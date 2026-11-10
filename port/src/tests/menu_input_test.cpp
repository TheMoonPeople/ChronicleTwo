#include <SDL3/SDL.h>
#include <gtest/gtest.h>

#include <array>
#include <cstring>
#include <memory>
#include <utility>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "nameregi.hpp"
#include "platform/clock.hpp"
#include "platform/input.hpp"
#include "platform/input_script.hpp"
#include "scenesnd.hpp"
#include "stubs/nameregi.hpp"

namespace {

class MenuInput : public testing::Test {
protected:
    void SetUp() override {
        InputResetBindings();
        GamePad__2.MenuModeOff();
    }

    void TearDown() override {
        GamePad__2.MenuModeOff();
        GamePad__2.AutoRepeatOff();
        InputScriptInstall({});
        InputResetBindings();
    }

    static unsigned Buttons(int scancode) {
        InputKeyboardMouse held;
        held.keys.push_back(scancode);
        return InputApplyKeyboardMouse({}, held).buttons;
    }
};

TEST_F(MenuInput, EscapeTracksRetailMenuMode) {
    EXPECT_EQ(Buttons(SDL_SCANCODE_ESCAPE), kInputTriangle);
    GamePad__2.MenuModeOn(120);
    EXPECT_EQ(GamePad__2.axis_threshold[0], 120);
    EXPECT_EQ(Buttons(SDL_SCANCODE_ESCAPE), kInputCircle);
    GamePad__2.MenuModeOff();
    EXPECT_EQ(GamePad__2.axis_threshold[0], 0);
    EXPECT_EQ(Buttons(SDL_SCANCODE_ESCAPE), kInputTriangle);
}

TEST_F(MenuInput, MenuKeyEnvironmentPropagatesEveryLayout) {
    SetMenuKeyCtrlEnv(0);
    EXPECT_EQ(GamePad__2.axis_threshold[0], 120);
    EXPECT_EQ(Buttons(SDL_SCANCODE_ESCAPE), kInputCircle);
    SetMenuKeyCtrlEnv(1);
    EXPECT_EQ(GamePad__2.axis_threshold[0], 0);
    EXPECT_EQ(Buttons(SDL_SCANCODE_ESCAPE), kInputTriangle);
    SetMenuKeyCtrlEnv(2);
    EXPECT_EQ(GamePad__2.axis_threshold[0], 120);
    EXPECT_EQ(Buttons(SDL_SCANCODE_ESCAPE), kInputCircle);
    SetMenuKeyCtrlEnv(3);
    EXPECT_EQ(GamePad__2.axis_threshold[0], 0);
    EXPECT_EQ(Buttons(SDL_SCANCODE_ESCAPE), kInputTriangle);
}

TEST_F(MenuInput, MenuModePreservesThresholdAndSecondPort) {
    CGamePad pad{};
    pad.axis_threshold[1] = 37;
    for (int threshold : {0, -1, 64, 120}) {
        pad.MenuModeOn(threshold);
        EXPECT_EQ(pad.axis_threshold[0], threshold);
        EXPECT_EQ(pad.axis_threshold[1], 37);
        EXPECT_EQ(Buttons(SDL_SCANCODE_ESCAPE), kInputCircle);
        pad.MenuModeOff();
        EXPECT_EQ(pad.axis_threshold[0], 0);
        EXPECT_EQ(pad.axis_threshold[1], 37);
        EXPECT_EQ(Buttons(SDL_SCANCODE_ESCAPE), kInputTriangle);
    }
}

TEST_F(MenuInput, OtherDefaultKeysRetainTheirPadButtons) {
    for (bool menu : {false, true}) {
        if (menu) {
            GamePad__2.MenuModeOn(120);
        }
        EXPECT_EQ(Buttons(SDL_SCANCODE_TAB), kInputTriangle);
        EXPECT_EQ(Buttons(SDL_SCANCODE_RETURN), kInputStart);
        EXPECT_EQ(Buttons(SDL_SCANCODE_E), kInputSquare);
        EXPECT_EQ(Buttons(SDL_SCANCODE_SPACE), kInputCross);
    }
}

TEST_F(MenuInput, EnglishMenuReadsEscapeAsCancelAndSpaceAsConfirm) {
    const int language = LanguageCode;
    LanguageCode = LANG_ENGLISH;
    GamePad__2.key_lock = 0;
    GamePad__2.previous_pad[0].button = 0;
    GamePad__2.MenuModeOn(120);
    GamePad__2.pad[0].button = Buttons(SDL_SCANCODE_ESCAPE);
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_CANCEL);
    GamePad__2.pad[0].button = Buttons(SDL_SCANCODE_SPACE);
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_DECIDE);
    GamePad__2.pad[0].button = Buttons(SDL_SCANCODE_TAB);
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_TRIANGLE);
    EXPECT_EQ(ConvertCheckPushButton(MenuCheckPushButton()), MENU_PUSH_BUTTON_CANCEL);
    GamePad__2.pad[0].button = 0;
    LanguageCode = language;
}

TEST_F(MenuInput, RetailUpdateConvertsLeftStickOnlyPastMenuThreshold) {
    InputScript script;
    std::string error;
    ASSERT_TRUE(InputScriptParse("0 pad1\n0 pad2\n4 pad1 255 128 128 128\n5 pad1 0 128 128 128\n6 pad1 128 255 128 128\n7 pad1 128 0 128 128\n8 pad1 255 128 128 128\n", script, error)) << error;
    InputScriptInstall(std::move(script));
    ClockSetUnbounded(true);
    ClockReset();
    GamePad__2.Init();
    for (int frame = 0; frame < 4; ++frame) {
        InputScriptApply(frame);
        GamePad__2.UpDate();
    }
    constexpr int directions = PAD_RIGHT | PAD_LEFT | PAD_DOWN | PAD_UP;
    GamePad__2.MenuModeOn(120);
    int frame = 4;
    for (int direction : {PAD_RIGHT, PAD_LEFT, PAD_DOWN, PAD_UP}) {
        InputScriptApply(frame++);
        GamePad__2.UpDate();
        EXPECT_EQ(GamePad__2.pad[0].button & directions, direction);
    }
    GamePad__2.MenuModeOff();
    InputScriptApply(8);
    GamePad__2.UpDate();
    EXPECT_EQ(GamePad__2.GetLX(), 128);
    EXPECT_EQ(GamePad__2.pad[0].button & directions, 0);
    GamePad__2.MenuModeOn(128);
    GamePad__2.UpDate();
    EXPECT_EQ(GamePad__2.pad[0].button & directions, 0);
    GamePad__2.MenuModeOn(127);
    GamePad__2.UpDate();
    EXPECT_EQ(GamePad__2.pad[0].button & directions, PAD_RIGHT);
}

TEST_F(MenuInput, KeyboardStickNavigatesOnlyInRetailMenuMode) {
    InputScript script;
    std::string error;
    ASSERT_TRUE(InputScriptParse("0 pad1\n0 pad2\n4 key:W\n5 key:S\n6 key:A\n7 key:D\n8 key:Up\n9 key:Down\n10 key:Left\n11 key:Right\n", script, error)) << error;
    InputScriptInstall(std::move(script));
    ClockSetUnbounded(true);
    ClockReset();
    constexpr int directions = PAD_UP | PAD_DOWN | PAD_LEFT | PAD_RIGHT;
    for (bool menu : {false, true}) {
        GamePad__2.Init();
        for (int frame = 0; frame < 4; ++frame) {
            InputScriptApply(frame);
            GamePad__2.UpDate();
        }
        if (menu) {
            GamePad__2.MenuModeOn(120);
        }
        for (int frame = 4; frame < 8; ++frame) {
            InputScriptApply(frame);
            GamePad__2.UpDate();
            const int expected[] = {PAD_UP, PAD_DOWN, PAD_LEFT, PAD_RIGHT};
            EXPECT_EQ(GamePad__2.pad[0].button & directions, menu ? expected[frame - 4] : 0)
                << "menu=" << menu << " frame=" << frame;
            EXPECT_NE(frame < 6 ? GamePad__2.GetLY() : GamePad__2.GetLX(), 0);
        }
        int frame = 8;
        for (int direction : {PAD_UP, PAD_DOWN, PAD_LEFT, PAD_RIGHT}) {
            InputScriptApply(frame++);
            GamePad__2.UpDate();
            EXPECT_EQ(GamePad__2.pad[0].button & directions, direction);
        }
    }
}

TEST_F(MenuInput, ReboundStickUsesThresholdAndStopsConvertingOnMenuExit) {
    const std::string_view binding[] = {"H"};
    ASSERT_TRUE(InputBindKeys("lx+", binding));
    InputScript script;
    std::string error;
    ASSERT_TRUE(InputScriptParse("0 pad1\n0 pad2\n4 key:H\n5 key:Right\n", script, error)) << error;
    InputScriptInstall(std::move(script));
    ClockSetUnbounded(true);
    ClockReset();
    GamePad__2.Init();
    for (int frame = 0; frame < 4; ++frame) {
        InputScriptApply(frame);
        GamePad__2.UpDate();
    }
    InputScriptApply(4);
    constexpr int directions = PAD_UP | PAD_DOWN | PAD_LEFT | PAD_RIGHT;
    for (int threshold : {0, 128, 127, 0, 120, -1}) {
        GamePad__2.MenuModeOn(threshold);
        GamePad__2.UpDate();
        EXPECT_EQ(GamePad__2.GetLX(), 128);
        EXPECT_EQ(GamePad__2.pad[0].button & directions,
                  threshold > 0 && threshold < 128 ? PAD_RIGHT : 0);
    }
    GamePad__2.MenuModeOff();
    GamePad__2.UpDate();
    EXPECT_EQ(GamePad__2.pad[0].button & directions, 0);
    InputScriptApply(5);
    GamePad__2.UpDate();
    EXPECT_TRUE(GamePad__2.Down(PAD_RIGHT));
}

TEST_F(MenuInput, MixedSourcesUseRetailThresholdAndOppositeCancellation) {
    InputScript script;
    std::string error;
    ASSERT_TRUE(InputScriptParse("0 pad1\n0 pad2\n4 key:W 255 128 128 128\n5 key:A 128 255 128 128\n6 key:Right key:A\n7 key:W key:D\n8 pad1 128 0 128 128\n", script, error)) << error;
    InputScriptInstall(std::move(script));
    ClockSetUnbounded(true);
    ClockReset();
    GamePad__2.Init();
    for (int frame = 0; frame < 4; ++frame) {
        InputScriptApply(frame);
        GamePad__2.UpDate();
    }
    GamePad__2.MenuModeOn(120);
    constexpr int directions = PAD_UP | PAD_DOWN | PAD_LEFT | PAD_RIGHT;
    int           frame = 4;
    for (int expected : std::initializer_list<int>{PAD_RIGHT | PAD_UP, PAD_DOWN | PAD_LEFT, 0, 0, PAD_UP}) {
        InputScriptApply(frame++);
        GamePad__2.UpDate();
        EXPECT_EQ(GamePad__2.pad[0].button & directions, expected);
    }
}

TEST_F(MenuInput, FieldMovementKeysDoNotSuppressDpadRepeatOrSecondPadLock) {
    InputScript script;
    std::string error;
    ASSERT_TRUE(InputScriptParse("0 pad1\n0 pad2\n4 key:A key:Right\n4 pad2 left\n12\n12 pad2\n", script, error)) << error;
    InputScriptInstall(std::move(script));
    ClockSetUnbounded(true);
    ClockReset();
    GamePad__2.Init();
    for (int frame = 0; frame < 4; ++frame) {
        InputScriptApply(frame);
        GamePad__2.UpDate();
    }
    GamePad__2.MenuModeOff();
    GamePad__2.SetAutoRepeat(PAD_RIGHT, 3, 2);
    for (int frame = 4; frame < 12; ++frame) {
        InputScriptApply(frame);
        GamePad__2.UpDate();
        EXPECT_EQ(GamePad__2.GetLX(), -128);
        EXPECT_FALSE(GamePad__2.On(PAD_LEFT));
        EXPECT_EQ(GamePad__2.Down(PAD_RIGHT) != 0, frame == 4 || frame == 7 || frame == 9 || frame == 11);
        EXPECT_TRUE(GamePad__2.On2(PAD_LEFT));
    }
    GamePad__2.key_lock2 = 1;
    GamePad__2.UpDate();
    EXPECT_EQ(GamePad__2.pad[1].button, 0);
    EXPECT_EQ(GamePad__2.previous_pad[1].button, 0);
    GamePad__2.key_lock2 = 0;
    InputScriptApply(12);
    GamePad__2.UpDate();
    EXPECT_FALSE(GamePad__2.On(PAD_RIGHT));
    EXPECT_EQ(GamePad__2.GetLX(), 0);
}

} // namespace

TEST_F(MenuInput, MouseMotionCannotReachMenuSticksOrRetailDirectionConversion) {
    GamePad__2.MenuModeOn(120);
    constexpr int          directions = PAD_UP | PAD_DOWN | PAD_LEFT | PAD_RIGHT;
    const std::string_view x[] = {"MouseX"};
    const std::string_view y[] = {"MouseY"};
    ASSERT_TRUE(InputBindKeys("lx", x));
    ASSERT_TRUE(InputBindKeys("ly", y));
    for (float motion : {-10000.0f, 10000.0f}) {
        const auto pad = InputApplyKeyboardMouse({}, {.mouse_dx = motion, .mouse_dy = motion});
        EXPECT_EQ(pad.left_x, 128);
        EXPECT_EQ(pad.left_y, 128);
        EXPECT_EQ(pad.right_x, 128);
        EXPECT_EQ(pad.right_y, 128);
        EXPECT_EQ(pad.buttons & directions, 0);
    }
}

TEST_F(MenuInput, ScriptedMenuMotionLeavesRetailAxesDirectionsAndCameraNeutral) {
    InputScript script;
    std::string error;
    ASSERT_TRUE(InputScriptParse("0 pad1\n0 pad2\n4 mouse:10000,10000\n5 mouse:-10000,-10000\n", script, error)) << error;
    InputScriptInstall(std::move(script));
    ClockSetUnbounded(true);
    ClockReset();
    GamePad__2.Init();
    for (int frame = 0; frame < 4; ++frame) {
        InputScriptApply(frame);
        GamePad__2.UpDate();
    }
    GamePad__2.MenuModeOn(120);
    for (int frame = 4; frame < 6; ++frame) {
        InputScriptApply(frame);
        GamePad__2.UpDate();
        EXPECT_EQ(GamePad__2.GetLX(), 0);
        EXPECT_EQ(GamePad__2.GetLY(), 0);
        EXPECT_EQ(GamePad__2.GetRX(), 0);
        EXPECT_EQ(GamePad__2.GetRY(), 0);
        EXPECT_EQ(GamePad__2.pad[0].button & (PAD_UP | PAD_DOWN | PAD_LEFT | PAD_RIGHT), 0);
        EXPECT_FLOAT_EQ(InputGetMouseLook().yaw, 0);
        EXPECT_FLOAT_EQ(InputGetMouseLook().pitch, 0);
    }
}

namespace {

/**
 * Supplies the real name-entry menu with idle key controls and message windows.
 */
class NameEntryInput : public testing::Test {
protected:
    void SetUp() override {
        InputResetBindings();
        InputSetTextEntry(false);
        LanguageCode = 1;
        NameRegiMenuPtr = &menu;
        NameRegistMax = 5;
        MenuCommonInfo = &keys;
        MenuDCMsg[6] = &help;
        MenuDCMsg[7] = &confirmation;
        help.buff = nullptr;
        confirmation.buff = nullptr;
        keys.key_enable = 0;
        menu.mode = NAMEREGI_MODE_INPUT;
        menu.key_arg_no = 0;
        menu.command_pos = 2;
        menu.select_mode = 2;
        menu.message_open = 0;
        menu.name_pos = 0;
        std::memset(menu.name, 0, sizeof(menu.name));
        GamePad__2.key_lock = 0;
        GamePad__2.pad[0].button = 0;
        GamePad__2.previous_pad[0].button = 0;
        EXPECT_EQ(NameRegistKey(), 0);
    }

    void TearDown() override {
        InputSetTextEntry(false);
        InputResetBindings();
        LanguageCode = language;
        NameRegiMenuPtr = previous_menu;
        NameRegistMax = maximum;
        MenuCommonInfo = previous_keys;
        MenuDCMsg[6] = previous_help;
        MenuDCMsg[7] = previous_confirmation;
        GamePad__2 = previous_pad;
    }

    /**
     * Sends one physical key press through the host event handler.
     */
    static void TypeKey(SDL_Scancode scancode, SDL_Keymod modifiers = SDL_KMOD_NONE) {
        SDL_Event event{};
        event.type = SDL_EVENT_KEY_DOWN;
        event.key.scancode = scancode;
        event.key.mod = modifiers;
        event.key.down = true;
        InputHandleEvent(event);
        event.type = SDL_EVENT_KEY_UP;
        event.key.down = false;
        InputHandleEvent(event);
    }

    int            language = LanguageCode;              /**< Previous game language. */
    CNameRegiMenu *previous_menu = NameRegiMenuPtr;      /**< Previous name-entry menu. */
    s16            maximum = NameRegistMax;              /**< Previous name-length limit. */
    CMenuKeyFunc  *previous_keys = MenuCommonInfo;       /**< Previous shared menu controls. */
    CDC2Mes       *previous_help = MenuDCMsg[6];         /**< Previous help window. */
    CDC2Mes       *previous_confirmation = MenuDCMsg[7]; /**< Previous confirmation window. */
    CGamePad       previous_pad = GamePad__2;            /**< Previous gamepad state. */
    CNameRegiMenu  menu;                                 /**< Real name-entry menu receiving typed characters. */
    CMenuKeyFunc   keys;                                 /**< Idle controls that avoid retail grid actions. */
    CDC2Mes        help;                                 /**< Empty help window for native menu stepping. */
    CDC2Mes        confirmation;                         /**< Empty confirmation window for native menu stepping. */
};

TEST_F(NameEntryInput, PhysicalTypingInsertsCharactersAndHonorsTheNameLimit) {
    TypeKey(SDL_SCANCODE_A, SDL_KMOD_SHIFT);
    TypeKey(SDL_SCANCODE_B);
    TypeKey(SDL_SCANCODE_1);
    EXPECT_EQ(NameRegistKey(), 0);
    EXPECT_STREQ(menu.name, "Ab1");
    EXPECT_EQ(menu.name_pos, 3);
    TypeKey(SDL_SCANCODE_C);
    TypeKey(SDL_SCANCODE_D);
    TypeKey(SDL_SCANCODE_E);
    EXPECT_EQ(NameRegistKey(), 0);
    EXPECT_STREQ(menu.name, "Ab1ce");
    EXPECT_EQ(menu.name_pos, 4);
    EXPECT_TRUE(InputTakeText().empty());
}

TEST_F(NameEntryInput, BackspaceAndDeleteEditAtTheCaret) {
    std::strcpy(menu.name, "ABCD");
    menu.name_pos = 2;
    TypeKey(SDL_SCANCODE_BACKSPACE);
    NameRegistKey();
    EXPECT_STREQ(menu.name, "ACD");
    EXPECT_EQ(menu.name_pos, 1);
    EXPECT_EQ(menu.button_flash[7], 8);
    TypeKey(SDL_SCANCODE_DELETE);
    NameRegistKey();
    EXPECT_STREQ(menu.name, "AD");
    EXPECT_EQ(menu.name_pos, 1);
    EXPECT_EQ(menu.button_flash[8], 8);
}

TEST_F(NameEntryInput, TypingSuppressesPadBindingsAndReturnSelectsTheAcceptCommand) {
    InputKeyboardMouse held;
    held.keys = {SDL_SCANCODE_E, SDL_SCANCODE_BACKSPACE};
    EXPECT_EQ(InputApplyKeyboardMouse({}, held).buttons & (kInputSquare | kInputSelect), 0);
    held.keys = {SDL_SCANCODE_RETURN};
    EXPECT_EQ(InputApplyKeyboardMouse({}, held).buttons & (kInputCross | kInputStart), kInputCross);
    TypeKey(SDL_SCANCODE_RETURN);
    NameRegistKey();
    EXPECT_EQ(menu.key_arg_no, 0);
    EXPECT_EQ(menu.command_pos, 11);
}

TEST_F(NameEntryInput, JapaneseAndAnOpenMessageBypassPhysicalTyping) {
    LanguageCode = 0;
    NameRegistKey();
    TypeKey(SDL_SCANCODE_A);
    NameRegistKey();
    EXPECT_STREQ(menu.name, "");
    InputKeyboardMouse held;
    held.keys = {SDL_SCANCODE_E};
    EXPECT_EQ(InputApplyKeyboardMouse({}, held).buttons & kInputSquare, kInputSquare);
    LanguageCode = 1;
    menu.message_open = 1;
    NameRegistKey();
    TypeKey(SDL_SCANCODE_A);
    NameRegistKey();
    EXPECT_STREQ(menu.name, "");
}

TEST_F(NameEntryInput, ForcedExitRetiresTheBorrowedControllerAndReleasesTextInput) {
    dc2::menu::ResetNameRegistration();
    EXPECT_EQ(NameRegiMenuPtr, nullptr);
    menu.name[0] = 'x';
    EXPECT_EQ(NameRegistKey(), 1);
    EXPECT_EQ(menu.name[0], 'x');
    NameRegistDraw();
    InputKeyboardMouse held;
    held.keys = {SDL_SCANCODE_E};
    EXPECT_EQ(InputApplyKeyboardMouse({}, held).buttons & kInputSquare, kInputSquare);
    dc2::menu::ResetNameRegistration();
}

TEST_F(NameEntryInput, CompletedCloseRetiresTheControllerBeforeItsBackingArenaReset) {
    auto    scene = std::make_unique<CScene>();
    CScene *previous_scene = MenuMainScene;
    MenuMainScene = scene.get();
    scene->fade.end = 1;
    menu.mode = NAMEREGI_MODE_CLOSE;
    EXPECT_EQ(NameRegistKey(), 1);
    EXPECT_EQ(NameRegiMenuPtr, nullptr);
    MenuMainScene = previous_scene;
}

TEST_F(NameEntryInput, SelectedGlyphRejectsInvalidModesAndCellsWithoutWriting) {
    std::array<char, 2> glyph{'x', 'y'};
    menu.select_mode = 2;
    menu.select.pos = 0;
    ASSERT_TRUE(menu.GetSelectedActiveFont(glyph));
    EXPECT_EQ(glyph[0], 'A');
    EXPECT_EQ(glyph[1], char{});
    glyph = {'x', 'y'};
    menu.select.pos = 32767;
    EXPECT_FALSE(menu.GetSelectedActiveFont(glyph));
    EXPECT_EQ(glyph, (std::array<char, 2>{'x', 'y'}));
    menu.select_mode = -1;
    EXPECT_FALSE(menu.GetSelectedActiveFont(glyph));
    EXPECT_EQ(glyph, (std::array<char, 2>{'x', 'y'}));
}

} // namespace

TEST(MenuQuestion, CommandsCopyTypedFieldsAndResetWithoutAliasing) {
    CBaseMenuClass    menu;
    MENU_ASKMODE_PARA request;
    for (std::size_t i = 0; i < std::size(request.cmd_msg); ++i) {
        request.cmd_msg[i] = static_cast<int>(i + 10);
        request.cmd_color[i] = static_cast<u32>(i + 100);
        request.cmd_shade[i] = static_cast<s16>(i + 200);
        request.cmd_mark[i] = static_cast<s16>(i + 300);
    }
    menu.SetAskParam(&request);
    menu.SetAskParam(&menu.ask_para);
    for (std::size_t i = 0; i < std::size(request.cmd_msg); ++i) {
        EXPECT_EQ(menu.ask_para.cmd_msg[i], request.cmd_msg[i]);
        EXPECT_EQ(menu.ask_para.cmd_color[i], request.cmd_color[i]);
        EXPECT_EQ(menu.ask_para.cmd_shade[i], request.cmd_shade[i]);
        EXPECT_EQ(menu.ask_para.cmd_mark[i], request.cmd_mark[i]);
    }
    menu.SetAskParam(nullptr);
    for (std::size_t i = 0; i < std::size(request.cmd_msg); ++i) {
        EXPECT_EQ(menu.ask_para.cmd_msg[i], 0);
        EXPECT_EQ(menu.ask_para.cmd_color[i], 0u);
        EXPECT_EQ(menu.ask_para.cmd_shade[i], 0);
        EXPECT_EQ(menu.ask_para.cmd_mark[i], 0);
    }
}
