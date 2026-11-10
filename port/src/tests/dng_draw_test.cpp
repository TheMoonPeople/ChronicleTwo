#include <gtest/gtest.h>

#include <array>
#include <memory>

#include "dng_event.hpp"
#include "dng_hud.hpp"
#include "scenesnd.hpp"
#include "sphida.hpp"

namespace {

using SceneHandle = std::unique_ptr<CScene>;

SceneHandle EmptyScene() {
    return std::make_unique<CScene>();
}

} // namespace

TEST(DngDraw, PoisonedSphidaConstructionStartsWithAnIdleGaugeAndEmptyOptionalState) {
    alignas(CSphida) std::array<std::byte, sizeof(CSphida)> storage{};
    storage.fill(std::byte{0xA5});
    auto *game = ::new (storage.data()) CSphida;
    EXPECT_EQ(game->play_flag, 0);
    EXPECT_EQ(game->col_model, nullptr);
    EXPECT_EQ(game->mini_level, 0);
    EXPECT_EQ(game->club_no, 0);
    EXPECT_FLOAT_EQ(game->carry, 0.0f);
    EXPECT_FLOAT_EQ(game->spin_mark_pos_x, 0.0f);
    EXPECT_FLOAT_EQ(game->spin_mark_pos_y, 0.0f);
    EXPECT_EQ(game->pow_gage.count, 0);
    EXPECT_EQ(game->pow_gage.state, -1);
    EXPECT_EQ(game->pow_gage.code, -10);
    EXPECT_EQ(game->pow_gage.safe_level, 2);
    EXPECT_EQ(game->red_mark.draw_request, 0);
    EXPECT_FLOAT_EQ(game->red_mark.angle, 0.0f);
    EXPECT_EQ(game->unk_198[0], 0x80);
    std::destroy_at(game);
}

TEST(DngDraw, RedMarkDrawsOnlyWhenRequested) {
    CRedMarkModel model{};
    model.frame = nullptr;
    model.angle = 0.5f;

    float start[4] = {1.0f, 2.0f, 3.0f, 0.0f};
    model.SetPosition(start);

    model.draw_request = 0;
    EXPECT_EQ(model.Draw(), 0);

    float unrequested[4];
    model.GetPosition(unrequested);
    EXPECT_FLOAT_EQ(unrequested[0], 1.0f);
    EXPECT_FLOAT_EQ(unrequested[1], 2.0f);
    EXPECT_FLOAT_EQ(unrequested[2], 3.0f);

    model.draw_request = 1;
    EXPECT_EQ(model.Draw(), 0);
    EXPECT_EQ(model.draw_request, 0);

    float restored[4];
    model.GetPosition(restored);
    EXPECT_FLOAT_EQ(restored[0], 1.0f);
    EXPECT_FLOAT_EQ(restored[1], 2.0f);
    EXPECT_FLOAT_EQ(restored[2], 3.0f);
}

TEST(DngDraw, LockOnWithoutPlayerDrawsNothing) {
    SceneHandle scene = EmptyScene();
    ASSERT_TRUE(scene);

    CLockOnModel model{};
    model.scene = scene.get();

    char marker[] = "marker";
    model.name = marker;

    EXPECT_EQ(model.Draw(), 0);
    EXPECT_EQ(model.name, marker);
}
