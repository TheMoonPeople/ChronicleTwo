#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#define MES_WINDOW_OUT_OF_LINE_INIT
#include "dataread.hpp"
#include "dngfloor.hpp"
#include "dngmenu.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "memcard.hpp"
#include "menuaqua.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "savedata.hpp"
#include "savedatadungeon.hpp"
#include "scenesnd.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"
#undef MES_WINDOW_OUT_OF_LINE_INIT

/** Brightness of the active dungeon tree selection. */
extern float DngTreeMapActiveLightRate;

/**
 *
 * Draws the selected room's floor information and completion medals.
 *
 */
static void DrawDngRoomInfo(DNGMAP_ROOM_INFO *room);

/**
 *
 * Draws a paged list of georama materials for the dungeon room.
 *
 */
void DrawGeoramaMateria(int top_y, char *title, int unused_count, int *items, int tex_block);

/** Tree map menu attached to the active dungeon screen. */
extern CMenuTreeMap *CMenuTreePt;

// Code (.text)
void CDngFreeMap::Initialize() {
    active = 1;
    unk_9 = 0;
    dng_no = 0;
    floor_manager = NULL;
    save_dungeon = NULL;
    mode = DNGMAP_MODE_MENU;
    view_rect.Set(120.0f, 138.0f, 420.0f, 286.0f);
    mark_num = 0;
    next_room_no = -1;
    user_room_no = -1;
    back_scroll = 0.0f;
    pos_x = pos_y = 0.0f;
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

void CDngFreeMap::InitTexture() {
    map_tex = NULL;
    last_tex = NULL;
    koma_tex = NULL;
    name_tex = NULL;
    tex_block = -1;
}

void CDngFreeMap::SetUserGlid(int room_no) {
    user_glid = NULL;

    if (0 <= room_no) {
        user_glid = GetRoomGlid(room_no);
    }
}

void CDngFreeMap::CalcGlidPutPos(GLID_INFO *glid, float &x, float &y, int board) {
    if (glid != NULL) {
        x = static_cast<float>(glid->x * 52 + glid->y * -16);
        y = static_cast<float>(glid->y * 20);

        if (board == 0) {
            x += pos_x;
            y += pos_y;
        }
    }
}

void CDngFreeMap::CheckIsViewMove(int x, int y, float &move_x, float &move_y) {
    int clipped_x = x;
    int clipped_y = y;

    if ((float) x < view_rect.left) {
        clipped_x = (int) view_rect.left;
    }

    if (view_rect.right + -10.0f < (float) clipped_x) {
        clipped_x = (int) (view_rect.right + -10.0f);
    }

    if ((float) y < view_rect.top) {
        clipped_y = (int) view_rect.top;
    }

    if (view_rect.bottom < (float) (clipped_y - 10)) {
        clipped_y = (int) (view_rect.bottom + -10.0f);
    }

    move_x = (float) (clipped_x - x);
    move_y = (float) (clipped_y - y);
}

void CDngFreeMap::SetNextRoomPos(GLID_INFO *glid) {
    if (glid != NULL) {
        float x, y, move_x, move_y;
        CalcGlidPutPos(glid, x, y, 0);
        CheckIsViewMove(static_cast<int>(x), static_cast<int>(y), move_x, move_y);
        next_pos_x = pos_x + move_x;
        next_pos_y = pos_y + move_y;
    }
}

GLID_INFO *CDngFreeMap::GetNextGlid(GLID_INFO *glid, int *direction) {
    if (glid == NULL || floor_manager == NULL) {
        return NULL;
    }

    return floor_manager->GetNextGlid(glid, direction);
}

GLID_INFO *CDngFreeMap::GetRoomGlid(int room_no) {
    return floor_manager != NULL ? floor_manager->GetDngMapFloorGlidInfo(room_no) : NULL;
}

GLID_INFO *CDngFreeMap::GetEntranceRoomGlid() {
    if (floor_manager == NULL) {
        return NULL;
    }

    for (int i = 0; i < floor_manager->glid_num; i++) {
        GLID_INFO *glid = &floor_manager->glid_info[i];

        if (glid->type == GLID_TYPE_ROOM && (glid->room.flag & DNGMAP_ROOM_FLAG_START)) {
            return glid;
        }
    }

    return NULL;
}

void CDngFreeMap::SetTextureInfo() {
    map_tex = mgTexManager.GetTexture("dt", -1);
    last_tex = mgTexManager.GetTexture("dtbg", -1);
    koma_tex = mgTexManager.GetTexture("dngop", -1);
    name_tex = mgTexManager.GetTexture("dtname", -1);
}

void CDngFreeMap::ResetDngMapPos(int room_no, int at_once) {
    GLID_INFO *glid = GetRoomGlid(room_no);

    if (glid != NULL) {
        float board_pos[2];
        float unused_x, unused_y;
        float left, top, right, bottom;
        int   width = floor_manager->glid_w;
        int   height = floor_manager->glid_h;

        for (int i = 0; i < floor_manager->glid_num; i++) {
            GLID_INFO *cell = &floor_manager->glid_info[i];

            if (cell->x == 0) {
                CalcGlidPutPos(cell, left, unused_y, 1);
            }

            if (cell->y == 0) {
                CalcGlidPutPos(cell, unused_x, top, 1);
            }

            if (cell->x == width) {
                CalcGlidPutPos(cell, right, unused_y, 1);
            }

            if (cell->y == height) {
                CalcGlidPutPos(cell, unused_x, bottom, 1);
            }
        }

        CalcGlidPutPos(glid, board_pos[0], board_pos[1], 1);
        next_pos_x = 256.0f - board_pos[0];
        next_pos_y = 208.0f - board_pos[1];

        if (at_once != 0) {
            pos_x = next_pos_x;
            pos_y = next_pos_y;
        }
    } else {
        pos_x = -100.0f;
        next_pos_x = -100.0f;
        pos_y = -100.0f;
        next_pos_y = -100.0f;
    }
}

void CDngFreeMap::DrawBackPattern(int opacity) {
    mgCDrawPrim *prim = GetMenuPrim();

    if (mode == DNGMAP_MODE_EVENT) {
        if (static_cast<float>(opacity) < 0.0f) {
            return;
        }

        SetSpriteEnv(prim, 2);
        prim->Bilinear(1);
        prim->AntiAliasing(1);
        prim->Begin(6);
        prim->Color(0, 0, 0, 32);
        prim->Vertex(0, 0, 0);
        prim->Vertex(mgScreenWidth, mgScreenHeight, 0);
        prim->End();
    }

    if (mode == DNGMAP_MODE_MENU && map_tex != NULL) {
        mgRect<int> tile;
        tile.Set(0, 256, 128, 128);
        DrawMenuTilePattern(prim, map_tex, back_scroll, back_scroll, tile, 1, NULL);
        back_scroll += 0.5f;

        if (!(back_scroll < 0.0f)) {
            back_scroll -= static_cast<float>(tile.right);
        }
    }
}

void CDngFreeMap::DrawDngName(int opacity) {
    if (name_tex != NULL) {
        mgRect<int> tex_rect;
        tex_rect.Set(0, 0, 256, 96);
        mgCDrawPrim *prim = GetMenuPrim();
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture(name_tex);
        prim->Color(10, 10, 10, static_cast<int>(0.25f * static_cast<float>(opacity)));
        PrimQuad(prim, 4.0f, 4.0f, tex_rect);
        prim->Color(128, 128, 128, 128);
        PrimQuad(prim, 0.0f, 0.0f, tex_rect);
        prim->End();
    }
}

void CDngFreeMap::DrawLast() {
    if (last_tex == NULL || mode == DNGMAP_MODE_EVENT) {
        return;
    }

    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 4);
    prim->AlphaBlend(1);
    prim->Begin(6);
    prim->Texture(last_tex);
    prim->Color(128, 128, 128, 128);
    prim->TextureCrd(0, 0);
    prim->Vertex(0, 0, 0);
    prim->TextureCrd(128, 128);
    prim->Vertex(mgScreenWidth, mgScreenHeight, 0);
    prim->End();
}
#ifdef NONMATCHING
/**
 *
 * Offset of a passage mark from its grid cell.
 *
 */
struct RootMarkOffset {
    s16 x; /**< Horizontal position of the mark inside its grid cell. */
    s16 y; /**< Vertical position of the mark inside its grid cell. */
};

/** Destination rectangle used while drawing passage lines. */
extern mgRect<float> treemap_root_put;
/** Passage mark offsets selected by shape. */
extern RootMarkOffset markOffsetTable_1092[];
/** Mark offset of the final dungeon's diagonal passage. */
extern RootMarkOffset zerumaito_offset_1110;
/** Texture origins of the passage-type icons. */
extern s16 root_type_texturecrd_1216[][2];

void CDngFreeMap::DrawRoot(mgRect<float> rect, DNGMAP_ROOT_INFO *root, int shadow, unsigned int marks, int opacity) {
    if (root == NULL || (float) mgScreenWidth < rect.left || rect.top > (float) (mgScreenHeight + 20)) {
        return;
    }
    mgRect<float> &put = treemap_root_put;
    put = rect;
    if (shadow != 0) {
        put.left += 8.0f;
        put.top += 8.0f;
    }
    float           red = 212.0f;
    float           green = 192.0f;
    float           blue = 144.0f;
    float           mark_color = 128.0f;
    RootMarkOffset *mark = markOffsetTable_1092;
    if (mode == DNGMAP_MODE_EVENT) {
        red = 128.0f;
        green = 111.0f;
        blue = 0.0f;
        mark_color = 64.0f;
    }
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 2);
    prim->Begin(1);
    prim->Color((int) red, (int) green, (int) blue, opacity);
    if (shadow != 0) {
        prim->Color(0, 0, 0, (int) (0.05f * (float) opacity));
    }
    if (root->shape == 1 || (root->shape >= 2 && root->shape < 4) || (root->shape >= 6 && root->shape < 8)) {
        put.left -= 5.0f;
    }
    put.right = put.left + 52.0f;
    put.bottom = put.top + 20.0f;
    if (root->shape == 0) {
        put.left += 26.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.left + (float) i, put.top, 0.0f);
            prim->Vertex(put.left + (float) i - 16.0f, put.bottom, 0.0f);
        }
        if (dng_no == 6) {
            mark = &zerumaito_offset_1110;
        }
    } else if (root->shape == 1) {
        if (marks & 0x100) {
            put.left += 14.0f;
        }
        put.top += 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.left - (float) i, put.top + (float) i, 0.0f);
            prim->Vertex(put.right - (float) i, put.top + (float) i, 0.0f);
        }
        mark = &markOffsetTable_1092[1];
    } else if (root->shape == 2) {
        put.left += 25.0f;
        put.top += 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.left - (float) i, put.top + (float) i, 0.0f);
            prim->Vertex(put.right - (float) i, put.top + (float) i, 0.0f);
        }
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.left + (float) i, put.top, 0.0f);
            prim->Vertex(put.left + (float) i - 10.0f, put.bottom, 0.0f);
        }
        mark = &markOffsetTable_1092[2];
    } else if (root->shape == 3) {
        put.right -= 27.0f;
        put.top += 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.left - (float) i, put.top + (float) i, 0.0f);
            prim->Vertex(put.right - (float) i, put.top + (float) i, 0.0f);
        }
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.right + (float) i, put.top, 0.0f);
            prim->Vertex(put.right + (float) i - 10.0f, put.bottom, 0.0f);
        }
        mark = &markOffsetTable_1092[3];
    } else if (root->shape == 4) {
        put.left += 26.0f;
        put.bottom -= 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.left + (float) i, put.top, 0.0f);
            prim->Vertex(put.left + (float) i - 10.0f, put.bottom + 2.0f, 0.0f);
        }
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.left - 7.0f - (float) i, put.bottom + (float) i, 0.0f);
            prim->Vertex(put.right - 5.0f - (float) i, put.bottom + (float) i, 0.0f);
        }
        mark = &markOffsetTable_1092[4];
    } else if (root->shape == 5) {
        put.right -= 26.0f;
        put.bottom -= 10.0f;
        put.left += 1.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.left - 6.0f - (float) i, put.bottom + (float) i, 0.0f);
            prim->Vertex(put.right - 6.0f - (float) i, put.bottom + (float) i, 0.0f);
        }
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.right + (float) i, put.top, 0.0f);
            prim->Vertex(put.right + (float) i - 9.0f, put.bottom, 0.0f);
        }
        mark = &markOffsetTable_1092[5];
        put.left = put.right;
    } else if (root->shape == 6) {
        put.left += 15.5f;
        put.top += 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.left + (float) i, put.bottom, 0.0f);
            prim->Vertex(put.right - (float) i, put.top + (float) i, 0.0f);
        }
    } else if (root->shape == 7) {
        put.left -= 1.0f;
        put.right -= 35.0f;
        put.top += 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.left - (float) i / 2.0f, put.top + (float) i, 0.0f);
            prim->Vertex(put.right - (float) i, put.bottom, 0.0f);
        }
    } else if (root->shape == 8) {
        put.left += 26.0f;
        put.right -= 5.5f;
        put.bottom -= 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.left + 1.5f - (float) i, put.top, 0.0f);
            prim->Vertex(put.right - (float) i / 2.0f, put.bottom + (float) i, 0.0f);
        }
    } else if (root->shape == 9) {
        put.left -= 6.0f;
        put.right -= 26.0f;
        put.bottom -= 10.0f;
        for (int i = 0; i < 3; i++) {
            prim->Vertex(put.left - (float) i, put.bottom + (float) i, 0.0f);
            prim->Vertex(put.right + (float) i, put.top, 0.0f);
        }
    }
    prim->End();
    prim->Bilinear(0);
    prim->TextureMapEnable(1);
    prim->Begin(6);
    prim->Color((int) red, (int) green, (int) blue, opacity);
    if (shadow != 0) {
        prim->Color(0, 0, 0, (int) (0.05f * (float) opacity));
    }
    prim->Texture(map_tex);
    if (root->type != 0 && root->opened != 0 && root->show_mark != 0 && mark != NULL) {
        prim->Color((int) mark_color, (int) mark_color, (int) mark_color, opacity);
        if (shadow != 0) {
            prim->Color(0, 0, 0, (int) (0.05f * (float) opacity));
        }
        int u = root_type_texturecrd_1216[root->type][0];
        int v = root_type_texturecrd_1216[root->type][1];
        prim->TextureCrd(u, v);
        prim->Vertex(rect.left + (float) mark->x, rect.top + (float) mark->y, 0.0f);
        prim->TextureCrd(u + 22, v + 22);
        prim->Vertex(rect.left + (float) mark->x + 22.0f, rect.top + (float) mark->y + 22.0f, 0.0f);
    }
    prim->End();
}

#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DrawRoot__11CDngFreeMapF9mgRect_f_P16DNGMAP_ROOT_INFOiUii);
#endif
unsigned int CDngFreeMap::DrawGlidCheck(GLID_INFO *glid) {
    unsigned int marks;

    if (glid == NULL) {
        return 0;
    }

    marks = 0;

    for (int direction = 0; direction < GLID_DIR_NUM; direction++) {
        GLID_INFO *neighbour = glid->link_glid[direction];

        if (neighbour == NULL || glid->type != GLID_TYPE_ROOT || neighbour->type != GLID_TYPE_ROOM) {
            continue;
        }

        if (direction == GLID_DIR_UP && neighbour->y + 1 == glid->y) {
            marks |= 2;
        }

        if (direction == GLID_DIR_LEFT && neighbour->x + 1 == glid->x) {
            marks |= 8;
        }

        if ((neighbour->room.flag & DNGMAP_ROOM_FLAG_SUB) != 0 ||
            (neighbour->room.flag & DNGMAP_ROOM_FLAG_BOSS) != 0) {
            if (neighbour->room.visited == 0) {
                continue;
            }

            if (neighbour->x == glid->x) {
                if (neighbour->y == glid->y - 1) {
                    marks |= 0x40;
                }

                if (neighbour->y == glid->y + 1) {
                    marks |= 0x80;
                }
            }

            if (neighbour->y == glid->y) {
                if (neighbour->x == glid->x - 1) {
                    marks |= 0x100;
                }

                if (neighbour->x == glid->x + 1) {
                    marks |= 0x200;
                }
            }
        }
    }

    return marks;
}
#ifdef NONMATCHING
/**
 *
 * Source rectangle of a room's letter or symbol.
 *
 */
struct RoomGlyph {
    s16 x; /**< Horizontal texture origin of the glyph. */
    s16 y; /**< Vertical texture origin of the glyph. */
    s16 w; /**< Width of the glyph in texture pixels. */
    s16 h; /**< Height of the glyph in texture pixels. */
};

/**
 *
 * Offset of a room's letter or symbol within its picture.
 *
 */
struct RoomGlyphOffset {
    s16 x; /**< Horizontal glyph offset within the room picture. */
    s16 y; /**< Vertical glyph offset within the room picture. */
};

/** Source rectangles of the room-kind glyphs. */
extern RoomGlyph get_moji_tbl_1524[];
/** Destination offsets of the room-kind glyphs. */
extern RoomGlyphOffset put_moji_tbl_1525[];
/** Room-mark phase increment for menu and event maps. */
extern float stepCntTbl_1501[2];

void CDngFreeMap::DrawRoomOne(mgRect<float> rect, DNGMAP_ROOM_INFO *room, unsigned int unused, int opacity, float brightness) {
    if (room == NULL || rect.left > (float) (mgScreenWidth + 20) || rect.top > (float) (mgScreenHeight + 30)) {
        return;
    }
    rect.left -= 30.0f;
    rect.top += -42.0f;
    mgRect<float> picture = rect;
    mgCDrawPrim  *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    picture.right = 96.0f;
    picture.bottom = 66.0f;
    if (dng_no == 4 || dng_no == 5 || dng_no == 6) {
        picture.right = 100.0f;
        picture.bottom = 68.0f;
    }
    mgRect<int> tex;
    mgRect<int> special;
    tex.Set(0, 66, 96, 66);
    special.Set(192, 198, 96, 96);
    if (room->visited == 0) {
        tex.left = 0;
        tex.top = 0;
    } else {
        tex.left += tex.right * (room->tex_no % 5);
        tex.top += tex.bottom * (room->tex_no / 5);
        if (room->flag & DNGMAP_ROOM_FLAG_START) {
            tex.left = 96;
            tex.top = 0;
        }
        if (room->flag & DNGMAP_ROOM_FLAG_EXIT) {
            tex.left = 192;
            tex.top = 0;
        }
        if (room->flag & (DNGMAP_ROOM_FLAG_SUB | DNGMAP_ROOM_FLAG_BOSS)) {
            tex.left = special.left + (room->tex_no % 3) * 96;
            tex.top = special.top + (room->tex_no / 3) * 96;
            tex.right = special.right;
            tex.bottom = room->tex_no >= 3 ? 90 : special.bottom;
            picture.right = (float) special.right;
            picture.bottom = (float) special.bottom;
        }
        picture.left += (float) room->offset_x;
        picture.top += (float) room->offset_y;
    }
    int   level = (int) (128.0f * brightness);
    float event_brightness = 1.0f;
    if (mode == DNGMAP_MODE_EVENT && user_glid != NULL && &user_glid->room != room) {
        level = (int) (64.0f * brightness);
        event_brightness = 0.5f;
    }
    if (mode == DNGMAP_MODE_MENU) {
        prim->Begin(6);
        prim->Texture(map_tex);
        prim->Color(0, 0, 0, static_cast<int>(0.25f * static_cast<float>(opacity)));
        PrimQuad(prim, picture.left + 8.0f, picture.top + 8.0f, tex);
        prim->End();
    }
    SetSpriteEnv(prim, 0);
    room->mark_phase += stepCntTbl_1501[mode];
    if (room->mark_phase > 3.1415927f) {
        room->mark_phase -= 6.2831855f;
    }
    int red = 192;
    if (room->mark != 0) {
        float phase = room->mark_phase;
        while (phase > 3.1415927f) {
            phase -= 6.2831855f;
        }
        while (phase < -3.1415927f) {
            phase += 6.2831855f;
        }
        if (phase > 0.0f) {
            red = (int) (7.0f * (float) level / 8.0f);
        }
    } else {
        red = level;
    }
    prim->Bilinear(0);
    prim->Begin(6);
    prim->Texture(map_tex);
    prim->Color(red, red, red, opacity);
    PrimQuad(prim, picture, tex);
    prim->End();
    if (room->visited == 0 && user_glid != NULL && &user_glid->room != room) {
        float overlay_left = picture.left + 40.0f;
        float overlay_top = picture.top + 25.0f;
        int   left = (int) overlay_left;
        int   top = (int) overlay_top;
        int   right = (int) (overlay_left + 20.0f);
        int   bottom = (int) (overlay_top + 30.0f);
        prim->Begin(6);
        prim->Color(red, red, red, opacity);
        prim->TextureCrd(492, 66);
        prim->Vertex(left, top, 0);
        prim->TextureCrd(512, 96);
        prim->Vertex(right, bottom, 0);
        prim->End();
    }
    if (room->mark != 0) {
        float          bob = 0.71875f * (6.0f * sinf(-room->mark_phase));
        mgRect<float> &mark = mark_rect[mark_num++];
        mark.left = picture.left + 64.0f;
        mark.top = picture.top + 4.0f - bob;
        mark.right = 64.0f + bob;
        mark.bottom = 46.0f + bob;
    }
    if (name_tex != NULL && room->visited == 1) {
        for (int i = 0; i < 3; i++) {
            if (!(room->flag & (1 << (i + 1)))) {
                continue;
            }
            RoomGlyph *glyph = &get_moji_tbl_1524[i];
            if (glyph->x < 0) {
                continue;
            }
            RoomGlyphOffset *offset = &put_moji_tbl_1525[i];
            mgRect<float>    glyph_put(picture.left + (float) offset->x,
                                       picture.top + (float) offset->y,
                                       (float) glyph->w, (float) glyph->h);
            prim->TextureMapEnable(1);
            prim->Begin(6);
            prim->Texture(name_tex);
            int tint = (int) (128.0f * event_brightness);
            prim->Color(tint, tint, tint, opacity);
            mgRect<int> glyph_rect;
            glyph_rect.Set(glyph->x, glyph->y, glyph->w, glyph->h);
            PrimQuad(prim, glyph_put.left, glyph_put.top, glyph_rect);
            prim->End();
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
    prim.Color(255, 0, 0, static_cast<int>(alpha));
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

/**
 *
 * Collects qualifying georama material items for a treasure floor.
 *
 */
static int CheckGeoramaMateria(TRESURE_BOX_FLOOR_INFO *info, int floor_no, int *items) {
    if (info == NULL) {
        return 0;
    }

    if (floor_no < 0) {
        return 0;
    }

    int                floor_group;
    int                count = 0;
    TRESURE_BOX_FLOOR *floor = &info->floor[floor_no];

    for (floor_group = 0; floor_group < floor->group_num; floor_group++) {
        int group_index;
        int group_id = floor->group_id[floor_group];

        if (group_id < 0) {
            break;
        }

        TRESURE_BOX_GROUP *group = NULL;

        for (group_index = 0; group_index < info->group_num; group_index++) {
            if (group_id == info->group[group_index].group_id) {
                group = &info->group[group_index];
                break;
            }
        }

        if (group != NULL) {
            for (group_index = 0; group_index < group->item_num; group_index++) {
                items[count++] = group->item[group_index].item_no;
            }
        }
    }

    for (int pass = 0; pass < 2; pass++) {
        for (floor_group = 0; floor_group < count; floor_group++) {
            if (!(GetItemDataAttribute(items[floor_group]) & ITEM_ATTRIBUTE_GEORAMA_MATERIA)) {
                local_sort1(floor_group, &count, items);
            }
        }
    }

    return count;
}

#ifdef NONMATCHING
extern mgCTexture *Floor_InfoTex;
extern mgRect<int> Floor_Info;
extern short       dngboardbrdtbl[24];
extern short       dngboardbrdtbl_1[16];
extern short       dngboardbrdtbl_2[12];
extern short       DngInfoMedalNumMsg[16];
extern int         DngInfoMedalMsgPutPos[2];
extern CDC2Mes    *MenuDngMes[8];
/** Room whose floor-information activities are being shown. */
extern DNGMAP_ROOM_INFO *DngInfoRoomInfo;
extern DNG_FLOOR_SAVE   *DngInfoFloorInfo;
extern int               DngInfoDrawAlpha;
extern u8                dngfloor_infoview;
/** Texture X coordinates of the room-info completion icons. */
extern s16   medal_xytbl_1736[];
extern float AlphaRate_1743;
extern u8    init_1744;

/**
 *
 * Draws the dungeon room information panel and its available activities.
 *
 */
void DrawDngRoomInfo(DNGMAP_ROOM_INFO *room) {
    if (room != NULL && Floor_InfoTex != NULL) {
        if (dngfloor_infoview) {
            CalcMenuAdd(&DngInfoDrawAlpha, 6, 128);
        } else {
            CalcMenuAdd(&DngInfoDrawAlpha, -8, 0);
        }
        int language = LanguageCode;
        int width = 0x19C;
        int height = 0xE4;
        if (language > 0) {
            width = 0x1D6;
            if (MenuDngMes[5] == NULL || MenuDngMes[5]->ClsMes::mes_no != 0x6C) {
                height += 0x16;
            }
        }
        int               alpha = DngInfoDrawAlpha;
        float             top = 92.0f;
        short            *bottom_table = dngboardbrdtbl_1;
        int               center = mgScreenWidth >> 1;
        float             left = (float) ((0x200 - width) >> 1);
        DNGMAP_ROOM_INFO *shown = DngInfoRoomInfo;
        if (shown != NULL) {
            if (!shown->geostone) {
                bottom_table = dngboardbrdtbl_2;
                height -= 0x20;
                top += 20.0f;
            }
            if (!shown->spheda) {
                height -= 0x16;
                top += 14.0f;
            }
            if (!shown->fishing) {
                height -= 0x16;
                top += 14.0f;
            }
        }
        DrawMenuFillBox(left + 6.0f, top + 6.0f, (float) (width - 8), (float) (height - 8),
                        (alpha * 7) / 10, 12, 12, 12);
        mgCDrawPrim *prim = GetMenuPrim();
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture(Floor_InfoTex);
        prim->Color(128, 128, 128, alpha);
        int ix = fptosi(left);
        int iy = fptosi(top);
        Menu3DivideTextureDraw(prim, mgRect<int>(ix, iy, width, 0x46), dngboardbrdtbl, 1);
        Menu3DivideTextureDraw(prim, mgRect<int>(ix, iy + 0x46, width, height - 0x46 - dngboardbrdtbl[15]),
                               &dngboardbrdtbl[12], 1);
        Menu3DivideTextureDraw(prim, mgRect<int>(ix, iy + height - bottom_table[3], width, bottom_table[3]),
                               bottom_table, 1);
        prim->End();
        prim->Begin(6);
        prim->Texture(Floor_InfoTex);
        prim->Color(128, 128, 128, alpha);
        PrimQuad(prim, (float) (center - (Floor_Info.right >> 1)) - 1.0f, top + 10.0f, Floor_Info);
        prim->End();

        int right = ix + width;
        int right_text = right - 0x48;
        if (CheckNowEurope()) {
            right_text = right - 0x54;
        }
        float       row_top = top + 68.0f;
        mgRect<int> mark(0x7C, 0, 0x16, 0x16);
        mgRect<int> highlight(0x92, 0, 0x16, 0x16);
        prim->Bilinear(1);
        prim->Begin(6);
        prim->Texture(Floor_InfoTex);
        prim->Color(128, 128, 128, alpha);
        if (MenuDngMes[0] != NULL) {
            MenuDngMes[0]->SetMovePosCenteringGyou(0, center, iy + 0x26);
        }
        if (DngInfoFloorInfo != NULL && !(DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_SEAL_CLEAR) && room->seal > 0) {
            if (!init_1744) {
                AlphaRate_1743 = 0.0f;
                init_1744 = 1;
            }
            AlphaRate_1743 += 0.034906585f;
            if (3.1415927f <= AlphaRate_1743) {
                AlphaRate_1743 -= 3.1415927f;
            }
            float seal_alpha = (float) alpha * sinf(AlphaRate_1743);
            if (seal_alpha < 0.0f) {
                seal_alpha = 0.0f;
            }
            if (seal_alpha > 128.0f) {
                seal_alpha = 128.0f;
            }
            mgRect<int>  translated_seal(0xD8, 0xA6, 0x28, 0x18);
            mgRect<int>  japanese_seal(0xB8, 0xD6, 0x18, 0x18);
            mgRect<int> *seal = &translated_seal;
            prim->Color(128, 128, 128, fptosi(seal_alpha));
            float seal_right_offset;
            if (language > 0) {
                seal->top += (room->seal - 1) * 0x18;
                seal_right_offset = 56.0f;
            } else {
                seal = &japanese_seal;
                seal->left += (room->seal - 1) * 0x18;
                seal_right_offset = 40.0f;
            }
            PrimQuad(prim, left + width - seal_right_offset, top + 35.0f, *seal);
            prim->Color(128, 128, 128, alpha);
        }
        int icon_x = fptosi(left + 20.0f);
        int icon_y = fptosi(2.0f + (68.0f + (float) iy));
        int text_x = icon_x + 0x1C;
        PrimQuad(prim, (float) icon_x, row_top, mark);
        if (DngInfoFloorInfo != NULL && (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_FAST_DESTROY_CLEAR)) {
            highlight.left = medal_xytbl_1736[0];
            PrimQuad(prim, (float) icon_x, (float) icon_y, highlight);
        }
        int icon_row_y = icon_y;
        int text_row_y = icon_y;
        {
            MenuDngMes[1]->line_pos[0][0] = text_x;
            MenuDngMes[1]->line_pos[0][1] = text_row_y;
            MenuDngMes[1]->line_pos_on[0] = 1;
            int line_right = right - MenuDngMes[1]->line_w[1] - 0xE;
            if (CheckNowEurope()) {
                line_right -= 8;
            }
            MenuDngMes[1]->line_pos[1][0] = line_right;
            MenuDngMes[1]->line_pos[1][1] = text_row_y;
            MenuDngMes[1]->line_pos_on[1] = 1;
        }
        icon_row_y += 0x16;
        text_row_y += 0x16;
        shown = DngInfoRoomInfo;
        if (shown != NULL && shown->fishing) {
            PrimQuad(prim, (float) icon_x, (float) icon_row_y, mark);
            if (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_FISHING_CLEAR) {
                highlight.left = medal_xytbl_1736[2];
                PrimQuad(prim, (float) icon_x, (float) icon_row_y, highlight);
            }
            MenuDngMes[3]->line_pos[0][0] = text_x;
            MenuDngMes[3]->line_pos[0][1] = text_row_y;
            MenuDngMes[3]->line_pos_on[0] = 1;
            MenuDngMes[3]->line_pos[1][0] = right - MenuDngMes[3]->line_w[1] - 0x10;
            MenuDngMes[3]->line_pos[1][1] = text_row_y;
            MenuDngMes[3]->line_pos_on[1] = 1;
            if (MenuDngMes[3]->ClsMes::mes_no == 2) {
                MenuDngMes[3]->line_pos[1][0] = right_text;
                MenuDngMes[3]->line_pos[1][1] = text_row_y;
                MenuDngMes[3]->line_pos_on[1] = 1;
            }

            icon_row_y += 0x16;
            text_row_y += 0x16;
        }
        shown = DngInfoRoomInfo;
        if (shown != NULL && shown->spheda) {
            PrimQuad(prim, (float) icon_x, (float) icon_row_y, mark);
            int prize_x = right_text;
            if (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_SPHEDA_CLEAR) {
                if (language > 0) {
                    prize_x -= 9;
                }
                if (CheckNowEurope()) {
                    prize_x = right - MenuDngMes[4]->line_w[1] - 0x10;
                }
                highlight.left = medal_xytbl_1736[3];
                PrimQuad(prim, (float) icon_x, (float) icon_row_y, highlight);
            } else if (CheckBitFlagMenu(0x13D)) {
                if (language > 0) {
                    prize_x -= 0x20;
                }
                if (CheckNowEurope()) {
                    prize_x = right - MenuDngMes[4]->line_w[1] - 0x10;
                }
            }
            MenuDngMes[4]->line_pos[0][0] = text_x;
            MenuDngMes[4]->line_pos[0][1] = text_row_y;
            MenuDngMes[4]->line_pos_on[0] = 1;
            MenuDngMes[4]->line_pos[1][0] = prize_x;
            MenuDngMes[4]->line_pos[1][1] = text_row_y;
            MenuDngMes[4]->line_pos_on[1] = 1;
            icon_row_y += 0x16;
            text_row_y += 0x16;
        }
        PrimQuad(prim, (float) icon_x, (float) icon_row_y, mark);
        if (DngInfoFloorInfo != NULL && (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_PRACTICE_CLEAR)) {
            highlight.left = medal_xytbl_1736[4];
            PrimQuad(prim, (float) icon_x, (float) icon_row_y, highlight);
        }
        if (language == 0) {
            MenuDngMes[5]->SetMovePosGyou(0, text_x, text_row_y);
            MenuDngMes[5]->SetMovePosGyou(1, right_text, text_row_y);
            text_row_y += 0x16;
        } else {
            MenuDngMes[5]->SetMovePosGyou(0, text_x, text_row_y);
            if (MenuDngMes[5]->ClsMes::mes_no == 0x6C) {
                MenuDngMes[5]->SetMovePosGyou(1, right - MenuDngMes[5]->line_w[1] - 0x10, text_row_y);
                text_row_y += 0x16;
            } else {
                MenuDngMes[5]->SetMovePosGyou(1, text_x, text_row_y + 0x16);
                MenuDngMes[5]->SetMovePosGyou(2, right - MenuDngMes[5]->line_w[2] - 0x10, text_row_y + 0x12);
                text_row_y += 0x2C;
            }
        }
        prim->End();
        MenuDngMes[6]->line_pos[0][0] = text_x;
        MenuDngMes[6]->line_pos[0][1] = text_row_y;
        MenuDngMes[6]->line_pos_on[0] = 1;
        MenuDngMes[6]->line_pos[1][0] = right - MenuDngMes[6]->line_w[1] - 0x1A;
        MenuDngMes[6]->line_pos[1][1] = text_row_y;
        MenuDngMes[6]->line_pos_on[1] = 1;

        shown = DngInfoRoomInfo;
        if (shown != NULL && shown->geostone) {
            MenuDngMes[7]->line_pos[0][0] = center - (MenuDngMes[7]->line_w[0] >> 1);
            MenuDngMes[7]->line_pos[0][1] = text_row_y + 0x24;
            MenuDngMes[7]->line_pos_on[0] = 1;
        }
        for (int i = 0; i < 8; ++i) {
            MenuDngMes[i]->SetMsgAlpha(alpha);
        }
        if (MenuDCMsg[5] != NULL) {
            DngInfoMedalMsgPutPos[0] = DngInfoMedalNumMsg[language * 2];
            DngInfoMedalMsgPutPos[1] = DngInfoMedalNumMsg[language * 2 + 1];
            MenuDCMsg[5]->SetPutPos(DngInfoMedalMsgPutPos);
            MenuDCMsg[5]->SetMsgAlpha(alpha);
        }
    }
}

#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DrawDngRoomInfo__FP16DNGMAP_ROOM_INFO);
#endif
#ifdef NONMATCHING
extern mgCTexture *Floor_InfoTex;
extern s8          GeoramaMateriaInfoDrawPage;
extern short       GeoramaMateriaNum;
extern mgRect<int> Floor_Info;
extern short       dngboardbrdtbl[24];
extern short       dngboardbrdtbl_2[12];
extern char        at_1993[];

/**
 *
 * Draws a paged list of georama materials for the dungeon room.
 *
 */
void DrawGeoramaMateria(int top_y, char *title, int unused_count, int *items, int tex_block) {
    int left = (mgScreenWidth - 0x1AE) >> 1;
    int column_left = mgScreenWidth / 3;
    int column_right = mgScreenWidth - column_left;
    mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *) NULL);
    CMenuFont font;
    DrawMenuFillBox((float) (left + 6), (float) (top_y + 6), 422.0f, 272.0f,
                    0x59, 0xC, 0xC, 0xC);
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(Floor_InfoTex);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, top_y, 0x1AE, 0x46), dngboardbrdtbl, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, top_y + 0x46, 0x1AE, 0xD2 - dngboardbrdtbl[15]),
                           &dngboardbrdtbl[12], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, top_y + 0x118 - dngboardbrdtbl_2[3], 0x1AE, dngboardbrdtbl_2[3]), dngboardbrdtbl_2, 1);
    PrimQuad(prim, (float) ((mgScreenWidth >> 1) - (Floor_Info.right >> 1)) - 1.0f,
             (float) top_y + 10.0f, Floor_Info);
    prim->End();

    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
    int text_w, text_h;
    font.SetStr(title);
    font.CalcDrawWH(font.str, &text_w, &text_h);
    font.SetPos((mgScreenWidth - text_w) >> 1, top_y + 0x26);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);

    int first = GeoramaMateriaInfoDrawPage * 14;
    int last = first + 14;
    if (GeoramaMateriaNum < last) {
        last = GeoramaMateriaNum;
    }
    int row_y = top_y + 0x47;
    for (int index = first; index < last; ++index) {
        char *name = GetItemMessage(items[index]);
        if (name == NULL) {
            continue;
        }
        font.SetStr(name);
        int item_w, item_h;
        font.CalcDrawWH(font.str, &item_w, &item_h);
        int column = (index % 2 == 0) ? column_left : column_right;
        font.SetPos(column - (item_w >> 1), row_y);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
        if (index % 2 != 0) {
            row_y += 0x18;
        }
    }
    char page[32];
    sprintf(page, at_1993, GeoramaMateriaInfoDrawPage + 1, GeoramaMateriaNum / 14 + 1);
    font.SetStr(page);
    font.SetPos(left + 0x186, top_y + 0xEF);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DrawGeoramaMateria__FiPciPii);
#endif
/** Source rectangle of the selected floor highlight. */
extern const mgRect<int> dng_light_circle;

void CDngFreeMap::DrawTreeMap(int opacity) {
    GLID_INFO    *glid = floor_manager->glid_info;
    mgRect<float> cell_rect(0.0f, 0.0f, 52.0f, 20.0f);

    if (mode == DNGMAP_MODE_MENU) {
        mgCDrawPrim *prim = GetMenuPrim();
        float        position[2];
        CalcGlidPutPos(select_glid, position[0], position[1], 0);
        position[0] = position[0] - 8.0f - 30.0f;
        position[1] = -42.0f + (11.0f + position[1]);
        float reach_x = 62.0f - 62.0f * DngTreeMapActiveLightRate;
        float reach_y = 40.0f - 40.0f * DngTreeMapActiveLightRate;
        SetSpriteEnv(prim, 4);
        prim->Bilinear(0);
        prim->Begin(6);
        prim->Texture(map_tex);
        prim->Color(128, 128, 128, (int) (0.5f * (float) opacity));
        prim->TextureCrd(dng_light_circle.left, dng_light_circle.top);
        prim->Vertex(position[0] + reach_x, position[1] + reach_y, 0.0f);
        prim->TextureCrd(dng_light_circle.left + dng_light_circle.right,
                         dng_light_circle.top + dng_light_circle.bottom);
        prim->Vertex(position[0] + 124.0f - reach_x, position[1] + 80.0f - reach_y, 0.0f);
        prim->End();
    }

    unsigned int marks;

    for (int i = 0; i < floor_manager->glid_num; i++, glid++) {
        CalcGlidPutPos(glid, cell_rect.left, cell_rect.top, 0);

        if (menu_debug_flag != 0) {
            DrawGlid(cell_rect);
        }

        marks = DrawGlidCheck(glid);

        if (glid->type == GLID_TYPE_ROOM) {
            float brightness = 1.0f;

            if (glid->blink != 0 && blink_cnt % 25 < 14) {
                brightness = 0.5f;
            }

            DrawRoomOne(cell_rect, &glid->room, 0, opacity, brightness);
        } else if (glid->type == GLID_TYPE_ROOT) {
            DrawRoot(cell_rect, &glid->root, 1, marks, opacity);
            DrawRoot(cell_rect, &glid->root, 0, marks, opacity);
        }
    }
}

extern float dng_player_pos[2];
extern int   dng_player_blink_cnt;

void CDngFreeMap::DrawPlayer(int opacity) {
    if (user_glid == NULL || koma_tex == NULL) {
        return;
    }

    float board_x, board_y;
    CalcGlidPutPos(user_glid, board_x, board_y, 0);
    board_x += 4.0f;
    board_y -= 30.0f;
    float sprite_alpha = static_cast<float>(opacity);

    if (mode == DNGMAP_MODE_EVENT) {
        if (koma_move != 0 && koma_now != NULL) {
            dng_player_pos[0] = koma_now->x;
            dng_player_pos[1] = koma_now->y;
            koma_now = koma_now->next;
        }

        board_x = dng_player_pos[0];
        board_y = dng_player_pos[1];
    }

    if (mode == DNGMAP_MODE_MENU) {
        board_y -= 6.0f * sinf(0.06283186f * (float) dng_player_blink_cnt);
    }

    dng_player_blink_cnt++;

    if (dng_player_blink_cnt >= 50) {
        dng_player_blink_cnt = 0;
    }

    float brightness = 16.0f + alpha + 16.0f * sinf(0.06283186f * (float) dng_player_blink_cnt);

    if (brightness < 0.0f) {
        brightness = 0.0f;
    }

    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Bilinear(1);
    prim->Begin(6);
    prim->Texture(koma_tex);
    int level = (int) brightness;
    prim->Color(level, level, level, static_cast<int>(sprite_alpha));
    mgRect<int> tex_rect(0, 0, 30, 48);
    PrimQuad(prim, board_x, board_y, tex_rect);
    prim->End();
}

void CDngFreeMap::Step() {
    if (active == 0) {
        return;
    }

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

    if (static_cast<float>(abs(static_cast<int>(pos_x - next_pos_x))) < 1.0f) {
        pos_x = next_pos_x;
    }

    if (static_cast<float>(abs(static_cast<int>(pos_y - next_pos_y))) < 1.0f) {
        pos_y = next_pos_y;
    }

    blink_cnt++;

    if (blink_cnt >= DNGMAP_BLINK_CYCLE) {
        blink_cnt = 0;
    }

    DngTreeMapActiveLightRate += 0.05f;

    if (!(DngTreeMapActiveLightRate < 1.0f)) {
        DngTreeMapActiveLightRate = 1.0f;
    }

    mark_num = 0;
}

/** Selected flag row in the dungeon map's debug readout. */
extern int MenuDngDebugFlagSelect;
/** Names of the passage kinds shown beside the debug room data. */
extern char *RootTable_2119[4];
/** Labels for the eight debug floor-save flags. */
extern char Table_2133[8][32];
/** Floor-save flag masks corresponding to the debug flag labels. */
extern unsigned int bittable_2134[8];

/**
 *
 * Kinds of passages identified by the floor map's debug readout.
 *
 */
enum DNGMAP_ROOT_TYPE {
    DNGMAP_ROOT_NORMAL = 0, /**< Ordinary passage to the next floor. */
    DNGMAP_ROOT_SUN = 1,    /**< Passage unlocked with a sun key. */
    DNGMAP_ROOT_MOON = 2,   /**< Passage unlocked with a moon key. */
    DNGMAP_ROOT_STAR = 3,   /**< Passage unlocked with a star key. */
};

void CDngFreeMap::Draw() {
    if (active != 0 && !(alpha <= 0.0f)) {
        mgCTextureManager *textures = &mgTexManager;
        mgCTexture        *texture = map_tex;

        if (texture == NULL) {
            return;
        }

        int opacity = (int) alpha;

        if (opacity < 0) {
            opacity = 0;
        }

        if (opacity > 128) {
            opacity = 128;
        }

        textures->ReloadTexture(texture->block, (sceVif1Packet *) NULL);
        DrawBackPattern(opacity);
        DrawLast();
        DrawTreeMap(opacity);
        DrawPlayer(opacity);

        if (mode != DNGMAP_MODE_EVENT) {
            mgCDrawPrim *prim = GetMenuPrim();
            SetSpriteEnv(prim, 0);
            prim->Bilinear(1);
            prim->Begin(6);
            prim->Texture(name_tex);
            prim->Color(128, 128, 128, opacity);

            for (int i = 0; i < mark_num; i++) {
                PrimQuad(prim, mark_rect[i], mgRect<int>(192, 210, 64, 46));
            }

            prim->End();
        }

        if (menu_debug_flag == 0) {
            return;
        }

        int block = -1;
        MenuReloadTexture(block, MenuDCMsg[2]->texture_block);
        int       moon;
        int       sun;
        int       normal;
        CMenuFont menu_font;
        CFont    *font = &menu_font;
        int       y = 110;
        DrawMenuFillBox(0.0f, 50.0f, 160.0f, 60.0f, 64, 0, 0, 0);
        font->SetStr("\x81@Ctrl : <- or -> \n  \x81@       \x81\x9B or \x81~\n\x81@\x91S\x95\\\x8E\xA6 :\x81\xA2");
        font->SetPos(0, 50);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        DrawMenuFillBox(0.0f, (float) y, 160.0f, (float) (mgScreenHeight - y), 64, 0, 0, 0);

        if (select_glid != NULL && select_glid->type == GLID_TYPE_ROOM) {
            DNG_FLOOR_SAVE *save = MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, select_glid->room.floor_id);

            if (save != NULL) {
                char detail[256];
                char line[32];
                sprintf(detail, "Room ID : %d", select_glid->room.floor_id);
                DNGMAP_ROOM_INFO *room = &select_glid->room;

                if (room->flag & DNGMAP_ROOM_FLAG_START) {
                    strcat(detail, ":START ");
                }

                if (room->flag & DNGMAP_ROOM_FLAG_EXIT) {
                    strcat(detail, ":EXIT");
                }

                if (room->flag & DNGMAP_ROOM_FLAG_BOSS) {
                    strcat(detail, ":BOSS");
                }

                if (room->flag & DNGMAP_ROOM_FLAG_SUB) {
                    strcat(detail, ":SUBMAP");
                }

                strcat(detail, "\n");
                font->SetStr(detail);
                font->SetPos(10, y + 2);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                normal = floor_manager->GetDngMapNextFloorID(select_glid->room.floor_id, DNGMAP_ROOT_NORMAL);
                sun = floor_manager->GetDngMapNextFloorID(select_glid->room.floor_id, DNGMAP_ROOT_SUN);
                moon = floor_manager->GetDngMapNextFloorID(select_glid->room.floor_id, DNGMAP_ROOT_MOON);
                sprintf(line, "Normal:%d\nSun:%d\n Moon :%d\n Star :%d", normal, sun, moon,
                        floor_manager->GetDngMapNextFloorID(select_glid->room.floor_id, DNGMAP_ROOT_STAR));
                font->SetStr(line);
                font->SetPos(20, y + 22);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                strcpy(line, "\x81@Root\x81"
                             "F");
                int links = floor_manager->GetDngMapNextRoot(select_glid->room.floor_id);

                for (int i = 0; i < 4; i++) {
                    if (links & (1 << i)) {
                        strcat(line, RootTable_2119[i]);
                    }
                }

                font->SetStr(line);
                font->SetPos(10, y + 102);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                sprintf(detail, "  VisitNum\x81\x40: %d\n", save->visit_count);

                if (MenuDngDebugFlagSelect == 0) {
                    sprintf(detail, "> VisitNum\x81\x40: %d\n", save->visit_count);
                }

                font->SetStr(detail);
                font->SetPos(10, y + 122);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                y += 142;

                for (int i = 0; i < 8; i++) {
                    strcpy(detail, Table_2133[i]);

                    if (save->flag & bittable_2134[i]) {
                        strcat(detail, "ON");
                    } else {
                        strcat(detail, "OFF");
                    }

                    if (MenuDngDebugFlagSelect > 0 && MenuDngDebugFlagSelect - 1 == i) {
                        detail[0] = '>';
                    }

                    font->SetStr(detail);
                    font->SetPos(10, y);
                    font->DrawDirect(font->str, font->pos_x, font->pos_y);
                    y += 20;
                }

                strcat(detail, "NONE");
            }
        }
    }
}

void CDngFreeMap::FadeIn(int frames) {
    fade_mode = DNGMAP_FADE_IN;
    fade_time = frames;
    fade_step = 128.0f;

    if (0 < frames) {
        fade_step = 128.0f / static_cast<float>(frames);
    }

    alpha = 0.0f;
}

void CDngFreeMap::FadeOut(int frames) {
    fade_mode = DNGMAP_FADE_OUT;
    fade_time = frames;
    fade_step = -128.0f;

    if (0 < frames) {
        fade_step = -128.0f / static_cast<float>(frames);
    }
}

void CDngFreeMap::DeleteTexBlock() {
    mgCTextureManager *manager = &mgTexManager;
    int                block = tex_block;

    if (block >= 0) {
        manager->DeleteBlock(block);
    }
}

void CDngFreeMap::SetKomaMove(int moving) {
    koma_move = moving;
    koma_now = koma_path;

    if (koma_now != NULL) {
        koma_now = koma_now->next;
    }
}
#ifdef NONMATCHING
/** Passage interpolation point tables, indexed by passage shape. */
extern const short *RootHokanTablePtrTable_2240__DATA[];
/** Room interpolation point tables, indexed by entry and exit direction. */
extern const short *RoomHokanTablePtrTable_2245__DATA[];
/** Point order of passage routes, indexed by shape and direction. */
extern const signed char is_reverse_tbl_2246__DATA[];
/** Room interpolation table selected by entry and exit direction. */
extern const signed char old_hokantbl_useno_2247__DATA[];
/** Point order of entry and exit room interpolation tables. */
extern const signed char is_reverse_tbl_room_2248__DATA[];

/**
 *
 * Orders the interpolation points when tracing a dungeon map route.
 *
 */
enum DNGMAP_PATH_ORDER {
    DNGMAP_PATH_FORWARD = 0, /**< Reads a cell's interpolation points from first to last. */
    DNGMAP_PATH_REVERSE = 1, /**< Reads a cell's interpolation points from last to first. */
};

int CDngFreeMap::LoadDngInfo(mgCMemory *stack, int block, int dungeon, int room, int next_room) {
    if (stack == NULL || stack->stGetRest() <= 0) {
        return 0;
    }

    save_dungeon = &GetSaveData()->save_dungeon;
    mgCDrawPrim *prim = GetMenuPrim();
    prim->offset_x = 0;
    prim->offset_y = 0;
    mgCMemory memory;
    int       remaining = stack->stGetRest();
    memory.stSetBuffer(stack->stGetTop(), remaining);
    memory.Align64();
    floor_manager = &((DNG_BATTLE_AREA *) menu_GetBattleAreaScene())->floor_manager;
    dng_no = dungeon;
    floor_manager->CheckDrawGlidInfo();
    user_room_no = room;
    next_room_no = next_room;
    GetRoomGlid(user_room_no);
    if (next_room_no >= 0) {
        GetRoomGlid(next_room_no);
    }
    select_glid = NULL;
    mode = DNGMAP_MODE_EVENT;
    InitTexture();
    tex_block = block;
    memory.Align64();
    u_long128 *buffer = memory.stGetTop();
    if (buffer != NULL) {
        char filename[0x40];
        sprintf(filename, "dmap%d.img", dungeon);
        unsigned int size = LoadFileMenu(filename, buffer, 1);
        unsigned int quadwords = (size & 15) ? (size >> 4) + 1 : size >> 4;
        memory.Alloc(quadwords);
        MenuEnterIMG(tex_block, (unsigned char *) buffer, "_dn");
        koma_tex = mgTexManager.GetTexture("dngop_dn", -1);
        map_tex = mgTexManager.GetTexture("dt_dn", -1);
        name_tex = mgTexManager.GetTexture("dtname_dn", -1);
    }
    view_rect.Set(60.0f, 40.0f, (float) (mgScreenWidth - 40), (float) (mgScreenHeight - 40));
    SetUserGlid(user_room_no);
    ResetDngMapPos(user_room_no, 1);
    koma_now = NULL;
    koma_path = NULL;
    koma_move = 0;
    CalcGlidPutPos(user_glid, dng_player_pos[0], dng_player_pos[1], 0);
    dng_player_pos[0] += 8.0f;
    dng_player_pos[1] += -28.0f;
    if (next_room_no >= 0) {
        int        direction = -1;
        float      gx = 0.0f;
        float      gy = 0.0f;
        float      x = 0.0f;
        float      y = 0.0f;
        GLID_INFO *start = GetRoomGlid(user_room_no);
        // Event jumps enter the first room of the branch between the two floors.
        if (dng_no == 1) {
            if (user_room_no == 8 && next_room_no >= 9) {
                next_room_no = next_room_no < 13 ? 9 : 13;
            }
            if (user_room_no >= 14 && next_room_no < user_room_no) {
                next_room_no = user_room_no - 1;
            }
            if (user_room_no == 13) {
                next_room_no = next_room_no < 14 ? 8 : 14;
            }
        }
        if (dng_no == 2) {
            if (user_room_no == 5 && next_room_no >= 6 && next_room_no < 9) {
                next_room_no = 6;
            }
            if (user_room_no >= 6 && user_room_no < 9 && next_room_no >= 9) {
                next_room_no = user_room_no - 1;
            }
            if (user_room_no >= 12 && user_room_no < 15 && next_room_no >= 16) {
                next_room_no = user_room_no - 1;
            }
            if (user_room_no == 16) {
                next_room_no = next_room_no < 16 ? 11 : 17;
            }
            if (user_room_no >= 17 && next_room_no < user_room_no) {
                next_room_no = user_room_no - 1;
            }
            if (user_room_no == 11) {
                next_room_no = next_room_no < 11 ? 10 : (next_room_no < 12 ? 16 : (next_room_no < 16 ? 12 : 16));
            }
        }
        if (dng_no == 3) {
            if (user_room_no >= 11 && user_room_no < 14 && next_room_no >= 16) {
                next_room_no = user_room_no - 1;
            }
            if (user_room_no == 10 && next_room_no >= 11 && next_room_no < 15) {
                next_room_no = 11;
            }
            if (user_room_no == 15) {
                next_room_no = next_room_no < 15 ? 10 : 16;
            }
            if (user_room_no >= 16 && next_room_no < user_room_no) {
                next_room_no = user_room_no - 1;
            }
        }
        if (dng_no == 4) {
            if (user_room_no == 4 && next_room_no >= 5 && next_room_no < 9) {
                next_room_no = 5;
            }
            if (user_room_no >= 5 && user_room_no < 8 && next_room_no >= 9) {
                next_room_no = user_room_no - 1;
            }
            if (user_room_no == 9) {
                next_room_no = next_room_no < 9 ? 4 : 10;
            }
            if (user_room_no >= 10 && next_room_no < user_room_no) {
                next_room_no = user_room_no - 1;
            }
        }
        if (dng_no == 5) {
            if (user_room_no == 4 && next_room_no >= 5 && next_room_no < 12) {
                next_room_no = 5;
            }
            if (user_room_no >= 5 && user_room_no < 11 && next_room_no >= 12) {
                next_room_no = user_room_no - 1;
            }
            if (user_room_no == 12) {
                next_room_no = next_room_no < 12 ? 4 : 13;
            }
            if (user_room_no >= 13 && next_room_no < user_room_no) {
                next_room_no = user_room_no - 1;
            }
        }
        if (dng_no == 6) {
            if (user_room_no >= 8 && user_room_no < 11 && next_room_no >= 11) {
                next_room_no = user_room_no - 1;
            }
            if (user_room_no >= 13 && user_room_no < 17 && next_room_no >= 17) {
                next_room_no = user_room_no - 1;
            }
            if (user_room_no == 20 && next_room_no >= 22) {
                next_room_no = 19;
            }
            if (user_room_no >= 24 && user_room_no < 27 && next_room_no >= 27) {
                next_room_no = user_room_no - 1;
            }
            if (user_room_no >= 29 && user_room_no < 33) {
                next_room_no = next_room_no < user_room_no ? user_room_no - 1 : user_room_no + 1;
            }
            if (user_room_no == 6) {
                next_room_no = next_room_no < 6 ? 5 : (next_room_no >= 11 ? 11 : 7);
            }
            if (user_room_no == 11) {
                next_room_no = next_room_no < 11 ? 6 : (next_room_no >= 17 ? 17 : 12);
            }
            if (user_room_no == 18) {
                next_room_no = next_room_no < 18 ? 17 : (next_room_no >= 22 ? 22 : 19);
            }
            if (user_room_no == 22) {
                next_room_no = next_room_no < 22 ? 18 : (next_room_no >= 27 ? 27 : 23);
            }
            if (user_room_no == 28) {
                next_room_no = next_room_no < 28 ? 27 : (next_room_no >= 34 ? 34 : 29);
            }
            if (user_room_no == 35) {
                next_room_no = next_room_no == 34 ? 34 : (next_room_no >= 36 ? 36 : 33);
            }
        }
        GLID_INFO *target = GetRoomGlid(next_room_no);
        if (target == NULL) {
            return 0;
        }
        if (start != NULL && abs((int) start->room.order - (int) target->room.order) >= 2) {
            GLID_INFO *candidate[4];
            int        candidate_room[4];
            int        candidate_count = 0;
            int        farthest = -1;
            u8         reverse = DNGMAP_PATH_REVERSE;
            if (start->room.order < target->room.order) {
                reverse = DNGMAP_PATH_FORWARD;
            }
            for (int dir = 0; dir < GLID_DIR_NUM; ++dir) {
                int adjacent = start->room.link[dir];
                if (adjacent < 0) {
                    continue;
                }
                GLID_INFO *linked = GetRoomGlid(adjacent);
                if (linked == NULL) {
                    continue;
                }
                if ((reverse == DNGMAP_PATH_REVERSE && linked->room.order < start->room.order) ||
                    (reverse == DNGMAP_PATH_FORWARD && start->room.order < linked->room.order)) {
                    candidate[candidate_count] = linked;
                    candidate_room[candidate_count] = adjacent;
                    if (adjacent > farthest) {
                        farthest = adjacent;
                    }
                    ++candidate_count;
                }
            }
            for (int i = 0; i < candidate_count; ++i) {
                if (reverse == DNGMAP_PATH_REVERSE ||
                    (reverse == DNGMAP_PATH_FORWARD &&
                     ((target->room.floor_id < farthest && abs((int) target->room.floor_id - candidate_room[i]) <= 0) ||
                      (farthest < target->room.floor_id && abs((int) target->room.floor_id - candidate_room[i]) > 0)))) {
                    target = candidate[i];
                    next_room_no = candidate_room[i];
                    break;
                }
            }
        }

        koma_path = (DNGMAP_KOMA_POS *) memory.Alloc(1);
        koma_now = koma_path;
        koma_now->next = NULL;
        DNGMAP_KOMA_POS *tail = koma_now;
        CalcGlidPutPos(target, x, y, 0);
        tail->x = x;
        tail->y = y;
        for (int i = 0; i < GLID_DIR_NUM; ++i) {
            if (target->room.link[i] == user_room_no) {
                direction = i;
                break;
            }
        }
        if (direction < 0) {
            return memory.stGetUsed();
        }
        int          table = old_hokantbl_useno_2247__DATA[direction];
        int          reverse = is_reverse_tbl_room_2248__DATA[table];
        const short *points = RoomHokanTablePtrTable_2245__DATA[table];
        if (reverse == DNGMAP_PATH_FORWARD) {
            for (int i = 0; i < 10; i++) {
                DNGMAP_KOMA_POS *node = (DNGMAP_KOMA_POS *) memory.Alloc(1);
                node->x = x + (float) points[i * 2];
                node->y = y + (float) points[i * 2 + 1];
                tail->next = node;
                tail = node;
            }
        } else if (reverse == DNGMAP_PATH_REVERSE) {
            for (int i = 9; i >= 0; i--) {
                DNGMAP_KOMA_POS *node = (DNGMAP_KOMA_POS *) memory.Alloc(1);
                node->x = x + (float) points[i * 2];
                node->y = y + (float) points[i * 2 + 1];
                tail->next = node;
                tail = node;
            }
        }
        GLID_INFO *glid = target->link_glid[direction];
        while (glid != NULL) {
            CalcGlidPutPos(glid, gx, gy, 0);
            glid->blink = 1;
            if (glid->type == GLID_TYPE_ROOT) {
                int          route_table = glid->root.shape;
                int          reverse = is_reverse_tbl_2246__DATA[route_table * 4 + direction];
                const short *points = RootHokanTablePtrTable_2240__DATA[route_table];
                if (reverse < 0) {
                    break;
                }
                if (reverse == DNGMAP_PATH_FORWARD) {
                    for (int i = 0; i < 20; i++) {
                        DNGMAP_KOMA_POS *node = (DNGMAP_KOMA_POS *) memory.Alloc(1);
                        node->x = gx + (float) points[i * 2];
                        node->y = gy + (float) points[i * 2 + 1];
                        tail->next = node;
                        tail = tail->next;
                    }
                } else if (reverse == DNGMAP_PATH_REVERSE) {
                    for (int i = 19; i >= 0; i--) {
                        DNGMAP_KOMA_POS *node = (DNGMAP_KOMA_POS *) memory.Alloc(1);
                        node->x = gx + (float) points[i * 2];
                        node->y = gy + (float) points[i * 2 + 1];
                        tail->next = node;
                        tail = node;
                    }
                }
            } else if (glid->type == GLID_TYPE_ROOM) {
                int          route_table = old_hokantbl_useno_2247__DATA[direction + 4];
                int          reverse = is_reverse_tbl_room_2248__DATA[route_table + 4];
                const short *points = RoomHokanTablePtrTable_2245__DATA[route_table];
                if (reverse == DNGMAP_PATH_FORWARD) {
                    for (int i = 0; i < 10; i++) {
                        DNGMAP_KOMA_POS *node = (DNGMAP_KOMA_POS *) memory.Alloc(1);
                        node->x = gx + (float) points[i * 2];
                        node->y = gy + (float) points[i * 2 + 1];
                        tail->next = node;
                        tail = node;
                    }
                } else if (reverse == DNGMAP_PATH_REVERSE) {
                    for (int i = 9; i >= 0; i--) {
                        DNGMAP_KOMA_POS *node = (DNGMAP_KOMA_POS *) memory.Alloc(1);
                        node->x = gx + (float) points[i * 2];
                        node->y = gy + (float) points[i * 2 + 1];
                        tail->next = node;
                        tail = node;
                    }
                }
            } else {
                break;
            }
            if (glid == start) {
                break;
            }
            glid = GetNextGlid(glid, &direction);
        }
        tail->next = NULL;
        if (koma_now->next != NULL) {
            dng_player_pos[0] = koma_now->next->x;
            dng_player_pos[1] = koma_now->next->y;
        }
    }
    return memory.stGetUsed();
}

#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", LoadDngInfo__11CDngFreeMapFP9mgCMemoryiiii);
#endif

/** Screen currently drawn by the dungeon tree menu. */
extern short DngTreeMode;

int CheckDngTreeMapFuncType() {
    if (MenuCommonInfo->open_type == (int) MENU_OPEN_DNG_TREE_MAP) {
        return 2;
    }

    if (MenuCommonInfo->open_type == (int) MENU_OPEN_MAIN_DUNGEON || TreeMapCallDungeonSubMap == 1) {
        return 1;
    }

    return 0;
}

extern char *name_tbl_2728[8];

void MakeDngTreeMapJumpNo(int dng_no, int floor_id, int *loop_no, int *map_no) {
    if (dng_no == 0 && floor_id == 8) {
        *loop_no = 1;
        *map_no = SearchMapNo("s01");
    }

    if (dng_no == 1 && floor_id == 6) {
        *loop_no = 1;
        *map_no = SearchMapNo("s05");
    }

    if (dng_no == 3 && floor_id == 20) {
        *loop_no = 1;
        *map_no = SearchMapNo("d04b01");

        if (CheckBitFlagMenu(0x1B6) != 0 && CheckBitFlagMenu(0x1BC) == 0) {
            *loop_no = 2;
            *map_no = dng_no;
        }
    }

    if (floor_id == 0) {
        *loop_no = 1;
        *map_no = SearchMapNo(name_tbl_2728[dng_no]);

        if (dng_no == 6) {
            CScene *scene = GetMainScene();
            scene->SetNowMapNo(SearchMapNo("d07f01"));
        }
    }
}

extern CDngFreeMap *MenuDngMap;
extern u_long128   *MenuCursorDataBuff;
extern mgCTexture  *Floor_InfoTex;
extern s8           maxidtable_2752[7];
extern char         at_2681[];
extern char         at_2786[];
extern char         at_2787__2[];
extern char         at_2788[];
extern char         at_2789[];
extern char         at_2790[];
extern int          DngInfoDrawAlpha;

void CMenuTreeMap::InitEnd() {
    BG_READ_INFO *read = GetReadBGFile(0);
    char          map_name[32];
    sprintf(map_name, at_2681, dng_no);
    int                block;
    mgCTextureManager *textures;
    u8                *map_img = (u8 *) GetPackFile((u_int *) read->buffer, map_name, NULL);
    block = tex_block[0];
    textures = &mgTexManager;
    MenuWorkTextureEnter(block, at_2786, 0x200, 0x100, 0x18);
    textures->EnterIMGFile(map_img, block, NULL, NULL);

    if (CheckDngTreeMapFuncType() == 2) {
        textures->EnterIMGFile((u8 *) MenuCursorDataBuff, block, NULL, NULL);
    }

    MenuDngMap->SetTextureInfo();
    Floor_InfoTex = textures->GetTexture(at_2787__2, -1);

    if (read != NULL) {
        script = (char *) GetPackFile((u_int *) read->buffer, at_2788, &script_size);
        MenuDngMap->floor_manager->CheckDrawGlidInfo();
        int room_no = MenuSaveDataDungeonPtr->floor_id[dng_no];

        if (room_no < 1) {
            room_no = 1;
        }

        if (maxidtable_2752[dng_no] < room_no) {
            room_no = 1;
        }

        MenuDngMap->SetUserGlid(room_no);
        select_glid = MenuDngMap->GetRoomGlid(room_no);

        if (select_glid == NULL) {
            select_glid = MenuDngMap->GetRoomGlid(room_no + 1);
        }

        int        active_room = room_no;
        GLID_INFO *marked = NULL;
        int        room_count = maxidtable_2752[dng_no];

        for (int i = 0; i < room_count; ++i) {
            GLID_INFO *cell = MenuDngMap->floor_manager->GetDngMapFloorGlidInfo(i);

            if (cell != NULL && cell->room.mark != 0) {
                active_room = cell->room.floor_id;
                marked = cell;
                break;
            }
        }

        if (select_glid != NULL &&
            ((select_glid->room.flag & DNGMAP_ROOM_FLAG_SUB) ||
             (select_glid->room.flag & DNGMAP_ROOM_FLAG_BOSS))) {
            marked = select_glid;
            active_room = room_no;
        }

        if (marked != NULL) {
            select_glid = marked;
        }

        MenuDngMap->ResetDngMapPos(active_room, 1);
        float position[2];
        MenuDngMap->CalcGlidPutPos(marked, position[0], position[1], 0);
        position[0] -= 30.0f;
        position[0] -= 20.0f;
        cursor_pos[0] = position[0];
        cursor_pos[1] = position[1];
        FadeInMenu(40, 0.0f);
        mes_data = (short *) GetPackFile((u_int *) read->buffer, at_2789, NULL);
        MsgInit();
        u_long128  buffer[0xA000 / sizeof(u_long128)];
        u_long128 *aligned = MenuCalcBufAlignment(buffer);
        char       treasure_name[64];
        sprintf(treasure_name, at_2790, dng_no + 1);
        int size;

        if (LoadFile2(treasure_name, aligned, &size, 0)) {
            CreatTresuarBoxInfo(&tresure, (char *) aligned, size);
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
extern short         TreeMapSaveDispY;
extern unsigned char TreeMapSaveFlag;

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
    ExeScript("MSG_INIT");
    CDC2Mes *message = MenuDCMsg[6];
    message->SetDrawSize(16, 20);
    message->ClsMes::mes_no = -1;
    message->MakeMsg(300);
    if (CheckDngTreeMapFuncType() == 2) {
        message->MakeMsg(81);
    } else if (CheckDngTreeMapFuncType() == 1) {
        message->MakeMsg(80);
    }
    message->StepMsg();
    int y = mgScreenHeight - 50;
    message->line_pos[0][0] = (mgScreenWidth >> 2) - (message->line_w[0] >> 1);
    message->line_pos[0][1] = y;
    message->line_pos_on[0] = 1;
    message->line_pos[1][0] = ((mgScreenWidth >> 2) * 3) - (message->line_w[1] >> 1);
    message->line_pos[1][1] = y;
    message->line_pos_on[1] = 1;
    TreeMapSaveDispY = y;
    if (TreeMapSaveFlag == 0) {
        message->line_pos[1][0] = 600;
        message->line_pos[1][1] = y;
        message->line_pos_on[1] = 1;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", MsgInit__12CMenuTreeMapFv);
#endif
#ifdef NONMATCHING
extern int             old_direction_2830;
extern s8              init_2831;
extern GLID_INFO      *old_glid_2833;
extern s8              init_2834;
extern GLID_INFO      *NextFloorGlid_2836;
extern s8              init_2837;
extern int             bitTable_2900[12];
extern s8              DngAskMessageDrawFlag;
extern u8              DngInfoFishOkFlag;
extern u8              DngInfoSphidaOkFlag;
extern u8              dngfloor_infoview;
extern u8              dngfloor_backdraw;
extern u8              GeoramaMateriaInfoDrawFlag;
extern s8              GeoramaMateriaInfoDrawPage;
extern int             DngInfoDrawAlpha;
extern DNG_FLOOR_SAVE *DngInfoFloorInfo;
/** Room whose floor-information activities are being shown. */
extern DNGMAP_ROOM_INFO *DngInfoRoomInfo;
extern int               MenuDngDebugFlagSelect;
extern float             DngTreeMapActiveLightRate;
extern char              at_3342[];
extern char              at_3343[];
extern char              at_3344[];
extern char              at_3345[];
extern char              at_3346[];
extern char              at_3347[];
extern char              at_3348[];
extern char              at_3349[];
extern char              at_3350[];

/** Number of georama parts listed for the selected dungeon floor. */
extern short GeoramaMateriaNum;

int CMenuTreeMap::Step() {
    int           result = 0;
    CMenuKeyFunc *keys = MenuCommonInfo;
    if (!init_2831) {
        old_direction_2830 = -1;
        init_2831 = 1;
    }
    if (!init_2834) {
        old_glid_2833 = NULL;
        init_2834 = 1;
    }
    CDC2Mes *message = MenuDCMsg[3];
    int      fade_done = FadeInOutMenu();
    MenuDngMap->Step();
    int read_busy = ReadBGSync();
    int selection_changed = 0;
    if (!init_2837) {
        NextFloorGlid_2836 = NULL;
        init_2837 = 1;
    }

    switch (mode) {
        case 1: {
            if (fade_done && !read_busy) {
                InitEnd();
                selection_changed = 1;
                cursor_reset = 1;
                old_direction_2830 = -1;
                old_glid_2833 = NULL;
            }
            break;
        }
        case 2: {
            if (fade_done) {
                DeleteTexBlock();
                ExeScript(at_3342);
                result = 1;
                if (MenuArg.end_code == 5) {
                    result = 2;
                    if (TreeMapCallDungeonSubMap) {
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
                    DNG_BATTLE_AREA *area = (DNG_BATTLE_AREA *) menu_GetBattleAreaScene();
                    if (area != NULL) {
                        area->floor_status &= 0xFFF8;
                    }
                }
                old_glid_2833 = NULL;
                old_direction_2830 = -1;
            }
            break;
        }
        case 12: {
            if (step == 0 && FadeCheckMenu()) {
                DngTreeMode = DNG_TREE_MODE_SAVE;
            }
            if (step == 1 && FadeCheckMenu()) {
                mode = 0;
            }
            break;
        }
        default: {
            keys->SelDataInit();
            keys->CheckSelectKey();
            int directions = keys->CheckLRKey();
            int buttons = keys->CheckPushButton();
            int action = -1;
            if (key_arg_no == 2) {
                if ((buttons & 4) || (buttons & 2)) {
                    action = 0x83;
                    MenuSePlay(1);
                }
            } else if (key_arg_no == 1) {
                if (!DngAskMessageDrawFlag) {
                    if (buttons) {
                        action = 0x78;
                    }
                } else if (!dngfloor_infoview) {
                    int cursor = message->YesNoCursor();
                    if (buttons & 1) {
                        action = cursor == 1 ? 0x78 : (cursor == 0 ? 0x6E : -1);
                    } else if (buttons & 2) {
                        action = 0x78;
                    }
                } else if (buttons & 1) {
                    action = CheckDngTreeMapFuncType() == 1 ? -1 : 0x6E;
                } else if (buttons & 2) {
                    action = 0x78;
                } else if ((buttons & 4) && GeoramaMateriaNum > 0) {
                    action = 0x82;
                }
            } else if (key_arg_no == 0) {
                if (menu_debug_flag) {
                    DNG_FLOOR_SAVE *floor = MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, select_glid->room.floor_id);
                    if (directions & 1) {
                        --MenuDngDebugFlagSelect;
                    }
                    if (directions & 2) {
                        ++MenuDngDebugFlagSelect;
                    }
                    if (MenuDngDebugFlagSelect < 0) {
                        MenuDngDebugFlagSelect = 0;
                    }
                    if (MenuDngDebugFlagSelect > 8) {
                        MenuDngDebugFlagSelect = 8;
                    }
                    if (MenuDngDebugFlagSelect == 0) {
                        if (((buttons & 1) || (directions & 8)) && floor != NULL && floor->visit_count < 30000) {
                            ++floor->visit_count;
                        }
                        if (((buttons & 2) || (directions & 4)) && floor != NULL && floor->visit_count) {
                            --floor->visit_count;
                        }
                    } else if (floor != NULL) {
                        if ((buttons & 1) || (directions & 8)) {
                            floor->flag |= bitTable_2900[MenuDngDebugFlagSelect];
                        }
                        if ((buttons & 2) || (directions & 4)) {
                            floor->flag &= ~bitTable_2900[MenuDngDebugFlagSelect];
                        }
                    }
                    if (buttons & 4) {
                        for (int id = 0;; ++id) {
                            DNG_FLOOR_SAVE *entry = MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, id);
                            if (entry == NULL) {
                                break;
                            }
                            if (entry->visit_count < 30000) {
                                ++entry->visit_count;
                            }
                            entry->flag = 0x1FB;
                        }
                    }
                    if ((buttons & 7) || (directions & 0xC)) {
                        MenuDngMap->floor_manager->CheckDrawGlidInfo();
                    }
                    if (directions & 0x20) {
                        MenuActiveSaveData->SetBitFlag(0xDC, 1);
                        MenuActiveSaveData->SetBitFlag(0x13D, 1);
                    }
                    return 0;
                }
                int dir = -1;
                if (directions & 1) {
                    dir = 0;
                } else if (directions & 2) {
                    dir = 1;
                } else if (directions & 4) {
                    dir = 2;
                } else if (directions & 8) {
                    dir = 3;
                }
                GLID_INFO *next = NULL;
                if (dir >= 0) {
                    next = MenuDngMap->floor_manager->GetKeyNextRoom(select_glid->room.floor_id, dir, old_glid_2833);
                }
                if (next != NULL && next != select_glid && next->room.unk_44 == 1) {
                    MenuSePlay(0);
                    old_glid_2833 = select_glid;
                    old_direction_2830 = -1;
                    select_glid = next;
                    MenuDngMap->SetNextRoomPos(next);
                    DngTreeMapActiveLightRate = 0.0f;
                    selection_changed = 1;
                }
                MenuDngMap->select_glid = select_glid;
                if (buttons == 4) {
                    if (!TreeMapSaveFlag) {
                        MenuSePlay(5);
                    } else {
                        FadeOutMenu(40, 0.0f);
                        mode = 12;
                        step = 0;
                        MenuSePlay(1);
                    }
                } else if (buttons == 8 || buttons == 2) {
                    int kind = CheckDngTreeMapFuncType();
                    action = 200;
                    if ((buttons == 8 && kind != 0) || (buttons == 2 && kind == 2)) {
                        action = 100;
                        NextFloorGlid_2836 = MenuDngMap->GetEntranceRoomGlid();
                    }
                } else if (buttons == 1) {
                    action = 100;
                    NextFloorGlid_2836 = select_glid ? select_glid : MenuDngMap->GetEntranceRoomGlid();
                    if (NextFloorGlid_2836 == MenuDngMap->GetEntranceRoomGlid() &&
                        ((MenuMainScene->active_map >= 0 && MenuMainScene->active_map < 11 &&
                          (GetMapType(MenuMainScene->now_map_no) == 2 ||
                           GetMapType(MenuMainScene->now_map_no) == 4 ||
                           GetMapType(MenuMainScene->now_map_no) == 6)) ||
                         (MenuMainScene->active_map == 1 && MenuMainScene->now_map_no == 100))) {
                        action = 200;
                    }
                }
            }
            DNG_FLOOR_SAVE *target_save = NextFloorGlid_2836 ? MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, NextFloorGlid_2836->room.floor_id) : NULL;
            if (action == 200) {
                MenuSePlay(5);
                FadeOutMenu(40, 0.0f);
                draw_hidden = 0;
                mode = 2;
                cursor_view = 0;
            } else if (action == 0x78) {
                MenuSePlay(5);
                key_arg_no = 0;
                dngfloor_infoview = 0;
                dngfloor_backdraw = 0;
                cursor_view = 1;
                money_view = 0;
            } else if (action == 0x83) {
                if (GeoramaMateriaNum < 15 || GeoramaMateriaInfoDrawPage) {
                    DngInfoDrawAlpha = 128;
                    key_arg_no = 1;
                    dngfloor_infoview = 1;
                    GeoramaMateriaInfoDrawFlag = 0;
                } else {
                    GeoramaMateriaInfoDrawPage = 1;
                }
            } else if (action == 0x82) {
                dngfloor_infoview = 0;
                dngfloor_backdraw = 1;
                GeoramaMateriaInfoDrawFlag = 1;
                GeoramaMateriaInfoDrawPage = 0;
                DngInfoDrawAlpha = 0;
                MenuSePlay(1);
                key_arg_no = 2;
            } else if (action == 0x6E) {
                MenuSePlay(1);
                if (jump_pay) {
                    int money = -MenuUserDataManPtr->money;
                    if (money < 0) {
                        ++money;
                    }
                    MenuUserDataManPtr->AddMoney(money >> 1);
                }
                MenuArg.result[1] = 0;
                MenuArg.end_code = 5;
                MenuArg.result[0] = 1;
                if (MenuDngMap->user_glid != NULL) {
                    MenuSaveDataDungeonPtr->stage_id = dng_no;
                    MenuArg.result[1] = MenuSaveDataDungeonPtr->prev_floor_id[dng_no];
                }
                MenuArg.result[2] = NextFloorGlid_2836->room.floor_id;
                bool jump_event = false;
                u32  room_flags = NextFloorGlid_2836->room.flag;
                if (room_flags & (DNGMAP_ROOM_FLAG_SUB | DNGMAP_ROOM_FLAG_BOSS)) {
                    if (dng_no == 1 && MenuArg.result[2] == 6) {
                        MenuMainScene->skip_play_bgm = 1;
                    } else {
                        jump_event = true;
                    }
                    MenuSaveDataDungeonPtr->SetFloorID(MenuArg.result[2]);
                }
                if (dng_no == 0 && ((MenuArg.result[2] == 3 && !CheckBitFlagMenu(0x66)) ||
                                    (MenuArg.result[2] == 8 && !CheckBitFlagMenu(0xC9)) || MenuArg.result[2] == 6)) {
                    jump_event = true;
                }
                if (dng_no == 1 && ((MenuArg.result[2] == 2 && !CheckBitFlagMenu(0xD4)) || MenuArg.result[2] == 14)) {
                    jump_event = true;
                }
                if (dng_no == 2 && ((MenuArg.result[2] == 2 && !CheckBitFlagMenu(0x133)) ||
                                    (MenuArg.result[2] == 21 && !CheckBitFlagMenu(0x158)) || MenuArg.result[2] == 22)) {
                    jump_event = true;
                }
                if (dng_no == 3 && ((MenuArg.result[2] == 2 && !CheckBitFlagMenu(0x196)) ||
                                    (MenuArg.result[2] == 17 && !CheckBitFlagMenu(0x1A8)) || MenuArg.result[2] == 19)) {
                    jump_event = true;
                }
                if ((dng_no == 4 && MenuArg.result[2] == 21) || (dng_no == 5 && MenuArg.result[2] == 26) ||
                    (dng_no == 6 && MenuArg.result[2] == 37)) {
                    jump_event = true;
                }
                if (jump_event) {
                    MenuMainScene->skip_load_bgm = 1;
                }
                draw_hidden = 0;
                mode = 2;
                FadeOutMenu(40, 0.0f);
            } else if (action == 100) {
                bool open_question = false;
                if (NextFloorGlid_2836 == NULL || (target_save != NULL && !(target_save->flag & 1))) {
                    MenuSePlay(5);
                } else if (CheckDngTreeMapFuncType() == 0 && TreeMapCallDungeonSubMap == 1) {
                    int loop_no, map_no;
                    MakeDngTreeMapJumpNo(dng_no, NextFloorGlid_2836->room.floor_id, &loop_no, &map_no);
                    if (map_no == MenuMainScene->now_map_no) {
                        MenuSePlay(5);
                    } else {
                        open_question = true;
                    }
                } else {
                    open_question = true;
                }
                if (open_question) {
                    selection_changed = 1;
                    DngAskMessageDrawFlag = 1;
                    if (CheckDngTreeMapFuncType() == 1 && !(NextFloorGlid_2836->room.flag & DNGMAP_ROOM_FLAG_START)) {
                        DngAskMessageDrawFlag = 2;
                    }
                    u32 flags = NextFloorGlid_2836->room.flag;
                    if (DngAskMessageDrawFlag == 2 && (flags & (DNGMAP_ROOM_FLAG_SUB | DNGMAP_ROOM_FLAG_BOSS | DNGMAP_ROOM_FLAG_EXIT))) {
                        MenuSePlay(5);
                        message->SetAbsPos(5);
                    } else {
                        MenuSePlay(0x13);
                        dngfloor_infoview = 1;
                        dngfloor_backdraw = 1;
                        DngInfoRoomInfo = &NextFloorGlid_2836->room;
                        DngInfoFloorInfo = target_save;
                        GetSaveData()->GetBitCtrl();
                        DNG_BATTLE_AREA *area = (DNG_BATTLE_AREA *) menu_GetBattleAreaScene();
                        jump_pay = (area->battle_clear == 0 && MenuCommonInfo->open_type == (int) MENU_OPEN_MAIN_DUNGEON && !TreeMapCallDungeonSubMap);
                        int mes_no = 0x3C;
                        if (flags & (DNGMAP_ROOM_FLAG_START | DNGMAP_ROOM_FLAG_SUB | DNGMAP_ROOM_FLAG_EXIT | DNGMAP_ROOM_FLAG_BOSS)) {
                            mes_no = 0x3D;
                            int name_id = NextFloorGlid_2836->room.floor_id + (dng_no + 1) * 1000;
                            message->SetMsgItemNo(&name_id, 1);
                        }
                        if (jump_pay) {
                            mes_no += 2;
                        }
                        message->SetAbsPos(-1);
                        int put_pos[2] = {0x3C, 0x118};
                        message->SetPutPos(put_pos);
                        message->ClsMes::mes_no = -1;
                        message->SetMsgCursor(0);
                        message->fade = 0.0f;
                        message->fade_speed = 0.1f;
                        for (int i = 0; i < 3; ++i) {
                            message->line_pos_on[i] = 0;
                        }
                        if (flags & (DNGMAP_ROOM_FLAG_START | DNGMAP_ROOM_FLAG_SUB | DNGMAP_ROOM_FLAG_EXIT | DNGMAP_ROOM_FLAG_BOSS)) {
                            message->abs_win.x = -1;
                            message->abs_win.y = -1;
                            message->SetAbsPos(5);
                            dngfloor_infoview = 0;
                        }
                        message->fuchi = 5;
                        message->font_w = 15;
                        message->SetMsgCursor(1);
                        message->MakeMsg(mes_no);
                        money_view = jump_pay ? 1 : 0;
                        GeoramaMateriaNum = 0;
                        if (dngfloor_infoview) {
                            message->fuchi = 0;
                            message->font_w = LanguageCode > 0 ? 17 : 8;
                            message->fade_speed = 1.0f;
                            message->fade = 1.0f;
                            message->select_top = -1;
                            message->SetMsgCursor(-1);
                            GeoramaMateriaNum = CheckGeoramaMateria(&tresure, select_glid->room.floor_id, georama_materia);
                            if (!(target_save->flag & 2)) {
                                GeoramaMateriaNum = 0;
                            }
                            message->line_pos[0][0] = 0x46;
                            message->line_pos[0][1] = mgScreenHeight - (GeoramaMateriaNum ? 0x46 : 0x32);
                            message->line_pos_on[0] = 1;
                            message->line_pos[1][0] = 0x14A;
                            message->line_pos[1][1] = mgScreenHeight - 0x32;
                            message->line_pos_on[1] = 1;
                            if (GeoramaMateriaNum) {
                                message->line_pos[2][0] = 0x46;
                                message->line_pos[2][1] = mgScreenHeight - 0x2C;
                                message->line_pos_on[2] = 1;
                            }
                            message->MakeMsg(GeoramaMateriaNum ? 0x41 : 0x40);
                            if (GeoramaMateriaNum && (LanguageCode == 4 || LanguageCode == 5)) {
                                message->line_pos[0][0] = message->line_pos[2][0] = 0x2E;
                                message->line_pos[1][0] = 0x160;
                            }
                            if (GeoramaMateriaNum && CheckDngTreeMapFuncType() == 1) {
                                message->line_pos[0][0] = message->line_pos[1][0] = 0x208;
                            }
                            money_view = 0;
                        }
                        cursor_view = 0;
                        key_arg_no = 1;
                    }
                }
            }
            break;
        }
    }
    if (select_glid != NULL && select_glid->type == GLID_TYPE_ROOM) {
        DngInfoFloorInfo = MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, select_glid->room.floor_id);
        if (selection_changed) {
            DNGMAP_ROOM_INFO *room = &select_glid->room;
            int               messages[8] = {room->floor_id + (dng_no + 1) * 1000, 0x96, 0x97, 0x98,
                                             0x99, room->practice_type + 100, 0x9B, 0x46};
            int               challenge_values[2] = {0, 0};
            if (room->practice_type == 0) {
                int seconds = room->practice_param / 60;
                challenge_values[0] = seconds / 60;
                challenge_values[1] = seconds % 60;
                if (challenge_values[1] == 0) {
                    messages[5] = 0x5A;
                } else {
                    messages[5] = 0x5B;
                }
                mes[5].SetMsgVolumeNo(challenge_values, 2);
            } else if (room->practice_type >= 1 && room->practice_type <= 4) {
                messages[5] = room->practice_param + 0x65;
            } else if (room->practice_type == 5) {
                messages[5] = 0x6C;
            }
            if (room->fishing < 0) {
                messages[3] = 0x79;
            }
            if (room->fishing > 0) {
                messages[3] = 0x78;
            }
            mes[3].SetMsgVolumeNoOne(room->fishing_record);
            DngInfoFishOkFlag = CheckBitFlagMenu(0xDC) != 0;
            DngInfoSphidaOkFlag = CheckBitFlagMenu(0x13D) != 0;
            if (!DngInfoFishOkFlag) {
                messages[3] = 2;
            }
            if (!DngInfoSphidaOkFlag) {
                messages[4] = 2;
            }
            int prize_no = (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_SPHEDA_CLEAR) ? 0x28 : 41;
            mes[4].SetMsgItemNo(&prize_no, 1);
            int spheda_no = (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_PRACTICE_CLEAR) ? 0x28 : 0x29;
            mes[5].SetMsgItemNo(&spheda_no, 1);
            if (CheckNowEurope()) {
                mes[6].value_half = 1;
            }
            mes[6].SetMsgVolumeNoOne(DngInfoFloorInfo->kill_count);
            int best_time = DngInfoFloorInfo->fast_destroy_time;
            int target_time = room->fast_destroy_time;
            int minutes = (best_time > 0 && best_time < target_time ? best_time : target_time) / 60;
            if (!(DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_FAST_DESTROY_CLEAR)) {
                messages[1] = 0x9A;
            }
            int  seconds = minutes % 60;
            int  hours = minutes / 60;
            char time_text[72];
            if (hours >= 100) {
                strcpy(time_text, CheckNowEurope() ? at_3344 : at_3343);
            } else if (!CheckNowEurope()) {
                if (hours < 10) {
                    strcpy(time_text, at_3349);
                } else {
                    strcpy(time_text, GetMenuBigNum(hours / 10));
                }
                strcat(time_text, GetMenuBigNum(hours % 10));
                strcat(time_text, at_3350);
                if (seconds < 10) {
                    strcat(time_text, at_3349);
                } else {
                    strcat(time_text, GetMenuBigNum(seconds / 10));
                }
                strcat(time_text, GetMenuBigNum(seconds % 10));
            } else if (hours < 10 && seconds < 10) {
                sprintf(time_text, at_3345, hours, seconds);
            } else if (hours < 10) {
                sprintf(time_text, at_3346, hours, seconds / 10, seconds % 10);
            } else if (seconds < 10) {
                sprintf(time_text, at_3347, hours, seconds);
            } else {
                sprintf(time_text, at_3348, hours, seconds / 10, seconds % 10);
            }
            char *time_ptr = time_text;
            mes[1].SetMsgItemNo(&time_ptr, 1);
            messages[7] = (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_GEOSTONE_FOUND) ? 0x46 : 0x47;
            if (!room->geostone) {
                messages[7] = 2;
            }
            for (int i = 0; i < 8; ++i) {
                mes[i].MakeMsg(messages[i]);
                mes[i].line_pos[0][0] = 600;
                mes[i].line_pos[0][1] = 10;
                mes[i].line_pos_on[0] = 1;
                mes[i].line_pos[1][0] = 600;
                mes[i].line_pos[1][1] = 10;
                mes[i].line_pos_on[1] = 1;
            }
        }
    }
    return result;
}

#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", Step__12CMenuTreeMapFv);
#endif
/** Floor-information message windows attached to the tree map. */
extern CDC2Mes *MenuDngMes[DNG_TREE_MAP_MES_MAX];
/** Floor map drawn behind the tree-map menu. */
extern CDngFreeMap *MenuDngMap;
/** Non-zero while the selected floor's information is visible. */
extern unsigned char dngfloor_infoview;
/** Non-zero while the floor-information backdrop fades in. */
extern unsigned char dngfloor_backdraw;
/** Current opacity of the floor-information backdrop. */
extern int dngfloor_backdraw_alpha;
/** Non-zero while the selected floor's georama materials are visible. */
extern unsigned char GeoramaMateriaInfoDrawFlag;
/** Visibility state of the question about jumping to the selected floor. */
extern s8 DngAskMessageDrawFlag;
/** Resting vertical position of the animated save prompt. */
extern short TreeMapSaveDispY;
/** Number of georama materials available on the selected floor. */
extern short GeoramaMateriaNum;
/** Frame counter of the save prompt's animation. */
extern short TreeMapSaveDispCount;
/** Number displayed in the save prompt. */
extern short TreeMapSaveNum;
/** Sine phase of the save prompt's vertical animation. */
extern float TreeMapSaveHopCount;

void CMenuTreeMap::Draw() {
    if ((mode & 2) && draw_hidden == 1) {
        return;
    }

    MenuDngMap->Draw();
    int show_help = 0;

    if (help_view != 0 && dngfloor_infoview == 0 && key_arg_no == 0) {
        show_help = 1;
    }

    if (menu_debug_flag != 0) {
        show_help = 0;
    }

    mgCTextureManager *textures = &mgTexManager;
    mgCDrawPrim       *prim = GetMenuPrim();

    if (show_help) {
        textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
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

                MenuDCMsg[6]->SetMovePosGyou(1, MenuDCMsg[6]->line_pos[1][0],
                                             (int) ((float) TreeMapSaveDispY - 10.0f * sinf(TreeMapSaveHopCount)));
            }
        }
    }

    if (MenuDngMap->select_glid != NULL) {
        if (dngfloor_backdraw != 0) {
            CalcMenuAdd(&dngfloor_backdraw_alpha, 3, 64);
        } else {
            CalcMenuAdd(&dngfloor_backdraw_alpha, -3, 0);
        }

        DrawMenuFillBox(dngfloor_backdraw_alpha, 0, 0, 0);
        int number_x = 540;
        int number_y = 0;
        int number_alpha = 0;
        int medal = GetUserDataMan()->GetYarikomiMedal();

        if (Floor_InfoTex != NULL) {
            textures->ReloadTexture(Floor_InfoTex->block, (sceVif1Packet *) NULL);
            int alpha = dngfloor_backdraw_alpha * 2;
            SetSpriteEnv(prim, 0);
            prim->Begin(6);
            prim->Texture(Floor_InfoTex);
            prim->Color(0, 0, 0, alpha / 3);
            PrimQuad(prim, 289.0f, 25.0f, mgRect<int>(0, 182, 164, 56));
            prim->Color(128, 128, 128, alpha);
            PrimQuad(prim, 286.0f, 22.0f, mgRect<int>(0, 182, 164, 56));
            prim->End();
            number_x = 410 - GetNumberKeta(medal) * 16;
            number_y = 39;
            number_alpha = dngfloor_backdraw_alpha * 2;
        }

        DrawDngRoomInfo(&MenuDngMap->select_glid->room);

        if (GeoramaMateriaInfoDrawFlag != 0 && Floor_InfoTex != NULL) {
            DrawGeoramaMateria(94, MenuDngMap->select_glid->room.title,
                               GeoramaMateriaNum, georama_materia, Floor_InfoTex->block);
        }

        MenuDngMap->DrawDngName(128);
        textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
        CMenuFont font;
        font.alpha = number_alpha;
        char number[32];
        SetMenuBigNum(number, medal);
        font.SetStr(number);
        font.SetPos(number_x, number_y);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);

        for (int i = 0; i < DNG_TREE_MAP_MES_MAX; i++) {
            MenuDngMes[i]->StepMsg();
            MenuDngMes[i]->DrawMsg();
        }
    }

    mgRect<int> number_rect;
    float       pos[2];
    MenuDngMap->CalcGlidPutPos(select_glid, pos[0], pos[1], 0);
    pos[0] -= 58.0f;
    pos[1] -= 8.0f;
    cursor_pos[0] += (pos[0] - cursor_pos[0]) / 4.0f;
    cursor_pos[1] += (pos[1] - cursor_pos[1]) / 4.0f;

    if (cursor_reset != 0) {
        cursor_pos[0] = pos[0];
        cursor_pos[1] = pos[1];
        cursor_reset = 0;
    }

    int cursor_alpha;

    if (mode == 1) {
        cursor_alpha = 0;
    } else {
        cursor_alpha = 128;

        if (mode == 2) {
            cursor_alpha = 0;
        }
    }

    if (cursor_view != 0) {
        mgCTexture *cursor = textures->GetTexture("mnmain", -1);

        if (cursor == NULL) {
            return;
        }

        textures->ReloadTexture(cursor->block, (sceVif1Packet *) NULL);
        MenuCursorDraw(cursor, cursor_pos, 0.0f, cursor_alpha);
    }

    if (money_view != 0 && Floor_InfoTex != NULL) {
        textures->ReloadTexture(Floor_InfoTex->block, (sceVif1Packet *) NULL);
        SetSpriteEnv(prim, 0);
        int y_money = mgScreenHeight - 76;
        prim->Begin(6);
        prim->Texture(Floor_InfoTex);
        prim->Color(128, 128, 128, 128);
        PrimQuad(prim, 302.0f, (float) y_money, mgRect<int>(0, 144, 184, 36));
        number_rect.Set(0, 126, 12, 18);
        prim->Color(128, 128, 128, 128);
        PrimDrawNumber(prim, GetUserDataMan()->money, (int) MENU_NUMBER_ALIGN_RIGHT, 426, y_money + 7,
                       number_rect, -1, 0);
        prim->End();
    }

    textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);

    if (key_arg_no == 1 && DngAskMessageDrawFlag == 1) {
        MenuDCMsg[3]->StepMsg();
        MenuDCMsg[3]->DrawMsg();
    }
}

int CMenuTreeMap::FadeInOutMenu() {
    int done = 0;

    switch (mode) {
        case 1:
            done = FadeCheckMenu();

            if (done != 0) {
                FadeOutMenu(40, 0.0f);
            }

            break;
        case 2:
            if (draw_hidden == 0) {
                done = FadeCheckMenu();
            }

            break;
    }

    return done;
}
#ifdef NONMATCHING
/** Arena used for tree-menu objects and files. */
extern mgCMemory MenuTreeMapStack;
/** Tree map menu attached to the active dungeon screen. */
extern CMenuTreeMap *CMenuTreePt;
/** Floor map drawn and moved by the tree menu. */
extern CDngFreeMap *MenuDngMap;
/** Message windows belonging to the active tree map. */
extern CDC2Mes *MenuDngMes[8];
/** Loaded image data for the tree-menu cursor. */
extern u_long128 *MenuCursorDataBuff;
/** Room whose floor-information activities are being shown. */
extern DNGMAP_ROOM_INFO *DngInfoRoomInfo;
/** Opacity of the floor-information backdrop. */
extern int dngfloor_backdraw_alpha;
/** Enables the selected floor information. */
extern u8 dngfloor_infoview;
/** Enables the floor-information backdrop. */
extern u8 dngfloor_backdraw;
/** Animation timer of the tree-menu save prompt. */
extern s16 TreeMapSaveDispCount;
/** Dungeon used by the floor-information panel. */
extern u8 DngInfoStageNo;

/**
 *
 * Carries the two file names read while opening the dungeon tree map.
 *
 */
struct DngTreeReadNames {
    char *name[2]; /**< Menu data file and optional second file. */
};

STATIC_ASSERT(sizeof(DngTreeReadNames) == 8);

/** Empty filename pair used to initialize the menu data request. */
extern DngTreeReadNames at_3478;

/**
 *
 * Creates the tree map and attaches its floor-information message windows.
 *
 */
inline CMenuTreeMap::CMenuTreeMap() {
    draw_hidden = 0;
    select_glid = NULL;
    mes_data = NULL;
    key_arg_no = 0;
    help_view = 1;
    cursor_reset = 0;
    money_view = 0;
    tresure_loaded = 0;
    for (int i = 0; i < DNG_TREE_MAP_MES_MAX; i++) {
        MenuDngMes[i] = &mes[i];
        MenuDngMes[i]->Init();
        MenuDngMes[i]->SetBuff_system(GetSystemMesBuffer());
    }
    MenuDngMes[1]->value_space = 0x10;
}

void DngTreeMapInit(mgCMemory *stack, int *tex_block, int menu_mode, int dng_no) {
    int remaining = stack->stGetRest();
    MenuTreeMapStack.stSetBuffer(stack->stGetTop(), remaining);
    MenuTreeMapStack.Align64();
    CMenuTreePt = new (MenuTreeMapStack.Alloc(0x2FC0)) CMenuTreeMap;
    CMenuTreePt->SetTexBlock(tex_block);
    MenuDngMap = new (MenuTreeMapStack.Alloc(0x13)) CDngFreeMap;
    MenuDngMap->save_dungeon = MenuSaveDataDungeonPtr;
    DNG_BATTLE_AREA *area = (DNG_BATTLE_AREA *) menu_GetBattleAreaScene();
    MenuDngMap->floor_manager = &area->floor_manager;
    DngTreeMode = DNG_TREE_MODE_MAP;
    DngInfoRoomInfo = 0;
    dngfloor_backdraw_alpha = 0;
    bool separate_map = menu_mode == 3 || menu_mode == 0;
    if (separate_map) {
        MenuTreeMapStack.Align64();
        MenuCursorDataBuff = MenuTreeMapStack.stGetTop();
        unsigned int size = LoadFileMenu("frametex.img", MenuCursorDataBuff, 1);
        MenuTreeMapStack.Alloc((size & 15) ? (size >> 4) + 1 : size >> 4);
        CMenuTreePt->FadeOutMenu(1, 0.0f);
        if (GetNowLoopNo() == (int) LOOP_EDIT || menu_mode == 0) {
            MenuDngMap->floor_manager->LoadDataTable(dng_no, &MenuTreeMapStack);
            MenuDngMap->floor_manager->CheckDrawGlidInfo();
            MenuTreeMapStack.Alloc(0x800);
            MenuTreeMapStack.Align64();
        }
    } else {
        if (MenuCommonInfo->cursor_form != NULL) {
            MenuCommonInfo->cursor_form->draw_flag = 0;
        }
        MenuCommonInfo->SetVibeCnt(0, 0);
        MenuCommonInfo->SetWakuType(-1);
        MenuCommonInfo->key_enable = 0;
        MenuCommonInfo->cursor = 0;
        MenuCommonInfo->top_line = 0;
        CMenuTreePt->FadeOutMenu(30, 0.0f);
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
    char filename[40];
    sprintf(filename, "dmap%d.pac", dng_no);
    DngTreeReadNames names = at_3478;
    names.name[0] = filename;
    MenuCommonReadData(&MenuTreeMapStack, names.name, 0);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dngmenu", DngTreeMapInit__FP9mgCMemoryPiii);
#endif
extern mgCMemory    MenuTreeMapStack;
extern CDngFreeMap *MenuDngMap;

int DngTreeMapKey() {
    int result = 0;

    if (DngTreeMode == DNG_TREE_MODE_MAP) {
        result = CMenuTreePt->Step();

        if (DngTreeMode == DNG_TREE_MODE_SAVE) {
            SetDngTreeFlag(1);
            SaveMapInfo(MenuDngMap->dng_no);
            NowProgramLoopNo = 2;
            mgCMemory  save_stack;
            int        rest = MenuTreeMapStack.stGetRest();
            u_long128 *top = MenuTreeMapStack.stGetTop();
            save_stack.stSetBuffer(top, rest);
            MenuSaveInit(&save_stack, &CMenuTreePt->tex_block[3], 7);
        }
    } else if (DngTreeMode == DNG_TREE_MODE_SAVE) {
        result = MenuSaveKey();

        if (result != 0) {
            SetDngTreeFlag(0);
            DngTreeMode = DNG_TREE_MODE_MAP;
            result = 0;
            CMenuTreePt->FadeInMenu(40, 0.0f);
            CMenuTreePt->mode = 12;
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

int CBaseMenuClass::IsCreateObject(int select_key, int push_button) { return 1; }

int CBaseMenuClass::IsMakeObject(int select_key, int push_button) { return 0; }

int CBaseMenuClass::IsAskExtend(int select_key, int push_button) { return 0; }

int CBaseMenuClass::ItemCmdAfter(int cmd_ret, ITEMCMD_RET_PARA *ret) { return 0; }

void CBaseMenuClass::ExitEnd() {}

template <>
void mgRect<float>::Set(float new_left, float new_top, float new_right, float new_bottom) {
    left = new_left;
    top = new_top;
    right = new_right;
    bottom = new_bottom;
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
const mgRect<int> dng_light_circle(388, 304, 124, 80);
const mgRect<int> dngfreemap_num(0, 0, 12, 18);
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
mgRect<float> treemap_root_put;
mgRect<int>   Floor_Info(0, 238, 256, 18);
mgCMemory     MenuTreeMapStack;
INCLUDE_BSS(at_3142, 0x10);
