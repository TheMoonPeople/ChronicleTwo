#include <gtest/gtest.h>

#include <array>
#include <bit>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <limits>
#include <memory>
#include <stdexcept>

#include "mg_drawenv.hpp"
#include "mglib.hpp"

namespace {

// This is the natural host placement of a draw environment after an eight-byte member.
struct alignas(16) OffsetDrawEnv {
    std::uint64_t prefix = 0;
    mgCDrawEnv    env;
};

static_assert(alignof(mgCDrawEnv) == 8);
static_assert(offsetof(OffsetDrawEnv, env) == 8);
static_assert(sizeof(mgCDrawEnv) == 64);

/**
 * Restores the render state after a pure transform test.
 */
struct RestoreRenderInfo {
    mgRENDER_INFO previous = mgRenderInfo; /**< Render state owned by the preceding caller. */

    ~RestoreRenderInfo() { mgRenderInfo = previous; }
};

} // namespace

TEST(MgDrawEnvCopy, CameraViewReadsExactlyThreeCoordinatesAndRejectsShortInputBeforeMutation) {
    RestoreRenderInfo restore;
    float             matrix[4][4]{
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {0, 0, 0, 1}
    };
    const std::array<float, 3> position{2.0f, 3.0f, 4.0f};
    mgSetViewMatrix(matrix, position);
    EXPECT_FLOAT_EQ(mgRenderInfo.camera_pos[0], 2.0f);
    EXPECT_FLOAT_EQ(mgRenderInfo.camera_pos[1], 3.0f);
    EXPECT_FLOAT_EQ(mgRenderInfo.camera_pos[2], 4.0f);
    EXPECT_FLOAT_EQ(mgRenderInfo.camera_pos[3], 1.0f);
    EXPECT_THROW(mgSetViewMatrix(matrix, std::span(position).first<2>()), std::invalid_argument);
    EXPECT_THROW(mgSetViewMatrix(nullptr, position), std::invalid_argument);
    EXPECT_FLOAT_EQ(mgRenderInfo.camera_pos[0], 2.0f);
    EXPECT_FLOAT_EQ(mgRenderInfo.camera_pos[1], 3.0f);
    EXPECT_FLOAT_EQ(mgRenderInfo.camera_pos[2], 4.0f);
    EXPECT_FLOAT_EQ(mgRenderInfo.camera_pos[3], 1.0f);
}

TEST(MgDrawEnvCopy, DropShadowReadsExactXYZVectorsAndSnapshotsAliasedInputsBeforeMutation) {
    RestoreRenderInfo          restore;
    const std::array<float, 3> direction{0.0f, 0.0f, 1.0f};
    const std::array<float, 3> position{0.0f, 0.0f, 5.0f};
    const std::array<float, 3> normal{0.0f, 0.0f, -1.0f};
    mgSetDropShadowMatrix(direction, position, normal);
    EXPECT_FLOAT_EQ(mgRenderInfo.shadow_plane_pos[3], 1.0f);
    EXPECT_FLOAT_EQ(mgRenderInfo.shadow_plane_normal[3], 0.0f);
    EXPECT_FLOAT_EQ(mgRenderInfo.shadow_light_dir[3], 0.0f);
    const auto shadow = std::bit_cast<std::array<float, 16>>(mgRenderInfo.shadow);
    EXPECT_THROW(mgSetDropShadowMatrix(std::span(direction).first<2>(), position, normal), std::invalid_argument);
    EXPECT_THROW(mgSetDropShadowMatrix(direction, std::span(position).first<2>(), normal), std::invalid_argument);
    EXPECT_THROW(mgSetDropShadowMatrix(direction, position, std::span(normal).first<2>()), std::invalid_argument);
    EXPECT_EQ((std::bit_cast<std::array<float, 16>>(mgRenderInfo.shadow)), shadow);
    mgSetDropShadowMatrix(std::span(mgRenderInfo.shadow_plane_normal).first<3>(),
                          std::span(mgRenderInfo.shadow_plane_pos).first<3>(),
                          std::span(mgRenderInfo.shadow_light_dir).first<3>());
    EXPECT_FLOAT_EQ(mgRenderInfo.shadow_light_dir[2], -1.0f);
    EXPECT_FLOAT_EQ(mgRenderInfo.shadow_plane_normal[2], 1.0f);
}

TEST(MgDrawEnvCopy, CopiesAtNaturalEightByteAlignment) {
    alignas(16) mgCDrawEnv source;
    auto                   destination = std::make_unique<OffsetDrawEnv>();
    ASSERT_EQ(reinterpret_cast<std::uintptr_t>(&source) % 16, 0u);
    ASSERT_EQ(reinterpret_cast<std::uintptr_t>(&destination->env) % 16, 8u);
    source.giftag.NLOOP = 7;
    source.giftag.EOP = 1;
    source.test.value = 0x0123456789abcdefULL;
    source.test_addr = 0x1111111111111111ULL;
    source.zbuf.value = 0x2233445566778899ULL;
    source.zbuf_addr = 0x2222222222222222ULL;
    source.alpha.value = 0xaabbccddeeff0011ULL;
    source.alpha_addr = 0x3333333333333333ULL;
    mgCDrawEnv &result = (destination->env = source);
    EXPECT_EQ(&result, &destination->env);
    EXPECT_EQ(destination->env.giftag.NLOOP, source.giftag.NLOOP);
    EXPECT_EQ(destination->env.giftag.EOP, source.giftag.EOP);
    EXPECT_EQ(destination->env.test.value, source.test.value);
    EXPECT_EQ(destination->env.test_addr, source.test_addr);
    EXPECT_EQ(destination->env.zbuf.value, source.zbuf.value);
    EXPECT_EQ(destination->env.zbuf_addr, source.zbuf_addr);
    EXPECT_EQ(destination->env.alpha.value, source.alpha.value);
    EXPECT_EQ(destination->env.alpha_addr, source.alpha_addr);
    EXPECT_EQ(destination->prefix, 0u);
}

TEST(MgDrawEnvCopy, SelfAssignmentPreservesAllBytes) {
    OffsetDrawEnv value;
    unsigned char before[sizeof(mgCDrawEnv)];
    std::memcpy(before, &value.env, sizeof before);
    mgCDrawEnv &alias = value.env;
    mgCDrawEnv &result = (value.env = alias);
    EXPECT_EQ(&result, &value.env);
    EXPECT_EQ(std::memcmp(&value.env, before, sizeof before), 0);
}

TEST(MgDrawEnvCopy, InitializeClearsTheWholeGifTagAndKeepsTheRegisterDefaults) {
    mgCDrawEnv environment;
    environment.giftag.REGS15 = 7;
    environment.giftag.PRE = 1;
    environment.Initialize(0);
    EXPECT_EQ(environment.giftag.NLOOP, 3u);
    EXPECT_EQ(environment.giftag.EOP, 1u);
    EXPECT_EQ(environment.giftag.NREG, 1u);
    EXPECT_EQ(environment.giftag.REGS0, SCE_GIF_PACKED_AD);
    EXPECT_EQ(environment.giftag.PRE, 0u);
    EXPECT_EQ(environment.giftag.REGS15, 0u);
    EXPECT_EQ(environment.test.value, 0x5000Bu);
    EXPECT_EQ(environment.alpha.value, 0x44u);
    EXPECT_EQ(environment.test_addr, SCE_GS_TEST_1);
    EXPECT_EQ(environment.zbuf_addr, SCE_GS_ZBUF_1);
    EXPECT_EQ(environment.alpha_addr, SCE_GS_ALPHA_1);
    environment.Initialize(1);
    EXPECT_EQ(environment.test_addr, SCE_GS_TEST_2);
    EXPECT_EQ(environment.zbuf_addr, SCE_GS_ZBUF_2);
    EXPECT_EQ(environment.alpha_addr, SCE_GS_ALPHA_2);
}

TEST(MgDrawEnvCopy, PointLightCopiesAllTypedLanesAndSupportsAliasedOutput) {
    mgRENDER_INFO info{};
    info.InitLighting();
    info.active_light = 0;
    mgPOINT_LIGHT source{};
    source.pos[0] = 1.0f;
    source.pos[1] = 2.0f;
    source.pos[2] = 3.0f;
    source.pos[3] = 9.0f;
    source.color[0] = 1.0f;
    source.color[1] = 4.0f;
    source.color[2] = 2.0f;
    source.color[3] = 0.25f;
    source.power = 3.0f;
    source.range = 0.0f;
    info.SetPlight(2, &source);
    mgPOINT_LIGHT output{};
    info.GetPlight(2, &output);
    const std::array position{1.0f, 2.0f, 3.0f, 1.0f};
    const std::array color{1.0f, 4.0f, 2.0f, 0.25f};
    EXPECT_EQ(std::to_array(output.pos), position);
    EXPECT_EQ(std::to_array(output.color), color);
    EXPECT_EQ(output.power, 3.0f);
    EXPECT_EQ(output.range, 6.0f);
    auto &stored = info.light_info[0].point_light[2];
    info.GetPlight(2, &stored);
    info.SetPlight(2, &stored);
    EXPECT_EQ(std::to_array(stored.pos), position);
    EXPECT_EQ(std::to_array(stored.color), color);
    EXPECT_EQ(stored.range, 6.0f);
}

TEST(MgDrawEnvCopy, BoxCopyPreservesFloatRepresentationsAndSelfAssignment) {
    mgVu0FBOX source{};
    source.max[0] = std::bit_cast<float>(std::uint32_t{0x7fc01234});
    source.max[1] = 2.0f;
    source.max[2] = 3.0f;
    source.max[3] = -0.0f;
    source.min[0] = -1.0f;
    source.min[1] = -2.0f;
    source.min[2] = -3.0f;
    source.min[3] = 1.0f;
    const auto maximum = std::bit_cast<std::array<std::uint32_t, 4>>(source.max);
    const auto minimum = std::bit_cast<std::array<std::uint32_t, 4>>(source.min);
    mgVu0FBOX  destination{};
    destination = source;
    auto &alias = destination;
    destination = alias;
    const auto copied_maximum = std::bit_cast<std::array<std::uint32_t, 4>>(destination.max);
    const auto copied_minimum = std::bit_cast<std::array<std::uint32_t, 4>>(destination.min);
    EXPECT_EQ(copied_maximum, maximum);
    EXPECT_EQ(copied_minimum, minimum);
}

TEST(MgDrawEnvCopy, ViewportIntegerConversionPreservesOddCentersAndHandlesMinimumWidth) {
    mgRENDER_INFO info{};
    info.SetRenderInfo(512.0f, 3, 5, 1.0f, 100.0f, 24, 1.0f);
    EXPECT_EQ(info.screen_box_min[0], -1.0f);
    EXPECT_EQ(info.screen_box_min[1], -2.0f);
    EXPECT_EQ(info.screen_box_max[0], 2.0f);
    EXPECT_EQ(info.screen_box_max[1], 3.0f);
    const auto minimum = std::numeric_limits<int>::min();
    info.SetRenderInfo(512.0f, minimum, minimum, 1.0f, 100.0f, 24, 1.0f);
    EXPECT_EQ(info.screen_box_min[0], 1073741824.0f);
    EXPECT_EQ(info.screen_box_min[1], 1073741824.0f);
    EXPECT_EQ(info.screen_box_max[0], -1073741824.0f);
    EXPECT_EQ(info.screen_box_max[1], -1073741824.0f);
}
