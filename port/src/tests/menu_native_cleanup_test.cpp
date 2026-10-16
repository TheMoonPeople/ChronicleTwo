#include "common.h"

#include <gtest/gtest.h>

#include <array>
#include <cstddef>
#include <cstdint>
#include <cstring>

#include "editmenu.hpp"
#include "editmode.hpp"
#include "menumain.hpp"
#include "menusys.hpp"

int MenuGeoramaPaintSelect(CMenuGeorama *menu, int keys, int pushed);

TEST(MenuNativeCleanup, FusionColorsSupportFloatAlignedDestinationsWithoutOverwritingCanaries) {
    alignas(16) std::array<std::byte, 32> storage;
    storage.fill(std::byte{0xa5});
    auto *color = reinterpret_cast<float *>(storage.data() + sizeof(float));
    ASSERT_NE(reinterpret_cast<std::uintptr_t>(color) % 16, 0u);
    FusionColor(0, 1, color);
    EXPECT_FLOAT_EQ(color[0], 64);
    EXPECT_FLOAT_EQ(color[1], 64);
    EXPECT_FLOAT_EQ(color[2], 64);
    EXPECT_FLOAT_EQ(color[3], 128);
    for (std::size_t index = 0; index < storage.size(); ++index) {
        if (index < 4 || index >= 20) {
            EXPECT_EQ(storage[index], std::byte{0xa5});
        }
    }
    const auto before = storage;
    FusionColor(1, 0, color);
    EXPECT_EQ(storage, before);
    FusionColor(0, 0, nullptr);
    FusionColor(1, 1, color);
    EXPECT_FLOAT_EQ(color[0], 128);
    EXPECT_GT(color[1], 128);
    EXPECT_LT(color[2], 128);
    EXPECT_FLOAT_EQ(color[3], 128);
}

TEST(MenuNativeCleanup, FirstPaintSelectionClosesIntoPaintModeAndReturnedSelectionDoesTheSame) {
    const auto   previous = MenuArg;
    CMenuGeorama menu;
    EXPECT_EQ(menu.paint_return, 1);
    menu.view_mode = GEORAMA_VIEW_PAINT;
    menu.paint_select = 0;
    MenuArg.end_code = -1;
    EXPECT_EQ(MenuGeoramaPaintSelect(&menu, 0, 1), 1);
    EXPECT_EQ(MenuArg.end_code, EDIT_MODE_PAINT);
    EXPECT_FLOAT_EQ(menu.paint_color[3], 1);
    menu.paint_return = 1;
    menu.paint_select = 1;
    MenuArg.end_code = -1;
    EXPECT_EQ(MenuGeoramaPaintSelect(&menu, 0, 8), 1);
    EXPECT_EQ(MenuArg.end_code, EDIT_MODE_PAINT);
    MenuArg = previous;
}

TEST(MenuNativeCleanup, RepaintSelectionAndCancellationPreserveTheirDistinctTransitions) {
    const auto   previous = MenuArg;
    CMenuGeorama menu;
    menu.view_mode = GEORAMA_VIEW_PAINT;
    menu.paint_select = GEORAMA_PENKI_NUM;
    MenuArg.end_code = -1;
    EXPECT_EQ(MenuGeoramaPaintSelect(&menu, 0, 4), 1);
    EXPECT_EQ(MenuArg.end_code, EDIT_MODE_REPAINT);
    menu.paint_select = 0;
    menu.key_arg_no = GEORAMA_VIEW_PAINT + 1;
    MenuArg.end_code = -1;
    EXPECT_EQ(MenuGeoramaPaintSelect(&menu, 0, 2), 0);
    EXPECT_EQ(menu.key_arg_no, 0);
    EXPECT_EQ(MenuArg.end_code, -1);
    menu.paint_return = 0;
    EXPECT_EQ(MenuGeoramaPaintSelect(&menu, 0, 1), 0);
    EXPECT_EQ(MenuArg.end_code, -1);
    MenuArg = previous;
}
