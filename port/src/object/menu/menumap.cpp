// clang-format off
// Load JSON before legacy game headers define conflicting macros.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"
#include "mw_runtime.h"

#include <array>
#include <cmath>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <optional>
#include <string>
#include <type_traits>
#include <vector>

#include "dataread.hpp"
#include "dngmenu.hpp"
#include "effectlist.hpp"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menumap.hpp"
#include "menusys.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nameregi.hpp"
#include "pal_timing.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "storage/password.hpp"
#include "stubs/menumap.hpp"
#include "sysmes.hpp"
#include "text/bounded.hpp"

/**
 *
 * Whether Spheda cursor movement should snap to its target.
 *
 */
static signed char SfidaMoveInitFlag;

/**
 *
 * Storage for the active world map menu.
 *
 */
static mgCMemory WorldMapStack;

/**
 *
 * Storage for the active Spheda menu.
 *
 */
static mgCMemory SphidaStack;

/**
 *
 * Texture blocks used by the Spheda menu.
 *
 */
static int SphidaMenuTexbk[16];
static_assert(std::size(SphidaMenuTexbk) == std::extent_v<decltype(CBaseMenuClass::tex_block)>);

/**
 *
 * Subgame save data used by the Spheda menus.
 *
 */
static CSubGameData *SubSaveData__2;

/**
 *
 * Spheda player and course records used by the menus.
 *
 */
static CSphidaData *SubSphidaData;

/**
 *
 * Primary Spheda menu texture.
 *
 */
static mgCTexture *SphidaTex;

/**
 *
 * Spheda menu interface texture.
 *
 */
static mgCTexture *SphidaTex_Sys;

/**
 *
 * Animated background offset for the Spheda menu.
 *
 */
static float SfidaBGXY;

/**
 *
 * Message window for the Spheda menu and score list.
 *
 */
static CDC2Mes *SphidaMenuMes;

/**
 *
 * Question window for Spheda menu confirmation prompts.
 *
 */
static CDC2Mes *SphidaMenuQus;

/**
 *
 * Message window used for Spheda score information.
 *
 */
static CDC2Mes *SphidaScore;

/**
 *
 * Whether to draw the Spheda confirmation question.
 *
 */
static u8 SphidaMenuQusDrawFlag;

/**
 *
 * Whether to draw the Spheda information message.
 *
 */
static u8 SphidaInfoMsgDrawFlag;

/**
 *
 * Spheda menu background texture.
 *
 */
static mgCTexture *SphidaTex2;

/**
 *
 * Texture used to draw the Spheda menu cursor.
 *
 */
static mgCTexture *SphidaCursor;

/**
 *
 * Whether to draw the Spheda menu cursor.
 *
 */
static u8 SphidaCursorDrawFlag;

/**
 *
 * Vertical position of the Spheda menu cursor.
 *
 */
static float SphidaCursorY;

/**
 *
 * Frame counter for the Spheda cursor animation.
 *
 */
static int SphidaCursorCount;

/**
 *
 * Current phase of the Spheda menu.
 *
 */
static short SphidaMenuPhase;

/**
 *
 * Cursor index and first visible row in the Spheda lists.
 *
 */
static int SphidaSelect[2];

/**
 *
 * Whether the Spheda list needs its next row populated.
 *
 */
static short SfidaMakeLine;

/**
 *
 * Menu that the world move menu mode shows. @see WORLD_MAP_MENU_TYPE
 *
 */
static signed char WorldMapMenuType;

/**
 *
 * Active world map menu instance.
 *
 */
static CWorldMapMenu *WorldMapPtr;

/**
 *
 * Frame counter for the active Spheda player highlight.
 *
 */
static short Sfida_NowPlayHorlBlink;

/**
 *
 * Main-loop mode requested by the selected travel destination.
 *
 */
static short WorldMap_NextLoopNo;

/**
 *
 * Map requested by the selected travel destination.
 *
 */
static short WorldMap_MapNo;

/**
 *
 * Dungeon floor requested by the selected travel destination.
 *
 */
static short WorldMap_DngFloor;

/**
 *
 * Number of scripted world map places.
 *
 */
static short spi_wmappos_tblnum;

/**
 *
 * Scripted world map place records.
 *
 */
static WMAP_POS_DATA *spi_wmappos_tbl;

/**
 *
 * Number of scripted world map areas.
 *
 */
static short spi_wmaparea_tblnum;

/**
 *
 * Scripted world map area records.
 *
 */
static WMAP_AREA_DATA *spi_wmaparea_tbl;

/**
 *
 * Memory backing the scripted world map place and area tables.
 *
 */
static mgCMemory *spi_wmapstack;

/**
 *
 * Number of world map areas currently available for travel.
 *
 */
static short MapEnableNum;

void worldmap_analyze(mgCMemory *stack, char *script, int size);

void CWorldMapMenu::SetMsgBuffer() {
    MenuDCMsg[4]->SetMessData(menu_mes_data, menu_mes_data);
    MenuDCMsg[4]->MsgPreset(15);
    MenuDCMsg[4]->fuchi = 5;
    MenuDCMsg[2]->SetMessData(mes_data, menu_mes_data);
    MenuDCMsg[3]->SetMessData(mes_data, menu_mes_data);
    MenuDCMsg[3]->push_button = 0;
    MenuDCMsg[3]->fade_speed = 1.0f;
}

int CWorldMapMenu::KeyStep() {
    int result = WORLD_MOVE_CONTINUE;
    int i = {};
    MenuCommonInfo->CheckSelectKey();
    int lr_key = MenuCommonInfo->CheckLRKey();
    int push = MenuCommonInfo->CheckPushButton();
    MenuCommonInfo->CheckKeyInput();
    CDC2Mes *name_mes = MenuDCMsg[4];
    int      next_step = -1;
    int      close = false;
    CDC2Mes *ask_mes = MenuDCMsg[2];
    CDC2Mes *list_mes = MenuDCMsg[3];

    switch (mode) {
        case WORLD_MAP_MODE_OPEN: {
            int faded = FadeCheckMenu();
            u8  world_move = MenuCommonInfo->open_type == MENU_OPEN_WORLD_MOVE ||
                             MenuCommonInfo->open_type == MENU_OPEN_WORLD_MOVE_B;

            if (ReadBGSync() != 0 || !((world_move && faded) || !world_move)) {
                break;
            }

            dc2::io::FileRead read = dc2::io::FindBackgroundRead(0);

            if (static_cast<bool>(read)) {
                u_char            *map_image = reinterpret_cast<u_char *>(AssetDirectoryRead(reinterpret_cast<u_int *>(read.Bytes().data()), "map.json", nullptr));
                mgCTextureManager *textures = &mgTexManager;
                textures->DeleteBlock(tex_block[0]);
                textures->EnterIMGFile(map_image, tex_block[0], nullptr, nullptr);
                u_char *capture_image = reinterpret_cast<u_char *>(AssetDirectoryRead(reinterpret_cast<u_int *>(read.Bytes().data()), "frametex.json", nullptr));

                if (world_move) {
                    textures->EnterIMGFile(capture_image, tex_block[0], nullptr, nullptr);
                }

                char map_name[0x20];
                std::snprintf(map_name, sizeof(map_name), "wmap0%d", map_type);
                map_tex = textures->GetTexture(map_name, -1);
                mark_tex = textures->GetTexture("wname", -1);
                anim_tex = textures->GetTexture("wmap021", -1);
                pulse_tex = textures->GetTexture("wmap022", -1);

                if (map_type == 4) {
                    anim_tex = textures->GetTexture("wmap04", -1);
                    map_tex = textures->GetTexture("wmap01", -1);
                }

                cursor_tex = textures->GetTexture("mnmain", -1);
                int         message_size = 0;
                const auto *message_bytes = reinterpret_cast<const std::byte *>(
                    AssetDirectoryRead(reinterpret_cast<u_int *>(read.Bytes().data()), "mapname.mes", &message_size));
                mes_data = message_bytes != nullptr && message_size > 0
                               ? dc2::text::MessageTable::Parse({message_bytes, static_cast<std::size_t>(message_size)})
                               : dc2::text::MessageTable{};
                menu_mes_data = GetMenuMainMessageBuffer();
                SetMsgBuffer();
            }

            step = -1;
            next_step = WORLD_MAP_STEP_AREA;
            opened = true;
            area_no = 0;
            cursor_view = true;
            cursor_reset = true;
            cursor_pos[0] = 200.0f;
            cursor_pos[1] = 200.0f;
            name_view = true;
            exit_wait = 0;
            back_alpha = 0.0f;
            WorldMapStack.Align64();
            char        *script = reinterpret_cast<char *>(WorldMapStack.stGetTop());
            unsigned int size = {};
            size = LoadFileMenu("wldmap.cfg.json", dc2::memory::AvailableFrom(WorldMapStack, script), MENU_FILE_LOAD_DIRECT);
            unsigned int blocks = {};

            if (size & 0xF) {
                blocks = (size >> 4) + 1;
            } else {
                blocks = size >> 4;
            }

            WorldMapStack.Alloc(blocks);
            worldmap_analyze(&WorldMapStack, script, size);
            area_no = GetSaveData()->area_no;

            if (MapEnableNum <= 0) {
                cursor_tex = nullptr;
                name_view = false;
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

                if (spi_wmappos_tbl != nullptr) {
                    here_area = spi_wmappos_tbl[pos_no].area_no + 1;
                }

                area_no = here_area;
                name_view = true;
            }

            MenuCommonInfo->key_enable = true;
            FadeInMenu(40, 0.0f);
            mode = WORLD_MAP_MODE_RUN;
            break;
        }
        case WORLD_MAP_MODE_CLOSE:
            if (FadeCheckMenu()) {
                exit_wait++;
                map_tex = nullptr;
                mark_tex = nullptr;
                anim_tex = nullptr;
                pulse_tex = nullptr;
                name_view = false;
                cursor_view = false;
                pos_list_view = false;
                ask_view = false;

                if (MenuCommonInfo->open_type != MENU_OPEN_WORLD_MOVE && exit_wait == 1 && MenuArg.end_code != MENU_END_WORLD_MOVE) {
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

                if (MenuArg.end_code == MENU_END_WORLD_MOVE) {
                    result = WORLD_MOVE_JUMP;
                }

                const auto system_mes = GetSystemMesBuffer();
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
                    close = true;
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }

                break;
            }

            if (menu_debug_flag != 0) {
                if (GamePad__2.Down(PAD_CIRCLE)) {
                    for (int i = 0; i < spi_wmappos_tblnum; i++) {
                        spi_wmappos_tbl[i].enable = true;
                    }

                    for (i = 0; i < spi_wmaparea_tblnum; i++) {
                        spi_wmaparea_tbl[i].enable = true;
                    }

                    MapEnableNum = spi_wmaparea_tblnum - 1;
                    cursor_tex = mgTexManager.GetTexture("mnmain", -1);
                    name_view = true;
                }

                return WORLD_MOVE_CONTINUE;
            }

            switch (step) {
                case WORLD_MAP_STEP_AREA:
                    if (MapEnableNum <= 0 && push != 0) {
                        MenuSePlay(SYSTEM_SE_CANCEL);
                        close = true;
                        break;
                    }

                    if (0 < lr_key) {
                        near_num = 0;
                        float dir[4] = {0.0f, 0.0f, 0.0f, 1.0f};

                        if (lr_key & MENU_SELECT_KEY_UP) {
                            dir[1] -= 1.0f;
                        }

                        if (lr_key & MENU_SELECT_KEY_DOWN) {
                            dir[1] += 1.0f;
                        }

                        if (lr_key & MENU_SELECT_KEY_LEFT) {
                            dir[0] -= 1.0f;
                        }

                        if (lr_key & MENU_SELECT_KEY_RIGHT) {
                            dir[0] += 1.0f;
                        }

                        sceVu0Normalize(dir, dir);
                        WMAP_AREA_DATA *next = nullptr;
                        WMAP_AREA_DATA *now_area = &spi_wmaparea_tbl[area_no];
                        float           now_pos[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                        now_pos[0] = now_area->x;
                        now_pos[1] = now_area->y;

                        for (int i = 0; i < WMAP_NEAR_AREA_MAX; i++) {
                            near_area[i] = nullptr;
                        }

                        for (i = 1; i < spi_wmaparea_tblnum; i++) {
                            near_area[i] = nullptr;
                            WMAP_AREA_DATA *area = &spi_wmaparea_tbl[i];

                            if (area->enable && area_no != area->area_no) {
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
                            bool  swapped = false;
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
                        bool  searching = true;

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

                        if (next == nullptr) {
                            next = now_area;
                        }

                        for (i = 0; i < spi_wmaparea_tblnum; i++) {
                            if (next == &spi_wmaparea_tbl[i]) {
                                area_no = i;
                                break;
                            }
                        }

                        if (next != now_area) {
                            MenuSePlay(SYSTEM_SE_CURSOR);
                        }
                    }

                    switch (push) {
                        case MENU_PUSH_BUTTON_DECIDE:
                            next_step = WORLD_MAP_STEP_POS;
                            select_area = &spi_wmaparea_tbl[area_no];

                            if (select_area == nullptr) {
                                MenuSePlay(SYSTEM_SE_CANCEL);
                                break;
                            }

                            pos_num = 0;

                            for (int i = 0; i < WMAP_AREA_POS_LIST; i++) {
                                WMAP_POS_DATA *pos = select_area->pos[i];

                                if (pos != nullptr && pos->enable) {
                                    pos_icon[pos_num] = pos->type;

                                    if (pos_icon[pos_num] == WMAP_POS_TYPE_GEORAMA) {
                                        pos_icon[pos_num] = 3;
                                    }

                                    pos_num++;
                                }
                            }

                            list_mes->SetMsgCursor(0);
                            MenuSePlay(SYSTEM_SE_DECIDE);
                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            MenuSePlay(SYSTEM_SE_CANCEL);
                            close = true;
                            break;
                    }

                    break;
                case WORLD_MAP_STEP_POS:
                    list_mes->AddMsgCursor2(0, pos_num - 1, 1);

                    switch (push) {
                        case MENU_PUSH_BUTTON_DECIDE:
                        case MENU_PUSH_BUTTON_TRIANGLE: {
                            select_pos = nullptr;
                            int line = 0;

                            for (int i = 0; i < WMAP_AREA_POS_LIST; i++) {
                                WMAP_POS_DATA *pos = select_area->pos[i];

                                if (pos != nullptr && pos->enable) {
                                    if (line == list_mes->GetMsgCursor()) {
                                        select_pos = select_area->pos[i];
                                        break;
                                    }

                                    line++;
                                }
                            }

                            if (select_pos == nullptr) {
                                MenuSePlay(SYSTEM_SE_CANCEL);
                            } else if (select_pos->map_no == MenuMainScene->GetNowMapNo()) {
                                MenuSePlay(SYSTEM_SE_CANCEL);
                            } else {
                                next_step = WORLD_MAP_STEP_ASK;
                                MenuSePlay(SYSTEM_SE_DECIDE);
                            }

                            break;
                        }
                        case MENU_PUSH_BUTTON_CANCEL:
                            next_step = WORLD_MAP_STEP_AREA;
                            MenuSePlay(SYSTEM_SE_CANCEL);
                            break;
                    }

                    break;
                case WORLD_MAP_STEP_ASK: {
                    int answer = ask_mes->YesNoCursor2(1);

                    if (answer == MES_YESNO_YES) {
                        MenuArg.end_code = MENU_END_WORLD_MOVE;
                        WorldMap_NextLoopNo = select_pos->loop_no;
                        WorldMap_MapNo = select_pos->map_no;

                        if (select_pos->loop_no == LOOP_DUNGEON) {
                            WorldMap_MapNo = select_pos->dng_no;

                            if (select_pos->floor < 0) {
                                step++;
                                FadeOutMenu(40, 0.0f);
                            } else {
                                MenuArg.end_code = MENU_END_WORLD_MOVE;
                                close = true;
                                MenuArg.result[0] = WorldMap_NextLoopNo;
                                MenuArg.result[1] = WorldMap_MapNo;
                                MenuArg.result[2] = select_pos->floor;
                            }
                        } else {
                            if (WorldMap_MapNo == SearchMapNo("s12") && CheckBitFlagMenu(SAVE_FLAG_WORLD_MAP_S12_REDIRECT) != 0) {
                                WorldMap_MapNo = SearchMapNo("s34");
                            }

                            if (select_pos->type == WMAP_POS_TYPE_GEORAMA) {
                                /**
                                 *
                                 * Georama map names indexed by world map area.
                                 *
                                 */
                                static char *geo_table[11] = {
                                    "",
                                    "",
                                    "g01",
                                    "g02",
                                    "g03",
                                    "g04",
                                    "",
                                    "g05",
                                    "",
                                    "",
                                    "",
                                };
                                MenuMainScene->SetNowMapNo(SearchMapNo(geo_table[select_pos->area_no]));
                            }

                            MenuArg.result[3] = 0;
                            MenuArg.result[2] = 0;
                            close = true;
                            MenuArg.result[0] = WorldMap_NextLoopNo;
                            MenuArg.result[1] = WorldMap_MapNo;

                            if (MenuMainScene->now_map_no == 0x22 && WorldMap_MapNo == 10) {
                                WorldMap_MapNo = 11;
                                MenuArg.result[1] = 11;
                            }
                        }

                        MenuSePlay(SYSTEM_SE_DECIDE);
                    }

                    if (answer == MES_YESNO_NO) {
                        next_step = WORLD_MAP_STEP_POS;
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    }

                    break;
                }
                case WORLD_MAP_STEP_TREE_MAP:
                    if (FadeCheckMenu()) {
                        TreeMapCalledWorldMap = true;
                        WorldMapMenuType = WORLD_MAP_MENU_TREE_MAP;
                        mgCMemory stack;
                        int       rest = WorldMapStack.stGetRest();
                        stack.stSetBuffer(WorldMapStack.stGetTop(), rest);
                        DngTreeMapInit(&stack, &tex_block[2], 0, select_pos->dng_no);
                    }

                    break;
                case WORLD_MAP_STEP_WAIT:
                    if ((push & MENU_PUSH_BUTTON_DECIDE) || (push & MENU_PUSH_BUTTON_CANCEL)) {
                        ask_view = false;
                        cursor_view = true;
                        step = WORLD_MAP_STEP_AREA;
                        MenuSePlay(SYSTEM_SE_DECIDE);
                    }

                    break;
            }

            break;
    }

    if (0 <= next_step) {
        switch (next_step) {
            case WORLD_MAP_STEP_AREA:
                cursor_view = true;
                pos_list_view = false;
                ask_view = false;
                break;
            case WORLD_MAP_STEP_POS: {
                char *names[WMAP_AREA_POS_LIST];
                int   line = 0;
                cursor_view = false;
                pos_list_view = true;
                ask_view = false;

                for (int i = 0; i < WMAP_AREA_POS_LIST; i++) {
                    if (select_area != nullptr) {
                        WMAP_POS_DATA *pos = select_area->pos[i];

                        if (pos != nullptr && pos->enable && line < pos_num) {
                            names[line++] = pos->name;
                        }
                    }
                }

                list_mes->MsgPreset(10);
                list_mes->SetMsgCursor(0);
                list_mes->cursor_on = true;
                list_mes->ClsMes::mes_no = -1;
                list_mes->cursor_time = 0;
                list_mes->fade_speed = 1.0f;
                list_mes->fade = 1.0f;
                list_mes->SetMsgItemNo(names, pos_num);
                list_mes->MakeMsg(pos_num + 0x45);
                break;
            }
            case WORLD_MAP_STEP_ASK: {
                pos_list_view = false;
                ask_view = true;
                list_mes->cursor_on = false;
                ask_mes->MsgPreset(11);
                ask_mes->SetAbsPos(5);
                char *names[1] = {nullptr};
                names[0] = select_pos->name;
                ask_mes->SetMsgItemNo(names, 1);
                ask_mes->ClsMes::mes_no = -1;
                ask_mes->fade = 0.0f;
                ask_mes->MakeMsg(0x9C6);
                ask_mes->SetMsgCursor(0);
                break;
            }
        }

        step = next_step;
    }

    if (close) {
        MenuCommonInfo->key_enable = false;
        mode = WORLD_MAP_MODE_CLOSE;
        FadeOutMenu(30, 0.0f);
    }

    return result;
}

static inline void WorldMapCursorDraw(mgCTexture *texture, float *position, float rotation, int alpha) {
    MenuCursorDraw(texture, position, rotation, 0, alpha, 1.0f);
}

void CWorldMapMenu::Draw() {
    mgCDrawPrim *prim = GetMenuPrim();
    int          loaded_tex = -1;

    if (capture_view == 1 && capture_tex != nullptr) {
        MenuReloadTexture(loaded_tex, capture_tex->block);
        PrimQuad(capture_tex, mgRect<int>(0, 0, mgScreenWidth, mgScreenHeight), mgRect<int>(0, 0, mgScreenWidth >> 1, mgScreenHeight >> 1), 0x80, 0x80, 0x80, 0x80);
    }

    DrawMenuFillBox(static_cast<int>(back_alpha), 0, 0, 0);
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);

    if (map_tex != nullptr) {
        mgRect<int> map_source(0, 0, 0x200, 0x16E);
        mgRect<int> map_dest(0, 0, 0x200, 0x1E0);
        MenuReloadTexture(loaded_tex, map_tex->block);
        PrimQuad(prim, map_tex, map_dest, map_source, 0x80, 0x80, 0x80, 0x80);

        if (map_type == 2 && anim_tex != nullptr && pulse_tex != nullptr) {
            SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
            prim->Begin(MG_PRIM_SPRITE);
            prim->Texture(anim_tex);
            prim->Color(0, 0, 0, 0x5E);

            for (int i = 0; i < 0xFF; i++) {
                int x = static_cast<int>(250.0f + 8.0f * sinf(wave_x[i]));
                prim->TextureCrd(0, i);
                prim->Vertex(x, i, 0);
                prim->TextureCrd(0xFE, i + 1);
                prim->Vertex(0x1FF, i + 1, 0);
                wave_x[i] = mgAngleLimit(0.034906585f + wave_x[i]);
            }

            for (int i = 0; i < 0xFF; i++) {
                int y = static_cast<int>(253.0f + 8.0f * sinf(wave_y[i]));
                prim->TextureCrd(i, 0);
                prim->Vertex(i + 0xFF, 0, 0);
                prim->TextureCrd(i + 1, 0xDC);
                prim->Vertex(i + 0x100, y, 0);
                wave_y[i] = mgAngleLimit(wave_y[i] - 0.05235988f);
            }

            prim->End();
            SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
            prim->Begin(MG_PRIM_SPRITE);
            prim->Texture(anim_tex);
            prim->Color(0x80, 0x80, 0x80, 0x80);
            prim->TextureCrd(0, 0);
            prim->Vertex(0x100, 0, 0);
            prim->TextureCrd(0x100, 0x100);
            prim->Vertex(0x200, 0x126, 0);
            prim->End();
            SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
            float pulse_color[2][4] = {
                {230.0f, 0.0f, 0.0f,   0.0f},
                {0.0f,   0.0f, 230.0f, 0.0f}
            };
            pulse_color[0][3] = 196.0f + 48.0f * sinf(pulse_angle[0]);
            pulse_color[1][3] = 196.0f + 48.0f * sinf(pulse_angle[1]);
            float pulse_speed[2] = {0.07853982f, 0.06283185307f};
            int   shift = 0;
            prim->Begin(MG_PRIM_SPRITE);
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

        if (map_type == 4 && anim_tex != nullptr) {
            float island_y = 89.7f + 6.0f * sinf(float_angle);
            float shadow_y = 14.0f + (156.4f + 1.5f * sinf(float_angle));
            prim->Bilinear(1);
            prim->Begin(MG_PRIM_SPRITE);
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

    if (mark_tex != nullptr) {
        mgRect<int> title_rect(-0x1C, -0xE, 0x100, 0x60);
        mgRect<int> title_source(0, 0, 0x100, 0x60);
        prim->Bilinear(1);
        prim->Begin(MG_PRIM_SPRITE);
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

        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(mark_tex);
        prim->Color(0x80, 0x80, 0x80, 0x80);

        for (int i = 1; i < spi_wmaparea_tblnum; i++) {
            WMAP_AREA_DATA *area = &spi_wmaparea_tbl[i];

            if ((0 < here_area && here_area == area->area_no) || (here_area < 0 && area->enable)) {
                PrimQuad(prim, mgRect<int>(area->x - 10, area->y - 15, 0x14, 0x1E), mark_source);
            }
        }

        prim->End();
    }

    CDC2Mes        *name_mes = MenuDCMsg[4];
    WMAP_AREA_DATA *now_area = &spi_wmaparea_tbl[area_no];
    CDC2Mes        *ask_mes = MenuDCMsg[2];
    CDC2Mes        *list_mes = MenuDCMsg[3];

    if (name_view) {
        char *name[3];

        for (int i = 0; i < spi_wmaparea_tblnum; i++) {
            if (area_no == i) {
                name[0] = spi_wmaparea_tbl[i].name;
                break;
            }
        }

        name_mes->SetMsgItemNo(name, 1);
        name_mes->MakeMsg(0x32);
        name_mes->StepMsg();

        if (now_area != nullptr) {
            int x = 0;
            int y = 0;

            if (now_area->name_side == WMAP_NAME_SIDE_RIGHT) {
                x = now_area->name_x + 0x1E;
                y = now_area->name_y;
            }

            if (now_area->name_side == WMAP_NAME_SIDE_LEFT) {
                x = now_area->name_x - name_mes->line_w[0] - 0x30;
                y = now_area->name_y;
            }

            name_mes->SetMovePosGyou(0, x, y);
        }

        name_mes->line_pos[0][0] -= 10;
        name_mes->line_pos[0][1] -= 15;
        MenuReloadTexture(loaded_tex, map_tex->block);
        int frame_x = name_mes->line_pos[0][0] - 0x10;
        int frame_y = name_mes->line_pos[0][1] - 0xC;
        int frame_step[4] = {0x1E, 0, 0x1E, 0};
        frame_step[1] = name_mes->line_w[0] - 0x1E;
        int         shadow_u = 0;
        mgRect<int> frame(frame_x, frame_y, 0x1E, 0x2E);
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(mark_tex);

        for (int i = 0; i < 3; i++) {
            prim->Color(0, 0, 0, 0x2E);
            PrimQuad(prim, mgRect<int>(frame.left + 4, frame.top + 4, frame.right, frame.bottom), mgRect<int>(shadow_u, 0x60, 0x1E, 0x32));
            prim->Color(0x80, 0x80, 0x80, 0x80);
            PrimQuad(prim, frame, mgRect<int>(shadow_u, 0x60, 0x1E, 0x32));
            frame.left += frame_step[i];
            frame.right = frame_step[i + 1];
            shadow_u += 0x1E;
        }

        prim->End();
        MenuReloadTexture(loaded_tex, list_mes->texture_block);
        name_mes->StepMsg();
        name_mes->DrawMsg();
    }

    if (pos_list_view) {
        float area_x = 0.0f;
        float area_y = 0.0f;

        if (now_area != nullptr) {
            area_x = now_area->name_x;
            area_y = now_area->name_y;
        }

        list_mes->StepMsg();
        int put_pos[2] = {static_cast<int>(60.0f + area_x), static_cast<int>(area_y)};
        int max_w = 0;
        int total_h = 0;

        for (int i = 0; select_area->pos[i] != nullptr; i++) {
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
        float icon_x = 24.0f + put_pos[0];
        float icon_y = 25.0f + put_pos[1];
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        prim->Begin(MG_PRIM_SPRITE);
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

    if (ask_view) {
        MenuReloadTexture(loaded_tex, ask_mes->texture_block);
        ask_mes->StepMsg();
        ask_mes->DrawMsg();
    }

    if (cursor_tex != nullptr && cursor_view) {
        float target_y = now_area->y - 0xF;
        CalcMenu1(static_cast<float>(now_area->x - 0x32), &cursor_pos[0], 4.0f, 0.0f, cursor_reset);
        CalcMenu1(target_y, &cursor_pos[1], 4.0f, 0.0f, cursor_reset);
        cursor_reset = false;
        MenuReloadTexture(loaded_tex, cursor_tex->block);
        WorldMapCursorDraw(cursor_tex, cursor_pos, 0.0f, 0x80);
    }

    if (menu_debug_flag != 0) {
        int   debug_tex = -1;
        float box_h = 40.0f;
        MenuReloadTexture(debug_tex, MenuArg.mes_tex_block);
        DrawMenuFillBox(300.0f, 10.0f, 220.0f, box_h, 0x40, 0, 0, 0);
        CMenuFont font;
        font.SetStr("(O):Open All Area");
        font.SetPos(0x136, 0xC);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
    }
}

inline CWorldMapMenu::CWorldMapMenu() {
    int i = {};

    memset(unk_118, 0, sizeof(unk_118));
    area_no = 0;
    capture_view = false;
    name_view = false;
    pos_list_view = false;
    cursor_reset = false;
    cursor_view = false;
    ask_view = false;
    select_area = nullptr;
    select_pos = nullptr;
    here_area = -1;
    view_only = false;
    exit_wait = 0;
    back_alpha = 128.0f;
    blink_cnt = 0;
    cursor_tex = nullptr;
    wave_x[0] = 0.0f;
    wave_y[0] = 0.0f;

    for (i = 0; i < WMAP_WAVE_LINE_NUM - 1; i++) {
        wave_x[i + 1] = mgAngleLimit(0.1308997f + wave_x[i]);
        wave_y[i + 1] = mgAngleLimit(0.10471976f + wave_y[i]);
    }

    float_angle = 0.0f;
    pulse_angle[0] = 0.0f;
    pulse_angle[1] = 0.0f;
    capture_tex = nullptr;
    map_tex = nullptr;
    mark_tex = nullptr;
    anim_tex = nullptr;
    pulse_tex = nullptr;
    map_type = 1;
    mes_data = nullptr;
    menu_mes_data = nullptr;

    for (i = 0; i < WMAP_AREA_POS_MAX; i++) {
        pos_icon[i] = 0;
    }

    spi_wmaparea_tblnum = 0;
    spi_wmaparea_tbl = nullptr;
    spi_wmappos_tblnum = 0;
    spi_wmappos_tbl = nullptr;
    WorldMap_MapNo = -1;
    WorldMap_NextLoopNo = -1;
    WorldMap_DngFloor = -1;
}

int WorldMoveInit(mgCMemory *stack, int *tex_block, int open_type) {
    char         path[0x20];
    u_long128   *buffer = {};
    unsigned int size = {};
    unsigned int blocks = {};

    int        available = stack->stGetRest();
    u_long128 *top = stack->stGetTop();
    WorldMapStack.stSetBuffer(top, available);
    WorldMapPtr = new (WorldMapStack.Alloc((sizeof(CWorldMapMenu) + 15) / 16 + 2)) CWorldMapMenu;
    WorldMapStack.Align64();
    WorldMapPtr->SetTexBlock(tex_block);
    WorldMapPtr->FadeOutMenu(40, 0.0f);
    WorldMapMenuType = WORLD_MAP_MENU_WORLD;
    GetMapType(GetMainScene()->now_map_no);

    if (MenuCommonInfo->open_type == MENU_OPEN_WORLD_MOVE) {
        WorldMapPtr->back_alpha = 0.0f;
    }

    WorldMapPtr->capture_tex = mgTexManager.GetTexture("menuwork2", -1);
    buffer = WorldMapStack.stGetTop();

    if (CheckBitFlagMenu(SAVE_FLAG_WORLD_MAP_2) != 0) {
        WorldMapPtr->map_type = 2;
    }

    if (CheckBitFlagMenu(SAVE_FLAG_WORLD_MAP_4) != 0) {
        WorldMapPtr->map_type = 4;
    }

    if (CheckBitFlagMenu(SAVE_FLAG_WORLD_MAP_3) != 0) {
        WorldMapPtr->map_type = 3;
    }

    StartReadBG();
    std::snprintf(path, sizeof(path), "wmap%d.pac", WorldMapPtr->map_type);
    size = LoadFileMenu(path, dc2::memory::AvailableFrom(WorldMapStack, buffer), MENU_FILE_LOAD_BG);

    if (size & 0xF) {
        blocks = (size >> 4) + 1;
    } else {
        blocks = size >> 4;
    }

    WorldMapStack.Alloc(blocks);
    return 1;
}

int WorldMoveKey() {
    if (WorldMapMenuType == WORLD_MAP_MENU_WORLD) {
        return WorldMapPtr->KeyStep();
    }

    if (WorldMapMenuType == WORLD_MAP_MENU_TREE_MAP) {
        int result = DngTreeMapKey();

        if (result == DNG_TREE_MAP_CLOSE) {
            MenuArg.end_code = MENU_END_NONE;
            MenuArg.result[0] = 0;
            TreeMapCalledWorldMap = false;
            MenuArg.result[1] = 0;
            WorldMapMenuType = WORLD_MAP_MENU_WORLD;
            WorldMapPtr->step = WORLD_MAP_STEP_AREA;
            WorldMapPtr->cursor_view = true;
            WorldMapPtr->FadeInMenu(40, 0.0f);
            WorldMapPtr->SetMsgBuffer();
            return WORLD_MOVE_CONTINUE;
        }

        if (result == DNG_TREE_MAP_JUMP) {
            MenuArg.end_code = MENU_END_WORLD_MOVE;
            TreeMapCalledWorldMap = false;
            MenuArg.result[0] = WorldMap_NextLoopNo;
            MenuArg.result[1] = WorldMap_MapNo;
            MakeDngTreeMapJumpNo(WorldMap_MapNo, MenuArg.result[2], &MenuArg.result[0],
                                 &MenuArg.result[1]);
            MenuArg.result[3] = 0;
            return WORLD_MOVE_JUMP;
        }
    }

    return WORLD_MOVE_CONTINUE;
}

void WorldMoveDraw() {
    if (WorldMapMenuType == WORLD_MAP_MENU_WORLD) {
        WorldMapPtr->Draw();
    }

    if (WorldMapMenuType == WORLD_MAP_MENU_TREE_MAP) {
        DngTreeMapDraw();
    }
}

void SphidaScreListUpdate(CDC2Mes *mes, int update) {
    int                 top = {};
    int                 line = {};
    SPHIDA_PLAYER_DATA *player = {};

    if (mes == nullptr || SubSphidaData == nullptr) {
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

            if (player != nullptr) {
                if (player->name[0] == 0 && player->name[1] == 0) {
                    char *unregistered = Mitouroku[LanguageCode];

                    if (unregistered != nullptr) {
                        dc2::text::Copy(mes->name[line], dc2::text::View(unregistered));
                    }
                } else if (player != nullptr) {
                    dc2::text::Copy(mes->name[line], dc2::text::View(player->name));
                }

                top++;
            }
        }

        mes->ClsMes::mes_no = -1;
        mes->MakeMsg(0x13EE);
    }
}

void SphidaMenuInit(mgCMemory *stack, int *tex_block, int open_type) {
    int        available = stack->stGetRest();
    u_long128 *top = stack->stGetTop();
    SphidaStack.stSetBuffer(top, available);

    for (int i = 0; i < 16; i++) {
        SphidaMenuTexbk[i] = tex_block[i];
    }

    SphidaMenuTexbk[15] = -1;
    MenuMainScene->fade.FadeIn(40);
    SubSaveData__2 = GetSubGameSaveData();
    SubSphidaData = nullptr;

    if (SubSaveData__2 != nullptr) {
        SubSphidaData = SubSaveData__2->GetSphidaData();
        SphidaMenuMes = new (SphidaStack.Alloc((sizeof(CDC2Mes) + 15) / 16 + 2)) CDC2Mes;
        SphidaMenuMes->SetMessData(GetSystemMesBuffer(), GetMenuMainMessageBuffer());
        SphidaMenuMes->MsgPreset(0x12);
        SphidaMenuMes->SetPutPos(0x100, 0x34, -1, -1);
        SphidaMenuMes->MakeMsg(0x13EC);
        SphidaMenuMes->SetMsgCursor(0);
        SphidaMenuQus = new (SphidaStack.Alloc((sizeof(CDC2Mes) + 15) / 16 + 2)) CDC2Mes;
        SphidaMenuQus->SetMessData(GetSystemMesBuffer(), GetMenuMainMessageBuffer());
        SphidaMenuQus->MsgPreset(0x12);
        SphidaMenuQus->MakeMsg(0x13F1);
        SphidaMenuQusDrawFlag = false;
        SphidaScore = new (SphidaStack.Alloc((sizeof(CDC2Mes) + 15) / 16 + 2)) CDC2Mes;
        SphidaScore->SetMessData(GetSystemMesBuffer(), GetMenuMainMessageBuffer());
        SphidaScore->MsgPreset(0x10);
        SphidaScore->SetPutPos(0x16, 0x14, -1, -1);
        SphidaScore->MakeMsg(0x13EE);
        SphidaSelect[0] = 0;
        SphidaInfoMsgDrawFlag = false;
        SphidaSelect[1] = 0;
        SfidaMakeLine = 0;
        MenuBGTextureBlock = SphidaMenuTexbk[0];
        SfidaMoveInitFlag = false;
        MenuCapture(MenuBGTextureBlock, &SphidaStack, 1);
        MenuPosData->AttachCommonTexInfo();
        MenuCommonInfo->key_enable = true;
        u_long128   *buffer = SphidaStack.stGetTop();
        unsigned int size = LoadFileMenu("textures/omake.json", dc2::memory::AvailableFrom(SphidaStack, buffer), MENU_FILE_LOAD_DIRECT);
        unsigned int blocks = {};

        if (size & 15) {
            blocks = (size >> 4) + 1;
        } else {
            blocks = size >> 4;
        }

        SphidaStack.Alloc(blocks);
        mgTexManager.EnterIMGFile(reinterpret_cast<u8 *>(buffer), SphidaMenuTexbk[1], nullptr, nullptr);
        SphidaTex = mgTexManager.GetTexture("omaketx", -1);
        mgTexManager.EnterIMGFile(GetMenuMainIMGPtr(), SphidaMenuTexbk[1], nullptr, nullptr);
        SphidaCursor = mgTexManager.GetTexture("mnmain", -1);
        SphidaCursorY = 300.0f;
        SphidaCursorDrawFlag = false;
        SphidaCursorCount = 0;
        SphidaTex2 = mgTexManager.GetTexture("mnbg", -1);
        SphidaTex_Sys = mgTexManager.GetTexture("omake_sfida", -1);
        SphidaMenuPhase = SPHIDA_MENU_TOP;
        SubSphidaData->InitPlay();
        SphidaScreListUpdate(SphidaScore, true);
    }
}

int OmakeSfidaSelect(int key) {
    int movement = MenuListSelectKeyCheck(key, 8);
    int distance = abs(movement);

    if (distance > 2) {
        SfidaMoveInitFlag = true;
    }

    return movement;
}

int SphidaMenuKey() {
    int select_key = MenuCommonInfo->CheckSelectKey() | MenuCommonInfo->CheckLRKey();
    int push_button = MenuCommonInfo->CheckPushButton();

    if (SubSphidaData == nullptr) {
        return 1;
    }

    int      list_changed = false;
    int      old_top = SphidaSelect[1];
    CDC2Mes *question = SphidaMenuQus;

    switch (SphidaMenuPhase) {
        case SPHIDA_MENU_TOP: {
            int choice = {};

            if (LanguageCode == LANG_JAPANESE) {
                choice = SphidaMenuMes->AddMsgCursor2(0, 3, 1);
            } else {
                choice = SphidaMenuMes->AddMsgCursor2(0, 2, 1);
            }

            if (push_button & MENU_PUSH_BUTTON_DECIDE) {
                int command = choice;

                if (LanguageCode != LANG_JAPANESE) {
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
                        MenuSePlay(SYSTEM_SE_DECIDE);
                        break;
                    case 1:
                        SphidaCursorDrawFlag = true;
                        SphidaMenuPhase = SPHIDA_MENU_PASSWORD;
                        SphidaMenuMes->cursor_on = false;
                        MenuSePlay(SYSTEM_SE_DECIDE);
                        break;
                    case 2:
                        SphidaCursorDrawFlag = true;
                        SphidaMenuMes->cursor_on = false;
                        SphidaMenuPhase = SPHIDA_MENU_CLEAR;
                        MenuSePlay(SYSTEM_SE_DECIDE);
                        break;
                    case 3:
                        SphidaMenuQusDrawFlag = true;
                        question->MsgPreset(0xB);
                        question->SetAbsPos(5);
                        question->MakeMsg(0xC58);
                        question->SetMsgCursor(1);
                        SphidaMenuMes->cursor_on = false;
                        SphidaMenuPhase = SPHIDA_MENU_QUIT_ASK;
                        MenuSePlay(SYSTEM_SE_DECIDE);
                        break;
                }
            } else if (DebugFlag != 0 && menu_debug_flag != 0 && (push_button & MENU_PUSH_BUTTON_SQUARE)) {
                SubSphidaData->Initialize();
                list_changed = true;
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
                    dc2::text::Copy(SubSphidaData->player_name, dc2::text::View(Nameregi_Target.keyword));
                    MenuArg.end_code = MENU_END_SPHIDA_START;
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
            if (MenuKeySelectCheck(OmakeSfidaSelect(select_key), &SphidaSelect[0], &SphidaSelect[1], 0, SPHIDA_PLAYER_MAX, 8, MENU_CURSOR_LIMIT_CLAMP) != 0) {
                MenuSePlay(SYSTEM_SE_CURSOR);
                int new_top = SphidaSelect[1];

                if (old_top != new_top) {
                    SfidaMakeLine = old_top < new_top ? 1 : 0;
                    list_changed = true;
                }
            }

            if (push_button & MENU_PUSH_BUTTON_DECIDE) {
                SPHIDA_PLAYER_DATA *player = SubSphidaData->GetPlayerData(SphidaSelect[0]);

                if (player == nullptr || player->name[0] == 0) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                } else {
                    std::array<char, 0x88> password_sjis{};
                    const auto             encoded = dc2::password::EncodeSphedaScore(
                        player->hole_score, static_cast<std::uint32_t>(player->password_key), dc2::text::View(player->name));

                    if (!encoded) {
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    } else {
                        ConvertAscii2ShitJiss(std::span<const char>(*encoded), password_sjis);
                        MenuSePlay(SYSTEM_SE_DECIDE);
                        SphidaMenuQusDrawFlag = true;
                        SphidaCursorDrawFlag = false;
                        question->MsgPreset(0x12);
                        question->SetAbsPos(5);
                        question->MakeMsg(0x13F0);

                        if (player != nullptr) {
                            dc2::text::Copy(question->name[0], dc2::text::View(player->name));
                        }

                        dc2::text::Copy(question->name[2], dc2::text::View(password_sjis));

                        if (LanguageCode == LANG_JAPANESE) {
                            SphidaInfoMsgDrawFlag = true;
                            MenuDCMsg[2]->MsgPreset(0x12);
                            MenuDCMsg[2]->SetAbsPos(8);
                            MenuDCMsg[2]->MakeMsg(0x13F2);
                        }

                        SphidaMenuPhase = SPHIDA_MENU_PASSWORD_VIEW;
                    }
                }
            } else if (push_button & MENU_PUSH_BUTTON_CANCEL) {
                SphidaMenuPhase = SPHIDA_MENU_TOP;
                SphidaCursorDrawFlag = false;
                SphidaMenuQusDrawFlag = false;
                SphidaMenuMes->cursor_on = true;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }

            break;
        }
        case SPHIDA_MENU_PASSWORD_VIEW:
            if (push_button != 0) {
                SphidaCursorDrawFlag = true;
                SphidaMenuQusDrawFlag = false;
                SphidaMenuPhase = SPHIDA_MENU_PASSWORD;
                SphidaInfoMsgDrawFlag = false;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }

            break;
        case SPHIDA_MENU_CLEAR: {
            if (MenuKeySelectCheck(OmakeSfidaSelect(select_key), &SphidaSelect[0], &SphidaSelect[1], 0, SPHIDA_PLAYER_MAX, 8, MENU_CURSOR_LIMIT_CLAMP) != 0) {
                MenuSePlay(SYSTEM_SE_CURSOR);
                int new_top = SphidaSelect[1];

                if (old_top != new_top) {
                    SfidaMakeLine = old_top < new_top ? 1 : 0;
                    list_changed = true;
                }
            }

            if (push_button & MENU_PUSH_BUTTON_DECIDE) {
                SPHIDA_PLAYER_DATA *player = SubSphidaData->GetPlayerData(SphidaSelect[0]);

                if (player == nullptr || player->name[0] == 0) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                } else {
                    question->MsgPreset(0xB);
                    question->SetAbsPos(5);
                    question->MakeMsg(0x13F1);
                    char *clear_names[2] = {nullptr, nullptr};
                    clear_names[0] = player->name;
                    question->SetMsgItemNo(clear_names, 1);
                    question->SetMsgCursor(1);
                    SphidaMenuQusDrawFlag = true;
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    SphidaMenuPhase = SPHIDA_MENU_CLEAR_ASK;
                }
            } else if (push_button & MENU_PUSH_BUTTON_CANCEL) {
                SphidaMenuPhase = SPHIDA_MENU_TOP;
                SphidaCursorDrawFlag = false;
                SphidaMenuQusDrawFlag = false;
                SphidaMenuMes->cursor_on = true;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }

            break;
        }
        case SPHIDA_MENU_CLEAR_ASK: {
            int answer = question->YesNoCursor2(0);

            if (answer == MES_YESNO_YES) {
                MenuSePlay(SYSTEM_SE_DECIDE);
                SubSphidaData->ClearPlayerScore(SphidaSelect[0]);
                SphidaMenuQusDrawFlag = false;
                SphidaMenuPhase = SPHIDA_MENU_CLEAR;
                list_changed = true;
            }

            if (answer == MES_YESNO_NO) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                SphidaMenuQusDrawFlag = false;
                SphidaMenuPhase = SPHIDA_MENU_CLEAR;
            }

            break;
        }
        case SPHIDA_MENU_QUIT_ASK: {
            int answer = question->YesNoCursor2(0);

            if (answer == MES_YESNO_YES) {
                MenuArg.result[0] = 0x14;
                SphidaMenuQusDrawFlag = false;
                MenuMainScene->fade.FadeOut(30, 0.0f, 0.0f, 0.0f);
                SphidaMenuPhase = SPHIDA_MENU_EXIT;
                MenuSePlay(SYSTEM_SE_DECIDE);
            }

            if (answer == MES_YESNO_NO) {
                SphidaMenuPhase = SPHIDA_MENU_TOP;
                SphidaMenuQusDrawFlag = false;
                SphidaMenuMes->cursor_on = true;
                MenuSePlay(SYSTEM_SE_CANCEL);
            }

            break;
        }
    }

    SphidaScreListUpdate(SphidaScore, list_changed);
    SfidaBGXY += 0.5f;

    if (0.0f <= SfidaBGXY) {
        SfidaBGXY -= 256.0f;
    }

    question->StepMsg();
    SphidaMenuMes->StepMsg();
    SphidaScore->StepMsg();
    MenuDCMsg[2]->StepMsg();
    return 0;
}

/**
 *
 * Vertical position of the Spheda score list.
 *
 */
static float SphidaScoreListY;

/**
 *
 * Vertical position of the Spheda score-list highlight.
 *
 */
static float SphidaScoreListBarY;

void SphidaMenuDraw() {
    int         list_rect[4];
    mgRect<int> clip;
    float       divisor = 4.0f;
    float       snap = 3.5f;

    if (SphidaMenuPhase == SPHIDA_MENU_NAME_REGIST) {
        NameRegistDraw();
        return;
    }

    if (SubSphidaData == nullptr) {
        return;
    }

    CalcMenu1(static_cast<float>(SphidaSelect[1] * -0x18), &SphidaScoreListY, divisor, snap, SfidaMoveInitFlag);
    mgCTextureManager *textures = &mgTexManager;
    mgCDrawPrim       *prim = GetMenuPrim();

    if (SphidaTex2 != nullptr) {
        textures->ReloadTexture(SphidaTex2->block, (sceVif1Packet *) nullptr);
        DrawMenuTilePattern(prim, SphidaTex2, SfidaBGXY, SfidaBGXY, mgRect<int>(0x100, 0x100, 0x100, 0x100), 0, nullptr);
    }

    SPHIDA_PLAYER_DATA *player = SubSphidaData->GetPlayerData(0);
    clip.Set(0, 0, 0, 0);

    if (SphidaTex != nullptr) {
        textures->ReloadTexture(SphidaTex->block, (sceVif1Packet *) nullptr);

        if (LanguageCode == LANG_JAPANESE) {
            DrawSubGameTitle(SphidaTex, 1, 0x1E, 0x1E, 0xCA);
        } else {
            DrawSubGameTitle(SphidaTex, 1, 0x18, 0x1A, 0xDE);
        }

        PrimQuad(prim, SphidaTex, 45.0f, 41.0f, mgRect<int>(0, 0xB6, 0xB4, 0x1C), 0x80, 0x80, 0x80, 0x80);

        if (LanguageCode == LANG_JAPANESE) {
            float label_x = 118.0f;
            DrawSubGameTitle(SphidaTex, 0, 0x5A, mgScreenHeight - 0x13E, 0x66);
            PrimQuad(prim, SphidaTex, label_x, mgScreenHeight - 0x133, mgRect<int>(0x6C, 0x9E, 0x30, 0x18), 0x80, 0x80, 0x80, 0x80);
        } else {
            float label_x = {};
            label_x = 98.0f;
            DrawSubGameTitle(SphidaTex, 0, 0x46, mgScreenHeight - 0x13E, 0x86);
            PrimQuad(prim, SphidaTex, label_x, mgScreenHeight - 0x133, mgRect<int>(0, 0x5C, 0x50, 0x18), 0x80, 0x80, 0x80, 0x80);
        }

        list_rect[2] = 0x15E;
        list_rect[3] = 0xE0;
        list_rect[0] = (mgScreenWidth - list_rect[2]) >> 1;
        list_rect[1] = mgScreenHeight - 0x104;
        int   scroll[2];
        float bar_h = 25.75f;
        scroll[1] = static_cast<int>(bar_h);
        CalcMenu1(3.21875f * static_cast<float>(SphidaSelect[1]), &SphidaScoreListBarY, 3.0f, 0.0f, SfidaMoveInitFlag);
        scroll[0] = fptosi(SphidaScoreListBarY);
        DrawSubGameScrlList(SphidaTex, list_rect, scroll);
        clip.Set(list_rect[0] + 4, list_rect[1] + 0xE, list_rect[0] + list_rect[2], list_rect[1] + list_rect[3] - 0x10);
        SetMenuScissor(clip);
        int line_x = list_rect[0] + 0x16;
        int y = fptosi(static_cast<float>(list_rect[1] + 0x22) + SphidaScoreListY);

        for (int rank = 0; rank < SPHIDA_PLAYER_MAX; rank++, y += 0x18, player++) {
            mgRect<int> digits(0, 0xEC, 0x12, 0x14);
            SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
            prim->Begin(MG_PRIM_SPRITE);
            prim->Texture(SphidaTex);
            prim->Color(0x80, 0x80, 0x80, 0x80);
            PrimDrawNumber(prim, rank + 1, MENU_NUMBER_ALIGN_CENTER, list_rect[0] + 0x32, y - 0x14, digits, -2, 0);
            int suffix_x = list_rect[0] + 0x32 + (GetNumberKeta(rank + 1) - 1) * 9;
            PrimQuad(prim, suffix_x, y - 0x14, mgRect<int>(0xC6, 0xEC, 0x12, 0x14));

            if (player->name[0] == 0 && player->name[1] == 0) {
                PrimQuad(prim, list_rect[0] + 0xD2, y - 0x14, mgRect<int>(0xB4, 0xEC, 0x12, 0x14));
            } else {
                PrimDrawNumber(prim, player->total_score, MENU_NUMBER_ALIGN_CENTER, list_rect[0] + 0xFC, y - 0x14, digits, -2, 0);
                float unit_x = 260.0f + list_rect[0];

                if (CheckNowEurope()) {
                    unit_x = 264.0f + list_rect[0];
                }

                PrimQuad(prim, unit_x, static_cast<float>(y) - 20.0f, mgRect<int>(0x4A, 0x88, 0x34, 0x16));
            }

            prim->End();
            DrawSubGameUnderLine(SphidaTex, line_x, y, list_rect[2] - 0x34);
        }

        ResetMenuScissor();
    }

    if (SphidaCursorDrawFlag && SphidaCursor != nullptr) {
        textures->ReloadTexture(SphidaCursor->block, (sceVif1Packet *) nullptr);
        float cursor_div = 4.0f;
        float cursor_snap = 3.2f;
        CalcMenu1(static_cast<float>(list_rect[1] + 0xD + (SphidaSelect[0] - SphidaSelect[1]) * 0x18), &SphidaCursorY, cursor_div, cursor_snap, 0);
        SphidaCursorCount++;

        if (SphidaCursorCount > 60000000) {
            SphidaCursorCount = 0;
        }

        float cursor_x = static_cast<float>(list_rect[0] - 0xC) + 8.0f * cosf(mgAngleLimit(0.05235988f * SphidaCursorCount));
        PrimQuad(prim, SphidaCursor, cursor_x, SphidaCursorY + 4.0f * sinf(mgAngleLimit(0.10471976f * SphidaCursorCount)),
                 menu_long_hand, 0x80, 0x80, 0x80, 0x80);
    }

    textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) nullptr);
    SphidaMenuMes->DrawMsg();

    if (SphidaScore != nullptr) {
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

        float line_y = static_cast<float>(list_rect[1] + 0x22) + SphidaScoreListY - 20.0f;
        float offset = 24.0f * top;
        line_y = line_y + offset;
        int line_x = list_rect[0] + 0x30;

        if (LanguageCode > LANG_JAPANESE) {
            line_x = list_rect[0] + 0x3A;
        }

        for (int line = 0; line < 9; line_y += 24.0f, line++) {
            SphidaScore->SetMovePosGyou(line, line_x, static_cast<int>(line_y));
        }

        SphidaScore->DrawMsg();
        ResetMenuScissor();
    }

    if (SphidaInfoMsgDrawFlag && MenuDCMsg[2] != nullptr) {
        MenuDCMsg[2]->DrawMsg();
    }

    if (SphidaMenuQusDrawFlag && SphidaMenuQus != nullptr) {
        SphidaMenuQus->DrawMsg();
    }

    if (menu_debug_flag) {
        CMenuFont font;
        font.DrawDirect("(A):Set Data(test)", 0x14, 0x50);
        font.DrawDirect("(#):Initialize ", 0x14, 0x64);
    }

    SfidaMoveInitFlag = false;
}

void SphidaScoreViewInit(mgCMemory *memory, int *tex_block, int open_type) {
    int        available = memory->stGetRest();
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
    SubSphidaData = nullptr;

    if (SubSaveData__2 != nullptr) {
        SubSphidaData = SubSaveData__2->GetSphidaData();
        SphidaStack.Align64();
        u_long128   *buffer = SphidaStack.stGetTop();
        unsigned int size = LoadFileMenu("textures/omake.json", dc2::memory::AvailableFrom(SphidaStack, buffer), MENU_FILE_LOAD_DIRECT);
        unsigned int blocks = {};

        if (size & 15) {
            blocks = (size >> 4) + 1;
        } else {
            blocks = size >> 4;
        }

        SphidaStack.Alloc(blocks);
        mgTexManager.EnterIMGFile(reinterpret_cast<u8 *>(buffer), SphidaMenuTexbk[1], nullptr, nullptr);
        SphidaTex = mgTexManager.GetTexture("omaketx", -1);
        SphidaTex_Sys = mgTexManager.GetTexture("omake_sfida", -1);
        MenuCommonInfo->key_enable = true;
        Sfida_NowPlayHorlBlink = 0;
    }
}

int SphidaScoreViewKey() {
    if (MenuCommonInfo->CheckPushButton()) {
        MenuSePlay(SYSTEM_SE_DECIDE);
        return 1;
    }

    Sfida_NowPlayHorlBlink++;

    if (Sfida_NowPlayHorlBlink > PAL_TIMING(0x32, 0x3c)) {
        Sfida_NowPlayHorlBlink = 0;
    }

    return 0;
}

void SphidaScoreViewDraw() {
    mgCTextureManager *textures = &mgTexManager;
    mgRect<int>        hole_digits;
    mgRect<int>        score_digits;
    mgRect<int>        number_digits;
    mgRect<int>        dest;
    mgRect<int>        source;
    mgRect<int>        dest_edge;
    mgRect<int>        source_edge;
    mgRect<int>        label_left;
    mgRect<int>        label_right;
    mgRect<int>        label_wide;
    mgRect<int>        title;
    mgRect<int>        hole_label;
    mgRect<int>        par_label;
    mgRect<int>        score_label;
    mgCDrawPrim       *prim = {};
    int                hole_no = {};
    int                row_y = {};
    int                row = {};
    int                loaded_tex_no = {};
    int                number_y = {};
    int                label_y = {};

    textures->ReloadTexture(SphidaMenuTexbk[0], (sceVif1Packet *) nullptr);
    loaded_tex_no = -1;
    source.Set(0, 0, mgScreenWidth / 2, mgScreenHeight / 2);
    dest.Set(0, 0, mgScreenWidth, mgScreenHeight);
    DrawMenuMainFrmImg(loaded_tex_no, dest, source, 128, 128, 128, 128, 1);
    source_edge.Set(0, 0, mgScreenWidth / 2, mgScreenHeight / 2);
    dest_edge.Set(-1, -1, mgScreenWidth + 1, mgScreenHeight + 1);
    DrawMenuMainFrmImg(loaded_tex_no, dest_edge, source_edge, 128, 128, 128, 128, 0);

    prim = GetMenuPrim();
    hole_no = SubSphidaData->GetNowHorl() + 1;

    if (SphidaTex_Sys != nullptr) {
        hole_digits.Set(0, 0x60, 0x1C, 0x20);
        textures->ReloadTexture(SphidaTex_Sys->block, (sceVif1Packet *) nullptr);
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(SphidaTex_Sys);
        prim->Color(128, 128, 128, 128);

        if (LanguageCode == LANG_JAPANESE) {
            float left_x = 42.0f;
            float right_x = 110.0f;
            label_left.Set(0, 0, 0x24, 0x26);
            label_y = mgScreenHeight - 0x4C;
            PrimQuad(prim, left_x, static_cast<float>(label_y), label_left);
            label_right.Set(0x24, 0, 0x5A, 0x26);
            PrimQuad(prim, right_x, mgScreenHeight - 0x4C, label_right);
            PrimDrawNumber(prim, hole_no, MENU_NUMBER_ALIGN_RIGHT, 0x6A, mgScreenHeight - 0x4A, hole_digits, -2, 0);
        } else if (LanguageCode > LANG_JAPANESE) {
            label_wide.Set(0, 0, 0x88, 0x26);
            PrimQuad(prim, 42.0f, mgScreenHeight - 0x4C, label_wide);
            number_y = mgScreenHeight - 0x4A;
            PrimDrawNumber(prim, hole_no, MENU_NUMBER_ALIGN_RIGHT, 0xCE, number_y, hole_digits, -2, 0);
        }

        prim->End();
    }

    if (SphidaTex != nullptr) {
        textures->ReloadTexture(SphidaTex->block, (sceVif1Packet *) nullptr);
        DrawSubGameTitle(SphidaTex, 0, 0x152, 0x2A, 0x78);
        title.Set(0, 0x88, 0x4A, 0x16);
        PrimQuad(prim, SphidaTex, 360.0f, 54.0f, title, 128, 128, 128, 128);
        DrawSubGameListFix(SphidaTex, 0x14A, 0x5A, 0x8C, 0xFA);
        row_y = 0x84;

        for (row = 0; row < SPHIDA_HOLE_MAX; row++) {
            DrawSubGameUnderLine(SphidaTex, 0x158, row_y, 0x6E);
            score_digits.Set(0, 0xEC, 0x12, 0x14);
            number_digits.Set(0, 0x74, 0xE, 0x14);
            SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
            prim->Begin(MG_PRIM_SPRITE);
            prim->Texture(SphidaTex);
            prim->Color(128, 128, 128, 128);

            if (Sfida_NowPlayHorlBlink > PAL_TIMING(0x19, 0x1e) && row == hole_no - 1) {
                prim->Color(0xD2, 0xD2, 0x64, 128);
            }

            PrimDrawNumber(prim, row + 1, MENU_NUMBER_ALIGN_RIGHT, 0x178, row_y - 0x12, number_digits, -2, 0);
            hole_label.Set(0x9A, 0x74, 0xE, 0x14);
            int hole_y = row_y - 0x12;
            PrimQuad(prim, 376.0f, hole_y, hole_label);
            prim->Color(128, 128, 128, 128);

            if (hole_no < row + 1) {
                par_label.Set(0xB4, 0xEC, 0x12, 0x14);
                PrimQuad(prim, 406.0f, row_y - 0x12, par_label);
            } else {
                PrimDrawNumber(prim, SubSphidaData->GetHorlScore(row), MENU_NUMBER_ALIGN_RIGHT, 0x1A6, row_y - 0x13, score_digits, -2, 0);
                score_label.Set(0x7E, 0x88, 0xE, 0x16);
                PrimQuad(prim, 430.0f, row_y - 0x12, score_label);
            }

            prim->End();
            row_y += 0x16;
        }
    }
}

namespace {

/**
 * One travel place of a world_map document.
 */
struct PositionEntry {
    int index;   /**< Slot in the place table. */
    int map;     /**< Map the place leads to. */
    int loop;    /**< Game loop the place leads to. */
    int area;    /**< World-map area the place belongs to. */
    int dungeon; /**< Dungeon the place leads to. */
    int floor;   /**< Dungeon floor to start on. */
    int flag;    /**< Event flag that opens the place. */
    int type;    /**< Kind of place. */
};

/**
 * One area of a world_map document.
 */
struct AreaEntry {
    int                        area;      /**< Area number and slot in the area table. */
    int                        map;       /**< Map the area represents. */
    int                        x;         /**< Screen x of the mark. */
    int                        y;         /**< Screen y of the mark, before the PAL stretch. */
    int                        name_x;    /**< Screen x of the name window. */
    int                        name_y;    /**< Screen y of the name window, before the PAL stretch. */
    int                        name_side; /**< Side the name window is placed on. */
    std::optional<std::string> title;     /**< Area name, CP932. */
};

/**
 * Typed contents of a world_map document.
 */
struct WorldMap {
    int                        positions_capacity; /**< Entries of the place table. */
    std::vector<PositionEntry> positions;          /**< Places in script order. */
    int                        areas_capacity;     /**< Entries of the area table. */
    std::vector<AreaEntry>     areas;              /**< Areas in script order. */
};

/**
 * Parses a world_map document.
 */
WorldMap ParseWorldMap(const native_config::Json &document) {
    using namespace native_config;
    WorldMap map{.positions_capacity = Int(document, "positions_capacity"), .positions = {}, .areas_capacity = Int(document, "areas_capacity"), .areas = {}};
    if (map.positions_capacity < 0 || map.areas_capacity < 0 || map.positions_capacity > 0x7FFF || map.areas_capacity > 0x7FFF) {
        throw std::runtime_error("world-map table size out of range");
    }
    for (const auto &pos : Array(document, "positions")) {
        map.positions.push_back({.index = Int(pos, "index"), .map = Int(pos, "map"), .loop = Int(pos, "loop"), .area = Int(pos, "area"), .dungeon = Int(pos, "dungeon"), .floor = Int(pos, "floor"), .flag = Int(pos, "flag"), .type = Int(pos, "type")});
    }
    for (const auto &area : Array(document, "areas")) {
        auto title = OptionalText(area, "title");
        // ConvertFontCode writes into a 0x100-byte buffer and can double a byte.
        if (title && title->size() >= 0x80) {
            throw std::runtime_error("world-map area title is too long");
        }
        map.areas.push_back({.area = Int(area, "area"), .map = Int(area, "map"), .x = Int(area, "x"), .y = Int(area, "y"), .name_x = Int(area, "name_x"), .name_y = Int(area, "name_y"), .name_side = Int(area, "name_side"), .title = std::move(title)});
    }
    return map;
}

/**
 * Gives the number of quadwords that hold a byte count.
 */
u32 Quadwords(u32 bytes) {
    return (bytes & 0xF) != 0 ? (bytes >> 4) + 1 : bytes >> 4;
}

/**
 * Fills one travel place as the POS tag does.
 */
void ApplyPosition(const PositionEntry &entry) {
    if (entry.index < 0 || entry.index >= spi_wmappos_tblnum) {
        return;
    }
    std::array<char, 0x100> converted{};
    WMAP_POS_DATA          *pos = &spi_wmappos_tbl[entry.index];
    pos->map_no = entry.map;
    pos->loop_no = static_cast<s16>(entry.loop);
    pos->area_no = static_cast<s16>(entry.area);
    pos->dng_no = static_cast<s16>(entry.dungeon);
    pos->floor = static_cast<s8>(entry.floor);
    ConvertFontCode(GetMapTitle(pos->map_no), converted.data());
    pos->name = mgCopyString(converted.data(), spi_wmapstack);
    pos->flag_no = static_cast<s16>(entry.flag);
    pos->enable = CheckBitFlagMenu(pos->flag_no) != 0 ? 1 : 0;
    pos->type = static_cast<s8>(entry.type);
    if (pos->type == WMAP_POS_TYPE_GEORAMA && CheckBitFlagMenu(SAVE_FLAG_CHAPTER_8) != 0) {
        pos->enable = 0;
    }
}

/**
 * Fills one area and gathers its places as the AREA tag does.
 */
void ApplyArea(const AreaEntry &entry) {
    if (entry.area < 0 || entry.area >= spi_wmaparea_tblnum) {
        return;
    }
    std::array<char, 0x100> converted{};
    WMAP_AREA_DATA         *area = &spi_wmaparea_tbl[entry.area];
    area->area_no = entry.area;
    area->map_no = static_cast<s16>(entry.map);
    area->x = entry.x;
    area->name_x = entry.name_x;
    area->name_side = entry.name_side;
    // The PAL screen is taller than the coordinates the script gives.
    area->y = static_cast<int>(1.15f * static_cast<float>(entry.y));
    area->name_y = static_cast<int>(1.15f * static_cast<float>(entry.name_y));
    std::string title = entry.title.value_or(std::string{});
    // A missing title converts as empty text rather than through a null pointer.
    ConvertFontCode(title.data(), converted.data());
    area->name = mgCopyString(converted.data(), spi_wmapstack);
    area->enable = 0;
    int position_count = 0;
    for (int index = 0; index < spi_wmappos_tblnum && position_count < WMAP_AREA_POS_MAX; ++index) {
        WMAP_POS_DATA *pos = &spi_wmappos_tbl[index];
        if (pos->area_no == entry.area) {
            area->pos[position_count++] = pos;
            if (pos->enable != 0) {
                area->enable = 1;
            }
        }
    }
    if (area->area_no == 8 && CheckBitFlagMenu(SAVE_FLAG_WORLD_MAP_4) != 0) {
        area->enable = 0;
    }
    if (CheckBitFlagMenu(SAVE_FLAG_CHAPTER_8_STARTED) != 0 && (area->area_no == 6 || area->area_no == 7)) {
        area->enable = 0;
    }
    if (area->enable != 0) {
        ++MapEnableNum;
    }
    for (int slot = position_count; slot < WMAP_AREA_POS_MAX; ++slot) {
        area->pos[slot] = nullptr;
    }
}

} // namespace

void worldmap_analyze(mgCMemory *stack, char *script, int /*size*/) {
    spi_wmapstack = stack;
    spi_wmappos_tbl = nullptr;
    MapEnableNum = 0;
    const auto map = native_config::ReadBuffer<WorldMap>(script, "world_map", ParseWorldMap);
    if (!map) {
        return;
    }
    spi_wmappos_tblnum = static_cast<short>(map->positions_capacity);
    spi_wmappos_tbl = reinterpret_cast<WMAP_POS_DATA *>(stack->Alloc(static_cast<int>(Quadwords(spi_wmappos_tblnum * sizeof(WMAP_POS_DATA)))));
    if (spi_wmappos_tbl == nullptr) {
        spi_wmappos_tblnum = 0;
    }
    for (const auto &pos : map->positions) {
        ApplyPosition(pos);
    }
    spi_wmaparea_tblnum = static_cast<short>(map->areas_capacity);
    spi_wmaparea_tbl = reinterpret_cast<WMAP_AREA_DATA *>(stack->Alloc(static_cast<int>(Quadwords(spi_wmaparea_tblnum * sizeof(WMAP_AREA_DATA)))));
    if (spi_wmaparea_tbl == nullptr) {
        spi_wmaparea_tblnum = 0;
    }
    for (const auto &area : map->areas) {
        ApplyArea(area);
    }
}
