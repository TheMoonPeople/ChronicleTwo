#include "sound.hpp"
#include "dataread.hpp"
#include "prespr.hpp"
#include "mg_drawprim.hpp"
#include <cstdio>
#include "font.hpp"
#include "sysmes.hpp"
#include "scenesnd.hpp"
#include "savedata.hpp"
#include "userdata.hpp"
#include "gamedata.hpp"
#include "scriptinterpreter.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "menumain.hpp"
#include "common.h"
#include "menucls1.hpp"
#include <cstring>
#include "mainloop.hpp"
#include "menucommon.hpp"
#include "mglib.hpp"

extern "C" int GetNumberKeta__Fi(int);
extern "C" double pow(double, double);

extern char *MenuHatena_894;
extern signed char init_895;
extern char *MenuHatena_1byte_897;
extern signed char init_898;
extern char at_905__4[];
extern char at_906__4[];
extern char *MenuBigNum[];
extern signed char *sn_944[];
extern CItemUseTarget MenuUsedTarget;
extern "C" int GetShiledKitLimmit__Fi(int);

// Code (.text)
char *GetHatena() {
    if (init_895 == 0) {
        MenuHatena_894 = at_905__4;
        init_895 = 1;
    }
    if (init_898 == 0) {
        MenuHatena_1byte_897 = at_906__4;
        init_898 = 1;
    }
    if (LanguageCode >= 2 && LanguageCode < 6) {
        return MenuHatena_1byte_897;
    }
    return MenuHatena_894;
}
char *GetMenuBigNum(int number) {
    return MenuBigNum[number % 10];
}
#pragma divbyzerocheck on
void SetMenuBigNum2(char *out, int number) {
    if (out != 0) {
        int rest = number;
        int pos = 0;
        int digits = GetNumberKeta(number);
        if (digits > 0) {
            do {
                signed char *glyph;
                if (digits == 1) {
                    glyph = (signed char *)GetMenuBigNum(rest);
                } else {
                    int divisor = (int)pow(10.0, (double)(digits - 1));
                    glyph = (signed char *)GetMenuBigNum(rest / divisor);
                    rest = rest % divisor;
                }
                char *dst = out + pos;
                digits -= 1;
                pos += 2;
                dst[0] = glyph[0];
                dst[1] = glyph[1];
            } while (digits > 0);
        }
        out[pos] = 0;
    }
}
#pragma divbyzerocheck reset
#pragma divbyzerocheck on

#pragma divbyzerocheck on
void SetMenuBigNum(char *out, int number) {
    if (out != 0) {
        int rest = number;
        int pos = 0;
        int digits = GetNumberKeta__Fi(number);
        if (CheckNowEurope() != 0) {
            if (digits > 0) {
                do {
                    signed char *glyph;
                    if (digits == 1) {
                        glyph = sn_944[rest];
                    } else {
                        double e = (double)(digits - 1);
                        int divisor = (int)pow(10.0, e);
                        glyph = sn_944[rest / divisor];
                        rest = rest % divisor;
                    }
                    signed char c = glyph[0];
                    digits -= 1;
                    out[pos++] = c;
                } while (digits > 0);
            }
        } else if (digits > 0) {
            do {
                signed char *glyph;
                if (digits == 1) {
                    glyph = (signed char *)GetMenuBigNum(rest);
                } else {
                    double base = 10.0;
                    const double &reference = base;
                    double e = (double)(digits - 1);
                    int divisor = (int)pow(reference, e);
                    glyph = (signed char *)GetMenuBigNum(rest / divisor);
                    rest = rest % divisor;
                }
                char *dst = out + pos;
                digits -= 1;
                pos += 2;
                dst[0] = glyph[0];
                dst[1] = glyph[1];
            } while (digits > 0);
        }
        out[pos] = 0;
    }
}
#pragma divbyzerocheck reset
#pragma divbyzerocheck reset
CMenuFont::CMenuFont() {
    Init();
    SetClearance(0x10, 0x14);
    SetFuchi(5);
    SetColor(0x80686A6BU);
    *(int *)&unk_b0 = 0;
    *(int *)&unk_b4 = 0;
}
void MenuMesInit(ClsMes *mes) {
    int a, b, c, d, e;
    if (mes != 0) {
        mes->npc_name_mode = 0;
        mes->char_num = 0;
        mes->text_w = 0;
        mes->text_h = 0;
        mes->page = 0;
        mes->page_num = 0;
        for (a = 0; a < 16; a++) {
            mes->page_chars[a] = 0;
        }
        mes->last_x = 0;
        mes->last_y = 0;
        *(int *)&mes->fade = 0;
        mes->open = 1;
        mes->draw_speed = mes->GetDrawSpeedDef();
        mes->page_wait = 0;
        mes->scroll_wait = 0;
        *(int *)&mes->reveal = 0;
        mes->reveal_num = 0;
        mes->page_top = 0;
        mes->unk_1f4 = 0;
        mes->InitMesWinTbl();
        mes->color = mes->def_color;
        mes->wait = 0;
        mes->page_time = 0;
        mes->page_auto_time = 30;
        mes->mes_no = -1;
        mes->unk_1e40 = 0;
        mes->alpha = 0x80;
        for (b = 0; b < 16; b++) {
            memset(mes->name[b], 0, 0x32);
        }
        for (c = 0; c < 16; c++) {
            mes->item_mes[c] = -1;
        }
        for (d = 0; d < 16; d++) {
            mes->values[d] = 0;
            mes->value_width[d] = 0;
        }
        mes->value = 0;
        mes->value_sign = 0;
        mes->value_zero = 1;
        mes->value_half = 0;
        mes->value_space = 0;
        mes->digit_font = 0;
        mes->space_w = -1;
        mes->justify_w = -1;
        mes->select = -1;
        mes->goal_cursor_x = 0;
        mes->goal_cursor_y = 0;
        mes->cursor_x = 0;
        mes->cursor_y = 0;
        mes->select_shade = 0;
        mes->cursor_centering = 0;
        mes->cursor_time = 0;
        mes->choice_pos[0][0] = -1;
        mes->choice_pos[0][1] = -1;
        mes->choice_pos[1][0] = -1;
        mes->choice_pos[1][1] = -1;
        mes->select_top = 0;
        mes->cursor_off_y = 0;
        mes->voice_on = 0;
        mes->voice_type = 0;
        mes->voice_cnt = 0;
        mes->close_time = 0;
        mes->scissor_on = 0;
        mes->scissor.x = 0;
        mes->scissor.width = 0;
        mes->scissor.y = 0;
        mes->scissor.height = 0;
        for (e = 0; e < 20; e++) {
            mes->line_indent[e] = 0;
            mes->line_pos[e][0] = 0;
            mes->line_pos[e][1] = 0;
            mes->line_pos_on[e] = 0;
            mes->line_shade[e] = -1;
            mes->line_color[e] = 0;
            mes->equip_on[e] = 0;
            mes->equip_x[e] = 0;
            mes->equip_y[e] = 0;
            mes->line_w[e] = 0;
            mes->line_alpha[e] = -1;
            mes->cross_on[e] = 0;
            mes->cross_x[e] = 0;
            mes->cross_y[e] = 0;
            mes->unk_271c[e] = -1;
            mes->unk_276c[e] = -1;
            mes->unk_27bc[e] = 0;
            mes->unk_280c[e] = 0;
            mes->delta_on[e] = 0;
            mes->delta_x[e] = 0;
            mes->delta_y[e] = 0;
        }
        mes->abs_win.x = -1;
        mes->abs_win.y = -1;
        mes->abs_win.width = -10;
        mes->abs_win.height = -10;
        mes->abs_text_off_x = -1;
        mes->abs_text_off_y = -1;
        mes->fukidashi_pos = -1;
        mes->value_zero = 0;
        mes->rows = 5;
        mes->draw_speed = 0.0f;
        mes->draw_speed_def = 0.0f;
        mes->push_button = 0;
        mes->tail_on = 0;
        mes->fade_speed = 1.0f;
        mes->fuchi = 5;
        mes->SetHalfFontWPercent(-1.0f);
        mes->font_w = 15;
        mes->font_h = 24;
        if (LanguageCode > 0) {
            mes->font_w = 15;
            mes->font_h = 24;
        }
        mes->draw_off_x = 0.0f;
        mes->draw_off_y = 0.0f;
        *(int *)&mes->unk_b0 = 0;
        *(int *)&mes->unk_b4 = 0;
    }
}
extern "C" void *__ct__6ClsMesFv(void *);
extern "C" void Set__9mgRect_i_Fiiii(void *, int, int, int, int);
extern "C" CDC2Mes *__ct__7CDC2MesFv(CDC2Mes *window) {
    __ct__6ClsMesFv(window);
    Set__9mgRect_i_Fiiii(&window->scissor, 0, 0, 0, 0);
    window->msg_change = 0;
    window->cursor = -1;
    window->text_off_x = -1;
    window->text_off_y = -1;
    window->mes_no = -1;
    window->cursor_on = 1;
    window->put_centering = 0;
    window->scissor_on = 0;
    Set__9mgRect_i_Fiiii(&window->scissor, 0, 0, 0x200, 0x19F);
    memset(window->str, 0, 0xC1);
    return window;
}
void CDC2Mes::SetMessData(short *buff_system, short *buff) {
    SetBuff_system(buff_system);
    SetBuff(buff);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", MsgPreset__7CDC2MesFi);
void CDC2Mes::MsgPreset(int preset, int unused) {
    MsgPreset(preset);
    if (LanguageCode == 1) {
        value_half = 1;
    }
}
void CDC2Mes::SetMsgCursor(int choice) {
    cursor = choice;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", AddMsgCursor2__7CDC2MesFiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", AddMsgCursor__7CDC2MesFiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", CommandMsgCursor__7CDC2MesFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", YesNoCursor__7CDC2MesFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", YesNoCursor2__7CDC2MesFi);
int CDC2Mes::GetMsgCursor() {
    return cursor;
}
int CDC2Mes::GetMsgItemNo(int index) {
    return item_mes[index];
}
void CDC2Mes::SetFontColor(int r, int g, int b, int a) {
    SetDefColor(r | (g << 8 | (a << 24 | b << 16)));
}
void CDC2Mes::SetPutPos(int x, int y, int w, int h) {
    abs_win.x = x;
    abs_win.y = y;
    abs_win.width = w;
    abs_win.height = h;
    if (*(signed char *)&put_centering != 0) {
        abs_win.x = (int)((unsigned int)mgScreenWidth - text_w) >> 1;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", SetPutPos__7CDC2MesFPi);
void CDC2Mes::SetAbsPos(int pos) {
    fukidashi_pos = pos;
}
int CDC2Mes::GetStringDrawWidthDC(char *str) {
    int width = GetStrWidth(str);
    if (width >= 0) {
        return width;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", SetMovePosCenteringGyou__7CDC2MesFiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", SetMsgItemNo__7CDC2MesFPii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", SetMsgItemNo__7CDC2MesFPPci);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", SetMsgVolumeNo__7CDC2MesFPii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", SetMsgVolumeNo__7CDC2MesFPiPii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", SetMsgVolumeNoOne__7CDC2MesFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", SetMsgItemPos__7CDC2MesFPii);
void CDC2Mes::MakeMsg(int message_no) {
    mes_no = message_no;
    str[0] = 0;
}
void CDC2Mes::MakeMsg(char *text) {
    mes_no = -1;
    str[0] = 0;
    if (text != NULL) {
        strcpy(str, text);
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", MakeMsg__7CDC2MesFP13CGameDataUsed);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", MakeMsg__7CDC2MesFP13CGameDataUsedP13CGameDataUsed);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", StepMsg__7CDC2MesFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", DrawMsg__7CDC2MesFv);
void CDC2Mes::SetMsgAlpha(int value) {
    alpha = value;
    if (value < 0)
        alpha = 0;
    if (0x80 < value)
        alpha = 0x80;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", Initialize__13CMenuMoveItemFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", AttachForm__13CMenuMoveItemFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", CheckMove__13CMenuMoveItemFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", SetMoveItemInfo__13CMenuMoveItemFP19MENU_ITEM_MOVE_INFOPiPi);
int CheckRoboShieldKit(CUserDataManager *manager, CGameDataUsed *item, int apply, int *kit_count,
                       int *applied_count) {
    if (item->item_type == 0xB) {
        int limit = GetShiledKitLimmit__Fi(item->item_no);
        ROBO_DATA *robo = &manager->robo_data;
        if (robo == 0) {
            return -1;
        }
        if (robo->shield_kit_num < limit) {
            *kit_count += 1;
            if (apply != 0) {
                *applied_count += 1;
                robo->shield_kit_num += 1;
                if (limit <= robo->shield_kit_num) {
                    robo->shield_kit_num = limit;
                }
                return 0xF;
            }
        }
    }
    return -1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", MenuUseItemCheckFunc__FP13CGameDataUsedP14CItemUseTargeti);
int CMenuItemUse::CheckItemUseEnable(CGameDataUsed *item, int kind, void *ptr) {
    int target_data[2];
    if (item == NULL || ptr == NULL) {
        return 0;
    }
    target_data[0] = -1;
    ((CItemUseTarget *)&target_data)->SetPtr(kind, ptr);
    return MenuUseItemCheckFunc(item, (CItemUseTarget *)&target_data, 0);
}
int CMenuItemUse::UseItem(CGameDataUsed *item, int kind, void *ptr) {
    u64 target_data;
    ((CItemUseTarget *)&target_data)->SetPtr(kind, ptr);
    MenuUsedTarget.SetPtr(kind, ptr);
    return UseItem(item, (CItemUseTarget *)&target_data);
}
int CMenuItemUse::UseItem(CGameDataUsed *item, CItemUseTarget *target) {
    if (item == NULL) {
        return 0;
    }
    item_no = (int)item->item_no;
    target_type = target->type;
    MenuUsedTarget.type = target->type;
    MenuUsedTarget.target.data = target->target.data;
    return MenuUseItemCheckFunc(item, target, 1);
}
void CMenuItemUse::Initialize(void) {
    item_no = 0;
    target_type = 0;
    unk_18 = 0;
}
int CheckNowStateUseThisItem(CGameDataUsed *item, CItemUseTarget *target) {
    return MenuUseItemCheckFunc(item, target, 0);
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menucls1", __sinit_menucls1_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", MenuBigNum__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", sn_944__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_1415__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", st_bittable_1654__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_905__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_906__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_907__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_908__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_909__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_910__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_911__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_912__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_913__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_914__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_915__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_916__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_945__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_946__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_947__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_948__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_949__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_950__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_951__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_952__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_953__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_954__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_1104__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_1328__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_1512__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_1513__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_1514__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_1623__3__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", D_0037B028__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menucls1", at_1371__2__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(MenuHatena_894, 0x4);
INCLUDE_BSS(init_895, 0x4);
INCLUDE_BSS(MenuHatena_1byte_897, 0x4);
INCLUDE_BSS(init_898, 0x4);
INCLUDE_BSS(at_1433__2, 0x4);
INCLUDE_BSS(MenuUsedItemNo, 0x4);
INCLUDE_BSS(MenuUsedItemType, 0x4);
INCLUDE_BSS(MenuUsedNotErrorCode, 0x4);
INCLUDE_BSS(MenuUsedTarget, 0x8);

// Uninitialised data (.bss)
INCLUDE_BSS(at_1407__2, 0x10);
INCLUDE_BSS(at_1436__3, 0x18);
