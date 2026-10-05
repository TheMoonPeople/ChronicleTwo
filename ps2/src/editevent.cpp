#include "common.h"
#include "scenesnd.hpp"
#include "vlgr_info.hpp"
#include "mg_memory.hpp"
#include "dataread.hpp"
#include <cstdio>
#include "runscript.hpp"
#include "savedata.hpp"
#include "character.hpp"
#include "mg_texture.hpp"
#include "mg_math.hpp"
#include "scene.hpp"
#include "editmap.hpp"
#include "editevent.hpp"
#include "dataread.hpp"
#include "cameracontrol.hpp"
#include "editloop.hpp"
#include "editmap.hpp"
#include "editparts.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "mapjump.hpp"
#include "menumain.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "padcontrol.hpp"
#include "runscript.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "userdata.hpp"
#include "vlgr_info.hpp"
#include <cstring>

int LoadIntNPC(GeoFuncParam *param, RS_STACKDATA *stack, int mode);
int LoadGeoNPC(GeoFuncParam *param, int mode);
int CheckPlaceBurnParts(GeoFuncParam *param, RS_STACKDATA *stack, int mode);

const int kEventNumberF9 = 0xF9;
const int kEventFlagTypeAB = 0x8;
const int kEventFlagTypeA = 0x10;
const int kEventFlagSetNumber = 0x80;
const int kEventFlagTypeC = 0x200;
const int kEventFlagTypeD = 0x400;

extern "C" char at_1209[];
extern "C" char at_1210[];
extern "C" char at_1211__2[];
extern char at_888__3[];
extern char at_1175__2[];

extern "C" float mgGetProjection__Fv();
extern mgCTextureManager mgTexManager;
#include <cstdio>
#include <cmath>

static int CheckPlaceBurnParts(GeoFuncParam *param, RS_STACKDATA *args, int argc);
static int LoadIntNPC(GeoFuncParam *param, RS_STACKDATA *args, int argc);
static int LoadGeoNPC(GeoFuncParam *param, int check_only);

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
    if (state == 1 || state == 2) {
        printf(at_888__3);
        return 0;
    }
    state = 1;
    count = 0;
    step = 0;
    type = -1;
    data = *event_data;
    if (*(int *)&data.head.v[0] & kEventFlagTypeAB) {
        if (*(int *)&data.head.v[0] & kEventFlagTypeA) {
            type = 0;
        } else {
            type = 1;
        }
        if (*(int *)&data.head.v[0] & kEventFlagSetNumber) {
            *(int *)&data.head.v[2] = kEventNumberF9;
        }
    }
    if (*(int *)&data.head.v[0] & kEventFlagTypeC) {
        type = 2;
    }
    if (*(int *)&data.head.v[0] & kEventFlagTypeD) {
        type = 3;
    }
    if (type == -1) {
        return 0;
    }
    projection = mgGetProjection__Fv();
    return 1;
}
#ifdef NONMATCHING
int CEditEvent::Step(CScene *scene) {
    if (state != EDIT_EVENT_STATE_RUNNING) return EDIT_EVENT_RESULT_IDLE;
    ++count;
    CEditMap *map = (CEditMap *)scene->GetMap(scene->active_map);
    CSaveData *save = GetSaveData();
    CMapFlagData *map_flags = save->GetMapFlag(scene->GetMainMapNo());
    CCharacter2 *character = scene->GetCharacter(scene->player_chara);
    mgCCamera *camera = scene->GetCamera(scene->active_camera);
    if (character == NULL || camera == NULL || map == NULL) return EDIT_EVENT_RESULT_END;
    ClsMes *message = scene->GetMessage(1);
    int result = EDIT_EVENT_RESULT_CONTINUE;
    float camera_pos[4], chara_pos[4], chara_rot[4];
    camera->GetPos(camera_pos);
    character->GetPosition(chara_pos);
    character->GetRotation(chara_rot);

    if (type == EDIT_EVENT_TYPE_HOUSE_DOOR) {
        switch (step) {
        case EDIT_HOUSE_DOOR_STEP_OPEN_MENU:
            MenuArg.open_type = 0xC;
            MenuArg.scene = scene;
            MenuArg.param[0] = data.chara_no;
            ((CCameraControl *)camera)->CancelRotBack();
            KeepEditAnalyze();
            ++step;
            result = EDIT_EVENT_RESULT_MENU;
            break;
        case EDIT_HOUSE_DOOR_STEP_MENU_END:
            mgSetProjection(projection);
            if (MenuArg.end_code == 9) {
                type = EDIT_EVENT_TYPE_DOOR;
                count = step = 0;
            } else {
                ++step;
                EditDataSave();
                CEditParts *parts = map->GetePlaceParts(data.chara_no);
                if (MenuArg.end_code == 0xD && parts != NULL && parts->GetInfoID() == 0x49) {
                    scene->fade.FadeOut(0x12, 0.0f, 0.0f, 0.0f);
                    reload_geo_npc = 1;
                } else {
                    count = 0x14;
                    reload_geo_npc = 0;
                }
            }
            break;
        case EDIT_HOUSE_DOOR_STEP_WAIT:
            if (count >= 0x14 || scene->fade.FadeCheck()) {
                if (reload_geo_npc) {
                    scene->fade.FadeIn(0x14);
                    GeoFuncParam param = {scene};
                    LoadGeoNPC(&param, 0);
                }
                if (EditAnalyzeChanged()) scene->RunEvent(0x136, NULL);
                result = EDIT_EVENT_RESULT_END;
            }
            break;
        }
    } else if (type == EDIT_EVENT_TYPE_DOOR) {
        float *door_pos = data.map_event.matrix[3];
        float target_angle = atan2f(data.map_event.matrix[2][0], data.map_event.matrix[2][2]);
        switch (step) {
        case EDIT_DOOR_STEP_START:
            if (strcmp(data.event.unk_38, "exit") != 0) {
                strcpy(map_name, data.event.unk_38);
                if (data.event.flag & FUNC_EVENT_ED_DOOR) {
                    CEditParts *parts = map->GetePlaceParts(data.chara_no);
                    int villager = parts != NULL ? parts->GetLiveNPC() : -1;
                    CVillagerInfo *info = GetVillagerInfo(villager);
                    reload_geo_npc = villager;
                    if (strlen(map_name) < 4) {
                        static const char *suffix[4] = {"ia", "ib", "ic", "id"};
                        strcat(map_name, info != NULL ? suffix[info->house_type % 4] : "ia");
                    }
                }
                ((CCameraControl *)camera)->RotBack(mgAngleLimit(3.1415927f + target_angle));
            }
            door_se = -1;
            memcpy(return_pos, chara_pos, sizeof(return_pos));
            memcpy(return_rot, chara_rot, sizeof(return_rot));
            step = EDIT_DOOR_STEP_APPROACH;
            break;
        case EDIT_DOOR_STEP_APPROACH: {
            character->SetMotion("\225\340\202\253", 0);
            float rotation[4] = {0.0f, mgAngleInterpolate(chara_rot[1], target_angle, 0.3f, 0), 0.0f, 1.0f};
            float position[4];
            mgVectorInterpolate(position, chara_pos, door_pos, 1.0f, 0);
            if (mgDistVector(data.map_event.matrix[0]) < 20.0f) character->SetPosition(position);
            character->SetRotation(rotation);
            if ((!mgAngleCmp(rotation[1], target_angle, 0.1f) && mgDistVectorXZ(position, door_pos) < 1.0f) || count > 200) {
                step = EDIT_DOOR_STEP_OPEN;
                count = data.event.unk_2c < 0 ? 0xE : 0;
                if (data.event.unk_2c >= 0)
                    character->SetMotion((char *)(data.event.flag & FUNC_EVENT_CLOSE_DOOR ? "\203h\203A\212J\202\251\202\310\202\242" : "\203h\203A\212J\202\257"), 2);
            }
            break;
        }
        case EDIT_DOOR_STEP_OPEN:
            if (data.event.flag & FUNC_EVENT_CLOSE_DOOR) {
                if (character->CheckMotionEnd() || count >= 0x3D || !scene->CheckDrawChara(scene->player_chara)) step = EDIT_DOOR_STEP_RETURN;
                if (count == 0x1E) scene->SePlayOpenDoor(0x18, door_pos);
            } else {
                if (count == 0xF && (data.event.flag & FUNC_EVENT_UNK_100)) scene->fade.FadeOut(0x1E, 0.0f, 0.0f, 0.0f);
                if (count == 0x14) {
                    scene->SePlayOpenDoor(data.event.unk_30, door_pos);
                    door_se = data.event.unk_30;
                }
                if (count >= 0x10 && scene->fade.FadeCheck()) step = EDIT_DOOR_STEP_LEAVE;
            }
            break;
        case EDIT_DOOR_STEP_LEAVE:
            ((CCameraControl *)camera)->CancelRotBack();
            if (data.event.point_no > 0) {
                scene->RunEvent(data.event.point_no, &data);
                result = EDIT_EVENT_RESULT_END;
            } else if (scene->fade.FadeCheck()) {
                if (!strcmp(data.event.unk_38, "exit")) {
                    scene->fade.FadeIn(0x1E);
                    result = EDIT_EVENT_RESULT_EXIT;
                } else {
                    PreLoadSync();
                    scene->fade.FadeIn(0x1E);
                    result = data.event.flag & FUNC_EVENT_ED_DOOR ? EDIT_EVENT_RESULT_ENTER_HOUSE : EDIT_EVENT_RESULT_ENTER;
                }
            }
            break;
        case EDIT_DOOR_STEP_RETURN: {
            float position[4];
            mgVectorInterpolate(position, chara_pos, return_pos, 1.0f, 0);
            float rotation[4] = {0.0f, mgAngleInterpolate(chara_rot[1], atan2f(camera_pos[0] - chara_pos[0], camera_pos[2] - chara_pos[2]), 0.2f, 0), 0.0f, 1.0f};
            if (mgDistVector(position, return_pos) < 1.0f) {
                step = EDIT_DOOR_STEP_WAIT;
                character->SetMotion("\202\276\202\337\202\276\202\337", 2);
            } else character->SetMotion("\225\340\202\253", 0);
            character->SetPosition(position);
            character->SetRotation(rotation);
            break;
        }
        case EDIT_DOOR_STEP_WAIT:
            if (character->CheckMotionEnd() || count >= 301 || !scene->CheckDrawChara(scene->player_chara)) result = EDIT_EVENT_RESULT_END;
            break;
        }
    } else if (type == EDIT_EVENT_TYPE_TREASURE_BOX) {
        CMapTreasureBox *box = map->GetTrBox(data.chara_slot);
        mgCFrame *lid = box != NULL && box->CObjectFrame::frame != NULL ? box->CObjectFrame::frame->SearchFrame("top") : NULL;
        if (lid == NULL) { step = EDIT_TREASURE_BOX_STEP_DELETE; result = EDIT_EVENT_RESULT_END; }
        else switch (step) {
        case EDIT_TREASURE_BOX_STEP_START:
            character->SetMotion("\227\247\202\277", 0);
            count = 0;
            if (CheckGetItemLimmitOver(box->item_no, box->item_num) < box->item_num) {
                message->Preset(4);
                message->SetWindowMode(4);
                message->MakeMesWin(0xC);
                step = EDIT_TREASURE_BOX_STEP_FULL_MESSAGE;
            } else {
                step = EDIT_TREASURE_BOX_STEP_OPEN;
                lid->SetRotation(0.0f, 0.0f, 0.0f);
                sndSePlay(scene->se_base_id, 0x3C, 0);
            }
            break;
        case EDIT_TREASURE_BOX_STEP_OPEN:
            if (++count >= 3) step = EDIT_TREASURE_BOX_STEP_LIFT;
            break;
        case EDIT_TREASURE_BOX_STEP_LIFT: {
            float rotation[4];
            lid->GetRotation(rotation);
            rotation[0] -= 0.05f;
            lid->SetRotation(rotation);
            if (rotation[0] < -1.0f) {
                step = EDIT_TREASURE_BOX_STEP_WAIT;
                box->active = 0;
                message->Preset(4);
                message->SetWindowMode(4);
                message->MakeMesWin(box->item_num < 2 ? 0xA : 0xB);
                sndSePlay(GetSystemSndID(), 0x12, 0);
                save->GetItem(box->item_no, box->item_num);
            }
            count = 0;
            break;
        }
        case EDIT_TREASURE_BOX_STEP_WAIT:
            if (++count >= 0x15) step = EDIT_TREASURE_BOX_STEP_MESSAGE;
            break;
        case EDIT_TREASURE_BOX_STEP_MESSAGE:
        case EDIT_TREASURE_BOX_STEP_FULL_MESSAGE:
            if (PadCtrl.Btn(0) || PadCtrl.Btn(1)) {
                message->Preset(0);
                sndSePlay(GetSystemSndID(), 0x19, 0);
                ++step;
            }
            break;
        case EDIT_TREASURE_BOX_STEP_DELETE:
            map->DeleteTrBox(data.chara_slot, map_flags);
            result = EDIT_EVENT_RESULT_END;
            break;
        case EDIT_TREASURE_BOX_STEP_END:
            result = EDIT_EVENT_RESULT_END;
            break;
        }
    } else if (type == EDIT_EVENT_TYPE_BOOK) {
        switch (step) {
        case EDIT_BOOK_STEP_START:
            character->SetMotion("\227\247\202\277", 0);
            message->Preset(4);
            message->SetWindowMode(4);
            BookshelfMessageMake(message, data.event.unk_2c, data.event.unk_30, data.event.unk_34);
            step = EDIT_BOOK_STEP_READ;
            count = 0x1E;
            break;
        case EDIT_BOOK_STEP_READ:
            if (message->State() == 0) step = EDIT_BOOK_STEP_DONE;
            else if (PadCtrl.Btn(0) || PadCtrl.Btn(1)) {
                if (message->State() == 5) message->GoNextPage();
                else if (message->State() == 3) { step = EDIT_BOOK_STEP_DONE; count = 5; }
                sndSePlay(GetSystemSndID(), 0x19, 0);
            }
            if (--count < 0) step = EDIT_BOOK_STEP_CLOSE;
            break;
        case EDIT_BOOK_STEP_DONE:
            step = EDIT_BOOK_STEP_CLOSE;
            break;
        case EDIT_BOOK_STEP_CLOSE:
            message->Preset(0);
            result = EDIT_EVENT_RESULT_END;
            break;
        }
    } else result = EDIT_EVENT_RESULT_END;
    if (result != EDIT_EVENT_RESULT_CONTINUE && result != EDIT_EVENT_RESULT_MENU) state = EDIT_EVENT_STATE_END;
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editevent", Step__10CEditEventFP6CScene);
#endif
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
            printf(at_1175__2);
            return 0;
        default:
            return 1;
    }
}
static int CheckPlaceBurnParts(GeoFuncParam *param, RS_STACKDATA *args, int argc) {
    if (argc != 1) return 0;
    rsSetStack(args, 0);
    if (param->scene == NULL) return 0;
    CEditMap *map = (CEditMap *)param->scene->GetMap(param->scene->active_map);
    if (map == NULL) return 0;
    rsSetStack(args, map->PlaceBurnParts());
    return 1;
}
int LoadIntNPC(GeoFuncParam *param, RS_STACKDATA *stack, int mode) {
    CScene *scene = param->scene;
    int villager_id = scene->villager_id;
    char name[64];
    mgCMemory *memory;
    int tex_block;
    int chara_no;
    CCharacter2 *chara;
    u32 *buffer;
    CEditMap *map;
    CFuncPoint *func_point;
    float position[4];
    float rotation[4];

    buffer = (u32 *)scene->read_buff;
    if (GetVillagerModelName(villager_id, name) == 0) {
        return 1;
    }
    if (LoadFile2(name, buffer, NULL, 0) == 0) {
        return 0;
    }
    scene->AssignStack(4);
    memory = scene->GetStack(4);
    if (memory->stack_size - memory->stack_used < 0xC800) {
        printf(at_1209);
        return 0;
    }
    chara_no = rsGetStackInt(stack);
    tex_block = scene->GetCharaTexb(chara_no);
    mgTexManager.DeleteBlock(tex_block);
    scene->LoadChara(chara_no, buffer, at_1210, memory, memory, memory, tex_block, 0);
    chara = scene->GetCharacter(chara_no);
    if (chara == NULL) {
        return 0;
    }
    map = (CEditMap *)scene->GetMap(scene->active_map);
    if (map != NULL) {
        func_point = map->func_point.Search(at_1211__2);
        if (func_point != NULL) {
            *(u_long128 *)position = *(u_long128 *)func_point->position;
            *(u_long128 *)rotation = *(u_long128 *)func_point->rotation;
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
int LoadGeoNPC(GeoFuncParam *param, int mode) {
    CScene *scene = param->scene;
    CEditMap *map;
    CEditParts *parts;
    int parts_index;
    int villager_id;
    u32 *buffer;
    char name[64];
    mgCMemory *memory;
    int tex_block;
    CCharacter2 *chara;
    CFuncPoint *func_point;
    float position[4];
    float rotation[4];
    float parts_rotation[4];
    float matrix[4][4];

    if (scene->GetMainMapNo() != 1) {
        return 0;
    }
    map = (CEditMap *)scene->GetMap(scene->active_map);
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
    buffer = (u32 *)scene->read_buff;
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
    scene->LoadChara(8, buffer, at_1210, memory, memory, memory, tex_block, 0);
    chara = scene->GetCharacter(8);
    if (chara == NULL) {
        return 0;
    }
    func_point = parts->func_point_mngr.Search(at_1211__2);
    if (func_point != NULL) {
        parts->GetLWMatrix(matrix);
        *(u_long128 *)position = *(u_long128 *)func_point->position;
        position[3] = 1.0f;
        sceVu0ApplyMatrix(position, matrix, position);
        *(u_long128 *)rotation = *(u_long128 *)func_point->rotation;
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
    CEditMap *map;
    CEditParts *parts;
    int parts_index;
    int chara_id;
    CCharacter2 *chara;
    CFuncPoint *func_point;
    float position[4];
    float rotation[4];
    float parts_rotation[4];
    float matrix[4][4];

    if (scene->GetMainMapNo() == 1) {
        map = (CEditMap *)scene->GetMap(scene->active_map);
        if (map != NULL && map->GetePlacePartsAtInfoID(0x49, &parts_index, 1) > 0) {
            parts = map->GetePlaceParts(parts_index);
            if (parts != NULL) {
                chara_id = scene->SearchCharaID(parts->GetLiveNPC());
                chara = scene->GetCharacter(chara_id);
                func_point = parts->func_point_mngr.Search(at_1211__2);
                if (chara != NULL && func_point != NULL) {
                    scene->StayVillager(chara_id);
                    parts->GetLWMatrix(matrix);
                    *(u_long128 *)position = *(u_long128 *)func_point->position;
                    position[3] = 1.0f;
                    sceVu0ApplyMatrix(position, matrix, position);
                    *(u_long128 *)rotation = *(u_long128 *)func_point->rotation;
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

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_920__4__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_888__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_916__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_917__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_918__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_919__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_1133__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_1134__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_1135__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_1136__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_1137__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_1138__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_1139__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_1154__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_1152__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_1175__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_1209__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_1210__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", at_1211__2__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editevent", MenuInfo__2__DATA);
