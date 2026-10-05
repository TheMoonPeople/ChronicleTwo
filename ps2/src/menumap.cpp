#include "menumap.hpp"
#include "dngmenu.hpp"
#include "mapselect.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "scriptinterpreter.hpp"
#include <cstring>

extern CDC2Mes *MenuDCMsg[9];
extern signed char WorldMapMenuType;
extern CWorldMapMenu *WorldMapPtr;
extern short Sfida_NowPlayHorlBlink;
extern short WorldMap_NextLoopNo;
extern short WorldMap_MapNo;
extern short spi_wmappos_tblnum;
extern void *spi_wmappos_tbl;
extern short spi_wmaparea_tblnum;
extern void *spi_wmaparea_tbl;
extern mgCMemory *spi_wmapstack;
extern short MapEnableNum;
extern SPI_TAG_PARAM menu_wmap_analyze_tag[];
extern "C" int fptosi(float value);

// Code (.text)
int _WMAP_POSNUM(SPI_STACK *stack, int) {
    unsigned int bytes;
    unsigned int blocks;
    spi_wmappos_tblnum = spiGetStackInt(stack);
    bytes = spi_wmappos_tblnum * sizeof(WMAP_POS_DATA);
    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }
    spi_wmappos_tbl = spi_wmapstack->Alloc(blocks);
    return 1;
}
int _WMAP_POS(SPI_STACK *stack, int) {
    char converted_title[0x100];
    WMAP_POS_DATA *pos = (WMAP_POS_DATA *)spi_wmappos_tbl + spiGetStackInt(stack++);
    pos->map_no = spiGetStackInt(stack++);
    pos->loop_no = spiGetStackInt(stack++);
    pos->area_no = spiGetStackInt(stack++);
    pos->dng_no = spiGetStackInt(stack++);
    pos->floor = spiGetStackInt(stack++);
    ConvertFontCode(GetMapTitle(pos->map_no), converted_title);
    pos->name = mgCopyString(converted_title, spi_wmapstack);
    pos->flag_no = spiGetStackInt(stack++);
    int unlocked = CheckBitFlagMenu(pos->flag_no);
    pos->enable = 0;
    if (unlocked != 0) {
        pos->enable = 1;
    }
    pos->type = spiGetStackInt(stack);
    if (pos->type == 4 && CheckBitFlagMenu(0x2E0) != 0) {
        pos->enable = 0;
    }
    return 1;
}
int _WMAP_AREANUM(SPI_STACK *stack, int) {
    unsigned int bytes;
    unsigned int blocks;
    spi_wmaparea_tblnum = spiGetStackInt(stack);
    bytes = spi_wmaparea_tblnum * sizeof(WMAP_AREA_DATA);
    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }
    spi_wmaparea_tbl = spi_wmapstack->Alloc(blocks);
    return 1;
}
int _WMAP_AREA(SPI_STACK *stack, int) {
    char converted_title[0x100];
    int area_no = spiGetStackInt(stack++);
    int map_no = spiGetStackInt(stack++);
    WMAP_AREA_DATA *area = (WMAP_AREA_DATA *)((int)spi_wmaparea_tbl + (int)(area_no * sizeof(WMAP_AREA_DATA)));
    area->area_no = area_no;
    area->unk_24 = map_no;
    area->x = spiGetStackInt(stack++);
    area->y = spiGetStackInt(stack++);
    area->name_x = spiGetStackInt(stack++);
    area->name_y = spiGetStackInt(stack++);
    area->name_side = spiGetStackInt(stack++);
    area->y = fptosi(1.15f * (float)area->y);
    area->name_y = fptosi(1.15f * (float)area->name_y);
    char *title = spiGetStackString(stack);
    memset(converted_title, 0, 0x100);
    ConvertFontCode(title, converted_title);
    area->name = mgCopyString(converted_title, spi_wmapstack);
    int position_count = 0;
    area->enable = 0;
    for (int i = 0; i < spi_wmappos_tblnum; i++) {
        if (area_no == ((WMAP_POS_DATA *)spi_wmappos_tbl)[i].area_no) {
            WMAP_POS_DATA *pos = (WMAP_POS_DATA *)spi_wmappos_tbl + i;
            area->pos[position_count] = pos;
            if ((signed char)area->pos[position_count]->enable != 0) {
                area->enable = 1;
            }
            position_count++;
        }
    }
    if (area->area_no == 8) {
        if (CheckBitFlagMenu(0x268) != 0) {
            area->enable = 0;
        }
    }
    if (CheckBitFlagMenu(0x320) != 0 && (area->area_no == 6 || area->area_no == 7)) {
        area->enable = 0;
    }
    if (area->enable != 0) {
        MapEnableNum++;
    }
    for (int slot = position_count; slot < 8; slot++) {
        area->pos[slot] = 0;
    }
    return 1;
}
void worldmap_analyze(mgCMemory *stack, char *script, int size) {
    spi_wmapstack = stack;
    spi_wmappos_tbl = 0;
    MapEnableNum = 0;
    CScriptInterpreter interpreter;
    interpreter.SetTag(menu_wmap_analyze_tag);
    interpreter.SetScript(script, size);
    interpreter.Run();
}
void CWorldMapMenu::SetMsgBuffer() {
    MenuDCMsg[4]->SetMessData(menu_mes_data, menu_mes_data);
    MenuDCMsg[4]->MsgPreset(15);
    ((ClsMes *)MenuDCMsg[4])->fuchi = 5;
    MenuDCMsg[2]->SetMessData(mes_data, menu_mes_data);
    MenuDCMsg[3]->SetMessData(mes_data, menu_mes_data);
    ((ClsMes *)MenuDCMsg[3])->push_button = 0;
    ((ClsMes *)MenuDCMsg[3])->fade_speed = 1.0f;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", KeyStep__13CWorldMapMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", Draw__13CWorldMapMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", WorldMoveInit__FP9mgCMemoryPii);
int WorldMoveKey() {
    if (WorldMapMenuType == 0) {
        return WorldMapPtr->KeyStep();
    }
    if (WorldMapMenuType == 1) {
        int result = DngTreeMapKey();
        if (result == 1) {
            MenuArg.end_code = 0;
            MenuArg.result[0] = 0;
            TreeMapCalledWorldMap = 0;
            MenuArg.result[1] = 0;
            WorldMapMenuType = 0;
            WorldMapPtr->step = 0;
            WorldMapPtr->cursor_view = 1;
            WorldMapPtr->FadeInMenu(40, 0.0f);
            WorldMapPtr->SetMsgBuffer();
            return 0;
        }
        if (result == 2) {
            MenuArg.end_code = 6;
            TreeMapCalledWorldMap = 0;
            MenuArg.result[0] = WorldMap_NextLoopNo;
            MenuArg.result[1] = WorldMap_MapNo;
            MakeDngTreeMapJumpNo(WorldMap_MapNo, MenuArg.result[2], &MenuArg.result[0],
                                 &MenuArg.result[1]);
            MenuArg.result[3] = 0;
            return 2;
        }
    }
    return 0;
}
void WorldMoveDraw() {
    if (WorldMapMenuType == 0) {
        WorldMapPtr->Draw();
    }
    if (WorldMapMenuType == 1) {
        DngTreeMapDraw();
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", SphidaScreListUpdate__FP7CDC2Mesi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", SphidaMenuInit__FP9mgCMemoryPii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", OmakeSfidaSelect__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", SphidaMenuKey__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", SphidaMenuDraw__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", SphidaScoreViewInit__FP9mgCMemoryPii);
int SphidaScoreViewKey() {
    if (MenuCommonInfo->CheckPushButton()) {
        MenuSePlay(1);
        return 1;
    }
    Sfida_NowPlayHorlBlink = Sfida_NowPlayHorlBlink + 1;
    if (Sfida_NowPlayHorlBlink > 0x32) {
        Sfida_NowPlayHorlBlink = 0;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", SphidaScoreViewDraw__Fv);

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", __sinit_menumap_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", menu_wmap_analyze_tag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1072__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1081__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1095__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", geo_table_1183__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1342__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1383__2__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_970__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_971__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_972__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_973__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1184__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1185__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1186__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1187__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1188__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1189__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1302__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1303__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1304__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1305__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1306__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1307__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1308__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1309__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1310__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1311__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1312__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1313__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1314__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1498__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1556__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1557__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1674__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1675__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1676__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1677__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1937__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1938__2__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", D_0037B058__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", __vt__13CWorldMapMenu__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menumap", at_1343__2__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(spi_wmapstack, 0x4);
INCLUDE_BSS(spi_wmaparea_tblnum, 0x4);
INCLUDE_BSS(spi_wmaparea_tbl, 0x4);
INCLUDE_BSS(spi_wmappos_tblnum, 0x4);
INCLUDE_BSS(spi_wmappos_tbl, 0x4);
INCLUDE_BSS(MapEnableNum, 0x4);
INCLUDE_BSS(WorldMapMenuType, 0x4);
INCLUDE_BSS(WorldMap_NextLoopNo, 0x4);
INCLUDE_BSS(WorldMap_MapNo, 0x4);
INCLUDE_BSS(WorldMap_DngFloor, 0x4);
INCLUDE_BSS(at_1218__2, 0x4);
INCLUDE_BSS(at_1393__2, 0x8);
INCLUDE_BSS(WorldMapPtr, 0x4);
INCLUDE_BSS(SubSaveData__2, 0x4);
INCLUDE_BSS(SubSphidaData, 0x4);
INCLUDE_BSS(SphidaMenuMes, 0x4);
INCLUDE_BSS(SphidaMenuQus, 0x4);
INCLUDE_BSS(SphidaMenuQusDrawFlag, 0x4);
INCLUDE_BSS(SphidaScore, 0x4);
INCLUDE_BSS(SphidaTex, 0x4);
INCLUDE_BSS(SphidaTex2, 0x4);
INCLUDE_BSS(SphidaTex_Sys, 0x4);
INCLUDE_BSS(SphidaCursor, 0x4);
INCLUDE_BSS(SphidaCursorDrawFlag, 0x4);
INCLUDE_BSS(SphidaCursorY, 0x4);
INCLUDE_BSS(SphidaCursorCount, 0x4);
INCLUDE_BSS(SphidaInfoMsgDrawFlag, 0x4);
INCLUDE_BSS(SfidaBGXY, 0x4);
INCLUDE_BSS(SphidaScoreListY, 0x4);
INCLUDE_BSS(SphidaScoreListBarY, 0x4);
INCLUDE_BSS(SphidaSelect, 0x8);
INCLUDE_BSS(SphidaMenuPhase, 0x4);
INCLUDE_BSS(SfidaMakeLine, 0x4);
INCLUDE_BSS(SfidaMoveInitFlag, 0x8);
INCLUDE_BSS(at_1764__3, 0x8);
INCLUDE_BSS(Sfida_NowPlayHorlBlink, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(WorldMapStack, 0x30);
INCLUDE_BSS(SphidaStack, 0x30);
INCLUDE_BSS(SphidaMenuTexbk, 0x20);
