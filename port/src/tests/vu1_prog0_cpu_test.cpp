#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstdint>
#include <random>
#include <span>
#include <vector>

#include "vu1/prog0_cpu.hpp"

namespace dc::vu1 {
namespace {

constexpr float kTol = 1e-3f;
constexpr float kZTol = 1.0f;

constexpr Vec4  kGuardMin{.x = 1.0f, .y = 1.0f, .z = 0.0f, .w = 10.0f};
constexpr Vec4  kGuardMax{.x = 4095.0f, .y = 4095.0f, .z = 0.0f, .w = 1000.0f};
constexpr float kInvFar = 1.0f / 1000.0f;
constexpr float kInvNear = 1.0f / 10.0f;

uint32_t TypeForVariant(int variant) {
    uint32_t type = 0;
    if (variant & 1) {
        type |= kProg0Colour;
    }
    if (variant & 2) {
        type |= kProg0NoTexture;
    }
    if (variant & 4) {
        type |= kProg0NoNormal;
    }
    return type;
}

void ExpectHeader(int variant, bool skinned, uint32_t dw0, uint32_t dw1, uint32_t dw2) {
    const uint32_t type = TypeForVariant(variant);
    EXPECT_EQ(Prog0HeaderVariant(type), variant);
    const Prog0Header h = PackProg0Header(type, 10, skinned);
    EXPECT_EQ(h.v_count, dw0);
    EXPECT_EQ(h.n_count, dw1);
    EXPECT_EQ(h.c_count, dw2);
    EXPECT_EQ(h.type, type);
}

Prog0Pipeline Pipe(bool ref_sphere, bool vertex_blend, Prog0Lighting lighting, bool vertex_colour, bool vc_add,
                   Prog0Clip clip, Prog0Output output) {
    return {.ref_sphere = ref_sphere, .vertex_blend = vertex_blend, .lighting = lighting, .vertex_colour = vertex_colour, .vc_add = vc_add, .clip = clip, .output = output};
}

// Vertex code bits: slot 0 at bits 17..12, slot 1 at 11..6, slot 2 at 5..0.
uint32_t CfBit(int slot, uint32_t code) {
    return code << (12 - 6 * slot);
}

std::array<Vec4, 3> Screen10_4() {
    return {
        {{.x = 2100.0f, .y = 2100.0f, .z = 0.0f, .w = 0.01f}, {.x = 2200.0f, .y = 2100.0f, .z = 0.0f, .w = 0.01f}, {.x = 2100.0f, .y = 2200.0f, .z = 0.0f, .w = 0.01f}}
    };
}

std::array<uint32_t, 3> Guards(const std::array<Vec4, 3> &v) {
    return {
        {Prog0GuardBits(v[0], kGuardMin, kGuardMax, kInvFar, kInvNear),
         Prog0GuardBits(v[1], kGuardMin, kGuardMax, kInvFar, kInvNear),
         Prog0GuardBits(v[2], kGuardMin, kGuardMax, kInvFar, kInvNear)}
    };
}

std::array<Prog0ClipVertex, 3> Triangle10_5() {
    return {
        {
         {.pos = {.x = 0.0f, .y = 0.0f, .z = 1.0f, .w = 2.0f}, .colour = {.x = 255.0f, .y = 0.0f, .z = 0.0f, .w = 255.0f}, .uv = {.x = 0.0f, .y = 0.0f, .z = 1.0f, .w = 0.0f}},
         {.pos = {.x = 1.0f, .y = 0.0f, .z = 0.0f, .w = 2.0f}, .colour = {.x = 0.0f, .y = 255.0f, .z = 0.0f, .w = 255.0f}, .uv = {.x = 1.0f, .y = 0.0f, .z = 1.0f, .w = 0.0f}},
         {.pos = {.x = 0.0f, .y = 1.0f, .z = -3.0f, .w = 1.0f}, .colour = {.x = 0.0f, .y = 0.0f, .z = 255.0f, .w = 255.0f}, .uv = {.x = 0.0f, .y = 1.0f, .z = 1.0f, .w = 0.0f}},
         }
    };
}

Prog0ClipPolygon AsPolygon(const std::array<Prog0ClipVertex, 3> &tri) {
    Prog0ClipPolygon poly{};
    for (int i = 0; i < 3; ++i) {
        poly.v[i] = tri[i];
    }
    poly.count = 3;
    return poly;
}

Mat4 ClipScreen10_5() {
    return {
        {{.x = 256.0f, .y = 0.0f, .z = 0.0f, .w = 0.0f},
         {.x = 0.0f, .y = 256.0f, .z = 0.0f, .w = 0.0f},
         {.x = 0.0f, .y = 0.0f, .z = -8350000.0f, .w = 0.0f},
         {.x = 2048.0f, .y = 2048.0f, .z = 8350000.0f, .w = 1.0f}}
    };
}

// Editor fog: mgSetFogParam(50, 400, ..., far_value = 255, near_value = 0). Yields F' = 255 everywhere.
Fog EditorFog() {
    return MakeFog(50.0f, 400.0f, 255.0f, 0.0f);
}

// Spec 10.3 fog: mgSetFogParam(10, 1000, ..., far_value = 0, near_value = 255).
Fog NormalFog() {
    return MakeFog(10.0f, 1000.0f, 0.0f, 255.0f);
}

TEST(Vu1Prog0Cpu, Vector10_3FogAtNear) {
    EXPECT_NEAR(FogValue(NormalFog(), 0.1f), 255.0f, kTol);
}

TEST(Vu1Prog0Cpu, Vector10_3FogAtFar) {
    EXPECT_NEAR(FogValue(NormalFog(), 0.001f), 0.0f, kTol);
}

TEST(Vu1Prog0Cpu, Vector10_3FogMidDepth) {
    EXPECT_NEAR(FogValue(NormalFog(), 0.01f), 23.182f, kTol);
}

TEST(Vu1Prog0Cpu, Vector10_3PackedMidDepthF23Adc0) {
    const float  fog = FogValue(NormalFog(), 0.01f);
    const GsXyzf p = PackProg0Xyzf(Vec4{.x = 2048.0f, .y = 2048.0f, .z = 0.0f, .w = 0.0f}, fog, false);
    EXPECT_EQ(p.f, 23);
    EXPECT_FALSE(p.adc);
}

TEST(Vu1Prog0Cpu, Vector10_3EditorFogPacksF255Adc0) {
    const float fog = FogValue(EditorFog(), 0.01f);
    EXPECT_EQ(fog, 255.0f);
    const GsXyzf p = PackProg0Xyzf(Vec4{.x = 2048.0f, .y = 2048.0f, .z = 0.0f, .w = 0.0f}, fog, false);
    EXPECT_EQ(p.f, 255);
    EXPECT_FALSE(p.adc);
}

TEST(Vu1Prog0Cpu, Vector10_4GuardBitsInsideGive208) {
    const std::array<Vec4, 3>     v = Screen10_4();
    const std::array<uint32_t, 3> g = Guards(v);
    EXPECT_EQ(g[0], 0xD0u);
    EXPECT_EQ(g[1], 0xD0u);
    EXPECT_EQ(g[2], 0xD0u);
    EXPECT_EQ(g[0] & g[1] & g[2], 208u);
}

TEST(Vu1Prog0Cpu, Vector10_4GuardBitsOutsideClearOwnBit) {
    EXPECT_EQ(Prog0GuardBits(Vec4{5000.0f, 2100.0f, 0.0f, 0.01f}, kGuardMin, kGuardMax, kInvFar, kInvNear), 0x50u);
    EXPECT_EQ(Prog0GuardBits(Vec4{2100.0f, 2100.0f, 0.0f, 0.2f}, kGuardMin, kGuardMax, kInvFar, kInvNear), 0xC0u);
    EXPECT_EQ(Prog0GuardBits(Vec4{2100.0f, 2100.0f, 0.0f, 0.0005f}, kGuardMin, kGuardMax, kInvFar, kInvNear), 0xC0u);
}

TEST(Vu1Prog0Cpu, Vector10_4OrientBitFollowsCrossZSign) {
    const std::array<Vec4, 3> v = Screen10_4();
    EXPECT_EQ(Prog0OrientBit(v[0], v[1], v[2]), 0x20u);
    EXPECT_EQ(Prog0OrientBit(v[0], v[2], v[1]), 0x00u);
}

TEST(Vu1Prog0Cpu, Vector10_4UnmirroredRejects) {
    const std::array<Vec4, 3> v = Screen10_4();
    const Prog0Facing         f = Prog0ListFacing(v, Guards(v), 0);
    EXPECT_FALSE(f.keep);
    EXPECT_EQ(f.adc_vertex, 2);
}

TEST(Vu1Prog0Cpu, Vector10_4MirroredAccepts) {
    const std::array<Vec4, 3> v = Screen10_4();
    const Prog0Facing         f = Prog0ListFacing(v, Guards(v), 32);
    EXPECT_TRUE(f.keep);
    EXPECT_EQ(f.adc_vertex, -1);
}

TEST(Vu1Prog0Cpu, Vector10_4ReversedUnmirroredAccepts) {
    const std::array<Vec4, 3> v = Screen10_4();
    const std::array<Vec4, 3> r = {
        {v[0], v[2], v[1]}
    };
    const Prog0Facing f = Prog0ListFacing(r, Guards(r), 0);
    EXPECT_TRUE(f.keep);
    EXPECT_EQ(f.adc_vertex, -1);
}

TEST(Vu1Prog0Cpu, Vector10_4ReversedMirroredRejects) {
    const std::array<Vec4, 3> v = Screen10_4();
    const std::array<Vec4, 3> r = {
        {v[0], v[2], v[1]}
    };
    const Prog0Facing f = Prog0ListFacing(r, Guards(r), 32);
    EXPECT_FALSE(f.keep);
    EXPECT_EQ(f.adc_vertex, 2);
}

TEST(Vu1Prog0Cpu, Vector10_5InputClipCodes) {
    const std::array<Prog0ClipVertex, 3> tri = Triangle10_5();
    EXPECT_EQ(Prog0ClipCode(tri[0].pos), 0x00u);
    EXPECT_EQ(Prog0ClipCode(tri[1].pos), 0x00u);
    EXPECT_EQ(Prog0ClipCode(tri[2].pos), 0x20u);
}

TEST(Vu1Prog0Cpu, Vector10_5ZMinusPassIntermediates) {
    const Prog0ClipPolygon out = Prog0ClipPlane(AsPolygon(Triangle10_5()), 0);
    ASSERT_EQ(out.count, 4);
    EXPECT_FALSE(out.overflow);

    const Prog0ClipVertex &i12 = out.v[2];
    EXPECT_NEAR(i12.pos.x, 0.5f, kTol);
    EXPECT_NEAR(i12.pos.y, 0.5f, kTol);
    EXPECT_NEAR(i12.pos.z, -1.5f, kTol);
    EXPECT_NEAR(i12.pos.w, 1.5f, kTol);
    EXPECT_NEAR(i12.colour.x, 0.0f, kTol);
    EXPECT_NEAR(i12.colour.y, 127.5f, kTol);
    EXPECT_NEAR(i12.colour.z, 127.5f, kTol);
    EXPECT_NEAR(i12.colour.w, 255.0f, kTol);
    EXPECT_NEAR(i12.uv.x, 0.5f, kTol);
    EXPECT_NEAR(i12.uv.y, 0.5f, kTol);
    EXPECT_NEAR(i12.uv.z, 1.0f, kTol);
    EXPECT_EQ(i12.uv.w, 0.0f);

    const Prog0ClipVertex &i23 = out.v[3];
    EXPECT_NEAR(i23.pos.x, 0.0f, kTol);
    EXPECT_NEAR(i23.pos.y, 0.6f, kTol);
    EXPECT_NEAR(i23.pos.z, -1.4f, kTol);
    EXPECT_NEAR(i23.pos.w, 1.4f, kTol);
    EXPECT_NEAR(i23.colour.x, 102.0f, kTol);
    EXPECT_NEAR(i23.colour.y, 0.0f, kTol);
    EXPECT_NEAR(i23.colour.z, 153.0f, kTol);
    EXPECT_NEAR(i23.colour.w, 255.0f, kTol);
    EXPECT_NEAR(i23.uv.x, 0.0f, kTol);
    EXPECT_NEAR(i23.uv.y, 0.6f, kTol);
    EXPECT_NEAR(i23.uv.z, 1.0f, kTol);
    EXPECT_EQ(i23.uv.w, 0.0f);
}

TEST(Vu1Prog0Cpu, Vector10_5NOutIsFourAfterAllPlanes) {
    const Prog0ClipPolygon poly = Prog0ClipTriangle(Triangle10_5());
    EXPECT_EQ(poly.count, 4);
    EXPECT_FALSE(poly.overflow);
}

TEST(Vu1Prog0Cpu, Vector10_5ScreenRecords) {
    const Prog0ClipPolygon poly = Prog0ClipTriangle(Triangle10_5());
    ASSERT_EQ(poly.count, 4);
    const Mat4              m = ClipScreen10_5();
    const Fog               fog = EditorFog();
    const Prog0ScreenVertex p0 = Prog0ToScreen(poly.v[0], m, fog);
    const Prog0ScreenVertex p1 = Prog0ToScreen(poly.v[1], m, fog);
    const Prog0ScreenVertex p2 = Prog0ToScreen(poly.v[2], m, fog);
    const Prog0ScreenVertex p3 = Prog0ToScreen(poly.v[3], m, fog);

    EXPECT_NEAR(p0.screen.x, 2048.0f, kTol);
    EXPECT_NEAR(p0.screen.y, 2048.0f, kTol);
    EXPECT_NEAR(p0.screen.z, 4175000.0f, kZTol);
    EXPECT_NEAR(p1.screen.x, 2176.0f, kTol);
    EXPECT_NEAR(p1.screen.y, 2048.0f, kTol);
    EXPECT_NEAR(p1.screen.z, 8350000.0f, kZTol);
    EXPECT_NEAR(p2.screen.x, 2133.3333f, kTol);
    EXPECT_NEAR(p2.screen.y, 2133.3333f, kTol);
    EXPECT_NEAR(p2.screen.z, 16700000.0f, kZTol);
    EXPECT_NEAR(p3.screen.x, 2048.0f, kTol);
    EXPECT_NEAR(p3.screen.y, 2157.7143f, kTol);
    EXPECT_NEAR(p3.screen.z, 16700000.0f, kZTol);

    EXPECT_EQ(p0.screen.w, 255.0f);
    EXPECT_EQ(p1.screen.w, 255.0f);
    EXPECT_EQ(p2.screen.w, 255.0f);
    EXPECT_EQ(p3.screen.w, 255.0f);
}

TEST(Vu1Prog0Cpu, Vector10_5StAndRgbaq) {
    const Prog0ClipPolygon poly = Prog0ClipTriangle(Triangle10_5());
    ASSERT_EQ(poly.count, 4);
    const Mat4              m = ClipScreen10_5();
    const Fog               fog = EditorFog();
    const Prog0ScreenVertex p0 = Prog0ToScreen(poly.v[0], m, fog);
    const Prog0ScreenVertex p1 = Prog0ToScreen(poly.v[1], m, fog);
    const Prog0ScreenVertex p2 = Prog0ToScreen(poly.v[2], m, fog);
    const Prog0ScreenVertex p3 = Prog0ToScreen(poly.v[3], m, fog);

    EXPECT_NEAR(p0.st.x, 0.0f, kTol);
    EXPECT_NEAR(p0.st.y, 0.0f, kTol);
    EXPECT_NEAR(p0.st.z, 0.5f, kTol);
    EXPECT_NEAR(p1.st.x, 0.5f, kTol);
    EXPECT_NEAR(p1.st.y, 0.0f, kTol);
    EXPECT_NEAR(p1.st.z, 0.5f, kTol);
    EXPECT_NEAR(p2.st.x, 0.3333f, kTol);
    EXPECT_NEAR(p2.st.y, 0.3333f, kTol);
    EXPECT_NEAR(p2.st.z, 0.6667f, kTol);
    EXPECT_NEAR(p3.st.x, 0.0f, kTol);
    EXPECT_NEAR(p3.st.y, 0.4286f, kTol);
    EXPECT_NEAR(p3.st.z, 0.7143f, kTol);

    EXPECT_EQ(p0.rgbaq, (std::array<int32_t, 4>{255, 0, 0, 255}));
    EXPECT_EQ(p1.rgbaq, (std::array<int32_t, 4>{0, 255, 0, 255}));
    EXPECT_EQ(p2.rgbaq, (std::array<int32_t, 4>{0, 127, 127, 255}));
    EXPECT_EQ(p3.rgbaq, (std::array<int32_t, 4>{102, 0, 153, 255}));
}

TEST(Vu1Prog0Cpu, Vector10_5XyzfPacked) {
    const Prog0ClipPolygon poly = Prog0ClipTriangle(Triangle10_5());
    ASSERT_EQ(poly.count, 4);
    const Mat4 m = ClipScreen10_5();
    const Fog  fog = EditorFog();

    const GsXyzf x0 = PackProg0Xyzf(Prog0ToScreen(poly.v[0], m, fog).screen, 255.0f, false);
    EXPECT_EQ(x0.x, 32768);
    EXPECT_EQ(x0.y, 32768);
    EXPECT_EQ(x0.z, 4175000u);

    const GsXyzf x1 = PackProg0Xyzf(Prog0ToScreen(poly.v[1], m, fog).screen, 255.0f, false);
    EXPECT_EQ(x1.x, 34816);
    EXPECT_EQ(x1.y, 32768);
    EXPECT_EQ(x1.z, 8350000u);

    const GsXyzf x2 = PackProg0Xyzf(Prog0ToScreen(poly.v[2], m, fog).screen, 255.0f, false);
    EXPECT_EQ(x2.x, 34133);
    EXPECT_EQ(x2.y, 34133);
    EXPECT_EQ(x2.z, 16700000u);

    const GsXyzf x3 = PackProg0Xyzf(Prog0ToScreen(poly.v[3], m, fog).screen, 255.0f, false);
    EXPECT_EQ(x3.x, 32768);
    EXPECT_EQ(x3.y, 34523);
    EXPECT_EQ(x3.z, 16700000u);
}

TEST(Vu1Prog0Cpu, Vector10_5PacketTagAndFan) {
    EXPECT_EQ(Prog0ClipPacketTag(4), 0x8004u);
    EXPECT_EQ(Prog0FanTriangle(0), (std::array<int, 3>{0, 1, 2}));
    EXPECT_EQ(Prog0FanTriangle(1), (std::array<int, 3>{0, 2, 3}));
}

TEST(Vu1Prog0Cpu, Vector10_5CullMirror0Culled) {
    const Prog0ClipPolygon poly = Prog0ClipTriangle(Triangle10_5());
    ASSERT_EQ(poly.count, 4);
    const Mat4 m = ClipScreen10_5();
    const Fog  fog = EditorFog();
    const Vec4 p0 = Prog0ToScreen(poly.v[0], m, fog).screen;
    const Vec4 p1 = Prog0ToScreen(poly.v[1], m, fog).screen;
    const Vec4 p2 = Prog0ToScreen(poly.v[2], m, fog).screen;
    EXPECT_EQ(Prog0OrientBit(p0, p1, p2), 0x20u);
    EXPECT_FALSE(Prog0ClipFacingKeep(p0, p1, p2, 0));
}

TEST(Vu1Prog0Cpu, Vector10_5CullMirror32Kept) {
    const Prog0ClipPolygon poly = Prog0ClipTriangle(Triangle10_5());
    ASSERT_EQ(poly.count, 4);
    const Mat4 m = ClipScreen10_5();
    const Fog  fog = EditorFog();
    const Vec4 p0 = Prog0ToScreen(poly.v[0], m, fog).screen;
    const Vec4 p1 = Prog0ToScreen(poly.v[1], m, fog).screen;
    const Vec4 p2 = Prog0ToScreen(poly.v[2], m, fog).screen;
    EXPECT_TRUE(Prog0ClipFacingKeep(p0, p1, p2, 32));
}

TEST(Vu1Prog0Cpu, DecisionNoNormalOverridesLighting) {
    EXPECT_EQ(SelectProg0Pipeline(0x018, 0x200),
              Pipe(false, false, Prog0Lighting::Off, false, false, Prog0Clip::None, Prog0Output::Output));
}

TEST(Vu1Prog0Cpu, DecisionLightingOffFlag) {
    EXPECT_EQ(SelectProg0Pipeline(0x020, 0x000),
              Pipe(false, false, Prog0Lighting::Off, false, false, Prog0Clip::None, Prog0Output::Output));
}

TEST(Vu1Prog0Cpu, DecisionLightingOffWithScissorClips) {
    EXPECT_EQ(SelectProg0Pipeline(0x023, 0x000),
              Pipe(false, false, Prog0Lighting::Off, false, false, Prog0Clip::ClipScis, Prog0Output::OutputC));
}

TEST(Vu1Prog0Cpu, DecisionRowNoFlags) {
    EXPECT_EQ(SelectProg0Pipeline(0x000, 0x000),
              Pipe(false, false, Prog0Lighting::Lighting, false, false, Prog0Clip::None, Prog0Output::Output));
    EXPECT_EQ(SelectProg0Pipeline(0x000, 0x004),
              Pipe(false, false, Prog0Lighting::Lighting, false, false, Prog0Clip::None, Prog0Output::Output));
}

TEST(Vu1Prog0Cpu, DecisionRowClipOnlyUsesOutputC) {
    EXPECT_EQ(SelectProg0Pipeline(0x001, 0x000),
              Pipe(false, false, Prog0Lighting::Lighting, false, false, Prog0Clip::None, Prog0Output::OutputC));
    EXPECT_EQ(SelectProg0Pipeline(0x001, 0x004),
              Pipe(false, false, Prog0Lighting::Lighting, false, false, Prog0Clip::None, Prog0Output::OutputC));
}

TEST(Vu1Prog0Cpu, DecisionRowFacingList) {
    EXPECT_EQ(SelectProg0Pipeline(0x004, 0x000),
              Pipe(false, false, Prog0Lighting::Lighting, false, false, Prog0Clip::None, Prog0Output::OutputCN));
}

TEST(Vu1Prog0Cpu, DecisionRowFacingStrip) {
    EXPECT_EQ(SelectProg0Pipeline(0x004, 0x004),
              Pipe(false, false, Prog0Lighting::Lighting, false, false, Prog0Clip::None, Prog0Output::OutputCNStrip));
}

TEST(Vu1Prog0Cpu, DecisionRowFacingWinsOverClipOutput) {
    EXPECT_EQ(SelectProg0Pipeline(0x005, 0x000).output, Prog0Output::OutputCN);
    EXPECT_EQ(SelectProg0Pipeline(0x005, 0x004).output, Prog0Output::OutputCNStrip);
}

TEST(Vu1Prog0Cpu, DecisionRowScissorList) {
    EXPECT_EQ(SelectProg0Pipeline(0x003, 0x000),
              Pipe(false, false, Prog0Lighting::Lighting, false, false, Prog0Clip::ClipScis, Prog0Output::OutputC));
}

TEST(Vu1Prog0Cpu, DecisionRowScissorStrip) {
    EXPECT_EQ(SelectProg0Pipeline(0x003, 0x004),
              Pipe(false, false, Prog0Lighting::Lighting, false, false, Prog0Clip::ClipScisStrip, Prog0Output::OutputC));
}

TEST(Vu1Prog0Cpu, DecisionRowScissorFacingList) {
    EXPECT_EQ(SelectProg0Pipeline(0x007, 0x000),
              Pipe(false, false, Prog0Lighting::Lighting, false, false, Prog0Clip::ClipScis, Prog0Output::OutputCN));
}

TEST(Vu1Prog0Cpu, DecisionRowScissorFacingStrip) {
    EXPECT_EQ(SelectProg0Pipeline(0x007, 0x004),
              Pipe(false, false, Prog0Lighting::Lighting, false, false, Prog0Clip::ClipScisStrip,
                   Prog0Output::OutputCNStrip));
}

// Row: F = 0x002 alone. Unreachable from the CPU (C-10). Implemented per dispatch T7 and T12
// (clip runs on F & 0x02, output is OUTPUT because F & 0x01 is clear), not per the table's clip column.
TEST(Vu1Prog0Cpu, DecisionRowScissorAloneDocumented) {
    EXPECT_EQ(SelectProg0Pipeline(0x002, 0x000),
              Pipe(false, false, Prog0Lighting::Lighting, false, false, Prog0Clip::ClipScis, Prog0Output::Output));
}

TEST(Vu1Prog0Cpu, DecisionRowRealLighting) {
    EXPECT_EQ(SelectProg0Pipeline(0x008, 0x000),
              Pipe(false, false, Prog0Lighting::Real, false, false, Prog0Clip::None, Prog0Output::Output));
}

TEST(Vu1Prog0Cpu, DecisionRowPointLighting) {
    EXPECT_EQ(SelectProg0Pipeline(0x010, 0x000),
              Pipe(false, false, Prog0Lighting::PointLighting, false, false, Prog0Clip::None, Prog0Output::Output));
}

TEST(Vu1Prog0Cpu, DecisionRowPointAndRealLighting) {
    EXPECT_EQ(SelectProg0Pipeline(0x018, 0x000),
              Pipe(false, false, Prog0Lighting::PointLighting, false, false, Prog0Clip::None, Prog0Output::Output));
}

TEST(Vu1Prog0Cpu, DecisionRowVertexBlend) {
    EXPECT_EQ(SelectProg0Pipeline(0x040, 0x000),
              Pipe(false, true, Prog0Lighting::Lighting, false, false, Prog0Clip::None, Prog0Output::Output));
}

TEST(Vu1Prog0Cpu, DecisionRowRefSphere) {
    EXPECT_EQ(SelectProg0Pipeline(0x100, 0x000),
              Pipe(true, false, Prog0Lighting::Lighting, false, false, Prog0Clip::None, Prog0Output::Output));
}

TEST(Vu1Prog0Cpu, DecisionRowRefSphereAndVertexBlend) {
    EXPECT_EQ(SelectProg0Pipeline(0x140, 0x000),
              Pipe(true, true, Prog0Lighting::Lighting, false, false, Prog0Clip::None, Prog0Output::Output));
}

TEST(Vu1Prog0Cpu, DecisionVertexColourMul) {
    EXPECT_EQ(SelectProg0Pipeline(0x000, 0x100),
              Pipe(false, false, Prog0Lighting::Lighting, true, false, Prog0Clip::None, Prog0Output::Output));
}

TEST(Vu1Prog0Cpu, DecisionVertexColourAdd) {
    EXPECT_EQ(SelectProg0Pipeline(0x080, 0x100),
              Pipe(false, false, Prog0Lighting::Lighting, true, true, Prog0Clip::None, Prog0Output::Output));
}

// Pipeline choice: VC ADD is only meaningful with colour, so it is gated on T & 0x100.
TEST(Vu1Prog0Cpu, DecisionVcAddIgnoredWithoutColour) {
    EXPECT_EQ(SelectProg0Pipeline(0x080, 0x000),
              Pipe(false, false, Prog0Lighting::Lighting, false, false, Prog0Clip::None, Prog0Output::Output));
}

// Non-skinned rows. O-24: variant 2 writes dw2 = n as a stale UV count; implemented as written.
TEST(Vu1Prog0Cpu, HeaderNonSkinnedV0) {
    ExpectHeader(0, false, 10, 10, 10);
}

TEST(Vu1Prog0Cpu, HeaderNonSkinnedV1) {
    ExpectHeader(1, false, 10, 10, 10);
}

TEST(Vu1Prog0Cpu, HeaderNonSkinnedV2) {
    ExpectHeader(2, false, 10, 10, 10);
}

TEST(Vu1Prog0Cpu, HeaderNonSkinnedV3) {
    ExpectHeader(3, false, 10, 10, 0);
}

TEST(Vu1Prog0Cpu, HeaderNonSkinnedV4) {
    ExpectHeader(4, false, 10, 0, 10);
}

TEST(Vu1Prog0Cpu, HeaderNonSkinnedV5) {
    ExpectHeader(5, false, 10, 0, 10);
}

TEST(Vu1Prog0Cpu, HeaderNonSkinnedV6) {
    ExpectHeader(6, false, 10, 0, 0);
}

TEST(Vu1Prog0Cpu, HeaderNonSkinnedV7) {
    ExpectHeader(7, false, 10, 0, 0);
}

// Skinned rows. O-25 (V2 dw1 = 0 aliases UV onto N) and O-26 (V6 dw0 = 0) implemented as written.
TEST(Vu1Prog0Cpu, HeaderSkinnedV0) {
    ExpectHeader(0, true, 10, 10, 0);
}

TEST(Vu1Prog0Cpu, HeaderSkinnedV1) {
    ExpectHeader(1, true, 10, 10, 10);
}

TEST(Vu1Prog0Cpu, HeaderSkinnedV2) {
    ExpectHeader(2, true, 10, 0, 0);
}

TEST(Vu1Prog0Cpu, HeaderSkinnedV3) {
    ExpectHeader(3, true, 10, 10, 0);
}

TEST(Vu1Prog0Cpu, HeaderSkinnedV4) {
    ExpectHeader(4, true, 10, 0, 0);
}

TEST(Vu1Prog0Cpu, HeaderSkinnedV5) {
    ExpectHeader(5, true, 10, 0, 10);
}

TEST(Vu1Prog0Cpu, HeaderSkinnedV6) {
    ExpectHeader(6, true, 0, 0, 0);
}

TEST(Vu1Prog0Cpu, HeaderSkinnedV7) {
    ExpectHeader(7, true, 10, 0, 0);
}

// O-26: V6 header dw0 = 0, so the N and W pointers collapse onto V as written.
TEST(Vu1Prog0Cpu, InputOffsetsSkinnedV6PointersCollapseOntoV) {
    const Prog0Header  h = PackProg0Header(TypeForVariant(6), 10, true);
    const Prog0Offsets o = Prog0InputOffsets(100, h);
    EXPECT_EQ(o.v, 102);
    EXPECT_EQ(o.normal, 102);
    EXPECT_EQ(o.uv, 102);
    EXPECT_EQ(o.colour, 102);
    EXPECT_EQ(o.weight, 102);
}

// O-25: V2 dw1 = 0, so the UV pointer equals the N pointer as written.
TEST(Vu1Prog0Cpu, InputOffsetsSkinnedV2UvAliasesNormal) {
    const Prog0Header  h = PackProg0Header(TypeForVariant(2), 10, true);
    const Prog0Offsets o = Prog0InputOffsets(100, h);
    EXPECT_EQ(o.normal, 112);
    EXPECT_EQ(o.uv, 112);
    EXPECT_EQ(o.weight, 122);
}

TEST(Vu1Prog0Cpu, InputOffsetsMdtVariant0) {
    const Prog0Header  h = PackProg0Header(TypeForVariant(0), 57, false);
    const Prog0Offsets o = Prog0InputOffsets(60, h);
    EXPECT_EQ(o.v, 62);
    EXPECT_EQ(o.normal, 119);
    EXPECT_EQ(o.uv, 176);
    EXPECT_EQ(o.colour, 233);
    EXPECT_EQ(o.weight, 290);
}

TEST(Vu1Prog0Cpu, BatchLimitMdtNoColour57) {
    EXPECT_EQ(Prog0BatchLimit(180, false, false), 57);
}

TEST(Vu1Prog0Cpu, BatchLimitMdtColour42) {
    EXPECT_EQ(Prog0BatchLimit(180, true, false), 42);
}

// Skinned OFFSET is 0xB4 - 2n; 16 bones gives 148 and 27 vertices (O-17).
TEST(Vu1Prog0Cpu, BatchLimitSkinned16BonesNoColour27) {
    EXPECT_EQ(Prog0BatchLimit(148, false, true), 27);
}

TEST(Vu1Prog0Cpu, ClipCodeInsideIsZero) {
    EXPECT_EQ(Prog0ClipCode(Vec4{1.0f, -1.0f, 1.0f, 1.0f}), 0u);
}

TEST(Vu1Prog0Cpu, ClipCodeSixPlanes) {
    EXPECT_EQ(Prog0ClipCode(Vec4{2.0f, 0.0f, 0.0f, 1.0f}), 1u << 0);
    EXPECT_EQ(Prog0ClipCode(Vec4{-2.0f, 0.0f, 0.0f, 1.0f}), 1u << 1);
    EXPECT_EQ(Prog0ClipCode(Vec4{0.0f, 2.0f, 0.0f, 1.0f}), 1u << 2);
    EXPECT_EQ(Prog0ClipCode(Vec4{0.0f, -2.0f, 0.0f, 1.0f}), 1u << 3);
    EXPECT_EQ(Prog0ClipCode(Vec4{0.0f, 0.0f, 2.0f, 1.0f}), 1u << 4);
    EXPECT_EQ(Prog0ClipCode(Vec4{0.0f, 0.0f, -2.0f, 1.0f}), 1u << 5);
}

// Strict inequality: |c| == |w| is inside. Uses |w| for negative w.
TEST(Vu1Prog0Cpu, ClipCodeBoundaryAndNegativeW) {
    EXPECT_EQ(Prog0ClipCode(Vec4{1.0f, 0.0f, 0.0f, 1.0f}), 0u);
    EXPECT_EQ(Prog0ClipCode(Vec4{2.0f, 0.0f, 0.0f, -1.0f}), 1u << 0);
}

TEST(Vu1Prog0Cpu, PushClipCodeLayout) {
    uint32_t cf = 0;
    cf = Prog0PushClipCode(cf, 0x01);
    cf = Prog0PushClipCode(cf, 0x02);
    cf = Prog0PushClipCode(cf, 0x04);
    EXPECT_EQ(cf, 0x1084u);
}

// 24-bit history holds four 6-bit codes: the first code is still in bits 18..23 after four pushes
// and is gone after the fifth.
TEST(Vu1Prog0Cpu, PushClipCodeDropsOldest) {
    uint32_t cf = 0;
    cf = Prog0PushClipCode(cf, 0x3F);
    cf = Prog0PushClipCode(cf, 0x00);
    cf = Prog0PushClipCode(cf, 0x00);
    cf = Prog0PushClipCode(cf, 0x00);
    EXPECT_EQ(cf, 0xFC0000u);
    cf = Prog0PushClipCode(cf, 0x00);
    EXPECT_EQ(cf, 0u);
}

TEST(Vu1Prog0Cpu, ClassifyTrivialKeep) {
    EXPECT_EQ(Prog0ClassifyTriangle(0u), Prog0ClipClass::Keep);
}

// Each mask is all ones except the three bits of one plane. O-2: reject reads as ((CF | mask) == 0xFFFFFF).
TEST(Vu1Prog0Cpu, ClassifyTrivialRejectPerPlane) {
    const uint32_t plane_codes[6] = {
        1u << 3, // -y
        1u << 2, // +y
        1u << 1, // -x
        1u << 0, // +x
        1u << 5, // -z
        1u << 4, // +z
    };
    for (uint32_t code : plane_codes) {
        const uint32_t cf = CfBit(0, code) | CfBit(1, code) | CfBit(2, code);
        EXPECT_EQ(Prog0ClassifyTriangle(cf), Prog0ClipClass::Reject) << "code " << code;
    }
}

TEST(Vu1Prog0Cpu, ClassifyPartialOneVertexBit) {
    EXPECT_EQ(Prog0ClassifyTriangle(CfBit(0, 1u << 0)), Prog0ClipClass::Partial);
}

TEST(Vu1Prog0Cpu, ClassifyPartialTwoOfThreeSameBit) {
    const uint32_t cf = CfBit(0, 1u << 3) | CfBit(1, 1u << 3);
    EXPECT_EQ(Prog0ClassifyTriangle(cf), Prog0ClipClass::Partial);
}

TEST(Vu1Prog0Cpu, PackXyzfFieldsAndAdc) {
    const GsXyzf p = PackProg0Xyzf(Vec4{.x = 2048.0f, .y = 2048.0f, .z = 4175000.0f, .w = 0.0f}, 255.0f, true);
    EXPECT_EQ(p.x, 32768);
    EXPECT_EQ(p.y, 32768);
    EXPECT_EQ(p.z, 4175000u);
    EXPECT_EQ(p.f, 255);
    EXPECT_TRUE(p.adc);
}

TEST(Vu1Prog0Cpu, PackXyzfNegativeXWrapsLow16) {
    const GsXyzf p = PackProg0Xyzf(Vec4{.x = -1.0f, .y = 0.0f, .z = 0.0f, .w = 0.0f}, 0.0f, false);
    EXPECT_EQ(p.x, 65520);
    EXPECT_EQ(p.f, 0);
    EXPECT_FALSE(p.adc);
}

const std::array<uint32_t, 8> kGuardChoice = {kGuardMask, kGuardMask, kGuardMask, kGuardMask,
                                              kGuardMask, kGuardMask, 0x90u, 0x50u};

uint32_t RandomGuard(std::mt19937 &rng) {
    return kGuardChoice[std::uniform_int_distribution<std::size_t>(0, kGuardChoice.size() - 1)(rng)];
}

std::vector<bool> RunWindowBatches(const std::vector<uint32_t> &guard, const std::vector<std::size_t> &sizes) {
    Prog0Window       carry{};
    std::vector<bool> out;
    std::size_t       pos = 0;
    for (const std::size_t n : sizes) {
        const std::vector<bool> adc = Prog0WindowAdc(std::span<const uint32_t>(guard).subspan(pos, n), carry);
        out.insert(out.end(), adc.begin(), adc.end());
        pos += n;
    }
    return out;
}

std::vector<Vec4> StripWithFourth(Vec4 v3) {
    return std::vector<Vec4>{
        {.x = 2100.0f, .y = 2100.0f, .z = 0.0f, .w = 0.01f},
        {.x = 2200.0f, .y = 2100.0f, .z = 0.0f, .w = 0.01f},
        {.x = 2100.0f, .y = 2200.0f, .z = 0.0f, .w = 0.01f},
        v3
    };
}

std::vector<bool> StripAdcAllIn(const std::vector<Vec4> &screen, uint32_t mirror) {
    const std::vector<uint32_t> guard(screen.size(), kGuardMask);
    Prog0StripWindow            carry{};
    return Prog0StripAdc(screen, guard, mirror, carry);
}

struct Batch {
    int start;
    int count;
};

// Batch k starts at (batch_limit - 2) * k and runs while the remaining vertices exceed one batch (3.3, CreateFacePacket).
std::vector<Batch> StripBatches(int vertex_num, int batch_limit) {
    std::vector<Batch> out;
    for (int b = 0;; ++b) {
        const int start = (batch_limit - 2) * b;
        const int remaining = vertex_num - start;
        out.push_back({.start = start, .count = std::min(batch_limit, remaining)});
        if (remaining <= batch_limit) {
            break;
        }
    }
    return out;
}

std::vector<int> ContinuousParity(std::size_t triangles) {
    std::vector<int> p(triangles);
    for (std::size_t t = 0; t < triangles; ++t) {
        p[t] = (t % 2 == 0) ? 1 : -1;
    }
    return p;
}

void FlipRange(std::vector<int> &p, std::size_t first, std::size_t last) {
    for (std::size_t t = first; t <= last; ++t) {
        p[t] = -p[t];
    }
}

void ExpectParity(const std::vector<int> &got, const std::vector<int> &want) {
    ASSERT_EQ(got.size(), want.size());
    for (std::size_t t = 0; t < want.size(); ++t) {
        EXPECT_EQ(got[t], want[t]) << "triangle " << t;
    }
}

void ExpectStripReorderMatchesRetail(int vertex_num, int batch_limit) {
    std::mt19937                       rng(static_cast<uint32_t>(vertex_num * 131 + batch_limit));
    std::uniform_int_distribution<int> coord(0, 1023);
    std::vector<Vec4>                  screen(static_cast<std::size_t>(vertex_num));
    std::vector<uint32_t>              guard(static_cast<std::size_t>(vertex_num));
    for (std::size_t i = 0; i < screen.size(); ++i) {
        screen[i] = {.x = static_cast<float>(coord(rng)), .y = static_cast<float>(coord(rng)), .z = 0.0f, .w = 0.01f};
        guard[i] = RandomGuard(rng);
    }

    const std::vector<int> parity = Prog0StripParity(vertex_num, batch_limit);
    ASSERT_EQ(parity.size(), static_cast<std::size_t>(vertex_num - 2));

    const auto  at = [](int i) { return static_cast<std::size_t>(i); };
    std::size_t checked = 0;
    bool        seen_pos = false;
    bool        seen_neg = false;
    bool        seen_keep = false;
    bool        seen_drop = false;
    for (const Batch &b : StripBatches(vertex_num, batch_limit)) {
        const auto start = static_cast<std::size_t>(b.start);
        const auto count = static_cast<std::size_t>(b.count);
        for (const uint32_t mirror : {0u, 32u}) {
            Prog0StripWindow        carry{};
            const std::vector<bool> adc = Prog0StripAdc(std::span<const Vec4>(screen).subspan(start, count),
                                                        std::span<const uint32_t>(guard).subspan(start, count),
                                                        mirror, carry);
            for (std::size_t k = 2; k < count; ++k) {
                const std::size_t             t = start + k - 2;
                const std::array<int, 3>      tri = Prog0StripTriangle(static_cast<int>(t), parity[t]);
                const std::array<Vec4, 3>     v = {screen[at(tri[0])], screen[at(tri[1])], screen[at(tri[2])]};
                const std::array<uint32_t, 3> g = {guard[at(tri[0])], guard[at(tri[1])], guard[at(tri[2])]};
                const bool                    list_keep = Prog0ListFacing(v, g, mirror).keep;
                const bool                    retail_keep = !adc[k];

                EXPECT_EQ(retail_keep, list_keep) << "t=" << t << " mirror=" << mirror;
                EXPECT_EQ(parity[t], k % 2 == 0 ? 1 : -1) << "t=" << t;
                ++checked;
                (parity[t] > 0 ? seen_pos : seen_neg) = true;
                (retail_keep ? seen_keep : seen_drop) = true;
            }
        }
    }
    EXPECT_EQ(checked, static_cast<std::size_t>(2 * (vertex_num - 2)));
    EXPECT_TRUE(seen_pos && seen_neg);
    EXPECT_TRUE(seen_keep && seen_drop);
}

TEST(Vu1Prog0Cpu, WindowAdcAllInDrawStartOnly) {
    const std::vector<uint32_t> guard(5, kGuardMask);
    Prog0Window                 carry{};
    EXPECT_EQ(Prog0WindowAdc(guard, carry), (std::vector<bool>{true, true, false, false, false}));
}

TEST(Vu1Prog0Cpu, WindowAdcOneOutPoisonsThreeWindows) {
    const std::vector<uint32_t> guard = {kGuardMask, kGuardMask, kGuardMask, 0x00u,
                                         kGuardMask, kGuardMask, kGuardMask};
    Prog0Window                 carry{};
    EXPECT_EQ(Prog0WindowAdc(guard, carry), (std::vector<bool>{true, true, false, true, true, true, false}));
}

TEST(Vu1Prog0Cpu, WindowAdcCarryKeepsTwoPriorFlags) {
    const std::vector<uint32_t> first = {kGuardMask, kGuardMask};
    const std::vector<uint32_t> second = {kGuardMask};
    Prog0Window                 carry{};
    Prog0WindowAdc(first, carry);
    EXPECT_EQ(Prog0WindowAdc(second, carry), (std::vector<bool>{false}));
}

TEST(Vu1Prog0Cpu, WindowAdcCarryBreaksOnOutPriorVertex) {
    const std::vector<uint32_t> first = {0x00u, kGuardMask};
    const std::vector<uint32_t> second = {kGuardMask};
    Prog0Window                 carry{};
    Prog0WindowAdc(first, carry);
    EXPECT_EQ(Prog0WindowAdc(second, carry), (std::vector<bool>{true}));
}

TEST(Vu1Prog0Cpu, WindowAdcBatchSplitInvariant) {
    std::mt19937          rng(7);
    std::vector<uint32_t> guard(40);
    for (uint32_t &g : guard) {
        g = RandomGuard(rng);
    }

    std::vector<bool> direct(guard.size());
    for (std::size_t k = 0; k < guard.size(); ++k) {
        const bool in2 = k >= 2 && guard[k - 2] == kGuardMask;
        const bool in1 = k >= 1 && guard[k - 1] == kGuardMask;
        direct[k] = !in2 || !in1 || guard[k] != kGuardMask;
    }

    EXPECT_EQ(RunWindowBatches(guard, {40}), direct);
    EXPECT_EQ(RunWindowBatches(guard, {1, 6, 9, 24}), direct);
    EXPECT_EQ(RunWindowBatches(guard, {13, 13, 14}), direct);
}

TEST(Vu1Prog0Cpu, StripAdc10_4UnmirroredRejectsBothTriangles) {
    EXPECT_EQ(StripAdcAllIn(StripWithFourth(Vec4{2200.0f, 2200.0f, 0.0f, 0.01f}), 0),
              (std::vector<bool>{true, true, true, true}));
}

TEST(Vu1Prog0Cpu, StripAdc10_4MirroredAcceptsBothTriangles) {
    EXPECT_EQ(StripAdcAllIn(StripWithFourth(Vec4{2200.0f, 2200.0f, 0.0f, 0.01f}), 32),
              (std::vector<bool>{true, true, false, false}));
}

TEST(Vu1Prog0Cpu, StripAdc10_4ReversedSecondTriangleUnmirroredAccepted) {
    EXPECT_EQ(StripAdcAllIn(StripWithFourth(Vec4{2000.0f, 2000.0f, 0.0f, 0.01f}), 0),
              (std::vector<bool>{true, true, true, false}));
}

TEST(Vu1Prog0Cpu, StripAdc10_4ReversedSecondTriangleMirroredRejected) {
    EXPECT_EQ(StripAdcAllIn(StripWithFourth(Vec4{2000.0f, 2000.0f, 0.0f, 0.01f}), 32),
              (std::vector<bool>{true, true, false, true}));
}

TEST(Vu1Prog0Cpu, StripParity57NoFlip) {
    ExpectParity(Prog0StripParity(57, 57), ContinuousParity(55));
}

TEST(Vu1Prog0Cpu, StripParity58SecondBatchFirstTriangleFlipped) {
    std::vector<int> want = ContinuousParity(56);
    FlipRange(want, 55, 55);
    ExpectParity(Prog0StripParity(58, 57), want);
}

TEST(Vu1Prog0Cpu, StripParity112SecondBatchFlipped) {
    std::vector<int> want = ContinuousParity(110);
    FlipRange(want, 55, 109);
    ExpectParity(Prog0StripParity(112, 57), want);
}

TEST(Vu1Prog0Cpu, StripParity113ThirdBatchNotFlipped) {
    std::vector<int> want = ContinuousParity(111);
    FlipRange(want, 55, 109);
    ExpectParity(Prog0StripParity(113, 57), want);
}

TEST(Vu1Prog0Cpu, StripParity42EvenStepNoFlip) {
    ExpectParity(Prog0StripParity(121, 42), ContinuousParity(119));
}

TEST(Vu1Prog0Cpu, StripTriangleOrderFollowsParity) {
    EXPECT_EQ(Prog0StripTriangle(5, 1), (std::array<int, 3>{5, 6, 7}));
    EXPECT_EQ(Prog0StripTriangle(5, -1), (std::array<int, 3>{6, 5, 7}));
}

TEST(Vu1Prog0Cpu, StripReorderMatchesRetailAcceptBatch57) {
    ExpectStripReorderMatchesRetail(200, 57);
}

TEST(Vu1Prog0Cpu, StripReorderMatchesRetailAcceptBatch42) {
    ExpectStripReorderMatchesRetail(200, 42);
}

TEST(Vu1Prog0Cpu, GsToNdcMapsCentreAndEdges) {
    const Vec4 centre = GsToNdc(Vec4{.x = 2048.0f, .y = 2048.0f, .z = 0.0f, .w = 1.0f}, 512.0f, 384.0f);
    EXPECT_NEAR(centre.x, 0.0f, kTol);
    EXPECT_NEAR(centre.y, 0.0f, kTol);
    const Vec4 corner = GsToNdc(Vec4{.x = 2560.0f, .y = 1664.0f, .z = 0.0f, .w = 1.0f}, 512.0f, 384.0f);
    EXPECT_NEAR(corner.x, 1.0f, kTol);
    EXPECT_NEAR(corner.y, -1.0f, kTol);
}

TEST(Vu1Prog0Cpu, GsZToDepthEndpoints) {
    EXPECT_EQ(GsZToDepth(0u, 16777215.0f), 0.0f);
    EXPECT_EQ(GsZToDepth(16777215u, 16777215.0f), 1.0f);
    EXPECT_NEAR(GsZToDepth(8388608u, 16777215.0f), 0.5f, 1e-6f);
    EXPECT_EQ(GsZToDepth(20000000u, 16777215.0f), 1.0f);
}

} // namespace
} // namespace dc::vu1
