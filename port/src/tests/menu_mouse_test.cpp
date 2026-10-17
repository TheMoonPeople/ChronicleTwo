#include <SDL3/SDL.h>
#include <gtest/gtest.h>

#include <limits>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "menusys.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "nd_meswin.hpp"
#include "options/screen.hpp"
#include "platform/clock.hpp"
#include "platform/input.hpp"
#include "platform/mouse.hpp"
#include "platform/settings.hpp"
#include "save_slots.hpp"

extern CSaveMenuClass *MouseSave asm("MenuMouse_Save");

namespace {
constexpr MenuMouseRect rows[] = {
    {20, 40,  100, 30},
    {20, 80,  100, 30},
    {20, 120, 100, 30}
};

TEST(MenuMouse, HitBoxesExcludeGapsAndTheirFarEdges) {
    EXPECT_EQ(MenuMouseHit(rows, 20, 40), 0);
    EXPECT_EQ(MenuMouseHit(rows, 119, 109), 1);
    EXPECT_EQ(MenuMouseHit(rows, 120, 90), -1);
    EXPECT_EQ(MenuMouseHit(rows, 50, 75), -1);
    EXPECT_EQ(MenuMouseHit(rows, -100, 90), -1);
    EXPECT_EQ(MenuMouseHit(rows, std::numeric_limits<float>::quiet_NaN(), 90), -1);
}

TEST(MenuMouse, StationaryPointerDoesNotUndoControllerSelection) {
    MenuMouseSample mouse{.x = 40, .y = 90, .pointing = true};
    EXPECT_EQ(MenuMouseChoose(mouse, rows, 2), 2);
    mouse.moved = true;
    EXPECT_EQ(MenuMouseChoose(mouse, rows, 2), 1);
    mouse.pointing = false;
    EXPECT_EQ(MenuMouseChoose(mouse, rows, 2), 2);
}

TEST(MenuMouse, ClickSelectsTheHoveredRowAndWheelClamps) {
    MenuMouseSample mouse{.x = 40, .y = 90, .pointing = true, .clicked = 1};
    EXPECT_EQ(MenuMouseChoose(mouse, rows, 0), 1);
    mouse.clicked = 0;
    mouse.wheel = -1;
    EXPECT_EQ(MenuMouseChoose(mouse, rows, 1), 2);
    EXPECT_EQ(MenuMouseChoose(mouse, rows, 2), 2);
    mouse.wheel = 1;
    EXPECT_EQ(MenuMouseChoose(mouse, rows, 1), 0);
    EXPECT_EQ(MenuMouseChoose(mouse, rows, 0), 0);
    mouse.wheel = std::numeric_limits<float>::infinity();
    EXPECT_EQ(MenuMouseChoose(mouse, rows, 1), 1);
}

TEST(MenuMouse, ClickWinsOverAWheelNotchInTheSameSample) {
    MenuMouseSample mouse{.x = 40, .y = 90, .wheel = -1, .pointing = true, .clicked = 1};
    EXPECT_EQ(MenuMouseChoose(mouse, rows, 0), 1);
    mouse.x = -100; // A click on the background still lets the notch move the selection.
    EXPECT_EQ(MenuMouseChoose(mouse, rows, 0), 1);
}

TEST(MenuMouse, WindowPixelsFollowUiScalingAndHighDpiMapping) {
    EXPECT_FLOAT_EQ(MenuMouseUnits(3, 1536, 1536), 1.0f / 3);
    EXPECT_FLOAT_EQ(MenuMouseUnits(6, 3072, 1536), 1.0f / 3);
    EXPECT_FLOAT_EQ(MenuMouseUnits(0, 0, 0), 1);
}

TEST(MenuMouse, HoverUsesTheRetailMoveResultAndScrollUpdate) {
    int cursor = 0, scroll = 0;
    MenuMouseMove(&cursor, 8);
    EXPECT_EQ(cursor, 0);
    EXPECT_EQ(MenuKeySelectCheck(0, &cursor, &scroll, 0, 13, 3, MENU_CURSOR_LIMIT_CLAMP), MENU_CURSOR_MOVED);
    EXPECT_EQ(cursor, 8);
    EXPECT_EQ(scroll, 6);
    EXPECT_EQ(MenuKeySelectCheck(0, &cursor, &scroll, 0, 13, 3, MENU_CURSOR_LIMIT_CLAMP), MENU_CURSOR_UNCHANGED);
}

TEST(MenuMouse, PadCursorLimitsRemainRetailWithoutMouseMotion) {
    int cursor = 0;
    EXPECT_EQ(MenuKeySelectCheck(-1, &cursor, nullptr, 0, 4, 4, MENU_CURSOR_LIMIT_WRAP), MENU_CURSOR_MOVED);
    EXPECT_EQ(cursor, 3);
    EXPECT_EQ(MenuKeySelectCheck(1, &cursor, nullptr, 0, 4, 4, MENU_CURSOR_LIMIT_REJECT), MENU_CURSOR_BLOCKED);
    EXPECT_EQ(cursor, 3);
    EXPECT_EQ(MenuKeySelectCheck(1, &cursor, nullptr, 0, 4, 4, MENU_CURSOR_LIMIT_EXIT), MENU_CURSOR_EXIT);
    EXPECT_EQ(cursor, 3);
}

TEST(MenuMouse, PopupWheelStepsAnEntireGridRow) {
    MenuMouseRect   cells[15]{};
    MenuMouseSample mouse{.wheel = -1, .pointing = true};
    EXPECT_EQ(MenuMouseChoose(mouse, cells, 2, 5), 7);
    EXPECT_EQ(MenuMouseChoose(mouse, cells, 12, 5), 14);
}

class MenuMouseInput : public testing::Test {
protected:
    int width = mgScreenWidth, height = mgScreenHeight;

    void SetUp() override {
        mgScreenWidth = 512;
        mgScreenHeight = 480;
        InputResetBindings();
        InputSetScriptedDevices({});
        MenuMouseEnable(false);
        MenuMouseTake();
        GamePad__2.key_lock = 0;
        GamePad__2.pad[0].button = GamePad__2.previous_pad[0].button = 0;
        ClockSetUnbounded(true);
    }

    void TearDown() override {
        InputSetScriptedDevices({});
        MenuMouseEnable(false);
        MenuMouseTake();
        InputSetMenuMouse(false);
        mgScreenWidth = width;
        mgScreenHeight = height;
        InputSetOverride(0, nullptr);
        InputResetBindings();
    }

    static void Tick() { mgEndFrame(nullptr); }
};

TEST_F(MenuMouseInput, ClicksUseRetailDownWithoutChangingStoredPadButtons) {
    MenuMouseEnable(true);
    InputSetScriptedDevices({.mouse_buttons = 1});
    EXPECT_TRUE(GamePad__2.Down(PAD_CROSS));
    EXPECT_FALSE(GamePad__2.Down(PAD_CIRCLE));
    EXPECT_EQ(GamePad__2.pad[0].button, 0);
    GamePad__2.key_lock = 1;
    EXPECT_FALSE(GamePad__2.Down(PAD_CROSS));
    GamePad__2.key_lock = 0;
}

TEST_F(MenuMouseInput, HeldClickCannotSelectWhenMenuOpens) {
    InputSetScriptedDevices({.mouse_buttons = 1});
    MenuMouseEnable(true);
    EXPECT_EQ(MenuMouseButtons(), 0);
}

TEST_F(MenuMouseInput, OutsideClickIsRejectedButRightClickCancels) {
    MenuMouseEnable(true);
    InputSetScriptedDevices({.mouse_buttons = 3});
    MenuMouseRows(rows, 0);
    EXPECT_FALSE(GamePad__2.Down(PAD_CROSS));
    EXPECT_TRUE(GamePad__2.Down(PAD_CIRCLE));
}

TEST_F(MenuMouseInput, MessageClickMovesTheRetailDirectionBeforeItConfirms) {
    const MenuMouseRect choices[] = {
        {20,  200, 70,  50},
        {200, 200, 100, 60}
    };
    MenuMouseEnable(true);
    MenuMouseNoteChoices(this, 42, choices, 0, true);
    InputSetScriptedDevices({.mouse_buttons = 1});
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_RIGHT);
    InputSetScriptedDevices({});
    for (int i = 0; i < 7; ++i) {
        Tick();
        MenuMouseNoteChoices(this, 42, choices, 1, true);
        if (i < 6) {
            EXPECT_EQ(MenuMouseButtons(), 0);
        } else {
            EXPECT_EQ(MenuMouseButtons(), PAD_CROSS);
        }
    }
    Tick();
    MenuMouseNoteChoices(this, 42, choices, 1, true);
    EXPECT_EQ(MenuMouseButtons(), 0);
}

TEST_F(MenuMouseInput, NewMessageDiscardsThePreviousPendingClick) {
    const MenuMouseRect choices[] = {
        {20,  200, 70,  50},
        {200, 200, 100, 60}
    };
    MenuMouseEnable(true);
    MenuMouseNoteChoices(this, 42, choices, 0, true);
    InputSetScriptedDevices({.mouse_buttons = 1});
    EXPECT_EQ(MenuMouseButtons(), PAD_RIGHT);
    InputSetScriptedDevices({});
    for (int i = 0; i < 9; ++i) {
        Tick();
        MenuMouseNoteChoices(this, 43, choices, 1, true);
        EXPECT_EQ(MenuMouseButtons(), 0);
    }
}

TEST_F(MenuMouseInput, MenuCloseKeepsHeldClickAwayFromGameplayUntilRelease) {
    MenuMouseEnable(true);
    InputSetScriptedDevices({.mouse_buttons = 1});
    EXPECT_EQ(MenuMouseButtons(), PAD_CROSS);
    MenuMouseEnable(false);
    EXPECT_EQ(MenuMouseButtons(), 0);
    EXPECT_EQ(InputApplyKeyboardMouse({}, {.mouse_buttons = 1}).buttons, 0);
    InputSetScriptedDevices({});
    Tick();
    MenuMouseTake();
    EXPECT_EQ(InputApplyKeyboardMouse({}, {.mouse_buttons = 1}).buttons, kInputCross);
}

TEST_F(MenuMouseInput, ControllerHandoffDiscardsThePreviousMouseChoiceTarget) {
    const MenuMouseRect choices[] = {
        {200, 200, 100, 60},
        {20,  200, 70,  50}
    };
    MenuMouseEnable(true);
    MenuMouseNoteChoices(this, 42, choices, 1, true);
    InputSetScriptedDevices({.mouse_buttons = 1});
    EXPECT_EQ(MenuMouseButtons(), PAD_LEFT);
    Tick();
    InputSetScriptedDevices({});
    InputPadState controller{};
    controller.buttons = kInputDown;
    InputSetOverride(0, &controller);
    MenuMouseNoteChoices(this, 42, choices, 1, true);
    EXPECT_EQ(MenuMouseButtons(), 0);
    Tick();
    InputSetOverride(0, nullptr);
    InputSetScriptedDevices({.mouse_dx = 1000});
    MenuMouseNoteChoices(this, 42, choices, 1, true);
    EXPECT_EQ(MenuMouseButtons(), 0);
}

TEST_F(MenuMouseInput, ListClickWaitsForTheRetailCursorThenConfirmsOnce) {
    const MenuMouseRect list[] = {
        {200, 200, 100, 60},
        {300, 200, 100, 60}
    };
    MenuMouseEnable(true);
    InputSetScriptedDevices({.mouse_buttons = 1});
    EXPECT_EQ(MenuMouseRows(list, 1), 0);
    MenuMouseDelayConfirm(this, 1, 0, 4);
    EXPECT_EQ(MenuMouseButtons(), 0);
    InputSetScriptedDevices({});
    for (int i = 1; i <= 5; ++i) {
        Tick();
        MenuMouseRows(list, 0);
        MenuMouseDelayConfirm(this, 0, 0, 4);
        EXPECT_EQ(MenuMouseButtons(), i == 4 ? PAD_CROSS : 0);
    }
}

TEST_F(MenuMouseInput, ListClickCannotCarryIntoAnotherPageOrSurviveCancel) {
    const MenuMouseRect list[] = {
        {200, 200, 100, 60},
        {300, 200, 100, 60}
    };
    MenuMouseEnable(true);
    InputSetScriptedDevices({.mouse_buttons = 1});
    MenuMouseRows(list, 1);
    MenuMouseDelayConfirm(this, 1, 0, 4);
    InputSetScriptedDevices({.mouse_buttons = 2});
    Tick();
    MenuMouseRows(list, 0);
    MenuMouseDelayConfirm(this, 0, 0, 4);
    EXPECT_EQ(MenuMouseButtons(), PAD_CIRCLE);
    InputSetScriptedDevices({});
    for (int i = 0; i < 5; ++i) {
        Tick();
    }
    MenuMouseRows(list, 0);
    MenuMouseDelayConfirm(this, 0, 0, 4);
    EXPECT_EQ(MenuMouseButtons(), 0);
}

TEST_F(MenuMouseInput, DrawnDialogueLinesUseTheirActualPositionsAndFirstSelectableLine) {
    ClsMes message;
    short  text[] = {0};
    message.buff = text;
    message.fade = 1;
    message.alpha = 128;
    message.font_h = 30;
    message.text_h = 90;
    message.text_w = 150;
    message.select_top = message.select = 1;
    message.line_pos_on[0] = message.line_pos_on[1] = message.line_pos_on[2] = 1;
    message.line_pos[0][0] = message.line_pos[1][0] = message.line_pos[2][0] = 200;
    message.line_pos[0][1] = 100;
    message.line_pos[1][1] = 140;
    message.line_pos[2][1] = 220;
    message.StepSelectCursor(1);
    InputSetScriptedDevices({.mouse_buttons = 1});
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_DOWN);
    // Drawing a message never writes the script's selected line itself.
    EXPECT_EQ(message.select, 1);
}

TEST_F(MenuMouseInput, DrawnYesNoChoicesUseTheirOwnPositions) {
    ClsMes message;
    short  text[] = {0};
    message.buff = text;
    message.fade = 1;
    message.alpha = 128;
    message.font_h = 30;
    message.select = 0;
    message.window_mode = MES_WIN_YESNO;
    message.choice_pos[0][0] = 190;
    message.choice_pos[0][1] = 220;
    message.choice_pos[1][0] = 220;
    message.choice_pos[1][1] = 220;
    message.StepSelectCursor(1);
    InputSetScriptedDevices({.mouse_buttons = 1});
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_RIGHT);
    EXPECT_EQ(message.select, 0);
}

TEST_F(MenuMouseInput, LoadListUsesScrolledFormGeometryAndRetailCursorTransition) {
    const auto catalog = SaveSlots;
    SaveSlots.saves.resize(20);
    CSaveMenuClass   save;
    CMenuPosDataForm form;
    form.x = 30;
    form.y = 190 - 80 * 10;
    save.list_form = &form;
    save.mode = SAVE_MENU_MODE_LOAD;
    save.CBaseMenuClass::mode = MENU_ASK_MODE_NONE;
    save.page = SAVE_MENU_PAGE_FILE_LIST;
    save.phase = SAVE_LIST_PHASE_SELECT;
    save.select = 11;
    save.top = 10;
    auto *previous = MouseSave;
    MouseSave = &save;
    CMenuKeyFunc keys;
    keys.now_mode = MENU_MODE_TITLE_SAVE;
    keys.key_enable = true;
    keys.select_key = 0;
    MenuMouseEnable(true);
    InputSetScriptedDevices({.mouse_buttons = 1});
    MenuMouseSave(save);
    keys.CheckSelectKey();
    EXPECT_EQ(save.select, 11);
    EXPECT_EQ(MenuKeySelectCheck(0, &save.select, &save.top, 0, 13, 3, MENU_CURSOR_LIMIT_CLAMP), MENU_CURSOR_MOVED);
    EXPECT_EQ(save.select, 10);
    EXPECT_EQ(save.top, 10);
    EXPECT_FALSE(GamePad__2.Down(PAD_CROSS));
    MouseSave = previous;
    SaveSlots = catalog;
}
} // namespace

TEST_F(MenuMouseInput, RepeatedAdaptersShareMotionWheelAndButtonEdgesWithinATick) {
    MenuMouseEnable(true);
    InputSetScriptedDevices({.mouse_buttons = 1, .mouse_dx = 40, .mouse_dy = 10, .mouse_wheel = -2});
    const auto first = MenuMouseTake();
    const auto second = MenuMouseTake();
    EXPECT_FLOAT_EQ(first.x, 296);
    EXPECT_FLOAT_EQ(first.y, 250);
    EXPECT_EQ(first.clicked, 1u);
    EXPECT_FLOAT_EQ(first.wheel, -2);
    EXPECT_FLOAT_EQ(second.x, first.x);
    EXPECT_FLOAT_EQ(second.y, first.y);
    EXPECT_FLOAT_EQ(second.wheel, first.wheel);
    MenuMouseSetButtons(PAD_SQUARE);
    EXPECT_EQ(MenuMouseButtons(), PAD_SQUARE);
    InputSetScriptedDevices({});
    Tick();
    EXPECT_EQ(MenuMouseTake().released, 1u);
    EXPECT_EQ(MenuMouseButtons(), 0);
}

TEST_F(MenuMouseInput, FlatSaveWheelReachesOnlyTheSingleNewRowBeyondRetailCapacity) {
    const auto catalog = SaveSlots;
    SaveSlots.saves.resize(20);
    CSaveMenuClass   save;
    CMenuPosDataForm form;
    form.x = 30;
    form.y = 164 - 80 * 18;
    save.list_form = &form;
    save.mode = SAVE_MENU_MODE_SAVE;
    save.CBaseMenuClass::mode = MENU_ASK_MODE_NONE;
    save.page = SAVE_MENU_PAGE_FILE_LIST;
    save.phase = SAVE_LIST_PHASE_SELECT;
    save.select = 19;
    save.top = 18;
    MenuMouseEnable(true);
    InputSetScriptedDevices({.mouse_wheel = -1});
    MenuMouseSave(save);
    EXPECT_EQ(MenuKeySelectCheck(0, &save.select, &save.top, 0, 21, 3, MENU_CURSOR_LIMIT_CLAMP), MENU_CURSOR_MOVED);
    EXPECT_EQ(save.select, 20);
    InputSetScriptedDevices({.mouse_wheel = -1});
    Tick();
    MenuMouseSave(save);
    MenuKeySelectCheck(0, &save.select, &save.top, 0, 21, 3, MENU_CURSOR_LIMIT_CLAMP);
    EXPECT_EQ(save.select, 20);
    EXPECT_TRUE(SaveSlotIsNew(SaveSlots, save.select, true));
    EXPECT_FALSE(SaveSlotIsNew(SaveSlots, save.select, false));
    SaveSlots = catalog;
}

TEST_F(MenuMouseInput, MenuWheelCannotZoomOrLeakBackIntoGameplay) {
    HostSettings config;
    config.mouse_zoom = true;
    InputApplyConfig(config);
    InputPadState pad{.connected = true};
    InputSetOverride(0, &pad);
    MenuMouseEnable(true);
    InputSetScriptedDevices({.mouse_wheel = -4});
    InputLatchPad(0);
    EXPECT_FLOAT_EQ(InputGetMouseLook().zoom, 0);
    EXPECT_FLOAT_EQ(MenuMouseTake().wheel, -4);
    MenuMouseEnable(false);
    InputSetScriptedDevices({});
    Tick();
    MenuMouseTake();
    InputLatchPad(0);
    EXPECT_FLOAT_EQ(InputGetMouseLook().zoom, 0);
    InputSetScriptedDevices({.mouse_wheel = -1});
    InputLatchPad(0);
    EXPECT_FLOAT_EQ(InputGetMouseLook().zoom, -1);
    InputApplyConfig(HostSettings{});
}

TEST_F(MenuMouseInput, OptionsRightClickCancelsRetailPcAndBindingPages) {
    const int language = LanguageCode;
    LanguageCode = LANG_ENGLISH;
    MenuMouseEnable(true);
    options::g_screen = {};
    InputSetScriptedDevices({.mouse_buttons = 2});
    EXPECT_FALSE(options::Run());
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_CIRCLE);
    EXPECT_FALSE(options::g_screen.open);
    for (int page = 0; page < 4; ++page) {
        InputSetScriptedDevices({});
        Tick();
        options::Run();
        options::g_screen.open = true;
        options::g_screen.page = page;
        InputSetScriptedDevices({.mouse_buttons = 2});
        Tick();
        EXPECT_TRUE(options::Run());
        EXPECT_FALSE(options::g_screen.open);
        EXPECT_EQ(options::g_screen.page, page);
        EXPECT_EQ(MenuMouseButtons(), 0);
    }
    InputSetScriptedDevices({});
    Tick();
    options::Run();
    options::g_screen.open = true;
    options::g_screen.binding = 0;
    InputBeginBindCapture();
    InputSetScriptedDevices({.mouse_buttons = 2});
    Tick();
    EXPECT_TRUE(options::Run());
    EXPECT_EQ(options::g_screen.binding, -1);
    EXPECT_TRUE(options::g_screen.open);
    EXPECT_EQ(MenuMouseButtons(), 0);
    options::g_screen = {};
    InputSetScriptedDevices({});
    Tick();
    options::Run();
    LanguageCode = language;
}

TEST_F(MenuMouseInput, RetailOptionsBackgroundClickCannotConfirmWhilePcSettingsIsClosed) {
    const int language = LanguageCode;
    LanguageCode = LANG_ENGLISH;
    MenuMouseEnable(true);
    options::g_screen = {};
    InputSetScriptedDevices({.mouse_buttons = 1});
    EXPECT_FALSE(options::Run());
    EXPECT_EQ(GamePad__2.GetPadDown(), 0);
    EXPECT_FALSE(options::g_screen.open);
    LanguageCode = language;
}

TEST_F(MenuMouseInput, DisplayMotionDoesNotAdvanceHoverOrConsumeTheNextTick) {
    const auto settings = InputGetMouseSettings();
    InputSetMouseSettings({.capture = false});
    MenuMouseEnable(true);
    const auto before = MenuMouseTake();
    SDL_Event  event{};
    event.type = SDL_EVENT_MOUSE_MOTION;
    event.motion.xrel = 30;
    event.motion.yrel = 12;
    InputHandleEvent(event);
    const auto display = MenuMouseDisplaySample();
    EXPECT_FLOAT_EQ(display.x, before.x + 30);
    EXPECT_FLOAT_EQ(display.y, before.y + 12);
    EXPECT_TRUE(display.pointing);
    EXPECT_FLOAT_EQ(MenuMouseTake().x, before.x);
    EXPECT_EQ(MenuMouseButtons(), 0);
    EXPECT_FLOAT_EQ(MenuMouseDisplaySample().x, display.x);
    InputLatchPad(0); // Motion already latched for logic must still be visible to presentation.
    EXPECT_FLOAT_EQ(MenuMouseDisplaySample().x, display.x);
    Tick();
    EXPECT_FLOAT_EQ(MenuMouseTake().x, display.x);
    EXPECT_FLOAT_EQ(MenuMouseTake().y, display.y);
    EXPECT_FLOAT_EQ(MenuMouseDisplaySample().x, display.x); // no double integration
    InputSetMouseSettings(settings);
}

TEST_F(MenuMouseInput, DisplayHandsOwnershipFromMouseToPadAndBackOnNewMotion) {
    const auto settings = InputGetMouseSettings();
    InputSetMouseSettings({.capture = false});
    MenuMouseEnable(true);
    MenuMouseTake();
    SDL_Event event{};
    event.type = SDL_EVENT_MOUSE_MOTION;
    event.motion.xrel = 10;
    InputHandleEvent(event);
    EXPECT_TRUE(MenuMouseDisplaySample().pointing);
    Tick();
    MenuMouseTake();
    InputPadState pad{.connected = true, .buttons = PAD_DOWN};
    InputSetOverride(0, &pad);
    EXPECT_FALSE(MenuMouseDisplaySample().pointing);
    Tick();
    MenuMouseTake();
    pad.buttons = 0;
    InputSetOverride(0, &pad);
    EXPECT_FALSE(MenuMouseDisplaySample().pointing);
    InputHandleEvent(event);
    EXPECT_TRUE(MenuMouseDisplaySample().pointing);
    InputSetOverride(0, nullptr);
    InputSetMouseSettings(settings);
}

TEST(MenuMouse, NativeCursorVisibilityFollowsFocusedClientOwnership) {
    EXPECT_TRUE(MousePointerCursorHidden(true, true, true));
    EXPECT_FALSE(MousePointerCursorHidden(true, false, true));
    EXPECT_FALSE(MousePointerCursorHidden(true, true, false));
    EXPECT_FALSE(MousePointerCursorHidden(false, true, true));
}

TEST_F(MenuMouseInput, FractionalWheelAccumulatesOncePerLogicalSample) {
    MenuMouseEnable(true);
    for (int i = 0; i < 4; ++i) {
        InputSetScriptedDevices({.mouse_wheel = -0.25f});
        Tick();
        EXPECT_EQ(MenuMouseTake().wheel, i == 3 ? -1 : 0);
        EXPECT_EQ(MenuMouseTake().wheel, i == 3 ? -1 : 0);
    }
    InputSetScriptedDevices({.mouse_wheel = 0.5f});
    Tick();
    EXPECT_EQ(MenuMouseTake().wheel, 0);
    Tick();
    InputSetScriptedDevices({.mouse_wheel = 0.5f});
    EXPECT_EQ(MenuMouseTake().wheel, 1);
}

TEST_F(MenuMouseInput, RetailOptionsHitUsesVisibleButtonAndSelectsItsChoice) {
    MenuMouseEnable(true);
    CMenuOption        menu;
    CMenuPosDataForm   form{};
    MENUFORMPARTS_TYPE button{};
    form.draw_flag = button.draw_flag = true;
    form.x = 100;
    form.y = 40;
    button.x = 140;
    button.y = 190;
    button.w = 40;
    button.h = 25;
    menu.top = 0;
    menu.select = 0;
    menu.choice = 0;
    menu.choice_num[2] = 2;
    menu.button[2][1] = &button;
    InputSetScriptedDevices({.mouse_buttons = 1});
    EXPECT_TRUE(MenuMouseOption(menu, &form)); // Initial pointer 256,240.
    EXPECT_EQ(menu.select, 2);
    EXPECT_EQ(menu.choice, 1);
    InputSetScriptedDevices({.mouse_dx = 200});
    Tick();
    EXPECT_FALSE(MenuMouseOption(menu, &form));
    EXPECT_EQ(menu.choice, 1);
}

TEST_F(MenuMouseInput, MultipleHandsKeepDistinctReplacementKeys) {
    MenuMouseEnable(true);
    InputSetScriptedDevices({.mouse_dx = 1});
    MenuMouseTake();
    gfx::TextureBinding texture{.texture = 123};
    const auto          first = MenuMouseNoteHand(texture, {0, 0, 40, 24});
    const auto          second = MenuMouseNoteHand(texture, {0, 0, 40, 24});
    EXPECT_NE(first, second);
    EXPECT_EQ(MenuMouseReplacedHandKey(), second);
}
