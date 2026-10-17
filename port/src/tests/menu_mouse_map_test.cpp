#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstddef>
#include <string>

#include "dngfloor.hpp"
#include "dngmenu.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse_floor.hpp"
#include "menu_mouse_map.hpp"
#include "menu_mouse_retail.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menumain.hpp"
#include "menumap.hpp"
#include "menuop.hpp"
#include "menusys.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "platform/clock.hpp"
#include "platform/input.hpp"
#include "save_slots.hpp"

namespace {
// Retail constructs these menus in their own units; the adapters read only plain fields.
template <class T>
struct Blank {
    alignas(T) std::byte storage[sizeof(T)] {};

    T *operator->() { return reinterpret_cast<T *>(storage); }

    T *get() { return reinterpret_cast<T *>(storage); }
};

GLID_INFO Room(int x, int y, int floor_id, int order, std::array<short, 4> keys = {-1, -1, -1, -1},
               int selectable = 1) {
    GLID_INFO cell{};
    cell.type = GLID_TYPE_ROOM;
    cell.x = x;
    cell.y = y;
    cell.room.floor_id = floor_id;
    cell.room.order = order;
    cell.room.selectable = selectable;
    for (int i = 0; i < GLID_DIR_NUM; ++i) {
        cell.room.key_room[i] = keys[i];
    }
    return cell;
}

// Placed help lines led by button symbols, as the tree map lays them out, and one plain line.
void HelpLines(ClsMes &message, int left_x, int left_y, int right_x, int right_y, int left_symbol = 6,
               int right_symbol = 8) {
    message.font_h = 24;
    message.font_w = 15;
    message.page_top = 0;
    message.reveal_num = 5;
    message.draw_off_x = message.draw_off_y = 0;
    message.tbl[0] = {.code = u16(MES_CODE_GAIJI + left_symbol), .x = 0, .y = 0};
    message.tbl[1] = {.code = 'M', .x = 22, .y = 0};
    message.tbl[2] = {.code = u16(MES_CODE_GAIJI + right_symbol), .x = 0, .y = 24};
    message.tbl[3] = {.code = 'C', .x = 60, .y = 24};
    message.tbl[4] = {.code = 'n', .x = 0, .y = 48};
    for (int line = 0; line < 3; ++line) {
        message.line_shade[line] = MES_SHADE_AUTO;
        message.line_pos_on[line] = line < 2;
    }
    message.line_pos[0][0] = left_x;
    message.line_pos[0][1] = left_y;
    message.line_pos[1][0] = right_x;
    message.line_pos[1][1] = right_y;
}

TEST(MenuMouseMap, WorldMapMarksCoverOnlyUnlockedAreasAndKeepTheirNeighboursApart) {
    WMAP_AREA_DATA areas[4]{};
    areas[0].enable = true;
    areas[1] = {.x = 305, .y = 149, .enable = true};
    areas[2] = {.x = 370, .y = 184, .enable = true};
    areas[3] = {.x = 200, .y = 300, .enable = false};
    const MenuMouseRect name{309, 128, 180, 46};
    const auto          rows = MenuMouseWorldMapRows(areas, name);
    ASSERT_EQ(rows.size(), 5u);
    EXPECT_EQ(rows[0].w, 0);
    EXPECT_EQ(rows[3].w, 0);
    EXPECT_EQ(MenuMouseHit(rows, 305, 149), 1);
    EXPECT_EQ(MenuMouseHit(rows, 286, 126), 1);
    EXPECT_EQ(MenuMouseHit(rows, 370, 200), 2);
    EXPECT_EQ(MenuMouseHit(rows, 200, 300), -1);
    EXPECT_EQ(MenuMouseHit(rows, 0, 0), -1);
    // The nearest retail pair is 74 units apart; their marks do not meet.
    EXPECT_EQ(MenuMouseHit(MenuMouseWorldMapRows(areas, {}), 337, 166), -1);
    // A mark in front of the name frame keeps its own area.
    EXPECT_EQ(MenuMouseHit(rows, 360, 170), 2);
    EXPECT_EQ(MenuMouseHit(rows, 450, 140), 4);
}

TEST(MenuMouseMap, FloorRectsFollowTheDrawnRoomPictureAndItsCull) {
    auto room = Room(0, 0, 1, 0);
    room.room.offset_x = 7;
    room.room.offset_y = -3;
    auto rect = MenuMouseFloorRect(room, 100, 200, 0, 512, 480);
    EXPECT_FLOAT_EQ(rect.x, 70);
    EXPECT_FLOAT_EQ(rect.y, 158);
    EXPECT_FLOAT_EQ(rect.w, 96);
    EXPECT_FLOAT_EQ(rect.h, 66);
    rect = MenuMouseFloorRect(room, 100, 200, 5, 512, 480);
    EXPECT_FLOAT_EQ(rect.w, 100);
    EXPECT_FLOAT_EQ(rect.h, 68);
    room.room.visited = 1;
    rect = MenuMouseFloorRect(room, 100, 200, 0, 512, 480);
    EXPECT_FLOAT_EQ(rect.x, 77);
    EXPECT_FLOAT_EQ(rect.y, 155);
    room.room.flag = DNGMAP_ROOM_FLAG_ROOM | DNGMAP_ROOM_FLAG_SUB;
    rect = MenuMouseFloorRect(room, 100, 200, 0, 512, 480);
    EXPECT_FLOAT_EQ(rect.w, 96);
    EXPECT_FLOAT_EQ(rect.h, 96);
    // DrawRoomOne skips a room whose put position is past the right edge plus 20 or the bottom plus 30.
    EXPECT_GT(MenuMouseFloorRect(room, 532, 200, 0, 512, 480).w, 0);
    EXPECT_EQ(MenuMouseFloorRect(room, 533, 200, 0, 512, 480).w, 0);
    EXPECT_EQ(MenuMouseFloorRect(room, 100, 511, 0, 512, 480).w, 0);
    EXPECT_GT(MenuMouseFloorRect(room, 600, 200, 0, 597, 480).w, 0);
}

// Rainbow Butterfly Wood forks at floor 8: floors 9-12 go down to a side floor, 13-15 right to the boss.
std::array<GLID_INFO, 8> RainbowFork() {
    return {Room(7, 0, 7, 7, {-1, -1, 5, 8}), Room(8, 0, 8, 8, {-1, 9, 7, 13}), Room(8, 4, 9, 9, {8, 10, 8, 10}), Room(9, 7, 10, 10, {9, 11, 9, 11}), Room(9, 0, 13, 9, {8, 14, 8, 14}), Room(11, 0, 14, 10, {13, 15, 13, 15}), Room(12, 0, 15, 11, {14, -1, 14, -1}, 0), {}};
}

TEST(MenuMouseMap, WheelFollowsTheKeyNeighboursAndKeepsToTheRightBranchAtAFork) {
    auto cells = RainbowFork();
    auto at = [&](int floor_id) -> GLID_INFO * {
        for (auto &cell : cells) {
            if (cell.type == GLID_TYPE_ROOM && cell.room.floor_id == floor_id) {
                return &cell;
            }
        }
        return nullptr;
    };
    EXPECT_EQ(MenuMouseFloorStep(cells, at(7), 1), at(8));
    EXPECT_EQ(MenuMouseFloorStep(cells, at(8), 1), at(13));
    EXPECT_EQ(MenuMouseFloorStep(cells, at(8), 2), at(14));
    // Floor 15 cannot take the cursor yet, so the wheel stops at 14.
    EXPECT_EQ(MenuMouseFloorStep(cells, at(8), 3), at(14));
    EXPECT_EQ(MenuMouseFloorStep(cells, at(9), 1), at(10));
    EXPECT_EQ(MenuMouseFloorStep(cells, at(9), -1), at(8));
    EXPECT_EQ(MenuMouseFloorStep(cells, at(10), -2), at(8));
    EXPECT_EQ(MenuMouseFloorStep(cells, at(14), -3), at(7));
    EXPECT_EQ(MenuMouseFloorStep(cells, at(10), 0), at(10));
    EXPECT_EQ(MenuMouseFloorStep(cells, nullptr, 1), nullptr);
}

TEST(MenuMouseMap, HelpLabelsNameTheButtonTheirSymbolShows) {
    const int language = LanguageCode;
    ClsMes    message;
    HelpLines(message, 67, 430, 330, 430);
    LanguageCode = 1;
    EXPECT_EQ(MenuMouseLabelButton(message, 0), PAD_CROSS);
    EXPECT_EQ(MenuMouseLabelButton(message, 1), PAD_CIRCLE);
    EXPECT_EQ(MenuMouseLabelButton(message, 2), 0);
    LanguageCode = 0;
    EXPECT_EQ(MenuMouseLabelButton(message, 0), PAD_CIRCLE);
    EXPECT_EQ(MenuMouseLabelButton(message, 1), PAD_CROSS);
    message.tbl[0].code = MES_CODE_GAIJI + 9;
    message.tbl[2].code = MES_CODE_GAIJI + 7;
    EXPECT_EQ(MenuMouseLabelButton(message, 0), PAD_SQUARE);
    EXPECT_EQ(MenuMouseLabelButton(message, 1), PAD_TRIANGLE);
    LanguageCode = language;
    const auto back = MenuMouseLabelRect(message, 1);
    EXPECT_FLOAT_EQ(back.x, 328);
    EXPECT_FLOAT_EQ(back.y, 424);
    EXPECT_FLOAT_EQ(back.w, 79);
    EXPECT_FLOAT_EQ(back.h, 36);
    message.draw_off_x = 5;
    message.draw_off_y = -2;
    EXPECT_FLOAT_EQ(MenuMouseLabelRect(message, 1).x, 333);
    EXPECT_FLOAT_EQ(MenuMouseLabelRect(message, 1).y, 422);
    EXPECT_EQ(MenuMouseLabelRect(message, 2).w, 0);
    EXPECT_EQ(MenuMouseLabelRect(message, 3).w, 0);
    // A hidden line is not drawn, so it names no button.
    message.line_shade[1] = MES_SHADE_HIDDEN;
    EXPECT_EQ(MenuMouseLabelButton(message, 1), 0);
    EXPECT_EQ(MenuMouseLabelRect(message, 1).w, 0);
}

TEST(MenuMouseMap, JapaneseClicksConfirmWithCircleAndCancelWithCross) {
    EXPECT_EQ(MenuMouseLanguageButtons(PAD_CROSS, 1), PAD_CROSS);
    EXPECT_EQ(MenuMouseLanguageButtons(PAD_CIRCLE, 1), PAD_CIRCLE);
    EXPECT_EQ(MenuMouseLanguageButtons(PAD_CROSS, 0), PAD_CIRCLE);
    EXPECT_EQ(MenuMouseLanguageButtons(PAD_CIRCLE | PAD_DOWN, 0), PAD_CROSS | PAD_DOWN);
    EXPECT_EQ(MenuMouseLanguageButtons(PAD_CROSS | PAD_CIRCLE, 0), PAD_CROSS | PAD_CIRCLE);
    EXPECT_EQ(MenuMouseLanguageButtons(PAD_DOWN, 0), PAD_DOWN);
}

class MenuMouseMapInput : public testing::TestWithParam<int> {
protected:
    int           width = mgScreenWidth, height = mgScreenHeight, language = LanguageCode;
    CMenuKeyFunc *keys = MenuCommonInfo;
    CMenuKeyFunc  menu;
    CDC2Mes      *messages[9]{};

    void SetUp() override {
        mgScreenWidth = 512;
        mgScreenHeight = 480;
        LanguageCode = GetParam();
        InputResetBindings();
        InputSetScriptedDevices({});
        MenuMouseEnable(false);
        MenuMouseTake();
        GamePad__2.key_lock = 0;
        GamePad__2.pad[0].button = GamePad__2.previous_pad[0].button = 0;
        ClockSetUnbounded(true);
        menu.open_type = MENU_OPEN_MAIN_TOWN;
        MenuCommonInfo = &menu;
        std::copy(std::begin(MenuDCMsg), std::end(MenuDCMsg), messages);
        std::fill(std::begin(MenuDCMsg), std::end(MenuDCMsg), nullptr);
    }

    void TearDown() override {
        InputSetScriptedDevices({});
        MenuMouseEnable(false);
        MenuMouseTake();
        InputSetMenuMouse(false);
        mgScreenWidth = width;
        mgScreenHeight = height;
        LanguageCode = language;
        MenuCommonInfo = keys;
        std::copy(std::begin(messages), std::end(messages), MenuDCMsg);
        MouseWorldMap = nullptr;
        MouseWorldAreas = nullptr;
        MouseWorldAreaCount = 0;
        MouseWorldMapType = WORLD_MAP_MENU_WORLD;
        MouseDngMap = nullptr;
        MouseTree = nullptr;
        MouseFloorInfoView = false;
        MouseFloorAsk = DNG_TREE_MAP_ASK_NONE;
        InputResetBindings();
    }

    static void Tick() { mgEndFrame(nullptr); }

    // Moves the pointer, which starts at (256, 240), by logical units this tick.
    static void Move(float dx, float dy) { InputSetScriptedDevices({.mouse_dx = dx, .mouse_dy = dy}); }

    static void Click(int buttons = 1) { InputSetScriptedDevices({.mouse_buttons = std::uint32_t(buttons)}); }

    static void Release() {
        InputSetScriptedDevices({});
        MenuMouseTake();
        Tick();
    }

    // Draws a Yes/No question with Yes under the pointer's start for longer than the confirmation
    // delay, then clicks there; gives the retail menu action the adapter leaves for that click.
    template <class Adapter>
    static int ClickQuestion(Adapter adapter, int buttons) {
        static const char       owner = 0;
        constexpr MenuMouseRect choices[] = {
            {240, 230, 40, 30},
            {300, 230, 40, 30}
        };
        for (int tick = 0; tick < 8; ++tick) {
            MenuMouseNoteChoices(&owner, 7, choices, 0, true);
            InputSetScriptedDevices({});
            adapter();
            Tick();
        }
        MenuMouseNoteChoices(&owner, 7, choices, 0, true);
        InputSetScriptedDevices({.mouse_buttons = std::uint32_t(buttons), .mouse_dx = 1});
        adapter();
        const int action = MenuCheckPushButton();
        Tick();
        return action;
    }
};

INSTANTIATE_TEST_SUITE_P(Languages, MenuMouseMapInput, testing::Values(1, 0),
                         [](const auto &info) { return info.param ? std::string("English") : std::string("Japanese"); });

struct WorldMap {
    WMAP_AREA_DATA       areas[4]{};
    mgCTexture           cursor;
    Blank<CWorldMapMenu> map;

    WorldMap() {
        areas[1] = {.x = 150, .y = 100, .enable = true};
        areas[2] = {.x = 296, .y = 250, .enable = true};
        areas[3] = {.x = 200, .y = 240, .enable = false};
        map->mode = WORLD_MAP_MODE_RUN;
        map->step = WORLD_MAP_STEP_AREA;
        map->cursor_tex = &cursor;
        map->cursor_view = true;
        map->area_no = 1;
        MouseWorldMap = map.get();
        MouseWorldMapType = WORLD_MAP_MENU_WORLD;
        MouseWorldAreas = areas;
        MouseWorldAreaCount = 4;
    }
};

TEST_P(MenuMouseMapInput, WorldMapHoverSelectsAnAreaAndClickConfirmsOnlyOnAMark) {
    WorldMap world;
    auto    &map = world.map;
    MenuMouseEnable(true);

    Move(40, 10);
    EXPECT_TRUE(MenuMouseWorldMap());
    EXPECT_EQ(map->area_no, 2);
    EXPECT_EQ(MenuCheckPushButton(), 0);

    Tick();
    Click();
    MenuMouseWorldMap();
    EXPECT_EQ(map->area_no, 2);
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_DECIDE);

    Tick();
    Move(-96, -10);
    MenuMouseWorldMap();
    EXPECT_EQ(map->area_no, 2);
    Tick();
    InputSetScriptedDevices({.mouse_buttons = 1, .mouse_wheel = -1});
    MenuMouseWorldMap();
    EXPECT_EQ(map->area_no, 2);
    EXPECT_EQ(MenuCheckPushButton(), 0);

    Tick();
    Click(2);
    MenuMouseWorldMap();
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_CANCEL);
}

TEST_P(MenuMouseMapInput, WorldMapNameFrameConfirmsTheCurrentArea) {
    WorldMap world;
    CDC2Mes  name;
    name.line_pos[0][0] = 366;
    name.line_pos[0][1] = 302;
    name.line_w[0] = 80;
    MenuDCMsg[4] = &name;
    world.map->name_view = true;
    MenuMouseEnable(true);
    // The frame spans (350, 290)-(460, 336), clear of every mark; the pointer moves into it at (400, 310).
    InputSetScriptedDevices({.mouse_buttons = 1, .mouse_dx = 144, .mouse_dy = 70});
    MenuMouseWorldMap();
    EXPECT_EQ(world.map->area_no, 1);
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_DECIDE);
}

TEST_P(MenuMouseMapInput, WorldMapLeavesOtherStepsAndViewsToTheSharedClick) {
    WorldMap world;
    auto    &map = world.map;
    MenuMouseEnable(true);
    auto check = [&](auto change, auto undo) {
        change();
        Tick();
        Move(40, 10);
        EXPECT_FALSE(MenuMouseWorldMap());
        EXPECT_EQ(map->area_no, 1);
        Tick();
        Move(-40, -10);
        MenuMouseWorldMap();
        undo();
    };
    check([&] { map->view_only = true; }, [&] { map->view_only = false; });
    check([&] { menu.open_type = MENU_OPEN_WORLD_MOVE; }, [&] { menu.open_type = MENU_OPEN_MAIN_TOWN; });
    check([&] { map->mode = WORLD_MAP_MODE_OPEN; }, [&] { map->mode = WORLD_MAP_MODE_RUN; });
    check([&] { map->step = WORLD_MAP_STEP_POS; }, [&] { map->step = WORLD_MAP_STEP_AREA; });
    check([&] { map->cursor_tex = nullptr; }, [&] { map->cursor_tex = &world.cursor; });
}

struct FloorMap {
    std::array<GLID_INFO, 8> cells = RainbowFork();
    Blank<CDngFloorManager>  manager;
    Blank<CDngFreeMap>       board;
    Blank<CMenuTreeMap>      tree;

    GLID_INFO *At(int floor_id) {
        for (auto &cell : cells) {
            if (cell.type == GLID_TYPE_ROOM && cell.room.floor_id == floor_id) {
                return &cell;
            }
        }
        return nullptr;
    }

    FloorMap() {
        manager->glid_info = cells.data();
        manager->glid_num = int(cells.size());
        board->floor_manager = manager.get();
        // Floor 8 (column 8, row 0) puts at (186, 120) and floor 13 (column 9) at (238, 120).
        board->pos_x = -230;
        board->pos_y = 120;
        tree->mode = MENU_ASK_MODE_NONE;
        tree->key_arg_no = DNG_TREE_MAP_SCREEN_MAP;
        tree->select_glid = At(8);
        tree->help_view = true;
        MouseDngMap = board.get();
        MouseTree = tree.get();
        MouseTreeMode = DNG_TREE_MODE_MAP;
        MouseWorldMapType = WORLD_MAP_MENU_TREE_MAP;
    }
};

TEST_P(MenuMouseMapInput, FloorHoverClickAndWheelUseTheRetailRoomTransition) {
    FloorMap floor;
    MenuMouseEnable(true);

    // Floor 13 is drawn at (208, 78)-(304, 144); the pointer moves to (256, 110).
    Move(0, -130);
    EXPECT_TRUE(MenuMouseWorldMap());
    EXPECT_TRUE(GamePad__2.Down(PAD_DOWN));
    EXPECT_EQ(floor.manager->GetKeyNextRoom(8, GLID_DIR_DOWN, nullptr), floor.At(13));

    Tick();
    floor.tree->select_glid = floor.At(13);
    Click();
    MenuMouseFloor();
    EXPECT_FALSE(GamePad__2.Down(PAD_DOWN));
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_DECIDE);

    // One notch down follows the Right key to 14; one up returns along the path to 8, not to 9.
    Tick();
    InputSetScriptedDevices({.mouse_wheel = -1});
    MenuMouseFloor();
    EXPECT_TRUE(GamePad__2.Down(PAD_DOWN));
    EXPECT_EQ(floor.manager->GetKeyNextRoom(13, GLID_DIR_DOWN, nullptr), floor.At(14));
    Tick();
    InputSetScriptedDevices({.mouse_wheel = 1});
    MenuMouseFloor();
    EXPECT_EQ(floor.manager->GetKeyNextRoom(13, GLID_DIR_DOWN, nullptr), floor.At(8));

    // An empty click claims nothing; Mouse2 cancels in the language's layout.
    Tick();
    Move(0, 200);
    MenuMouseFloor();
    Tick();
    Click();
    MenuMouseFloor();
    EXPECT_EQ(MenuCheckPushButton(), 0);
    Tick();
    Click(2);
    MenuMouseFloor();
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_CANCEL);
}

TEST_P(MenuMouseMapInput, FloorMapHelpLabelsPressSquareAndTriangle) {
    FloorMap floor;
    CDC2Mes  help;
    // Back to Map (Square) under the pointer's start; Save Progress (Triangle) at the bottom right.
    HelpLines(help, 240, 236, 330, 430, 9, 7);
    MenuDCMsg[6] = &help;
    MenuMouseEnable(true);

    InputSetScriptedDevices({.mouse_buttons = 1, .mouse_dx = 1});
    MenuMouseFloor();
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_SQUARE);
    EXPECT_FALSE(GamePad__2.Down(PAD_DOWN));

    Tick();
    Move(100, 200);
    MenuMouseFloor();
    Tick();
    Click();
    MenuMouseFloor();
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_TRIANGLE);
}

TEST_P(MenuMouseMapInput, FloorInformationActsOnlyOnItsLabels) {
    FloorMap floor;
    floor.tree->key_arg_no = DNG_TREE_MAP_SCREEN_FLOOR;
    MouseFloorInfoView = true;
    MouseFloorAsk = DNG_TREE_MAP_ASK_JUMP;
    CDC2Mes message;
    // Cancel is drawn under the pointer's start at (256, 240); Move is at the bottom left.
    HelpLines(message, 70, 430, 240, 236);
    MenuDCMsg[3] = &message;
    MenuMouseEnable(true);

    InputSetScriptedDevices({.mouse_buttons = 1, .mouse_dx = 1});
    MenuMouseFloor();
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_CANCEL);

    // A click on the panel, as a double click on the room would land, does not travel.
    Tick();
    Move(0, -100);
    MenuMouseFloor();
    Tick();
    Click();
    MenuMouseFloor();
    EXPECT_EQ(MenuCheckPushButton(), 0);

    Tick();
    Move(-170, 300);
    MenuMouseFloor();
    Tick();
    Click();
    MenuMouseFloor();
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_DECIDE);

    Tick();
    Click(2);
    MenuMouseFloor();
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_CANCEL);
}

TEST_P(MenuMouseMapInput, WorldMapPlaceListAndQuestionUseTheLanguageLayout) {
    WorldMap world;
    MenuMouseEnable(true);
    for (const int step : {WORLD_MAP_STEP_POS, WORLD_MAP_STEP_ASK}) {
        world.map->step = step;
        EXPECT_EQ(ClickQuestion(MenuMouseWorldMap, 1), MENU_PUSH_BUTTON_DECIDE) << step;
        EXPECT_EQ(ClickQuestion(MenuMouseWorldMap, 2), MENU_PUSH_BUTTON_CANCEL) << step;
    }
}

TEST_P(MenuMouseMapInput, FloorQuestionsAndOtherFloorScreensUseTheLanguageLayout) {
    FloorMap floor;
    MenuMouseEnable(true);
    // The start, side, boss and exit rooms ask Yes/No without the information panel.
    floor.tree->key_arg_no = DNG_TREE_MAP_SCREEN_FLOOR;
    MouseFloorInfoView = false;
    MouseFloorAsk = DNG_TREE_MAP_ASK_JUMP;
    EXPECT_EQ(ClickQuestion(MenuMouseFloor, 1), MENU_PUSH_BUTTON_DECIDE);
    EXPECT_EQ(ClickQuestion(MenuMouseFloor, 2), MENU_PUSH_BUTTON_CANCEL);
    // The dungeon menu's information-only view and the materials list cancel with Mouse2.
    MouseFloorAsk = DNG_TREE_MAP_ASK_INFO;
    Release();
    Click(2);
    MenuMouseFloor();
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_CANCEL);
    Tick();
    floor.tree->key_arg_no = DNG_TREE_MAP_SCREEN_MATERIALS;
    Release();
    Click(2);
    MenuMouseFloor();
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_CANCEL);
}

// The file list as the floor map's Save Progress opens it, with File 12 selected at (30, 270)-(488, 346).
struct FloorSave {
    decltype(SaveSlots) catalog = SaveSlots;
    CSaveMenuClass   save;
    CMenuPosDataForm form;

    explicit FloorSave(CMenuKeyFunc &menu) {
        SaveSlots.saves.resize(20);
        form.x = 30;
        form.y = 190 - 80 * 10;
        save.list_form = &form;
        save.mode = SAVE_MENU_MODE_SAVE;
        save.CBaseMenuClass::mode = MENU_ASK_MODE_NONE;
        save.page = SAVE_MENU_PAGE_FILE_LIST;
        save.phase = SAVE_LIST_PHASE_SELECT;
        save.select = 11;
        save.top = 10;
        menu.now_mode = MENU_MODE_DNG_TREE_MAP;
        MouseTreeMode = DNG_TREE_MODE_SAVE;
    }

    ~FloorSave() {
        SaveSlots = catalog;
        MouseTreeMode = DNG_TREE_MODE_MAP;
    }
};

TEST_P(MenuMouseMapInput, FloorMapSaveFileListUsesTheLanguageLayout) {
    FloorSave floor(menu);
    MenuMouseEnable(true);
    Move(0, 40);
    MenuMouseSave(floor.save);
    Tick();
    Click();
    MenuMouseSave(floor.save);
    EXPECT_EQ(floor.save.select, 11);
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_DECIDE);
    Release();
    Click(2);
    MenuMouseSave(floor.save);
    EXPECT_EQ(MenuCheckPushButton(), MENU_PUSH_BUTTON_CANCEL);
}

TEST_P(MenuMouseMapInput, FloorMapSaveQuestionUsesTheLanguageLayout) {
    FloorSave floor(menu);
    floor.save.phase = SAVE_LIST_PHASE_CONFIRM_SAVE;
    MenuMouseEnable(true);
    auto adapter = [&] { MenuMouseSave(floor.save); };
    EXPECT_EQ(ClickQuestion(adapter, 1), MENU_PUSH_BUTTON_DECIDE);
    EXPECT_EQ(ClickQuestion(adapter, 2), MENU_PUSH_BUTTON_CANCEL);
}

TEST_P(MenuMouseMapInput, OtherSaveScreensKeepTheSharedClicks) {
    FloorSave floor(menu);
    floor.save.phase = SAVE_LIST_PHASE_CONFIRM_SAVE;
    menu.now_mode = MENU_MODE_SAVE;
    MenuMouseEnable(true);
    auto adapter = [&] { MenuMouseSave(floor.save); };
    // Outside the floor map's handoff, Mouse1 stays the shared Cross in either language.
    EXPECT_EQ(ClickQuestion(adapter, 1), GetParam() ? MENU_PUSH_BUTTON_DECIDE : MENU_PUSH_BUTTON_CANCEL);
}
} // namespace
