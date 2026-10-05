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
#include "gameutil.hpp"
#include <libvu0.h>
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
extern char at_1317[];
extern char at_2366[];
extern char at_2367[];
extern char at_2368[];
extern char at_2369[];
extern char at_2370[];
extern char at_2371[];
extern char at_2372[];
extern char at_2373[];
extern char at_2374[];
extern char at_2375[];
extern char at_2376[];
extern char at_2377[];
extern char at_2378[];
extern char at_2379[];
extern char at_2380[];
extern char at_2381[];
extern char at_2382[];
extern char at_2383[];
extern char at_2384[];
extern char at_2385[];
extern char at_2386[];
extern char at_2387[];
extern char at_2388[];
extern char at_2389[];
extern char at_2390[];
extern char at_2391[];
extern char at_2392[];
extern char at_2393[];
extern char at_2394[];
extern char at_2395[];
extern char at_2396[];
extern char at_2397[];


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

extern char at_1124[];

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
void set2DSpriteEasy(mgCDrawPrim *primitive, mgRect<int> destination,
                     mgRect<int> texture, RGBAQ_TYPE *color) {
    texture.right += texture.left;
    texture.bottom += texture.top;
    destination.right += destination.left;
    destination.bottom += destination.top;
    primitive->Color(color->r, color->g, color->b, color->a);
    primitive->TextureCrd(texture.left, texture.top);
    primitive->Vertex(destination.left, destination.top, 0);
    primitive->TextureCrd(texture.right, texture.bottom);
    primitive->Vertex(destination.right, destination.bottom, 0);
}
void _set2DSprite(char *texture_name, mgCDrawPrim *primitive, mgRect<int> destination,
                  mgRect<int> texture, RGBAQ_TYPE *color) {
    if (MesAbsDrawOff == 0) {
        primitive->Begin(6);
        MySetTex(texture_name, primitive);
        set2DSpriteEasy(primitive, destination, texture, color);
        primitive->End();
    }
}
void set2DSprite(mgCDrawPrim *primitive, mgRect<int> destination,
                 mgRect<int> texture, RGBAQ_TYPE *color) {
    _set2DSprite(at_1124, primitive, destination, texture, color);
}
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
#ifdef NONMATCHING
void ClsMes::DrawFukidashi_sub(mgCDrawPrim *prim, int dx, int dy, int layer) {
    int   outline[16][2];
    float width;
    float height;
    float hit_x;
    float hit_y;
    int   origin_x;
    int   origin_y;
    int   shade;
    int   opacity;
    int   vertex_x;
    int   vertex_y;
    int   tip_x;
    int   tip_y;
    int   left_x;
    int   left_y;
    int   right_x;
    int   right_y;
    int   point;

    if (fukidashi_centre_x < 0 || fukidashi_centre_y < 0) {
        return;
    }
    width = fukidashi_w * fade;
    height = fukidashi_h * fade;
    prim->offset_x = (int)draw_off_x * 16;
    prim->offset_y = (int)draw_off_y * 16;
    prim->Begin(MG_PRIM_TRIANGLE_FAN);
    if (layer == MES_FUKIDASHI_OUTLINE) {
        shade = 0x40;
        opacity = (alpha * 0x40 / 128) & 0xFF;
        prim->Shading(0);
    } else {
        shade = 0xC8;
        opacity = 0x80;
        prim->Shading(1);
    }
    prim->Color(shade, shade, shade, opacity);
    origin_x = (int)LinerInterpolation(fukidashi_centre_x, fukidashi_x, fade);
    origin_y = (int)LinerInterpolation(fukidashi_centre_y, fukidashi_y, fade) + 1;
    for (point = 0; point < 16; point++) {
        vertex_x = (int)(width * (1.0f - p[point][0])) + origin_x + dx;
        vertex_y = (int)(height * (1.0f - p[point][1])) + origin_y + dy;
        if (layer != MES_FUKIDASHI_OUTLINE) {
            if (point == 0) {
                prim->Color(0xFA, 0xFA, 0xFA, 0x80);
            } else {
                prim->Color(0xC8, 0xC8, 0xC8, 0x80);
            }
        }
        outline[point][0] = vertex_x;
        outline[point][1] = vertex_y;
        prim->Vertex(vertex_x, vertex_y, 0);
    }
    prim->End();
    if (tail_on != 0) {
        tip_x = (int)LinerInterpolation(fukidashi_centre_x, tail_tip_x, fade) + dx;
        tip_y = (int)LinerInterpolation(fukidashi_centre_y, tail_tip_y, fade) + dy;
        left_x = (int)LinerInterpolation(fukidashi_centre_x, tail_left_x, fade) + dx;
        left_y = (int)LinerInterpolation(fukidashi_centre_y, tail_left_y, fade) + dy;
        right_x = (int)LinerInterpolation(fukidashi_centre_x, tail_right_x, fade) + dx;
        right_y = (int)LinerInterpolation(fukidashi_centre_y, tail_right_y, fade) + dy;
        for (point = 1; point < 15; point++) {
            if (CalcIntersectionPoint2PAnd2P(tip_x, tip_y, left_x, left_y,
                    outline[point][0], outline[point][1], outline[point + 1][0], outline[point + 1][1], &hit_x, &hit_y)) {
                left_x = (int)hit_x;
                left_y = (int)hit_y;
                break;
            }
        }
        for (point = 1; point < 15; point++) {
            if (CalcIntersectionPoint2PAnd2P(tip_x, tip_y, right_x, right_y,
                    outline[point][0], outline[point][1], outline[point + 1][0], outline[point + 1][1], &hit_x, &hit_y)) {
                right_x = (int)hit_x;
                right_y = (int)hit_y;
                break;
            }
        }
        prim->offset_x = (int)draw_off_x * 16;
        prim->offset_y = (int)draw_off_y * 16;
        prim->Begin(MG_PRIM_TRIANGLE);
        if (layer == MES_FUKIDASHI_OUTLINE) {
            prim->Color(0x40, 0x40, 0x40, 0x80);
        } else {
            prim->Color(0xC8, 0xC8, 0xC8, 0x80);
        }
        prim->Vertex(tip_x, tip_y, 0);
        prim->Vertex(left_x, left_y, 0);
        prim->Vertex(right_x, right_y, 0);
        prim->End();
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawFukidashi_sub__6ClsMesFP11mgCDrawPrimiii);
#endif
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
void ClsMes::SetDrawSpeed() {
    if (LanguageCode == 1 || LanguageCode == 2 || LanguageCode == 3 ||
        LanguageCode == 4 || LanguageCode == 5) {
        draw_speed = 1.2f;
        draw_speed_def = 1.2f;
    } else {
        draw_speed = 0.6f;
        draw_speed_def = 0.6f;
    }
}
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
int ClsMes::GetCaptionOff() {
    int caption_off = 0;
    CSaveData *save = GetSaveData();
    if (save != NULL) {
        SV_CONFIG_OPTION *options = &save->config;
        if (options != NULL) {
            caption_off = (s8)options->caption_off;
        }
    }
    return caption_off;
}
int ClsMes::GetPageAutoFlg(void) {
    return page_auto;
}
void GetScrPosFromChar(CCharacter2 *character, int *screen_position) {
    float world_position[4];
    int projected_position[4];
    character->GetPosition(world_position);
    world_position[1] += 0.85f * character->body_height;
    world_position[3] = 1.0f;
    mgTransWorldScreen(projected_position, world_position);
    screen_position[0] = projected_position[0] / 16;
    screen_position[1] = projected_position[1] / 16;
}
int ClsMes::GetStrWidth(char *text) {
    if (text == NULL) {
        return -1;
    }
    int width = 0;
    int length = strlen(text);
    int index = 0;
    int font_number;
    char *cursor;
    while (index < length) {
        cursor = text + index;
        if (strncmp(cursor, at_1317, 5) == 0) {
            width += fptosi((float)font_w * half_font_w_percent);
            index += 9;
        } else {
            unsigned short gaiji = GetFontGaijiFontNo(cursor);
            if (gaiji != 0) {
                if (GetFontGaijiHankaku(gaiji)) {
                    width += fptosi((float)font_w * half_font_w_percent);
                } else {
                    width += fptosi(2.0f * ((float)font_w * half_font_w_percent));
                }
                index += 2;
            } else {
                font_number = GetHalfFontNo__Fc((s8)*cursor);
                if (font_number == -2) {
                    index++;
                } else if (0 <= font_number) {
                    if (font_number == GetHalfFontNo__Fc(' ')) {
                        width += font_w / 2;
                    } else {
                        width += fptosi((float)font_w * half_font_w_percent);
                    }
                    index++;
                } else {
                    font_number = GetFontNo(cursor);
                    if (font_number <= 0) {
                        index++;
                    } else {
                        if (CheckKanjiFont(font_number)) {
                            width += font_w;
                        } else if (CheckKanjiFont(GetFontNo(cursor + 2))) {
                            width += font_w;
                        } else {
                            width += font_w;
                        }
                        index += 2;
                    }
                }
            }
        }
    }
    return width;
}
int ClsMes::GetStrWidth(int name_index) {
    if (name_index < 0) {
        return -1;
    }
    if (name_index >= MES_NAME_MAX) {
        return -1;
    }
    return GetStrWidth(name[name_index]);
}
void ClsMes::AutoSetSub(CCharacter2 *first, CCharacter2 *second, int *screen_pos) {
    GetScrPosFromChar(first, screen_pos);
    GetScrPosFromChar(second, screen_pos + 2);
}
void CalcAutoPosSetData(int screen_width, int screen_height, int width, int height, RECT *slots) {
    for (int row = 0; row < 3; row++) {
        for (int column = 0; column < 3; column++, slots++) {
            if (column == 0) {
                slots->x = 0;
            } else {
                slots->x = column * (screen_width - width) / 2;
                slots->x += 16;
            }
            if (row == 0) {
                slots->y = 0;
            } else {
                slots->y = row * (screen_height - height) / 2;
                slots->y += 16;
            }
            if (column == 0 || column == 2) {
                slots->width = width + 16;
            } else {
                slots->width = width;
            }
            if (row == 0 || row == 2) {
                slots->height = height + 16;
            } else {
                slots->height = height;
            }
        }
    }
}
void ClsMes::CalcMesWinXYFromFukidashiXY(void) {
    text_x = fukidashi_x + mes_win_inset_x;
    text_y = fukidashi_y + mes_win_inset_y;
}
#ifdef NONMATCHING
void ClsMes::CalcFukidashiXY(int *pos) {
    RECT  slots[3][3];
    int   occupied[3][3];
    float distance[3][3];
    float nearest;
    float farthest;
    int   width;
    int   height;
    int   chosen_x;
    int   chosen_y;
    int   row;
    int   column;

    width = fukidashi_w > 160 ? fukidashi_w : 160;
    height = fukidashi_h > 149 ? fukidashi_h : 149;
    CalcAutoPosSetData(480, 448, width, height, &slots[0][0]);
    chosen_x = 0;
    chosen_y = 0;
    if (fukidashi_pos == 0) {
        for (row = 0; row < 3; row++) {
            for (column = 0; column < 3; column++) {
                occupied[row][column] = CheckPosInOutForRect(&slots[row][column], pos[0], pos[1]);
                if (occupied[row][column] == 0) {
                    occupied[row][column] = CheckPosInOutForRect(&slots[row][column], pos[2], pos[3]);
                }
            }
        }
        for (row = 0; row < 3; row++) {
            for (column = 0; column < 3; column++) {
                if (occupied[row][column] != 0) {
                    distance[row][column] = -1.0f;
                }
                distance[row][column] = GetDisPosToRect(&slots[row][column], pos[0], pos[1]);
                nearest = GetDisPosToRect(&slots[row][column], pos[2], pos[3]);
                if (nearest < distance[row][column]) {
                    distance[row][column] = nearest;
                }
            }
        }
        farthest = 0.0f;
        for (row = 0; row < 3; row++) {
            for (column = 0; column < 3; column++) {
                if (distance[row][column] >= 0.0f && farthest < distance[row][column]) {
                    farthest = distance[row][column];
                    chosen_x = column;
                    chosen_y = row;
                }
            }
        }
    } else {
        chosen_x = (fukidashi_pos - 1) % 3;
        chosen_y = (fukidashi_pos - 1) / 3;
    }
    fukidashi_x = slots[chosen_y][chosen_x].x;
    fukidashi_y = slots[chosen_y][chosen_x].y;
    if (fukidashi_w < 160) {
        fukidashi_x += (160 - fukidashi_w) / 2;
    }
    if (fukidashi_h < 149) {
        fukidashi_y += (149 - fukidashi_h) / 2;
    }
    if (chosen_x == 0) {
        fukidashi_x += 16;
    }
    if (chosen_y == 0) {
        fukidashi_y += 16;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", CalcFukidashiXY__6ClsMesFPi);
#endif
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
char *GetBuffMesIdPtr(char *buffer, int size, int message_id) {
    char *cursor = buffer;
    while (cursor < buffer + size) {
        if (*cursor == '@' && atoi(cursor + 1) == message_id) {
            while (cursor < buffer + size) {
                if (*cursor == '\n') {
                    return cursor + 1;
                }
                cursor++;
            }
            return NULL;
        }
        cursor++;
    }
    return NULL;
}
void ClsMes::SetHalfFontWPercent(float percent) {
    if (percent < 0.0f) {
        half_font_w_percent = 0.55f;
        return;
    }
    half_font_w_percent = percent;
}
#ifdef NONMATCHING
ClsMes::ClsMes() {
    int i;

    CFont::Init();
    npc_name_mode = 0;
    text_x = 100;
    text_y = 50;
    font_w = 15;
    font_h = 24;
    SetHalfFontWPercent(-1.0f);
    SetDrawSize(16, 20);
    columns = 70;
    rows = 5;
    char_num = 0;
    text_w = 0;
    text_h = 0;
    page = 0;
    page_num = 0;
    for (i = 0; i < MES_PAGE_MAX; i++) {
        page_chars[i] = 0;
    }
    last_x = 0;
    last_y = 0;
    fukidashi_centre_x = -1;
    fukidashi_centre_y = -1;
    fukidashi_x = text_x;
    fukidashi_y = text_y;
    fukidashi_w = font_w * columns;
    fukidashi_h = font_h * rows;
    fukidashi_pos = 0;
    tail_on = 1;
    tail_root_x = 300;
    tail_root_y = 200;
    tail_target_x = 320;
    tail_target_y = 200;
    tail_half_w = 8;
    tail_length = 48;
    window_mode = MES_WIN_FUKIDASHI;
    bg_opaque = 0;
    abs_win.x = -1;
    abs_win.y = -1;
    abs_win.width = 0;
    abs_win.height = 0;
    abs_text_off_x = -1;
    abs_text_off_y = -1;
    draw_off_x = 0.0f;
    draw_off_y = 0.0f;
    CFont::unk_b0 = 0.0f;
    CFont::unk_b4 = 0.0f;
    point_x = 0;
    point_y = 0;
    win_color.r = 0x27;
    win_color.g = 0x20;
    win_color.b = 0x20;
    win_color.a = 0x80;
    SetDrawSpeed();
    page_wait = 0;
    page_auto = 0;
    unk_1e0 = 0;
    fade_speed = 0.1f;
    fade = 0.0f;
    open = 1;
    scroll_wait = 0;
    reveal = 0.0f;
    reveal_num = 0;
    page_top = 0;
    unk_1f4 = 0;
    SetDefColor(MES_COLOR_DARK);
    wait = 0;
    page_time = 0;
    page_auto_time = 30;
    mes_no = -1;
    unk_1e40 = 0;
    mes_data = NULL;
    mes_data_size = 0;
    fuchi = FUCHI_SHADOW_BLACK;
    push_button = 1;
    centering = 0;
    line_indent_on = 0;
    alpha = 0x80;
    for (i = 0; i < MES_NAME_MAX; i++) {
        memset(name[i], 0, MES_NAME_LEN);
    }
    for (i = 0; i < MES_ITEM_MAX; i++) {
        item_mes[i] = -1;
    }
    for (i = 0; i < MES_VALUE_MAX; i++) {
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
    select_shade = MES_SELECT_SHADE_DARK;
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
    texture_block = 0;
    scissor_on = 0;
    scissor.x = 0;
    scissor.width = 0;
    scissor.y = 0;
    scissor.height = 0;
    for (i = 0; i < MES_LINE_MAX; i++) {
        line_indent[i] = 0;
        line_pos[i][0] = 0;
        line_pos[i][1] = 0;
        line_pos_on[i] = 0;
        line_shade[i] = MES_SHADE_AUTO;
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
    buff = NULL;
    buff_system = NULL;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", __ct__6ClsMesFv);
#endif
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
#ifdef NONMATCHING
void ClsMes::StepNormal() {
    float centre[2];
    float left[2];
    float left_rotated[2];
    float right[2];
    float right_rotated[2];
    float angle;
    float dx;
    float dy;
    float distance;

    if (window_mode == MES_WIN_FUKIDASHI && (fukidashi_centre_x < 0 || fukidashi_centre_y < 0)) {
        return;
    }
    if (fade_speed == 0.0f) {
        fade = 1.0f;
    } else if (open != 0) {
        if (fade < 1.0f) {
            fade += fade_speed;
        }
        if (fade > 1.0f) {
            fade = 1.0f;
        }
    } else {
        if (fade > 0.0f) {
            fade -= fade_speed;
        }
        if (fade < 0.0f) {
            fade = 0.0f;
        }
    }
    if (tail_on != 0) {
        centre[0] = tail_root_x;
        centre[1] = tail_root_y;
        angle = atan2((float)(tail_target_x - tail_root_x), (float)(tail_target_y - tail_root_y));
        left[0] = tail_root_x - tail_half_w;
        left[1] = tail_root_y;
        RollPos(centre, left, angle, left_rotated);
        tail_left_x = (int)left_rotated[0];
        tail_left_y = (int)left_rotated[1];
        right[0] = tail_root_x + tail_half_w;
        right[1] = tail_root_y;
        RollPos(centre, right, angle, right_rotated);
        tail_right_x = (int)right_rotated[0];
        tail_right_y = (int)right_rotated[1];
        dx = tail_target_x - tail_root_x;
        dy = tail_target_y - tail_root_y;
        distance = sqrt(dx * dx + dy * dy);
        if (distance > 0.0f) {
            tail_tip_x = (int)(tail_length * dx / distance) + tail_root_x;
            tail_tip_y = (int)(tail_length * dy / distance) + tail_root_y;
        } else {
            tail_tip_x = tail_root_x;
            tail_tip_y = tail_root_y;
        }
    }
    MyTextureMake();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", StepNormal__6ClsMesFv);
#endif
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
short *SetAndGetNameRegistTbl(int name_index) {
    if (name_index < 0) {
        return NULL;
    }
    if (name_index >= NAME_REGIST_USED) {
        return NULL;
    }
    for (int character = 0; character < NAME_REGIST_LEN; character++) {
        NameRegistTbl[name_index][character] = mes_newline;
    }
    return NameRegistTbl[name_index];
}
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
#ifdef NONMATCHING
void ClsMes::MakeMesWinTbl_str(char *str, int *x, int *y) {
    char *suffix;
    int length;
    int position;
    int tag_no;
    int handled;
    int font_no;
    int item_code;

    length = strlen(str);
    position = 0;
    while (position < length) {
        handled = 0;
        if (strncmp(&str[position], "//", 2) == 0) {
            position += 2;
            while (GetHalfFontNo__Fc(str[position]) != -2) {
                position++;
            }
            position++;
            handled = 1;
        }
        if (handled == 0 && strncmp(&str[position], "[\x90\x94\x92\x6C", 5) == 0) {
            position += 5;
            tag_no = 0;
            suffix = &str[position];
            if (strncmp(suffix, "\x82\x50]", 3) == 0) {
                tag_no = 1;
            }
            if (strncmp(suffix, "\x82\x51]", 3) == 0) {
                tag_no = 2;
            }
            if (strncmp(suffix, "\x82\x52]", 3) == 0) {
                tag_no = 3;
            }
            if (strncmp(suffix, "\x82\x53]", 3) == 0) {
                tag_no = 4;
            }
            if (strncmp(suffix, "\x82\x54]", 3) == 0) {
                tag_no = 5;
            }
            if (strncmp(suffix, "\x82\x55]", 3) == 0) {
                tag_no = 6;
            }
            if (strncmp(suffix, "\x82\x56]", 3) == 0) {
                tag_no = 7;
            }
            if (strncmp(suffix, "\x82\x57]", 3) == 0) {
                tag_no = 8;
            }
            if (strncmp(suffix, "\x82\x58]", 3) == 0) {
                tag_no = 9;
            }
            if (strncmp(suffix, "\x82\x50\x82\x4F]", 5) == 0) {
                tag_no = 10;
            }
            if (tag_no != 0) {
                position += tag_no < 10 ? 3 : 5;
                handled = 1;
                MakeMesWinTbl_value(tag_no - 1, x, y);
            }
        }
        if (handled == 0 && strncmp(&str[position], "[Number", 7) == 0) {
            position += 7;
            tag_no = 0;
            suffix = &str[position];
            if (strncmp(suffix, "1]", 2) == 0) {
                tag_no = 1;
            }
            if (strncmp(suffix, "2]", 2) == 0) {
                tag_no = 2;
            }
            if (strncmp(suffix, "3]", 2) == 0) {
                tag_no = 3;
            }
            if (strncmp(suffix, "4]", 2) == 0) {
                tag_no = 4;
            }
            if (strncmp(suffix, "5]", 2) == 0) {
                tag_no = 5;
            }
            if (strncmp(suffix, "6]", 2) == 0) {
                tag_no = 6;
            }
            if (strncmp(suffix, "7]", 2) == 0) {
                tag_no = 7;
            }
            if (strncmp(suffix, "8]", 2) == 0) {
                tag_no = 8;
            }
            if (strncmp(suffix, "9]", 2) == 0) {
                tag_no = 9;
            }
            if (strncmp(suffix, "10]", 3) == 0) {
                tag_no = 10;
            }
            if (tag_no != 0) {
                position += tag_no < 10 ? 2 : 3;
                handled = 1;
                MakeMesWinTbl_value(tag_no - 1, x, y);
            }
        }
        if (handled == 0 && strncmp(&str[position], "[\x83\x41\x83\x43\x83\x65\x83\x80", 9) == 0) {
            position += 9;
            tag_no = 0;
            suffix = &str[position];
            if (strncmp(suffix, "\x82\x50]", 3) == 0) {
                tag_no = 1;
            }
            if (strncmp(suffix, "\x82\x51]", 3) == 0) {
                tag_no = 2;
            }
            if (strncmp(suffix, "\x82\x52]", 3) == 0) {
                tag_no = 3;
            }
            if (strncmp(suffix, "\x82\x53]", 3) == 0) {
                tag_no = 4;
            }
            if (strncmp(suffix, "\x82\x54]", 3) == 0) {
                tag_no = 5;
            }
            if (strncmp(suffix, "\x82\x55]", 3) == 0) {
                tag_no = 6;
            }
            if (strncmp(suffix, "\x82\x56]", 3) == 0) {
                tag_no = 7;
            }
            if (strncmp(suffix, "\x82\x57]", 3) == 0) {
                tag_no = 8;
            }
            if (strncmp(suffix, "\x82\x58]", 3) == 0) {
                tag_no = 9;
            }
            if (strncmp(suffix, "\x82\x50\x82\x4F]", 5) == 0) {
                tag_no = 10;
            }
            if (strncmp(suffix, "\x82\x50\x82\x50]", 5) == 0) {
                tag_no = 11;
            }
            if (strncmp(suffix, "\x82\x50\x82\x51]", 5) == 0) {
                tag_no = 12;
            }
            if (strncmp(suffix, "\x82\x50\x82\x52]", 5) == 0) {
                tag_no = 13;
            }
            if (strncmp(suffix, "\x82\x50\x82\x53]", 5) == 0) {
                tag_no = 14;
            }
            if (strncmp(suffix, "\x82\x50\x82\x54]", 5) == 0) {
                tag_no = 15;
            }
            if (strncmp(suffix, "\x82\x50\x82\x55]", 5) == 0) {
                tag_no = 16;
            }
            if (tag_no != 0) {
                position += tag_no < 10 ? 3 : 5;
                handled = 1;
                switch (tag_no) {
                    case 1:
                        item_code = MES_CODE_ITEM_FIRST;
                        break;
                    case 2:
                        item_code = 0xFBFD;
                        break;
                    case 3:
                        item_code = 0xFBFC;
                        break;
                    case 4:
                        item_code = 0xFBFB;
                        break;
                    case 5:
                        item_code = 0xFBF2;
                        break;
                    case 6:
                        item_code = 0xFBF1;
                        break;
                    case 7:
                        item_code = 0xFBF0;
                        break;
                    case 8:
                        item_code = 0xFBEF;
                        break;
                    case 9:
                        item_code = 0xFBEE;
                        break;
                    case 10:
                        item_code = 0xFBED;
                        break;
                    case 11:
                        item_code = 0xFBEC;
                        break;
                    case 12:
                        item_code = 0xFBEB;
                        break;
                    case 13:
                        item_code = 0xFBEA;
                        break;
                    case 14:
                        item_code = 0xFBE9;
                        break;
                    case 15:
                        item_code = 0xFBE8;
                        break;
                    case 16:
                        item_code = MES_CODE_ITEM_LAST;
                        break;
                }
                MakeMesWinTbl_item(item_code, x, y);
            }
        }
        if (handled == 0 && strncmp(&str[position], "[\x95\xB6\x8E\x9A\x97\xF1", 7) == 0) {
            position += 7;
            tag_no = 0;
            suffix = &str[position];
            if (strncmp(suffix, "\x82\x50]", 3) == 0) {
                tag_no = 1;
            }
            if (strncmp(suffix, "\x82\x51]", 3) == 0) {
                tag_no = 2;
            }
            if (strncmp(suffix, "\x82\x52]", 3) == 0) {
                tag_no = 3;
            }
            if (strncmp(suffix, "\x82\x53]", 3) == 0) {
                tag_no = 4;
            }
            if (strncmp(suffix, "\x82\x54]", 3) == 0) {
                tag_no = 5;
            }
            if (strncmp(suffix, "\x82\x55]", 3) == 0) {
                tag_no = 6;
            }
            if (strncmp(suffix, "\x82\x56]", 3) == 0) {
                tag_no = 7;
            }
            if (strncmp(suffix, "\x82\x57]", 3) == 0) {
                tag_no = 8;
            }
            if (strncmp(suffix, "\x82\x58]", 3) == 0) {
                tag_no = 9;
            }
            if (strncmp(suffix, "\x82\x50\x82\x4F]", 5) == 0) {
                tag_no = 10;
            }
            if (strncmp(suffix, "\x82\x50\x82\x50]", 5) == 0) {
                tag_no = 11;
            }
            if (strncmp(suffix, "\x82\x50\x82\x51]", 5) == 0) {
                tag_no = 12;
            }
            if (strncmp(suffix, "\x82\x50\x82\x52]", 5) == 0) {
                tag_no = 13;
            }
            if (strncmp(suffix, "\x82\x50\x82\x53]", 5) == 0) {
                tag_no = 14;
            }
            if (strncmp(suffix, "\x82\x50\x82\x54]", 5) == 0) {
                tag_no = 15;
            }
            if (strncmp(suffix, "\x82\x50\x82\x55]", 5) == 0) {
                tag_no = 16;
            }
            if (tag_no != 0) {
                position += tag_no < 10 ? 3 : 5;
                handled = 1;
                MakeMesWinTbl_str(tag_no - 1, x, y);
            }
        }
        if (handled == 0) {
            font_no = GetAlphabeticalFontNo_cp(&str[position]);
            if (font_no > 0) {
                SetMesWinTbl(font_no, *x, *y);
                position += 9;
                *x += (int)(font_w * half_font_w_percent);
            } else {
                font_no = GetFontGaijiFontNo(&str[position]);
                if (font_no != 0) {
                    SetMesWinTbl(font_no, *x, *y);
                    position += 2;
                    *x += font_w;
                } else {
                    font_no = GetGaijiFontNo(&str[position]);
                    if (font_no > 0) {
                        SetMesWinTbl(font_no, *x, *y);
                        *x += GetGaijiW(font_no);
                        position += GetGaijiLen(font_no);
                    } else if (strncmp(&str[position], "<page>", 6) == 0) {
                        SetMesWinTbl(MES_CODE_PAGE, *x, *y);
                        *x = 0;
                        position += 6;
                        *y = 0;
                    } else {
                        font_no = GetHalfFontNo__Fc(str[position]);
                        if (font_no == -2) {
                            SetMesWinTbl(MES_CODE_NEWLINE, *x, *y);
                            *x = 0;
                            position++;
                            *y += font_h;
                        } else if (CheckHalfFont(font_no) != 0) {
                            SetMesWinTbl(font_no, *x, *y);
                            if (font_no == GetHalfFontNo__Fc(' ')) {
                                *x += font_w / 2;
                            } else {
                                *x += (int)(font_w * half_font_w_percent);
                            }
                            position++;
                        } else {
                            font_no = GetFontNo(&str[position]);
                            if (font_no == -1) {
                                font_no = GetFontNo("\x81\x48");
                            }
                            SetMesWinTbl(font_no, *x, *y);
                            if (CheckKanjiFont(font_no) != 0) {
                                *x += font_w;
                            } else if (CheckKanjiFont(GetFontNo(&str[position + 2])) != 0) {
                                *x += font_w;
                            } else {
                                *x += font_w;
                            }
                            position += 2;
                        }
                    }
                }
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", MakeMesWinTbl_str__6ClsMesFPcPiPi);
#endif
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
#ifdef NONMATCHING
int ClsMes::GetMesWidth_system(int mes_no) {
    unsigned short *text;
    unsigned short  code;
    int             width;
    int             maximum;
    int             inserted_width;

    if (mes_no < 0 || buff_system == NULL) {
        return -1;
    }
    text = (unsigned short *)GetTextLineDataTop_system(mes_no);
    width = 0;
    if (text == NULL) {
        return -1;
    }
    maximum = 0;
    while (1) {
        code = *text++;
        if (code == MES_CODE_NEWLINE) {
            if (maximum < width) {
                maximum = width;
            }
            width = 0;
        } else if (code == MES_CODE_END) {
            break;
        } else if (code >= 0xFAEA && code <= 0xFAF9) {
            inserted_width = GetStrWidth(0xFAF9 - code);
            if (inserted_width != -1) {
                width += inserted_width;
            }
        } else if (code >= 0xFFA0) {
            width += (int)(font_w * half_font_w_percent);
        } else if (code >= 0xFDE0 && code < 0xFDF8) {
            if (GetFontGaijiHankaku(code) != 0) {
                width += (int)(font_w * half_font_w_percent);
            } else {
                width += (int)(2.0f * (font_w * half_font_w_percent));
            }
        } else if (code >= MES_CODE_GAIJI && code < 0xFD32) {
            width += GetGaijiW(code);
        } else if (code >= MES_CODE_MOVE_X && code < 0xFA00) {
            width += code - MES_CODE_MOVE_X;
        } else if (CheckHalfFont(code) != 0) {
            if (code == GetHalfFontNo__Fc(' ')) {
                width += font_w / 2;
            } else {
                width += (int)(font_w * half_font_w_percent);
            }
        } else if (CheckKanjiFont(code) != 0) {
            width += font_w;
        } else if (CheckKanjiFont(*text) != 0) {
            width += font_w;
        } else {
            width += font_w;
        }
    }
    if (maximum < width) {
        return width;
    }
    return maximum;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", GetMesWidth_system__6ClsMesFi);
#endif
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
#ifdef NONMATCHING
int ClsMes::CalcSpaceW(int width, int char_width, unsigned short *text) {
    int            spaces;
    int            used_width;
    unsigned short code;

    spaces = 0;
    used_width = 0;
    while (1) {
        code = *text++;
        if (code == MES_CODE_SPACE) {
            spaces++;
        } else if (code == MES_CODE_END || code == MES_CODE_PAGE || code == MES_CODE_NEWLINE) {
            break;
        } else if (code >= MES_CODE_GAIJI && code < 0xFD32) {
            used_width += GetGaijiW(code);
        } else if (code >= 0xFFA0) {
            used_width += (int)(char_width * half_font_w_percent);
        } else if (code >= 0xFDE0 && code < 0xFDF8) {
            if (GetFontGaijiHankaku(code) != 0) {
                used_width += (int)(font_w * half_font_w_percent);
            } else {
                used_width += (int)(2.0f * (font_w * half_font_w_percent));
            }
        } else if (code >= MES_CODE_MOVE_X && code < 0xFA00) {
            used_width += code - MES_CODE_MOVE_X;
        } else if ((code < MES_CODE_COLOR_DEFAULT || code >= MES_CODE_GAIJI) &&
                   (code < MES_CODE_COLOR_A || code >= 0xF600) &&
                   code != MES_CODE_VOICE_1 && code != MES_CODE_VOICE_0 && code != MES_CODE_VOICE_2) {
            if (CheckHalfFont(code) != 0) {
                if (code == GetHalfFontNo__Fc(' ')) {
                    used_width += char_width / 2;
                } else {
                    used_width += (int)(char_width * half_font_w_percent);
                }
            } else {
                used_width += char_width;
            }
        }
    }
    if (spaces > 0) {
        return (width - used_width) / spaces;
    }
    return -1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", CalcSpaceW__6ClsMesFiiPUs);
#endif
#ifdef NONMATCHING
int ClsMes::MakeMesWinTbl(int mes_no) {
    unsigned short *text;
    short          *registered_name;
    unsigned short  code;
    short           name_code;
    int             x;
    int             y;
    int             value_code;

    if (buff == NULL) {
        return 0;
    }
    text = (unsigned short *)GetTextLineDataTop(mes_no);
    if (text == NULL) {
        return 0;
    }
    InitMesWinTbl();
    draw_speed = GetDrawSpeedDef();
    x = 0;
    y = 0;
    while (1) {
        code = *text++;
        if (code == MES_CODE_NEWLINE || code == MES_CODE_PAGE || code == MES_CODE_END) {
            space_w = -1;
            justify_w = -1;
        }
        if (code == MES_CODE_NEWLINE) {
            SetMesWinTbl(MES_CODE_NEWLINE, x, y);
            x = 0;
            y += font_h;
        } else if (code == MES_CODE_PAGE) {
            SetMesWinTbl(MES_CODE_PAGE, x, y);
            x = 0;
            y = 0;
        } else if (code == MES_CODE_END) {
            break;
        } else if (code == MES_CODE_VOICE_1 || code == MES_CODE_VOICE_0 || code == MES_CODE_VOICE_2) {
            SetMesWinTbl(code, x, y);
        } else if (code == MES_CODE_SPACE) {
            SetMesWinTbl(MES_CODE_SPACE, x, y);
            if (justify_w >= 0 || space_w >= 0) {
                x += space_w;
            } else {
                x += font_w / 2;
            }
        } else if (code >= 0xFFA0) {
            SetMesWinTbl(GetAlphabeticalFontNo_us(code), x, y);
            x += (int)(font_w * half_font_w_percent);
        } else if (code >= 0xFDE0 && code < 0xFDF8) {
            SetMesWinTbl(GetFontNoFromFontGaijiCode(code), x, y);
            x += font_w;
        } else if (code >= MES_CODE_GAIJI && code < 0xFD32) {
            SetMesWinTbl(code, x, y);
            x += GetGaijiW(code);
        } else if ((code >= MES_CODE_COLOR_DEFAULT && code < MES_CODE_GAIJI) ||
                   (code >= MES_CODE_COLOR_A && code < 0xF600)) {
            SetMesWinTbl(code, x, y);
        } else if (code >= MES_CODE_JUSTIFY && code < MES_CODE_SPACE_W) {
            justify_w = (code - MES_CODE_JUSTIFY) * 4;
            space_w = CalcSpaceW(justify_w, font_w, text - 1);
        } else if (code >= MES_CODE_SPACE_W && code < MES_CODE_MOVE_X) {
            space_w = code - MES_CODE_SPACE_W;
        } else if (code >= MES_CODE_MOVE_X && code < 0xFA00) {
            x += code - MES_CODE_MOVE_X;
        } else if (code >= 0xFAFA && code < 0xFB00) {
            registered_name = SetAndGetNameRegistTbl(code - 0xFAFA);
            if (registered_name != NULL) {
                name_code = *registered_name;
                while (name_code != MES_CODE_NEWLINE && name_code != MES_CODE_END) {
                    SetMesWinTbl(name_code, x, y);
                    if (CheckKanjiFont(name_code) != 0) {
                        x += font_w;
                    } else if (CheckKanjiFont(registered_name[1]) != 0) {
                        x += font_w;
                    } else {
                        x += font_w;
                    }
                    registered_name++;
                    name_code = *registered_name;
                }
            }
        } else if (code >= 0xFAEA && code <= 0xFAF9) {
            MakeMesWinTbl_str(0xFAF9 - code, &x, &y);
        } else if (code == 0xFBFF) {
            MakeMesWinTbl_value(&x, &y);
        } else {
            value_code = code - 0xFB00;
            if (value_code >= 0xF3 && value_code < 0xFB) {
                MakeMesWinTbl_value(0xFA - value_code, &x, &y);
            } else if (value_code >= 0xDF && value_code < 0xE7) {
                MakeMesWinTbl_value(0xEE - value_code, &x, &y);
            } else if (MakeMesWinTbl_item(code, &x, &y) == 0) {
                SetMesWinTbl(code, x, y);
                if (CheckHalfFont(code) != 0) {
                    if (code == GetHalfFontNo__Fc(' ')) {
                        x += font_w / 2;
                    } else {
                        x += (int)(font_w * half_font_w_percent);
                    }
                } else if (CheckKanjiFont(code) != 0) {
                    x += font_w;
                } else if (CheckKanjiFont(*text) != 0) {
                    x += font_w;
                } else {
                    x += font_w;
                }
            }
        }
    }
    SetMesWinTbl(MES_CODE_END, x, y);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", MakeMesWinTbl__6ClsMesFi);
#endif
int ClsMes::MakeMesWinTbl(char *text) {
    if (text == NULL) {
        return 0;
    }
    InitMesWinTbl();
    draw_speed = GetDrawSpeedDef();
    int cursor_x = 0;
    int cursor_y = 0;
    MakeMesWinTbl_str(text, &cursor_x, &cursor_y);
    SetMesWinTbl(mes_end, (short)cursor_x, (short)cursor_y);
    return 1;
}
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
#ifdef NONMATCHING
void ClsMes::NeedMesWinWH(int mes_no) {
    char            number[128];
    unsigned short *text;
    unsigned short  code;
    int             y;
    int             line;
    int             page_index;
    int             value_no;
    int             number_value;
    int             width;
    int             item_no;
    int             message;
    int             i;

    if (buff == NULL) {
        return;
    }
    text = (unsigned short *)GetTextLineDataTop(mes_no);
    if (text == NULL) {
        return;
    }
    text_h = 0;
    y = 0;
    line = 0;
    page_index = 0;
    while (1) {
        code = *text++;
        if (code == MES_CODE_NEWLINE || code == MES_CODE_PAGE || code == MES_CODE_END) {
            space_w = -1;
            justify_w = -1;
        }
        if (code == MES_CODE_PAGE) {
            AddPage(line, page_index);
            line++;
            SetYokoHaba(line, 0);
            y = 0;
            page_index++;
        } else if (code == MES_CODE_NEWLINE) {
            line++;
            SetYokoHaba(line, 0);
            y += font_h;
            if (text_h < y) {
                text_h = y;
            }
        } else if (code == MES_CODE_SPACE) {
            if (justify_w >= 0 || space_w >= 0) {
                AddYokoHaba(line, space_w);
            } else {
                AddYokoHaba(line, font_w / 2);
            }
        } else if (code == MES_CODE_END) {
            break;
        } else if ((code < MES_CODE_WAIT || code >= MES_CODE_NEWLINE) &&
                   (code < MES_CODE_COLOR_DEFAULT || code >= MES_CODE_GAIJI) &&
                   (code < MES_CODE_COLOR_A || code >= MES_CODE_JUSTIFY) &&
                   code != MES_CODE_VOICE_1 && code != MES_CODE_VOICE_0 && code != MES_CODE_VOICE_2) {
            if (code >= MES_CODE_JUSTIFY && code < MES_CODE_SPACE_W) {
                justify_w = (code - MES_CODE_JUSTIFY) * 4;
                space_w = CalcSpaceW(justify_w, font_w, text - 1);
            } else if (code >= MES_CODE_SPACE_W && code < MES_CODE_MOVE_X) {
                space_w = code - MES_CODE_SPACE_W;
            } else if (code >= MES_CODE_MOVE_X && code < 0xFA00) {
                AddYokoHaba(line, code - MES_CODE_MOVE_X);
            } else if (code == 0xFBFF || (code >= 0xFBF3 && code < 0xFBFB) ||
                       (code >= 0xFBDF && code < MES_CODE_ITEM_LAST)) {
                if (code == 0xFBFF) {
                    number_value = value;
                } else {
                    if (code >= 0xFBF3 && code < 0xFBFB) {
                        value_no = 0xFBFA - code;
                    } else {
                        value_no = 0xFBEE - code;
                    }
                    number_value = values[value_no];
                }
                if (value_zero != 0 || number_value != 0) {
                    if (value_sign != 0 && number_value > 0) {
                        sprintf(number, "+%d\n", number_value);
                    } else {
                        sprintf(number, "%d\n", number_value);
                    }
                    width = (strlen(number) - 1) * font_w;
                    if (value_half != 0) {
                        width /= 2;
                    }
                    AddYokoHaba(line, width);
                }
            } else if (code == MES_CODE_ITEM_FIRST || code == 0xFBFD || code == 0xFBFC ||
                       code == 0xFBFB || code == 0xFBF2 || code == 0xFBF1 ||
                       code == 0xFBF0 || code == 0xFBEF || code == 0xFBEE ||
                       code == 0xFBED || code == 0xFBEC || code == 0xFBEB ||
                       code == 0xFBEA || code == 0xFBE9 || code == 0xFBE8 ||
                       code == MES_CODE_ITEM_LAST) {
                item_no = GetItemNoFromFontNo(code);
                message = -1;
                if (item_no > 0 && item_no < 17) {
                    message = item_mes[item_no - 1];
                }
                width = GetMesWidth_system(message);
                if (width != -1) {
                    AddYokoHaba(line, width);
                }
            } else if (code >= 0xFAEA && code <= 0xFAF9) {
                width = GetStrWidth(0xFAF9 - code);
                if (width != -1) {
                    AddYokoHaba(line, width);
                }
            } else if (code >= 0xFFA0) {
                AddYokoHaba(line, (int)(font_w * half_font_w_percent));
            } else if (code >= 0xFDE0 && code < 0xFDF8) {
                if (code == 0xFDF3) {
                    AddYokoHaba(line, (int)(2.0f * (font_w * half_font_w_percent)));
                } else if (GetFontGaijiHankaku(code) != 0) {
                    AddYokoHaba(line, (int)(font_w * half_font_w_percent));
                } else {
                    AddYokoHaba(line, (int)(2.0f * (font_w * half_font_w_percent)));
                }
            } else if (code >= MES_CODE_GAIJI && code < 0xFD32) {
                AddYokoHaba(line, GetGaijiW(code));
            } else if (CheckHalfFont(code) != 0) {
                if (code == GetHalfFontNo__Fc(' ')) {
                    AddYokoHaba(line, font_w / 2);
                } else {
                    AddYokoHaba(line, (int)(font_w * half_font_w_percent));
                }
            } else if (CheckKanjiFont(code) != 0) {
                AddYokoHaba(line, font_w);
            } else if (CheckKanjiFont(*text) != 0) {
                AddYokoHaba(line, font_w);
            } else {
                AddYokoHaba(line, font_w);
            }
        }
    }
    AddPage(line, page_index);
    text_h += font_h;
    text_w = 0;
    for (i = 0; i < MES_LINE_MAX; i++) {
        if (line_w[i] >= 0 && text_w < line_w[i]) {
            text_w = line_w[i];
        }
    }
    for (i = 0; i < MES_LINE_MAX; i++) {
        line_indent[i] = (text_w - line_w[i]) / 2;
    }
    page_num = page_index + 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", NeedMesWinWH__6ClsMesFi);
#endif
void ClsMes::NeedMesWinWH(char *text) {
    char message[mes_buffer_size];
    char value_text[0x80];
    char number_text[0x80];
    int length;
    int height;
    int line;
    int page;
    int position;
    int width_index;
    int indent_index;
    int index;
    int code;
    int width;
    int item;
    int message_id;
    int half_font;
    int font_number;
    u16 gaiji_number;
    int digits;
    char *cursor;
    char *tag_text;
    strcpy(message, text);
    text_h = 0;
    height = 0;
    line = 0;
    page = 0;
    length = strlen(message);
    position = 0;
    if (0 < length) {
        do {
            cursor = message + position;
            if (strncmp(cursor, at_2366, 2) == 0) {
                position += 2;
                while (1) {
                    if ((s8)message[position] == '\n') {
                        position++;
                        break;
                    }
                    position++;
                }
                continue;
            }
            if (strncmp(message + position, at_2367, 5) == 0) {
                position += 5;
                tag_text = message + position;
                index = -1;
                if (strncmp(tag_text, at_2368, 3) == 0) {
                    position += 3;
                    index = 0;
                } else if (strncmp(tag_text, at_2369, 3) == 0) {
                    position += 3;
                    index = 1;
                } else if (strncmp(tag_text, at_2370, 3) == 0) {
                    position += 3;
                    index = 2;
                } else if (strncmp(tag_text, at_2371, 3) == 0) {
                    position += 3;
                    index = 3;
                } else if (strncmp(tag_text, at_2372, 3) == 0) {
                    position += 3;
                    index = 4;
                } else if (strncmp(tag_text, at_2373, 3) == 0) {
                    position += 3;
                    index = 5;
                } else if (strncmp(tag_text, at_2374, 3) == 0) {
                    position += 3;
                    index = 6;
                } else if (strncmp(tag_text, at_2375, 3) == 0) {
                    position += 3;
                    index = 7;
                } else if (strncmp(tag_text, at_2376, 3) == 0) {
                    position += 3;
                    index = 8;
                } else if (strncmp(tag_text, at_2377, 5) == 0) {
                    position += 5;
                    index = 9;
                }
                if (index != -1) {
                    if (value_zero != 0 || values[index] != 0) {
                        if (value_sign != 0 && values[index] > 0) {
                            sprintf(value_text, at_2109, values[index]);
                        } else {
                            sprintf(value_text, at_2110, values[index]);
                        }
                        digits = strlen(value_text) - 1;
                        if (value_half != 0) {
                            AddYokoHaba(line, digits * font_w / 2);
                        } else {
                            AddYokoHaba(line, digits * font_w);
                        }
                    }
                    continue;
                }
            }
            if (strncmp(message + position, at_2378, 7) == 0) {
                position += 7;
                int value_index = -1;
                char *number_tag = message + position;
                if (strncmp(number_tag, at_2379, 2) == 0) {
                    position += 2;
                    value_index = 0;
                } else if (strncmp(number_tag, at_2380, 2) == 0) {
                    position += 2;
                    value_index = 1;
                } else if (strncmp(number_tag, at_2381, 2) == 0) {
                    position += 2;
                    value_index = 2;
                } else if (strncmp(number_tag, at_2382, 2) == 0) {
                    position += 2;
                    value_index = 3;
                } else if (strncmp(number_tag, at_2383, 2) == 0) {
                    position += 2;
                    value_index = 4;
                } else if (strncmp(number_tag, at_2384, 2) == 0) {
                    position += 2;
                    value_index = 5;
                } else if (strncmp(number_tag, at_2385, 2) == 0) {
                    position += 2;
                    value_index = 6;
                } else if (strncmp(number_tag, at_2386, 2) == 0) {
                    position += 2;
                    value_index = 7;
                } else if (strncmp(number_tag, at_2387, 2) == 0) {
                    position += 2;
                    value_index = 8;
                } else if (strncmp(number_tag, at_2388, 3) == 0) {
                    position += 3;
                    value_index = 9;
                }
                if (value_index != -1) {
                    if (value_zero != 0 || values[value_index] != 0) {
                        if (value_sign != 0 && values[value_index] > 0) {
                            sprintf(number_text, at_2109, values[value_index]);
                        } else {
                            sprintf(number_text, at_2110, values[value_index]);
                        }
                        digits = strlen(number_text) - 1;
                        if (value_half != 0) {
                            AddYokoHaba(line, digits * font_w / 2);
                        } else {
                            AddYokoHaba(line, digits * font_w);
                        }
                    }
                    continue;
                }
            }
            if (strncmp(message + position, at_2389, 9) == 0) {
                position += 9;
                tag_text = message + position;
                code = -1;
                if (strncmp(tag_text, at_2368, 3) == 0) {
                    position += 3;
                    code = 0xfbfe;
                } else if (strncmp(tag_text, at_2369, 3) == 0) {
                    position += 3;
                    code = 0xfbfd;
                } else if (strncmp(tag_text, at_2370, 3) == 0) {
                    position += 3;
                    code = 0xfbfc;
                } else if (strncmp(tag_text, at_2371, 3) == 0) {
                    position += 3;
                    code = 0xfbfb;
                } else if (strncmp(tag_text, at_2372, 3) == 0) {
                    position += 3;
                    code = 0xfbf2;
                } else if (strncmp(tag_text, at_2373, 3) == 0) {
                    position += 3;
                    code = 0xfbf1;
                } else if (strncmp(tag_text, at_2374, 3) == 0) {
                    position += 3;
                    code = 0xfbf0;
                } else if (strncmp(tag_text, at_2375, 3) == 0) {
                    position += 3;
                    code = 0xfbef;
                } else if (strncmp(tag_text, at_2376, 3) == 0) {
                    position += 3;
                    code = 0xfbee;
                } else if (strncmp(tag_text, at_2377, 5) == 0) {
                    position += 5;
                    code = 0xfbed;
                } else if (strncmp(tag_text, at_2390, 5) == 0) {
                    position += 5;
                    code = 0xfbec;
                } else if (strncmp(tag_text, at_2391, 5) == 0) {
                    position += 5;
                    code = 0xfbeb;
                } else if (strncmp(tag_text, at_2392, 5) == 0) {
                    position += 5;
                    code = 0xfbea;
                } else if (strncmp(tag_text, at_2393, 5) == 0) {
                    position += 5;
                    code = 0xfbe9;
                } else if (strncmp(tag_text, at_2394, 5) == 0) {
                    position += 5;
                    code = 0xfbe8;
                } else if (strncmp(tag_text, at_2395, 5) == 0) {
                    position += 5;
                    code = 0xfbe7;
                }
                if (code != -1) {
                    item = GetItemNoFromFontNo(code);
                    if (item <= 0) {
                        message_id = -1;
                    } else if (item > 0x10) {
                        message_id = -1;
                    } else {
                        message_id = item_mes[item - 1];
                    }
                    width = GetMesWidth_system(message_id);
                    if (width != -1) {
                        AddYokoHaba(line, width);
                    }
                    continue;
                }
            }
            if (strncmp(message + position, at_2396, 7) == 0) {
                position += 7;
                index = 0;
                if (strncmp(message + position, at_2368, 3) == 0) {
                    index = 1;
                    position += 3;
                }
                if (strncmp(message + position, at_2369, 3) == 0) {
                    index = 2;
                    position += 3;
                }
                if (strncmp(message + position, at_2370, 3) == 0) {
                    index = 3;
                    position += 3;
                }
                if (strncmp(message + position, at_2371, 3) == 0) {
                    index = 4;
                    position += 3;
                }
                if (strncmp(message + position, at_2372, 3) == 0) {
                    index = 5;
                    position += 3;
                }
                if (strncmp(message + position, at_2373, 3) == 0) {
                    index = 6;
                    position += 3;
                }
                if (strncmp(message + position, at_2374, 3) == 0) {
                    index = 7;
                    position += 3;
                }
                if (strncmp(message + position, at_2375, 3) == 0) {
                    index = 8;
                    position += 3;
                }
                if (strncmp(message + position, at_2376, 3) == 0) {
                    index = 9;
                    position += 3;
                }
                if (strncmp(message + position, at_2377, 5) == 0) {
                    index = 10;
                    position += 5;
                }
                if (strncmp(message + position, at_2390, 5) == 0) {
                    index = 11;
                    position += 5;
                }
                if (strncmp(message + position, at_2391, 5) == 0) {
                    index = 12;
                    position += 5;
                }
                if (strncmp(message + position, at_2392, 5) == 0) {
                    index = 13;
                    position += 5;
                }
                if (strncmp(message + position, at_2393, 5) == 0) {
                    index = 14;
                    position += 5;
                }
                if (strncmp(message + position, at_2394, 5) == 0) {
                    index = 15;
                    position += 5;
                }
                if (strncmp(message + position, at_2395, 5) == 0) {
                    index = 16;
                    position += 5;
                }
                if (index != 0) {
                    AddYokoHaba(line, GetStrWidth(name[index - 1]));
                    continue;
                }
            }
            cursor = message + position;
            if (0 < (u16)GetAlphabeticalFontNo_cp(cursor)) {
                AddYokoHaba(line, fptosi((float)font_w * half_font_w_percent));
                position += 9;
            } else {
                if ((GetFontGaijiFontNo(cursor) & 0xFFFF) != 0) {
                    AddYokoHaba(line, font_w);
                    position += 2;
                    continue;
                }
                gaiji_number = GetGaijiFontNo(cursor);
                if (0 < gaiji_number) {
                    AddYokoHaba(line, GetGaijiW(gaiji_number));
                    position += GetGaijiLen(gaiji_number);
                } else if ((s8)*cursor == '\n') {
                    line++;
                    SetYokoHaba(line, 0);
                    height += font_h;
                    if (text_h < height) {
                        text_h = height;
                    }
                    position++;
                } else if (strncmp(cursor, at_2397, 6) == 0) {
                    AddPage(line, page);
                    line++;
                    SetYokoHaba(line, 0);
                    height = 0;
                    position += 6;
                    page++;
                } else {
                    half_font = GetHalfFontNo__Fc((s8)*cursor);
                    if (CheckHalfFont(half_font) != 0) {
                        if (half_font == GetHalfFontNo__Fc(' ')) {
                            AddYokoHaba(line, font_w / 2);
                        } else {
                            AddYokoHaba(line, fptosi((float)font_w * half_font_w_percent));
                        }
                        position++;
                    } else {
                        font_number = GetFontNo(cursor);
                        if (0 <= font_number) {
                            if (CheckKanjiFont(font_number) != 0) {
                                AddYokoHaba(line, font_w);
                            } else if (CheckKanjiFont(GetFontNo(cursor + 2)) != 0) {
                                AddYokoHaba(line, font_w);
                            } else {
                                AddYokoHaba(line, font_w);
                            }
                            position += 2;
                        } else {
                            AddYokoHaba(line, font_w);
                            position += 2;
                        }
                    }
                }
            }
        } while (position < length);
    }
    AddPage(line, page);
    text_h += font_h;
    text_w = 0;
    for (width_index = 0; width_index < mes_line_count; width_index++) {
        if (line_w[width_index] >= 0 && text_w < line_w[width_index]) {
            text_w = line_w[width_index];
        }
    }
    for (indent_index = 0; indent_index < mes_line_count; indent_index++) {
        line_indent[indent_index] = (text_w - line_w[indent_index]) / 2;
    }
    page_num = page + 1;
}

void ClsMes::MakeMesWin_init(int reset_fade) {
    reveal_num = 0;
    page_top = 0;
    unk_1f4 = 0;
    scroll_wait = 0;
    reveal = 0.0f;
    voice_type = 0;
    voice_cnt = 0;
    close_time = 0;
    if (reset_fade != 0) {
        fade = 0.0f;
    }
    open = 1;
    page_wait = 0;
    page_time = 0;
    page = 0;
    page_num = 0;
    for (int index = 0; index < MES_PAGE_MAX; index++) {
        page_chars[index] = 0;
    }
    last_x = 0;
    last_y = 0;
    for (int index = 0; index < MES_LINE_MAX; index++) {
        line_w[index] = 0;
        line_alpha[index] = -1;
    }
}
#ifdef NONMATCHING
void ClsMes::MakeMesWin(int message) {
    int extra_width;
    int current_page;
    int character_count;
    int index;

    if (message < 0) {
        if (mes_no == -2) {
            open = 1;
        }
    } else if (mes_no == message) {
        if (GetPageAutoFlg() == 0) {
            open = 1;
            GoNextPage();
        }
    } else {
        mes_no = message;
        MakeMesWin_init(1);
        NeedMesWinWH(message);
        if (text_w < 45) {
            fukidashi_w = 105;
        } else {
            extra_width = 0;
            fukidashi_w = text_w + 60;
            for (current_page = 0; current_page < page_num; current_page++) {
                character_count = 0;
                for (index = 0; index < current_page + 1; index++) {
                    character_count += page_chars[index];
                }
                if (line_w[character_count - 1] >= text_w) {
                    extra_width = 1;
                }
            }
            if (extra_width != 0) {
                fukidashi_w += 20;
            }
        }
        fukidashi_h = text_h + 48;
        if (MakeMesWinTbl(message) != 0) {
            char_num = tbl_num;
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", MakeMesWin__6ClsMesFi);
#endif
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
#ifdef NONMATCHING
void ClsMes::MakeMesWin(char *str, int open, int reset_fade) {
    char text[512];
    int  extra_width;
    int  current_page;
    int  character_count;
    int  index;

    if (str != NULL) {
        PreMesMake(str, text);
        mes_no = -2;
        MakeMesWin_init(reset_fade);
        this->open = open;
        NeedMesWinWH(text);
        if (text_w < 45) {
            fukidashi_w = 105;
        } else {
            extra_width = 0;
            fukidashi_w = text_w + 60;
            for (current_page = 0; current_page < page_num; current_page++) {
                character_count = 0;
                for (index = 0; index < current_page + 1; index++) {
                    character_count += page_chars[index];
                }
                if (line_w[character_count - 1] >= text_w) {
                    extra_width = 1;
                }
            }
            if (extra_width != 0) {
                fukidashi_w += 20;
            }
        }
        fukidashi_h = text_h + 48;
        if (MakeMesWinTbl(text) != 0) {
            char_num = tbl_num;
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", MakeMesWin__6ClsMesFPcii);
#endif
int ClsMes::MakeAnd3DPosSet(char *text, float *world_position, int offset_x, int offset_y) {
    int screen_position[4];
    if (text == NULL) {
        return 0;
    }
    if (mgTransWorldScreen(screen_position, world_position) == 0) {
        return 0;
    }
    MakeMesWin(text, 1, 0);
    int centre_x = screen_position[0] >> 4;
    int centre_y = screen_position[1] >> 4;
    int width = text_w;
    int height = text_h;
    centre_x += offset_x;
    centre_y += offset_y;
    int left = centre_x - width / 2;
    if (left < 0) {
        return 0;
    }
    if (mgScreenWidth < centre_x + width / 2) {
        return 0;
    }
    int top = centre_y - height / 2;
    if (top < 0) {
        return 0;
    }
    if (mgScreenHeight < centre_y + height / 2) {
        return 0;
    }
    abs_win.x = left;
    abs_win.y = top;
    return 1;
}
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
#ifdef NONMATCHING
RGBAQ_TYPE ClsMes::GetFontColor(int index, int *outline) {
    RGBAQ_TYPE result;
    int        line;

    line = tbl[index].y / font_h;
    if (line_color[line] != 0) {
        result = RgbqToUint(line_color[line]);
        result.a = alpha * result.a / 128;
        return result;
    }
    result = RgbqToUint(tbl[index].color);
    if (line_alpha[line] >= 0) {
        result.a = line_alpha[line] * result.a / 128;
    } else {
        result.a = alpha * result.a / 128;
    }
    *outline = 1;
    switch (GetGyouAlpha(line)) {
        case MES_SHADE_DARK:
            result.r /= 2;
            result.g /= 2;
            result.b /= 2;
            break;
        case MES_SHADE_BRIGHT:
            result.a = alpha * 0xFF / 128;
            break;
        case MES_SHADE_FAINT:
            result.r = 0;
            result.g = 0;
            result.b = 0;
            result.a = alpha * 0x40 / 128;
            *outline = 0;
            break;
        case MES_SHADE_HIDDEN:
            result.a = 0;
            break;
    }
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", GetFontColor__6ClsMesFiPi);
#endif
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
#ifdef NONMATCHING
void ClsMes::DrawFont() {
    int        index;
    int        line;
    int        x;
    int        y;
    int        dx;
    int        dy;
    int        left;
    int        right;
    int        top;
    int        bottom;
    int        outline;
    int        digit;
    RGBAQ_TYPE glyph_color;

    if (MesAbsDrawOff != 0) {
        return;
    }
    mgRect<int> rect(0, 0, 0, 0);
    mgCDrawPrim prim;
    MySetPrim(&prim, MES_PRIM_SPRITE, 0);
    prim.offset_x = (int)draw_off_x * 16;
    prim.offset_y = (int)draw_off_y * 16;
    prim.Begin(MG_PRIM_SPRITE);
    for (index = page_top; index < reveal_num; index++) {
        line = tbl[index].y / font_h;
        if (line_shade[line] == MES_SHADE_HIDDEN) {
            continue;
        }
        x = tbl[index].x;
        y = tbl[index].y;
        if (line_pos_on[line] != 0) {
            x += line_pos[line][0];
            y = line_pos[line][1];
        } else {
            if (scissor_on != 0) {
                left = scissor.x;
                right = left + scissor.width;
                top = scissor.y;
                bottom = top + scissor.height;
                if (left < 0) {
                    left = 0;
                }
                if (right < 0) {
                    right = 0;
                }
                if (left > mgScreenWidth - 1) {
                    left = mgScreenWidth - 1;
                }
                if (right > mgScreenWidth - 1) {
                    right = mgScreenWidth - 1;
                }
                if (top < 0) {
                    top = 0;
                }
                if (bottom < 0) {
                    bottom = 0;
                }
                if (top > mgScreenHeight - 1) {
                    top = mgScreenHeight - 1;
                }
                if (bottom > mgScreenHeight - 1) {
                    bottom = mgScreenHeight - 1;
                }
                prim.Direct(0x40, (unsigned long)left | ((unsigned long)right << 16) |
                            ((unsigned long)top << 32) | ((unsigned long)bottom << 48));
            }
            x += text_x;
            y += text_y;
            CalcCenteringXY(&dx, &dy);
            x += dx;
            y += dy;
            if (line_indent_on != 0) {
                x += line_indent[line];
            }
        }
        if (tbl[index].code >= MES_CODE_GAIJI && tbl[index].code < 0xFD32) {
            if (tbl[index].code == 0xFD26 || tbl[index].code == 0xFD27 || tbl[index].code == 0xFD28) {
                glyph_color = GetFontColor(index, &outline);
            } else {
                glyph_color.r = 0x80;
                glyph_color.g = 0x80;
                glyph_color.b = 0x80;
                glyph_color.a = alpha;
            }
            MySetTex("gaiji", &prim);
            DrawGaiji_sub(&prim, tbl[index].code, x, y, glyph_color, font_h);
        } else {
            outline = 1;
            glyph_color = GetFontColor(index, &outline);
            digit = GetDigitNo(tbl[index].code);
            if (digit_font == 1 && digit != -1) {
                MySetTex("gaiji", &prim);
                DrawDigit(&prim, digit, x, y, alpha, &glyph_color);
            } else {
                CFont::alpha = alpha;
                if (line_alpha[line] >= 0) {
                    DrawChar(&prim, tbl[index].code, x, y, outline, glyph_color, line_alpha[line]);
                } else {
                    DrawChar(&prim, tbl[index].code, x, y, outline, glyph_color, alpha);
                }
            }
        }
        last_x = x;
        last_y = y;
        if (scissor_on != 0 && line_pos_on[line] == 0) {
            prim.Direct(0x40, ((unsigned long)(mgScreenWidth - 1) << 16) |
                        ((unsigned long)(mgScreenHeight - 1) << 48));
        }
    }
    prim.End();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawFont__6ClsMesFv);
#endif
#ifdef NONMATCHING
void ClsMes::SetGoalCursorXY() {
    int dx;
    int dy;
    int line;
    int count;
    int width;

    if (select < 0) {
        return;
    }
    if (window_mode == MES_WIN_YESNO) {
        if (choice_pos[select][0] < 0 || choice_pos[select][1] < 0) {
            return;
        }
        goal_cursor_x = (int)((choice_pos[select][0] - 20) - draw_off_x);
        goal_cursor_y = (int)(choice_pos[select][1] - draw_off_y);
    } else {
        goal_cursor_x = text_x - 40 - font_w / 2;
        goal_cursor_y = text_y + font_h * select + cursor_off_y + draw_h / 2 - 12;
        CalcCenteringXY(&dx, &dy);
        goal_cursor_x += dx;
        goal_cursor_y += dy;
        if (line_indent_on != 0 && cursor_centering != 0) {
            count = 0;
            for (line = 0; line < MES_LINE_MAX; line++) {
                if (line_w[line] < 0) {
                    break;
                }
                count++;
            }
            width = 0;
            for (line = select_top; line < count; line++) {
                if (width < line_w[line]) {
                    width = line_w[line];
                }
            }
            goal_cursor_x += (text_w - width) / 2;
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", SetGoalCursorXY__6ClsMesFv);
#endif
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
#ifdef NONMATCHING
void ClsMes::DrawEquipment(mgCDrawPrim *prim) {
    RECT       at = {191, 82, 9, 16};
    RGBAQ_TYPE color;
    int        line;

    for (line = 0; line < MES_LINE_MAX; line++) {
        if (equip_on[line] != 0) {
            if (line_color[line] != 0) {
                color = RgbqToUint(line_color[line]);
                color.a = alpha * color.a / 128;
            } else {
                color.r = 0x80;
                color.g = 0x80;
                color.b = 0x80;
                color.a = alpha;
            }
            mgRect<int> uv(at.x, at.y, at.width, at.height);
            mgRect<int> xy((int)(draw_off_x + (line_pos[line][0] + equip_x[line])),
                           (int)(draw_off_y + (line_pos[line][1] + equip_y[line])), at.width, at.height);
            set2DSprite(prim, xy, uv, &color);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawEquipment__6ClsMesFP11mgCDrawPrim);
#endif
#ifdef NONMATCHING
void ClsMes::DrawCross(mgCDrawPrim *prim) {
    RECT       at = {132, 104, 10, 16};
    RGBAQ_TYPE color;
    int        line;

    for (line = 0; line < MES_LINE_MAX; line++) {
        if (cross_on[line] != 0) {
            if (line_color[line] != 0) {
                color = RgbqToUint(line_color[line]);
                color.a = alpha * color.a / 128;
            } else {
                color.r = 0x80;
                color.g = 0x80;
                color.b = 0x80;
                color.a = alpha;
            }
            mgRect<int> uv(at.x, at.y, at.width, at.height);
            mgRect<int> xy((int)(draw_off_x + (line_pos[line][0] + cross_x[line])),
                           (int)(draw_off_y + (line_pos[line][1] + cross_y[line])), at.width, at.height);
            set2DSprite(prim, xy, uv, &color);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawCross__6ClsMesFP11mgCDrawPrim);
#endif
#ifdef NONMATCHING
void ClsMes::DrawRightDelta(mgCDrawPrim *prim) {
    RECT       at = {158, 240, 10, 16};
    RGBAQ_TYPE color;
    int        line;

    for (line = 0; line < MES_LINE_MAX; line++) {
        if (delta_on[line] != 0) {
            if (line_color[line] != 0) {
                color = RgbqToUint(line_color[line]);
                color.a = alpha * color.a / 128;
            } else {
                color.r = 0x80;
                color.g = 0x80;
                color.b = 0x80;
                color.a = alpha;
            }
            mgRect<int> uv(at.x, at.y, at.width, at.height);
            mgRect<int> xy((int)(draw_off_x + (line_pos[line][0] + delta_x[line])),
                           (int)(draw_off_y + (line_pos[line][1] + delta_y[line])), at.width, font_h - 2);
            set2DSprite(prim, xy, uv, &color);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawRightDelta__6ClsMesFP11mgCDrawPrim);
#endif
#ifdef NONMATCHING
void ClsMes::DrawDigit(mgCDrawPrim *prim, int digit, int x, int y, int alpha, RGBAQ_TYPE *color) {
    RECT at = {176, 140, 16, 20};

    at.x += digit % 5 * at.width;
    at.y += digit / 5 * at.height;
    color->a = alpha * 128 / 128;
    mgRect<int> uv(at.x, at.y, at.width, at.height);
    mgRect<int> xy(x, (int)(y + 2.0), at.width, at.height);
    set2DSpriteEasy(prim, xy, uv, color);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawDigit__6ClsMesFP11mgCDrawPrimiiiiP10RGBAQ_TYPE);
#endif
extern RECT data_4206[];
void ClsMes::DrawPushButton(mgCDrawPrim *prim, int right, int bottom) {
    mgRect<int> destination;
    mgRect<int> texture;
    RGBAQ_TYPE color;
    int x;
    int y;
    int frame;
    if (push_button == 0) {
        return;
    }
    if (fade < 1.0) {
        return;
    }
    if (window_mode == MES_WIN_DQ_FUKIDASHI || window_mode == MES_WIN_DQ_FUKIDASHI_2) {
        if (page + 1 >= page_num) {
            return;
        }
    }
    if (window_mode == MES_WIN_BOTTOM || window_mode == MES_WIN_CENTRE) {
        if (CSnd.StreamGetState(1) != 0) {
            return;
        }
    }
    if (reveal_num < char_num || select >= 0) {
        if (page_wait == 0) {
            return;
        }
    }
    frame = (page_time / 8) % 4;
    x = last_x;
    y = last_y;
    switch (window_mode) {
        case MES_WIN_FUKIDASHI:
            frame += 4;
            break;
        case MES_WIN_NONE:
        case MES_WIN_BOTTOM:
        case MES_WIN_DQ_FUKIDASHI:
        case MES_WIN_DQ_FUKIDASHI_2:
        case MES_WIN_CENTRE:
            if ((page_time / 16) % 2 != 0) {
                return;
            }
            y += font_h / 2 - 4;
            if (fuchi == 3 || fuchi == 6 || fuchi == 8) {
                frame = 8;
            } else {
                frame = 9;
            }
            break;
        case MES_WIN_HELP:
            y += font_h;
            break;
        case MES_WIN_VERSATILE_1:
        case MES_WIN_VERSATILE_4:
            x = right - data_4206[frame].width - 16;
            y = bottom - data_4206[frame].height - 12;
            break;
        default:
            return;
    }
    color.r = color.g = color.b = 128;
    color.a = (alpha * 128) / 128;
    texture.Set(data_4206[frame].x, data_4206[frame].y, data_4206[frame].width, data_4206[frame].height);
    x = fptosi((float)x + draw_off_x);
    y = fptosi((float)y + draw_off_y);
    destination.Set(x, y, data_4206[frame].width, data_4206[frame].height);
    set2DSprite(prim, destination, texture, &color);
}
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
#ifdef NONMATCHING
void ClsMes::DrawMesWin() {
    RGBAQ_TYPE color;
    RGBAQ_TYPE shadow_color;
    RECT       inner;
    RECT       outer;
    RECT       shadow;
    RECT       scaled;
    int        dx;
    int        dy;
    int        select_y;

    SetFuchi(fuchi);
    text_x = 0;
    text_y = 0;
    color.r = 0x80;
    color.g = 0x80;
    color.b = 0x80;
    color.a = alpha;
    shadow_color.r = 0;
    shadow_color.g = 0;
    shadow_color.b = 0;
    shadow_color.a = alpha * 0x40 / 128;
    mgCDrawPrim frame_prim;
    mgCDrawPrim sprite_prim;
    MySetPrim(&sprite_prim, MES_PRIM_SPRITE, 0);
    if (mes_no == -1) {
        return;
    }
    CalcCenteringXY(&dx, &dy);
    inner.x = text_x + dx;
    inner.y = text_y + dy;
    inner.width = text_w;
    inner.height = text_h;
    CalcWindowOutRectFromInRect(window_mode, inner, &outer);
    SetOuterRectXYFromFukidashiPos(&outer);
    SetAbsWinData(&outer);
    CalcWindowInRectFromOutRect(window_mode, outer, &inner);
    shadow.x = outer.x + 5;
    shadow.y = outer.y + 5;
    shadow.width = outer.width;
    shadow.height = outer.height;
    switch (window_mode) {
        case MES_WIN_FUKIDASHI:
            outer.x = fukidashi_x;
            outer.y = fukidashi_y;
            DrawFukidashi(-1, -1, MES_FUKIDASHI_OUTLINE);
            DrawFukidashi(1, -1, MES_FUKIDASHI_OUTLINE);
            DrawFukidashi(-1, 1, MES_FUKIDASHI_OUTLINE);
            DrawFukidashi(1, 1, MES_FUKIDASHI_OUTLINE);
            DrawFukidashiShadow();
            DrawFukidashi(0, 0, MES_FUKIDASHI_BODY);
            CalcMesWinXYFromFukidashiXY();
            inner.x = text_x + dx;
            inner.y = text_y + dy;
            inner.width = text_w;
            inner.height = text_h;
            break;
        case MES_WIN_HELP:
            CalcRectScale(outer, fade, &scaled);
            scaled.x = (int)(scaled.x + draw_off_x);
            scaled.y = (int)(scaled.y + draw_off_y);
            MyMenuHelpWinDraw(&sprite_prim, scaled, alpha);
            break;
        case MES_WIN_FLOATING:
            shadow.x = (int)(shadow.x + draw_off_x);
            shadow.y = (int)(shadow.y + draw_off_y);
            MyMenuFloatingWinDraw(&frame_prim, shadow, shadow.x + point_x, shadow.y + point_y,
                                  &shadow_color, &shadow_color);
            outer.x = (int)(outer.x + draw_off_x);
            outer.y = (int)(outer.y + draw_off_y);
            MyMenuFloatingWinDraw(&frame_prim, outer, outer.x + point_x, outer.y + point_y,
                                  &color, &win_color);
            break;
        case MES_WIN_VERSATILE_1:
            CalcRectScale(shadow, fade, &scaled);
            scaled.x = (int)(scaled.x + draw_off_x);
            scaled.y = (int)(scaled.y + draw_off_y);
            DrawVersatileWin_1(&frame_prim, scaled, &shadow_color, alpha, bg_opaque);
            CalcRectScale(outer, fade, &scaled);
            scaled.x = (int)(scaled.x + draw_off_x);
            scaled.y = (int)(scaled.y + draw_off_y);
            DrawVersatileWin_1(&frame_prim, scaled, &color, alpha, bg_opaque);
            break;
        case MES_WIN_YESNO:
            OffsetYesNoWin(&outer, &shadow);
            CalcRectScale(shadow, fade, &scaled);
            scaled.x = (int)(scaled.x + draw_off_x);
            scaled.y = (int)(scaled.y + draw_off_y);
            DrawVersatileWin_yesno(&frame_prim, scaled, &shadow_color, alpha, bg_opaque);
            CalcRectScale(outer, fade, &scaled);
            scaled.x = (int)(scaled.x + draw_off_x);
            scaled.y = (int)(scaled.y + draw_off_y);
            DrawVersatileWin_yesno(&frame_prim, scaled, &color, alpha, bg_opaque);
            SetSelectCursorPos(scaled);
            DrawYesNo(&frame_prim, choice_pos[0][0], choice_pos[0][1], choice_pos[1][0], choice_pos[1][1], &color);
            break;
        case MES_WIN_VERSATILE_3:
            CalcRectScale(shadow, fade, &scaled);
            select_y = scaled.y + scaled.height / 2;
            select_y += (int)((inner.y + font_h * select_top + 7 - select_y) * fade);
            scaled.x = (int)(scaled.x + draw_off_x);
            scaled.y = (int)(scaled.y + draw_off_y);
            DrawVersatileWin_3(&frame_prim, scaled, select_y, &shadow_color, alpha, bg_opaque);
            CalcRectScale(outer, fade, &scaled);
            scaled.x = (int)(scaled.x + draw_off_x);
            scaled.y = (int)(scaled.y + draw_off_y);
            DrawVersatileWin_3(&frame_prim, scaled, select_y, &color, alpha, bg_opaque);
            break;
        case MES_WIN_VERSATILE_4:
            CalcRectScale(shadow, fade, &scaled);
            scaled.x = (int)(scaled.x + draw_off_x);
            scaled.y = (int)(scaled.y + draw_off_y);
            DrawVersatileWin_4(&frame_prim, scaled, &shadow_color, alpha, bg_opaque);
            CalcRectScale(outer, fade, &scaled);
            scaled.x = (int)(scaled.x + draw_off_x);
            scaled.y = (int)(scaled.y + draw_off_y);
            DrawVersatileWin_4(&frame_prim, scaled, &color, alpha, bg_opaque);
            break;
        case MES_WIN_DQ_FUKIDASHI:
        case MES_WIN_DQ_FUKIDASHI_2:
            text_x = (int)CalcAutoPosSet(0.0f, 512.0f, text_w, 0.5f);
            text_y = (int)CalcAutoPosSet(0.0f, 480.0f, text_h, 0.95f);
            outer.x = text_x - (font_w + 8);
            outer.y = text_y - 13;
            outer.width = font_w + (font_w + 16 + text_w);
            outer.height = text_h + 26;
            point_x = tail_target_x - text_x;
            point_y = -10;
            outer.x = (int)(outer.x + draw_off_x);
            outer.y = (int)(outer.y + draw_off_y);
            DrawDQFukidashi(&frame_prim, outer, outer.x + point_x, outer.y + point_y, &color, tail_on, window_mode);
            break;
    }
    if (window_mode == MES_WIN_FUKIDASHI && open != 0 && fade < 1.0f) {
        return;
    }
    page_time++;
    if (abs_win.x >= 0) {
        if (abs_text_off_x >= 0) {
            text_x = abs_win.x + abs_text_off_x;
        } else {
            text_x = abs_win.x + waku_data[window_mode][0];
        }
    } else if (fukidashi_pos > 0) {
        text_x = outer.x + waku_data[window_mode][0];
    } else {
        text_x = inner.x;
    }
    if (abs_win.y >= 0) {
        if (abs_text_off_y >= 0) {
            text_y = abs_win.y + abs_text_off_y;
        } else {
            text_y = abs_win.y + waku_data[window_mode][1];
        }
    } else if (fukidashi_pos > 0) {
        text_y = outer.y + waku_data[window_mode][1];
    } else {
        text_y = inner.y;
    }
    if (window_mode == MES_WIN_BOTTOM || window_mode == MES_WIN_DQ_FUKIDASHI ||
        window_mode == MES_WIN_DQ_FUKIDASHI_2) {
        text_x = (int)CalcAutoPosSet(0.0f, 512.0f, text_w, 0.5f);
        text_y = (int)CalcAutoPosSet(0.0f, 480.0f, text_h, 0.95f);
    }
    if (window_mode == MES_WIN_CENTRE) {
        text_x = (int)CalcAutoPosSet(0.0f, 512.0f, text_w, 0.5f);
        text_y = (int)CalcAutoPosSet(0.0f, 480.0f, text_h, 0.5f);
    }
    if (scissor_on == 1) {
        scissor.x = text_x;
        scissor.y = text_y - 1;
        if (abs_win.width > 0) {
            scissor.width = abs_win.width;
        } else {
            scissor.width = text_w;
        }
        if (abs_win.height > 0) {
            scissor.height = abs_win.height;
        } else {
            scissor.height = text_h;
        }
    }
    if (GetCaptionOff() != 0 && window_mode == MES_WIN_BOTTOM && EdEventInfo.stream_playing != 0) {
        return;
    }
    DrawFont();
    StepSelectCursor(1);
    DrawSelectCursor(&sprite_prim);
    DrawPushButton(&sprite_prim, outer.x + outer.width, outer.y + outer.height);
    DrawEquipment(&sprite_prim);
    DrawCross(&sprite_prim);
    DrawRightDelta(&sprite_prim);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/nd_meswin", DrawMesWin__6ClsMesFv);
#endif
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

// Small uninitialised data (.sbss)
INCLUDE_BSS(MesAbsDrawOff, 0x4);
INCLUDE_BSS(MovieCCCnt, 0x4);
INCLUDE_BSS(MovieCCW, 0x4);
INCLUDE_BSS(MovieCCH, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(NameRegistTbl, 0xB0);
CFont MovieCCFont;
INCLUDE_BSS(MovieCCStart, 0x50);
INCLUDE_BSS(MovieCCClear, 0x50);
INCLUDE_BSS(MovieCCStr, 0x1B60);
