#include <gtest/gtest.h>

#include <cmath>
#include <cstring>
#include <string>

#include "dng_main.hpp"
#include "editctrl_port.hpp"
#include "editloop.hpp"
#include "gfx/displaylist.hpp"
#include "mainloop_port.hpp"
#include "menu_world.hpp"
#include "menudraw.hpp"
#include "menudraw_port.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib.hpp"

namespace {

// One character per entry: M mesh, D 2D draw, C clear, T target, K copy, R depth read.
std::string Kinds(const gfx::DisplayList &list) {
    std::string kinds;
    for (const gfx::detail::Entry &entry : list.entries) {
        if (std::holds_alternative<gfx::detail::MeshEntry>(entry)) {
            kinds += 'M';
        } else if (std::holds_alternative<gfx::detail::Draw2DEntry>(entry)) {
            kinds += 'D';
        } else if (std::holds_alternative<gfx::detail::ClearEntry>(entry)) {
            kinds += 'C';
        } else if (std::holds_alternative<gfx::detail::TargetEntry>(entry)) {
            kinds += 'T';
        } else if (std::holds_alternative<gfx::detail::CopyEntry>(entry)) {
            kinds += 'K';
        } else if (std::holds_alternative<gfx::detail::ReadDepthEntry>(entry)) {
            kinds += 'R';
        }
    }
    return kinds;
}

gfx::detail::MeshRecord MeshRecordWithKey(gfx::InterpKey key) {
    gfx::detail::MeshRecord record;
    record.key = key;
    return record;
}

gfx::detail::MeshEntry MeshOfRecord(uint32_t record) {
    gfx::detail::MeshEntry mesh;
    mesh.record = record;
    return mesh;
}

gfx::detail::Draw2DEntry Draw2DWithKey(gfx::InterpKey key, gfx::TextureHandle texture = gfx::kNullTexture) {
    gfx::detail::Draw2DEntry draw{};
    draw.interpolation.key = key;
    draw.binding.texture = texture;
    return draw;
}

} // namespace

// Menus other than the town and dungeon main menus open at once, and nothing of the Item page changes.
TEST(MenuWorld, OtherMenusOpenUnchanged) {
    MENU_INIT_ARG arg{};
    arg.open_type = MENU_OPEN_INVENT;
    menuworld::MenuOpening(&arg);
    menuworld::MenuOpening(nullptr);
    EXPECT_FALSE(menuworld::ItemBackdrop());

    const menuworld::ItemDrawScope scope;
    EXPECT_FALSE(menuworld::FillWithBackdrop());
    EXPECT_FALSE(menuworld::SelectionAnchor().has_value());
    EXPECT_FLOAT_EQ(menuworld::RetailPointerX(123.5f), 123.5f);
}

TEST(MenuWorld, SpreadPointerReachesLeftPanelPartsUpToTheSplit) {
    // At 16:9 the left panels move 106.7 left and the bag 106.7 right of the split at 240.
    const float shift = -106.7f;
    // A weapon icon drawn at retail x 225, inside the 40-wide band before the split, is hit where it is drawn.
    EXPECT_FLOAT_EQ(menuworld::SpreadPointerX(225.0f + shift, shift, 240.0f, false), 225.0f);
    EXPECT_FLOAT_EQ(menuworld::SpreadPointerX(100.0f + shift, shift, 240.0f, false), 100.0f);
    // The bag's first column, and the gap between the spreads.
    EXPECT_FLOAT_EQ(menuworld::SpreadPointerX(250.0f - shift, shift, 240.0f, false), 250.0f);
    EXPECT_LT(menuworld::SpreadPointerX(240.0f, shift, 240.0f, false), -1000.0f);
    EXPECT_GT(menuworld::SpreadPointerX(240.0f, shift, 240.0f, true), 240.0f);
    // At 4:3 nothing moves.
    EXPECT_FLOAT_EQ(menuworld::SpreadPointerX(239.0f, 0.0f, 240.0f, false), 239.0f);
    EXPECT_FLOAT_EQ(menuworld::SpreadPointerX(240.0f, 0.0f, 240.0f, false), 240.0f);
}

TEST(MenuWorld, ItemsEntryDissolvesThePlayerAndReturnsThroughTheOrb) {
    const int     saved_loop_mode = PortTownLoopMode;
    CMenuKeyFunc *saved_keys = MenuCommonInfo;
    CMenuKeyFunc  keys;
    PortTownLoopMode = EDIT_LOOP_WALK_MENU;
    MenuCommonInfo = &keys;
    keys.now_mode = MENU_MODE_ITEM;

    MENU_INIT_ARG arg{};
    arg.open_type = MENU_OPEN_MAIN_TOWN;
    menuworld::MenuOpening(&arg);
    MenuMainFrameModeSet(MENU_MAIN_FRAME_OPEN, true);
    for (int i = 0; i < 40 && GetMenuMainFrameEndFlag() == 0; ++i) {
        MenuMainFrameStep();
    }
    ASSERT_NE(GetMenuMainFrameEndFlag(), 0);

    // The orb closes into Items, dissolving the player out of the captured world as it goes.
    menuworld::ItemOpening();
    EXPECT_EQ(menuworld::PlayerDissolveAlpha(), 128);
    float last_x = GetMenuMainFrameLeftTopPos(0)[0];
    int   last_alpha = menuworld::PlayerDissolveAlpha();
    bool  ended = false;
    for (int i = 0; i < 30 && !ended; ++i) {
        MenuMainFrameStep();
        const float x = GetMenuMainFrameLeftTopPos(0)[0];
        const int   alpha = menuworld::PlayerDissolveAlpha();
        EXPECT_LE(x, last_x);
        EXPECT_LE(alpha, last_alpha);
        last_x = x;
        last_alpha = alpha;
        ended = GetMenuMainFrameEndFlag() != 0 && std::fabs(x + 269.0f) <= 1.0f;
    }
    EXPECT_TRUE(ended);
    EXPECT_NEAR(last_x, -269.0f, 1.0f);
    EXPECT_EQ(menuworld::PlayerDissolveAlpha(), 0);

    // Reopening Items from a sub page leaves the closed orb where it is.
    menuworld::ItemOpening();
    EXPECT_EQ(menuworld::PlayerDissolveAlpha(), 0);
    const float closed_x = GetMenuMainFrameLeftTopPos(0)[0];
    MenuMainFrameStep();
    EXPECT_FLOAT_EQ(GetMenuMainFrameLeftTopPos(0)[0], closed_x);

    // Leaving Items slides the orb back open to the main menu.
    MenuMainFrameModeSet(MENU_MAIN_FRAME_SLIDE_BACK, true);
    last_x = GetMenuMainFrameLeftTopPos(0)[0];
    ended = false;
    for (int i = 0; i < 30 && !ended; ++i) {
        MenuMainFrameStep();
        const float x = GetMenuMainFrameLeftTopPos(0)[0];
        EXPECT_GE(x, last_x);
        last_x = x;
        ended = GetMenuMainFrameEndFlag() != 0;
    }
    EXPECT_TRUE(ended);
    EXPECT_NEAR(last_x, 0.0f, 1.0f);

    // The returned orb can close into Items again.
    menuworld::ItemOpening();
    EXPECT_EQ(menuworld::PlayerDissolveAlpha(), 128);

    menuworld::MenuClosed();
    MenuCommonInfo = saved_keys;
    PortTownLoopMode = saved_loop_mode;
}

TEST(MenuWorld, ItemPanelsKeepTheirSidesThroughoutEntryAndExit) {
    const int saved_width = mgScreenWidth;
    mgScreenWidth = 512;
    CMenuPosDataForm      board{};
    CMenuPosDataForm      character{};
    CMenuPosDataForm      money{};
    CMenuPosDataForm      auxiliary{};
    MENU_FORM_ACTION_MOVE board_move{};
    MENU_FORM_ACTION_MOVE character_move{};
    MENU_FORM_ACTION_MOVE auxiliary_move{};
    MENU_FORM_ACTION      board_action{};
    MENU_FORM_ACTION      character_action{};
    MENU_FORM_ACTION      auxiliary_action{};
    std::memcpy(board_action.name, "\x92\x86\x82\xD6", 5);
    std::memcpy(character_action.name, "\x92\x86\x82\xD6", 5);
    std::memcpy(auxiliary_action.name, "\x92\x86\x82\xD6", 5);
    board_move.x = 226.0f;
    character_move.x = 7.0f;
    auxiliary_move.x = 320.0f;
    board_action.move = &board_move;
    character_action.move = &character_move;
    auxiliary_action.move = &auxiliary_move;
    board.action = &board_action;
    board.action_num = 1;
    character.action = &character_action;
    character.action_num = 1;
    auxiliary.action = &auxiliary_action;
    auxiliary.action_num = 1;

    auto *saved_board = class_menu_item_info.item_board_form;
    auto *saved_money = class_menu_item_info.money_form;
    auto *saved_view = class_menu_item_info.view_form[0];
    class_menu_item_info.item_board_form = &board;
    class_menu_item_info.money_form = &money;
    class_menu_item_info.view_form[0] = &character;

    for (float x : {-260.0f, -80.0f, 7.0f, 226.0f, 470.0f, 530.0f}) {
        board.x = x;
        character.x = x;
        money.x = x;
        auxiliary.x = x;
        EXPECT_FLOAT_EQ(menuworld::ItemPanelSplit(&board), 224.0f);
        EXPECT_EQ(menuworld::ItemPanelSide(board, 224.0f), 1);
        EXPECT_EQ(menuworld::ItemPanelSide(character, 224.0f), -1);
        EXPECT_EQ(menuworld::ItemPanelSide(money, 224.0f), 1);
        EXPECT_EQ(menuworld::ItemPanelSide(auxiliary, 224.0f), 1);
    }

    class_menu_item_info.item_board_form = saved_board;
    class_menu_item_info.money_form = saved_money;
    class_menu_item_info.view_form[0] = saved_view;
    mgScreenWidth = saved_width;
}

// The cursor's shift starts at the left panels' shift, ends at the right's, and eases across the flip between them.
TEST(MenuWorld, CursorShiftEasesFromTheLeftPanelsToTheRightPanels) {
    const int saved_width = mgScreenWidth;
    mgScreenWidth = 512;
    CMenuPosDataForm      board{};
    MENU_FORM_ACTION_MOVE board_move{};
    MENU_FORM_ACTION      board_action{};
    std::memcpy(board_action.name, "\x92\x86\x82\xD6", 5);
    board_move.x = 226.0f;
    board_action.move = &board_move;
    board.action = &board_action;
    board.action_num = 1;

    auto *saved_board = class_menu_item_info.item_board_form;
    class_menu_item_info.item_board_form = &board;

    const float left = menuworld::CursorShift(0.0f);
    EXPECT_FLOAT_EQ(menuworld::CursorShift(184.0f), left);
    EXPECT_FLOAT_EQ(menuworld::CursorShift(204.0f), 0.0f);
    EXPECT_FLOAT_EQ(menuworld::CursorShift(224.0f), -left);
    EXPECT_FLOAT_EQ(menuworld::CursorShift(400.0f), -left);
    EXPECT_NEAR(menuworld::CursorShift(194.0f), left * 0.5f, 1e-4f);

    class_menu_item_info.item_board_form = saved_board;
    mgScreenWidth = saved_width;
}

// The build-up list's hand sits near the split, but moves with the selection's panels like the pointer, not the eased shift.
TEST(MenuWorld, BuildUpHandTakesTheSelectionsSide) {
    const int saved_width = mgScreenWidth;
    mgScreenWidth = 512;
    auto      &menu = class_menu_item_info;
    const auto saved_mode = menu.mode;
    const auto saved_ask = menu.ask_para.ask_mode;
    const auto saved_key = menu.key_arg_no;
    menu.mode = MENU_ASK_MODE_EXTEND;
    menu.ask_para.ask_mode = MENU_ITEM_EXTEND_BUILD_UP;

    menu.key_arg_no = ITEM_MENU_PANEL_WEAPON;
    EXPECT_FLOAT_EQ(menuworld::CursorFrameShift(), menuworld::CursorShift(0.0f));
    menu.key_arg_no = ITEM_MENU_PANEL_BAG;
    EXPECT_FLOAT_EQ(menuworld::CursorFrameShift(), menuworld::CursorShift(400.0f));

    menu.mode = saved_mode;
    menu.ask_para.ask_mode = saved_ask;
    menu.key_arg_no = saved_key;
    mgScreenWidth = saved_width;
}

// The debug item browser keeps the frame's layout: the Item page's anchor is not applied and the menu camera stays.
TEST(MenuWorld, DebugItemBrowserIgnoresTheSpread) {
    const int saved_debug = menu_debug_flag;
    menu_debug_flag = 1;
    {
        const gfx::UiAnchor            before = gfx::CurrentUiAnchor();
        const menuworld::ItemDrawScope scope;
        EXPECT_EQ(gfx::CurrentUiAnchor().left_until, before.left_until);
        EXPECT_EQ(gfx::CurrentUiAnchor().right_from, before.right_from);
    }
    EXPECT_FALSE(menuworld::ViewMenuCharacter());
    menu_debug_flag = saved_debug;
}

TEST(MenuWorld, ReturningMenuChromeKeepsCanonicalCoordinates) {
    CMenuPosDataForm form{};
    for (const char *name : {"areaboard", "timeboard", "msg1", "mi00", "mi0", "mi2", "mi9"}) {
        form.name = const_cast<char *>(name);
        EXPECT_TRUE(menuworld::RootChromeUnanchored(form)) << name;
    }
    for (const char *name : {"itembrd", "moneybrd", "form_view00", "msg0", "cursor0"}) {
        form.name = const_cast<char *>(name);
        EXPECT_FALSE(menuworld::RootChromeUnanchored(form)) << name;
    }
}

TEST(MenuCharacterLayout, EnglishPalCentralBackingMatchesTheOtherPalBoards) {
    MENUFORMPARTS_TYPE parts[3]{};
    parts[0].name = const_cast<char *>("fcb1");
    parts[0].x = 178.0f;
    parts[0].y = 158.0f;
    parts[0].w = 100.0f;
    parts[0].h = 100.0f;
    parts[1].name = const_cast<char *>("fc1");
    parts[1].y = 181.0f;
    parts[1].h = 112.0f;
    parts[2].name = const_cast<char *>("fcb0");
    parts[2].h = 121.0f;
    CMenuPosDataForm form{};
    form.name = const_cast<char *>("chr_bg");
    form.parts = parts;
    form.parts_num = 3;
    MenuAlignCharacterSlot(form);
    EXPECT_FLOAT_EQ(parts[0].x, 178.0f);
    EXPECT_FLOAT_EQ(parts[0].y, 181.0f);
    EXPECT_FLOAT_EQ(parts[0].w, 100.0f);
    EXPECT_FLOAT_EQ(parts[0].h, 121.0f);
    EXPECT_FLOAT_EQ(parts[1].h, 112.0f);
    MenuAlignCharacterSlot(form);
    EXPECT_FLOAT_EQ(parts[0].y, 181.0f);
    EXPECT_FLOAT_EQ(parts[0].h, 121.0f);

    // The Japanese board's portrait and backing both retain their original vertical scale.
    parts[0].y = parts[1].y = 158.0f;
    parts[0].h = 100.0f;
    parts[2].h = 106.0f;
    MenuAlignCharacterSlot(form);
    EXPECT_FLOAT_EQ(parts[0].y, 158.0f);
    EXPECT_FLOAT_EQ(parts[0].h, 100.0f);
}

TEST(MenuWorld, PlayerlessReplayDropsPlayerEffectsShadowsAndTheLastRedMarker) {
    constexpr gfx::InterpKey player = 1;
    constexpr gfx::InterpKey effect = 2;
    constexpr gfx::InterpKey red_marker = 3;
    constexpr gfx::InterpKey map = 4;

    gfx::DisplayList source;
    source.records = {MeshRecordWithKey(player), MeshRecordWithKey(effect), MeshRecordWithKey(red_marker),
                      MeshRecordWithKey(map)};
    source.entries = {MeshOfRecord(0),
                      Draw2DWithKey(menuworld::kPlayerEffectKey),
                      Draw2DWithKey(0),
                      MeshOfRecord(1),
                      MeshOfRecord(2),
                      MeshOfRecord(3),
                      MeshOfRecord(2),
                      MeshOfRecord(2),
                      Draw2DWithKey(0)};
    menuworld::PlayerlessFilter filter;
    filter.keys = {player, effect};
    filter.trailing_run_keys = {red_marker};
    // Skinned meshes index palettes during replay, so the replay must carry them.
    source.palettes.resize(2);
    source.palettes[1].bones[0][0][3] = 5.0f;

    gfx::DisplayList replay;
    menuworld::BuildPlayerlessReplay(source, filter, 9, replay);
    // The clean pass keeps the first red marker, which is not in the last run, then the copy and the whole frame.
    EXPECT_EQ(Kinds(replay), "DMMDK"
                             "MDDMMMMMD");
    EXPECT_EQ(std::get<gfx::detail::MeshEntry>(replay.entries[1]).record, 2u);
    EXPECT_EQ(std::get<gfx::detail::MeshEntry>(replay.entries[2]).record, 3u);
    ASSERT_EQ(replay.palettes.size(), source.palettes.size());
    EXPECT_FLOAT_EQ(replay.palettes[1].bones[0][0][3], 5.0f);

    // Without a trailing run both red runs stay in the clean pass.
    filter.trailing_run_keys.clear();
    gfx::DisplayList kept;
    menuworld::BuildPlayerlessReplay(source, filter, 9, kept);
    EXPECT_EQ(Kinds(kept), "DMMMMDK"
                           "MDDMMMMMD");
}

TEST(MenuWorld, PlayerlessReplayDropsOutlineCompositesWithoutOutlineDraws) {
    constexpr gfx::InterpKey player = 1;
    constexpr gfx::TextureHandle outline = 7;

    gfx::DisplayList source;
    source.records = {MeshRecordWithKey(player), MeshRecordWithKey(0)};
    gfx::detail::TargetEntry to_outline{outline};
    gfx::detail::TargetEntry to_main{gfx::kMainTarget};
    source.entries = {to_outline,
                      gfx::detail::ClearEntry{},
                      MeshOfRecord(0),
                      to_main,
                      Draw2DWithKey(0, outline),
                      to_outline,
                      gfx::detail::ClearEntry{},
                      MeshOfRecord(1),
                      to_main,
                      Draw2DWithKey(0, outline)};
    menuworld::PlayerlessFilter filter;
    filter.keys = {player};
    filter.outline_target = outline;

    gfx::DisplayList replay;
    menuworld::BuildPlayerlessReplay(source, filter, 9, replay);
    // The first composite samples an outline that only the player drew into, so it goes; the second samples a
    // world mesh's outline and stays.
    EXPECT_EQ(Kinds(replay), "TCTTCMTD"
                             "K"
                             "TCMTDTCMTD");
}

TEST(MenuWorld, PlayerEffectScopeTagsOnlyTheDungeonPauseFrame) {
    const int           saved_loop = PortLoopNo;
    const DNG_STATUS    saved_status = DngStatus;
    const gfx::Interp2D saved_interp = gfx::CurrentInterp2D();
    menuworld::MenuClosed();

    PortLoopNo = LOOP_DUNGEON;
    DngStatus.mode = DNG_STATUS_MENU;
    EXPECT_TRUE(menuworld::PausingDungeonFrame());
    {
        const menuworld::PlayerEffectScope player_scope(true);
        EXPECT_EQ(gfx::CurrentInterp2D().key, menuworld::kPlayerEffectKey);
    }
    {
        const menuworld::PlayerEffectScope world_scope(false);
        EXPECT_EQ(gfx::CurrentInterp2D().key, saved_interp.key);
    }

    DngStatus.mode = DNG_STATUS_FIELD;
    EXPECT_FALSE(menuworld::PausingDungeonFrame());
    {
        const menuworld::PlayerEffectScope field_scope(true);
        EXPECT_EQ(gfx::CurrentInterp2D().key, saved_interp.key);
    }

    DngStatus.mode = DNG_STATUS_MENU;
    PortLoopNo = LOOP_EDIT;
    EXPECT_FALSE(menuworld::PausingDungeonFrame());
    {
        const menuworld::PlayerEffectScope town_scope(true);
        EXPECT_EQ(gfx::CurrentInterp2D().key, saved_interp.key);
    }

    PortLoopNo = saved_loop;
    DngStatus = saved_status;
}
