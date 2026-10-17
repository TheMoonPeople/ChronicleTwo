#include <gtest/gtest.h>

#include <cstdio>
#include <vector>

#include "drawwin.hpp"
#include "menuaqua.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "menusys.hpp"
#include "mg_memory.hpp"
#include "stubs/menuop.hpp"

TEST(MenuOptionStride, MinimapChoicesUseTheirFullPointerWidth) {
    CMenuPosDataManage layout = {};
    CMenuPosDataForm   form = {};
    form.name = const_cast<char *>("Op_Switch");
    form.active = 1;
    MENUFORMPARTS_TYPE parts[OPTION_ITEM_MAX * OPTION_BUTTON_NUM] = {};
    char               names[OPTION_ITEM_MAX * OPTION_BUTTON_NUM][16] = {};
    for (int row = 0; row < OPTION_ITEM_MAX; ++row) {
        for (int choice = 0; choice < OPTION_BUTTON_NUM; ++choice) {
            int index = row * OPTION_BUTTON_NUM + choice;
            std::snprintf(names[index], sizeof names[index], "INDEX%02d%d", row, choice);
            parts[index].name = names[index];
        }
    }
    form.parts = parts;
    form.parts_num = OPTION_ITEM_MAX * OPTION_BUTTON_NUM;
    layout.form = &form;
    layout.form_num = 1;
    MenuPosData = &layout;
    CMenuKeyFunc common = {};
    common.cursor_form = &form;
    common.waku_form = &form;
    MenuCommonInfo = &common;
    SV_CONFIG_OPTION config = {};
    MenuConfigPtr = &config;
    CDC2Mes message;
    MenuDCMsg[2] = &message;
    MenuArg.pack = nullptr;
    MenuArg.open_type = 0;
    int blocks[] = {0, -1};
    for (int selected = 0; selected < OPTION_BUTTON_NUM; ++selected) {
        std::vector<u_long128> storage(4096);
        mgCMemory              memory;
        memory.stSetBuffer(storage.data(), storage.size());
        memory.Alloc(4); // Leave the empty pack header before the menu's local allocations.
        config.map = selected;
        MenuOptionInit(&memory, blocks, 0);
        for (int choice = 0; choice < OPTION_BUTTON_NUM; ++choice) {
            const auto &button = parts[OPTION_ITEM_MINIMAP * OPTION_BUTTON_NUM + choice];
            EXPECT_EQ(button.rgba[0], choice == selected ? 0x80 : 0x40);
        }
    }
    MenuPosData = nullptr;
    MenuCommonInfo = nullptr;
    MenuConfigPtr = nullptr;
    MenuDCMsg[2] = nullptr;
}

TEST(MenuOptionCursor, BottomLimitReachesTheNinthShownRow) {
    // PAL's op_cursorlimmit bottom is 274; the ninth shown row settles at 288.
    EXPECT_EQ(PortOptionCursorBottom(274, 288, 100, 100), 288);
    // While the list scrolls up to it, the row is still 18 below its place.
    EXPECT_EQ(PortOptionCursorBottom(274, 306, 118, 100), 288);
    // Rows that settle above the limit, and the top row scrolling down, keep retail's limit.
    EXPECT_EQ(PortOptionCursorBottom(274, 264, 100, 100), 274);
    EXPECT_EQ(PortOptionCursorBottom(274, 72, 76, 100), 274);
}
