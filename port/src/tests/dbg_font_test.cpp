#include <gtest/gtest.h>

#include "dbg_font.hpp"

namespace {

// Texture ids stay -1, so __putc never reloads a sheet and draws through the no-op PC primitive path.
TEST(DbgFont, PrintDirectAdvancesCursorThroughNewlineAndHalfWidthGlyphs) {
    dbgCJISFont font;
    char        format[] = "AB\n%dC";

    font.PrintDirect(10, 20, format, 7);

    // Each half-width glyph advances by char_width - (16 - 8) + 2 = 10; "\n" returns x to 0 and moves y one line.
    EXPECT_EQ(font.x, 20);
    EXPECT_EQ(font.y, 36);
    EXPECT_EQ(font.loaded_texture_id, -1);
}

TEST(DbgFont, EscapeSequenceTogglesBackBox) {
    dbgCJISFont font;
    char        toggle[] = "ESC[$";

    font.PrintDirect(0, 0, toggle);

    EXPECT_NE(font.back_enable, 0);
    EXPECT_EQ(font.x, 0);
    EXPECT_EQ(font.y, 0);

    font.PrintDirect(0, 0, toggle);

    EXPECT_EQ(font.back_enable, 0);
}

TEST(DbgFont, EscapeSequenceTogglesShadow) {
    dbgCJISFont font;
    char        toggle[] = "ESC[#";

    font.PrintDirect(0, 0, toggle);

    EXPECT_NE(font.shadow_enable, 0);
    EXPECT_EQ(font.back_enable, 0);
}

TEST(DbgFont, TrailingShiftJisLeadByteStopsWithoutReadingPastTerminator) {
    dbgCJISFont font;
    char        text[] = "A\x82";

    font.PrintDirect(0, 0, text);

    EXPECT_EQ(font.x, 10);
    EXPECT_EQ(font.y, 0);
    EXPECT_EQ(font.loaded_texture_id, -1);
}

} // namespace
