#include "common.h"
#include "character.hpp"
#include "map.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "sceneevent.hpp"
#include "scenesnd.hpp"
#include "userdata.hpp"
#include "villagermngr.hpp"
#include "vlgr_info.hpp"
#include "scenevillager.hpp"
#include "mainloop.hpp"
#include "dataread.hpp"
#include "funcpoint.hpp"
#include "mglib.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include <cstring>

extern char *motion_name[];
extern GAMEOBJ_INFO GameObjInfo[];
extern float at_868__4[4];
extern char at_991__4[];
extern char at_992__3[];
extern char at_815__3[];
extern char at_1335[];
extern char at_1336[];
extern char at_1337[];
extern char at_1338[];
extern char at_1339__2[];
extern char at_1441__3[];
extern char at_1442__2[];
extern char at_1443__2[];
extern char at_1444__2[];
extern char at_1445__2[];
extern char at_1446__2[];
extern char at_1447__2[];
extern char at_1448__2[];
extern char at_1449__2[];
extern char at_1464__4[];
extern char at_1592__4[];
extern char at_1593__3[];
extern char at_1594__4[];
extern char at_1595__5[];
extern char at_1842__3[];
extern char at_1843__3[];
extern char at_1844__3[];
extern char at_1845__2[];
extern char at_1846__2[];
extern char at_1847__2[];

// Code (.text)
int GetChrFileSize(u32 *pack, int file_size) {
    u32 *files[8];
    int sizes[8];
    int count = GetPackFileExt(pack, at_815__3, files, 8, sizes, NULL);
    int total = 0;
    int i = 0;
    int size;
    for (i = 0; i < count; i++) {
        total += sizes[i];
    }
    size = (file_size - total) + (total / 3 + total * 3);
    if (size % 1024 != 0) {
        size = (size / 1024) * 1024 + 1024;
    }
    return size;
}
int CScene::CheckDrawChara(int index) {
    if (IsActive(1, index) == 0) {
        return 0;
    }
    int status = GetStatus(1, index);
    if (status & SCENE_CHARA_HIDE) {
        return 0;
    }
    return ((status & SCENE_CHARA_NO_MODEL) != 0) ^ 1;
}
int CScene::CheckDrawCharaShadow(int index) {
    if (IsActive(1, index) == 0) {
        return 0;
    }
    int status = GetStatus(1, index);
    if (status & SCENE_CHARA_HIDE) {
        return 0;
    }
    return ((status & SCENE_CHARA_NO_SHADOW) != 0) ^ 1;
}
int CScene::StepChara(int index) {
    float entry_pos[4];
    CCharacter2 *chara = GetCharacter(index);
    if (chara == NULL) {
        return 0;
    }
    chara->foot_se_bank = se_base_id;
    if (chara->CheckDraw() == 0) {
        return 0;
    }
    if (CheckDrawChara(index) == 0 && CheckDrawCharaShadow(index) == 0) {
        return 0;
    }
    chara->SetWind(wind_power, wind_dir);
    if (chara->GetEntryObjectPos(1, entry_pos) != 0) {
        chara->SetFloor(entry_pos[1]);
    }
    chara->Step();
    return 1;
}
void CScene::GetCharaLighting(float (*lights)[4], float *ambient) {
    CMap *map = GetMap(active_map);
    if (map != NULL) {
        float light_scale = 0.3f;
        float ambient_scale = 1.8f;
        float ambient_floor = 56.0f;
        union {
            float f[4];
            u_long128 word;
        } limit;
        int i;
        float lowest;
        float next;
        float third;
        if (map->chara_light_adjust != 0) {
            light_scale = map->chara_light_adjust_value[0];
            ambient_scale = map->chara_light_adjust_value[1];
            ambient_floor = 128.0f * map->chara_light_adjust_value[2];
        }
        limit = *(typeof(limit) *)at_868__4;
        for (i = 0; i < 4; i++) {
            sceVu0ScaleVectorXYZ(lights[i], lights[i], light_scale);
            mgVectorMin(lights[i], lights[i], limit.f);
        }
        sceVu0ScaleVectorXYZ(ambient, ambient, ambient_scale);
        lowest = ambient[0] < ambient[1] ? (ambient[0] < ambient[2] ? ambient[0] : ambient[2])
                                         : (ambient[1] < ambient[2] ? ambient[1] : ambient[2]);
        if (lowest < ambient_floor) {
            float lift = ambient_floor - lowest;
            ambient[0] += lift;
            ambient[1] += lift;
            ambient[2] += lift;
        }
        if (!(ambient[0] <= 128.0f)) {
            ambient[0] = 128.0f;
        }
        if (!(ambient[1] <= 128.0f)) {
            ambient[1] = 128.0f;
        }
        if (!(ambient[2] <= 128.0f)) {
            ambient[2] = 128.0f;
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/scenevillager", DrawChara__6CSceneFii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/scenevillager", DrawCharaShadow__6CSceneFi);
void CScene::DrawExclamationMark(mgCFrame *frame) {
    float position[4];
    int index;
    if (frame != NULL) {
        for (index = 0; index < SCENE_CHARA_SLOT_NUM; index++) {
            if (CheckDrawChara(index) != 0) {
                CCharacter2 *chara = GetCharacter(index);
                if (chara != NULL && (GetStatus(1, index) & SCENE_CHARA_EXCLAMATION) != 0) {
                    chara->GetPosition(position);
                    if (chara->body_height > 0.0f) {
                        position[1] -= 32.0f;
                        position[1] += 2.0f * chara->body_height;
                    }
                    frame->SetPosition(position);
                    mgDrawDirect(frame);
                }
            }
        }
    }
}
int CScene::SearchCharaTexb(int slot) {
    int texb;
    int other;
    int i;
    int j;

    texb = GetCharaTexb(slot);
    i = 0;
    if (texb < 0) {
        return -1;
    }
    do {
        j = i + SCENE_VILLAGER_SLOT_TOP;
        if (j != slot) {
            other = GetCharaTexb(j);
            if ((other >= 0) && (other == texb)) {
                return j;
            }
        }
        i += 1;
    } while (i < (SCENE_VILLAGER_SLOT_NUM + SCENE_SUB_VILLAGER_SLOT_NUM));
    return -1;
}
int CScene::PreLoadVillager(int map_id, u_long128 *cache) {
    int chara_ids[32];
    CVillagerPlaceInfo *places[32];
    char model_name[0x100];
    int count;
    int i;
    count = GetLoadVillagerList(map_id, chara_ids, places);
    InitFileCache(cache, 1);
    for (i = 0; i < count; i++) {
        if (GetVillagerModelName(chara_ids[i], model_name) != 0) {
            LoadFileCacheBG(model_name);
        }
    }
    return count;
}
void CScene::PreLoadVillagerEnd() {
    DeleteFileCache();
}
int CScene::DeleteVillager(int chara_id) {
    villager_mngr.DeleteCharaID(chara_id);
    return 1;
}
void CScene::DeleteSubVillager() {
    mgCTextureManager *tex_manager = &mgTexManager;
    int i;
    for (i = 0; i < SCENE_SUB_VILLAGER_SLOT_NUM; i++) {
        int texb = GetCharaTexb(i + SCENE_SUB_VILLAGER_SLOT_TOP);
        if (texb > 0 && SearchCharaTexb(i + SCENE_SUB_VILLAGER_SLOT_TOP) < 0) {
            tex_manager->DeleteBlock(texb);
        }
        DeleteChara(i + SCENE_SUB_VILLAGER_SLOT_TOP);

        villager_mngr.DeleteCharaID(i + SCENE_SUB_VILLAGER_SLOT_TOP);
    }
    ClearStack(4);
    sub_villager_time = -1;
}
void CScene::DeleteVillager() {
    mgCTextureManager *tex_manager = &mgTexManager;
    int i;
    for (i = 0; i < SCENE_VILLAGER_SLOT_NUM; i++) {
        int texb = GetCharaTexb(i + SCENE_VILLAGER_SLOT_TOP);
        if (texb > 0 && SearchCharaTexb(i + SCENE_VILLAGER_SLOT_TOP) < 0) {
            tex_manager->DeleteBlock(texb);
        }
        DeleteChara(i + SCENE_VILLAGER_SLOT_TOP);

        villager_mngr.DeleteCharaID(i + SCENE_VILLAGER_SLOT_TOP);
    }
    ClearStack(2);
    villager_time = -1;
}
int CScene::SearchCharaID(int chara_id) {
    int i = SCENE_VILLAGER_SLOT_TOP;
    do {
        int no = GetCharaNo(i);
        if (no == chara_id) {
            return i;
        }
        i++;
    } while (i < SCENE_TALK_SLOT_END);
    return -1;
}
int CScene::GetNowVillagerTime() {
    int is_night;

    float end_hour = 6.0f;
    float start_hour = 21.0f;

    is_night = 0;
    if (CheckTime(time, start_hour, end_hour) != 0) {
        is_night = 1;
    }
    return is_night;
}
int CScene::GetLoadVillagerList(int map_id, int *chara_ids, CVillagerPlaceInfo **places) {
    CSaveData *save = save_data;
    int chapter;
    int villager_time;
    int count;
    int i;
    CUserDataManager *user_data;
    if (save == NULL) {
        return 0;
    }
    if (map_id < 0) {
        return 0;
    }
    chapter = save->game_progress;
    villager_time = GetNowVillagerTime();
    count = villager_mngr.GetAppearVlgr(chapter, villager_time, map_id, chara_ids, places);
    user_data = &save_data->user_data;
    if (user_data == NULL) {
        return count;
    }
    for (i = 0; i < count; i++) {
        if (user_data->GetPartyCharaStatus(chara_ids[i]) > 0) {
            chara_ids[i] += 1000;
        }
    }
    return count;
}
int CScene::SearchCopyModel(int villager_id) {
    CVillagerInfo *info = GetVillagerInfo(villager_id);
    int i;
    if (info == NULL) {
        return -1;
    }
    for (i = 0; i < (SCENE_VILLAGER_SLOT_NUM + SCENE_SUB_VILLAGER_SLOT_NUM); i++) {
        int slot = i + SCENE_VILLAGER_SLOT_TOP;
        CSceneCharacter *scene_chara = GetSceneCharacter(slot);
        if (scene_chara != NULL && GetCharacter(slot) != NULL) {
            CVillagerInfo *other = GetVillagerInfo(scene_chara->chara_no);
            if (other != NULL && other->model_name != NULL && info->model_name != NULL &&
                strcmp(other->model_name, info->model_name) == 0) {
                return slot;
            }
        }
    }
    return -1;
}
int GetObjectNameList(char *names, CCharacter2 *chara, mgCFrame **frames, int max) {
    char name[64];
    char *cursor;
    int count;
    mgCFrame *model;
    int index;
    if (names == NULL || max <= 0 || chara == NULL) {
        return 0;
    }
    model = chara->CObjectFrame::frame;
    count = 0;
    if (model == NULL) {
        return 0;
    }
    index = 0;
    while ((s8)*names != 0) {
        if (!(count < max)) {
            return count;
        }
        cursor = name;
        for (;;) {
            if ((s8)*names == ';' || (s8)*names == 0) {
                break;
            }
            *cursor++ = (s8)*names++;
        }
        *cursor = 0;
        frames[index] = model->SearchFrame(name);
        if ((s8)*names == 0) {
            count++;
            break;
        }
        names++;
        if (frames[index] != NULL) {
            index++;
            count++;
        }
    }
    return count;
}
extern "C" mgCFrameAttr *__ct__12mgCFrameAttrFv(mgCFrameAttr *);
void CScene::CharaObjectOnOff(int index, mgCMemory *memory) {
    mgCFrame *frames[16];
    CVillagerInfo *info;
    int i;
    CCharacter2 *chara;
    int j;
    CSceneCharacter *scene_chara = GetSceneCharacter(index);
    if (scene_chara == NULL) {
        return;
    }
    chara = scene_chara->chara;
    if (chara == NULL) {
        return;
    }
    info = GetVillagerInfo(scene_chara->chara_no);
    if (info == NULL) {
        return;
    }
    int count = GetObjectNameList(info->show_frames, chara, frames, 16);
    for (i = 0; i < count; i++) {
        if (frames[i] != NULL) {
            mgCFrameAttr *attr = frames[i]->attr;
            if (attr == NULL && memory != NULL) {
                if ((attr = (mgCFrameAttr *)operator new(0x90, (u_long128 *)memory->Alloc(0xB))) != NULL) {
                    attr = __ct__12mgCFrameAttrFv(attr);
                }
                frames[i]->attr = attr;
            }
            if (attr != NULL) {
                attr->draw = 1;
            }
        }
    }
    count = GetObjectNameList(info->hide_frames, chara, frames, 16);
    for (j = 0; j < count; j++) {
        if (frames[j] != NULL) {
            mgCFrameAttr *attr = frames[j]->attr;
            if (attr == NULL && memory != NULL) {
                if ((attr = (mgCFrameAttr *)operator new(0x90, (u_long128 *)memory->Alloc(0xB))) != NULL) {
                    attr = __ct__12mgCFrameAttrFv(attr);
                }
                frames[j]->attr = attr;
            }
            if (attr != NULL) {
                attr->draw = 2;
            }
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/scenevillager", LoadVillager__6CSceneFii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/scenevillager", LoadSubVillager__6CSceneFii);
void CScene::RegisterVillager(int chara_id, int slot, int place_no) {
    RegisterVillager(chara_id, slot, GetVlgrPlaceInfo(place_no));
}
int CScene::RegisterVillager(int chara_id, int slot, CVillagerPlaceInfo *place) {
    return villager_mngr.Register(slot, chara_id, place);
}
int CScene::RegisterVillager(int chara_id, int slot, mgCMemory *memory) {
    float character_position[4];
    CCharacter2 *chara;
    CVillagerPlaceInfo *place_info;
    if ((place_info = (CVillagerPlaceInfo *)operator new(sizeof(CVillagerPlaceInfo),
                                                        (u_long128 *)memory->Alloc(6))) != NULL) {
        memset(place_info, 0, sizeof(CVillagerPlaceInfo));
        place_info->map_no = -1;
    }
    if (place_info == NULL) {
        return 0;
    }
    chara = GetCharacter(chara_id);
    if (chara == NULL) {
        return 0;
    }
    chara->GetPosition(place_info->pos);
    chara->GetRotation(character_position);
    place_info->pos[3] = character_position[1];
    return RegisterVillager(chara_id, slot, place_info);
}
int CScene::GetTalkEvent(float *position, CSceneEventData *event) {
    float character_position[4];
    float character_rotation[4];
    float talk_rect[4];
    float rotation[4][4];
    CSceneEventData cleared_event;
    float range;
    int slot;
    for (slot = SCENE_VILLAGER_SLOT_TOP; slot < SCENE_TALK_SLOT_END; slot++) {
        range = 30.0f;
        if (IsActive(1, slot) != 0) {
            CCharacter2 *chara = GetCharacter(slot);
            if (chara != NULL) {
                int rect_kind;
                chara->GetPosition(character_position);
                chara->GetRotation(character_rotation);
                rect_kind = villager_mngr.GetTalkRect(slot, talk_rect);
                if (rect_kind >= 0) {
                    if (!(talk_rect[3] <= 0.0f)) {
                        range = talk_rect[3];
                    }
                    talk_rect[3] = 1.0f;
                    if (rect_kind != 0) {
                        mgUnitMatrix(rotation);
                        mgCreateMatrixPY(rotation, character_position, character_rotation[1]);
                        sceVu0ApplyMatrix(character_position, rotation, talk_rect);
                    }
                    if (mgDistVector(character_position, position) < range) {

                        memset(&cleared_event, 0, sizeof(cleared_event));
                        event->chara_slot = slot;
                        event->chara_no = GetCharaNo(slot);
                        event->event.point_no = slot - SCENE_VILLAGER_SLOT_TOP;
                        return 1;
                    }
                }
            }
        }
    }
    return 0;
}
static char *GetMotionName(int motion_id) {
    switch (motion_id) {
        case 1:
            return motion_name[1];
        case 2:
            return motion_name[2];
        case 3:
            return motion_name[3];
        case 4:
            return motion_name[4];
        case 5:
            return motion_name[5];
        case 6:
            return motion_name[6];
        case 7:
            return motion_name[7];
        case 8:
            return motion_name[8];
        default:
            return motion_name[0];
    }
}
int GetMotionID(char *name) {
    int i;
    if (name == NULL) {
        return -1;
    }
    for (i = 0; motion_name[i] != NULL; i++) {
        if (strcmp(name, motion_name[i]) == 0) {
            return i;
        }
    }
    return -1;
}
void SetCharaMotion(CCharacter2 *chara, int motion_id, int mode) {
    char *name = GetMotionName(motion_id);
    if (name != NULL) {
        if (motion_id == 4 && chara->GetKeyListPtr(name, NULL) == NULL) {
            name = GetMotionName(0);
        }
        if (name != NULL) {
            chara->SetMotion(name, mode);
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/scenevillager", StepVillager__6CSceneFv);
void CScene::StayNearVillager(float *position, int *stayed) {

    CScene *scene = this;
    int count = villager_mngr.data_num;
    int i;
    if (scene->villager_mngr.stop == 0) {
        for (i = 0; i < count; i++) {
            CVillagerData *villager;
            stayed[i] = 0;
            villager = scene->villager_mngr.GetData(i);
            if (villager != NULL) {
                int unusable = villager->vlgr_id < 0 || !(villager->place != NULL);
                if (!(unusable & 0xFF) && villager->stay <= 0 &&
                    mgDistVectorXZ(position, villager->pos) < position[3]) {
                    CCharacter2 *chara;
                    scene->villager_mngr.Stay(i);
                    chara = scene->GetCharacter(villager->chara_id);
                    if (chara != NULL) {
                        int motion = GetMotionID(chara->GetNowMotionName());
                        if (chara != NULL && scene->villager_mngr.CheckStay(i) != 0) {
                            CVillagerPlaceInfo *place = villager->place;
                            if (motion == place->move_motion) {
                                SetCharaMotion(chara, place->motion, 0);
                            }
                        }
                        stayed[i] = 1;
                    }
                }
            }
        }
    }
}
void CScene::CancelStayVillager(int *flags) {

    CScene *scene = this;
    int i = 0;
    int count = scene->villager_mngr.data_num;
    if (0 < count) {
        do {
            if (flags[i] != 0) {
                scene->villager_mngr.CancelStay(i);
            }
            i++;
        } while (i < count);
    }
}
void CScene::StayVillager(int chara_id) {
    CScene *scene = this;
    int index = scene->villager_mngr.SearchDataIDatCharaID(chara_id);
    if (index >= 0) {
        scene->villager_mngr.Stay(index);
    }
}
void CScene::CancelStayVillager(int chara_id) {

    CScene *scene = this;
    int index = scene->villager_mngr.SearchDataIDatCharaID(chara_id);
    CVillagerData *villager = scene->villager_mngr.GetData(index);
    if (index >= 0) {
        scene->villager_mngr.CancelStay(index);
    }
    if (villager != NULL && villager->stay == 0) {
        CCharacter2 *chara = scene->GetCharacter(villager->chara_id);
        if (chara != NULL) {
            chara->GetPosition(villager->pos);
            chara->GetRotation(villager->rot);
        }
    }
}
void CScene::ExModeVillager(int chara_id) {
    CScene *scene = this;
    int index = scene->villager_mngr.SearchDataIDatCharaID(chara_id);
    if (index >= 0) {
        scene->villager_mngr.ExMode(index);
    }
}
void CScene::SetActiveVillager() {

    CScene *scene = this;
    int no_map;
    int i = 0;
    int count;
    no_map = scene->active_map == 0;
    count = scene->villager_mngr.data_num;
    for (; i < count; i++) {
        CVillagerData *villager = scene->villager_mngr.GetData(i);
        if (villager != NULL) {
            int unused = villager->vlgr_id < 0;
            if (unused == 0) {
                unused = (villager->place != NULL) ^ 1;
            }
            if (!(unused & 0xFF)) {
                if (no_map) {
                    scene->SetActive(1, villager->chara_id);
                } else {
                    int chara_id = villager->chara_id;
                    if (chara_id >= SCENE_SUB_VILLAGER_SLOT_TOP) {
                        scene->SetActive(1, chara_id);
                    } else {
                        scene->ResetActive(1, chara_id);
                    }
                }
            }
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/scenevillager", InScreenChara__6CSceneFPQ26CScene17InScreenCharaInfoPf);
void CScene::LoadGameObject(int now_map_no, int tex_block, mgCMemory *memory) {
    GAMEOBJ_INFO *entry;
    int skip_objects;
    u32 *file_buffer;
    CSaveData *save;

    file_buffer = (u32 *)read_buff;
    entry = (GAMEOBJ_INFO *)GameObjInfo;
    DeleteChara(SCENE_GAMEOBJ_SLOT_TG);
    DeleteChara(SCENE_GAMEOBJ_SLOT_TG_BASE);
    DeleteChara(SCENE_GAMEOBJ_SLOT_SAVEPOINT);
    DeleteChara(SCENE_GAMEOBJ_SLOT_BOOK);
    mgTexManager.DeleteBlock(tex_block);
    save = save_data;
    skip_objects = 0;
    if ((save != NULL) && (GetGameChapter(save->game_progress) == 8)) {
        skip_objects = 1;
    }

    for (;;) {
        if (entry->map_no < 0) {
            break;
        }
        if (entry->map_no == now_map_no) {
            switch (entry->type) {
                case 3:
                    if (LoadFile2(at_1842__3, file_buffer, NULL, 0) != 0) {
                        LoadChara(SCENE_GAMEOBJ_SLOT_SAVEPOINT, file_buffer, NULL, memory, memory, memory,
                                  tex_block, 1);
                        SetActive(1, SCENE_GAMEOBJ_SLOT_SAVEPOINT);
                        if (LoadFile2(at_1843__3, file_buffer, NULL, 0) != 0) {
                            LoadChara(SCENE_GAMEOBJ_SLOT_BOOK, file_buffer, NULL, memory, memory, memory,
                                      tex_block, 1);
                            SetActive(1, SCENE_GAMEOBJ_SLOT_BOOK);
                        }
                    }
                    break;
                case 1:
                    if ((skip_objects == 0) &&
                        (LoadFile2(at_1844__3, file_buffer, NULL, 0) != 0)) {
                        LoadChara(SCENE_GAMEOBJ_SLOT_TG, file_buffer, NULL, memory, memory, memory,
                                  tex_block, 1);
                        SetActive(1, SCENE_GAMEOBJ_SLOT_TG);
                        if (LoadFile2(at_1845__2, file_buffer, NULL, 0) != 0) {
                            LoadChara(SCENE_GAMEOBJ_SLOT_TG_BASE, file_buffer, NULL, memory, memory, memory,
                                      tex_block, 1);
                            SetActive(1, SCENE_GAMEOBJ_SLOT_TG_BASE);
                        }
                    }
                    break;
                case 2:
                    if ((skip_objects == 0) &&
                        (LoadFile2(at_1846__2, file_buffer, NULL, 0) != 0)) {
                        LoadChara(SCENE_GAMEOBJ_SLOT_TG, file_buffer, NULL, memory, memory, memory,
                                  tex_block, 1);
                        SetActive(1, SCENE_GAMEOBJ_SLOT_TG);
                        if (LoadFile2(at_1847__2, file_buffer, NULL, 0) != 0) {
                            LoadChara(SCENE_GAMEOBJ_SLOT_TG_BASE, file_buffer, NULL, memory, memory, memory,
                                      tex_block, 1);
                            SetActive(1, SCENE_GAMEOBJ_SLOT_TG_BASE);
                        }
                    }
                    break;
            }
        }
        entry++;
    }
}
int CScene::GetGameObjectEvent(float *position, CSceneEventData *event) {
    GAMEOBJ_INFO *entry;
    int now_map_no;
    int i;
    float point[4];
    if (active_map != 0) {
        return -1;
    }
    now_map_no = GetMainMapNo();
    entry = (GAMEOBJ_INFO *)GameObjInfo;
    for (;;) {
        if (entry->map_no < 0) {
            break;
        }
        if (entry->map_no == now_map_no) {
            for (i = 0; i < entry->place_num; i++) {
                *(u_long128 *)point = *(u_long128 *)entry->place[i].pos;
                point[3] = 1.0f;
                if (mgDistVector(point, position) < 20.0f) {
                    *(u_long128 *)event->position = *(u_long128 *)point;
                    mgZeroVector(event->rotation);
                    switch (entry->type) {
                        case 3:
                            if (IsActive(1, SCENE_GAMEOBJ_SLOT_SAVEPOINT) != 0 &&
                                IsActive(1, SCENE_GAMEOBJ_SLOT_BOOK) != 0) {
                                event->gameobj_no = i;
                                return SCENE_GAMEOBJ_SLOT_SAVEPOINT;
                            }
                            break;
                        case 1:
                        case 2:
                            if (IsActive(1, SCENE_GAMEOBJ_SLOT_TG) != 0 &&
                                IsActive(1, SCENE_GAMEOBJ_SLOT_TG_BASE) != 0) {
                                return SCENE_GAMEOBJ_SLOT_TG;
                            }
                            break;
                    }
                }
            }
        }
        entry++;
    }
    return -1;
}
void CScene::DrawGameObject(int now_map_no) {
    GAMEOBJ_INFO *entry;
    CCharacter2 *first;
    CCharacter2 *second;
    int i;
    int offset;
    float first_point[4];
    float second_point[4];
    if (active_map != 0) {
        return;
    }
    entry = (GAMEOBJ_INFO *)GameObjInfo;
    for (;;) {
        if (entry->map_no < 0) {
            break;
        }
        if (entry->map_no == now_map_no) {
            first = NULL;
            second = NULL;
            switch (entry->type) {
                case 3:
                    if (IsActive(1, SCENE_GAMEOBJ_SLOT_SAVEPOINT) != 0 && IsActive(1, SCENE_GAMEOBJ_SLOT_BOOK) != 0) {
                        first = GetCharacter(SCENE_GAMEOBJ_SLOT_SAVEPOINT);
                        second = GetCharacter(SCENE_GAMEOBJ_SLOT_BOOK);
                    }
                    break;
                case 1:
                case 2:
                    if (IsActive(1, SCENE_GAMEOBJ_SLOT_TG) != 0 && IsActive(1, SCENE_GAMEOBJ_SLOT_TG_BASE) != 0) {
                        first = GetCharacter(SCENE_GAMEOBJ_SLOT_TG);
                        second = GetCharacter(SCENE_GAMEOBJ_SLOT_TG_BASE);
                    }
                    break;
            }
            for (i = 0, offset = 0; i < entry->place_num; offset += 0x10, i++) {

                u8 *base = (u8 *)entry + offset;
                u_long128 point_copy = *(u_long128 *)(base + 0x10);
                *(u_long128 *)first_point = point_copy;
                first_point[3] = 1.0f;
                *(u_long128 *)second_point = *(u_long128 *)(base + 0x10);
                second_point[3] = 1.0f;
                if (entry->type == 1 || entry->type == 2) {
                    first_point[1] += 60.0f;
                }
                if (second != NULL) {
                    second->SetPosition(second_point);
                    second->SetRotation(0.0f, *(float *)(base + 0x1C), 0.0f);
                    second->DrawDirect();
                }
                if (first != NULL) {
                    first->SetPosition(first_point);
                    first->SetRotation(0.0f, *(float *)(base + 0x1C), 0.0f);
                    first->DrawDirect();
                }
            }
        }
        entry++;
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_868__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_991__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_992__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", motion_name__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", GameObjInfo__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_815__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1335__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1336__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1337__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1338__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1339__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1441__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1442__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1443__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1444__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1445__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1446__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1447__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1448__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1449__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1464__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1592__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1593__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1594__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1595__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1842__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1843__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1844__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1845__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1846__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/scenevillager", at_1847__2__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(at_988__3, 0x10);
