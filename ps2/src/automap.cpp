#include <cstring>
#include <cstdio>
#include "maintex.hpp"
#include "mglib.hpp"
#include "mg_math.hpp"
#include "dng_main.hpp"
#include "scenesnd.hpp"
#include "savedatadungeon.hpp"
#include "common.h"
#include "dng_effect.hpp"
#include "map.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "mg_memory.hpp"
#include "scriptinterpreter.hpp"
#include "automap.hpp"

enum { kMapPartsStride = 0x310, kMiniMapInfoCount = 18, kHealingCooldown = 0x708, kStepUp = 1, kStepDown = 2, kStepRight = 4, kStepLeft = 8, kTermRightMargin = 21 };
extern CAutoMapGen * auto_map;
extern mgCMemory * nowPrisetStack;
extern AUTOMAP_ROOM_INFO * nowPriset;
extern int nowPrisetNum;
extern s16 * nowPrisetTable;
extern SPI_TAG_PARAM tag__4[];
extern char at_1111[];
extern char at_2119__2[];
extern char at_2125__2[];
extern char at_2126__2[];
extern char at_2128__2[];
extern char at_2289[];
extern char at_2290[];
extern char at_2377__2[];
extern char at_2609[];
int _ROOM_FIXED(SPI_STACK *stack, int argCount);
int _GRID_SIZE(SPI_STACK *stack, int unused);
int _ROOM_ID(SPI_STACK *stack, int argCount);
int _ROOM_SIZE(SPI_STACK *stack, int argCount);
int _ROOM_RATE(SPI_STACK *stack, int argCount);
int _RD(SPI_STACK *stack, int argCount);
int _ROOM_END(SPI_STACK *stack, int argCount);

// Code (.text)
void CMiniMapSymbol::SetMapInfo(CMap *newMap, CAutoMapParts *newAutoMapParts, int width, int height,
                                float cellWidth, float cellDepth) {
    if (newMap == 0) {
        return;
    }
    map = newMap;
    grid = newAutoMapParts;
    grid_w = width;
    grid_h = height;
    cell_w = cellWidth;
    cell_d = cellDepth;
    parts_table = (CMapParts *)newMap->GetPlacPartsTable(&parts_num);
    CMapParts *part = parts_table;
    parts_num = 0;

    while ((*(s8 *)part->name == 0) == 0) {
        part = (CMapParts *)((u8 *)part + kMapPartsStride);
        parts_num++;
    }
    texture = mgTexManager.GetTexture(at_1111, -1);
    s8 *floorName = (s8 *)BattleAreaScene->map_name;
    if (*floorName == 0) {
        return;
    }
    info = 0;
    char buffer[0x40];
    strcpy(buffer, (char *)floorName);
    if (strlen(buffer) == 7) {
        buffer[6] = 0;
    }
    for (int i = 0; i < kMiniMapInfoCount; i++) {
        char *entryName = MiniMapInfoData[i].name;
        if (entryName != 0 && strcmp(buffer, entryName) == 0) {
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
        char *partsName = part->parts_name;
        part->unk_1dc = -1;
        for (int j = 0; PartsInfoData[j].name != 0; j++) {
            if (strcmp(PartsInfoData[j].name, partsName) == 0) {
                part->unk_1dc = info->tile[j];
            }
        }
        part = (CMapParts *)((u8 *)part + kMapPartsStride);
    }
}
void CMiniMapSymbol::DrawSymbolOpen() {
    prim.Initialize(0, 0);
    prim.Preset2D();
    prim.Begin(6);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/automap", DrawSymbol__14CMiniMapSymbolFPfi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/automap", DrawSymbol_Chara__14CMiniMapSymbolFP11CCharacter2);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/automap", Draw__14CMiniMapSymbolFPf);
int CHealingPoint::CheckHealingTime() {
    if (enable == 0) {
        return 0;
    }
    if (timer > 0) {
        return 0;
    }
    HealingEffectMan.SetMode(1);
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
            HealingEffectMan.SetMode(2);
        }
    }
}
int _ROOM_FIXED(SPI_STACK *stack, int argCount) {
    nowPriset->fixed = spiGetStackInt(stack);
    return 1;
}
int _GRID_SIZE(SPI_STACK *stack, int unused) {
    float cellSizeX = spiGetStackFloat(stack++);
    float cellSizeZ = spiGetStackFloat(stack);
    CAutoMapGen *map = auto_map;
    map->cell_w = cellSizeX;
    map->cell_d = cellSizeZ;
    return 1;
}
int _ROOM_ID(SPI_STACK *stack, int argCount) {
    nowPriset->id = spiGetStackInt(stack);
    return 1;
}
int _ROOM_SIZE(SPI_STACK *stack, int argCount) {
    if (argCount != 2) {
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
    nowPriset->table = (s16 *)operator new[](bytes, (u_long128 *)nowPrisetStack->Alloc(blocks + 2));
    nowPrisetTable = nowPriset->table;
    nowPrisetNum += 1;
    return 1;
}
int _ROOM_RATE(SPI_STACK *stack, int argCount) {
    nowPriset->rate = spiGetStackInt(stack);
    return 1;
}
int _RD(SPI_STACK *stack, int argCount) {
    if (argCount != nowPriset->w * 2) {
        return 0;
    }
    for (int i = 0; i < argCount / 2; i++) {
        *nowPrisetTable++ = spiGetStackInt(stack++);
        *nowPrisetTable++ = spiGetStackInt(stack++);
    }
    return 1;
}
int _ROOM_END(SPI_STACK *stack, int argCount) {
    nowPriset = nowPriset + 1;
    return 1;
}
void CAutoMapGen::SetupRoomInfo(char *name, int length, mgCMemory *mem) {
    int i;

    room_info = (AUTOMAP_ROOM_INFO *)operator new[](0x600, mem->Alloc(0x62));
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/automap", CreatRoom__11CAutoMapGenFiiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/automap", LinkConnectCheck__11CAutoMapGenFiiiii);
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
    (grid + y * grid_w)[x].link |= (u8)mark;
    (grid + y * grid_w)[x].road_link |= (u8)mark;
    (grid + ny * grid_w)[nx].link |= (u8)direction;
    (grid + ny * grid_w)[nx].road_link |= (u8)direction;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/automap", RoomLink__11CAutoMapGenFii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/automap", CreatDummyRoot__11CAutoMapGenFi);
void CAutoMapGen::CreatTermParts() {
    CAutoMapParts *grid;
    int openDirs;
    int x;
    int y;
    int length;
    int direction;
    int steps;
    int rowWidth;
    int xOff;
    int yOff;
    CAutoMapParts *cell;
    int pending;
    int room_no;

    do {
        openDirs = 0;
        x = iRand(grid_w - 4) + 2;
        y = iRand(grid_h - 4) + 2;
        rowWidth = grid_w;
        grid = this->grid;
        xOff = x * sizeof(CAutoMapParts);
        yOff = y * rowWidth;
        yOff *= sizeof(CAutoMapParts);
        cell = (CAutoMapParts *)((u8 *)grid + yOff + xOff);
        if (cell->kind == 1) {
            if (((CAutoMapParts *)((u8 *)grid + (y - 1) * rowWidth * sizeof(CAutoMapParts) + xOff))
                    ->kind == 0) {
                openDirs |= kStepUp;
            }
            if (((CAutoMapParts *)((u8 *)grid + (y + 1) * rowWidth * sizeof(CAutoMapParts) + xOff))
                    ->kind == 0) {
                openDirs |= kStepDown;
            }
            if ((cell - 1)->kind == 0) {
                openDirs |= kStepLeft;
            }
            if ((cell + 1)->kind == 0) {
                openDirs |= kStepRight;
            }
        }
    } while (openDirs == 0);
    room_no = ((CAutoMapParts *)(xOff + (yOff + (int)grid)))->room_no;
    do {
        direction = 1 << iRand(4);
    } while (!(openDirs & direction));
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/automap", CreatDoorRoom__11CAutoMapGenFv);
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
    int y;
    int x;
    int i;
    int j;
    int flags;
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
        mgCMemory *stack = (mgCMemory *)DngMainScene->GetStack(2);
        float pos[4];
        float scale[4];
        *(u_long128 *)pos = *(u_long128 *)at_2125__2;
        *(u_long128 *)scale = *(u_long128 *)at_2126__2;
        map->PlaceParts(at_2128__2, pos, pos, scale, stack);
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/automap", SetDummyTree__11CAutoMapGenFv);
void CAutoMapGen::SearchHealingPoint(CMap *map) {
    CMapParts *parts;
    int i;
    char name[64];
    float pos[4];
    float offset[4];
    CFuncPoint *point;

    if (map == NULL) {
        return;
    }
    for (i = 0; i < 4; i++) {
        sprintf(name, at_2289, i + 6);
        parts = map->GetPlaceParts(name);
        if (parts != NULL) {
            ((CMapParts *)parts)->GetPosition(pos);
            point = parts->func_point_mngr.Search(at_2290);
            if (point != NULL) {
                *(u_long128 *)offset = *(u_long128 *)point->position;
                sceVu0AddVector(pos, pos, offset);
                HealingEffectMan.Set(pos);
                healing_point.enable = 1;
            }
            break;
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/automap", IndexToPartsPlace__11CAutoMapGenFv);
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
void CAutoMapGen::CreatFixedMap(int presetNo) {
    CAutoMapParts *cell;
    int i;
    AUTOMAP_ROOM_INFO *preset = room_info + presetNo;
    int presetWidth;
    int presetHeight;
    s16 *table;
    int y;
    int x;

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
    presetHeight = preset->h;
    presetWidth = preset->w;
    table = preset->table;
    for (y = 0; y < presetHeight; y++) {
        for (x = 0; x < presetWidth; x++) {
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
    room[0].w = presetWidth;
    room[0].h = presetHeight;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/automap", RandomMapMainProc__11CAutoMapGenFv);
void CAutoMapGen::Build() {
    int floorNo;
    int room;
    int mode;
    CMap *map;
    CMapParts *parts;

    minimap_enable = 1;
    navi_enable = 1;
    mode = gen_flag;
    if (mode & 0x40) {
        AUTOMAP_ROOM_INFO *preset = room_info;
        int h = preset->h;
        grid_w = preset->w;
        grid_h = h;
        CreatFixedMap(0);
        IndexToPartsPlace();
        return;
    }
    if (mode & 2) {
        floorNo = DngSaveDataDungeon->floor_id[DngSaveDataDungeon->stage_id];
        printf(at_2609, floorNo);
        room = 0;
        if (floorNo < 8) {
            if (floorNo == 5) {
                room = 0;
            } else {
                room = iRand(19) + 1;
            }
        }
        if (floorNo < 19) {
            if (floorNo >= 8) {
                if (floorNo == 11) {
                    room = 0;
                } else {
                    room = iRand(19) + 1;
                }
            }
        }
        if (floorNo >= 19) {
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
            while ((*(s8 *)parts->name == 0) == 0) {
                parts++;
                place_parts_num++;
            }
        }
    }
}
void CAutoMapGen::MinimapVisTest(float *pos) {
    float sizeX;
    float sizeZ;
    int x;
    int z;
    CAutoMapParts *cell;
    int i;
    int row;
    int col;
    CAutoMapParts *grid = this->grid;

    if (grid != NULL && minimap_enable != 0) {
        sizeX = cell_w;
        x = (int)((pos[0] + 0.5f * sizeX) / sizeX);
        sizeZ = cell_d;
        z = (int)((pos[2] + 0.5f * sizeZ) / sizeZ);
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
    int x;
    int z;
    CMapParts *door;
    int opened;

    if (grid == NULL) {
        return;
    }
    x = (int)((pos[0] + 0.5f * cell_w) / cell_w);
    z = (int)((pos[2] + 0.5f * cell_d) / cell_d);
    door = (grid + z * grid_w)[x].parts;
    if (door != NULL) {
        door->unk_1dc -= 4;
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
    float stonePos[4];
    int i;

    for (i = 0; i < 12; i++) {
        if (random_stone[i] != NULL) {
            random_stone[i]->GetPosition(stonePos);
            if (mgDistVector(pos, stonePos) < radius) {
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
    float sizeX;
    float sizeZ;
    int x;
    int z;

    if (grid == NULL) {
        return 0;
    }
    sizeX = cell_w;
    x = (int)((pos[0] + 0.5f * sizeX) / sizeX);
    sizeZ = cell_d;
    z = (int)((pos[2] + 0.5f * sizeZ) / sizeZ);
    if (x < 0 || !((float)x < sizeX)) {
        return 1;
    }
    if (z < 0 || !((float)z < sizeZ)) {
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
    float sizeX;
    float sizeZ;
    int x;
    int z;
    s8 step;

    if (navi_valid == 0 || navi_enable == 0) {
        return 0.0f;
    }
    sizeX = cell_w;
    x = (int)((pos[0] + 0.5f * sizeX) / sizeX);
    sizeZ = cell_d;
    z = (int)((pos[2] + 0.5f * sizeZ) / sizeZ);
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
    float distance = (float)(navi_depth - step);
    distance *= (sizeX + sizeZ) / 2.0f;
    return distance;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/automap", UpdateNaviMap__11CAutoMapGenFPfi);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", PartsInfoData__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", MiniMapInfoData__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/automap", symbol_table__DATA);
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
