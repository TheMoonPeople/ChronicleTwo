#include "common.h"

#include <libgraph.h>
#include <libvu0.h>

#include <algorithm>
#include <array>
#include <bit>
#include <cmath>
#include <cstring>
#include <map>
#include <span>
#include <unordered_map>
#include <vector>

#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_shadow.hpp"
#include "mg_visual.hpp"
#include "render/renderer.hpp"
#include "render/shadow_mesh.hpp"
#include "vu1/sdw_geom.hpp"

/**
 *
 * Writes the packet that loads the shadow projection matrix into VU1 memory, followed by the GS
 * packets the shadow microprogram sends, and returns its length in quadwords.
 *
 */
static int SetShadowData(u_int *packet, float (*matrix)[4]) {
    // DMA CNT of eight quadwords, then VIF UNPACK of the matrix and the two GIF packets.
    packet[0] = 0x10000008;
    packet[1] = 0;
    packet[2] = 0;
    packet[3] = 0x6C080028;
    u_long128 *dst = (u_long128 *) (packet + 4);
    std::memcpy(dst, matrix, sizeof(sceVu0FMATRIX));
    packet[0x14] = 0x8001;
    packet[0x15] = 0x102E8000;
    packet[0x16] = 0xE;
    packet[0x17] = 0;
    packet[0x18] = 0x68;
    packet[0x19] = 0x80;
    packet[0x1A] = 0x42;
    packet[0x1B] = 0;
    packet[0x1C] = 0x8001;
    packet[0x1D] = 0x102E8000;
    packet[0x1E] = 0xE;
    packet[0x1F] = 0;
    packet[0x20] = 0x62;
    packet[0x21] = 0x80;
    packet[0x22] = 0x42;
    packet[0x23] = 0;
    return 9;
}

struct ShadowGifRegs {
    u_long reg_s0 : 4;
    u_long reg_s1 : 4;
};

const FACES_ID *mgCShadowMDT::CreateFace(const FACES_ID *source, std::span<const std::byte> remaining,
                                         mgCMemory *face_memory, mgCMemory *index_memory, mgCFace **result) {
    const auto record_bytes = dc2::render::FaceRecordBytes(remaining, true);
    if (!record_bytes || remaining.data() != reinterpret_cast<const std::byte *>(source) ||
        face_memory == nullptr || index_memory == nullptr) {
        return nullptr;
    }
    if (!dc2::render::FaceAllocationFits(*face_memory, *index_memory,
                                         static_cast<std::size_t>(source->vertex_num))) {
        return nullptr;
    }
    mgCFace *face = dc2::memory::NewObject<mgCFace>(*face_memory);
    if (face == nullptr) {
        return nullptr;
    }
    face->vertex_num = (int) source->vertex_num / 3;
    face->type = source->type;
    face->index_stride = 3;
    face->index_num = face->vertex_num * face->index_stride;
    // Only the position index of each of a triangle's three vertices is kept.
    face->material = source->material;
    const int *vertex = source->index;
    int       *index = dc2::memory::NewArray<int>(*index_memory, static_cast<std::size_t>(face->index_num));
    if (index == nullptr) {
        return nullptr;
    }
    face->index = index;

    for (int i = 0; i < face->vertex_num; i++) {
        index[0] = vertex[0];
        index[1] = vertex[3];
        index[2] = vertex[6];
        index += 3;
        vertex += 9;
    }

    face->next = nullptr;
    mgFACE_GROUP *group = face_group;

    if (group == nullptr) {
        group = dc2::memory::NewObject<mgFACE_GROUP>(*face_memory);
        if (group == nullptr) {
            return nullptr;
        }
        *group = {};
        group->next = nullptr;
        group->face = nullptr;
        group->material = face->material;
        group->vu_program = 1; // MG_VU_PROG_SHADOW
        face_group = group;
    }

    mgCFace *last = group->face;

    if (last == nullptr) {
        group->face = face;
    } else {
        mgCFace *following = {};

        while ((following = last->next) != nullptr) {
            last = following;
        }

        last->next = face;
    }

    if (result != nullptr) {
        *result = face;
    }

    return reinterpret_cast<const FACES_ID *>(remaining.data() + *record_bytes);
}

int mgCShadowMDT::DataAssignMDT(std::span<std::byte> model, mgCMemory *memory,
                                mgCTextureManager *textures) {
    const auto face_section = dc2::render::ValidateMdtFaceSection(model, true);
    if (!face_section || memory == nullptr) {
        return 0;
    }
    auto      *header = reinterpret_cast<MDT_HEADER *>(model.data());
    const auto needed = dc2::render::RequiredMdtQuadwords(*header, *face_section,
                                                          dc2::render::MdtStorage::Shadow);
    if (!needed || memory->lock != 0 ||
        *needed >= dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128)) {
        return 0;
    }

    texture_manager = textures;
    // A shadow needs neither normals nor texture coordinates.
    header->uv_num = 0;
    header->normal_num = 0;
    mgCVisualMDT::CopyMDTData(header, memory);
    face_group = nullptr;
    const auto *faces = reinterpret_cast<const MDT_FACES *>(face_section->data());
    auto        remaining = face_section->subspan(sizeof(MDT_FACES));
    int         count = faces->prim_num;

    for (int i = 0; i < count; i++) {
        const auto *cursor = reinterpret_cast<const FACES_ID *>(remaining.data());
        const auto *next = CreateFace(cursor, remaining, memory, memory, nullptr);
        if (next == nullptr) {
            return 0;
        }
        remaining = remaining.subspan(reinterpret_cast<const std::byte *>(next) - remaining.data());
    }

    return 1;
}

namespace vu = dc::vu1;

namespace {

constexpr float kIdentity[16] = {1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f,
                                 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f};

// Flat colour 1 is retail's RGBAQ (1, 1, 1) against a material of 0x80.
constexpr float       kShadowDiffuse = 1.0f / 128.0f;
constexpr float       kShadowAlpha = 0.5f;
constexpr std::size_t kShadowCacheEntries = 128;

// Z-fail counts the volume's far caps, which lie on the receiving plane. A cap on the plane passes
// GEQUAL against the floor and is missed, so the drop is pushed past the plane by this fraction of
// its eye depth.
constexpr float kShadowDropBias = 1e-3f;

// GS guard band half-range about the screen centre, in logical pixels.
constexpr float kGuardHalfRange = 2048.0f;

vu::Mat4 ToMat(const float (*m)[4]) {
    vu::Mat4 out{};
    std::memcpy(&out, m, sizeof out);
    return out;
}

gfx::StencilFace VolumeFace(gfx::StencilOp depth_fail) {
    return {.compare = gfx::CompareOp::Always, .fail = gfx::StencilOp::Keep, .pass = gfx::StencilOp::Keep, .depth_fail = depth_fail};
}

// Negated comparisons so a NaN corner is rejected.
bool InClipVolume(const vu::Vec4 &p, const mgPortProjection &projection) {
    if (p.z < projection.near_z || p.z > projection.far_z) {
        return false;
    }

    const float screen_x = std::fabs(p.x * projection.eye / p.z);
    const float screen_y = std::fabs(p.y * projection.eye * projection.aspect_y / p.z);
    return screen_x <= kGuardHalfRange && screen_y <= kGuardHalfRange;
}

using Triangle = std::array<vu::Vec4, 3>;
using Neighbours = std::array<int32_t, 3>;

struct Topology {
    std::vector<Triangle>   triangles;
    std::vector<Neighbours> neighbours;
};

// Position identities weld duplicated seam vertices without depending on the visual's index layout.
std::array<uint32_t, 3> PositionKey(const vu::Vec4 &p) {
    return {std::bit_cast<uint32_t>(p.x + 0.0f), std::bit_cast<uint32_t>(p.y + 0.0f), std::bit_cast<uint32_t>(p.z + 0.0f)};
}

Topology &ShadowTopology(const mgCShadowMDT &visual) {
    static std::unordered_map<const mgCShadowMDT *, Topology> cache;
    static thread_local std::vector<Triangle>                 triangles;
    triangles.clear();
    for (const mgFACE_GROUP *group = visual.face_group; group; group = group->next) {
        for (const mgCFace *face = group->face; face; face = face->next) {
            for (int t = 0; t < face->vertex_num; ++t) {
                Triangle triangle;
                for (int corner = 0; corner < 3; ++corner) {
                    const float *p = visual.vertex[face->index[t * 3 + corner]];
                    triangle[corner] = {.x = p[0], .y = p[1], .z = p[2], .w = 1.0f};
                }
                triangles.push_back(triangle);
            }
        }
    }
    // Cached geometry is owned, never read through retired arena pointers, and compared before reuse.
    if (cache.size() >= kShadowCacheEntries && !cache.contains(&visual)) {
        cache.clear();
    }
    auto &entry = cache[&visual];
    if (entry.triangles.size() == triangles.size() &&
        (triangles.empty() || std::memcmp(entry.triangles.data(), triangles.data(), triangles.size() * sizeof(Triangle)) == 0)) {
        return entry;
    }
    entry.triangles = triangles;
    entry.neighbours.assign(triangles.size(), {-1, -1, -1});

    struct Edge {
        uint64_t key;
        uint32_t triangle;
        uint32_t edge;
        auto     operator<=>(const Edge &) const = default;
    };

    std::map<std::array<uint32_t, 3>, uint32_t> positions;
    std::vector<Edge>                           edges;
    edges.reserve(triangles.size() * 3);
    for (uint32_t t = 0; t < triangles.size(); ++t) {
        std::array<uint32_t, 3> ids{};
        for (int corner = 0; corner < 3; ++corner) {
            ids[corner] = positions.try_emplace(PositionKey(triangles[t][corner]), static_cast<uint32_t>(positions.size())).first->second;
        }
        for (uint32_t edge = 0; edge < 3; ++edge) {
            const auto a = ids[edge];
            const auto b = ids[(edge + 1) % 3];
            if (a != b) {
                edges.push_back({.key = (uint64_t{std::min(a, b)} << 32) | std::max(a, b), .triangle = t, .edge = edge});
            }
        }
    }
    std::ranges::sort(edges);
    for (std::size_t first = 0; first < edges.size();) {
        std::size_t end = first + 1;
        while (end < edges.size() && edges[end].key == edges[first].key) {
            ++end;
        }
        if (end - first == 2 && edges[first].triangle != edges[first + 1].triangle) {
            const auto &a = edges[first];
            const auto &b = edges[first + 1];
            entry.neighbours[a.triangle][a.edge] = static_cast<int32_t>(b.triangle * 3 + b.edge);
            entry.neighbours[b.triangle][b.edge] = static_cast<int32_t>(a.triangle * 3 + a.edge);
        }
        first = end;
    }
    return entry;
}

struct Prism {
    Triangle            top{};
    Triangle            drop{};
    std::array<bool, 3> sides{true, true, true};
    bool                down = false;
    bool                valid = false;
    uint32_t            first = 0;
};

bool SamePoint(const vu::Vec4 &a, const vu::Vec4 &b) {
    return a.x == b.x && a.y == b.y && a.z == b.z;
}

// Only identical, planar sides between prisms on opposite sides of the shared plane cancel.
bool SideCancelled(const Prism &a, int edge, const Prism &b, int other_edge) {
    const int  next = (edge + 1) % 3;
    const int  other_next = (other_edge + 1) % 3;
    const bool forward = SamePoint(a.top[edge], b.top[other_edge]);
    const int  b0 = forward ? other_edge : other_next;
    const int  b1 = forward ? other_next : other_edge;
    if (!SamePoint(a.top[edge], b.top[b0]) || !SamePoint(a.top[next], b.top[b1]) ||
        !SamePoint(a.drop[edge], b.drop[b0]) || !SamePoint(a.drop[next], b.drop[b1])) {
        return false;
    }
    const auto  base = a.top[edge];
    const auto  normal = vu::Cross3(a.top[next] - base, a.drop[edge] - base);
    const float length = std::sqrt(vu::Dot3(normal, normal));
    const auto  far_corner = a.drop[next] - base;
    if (!std::isfinite(length) || length == 0.0f ||
        std::fabs(vu::Dot3(normal, far_corner)) > 1e-5f * length * std::sqrt(vu::Dot3(far_corner, far_corner))) {
        return false;
    }
    const auto side = [&](const Prism &prism) {
        float result = 0.0f;
        for (const auto *corners : {&prism.top, &prism.drop}) {
            for (const auto &corner : *corners) {
                const auto  offset = corner - base;
                const float distance = vu::Dot3(normal, offset);
                if (std::fabs(distance) > 1e-5f * length * std::sqrt(vu::Dot3(offset, offset))) {
                    if (result != 0.0f && (distance < 0.0f) != (result < 0.0f)) {
                        return 0.0f;
                    }
                    result = distance;
                }
            }
        }
        return result;
    };
    const float sa = side(a);
    const float sb = side(b);
    return sa != 0.0f && sb != 0.0f && (sa < 0.0f) != (sb < 0.0f);
}

void Emit(std::vector<uint32_t> &indices, uint32_t a, uint32_t b, uint32_t c, bool forward) {
    indices.insert(indices.end(), forward ? std::initializer_list<uint32_t>{a, b, c} : std::initializer_list<uint32_t>{a, c, b});
}

} // namespace

void AppendShadowPrism(const vu::Vec4 top[3], const vu::Vec4 drop[3], const vu::Vec4 &bias_dir,
                       const mgPortProjection &projection, std::vector<vu::SdwPrismTriangle> &out) {
    for (int j = 0; j < 3; ++j) {
        if (!InClipVolume(top[j], projection) || !InClipVolume(drop[j], projection)) {
            return;
        }
    }

    const float bias = kShadowDropBias * std::fabs(drop[0].z);
    vu::Vec4    biased[3];
    for (int j = 0; j < 3; ++j) {
        biased[j] = drop[j] + bias_dir * bias;
    }

    // Grazing triangles are rejected by SdwPrism's |thickness| <= 1e-4 |n||h| test, retail's |Q| <= 1e-4 up to scale.
    vu::SdwPrism(top, biased, out);
}

int mgCShadowMDT::CreateFacePacket(u_int * /*packet*/, mgCFace * /*face*/) {
    return 0;
}

uptr mgCShadowMDT::CreatePacket(mgCDrawManager * /*draw_manager*/) {
    for (mgFACE_GROUP *node = face_group; node != nullptr; node = node->next) {
        node->packet = nullptr;
        node->packet_size = 0;
    }

    return 0;
}

int mgCShadowMDT::CreateRenderInfoPacket(u_int * /*packet*/, float (*matrix)[4], mgRENDER_INFO *info) {
    if (!mgPortRendererReady() || !mgPortFrameOpen() || !mgPortInShadow()) {
        return 0;
    }

    static thread_local std::vector<gfx::Vertex3D> vertices;
    static thread_local std::vector<uint32_t>      indices;
    const mgPortProjection                         projection = mgPortCurrentProjection();
    mgShadowPortBuildMesh(*this, matrix, *info, projection, vertices, indices);
    if (indices.empty()) {
        return 0;
    }

    // Vertices are in eye space; the local transform carries them back to world so the display list's
    // interpolated camera can be applied on top.
    gfx::MeshTransform transform = mgPortMeshTransform(kIdentity);
    if (!gfx::InvertAffineTransform(transform.view, transform.local)) {
        return 0;
    }

    gfx::MeshConstants constants{};
    mgPortEyeToClip(projection, mgPortCurrentTarget(), constants.mvp);
    constants.flags = gfx::kMeshShadow;
    constants.diffuse[0] = kShadowDiffuse;
    constants.diffuse[1] = kShadowDiffuse;
    constants.diffuse[2] = kShadowDiffuse;
    constants.diffuse[3] = kShadowAlpha;

    const mgCDrawEnv &env = draw_env != nullptr ? *draw_env : info->draw_env[0];

    // Z-fail: a pixel's count is the number of volumes its surface lies inside. Colour is not written.
    gfx::DrawState volume = mgPortDrawState();
    mgPortApplyDrawEnv(volume, env);
    volume.blend = false;
    volume.alpha_test = false;
    volume.cull = gfx::CullMode::None;
    volume.depth_test = gfx::DepthTest::GEqual;
    volume.depth_write = false;
    volume.stencil_test = true;
    volume.stencil_front = VolumeFace(gfx::StencilOp::DecrementWrap);
    volume.stencil_back = VolumeFace(gfx::StencilOp::IncrementWrap);
    volume.color_write_mask = 0;

    // Shadow volumes are rebuilt from this tick's matrices, so the previous tick's must not be
    // interpolated into them.
    {
        mgPortInterpScope scope(this, kMgPortFrameTeleportDistance, false, true);
        mgPortDrawMeshImmediate(vertices, indices, constants, gfx::TextureBinding{}, volume, &transform);
    }

    return 0;
}

void mgShadowPortBuildMesh(const mgCShadowMDT &visual, float (*matrix)[4], mgRENDER_INFO &info,
                           const mgPortProjection &projection, std::vector<gfx::Vertex3D> &vertices,
                           std::vector<uint32_t> &indices) {
    sceVu0FMATRIX model_to_eye;
    sceVu0FMATRIX drop_to_eye;
    sceVu0FMATRIX shadow;
    mgMulMatrix(model_to_eye, info.view, matrix);
    mgMulMatrix(shadow, info.shadow, matrix);
    mgMulMatrix(drop_to_eye, info.view, shadow);
    const auto                             to_eye = ToMat(model_to_eye);
    const auto                             drop_eye = ToMat(drop_to_eye);
    const auto                             light = vu::Mul(ToMat(info.view), {.x = info.shadow_light_dir[0], .y = info.shadow_light_dir[1], .z = info.shadow_light_dir[2], .w = 0});
    const auto                             bias_dir = light * (1.0f / std::sqrt(vu::Dot3(light, light)));
    const auto                            &topology = ShadowTopology(visual);
    static thread_local std::vector<Prism> prisms;
    prisms.resize(topology.triangles.size());
    vertices.clear();
    indices.clear();
    vertices.reserve(prisms.size() * 6);
    indices.reserve(prisms.size() * 24);
    for (std::size_t t = 0; t < prisms.size(); ++t) {
        auto &prism = prisms[t];
        prism.valid = true;
        prism.sides.fill(true);
        for (int i = 0; i < 3; ++i) {
            prism.top[i] = vu::Mul(to_eye, topology.triangles[t][i]);
            prism.drop[i] = vu::Mul(drop_eye, topology.triangles[t][i]);
            prism.valid = prism.valid && InClipVolume(prism.top[i], projection) && InClipVolume(prism.drop[i], projection);
        }
        if (!prism.valid) {
            continue;
        }
        const float bias = kShadowDropBias * std::fabs(prism.drop[0].z);
        for (auto &corner : prism.drop) {
            corner = corner + bias_dir * bias;
        }
        prism.valid = vu::SdwPrismOrientation(prism.top.data(), prism.drop.data(), prism.down);
        if (!prism.valid) {
            continue;
        }
        prism.first = static_cast<uint32_t>(vertices.size());
        for (const auto *corners : {&prism.top, &prism.drop}) {
            for (const auto &corner : *corners) {
                gfx::Vertex3D vertex{};
                vertex.position[0] = corner.x;
                vertex.position[1] = corner.y;
                vertex.position[2] = corner.z;
                vertices.push_back(vertex);
            }
        }
    }
    // Decide each pair once and remove both copies together.
    for (std::size_t t = 0; t < prisms.size(); ++t) {
        auto &prism = prisms[t];
        if (!prism.valid) {
            continue;
        }
        for (int edge = 0; edge < 3; ++edge) {
            const int32_t link = topology.neighbours[t][edge];
            if (link < 0) {
                continue;
            }
            const auto other = static_cast<std::size_t>(link / 3);
            const int  other_edge = link % 3;
            if (t < other && prisms[other].valid && SideCancelled(prism, edge, prisms[other], other_edge)) {
                prism.sides[edge] = false;
                prisms[other].sides[other_edge] = false;
            }
        }
    }
    for (const auto &prism : prisms) {
        if (!prism.valid) {
            continue;
        }
        const auto first = prism.first;
        Emit(indices, first, first + 1, first + 2, prism.down);
        Emit(indices, first + 3, first + 4, first + 5, !prism.down);
        for (uint32_t edge = 0; edge < 3; ++edge) {
            if (!prism.sides[edge]) {
                continue;
            }
            const auto next = (edge + 1) % 3;
            Emit(indices, first + edge, first + 3 + edge, first + 3 + next, prism.down);
            Emit(indices, first + edge, first + 3 + next, first + next, prism.down);
        }
    }
}
