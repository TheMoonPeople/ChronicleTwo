#include <gtest/gtest.h>

#include <cstdio>
#include <cstring>

#include "../menu_mouse_make.hpp"
#include "../menu_mouse_monster.hpp"
#include "gamepad.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "menuchr.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib.hpp"
#include "platform/clock.hpp"
#include "platform/input.hpp"

extern CMenuInvent *TestInventPt asm("MenuMouse_Invent");

using namespace menumouse;

TEST(MenuMouseMake, CardRowsAreHalfOpenAndFollowTheEasedList) {
    const Point list{30, 72};
    EXPECT_EQ(CardHit({30, 72}, list, 72, 5, 20), 0);
    EXPECT_EQ(CardHit({260.99f, 117.99f}, list, 72, 5, 20), 0);
    EXPECT_EQ(CardHit({30, 118}, list, 72, 5, 20), 1);
    EXPECT_EQ(CardHit({100, 72 + 4 * 46 + 45}, list, 72, 5, 20), 4);
    EXPECT_EQ(CardHit({261, 80}, list, 72, 5, 20), -1);
    EXPECT_EQ(CardHit({29, 80}, list, 72, 5, 20), -1);
    // Rows above or below the five-row window are clipped.
    EXPECT_EQ(CardHit({100, 71}, {30, 26}, 72, 5, 20), -1);
    EXPECT_EQ(CardHit({100, 72 + 5 * 46}, list, 72, 5, 20), -1);
    // A list scrolled two rows puts card 2 in the first visible row; mid-ease it follows the drawn origin.
    EXPECT_EQ(CardHit({100, 80}, {30, 72 - 92}, 72, 5, 20), 2);
    EXPECT_EQ(CardHit({100, 80}, {30, 72 - 60}, 72, 5, 20), 1);
    EXPECT_EQ(CardHit({100, 200}, list, 72, 5, 2), -1);
}

TEST(MenuMouseMake, WheelStepIsSharedWithListChoice) {
    EXPECT_EQ(MenuMouseWheelStep(3, -1, 10), 4);
    EXPECT_EQ(MenuMouseWheelStep(3, 2, 10), 1);
    EXPECT_EQ(MenuMouseWheelStep(0, 5, 10), 0);
    EXPECT_EQ(MenuMouseWheelStep(8, -100, 10), 9);
    EXPECT_EQ(MenuMouseWheelStep(4, 0, 10), 4);
    EXPECT_EQ(MenuMouseWheelStep(3, -1, 12, 3), 6);
}

namespace {
// The Make menu as town:10 draws it: cards at x 30-261 from y 72, the item board's
// first column (x 236-276) under the card list's right edge.
MakeLists Lists() {
    MakeLists lists;
    lists.cards = lists.board = true;
    lists.card_count = 20;
    lists.item_count = 60;
    lists.card_list = {30, 72};
    lists.card_clip = 72;
    lists.board_origin = {236, 50};
    lists.board_clip = {236, 44, 240, 250};
    lists.board_rest = {236, 50};
    return lists;
}
} // namespace

TEST(MenuMouseMake, HoverMovesTheCursorOfThePaneInFront) {
    auto result = MakeListsUpdate(Lists(), {100, 170}, true, 0, 0);
    EXPECT_FALSE(result.state.items_front);
    EXPECT_EQ(result.state.card_cursor, 2);
    EXPECT_TRUE(result.sound);
    EXPECT_EQ(result.buttons, 0);
    result = MakeListsUpdate(Lists(), {100, 170}, false, 0, 0);
    EXPECT_EQ(result.state.card_cursor, 0); // A resting pointer leaves the keyboard's choice alone.
}

TEST(MenuMouseMake, OverlapKeepsThePaneInFront) {
    // (250, 100) is both card 0 and bag cell 6.
    auto result = MakeListsUpdate(Lists(), {250, 100}, true, 0, 0);
    EXPECT_FALSE(result.state.items_front);
    EXPECT_EQ(result.state.card_cursor, 0);
    auto items = Lists();
    items.items_front = true;
    result = MakeListsUpdate(items, {250, 100}, true, 0, 0);
    EXPECT_TRUE(result.state.items_front);
    EXPECT_EQ(result.state.item_cursor, 6);
}

TEST(MenuMouseMake, HoveringTheOtherPaneSwitchesWithoutConfirmingOrDoubleSound) {
    auto result = MakeListsUpdate(Lists(), {300, 100}, false, 1, 0);
    EXPECT_TRUE(result.state.items_front);
    EXPECT_EQ(result.state.item_cursor, 7);
    EXPECT_FALSE(result.sound); // The retail pane change plays its own sound.
    EXPECT_EQ(result.buttons, 0);
    auto items = result.state;
    result = MakeListsUpdate(items, {300, 100}, false, 1, 0);
    EXPECT_EQ(result.buttons, PAD_CROSS);
    EXPECT_EQ(MakeListsUpdate(items, {300, 100}, false, 2, 0).buttons, PAD_CIRCLE);
    EXPECT_EQ(MakeListsUpdate(items, {490, 400}, false, 1, 0).buttons, 0); // Background.
}

TEST(MenuMouseMake, HeldItemKeepsTheItemBoard) {
    auto lists = Lists();
    lists.items_front = true;
    lists.cards = false; // An item on the hand: retail redirects the card list to the board.
    auto result = MakeListsUpdate(lists, {100, 170}, true, 1, -1);
    EXPECT_TRUE(result.state.items_front);
    EXPECT_EQ(result.state.card_cursor, 0);
    EXPECT_EQ(result.buttons, 0);
}

TEST(MenuMouseMake, WheelScrollsThePaneUnderThePointer) {
    auto result = MakeListsUpdate(Lists(), {100, 300}, false, 0, -6);
    EXPECT_EQ(result.state.card_cursor, 6);
    EXPECT_EQ(result.state.card_top, 2);
    EXPECT_TRUE(result.sound);
    // The wheel over the board brings it forward and selects the cell that settles under the pointer.
    result = MakeListsUpdate(Lists(), {300, 100}, false, 0, -1);
    EXPECT_TRUE(result.state.items_front);
    EXPECT_EQ(result.state.item_top, 1);
    EXPECT_EQ(result.state.item_cursor, 13);
    EXPECT_FALSE(result.sound);
    EXPECT_EQ(result.buttons, 0);
}

TEST(MenuMouseMake, ClickWithAWheelNotchConfirmsTheDrawnTarget) {
    auto result = MakeListsUpdate(Lists(), {100, 100}, false, 1, -1);
    EXPECT_EQ(result.state.card_cursor, 0);
    EXPECT_EQ(result.state.card_top, 0);
    EXPECT_EQ(result.buttons, PAD_CROSS);
    auto items = Lists();
    items.items_front = true;
    result = MakeListsUpdate(items, {300, 100}, false, 1, -1);
    EXPECT_EQ(result.state.item_top, 0);
    EXPECT_EQ(result.state.item_cursor, 7);
    EXPECT_EQ(result.buttons, PAD_CROSS);
}

TEST(MenuMouseMake, WheelOverTheBoardTopStripKeepsTheCursorInTheNewRows) {
    auto items = Lists();
    items.items_front = true;
    // (300, 45) is inside the aperture but above the first resting row.
    auto result = MakeListsUpdate(items, {300, 45}, false, 0, -1);
    EXPECT_EQ(result.state.item_top, 1);
    EXPECT_EQ(result.state.item_cursor, 6);
    // The retail scroll check that MenuItemBrdKey runs next keeps the new top line.
    int top = result.state.item_top;
    MenuCheckLine(&top, result.state.item_cursor / 6, 5);
    EXPECT_EQ(top, 1);
}

TEST(MenuMouseMake, AnEasingBoardRowDoesNotLetTheCardsBehindTakeInput) {
    auto items = Lists();
    items.items_front = true;
    // (250, 80) is over card 0 and, in front of it, bag cell 6.
    auto result = MakeListsUpdate(items, {250, 80}, false, 0, -1);
    EXPECT_TRUE(result.state.items_front);
    EXPECT_EQ(result.state.item_top, 1);
    EXPECT_EQ(result.state.item_cursor, 6);
    auto easing = result.state;
    easing.board_origin.y = 37.5f; // Row 0 is still drawn under the pointer.
    result = MakeListsUpdate(easing, {250, 80}, false, 0, -1);
    EXPECT_TRUE(result.state.items_front);
    EXPECT_EQ(result.state.item_top, 2);
    EXPECT_EQ(result.state.card_cursor, 0);
    result = MakeListsUpdate(easing, {250, 80}, true, 1, 0);
    EXPECT_TRUE(result.state.items_front);
    EXPECT_EQ(result.state.card_cursor, 0);
    EXPECT_EQ(result.state.item_cursor, 6);
    EXPECT_EQ(result.buttons, 0);
}

TEST(MenuMouseMake, RowsSlidingOutOfTheBoardAreNotHit) {
    auto lists = Lists();
    lists.items_front = true;
    lists.item_top = 1;
    lists.board_origin = {236, 20}; // Easing from top 0 towards top 1: row 0 is still drawn.
    auto result = MakeListsUpdate(lists, {300, 50}, true, 1, 0);
    EXPECT_EQ(result.state.item_cursor, 0);
    EXPECT_EQ(result.buttons, 0);
    result = MakeListsUpdate(lists, {300, 80}, true, 0, 0);
    EXPECT_EQ(result.state.item_cursor, 7);
}

namespace {
// CommonBoardDraw for a board at (152, 30) with the English minimum width.
const float     kInfo[5] = {172, 276, 172, 304, 248};
const MakeBoard kBoard = MakeBoardRects({152, 30}, kInfo);
} // namespace

TEST(MenuMouseMake, BoardRectsFollowTheRetailDrawPlacement) {
    EXPECT_FLOAT_EQ(kBoard.make.x, 172);
    EXPECT_FLOAT_EQ(kBoard.make.y, 276);
    EXPECT_FLOAT_EQ(kBoard.quit.y, 304);
    // arrow_x = 10 + 152 + 124 + 24.8 + 2, truncated as the draw does.
    EXPECT_FLOAT_EQ(kBoard.fewer.x, 312);
    EXPECT_FLOAT_EQ(kBoard.fewer.y, 280);
    EXPECT_FLOAT_EQ(kBoard.count.x, 328);
    EXPECT_FLOAT_EQ(kBoard.more.x, 362);
    EXPECT_FALSE(kBoard.make.Contains({172, 302}));
    EXPECT_TRUE(kBoard.quit.Contains({172, 304}));
}

TEST(MenuMouseMake, BoardClicksAndWheelBecomeRetailKeys) {
    EXPECT_EQ(MakeBoardInput(kBoard, {180, 280}, false, 1, 0).buttons, PAD_CROSS);
    EXPECT_EQ(MakeBoardInput(kBoard, {315, 290}, false, 1, 0).buttons, PAD_LEFT);
    EXPECT_EQ(MakeBoardInput(kBoard, {365, 290}, false, 1, 0).buttons, PAD_RIGHT);
    EXPECT_EQ(MakeBoardInput(kBoard, {340, 290}, false, 1, 0).buttons, PAD_CROSS);
    EXPECT_EQ(MakeBoardInput(kBoard, {20, 20}, false, 1, 0).buttons, 0);
    EXPECT_EQ(MakeBoardInput(kBoard, {340, 290}, true, 0, 0).row, 0); // The count belongs to the Make row.
    auto wheel = MakeBoardInput(kBoard, {180, 310}, false, 0, 1);
    EXPECT_EQ(wheel.row, 0);
    EXPECT_EQ(wheel.buttons, PAD_RIGHT);
}

namespace {
// Drives the adapters through the retail CheckSelectKey, as MenuInventKey and KeyStep do.
// The retail menus' constructors are unit-local, so the tests use zeroed storage and set
// only the members the adapters read; no virtual member is called.
class MakeMouse : public testing::Test {
protected:
    CMenuKeyFunc keys;
    alignas(CMenuInvent) unsigned char invent_storage[sizeof(CMenuInvent)] {};
    alignas(CMenuMosSelect) unsigned char box_storage[sizeof(CMenuMosSelect)] {};
    CMenuInvent        &invent = *reinterpret_cast<CMenuInvent *>(invent_storage);
    CMenuMosSelect     &box = *reinterpret_cast<CMenuMosSelect *>(box_storage);
    CMenuPosDataForm    makebrd{}, badges{};
    MENUFORMPARTS_TYPE  badge_parts[MOS_SELECT_BADGE_NUM]{};
    char                badge_names[MOS_SELECT_BADGE_NUM][4]{};
    MOS_CHANGE_PARAM    badge[MOS_SELECT_BADGE_NUM]{};
    CMenuKeyFunc       *saved_keys = MenuCommonInfo;
    CMenuInvent        *saved_invent = TestInventPt;
    CGamePad            saved_pad = GamePad__2;
    BUILDUP_WEAPON_INFO saved_buildup = BuildUpWeaponInfo;
    MENU_LOAD_INFO      saved_load = MenuLoadInfo;
    float               saved_info[5]{};
    s16                 saved_names[3][2]{};
    int                 saved_width = mgScreenWidth, saved_height = mgScreenHeight;

    void SetUp() override {
        std::memcpy(saved_info, MakeBoardDrawInfo, sizeof(saved_info));
        std::memcpy(saved_names, BuildUpNameXY, sizeof(saved_names));
        MenuMouseEnable(false);
        InputSetScriptedDevices({});
        mgEndFrame(nullptr);
        MenuMouseTake();
        InputResetBindings();
        mgScreenWidth = 512;
        mgScreenHeight = 480;
        MenuCommonInfo = &keys;
        GamePad__2.key_lock = 0;
        GamePad__2.pad[0].button = GamePad__2.previous_pad[0].button = 0;
        keys.key_enable = true;
        keys.now_mode = MENU_MODE_INVENT;
        TestInventPt = &invent;
        std::memcpy(MakeBoardDrawInfo, kInfo, sizeof(kInfo));
        makebrd.x = 152;
        makebrd.y = 30;
        makebrd.draw_flag = true;
        invent.makebrd_form = &makebrd;
        badges.draw_flag = true;
        badges.parts = badge_parts;
        badges.parts_num = MOS_SELECT_BADGE_NUM;
        for (int i = 0; i < MOS_SELECT_BADGE_NUM; ++i) {
            std::snprintf(badge_names[i], sizeof(badge_names[i]), "B%d", i);
            auto &part = badge_parts[i];
            part.name = badge_names[i];
            part.dtype = MENUFORMPARTS_DTYPE_FUNCINFO;
            part.x = 40.0f + 66 * (i % 3);
            part.y = 82.0f + 66 * (i / 3);
            part.w = part.h = 64;
            part.draw_flag = i == 0 || i == 3; // AttachForm shows only the badges Monica has.
            badge[i].enable = part.draw_flag;
            badge[i].monster_id = static_cast<s16>(100 + i);
        }
        box.badge_form = &badges;
        box.badge = badge;
        ClockSetUnbounded(true);
        MenuMouseEnable(true);
    }

    void TearDown() override {
        MenuMouseEnable(false);
        InputSetScriptedDevices({});
        mgEndFrame(nullptr);
        MenuMouseTake();
        InputResetBindings();
        MenuCommonInfo = saved_keys;
        TestInventPt = saved_invent;
        GamePad__2 = saved_pad;
        BuildUpWeaponInfo = saved_buildup;
        MenuLoadInfo = saved_load;
        std::memcpy(MakeBoardDrawInfo, saved_info, sizeof(saved_info));
        std::memcpy(BuildUpNameXY, saved_names, sizeof(saved_names));
        mgScreenWidth = saved_width;
        mgScreenHeight = saved_height;
    }

    // The pointer starts at the screen centre (256, 240).
    void Tick(float dx = 0, float dy = 0, unsigned buttons = 0, float wheel = 0) {
        InputSetScriptedDevices({.mouse_buttons = buttons, .mouse_dx = dx, .mouse_dy = dy, .mouse_wheel = wheel});
        mgEndFrame(nullptr);
        keys.CheckSelectKey();
    }

    // One key step of the badge box, as MenuMonsterBoxKey runs it.
    void BoxTick(float dx = 0, float dy = 0, unsigned buttons = 0, float wheel = 0) {
        InputSetScriptedDevices({.mouse_buttons = buttons, .mouse_dx = dx, .mouse_dy = dy, .mouse_wheel = wheel});
        mgEndFrame(nullptr);
        MenuMouseMonster(box, keys);
    }
};
} // namespace

TEST_F(MakeMouse, QuantityBoardHoverAndClicksDriveTheRetailRow) {
    invent.mode = MENU_ASK_MODE_MAKE;
    invent.step = INVENT_MAKE_STEP_SELECT;
    invent.make_cursor = 0;
    Tick(-76, 70); // Quit at (180, 310).
    EXPECT_EQ(invent.make_cursor, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    Tick(135, -20); // The fewer arrow at (315, 290).
    EXPECT_EQ(invent.make_cursor, 0);
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_LEFT);
    Tick(-200, -200, 0); // Background.
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
}

TEST_F(MakeMouse, PagesWithoutTargetsIgnoreLeftClicksAndBackOutOnRightClicks) {
    invent.mode = MENU_ASK_MODE_NONE;
    invent.key_arg_no = INVENT_MODE_THINK;
    Tick(5, 0);
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    Tick(0, 0, 0);
    Tick(0, 0, 2);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CIRCLE);
}

TEST_F(MakeMouse, BadgeInputActsOnlyInsideTheBoxKeyStep) {
    box.key_arg_no = MOS_SELECT_PAGE_BADGE;
    keys.now_mode = MENU_MODE_CHARA_CHANGE;
    Tick(-184, -60); // Over badge 3, outside MenuMonsterBoxKey.
    EXPECT_EQ(box.select, 0);
    BoxTick(1, 0);
    EXPECT_EQ(box.select, 3);
    EXPECT_EQ(box.view_monster, 103);
    EXPECT_FALSE(MenuLoadInfo.update_scene);
    BoxTick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
}

TEST_F(MakeMouse, HiddenBadgesAndBackgroundTakeNoClicksButTheWheelMovesRows) {
    box.key_arg_no = MOS_SELECT_PAGE_BADGE;
    keys.now_mode = MENU_MODE_CHARA_CHANGE;
    BoxTick(-118, -60); // Badge 4 has no part drawn.
    EXPECT_EQ(box.select, 0);
    BoxTick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    BoxTick(0, 0, 0, -1);
    EXPECT_EQ(box.select, 3);
    EXPECT_EQ(box.view_monster, 103);
}

TEST_F(MakeMouse, BadgeClickWithAWheelNotchOpensTheClickedBadge) {
    box.key_arg_no = MOS_SELECT_PAGE_BADGE;
    keys.now_mode = MENU_MODE_CHARA_CHANGE;
    BoxTick(-184, -140, 1, -1); // (72, 100): badge 0.
    EXPECT_EQ(box.select, 0);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
}

TEST_F(MakeMouse, ClassRowClickWithAWheelNotchConfirmsTheClickedRow) {
    keys.now_mode = MENU_MODE_CHARA_CHANGE;
    box.key_arg_no = MOS_SELECT_PAGE_COMMAND;
    box.step = MOS_SELECT_STEP_CLASS_SELECT;
    BuildUpWeaponInfo.mode = 1;
    BuildUpWeaponInfo.select_num = 3;
    BuildUpWeaponInfo.select_no = 0;
    for (int i = 0; i < 3; ++i) {
        BuildUpNameXY[i][0] = 200;
        BuildUpNameXY[i][1] = static_cast<s16>(200 + 30 * i);
    }
    BoxTick(-46, -35, 1, -1); // (210, 205): the first row.
    EXPECT_EQ(BuildUpWeaponInfo.select_no, 0);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
}

TEST_F(MakeMouse, ClassChangeRowsHoverThenConfirm) {
    keys.now_mode = MENU_MODE_CHARA_CHANGE;
    box.key_arg_no = MOS_SELECT_PAGE_COMMAND;
    box.step = MOS_SELECT_STEP_CLASS_SELECT;
    BuildUpWeaponInfo.mode = 1;
    BuildUpWeaponInfo.select_num = 3;
    BuildUpWeaponInfo.select_no = 0;
    for (int i = 0; i < 3; ++i) {
        BuildUpNameXY[i][0] = 200;
        BuildUpNameXY[i][1] = static_cast<s16>(200 + 30 * i);
    }
    BoxTick(10, 25); // (266, 265): the third row.
    EXPECT_EQ(BuildUpWeaponInfo.select_no, 2);
    BoxTick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
}

TEST_F(MakeMouse, StatusPageWheelStepsFormsAndLeftClickDoesNothing) {
    keys.now_mode = MENU_MODE_CHARA_CHANGE;
    box.key_arg_no = MOS_SELECT_PAGE_STATUS;
    BoxTick(5, 0);
    BoxTick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    BoxTick(0, 0, 0, -1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_R1);
    BoxTick(0, 0, 2);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CIRCLE);
}

TEST(MenuMouseMake, BadgeCellsTileTheBoxWithoutOverlap) {
    MenuMouseRect cells[12];
    for (int i = 0; i < 12; ++i) {
        cells[i] = MenuMouseBadgeCell({40.0f + 66 * (i % 3), 82.0f + 66 * (i / 3), 64, 64});
    }
    EXPECT_EQ(MenuMouseHit(cells, 40, 82), 0);
    EXPECT_EQ(MenuMouseHit(cells, 104.5f, 100), 0); // The gap belongs to a neighbour.
    EXPECT_EQ(MenuMouseHit(cells, 105, 100), 1);
    EXPECT_EQ(MenuMouseHit(cells, 236, 344), 11);
    EXPECT_EQ(MenuMouseHit(cells, 237, 344), -1);
    EXPECT_EQ(MenuMouseBadgeCell({}).w, 0); // A hidden badge stays empty.
}
