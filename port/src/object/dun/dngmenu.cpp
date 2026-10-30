#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <format>

#include "text/bounded.hpp"

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
#include "pal_timing.hpp"
#include "savedata.hpp"
#include "savedatadungeon.hpp"
#include "scenesnd.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"
#undef MES_WINDOW_OUT_OF_LINE_INIT

/**
 *
 * Draws the selected room's floor information and completion medals.
 *
 * @mangled DrawDngRoomInfo__FP16DNGMAP_ROOM_INFO
 * @address 0x1EE0F0
 * @size 0xB18
 */
static void DrawDngRoomInfo(DNGMAP_ROOM_INFO *room);

/**
 *
 * Draws a paged list of georama materials for the dungeon room.
 *
 * @mangled DrawGeoramaMateria__FiPciPii
 * @address 0x1EEC10
 * @size 0x400
 */
static void DrawGeoramaMateria(int top_y, char *title, int unused_count, int *items, int tex_block);

/**
 *
 * Selected floor-save flag in the map debug panel.
 *
 */
static int MenuDngDebugFlagSelect;

/**
 *
 * Floor map attached to the active dungeon menu.
 *
 */
static CDngFreeMap *MenuDngMap;

/**
 *
 * Non-zero while the chosen floor's information panel is shown.
 *
 */
static u8 dngfloor_infoview;

/**
 *
 * Enables the floor-information backdrop.
 *
 */
static u8 dngfloor_backdraw;

/**
 *
 * Opacity of the floor-information backdrop.
 *
 */
static int dngfloor_backdraw_alpha;

/**
 *
 * Texture used by the floor-information frame.
 *
 */
static mgCTexture *Floor_InfoTex;

/**
 *
 * Indicates that fishing tests are unlocked.
 *
 */
static u8 DngInfoFishOkFlag;

/**
 *
 * Indicates that spheda tests are unlocked.
 *
 */
static u8 DngInfoSphidaOkFlag;

/**
 *
 * What the tree map shows once a floor has been chosen, a DNG_TREE_MAP_ASK.
 *
 */
static s8 DngAskMessageDrawFlag;

/**
 *
 * Save record of the floor shown by the information panel.
 *
 */
static DNG_FLOOR_SAVE *DngInfoFloorInfo;

/**
 *
 * Room shown by the floor-information panel.
 *
 */
static DNGMAP_ROOM_INFO *DngInfoRoomInfo;

/**
 *
 * Opacity of the selected floor information.
 *
 */
static int DngInfoDrawAlpha;

/**
 *
 * Position of the medal-count message.
 *
 */
static int DngInfoMedalMsgPutPos[2];

/**
 *
 * Enables the georama material list.
 *
 */
static u8 GeoramaMateriaInfoDrawFlag;

/**
 *
 * Page displayed by the georama material list.
 *
 */
static s8 GeoramaMateriaInfoDrawPage;

/**
 *
 * Number of georama materials collected for the floor.
 *
 */
static short GeoramaMateriaNum;

/**
 *
 * Brightness of the active dungeon tree selection.
 *
 */
static float DngTreeMapActiveLightRate;

/**
 *
 * Animation counter of the player marker.
 *
 */
static int dng_player_blink_cnt;

/**
 *
 * Selects the tree map or its save menu.
 *
 */
static short DngTreeMode;

/**
 *
 * Indicates that the tree map is open for saving.
 *
 */
u8 TreeMapSaveFlag;

/**
 *
 * Counts saves made through the tree map.
 *
 */
s16 TreeMapSaveNum;

/**
 *
 * Animation timer of the tree-menu save prompt.
 *
 */
static short TreeMapSaveDispCount;

/**
 *
 * Phase of the tree-menu save prompt hop.
 *
 */
static float TreeMapSaveHopCount;

/**
 *
 * Vertical position of the tree-menu save prompt.
 *
 */
static short TreeMapSaveDispY;

/**
 *
 * Requests the dungeon submap through the tree menu.
 *
 */
u8 TreeMapCallDungeonSubMap;

/**
 *
 * Records that the world map opened the tree menu.
 *
 */
u8 TreeMapCalledWorldMap;

/**
 *
 * Loaded image data for the tree-menu cursor.
 *
 */
static u8 *MenuCursorDataBuff;

/**
 *
 * Tree map menu attached to the active dungeon screen.
 *
 */
static CMenuTreeMap *CMenuTreePt;

/**
 *
 * Message windows belonging to the active tree map.
 *
 */
static CDC2Mes *MenuDngMes[DNG_TREE_MAP_MES_MAX];

void CDngFreeMap::Initialize() {
    active = true;
    unk_9 = 0;
    dng_no = 0;
    floor_manager = nullptr;
    save_dungeon = nullptr;
    mode = DNGMAP_MODE_MENU;
    view_rect.Set(120.0f, 138.0f, 420.0f, 286.0f);
    mark_num = 0;
    next_room_no = -1;
    user_room_no = -1;
    back_scroll = 0.0f;
    pos_x = pos_y = 0.0f;
    next_pos_x = 200.0f;
    next_pos_y = 200.0f;
    select_glid = nullptr;
    InitTexture();
    alpha = 128.0f;
    user_glid = nullptr;
    blink_cnt = 0;
    koma_now = nullptr;
    koma_path = nullptr;
    koma_move = false;
    fade_mode = DNGMAP_FADE_NONE;
    fade_time = -1;
    fade_step = 0.0f;
}

void CDngFreeMap::InitTexture() {
    map_tex = nullptr;
    last_tex = nullptr;
    koma_tex = nullptr;
    name_tex = nullptr;
    tex_block = -1;
}

void CDngFreeMap::SetUserGlid(int room_no) {
    user_glid = nullptr;

    if (0 <= room_no) {
        user_glid = GetRoomGlid(room_no);
    }
}

void CDngFreeMap::CalcGlidPutPos(GLID_INFO *glid, float &x, float &y, int board) {
    if (glid != nullptr) {
        x = static_cast<float>(glid->x * 52 + glid->y * -16);
        y = static_cast<float>(glid->y * 20);

        if (!board) {
            x += pos_x;
            y += pos_y;
        }
    }
}

void CDngFreeMap::CheckIsViewMove(int x, int y, float &move_x, float &move_y) {
    int clipped_x = x;
    int clipped_y = y;

    if (static_cast<float>(x) < view_rect.left) {
        clipped_x = static_cast<int>(view_rect.left);
    }

    if (view_rect.right + -10.0f < static_cast<float>(clipped_x)) {
        clipped_x = static_cast<int>(view_rect.right + -10.0f);
    }

    if (static_cast<float>(y) < view_rect.top) {
        clipped_y = static_cast<int>(view_rect.top);
    }

    if (view_rect.bottom < static_cast<float>(clipped_y - 10)) {
        clipped_y = static_cast<int>(view_rect.bottom + -10.0f);
    }

    move_x = static_cast<float>(clipped_x - x);
    move_y = static_cast<float>(clipped_y - y);
}

void CDngFreeMap::SetNextRoomPos(GLID_INFO *glid) {
    if (glid != nullptr) {
        float x = {}, y = {}, move_x = {}, move_y = {};
        CalcGlidPutPos(glid, x, y, 0);
        CheckIsViewMove(static_cast<int>(x), static_cast<int>(y), move_x, move_y);
        next_pos_x = pos_x + move_x;
        next_pos_y = pos_y + move_y;
    }
}

GLID_INFO *CDngFreeMap::GetNextGlid(GLID_INFO *glid, int *direction) {
    if (glid == nullptr || floor_manager == nullptr) {
        return nullptr;
    }

    return floor_manager->GetNextGlid(glid, direction);
}

GLID_INFO *CDngFreeMap::GetRoomGlid(int room_no) {
    return floor_manager != nullptr ? floor_manager->GetDngMapFloorGlidInfo(room_no) : nullptr;
}

GLID_INFO *CDngFreeMap::GetEntranceRoomGlid() {
    if (floor_manager == nullptr) {
        return nullptr;
    }

    for (int i = 0; i < floor_manager->glid_num; i++) {
        GLID_INFO *glid = &floor_manager->glid_info[i];

        if (glid->type == GLID_TYPE_ROOM && (glid->room.flag & DNGMAP_ROOM_FLAG_START)) {
            return glid;
        }
    }

    return nullptr;
}

void CDngFreeMap::SetTextureInfo() {
    map_tex = mgTexManager.GetTexture("dt", -1);
    last_tex = mgTexManager.GetTexture("dtbg", -1);
    koma_tex = mgTexManager.GetTexture("dngop", -1);
    name_tex = mgTexManager.GetTexture("dtname", -1);
}

void CDngFreeMap::ResetDngMapPos(int room_no, int at_once) {
    GLID_INFO *glid = GetRoomGlid(room_no);

    if (glid != nullptr) {
        float board_pos[2];
        float unused_x = {}, unused_y = {};
        float left = {}, top = {}, right = {}, bottom = {};
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

        if (at_once) {
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

        SetSpriteEnv(prim, MENU_SPRITE_ENV_COLOR_AA);
        prim->Bilinear(1);
        prim->AntiAliasing(1);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Color(0, 0, 0, 32);
        prim->Vertex(0, 0, 0);
        prim->Vertex(mgScreenWidth, mgScreenHeight, 0);
        prim->End();
    }

    if (mode == DNGMAP_MODE_MENU && map_tex != nullptr) {
        mgRect<int> tile;
        tile.Set(0, 256, 128, 128);
        DrawMenuTilePattern(prim, map_tex, back_scroll, back_scroll, tile, 1, nullptr);
        back_scroll += 0.5f;

        if (!(back_scroll < 0.0f)) {
            back_scroll -= static_cast<float>(tile.right);
        }
    }
}

void CDngFreeMap::DrawDngName(int opacity) {
    if (name_tex != nullptr) {
        mgRect<int> tex_rect;
        tex_rect.Set(0, 0, 256, 96);
        mgCDrawPrim *prim = GetMenuPrim();
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(name_tex);
        prim->Color(10, 10, 10, static_cast<int>(0.25f * static_cast<float>(opacity)));
        PrimQuad(prim, 4.0f, 4.0f, tex_rect);
        prim->Color(128, 128, 128, 128);
        PrimQuad(prim, 0.0f, 0.0f, tex_rect);
        prim->End();
    }
}

void CDngFreeMap::DrawLast() {
    if (last_tex == nullptr || mode == DNGMAP_MODE_EVENT) {
        return;
    }

    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_ADD);
    prim->AlphaBlend(1);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(last_tex);
    prim->Color(128, 128, 128, 128);
    prim->TextureCrd(0, 0);
    prim->Vertex(0, 0, 0);
    prim->TextureCrd(128, 128);
    prim->Vertex(mgScreenWidth, mgScreenHeight, 0);
    prim->End();
}

/**
 *
 * Offset of a passage mark from its grid cell.
 *
 */
struct RootMarkOffset {
    s16 x; /**< Horizontal position of the mark inside its grid cell. */
    s16 y; /**< Vertical position of the mark inside its grid cell. */
};

/**
 *
 * Offsets of the passage marks within each passage shape.
 *
 */
static RootMarkOffset markOffsetTable_1092[10] = {
    {6, -2},
    {4, -2},
    {4, -2},
    {4, -2},
    {4, -2},
    {4, -2},
    {4, -2},
    {4, -2},
    {4, -2},
    {4, -2}
};

/**
 *
 * Offset of the special passage mark in dungeon six.
 *
 */
static RootMarkOffset zerumaito_offset_1110 = {
    13, -11};

/**
 *
 * Texture coordinates of the passage-type marks.
 *
 */
static s16 root_type_texturecrd_1216[5][2] = {
    {0,   0 },
    {490, 0 },
    {490, 22},
    {490, 44},
    {294, 18}
};

unsigned int CDngFreeMap::DrawGlidCheck(GLID_INFO *glid) {
    unsigned int marks = {};

    if (glid == nullptr) {
        return 0;
    }

    marks = 0;

    for (int direction = 0; direction < GLID_DIR_NUM; direction++) {
        GLID_INFO *neighbour = glid->link_glid[direction];

        if (neighbour == nullptr || glid->type != GLID_TYPE_ROOT || neighbour->type != GLID_TYPE_ROOM) {
            continue;
        }

        if (direction == GLID_DIR_UP && neighbour->y + 1 == glid->y) {
            marks |= DNGMAP_GLID_MARK_ROOM_UP;
        }

        if (direction == GLID_DIR_LEFT && neighbour->x + 1 == glid->x) {
            marks |= DNGMAP_GLID_MARK_ROOM_LEFT;
        }

        if ((neighbour->room.flag & DNGMAP_ROOM_FLAG_SUB) || (neighbour->room.flag & DNGMAP_ROOM_FLAG_BOSS)) {
            if (!neighbour->room.visited) {
                continue;
            }

            if (neighbour->x == glid->x) {
                if (neighbour->y == glid->y - 1) {
                    marks |= DNGMAP_GLID_MARK_SPECIAL_UP;
                }

                if (neighbour->y == glid->y + 1) {
                    marks |= DNGMAP_GLID_MARK_SPECIAL_DOWN;
                }
            }

            if (neighbour->y == glid->y) {
                if (neighbour->x == glid->x - 1) {
                    marks |= DNGMAP_GLID_MARK_SPECIAL_LEFT;
                }

                if (neighbour->x == glid->x + 1) {
                    marks |= DNGMAP_GLID_MARK_SPECIAL_RIGHT;
                }
            }
        }
    }

    return marks;
}

/**
 *
 * Offset of a room's letter or symbol within its picture.
 *
 */
struct RoomGlyphOffset {
    s16 x; /**< Horizontal glyph offset within the room picture. */
    s16 y; /**< Vertical glyph offset within the room picture. */
};

/**
 *
 * Texture rectangles of the visited-room labels.
 *
 */
static s16 get_moji_tbl_1524[16] = {
    0, 172, 62, 22, 0, 194, 62, 20, 0, 216, 62, 20, -1, 0, 0, 0};

/**
 *
 * Destination offsets of the visited-room labels.
 *
 */
static RoomGlyphOffset put_moji_tbl_1525[4] = {
    {20, -7},
    {20, -7},
    {20, 0 },
    {10, 10}
};

/**
 *
 * Room-mark animation speed in menu and event modes.
 *
 */
static float stepCntTbl_1501[2] = {
    0.0628318563f, 0.125663713f};

void CDngFreeMap::DrawGlid(mgRect<float> rect) {
    mgCDrawPrim prim;
    SetSpriteEnv(&prim, MENU_SPRITE_ENV_COLOR);
    prim.AntiAliasing(1);
    prim.Begin(MG_PRIM_LINE_STRIP);
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
    if (info == nullptr) {
        return 0;
    }

    if (floor_no < 0) {
        return 0;
    }

    int                floor_group = {};
    int                count = 0;
    TRESURE_BOX_FLOOR *floor = &info->floor[floor_no];

    for (floor_group = 0; floor_group < floor->group_num; floor_group++) {
        int group_index = {};
        int group_id = floor->group_id[floor_group];

        if (group_id < 0) {
            break;
        }

        TRESURE_BOX_GROUP *group = nullptr;

        for (group_index = 0; group_index < info->group_num; group_index++) {
            if (group_id == info->group[group_index].group_id) {
                group = &info->group[group_index];
                break;
            }
        }

        if (group != nullptr) {
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

/**
 *
 * Screen position of the medal-count message for each language, as X/Y pairs.
 *
 */
static short DngInfoMedalNumMsg[6][2] = {
    {330, 10},
    {330, 10},
    {330, 10},
    {330, 10},
    {330, 20},
    {330, 20}
};

/**
 *
 * Texture rectangles of the upper and middle floor-information frame.
 *
 */
static short dngboardbrdtbl[6][4] = {
    {0,  0, 24, 70},
    {24, 0, 8,  70},
    {32, 0, 24, 70},
    {58, 2, 24, 4 },
    {82, 2, 8,  4 },
    {90, 2, 24, 4 },
};

/**
 *
 * Texture rectangles of the floor-information frame with a geostone row.
 *
 */
static short dngboardbrdtbl_1[3][4] = {
    {58, 6, 24, 50},
    {82, 6, 8,  50},
    {90, 6, 24, 50},
};

/**
 *
 * Texture rectangles of the floor-information frame without a geostone row.
 *
 */
static short dngboardbrdtbl_2[3][4] = {
    {58, 22, 24, 36},
    {82, 22, 8,  36},
    {90, 22, 24, 36},
};

void DrawDngRoomInfo(DNGMAP_ROOM_INFO *room) {
    /**
     *
     * Texture X coordinates of the floor completion icons.
     *
     */
    static s16 medal_xytbl[5] = {168, 190, 212, 234, 146};

    if (room != nullptr && Floor_InfoTex != nullptr) {
        if (dngfloor_infoview) {
            CalcMenuAdd(&DngInfoDrawAlpha, 6, 128);
        } else {
            CalcMenuAdd(&DngInfoDrawAlpha, -8, 0);
        }

        int language = LanguageCode;
        int width = 0x19C;
        int height = 0xE4;

        if (language > LANG_JAPANESE) {
            width = 0x1D6;

            if (MenuDngMes[DNG_TREE_MAP_MES_PRACTICE] == nullptr || MenuDngMes[DNG_TREE_MAP_MES_PRACTICE]->ClsMes::mes_no != 0x6C) {
                height += 0x16;
            }
        }

        float left = {};
        float top = 92.0f;
        left = static_cast<float>((0x200 - width) >> 1);
        int center = mgScreenWidth >> 1;
        short (*bottom_table)[4] = dngboardbrdtbl_1;
        int               alpha = DngInfoDrawAlpha;
        DNGMAP_ROOM_INFO *shown = DngInfoRoomInfo;
        int               fill_alpha = (alpha * 7) / 10;

        if (shown != nullptr) {
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

        DrawMenuFillBox(left + 6.0f, top + 6.0f, static_cast<float>(width - 8), static_cast<float>(height - 8),
                        fill_alpha, 12, 12, 12);
        mgCDrawPrim *prim = GetMenuPrim();
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(Floor_InfoTex);
        prim->Color(128, 128, 128, alpha);
        int ix = static_cast<int>(left);
        int iy = {};
        Menu3DivideTextureDraw(prim, mgRect<int>(ix, iy = static_cast<int>(top), width, 0x46), dngboardbrdtbl[0], 1);
        Menu3DivideTextureDraw(prim, mgRect<int>(ix, iy + 0x46, width, height - 0x46 - dngboardbrdtbl[3][3]),
                               dngboardbrdtbl[3], 1);
        Menu3DivideTextureDraw(prim, mgRect<int>(ix, iy + height - bottom_table[0][3], width, bottom_table[0][3]),
                               bottom_table[0], 1);
        prim->End();
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(Floor_InfoTex);
        prim->Color(128, 128, 128, alpha);
        PrimQuad(prim, static_cast<float>(center - (Floor_Info.right >> 1)) - 1.0f, top + 10.0f, Floor_Info);
        prim->End();

        int   right_text = ix + width - 0x48;
        float row_top = top + 68.0f;

        if (CheckNowEurope()) {
            right_text = ix + width - 0x54;
        }

        mgRect<int> mark(0x7C, 0, 0x16, 0x16);
        mgRect<int> highlight(0x92, 0, 0x16, 0x16);
        prim->Bilinear(1);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(Floor_InfoTex);
        prim->Color(128, 128, 128, alpha);

        if (MenuDngMes[DNG_TREE_MAP_MES_TITLE] != nullptr) {
            MenuDngMes[DNG_TREE_MAP_MES_TITLE]->SetMovePosCenteringGyou(0, center, iy + 0x26);
        }

        if (DngInfoFloorInfo != nullptr && !(DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_SEAL_CLEAR) && 0 < room->seal) {
            /**
             *
             * Phase of the floor-seal opacity pulse.
             *
             */
            static float AlphaRate = 0.0f;
            AlphaRate += 0.034906585f;

            if (PI <= AlphaRate) {
                AlphaRate -= PI;
            }

            float seal_alpha = static_cast<float>(alpha) * sinf(AlphaRate);

            if (seal_alpha < 0.0f) {
                seal_alpha = 0.0f;
            }

            if (128.0f < seal_alpha) {
                seal_alpha = 128.0f;
            }

            mgRect<int>  translated_seal(0xD8, 0xA6, 0x28, 0x18);
            mgRect<int>  japanese_seal(0xB8, 0xD6, 0x18, 0x18);
            mgRect<int> *seal = &translated_seal;
            prim->Color(128, 128, 128, fptosi(seal_alpha));
            float seal_y = top + 35.0f;
            float seal_x = {};

            if (language > LANG_JAPANESE) {
                seal->top += (room->seal - 1) * 0x18;
                seal_x = left + width - 56.0f;
            } else {
                seal = &japanese_seal;
                seal->left += (room->seal - 1) * 0x18;
                seal_x = left + width - 40.0f;
            }

            PrimQuad(prim, seal_x, seal_y, *seal);
            prim->Color(128, 128, 128, alpha);
        }

        int icon_x = static_cast<int>(left + 20.0f);
        int icon_row_y = iy = static_cast<int>(2.0f + (68.0f + static_cast<float>(iy)));
        int text_x = icon_x + 0x1C;
        PrimQuad(prim, static_cast<float>(icon_x), row_top, mark);

        if (DngInfoFloorInfo != nullptr && (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_FAST_DESTROY_CLEAR)) {
            highlight.left = medal_xytbl[0];
            PrimQuad(prim, static_cast<float>(icon_x), static_cast<float>(icon_row_y), highlight);
        }

        MenuDngMes[DNG_TREE_MAP_MES_FAST_DESTROY]->SetMovePosGyou(0, text_x, iy);
        int line_right = ix + width - MenuDngMes[DNG_TREE_MAP_MES_FAST_DESTROY]->line_w[1] - 0xE;

        if (CheckNowEurope()) {
            line_right -= 8;
        }

        MenuDngMes[DNG_TREE_MAP_MES_FAST_DESTROY]->SetMovePosGyou(1, line_right, iy);
        icon_row_y += 0x16;
        iy += 0x16;
        shown = DngInfoRoomInfo;

        if (shown != nullptr && shown->fishing) {
            PrimQuad(prim, static_cast<float>(icon_x), static_cast<float>(icon_row_y), mark);

            if (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_FISHING_CLEAR) {
                highlight.left = medal_xytbl[2];
                PrimQuad(prim, static_cast<float>(icon_x), static_cast<float>(icon_row_y), highlight);
            }

            MenuDngMes[DNG_TREE_MAP_MES_FISHING]->SetMovePosGyou(0, text_x, iy);
            MenuDngMes[DNG_TREE_MAP_MES_FISHING]->SetMovePosGyou(1, ix + width - MenuDngMes[DNG_TREE_MAP_MES_FISHING]->line_w[1] - 0x10, iy);

            if (MenuDngMes[DNG_TREE_MAP_MES_FISHING]->ClsMes::mes_no == 2) {
                MenuDngMes[DNG_TREE_MAP_MES_FISHING]->SetMovePosGyou(1, right_text, iy);
            }

            icon_row_y += 0x16;
            iy += 0x16;
        }

        shown = DngInfoRoomInfo;

        if (shown != nullptr && shown->spheda) {
            PrimQuad(prim, static_cast<float>(icon_x), static_cast<float>(icon_row_y), mark);
            int prize_x = right_text;

            if (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_SPHEDA_CLEAR) {
                if (language > LANG_JAPANESE) {
                    prize_x -= 9;
                }

                if (CheckNowEurope()) {
                    prize_x = ix + width - MenuDngMes[DNG_TREE_MAP_MES_SPHEDA]->line_w[1] - 0x10;
                }

                highlight.left = medal_xytbl[3];
                PrimQuad(prim, static_cast<float>(icon_x), static_cast<float>(icon_row_y), highlight);
            } else if (CheckBitFlagMenu(SAVE_FLAG_SPHEDA_UNLOCKED)) {
                if (language > LANG_JAPANESE) {
                    prize_x -= 0x20;
                }

                if (CheckNowEurope()) {
                    prize_x = ix + width - MenuDngMes[DNG_TREE_MAP_MES_SPHEDA]->line_w[1] - 0x10;
                }
            }

            MenuDngMes[DNG_TREE_MAP_MES_SPHEDA]->SetMovePosGyou(0, text_x, iy);
            MenuDngMes[DNG_TREE_MAP_MES_SPHEDA]->SetMovePosGyou(1, prize_x, iy);
            icon_row_y += 0x16;
            iy += 0x16;
        }

        PrimQuad(prim, static_cast<float>(icon_x), static_cast<float>(icon_row_y), mark);

        if (DngInfoFloorInfo != nullptr && (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_PRACTICE_CLEAR)) {
            highlight.left = medal_xytbl[4];
            PrimQuad(prim, static_cast<float>(icon_x), static_cast<float>(icon_row_y), highlight);
        }

        if (language == LANG_JAPANESE) {
            MenuDngMes[DNG_TREE_MAP_MES_PRACTICE]->SetMovePosGyou(0, text_x, iy);
            MenuDngMes[DNG_TREE_MAP_MES_PRACTICE]->SetMovePosGyou(1, right_text, iy);
            iy += 0x16;
        } else {
            MenuDngMes[DNG_TREE_MAP_MES_PRACTICE]->SetMovePosGyou(0, text_x, iy);

            if (MenuDngMes[DNG_TREE_MAP_MES_PRACTICE]->ClsMes::mes_no == 0x6C) {
                MenuDngMes[DNG_TREE_MAP_MES_PRACTICE]->SetMovePosGyou(1, ix + width - MenuDngMes[DNG_TREE_MAP_MES_PRACTICE]->line_w[1] - 0x10, iy);
                iy += 0x16;
            } else {
                MenuDngMes[DNG_TREE_MAP_MES_PRACTICE]->SetMovePosGyou(1, text_x, iy + 0x16);
                MenuDngMes[DNG_TREE_MAP_MES_PRACTICE]->SetMovePosGyou(2, ix + width - MenuDngMes[DNG_TREE_MAP_MES_PRACTICE]->line_w[2] - 0x10, iy + 0x12);
                iy += 0x2C;
            }
        }

        prim->End();
        MenuDngMes[DNG_TREE_MAP_MES_KILL_COUNT]->SetMovePosGyou(0, text_x, iy);
        MenuDngMes[DNG_TREE_MAP_MES_KILL_COUNT]->SetMovePosGyou(1, ix + width - MenuDngMes[DNG_TREE_MAP_MES_KILL_COUNT]->line_w[1] - 0x1A, iy);

        shown = DngInfoRoomInfo;

        if (shown != nullptr && shown->geostone) {
            MenuDngMes[DNG_TREE_MAP_MES_GEOSTONE]->SetMovePosGyou(0, center - (MenuDngMes[DNG_TREE_MAP_MES_GEOSTONE]->line_w[0] >> 1), iy + 0x24);
        }

        for (int i = 0; i < DNG_TREE_MAP_MES_MAX; ++i) {
            MenuDngMes[i]->SetMsgAlpha(alpha);
        }

        if (MenuDCMsg[5] != nullptr) {
            DngInfoMedalMsgPutPos[0] = DngInfoMedalNumMsg[language][0];
            DngInfoMedalMsgPutPos[1] = DngInfoMedalNumMsg[language][1];
            MenuDCMsg[5]->SetPutPos(DngInfoMedalMsgPutPos);
            MenuDCMsg[5]->SetMsgAlpha(alpha);
        }
    }
}

static void DrawGeoramaMateria(int top_y, char *title, int unused_count, int *items, int tex_block) {
    int index = {};
    int x = {};
    int y = {};
    int left = (mgScreenWidth - 0x1AE) >> 1;
    int column_left = mgScreenWidth / 3;
    int column_right = mgScreenWidth - column_left;
    mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *) nullptr);
    CMenuFont font;
    DrawMenuFillBox(static_cast<float>(left + 6), static_cast<float>(top_y + 6), 422.0f, 272.0f,
                    0x59, 0xC, 0xC, 0xC);
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(Floor_InfoTex);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, top_y, 0x1AE, 0x46), dngboardbrdtbl[0], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, top_y + 0x46, 0x1AE, 0xD2 - dngboardbrdtbl[3][3]),
                           dngboardbrdtbl[3], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(left, top_y + 0x118 - dngboardbrdtbl_2[0][3], 0x1AE, dngboardbrdtbl_2[0][3]), dngboardbrdtbl_2[0], 1);
    PrimQuad(prim, static_cast<float>((mgScreenWidth >> 1) - (Floor_Info.right >> 1)) - 1.0f,
             static_cast<float>(top_y) + 10.0f, Floor_Info);
    prim->End();

    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) nullptr);
    int text_h = {}, text_w = {};
    font.SetStr(title);
    font.CalcDrawWH(font.str, &text_w, &text_h);
    x = (mgScreenWidth - text_w) >> 1;
    y = top_y + 0x26;
    font.SetPos(x, y);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);

    int first = GeoramaMateriaInfoDrawPage * DNG_TREE_MAP_MATERIA_PAGE;
    int last = first + DNG_TREE_MAP_MATERIA_PAGE;
    y = top_y + 0x47;

    if (GeoramaMateriaNum < last) {
        last = GeoramaMateriaNum;
    }

    for (index = first; index < last; ++index) {
        char *name = GetItemMessage(items[index]);

        if (name == nullptr) {
            continue;
        }

        font.SetStr(name);
        int item_h = {}, item_w = {};
        font.CalcDrawWH(font.str, &item_w, &item_h);
        x = item_w;

        if (index % 2 == 0) {
            x = column_left - (x >> 1);
        } else {
            x = column_right - (x >> 1);
        }

        font.SetPos(x, y);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);

        if (index % 2 != 0) {
            y += 0x18;
        }
    }

    x = left + 0x186;
    y = top_y + 0xEF;
    char page[32];
    std::snprintf(page, sizeof(page), "%d/%d", GeoramaMateriaInfoDrawPage + 1, GeoramaMateriaNum / DNG_TREE_MAP_MATERIA_PAGE + 1);
    font.SetStr(page);
    font.SetPos(x, y);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
}

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
        SetSpriteEnv(prim, MENU_SPRITE_ENV_ADD);
        prim->Bilinear(0);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(map_tex);
        prim->Color(128, 128, 128, static_cast<int>(0.5f * static_cast<float>(opacity)));
        prim->TextureCrd(dng_light_circle.left, dng_light_circle.top);
        prim->Vertex(position[0] + reach_x, position[1] + reach_y, 0.0f);
        prim->TextureCrd(dng_light_circle.left + dng_light_circle.right,
                         dng_light_circle.top + dng_light_circle.bottom);
        prim->Vertex(position[0] + 124.0f - reach_x, position[1] + 80.0f - reach_y, 0.0f);
        prim->End();
    }

    unsigned int marks = {};

    for (int i = 0; i < floor_manager->glid_num; i++, glid++) {
        CalcGlidPutPos(glid, cell_rect.left, cell_rect.top, 0);

        if (menu_debug_flag) {
            DrawGlid(cell_rect);
        }

        marks = DrawGlidCheck(glid);

        if (glid->type == GLID_TYPE_ROOM) {
            float brightness = 1.0f;

            if (glid->blink && blink_cnt % PAL_TIMING(25, 30) < 14) {
                brightness = 0.5f;
            }

            DrawRoomOne(cell_rect, &glid->room, 0, opacity, brightness);
        } else if (glid->type == GLID_TYPE_ROOT) {
            DrawRoot(cell_rect, &glid->root, 1, marks, opacity);
            DrawRoot(cell_rect, &glid->root, 0, marks, opacity);
        }
    }
}

/**
 *
 * Last player-marker position during event movement.
 *
 */
static float dng_player_pos[2] = {
    0.0f, 0.0f};

void CDngFreeMap::DrawPlayer(int opacity) {
    if (user_glid == nullptr || koma_tex == nullptr) {
        return;
    }

    float board_x = {}, board_y = {};
    CalcGlidPutPos(user_glid, board_x, board_y, 0);
    board_x += 4.0f;
    board_y -= 30.0f;
    float sprite_alpha = static_cast<float>(opacity);

    if (mode == DNGMAP_MODE_EVENT) {
        if (koma_move && koma_now != nullptr) {
            dng_player_pos[0] = koma_now->x;
            dng_player_pos[1] = koma_now->y;
            koma_now = koma_now->next;
        }

        board_x = dng_player_pos[0];
        board_y = dng_player_pos[1];
    }

    if (mode == DNGMAP_MODE_MENU) {
        board_y -= 6.0f * sinf(PAL_TIMING(0.06283186f, 0.05235988f) * static_cast<float>(dng_player_blink_cnt));
    }

    dng_player_blink_cnt++;

    if (dng_player_blink_cnt >= PAL_TIMING(50, 60)) {
        dng_player_blink_cnt = 0;
    }

    float brightness = 16.0f + alpha + 16.0f * sinf(PAL_TIMING(0.06283186f, 0.05235988f) * static_cast<float>(dng_player_blink_cnt));

    if (brightness < 0.0f) {
        brightness = 0.0f;
    }

    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Bilinear(1);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(koma_tex);
    int level = static_cast<int>(brightness);
    prim->Color(level, level, level, static_cast<int>(sprite_alpha));
    mgRect<int> tex_rect(0, 0, 30, 48);
    PrimQuad(prim, board_x, board_y, tex_rect);
    prim->End();
}

void CDngFreeMap::Step() {
    if (!active) {
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

    if (blink_cnt >= PAL_TIMING(DNGMAP_BLINK_CYCLE, 120)) {
        blink_cnt = 0;
    }

    DngTreeMapActiveLightRate += 0.05f;

    if (!(DngTreeMapActiveLightRate < 1.0f)) {
        DngTreeMapActiveLightRate = 1.0f;
    }

    mark_num = 0;
}

/**
 *
 * Names of the four passage types in the map debug display.
 *
 */
static char *RootTable_2119[4] = {
    "Nrm,",
    "Sun,",
    "Moon,",
    "Star,"};

/**
 *
 * Labels of the floor-save flags in the map debug display.
 *
 */
static char Table_2133[8][32] = {
    "  go enable :",
    "  Clear \x81\x40  :",
    "  Mission Clr:",
    "  FastestTime:",
    "  Fish     :",
    "  TalkMons :",
    "  Spheda:",
    "  GeoStone:"};

/**
 *
 * Save-flag masks corresponding to the floor debug labels.
 *
 */
static unsigned int bittable_2134[8] = {
    DNG_FLOOR_FLAG_OPEN,
    DNG_FLOOR_FLAG_CLEAR,
    DNG_FLOOR_FLAG_PRACTICE_CLEAR,
    DNG_FLOOR_FLAG_FAST_DESTROY_CLEAR,
    DNG_FLOOR_FLAG_FISHING_CLEAR,
    DNG_FLOOR_FLAG_TALK_MONSTER,
    DNG_FLOOR_FLAG_SPHEDA_CLEAR,
    DNG_FLOOR_FLAG_GEOSTONE_FOUND};

void CDngFreeMap::Draw() {
    if (active && !(alpha <= 0.0f)) {
        mgCTextureManager *textures = &mgTexManager;
        mgCTexture        *texture = map_tex;

        if (texture == nullptr) {
            return;
        }

        int opacity = static_cast<int>(alpha);

        if (opacity < 0) {
            opacity = 0;
        }

        if (opacity > 128) {
            opacity = 128;
        }

        textures->ReloadTexture(texture->block, (sceVif1Packet *) nullptr);
        DrawBackPattern(opacity);
        DrawLast();
        DrawTreeMap(opacity);
        DrawPlayer(opacity);

        if (mode != DNGMAP_MODE_EVENT) {
            mgCDrawPrim *prim = GetMenuPrim();
            SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
            prim->Bilinear(1);
            prim->Begin(MG_PRIM_SPRITE);
            prim->Texture(name_tex);
            prim->Color(128, 128, 128, opacity);

            for (int i = 0; i < mark_num; i++) {
                PrimQuad(prim, mark_rect[i], mgRect<int>(192, 210, 64, 46));
            }

            prim->End();
        }

        if (!menu_debug_flag) {
            return;
        }

        int block = -1;
        MenuReloadTexture(block, MenuDCMsg[2]->texture_block);
        int       moon = {};
        int       sun = {};
        int       normal = {};
        CMenuFont menu_font;
        CFont    *font = &menu_font;
        int       y = 110;
        DrawMenuFillBox(0.0f, 50.0f, 160.0f, 60.0f, 64, 0, 0, 0);
        font->SetStr("\x81@Ctrl : <- or -> \n  \x81@       \x81\x9B or \x81~\n\x81@\x91S\x95\\\x8E\xA6 :\x81\xA2");
        font->SetPos(0, 50);
        menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        DrawMenuFillBox(0.0f, static_cast<float>(y), 160.0f, static_cast<float>(mgScreenHeight - y), 64, 0, 0, 0);

        if (select_glid != nullptr && select_glid->type == GLID_TYPE_ROOM) {
            DNG_FLOOR_SAVE *save = MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, select_glid->room.floor_id);

            if (save != nullptr) {
                char detail[256];
                char line[FONT_STR_MAX];
                std::snprintf(detail, sizeof(detail), "Room ID : %d", select_glid->room.floor_id);
                DNGMAP_ROOM_INFO *room = &select_glid->room;

                if (room->flag & DNGMAP_ROOM_FLAG_START) {
                    dc2::text::Append(detail, dc2::text::View(":START "));
                }

                if (room->flag & DNGMAP_ROOM_FLAG_EXIT) {
                    dc2::text::Append(detail, dc2::text::View(":EXIT"));
                }

                if (room->flag & DNGMAP_ROOM_FLAG_BOSS) {
                    dc2::text::Append(detail, dc2::text::View(":BOSS"));
                }

                if (room->flag & DNGMAP_ROOM_FLAG_SUB) {
                    dc2::text::Append(detail, dc2::text::View(":SUBMAP"));
                }

                dc2::text::Append(detail, dc2::text::View("\n"));
                font->SetStr(detail);
                font->SetPos(10, y + 2);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                normal = floor_manager->GetDngMapNextFloorID(select_glid->room.floor_id, DNGMAP_ROOT_NORMAL);
                sun = floor_manager->GetDngMapNextFloorID(select_glid->room.floor_id, DNGMAP_ROOT_SUN);
                moon = floor_manager->GetDngMapNextFloorID(select_glid->room.floor_id, DNGMAP_ROOT_MOON);
                std::snprintf(line, sizeof(line), "Normal:%d\nSun:%d\n Moon :%d\n Star :%d", normal, sun, moon,
                              floor_manager->GetDngMapNextFloorID(select_glid->room.floor_id, DNGMAP_ROOT_STAR));
                font->SetStr(line);
                font->SetPos(20, y + 22);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                dc2::text::Copy(line, dc2::text::View("\x81@Root\x81"
                                                      "F"));
                int links = floor_manager->GetDngMapNextRoot(select_glid->room.floor_id);

                for (int i = 0; i < 4; i++) {
                    if (links & (1 << i)) {
                        dc2::text::Append(line, dc2::text::View(RootTable_2119[i]));
                    }
                }

                font->SetStr(line);
                font->SetPos(10, y + 102);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                std::snprintf(detail, sizeof(detail), "  VisitNum\x81\x40: %d\n", save->visit_count);

                if (MenuDngDebugFlagSelect == 0) {
                    std::snprintf(detail, sizeof(detail), "> VisitNum\x81\x40: %d\n", save->visit_count);
                }

                font->SetStr(detail);
                font->SetPos(10, y + 122);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                y += 142;

                for (int i = 0; i < 8; i++) {
                    dc2::text::Copy(detail, dc2::text::View(Table_2133[i]));

                    if (save->flag & bittable_2134[i]) {
                        dc2::text::Append(detail, dc2::text::View("ON"));
                    } else {
                        dc2::text::Append(detail, dc2::text::View("OFF"));
                    }

                    if (MenuDngDebugFlagSelect > 0 && MenuDngDebugFlagSelect - 1 == i) {
                        detail[0] = '>';
                    }

                    font->SetStr(detail);
                    font->SetPos(10, y);
                    font->DrawDirect(font->str, font->pos_x, font->pos_y);
                    y += 20;
                }

                dc2::text::Append(detail, dc2::text::View("NONE"));
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

    if (koma_now != nullptr) {
        koma_now = koma_now->next;
    }
}

// clang-format off
/**
 *
 * Interpolation points and terminator for passage shape 0.
 *
 */
static short RootHokanTable0_2230[DNGMAP_ROOT_HOKAN_POINTS + 1][2] = {
    {14, -38},
    {13, -37},
    {12, -36},
    {11, -35},
    {10, -34},
    {9, -33},
    {9, -32},
    {8, -31},
    {7, -30},
    {6, -29},
    {5, -28},
    {5, -27},
    {4, -26},
    {3, -25},
    {2, -24},
    {1, -23},
    {1, -22},
    {0, -21},
    {0, -20},
    {-1, -19},
    {-1, -1}
};

/**
 *
 * Interpolation points and terminator for passage shape 1.
 *
 */
static short RootHokanTable1_2231[DNGMAP_ROOT_HOKAN_POINTS + 1][2] = {
    {-20, -28},
    {-17, -28},
    {-14, -28},
    {-12, -28},
    {-9, -28},
    {-7, -28},
    {-4, -28},
    {-1, -28},
    {0, -28},
    {3, -28},
    {5, -28},
    {8, -28},
    {11, -28},
    {13, -28},
    {16, -28},
    {18, -28},
    {21, -28},
    {24, -28},
    {26, -28},
    {29, -28},
    {-1, -1}
};

/**
 *
 * Interpolation points and terminator for passage shape 2.
 *
 */
static short RootHokanTable2_2232[DNGMAP_ROOT_HOKAN_POINTS + 1][2] = {
    {-1, -1},
    {-1, -19},
    {0, -20},
    {0, -21},
    {1, -22},
    {1, -23},
    {2, -24},
    {3, -25},
    {4, -26},
    {5, -27},
    {5, -28},
    {8, -28},
    {11, -28},
    {13, -28},
    {16, -28},
    {18, -28},
    {21, -28},
    {24, -28},
    {26, -28},
    {29, -28},
    {-1, -1}
};

/**
 *
 * Interpolation points and terminator for passage shape 3.
 *
 */
static short RootHokanTable3_2233[DNGMAP_ROOT_HOKAN_POINTS + 1][2] = {
    {-20, -28},
    {-17, -28},
    {-14, -28},
    {-12, -28},
    {-9, -28},
    {-7, -28},
    {-4, -28},
    {-1, -28},
    {0, -28},
    {3, -28},
    {5, -28},
    {5, -27},
    {4, -26},
    {3, -25},
    {2, -24},
    {1, -23},
    {1, -22},
    {0, -21},
    {0, -20},
    {-1, -19},
    {-1, -1}
};

/**
 *
 * Interpolation points and terminator for passage shape 4.
 *
 */
static short RootHokanTable4_2234[DNGMAP_ROOT_HOKAN_POINTS + 1][2] = {
    {14, -38},
    {13, -37},
    {12, -36},
    {11, -35},
    {10, -34},
    {9, -33},
    {9, -32},
    {8, -31},
    {7, -30},
    {6, -29},
    {5, -28},
    {8, -28},
    {11, -28},
    {13, -28},
    {16, -28},
    {18, -28},
    {21, -28},
    {24, -28},
    {26, -28},
    {29, -28},
    {-1, -1}
};

/**
 *
 * Interpolation points and terminator for passage shape 5.
 *
 */
static short RootHokanTable5_2235[DNGMAP_ROOT_HOKAN_POINTS + 1][2] = {
    {-20, -28},
    {-17, -28},
    {-14, -28},
    {-12, -28},
    {-9, -28},
    {-7, -28},
    {-4, -28},
    {-1, -28},
    {0, -28},
    {3, -28},
    {5, -28},
    {6, -29},
    {7, -30},
    {8, -31},
    {9, -32},
    {9, -33},
    {10, -34},
    {11, -35},
    {12, -36},
    {13, -37},
    {-1, -1}
};

/**
 *
 * Interpolation points and terminator for passage shape 6.
 *
 */
static short RootHokanTable6_2236[DNGMAP_ROOT_HOKAN_POINTS + 1][2] = {
    {32, -28},
    {30, -27},
    {28, -27},
    {26, -26},
    {25, -26},
    {23, -25},
    {21, -25},
    {20, -24},
    {18, -24},
    {16, -23},
    {14, -23},
    {13, -22},
    {11, -22},
    {9, -21},
    {8, -21},
    {6, -20},
    {4, -20},
    {3, -19},
    {1, -19},
    {0, -18},
    {-1, -1}
};

/**
 *
 * Interpolation points and terminator for passage shape 7.
 *
 */
static short RootHokanTable7_2237[DNGMAP_ROOT_HOKAN_POINTS + 1][2] = {
    {-20, -28},
    {-19, -27},
    {-18, -27},
    {-17, -26},
    {-16, -26},
    {-15, -25},
    {-14, -25},
    {-13, -24},
    {-12, -24},
    {-11, -23},
    {-11, -23},
    {-10, -22},
    {-9, -22},
    {-8, -21},
    {-7, -21},
    {-6, -20},
    {-5, -20},
    {-4, -19},
    {-3, -19},
    {-2, -18},
    {-1, -1}
};

/**
 *
 * Interpolation points and terminator for passage shape 8.
 *
 */
static short RootHokanTable8_2238[DNGMAP_ROOT_HOKAN_POINTS + 1][2] = {
    {14, -38},
    {14, -37},
    {15, -37},
    {16, -36},
    {17, -36},
    {18, -35},
    {19, -35},
    {20, -34},
    {21, -34},
    {22, -33},
    {22, -33},
    {23, -32},
    {24, -32},
    {25, -31},
    {26, -31},
    {27, -30},
    {28, -30},
    {29, -29},
    {30, -29},
    {31, -28},
    {-1, -1}
};

/**
 *
 * Interpolation points and terminator for passage shape 9.
 *
 */
static short RootHokanTable9_2239[DNGMAP_ROOT_HOKAN_POINTS + 1][2] = {
    {14, -38},
    {12, -37},
    {10, -37},
    {8, -36},
    {7, -36},
    {5, -35},
    {3, -35},
    {2, -34},
    {0, -34},
    {-1, -33},
    {-3, -33},
    {-4, -32},
    {-6, -32},
    {-8, -31},
    {-9, -31},
    {-11, -30},
    {-13, -30},
    {-14, -29},
    {-16, -29},
    {-18, -28},
    {-1, -1}
};

/**
 *
 * Interpolation points and terminator for room connection 0.
 *
 */
static short RoomHokanTable0_2241[DNGMAP_ROOM_HOKAN_POINTS + 1][2] = {
    {14, -38},
    {13, -37},
    {12, -36},
    {11, -35},
    {10, -34},
    {9, -33},
    {9, -32},
    {8, -31},
    {7, -30},
    {6, -29},
    {-1, -1}
};

/**
 *
 * Interpolation points and terminator for room connection 1.
 *
 */
static short RoomHokanTable1_2242[DNGMAP_ROOM_HOKAN_POINTS + 1][2] = {
    {6, -28},
    {5, -27},
    {4, -26},
    {3, -25},
    {2, -24},
    {1, -23},
    {1, -22},
    {0, -21},
    {0, -20},
    {-1, -19},
    {-1, -1}
};

/**
 *
 * Interpolation points and terminator for room connection 2.
 *
 */
static short RoomHokanTable2_2243[DNGMAP_ROOM_HOKAN_POINTS + 1][2] = {
    {-20, -28},
    {-17, -28},
    {-14, -28},
    {-12, -28},
    {-9, -28},
    {-7, -28},
    {-4, -28},
    {-1, -28},
    {0, -28},
    {3, -28},
    {-1, -1}
};

/**
 *
 * Interpolation points and terminator for room connection 3.
 *
 */
static short RoomHokanTable3_2244[DNGMAP_ROOM_HOKAN_POINTS + 1][2] = {
    {6, -28},
    {8, -28},
    {11, -28},
    {13, -28},
    {16, -28},
    {18, -28},
    {21, -28},
    {24, -28},
    {26, -28},
    {29, -28},
    {-1, -1}
};

// clang-format on

int CDngFreeMap::LoadDngInfo(mgCMemory *stack, int block, int dungeon, int room, int next_room) {
    /**
     *
     * Interpolation point lists for the passage shapes.
     *
     */
    static short (*RootHokanTablePtrTable[11])[2] = {
        RootHokanTable0_2230,
        RootHokanTable1_2231,
        RootHokanTable2_2232,
        RootHokanTable3_2233,
        RootHokanTable4_2234,
        RootHokanTable5_2235,
        RootHokanTable6_2236,
        RootHokanTable7_2237,
        RootHokanTable8_2238,
        RootHokanTable9_2239,
        nullptr};

    /**
     *
     * Interpolation point lists for the four room connections.
     *
     */
    static short (*RoomHokanTablePtrTable[GLID_DIR_NUM + 1])[2] = {
        RoomHokanTable0_2241,
        RoomHokanTable1_2242,
        RoomHokanTable2_2243,
        RoomHokanTable3_2244,
        nullptr};

    /**
     *
     * Point traversal order for each passage shape and connection direction.
     *
     */
    static signed char is_reverse_tbl[11][GLID_DIR_NUM] = {
        {DNGMAP_PATH_REVERSE, DNGMAP_PATH_FORWARD, DNGMAP_PATH_NONE,    DNGMAP_PATH_NONE   },
        {DNGMAP_PATH_NONE,    DNGMAP_PATH_NONE,    DNGMAP_PATH_REVERSE, DNGMAP_PATH_FORWARD},
        {DNGMAP_PATH_FORWARD, DNGMAP_PATH_NONE,    DNGMAP_PATH_NONE,    DNGMAP_PATH_REVERSE},
        {DNGMAP_PATH_REVERSE, DNGMAP_PATH_NONE,    DNGMAP_PATH_NONE,    DNGMAP_PATH_FORWARD},
        {DNGMAP_PATH_NONE,    DNGMAP_PATH_FORWARD, DNGMAP_PATH_REVERSE, DNGMAP_PATH_NONE   },
        {DNGMAP_PATH_NONE,    DNGMAP_PATH_REVERSE, DNGMAP_PATH_NONE,    DNGMAP_PATH_FORWARD},
        {DNGMAP_PATH_REVERSE, DNGMAP_PATH_NONE,    DNGMAP_PATH_FORWARD, DNGMAP_PATH_NONE   },
        {DNGMAP_PATH_REVERSE, DNGMAP_PATH_NONE,    DNGMAP_PATH_NONE,    DNGMAP_PATH_FORWARD},
        {DNGMAP_PATH_NONE,    DNGMAP_PATH_FORWARD, DNGMAP_PATH_REVERSE, DNGMAP_PATH_NONE   },
        {DNGMAP_PATH_NONE,    DNGMAP_PATH_FORWARD, DNGMAP_PATH_NONE,    DNGMAP_PATH_REVERSE},
        {DNGMAP_PATH_NONE,    DNGMAP_PATH_REVERSE, DNGMAP_PATH_NONE,    DNGMAP_PATH_FORWARD}
    };

    /**
     *
     * Room interpolation list selected by direction and entry side.
     *
     */
    static signed char old_hokantbl_useno[2 * GLID_DIR_NUM] = {
        0, 1, 2, 3, 1, 0, 3, 2};

    /**
     *
     * Traversal order of each room interpolation list.
     *
     */
    static signed char is_reverse_tbl_room[2 * GLID_DIR_NUM] = {
        DNGMAP_PATH_REVERSE, DNGMAP_PATH_FORWARD, DNGMAP_PATH_REVERSE, DNGMAP_PATH_FORWARD,
        DNGMAP_PATH_FORWARD, DNGMAP_PATH_REVERSE, DNGMAP_PATH_FORWARD, DNGMAP_PATH_REVERSE};

    if (stack == nullptr || stack->stGetRest() <= 0) {
        return 0;
    }

    save_dungeon = &GetSaveData()->save_dungeon;
    mgCDrawPrim *prim = GetMenuPrim();
    prim->offset_x = 0;
    prim->offset_y = 0;
    mgCMemory memory;
    int       remaining = stack->stGetRest();
    memory.stSetBorrowedBuffer(*stack, std::span(stack->stGetTop(), static_cast<std::size_t>(remaining)));
    memory.Align64();
    floor_manager = &menu_GetBattleAreaScene()->floor_manager;
    dng_no = dungeon;
    floor_manager->CheckDrawGlidInfo();
    user_room_no = room;
    next_room_no = next_room;
    GetRoomGlid(user_room_no);

    if (0 <= next_room_no) {
        GetRoomGlid(next_room_no);
    }

    select_glid = nullptr;
    mode = DNGMAP_MODE_EVENT;
    InitTexture();
    tex_block = block;
    memory.Align64();
    u_long128 *buffer = memory.stGetTop();

    if (buffer != nullptr) {
        char filename[0x40];
        std::snprintf(filename, sizeof(filename), "textures/dmap%d.json", dungeon);
        unsigned int size = LoadFileMenu(filename, dc2::memory::RemainingBytes(memory), MENU_FILE_LOAD_DIRECT);
        unsigned int quadwords = (size & 15) ? (size >> 4) + 1 : size >> 4;
        memory.Alloc(quadwords);
        MenuEnterIMG(tex_block, reinterpret_cast<u8 *>(buffer), "_dn");
        koma_tex = mgTexManager.GetTexture("dngop_dn", -1);
        map_tex = mgTexManager.GetTexture("dt_dn", -1);
        name_tex = mgTexManager.GetTexture("dtname_dn", -1);
    }

    view_rect.Set(60.0f, 40.0f, static_cast<float>(mgScreenWidth - 40), static_cast<float>(mgScreenHeight - 40));
    SetUserGlid(user_room_no);
    ResetDngMapPos(user_room_no, true);
    koma_now = nullptr;
    koma_path = nullptr;
    koma_move = false;
    CalcGlidPutPos(user_glid, dng_player_pos[0], dng_player_pos[1], 0);
    dng_player_pos[0] += 8.0f;
    dng_player_pos[1] += -28.0f;

    if (0 <= next_room_no) {
        int        direction = -1;
        float      gx = 0.0f;
        float      gy = 0.0f;
        float      x = 0.0f;
        float      y = 0.0f;
        GLID_INFO *start = GetRoomGlid(user_room_no);

        // At branching rooms, the destination becomes the neighbouring room on the way to the requested room.
        if (dng_no == 1) {
            if (user_room_no == 8 && next_room_no > 8) {
                if (next_room_no < 8) {
                    next_room_no = 7;
                } else if (next_room_no < 13) {
                    next_room_no = 9;
                } else {
                    next_room_no = 13;
                }
            }

            if (user_room_no > 13 && next_room_no < user_room_no) {
                next_room_no = user_room_no - 1;
            }

            if (user_room_no == 13) {
                if (next_room_no < 14) {
                    next_room_no = 8;
                } else {
                    next_room_no = 14;
                }
            }
        }

        if (dng_no == 2) {
            if (user_room_no == 5 && next_room_no > 5 && next_room_no < 9) {
                next_room_no = 6;
            }

            if (user_room_no > 5 && user_room_no < 9 && next_room_no > 8) {
                next_room_no = user_room_no - 1;
            }

            if (user_room_no >= 12 && user_room_no < 15 && next_room_no > 15) {
                next_room_no = user_room_no - 1;
            }

            if (user_room_no == 16) {
                if (next_room_no < 16) {
                    next_room_no = 11;
                } else {
                    next_room_no = 17;
                }
            }

            if (user_room_no > 16 && next_room_no < user_room_no) {
                next_room_no = user_room_no - 1;
            }

            if (user_room_no == 11) {
                if (next_room_no < 11) {
                    next_room_no = 10;
                } else if (next_room_no > 11 && next_room_no < 16) {
                    next_room_no = 12;
                } else {
                    next_room_no = 16;
                }
            }
        }

        if (dng_no == 3) {
            if (user_room_no > 10 && user_room_no < 14 && next_room_no > 15) {
                next_room_no = user_room_no - 1;
            }

            if (user_room_no == 10 && next_room_no > 10 && next_room_no < 15) {
                next_room_no = 11;
            }

            if (user_room_no == 15) {
                if (next_room_no < 15) {
                    next_room_no = 10;
                } else {
                    next_room_no = 16;
                }
            }

            if (user_room_no > 15 && next_room_no < user_room_no) {
                next_room_no = user_room_no - 1;
            }
        }

        if (dng_no == 4) {
            if (user_room_no == 4 && next_room_no > 4 && next_room_no < 9) {
                next_room_no = 5;
            }

            if (user_room_no > 4 && user_room_no < 8 && next_room_no > 8) {
                next_room_no = user_room_no - 1;
            }

            if (user_room_no == 9) {
                if (next_room_no < 9) {
                    next_room_no = 4;
                } else {
                    next_room_no = 10;
                }
            }

            if (user_room_no > 9 && next_room_no < user_room_no) {
                next_room_no = user_room_no - 1;
            }
        }

        if (dng_no == 5) {
            if (user_room_no == 4 && next_room_no > 4 && next_room_no < 12) {
                next_room_no = 5;
            }

            if (user_room_no > 4 && user_room_no < 11 && next_room_no > 11) {
                next_room_no = user_room_no - 1;
            }

            if (user_room_no == 12) {
                if (next_room_no < 12) {
                    next_room_no = 4;
                } else {
                    next_room_no = 13;
                }
            }

            if (user_room_no > 12 && next_room_no < user_room_no) {
                next_room_no = user_room_no - 1;
            }
        }

        if (dng_no == 6) {
            if (user_room_no > 7 && user_room_no < 11 && next_room_no > 10) {
                next_room_no = user_room_no - 1;
            }

            if (user_room_no > 12 && user_room_no < 17 && next_room_no > 16) {
                next_room_no = user_room_no - 1;
            }

            if (user_room_no > 19 && user_room_no < 21 && next_room_no > 21) {
                next_room_no = user_room_no - 1;
            }

            if (user_room_no > 23 && user_room_no < 27 && next_room_no > 26) {
                next_room_no = user_room_no - 1;
            }

            if (user_room_no >= 29 && user_room_no < 33) {
                if (next_room_no < user_room_no) {
                    next_room_no = user_room_no - 1;
                } else {
                    next_room_no = user_room_no + 1;
                }
            }

            if (user_room_no == 6) {
                if (next_room_no < 6) {
                    next_room_no = 5;
                } else if (next_room_no >= 11) {
                    next_room_no = 11;
                } else {
                    next_room_no = 7;
                }
            }

            if (user_room_no == 11) {
                if (next_room_no < 11) {
                    next_room_no = 6;
                } else if (next_room_no >= 17) {
                    next_room_no = 17;
                } else {
                    next_room_no = 12;
                }
            }

            if (user_room_no == 18) {
                if (next_room_no < 18) {
                    next_room_no = 17;
                } else if (next_room_no >= 22) {
                    next_room_no = 22;
                } else {
                    next_room_no = 19;
                }
            }

            if (user_room_no == 22) {
                if (next_room_no < 22) {
                    next_room_no = 18;
                } else if (next_room_no >= 27) {
                    next_room_no = 27;
                } else {
                    next_room_no = 23;
                }
            }

            if (user_room_no == 28) {
                if (next_room_no < 28) {
                    next_room_no = 27;
                } else if (next_room_no >= 34) {
                    next_room_no = 34;
                } else {
                    next_room_no = 29;
                }
            }

            if (user_room_no == 35) {
                if (next_room_no == 34) {
                    next_room_no = 34;
                } else if (next_room_no >= 36) {
                    next_room_no = 36;
                } else {
                    next_room_no = 33;
                }
            }
        }

        GLID_INFO *target = GetRoomGlid(next_room_no);

        if (target == nullptr) {
            return 0;
        }

        if (start != nullptr && target != nullptr && abs(start->room.order - target->room.order) > 1) {
            int        candidate_room[GLID_DIR_NUM];
            GLID_INFO *candidate[GLID_DIR_NUM];
            u8         search_order = DNGMAP_PATH_REVERSE;

            if (target->room.order > start->room.order) {
                search_order = DNGMAP_PATH_FORWARD;
            }

            int candidate_count = 0;
            int farthest = -1;

            for (int dir = 0; dir < GLID_DIR_NUM; ++dir) {
                if (start->room.link[dir] >= 0) {
                    GLID_INFO *linked = GetRoomGlid(start->room.link[dir]);

                    if (linked != nullptr &&
                        ((search_order == DNGMAP_PATH_REVERSE && linked->room.order < start->room.order) ||
                         (search_order == DNGMAP_PATH_FORWARD && linked->room.order > start->room.order))) {
                        candidate_room[candidate_count] = start->room.link[dir];
                        candidate[candidate_count] = linked;

                        if (farthest < start->room.link[dir]) {
                            farthest = start->room.link[dir];
                        }

                        ++candidate_count;
                    }
                }
            }

            int target_room = target->room.floor_id;

            for (int i = 0; i < candidate_count; ++i) {
                if (search_order == DNGMAP_PATH_REVERSE ||
                    (search_order == DNGMAP_PATH_FORWARD &&
                     ((target_room < farthest && abs(target_room - candidate_room[i]) <= 0) ||
                      (farthest < target_room && abs(target_room - candidate_room[i]) > 0)))) {
                    target = candidate[i];
                    next_room_no = candidate_room[i];
                    break;
                }
            }
        }

        koma_path = reinterpret_cast<DNGMAP_KOMA_POS *>(memory.Alloc(1));
        koma_now = koma_path;
        koma_now->next = nullptr;
        const short (*curve)[2] = {};
        DNGMAP_KOMA_POS *tail = koma_now;
        CalcGlidPutPos(target, x, y, 0);
        tail->x = x;
        tail->y = y;

        for (int i = 0; i < GLID_DIR_NUM; ++i) {
            if (target == nullptr) {
                break;
            }

            if (target->room.link[i] == user_room_no) {
                direction = i;
                break;
            }
        }

        if (direction < 0) {
            return memory.stGetUsed();
        }

        int room_index = old_hokantbl_useno[direction];
        const short (*points)[2] = RoomHokanTablePtrTable[room_index];
        int room_order = is_reverse_tbl_room[room_index];

        if (room_order == DNGMAP_PATH_FORWARD) {
            for (room_index = 0; room_index < DNGMAP_ROOM_HOKAN_POINTS; room_index++) {
                DNGMAP_KOMA_POS *node = reinterpret_cast<DNGMAP_KOMA_POS *>(memory.Alloc(1));
                node->x = x + points[room_index][0];
                node->y = y + points[room_index][1];
                tail->next = node;
                tail = node;
            }
        } else if (room_order == DNGMAP_PATH_REVERSE) {
            for (room_index = DNGMAP_ROOM_HOKAN_POINTS - 1; room_index >= 0; room_index--) {
                DNGMAP_KOMA_POS *node = reinterpret_cast<DNGMAP_KOMA_POS *>(memory.Alloc(1));
                node->x = x + points[room_index][0];
                node->y = y + points[room_index][1];
                tail->next = node;
                tail = node;
            }
        }

        GLID_INFO *glid = target->link_glid[direction];

        while (glid != nullptr) {
            CalcGlidPutPos(glid, gx, gy, 0);
            glid->blink = true;

            if (glid->type == GLID_TYPE_ROOT) {
                int passage_index = glid->root.shape;
                curve = RootHokanTablePtrTable[passage_index];
                int passage_order = is_reverse_tbl[passage_index][direction];

                if (passage_order < 0) {
                    break;
                }

                if (passage_order == DNGMAP_PATH_FORWARD) {
                    for (passage_index = 0; passage_index < DNGMAP_ROOT_HOKAN_POINTS; passage_index++) {
                        DNGMAP_KOMA_POS *node = reinterpret_cast<DNGMAP_KOMA_POS *>(memory.Alloc(1));
                        node->x = gx + curve[passage_index][0];
                        node->y = gy + curve[passage_index][1];
                        tail->next = node;
                        tail = tail->next;
                    }
                } else if (passage_order == DNGMAP_PATH_REVERSE) {
                    for (passage_index = DNGMAP_ROOT_HOKAN_POINTS - 1; passage_index >= 0; passage_index--) {
                        DNGMAP_KOMA_POS *node = reinterpret_cast<DNGMAP_KOMA_POS *>(memory.Alloc(1));
                        node->x = gx + curve[passage_index][0];
                        node->y = gy + curve[passage_index][1];
                        tail->next = node;
                        tail = node;
                    }
                }
            } else if (glid->type == GLID_TYPE_ROOM) {
                int through_room_index = old_hokantbl_useno[direction + GLID_DIR_NUM];
                curve = RoomHokanTablePtrTable[through_room_index];
                int through_room_order = is_reverse_tbl_room[through_room_index + GLID_DIR_NUM];

                if (through_room_order == DNGMAP_PATH_FORWARD) {
                    for (through_room_index = 0; through_room_index < DNGMAP_ROOM_HOKAN_POINTS; through_room_index++) {
                        DNGMAP_KOMA_POS *node = reinterpret_cast<DNGMAP_KOMA_POS *>(memory.Alloc(1));
                        node->x = gx + curve[through_room_index][0];
                        node->y = gy + curve[through_room_index][1];
                        tail->next = node;
                        tail = node;
                    }
                } else if (through_room_order == DNGMAP_PATH_REVERSE) {
                    for (through_room_index = DNGMAP_ROOM_HOKAN_POINTS - 1; through_room_index >= 0; through_room_index--) {
                        DNGMAP_KOMA_POS *node = reinterpret_cast<DNGMAP_KOMA_POS *>(memory.Alloc(1));
                        node->x = gx + curve[through_room_index][0];
                        node->y = gy + curve[through_room_index][1];
                        tail->next = node;
                        tail = node;
                    }
                }
            }

            if (glid == start) {
                break;
            }

            glid = GetNextGlid(glid, &direction);

            if (glid == nullptr) {
                break;
            }
        }

        tail->next = nullptr;
        DNGMAP_KOMA_POS *first = koma_now->next;

        if (first != nullptr) {
            dng_player_pos[0] = first->x;
            dng_player_pos[1] = first->y;
        }
    }

    return memory.stGetUsed();
}

int CheckDngTreeMapFuncType() {
    if (MenuCommonInfo->open_type == MENU_OPEN_DNG_TREE_MAP) {
        return DNG_TREE_MAP_FUNC_SAVE_POINT;
    }

    if (MenuCommonInfo->open_type == MENU_OPEN_MAIN_DUNGEON || TreeMapCallDungeonSubMap == 1) {
        return DNG_TREE_MAP_FUNC_DUNGEON;
    }

    return DNG_TREE_MAP_FUNC_OTHER;
}

/**
 *
 * First-floor map names for the seven dungeons.
 *
 */
static char *name_tbl_2728[7] = {
    "d01e01",
    "s02",
    "g02",
    "g03",
    "g04",
    "d06e01",
    "m05"};

void MakeDngTreeMapJumpNo(int dng_no, int floor_id, int *loop_no, int *map_no) {
    if (dng_no == 0 && floor_id == 8) {
        *loop_no = LOOP_EDIT;
        *map_no = SearchMapNo("s01");
    }

    if (dng_no == 1 && floor_id == 6) {
        *loop_no = LOOP_EDIT;
        *map_no = SearchMapNo("s05");
    }

    if (dng_no == 3 && floor_id == 20) {
        *loop_no = LOOP_EDIT;
        *map_no = SearchMapNo("d04b01");

        if (CheckBitFlagMenu(0x1B6) && !CheckBitFlagMenu(0x1BC)) {
            *loop_no = LOOP_DUNGEON;
            *map_no = dng_no;
        }
    }

    if (floor_id == 0) {
        *loop_no = LOOP_EDIT;
        *map_no = SearchMapNo(name_tbl_2728[dng_no]);

        if (dng_no == 6) {
            CScene *scene = GetMainScene();
            scene->SetNowMapNo(SearchMapNo("d07f01"));
        }
    }
}

/**
 *
 * Maximum floor number for each dungeon.
 *
 */
static s8 maxidtable_2752[7] = {
    8, 15, 24, 20, 22, 28, 38};

void CMenuTreeMap::InitEnd() {
    dc2::io::FileRead read = dc2::io::FindBackgroundRead(0);
    char              map_name[32];
    std::snprintf(map_name, sizeof(map_name), "dmap%d.json", dng_no);
    int                block = {};
    mgCTextureManager *textures = {};
    u8                *map_img = reinterpret_cast<u8 *>(AssetDirectoryRead(reinterpret_cast<u_int *>(read.Bytes().data()), map_name, nullptr));
    block = tex_block[0];
    textures = &mgTexManager;
    MenuWorkTextureEnter(block, "dngmnwork2", 0x200, 0x100, 0x18);
    textures->EnterIMGFile(map_img, block, nullptr, nullptr);

    if (CheckDngTreeMapFuncType() == DNG_TREE_MAP_FUNC_SAVE_POINT) {
        textures->EnterIMGFile(MenuCursorDataBuff, block, nullptr, nullptr);
    }

    MenuDngMap->SetTextureInfo();
    Floor_InfoTex = textures->GetTexture("dngfibrd", -1);

    if (static_cast<bool>(read)) {
        script = reinterpret_cast<char *>(AssetDirectoryRead(reinterpret_cast<u_int *>(read.Bytes().data()), "dtmap_com.cfg.json", &script_size));
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

        if (select_glid == nullptr) {
            select_glid = MenuDngMap->GetRoomGlid(room_no + 1);
        }

        int        active_room = room_no;
        GLID_INFO *marked = nullptr;
        int        room_count = maxidtable_2752[dng_no];

        for (int i = 0; i < room_count; ++i) {
            GLID_INFO *cell = MenuDngMap->floor_manager->GetDngMapFloorGlidInfo(i);

            if (cell != nullptr && cell->room.mark) {
                active_room = cell->room.floor_id;
                marked = cell;
                break;
            }
        }

        if (select_glid != nullptr &&
            ((select_glid->room.flag & DNGMAP_ROOM_FLAG_SUB) ||
             (select_glid->room.flag & DNGMAP_ROOM_FLAG_BOSS))) {
            marked = select_glid;
            active_room = room_no;
        }

        if (marked != nullptr) {
            select_glid = marked;
        }

        MenuDngMap->ResetDngMapPos(active_room, true);
        float position[2];
        MenuDngMap->CalcGlidPutPos(marked, position[0], position[1], 0);
        position[0] -= 30.0f;
        position[0] -= 20.0f;
        cursor_pos[0] = position[0];
        cursor_pos[1] = position[1];
        FadeInMenu(40, 0.0f);
        int         message_size = 0;
        const auto *message_bytes = AssetDirectoryRead(reinterpret_cast<u_int *>(read.Bytes().data()), "systree.mes", &message_size);
        mes_data = message_bytes != nullptr && message_size > 0 ? dc2::text::MessageTable::Parse(
                                                                      {reinterpret_cast<const std::byte *>(message_bytes), static_cast<std::size_t>(message_size)})
                                                                : dc2::text::MessageTable{};
        MsgInit();
        const auto treasure_name = std::format("dungeon/cfg_file/tbox_d0{}.cfg.json", static_cast<std::int64_t>(dng_no) + 1);
        tresure_loaded = dc2::dungeon::LoadTreasureBoxInfo(tresure, treasure_name);
    }

    DngInfoDrawAlpha = 0;
    MenuCommonInfo->key_enable = true;
    cursor_view = true;
    mode = MENU_ASK_MODE_NONE;
    key_arg_no = DNG_TREE_MAP_SCREEN_MAP;
}

void CMenuTreeMap::MsgInit() {
    for (int i = 0; i < DNG_TREE_MAP_MES_MAX; i++) {
        mes[i].SetMessData(mes_data, mes_data);
        mes[i].MsgPreset(MENU_SCRIPT_MES_ITEMMSG);
        mes[i].fuchi = FUCHI_SHADOW_BLACK_WIDE;
        mes[i].value_zero = true;
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

    if (CheckDngTreeMapFuncType() == DNG_TREE_MAP_FUNC_SAVE_POINT) {
        message->MakeMsg(81);
    } else if (CheckDngTreeMapFuncType() == DNG_TREE_MAP_FUNC_DUNGEON) {
        message->MakeMsg(80);
    }

    message->StepMsg();
    int y = mgScreenHeight - 50;
    int x = mgScreenWidth;
    int width = message->line_w[0];
    x >>= 2;
    width >>= 1;
    message->SetMovePosGyou(0, x - width, y);
    message->SetMovePosGyou(1, ((mgScreenWidth >> 2) * 3) - (message->line_w[1] >> 1), y);
    TreeMapSaveDispY = y;

    if (!TreeMapSaveFlag) {
        message->SetMovePosGyou(1, 600, y);
    }
}

int CMenuTreeMap::FadeInOutMenu() {
    int done = 0;

    switch (mode) {
        case MENU_ASK_MODE_OPEN:
            done = FadeCheckMenu();

            if (done) {
                FadeOutMenu(40, 0.0f);
            }

            break;
        case MENU_ASK_MODE_CLOSE:
            if (!draw_hidden) {
                done = FadeCheckMenu();
            }

            break;
    }

    return done;
}

/**
 *
 * Dungeon used by the floor-information panel.
 *
 */
static u8 DngInfoStageNo = 1;

/**
 *
 * Carries the two file names read while opening the dungeon tree map.
 *
 */
struct DngTreeReadNames {
    char *name[2]; /**< Menu data file and optional second file. */
};

STATIC_ASSERT(sizeof(DngTreeReadNames) == 8);

/**
 *
 * Creates the tree map and attaches its floor-information message windows.
 *
 */
inline CMenuTreeMap::CMenuTreeMap() {
    draw_hidden = false;
    select_glid = nullptr;
    mes_data = nullptr;
    key_arg_no = DNG_TREE_MAP_SCREEN_MAP;
    help_view = true;
    cursor_reset = false;
    money_view = false;
    tresure_loaded = false;

    for (int i = 0; i < DNG_TREE_MAP_MES_MAX; i++) {
        MenuDngMes[i] = &mes[i];
        MenuDngMes[i]->Init();
        MenuDngMes[i]->SetBuff_system(GetSystemMesBuffer());
    }

    MenuDngMes[DNG_TREE_MAP_MES_FAST_DESTROY]->value_space = 0x10;
}

void DngTreeMapInit(mgCMemory *stack, int *tex_block, int menu_mode, int dng_no) {
    CMenuTreePt = nullptr;
    MenuDngMap = nullptr;
    if (stack == nullptr || tex_block == nullptr || stack->stGetRest() <= 0) {
        return;
    }
    int remaining = stack->stGetRest();
    MenuTreeMapStack.stSetBorrowedBuffer(*stack, std::span(stack->stGetTop(), static_cast<std::size_t>(remaining)));
    MenuTreeMapStack.Align64();
    CMenuTreePt = dc2::memory::NewObject<CMenuTreeMap>(MenuTreeMapStack);
    if (CMenuTreePt == nullptr) {
        return;
    }
    CMenuTreePt->SetTexBlock(tex_block);
    MenuDngMap = dc2::memory::NewObject<CDngFreeMap>(MenuTreeMapStack);
    if (MenuDngMap == nullptr) {
        CMenuTreePt = nullptr;
        return;
    }
    MenuDngMap->save_dungeon = MenuSaveDataDungeonPtr;
    DNG_BATTLE_AREA *area = menu_GetBattleAreaScene();
    MenuDngMap->floor_manager = &area->floor_manager;
    DngTreeMode = DNG_TREE_MODE_MAP;
    DngInfoRoomInfo = nullptr;
    dngfloor_backdraw_alpha = 0;

    switch (menu_mode) {
        case MENU_OPEN_MAIN_TOWN:
        case MENU_OPEN_DNG_TREE_MAP: {
            MenuTreeMapStack.Align64();
            MenuCursorDataBuff = reinterpret_cast<u8 *>(MenuTreeMapStack.stGetTop());
            unsigned int size = LoadFileMenu("textures/frametex.json", dc2::memory::RemainingBytes(MenuTreeMapStack), MENU_FILE_LOAD_DIRECT);
            MenuTreeMapStack.Alloc((size & 15) ? (size >> 4) + 1 : size >> 4);
            CMenuTreePt->FadeOutMenu(1, 0.0f);

            if (GetNowLoopNo() == LOOP_EDIT || menu_mode == MENU_OPEN_MAIN_TOWN) {
                MenuDngMap->floor_manager->LoadDataTable(dng_no, &MenuTreeMapStack);
                MenuDngMap->floor_manager->CheckDrawGlidInfo();
                MenuTreeMapStack.Alloc(0x800);
                MenuTreeMapStack.Align64();
            }

            break;
        }
        default:
            if (MenuCommonInfo->cursor_form != nullptr) {
                MenuCommonInfo->cursor_form->draw_flag = 0;
            }

            MenuCommonInfo->SetVibeCnt(0, 0);
            MenuCommonInfo->SetWakuType(-1);
            MenuCommonInfo->key_enable = false;
            MenuCommonInfo->cursor = 0;
            MenuCommonInfo->top_line = 0;
            CMenuTreePt->FadeOutMenu(30, 0.0f);
            break;
    }

    dngfloor_infoview = false;
    dngfloor_backdraw = false;
    TreeMapSaveDispCount = 0;

    if (dng_no < 0 || dng_no > DNGMAP_DUNGEON_MAX) {
        dng_no = 0;
    }

    CMenuTreePt->dng_no = dng_no;
    MenuDngMap->dng_no = dng_no;
    DngInfoStageNo = dng_no;
    char filename[40];
    std::snprintf(filename, sizeof(filename), "dmap%d.pac", dng_no);
    DngTreeReadNames names = {
        {nullptr, nullptr}
    };
    names.name[0] = filename;
    MenuCommonReadData(&MenuTreeMapStack, names.name, MENU_FILE_LOAD_BG);
}

int DngTreeMapKey();

void DngTreeMapDraw() {
    if (CMenuTreePt == nullptr || MenuDngMap == nullptr) {
        return;
    }
    if (DngTreeMode == DNG_TREE_MODE_MAP) {
        CMenuTreePt->Draw();
    } else if (DngTreeMode == DNG_TREE_MODE_SAVE) {
        MenuSaveDraw();
    }
}

template <>
void mgRect<float>::Set(float new_left, float new_top, float new_right, float new_bottom) {
    left = new_left;
    top = new_top;
    right = new_right;
    bottom = new_bottom;
}

const mgRect<int> dng_light_circle(388, 304, 124, 80);
const mgRect<int> dngfreemap_num(0, 0, 12, 18);

mgRect<float> treemap_root_put;
mgRect<int>   Floor_Info(0, 238, 256, 18);
mgCMemory     MenuTreeMapStack;

int CMenuTreeMap::StepMapCore() {
    /**
     *
     * Actions requested by the map, confirmation and material-list keys.
     *
     */
    enum TreeMapAction {
        TREE_MAP_ACTION_NONE = -1,           /**< No action requested. */
        TREE_MAP_ACTION_SELECT = 100,        /**< Opens the selected floor's information or question. */
        TREE_MAP_ACTION_JUMP = 110,          /**< Confirms the selected floor and closes the map. */
        TREE_MAP_ACTION_MATERIALS = 130,     /**< Opens the georama material list. */
        TREE_MAP_ACTION_MATERIAL_PAGE = 131, /**< Advances or closes the georama material list. */
        TREE_MAP_ACTION_CANCEL = 120,        /**< Closes the selected floor's information or question. */
        TREE_MAP_ACTION_CLOSE = 200          /**< Closes the map without selecting a floor. */
    };

    /**
     *
     * Messages that ask about or describe the selected floor.
     *
     */
    enum TreeMapMessage {
        TREE_MAP_MES_JUMP = 0x3C,                /**< Asks whether to go to the selected floor. */
        TREE_MAP_MES_JUMP_NAMED = 0x3D,          /**< Asks whether to go to the named start, sub, exit or boss floor. */
        TREE_MAP_MES_PAY = 2,                    /**< Added to a question for its variant that charges for the jump. */
        TREE_MAP_MES_FLOOR_INFO = 0x40,          /**< Describes a floor without georama materials. */
        TREE_MAP_MES_FLOOR_INFO_MATERIALS = 0x41 /**< Describes a floor with georama materials to list. */
    };

    int           result = DNG_TREE_MAP_CONTINUE;
    CMenuKeyFunc *keys = MenuCommonInfo;

    /**
     *
     * Navigation state reset when the map opens or the cursor moves.
     *
     */
    static int old_direction = -1;

    /**
     *
     * Room the cursor last moved away from, passed back to GetKeyNextRoom.
     *
     */
    static GLID_INFO *old_glid = nullptr;

    CDC2Mes *message = MenuDCMsg[3];
    int      fade_done = FadeInOutMenu();
    MenuDngMap->Step();
    int read_busy = ReadBGSync();
    int selection_changed = false;

    /**
     *
     * Destination cell selected for floor travel.
     *
     */
    static GLID_INFO *NextFloorGlid = nullptr;

    switch (mode) {
        case MENU_ASK_MODE_OPEN: {
            if (fade_done && !read_busy) {
                InitEnd();
                selection_changed = true;
                cursor_reset = true;
                old_direction = -1;
                old_glid = nullptr;
            }

            break;
        }
        case MENU_ASK_MODE_CLOSE: {
            if (fade_done) {
                DeleteTexBlock();
                ExeScript("MSG_END");
                result = DNG_TREE_MAP_CLOSE;

                if (MenuArg.end_code == MENU_END_DNG_MOVE) {
                    result = DNG_TREE_MAP_JUMP;

                    if (TreeMapCallDungeonSubMap) {
                        MenuArg.end_code = MENU_END_WORLD_MOVE;
                        MenuArg.result[0] = LOOP_EDIT;
                        MakeDngTreeMapJumpNo(dng_no, MenuArg.result[2], &MenuArg.result[0], &MenuArg.result[1]);
                        GetSaveData()->ResetBitCtrl(MENU_DEBUG_BIT_CTRL_BOOT_TREEMAP);

                        if (MenuArg.result[2] == 0) {
                            GetSaveData()->save_dungeon.SetFloorID(0);
                        }
                    }

                    if (CheckDngTreeMapFuncType() == DNG_TREE_MAP_FUNC_OTHER && MenuArg.result[0] == LOOP_DUNGEON) {
                        MenuMainScene->skip_load_bgm = 1;
                    }

                    CheckDngTreeMapFuncType();
                    DNG_BATTLE_AREA *area = menu_GetBattleAreaScene();

                    if (area != nullptr) {
                        area->floor_status &= ~(DNG_FLOOR_STATUS_SEAL_MONICA | DNG_FLOOR_STATUS_SEAL_MAX | DNG_FLOOR_STATUS_UNK_4);
                    }
                }

                old_glid = nullptr;
                old_direction = -1;
            }

            break;
        }
        case MENU_ASK_MODE_EXTEND: {
            if (step == 0 && FadeCheckMenu()) {
                DngTreeMode = DNG_TREE_MODE_SAVE;
            }

            if (step == 1 && FadeCheckMenu()) {
                mode = MENU_ASK_MODE_NONE;
            }

            break;
        }
        default: {
            keys->SelDataInit();
            keys->CheckSelectKey();
            int directions = keys->CheckLRKey();
            int buttons = keys->CheckPushButton();
            int action = TREE_MAP_ACTION_NONE;

            switch (key_arg_no) {
                case DNG_TREE_MAP_SCREEN_MAP: {
                    if (menu_debug_flag) {
                        /**
                         *
                         * Floor-save flag toggled by each debug selector row; row zero edits the visit count instead.
                         *
                         */
                        static int bitTable[9] = {
                            DNG_FLOOR_FLAG_OPEN,
                            DNG_FLOOR_FLAG_OPEN,
                            DNG_FLOOR_FLAG_CLEAR,
                            DNG_FLOOR_FLAG_PRACTICE_CLEAR,
                            DNG_FLOOR_FLAG_FAST_DESTROY_CLEAR,
                            DNG_FLOOR_FLAG_FISHING_CLEAR,
                            DNG_FLOOR_FLAG_TALK_MONSTER,
                            DNG_FLOOR_FLAG_SPHEDA_CLEAR,
                            DNG_FLOOR_FLAG_GEOSTONE_FOUND};

                        DNG_FLOOR_SAVE *floor = MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, select_glid->room.floor_id);

                        if (directions & MENU_SELECT_KEY_UP) {
                            --MenuDngDebugFlagSelect;
                        }

                        if (directions & MENU_SELECT_KEY_DOWN) {
                            ++MenuDngDebugFlagSelect;
                        }

                        if (MenuDngDebugFlagSelect < 0) {
                            MenuDngDebugFlagSelect = 0;
                        }

                        if (MenuDngDebugFlagSelect > 8) {
                            MenuDngDebugFlagSelect = 8;
                        }

                        if (MenuDngDebugFlagSelect == 0) {
                            if (((buttons & MENU_PUSH_BUTTON_DECIDE) || (directions & MENU_SELECT_KEY_RIGHT)) && floor != nullptr && floor->visit_count < 30000) {
                                ++floor->visit_count;
                            }

                            if (((buttons & MENU_PUSH_BUTTON_CANCEL) || (directions & MENU_SELECT_KEY_LEFT)) && floor != nullptr && 0 < floor->visit_count) {
                                --floor->visit_count;
                            }
                        }

                        if (MenuDngDebugFlagSelect != 0) {
                            if ((buttons & MENU_PUSH_BUTTON_DECIDE) || (directions & MENU_SELECT_KEY_RIGHT)) {
                                floor->flag |= bitTable[MenuDngDebugFlagSelect];
                            }

                            if ((buttons & MENU_PUSH_BUTTON_CANCEL) || (directions & MENU_SELECT_KEY_LEFT)) {
                                floor->flag &= ~bitTable[MenuDngDebugFlagSelect];
                            }
                        }

                        if (buttons & MENU_PUSH_BUTTON_TRIANGLE) {
                            for (int id = 0;; ++id) {
                                DNG_FLOOR_SAVE *entry = MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, id);

                                if (entry == nullptr) {
                                    break;
                                }

                                if (entry->visit_count < 30000) {
                                    ++entry->visit_count;
                                }

                                entry->flag = DNG_FLOOR_FLAG_OPEN | DNG_FLOOR_FLAG_CLEAR | DNG_FLOOR_FLAG_PRACTICE_CLEAR |
                                              DNG_FLOOR_FLAG_FAST_DESTROY_CLEAR | DNG_FLOOR_FLAG_FISHING_CLEAR |
                                              DNG_FLOOR_FLAG_TALK_MONSTER | DNG_FLOOR_FLAG_SPHEDA_CLEAR | DNG_FLOOR_FLAG_GEOSTONE_FOUND;
                            }
                        }

                        if ((buttons & MENU_PUSH_BUTTON_DECIDE) || (buttons & MENU_PUSH_BUTTON_CANCEL) || (buttons & MENU_PUSH_BUTTON_TRIANGLE) || (directions & MENU_SELECT_KEY_LEFT) || (directions & MENU_SELECT_KEY_RIGHT)) {
                            MenuDngMap->floor_manager->CheckDrawGlidInfo();
                        }

                        if (directions & MENU_SELECT_KEY_R1) {
                            MenuActiveSaveData->SetBitFlag(SAVE_FLAG_FISHING_OPEN, 1);
                            MenuActiveSaveData->SetBitFlag(SAVE_FLAG_SPHEDA_UNLOCKED, 1);
                        }

                        return DNG_TREE_MAP_CONTINUE;
                    }

                    GLID_INFO *next = nullptr;
                    int        dir = -1;

                    if (directions & MENU_SELECT_KEY_UP) {
                        dir = GLID_DIR_UP;
                    } else if (directions & MENU_SELECT_KEY_DOWN) {
                        dir = GLID_DIR_DOWN;
                    } else if (directions & MENU_SELECT_KEY_LEFT) {
                        dir = GLID_DIR_LEFT;
                    } else if (directions & MENU_SELECT_KEY_RIGHT) {
                        dir = GLID_DIR_RIGHT;
                    }

                    if (0 <= dir) {
                        next = MenuDngMap->floor_manager->GetKeyNextRoom(select_glid->room.floor_id, dir, old_glid);
                    }

                    if (next != nullptr && next != select_glid && next->room.selectable == 1) {
                        MenuSePlay(SYSTEM_SE_CURSOR);
                        old_glid = select_glid;
                        old_direction = -1;
                        select_glid = next;
                        MenuDngMap->SetNextRoomPos(select_glid);
                        DngTreeMapActiveLightRate = 0.0f;
                        selection_changed = true;
                    }

                    MenuDngMap->select_glid = select_glid;

                    switch (buttons) {
                        case MENU_PUSH_BUTTON_DECIDE: {
                            action = TREE_MAP_ACTION_SELECT;
                            NextFloorGlid = MenuDngMap->GetEntranceRoomGlid();

                            if (select_glid != nullptr) {
                                NextFloorGlid = select_glid;
                            }

                            GLID_INFO *target = NextFloorGlid;
                            int        current_map = MenuMainScene->now_map_no;

                            if (target == MenuDngMap->GetEntranceRoomGlid() &&
                                ((0 <= current_map && current_map < 11 &&
                                  (GetMapType(MenuMainScene->now_sub_map_no) == MAP_TYPE_GEORAMA_INTERIOR ||
                                   GetMapType(MenuMainScene->now_sub_map_no) == MAP_TYPE_INTERIOR ||
                                   GetMapType(MenuMainScene->now_sub_map_no) == MAP_TYPE_FUTURE_INTERIOR)) ||
                                 (current_map == 1 && MenuMainScene->now_sub_map_no == 100))) {
                                action = TREE_MAP_ACTION_CLOSE;
                            }

                            break;
                        }
                        case MENU_PUSH_BUTTON_CANCEL: {
                            if (CheckDngTreeMapFuncType() == DNG_TREE_MAP_FUNC_SAVE_POINT) {
                                action = TREE_MAP_ACTION_SELECT;
                                NextFloorGlid = MenuDngMap->GetEntranceRoomGlid();
                            } else {
                                action = TREE_MAP_ACTION_CLOSE;
                            }

                            break;
                        }
                        case MENU_PUSH_BUTTON_SQUARE: {
                            if (CheckDngTreeMapFuncType() != DNG_TREE_MAP_FUNC_OTHER) {
                                action = TREE_MAP_ACTION_SELECT;
                                NextFloorGlid = MenuDngMap->GetEntranceRoomGlid();
                            } else {
                                action = TREE_MAP_ACTION_CLOSE;
                            }

                            break;
                        }
                        case MENU_PUSH_BUTTON_TRIANGLE: {
                            if (TreeMapSaveFlag) {
                                FadeOutMenu(40, 0.0f);
                                mode = MENU_ASK_MODE_EXTEND;
                                step = 0;
                                MenuSePlay(SYSTEM_SE_DECIDE);
                            } else {
                                MenuSePlay(SYSTEM_SE_CANCEL);
                            }

                            break;
                        }
                    }

                    break;
                }
                case DNG_TREE_MAP_SCREEN_FLOOR: {
                    if (!DngAskMessageDrawFlag) {
                        if (buttons) {
                            action = TREE_MAP_ACTION_CANCEL;
                        }
                    } else if (dngfloor_infoview) {
                        if (buttons & MENU_PUSH_BUTTON_DECIDE) {
                            action = TREE_MAP_ACTION_JUMP;

                            if (CheckDngTreeMapFuncType() == DNG_TREE_MAP_FUNC_DUNGEON) {
                                action = TREE_MAP_ACTION_NONE;
                            }

                        } else if (buttons & MENU_PUSH_BUTTON_CANCEL) {
                            action = TREE_MAP_ACTION_CANCEL;

                        } else if ((buttons & MENU_PUSH_BUTTON_TRIANGLE) && 0 < GeoramaMateriaNum) {
                            action = TREE_MAP_ACTION_MATERIALS;
                        }
                    } else {
                        int cursor = message->YesNoCursor();

                        if (buttons & MENU_PUSH_BUTTON_DECIDE) {
                            switch (cursor) {
                                case 0:
                                    action = TREE_MAP_ACTION_JUMP;
                                    break;
                                case 1:
                                    action = TREE_MAP_ACTION_CANCEL;
                                    break;
                            }
                        } else if (buttons & MENU_PUSH_BUTTON_CANCEL) {
                            action = TREE_MAP_ACTION_CANCEL;
                        }
                    }

                    break;
                }
                case DNG_TREE_MAP_SCREEN_MATERIALS: {
                    if ((buttons & MENU_PUSH_BUTTON_TRIANGLE) || (buttons & MENU_PUSH_BUTTON_CANCEL)) {
                        action = TREE_MAP_ACTION_MATERIAL_PAGE;
                        MenuSePlay(SYSTEM_SE_DECIDE);
                    }

                    break;
                }
            }

            DNG_FLOOR_SAVE *target_save = NextFloorGlid ? MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, NextFloorGlid->room.floor_id) : nullptr;

            switch (action) {
                case TREE_MAP_ACTION_SELECT: {
                    int loop_no = {}, map_no = {};

                    if (NextFloorGlid == nullptr) {
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    } else if (target_save != nullptr && !(target_save->flag & DNG_FLOOR_FLAG_OPEN)) {
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    } else {
                        if (CheckDngTreeMapFuncType() == DNG_TREE_MAP_FUNC_OTHER && TreeMapCallDungeonSubMap == 1) {
                            MakeDngTreeMapJumpNo(dng_no, NextFloorGlid->room.floor_id, &loop_no, &map_no);

                            if (map_no == MenuMainScene->GetNowMapNo()) {
                                MenuSePlay(SYSTEM_SE_CANCEL);
                                break;
                            }
                        }

                        selection_changed = true;
                        DngAskMessageDrawFlag = DNG_TREE_MAP_ASK_JUMP;

                        if (CheckDngTreeMapFuncType() == DNG_TREE_MAP_FUNC_DUNGEON && !(NextFloorGlid->room.flag & DNGMAP_ROOM_FLAG_START)) {
                            DngAskMessageDrawFlag = DNG_TREE_MAP_ASK_INFO;
                        }

                        if ((DngAskMessageDrawFlag == DNG_TREE_MAP_ASK_NONE || DngAskMessageDrawFlag == DNG_TREE_MAP_ASK_INFO) &&
                            ((NextFloorGlid->room.flag & DNGMAP_ROOM_FLAG_SUB) ||
                             (NextFloorGlid->room.flag & DNGMAP_ROOM_FLAG_BOSS) ||
                             (NextFloorGlid->room.flag & DNGMAP_ROOM_FLAG_EXIT))) {
                            MenuSePlay(SYSTEM_SE_CANCEL);
                            message->SetAbsPos(5);
                        } else {
                            MenuSePlay(SYSTEM_SE_WINDOW);
                            dngfloor_infoview = true;
                            dngfloor_backdraw = true;
                            DngInfoRoomInfo = &NextFloorGlid->room;
                            DngInfoFloorInfo = target_save;
                            int mes_no = TREE_MAP_MES_JUMP;
                            GetSaveData()->GetBitCtrl();
                            int battle_clear = menu_GetBattleAreaScene()->battle_clear;
                            jump_pay = false;

                            if (battle_clear == 0 && MenuCommonInfo->open_type == MENU_OPEN_MAIN_DUNGEON) {
                                jump_pay = true;
                            }

                            if (TreeMapCallDungeonSubMap) {
                                jump_pay = false;
                            }

                            u32 flags = NextFloorGlid->room.flag;

                            if ((flags & DNGMAP_ROOM_FLAG_START) || (flags & DNGMAP_ROOM_FLAG_SUB) || (flags & DNGMAP_ROOM_FLAG_EXIT) || (flags & DNGMAP_ROOM_FLAG_BOSS)) {
                                mes_no = TREE_MAP_MES_JUMP_NAMED;
                                int name_id[1] = {NextFloorGlid->room.floor_id + (dng_no + 1) * 1000};
                                message->SetMsgItemNo(name_id, 1);
                            }

                            if (jump_pay) {
                                mes_no += TREE_MAP_MES_PAY;
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

                            flags = NextFloorGlid->room.flag;

                            if ((flags & DNGMAP_ROOM_FLAG_EXIT) || (flags & DNGMAP_ROOM_FLAG_START) || (flags & DNGMAP_ROOM_FLAG_SUB) || (flags & DNGMAP_ROOM_FLAG_BOSS)) {
                                message->abs_win.x = -1;
                                message->abs_win.y = -1;
                                message->SetAbsPos(5);
                                dngfloor_infoview = false;
                            }

                            message->window_mode = MES_WIN_YESNO;
                            message->fuchi = FUCHI_SHADOW_BLACK_WIDE;
                            message->font_w = 15;
                            message->SetMsgCursor(1);
                            message->MakeMsg(mes_no);
                            money_view = false;

                            if (jump_pay) {
                                money_view = true;
                            }

                            GeoramaMateriaNum = 0;

                            if (dngfloor_infoview == 1) {
                                message->window_mode = MES_WIN_NONE;
                                message->fuchi = FUCHI_OUTLINE_THICK;

                                if (LanguageCode > LANG_JAPANESE) {
                                    message->font_w = 17;
                                }

                                message->fade_speed = 1.0f;
                                message->fade = 1.0f;
                                message->select_top = -1;
                                message->SetMsgCursor(-1);
                                GeoramaMateriaNum = CheckGeoramaMateria(&tresure, select_glid->room.floor_id, georama_materia);

                                if (!(target_save->flag & DNG_FLOOR_FLAG_CLEAR)) {
                                    GeoramaMateriaNum = 0;
                                }

                                if (GeoramaMateriaNum <= 0) {
                                    message->SetMovePosGyou(0, 0x46, mgScreenHeight - 0x32);
                                    message->SetMovePosGyou(1, 0x14A, mgScreenHeight - 0x32);
                                    message->MakeMsg(TREE_MAP_MES_FLOOR_INFO);
                                } else {
                                    message->MakeMsg(TREE_MAP_MES_FLOOR_INFO_MATERIALS);
                                    message->SetMovePosGyou(0, 0x46, mgScreenHeight - 0x46);
                                    message->SetMovePosGyou(1, 0x14A, mgScreenHeight - 0x32);
                                    message->SetMovePosGyou(2, 0x46, mgScreenHeight - 0x2C);

                                    if (LanguageCode == LANG_ITALIAN || LanguageCode == LANG_SPANISH) {
                                        message->SetMovePosGyou(0, 0x2E, mgScreenHeight - 0x46);
                                        message->SetMovePosGyou(1, 0x160, mgScreenHeight - 0x32);
                                        message->SetMovePosGyou(2, 0x2E, mgScreenHeight - 0x2C);
                                    }

                                    if (CheckDngTreeMapFuncType() == DNG_TREE_MAP_FUNC_DUNGEON) {
                                        message->SetMovePosGyou(0, 0x208, mgScreenHeight - 0x46);
                                        message->SetMovePosGyou(1, 0x208, mgScreenHeight - 0x32);
                                    }
                                }

                                money_view = false;
                            }

                            cursor_view = false;
                            key_arg_no = DNG_TREE_MAP_SCREEN_FLOOR;
                        }
                    }

                    break;
                }
                case TREE_MAP_ACTION_JUMP: {
                    MenuSePlay(SYSTEM_SE_DECIDE);

                    if (jump_pay) {
                        int money = -MenuUserDataManPtr->money;

                        if (money < 0) {
                            ++money;
                        }

                        MenuUserDataManPtr->AddMoney(money >> 1);
                    }

                    MenuArg.result[1] = 0;
                    MenuArg.end_code = MENU_END_DNG_MOVE;
                    MenuArg.result[0] = LOOP_EDIT;

                    if (MenuDngMap->user_glid != nullptr) {
                        MenuSaveDataDungeonPtr->stage_id = dng_no;
                        MenuArg.result[1] = MenuSaveDataDungeonPtr->prev_floor_id[MenuSaveDataDungeonPtr->stage_id];
                    }

                    MenuArg.result[2] = NextFloorGlid->room.floor_id;
                    int jump_event = false;
                    u32 room_flags = NextFloorGlid->room.flag;

                    if ((room_flags & DNGMAP_ROOM_FLAG_SUB) || (room_flags & DNGMAP_ROOM_FLAG_BOSS)) {
                        if (CMenuTreePt->dng_no == 1 && NextFloorGlid->room.floor_id == 6) {
                            MenuMainScene->skip_play_bgm = 1;
                        } else {
                            jump_event = true;
                        }

                        MenuSaveDataDungeonPtr->SetFloorID(MenuArg.result[2]);
                    }

                    if (CMenuTreePt->dng_no == 0) {
                        if (MenuArg.result[2] == 3 && !CheckBitFlagMenu(0x66)) {
                            jump_event = true;
                        }

                        if (MenuArg.result[2] == 8 && !CheckBitFlagMenu(0xC9)) {
                            jump_event = true;
                        }

                        if (MenuArg.result[2] == 6) {
                            jump_event = true;
                        }
                    }

                    if (CMenuTreePt->dng_no == 1) {
                        if (MenuArg.result[2] == 2 && !CheckBitFlagMenu(0xD4)) {
                            jump_event = true;
                        }

                        if (MenuArg.result[2] == 14) {
                            jump_event = true;
                        }
                    }

                    if (CMenuTreePt->dng_no == 2) {
                        if (MenuArg.result[2] == 2 && !CheckBitFlagMenu(0x133)) {
                            jump_event = true;
                        }

                        if (MenuArg.result[2] == 21 && !CheckBitFlagMenu(SAVE_FLAG_FISHING_CONTEST_UNLOCKED)) {
                            jump_event = true;
                        }

                        if (MenuArg.result[2] == 22) {
                            jump_event = true;
                        }
                    }

                    if (CMenuTreePt->dng_no == 3) {
                        if (MenuArg.result[2] == 2 && !CheckBitFlagMenu(0x196)) {
                            jump_event = true;
                        }

                        if (MenuArg.result[2] == 17 && !CheckBitFlagMenu(SAVE_FLAG_FINNY_FRENZY_UNLOCKED)) {
                            jump_event = true;
                        }

                        if (MenuArg.result[2] == 19) {
                            jump_event = true;
                        }
                    }

                    if (CMenuTreePt->dng_no == 4) {
                        if (MenuArg.result[2] == 21) {
                            jump_event = true;
                        }
                    }

                    if (CMenuTreePt->dng_no == 5) {
                        if (MenuArg.result[2] == 26) {
                            jump_event = true;
                        }
                    }

                    if (CMenuTreePt->dng_no == 6 && MenuArg.result[2] == 37) {
                        jump_event = true;
                    }

                    if (jump_event) {
                        MenuMainScene->skip_load_bgm = 1;
                    }

                    draw_hidden = false;
                    mode = MENU_ASK_MODE_CLOSE;
                    FadeOutMenu(40, 0.0f);

                    break;
                }
                case TREE_MAP_ACTION_MATERIALS: {
                    dngfloor_infoview = false;
                    dngfloor_backdraw = true;
                    GeoramaMateriaInfoDrawFlag = true;
                    GeoramaMateriaInfoDrawPage = 0;
                    DngInfoDrawAlpha = 0;
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    key_arg_no = DNG_TREE_MAP_SCREEN_MATERIALS;

                    break;
                }
                case TREE_MAP_ACTION_MATERIAL_PAGE: {
                    if (GeoramaMateriaNum > DNG_TREE_MAP_MATERIA_PAGE && GeoramaMateriaInfoDrawPage == 0) {
                        GeoramaMateriaInfoDrawPage++;
                    } else {
                        DngInfoDrawAlpha = 128;
                        key_arg_no = DNG_TREE_MAP_SCREEN_FLOOR;
                        dngfloor_infoview = true;
                        GeoramaMateriaInfoDrawFlag = false;
                    }

                    break;
                }
                case TREE_MAP_ACTION_CANCEL: {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    key_arg_no = DNG_TREE_MAP_SCREEN_MAP;
                    dngfloor_infoview = false;
                    dngfloor_backdraw = false;
                    cursor_view = true;
                    money_view = false;

                    break;
                }
                case TREE_MAP_ACTION_CLOSE: {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    FadeOutMenu(40, 0.0f);
                    draw_hidden = false;
                    mode = MENU_ASK_MODE_CLOSE;
                    cursor_view = false;

                    break;
                }
            }

            break;
        }
    }

    if (select_glid != nullptr && select_glid->type == GLID_TYPE_ROOM) {
        DngInfoFloorInfo = MenuSaveDataDungeonPtr->GetFloorInfoPtr(dng_no, select_glid->room.floor_id);

        if (selection_changed) {
            GLID_INFO        *glid = select_glid;
            int               messages[DNG_TREE_MAP_MES_MAX] = {glid->room.floor_id + (dng_no + 1) * 1000, 0x96, 0x97, 0x98,
                                                                0x99, glid->room.practice_type + 100, 0x9B, 0x46};
            int               practice_items[4] = {0, 0, 0, 0};
            char              time_text[72];
            DNGMAP_ROOM_INFO *room = &glid->room;

            if (glid->room.practice_type == 0) {
                int seconds = room->practice_param / 60;
                int challenge_values[2] = {seconds / 60, seconds % 60};

                if (challenge_values[1] == 0) {
                    messages[DNG_TREE_MAP_MES_PRACTICE] = 0x5A;
                } else {
                    messages[DNG_TREE_MAP_MES_PRACTICE] = 0x5B;
                }

                mes[DNG_TREE_MAP_MES_PRACTICE].SetMsgVolumeNo(challenge_values, 2);
            }

            if (room->practice_type == 1 || room->practice_type == 2 || room->practice_type == 3 || room->practice_type == 4) {
                messages[DNG_TREE_MAP_MES_PRACTICE] = room->practice_param + 0x65;
            }

            if (room->practice_type == 5) {
                messages[DNG_TREE_MAP_MES_PRACTICE] = 0x6C;
            }

            if (room->fishing < 0) {
                messages[DNG_TREE_MAP_MES_FISHING] = 0x79;
            }

            if (0 < room->fishing) {
                messages[DNG_TREE_MAP_MES_FISHING] = 0x78;
            }

            mes[DNG_TREE_MAP_MES_FISHING].SetMsgVolumeNoOne(room->fishing_record);
            DngInfoFishOkFlag = CheckBitFlagMenu(SAVE_FLAG_FISHING_OPEN) != 0;
            DngInfoSphidaOkFlag = CheckBitFlagMenu(SAVE_FLAG_SPHEDA_UNLOCKED) != 0;

            if (!DngInfoFishOkFlag) {
                messages[DNG_TREE_MAP_MES_FISHING] = 2;
            }

            if (!DngInfoSphidaOkFlag) {
                messages[DNG_TREE_MAP_MES_SPHEDA] = 2;
            }

            int prize_no[1] = {41};

            if (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_SPHEDA_CLEAR) {
                prize_no[0] = 0x28;
            }

            mes[DNG_TREE_MAP_MES_SPHEDA].SetMsgItemNo(prize_no, 1);
            practice_items[0] = 0x29;

            if (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_PRACTICE_CLEAR) {
                practice_items[0] = 0x28;
            }

            mes[DNG_TREE_MAP_MES_PRACTICE].SetMsgItemNo(practice_items, 1);

            if (CheckNowEurope()) {
                mes[DNG_TREE_MAP_MES_KILL_COUNT].value_half = true;
            }

            mes[DNG_TREE_MAP_MES_KILL_COUNT].SetMsgVolumeNoOne(DngInfoFloorInfo->kill_count);
            int total_seconds = {};
            int target_time = room->fast_destroy_time;
            int best_time = DngInfoFloorInfo->fast_destroy_time;
            total_seconds = target_time / 60;

            if (best_time != 0 && best_time < target_time) {
                total_seconds = best_time / 60;
            }

            if (!(DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_FAST_DESTROY_CLEAR)) {
                messages[DNG_TREE_MAP_MES_FAST_DESTROY] = 0x9A;
            }

            int time_minutes = total_seconds / 60;
            int seconds = total_seconds % 60;

            if (time_minutes > 99) {
                dc2::text::Copy(time_text, dc2::text::View("\x82\x58\x82\x58\x81\x46\x82\x58\x82\x58"));

                if (CheckNowEurope()) {
                    dc2::text::Copy(time_text, dc2::text::View("99:99"));
                }
            } else if (CheckNowEurope()) {
                if (time_minutes / 10 <= 0) {
                    if (seconds / 10 <= 0) {
                        std::snprintf(time_text, sizeof(time_text), "0%d:0%d", time_minutes, seconds);
                    } else {
                        std::snprintf(time_text, sizeof(time_text), "0%d:%d%d", time_minutes, seconds / 10, seconds % 10);
                    }
                } else {
                    if (seconds / 10 <= 0) {
                        std::snprintf(time_text, sizeof(time_text), "%d:0%d", time_minutes, seconds);
                    } else {
                        std::snprintf(time_text, sizeof(time_text), "%d:%d%d", time_minutes, seconds / 10, seconds % 10);
                    }
                }
            } else {
                if (time_minutes / 10 <= 0) {
                    dc2::text::Copy(time_text, dc2::text::View("\x82\x4F"));
                } else {
                    dc2::text::Copy(time_text, dc2::text::View(GetMenuBigNum(time_minutes / 10)));
                }

                dc2::text::Append(time_text, dc2::text::View(GetMenuBigNum(time_minutes % 10)));
                dc2::text::Append(time_text, dc2::text::View("\x81\x46"));

                if (seconds / 10 <= 0) {
                    dc2::text::Append(time_text, dc2::text::View("\x82\x4F"));
                } else {
                    dc2::text::Append(time_text, dc2::text::View(GetMenuBigNum(seconds / 10)));
                }

                dc2::text::Append(time_text, dc2::text::View(GetMenuBigNum(seconds % 10)));
            }

            char *time_ptr[1] = {time_text};
            mes[DNG_TREE_MAP_MES_FAST_DESTROY].SetMsgItemNo(time_ptr, 1);
            messages[DNG_TREE_MAP_MES_GEOSTONE] = 0x47;

            if (DngInfoFloorInfo->flag & DNG_FLOOR_FLAG_GEOSTONE_FOUND) {
                messages[DNG_TREE_MAP_MES_GEOSTONE] = 0x46;
            }

            if (!room->geostone) {
                messages[DNG_TREE_MAP_MES_GEOSTONE] = 2;
            }

            for (int i = 0; i < DNG_TREE_MAP_MES_MAX; ++i) {
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

void CMenuTreeMap::DrawMapCore() {
    if ((mode & 2) && draw_hidden == 1) {
        return;
    }

    MenuDngMap->Draw();
    int show_help = false;

    if (help_view && !dngfloor_infoview && key_arg_no == DNG_TREE_MAP_SCREEN_MAP) {
        show_help = true;
    }

    if (menu_debug_flag) {
        show_help = false;
    }

    mgCTextureManager *textures = &mgTexManager;
    mgCDrawPrim       *prim = GetMenuPrim();

    if (show_help) {
        textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) nullptr);
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

                if (PI <= TreeMapSaveHopCount) {
                    TreeMapSaveHopCount -= PI;
                }

                MenuDCMsg[6]->SetMovePosGyou(1, MenuDCMsg[6]->line_pos[1][0],
                                             static_cast<int>(static_cast<float>(TreeMapSaveDispY) - 10.0f * sinf(TreeMapSaveHopCount)));
            }
        }
    }

    if (MenuDngMap->select_glid != nullptr) {
        if (dngfloor_backdraw) {
            CalcMenuAdd(&dngfloor_backdraw_alpha, 3, 64);
        } else {
            CalcMenuAdd(&dngfloor_backdraw_alpha, -3, 0);
        }

        DrawMenuFillBox(dngfloor_backdraw_alpha, 0, 0, 0);
        int number_x = 540;
        int number_y = 0;
        int number_alpha = 0;
        int medal = GetUserDataMan()->GetYarikomiMedal();

        if (Floor_InfoTex != nullptr) {
            textures->ReloadTexture(Floor_InfoTex->block, (sceVif1Packet *) nullptr);
            int alpha = dngfloor_backdraw_alpha * 2;
            SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
            prim->Begin(MG_PRIM_SPRITE);
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

        if (GeoramaMateriaInfoDrawFlag && Floor_InfoTex != nullptr) {
            DrawGeoramaMateria(94, MenuDngMap->select_glid->room.title,
                               GeoramaMateriaNum, georama_materia, Floor_InfoTex->block);
        }

        MenuDngMap->DrawDngName(128);
        textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) nullptr);
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

    if (cursor_reset) {
        cursor_pos[0] = pos[0];
        cursor_pos[1] = pos[1];
        cursor_reset = false;
    }

    int cursor_alpha = {};

    if (mode == MENU_ASK_MODE_OPEN) {
        cursor_alpha = 0;
    } else {
        cursor_alpha = 128;

        if (mode == MENU_ASK_MODE_CLOSE) {
            cursor_alpha = 0;
        }
    }

    if (cursor_view) {
        mgCTexture *cursor = textures->GetTexture("mnmain", -1);

        if (cursor == nullptr) {
            return;
        }

        textures->ReloadTexture(cursor->block, (sceVif1Packet *) nullptr);
        MenuCursorDraw(cursor, cursor_pos, 0.0f, cursor_alpha);
    }

    if (money_view && Floor_InfoTex != nullptr) {
        textures->ReloadTexture(Floor_InfoTex->block, (sceVif1Packet *) nullptr);
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        int y_money = mgScreenHeight - 76;
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(Floor_InfoTex);
        prim->Color(128, 128, 128, 128);
        PrimQuad(prim, 302.0f, static_cast<float>(y_money), mgRect<int>(0, 144, 184, 36));
        number_rect.Set(0, 126, 12, 18);
        prim->Color(128, 128, 128, 128);
        PrimDrawNumber(prim, GetUserDataMan()->money, MENU_NUMBER_ALIGN_RIGHT, 426, y_money + 7,
                       number_rect, -1, 0);
        prim->End();
    }

    textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) nullptr);

    if (key_arg_no == DNG_TREE_MAP_SCREEN_FLOOR && DngAskMessageDrawFlag == DNG_TREE_MAP_ASK_JUMP) {
        MenuDCMsg[3]->StepMsg();
        MenuDCMsg[3]->DrawMsg();
    }
}

#include "common.h"

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <numbers>
#include <optional>
#include <vector>

#include "floor_monsters.hpp"
#include "mainloop.hpp"
#include "memcard.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "mg_drawprim.hpp"
#include "mglib.hpp"
#include "object/dun/map_presentation.hpp"
#include "render/primitive_submission.hpp"
#include "render/renderer.hpp"
#include "stubs/dngmenu.hpp"

namespace {

// How a passage cell is drawn: which edges of the cell its line joins.
enum class RootShape : u8 {
    Vertical = 0,     // top centre down to the bottom centre
    Horizontal = 1,   // left to right across the middle
    RightAndDown = 2, // middle to the right, branching down from the middle
    LeftAndDown = 3,  // left to the middle, branching down from the middle
    UpAndRight = 4,   // top centre down to the middle, then to the right
    UpAndLeft = 5,    // left to the middle, then up to the top centre
    DownToRight = 6,  // bottom centre up to the right of the middle
    LeftToDown = 7,   // left of the middle down to the bottom centre
    UpToRight = 8,    // top centre down to the right of the middle
    LeftToUp = 9,     // left of the middle up to the top centre
};

// Offset of a passage mark from its grid cell.
struct NativeRootMarkOffset {
    s16 x;
    s16 y;
};

constexpr NativeRootMarkOffset kNativeRootMarkOffsets[10] = {
    {.x = 6, .y = -2},
    {.x = 4, .y = -2},
    {.x = 4, .y = -2},
    {.x = 4, .y = -2},
    {.x = 4, .y = -2},
    {.x = 4, .y = -2},
    {.x = 4, .y = -2},
    {.x = 4, .y = -2},
    {.x = 4, .y = -2},
    {.x = 4, .y = -2},
};

// The one passage mark of dungeon six that sits off its usual place.
constexpr NativeRootMarkOffset kZerumaitoMarkOffset = {.x = 13, .y = -11};

// Texture coordinates of the passage-type marks.
constexpr s16 kRootTypeTexture[5][2] = {
    {0,   0 },
    {490, 0 },
    {490, 22},
    {490, 44},
    {294, 18},
};

// Texture rectangles of the visited-room labels; a negative left ends the table.
constexpr s16 kRoomLabelTexture[4][4] = {
    {0,  172, 62, 22},
    {0,  194, 62, 20},
    {0,  216, 62, 20},
    {-1, 0,   0,  0 },
};

// Destination offsets of the visited-room labels within the room picture.
constexpr NativeRootMarkOffset kRoomLabelOffset[4] = {
    {.x = 20, .y = -7},
    {.x = 20, .y = -7},
    {.x = 20, .y = 0 },
    {.x = 10, .y = 10},
};

// Room-mark animation speed in menu and event modes.
constexpr float kRoomMarkStep[2] = {0.0628318563f, 0.125663713f};

// Retail strokes a passage with three lines a pixel apart, some of them not parallel. The GS draws a line one pixel
// thick across its minor axis, so the three join into one solid stroke; a host line is one physical pixel wide and
// leaves three hairlines at native resolution. Each three lines are filled here as one band: the convex hull of the
// pixel-wide bands the GS covers.
class PassageStroke {
public:
    explicit PassageStroke(mgCDrawPrim &builder) : prim(builder) {}

    void Color() {
        Flush();
        mgPortPrimColor(prim, color);
    }

    void Line(float x0, float y0, float x1, float y1) {
        const bool  x_major = std::fabs(x1 - x0) >= std::fabs(y1 - y0);
        const float across_x = x_major ? 0.0f : 1.0f;
        const float across_y = x_major ? 1.0f : 0.0f;
        points.push_back({.x = x0, .y = y0});
        points.push_back({.x = x1, .y = y1});
        points.push_back({.x = x1 + across_x, .y = y1 + across_y});
        points.push_back({.x = x0 + across_x, .y = y0 + across_y});

        if (points.size() == kBandPoints) {
            FillBand();
        }
    }

    void Flush() {
        FillBand();

        if (!vertices.empty()) {
            mgPortPrimSubmit(prim, gfx::Primitive::Triangles, vertices);
            vertices.clear();
        }
    }

private:
    struct Point {
        float x;
        float y;
    };

    // Four corners for each of a passage's three lines.
    static constexpr std::size_t kBandPoints = 12;

    // Fills the convex hull of the pending corners as a triangle fan.
    void FillBand() {
        if (points.empty()) {
            return;
        }

        std::ranges::sort(points, [](const Point &a, const Point &b) { return a.x < b.x || (a.x == b.x && a.y < b.y); });
        const auto cross = [](const Point &o, const Point &a, const Point &b) {
            return (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x);
        };
        // Andrew's monotone chain: the lower hull, then the upper, without collinear points.
        std::vector<Point> hull;

        for (int pass = 0; pass < 2; ++pass) {
            const std::size_t first = hull.size();

            for (std::size_t n = 0; n < points.size(); ++n) {
                const Point &point = pass == 0 ? points[n] : points[points.size() - 1 - n];

                while (hull.size() >= first + 2 && cross(hull[hull.size() - 2], hull.back(), point) <= 0.0f) {
                    hull.pop_back();
                }

                hull.push_back(point);
            }

            hull.pop_back();
        }

        points.clear();
        const auto vertex = [this](const Point &point) {
            return mgPortPrimVertex(prim, point.x, point.y, 0.0f, 0.0f, 0.0f, color);
        };

        for (std::size_t i = 1; i + 1 < hull.size(); ++i) {
            vertices.insert(vertices.end(), {vertex(hull[0]), vertex(hull[i]), vertex(hull[i + 1])});
        }
    }

    mgCDrawPrim               &prim;
    uint8_t                    color[4] = {};
    std::vector<Point>         points;
    std::vector<gfx::Vertex2D> vertices;
};

} // namespace

// Retail skips passages and rooms past the right and bottom of the 4:3 screen, which a wider window shows.
// Both are culled against the visible extent in UI units instead, and the passage lines are filled as solid strokes.
void CDngFreeMap::DrawRoot(mgRect<float> rect, DNGMAP_ROOT_INFO *root, int shadow, unsigned int marks,
                           int opacity) {
    const auto extent = mgPortVisibleUiExtent(mgPortCurrentTarget());

    if (root == nullptr || extent.right < rect.left || rect.top > extent.bottom + 20.0f) {
        return;
    }

    mgRect<float> &put = treemap_root_put;
    put = rect;

    if (shadow) {
        put.left += 8.0f;
        put.top += 8.0f;
    }

    float                       mark_color = 128.0f;
    float                       red = 212.0f;
    float                       green = 192.0f;
    float                       blue = 144.0f;
    const NativeRootMarkOffset *mark = kNativeRootMarkOffsets;

    if (mode == DNGMAP_MODE_EVENT) {
        mark_color = 64.0f;
        red = 128.0f;
        green = 111.0f;
        blue = 0.0f;
    }

    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_COLOR_AA);
    prim->Begin(MG_PRIM_LINE);
    prim->Color(static_cast<int>(red), static_cast<int>(green), static_cast<int>(blue), opacity);

    if (shadow) {
        prim->Color(0, 0, 0, static_cast<int>(0.05f * static_cast<float>(opacity)));
    }

    PassageStroke stroke(*prim);
    stroke.Color();
    const auto shape = static_cast<RootShape>(root->shape);

    if (shape == RootShape::Horizontal || shape == RootShape::RightAndDown || shape == RootShape::LeftAndDown ||
        shape == RootShape::DownToRight || shape == RootShape::LeftToDown) {
        put.left -= 5.0f;
    }

    put.right = put.left + 52.0f;
    put.bottom = put.top + 20.0f;

    switch (shape) {
        case RootShape::Vertical:
            put.left += 26.0f;

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(put.left + i, put.top, put.left + i + -16.0f, put.bottom);
            }

            mark = &kNativeRootMarkOffsets[0];

            if (dng_no == 6) {
                mark = &kZerumaitoMarkOffset;
            }

            break;
        case RootShape::Horizontal:
            if (marks & DNGMAP_GLID_MARK_SPECIAL_LEFT) {
                put.left += 14.0f;
            }

            put.top += 10.0f;

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(put.left - i, put.top + i, put.right - i, put.top + i);
            }

            mark = &kNativeRootMarkOffsets[1];
            break;
        case RootShape::RightAndDown:
            put.left += 25.0f;
            put.top += 10.0f;

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(put.left - i, put.top + i, put.right - i, put.top + i);
            }

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(put.left + i, put.top, put.left + i - 10.0f, put.bottom);
            }

            mark = &kNativeRootMarkOffsets[2];
            break;
        case RootShape::LeftAndDown:
            put.right -= 27.0f;
            put.top += 10.0f;

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(put.left - i, put.top + i, put.right - i, put.top + i);
            }

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(put.right + i, put.top, put.right + i - 10.0f, put.bottom);
            }

            mark = &kNativeRootMarkOffsets[3];
            break;
        case RootShape::UpAndRight: {
            put.left += 26.0f;
            put.bottom -= 10.0f;
            const float inner_left = put.left - 2.0f;
            const float inner_bottom = put.bottom + 2.0f;

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(put.left + i, put.top, put.left + i - 10.0f, inner_bottom);
            }

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(inner_left - i - 5.0f, put.bottom + i, put.right - i - 5.0f,
                            put.bottom + i);
            }

            mark = &kNativeRootMarkOffsets[4];
            break;
        }
        case RootShape::UpAndLeft:
            put.right -= 26.0f;
            put.bottom -= 10.0f;
            put.left += 1.0f;

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(put.left - i - 5.0f - 1.0f, put.bottom + i, put.right - i - 5.0f - 1.0f,
                            put.bottom + i);
            }

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(put.right + i, put.top, put.right + i - 10.0f + 1.0f, put.bottom);
            }

            mark = &kNativeRootMarkOffsets[5];
            put.left = put.right;
            break;
        case RootShape::DownToRight:
            put.left += 15.5f;
            put.top += 10.0f;

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(put.left + i, put.bottom, put.right - i, put.top + i);
            }

            break;
        case RootShape::LeftToDown:
            put.left -= 1.0f;
            put.right -= 35.0f;
            put.top += 10.0f;

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(put.left - i / 2.0f, put.top + i, put.right - i, put.bottom);
            }

            break;
        case RootShape::UpToRight:
            put.left += 26.0f;
            put.right -= 5.5f;
            put.bottom -= 10.0f;

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(put.left + 1.5f - i, put.top, put.right - i / 2.0f, put.bottom + i);
            }

            break;
        case RootShape::LeftToUp:
            put.left -= 6.0f;
            put.right -= 26.0f;
            put.bottom -= 10.0f;

            for (float i = 0.0f; i < 3.0f; i++) {
                stroke.Line(put.left - i, put.bottom + i, put.right + i, put.top);
            }

            break;
    }

    stroke.Flush();
    prim->End();
    prim->Bilinear(0);
    prim->TextureMapEnable(1);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Color(static_cast<int>(red), static_cast<int>(green), static_cast<int>(blue), opacity);

    if (shadow) {
        prim->Color(0, 0, 0, static_cast<int>(0.05f * static_cast<float>(opacity)));
    }

    prim->Texture(map_tex);

    if (root->type != DNGMAP_ROOT_NORMAL && static_cast<u8>(root->opened) != 0 && root->show_mark && mark != nullptr) {
        prim->Color(static_cast<int>(mark_color), static_cast<int>(mark_color), static_cast<int>(mark_color), opacity);

        if (shadow) {
            prim->Color(0, 0, 0, static_cast<int>(0.05f * static_cast<float>(opacity)));
        }

        const int type = root->type;
        prim->TextureCrd(kRootTypeTexture[type][0], kRootTypeTexture[type][1]);
        prim->Vertex(rect.left + static_cast<float>(mark->x), rect.top + static_cast<float>(mark->y), 0.0f);
        prim->TextureCrd(kRootTypeTexture[type][0] + 22, kRootTypeTexture[type][1] + 22);
        prim->Vertex(rect.left + static_cast<float>(mark->x) + 22.0f, rect.top + static_cast<float>(mark->y) + 22.0f, 0.0f);
    }

    prim->End();
}

std::optional<mgRect<float>> PortDngRoomPicture(int dng_no, const DNGMAP_ROOM_INFO &room, float x, float y, float right,
                                                float bottom) {
    if (x > right + 20.0f || y > bottom + 30.0f) {
        return std::nullopt;
    }

    mgRect<float> picture(x - 30.0f, y - 42.0f, 96.0f, 66.0f);

    if (dng_no == 4 || dng_no == 5 || dng_no == 6) {
        picture.right = 100.0f;
        picture.bottom = 68.0f;
    }

    if (room.visited) {
        // Sub and boss rooms draw their larger special picture.
        if ((room.flag & DNGMAP_ROOM_FLAG_SUB) || (room.flag & DNGMAP_ROOM_FLAG_BOSS)) {
            picture.right = 96.0f;
            picture.bottom = 96.0f;
        }

        picture.left += static_cast<float>(room.offset_x);
        picture.top += static_cast<float>(room.offset_y);
    }

    return picture;
}

void CDngFreeMap::DrawRoomOne(mgRect<float> rect, DNGMAP_ROOM_INFO *room, unsigned int /*unused*/,
                              int opacity, float brightness) {
    if (room == nullptr) {
        return;
    }

    const auto extent = mgPortVisibleUiExtent(mgPortCurrentTarget());
    const auto placed = PortDngRoomPicture(dng_no, *room, rect.left, rect.top, extent.right, extent.bottom);

    if (!placed) {
        return;
    }

    const mgRect<float> picture = *placed;
    mgCDrawPrim        *prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    mgRect<int> tex;
    mgRect<int> special;
    tex.Set(0, 66, 96, 66);
    special.Set(192, 198, 96, 96);
    const int tex_no = room->tex_no;

    if (!room->visited) {
        tex.left = 0;
        tex.top = 0;
    } else {
        const int column = tex_no % 5;
        const int row = tex_no / 5;
        tex.left += tex.right * column;
        tex.top += tex.bottom * row;

        if (room->flag & DNGMAP_ROOM_FLAG_START) {
            tex.left = 96;
            tex.top = 0;
        }

        if (room->flag & DNGMAP_ROOM_FLAG_EXIT) {
            tex.left = 192;
            tex.top = 0;
        }

        if ((room->flag & DNGMAP_ROOM_FLAG_SUB) || (room->flag & DNGMAP_ROOM_FLAG_BOSS)) {
            tex.left = special.left + (room->tex_no % 3) * 96;
            tex.top = special.top + (room->tex_no / 3) * 96;
            tex.right = special.right;
            tex.bottom = special.bottom;

            if (room->tex_no >= 3) {
                tex.bottom = 90;
            }
        }
    }

    int   level = static_cast<int>(128.0f * brightness);
    float shadow_alpha = 0.25f * static_cast<float>(opacity);
    float event_brightness = 1.0f;

    if (mode == DNGMAP_MODE_EVENT && user_glid != nullptr && &user_glid->room != room) {
        level = static_cast<int>(64.0f * brightness);
        event_brightness = 0.5f;
    }

    if (mode == DNGMAP_MODE_MENU) {
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(map_tex);
        prim->Color(0, 0, 0, static_cast<int>(shadow_alpha));
        PrimQuad(prim, picture.left + 8.0f, picture.top + 8.0f, tex);
        prim->End();
    }

    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    room->mark_phase += kRoomMarkStep[mode];

    if (room->mark_phase > std::numbers::pi_v<float>) {
        room->mark_phase -= TWO_PI;
    }

    int r = 192;
    int g = 192;
    int b = 192;

    if (room->mark) {
        float phase = room->mark_phase;

        while (phase > std::numbers::pi_v<float>) {
            phase -= TWO_PI;
        }

        while (phase < -std::numbers::pi_v<float>) {
            phase += TWO_PI;
        }

        if (phase > 0.0f) {
            b = g = r = static_cast<int>(7.0f * static_cast<float>(level) / 8.0f);
        }
    } else {
        b = g = r = level;
    }

    prim->Bilinear(0);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(map_tex);
    prim->Color(r, g, b, opacity);
    PrimQuad(prim, picture, tex);
    prim->End();

    if (!room->visited && user_glid != nullptr && &user_glid->room != room) {
        const float overlay_left = picture.left + 40.0f;
        const float overlay_top = picture.top + 25.0f;
        prim->Begin(MG_PRIM_SPRITE);
        prim->Color(r, g, b, opacity);
        prim->TextureCrd(492, 66);
        prim->Vertex(static_cast<int>(overlay_left), static_cast<int>(overlay_top), 0);
        prim->TextureCrd(512, 96);
        prim->Vertex(static_cast<int>(overlay_left + 20.0f), static_cast<int>(overlay_top + 30.0f), 0);
        prim->End();
    }

    if (room->mark) {
        const float bob = 0.71875f * (6.0f * sinf(-room->mark_phase));
        mark_rect[mark_num].left = picture.left + 64.0f;
        mark_rect[mark_num].top = picture.top + 4.0f - bob;
        mark_rect[mark_num].right = 64.0f + bob;
        mark_rect[mark_num].bottom = 46.0f + bob;
        mark_num++;
    }

    const float tint = 128.0f * event_brightness;

    if (name_tex != nullptr && room->visited == 1) {
        for (int i = 0; i < 3; i++) {
            if (!(room->flag & (1 << (i + 1))) || kRoomLabelTexture[i][0] < 0) {
                continue;
            }

            const s16 *label = kRoomLabelTexture[i];
            prim->TextureMapEnable(1);
            prim->Begin(MG_PRIM_SPRITE);
            prim->Texture(name_tex);
            prim->Color(static_cast<int>(tint), static_cast<int>(tint), static_cast<int>(tint), opacity);
            mgRect<int> label_rect;
            label_rect.Set(label[0], label[1], label[2], label[3]);
            PrimQuad(prim, picture.left + static_cast<float>(kRoomLabelOffset[i].x), picture.top + static_cast<float>(kRoomLabelOffset[i].y),
                     label_rect);
            prim->End();
        }
    }
}

// Retail opens the floor map with no room under the cursor when the saved floor has no room cell and
// no floor is marked. Its step then reads the floor of that null cell (the debug flag editor at once,
// a directional key otherwise). On the PS2 that reads low RAM; natively it faults. Put the cursor on
// the entrance room, which is the floor retail's decide already falls back to with no selection.
int DngTreeMapKey() {
    if (CMenuTreePt == nullptr || MenuDngMap == nullptr) {
        return 0;
    }
    int result = 0;

    if (DngTreeMode == DNG_TREE_MODE_MAP) {
        if (CMenuTreePt->select_glid == nullptr && CMenuTreePt->key_arg_no == DNG_TREE_MAP_SCREEN_MAP &&
            CMenuTreePt->mode == MENU_ASK_MODE_NONE) {
            CMenuTreePt->select_glid = MenuDngMap->GetEntranceRoomGlid();
        }

        result = CMenuTreePt->Step();

        if (DngTreeMode == DNG_TREE_MODE_SAVE) {
            SetDngTreeFlag(1);
            SaveMapInfo(MenuDngMap->dng_no);
            NowProgramLoopNo = LOOP_DUNGEON;
            MenuSaveInit(&MenuTreeMapStack, &CMenuTreePt->tex_block[3], MENU_OPEN_SAVE);
        }
    } else if (DngTreeMode == DNG_TREE_MODE_SAVE) {
        result = MenuSaveKey();

        if (result != 0) {
            SetDngTreeFlag(0);
            DngTreeMode = DNG_TREE_MODE_MAP;
            result = 0;
            CMenuTreePt->FadeInMenu(40, 0.0f);
            CMenuTreePt->mode = MENU_ASK_MODE_EXTEND;
            CMenuTreePt->step = 1;
            CMenuTreePt->MsgInit();
        }
    }

    return result;
}

// The floor information's monster page (floor_monsters.cpp) reads the keys before retail's step, which has no keys
// for the page's screen, and changes the information's state once that step has run.
int CMenuTreeMap::Step() {
    const auto action = floor_monsters::BeforeStep(*this);
    const int  result = StepMapCore();
    floor_monsters::AfterStep(*this, action);
    return result;
}

// The monster page and the prompt leading to it draw over retail's map and information.
void CMenuTreeMap::Draw() {
    DrawMapCore();
    floor_monsters::Draw(*this);
}
