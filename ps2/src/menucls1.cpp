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

// Code (.text)
char *GetHatena() {
    /**
     * Full-width placeholder for an unidentified item name.
     */
    static char *MenuHatena = "\x81H\x81H\x81H";
    /**
     * Single-byte placeholder for an unidentified item name.
     */
    static char *MenuHatena_1byte = "???";

    if (LanguageCode >= 2 && LanguageCode < 6) {
        return MenuHatena_1byte;
    }

    return MenuHatena;
}

char *GetMenuBigNum(int number) {
    return MenuBigNum[number % 10];
}

void SetMenuBigNum2(char *out, int number) {
    if (out != 0) {
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
     * Single-byte glyphs used to write decimal item counts.
     */
    static char *sn[10] = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};

    if (out != 0) {
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

        for (b = 0; b < 16; b++) {
            memset(mes->name[b], 0, sizeof(mes->name[b]));
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
        mes->offset_x = 0.0f;
        mes->offset_y = 0.0f;
    }
}

CDC2Mes::CDC2Mes() {
    scissor.Set(0, 0, 0, 0);
    msg_change = 0;
    cursor = -1;
    text_off_x = -1;
    text_off_y = -1;
    mes_no = -1;
    cursor_on = 1;
    put_centering = 0;
    scissor_on = 0;
    scissor.Set(0, 0, 0x200, 0x19F);
    memset(str, 0, 0xC1);
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
    cursor_on = 1;
    put_centering = 0;
    scissor_on = 0;
    scissor.Set(0, 0, mgScreenWidth - 1, mgScreenHeight - 1);

    switch (preset) {
        case 0:
            SetWindowMode(MES_WIN_HELP);
            break;
        case 1:
            SetWindowMode(MES_WIN_HELP);
            fuchi = FUCHI_OUTLINE_WIDE;
            break;
        case 2:
            SetWindowMode(MES_WIN_NONE);
            break;
        case 3:
            SetWindowMode(MES_WIN_VERSATILE_4);
            abs_win.width = 272;
            abs_win.height = 102;
            text_off_x = 16;
            text_off_y = 16;
            value_sign = 1;
            centering = 0;
            break;
        case 4:
        case 5:
            SetWindowMode(MES_WIN_NONE);
            rows = 1;
            value_sign = 1;

            if (preset == 5) {
                fuchi = FUCHI_SHADOW_BLACK_WIDE;
            }

            break;
        case 7:
            SetWindowMode(MES_WIN_NONE);
            rows = 1;
            value_zero = 1;
            fuchi = FUCHI_NONE;
            SetDefColor(0x80141414);
            break;
        case 9:
            SetWindowMode(MES_WIN_NONE);
            fuchi = FUCHI_NONE;
            SetFontColor(6, 6, 6, 128);
            rows = 1;
            value_zero = 1;
            break;
        case 6:
            point_x = 40;
            point_y = -60;
            SetWindowMode(MES_WIN_FLOATING);
            select_shade = MES_SELECT_SHADE_BRIGHT;
            break;
        case 10:
        case 18:
            SetWindowMode(MES_WIN_VERSATILE_1);
            fuchi = FUCHI_NONE;
            push_button = 1;
            fade_speed = 0.1f;

            if (preset == 18) {
                push_button = 0;
            }

            break;
        case 11:
            SetWindowMode(MES_WIN_YESNO);
            fuchi = FUCHI_NONE;
            fade_speed = 0.1f;
            break;
        case 12:
            SetWindowMode(MES_WIN_VERSATILE_3);
            fade_speed = 0.1f;
            break;
        case 8:
        case 13:
            SetWindowMode(MES_WIN_VERSATILE_4);

            if (preset == 8) {
                text_off_x = 16;
                text_off_y = 16;
                abs_win.width = 236;
                abs_win.height = 100;
            }

            break;
        case 14:
            SetWindowMode(MES_WIN_NONE);
            break;
        case 15:
        case 16:
            SetWindowMode(MES_WIN_NONE);

            if (preset == 16) {
                fuchi = FUCHI_SHADOW_BLACK_WIDE;
            }

            break;
        case 17:
            SetWindowMode(MES_WIN_NONE);
            value_zero = 1;
            font_h -= 2;
            break;
        case 19:
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

    if (LanguageCode == 1) {
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
        MenuSePlay(0);
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
        MenuSePlay(0);
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
        MenuSePlay(0);
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
        MenuSePlay(0);
    }

    int buttons = MenuCheckPushButton();

    if (buttons & 1) {
        return cursor == 0 ? 1 : 2;
    }

    if (alt_button == 1 && (buttons & 4)) {
        return cursor == 0 ? 1 : 2;
    }

    if (buttons & 2) {
        return 2;
    }

    return 0;
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
            msg_change = 1;
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
                msg_change = 1;
            }

            strcpy(name[index], "");
        } else {
            if (strcmp(previous[index], strings[index]) != 0) {
                msg_change = 1;
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
            msg_change = 1;
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
            msg_change = 1;
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

            if (item_no == 0x38) {
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

        if (item_no == (int) ITEM_ID_SPECTOL) {
            value_sign = 0;
        } else if (item_no == 0x137) {
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
        names[0] = weapon->GetName(1);
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

        if ((s8) msg_change != 0) {
            ClsMes::mes_no = -1;
            msg_change = 0;
        }

        int choice = cursor;

        if (select < 0) {
            cursor_time = 0;
        }

        select = choice;

        if ((s8) str[0] == 0) {
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
    move_on = 0;

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
                    if (entry->mode == 0 || entry->mode == 2) {
                        entry->dest->CopyGameData(&entry->item);
                    } else if (entry->mode == 1) {
                        entry->dest->CopyDataItem(&entry->item);
                    }

                    entry->active = 0;
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
        move_on = 0;
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

            if (entry->mode == 2) {
                entry->item.DeleteNum(entry->item.GetNum() - 1);
            }

            moving_form->x = start[0];
            moving_form->y = start[1];
            moving_form->SetNextMovePos(goal, 2);
            MENUFORMPARTS_TYPE *part = moving_form->GetPartInfo("item");
            part->etc_info[1] = entry->item.item_no;
            part->etc_info[2] = 0;

            if (part->etc_info[1] == (int) ITEM_ID_SPECTOL) {
                part->etc_info[2] = entry->item.GetSpectolNo();
            }

            if (part->etc_info[1] == 0x1AA) {
                part->etc_info[2] = entry->item.data.item.num;
            }

            part = moving_form->GetPartInfo("num");
            part->etc_info[0] = 0;
            part->etc_info[1] = entry->item.GetNum();
            part->etc_info[2] = 1;
            move_on = 1;
            entry->active = 1;
            break;
        }
    }
}

int CheckRoboShieldKit(CUserDataManager *manager, CGameDataUsed *item, int apply, int *kit_count,
                       int *applied_count) {
    if (item->item_type == ITEM_DATA_ROBO_CORE) {
        int        limit = GetShiledKitLimmit(item->item_no);
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

int MenuUseItemCheckFunc(CGameDataUsed *item, CItemUseTarget *target, int apply) {
    /**
     * Character status bits tested when an item adds or cures a condition.
     */
    static u32 st_bittable[7] = {
        CHARA_STATUS_POISON, CHARA_STATUS_SLOW, CHARA_STATUS_UNK_4, CHARA_STATUS_UNK_8,
        CHARA_STATUS_POWER, CHARA_STATUS_UNK_20, CHARA_STATUS_UNK_40};

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
    MenuUsedNotErrorCode = 0;
    int items_blocked = 0;

    if (battle->floor_status & DNG_FLOOR_DISABLE_ITEMS) {
        items_blocked = 1;
    }

    int party = user->GetNowPartyMember();

    switch (target->type) {
        case ITEM_USE_TARGET_CHARA: {
            if (!(effect.target_flags & 6) && !(effect.target_flags & 0x10)) {
                break;
            }

            chara = (CHARA_DATA *) target->target.data;
            short dead = 0;

            if (chara->hp.GetRate() <= 0.0f) {
                dead = 1;
            }

            if (dead == 1 && (effect.status_flags & 0x10)) {
                break;
            }

            int weapon_type = chara->equip[0].item_type;

            if (!(chara->status_attr & 0x40) || !(effect.status_flags & 0x10)) {
                if (((MenuUsedItemNo == 0x184 && weapon_type == (int) ITEM_DATA_MAX_MELEE) ||
                     (MenuUsedItemNo == 0x185 && weapon_type == (int) ITEM_DATA_MONICA_MELEE)) &&
                    chara->defence < 0x80) {
                    count++;

                    if (apply != 0) {
                        chara->defence += 4;

                        if (chara->defence > 0x80) {
                            chara->defence = 0x80;
                        }

                        sound = 10;
                        used++;
                    }
                }

                if (MenuUsedItemNo == 0x128 && chara->hp.max < 255.0f) {
                    count++;

                    if (apply != 0) {
                        used++;
                        chara->hp.max += 8.0f;
                        sound = 10;

                        if (255.0f < chara->hp.max) {
                            chara->hp.max = 255.0f;
                        }
                    }
                }
            }

            if (items_blocked != 0) {
                break;
            }

            if (MenuUsedItemNo == 0x111) {
                if (dead == 1) {
                    count++;

                    if (apply != 0) {
                        used++;
                        chara->hp.SetFillRate(1.0f);
                        chara->status_attr = 0;
                        sound = 10;
                        battle->practice_actions |= DNG_PRACTICE_ACTION_HEAL;
                    }
                }

                break;
            }

            if ((chara->status_attr & 0x40) && (effect.status_flags & 0x10) && item->item_no != 0x110) {
                MenuUsedNotErrorCode = 1;
                break;
            }

            CHARA_DATA *max = user->GetCharaDataPtr(USER_CHARA_MAX);
            CHARA_DATA *monica = user->GetCharaDataPtr(USER_CHARA_MONICA);
            user->GetMonsterBajjiDataPtrMosId(user->monster_id);

            if (MenuUsedItemNo == 0x10F) {
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

                        sound = 10;
                        battle->practice_actions |= DNG_PRACTICE_ACTION_HEAL;
                    }
                }
            } else if (MenuUsedItemNo == 0x1AA) {
                if (dead == 0 && chara->hp.GetRate() < 1.0f) {
                    count++;

                    if (apply != 0) {
                        used++;
                        chara->hp.AddPoint(item->data.attach.level);
                        sound = 10;
                        battle->practice_actions |= DNG_PRACTICE_ACTION_HEAL;
                    }
                }
            } else {
                if (MenuUsedItemNo == 0x124 && (dead == 1 || chara->hp.max <= chara->hp.now)) {
                    break;
                }

                if ((effect.use_flags & (int) ITEM_USE_FLAG_RESTORE_HP) && dead == 0 && chara->hp.now < chara->hp.max) {
                    count++;

                    if (apply != 0) {
                        chara->hp.AddPoint(effect.value[used]);
                        sound = 10;
                        used++;
                        battle->practice_actions |= DNG_PRACTICE_ACTION_HEAL;
                    }
                }

                int add;
                int cure;
                ConvertItemAttrToCharaAttr(effect.use_flags, &add, &cure);

                if ((add != 0 || cure != 0) && GetNowLoopNo() != (int) LOOP_EDIT) {
                    int available = 0;
                    int changed = 0;

                    if (add != 0) {
                        for (int i = 0; i < 7; i++) {
                            if (!(chara->status_attr & st_bittable[i]) && add == st_bittable[i]) {
                                available = 1;

                                if (apply != 0) {
                                    chara->status_attr |= add;
                                    changed = 1;

                                    if (st_bittable[i] & 0x10) {
                                        chara->status_time[0] = 750;
                                    }

                                    if (st_bittable[i] & 2) {
                                        chara->status_time[1] = 750;
                                    }

                                    if (st_bittable[i] & 8) {
                                        chara->status_time[2] = 750;
                                    }

                                    if (st_bittable[i] & 0x20) {
                                        chara->status_time[2] = 750;
                                    }
                                }
                            }
                        }
                    }

                    int cured = 0;

                    if (cure != 0) {
                        for (int i = 0; i < 7; i++) {
                            if ((chara->status_attr & st_bittable[i]) && (cure & st_bittable[i])) {
                                available = 1;

                                if (apply != 0) {
                                    cured = 1;
                                    changed = 1;
                                    chara->status_attr &= ~cure;
                                }
                            }
                        }

                        if (cured != 0) {
                            sound = 10;
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

            if (MenuUsedItemNo == 0x127) {
                if (weapon->used_type == USED_ITEM_TYPE_WEAPON && !weapon->IsLevelUp() && weapon->IsFishingRod() != 1) {
                    count++;

                    if (apply != 0) {
                        used++;
                        weapon->LevelUp();
                        sound = 30;
                    }
                }
            } else if (MenuUsedItemNo == 0x1A7) {
                sound = CheckRoboShieldKit(user, weapon, apply, &count, &used);
            } else if (MenuUsedItemNo == (int) ITEM_ID_RIDEPOD_FUEL) {
                if (weapon == &user->robo_data.parts[2] && user->robo_data.AddPoint(0.0f) < 1.0f && items_blocked == 0) {
                    count++;

                    if (apply != 0) {
                        user->robo_data.AddPoint(150.0f);
                        sound = 9;
                        used++;
                    }
                }
            } else {
                if ((effect.use_flags & (int) ITEM_USE_FLAG_REPAIR) && weapon->IsRepair() && weapon->IsEnableUseRepair(MenuUsedItemNo)) {
                    count++;

                    if (apply != 0) {
                        int amount = 999;

                        if (weapon->item_type == ITEM_DATA_ROBO_ARM) {
                            amount = (int) (weapon->data.robopart.whp.max / 2.0f);
                        }

                        weapon->Repair(amount);
                        sound = 9;
                        used++;
                    }
                }

                if ((effect.use_flags & (int) ITEM_USE_FLAG_FILL_ABS) && weapon->data.weapon.abs.now < weapon->data.weapon.abs.max) {
                    count++;

                    if (apply != 0) {
                        sound = 10;
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

            if (MenuUsedItemNo == (int) ITEM_ID_RIDEPOD_FUEL) {
                if (user->robo_data.AddPoint(0.0f) < 1.0f && items_blocked == 0) {
                    count++;

                    if (apply != 0) {
                        user->robo_data.AddPoint(150.0f);
                        sound = 9;
                        used++;
                    }
                }
            } else if (items_blocked == 0 && (effect.use_flags & (int) ITEM_USE_FLAG_REPAIR) && robo->hp.now < robo->hp.max) {
                count++;

                if (apply != 0) {
                    sound = 10;
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

                if ((effect.use_flags & (int) ITEM_USE_FLAG_RESTORE_HP) && monica != NULL && monica->hp.now < monica->hp.max) {
                    count++;

                    if (apply != 0) {
                        monica->hp.AddPoint(effect.value[used]);
                        sound = 10;
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
    u64 target_data;
    ((CItemUseTarget *) &target_data)->SetPtr(kind, ptr);
    MenuUsedTarget.SetPtr(kind, ptr);
    return UseItem(item, (CItemUseTarget *) &target_data);
}

int CMenuItemUse::UseItem(CGameDataUsed *item, CItemUseTarget *target) {
    if (item == NULL) {
        return 0;
    }

    item_no = (int) item->item_no;
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
