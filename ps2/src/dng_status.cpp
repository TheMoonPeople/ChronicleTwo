#define MG_DRAWPRIM_MANUAL_CTOR
#include "common.h"
#include "mg_drawprim.hpp"
#include "automap.hpp"
#include "effscript.hpp"
#include "maintex.hpp"
#include "monster.hpp"
#include "font.hpp"
#include "mainloop.hpp"
#include "cameracontrol.hpp"
#include "event_func.hpp"
#include "event.hpp"
#include "menucommon.hpp"
#include "mglib.hpp"
#include "mapload.hpp"
#include <cmath>
#include <cstring>
#include <cstdlib>
#include <cstdio>
#include "savedatadungeon.hpp"
#include "sceneevent.hpp"
#include "snd_seseq.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "dng_effect.hpp"
#include "dng_debug.hpp"
#include "dng_main.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "prespr.hpp"
#include "userdata.hpp"
#include "dng_status.hpp"

extern "C" int fptosi(float value);
extern "C" void __ct__11mgCDrawPrimFv(mgCDrawPrim *);
extern "C" void PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(
    int x, int y, int value, mgCTexture *texture, mgRect<int> *rect,
    int digit_count, int right_align, int spacing, SP_RGBA *color);
extern float cur_ang_1005;
extern s8 init_1006;

#pragma divbyzerocheck on
#include <cmath>

#include "actionchara.hpp"
#include "dng_main.hpp"
#include "maintex.hpp"
#include "prespr.hpp"
#include "scenesnd.hpp"
#include "subgame.hpp"
#include "userdata.hpp"
// Code (.text)
void PrintV(int x, int y, int value, mgCTexture *texture, mgRect<int> rect, int digit_count,
            int right_align, int spacing, SP_RGBA *color) {
    int digits[6];

    int divisor = 1;
    int i;
    int shown;
    int j;
    int k;
    digits[0] = -1;
    digits[1] = -1;
    digits[2] = -1;
    digits[3] = -1;
    digits[4] = -1;
    digits[5] = -1;
    for (j = 0; j < digit_count - 1; j++) {
        divisor *= 10;
    }
    for (k = digit_count - 1; k >= 0; k--) {
        int digit = value / divisor;
        digits[k] = digit;
        value -= digit * divisor;
        divisor /= 10;
    }
    shown = digit_count;
    for (i = digit_count - 1; i > 0; i--) {
        if (digits[i] != 0) {
            break;
        }
        shown--;
    }

    CPreSprite sprite;
    CPreSprite spare;
    __ct__11mgCDrawPrimFv(&sprite);
    __ct__11mgCDrawPrimFv(&spare);
    sprite.Initialize(0, 0);
    sprite.Preset2D();
    sprite.Begin(6);
    sprite.Texture(texture);
    if (color != 0) {
        sprite.Color(color->r, color->g, color->b, color->a);
    } else {
        sprite.Color(0x80, 0x80, 0x80, 0x80);
    }
    if (spacing < 0) {
        spacing = rect.right;
    }
    if (right_align != 0) {
        x += spacing * (digit_count - shown);
    }
    for (shown--; shown >= 0; shown--) {
        sprite.SetIRect(x, y, rect.right, rect.bottom + 1, rect.left + rect.right * digits[shown], rect.top);
        x += spacing;
    }
    sprite.End();
}
#pragma divbyzerocheck reset

void DrawDrumCounter(int x, int y, int value) {
    int digit[6];
    int index;

    index = 0;
    digit[index] = 0;
    digit[1] = 0;
    digit[2] = 0;
    digit[3] = 0;
    digit[4] = 0;
    digit[5] = 0;
    value -= (digit[index] = value / 10000) * 10000;
    value -= (digit[1] = value / 1000) * 1000;
    value -= (digit[2] = value / 100) * 100;
    value -= (digit[3] = value / 10) * 10;
    digit[4] = value;

    CPreSprite sprite[2];

    __ct__11mgCDrawPrimFv(&sprite[0]);
    __ct__11mgCDrawPrimFv(&sprite[1]);
    sprite[0].Initialize(NULL, NULL);
    sprite[0].Preset2D();
    sprite[0].Begin(MG_PRIM_SPRITE);
    sprite[0].Texture(TEX_SystenFrame);
    sprite[0].Color(0x80, 0x80, 0x80, 0x80);
    for (index = 0; index < 5; index++) {
        sprite[0].SetIRect(x, y, 12, 12, digit[index] * 12, 0xE8);
        x += 15;
    }
    sprite[0].End();
}

/**
 * Draws the rotating highlight around the active item slot with its fade alpha.
 */
void DrawActiveItemCursor(int x, int y, float alpha) {
    CPreSprite sprite;
    CPreSprite spare;
    float corner[4];
    float u;
    float v;

    __ct__11mgCDrawPrimFv(&sprite);
    __ct__11mgCDrawPrimFv(&spare);
    sprite.Initialize(0, 0);
    sprite.Preset2D();
    sprite.Bilinear(1);
    sprite.Begin(3);
    sprite.Texture(TEX_SystenFrame);
    sprite.SetAlphaBlend(2);
    sprite.Color(0x80, 0x80, 0x80, fptosi(128.0f * alpha));
    if (init_1006 == 0) {
        cur_ang_1005 = -3.1415927f;
        init_1006 = 1;
    }
    cur_ang_1005 += 0.017453292f;
    if (!(cur_ang_1005 <= 3.1415927f)) {
        cur_ang_1005 -= 25.132742f;
    }
    v = -28.0f;
    u = v;
    corner[0] = x + (u * sinf(cur_ang_1005) - v * cosf(cur_ang_1005));
    corner[1] = y + (v * sinf(cur_ang_1005) + u * cosf(cur_ang_1005));
    sprite.TextureCrd(0x84, 0xCA);
    sprite.Vertex(corner);
    v += 55.0f;
    corner[0] = x + (u * sinf(cur_ang_1005) - v * cosf(cur_ang_1005));
    corner[1] = y + (v * sinf(cur_ang_1005) + u * cosf(cur_ang_1005));
    sprite.TextureCrd(0xB9, 0xCA);
    sprite.Vertex(corner);
    v -= 55.0f;
    u += 55.0f;
    corner[0] = x + (u * sinf(cur_ang_1005) - v * cosf(cur_ang_1005));
    corner[1] = y + (v * sinf(cur_ang_1005) + u * cosf(cur_ang_1005));
    sprite.TextureCrd(0x84, 0xFF);
    sprite.Vertex(corner);
    v += 55.0f;
    u -= 55.0f;
    corner[0] = x + (u * sinf(cur_ang_1005) - v * cosf(cur_ang_1005));
    corner[1] = y + (v * sinf(cur_ang_1005) + u * cosf(cur_ang_1005));
    sprite.TextureCrd(0xB9, 0xCA);
    sprite.Vertex(corner);
    v -= 55.0f;
    u += 55.0f;
    corner[0] = x + (u * sinf(cur_ang_1005) - v * cosf(cur_ang_1005));
    corner[1] = y + (v * sinf(cur_ang_1005) + u * cosf(cur_ang_1005));
    sprite.TextureCrd(0x84, 0xFF);
    sprite.Vertex(corner);
    v += 55.0f;
    corner[0] = x + (u * sinf(cur_ang_1005) - v * cosf(cur_ang_1005));
    corner[1] = y + (v * sinf(cur_ang_1005) + u * cosf(cur_ang_1005));
    sprite.TextureCrd(0xB9, 0xFF);
    sprite.Vertex(corner);
    sprite.End();
}
#ifdef NONMATCHING
void DrawMainUnitStatusBord(float rate) {
    SP_RGBA           color;
    CPreSprite sprite;
    CPreSprite spare;
    extern float      palanim_1023;
    extern s8         init_1024;
    CActionChara     *character;
    CBattleCharaInfo *info;
    CGameDataUsed    *active_items;
    int               hp_max;
    int               hp_now;
    struct charge_position_data { int value[7][2]; };
    charge_position_data charge_position;
    struct charge_glyph_data { int value[4][2]; };
    charge_glyph_data charge_glyph;
    struct status_mask_data { int value[7]; };
    status_mask_data status_mask;
    struct status_glyph_data { s16 value[7][2]; };
    status_glyph_data status_glyph;
    mgRect<int> item_glyph;
    mgRect<int> hp_now_glyph;
    mgRect<int> hp_max_glyph;
    mgRect<int> whp_now_glyph;
    mgRect<int> whp_max_glyph;
    mgRect<int> second_whp_now_glyph;
    mgRect<int> second_whp_max_glyph;
    int               whp[2][2];
    int               abs[2][2];
    int               weapon_y;
    int               hp_y;
    int               weapon_x;
    int               second_weapon_x;
    int               second_weapon_y;
    int               event_running;
    float             hp_rate;
    float             whp_rate[2];
    float             flash[1];
    int               index;
    int               item_x;
    int               charge_max;
    int               charge_now;
    int               element;
    int               alpha;
    int               status_attr;
    int               status_x;
    int               width;
    int               top_right;
    int               bottom_right;
    int               red;
    int               green;
    int               blue;
    int               pulse;
    int               gauge_left;
    int               gauge_right;
    int               number_x;
    s16               weapon_no;
    s16               second_weapon_no;

    color.r = 0x80;
    color.g = 0x80;
    color.b = 0x80;
    color.a = 0x80;
    weapon_y = (int)(80.0f * rate) - 72;
    hp_y = weapon_y;
    weapon_x = 280;
    second_weapon_x = 580 - (int)(300.0f * rate);
    second_weapon_y = 8;
    if (SubGameRunning() != 0) {
        weapon_y = -72;
        weapon_x = 280;
        second_weapon_x = 580;
    }
    event_running = 0;
    character = (CActionChara *)DngMainScene->GetCharacter(0);
    if (character != NULL) {
        event_running = character->CheckRunEvent();
    }
    info = GetBattleCharaInfo();
    hp_max = info->GetMaxHp_i();
    hp_now = info->GetNowHp_i();
    info->GetNowWhp(0, whp[0]);
    info->GetNowWhp(1, whp[1]);
    hp_rate = (float)hp_now / (float)hp_max;
    whp_rate[0] = (float)whp[0][0] / (float)whp[0][1];
    whp_rate[1] = (float)whp[1][0] / (float)whp[1][1];
    if (!init_1024) {
        palanim_1023 = 0.0f;
        init_1024 = 1;
    }
    palanim_1023 += 0.19634955f;
    if (!(palanim_1023 <= 0.0f)) {
        palanim_1023 -= 3.1415927f;
    }
    flash[0] = sinf(palanim_1023);

    __ct__11mgCDrawPrimFv(&sprite);
    __ct__11mgCDrawPrimFv(&spare);

    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Bilinear(0);
    sprite.Texture(TEX_SystenFrame);
    sprite.Color(0x80, 0x80, 0x80, 0x80);
    sprite.SetIRect(24, hp_y, 203, 21, 0, 0x8C);
    sprite.SetIRect(212, hp_y + 14, 12, 12, 0x78, 0xE8);
    sprite.SetIRect(48, hp_y + 18, 149, 47, 0xEC, 0);
    active_items = info->GetActiveItemInfo(0);
    sprite.Texture(TEX_DummyIcon1);
    if (active_items[0].GetNum() > 0) {
        sprite.SetIStretch(54, hp_y + 20, 28, 35, 0, 0, 31, 31);
    }
    if (active_items[1].GetNum() > 0) {
        sprite.SetIStretch(96, hp_y + 20, 28, 35, 32, 0, 31, 31);
    }
    if (active_items[2].GetNum() > 0) {
        sprite.SetIStretch(138, hp_y + 20, 28, 35, 0, 32, 31, 31);
    }
    sprite.End();
    if (event_running != 0) {
        DngStatus.cursor_fade += 0.16666667f;
        if (DngStatus.cursor_fade >= 1.0f) {
            DngStatus.cursor_fade = 1.0f;
        }
    } else {
        DngStatus.cursor_fade -= 0.33333334f;
        if (DngStatus.cursor_fade <= 0.0f) {
            DngStatus.cursor_fade = 0.0f;
        }
    }
    DrawActiveItemCursor(DngStatus.active_item * 42 + 68, hp_y + 38, DngStatus.cursor_fade);
    for (index = 0, item_x = 0; index < 3; index++, active_items++, item_x += 41) {
        if (active_items->GetNum() >= 2) {
            item_glyph.Set(0, 0xE8, 12, 12);
            PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(item_x + 64, hp_y + 45, active_items->GetNum(), TEX_SystenFrame, &item_glyph, 2, 1, 10, NULL);
        }
    }
    charge_max = info->GetMagicSwordCounterMax();
    element = info->GetMagicSwordElem();
    charge_now = info->GetMagicSwordCounterNow();
    extern charge_position_data at_1048__2__DATA;
    charge_position = at_1048__2__DATA;
    extern charge_glyph_data at_1049__DATA;
    charge_glyph = at_1049__DATA;


    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Texture(TEX_SystenFrame);
    alpha = (int)(128.0f * rate);
    sprite.Color(0x80, 0x80, 0x80, alpha);
    for (index = 0; index < charge_max; index++) {
        if (index < charge_now) {
            sprite.SetIRect(charge_position.value[index][0], charge_position.value[index][1], 10, 10,
                              charge_glyph.value[element][0], charge_glyph.value[element][1]);
        } else {
            sprite.SetIRect(charge_position.value[index][0], charge_position.value[index][1], 10, 10, 0xD0, 0xD8);
        }
    }
    sprite.End();
    status_attr = info->GetAttr();
    extern status_mask_data at_1058__2__DATA;
    status_mask = at_1058__2__DATA;
    extern status_glyph_data at_1059__2__DATA;
    status_glyph = at_1059__2__DATA;


    if (status_attr != 0) {
        status_x = 24;
        sprite.Initialize(NULL, NULL);
        sprite.Preset2D();
        sprite.Begin(MG_PRIM_SPRITE);
        sprite.Texture(TEX_StatusIcon);
        sprite.Color(0x80, 0x80, 0x80, alpha);
        for (index = 0; index < 7; index++) {
            if (status_attr & status_mask.value[index]) {
                sprite.SetIRect(status_x, 74, 24, 24, status_glyph.value[index][0], status_glyph.value[index][1]);
                status_x += 26;
            }
        }
        sprite.End();
    }
    width = (int)(171.0f * hp_rate);
    red = 0x80;
    green = 0x80;
    blue = 0x80;
    if (hp_rate < 0.2f) {
        pulse = (int)(-64.0f * flash[0]);
        red = pulse + 0x80;
        green = 0x80 - pulse;
        blue = 0x80 - pulse;
    }
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_TRIANGLE_STRIP);
    sprite.Texture(TEX_SystenFrame);
    sprite.Color(red, green, blue, 0x80);
    if (hp_now > 0) {
        top_right = width + 45;
        bottom_right = top_right;
        if (top_right < 50) {
            top_right = 50;
        }
        if (bottom_right >= 212) {
            bottom_right = 211;
        }
        sprite.TextureCrd(0x46, 0xA2);
        sprite.Vertex(50, hp_y + 6, 0);
        sprite.TextureCrd(0x4E, 0xA2);
        sprite.Vertex(top_right, hp_y + 6, 0);
        sprite.TextureCrd(0x46, 0xA7);
        sprite.Vertex(45, hp_y + 11, 0);
        sprite.TextureCrd(0x4E, 0xA7);
        sprite.Vertex(bottom_right, hp_y + 11, 0);
    }
    sprite.End();
    hp_now_glyph.Set(0, 0xE8, 12, 12);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(161, hp_y + 14, hp_now, TEX_SystenFrame, &hp_now_glyph, 5, 1, 10, NULL);
    hp_max_glyph.Set(0, 0xE8, 12, 12);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(221, hp_y + 14, hp_max, TEX_SystenFrame, &hp_max_glyph, 5, 0, 10, NULL);
    second_weapon_no = info->equip[1].item_no;
    weapon_no = info->equip[0].item_no;
    if (whp_rate[0] < 0.2f) {
        if (whp[0][0] <= 0) {
            pulse = (int)(-64.0f * flash[0]);
            color.r = pulse + 0x80;
            color.g = 0x80 - pulse;
            color.b = 0x80 - pulse;
        } else {
            pulse = (int)(-64.0f * flash[0]);
            color.r = 0x80 - pulse;
            color.g = 0x80 - pulse;
            color.b = 0x80 - pulse;
        }
    } else {
        color.r = 0x80;
        color.g = 0x80;
        color.b = 0x80;
    }
    color.a = 0x80;
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Color(color.r, color.g, color.b, color.a);
    sprite.SetIRect(weapon_x, weapon_y, 148, 50, 0xEC, 0x2E);
    sprite.SetIRect(weapon_x + 64, weapon_y + 19, 12, 12, 0x78, 0xE8);
    if (weapon_no > 0) {
        sprite.Texture(TEX_DummyIcon2);
        sprite.SetIStretch(weapon_x + 4, weapon_y + 10, 28, 35, 0, 0, 31, 31);
        sprite.Texture(TEX_SystenFrame);
        if (whp[0][0] <= 0) {
            sprite.SetIRect(weapon_x + 20, weapon_y + 28, 14, 16, 0x50, 0xBA);
        }
    }
    sprite.End();
    number_x = weapon_x + 76;
    whp_now_glyph.Set(0, 0xE8, 12, 12);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(number_x - 61, weapon_y + 19, whp[0][0], TEX_SystenFrame, &whp_now_glyph, 5, 1, 10, &color);
    whp_max_glyph.Set(0, 0xE8, 12, 12);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(number_x - 4, weapon_y + 19, whp[0][1], TEX_SystenFrame, &whp_max_glyph, 5, 0, 10, &color);
    gauge_left = weapon_x + 36;
    gauge_right = gauge_left + (int)(95.0f * whp_rate[0]);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_TRIANGLE_STRIP);
    sprite.Color(0x80, 0x80, 0x80, 0x80);
    sprite.TextureCrd(0x46, 0xB2);
    sprite.Vertex(gauge_left, weapon_y + 5, 0);
    sprite.TextureCrd(0x4E, 0xB2);
    sprite.Vertex(gauge_right, weapon_y + 5, 0);
    sprite.TextureCrd(0x46, 0xB6);
    sprite.Vertex(gauge_left, weapon_y + 9, 0);
    sprite.TextureCrd(0x4E, 0xB6);
    sprite.Vertex(gauge_right, weapon_y + 9, 0);
    sprite.End();
    info->GetNowAbs(0, abs[0]);
    gauge_left = weapon_x + 38;
    gauge_right = gauge_left + (int)(95.0f * ((float)abs[0][0] / (float)abs[0][1]));
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_TRIANGLE_STRIP);
    sprite.TextureCrd(0x46, 0xB6);
    sprite.Vertex(gauge_left, weapon_y + 10, 0);
    sprite.TextureCrd(0x4E, 0xB6);
    sprite.Vertex(gauge_right, weapon_y + 10, 0);
    sprite.TextureCrd(0x46, 0xBA);
    sprite.Vertex(gauge_left, weapon_y + 13, 0);
    sprite.TextureCrd(0x4E, 0xBA);
    sprite.Vertex(gauge_right, weapon_y + 13, 0);
    sprite.End();
    if (whp_rate[1] < 0.2f) {
        if (whp[1][0] <= 0) {
            pulse = (int)(-64.0f * flash[0]);
            color.r = pulse + 0x80;
            color.g = 0x80 - pulse;
            color.b = 0x80 - pulse;
        } else {
            pulse = (int)(-64.0f * flash[0]);
            color.r = 0x80 - pulse;
            color.g = 0x80 - pulse;
            color.b = 0x80 - pulse;
        }
    } else {
        color.r = 0x80;
        color.g = 0x80;
        color.b = 0x80;
    }
    color.a = 0x80;
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Color(color.r, color.g, color.b, color.a);
    sprite.SetIRect(second_weapon_x + 58, second_weapon_y + 9, 148, 50, 0xEC, 0x60);
    sprite.SetIRect(second_weapon_x + 129, second_weapon_y + 28, 12, 12, 0x78, 0xE8);
    if (second_weapon_no > 0) {
        sprite.Texture(TEX_DummyIcon2);
        sprite.SetIStretch(second_weapon_x + 170, second_weapon_y + 10, 28, 35, 32, 0, 31, 31);
        sprite.Texture(TEX_SystenFrame);
        if (whp[1][0] <= 0) {
            sprite.SetIRect(second_weapon_x + 186, weapon_y + 28, 14, 16, 0x50, 0xBA);
        }
    }
    sprite.End();
    gauge_left = second_weapon_x + 74;
    gauge_right = gauge_left + (int)(95.0f * whp_rate[1]);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_TRIANGLE_STRIP);
    sprite.TextureCrd(0x46, 0xB2);
    sprite.Vertex(gauge_left, second_weapon_y + 47, 0);
    sprite.TextureCrd(0x4E, 0xB2);
    sprite.Vertex(gauge_right, second_weapon_y + 47, 0);
    sprite.TextureCrd(0x46, 0xB6);
    sprite.Vertex(gauge_left, second_weapon_y + 51, 0);
    sprite.TextureCrd(0x4E, 0xB6);
    sprite.Vertex(gauge_right, second_weapon_y + 51, 0);
    sprite.End();
    info->GetNowAbs(1, abs[1]);
    gauge_left = second_weapon_x + 76;
    gauge_right = gauge_left + (int)(95.0f * ((float)abs[1][0] / (float)abs[1][1]));
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_TRIANGLE_STRIP);
    sprite.TextureCrd(0x46, 0xB6);
    sprite.Vertex(gauge_left, second_weapon_y + 52, 0);
    sprite.TextureCrd(0x4E, 0xB6);
    sprite.Vertex(gauge_right, second_weapon_y + 52, 0);
    sprite.TextureCrd(0x46, 0xBA);
    sprite.Vertex(gauge_left, second_weapon_y + 55, 0);
    sprite.TextureCrd(0x4E, 0xBA);
    sprite.Vertex(gauge_right, second_weapon_y + 55, 0);
    sprite.End();
    number_x = second_weapon_x + 142;
    second_whp_now_glyph.Set(0, 0xE8, 12, 12);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(number_x - 61, second_weapon_y + 28, whp[1][0], TEX_SystenFrame, &second_whp_now_glyph, 5, 1, 10, &color);
    second_whp_max_glyph.Set(0, 0xE8, 12, 12);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(number_x - 4, second_weapon_y + 28, whp[1][1], TEX_SystenFrame, &second_whp_max_glyph, 5, 0, 10, &color);
    if (rate >= 1.0f) {
        if (SubGameRunning() != 0) {
            return;
        }
        if (hp_rate < 0.3f) {
            WarningGage2.warning[0] = 1;
        } else {
            WarningGage2.warning[0] = 0;
        }
        if (whp_rate[0] < 0.2f) {
            WarningGage2.warning[1] = 1;
        } else {
            WarningGage2.warning[1] = 0;
        }
        if (whp_rate[1] < 0.2f) {
            WarningGage2.warning[2] = 1;
        } else {
            WarningGage2.warning[2] = 0;
        }
        WarningGage2.rate[0] = hp_rate;
        WarningGage2.rate[1] = whp_rate[0];
        WarningGage2.rate[2] = whp_rate[1];
        WarningGage2.layout = WARNING_GAGE_LAYOUT_MAIN;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_status", DrawMainUnitStatusBord__Ff);
#endif

void DrawRoboUnitStatusBord(float rate) {
    int               color[4];
    CPreSprite sprite;
    CPreSprite spare;
    extern float      palanim_1222;
    extern s8         init_1223;
    CBattleCharaInfo *info;
    int               hp_max;
    int               hp_now;
    int               whp[2];
    int               abs[2];
    float             hp_rate[1];
    float             whp_rate;
    float             flash;
    int               pulse;
    int               width;
    int               top_right;
    int               bottom_right;


    color[0] = 0x80;
    color[1] = 0x80;
    color[2] = 0x80;
    color[3] = 0x80;
    int y = (int)(80.0f * rate) - 72;
    info = GetBattleCharaInfo();
    hp_max = info->GetMaxHp_i();
    hp_now = info->GetNowHp_i();
    info->GetNowWhp(0, whp);
    hp_rate[0] = (float)hp_now / (float)hp_max;
    whp_rate = (float)whp[0] / (float)whp[1];
    if (!init_1223) {
        palanim_1222 = 0.0f;
        init_1223 = 1;
    }
    palanim_1222 += 0.19634955f;
    if (!(palanim_1222 <= 0.0f)) {
        palanim_1222 -= 3.1415927f;
    }
    flash = sinf(palanim_1222);
    if (whp_rate < 0.2f) {
        if (whp_rate <= 0.0f) {
            pulse = (int)(-64.0f * flash);
            color[0] = pulse + 0x80;
            color[1] = 0x80 - pulse;
            color[2] = 0x80 - pulse;
            color[3] = 0x80;
        } else {
            pulse = (int)(-64.0f * flash);
            color[0] = 0x80 - pulse;
            color[1] = 0x80 - pulse;
            color[2] = 0x80 - pulse;
            color[3] = 0x80;
        }
    } else {
        color[0] = 0x80;
        color[1] = 0x80;
        color[2] = 0x80;
        color[3] = 0x80;
    }

    __ct__11mgCDrawPrimFv(&sprite);
    __ct__11mgCDrawPrimFv(&spare);

    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Bilinear(0);
    sprite.Texture(TEX_SystenFrame);
    sprite.Color(0x80, 0x80, 0x80, 0x80);
    sprite.SetIRect(186, y + 8, 42, 22, 0xC0, 0);
    sprite.SetIRect(219, y, 96, 46, 0x120, 0x92);
    sprite.SetIRect(16, y, 192, 42, 0, 0);
    sprite.Color(color[0], color[1], color[2], 0x80);
    sprite.SetIRect(320, y, 176, 40, 0, 0x2A);
    sprite.Color(0x80, 0x80, 0x80, 0x80);
    sprite.SetIRect(106, y + 20, 12, 12, 0x78, 0xE8);
    sprite.Color(color[0], color[1], color[2], 0x80);
    sprite.SetIRect(420, y + 18, 12, 12, 0x78, 0xE8);
    sprite.Texture(TEX_DummyIcon2);
    sprite.Color(0x80, 0x80, 0x80, 0x80);
    sprite.SetIStretch(22, y + 6, 28, 35, 0, 0, 31, 31);
    sprite.Color(color[0], color[1], color[2], 0x80);
    sprite.SetIStretch(460, y + 6, 28, 35, 32, 0, 31, 31);
    sprite.Texture(TEX_SystenFrame);
    sprite.End();
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_TRIANGLE_STRIP);
    sprite.Texture(TEX_SystenFrame);
    sprite.Color(0x80, 0x80, 0x80, 0x80);
    {
        int &saved_width = width;
        top_right = (saved_width = (int)(141.0f * hp_rate[0])) + 58;
    }
    bottom_right = top_right;
    int limit = 196;
    if (bottom_right > limit) {
        bottom_right = limit;
    }
    sprite.TextureCrd(0x50, 0xB4);
    sprite.Vertex(62, y + 5, 0);
    sprite.TextureCrd(0x58, 0xB4);
    sprite.Vertex(top_right, y + 5, 0);
    sprite.TextureCrd(0x50, 0xB9);
    sprite.Vertex(58, y + 9, 0);
    sprite.TextureCrd(0x58, 0xB9);
    sprite.Vertex(bottom_right, y + 9, 0);
    sprite.End();
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_TRIANGLE_STRIP);
    sprite.Texture(TEX_SystenFrame);
    sprite.Color(color[0], color[1], color[2], 0x80);
    top_right = (int)(107.0f * ((float)whp[0] / (float)whp[1])) + 337;
    sprite.TextureCrd(0x46, 0xB2);
    sprite.Vertex(337, y + 8, 0);
    sprite.TextureCrd(0x4E, 0xB2);
    sprite.Vertex(top_right, y + 8, 0);
    sprite.TextureCrd(0x46, 0xB6);
    sprite.Vertex(337, y + 12, 0);
    sprite.TextureCrd(0x4E, 0xB6);
    sprite.Vertex(top_right, y + 12, 0);
    sprite.End();
    int blue = ((SP_RGBA *)&color[2])->r;
    int green = ((SP_RGBA *)&color[1])->r;
    color[1] = green;
    color[2] = blue;
    color[3] = 0x80;
    mgRect<int> whp_now_glyph(0, 0xE8, 12, 12);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(370, y + 18, whp[0], TEX_SystenFrame, &whp_now_glyph, 5, 1, 10, (SP_RGBA *)color);
    mgRect<int> whp_max_glyph(0, 0xE8, 12, 12);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(430, y + 18, whp[1], TEX_SystenFrame, &whp_max_glyph, 5, 0, 10, (SP_RGBA *)color);
    color[0] = 0x80;
    color[1] = 0x80;
    color[2] = 0x80;
    color[3] = 0x80;
    mgRect<int> hp_now_glyph(0, 0xE8, 12, 12);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(56, y + 20, hp_now, TEX_SystenFrame, &hp_now_glyph, 5, 1, 10, (SP_RGBA *)color);
    mgRect<int> hp_max_glyph(0, 0xE8, 12, 12);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(116, y + 20, hp_max, TEX_SystenFrame, &hp_max_glyph, 5, 0, 10, (SP_RGBA *)color);
    info->GetNowAbs(0, abs);
    DrawDrumCounter(230, y + 19, abs[0]);
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Texture(TEX_SystenFrame);
    sprite.Color(0x80, 0x80, 0x80, 0x80);
    sprite.SetIRect(width + 57, y - 3, 8, 24, 0xB0, 0x2A);
    sprite.End();
    if (hp_rate[0] < 0.3f) {
        WarningGage2.warning[0] = 1;
    } else {
        WarningGage2.warning[0] = 0;
    }
    if (whp_rate < 0.2f) {
        WarningGage2.warning[1] = 1;
    } else {
        WarningGage2.warning[1] = 0;
    }
    WarningGage2.rate[0] = hp_rate[0];
    WarningGage2.layout = WARNING_GAGE_LAYOUT_ROBO;
    WarningGage2.rate[1] = whp_rate;
}
void DrawMonsterUnitStatusBord(float alpha) {


    int whp[2];
    int abs[2];
    CBattleCharaInfo *info;
    int max_hp;
    int now_hp;
    float hp_rate;
    int hp_right;
    int hp_bottom_right;
    int whp_left;
    int whp_right;
    int whp_bottom_right;
    int abs_right;
    if (alpha < 1.0f) {
        return;
    }
    info = GetBattleCharaInfo();
    max_hp = info->GetMaxHp_i();
    now_hp = info->GetNowHp_i();
    info->GetNowWhp(0, whp);

    CPreSprite prim;
    CPreSprite spare;
    int color[4];
    mgRect<int> rect0;
    mgRect<int> rect1;
    mgRect<int> rect2;
    mgRect<int> rect3;
    __ct__11mgCDrawPrimFv(&prim);
    __ct__11mgCDrawPrimFv(&spare);
    prim.Initialize(0, 0);
    prim.Preset2D();
    prim.Begin(6);
    prim.Bilinear(0);
    prim.Texture(TEX_SystenFrame);
    prim.Color(0x80, 0x80, 0x80, 0x80);
    prim.SetIRect(0x10, 8, 0xCA, 0x16, 0, 0x52);
    prim.SetIRect(0x12C, 8, 0xC8, 0x24, 0, 0x68);
    prim.SetIRect(0xA2, 0x18, 0xC, 0xC, 0x78, 0xE8);
    prim.SetIRect(0x177, 0x1D, 0xC, 0xC, 0x78, 0xE8);
    prim.End();
    prim.Initialize(0, 0);
    prim.Preset2D();
    prim.Begin(4);
    prim.Texture(TEX_SystenFrame);
    prim.Color(0x80, 0x80, 0x80, 0x80);
    hp_rate = (float)now_hp / (float)max_hp;
    hp_right = fptosi(176.0f * hp_rate) + 0x20;
    hp_bottom_right = hp_right;
    if (hp_bottom_right > 0xC8) {
        hp_bottom_right = 0xC8;
    }
    prim.TextureCrd(0x46, 0xA2);
    prim.Vertex(0x28, 0xE, 0);
    prim.TextureCrd(0x4E, 0xA2);
    prim.Vertex(hp_right, 0xE, 0);
    prim.TextureCrd(0x46, 0xA7);
    prim.Vertex(0x20, 0x13, 0);
    prim.TextureCrd(0x4E, 0xA7);
    prim.Vertex(hp_bottom_right, 0x13, 0);
    prim.End();
    prim.Initialize(0, 0);
    prim.Preset2D();
    prim.Begin(4);
    prim.Bilinear(0);
    prim.Texture(TEX_SystenFrame);
    prim.Color(0x80, 0x80, 0x80, 0x80);
    whp_right = fptosi(137.0f * ((float)whp[0] / (float)whp[1])) + 0x157;
    whp_left = 0x157;
    whp_bottom_right = whp_right + 4;
    whp_left -= 4;
    if (whp_left < 0x153) {
        whp_left = 0x153;
    }
    if (whp_bottom_right > 0x1E1) {
        whp_bottom_right = 0x1E1;
    }
    prim.TextureCrd(0x46, 0xA8);
    prim.Vertex(whp_left, 0xD, 0);
    prim.TextureCrd(0x4E, 0xA8);
    prim.Vertex(whp_right, 0xD, 0);
    prim.TextureCrd(0x46, 0xAC);
    prim.Vertex(0x157, 0x12, 0);
    prim.TextureCrd(0x4E, 0xAC);
    prim.Vertex(whp_bottom_right, 0x12, 0);
    prim.End();
    info->GetNowAbs(0, abs);
    abs_right = fptosi(137.0f * ((float)abs[0] / (float)abs[1])) + 0x157;
    prim.Preset2D();
    prim.Begin(4);
    prim.TextureCrd(0x46, 0xB6);
    prim.Vertex(0x157, 0x14, 0);
    prim.TextureCrd(0x4E, 0xB6);
    prim.Vertex(abs_right, 0x14, 0);
    prim.TextureCrd(0x46, 0xBA);
    prim.Vertex(0x157, 0x17, 0);
    prim.TextureCrd(0x4E, 0xBA);
    prim.Vertex(abs_right, 0x17, 0);
    prim.End();

    color[1] = 0x80;
    color[2] = 0x80;
    color[3] = 0x80;
    color[0] = 0x80;
    color[1] = 0x80;
    color[2] = 0x80;
    color[3] = 0x80;
    rect0.Set(0, 0xE8, 0xC, 0xC);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(0x6E, 0x18, now_hp, TEX_SystenFrame, &rect0, 5,
                                                    1, 0xA, (SP_RGBA *)color);
    rect1.Set(0, 0xE8, 0xC, 0xC);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(0xAC, 0x18, max_hp, TEX_SystenFrame, &rect1, 5,
                                                    0, 0xA, (SP_RGBA *)color);
    color[0] = 0x80;
    color[1] = 0x80;
    color[2] = 0x80;
    color[3] = 0x80;
    rect2.Set(0, 0xE8, 0xC, 0xC);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(0x160, 0x1D, whp[1], TEX_SystenFrame, &rect2, 5,
                                                    1, 0xA, (SP_RGBA *)color);
    rect3.Set(0, 0xE8, 0xC, 0xC);
    PrintV__FiiiP10mgCTexture9mgRect_i_iiiP7SP_RGBA(0x163, 0x1D, whp[0], TEX_SystenFrame, &rect3, 5,
                                                    0, 0xA, (SP_RGBA *)color);
    if (hp_rate < 0.3f) {
        WarningGage2.warning[0] = 1;
    } else {
        WarningGage2.warning[0] = 0;
    }
    WarningGage2.rate[0] = hp_rate;
    WarningGage2.layout = 0;
}

void DrawStatusBord() {
    float rate;
    int   chara;

    chara = DngUserData->active_chr_no;
    rate = BattleAreaScene->statusbar_rate;
    WarningGage2.warning[0] = 0;
    WarningGage2.warning[1] = 0;
    WarningGage2.warning[2] = 0;
    LockOnModel.pos[3] = 0.0f;
    switch (chara) {
    case USER_CHARA_MAX:
    case USER_CHARA_MONICA:
        DrawMainUnitStatusBord(rate);
        break;
    case USER_CHARA_ROBO:
        DrawRoboUnitStatusBord(rate);
        break;
    case USER_CHARA_MONSTER:
        DrawMonsterUnitStatusBord(rate);
        break;
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_status", at_1048__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_status", at_1049__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_status", at_1058__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_status", at_1059__2__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(cur_ang_1005, 0x4);
INCLUDE_BSS(init_1006, 0x4);
INCLUDE_BSS(palanim_1023, 0x4);
INCLUDE_BSS(init_1024, 0x4);
INCLUDE_BSS(palanim_1222, 0x4);
INCLUDE_BSS(init_1223, 0x4);
