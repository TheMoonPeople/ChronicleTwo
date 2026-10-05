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

// Code (.text)
void CEditEvent::Reset(void) {
    state = 0;
    unk_c = 0;
    count = 0;
    type = -1;
    door_se = -1;
    *(int *)map_name = 0;
    memset(&data, 0, 0xD0);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editevent", Step__10CEditEventFP6CScene);
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
int CheckPlaceBurnParts(GeoFuncParam *param, RS_STACKDATA *stack, int mode) {
    CEditMap *map;
    CScene *scene;

    if (mode != 1) {
        return 0;
    }
    rsSetStack(stack, 0);
    scene = param->scene;
    if (scene == NULL) {
        return 0;
    }
    map = (CEditMap *)scene->GetMap(scene->active_map);
    if (map == NULL) {
        return 0;
    }
    rsSetStack(stack, map->PlaceBurnParts());
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
