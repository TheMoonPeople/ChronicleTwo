#include <SDL3/SDL.h>
#include <gtest/gtest.h>

#include <limits>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menuchr.hpp"
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
    {.x = 20, .y = 40,  .w = 100, .h = 30},
    {.x = 20, .y = 80,  .w = 100, .h = 30},
    {.x = 20, .y = 120, .w = 100, .h = 30}
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

TEST(MenuMouse, CursorSoundPlaysAtMostOnceATick) {
    const u32 saved_sound = SystemSND_ID;
    SystemSND_ID = static_cast<u32>(-1);
    mgEndFrame(nullptr);
    const int sounds = MenuMouseCursorSounds();
    MenuMouseCursorSound();
    MenuMouseCursorSound(); // A second adapter in the same tick.
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 1);
    mgEndFrame(nullptr);
    MenuMouseCursorSound();
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 2);
    SystemSND_ID = saved_sound;
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

TEST(MenuMouse, PointerGainKeepsFineMotionLinearAndDoublesFastMotion) {
    EXPECT_FLOAT_EQ(MenuMouseGain(30, 0, 1.5f, false), 1.5f);
    EXPECT_FLOAT_EQ(MenuMouseGain(3, 0, 1.5f, true), 1.5f);
    EXPECT_FLOAT_EQ(MenuMouseGain(0, 4, 1.5f, true), 1.5f);
    EXPECT_FLOAT_EQ(MenuMouseGain(16, 0, 1.5f, true), 2.25f);
    EXPECT_FLOAT_EQ(MenuMouseGain(-28, 0, 1.5f, true), 3.0f);
    EXPECT_FLOAT_EQ(MenuMouseGain(300, 300, 1.5f, true), 3.0f);
    // Bad input keeps a finite gain.
    EXPECT_FLOAT_EQ(MenuMouseGain(std::numeric_limits<float>::quiet_NaN(), 0, 1, true), 1);
    EXPECT_FLOAT_EQ(MenuMouseGain(0, 0, 0, false), 1);
}

TEST(MenuMouse, HoverUsesTheRetailMoveResultAndScrollUpdate) {
    int cursor = 0;
    int scroll = 0;
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
        {.x = 20,  .y = 200, .w = 70,  .h = 50},
        {.x = 200, .y = 200, .w = 100, .h = 60}
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
        {.x = 20,  .y = 200, .w = 70,  .h = 50},
        {.x = 200, .y = 200, .w = 100, .h = 60}
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
        {.x = 200, .y = 200, .w = 100, .h = 60},
        {.x = 20,  .y = 200, .w = 70,  .h = 50}
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
        {.x = 200, .y = 200, .w = 100, .h = 60},
        {.x = 300, .y = 200, .w = 100, .h = 60}
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
        {.x = 200, .y = 200, .w = 100, .h = 60},
        {.x = 300, .y = 200, .w = 100, .h = 60}
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
    CMenuPosDataForm form{};
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
    CMenuPosDataForm form{};
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
    const auto          first = MenuMouseNoteHand(texture, {.x = 0, .y = 0, .w = 40, .h = 24});
    const auto          second = MenuMouseNoteHand(texture, {.x = 0, .y = 0, .w = 40, .h = 24});
    EXPECT_NE(first, second);
    EXPECT_EQ(MenuMouseReplacedHandKey(), second);
}

TEST(MenuMouse, WheelScrollsWholeRowsAndKeepsTheCursorUnderThePointerOrInView) {
    // Sixteen rows, nine shown: down three notches from the top.
    EXPECT_EQ(MenuMouseScroll(-3, {0, 2}, 16, 9, 4).top, 3);
    EXPECT_EQ(MenuMouseScroll(-3, {0, 2}, 16, 9, 4).selected, 7);
    EXPECT_EQ(MenuMouseScroll(-3, {0, 2}, 16, 9, -1).selected, 3);
    // The list stops at its last page and at its first row.
    EXPECT_EQ(MenuMouseScroll(-20, {5, 9}, 16, 9, -1).top, 7);
    EXPECT_EQ(MenuMouseScroll(-20, {5, 9}, 16, 9, -1).selected, 9);
    EXPECT_EQ(MenuMouseScroll(2, {1, 9}, 16, 9, -1).top, 0);
    EXPECT_EQ(MenuMouseScroll(2, {1, 9}, 16, 9, -1).selected, 8);
    // A list that fits, no wheel, or a bad wheel value does not move.
    EXPECT_EQ(MenuMouseScroll(-1, {0, 1}, 4, 9, -1).top, 0);
    EXPECT_EQ(MenuMouseScroll(0, {3, 5}, 16, 9, 0).selected, 5);
    EXPECT_EQ(MenuMouseScroll(std::numeric_limits<float>::quiet_NaN(), {3, 5}, 16, 9, 0).top, 3);
}

namespace {
void Place(MENUFORMPARTS_TYPE &part, const char *name, float x, float y, float w, float h) {
    part.name = const_cast<char *>(name);
    part.x = x;
    part.y = y;
    part.w = w;
    part.h = h;
    part.draw_flag = true;
}
} // namespace

TEST_F(MenuMouseInput, RetailOptionsHoverMovesRowAndButtonAndTheWheelScrolls) {
    MenuMouseEnable(true);
    CMenuOption        menu;
    CMenuPosDataForm   form{};
    MENUFORMPARTS_TYPE buttons[OPTION_ITEM_MAX][2]{};
    form.draw_flag = true;
    form.x = 40;
    form.y = 158; // Row 3's buttons are centred on the initial pointer, 256,240.
    for (int row = 0; row < OPTION_ITEM_MAX; ++row) {
        menu.choice_num[row] = 2;
        for (int choice = 0; choice < 2; ++choice) {
            Place(buttons[row][choice], "button", 200.0f + 80 * choice, 24.0f * row, 60, 20);
            menu.button[row][choice] = &buttons[row][choice];
        }
    }
    menu.mode = MENU_ASK_MODE_NONE;
    menu.top = menu.select = menu.choice = 0;
    // A stationary pointer leaves the keyboard's row alone.
    InputSetScriptedDevices({.mouse_buttons = 2});
    MenuMouseOptionHover(menu, &form, nullptr);
    EXPECT_EQ(MenuKeySelectCheck(0, &menu.select, &menu.top, 0, 16, 9, MENU_CURSOR_LIMIT_CLAMP), MENU_CURSOR_UNCHANGED);
    InputSetScriptedDevices({});
    Tick();
    InputSetScriptedDevices({.mouse_dx = 1});
    MenuMouseOptionHover(menu, &form, nullptr);
    EXPECT_EQ(MenuKeySelectCheck(0, &menu.select, &menu.top, 0, 16, 9, MENU_CURSOR_LIMIT_CLAMP), MENU_CURSOR_MOVED);
    EXPECT_EQ(menu.select, 3);
    EXPECT_EQ(menu.choice, 0);
    Tick();
    // Along one row the adapter changes the choice itself (and sounds it); no row move is queued.
    InputSetScriptedDevices({.mouse_dx = 80});
    MenuMouseOptionHover(menu, &form, nullptr);
    EXPECT_EQ(menu.choice, 1);
    EXPECT_EQ(MenuKeySelectCheck(0, &menu.select, &menu.top, 0, 16, 9, MENU_CURSOR_LIMIT_CLAMP), MENU_CURSOR_UNCHANGED);
    Tick();
    // The row's label keeps the row and its choice.
    InputSetScriptedDevices({.mouse_dx = -280});
    MenuMouseOptionHover(menu, &form, nullptr);
    EXPECT_EQ(MenuKeySelectCheck(0, &menu.select, &menu.top, 0, 16, 9, MENU_CURSOR_LIMIT_CLAMP), MENU_CURSOR_UNCHANGED);
    EXPECT_EQ(menu.choice, 1);
    Tick();
    // Two notches down: the list moves under the pointer, which stays on its fourth shown row.
    InputSetScriptedDevices({.mouse_wheel = -2});
    MenuMouseOptionHover(menu, &form, nullptr);
    EXPECT_EQ(menu.top, 2);
    EXPECT_EQ(MenuKeySelectCheck(0, &menu.select, &menu.top, 0, 16, 9, MENU_CURSOR_LIMIT_CLAMP), MENU_CURSOR_MOVED);
    EXPECT_EQ(menu.select, 5);
    EXPECT_EQ(menu.top, 2);
    Tick();
    // Sixteen retail options stop at the last page.
    InputSetScriptedDevices({.mouse_wheel = -20});
    MenuMouseOptionHover(menu, &form, nullptr);
    EXPECT_EQ(menu.top, 7);
}

TEST_F(MenuMouseInput, RetailOptionsHitOnlyDrawnRowsInsideTheListWhileItEases) {
    MenuMouseEnable(true);
    CMenuOption        menu;
    CMenuPosDataForm   form{};
    CMenuPosDataForm   clip{};
    MENUFORMPARTS_TYPE buttons[OPTION_ITEM_MAX][2]{};
    form.draw_flag = true;
    form.x = 40;
    for (int row = 0; row < OPTION_ITEM_MAX; ++row) {
        menu.choice_num[row] = 2;
        for (int choice = 0; choice < 2; ++choice) {
            Place(buttons[row][choice], "button", 200.0f + 80 * choice, 24.0f * row, 60, 20);
            menu.button[row][choice] = &buttons[row][choice];
        }
    }
    // Nine rows show between y 100 and 316. The wheel has just moved top to 7, but the drawn list
    // still starts near row 0: row 6's drawn buttons cover the initial pointer (256,240) though it
    // is above the new top, and row 10 has slid below the scissor, to y 330-350.
    clip.x = 30;
    clip.y = 100;
    clip.clip_w = 400;
    clip.clip_h = 216;
    form.y = 90;
    menu.mode = MENU_ASK_MODE_NONE;
    menu.top = 7;
    menu.select = 7;
    menu.choice = 0;
    // A visible outgoing row is still the row under the pointer, and clicking it confirms that row.
    InputSetScriptedDevices({.mouse_buttons = 1});
    EXPECT_TRUE(MenuMouseOption(menu, &form, &clip));
    EXPECT_EQ(menu.select, 6);
    InputSetScriptedDevices({});
    Tick();
    // The footer below the scissor is not row 10.
    InputSetScriptedDevices({.mouse_buttons = 1, .mouse_dy = 90});
    EXPECT_FALSE(MenuMouseOption(menu, &form, &clip));
    EXPECT_EQ(menu.select, 6);
    InputSetScriptedDevices({});
    Tick();
    InputSetScriptedDevices({.mouse_dx = 1});
    MenuMouseOptionHover(menu, &form, &clip);
    EXPECT_EQ(MenuKeySelectCheck(0, &menu.select, &menu.top, 0, 16, 9, MENU_CURSOR_LIMIT_CLAMP), MENU_CURSOR_UNCHANGED);
    // Without the scissor the same point would be row 10's button.
    EXPECT_TRUE(MenuMouseOption(menu, &form, nullptr));
    EXPECT_EQ(menu.select, 10);
}

TEST_F(MenuMouseInput, CharacterPortraitsSelectOnHoverAndOnlyAPortraitClickConfirms) {
    MenuMouseEnable(true);
    CMenuPosDataForm   form{};
    MENUFORMPARTS_TYPE rings[5]{};
    const char        *names[] = {"fc0", "fc1", "fc2", "fc3", "fc4"};
    for (int i = 0; i < 5; ++i) {
        Place(rings[i], names[i], 40.0f + 90 * i, 200, 80, 80);
    }
    form.parts = rings;
    form.parts_num = 5;
    // The pointer starts at 256,240, over fc2; the ridepod is not in this party.
    InputSetScriptedDevices({.mouse_buttons = 1, .mouse_dx = 1});
    EXPECT_EQ(MenuMouseCharaSelect(form, 0b0011, 0, 0), 0);
    EXPECT_FALSE(GamePad__2.Down(PAD_CROSS));
    InputSetScriptedDevices({});
    Tick();
    InputSetScriptedDevices({.mouse_dx = -90});
    EXPECT_EQ(MenuMouseCharaSelect(form, 0b0011, 0, 0), 1);
    Tick();
    InputSetScriptedDevices({.mouse_buttons = 1});
    EXPECT_EQ(MenuMouseCharaSelect(form, 0b0011, 0, 1), 1);
    EXPECT_TRUE(GamePad__2.Down(PAD_CROSS));
    InputSetScriptedDevices({});
    Tick();
    // The townsperson's portrait counts once one travels with the party.
    InputSetScriptedDevices({.mouse_dx = 270});
    EXPECT_EQ(MenuMouseCharaSelect(form, 0b0011, 0, 1), 1);
    Tick();
    InputSetScriptedDevices({.mouse_dx = 1});
    EXPECT_EQ(MenuMouseCharaSelect(form, 0b0011, 3, 1), 4);
    Tick();
    // The wheel does not walk the portrait map.
    InputSetScriptedDevices({.mouse_wheel = 1});
    EXPECT_EQ(MenuMouseCharaSelect(form, 0b0011, 3, 4), 4);
}

TEST(MenuMouse, CharacterPageStatesChooseWhatTheMouseDrives) {
    using enum MenuMouseCharaInput;
    constexpr int none = MENU_ASK_MODE_NONE;
    constexpr int box = CHR_CNG_SUB_MENU_MONSTER_BOX;
    constexpr int own = CHR_CNG_SUB_MENU_NONE;
    EXPECT_EQ(MenuMouseCharaInputFor(none, own, CHR_CNG_PAGE_SELECT, CHR_CNG_STEP_SELECT, 0, 0), Portraits);
    EXPECT_EQ(MenuMouseCharaInputFor(none, own, CHR_CNG_PAGE_SELECT, CHR_CNG_STEP_SELECT, CHR_CNG_PHASE_LOAD, 0), Locked);
    // The opening wait and the townsperson's questions keep the retail any-button and message choices.
    EXPECT_EQ(MenuMouseCharaInputFor(none, own, CHR_CNG_PAGE_SELECT, CHR_CNG_STEP_SELECT, 0, 20), Retail);
    EXPECT_EQ(MenuMouseCharaInputFor(none, own, CHR_CNG_PAGE_SELECT, CHR_CNG_STEP_NPC_MENU, 0, 0), Retail);
    EXPECT_EQ(MenuMouseCharaInputFor(none, own, CHR_CNG_PAGE_CONFIRM, 0, 0, 0), Retail);
    EXPECT_EQ(MenuMouseCharaInputFor(none, own, CHR_CNG_PAGE_NPC, CHR_CNG_NPC_STEP_COMMAND, 0, 0), Retail);
    EXPECT_EQ(MenuMouseCharaInputFor(none, own, CHR_CNG_PAGE_NPC, CHR_CNG_NPC_STEP_REPAIR_SELECT, 0, 0), RepairBoard);
    // Opening, closing and the monster box are not this page's.
    EXPECT_EQ(MenuMouseCharaInputFor(MENU_ASK_MODE_OPEN, own, CHR_CNG_PAGE_SELECT, CHR_CNG_STEP_SELECT, 0, 0), Retail);
    EXPECT_EQ(MenuMouseCharaInputFor(none, box, CHR_CNG_PAGE_SELECT, CHR_CNG_STEP_SELECT, 0, 0), Retail);
}

TEST_F(MenuMouseInput, RepairBoardSelectsItemsScrollsAndRejectsBackgroundClicks) {
    MenuMouseEnable(true);
    CMenuPosDataForm board{};
    board.draw_flag = true;
    board.x = 200;
    board.y = 30;
    const float old_x = MenuItemBrdUnderBrdPosXY[0];
    const float old_y = MenuItemBrdUnderBrdPosXY[1];
    // Slots are 40 by 50 from 216,56, six to a row, so the initial pointer (256,240) is slot 19.
    MenuItemBrdUnderBrdPosXY[0] = 216;
    MenuItemBrdUnderBrdPosXY[1] = 56;
    int select = 0;
    int top = 0;
    InputSetScriptedDevices({.mouse_dx = 1});
    MenuMouseRepairBoard(&board, select, top, 60);
    EXPECT_EQ(select, 19);
    Tick();
    InputSetScriptedDevices({.mouse_buttons = 1});
    MenuMouseRepairBoard(&board, select, top, 60);
    EXPECT_TRUE(GamePad__2.Down(PAD_CROSS));
    InputSetScriptedDevices({});
    Tick();
    // Two rows down keeps the pointer's place on the board.
    InputSetScriptedDevices({.mouse_wheel = -2});
    MenuMouseRepairBoard(&board, select, top, 60);
    EXPECT_EQ(top, 2);
    EXPECT_EQ(select, 31);
    Tick();
    // Beside the board a click does not repair the selected item.
    InputSetScriptedDevices({.mouse_dx = 250});
    MenuMouseRepairBoard(&board, select, top, 60);
    Tick();
    InputSetScriptedDevices({.mouse_buttons = 1});
    MenuMouseRepairBoard(&board, select, top, 60);
    EXPECT_FALSE(GamePad__2.Down(PAD_CROSS));
    EXPECT_EQ(select, 31);
    MenuItemBrdUnderBrdPosXY[0] = old_x;
    MenuItemBrdUnderBrdPosXY[1] = old_y;
}

TEST_F(MenuMouseInput, HelpEntriesFollowHoverScrollAndTurnPicturePages) {
    MenuMouseEnable(true);
    CManualMenu        menu;
    CMenuPosDataForm   background{};
    CMenuPosDataForm   clip{};
    MENUFORMPARTS_TYPE places[2]{};
    Place(places[0], "base_msg", 60, 100, 0, 0);
    Place(places[1], "scrlbase", 400, 100, 0, 0);
    places[0].dtype = places[1].dtype = MENUFORMPARTS_DTYPE_FUNCINFO;
    background.parts = places;
    background.parts_num = 2;
    clip.x = 40;
    clip.y = 96;
    clip.clip_w = 400;
    clip.clip_h = 240; // Ten entries.
    menu.mode = MENU_ASK_MODE_NONE;
    menu.list_y = 100; // Entry 6 spans y 240-264.
    InputSetScriptedDevices({.mouse_dx = 1});
    MenuMouseManual(menu, &background, &clip);
    EXPECT_EQ(MenuKeySelectCheck(0, &menu.select, &menu.top, 0, 46, 10, MENU_CURSOR_LIMIT_CLAMP), MENU_CURSOR_MOVED);
    EXPECT_EQ(menu.select, 6);
    Tick();
    InputSetScriptedDevices({.mouse_wheel = -3});
    MenuMouseManual(menu, &background, &clip);
    EXPECT_EQ(menu.top, 3);
    MenuKeySelectCheck(0, &menu.select, &menu.top, 0, 46, 10, MENU_CURSOR_LIMIT_CLAMP);
    EXPECT_EQ(menu.select, 9);
    Tick();
    // The drawn list has not eased yet: the pointer is still over entry 6, which is pictured there.
    InputSetScriptedDevices({.mouse_buttons = 1});
    MenuMouseManual(menu, &background, &clip);
    EXPECT_TRUE(GamePad__2.Down(PAD_CROSS));
    EXPECT_EQ(MenuKeySelectCheck(0, &menu.select, &menu.top, 0, 46, 10, MENU_CURSOR_LIMIT_CLAMP), MENU_CURSOR_MOVED);
    EXPECT_EQ(menu.select, 6);
    InputSetScriptedDevices({});
    Tick();
    // Entry 11 is drawn below the scissor (y 360-384); a click there opens nothing.
    InputSetScriptedDevices({.mouse_dy = 125});
    MenuMouseManual(menu, &background, &clip);
    Tick();
    InputSetScriptedDevices({.mouse_buttons = 1});
    MenuMouseManual(menu, &background, &clip);
    EXPECT_FALSE(GamePad__2.Down(PAD_CROSS));
    InputSetScriptedDevices({});
    Tick();
    // Beside the list a click does not open an entry either.
    InputSetScriptedDevices({.mouse_dx = 200, .mouse_dy = -125});
    MenuMouseManual(menu, &background, &clip);
    Tick();
    InputSetScriptedDevices({.mouse_buttons = 1});
    MenuMouseManual(menu, &background, &clip);
    EXPECT_FALSE(GamePad__2.Down(PAD_CROSS));
    InputSetScriptedDevices({});
    Tick();
    menu.key_arg_no = MANUAL_STEP_PLAY;
    menu.pict_mode = true;
    InputSetScriptedDevices({.mouse_wheel = -1});
    MenuMouseManual(menu, &background, &clip);
    EXPECT_TRUE(GamePad__2.Down(PAD_RIGHT));
    Tick();
    InputSetScriptedDevices({.mouse_wheel = 1});
    MenuMouseManual(menu, &background, &clip);
    EXPECT_TRUE(GamePad__2.Down(PAD_LEFT));
}

TEST_F(MenuMouseInput, NewestChoiceWindowTakesTheClickOverAListStillDrawingItsCursor) {
    const MenuMouseRect commands[] = {
        {.x = 20, .y = 300, .w = 100, .h = 20},
        {.x = 20, .y = 320, .w = 100, .h = 20}
    };
    const MenuMouseRect question[] = {
        {.x = 200, .y = 220, .w = 100, .h = 30},
        {.x = 200, .y = 250, .w = 100, .h = 30}
    };
    MenuMouseEnable(true);
    MenuMouseNoteChoices(this, 31, commands, 0, false);
    Tick();
    // The question opens over the commands; both note their choices every tick, the commands first.
    InputSetScriptedDevices({.mouse_buttons = 1});
    bool confirmed = false;
    for (int i = 0; i < 9 && !confirmed; ++i) {
        MenuMouseNoteChoices(this, 31, commands, 0, false);
        MenuMouseNoteChoices(this, 145, question, 0, false);
        confirmed = MenuMouseButtons() == PAD_CROSS;
        InputSetScriptedDevices({});
        Tick();
    }
    EXPECT_TRUE(confirmed);
}

namespace {
// Draws a list's choices and a question's each tick, in either order, and returns the retail buttons.
int DrawCommandsAndQuestion(const void *commands, const void *question, std::span<const MenuMouseRect> command_rows,
                            std::span<const MenuMouseRect> question_rows, int selected, bool question_first) {
    if (question_first) {
        MenuMouseNoteChoices(question, 145, question_rows, selected, true);
        MenuMouseNoteChoices(commands, 31, command_rows, 0, false);
    } else {
        MenuMouseNoteChoices(commands, 31, command_rows, 0, false);
        MenuMouseNoteChoices(question, 145, question_rows, selected, true);
    }
    return MenuMouseButtons();
}

constexpr MenuMouseRect kCommandRows[] = {
    {.x = 20, .y = 300, .w = 100, .h = 30},
    {.x = 20, .y = 330, .w = 100, .h = 30}
};
// The initial pointer, 256,240, is on the question's second choice.
constexpr MenuMouseRect kQuestionRows[] = {
    {.x = 100, .y = 220, .w = 100, .h = 30},
    {.x = 220, .y = 220, .w = 100, .h = 30}
};
} // namespace

TEST_F(MenuMouseInput, NewerQuestionMovesThenConfirmsWhateverTheRedrawOrderAndCommandsReturn) {
    int question = 0;
    MenuMouseEnable(true);
    MenuMouseNoteChoices(this, 31, kCommandRows, 0, false);
    Tick();
    int  selected = 0;
    bool confirmed = false;
    for (int i = 0; i < 12; ++i) {
        InputSetScriptedDevices({.mouse_buttons = i == 0 ? 1u : 0u});
        const int buttons = DrawCommandsAndQuestion(this, &question, kCommandRows, kQuestionRows, selected, i % 2);
        selected = buttons & PAD_RIGHT ? 1 : selected;
        confirmed = confirmed || (buttons & PAD_CROSS);
        Tick();
    }
    EXPECT_EQ(selected, 1);
    EXPECT_TRUE(confirmed);
    // Once the question closes, the commands take the mouse again.
    for (int i = 0; i < 10; ++i) {
        InputSetScriptedDevices({});
        MenuMouseNoteChoices(this, 31, kCommandRows, 0, false);
        EXPECT_EQ(MenuMouseButtons(), 0);
        Tick();
    }
    InputSetScriptedDevices({.mouse_buttons = 1, .mouse_dx = -200, .mouse_dy = 70});
    MenuMouseNoteChoices(this, 31, kCommandRows, 0, false);
    EXPECT_EQ(MenuMouseButtons(), PAD_CROSS);
}

TEST_F(MenuMouseInput, WindowsAppearingInOneTickKeepTheLaterDrawnOneOnTop) {
    for (const bool reversed_later : {false, true}) {
        int question = 0;
        MenuMouseEnable(false);
        MenuMouseEnable(true);
        int  selected = 0;
        bool confirmed = false;
        // Both first draw in one tick, commands first; later redraws may swap the order.
        for (int i = -10; i < 12; ++i) {
            InputSetScriptedDevices({.mouse_buttons = i == 0 ? 1u : 0u});
            const bool question_first = i > -10 && reversed_later;
            const int  buttons = DrawCommandsAndQuestion(this, &question, kCommandRows, kQuestionRows, selected, question_first);
            selected = buttons & PAD_RIGHT ? 1 : selected;
            confirmed = confirmed || (buttons & PAD_CROSS);
            Tick();
        }
        EXPECT_EQ(selected, 1) << reversed_later;
        EXPECT_TRUE(confirmed) << reversed_later;
        InputSetScriptedDevices({});
        Tick();
    }
}

TEST_F(MenuMouseInput, ReopenedQuestionTakesTheMouseBackFromTheCommands) {
    int question = 0;
    MenuMouseEnable(true);
    for (int i = 0; i < 3; ++i) {
        DrawCommandsAndQuestion(this, &question, kCommandRows, kQuestionRows, 0, false);
        Tick();
    }
    // The question closes for two ticks, then opens again over the commands.
    for (int i = 0; i < 2; ++i) {
        MenuMouseNoteChoices(this, 31, kCommandRows, 0, false);
        MenuMouseButtons();
        Tick();
    }
    int  selected = 0;
    bool confirmed = false;
    for (int i = 0; i < 12; ++i) {
        InputSetScriptedDevices({.mouse_buttons = i == 0 ? 1u : 0u});
        const int buttons = DrawCommandsAndQuestion(this, &question, kCommandRows, kQuestionRows, selected, false);
        selected = buttons & PAD_RIGHT ? 1 : selected;
        confirmed = confirmed || (buttons & PAD_CROSS);
        Tick();
    }
    EXPECT_EQ(selected, 1);
    EXPECT_TRUE(confirmed);
}

TEST_F(MenuMouseInput, RepairBoardOwnsClicksWhileCedricsCommandsStillDraw) {
    MenuMouseEnable(true);
    CMenuPosDataForm board{};
    board.draw_flag = true;
    board.x = 200;
    board.y = 30;
    const float old_x = MenuItemBrdUnderBrdPosXY[0];
    const float old_y = MenuItemBrdUnderBrdPosXY[1];
    MenuItemBrdUnderBrdPosXY[0] = 216;
    MenuItemBrdUnderBrdPosXY[1] = 56;
    int select = 0;
    int top = 0;
    for (int i = 0; i < 10; ++i) {
        MenuMouseNoteChoices(this, 31, kCommandRows, 0, false);
        InputSetScriptedDevices({});
        MenuMouseRepairBoard(&board, select, top, 60);
        Tick();
    }
    // A click on slot 19 confirms it; the commands' choices add no direction.
    MenuMouseNoteChoices(this, 31, kCommandRows, 0, false);
    InputSetScriptedDevices({.mouse_buttons = 1});
    MenuMouseRepairBoard(&board, select, top, 60);
    EXPECT_EQ(select, 19);
    EXPECT_EQ(MenuMouseButtons(), PAD_CROSS);
    InputSetScriptedDevices({});
    Tick();
    // A click on a command behind the board neither confirms nor moves; right click backs out.
    MenuMouseNoteChoices(this, 31, kCommandRows, 0, false);
    InputSetScriptedDevices({.mouse_buttons = 1, .mouse_dx = -200, .mouse_dy = 70});
    MenuMouseRepairBoard(&board, select, top, 60);
    EXPECT_EQ(MenuMouseButtons(), 0);
    EXPECT_EQ(select, 19);
    InputSetScriptedDevices({});
    Tick();
    MenuMouseNoteChoices(this, 31, kCommandRows, 0, false);
    InputSetScriptedDevices({.mouse_buttons = 2});
    MenuMouseRepairBoard(&board, select, top, 60);
    EXPECT_EQ(MenuMouseButtons(), PAD_CIRCLE);
    MenuItemBrdUnderBrdPosXY[0] = old_x;
    MenuItemBrdUnderBrdPosXY[1] = old_y;
}

TEST_F(MenuMouseInput, RepairBoardInputLeavesNoTargetForCedricsCommandsAfterItCloses) {
    // Board clicks on a command behind it, or wheel notches, then right click closes the board.
    for (const InputKeyboardMouse &board_input : {
             InputKeyboardMouse{.mouse_buttons = 1, .mouse_dx = -200, .mouse_dy = 100},
             InputKeyboardMouse{.mouse_wheel = -1}
    }) {
        InputSetScriptedDevices({});
        MenuMouseEnable(false);
        Tick();
        MenuMouseEnable(true);
        CMenuPosDataForm board{};
        board.draw_flag = true;
        board.x = 200;
        board.y = 30;
        const float old_x = MenuItemBrdUnderBrdPosXY[0];
        const float old_y = MenuItemBrdUnderBrdPosXY[1];
        MenuItemBrdUnderBrdPosXY[0] = 216;
        MenuItemBrdUnderBrdPosXY[1] = 56;
        int select = 0;
        int top = 0;
        for (int i = 0; i < 10; ++i) {
            MenuMouseNoteChoices(this, 31, kCommandRows, 0, false);
            InputSetScriptedDevices({});
            MenuMouseRepairBoard(&board, select, top, 60);
            Tick();
        }
        MenuMouseNoteChoices(this, 31, kCommandRows, 0, false);
        InputSetScriptedDevices(board_input);
        MenuMouseRepairBoard(&board, select, top, 60);
        EXPECT_EQ(MenuMouseButtons(), 0);
        Tick();
        MenuMouseNoteChoices(this, 31, kCommandRows, 0, false);
        InputSetScriptedDevices({.mouse_buttons = 2});
        MenuMouseRepairBoard(&board, select, top, 60);
        EXPECT_EQ(MenuMouseButtons(), PAD_CIRCLE);
        Tick();
        // Back on the commands: idle ticks move and confirm nothing.
        for (int i = 0; i < 10; ++i) {
            InputSetScriptedDevices({});
            MenuMouseNoteChoices(this, 31, kCommandRows, 0, false);
            EXPECT_EQ(MenuMouseButtons(), 0) << i;
            Tick();
        }
        // A fresh click on the first command confirms it.
        const auto pos = MenuMouseTake();
        Tick();
        InputSetScriptedDevices({.mouse_buttons = 1, .mouse_dx = 50 - pos.x, .mouse_dy = 310 - pos.y});
        MenuMouseNoteChoices(this, 31, kCommandRows, 0, false);
        EXPECT_EQ(MenuMouseButtons(), PAD_CROSS);
        InputSetScriptedDevices({});
        Tick();
        MenuItemBrdUnderBrdPosXY[0] = old_x;
        MenuItemBrdUnderBrdPosXY[1] = old_y;
    }
}

namespace {
MenuMouseSample DragSample(float x, bool held, bool pressed = false) {
    return {.x = x, .y = 200, .pointing = true, .clicked = pressed ? 1u : 0u, .held = held ? 1u : 0u};
}
} // namespace

TEST(MenuMouseDrag, TurnsOnlyAfterAFreshPressOverTheArea) {
    MenuMouseDrag drag;
    const int     owner = 0;
    EXPECT_EQ(drag.Step(&owner, 1, true, DragSample(350, true, true), false), 0);
    EXPECT_EQ(drag.Step(&owner, 2, true, DragSample(370, true), true), 0) << "pressed beside the area";
    EXPECT_EQ(drag.Step(&owner, 3, true, DragSample(380, false), true), 0);
    EXPECT_EQ(drag.Step(&owner, 4, true, DragSample(380, true, true), true), 0);
    EXPECT_EQ(drag.Step(&owner, 5, true, DragSample(395, true), false), 15) << "the drag keeps going off the area";
    EXPECT_EQ(drag.Step(&owner, 6, true, DragSample(390, true), true), -5);
}

TEST(MenuMouseDrag, AHeldPressDoesNotCarryThroughALoad) {
    MenuMouseDrag drag;
    const int     owner = 0;
    // Pressed while the model is still loading, then held as it finishes: no stale travel.
    EXPECT_EQ(drag.Step(&owner, 1, false, DragSample(350, true, true), true), 0);
    EXPECT_EQ(drag.Step(&owner, 2, false, DragSample(420, true), true), 0);
    EXPECT_EQ(drag.Step(&owner, 3, true, DragSample(450, true), true), 0);
    EXPECT_FALSE(drag.Dragging());
    // A load during a drag ends it too.
    EXPECT_EQ(drag.Step(&owner, 4, true, DragSample(450, true, true), true), 0);
    EXPECT_EQ(drag.Step(&owner, 5, false, DragSample(460, true), true), 0);
    EXPECT_EQ(drag.Step(&owner, 6, true, DragSample(500, true), true), 0);
}

TEST(MenuMouseDrag, AQuestionOrMissedTicksNeedAFreshPress) {
    MenuMouseDrag drag;
    const int     owner = 0;
    EXPECT_EQ(drag.Step(&owner, 1, true, DragSample(350, true, true), true), 0);
    EXPECT_EQ(drag.Step(&owner, 2, true, DragSample(360, true), true), 10);
    // A confirmation question cancels the drag; the button still held afterwards turns nothing.
    drag.Cancel();
    EXPECT_EQ(drag.Step(&owner, 3, true, DragSample(380, true), true), 0);
    EXPECT_EQ(drag.Step(&owner, 4, true, DragSample(380, true, true), true), 0);
    EXPECT_EQ(drag.Step(&owner, 5, true, DragSample(390, true), true), 10);
    // Ticks the menu skipped (its question took the mouse) end it as well.
    EXPECT_EQ(drag.Step(&owner, 9, true, DragSample(420, true), true), 0);
}

TEST(MenuMouseDrag, ReleaseOrAReopenedMenuEndsTheDrag) {
    MenuMouseDrag drag;
    const int     first = 0;
    const int     reopened = 0;
    EXPECT_EQ(drag.Step(&first, 1, true, DragSample(350, true, true), true), 0);
    EXPECT_EQ(drag.Step(&first, 2, true, DragSample(352, false), true), 0) << "released";
    EXPECT_EQ(drag.Step(&first, 3, true, DragSample(360, true), true), 0) << "held again without a press";
    EXPECT_EQ(drag.Step(&first, 4, true, DragSample(360, true, true), true), 0);
    EXPECT_EQ(drag.Step(&first, 5, true, DragSample(365, true), true), 5);
    // The menu closes and another opens while the button is still down.
    EXPECT_EQ(drag.Step(&reopened, 6, true, DragSample(380, true), true), 0);
    EXPECT_FALSE(drag.Dragging());
    // The pointer leaving the menu (hidden) ends it too.
    EXPECT_EQ(drag.Step(&reopened, 7, true, DragSample(380, true, true), true), 0);
    MenuMouseSample hidden = DragSample(400, true);
    hidden.pointing = false;
    EXPECT_EQ(drag.Step(&reopened, 8, true, hidden, true), 0);
    EXPECT_EQ(drag.Step(&reopened, 9, true, DragSample(420, true), true), 0);
}
