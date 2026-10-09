#include "common.h"

#include <cstdio>
#include <cstring>

#include "cameracontrol.hpp"
#include "dataread.hpp"
#include "dbg_font.hpp"
#include "editdebug.hpp"
#include "editloop.hpp"
#include "editmap.hpp"
#include "font.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "map.hpp"
#include "mapjump.hpp"
#include "menuaqua.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "userdata.hpp"

/**
 *
 * Writes the marker for the selected debug-menu row and returns its length.
 *
 */
static int PrintCursor(char *text, int row);

/**
 *
 * Loads one fish-race contestant from the GYOFISH script tag.
 *
 */
static int tagGyoFish(SPI_STACK *stack, int argument_count);

/**
 *
 * Reloads the host fish-race configuration into the bonus racer table.
 *
 */
static void LoadGyorace();

/**
 * Whether the town-building debug menu is open.
 */
static int EditDebugFlag;

/**
 * Texture bank selected for the town-building debug menu.
 */
static int EditDebugTexb;

/**
 * Selected row of the town-building debug menu.
 */
static int Select;

/**
 * Current page of the town-building debug menu.
 */
static int SelTAG;

/**
 * Sub game selected for the debug launch action.
 */
static int sg_type;

/**
 * Destination map selected for the debug jump action.
 */
static int map_jump;

/**
 * Host town-layout file number selected for saving.
 */
static int save_no;

/**
 * Host town-layout file number selected for loading.
 */
static int load_no;

/**
 * Town-layout condition selected for inspection.
 */
static int condition;

/**
 * Map flag selected for inspection.
 */
static int map_flag_no;

/**
 * Whether the lighting editor is open.
 */
static int LEditFlag;

/**
 * Current page of the lighting editor.
 */
static int LightType;

/**
 * Directional light selected in the lighting editor.
 */
static int DirLightNo;

/**
 * Fish-race contestant index while loading the debug configuration.
 */
static int fish_num;

/**
 * Event selected for the debug run action.
 */
static int EventNo = 100;

/**
 * Number of selectable rows on each debug-menu page.
 */
static int SelMax[EDIT_DEBUG_PAGE_COUNT] = {EDIT_DEBUG_GENERAL_COUNT, EDIT_DEBUG_EDIT_DATA_COUNT, EDIT_DEBUG_MAP_COUNT};

/**
 * Editable values associated with each debug-menu row.
 */
static int *SelData[EDIT_DEBUG_PAGE_COUNT][8] = {
    {&DebugInfo.debug_camera, &EventNo, &DebugInfo.georama_debug, &DebugInfo.chara_move,
     &sg_type, &DebugInfo.param_off, &DebugInfo.invent_debug, NULL},
    {NULL, &save_no, &load_no, &condition, &map_flag_no, NULL, NULL, NULL},
    {&map_jump, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
};

/**
 * Labels displayed for each debug-menu row.
 */
static char *SelText[EDIT_DEBUG_PAGE_COUNT][8] = {
    {"Debug Camera    ", "RunEvent        ", "Georama Debug   ", "CharaMove       ", "SubGame         ", "ParamOff        ", "InventDebug     ", NULL},
    {"All Clear       ", "Save File       ", "Load File       ", "Con ", "Map Flag  ", NULL, NULL, NULL},
    {"Map Jump        ", "Load Gyorace    ", NULL, NULL, NULL, NULL, NULL, NULL},
};

/**
 * Help text displayed for each debug-menu row.
 */
static char *SelHelp[EDIT_DEBUG_PAGE_COUNT][8] = {
    {"", "\x81\x9B:run \x81\xA2:reload", "", "1:sp up 2:col off", "", "", "", NULL},
    {"", "", "", "", "", "", NULL, NULL},
    {"", "", "", "", "", "", NULL, NULL},
};

/**
 * Selected row on each lighting-editor page.
 */
static int LightSel[LIGHTING_EDIT_PAGE_COUNT] = {0, 0, 0, 0};

/**
 * Number of selectable rows on each lighting-editor page.
 */
static int LightListNum[LIGHTING_EDIT_PAGE_COUNT] = {11, 8, 9, 3};

// Code (.text)
void EditDebugInit() {
    EditDebugFlag = 0;
    Select = 0;
    EditDebugTexb = -1;
}

int EditDebugMode() { return EditDebugFlag; }

void EditDebugStart(int texb, mgCMemory *buffer) {
    buffer->stack_used = 0;
    buffer->lock = 0;
    EditDebugFlag = 1;
    EditDebugTexb = texb;
}

/**
 *
 * Writes the selection marker for an editor debug menu row.
 *
 */
static int PrintCursor(char *text, int row) {
    if (row == Select) {
        int length = sprintf(text, "->");
        return length;
    }

    return sprintf(text, "  ");
}

int EditDebugLoop(CScene *scene, EditDebugInfo *info) {
    char text[4096];
    int edit_data_no;
    char *end;
    CCharacter2 *character;
    CMapFlagData *map_flags;
    int row;
    int *value;
    int closed;

    if (!EditDebugFlag || !DebugFlag) {
        return 0;
    }
    edit_data_no = info->edit_data_no;
    end = text;
    character = scene->GetCharacter(scene->player_chara);
    map_flags = GetSaveData()->GetMapFlag(scene->GetMainMapNo());
    mgCDrawPrim background;
    background.Initialize(NULL, NULL);
    background.AlphaBlendEnable(1);
    background.AlphaTestEnable(0);
    background.DepthTestEnable(0);
    background.Begin(MG_PRIM_SPRITE);
    background.Color(1, 1, 1, 64);
    background.Vertex(10, 10, 0);
    background.Vertex(250, 200, 0);
    background.End();

    if (character) {
        float position[4];
        float rotation[4];
        character->GetPosition(position);
        character->GetRotation(rotation);
        end += sprintf(end, "%7.1f %7.1f %7.1f R%4.2f\n", position[0], position[1], position[2], rotation[1]);
        if (GamePad__2.Down(PAD_START)) {
            char coordinates[512];
            int length = sprintf(coordinates, "%.1f,%.1f,%.1f,%.2f;", position[0], position[1], position[2], rotation[1]);
            WriteFile("host0:pos.txt", coordinates, length);
        }
    } else {
        end += sprintf(end, "\n");
    }

    for (row = 0; row < SelMax[SelTAG]; row++) {
        end += PrintCursor(end, row);
        end += sprintf(end, "%s ", SelText[SelTAG][row]);
        if (SelTAG == EDIT_DEBUG_PAGE_EDIT_DATA &&
            (row == EDIT_DEBUG_EDIT_DATA_CONDITION || row == EDIT_DEBUG_EDIT_DATA_MAP_FLAG)) {
            if (row == EDIT_DEBUG_EDIT_DATA_CONDITION) {
                if (info->edit_data) {
                    const char *state[2] = {"X", "O"};
                    char condition_text[128];
                    int flag = info->edit_data->dbgGetContintionFlag(edit_data_no, condition, condition_text);
                    end += sprintf(end, "%d[%s]%s\n", condition, state[flag], condition_text);
                } else {
                    end += sprintf(end, "nothing\n");
                }
            }
            if (row == EDIT_DEBUG_EDIT_DATA_MAP_FLAG) {
                const char *state[2] = {"X", "O"};
                if (!map_flags) {
                    end += sprintf(end, "nothing\n");
                } else {
                    end += sprintf(end, "(%d)%d = %s\n", scene->GetMainMapNo(), map_flag_no,
                                   state[map_flags->GetFlag(map_flag_no)]);
                }
            }
        } else if (SelData[SelTAG][row]) {
            end += sprintf(end, "%d\n", *SelData[SelTAG][row]);
        } else {
            end += sprintf(end, "\n");
        }
    }
    end += sprintf(end, "\n");
    if (SelHelp[SelTAG][Select]) {
        sprintf(end, "%s\n", SelHelp[SelTAG][Select]);
    }

    value = SelData[SelTAG][Select];
    if (value) {
        if (GamePad__2.Down(PAD_LEFT)) {
            --*value;
        }
        if (GamePad__2.Down(PAD_RIGHT)) {
            ++*value;
        }
        if (GamePad__2.On(PAD_L2) && GamePad__2.On(PAD_R2)) {
            if (GamePad__2.Down(PAD_L1)) {
                *value -= 10000;
            }
            if (GamePad__2.Down(PAD_R1)) {
                *value += 10000;
            }
        } else {
            if (GamePad__2.Down(PAD_L1)) {
                *value -= 10;
            }
            if (GamePad__2.Down(PAD_R1)) {
                *value += 10;
            }
        }
        if (GamePad__2.Down(PAD_L2)) {
            *value -= 100;
        }
        if (GamePad__2.Down(PAD_R2)) {
            *value += 100;
        }
        if (*value < 0) {
            *value = 0;
        }
        if (*value >= 99999) {
            *value = 99999;
        }
    }
    if (GamePad__2.Down(PAD_SELECT)) {
        ++SelTAG;
        if (SelTAG >= EDIT_DEBUG_PAGE_COUNT) {
            SelTAG = EDIT_DEBUG_PAGE_GENERAL;
        }
    }
    if (GamePad__2.Down(PAD_DOWN)) {
        ++Select;
    }
    if (GamePad__2.Down(PAD_UP)) {
        --Select;
    }
    if (Select < 0) {
        Select = SelMax[SelTAG] - 1;
    }
    if (Select >= SelMax[SelTAG]) {
        Select = 0;
    }
    DebugInfo.debug_camera = DebugInfo.debug_camera != 0;
    DebugInfo.georama_debug = DebugInfo.georama_debug != 0;
    DebugInfo.param_off = DebugInfo.param_off != 0;
    if (DebugInfo.chara_move < 0) {
        DebugInfo.chara_move = 0;
    }
    if (DebugInfo.chara_move > 2) {
        DebugInfo.chara_move = 2;
    }
    if (DebugInfo.invent_debug < 0) {
        DebugInfo.invent_debug = 0;
    }
    if (DebugInfo.invent_debug > 1) {
        DebugInfo.invent_debug = 1;
    }
    GetDebugFont()->DrawDirect(text, 10, 10);

    closed = 0;
    if (GamePad__2.Down(PAD_CIRCLE)) {
        if (SelTAG == EDIT_DEBUG_PAGE_GENERAL && Select == EDIT_DEBUG_GENERAL_SUB_GAME) {
            sgInitSubGame(sg_type, info);
            EditDebugEnd();
            closed = 1;
        }
        if (SelTAG == EDIT_DEBUG_PAGE_EDIT_DATA) {
            int map_no = scene->now_map_no;
            GetSaveData();
            CEditData *edit_data = info->edit_data;
            CEditMap *map = (CEditMap *)scene->GetMap(scene->active_map);
            if (edit_data && map) {
                char path[64];
                switch (Select) {
                case EDIT_DEBUG_EDIT_DATA_ALL_CLEAR:
                    map->ClearAllParts();
                    break;
                case EDIT_DEBUG_EDIT_DATA_SAVE_FILE:
                    EditDataSave();
                    sprintf(path, "host0:geo_data/geo%d-%d.edt", map_no, save_no);
                    WriteFile(path, edit_data, 0x5510);
                    break;
                case EDIT_DEBUG_EDIT_DATA_LOAD_FILE:
                    sprintf(path, "host0:geo_data/geo%d-%d.edt", map_no, load_no);
                    if (LoadFile2(path, edit_data, NULL, 0)) {
                        EditDataLoad();
                    }
                    break;
                case EDIT_DEBUG_EDIT_DATA_CONDITION:
                    info->edit_data->dbgSetContintionFlag(
                        edit_data_no, condition, !info->edit_data->dbgGetContintionFlag(edit_data_no, condition, NULL));
                    break;
                case EDIT_DEBUG_EDIT_DATA_MAP_FLAG:
                    if (map_flags) {
                        map_flags->SetFlag(map_flag_no, !map_flags->GetFlag(map_flag_no));
                    }
                    break;
                }
            }
        }
        if (SelTAG == EDIT_DEBUG_PAGE_MAP) {
            switch (Select) {
            case EDIT_DEBUG_MAP_MAP_JUMP:
                closed = 1;
                info->jump_map_no = map_jump;
                break;
            case EDIT_DEBUG_MAP_LOAD_GYORACE:
                LoadGyorace();
                break;
            }
        }
    }
    if (GamePad__2.Down(PAD_TRIANGLE) && SelTAG == EDIT_DEBUG_PAGE_EDIT_DATA &&
        Select == EDIT_DEBUG_EDIT_DATA_CONDITION) {
        int flag = info->edit_data->dbgGetContintionFlag(edit_data_no, 0, NULL);
        for (int i = 0; i < 64; i++) {
            info->edit_data->dbgSetContintionFlag(edit_data_no, i, !flag);
        }
    }
    if (SelTAG == EDIT_DEBUG_PAGE_GENERAL && Select == EDIT_DEBUG_GENERAL_RUN_EVENT) {
        if (GamePad__2.Down(PAD_CIRCLE)) {
            scene->RunEvent(EventNo, NULL);
            closed = 1;
        }
        if (GamePad__2.Down(PAD_TRIANGLE)) {
            ReloadMapScript();
        }
    }
    if (closed || GamePad__2.Down(PAD_CROSS | PAD_R3)) {
        EditDebugEnd();
        return 1;
    }
    return 0;
}
void EditDebugEnd() {
    EditDebugInit();
}

void InitLightingEdit() { LEditFlag = 0; }

void EndLightingEdit() {
    InitLightingEdit();
}

int IsLightingEditMode() { return LEditFlag; }

void LightingEdit(CScene *scene) {
    int row;
    float *selected;
    int selected_index;
    int edit;
    char *end;
    CMapLightingInfo *light;
    CMap *map;
    int light_no;
    float angle;
    int previous;
    if (!LEditFlag) {
        if (GamePad__2.Down2(PAD_R3)) {
            LEditFlag = 1;
            GamePad__2.SetAutoRepeat2(PAD_LEFT | PAD_RIGHT, 10, 1);
            GamePad__2.SetAutoRepeat2(PAD_DOWN | PAD_UP, 15, 3);
        }
        return;
    }
    map = scene->GetMap(scene->active_map);
    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.AlphaBlendEnable(1);
    prim.AlphaTestEnable(0);
    prim.DepthTestEnable(0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(1, 1, 1, 64);
    prim.Vertex(10, 10, 0);
    prim.Vertex(150, 300, 0);
    prim.End();
    light_no = map->map_info.active_light_no;
    light = map->map_info.GetLightingInfo(light_no);
    selected = NULL;
    selected_index = 0;
    const char *channel[3] = {"R", "G", "B"};
    const char *axis[3] = {"X", "Y", "Z"};
    const char *cursor[2] = {"  ", ">>"};
    const char *tail[2] = {"  ", "<<"};
    char text[4096];
    const char *pages[4] = {"<- BG & AMB  ->", "<-Dir Light ", "<-    Fog    ->", "<-   File    ->"};
    end = text;
    row = LightSel[LightType];
    end += sprintf(end, "%sLightSet [%d]\n", cursor[row == LIGHTING_EDIT_ROW_LIGHT_SET], light_no);
    if (LightType != LIGHTING_EDIT_PAGE_DIR_LIGHT) end += sprintf(end, "%s%s\n", cursor[row == LIGHTING_EDIT_ROW_PAGE], pages[LightType]);
    else end += sprintf(end, "%s%s%d->\n", cursor[row == LIGHTING_EDIT_ROW_PAGE], pages[LightType], DirLightNo);
    if (LightType == LIGHTING_EDIT_PAGE_BG_AMBIENT) {
        edit = row - LIGHTING_EDIT_ROW_ITEM;
        float *colors[3] __attribute__((aligned(16))) = {light->bg_color, light->bg_color2, light->ambient};
        if (row > 10) row = 10;
        selected = colors[edit / 3];
        selected_index = edit % 3;
        const char *groups[3] = {"BG_COL  ", "BG_COL2 ", "AMBIENT "};
        for (int group = 0; group < 3; group++) {
            for (int component = 0; component < 3; component++) {
                int hit = edit == group * 3 + component;
                end += sprintf(end, "%s%s%s = %d%s\n", cursor[hit], groups[group], channel[component],
                               (int)colors[group][component], tail[hit]);
            }
        }
        end += sprintf(end, "   BG   BG2   AMB\n");
    }
    if (LightType == LIGHTING_EDIT_PAGE_DIR_LIGHT) {
        int edit = row - LIGHTING_EDIT_ROW_ITEM;
        if (edit >= LIGHTING_EDIT_DIR_ROTATE_X && edit < LIGHTING_EDIT_DIR_COUNT) {
            sceVu0FVECTOR angles;
            mgZeroVector(angles);
            if (GamePad__2.Down2(PAD_RIGHT)) angles[edit - LIGHTING_EDIT_DIR_ROTATE_X] = 0.04f;
            if (GamePad__2.Down2(PAD_LEFT)) angles[edit - LIGHTING_EDIT_DIR_ROTATE_X] = -0.04f;
            if (!(mgDistVector(angles) <= 0.0f)) {
                sceVu0FVECTOR vector;
                vector[0] = light->light_dir[0][DirLightNo];
                vector[1] = light->light_dir[1][DirLightNo];
                vector[2] = light->light_dir[2][DirLightNo];
                vector[3] = 0.0f;
                if (mgDistVector(vector) == 0.0f) vector[2] = 1.0f;
                sceVu0FMATRIX transform;
                mgUnitMatrix(transform);
                sceVu0RotMatrix(transform, transform, angles);
                sceVu0ApplyMatrix(vector, transform, vector);
                sceVu0Normalize(vector, vector);
                light->light_dir[0][DirLightNo] = vector[0];
                light->light_dir[1][DirLightNo] = vector[1];
                light->light_dir[2][DirLightNo] = vector[2];
            }
        }
        if (edit >= 0) {
            if (edit < LIGHTING_EDIT_DIR_ROTATE_X) {
                selected_index = edit;
                selected = light->light_color[DirLightNo];
            }
        }
        for (int component = 0; component < 3; component++) {
            int hit = edit == component;
            end += sprintf(end, "%sCOL %s = %d%s\n", cursor[hit], channel[component],
                           (int)light->light_color[DirLightNo][component], tail[hit]);
        }
        end += sprintf(end, "%sROTATE X <->%s\n", cursor[edit == LIGHTING_EDIT_DIR_ROTATE_X], tail[edit == LIGHTING_EDIT_DIR_ROTATE_X]);
        end += sprintf(end, "%sROTATE Y <->%s\n", cursor[edit == LIGHTING_EDIT_DIR_ROTATE_Y], tail[edit == LIGHTING_EDIT_DIR_ROTATE_Y]);
        end += sprintf(end, "%sROTATE Z <->%s\n", cursor[edit == LIGHTING_EDIT_DIR_ROTATE_Z], tail[edit == LIGHTING_EDIT_DIR_ROTATE_Z]);
        for (int a = 0; a < 3; a++)
            end += sprintf(end, " DIR %s = %f\n", axis[a], light->light_dir[a][DirLightNo]);
    }
    if (LightType == LIGHTING_EDIT_PAGE_FOG) {
        unsigned int edit = row - LIGHTING_EDIT_ROW_ITEM;
        mgFOG_PARAM *fog = &light->fog;
        int direction = 0;
        if (GamePad__2.Down2(PAD_RIGHT)) direction = 1;
        if (GamePad__2.Down2(PAD_LEFT)) direction = -1;
        if (direction != 0) {
            switch (edit) {
            case LIGHTING_EDIT_FOG_NEAR:
                fog->near_dist += 10.0f * direction;
                break;
            case LIGHTING_EDIT_FOG_FAR:
                fog->far_dist += 10.0f * direction;
                break;
            case LIGHTING_EDIT_FOG_R:
            case LIGHTING_EDIT_FOG_G:
            case LIGHTING_EDIT_FOG_B: {
                int value = fog->color[edit - LIGHTING_EDIT_FOG_R] + direction;
                if (value < 0) value = 0;
                if (value > 255) value = 255;
                fog->color[edit - LIGHTING_EDIT_FOG_R] = value;
                break;
            }
            case LIGHTING_EDIT_FOG_MIN:
                fog->far_value = (int)fog->far_value + direction;
                break;
            case LIGHTING_EDIT_FOG_MAX:
                fog->near_value = (int)fog->near_value + direction;
                break;
            }
            if (fog->far_value < 0.0f) fog->far_value = 0.0f;
            if (fog->near_value < 0.0f) fog->near_value = 0.0f;
            if (!(fog->far_value <= 255.0f)) fog->far_value = 255.0f;
            if (!(fog->near_value <= 255.0f)) fog->near_value = 255.0f;
            if (fog->near_dist < 10.0f) fog->near_dist = 10.0f;
            if (fog->far_dist < fog->near_dist) fog->far_dist = fog->near_dist;
        }
        end += sprintf(end, "%sNEAR = %f%s\n", cursor[edit == LIGHTING_EDIT_FOG_NEAR], fog->near_dist, tail[edit == LIGHTING_EDIT_FOG_NEAR]);
        end += sprintf(end, "%sFAR  = %f%s\n", cursor[edit == LIGHTING_EDIT_FOG_FAR], fog->far_dist, tail[edit == LIGHTING_EDIT_FOG_FAR]);
        end += sprintf(end, "%sR    = %d%s\n", cursor[edit == LIGHTING_EDIT_FOG_R], fog->r, tail[edit == LIGHTING_EDIT_FOG_R]);
        end += sprintf(end, "%sG    = %d%s\n", cursor[edit == LIGHTING_EDIT_FOG_G], fog->g, tail[edit == LIGHTING_EDIT_FOG_G]);
        end += sprintf(end, "%sB    = %d%s\n", cursor[edit == LIGHTING_EDIT_FOG_B], fog->b, tail[edit == LIGHTING_EDIT_FOG_B]);
        end += sprintf(end, "%sMIN  = %d%s\n", cursor[edit == LIGHTING_EDIT_FOG_MIN], (int)fog->far_value, tail[edit == LIGHTING_EDIT_FOG_MIN]);
        end += sprintf(end, "%sMAX  = %d%s\n", cursor[edit == LIGHTING_EDIT_FOG_MAX], (int)fog->near_value, tail[edit == LIGHTING_EDIT_FOG_MAX]);
    }
    if (LightType == LIGHTING_EDIT_PAGE_FILE) {
        int edit = row - LIGHTING_EDIT_ROW_ITEM;
        sprintf(end, "%sSAVE <->%s\n", cursor[edit == 0], tail[edit == 0]);
        if (edit == 0 && (GamePad__2.Down2(PAD_LEFT) || GamePad__2.Down2(PAD_RIGHT))) {
            char script[0x5000];
            int size = map->map_info.OutputLightData(script);
            if (size > 0) {
                char host[16] = "host:";
                char path[128];
                sprintf(path, "%sy:/dc2/build/light_info/%s.lgt", host, scene->GetMapName(scene->active_map));
                WriteFile(path, script, size);
            }
        }
    }
    if (selected != NULL) {
        int value;
        float *target = &selected[selected_index];
        value = (int)*target;
        if (GamePad__2.Down2(PAD_RIGHT)) value += 1;
        if (GamePad__2.Down2(PAD_LEFT)) value -= 1;
        if (value < 0) value = 0;
        if (value > 255) value = 255;
        *target = value;
    }
    if (GamePad__2.Down2(PAD_UP)) row -= 1;
    if (GamePad__2.Down2(PAD_DOWN)) row += 1;
    if (row < 0) row = LightListNum[LightType] - 1;
    previous = LightType;
    if (row >= LightListNum[LightType]) row = 0;
    LightSel[LightType] = row;
    if (row == LIGHTING_EDIT_ROW_PAGE) {
        if (previous == LIGHTING_EDIT_PAGE_DIR_LIGHT) {
            if (GamePad__2.Down2(PAD_RIGHT)) DirLightNo += 1;
            if (GamePad__2.Down2(PAD_LEFT)) DirLightNo -= 1;
            if (DirLightNo < 0) {
                DirLightNo = 0;
                LightType -= 1;
            }
            if (DirLightNo > 3) {
                DirLightNo = 3;
                LightType += 1;
            }
        } else {
            if (GamePad__2.Down2(PAD_RIGHT)) LightType += 1;
            if (GamePad__2.Down2(PAD_LEFT)) LightType -= 1;
        }
        if (LightType < 0) LightType = LIGHTING_EDIT_PAGE_BG_AMBIENT;
        if (LightType > LIGHTING_EDIT_PAGE_FILE) LightType = LIGHTING_EDIT_PAGE_FILE;
        if (LightType == LIGHTING_EDIT_PAGE_BG_AMBIENT) DirLightNo = 0;
        if (LightType == LIGHTING_EDIT_PAGE_FOG) DirLightNo = 3;
        if (previous != LightType) LightSel[LightType] = LIGHTING_EDIT_ROW_PAGE;
    }
    if (row == LIGHTING_EDIT_ROW_LIGHT_SET) {
        if (GamePad__2.Down2(PAD_RIGHT)) light_no += 1;
        if (GamePad__2.Down2(PAD_LEFT)) light_no -= 1;
        if (light_no < 0) light_no = 0;
        if (light_no >= map->map_info.lighting_info_num) light_no = map->map_info.lighting_info_num - 1;
        float time = map->GetLightNoTime(light_no);
        if (!(time < 0.0f)) scene->SetTime(time);
        if (light_no >= 0 && light_no < map->map_info.lighting_info_num) map->map_info.active_light_no = light_no;
    }
    GetDebugFont()->DrawDirect(text, 10, 10);
    if (LightType == LIGHTING_EDIT_PAGE_BG_AMBIENT) {
        prim.AlphaBlendEnable(0);
        prim.AlphaTestEnable(0);
        prim.DepthTestEnable(0);
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(light->bg_color);
        prim.Vertex(20, 230, 0);
        prim.Vertex(50, 260, 0);
        prim.Color(light->bg_color2);
        prim.Vertex(60, 230, 0);
        prim.Vertex(90, 260, 0);
        prim.Color(light->ambient);
        prim.Vertex(100, 230, 0);
        prim.Vertex(130, 260, 0);
        prim.End();
    }
    if (LightType == LIGHTING_EDIT_PAGE_DIR_LIGHT) {
        prim.AlphaBlendEnable(0);
        prim.AlphaTestEnable(0);
        prim.DepthTestEnable(0);
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(light->light_color[DirLightNo]);
        prim.Vertex(20, 230, 0);
        prim.Vertex(50, 260, 0);
        prim.End();
        float direction[4];
        float reference[4];
        float tip_light[4];
        float tip_x[4];
        float tip_y[4];
        float tip_z[4];
        int origin[4];
        int light_screen[4];
        int x_screen[4];
        int y_screen[4];
        int z_screen[4];
        int anchor[4] = {0x4B0, 0x1040, 0, 0};
        float x_axis[4] = {1.0f, 0.0f, 0.0f, 0.0f};
        float y_axis[4] = {0.0f, 1.0f, 0.0f, 0.0f};
        float z_axis[4] = {0.0f, 0.0f, 1.0f, 0.0f};
        direction[0] = light->light_dir[0][DirLightNo];
        direction[1] = light->light_dir[1][DirLightNo];
        direction[2] = light->light_dir[2][DirLightNo];
        direction[3] = 0.0f;
        sceVu0ScaleVector(direction, direction, 10.0f);
        sceVu0ScaleVector(x_axis, x_axis, 10.0f);
        sceVu0ScaleVector(y_axis, y_axis, 10.0f);
        sceVu0ScaleVector(z_axis, z_axis, 10.0f);
        mgCCamera *camera = scene->GetCamera(scene->active_camera);
        if (camera != NULL) camera->GetRef(reference);
        reference[3] = 1.0f;
        sceVu0AddVector(tip_light, reference, direction);
        sceVu0AddVector(tip_x, reference, x_axis);
        sceVu0AddVector(tip_y, reference, y_axis);
        sceVu0AddVector(tip_z, reference, z_axis);
        mgTransWorldScreen(origin, reference);
        mgTransWorldScreen(light_screen, tip_light);
        mgTransWorldScreen(x_screen, tip_x);
        mgTransWorldScreen(y_screen, tip_y);
        mgTransWorldScreen(z_screen, tip_z);
        for (int i = 0; i < 2; i++) {
            light_screen[i] -= origin[i];
            x_screen[i] -= origin[i];
            y_screen[i] -= origin[i];
            z_screen[i] -= origin[i];
        }
        sceVu0ITOF4Vector(tip_light, light_screen);
        sceVu0ITOF4Vector(tip_x, x_screen);
        sceVu0ITOF4Vector(tip_y, y_screen);
        sceVu0ITOF4Vector(tip_z, z_screen);
        float unit = (tip_y[1] < 0.0f) ? -tip_y[1] : tip_y[1];
        float ratio = 30.0f / unit;
        sceVu0ScaleVector(tip_light, tip_light, ratio);
        sceVu0ScaleVector(tip_x, tip_x, ratio);
        sceVu0ScaleVector(tip_y, tip_y, ratio);
        sceVu0ScaleVector(tip_z, tip_z, ratio);
        sceVu0FTOI4Vector(light_screen, tip_light);
        sceVu0FTOI4Vector(x_screen, tip_x);
        sceVu0FTOI4Vector(y_screen, tip_y);
        sceVu0FTOI4Vector(z_screen, tip_z);
        for (int i = 0; i < 2; i++) {
            light_screen[i] += anchor[i];
            x_screen[i] += anchor[i];
            y_screen[i] += anchor[i];
            z_screen[i] += anchor[i];
        }
        prim.AlphaBlendEnable(1);
        prim.AlphaTestEnable(0);
        prim.DepthTestEnable(0);
        prim.Begin(MG_PRIM_LINE);
        prim.Color(0, 255, 0, 64);
        prim.Vertex4(anchor);
        prim.Vertex4(x_screen);
        prim.Color(0, 0, 255, 64);
        prim.Vertex4(anchor);
        prim.Vertex4(y_screen);
        prim.Color(255, 0, 0, 64);
        prim.Vertex4(anchor);
        prim.Vertex4(z_screen);
        prim.Color(255, 255, 255, 64);
        prim.Vertex4(anchor);
        prim.Color(255, 255, 255, 128);
        prim.Vertex4(light_screen);
        prim.End();
    }
    mgCCamera *camera = scene->GetCamera(scene->active_camera);
    if (camera != NULL) {
        angle = 0.05f * -GamePad__2.GetRXf2();
        float magnitude = (angle < 0.0f) ? -angle : angle;
        if (!(magnitude <= 0.001f)) ((CCameraControl *)camera)->Rotate(angle);
    }
    if (GamePad__2.Down2(PAD_R3)) {
        LEditFlag = 0;
        EndLightingEdit();
        GamePad__2.CancelAutoRepeat2(PAD_UP | PAD_DOWN | PAD_LEFT | PAD_RIGHT);
    }
}

/**
 *
 * Loads a gyorace fish definition from a debug script.
 *
 */
static int tagGyoFish(SPI_STACK *stack, int argument_count) {
    CGameDataUsed *racer = GetOmakeGyoracer2(fish_num);

    if (racer == NULL) {
        return 0;
    }

    BREEDFISH_USED *fish = &racer->data.fish;
    char           *name = spiGetStackString(stack++);

    if (name != NULL) {
        strcpy(fish->name, name);
    }

    racer->item_no = spiGetStackInt(stack++);
    fish->color = spiGetStackInt(stack++);
    fish->kind = spiGetStackInt(stack++);
    int tactics = spiGetStackInt(stack++);
    fish->param[4] = spiGetStackInt(stack++);
    fish->param[3] = spiGetStackInt(stack++);
    fish->param[0] = spiGetStackInt(stack++);
    fish->param[1] = spiGetStackInt(stack++);
    fish->param[2] = spiGetStackInt(stack);
    SetOmakeGyoracerTactics(fish_num, tactics);
    ++fish_num;
    return 1;
}

/**
 *
 * Loads and runs the host gyorace configuration script.
 *
 */
static void LoadGyorace() {
    char script[0x4000];
    int  size;

    if (LoadFile2("host:gyorace.cfg", script, &size, 0)) {
        fish_num = 0;
        SPI_TAG_PARAM tags[2] = {
            {"GYOFISH", tagGyoFish},
            {NULL,      NULL      }
        };
        CScriptInterpreter interpreter;
        interpreter.SetTag(tags);
        interpreter.SetScript((char *) &script, size);
        interpreter.Run();
    }
}
