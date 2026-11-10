#include <gtest/gtest.h>

#include <algorithm>
#include <memory>
#include <span>
#include <vector>

#include "dng_hud.hpp"
#include "dng_main.hpp"
#include "dng_status.hpp"
#include "gfx/gfx.hpp"
#include "maintex.hpp"
#include "mg_drawprim.hpp"
#include "mglib.hpp"
#include "render/primitive_submission.hpp"
#include "render/renderer.hpp"
#include "scenesnd.hpp"
#include "userdata.hpp"

namespace {
struct HudBatch {
    std::vector<gfx::Vertex2D> vertices;
    gfx::UiAnchor              anchor;
    gfx::TextureHandle         texture;
};

class HumanHudRig {
public:
    HumanHudRig() {
        mgScreenWidth = 512;
        mgScreenHeight = 480;
        mgScreenOffx = 2048 - 256;
        mgScreenOffy = 2048 - 240;
        mgDrawManager.render_info = &render_info;
        mgVif1Packet = &packet;
        DngMainScene = scene.get();
        DngUserData = user.get();
        DngUserData->active_chr_no = USER_CHARA_MAX;
        BattleAreaScene = &area;
        area.statusbar_rate = 1.0f;
        TEX_SystenFrame = &texture;
        texture.tex0.TBP0 = 1234;
        mgPortSetTextureLookup(nullptr, [](uint64_t tex0) {
            return mgPortTexture{.texture = (tex0 & 0x3FFF) == 1234 ? 42u : gfx::kNullTexture, .palette = gfx::kNullTexture};
        });
        auto *battle = GetBattleCharaInfo();
        battle->Initialize();
        battle->chr_no = USER_CHARA_MAX;
        battle->chara_type = BATTLE_CHARA_HUMAN;
        battle->hp = &hp;
        hp.now = hp.max = 32.0f;
        battle->equip = equip;
        battle->active_item = items;
        for (int i = 0; i < 2; ++i) {
            battle->GetNowAccessWHp(i)->now = battle->GetNowAccessWHp(i)->max = 36.0f;
            battle->GetNowAccessAbs(i)->max = 100.0f;
            battle->GetNowAccessAbs(i)->now = 75.0f;
        }
        mgPortSetPrimSink([this](gfx::Primitive, std::span<const gfx::Vertex2D> vertices,
                                 const gfx::TextureBinding &binding, const gfx::DrawState &) {
            batches.push_back({
                .vertices = {vertices.begin(), vertices.end()},
                .anchor = gfx::CurrentUiAnchor(),
                .texture = binding.texture
            });
        });
    }

    ~HumanHudRig() {
        mgPortSetPrimSink({});
        mgPortSetTextureLookup(nullptr, nullptr);
        mgDrawManager.render_info = saved_info;
        mgVif1Packet = saved_packet;
        DngMainScene = saved_scene;
        DngUserData = saved_user;
        BattleAreaScene = saved_area;
        TEX_SystenFrame = saved_texture;
        *GetBattleCharaInfo() = saved_battle;
        mgScreenWidth = saved_width;
        mgScreenHeight = saved_height;
        mgScreenOffx = saved_offx;
        mgScreenOffy = saved_offy;
    }

    std::vector<HudBatch> batches;
    DNG_BATTLE_AREA       area{};

private:
    mgRENDER_INFO                    *saved_info = mgDrawManager.render_info;
    sceVif1Packet                    *saved_packet = mgVif1Packet;
    CScene                           *saved_scene = DngMainScene;
    CUserDataManager                 *saved_user = DngUserData;
    DNG_BATTLE_AREA                  *saved_area = BattleAreaScene;
    mgCTexture                       *saved_texture = TEX_SystenFrame;
    CBattleCharaInfo                  saved_battle = *GetBattleCharaInfo();
    int                               saved_width = mgScreenWidth, saved_height = mgScreenHeight;
    int                               saved_offx = mgScreenOffx, saved_offy = mgScreenOffy;
    std::unique_ptr<CScene>           scene = std::make_unique<CScene>();
    std::unique_ptr<CUserDataManager> user = std::make_unique<CUserDataManager>();
    mgRENDER_INFO                     render_info{};
    sceVif1Packet                     packet{};
    mgCTexture                        texture;
    COMMON_GAGE                       hp{};
    CGameDataUsed                     equip[2]{};
    CGameDataUsed                     items[3]{};
};

int AnchorX(const HudBatch &batch) {
    float lo = INFINITY;
    float hi = -INFINITY;
    for (const auto &vertex : batch.vertices) {
        lo = std::min(lo, vertex.x);
        hi = std::max(hi, vertex.x);
    }
    const float centre = (lo + hi) * 0.5f;
    return centre < batch.anchor.left_until ? -1 : centre >= batch.anchor.right_from ? 1
                                                                                     : 0;
}
} // namespace

TEST(DngStatus, HumanPanelsKeepTheirOwnScreenSide) {
    HumanHudRig rig;
    DrawStatusBord();
    int left = 0;
    int right = 0;
    for (const auto &batch : rig.batches) {
        float lo = INFINITY;
        float hi = -INFINITY;
        for (const auto &vertex : batch.vertices) {
            lo = std::min(lo, vertex.x);
            hi = std::max(hi, vertex.x);
        }
        // Retail emits HP/items and weapons as separate batches, wholly on their own side.
        const int expected = (lo + hi) * 0.5f < 256.0f ? -1 : 1;
        EXPECT_EQ(AnchorX(batch), expected) << "batch bounds " << lo << "," << hi;
        EXPECT_EQ(batch.anchor.top_until, INFINITY);
        EXPECT_TRUE(batch.anchor.scissor);
        (expected < 0 ? left : right)++;
    }
    EXPECT_GT(left, 0);
    EXPECT_GT(right, 0);
    EXPECT_EQ(gfx::CurrentUiAnchor().left_until, -INFINITY);
    EXPECT_EQ(gfx::CurrentUiAnchor().right_from, INFINITY);
}

TEST(DngStatus, WarningIconsFollowTheirPanel) {
    HumanHudRig   rig;
    CWarningGage2 warning{};
    warning.layout = WARNING_GAGE_LAYOUT_MAIN;
    warning.time = 20;
    for (int i = 0; i < 3; ++i) {
        rig.batches.clear();
        warning.warning[0] = warning.warning[1] = warning.warning[2] = 0;
        warning.warning[i] = 1;
        warning.rate[i] = 0.1f;
        warning.Draw();
        ASSERT_FALSE(rig.batches.empty());
        for (const auto &batch : rig.batches) {
            EXPECT_EQ(AnchorX(batch), i == 0 ? -1 : 1);
            EXPECT_EQ(batch.texture, 42u);
        }
    }
    warning.layout = WARNING_GAGE_LAYOUT_ROBO;
    for (int i = 0; i < 2; ++i) {
        rig.batches.clear();
        warning.warning[0] = warning.warning[1] = warning.warning[2] = 0;
        warning.warning[i] = 1;
        warning.rate[i] = 0.1f;
        warning.Draw();
        ASSERT_FALSE(rig.batches.empty());
        for (const auto &batch : rig.batches) {
            EXPECT_EQ(AnchorX(batch), -1);
            EXPECT_EQ(batch.anchor.top_until, INFINITY);
            EXPECT_TRUE(batch.anchor.scissor);
        }
    }
}
