#include <gtest/gtest.h>

#include <cmath>

#include "object/menu/menu_presentation.hpp"

TEST(MenuTileTest, GridPreservesPhaseAndCoversBothAxesAtExtremeExtents) {
    for (int tile : {64, 128, 256}) {
        for (float phase : {-255.0f, -127.5f, -1.0f, 40.5f}) {
            for (auto bounds : {
                     std::pair{-426.667f, 938.667f},
                     std::pair{-1040.0f,  1520.0f },
                     std::pair{0.0f,      512.0f  }
            }) {
                const float first = MenuTilePatternFirst(phase, tile, std::floor(bounds.first) - 1);
                const int   count = MenuTilePatternCount(first, tile, std::ceil(bounds.second));
                EXPECT_LE(static_cast<int>(first), bounds.first);
                EXPECT_GE(static_cast<int>(first + (count - 1) * tile) + tile, bounds.second);
                const float steps = (phase - first) / tile;
                EXPECT_FLOAT_EQ(steps, std::round(steps));
            }
        }
    }
}

TEST(MenuTileTest, FourThreeVisibleColumnsRetainTheirQuantizedPhase) {
    for (float phase : {-255.0f, -127.5f, -1.0f, 40.5f}) {
        const float first = MenuTilePatternFirst(phase, 128, -1);
        const int   count = MenuTilePatternCount(first, 128, 512);
        for (int n = -8; n < 8; ++n) {
            const int expected = static_cast<int>(phase + n * 128);
            if (expected < 0 || expected >= 512) {
                continue;
            }
            bool found = false;
            for (int i = 0; i < count; ++i) {
                found |= static_cast<int>(first + i * 128) == expected;
            }
            EXPECT_TRUE(found) << phase << " " << expected;
        }
    }
}

TEST(MenuTileTest, ZeroSizeProducesNoTiles) {
    EXPECT_EQ(MenuTilePatternCount(-256, 0, 768), 0);
    EXPECT_FLOAT_EQ(MenuTilePatternFirst(-100, 0, -426), -100);
}
