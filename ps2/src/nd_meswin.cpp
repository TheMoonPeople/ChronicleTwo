#include "snd_mngr.hpp"
#include "scenesnd.hpp"
#include "event_func.hpp"
#include "drawwin.hpp"
#include "npccfg.hpp"
#include "nd_meswin.hpp"
#include "mainloop.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "character.hpp"
#include "savedata.hpp"
#include "userdata.hpp"
#include "scene.hpp"
#include "menucls1.hpp"
#include "mglib.hpp"
#include "font.hpp"
#include "sound.hpp"
#include "dataread.hpp"
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <cstring>

struct message_anchor_table {
    float point[19][2];
};

union message_draw_prim {
    mgCDrawPrim prim;
    u8 storage[0x120];
};

extern "C" void
__ct__11mgCDrawPrimFv(void *self);

extern "C" int fptosi(float value);
extern "C" int sndSePlay__FUiii(unsigned int, int, int);

extern "C" u8 at_4574[];

extern "C" message_anchor_table at_3748;

extern "C" char at_4634[];

extern "C" char at_4635[];

extern "C" char at_4636[];

extern "C" char at_4637[];

static const int mes_buffer_size = 0x200;

static const int min_centered_width = 0x2D;

static const int cursor_tex_x = 0x60;

static const int cursor_tex_y = 0xE8;

static const int cursor_w = 0x28;

static const int cursor_h = 0x18;

static const int movie_ccframes_per_second = 25;

static const int screen_w = 0x200;

static const int movie_ccbottom_y = 0x1D0;

static const int movie_ccslots = 20;

static const int movie_ccstr_size = 0x15E;

const int mes_win_tbl_size = 450;

const int mes_name_count = 16;

const int mes_line_count = 20;

extern "C" void __ct__11mgCDrawPrimFv(void *);

static const unsigned int text_color_dark = 0x80202020;

static const unsigned int text_color_grey = 0x80686A6B;

static const int mes_win_inset_x = 0x1E;

static const int mes_win_inset_y = 0x18;

extern char at_2718[];

const int mes_newline = 0xFF00;

const int mes_end = 0xFF01;

const int mes_space = 0xFF02;

const int mes_page_break = 0xFF03;

extern "C" int GetHalfFontNo__Fc(int ch);

extern char at_2109[];

extern char at_2110[];

extern char at_2111[];

extern char at_2112[];

extern char at_2113[];

extern char at_2114[];

extern char at_2115[];

extern char at_2116[];

extern char at_2117[];

extern char at_2118[];

extern char at_2119[];

extern char at_2120[];

extern char at_2121[];

extern char at_2122[];

extern char at_2123[];

extern char at_2124[];

extern char at_2567[];

char *GetTopAddress(char *text, int size, int id);

#include "common.h"

// Code (.text)
void MySetPrim(mgCDrawPrim *prim, int mode, int bilinear) {
    prim->Initialize(NULL, NULL);
    switch (mode) {
        case 1:
            prim->AlphaBlendEnable(1);
            prim->AlphaBlend(1);
            prim->AlphaTestEnable(1);
            prim->AlphaTest(1, 0);
            prim->DepthTestEnable(0);
            prim->ZMask(-1);
            prim->Shading(0);
            prim->TextureMapEnable(1);
            prim->Bilinear(0);
            prim->AntiAliasing(1);
            break;
        case 3:
            prim->Shading(1);
            prim->TextureMapEnable(1);
            prim->AlphaBlendEnable(1);
            prim->DepthTestEnable(0);
            if (bilinear != 0) {
                prim->Bilinear(1);
            } else {
                prim->Bilinear(0);
            }
            break;
        case 4:
            prim->Shading(1);
            prim->TextureMapEnable(1);
            prim->AlphaBlendEnable(1);
            prim->DepthTestEnable(0);
            if (bilinear != 0) {
                prim->Bilinear(1);
            } else {
                prim->Bilinear(0);
            }
            break;
        case 7:
            prim->AlphaTestEnable(0);
            prim->DepthTestEnable(0);
            prim->ZMask(-1);
            prim->TextureMapEnable(0);
            prim->AlphaBlendEnable(1);
            prim->AntiAliasing(1);
            break;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", set2DSpriteEasy__FP11mgCDrawPrim9mgRect_i_9mgRect_i_P10RGBAQ_TYPE);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", _set2DSprite__FPcP11mgCDrawPrim9mgRect_i_9mgRect_i_P10RGBAQ_TYPE);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", set2DSprite__FP11mgCDrawPrim9mgRect_i_9mgRect_i_P10RGBAQ_TYPE);
void FillRect(int x, int y, int w, int h, int r, int g, int b, int a) {
    message_draw_prim drawer;
    drawer.prim.Initialize(NULL, NULL);
    drawer.prim.AlphaBlendEnable(1);
    drawer.prim.AlphaBlend(1);
    drawer.prim.AlphaTestEnable(1);
    drawer.prim.AlphaTest(1, 0);
    drawer.prim.DepthTestEnable(0);
    drawer.prim.ZMask(-1);
    drawer.prim.Bilinear(0);
    drawer.prim.TextureMapEnable(0);
    drawer.prim.Begin(6);
    drawer.prim.Color(r, g, b, a);
    drawer.prim.Vertex(x, y, 0);
    drawer.prim.Vertex(x + w, y + h, 0);
    drawer.prim.End();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawFukidashi_sub__6ClsMesFP11mgCDrawPrimiii);
void ClsMes::DrawFukidashi(int a, int b, int c) {
    message_draw_prim drawer;
    drawer.prim.Initialize(NULL, NULL);
    drawer.prim.ZMask(-1);
    drawer.prim.AlphaTestEnable(0);
    drawer.prim.AlphaBlendEnable(1);
    drawer.prim.DAlphaTest(0, 0);
    drawer.prim.DepthTestEnable(0);
    drawer.prim.DepthTest(-1);
    drawer.prim.TextureMapEnable(0);
    drawer.prim.Bilinear(1);
    drawer.prim.AntiAliasing(1);
    DrawFukidashi_sub(&drawer.prim, a, b, c);
    drawer.prim.AntiAliasing(0);
    DrawFukidashi_sub(&drawer.prim, a, b, c);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", SetDrawSpeed__6ClsMesFv);
float ClsMes::GetDrawSpeedDef(void) {
    CSaveData *save = GetSaveData();
    if (save != NULL) {
        SV_CONFIG_OPTION *options = &save->config;
        if (options != NULL && options->message_speed == 1) {
            return 0.0f;
        }
    }
    return draw_speed_def;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", GetCaptionOff__6ClsMesFv);
int ClsMes::GetPageAutoFlg(void) {
    return page_auto;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", GetScrPosFromChar__FP11CCharacter2Pi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", GetStrWidth__6ClsMesFPc);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", GetStrWidth__6ClsMesFi);
void ClsMes::AutoSetSub(CCharacter2 *first, CCharacter2 *second, int *screen_pos) {
    GetScrPosFromChar(first, screen_pos);
    GetScrPosFromChar(second, screen_pos + 2);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", CalcAutoPosSetData__FiiiiP4RECT);
void ClsMes::CalcMesWinXYFromFukidashiXY(void) {
    text_x = fukidashi_x + mes_win_inset_x;
    text_y = fukidashi_y + mes_win_inset_y;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", CalcFukidashiXY__6ClsMesFPi);
void ClsMes::AutoSet(int *screen_pos) {
    CalcFukidashiXY(screen_pos);
    fukidashi_centre_x = fukidashi_x + fukidashi_w / 2;
    fukidashi_centre_y = fukidashi_y + fukidashi_h / 2;
    int target_x = screen_pos[0];
    int target_y = screen_pos[1];
    if (tail_on != 0) {
        tail_target_x = target_x;
        tail_target_y = target_y;
        if (tail_target_x <= fukidashi_x + fukidashi_w / 4) {
            tail_root_x = fukidashi_x + fukidashi_w / 4;
        } else if (fukidashi_x + fukidashi_w * 3 / 4 <= tail_target_x) {
            tail_root_x = fukidashi_x + fukidashi_w * 3 / 4;
        } else {
            tail_root_x = tail_target_x;
        }
        if (tail_target_y <= fukidashi_y + fukidashi_h / 4) {
            tail_root_y = fukidashi_y + fukidashi_h / 4;
        } else if (fukidashi_y + fukidashi_h * 3 / 4 <= tail_target_y) {
            tail_root_y = fukidashi_y + fukidashi_h * 3 / 4;
        } else {
            tail_root_y = tail_target_y;
        }
    }
    CalcMesWinXYFromFukidashiXY();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", GetBuffMesIdPtr__FPcii);
void ClsMes::SetHalfFontWPercent(float percent) {
    if (percent < 0.0f) {
        half_font_w_percent = 0.55f;
        return;
    }
    half_font_w_percent = percent;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", __ct__6ClsMesFv);
void ClsMes::SetBuff(short *buffer) {
    buff = buffer;
}
void ClsMes::SetBuff_system(short *buffer) {
    buff_system = buffer;
}
void ClsMes::SetDefColor(u32 rgba) {
    def_color = rgba;
    color = def_color;
}
void ClsMes::Preset(int preset) {
    npc_name_mode = 0;
    char_num = 0;
    text_w = 0;
    text_h = 0;
    page = 0;
    page_num = 0;
    for (int i = 0; i < 16; i++) {
        page_chars[i] = 0;
    }
    last_x = 0;
    last_y = 0;
    *(int *)&fade = 0;
    open = 1;
    draw_speed = GetDrawSpeedDef();
    page_wait = 0;
    scroll_wait = 0;
    reveal = 0;
    reveal_num = 0;
    page_top = 0;
    unk_1f4 = 0;
    InitMesWinTbl();
    color = def_color;
    wait = 0;
    page_time = 0;
    page_auto_time = 30;
    mes_no = -1;
    unk_1e40 = 0;
    alpha = 0x80;
    for (int i = 0; i < 16; i++) {
        memset(name[i], 0, sizeof(name[i]));
    }
    for (int i = 0; i < 16; i++) {
        item_mes[i] = -1;
    }
    for (int i = 0; i < 16; i++) {
        values[i] = 0;
        value_width[i] = 0;
    }
    value = 0;
    value_sign = 0;
    value_zero = 1;
    value_half = 0;
    value_space = 0;
    digit_font = 0;
    space_w = -1;
    justify_w = -1;
    select = -1;
    goal_cursor_x = 0;
    goal_cursor_y = 0;
    cursor_x = 0;
    cursor_y = 0;
    select_shade = 0;
    cursor_centering = 0;
    cursor_time = 0;
    choice_pos[0][0] = -1;
    choice_pos[0][1] = -1;
    choice_pos[1][0] = -1;
    choice_pos[1][1] = -1;
    select_top = 0;
    cursor_off_y = 0;
    voice_on = 0;
    voice_type = 0;
    voice_cnt = 0;
    close_time = 0;
    scissor_on = 0;
    scissor.x = 0;
    scissor.width = 0;
    scissor.y = 0;
    scissor.height = 0;
    for (int i = 0; i < 20; i++) {
        line_indent[i] = 0;
        line_pos[i][0] = 0;
        line_pos[i][1] = 0;
        line_pos_on[i] = 0;
        line_shade[i] = -1;
        line_color[i] = 0;
        equip_on[i] = 0;
        equip_x[i] = 0;
        equip_y[i] = 0;
        line_w[i] = 0;
        line_alpha[i] = -1;
        cross_on[i] = 0;
        cross_x[i] = 0;
        cross_y[i] = 0;
        unk_271c[i] = -1;
        unk_276c[i] = -1;
        unk_27bc[i] = 0;
        unk_280c[i] = 0;
        delta_on[i] = 0;
        delta_x[i] = 0;
        delta_y[i] = 0;
    }
    switch (preset) {
        case 6:
            SetDefColor(text_color_grey);
            cursor_off_y = 0;
            fuchi = 5;
            push_button = 0;
            select_shade = 0;
            abs_win.x = -1;
            abs_win.y = -1;
            abs_win.width = -1;
            abs_win.height = -1;
            draw_speed = 1.0f;
            return;
        case 5:
            window_mode = 1;
            SetDefColor(text_color_dark);
            font_w = 0xF;
            font_h = 0x14;
            columns = 0x15;
            rows = 4;
            draw_speed = 0.0f;
            draw_speed_def = 0.0f;
            fuchi = 0;
            push_button = 1;
            centering = 0;
            line_indent_on = 0;
            fade_speed = 0.2f;
            return;
        case 0:
            SetDrawSpeed();
            window_mode = 1;
            SetDefColor(text_color_dark);
            fuchi = 1;
            push_button = 1;
            return;
        case 1:
            window_mode = 0;
            draw_speed = 0.0f;
            draw_speed_def = 0.0f;
            SetDefColor(text_color_dark);
            fuchi = 2;
            push_button = 0;
            return;
        case 2:
            SetWindowMode(0);
            push_button = 0;
            draw_speed = 0.0f;
            draw_speed_def = 0.0f;
            centering = 0;
            abs_win.x = -1;
            abs_win.y = -1;
            abs_win.width = -1;
            abs_win.height = -1;
            return;
        case 3:
            SetWindowMode(0);
            push_button = 0;
            draw_speed = 0.0f;
            draw_speed_def = 0.0f;
            centering = 0;
            abs_win.x = -1;
            abs_win.y = -1;
            abs_win.width = 0;
            abs_win.height = 0;
            npc_name_mode = 1;
            return;
        case 4:
            SetWindowMode(2);
            push_button = 0;
            draw_speed = 0.0f;
            draw_speed_def = 0.0f;
            fuchi = 5;
            abs_win.x = -1;
            abs_win.y = -1;
            abs_win.width = -1;
            abs_win.height = -1;
    }
}
void ClsMes::SetWindowMode(int mode) {
    if (mode == 2) {
        mode = 4;
    }
    window_mode = mode;
    switch (mode) {
        case 1:
            font_w = 0xF;
            font_h = 0x18;
            SetDefColor(0x80202020U);
            cursor_off_y = 0;
            fuchi = 0;
            push_button = 1;
            select_shade = 2;
            break;
        case 2:
            SetDefColor(0x80686A6BU);
            cursor_off_y = 0;
            fuchi = 5;
            push_button = 0;
            select_shade = 0;
            break;
        case 3:
            SetDefColor(0x80686A6BU);
            cursor_off_y = 0;
            fuchi = 5;
            push_button = 0;
            select_shade = 0;
            break;
        case 4:
            SetDefColor(0x80686A6BU);
            cursor_off_y = 0;
            fuchi = 5;
            push_button = 0;
            select_shade = 0;
            break;
        case 5:
            SetDefColor(0x80686A6BU);
            cursor_off_y = 0;
            fuchi = 5;
            push_button = 0;
            select_shade = 0;
            break;
        case 6:
            SetDefColor(0x80686A6BU);
            cursor_off_y = 0;
            fuchi = 5;
            push_button = 0;
            select_shade = 0;
            break;
        case 8:
            SetDefColor(0x80686A6BU);
            cursor_off_y = 0;
            fuchi = 5;
            push_button = 0;
            select_shade = 0;
            break;
        case 7:
            SetDefColor(0x80686A6BU);
            cursor_off_y = 0;
            fuchi = 8;
            push_button = 1;
            select_shade = 0;
            break;
        case 9:
        case 10:
            SetDefColor(0x80686A6BU);
            cursor_off_y = 0;
            fuchi = 4;
            push_button = 1;
            select_shade = 0;
            break;
        case 11:
            SetDefColor(0x80202020U);
            cursor_off_y = 0;
            fuchi = 0;
            push_button = 1;
            select_shade = 0;
            break;
        case 12:
            window_mode = 0;
            SetDefColor(0x80202020U);
            cursor_off_y = 0;
            fuchi = 0;
            push_button = 0;
            select_shade = 0;
            break;
        default:
            window_mode = 0;
            SetDefColor(0x80686A6BU);
            cursor_off_y = 0;
            fuchi = 8;
            push_button = 0;
            select_shade = 0;
            break;
    }
}
int ClsMes::GetWindowMode(void) {
    return window_mode;
}
void ClsMes::SetWindowBgOpaqueFlg(int opaque) {
    bg_opaque = opaque;
}
void ClsMes::StepNpcName() {
    float pos[4];
    int screen[4];
    int slot;
    int npc_index;
    int chara_index;
    for (slot = 0; slot < mes_line_count; slot++) {
        line_indent[slot] = 0;
        line_pos[slot][0] = 0;
        line_pos[slot][1] = 0;
        line_pos_on[slot] = 0;
        line_shade[slot] = 4;
    }
    for (npc_index = 0; npc_index < mes_name_count; npc_index++) {
        char *name = GetNPCName(GetLocalCnt(npc_index + 8));
        if (name != 0) {
            strcpy(this->name[npc_index], name);
        }
    }
    MakeMesWin(0x11);
    for (chara_index = 0; chara_index < 0x38; chara_index++) {
        if (GetMainScene()->IsActive(1, chara_index + 8) != 0) {
            CCharacter2 *chara = GetMainScene()->GetCharacter(chara_index + 8);
            if (chara != 0 && chara->CheckDraw() != 0) {
                chara->GetPosition(pos);
                pos[1] += 45.0f;
                if (mgTransWorldScreen(screen, pos) != 0 && chara_index >= 0 &&
                    chara_index < mes_name_count) {
                    int name_width = GetStrWidth(GetNPCName(GetLocalCnt(chara_index + 8)));
                    int x = (screen[0] >> 4) - name_width / 2;
                    int y = screen[1] >> 4;
                    y -= font_h;
                    if (x >= 0 && x + name_width < 0x201 && y >= 0 && y + font_h < 0x1A1) {
                        if (chara_index < mes_line_count) {
                            line_pos[chara_index][0] = x;
                            line_pos[chara_index][1] = y;
                            line_pos_on[chara_index] = 1;
                            line_shade[chara_index] = 0;
                        } else {
                            break;
                        }
                    }
                }
            }
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", StepNormal__6ClsMesFv);
void ClsMes::Step(void) {
    if (close_time > 0) {
        close_time -= 1;
        if (close_time <= 0) {
            if (select < 0) {
                cursor_time = 0;
            }
            select = -1;
            draw_speed = GetDrawSpeedDef();
            mes_no = -1;
            unk_1e40 = 0;
            open = 0;
            fade = 0.0f;
            fukidashi_centre_x = -1;
            fukidashi_centre_y = -1;
            fukidashi_pos = 0;
            tail_on = 1;
            SetWindowMode(10);
        }
    }
    switch (npc_name_mode) {
        case 1:
            StepNpcName();
            StepNormal();
            break;
        default:
        case 0:
            StepNormal();
            break;
    }
    if (scroll_speed < 0) {
        scroll_speed = -scroll_speed;
    }
    if (scroll_y <= scroll_goal - scroll_speed) {
        scroll_y += scroll_speed;
        int i;
        int amount = scroll_speed;
        for (i = 0; i < tbl_num; i++) {
            tbl[i].y += amount;
        }
    }
    if (scroll_goal - scroll_speed < scroll_y && scroll_y < scroll_goal) {
        int delta = scroll_y - scroll_goal;
        scroll_y += delta;
        for (int i = 0; i < tbl_num; i++) {
            tbl[i].y += delta;
        }
    }
    if (scroll_y == scroll_goal) {
        scroll_wait = 0;
    }
    if (scroll_goal < scroll_y && scroll_y < scroll_goal + scroll_speed) {
        int delta = scroll_goal - scroll_y;
        scroll_y += delta;
        for (int i = 0; i < tbl_num; i++) {
            tbl[i].y += delta;
        }
    }
    if (scroll_y >= scroll_goal + scroll_speed) {
        scroll_y -= scroll_speed;
        int i;
        int amount = -scroll_speed;
        for (i = 0; i < tbl_num; i++) {
            tbl[i].y += amount;
        }
    }
}
int ClsMes::State() {
    float progress = fade;
    if (progress <= 0.0f) {
        return 0;
    }
    if (0.0f < progress && progress < 1.0f) {
        return open != 0 ? 1 : 4;
    }
    if (page_wait != 0) {
        return 5;
    }
    if (reveal_num >= char_num) {
        return 3;
    }
    return scroll_wait != 0 ? 6 : 2;
}
void ClsMes::GoNextPage() {
    if (page_wait != 0) {
        page_wait = 0;
        page += 1;
        page_time = 0;
        page_top = reveal_num;
    }
}
int ClsMes::MyTextureMake_sub() {
    int index = reveal_num;
    reveal_num = index + 1;
    if (voice_on != 0 && draw_speed > 0.0f) {
        if (reveal_num % 3 == 0) {
            if (voice_type == 1) {
                sndSePlay__FUiii(SystemSND_ID, 7, voice_cnt % 2);
            } else if (voice_type == 2) {
                sndSePlay__FUiii(SystemSND_ID, 6, voice_cnt % 2);
            } else {
                sndSePlay__FUiii(SystemSND_ID, 5, voice_cnt % 2);
            }
            voice_cnt += 1;
        }
    }
    u16 code = tbl[index].code;
    switch (code) {
        case mes_newline:
            reveal += 1.0f;
            return 0;
        case mes_page_break:
            page_wait = 1;
            if (GetPageAutoFlg() != 0 && page_time >= page_auto_time) {
                GoNextPage();
            }
            return 1;
        case mes_end:
            reveal += 1.0f;
            return 2;
        case mes_space:
            reveal += 1.0f;
            return 0;
        default:
            if ((code >= 0xF900 && code <= 0xF9FF) || (code >= 0xF800 && code <= 0xF8FF) ||
                (code >= 0xF700 && code <= 0xF7FF)) {
                reveal += 1.0f;
                return 0;
            }
            wait = tbl[index].wait;
            return 0;
    }
}
void ClsMes::MyTextureMake() {
    if (fade < 1.0f) {
        return;
    }
    if (page_wait != 0) {
        if (GetPageAutoFlg() != 0 && page_time >= page_auto_time) {
            GoNextPage();
        }
        return;
    }
    if (wait > 0) {
        wait -= 1;
    } else if (scroll_wait == 0 && draw_speed > 0.0f) {
        reveal += draw_speed;
    }
    if (GetDrawSpeedDef() == 0.0f && reveal_num >= char_num) {
        return;
    }
    if (!(reveal <= (float)char_num)) {
        reveal = (float)char_num;
    }
    while (draw_speed == 0.0f || !(reveal - (float)reveal_num < 1.0f)) {
        int result = MyTextureMake_sub();
        if (result == 1 || result == 2) {
            if (draw_speed == 0.0f) {
                draw_speed = GetDrawSpeedDef();
                reveal = (float)reveal_num;
            }
            return;
        }
        if (reveal_num >= char_num) {
            draw_speed = GetDrawSpeedDef();
            reveal = (float)reveal_num;
            return;
        }
        if (GetDrawSpeedDef() == 0.0f && reveal_num >= char_num) {
            return;
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", SetAndGetNameRegistTbl__Fi);
void ClsMes::MakeMesWinTbl_value(int *x, int *y) {
    char text[0x80];
    int font_no;
    int length;
    int i;
    if (value_zero != 0 || value != 0) {
        if (value_sign != 0 && value > 0) {
            sprintf((char *)text, at_2109, value);
        } else {
            sprintf((char *)text, at_2110, value);
        }
        length = strlen((char *)text);
        for (i = 0; i < length; i++) {
            font_no = -1;
            if (value_half != 0) {
                font_no = GetHalfFontNo__Fc(text[i]);
            } else {
                if (text[i] == '+') {
                    font_no = GetFontNo(at_2111);
                }
                if (text[i] == '-') {
                    font_no = GetFontNo(at_2112);
                }
                if (text[i] == '1') {
                    font_no = GetFontNo(at_2113);
                }
                if (text[i] == '2') {
                    font_no = GetFontNo(at_2114);
                }
                if (text[i] == '3') {
                    font_no = GetFontNo(at_2115);
                }
                if (text[i] == '4') {
                    font_no = GetFontNo(at_2116);
                }
                if (text[i] == '5') {
                    font_no = GetFontNo(at_2117);
                }
                if (text[i] == '6') {
                    font_no = GetFontNo(at_2118);
                }
                if (text[i] == '7') {
                    font_no = GetFontNo(at_2119);
                }
                if (text[i] == '8') {
                    font_no = GetFontNo(at_2120);
                }
                if (text[i] == '9') {
                    font_no = GetFontNo(at_2121);
                }
                if (text[i] == '0') {
                    font_no = GetFontNo(at_2122);
                }
                printf(at_2123, GetFontNo(at_2122));
                printf(at_2124, GetFontNo(at_2121));
            }
            if (font_no >= 0) {
                SetMesWinTbl(font_no, *x, *y);
                if (value_half != 0) {
                    *x = *x + (font_w / 2 + value_space);
                } else {
                    *x = *x + (font_w + value_space);
                }
            }
        }
    }
}
void ClsMes::MakeMesWinTbl_value(int value_no, int *x, int *y) {
    char text[0x80];
    int font_no;
    int length;
    int i;
    if (value_zero != 0 || values[value_no] != 0) {
        if (value_sign != 0 && values[value_no] > 0) {
            sprintf((char *)text, at_2109, values[value_no]);
        } else {
            sprintf((char *)text, at_2110, values[value_no]);
        }
        length = strlen((char *)text);
        if (value_width[value_no] > 0) {
            *x += (value_width[value_no] - length) * (font_w + value_space);
        }
        for (i = 0; i < length; i++) {
            font_no = -1;
            if (value_half != 0) {
                font_no = GetHalfFontNo__Fc(text[i]);
            } else {
                if (text[i] == '+') {
                    font_no = GetFontNo(at_2111);
                }
                if (text[i] == '-') {
                    font_no = GetFontNo(at_2112);
                }
                if (text[i] == '1') {
                    font_no = GetFontNo(at_2113);
                }
                if (text[i] == '2') {
                    font_no = GetFontNo(at_2114);
                }
                if (text[i] == '3') {
                    font_no = GetFontNo(at_2115);
                }
                if (text[i] == '4') {
                    font_no = GetFontNo(at_2116);
                }
                if (text[i] == '5') {
                    font_no = GetFontNo(at_2117);
                }
                if (text[i] == '6') {
                    font_no = GetFontNo(at_2118);
                }
                if (text[i] == '7') {
                    font_no = GetFontNo(at_2119);
                }
                if (text[i] == '8') {
                    font_no = GetFontNo(at_2120);
                }
                if (text[i] == '9') {
                    font_no = GetFontNo(at_2121);
                }
                if (text[i] == '0') {
                    font_no = GetFontNo(at_2122);
                }
            }
            if (font_no >= 0) {
                SetMesWinTbl(font_no, *x, *y);
                if (value_half != 0) {
                    *x = *x + (font_w / 2 + value_space);
                } else {
                    *x = *x + (font_w + value_space);
                }
            }
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", MakeMesWinTbl_str__6ClsMesFPcPiPi);
void ClsMes::MakeMesWinTbl_str(int i, int *a2, int *a3) { this->MakeMesWinTbl_str((char*)this + i*50 + 0x1E59, a2, a3); }
int ClsMes::MakeMesWinTbl_item(int ref_code, int *x, int *y) {
    u16 *cursor;
    int code;
    int line_no;
    short *name;
    int name_char;
    if (ref_code <= 0xFAFF) {
        return 0;
    }
    if (ref_code > 0xFBFF) {
        return 0;
    }
    switch ((ref_code - 0x8000) - 0x7B00) {
        case 0xFE:
            line_no = item_mes[0];
            break;
        case 0xFD:
            line_no = item_mes[1];
            break;
        case 0xFC:
            line_no = item_mes[2];
            break;
        case 0xFB:
            line_no = item_mes[3];
            break;
        case 0xF2:
            line_no = item_mes[4];
            break;
        case 0xF1:
            line_no = item_mes[5];
            break;
        case 0xF0:
            line_no = item_mes[6];
            break;
        case 0xEF:
            line_no = item_mes[7];
            break;
        case 0xEE:
            line_no = item_mes[8];
            break;
        case 0xED:
            line_no = item_mes[9];
            break;
        case 0xEC:
            line_no = item_mes[10];
            break;
        case 0xEB:
            line_no = item_mes[11];
            break;
        case 0xEA:
            line_no = item_mes[12];
            break;
        case 0xE9:
            line_no = item_mes[13];
            break;
        case 0xE8:
            line_no = item_mes[14];
            break;
        case 0xE7:
            line_no = item_mes[15];
            break;
        default:
            return 0;
    }
    if (line_no < 0) {
        return 0;
    }
    if (buff_system == 0) {
        return 0;
    }
    cursor = (u16 *)GetTextLineDataTop_system(line_no);
    if (cursor == 0) {
        return 0;
    }
    for (;;) {
        switch (code = *cursor++) {
            case mes_end:
                return 1;
            case mes_space:
                SetMesWinTbl(code, *x, *y);
                if (justify_w >= 0 || space_w >= 0) {
                    *x += space_w;
                } else {
                    *x += font_w / 2;
                }
                continue;
            case mes_newline:
                SetMesWinTbl(code, *x, *y);
                *x = 0;
                *y += font_h;
                continue;
            default:
                if (code >= 0xFAFA && code < 0xFB00) {
                    name = SetAndGetNameRegistTbl((code - 0x8000) - 0x7AFA);
                    if (name != 0) {
                        name_char = *name;
                        while (name_char != mes_newline && name_char != mes_end) {
                            SetMesWinTbl(name_char, *x, *y);
                            if (((CFont *)this)->CheckKanjiFont(name_char) != 0) {
                                *x = *x + font_w;
                            } else if (((CFont *)this)->CheckKanjiFont(name[1]) != 0) {
                                *x = *x + font_w;
                            } else {
                                *x = *x + font_w;
                            }
                            name++;
                            name_char = *name;
                        }
                    }
                } else if (code >= 0xFAEA && code < 0xFAFA) {
                    printf(at_2567);
                } else if (code >= 0xFFA0 && code < 0x10000) {
                    SetMesWinTbl(GetAlphabeticalFontNo_us(code) & 0xFFFF, *x, *y);
                    *x += fptosi((float)font_w * half_font_w_percent);
                } else if (code >= 0xFDE0 && code < 0xFDF8) {
                    SetMesWinTbl(GetFontNoFromFontGaijiCode(code) & 0xFFFF, *x, *y);
                    *x += font_w;
                } else if (code >= 0xFD00 && code < 0xFD32) {
                    SetMesWinTbl(code, *x, *y);
                    *x += GetGaijiW(code);
                } else if (code >= 0xF700 && code < 0xF800) {
                    justify_w = ((code - 0x8000) - 0x7700) * 4;
                    space_w = CalcSpaceW(justify_w, font_w, cursor - 1);
                } else if (code >= 0xF800 && code < 0xF900) {
                    space_w = (code - 0x8000) - 0x7800;
                } else if (code >= 0xF900 && code < 0xFA00) {
                    *x += (code - 0x8000) - 0x7900;
                } else {
                    SetMesWinTbl(code, *x, *y);
                    if (((CFont *)this)->CheckHalfFont(code) != 0) {
                        if (code == GetHalfFontNo__Fc(0x20)) {
                            *x = *x + font_w / 2;
                        } else {
                            *x = *x + fptosi((float)font_w * half_font_w_percent);
                        }
                        ((CFont *)this)->CheckKanjiFont(*cursor);
                    } else if (((CFont *)this)->CheckKanjiFont(code) != 0) {
                        *x += font_w;
                    } else if (((CFont *)this)->CheckKanjiFont(*cursor) != 0) {
                        *x += font_w;
                    } else {
                        *x += font_w;
                    }
                }
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", GetMesWidth_system__6ClsMesFi);
short *ClsMes::GetTextLineDataTop(int line_id) {
    short *table = buff;
    int i = 0;
    int count = *table;
    short *entries = table + 1;
    int off;
    if (0 < count) {
        off = 0;
        do {
            if (line_id == *(u16 *)((u8 *)entries + off + 2)) {
                return entries + count + *(u16 *)((i << 2) + (int)entries + 4);
            }
            i++;
            off += 4;
        } while (i < count);
    }
    return 0;
}
short *ClsMes::GetTextLineDataTop_system(int line_id) {
    short *table = buff_system;
    int i = 0;
    int count = *table;
    short *entries = table + 1;
    int off;
    if (0 < count) {
        off = 0;
        do {
            if (line_id == *(u16 *)((u8 *)entries + off + 2)) {
                return entries + count + *(u16 *)((i << 2) + (int)entries + 4);
            }
            i++;
            off += 4;
        } while (i < count);
    }
    return 0;
}
void ClsMes::InitMesWinTbl(void) {
    int i;
    for (i = 0; i < mes_win_tbl_size; i++) {
        tbl[i].code = 0;
        tbl[i].x = 0;
        tbl[i].y = 0;
        tbl[i].color = 0;
        tbl[i].wait = 0;
    }
    tbl_num = 0;
    scroll_y = 0;
    scroll_goal = 0;
    scroll_speed = 0;
}
int ClsMes::SetMesWinTbl(int code, short x, short y) {
    if (code >= 0xFE00 && code < 0xFF00) {
        if (tbl_num > 0) {
            tbl[tbl_num - 1].wait += (code - 0x8000 - 0x7E00) & 0xFF;
        }
        return 0;
    }
    if (code >= 0xFC00 && code < 0xFD00) {
        switch (code - 0x8000 - 0x7C00) {
            case 0:
                color = def_color;
                break;
            case 1:
                color = 0x8022227F;
                break;
        }
        return 0;
    }
    if (code >= 0xF500 && code < 0xF600) {
        color = (color & ~0xFF) | ((code - 0x8000 - 0x7500) & 0xFF);
    }
    if (code >= 0xF400 && code < 0xF500) {
        color = (color & 0xFFFF00FF) | (((code - 0x8000 - 0x7400) & 0xFF) << 8);
    }
    if (code >= 0xF300 && code < 0xF400) {
        color = (color & 0xFF00FFFF) | (((code - 0x8000 - 0x7300) & 0xFF) << 16);
    }
    if (code >= 0xF200 && code < 0xF300) {
        color = (color & 0xFFFFFF) | (((code - 0x8000 - 0x7200) & 0xFF) << 24);
    }
    if (code == 0xFF04) {
        voice_type = 1;
    }
    if (code == 0xFF05) {
        voice_type = 0;
    }
    if (code == 0xFF06) {
        voice_type = 2;
    }
    if (tbl_num < 0x1C2) {
        tbl[tbl_num].code = code;
        tbl[tbl_num].x = x;
        tbl[tbl_num].y = y;
        tbl[tbl_num].color = color;
        tbl_num += 1;
    } else {
        printf(at_2718);
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", CalcSpaceW__6ClsMesFiiPUs);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", MakeMesWinTbl__6ClsMesFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", MakeMesWinTbl__6ClsMesFPc);
int GetItemNoFromFontNo(int font_code) {
    int symbol;
    int item_no;

    symbol = (font_code - 0x8000) - 0x7B00;
    item_no = 1;
    if (symbol != 0xFE) {
        item_no = 2;
        switch (symbol) {
        case 0xE7:
            return 0x10;
        case 0xE8:
            return 0xF;
        case 0xE9:
            return 0xE;
        case 0xEA:
            return 0xD;
        case 0xEB:
            return 0xC;
        case 0xEC:
            return 0xB;
        case 0xED:
            return 0xA;
        case 0xEE:
            return 9;
        case 0xEF:
            return 8;
        case 0xF0:
            return 7;
        case 0xF1:
            return 6;
        case 0xF2:
            return 5;
        case 0xFB:
            return 4;
        case 0xFC:
            return 3;
        case 0xFD:
            return item_no;
        default:
            return -1;
        }
    } else {
        return item_no;
    }
}
void ClsMes::AddYokoHaba(int index, int value) {
    if (value < 0) return;
    line_w[index] += value;
}
void ClsMes::SetYokoHaba(int index, int width) {
    if (width >= 0) {
        line_w[index] = width;
    }
}
void ClsMes::AddPage(int end, int page) {
    int i;
    page_chars[page] = end + 1;
    if (page > 0) {
        for (i = 0; i <= page - 1; i++) {
            page_chars[page] -= page_chars[i];
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", NeedMesWinWH__6ClsMesFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", NeedMesWinWH__6ClsMesFPc);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", MakeMesWin_init__6ClsMesFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", MakeMesWin__6ClsMesFi);
void PreMesMake(char *source, char *buffer) {
    signed char *src = (signed char *)source;
    int length = 0;
    do {
        signed char c = *src;
        if (c == '\\' && src[1] == 'n') {
            src += 2;
            buffer[length++] = '\n';
        } else if (c == '\n') {
            if (src[1] == '@') {
                int next = length + 1;
                buffer[length] = 0;
                buffer[next] = 0;
                break;
            }
            src++;
            buffer[length++] = '\n';
        } else if (c == '\r' && src[1] == '\n') {
            if (src[2] == '@') {
                int next = length + 1;
                buffer[length] = 0;
                buffer[next] = 0;
                break;
            }
            src += 2;
            buffer[length++] = '\n';
        } else {
            buffer[length] = c;
            src++;
            length++;
        }
        if (*src == 0) {
            buffer[length] = 0;
            break;
        }
    } while (length < mes_buffer_size);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", MakeMesWin__6ClsMesFPcii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", MakeAnd3DPosSet__6ClsMesFPcPfii);
void ClsMes::DrawFukidashiShadow() {
    u8 drawer_storage[0x110];

    volatile int screen_origin[4];
    if (fukidashi_centre_x < 0 || fukidashi_centre_y < 0) {
        return;
    }
    float scale = fade;
    float width = (float)fukidashi_w * scale;
    float height = (float)fukidashi_h * scale;
    __ct__11mgCDrawPrimFv(drawer_storage);
    mgCDrawPrim *prim = (mgCDrawPrim *)drawer_storage;
    prim->Initialize(NULL, NULL);
    prim->AlphaTestEnable(0);
    prim->DepthTestEnable(0);
    prim->ZMask(-1);
    prim->TextureMapEnable(0);
    prim->AlphaBlendEnable(1);
    int origin_y = fptosi(draw_off_y);
    screen_origin[0] = fptosi(draw_off_x) * 16;
    screen_origin[1] = origin_y * 16;
    prim->Begin(5);
    prim->Color(0, 0, 0, 0x40);
    int center_x = fptosi(LinerInterpolation((float)fukidashi_centre_x, (float)fukidashi_x, fade));
    int center_y = fptosi(LinerInterpolation((float)fukidashi_centre_y, (float)fukidashi_y, fade));
    for (int i = 0; i < 16; i++) {
        float *point = p[i];
        int x = fptosi(width * (1.0f - point[0]));
        int y = fptosi(height * (1.0f - point[1]));
        x += center_x + 7;
        y += center_y + 7;
        prim->Vertex(x, y, 0);
    }
    prim->End();
}
void CalcRectScale(RECT rect, float scale, RECT *out) {
    out->width = fptosi(rect.width * scale);
    out->height = fptosi(rect.height * scale);
    out->x = rect.x + rect.width / 2 - out->width / 2;
    out->y = rect.y + rect.height / 2 - out->height / 2;
}
void ClsMes::SetSelectCursorPos(RECT rect) {
    CalcSelectCursorPos(rect, &choice_pos[0][0]);
}
void DrawYesNo(mgCDrawPrim *prim, int yes_x, int yes_y, int no_x, int no_y, RGBAQ_TYPE *color) {
    mgRect<int> yesDst;
    mgRect<int> yesSrc;
    mgRect<int> noDst;
    mgRect<int> noSrc;
    yesSrc.Set(0x88, 0xE6, 0x3C, 0x1A);
    yesDst.Set(yes_x, yes_y, 0x3C, 0x1A);
    set2DSprite(prim, yesDst, yesSrc, color);
    noSrc.Set(0xC4, 0xE6, 0x3C, 0x1A);
    noDst.Set(no_x, no_y, 0x3C, 0x1A);
    set2DSprite(prim, noDst, noSrc, color);
}
void GetPos_AbsPosSet(RECT screen, int width, int height, int bubble_pos, int *x, int *y) {
    message_anchor_table anchor = at_3748;
    int pos_x = fptosi(screen.width * anchor.point[bubble_pos - 1][0]);
    pos_x -= width / 2;
    int pos_y = fptosi(screen.height * anchor.point[bubble_pos - 1][1]);
    pos_y -= height / 2;
    if (pos_x < 0) {
        pos_x = 0;
    }
    if (pos_y < 0) {
        pos_y = 0;
    }
    if (pos_x + width > screen.width) {
        pos_x = screen.width - width;
    }
    if (pos_y + height > screen.height) {
        pos_y = screen.height - height;
    }
    pos_x += screen.x;
    pos_y += screen.y;
    *x = pos_x;
    *y = pos_y;
}
float CalcAutoPosSet(float min, float max, float size, float ratio) {
    float position = max - min;
    position -= size;
    position *= ratio;
    position += min;
    return position;
}
RGBAQ_TYPE RgbqToUint(unsigned int color) {
    RGBAQ_TYPE rgbaq;
    rgbaq.r = color & 0xFF;
    rgbaq.g = (color & 0xFF00) >> 8;
    rgbaq.b = (color & 0xFF0000) >> 16;
    rgbaq.a = (color & 0xFF000000) >> 24;
    return rgbaq;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", GetFontColor__6ClsMesFiPi);
int ClsMes::GetGyouAlpha(int line) {
    if (line < select_top) {
        return 0;
    }
    int alpha = line_shade[line];
    if (alpha < 0) {
        int selected = select;
        if (0 <= selected) {
            if (window_mode == 5) {
                return 0;
            }

            switch (select_shade) {
                case -1:
                    return 0;
                case 1:
                    if (line == selected) {
                        return 2;
                    }
                    return 0;
                case 2:
                    if (line == selected) {
                        return 0;
                    }
                    return 3;
                default:
                    return (line == selected) ^ 1;
            }
        }
        return 0;
    }
    return alpha;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawFont__6ClsMesFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", SetGoalCursorXY__6ClsMesFv);
void ClsMes::StepSelectCursor(int steps) {
    int i;

    if (select < 0) {
        cursor_time = 0;
        return;
    }
    SetGoalCursorXY();
    if (cursor_time <= 0) {
        cursor_x = goal_cursor_x;
        cursor_y = goal_cursor_y;
        cursor_time = 1;
        return;
    }
    for (i = 0; i < steps; i++) {
        cursor_x = (cursor_x + goal_cursor_x) / 2;
        cursor_y = (cursor_y + goal_cursor_y) / 2;
        cursor_time += 1;
    }
}
void ClsMes::DrawSelectCursor(mgCDrawPrim *prim) {
    mgRect<int> shadowDst;
    mgRect<int> shadowSrc;
    mgRect<int> cursorDst;
    mgRect<int> cursorSrc;
    RGBAQ_TYPE cursor_color;
    RGBAQ_TYPE shadow_color;
    float progress = fade;
    if ((double)progress < 1.0 || select < 0 ||
        (window_mode == 5 && select != 0 && select != 1)) {
        cursor_time = 0;
        return;
    }
    cursor_color.b = 0x80;
    cursor_color.g = 0x80;
    cursor_color.r = 0x80;

    cursor_color.a = (alpha << 7) / 128;
    shadow_color.b = 0;
    shadow_color.g = 0;
    shadow_color.r = 0;
    shadow_color.a = (alpha << 6) / 128;
    int x;
    int y;
    int offset_x;
    int offset_y;
    if (window_mode == 1) {
        offset_x = fptosi(12.0f * mgSinf(3.1415927f * (float)cursor_time / 20.0f));
        if (0 < offset_x) {
            offset_x = -offset_x;
        }
        offset_x += 8;
        offset_y = 0;
    } else {
        offset_x = fptosi(6.0f * mgCosf(3.1415927f * (float)cursor_time / 60.0f));
        offset_y = fptosi(4.0f * mgSinf(3.1415927f * (float)cursor_time / 30.0f));
    }
    if (window_mode != 1) {
        shadowSrc.Set(cursor_tex_x, cursor_tex_y, cursor_w, cursor_h);
        x = fptosi(draw_off_x + (float)(cursor_x + offset_x + 5));
        y = fptosi(draw_off_y + (float)(cursor_y + offset_y + 5));
        shadowDst.Set(x, y, cursor_w, cursor_h);
        set2DSprite(prim, shadowDst, shadowSrc, &shadow_color);
    }
    cursorSrc.Set(cursor_tex_x, cursor_tex_y, cursor_w, cursor_h);
    float tx = (float)(cursor_x + offset_x);
    x = fptosi(draw_off_x + tx);
    float ty = (float)(cursor_y + offset_y);
    y = fptosi(draw_off_y + ty);
    cursorDst.Set(x, y, cursor_w, cursor_h);
    set2DSprite(prim, cursorDst, cursorSrc, &cursor_color);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawEquipment__6ClsMesFP11mgCDrawPrim);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawCross__6ClsMesFP11mgCDrawPrim);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawRightDelta__6ClsMesFP11mgCDrawPrim);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawDigit__6ClsMesFP11mgCDrawPrimiiiiP10RGBAQ_TYPE);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawPushButton__6ClsMesFP11mgCDrawPrimii);
void ClsMes::CalcCenteringXY(int *x, int *y) {
    int margin;
    int spare;

    *x = 0;
    if (window_mode == 1) {
        if (text_w < min_centered_width) {
            margin = min_centered_width - text_w;
            *x = margin / 2;
        }
    }
    *y = 0;
    if ((window_mode != 1) && (centering != 0)) {
        spare = (rows * font_h) - text_h;
        *y = spare / 2;
    }
}
void ClsMes::SetAbsWinData(RECT *rect) {
    int value;
    value = abs_win.x;
    if (value > -1) {
        rect->x = value;
    }
    value = abs_win.y;
    if (value > -1) {
        rect->y = value;
    }
    value = abs_win.width;
    if (0 < value) {
        rect->width = value;
    }
    value = abs_win.height;
    if (0 < value) {
        rect->height = value;
    }
}
void ClsMes::SetOuterRectXYFromFukidashiPos(RECT *rect) {
    if (fukidashi_pos > 0) {
        RECT screen;
        screen.x = 0x10;
        screen.y = 0x10;
        screen.width = 0x1E0;
        screen.height = 0x1C0;
        GetPos_AbsPosSet(screen, rect->width, rect->height, fukidashi_pos, &rect->x, &rect->y);
    }
}
void CalcWindowOutRectFromInRect(int type, RECT inner, RECT *outer) {
    outer->x = inner.x - waku_data[type][0];
    outer->y = inner.y - waku_data[type][1];
    outer->width = inner.width + waku_data[type][0] + waku_data[type][2];
    outer->height = inner.height + waku_data[type][1] + waku_data[type][3];
}
void CalcWindowInRectFromOutRect(int type, RECT outer, RECT *inner) {
    inner->x = outer.x + waku_data[type][0];
    inner->y = outer.y + waku_data[type][1];
    inner->width = outer.width - (waku_data[type][0] + waku_data[type][2]);
    inner->height = outer.height - (waku_data[type][1] + waku_data[type][3]);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawMesWin__6ClsMesFv);
void Parametric(float *a, float *b, float *out) {
    sceVu0SubVector(out, b, a);
    out[3] = 1.0f;
    sceVu0Normalize(out, out);
    out[3] = 1.0f;
}
int Quadratic(float a, float b, float c, float *root1, float *root2) {
    float discriminant = b * b - 4.0 * a * c;
    float root = sqrt(discriminant);
    if (discriminant > 0.0f) {
        *root1 = -b + root;
        *root1 = *root1 / (2.0f * a);
        *root2 = -b - root;
        *root2 = *root2 / (2.0f * a);
        return 2;
    }
    if (discriminant == 0.0f) {
        *root1 = -b;
        *root1 /= 2.0f * a;
        return 1;
    }
    return 0;
}
int CalcIntersectionPointSphereAndLine(float *center, float radius, float *line_a, float *line_b, float *hit1,
                                       float *hit2) {
    float direction[4];
    float offset[4];
    float root1;
    float root2;
    int count;

    Parametric(line_a, line_b, direction);
    sceVu0SubVector(offset, line_a, center);
    count = Quadratic(
        direction[0] * direction[0] + direction[1] * direction[1] + direction[2] * direction[2],
        direction[0] * offset[0] + direction[1] * offset[1] + direction[2] * offset[2],
        offset[0] * offset[0] + offset[1] * offset[1] + offset[2] * offset[2] - radius * radius,
        &root1, &root2);
    switch (count) {
        case 2:
            sceVu0ScaleVector(hit2, direction, root2);
            hit2[3] = 1.0f;
            sceVu0AddVector(hit2, hit2, line_a);
            hit2[3] = 1.0f;
        case 1:
            sceVu0ScaleVector(hit1, direction, root1);
            hit1[3] = 1.0f;
            sceVu0AddVector(hit1, hit1, line_a);
            hit1[3] = 1.0f;
            return count;
        default:
            return 0;
    }
}
int CheckPosInOutForArea(float *corner_a, float *corner_b, float *pos) {
    float first;
    float second;
    float lower;
    int axis;

    for (axis = 0; axis < 3; axis++) {
        first = corner_a[axis];
        second = corner_b[axis];
        lower = (first < second) ? first : second;
        if (pos[axis] < lower) {
            return 0;
        }
        first = (first > second) ? first : second;
        if (first < pos[axis]) {
            return 0;
        }
    }
    return 1;
}
int CalcMoveNextPos(float *from, float *to, float distance, float *out) {
    float direction[4];
    from[3] = 1.0f;
    to[3] = 1.0f;
    sceVu0SubVector(direction, to, from);
    direction[3] = 1.0f;
    sceVu0Normalize(direction, direction);
    direction[3] = 1.0f;
    sceVu0ScaleVector(direction, direction, distance);
    direction[3] = 1.0f;
    sceVu0AddVector(out, direction, from);
    direction[3] = 1.0f;
    if (CheckPosInOutForArea(from, out, to)) {
        sceVu0CopyVector(out, to);
        return 1;
    }
    return 0;
}
void InitMovieCC(void) {
    for (int i = 0; i < movie_ccslots; i++) {
        MovieCCStart[i] = 0;
        MovieCCClear[i] = 0;
        memset(MovieCCStr[i], 0, movie_ccstr_size);
    }
}
void MyStrCpyLineFeed(char *dst, char *src) {
    signed char *out;
    signed char *in;

    in = (signed char *)src;
    out = (signed char *)dst;
loop:
    if (*in != 0xA) {
        if (strncmp((char *)in, (char *)at_4574, 2) == 0) {
            in += 2;
            *out = 0xA;
            out += 1;
        } else {
            *out = *in;
            in += 1;
            out += 1;
        }
        goto loop;
    }
    *out = 0;
}
void GetNextLineTop(char **text) {
    char *next = *text;
    while (true) {
        if (*next == '\n') {
            break;
        }
        next++;
    }
    *text = next + 1;
}
char *GetTopAddress(char *text, int size, int id) {
    signed char *cursor = (signed char *)text;
    while (cursor - (signed char *)text < size) {
        if (*cursor == '@') {
            cursor++;
            int found = atoi((char *)cursor);
            if (found == id) {
                GetNextLineTop((char **)&cursor);
                return (char *)cursor;
            }
        }
        cursor++;
    }
    return 0;
}
void MovieCCAnalyze(char *text, int size, int id) {
    char *cursor;
    int script_id;
    int slot;

    if (text == NULL) {
        return;
    }
    if (size <= 0) {
        return;
    }

    if (id > 0 && id < 21) {
        script_id = id + 900;
    } else if (id == 21) {
        script_id = 944;
    } else if (id >= 24 && id < 47) {
        script_id = id + 897;
    } else {
        script_id = 0;
    }
    cursor = GetTopAddress(text, size, script_id);
    if (cursor == NULL) {
        return;
    }
    InitMovieCC();
    slot = 0;
    while ((unsigned int)cursor < (unsigned int)(text + size)) {
        if (strncmp(cursor, at_4634, 5) == 0) {
            cursor += 5;
            MovieCCStart[slot] = (int)(movie_ccframes_per_second * atof(cursor));
            GetNextLineTop(&cursor);
        } else if (strncmp(cursor, at_4635, 5) == 0) {
            cursor += 5;
            MovieCCClear[slot] = (int)(movie_ccframes_per_second * atof(cursor));
            GetNextLineTop(&cursor);
        } else if (strncmp(cursor, at_4636, 5) == 0) {
            cursor += 5;
            MyStrCpyLineFeed(MovieCCStr[slot], cursor);
            slot++;
            GetNextLineTop(&cursor);
        } else if (strncmp(cursor, at_4637, 4) == 0) {
            break;
        } else {
            cursor++;
        }
    }
}
void MovieCCDraw(void) {
    for (int i = 0; i < movie_ccslots; i++) {
        if (MovieCCStart[i] < (int)MovieCCCnt && (int)MovieCCCnt < MovieCCClear[i]) {
            MovieCCFont.CalcDrawWH(MovieCCStr[i], &MovieCCW, &MovieCCH);
            MovieCCFont.DrawDirect(MovieCCStr[i], (screen_w - MovieCCW) / 2,
                                   movie_ccbottom_y - MovieCCH);
        }
    }
    MovieCCCnt++;
}
void MovieCCInit(char *text, int size, int id) {
    if (LanguageCode != 1) {
        MovieCCFont.Init();
        MovieCCFont.SetFuchi(8);

        MovieCCFont.SetClearance(MovieCCFont.clearance_w + 2, MovieCCFont.clearance_h - 6);
        MovieCCCnt = 0;
        MovieCCW = 0;
        MovieCCH = 0;
        MovieCCAnalyze(text, size, id);
    }
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", __sinit_nd_meswin_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", p__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_3748__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_4057__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_4100__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_4143__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_4185__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", data_4206__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", waku_data__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_1124__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_1317__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_1724__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_1758__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2109__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2110__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2111__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2112__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2113__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2114__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2115__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2116__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2117__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2118__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2119__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2120__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2121__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2122__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2123__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2124__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2366__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2367__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2368__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2369__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2370__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2371__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2372__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2373__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2374__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2375__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2376__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2377__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2378__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2379__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2380__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2381__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2382__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2383__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2384__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2385__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2386__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2387__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2388__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2389__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2390__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2391__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2392__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2393__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2394__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2395__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2396__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2397__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2398__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2567__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2718__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_2900__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_4276__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_4472__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_4574__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_4634__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_4635__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_4636__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", at_4637__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/nd_meswin", D_0037AFEC__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(MesAbsDrawOff, 0x4);
INCLUDE_BSS(MovieCCCnt, 0x4);
INCLUDE_BSS(MovieCCW, 0x4);
INCLUDE_BSS(MovieCCH, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(NameRegistTbl, 0xB0);
INCLUDE_BSS(MovieCCFont, 0xC0);
INCLUDE_BSS(MovieCCStart, 0x50);
INCLUDE_BSS(MovieCCClear, 0x50);
INCLUDE_BSS(MovieCCStr, 0x1B60);
