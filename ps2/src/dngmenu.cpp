#include "sound.hpp"
#include "dataread.hpp"
#include "prespr.hpp"
#include "mg_drawprim.hpp"
#include <cstdio>
#include <cstdlib>
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
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "memcard.hpp"
#include "common.h"
#include "dngmenu.hpp"
#include "mapselect.hpp"
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
extern char at_2826[];
extern char at_2681[];
extern char at_2786[];
extern char at_2787__2[];
extern char at_2788[];
extern char at_2789[];
extern char at_2790[];
extern s8 maxidtable_2752[7];
extern u_char *MenuCursorDataBuff;
extern mgCTexture *Floor_InfoTex;
extern int DngInfoDrawAlpha;
extern char at_3539[];
extern char at_3540[];
extern CDC2Mes *MenuDngMes[DNG_TREE_MAP_MES_MAX];
extern DNGMAP_ROOM_INFO *DngInfoRoomInfo;
extern DNG_FLOOR_SAVE *DngInfoFloorInfo;
extern s8 init_1744;
extern float AlphaRate_1743;
extern int DngInfoMedalMsgPutPos[2];
extern s16 DngInfoMedalNumMsg[][2];
extern s16 medal_xytbl_1736[];
extern s16 dngboardbrdtbl_1[12];
extern s16 markOffsetTable_1092[][2];
extern s16 zerumaito_offset_1110[2];
extern char at_2682[];
extern char at_2683[];
extern char at_2684[];
extern char at_2685[];
extern s8 old_hokantbl_useno_2247[2][4];
extern s8 is_reverse_tbl_room_2248[2][4];
extern s8 is_reverse_tbl_2246[][4];
extern s16 (*RoomHokanTablePtrTable_2245[])[2];
extern s16 (*RootHokanTablePtrTable_2240[])[2];
extern s8 init_2831;
extern int old_direction_2830;
extern s8 init_2834;
extern GLID_INFO *old_glid_2833;
extern s8 init_2837;
extern GLID_INFO *NextFloorGlid_2836;
extern int bitTable_2900[];
extern u8 DngInfoFishOkFlag;
extern u8 DngInfoSphidaOkFlag;
extern char at_3342[];
extern char at_3343[];
extern char at_3344[];
extern char at_3345[];
extern char at_3346[];
extern char at_3347[];
extern char at_3348[];
extern char at_3349[];
extern char at_3350[];
struct DNGMAP_TEX_POS {
    s16 u;
    s16 v;
};
extern DNGMAP_TEX_POS root_type_texturecrd_1216[];
extern int dngfloor_backdraw_alpha;
extern u8 dngfloor_infoview;
extern u8 dngfloor_backdraw;
extern s16 TreeMapSaveDispCount;
extern u8 DngInfoStageNo;
extern "C" void Init__6ClsMesFv(ClsMes *mes);
extern char at_1993[];
extern s16 dngboardbrdtbl[2][12];
extern s16 dngboardbrdtbl_2[12];
extern s8 GeoramaMateriaInfoDrawPage;
extern s16 GeoramaMateriaNum;
extern u8 GeoramaMateriaInfoDrawFlag;
extern s8 DngAskMessageDrawFlag;
extern s16 TreeMapSaveNum;
extern float TreeMapSaveHopCount;
extern char at_3451[];
extern float stepCntTbl_1501[2];
extern s16 get_moji_tbl_1524[4][4];
extern s16 put_moji_tbl_1525[4][2];
static void DrawDngRoomInfo(DNGMAP_ROOM_INFO *room);
static void DrawGeoramaMateria(int y, char *title, int materia_num, int *materia, int tex_block);
extern s16 TreeMapSaveDispY;
extern char *RootTable_2119[4];
extern char Table_2133[8][0x20];
extern int bittable_2134[8];
extern "C" float sinf(float);
extern mgRect<float> treemap_root_put;
extern mgRect<int> dng_light_circle;
extern mgRect<int> dngfreemap_num;
extern mgRect<int> Floor_Info;
extern mgCMemory MenuTreeMapStack;
extern CMenuTreeMap *CMenuTreePt;
extern CDngFreeMap *MenuDngMap;
extern s16 DngTreeMode;
extern float dng_player_pos[2];
extern float DngTreeMapActiveLightRate;
extern int dng_player_blink_cnt;
extern char at_1018__5[];
extern char at_1019__4[];
extern char at_1020__3[];
extern char at_1021__3[];
int SearchMapNo(char *mapName);

// Code (.text)
void CDngFreeMap::Initialize() {
    float left = 120.0f;
    float top = 138.0f;
    float bottom = 286.0f;
    float right = 420.0f;
    active = 1;
    unk_9 = 0;
    dng_no = 0;
    floor_manager = NULL;
    save_dungeon = NULL;
    mode = DNGMAP_MODE_MENU;
    view_rect.Set(left, top, right, bottom);
    mark_num = 0;
    next_room_no = -1;
    user_room_no = -1;
    back_scroll = 0.0f;
    pos_y = 0.0f;
    pos_x = 0.0f;
    next_pos_x = 200.0f;
    next_pos_y = 200.0f;
    select_glid = NULL;
    InitTexture();
    alpha = 128.0f;
    user_glid = NULL;
    blink_cnt = 0;
    koma_now = NULL;
    koma_path = NULL;
    koma_move = 0;
    fade_mode = DNGMAP_FADE_NONE;
    fade_time = -1;
    fade_step = 0.0f;
}
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
    int clampedX = x;
    int clampedY = y;

    if ((float)clampedX < view_rect.left) {
        clampedX = (int)view_rect.left;
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
#ifdef NONMATCHING
void CDngFreeMap::DrawRoot(mgRect<float> rect, DNGMAP_ROOT_INFO *root, int shadow, unsigned int glid_check, int alpha) {
    mgRect<float> *put;
    s16 *mark;
    mgCDrawPrim *prim;
    if (root == NULL || (float)mgScreenWidth < rect.left || !(rect.top <= (float)(mgScreenHeight + 20))) {
        return;
    }
    put = &treemap_root_put;
    *put = rect;
    if (shadow != 0) {
        put->left += 8.0f;
        put->top += 8.0f;
    }
    float red = 212.0f;
    float mark_level = 128.0f;
    float green = 192.0f;
    float blue = 144.0f;
    mark = markOffsetTable_1092[0];
    if (mode == DNGMAP_MODE_EVENT) {
        red = 128.0f;
        mark_level = 64.0f;
        blue = 0.0f;
        green = 111.0f;
    }
    prim = GetMenuPrim();
    SetSpriteEnv(prim, 2);
    prim->Begin(1);
    int r = fptosi(red);
    int g = fptosi(green);
    int b = fptosi(blue);
    prim->Color(r, g, b, alpha);
    if (shadow != 0) {
        prim->Color(0, 0, 0, fptosi(0.05f * (float)alpha));
    }
    if (root->shape == 1 || (root->shape >= 2 && root->shape <= 3) || (root->shape >= 6 && root->shape <= 7)) {
        put->left -= 5.0f;
    }
    put->right = 52.0f + put->left;
    put->bottom = 20.0f + put->top;
    if (root->shape == 0) {
        put->left += 26.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put->left + (float)i, put->top, 0.0f);
            prim->Vertex(-16.0f + (put->left + (float)i), put->bottom, 0.0f);
        }
        mark = markOffsetTable_1092[0];
        if (dng_no == 6) {
            mark = zerumaito_offset_1110;
        }
    } else if (root->shape == 1) {
        if (glid_check & 0x100) {
            put->left += 14.0f;
        }
        put->top += 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put->left - (float)i, put->top + (float)i, 0.0f);
            prim->Vertex(put->right - (float)i, put->top + (float)i, 0.0f);
        }
        mark = markOffsetTable_1092[1];
    } else if (root->shape == 2) {
        put->left += 25.0f;
        put->top += 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put->left - (float)i, put->top + (float)i, 0.0f);
            prim->Vertex(put->right - (float)i, put->top + (float)i, 0.0f);
        }
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put->left + (float)i, put->top, 0.0f);
            prim->Vertex(put->left + (float)i - 10.0f, put->bottom, 0.0f);
        }
        mark = markOffsetTable_1092[2];
    } else if (root->shape == 3) {
        put->right -= 27.0f;
        put->top += 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put->left - (float)i, put->top + (float)i, 0.0f);
            prim->Vertex(put->right - (float)i, put->top + (float)i, 0.0f);
        }
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put->right + (float)i, put->top, 0.0f);
            prim->Vertex(put->right + (float)i - 10.0f, put->bottom, 0.0f);
        }
        mark = markOffsetTable_1092[3];
    } else if (root->shape == 4) {
        put->left += 26.0f;
        put->bottom -= 10.0f;
        float branch_left = put->left - 2.0f;
        float branch_top = 2.0f + put->bottom;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put->left + (float)i, put->top, 0.0f);
            prim->Vertex(put->left + (float)i - 10.0f, branch_top, 0.0f);
        }
        for (int i = 0; i < 3; i++) {
            prim->Vertex(branch_left - (float)i - 5.0f, put->bottom + (float)i, 0.0f);
            prim->Vertex(put->right - (float)i - 5.0f, put->bottom + (float)i, 0.0f);
        }
        mark = markOffsetTable_1092[4];
    } else if (root->shape == 5) {
        put->right -= 26.0f;
        put->bottom -= 10.0f;
        put->left += 1.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put->left - (float)i - 5.0f - 1.0f, put->bottom + (float)i, 0.0f);
            prim->Vertex(put->right - (float)i - 5.0f - 1.0f, put->bottom + (float)i, 0.0f);
        }
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put->right + (float)i, put->top, 0.0f);
            prim->Vertex(1.0f + (put->right + (float)i - 10.0f), put->bottom, 0.0f);
        }
        mark = markOffsetTable_1092[5];
        put->left = put->right;
    } else if (root->shape == 6) {
        put->left += 15.5f;
        put->top += 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put->left + (float)i, put->bottom, 0.0f);
            prim->Vertex(put->right - (float)i, put->top + (float)i, 0.0f);
        }
    } else if (root->shape == 7) {
        put->left -= 1.0f;
        put->right -= 35.0f;
        put->top += 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put->left - (float)i / 2.0f, put->top + (float)i, 0.0f);
            prim->Vertex(put->right - (float)i, put->bottom, 0.0f);
        }
    } else if (root->shape == 8) {
        put->left += 26.0f;
        put->right -= 5.5f;
        put->bottom -= 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(1.5f + put->left - (float)i, put->top, 0.0f);
            prim->Vertex(put->right - (float)i / 2.0f, put->bottom + (float)i, 0.0f);
        }
    } else if (root->shape == 9) {
        put->left -= 6.0f;
        put->right -= 26.0f;
        put->bottom -= 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put->left - (float)i, put->bottom + (float)i, 0.0f);
            prim->Vertex(put->right + (float)i, put->top, 0.0f);
        }
    }
    prim->End();
    prim->Bilinear(0);
    prim->TextureMapEnable(1);
    prim->Begin(6);
    prim->Color(r, g, b, alpha);
    if (shadow != 0) {
        prim->Color(0, 0, 0, fptosi(0.05f * (float)alpha));
    }
    prim->Texture(map_tex);
    if (root->type != 0 && root->opened != 0 && root->show_mark != 0 && mark != NULL) {
        int level = fptosi(mark_level);
        prim->Color(level, level, level, alpha);
        if (shadow != 0) {
            prim->Color(0, 0, 0, fptosi(0.05f * (float)alpha));
        }
        int type = root->type;
        prim->TextureCrd(root_type_texturecrd_1216[type].u, root_type_texturecrd_1216[type].v);
        prim->Vertex(rect.left + (float)mark[0], rect.top + (float)mark[1], 0.0f);
        prim->TextureCrd(root_type_texturecrd_1216[type].u + 0x16, root_type_texturecrd_1216[type].v + 0x16);
        prim->Vertex(22.0f + (rect.left + (float)mark[0]), 22.0f + (rect.top + (float)mark[1]), 0.0f);
    }
    prim->End();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DrawRoot__11CDngFreeMapF9mgRect_f_P16DNGMAP_ROOT_INFOiUii);
#endif
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
#ifdef NONMATCHING
void CDngFreeMap::DrawRoomOne(mgRect<float> rect, DNGMAP_ROOM_INFO *room, unsigned int glid_check, int alpha, float bright) {
    if (room == NULL || !(rect.left <= (float)(mgScreenWidth + 20)) || !(rect.top <= (float)(mgScreenHeight + 30))) {
        return;
    }
    rect.left -= 30.0f;
    rect.top += -42.0f;
    mgRect<float> put = rect;
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    put.right = 96.0f;
    put.bottom = 66.0f;
    if (dng_no == 4 || dng_no == 5 || dng_no == 6) {
        put.right = 100.0f;
        put.bottom = 68.0f;
    }
    mgRect<int> uv(0, 0x42, 0x60, 0x42);
    mgRect<int> special_uv(0xC0, 0xC6, 0x60, 0x60);
    int picture = room->tex_no;
    if (room->visited == 0) {
        uv.left = 0;
        uv.top = 0;
    } else {
        uv.left += uv.right * (picture % 5);
        uv.top += uv.bottom * (picture / 5);
        if (room->flag & 2) {
            uv.left = 0x60;
            uv.top = 0;
        }
        if (room->flag & 4) {
            uv.left = 0xC0;
            uv.top = 0;
        }
        if ((room->flag & 0x10) || (room->flag & 8)) {
            uv.left = special_uv.left + room->tex_no % 3 * 0x60;
            uv.top = special_uv.top + room->tex_no / 3 * 0x60;
            uv.right = special_uv.right;
            uv.bottom = special_uv.bottom;
            if (room->tex_no >= 3) {
                uv.bottom = 0x5A;
            }
            put.right = (float)uv.right;
            put.bottom = (float)uv.bottom;
        }
        put.left += (float)room->offset_x;
        put.top += (float)room->offset_y;
    }
    int level = fptosi(128.0f * bright);
    float shade = 1.0f;
    float shadow_alpha = 0.25f * (float)alpha;
    s16 draw_mode = mode;
    if (draw_mode == DNGMAP_MODE_EVENT && user_glid != NULL && &user_glid->room != room) {
        level = fptosi(64.0f * bright);
        shade = 0.5f;
    }
    if (draw_mode == DNGMAP_MODE_MENU) {
        prim->Begin(6);
        prim->Texture(map_tex);
        prim->Color(0, 0, 0, fptosi(shadow_alpha));
        PrimQuad(prim, 8.0f + put.left, 8.0f + put.top, uv);
        prim->End();
    }
    SetSpriteEnv(prim, 0);
    room->mark_phase += stepCntTbl_1501[mode];
    if (!(room->mark_phase <= 3.1415927f)) {
        room->mark_phase -= 6.2831855f;
    }
    int red = 0xC0;
    int green = 0xC0;
    int blue = 0xC0;
    if (room->mark != 0) {
        float phase = room->mark_phase;
        while (!(phase <= 3.1415927f)) {
            phase -= 6.2831855f;
        }
        while (phase < -3.1415927f) {
            phase += 6.2831855f;
        }
        if (!(phase <= 0.0f)) {
            red = green = blue = fptosi(7.0f * (float)level / 8.0f);
        }
    } else {
        red = green = blue = level;
    }
    prim->Bilinear(0);
    prim->Begin(6);
    prim->Texture(map_tex);
    prim->Color(red, green, blue, alpha);
    PrimQuad(prim, put, uv);
    prim->End();
    if (room->visited == 0 && user_glid != NULL && &user_glid->room != room) {
        float mark_x = 40.0f + put.left;
        int x0 = fptosi(mark_x);
        float mark_y = 25.0f + put.top;
        int y0 = fptosi(mark_y);
        int x1 = fptosi(20.0f + mark_x);
        int y1 = fptosi(30.0f + mark_y);
        prim->Begin(6);
        prim->Color(red, green, blue, alpha);
        prim->TextureCrd(0x1EC, 0x42);
        prim->Vertex(x0, y0, 0);
        prim->TextureCrd(0x200, 0x60);
        prim->Vertex(x1, y1, 0);
        prim->End();
    }
    if (room->mark != 0) {
        float bob = 0.71875f * (6.0f * sinf(-room->mark_phase));
        mark_rect[mark_num].left = 64.0f + put.left;
        mark_rect[mark_num].top = 4.0f + put.top - bob;
        mark_rect[mark_num].right = 64.0f + bob;
        mark_rect[mark_num].bottom = 46.0f + bob;
        mark_num++;
    }
    if (name_tex != NULL && room->visited == 1) {
        for (int i = 0; i < 3; i++) {
            if (room->flag & (1 << (i + 1))) {
                s16 *letter = get_moji_tbl_1524[i];
                if (letter[0] >= 0) {
                    mgRect<float> letter_put(put.left + (float)put_moji_tbl_1525[i][0], put.top + (float)put_moji_tbl_1525[i][1],
                                             (float)letter[2], (float)letter[3]);
                    prim->TextureMapEnable(1);
                    prim->Begin(6);
                    prim->Texture(name_tex);
                    int letter_level = fptosi(128.0f * shade);
                    prim->Color(letter_level, letter_level, letter_level, alpha);
                    mgRect<int> letter_uv(letter[0], letter[1], letter[2], letter[3]);
                    PrimQuad(prim, letter_put.left, letter_put.top, letter_uv);
                    prim->End();
                }
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DrawRoomOne__11CDngFreeMapF9mgRect_f_P16DNGMAP_ROOM_INFOUiif);
#endif
void CDngFreeMap::DrawGlid(mgRect<float> rect) {
    mgCDrawPrim prim;
    SetSpriteEnv(&prim, 1);
    prim.AntiAliasing(1);
    prim.Begin(2);
    prim.Color(0xFF, 0, 0, fptosi(alpha));
    float top = rect.top;
    prim.Vertex(rect.left, top, 0.0f);
    float right = rect.left + rect.right;
    prim.Vertex(right, top, 0.0f);
    float bottom = 20.0f + top;
    prim.Vertex(-16.0f + right, bottom, 0.0f);
    prim.Vertex(-16.0f + rect.left, bottom, 0.0f);
    prim.Vertex(rect.left, top, 0.0f);
    prim.End();
}
#ifdef NONMATCHING
int CheckGeoramaMateria(TRESURE_BOX_FLOOR_INFO *tresure, int floor, int *materia) {
    int cursor;
    int materia_num;
        int g;
    int group_id;
    TRESURE_BOX_GROUP *group;
    int k;
    int pass;

    if (tresure == NULL) {
        return 0;
    }
    if (floor < 0) {
        return 0;
    }
    materia_num = 0;
    cursor = 0;
    TRESURE_BOX_FLOOR *floor_info = &tresure->floor[floor];
    while (cursor < floor_info->group_num) {
        group_id = floor_info->group_id[cursor];
        if (group_id >= 0) {
            group = NULL;
            for (g = 0; g < tresure->group_num; g++) {
                if (group_id == tresure->group[g].group_id) {
                    group = &tresure->group[g];
                    break;
                }
            }
            k = 0;
            if (group != NULL) {
                for (; k < group->item_num; k++) {
                    materia[materia_num++] = group->item[k].item_no;
                }
            }
        }
        cursor++;
    }
    for (pass = 0; pass < 2; pass++) {
        for (cursor = 0; cursor < materia_num; cursor++) {
            if (!(GetItemDataAttribute(materia[cursor]) & 0x10)) {
                local_sort1(cursor, &materia_num, materia);
            }
        }
    }
    return materia_num;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", CheckGeoramaMateria__FP22TRESURE_BOX_FLOOR_INFOiPi);
#endif
#ifdef NONMATCHING
static void DrawDngRoomInfo(DNGMAP_ROOM_INFO *room) {
    if (room != NULL && Floor_InfoTex != NULL) {
        if (dngfloor_infoview != 0) {
            CalcMenuAdd(&DngInfoDrawAlpha, 6, 0x80);
        } else {
            CalcMenuAdd(&DngInfoDrawAlpha, -8, 0);
        }
        int language = LanguageCode;
        int board_w = 0x19C;
        int board_h = 0xE4;
        if (language > 0) {
            board_w = 0x1D6;
            if (MenuDngMes[5] == NULL || MenuDngMes[5]->ClsMes::mes_no != 0x6C) {
                board_h += 0x16;
            }
        }
        float board_x;
        float board_y = 92.0f;
        s16 *bottom_tbl = dngboardbrdtbl_1;
        int centre_x = mgScreenWidth >> 1;
        int alpha = DngInfoDrawAlpha;
        board_x = (float)((0x200 - board_w) >> 1);
        int box_alpha = alpha * 7 / 10;
        if (DngInfoRoomInfo != NULL) {
            if (DngInfoRoomInfo->geostone == 0) {
                bottom_tbl = dngboardbrdtbl_2;
                board_h -= 0x20;
                board_y += 20.0f;
            }
            if (DngInfoRoomInfo->spheda == 0) {
                board_h -= 0x16;
                board_y += 14.0f;
            }
            if (DngInfoRoomInfo->fishing == 0) {
                board_h -= 0x16;
                board_y += 14.0f;
            }
        }
        DrawMenuFillBox(6.0f + board_x, 6.0f + board_y, (float)(board_w - 8), (float)(board_h - 8), box_alpha, 0xC, 0xC, 0xC);
        mgCDrawPrim *prim = GetMenuPrim();
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture(Floor_InfoTex);
        prim->Color(0x80, 0x80, 0x80, alpha);
        int left = fptosi(board_x);
        int top = fptosi(board_y);
        Menu3DivideTextureDraw(prim, mgRect<int>(left, top, board_w, 0x46), dngboardbrdtbl[0], 1);
        Menu3DivideTextureDraw(prim, mgRect<int>(left, top + 0x46, board_w, board_h - 0x46 - dngboardbrdtbl[1][3]), dngboardbrdtbl[1], 1);
        Menu3DivideTextureDraw(prim, mgRect<int>(left, top + board_h - bottom_tbl[3], board_w, bottom_tbl[3]), bottom_tbl, 1);
        prim->End();
        prim->Begin(6);
        prim->Texture(Floor_InfoTex);
        prim->Color(0x80, 0x80, 0x80, alpha);
        PrimQuad(prim, (float)(centre_x - (Floor_Info.right >> 1)) - 1.0f, 10.0f + board_y, Floor_Info);
        prim->End();
        float mark_y = 68.0f + board_y;
        int value_x = left + board_w - 0x48;
        if (CheckNowEurope() != 0) {
            value_x = left + board_w - 0x54;
        }
        mgRect<int> mark_uv(0x7C, 0, 0x16, 0x16);
        mgRect<int> medal_uv(0x92, 0, 0x16, 0x16);
        prim->Bilinear(1);
        prim->Begin(6);
        prim->Texture(Floor_InfoTex);
        prim->Color(0x80, 0x80, 0x80, alpha);
        if (MenuDngMes[0] != NULL) {
            MenuDngMes[0]->SetMovePosCenteringGyou(0, centre_x, top + 0x26);
        }
        if (DngInfoFloorInfo != NULL && !(DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_SEAL_CLEAR) && 0 < room->seal) {
            if (init_1744 == 0) {
                AlphaRate_1743 = 0.0f;
                init_1744 = 1;
            }
            AlphaRate_1743 += 0.034906585f;
            if (3.1415927f <= AlphaRate_1743) {
                AlphaRate_1743 -= 3.1415927f;
            }
            float seal_alpha = (float)alpha * sinf(AlphaRate_1743);
            if (seal_alpha < 0.0f) {
                seal_alpha = 0.0f;
            }
            if (128.0f < seal_alpha) {
                seal_alpha = 128.0f;
            }
            mgRect<int> seal_name_uv(0xD8, 0xA6, 0x28, 0x18);
            mgRect<int> seal_icon_uv(0xB8, 0xD6, 0x18, 0x18);
            mgRect<int> *seal_uv = &seal_name_uv;
            prim->Color(0x80, 0x80, 0x80, fptosi(seal_alpha));
            float seal_x;
            if (language > 0) {
                seal_uv->top += (room->seal - 1) * 0x18;
                seal_x = board_x + (float)board_w - 56.0f;
            } else {
                seal_uv = &seal_icon_uv;
                seal_uv->left += (room->seal - 1) * 0x18;
                seal_x = board_x + (float)board_w - 40.0f;
            }
            PrimQuad(prim, seal_x, 35.0f + board_y, *seal_uv);
            prim->Color(0x80, 0x80, 0x80, alpha);
        }
        int mark_x = fptosi(20.0f + board_x);
        int line_y = fptosi(2.0f + (68.0f + (float)top));
        int row_y = line_y;
        int text_x = mark_x + 0x1C;
        PrimQuad(prim, (float)mark_x, mark_y, mark_uv);
        if (DngInfoFloorInfo != NULL && (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_FAST_DESTROY_CLEAR)) {
            medal_uv.left = medal_xytbl_1736[0];
            PrimQuad(prim, (float)mark_x, (float)row_y, medal_uv);
        }
        MenuDngMes[1]->SetMovePosGyou(0, text_x, line_y);
        int time_x = left + board_w - MenuDngMes[1]->line_w[1] - 0xE;
        if (CheckNowEurope() != 0) {
            time_x -= 8;
        }
        row_y += 0x16;
        MenuDngMes[1]->SetMovePosGyou(1, time_x, line_y);
        line_y += 0x16;
        if (DngInfoRoomInfo != NULL && DngInfoRoomInfo->fishing != 0) {
            PrimQuad(prim, (float)mark_x, (float)row_y, mark_uv);
            if (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_FISHING_CLEAR) {
                medal_uv.left = medal_xytbl_1736[2];
                PrimQuad(prim, (float)mark_x, (float)row_y, medal_uv);
            }
            MenuDngMes[3]->SetMovePosGyou(0, text_x, line_y);
            MenuDngMes[3]->SetMovePosGyou(1, left + board_w - MenuDngMes[3]->line_w[1] - 0x10, line_y);
            if (MenuDngMes[3]->ClsMes::mes_no == 2) {
                MenuDngMes[3]->SetMovePosGyou(1, value_x, line_y);
            }
            row_y += 0x16;
            line_y += 0x16;
        }
        if (DngInfoRoomInfo != NULL && DngInfoRoomInfo->spheda != 0) {
            PrimQuad(prim, (float)mark_x, (float)row_y, mark_uv);
            int spheda_x = value_x;
            if (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_SPHEDA_CLEAR) {
                if (language > 0) {
                    spheda_x = value_x - 9;
                }
                if (CheckNowEurope() != 0) {
                    spheda_x = left + board_w - MenuDngMes[4]->line_w[1] - 0x10;
                }
                medal_uv.left = medal_xytbl_1736[3];
                PrimQuad(prim, (float)mark_x, (float)row_y, medal_uv);
            } else if (CheckBitFlagMenu(0x13D) != 0) {
                if (language > 0) {
                    spheda_x = value_x - 0x20;
                }
                if (CheckNowEurope() != 0) {
                    spheda_x = left + board_w - MenuDngMes[4]->line_w[1] - 0x10;
                }
            }
            row_y += 0x16;
            MenuDngMes[4]->SetMovePosGyou(0, text_x, line_y);
            MenuDngMes[4]->SetMovePosGyou(1, spheda_x, line_y);
            line_y += 0x16;
        }
        PrimQuad(prim, (float)mark_x, (float)row_y, mark_uv);
        if (DngInfoFloorInfo != NULL && (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_PRACTICE_CLEAR)) {
            medal_uv.left = medal_xytbl_1736[4];
            PrimQuad(prim, (float)mark_x, (float)row_y, medal_uv);
        }
        if (language == 0) {
            MenuDngMes[5]->SetMovePosGyou(0, text_x, line_y);
            MenuDngMes[5]->SetMovePosGyou(1, value_x, line_y);
            line_y += 0x16;
        } else {
            MenuDngMes[5]->SetMovePosGyou(0, text_x, line_y);
            if (MenuDngMes[5]->ClsMes::mes_no == 0x6C) {
                MenuDngMes[5]->SetMovePosGyou(1, left + board_w - MenuDngMes[5]->line_w[1] - 0x10, line_y);
                line_y += 0x16;
            } else {
                MenuDngMes[5]->SetMovePosGyou(1, text_x, line_y + 0x16);
                MenuDngMes[5]->SetMovePosGyou(2, left + board_w - MenuDngMes[5]->line_w[2] - 0x10, line_y + 0x12);
                line_y += 0x2C;
            }
        }
        prim->End();
        MenuDngMes[6]->SetMovePosGyou(0, text_x, line_y);
        MenuDngMes[6]->SetMovePosGyou(1, left + board_w - MenuDngMes[6]->line_w[1] - 0x1A, line_y);
        if (DngInfoRoomInfo != NULL && DngInfoRoomInfo->geostone != 0) {
            MenuDngMes[7]->SetMovePosGyou(0, centre_x - (MenuDngMes[7]->line_w[0] >> 1), line_y + 0x24);
        }
        for (int i = 0; i < DNG_TREE_MAP_MES_MAX; i++) {
            MenuDngMes[i]->SetMsgAlpha(alpha);
        }
        if (MenuDCMsg[5] != NULL) {
            DngInfoMedalMsgPutPos[0] = DngInfoMedalNumMsg[language][0];
            DngInfoMedalMsgPutPos[1] = DngInfoMedalNumMsg[language][1];
            MenuDCMsg[5]->SetPutPos(DngInfoMedalMsgPutPos);
            MenuDCMsg[5]->SetMsgAlpha(alpha);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DrawDngRoomInfo__FP16DNGMAP_ROOM_INFO);
#endif
#ifdef NONMATCHING
static void DrawGeoramaMateria(int y, char *title, int materia_num, int *materia, int tex_block) {
    int screen_w = mgScreenWidth;
    int left = (screen_w - 430) >> 1;
    int left_column = screen_w / 3;
    int right_column = screen_w - left_column;
    mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *)NULL);
    CMenuFont font;
    DrawMenuFillBox((float)(left + 6), (float)(y + 6), 422.0f, 272.0f, 0x59, 0xC, 0xC, 0xC);
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(Floor_InfoTex);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, y, 430, 70), dngboardbrdtbl[0], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, y + 70, 430, 210 - dngboardbrdtbl[1][3]), dngboardbrdtbl[1], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, y + 280 - dngboardbrdtbl_2[3], 430, dngboardbrdtbl_2[3]), dngboardbrdtbl_2, 1);
    PrimQuad(prim, (float)((mgScreenWidth >> 1) - (Floor_Info.right >> 1)) - 1.0f, 10.0f + (float)y, Floor_Info);
    prim->End();
    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
    int title_h;
    int title_w;
    font.SetStr(title);
    font.CalcDrawWH(font.str, &title_w, &title_h);
    font.SetPos((mgScreenWidth - title_w) >> 1, y + 0x26);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
    int i = GeoramaMateriaInfoDrawPage * 14;
    int end = i + 14;
    int line_y = y + 0x47;
    if (GeoramaMateriaNum < end) {
        end = GeoramaMateriaNum;
    }
    for (; i < end; i++) {
        char *name = GetItemMessage(materia[i]);
        if (name != NULL) {
            int name_h;
            int name_w;
            font.SetStr(name);
            font.CalcDrawWH(font.str, &name_w, &name_h);
            int column = i % 2;
            int x;
            if (column == 0) {
                x = left_column - (name_w >> 1);
            } else {
                x = right_column - (name_w >> 1);
            }
            font.SetPos(x, line_y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            if (column != 0) {
                line_y += 0x18;
            }
        }
    }
    char page[0x20];
    sprintf(page, at_1993, GeoramaMateriaInfoDrawPage + 1, GeoramaMateriaNum / 14 + 1);
    font.SetStr(page);
    font.SetPos(left + 0x186, y + 0xEF);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DrawGeoramaMateria__FiPciPii);
#endif
void CDngFreeMap::DrawTreeMap(int alpha) {
    GLID_INFO *glid = floor_manager->glid_info;
    mgRect<float> rect(0.0f, 0.0f, 52.0f, 20.0f);
    unsigned int glid_check;
    int i;
    if (mode == DNGMAP_MODE_MENU) {
        float light[2];
        mgCDrawPrim *prim = GetMenuPrim();
        CalcGlidPutPos(select_glid, light[0], light[1], 0);
        light[0] = light[0] - 8.0f - 30.0f;
        light[1] = -42.0f + (11.0f + light[1]);
        float shrink_w = 62.0f - 62.0f * DngTreeMapActiveLightRate;
        float shrink_h = 40.0f - 40.0f * DngTreeMapActiveLightRate;
        SetSpriteEnv(prim, 4);
        prim->Bilinear(0);
        prim->Begin(6);
        prim->Texture(map_tex);
        prim->Color(0x80, 0x80, 0x80, fptosi(0.5f * (float)alpha));
        prim->TextureCrd(dng_light_circle.left, dng_light_circle.top);
        prim->Vertex(light[0] + shrink_w, light[1] + shrink_h, 0.0f);
        prim->TextureCrd(dng_light_circle.left + dng_light_circle.right, dng_light_circle.top + dng_light_circle.bottom);
        prim->Vertex(124.0f + light[0] - shrink_w, 80.0f + light[1] - shrink_h, 0.0f);
        prim->End();
    }
    for (i = 0; i < floor_manager->glid_num; i++, glid++) {
        CalcGlidPutPos(glid, rect.left, rect.top, 0);
        if (menu_debug_flag != 0) {
            DrawGlid(rect);
        }
        glid_check = DrawGlidCheck(glid);
        if (glid->type == kGlidRoom) {
            float bright = 1.0f;
            if ((s8)glid->blink != 0 && blink_cnt % 25 < 14) {
                bright = 0.5f;
            }
            DrawRoomOne(rect, &glid->room, 0, alpha, bright);
        } else if (glid->type == 0) {
            DrawRoot(rect, &glid->root, 1, glid_check, alpha);
            DrawRoot(rect, &glid->root, 0, glid_check, alpha);
        }
    }
}
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
void CDngFreeMap::Step() {
    if (active != 0) {
        if (fade_mode == DNGMAP_FADE_IN) {
            alpha += fade_step;
            if (128.0f < alpha) {
                alpha = 128.0f;
            }
        } else if (fade_mode == DNGMAP_FADE_OUT) {
            alpha += fade_step;
            if (alpha < 0.0f) {
                alpha = 0.0f;
            }
        }
        pos_x += (next_pos_x - pos_x) / 5.0f;
        pos_y += (next_pos_y - pos_y) / 5.0f;
        if ((float)abs(fptosi(pos_x - next_pos_x)) < 1.0f) {
            pos_x = next_pos_x;
        }
        if ((float)abs(fptosi(pos_y - next_pos_y)) < 1.0f) {
            pos_y = next_pos_y;
        }
        blink_cnt++;
        if (blink_cnt >= 100) {
            blink_cnt = 0;
        }
        DngTreeMapActiveLightRate += 0.05f;
        if (!(DngTreeMapActiveLightRate < 1.0f)) {
            DngTreeMapActiveLightRate = 1.0f;
        }
        mark_num = 0;
    }
}
extern "C" void *__ct__9CMenuFontFv(void *);
void CDngFreeMap::Draw() {
    union { CMenuFont font; };
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
#ifdef NONMATCHING
int CDngFreeMap::LoadDngInfo(mgCMemory *stack, int tex_block, int dng_no, int user_room_no, int next_room_no) {
    int i;
    if (stack == NULL || stack->stGetRest() <= 0) {
        return 0;
    }
    save_dungeon = &GetSaveData()->save_dungeon;
    mgCDrawPrim *menu_prim = GetMenuPrim();
    menu_prim->offset_x = 0;
    menu_prim->offset_y = 0;
    mgCMemory work;
    int rest = stack->stGetRest();
    work.stSetBuffer(stack->stGetTop(), rest);
    work.Align64();
    floor_manager = &((DNG_BATTLE_AREA *)menu_GetBattleAreaScene())->floor_manager;
    this->dng_no = dng_no;
    floor_manager->CheckDrawGlidInfo();
    this->user_room_no = user_room_no;
    this->next_room_no = next_room_no;
    GetRoomGlid(this->user_room_no);
    if (0 <= this->next_room_no) {
        GetRoomGlid(this->next_room_no);
    }
    select_glid = NULL;
    mode = DNGMAP_MODE_EVENT;
    InitTexture();
    this->tex_block = tex_block;
    work.Align64();
    u_long128 *file = work.stGetTop();
    if (file != NULL) {
        char name[0x40];
        sprintf(name, at_2681, dng_no);
        unsigned int size = LoadFileMenu(name, file, 1);
        work.Alloc((size & 0xF) ? (size >> 4) + 1 : size >> 4);
        MenuEnterIMG(this->tex_block, (u_char *)file, at_2682);
        koma_tex = mgTexManager.GetTexture(at_2683, -1);
        map_tex = mgTexManager.GetTexture(at_2684, -1);
        name_tex = mgTexManager.GetTexture(at_2685, -1);
    }
    view_rect.Set(60.0f, 40.0f, (float)(mgScreenWidth - 40), (float)(mgScreenHeight - 40));
    SetUserGlid(this->user_room_no);
    ResetDngMapPos(this->user_room_no, 1);
    koma_now = NULL;
    koma_path = NULL;
    koma_move = 0;
    CalcGlidPutPos(user_glid, dng_player_pos[0], dng_player_pos[1], 0);
    dng_player_pos[0] += 8.0f;
    dng_player_pos[1] += -28.0f;
    if (0 <= this->next_room_no) {
        int direction;
        float glid_x;
        float glid_y;
        float room_x;
        float room_y;
        glid_x = 0.0f;
        direction = -1;
        glid_y = 0.0f;
        room_x = 0.0f;
        room_y = 0.0f;
        GLID_INFO *from_glid = GetRoomGlid(this->user_room_no);
        if (this->dng_no == 1) {
            if (this->user_room_no == 8 && this->next_room_no > 8) {
                if (this->next_room_no <= 7) {
                    this->next_room_no = 7;
                } else if (this->next_room_no <= 12) {
                    this->next_room_no = 9;
                } else {
                    this->next_room_no = 13;
                }
            }
            if (this->user_room_no > 13 && this->user_room_no > this->next_room_no) {
                this->next_room_no = this->user_room_no - 1;
            }
            if (this->user_room_no == 13) {
                if (this->next_room_no <= 13) {
                    this->next_room_no = 8;
                } else {
                    this->next_room_no = 14;
                }
            }
        }
        if (this->dng_no == 2) {
            if (this->user_room_no == 5 && this->next_room_no > 5 && this->next_room_no <= 8) {
                this->next_room_no = 6;
            }
            if (this->user_room_no > 5 && this->user_room_no <= 8 && this->next_room_no > 8) {
                this->next_room_no = this->user_room_no - 1;
            }
            if (this->user_room_no >= 12 && this->user_room_no <= 14 && this->next_room_no > 15) {
                this->next_room_no = this->user_room_no - 1;
            }
            if (this->user_room_no == 16) {
                if (this->next_room_no <= 15) {
                    this->next_room_no = 11;
                } else {
                    this->next_room_no = 17;
                }
            }
            if (this->user_room_no > 16 && this->user_room_no > this->next_room_no) {
                this->next_room_no = this->user_room_no - 1;
            }
            if (this->user_room_no == 11) {
                if (this->next_room_no <= 10) {
                    this->next_room_no = 10;
                } else if (this->next_room_no > 11 && this->next_room_no <= 15) {
                    this->next_room_no = 12;
                } else {
                    this->next_room_no = 16;
                }
            }
        }
        if (this->dng_no == 3) {
            if (this->user_room_no > 10 && this->user_room_no <= 13 && this->next_room_no > 15) {
                this->next_room_no = this->user_room_no - 1;
            }
            if (this->user_room_no == 10 && this->next_room_no > 10 && this->next_room_no <= 14) {
                this->next_room_no = 11;
            }
            if (this->user_room_no == 15) {
                if (this->next_room_no <= 14) {
                    this->next_room_no = 10;
                } else {
                    this->next_room_no = 16;
                }
            }
            if (this->user_room_no > 15 && this->user_room_no > this->next_room_no) {
                this->next_room_no = this->user_room_no - 1;
            }
        }
        if (this->dng_no == 4) {
            if (this->user_room_no == 4 && this->next_room_no > 4 && this->next_room_no <= 8) {
                this->next_room_no = 5;
            }
            if (this->user_room_no > 4 && this->user_room_no <= 7 && this->next_room_no > 8) {
                this->next_room_no = this->user_room_no - 1;
            }
            if (this->user_room_no == 9) {
                if (this->next_room_no <= 8) {
                    this->next_room_no = 4;
                } else {
                    this->next_room_no = 10;
                }
            }
            if (this->user_room_no > 9 && this->user_room_no > this->next_room_no) {
                this->next_room_no = this->user_room_no - 1;
            }
        }
        if (this->dng_no == 5) {
            if (this->user_room_no == 4 && this->next_room_no > 4 && this->next_room_no <= 11) {
                this->next_room_no = 5;
            }
            if (this->user_room_no > 4 && this->user_room_no <= 10 && this->next_room_no > 11) {
                this->next_room_no = this->user_room_no - 1;
            }
            if (this->user_room_no == 12) {
                if (this->next_room_no <= 11) {
                    this->next_room_no = 4;
                } else {
                    this->next_room_no = 13;
                }
            }
            if (this->user_room_no > 12 && this->user_room_no > this->next_room_no) {
                this->next_room_no = this->user_room_no - 1;
            }
        }
        if (this->dng_no == 6) {
            if (this->user_room_no > 7 && this->user_room_no <= 10 && this->next_room_no > 10) {
                this->next_room_no = this->user_room_no - 1;
            }
            if (this->user_room_no > 12 && this->user_room_no <= 16 && this->next_room_no > 16) {
                this->next_room_no = this->user_room_no - 1;
            }
            if (this->user_room_no > 19 && this->user_room_no <= 20 && this->next_room_no > 21) {
                this->next_room_no = this->user_room_no - 1;
            }
            if (this->user_room_no > 23 && this->user_room_no <= 26 && this->next_room_no > 26) {
                this->next_room_no = this->user_room_no - 1;
            }
            if (this->user_room_no >= 29 && this->user_room_no <= 32) {
                if (this->user_room_no > this->next_room_no) {
                    this->next_room_no = this->user_room_no - 1;
                } else {
                    this->next_room_no = this->user_room_no + 1;
                }
            }
            if (this->user_room_no == 6) {
                if (this->next_room_no <= 5) {
                    this->next_room_no = 5;
                } else if (this->next_room_no >= 11) {
                    this->next_room_no = 11;
                } else {
                    this->next_room_no = 7;
                }
            }
            if (this->user_room_no == 11) {
                if (this->next_room_no <= 10) {
                    this->next_room_no = 6;
                } else if (this->next_room_no >= 17) {
                    this->next_room_no = 17;
                } else {
                    this->next_room_no = 12;
                }
            }
            if (this->user_room_no == 18) {
                if (this->next_room_no <= 17) {
                    this->next_room_no = 17;
                } else if (this->next_room_no >= 22) {
                    this->next_room_no = 22;
                } else {
                    this->next_room_no = 19;
                }
            }
            if (this->user_room_no == 22) {
                if (this->next_room_no <= 21) {
                    this->next_room_no = 18;
                } else if (this->next_room_no >= 27) {
                    this->next_room_no = 27;
                } else {
                    this->next_room_no = 23;
                }
            }
            if (this->user_room_no == 28) {
                if (this->next_room_no <= 27) {
                    this->next_room_no = 27;
                } else if (this->next_room_no >= 34) {
                    this->next_room_no = 34;
                } else {
                    this->next_room_no = 29;
                }
            }
            if (this->user_room_no == 35) {
                if (this->next_room_no == 34) {
                    this->next_room_no = 34;
                } else if (this->next_room_no >= 36) {
                    this->next_room_no = 36;
                } else {
                    this->next_room_no = 33;
                }
            }
        }
        GLID_INFO *to_glid = GetRoomGlid(this->next_room_no);
        if (to_glid == NULL) {
            return 0;
        }
        if (from_glid != NULL && to_glid != NULL && abs(from_glid->room.order - to_glid->room.order) > 1) {
            int link_floor[4];
            GLID_INFO *link_glid[4];
            u8 descend = 1;
            if (to_glid->room.order > from_glid->room.order) {
                descend = 0;
            }
            int link_num = 0;
            int max_floor = -1;
            for (int i = 0; i < 4; i++) {
                s16 *link = &from_glid->room.link[i];
                if (*link >= 0) {
                    GLID_INFO *glid = GetRoomGlid(*link);
                    if (glid != NULL && ((descend == 1 && glid->room.order < from_glid->room.order) ||
                                         (descend == 0 && glid->room.order > from_glid->room.order))) {
                        int floor = *link;
                        link_glid[link_num] = glid;
                        link_floor[link_num] = floor;
                        if (floor > max_floor) {
                            max_floor = floor;
                        }
                        link_num++;
                    }
                }
            }
            int to_floor = to_glid->room.floor_id;
            for (int i = 0; i < link_num; i++) {
                if (descend == 1 ||
                    (descend == 0 && ((max_floor > to_floor && abs(to_floor - link_floor[i]) <= 0) ||
                                      (to_floor > max_floor && abs(to_floor - link_floor[i]) > 0)))) {
                    to_glid = link_glid[i];
                    this->next_room_no = link_floor[i];
                    break;
                }
            }
        }
        koma_path = (DNGMAP_KOMA_POS *)work.Alloc(1);
        koma_now = koma_path;
        koma_now->next = NULL;
        DNGMAP_KOMA_POS *tail = koma_now;
        CalcGlidPutPos(to_glid, room_x, room_y, 0);
        tail->x = room_x;
        tail->y = room_y;
        for (int i = 0; i < 4; i++) {
            if (to_glid == NULL) {
                break;
            }
            if (to_glid->room.link[i] == this->user_room_no) {
                direction = i;
                break;
            }
        }
        if (direction < 0) {
            return work.stGetUsed();
        }
        int room_table = old_hokantbl_useno_2247[0][direction];
        s16(*room_points)[2] = RoomHokanTablePtrTable_2245[room_table];
        s8 room_reverse = is_reverse_tbl_room_2248[0][room_table];
        if (room_reverse == 0) {
            for (int i = 0; i < 10; i++) {
                DNGMAP_KOMA_POS *pos = (DNGMAP_KOMA_POS *)work.Alloc(1);
                pos->x = room_x + (float)room_points[i][0];
                pos->y = room_y + (float)room_points[i][1];
                tail->next = pos;
                tail = pos;
            }
        } else if (room_reverse == 1) {
            for (int i = 9; i >= 0; i--) {
                DNGMAP_KOMA_POS *pos = (DNGMAP_KOMA_POS *)work.Alloc(1);
                pos->x = room_x + (float)room_points[i][0];
                pos->y = room_y + (float)room_points[i][1];
                tail->next = pos;
                tail = pos;
            }
        }
        GLID_INFO *glid = to_glid->link_glid[direction];
        while (glid != NULL) {
            CalcGlidPutPos(glid, glid_x, glid_y, 0);
            glid->blink = 1;
            if (glid->type == 0) {
                s16(*points)[2] = RootHokanTablePtrTable_2240[glid->root.shape];
                s8 reverse = is_reverse_tbl_2246[glid->root.shape][direction];
                if (reverse < 0) {
                    break;
                }
                if (reverse == 0) {
                    for (i = 0; i < 20; i++) {
                        DNGMAP_KOMA_POS *pos = (DNGMAP_KOMA_POS *)work.Alloc(1);
                        pos->x = glid_x + (float)points[i][0];
                        pos->y = glid_y + (float)points[i][1];
                        tail->next = pos;
                        tail = tail->next;
                    }
                } else if (reverse == 1) {
                    for (i = 19; i >= 0; i--) {
                        DNGMAP_KOMA_POS *pos = (DNGMAP_KOMA_POS *)work.Alloc(1);
                        pos->x = glid_x + (float)points[i][0];
                        pos->y = glid_y + (float)points[i][1];
                        tail->next = pos;
                        tail = pos;
                    }
                }
            } else if (glid->type == 1) {
                int table = old_hokantbl_useno_2247[1][direction];
                s16(*points)[2] = RoomHokanTablePtrTable_2245[table];
                s8 reverse = is_reverse_tbl_room_2248[1][table];
                if (reverse == 0) {
                    for (i = 0; i < 10; i++) {
                        DNGMAP_KOMA_POS *pos = (DNGMAP_KOMA_POS *)work.Alloc(1);
                        pos->x = glid_x + (float)points[i][0];
                        pos->y = glid_y + (float)points[i][1];
                        tail->next = pos;
                        tail = pos;
                    }
                } else if (reverse == 1) {
                    for (i = 9; i >= 0; i--) {
                        DNGMAP_KOMA_POS *pos = (DNGMAP_KOMA_POS *)work.Alloc(1);
                        pos->x = glid_x + (float)points[i][0];
                        pos->y = glid_y + (float)points[i][1];
                        tail->next = pos;
                        tail = pos;
                    }
                }
            }
            if (glid == from_glid) {
                break;
            }
            glid = GetNextGlid(glid, &direction);
            if (glid == NULL) {
                break;
            }
        }
        tail->next = NULL;
        DNGMAP_KOMA_POS *first = koma_now->next;
        if (first != NULL) {
            dng_player_pos[0] = first->x;
            dng_player_pos[1] = first->y;
        }
    }
    return work.stGetUsed();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", LoadDngInfo__11CDngFreeMapFP9mgCMemoryiiii);
#endif
int CheckDngTreeMapFuncType() {
    if (MenuCommonInfo->open_type == 3) {
        return 2;
    }
    if (MenuCommonInfo->open_type == 1 || TreeMapCallDungeonSubMap == 1) {
        return 1;
    }
    return 0;
}
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
void CMenuTreeMap::InitEnd() {
    float pos[2];
    int data_size;
    char name[0x20];
    u_long128 buffer[0xA00];
    char path[0x40];
    BG_READ_INFO *file = GetReadBGFile(0);
    sprintf(name, at_2681, dng_no);
    u_char *img = (u_char *)GetPackFile((u_int *)file->buffer, name, NULL);
    int block = tex_block[0];
    mgCTextureManager *textures = &mgTexManager;
    MenuWorkTextureEnter(block, at_2786, 0x200, 0x100, 0x18);
    textures->EnterIMGFile(img, block, NULL, NULL);
    if (CheckDngTreeMapFuncType() == 2) {
        textures->EnterIMGFile(MenuCursorDataBuff, block, NULL, NULL);
    }
    MenuDngMap->SetTextureInfo();
    Floor_InfoTex = textures->GetTexture(at_2787__2, -1);
    if (file != NULL) {
        script = (char *)GetPackFile((u_int *)file->buffer, at_2788, &script_size);
        MenuDngMap->floor_manager->CheckDrawGlidInfo();
        int floor = MenuSaveDataDungeonPtr->floor_id[dng_no];
        if (floor <= 0) {
            floor = 1;
        }
        if (maxidtable_2752[dng_no] < floor) {
            floor = 1;
        }
        MenuDngMap->SetUserGlid(floor);
        select_glid = MenuDngMap->GetRoomGlid(floor);
        if (select_glid == NULL) {
            select_glid = MenuDngMap->GetRoomGlid(floor + 1);
        }
        int view_floor = floor;
        GLID_INFO *mark_glid = NULL;
        int max_id = maxidtable_2752[dng_no];
        for (int id = 0; id < max_id; id++) {
            GLID_INFO *glid = MenuDngMap->floor_manager->GetDngMapFloorGlidInfo(id);
            if (glid != NULL && glid->room.mark != 0) {
                view_floor = glid->room.floor_id;
                mark_glid = glid;
                break;
            }
        }
        GLID_INFO *select = select_glid;
        if (select != NULL && ((select->room.flag & 0x10) || (select->room.flag & 8))) {
            mark_glid = select;
            view_floor = floor;
        }
        if (mark_glid != NULL) {
            select_glid = mark_glid;
        }
        MenuDngMap->ResetDngMapPos(view_floor, 1);
        MenuDngMap->CalcGlidPutPos(mark_glid, pos[0], pos[1], 0);
        pos[0] -= 30.0f;
        pos[0] -= 20.0f;
        cursor_pos[0] = pos[0];
        cursor_pos[1] = pos[1];
        FadeInMenu(0x28, 0.0f);
        mes_data = (short *)GetPackFile((u_int *)file->buffer, at_2789, NULL);
        MsgInit();
        u_long128 *data = MenuCalcBufAlignment(buffer);
        sprintf(path, at_2790, dng_no + 1);
        if (LoadFile2(path, data, &data_size, 0) != 0) {
            CreatTresuarBoxInfo(&tresure, (char *)data, data_size);
            tresure_loaded = 1;
        }
    }
    DngInfoDrawAlpha = 0;
    MenuCommonInfo->key_enable = 1;
    cursor_view = 1;
    mode = 0;
    key_arg_no = 0;
}
#ifdef NONMATCHING
void CMenuTreeMap::MsgInit() {
    for (int i = 0; i < DNG_TREE_MAP_MES_MAX; i++) {
        mes[i].SetMessData(mes_data, mes_data);
        mes[i].MsgPreset(15);
        mes[i].fuchi = 5;
        mes[i].value_zero = 1;
    }
    MenuCommandAnalyzeInfo.mes_buff[0] = mes_data;
    MenuCommandAnalyzeInfo.mes_buff[1] = GetMenuMainMessageBuffer();
    MenuCommandAnalyzeInfo.system_mes_buff[0] = mes_data;
    MenuCommandAnalyzeInfo.system_mes_buff[1] = GetSystemMesBuffer();
    ExeScript(at_2826);
    CDC2Mes *help = MenuDCMsg[6];
    help->SetDrawSize(16, 20);
    help->ClsMes::mes_no = -1;
    help->MakeMsg(300);
    if (CheckDngTreeMapFuncType() == 2) {
        help->MakeMsg(0x51);
    } else if (CheckDngTreeMapFuncType() == 1) {
        help->MakeMsg(0x50);
    }
    help->StepMsg();
    int help_y = mgScreenHeight - 50;
    help->SetMovePosGyou(0, (mgScreenWidth >> 2) - (help->line_w[0] >> 1), help_y);
    help->SetMovePosGyou(1, (mgScreenWidth >> 2) * 3 - (help->line_w[1] >> 1), help_y);
    TreeMapSaveDispY = help_y;
    if (TreeMapSaveFlag == 0) {
        help->SetMovePosGyou(1, 600, help_y);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", MsgInit__12CMenuTreeMapFv);
#endif
#ifdef NONMATCHING
int CMenuTreeMap::Step() {
    int result = DNG_TREE_MAP_CONTINUE;
    CMenuKeyFunc *key = MenuCommonInfo;
    if (init_2831 == 0) {
        old_direction_2830 = -1;
        init_2831 = 1;
    }
    if (init_2834 == 0) {
        old_glid_2833 = NULL;
        init_2834 = 1;
    }
    CDC2Mes *ask = MenuDCMsg[3];
    int fade_done = FadeInOutMenu();
    MenuDngMap->Step();
    int reading = ReadBGSync();
    int info_changed = 0;
    if (init_2837 == 0) {
        NextFloorGlid_2836 = NULL;
        init_2837 = 1;
    }
    switch (mode) {
    case 1:
        if (fade_done != 0 && reading == 0) {
            InitEnd();
            info_changed = 1;
            cursor_reset = 1;
            old_direction_2830 = -1;
            old_glid_2833 = NULL;
        }
        break;
    case 2:
        if (fade_done != 0) {
            DeleteTexBlock();
            ExeScript(at_3342);
            result = DNG_TREE_MAP_CLOSE;
            if (MenuArg.end_code == 5) {
                result = DNG_TREE_MAP_JUMP;
                if (TreeMapCallDungeonSubMap != 0) {
                    MenuArg.end_code = 6;
                    MenuArg.result[0] = 1;
                    MakeDngTreeMapJumpNo(dng_no, MenuArg.result[2], &MenuArg.result[0], &MenuArg.result[1]);
                    GetSaveData()->ResetBitCtrl(0x10);
                    if (MenuArg.result[2] == 0) {
                        GetSaveData()->save_dungeon.SetFloorID(0);
                    }
                }
                if (CheckDngTreeMapFuncType() == 0 && MenuArg.result[0] == 2) {
                    MenuMainScene->skip_load_bgm = 1;
                }
                CheckDngTreeMapFuncType();
                DNG_BATTLE_AREA *area = (DNG_BATTLE_AREA *)menu_GetBattleAreaScene();
                if (area != NULL) {
                    area->floor_status &= 0xFFF8;
                }
            }
            old_glid_2833 = NULL;
            old_direction_2830 = -1;
        }
        break;
    case 12:
        if (step == 0 && FadeCheckMenu() != 0) {
            DngTreeMode = DNG_TREE_MODE_SAVE;
        }
        if (step == 1 && FadeCheckMenu() != 0) {
            mode = 0;
        }
        break;
    default: {
        key->SelDataInit();
        key->CheckSelectKey();
        int lr = key->CheckLRKey();
        int push = key->CheckPushButton();
        int action = -1;
        switch (key_arg_no) {
        case 0: {
            if (menu_debug_flag != 0) {
                DNG_FLOOR_SAVE *record = MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, select_glid->room.floor_id);
                if (lr & 1) {
                    MenuDngDebugFlagSelect--;
                }
                if (lr & 2) {
                    MenuDngDebugFlagSelect++;
                }
                if (MenuDngDebugFlagSelect < 0) {
                    MenuDngDebugFlagSelect = 0;
                }
                if (MenuDngDebugFlagSelect > 8) {
                    MenuDngDebugFlagSelect = 8;
                }
                if (MenuDngDebugFlagSelect == 0) {
                    if ((push & 1) || (lr & 8)) {
                        if (record != NULL && record->visit_count < 30000) {
                            record->visit_count++;
                        }
                    }
                    if (((push & 2) || (lr & 4)) && record != NULL && 0 < record->visit_count) {
                        record->visit_count--;
                    }
                }
                if (MenuDngDebugFlagSelect != 0) {
                    if ((push & 1) || (lr & 8)) {
                        record->flag |= bitTable_2900[MenuDngDebugFlagSelect];
                    }
                    if ((push & 2) || (lr & 4)) {
                        record->flag &= ~bitTable_2900[MenuDngDebugFlagSelect];
                    }
                }
                if (push & 4) {
                    for (int floor = 0;; floor++) {
                        DNG_FLOOR_SAVE *each = MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, floor);
                        if (each == NULL) {
                            break;
                        }
                        if (each->visit_count < 30000) {
                            each->visit_count++;
                        }
                        each->flag = 0x1FB;
                    }
                }
                if ((push & 1) || (push & 2) || (push & 4) || (lr & 4) || (lr & 8)) {
                    MenuDngMap->floor_manager->CheckDrawGlidInfo();
                }
                if (lr & 0x20) {
                    MenuActiveSaveData->SetBitFlag(0xDC, 1);
                    MenuActiveSaveData->SetBitFlag(0x13D, 1);
                }
                return 0;
            }
            GLID_INFO *next = NULL;
            int direction = -1;
            if (lr & 1) {
                direction = 0;
            } else if (lr & 2) {
                direction = 1;
            } else if (lr & 4) {
                direction = 2;
            } else if (lr & 8) {
                direction = 3;
            }
            if (0 <= direction) {
                next = MenuDngMap->floor_manager->GetKeyNextRoom(select_glid->room.floor_id, direction, old_glid_2833);
            }
            if (next != NULL && next != select_glid && (s8)next->room.unk_44 == 1) {
                MenuSePlay(0);
                old_glid_2833 = select_glid;
                old_direction_2830 = -1;
                select_glid = next;
                MenuDngMap->SetNextRoomPos(select_glid);
                DngTreeMapActiveLightRate = 0.0f;
                info_changed = 1;
            }
            MenuDngMap->select_glid = select_glid;
            switch (push) {
            case 1: {
                action = 100;
                NextFloorGlid_2836 = MenuDngMap->GetEntranceRoomGlid();
                if (select_glid != NULL) {
                    NextFloorGlid_2836 = select_glid;
                }
                GLID_INFO *target = NextFloorGlid_2836;
                int map_no = MenuMainScene->now_map_no;
                if (target == MenuDngMap->GetEntranceRoomGlid()) {
                    if ((0 <= map_no && map_no <= 10 &&
                         (GetMapType(MenuMainScene->now_sub_map_no) == 2 || GetMapType(MenuMainScene->now_sub_map_no) == 4 ||
                          GetMapType(MenuMainScene->now_sub_map_no) == 6)) ||
                        (map_no == 1 && MenuMainScene->now_sub_map_no == 100)) {
                        action = 200;
                    }
                }
                break;
            }
            case 2:
                if (CheckDngTreeMapFuncType() == 2) {
                    action = 100;
                    NextFloorGlid_2836 = MenuDngMap->GetEntranceRoomGlid();
                } else {
                    action = 200;
                }
                break;
            case 8:
                if (CheckDngTreeMapFuncType() != 0) {
                    action = 100;
                    NextFloorGlid_2836 = MenuDngMap->GetEntranceRoomGlid();
                } else {
                    action = 200;
                }
                break;
            case 4:
                if (TreeMapSaveFlag != 0) {
                    FadeOutMenu(0x28, 0.0f);
                    mode = 12;
                    step = 0;
                    MenuSePlay(1);
                } else {
                    MenuSePlay(5);
                }
                break;
            }
            break;
        }
        case 1:
            if (DngAskMessageDrawFlag == 0) {
                if (push != 0) {
                    action = 120;
                }
            } else if (dngfloor_infoview != 0) {
                if (push & 1) {
                    action = 110;
                    if (CheckDngTreeMapFuncType() == 1) {
                        action = -1;
                    }
                } else if (push & 2) {
                    action = 120;
                } else if ((push & 4) && 0 < GeoramaMateriaNum) {
                    action = 130;
                }
            } else {
                int answer = ask->YesNoCursor();
                if (push & 1) {
                    switch (answer) {
                    case 0:
                        action = 110;
                        break;
                    case 1:
                        action = 120;
                        break;
                    }
                } else if (push & 2) {
                    action = 120;
                }
            }
            break;
        case 2:
            if ((push & 4) || (push & 2)) {
                action = 131;
                MenuSePlay(1);
            }
            break;
        }
        DNG_FLOOR_SAVE *next_record = NULL;
        if (NextFloorGlid_2836 != NULL) {
            next_record = MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, NextFloorGlid_2836->room.floor_id);
        }
        switch (action) {
        case 100: {
            if (NextFloorGlid_2836 == NULL) {
                MenuSePlay(5);
                break;
            }
            if (next_record != NULL && !(next_record->flag & DNG_FLOOR_FLAG_OPEN)) {
                MenuSePlay(5);
                break;
            }
            if (CheckDngTreeMapFuncType() == 0 && TreeMapCallDungeonSubMap == 1) {
                int loop_no;
                int map_no;
                MakeDngTreeMapJumpNo(dng_no, NextFloorGlid_2836->room.floor_id, &loop_no, &map_no);
                if (MenuMainScene->now_map_no == map_no) {
                    MenuSePlay(5);
                    break;
                }
            }
            info_changed = 1;
            DngAskMessageDrawFlag = 1;
            if (CheckDngTreeMapFuncType() == 1 && !(NextFloorGlid_2836->room.flag & 2)) {
                DngAskMessageDrawFlag = 2;
            }
            if ((DngAskMessageDrawFlag == 0 || DngAskMessageDrawFlag == 2) &&
                ((NextFloorGlid_2836->room.flag & 0x10) || (NextFloorGlid_2836->room.flag & 8) || (NextFloorGlid_2836->room.flag & 4))) {
                MenuSePlay(5);
                ask->SetAbsPos(5);
                break;
            }
            MenuSePlay(0x13);
            DngInfoFloorInfo = next_record;
            dngfloor_infoview = 1;
            int mes_no = 0x3C;
            dngfloor_backdraw = 1;
            DngInfoRoomInfo = &NextFloorGlid_2836->room;
            GetSaveData()->GetBitCtrl();
            DNG_BATTLE_AREA *area = (DNG_BATTLE_AREA *)menu_GetBattleAreaScene();
            int busy = area->unk_5c;
            jump_pay = 0;
            if (busy == 0 && MenuCommonInfo->open_type == 1) {
                jump_pay = 1;
            }
            if (TreeMapCallDungeonSubMap != 0) {
                jump_pay = 0;
            }
            GLID_INFO *target = NextFloorGlid_2836;
            if ((target->room.flag & 2) || (target->room.flag & 0x10) || (target->room.flag & 4) || (target->room.flag & 8)) {
                mes_no = 0x3D;
                int floor_item[1] = {target->room.floor_id + (dng_no + 1) * 1000};
                ask->SetMsgItemNo(floor_item, 1);
            }
            if (jump_pay != 0) {
                mes_no += 2;
            }
            ask->SetAbsPos(-1);
            int put_pos[2] = {0x3C, 0x118};
            ask->SetPutPos(put_pos);
            ask->ClsMes::mes_no = -1;
            ask->SetMsgCursor(0);
            ask->fade = 0.0f;
            ask->fade_speed = 0.1f;
            ask->line_pos_on[0] = 0;
            ask->line_pos_on[1] = 0;
            ask->line_pos_on[2] = 0;
            if ((NextFloorGlid_2836->room.flag & 4) || (NextFloorGlid_2836->room.flag & 2) || (NextFloorGlid_2836->room.flag & 0x10) ||
                (NextFloorGlid_2836->room.flag & 8)) {
                ask->abs_win.x = -1;
                ask->abs_win.y = -1;
                ask->SetAbsPos(5);
                dngfloor_infoview = 0;
            }
            ask->window_mode = 5;
            ask->fuchi = 5;
            ask->font_w = 0xF;
            ask->SetMsgCursor(1);
            ask->MakeMsg(mes_no);
            money_view = 0;
            if (jump_pay != 0) {
                money_view = 1;
            }
            GeoramaMateriaNum = 0;
            if (dngfloor_infoview == 1) {
                ask->window_mode = 0;
                ask->fuchi = 8;
                if (LanguageCode > 0) {
                    ask->font_w = 0x11;
                }
                ask->fade_speed = 1.0f;
                ask->fade = 1.0f;
                ask->select_top = -1;
                ask->SetMsgCursor(-1);
                GeoramaMateriaNum = CheckGeoramaMateria(&tresure, select_glid->room.floor_id, georama_materia);
                if (!(next_record->flag & 2)) {
                    GeoramaMateriaNum = 0;
                }
                if (GeoramaMateriaNum <= 0) {
                    ask->SetMovePosGyou(0, 0x46, mgScreenHeight - 0x32);
                    ask->SetMovePosGyou(1, 0x14A, mgScreenHeight - 0x32);
                    ask->MakeMsg(0x40);
                } else {
                    ask->MakeMsg(0x41);
                    ask->SetMovePosGyou(0, 0x46, mgScreenHeight - 0x46);
                    ask->SetMovePosGyou(1, 0x14A, mgScreenHeight - 0x32);
                    ask->SetMovePosGyou(2, 0x46, mgScreenHeight - 0x2C);
                    if (LanguageCode == 4 || LanguageCode == 5) {
                        ask->SetMovePosGyou(0, 0x2E, mgScreenHeight - 0x46);
                        ask->SetMovePosGyou(1, 0x160, mgScreenHeight - 0x32);
                        ask->SetMovePosGyou(2, 0x2E, mgScreenHeight - 0x2C);
                    }
                    if (CheckDngTreeMapFuncType() == 1) {
                        ask->SetMovePosGyou(0, 0x208, mgScreenHeight - 0x46);
                        ask->SetMovePosGyou(1, 0x208, mgScreenHeight - 0x32);
                    }
                }
                money_view = 0;
            }
            cursor_view = 0;
            key_arg_no = 1;
            break;
        }
        case 110: {
            MenuSePlay(1);
            if (jump_pay != 0) {
                MenuUserDataManPtr->AddMoney(-MenuUserDataManPtr->money / 2);
            }
            MenuArg.result[1] = 0;
            MenuArg.end_code = 5;
            MenuArg.result[0] = 1;
            if (MenuDngMap->user_glid != NULL) {
                MenuSaveDataDungeonPtr->stage_id = dng_no;
                MenuArg.result[1] = MenuSaveDataDungeonPtr->prev_floor_id[MenuSaveDataDungeonPtr->stage_id];
            }
            MenuArg.result[2] = NextFloorGlid_2836->room.floor_id;
            int skip_bgm = 0;
            if ((NextFloorGlid_2836->room.flag & 0x10) || (NextFloorGlid_2836->room.flag & 8)) {
                if (CMenuTreePt->dng_no == 1 && NextFloorGlid_2836->room.floor_id == 6) {
                    MenuMainScene->skip_play_bgm = 1;
                } else {
                    skip_bgm = 1;
                }
                MenuSaveDataDungeonPtr->SetFloorID(MenuArg.result[2]);
            }
            if (CMenuTreePt->dng_no == 0) {
                if (MenuArg.result[2] == 3 && CheckBitFlagMenu(0x66) == 0) {
                    skip_bgm = 1;
                }
                if (MenuArg.result[2] == 8 && CheckBitFlagMenu(0xC9) == 0) {
                    skip_bgm = 1;
                }
                if (MenuArg.result[2] == 6) {
                    skip_bgm = 1;
                }
            }
            if (CMenuTreePt->dng_no == 1) {
                if (MenuArg.result[2] == 2 && CheckBitFlagMenu(0xD4) == 0) {
                    skip_bgm = 1;
                }
                if (MenuArg.result[2] == 14) {
                    skip_bgm = 1;
                }
            }
            if (CMenuTreePt->dng_no == 2) {
                if (MenuArg.result[2] == 2 && CheckBitFlagMenu(0x133) == 0) {
                    skip_bgm = 1;
                }
                if (MenuArg.result[2] == 21 && CheckBitFlagMenu(0x158) == 0) {
                    skip_bgm = 1;
                }
                if (MenuArg.result[2] == 22) {
                    skip_bgm = 1;
                }
            }
            if (CMenuTreePt->dng_no == 3) {
                if (MenuArg.result[2] == 2 && CheckBitFlagMenu(0x196) == 0) {
                    skip_bgm = 1;
                }
                if (MenuArg.result[2] == 17 && CheckBitFlagMenu(0x1A8) == 0) {
                    skip_bgm = 1;
                }
                if (MenuArg.result[2] == 19) {
                    skip_bgm = 1;
                }
            }
            int tree_dng_no = CMenuTreePt->dng_no;
            if (tree_dng_no == 4 && MenuArg.result[2] == 21) {
                skip_bgm = 1;
            }
            if (tree_dng_no == 5 && MenuArg.result[2] == 26) {
                skip_bgm = 1;
            }
            if (tree_dng_no == 6 && MenuArg.result[2] == 37) {
                skip_bgm = 1;
            }
            if (skip_bgm != 0) {
                MenuMainScene->skip_load_bgm = 1;
            }
            unk_11a = 0;
            mode = 2;
            FadeOutMenu(0x28, 0.0f);
            break;
        }
        case 130:
            dngfloor_infoview = 0;
            dngfloor_backdraw = 1;
            GeoramaMateriaInfoDrawFlag = 1;
            GeoramaMateriaInfoDrawPage = 0;
            DngInfoDrawAlpha = 0;
            MenuSePlay(1);
            key_arg_no = 2;
            break;
        case 131:
            if (GeoramaMateriaNum > 14 && GeoramaMateriaInfoDrawPage == 0) {
                GeoramaMateriaInfoDrawPage++;
            } else {
                DngInfoDrawAlpha = 0x80;
                key_arg_no = 1;
                dngfloor_infoview = 1;
                GeoramaMateriaInfoDrawFlag = 0;
            }
            break;
        case 120:
            MenuSePlay(5);
            key_arg_no = 0;
            dngfloor_infoview = 0;
            dngfloor_backdraw = 0;
            cursor_view = 1;
            money_view = 0;
            break;
        case 200:
            MenuSePlay(5);
            FadeOutMenu(0x28, 0.0f);
            unk_11a = 0;
            mode = 2;
            cursor_view = 0;
            break;
        }
        break;
    }
    }
    if (select_glid != NULL && select_glid->type == kGlidRoom) {
        DngInfoFloorInfo = MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, select_glid->room.floor_id);
        if (info_changed != 0) {
            GLID_INFO *glid = select_glid;
            int mes_no[DNG_TREE_MAP_MES_MAX] = {glid->room.floor_id + (dng_no + 1) * 1000, 0x96, 0x97, 0x98, 0x99, glid->room.practice_type + 100,
                                                0x9B, 0x46};
            int practice_item[4] = {0};
            DNGMAP_ROOM_INFO *room = &glid->room;
            if (glid->room.practice_type == 0) {
                int seconds = room->practice_param / 60;
                int time[2] = {seconds / 60, seconds % 60};
                if (time[1] == 0) {
                    mes_no[5] = 0x5A;
                } else {
                    mes_no[5] = 0x5B;
                }
                mes[5].SetMsgVolumeNo(time, 2);
            }
            if (room->practice_type == 1 || room->practice_type == 2 || room->practice_type == 3 || room->practice_type == 4) {
                mes_no[5] = room->practice_param + 0x65;
            }
            if (room->practice_type == 5) {
                mes_no[5] = 0x6C;
            }
            if (room->fishing < 0) {
                mes_no[3] = 0x79;
            }
            if (0 < room->fishing) {
                mes_no[3] = 0x78;
            }
            mes[3].SetMsgVolumeNoOne(room->fishing_record);
            DngInfoFishOkFlag = CheckBitFlagMenu(0xDC) != 0;
            DngInfoSphidaOkFlag = CheckBitFlagMenu(0x13D) != 0;
            if (DngInfoFishOkFlag == 0) {
                mes_no[3] = 2;
            }
            if (DngInfoSphidaOkFlag == 0) {
                mes_no[4] = 2;
            }
            int spheda_item[1] = {0x29};
            if (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_SPHEDA_CLEAR) {
                spheda_item[0] = 0x28;
            }
            mes[4].SetMsgItemNo(spheda_item, 1);
            practice_item[0] = 0x29;
            if (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_PRACTICE_CLEAR) {
                practice_item[0] = 0x28;
            }
            mes[5].SetMsgItemNo(practice_item, 1);
            if (CheckNowEurope() != 0) {
                mes[6].value_half = 1;
            }
            mes[6].SetMsgVolumeNoOne(DngInfoFloorInfo->kill_count);
            int clear_seconds = room->fast_destroy_time / 60;
            if (DngInfoFloorInfo->fast_destroy_time != 0 && DngInfoFloorInfo->fast_destroy_time < room->fast_destroy_time) {
                clear_seconds = DngInfoFloorInfo->fast_destroy_time / 60;
            }
            if (!(DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_FAST_DESTROY_CLEAR)) {
                mes_no[1] = 0x9A;
            }
            int minutes = clear_seconds / 60;
            int rest_seconds = clear_seconds % 60;
            char time_text[0x40];
            if (minutes > 99) {
                strcpy(time_text, at_3343);
                if (CheckNowEurope() != 0) {
                    strcpy(time_text, at_3344);
                }
            } else if (CheckNowEurope() != 0) {
                if (minutes / 10 <= 0) {
                    if (rest_seconds / 10 <= 0) {
                        sprintf(time_text, at_3345, minutes, rest_seconds);
                    } else {
                        sprintf(time_text, at_3346, minutes, rest_seconds / 10, rest_seconds % 10);
                    }
                } else if (rest_seconds / 10 <= 0) {
                    sprintf(time_text, at_3347, minutes, rest_seconds);
                } else {
                    sprintf(time_text, at_3348, minutes, rest_seconds / 10, rest_seconds % 10);
                }
            } else {
                if (minutes / 10 <= 0) {
                    strcpy(time_text, at_3349);
                } else {
                    strcpy(time_text, GetMenuBigNum(minutes / 10));
                }
                strcat(time_text, GetMenuBigNum(minutes % 10));
                strcat(time_text, at_3350);
                if (rest_seconds / 10 <= 0) {
                    strcat(time_text, at_3349);
                } else {
                    strcat(time_text, GetMenuBigNum(rest_seconds / 10));
                }
                strcat(time_text, GetMenuBigNum(rest_seconds % 10));
            }
            char *time_item[1] = {time_text};
            mes[1].SetMsgItemNo(time_item, 1);
            mes_no[7] = 0x47;
            if (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_GEOSTONE_FOUND) {
                mes_no[7] = 0x46;
            }
            if (room->geostone == 0) {
                mes_no[7] = 2;
            }
            for (int i = 0; i < DNG_TREE_MAP_MES_MAX; i++) {
                mes[i].MakeMsg(mes_no[i]);
                mes[i].SetMovePosGyou(0, 600, 10);
                mes[i].SetMovePosGyou(1, 600, 10);
            }
        }
    }
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", Step__12CMenuTreeMapFv);
#endif
void CMenuTreeMap::Draw() {
    float target[2];
    if ((mode & 2) && unk_11a == 1) {
        return;
    }
    MenuDngMap->Draw();
    int help_on = 0;
    if (help_view != 0 && dngfloor_infoview == 0 && key_arg_no == 0) {
        help_on = 1;
    }
    if (menu_debug_flag != 0) {
        help_on = 0;
    }
    mgCTextureManager *textures = &mgTexManager;
    mgCDrawPrim *prim = GetMenuPrim();
    if (help_on != 0) {
        textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
        MenuDCMsg[6]->StepMsg();
        MenuDCMsg[6]->DrawMsg();
        if (TreeMapSaveFlag == 1) {
            TreeMapSaveDispCount++;
            if (TreeMapSaveDispCount >= 90) {
                TreeMapSaveDispCount = 0;
            }
            MenuDCMsg[6]->line_color[1] = 0x80E0E060;
            if (TreeMapSaveNum == 0) {
                if (TreeMapSaveHopCount < 0.6829549f || TreeMapSaveHopCount > 2.4586377f) {
                    MenuDCMsg[6]->line_color[1] = 0x80686A6B;
                }
                TreeMapSaveHopCount += 0.06829549f;
                if (3.1415927f <= TreeMapSaveHopCount) {
                    TreeMapSaveHopCount -= 3.1415927f;
                }
                int hop_y = fptosi((float)TreeMapSaveDispY - 10.0f * sinf(TreeMapSaveHopCount));
                MenuDCMsg[6]->SetMovePosGyou(1, MenuDCMsg[6]->line_pos[1][0], hop_y);
            }
        }
    }
    if (MenuDngMap->select_glid != NULL) {
        if (dngfloor_backdraw != 0) {
            int *alpha = &dngfloor_backdraw_alpha;
            CalcMenuAdd(alpha, 3, 0x40);
        } else {
            CalcMenuAdd(&dngfloor_backdraw_alpha, -3, 0);
        }
        DrawMenuFillBox(dngfloor_backdraw_alpha, 0, 0, 0);
        int medal_x = 0x21C;
        int medal_y = 0;
        int medal_alpha = 0;
        int medal = GetUserDataMan()->GetYarikomiMedal();
        if (Floor_InfoTex != NULL) {
            textures->ReloadTexture(Floor_InfoTex->block, (sceVif1Packet *)NULL);
            int board_alpha = dngfloor_backdraw_alpha * 2;
            SetSpriteEnv(prim, 0);
            prim->Begin(6);
            prim->Texture(Floor_InfoTex);
            prim->Color(0, 0, 0, board_alpha / 3);
            PrimQuad(prim, 289.0f, 25.0f, mgRect<int>(0, 0xB6, 0xA4, 0x38));
            prim->Color(0x80, 0x80, 0x80, board_alpha);
            PrimQuad(prim, 286.0f, 22.0f, mgRect<int>(0, 0xB6, 0xA4, 0x38));
            prim->End();
            medal_x = 0x19A - GetNumberKeta(medal) * 16;
            medal_y = 0x27;
            medal_alpha = dngfloor_backdraw_alpha * 2;
        }
        DrawDngRoomInfo(&MenuDngMap->select_glid->room);
        if (GeoramaMateriaInfoDrawFlag != 0 && Floor_InfoTex != NULL) {
            DrawGeoramaMateria(0x5E, MenuDngMap->select_glid->room.title, GeoramaMateriaNum, georama_materia,
                               Floor_InfoTex->block);
        }
        MenuDngMap->DrawDngName(0x80);
        textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
        CMenuFont font;
        char medal_text[0x20];
        font.alpha = medal_alpha;
        SetMenuBigNum(medal_text, medal);
        font.SetStr(medal_text);
        font.SetPos(medal_x, medal_y);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
        for (int i = 0; i < DNG_TREE_MAP_MES_MAX; i++) {
            MenuDngMes[i]->StepMsg();
            MenuDngMes[i]->DrawMsg();
        }
    }
    MenuDngMap->CalcGlidPutPos(select_glid, target[0], target[1], 0);
    target[0] -= 58.0f;
    target[1] -= 8.0f;
    cursor_pos[0] += (target[0] - cursor_pos[0]) / 4.0f;
    cursor_pos[1] += (target[1] - cursor_pos[1]) / 4.0f;
    if (cursor_reset != 0) {
        cursor_pos[0] = target[0];
        cursor_pos[1] = target[1];
        cursor_reset = 0;
    }
    int cursor_alpha;
    if (mode == 1) {
        cursor_alpha = 0;
    } else if (mode == 2) {
        cursor_alpha = 0;
    } else {
        cursor_alpha = 0x80;
    }
    if (cursor_view != 0) {
        mgCTexture *cursor_tex = textures->GetTexture(at_3451, -1);
        if (cursor_tex == NULL) {
            return;
        }
        textures->ReloadTexture(cursor_tex->block, (sceVif1Packet *)NULL);
        MenuCursorDraw(cursor_tex, cursor_pos, 0.0f, cursor_alpha);
    }
    if (money_view != 0 && Floor_InfoTex != NULL) {
        textures->ReloadTexture(Floor_InfoTex->block, (sceVif1Packet *)NULL);
        SetSpriteEnv(prim, 0);
        int money_y = mgScreenHeight - 0x4C;
        prim->Begin(6);
        prim->Texture(Floor_InfoTex);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        PrimQuad(prim, 302.0f, (float)money_y, mgRect<int>(0, 0x90, 0xB8, 0x24));
        mgRect<int> digit_rect(0, 0x7E, 0xC, 0x12);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        PrimDrawNumber(prim, GetUserDataMan()->money, 0, 0x1AA, money_y + 7, digit_rect, -1, 0);
        prim->End();
    }
    textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
    if (key_arg_no == 1 && DngAskMessageDrawFlag == 1) {
        MenuDCMsg[3]->StepMsg();
        MenuDCMsg[3]->DrawMsg();
    }
}
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
inline CMenuTreeMap::CMenuTreeMap() {
    unk_11a = 0;
    select_glid = NULL;
    mes_data = NULL;
    key_arg_no = 0;
    help_view = 1;
    cursor_reset = 0;
    money_view = 0;
    tresure_loaded = 0;
    for (int i = 0; i < DNG_TREE_MAP_MES_MAX; i++) {
        MenuDngMes[i] = &mes[i];
        Init__6ClsMesFv(MenuDngMes[i]);
        MenuDngMes[i]->SetBuff_system(GetSystemMesBuffer());
    }
    MenuDngMes[1]->value_space = 0x10;
}
void DngTreeMapInit(mgCMemory *stack, int *tex_block, int menu_mode, int dng_no) {
    char name[0x28];
    int rest = stack->stGetRest();
    u_long128 *top = stack->stGetTop();
    MenuTreeMapStack.stSetBuffer(top, rest);
    MenuTreeMapStack.Align64();
    CMenuTreePt = new (MenuTreeMapStack.Alloc(0x2FC0)) CMenuTreeMap;
    CMenuTreePt->SetTexBlock(tex_block);
    MenuDngMap = new (MenuTreeMapStack.Alloc(0x13)) CDngFreeMap;
    MenuDngMap->save_dungeon = MenuSaveDataDungeonPtr;
    MenuDngMap->floor_manager = &((DNG_BATTLE_AREA *)menu_GetBattleAreaScene())->floor_manager;
    DngTreeMode = DNG_TREE_MODE_MAP;
    DngInfoRoomInfo = NULL;
    dngfloor_backdraw_alpha = 0;
    switch (menu_mode) {
    case 0:
    case 3: {
        MenuTreeMapStack.Align64();
        MenuCursorDataBuff = (u_char *)MenuTreeMapStack.stGetTop();
        unsigned int size = LoadFileMenu(at_3539, (u_long128 *)MenuCursorDataBuff, 1);
        MenuTreeMapStack.Alloc((size & 0xF) ? (size >> 4) + 1 : size >> 4);
        CMenuTreePt->FadeOutMenu(1, 0.0f);
        if (GetNowLoopNo() == 1 || menu_mode == 0) {
            MenuDngMap->floor_manager->LoadDataTable(dng_no, &MenuTreeMapStack);
            MenuDngMap->floor_manager->CheckDrawGlidInfo();
            MenuTreeMapStack.Alloc(0x800);
            MenuTreeMapStack.Align64();
        }
        break;
    }
    default:
        if (MenuCommonInfo->cursor_form != NULL) {
            MenuCommonInfo->cursor_form->draw_flag = 0;
        }
        MenuCommonInfo->SetVibeCnt(0, 0);
        MenuCommonInfo->SetWakuType(-1);
        MenuCommonInfo->key_enable = 0;
        MenuCommonInfo->cursor = 0;
        MenuCommonInfo->top_line = 0;
        CMenuTreePt->FadeOutMenu(0x1E, 0.0f);
        break;
    }
    dngfloor_infoview = 0;
    dngfloor_backdraw = 0;
    TreeMapSaveDispCount = 0;
    if (dng_no < 0 || dng_no > 6) {
        dng_no = 0;
    }
    CMenuTreePt->dng_no = dng_no;
    MenuDngMap->dng_no = dng_no;
    DngInfoStageNo = dng_no;
    sprintf(name, at_3540, dng_no);
    char *files[2] = {name, NULL};
    MenuCommonReadData(&MenuTreeMapStack, files, 0);
}
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
int DngTreeMapKey() {
    int result = 0;

    if (DngTreeMode == DNG_TREE_MODE_MAP) {
        result = CMenuTreePt->Step();
        if (DngTreeMode == DNG_TREE_MODE_SAVE) {
            SetDngTreeFlag(1);
            SaveMapInfo(MenuDngMap->dng_no);
            NowProgramLoopNo = 2;
            mgCMemory save_stack;
            int remaining = MenuTreeMapStack.stGetRest();
            u_long128 *top = MenuTreeMapStack.stGetTop();
            save_stack.stSetBuffer(top, remaining);
            MenuSaveInit(&save_stack, &CMenuTreePt->tex_block[3], 7);
        }
    } else if (DngTreeMode == DNG_TREE_MODE_SAVE) {
        result = MenuSaveKey();
        if (result != 0) {
            SetDngTreeFlag(0);
            DngTreeMode = DNG_TREE_MODE_MAP;
            result = 0;
            CMenuTreePt->FadeInMenu(0x28, 0.0f);
            CMenuTreePt->mode = 0xC;
            CMenuTreePt->step = 1;
            CMenuTreePt->MsgInit();
        }
    }
    return result;
}
void DngTreeMapDraw() {
    if (DngTreeMode == DNG_TREE_MODE_MAP) {
        CMenuTreePt->Draw();
    } else if (DngTreeMode == DNG_TREE_MODE_SAVE) {
        MenuSaveDraw();
    }
}
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
template <>
void mgRect<float>::Set(float new_left, float new_top, float new_right, float new_bottom) {
    left = new_left;
    top = new_top;
    right = new_right;
    bottom = new_bottom;
}

// Static initialiser (.init)
extern "C" void __sinit_dngmenu_cpp() {
    dng_light_circle.Set(0x184, 0x130, 0x7C, 0x50);
    dngfreemap_num.Set(0, 0, 0xC, 0x12);
    treemap_root_put.Set(0.0f, 0.0f, 0.0f, 0.0f);
    Floor_Info.Set(0, 0xEE, 0x100, 0x12);
    MenuTreeMapStack.Init();
}

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
