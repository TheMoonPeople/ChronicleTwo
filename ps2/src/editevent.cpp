#include "common.h"

#include <cstdio>
#include <cstring>

#include "cameracontrol.hpp"
#include "character.hpp"
#include "dataread.hpp"
#include "editevent.hpp"
#include "editloop.hpp"
#include "editmap.hpp"
#include "editparts.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "mapjump.hpp"
#include "menumain.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "padcontrol.hpp"
#include "runscript.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "userdata.hpp"
#include "vlgr_info.hpp"

int LoadIntNPC(GeoFuncParam *param, RS_STACKDATA *stack, int mode);
int LoadGeoNPC(GeoFuncParam *param, int mode);

const int kEventNumberF9 = 0xF9;

#include <cmath>

static int CheckPlaceBurnParts(GeoFuncParam *param, RS_STACKDATA *args, int argc);

// Code (.text)
void CEditEvent::Reset() {
    state = EDIT_EVENT_STATE_IDLE;
    unk_c = 0;
    count = 0;
    type = EDIT_EVENT_TYPE_NONE;
    door_se = -1;
    map_name[0] = 0;
    memset(&data, 0, sizeof(data));
}

int CEditEvent::StartEvent(CSceneEventData *event_data) {
    if (event_data == NULL) {
        return 0;
    }

    if (state == EDIT_EVENT_STATE_RUNNING || state == EDIT_EVENT_STATE_UNK_2) {
        printf("now running!!!");
        return 0;
    }

    state = EDIT_EVENT_STATE_RUNNING;
    count = 0;
    step = 0;
    type = EDIT_EVENT_TYPE_NONE;
    data.head = event_data->head;
    data.group_1 = event_data->group_1;
    data.group_2 = event_data->group_2;
    data.group_3 = event_data->group_3;
    data.group_4 = event_data->group_4;
    data.group_5 = event_data->group_5;
    data.vectors_a = event_data->vectors_a;
    data.vectors_b = event_data->vectors_b;
    data.chara_no = event_data->chara_no;
    data.chara_slot = event_data->chara_slot;
    data.gameobj_no = event_data->gameobj_no;
    data.unk_cc = event_data->unk_cc;

    if (data.event.flag & FUNC_EVENT_DOOR) {
        if (data.event.flag & FUNC_EVENT_ED_DOOR) {
            type = EDIT_EVENT_TYPE_HOUSE_DOOR;
        } else {
            type = EDIT_EVENT_TYPE_DOOR;
        }

        if (data.event.flag & FUNC_EVENT_CLOSE_DOOR) {
            data.event.point_no = kEventNumberF9;
        }
    }

    if (data.event.flag & FUNC_EVENT_TREASURE_BOX) {
        type = EDIT_EVENT_TYPE_TREASURE_BOX;
    }

    if (data.event.flag & FUNC_EVENT_BOOK) {
        type = EDIT_EVENT_TYPE_BOOK;
    }

    if (type == EDIT_EVENT_TYPE_NONE) {
        return 0;
    }

    projection = mgGetProjection();
    return 1;
}

/**
 * Menu arguments used by house-door events.
 */
static MENU_INIT_ARG *MenuInfo__2 = &MenuArg;

/**
 *
 * Resets and closes an edit event message window.
 *
 */
static inline void close_message(ClsMes *message) {
    if (message->select < 0) {
        message->cursor_time = 0;
    }

    message->select = -1;
    message->draw_speed = message->GetDrawSpeedDef();
    message->mes_no = -1;
    message->text_ptr = 0;
    message->open = 0;
    message->fade = 0.0f;
    message->fukidashi_centre_x = -1;
    message->fukidashi_centre_y = -1;
    message->fukidashi_pos = 0;
}

int CEditEvent::Step(CScene *scene) {
    ClsMes          *message;
    int              result;
    CMapTreasureBox *box;
    CCharacter2     *character;
    CCameraControl  *camera;
    CPadControl     *pad;
    CEditMap        *map;
    int              show;
    CMapFlagData    *map_flags;
    int              flags;
    int              argument_3;
    int              se_base;
    int              argument_1;
    int              argument_2;

    if (state != EDIT_EVENT_STATE_RUNNING) {
        return EDIT_EVENT_RESULT_IDLE;
    }

    ++count;
    map = (CEditMap *) scene->GetMap(scene->active_map);
    CSaveData *save = GetSaveData();
    map_flags = save->GetMapFlag(scene->GetMainMapNo());
    character = scene->GetCharacter(scene->player_chara);
    camera = (CCameraControl *) scene->GetCamera(scene->active_camera);

    if (character == NULL || camera == NULL || map == NULL) {
        return EDIT_EVENT_RESULT_END;
    }

    float camera_pos[4], chara_pos[4], chara_rot[4];
    float rotation[4], position[4];
    camera->GetPos(camera_pos);
    character->GetRotation(chara_rot);
    character->GetPosition(chara_pos);
    float camera_angle = atan2f(camera_pos[0] - chara_pos[0], camera_pos[2] - chara_pos[2]);
    se_base = scene->se_base_id;
    message = scene->GetMessage(1);
    GeoFuncParam param;
    param.scene = scene;
    pad = &PadCtrl;
    show = character->CheckDraw();
    show &= scene->CheckDrawChara(scene->player_chara);
    argument_1 = data.event.arg1;
    argument_2 = data.event.arg2;
    flags = data.event.flag;
    argument_3 = data.event.arg3;
    result = EDIT_EVENT_RESULT_CONTINUE;

    if (type == EDIT_EVENT_TYPE_DOOR) {
        if (character != NULL) {
            float scale_y;
            float scale;
            scale = mgDistVector(data.map_event.matrix[0]);
            scale_y = mgDistVector(data.map_event.matrix[1]);
            float scale_z = mgDistVector(data.map_event.matrix[2]);
            scale = scale > scale_y ? (scale > scale_z ? scale : scale_z) : (scale_y > scale_z ? scale_y : scale_z);

            switch (step) {
                case EDIT_DOOR_STEP_START:
                    if (strcmp(data.event.target, "exit") != 0) {
                        strcpy(map_name, data.event.target);

                        if (data.event.flag & FUNC_EVENT_ED_DOOR) {
                            int         villager = -1;
                            CEditParts *parts = map->GetePlaceParts(data.map_event.parts_no);

                            if (parts != NULL) {
                                villager = parts->GetLiveNPC();
                            }

                            CVillagerInfo *info = GetVillagerInfo(villager);
                            data.unk_cc = villager;

                            if (strlen(map_name) < 4) {
                                if (info != NULL) {
                                    char *suffix[4] = {"ia", "ib", "ic", "id"};
                                    strcat(map_name, suffix[info->house_type % 4]);
                                } else {
                                    strcat(map_name, "ia");
                                }
                            }
                        }

                        camera->RotBack(mgAngleLimit(3.1415927f + atan2f(data.map_event.matrix[2][0], data.map_event.matrix[2][2])));
                    }

                    door_se = -1;
                    character->GetPosition(return_pos);
                    character->GetRotation(return_rot);
                    step = EDIT_DOOR_STEP_APPROACH;
                    break;
                case EDIT_DOOR_STEP_APPROACH: {
                    character->SetMotion("\x95\xE0\x82\xAB", 0);
                    mgZeroVector(rotation);
                    float target_angle = atan2f(data.map_event.matrix[2][0], data.map_event.matrix[2][2]);
                    mgVectorInterpolate(position, chara_pos, data.map_event.matrix[3], 1.0f, 0);
                    rotation[1] = mgAngleInterpolate(chara_rot[1], target_angle, 0.3f, 0);
                    float distance = 0.0f;

                    if (scale < 20.0f) {
                        character->SetPosition(position);
                        distance = mgDistVectorXZ(position, data.map_event.matrix[3]);
                    }

                    character->SetRotation(rotation);

                    if ((!mgAngleCmp(rotation[1], target_angle, 0.1f) && distance < 1.0f) || !((float) count <= 200.0f)) {
                        step = EDIT_DOOR_STEP_OPEN;

                        if (argument_1 >= 0) {
                            if (flags & FUNC_EVENT_CLOSE_DOOR) {
                                character->SetMotion("\x83h\x83""A\x8AJ\x82\xA9\x82\xC8\x82\xA2", 2);
                            } else {
                                character->SetMotion("\x83h\x83""A\x8AJ\x82\xAF", 2);
                            }
                        } else {
                            count = 0xE;
                        }

                        count = 0;
                    }

                    break;
                }
                case EDIT_DOOR_STEP_OPEN:
                    if (flags & FUNC_EVENT_CLOSE_DOOR) {
                        if (character->CheckMotionEnd() || count >= 0x3D || show == 0) {
                            step = EDIT_DOOR_STEP_RETURN;
                        }

                        if (count == 0x1E) {
                            scene->SePlayOpenDoor(0x18, data.map_event.matrix[3]);
                        }
                    } else {
                        if (count == 0xF && (data.event.flag & FUNC_EVENT_UNK_100)) {
                            scene->fade.FadeOut(0x1E, 0.0f, 0.0f, 0.0f);
                        }

                        if (count == 0x14) {
                            scene->SePlayOpenDoor(argument_2, data.map_event.matrix[3]);
                            door_se = argument_2;
                        }

                        if (count > 0xF && scene->fade.FadeCheck()) {
                            step = EDIT_DOOR_STEP_LEAVE;
                        }
                    }

                    break;
                case EDIT_DOOR_STEP_LEAVE:
                    camera->CancelRotBack();

                    if (data.event.point_no > 0) {
                        scene->RunEvent(data.event.point_no, &data);
                        result = EDIT_EVENT_RESULT_END;
                    } else if (strcmp(data.event.target, "exit") != 0) {
                        if (scene->fade.FadeCheck() && PreLoadSync() == 0) {
                            scene->fade.FadeIn(0x1E);

                            if (data.event.flag & FUNC_EVENT_ED_DOOR) {
                                result = EDIT_EVENT_RESULT_ENTER_HOUSE;
                            } else {
                                result = EDIT_EVENT_RESULT_ENTER;
                            }
                        }
                    } else if (scene->fade.FadeCheck()) {
                        scene->fade.FadeIn(0x1E);
                        result = EDIT_EVENT_RESULT_EXIT;
                    }

                    break;
                case EDIT_DOOR_STEP_RETURN: {
                    chara_rot[1] = mgAngleInterpolate(chara_rot[1], camera_angle, 0.2f, 0);
                    mgVectorInterpolate(chara_pos, chara_pos, return_pos, 1.0f, 0);
                    int   angle = mgAngleCmp(chara_rot[1], camera_angle, 0.1f);
                    float distance = mgDistVector(chara_pos, return_pos);

                    if (angle == 0 && distance < 1.0f) {
                        step = EDIT_DOOR_STEP_WAIT;
                        character->SetMotion("\x82\xBE\x82\xDF\x82\xBE\x82\xDF", 2);
                    } else {
                        character->SetMotion("\x95\xE0\x82\xAB", 0);
                    }

                    character->SetRotation(chara_rot);
                    character->SetPosition(chara_pos);
                    break;
                }
                case EDIT_DOOR_STEP_WAIT:
                    if (character->CheckMotionEnd() || count >= 301 || show == 0) {
                        result = EDIT_EVENT_RESULT_END;
                    }

                    break;
            }
        }
    } else if (type == EDIT_EVENT_TYPE_HOUSE_DOOR) {
        switch (step) {
            case EDIT_HOUSE_DOOR_STEP_OPEN_MENU:
                MenuInfo__2->open_type = 0xC;
                MenuInfo__2->scene = scene;
                MenuInfo__2->param[0] = data.map_event.parts_no;
                camera->CancelRotBack();
                result = EDIT_EVENT_RESULT_MENU;
                ++step;
                KeepEditAnalyze();
                break;
            case EDIT_HOUSE_DOOR_STEP_MENU_END: {
                mgSetProjection(projection);

                if (MenuInfo__2->end_code == 9) {
                    type = EDIT_EVENT_TYPE_DOOR;
                    count = 0;
                    step = 0;
                    break;
                }

                ++step;
                EditDataSave();
                CEditParts *parts = map->GetePlaceParts(data.map_event.parts_no);
                int         info = -1;

                if (parts != NULL) {
                    info = parts->GetInfoID();
                }

                if (MenuInfo__2->end_code == 0xD && info == 0x49) {
                    scene->fade.FadeOut(0x12, 0.0f, 0.0f, 0.0f);
                    reload_geo_npc = 1;
                } else {
                    count = 0x14;
                    reload_geo_npc = 0;
                }
            }
            case EDIT_HOUSE_DOOR_STEP_WAIT:
                if (count >= 0x14 || scene->fade.FadeCheck()) {
                    result = EDIT_EVENT_RESULT_END;

                    if (reload_geo_npc) {
                        scene->fade.FadeIn(0x14);
                        LoadGeoNPC(&param, 0);
                    }

                    if (EditAnalyzeChanged()) {
                        scene->RunEvent(0x136, NULL);
                    }
                }

                break;
        }
    } else if (type == EDIT_EVENT_TYPE_TREASURE_BOX) {
        box = map->GetTrBox(data.map_event.point_no);
        mgCFrame *lid = NULL;

        if (box != NULL && box->CObjectFrame::frame != NULL) {
            lid = box->CObjectFrame::frame->SearchFrame("top");
        }

        if (lid == NULL) {
            result = EDIT_EVENT_RESULT_END;
            step = EDIT_TREASURE_BOX_STEP_DELETE;
        }

        switch (step) {
            case EDIT_TREASURE_BOX_STEP_START:
                character->SetMotion("\x97\xA7\x82\xBF", 0);
                count = 0;

                if (CheckGetItemLimmitOver(box->item_no, box->item_num) < box->item_num) {
                    message->Preset(4);
                    message->SetWindowMode(4);
                    message->MakeMesWin(0xC);
                    message->fukidashi_pos = 8;
                    step = EDIT_TREASURE_BOX_STEP_FULL_MESSAGE;
                    count = 0;
                } else {
                    ++step;
                    lid->SetRotation(0.0f, 0.0f, 0.0f);
                    sndSePlay(se_base, 0x3C, 0);
                }

                break;
            case EDIT_TREASURE_BOX_STEP_OPEN:
                if (count > 2) {
                    ++step;
                }

                ++count;
                break;
            case EDIT_TREASURE_BOX_STEP_LIFT: {
                float rotation[4];
                lid->GetRotation(rotation);
                rotation[0] -= 0.05f;
                lid->SetRotation(rotation);

                if (rotation[0] < -1.0f) {
                    ++step;
                    box->show = 0;
                    message->Preset(4);
                    message->SetWindowMode(4);
                    int message_no = 0xA;

                    if (box->item_num < 2) {
                        message->item_mes[0] = GetItemMessageNo(box->item_no, 1);
                    } else {
                        message_no = 0xB;
                        message->item_mes[0] = GetItemMessageNo(box->item_no, 1);
                        message->values[1] = box->item_num;
                        message->value_width[1] = 0;
                    }

                    message->MakeMesWin(message_no);
                    message->fukidashi_pos = 8;
                    sndSePlay(GetSystemSndID(), 0x12, 0);
                    GetSaveData()->GetItem(box->item_no, box->item_num);
                }

                count = 0;
                break;
            }
            case EDIT_TREASURE_BOX_STEP_WAIT:
                ++count;

                if (count > 0x14) {
                    ++step;
                }

                break;
            case EDIT_TREASURE_BOX_STEP_MESSAGE:
                if (pad->Btn(0) || pad->Btn(1)) {
                    close_message(message);
                    sndSePlay(GetSystemSndID(), 0x19, 0);
                    ++step;
                }

                break;
            case EDIT_TREASURE_BOX_STEP_DELETE:
                map->DeleteTrBox(data.map_event.point_no, map_flags);
                result = EDIT_EVENT_RESULT_END;
                break;
            case EDIT_TREASURE_BOX_STEP_FULL_MESSAGE:
                if (pad->Btn(0) || pad->Btn(1)) {
                    close_message(message);
                    sndSePlay(GetSystemSndID(), 0x19, 0);
                    ++step;
                }

                break;
            case EDIT_TREASURE_BOX_STEP_END:
                result = EDIT_EVENT_RESULT_END;
                break;
        }
    } else if (type == EDIT_EVENT_TYPE_BOOK) {
        switch (step) {
            case EDIT_BOOK_STEP_START:
                character->SetMotion("\x97\xA7\x82\xBF", 0);
                message->Preset(4);
                message->SetWindowMode(4);
                BookshelfMessageMake(message, argument_1, argument_2, argument_3);
                message->fukidashi_pos = 8;
                step = EDIT_BOOK_STEP_READ;
                count = 0x1E;
                break;
            case EDIT_BOOK_STEP_READ: {
                int message_state = message->State();
                int button = ((bool) pad->Btn(0)) || ((bool) pad->Btn(1));

                switch (message_state) {
                    case 5:
                        if (button) {
                            message->GoNextPage();
                            sndSePlay(GetSystemSndID(), 0x19, 0);
                        }

                        break;
                    case 3:
                        if (button) {
                            step = EDIT_BOOK_STEP_DONE;
                            count = 5;
                            sndSePlay(GetSystemSndID(), 0x19, 0);
                        }

                        break;
                    case 0:
                        step = EDIT_BOOK_STEP_DONE;
                        break;
                }

                --count;

                if (count < 0) {
                    step = EDIT_BOOK_STEP_CLOSE;
                }

                break;
            }
            case EDIT_BOOK_STEP_DONE:
                step = EDIT_BOOK_STEP_CLOSE;
                break;
            case EDIT_BOOK_STEP_CLOSE:
                close_message(message);
                result = EDIT_EVENT_RESULT_END;
                break;
        }
    } else {
        result = EDIT_EVENT_RESULT_END;
    }

    if (result != EDIT_EVENT_RESULT_CONTINUE) {
        if (result != EDIT_EVENT_RESULT_MENU) {
            state = EDIT_EVENT_STATE_END;
            return result;
        }
    }

    return result;
}

int CEditEvent::Draw(CScene *scene) {
    if (state != 1) {
        return 0;
    }

    return 0;
}

int GeoramaFunc(GeoFuncParam *param, RS_STACKDATA *stack, int mode) {
    int command = rsGetStackInt(stack++);

    switch (command) {
        case 1:
            return LoadIntNPC(param, stack, mode - 1);
        case 2:
            return LoadGeoNPC(param, 0);
        case 3:
            return CheckPlaceBurnParts(param, stack, mode - 1);
        case 999:
            printf("warning!!! test function  called!!!\n");
            return 0;
        default:
            return 1;
    }
}

/**
 *
 * Returns whether the active edit map can place burn parts.
 *
 */
static int CheckPlaceBurnParts(GeoFuncParam *param, RS_STACKDATA *args, int argc) {
    if (argc != 1) {
        return 0;
    }

    rsSetStack(args, 0);

    if (param->scene == NULL) {
        return 0;
    }

    CEditMap *map = (CEditMap *) param->scene->GetMap(param->scene->active_map);

    if (map == NULL) {
        return 0;
    }

    rsSetStack(args, map->PlaceBurnParts());
    return 1;
}

/**
 *
 * Loads and places a town NPC named by the current villager identifier.
 *
 */
int LoadIntNPC(GeoFuncParam *param, RS_STACKDATA *stack, int mode) {
    CScene      *scene = param->scene;
    int          villager_id = scene->villager_id;
    char         name[64];
    mgCMemory   *memory;
    int          tex_block;
    int          chara_no;
    CCharacter2 *chara;
    u32         *buffer;
    CEditMap    *map;
    CFuncPoint  *func_point;
    float        position[4];
    float        rotation[4];

    buffer = (u32 *) scene->read_buff;

    if (GetVillagerModelName(villager_id, name) == 0) {
        return 1;
    }

    if (LoadFile2(name, buffer, NULL, 0) == 0) {
        return 0;
    }

    scene->AssignStack(4);
    memory = scene->GetStack(4);

    if (memory->stack_size - memory->stack_used < 0xC800) {
        printf("geo int chara memory over!!\n");
        return 0;
    }

    chara_no = rsGetStackInt(stack);
    tex_block = scene->GetCharaTexb(chara_no);
    mgTexManager.DeleteBlock(tex_block);
    scene->LoadChara(chara_no, buffer, "info.cfg", memory, memory, memory, tex_block, 0);
    chara = scene->GetCharacter(chara_no);

    if (chara == NULL) {
        return 0;
    }

    map = (CEditMap *) scene->GetMap(scene->active_map);

    if (map != NULL) {
        func_point = map->func_point.Search("npc_pos");

        if (func_point != NULL) {
            *(u_long128 *) position = *(u_long128 *) func_point->position;
            *(u_long128 *) rotation = *(u_long128 *) func_point->rotation;
            rotation[2] = 0.0f;
            rotation[0] = 0.0f;
            chara->SetPosition(position);
            chara->SetRotation(rotation);
        }
    }

    scene->SetCharaNo(chara_no, villager_id);
    scene->RegisterVillager(chara_no, villager_id, memory);
    return 1;
}

/**
 *
 * Loads a town NPC at its georama placement or function point.
 *
 */
int LoadGeoNPC(GeoFuncParam *param, int mode) {
    CScene      *scene = param->scene;
    CEditMap    *map;
    CEditParts  *parts;
    int          parts_index;
    int          villager_id;
    u32         *buffer;
    char         name[64];
    mgCMemory   *memory;
    int          tex_block;
    CCharacter2 *chara;
    CFuncPoint  *func_point;
    float        position[4];
    float        rotation[4];
    float        parts_rotation[4];
    float        matrix[4][4];

    if (scene->GetMainMapNo() != 1) {
        return 0;
    }

    map = (CEditMap *) scene->GetMap(scene->active_map);

    if (map == NULL) {
        return 0;
    }

    if (mode == 0) {
        scene->DeleteVillager();
    }

    if (map->GetePlacePartsAtInfoID(0x49, &parts_index, 1) <= 0) {
        return 0;
    }

    parts = map->GetePlaceParts(parts_index);

    if (parts == NULL) {
        return 0;
    }

    villager_id = parts->GetLiveNPC();
    buffer = (u32 *) scene->read_buff;

    if (GetVillagerModelName(villager_id, name) == 0) {
        return 1;
    }

    if (mode != 0) {
        return 1;
    }

    if (LoadFile2(name, buffer, NULL, 0) == 0) {
        return 0;
    }

    scene->AssignStack(2);
    memory = scene->GetStack(2);
    tex_block = scene->GetCharaTexb(8);
    mgTexManager.DeleteBlock(tex_block);
    scene->LoadChara(8, buffer, "info.cfg", memory, memory, memory, tex_block, 0);
    chara = scene->GetCharacter(8);

    if (chara == NULL) {
        return 0;
    }

    func_point = parts->func_point_mngr.Search("npc_pos");

    if (func_point != NULL) {
        parts->GetLWMatrix(matrix);
        *(u_long128 *) position = *(u_long128 *) func_point->position;
        position[3] = 1.0f;
        sceVu0ApplyMatrix(position, matrix, position);
        *(u_long128 *) rotation = *(u_long128 *) func_point->rotation;
        parts->GetRotation(parts_rotation);
        rotation[2] = 0.0f;
        rotation[0] = 0.0f;
        rotation[1] = mgAngleLimit(rotation[1] + parts_rotation[1]);
        chara->SetPosition(position);
        chara->SetRotation(rotation);
        scene->SetActive(1, 8);
    }

    scene->SetCharaNo(8, villager_id);
    return scene->RegisterVillager(8, villager_id, memory);
}

void GeoUpdateNpcPos(CScene *scene) {
    CEditMap    *map;
    CEditParts  *parts;
    int          parts_index;
    int          chara_id;
    CCharacter2 *chara;
    CFuncPoint  *func_point;
    float        position[4];
    float        rotation[4];
    float        parts_rotation[4];
    float        matrix[4][4];

    if (scene->GetMainMapNo() == 1) {
        map = (CEditMap *) scene->GetMap(scene->active_map);

        if (map != NULL && map->GetePlacePartsAtInfoID(0x49, &parts_index, 1) > 0) {
            parts = map->GetePlaceParts(parts_index);

            if (parts != NULL) {
                chara_id = scene->SearchCharaID(parts->GetLiveNPC());
                chara = scene->GetCharacter(chara_id);
                func_point = parts->func_point_mngr.Search("npc_pos");

                if (chara != NULL && func_point != NULL) {
                    scene->StayVillager(chara_id);
                    parts->GetLWMatrix(matrix);
                    *(u_long128 *) position = *(u_long128 *) func_point->position;
                    position[3] = 1.0f;
                    sceVu0ApplyMatrix(position, matrix, position);
                    *(u_long128 *) rotation = *(u_long128 *) func_point->rotation;
                    parts->GetRotation(parts_rotation);
                    rotation[2] = 0.0f;
                    rotation[0] = 0.0f;
                    rotation[1] = mgAngleLimit(rotation[1] + parts_rotation[1]);
                    chara->SetPosition(position);
                    chara->SetRotation(rotation);
                    scene->CancelStayVillager(chara_id);
                }
            }
        }
    }
}
