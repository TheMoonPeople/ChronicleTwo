#include "menumap.hpp"
#include "dngmenu.hpp"
#include "mapselect.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "scriptinterpreter.hpp"
#include "menusys.hpp"
#include <cstdlib>
#include <cmath>
#include "menudraw.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "mainloop.hpp"
#include "savedata.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "dataread.hpp"
#include <cstring>
#include "sysmes.hpp"
#include "nameregi.hpp"
#include "password.hpp"
#include "effectlist.hpp"
#include <cstdio>
#include "mg_math.hpp"
#include "mg_drawprim.hpp"
#include "scenesnd.hpp"

extern signed char SfidaMoveInitFlag;
extern mgCMemory SphidaStack;
extern mgCMemory WorldMapStack;
extern int SphidaMenuTexbk[16];
extern CSubGameData *SubSaveData__2;
extern CSphidaData *SubSphidaData;
extern mgCTexture *SphidaTex;
extern mgCTexture *SphidaTex_Sys;
extern char at_1674[];
extern char at_1675[];
extern char at_1677[];
extern char at_1310__4[];
extern char at_1676[];
extern int D_01F3C7FC[4];
extern float SfidaBGXY;
extern int DebugFlag;
extern int menu_debug_flag;
extern CDC2Mes *SphidaMenuMes;
extern CDC2Mes *SphidaMenuQus;
extern CDC2Mes *SphidaScore;
extern char SphidaMenuQusDrawFlag;
extern char SphidaInfoMsgDrawFlag;
extern mgCTexture *SphidaTex2;
extern mgCTexture *SphidaCursor;
extern char SphidaCursorDrawFlag;
extern float SphidaCursorY;
extern int SphidaCursorCount;
extern short SphidaMenuPhase;
extern char at_1556__2[];
extern char at_1557__2[];
extern int SphidaSelect[2];
extern short SfidaMakeLine;
extern int LanguageCode;

extern CDC2Mes *MenuDCMsg[9];
extern signed char WorldMapMenuType;
extern CWorldMapMenu *WorldMapPtr;
extern short Sfida_NowPlayHorlBlink;
extern short WorldMap_NextLoopNo;
extern short WorldMap_MapNo;
extern short WorldMap_DngFloor;
extern short spi_wmappos_tblnum;
extern WMAP_POS_DATA *spi_wmappos_tbl;
extern short spi_wmaparea_tblnum;
extern WMAP_AREA_DATA *spi_wmaparea_tbl;
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
    spi_wmappos_tbl = (WMAP_POS_DATA *)spi_wmapstack->Alloc(blocks);
    return 1;
}
int _WMAP_POS(SPI_STACK *stack, int) {
    char converted_title[0x100];
    WMAP_POS_DATA *pos = &spi_wmappos_tbl[spiGetStackInt(stack++)];
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
    spi_wmaparea_tbl = (WMAP_AREA_DATA *)spi_wmapstack->Alloc(blocks);
    return 1;
}
int _WMAP_AREA(SPI_STACK *stack, int) {
    char converted_title[0x100];
    int area_no = spiGetStackInt(stack++);
    int map_no = spiGetStackInt(stack++);
    WMAP_AREA_DATA *area = &spi_wmaparea_tbl[area_no];
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
        if (area_no == spi_wmappos_tbl[i].area_no) {
            WMAP_POS_DATA *pos = &spi_wmappos_tbl[i];
            area->pos[position_count] = pos;
            if (area->pos[position_count]->enable != 0) {
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
#ifdef NONMATCHING
extern char at_1302__4[];
extern char at_1303__4[];
extern char at_1304__5[];
extern char at_1305__4[];
extern char at_1306__4[];
extern char at_1307__5[];
extern char at_1308__5[];
extern char at_1309__4[];
extern char at_1311__3[];
extern char at_1312[];
extern char at_1313[];
extern char at_1314[];
extern char *geo_table_1183[];
int CWorldMapMenu::KeyStep() {
    int result = WORLD_MOVE_CONTINUE;
    int i;
    MenuCommonInfo->CheckSelectKey();
    int lr_key = MenuCommonInfo->CheckLRKey();
    int push = MenuCommonInfo->CheckPushButton();
    MenuCommonInfo->CheckKeyInput();
    CDC2Mes *name_mes = MenuDCMsg[4];
    int next_step = -1;
    int close = 0;
    CDC2Mes *ask_mes = MenuDCMsg[2];
    CDC2Mes *list_mes = MenuDCMsg[3];

    switch (mode) {
    case WORLD_MAP_MODE_OPEN: {
        int faded = FadeCheckMenu();
        u8 world_move = MenuCommonInfo->open_type == MENU_OPEN_WORLD_MOVE ||
                        MenuCommonInfo->open_type == MENU_OPEN_WORLD_MOVE_B;
        if (ReadBGSync() != 0 || !((world_move && faded) || !world_move)) {
            break;
        }
        BG_READ_INFO *read = GetReadBGFile(0);
        if (read != NULL) {
            u_char *map_image = (u_char *)GetPackFile((u_int *)read->buffer, at_1302__4, NULL);
            mgCTextureManager *textures = &mgTexManager;
            textures->DeleteBlock(tex_block[0]);
            textures->EnterIMGFile(map_image, tex_block[0], NULL, NULL);
            u_char *capture_image = (u_char *)GetPackFile((u_int *)read->buffer, at_1303__4, NULL);
            if (world_move) {
                textures->EnterIMGFile(capture_image, tex_block[0], NULL, NULL);
            }
            char map_name[0x20];
            sprintf(map_name, at_1304__5, map_type);
            map_tex = textures->GetTexture(map_name, -1);
            mark_tex = textures->GetTexture(at_1305__4, -1);
            anim_tex = textures->GetTexture(at_1306__4, -1);
            pulse_tex = textures->GetTexture(at_1307__5, -1);
            if (map_type == 4) {
                anim_tex = textures->GetTexture(at_1308__5, -1);
                map_tex = textures->GetTexture(at_1309__4, -1);
            }
            cursor_tex = textures->GetTexture(at_1310__4, -1);
            mes_data = (short *)GetPackFile((u_int *)read->buffer, at_1311__3, NULL);
            menu_mes_data = GetMenuMainMessageBuffer();
            SetMsgBuffer();
        }
        step = -1;
        next_step = WORLD_MAP_STEP_AREA;
        opened = 1;
        area_no = 0;
        cursor_view = 1;
        cursor_reset = 1;
        cursor_pos[0] = 200.0f;
        cursor_pos[1] = 200.0f;
        name_view = 1;
        exit_wait = 0;
        back_alpha = 0.0f;
        WorldMapStack.Align64();
        unsigned int size;
        u_long128 *script = WorldMapStack.stGetTop();
        size = LoadFileMenu(at_1312, script, 1);
        unsigned int blocks;
        if (size & 0xF) {
            blocks = (size >> 4) + 1;
        } else {
            blocks = size >> 4;
        }
        WorldMapStack.Alloc(blocks);
        worldmap_analyze(&WorldMapStack, (char *)script, size);
        area_no = GetSaveData()->area_no;
        if (MapEnableNum <= 0) {
            cursor_tex = NULL;
            name_view = 0;
        }
        if (MenuArg.open_type == MENU_OPEN_WORLD_MOVE) {
            int pos_no = MenuArg.param[0];
            if (pos_no == 10) {
                pos_no = 0x15;
            } else if (pos_no == 9) {
                pos_no = 0xF;
            } else if (pos_no == 8) {
                pos_no = 0xE;
            }
            if (spi_wmappos_tbl != NULL) {
                here_area = spi_wmappos_tbl[pos_no].area_no + 1;
            }
            area_no = here_area;
            name_view = 1;
        }
        MenuCommonInfo->key_enable = 1;
        FadeInMenu(40, 0.0f);
        mode = WORLD_MAP_MODE_RUN;
        break;
    }
    case WORLD_MAP_MODE_CLOSE:
        if (FadeCheckMenu()) {
            exit_wait++;
            map_tex = NULL;
            mark_tex = NULL;
            anim_tex = NULL;
            pulse_tex = NULL;
            name_view = 0;
            cursor_view = 0;
            pos_list_view = 0;
            ask_view = 0;
            if (MenuCommonInfo->open_type != MENU_OPEN_WORLD_MOVE && exit_wait == 1 && MenuArg.end_code != 6) {
                FadeInMenu(40, 0.0f);
            } else {
                exit_wait++;
            }
        }
        if (exit_wait == 1) {
            CalcMenuAdd(&back_alpha, -8.0f, 0.0f);
        }
        if (exit_wait > 2) {
            result = WORLD_MOVE_CLOSE;
            if (MenuArg.end_code == 6) {
                result = WORLD_MOVE_JUMP;
            }
            short *system_mes = GetSystemMesBuffer();
            name_mes->SetBuff_system(system_mes);
            ask_mes->SetBuff_system(system_mes);
            list_mes->SetBuff_system(system_mes);
        }
        break;
    default:
        if (MenuCommonInfo->open_type == MENU_OPEN_WORLD_MOVE) {
            CalcMenuAdd(&back_alpha, 8.0f, 128.0f);
            if (push != 0) {
                close = 1;
                MenuSePlay(close);
            }
            break;
        }
        if (view_only != 0) {
            if (push != 0) {
                close = 1;
                MenuSePlay(1);
            }
            break;
        }
        if (menu_debug_flag != 0) {
            if (GamePad__2.Down(0x20)) {
                for (int i = 0; i < spi_wmappos_tblnum; i++) {
                    spi_wmappos_tbl[i].enable = 1;
                }
                for (i = 0; i < spi_wmaparea_tblnum; i++) {
                    spi_wmaparea_tbl[i].enable = 1;
                }
                MapEnableNum = spi_wmaparea_tblnum - 1;
                cursor_tex = mgTexManager.GetTexture(at_1310__4, -1);
                name_view = 1;
            }
            return WORLD_MOVE_CONTINUE;
        }
        switch (step) {
        case WORLD_MAP_STEP_AREA:
            if (MapEnableNum <= 0 && push != 0) {
                MenuSePlay(5);
                close = 1;
                break;
            }
            if (0 < lr_key) {
                near_num = 0;
                float dir[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                if (lr_key & 1) {
                    dir[1] -= 1.0f;
                }
                if (lr_key & 2) {
                    dir[1] += 1.0f;
                }
                if (lr_key & 4) {
                    dir[0] -= 1.0f;
                }
                if (lr_key & 8) {
                    dir[0] += 1.0f;
                }
                sceVu0Normalize(dir, dir);
                WMAP_AREA_DATA *next = NULL;
                WMAP_AREA_DATA *now_area = &spi_wmaparea_tbl[area_no];
                float now_pos[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                now_pos[0] = now_area->x;
                now_pos[1] = now_area->y;
                for (int i = 0; i < WMAP_NEAR_AREA_MAX; i++) {
                    near_area[i] = NULL;
                }
                for (i = 1; i < spi_wmaparea_tblnum; i++) {
                    near_area[i] = NULL;
                    WMAP_AREA_DATA *area = &spi_wmaparea_tbl[i];
                    if (area->enable != 0 && area_no != area->area_no) {
                        float area_pos[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                        float area_dir[4];
                        area_pos[0] = area->x;
                        area_pos[1] = area->y;
                        sceVu0SubVector(area_dir, area_pos, now_pos);
                        sceVu0Normalize(area_dir, area_dir);
                        float dot = sceVu0InnerProduct(dir, area_dir);
                        near_area[near_num] = &spi_wmaparea_tbl[i];
                        near_area[near_num]->dist = mgDistVector(area_pos, now_pos);
                        near_area[near_num]->dir_dot = dot;
                        near_num++;
                    }
                }
                for (int i = 0; i < near_num; i++) {
                    bool swapped = false;
                    float dist = near_area[i]->dist;
                    for (int j = i + 1; j < near_num; j++) {
                        if (near_area[j]->dist < dist) {
                            WMAP_AREA_DATA *swap = near_area[i];
                            near_area[i] = near_area[j];
                            near_area[j] = swap;
                            swapped = true;
                        }
                    }
                    if (swapped) {
                        i = -1;
                    }
                }
                float threshold = 0.72f;
                bool searching = true;
                while (searching && 0.0f < threshold) {
                    for (i = 0; i < near_num; i++) {
                        if (threshold < near_area[i]->dir_dot) {
                            next = near_area[i];
                            searching = false;
                            break;
                        }
                    }
                    threshold -= 0.05f;
                }
                if (next == NULL) {
                    next = now_area;
                }
                for (i = 0; i < spi_wmaparea_tblnum; i++) {
                    if (next == &spi_wmaparea_tbl[i]) {
                        area_no = i;
                        break;
                    }
                }
                if (next != now_area) {
                    MenuSePlay(0);
                }
            }
            switch (push) {
            case 1:
                next_step = WORLD_MAP_STEP_POS;
                select_area = &spi_wmaparea_tbl[area_no];
                if (select_area == NULL) {
                    MenuSePlay(5);
                    break;
                }
                pos_num = 0;
                for (int i = 0; i < WMAP_AREA_POS_LIST; i++) {
                    WMAP_POS_DATA *pos = select_area->pos[i];
                    if (pos != NULL && pos->enable != 0) {
                        pos_icon[pos_num] = pos->type;
                        if (pos_icon[pos_num] == WMAP_POS_TYPE_GEORAMA) {
                            pos_icon[pos_num] = 3;
                        }
                        pos_num++;
                    }
                }
                list_mes->SetMsgCursor(0);
                MenuSePlay(1);
                break;
            case 2:
                MenuSePlay(5);
                close = 1;
                break;
            }
            break;
        case WORLD_MAP_STEP_POS:
            list_mes->AddMsgCursor2(0, pos_num - 1, 1);
            switch (push) {
            case 1:
            case 4: {
                select_pos = NULL;
                int line = 0;
                for (int i = 0; i < WMAP_AREA_POS_LIST; i++) {
                    WMAP_POS_DATA *pos = select_area->pos[i];
                    if (pos != NULL && pos->enable != 0) {
                        if (line == list_mes->GetMsgCursor()) {
                            select_pos = select_area->pos[i];
                            break;
                        }
                        line++;
                    }
                }
                if (select_pos == NULL) {
                    MenuSePlay(5);
                } else if (MenuMainScene->now_map_no == select_pos->map_no) {
                    MenuSePlay(5);
                } else {
                    next_step = WORLD_MAP_STEP_ASK;
                    MenuSePlay(1);
                }
                break;
            }
            case 2:
                next_step = WORLD_MAP_STEP_AREA;
                MenuSePlay(5);
                break;
            }
            break;
        case WORLD_MAP_STEP_ASK: {
            int answer = ask_mes->YesNoCursor2(1);
            if (answer == 1) {
                MenuArg.end_code = 6;
                WorldMap_NextLoopNo = select_pos->loop_no;
                WorldMap_MapNo = select_pos->map_no;
                if (select_pos->loop_no == LOOP_DUNGEON) {
                    WorldMap_MapNo = select_pos->dng_no;
                    if (select_pos->floor < 0) {
                        step++;
                        FadeOutMenu(40, 0.0f);
                    } else {
                        MenuArg.end_code = 6;
                        close = 1;
                        MenuArg.result[0] = WorldMap_NextLoopNo;
                        MenuArg.result[1] = WorldMap_MapNo;
                        MenuArg.result[2] = select_pos->floor;
                    }
                } else {
                    if (WorldMap_MapNo == SearchMapNo(at_1313) && CheckBitFlagMenu(0x2BC) != 0) {
                        WorldMap_MapNo = SearchMapNo(at_1314);
                    }
                    if (select_pos->type == WMAP_POS_TYPE_GEORAMA) {
                        MenuMainScene->SetNowMapNo(SearchMapNo(geo_table_1183[select_pos->area_no]));
                    }
                    MenuArg.result[3] = 0;
                    MenuArg.result[2] = 0;
                    close = 1;
                    MenuArg.result[0] = WorldMap_NextLoopNo;
                    MenuArg.result[1] = WorldMap_MapNo;
                    if (MenuMainScene->now_map_no == 0x22 && WorldMap_MapNo == 10) {
                        WorldMap_MapNo = 11;
                        MenuArg.result[1] = 11;
                    }
                }
                MenuSePlay(1);
            }
            if (answer == 2) {
                next_step = WORLD_MAP_STEP_POS;
                MenuSePlay(5);
            }
            break;
        }
        case WORLD_MAP_STEP_TREE_MAP:
            if (FadeCheckMenu()) {
                TreeMapCalledWorldMap = 1;
                WorldMapMenuType = 1;
                mgCMemory stack;
                int rest = WorldMapStack.stGetRest();
                stack.stSetBuffer(WorldMapStack.stGetTop(), rest);
                DngTreeMapInit(&stack, &tex_block[2], 0, select_pos->dng_no);
            }
            break;
        case WORLD_MAP_STEP_WAIT:
            if ((push & 1) || (push & 2)) {
                ask_view = 0;
                cursor_view = 1;
                step = WORLD_MAP_STEP_AREA;
                MenuSePlay(1);
            }
            break;
        }
        break;
    }

    if (0 <= next_step) {
        switch (next_step) {
        case WORLD_MAP_STEP_AREA:
            cursor_view = 1;
            pos_list_view = 0;
            ask_view = 0;
            break;
        case WORLD_MAP_STEP_POS: {
            char *names[WMAP_AREA_POS_LIST];
            int line = 0;
            cursor_view = 0;
            pos_list_view = 1;
            ask_view = 0;
            for (int i = 0; i < WMAP_AREA_POS_LIST; i++) {
                if (select_area != NULL) {
                    WMAP_POS_DATA *pos = select_area->pos[i];
                    if (pos != NULL && pos->enable != 0 && line < pos_num) {
                        names[line++] = pos->name;
                    }
                }
            }
            list_mes->MsgPreset(10);
            list_mes->SetMsgCursor(0);
            list_mes->cursor_on = 1;
            ((ClsMes *)list_mes)->mes_no = -1;
            list_mes->cursor_time = 0;
            list_mes->fade_speed = 1.0f;
            list_mes->fade = 1.0f;
            list_mes->SetMsgItemNo(names, pos_num);
            list_mes->MakeMsg(pos_num + 0x45);
            break;
        }
        case WORLD_MAP_STEP_ASK: {
            pos_list_view = 0;
            ask_view = 1;
            list_mes->cursor_on = 0;
            ask_mes->MsgPreset(11);
            ask_mes->SetAbsPos(5);
            char *names[1] = {NULL};
            names[0] = select_pos->name;
            ask_mes->SetMsgItemNo(names, 1);
            ((ClsMes *)ask_mes)->mes_no = -1;
            ask_mes->fade = 0.0f;
            ask_mes->MakeMsg(0x9C6);
            ask_mes->SetMsgCursor(0);
            break;
        }
        }
        step = next_step;
    }
    if (close != 0) {
        MenuCommonInfo->key_enable = 0;
        mode = WORLD_MAP_MODE_CLOSE;
        FadeOutMenu(30, 0.0f);
    }
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", KeyStep__13CWorldMapMenuFv);
#endif
#ifdef NONMATCHING
extern char at_1498__3[];
void CWorldMapMenu::Draw() {
    mgCDrawPrim *prim = GetMenuPrim();
    int loaded_tex = -1;
    if (capture_view == 1 && capture_tex != NULL) {
        MenuReloadTexture(loaded_tex, capture_tex->block);
        PrimQuad(capture_tex, mgRect<int>(0, 0, mgScreenWidth, mgScreenHeight),
                 mgRect<int>(0, 0, mgScreenWidth >> 1, mgScreenHeight >> 1), 0x80, 0x80, 0x80, 0x80);
    }
    DrawMenuFillBox((int)back_alpha, 0, 0, 0);
    SetSpriteEnv(prim, 0);
    if (map_tex != NULL) {
        mgRect<int> map_source(0, 0, 0x200, 0x16E);
        mgRect<int> map_dest(0, 0, 0x200, 0x1E0);
        MenuReloadTexture(loaded_tex, map_tex->block);
        PrimQuad(prim, map_tex, map_dest, map_source, 0x80, 0x80, 0x80, 0x80);
        if (map_type == 2 && anim_tex != NULL && pulse_tex != NULL) {
            SetSpriteEnv(prim, 0);
            prim->Begin(6);
            prim->Texture(anim_tex);
            prim->Color(0, 0, 0, 0x5E);
            for (int i = 0; i < 0xFF; i++) {
                int x = (int)(250.0f + 8.0f * sinf(wave_x[i]));
                prim->TextureCrd(0, i);
                prim->Vertex(x, i, 0);
                prim->TextureCrd(0xFE, i + 1);
                prim->Vertex(0x1FF, i + 1, 0);
                wave_x[i] = mgAngleLimit(0.034906585f + wave_x[i]);
            }
            for (int i = 0; i < 0xFF; i++) {
                int y = (int)(253.0f + 8.0f * sinf(wave_y[i]));
                prim->TextureCrd(i, 0);
                prim->Vertex(i + 0xFF, 0, 0);
                prim->TextureCrd(i + 1, 0xDC);
                prim->Vertex(i + 0x100, y, 0);
                wave_y[i] = mgAngleLimit(wave_y[i] - 0.05235988f);
            }
            prim->End();
            SetSpriteEnv(prim, 0);
            prim->Begin(6);
            prim->Texture(anim_tex);
            prim->Color(0x80, 0x80, 0x80, 0x80);
            prim->TextureCrd(0, 0);
            prim->Vertex(0x100, 0, 0);
            prim->TextureCrd(0x100, 0x100);
            prim->Vertex(0x200, 0x126, 0);
            prim->End();
            SetSpriteEnv(prim, 0);
            float pulse_color[2][4] = {{230.0f, 0.0f, 0.0f, 0.0f}, {0.0f, 0.0f, 230.0f, 0.0f}};
            pulse_color[0][3] = 196.0f + 48.0f * sinf(pulse_angle[0]);
            pulse_color[1][3] = 196.0f + 48.0f * sinf(pulse_angle[1]);
            float pulse_speed[2] = {0.07853982f, 0.06283185f};
            int shift = 0;
            prim->Begin(6);
            prim->Texture(pulse_tex);
            for (int i = 0; i < 2; i++) {
                prim->Color(pulse_color[i]);
                prim->TextureCrd(0, 0);
                prim->Vertex(shift + 0x100, 0, 0);
                prim->TextureCrd(0x100, 0x100);
                prim->Vertex(shift + 0x200, 0x126, 0);
                pulse_angle[i] = mgAngleLimit(pulse_angle[i] + pulse_speed[i]);
                shift += 3;
            }
            prim->End();
        }
        if (map_type == 4 && anim_tex != NULL) {
            float island_y = 89.7f + 6.0f * sinf(float_angle);
            float shadow_y = 14.0f + (156.4f + 1.5f * sinf(float_angle));
            prim->Bilinear(1);
            prim->Begin(6);
            prim->Texture(anim_tex);
            prim->Color(0, 0, 0, 0x60);
            prim->TextureCrd(0xA, 0xA);
            prim->Vertex(373.0f, shadow_y, 0.0f);
            prim->TextureCrd(0x76, 0x76);
            prim->Vertex(469.0f, 128.0f + shadow_y - 50.0f, 0.0f);
            prim->Color(0x80, 0x80, 0x80, 0x80);
            prim->TextureCrd(0xA, 0xA);
            prim->Vertex(360.0f, island_y, 0.0f);
            prim->TextureCrd(0xF6, 0xF6);
            prim->Vertex(586.0f, 294.4f + island_y - 30.0f, 0.0f);
            prim->End();
            float_angle = mgAngleLimit(0.02617994f + float_angle);
        }
    }
    if (mark_tex != NULL) {
        mgRect<int> title_rect(-0x1C, -0xE, 0x100, 0x60);
        mgRect<int> title_source(0, 0, 0x100, 0x60);
        prim->Bilinear(1);
        prim->Begin(6);
        prim->Texture(mark_tex);
        prim->Color(0, 0, 0, 0x2E);
        mgRect<int> title_shadow(0, 0, 0, 0);
        title_shadow = title_rect;
        title_shadow.left += 4;
        title_shadow.top += 4;
        PrimQuad(prim, title_shadow, title_source);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        PrimQuad(prim, title_rect, title_source);
        prim->End();
        blink_cnt++;
        if (blink_cnt >= 90) {
            blink_cnt = 0;
        }
        mgRect<int> mark_source(0xD0, 0xB4, 0x14, 0x1E);
        if (blink_cnt > 45) {
            mark_source.top -= mark_source.bottom;
        }
        prim->Begin(6);
        prim->Texture(mark_tex);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        for (int i = 1; i < spi_wmaparea_tblnum; i++) {
            WMAP_AREA_DATA *area = &spi_wmaparea_tbl[i];
            if ((0 < here_area && here_area == area->area_no) || (here_area < 0 && area->enable != 0)) {
                PrimQuad(prim, mgRect<int>(area->x - 10, area->y - 15, 0x14, 0x1E), mark_source);
            }
        }
        prim->End();
    }

    CDC2Mes *name_mes = MenuDCMsg[4];
    WMAP_AREA_DATA *now_area = &spi_wmaparea_tbl[area_no];
    CDC2Mes *ask_mes = MenuDCMsg[2];
    CDC2Mes *list_mes = MenuDCMsg[3];
    if (name_view != 0) {
        char *name;
        for (int i = 0; i < spi_wmaparea_tblnum; i++) {
            if (area_no == i) {
                name = spi_wmaparea_tbl[i].name;
                break;
            }
        }
        name_mes->SetMsgItemNo(&name, 1);
        name_mes->MakeMsg(0x32);
        name_mes->StepMsg();
        if (now_area != NULL) {
            int x = 0;
            int y = 0;
            if (now_area->name_side == 0) {
                x = now_area->name_x + 0x1E;
                y = now_area->name_y;
            }
            if (now_area->name_side == 1) {
                x = now_area->name_x - name_mes->line_w[0] - 0x30;
                y = now_area->name_y;
            }
            name_mes->SetMovePosGyou(0, x, y);
        }
        name_mes->line_pos[0][0] -= 10;
        name_mes->line_pos[0][1] -= 15;
        MenuReloadTexture(loaded_tex, map_tex->block);
        int frame_step[4] = {0x1E, 0, 0x1E, 0};
        frame_step[1] = name_mes->line_w[0] - 0x1E;
        mgRect<int> frame(name_mes->line_pos[0][0] - 0x10, name_mes->line_pos[0][1] - 0xC, 0x1E, 0x2E);
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture(mark_tex);
        for (int i = 0; i < 3; i++) {
            prim->Color(0, 0, 0, 0x2E);
            PrimQuad(prim, mgRect<int>(frame.left + 4, frame.top + 4, frame.right, frame.bottom),
                     mgRect<int>(i * 0x1E, 0x60, 0x1E, 0x32));
            prim->Color(0x80, 0x80, 0x80, 0x80);
            PrimQuad(prim, frame, mgRect<int>(i * 0x1E, 0x60, 0x1E, 0x32));
            frame.left += frame_step[i];
            frame.right = frame_step[i + 1];
        }
        prim->End();
        MenuReloadTexture(loaded_tex, list_mes->texture_block);
        name_mes->StepMsg();
        name_mes->DrawMsg();
    }
    if (pos_list_view != 0) {
        float area_x = 0.0f;
        float area_y = 0.0f;
        if (now_area != NULL) {
            area_x = now_area->name_x;
            area_y = now_area->name_y;
        }
        list_mes->StepMsg();
        int put_pos[2] = {0, 0};
        put_pos[0] = (int)(60.0f + area_x);
        put_pos[1] = (int)area_y;
        int max_w = 0;
        int total_h = 0;
        for (int i = 0; select_area->pos[i] != NULL; i++) {
            int w = list_mes->GetStrWidth(i);
            if (max_w < w) {
                max_w = w;
            }
            total_h += list_mes->font_h;
        }
        if (mgScreenWidth - 0x50 - max_w < put_pos[0]) {
            put_pos[0] = mgScreenWidth - 0x50 - max_w;
        }
        if (mgScreenHeight - 0x50 - total_h < put_pos[1]) {
            put_pos[1] = mgScreenHeight - 0x50 - total_h;
        }
        list_mes->SetPutPos(put_pos);
        list_mes->StepMsg();
        list_mes->DrawMsg();
        MenuReloadTexture(loaded_tex, mark_tex->block);
        float icon_y = 25.0f + put_pos[1];
        float icon_x = 24.0f + put_pos[0];
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture(mark_tex);
        for (int i = 0; i < pos_num; i++) {
            mgRect<int> icon_source(pos_icon[i] * 0x14 + 0xB0, 0x60, 0x14, 0x18);
            if (i == list_mes->GetMsgCursor()) {
                prim->Color(0x80, 0x80, 0x80, 0x80);
            } else {
                prim->Color(0x40, 0x40, 0x40, 0x80);
            }
            PrimQuad(prim, icon_x, icon_y, icon_source);
            icon_y += 24.0f;
        }
        prim->End();
    }
    if (ask_view != 0) {
        MenuReloadTexture(loaded_tex, ask_mes->texture_block);
        ask_mes->StepMsg();
        ask_mes->DrawMsg();
    }
    if (cursor_tex != NULL && cursor_view != 0) {
        float target_y = now_area->y - 0xF;
        CalcMenu1((float)(now_area->x - 0x32), &cursor_pos[0], 4.0f, 0.0f, cursor_reset);
        CalcMenu1(target_y, &cursor_pos[1], 4.0f, 0.0f, cursor_reset);
        cursor_reset = 0;
        MenuReloadTexture(loaded_tex, cursor_tex->block);
        MenuCursorDraw(cursor_tex, cursor_pos, 0.0f, 0, 0x80, 1.0f);
    }
    if (menu_debug_flag != 0) {
        int debug_tex = -1;
        MenuReloadTexture(debug_tex, MenuArg.mes_tex_block);
        DrawMenuFillBox(300.0f, 10.0f, 220.0f, 40.0f, 0x40, 0, 0, 0);
        CMenuFont font;
        font.SetStr(at_1498__3);
        font.SetPos(0x136, 0xC);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", Draw__13CWorldMapMenuFv);
#endif
inline CWorldMapMenu::CWorldMapMenu() {
    int i;

    memset(unk_118, 0, sizeof(unk_118));
    area_no = 0;
    capture_view = 0;
    name_view = 0;
    pos_list_view = 0;
    cursor_reset = 0;
    cursor_view = 0;
    ask_view = 0;
    select_area = NULL;
    select_pos = NULL;
    here_area = -1;
    view_only = 0;
    exit_wait = 0;
    back_alpha = 128.0f;
    blink_cnt = 0;
    cursor_tex = NULL;
    wave_x[0] = 0.0f;
    wave_y[0] = 0.0f;
    for (i = 0; i < WMAP_WAVE_LINE_NUM - 1; i++) {
        wave_x[i + 1] = mgAngleLimit(0.1308997f + wave_x[i]);
        wave_y[i + 1] = mgAngleLimit(0.10471976f + wave_y[i]);
    }
    float_angle = 0.0f;
    pulse_angle[0] = 0.0f;
    pulse_angle[1] = 0.0f;
    capture_tex = NULL;
    map_tex = NULL;
    mark_tex = NULL;
    anim_tex = NULL;
    pulse_tex = NULL;
    map_type = 1;
    mes_data = NULL;
    menu_mes_data = NULL;
    for (i = 0; i < WMAP_AREA_POS_MAX; i++) {
        pos_icon[i] = 0;
    }
    spi_wmaparea_tblnum = 0;
    spi_wmaparea_tbl = NULL;
    spi_wmappos_tblnum = 0;
    spi_wmappos_tbl = NULL;
    WorldMap_MapNo = -1;
    WorldMap_NextLoopNo = -1;
    WorldMap_DngFloor = -1;
}
int WorldMoveInit(mgCMemory *stack, int *tex_block, int open_type) {
    char path[0x20];
    u_long128 *buffer;
    unsigned int size;
    unsigned int blocks;

    int available = stack->stGetRest();
    u_long128 *top = stack->stGetTop();
    WorldMapStack.stSetBuffer(top, available);
    WorldMapPtr = new(WorldMapStack.Alloc(0xBD)) CWorldMapMenu;
    WorldMapStack.Align64();
    WorldMapPtr->SetTexBlock(tex_block);
    WorldMapPtr->FadeOutMenu(40, 0.0f);
    WorldMapMenuType = 0;
    GetMapType(GetMainScene()->now_map_no);
    if (MenuCommonInfo->open_type == MENU_OPEN_WORLD_MOVE) {
        WorldMapPtr->back_alpha = 0.0f;
    }
    WorldMapPtr->capture_tex = mgTexManager.GetTexture(at_1556__2, -1);
    buffer = WorldMapStack.stGetTop();
    if (CheckBitFlagMenu(0x258) != 0) {
        WorldMapPtr->map_type = 2;
    }
    if (CheckBitFlagMenu(0x268) != 0) {
        WorldMapPtr->map_type = 4;
    }
    if (CheckBitFlagMenu(0x280) != 0) {
        WorldMapPtr->map_type = 3;
    }
    StartReadBG();
    sprintf(path, at_1557__2, WorldMapPtr->map_type);
    size = LoadFileMenu(path, buffer, 0);
    if (size & 0xF) {
        blocks = (size >> 4) + 1;
    } else {
        blocks = size >> 4;
    }
    WorldMapStack.Alloc(blocks);
    return 1;
}
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
void SphidaScreListUpdate(CDC2Mes *mes, int update) {
    int top;
    int line;
    SPHIDA_PLAYER_DATA *player;

    if (mes == NULL || SubSphidaData == NULL) {
        return;
    }
    top = SphidaSelect[1];
    if (SfidaMakeLine == 1) {
        top--;
        if (top < 0) {
            top = 0;
        }
    }
    if (update != 0) {
        for (line = 0; line < 9; line++) {
            player = SubSphidaData->GetPlayerData(top);
            if (player != NULL) {
                if (player->name[0] == 0 && player->name[1] == 0) {
                    char *unregistered = Mitouroku[LanguageCode];
                    if (unregistered != NULL) {
                        strcpy(mes->name[line], unregistered);
                    }
                } else if (player != NULL) {
                    strcpy(mes->name[line], player->name);
                }
                top++;
            }
        }
        mes->ClsMes::mes_no = -1;
        mes->MakeMsg(0x13EE);
    }
}
void SphidaMenuInit(mgCMemory *stack, int *tex_block, int open_type) {
    int available = stack->stGetRest();
    u_long128 *top = stack->stGetTop();
    SphidaStack.stSetBuffer(top, available);
    for (int i = 0; i < 16; i++) {
        SphidaMenuTexbk[i] = tex_block[i];
    }
    D_01F3C7FC[0] = -1;
    MenuMainScene->fade.FadeIn(40);
    SubSaveData__2 = GetSubGameSaveData();
    SubSphidaData = NULL;
    if (SubSaveData__2 != NULL) {
        SubSphidaData = SubSaveData__2->GetSphidaData();
        SphidaMenuMes = new(SphidaStack.Alloc(0x2A7)) CDC2Mes;
        SphidaMenuMes->SetMessData(GetSystemMesBuffer(), GetMenuMainMessageBuffer());
        SphidaMenuMes->MsgPreset(0x12);
        SphidaMenuMes->SetPutPos(0x100, 0x34, -1, -1);
        SphidaMenuMes->MakeMsg(0x13EC);
        SphidaMenuMes->SetMsgCursor(0);
        SphidaMenuQus = new(SphidaStack.Alloc(0x2A7)) CDC2Mes;
        SphidaMenuQus->SetMessData(GetSystemMesBuffer(), GetMenuMainMessageBuffer());
        SphidaMenuQus->MsgPreset(0x12);
        SphidaMenuQus->MakeMsg(0x13F1);
        SphidaMenuQusDrawFlag = 0;
        SphidaScore = new(SphidaStack.Alloc(0x2A7)) CDC2Mes;
        SphidaScore->SetMessData(GetSystemMesBuffer(), GetMenuMainMessageBuffer());
        SphidaScore->MsgPreset(0x10);
        SphidaScore->SetPutPos(0x16, 0x14, -1, -1);
        SphidaScore->MakeMsg(0x13EE);
        SphidaSelect[0] = 0;
        SphidaInfoMsgDrawFlag = 0;
        SphidaSelect[1] = 0;
        SfidaMakeLine = 0;
        MenuBGTextureBlock = SphidaMenuTexbk[0];
        SfidaMoveInitFlag = 0;
        MenuCapture(MenuBGTextureBlock, &SphidaStack, 1);
        MenuPosData->AttachCommonTexInfo();
        MenuCommonInfo->key_enable = 1;
        u_long128 *buffer = SphidaStack.stGetTop();
        unsigned int size = LoadFileMenu(at_1674, buffer, 1);
        unsigned int blocks;
        if (size & 15) {
            blocks = (size >> 4) + 1;
        } else {
            blocks = size >> 4;
        }
        SphidaStack.Alloc(blocks);
        mgTexManager.EnterIMGFile((u8 *)buffer, SphidaMenuTexbk[1], NULL, NULL);
        SphidaTex = mgTexManager.GetTexture(at_1675, -1);
        mgTexManager.EnterIMGFile((u8 *)GetMenuMainIMGPtr(), SphidaMenuTexbk[1], NULL, NULL);
        SphidaCursor = mgTexManager.GetTexture(at_1310__4, -1);
        SphidaCursorY = 300.0f;
        SphidaCursorDrawFlag = 0;
        SphidaCursorCount = 0;
        SphidaTex2 = mgTexManager.GetTexture(at_1676, -1);
        SphidaTex_Sys = mgTexManager.GetTexture(at_1677, -1);
        SphidaMenuPhase = 0;
        SubSphidaData->InitPlay();
        SphidaScreListUpdate(SphidaScore, 1);
    }
}
int OmakeSfidaSelect(int key) {
    int movement = MenuListSelectKeyCheck(key, 8);
    int distance = abs(movement);
    if (distance > 2) {
        SfidaMoveInitFlag = 1;
    }
    return movement;
}

#ifdef NONMATCHING
int SphidaMenuKey() {
    int select_key = MenuCommonInfo->CheckSelectKey() | MenuCommonInfo->CheckLRKey();
    int push_button = MenuCommonInfo->CheckPushButton();
    if (SubSphidaData == NULL) {
        return 1;
    }
    int list_changed = 0;
    int old_top = SphidaSelect[1];
    CDC2Mes *question = SphidaMenuQus;

    switch (SphidaMenuPhase) {
        case SPHIDA_MENU_TOP: {
            int choice;
            if (LanguageCode == 0) {
                choice = SphidaMenuMes->AddMsgCursor2(0, 3, 1);
            } else {
                choice = SphidaMenuMes->AddMsgCursor2(0, 2, 1);
            }
            if (push_button & MENU_PUSH_BUTTON_DECIDE) {
                int command = choice;
                if (LanguageCode != 0) {
                    if (choice == 1) {
                        command = 2;
                    }
                    if (choice == 2) {
                        command = 3;
                    }
                }
                switch (command) {
                    case 0:
                        SphidaMenuPhase = SPHIDA_MENU_NAME_FADE;
                        MenuMainScene->fade.FadeOut(30, 0.0f, 0.0f, 0.0f);
                        MenuSePlay(1);
                        break;
                    case 1:
                        SphidaCursorDrawFlag = 1;
                        SphidaMenuPhase = SPHIDA_MENU_PASSWORD;
                        SphidaMenuMes->cursor_on = 0;
                        MenuSePlay(1);
                        break;
                    case 2:
                        SphidaCursorDrawFlag = 1;
                        SphidaMenuMes->cursor_on = 0;
                        SphidaMenuPhase = SPHIDA_MENU_CLEAR;
                        MenuSePlay(1);
                        break;
                    case 3:
                        SphidaMenuQusDrawFlag = 1;
                        question->MsgPreset(0xB);
                        question->SetAbsPos(5);
                        question->MakeMsg(0xC58);
                        question->SetMsgCursor(1);
                        SphidaMenuMes->cursor_on = 0;
                        SphidaMenuPhase = SPHIDA_MENU_QUIT_ASK;
                        MenuSePlay(1);
                        break;
                }
            } else if (DebugFlag != 0 && menu_debug_flag != 0 && (push_button & MENU_PUSH_BUTTON_SQUARE)) {
                SubSphidaData->Initialize();
                list_changed = 1;
            }
            break;
        }
        case SPHIDA_MENU_EXIT:
        case SPHIDA_MENU_NAME_FADE:
            if (MenuMainScene->fade.FadeCheck() != 0) {
                if (SphidaMenuPhase == SPHIDA_MENU_NAME_FADE) {
                    SphidaMenuPhase = SPHIDA_MENU_NAME_REGIST;
                    Nameregi_Target.target = NAMEREGI_TARGET_SPHIDA;
                    NameRegistInit(&SphidaStack, &SphidaMenuTexbk[5], 4);
                    break;
                }
                return 2;
            }
            break;
        case SPHIDA_MENU_NAME_REGIST:
            if (NameRegistKey() != 0) {
                SubSphidaData->InitPlay();
                if (Nameregi_Target.keyword[0] != 0) {
                    strcpy(SubSphidaData->player_name, Nameregi_Target.keyword);
                    MenuArg.end_code = 0x12;
                    MenuArg.result[0] = 0x12;
                    MenuMainScene->fade.FadeOut(30, 0.0f, 0.0f, 0.0f);
                    SphidaMenuPhase = SPHIDA_MENU_EXIT;
                } else {
                    MenuMainScene->fade.FadeIn(20);
                    SphidaMenuPhase = SPHIDA_MENU_TOP;
                }
            }
            break;
        case SPHIDA_MENU_PASSWORD: {
            if (MenuKeySelectCheck(OmakeSfidaSelect(select_key), &SphidaSelect[0], &SphidaSelect[1], 0, 0x40, 8, 0) != 0) {
                MenuSePlay(0);
                int new_top = SphidaSelect[1];
                if (old_top != new_top) {
                    SfidaMakeLine = old_top < new_top ? 1 : 0;
                    list_changed = 1;
                }
            }
            if (push_button & MENU_PUSH_BUTTON_DECIDE) {
                SPHIDA_PLAYER_DATA *player = SubSphidaData->GetPlayerData(SphidaSelect[0]);
                if (player == NULL || player->name[0] == 0) {
                    MenuSePlay(5);
                } else {
                    char password_text[0x30];
                    u8 password_data[16];
                    char password_sjis[0x88];
                    int i;
                    int encoded;

                    memset(password_data, 0, sizeof(password_data));
                    for (i = 0; i < 10; i++) {
                        password_data[i] = player->hole_score[i];
                    }
                    password_data[13] = *(u8 *)&player->password_key;
                    encoded = EncodePassword(password_data, 0x10, (u8 *)player, 0x14, password_text, 0x48);
                    ConvertAscii2ShitJiss(password_text, password_sjis);
                    password_sjis[0x2C] = 0;
                    password_sjis[0x2D] = 0;
                    if (encoded == 0) {
                        MenuSePlay(5);
                    } else {
                        MenuSePlay(1);
                        SphidaMenuQusDrawFlag = 1;
                        SphidaCursorDrawFlag = 0;
                        question->MsgPreset(0x12);
                        question->SetAbsPos(5);
                        question->MakeMsg(0x13F0);
                        if (player != NULL) {
                            strcpy(question->name[0], player->name);
                        }
                        strcpy(question->name[2], password_sjis);
                        if (LanguageCode == 0) {
                            SphidaInfoMsgDrawFlag = 1;
                            MenuDCMsg[2]->MsgPreset(0x12);
                            MenuDCMsg[2]->SetAbsPos(8);
                            MenuDCMsg[2]->MakeMsg(0x13F2);
                        }
                        SphidaMenuPhase = SPHIDA_MENU_PASSWORD_VIEW;
                    }
                }
            } else if (push_button & MENU_PUSH_BUTTON_CANCEL) {
                SphidaMenuPhase = SPHIDA_MENU_TOP;
                SphidaCursorDrawFlag = 0;
                SphidaMenuQusDrawFlag = 0;
                SphidaMenuMes->cursor_on = 1;
                MenuSePlay(5);
            }
            break;
        }
        case SPHIDA_MENU_PASSWORD_VIEW:
            if (push_button != 0) {
                SphidaCursorDrawFlag = 1;
                SphidaMenuQusDrawFlag = 0;
                SphidaMenuPhase = SPHIDA_MENU_PASSWORD;
                SphidaInfoMsgDrawFlag = 0;
                MenuSePlay(5);
            }
            break;
        case SPHIDA_MENU_CLEAR: {
            if (MenuKeySelectCheck(OmakeSfidaSelect(select_key), &SphidaSelect[0], &SphidaSelect[1], 0, 0x40, 8, 0) != 0) {
                MenuSePlay(0);
                int new_top = SphidaSelect[1];
                if (old_top != new_top) {
                    SfidaMakeLine = old_top < new_top ? 1 : 0;
                    list_changed = 1;
                }
            }
            if (push_button & MENU_PUSH_BUTTON_DECIDE) {
                SPHIDA_PLAYER_DATA *player = SubSphidaData->GetPlayerData(SphidaSelect[0]);
                if (player == NULL || player->name[0] == 0) {
                    MenuSePlay(5);
                } else {
                    char *clear_names[2] = {NULL, NULL};

                    question->MsgPreset(0xB);
                    question->SetAbsPos(5);
                    question->MakeMsg(0x13F1);
                    clear_names[0] = player->name;
                    question->SetMsgItemNo(clear_names, 1);
                    question->SetMsgCursor(1);
                    SphidaMenuQusDrawFlag = 1;
                    MenuSePlay(1);
                    SphidaMenuPhase = SPHIDA_MENU_CLEAR_ASK;
                }
            } else if (push_button & MENU_PUSH_BUTTON_CANCEL) {
                SphidaMenuPhase = SPHIDA_MENU_TOP;
                SphidaCursorDrawFlag = 0;
                SphidaMenuQusDrawFlag = 0;
                SphidaMenuMes->cursor_on = 1;
                MenuSePlay(5);
            }
            break;
        }
        case SPHIDA_MENU_CLEAR_ASK: {
            int answer = question->YesNoCursor2(0);
            if (answer == 1) {
                MenuSePlay(1);
                SubSphidaData->ClearPlayerScore(SphidaSelect[0]);
                SphidaMenuQusDrawFlag = 0;
                SphidaMenuPhase = SPHIDA_MENU_CLEAR;
                list_changed = 1;
            }
            if (answer == 2) {
                MenuSePlay(5);
                SphidaMenuQusDrawFlag = 0;
                SphidaMenuPhase = SPHIDA_MENU_CLEAR;
            }
            break;
        }
        case SPHIDA_MENU_QUIT_ASK: {
            int answer = question->YesNoCursor2(0);
            if (answer == 1) {
                MenuArg.result[0] = 0x14;
                SphidaMenuQusDrawFlag = 0;
                MenuMainScene->fade.FadeOut(30, 0.0f, 0.0f, 0.0f);
                SphidaMenuPhase = SPHIDA_MENU_EXIT;
                MenuSePlay(1);
            }
            if (answer == 2) {
                SphidaMenuPhase = SPHIDA_MENU_TOP;
                SphidaMenuQusDrawFlag = 0;
                SphidaMenuMes->cursor_on = 1;
                MenuSePlay(5);
            }
            break;
        }
    }
    SphidaScreListUpdate(SphidaScore, list_changed);
    SfidaBGXY += 0.5f;
    if (SfidaBGXY >= 0.0f) {
        SfidaBGXY -= 256.0f;
    }
    question->StepMsg();
    SphidaMenuMes->StepMsg();
    SphidaScore->StepMsg();
    MenuDCMsg[2]->StepMsg();
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", SphidaMenuKey__Fv);
#endif
#ifdef NONMATCHING
extern float SphidaScoreListY;
extern float SphidaScoreListBarY;
extern char at_1937__2[];
extern char at_1938__2[];
void SphidaMenuDraw() {
    int list_rect[4];
    mgRect<int> clip;
    if (SphidaMenuPhase == 100) {
        NameRegistDraw();
        return;
    }
    if (SubSphidaData == NULL) {
        return;
    }
    CalcMenu1((float)(SphidaSelect[1] * -0x18), &SphidaScoreListY, 4.0f, 3.5f, SfidaMoveInitFlag);
    mgCDrawPrim *prim = GetMenuPrim();
    if (SphidaTex2 != NULL) {
        mgTexManager.ReloadTexture(SphidaTex2->block, (sceVif1Packet *)NULL);
        mgRect<int> tile(0x100, 0x100, 0x100, 0x100);
        DrawMenuTilePattern(prim, SphidaTex2, SfidaBGXY, SfidaBGXY, tile, 0, NULL);
    }
    SPHIDA_PLAYER_DATA *player = SubSphidaData->GetPlayerData(0);
    clip.Set(0, 0, 0, 0);
    if (SphidaTex != NULL) {
        mgTexManager.ReloadTexture(SphidaTex->block, (sceVif1Packet *)NULL);
        if (LanguageCode == 0) {
            DrawSubGameTitle(SphidaTex, 1, 0x1E, 0x1E, 0xCA);
        } else {
            DrawSubGameTitle(SphidaTex, 1, 0x18, 0x1A, 0xDE);
        }
        mgRect<int> title(0, 0xB6, 0xB4, 0x1C);
        PrimQuad(prim, SphidaTex, 45.0f, 41.0f, title, 0x80, 0x80, 0x80, 0x80);
        if (LanguageCode == 0) {
            DrawSubGameTitle(SphidaTex, 0, 0x5A, mgScreenHeight - 0x13E, 0x66);
            mgRect<int> score_label(0x6C, 0x9E, 0x30, 0x18);
            PrimQuad(prim, SphidaTex, 118.0f, mgScreenHeight - 0x133, score_label, 0x80, 0x80, 0x80, 0x80);
        } else {
            DrawSubGameTitle(SphidaTex, 0, 0x46, mgScreenHeight - 0x13E, 0x86);
            mgRect<int> score_label(0, 0x5C, 0x50, 0x18);
            PrimQuad(prim, SphidaTex, 98.0f, mgScreenHeight - 0x133, score_label, 0x80, 0x80, 0x80, 0x80);
        }
        list_rect[2] = 0x15E;
        list_rect[3] = 0xE0;
        list_rect[0] = (mgScreenWidth - list_rect[2]) >> 1;
        list_rect[1] = mgScreenHeight - 0x104;
        int scroll[2];
        scroll[1] = fptosi(25.75f);
        CalcMenu1(3.21875f * (float)SphidaSelect[1], &SphidaScoreListBarY, 3.0f, 0.0f, SfidaMoveInitFlag);
        scroll[0] = fptosi(SphidaScoreListBarY);
        DrawSubGameScrlList(SphidaTex, list_rect, scroll);
        clip.Set(list_rect[0] + 4, list_rect[1] + 0xE, list_rect[0] + list_rect[2], list_rect[1] + list_rect[3] - 0x10);
        SetMenuScissor(clip);
        int y = fptosi((float)(list_rect[1] + 0x22) + SphidaScoreListY);
        for (int rank = 0; rank < 0x40; rank++, y += 0x18, player++) {
            mgRect<int> digits(0, 0xEC, 0x12, 0x14);
            SetSpriteEnv(prim, 0);
            prim->Begin(6);
            prim->Texture(SphidaTex);
            prim->Color(0x80, 0x80, 0x80, 0x80);
            PrimDrawNumber(prim, rank + 1, 1, list_rect[0] + 0x32, y - 0x14, digits, -2, 0);
            int suffix_x = list_rect[0] + 0x32 + (GetNumberKeta(rank + 1) - 1) * 9;
            mgRect<int> rank_suffix(0xC6, 0xEC, 0x12, 0x14);
            PrimQuad(prim, suffix_x, y - 0x14, rank_suffix);
            if (player->name[0] == 0 && player->name[1] == 0) {
                mgRect<int> no_score(0xB4, 0xEC, 0x12, 0x14);
                PrimQuad(prim, list_rect[0] + 0xD2, y - 0x14, no_score);
            } else {
                PrimDrawNumber(prim, player->total_score, 1, list_rect[0] + 0xFC, y - 0x14, digits, -2, 0);
                float unit_x = 260.0f + list_rect[0];
                if (CheckNowEurope()) {
                    unit_x = 264.0f + list_rect[0];
                }
                mgRect<int> unit(0x4A, 0x88, 0x34, 0x16);
                PrimQuad(prim, unit_x, (float)y - 20.0f, unit);
            }
            prim->End();
            DrawSubGameUnderLine(SphidaTex, list_rect[0] + 0x16, y, list_rect[2] - 0x34);
        }
        ResetMenuScissor();
    }
    if (SphidaCursorDrawFlag && SphidaCursor != NULL) {
        mgTexManager.ReloadTexture(SphidaCursor->block, (sceVif1Packet *)NULL);
        CalcMenu1((float)(list_rect[1] + 0xD + (SphidaSelect[0] - SphidaSelect[1]) * 0x18), &SphidaCursorY, 4.0f, 3.2f, 0);
        SphidaCursorCount++;
        if (SphidaCursorCount >= 59999999) {
            SphidaCursorCount = 0;
        }
        float cursor_x = (float)(list_rect[0] - 0xC) + 8.0f * cosf(mgAngleLimit(0.05235988f * SphidaCursorCount));
        PrimQuad(prim, SphidaCursor, cursor_x, SphidaCursorY + 4.0f * sinf(mgAngleLimit(0.10471976f * SphidaCursorCount)),
                 menu_long_hand, 0x80, 0x80, 0x80, 0x80);
    }
    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
    SphidaMenuMes->DrawMsg();
    if (SphidaScore != NULL) {
        clip.left += 0xA;
        clip.right -= 0xA;
        clip.bottom -= 2;
        SetMenuScissor(clip);
        int top = SphidaSelect[1];
        if (SfidaMakeLine == 1) {
            top--;
            if (top < 0) {
                top = 0;
            }
        }
        int line_x = list_rect[0] + 0x30;
        float line_y = (float)(list_rect[1] + 0x22) + SphidaScoreListY - 20.0f + 24.0f * top;
        if (LanguageCode > 0) {
            line_x = list_rect[0] + 0x3A;
        }
        for (int line = 0; line < 9; line++, line_y += 24.0f) {
            SphidaScore->SetMovePosGyou(line, line_x, fptosi(line_y));
        }
        SphidaScore->DrawMsg();
        ResetMenuScissor();
    }
    if (SphidaInfoMsgDrawFlag && MenuDCMsg[2] != NULL) {
        MenuDCMsg[2]->DrawMsg();
    }
    if (SphidaMenuQusDrawFlag && SphidaMenuQus != NULL) {
        SphidaMenuQus->DrawMsg();
    }
    if (menu_debug_flag) {
        CMenuFont font;
        font.DrawDirect(at_1937__2, 0x14, 0x50);
        font.DrawDirect(at_1938__2, 0x14, 0x64);
    }
    SfidaMoveInitFlag = 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", SphidaMenuDraw__Fv);
#endif
void SphidaScoreViewInit(mgCMemory *memory, int *tex_block, int) {
    int available = memory->stGetRest();
    u_long128 *top = memory->stGetTop();
    SphidaStack.stSetBuffer(top, available);
    SphidaMenuTexbk[0] = tex_block[0];
    SphidaMenuTexbk[1] = tex_block[1];
    SphidaMenuTexbk[2] = tex_block[2];
    SphidaMenuTexbk[3] = tex_block[3];
    SphidaMenuTexbk[4] = tex_block[4];
    SphidaMenuTexbk[5] = tex_block[5];
    SphidaMenuTexbk[6] = tex_block[6];
    SphidaMenuTexbk[7] = tex_block[7];
    MenuBGTextureBlock = SphidaMenuTexbk[0];
    MenuCapture(MenuBGTextureBlock, &SphidaStack, 1);
    MenuPosData->AttachCommonTexInfo();
    SubSaveData__2 = GetSubGameSaveData();
    SubSphidaData = NULL;
    if (SubSaveData__2 != NULL) {
        SubSphidaData = SubSaveData__2->GetSphidaData();
        SphidaStack.Align64();
        u_long128 *buffer = SphidaStack.stGetTop();
        unsigned int size = LoadFileMenu(at_1674, buffer, 1);
        unsigned int blocks;
        if (size & 15) {
            blocks = (size >> 4) + 1;
        } else {
            blocks = size >> 4;
        }
        SphidaStack.Alloc(blocks);
        mgTexManager.EnterIMGFile((u8 *)buffer, SphidaMenuTexbk[1], NULL, NULL);
        SphidaTex = mgTexManager.GetTexture(at_1675, -1);
        SphidaTex_Sys = mgTexManager.GetTexture(at_1677, -1);
        MenuCommonInfo->key_enable = 1;
        Sfida_NowPlayHorlBlink = 0;
    }
}

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
#ifdef NONMATCHING
void SphidaScoreViewDraw() {
    mgCTextureManager *textures = &mgTexManager;
    mgRect<int> hole_digits;
    mgRect<int> score_digits;
    mgRect<int> number_digits;
    mgRect<int> dest;
    mgRect<int> source;
    mgRect<int> dest_edge;
    mgRect<int> source_edge;
    mgRect<int> label_left;
    mgRect<int> label_right;
    mgRect<int> label_wide;
    mgRect<int> title;
    mgRect<int> hole_label;
    mgRect<int> par_label;
    mgRect<int> score_label;
    mgCDrawPrim *prim;
    int hole_no;
    int row_y;
    int row;
    int loaded_tex_no;
    int number_y;
    int label_y;

    textures->ReloadTexture(SphidaMenuTexbk[0], (sceVif1Packet *)NULL);
    loaded_tex_no = -1;
    source.Set(0, 0, mgScreenWidth / 2, mgScreenHeight / 2);
    dest.Set(0, 0, mgScreenWidth, mgScreenHeight);
    DrawMenuMainFrmImg(loaded_tex_no, dest, source, 128, 128, 128, 128, 1);
    source_edge.Set(0, 0, mgScreenWidth / 2, mgScreenHeight / 2);
    dest_edge.Set(-1, -1, mgScreenWidth + 1, mgScreenHeight + 1);
    DrawMenuMainFrmImg(loaded_tex_no, dest_edge, source_edge, 128, 128, 128, 128, 0);

    prim = GetMenuPrim();
    hole_no = SubSphidaData->GetNowHorl() + 1;
    if (SphidaTex_Sys != NULL) {
        hole_digits.Set(0, 0x60, 0x1C, 0x20);
        textures->ReloadTexture(SphidaTex_Sys->block, (sceVif1Packet *)NULL);
        SetSpriteEnv(prim, 0);
        prim->Begin(6);
        prim->Texture(SphidaTex_Sys);
        prim->Color(128, 128, 128, 128);
        if (LanguageCode == 0) {
            label_left.Set(0, 0, 0x24, 0x26);
            label_y = mgScreenHeight - 0x4C;
            PrimQuad(prim, 42.0f, (float)label_y, label_left);
            label_right.Set(0x24, 0, 0x5A, 0x26);
            PrimQuad(prim, 110.0f, (float)(mgScreenHeight - 0x4C), label_right);
            PrimDrawNumber(prim, hole_no, 0, 0x6A, mgScreenHeight - 0x4A, hole_digits, -2, 0);
        } else if (LanguageCode > 0) {
            label_wide.Set(0, 0, 0x88, 0x26);
            PrimQuad(prim, 42.0f, mgScreenHeight - 0x4C, label_wide);
            number_y = mgScreenHeight - 0x4A;
            PrimDrawNumber(prim, hole_no, 0, 0xCE, number_y, hole_digits, -2, 0);
        }
        prim->End();
    }
    if (SphidaTex != NULL) {
        textures->ReloadTexture(SphidaTex->block, (sceVif1Packet *)NULL);
        DrawSubGameTitle(SphidaTex, 0, 0x152, 0x2A, 0x78);
        title.Set(0, 0x88, 0x4A, 0x16);
        PrimQuad(prim, SphidaTex, 360.0f, 54.0f, title, 128, 128, 128, 128);
        DrawSubGameListFix(SphidaTex, 0x14A, 0x5A, 0x8C, 0xFA);
        row_y = 0x84;
        for (row = 0; row < 9; row++) {
            DrawSubGameUnderLine(SphidaTex, 0x158, row_y, 0x6E);
            score_digits.Set(0, 0xEC, 0x12, 0x14);
            number_digits.Set(0, 0x74, 0xE, 0x14);
            SetSpriteEnv(prim, 0);
            prim->Begin(6);
            prim->Texture(SphidaTex);
            prim->Color(128, 128, 128, 128);
            if (Sfida_NowPlayHorlBlink > 0x19 && row == hole_no - 1) {
                prim->Color(0xD2, 0xD2, 0x64, 128);
            }
            PrimDrawNumber(prim, row + 1, 0, 0x178, row_y - 0x12, number_digits, -2, 0);
            hole_label.Set(0x9A, 0x74, 0xE, 0x14);
            int hole_y = row_y - 0x12;
            PrimQuad(prim, 376.0f, hole_y, hole_label);
            prim->Color(128, 128, 128, 128);
            if (hole_no < row + 1) {
                par_label.Set(0xB4, 0xEC, 0x12, 0x14);
                PrimQuad(prim, 406.0f, row_y - 0x12, par_label);
            } else {
                PrimDrawNumber(prim, SubSphidaData->GetHorlScore(row), 0, 0x1A6, row_y - 0x13, score_digits, -2, 0);
                score_label.Set(0x7E, 0x88, 0xE, 0x16);
                PrimQuad(prim, 430.0f, row_y - 0x12, score_label);
            }
            prim->End();
            row_y += 0x16;
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menumap", SphidaScoreViewDraw__Fv);
#endif

// Static initialiser (.init)
extern "C" void __sinit_menumap_cpp() {
    WorldMapStack.Init();
    SphidaStack.Init();
}

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
