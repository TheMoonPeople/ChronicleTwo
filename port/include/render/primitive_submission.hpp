#pragma once

#include <cstdint>
#include <functional>
#include <span>
#include <utility>
#include <vector>

#include "gfx/gfx.hpp"

class mgCDrawPrim;

using mgPortPrimSink = std::function<void(gfx::Primitive, std::span<const gfx::Vertex2D>, const gfx::TextureBinding &,
                                          const gfx::DrawState &)>;
// Replaces mgPortDraw2D as the primitive builder's destination while set; an empty function restores it. For tests.
void mgPortSetPrimSink(mgPortPrimSink sink);
// Registers the host draw that the draw manager replays where retail calls `packet`, replacing any earlier entry for it.
void mgPortSetPacketDraw(const void *packet, std::function<void()> draw);
// Removes the host draw registered for `packet`, if any.
void mgPortClearPacketDraw(const void *packet);
// Invalidates all transient host draws when mgBeginPacket resets their shared data arena.
void mgPortClearPacketDraws();
// Runs the host draw registered for `packet`; false when there is none, including a null packet.
bool mgPortPacketDraw(const void *packet);

/**
 * Draws what the builder has batched so far, so the primitives after it make a draw of their own, with their own
 * interpolation tag. Nothing pending draws nothing.
 */
void mgPortPrimFlush(const mgCDrawPrim &prim);
// Draws `vertices` as a list of Triangles, Lines or Quads with the builder's state. Mirrors Kick's flush and
// flat-shading rules, so an override draws what its retail caller would.
void mgPortPrimSubmit(mgCDrawPrim &prim, gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices);
// Host-owned texture, with the builder's state and ordering. Does not change the builder's retail binding.
void mgPortPrimSubmitTexture(mgCDrawPrim &prim, std::span<const gfx::Vertex2D> quads,
                             const gfx::TextureBinding &texture);
// Returns the UVs at p0 and p1 that cover the texels a nearest-filtered GS sprite samples across the pixel span.
// The corners may come in either order; each keeps its own UV.
std::pair<float, float> mgPortSpriteTexelSpan(float p0, float p1, float u0, float u1);
inline constexpr float  kMgPortNearestTexelBias = 1.0f / 64.0f;
void                    mgPortStripTriangles(std::span<const gfx::Vertex2D> strip, std::vector<gfx::Vertex2D> &out);
void                    mgPortPrimColor(const mgCDrawPrim &prim, uint8_t rgba[4]);
// `gs_x`/`gs_y` are given before GetOffset, which adds the screen offset that mgPortLogicalX takes back out.
gfx::Vertex2D mgPortPrimVertex(const mgCDrawPrim &prim, float gs_x, float gs_y, float gs_z, float u, float v,
                               const uint8_t rgba[4], uint8_t fog = 0xFF);
