#include <gtest/gtest.h>

#include <array>
#include <memory>

#include "../menu_mouse_item.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menuaqua.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib.hpp"
#include "platform/clock.hpp"
#include "platform/input.hpp"
#include "savedata.hpp"

extern CSaveData *PortActiveSaveData asm("MainLoop_ActiveSaveData");

using namespace menumouse;

TEST(MenuMouse, GridUsesSixColumnsAndHalfOpenCellEdges) {
    const Point origin{.x = 240, .y = 50};
    const Rect  clip{.x = 240, .y = 44, .w = 240, .h = 250};
    EXPECT_EQ(GridHit({240, 50}, origin, clip, 144), (Target{ITEM_MENU_PANEL_BAG, 0}));
    EXPECT_EQ(GridHit({279.99f, 99.99f}, origin, clip, 144).cursor, 0);
    EXPECT_EQ(GridHit({280, 50}, origin, clip, 144).cursor, 1);
    EXPECT_EQ(GridHit({240, 100}, origin, clip, 144).cursor, 6);
    EXPECT_FALSE(GridHit({480, 50}, origin, clip, 144));
    EXPECT_FALSE(GridHit({240, 294}, origin, clip, 144));
    EXPECT_FALSE(GridHit({240, 49}, origin, clip, 144));
}

TEST(MenuMouse, GridFollowsAnimatedScrollAndRejectsCapacityOverflow) {
    const Rect clip{.x = 240, .y = 44, .w = 240, .h = 250};
    EXPECT_EQ(GridHit({250, 55}, {240, -50}, clip, 144).cursor, 12);
    EXPECT_EQ(GridHit({250, 49}, {240, 0}, clip, 144).cursor, 0);
    EXPECT_EQ(GridHit({250, 51}, {240, 0}, clip, 144).cursor, 6);
    EXPECT_FALSE(GridHit({450, 260}, {240, 50}, clip, 29));
}

TEST(MenuMouse, WheelUsesWholeNotchesFromSharedAccumulator) {
    EXPECT_EQ(ScrollTop(0, 144, 5, 1), 0);
    EXPECT_EQ(ScrollTop(0, 144, 5, -1), 1);
    EXPECT_EQ(ScrollTop(0, 144, 5, -0.1f), 0);
    EXPECT_EQ(ScrollTop(18, 144, 5, -5), 19);
    EXPECT_EQ(ScrollTop(0, 29, 5, -1), 0);
}

namespace {
const Target source{.panel = ITEM_MENU_PANEL_BAG, .cursor = 1}, dest{.panel = ITEM_MENU_PANEL_BAG, .cursor = 8};
const Take   press{.pointing = true, .moved = true, .pressed = 1, .released = 0, .held = 1}, hold{.pointing = true, .moved = true, .pressed = 0, .released = 0, .held = 1}, release{.pointing = true, .moved = false, .pressed = 0, .released = 1, .held = 0};
} // namespace

TEST(MenuMouse, ShortClickOpensCommandOnRelease) {
    Gesture g;
    EXPECT_EQ(g.Update(press, {100, 100}, source, true, false), Action::None);
    EXPECT_EQ(g.Update(hold, {102, 100}, source, true, false), Action::None);
    EXPECT_EQ(g.Update(release, {102, 100}, source, true, false), Action::Click);
    EXPECT_FALSE(g.pending);
}

TEST(MenuMouse, DragPicksUpSourceThenDropsOnRelease) {
    Gesture g;
    g.Update(press, {.x = 100, .y = 100}, source, true, false);
    EXPECT_EQ(g.Update(hold, {120, 150}, dest, true, false), Action::PickUp);
    EXPECT_EQ(g.source, source);
    EXPECT_EQ(g.Update(hold, {120, 150}, dest, true, true), Action::None);
    EXPECT_EQ(g.Update(release, {120, 150}, dest, true, true), Action::Drop);
}

TEST(MenuMouse, FastDragWaitsForRetailPickupBeforeRelease) {
    Gesture g;
    g.Update(press, {.x = 100, .y = 100}, source, true, false);
    EXPECT_EQ(g.Update(release, {120, 150}, dest, true, false), Action::PickUp);
    EXPECT_EQ(g.Update({true}, {120, 150}, dest, true, true), Action::Drop);
}

TEST(MenuMouse, DropOutsideReturnsItemWithoutDiscard) {
    Gesture g;
    g.Update(press, {.x = 100, .y = 100}, source, true, false);
    g.Update(hold, {.x = 120, .y = 150}, {}, false, false);
    EXPECT_EQ(g.Update(release, {120, 150}, {}, false, true), Action::Cancel);
}

TEST(MenuMouse, RightClickCancelsPendingAndActiveDrags) {
    Gesture g;
    g.Update(press, {}, source, true, false);
    EXPECT_EQ(g.Update({true, true, 2, 0, 3}, {}, source, true, false), Action::Cancel);
    EXPECT_FALSE(g.pending);
    EXPECT_EQ(g.Update(release, {}, source, true, false), Action::None);
}

TEST(MenuMouse, PadTakeoverCancelsOnlyTheMouseGesture) {
    Gesture g;
    g.Update(press, {}, source, true, false);
    EXPECT_EQ(g.Update({}, {}, dest, true, false), Action::None);
    EXPECT_FALSE(g.pending);
    EXPECT_FALSE(g.dragging);
}

TEST(MenuMouse, CarriedRetailItemCanBePlacedWithClick) {
    Gesture g;
    EXPECT_EQ(g.Update(press, {}, dest, true, true), Action::Drop);
    EXPECT_EQ(g.Update(press, {}, {}, false, true), Action::None);
}

namespace {
class ItemMouse : public testing::Test {
protected:
    CMenuKeyFunc        keys;
    CMenuPosDataManage  forms{};
    CMenuPosDataForm    board{}, character{}, hand{}, command{};
    MENUFORMPARTS_TYPE  parts[7]{};
    MENU_INPUTKEY_ARG   layouts[ITEM_MENU_PANEL_NUM]{};
    CGameDataUsed       items[144]{};
    CHARA_DATA          chara{};
    CDC2Mes             message;
    CMenuItemInfo       saved_menu = class_menu_item_info;
    CMENU_USERPARAM     saved_user = MenuUserParam;
    CMenuKeyFunc       *saved_keys = MenuCommonInfo;
    CMenuPosDataManage *saved_forms = MenuPosData;
    CMenuMoveItem      *saved_move = MenuMoveItemPtr;
    CDC2Mes            *saved_message = MenuDCMsg[5];
    CMenuPosDataForm   *saved_message_form = MenuMesForm[5];
    CGamePad            saved_pad = GamePad__2;
    int                 saved_width = mgScreenWidth, saved_height = mgScreenHeight;
    float               saved_board_x = MenuItemBrdUnderBrdPosXY[0], saved_board_y = MenuItemBrdUnderBrdPosXY[1];

    void SetUp() override {
        MenuMouseClose();
        MenuMouseEnable(false);
        InputSetScriptedDevices({});
        mgEndFrame(nullptr);
        MenuMouseTake();
        MenuMousePadTick();
        InputResetBindings();
        mgScreenWidth = 512;
        mgScreenHeight = 480;
        MenuPosData = &forms;
        MenuCommonInfo = &keys;
        MenuMoveItemPtr = nullptr;
        MenuDCMsg[5] = &message;
        MenuMesForm[5] = &command;
        GamePad__2.key_lock = 0;
        GamePad__2.pad[0].button = GamePad__2.previous_pad[0].button = 0;
        keys.now_mode = MENU_MODE_ITEM;
        keys.cursor = keys.top_line = 0;
        keys.key_arg = &layouts[ITEM_MENU_PANEL_BAG];
        keys.cursor_form = &hand;
        for (auto &layout : layouts) {
            layout.columns = layout.disp_columns = 6;
            layout.disp_lines = 5;
            layout.max = 138;
        }
        auto &menu = class_menu_item_info;
        menu.mode = MENU_ASK_MODE_NONE;
        menu.step = 0;
        menu.sub_menu = menu.next_sub_menu = MENU_ITEM_SUB_MENU_NONE;
        menu.view_mode = MENU_ITEM_VIEW_MAX;
        menu.sub_view = 0;
        menu.key_arg_no = ITEM_MENU_PANEL_BAG;
        menu.item_board_form = &board;
        menu.view_form[0] = &character;
        board.x = 226;
        board.y = 24;
        character.draw_flag = true;
        character.parts = parts;
        character.parts_num = 7;
        char *names[] = {const_cast<char *>("item0"), const_cast<char *>("item1"), const_cast<char *>("item2"),
                         const_cast<char *>("wep0"), const_cast<char *>("wep1"),
                         const_cast<char *>("c_i0"), const_cast<char *>("c_w0")};
        Point positions[] = {
            {.x = 50,  .y = 58 },
            {.x = 91,  .y = 58 },
            {.x = 133, .y = 58 },
            {.x = 30,  .y = 400},
            {.x = 196, .y = 400},
            {.x = 29,  .y = 50 },
            {.x = 3,   .y = 379}
        };
        for (int i = 0; i < 7; ++i) {
            parts[i].name = names[i];
            parts[i].x = positions[i].x;
            parts[i].y = positions[i].y;
            parts[i].dtype = MENUFORMPARTS_DTYPE_FUNCINFO;
        }
        for (int i = 0; i < 3; ++i) {
            menu.item_parts[0][i] = &parts[i];
        }
        menu.wep_parts[0][8] = &parts[3];
        menu.wep_parts[0][14] = &parts[4];
        MenuItemBrdUnderBrdPosXY[0] = 242;
        MenuItemBrdUnderBrdPosXY[1] = 50;
        MenuUserParam.used_data = items;
        MenuUserParam.chara[0] = &chara;
        ClockSetUnbounded(true);
        MenuMouseEnable(true);
        MenuMouseUpdate(keys); // Opening consumes held buttons without activating.
    }

    void TearDown() override {
        MenuMouseClose();
        MenuMouseEnable(false);
        InputSetScriptedDevices({});
        mgEndFrame(nullptr);
        MenuMouseTake();
        MenuMousePadTick();
        InputResetBindings();
        class_menu_item_info = saved_menu;
        MenuUserParam = saved_user;
        MenuCommonInfo = saved_keys;
        MenuPosData = saved_forms;
        MenuMoveItemPtr = saved_move;
        MenuDCMsg[5] = saved_message;
        MenuMesForm[5] = saved_message_form;
        GamePad__2 = saved_pad;
        mgScreenWidth = saved_width;
        mgScreenHeight = saved_height;
        MenuItemBrdUnderBrdPosXY[0] = saved_board_x;
        MenuItemBrdUnderBrdPosXY[1] = saved_board_y;
    }

    void Tick(float dx = 0, float dy = 0, unsigned buttons = 0, float wheel = 0) {
        InputSetScriptedDevices({.mouse_buttons = buttons, .mouse_dx = dx, .mouse_dy = dy, .mouse_wheel = wheel});
        mgEndFrame(nullptr);
        keys.SelDataInit();
    }

    // Moves the pointer to a logical position, starting it at the retail hand if needed.
    void MoveTo(float x, float y) {
        if (!MenuMouseTake().pointing) {
            Tick(0.5f, 0);
        }
        Tick(x - MenuMouseTake().x, y - MenuMouseTake().y);
    }

    // What hovering a position selects; miss if it is no target.
    const Target miss{.panel = ITEM_MENU_PANEL_BAG, .cursor = 137};

    Target PanelAt(float x, float y) {
        class_menu_item_info.key_arg_no = miss.panel;
        keys.key_arg = &layouts[miss.panel];
        keys.cursor = miss.cursor;
        MoveTo(x, y);
        return {.panel = class_menu_item_info.key_arg_no, .cursor = keys.cursor};
    }
};
} // namespace

TEST_F(ItemMouse, HoverUpdatesRetailGridSelectionWithoutPressingAnything) {
    Tick(40, 50);
    EXPECT_EQ(class_menu_item_info.key_arg_no, ITEM_MENU_PANEL_BAG);
    EXPECT_EQ(keys.cursor, 7);
    EXPECT_EQ(keys.select_pos[0], 7);
    EXPECT_EQ(keys.key_arg, &layouts[ITEM_MENU_PANEL_BAG]);
    EXPECT_TRUE(keys.CheckKeyInput());
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
}

TEST_F(ItemMouse, AllActiveAndEquippedSlotsUseTheirDrawnIconPositions) {
    Tick(-196, -1); // First slot centre (66,74).
    EXPECT_EQ(class_menu_item_info.key_arg_no, ITEM_MENU_PANEL_ACTIVE_ITEMS);
    EXPECT_EQ(keys.cursor, 0);
    Tick(41, 0);
    EXPECT_EQ(keys.cursor, 1);
    Tick(42, 0);
    EXPECT_EQ(keys.cursor, 2);
    Tick(-103, 342);
    EXPECT_EQ(class_menu_item_info.key_arg_no, ITEM_MENU_PANEL_EQUIPMENT);
    EXPECT_EQ(keys.cursor, 0);
    Tick(166, 0);
    EXPECT_EQ(keys.cursor, 1);
    EXPECT_EQ(keys.key_arg, &layouts[ITEM_MENU_PANEL_EQUIPMENT]);
}

TEST_F(ItemMouse, HoverSoundsOnlyTheMovesTheRetailCursorCheckCannotSee) {
    const int sounds = MenuMouseCursorSounds();
    Tick(-196, -1); // Bag cell 0 to active item 0: the same index on another panel.
    EXPECT_EQ(class_menu_item_info.key_arg_no, ITEM_MENU_PANEL_ACTIVE_ITEMS);
    EXPECT_EQ(keys.cursor, keys.save_cursor);
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 1);
    Tick(41, 0); // KeyStepLocal sounds a cursor that differs from the saved one.
    EXPECT_EQ(keys.cursor, 1);
    EXPECT_NE(keys.cursor, keys.save_cursor);
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 1);
    Tick(1, 0);
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 1);
}

TEST_F(ItemMouse, HoverCharacterSetsTheRetailCharacterTarget) {
    Tick(-116, 150);
    EXPECT_EQ(class_menu_item_info.key_arg_no, ITEM_MENU_PANEL_CHARA);
    EXPECT_EQ(keys.cursor, 0);
}

TEST_F(ItemMouse, WheelChangesVisibleRowAndCursorTogether) {
    Tick(1, 0, 0, -5);
    EXPECT_EQ(keys.cursor, 30);
    EXPECT_EQ(keys.top_line, 5);
    EXPECT_TRUE(keys.CheckKeyInput());
    Tick(0, 0, 0, 100);
    EXPECT_EQ(keys.cursor, 0);
    EXPECT_EQ(keys.top_line, 0);
}

TEST_F(ItemMouse, WheelScrollEasesLikeTheRetailDpadScroll) {
    const auto saved_manner = MenuItemBrdCalcManner;
    MenuItemBrdCalcManner = MENU_ITEM_BRD_CALC_EASE;
    MenuItemBrdUnderBrdPosXY[1] = 50; // The retail board origin for top line 0.
    Tick(1, 0, 0, -1);
    EXPECT_EQ(keys.top_line, 1);
    EXPECT_EQ(keys.cursor, 6); // The cell that settles under the pointer.
    EXPECT_EQ(MenuItemBrdCalcManner, MENU_ITEM_BRD_CALC_EASE);
    EXPECT_FLOAT_EQ(MenuItemBrdUnderBrdPosXY[1], 50); // Not snapped by the mouse.
    Func_MenuItemBrdPosStep(keys.top_line);
    EXPECT_LT(MenuItemBrdUnderBrdPosXY[1], 50);
    EXPECT_GT(MenuItemBrdUnderBrdPosXY[1], 0); // Part way to the next row.
    // Row 0 is sliding out: hovering it no longer moves the cursor back.
    Tick(0, 1); // Still over the drawn first row.
    EXPECT_EQ(keys.cursor, 6);
    EXPECT_EQ(keys.top_line, 1);
    for (int i = 0; i < 60; ++i) {
        Func_MenuItemBrdPosStep(keys.top_line);
    }
    EXPECT_NEAR(MenuItemBrdUnderBrdPosXY[1], 0, 1);
    MenuItemBrdCalcManner = saved_manner;
}

TEST_F(ItemMouse, ClickDuringAnEasedWheelScrollConfirmsTheClickedCell) {
    const auto saved_manner = MenuItemBrdCalcManner;
    MenuItemBrdCalcManner = MENU_ITEM_BRD_CALC_EASE;
    MenuItemBrdUnderBrdPosXY[1] = 50;
    items[6].item_no = 1;
    items[12].item_no = 1;
    // Mouse1 and a wheel notch arrive together over cell 6 at (263, 130).
    Tick(1, 55, 1, -1);
    EXPECT_EQ(keys.top_line, 1);
    EXPECT_EQ(keys.cursor, 12); // The cell that will settle under the pointer.
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    MenuItemBrdUnderBrdPosXY[1] = 37.5f; // Part way through the retail ease; cell 6 is still drawn there.
    Tick();
    EXPECT_EQ(keys.cursor, 6);
    EXPECT_EQ(keys.top_line, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    MenuItemBrdCalcManner = saved_manner;
}

TEST_F(ItemMouse, WheelOverTheBoardTopStripKeepsTheCursorInTheNewRows) {
    MenuItemBrdUnderBrdPosXY[1] = 50;
    // (263, 45) is inside the aperture but above the first resting row.
    Tick(1, -30, 0, -1);
    EXPECT_EQ(keys.top_line, 1);
    EXPECT_EQ(keys.cursor, 6);
    // The retail key pass that follows keeps the new top line.
    auto  save = std::make_unique<CSaveData>();
    auto *saved = PortActiveSaveData;
    PortActiveSaveData = save.get();
    MenuItemBrdKey(0, &keys.cursor, &keys.top_line, ITEM_BOARD_MAIN);
    PortActiveSaveData = saved;
    EXPECT_EQ(keys.top_line, 1);
    EXPECT_EQ(keys.cursor, 6);
}

TEST(MenuMouse, VisibleRowUsesTheTargetTopLine) {
    EXPECT_TRUE(VisibleRow(6, 1, 5));
    EXPECT_FALSE(VisibleRow(5, 1, 5));
    EXPECT_TRUE(VisibleRow(35, 1, 5));
    EXPECT_FALSE(VisibleRow(36, 1, 5));
    EXPECT_FALSE(VisibleRow(-1, 0, 5));
}

TEST_F(ItemMouse, DragEmitsRetailPickupThenCrossAtDestination) {
    items[0].item_no = 1;
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    Tick(40, 50, 1);
    EXPECT_EQ(keys.cursor, 0); // Pickup still operates on the original item.
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_SQUARE);
    keys.have_item.item_no = 1; // The retail key step has picked it up.
    Tick(0, 0, 1);
    EXPECT_EQ(keys.cursor, 7); // Even if the mouse stops moving after pickup.
    Tick();
    EXPECT_EQ(keys.cursor, 7);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    EXPECT_TRUE(GamePad__2.Down(PAD_CROSS));
}

TEST_F(ItemMouse, ClickAndBackBecomeRetailButtonEdges) {
    items[0].item_no = 1;
    Tick(0, 0, 1);
    Tick();
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    Tick(0, 0, 2);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CIRCLE);
    GamePad__2.key_lock = 1;
    EXPECT_FALSE(GamePad__2.Down(PAD_CIRCLE));
}

TEST_F(ItemMouse, CommandHoverAndClickUseTheDisplayedMessageRows) {
    auto &menu = class_menu_item_info;
    menu.mode = MENU_ASK_MODE_ITEM_COMMAND;
    menu.ask_para.form = &command;
    menu.ask_para.mes_no = 5;
    menu.ask_para.cmd_num = 3;
    command.draw_flag = true;
    message.text_x = 250;
    message.text_y = 100;
    message.text_w = 100;
    message.font_h = 24;
    message.draw_off_x = message.draw_off_y = 0;
    message.window_mode = MES_WIN_FLOATING;
    message.centering = 0;
    message.cursor = 0;
    Tick(0, 24); // Start at the selected command, then move down one row.
    EXPECT_EQ(message.GetMsgCursor(), 1);
    EXPECT_EQ(keys.cursor, 0);
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    Tick(150, 0, 0);
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
}

TEST_F(ItemMouse, PadInputAndLockedMenusKeepTheirSelection) {
    GamePad__2.pad[0].button = PAD_RIGHT;
    Tick(80, 0, 1);
    EXPECT_EQ(keys.cursor, 0);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_RIGHT);
    EXPECT_TRUE(GamePad__2.Down(PAD_RIGHT));
    GamePad__2.pad[0].button = 0;
    keys.key_enable = false;
    Tick(80, 0);
    EXPECT_EQ(keys.cursor, 0);
}

TEST_F(ItemMouse, TakingOverAnActiveSlotStartsAtTheRetailHandTip) {
    class_menu_item_info.key_arg_no = ITEM_MENU_PANEL_ACTIVE_ITEMS;
    keys.key_arg = &layouts[ITEM_MENU_PANEL_ACTIVE_ITEMS];
    hand.x = 40;
    hand.y = 60;
    Tick(41, 0);
    EXPECT_EQ(class_menu_item_info.key_arg_no, ITEM_MENU_PANEL_ACTIVE_ITEMS);
    EXPECT_EQ(keys.cursor, 1);
}

TEST_F(ItemMouse, LeavingWhilePressedQuarantinesTheButtonUntilRelease) {
    Tick(1, 0, 1);
    keys.now_mode = MENU_MODE_MAIN_TOWN;
    GamePad__2.MenuModeOff();
    mgEndFrame(nullptr);
    MenuMouseTake();
    MenuMousePadTick();
    InputKeyboardMouse mouse{.mouse_buttons = 1};
    EXPECT_EQ(InputApplyKeyboardMouse({}, mouse).buttons, 0);
    InputSetScriptedDevices({});
    mgEndFrame(nullptr);
    MenuMouseTake();
    MenuMousePadTick();
    EXPECT_NE(InputApplyKeyboardMouse({}, mouse).buttons, 0);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
}

TEST_F(ItemMouse, ConfirmationChoicesUseRetailYesNoState) {
    auto &menu = class_menu_item_info;
    menu.mode = MENU_ASK_MODE_TRUSH;
    menu.ask_para.mes_no = 5;
    command.draw_flag = true;
    message.window_mode = MES_WIN_YESNO;
    message.choice_pos[0][0] = 250;
    message.choice_pos[0][1] = 100;
    message.choice_pos[1][0] = 350;
    message.choice_pos[1][1] = 100;
    message.cursor = 1;
    Tick(0, 30);
    EXPECT_EQ(message.GetMsgCursor(), 0);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    Tick(100, 0);
    EXPECT_EQ(message.GetMsgCursor(), 1);
    command.draw_flag = false;
    Tick(-100, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
}

TEST_F(ItemMouse, QuantityBoardWheelAndArrowsUseRetailDirectionKeys) {
    class_menu_item_info.mode = MENU_ASK_MODE_HOW_MUCH;
    keys.how_much_form = &command;
    command.draw_flag = true;
    command.parts = parts;
    command.parts_num = 2;
    parts[0].name = const_cast<char *>("up");
    parts[0].x = 250;
    parts[0].y = 70;
    parts[1].name = const_cast<char *>("down");
    parts[1].x = 250;
    parts[1].y = 110;
    Tick(1, 0, 0, -1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_DOWN);
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_UP);
    Tick(0, 40);
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_DOWN);
}

TEST_F(ItemMouse, ControllerOnlyItemPageDoesNotMoveTheSharedPointerOrigin) {
    Tick();
    EXPECT_FALSE(MenuMouseTake().pointing);
    EXPECT_FLOAT_EQ(MenuMouseTake().x, 256);
    EXPECT_FLOAT_EQ(MenuMouseTake().y, 240);
    keys.now_mode = MENU_MODE_MAIN_TOWN;
    Tick(10, 0);
    EXPECT_FLOAT_EQ(MenuMouseTake().x, 266);
    EXPECT_FLOAT_EQ(MenuMouseTake().y, 240);
}

TEST_F(ItemMouse, CommandRowsFollowDrawnLinePositionsAndWidths) {
    auto &menu = class_menu_item_info;
    menu.mode = MENU_ASK_MODE_ITEM_COMMAND;
    menu.ask_para = {};
    menu.ask_para.form = &command;
    menu.ask_para.mes_no = 5;
    menu.ask_para.cmd_num = 3;
    command.draw_flag = true;
    message.text_x = 250;
    message.text_y = 100;
    message.text_w = 50;
    message.font_h = 24;
    message.cursor = 0;
    message.line_pos_on[2] = 1;
    message.line_pos[2][0] = 300;
    message.line_pos[2][1] = 210;
    message.line_w[2] = 100;
    Tick(65, 100, 1); // (340,212), in the drawn third row, outside text_w.
    EXPECT_EQ(message.GetMsgCursor(), 2);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
}

TEST_F(ItemMouse, WeaponAndRodStatsHoverBothColumnsUsingMovedForms) {
    auto              &menu = class_menu_item_info;
    MENUFORMPARTS_TYPE stats[10]{};
    char               names[10][16];
    CMenuPosDataForm   stat_form{};
    stat_form.x = 30;
    stat_form.y = 40;
    stat_form.draw_flag = true;
    stat_form.parts = stats;
    stat_form.parts_num = 10;
    for (int i = 0; i < 10; ++i) {
        std::snprintf(names[i], sizeof(names[i]), "index%d", i);
        stats[i].name = names[i];
        stats[i].x = 70 + (i % 2) * 110;
        stats[i].y = 130 + (i / 2) * 24;
        stats[i].w = 104;
        stats[i].h = 20;
        stats[i].draw_flag = true;
    }
    menu.view_mode = MENU_ITEM_VIEW_WEAPON;
    menu.view_form[2] = &stat_form;
    Tick(-142, 98); // Bag centre (262,75) -> first stat (120,173).
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_WEAPON_STATS);
    EXPECT_EQ(keys.cursor, 0);
    for (int i = 1; i < 10; ++i) {
        Tick(i % 2 ? 110 : -110, i % 2 ? 0 : 24);
        EXPECT_EQ(keys.cursor, i);
        EXPECT_EQ(keys.select_pos[0], i);
        EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    }
    Tick(0, 0, 2);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CIRCLE);
    menu.view_mode = MENU_ITEM_VIEW_FISHING_ROD;
    menu.view_form[5] = &stat_form;
    for (int i = 0; i < 5; ++i) {
        stats[i].x = 70;
        stats[i].y = 130 + i * 24;
    }
    Tick(-110, -96);
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_FISHING_ROD_STATS);
    EXPECT_EQ(keys.cursor, 0);
    Tick(0, 96);
    EXPECT_EQ(keys.cursor, 4);
}

TEST_F(ItemMouse, UnmappedQuestionClickConfirmsCurrentSelection) {
    class_menu_item_info.mode = MENU_ASK_MODE_EXTEND;
    class_menu_item_info.step = 1;
    class_menu_item_info.ask_para.mes_no = -1;
    Tick(10, 10, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    EXPECT_EQ(keys.cursor, 0);
    Tick(0, 0, 2);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CIRCLE);
}

TEST_F(ItemMouse, QuantityRejectsClicksOutsideItsBoard) {
    class_menu_item_info.mode = MENU_ASK_MODE_HOW_MUCH;
    keys.how_much_form = &command;
    command.draw_flag = true;
    command.parts = parts;
    command.parts_num = 2;
    parts[0].name = const_cast<char *>("up");
    parts[0].x = 250;
    parts[0].y = 70;
    parts[1].name = const_cast<char *>("down");
    parts[1].x = 250;
    parts[1].y = 110;
    Tick(-150, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    Tick(0, 0);
    Tick(150, 20, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
}

TEST_F(ItemMouse, FollowupYesNoUsesVisibleMessageInsteadOfStaleAskId) {
    class_menu_item_info.mode = MENU_ASK_MODE_EXTEND;
    class_menu_item_info.ask_para.mes_no = -1;
    CDC2Mes     followup;
    auto *const saved = MenuDCMsg[7];
    auto *const saved_form = MenuMesForm[7];
    MenuDCMsg[7] = &followup;
    MenuMesForm[7] = &command;
    command.draw_flag = true;
    followup.font_h = 24;
    followup.cursor = 0;
    followup.window_mode = MES_WIN_YESNO;
    followup.choice_pos[0][0] = 210;
    followup.choice_pos[0][1] = 150;
    followup.choice_pos[1][0] = 290;
    followup.choice_pos[1][1] = 150;
    Tick(40, 85, 1);
    EXPECT_EQ(followup.cursor, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    MenuDCMsg[7] = saved;
    MenuMesForm[7] = saved_form;
}

TEST_F(ItemMouse, CommandExplanationStillAcceptsConfirmAndCancel) {
    class_menu_item_info.mode = MENU_ASK_MODE_ITEM_COMMAND;
    class_menu_item_info.step = 1;
    class_menu_item_info.ask_para.mes_no = -1;
    Tick(1, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    Tick(0, 0, 2);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CIRCLE);
}

TEST_F(ItemMouse, RidepodSlotsUseTheirMovedFormPositions) {
    class_menu_item_info.view_mode = MENU_ITEM_VIEW_ROBO;
    class_menu_item_info.view_form[3] = &character;
    parts[0].name = const_cast<char *>("c_w0");
    parts[0].x = 40;
    parts[0].y = 180;
    parts[1].name = const_cast<char *>("c_w1");
    parts[1].x = 130;
    parts[1].y = 180;
    Tick(-202, 115);
    EXPECT_EQ(class_menu_item_info.key_arg_no, ITEM_MENU_PANEL_RIDEPOD_PARTS);
    EXPECT_EQ(keys.cursor, 0);
    Tick(90, 0, 1);
    EXPECT_EQ(keys.cursor, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
}

TEST_F(ItemMouse, BuildUpListHoverSelectsBeforeClickConfirms) {
    const auto saved = BuildUpWeaponInfo;
    s16        saved_pos[3][2];
    std::copy(&BuildUpNameXY[0][0], &BuildUpNameXY[0][0] + 6, &saved_pos[0][0]);
    class_menu_item_info.mode = MENU_ASK_MODE_EXTEND;
    class_menu_item_info.ask_para.ask_mode = MENU_ITEM_EXTEND_BUILD_UP;
    BuildUpWeaponInfo.select_num = 3;
    BuildUpWeaponInfo.select_no = 0;
    for (int i = 0; i < 3; ++i) {
        BuildUpNameXY[i][0] = 220;
        BuildUpNameXY[i][1] = 100 + 40 * i;
    }
    const int sounds = MenuMouseCursorSounds();
    Tick(1, 115);
    EXPECT_EQ(BuildUpWeaponInfo.select_no, 2);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 1); // The retail step reads the cursor after the mouse.
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 1);
    BuildUpWeaponInfo = saved;
    std::copy(&saved_pos[0][0], &saved_pos[0][0] + 6, &BuildUpNameXY[0][0]);
}

// MenuWeaponBuildUpDraw puts a name board 20 right of and 5 above each recorded name position:
// 0xBE by 0x20 outside Japanese, 0xAC wide in Japanese.
TEST(MenuMouse, BuildUpRowsCoverEachDrawnNameBoard) {
    const short names[3][2] = {
        {262, 80 },
        {262, 158},
        {7,   7  }
    };
    const auto rows = MenuMouseBuildUpRows(names, 2, LANG_ENGLISH);
    EXPECT_TRUE(rows[0].Contains(262, 75));
    EXPECT_TRUE(rows[0].Contains(471.9f, 106.9f));
    EXPECT_FALSE(rows[0].Contains(472, 90));
    EXPECT_FALSE(rows[0].Contains(261.9f, 90));
    EXPECT_FALSE(rows[0].Contains(300, 107));
    EXPECT_TRUE(rows[1].Contains(300, 153));
    EXPECT_EQ(MenuMouseHit(rows, 300, 130), -1); // Between the boards.
    EXPECT_EQ(MenuMouseHit(rows, 10, 10), -1);   // Past count, the third row is empty.
    EXPECT_FLOAT_EQ(MenuMouseBuildUpRows(names, 2, LANG_JAPANESE)[0].w, 0xAC + 20);
    EXPECT_FLOAT_EQ(MenuMouseBuildUpRows(names, 9, LANG_ENGLISH)[2].w, 0xBE + 20);
    EXPECT_FLOAT_EQ(MenuMouseBuildUpRows(names, -1, LANG_ENGLISH)[0].w, 0);
}

TEST_F(ItemMouse, BuildUpClicksConfirmOnlyOnRowsAndRightClickBacksOut) {
    const auto saved = BuildUpWeaponInfo;
    const int  saved_language = LanguageCode;
    s16        saved_pos[3][2];
    std::copy(&BuildUpNameXY[0][0], &BuildUpNameXY[0][0] + 6, &saved_pos[0][0]);
    LanguageCode = LANG_ENGLISH;
    class_menu_item_info.mode = MENU_ASK_MODE_EXTEND;
    class_menu_item_info.ask_para.ask_mode = MENU_ITEM_EXTEND_BUILD_UP;
    BuildUpWeaponInfo.select_num = 2;
    BuildUpWeaponInfo.select_no = 1;
    BuildUpWeaponInfo.enable[0] = BuildUpWeaponInfo.enable[1] = false; // Both "???": retail refuses them.
    const s16 names[2][2] = {
        {262, 80 },
        {262, 158}
    };
    std::copy(&names[0][0], &names[0][0] + 4, &BuildUpNameXY[0][0]);

    MoveTo(460, 100); // The right end of the first board.
    EXPECT_EQ(BuildUpWeaponInfo.select_no, 0);
    MoveTo(240, 170); // Left of the second board, past its gap: no target.
    EXPECT_EQ(BuildUpWeaponInfo.select_no, 0);
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    EXPECT_EQ(BuildUpWeaponInfo.select_no, 0);
    Tick();
    MoveTo(300, 180);
    EXPECT_EQ(BuildUpWeaponInfo.select_no, 1);
    Tick(0, 0, 1); // Retail Cross handles the refusal and its sound.
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    Tick();
    Tick(0, 0, 2);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CIRCLE);
    EXPECT_EQ(BuildUpWeaponInfo.select_no, 1);

    BuildUpWeaponInfo = saved;
    LanguageCode = saved_language;
    std::copy(&saved_pos[0][0], &saved_pos[0][0] + 6, &BuildUpNameXY[0][0]);
}

TEST_F(ItemMouse, CommandMessageIdIsCheckedBeforeIndexingTheMessageTable) {
    class_menu_item_info.mode = MENU_ASK_MODE_ITEM_COMMAND;
    class_menu_item_info.ask_para.form = &command;
    command.draw_flag = true;
    for (int id : {-1, 9}) {
        class_menu_item_info.ask_para.mes_no = id;
        Tick(1, 0, 1);
        EXPECT_EQ(GamePad__2.GetPadDown(), 0);
        Tick(0, 0);
    }
}

TEST_F(ItemMouse, UnselectableFollowupAcceptsClickEvenWhenOriginalCommandIsHidden) {
    class_menu_item_info.mode = MENU_ASK_MODE_ITEM_COMMAND;
    class_menu_item_info.step = 1;
    class_menu_item_info.ask_para.mes_no = 5;
    command.draw_flag = false;
    CDC2Mes          followup;
    CMenuPosDataForm followup_form{};
    auto *const      saved = MenuDCMsg[7];
    auto *const      saved_form = MenuMesForm[7];
    MenuDCMsg[7] = &followup;
    MenuMesForm[7] = &followup_form;
    followup_form.draw_flag = true;
    followup.cursor = -1;
    Tick(1, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    MenuDCMsg[7] = saved;
    MenuMesForm[7] = saved_form;
}

TEST_F(ItemMouse, RodPointsRejectBackgroundAndAcceptStatHit) {
    auto &menu = class_menu_item_info;
    menu.mode = MENU_ASK_MODE_ROD_POINTS;
    menu.view_mode = MENU_ITEM_VIEW_FISHING_ROD;
    CMenuPosDataForm   form{};
    MENUFORMPARTS_TYPE stat{};
    form.draw_flag = stat.draw_flag = true;
    form.parts = &stat;
    form.parts_num = 1;
    stat.name = const_cast<char *>("index0");
    stat.x = 100;
    stat.y = 100;
    stat.w = 100;
    stat.h = 24;
    menu.view_form[5] = &form;
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    Tick(0, 0);
    Tick(-140, 35, 1);
    EXPECT_EQ(keys.cursor, 0);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    menu.view_form[5] = nullptr;
}

TEST_F(ItemMouse, RodPointHoverLeavesTheSoundToTheRetailCursorCheck) {
    auto &menu = class_menu_item_info;
    menu.mode = MENU_ASK_MODE_ROD_POINTS;
    menu.view_mode = MENU_ITEM_VIEW_FISHING_ROD;
    CMenuPosDataForm   form{};
    MENUFORMPARTS_TYPE stat{};
    form.draw_flag = stat.draw_flag = true;
    form.parts = &stat;
    form.parts_num = 1;
    stat.name = const_cast<char *>("index0");
    stat.x = stat.y = 100;
    stat.w = 100;
    stat.h = 24;
    menu.view_form[5] = &form;
    Tick(-140, 35);
    keys.cursor = 2; // The keys moved the stat cursor, which is select_pos[0].
    const int sounds = MenuMouseCursorSounds();
    Tick(1, 0);
    EXPECT_EQ(keys.select_pos[0], 0);
    EXPECT_NE(keys.cursor, keys.save_cursor);   // KeyStepLocal sounds this move...
    EXPECT_EQ(MenuMouseCursorSounds(), sounds); // ...so the mouse does not.
    menu.view_form[5] = nullptr;
}

TEST_F(ItemMouse, RodWheelSpendsRefundsAndKeepsRetailPointLimits) {
    auto         &menu = class_menu_item_info;
    const auto    saved_spectol = SpectolInfoStay;
    CGameDataUsed rod{};
    rod.data.weapon.attribute[0] = 98;
    rod.data.weapon.fusion_point = 250;
    SpectolInfoStay = rod;
    menu.view_weapon = &rod;
    menu.mode = MENU_ASK_MODE_ROD_POINTS;
    menu.view_mode = MENU_ITEM_VIEW_FISHING_ROD;
    keys.key_enable = true;
    keys.select_pos[0] = 0;
    CMenuPosDataForm   form{};
    MENUFORMPARTS_TYPE stat{};
    form.draw_flag = stat.draw_flag = true;
    form.parts = &stat;
    form.parts_num = 1;
    stat.name = const_cast<char *>("index0");
    stat.x = stat.y = 100;
    stat.w = 100;
    stat.h = 24;
    menu.view_form[5] = &form;
    Tick(-140, 35);
    auto wheel = [&](float amount) {
        Tick(0, 0, 0, amount);
        keys.CheckSelectKey();
        const int key = keys.CheckLRKey();
        EXPECT_EQ(key, amount > 0 ? MENU_SELECT_KEY_RIGHT : MENU_SELECT_KEY_LEFT);
        menu.PushKey(key, 0);
        Tick();
    };
    wheel(1);
    EXPECT_EQ(rod.data.weapon.attribute[0], 99);
    EXPECT_EQ(rod.data.weapon.fusion_point, 150);
    wheel(100); // A large wheel sample is still one bounded retail action.
    EXPECT_EQ(rod.data.weapon.attribute[0], 100);
    EXPECT_EQ(rod.data.weapon.fusion_point, 50);
    wheel(1);
    EXPECT_EQ(rod.data.weapon.attribute[0], 100);
    EXPECT_EQ(rod.data.weapon.fusion_point, 50);
    wheel(-1);
    EXPECT_EQ(rod.data.weapon.attribute[0], 99);
    EXPECT_EQ(rod.data.weapon.fusion_point, 150);
    wheel(-1);
    wheel(-1); // Cannot refund points already present on entry.
    EXPECT_EQ(rod.data.weapon.attribute[0], 98);
    EXPECT_EQ(rod.data.weapon.fusion_point, 250);
    rod.data.weapon.fusion_point = 99;
    wheel(1);
    EXPECT_EQ(rod.data.weapon.attribute[0], 98);
    EXPECT_EQ(rod.data.weapon.fusion_point, 99);
    Tick(300, 0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    SpectolInfoStay = saved_spectol;
    menu.view_form[5] = nullptr;
}

namespace {
// A page form whose parts sit relative to its origin, as the item menu's layout places them.
struct PagePart {
    const char *name = nullptr;
    float       x = 0, y = 0, w = 0, h = 0;
};

struct PageForm {
    CMenuPosDataForm                  form{};
    std::array<MENUFORMPARTS_TYPE, 3> parts{};

    PageForm(const PageForm &) = delete; // form.parts points into this object.

    PageForm(float x, float y, std::initializer_list<PagePart> named) {
        form.x = x;
        form.y = y;
        form.draw_flag = true;
        form.parts = parts.data();
        for (const auto &named_part : named) {
            auto &part = parts.at(form.parts_num++);
            part.name = const_cast<char *>(named_part.name);
            part.x = named_part.x;
            part.y = named_part.y;
            part.w = named_part.w;
            part.h = named_part.h;
            part.draw_flag = true;
        }
    }
};

// The English item layout, menu/1/itemmn0.pac/item.cfg.json: each page's settled
// position (its FORM_ACTDEF into the menu) and the parts the hit areas use.
// The other PAL languages match; Japanese places the pages higher.
PageForm WeaponPage() { return {-10, 258, {{.name = "chrpos", .x = 46, .y = -96}}}; } // form_view1

PageForm RodPage() { return {-10, 258, {{.name = "chrpos", .x = 46, .y = -66}}}; } // form_view4

PageForm MonsterPage() { return {24, 352, {{.name = "chr_cur", .x = 4, .y = -178}}}; } // form_view3

PageForm RidepodPage() { // form_view2
    return {
        24, 352, {{.name = "chr_cur", .x = 18, .y = -178}, {.name = "c_w0", .x = -16, .y = 0}, {.name = "c_w1", .x = 134, .y = 45}}
    };
}

PageForm MaxPage() { // form_view00
    return {
        24, 352, {{.name = "c_i0", .x = 5, .y = -302}, {.name = "c_w0", .x = -21, .y = 27}, {.name = "esa0", .x = 31, .y = 84, .w = 24, .h = 30}}
    };
}
} // namespace

TEST_F(ItemMouse, WeaponPageModelIsTheRetailWeaponTarget) {
    auto    &menu = class_menu_item_info;
    PageForm weapon = WeaponPage();
    menu.view_mode = MENU_ITEM_VIEW_WEAPON;
    menu.view_form[2] = &weapon.form;
    items[0].item_no = 1;
    Tick(0, 0, 1);
    Tick(-152, 85, 1); // Bag cell 0 (262,75) -> the turning weapon (110,160).
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_SQUARE);
    keys.have_item.item_no = 1; // The retail key step has picked up the attachment.
    Tick(0, 0, 1);
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_WEAPON);
    EXPECT_EQ(keys.key_arg, &layouts[ITEM_MENU_PANEL_WEAPON]);
    EXPECT_EQ(keys.cursor, 0);
    Tick();
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS); // Retail's use-on-weapon, with its fusion question.
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_WEAPON);
}

TEST_F(ItemMouse, WeaponModelStopsAboveTheBoardAndRodUsesItsOwnPage) {
    auto    &menu = class_menu_item_info;
    PageForm weapon = WeaponPage();
    menu.view_mode = MENU_ITEM_VIEW_WEAPON;
    menu.view_form[2] = &weapon.form;
    Tick(-152, 165); // (110,240): the durability bar, under the model's area.
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_BAG);
    Tick(0, -4);
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_WEAPON);
    weapon.form.draw_flag = false;
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), 0); // A hidden page has no target to confirm.
    PageForm rod = RodPage();
    menu.view_mode = MENU_ITEM_VIEW_FISHING_ROD;
    menu.view_form[5] = &rod.form;
    Tick(0, 1);
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_FISHING_ROD);
    EXPECT_EQ(keys.key_arg, &layouts[ITEM_MENU_PANEL_FISHING_ROD]);
}

TEST_F(ItemMouse, DropOnCharacterSendsTheRetailUseOnCharacterKeys) {
    items[0].item_no = 1;
    Tick(0, 0, 1);
    Tick(-122, 155, 1); // Bag cell 0 -> Max's model (140,230).
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_SQUARE);
    keys.have_item.item_no = 1;
    Tick(0, 0, 1);
    EXPECT_EQ(class_menu_item_info.key_arg_no, ITEM_MENU_PANEL_CHARA);
    Tick();
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    EXPECT_EQ(class_menu_item_info.key_arg_no, ITEM_MENU_PANEL_CHARA);
}

TEST_F(ItemMouse, RidepodAndMonsterModelsAreTheirPagesUseTargets) {
    auto    &menu = class_menu_item_info;
    PageForm robo = RidepodPage();
    menu.view_mode = MENU_ITEM_VIEW_ROBO;
    menu.view_form[3] = &robo.form;
    Tick(-162, 155); // (100,230), the ridepod.
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_RIDEPOD);
    EXPECT_EQ(keys.cursor, 0);
    Tick(-60, 135); // (40,365), its first part slot, stays a part target.
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_RIDEPOD_PARTS);
    Tick(0, -25); // (40,340), the name row, is not part of the model.
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_RIDEPOD_PARTS);
    Tick(0, -7); // (40,333), just above the name, is the ridepod again.
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_RIDEPOD);
    EXPECT_EQ(keys.key_arg, &layouts[ITEM_MENU_PANEL_RIDEPOD]);
    PageForm monster = MonsterPage();
    menu.view_mode = MENU_ITEM_VIEW_MONSTER;
    menu.view_form[4] = &monster.form;
    Tick(60, -100); // (100,233).
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_MONSTER);
    EXPECT_EQ(keys.key_arg, &layouts[ITEM_MENU_PANEL_MONSTER]);
}

TEST_F(ItemMouse, BaitSlotNeedsMaxsRodAndItsDrawnPart) {
    auto    &menu = class_menu_item_info;
    PageForm max = MaxPage();
    menu.view_form[0] = &max.form;
    menu.item_parts[0][0] = menu.item_parts[0][1] = menu.item_parts[0][2] = nullptr;
    menu.wep_parts[0][8] = menu.wep_parts[0][14] = nullptr;
    auto  save = std::make_unique<CSaveData>();
    auto *saved = PortActiveSaveData;
    PortActiveSaveData = save.get();
    Tick(-195, 375); // (67,450), the bait icon, but no rod is equipped.
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_BAG);
    save->user_data.chara_data[USER_CHARA_MAX].equip[CHARA_EQUIP_MELEE].item_no = ITEM_ID_FISHING_ROD;
    max.parts[2].draw_flag = false;
    Tick(0, 1);
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_BAG);
    max.parts[2].draw_flag = true;
    Tick(0, 1);
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_FISHING_BAIT);
    EXPECT_EQ(keys.key_arg, &layouts[ITEM_MENU_PANEL_FISHING_BAIT]);
    menu.view_mode = MENU_ITEM_VIEW_MONICA; // Monica's page has no bait.
    menu.sub_view = 1;
    menu.view_form[1] = &max.form;
    menu.item_parts[1][0] = menu.item_parts[1][1] = menu.item_parts[1][2] = nullptr;
    menu.wep_parts[1][8] = menu.wep_parts[1][14] = nullptr;
    menu.key_arg_no = ITEM_MENU_PANEL_BAG;
    Tick(0, 1);
    EXPECT_EQ(menu.key_arg_no, ITEM_MENU_PANEL_BAG);
    PortActiveSaveData = saved;
}

TEST_F(ItemMouse, ModelAreasEndAtTheExtractedLayoutsNeighbours) {
    auto        &menu = class_menu_item_info;
    const Target weapon{.panel = ITEM_MENU_PANEL_WEAPON, .cursor = 0};
    const Target rod{.panel = ITEM_MENU_PANEL_FISHING_ROD, .cursor = 0};
    PageForm     weapon_page = WeaponPage();
    PageForm     rod_page = RodPage();
    menu.view_mode = MENU_ITEM_VIEW_WEAPON;
    menu.view_form[2] = &weapon_page.form;
    // chrpos is at (36,162): the area is x 28-208, from the bag's first row (y 50)
    // to the durability bar 20 above the board (y 238).
    EXPECT_EQ(PanelAt(28, 50), weapon);
    EXPECT_EQ(PanelAt(207.5f, 237.5f), weapon);
    EXPECT_EQ(PanelAt(27.5f, 100), miss);
    EXPECT_EQ(PanelAt(208, 100), miss);
    EXPECT_EQ(PanelAt(110, 49.5f), miss);
    EXPECT_EQ(PanelAt(110, 238), miss);
    EXPECT_EQ(PanelAt(242, 100), (Target{ITEM_MENU_PANEL_BAG, 6})); // The bag's left edge.
    menu.view_mode = MENU_ITEM_VIEW_FISHING_ROD;
    menu.view_form[5] = &rod_page.form;
    EXPECT_EQ(PanelAt(110, 80), rod); // The rod's chrpos is 30 lower.
    EXPECT_EQ(PanelAt(110, 79.5f), miss);
    EXPECT_EQ(PanelAt(207.5f, 237.5f), rod);
    EXPECT_EQ(PanelAt(208, 200), miss);

    // chr_cur is at y 174: the area is x 8-188 (c_w0's left edge) and y 110-336,
    // stopping at the name row above the part slots at y 352.
    PageForm robo_page = RidepodPage();
    PageForm monster_page = MonsterPage();
    menu.view_mode = MENU_ITEM_VIEW_ROBO;
    menu.view_form[3] = &robo_page.form;
    const Target ridepod{.panel = ITEM_MENU_PANEL_RIDEPOD, .cursor = 0};
    const Target monster{.panel = ITEM_MENU_PANEL_MONSTER, .cursor = 0};
    EXPECT_EQ(PanelAt(8, 110), ridepod);
    EXPECT_EQ(PanelAt(187.5f, 335.5f), ridepod);
    EXPECT_EQ(PanelAt(7.5f, 200), miss);
    EXPECT_EQ(PanelAt(188, 200), miss);
    EXPECT_EQ(PanelAt(100, 109.5f), miss);
    EXPECT_EQ(PanelAt(40, 336), miss);
    EXPECT_EQ(PanelAt(40, 352), (Target{ITEM_MENU_PANEL_RIDEPOD_PARTS, 0}));
    menu.view_mode = MENU_ITEM_VIEW_MONSTER;
    menu.view_form[4] = &monster_page.form;
    EXPECT_EQ(PanelAt(8, 110), monster);
    EXPECT_EQ(PanelAt(187.5f, 335.5f), monster);
    EXPECT_EQ(PanelAt(188, 200), miss);
    EXPECT_EQ(PanelAt(100, 336), miss);

    // esa0 is a 24x30 icon at (55,436), with a 4-unit margin.
    PageForm max_page = MaxPage();
    menu.view_mode = MENU_ITEM_VIEW_MAX;
    menu.view_form[0] = &max_page.form;
    menu.item_parts[0][0] = menu.item_parts[0][1] = menu.item_parts[0][2] = nullptr;
    menu.wep_parts[0][8] = menu.wep_parts[0][14] = nullptr;
    auto  save = std::make_unique<CSaveData>();
    auto *saved = PortActiveSaveData;
    PortActiveSaveData = save.get();
    save->user_data.chara_data[USER_CHARA_MAX].equip[CHARA_EQUIP_MELEE].item_no = ITEM_ID_FISHING_ROD;
    const Target bait{.panel = ITEM_MENU_PANEL_FISHING_BAIT, .cursor = 0};
    EXPECT_EQ(PanelAt(51, 432), bait);
    EXPECT_EQ(PanelAt(82.5f, 469.5f), bait);
    EXPECT_EQ(PanelAt(83, 450), miss);
    EXPECT_EQ(PanelAt(67, 470), miss);
    PortActiveSaveData = saved;
}

namespace {
// Retail's own pickup, refusal and return run around the mouse. Its synthesis
// question needs the game's message data, so the tests open it, and answer it,
// with the state CheckSpectolFusion and its Yes, No and Circle leave.
class ItemMouseReturn : public ItemMouse {
protected:
    static constexpr int       kSphere = 1, kWeapon = 8; // Bag cells.
    std::unique_ptr<CSaveData> save = std::make_unique<CSaveData>();
    CSaveData                 *saved_save = PortActiveSaveData;
    CUserDataManager          *saved_user = MenuUserDataManPtr;
    int                        saved_language = LanguageCode;
    CMenuMoveItem              move;
    CMenuPosDataForm           move_forms[2]{};
    MENUFORMPARTS_TYPE         move_parts[2][2]{}, held_parts[3]{};

    void SetUp() override {
        ItemMouse::SetUp();
        PortActiveSaveData = save.get();
        MenuUserDataManPtr = &save->user_data;
        LanguageCode = 1; // PAL English, where Cross confirms.
        for (int i = 0; i < 2; ++i) {
            move_parts[i][0].name = const_cast<char *>("item");
            move_parts[i][1].name = const_cast<char *>("num");
            move_forms[i].parts = move_parts[i];
            move_forms[i].parts_num = 2;
            move.form[i] = &move_forms[i];
        }
        MenuMoveItemPtr = &move;
        keys.key_enable = true;
        keys.have_icon = &held_parts[0];
        keys.have_shadow = &held_parts[1];
        keys.have_num = &held_parts[2];
        keys.InitHaveData();
        auto &sphere = items[kSphere];
        sphere.item_no = ITEM_ID_SPECTOL;
        sphere.used_type = USED_ITEM_TYPE_ATTACH;
        sphere.item_type = ITEM_DATA_SPECTOL;
        items[kWeapon].item_no = 2;
        items[kWeapon].used_type = USED_ITEM_TYPE_WEAPON;
    }

    void TearDown() override {
        PortActiveSaveData = saved_save;
        MenuUserDataManPtr = saved_user;
        LanguageCode = saved_language;
        ItemMouse::TearDown();
    }

    // Retail's item key step for this frame's buttons. A return's move lands at once.
    void Retail() {
        if (move.move_on) {
            for (auto &form : move_forms) {
                form.x = form.next_x;
                form.y = form.next_y;
            }
            move.CheckMove();
            return;
        }
        keys.CheckSelectKey();
        if (const int push = keys.CheckPushButton()) {
            class_menu_item_info.PushKey(keys.select_key, push);
        }
    }

    void Frame(float dx = 0, float dy = 0, unsigned buttons = 0) {
        Tick(dx, dy, buttons);
        Retail();
    }

    // Drags the sphere from its cell, retail picking it up, and releases it at (x,y).
    void DragSphereTo(float x, float y) {
        Frame(40, 0);   // Bag cell 0 (262,75) -> the sphere (302,75).
        Frame(0, 0, 1); // Press.
        Frame(0, 10, 1);
        ASSERT_EQ(keys.have_item.item_no, ITEM_ID_SPECTOL);
        ASSERT_EQ(items[kSphere].item_no, 0);
        Frame(x - 302, y - 85, 1);
        Tick(); // Release: the drop's Cross, not yet handled.
        ASSERT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    }

    // The drop on the bag weapon (342,125) opens retail's synthesis question.
    void AskToSynthesise() {
        DragSphereTo(342, 125);
        class_menu_item_info.mode = MENU_ASK_MODE_FUSION;
        class_menu_item_info.ask_para.mes_no = -1; // Its rows aren't modelled: a click answers.
        for (int i = 0; i < 4; ++i) {
            Frame(1, 0);
        }
        EXPECT_EQ(keys.have_item.item_no, ITEM_ID_SPECTOL); // No return while the question is open.
        EXPECT_EQ(items[kSphere].item_no, 0);
        EXPECT_FALSE(move.move_on);
    }

    // Spheres wherever they are: in the bag, on the cursor or moving.
    int Spheres() {
        int count = keys.have_item.item_no == ITEM_ID_SPECTOL;
        for (const auto &item : items) {
            count += item.item_no == ITEM_ID_SPECTOL;
        }
        for (const auto &info : move.info) {
            count += info.active && info.item.item_no == ITEM_ID_SPECTOL;
        }
        return count;
    }

    void ExpectSphereBackInItsCell() {
        for (int i = 0; i < 3; ++i) {
            Frame(1, 0); // The return, then its move landing.
        }
        EXPECT_EQ(items[kSphere].item_no, ITEM_ID_SPECTOL);
        EXPECT_EQ(keys.have_item.item_no, 0);
        EXPECT_EQ(items[kWeapon].item_no, 2);
        EXPECT_FALSE(move.move_on);
        EXPECT_EQ(Spheres(), 1);
    }

    void ExpectSphereStillCarried() {
        for (int i = 0; i < 3; ++i) {
            Frame(1, 0);
        }
        EXPECT_EQ(keys.have_item.item_no, ITEM_ID_SPECTOL);
        EXPECT_EQ(items[kSphere].item_no, 0);
        EXPECT_EQ(items[kWeapon].item_no, 2);
        EXPECT_FALSE(move.move_on);
        EXPECT_EQ(Spheres(), 1);
    }
};
} // namespace

TEST_F(ItemMouseReturn, ConsumedHeldItemIsNotReturned) {
    AskToSynthesise();
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    keys.InitHaveData(); // Retail's Yes attaches the sphere to the weapon.
    class_menu_item_info.mode = MENU_ASK_MODE_NONE;
    for (int i = 0; i < 3; ++i) {
        Frame(1, 0);
    }
    EXPECT_EQ(items[kSphere].item_no, 0);
    EXPECT_EQ(keys.have_item.item_no, 0);
    EXPECT_EQ(items[kWeapon].item_no, 2);
    EXPECT_FALSE(move.move_on);
    EXPECT_EQ(Spheres(), 0);
}

TEST_F(ItemMouseReturn, NoReturnsTheSphereToItsCell) {
    AskToSynthesise();
    Tick(0, 0, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CROSS);
    class_menu_item_info.mode = MENU_ASK_MODE_NONE; // Retail's No keeps the sphere carried.
    ExpectSphereBackInItsCell();
}

TEST_F(ItemMouseReturn, CircleReturnsTheSphereToItsCell) {
    AskToSynthesise();
    Tick(0, 0, 2);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CIRCLE);
    class_menu_item_info.mode = MENU_ASK_MODE_NONE;
    ExpectSphereBackInItsCell();
}

TEST_F(ItemMouseReturn, RetailRefusalReturnsTheItemToItsCell) {
    DragSphereTo(140, 230); // Max, who cannot use a sphere.
    Retail();
    EXPECT_EQ(class_menu_item_info.key_arg_no, ITEM_MENU_PANEL_CHARA);
    EXPECT_EQ(class_menu_item_info.mode, MENU_ASK_MODE_NONE);
    EXPECT_EQ(keys.have_item.item_no, ITEM_ID_SPECTOL); // Refused, still carried.
    ExpectSphereBackInItsCell();
}

TEST_F(ItemMouseReturn, PadDuringTheQuestionLeavesTheSphereCarried) {
    AskToSynthesise();
    GamePad__2.pad[0].button = PAD_CIRCLE;
    Tick(); // The pad answers instead.
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CIRCLE);
    class_menu_item_info.mode = MENU_ASK_MODE_NONE;
    GamePad__2.previous_pad[0].button = PAD_CIRCLE;
    Tick();
    GamePad__2.pad[0].button = GamePad__2.previous_pad[0].button = 0;
    ExpectSphereStillCarried();
}

TEST_F(ItemMouseReturn, PadDuringTheDragLeavesTheSphereCarried) {
    Frame(40, 0);
    Frame(0, 0, 1);
    Frame(0, 10, 1);
    ASSERT_EQ(keys.have_item.item_no, ITEM_ID_SPECTOL);
    GamePad__2.pad[0].button = PAD_RIGHT;
    Tick(40, 40, 1);
    GamePad__2.pad[0].button = 0;
    Frame(0, 0, 1);
    Tick(); // The mouse release no longer drops anything.
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    Retail();
    ExpectSphereStillCarried();
}
