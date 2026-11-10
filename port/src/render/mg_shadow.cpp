#include "common.h"

#include <libgraph.h>
#include <libvu0.h>

#include <algorithm>
#include <array>
#include <bit>
#include <cmath>
#include <cstring>
#include <limits>
#include <map>
#include <span>
#include <unordered_map>
#include <utility>
#include <vector>

#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_shadow.hpp"
#include "mg_visual.hpp"
#include "profile.hpp"
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
constexpr std::size_t kShadowCacheEntries = 1024;

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

/**
 * Owns validated native triangles, cancellation links and exact computational position identities.
 */
struct Topology {
    std::vector<Triangle>                triangles;        /**< Owned source triangles compared before reuse. */
    std::vector<Neighbours>              neighbours;       /**< Existing exact cancellation links. */
    std::vector<vu::Vec4>                memo_positions;   /**< Raw-exact representatives and separately evaluated variants with homogeneous one. */
    std::vector<std::array<uint32_t, 3>> corner_positions; /**< Original triangle corners mapped to exact source positions. */
};

/**
 * Selects the game-thread evaluator while retaining the original reference expressions.
 */
thread_local dc2::render::ShadowTransformMode shadow_transform_mode = dc2::render::ShadowTransformMode::Memoized;
/**
 * Accumulates bounded game-thread shadow construction counters.
 */
thread_local dc2::render::ShadowMeshStats shadow_mesh_stats;

// Position identities weld duplicated seam vertices without depending on the visual's index layout.
std::array<uint32_t, 3> PositionKey(const vu::Vec4 &p) {
    return {std::bit_cast<uint32_t>(p.x + 0.0f), std::bit_cast<uint32_t>(p.y + 0.0f), std::bit_cast<uint32_t>(p.z + 0.0f)};
}

/**
 * Retains independent cancellation identity and the first raw computational representative.
 */
struct Position {
    uint32_t adjacency_id;   /**< First-seen normalized position identity for edge construction. */
    uint32_t representative; /**< First source position retained with its exact raw bits. */
};

/**
 * Orders one triangle edge by its normalized endpoints and source location.
 */
struct Edge {
    uint64_t key;      /**< Sorted endpoint identities packed into one key. */
    uint32_t triangle; /**< Source triangle owning the edge. */
    uint32_t edge;     /**< Original corner starting the edge. */
    auto     operator<=>(const Edge &) const = default;
};

/**
 * Reuses exact normalized position identities without allocating one node per position.
 */
class PositionTable {
    /**
     * Stores one occupied normalized key and its first-seen position identity.
     */
    struct Bucket {
        std::array<uint32_t, 3> key{};            /**< Exact normalized XYZ bits. */
        Position                position{};       /**< First-seen adjacency and computational representative. */
        bool                    occupied = false; /**< Whether the key participates in this rebuild. */
    };

    std::vector<Bucket>      buckets;              /**< Power-of-two table with at most half its buckets occupied. */
    std::vector<std::size_t> occupied_slots;       /**< Buckets to clear before the next rebuild. */
    uint32_t                 unique_positions = 0; /**< Number of first-seen normalized keys in source order. */

    /**
     * Mixes all normalized coordinate bits before power-of-two bucket selection.
     */
    static std::size_t Hash(const std::array<uint32_t, 3> &key) {
        uint64_t hash = 0x9e3779b97f4a7c15ULL;
        for (const auto component : key) {
            hash ^= component;
            hash *= 0xbf58476d1ce4e5b9ULL;
            hash ^= hash >> 27;
        }
        return static_cast<std::size_t>(hash);
    }

public:
    /**
     * Clears the previous rebuild and provides checked capacity for every source corner.
     */
    bool Reset(std::size_t corners) {
        for (const auto slot : occupied_slots) {
            buckets[slot].occupied = false;
        }
        occupied_slots.clear();
        unique_positions = 0;
        if (!std::in_range<uint32_t>(corners) || corners > std::numeric_limits<std::size_t>::max() / 2) {
            return false;
        }
        const auto  required = std::max<std::size_t>(2, corners * 2);
        std::size_t capacity = 2;
        while (capacity < required) {
            if (capacity > std::numeric_limits<std::size_t>::max() / 2) {
                return false;
            }
            capacity *= 2;
        }
        if (buckets.size() < capacity) {
            buckets.resize(capacity);
        }
        occupied_slots.reserve(corners);
        return true;
    }

    /**
     * Resolves an exact key while preserving source-order identity and representative assignment.
     */
    std::pair<Position, bool> FindOrInsert(const std::array<uint32_t, 3> &key, uint32_t representative) {
        auto slot = Hash(key) & (buckets.size() - 1);
        while (buckets[slot].occupied) {
            if (buckets[slot].key == key) {
                return {buckets[slot].position, false};
            }
            slot = (slot + 1) & (buckets.size() - 1);
        }
        auto &bucket = buckets[slot];
        bucket.key = key;
        bucket.position = {.adjacency_id = unique_positions++, .representative = representative};
        bucket.occupied = true;
        occupied_slots.push_back(slot);
        return {bucket.position, true};
    }
};

/**
 * Rebuilds exact corner identities and cancellation links using the selected position lookup.
 */
template <class Lookup>
void RebuildTopology(Topology &entry, std::span<const Triangle> triangles, Lookup lookup, std::vector<Edge> &edges) {
    entry.triangles.assign(triangles.begin(), triangles.end());
    entry.neighbours.assign(triangles.size(), {-1, -1, -1});
    entry.memo_positions.clear();
    entry.corner_positions.resize(triangles.size());
    edges.clear();
    edges.reserve(triangles.size() * 3);
    for (uint32_t t = 0; t < triangles.size(); ++t) {
        std::array<uint32_t, 3> ids{};
        for (int corner = 0; corner < 3; ++corner) {
            const auto &source = triangles[t][corner];
            const auto [position, inserted] = lookup(PositionKey(source), static_cast<uint32_t>(entry.memo_positions.size()));
            const auto raw_key = [](const vu::Vec4 &point) {
                return std::array{std::bit_cast<uint32_t>(point.x), std::bit_cast<uint32_t>(point.y), std::bit_cast<uint32_t>(point.z)};
            };
            uint32_t computational_id = position.representative;
            // Unmatched raw variants remain separate without another lookup or bucket allocation.
            if (inserted || raw_key(entry.memo_positions[computational_id]) != raw_key(source)) {
                computational_id = static_cast<uint32_t>(entry.memo_positions.size());
                entry.memo_positions.push_back(source);
            }
            entry.corner_positions[t][static_cast<std::size_t>(corner)] = computational_id;
            ids[corner] = position.adjacency_id;
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
}

/**
 * Builds topology through the original ordered-map identity lookup for independent comparison.
 */
void RebuildReferenceTopology(Topology &entry, std::span<const Triangle> triangles, std::vector<Edge> &edges) {
    std::map<std::array<uint32_t, 3>, Position> positions;
    RebuildTopology(entry, triangles, [&](const auto &key, uint32_t representative) {
        const auto [position,inserted]=positions.try_emplace(key,Position{.adjacency_id=static_cast<uint32_t>(positions.size()),.representative=representative});
        return std::pair{position->second,inserted}; }, edges);
}

Topology &ShadowTopology(const mgCShadowMDT &visual) {
    CT_PROFILE_ZONE("Build native shadow topology");
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
    static thread_local std::vector<Edge> edges;
    if (shadow_transform_mode == dc2::render::ShadowTransformMode::Reference) {
        static thread_local Topology          reference;
        static thread_local std::vector<Edge> reference_edges;
        ++shadow_mesh_stats.topology_rebuilds;
        RebuildReferenceTopology(reference, triangles, reference_edges);
        return reference;
    }
    // Cached geometry is owned, never read through retired arena pointers, and compared before reuse.
    if (cache.size() >= kShadowCacheEntries && !cache.contains(&visual)) {
        cache.clear();
    }
    auto &entry = cache[&visual];
    if (entry.triangles.size() == triangles.size() &&
        (triangles.empty() || std::memcmp(entry.triangles.data(), triangles.data(), triangles.size() * sizeof(Triangle)) == 0)) {
        ++shadow_mesh_stats.topology_hits;
        return entry;
    }
    ++shadow_mesh_stats.topology_rebuilds;
    static thread_local PositionTable positions;
    if (triangles.size() <= std::numeric_limits<std::size_t>::max() / 3 && positions.Reset(triangles.size() * 3)) {
        RebuildTopology(entry, triangles, [&](const auto &key, uint32_t representative) { return positions.FindOrInsert(key, representative); }, edges);
    } else {
        RebuildReferenceTopology(entry, triangles, edges);
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
    {
        CT_PROFILE_ZONE("Build native shadow mesh");
        mgShadowPortBuildMesh(*this, matrix, *info, projection, vertices, indices);
    }
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

namespace dc2::render {

ShadowTransformMode SetShadowTransformMode(ShadowTransformMode mode) {
    return std::exchange(shadow_transform_mode, mode);
}

ShadowMeshStats GetShadowMeshStats() { return shadow_mesh_stats; }

} // namespace dc2::render

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
    const bool memoized = shadow_transform_mode == dc2::render::ShadowTransformMode::Memoized;
    ++shadow_mesh_stats.draws;
    shadow_mesh_stats.memoized_draws += memoized ? 1 : 0;
    shadow_mesh_stats.reference_draws += memoized ? 0 : 1;
    shadow_mesh_stats.source_corners += topology.triangles.size() * 3;
    shadow_mesh_stats.transformed_positions += memoized ? topology.memo_positions.size() : topology.triangles.size() * 3;

    /**
     * Retains one draw's pure corner expressions without sharing per-triangle bias.
     */
    struct TransformedPosition {
        vu::Vec4 top{};         /**< Original model-to-eye result. */
        vu::Vec4 drop{};        /**< Original receiving-plane result before bias. */
        bool     valid = false; /**< Original unbiased clip predicate. */
    };

    static thread_local std::vector<TransformedPosition> transformed;
    if (memoized) {
        transformed.resize(topology.memo_positions.size());
        for (std::size_t index = 0; index < transformed.size(); ++index) {
            auto &position = transformed[index];
            position.top = vu::Mul(to_eye, topology.memo_positions[index]);
            position.drop = vu::Mul(drop_eye, topology.memo_positions[index]);
            position.valid = InClipVolume(position.top, projection) && InClipVolume(position.drop, projection);
        }
    }
    vertices.clear();
    indices.clear();
    vertices.reserve(prisms.size() * 6);
    indices.reserve(prisms.size() * 24);
    for (std::size_t t = 0; t < prisms.size(); ++t) {
        auto &prism = prisms[t];
        prism.valid = true;
        prism.sides.fill(true);
        for (int i = 0; i < 3; ++i) {
            if (memoized) {
                const auto &position = transformed[topology.corner_positions[t][static_cast<std::size_t>(i)]];
                prism.top[i] = position.top;
                prism.drop[i] = position.drop;
                prism.valid = prism.valid && position.valid;
            } else {
                prism.top[i] = vu::Mul(to_eye, topology.triangles[t][i]);
                prism.drop[i] = vu::Mul(drop_eye, topology.triangles[t][i]);
                prism.valid = prism.valid && InClipVolume(prism.top[i], projection) && InClipVolume(prism.drop[i], projection);
            }
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
