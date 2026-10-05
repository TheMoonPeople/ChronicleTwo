#pragma once

#include "common.h"

#include "font.hpp"
#include "menusys.hpp"

/**
 * @file
 * Declares the name entry screen of the menus, where the player types a name
 * for a weapon, a ridepod part, a fish or the ridepod, the keyword an event
 * asks for or the name of a Spheda course, from grids of letters, kana, kanji
 * and symbols, plus the conversions between ASCII and Shift-JIS that it needs.
 */

class CDC2Mes;
class mgCMemory;

/**
 *
 * What the name entry screen is naming, as NAMEREGI_TARGET_INFO::target holds it.
 *
 */
// clang-format off
enum NAMEREGI_TARGET {
    NAMEREGI_TARGET_ITEM    = 0, /**< Renaming the item NAMEREGI_TARGET_INFO::item points at. */
    NAMEREGI_TARGET_ROBO    = 1, /**< Naming the ridepod. */
    NAMEREGI_TARGET_KEYWORD = 2, /**< Typing the keyword an event asks for, checked against NAMEREGI_TARGET_INFO::keyword. */
    NAMEREGI_TARGET_FISH    = 3, /**< Naming a fish of the fish race, or typing a fish password. */
    NAMEREGI_TARGET_SPHIDA  = 4, /**< Naming a Spheda course; the name is left in NAMEREGI_TARGET_INFO::keyword. */
};
// clang-format on

/**
 *
 * Character sets the grid of the name entry screen shows, as GetActiveFontMode returns them.
 *
 */
// clang-format off
enum NAMEREGI_FONT_MODE {
    NAMEREGI_FONT_MODE_ALPHA = 0, /**< Upper and lower case letters and digits. */
    NAMEREGI_FONT_MODE_HIRA  = 1, /**< Hiragana. */
    NAMEREGI_FONT_MODE_KATA  = 2, /**< Katakana. */
    NAMEREGI_FONT_MODE_KANJI = 3, /**< Kanji that the font has glyphs for, by reading. */
    NAMEREGI_FONT_MODE_KIGOU = 4, /**< Symbols. */
    NAMEREGI_FONT_MODE_NUM   = 5, /**< Number of character sets. */
};
// clang-format on

/**
 *
 * Steps of the name entry screen, as CBaseMenuClass::mode holds them while it runs.
 *
 */
// clang-format off
enum NAMEREGI_MODE {
    NAMEREGI_MODE_INPUT   = 0,  /**< The player moves the cursor and types. */
    NAMEREGI_MODE_OPEN    = 1,  /**< The screen is fading in. */
    NAMEREGI_MODE_CLOSE   = 2,  /**< The screen is fading out to close. */
    NAMEREGI_MODE_MESSAGE = 13, /**< A question or a notice is open in the message window. */
};
// clang-format on

/**
 *
 * What the name entry screen is to name and the keyword it is to check, filled in by the menu that opens it.
 *
 */
struct NAMEREGI_TARGET_INFO {
    s16 target;          /**< What is being named. @see NAMEREGI_TARGET */
    CGameDataUsed *item; /**< Item or fish being named. */
    char keyword[0x40];  /**< Keyword an event checks the input against, or the name the screen gives back. */
};
STATIC_ASSERT(sizeof(NAMEREGI_TARGET_INFO) == 0x48);

/**
 *
 * Cursor of a grid of the name entry screen, as nameregist_local_key moves it.
 *
 */
struct MENU_SELECT_PARAM {
    int pos; /**< Cell the cursor is on, counted row by row. */
    int row;
};

/**
 *
 * One kanji of a reading in the kanji grid, in a list that CheckChronicleKanjiFont builds.
 *
 */
struct NAMEREGI_KANJI_NODE {
    u8 code[2];              /**< Shift-JIS code of the kanji. */
    u8 unk_2[2];
    NAMEREGI_KANJI_NODE *next; /**< Next kanji of the reading, or NULL. */
};

/**
 *
 * One reading of the kanji grid: the first Shift-JIS code of the reading and the kanji the font has from there on.
 *
 */
struct NAMEREGI_KANJI_INDEX {
    u8 code[2];              /**< Shift-JIS code the reading starts at. */
    u8 unk_2[2];
    s16 num;                   /**< Number of kanji in the list. */
    u8 unk_6[2];
    NAMEREGI_KANJI_NODE *list; /**< Kanji of the reading the font has, or NULL. */
    u8 unk_C[4];
};
STATIC_ASSERT(sizeof(NAMEREGI_KANJI_INDEX) == 0x10);

/**
 *
 * The name entry screen: the grid of characters, the row of character set and editing buttons, the name being typed
 * and the message window that asks to confirm it.
 *
 */
class CNameRegiMenu : public CBaseMenuClass {
public:
    int select_mode;            /**< Row of NameStrSelectModeTable for the character set shown. */
    MENU_SELECT_PARAM select;   /**< Cursor on the character grid. */
    int command_pos;            /**< Button the cursor is on in the row below the grid. */
    s32 unk_120;
    int kanji_cell_num;         /**< Number of cells of the kanji grid, readings included. */
    int kanji_page_num;         /**< Number of pages of six rows of the kanji grid. */
    int kanji_line_max;         /**< Highest first row of the kanji grid. */
    u8 cursor_snap;             /**< Non-zero to move the mark cursor straight to its place. */
    float cursor_x;             /**< Screen x of the mark cursor. */
    float cursor_y;             /**< Screen y of the mark cursor. */
    int cursor_cnt;             /**< Frames counted to make the mark cursor bob. */
    RECT waku;                  /**< Frame drawn around the message window. */
    int password_input;         /**< Non-zero while a fish password is typed instead of a name. */
    s32 unk_154;
    s16 button_flash[16];       /**< Frames each button of the row below the grid stays lit after it is pressed. */
    float select_box_x;         /**< Screen x of the box drawn behind the character the cursor is on. */
    float select_box_y;         /**< Screen y of the box drawn behind the character the cursor is on. */
    CFont name_font;            /**< Font that draws the name being typed. */
    int caret_cnt;              /**< Frames counted to blink the caret; reset whenever the name changes. */
    float wave_angle;           /**< Angle that makes the board sway. */
    char old_name[0x61];        /**< Name before it is changed, to tell whether it changed. */
    char name[0x61];            /**< Name being typed, in Shift-JIS. */
    int name_pos;               /**< Character of the name the caret is at. */
    CFont grid_font[1];         /**< Font that draws the character grid. */
    int message_open;           /**< Non-zero while the second message window is shown over a dimmed screen. */
    float tile_scroll;          /**< Offset of the scrolling background tiles. */
    char jis_table[0x800];      /**< Shift-JIS code of each character of ascii_code_table, two bytes each. */

    /**
     *
     * Gives the character set shown, from the button chosen and the language.
     *
     * @mangled GetActiveFontMode__13CNameRegiMenuFv
     * @address 0x30F950
     * @size 0x50
     */
    int GetActiveFontMode();

    /**
     *
     * Copies an ASCII string into Shift-JIS, character by character through jis_table.
     *
     * @mangled CopyAsciiToJis__13CNameRegiMenuFPcPc
     * @address 0x30F9A0
     * @size 0x100
     */
    void CopyAsciiToJis(char *src, char *dst);

    /**
     *
     * Copies a Shift-JIS string into ASCII, character by character through jis_table.
     *
     * @mangled CopyJisToAscii__13CNameRegiMenuFPcPc
     * @address 0x30FAA0
     * @size 0x120
     */
    void CopyJisToAscii(char *src, char *dst);

    /**
     *
     * Moves the cursor between the character grid and the row of buttons below it, keeping its column.
     *
     * @mangled ConvertPositionNameRegi__13CNameRegiMenuFi
     * @address 0x310C30
     * @size 0x1C0
     */
    void ConvertPositionNameRegi(int to_command);

    /**
     *
     * Moves the cursor of the kanji grid on past the cells that hold no kanji; returns what nameregist_local_key did.
     *
     * @mangled CheckKanjiPosition__13CNameRegiMenuFiPsi
     * @address 0x310DF0
     * @size 0x140
     */
    int CheckKanjiPosition(int key, short *step, int limit_no);

    /**
     *
     * Runs one frame of the screen's input; returns non-zero once the screen has closed.
     *
     * @mangled KeyStep__13CNameRegiMenuFv
     * @address 0x310F30
     * @size 0x1470
     */
    int KeyStep();

    /**
     *
     * Gives the character the cursor is on in the character grid.
     *
     * @mangled GetSelectedActiveFont__13CNameRegiMenuFPc
     * @address 0x3123A0
     * @size 0x2A0
     */
    void GetSelectedActiveFont(char *dst);

    /**
     *
     * Sets the grid font up for a character set.
     *
     * @mangled ChangeFontSelectMode__13CNameRegiMenuFi
     * @address 0x312640
     * @size 0xC0
     */
    void ChangeFontSelectMode(int font_mode);

    /**
     *
     * Draws the background, the board and the row of buttons below the grid.
     *
     * @mangled DrawBaseBoard__13CNameRegiMenuFv
     * @address 0x312740
     * @size 0x4F0
     */
    void DrawBaseBoard();

    /**
     *
     * Draws the character grid of the character set shown.
     *
     * @mangled DrawActiveFont__13CNameRegiMenuFv
     * @address 0x312C30
     * @size 0x530
     */
    void DrawActiveFont();

    /**
     *
     * Moves the mark cursor towards the cell or button the cursor is on.
     *
     * @mangled StepMarkCursor__13CNameRegiMenuFv
     * @address 0x313160
     * @size 0x300
     */
    void StepMarkCursor();

    /**
     *
     * Draws the bobbing mark cursor.
     *
     * @mangled DrawMarkCursor__13CNameRegiMenuFv
     * @address 0x313460
     * @size 0xC0
     */
    void DrawMarkCursor();

    /**
     *
     * Draws the name being typed with its caret.
     *
     * @mangled DrawSelectedWord__13CNameRegiMenuFv
     * @address 0x313520
     * @size 0x2A0
     */
    void DrawSelectedWord();

    /**
     *
     * Draws the message window and, while one is open, the second message window over a dimmed screen.
     *
     * @mangled DrawMessage__13CNameRegiMenuFv
     * @address 0x3137C0
     * @size 0xC0
     */
    void DrawMessage();
};
STATIC_ASSERT(sizeof(CNameRegiMenu) == 0xBC8);

/**
 *
 * Gives the keyword the next name entry checks the input against, the topic it shows and a code of the event.
 *
 * @mangled SetEventKeyword__FPcPci
 * @address 0x30F890
 * @size 0x80
 */
void SetEventKeyword(char *keyword, char *topic, int code);

/**
 *
 * Tells whether naming an item uses up one item 0x180 of the inventory; true for weapons and ridepod parts.
 *
 * @mangled CheckDeleteNameRegisteItem__FP13CGameDataUsed
 * @address 0x30F910
 * @size 0x40
 */
int CheckDeleteNameRegisteItem(CGameDataUsed *item);

/**
 *
 * Builds the lists of kanji the font has for each reading of the kanji grid; returns the number of kanji found.
 *
 * @mangled CheckChronicleKanjiFont__FP9mgCMemory
 * @address 0x30FBC0
 * @size 0x1D0
 */
int CheckChronicleKanjiFont(mgCMemory *stack);

/**
 *
 * Gives the character of a cell of the kanji grid; returns 0 for a kanji, 1 for a reading, 2 for a blank, -1 past the
 * end.
 *
 * @mangled GetNameRegistFontKanjiList__FiPc
 * @address 0x30FD90
 * @size 0xD0
 */
int GetNameRegistFontKanjiList(int cell, char *dst);

/**
 *
 * Lays a message window out centred on the screen and gives the frame to draw around it.
 *
 * @mangled AdjustWaku__FP7CDC2MesP4RECT
 * @address 0x30FE60
 * @size 0x90
 */
void AdjustWaku(CDC2Mes *mes, RECT *waku);

/**
 *
 * Converts a Shift-JIS string into ASCII through the conversion tables.
 *
 * @mangled ConvertShitJiss2Ascii__FPcPc
 * @address 0x30FFA0
 * @size 0xA0
 */
void ConvertShitJiss2Ascii(char *src, char *dst);

/**
 *
 * Converts an ASCII string into Shift-JIS through the conversion tables.
 *
 * @mangled ConvertAscii2ShitJiss__FPcPc
 * @address 0x310040
 * @size 0x80
 */
void ConvertAscii2ShitJiss(char *src, char *dst);

/**
 *
 * Opens the name entry screen for what Nameregi_Target names.
 *
 * @mangled NameRegistInit__FP9mgCMemoryPii
 * @address 0x3100C0
 * @size 0x870
 */
void NameRegistInit(mgCMemory *stack, int *tex_block, int open_type);

/**
 *
 * Runs one frame of the name entry screen's input; returns non-zero once it has closed.
 *
 * @mangled NameRegistKey__Fv
 * @address 0x310930
 * @size 0x10
 */
int NameRegistKey();

/**
 *
 * Draws the name entry screen.
 *
 * @mangled NameRegistDraw__Fv
 * @address 0x310940
 * @size 0x50
 */
void NameRegistDraw();

/**
 *
 * Gives the button of the row below the grid that stands for a character set, for the language.
 *
 * @mangled ConvertNameRegiBaseBoardTable__Fi
 * @address 0x312700
 * @size 0x40
 */
s8 ConvertNameRegiBaseBoardTable(int font_mode);

/**
 * What the name entry screen is to name.
 *
 * @mangled Nameregi_Target
 * @address 0x1F5D260
 * @size 0x48
 */
extern NAMEREGI_TARGET_INFO Nameregi_Target;
