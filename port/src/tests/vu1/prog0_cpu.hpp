#pragma once

#include <array>
#include <cstdint>
#include <span>
#include <vector>

#include "vu1/vu1_math.hpp"

namespace dc::vu1 {

enum Prog0Flag : uint32_t {
    kProg0Clip = 0x001,
    kProg0Scissor = 0x002,
    kProg0Facing = 0x004,
    kProg0RealLighting = 0x008,
    kProg0PointLights = 0x010,
    kProg0LightingOff = 0x020,
    kProg0VertexBlend = 0x040,
    kProg0VcAdd = 0x080,
    kProg0RefSphere = 0x100,
};

enum Prog0Type : uint32_t {
    kProg0NoTexture = 0x010,
    kProg0Colour = 0x100,
    kProg0NoNormal = 0x200,
    kProg0PrimMask = 0x007,
    kProg0PrimStrip = 0x004,
};

enum class Prog0Lighting {
    Off,
    Lighting,
    Real,
    PointLighting
};
enum class Prog0Clip {
    None,
    ClipScis,
    ClipScisStrip
};
enum class Prog0Output {
    Output,
    OutputC,
    OutputCN,
    OutputCNStrip
};

struct Prog0Pipeline {
    bool          ref_sphere;
    bool          vertex_blend;
    Prog0Lighting lighting;
    bool          vertex_colour;
    bool          vc_add;
    Prog0Clip     clip;
    Prog0Output   output;

    bool operator==(const Prog0Pipeline &) const = default;
};

Prog0Pipeline SelectProg0Pipeline(uint32_t flags, uint32_t type);

// Variant index 0..7: colour (1), no texture (2), no normal (4). Same encoding for skinned rows.
int Prog0HeaderVariant(uint32_t type);

struct Prog0Header {
    uint32_t v_count;
    uint32_t n_count;
    uint32_t c_count;
    uint32_t type;
};

Prog0Header PackProg0Header(uint32_t type, uint32_t n, bool skinned);

struct Prog0Offsets {
    int v;
    int normal;
    int uv;
    int colour;
    int weight;
};

Prog0Offsets Prog0InputOffsets(int tops, const Prog0Header &header);

int Prog0BatchLimit(int vu1_offset, bool colour, bool skinned);

uint32_t Prog0ClipCode(Vec4 clip);
uint32_t Prog0PushClipCode(uint32_t cf, uint32_t code);

enum class Prog0ClipClass {
    Keep,
    Reject,
    Partial
};
Prog0ClipClass Prog0ClassifyTriangle(uint32_t cf);

struct Prog0ClipVertex {
    Vec4 pos;
    Vec4 colour;
    Vec4 uv;
};

inline constexpr int kProg0ClipCapacity = 20;

struct Prog0ClipPolygon {
    std::array<Prog0ClipVertex, kProg0ClipCapacity> v;
    int                                             count;
    bool                                            overflow;
};

// Planes in spec order: 0 Z-, 1 Z+, 2 X-, 3 X+, 4 Y-, 5 Y+.
Prog0ClipPolygon Prog0ClipPlane(const Prog0ClipPolygon &in, int plane);
Prog0ClipPolygon Prog0ClipTriangle(const std::array<Prog0ClipVertex, 3> &tri);

struct Prog0ScreenVertex {
    Vec4                   screen; // x, y, z in GS units after the divide; w = F'
    Vec4                   st;
    std::array<int32_t, 4> rgbaq;
};

Prog0ScreenVertex Prog0ToScreen(const Prog0ClipVertex &v, const Mat4 &clip_screen, const Fog &fog);

// Triangle index i of a fan over n vertices is (0, i+1, i+2).
std::array<int, 3> Prog0FanTriangle(int tri);
uint32_t           Prog0ClipPacketTag(int n_out);

// Guard bits 0x80 (x), 0x40 (y), 0x10 (w). screen.w is Q = 1/w.
uint32_t Prog0GuardBits(Vec4 screen, Vec4 g_min, Vec4 g_max, float inv_far, float inv_near);

// 0x20 when cross.z < 0 for cross = (v2 - v0) x (v1 - v0).
uint32_t Prog0OrientBit(Vec4 v0, Vec4 v1, Vec4 v2);

struct Prog0Facing {
    bool keep;
    int  adc_vertex; // 2 when dropped by ADC on the third vertex, -1 otherwise
};

// mirror is QW[30].x as an integer: 0 or 32.
Prog0Facing Prog0ListFacing(const std::array<Vec4, 3> &v, const std::array<uint32_t, 3> &guard, uint32_t mirror);
bool        Prog0ClipFacingKeep(Vec4 p0, Vec4 p1, Vec4 p2, uint32_t mirror);

// The window carry is the in-flags of the two vertices before the next one. A draw starts with
// both out: vertices 0 and 1 of a draw are inert, since no list triangle and no strip triangle
// completes on them (7.1, 7.3).
struct Prog0Window {
    bool in_prev2 = false;
    bool in_prev1 = false;
};

// OUTPUTC window ADC (7.1). guard holds the Prog0GuardBits words of one batch.
std::vector<bool> Prog0WindowAdc(std::span<const uint32_t> guard, Prog0Window &carry);

struct Prog0StripWindow {
    Prog0Window window;
    Vec4        pos_prev2 = {};
    Vec4        pos_prev1 = {};
};

// OUTPUTCN_STR facing and ADC (7.3) for one batch. screen and guard have equal length; mirror is 0 or 32.
std::vector<bool> Prog0StripAdc(std::span<const Vec4> screen, std::span<const uint32_t> guard, uint32_t mirror,
                                Prog0StripWindow &carry);

// Parity sign for triangle t = 0..vertex_num-3 of a strip cut into batches of batch_limit vertices.
// The parity belongs to the batch-local completing vertex and restarts at every batch (O-5).
std::vector<int> Prog0StripParity(int vertex_num, int batch_limit);

// Vertex order for triangle t whose retail parity is parity (+1 or -1). Prog0ListFacing on this
// order reproduces the Prog0StripAdc accept decision for the triangle.
std::array<int, 3> Prog0StripTriangle(int t, int parity);

struct GsXyzf {
    uint16_t x;
    uint16_t y;
    uint32_t z; // 24 bits
    uint8_t  f;
    bool     adc;
};

GsXyzf PackProg0Xyzf(Vec4 screen, float fog, bool adc);

Vec4  GsToNdc(Vec4 screen, float half_width, float half_height);
float GsZToDepth(uint32_t z24, float z_range);

} // namespace dc::vu1
