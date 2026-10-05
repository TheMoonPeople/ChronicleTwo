#include "common.h"
#include "mg_memory.hpp"
#include "scriptinterpreter.hpp"
#include <cstring>
#include "editmap.hpp"
#include "dbg_font.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "gamepad.hpp"
#include "scene.hpp"
#include "editdebug.hpp"
#include "dataread.hpp"
#include "cameracontrol.hpp"
#include "editloop.hpp"
#include "editmap.hpp"
#include "font.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "map.hpp"
#include "mapjump.hpp"
#include "menuaqua.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mg_math.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "userdata.hpp"
#include <cstdio>

extern char at_1028__2[];
extern char at_1029__2[];

extern int EditDebugFlag;
extern int EditDebugTexb;
extern int Select;
extern int LEditFlag;
#include <cstring>

extern CGamePad GamePad__2;
extern int EditDebugFlag, EditDebugTexb, Select, SelTAG, sg_type, map_jump;
extern int save_no, load_no, condition, map_flag_no, LEditFlag, LightType, DirLightNo, fish_num;
extern int EventNo;
extern int SelMax[EDIT_DEBUG_PAGE_COUNT];
extern int LightSel[LIGHTING_EDIT_PAGE_COUNT], LightListNum[LIGHTING_EDIT_PAGE_COUNT];
extern int *SelData[EDIT_DEBUG_PAGE_COUNT][8];
extern char *SelText[EDIT_DEBUG_PAGE_COUNT][8];
extern char *SelHelp[EDIT_DEBUG_PAGE_COUNT][8];

/**
 * Writes the marker for the selected debug-menu row and returns its length.
 */
static int PrintCursor(char *text, int row);
/**
 * Loads one fish-race contestant from the GYOFISH script tag.
 */
int tagGyoFish(SPI_STACK *stack, int argument_count);
/**
 * Reloads the host fish-race configuration into the bonus racer table.
 */
static void LoadGyorace();

// Code (.text)
void EditDebugInit() { EditDebugFlag = 0; Select = 0; EditDebugTexb = -1; }
int EditDebugMode() { return EditDebugFlag; }
void EditDebugStart(int texb, mgCMemory *buffer) {
    buffer->stack_used = 0;
    buffer->lock = 0;
    EditDebugFlag = 1;
    EditDebugTexb = texb;
}
static int PrintCursor(char *text, int row) {
    if (row == Select) {
        int length = sprintf(text, "->");
        return length;
    }
    return sprintf(text, "  ");
}
#ifdef NONMATCHING
int EditDebugLoop(CScene *scene, EditDebugInfo *info) {
    if (!EditDebugFlag || !DebugFlag) return 0;
    CCharacter2 *character = scene->GetCharacter(scene->player_chara);
    CMapFlagData *map_flags = GetSaveData()->GetMapFlag(scene->GetMainMapNo());
    mgCDrawPrim background;
    background.Initialize(NULL, NULL);
    background.AlphaBlendEnable(1);
    background.AlphaTestEnable(0);
    background.DepthTestEnable(0);
    background.Begin(6);
    background.Color(1, 1, 1, 64);
    background.Vertex(10, 10, 0);
    background.Vertex(250, 200, 0);
    background.End();

    char text[4096];
    char *end = text;
    if (character) {
        float position[4], rotation[4];
        character->GetPosition(position);
        character->GetRotation(rotation);
        end += sprintf(end, "%7.1f %7.1f %7.1f R%4.2f\n", position[0], position[1], position[2], rotation[1]);
        if (GamePad__2.Down(PAD_START)) {
            char coordinates[512];
            int length = sprintf(coordinates, "%.1f,%.1f,%.1f,%.2f;", position[0], position[1], position[2], rotation[1]);
            WriteFile("host0:pos.txt", coordinates, length);
        }
    } else end += sprintf(end, "\n");

    const char *state[2] = {"X", "O"};
    for (int row = 0; row < SelMax[SelTAG]; ++row) {
        end += PrintCursor(end, row);
        end += sprintf(end, "%s ", SelText[SelTAG][row]);
        if (SelTAG == EDIT_DEBUG_PAGE_EDIT_DATA && row == EDIT_DEBUG_EDIT_DATA_CONDITION) {
            if (info->edit_data) {
                char condition_text[128];
                int flag = info->edit_data->dbgGetContintionFlag(info->edit_data_no, condition, condition_text);
                end += sprintf(end, "%d[%s]%s\n", condition, state[flag != 0], condition_text);
            } else end += sprintf(end, "nothing\n");
        } else if (SelTAG == EDIT_DEBUG_PAGE_EDIT_DATA && row == EDIT_DEBUG_EDIT_DATA_MAP_FLAG) {
            if (map_flags) end += sprintf(end, "(%d)%d = %s\n", scene->GetMainMapNo(), map_flag_no,
                                          state[map_flags->GetFlag(map_flag_no) != 0]);
            else end += sprintf(end, "nothing\n");
        } else if (SelData[SelTAG][row]) {
            end += sprintf(end, "%d\n", *SelData[SelTAG][row]);
        } else end += sprintf(end, "\n");
    }
    end += sprintf(end, "\n");
    if (SelHelp[SelTAG][Select]) sprintf(end, "%s\n", SelHelp[SelTAG][Select]);

    int *value = SelData[SelTAG][Select];
    if (value) {
        if (GamePad__2.Down(PAD_LEFT)) --*value;
        if (GamePad__2.Down(PAD_RIGHT)) ++*value;
        int step = GamePad__2.On(PAD_L2) && GamePad__2.On(PAD_R2) ? 10000 : 10;
        if (GamePad__2.Down(PAD_L1)) *value -= step;
        if (GamePad__2.Down(PAD_R1)) *value += step;
        if (GamePad__2.Down(PAD_L2)) *value -= 100;
        if (GamePad__2.Down(PAD_R2)) *value += 100;
        if (*value < 0) *value = 0;
        if (*value > 99999) *value = 99999;
    }
    if (GamePad__2.Down(PAD_SELECT)) {
        ++SelTAG;
        if (SelTAG >= EDIT_DEBUG_PAGE_COUNT) SelTAG = EDIT_DEBUG_PAGE_GENERAL;
    }
    if (GamePad__2.Down(PAD_DOWN)) ++Select;
    if (GamePad__2.Down(PAD_UP)) --Select;
    if (Select < 0) Select = SelMax[SelTAG] - 1;
    if (Select >= SelMax[SelTAG]) Select = 0;
    DebugInfo.debug_camera = DebugInfo.debug_camera != 0;
    DebugInfo.georama_debug = DebugInfo.georama_debug != 0;
    DebugInfo.param_off = DebugInfo.param_off != 0;
    if (DebugInfo.chara_move < 0) DebugInfo.chara_move = 0;
    if (DebugInfo.chara_move > 2) DebugInfo.chara_move = 2;
    if (DebugInfo.invent_debug < 0) DebugInfo.invent_debug = 0;
    if (DebugInfo.invent_debug > 1) DebugInfo.invent_debug = 1;
    GetDebugFont()->DrawDirect(text, 10, 10);

    int closed = 0;
    if (GamePad__2.Down(PAD_CIRCLE)) {
        if (SelTAG == EDIT_DEBUG_PAGE_GENERAL && Select == EDIT_DEBUG_GENERAL_SUB_GAME) {
            sgInitSubGame(sg_type, info);
            EditDebugEnd();
            closed = 1;
        }
        if (SelTAG == EDIT_DEBUG_PAGE_EDIT_DATA) {
            CEditMap *map = (CEditMap *)scene->GetMap(scene->active_map);
            if (info->edit_data && map) {
                char path[128];
                switch (Select) {
                case EDIT_DEBUG_EDIT_DATA_ALL_CLEAR: map->ClearAllParts(); break;
                case EDIT_DEBUG_EDIT_DATA_SAVE_FILE:
                    EditDataSave();
                    sprintf(path, "host0:geo_data/geo%d-%d.edt", scene->now_map_no, save_no);
                    WriteFile(path, info->edit_data, 0x5510);
                    break;
                case EDIT_DEBUG_EDIT_DATA_LOAD_FILE:
                    sprintf(path, "host0:geo_data/geo%d-%d.edt", scene->now_map_no, load_no);
                    if (LoadFile2(path, info->edit_data, NULL, 0)) EditDataLoad();
                    break;
                case EDIT_DEBUG_EDIT_DATA_CONDITION:
                    info->edit_data->dbgSetContintionFlag(info->edit_data_no, condition,
                        !info->edit_data->dbgGetContintionFlag(info->edit_data_no, condition, NULL));
                    break;
                case EDIT_DEBUG_EDIT_DATA_MAP_FLAG:
                    if (map_flags) map_flags->SetFlag(map_flag_no, !map_flags->GetFlag(map_flag_no));
                    break;
                }
            }
        }
        if (SelTAG == EDIT_DEBUG_PAGE_MAP) {
            if (Select == EDIT_DEBUG_MAP_MAP_JUMP) { info->jump_map_no = map_jump; closed = 1; }
            if (Select == EDIT_DEBUG_MAP_LOAD_GYORACE) LoadGyorace();
        }
    }
    if (GamePad__2.Down(PAD_TRIANGLE) && SelTAG == EDIT_DEBUG_PAGE_EDIT_DATA &&
        Select == EDIT_DEBUG_EDIT_DATA_CONDITION && info->edit_data) {
        int new_flag = !info->edit_data->dbgGetContintionFlag(info->edit_data_no, 0, NULL);
        for (int i = 0; i < 64; ++i) info->edit_data->dbgSetContintionFlag(info->edit_data_no, i, new_flag);
    }
    if (SelTAG == EDIT_DEBUG_PAGE_GENERAL && Select == EDIT_DEBUG_GENERAL_RUN_EVENT) {
        if (GamePad__2.Down(PAD_CIRCLE)) { scene->RunEvent(EventNo, NULL); closed = 1; }
        if (GamePad__2.Down(PAD_TRIANGLE)) ReloadMapScript();
    }
    if (closed || GamePad__2.Down(PAD_CROSS | PAD_L3)) {
        EditDebugEnd();
        return 1;
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdebug", EditDebugLoop__FP6CSceneP13EditDebugInfo);
#endif
void EditDebugEnd(void) {
    EditDebugInit();
}
void InitLightingEdit() { LEditFlag = 0; }
void EndLightingEdit(void) {
    InitLightingEdit();
}
int IsLightingEditMode() { return LEditFlag; }
#ifdef NONMATCHING
void LightingEdit(CScene *scene) {
    if (!LEditFlag) {
        if (GamePad__2.Down2(PAD_L3)) {
            LEditFlag = 1;
            GamePad__2.SetAutoRepeat2(PAD_LEFT | PAD_RIGHT, 10, 1);
            GamePad__2.SetAutoRepeat2(PAD_DOWN | PAD_UP, 15, 3);
        }
        return;
    }
    CMap *map = scene->GetMap(scene->active_map);
    int light_no = map->active_light_no;
    CMapLightingInfo *light = ((CMapInfo *)map)->GetLightingInfo(light_no);
    mgCDrawPrim background;
    background.Initialize(NULL, NULL);
    background.AlphaBlendEnable(1);
    background.AlphaTestEnable(0);
    background.DepthTestEnable(0);
    background.Begin(6);
    background.Color(1, 1, 1, 64);
    background.Vertex(10, 10, 0);
    background.Vertex(150, 300, 0);
    background.End();

    int row = LightSel[LightType];
    const char *cursor[2] = {"  ", "->"};
    const char *pages[4] = {"BG & AMB", "Dir Light", "Fog", "File"};
    const char *channel[3] = {"R", "G", "B"};
    char text[4096];
    char *end = text;
    end += sprintf(end, "%sLightSet [%d]\n", cursor[row == 0], light_no);
    if (LightType == LIGHTING_EDIT_PAGE_DIR_LIGHT)
        end += sprintf(end, "%s%s%d->\n", cursor[row == 1], pages[LightType], DirLightNo);
    else end += sprintf(end, "%s%s\n", cursor[row == 1], pages[LightType]);

    int edit_row = row - 2;
    int direction = GamePad__2.Down2(PAD_RIGHT) ? 1 : 0;
    if (GamePad__2.Down2(PAD_LEFT)) direction = -1;
    if (LightType == LIGHTING_EDIT_PAGE_BG_AMBIENT) {
        float *colors[3] = {light->bg_color, light->bg_color2, light->ambient};
        const char *groups[3] = {"BG", "BG2", "AMB"};
        if (edit_row >= 0 && edit_row < 9 && direction) {
            float &component = colors[edit_row / 3][edit_row % 3];
            int value = (int)component + direction;
            if (value < 0) value = 0;
            if (value > 255) value = 255;
            component = (float)value;
        }
        for (int group = 0; group < 3; ++group)
            for (int component = 0; component < 3; ++component)
                end += sprintf(end, "%s%s%s = %d\n", cursor[edit_row == group * 3 + component],
                    groups[group], channel[component], (int)colors[group][component]);
        end += sprintf(end, "   BG   BG2   AMB\n");
    }
    if (LightType == LIGHTING_EDIT_PAGE_DIR_LIGHT) {
        if (edit_row >= 0 && edit_row < 3 && direction) {
            float &component = light->light_color[DirLightNo][edit_row];
            int value = (int)component + direction;
            if (value < 0) value = 0;
            if (value > 255) value = 255;
            component = (float)value;
        }
        if (edit_row >= 3 && edit_row < 6 && direction) {
            sceVu0FVECTOR angles = {0.0f, 0.0f, 0.0f, 0.0f};
            angles[edit_row - 3] = direction * 0.01f;
            sceVu0FVECTOR vector = {
                light->light_dir[0][DirLightNo], light->light_dir[1][DirLightNo],
                light->light_dir[2][DirLightNo], 0.0f
            };
            if (mgDistVector(vector) == 0.0f) vector[2] = 1.0f;
            sceVu0FMATRIX transform;
            mgUnitMatrix(transform);
            sceVu0RotMatrix(transform, transform, angles);
            sceVu0ApplyMatrix(vector, transform, vector);
            sceVu0Normalize(vector, vector);
            for (int axis = 0; axis < 3; ++axis) light->light_dir[axis][DirLightNo] = vector[axis];
        }
        for (int component = 0; component < 3; ++component)
            end += sprintf(end, "%sCOL %s = %d\n", cursor[edit_row == component],
                channel[component], (int)light->light_color[DirLightNo][component]);
        for (int axis = 0; axis < 3; ++axis)
            end += sprintf(end, "%sROTATE %s <->\n", cursor[edit_row == axis + 3],
                axis == 0 ? "X" : axis == 1 ? "Y" : "Z");
        for (int axis = 0; axis < 3; ++axis)
            end += sprintf(end, " DIR %s = %f\n", channel[axis], light->light_dir[axis][DirLightNo]);
    }
    if (LightType == LIGHTING_EDIT_PAGE_FOG) {
        mgFOG_PARAM &fog = light->fog;
        if (direction) {
            if (edit_row == 0) fog.near_dist += direction * 10.0f;
            if (edit_row == 1) fog.far_dist += direction * 10.0f;
            u_char *components[3] = {&fog.r, &fog.g, &fog.b};
            if (edit_row >= 2 && edit_row <= 4) {
                int value = *components[edit_row - 2] + direction;
                if (value < 0) value = 0;
                if (value > 255) value = 255;
                *components[edit_row - 2] = value;
            }
            if (edit_row == 5) fog.far_value = (float)((int)fog.far_value + direction);
            if (edit_row == 6) fog.near_value = (float)((int)fog.near_value + direction);
            if (fog.far_value < 0.0f) fog.far_value = 0.0f;
            if (fog.far_value > 255.0f) fog.far_value = 255.0f;
            if (fog.near_value < 0.0f) fog.near_value = 0.0f;
            if (fog.near_value > 255.0f) fog.near_value = 255.0f;
            if (fog.near_dist < 10.0f) fog.near_dist = 10.0f;
            if (fog.far_dist < fog.near_dist) fog.far_dist = fog.near_dist;
        }
        end += sprintf(end, "%sNEAR = %f\n", cursor[edit_row == 0], fog.near_dist);
        end += sprintf(end, "%sFAR  = %f\n", cursor[edit_row == 1], fog.far_dist);
        end += sprintf(end, "%sR    = %d\n", cursor[edit_row == 2], fog.r);
        end += sprintf(end, "%sG    = %d\n", cursor[edit_row == 3], fog.g);
        end += sprintf(end, "%sB    = %d\n", cursor[edit_row == 4], fog.b);
        end += sprintf(end, "%sMIN  = %d\n", cursor[edit_row == 5], (int)fog.far_value);
        end += sprintf(end, "%sMAX  = %d\n", cursor[edit_row == 6], (int)fog.near_value);
    }
    if (LightType == LIGHTING_EDIT_PAGE_FILE) {
        end += sprintf(end, "%sSAVE <->\n", cursor[row == 2]);
        if (row == 2 && direction) {
            char script[0x5000];
            int size = ((CMapInfo *)map)->OutputLightData(script);
            if (size > 0) {
                char path[128];
                sprintf(path, "%sy:/dc2/build/light_info/%s.lgt", "host:", scene->GetMapName(scene->active_map));
                WriteFile(path, script, size);
            }
        }
    }

    if (GamePad__2.Down2(PAD_UP)) --row;
    if (GamePad__2.Down2(PAD_DOWN)) ++row;
    if (row < 0) row = LightListNum[LightType] - 1;
    if (row >= LightListNum[LightType]) row = 0;
    LightSel[LightType] = row;
    if (row == 1 && direction) {
        int previous = LightType;
        if (LightType == LIGHTING_EDIT_PAGE_DIR_LIGHT) {
            DirLightNo += direction;
            if (DirLightNo < 0) { DirLightNo = 0; --LightType; }
            if (DirLightNo > 3) { DirLightNo = 3; ++LightType; }
        } else LightType += direction;
        if (LightType < 0) LightType = 0;
        if (LightType >= LIGHTING_EDIT_PAGE_COUNT) LightType = LIGHTING_EDIT_PAGE_COUNT - 1;
        if (LightType == LIGHTING_EDIT_PAGE_BG_AMBIENT) DirLightNo = 0;
        if (LightType == LIGHTING_EDIT_PAGE_FOG) DirLightNo = 3;
        if (previous != LightType) LightSel[LightType] = 1;
    }
    if (row == 0 && direction) {
        light_no += direction;
        if (light_no < 0) light_no = 0;
        if (light_no >= map->lighting_info_num) light_no = map->lighting_info_num - 1;
        float time = map->GetLightNoTime(light_no);
        if (time >= 0.0f) scene->SetTime(time);
        if (light_no >= 0 && light_no < map->lighting_info_num) map->active_light_no = light_no;
    }
    GetDebugFont()->DrawDirect(text, 10, 10);
    mgCCamera *camera = scene->GetCamera(scene->active_camera);
    if (camera) {
        float angle = -GamePad__2.GetRXf2() * 0.05f;
        if (angle > 0.001f || angle < -0.001f) ((CCameraControl *)camera)->Rotate(angle);
    }
    if (GamePad__2.Down2(PAD_L3)) {
        EndLightingEdit();
        GamePad__2.CancelAutoRepeat2(PAD_UP | PAD_DOWN | PAD_LEFT | PAD_RIGHT);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdebug", LightingEdit__FP6CScene);
#endif
int tagGyoFish(SPI_STACK *stack, int argument_count) {
    CGameDataUsed *racer = GetOmakeGyoracer2(fish_num);
    if (racer == NULL) {
        return 0;
    }
    BREEDFISH_USED *fish = &racer->data.fish;
    char *name = spiGetStackString(stack++);
    if (name != NULL) {
        strcpy(fish->name, name);
    }
    racer->item_no = spiGetStackInt(stack++);
    fish->unk_3a = spiGetStackInt(stack++);
    fish->unk_16 = spiGetStackInt(stack++);
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
static void LoadGyorace() {
    char script[0x4000];
    int size;
    if (LoadFile2("host:gyorace.cfg", script, &size, 0)) {
        fish_num = 0;
        SPI_TAG_PARAM tags[2] = {{"GYOFISH", tagGyoFish}, {NULL, NULL}};
        CScriptInterpreter interpreter;
        interpreter.SetTag(tags);
        interpreter.SetScript((char *)&script, size);
        interpreter.Run();
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", SelMax__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", SelData__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", SelText__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", SelHelp__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", LightSel__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", LightListNum__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1219__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1222__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1231__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1243__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1321__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1385__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1386__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1387__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1388__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1542__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_989__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_990__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_991__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_992__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_993__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_994__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_995__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_996__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_997__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_998__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_999__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1000__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1001__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1002__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1003__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1004__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1005__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1028__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1029__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1057__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1058__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1181__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1182__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1183__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1184__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1185__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1186__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1187__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1188__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1189__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1190__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1191__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1216__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1217__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1218__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1220__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1221__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1223__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1225__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1227__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1228__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1229__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1230__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1240__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1241__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1242__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1495__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1496__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1497__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1498__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1499__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1500__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1501__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1502__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1503__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1504__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1505__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1506__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1507__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1508__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1509__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1510__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1511__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1512__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1513__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1514__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1541__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1544__2__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", EventNo__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1059__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1063__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1224__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdebug", at_1226__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(EditDebugFlag, 0x4);
INCLUDE_BSS(EditDebugTexb, 0x4);
INCLUDE_BSS(Select, 0x4);
INCLUDE_BSS(SelTAG, 0x4);
INCLUDE_BSS(sg_type, 0x4);
INCLUDE_BSS(map_jump, 0x4);
INCLUDE_BSS(save_no, 0x4);
INCLUDE_BSS(load_no, 0x4);
INCLUDE_BSS(condition, 0x4);
INCLUDE_BSS(map_flag_no, 0x4);
INCLUDE_BSS(LEditFlag, 0x4);
INCLUDE_BSS(LightType, 0x4);
INCLUDE_BSS(DirLightNo, 0x4);
INCLUDE_BSS(fish_num, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(at_1237, 0x10);
