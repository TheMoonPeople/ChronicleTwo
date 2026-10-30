#pragma once

#include "common.h"

/**
 * @file
 * Declares the debug font that prints Shift-JIS text straight to the
 * screen from three glyph-sheet textures.
 */

/**
 *
 * Glyph serial numbers that pick the glyph sheet a character is drawn from.
 *
 */
// clang-format off
enum DbgFontSerno {
    DBG_FONT_SERNO_SHEET_1    = 0x1000, /**< First serial number on the second full-width sheet. */
    DBG_FONT_SERNO_HALF_WIDTH = 0x2000, /**< First serial number on the half-width sheet. */
    DBG_FONT_SERNO_ASCII      = 0x204D, /**< Added to an ASCII code to give the serial number of its half-width glyph. */
    DBG_FONT_SERNO_DAKUTEN    = 0x2134, /**< Half-width voiced-sound mark, merged into the preceding kana. */
    DBG_FONT_SERNO_HANDAKUTEN = 0x2135, /**< Half-width semi-voiced-sound mark, merged into the preceding kana. */
    DBG_FONT_SERNO_UNKNOWN    = 0x227E, /**< Glyph drawn for a half-width character with no mapping. */
    DBG_FONT_SERNO_END        = 0x2285, /**< First serial number past the last glyph; such characters are not drawn. */
};

// clang-format on

/**
 *
 * Index of a glyph sheet in dbgCJISFont's texture tables.
 *
 */
// clang-format off
enum DbgFontSheet {
    DBG_FONT_SHEET_FULL_WIDTH_0 = 0, /**< First full-width (kanji) sheet. */
    DBG_FONT_SHEET_FULL_WIDTH_1 = 1, /**< Second full-width (kanji) sheet. */
    DBG_FONT_SHEET_HALF_WIDTH   = 2, /**< Half-width sheet of ASCII and kana. */
    DBG_FONT_SHEET_COUNT        = 3, /**< Number of glyph sheets. */
};

// clang-format on

/**
 *
 * Draws debug text one glyph at a time from 64x64-cell glyph sheets,
 * with an optional box and black outline behind each glyph, following
 * embedded tab, newline and toggle sequences.
 *
 */
class dbgCJISFont {
public:
    int                texture_id[DBG_FONT_SHEET_COUNT]{};         /**< Texture-manager slot holding each glyph sheet; -1 for none. */
    int                loaded_texture_id{};                        /**< Slot of the sheet last made resident; -1 when none is. */
    char               texture_name[DBG_FONT_SHEET_COUNT][0x20]{}; /**< Texture-manager name of each glyph sheet. */
    int                x{};                                        /**< Screen x of the next glyph. */
    int                y{};                                        /**< Screen y of the next glyph. */
    int                char_width{};                               /**< Width of a full-width glyph cell; tabs advance by two cells. */
    int                char_height{};                              /**< Height of a glyph cell and of a line. */
    unsigned long long prev_serno{};                               /**< Serial number of the preceding half-width kana, for merging sound marks; 0 for none. */
    char               buffer[0x800]{};                            /**< Text buffer, emptied by Clear. */
    int                color[4]{};                                 /**< Red, green, blue and alpha of the glyphs. */
    int                back_enable{};                              /**< Non-zero to draw a box behind each glyph; toggled by "ESC[$". */
    int                back_color[4]{};                            /**< Red, green, blue and alpha of the box behind each glyph. */
    int                shadow_enable{};                            /**< Non-zero to draw each glyph in black one pixel larger beneath it; toggled by "ESC[#". */

    /**
     *
     * Builds the font with no glyph sheets and default colours.
     *
     * @mangled __ct__11dbgCJISFontFv
     * @address 0x187810
     * @size 0x28
     */
    dbgCJISFont();

    /**
     *
     * Forgets the glyph sheets and puts the cursor, cell size and
     * colours back to their defaults.
     *
     * @mangled Initialize__11dbgCJISFontFv
     * @address 0x187840
     * @size 0x6C
     */
    void Initialize();

    /**
     *
     * Names the texture-manager slot and texture of each of the three
     * glyph sheets.
     *
     * @mangled InitTexture__11dbgCJISFontFiPciPciPc
     * @address 0x1878B0
     * @size 0x68
     */
    void InitTexture(int full0_id, char *full0_name, int full1_id, char *full1_name, int half_id, char *half_name);

    /**
     *
     * Empties the text buffer.
     *
     * @mangled Clear__11dbgCJISFontFv
     * @address 0x187920
     * @size 0x8
     */
    void Clear();

    /**
     *
     * Draws the glyph with the given serial number at the cursor and
     * moves the cursor past it.
     *
     * @mangled __putc__11dbgCJISFontFUl
     * @address 0x187930
     * @size 0x4A4
     */
    void __putc(unsigned long long serno);

    /**
     *
     * Formats a Shift-JIS string and draws it at once, starting at the
     * given screen position.
     *
     * @mangled PrintDirect__11dbgCJISFontFiiPce
     * @address 0x187DE0
     * @size 0x2A8
     */
    void PrintDirect(int x, int y, char *format, ...);
};

STATIC_ASSERT(sizeof(dbgCJISFont) == 0x8B0);

/**
 *
 * The debug font used by the debug menus and the event editor.
 *
 * @address 0x3F36A0
 * @size 0x8B0
 */
extern dbgCJISFont JisFont;
