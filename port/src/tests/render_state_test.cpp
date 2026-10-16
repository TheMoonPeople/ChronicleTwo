#include "common.h"

#include <gtest/gtest.h>

#include <array>
#include <cstring>

#include "gfx_fixture.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/clock.hpp"

namespace {
/**
 * Records native draw state against an offscreen framebuffer with stencil support.
 */
class NativeRenderState : public testing::Test {
protected:
    dc::test::GfxFixture renderer{64, 64, 1.0f, dc::test::GfxOptions{.offscreen = true}};

    void SetUp() override {
        ClockSetUnbounded(true);
        mgInit(MG_SCREEN_MODE_512X480, 3);
        mgBeginFrame(nullptr);
    }

    void TearDown() override { mgEndFrame(nullptr); }
};
} // namespace

TEST_F(NativeRenderState, DestinationAlphaTestsResetWithoutErasingIndependentStencilState) {
    mgPortBeginDestAlphaMask();
    gfx::DrawState state;
    mgPortApplyTest(state, SCE_GS_SET_TEST(1, 6, 12, 0, 0, 0, 1, 2));
    EXPECT_EQ(state.color_write_mask, 0);
    EXPECT_EQ(state.stencil_front.write_mask, 0x80);
    mgPortEndDestAlphaMask();
    mgPortApplyTest(state, SCE_GS_SET_TEST(1, 6, 12, 0, 1, 1, 1, 2));
    EXPECT_TRUE(state.stencil_test);
    EXPECT_EQ(state.color_write_mask, gfx::kWriteRgba);
    mgPortApplyTest(state, SCE_GS_SET_TEST(1, 6, 12, 0, 0, 0, 1, 2));
    EXPECT_FALSE(state.stencil_test);
    EXPECT_EQ(state.color_write_mask, gfx::kWriteRgba);
    EXPECT_TRUE(state.alpha_test);
    for (int datm : {0, 1}) {
        mgPortApplyTest(state, SCE_GS_SET_TEST(1, 6, 12, 0, 1, datm, 1, 2));
        EXPECT_TRUE(state.stencil_test);
        EXPECT_EQ(state.stencil_front.reference, datm ? 0x80 : 0);
        EXPECT_EQ(state.stencil_front.compare_mask, 0x80);
        EXPECT_EQ(state.stencil_front.write_mask, 0);
        mgPortApplyTest(state, SCE_GS_SET_TEST(1, 6, 12, 0, 0, 0, 1, 2));
        EXPECT_FALSE(state.stencil_test);
    }
    const gfx::StencilFace shadow{gfx::CompareOp::NotEqual, gfx::StencilOp::Keep, gfx::StencilOp::Zero,
                                  gfx::StencilOp::Keep, 0, 0xff, 0xff};
    state.stencil_test = true;
    state.stencil_front = state.stencil_back = shadow;
    mgPortApplyTest(state, SCE_GS_SET_TEST(1, 6, 12, 0, 0, 0, 1, 2));
    EXPECT_TRUE(state.stencil_test);
    EXPECT_EQ(state.stencil_front, shadow);
    EXPECT_EQ(state.stencil_back, shadow);
    mgCTexture target;
    mgBeginDrawShadow(&target, nullptr);
    mgPortApplyTest(state, SCE_GS_SET_TEST(1, 6, 12, 0, 1, 1, 1, 2));
    EXPECT_EQ(state.stencil_front, shadow);
    mgEndDrawShadow(&target, nullptr);
    mgPortResetGs();
    EXPECT_FALSE(mgPortDrawState().stencil_test);
}

TEST_F(NativeRenderState, AuxiliaryRenderRestoresTargetCameraLightAndGsStateOnEarlyReturn) {
    mgSetPkFrameBuffer(71, 160, 120, SCE_GS_PSMCT32);
    mgSetProjection(321.0f);
    mgRenderInfo.view[0][0] = 2.5f;
    mgRenderInfo.camera_pos[0] = 42;
    mgRenderInfo.light_info[0].ambient[0] = 73;
    mgPortGs().test = 0x123456;
    mgPortGs().scissor[0] = 17;
    const auto target = mgPortCurrentTarget();
    const auto render = mgRenderInfo;
    const auto gs = mgPortGs();
    mgCTexture frame;
    mgGetFrameBuffer(&frame);
    auto fail = [&] {
        mgPortRenderStateScope restore;
        mgSetPkFrameBuffer(72, 96, 64, SCE_GS_PSMCT32);
        mgSetProjection(999);
        mgRenderInfo.view[0][0] = -2;
        mgRenderInfo.camera_pos[0] = -42;
        mgRenderInfo.light_info[0].ambient[0] = 0;
        mgPortGs().test = 0;
        mgPortGs().scissor[0] = 0;
        return false;
    };
    EXPECT_FALSE(fail());
    EXPECT_EQ(mgPortCurrentTarget(), target);
    EXPECT_EQ(mgScreenWidth, 160);
    EXPECT_EQ(mgScreenHeight, 120);
    EXPECT_FLOAT_EQ(mgRenderInfo.projection, render.projection);
    EXPECT_FLOAT_EQ(mgRenderInfo.view[0][0], render.view[0][0]);
    EXPECT_FLOAT_EQ(mgRenderInfo.camera_pos[0], render.camera_pos[0]);
    EXPECT_FLOAT_EQ(mgRenderInfo.light_info[0].ambient[0], render.light_info[0].ambient[0]);
    EXPECT_EQ(mgPortGs().test, gs.test);
    EXPECT_EQ(mgPortGs().scissor[0], gs.scissor[0]);
    mgCTexture restored;
    mgGetFrameBuffer(&restored);
    EXPECT_EQ(restored.tex0.value, frame.tex0.value);
    const std::array<unsigned char, 4> color{32, 64, 128, 255};
    gfx::Clear(true, color.data(), false, 0);
    mgSetPkFrameBuffer(-1, -1, -1, -1);
}
