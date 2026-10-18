#define MGLIB_IMPLICIT_TEX0_ASSIGNMENT // Texture() copies an mgCTexture by value, which needs sceGsTex0's implicit assignment.
#include "common.h"

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <functional>
#include <tuple>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "log/log.hpp"
#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"

// The GS evaluates UV at integer pixel positions and nearest-samples floor(u), so the texel one past the last
// covered pixel is never read. Sampling at pixel centres would read it and bleed the neighbouring glyph into the cell.
std::pair<float, float> mgPortSpriteTexelSpan(float p0, float p1, float u0, float u1) {
    const bool  flipped = p1 < p0;
    const float lo = flipped ? p1 : p0;
    const float hi = flipped ? p0 : p1;
    const float ulo = flipped ? u1 : u0;
    const float uhi = flipped ? u0 : u1;
    const float width = hi - lo;

    if (width <= 0.0f) {
        return {u0, u1};
    }

    const float first = std::ceil(lo);
    const float last = std::ceil(hi) - 1.0f;

    if (last < first) {
        return {u0, u1};
    }

    const float s = (uhi - ulo) / width;
    const float ua = ulo + (first - lo) * s;
    const float ub = ulo + (last - lo) * s;

    const float new_lo = s >= 0.0f ? std::floor(ua) : std::floor(ua) + 1.0f;
    const float new_hi = s >= 0.0f ? std::floor(ub) + 1.0f : std::floor(ub);

    return flipped ? std::pair<float, float>{new_hi, new_lo} : std::pair<float, float>{new_lo, new_hi};
}

namespace {

struct PrimRun {
    int                        prim_type = MG_PRIM_POINT;
    bool                       packed = false;
    bool                       inherited_texture = false; // Begin2 filled in the retained TEX0/TEX1
    uint8_t                    color[4] = {0xFF, 0xFF, 0xFF, 0xFF};
    uint8_t                    fog = 0xFF;
    float                      q = 1.0f;
    float                      s = 0.0f;
    float                      t = 0.0f;
    float                      u = 0.0f;
    float                      v = 0.0f;
    std::vector<gfx::Vertex2D> queue;
    std::vector<gfx::Vertex2D> batch;
    gfx::Primitive             batch_primitive = gfx::Primitive::Quads;
};

std::unordered_map<const mgCDrawPrim *, PrimRun> runs;
std::unordered_set<u_long>                       ignored_direct_registers;
mgPortPrimSink                                   prim_sink;

// Constructed on first use, so captured mesh owners are released before the renderer's
// static resource tables at process exit.
std::unordered_map<const void *, std::function<void()> > &PacketDraws() {
    static std::unordered_map<const void *, std::function<void()> > draws;
    return draws;
}

PrimRun *Find(const mgCDrawPrim *self) {
    const auto it = runs.find(self);
    return it == runs.end() ? nullptr : &it->second;
}

void DrawVertices(const mgCDrawPrim &self, gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices) {
    gfx::DrawState state = mgPortDrawState();
    state.blend = self.prim.ABE != 0;
    state.fog = self.prim.FGE != 0;

    gfx::TextureBinding binding;

    if (self.prim.TME != 0) {
        binding = mgPortBinding(self.texture.tex0_bits, self.texture.tex1_bits);
        if (binding.texture == gfx::kMainTarget && mgPortCurrentTarget() == gfx::kMainTarget && mgPortFrameOpen()) {
            binding.texture = mgPortSnapshotFrame();
            if (binding.texture == gfx::kNullTexture && !prim_sink) {
                return;
            }
        }
    }

    if (prim_sink) {
        prim_sink(primitive, vertices, binding, state);
    } else {
        mgPortDraw2D(primitive, vertices, binding, state);
    }
}

void FlushBatch(const mgCDrawPrim &self, PrimRun &run) {
    if (run.batch.empty()) {
        return;
    }

    DrawVertices(self, run.batch_primitive, run.batch);
    run.batch.clear();
}

void FlushPending(const mgCDrawPrim *self) {
    if (PrimRun *run = Find(self)) {
        FlushBatch(*self, *run);
    }
}

void Submit(const mgCDrawPrim &self, PrimRun &run, gfx::Primitive primitive, const gfx::Vertex2D *in,
            std::size_t count) {
    gfx::Vertex2D out[4]{};
    std::copy_n(in, count, out);

    if (self.prim.IIP == 0 && primitive != gfx::Primitive::Quads) {
        for (std::size_t i = 0; i < count; ++i) {
            std::copy_n(in[count - 1].color, 4, out[i].color);
        }
    }

    if (!run.batch.empty() && run.batch_primitive != primitive) {
        FlushBatch(self, run);
    }

    run.batch_primitive = primitive;
    run.batch.insert(run.batch.end(), out, out + count);
}

void AssembleSprite(const mgCDrawPrim &self, PrimRun &run, const gfx::Vertex2D &a, const gfx::Vertex2D &b) {
    auto corner = [&b](float x, float y, float u, float v) {
        gfx::Vertex2D out = b;
        out.x = x;
        out.y = y;
        out.u = u;
        out.v = v;
        return out;
    };

    float       au = a.u;
    float       bu = b.u;
    float       av = a.v;
    float       bv = b.v;
    const float target_scale = mgPortTextureScale(mgPortCurrentTarget());
    const auto  physical = MgTexturePhysicalExtent(self.texture.tex0_bits);
    const auto  logical = MgTextureLogicalExtent(self.texture.tex0_bits);
    const float source_scale = static_cast<float>(physical.width) / logical.width;

    if (self.prim.TME != 0 && self.prim.FST != 0 && mgPortFilter(self.texture.tex1_bits) == gfx::Filter::Linear) {
        // The GS evaluates UV at integer pixel positions. Vulkan's pixel centres
        // are half a physical destination pixel later: compensate by the sprite's UV slope,
        // including stretched and flipped sprites. Texture sampling itself still
        // applies the usual half-texel bilinear footprint; that is a separate shift.
        const float du = b.x != a.x ? 0.5f * (b.u - a.u) / ((b.x - a.x) * target_scale) : 0.0f;
        const float dv = b.y != a.y ? 0.5f * (b.v - a.v) / ((b.y - a.y) * target_scale) : 0.0f;
        au -= du;
        bu -= du;
        av -= dv;
        bv -= dv;
    } else if (self.prim.TME != 0 && self.prim.FST != 0 && mgPortFilter(self.texture.tex1_bits) == gfx::Filter::Nearest) {
        std::tie(au, bu) = mgPortSpriteTexelSpan(a.x * target_scale, b.x * target_scale,
                                                 a.u * source_scale, b.u * source_scale);
        std::tie(av, bv) = mgPortSpriteTexelSpan(a.y * target_scale, b.y * target_scale,
                                                 a.v * source_scale, b.v * source_scale);
        // The GPU can interpolate a hair under an exact texel boundary, where the GS takes the texel after it.
        au += kMgPortNearestTexelBias;
        bu += kMgPortNearestTexelBias;
        av += kMgPortNearestTexelBias;
        bv += kMgPortNearestTexelBias;
        au /= source_scale;
        bu /= source_scale;
        av /= source_scale;
        bv /= source_scale;
    }

    const gfx::Vertex2D quad[4] = {
        corner(a.x, a.y, au, av),
        corner(b.x, a.y, bu, av),
        corner(b.x, b.y, bu, bv),
        corner(a.x, b.y, au, bv),
    };
    Submit(self, run, gfx::Primitive::Quads, quad, 4);
}

void Assemble(const mgCDrawPrim &self, PrimRun &run, const gfx::Vertex2D &vertex) {
    std::vector<gfx::Vertex2D> &queue = run.queue;

    switch (run.prim_type) {
        case MG_PRIM_POINT: {
            gfx::Vertex2D quad[4] = {vertex, vertex, vertex, vertex};
            quad[1].x += 1.0f;
            quad[2].x += 1.0f;
            quad[2].y += 1.0f;
            quad[3].y += 1.0f;
            Submit(self, run, gfx::Primitive::Quads, quad, 4);
            break;
        }
        case MG_PRIM_LINE:
            queue.push_back(vertex);

            if (queue.size() == 2) {
                Submit(self, run, gfx::Primitive::Lines, queue.data(), 2);
                queue.clear();
            }

            break;
        case MG_PRIM_LINE_STRIP:
            queue.push_back(vertex);

            if (queue.size() == 2) {
                Submit(self, run, gfx::Primitive::Lines, queue.data(), 2);
                queue.erase(queue.begin());
            }

            break;
        case MG_PRIM_TRIANGLE:
            queue.push_back(vertex);

            if (queue.size() == 3) {
                Submit(self, run, gfx::Primitive::Triangles, queue.data(), 3);
                queue.clear();
            }

            break;
        case MG_PRIM_TRIANGLE_STRIP:
            queue.push_back(vertex);

            if (queue.size() == 3) {
                Submit(self, run, gfx::Primitive::Triangles, queue.data(), 3);
                queue.erase(queue.begin());
            }

            break;
        case MG_PRIM_TRIANGLE_FAN:
            queue.push_back(vertex);

            if (queue.size() == 3) {
                Submit(self, run, gfx::Primitive::Triangles, queue.data(), 3);
                queue.erase(queue.begin() + 1);
            }

            break;
        case MG_PRIM_SPRITE:
            queue.push_back(vertex);

            if (queue.size() == 2) {
                AssembleSprite(self, run, queue[0], queue[1]);
                queue.clear();
            }

            break;
    }
}

void Kick(const mgCDrawPrim &self, PrimRun *run, uint32_t gs_x, uint32_t gs_y, uint32_t gs_z) {
    // End2 is skipped for a disabled builder, so nothing would ever flush or clear what it batched.
    if (run == nullptr || self.disabled != 0) {
        return;
    }

    gfx::Vertex2D vertex{};
    vertex.x = mgPortLogicalX(static_cast<int>(gs_x & 0xFFFF));
    vertex.y = mgPortLogicalY(static_cast<int>(gs_y & 0xFFFF));
    vertex.z = mgPortDepth(gs_z);

    if (self.prim.TME != 0 && self.prim.FST == 0) {
        const auto width = static_cast<float>(1u << self.texture.tex0.TW);
        const auto height = static_cast<float>(1u << self.texture.tex0.TH);
        vertex.u = run->s / run->q * width;
        vertex.v = run->t / run->q * height;
    } else {
        vertex.u = run->u;
        vertex.v = run->v;
    }

    std::copy_n(run->color, 4, vertex.color);
    vertex.fog = run->fog;
    Assemble(self, *run, vertex);
}

} // namespace

PORT_OVERRIDE void mgCDrawPrim::Begin2() {
    // A disabled builder skips End2, so state left by an earlier primitive is dropped here.
    runs.insert_or_assign(this, PrimRun{});
    // End/Begin does not write a new colour. HUD bars inherit the preceding batch's tint.
    std::copy_n(mgPortGs().prim_color, 4, runs.at(this).color);
    // Likewise TEX0: the second weapon's synth gauge re-Initializes its builder and never binds a texture.
    // Limited to the status board, and to the builder that wrote it: elsewhere a builder whose Texture() got
    // null (the dungeon loading picture, the boot logo's fade-out) must not pick up an unrelated texture.
    if (mgPortGs().inherit_prim_texture && texture.tex0_bits == 0 && mgPortGs().prim_tex0 != 0 &&
        mgPortGs().prim_tex_owner == this) {
        texture.tex0_bits = mgPortGs().prim_tex0;
        texture.tex1_bits = mgPortGs().prim_tex1;
        runs.at(this).inherited_texture = true;
    }

    disabled = 1;

    if (memory == nullptr || vif_packet == nullptr || draw_manager == nullptr) {
        return;
    }

    mgRENDER_INFO *render_info = draw_manager->render_info;

    if (render_info == nullptr) {
        return;
    }

    disabled = 0;
    sceGsZbuf zbuf = render_info->draw_env[0].zbuf;
    draw_env.zbuf = zbuf;
    draw_env.SetZBuf(z_mask);

    mgPortGs().test = draw_env.test.value;
    mgPortGs().zbuf = draw_env.zbuf.value;
    mgPortGs().alpha = draw_env.alpha.value;
}

PORT_OVERRIDE void mgCDrawPrim::BeginDma() {
    // A PRIM write restarts primitive assembly on the GS.
    PrimRun &run = runs[this];
    run.prim_type = static_cast<int>(prim.PRIM);
    run.queue.clear();
}

PORT_OVERRIDE void mgCDrawPrim::EndDma() {
    FlushPending(this);
}

PORT_OVERRIDE void mgCDrawPrim::BeginPrim2(int type) {
    packed = 0;
    prim.PRIM = type;
    q = 1.0f;

    PrimRun &run = runs[this];
    run.packed = false;
    run.q = 1.0f;

    BeginDma();
}

PORT_OVERRIDE void mgCDrawPrim::BeginPrim2(int prim_type, u_int /*data_a*/, u_int /*data_b*/, int unit_count) {
    packed = 1;
    prim.PRIM = prim_type;
    q = 1.0f;
    nreg = unit_count;

    PrimRun &run = runs[this];
    run.packed = true;
    run.prim_type = prim_type;
    run.q = 1.0f;
    run.queue.clear();
}

PORT_OVERRIDE void mgCDrawPrim::EndPrim2() {
    FlushPending(this);
}

PORT_OVERRIDE void mgCDrawPrim::End2() {
    FlushPending(this);
    runs.erase(this);
}

PORT_OVERRIDE void mgCDrawPrim::Data(int *data) {
    // write is null on PC unless a caller points it at a buffer, so retail's quadword copy is guarded here.
    if (write != nullptr) {
        std::memcpy(write, data, sizeof(u_long128));
        write++;
    }

    const PrimRun *run = Find(this);

    if (run == nullptr || !run->packed) {
        return;
    }

    static bool reported = false;

    if (!reported) {
        reported = true;
        CT_LOG_WARN(Gfx, "mg_drawprim: packed GIF data ignored; its caller needs a port override");
    }
}

PORT_OVERRIDE u_long128 *mgCDrawPrim::DirectData(int count) {
    thread_local std::vector<u_long128> scratch(256);

    if (count > 0 && static_cast<std::size_t>(count) > scratch.size()) {
        scratch.resize(static_cast<std::size_t>(count));
    }

    return scratch.data();
}

PORT_OVERRIDE void mgCDrawPrim::Vertex4(int x, int y, int z) {
    int ox = 0;
    int oy = 0;
    GetOffset(&ox, &oy);
    Kick(*this, Find(this), static_cast<uint32_t>(x + ox), static_cast<uint32_t>(y + oy), static_cast<uint32_t>(z));
}

PORT_OVERRIDE void mgCDrawPrim::Color(int r, int g, int b, int a) {
    PrimRun *run = Find(this);

    if (run == nullptr) {
        return;
    }

    run->color[0] = static_cast<uint8_t>(r & 0xFF);
    run->color[1] = static_cast<uint8_t>(g & 0xFF);
    run->color[2] = static_cast<uint8_t>(b & 0xFF);
    run->color[3] = static_cast<uint8_t>(a & 0xFF);
    std::copy_n(run->color, 4, mgPortGs().prim_color);
}

PORT_OVERRIDE void mgCDrawPrim::TextureCrd4(int u, int v) {
    PrimRun *run = Find(this);

    if (run == nullptr) {
        return;
    }

    run->u = static_cast<float>(u) / 16.0f;
    run->v = static_cast<float>(v) / 16.0f;
}

PORT_OVERRIDE void mgCDrawPrim::Direct(unsigned long long reg, unsigned long long data) {
    // The pending batch was built under the state that is about to change.
    FlushPending(this);

    mgPortGsState &gs = mgPortGs();

    switch (reg) {
        case SCE_GS_TEXA:
            gs.texa = data;
            break;
        case SCE_GS_ALPHA_1:
            gs.alpha = data;
            break;
        case SCE_GS_TEST_1:
            gs.test = data;
            break;
        case SCE_GS_ZBUF_1:
            gs.zbuf = data;
            break;
        case SCE_GS_CLAMP_1:
            gs.clamp = data;
            break;
        case SCE_GS_TEX1_1:
            gs.tex1 = data;
            break;
        case SCE_GS_FOGCOL:
            gs.fog_color[0] = static_cast<uint8_t>(data & 0xFF);
            gs.fog_color[1] = static_cast<uint8_t>((data >> 8) & 0xFF);
            gs.fog_color[2] = static_cast<uint8_t>((data >> 16) & 0xFF);
            break;
        case SCE_GS_SCISSOR_1:
            gs.scissor[0] = static_cast<int>(data & 0x7FF);
            gs.scissor[1] = static_cast<int>((data >> 32) & 0x7FF);
            gs.scissor[2] = static_cast<int>((data >> 16) & 0x7FF);
            gs.scissor[3] = static_cast<int>((data >> 48) & 0x7FF);
            break;
        case SCE_GS_TEXFLUSH:
        case SCE_GS_PRMODECONT:
            break;
        default:
            if (ignored_direct_registers.insert(reg).second) {
                CT_LOG_WARN(Gfx, "mg_drawprim: Direct register 0x{:x} ignored", static_cast<unsigned>(reg));
            }

            break;
    }
}

PORT_OVERRIDE void mgCDrawPrim::Texture(mgCTexture *source) {
    FlushPending(this);
    source = MgTextureDrawVariant(source);

    if (source == nullptr) {
        // A local builder at a reused stack address can look like the owner. One that asks for a texture
        // which is not loaded (the boot logo's fade-out, the dungeon loading picture) keeps drawing without one.
        if (PrimRun *run = Find(this); run != nullptr && run->inherited_texture) {
            texture.tex0_bits = 0;
            texture.tex1_bits = 0;
            run->inherited_texture = false;
        }
        return;
    }

    texture = *source;
    texture.Bilinear(bilinear);
    mgPortGs().prim_tex0 = texture.tex0_bits;
    mgPortGs().prim_tex1 = texture.tex1_bits;
    mgPortGs().prim_tex_owner = this;
}

PORT_OVERRIDE int mgCDrawManager::ReloadTexture(int group, sceVif1Packet *vif_packet) {
    mgCTextureManager *manager = texture_manager;

    if (group < 0 || group >= manager->block_max) {
        return 0;
    }

    const int index = draw_order != nullptr ? order_index[group] : group;

    if (index < 0) {
        return 0;
    }

    manager->ReloadTexture(group, vif_packet);
    return 1;
}

PORT_OVERRIDE int mgCDrawManager::Draw(int group, sceVif1Packet * /*unused*/) {
    if (group < 0 || group >= texture_manager->block_max) {
        return 0;
    }

    if (draw_order != nullptr) {
        group = order_index[group];
    }

    if (group < 0) {
        return 0;
    }

    mgSORT_PACKET **list = packet_list[group];

    if (list == nullptr) {
        return 1;
    }

    u_long128 *common = nullptr;

    // Packets are called in the reverse of their registration order.
    for (int i = packet_num[group] - 1; i >= 0; --i) {
        const mgSORT_PACKET *entry = list[i];

        if (entry == nullptr) {
            continue;
        }

        mgSendVuProg(nullptr, entry->vu_program);

        if (common != entry->common) {
            mgPortPacketDraw(entry->common);
            common = entry->common;
        }

        mgPortPacketDraw(entry->packet);
    }

    return 1;
}

void mgPortSetPrimSink(mgPortPrimSink sink) {
    prim_sink = std::move(sink);
}

void mgPortSetPacketDraw(const void *packet, std::function<void()> draw) {
    if (packet == nullptr) {
        return;
    }

    PacketDraws()[packet] = std::move(draw);
}

void mgPortClearPacketDraw(const void *packet) {
    PacketDraws().erase(packet);
}

void mgPortClearPacketDraws() {
    PacketDraws().clear();
}

bool mgPortPacketDraw(const void *packet) {
    if (packet == nullptr) {
        return false;
    }

    const auto &draws = PacketDraws();
    const auto  it = draws.find(packet);

    if (it == draws.end()) {
        return false;
    }

    // Copied because the draw may clear or replace its own entry while it runs.
    const std::function<void()> draw = it->second;
    draw();
    return true;
}

void mgPortPrimFlush(const mgCDrawPrim &prim) {
    FlushPending(&prim);
}

void mgPortPrimSubmit(mgCDrawPrim &prim, gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices) {
    FlushPending(&prim);

    // A disabled builder never flushes what it would batch, so it draws nothing here either.
    if (prim.disabled != 0 || vertices.empty()) {
        return;
    }

    const std::size_t group = primitive == gfx::Primitive::Lines       ? 2
                              : primitive == gfx::Primitive::Triangles ? 3
                                                                       : 0;

    if (prim.prim.IIP != 0 || group == 0) {
        DrawVertices(prim, primitive, vertices);
        return;
    }

    std::vector<gfx::Vertex2D> flat(vertices.begin(), vertices.end());

    for (std::size_t first = 0; first + group <= flat.size(); first += group) {
        const std::size_t last = first + group - 1;

        for (std::size_t i = first; i < last; ++i) {
            std::copy_n(flat[last].color, 4, flat[i].color);
        }
    }

    DrawVertices(prim, primitive, flat);
}

void mgPortPrimSubmitTexture(mgCDrawPrim &prim, std::span<const gfx::Vertex2D> quads,
                             const gfx::TextureBinding &texture) {
    FlushPending(&prim);
    if (prim.disabled != 0 || quads.empty()) {
        return;
    }
    gfx::DrawState state = mgPortDrawState();
    state.blend = prim.prim.ABE != 0;
    state.fog = prim.prim.FGE != 0;
    if (prim_sink) {
        prim_sink(gfx::Primitive::Quads, quads, texture, state);
    } else {
        mgPortDraw2D(gfx::Primitive::Quads, quads, texture, state);
    }
}

void mgPortStripTriangles(std::span<const gfx::Vertex2D> strip, std::vector<gfx::Vertex2D> &out) {
    for (std::size_t i = 2; i < strip.size(); ++i) {
        out.push_back(strip[i - 2]);
        out.push_back(strip[i - 1]);
        out.push_back(strip[i]);
    }
}

void mgPortPrimColor(const mgCDrawPrim &prim, uint8_t rgba[4]) {
    static constexpr uint8_t kWhite[4] = {0xFF, 0xFF, 0xFF, 0xFF};
    const PrimRun           *run = Find(&prim);
    std::copy_n(run != nullptr ? run->color : kWhite, 4, rgba);
}

gfx::Vertex2D mgPortPrimVertex(const mgCDrawPrim &prim, float gs_x, float gs_y, float gs_z, float u, float v,
                               const uint8_t rgba[4], uint8_t fog) {
    int offset_x = 0;
    int offset_y = 0;
    // GetOffset only reads the builder; retail declares it non-const.
    const_cast<mgCDrawPrim &>(prim).GetOffset(&offset_x, &offset_y);

    const float origin_x = mgPortLogicalX(0);
    const float origin_y = mgPortLogicalY(0);
    // The slope comes from the seam, which is affine, rather than from a fixed pixel-to-unit ratio.
    const float scale_x = mgPortLogicalX(16) - origin_x;
    const float scale_y = mgPortLogicalY(16) - origin_y;

    gfx::Vertex2D vertex{};
    vertex.x = origin_x + (gs_x + static_cast<float>(offset_x) / 16.0f) * scale_x;
    vertex.y = origin_y + (gs_y + static_cast<float>(offset_y) / 16.0f) * scale_y;
    // 4294967040 is the largest float below 2^32, so the cast to uint32_t is defined for every input.
    vertex.z = mgPortDepth(static_cast<uint32_t>(std::clamp(gs_z, 0.0f, 4294967040.0f)));
    vertex.u = u;
    vertex.v = v;
    std::copy_n(rgba, 4, vertex.color);
    vertex.fog = fog;
    return vertex;
}

// Stride fixes: retail sizes the pointer tables at four bytes an entry (n / 4 + 1 quadwords) and clears them as ints.
namespace {

template <typename T>
T *AllocTable(mgCMemory *memory, int count) {
    return reinterpret_cast<T *>(memory->Alloc(static_cast<int>((count * sizeof(T) + 15) / 16) + 1));
}

} // namespace

PORT_OVERRIDE void mgCDrawManager::BeginDraw(mgCMemory *new_memory, int *id_list) {
    memory = new_memory != nullptr ? new_memory : packet_memory;
    group_num = texture_manager->block_max;
    group_max = group_num;
    order_index = nullptr;
    draw_order = nullptr;

    if (id_list != nullptr) {
        order_index = AllocTable<int>(memory, group_max);

        for (int i = 0; i < group_max; i++) {
            order_index[i] = -1;
        }

        int used_count = 0;

        while (id_list[used_count] >= 0) {
            used_count++;
        }

        draw_order = AllocTable<int>(memory, used_count + 1);

        for (int i = 0; i < used_count; i++) {
            draw_order[i] = id_list[i];
            order_index[draw_order[i]] = i;
        }

        draw_order[used_count] = -1;
        group_num = used_count;
    }

    const int tables = group_num + 1;
    packet_list = AllocTable<mgSORT_PACKET **>(memory, tables);
    unk_14 = AllocTable<int>(memory, tables);
    packet_num = AllocTable<int>(memory, tables);
    sort_table = AllocTable<mgSORT_PACKET *>(memory, sort_num);
    ClearTable();
}

PORT_OVERRIDE void mgCDrawManager::ClearTable() {
    for (int i = 0; i < group_num; i++) {
        packet_list[i] = nullptr;
        unk_14[i] = 0;
        packet_num[i] = 0;
    }

    for (int i = 0; i < sort_num; i++) {
        sort_table[i] = nullptr;
    }
}

PORT_OVERRIDE void mgCDrawManager::PreEndDraw() {
    packet_cursor = AllocTable<mgSORT_PACKET **>(memory, group_num);

    for (int i = 0; i < group_num; i++) {
        if (packet_num[i] > 0) {
            packet_list[i] = AllocTable<mgSORT_PACKET *>(memory, packet_num[i]);
            packet_cursor[i] = packet_list[i];
        }
    }

    // Only the first sort bucket is used.
    for (mgSORT_PACKET *item = sort_table[0]; item != nullptr; item = item->next) {
        *packet_cursor[item->group]++ = item;
    }
}
