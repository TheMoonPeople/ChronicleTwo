#include "common.h"

#include <algorithm>
#include <cmath>
#include <cstring>
#include <optional>
#include <unordered_map>
#include <utility>
#include <vector>

#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_math.hpp"
#include "mg_sprite.hpp"
#include "mg_sprite_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "vu1/sprite3d_geom.hpp"

namespace {

namespace vu1 = dc::vu1;

// The values Vu_prog_3dsp reads from the render-info packet (docs/vu1/prog_3dsp.md sections 3, 5 and 8).
struct BillboardSetup {
    vu1::Mat4 local_screen{};
    vu1::Vec4 vs0{};
    vu1::Vec4 vs1{};
    vu1::Fog  fog{};
    vu1::Vec4 guard_min{};
    vu1::Vec4 guard_max{};
    bool      fog_enabled = false;
    uint8_t   fog_colour[3] = {};
};

struct BillboardBatch {
    bool                             rotated = false;
    bool                             has_env = false;
    mgCDrawEnv                       env;
    bool                             fog_zero = false;
    bool                             has_texture = false;
    uint64_t                         tex0 = 0;
    uint64_t                         tex1 = 0;
    std::vector<vu1::Sprite3dRecord> billboards;
    // Set by mgPortTag3DSpriteBatch: the batch is drawn under this tag rather than the one current at the draw.
    std::optional<gfx::Interp2D> interpolation;
};

struct BillboardPacket {
    // Stable, non-null address that retail's `packet != NULL` built test reads; nothing dereferences it.
    u_long128                   anchor{};
    BillboardSetup              setup;
    std::vector<BillboardBatch> batches;
    bool                        batch_open = false;
    bool                        has_env = false;
    mgCDrawEnv                  env;
    // FOGCOL is written only by additive and subtractive environments, so once one is set it holds for the rest of the packet.
    bool     fog_zero = false;
    bool     has_texture = false;
    uint64_t tex0 = 0;
    uint64_t tex1 = 0;
};

std::unordered_map<const mgC3DSprite *, BillboardPacket> packets;
mgPortPrimSink                                           sprite_sink;

BillboardPacket &PacketOf(const mgC3DSprite *sprite) {
    return packets[sprite];
}

vu1::Mat4 LoadSpriteMatrix(const float (*m)[4]) {
    vu1::Mat4 out{};
    std::memcpy(&out, m, sizeof out);
    return out;
}

vu1::Vec4 ScaleSpriteRow(const float *row, float scale) {
    return {.x = row[0] * scale, .y = row[1] * scale, .z = row[2] * scale, .w = row[3]};
}

// Affine GS-pixel to logical and depth maps, read from the seam once per batch.
struct SpriteViewport {
    float x0, xs;
    float y0, ys;
    float z0, zs;
};

SpriteViewport SpriteViewportFromSeam() {
    const float x0 = mgPortLogicalX(0);
    const float y0 = mgPortLogicalY(0);
    // mgPortDepth clamps to [0, 1], so the slope is sampled at 1 GS Z unit where the clamp is inactive.
    const float z0 = mgPortDepth(0);
    return {.x0 = x0, .xs = mgPortLogicalX(16) - x0, .y0 = y0, .ys = mgPortLogicalY(16) - y0, .z0 = z0, .zs = mgPortDepth(1) - z0};
}

uint8_t ColourByte(float c) {
    return static_cast<uint8_t>(std::clamp(c, 0.0f, 255.0f));
}

gfx::Vertex2D SpriteVertex(const vu1::Sprite3dVertexF &s, const float *rgba, const SpriteViewport &vp) {
    gfx::Vertex2D out{};
    out.x = vp.x0 + s.x * vp.xs;
    out.y = vp.y0 + s.y * vp.ys;
    out.z = std::clamp(vp.z0 + s.z * vp.zs, 0.0f, 1.0f);
    out.u = s.u;
    out.v = s.v;

    for (int c = 0; c < 4; ++c) {
        out.color[c] = ColourByte(rgba[c]);
    }

    out.fog = static_cast<uint8_t>(std::lround(s.fog * 255.0f));
    return out;
}

// Submitted as depth-tested 2D at the tick's screen corners, so a billboard's own motion is not interpolated
// (docs/PC.md "Ticks and display frames") unless mgPortTag3DSpriteBatch gave its batch a keyed tag.
void SubmitSpriteBatch(const BillboardBatch &batch, const BillboardSetup &setup) {
    const vu1::Sprite3dParams  params{.ls = setup.local_screen, .vs0 = setup.vs0, .vs1 = setup.vs1, .fog = setup.fog, .guard_min = setup.guard_min, .guard_max = setup.guard_max};
    const int                  geom_mode = batch.rotated ? 1 : 0;
    constexpr int              kStrip[6] = {0, 1, 2, 1, 2, 3};
    const SpriteViewport       viewport = SpriteViewportFromSeam();
    std::vector<gfx::Vertex2D> vertices;

    for (const vu1::Sprite3dRecord &billboard : batch.billboards) {
        const vu1::Sprite3dQuadF quad = vu1::Sprite3dExpandNative(params, billboard, geom_mode);

        if (!quad.drawn) {
            continue;
        }

        if (batch.rotated) {
            for (const int index : kStrip) {
                vertices.push_back(SpriteVertex(quad.v[index], quad.rgba, viewport));
            }
        } else {
            const vu1::Sprite3dVertexF &lo = quad.v[0];
            const vu1::Sprite3dVertexF &hi = quad.v[1];
            const vu1::Sprite3dVertexF  corners[4] = {
                {.x = lo.x, .y = lo.y, .z = lo.z, .u = lo.u, .v = lo.v, .fog = lo.fog},
                {.x = hi.x, .y = lo.y, .z = lo.z, .u = hi.u, .v = lo.v, .fog = lo.fog},
                {.x = hi.x, .y = hi.y, .z = lo.z, .u = hi.u, .v = hi.v, .fog = lo.fog},
                {.x = lo.x, .y = hi.y, .z = lo.z, .u = lo.u, .v = hi.v, .fog = lo.fog},
            };
            for (const vu1::Sprite3dVertexF &corner : corners) {
                vertices.push_back(SpriteVertex(corner, quad.rgba, viewport));
            }
        }
    }

    if (vertices.empty()) {
        return;
    }

    gfx::DrawState state = mgPortDrawState();

    if (batch.has_env) {
        mgPortApplyDrawEnv(state, batch.env);
    }

    // The packet sets PRMODECONT, so ABE, TME and FGE come from its PRMODE write, not from the GIF PRIM.
    state.blend = true;
    state.fog = setup.fog_enabled;

    for (int c = 0; c < 3; ++c) {
        state.fog_color[c] = batch.fog_zero ? 0 : setup.fog_colour[c];
    }

    const gfx::TextureBinding binding =
        batch.has_texture ? mgPortBinding(batch.tex0, batch.tex1) : gfx::TextureBinding{};
    const gfx::Primitive primitive = batch.rotated ? gfx::Primitive::Triangles : gfx::Primitive::Quads;

    std::optional<gfx::Interp2DScope> tag;

    if (batch.interpolation) {
        tag.emplace(*batch.interpolation);
    }

    if (sprite_sink) {
        sprite_sink(primitive, vertices, binding, state);
    } else {
        mgPortDraw2D(primitive, vertices, binding, state);
    }
}

} // namespace

PORT_OVERRIDE void mgC3DSprite::BeginCreatePacket(int mode, mgCDrawManager *manager) {
    if (manager == nullptr) {
        manager = &mgDrawManager;
    }

    memory = manager->data_memory;
    BillboardPacket &state = PacketOf(this);
    state.batches.clear();
    state.batch_open = false;
    state.has_env = false;
    state.fog_zero = false;
    state.has_texture = false;
    packet = &state.anchor;
    packet_start = packet;
    packet_cur = packet;
    this->mode = mode;
    prog_started = 0;
    sprite_num = 0;
}

PORT_OVERRIDE void mgC3DSprite::CPSetDrawEnv(mgCDrawEnv *draw_env) {
    if (draw_env == nullptr) {
        return;
    }

    BillboardPacket &state = PacketOf(this);
    state.env = *draw_env;
    state.has_env = true;
    const int macro = draw_env->GetAlphaMacroID();

    if (macro == MG_ALPHA_MACRO_ADD || macro == MG_ALPHA_MACRO_SUB) {
        state.fog_zero = true;
    }
}

PORT_OVERRIDE void mgC3DSprite::CPSetTexture(mgCTexture *texture) {
    if (texture == nullptr) {
        return;
    }

    BillboardPacket &state = PacketOf(this);
    state.has_texture = true;
    state.tex0 = texture->tex0_bits;
    state.tex1 = texture->tex1_bits;
}

PORT_OVERRIDE void mgC3DSprite::BeginCPSprite() {
    BillboardPacket &state = PacketOf(this);
    BillboardBatch   batch;
    batch.rotated = mode == MG_3DSPRITE_MODE_ROTATE;
    batch.has_env = state.has_env;
    batch.env = state.env;
    batch.fog_zero = state.fog_zero;
    batch.has_texture = state.has_texture;
    batch.tex0 = state.tex0;
    batch.tex1 = state.tex1;
    state.batches.push_back(std::move(batch));
    state.batch_open = true;
    sprite_num = 0;
}

PORT_OVERRIDE void mgC3DSprite::CPSetSprite(float *first, float *second, float *third, float *fourth,
                                            float *fifth) {
    BillboardPacket &state = PacketOf(this);

    if (!state.batch_open) {
        return;
    }

    vu1::Sprite3dRecord record{};
    std::memcpy(&record.pos, first, sizeof record.pos);

    if (mode == MG_3DSPRITE_MODE_ROTATE) {
        record.size = {.x = second[0], .y = second[1], .z = std::sin(second[2]), .w = std::cos(second[2])};
    } else {
        std::memcpy(&record.size, second, sizeof record.size);
    }

    std::memcpy(&record.colour, third, sizeof record.colour);
    std::memcpy(&record.uv0, fourth, sizeof record.uv0);
    std::memcpy(&record.uv1, fifth, sizeof record.uv1);
    state.batches.back().billboards.push_back(record);
    sprite_num += 1;
}

PORT_OVERRIDE void mgC3DSprite::EndCPSprite() {
    PacketOf(this).batch_open = false;
}

PORT_OVERRIDE void mgC3DSprite::EndCreatePacket() {
    PacketOf(this).batch_open = false;
}

// Retail's packet is DMA-sent and its size returned; here the setup is only kept for the draw that follows.
PORT_OVERRIDE int mgC3DSprite::CreateRenderInfoPacket(u_int * /*dest*/, float (*matrix)[4], mgRENDER_INFO *render_info) {
    BillboardSetup &setup = PacketOf(this).setup;
    const vu1::Mat4 world_screen = LoadSpriteMatrix(render_info->world_screen);
    const vu1::Mat4 local = LoadSpriteMatrix(matrix);

    for (int k = 0; k < 4; ++k) {
        setup.local_screen.q[k] = vu1::Mul(world_screen, local.q[k]);
    }

    setup.vs0 = ScaleSpriteRow(render_info->view_screen[0], mgDistVector(matrix[0]));
    setup.vs1 = ScaleSpriteRow(render_info->view_screen[1], mgDistVector(matrix[1]));
    setup.fog = vu1::Fog{.offset = render_info->fog.offset, .near_value = render_info->fog.near_value, .far_value = render_info->fog.far_value, .scale = render_info->fog.scale};

    // Scissor is cleared on this path (below), so the cull bounds are the full GS range, not the guard area.
    setup.guard_min = {.x = 1.0f, .y = 1.0f, .z = 0.0f, .w = render_info->guard_min[3]};
    setup.guard_max = {.x = 4095.0f, .y = 4095.0f, .z = 0.0f, .w = render_info->guard_max[3]};
    render_info->scissor = 0;

    const mgCFrameAttr *attr = render_info->attr;
    setup.fog_enabled = attr != nullptr && attr->fog != 0 && render_info->fog_enable != 0;

    const bool black_fog = attr != nullptr && attr->fog > MG_FOG_SCENE;
    setup.fog_colour[0] = black_fog ? 0 : render_info->fog.r;
    setup.fog_colour[1] = black_fog ? 0 : render_info->fog.g;
    setup.fog_colour[2] = black_fog ? 0 : render_info->fog.b;
    return 0;
}

// No DMA chain on PC: tag is left untouched and the billboards are submitted before returning.
PORT_OVERRIDE int mgC3DSprite::Draw(u_int * /*tag*/, float (*matrix)[4], mgCDrawManager *manager) {
    if (manager == nullptr) {
        manager = &mgDrawManager;
    }

    mgRENDER_INFO *render_info = manager->render_info;
    texture_manager = manager->texture_manager;

    if (packet == nullptr || render_info == nullptr) {
        return 0;
    }

    CreateRenderInfoPacket(nullptr, matrix, render_info);
    const BillboardPacket &state = PacketOf(this);

    for (const BillboardBatch &batch : state.batches) {
        SubmitSpriteBatch(batch, state.setup);
    }

    return 0;
}

void mgPortSet3DSpriteSink(mgPortPrimSink sink) {
    sprite_sink = std::move(sink);
}

void mgPortTag3DSpriteBatch(mgC3DSprite *sprite, const gfx::Interp2D &interpolation) {
    BillboardPacket &state = PacketOf(sprite);

    if (state.batch_open && !state.batches.empty()) {
        state.batches.back().interpolation = interpolation;
    }
}

// No DMA chain on PC: returning 0 leaves the caller's VIF cursor where it was, and the draw is already submitted.
PORT_OVERRIDE int mgCSprite::Draw(u_int * /*tag*/, float (* /*matrix*/)[4], mgCDrawManager *manager) {
    if (manager == nullptr) {
        manager = &mgDrawManager;
    }

    texture_manager = manager->texture_manager;
    CreatePacket(manager);
    return 0;
}

// Retail's CreateRenderInfoPacket writes this environment into a DMA packet, so it is derived here instead.
// Returns 0: retail returns the packet's address, which has no PC equivalent and no caller reads.
PORT_OVERRIDE uptr mgCSprite::CreatePacket(mgCDrawManager *manager) {
    mgRENDER_INFO *render_info = manager->render_info;

    if (render_info == nullptr) {
        return 0;
    }

    mgCDrawEnv env;

    if (draw_env != nullptr) {
        env = *draw_env;
    } else {
        SetDrawEnv(&env, &attr, &render_info->draw_env[0]);
    }

    // A depth below 1.0 is not a view distance; the sprite is drawn at depth zero.
    int screen_z = 0;

    if (!(depth < 1.0f)) {
        float position[4] = {0.0f, 0.0f, 0.0f, 1.0f};
        int   projected[4];
        position[2] = depth;

        if (mgTransViewPrim(projected, position) != 0) {
            screen_z = projected[2];
        }
    }

    mgCDrawPrim prim;
    prim.Initialize(nullptr, nullptr);
    prim.draw_manager = manager;
    prim.draw_env = env;
    // Begin2 rebuilds the depth buffer from the render info and applies z_mask, so the mask has to carry the environment's write setting.
    prim.ZMask(env.zbuf.bits.zmsk != 0 ? MG_Z_MASK_MASKED : MG_Z_MASK_WRITE);
    prim.AlphaBlendEnable(1);
    prim.TextureMapEnable(texture != nullptr);

    if (texture != nullptr) {
        prim.Texture(texture);
    }

    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(color.bytes.red, color.bytes.green, color.bytes.blue, color.bytes.alpha);
    // Corners are passed without the screen offset: Coord(0) adds it in Vertex4, as retail adds it in CreatePacket.
    prim.TextureCrd4(uv.left, uv.top);
    prim.Vertex4(screen.left, screen.top, screen_z);
    prim.TextureCrd4(uv.right, uv.bottom);
    prim.Vertex4(screen.right, screen.bottom, screen_z);
    prim.End();
    return 0;
}
