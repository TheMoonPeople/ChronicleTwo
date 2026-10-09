#include "common.h"

#include <cmath>
#include <cstddef>
#include <cstring>

#include "dataread.hpp"
#include "drawwin.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nameregi.hpp"
#include "nd_meswin.hpp"
#include "password.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

/**
 *
 * Maps name entry board slots to their displayed tile indices.
 *
 */
struct BoardTable {
    s8 slot[5]; /**< Tile index for each board slot. */
};

/**
 *
 * Maps command slots to character grid positions for each language and font.
 *
 */
struct PositionTable {
    s8 index[3][5][12]; /**< Character grid position for each language, font, and command. */
};

/**
 *
 * Stores the topic shown while entering an event keyword.
 *
 */
static char NameRegiTopic[0x40];

/**
 *
 * Stores the event keyword result code.
 *
 */
static s8 NameRegiCode;

/**
 *
 * Maps language and name entry button selection to a character set.
 *
 */
static s8 NameStrSelectModeTable[7][6] = {
    {NAMEREGI_FONT_MODE_KATA, NAMEREGI_FONT_MODE_HIRA, NAMEREGI_FONT_MODE_ALPHA, NAMEREGI_FONT_MODE_KIGOU, NAMEREGI_FONT_MODE_KANJI, -1},
    {-1, -1, NAMEREGI_FONT_MODE_ALPHA, NAMEREGI_FONT_MODE_KIGOU, -1, -1},
    {-1, -1, NAMEREGI_FONT_MODE_ALPHA, NAMEREGI_FONT_MODE_KIGOU, -1, -1},
    {-1, -1, NAMEREGI_FONT_MODE_ALPHA, NAMEREGI_FONT_MODE_KIGOU, -1, -1},
    {-1, -1, NAMEREGI_FONT_MODE_ALPHA, NAMEREGI_FONT_MODE_KIGOU, -1, -1},
    {-1, -1, NAMEREGI_FONT_MODE_ALPHA, NAMEREGI_FONT_MODE_KIGOU, -1, -1},
    {-1, -1, NAMEREGI_FONT_MODE_ALPHA, NAMEREGI_FONT_MODE_KIGOU, -1, -1}
};

/**
 *
 * Stores the initial Shift-JIS boundaries and generated kanji lists for each reading.
 *
 */
static NAMEREGI_KANJI_INDEX NameRegiSearchKanjiIndexTable[46] = {
    {{0x88, 0x9F}},
    {{0x88, 0xC8}},
    {{0x89, 0x45}},
    {{0x89, 0x61}},
    {{0x89, 0x98}},
    {{0x89, 0xBA}},
    {{0x8A, 0xE9}},
    {{0x8B, 0xE3}},
    {{0x8C, 0x54}},
    {{0x8C, 0xC1}},
    {{0x8D, 0xB1}},
    {{0x8E, 0x64}},
    {{0x90, 0x79}},
    {{0x90, 0xA2}},
    {{0x91, 0x58}},
    {{0x91, 0xBC}},
    {{0x92, 0x6C}},
    {{0x92, 0xC3}},
    {{0x92, 0xE0}},
    {{0x93, 0x65}},
    {{0x93, 0xDE}},
    {{0x93, 0xF1}},
    {{0x94, 0x47}},
    {{0x94, 0x4B}},
    {{0x94, 0x54}},
    {{0x94, 0x62}},
    {{0x94, 0xD9}},
    {{0x95, 0x73}},
    {{0x95, 0xB8}},
    {{0x95, 0xDB}},
    {{0x96, 0x80}},
    {{0x96, 0xA1}},
    {{0x96, 0xB1}},
    {{0x96, 0xBB}},
    {{0x96, 0xCC}},
    {{0x96, 0xE7}},
    {{0x96, 0xF9}},
    {{0x97, 0x5C}},
    {{0x97, 0x85}},
    {{0x97, 0x98}},
    {{0x97, 0xDA}},
    {{0x97, 0xDF}},
    {{0x98, 0x43}},
    {{0x98, 0x60}},
    {{0x98, 0x73}},
    {{0x00, 0x00}}
};

/**
 *
 * Stores the Shift-JIS reading characters shown at the start of kanji groups.
 *
 */
static s8 testchar[93] = "\x82\xA0\x82\xA2\x82\xA4\x82\xA6\x82\xA8\x82\xA9\x82\xAB\x82\xAD\x82\xAF\x82\xB1\x82\xB3\x82\xB5\x82\xB7\x82\xB9\x82\xBB\x82\xBD\x82\xBF\x82\xC2\x82\xC4\x82\xC6\x82\xC8\x82\xC9\x82\xCA\x82\xCB\x82\xCC\x82\xCD\x82\xD0\x82\xD3\x82\xD6\x82\xD9\x82\xDC\x82\xDD\x82\xDE\x82\xDF\x82\xE0\x82\xE2\x82\xE4\x82\xE6\x82\xE7\x82\xE8\x82\xE9\x82\xEA\x82\xEB\x82\xED\x82\xF0\x82\xF1";

/**
 *
 * Stores ASCII characters accepted by the name conversion table.
 *
 */
static s8 txt_table[59] = "0123456789abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";

/**
 *
 * Stores the alpha characters used by the name entry font.
 *
 */
static char ALPHA_TABLE1[28] = "ABCDEFGHIJKLM\nNOPQRSTUVWXYZ";

/**
 *
 * Stores the alpha characters used by the name entry font.
 *
 */
static char ALPHA_TABLE2[28] = "abcdefghijklm\nnopqrstuvwxyz";

/**
 *
 * Stores the digit characters used by the name entry font.
 *
 */
static char STR_NUM_TABLE[14] = "0123456789   ";

/**
 *
 * Stores the first hiragana character table used by the name entry font.
 *
 */
static char HIRA_TABLE1[2] = " ";

/**
 *
 * Stores the second hiragana character table used by the name entry font.
 *
 */
static char HIRA_TABLE2[2] = " ";

/**
 *
 * Stores the third hiragana character table used by the name entry font.
 *
 */
static char HIRA_TABLE3[2] = " ";

/**
 *
 * Stores the first katakana character table used by the name entry font.
 *
 */
static char KATA_TABLE1[2] = " ";

/**
 *
 * Stores the second katakana character table used by the name entry font.
 *
 */
static char KATA_TABLE2[2] = " ";

/**
 *
 * Stores the third katakana character table used by the name entry font.
 *
 */
static char KATA_TABLE3[2] = " ";

/**
 *
 * Stores the kigou characters used by the name entry font.
 *
 */
static char KIGOU_TABLE1[1] = "";

/**
 *
 * Stores the kigou characters used by the name entry font.
 *
 */
static char KIGOU_TABLE2[2] = " ";

/**
 *
 * Holds the character tables used by one name entry font mode.
 *
 */
struct FontTables {
    char *first;  /**< First character table. */
    char *second; /**< Second character table. */
    char *third;  /**< Third character table. */
};

/**
 *
 * Holds the four channel values used to colour a name entry board tile.
 *
 */
struct BoardColor {
    s16 r; /**< Red channel. */
    s16 g; /**< Green channel. */
    s16 b; /**< Blue channel. */
    s16 a; /**< Alpha channel. */
};

/**
 *
 * Locates and sizes a rectangular region of a name entry board texture.
 *
 */
struct BoardRect {
    s16 x; /**< Horizontal origin. */
    s16 y; /**< Vertical origin. */
    s16 w; /**< Width. */
    s16 h; /**< Height. */
};

/**
 *
 * Locates a point on the name entry board.
 *
 */
struct BoardPoint {
    s16 x; /**< Horizontal coordinate. */
    s16 y; /**< Vertical coordinate. */
};

/**
 *
 * Stores the two colours used to draw name entry board passes.
 *
 */
static BoardColor colt_1808[2] = {
    {0, 0, 0, 32},
    {128, 128, 128, 128}
};

/**
 *
 * Stores character set button texture rectangles for each name entry board layout.
 *
 */
static BoardRect table_1819[7][5] = {
    {
        {176, 324, 54, 30},
        {88, 324, 88, 30},
        {0, 324, 88, 30},
        {188, 354, 70, 30},
        {230, 324, 54, 30}
    },
    {
        {0, 294, 132, 30},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {132, 294, 132, 30}
    },
    {
        {0, 294, 132, 30},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {132, 294, 132, 30}
    },
    {
        {0, 294, 132, 30},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {132, 294, 132, 30}
    },
    {
        {0, 294, 132, 30},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {132, 294, 132, 30}
    },
    {
        {0, 294, 132, 30},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {132, 294, 132, 30}
    },
    {
        {0, 294, 132, 30},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {132, 294, 132, 30}
    }
};

/**
 *
 * Stores editing command texture rectangles for each name entry board layout.
 *
 */
static BoardRect tex_commtbl_1822[7][6] = {
    {
        {0, 354, 36, 30},
        {36, 354, 36, 30},
        {184, 294, 58, 30},
        {72, 354, 58, 30},
        {130, 354, 58, 30},
        {0, 294, 92, 30}
    },
    {
        {0, 354, 36, 30},
        {36, 354, 36, 30},
        {0, 324, 88, 30},
        {72, 354, 88, 30},
        {160, 354, 88, 30},
        {0, 294, 92, 30}
    },
    {
        {0, 354, 36, 30},
        {36, 354, 36, 30},
        {0, 324, 88, 30},
        {72, 354, 88, 30},
        {160, 354, 88, 30},
        {0, 294, 92, 30}
    },
    {
        {0, 354, 36, 30},
        {36, 354, 36, 30},
        {0, 324, 88, 30},
        {72, 354, 88, 30},
        {160, 354, 88, 30},
        {0, 294, 92, 30}
    },
    {
        {0, 354, 36, 30},
        {36, 354, 36, 30},
        {0, 324, 88, 30},
        {72, 354, 88, 30},
        {160, 354, 88, 30},
        {0, 294, 92, 30}
    },
    {
        {0, 354, 36, 30},
        {36, 354, 36, 30},
        {0, 324, 88, 30},
        {72, 354, 88, 30},
        {160, 354, 88, 30},
        {0, 294, 92, 30}
    },
    {
        {0, 354, 36, 30},
        {36, 354, 36, 30},
        {0, 324, 88, 30},
        {72, 354, 88, 30},
        {160, 354, 88, 30},
        {0, 294, 92, 30}
    }
};

/**
 *
 * Stores the screen positions of name entry commands for each board layout.
 *
 */
static BoardPoint nameregist_baseboard_upper_table[6][12] = {
    {
        {21, 16},
        {107, 16},
        {193, 16},
        {245, 16},
        {297, 16},
        {29, 44},
        {66, 44},
        {107, 44},
        {163, 44},
        {219, 44},
        {275, 44},
        {369, 22}
    },
    {
        {21, 16},
        {0, 0},
        {0, 0},
        {0, 0},
        {150, 16},
        {29, 44},
        {66, 44},
        {279, 44},
        {107, 44},
        {193, 44},
        {279, 16},
        {369, 22}
    },
    {
        {21, 16},
        {0, 0},
        {0, 0},
        {0, 0},
        {150, 16},
        {29, 44},
        {66, 44},
        {279, 44},
        {107, 44},
        {193, 44},
        {279, 16},
        {369, 22}
    },
    {
        {21, 16},
        {0, 0},
        {0, 0},
        {0, 0},
        {150, 16},
        {29, 44},
        {66, 44},
        {279, 44},
        {107, 44},
        {193, 44},
        {279, 16},
        {369, 22}
    },
    {
        {21, 16},
        {0, 0},
        {0, 0},
        {0, 0},
        {150, 16},
        {29, 44},
        {66, 44},
        {279, 44},
        {107, 44},
        {193, 44},
        {279, 16},
        {369, 22}
    },
    {
        {21, 16},
        {0, 0},
        {0, 0},
        {0, 0},
        {150, 16},
        {29, 44},
        {66, 44},
        {279, 44},
        {107, 44},
        {193, 44},
        {279, 16},
        {369, 22}
    }
};

/**
 *
 * Stores the heights of the name entry board texture slices.
 *
 */
static s16 get_Htable_1806[4] = {100, 16, 32, 0};

/**
 *
 * Stores the primary ASCII symbol grid for European name entry.
 *
 */
static char KIGOU_TABLE_ASCII1[31] = "!?\"#$&'()*+-%,.\n:;<=>@[]_{}|/ ";

/**
 *
 * Stores the extended ASCII symbol grid for European name entry.
 *
 */
static char KIGOU_TABLE_ASCII2[128] = " ";

/**
 *
 * Lists the Shift-JIS character tables used to build the conversion grid.
 *
 */
static char *jis_ptr_table[2] = {NULL, NULL};

/**
 *
 * Points to the name entry window frame texture.
 *
 */
static mgCTexture *NameRegiWaku;

/**
 *
 * Points to the scrolling name entry background texture.
 *
 */
static mgCTexture *NameRegiBGTile;

/**
 *
 * Points to the extra glyph texture used by name entry.
 *
 */
static mgCTexture *NameregiGaiji;

/**
 *
 * Groups the character arrays available for each name entry font mode.
 *
 */
static FontTables NameRegistFont_Table[NAMEREGI_FONT_MODE_NUM] = {
    {ALPHA_TABLE1, ALPHA_TABLE2, STR_NUM_TABLE},
    {HIRA_TABLE1, HIRA_TABLE2, HIRA_TABLE3},
    {KATA_TABLE1, KATA_TABLE2, KATA_TABLE3},
    {NULL, NULL, NULL},
    {KIGOU_TABLE1, KIGOU_TABLE2, NULL}
};

/**
 *
 * Points to the active name entry menu.
 *
 */
static CNameRegiMenu *NameRegiMenuPtr;

/**
 *
 * Caches the last texture block loaded by the name entry menu.
 *
 */
static int OldReloadTexNumber;

/**
 *
 * Stores the number of cells in each name entry character set.
 *
 */
static s16 LimmitTable_1360[5] = {65, 90, 90, 114, 90};

/**
 *
 * Stores the number of columns in each name entry character set.
 *
 */
static s8 NameRegistGyouLimmitTable[5] = {13, 15, 15, 19, 15};

/**
 *
 * Maps grid columns to name entry commands for each language and character set.
 *
 */
static s8 Convtable2_1382[2][5][8] = {
    {
        {0, 1, 3, 5, 8, 11, 12, 0},
        {1, 2, 5, 7, 9, 11, 13, 0},
        {1, 2, 5, 7, 9, 11, 13, 0},
        {1, 3, 5, 7, 11, 15, 20, 0},
        {0, 1, 2, 3, 5, 7, 9, 14}
    },
    {
        {0, 1, 3, 5, 8, 11, 12, 0},
        {1, 2, 5, 7, 9, 11, 13, 0},
        {1, 2, 5, 7, 9, 11, 13, 0},
        {1, 3, 5, 7, 11, 15, 20, 0},
        {0, 2, 5, 5, 9, 12, 9, 14}
    }
};

/**
 *
 * Maps character sets to buttons on the Japanese name entry board.
 *
 */
static BoardTable convtbl_1792 = {{2, 1, 0, 4, 3}};

/**
 *
 * Points to the name entry cursor texture.
 *
 */
static mgCTexture *NameRegiCursor;

/**
 *
 * Points to the name entry board texture.
 *
 */
static mgCTexture *NameRegiTex1;

/**
 *
 * Limits the number of characters accepted by name entry.
 *
 */
static s16 NameRegistMax = 10;

/**
 *
 * Stores the three texture slices used to draw the selected name frame.
 *
 */
static s16 gettbl0_2012[12] = {0, 148, 42, 64, 42, 148, 16, 64, 58, 148, 42, 64};

/**
 *
 * Owns the temporary model, texture and font storage for name entry.
 *
 */
static mgCMemory NameRegiStack;

// Code (.text)
void SetEventKeyword(char *target, char *topic, int code) {
    Nameregi_Target.keyword[0] = 0;
    Nameregi_Target.keyword[1] = 0;

    if (target != NULL) {
        strcpy(Nameregi_Target.keyword, target);
    }

    NameRegiTopic[0] = 0;
    NameRegiTopic[1] = 0;

    if (topic != NULL) {
        strcpy(NameRegiTopic, topic);
    }

    NameRegiCode = code;
}

int CheckDeleteNameRegisteItem(CGameDataUsed *item) {
    if (item == NULL) {
        return 0;
    }

    if (item->used_type == USED_ITEM_TYPE_WEAPON || item->used_type == USED_ITEM_TYPE_ROBO_PART) {
        return 1;
    }

    return 0;
}

int CNameRegiMenu::GetActiveFontMode() {
    int language = LanguageCode;

    if (language < 0) {
        language = 0;
    }

    if (language > 1) {
        language = 1;
    }

    return NameStrSelectModeTable[language][select_mode];
}

/**
 *
 * Lists the ASCII characters mapped by the name entry font.
 *
 */
static char ascii_code_table[95] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789   !\"#$%&'()*+,-. /:;<=>?@[]_{}|";

void CNameRegiMenu::CopyAsciiToJis(char *src, char *dst) {
    if (src == NULL || dst == NULL) {
        return;
    }

    if (CheckNowEurope() != 0) {
        strcpy(dst, src);
    } else {
        char *ascii_codes = ascii_code_table;

        while ((s8) *src != 0) {
            s64 character = (s8) *src;
            int matched_index = -1;
            int table_index = 0;

            while ((s8) ascii_codes[table_index] != 0) {
                if (character == (s64) (s8) ascii_codes[table_index]) {
                    matched_index = table_index;
                    break;
                }

                table_index++;
            }

            if (0 <= matched_index) {
                dst[0] = jis_table[matched_index * 2];
                dst[1] = jis_table[matched_index * 2 + 1];
                dst += 2;
            }

            src++;
        }

        *dst = 0;
    }
}
void CNameRegiMenu::CopyJisToAscii(char *src, char *dst) {
    if (src == NULL || dst == NULL) {
        return;
    }
    if (CheckNowEurope() != 0) {
        strcpy(dst, src);
    } else {
        char *text = src;
        while ((s8) *text != 0) {
            long high = *text;
            int  matched_index = -1;
            int  table_index = 0;
            while ((s8) jis_table[table_index] != 0) {
                if (high == jis_table[table_index] && text[1] == jis_table[table_index + 1]) {
                    matched_index = table_index;
                    break;
                }
                table_index += 2;
            }
            if (0 <= matched_index) {
                *dst = ascii_code_table[matched_index / 2];
                dst++;
            }
            text += 2;
        }
        *dst = 0;
    }
}
int CheckChronicleKanjiFont(mgCMemory *memory) {
    char name[3];
    int  total;
    int  row;

    if (memory == NULL) {
        return 0;
    }

    name[2] = 0;
    total = 0;
    row = 0;

    do {
        NAMEREGI_KANJI_INDEX *current;
        NAMEREGI_KANJI_NODE  *node;
        NAMEREGI_KANJI_NODE  *previous;
        u8                    high;
        u8                    low;
        int                   i;
        NAMEREGI_KANJI_INDEX *next;
        int                   count;
        node = NULL;
        previous = NULL;
        count = 0;
        i = 0;
        current = &NameRegiSearchKanjiIndexTable[row];
        next = &NameRegiSearchKanjiIndexTable[row + 1];
        current->list = NULL;
        high = current->code[0];
        low = current->code[1];

        do {
            name[0] = high;
            name[1] = low;

            if (0 <= GetFontNo(name)) {
                if (current->list == NULL) {
                    current->list = (NAMEREGI_KANJI_NODE *) memory->Alloc(1);
                    node = current->list;
                } else {
                    previous->next = (NAMEREGI_KANJI_NODE *) memory->Alloc(1);
                    node = previous->next;
                }

                node->code[0] = high;
                node->code[1] = low;
                count++;
                node->next = NULL;
            }

            if (low < 0xFF) {
                low++;
            } else {
                low = 0;
                high++;
            }

            previous = node;

            if (next->code[0] == high && next->code[1] == low) {
                break;
            }

            i++;
        } while (i < 0x200);

        if (node != NULL) {
            node->next = NULL;
        }

        current->num = count;
        total += count;
        row++;
    } while (row < 0x2C);

    return total;
}

int GetNameRegistFontKanjiList(int font_index, char *out) {
    int                  position = 0;
    int                  row = 0;
    NAMEREGI_KANJI_NODE *node;

    do {
        if (position == font_index) {
            out[0] = testchar[row * 2];
            out[1] = testchar[row * 2 + 1];
            return 1;
        }

        node = NameRegiSearchKanjiIndexTable[row].list;
        position++;

        if (node != NULL) {
            do {
                if (position == font_index) {
                    out[0] = node->code[0];
                    out[1] = node->code[1];
                    return 0;
                }

                node = node->next;
                position++;
            } while (node != NULL);
        }

        if (position == font_index) {
            out[0] = -0x7F;
            out[1] = 0x40;
            return 2;
        }

        position++;
        row++;
    } while (row < 0x2C);

    return -1;
}

/**
 *
 * Stores the two coordinates used to place the name entry message window.
 *
 */
union NameRegiWindowPosition {
    int coordinates[2]; /**< Horizontal and vertical window positions. */
    s64 packed;         /**< Both positions copied together. */
};

/**
 *
 * Centers a message window and updates its surrounding frame.
 *
 * @mangled AdjustWaku__FP7CDC2MesP4RECT
 * @address 0x30FE60
 * @size 0x8C
 */
void AdjustWaku(CDC2Mes *message, RECT *frame) {
    message->StepMsg();
    int                    width = message->line_w[0];
    NameRegiWindowPosition position = {{0, 36}};
    position.coordinates[0] = (mgScreenWidth - width) >> 1;
    message->SetPutPos(position.coordinates);
    frame->x = position.coordinates[0] - 20;
    frame->y = position.coordinates[1] - 22;
    frame->width = width + 44;
    frame->height = message->font_h + 36;
}

/**
 *
 * Stores the Shift-JIS counterparts of the ASCII name conversion characters.
 *
 */
static s8 txt_table2[117] = "\x82O\x82P\x82Q\x82R\x82S\x82T\x82U\x82V\x82W\x82X\x82\x81\x82\x82\x82\x83\x82\x84\x82\x85\x82\x86\x82\x87\x82\x88\x82\x89\x82\x8A\x82\x8B\x82\x8D\x82\x8E\x82\x90\x82\x91\x82\x92\x82\x93\x82\x94\x82\x95\x82\x96\x82\x97\x82\x98\x82\x99\x82\x9A\x82`\x82" "a\x82" "b\x82" "c\x82" "d\x82" "e\x82" "f\x82g\x82i\x82j\x82k\x82l\x82m\x82o\x82p\x82q\x82r\x82s\x82t\x82u\x82v\x82w\x82x\x82y";

/**
 *
 * Finds a two-byte JIS character in the name-entry character table.
 *
 * @mangled search_txt_jis__FPc
 * @address 0x30FEF0
 * @size 0x58
 */
int search_txt_jis(char *text) {
    int index = 0;

    do {
        if ((s8) text[0] == txt_table2[index * 2] && (s8) text[1] == txt_table2[index * 2 + 1]) {
            return index;
        }

        index++;
    } while (index < 0x3A);

    return -1;
}

/**
 *
 * Finds an ASCII character in the name-entry character table.
 *
 * @mangled search_txt_asci__FPc
 * @address 0x30FF50
 * @size 0x44
 */
static int search_txt_asci(char *text) {
    s8 *character = text;
    int table_index = 0;

    do {
        if (*character == txt_table[table_index]) {
            return table_index;
        }

        table_index++;
    } while (table_index < 0x3A);

    return -1;
}

void ConvertShitJiss2Ascii(char *src, char *dst) {
    if (src == NULL || dst == NULL) {
        return;
    }

    if (CheckNowEurope() != 0) {
        strcpy(dst, src);
        return;
    }

    while ((s8) *src != 0) {
        int index = search_txt_jis(src);

        if (0 <= index) {
            *dst = txt_table[index];
        }

        src += 2;
        dst++;
    }
}

void ConvertAscii2ShitJiss(char *src, char *dst) {
    if (dst == NULL || src == NULL) {
        return;
    }

    char *input = src;
    char *output = dst;

    while ((s8) *input != 0) {
        int index = search_txt_asci(input);

        if (0 <= index) {
            output[0] = txt_table2[index * 2];
            output[1] = txt_table2[index * 2 + 1];
        }

        input++;
        output += 2;
    }
}

/**
 *
 * Groups the item names shown in one name entry menu state.
 *
 */
struct NameRegiItemNames {
    char *name[3]; /**< Item name for each selectable entry. */
};

inline CNameRegiMenu::CNameRegiMenu() {
    select.pos = 0;
    select.row = 0;
    unk_120 = 0;
    command_pos = 0;

    if (LanguageCode > 0) {
        command_pos = 2;
    }

    cursor_x = 0.0f;
    cursor_y = 0.0f;
    cursor_snap = 1;
    cursor_cnt = 0;
    caret_cnt = 0;
    wave_angle = 0.0f;

    for (int i = 0; i < 16; i++) {
        button_flash[i] = 0;
    }

    kanji_cell_num = 0;
    kanji_page_num = 0;
    kanji_line_max = 0;
    select_box_x = 0.0f;
    select_box_y = 0.0f;
    message_type = 0;
    memset(old_name, 0, sizeof(old_name));
    memset(name, 0, sizeof(name));
    name_pos = 0;
    name_font.Init();
    name_font.offset_x = 0.0f;
    name_font.offset_y = 0.0f;
    name_font.SetClearance(0x18, 0x14);
    name_font.SetFuchi(5);
    name_font.SetColor(0x80686A6B);
    password_input = 0;
    message_open = 0;
    tile_scroll = 0.0f;
    select_mode = 0;

    if (LanguageCode > 0) {
        select_mode = 2;
    }

    char *jis = jis_table;

    for (int i = 0; jis_ptr_table[i] != NULL; i++) {
        char *ascii = jis_ptr_table[i];

        while (*ascii != 0) {
            if ((s8) *ascii != '\n') {
                jis[0] = *ascii;
                ascii++;
                jis[1] = ascii[0];
                jis += 2;
            }

            ascii++;
        }
    }

    *jis = 0;
    ChangeFontSelectMode(GetActiveFontMode());
}

/**
 *
 * Rounds a byte count up to the number of sixteen-byte memory blocks it occupies.
 *
 */
static inline u_int Align16Blocks(u_int n) {
    if (n & 0xF) {
        return (n >> 4) + 1;
    }

    return n >> 4;
}

void NameRegistInit(mgCMemory *stack, int *tex_block, int open_type) {
    int rest = stack->stGetRest();
    NameRegiStack.stSetBuffer(stack->stGetTop(), rest);
    CNameRegiMenu *menu = new (NameRegiStack.Alloc(0xBF)) CNameRegiMenu;
    NameRegiMenuPtr = menu;
    menu->SetTexBlock(tex_block);
    NameRegiStack.Align64();
    mgCTextureManager *textures;
    int                file_size;
    u_int             *pack = (u_int *) NameRegiStack.stGetTop();
    NameRegiStack.Alloc(Align16Blocks(LoadFileMenu("nregi.pac", (u_long128 *) pack, 1)));
    textures = &mgTexManager;
    MenuEnterIMG(NameRegiMenuPtr->tex_block[0], (u8 *) GetPackFile(pack, "img.img", &file_size), NULL);
    NameRegiTex1 = textures->GetTexture("nameregi", -1);
    NameRegiBGTile = textures->GetTexture("nameregi", -1);
    NameRegiWaku = NULL;
    NameRegiCursor = NULL;
    u8 *waku_img = (u8 *) GetPackFile(pack, "edmenu.img", &file_size);

    if (waku_img != NULL) {
        MenuEnterIMG(NameRegiMenuPtr->tex_block[0], waku_img, "m");
        NameRegiWaku = textures->GetTexture("menueff0m", -1);
    }

    u8 *cursor_img = GetMenuMainIMGPtr();

    if (cursor_img != NULL) {
        MenuEnterIMG(NameRegiMenuPtr->tex_block[0], cursor_img, "m");
        NameRegiCursor = textures->GetTexture("mnmainm", -1);
    }

    NameregiGaiji = textures->GetTexture("gaiji", -1);
    NameRegistMax = 10;
    NameRegistFont_Table[NAMEREGI_FONT_MODE_KIGOU].first = KIGOU_TABLE1;
    NameRegistFont_Table[NAMEREGI_FONT_MODE_KIGOU].second = KIGOU_TABLE2;

    if (LanguageCode > 0) {
        NameRegistMax = 20;
        NameRegistFont_Table[NAMEREGI_FONT_MODE_KIGOU].first = KIGOU_TABLE_ASCII1;
        NameRegistFont_Table[NAMEREGI_FONT_MODE_KIGOU].second = KIGOU_TABLE_ASCII2;

        if (CheckNowEurope() != 0) {
            int ranges[17] = {0xBA, 0xBA, 0xBD, 0xCF, 0xD2, 0xD6, 0xD9, 0xDD, 0xDF, 0xE4, 0xE6, 0xEF, 0xF2, 0xF6, 0xF9, 0xFD, -1};
            int out = 0;
            int count = 0;
            int pair = 0;

            for (;;) {
                int first = ranges[pair];

                if (first < 0) {
                    break;
                }

                int offset = 0;

                for (;;) {
                    if (ranges[pair + 1] < first + offset) {
                        break;
                    }

                    KIGOU_TABLE_ASCII2[out] = first + offset;
                    out++;

                    if (count % 15 == 14) {
                        KIGOU_TABLE_ASCII2[out] = '\n';
                        out++;
                    }

                    count++;
                    offset++;
                }

                pair += 2;
            }

            KIGOU_TABLE_ASCII2[out] = 0;
        }
    }

    mgCMemory kanji_memory;
    int       kanji_rest = NameRegiStack.stGetRest();
    kanji_memory.stSetBuffer(NameRegiStack.stGetTop(), kanji_rest);
    NameRegiMenuPtr->kanji_cell_num = CheckChronicleKanjiFont(&kanji_memory) + 0x58;
    NameRegiMenuPtr->kanji_page_num = NameRegiMenuPtr->kanji_cell_num / 114;
    NameRegiMenuPtr->kanji_line_max = NameRegiMenuPtr->kanji_page_num * 6;
    NameRegiStack.Alloc(Align16Blocks(kanji_memory.stGetUsed()));
    short   *message_buffer = GetMenuMainMessageBuffer();
    short   *system_buffer = GetSystemMesBuffer();
    CDC2Mes *message = MenuDCMsg[6];
    message->SetBuff(message_buffer);
    message->SetBuff_system(system_buffer);
    message->MsgPreset(2);
    message->push_button = 0;
    message->fade_speed = 1.0f;
    int               message_no = 0;
    NameRegiItemNames item_names = {{NULL, NULL, NULL}};

    switch (Nameregi_Target.target) {
        case NAMEREGI_TARGET_ITEM:
            if (Nameregi_Target.item != NULL) {
                s16 used_type = Nameregi_Target.item->used_type;

                if (used_type != 0) {
                    switch (used_type) {
                        case 3:
                        case 5:
                        case 6:
                            message_no = 1;
                            item_names.name[0] = Nameregi_Target.item->GetName(0);
                            break;
                    }
                }
            }

            break;
        case NAMEREGI_TARGET_ROBO:
            item_names.name[0] = GetUserDataMan()->GetRoboName();
            break;
        case NAMEREGI_TARGET_KEYWORD:
            MenuArg.result[0] = 0;
            message_no = MenuArg.param[0] + 0xA;

            if (NameRegiCode == 1) {
                item_names.name[0] = Nameregi_Target.keyword;
            }

            break;
        case NAMEREGI_TARGET_FISH:
            item_names.name[0] = NULL;
            message_no = 0x6E;
            break;
        case NAMEREGI_TARGET_SPHIDA:
            message_no = 0x78;
            memset(Nameregi_Target.keyword, 0, sizeof(Nameregi_Target.keyword));
            item_names.name[0] = NULL;
            break;
    }

    if (item_names.name[0] != NULL) {
        strcpy(NameRegiMenuPtr->old_name, item_names.name[0]);
        strcpy(NameRegiMenuPtr->name, item_names.name[0]);

        if (LanguageCode > 0) {
            NameRegiMenuPtr->CopyAsciiToJis(item_names.name[0], NameRegiMenuPtr->name);
        }
    }

    int name_length = strlen(NameRegiMenuPtr->name);
    NameRegiMenuPtr->name_pos = name_length / 2;

    if (CheckNowEurope() != 0) {
        NameRegiMenuPtr->name_pos = name_length;
    }

    if (NameRegistMax <= NameRegiMenuPtr->name_pos) {
        NameRegiMenuPtr->name_pos = NameRegistMax - 1;
    }

    if (Nameregi_Target.target == NAMEREGI_TARGET_KEYWORD) {
        message->MakeMsg(NameRegiTopic);
    } else {
        message->MakeMsg(message_no + 0xFA0);
        message->SetMsgItemNo(item_names.name, 1);
    }

    AdjustWaku(message, &NameRegiMenuPtr->waku);
    CDC2Mes *confirm = MenuDCMsg[7];
    confirm->SetBuff(message_buffer);
    confirm->SetBuff_system(system_buffer);
    NameRegiMenuPtr->FadeInMenu(0x28, 0.0f);
}

int NameRegistKey() {
    return NameRegiMenuPtr->KeyStep();
}

void NameRegistDraw() {
    OldReloadTexNumber = -1;
    NameRegiMenuPtr->DrawBaseBoard();
    NameRegiMenuPtr->DrawSelectedWord();
    NameRegiMenuPtr->DrawActiveFont();
    NameRegiMenuPtr->DrawMarkCursor();
    NameRegiMenuPtr->DrawMessage();
}

/**
 *
 * Removes trailing spaces or full-width blanks from a name before accepting it.
 *
 * @mangled CheckInputWord__FPc
 * @address 0x310990
 * @size 0xC4
 */
void CheckInputWord(char *word) {
    int index = strlen(word) - 1;

    while (index >= 0) {
        if (CheckNowEurope() != 0) {
            if (word[index] != 0x20) {
                break;
            }

            word[index] = 0;
            index--;
        } else if (LanguageCode == 0 || LanguageCode == 1) {
            if (word[index] != 0x40) {
                break;
            }

            if ((u8) word[index - 1] == 0x81) {
                word[index - 1] = 0;
                word[index] = 0;
            }

            index -= 2;
        } else {
            index--;
        }
    }
}

int nameregist_local_key(MENU_SELECT_PARAM *param, int &keys, s16 *step, int table_index) {
    int direction = 0;

    if (keys & 1) {
        direction = 1;
        param->pos += step[0];
    }

    if (keys & 2) {
        direction = 2;
        param->pos += step[1];
    }

    if (keys & 4) {
        s16 row_size = step[1];

        if (param->pos % row_size == 0) {
            param->pos += row_size - 1;
        } else {
            param->pos += step[2];
        }

        direction = 4;
    } else if (keys & 8) {
        s16 row_size = step[1];
        int last = row_size - 1;
        int same = last == param->pos % row_size;

        if (same) {
            param->pos -= last;
        } else {
            param->pos += step[3];
        }

        direction = 1;
    }

    if (keys & 0x10 || keys & 0x40) {
        keys = 4;
    }

    if (keys & 0x20 || keys & 0x80) {
        keys = 8;
    }

    int base = param->pos;

    if (base < 0) {
        param->pos = base + LimmitTable_1360[table_index];
        direction = -1;
    }

    if (LimmitTable_1360[table_index] <= param->pos) {
        param->pos += step[0];
        keys &= ~2;
        keys |= 1;
    }

    return direction;
}

void CNameRegiMenu::ConvertPositionNameRegi(int mode) {
    int font_mode = GetActiveFontMode();

    if (mode == 0) {
        int           col = command_pos;
        PositionTable table = {{
            {
                {0, 0, 7, 9, 11, 0, 0, 2, 4, 6, 8, 12},
                {0, 1, 3, 8, 10, 0, 1, 3, 5, 7, 9, 12},
                {0, 1, 3, 8, 10, 0, 1, 3, 5, 7, 9, 12},
                {0, 0, 9, 10, 11, 0, 1, 3, 6, 8, 12, 15},
                {0, 0, 8, 10, 11, 0, 0, 2, 4, 7, 9, 14}
            },
            {
                {0, 0, 5, 8, 0, 0, 0, 9, 1, 5, 8, 12},
                {0, 1, 3, 8, 10, 0, 1, 3, 5, 7, 9, 12},
                {0, 1, 3, 8, 10, 0, 1, 3, 5, 7, 9, 12},
                {0, 0, 9, 10, 11, 0, 1, 3, 6, 8, 12, 15},
                {0, 0, 8, 10, 11, 0, 0, 9, 2, 6, 9, 13}
            },
            {
                {0, 0, 7, 9, 11, 0, 0, 2, 4, 6, 8, 12},
                {0, 1, 3, 8, 10, 0, 1, 3, 5, 7, 9, 12},
                {0, 1, 3, 8, 10, 0, 1, 3, 5, 7, 9, 12},
                {0, 0, 9, 10, 11, 0, 1, 3, 6, 8, 12, 15},
                {0, 0, 8, 10, 11, 0, 0, 11, 2, 6, 9, 13}
            }
        }};
        int           language = LanguageCode;

        if (language > 0) {
            language = 1;
        }

        select.pos = table.index[language][font_mode][col];
    }

    if (mode == 1) {
        int remainder = select.pos % NameRegistGyouLimmitTable[font_mode];
        int language = 0;

        if (LanguageCode > 0) {
            language = 1;
        }

        s8 *limit = Convtable2_1382[language][font_mode];

        if (remainder < limit[0]) {
            command_pos = 5;
        } else if (remainder < limit[1]) {
            command_pos = 6;
        } else if (remainder < limit[2]) {
            command_pos = 7;

            if (LanguageCode > 0) {
                command_pos = 8;
            }
        } else if (remainder < limit[3]) {
            command_pos = 8;
        } else if (remainder < limit[4]) {
            command_pos = 9;
        } else if (remainder < limit[5]) {
            command_pos = 0xA;

            if (LanguageCode > 0) {
                command_pos = 7;
            }
        } else {
            command_pos = 0xB;
        }
    }
}

int CNameRegiMenu::CheckKanjiPosition(int position, s16 *keys, int key_mode) {
    MENU_SELECT_PARAM *param = &select;
    int                result = 0;
    char               cell[4];
    cell[2] = 0;
    int kind = GetNameRegistFontKanjiList(select.pos + select.row * 0x13, cell);

    while (kind != 0 && kind != 1) {
        result = nameregist_local_key(param, position, keys, key_mode);

        if (result == -1) {
            break;
        }

        kind = GetNameRegistFontKanjiList(param->pos + param->row * 0x13, cell);

        if (kind < 0) {
            position = 1;

            while (kind != 0 && kind != 1) {
                result = nameregist_local_key(param, position, keys, key_mode);

                if (result == -1) {
                    break;
                }

                kind = GetNameRegistFontKanjiList(param->pos + param->row * 0x13, cell);
            }

            break;
        }
    }

    return result;
}

/**
 *
 * Stores the pair of names substituted into a name entry message.
 *
 */
union NameMessageArguments {
    char *name[2]; /**< Names inserted into the message. */
    s64   packed;  /**< Both name pointers copied together. */
};

/**
 *
 * Holds the command navigation and event entries for the name entry board.
 *
 */
struct NameCommandTable {
    s8 bytes[0x30]; /**< Four entries for each command slot. */
};

/**
 *
 * Holds the bytes used to decode a fishing password.
 *
 */
struct PasswordKey {
    u8 bytes[0x21]; /**< Password decoding key and its terminator. */
};

/**
 *
 * Stores row and horizontal cursor steps for each name entry character set.
 *
 */
static s16 addTable_1510[5][4] = {
    {-13, 13, -1, 1},
    {-15, 15, -1, 1},
    {-15, 15, -1, 1},
    {-19, 19, -1, 1},
    {-15, 15, -1, 1}
};

/**
 *
 * Maps name entry character sets to command buttons.
 *
 */
static s8 convTbl_1579[5] = {2, 1, 0, 4, 3};

/**
 *
 * Stores the default Spheda name for each language.
 *
 */
static char *Sfida_default_Name[7] = {
    "\x83\x86\x83\x8A\x83X", "Max", "Max", "Max", "Max", "Max", "Max"
};

s32 CNameRegiMenu::KeyStep() {
    s32      keys;
    s32      event;
    s32      pushed;
    CDC2Mes *message;

    event = -1;
    keys = MenuCommonInfo->CheckSelectKey();
    keys = MenuCommonInfo->CheckLRKey();
    pushed = MenuCommonInfo->CheckPushButton();
    message = MenuDCMsg[7];

    switch (mode) {
        case NAMEREGI_MODE_OPEN:
            if (FadeCheckMenu() != 0) {
                mode = NAMEREGI_MODE_INPUT;
                MenuCommonInfo->key_enable = 1;
            }

            break;
        case NAMEREGI_MODE_CLOSE:
            if (FadeCheckMenu() != 0) {
                return 1;
            }

            break;
        case NAMEREGI_MODE_MESSAGE: {
            if (message_type == 0) {
                s32 answer = message->YesNoCursor2(1);

                if (answer == 1) {
                    char converted_name[0x100];
                    event = 0x1FE;
                    MenuSePlay(SYSTEM_SE_DECIDE);

                    if (Nameregi_Target.target == NAMEREGI_TARGET_KEYWORD) {
                        MenuArg.result[0] = 0;
                        event = 1;
                        strcpy(converted_name, name);

                        if (LanguageCode > 0) {
                            CopyJisToAscii(name, converted_name);
                        }

                        if (strcmp(Nameregi_Target.keyword, converted_name) == 0) {
                            MenuArg.result[0] = 1;
                        }

                        if (strcmp(Nameregi_Target.keyword, "SIRUS") == 0 && strcmp(converted_name, "Sirus") == 0) {
                            MenuArg.result[0] = 1;
                        }
                    } else if (Nameregi_Target.target == NAMEREGI_TARGET_FISH) {
                        event = 0x3E8;

                        if (password_input != 0) {
                            event = 1;
                        }
                    } else if (Nameregi_Target.target == NAMEREGI_TARGET_SPHIDA) {
                        event = 1;
                        strcpy(Nameregi_Target.keyword, name);

                        if (LanguageCode > 0) {
                            CopyJisToAscii(name, Nameregi_Target.keyword);
                        }
                    }
                }

                if (answer == 2) {
                    event = 0x1F9;
                    MenuSePlay(SYSTEM_SE_CANCEL);

                    if (Nameregi_Target.target == NAMEREGI_TARGET_KEYWORD) {
                        MenuArg.result[0] = -1;
                    }
                }
            }

            if (message_type == 1 && pushed != 0) {
                event = 1;
                MenuSePlay(SYSTEM_SE_DECIDE);
            }

            s16 message_mode = message_type;

            if (message_mode == 2) {
                if (pushed != 0) {
                    event = 0x1F9;
                }
            }

            if (message_mode == 0xA) {
                s32 answer = message->YesNoCursor2(1);

                if (answer == 1) {
                    event = 1;
                    MenuSePlay(SYSTEM_SE_DECIDE);

                    if (Nameregi_Target.target == NAMEREGI_TARGET_SPHIDA) {
                        Nameregi_Target.keyword[0] = 0;
                    }

                    if (Nameregi_Target.target == NAMEREGI_TARGET_FISH && Nameregi_Target.item != NULL) {
                        Nameregi_Target.item->item_no = -1;
                        Nameregi_Target.item->data.fish.name[0] = 0;
                    }
                }

                if (answer == 2) {
                    event = 0x1F9;
                }
            }

            if (message_type == 0x14) {
                s32 answer = message->YesNoCursor2(1);

                if (answer == 1) {
                    event = 0x83;
                }

                if (answer == 2) {
                    event = 0x1F9;
                }
            }

            message_mode = message_type;

            if ((message_mode == 0x1E || message_mode == 0x28) && pushed != 0) {
                if (message_mode == 0x1E) {
                    mode = NAMEREGI_MODE_INPUT;
                }

                if (message_type == 0x28) {
                    mode = NAMEREGI_MODE_CLOSE;
                    FadeOutMenu(0x28, 0.0f);
                }

                message_open = 0;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }

            break;
        }
        case NAMEREGI_MODE_INPUT: {
            s32  font_mode = GetActiveFontMode();
            s16 *key_table = addTable_1510[font_mode];

            switch (key_arg_no) {
                case 0: {
                    NameCommandTable japanese_navigation = {{-1, 5, 11, 1, -1, 7, 0, 2, -1, 8, 1, 3, -1, 10, 2, 4, -1, 10, 3, 11, 0, -2, 11, 6, 0, -2, 5, 7, 1, -2, 6, 8, 1, -2, 7, 9, 2, -2, 8, 10, 3, -2, 9, 11, -1, -2, 4, 0}};
                    NameCommandTable localized_navigation = {{-1, -1, -1, -1, -1, -1, -1, -1, -1, 5, 11, 3, -1, 8, 2, 10, -1, -1, -1, -1, 2, -2, 11, 6, 2, -2, 5, 8, 10, -2, 9, 11, 2, -2, 6, 9, 3, -2, 8, 7, -1, 7, 3, 11, -1, -2, 10, 2}};
                    s8              *row = &japanese_navigation.bytes[command_pos * 4];

                    if (LanguageCode > 0) {
                        row = &localized_navigation.bytes[command_pos * 4];
                    }

                    s32 direction = -1;

                    if (keys & 1) {
                        direction = 0;
                    }

                    if (keys & 2) {
                        direction = 1;
                    }

                    if (keys & 4) {
                        direction = 2;
                    }

                    if (keys & 8) {
                        direction = 3;
                    }

                    if (0 <= direction) {
                        s8 target = row[direction];

                        if (0 <= target) {
                            command_pos = target;
                            MenuSePlay(SYSTEM_SE_CURSOR);
                        } else if (target == -2) {
                            ConvertPositionNameRegi(0);
                            key_arg_no = 1;

                            if (font_mode == NAMEREGI_FONT_MODE_KANJI) {
                                keys = 2;
                                CheckKanjiPosition(2, key_table, font_mode);
                            }

                            MenuSePlay(SYSTEM_SE_CURSOR);
                            break;
                        }
                    }

                    s16 command_table[12][2] = {
                        {20, 2},
                        {20, 2},
                        {20, 2},
                        {20, 2},
                        {20, 2},
                        {70, 2},
                        {71, 2},
                        {100, 2},
                        {110, 2},
                        {120, 2},
                        {130, 2},
                        {500, 2}
                    };
                    s16 *command_events = command_table[command_pos];

                    if ((pushed & 1) || (pushed & 4)) {
                        event = command_events[0];
                    } else if (pushed & 2) {
                        event = command_events[1];
                    }

                    break;
                }
                case 1: {
                    MENU_SELECT_PARAM *selection = &select;
                    s32                result;
                    s32                previous_position;

                    if (font_mode == NAMEREGI_FONT_MODE_KANJI) {
                        s32 previous_row = selection->row;

                        if ((keys & 0x20) || (keys & 0x80)) {
                            selection->row += 6;
                        }

                        if ((keys & 0x10) || (keys & 0x40)) {
                            selection->row -= 6;
                        }

                        if (selection->row < 0) {
                            selection->row = 0;
                        }

                        s32 last_row = NameRegiMenuPtr->kanji_line_max;

                        if (last_row < selection->row) {
                            selection->row = last_row;
                        }

                        if (previous_row != selection->row) {
                            MenuSePlay(SYSTEM_SE_CURSOR);
                        }
                    }

                    previous_position = selection->pos;
                    result = 0;

                    if (font_mode == NAMEREGI_FONT_MODE_KANJI) {
                        if (keys != 0) {
                            result = nameregist_local_key(selection, keys, key_table, font_mode);

                            if (0 <= result) {
                                result = CheckKanjiPosition(keys, key_table, font_mode);
                            }
                        }
                    } else {
                        result = nameregist_local_key(selection, keys, key_table, font_mode);
                    }

                    if (result == -1) {
                        ConvertPositionNameRegi(1);
                        key_arg_no = 0;
                        MenuSePlay(SYSTEM_SE_CURSOR);
                    } else {
                        if (previous_position != selection->pos) {
                            MenuSePlay(SYSTEM_SE_CURSOR);
                        }

                        if ((pushed & 1) || (pushed & 4)) {
                            event = 5;
                        }

                        if (pushed & 2) {
                            event = 0xB;
                        }
                    }

                    break;
                }
            }

            break;
        }
    }

    switch (event) {
        case 0x14:
            if (password_input != 0) {
                MenuSePlay(SYSTEM_SE_CANCEL);
            } else {
                select_mode = command_pos;
                ChangeFontSelectMode(GetActiveFontMode());
                MenuSePlay(SYSTEM_SE_DECIDE);
            }

            break;
        case 0xA:
            key_arg_no = 1;
            select.row = 0;
            MenuSePlay(SYSTEM_SE_DECIDE);
            break;
        case 0xB:
            key_arg_no = 0;
            command_pos = convTbl_1579[GetActiveFontMode()];
            MenuSePlay(SYSTEM_SE_CANCEL);
            break;
        case 5: {
            union {
                char text[0x20];
                s8   signed_text[0x20];
            } selected_character;

            GetSelectedActiveFont(selected_character.text);
            selected_character.text[2] = 0;

            for (s32 index = 0; index < name_pos; index++) {
                if (name[index] == 0) {
                    name[index] = 0x20;
                }
            }

            name[name_pos] = selected_character.signed_text[0];
            name_pos += 1;

            if (NameRegistMax <= name_pos) {
                name_pos = NameRegistMax - 1;
            }

            MenuSePlay(SYSTEM_SE_DECIDE);
            break;
        }
        case 0x46:
            name_pos -= 1;

            if (name_pos < 0) {
                name_pos = 0;
            }

            button_flash[5] = 8;
            caret_cnt = 0x28;
            MenuSePlay(SYSTEM_SE_DECIDE);
            break;
        case 0x47:
            name_pos += 1;

            if (NameRegistMax <= name_pos) {
                name_pos = NameRegistMax - 1;
            }

            button_flash[6] = 8;
            caret_cnt = 0x28;
            MenuSePlay(SYSTEM_SE_DECIDE);
            break;
        case 0x64: {
            MenuSePlay(SYSTEM_SE_CANCEL);
            s32 index = name_pos;

            if (index != 0) {
                for (; index < NameRegistMax; index++) {
                    name[index - 1] = name[index];
                }

                name[NameRegistMax - 1] = 0;
                button_flash[7] = 8;
                name_pos -= 1;

                if (name_pos < 0) {
                    name_pos = 0;
                }

                caret_cnt = 0x28;
            }

            break;
        }
        case 0x6E: {
            s32 index = name_pos;

            for (; index < NameRegistMax; index++) {
                name[index] = name[index + 1];
            }

            name[NameRegistMax] = 0;
            button_flash[8] = 8;
            caret_cnt = 0x28;
            MenuSePlay(SYSTEM_SE_CANCEL);
            break;
        }
        case 0x78: {
            s32 index = NameRegistMax;

            for (; name_pos <= index; index--) {
                name[index + 1] = name[index];
            }

            name[name_pos] = 0x20;
            name[NameRegistMax] = 0;
            button_flash[9] = 8;
            caret_cnt = 0x28;
            MenuSePlay(SYSTEM_SE_DECIDE);
            break;
        }
        case 0x82:
            if (Nameregi_Target.target == NAMEREGI_TARGET_FISH) {
                MenuSePlay(SYSTEM_SE_CANCEL);
            } else {
                mode = NAMEREGI_MODE_MESSAGE;
                message_open = 1;
                message_type = 0x14;
                message->MsgPreset(0xB);
                message->SetAbsPos(5);
                message->SetMsgCursor(0);
                message->MakeMsg(0x1007);
                NameMessageArguments arguments = {{NULL, NULL}};

                if (Nameregi_Target.target == NAMEREGI_TARGET_ITEM) {
                    arguments.name[0] = GetItemMessage(Nameregi_Target.item->item_no);
                }

                if (Nameregi_Target.target == NAMEREGI_TARGET_ROBO) {
                    arguments.name[0] = GetUserDataMan()->GetRoboNameDefault();
                }

                if (Nameregi_Target.target == NAMEREGI_TARGET_KEYWORD) {
                    message->MakeMsg(0x1008);
                }

                if (Nameregi_Target.target == NAMEREGI_TARGET_SPHIDA) {
                    arguments.name[0] = NULL;
                    message->MakeMsg(0x101B);
                }

                message->SetMsgItemNo(arguments.name, 2);
                MenuSePlay(SYSTEM_SE_DECIDE);
            }

            break;
        case 0x83:
            message_open = 0;
            mode = NAMEREGI_MODE_INPUT;
            MenuSePlay(SYSTEM_SE_DECIDE);
            memset(name, 0, 0x61);

            if (Nameregi_Target.target == NAMEREGI_TARGET_KEYWORD) {
                name_pos = 0;
            } else if (Nameregi_Target.target == NAMEREGI_TARGET_SPHIDA) {
                strcpy(name, Sfida_default_Name[LanguageCode]);
                name_pos = strlen(name);
            } else {
                strcpy(name, message->name[0]);

                if (LanguageCode > 0) {
                    NameRegiMenuPtr->CopyAsciiToJis(message->name[0], name);
                }

                name_pos = strlen(name);
            }

            break;
        case 0x1FE: {
            char final_name[0x80];

            strcpy(final_name, name);

            if (Nameregi_Target.target == NAMEREGI_TARGET_ITEM) {
                if (LanguageCode > 0 && Nameregi_Target.item != NULL && Nameregi_Target.item->used_type == 3 &&
                    Nameregi_Target.item->IsFishingRod() == 0) {
                    char ascii[0x80];
                    s32  item_no;
                    CopyJisToAscii(name, ascii);
                    item_no = SearchItemByName(ascii);

                    if (item_no == 0x12E || item_no == 0x12F) {
                        message_type = 0x1E;
                        message->MsgPreset(0xA);
                        message->SetAbsPos(5);
                        message->MakeMsg(0xFD4);
                        break;
                    }

                    if (ConvertUsedItemType(GetItemDataType(item_no)) == 3) {
                        Nameregi_Target.item->CopyDataWeapon(item_no);
                    }
                }

                if (CheckDeleteNameRegisteItem(Nameregi_Target.item) != 0) {
                    GetUserDataMan()->DeleteItem(0x180, 1);
                }

                if (LanguageCode > 0) {
                    CopyJisToAscii(name, final_name);
                }

                Nameregi_Target.item->SetName(final_name);
                Nameregi_Target.item->rename_flag = 1;
            }

            if (Nameregi_Target.target == NAMEREGI_TARGET_ROBO) {
                GetUserDataMan()->SetRoboName(final_name);
            }

            if (Nameregi_Target.target == NAMEREGI_TARGET_SPHIDA) {
                if (LanguageCode > 0) {
                    CopyJisToAscii(name, final_name);
                }

                strcpy(Nameregi_Target.keyword, final_name);
            }

            message_type = 1;
            message->MsgPreset(0xA);
            message->SetAbsPos(5);
            message->MakeMsg(0x1006);
            NameMessageArguments arguments = {{NULL, NULL}};
            arguments.name[0] = old_name;
            arguments.name[1] = final_name;
            message->SetMsgItemNo(arguments.name, 2);
            break;
        }
        case 0x1F4: {
            s32 message_id;
            CheckInputWord(name);

            if ((s32) strlen(name) <= 0) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                break;
            }

            message_id = 0x1005;

            if (Nameregi_Target.target == NAMEREGI_TARGET_FISH) {
                message_id = 0x1010;

                if (password_input != 0) {
                    char password[0x30];
                    u8   decoded[0x20];
                    u16  header[7];
                    u8  *key_text;
                    s32  password_valid;
                    ConvertShitJiss2Ascii(name, password);
                    PasswordKey key = {{0}};
                    password[0x16] = 0;
                    strcpy((char *) key.bytes, Nameregi_Target.item->GetName(0));
                    key_text = key.bytes;
                    password_valid = DecodePassword(password, (u8 *)decoded, 0x10, (u8 *)key_text, 0x14);
                    memcpy(header, decoded, 0xE);

                    if (password_valid == 0 || (header[0] & 0x1FF) < 0x136) {
                        mode = NAMEREGI_MODE_MESSAGE;
                        message_open = 1;
                        message_type = 0x1E;
                        message->MsgPreset(0xA);
                        message->SetAbsPos(5);
                        message->ClsMes::mes_no = -1;
                        message->MakeMsg(0x1011);
                        message->SetMsgCursor(-1);
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    } else {
                        Nameregi_Target.item->Init();
                        Nameregi_Target.item->used_type = 6;
                        Nameregi_Target.item->SetName((char *) key_text);
                        Nameregi_Target.item->TransToData((char *) decoded, 0xE);
                        MenuSePlay(SYSTEM_SE_DECIDE);
                        mode = NAMEREGI_MODE_MESSAGE;
                        message->MsgPreset(0xA);
                        message->SetAbsPos(5);
                        message->ClsMes::mes_no = -1;
                        message_type = 0x28;
                        message_open = 1;
                        Nameregi_Target.item->TransToData((char *) decoded, 0xE);
                        message->MakeMsg(0x1012);

                        if (key_text != NULL) {
                            strcpy(message->name[0], (char *) key_text);
                        }
                    }

                    break;
                }
            } else if (Nameregi_Target.target == NAMEREGI_TARGET_SPHIDA) {
                message_id = 0x101A;
            } else if (Nameregi_Target.target != NAMEREGI_TARGET_KEYWORD) {
                char candidate_name[0x80];
                strcpy(candidate_name, name);

                if (LanguageCode > 0) {
                    CopyJisToAscii(name, candidate_name);
                }

                if (strcmp(candidate_name, old_name) == 0) {
                    mode = NAMEREGI_MODE_MESSAGE;
                    message_open = 1;
                    message_type = 0xA;
                    message->MsgPreset(0xB);
                    message->SetAbsPos(5);
                    message->SetMsgCursor(0);
                    message->MakeMsg(0xFDC);
                    NameMessageArguments arguments = {{NULL, NULL}};
                    arguments.name[0] = old_name;
                    message->SetMsgItemNo(arguments.name, 2);
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    break;
                }
            } else {
                message_id = 0x1004;
                MenuArg.end_code = 0xE;
            }

            {
                char display_name[0x80];
                mode = NAMEREGI_MODE_MESSAGE;
                message_type = 0;
                message_open = 1;
                message->MsgPreset(0xB);
                message->SetAbsPos(5);
                message->SetMsgCursor(1);
                message->MakeMsg(message_id);
                NameMessageArguments arguments = {{NULL, NULL}};
                arguments.name[0] = name;

                if (LanguageCode > 0) {
                    CopyJisToAscii(name, display_name);
                    arguments.name[0] = display_name;
                }

                message->SetMsgItemNo(arguments.name, 1);
                MenuSePlay(SYSTEM_SE_DECIDE);
            }
            break;
        }
        case 0x1F9:
            mode = NAMEREGI_MODE_INPUT;
            message_open = 0;
            MenuSePlay(SYSTEM_SE_CANCEL);
            break;
        case 2:
            if (Nameregi_Target.target == NAMEREGI_TARGET_KEYWORD) {
                message_type = 0xA;
                message_open = 1;
                MenuArg.end_code = 0;
                message->MsgPreset(0xB);
                message->SetAbsPos(5);
                message->SetMsgCursor(1);
                mode = NAMEREGI_MODE_MESSAGE;
                message->MakeMsg(0xFB4);
                MenuSePlay(SYSTEM_SE_CANCEL);
            } else {
                mode = NAMEREGI_MODE_MESSAGE;
                message_type = 0xA;
                message_open = 1;
                message->MsgPreset(0xB);
                message->SetAbsPos(5);
                message->SetMsgCursor(1);
                message->MakeMsg(0xFDC);
                NameMessageArguments arguments = {{NULL, NULL}};
                arguments.name[0] = old_name;
                message->SetMsgItemNo(arguments.name, 1);
                MenuSePlay(SYSTEM_SE_CANCEL);

                if (Nameregi_Target.target == NAMEREGI_TARGET_SPHIDA) {
                    message->MsgPreset(0xB);
                    message->SetAbsPos(5);
                    message->MakeMsg(0x1019);
                    message->SetMsgCursor(1);
                } else if (Nameregi_Target.target == NAMEREGI_TARGET_FISH) {
                    message->MsgPreset(0xB);
                    message->SetAbsPos(5);
                    message->MakeMsg(0x1013);
                    message->SetMsgCursor(1);
                }
            }

            break;
        case 0x3E8: {
            if (Nameregi_Target.target == NAMEREGI_TARGET_FISH) {
                Nameregi_Target.item->item_no = 0x140;
                Nameregi_Target.item->used_type = 6;

                if (LanguageCode > 0) {
                    char backup[0x40];
                    strcpy(backup, name);
                    CopyJisToAscii(backup, name);
                }

                Nameregi_Target.item->SetName(name);
            }

            MenuDCMsg[6]->MakeMsg(0x100F);
            CDC2Mes *name_window = MenuDCMsg[6];
            char    *name_text = name;

            if (name_text != NULL) {
                strcpy(name_window->name[0], name_text);
            }

            AdjustWaku(MenuDCMsg[6], &NameRegiMenuPtr->waku);
            memset(name, 0, 0x61);
            name_pos = 0;
            password_input = 1;
            command_pos = 2;
            select_mode = command_pos;
            ChangeFontSelectMode(GetActiveFontMode());
            NameRegistMax = 0x16;
            mode = NAMEREGI_MODE_INPUT;
            step = 0;
            message_open = 0;
            break;
        }
        case 1:
            mode = NAMEREGI_MODE_CLOSE;
            FadeOutMenu(0x28, 0.0f);
            break;
    }

    caret_cnt += 1;

    if (caret_cnt >= 0x50) {
        caret_cnt = 0;
    }

    wave_angle += 0.06981317f;

    if (!(wave_angle <= 3.1415927f)) {
        wave_angle -= 6.2831855f;
    }

    StepMarkCursor();
    MenuDCMsg[6]->StepMsg();
    message->StepMsg();
    return 0;
}

void CNameRegiMenu::GetSelectedActiveFont(char *dst) {
    int font_mode = GetActiveFontMode();
    char *first_table = NameRegistFont_Table[font_mode].first;
    char *second_table = NameRegistFont_Table[font_mode].second;
    char *third_table = NameRegistFont_Table[font_mode].third;
    char *table = first_table;
    s16 cell = select.pos;
    if (font_mode == NAMEREGI_FONT_MODE_HIRA || font_mode == NAMEREGI_FONT_MODE_KATA) {
        int rest;
        int column;
        int part;
        rest = cell % 15;
        column = cell / 15;
        part = rest / 5;
        char *kana_tables[3] = { first_table, second_table, third_table };
        table = kana_tables[part];
        rest -= part * 5;
        char *glyph = table + (column + 2 * (rest + column * 5));
        dst[0] = glyph[0];
        dst[1] = glyph[1];
    }
    if (font_mode == NAMEREGI_FONT_MODE_ALPHA) {
        table = first_table;
        auto column = cell % 13;
        int line = cell / 13;
        if (cell >= 26 && cell < 52) {
            table = second_table;
            line -= 2;
        }
        if (cell >= 52) {
            table = third_table;
            line -= 4;
        }
        __typeof__(line * 13 + column) line_start = line * 13 + column;
        __typeof__(line + (line_start)) glyph_index = line + (line_start);
        dst[0] = table[glyph_index];
    }
    if (font_mode == NAMEREGI_FONT_MODE_KANJI) {
        GetNameRegistFontKanjiList(select.pos + select.row * 0x13, dst);
    }
    if (font_mode == NAMEREGI_FONT_MODE_KIGOU) {
        __typeof__(cell % 15) column = cell % 15;
        int line = cell / 15;
        if (line >= 2) {
            table = second_table;
            line -= 2;
        }
        __typeof__((unsigned int)line + (column + (line * 16 - line))) glyph_index = (unsigned int)line + (column + (line * 16 - line));
        dst[0] = table[glyph_index];
    }
}
void CNameRegiMenu::ChangeFontSelectMode(int mode) {
    if (mode < 0 || mode >= 5) {
        return;
    }

    int spacing_x = 0x18;
    int spacing_y = spacing_x;

    if (mode == 3) {
        spacing_x = 0x16;
    }

    if (mode == 0) {
        spacing_x = 0x30;
        spacing_y = 0x18;
    }

    if (mode == 4) {
        spacing_x = 0x30;
        spacing_y = 0x18;
    }

    grid_font[0].Init();
    grid_font[0].SetFuchi(5);
    grid_font[0].SetColor(0x80686A6BU);
    grid_font[0].SetClearance(spacing_x, spacing_y);
    grid_font[0].offset_x = 0.0f;
    grid_font[0].offset_y = 0.0f;
}

int ConvertNameRegiBaseBoardTable(int index) {
    int result = convtbl_1792.slot[index];

    if (LanguageCode > 0) {
        BoardTable alternate = {{0, 0, 0, 0, 4}};
        result = alternate.slot[index];
    }

    return result;
}

void CNameRegiMenu::DrawBaseBoard() {
    mgRect<int>  tile;
    mgRect<int>  put_rect;
    mgRect<int>  tex_rect;
    mgRect<int>  mode_tex;
    mgRect<int>  extra_tex;
    mgRect<int>  button_tex;
    mgRect<int>  arrow_tex;
    mgRect<int>  arrow_tex_right;
    mgCDrawPrim *prim = GetMenuPrim();

    if (NameRegiBGTile != NULL) {
        MenuReloadTexture(OldReloadTexNumber, NameRegiBGTile->block);
        tile.Set(0x180, 0x100, 0x80, 0x80);
        DrawMenuTilePattern(prim, NameRegiBGTile, tile_scroll, tile_scroll, tile, 0, NULL);
        tile_scroll += 0.5f;

        if (tile_scroll >= 0.0f) {
            tile_scroll -= (float) tile.right;
        }
    }

    if (NameRegiTex1 != NULL) {
        MenuReloadTexture(OldReloadTexNumber, NameRegiTex1->block);
        s16 board_heights[4] = {100, 0, 32, 0};
        board_heights[1] = 0x80;
        int put_x = 0x13;
        int put_y = 0xA9;
        int tex_y = 0;
        int pass = 0;

        do {
            int part = 0;

            do {
                tex_rect.Set(0, tex_y, 0x1E0, get_Htable_1806[part]);
                put_rect.Set(put_x, put_y, 0x1E0, board_heights[part]);
                PrimQuad(NameRegiTex1, put_rect, tex_rect, colt_1808[pass].a, colt_1808[pass].r, colt_1808[pass].g, colt_1808[pass].b);
                put_y += board_heights[part];
                tex_y += get_Htable_1806[part];
                part++;
            } while (part < 3);

            tex_y = 0;
            put_x = 0x10;
            put_y = 0xA6;
            pass++;
        } while (pass < 2);

        int         font_mode = GetActiveFontMode();
        BoardRect  *mode_rect = &table_1819[LanguageCode][font_mode];
        BoardPoint *mode_pos = &nameregist_baseboard_upper_table[0][ConvertNameRegiBaseBoardTable(font_mode)];

        if (LanguageCode > 0) {
            mode_pos += 12;
        }

        mode_tex.Set(mode_rect->x, mode_rect->y, mode_rect->w, mode_rect->h);
        PrimQuad(NameRegiTex1, (float) (mode_pos->x + 0x10), (float) (mode_pos->y + 0xA6), mode_tex, 0x80, 0x80, 0x80, 0x80);

        if (LanguageCode <= 0) {
            extra_tex.Set(0x58, 0x144, 0x58, 0x1E);
            PrimQuad(NameRegiTex1, (float) (nameregist_baseboard_upper_table[LanguageCode][10].x + 0x10), (float) (nameregist_baseboard_upper_table[LanguageCode][10].y + 0xA6), extra_tex, 0x80, 0x80, 0x80, 0x80);
        }

        int button = 5;

        do {
            if (0 < button_flash[button]) {
                BoardPoint *button_pos = &nameregist_baseboard_upper_table[LanguageCode][button];
                BoardRect  *button_rect = &tex_commtbl_1822[LanguageCode][button - 5];
                button_tex.Set(button_rect->x, button_rect->y, button_rect->w, button_rect->h);
                PrimQuad(NameRegiTex1, (float) (button_pos->x + 0x10), (float) (button_pos->y + 0xA6), button_tex, 0x80, 0x80, 0x80, 0x80);
                button_flash[button]--;
            }

            button++;
        } while (button < 11);

        if (key_arg_no == 1 && font_mode == NAMEREGI_FONT_MODE_KANJI) {
            float arrow_y = 246.0f + 6.0f * sinf(wave_angle);

            if (NameregiGaiji != NULL) {
                MenuReloadTexture(OldReloadTexNumber, NameregiGaiji->block);
                arrow_tex.Set(0x20, 0x84, 0x20, 0x16);
                PrimQuad(NameregiGaiji, 16.0f, arrow_y, arrow_tex, 0x80, 0x80, 0x80, 0x80);
                arrow_tex_right.Set(0x40, 0x84, 0x20, 0x16);
                PrimQuad(NameregiGaiji, (float) (mgScreenWidth - 0x2A), arrow_y, arrow_tex_right, 0x80, 0x80, 0x80, 0x80);
            }
        }
    }
}
void CNameRegiMenu::DrawActiveFont() {
    struct KanjiMark { int x; int y; };
    KanjiMark marks[20];
    char glyphs[20][3];
    char line[0x40];
    int mark_num;
    int y;
    int font_mode;
    CFont *font;
    mgRect<int> mark_rect;
    FontTables *tables;
    y = 0x104;
    font_mode = GetActiveFontMode();
    if (NameregiGaiji != NULL) {
        MenuReloadTexture(OldReloadTexNumber, NameregiGaiji->block);
    }
    font = &grid_font[0];
    tables = &NameRegistFont_Table[font_mode];
    if (key_arg_no == 1) {
        DrawMenuFillBox(select_box_x, select_box_y, 14.0f, 21.0f, 0x40, 0x80, 0x20, 0x20);
    }
    switch (font_mode) {
        case NAMEREGI_FONT_MODE_HIRA:
        case NAMEREGI_FONT_MODE_KATA:
            font->SetPos(0x3E, 0x104);
            font->SetStr(tables->first);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetPos(0xC6, 0x104);
            font->SetStr(tables->second);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetPos(0x14E, 0x104);
            font->SetStr(tables->third);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            break;
        case NAMEREGI_FONT_MODE_ALPHA:
            font->SetPos(0x64, 0x110);
            font->SetStr(tables->first);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetPos(0x64, 0x140);
            font->SetStr(tables->second);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetPos(0x64, 0x170);
            font->SetStr(tables->third);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            break;
        case NAMEREGI_FONT_MODE_KANJI: {
            mark_num = 0;
            int cell = select.row * 0x13;
            line[0x26] = 0;
            int column = 0;
            line[0x27] = 0;
            if (cell < 0x672) {
                do {
                    char *glyph = &line[column];
                    int kind = GetNameRegistFontKanjiList(cell, glyph);
                    if (kind == 0) {
                        column += 2;
                    } else if (kind == 1) {
                        marks[mark_num].x = (cell % 0x13) * 0x16 + 0x2E;
                        marks[mark_num].y = y - 3;
                        glyphs[mark_num][0] = glyph[0];
                        glyphs[mark_num][1] = glyph[1];
                        glyphs[mark_num][2] = 0;
                        mark_num++;
                        column += 2;
                    } else if (kind == 2) {
                        column += 2;
                    } else {
                        glyph[0] = 0;
                        font->SetStr(line);
                        font->SetPos(0x34, y);
                        font->DrawDirect(font->str, font->pos_x, font->pos_y);
                        break;
                    }
                    cell++;
                    if (column >= 0x26) {
                        font->SetStr(line);
                        font->SetPos(0x34, y);
                        font->DrawDirect(font->str, font->pos_x, font->pos_y);
                        y += 0x18;
                        column = 0;
                        if (y >= 0x194) {
                            break;
                        }
                    }
                } while (cell < 0x672);
            }
            MenuReloadTexture(OldReloadTexNumber, NameRegiTex1->block);
            int mark = 0;
            if (0 < mark_num) {
                do {
                    mgRect<int> mark_tex;
                    mark_rect.Set(marks[mark].x, marks[mark].y, 0x1A, 0x19);
                    mark_tex.Set(0x1E2, 0, 0x1E, 0x1C);
                    PrimQuad(NameRegiTex1, mark_rect, mark_tex, 0x80, 0x80, 0x80, 0x80);
                    mark++;
                } while (mark < mark_num);
            }
            if (NameregiGaiji != NULL) {
                MenuReloadTexture(OldReloadTexNumber, NameregiGaiji->block);
                int i = 0;
                int glyph_x;
                if (0 < mark_num) {
                    do {
                        int glyph_y = marks[i].y + 3;
                        glyph_x = marks[i].x + 6;
                        font->SetStr(glyphs[i]);
                        font->SetPos(glyph_x, glyph_y);
                        font->DrawDirect(font->str, font->pos_x, font->pos_y);
                        i++;
                    } while (i < mark_num);
                }
            }
            break;
        }
        case NAMEREGI_FONT_MODE_KIGOU:
            font->SetPos(0x52, 0x104);
            font->SetStr(tables->first);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetPos(0x52, 0x134);
            font->SetStr(tables->second);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            break;
    }
}
#pragma divbyzerocheck on
void CNameRegiMenu::StepMarkCursor() {
    float target_x = 0.0f;
    float target_y = 0.0f;
    switch (key_arg_no) {
    case 0: {
        int button = command_pos;
        int language = 0;
        int slot = button;
        if (LanguageCode > 0) {
            language = 1;
            if (button == 2) {
                slot = 0;
            }
            if (button == 3) {
                slot = 4;
            }
        }
        target_x = (18.0f + (float)nameregist_baseboard_upper_table[language][slot].x) - 32.0f;
        target_y = 5.0f + (166.0f + (float)nameregist_baseboard_upper_table[language][slot].y);
        if (button == 0xB) {
            target_y += 5.0f;
        }
        break;
    }
    case 1: {
        MENU_SELECT_PARAM *param = &select;
        int font_mode = GetActiveFontMode();
        int column = param->pos % NameRegistGyouLimmitTable[font_mode];
        int line = param->pos / NameRegistGyouLimmitTable[font_mode];
        if (font_mode == NAMEREGI_FONT_MODE_HIRA || font_mode == NAMEREGI_FONT_MODE_KATA) {
            target_x = (float)(column * 0x18 + 0x3E + column / 5 * 0x10);
            target_y = (float)(0x104 + line * 0x18);
        }
        if (font_mode == NAMEREGI_FONT_MODE_KANJI) {
            target_x = (float)(0x34 + 0x16 * column);
            target_y = (float)(line * 0x18 + 0x104);
        }
        if (font_mode == NAMEREGI_FONT_MODE_ALPHA) {
            target_x = (float)(column * 0x18 + 0x64);
            target_y = (float)(line * 0x18 + 0x110);
        }
        if (NAMEREGI_FONT_MODE_KIGOU == font_mode) {
            target_x = (float)(column * 0x18 + 0x52);
            target_y = (float)(line * 0x18 + 0x104);
        }
        target_x -= 2.0f;
        select_box_x = target_x;
        target_x -= 36.0f;
        select_box_y = target_y;
        break;
    }
    }
    CalcMenu1(target_x, &cursor_x, 4.0f, 0.0f, cursor_snap);
    CalcMenu1(target_y, &cursor_y, 4.0f, 0.0f, cursor_snap);
    cursor_snap = 0;
    if (mode != NAMEREGI_MODE_MESSAGE) {
        cursor_cnt++;
    }
}
#pragma divbyzerocheck reset
void CNameRegiMenu::DrawMarkCursor() {
    float pos[2];
    pos[0] = cursor_x + 6.0f * cosf(mgAngleLimit(0.05235988f * (float) cursor_cnt));
    pos[1] = cursor_y + 4.0f * sinf(mgAngleLimit(0.10471976f * (float) cursor_cnt));
    MenuCursorDraw(NameRegiCursor, pos, 0.0f, 0, 0x80, 0.8f);
}

void CNameRegiMenu::DrawSelectedWord() {
    mgRect<int> shadow;
    mgRect<int> frame;
    MenuReloadTexture(OldReloadTexNumber, NameRegiTex1->block);
    int          box_width = NameRegistMax * 0xC + 0x3E;
    int          box_left = (mgScreenWidth - box_width) >> 1;
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(NameRegiTex1);
    prim->Color(0, 0, 0, 0x33);
    shadow.Set(box_left + 3, 0x59, box_width, gettbl0_2012[3]);
    Menu3DivideTextureDraw(prim, shadow, gettbl0_2012, 1);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    frame.Set(box_left, 0x56, box_width, gettbl0_2012[3]);
    Menu3DivideTextureDraw(prim, frame, gettbl0_2012, 1);
    prim->End();
    int underscore_x = box_left + 0x20;
    SetSpriteEnv(prim, 2);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Color(0xFA, 0xFA, 0xFA, 0x40);
    int i = 0;

    while (i < NameRegistMax) {
        prim->Vertex(underscore_x, 0x7F, 0);
        prim->Vertex(underscore_x + 8, 0x81, 0);
        underscore_x += 0xC;
        i++;
    }

    prim->End();
    int cursor_alpha = 0x60;

    if (caret_cnt % 80 < 0x28) {
        cursor_alpha = 0;
    }

    int cursor_left = box_left + 0x1E + name_pos * 0xC;
    prim->Begin(MG_PRIM_SPRITE);
    prim->Color(0xDC, 0xDC, 0xDC, cursor_alpha);
    prim->Vertex(cursor_left, 0x65, 0);
    prim->Vertex(cursor_left + 0xC, 0x7C, 0);
    prim->End();
    MenuReloadTexture(OldReloadTexNumber, MenuArg.mes_tex_block);
    name_font.SetPos(box_left + 0x1F, 0x67);
    name_font.SetStr(name);
    CFont *font = &name_font;
    font->DrawDirect(font->str, font->pos_x, font->pos_y);
}

void CNameRegiMenu::DrawMessage() {
    MenuReloadTexture(OldReloadTexNumber, MenuDCMsg[6]->texture_block);
    mgCDrawPrim prim;
    SetSpriteEnv(&prim, 0);
    RGBAQ_TYPE color = {0x80, 0x80, 0x80, 0x80, 0x3F800000};
    DrawVersatileWin_1(&prim, waku, &color, 0x80);
    (MenuDCMsg[6])->DrawMsg();

    if (message_open != 0) {
        DrawMenuFillBox(0.0f, 0.0f, (float) mgScreenWidth, (float) mgScreenHeight, 0x40, 0, 0,
                        0);
        (MenuDCMsg[7])->DrawMsg();
    }
}

// Uninitialised data (.bss)
/**
 *
 * Stores the target and keyword for the name entry screen.
 *
 */
NAMEREGI_TARGET_INFO Nameregi_Target;
