#include "common.h"
#include "nameregi.hpp"
#include "menuaqua.hpp"
#include "mglib.hpp"
#include "menumain.hpp"
#include "font.hpp"
#include "menucls1.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_memory.hpp"
#include "mainloop.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "drawwin.hpp"
#include "nd_meswin.hpp"
#include "mg_math.hpp"
#include <cstring>
#include <cmath>

struct BoardTable {
    s8 slot[5];
};
struct PositionTable {
    s8 index[3][5][12];
};
extern char NameRegiTopic[0x40];
extern s8 NameRegiCode;
extern s8 NameStrSelectModeTable[7][6];
extern NAMEREGI_KANJI_INDEX NameRegiSearchKanjiIndexTable[0x2C];
extern s8 testchar[0x2C][2];
extern s8 txt_table[0x3B];
extern CNameRegiMenu *NameRegiMenuPtr;
extern int OldReloadTexNumber;
extern s16 LimmitTable_1360[5];
extern PositionTable at_1377__5;
extern s8 NameRegistGyouLimmitTable[5];
extern s8 Convtable2_1382[2][5][8];
extern BoardTable convtbl_1792;
extern BoardTable at_1795;
extern mgCTexture *NameRegiCursor;
extern mgCTexture *NameRegiTex1;
extern s16 NameRegistMax;
extern s16 gettbl0_2012[12];
extern s64 at_2031__3;
extern CNameRegiMenu *NameRegiMenuPtr;

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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", CheckDeleteNameRegisteItem__FP13CGameDataUsed);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", CopyAsciiToJis__13CNameRegiMenuFPcPc);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", CopyJisToAscii__13CNameRegiMenuFPcPc);
int CheckChronicleKanjiFont(mgCMemory *memory) {
    char name[3];
    int total;
    int row;
    int row_offset;
    if (memory == NULL) {
        return 0;
    }
    name[2] = 0;
    total = 0;
    row = 0;
    row_offset = 0;
    do {
        NAMEREGI_KANJI_INDEX *current;
        NAMEREGI_KANJI_NODE *node;
        NAMEREGI_KANJI_NODE *previous;
        u8 high;
        u8 low;
        int i;
        NAMEREGI_KANJI_INDEX *next;
        int count;
        node = NULL;
        previous = NULL;
        count = 0;
        i = 0;
        current = (NAMEREGI_KANJI_INDEX *)((u8 *)NameRegiSearchKanjiIndexTable + row_offset);
        next = &NameRegiSearchKanjiIndexTable[row + 1];
        current->list = NULL;
        high = (u8)current->code[0];
        low = (u8)current->code[1];
        do {
            name[0] = high;
            name[1] = low;
            if (0 <= GetFontNo(name)) {
                if (current->list == NULL) {
                    current->list = (NAMEREGI_KANJI_NODE *)memory->Alloc(1);
                    node = current->list;
                } else {
                    previous->next = (NAMEREGI_KANJI_NODE *)memory->Alloc(1);
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
            if ((u8)next->code[0] == high && (u8)next->code[1] == low) {
                break;
            }
            i++;
        } while (i < 0x200);
        if (node != NULL) {
            node->next = NULL;
        }
        current->num = count;
        total += count;
        row_offset += 0x10;
        row++;
    } while (row < 0x2C);
    return total;
}
int GetNameRegistFontKanjiList(int font_index, char *out) {
    s8 *dst = (s8 *)out;
    int position = 0;
    int row = 0;
    NAMEREGI_KANJI_NODE *node;
    int offset = 0;
    do {
        if (position == font_index) {
            out[0] = testchar[row][0];
            out[1] = testchar[row][1];
            return 1;
        }
        node = ((NAMEREGI_KANJI_INDEX *)((u8 *)NameRegiSearchKanjiIndexTable + offset))->list;
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
            dst[0] = -0x7F;
            dst[1] = 0x40;
            return 2;
        }
        row++;
        position++;
        offset += 0x10;
    } while (row < 0x2C);
    return -1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", AdjustWaku__FP7CDC2MesP4RECT);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", search_txt_jis__FPc);
int search_txt_asci(char *text) {
    s8 *ch = (s8 *)text;
    int i = 0;
    do {
        if (*ch == txt_table[i]) {
            return i;
        }
        i++;
    } while (i < 0x3A);
    return -1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", ConvertShitJiss2Ascii__FPcPc);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", ConvertAscii2ShitJiss__FPcPc);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", NameRegistInit__FP9mgCMemoryPii);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", CheckInputWord__FPc);
#pragma divbyzerocheck on
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
#pragma divbyzerocheck reset
#pragma divbyzerocheck on
void CNameRegiMenu::ConvertPositionNameRegi(int mode) {
    int font_mode = GetActiveFontMode();
    if (mode == 0) {
        int col = command_pos;
        PositionTable table = at_1377__5;
        int language = LanguageCode;
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
#pragma divbyzerocheck reset
int CNameRegiMenu::CheckKanjiPosition(int position, s16 *keys, int key_mode) {
    MENU_SELECT_PARAM *param = &select;
    int result = 0;
    char cell[4];
    cell[2] = 0;
    int kind = GetNameRegistFontKanjiList(select.pos + kanji_line * 0x13, cell);
    while (kind != 0 && kind != 1) {
        result = nameregist_local_key(param, position, keys, key_mode);
        if (result == -1) {
            break;
        }
        kind = GetNameRegistFontKanjiList(param->pos + kanji_line * 0x13, cell);
        if (kind < 0) {
            position = 1;
            while (kind != 0 && kind != 1) {
                result = nameregist_local_key(param, position, keys, key_mode);
                if (result == -1) {
                    break;
                }
                kind = GetNameRegistFontKanjiList(param->pos + kanji_line * 0x13, cell);
            }
            break;
        }
    }
    return result;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", KeyStep__13CNameRegiMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", GetSelectedActiveFont__13CNameRegiMenuFPc);
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
    grid_font[0].unk_b0 = 0.0f;
    grid_font[0].unk_b4 = 0.0f;
}
int ConvertNameRegiBaseBoardTable(int index) {
    s8 result = convtbl_1792.slot[index];
    if (LanguageCode > 0) {
        BoardTable alternate = at_1795;
        result = alternate.slot[index];
    }
    return result;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", DrawBaseBoard__13CNameRegiMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", DrawActiveFont__13CNameRegiMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", StepMarkCursor__13CNameRegiMenuFv);
void CNameRegiMenu::DrawMarkCursor() {
    float pos[2];
    pos[0] = cursor_x + 6.0f * cosf(mgAngleLimit(0.05235988f * (float)cursor_cnt));
    pos[1] = cursor_y + 4.0f * sinf(mgAngleLimit(0.10471976f * (float)cursor_cnt));
    MenuCursorDraw(NameRegiCursor, pos, 0.0f, 0, 0x80, 0.8f);
}
void CNameRegiMenu::DrawSelectedWord() {
    mgRect<int> shadow;
    mgRect<int> frame;
    MenuReloadTexture(OldReloadTexNumber, *(s16 *)NameRegiTex1);
    int box_width = NameRegistMax * 0xC + 0x3E;
    int box_left = (mgScreenWidth - box_width) >> 1;
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
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
    prim->Begin(6);
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
    prim->Begin(6);
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
    RGBAQ_TYPE color;
    mgCDrawPrim prim;
    MenuReloadTexture(OldReloadTexNumber, *(int *)((u8 *)MenuDCMsg[6] + 0x22A4));
    SetSpriteEnv(&prim, 0);
    *(s64 *)&color = at_2031__3;
    DrawVersatileWin_1(&prim, waku, &color, 0x80);
    (MenuDCMsg[6])->DrawMsg();
    if (message_open != 0) {
        DrawMenuFillBox(0.0f, 0.0f, (float)mgScreenWidth, (float)mgScreenHeight, 0x40, 0, 0,
                                   0);
        (MenuDCMsg[7])->DrawMsg();
    }
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nameregi", __sinit_nameregi_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", Sfida_default_Name__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", ALPHA_TABLE1__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", ALPHA_TABLE2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", STR_NUM_TABLE__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", KIGOU_TABLE_ASCII1__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", KIGOU_TABLE_ASCII2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", ascii_code_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", NameRegistFont_Table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", NameStrSelectModeTable__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", NameRegiSearchKanjiIndexTable__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", testchar__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", txt_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", txt_table2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1153__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", LimmitTable_1360__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1377__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", Convtable2_1382__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", addTable_1510__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1513__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1514__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1534__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", nameregist_baseboard_upper_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", colt_1808__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", table_1819__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", tex_commtbl_1822__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", gettbl0_2012__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_892__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_893__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1281__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1282__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1283__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1284__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1285__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1286__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1287__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1288__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1747__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1748__2__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", D_0037B084__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", __vt__13CNameRegiMenu__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", NameRegistMax__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", HIRA_TABLE1__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", HIRA_TABLE2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", HIRA_TABLE3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", KATA_TABLE1__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", KATA_TABLE2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", KATA_TABLE3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", KIGOU_TABLE1__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", KIGOU_TABLE2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", jis_ptr_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", NameRegistGyouLimmitTable__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1081__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", convTbl_1579__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", convtbl_1792__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1795__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", get_Htable_1806__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_1807__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nameregi", at_2031__3__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(NameRegiCode, 0x4);
INCLUDE_BSS(NameRegiMenuPtr, 0x4);
INCLUDE_BSS(OldReloadTexNumber, 0x4);
INCLUDE_BSS(NameRegiTex1, 0x4);
INCLUDE_BSS(NameRegiBGTile, 0x4);
INCLUDE_BSS(NameRegiCursor, 0x4);
INCLUDE_BSS(NameRegiWaku, 0x4);
INCLUDE_BSS(NameregiGaiji, 0x8);
INCLUDE_BSS(at_1621__3, 0x8);
INCLUDE_BSS(at_1661__3, 0x8);
INCLUDE_BSS(at_1684__3, 0x8);
INCLUDE_BSS(at_1686, 0x8);
INCLUDE_BSS(at_1693__2, 0x8);

// Uninitialised data (.bss)
INCLUDE_BSS(Nameregi_Target, 0x50);
INCLUDE_BSS(NameRegiTopic, 0x40);
INCLUDE_BSS(NameRegiStack, 0x30);
INCLUDE_BSS(at_1171__3, 0x10);
INCLUDE_BSS(at_1669, 0x28);
INCLUDE_BSS(at_1755, 0x18);
