#pragma once

#include <cstdint>
#include <vector>

#include "render/renderer.hpp"
#include "vu1/sdw_geom.hpp"

namespace dc2::render {

/**
 * Selects memoized shadow construction or independent ordered-map topology and corner evaluation.
 */
enum class ShadowTransformMode {
    Memoized,
    Reference
};

/**
 * Counts game-thread shadow construction and exact transform reuse over its lifetime.
 */
struct ShadowMeshStats {
    std::uint64_t draws = 0;                 /**< Builder invocations. */
    std::uint64_t memoized_draws = 0;        /**< Invocations reusing raw-exact representative positions. */
    std::uint64_t reference_draws = 0;       /**< Invocations evaluating original triangle corners. */
    std::uint64_t source_corners = 0;        /**< Expanded triangle corners requested by the source. */
    std::uint64_t transformed_positions = 0; /**< Positions whose original transform expressions were evaluated. */
    std::uint64_t topology_hits = 0;         /**< Owned topology reuses after exact geometry comparison. */
    std::uint64_t topology_rebuilds = 0;     /**< Topology construction passes for changed geometry or independent reference evaluation. */
};

/**
 * Selects a game-thread shadow evaluation mode and returns its previous value.
 */
ShadowTransformMode SetShadowTransformMode(ShadowTransformMode mode);

/**
 * Snapshots game-thread lifetime shadow construction counters.
 */
ShadowMeshStats GetShadowMeshStats();

} // namespace dc2::render

// Appends the shadow prism of one caster triangle, or nothing when retail's clip rejects it: a corner
// (top or drop, eye space, before the drop bias) outside the projection's near/far range or the GS guard
// band. bias_dir lifts the drop corners off the receiving plane.
void AppendShadowPrism(const dc::vu1::Vec4 top[3], const dc::vu1::Vec4 drop[3], const dc::vu1::Vec4 &bias_dir,
                       const mgPortProjection &projection, std::vector<dc::vu1::SdwPrismTriangle> &out);

class mgCShadowMDT;
class mgRENDER_INFO;

/**
 * Builds indexed shadow prisms, omitting shared sides whose opposite windings cancel.
 */
void mgShadowPortBuildMesh(const mgCShadowMDT &visual, float (*matrix)[4], mgRENDER_INFO &info,
                           const mgPortProjection &projection, std::vector<gfx::Vertex3D> &vertices,
                           std::vector<uint32_t> &indices);
