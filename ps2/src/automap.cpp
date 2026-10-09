#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "automap.hpp"
#include "dng_effect.hpp"
#include "dng_main.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "map.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "savedatadungeon.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"

enum {
    kMiniMapInfoCount = 18,
    kHealingCooldown = 0x708,
    kStepUp = 1,
    kStepDown = 2,
    kStepRight = 4,
    kStepLeft = 8,
    kTermRightMargin = 21,
    kDoorPartsBegin = 0xE8,
    kDoorPartsEnd = 0xF0,
    kDoorPartsLast = kDoorPartsEnd - 1
};

MINIMAP_SYMBOL_INFO symbol_table[] = {
    {MINIMAP_SYMBOL_MONSTER_BLINK, 255, 0,   0,   10, 10, 1, 1},
    {MINIMAP_SYMBOL_MONSTER,       255, 0,   0,   10, 10, 0, 1},
    {MINIMAP_SYMBOL_TREASURE_BOX,  96,  64,  0,   10, 10, 0, 1},
    {MINIMAP_SYMBOL_RANDOM_CIRCLE, 255, 255, 0,   10, 10, 0, 1},
    {MINIMAP_SYMBOL_GEOSTONE,      255, 0,   180, 10, 10, 0, 1},
    {MINIMAP_SYMBOL_SPHIDA_6,      255, 0,   0,   10, 10, 1, 0},
    {MINIMAP_SYMBOL_SPHIDA_7,      0,   0,   255, 10, 10, 1, 0},
    {MINIMAP_SYMBOL_SPHIDA_4,      255, 0,   0,   14, 14, 0, 0},
    {MINIMAP_SYMBOL_SPHIDA_5,      0,   64,  255, 14, 14, 0, 0},
    {MINIMAP_SYMBOL_END,           0,   0,   0,   0,  0,  0, 0},
};
extern int                cax;
extern int                cay;
extern CAutoMapGen       *auto_map;
extern mgCMemory         *nowPrisetStack;
extern AUTOMAP_ROOM_INFO *nowPriset;
extern int                nowPrisetNum;
extern s16               *nowPrisetTable;
extern SPI_TAG_PARAM      tag__4[];
extern char               at_1111[];
extern char               at_2119__2[];
extern char               at_2125__2[];
extern char               at_2126__2[];
extern char               at_2128__2[];
extern char               at_2270[];
extern char               at_2347[];
extern char               at_2348[];
extern char               at_2349[];
extern char               at_2289[];
extern char               at_2290[];
extern char               at_2377__2[];
extern char               at_1661[];
extern char               at_2561[];
extern char               at_2609[];
int                       _ROOM_FIXED(SPI_STACK *stack, int arg_count);
int                       _GRID_SIZE(SPI_STACK *stack, int unused);
int                       _ROOM_ID(SPI_STACK *stack, int arg_count);
int                       _ROOM_SIZE(SPI_STACK *stack, int arg_count);
int                       _ROOM_RATE(SPI_STACK *stack, int arg_count);
int                       _RD(SPI_STACK *stack, int arg_count);
int                       _ROOM_END(SPI_STACK *stack, int arg_count);

/**
 *
 * Grid position of a linked dungeon room.
 *
 */
struct ROOM_LINK_POINT {
    int x; /**< Horizontal grid position. */
    int y; /**< Vertical grid position. */
};

// Code (.text)
void CMiniMapSymbol::SetMapInfo(CMap *new_map, CAutoMapParts *new_auto_map_parts, int width, int height,
                                float cell_width, float cell_depth) {
    if (new_map == 0) {
        return;
    }

    map = new_map;
    grid = new_auto_map_parts;
    grid_w = width;
    grid_h = height;
    cell_w = cell_width;
    cell_d = cell_depth;
    parts_table = new_map->GetPlacPartsTable(&parts_num);
    CMapParts *part = parts_table;
    parts_num = 0;

    while ((*(s8 *) part->name == 0) == 0) {
        part++;
        parts_num++;
    }

    texture = mgTexManager.GetTexture(at_1111, -1);
    char *floor_name = BattleAreaScene->map_name;

    if (*floor_name == 0) {
        return;
    }

    info = 0;
    char buffer[0x40];
    strcpy(buffer, floor_name);

    if (strlen(buffer) == 7) {
        buffer[6] = 0;
    }

    for (int i = 0; i < kMiniMapInfoCount; i++) {
        char *entry_name = MiniMapInfoData[i].name;

        if (entry_name != 0 && strcmp(buffer, entry_name) == 0) {
            info = &MiniMapInfoData[i];
            break;
        }
    }

    if (info == 0) {
        return;
    }

    part = parts_table;

    if (part == 0) {
        return;
    }

    for (int i = 0; i < parts_num; i++) {
        char *parts_name = part->parts_name;
        part->minimap_tile = -1;

        for (int j = 0; PartsInfoData[j].name != 0; j++) {
            if (strcmp(PartsInfoData[j].name, parts_name) == 0) {
                part->minimap_tile = info->tile[j];
            }
        }

        part++;
    }
}

void CMiniMapSymbol::DrawSymbolOpen() {
    prim.Initialize(0, 0);
    prim.Preset2D();
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0x80, 0x80, 0x80, 0x60);
    prim.Texture(TEX_SystenFrame);
    prim.SetScirror(x - w / 2, y - h / 2, w, h);
}

void CMiniMapSymbol::DrawSymbolClose() {
    prim.SetScirror(0, 0, mgScreenWidth - 1, mgScreenHeight - 1);
    prim.End();
    blink_cnt++;

    if (blink_cnt > 30) {
        blink_cnt = 0;
    }
}

void CMiniMapSymbol::DrawSymbol(float *pos, int symbol) {
    float delta[4];

    if (BattleAreaScene->boss_map != 0) {
        return;
    }
    sceVu0SubVector(delta, pos, center);
    float sizeX = cell_w;
    float ratio = delta[0] / sizeX;
    int   screen_x = x + (int) (16.0f * ratio);
    int   screen_y = y + (int) (16.0f * (delta[2] / cell_d));
    int   cell_x = (int) ((pos[0] + 0.5f * sizeX) / sizeX);
    int   cell_z = (int) ((pos[2] + 0.5f * cell_d) / cell_d);
    int   revealed = 0;
    if (grid != NULL && (grid + cell_z * grid_w)[cell_x].visible != 0) {
        revealed = 1;
    }
    if (BattleAreaScene->minimap_reveal & MINIMAP_REVEAL_SYMBOLS) {
        revealed = 1;
    }
    for (MINIMAP_SYMBOL_INFO *info = symbol_table; info->symbol != MINIMAP_SYMBOL_END; info++) {
        if (info->symbol == symbol) {
            if ((info->need_visible == 0 || revealed != 0) && (info->blink == 0 || blink_cnt < 16)) {
                prim.Color(info->r, info->g, info->b, 0x80);
                prim.SetIStretch(screen_x - info->w / 2 + 8, screen_y - info->h / 2 + 8, info->w, info->w, 0xBA, 0xF6, 10, 10);
            }
            break;
        }
    }
}

void CMiniMapSymbol::DrawSymbol_Chara(CCharacter2 *chara) {
    float pos[4];
    float rot[4];

    if (chara == NULL) {
        return;
    }
    if (BattleAreaScene->boss_map != 0) {
        return;
    }
    chara->GetPosition(pos);
    chara->GetRotation(rot);
    sceVu0SubVector(pos, pos, center);
    int        screen_x = x + (int) (16.0f * (pos[0] / cell_w)) + 8;
    int        screen_y = y + (int) (16.0f * (pos[2] / cell_d)) + 8;
    float      angle = rot[1];
    CPreSprite sprite;
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_TRIANGLE_STRIP);
    sprite.Color(0x80, 0x80, 0x80, 0x60);
    sprite.Texture(TEX_SystenFrame);
    sprite.SetScirror(x - w / 2, y - h / 2, w, h);
    int off_x = (int) (-7.0f * sinf(angle) - -6.0f * cosf(angle));
    int off_y = (int) (-6.0f * sinf(angle) + -7.0f * cosf(angle));
    sprite.TextureCrd(0xC4, 0xF2);
    sprite.Vertex(screen_x + off_x, screen_y + off_y, 0);
    off_x = (int) (-7.0f * sinf(angle) - 6.0f * cosf(angle));
    off_y = (int) (6.0f * sinf(angle) + -7.0f * cosf(angle));
    sprite.TextureCrd(0xD0, 0xF2);
    sprite.Vertex(screen_x + off_x, screen_y + off_y, 0);
    off_x = (int) (7.0f * sinf(angle) - -6.0f * cosf(angle));
    off_y = (int) (-6.0f * sinf(angle) + 7.0f * cosf(angle));
    sprite.TextureCrd(0xC4, 0x100);
    sprite.Vertex(screen_x + off_x, screen_y + off_y, 0);
    off_x = (int) (7.0f * sinf(angle) - 6.0f * cosf(angle));
    off_y = (int) (6.0f * sinf(angle) + 7.0f * cosf(angle));
    sprite.TextureCrd(0xD0, 0x100);
    sprite.Vertex(screen_x + off_x, screen_y + off_y, 0);
    sprite.SetScirror(0, 0, mgScreenWidth - 1, mgScreenHeight - 1);
    sprite.End();
}

void CMiniMapSymbol::Draw(float *pos) {
    if (map == NULL) {
        return;
    }
    CMapParts *parts = parts_table;
    if (parts == NULL) {
        return;
    }
    if (BattleAreaScene->boss_map != 0) {
        return;
    }
    sceVu0CopyVector(center, pos);
    int dimmed = 0;
    if (BattleAreaScene->minimap_reveal & MINIMAP_REVEAL_ROOMS) {
        dimmed = 1;
    }
    CPreSprite sprite;
    CPreSprite spare;
    float      part_pos[4];
    float      delta[4];
    sprite.Initialize(NULL, NULL);
    sprite.Preset2D();
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Texture(texture);
    sprite.Color(0x80, 0x80, 0x80, 0x60);
    sprite.SetScirror(x - w / 2, y - h / 2, w, h);
    for (int i = 0; i < parts_num; i++) {
        if ((*(s8 *) parts->name == 0) == 0) {
            int tile = parts->minimap_tile;
            if (tile == -1) {
                parts++;
                continue;
            }
            int tile_u = (tile % 16) * 16;
            int tile_v = (tile / 16) * 16;
            parts->GetPosition(part_pos);
            sceVu0SubVector(delta, part_pos, center);
            float          rate_z = delta[2] / cell_d;
            float          rate_x = delta[0] / cell_w;
            float          screen_x = (float) x + 16.0f * rate_x;
            float          screen_y = y + rate_z * 16.0f;
            float          sizeD = cell_d;
            CAutoMapParts *cells = grid;
            if (cells != NULL) {
                s16            width = grid_w;
                CAutoMapParts *cell = &cells[width * (int) (part_pos[2] / sizeD) + (int) (part_pos[0] / sizeD)];
                if (cell->attr & AUTOMAP_ATTR_HIDE) {
                    parts++;
                    continue;
                }
                if (cell->visible != 0) {
                    sprite.Color(0x80, 0x80, 0x80, 0x80);
                } else if (dimmed != 0) {
                    sprite.Color(0x30, 0x30, 0x30, 0x80);
                } else {
                    sprite.Color(0x30, 0x30, 0x30, 0);
                }
            }
            int rect_x = (int) screen_x;
            sprite.SetIRect(rect_x, (int) screen_y, 16, 16, tile_u, tile_v);
        }
        parts++;
    }
    sprite.SetScirror(0, 0, mgScreenWidth - 1, mgScreenHeight - 1);
    sprite.End();
}

int CHealingPoint::CheckHealingTime() {
    if (enable == 0) {
        return 0;
    }

    if (timer > 0) {
        return 0;
    }

    HealingEffectMan.SetMode((int) HEALING_EFFECT_SPENT);
    timer = kHealingCooldown;
    return 1;
}

void CHealingPoint::Step() {
    int remaining;

    if (enable != 0) {
        remaining = timer;

        if (remaining > 0) {
            timer = remaining - 1;
        }

        if (timer <= 0) {
            HealingEffectMan.SetMode((int) HEALING_EFFECT_RECHARGE);
        }
    }
}

/**
 *
 * Sets the fixed flag of the current automap room preset.
 *
 */
int _ROOM_FIXED(SPI_STACK *stack, int arg_count) {
    nowPriset->fixed = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the automap cell width and depth from a script.
 *
 */
int _GRID_SIZE(SPI_STACK *stack, int unused) {
    float        cell_size_x = spiGetStackFloat(stack++);
    float        cell_size_z = spiGetStackFloat(stack);
    CAutoMapGen *map = auto_map;
    map->cell_w = cell_size_x;
    map->cell_d = cell_size_z;
    return 1;
}

/**
 *
 * Sets the identifier of the current automap room preset.
 *
 */
int _ROOM_ID(SPI_STACK *stack, int arg_count) {
    nowPriset->id = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Allocates the cell table for the current automap room preset.
 *
 */
int _ROOM_SIZE(SPI_STACK *stack, int arg_count) {
    if (arg_count != 2) {
        return 0;
    }

    int width = spiGetStackInt(stack++);
    int height = spiGetStackInt(stack);
    u32 bytes = width * height * 4;
    nowPriset->w = width;
    nowPriset->h = height;
    u32 blocks;

    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }

    nowPriset->table = (s16 *) operator new[](bytes, nowPrisetStack->Alloc(blocks + 2));
    nowPrisetTable = nowPriset->table;
    nowPrisetNum += 1;
    return 1;
}

/**
 *
 * Sets the appearance rate of the current automap room preset.
 *
 */
int _ROOM_RATE(SPI_STACK *stack, int arg_count) {
    nowPriset->rate = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Appends one row of cell data to the current automap room preset.
 *
 */
int _RD(SPI_STACK *stack, int arg_count) {
    if (arg_count != nowPriset->w * 2) {
        return 0;
    }

    for (int i = 0; i < arg_count / 2; i++) {
        *nowPrisetTable++ = spiGetStackInt(stack++);
        *nowPrisetTable++ = spiGetStackInt(stack++);
    }

    return 1;
}

/**
 *
 * Advances to the next automap room preset.
 *
 */
int _ROOM_END(SPI_STACK *stack, int arg_count) {
    nowPriset = nowPriset + 1;
    return 1;
}

void CAutoMapGen::SetupRoomInfo(char *name, int length, mgCMemory *mem) {
    int i;

    room_info = (AUTOMAP_ROOM_INFO *) operator new[](0x600, mem->Alloc(0x62));

    for (i = 0; i < 64; i++) {
        AUTOMAP_ROOM_INFO *preset = room_info + i;
        preset->id = -1;
        preset->fixed = 0;
        preset->table = 0;
    }

    room_info_num = 0;
    nowPrisetStack = mem;
    auto_map = this;
    nowPriset = room_info;
    nowPrisetNum = 0;
    CScriptInterpreter interpreter;
    interpreter.SetTag(tag__4);
    interpreter.SetScript(name, length);
    interpreter.Run();
    room_info_num = nowPrisetNum;
}

int CAutoMapGen::CreatRoom(int x, int y, int room_no, int info_no) {
    int                w, h;
    int                pick;
    s16               *table;
    AUTOMAP_ROOM_INFO *info;
    if (info_no == -1) {
        do {
            pick = iRand(room_info_num);
            if (room_info[pick].fixed > 0) {
                pick = -1;
            }
            if (room_info[pick].rate < iRand(100)) {
                pick = -1;
            }
        } while (pick == -1);
        info_no = pick;
    }
    info = &room_info[info_no];
    if (info->table == NULL) {
        return 0;
    }
    w = info->w;
    h = info->h;
    if (x < 0 || y < 0) {
        return 0;
    }
    if (x + w > grid_w || y + h > grid_h) {
        return 0;
    }
    for (int row = y - 1; row < y + h + 1; row++) {
        for (int col = x; col < x + w; col++) {
            if ((grid + row * grid_w)[col].kind != 0) {
                return 0;
            }
        }
    }
    for (int row = y; row < y + h; row++) {
        for (int col = x - 1; col < x + w + 1; col++) {
            if ((grid + row * grid_w)[col].kind != 0) {
                return 0;
            }
        }
    }
    table = info->table;
    for (int row = y; row < y + h; row++) {
        for (int col = x; col < x + w; col++) {
            s16 parts_no = table[0];
            s16 attr = table[1];
            table += 2;
            if (parts_no != -1) {
                (grid + row * grid_w)[col].parts_no = parts_no;
                (grid + row * grid_w)[col].attr = attr;
                (grid + row * grid_w)[col].kind = PartsInfoData[parts_no].kind;
                (grid + row * grid_w)[col].link = PartsInfoData[parts_no].link;
                (grid + row * grid_w)[col].road_link = 0;
                (grid + row * grid_w)[col].room_no = room_no;
            }
        }
    }
    room[room_no].x = x;
    room[room_no].y = y;
    room[room_no].w = w;
    room[room_no].h = h;
    return 1;
}

int CAutoMapGen::LinkConnectCheck(int x, int y, int kind, int room_no, int exclude) {
    int sides[4];
    int cell_kind;
    int count = 0;

    if (exclude != kStepDown) {
        if (y > 0) {
            cell_kind = (grid + (y - 1) * grid_w)[x].kind;
            int cell_room = (grid + (y - 1) * grid_w)[x].room_no;

            if ((cell_kind & kind) && cell_room != room_no) {
                sides[count++] = kStepUp;
            }
        }
    }

    if (exclude != kStepUp) {
        if (y < grid_h - 1) {
            cell_kind = (grid + (y + 1) * grid_w)[x].kind;
            int cell_room = (grid + (y + 1) * grid_w)[x].room_no;

            if ((cell_kind & kind) && cell_room != room_no) {
                sides[count++] = kStepDown;
            }
        }
    }

    if (exclude != kStepLeft) {
        if (x < grid_w - 1) {
            cell_kind = (grid + y * grid_w + x + 1)->kind;
            int cell_room = (grid + y * grid_w + x + 1)->room_no;

            if ((cell_kind & kind) && cell_room != room_no) {
                sides[count++] = kStepRight;
            }
        }
    }

    if (exclude != kStepRight) {
        if (x > 0) {
            cell_kind = (grid + y * grid_w + x - 1)->kind;
            int cell_room = (grid + y * grid_w + x - 1)->room_no;

            if ((cell_kind & kind) && cell_room != room_no) {
                sides[count++] = kStepLeft;
            }
        }
    }

    if (count <= 0) {
        return 0;
    }

    return sides[iRand(count)];
}

void CAutoMapGen::SetRoadLinkMark(int x, int y, int direction) {
    int nx = x;
    int ny = y;
    int mark;

    switch (direction) {
        case 1:
            ny++;
            mark = 2;
            break;
        case 2:
            ny--;
            mark = 1;
            break;
        case 4:
            nx--;
            mark = 8;
            break;
        case 8:
            nx++;
            mark = 4;
            break;
    }

    (grid + y * grid_w)[x].link |= (u8) mark;
    (grid + y * grid_w)[x].road_link |= (u8) mark;
    (grid + ny * grid_w)[nx].link |= (u8) direction;
    (grid + ny * grid_w)[nx].road_link |= (u8) direction;
}

void CAutoMapGen::RoomLink(int from, int to) {
    ROOM_LINK_POINT starts[64];
    int             dx;
    s32             steps;
    AUTOMAP_ROOM   *dst;
    int             dy;
    AUTOMAP_ROOM   *src;
    int             joined;
    int             depth;
    float           dist_y;
    int             pick;
    int             x;
    int             side;
    int             src_x;
    int             goal_y;
    int             y;
    src = &room[from];
    dst = &room[to];

    src_x = src->x + src->w / 2;
    int src_y = src->y + src->h / 2;
    int goal_x = dst->x + dst->w / 2;
    goal_y = dst->y + dst->h / 2;
    float dist_x = (float) (src_x - goal_x);
    if (dist_x < 0.0f) {
        dist_x = -dist_x;
    }
    dist_y = (float) (src_y - goal_y);
    dx = src_x - goal_x;
    dy = src_y - goal_y;
    if (dist_y < 0.0f) {
        dist_y = -dist_y;
    }
    if (!(dist_x <= dist_y)) {
        if (dx < 0) {
            side = kStepRight;
        } else {
            side = kStepLeft;
        }
    } else {
        if (dy < 0) {
            side = kStepDown;
        } else {
            side = kStepUp;
        }
    }
    if (gen_flag & AUTOMAP_GEN_FIXED_START && from == 0) {
        side = kStepRight;
    }
    int start_num = 0;
    depth = 0;
    switch (side) {
        case kStepUp:
            while (start_num <= 0) {
                for (int col = src->x; col < src->x + src->w; col++) {
                    u32 kind = (grid + (src->y + depth) * grid_w)[col].kind;
                    if ((kind & (AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT)) && !(kind & (AUTOMAP_KIND_PART | AUTOMAP_KIND_HEALING))) {
                        starts[start_num].x = col;
                        starts[start_num].y = src->y + depth;
                        start_num++;
                    }
                }
                depth++;
            }
            break;
        case kStepDown:
            while (start_num <= 0) {
                for (int col = src->x; col < src->x + src->w; col++) {
                    u32 kind = (grid + (src->y + src->h - 1 - depth) * grid_w)[col].kind;
                    if ((kind & (AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT)) && !(kind & (AUTOMAP_KIND_PART | AUTOMAP_KIND_HEALING))) {
                        starts[start_num].x = col;
                        starts[start_num].y = src->y + src->h - 1 - depth;
                        start_num++;
                    }
                }
                depth++;
            }
            break;
        case kStepRight:
            while (start_num <= 0) {
                for (int row = src->y; row < src->y + src->h; row++) {
                    u32 kind = (grid + row * grid_w + src->x + src->w - 1 - depth)->kind;
                    if ((kind & (AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT)) && !(kind & (AUTOMAP_KIND_PART | AUTOMAP_KIND_HEALING))) {
                        starts[start_num].x = src->x + src->w - 1 - depth;
                        starts[start_num].y = row;
                        start_num++;
                    }
                }
                depth++;
            }
            break;
        case kStepLeft:
            while (start_num <= 0) {
                for (int row = src->y; row < src->y + src->h; row++) {
                    u32 kind = (grid + depth + row * grid_w + src->x)->kind;
                    if ((kind & (AUTOMAP_KIND_ROOM | AUTOMAP_KIND_ROOM_ALT)) && !(kind & (AUTOMAP_KIND_PART | AUTOMAP_KIND_HEALING))) {
                        starts[start_num].x = src->x + depth;
                        starts[start_num].y = row;
                        start_num++;
                    }
                }
                depth++;
            }
            break;
    }
    if (start_num <= 0) {
        printf(at_1661);
        return;
    }
    pick = iRand(start_num);
    x = starts[pick].x;
    y = starts[pick].y;
    (grid + y * grid_w)[x].kind |= AUTOMAP_KIND_ENTRANCE;
    dist_x = dx;
    if (dist_x < 0.0f) {
        dist_x = -dist_x;
    }
    dist_y = (float) dy;
    if (dist_y < 0.0f) {
        dist_y = -dist_y;
    }
    if (!(dist_x <= dist_y)) {
        side = kStepLeft;
        if (dx < 0) {
            side = kStepRight;
        }
        float d = (float) dx;
        if (d < 0.0f) {
            d = -d;
        }
        steps = iRand((int) (d - (float) (src->w / 2))) + 1;
    } else {
        if (dy < 0) {
            side = kStepDown;
        } else {
            side = kStepUp;
        }
        float d = (float) dy;
        if (d < 0.0f) {
            d = -d;
        }
        steps = iRand((int) (d - (float) (src->h / 2))) + 1;
    }
    joined = 0;
    do {
        if (steps > 0) {
            do {
                int link = LinkConnectCheck(x, y, 1, from, side);
                if (link != 0) {
                    steps = 0;
                    side = link;
                    joined = 1;
                }
                if (link == 0) {
                    link = LinkConnectCheck(x, y, 6, from, side);
                    if (link > 0) {
                        side = link;
                        steps = 0;
                        joined = 6;
                    }
                }
                switch (side) {
                    case kStepUp:
                        y--;
                        break;
                    case kStepDown:
                        y++;
                        break;
                    case kStepRight:
                        x++;
                        break;
                    case kStepLeft:
                        x--;
                        break;
                }
                switch (joined) {
                    case 6:
                        (grid + y * grid_w)[x].kind |= 8;
                        break;
                    default:
                        (grid + y * grid_w)[x].kind |= 1;
                        break;
                }
                if (joined == 0) {
                    (grid + y * grid_w)[x].room_no = from;
                }
                SetRoadLinkMark(x, y, side);
                steps--;
            } while (steps > 0);
        }
        dx = x - goal_x;
        dist_x = (float) dx;
        if (dist_x < 0.0f) {
            dist_x = -dist_x;
        }
        dy = y - goal_y;
        dist_y = (float) dy;
        if (dist_y < 0.0f) {
            dist_y = -dist_y;
        }
        if (!(dist_x <= dist_y)) {
            if (dx < 0) {
                side = kStepRight;
            } else {
                side = kStepLeft;
            }
            float d = (float) dx;
            steps = iRand((int) (d < 0.0f ? -d : d)) + 1;
        } else {
            if (dy < 0) {
                side = kStepDown;
            } else {
                side = kStepUp;
            }
            float d = (float) dy;
            steps = iRand((int) (d < 0.0f ? -d : d)) + 1;
        }
    } while (joined == 0);
}

void CAutoMapGen::CreatDummyRoot(int room_no) {
    int tries = 0;
    int x;
    int y;
    int occupied;

    do {
        x = iRand(grid_w - 3);
        y = iRand(grid_h - 3);
        occupied = 0;
        for (int row = y; row < y + 3; row++) {
            for (int col = x; col < x + 3; col++) {
                occupied |= (grid + row * grid_w)[col].kind;
            }
        }
        tries++;
        if (tries >= 1000) {
            return;
        }
    } while (occupied != 0);

    AUTOMAP_ROOM *target = &room[iRand(room_num)];
    int           goal_x = target->x + target->w / 2;
    int           goal_y = target->y + target->h / 2;
    int           side;
    int           steps;
    int           dx = x - goal_x;
    float         dist_x = (float) dx;
    if (dist_x < 0.0f) {
        dist_x = -dist_x;
    }
    int   dy = y - goal_y;
    float dist_y = (float) dy;
    if (dist_y < 0.0f) {
        dist_y = -dist_y;
    }
    if (!(dist_x <= dist_y)) {
        side = dx < 0 ? kStepRight : kStepLeft;
        float d = (float) dx;
        if (d < 0.0f) {
            d = -d;
        }
        steps = iRand((int) d) + 1;
    } else {
        side = dy < 0 ? kStepDown : kStepUp;
        float d = (float) dy;
        if (d < 0.0f) {
            d = -d;
        }
        steps = iRand((int) d) + 1;
    }
    if (steps >= 2) {
        steps = 2;
    }
    int joined = 0;
    (grid + y * grid_w)[x].kind = 1;
    (grid + y * grid_w)[x].room_no = room_no;
    do {
        if (steps > 0) {
            do {
                int link = LinkConnectCheck(x, y, 1, room_no, side);
                if (link != 0) {
                    steps = 0;
                    side = link;
                    joined = 1;
                }
                if (link == 0) {
                    link = LinkConnectCheck(x, y, 6, room_no, side);
                    if (link > 0) {
                        side = link;
                        steps = 0;
                        joined = 6;
                    }
                }
                switch (side) {
                    case kStepUp:
                        y--;
                        break;
                    case kStepDown:
                        y++;
                        break;
                    case kStepRight:
                        x++;
                        break;
                    case kStepLeft:
                        x--;
                        break;
                }
                switch (joined) {
                    case 6:
                        (grid + y * grid_w)[x].kind |= 8;
                        break;
                    default:
                        (grid + y * grid_w)[x].kind |= 1;
                        break;
                }
                if (joined == 0) {
                    (grid + y * grid_w)[x].room_no = room_no;
                }
                SetRoadLinkMark(x, y, side);
                steps--;
            } while (steps > 0);
        }
        dx = x - goal_x;
        dist_x = (float) dx;
        if (dist_x < 0.0f) {
            dist_x = -dist_x;
        }
        dy = y - goal_y;
        dist_y = (float) dy;
        if (dist_y < 0.0f) {
            dist_y = -dist_y;
        }
        if (!(dist_x <= dist_y)) {
            if (dx < 0) {
                side = kStepRight;
            } else {
                side = kStepLeft;
            }
            float d = (float) dx;
            steps = iRand((int) (d < 0.0f ? -d : d)) + 1;
        } else {
            if (dy < 0) {
                side = kStepDown;
            } else {
                side = kStepUp;
            }
            float d = dy;
            steps = iRand((int) (d < 0.0f ? -d : d)) + 1;
        }
        if (steps >= 2) {
            steps = 2;
        }
    } while (joined == 0);
}

void CAutoMapGen::CreatTermParts() {
    CAutoMapParts *grid;
    int            open_dirs;
    int            x;
    int            y;
    int            length;
    int            direction;
    int            steps;
    int            row_width;
    int            x_off;
    int            y_off;
    CAutoMapParts *cell;
    int            pending;
    int            room_no;

    do {
        open_dirs = 0;
        x = iRand(grid_w - 4) + 2;
        y = iRand(grid_h - 4) + 2;
        row_width = grid_w;
        grid = this->grid;
        x_off = x * sizeof(CAutoMapParts);
        y_off = y * row_width;
        y_off *= sizeof(CAutoMapParts);
        cell = (CAutoMapParts *) ((u8 *) grid + y_off + x_off);

        if (cell->kind == 1) {
            if (((CAutoMapParts *) ((u8 *) grid + (y - 1) * row_width * sizeof(CAutoMapParts) + x_off))
                    ->kind == 0) {
                open_dirs |= kStepUp;
            }

            if (((CAutoMapParts *) ((u8 *) grid + (y + 1) * row_width * sizeof(CAutoMapParts) + x_off))
                    ->kind == 0) {
                open_dirs |= kStepDown;
            }

            if ((cell - 1)->kind == 0) {
                open_dirs |= kStepLeft;
            }

            if ((cell + 1)->kind == 0) {
                open_dirs |= kStepRight;
            }
        }
    } while (open_dirs == 0);

    room_no = ((CAutoMapParts *) (x_off + (y_off + (int) grid)))->room_no;

    do {
        direction = 1 << iRand(4);
    } while (!(open_dirs & direction));

    switch (direction) {
        case kStepUp:
            y--;
            break;
        case kStepDown:
            y++;
            break;
        case kStepLeft:
            x--;
            break;
        case kStepRight:
            x++;
            break;
    }

    (this->grid + y * grid_w + x)->kind |= 1;
    (this->grid + y * grid_w + x)->room_no = room_no;
    SetRoadLinkMark(x, y, direction);
    length = iRand(2);
    pending = 0;

    do {
        if (y > 0 && (this->grid + (y - 1) * grid_w + x)->kind == 0) {
            pending |= kStepUp;
        }

        if (y <= grid_h - 2 && (this->grid + (y + 1) * grid_w + x)->kind == 0) {
            pending |= kStepDown;
        }

        if (x > 0 && (this->grid + y * grid_w + x - 1)->kind == 0) {
            pending |= kStepLeft;
        }

        if (x <= grid_w - 2 && (this->grid + y * grid_w + x + 1)->kind == 0) {
            pending |= kStepRight;
        }

        if (pending == 0) {
            break;
        }

        do {
            direction = 1 << iRand(4);
        } while (!(pending & direction));

        steps = iRand(2);
        pending = 0;

        while (steps > 0) {
            switch (direction) {
                case kStepUp:
                    y--;

                    if (y < 2) {
                        steps = 0;
                    }

                    break;
                case kStepDown:
                    y++;

                    if (grid_h - 2 < y) {
                        steps = 0;
                    }

                    break;
                case kStepLeft:
                    x--;

                    if (x < 2) {
                        steps = 0;
                    }

                    break;
                case kStepRight:
                    x++;

                    if (grid_w - kTermRightMargin < x) {
                        steps = 0;
                    }

                    break;
            }

            (this->grid + y * grid_w + x)->kind |= 1;
            (this->grid + y * grid_w + x)->room_no = room_no;
            SetRoadLinkMark(x, y, direction);

            if (steps <= 0) {
                break;
            }

            switch (direction) {
                case kStepUp:
                    if ((this->grid + (y - 1) * grid_w + x)->kind != 0) {
                        steps = 0;
                    }

                    break;
                case kStepDown:
                    if ((this->grid + (y + 1) * grid_w + x)->kind != 0) {
                        steps = 0;
                    }

                    break;
                case kStepLeft:
                    if ((this->grid + y * grid_w + x - 1)->kind != 0) {
                        steps = 0;
                    }

                    break;
                case kStepRight:
                    if ((this->grid + y * grid_w + x + 1)->kind != 0) {
                        steps = 0;
                    }

                    break;
            }
        }

        length--;
    } while (length > 0);
}

void CAutoMapGen::CreatDoorRoom() {
    if (iRand(100) < 50) {
        return;
    }

    int candidates[8];

    for (int i = 0; i < 8; i++) {
        candidates[i] = -1;
    }

    int candidate_num = 0;

    for (int i = 0; i < room_num; i++) {
        if (room[i].unk_0 != 0) {
            continue;
        }

        if ((gen_flag & AUTOMAP_GEN_FIXED_START) && i == 0) {
            continue;
        }

        int entrances = 0;

        for (int row = room[i].y; row < room[i].y + room[i].h; row++) {
            for (int col = room[i].x; col < room[i].x + room[i].w; col++) {
                CAutoMapParts *cell = &(grid + row * grid_w)[col];

                if (cell->parts_no >= kDoorPartsBegin && cell->parts_no < kDoorPartsEnd) {
                    entrances += 999;
                } else if (cell->kind & AUTOMAP_KIND_ENTRANCE) {
                    u8 road_link = cell->road_link;

                    if (road_link & AUTOMAP_LINK_NEG_Z) {
                        entrances++;
                    }

                    if (road_link & AUTOMAP_LINK_POS_Z) {
                        entrances++;
                    }

                    if (road_link & AUTOMAP_LINK_POS_X) {
                        entrances++;
                    }

                    if (road_link & AUTOMAP_LINK_NEG_X) {
                        entrances++;
                    }
                }
            }
        }

        if (entrances == 1) {
            candidates[candidate_num++] = i;
        }
    }

    if (candidate_num > 0) {
        door_room = -1;
        int           pick = iRand(candidate_num);
        AUTOMAP_ROOM *r = &room[candidates[pick]];

        for (int row = r->y; row < r->y + r->h; row++) {
            for (int col = r->x; col < r->x + r->w; col++) {
                CAutoMapParts *cell = &(grid + row * grid_w)[col];

                if (cell->parts_no < kDoorPartsBegin || cell->parts_no > kDoorPartsLast) {
                    if (cell->kind & AUTOMAP_KIND_ENTRANCE) {
                        cell->kind |= AUTOMAP_KIND_DOOR;
                        (grid + row * grid_w)[col].parts_no += 4;
                        door_room = candidates[pick];
                    }
                }
            }
        }
    }
}

CMapParts *CAutoMapGen::SearchDoorParts() {
    int row;
    int col;

    if (grid == NULL) {
        return 0;
    }

    for (row = 0; grid_h != 0; row++) {
        for (col = 0; col < grid_w; col++) {
            if ((this->grid + row * grid_w)[col].kind & 0x10) {
                return (this->grid + row * grid_w)[col].parts;
            }
        }
    }

    return 0;
}

void CAutoMapGen::SetPartsIndex() {
    int            y;
    int            x;
    int            i;
    int            j;
    int            flags;
    CAutoMapParts *cell;

    for (y = 0; y < grid_h; y++) {
        for (x = 0; x < grid_w; x++) {
            cell = &(grid + y * grid_w)[x];
            flags = cell->kind;

            if (flags == 0) {
                cell->parts_no = -1;
            } else if (flags & 1) {
                for (i = 0;; i++) {
                    if ((PartsInfoData[i].kind & 1) &&
                        PartsInfoData[i].link == (grid + y * grid_w)[x].road_link) {
                        (grid + y * grid_w)[x].parts_no = i;
                        break;
                    }
                }
            } else if (flags & 8) {
                printf(at_2119__2, x, y, flags, cell->road_link);

                for (j = 0; j < 0x118; j++) {
                    if (PartsInfoData[j].kind == (grid + y * grid_w)[x].kind &&
                        PartsInfoData[j].entrance == (grid + y * grid_w)[x].road_link &&
                        PartsInfoData[j].link == (grid + y * grid_w)[x].link) {
                        (grid + y * grid_w)[x].parts_no = j;
                        break;
                    }
                }
            }
        }
    }
}

void CAutoMapGen::SetDummyMountain() {
    CMap *map = DngMainScene->GetMap(0);

    if (map != NULL) {
        mgCMemory *stack = DngMainScene->GetStack(2);
        float      pos[4];
        float      scale[4];
        *(u_long128 *) pos = *(u_long128 *) at_2125__2;
        *(u_long128 *) scale = *(u_long128 *) at_2126__2;
        map->PlaceParts(at_2128__2, pos, pos, scale, stack);
    }
}

void CAutoMapGen::SetDummyTree() {
    s16   field[0x4000];
    float pos[4];

    int   width = grid_w + 8;
    int   height = grid_h + 8;
    CMap *map = DngMainScene->GetMap(0);

    if (map == NULL) {
        return;
    }

    for (int i = 0; i < height * width; i++) {
        field[i] = -1;
    }

    for (int row = 0; row < grid_h; row++) {
        for (int col = 0; col < grid_w; col++) {
            if ((grid + row * grid_w)[col].parts_no != -1) {
                field[(row + 4) * width + col + 4] = 1;
            }
        }
    }

    for (int row = 0; row < height; row++) {
        for (int col = 0; col < width; col++) {
            if (field[row * width + col] == -1) {
                int touches = 0;

                if (field[(row - 1) * width + col] == 1) {
                    touches = 1;
                }

                if (field[(row + 1) * width + col] == 1) {
                    touches = 1;
                }

                if (field[row * width + col - 1] == 1) {
                    touches = 1;
                }

                if (field[row * width + col + 1] == 1) {
                    touches = 1;
                }

                if (field[(row - 1) * width + col - 1] == 1) {
                    touches = 1;
                }

                if (field[(row - 1) * width + col + 1] == 1) {
                    touches = 1;
                }

                if (field[(row + 1) * width + col - 1] == 1) {
                    touches = 1;
                }

                if (field[(row + 1) * width + col + 1] == 1) {
                    touches = 1;
                }

                if (touches != 0) {
                    field[row * width + col] = 2;
                }
            }
        }
    }

    for (int row = 0; row < height; row++) {
        for (int col = 0; col < width; col++) {
            if (field[row * width + col] == -1) {
                int touches = 0;

                if (field[(row - 1) * width + col] == 2) {
                    touches = 1;
                }

                if (field[(row + 1) * width + col] == 2) {
                    touches = 1;
                }

                if (field[row * width + col - 1] == 2) {
                    touches = 1;
                }

                if (field[row * width + col + 1] == 2) {
                    touches = 1;
                }

                if (field[(row - 1) * width + col - 1] == 2) {
                    touches = 1;
                }

                if (field[(row - 1) * width + col + 1] == 2) {
                    touches = 1;
                }

                if (field[(row + 1) * width + col - 1] == 2) {
                    touches = 1;
                }

                if (field[(row + 1) * width + col + 1] == 2) {
                    touches = 1;
                }

                if (touches != 0) {
                    field[row * width + col] = 3;
                }
            }
        }
    }

    mgCMemory *stack = DngMainScene->GetStack(2);
    CMapParts *parts;
    float      rot[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float      scale[4] = {1.0f, 1.0f, 1.0f, 1.0f};

    for (int row = 0; row < height; row++) {
        for (int col = 0; col < width; col++) {
            s16 tile = field[row * width + col];

            if (tile > 1) {
                pos[0] = (float) col * cell_w - 4.0f * cell_w;
                pos[1] = 0.0f;
                pos[2] = (float) row * cell_d - 4.0f * cell_d;
                pos[3] = 1.0f;

                if (tile == 2) {
                    parts = map->PlaceParts(at_2128__2, pos, rot, scale, stack);
                }

                if (field[row * width + col] == 3) {
                    parts = map->PlaceParts(at_2270, pos, rot, scale, stack);
                }

                if (parts != NULL) {
                    parts->minimap_tile = -1;
                }
            }
        }
    }
}

void CAutoMapGen::SearchHealingPoint(CMap *map) {
    CMapParts  *parts;
    int         i;
    char        name[64];
    float       pos[4];
    float       offset[4];
    CFuncPoint *point;

    if (map == NULL) {
        return;
    }

    for (i = 0; i < 4; i++) {
        sprintf(name, at_2289, i + 6);
        parts = map->GetPlaceParts(name);

        if (parts != NULL) {
            (parts)->GetPosition(pos);
            point = parts->func_point_mngr.Search(at_2290);

            if (point != NULL) {
                *(u_long128 *) offset = *(u_long128 *) point->position;
                sceVu0AddVector(pos, pos, offset);
                HealingEffectMan.Set(pos);
                healing_point.enable = 1;
            }

            break;
        }
    }
}

void CAutoMapGen::IndexToPartsPlace() {
    float pos[4];

    CMap *map = DngMainScene->GetMap(0);

    if (map == NULL) {
        return;
    }

    DngMainScene->ClearStack(2);
    DngMainScene->AssignStack(2);
    mgCMemory *stack = DngMainScene->GetStack(2);

    if (stack == NULL) {
        return;
    }

    map->ClearPlaceParts();
    float rot[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float scale[4] = {1.0f, 1.0f, 1.0f, 1.0f};

    for (int row = 0; row < grid_h; row++) {
        for (int col = 0; col < grid_w; col++) {
            CAutoMapParts *cell = &(grid + row * grid_w)[col];

            if (cell->parts_no != -1) {
                char *name = PartsInfoData[cell->parts_no].name;
                pos[0] = (float) col * cell_w;
                pos[1] = 0.0f;
                pos[2] = (float) row * cell_d;
                pos[3] = 1.0f;
                (grid + row * grid_w)[col].parts = map->PlaceParts(name, pos, rot, scale, stack);
            }
        }
    }

    SearchHealingPoint(map);

    if (gen_flag & AUTOMAP_GEN_DUMMY_TREE) {
        SetDummyTree();
    }

    if (gen_flag & AUTOMAP_GEN_DUMMY_MOUNTAIN) {
        SetDummyMountain();
    }

    pos[1] = -99999.0f;
    pos[3] = 1.0f;
    pos[0] = 0.0f;
    pos[2] = 0.0f;
    gio_parts = map->PlaceParts(at_2347, pos, rot, scale, stack);

    for (int i = 0; i < 12; i++) {
        random_stone[i] = map->PlaceParts(at_2348, pos, rot, scale, stack);
    }

    pot_parts = map->PlaceParts(at_2349, pos, rot, scale, stack);
    map->PlacePartsEnd();

    for (int row = 0; row < grid_h; row++) {
        for (int col = 0; col < grid_w; col++) {
            CAutoMapParts *cell = &(grid + row * grid_w)[col];

            if (cell->parts_no != -1) {
                if (cell->parts != NULL) {
                    cell->wall = cell->parts->move_flag;
                }
            }
        }
    }
}

void CAutoMapGen::SetInOutPartsIndex(int offset) {
    int candidates[64];
    int count = 0;
    int base;
    int y;
    int x;
    int pick;

    for (y = 0; y < grid_h; y++) {
        for (x = 0; x < grid_w; x++) {
            if (count >= 64) {
                break;
            }

            base = y * grid_w;
            s16 parts = (grid + base)[x].parts_no;

            if (parts >= 0x1C && parts < 0x20) {
                candidates[count++] = x + base;
            }
        }
    }

    if (count > 0) {
        printf(at_2377__2, count);
        pick = iRand(count);
        grid[candidates[pick]].parts_no += offset;
    }
}

void CAutoMapGen::SetHealingPointIndex() {
    int candidates[64];
    int count = 0;
    int base;
    int y;
    int x;
    int pick;

    if (iRand(100) < 51) {
        for (y = 0; y < grid_h; y++) {
            for (x = 0; x < grid_w; x++) {
                if (count >= 64) {
                    break;
                }

                base = y * grid_w;
                s16 parts = (grid + base)[x].parts_no;

                if (parts >= 0x6C && parts < 0x74) {
                    candidates[count++] = x + base;
                }
            }
        }

        if (count > 0) {
            pick = iRand(count);
            s16 parts = grid[candidates[pick]].parts_no;
            int next;

            if (parts < 0x70) {
                next = parts + 0x1C;
            } else {
                next = parts + 0x18;
            }

            grid[candidates[pick]].parts_no = next;
        }
    }
}

void CAutoMapGen::CreatFixedMap(int preset_no) {
    CAutoMapParts     *cell;
    int                i;
    AUTOMAP_ROOM_INFO *preset = room_info + preset_no;
    int                preset_width;
    int                preset_height;
    s16               *table;
    int                y;
    int                x;

    for (i = 0; i < grid_w * grid_h; i++) {
        cell = grid + i;
        cell->parts_no = -1;
        cell->attr = 0;
        cell->kind = 0;
        cell->room_no = -1;
        cell->road_link = 0;
        cell->link = 0;
        cell->visible = 0;
        cell->wall = -1;
        cell->parts = 0;
    }

    for (i = 0; i < 8; i++) {
        room[i].unk_0 = 0;
    }

    preset_height = preset->h;
    preset_width = preset->w;
    table = preset->table;

    for (y = 0; y < preset_height; y++) {
        for (x = 0; x < preset_width; x++) {
            s16 parts_no = table[0];
            s16 attr = table[1];
            table += 2;

            if (parts_no != -1) {
                (grid + y * grid_w)[x].parts_no = parts_no;
                (grid + y * grid_w)[x].attr = attr;
                (grid + y * grid_w)[x].kind = PartsInfoData[parts_no].kind;
                (grid + y * grid_w)[x].link = PartsInfoData[parts_no].link;
                (grid + y * grid_w)[x].road_link = 0;
                (grid + y * grid_w)[x].room_no = 0;
            }
        }
    }

    room[0].x = 0;
    room[0].y = 0;
    room[0].w = preset_width;
    room[0].h = preset_height;
}

void CAutoMapGen::RandomMapMainProc() {
    int               link;
    int               i;
    int               rooms;
    int               goal;
    int               exits;
    int               seed;
    int               floor_id;
    int               round;
    int               dummy_roots;
    int               failures;
    int               to;
    int               result;
    int               n;
    CDngFloorManager *manager;
    random_map = 1;
    seed = iRand(0xFFFF);
    if (DebugFlag != 0) {
        printf(at_2561, seed);
    }
    srand(seed);
    floor_id = DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id];
    manager = &BattleAreaScene->floor_manager;
    for (i = 0; i < grid_w * grid_h; i++) {
        grid[i].Initialize();
    }
    for (n = 0; n < 8; n++) {
        room[n].unk_0 = 0;
    }
    do {
        if (gen_flag & AUTOMAP_GEN_FIXED_START) {
            CreatFixedMap(0);
            n = 1;
        } else {
            n = CreatRoom(iRand(grid_w - 2) + 1, iRand(grid_h - 2) + 1, 0, -1);
        }
    } while (n == 0);
    while (CreatRoom(iRand(grid_w - 2) + 1, iRand(grid_h - 2) + 1, 1, -1) == 0) {
    }
    RoomLink(0, 1);

    rooms = 2;
    goal = iRand(3) + 4;
    round = 0;
    while (rooms < goal) {
        failures = 0;
        do {
            result = CreatRoom(iRand(grid_w - 2) + 1, iRand(grid_h - 2) + 1, rooms, -1);
            link = iRand(rooms);
            if ((gen_flag & AUTOMAP_GEN_FIXED_START) && link == 0) {
                link++;
            }
            if (result != 0) {
                RoomLink(rooms, link);
                rooms++;
                round = 0;
                break;
            }
            failures++;
        } while (failures < 128);
        if (round > 128) {
            break;
        }
        round++;
    }
    room_num = rooms;

    n = iRand(3) + 1;
    for (link = 0; link < n;) {
        result = iRand(rooms);
        to = iRand(rooms);
        if ((!(gen_flag & AUTOMAP_GEN_FIXED_START) || (result != 0 && to != 0)) && result != to) {
            RoomLink(result, to);
            link++;
        }
    }
    dummy_roots = iRand(3) + 1;
    for (i = 0; i < dummy_roots; i++) {
        CreatDummyRoot(i + 50);
    }
    CreatTermParts();
    CreatTermParts();
    CreatTermParts();
    SetPartsIndex();
    if (!(gen_flag & AUTOMAP_GEN_NO_IN_OUT)) {
        SetInOutPartsIndex(4);
    }
    CreatDoorRoom();
    if (!(gen_flag & AUTOMAP_GEN_NO_HEALING)) {
        SetHealingPointIndex();
    }
    exits = manager->GetDngMapNextRoot(floor_id);
    if (exits & 1) {
        SetInOutPartsIndex(8);
    }
    if (exits & 2) {
        SetInOutPartsIndex(12);
    }
    if (exits & 4) {
        SetInOutPartsIndex(16);
    }
    if (exits & 8) {
        SetInOutPartsIndex(20);
    }
    IndexToPartsPlace();
}

void CAutoMapGen::Build() {
    int        floor_no;
    int        room;
    int        mode;
    CMap      *map;
    CMapParts *parts;

    minimap_enable = 1;
    navi_enable = 1;
    mode = gen_flag;

    if (mode & 0x40) {
        AUTOMAP_ROOM_INFO *preset = room_info;
        int                h = preset->h;
        grid_w = preset->w;
        grid_h = h;
        CreatFixedMap(0);
        IndexToPartsPlace();
        return;
    }

    if (mode & 2) {
        floor_no = DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id];
        printf(at_2609, floor_no);
        room = 0;

        if (floor_no < 8) {
            if (floor_no == 5) {
                room = 0;
            } else {
                room = iRand(19) + 1;
            }
        }

        if (floor_no < 19) {
            if (floor_no >= 8) {
                if (floor_no == 11) {
                    room = 0;
                } else {
                    room = iRand(19) + 1;
                }
            }
        }

        if (floor_no >= 19) {
            room = iRand(10);
        }

        int h = room_info[room].h;
        grid_w = room_info[room].w;
        grid_h = h;
        CreatFixedMap(room);
        IndexToPartsPlace();
        return;
    }

    if (mode & 8) {
        grid_w = 20;
        grid_h = 16;
        RandomMapMainProc();
        return;
    }

    grid_w = 14;
    grid_h = 14;
    RandomMapMainProc();
    map = DngMainScene->GetMap(0);

    if (map != NULL) {
        parts = map->GetPlacPartsTable(&place_parts_num);
        place_parts_num = 0;

        if (place_parts_num > 0) {
            while ((*(s8 *) parts->name == 0) == 0) {
                parts++;
                place_parts_num++;
            }
        }
    }
}

void CAutoMapGen::MinimapVisTest(float *pos) {
    float          size_x;
    float          size_z;
    int            x;
    int            z;
    CAutoMapParts *cell;
    int            i;
    int            row;
    int            col;
    CAutoMapParts *grid = this->grid;

    if (grid != NULL && minimap_enable != 0) {
        size_x = cell_w;
        x = (int) ((pos[0] + 0.5f * size_x) / size_x);
        size_z = cell_d;
        z = (int) ((pos[2] + 0.5f * size_z) / size_z);

        if (x < 0) {
            x = 0;
        }

        if (z < 0) {
            z = 0;
        }

        (grid + z * grid_w)[x].visible = 1;
        cell = &(this->grid + z * grid_w)[x];

        if (z > 0) {
            CAutoMapParts *up = cell - grid_w;

            if (!(up->wall & 8)) {
                up->visible = 1;
            }
        }

        if (z < grid_h - 1) {
            if (!(cell[grid_w].wall & 2)) {
                cell[grid_w].visible = 1;
            }
        }

        if (x > 0 && !(cell[-1].wall & 4)) {
            cell[-1].visible = 1;
        }

        if (x < grid_w - 1 && !(cell[1].wall & 1)) {
            cell[1].visible = 1;
        }

        if (!(gen_flag & 2)) {
            for (i = 0; i < room_num; i++) {
                if (x >= room[i].x && z >= room[i].y && x < room[i].x + room[i].w &&
                    z < room[i].y + room[i].h) {
                    for (row = 0; row < room[i].h; row++) {
                        for (col = 0; col < room[i].w; col++) {
                            (&(this->grid + (room[i].y + row) * grid_w)[col])[room[i].x].visible = 1;
                        }
                    }
                }
            }
        }
    }
}

void CAutoMapGen::MinimapDoorOpen(float *pos) {
    int        x;
    int        z;
    CMapParts *door;
    int        opened;

    if (grid == NULL) {
        return;
    }

    x = (int) ((pos[0] + 0.5f * cell_w) / cell_w);
    z = (int) ((pos[2] + 0.5f * cell_d) / cell_d);
    door = (grid + z * grid_w)[x].parts;

    if (door != NULL) {
        door->minimap_tile -= 4;
        u8 link = (grid + z * grid_w)[x].road_link;
        opened = 0;

        if (link == 1) {
            opened = 2;
        }

        if (link == 2) {
            opened = 8;
        }

        if (link == 4) {
            opened = 4;
        }

        if (link == 8) {
            opened = 1;
        }

        (grid + z * grid_w)[x].wall &= ~opened;
    }
}

CMapParts *CAutoMapGen::SearchRandomStone(float *pos, float radius) {
    float stone_pos[4];
    int   i;

    for (i = 0; i < 12; i++) {
        if (random_stone[i] != NULL) {
            random_stone[i]->GetPosition(stone_pos);

            if (mgDistVector(pos, stone_pos) < radius) {
                return random_stone[i];
            }
        }
    }

    return NULL;
}

void CAutoMapGen::ClearRandomStone() {
    int i;

    for (i = 0; i < 12; i++) {
        if (random_stone[i] != NULL) {
            random_stone[i]->SetPosition(0.0f, -99999.0f, 0.0f);
        }
    }
}

void CAutoMapGen::Step() {
    healing_point.Step();
}

int CAutoMapGen::GetAttrStatus(float *pos) {
    CAutoMapParts *grid = this->grid;
    float          size_x;
    float          size_z;
    int            x;
    int            z;

    if (grid == NULL) {
        return 0;
    }

    size_x = cell_w;
    x = (int) ((pos[0] + 0.5f * size_x) / size_x);
    size_z = cell_d;
    z = (int) ((pos[2] + 0.5f * size_z) / size_z);

    if (x < 0 || !((float) x < size_x)) {
        return 1;
    }

    if (z < 0 || !((float) z < size_z)) {
        return 1;
    }

    return (grid + z * grid_w)[x].attr;
}

void CAutoMapGen::MinimapAllVisible() {
    int i;

    for (i = 0; i < grid_w * grid_h; i++) {
        grid[i].visible = 1;
    }
}

float CAutoMapGen::GetNaviDistance(float *pos) {
    float size_x;
    float size_z;
    int   x;
    int   z;
    s8    step;

    if (navi_valid == 0 || navi_enable == 0) {
        return 0.0f;
    }

    size_x = cell_w;
    x = (int) ((pos[0] + 0.5f * size_x) / size_x);
    size_z = cell_d;
    z = (int) ((pos[2] + 0.5f * size_z) / size_z);

    if (x < 0) {
        x = 0;
    }

    if (z < 0) {
        z = 0;
    }

    step = (grid + z * grid_w)[x].navi;

    if (step <= 0) {
        return -1.0f;
    }

    float distance = (float) (navi_depth - step);
    distance *= (size_x + size_z) / 2.0f;
    return distance;
}

void CAutoMapGen::UpdateNaviMap(float *pos, int depth) {
    int            steps;
    int            x;
    u32            wall;
    int            changed;
    int            z;
    int            row;
    CAutoMapParts *cell;
    int            i;
    float          sizeX;
    int            col;
    if (grid == NULL || navi_enable == 0) {
        return;
    }
    navi_depth = depth;
    sizeX = cell_w;
    x = (int) ((pos[0] + 0.5f * sizeX) / sizeX);
    float sizeZ = cell_d;
    z = (int) ((pos[2] + 0.5f * sizeZ) / sizeZ);
    if (x < 0) {
        x = 0;
    }
    if (z < 0) {
        z = 0;
    }
    if (x != cax || z != cay) {
        cax = x;
        cay = z;
    } else {
        return;
    }
    cell = grid;
    for (i = 0; i < grid_w * grid_h; i++) {
        if (cell->parts_no != -1) {
            cell->navi = 0;
        } else {
            cell->navi = -1;
        }
        cell++;
    }
    (grid + z * grid_w)[x].navi = depth;
    do {
        cell = grid;
        changed = 0;
        for (row = 0; row < grid_h; row++) {
            for (col = 0; col < grid_w; col++) {
                steps = cell->navi;
                wall = cell->wall;
                if (steps > 0) {
                    if (row > 0 && !(wall & AUTOMAP_WALL_NEG_Z)) {
                        int next = steps - 1;
                        if ((cell - grid_w)->navi < next && !((cell - grid_w)->wall & AUTOMAP_WALL_POS_Z)) {
                            (cell - grid_w)->navi = next;
                            changed = 1;
                        }
                    }
                    if (row < grid_h - 1 && !(wall & AUTOMAP_WALL_POS_Z)) {
                        int next = steps - 1;
                        if ((cell + grid_w)->navi < next && !((cell + grid_w)->wall & AUTOMAP_WALL_NEG_Z)) {
                            (cell + grid_w)->navi = next;
                            changed = 1;
                        }
                    }
                    if (col > 0 && !(wall & AUTOMAP_WALL_NEG_X)) {
                        int next = steps - 1;
                        if (cell[-1].navi < next && !(cell[-1].wall & AUTOMAP_WALL_POS_X)) {
                            cell[-1].navi = next;
                            changed = 1;
                        }
                    }
                    if (col < grid_w - 1 && !(wall & AUTOMAP_WALL_POS_X)) {
                        int next = steps - 1;
                        if (cell[1].navi < next && !(cell[1].wall & AUTOMAP_WALL_NEG_X)) {
                            cell[1].navi = next;
                            changed = 1;
                        }
                    }
                }
                cell++;
            }
        }
    } while (changed != 0);
    navi_valid = 1;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", PartsInfoData__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", MiniMapInfoData__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", tag__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2125__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2126__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2211__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2212__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2298__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2299__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_778__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_779__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_780__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_781__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_782__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_783__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_784__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_785__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_786__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_787__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_788__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_789__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_790__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_791__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_792__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_793__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_794__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_795__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_796__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_797__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_798__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_799__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_800__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_801__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_802__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_803__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_804__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_805__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_806__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_807__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_808__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_809__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_810__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_811__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_812__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_813__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_814__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_815__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_816__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_817__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_818__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_819__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_820__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_821__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_822__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_823__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_824__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_825__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_826__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_827__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_828__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_829__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_830__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_831__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_832__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_833__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_834__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_835__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_836__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_837__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_838__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_839__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_840__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_841__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_842__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_843__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_844__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_845__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_846__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_847__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_848__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_849__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_850__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_851__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_852__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_853__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_854__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_855__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_856__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_857__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_858__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_859__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_860__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_861__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_862__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_863__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_864__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_865__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_866__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_867__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_868__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_869__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_870__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_871__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_872__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_873__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_874__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_875__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_876__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_877__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_878__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_879__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_880__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_881__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_882__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_883__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_884__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_885__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_886__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_887__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_888__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_889__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_890__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_891__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_892__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_893__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_894__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_895__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_896__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_897__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_898__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_899__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_900__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_901__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_902__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_903__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_904__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_905__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_906__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_907__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_908__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_909__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_910__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_911__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_912__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_913__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_914__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_915__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_916__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_917__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_918__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_919__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_920__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_921__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_922__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_923__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_924__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_925__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_926__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_927__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_928__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_929__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_930__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_931__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_932__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_933__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_934__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_935__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_936__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_937__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_938__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_939__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_940__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_941__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_942__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_943__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_944__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_945__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_946__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_947__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_948__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_949__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_950__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_951__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_952__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_953__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_954__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_955__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_956__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_957__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_958__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_959__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_960__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_961__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_962__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_963__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_964__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_965__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_966__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_967__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_968__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_969__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_970__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_971__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_972__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_973__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_974__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_975__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_976__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_977__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_978__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_979__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_980__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_981__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_982__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_983__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_984__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_985__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_986__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_987__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_988__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_989__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_990__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_991__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_992__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_993__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_994__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_995__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_996__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_997__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_998__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_999__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1000__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1001__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1002__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1003__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1004__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1005__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1006__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1007__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1008__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1009__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1010__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1011__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1012__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1013__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1014__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1015__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1016__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1017__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1018__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1019__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1020__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1021__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1022__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1023__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1024__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1025__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1026__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1027__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1028__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1029__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1030__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1031__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1032__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1033__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1034__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1035__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1036__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1037__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1038__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1039__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1040__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1041__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1042__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1043__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1044__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1045__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1046__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1047__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1048__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1049__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1050__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1051__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1052__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1053__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1054__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1111__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1304__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1305__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1306__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1307__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1308__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1309__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1310__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_1661__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2119__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2128__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2270__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2289__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2290__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2347__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2348__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2349__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2377__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2561__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", at_2609__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(auto_map, 0x4);
INCLUDE_BSS(nowPrisetStack, 0x4);
INCLUDE_BSS(nowPriset, 0x4);
INCLUDE_BSS(nowPrisetNum, 0x4);
INCLUDE_BSS(nowPrisetTable, 0x4);
INCLUDE_BSS(cax, 0x4);
INCLUDE_BSS(cay, 0x4);
