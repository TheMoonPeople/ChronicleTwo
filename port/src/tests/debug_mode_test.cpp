#include <SDL3/SDL.h>
#include <gtest/gtest.h>

#include <array>
#include <memory>

#include "debug_fixture.hpp"
#include "debug_mode.hpp"
#include "scoped_global_object.hpp"
#include "test_hooks.hpp"

using GamePadDebugChord = dc::test::DebugFixture;
#include "dng_debug.hpp"
#include "dng_main.hpp"
#include "editdebug.hpp"
#include "editloop.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "mg_memory.hpp"
#include "object/world/town_control.hpp"
#include "options/screen.hpp"
#include "platform/game_loop_state.hpp"
#include "platform/input.hpp"
#include "platform/settings.hpp"
#include "scenesnd.hpp"
#include "sphida.hpp"
#include "stubs/subgame.hpp"
#include "subgame.hpp"
#include "title.hpp"

namespace {

constexpr int kAllShoulders = PAD_L1 | PAD_R1 | PAD_L2 | PAD_R2;

class SphidaLeaseGuard {
public:
    SphidaLeaseGuard() : previous(dc2::sphida::Lease()) { InitSphida(); }

    ~SphidaLeaseGuard() {
        InitSphida();
        if (!previous.Bytes().empty()) {
            dc2::sphida::Publish(previous);
        }
    }

    SphidaLeaseGuard(const SphidaLeaseGuard &) = delete;
    SphidaLeaseGuard &operator=(const SphidaLeaseGuard &) = delete;

private:
    dc2::memory::ArenaBuffer previous;
};

bool PublishTestSphida(mgCMemory &memory, CSphida &sphida) {
    return dc2::sphida::Publish(dc2::memory::ArenaBuffer::Bind(
        memory, {reinterpret_cast<u8 *>(&sphida), sizeof(sphida)}));
}

} // namespace

TEST(DebugMode, BootOnSetsTheDebugCodeAndTheModeFlag) {
    MasterDebugCode = 0;
    MasterDebugModeOn = 0;
    DebugModeBoot(true);
    EXPECT_EQ(MasterDebugCode, MASTER_DEBUG_CODE);
    EXPECT_EQ(MasterDebugModeOn, 1);
}

TEST(DebugMode, BootOffLeavesTheGlobalsAlone) {
    MasterDebugCode = 0;
    MasterDebugModeOn = 0;
    DebugModeBoot(false);
    EXPECT_EQ(MasterDebugCode, 0);
    EXPECT_EQ(MasterDebugModeOn, 0);
}

TEST(DebugMode, ChordNeedsAllFourShouldersAndANewR3Press) {
    MasterDebugCode = MASTER_DEBUG_CODE;
    EXPECT_TRUE(DebugModeToggleChord(kAllShoulders, PAD_R3));
    EXPECT_TRUE(DebugModeToggleChord(kAllShoulders | PAD_CROSS, PAD_R3));
    EXPECT_FALSE(DebugModeToggleChord(kAllShoulders | PAD_R3, 0));
    EXPECT_FALSE(DebugModeToggleChord(PAD_R3, PAD_R3));
    for (int shoulder : {PAD_L1, PAD_R1, PAD_L2, PAD_R2}) {
        EXPECT_FALSE(DebugModeToggleChord(kAllShoulders & ~shoulder, PAD_R3)) << shoulder;
    }
}

TEST(DebugMode, ChordIsOffWithoutTheDebugCode) {
    MasterDebugCode = 0;
    EXPECT_FALSE(DebugModeToggleChord(kAllShoulders, PAD_R3));
}

// Drives the real pad-1 accessors the MainLoop call site uses, not masks built by hand.
TEST_F(GamePadDebugChord, FiresOnANewR3PressWithAllShoulders) {
    MasterDebugCode = MASTER_DEBUG_CODE;
    GamePad__2.key_lock = 0;
    GamePad__2.pad[0].button = kAllShoulders | PAD_R3;
    GamePad__2.previous_pad[0].button = kAllShoulders;
    EXPECT_TRUE(GameDebugEnabled() && DebugModeToggleChord(GamePad__2.GetPadOn(), GamePad__2.GetPadDown()));
}

TEST_F(GamePadDebugChord, DoesNotFireWhileR3IsHeld) {
    MasterDebugCode = MASTER_DEBUG_CODE;
    GamePad__2.key_lock = 0;
    GamePad__2.pad[0].button = kAllShoulders | PAD_R3;
    GamePad__2.previous_pad[0].button = kAllShoulders | PAD_R3;
    EXPECT_FALSE(GameDebugEnabled() && DebugModeToggleChord(GamePad__2.GetPadOn(), GamePad__2.GetPadDown()));
}

TEST_F(GamePadDebugChord, FiresWithPad2Locked) {
    MasterDebugCode = MASTER_DEBUG_CODE;
    GamePad__2.DebugKeyLock(1);
    GamePad__2.key_lock = 0;
    GamePad__2.pad[0].button = kAllShoulders | PAD_R3;
    GamePad__2.previous_pad[0].button = kAllShoulders;
    EXPECT_TRUE(GameDebugEnabled() && DebugModeToggleChord(GamePad__2.GetPadOn(), GamePad__2.GetPadDown()));
}

TEST_F(GamePadDebugChord, PadLockSilencesTheChord) {
    MasterDebugCode = MASTER_DEBUG_CODE;
    GamePad__2.key_lock = 1;
    GamePad__2.pad[0].button = kAllShoulders | PAD_R3;
    GamePad__2.previous_pad[0].button = kAllShoulders;
    EXPECT_FALSE(GameDebugEnabled() && DebugModeToggleChord(GamePad__2.GetPadOn(), GamePad__2.GetPadDown()));
    GamePad__2.key_lock = 0;
}

namespace {

// Puts the player in control of a dungeon floor and a town walk, the state the mode_debug_menu key reads, and restores the
// game's state afterwards.
class DebugMenuKey : public testing::Test {
protected:
    void SetUp() override {
        GamePad__2.key_lock = 0;
        GamePad__2.pad[0].button = 0;
        GamePad__2.previous_pad[0].button = 0;
        DebugFlag = 0;
        GetMainScene()->event_run = 0;
        scene.event_run = 0;
        DngMainScene = &scene;
        DngStatus = {};
        DngStatus.mode = DNG_STATUS_FIELD;
        BattleAreaScene = &area;
        dngGetDebugInfo()->active = false;
        SubGame = SUBGAME_NONE;
        InitSphida();
        PortTownLoopMode = EDIT_LOOP_WALK;
        PortTownControlMode = EDIT_CONTROL_PLAYER;
        PortTownLockChara = 0;
        PortTownPause = 0;
        EditDebugEnd();
    }

    void TearDown() override {
        EditDebugEnd();
        dngGetDebugInfo()->active = false;
        GamePad__2 = pad;
        DebugFlag = debug_flag;
        GetMainScene()->event_run = event_run;
        DngMainScene = dng_scene;
        DngStatus = status;
        BattleAreaScene = battle_area;
        SubGame = sub_game;

        PortTownLoopMode = town_loop;
        PortTownControlMode = town_control;
        PortTownLockChara = town_lock;
        PortTownPause = town_pause;
    }

    // A dropped press must leave DebugFlag and pad 1 as they were.
    void ExpectDropped(int loop) {
        const int held = GamePad__2.pad[0].button;
        const int previous = GamePad__2.previous_pad[0].button;
        const int flag = DebugFlag;
        EXPECT_EQ(DebugModeMenuButtons(loop), 0) << loop;
        EXPECT_FALSE(DebugModeMenuKey(loop)) << loop;
        EXPECT_EQ(DebugFlag, flag) << loop;
        EXPECT_EQ(GamePad__2.pad[0].button, held) << loop;
        EXPECT_EQ(GamePad__2.previous_pad[0].button, previous) << loop;
    }

    // Releases every pad 1 button for a tick, as GamePad__2.UpDate would.
    static void ReleasePad() {
        GamePad__2.previous_pad[0].button = GamePad__2.pad[0].button;
        GamePad__2.pad[0].button = 0;
    }

    CScene           scene;
    DNG_BATTLE_AREA  area{};
    CGamePad         pad = GamePad__2;
    int              debug_flag = DebugFlag;
    int              event_run = GetMainScene()->event_run;
    CScene          *dng_scene = DngMainScene;
    DNG_STATUS       status = DngStatus;
    DNG_BATTLE_AREA *battle_area = BattleAreaScene;
    int              sub_game = SubGame;
    SphidaLeaseGuard sphida_scope;
    int              town_loop = PortTownLoopMode;
    int              town_control = PortTownControlMode;
    int              town_lock = PortTownLockChara;
    int              town_pause = PortTownPause;
};

// Binds mode_debug_menu to F9 and presses it through the host input, as a keyboard or input script does.
class DebugMenuKeyInput : public testing::Test {
protected:
    void SetUp() override {
        HostSettings settings;
        settings.key_bindings = {
            {.action = "mode_debug_menu", .keys = {"F9"}}
        };
        InputResetBindings();
        InputApplyConfig(settings);
        InputSetScriptedDevices({});
        DebugModeDiscardMenuKey();
    }

    void TearDown() override {
        InputSetScriptedDevices({});
        DebugModeDiscardMenuKey();
        InputResetBindings();
    }

    static void Press() {
        InputSetScriptedDevices({.keys = {SDL_SCANCODE_F9}});
        InputSetScriptedDevices({});
    }
};

} // namespace

TEST_F(DebugMenuKey, OpensTheTitleOrFieldDebugMenu) {
    EXPECT_EQ(DebugModeMenuButtons(LOOP_TITLE), PAD_START | PAD_SELECT);
    EXPECT_EQ(DebugModeMenuButtons(LOOP_DUNGEON), PAD_R3);
    EXPECT_EQ(DebugModeMenuButtons(LOOP_EDIT), PAD_R3);

    GamePad__2.pad[0].button = PAD_R3;
    GamePad__2.previous_pad[0].button = PAD_R3;
    EXPECT_TRUE(DebugModeMenuKey(LOOP_DUNGEON));
    EXPECT_EQ(DebugFlag, 1);
    EXPECT_EQ(GamePad__2.GetPadDown(), PAD_R3);
}

TEST_F(DebugMenuKey, DropsThePressInLoopsWithoutADebugMenuKey) {
    for (int loop : {LOOP_MENU, LOOP_CHARA_VIEWER, LOOP_TEX_VIEWER, LOOP_MAP_VIEW, LOOP_SOUND_VIEWER, LOOP_MOVIE_VIEW,
                     LOOP_SV_CONV_VIEW}) {
        ExpectDropped(loop);
    }
}

// MenuMainKey would take the R3 as a menu_debug_flag toggle (menumain.cpp:1433).
TEST_F(DebugMenuKey, DropsThePressWhileADungeonMenuIsOpen) {
    for (auto mode : {DNG_STATUS_MENU, DNG_STATUS_EVENT_MENU}) {
        DngStatus.mode = mode;
        ExpectDropped(LOOP_DUNGEON);
    }
}

TEST_F(DebugMenuKey, DropsThePressWhileADungeonEventRunsOrThePlayerIsHeld) {
    DngStatus.mode = DNG_STATUS_EVENT;
    ExpectDropped(LOOP_DUNGEON);
    DngStatus.mode = DNG_STATUS_FIELD;
    GetMainScene()->event_run = 1;
    ExpectDropped(LOOP_DUNGEON);
    GetMainScene()->event_run = 0;
    for (u32 flag : {DNG_PAUSE_PLAYER_STEP, DNG_PAUSE_FIELD_STEP, DNG_PAUSE_PLAYER_CONTROL}) {
        area.pause_flag = flag;
        ExpectDropped(LOOP_DUNGEON);
    }
}

// Fishing and Spheda run in field mode, and DngMainKey reads the debug R3 before either (dng_main.cpp:2176-2275).
TEST_F(DebugMenuKey, DropsThePressWhileADungeonSubGameOrSphedaRuns) {
    SubGame = SUBGAME_FISHING;
    ExpectDropped(LOOP_DUNGEON);
    SubGame = SUBGAME_NONE;

    alignas(16) u_long128 storage[128]{};
    mgCMemory             memory;
    memory.stSetBuffer(storage, 128);
    auto *spheda = dc2::memory::NewObject<CSphida>(memory);
    ASSERT_NE(spheda, nullptr);
    ASSERT_TRUE(PublishTestSphida(memory, *spheda));
    spheda->play_flag = 1;
    ExpectDropped(LOOP_DUNGEON);
    // A floor's Spheda object that is not being played leaves the key alone.
    spheda->play_flag = 0;
    EXPECT_EQ(DebugModeMenuButtons(LOOP_DUNGEON), PAD_R3);
}

// EditDebugStart would reset MenuBuffer__2 under the open menu (editdebug.cpp:178-181).
TEST_F(DebugMenuKey, DropsThePressWhileATownMenuIsOpen) {
    for (int mode : {EDIT_LOOP_WALK_MENU, EDIT_LOOP_EDIT, EDIT_LOOP_EDIT_MENU, EDIT_LOOP_WAIT_READ}) {
        PortTownLoopMode = mode;
        ExpectDropped(LOOP_EDIT);
    }
}

TEST_F(DebugMenuKey, DropsThePressWhileATownEventRunsOrThePlayerIsHeld) {
    PortTownControlMode = EDIT_CONTROL_EVENT;
    ExpectDropped(LOOP_EDIT);
    PortTownControlMode = EDIT_CONTROL_PLAYER;
    GetMainScene()->event_run = 1;
    ExpectDropped(LOOP_EDIT);
    GetMainScene()->event_run = 0;
    PortTownLockChara = 1;
    ExpectDropped(LOOP_EDIT);
    PortTownLockChara = 0;
    PortTownPause = 1;
    ExpectDropped(LOOP_EDIT);
    PortTownPause = 0;
    SubGame = SUBGAME_FISHING;
    ExpectDropped(LOOP_EDIT);
}

TEST_F(DebugMenuKey, DropsThePressUnderAPadLockInEveryLoop) {
    GamePad__2.key_lock = 1;
    for (int loop : {LOOP_TITLE, LOOP_DUNGEON, LOOP_EDIT}) {
        ExpectDropped(loop);
    }
}

TEST_F(DebugMenuKey, DropsThePressUnderAPadLockWhileADebugMenuIsOpen) {
    dngGetDebugInfo()->active = true;
    area.pause_flag = DNG_PAUSE_PLAYER_STEP | DNG_PAUSE_PLAYER_CONTROL | DNG_PAUSE_FIELD_STEP;
    mgCMemory buffer;
    EditDebugStart(215, &buffer);
    PortTownControlMode = EDIT_CONTROL_DEBUG;
    ASSERT_EQ(DebugModeMenuButtons(LOOP_DUNGEON), PAD_R3);
    ASSERT_EQ(DebugModeMenuButtons(LOOP_EDIT), PAD_R3);

    GamePad__2.key_lock = 1;
    ExpectDropped(LOOP_DUNGEON);
    ExpectDropped(LOOP_EDIT);
}

// Both presses go through DngMainKey, which opens the menu on the first R3 and closes it on the second.
TEST_F(DebugMenuKey, SecondPressClosesTheDungeonDebugMenu) {
    ASSERT_TRUE(DebugModeMenuKey(LOOP_DUNGEON));
    EXPECT_EQ(DebugFlag, 1);
    DngMainKey();
    ASSERT_TRUE(dngGetDebugInfo()->active);
    ASSERT_FALSE(PortDungeonFieldControl());
    ReleasePad();
    DngMainKey();
    ASSERT_TRUE(dngGetDebugInfo()->active);
    DebugFlag = 0;

    EXPECT_TRUE(DebugModeMenuKey(LOOP_DUNGEON));
    EXPECT_EQ(DebugFlag, 1);
    DngMainKey();
    EXPECT_FALSE(dngGetDebugInfo()->active);
    EXPECT_EQ(area.pause_flag, 0u);
}

// EditDebugLoop draws through the renderer and the save data, so this stops at the R3 it closes on.
TEST_F(DebugMenuKey, SecondPressReachesTheOpenTownDebugMenu) {
    ASSERT_TRUE(DebugModeMenuKey(LOOP_EDIT));
    // EditLoop opens the menu on that R3 and hands control to it (editloop.cpp:1730-1733).
    mgCMemory buffer;
    EditDebugStart(215, &buffer);
    PortTownControlMode = EDIT_CONTROL_DEBUG;
    ASSERT_FALSE(PortTownFieldControl());
    ReleasePad();
    DebugFlag = 0;

    EXPECT_TRUE(DebugModeMenuKey(LOOP_EDIT));
    EXPECT_EQ(DebugFlag, 1);
    // EditDebugLoop closes on a new Cross or R3 (editdebug.cpp:458).
    EXPECT_TRUE(GamePad__2.Down(PAD_CROSS | PAD_R3));
    // EditLoop does not reopen it on the same press: control stays with the menu until it closes.
    EXPECT_EQ(PortTownControlMode, EDIT_CONTROL_DEBUG);
}

TEST_F(DebugMenuKeyInput, APressWithinAnOrdinaryTickCountsOnce) {
    DebugModeEndMenuKeyTick(10, 11);
    Press();
    Press();
    EXPECT_TRUE(DebugModeTakeMenuKey(11));
    DebugModeEndMenuKeyTick(11, 12);
    EXPECT_FALSE(DebugModeTakeMenuKey(12));
}

// The frame pause waits on sceGsSyncV, so no frame tells it apart: MainLoop discards when it resumes.
TEST_F(DebugMenuKeyInput, APressDuringAFramePauseIsDroppedOnResume) {
    DebugModeEndMenuKeyTick(10, 11);
    Press();
    DebugModeDiscardMenuKey();
    EXPECT_FALSE(DebugModeTakeMenuKey(11));
    DebugModeEndMenuKeyTick(11, 12);
    Press();
    EXPECT_TRUE(DebugModeTakeMenuKey(12));
}

// PauseLoop ends frames of its own between two ticks.
TEST_F(DebugMenuKeyInput, APressDuringThePauseOverlayIsDropped) {
    DebugModeEndMenuKeyTick(10, 11);
    Press();
    EXPECT_FALSE(DebugModeTakeMenuKey(40));
    DebugModeEndMenuKeyTick(40, 41);
    EXPECT_FALSE(DebugModeTakeMenuKey(41));
}

// A loading screen ends frames inside the tick that waits on it.
TEST_F(DebugMenuKeyInput, APressDuringALoadIsDropped) {
    DebugModeEndMenuKeyTick(10, 11);
    DebugModeEndMenuKeyTick(11, 90);
    Press();
    EXPECT_FALSE(DebugModeTakeMenuKey(90));
    DebugModeEndMenuKeyTick(90, 91);
    Press();
    EXPECT_TRUE(DebugModeTakeMenuKey(91));
}

// MainLoop discards when a mode starts, and the new mode's first tick has no tick before it.
TEST_F(DebugMenuKeyInput, APressAcrossAModeChangeIsDropped) {
    DebugModeEndMenuKeyTick(10, 11);
    Press();
    DebugModeDiscardMenuKey();
    Press();
    EXPECT_FALSE(DebugModeTakeMenuKey(11));
    DebugModeEndMenuKeyTick(11, 12);
    EXPECT_FALSE(DebugModeTakeMenuKey(12));
}

TEST_F(DebugMenuKeyInput, BindingCaptureDropsModeShortcutWithoutDeferringIt) {
    DebugModeEndMenuKeyTick(10, 11);
    Press();
    const int previous_binding = options::g_screen.binding;
    options::g_screen.binding = 0;
    EXPECT_FALSE(DebugModeTakeMenuKey(11));
    options::g_screen.binding = previous_binding;
    EXPECT_FALSE(DebugModeTakeMenuKey(11));
}

TEST_F(GamePadDebugChord, DeveloperShortcutDoesNotAlsoQueueTheModeShortcut) {
    InputSetScriptedDevices({});
    InputSetScriptedDevices({.keys = {SDL_SCANCODE_F1}});
    InputSetScriptedDevices({});
    EXPECT_TRUE(GameDeveloperMenuRequested(LOOP_EDIT));
    EXPECT_FALSE(GameDeveloperMenuRequested(LOOP_EDIT));
    EXPECT_FALSE(InputHostPressed(InputHostAction::ModeDebugMenu));
}

TEST(SphidaLifetime, ResetRejectsTheOldObjectAndItsReusedAddress) {
    alignas(16) u_long128 storage[128]{};
    mgCMemory             memory;
    memory.stSetBuffer(storage, 128);
    SphidaLeaseGuard guard;
    auto            *first = dc2::memory::NewObject<CSphida>(memory);
    ASSERT_NE(first, nullptr);
    ASSERT_TRUE(PublishTestSphida(memory, *first));
    const auto previous = dc2::sphida::Lease();
    EXPECT_EQ(GetSphidaPtr(), first);
    memory.stReset();
    EXPECT_EQ(GetSphidaPtr(), nullptr);
    auto *replacement = dc2::memory::NewObject<CSphida>(memory);
    ASSERT_EQ(replacement, first);
    EXPECT_FALSE(dc2::sphida::Publish(previous));
    EXPECT_EQ(GetSphidaPtr(), nullptr);
    ASSERT_TRUE(PublishTestSphida(memory, *replacement));
    EXPECT_EQ(GetSphidaPtr(), replacement);
    InitSphida();
    EXPECT_EQ(GetSphidaPtr(), nullptr);
}

TEST(SphidaLifetime, PublicationRejectsAnIncompleteExtentWithoutReplacingTheLiveGame) {
    alignas(16) u_long128 storage[128]{};
    mgCMemory             memory;
    memory.stSetBuffer(storage, 128);
    SphidaLeaseGuard guard;
    auto            *sphida = dc2::memory::NewObject<CSphida>(memory);
    ASSERT_NE(sphida, nullptr);
    ASSERT_TRUE(PublishTestSphida(memory, *sphida));
    const auto lease = dc2::sphida::Lease();
    EXPECT_FALSE(dc2::sphida::Publish(lease.Subspan(0, sizeof(CSphida) - 1)));
    EXPECT_FALSE(dc2::sphida::Publish({}));
    EXPECT_EQ(GetSphidaPtr(), sphida);
}

TEST(SphidaLifetime, HeapFreeRevokesTheGameAndUnrelatedFreePreservesIt) {
    alignas(16) u_long128 storage[256]{};
    mgCMemory             memory;
    memory.SetHeapMem(storage, 256);
    SphidaLeaseGuard guard;
    const auto       game = memory.StartStackMode(MG_STACK_MODE_FIT, 128);
    ASSERT_NE(game, nullptr);
    auto *sphida = dc2::memory::NewObject<CSphida>(memory);
    ASSERT_NE(sphida, nullptr);
    ASSERT_TRUE(PublishTestSphida(memory, *sphida));
    memory.EndStackMode();
    const auto unrelated = memory.StartStackMode(MG_STACK_MODE_FIT, 16);
    ASSERT_NE(unrelated, nullptr);
    ASSERT_NE(memory.Alloc(1), nullptr);
    memory.EndStackMode();
    memory.Free(unrelated);
    EXPECT_EQ(GetSphidaPtr(), sphida);
    const auto old = dc2::sphida::Lease();
    memory.Free(game);
    EXPECT_EQ(GetSphidaPtr(), nullptr);
    const auto reused = memory.StartStackMode(MG_STACK_MODE_FIT, 128);
    ASSERT_NE(reused, nullptr);
    auto *replacement = dc2::memory::NewObject<CSphida>(memory);
    ASSERT_EQ(replacement, sphida);
    EXPECT_FALSE(dc2::sphida::Publish(old));
    ASSERT_TRUE(PublishTestSphida(memory, *replacement));
    memory.EndStackMode();
    EXPECT_EQ(GetSphidaPtr(), replacement);
}

TEST(SphidaLifetime, DestructionAndReconstructedAllocatorIdentityKeepTheOldLeaseRetired) {
    alignas(16) u_long128                         storage[128]{};
    alignas(mgCMemory) std::byte                  owner_storage[sizeof(mgCMemory)];
    auto                                          destroy = [](mgCMemory *memory) { std::destroy_at(memory); };
    std::unique_ptr<mgCMemory, decltype(destroy)> owner(
        std::construct_at(reinterpret_cast<mgCMemory *>(owner_storage)), destroy);
    owner->stSetBuffer(storage, 128);
    SphidaLeaseGuard guard;
    auto            *first = dc2::memory::NewObject<CSphida>(*owner);
    ASSERT_NE(first, nullptr);
    ASSERT_TRUE(PublishTestSphida(*owner, *first));
    const auto previous = dc2::sphida::Lease();
    owner.reset();
    EXPECT_EQ(GetSphidaPtr(), nullptr);
    owner.reset(std::construct_at(reinterpret_cast<mgCMemory *>(owner_storage)));
    owner->stSetBuffer(storage, 128);
    auto *replacement = dc2::memory::NewObject<CSphida>(*owner);
    ASSERT_EQ(replacement, first);
    EXPECT_FALSE(dc2::sphida::Publish(previous));
    EXPECT_EQ(GetSphidaPtr(), nullptr);
    ASSERT_TRUE(PublishTestSphida(*owner, *replacement));
}
