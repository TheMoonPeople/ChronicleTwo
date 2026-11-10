#define MGLIB_IMPLICIT_TEX0_ASSIGNMENT
#include "common.h"

#include <algorithm>
#include <climits>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <functional>
#include <limits>
#include <optional>
#include <stdexcept>
#include <tuple>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "log/log.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "render/primitive_submission.hpp"
#include "render/renderer.hpp"
#include "render/texture_runtime.hpp"
#include "vu0_lanes.hpp"

mgCDrawPrim::mgCDrawPrim() {
    memory = nullptr;
    vif_packet = nullptr;
    draw_manager = nullptr;
    disabled = 1;
    q = 1.0f;
    prim = {};
    prim.FST = 1;
    bilinear = 1;
    z_mask = MG_Z_MASK_WRITE;
    coord = 0;
    offset_x = 0;
    offset_y = 0;
}

void mgCDrawPrim::Initialize(mgCMemory *memory, sceVif1Packet *vif_packet) {
    if (vif_packet == nullptr) {
        vif_packet = mgVif1Packet;
    }

    if (memory == nullptr) {
        memory = mgGetDataBuffer();
    }

    this->memory = memory;
    this->vif_packet = vif_packet;
    detached = 0;

    if (draw_manager == nullptr) {
        draw_manager = &mgDrawManager;
    }

    disabled = 1;
    texture.Initialize();
    draw_env.Initialize(0);
}

void mgCDrawPrim::Begin(int prim_type) {
    this->disabled = 1;

    if (this->memory == nullptr || this->vif_packet == nullptr || this->draw_manager == nullptr) {
        return;
    }

    if (this->draw_manager->render_info == nullptr) {
        return;
    }

    this->disabled = 0;
    this->prim.PRIM = prim_type;
    this->q = 1.0f;
    Begin2();
    BeginDma();
}

void mgCDrawPrim::Flush() {
    EndDma();
    BeginDma();
}

void mgCDrawPrim::End() {
    if (disabled == 0) {
        EndDma();
        End2();
    }
}

void mgCDrawPrim::Vertex(int x, int y, int z) {
    Vertex4(x << 4, y << 4, z);
}

void mgCDrawPrim::Vertex(float x, float y, float z) {
    float pos[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    pos[0] = x;
    pos[1] = y;
    pos[2] = z;
    Vertex(pos);
}

void mgCDrawPrim::Vertex4(int *pos) {
    Vertex4(pos[0], pos[1], pos[2]);
}

void mgCDrawPrim::TextureCrd(int u, int v) {
    TextureCrd4(u << 4, v << 4);
}

/**
 *
 * Texture state of a drawing primitive, copied from a texture as plain data.
 *
 */
struct mgCTextureFields {
    short       block;                       /**< Texture block the texture belongs to. */
    short       width;                       /**< Width of the base level, in pixels. */
    short       height;                      /**< Height of the base level, in pixels. */
    short       bpp;                         /**< Bits per pixel. */
    char        name[32];                    /**< Name the texture is registered under. */
    int         vram_size;                   /**< GS blocks of VRAM reserved for the pixels. */
    int         image_blocks;                /**< GS blocks the pixels of every mip level occupy. */
    int         clut_size;                   /**< GS blocks the palette occupies. */
    u_long      tex0_bits;                   /**< Packed GS TEX0 register value. */
    u_long      tex1_bits;                   /**< Packed GS TEX1 register value. */
    u_long      clamp_bits;                  /**< Packed GS CLAMP register value. */
    u_long128  *image[MG_TEXTURE_LEVEL_MAX]; /**< Pixels of each mip level in main memory. */
    u_long128  *clut;                        /**< Palette in main memory. */
    int         swizzled;                    /**< Non-zero when the 8-bit pixels are stored in 32-bit page order. */
    mgCTexture *next;                        /**< Following texture of the same texture block. */
};

/**
 *
 * Exposes the texture cache of a drawing primitive.
 *
 */
struct mgCDrawPrimTexture {
    u_char           unk_0[0x58];
    mgCTextureFields texture; /**< Texture state copied for this primitive. */
};

void mgCDrawPrim::AlphaBlendEnable(int enable) {
    prim.ABE = enable;
}

void mgCDrawPrim::AlphaBlend(int mode) {
    draw_env.SetAlpha(mode);
}

void mgCDrawPrim::AlphaTestEnable(int enable) {
    draw_env.test.bits.ate = enable;
}

void mgCDrawPrim::AlphaTest(int method, int ref) {
    draw_env.test.bits.atst = method;
    draw_env.test.bits.aref = ref;
}

void mgCDrawPrim::DAlphaTest(int enable, int mode) {
    draw_env.test.bits.date = enable;
    draw_env.test.bits.datm = mode;
}

void mgCDrawPrim::DepthTestEnable(int enable) {
    sceGsTest *test = &draw_env.test;

    if (enable == 0) {
        test->bits.zte = 1;
        test->bits.ztst = 1;
    } else {
        DepthTest(MG_DEPTH_TEST_GEQUAL);
    }
}

void mgCDrawPrim::DepthTest(int mode) {
    sceGsTest *test = &draw_env.test;
    test->bits.zte = 1;

    switch (mode) {
        case -1:
            test->bits.ztst = 1;
            break;
        case 1:
            test->bits.ztst = 2;
            break;
        case 2:
            test->bits.ztst = 3;
            break;
    }
}

void mgCDrawPrim::ZMask(int mask) {
    z_mask = mask;
}

void mgCDrawPrim::TextureMapEnable(int enable) {
    prim.TME = enable;
}

void mgCDrawPrim::Bilinear(int enable) {
    bilinear = enable;
}

void mgCDrawPrim::Shading(int enable) {
    prim.IIP = enable;
}

void mgCDrawPrim::AntiAliasing(int enable) {
    prim.AA1 = enable;
}

void mgCDrawPrim::FogEnable(int enable) {
    prim.FGE = enable;
}

void mgCDrawPrim::Coord(int coord) {
    this->coord = coord;
}

void mgCDrawPrim::GetOffset(int *x, int *y) {
    *y = 0;
    *x = 0;

    if (coord == 0) {
        *x = mgScreenOffx << 4;
        *y = mgScreenOffy << 4;
    }

    *x += offset_x;
    *y += offset_y;
}

mgCDrawManager::mgCDrawManager() {
    unk_68 = 0x40;
    unk_6c = 0;
    unk_70 = 0;
}

void mgCDrawManager::SetSortTable(int num) {
    float near_dist = 1.0f;
    float far_dist = 2.0f;

    if (render_info != nullptr) {
        near_dist = render_info->clip_min[2];
        far_dist = render_info->clip_max[2];
    }

    sort_num = num;
    sort_max = sort_num - 1;
    sort_num_f = (float) num;
    near_clip = near_dist;
    far_clip = far_dist;
    clip_range = far_dist - near_clip;
    sort_near = near_clip;
    sort_ratio = near_clip / far_clip;
    sort_scale = sort_num_f;
}

void mgCDrawManager::EndDraw(sceVif1Packet *vif_packet) {
    if (frame_tables.Bytes().empty()) {
        return;
    }
    PreEndDraw();
    if (!packets_prepared) {
        return;
    }

    for (int i = 0; i < group_num; i++) {
        const int group = draw_order != nullptr ? draw_order[i] : i;
        ReloadTexture(group, vif_packet);
        Draw(group, vif_packet);
    }
}

void mgCDrawManager::AddPacket(int group, u_long128 *common, u_long128 *packet, int vu_program) {
    if (frame_tables.Bytes().empty() || group_num <= 0 || group_max <= 0 || group >= group_max || memory == nullptr ||
        sort_table == nullptr || packet_num == nullptr || memory->stack != frame_stack) {
        return;
    }
    int index = group < 0 ? 0 : group;
    if (order_index != nullptr) {
        const int selected = group < 0 && draw_order != nullptr ? draw_order[0] : group;
        if (selected < 0 || selected >= group_max) {
            return;
        }
        index = order_index[selected];
    }
    if (index < 0 || index >= group_num || packet_num[index] == INT_MAX) {
        return;
    }
    auto *node = dc2::memory::NewObject<mgSORT_PACKET>(*memory);
    if (node == nullptr) {
        return;
    }
    node->next = sort_table[0];
    node->common = common;
    node->packet = packet;
    node->group = static_cast<s16>(index);
    node->vu_program = static_cast<s16>(vu_program);
    sort_table[0] = node;
    ++packet_num[index];
    packets_prepared = false;
}

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

/**
 * Deferred packet draws keyed by packet address, with open addressing so a steady frame allocates nothing.
 */
class PacketDrawTable {
public:
    void Set(const void *packet, std::function<void()> draw) {
        if ((occupied + 1) * 2 > slots.size()) {
            Rehash(std::max<std::size_t>(kMinimumSlots, slots.size() * 2));
        }
        Slot &slot = slots[InsertIndex(packet)];
        if (slot.key != packet) {
            occupied += slot.key == nullptr ? 1 : 0;
            slot.key = packet;
        }
        slot.draw = std::move(draw);
    }

    void Erase(const void *packet) {
        if (Slot *slot = Find(packet)) {
            // The slot stays occupied so later keys in its probe sequence remain reachable.
            slot->key = Tombstone();
            slot->draw = nullptr;
        }
    }

    // A copy, because the draw may clear or replace its own entry while it runs.
    std::function<void()> Get(const void *packet) {
        const Slot *slot = Find(packet);
        return slot != nullptr ? slot->draw : std::function<void()>();
    }

    void Clear() {
        for (Slot &slot : slots) {
            if (slot.key != nullptr) {
                slot.key = nullptr;
                slot.draw = nullptr;
            }
        }
        occupied = 0;
    }

private:
    struct Slot {
        const void           *key = nullptr;
        std::function<void()> draw;
    };

    static constexpr std::size_t kMinimumSlots = 1024;

    static const void *Tombstone() {
        static const char mark = 0;
        return &mark;
    }

    std::size_t Home(const void *packet) const {
        const auto bits = static_cast<std::uint64_t>(reinterpret_cast<std::uintptr_t>(packet) >> 2);
        return static_cast<std::size_t>(bits * 0x9E3779B97F4A7C15ULL) & (slots.size() - 1);
    }

    Slot *Find(const void *packet) {
        if (slots.empty() || packet == nullptr) {
            return nullptr;
        }
        for (std::size_t index = Home(packet);; index = (index + 1) & (slots.size() - 1)) {
            Slot &slot = slots[index];
            if (slot.key == packet) {
                return &slot;
            }
            if (slot.key == nullptr) {
                return nullptr;
            }
        }
    }

    // The packet's own slot, else the first reusable slot of its probe sequence.
    std::size_t InsertIndex(const void *packet) const {
        std::optional<std::size_t> reusable;
        for (std::size_t index = Home(packet);; index = (index + 1) & (slots.size() - 1)) {
            const Slot &slot = slots[index];
            if (slot.key == packet) {
                return index;
            }
            if (slot.key == nullptr) {
                return reusable.value_or(index);
            }
            if (slot.key == Tombstone() && !reusable) {
                reusable = index;
            }
        }
    }

    void Rehash(std::size_t count) {
        std::vector<Slot> previous = std::exchange(slots, std::vector<Slot>(count));
        occupied = 0;
        for (Slot &slot : previous) {
            if (slot.key != nullptr && slot.key != Tombstone()) {
                Set(slot.key, std::move(slot.draw));
            }
        }
    }

    std::vector<Slot> slots;
    std::size_t       occupied = 0; /**< Keys and tombstones. */
};

std::uint64_t packet_draw_epoch = 0;

// Constructed on first use, so captured mesh owners are released before the renderer's
// static resource tables at process exit.
PacketDrawTable &PacketDraws() {
    static PacketDrawTable draws;
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

void mgCDrawPrim::Begin2() {
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

void mgCDrawPrim::BeginDma() {
    // A PRIM write restarts primitive assembly on the GS.
    PrimRun &run = runs[this];
    run.prim_type = static_cast<int>(prim.PRIM);
    run.queue.clear();
}

void mgCDrawPrim::EndDma() {
    FlushPending(this);
}

void mgCDrawPrim::BeginPrim2(int type) {
    packed = 0;
    prim.PRIM = type;
    q = 1.0f;

    PrimRun &run = runs[this];
    run.packed = false;
    run.q = 1.0f;

    BeginDma();
}

void mgCDrawPrim::BeginPrim2(int prim_type, u_int /*data_a*/, u_int /*data_b*/, int unit_count) {
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

void mgCDrawPrim::EndPrim2() {
    FlushPending(this);
}

void mgCDrawPrim::End2() {
    FlushPending(this);
    runs.erase(this);
}

void mgCDrawPrim::Data(int *data) {
    if (data == nullptr) {
        return;
    }
    if (!write_buffer.empty()) {
        std::memcpy(write_buffer.data(), data, sizeof(u_long128));
        write_buffer = write_buffer.subspan(1);
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

u_long128 *mgCDrawPrim::DirectData(int count) {
    thread_local std::vector<u_long128> scratch(256);

    if (count > 0 && static_cast<std::size_t>(count) > scratch.size()) {
        scratch.resize(static_cast<std::size_t>(count));
    }

    return scratch.data();
}

void mgCDrawPrim::Vertex4(int x, int y, int z) {
    int ox = 0;
    int oy = 0;
    GetOffset(&ox, &oy);
    Kick(*this, Find(this), static_cast<uint32_t>(x + ox), static_cast<uint32_t>(y + oy), static_cast<uint32_t>(z));
}

void mgCDrawPrim::Color(int r, int g, int b, int a) {
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

void mgCDrawPrim::TextureCrd4(int u, int v) {
    PrimRun *run = Find(this);

    if (run == nullptr) {
        return;
    }

    run->u = static_cast<float>(u) / 16.0f;
    run->v = static_cast<float>(v) / 16.0f;
}

void mgCDrawPrim::Direct(unsigned long long reg, unsigned long long data) {
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

void mgCDrawPrim::Texture(mgCTexture *source) {
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

int mgCDrawManager::ReloadTexture(int group, sceVif1Packet *vif_packet) {
    if (frame_tables.Bytes().empty() || texture_manager == nullptr) {
        return 0;
    }
    mgCTextureManager *manager = texture_manager;

    if (group < 0 || group >= manager->block_max || group >= group_max) {
        return 0;
    }

    const int index = draw_order != nullptr ? order_index[group] : group;

    if (index < 0 || index >= group_num) {
        return 0;
    }

    manager->ReloadTexture(group, vif_packet);
    return 1;
}

int mgCDrawManager::Draw(int group, sceVif1Packet * /*unused*/) {
    if (frame_tables.Bytes().empty() || texture_manager == nullptr || !packets_prepared) {
        return 0;
    }
    if (group < 0 || group >= texture_manager->block_max || group >= group_max) {
        return 0;
    }

    if (draw_order != nullptr) {
        group = order_index[group];
    }

    if (group < 0 || group >= group_num || packet_num[group] < 0) {
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

    PacketDraws().Set(packet, std::move(draw));
}

void mgPortClearPacketDraw(const void *packet) {
    PacketDraws().Erase(packet);
}

void mgPortClearPacketDraws() {
    PacketDraws().Clear();
    ++packet_draw_epoch;
}

std::uint64_t mgPortPacketDrawEpoch() {
    return packet_draw_epoch;
}

bool mgPortPacketDraw(const void *packet) {
    if (packet == nullptr) {
        return false;
    }

    const std::function<void()> draw = PacketDraws().Get(packet);
    if (!draw) {
        return false;
    }
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

namespace {

template <typename T>
T *AllocTable(mgCMemory *memory, int count) {
    if (memory == nullptr || count < 0) {
        throw std::length_error("invalid draw table size");
    }
    const auto elements = static_cast<std::size_t>(std::max(count, 1));
    auto      *table = dc2::memory::NewArray<T>(*memory, elements);
    if (table == nullptr) {
        throw std::length_error("draw table exceeds remaining arena capacity");
    }
    std::fill_n(table, elements, T{});
    return table;
}

} // namespace

void mgCDrawManager::BeginDraw(mgCMemory *new_memory, std::span<const int> id_list) {
    auto *destination = new_memory != nullptr ? new_memory : packet_memory;
    if (destination == nullptr || texture_manager == nullptr || texture_manager->block_max < 0 || sort_num < 0) {
        throw std::invalid_argument("invalid draw manager storage or counts");
    }
    const int maximum = texture_manager->block_max;
    auto      ids = id_list;
    if (!ids.empty()) {
        const auto sentinel = std::ranges::find_if(ids, [](int id) { return id < 0; });
        if (sentinel == ids.end()) {
            throw std::invalid_argument("draw order has no terminator");
        }
        ids = ids.first(static_cast<std::size_t>(sentinel - ids.begin()));
        if (ids.size() >= static_cast<std::size_t>(INT_MAX) ||
            std::ranges::any_of(ids, [maximum](int id) { return id >= maximum; })) {
            throw std::invalid_argument("draw order contains an invalid texture block");
        }
    }
    const int groups = id_list.empty() ? maximum : static_cast<int>(ids.size());
    if (groups > static_cast<int>(std::numeric_limits<s16>::max()) + 1) {
        throw std::length_error("draw group count exceeds table extent");
    }
    std::size_t required = 0;
    auto        add_table = [&]<class T>(int count) {
        const auto size = dc2::memory::ArrayQuadwords<T>(static_cast<std::size_t>(std::max(count, 1)));
        if (!size || static_cast<std::size_t>(*size) >= static_cast<std::size_t>(INT_MAX) - required) {
            throw std::length_error("draw tables exceed allocation range");
        }
        required += static_cast<std::size_t>(*size);
    };
    if (!id_list.empty()) {
        add_table.template operator()<int>(maximum);
        add_table.template operator()<int>(groups + 1);
    }
    add_table.template operator()<mgSORT_PACKET **>(groups + 1);
    add_table.template operator()<int>(groups + 1);
    add_table.template operator()<int>(groups + 1);
    add_table.template operator()<mgSORT_PACKET *>(sort_num);
    if (destination->lock != 0 || required >= dc2::memory::RemainingBytes(*destination).size() / sizeof(u_long128)) {
        throw std::length_error("draw tables exceed remaining arena capacity");
    }
    memory = destination;
    frame_stack = memory->stack;
    packets_prepared = false;
    group_num = groups;
    group_max = maximum;
    order_index = nullptr;
    draw_order = nullptr;
    if (!id_list.empty()) {
        order_index = AllocTable<int>(memory, group_max);
        std::fill_n(order_index, static_cast<std::size_t>(group_max), -1);
        draw_order = AllocTable<int>(memory, groups + 1);
        for (std::size_t index = 0; index < ids.size(); ++index) {
            draw_order[index] = ids[index];
            order_index[ids[index]] = static_cast<int>(index);
        }
        draw_order[groups] = -1;
    }
    const int tables = groups + 1;
    packet_list = AllocTable<mgSORT_PACKET **>(memory, tables);
    unk_14 = AllocTable<int>(memory, tables);
    packet_num = AllocTable<int>(memory, tables);
    sort_table = AllocTable<mgSORT_PACKET *>(memory, sort_num);
    frame_tables = dc2::memory::ArenaBuffer::Bind(*memory,
                                                  std::span(reinterpret_cast<u8 *>(sort_table), static_cast<std::size_t>(std::max(sort_num, 1)) * sizeof(*sort_table)));
    if (frame_tables.Bytes().empty()) {
        throw std::logic_error("draw table allocation has no live lease");
    }
    ClearTable();
}

void mgCDrawManager::ClearTable() {
    if (frame_tables.Bytes().empty()) {
        return;
    }
    for (int i = 0; i < group_num; i++) {
        packet_list[i] = nullptr;
        unk_14[i] = 0;
        packet_num[i] = 0;
    }

    for (int i = 0; i < sort_num; i++) {
        sort_table[i] = nullptr;
    }
}

void mgCDrawManager::PreEndDraw() {
    if (frame_tables.Bytes().empty() || memory->stack != frame_stack) {
        return;
    }
    packets_prepared = false;
    const auto cursor_size = dc2::memory::ArrayQuadwords<mgSORT_PACKET **>(static_cast<std::size_t>(std::max(group_num, 1)));
    if (!cursor_size) {
        return;
    }
    std::size_t required = static_cast<std::size_t>(*cursor_size);
    for (int group = 0; group < group_num; ++group) {
        if (packet_num[group] < 0) {
            return;
        }
        if (packet_num[group] == 0) {
            continue;
        }
        const auto size = dc2::memory::ArrayQuadwords<mgSORT_PACKET *>(static_cast<std::size_t>(packet_num[group]));
        if (!size || static_cast<std::size_t>(*size) > std::numeric_limits<std::size_t>::max() - required) {
            return;
        }
        required += static_cast<std::size_t>(*size);
    }
    if (memory->lock != 0 || required >= dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128)) {
        return;
    }
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
    packets_prepared = true;
}

namespace {

void StoreLanes(std::span<u_long128> &destination, const int lanes[4]) {
    if (destination.empty()) {
        return;
    }

    std::memcpy(destination.data(), lanes, sizeof(int) * 4);
    destination = destination.subspan(1);
}

} // namespace

void mgCDrawPrim::Data0(float *data) {
    if (data == nullptr) {
        return;
    }
    const int lanes[4] = {vu0::Ftoi(data[0]), vu0::Ftoi(data[1]), vu0::Ftoi(data[2]), vu0::Ftoi(data[3])};
    StoreLanes(write_buffer, lanes);
}

void mgCDrawPrim::Data4(float *data) {
    if (data == nullptr) {
        return;
    }
    const int lanes[4] = {vu0::Ftoi4(data[0]), vu0::Ftoi4(data[1]), vu0::Ftoi4(data[2]), vu0::Ftoi4(data[3])};
    StoreLanes(write_buffer, lanes);
}

void mgCDrawPrim::Vertex(float *pos) {
    Vertex4(vu0::Ftoi4(pos[0]), vu0::Ftoi4(pos[1]), vu0::Ftoi(pos[2]));
}

void mgCDrawPrim::Color(float *color) {
    Color(vu0::Ftoi(color[0]), vu0::Ftoi(color[1]), vu0::Ftoi(color[2]), vu0::Ftoi(color[3]));
}
