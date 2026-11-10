#include "common.h"

#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <limits>

#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "water.hpp"

void CFireRaster::Step() {
    FireRasterParticle *free_slot = nullptr;
    int                 i = 0;
    FireRasterParticle *particle_slot = {};
    int                 offset = 0;

    for (; i < 20; offset++, i++) {
        particle_slot = &particle[offset];

        if (particle_slot->life <= 0) {
            free_slot = particle_slot;
        } else if (particle_slot->time >= particle_slot->life) {
            memset(particle_slot, 0, sizeof(FireRasterParticle));
        } else {
            particle_slot->position[1] += 1.2f;
            particle_slot->position[0] = 10.0f * sinf(PI * (static_cast<float>(particle_slot->time + i * 2) / 10.0f));
            particle_slot->position[2] = 10.0f * sinf(PI * (static_cast<float>(particle_slot->time + i * 2 + 10) / 8.0f));
            particle_slot->size -= 0.1f;
            particle_slot->time++;
        }
    }

    if (free_slot != nullptr) {
        mgZeroVectorW(free_slot->position);
        free_slot->size = 13.0f;
        free_slot->time = rand() % 20;
        free_slot->life = 30;
    }
}

struct TextureFields {
    short       block;
    short       width;
    short       height;
    short       bpp;
    char        name[32];
    int         vram_size;
    int         image_blocks;
    int         clut_size;
    u_long      tex0;
    u_long      tex1;
    u_long      clamp;
    u_long128  *image[4];
    u_long128  *clut;
    int         swizzled;
    mgCTexture *next;
};

void CFireRaster::SetTexture(mgCTexture *texture) {
    if (texture != nullptr) {
        *reinterpret_cast<TextureFields *>(&this->texture) = *reinterpret_cast<TextureFields *>(texture);
        this->texture.tex0.bits.tcc = 0;
    }
}

void CFireRaster::Draw(sceVu0FVECTOR position, float *scale) {
    mgCDrawPrim         prim;
    FireRasterParticle *wisp = {};
    int                 top_left[4];
    int                 bottom_right[4];
    sceVu0FVECTOR       world_position;
    int                 uv0[2];
    int                 uv1[2];
    int                 left = {};
    int                 top = {};
    int                 right = {};
    int                 bottom = {};
    int                 index = {};

    prim.Initialize(nullptr, nullptr);
    prim.DepthTestEnable(1);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.TextureMapEnable(1);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    prim.AlphaTestEnable(0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Coord(1);
    prim.Texture(&texture);
    prim.Direct(SCE_GS_TEXA, 0x8000000080ULL);
    prim.Color(0x80, 0x80, 0x80, 0x20);
    left = mgScreenOffx * 16;
    top = mgScreenOffy * 16;
    right = (mgScreenOffx + mgScreenWidth - 2) * 16;
    bottom = (mgScreenOffy + mgScreenHeight - 2) * 16;

    for (index = 0; index < 20; index++) {
        wisp = &particle[index];

        if (wisp->life > 0) {
            world_position[0] = wisp->position[0] * scale[0];
            world_position[1] = wisp->position[1] * scale[1];
            world_position[2] = wisp->position[2] * scale[2];
            sceVu0AddVector(world_position, position, wisp->position);
            world_position[3] = 1.0f;

            if (mgTransWorldPrim3DSprite(top_left, bottom_right, world_position,
                                         wisp->size * scale[0], wisp->size * scale[1], 0) != 0) {
                if (top_left[0] < left) {
                    top_left[0] = left;
                }

                if (top_left[1] < top) {
                    top_left[1] = top;
                }

                if (bottom_right[0] < left) {
                    bottom_right[0] = left;
                }

                if (bottom_right[1] < top) {
                    bottom_right[1] = top;
                }

                if (top_left[0] > right) {
                    top_left[0] = right;
                }

                if (top_left[1] > bottom) {
                    top_left[1] = bottom;
                }

                if (bottom_right[0] > right) {
                    bottom_right[0] = right;
                }

                if (bottom_right[1] > bottom) {
                    bottom_right[1] = bottom;
                }

                uv0[0] = top_left[0] - mgScreenOffx * 16 + 0x28;
                uv0[1] = top_left[1] - mgScreenOffy * 16 + 0x28;
                uv1[0] = bottom_right[0] - mgScreenOffx * 16 - 0x28;
                uv1[1] = bottom_right[1] - mgScreenOffy * 16 - 0x28;

                if (uv0[0] < 0) {
                    uv0[0] = 0;
                }

                if (uv0[1] < 0) {
                    uv0[1] = 0;
                }

                if (uv1[0] < 0) {
                    uv1[0] = 0;
                }

                if (uv1[1] < 0) {
                    uv1[1] = 0;
                }

                if (uv0[0] > mgScreenWidth * 16) {
                    uv0[0] = mgScreenWidth * 16;
                }

                if (uv0[1] > mgScreenHeight * 16) {
                    uv0[1] = mgScreenHeight * 16;
                }

                if (uv1[0] > mgScreenWidth * 16) {
                    uv1[0] = mgScreenWidth * 16;
                }

                if (uv1[1] > mgScreenHeight * 16) {
                    uv1[1] = mgScreenHeight * 16;
                }

                prim.TextureCrd4(uv0[0], uv0[1]);
                prim.Vertex4(top_left);
                prim.TextureCrd4(uv1[0], uv1[1]);
                prim.Vertex4(bottom_right);
            }
        }
    }

    prim.End();
}

void CFireRaster::Initialize() {
    int index = 0;

    do {
        memset(&particle[index], 0, sizeof(particle[index]));
        index++;
    } while (index < 20);
}

void CThunderEffect::Init() {
    unk_00 = 0;
    unk_90 = 0;
    unk_94 = 0;
    unk_98 = 0;
}

std::span<float> CWater::Grid(bool second) const {
    if (rows < 2 || columns < 2) {
        return {};
    }
    const auto row_count = static_cast<std::size_t>(rows);
    const auto column_count = static_cast<std::size_t>(columns);
    if (row_count > std::numeric_limits<std::size_t>::max() / column_count) {
        return {};
    }
    const auto &grid = grids[second ? 1U : 0U];
    const auto  bytes = grid.storage.Bytes();
    if (grid.values.size() != row_count * column_count || bytes.empty() ||
        bytes.size() != grid.values.size_bytes() ||
        static_cast<const void *>(bytes.data()) != static_cast<const void *>(grid.values.data())) {
        return {};
    }
    return grid.values;
}

std::span<float> CWater::Heights() { return Grid(second_grid); }

std::span<const float> CWater::Heights() const { return Grid(second_grid); }

void CWater::Hamon() {
    const auto current = Grid(second_grid);
    auto       next = Grid(!second_grid);
    if (current.empty() || next.size() != current.size()) {
        return;
    }
    second_grid = !second_grid;
    const float coefficient = speed * speed;
    const float center_coefficient = 2.0f * (1.0f - 2.0f * coefficient);
    const auto  row_count = static_cast<std::size_t>(rows);
    const auto  column_count = static_cast<std::size_t>(columns);
    for (std::size_t row = 1; row + 1 < row_count; ++row) {
        for (std::size_t column = 1; column + 1 < column_count; ++column) {
            const auto  index = row * column_count + column;
            const float old_height = next[index];
            float       new_height = (current[index - 1] + current[index + 1] + current[index + column_count]) + current[index - column_count];
            new_height *= coefficient;
            new_height += center_coefficient * current[index] - old_height;
            next[index] = new_height - damping * (new_height - old_height);
        }
    }
}

void CWater::SetVertex(float *a, float *b) {
    if (a != nullptr && b != nullptr) {
        mgVectorMaxMin(max, min, a, b);
    }
}

void CWater::Shake(int x, int z, float amount) {
    auto values = Heights();
    if (values.empty() || rows < 3 || columns < 3 || !std::isfinite(amount)) {
        return;
    }
    x = std::clamp(x % rows, 1, rows - 2);
    z = std::clamp(z % columns, 1, columns - 2);
    const auto index = static_cast<std::size_t>(x) * static_cast<std::size_t>(columns) + static_cast<std::size_t>(z);
    values[index] += amount;
}

void CWaterFrame::Shake(float x, float z, float height_change) {
    auto *water = GetWater();
    if (water == nullptr || water->Heights().empty() || !std::isfinite(x) || !std::isfinite(z)) {
        return;
    }
    sceVu0FMATRIX world_matrix;
    sceVu0FMATRIX inverse_matrix;
    sceVu0FVECTOR position{x, 0.0f, z, 1.0f};
    sceVu0FVECTOR local_position;
    GetLWMatrix(world_matrix);
    mgInversMatrix(inverse_matrix, world_matrix);
    sceVu0ApplyMatrix(local_position, inverse_matrix, position);
    x = local_position[0];
    z = local_position[2];
    const float width = water->max[0] - water->min[0];
    const float depth = water->max[2] - water->min[2];
    if (!std::isfinite(x) || !std::isfinite(z) || !std::isfinite(width) || !std::isfinite(depth) ||
        width <= 0.0f || depth <= 0.0f || x < water->min[0] || x > water->max[0] || z < water->min[2] || z > water->max[2]) {
        return;
    }
    const float row = static_cast<float>(water->rows) * (x - water->min[0]) / width;
    const float column = static_cast<float>(water->columns) * (z - water->min[2]) / depth;
    if (!std::isfinite(row) || !std::isfinite(column)) {
        return;
    }
    const auto row_index = static_cast<int>(std::clamp(static_cast<double>(row), 0.0, static_cast<double>(water->rows)));
    const auto column_index = static_cast<int>(std::clamp(static_cast<double>(column), 0.0, static_cast<double>(water->columns)));
    water->Shake(row_index, column_index, height_change);
}

CWater *CWaterFrame::GetWater() {
    return dynamic_cast<CWater *>(visual);
}

bool CWater::SetSize(int x, int z, mgCMemory *memory) {
    if (memory == nullptr || memory->lock != 0 || x < 2 || z < 2) {
        return false;
    }
    const auto row_count = static_cast<std::size_t>(x);
    const auto column_count = static_cast<std::size_t>(z);
    if (row_count > std::numeric_limits<std::size_t>::max() / column_count) {
        return false;
    }
    const auto count = row_count * column_count;
    const auto words = dc2::memory::ArrayQuadwords<float>(count);
    if (!words || dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128) <= 2 * static_cast<std::size_t>(*words)) {
        return false;
    }
    std::array<GridStorage, 2> pending{};
    for (auto &grid : pending) {
        auto *values = dc2::memory::NewArray<float>(*memory, count);
        if (values == nullptr) {
            return false;
        }
        grid.values = std::span(values, count);
        const auto allocation = dc2::memory::AllocationBytes(*memory, values);
        if (allocation.size() < grid.values.size_bytes()) {
            return false;
        }
        grid.storage = dc2::memory::ArenaBuffer::Bind(*memory, allocation.first(grid.values.size_bytes()));
        if (grid.storage.Bytes().size() != grid.values.size_bytes()) {
            return false;
        }
        std::ranges::fill(grid.values, 0.0f);
    }
    grids = pending;
    rows = x;
    columns = z;
    second_grid = false;
    unk_50 = 0;
    return true;
}

void CWater::SetParam(float wave_speed, float wave_damping, float param_48, float param_4c) {
    speed = wave_speed;
    damping = wave_damping;
    surface_param0 = param_48;
    surface_param1 = param_4c;
}

void CWater::SetColor(u_char red, u_char green, u_char blue, u_char alpha) {
    color[0] = red;
    color[1] = green;
    color[2] = blue;
    color[3] = alpha;
}

CWater::CWater() {
    rows = 0;
    columns = 0;
    texture = nullptr;
    color[0] = 128;
    color[1] = 128;
    color[2] = 128;
    color[3] = 128;
    speed = 0.1f;
    damping = 0.015f;
    surface_param0 = 0;
    surface_param1 = 0;
}

void CWaterFrame::SetTexture(mgCTexture *texture) {
    CWater *surface = GetWater();

    if (surface) {
        surface->texture = texture;
    }
}

void CWaterFrame::Step() {
    CWater *surface = GetWater();

    if (surface == nullptr || stop != 0) {
        return;
    }

    surface->Hamon();
}

void CWaterFrame::SetParam(float p0, float p1, float p2, float p3) {
    CWater *surface = GetWater();

    if (surface) {
        surface->SetParam(p0, p1, p2, p3);
    }
}

void CWaterFrame::SetColor(u_char r, u_char g, u_char b, u_char a) {
    CWater *surface = GetWater();

    if (surface) {
        surface->SetColor(r, g, b, a);
    }
}

void CWaterFrame::Shake(int x, int z, float amount) {
    CWater *surface = GetWater();

    if (surface) {
        surface->Shake(x, z, amount);
    }
}

CWaterFrame *CreateWaterFrame(int rows, int columns, float *min, float *max, mgCMemory *memory) {
    if (memory == nullptr || min == nullptr || max == nullptr || rows < 2 || columns < 2) {
        return nullptr;
    }
    auto *frame = dc2::memory::NewObject<CWaterFrame>(*memory);
    if (frame == nullptr) {
        return nullptr;
    }
    auto *attr = dc2::memory::NewObject<mgCFrameAttr>(*memory);
    auto *water = dc2::memory::NewObject<CWater>(*memory);
    if (attr == nullptr || water == nullptr || !water->SetSize(rows, columns, memory)) {
        return nullptr;
    }
    auto *bound = dc2::memory::NewObject<mgCFrame::BoundInfo>(*memory);
    if (bound == nullptr) {
        return nullptr;
    }
    attr->z_write = MG_ZBUF_NO_WRITE;
    attr->z_test = MG_DEPTH_TEST_GEQUAL;
    attr->alpha_test = -1;
    attr->alpha_blend = MG_ALPHA_MACRO_BLEND;
    frame->attr = attr;
    frame->bound = bound;
    water->SetVertex(min, max);
    frame->SetVisual(water);
    frame->SetBBox(max, min);
    if (!dc2::render::VisualCloneInputs::Publish(*memory, *water, dc2::render::VisualCloneKind::Water) ||
        !dc2::render::FrameCloneInputs::Publish(*memory, *frame, water->clone_inputs)) {
        return nullptr;
    }
    return frame;
}

void CWaterFrame::Initialize() {
    unk_110 = 0;
    stop = 0;
    mgCFrame::Initialize();
}

// Ahead of common.h: libgraph.h defines A, B, C and D as macros that would rewrite the vu1 header's names.
// clang-format off
#include "vu1/water_geom.hpp"

#include "common.h"
// clang-format on

#include <cstring>
#include <span>
#include <vector>

#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "render/renderer.hpp"
#include "water.hpp"

namespace vu = dc::vu1;

namespace {

constexpr uint32_t kWaterPrimMode = 0x158u;
constexpr uint32_t kWaterPrimFog = 0x20u;

// TEXA as the water packet writes it: TA0 and TA1 0x80, AEM off.
constexpr uint64_t kWaterTexa = 0x0000008000000080ull;

void MultiplyColumnMajor(const float (&a)[16], const float (&b)[16], float (&out)[16]) {
    float result[16];
    for (int col = 0; col < 4; ++col) {
        for (int row = 0; row < 4; ++row) {
            float sum = 0.0f;
            for (int k = 0; k < 4; ++k) {
                sum += a[k * 4 + row] * b[col * 4 + k];
            }
            result[col * 4 + row] = sum;
        }
    }
    std::memcpy(out, result, sizeof result);
}

bool FogOn(const mgRENDER_INFO &info) {
    return info.attr != nullptr && info.attr->fog != 0 && info.fog_enable != 0;
}

void FogColour(const mgRENDER_INFO &info, uint8_t (&out)[3]) {
    out[0] = info.fog.r;
    out[1] = info.fog.g;
    out[2] = info.fog.b;

    if (info.attr != nullptr && info.attr->fog == MG_FOG_BLACK) {
        out[0] = out[1] = out[2] = 0x00;
    } else if (info.attr != nullptr && info.attr->fog == MG_FOG_WHITE) {
        out[0] = out[1] = out[2] = 0xFF;
    }
}

// The overrides mgCVisual::SetDrawEnvGifTag applies to the base draw env, in native terms.
void ApplyFrameAttr(gfx::DrawState &state, const mgCVisualAttr &attr) {
    if (attr.alpha_ref >= 0) {
        state.alpha_ref = static_cast<uint8_t>(attr.alpha_ref);
    }

    switch (attr.z_test) {
        case MG_DEPTH_TEST_ALWAYS:
            state.depth_test = gfx::DepthTest::Always;
            break;
        case MG_DEPTH_TEST_GEQUAL:
            state.depth_test = gfx::DepthTest::GEqual;
            break;
        case MG_DEPTH_TEST_GREATER:
            state.depth_test = gfx::DepthTest::Greater;
            break;
        default:
            break;
    }

    if (attr.alpha_test > 0) {
        state.alpha_test = true;
        state.alpha_func = static_cast<gfx::AlphaFunc>(attr.alpha_test);
    } else if (attr.alpha_test == -1) {
        state.alpha_test = false;
    }

    // dest_alpha_test has no DrawState equivalent.

    switch (attr.alpha_blend) {
        case MG_ALPHA_BLEND_NORMAL:
            state.alpha = gfx::GsBlend{.a = 0, .b = 1, .c = 0, .d = 1, .fix = 0x00};
            break;
        case MG_ALPHA_BLEND_ADD:
            state.alpha = gfx::GsBlend{.a = 0, .b = 2, .c = 0, .d = 1, .fix = 0x00};
            break;
        case MG_ALPHA_BLEND_SUB:
            state.alpha = gfx::GsBlend{.a = 2, .b = 0, .c = 0, .d = 1, .fix = 0x00};
            break;
        case MG_ALPHA_BLEND_NONE:
            state.alpha = gfx::GsBlend{.a = 2, .b = 2, .c = 2, .d = 0, .fix = 0x80};
            break;
        case MG_ALPHA_BLEND_ADD_FULL:
            state.alpha = gfx::GsBlend{.a = 0, .b = 2, .c = 2, .d = 1, .fix = 0x80};
            break;
        default:
            break;
    }

    switch (attr.z_write) {
        case MG_ZBUF_NO_WRITE:
            state.depth_write = false;
            break;
        case MG_ZBUF_WRITE:
            state.depth_write = true;
            break;
        default:
            break;
    }
}

} // namespace

int CWater::CreateRenderInfoPacket(u_int * /*packet*/, float (* /*matrix*/)[4], mgRENDER_INFO *info) {
    if (info == nullptr) {
        return 0;
    }
    info->scissor = 0;
    prmode = kWaterPrimMode | (FogOn(*info) ? kWaterPrimFog : 0u);
    return 0;
}

int CWater::Draw(u_int * /*tag*/, float (*matrix)[4], mgCDrawManager *draw_manager) {
    if (draw_manager == nullptr) {
        draw_manager = &mgDrawManager;
    }

    mgRENDER_INFO *render_info = draw_manager->render_info;
    if (render_info == nullptr || matrix == nullptr) {
        return 0;
    }
    texture_manager = draw_manager->texture_manager;
    CreateRenderInfoPacket(nullptr, matrix, render_info);

    uint8_t fog_colour[3];
    FogColour(*render_info, fog_colour);

    // The water packet leaves TEXA, FOGCOL and TEX1 in the GS, where later draws find them.
    mgPortGs().texa = kWaterTexa;
    for (int channel = 0; channel < 3; ++channel) {
        mgPortGs().fog_color[channel] = fog_colour[channel];
    }
    if (texture != nullptr) {
        mgPortGs().tex1 = texture->tex1_bits;
    }

    if (!mgPortRendererReady() || !mgPortFrameOpen() || rows < 2 || columns < 2 || Heights().empty()) {
        return 0;
    }

    sceVu0FMATRIX model_to_eye;
    mgMulMatrix(model_to_eye, render_info->view, matrix);
    vu::Mat4 eye{};
    std::memcpy(&eye, model_to_eye, sizeof eye);

    const vu::WaterSurface surface{
        .p0 = surface_param0,
        .p1 = surface_param1,
        .colour = {static_cast<float>(color[0]), static_cast<float>(color[1]), static_cast<float>(color[2]), static_cast<float>(color[3])}
    };
    const vu::WaterMeshDesc desc{
        .min = {.x = min[0], .y = min[1], .z = min[2], .w = min[3]},
        .max = {.x = max[0], .y = max[1], .z = max[2], .w = max[3]},
        .rows = rows,
        .columns = columns
    };
    static thread_local vu::WaterMesh mesh;
    vu::BuildWaterMesh(desc, Heights(), mesh);

    static thread_local std::vector<vu::WaterHostVertex> host_vertices;
    static thread_local std::vector<uint32_t>            indices;
    vu::WaterHostMesh(surface, eye, mesh, host_vertices, indices);
    if (indices.empty()) {
        return 0;
    }

    // Retail samples a copy of the frame that CMap::DrawWater takes right before this draw; the
    // same frame contents come from a snapshot taken here.
    gfx::TextureHandle image = gfx::kNullTexture;
    if (mgPortCurrentTarget() == gfx::kMainTarget) {
        image = gfx::NamedRenderTarget("water refraction", static_cast<uint32_t>(mgScreenWidth),
                                       static_cast<uint32_t>(mgScreenHeight), false, false, true);
        if (image == gfx::kNullTexture || !gfx::SnapshotFrame(image)) {
            return 0;
        }
    } else if (texture != nullptr) {
        image = mgPortBinding(texture).texture;
    }
    if (image == gfx::kNullTexture) {
        return 0;
    }

    const gfx::LogicalMapping mapping = gfx::GetLogicalMapping(image);
    if (mapping.pixel_width == 0 || mapping.pixel_height == 0) {
        return 0;
    }

    static thread_local std::vector<gfx::Vertex3D> vertices;
    vertices.resize(host_vertices.size());
    for (std::size_t i = 0; i < host_vertices.size(); ++i) {
        const vu::WaterHostVertex &host = host_vertices[i];
        gfx::Vertex3D             &vertex = vertices[i];
        std::copy(host.position, host.position + 3, vertex.position);
        vertex.uv[0] = host.uv_offset[0] * mapping.scale_x / static_cast<float>(mapping.pixel_width);
        vertex.uv[1] = host.uv_offset[1] * mapping.scale_y / static_cast<float>(mapping.pixel_height);
        std::copy(host.color, host.color + 4, vertex.color);
    }

    float model[16];
    std::memcpy(model, matrix, sizeof model);
    float world_to_clip[16];
    mgPortWorldToClip(world_to_clip);

    gfx::MeshConstants constants{};
    MultiplyColumnMajor(world_to_clip, model, constants.mvp);
    constants.flags = gfx::kMeshVertexColor | gfx::kMeshScreenUv;
    for (float &channel : constants.diffuse) {
        channel = 1.0f;
    }

    const bool fog_on = FogOn(*render_info);
    if (fog_on) {
        // mesh.vert clamps to [lo, hi]; the VU takes max(far, min(near, F)). Those agree when
        // far <= near, and otherwise the VU's value is the constant far.
        constants.flags |= gfx::kMeshFog;
        constants.fog[0] = render_info->fog.offset;
        constants.fog[1] = render_info->fog.scale;
        constants.fog[2] = render_info->fog.far_value;
        constants.fog[3] = std::max(render_info->fog.near_value, render_info->fog.far_value);
    }

    const mgCDrawEnv &base = draw_env != nullptr ? *draw_env : render_info->draw_env[0];
    gfx::DrawState    state = mgPortDrawState();
    mgPortApplyDrawEnv(state, base);
    if (render_info->attr != nullptr) {
        ApplyFrameAttr(state, *render_info->attr);
    }
    state.blend = true;
    state.fog = fog_on;
    for (int channel = 0; channel < 3; ++channel) {
        state.fog_color[channel] = fog_colour[channel];
    }
    state.texa_aem = false;
    state.texa_ta0 = 0x80;
    state.cull = gfx::CullMode::None;

    gfx::TextureBinding binding;
    binding.texture = image;
    binding.filter = texture != nullptr ? mgPortFilter(texture->tex1_bits) : gfx::Filter::Linear;
    binding.wrap_u = gfx::Wrap::Clamp;
    binding.wrap_v = gfx::Wrap::Clamp;
    binding.ignore_alpha = true;

    const gfx::MeshTransform transform = mgPortMeshTransform(model);
    mgPortInterpScope        scope(this, kMgPortFrameTeleportDistance);
    mgPortDrawMeshImmediate(vertices, indices, constants, binding, state, &transform);
    return 0;
}
