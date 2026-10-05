#include "sound.hpp"
#include "dataread.hpp"
#include "prespr.hpp"
#include "mg_drawprim.hpp"
#include <cstdio>
#include "savedatadungeon.hpp"
#include "map.hpp"
#include "dngfloor.hpp"
#include "font.hpp"
#include "sysmes.hpp"
#include "scenesnd.hpp"
#include "savedata.hpp"
#include "userdata.hpp"
#include "gamedata.hpp"
#include "scriptinterpreter.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mainloop.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "menumain.hpp"
#include "common.h"
#include "dngmenu.hpp"
#include <cstring>

enum { kGlidRoom = 1, kGlidEntrance = 2, kGlidCellWidth = 0x34, kGlidRowShear = -0x10, kGlidRowHeight = 0x14 };
enum { kGlidUp, kGlidDown, kGlidLeft, kGlidRight };
enum { kTreeMapFadeOutFrames = 0x28 };
const float kMapCentreX = 256.0f;
const float kMapCentreY = 208.0f;
const float kMapOffScreen = -100.0f;

extern "C" char at_2739[];
extern "C" char at_2740[];
extern "C" char at_2741[];
extern "C" char at_2742[];
extern "C" char *name_tbl_2728[7];
extern "C" int fptosi(float value);
extern int MenuDngDebugFlagSelect;
extern char at_2176[];
extern char at_2177[];
extern char at_2178[];
extern char at_2179[];
extern char at_2180[];
extern char at_2181[];
extern char at_2182[];
extern char at_2183__2[];
extern char at_2184[];
extern char at_2185[];
extern char at_2186[];
extern char at_2187[];
extern char at_2188[];
extern char at_2189[];
extern char *RootTable_2119[4];
extern char Table_2133[8][0x20];
extern int bittable_2134[8];
extern "C" float sinf(float);
extern mgRect<float> treemap_root_put;
extern float dng_player_pos[2];
extern int dng_player_blink_cnt;
extern char at_1018__5[];
extern char at_1019__4[];
extern char at_1020__3[];
extern char at_1021__3[];
extern CDC2Mes *MenuDCMsg[9];
int SearchMapNo(char *mapName);

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", Initialize__11CDngFreeMapFv);
void CDngFreeMap::InitTexture(void) {
    map_tex = NULL;
    last_tex = NULL;
    koma_tex = NULL;
    name_tex = NULL;
    tex_block = -1;
}
void CDngFreeMap::SetUserGlid(int room) {
    user_glid = NULL;
    if (0 <= room) {
        user_glid = GetRoomGlid(room);
    }
}
void CDngFreeMap::CalcGlidPutPos(GLID_INFO *glid, float &x, float &y, int ignore_scroll) {
    if (glid != NULL) {
        x = (float)((glid->x * kGlidCellWidth) + (glid->y * kGlidRowShear));
        y = (float)(glid->y * kGlidRowHeight);
        if (ignore_scroll == 0) {
            x += pos_x;
            y += pos_y;
        }
    }
}
void CDngFreeMap::CheckIsViewMove(int x, int y, float &moveX, float &moveY) {
    float left = *(volatile float *)&view_rect.left;
    int clampedX = x;
    int clampedY = y;

    if ((float)clampedX < left) {
        clampedX = (int)left;
    }
    if (-10.0f + view_rect.right < (float)clampedX) {
        clampedX = (int)(-10.0f + view_rect.right);
    }
    if ((float)clampedY < view_rect.top) {
        clampedY = (int)view_rect.top;
    }

    clampedY = view_rect.bottom < (float)(clampedY - 10) ? (int)(-10.0f + view_rect.bottom) : clampedY;
    moveX = (float)(clampedX - x);
    moveY = (float)(clampedY - y);
}
void CDngFreeMap::SetNextRoomPos(GLID_INFO *room) {
    float room_x;
    float room_y;
    float move_x;
    float move_y;
    if (room != NULL) {
        CalcGlidPutPos(room, room_x, room_y, 0);
        int x = (int)room_x;
        int y = (int)room_y;
        CheckIsViewMove(x, y, move_x, move_y);
        next_pos_x = pos_x + move_x;
        next_pos_y = pos_y + move_y;
    }
}
GLID_INFO *CDngFreeMap::GetNextGlid(GLID_INFO *glid, int *index) {
    if (glid == NULL || floor_manager == NULL) {
        return 0;
    }
    return floor_manager->GetNextGlid(glid, index);
}
GLID_INFO *CDngFreeMap::GetRoomGlid(int room) {
    if (floor_manager != NULL)
        return floor_manager->GetDngMapFloorGlidInfo(room);
    return NULL;
}
GLID_INFO *CDngFreeMap::GetEntranceRoomGlid() {
    int grid;
    int byte_offset;
    CDngFloorManager *manager = floor_manager;
    if (manager == NULL) {
        return NULL;
    }

    for (grid = 0, byte_offset = 0; grid < manager->glid_num; byte_offset += sizeof(GLID_INFO), ++grid) {
        GLID_INFO *entry = (GLID_INFO *)((u8 *)manager->glid_info + byte_offset);
        if (entry->type == kGlidRoom && (entry->room.flag & kGlidEntrance)) {
            return entry;
        }
    }
    return NULL;
}
void CDngFreeMap::SetTextureInfo() {
    map_tex = mgTexManager.GetTexture(at_1018__5, -1);
    last_tex = mgTexManager.GetTexture(at_1019__4, -1);
    koma_tex = mgTexManager.GetTexture(at_1020__3, -1);
    name_tex = mgTexManager.GetTexture(at_1021__3, -1);
}
void CDngFreeMap::ResetDngMapPos(int room, int snap) {
    GLID_INFO *glid = GetRoomGlid(room);
    if (glid != NULL) {
        float room_pos[2];

        float row_x, colY, edgeX0, edgeY0, edgeX1, edgeY1;
        int last_x = (short)floor_manager->glid_w;
        int last_y = (short)floor_manager->glid_h;
        int i;
        GLID_INFO *entry;
        for (i = 0; i < floor_manager->glid_num; i++) {
            entry = &floor_manager->glid_info[i];
            if (entry->x == 0) {
                CalcGlidPutPos(entry, edgeX0, colY, 1);
            }
            if (entry->y == 0) {
                CalcGlidPutPos(entry, row_x, edgeY0, 1);
            }
            if (entry->x == last_x) {
                CalcGlidPutPos(entry, edgeX1, colY, 1);
            }
            if (entry->y == last_y) {
                CalcGlidPutPos(entry, row_x, edgeY1, 1);
            }
        }
        CalcGlidPutPos(glid, room_pos[0], room_pos[1], 1);
        next_pos_x = kMapCentreX - room_pos[0];
        next_pos_y = kMapCentreY - room_pos[1];
        if (snap != 0) {
            pos_x = next_pos_x;
            pos_y = next_pos_y;
        }

    } else {
        pos_x = kMapOffScreen;
        next_pos_x = kMapOffScreen;
        pos_y = kMapOffScreen;
        next_pos_y = kMapOffScreen;
    }
}
void CDngFreeMap::DrawBackPattern(int alpha) {
    mgCDrawPrim *prim = GetMenuPrim();
    if (mode == 1) {
        if ((float)alpha < 0.0f)
            return;
        SetSpriteEnv(prim, 2);
        prim->Bilinear(1);
        prim->AntiAliasing(1);
        prim->Begin(6);
        prim->Color(0, 0, 0, 0x20);
        prim->Vertex(0, 0, 0);
        prim->Vertex(mgScreenWidth, mgScreenHeight, 0);
        prim->End();
    }
    if (mode == 0 && map_tex != 0) {
        mgRect<int> rect;
        rect.Set(0, 0x100, 0x80, 0x80);
        DrawMenuTilePattern(prim, map_tex, back_scroll, back_scroll, rect, 1, 0);
        back_scroll += 0.5f;
        if (!(back_scroll < 0.0f))
            back_scroll -= (float)rect.right;
    }
}
void CDngFreeMap::DrawDngName(int frame) {
    if (name_tex == 0)
        return;
    mgRect<int> rect;
    rect.Set(0, 0, 256, 96);
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(name_tex);
    prim->Color(10, 10, 10, fptosi(0.25f * (float)frame));
    PrimQuad(prim, 4.0f, 4.0f, rect);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    PrimQuad(prim, 0.0f, 0.0f, rect);
    prim->End();
}
void CDngFreeMap::DrawLast() {
    if (last_tex == 0 || mode == 1)
        return;
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 4);
    prim->AlphaBlend(1);
    prim->Begin(6);
    prim->Texture(last_tex);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    prim->TextureCrd(0, 0);
    prim->Vertex(0, 0, 0);
    prim->TextureCrd(0x80, 0x80);
    prim->Vertex(mgScreenWidth, mgScreenHeight, 0);
    prim->End();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DrawRoot__11CDngFreeMapF9mgRect_f_P16DNGMAP_ROOT_INFOiUii);
unsigned int CDngFreeMap::DrawGlidCheck(GLID_INFO *glid) {
    int mask;
    int direction;
    GLID_INFO *neighbor;

    if (glid == NULL) {
        return 0;
    }
    mask = 0;
    for (direction = 0; direction < 4; direction++) {
        neighbor = glid->link_glid[direction];
        if ((neighbor != NULL) && (glid->type == 0) && (neighbor->type == kGlidRoom)) {
            if ((direction == kGlidUp) && ((neighbor->y + 1) == glid->y)) {
                mask |= 2;
            }
            if ((direction == kGlidLeft) && ((neighbor->x + 1) == glid->x)) {
                mask |= 8;
            }
            if (((neighbor->room.flag & 0x10) || (neighbor->room.flag & 8)) &&
                (neighbor->room.visited != 0)) {
                if (neighbor->x == glid->x) {
                    if (neighbor->y == (glid->y - 1)) {
                        mask |= 0x40;
                    }
                    if (neighbor->y == (glid->y + 1)) {
                        mask |= 0x80;
                    }
                }
                if (neighbor->y == glid->y) {
                    if (neighbor->x == (glid->x - 1)) {
                        mask |= 0x100;
                    }
                    if (neighbor->x == (glid->x + 1)) {
                        mask |= 0x200;
                    }
                }
            }
        }
    }
    return mask;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DrawRoomOne__11CDngFreeMapF9mgRect_f_P16DNGMAP_ROOM_INFOUiif);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DrawGlid__11CDngFreeMapF9mgRect_f_);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", CheckGeoramaMateria__FP22TRESURE_BOX_FLOOR_INFOiPi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DrawDngRoomInfo__FP16DNGMAP_ROOM_INFO);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DrawGeoramaMateria__FiPciPii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DrawTreeMap__11CDngFreeMapFi);
void CDngFreeMap::DrawPlayer(int alpha) {
    float x;
    float y;
    mgRect<int> rect;
    if (user_glid == NULL || koma_tex == 0)
        return;
    CalcGlidPutPos(user_glid, x, y, 0);
    x += 4.0f;
    y -= 30.0f;
    float alpha_f = (float)alpha;
    if (mode == 1) {
        if (koma_move != 0 && koma_now != NULL) {
            dng_player_pos[0] = koma_now->x;
            dng_player_pos[1] = koma_now->y;
            koma_now = koma_now->next;
        }
        x = dng_player_pos[0];
        y = dng_player_pos[1];
    }
    if (mode == 0)
        y -= 6.0f * sinf(0.06283186f * (float)dng_player_blink_cnt);
    dng_player_blink_cnt++;
    if (dng_player_blink_cnt >= 50)
        dng_player_blink_cnt = 0;
    float tint = 16.0f + this->alpha + 16.0f * sinf(0.06283186f * (float)dng_player_blink_cnt);
    if (tint < 0.0f)
        tint = 0.0f;
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Bilinear(1);
    prim->Begin(6);
    prim->Texture(koma_tex);
    int level = fptosi(tint);
    prim->Color(level, level, level, fptosi(alpha_f));
    rect.Set(0, 0, 30, 48);
    PrimQuad(prim, x, y, rect);
    prim->End();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", Step__11CDngFreeMapFv);
extern "C" void *__ct__9CMenuFontFv(void *);
void CDngFreeMap::Draw() {
    union { CMenuFont font; char font_storage[sizeof(CMenuFont)]; };
    char line[0x100];
    char text[0x20];
    mgRect<int> plateUv;
    int loaded_texture;
    if (active != 0 && !(alpha <= 0.0f)) {
        mgCTextureManager *texture_manager = &mgTexManager;

        mgCTexture *dt_texture = (mgCTexture *)map_tex;
        if (dt_texture != NULL) {
            int alpha = fptosi(this->alpha);
            if (alpha < 0)
                alpha = 0;
            if (alpha > 0x80)
                alpha = 0x80;
            texture_manager->ReloadTexture(dt_texture->block, (sceVif1Packet *)NULL);
            DrawBackPattern(alpha);
            DrawLast();
            DrawTreeMap(alpha);
            DrawPlayer(alpha);
            if (mode != 1) {
                mgCDrawPrim *prim = GetMenuPrim();
                SetSpriteEnv(prim, 0);
                prim->Bilinear(1);
                prim->Begin(6);
                prim->Texture(name_tex);
                prim->Color(0x80, 0x80, 0x80, alpha);
                for (int i = 0; i < mark_num; i++) {
                    plateUv.Set(0xC0, 0xD2, 0x40, 0x2E);
                    PrimQuad(prim, mark_rect[i], plateUv);
                }
                prim->End();
            }
            if (menu_debug_flag != 0) {
                loaded_texture = -1;
                MenuReloadTexture(loaded_texture, MenuDCMsg[2]->texture_block);
                __ct__9CMenuFontFv(&font);
                int next_floor2;
                int next_floor1;
                int next_floor0;
                CMenuFont *menu_font = &font;
                int row_y = 0x6E;
                int panel_top = 0x32;
                float box_x = 0.0f;
                float box_y = (float)panel_top;
                float box_h = 60.0f;
                float box_w = 160.0f;
                DrawMenuFillBox((float)box_x, box_y, (float)box_w, box_h, 0x40, 0, 0, 0);
                menu_font->SetStr(at_2176);
                menu_font->SetPos(0, 0x32);
                menu_font->DrawDirect(menu_font->str, font.pos_x,
                                          font.pos_y);
                int screen_height = mgScreenHeight;
                DrawMenuFillBox(0.0f, 110.0f, 160.0f, (float)(screen_height - 0x6E), 0x40, 0, 0, 0);
                GLID_INFO *glid = select_glid;
                if (glid != NULL && glid->type == kGlidRoom) {
                    DNG_FLOOR_SAVE *record =
                        MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, glid->room.floor_id);
                    if (record != NULL) {
                        sprintf(line, at_2177, select_glid->room.floor_id);
                        DNGMAP_ROOM_INFO *info = &select_glid->room;
                        if (info->flag & 2)
                            strcat(line, at_2178);
                        if (info->flag & 4)
                            strcat(line, at_2179);
                        if (info->flag & 8)
                            strcat(line, at_2180);
                        if (info->flag & 0x10)
                            strcat(line, at_2181);
                        strcat(line, at_2182);
                        menu_font->SetStr(line);
                        menu_font->SetPos(0xA, 0x70);
                        menu_font->DrawDirect(menu_font->str, menu_font->pos_x,
                                                  menu_font->pos_y);
                        next_floor0 =
                            floor_manager->GetDngMapNextFloorID(select_glid->room.floor_id, 0);
                        next_floor1 =
                            floor_manager->GetDngMapNextFloorID(select_glid->room.floor_id, 1);
                        next_floor2 =
                            floor_manager->GetDngMapNextFloorID(select_glid->room.floor_id, 2);
                        sprintf(text, at_2183__2, next_floor0, next_floor1, next_floor2,
                                floor_manager->GetDngMapNextFloorID(select_glid->room.floor_id, 3));
                        menu_font->SetStr(text);
                        menu_font->SetPos(0x14, 0x84);
                        menu_font->DrawDirect(menu_font->str, menu_font->pos_x,
                                                  menu_font->pos_y);
                        strcpy(text, at_2184);
                        int root_mask = floor_manager->GetDngMapNextRoot(select_glid->room.floor_id);
                        for (int root_bit = 0; root_bit < 4; root_bit++) {
                            if (root_mask & (1 << root_bit))
                                strcat(text, RootTable_2119[root_bit]);
                        }
                        menu_font->SetStr(text);
                        menu_font->SetPos(0xA, 0xD4);
                        menu_font->DrawDirect(menu_font->str, menu_font->pos_x,
                                                  menu_font->pos_y);
                        sprintf(line, at_2185, record->visit_count);
                        if (MenuDngDebugFlagSelect == 0)
                            sprintf(line, at_2186, record->visit_count);
                        menu_font->SetStr(line);
                        menu_font->SetPos(0xA, 0xE8);
                        menu_font->DrawDirect(menu_font->str, menu_font->pos_x,
                                                  menu_font->pos_y);
                        row_y += 0x8E;
                        for (int i = 0; i < 8; i++) {
                            strcpy(line, Table_2133[i]);
                            if (record->flag & bittable_2134[i])
                                strcat(line, at_2187);
                            else
                                strcat(line, at_2188);
                            if (MenuDngDebugFlagSelect > 0 && MenuDngDebugFlagSelect - 1 == i)
                                line[0] = '>';
                            menu_font->SetStr(line);
                            menu_font->SetPos(0xA, row_y);
                            menu_font->DrawDirect(menu_font->str, menu_font->pos_x,
                                                      menu_font->pos_y);
                            row_y += 0x14;
                        }
                        strcat(line, at_2189);
                    }
                }
            }
        }
    }
}
void CDngFreeMap::FadeIn(int frames) {
    fade_mode = 0;
    fade_time = frames;
    fade_step = 128.0f;
    if (0 < frames) {
        fade_step = 128.0f / (float)frames;
    }
    alpha = 0.0f;
}
void CDngFreeMap::FadeOut(int frames) {
    fade_mode = 1;
    fade_time = frames;
    fade_step = -128.0f;
    if (0 < frames) {
        fade_step = -128.0f / (float)frames;
    }
}
void CDngFreeMap::DeleteTexBlock() {
    short block = tex_block;

    mgCTextureManager *manager = &mgTexManager;
    if (block >= 0)
        manager->DeleteBlock(block);
}
void CDngFreeMap::SetKomaMove(int move) {
    koma_move = (short)move;
    koma_now = koma_path;
    if (koma_now != NULL)
        koma_now = koma_now->next;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", LoadDngInfo__11CDngFreeMapFP9mgCMemoryiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", CheckDngTreeMapFuncType__Fv);
void MakeDngTreeMapJumpNo(int dungeon, int floor, int *jump_kind, int *jump_target) {
    if (dungeon == 0 && floor == 8) {
        *jump_kind = 1;
        *jump_target = SearchMapNo(at_2739);
    }
    if (dungeon == 1 && floor == 6) {
        *jump_kind = 1;
        *jump_target = SearchMapNo(at_2740);
    }
    if (dungeon == 3 && floor == 0x14) {
        *jump_kind = 1;
        *jump_target = SearchMapNo(at_2741);
        if ((CheckBitFlagMenu(0x1B6) != 0) && (CheckBitFlagMenu(0x1BC) == 0)) {
            *jump_kind = 2;
            *jump_target = dungeon;
        }
    }
    if (floor == 0) {
        *jump_kind = 1;
        *jump_target = SearchMapNo(name_tbl_2728[dungeon]);
        if (dungeon == 6) {
            ((CScene *)GetMainScene())->SetNowMapNo(SearchMapNo(at_2742));
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", InitEnd__12CMenuTreeMapFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", MsgInit__12CMenuTreeMapFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", Step__12CMenuTreeMapFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", Draw__12CMenuTreeMapFv);
int CMenuTreeMap::FadeInOutMenu() {
    int fade_done;

    fade_done = 0;
    switch (mode) {
        case 1:
            fade_done = FadeCheckMenu();
            if (fade_done != 0) {
                FadeOutMenu(kTreeMapFadeOutFrames, 0.0f);
            }
            break;
        case 2:
            if (unk_11a == 0) {
                fade_done = FadeCheckMenu();
            }
            break;
    }
    return fade_done;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DngTreeMapInit__FP9mgCMemoryPiii);
extern "C" void Init__6ClsMesFv(ClsMes *mes) {
    int i;
    int j;
    int k;
    int m;
    int n;

    mes->npc_name_mode = 0;
    mes->char_num = 0;
    mes->text_w = 0;
    mes->text_h = 0;
    mes->page = 0;
    mes->page_num = 0;
    for (i = 0; i < 16; i++) {
        mes->page_chars[i] = 0;
    }
    mes->page_chars[16] = 0;
    mes->page_chars[17] = 0;
    mes->fade = 0;
    mes->open = 1;
    mes->draw_speed = mes->GetDrawSpeedDef();
    mes->page_wait = 0;
    mes->scroll_wait = 0;
    mes->reveal = 0;
    mes->reveal_num = 0;
    mes->page_top = 0;
    mes->unk_1f4 = 0;
    mes->InitMesWinTbl();
    mes->color = mes->def_color;
    mes->wait = 0;
    mes->page_time = 0;
    mes->page_auto_time = 0x1E;
    mes->mes_no = -1;
    mes->unk_1e40 = 0;
    mes->alpha = 0x80;
    for (j = 0; j < 16; j++) {
        memset(mes->name[j], 0, sizeof(mes->name[j]));
    }
    for (k = 0; k < 16; k++) {
        mes->item_mes[k] = -1;
    }
    for (m = 0; m < 16; m++) {
        mes->values[m] = 0;
        mes->value_width[m] = 0;
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
    for (n = 0; n < 20; n++) {
        mes->line_indent[n] = 0;
        mes->line_pos[n][0] = 0;
        mes->line_pos[n][1] = 0;
        mes->line_pos_on[n] = 0;
        mes->line_shade[n] = -1;
        mes->line_color[n] = 0;
        mes->equip_on[n] = 0;
        mes->equip_x[n] = 0;
        mes->equip_y[n] = 0;
        mes->line_w[n] = 0;
        mes->line_alpha[n] = -1;
        mes->cross_on[n] = 0;
        mes->cross_x[n] = 0;
        mes->cross_y[n] = 0;
        mes->unk_271c[n] = -1;
        mes->unk_276c[n] = -1;
        mes->unk_27bc[n] = 0;
        mes->unk_280c[n] = 0;
        mes->delta_on[n] = 0;
        mes->delta_x[n] = 0;
        mes->delta_y[n] = 0;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DngTreeMapKey__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DngTreeMapDraw__Fv);
int CBaseMenuClass::IsCreateObject(int a, int b) {
    return 1;
}
int CBaseMenuClass::IsMakeObject(int a, int b) {
    return 0;
}
int CBaseMenuClass::IsAskExtend(int a, int b) {
    return 0;
}
int CBaseMenuClass::ItemCmdAfter(int command, ITEMCMD_RET_PARA *para) {
    return 0;
}
void CBaseMenuClass::ExitEnd() {}
extern "C" void Set__9mgRect_f_Fffff(mgRect<float> *rect, float x, float y, float w, float h) {
    rect->left = x;
    rect->top = y;
    rect->right = w;
    rect->bottom = h;
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", __sinit_dngmenu_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", markOffsetTable_1092__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", root_type_texturecrd_1216__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", get_moji_tbl_1524__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", put_moji_tbl_1525__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", DngInfoMedalNumMsg__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", dngboardbrdtbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", dngboardbrdtbl_1__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", dngboardbrdtbl_2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", medal_xytbl_1736__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RootTable_2119__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", Table_2133__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", bittable_2134__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RootHokanTable0_2230__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RootHokanTable1_2231__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RootHokanTable2_2232__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RootHokanTable3_2233__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RootHokanTable4_2234__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RootHokanTable5_2235__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RootHokanTable6_2236__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RootHokanTable7_2237__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RootHokanTable8_2238__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RootHokanTable9_2239__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RootHokanTablePtrTable_2240__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RoomHokanTable0_2241__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RoomHokanTable1_2242__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RoomHokanTable2_2243__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RoomHokanTable3_2244__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", RoomHokanTablePtrTable_2245__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", is_reverse_tbl_2246__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", name_tbl_2728__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", bitTable_2900__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3141__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", dng_light_circle__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", dngfreemap_num__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_1018__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_1019__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_1020__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_1021__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_1993__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2120__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2121__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2122__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2123__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2176__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2177__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2178__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2179__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2180__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2181__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2182__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2183__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2184__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2185__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2186__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2187__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2188__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2189__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2681__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2682__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2683__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2684__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2685__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2729__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2730__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2731__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2732__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2733__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2734__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2735__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2739__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2740__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2741__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2742__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2786__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2787__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2788__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2789__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2790__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_2826__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3342__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3343__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3344__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3345__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3346__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3347__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3348__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3349__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3350__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3451__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3539__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3540__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", D_0037B018__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", __vt__12CMenuTreeMap__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", zerumaito_offset_1110__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", stepCntTbl_1501__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", DngInfoStageNo__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", dng_player_pos__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", old_hokantbl_useno_2247__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", is_reverse_tbl_room_2248__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", maxidtable_2752__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3043__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dngmenu", at_3164__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(MenuDngDebugFlagSelect, 0x4);
INCLUDE_BSS(MenuDngMap, 0x4);
INCLUDE_BSS(dngfloor_infoview, 0x4);
INCLUDE_BSS(dngfloor_backdraw, 0x4);
INCLUDE_BSS(dngfloor_backdraw_alpha, 0x4);
INCLUDE_BSS(Floor_InfoTex, 0x4);
INCLUDE_BSS(DngInfoFishOkFlag, 0x4);
INCLUDE_BSS(DngInfoSphidaOkFlag, 0x4);
INCLUDE_BSS(DngAskMessageDrawFlag, 0x4);
INCLUDE_BSS(DngInfoFloorInfo, 0x4);
INCLUDE_BSS(DngInfoRoomInfo, 0x4);
INCLUDE_BSS(DngInfoDrawAlpha, 0x8);
INCLUDE_BSS(DngInfoMedalMsgPutPos, 0x8);
INCLUDE_BSS(AlphaRate_1743, 0x4);
INCLUDE_BSS(init_1744, 0x4);
INCLUDE_BSS(GeoramaMateriaInfoDrawFlag, 0x4);
INCLUDE_BSS(GeoramaMateriaInfoDrawPage, 0x4);
INCLUDE_BSS(GeoramaMateriaNum, 0x4);
INCLUDE_BSS(DngTreeMapActiveLightRate, 0x4);
INCLUDE_BSS(dng_player_blink_cnt, 0x4);
INCLUDE_BSS(DngTreeMode, 0x4);
INCLUDE_BSS(TreeMapSaveFlag, 0x4);
INCLUDE_BSS(TreeMapSaveNum, 0x4);
INCLUDE_BSS(TreeMapSaveDispCount, 0x4);
INCLUDE_BSS(TreeMapSaveHopCount, 0x4);
INCLUDE_BSS(TreeMapSaveDispY, 0x4);
INCLUDE_BSS(TreeMapCallDungeonSubMap, 0x4);
INCLUDE_BSS(TreeMapCalledWorldMap, 0x4);
INCLUDE_BSS(MenuCursorDataBuff, 0x4);
INCLUDE_BSS(CMenuTreePt, 0x4);
INCLUDE_BSS(old_direction_2830, 0x4);
INCLUDE_BSS(init_2831, 0x4);
INCLUDE_BSS(old_glid_2833, 0x4);
INCLUDE_BSS(init_2834, 0x4);
INCLUDE_BSS(NextFloorGlid_2836, 0x4);
INCLUDE_BSS(init_2837, 0x4);
INCLUDE_BSS(at_3040__2, 0x4);
INCLUDE_BSS(at_3145, 0x8);
INCLUDE_BSS(at_3199, 0x8);
INCLUDE_BSS(at_3478, 0x8);

// Uninitialised data (.bss)
INCLUDE_BSS(MenuDngMes, 0x20);
INCLUDE_BSS(treemap_root_put, 0x10);
INCLUDE_BSS(Floor_Info, 0x10);
INCLUDE_BSS(MenuTreeMapStack, 0x30);
INCLUDE_BSS(at_3142, 0x10);
