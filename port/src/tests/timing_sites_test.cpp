#include <gtest/gtest.h>

#include <cstring>
#include <memory>

#include "character.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "mainloop_port.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "runscript.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "sceneseq.hpp"
#include "stubs/event.hpp"

namespace {
RS_STACKDATA Integer(int value) {
    RS_STACKDATA result{};
    result.type = RS_INT;
    result.val.i = value;
    return result;
}

RS_STACKDATA Reference(RS_STACKDATA &value) {
    RS_STACKDATA result{};
    result.type = RS_PTR;
    result.val.p = &value;
    return result;
}

class GameplayTimingSites : public testing::Test {
protected:
    std::unique_ptr<CSaveData> save = std::make_unique<CSaveData>();
    CSaveData                 *previous_save = PortActiveSaveData;
    CScene                    *previous_event_scene = EventScene;
    RS_PROG_HEADER             program{};
    alignas(64) u_long128 storage[512] {};
    mgCMemory memory;

    void SetUp() override {
        PortActiveSaveData = save.get();
        EventScene = GetMainScene();
        std::memcpy(program.magic, "SB2", 3);
        memory.stSetBuffer(storage, 512);
        SetEventScript(reinterpret_cast<char *>(&program), nullptr, &memory);
    }

    void TearDown() override {
        SetEventScript(nullptr, nullptr, nullptr);
        EventScene = previous_event_scene;
        PortActiveSaveData = previous_save;
    }
};
} // namespace

TEST_F(GameplayTimingSites, CharacterNormalDriveUsesNtscMotionSpeed) {
    CCharacter2     character;
    CHRINFO_KEY_SET key{};
    key.start_frame = 0;
    key.end_frame = 100;
    character.now_key = character.next_key = character.posed_key = &key;
    character.now_set = 0;
    character.now_flags = character.next_flags = 0;
    character.motion[0].motion_list = nullptr;
    character.frame = 10;
    character.step = 2;
    character.NormalDrive();
    EXPECT_FLOAT_EQ(character.frame, 12.0f);
}

TEST_F(GameplayTimingSites, CameraDelayAndFadeCommandsConvertFrames) {
    _SEN_CMR_SEQ nodes[4]{};
    CSceneCmrSeq sequence;
    sequence.Initialize(nodes, 4);
    sequence.PRDelay(60);
    sequence.FadeIn(60, 0, 0, 0);
    ASSERT_NE(sequence.pr_last, nullptr);
    ASSERT_NE(sequence.fade_last, nullptr);
    const int expected = 60;
    EXPECT_EQ(sequence.pr_last->frame, expected);
    EXPECT_EQ(sequence.fade_last->frame, expected);
    sequence.PRDelay(1);
    EXPECT_EQ(sequence.pr_last->frame, 1);
}

TEST_F(GameplayTimingSites, EventFadeInConvertsFramesAndClampsZero) {
    auto frames = Integer(60);
    ASSERT_EQ(EventScript.ext_func_table[EVENT_EXT_SET_FADE_IN](&frames, 1), 1);
    EXPECT_FLOAT_EQ(EventScene->fade.speed, 128.0f / 60);
    frames = Integer(0);
    ASSERT_EQ(EventScript.ext_func_table[EVENT_EXT_SET_FADE_IN](&frames, 1), 1);
    EXPECT_FLOAT_EQ(EventScene->fade.speed, 128.0f);
}

TEST_F(GameplayTimingSites, ItemPowerStatusUsesNtscDuration) {
    GameItemDataManage.Initialize();
    CDataCommon *common = GetCommonItemData(1);
    ASSERT_NE(common, nullptr);
    const CDataCommon previous_common = *common;
    CDataItem         effect;
    effect.use_flags = ITEM_USE_FLAG_ADD_POWER;
    effect.target_flags = 6;
    effect.action_flags = 0;
    const auto previous_items = GameItemDataManage.item_data;
    const auto previous_count = GameItemDataManage.item_num;
    common->type = ITEM_DATA_RECOVERY;
    common->list_no = 0;
    GameItemDataManage.item_data = &effect;
    GameItemDataManage.item_num = 1;
    const int previous_loop = PortLoopNo;
    PortLoopNo = LOOP_DUNGEON;
    auto &chara = save->user_data.chara_data[USER_CHARA_MAX];
    chara.hp.max = chara.hp.now = 100;
    chara.status_attr = 0;
    CGameDataUsed item;
    item.item_no = 1;
    item.used_type = USED_ITEM_TYPE_ITEM;
    item.data.item.num = 2;
    CItemUseTarget target;
    target.SetPtr(ITEM_USE_TARGET_CHARA, &chara);
    EXPECT_EQ(MenuUseItemCheckFunc(&item, &target, 1), 1);
    EXPECT_EQ(chara.status_time[0], 900);
    PortLoopNo = previous_loop;
    *common = previous_common;
    GameItemDataManage.item_data = previous_items;
    GameItemDataManage.item_num = previous_count;
}

TEST_F(GameplayTimingSites, AquariumMessageUsesNtscDuration) {
    CAquaMes      messages;
    ClsMes        window;
    CGameDataUsed data;
    data.used_type = USED_ITEM_TYPE_NONE;
    data.data.fish.sex = 2; // No gender-change text is needed to check the message lifetime.
    CAquaFish fish;
    fish.data = &data;
    messages.fish_mes = &window;
    messages.ChangeManMessage(&fish);
    EXPECT_EQ(messages.fish_mes_time, 300);
}

TEST_F(GameplayTimingSites, StopwatchAndItemTimeCheckConvertSavedDelta) {
    save->play_time = 1;
    auto start = Integer(EVENT_STOPWATCH_START);
    ASSERT_EQ(EventScript.ext_func_table[EVENT_EXT_STOPWATCH](&start, 1), 1);
    save->play_time = 51;
    RS_STACKDATA output[] = {Integer(-1), Integer(-1), Integer(-1), Integer(-1)};
    RS_STACKDATA stop[] = {Integer(EVENT_STOPWATCH_STOP), Reference(output[0]), Reference(output[1]),
                           Reference(output[2]), Reference(output[3])};
    ASSERT_EQ(EventScript.ext_func_table[EVENT_EXT_STOPWATCH](stop, 5), 1);
    EXPECT_EQ(output[0].val.i, 0);
    EXPECT_EQ(output[1].val.i, 1);
    EXPECT_EQ(output[2].val.i, 0);
    EXPECT_EQ(output[3].val.i, 1);
    auto &user = save->user_data;
    user.last_refresh_time = 1;
    user.aquarium.last_time = 51;
    user.used_data[0].used_type = USED_ITEM_TYPE_FISH;
    user.used_data[0].data.fish.timer = 100;
    user.RefreshParam();
    EXPECT_EQ(user.used_data[0].data.fish.timer, 40);
    EXPECT_EQ(user.last_refresh_time, 51);
}
