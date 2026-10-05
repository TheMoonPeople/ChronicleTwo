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
extern float cur_ang_1005;
extern s8 init_1006;

#pragma divbyzerocheck on
// Code (.text)
void PrintV(int x, int y, int value, mgCTexture *texture, mgRect<int> rect, int digit_count,
            int right_align, int spacing, SP_RGBA *color) {
    int digits[6];
    CPreSprite sprite;
    CPreSprite spare;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_status", DrawDrumCounter__Fiii);
void DrawActiveItemCursor(int x, int y, float alpha) {
    CPreSprite sprite;
    CPreSprite spare;
    float corner[4];
    float u;
    float v;

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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_status", DrawMainUnitStatusBord__Ff);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_status", DrawRoboUnitStatusBord__Ff);
void DrawMonsterUnitStatusBord(float alpha) {
    CPreSprite prim;
    CPreSprite spare;
    int color[4];
    mgRect<int> rect0;
    mgRect<int> rect1;
    mgRect<int> rect2;
    mgRect<int> rect3;
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
    PrintV(0x6E, 0x18, now_hp, TEX_SystenFrame, rect0, 5,
                                                    1, 0xA, (SP_RGBA *)color);
    rect1.Set(0, 0xE8, 0xC, 0xC);
    PrintV(0xAC, 0x18, max_hp, TEX_SystenFrame, rect1, 5,
                                                    0, 0xA, (SP_RGBA *)color);
    color[0] = 0x80;
    color[1] = 0x80;
    color[2] = 0x80;
    color[3] = 0x80;
    rect2.Set(0, 0xE8, 0xC, 0xC);
    PrintV(0x160, 0x1D, whp[1], TEX_SystenFrame, rect2, 5,
                                                    1, 0xA, (SP_RGBA *)color);
    rect3.Set(0, 0xE8, 0xC, 0xC);
    PrintV(0x163, 0x1D, whp[0], TEX_SystenFrame, rect3, 5,
                                                    0, 0xA, (SP_RGBA *)color);
    if (hp_rate < 0.3f) {
        WarningGage2.warning[0] = 1;
    } else {
        WarningGage2.warning[0] = 0;
    }
    WarningGage2.rate[0] = hp_rate;
    WarningGage2.layout = 0;
}
void DrawStatusBord(void) {
    s16 chr_no = DngUserData->active_chr_no;
    float rate = BattleAreaScene->statusbar_rate;
    WarningGage2.warning[0] = 0;
    WarningGage2.warning[1] = 0;
    WarningGage2.warning[2] = 0;
    LockOnModel.pos[3] = 0;
    switch (chr_no) {
        case 0:
        case 1:
            DrawMainUnitStatusBord(rate);
            break;
        case 2:
            DrawRoboUnitStatusBord(rate);
            break;
        case 3:
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
