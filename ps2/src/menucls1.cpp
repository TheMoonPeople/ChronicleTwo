#include "common.h"

#include <cmath>
#include <cstdio>
#include <cstring>

#include "dataread.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "mapload.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "pal_timing.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

char *MenuBigNum[10] = {
    "\x82O", "\x82P", "\x82Q", "\x82R", "\x82S", "\x82T", "\x82U", "\x82V", "\x82W", "\x82X"};
CItemUseTarget MenuUsedTarget;
int            MenuUsedItemNo;
u32            MenuUsedItemType;
int            MenuUsedNotErrorCode;

char *GetHatena() {
    /**
     *
     * Full-width placeholder for an unidentified item name.
     *
     */
    static char *MenuHatena = "\x81H\x81H\x81H";
    /**
     *
     * Single-byte placeholder for an unidentified item name.
     *
     */
    static char *MenuHatena_1byte = "???";

    if (LanguageCode >= LANG_FRENCH && LanguageCode < LANG_CHINESE) {
        return MenuHatena_1byte;
    }

    return MenuHatena;
}

char *GetMenuBigNum(int number) {
    return MenuBigNum[number % 10];
}

void SetMenuBigNum2(char *out, int number) {
    if (out != NULL) {
        int rest = number;
        int pos = 0;
        int digits = GetNumberKeta(number);

        if (digits > 0) {
            do {
                char *glyph;

                if (digits == 1) {
                    glyph = GetMenuBigNum(rest);
                } else {
                    int divisor = (int) pow(10.0, (double) (digits - 1));
                    glyph = GetMenuBigNum(rest / divisor);
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

void SetMenuBigNum(char *out, int number) {
    /**
     *
     * Single-byte glyphs used to write decimal item counts.
     *
     */
    static char *sn[10] = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};

    if (out != NULL) {
        int rest = number;
        int pos = 0;
        int digits = GetNumberKeta(number);

        if (CheckNowEurope() != 0) {
            if (digits > 0) {
                do {
                    char *glyph;

                    if (digits == 1) {
                        glyph = sn[rest];
                    } else {
                        double e = (double) (digits - 1);
                        int    divisor = (int) pow(10.0, e);
                        glyph = sn[rest / divisor];
                        rest = rest % divisor;
                    }

                    signed char c = glyph[0];
                    digits -= 1;
                    out[pos++] = c;
                } while (digits > 0);
            }
        } else if (digits > 0) {
            do {
                char *glyph;

                if (digits == 1) {
                    glyph = GetMenuBigNum(rest);
                } else {
                    double        base = 10.0;
                    const double &reference = base;
                    double        e = (double) (digits - 1);
                    int           divisor = (int) pow(reference, e);
                    glyph = GetMenuBigNum(rest / divisor);
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

CMenuFont::CMenuFont() {
    Init();
    SetClearance(0x10, 0x14);
    SetFuchi(5);
    SetColor(0x80686A6BU);
    offset_x = 0.0f;
    offset_y = 0.0f;
}

void MenuMesInit(ClsMes *mes) {
    int page_no, name_no, item_no, value_no, line_no;

    if (mes != NULL) {
        mes->npc_name_mode = 0;
        mes->char_num = 0;
        mes->text_w = 0;
        mes->text_h = 0;
        mes->page = 0;
        mes->page_num = 0;

        for (page_no = 0; page_no < 16; page_no++) {
            mes->page_chars[page_no] = 0;
        }

        mes->last_x = 0;
        mes->last_y = 0;
        mes->fade = 0.0f;
        mes->open = 1;
        mes->draw_speed = mes->GetDrawSpeedDef();
        mes->page_wait = 0;
        mes->scroll_wait = 0;
        mes->reveal = 0.0f;
        mes->reveal_num = 0;
        mes->page_top = 0;
        mes->unk_1f4 = 0;
        mes->InitMesWinTbl();
        mes->color = mes->def_color;
        mes->wait = 0;
        mes->page_time = 0;
        mes->page_auto_time = 30;
        mes->mes_no = -1;
        mes->text_ptr = 0;
        mes->alpha = 0x80;

        for (name_no = 0; name_no < 16; name_no++) {
            memset(mes->name[name_no], 0, sizeof(mes->name[name_no]));
        }

        for (item_no = 0; item_no < 16; item_no++) {
            mes->item_mes[item_no] = -1;
        }

        for (value_no = 0; value_no < 16; value_no++) {
            mes->values[value_no] = 0;
            mes->value_width[value_no] = 0;
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

        for (line_no = 0; line_no < 20; line_no++) {
            mes->line_indent[line_no] = 0;
            mes->line_pos[line_no][0] = 0;
            mes->line_pos[line_no][1] = 0;
            mes->line_pos_on[line_no] = 0;
            mes->line_shade[line_no] = -1;
            mes->line_color[line_no] = 0;
            mes->equip_on[line_no] = 0;
            mes->equip_x[line_no] = 0;
            mes->equip_y[line_no] = 0;
            mes->line_w[line_no] = 0;
            mes->line_alpha[line_no] = -1;
            mes->cross_on[line_no] = 0;
            mes->cross_x[line_no] = 0;
            mes->cross_y[line_no] = 0;
            mes->unk_271c[line_no] = -1;
            mes->unk_276c[line_no] = -1;
            mes->unk_27bc[line_no] = 0;
            mes->unk_280c[line_no] = 0;
            mes->delta_on[line_no] = 0;
            mes->delta_x[line_no] = 0;
            mes->delta_y[line_no] = 0;
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

        if (LanguageCode > LANG_JAPANESE) {
            mes->font_w = 15;
            mes->font_h = 24;
        }

        mes->draw_off_x = 0.0f;
        mes->draw_off_y = 0.0f;
        mes->offset_x = 0.0f;
        mes->offset_y = 0.0f;
    }
}

CDC2Mes::CDC2Mes() {
    scissor.Set(0, 0, 0, 0);
    msg_change = false;
    cursor = -1;
    text_off_x = -1;
    text_off_y = -1;
    mes_no = -1;
    cursor_on = true;
    put_centering = false;
    scissor_on = false;
    scissor.Set(0, 0, 0x200, 0x19F);
    memset(str, 0, sizeof(str));
}

void CDC2Mes::SetMessData(short *buff_system, short *buff) {
    SetBuff_system(buff_system);
    SetBuff(buff);
}

void CDC2Mes::MsgPreset(int preset) {
    MenuMesInit(this);
    SetMsgCursor(-1);
    mes_no = 0;
    str[0] = 0;
    cursor_on = true;
    put_centering = false;
    scissor_on = false;
    scissor.Set(0, 0, mgScreenWidth - 1, mgScreenHeight - 1);

    switch (preset) {
        case MENU_SCRIPT_MES_DEFAULT:
            SetWindowMode(MES_WIN_HELP);
            break;
        case MENU_SCRIPT_MES_DEFAULT_BLACK:
            SetWindowMode(MES_WIN_HELP);
            fuchi = FUCHI_OUTLINE_WIDE;
            break;
        case MENU_SCRIPT_MES_NO_WIN:
            SetWindowMode(MES_WIN_NONE);
            break;
        case MENU_SCRIPT_MES_SYSTEM:
            SetWindowMode(MES_WIN_VERSATILE_4);
            abs_win.width = 272;
            abs_win.height = 102;
            text_off_x = 16;
            text_off_y = 16;
            value_sign = 1;
            centering = 0;
            break;
        case MENU_SCRIPT_MES_NAME:
        case MENU_SCRIPT_MES_NAME_BLACK:
            SetWindowMode(MES_WIN_NONE);
            rows = 1;
            value_sign = 1;

            if (preset == MENU_SCRIPT_MES_NAME_BLACK) {
                fuchi = FUCHI_SHADOW_BLACK_WIDE;
            }

            break;
        case MENU_SCRIPT_MES_INVENT:
            SetWindowMode(MES_WIN_NONE);
            rows = 1;
            value_zero = 1;
            fuchi = FUCHI_NONE;
            SetDefColor(0x80141414);
            break;
        case MENU_SCRIPT_MES_MSGDIC:
            SetWindowMode(MES_WIN_NONE);
            fuchi = FUCHI_NONE;
            SetFontColor(6, 6, 6, 128);
            rows = 1;
            value_zero = 1;
            break;
        case MENU_SCRIPT_MES_ITEMCMD:
            point_x = 40;
            point_y = -60;
            SetWindowMode(MES_WIN_FLOATING);
            select_shade = MES_SELECT_SHADE_BRIGHT;
            break;
        case MENU_SCRIPT_MES_GENERAL:
        case MENU_SCRIPT_MES_GENERAL_2:
            SetWindowMode(MES_WIN_VERSATILE_1);
            fuchi = FUCHI_NONE;
            push_button = 1;
            fade_speed = 0.1f;

            if (preset == MENU_SCRIPT_MES_GENERAL_2) {
                push_button = 0;
            }

            break;
        case MENU_SCRIPT_MES_YESNO:
            SetWindowMode(MES_WIN_YESNO);
            fuchi = FUCHI_NONE;
            fade_speed = 0.1f;
            break;
        case MENU_SCRIPT_MES_BRD3:
            SetWindowMode(MES_WIN_VERSATILE_3);
            fade_speed = 0.1f;
            break;
        case MENU_SCRIPT_MES_GEO:
        case MENU_SCRIPT_MES_HELPWIN:
            SetWindowMode(MES_WIN_VERSATILE_4);

            if (preset == MENU_SCRIPT_MES_GEO) {
                text_off_x = 16;
                text_off_y = 16;
                abs_win.width = 236;
                abs_win.height = 100;
            }

            break;
        case MENU_SCRIPT_MES_MAKEBRD:
            SetWindowMode(MES_WIN_NONE);
            break;
        case MENU_SCRIPT_MES_ITEMMSG:
        case MENU_SCRIPT_MES_ITEMMSG_DEFAULTFUCHI:
            SetWindowMode(MES_WIN_NONE);

            if (preset == MENU_SCRIPT_MES_ITEMMSG_DEFAULTFUCHI) {
                fuchi = FUCHI_SHADOW_BLACK_WIDE;
            }

            break;
        case MENU_SCRIPT_MES_VOLMSG:
            SetWindowMode(MES_WIN_NONE);
            value_zero = 1;
            font_h -= 2;
            break;
        case MENU_SCRIPT_MES_TALK:
            Preset(0);
            fade_speed = 0.1f;
            break;
    }

    if (CheckNowEurope()) {
        value_half = 1;
    }
}

void CDC2Mes::MsgPreset(int preset, int unused) {
    MsgPreset(preset);

    if (LanguageCode == LANG_ENGLISH) {
        value_half = 1;
    }
}

void CDC2Mes::SetMsgCursor(int choice) {
    cursor = choice;
}

int CDC2Mes::AddMsgCursor2(int min, int max, int loop) {
    int step = 0;

    if (GamePad__2.Down(PAD_UP)) {
        step--;
    }

    if (GamePad__2.Down(PAD_DOWN)) {
        step++;
    }

    if (AddMsgCursor(step, min, max, loop)) {
        MenuSePlay(SYSTEM_SE_CURSOR);
    }

    return cursor;
}

int CDC2Mes::AddMsgCursor(int step, int min, int max, int loop) {
    int previous = cursor;
    cursor += step;

    if (loop == 1) {
        if (cursor < min) {
            cursor = max;
        } else if (cursor > max) {
            cursor = min;
        }
    } else {
        if (cursor < min) {
            cursor = min;
        } else if (cursor > max) {
            cursor = max;
        }
    }

    return previous != cursor;
}

int CDC2Mes::CommandMsgCursor() {
    int step = 0;

    if (GamePad__2.Down(PAD_UP)) {
        step--;
    }

    if (GamePad__2.Down(PAD_DOWN)) {
        step++;
    }

    int choices = 0;

    for (int index = 0; index < MES_ITEM_MAX; index++) {
        if (0 < item_mes[index]) {
            choices++;
        } else {
            break;
        }
    }

    if (choices <= 0) {
        choices = 1;
    }

    if (AddMsgCursor(step, 0, choices - 1, 1)) {
        MenuSePlay(SYSTEM_SE_CURSOR);
    }

    return cursor;
}

int CDC2Mes::YesNoCursor() {
    int step = 0;

    if (GamePad__2.Down(PAD_LEFT)) {
        step--;
    }

    if (GamePad__2.Down(PAD_RIGHT)) {
        step++;
    }

    if (AddMsgCursor(step, 0, 1, 0)) {
        MenuSePlay(SYSTEM_SE_CURSOR);
    }

    return cursor;
}

int CDC2Mes::YesNoCursor2(int alt_button) {
    int step = 0;

    if (GamePad__2.Down(PAD_LEFT)) {
        step--;
    }

    if (GamePad__2.Down(PAD_RIGHT)) {
        step++;
    }

    if (AddMsgCursor(step, 0, 1, 0)) {
        MenuSePlay(SYSTEM_SE_CURSOR);
    }

    int buttons = MenuCheckPushButton();

    if (buttons & MENU_PUSH_BUTTON_DECIDE) {
        return cursor == 0 ? MES_YESNO_YES : MES_YESNO_NO;
    }

    if (alt_button == 1 && (buttons & MENU_PUSH_BUTTON_TRIANGLE)) {
        return cursor == 0 ? MES_YESNO_YES : MES_YESNO_NO;
    }

    if (buttons & MENU_PUSH_BUTTON_CANCEL) {
        return MES_YESNO_NO;
    }

    return MES_YESNO_NONE;
}

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

    if (put_centering != 0) {
        abs_win.x = (int) ((unsigned int) mgScreenWidth - text_w) >> 1;
    }
}

void CDC2Mes::SetPutPos(int *pos) {
    abs_win.x = pos[0];
    abs_win.y = pos[1];

    if (put_centering != 0) {
        abs_win.x = (int) ((unsigned int) mgScreenWidth - text_w) >> 1;
    }

    if (0 < abs_win.width) {
        abs_text_off_x = text_off_x;
        abs_text_off_y = text_off_y;
    }

    if (0 < fukidashi_pos) {
        abs_win.y = -1;
        abs_win.x = -1;
    }
}

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

void CDC2Mes::SetMovePosCenteringGyou(int line, int centre_x, int y) {
    centre_x -= line_w[line] >> 1;

    if (line >= 0 && line < MES_LINE_MAX) {
        line_pos[line][0] = centre_x;
        line_pos[line][1] = y;
        line_pos_on[line] = 1;
    }
}

void CDC2Mes::SetMsgItemNo(int *messages, int count) {
    int previous[MES_ITEM_MAX];

    for (int index = 0; index < count && index < MES_ITEM_MAX; index++) {
        previous[index] = item_mes[index];

        if (previous[index] != messages[index]) {
            msg_change = true;
        }

        int message = messages[index];

        if (index >= 0 && index < MES_ITEM_MAX) {
            item_mes[index] = message;
        }

        if (messages[index] <= -1) {
            for (; index < MES_ITEM_MAX; index++) {
                if (index >= 0 && index < MES_ITEM_MAX) {
                    item_mes[index] = -1;
                }
            }

            break;
        }
    }
}

void CDC2Mes::SetMsgItemNo(char **strings, int count) {
    char *previous[MES_ITEM_MAX];

    for (int index = 0; index < count && index < MES_ITEM_MAX; index++) {
        previous[index] = name[index];

        if (strings[index] == NULL) {
            if (strcmp(name[index], "") != 0) {
                msg_change = true;
            }

            strcpy(name[index], "");
        } else {
            if (strcmp(previous[index], strings[index]) != 0) {
                msg_change = true;
            }

            if (strings[index] != NULL) {
                strcpy(name[index], strings[index]);
            }
        }

        if (strings[index] == NULL) {
            for (; index < MES_ITEM_MAX; index++) {
                strcpy(name[index], "");
            }

            break;
        }
    }
}

void CDC2Mes::SetMsgVolumeNo(int *numbers, int count) {
    int previous[MES_VALUE_MAX];

    for (int index = 0; index < count && index < MES_VALUE_MAX; index++) {
        previous[index] = values[index];

        if (previous[index] != numbers[index]) {
            msg_change = true;
        }

        values[index] = numbers[index];
        value_width[index] = 0;
    }
}

void CDC2Mes::SetMsgVolumeNo(int *numbers, int *digit_widths, int count) {
    int previous[MES_VALUE_MAX];

    for (int index = 0; index < count && index < MES_VALUE_MAX; index++) {
        previous[index] = values[index];

        if (previous[index] != numbers[index]) {
            msg_change = true;
        }

        int next = numbers[index];
        int digits = digit_widths[index];
        values[index] = next;
        value_width[index] = digits;
    }
}

void CDC2Mes::SetMsgVolumeNoOne(int value) {
    int numbers[2] = {0, -1};
    numbers[0] = value;
    SetMsgVolumeNo(numbers, 1);
}

void CDC2Mes::SetMsgItemPos(int *pos, int count) {
    for (int index = 0; index < count && index < MES_VALUE_MAX; index++) {
        int x;
        int y;
        y = pos[index * 2 + 1];
        x = pos[index * 2];

        if (index >= 0 && index < MES_LINE_MAX) {
            line_pos[index][0] = x;
            line_pos[index][1] = y;
            line_pos_on[index] = 1;
        }
    }
}

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

void CDC2Mes::MakeMsg(CGameDataUsed *item) {
    if (item != NULL) {
        int   numbers[3] = {0, 0, 0};
        char *names[2];
        int   message_no;
        int   item_no = item->item_no;
        message_no = 0;

        if (0 < item_no) {
            message_no = GetItemMessageNo(item_no, 1);

            if (item_no == ITEM_ID_LAMBS_SWORD) {
                if (GetTimeBand(MenuNowTime) == MAP_TIME_BAND_NIGHT) {
                    message_no = 0xA2;
                }
            }

            item->GetMsgAddInfo(&names[0], &names[1], numbers);
            SetMsgItemNo(names, 2);
            SetMsgVolumeNo(numbers, 2);
        } else {
            int messages[4] = {-1, -1, -1, -1};
            SetMsgItemNo(messages, 4);
        }

        value_sign = 1;
        value_zero = 0;

        if (item_no == ITEM_ID_SPECTOL) {
            value_sign = 0;
        } else if (item_no == ITEM_ID_MEDAL_HOLDER) {
            value_zero = 1;
            value_sign = 0;
        }

        MakeMsg(message_no);
    } else {
        MakeMsg(0);
    }
}

void CDC2Mes::MakeMsg(CGameDataUsed *attachment, CGameDataUsed *weapon) {
    if (attachment != NULL) {
        if (weapon == NULL) {
            return;
        }
    } else {
        return;
    }

    if (weapon->used_type != USED_ITEM_TYPE_WEAPON || weapon->IsFishingRod()) {
        char *names[1] = {NULL};
        names[0] = weapon->GetName(ITEM_NAME_TYPE_LEVEL);
        SetMsgItemNo(names, 1);
        MakeMsg(0xBD);
    } else {
        if (weapon->RemainFusion() < attachment->data.attach.spectol_value) {
            MakeMsg(0xBA);
        } else {
            int numbers[3] = {0, 0, 0};
            numbers[0] = attachment->data.attach.spectol_value;
            numbers[1] = weapon->RemainFusion();
            numbers[2] = weapon->RemainFusion() - attachment->data.attach.spectol_value;
            value_zero = 1;
            value_sign = 0;
            SetMsgVolumeNo(numbers, 3);
            MakeMsg(0xBC);
        }
    }
}

void CDC2Mes::StepMsg() {
    if (buff != NULL) {
        int message_no = mes_no;

        if (msg_change != 0) {
            ClsMes::mes_no = -1;
            msg_change = false;
        }

        int choice = cursor;

        if (select < 0) {
            cursor_time = 0;
        }

        select = choice;

        if (str[0] == 0) {
            MakeMesWin(message_no);
            Step();
        } else {
            MakeMesWin(str, 1, 1);

            if (abs_win.width > 0 || abs_win.height > 0) {
                open = 1;
            }

            Step();
        }
    }
}

void CDC2Mes::DrawMsg() {
    int saved_x;
    int saved_y;

    if (buff != NULL) {
        if (cursor_on == 0) {
            saved_x = cursor_x;
            saved_y = cursor_y;
            cursor_x = -1000;
            cursor_y = -1000;
        }

        if (scissor_on != 0) {
            SetMenuScissor(scissor);
        }

        DrawMesWin();

        if (scissor_on != 0) {
            ResetMenuScissor();
        }

        if (cursor_on == 0) {
            cursor_x = saved_x;
            cursor_y = saved_y;
        }
    }
}

void CDC2Mes::SetMsgAlpha(int value) {
    alpha = value;

    if (value < 0) {
        alpha = 0;
    }

    if (0x80 < value) {
        alpha = 0x80;
    }
}

void CMenuMoveItem::Initialize() {
    move_on = false;

    for (int index = 0; index < 2; index++) {
        form[index] = NULL;
        memset(&info[index], 0, sizeof(MENU_ITEM_MOVE_INFO));
    }
}

void CMenuMoveItem::AttachForm() {
    form[0] = MenuPosData->GetFormInfo("moveitem0");
    form[1] = MenuPosData->GetFormInfo("moveitem1");

    if (form[0] != NULL) {
        form[0]->draw_flag = 0;
        form[0]->SetNumber("num", 0);
    }

    if (form[1] != NULL) {
        form[1]->draw_flag = 0;
        form[1]->SetNumber("num", 0);
    }
}

int CMenuMoveItem::CheckMove() {
    int moving = 0;

    if (move_on != 0) {
        for (int index = 0; index < 2; index++) {
            MENU_ITEM_MOVE_INFO *entry = &info[index];

            if (entry->active != 0) {
                if (form[index]->CheckMoveEnd()) {
                    if (entry->mode == MENU_MOVE_ITEM_COPY || entry->mode == MENU_MOVE_ITEM_ONE) {
                        entry->dest->CopyGameData(&entry->item);
                    } else if (entry->mode == MENU_MOVE_ITEM_STACK) {
                        entry->dest->CopyDataItem(&entry->item);
                    }

                    entry->active = false;
                    entry->item.Init();
                    entry->dest = NULL;
                    form[index]->draw_flag = 0;
                    CheckEnableHaveItemNum();
                } else {
                    int  x;
                    int  y;
                    int &y_pos = y;
                    moving++;
                    form[index]->GetPutPosXY(NULL, x, y_pos);

                    if (286 < x && 302 < y_pos) {
                        form[index]->draw_flag = 0;
                    }
                }
            }
        }
    }

    if (moving == 0) {
        move_on = false;
    }

    return move_on;
}

void CMenuMoveItem::SetMoveItemInfo(MENU_ITEM_MOVE_INFO *request, int *start, int *goal) {
    if (request == NULL) {
        return;
    }

    for (int index = 0; index < 2; index++) {
        MENU_ITEM_MOVE_INFO *entry = &info[index];

        if (entry->active == 0) {
            CMenuPosDataForm *moving_form = form[index];
            memcpy(entry, request, sizeof(MENU_ITEM_MOVE_INFO));
            moving_form->draw_flag = 1;

            if (entry->item.item_no <= 0) {
                moving_form->draw_flag = 0;
            }

            if (entry->mode == MENU_MOVE_ITEM_ONE) {
                entry->item.DeleteNum(entry->item.GetNum() - 1);
            }

            moving_form->x = start[0];
            moving_form->y = start[1];
            moving_form->SetNextMovePos(goal, 2);
            MENUFORMPARTS_TYPE *part = moving_form->GetPartInfo("item");
            part->etc_info[1] = entry->item.item_no;
            part->etc_info[2] = 0;

            if (part->etc_info[1] == ITEM_ID_SPECTOL) {
                part->etc_info[2] = entry->item.GetSpectolNo();
            }

            if (part->etc_info[1] == ITEM_ID_BOILED_FISH) {
                part->etc_info[2] = entry->item.data.item.num;
            }

            part = moving_form->GetPartInfo("num");
            part->etc_info[0] = 0;
            part->etc_info[1] = entry->item.GetNum();
            part->etc_info[2] = 1;
            move_on = true;
            entry->active = true;
            break;
        }
    }
}

int CheckRoboShieldKit(CUserDataManager *manager, CGameDataUsed *item, int apply, int *kit_count,
                       int *applied_count) {
    if (item->item_type == ITEM_DATA_ROBO_CORE) {
        int        limit = GetShiledKitLimmit(item->item_no);
        ROBO_DATA *robo = &manager->robo_data;

        if (robo == NULL) {
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

int MenuUseItemCheckFunc(CGameDataUsed *item, CItemUseTarget *target, int apply) {
    /**
     *
     * Character status bits tested when an item adds or cures a condition.
     *
     */
    static u32 st_bittable[7] = {
        CHARA_STATUS_POISON, CHARA_STATUS_SLOW, CHARA_STATUS_CURSE, CHARA_STATUS_STOP,
        CHARA_STATUS_POWER, CHARA_STATUS_STONE, CHARA_STATUS_DRY};

    if (item == NULL || target == NULL) {
        return 0;
    }

    USEITEM_EFFECT effect;

    if (GetUsedItemAfterEffect(item->item_no, &effect) == 0) {
        return 0;
    }

    int               count = 0;
    int               sound = -1;
    int               used = 0;
    CUserDataManager *user;
    CHARA_DATA       *chara;
    CGameDataUsed    *weapon;
    CScene           *scene = GetMainScene();
    DNG_BATTLE_AREA  *battle = &scene->battle_area;
    user = GetUserDataMan();

    if (scene == NULL || battle == NULL || user == NULL) {
        return 0;
    }

    MenuUsedItemType = effect.use_flags;
    MenuUsedItemNo = item->item_no;
    MenuUsedNotErrorCode = false;
    int items_blocked = false;

    if (battle->floor_status & DNG_FLOOR_DISABLE_ITEMS) {
        items_blocked = true;
    }

    int party = user->GetNowPartyMember();

    switch (target->type) {
        case ITEM_USE_TARGET_CHARA: {
            if (!(effect.target_flags & 6) && !(effect.target_flags & 0x10)) {
                break;
            }

            chara = (CHARA_DATA *) target->target.data;
            short dead = false;

            if (chara->hp.GetRate() <= 0.0f) {
                dead = true;
            }

            if (dead == 1 && (effect.action_flags & ITEM_ACTION_EAT)) {
                break;
            }

            int weapon_type = chara->equip[CHARA_EQUIP_MELEE].item_type;

            if (!(chara->status_attr & CHARA_STATUS_DRY) || !(effect.action_flags & ITEM_ACTION_EAT)) {
                if (((MenuUsedItemNo == ITEM_ID_POTATO_PIE && weapon_type == ITEM_DATA_MAX_MELEE) ||
                     (MenuUsedItemNo == ITEM_ID_WITCH_PARFAIT && weapon_type == ITEM_DATA_MONICA_MELEE)) &&
                    chara->defence < 0x80) {
                    count++;

                    if (apply != 0) {
                        chara->defence += 4;

                        if (chara->defence > 0x80) {
                            chara->defence = 0x80;
                        }

                        sound = SYSTEM_SE_RECOVER;
                        used++;
                    }
                }

                if (MenuUsedItemNo == ITEM_ID_FRUIT_OF_EDEN && chara->hp.max < 255.0f) {
                    count++;

                    if (apply != 0) {
                        used++;
                        chara->hp.max += 8.0f;
                        sound = SYSTEM_SE_RECOVER;

                        if (255.0f < chara->hp.max) {
                            chara->hp.max = 255.0f;
                        }
                    }
                }
            }

            if (items_blocked != 0) {
                break;
            }

            if (MenuUsedItemNo == ITEM_ID_RESURRECTION_POWDER) {
                if (dead == 1) {
                    count++;

                    if (apply != 0) {
                        used++;
                        chara->hp.SetFillRate(1.0f);
                        chara->status_attr = 0;
                        sound = SYSTEM_SE_RECOVER;
                        battle->practice_actions |= DNG_PRACTICE_ACTION_HEAL;
                    }
                }

                break;
            }

            if ((chara->status_attr & CHARA_STATUS_DRY) && (effect.action_flags & ITEM_ACTION_EAT) && item->item_no != ITEM_ID_PLUM_RICE_BALL) {
                MenuUsedNotErrorCode = true;
                break;
            }

            CHARA_DATA *max = user->GetCharaDataPtr(USER_CHARA_MAX);
            CHARA_DATA *monica = user->GetCharaDataPtr(USER_CHARA_MONICA);
            user->GetMonsterBajjiDataPtrMosId(user->monster_id);

            if (MenuUsedItemNo == ITEM_ID_DOUBLE_PUDDING) {
                if ((!max->hp.CheckFill() && 0.0f < max->hp.GetRate()) ||
                    ((party & 2) && !monica->hp.CheckFill() && 0.0f < monica->hp.GetRate())) {
                    count++;

                    if (apply != 0) {
                        used++;

                        if (0.0f < max->hp.GetRate()) {
                            max->hp.SetFillRate(1.0f);
                        }

                        if (0.0f < monica->hp.GetRate()) {
                            monica->hp.SetFillRate(1.0f);
                        }

                        sound = SYSTEM_SE_RECOVER;
                        battle->practice_actions |= DNG_PRACTICE_ACTION_HEAL;
                    }
                }
            } else if (MenuUsedItemNo == ITEM_ID_BOILED_FISH) {
                if (dead == 0 && chara->hp.GetRate() < 1.0f) {
                    count++;

                    if (apply != 0) {
                        used++;
                        chara->hp.AddPoint(item->data.attach.level);
                        sound = SYSTEM_SE_RECOVER;
                        battle->practice_actions |= DNG_PRACTICE_ACTION_HEAL;
                    }
                }
            } else {
                if (MenuUsedItemNo == ITEM_ID_MELLOW_BANANA && (dead == 1 || chara->hp.max <= chara->hp.now)) {
                    break;
                }

                if ((effect.use_flags & ITEM_USE_FLAG_RESTORE_HP) && dead == 0 && chara->hp.now < chara->hp.max) {
                    count++;

                    if (apply != 0) {
                        chara->hp.AddPoint(effect.value[used]);
                        sound = SYSTEM_SE_RECOVER;
                        used++;
                        battle->practice_actions |= DNG_PRACTICE_ACTION_HEAL;
                    }
                }

                int add;
                int cure;
                ConvertItemAttrToCharaAttr(effect.use_flags, &add, &cure);

                if ((add != 0 || cure != 0) && GetNowLoopNo() != LOOP_EDIT) {
                    int available = false;
                    int changed = false;

                    if (add != 0) {
                        for (int i = 0; i < 7; i++) {
                            if (!(chara->status_attr & st_bittable[i]) && add == st_bittable[i]) {
                                available = true;

                                if (apply != 0) {
                                    chara->status_attr |= add;
                                    changed = true;

                                    if (st_bittable[i] & CHARA_STATUS_POWER) {
                                        chara->status_time[0] = PAL_TIMING(750, 900);
                                    }

                                    if (st_bittable[i] & CHARA_STATUS_SLOW) {
                                        chara->status_time[1] = PAL_TIMING(750, 900);
                                    }

                                    if (st_bittable[i] & CHARA_STATUS_STOP) {
                                        chara->status_time[2] = PAL_TIMING(750, 900);
                                    }

                                    if (st_bittable[i] & CHARA_STATUS_STONE) {
                                        chara->status_time[2] = PAL_TIMING(750, 900);
                                    }
                                }
                            }
                        }
                    }

                    int cured = false;

                    if (cure != 0) {
                        for (int i = 0; i < 7; i++) {
                            if ((chara->status_attr & st_bittable[i]) && (cure & st_bittable[i])) {
                                available = true;

                                if (apply != 0) {
                                    cured = true;
                                    changed = true;
                                    chara->status_attr &= ~cure;
                                }
                            }
                        }

                        if (cured != 0) {
                            sound = SYSTEM_SE_RECOVER;
                        }
                    }

                    if (available != 0) {
                        count++;
                    }

                    if (apply != 0 && changed != 0) {
                        battle->practice_actions |= DNG_PRACTICE_ACTION_HEAL;

                        if (sound < 0) {
                            sound = -1;
                            sndSePlay(scene->se_battle_id, 0x56, 0);
                        }

                        used++;
                    }
                }
            }

            break;
        }
        case ITEM_USE_TARGET_ITEM: {
            weapon = target->target.item;

            if (weapon->item_no <= 0 || !(effect.target_flags & 0x20)) {
                break;
            }

            if (weapon == NULL) {
                return 0;
            }

            if (MenuUsedItemNo == ITEM_ID_LEVEL_UP_POWDER) {
                if (weapon->used_type == USED_ITEM_TYPE_WEAPON && !weapon->IsLevelUp() && weapon->IsFishingRod() != 1) {
                    count++;

                    if (apply != 0) {
                        used++;
                        weapon->LevelUp();
                        sound = SYSTEM_SE_PARAM_UP;
                    }
                }
            } else if (MenuUsedItemNo == ITEM_ID_SHIELD_KIT) {
                sound = CheckRoboShieldKit(user, weapon, apply, &count, &used);
            } else if (MenuUsedItemNo == ITEM_ID_RIDEPOD_FUEL) {
                if (weapon == &user->robo_data.parts[ROBO_PART_PACK] && user->robo_data.AddPoint(0.0f) < 1.0f && items_blocked == 0) {
                    count++;

                    if (apply != 0) {
                        user->robo_data.AddPoint(150.0f);
                        sound = 9;
                        used++;
                    }
                }
            } else {
                if ((effect.use_flags & ITEM_USE_FLAG_REPAIR) && weapon->IsRepair() && weapon->IsEnableUseRepair(MenuUsedItemNo)) {
                    count++;

                    if (apply != 0) {
                        int amount = 999;

                        if (weapon->item_type == ITEM_DATA_ROBO_ARM) {
                            amount = weapon->data.robopart.whp.max / 2.0f;
                        }

                        weapon->Repair(amount);
                        sound = 9;
                        used++;
                    }
                }

                if ((effect.use_flags & ITEM_USE_FLAG_FILL_ABS) && weapon->data.weapon.abs.now < weapon->data.weapon.abs.max) {
                    count++;

                    if (apply != 0) {
                        sound = SYSTEM_SE_RECOVER;
                        weapon->data.weapon.abs.now = weapon->data.weapon.abs.max;
                        used++;
                    }
                }
            }

            break;
        }
        case ITEM_USE_TARGET_ROBO: {
            if (!(effect.target_flags & 8)) {
                break;
            }

            ROBO_DATA *robo = (ROBO_DATA *) target->target.data;

            if (MenuUsedItemNo == ITEM_ID_RIDEPOD_FUEL) {
                if (user->robo_data.AddPoint(0.0f) < 1.0f && items_blocked == 0) {
                    count++;

                    if (apply != 0) {
                        user->robo_data.AddPoint(150.0f);
                        sound = 9;
                        used++;
                    }
                }
            } else if (items_blocked == 0 && (effect.use_flags & ITEM_USE_FLAG_REPAIR) && robo->hp.now < robo->hp.max) {
                count++;

                if (apply != 0) {
                    sound = SYSTEM_SE_RECOVER;
                    robo->hp.now = robo->hp.max;
                    used++;
                }
            }

            break;
        }
        case ITEM_USE_TARGET_MONSTER: {
            if (!(battle->floor_status & DNG_FLOOR_DISABLE_ITEMS)) {
                user->GetMonsterBajjiDataPtrMosId(user->monster_id);
                CHARA_DATA *monica = user->GetCharaDataPtr(USER_CHARA_MONICA);

                if ((effect.use_flags & ITEM_USE_FLAG_RESTORE_HP) && monica != NULL && monica->hp.now < monica->hp.max) {
                    count++;

                    if (apply != 0) {
                        monica->hp.AddPoint(effect.value[used]);
                        sound = SYSTEM_SE_RECOVER;
                        used++;
                    }
                }
            }

            break;
        }
    }

    if (used != 0) {
        item->DeleteNum(1);
        MenuSePlay(sound);
    }

    if (apply == 0) {
        return count;
    } else if (apply == 1) {
        return used;
    }

    return 0;
}

int CMenuItemUse::CheckItemUseEnable(CGameDataUsed *item, int kind, void *ptr) {
    if (item == NULL || ptr == NULL) {
        return 0;
    }

    CItemUseTarget target_data;
    target_data.SetPtr(kind, ptr);
    return MenuUseItemCheckFunc(item, &target_data, 0);
}

int CMenuItemUse::UseItem(CGameDataUsed *item, int kind, void *ptr) {
    union {
        CItemUseTarget target_data;
    };

    target_data.SetPtr(kind, ptr);
    MenuUsedTarget.SetPtr(kind, ptr);
    return UseItem(item, &target_data);
}

int CMenuItemUse::UseItem(CGameDataUsed *item, CItemUseTarget *target) {
    if (item == NULL) {
        return 0;
    }

    item_no = item->item_no;
    target_type = target->type;
    MenuUsedTarget.type = target->type;
    MenuUsedTarget.target.data = target->target.data;
    return MenuUseItemCheckFunc(item, target, 1);
}

void CMenuItemUse::Initialize() {
    item_no = 0;
    target_type = 0;
    unk_18 = 0;
}

int CheckNowStateUseThisItem(CGameDataUsed *item, CItemUseTarget *target) {
    return MenuUseItemCheckFunc(item, target, 0);
}
