#include "common.h"
#include "automap.hpp"
#include "mainloop.hpp"
#include "padcontrol.hpp"
#include "gamedata.hpp"
#include "mglib.hpp"
#include "dataread.hpp"
#include "swordeffect.hpp"
#include "snd_mngr.hpp"
#include "dng_event.hpp"
#include "effscript.hpp"
#include "colprim.hpp"
#include "mg_math.hpp"
#include "mg_camera.hpp"
#include "sceneload.hpp"
#include "scene.hpp"
#include "sound.hpp"
#include "dng_main.hpp"
#include "dng_status.hpp"
#include "savedata.hpp"
#include "actscript.hpp"
#include "scriptinterpreter.hpp"
#include <cstring>
#include <cstdio>
#include <cmath>
#include "cameracontrol.hpp"
#include "character.hpp"
#include "dng_effect.hpp"
#include "map.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "monster.hpp"
#include "runscript.hpp"
#include "scenesnd.hpp"
#include "userdata.hpp"
#include "actionchara.hpp"

extern "C" void SethitEffect__15CHitEffectImageFPfPfffffii(CHitEffectImage *, float *, float *, float, float, float, float, int, int);
extern char at_1325[];
extern char at_1357[];
extern char at_1358[];
extern char at_1394[];
extern char at_1427[];
extern char at_1428[];
extern CScene *nowScene__2;
union ActionVector { float f[4]; int i[4]; u_long128 qw; };
struct ThrowItemTable { int item_no[19]; };
extern ThrowItemTable at_1398;
extern CMonsterMan *ActiveMonster;
extern float at_3289[4];
extern float at_3291[4];
extern char at_2423[];
extern char at_3389[];
extern char at_2333[];
extern char at_2334[];
extern char at_2210[];
extern float ang_3371;
extern s8 init_3372;
extern char at_2846[];
int RockOn_TargetSel(CScene *scene, int index);
int DistCheck_Action2(CScene *scene, float unused, float range, float *out_dist, int rank, int *out_rank);
int Check_LockOn(CScene *scene, float range, int index);
void HitEffectSet(CScene *scene, float *point);
int CheckAmuletAvoid(int item_no);
int CheckEquipSetItem(int item_no);

// Code (.text)
void CActionChara::ResetAccele(void) {
    accele.accele[2] = 0;
    accele.accele[1] = 0;
    accele.accele[0] = 0;
    accele.speed = 0;
}
void CActionChara::ResetAction() {
    int i;

    AllDeleteDamage();
    i = 0;
    do {
        if (sword_effect[i] != NULL) {
            sword_effect[i]->Clear();
        }
        i++;
    } while (i < 3);
    hold_type = 0;
    add_speed = 0.0f;
    add_time = 0;
    blow_speed = 0.0f;
    blow_time = 0;
    accume.frame = 0;
    action_info.chara = this;
    action_info.env = NULL;
    if (this->script.check_program(0x96) != 0) {
        this->script.run(0x96);
    }
    prog_no = 0xC8;
}
void CActionChara::ResetScript() {
    int i;
    int j;
    int k;
    int l;
    int m;

    for (i = 0; i < 8; i++) {
        object[i].frame = 0;
    }
    for (j = 0; j < 16; j++) {
        body_col[j].type = 0;
        body_col[j].unk_20 = -1;
    }
    for (k = 0; k < 11; k++) {
        damage[k].use = 0;
        damage[k].chara = NULL;
        damage[k].frame0 = NULL;
        damage[k].frame1 = NULL;
        damage[k].damage = NULL;
        damage[k].prim = NULL;
    }
    damage_num = 0;
    for (l = 0; l < 10; l++) {
        sound[l].se_no = -1;
    }
    for (m = 0; m < 3; m++) {
        if (sword_effect[m] != NULL) {
            sword_effect[m]->Clear();
        }
    }
    hold_type = 0;
    add_speed = 0.0f;
    add_time = 0;
    blow_speed = 0.0f;
    blow_time = 0;
    accume.frame = 0;
}
s32 CActionChara::CheckRunEvent(void) {
    s32 can_run = menu_flag;
    if (hold_type != 0) {
        can_run = 0;
    }
    return can_run;
}
void CActionChara::SetMaskFlag(int flag, int set) {
    if (set != 0)
        mask_flag = mask_flag | flag;
    else
        mask_flag = mask_flag & ~flag;
}
ACTION_OBJECT *CActionChara::EntryObject(char *name, int index) {
    mgCFrame *object;
    ACTION_OBJECT *slot;
    int i;

    object = SearchObject(name);
    if (object == NULL) {
        return 0;
    }
    i = 0;
    if (index != -1) {

        slot = (ACTION_OBJECT *)((index << 5) + (int)this + 0xC00);
        slot->frame = object;
        slot->pos[2] = 0.0f;
        slot->pos[1] = 0.0f;
        slot->pos[0] = 0.0f;
        return slot;
    }
    for (; i < 8; i++) {
        if (this->object[i].frame == 0) {
            slot = (ACTION_OBJECT *)((i << 5) + (int)this + 0xC00);
            slot->frame = object;
            slot->pos[2] = 0.0f;
            slot->pos[1] = 0.0f;
            slot->pos[0] = 0.0f;
            return slot;
        }
    }
    return 0;
}
void CActionChara::CalcCollision(void) {
    ACTION_OBJECT *entry = object;
    s32 index = 0;
    do {
        mgCFrame *frame = entry->frame;
        if (frame != NULL) {
            frame->GetWorldPosition0(entry->pos);
        }
        index += 1;
        entry += 1;
    } while (index < 8);
}
ACTION_BODY_COL *CActionChara::EntryBodyCol(int index, float value) {
    int i;

    if (index < 0 || index >= 8) {
        return NULL;
    }
    if (object[index].frame == 0) {
        return NULL;
    }
    for (i = 0; i < 16; i++) {
        if (body_col[i].type == 0) {
            body_col[i].type = 2;
            body_col[i].object = index;
            body_col[i].radius = value;
            return &body_col[i];
        }
    }
    return NULL;
}
ACTION_DAMAGE *CActionChara::EntryDamage2(char *frame_name_a, char *frame_name_b, char *hit_name, float power,
                                 char *motion, float start_ratio, float end_ratio, char *chara_name) {
    mgCFrame *frame_a;
    mgCFrame *frame_b;
    int i;
    float start_frame;
    float end_frame;

    if (damage_num >= 11) {
        return NULL;
    }
    frame_a = NULL;
    frame_b = NULL;
    if (frame_name_a != NULL) {
        frame_a = SearchObject(frame_name_a);
    }
    if (frame_name_b != NULL) {
        frame_b = SearchObject(frame_name_b);
    }
    for (i = 0; i < 11; i++) {
        if (damage[i].use == 0) {
            start_frame = GetWaitToFrame(motion, start_ratio, chara_name);
            end_frame = GetWaitToFrame(motion, end_ratio, chara_name);
            if (start_frame == 0.0f && end_frame == 0.0f) {
                return NULL;
            }
            damage[i].use = 1;
            damage[i].frame0 = frame_a;
            damage[i].frame1 = frame_b;
            damage[i].damage = hit_name;
            damage[i].start_frame = start_frame;
            damage[i].end_frame = end_frame;
            damage[i].chara = chara_name;
            damage[i].radius = power;
            damage[i].power_rate = 1.0f;
            damage_num++;
            return &damage[i];
        }
    }
    return NULL;
}
ACTION_DAMAGE *CActionChara::EntryDamage2(mgCFrame *frame_a, mgCFrame *frame_b, char *hit_name, float power,
                                 char *motion, float start_ratio, float end_ratio, char *chara_name) {
    int i;
    float start_frame;
    float end_frame;

    if (damage_num >= 11) {
        return NULL;
    }
    for (i = 0; i < 11; i++) {
        if (damage[i].use == 0) {
            start_frame = GetWaitToFrame(motion, start_ratio, chara_name);
            end_frame = GetWaitToFrame(motion, end_ratio, chara_name);
            if (start_frame == 0.0f && end_frame == 0.0f) {
                return NULL;
            }
            damage[i].use = 1;
            damage[i].frame0 = frame_a;
            damage[i].frame1 = frame_b;
            damage[i].damage = hit_name;
            damage[i].start_frame = start_frame;
            damage[i].end_frame = end_frame;
            damage[i].chara = chara_name;
            damage[i].radius = power;
            damage[i].power_rate = 1.0f;
            damage_num++;
            return &damage[i];
        }
    }
    return NULL;
}
void CActionChara::AllDeleteDamage() {
    int i;

    for (i = 0; i < damage_num; i++) {
        if (damage[i].use != 0) {
            if (damage[i].prim != NULL) {
                damage[i].prim->Delete(-1);
            }
        }
    }
}
ACTION_SW_EFFECT *CActionChara::GetSwEffectPtr() {
    ACTION_SW_EFFECT *slot;
    int i;

    slot = sw_effect;
    i = 0;
    do {
        if (slot->motion == 0) {
            return slot;
        }
        i += 1;
        slot += 1;
    } while (i < 9);
    return NULL;
}
void CActionChara::SetSoundInfoCopy() {
    CActionChara *chara;
    u8 *info;

    chara = next;
    info = (u8 *)&foot_se_bank;
    if (chara != NULL) {
        do {
            memcpy(&chara->foot_se_bank, info, 0x28);
            chara = chara->next;
        } while (chara != NULL);
    }
}
void CActionChara::SetFadeFlag(int flag) {
    CActionChara *chara = this;
    if (chara != NULL) {
        do {
            ((CCharacter2 *)chara)->fade = flag;
            chara = chara->next;
        } while (chara != NULL);
    }
}
void CActionChara::SetFarDist(float dist) {
    CActionChara *chara = this;
    if (chara != NULL) {
        do {
            ((CObject *)chara)->far_dist = dist;
            chara = chara->next;
        } while (chara != NULL);
    }
}
void CActionChara::SetNearDist(float dist) {
    CActionChara *chara = this;
    if (chara != NULL) {
        do {
            ((CObject *)chara)->near_dist = dist;
            chara = chara->next;
        } while (chara != NULL);
    }
}
float CActionChara::GetCameraDist() {
    CActionChara *target;

    target = parent;
    if (target != NULL) {
        return target->CCharacter2::GetCameraDist();
    }
    return CCharacter2::GetCameraDist();
}
void CActionChara::Show(int show, int chain) {
    CActionChara *chara = this;
    if (chain == 0) {
        ((CObject *)chara)->show = show;
        return;
    }
    if (chara != NULL) {
        do {
            ((CObject *)chara)->show = show;
            chara = chara->next;
        } while (chara != NULL);
    }
}
int CActionChara::GetShow(char *name) {
    CActionChara *current;
    int show;

    show = 0;
    current = this;
    if (name != NULL) {
        if (this != NULL) {
            do {
                if (strcmp(current->name, name) == 0) {
                    return ((CObject *)current)->show;
                }
                current = current->next;
            } while (current != NULL);
        }
    } else {
        show = ((CObject *)this)->show;
    }
    return show;
}
int CActionChara::CheckKeri(char *name, int flag) {
    mgCFrame *object;
    CMapParts *stone;
    CMapPiece *piece;
    float pos[4];
    float radius;

    object = SearchObject(name);
    if (object == NULL) {
        return 0;
    }
    object->GetWorldPosition0(pos);
    pos[3] = 1.0f;
    radius = 30.0f;
    if (flag != 0) {
        radius = 40.0f;
    }
    stone = (CMapParts *)AutoMapGen.SearchRandomStone(pos, radius);
    if (stone != NULL) {
        if (flag != 0) {
            piece = stone->SearchPiece(at_1325);
            if (piece != NULL) {
                piece->Show(0);
            }
            release_timing = 5;
            hold_parts = stone;
        }
        return 1;
    }
    return 0;
}
int CActionChara::CheckEnemyCatch(char *name) {
    mgCFrame *object;
    CMapParts *stone;
    CMapPiece *piece;
    CActionChara *other;
    CBattleCharaInfo *battle_info;
    float pos[4];
    float one;

    one = 1.0f;
    object = SearchObject(name);
    if (object == NULL) {
        return 0;
    }
    if (hold_type != 0) {
        return 0;
    }
    if (ActiveMonster->CheckThrowTarget(object) != NULL) {
        hold_type = 3;
        release_timing = 1;
        other = SearchChara(at_1357);
        if (other != NULL) {
            other->Show(0, 0);
        }
        battle_info = GetBattleCharaInfo();
        if (battle_info->chr_no == 0) {
            other = SearchChara(at_1358);
            if (other != NULL) {
                other->Show(0, 0);
            }
        }
        battle_info->AddHp_Rate(-0.05f, 3, one);
        return 1;
    }
    object->GetWorldPosition0(pos);
    pos[3] = 1.0f;
    stone = (CMapParts *)AutoMapGen.SearchRandomStone(pos, 30.0f);
    if (stone != NULL) {
        piece = stone->SearchPiece(at_1325);
        if (piece != NULL) {
            piece->Show(0);
        }
        release_timing = 1;
        hold_frame = object;
        hold_parts = stone;
        hold_type = 4;
        other = SearchChara(at_1357);
        if (other != NULL) {
            other->Show(0, 0);
        }
        if ((GetBattleCharaInfo())->chr_no == 0) {
            other = SearchChara(at_1358);
            if (other != NULL) {
                other->Show(0, 0);
            }
        }
        return 1;
    }
    return 0;
}
void CActionChara::ThrowItemObject() {
    float target[4];
    float position[4];
    u8 *item;

    if (hold_type != 0) {
        if (throw_effect >= 0) {
            effect_man->SetScriptProgNo(0x12C, 0, throw_effect);
            sceVu0CopyVector(target, front_vec);
            GetPosition(position);
            sceVu0ScaleVector(target, target, 120.0f);
            sceVu0AddVector(target, target, position);
            effect_man->SetScriptVect1(target, 0, throw_effect);
            hold_type = 0;

            item = (u8 *)GetBattleCharaInfo()->GetActiveItemInfo(0);
            item += DngStatus.active_item * sizeof(CGameDataUsed);
            ((CGameDataUsed *)item)->DeleteNum(1);
        }
    }
}
int CActionChara::UsedItemAction() {
    CBattleCharaInfo *battle_info;
    CGameDataUsed *item;
    s16 item_no;
    CDataItem *info;
    int healing;

    battle_info = GetBattleCharaInfo();
    item = (CGameDataUsed *)battle_info->GetActiveItemInfo(0) + DngStatus.active_item;
    if (DngStatus.active_item == 3) {
        return 3;
    }
    item_no = item->item_no;
    info = GetItemInfoData(item_no);
    if (info != NULL) {
        if (info->status_flags & 6) {
            EntryThrowItem();
            return 2;
        }
        if (info->status_flags & 0x19) {
            if (battle_info->UseActiveItem(item) != 0) {
                if (info->status_flags & 0x18) {
                    healing = 0;
                    if (item_no == 0x112) {
                        healing = 1;
                    }
                    if (healing == 0) {
                        pallet[0].SetAnim(0x60, 0xB4, 0xFF, 1, 0x2D, 0);
                    }
                    if (healing == 1) {
                        pallet[0].SetAnim(0xFF, 0xDC, 0x40, 1, 0x2D, 0);
                    }
                    effect_man->CreateEffSpt(at_1394, 0, 0);
                    effect_man->SetScriptTargetId(0, -1, -1);
                    effect_man->SetValue(0, healing, 0, -1);
                }
            }
            return 1;
        }
    }
    return 0;
}
void CActionChara::EntryThrowItem() {
    ThrowItemTable table;
    CGameDataUsed *item;
    int index;
    int item_no;
    CBattleCharaInfo *battle_info;

    battle_info = GetBattleCharaInfo();
    item = (CGameDataUsed *)battle_info->GetActiveItemInfo(0) + DngStatus.active_item;
    item_no = item->item_no;
    table = at_1398;
    index = 0;
    while (table.item_no[index] != -1) {
        if (item_no == table.item_no[index]) {
            break;
        }
        index++;
    }
    if (table.item_no[index] == -1) {
        index = 0;
    }
    throw_effect = effect_man->CreateEffSpt(at_1427, 0, 1);
    if (throw_effect < 0) {
        printf(at_1428);
    } else {
        effect_man->SetValue(0, 1, 0, throw_effect);
        effect_man->SetValue(1, item_no, 0, throw_effect);
        if (action_info.env != NULL) {
            effect_man->SetCharacter(
                (CCharacter2 *)(action_info.env->item_chara + index), 0, throw_effect);
            effect_man->SetTexb(action_info.env->texb, 0, throw_effect);
            index = 0;
            if (item_no == 0x130) {
                do {
                    effect_man->SetValue(index + 2, item->GetGiftBoxItemNo(index), 0,
                                           throw_effect);
                    index++;
                } while (index < 3);
            }
        }
    }
    hold_type = 1;
}
void CActionChara::RemoveThrowItem() {
    s8 effect_no;

    if (hold_type != 0) {
        GetBattleCharaInfo();
        if (hold_type == 1) {
            effect_no = throw_effect;
            if (effect_no >= 0) {
                effect_man->DeleteEffSpt(0, effect_no);
            }
            hold_type = 0;
        }
    }
}
float CActionChara::GetNowFrameWait(char *name) {
    CActionChara *current;
    float wait;

    wait = 0.0f;
    current = this;
    if (name != NULL) {
        if (this != NULL) {
            do {
                if (strcmp(current->name, name) == 0) {
                    return ((CCharacter2 *)current)->frame_ratio;
                }
                current = current->next;
            } while (current != NULL);
        }
    } else {
        wait = CCharacter2::frame_ratio;
    }
    return wait;
}
float CActionChara::GetNowFrame(char *name) {
    CActionChara *current;
    float frame;

    frame = 0.0f;
    current = this;
    if (name != NULL) {
        if (this != NULL) {
            do {
                if (strcmp(current->name, name) == 0) {
                    return ((CCharacter2 *)current)->frame;
                }
                current = current->next;
            } while (current != NULL);
        }
    } else {
        frame = CCharacter2::frame;
    }
    return frame;
}
int CActionChara::CheckMotionEnd(char *name) {
    CActionChara *chara;
    int result;

    result = 0;
    chara = this;
    if (name != NULL) {
        for (; chara != NULL; chara = chara->next) {
            if (strcmp(chara->name, name) == 0) {
                return chara->CCharacter2::CheckMotionEnd();
            }
        }
    } else {
        result = CCharacter2::CheckMotionEnd();
    }
    return result;
}
int CActionChara::GetMotionStatus(char *name) {
    CActionChara *current;
    int status;

    status = 0;
    current = this;
    if (name != NULL) {
        if (this != NULL) {
            do {
                if (strcmp(current->name, name) == 0) {
                    return ((CCharacter2 *)current)->motion_status;
                }
                current = current->next;
            } while (current != NULL);
        }
    } else {
        status = CCharacter2::motion_status;
    }
    return status;
}
float CActionChara::GetWaitToFrame(char *motion, float ratio, char *chara_name) {
    CActionChara *chara;
    CHRINFO_KEY_SET *keys;
    float frame;

    chara = this;
    frame = 0.0f;
    if (chara_name != NULL) {
        for (; chara != NULL; chara = chara->next) {
            if (strcmp(chara->name, chara_name) == 0) {
                keys = ((CCharacter2 *)chara)->GetKeyListPtr(motion, NULL);
                if (keys != NULL) {
                    return (float)keys->start_frame +
                           ratio * ((float)keys->end_frame - (float)keys->start_frame);
                }
            }
        }
    } else {
        keys = CCharacter2::GetKeyListPtr(motion, NULL);
        if (keys != NULL) {
            frame = (float)keys->start_frame + ratio * ((float)keys->end_frame - (float)keys->start_frame);
        }
    }
    return frame;
}
void CActionChara::SetMotion(int motion_no, int param) {
    CActionChara *current;

    current = this;
    if (this != NULL) {
        do {
            current->CCharacter2::SetMotion(motion_no, param);
            current = current->next;
        } while (current != NULL);
    }
}
void CActionChara::SetMotion(char *name, int param, int chain) {
    CActionChara *current;

    current = this;
    if (chain == 0) {
        CCharacter2::SetMotion(name, param);
        return;
    }
    if (this != NULL) {
        do {
            current->CCharacter2::SetMotion(name, param);
            current = current->next;
        } while (current != NULL);
    }
}
void CActionChara::ResetMotion() {
    CActionChara *current;

    current = this;
    if (this != NULL) {
        do {
            current->CCharacter2::ResetMotion();
            current = current->next;
        } while (current != NULL);
    }
}
int CActionChara::Draw() {
    float draw_pos[4];
    float saved_pos[4];
    float ambient[4];
    int result;
    CActionChara *chara;

    chara = this;
    GetPosition(draw_pos);
    GetPosition(saved_pos);
    if (damage_time > 6) {
        draw_pos[1] += 2.5f * mgRnd();
    }
    SetPosition(draw_pos);
    mgGetAmbient(ambient);
    if (this != NULL) {
        do {
            result = chara->CCharacter2::Draw();
            chara->CalcCollision();
            chara = chara->next;
        } while (chara != NULL);
    }
    SetPosition(saved_pos);
    mgSetAmbient(ambient);
    return result;
}
int CActionChara::DrawDirect() {
    float draw_pos[4];
    float saved_pos[4];
    float ambient[4];
    float pallet_color[4];
    int result;
    CActionChara *chara;
    int i;

    chara = this;
    GetPosition(draw_pos);
    GetPosition(saved_pos);
    if (shake.time > 0) {
        draw_pos[1] += shake.offset;
    }
    SetPosition(draw_pos);
    mgGetAmbient(ambient);
    i = 0;
    do {
        if (pallet[i].CreatPallet(pallet_color, ambient) != 0) {
            mgSetAmbient(pallet_color);
            break;
        }
        i++;
    } while (i < 3);
    if (this != NULL) {
        do {
            result = chara->CCharacter2::DrawDirect();
            chara->CalcCollision();
            chara = chara->next;
        } while (chara != NULL);
    }
    SetPosition(saved_pos);
    mgSetAmbient(ambient);
    return result;
}
int CActionChara::DrawShadowDirect() {
    CActionChara *current;

    current = this;
    if (this != NULL) {
        do {
            current->CCharacter2::DrawShadowDirect();
            current = current->next;
        } while (current != NULL);
    }
}

void CActionChara::DrawEffect() {
    CEffectScriptMan *effect_man;

    CCharacter2::DrawEffect();
    effect_man = this->effect_man;
    if (effect_man != NULL) {
        effect_man->Draw();
    }
}
void CActionChara::StepEffect() {
    ACTION_SW_EFFECT *slot;
    CActionChara *watched;
    mgCFrame *start_frame;
    mgCFrame *end_frame;
    float frame;
    int i;
    int offset;

    i = 0;
    offset = 0;
    for (; i < sw_effect_num; i++) {

        slot = (ACTION_SW_EFFECT *)((u8 *)this + 0x7E4 + offset);
        if (slot->motion != NULL) {
            if (slot->wait > 0) {
                slot->wait--;
            } else {
                watched = this;
                if (slot->chara != NULL) {
                    watched = SearchChara(slot->chara);
                }
                if (watched != NULL && watched->GetNowMotionName() != NULL &&
                    strcmp(watched->GetNowMotionName(), slot->motion) == 0) {
                    frame = watched->GetNowFrameWait(NULL);
                    if (!(frame < slot->start) && frame < slot->end) {
                        start_frame = watched->SearchObject(slot->frame0);
                        end_frame = watched->SearchObject(slot->frame1);
                        if (start_frame != NULL && end_frame != NULL) {
                            sword_effect[slot->sword_no]->StartEffect(
                                start_frame, end_frame, slot->unk_1c, slot->fade_time,
                                slot->unk_1d);
                            slot->wait = 5;
                        }
                    }
                }
            }
        }
        offset += 0x20;
    }
    CCharacter2::StepEffect();
}
CActionChara *CActionChara::SearchChara(char *name) {
    CActionChara *current;

    current = this;
    if (this != NULL) {
        do {
            if (strcmp(current->name, name) == 0) {
                return current;
            }
            current = current->next;
        } while (current != NULL);
    }
    return NULL;
}
mgCFrame *CActionChara::SearchObject(char *name) {
    CActionChara *current;
    mgCFrame *frame;
    mgCFrame *found;

    current = this;
    if (this != NULL) {
        do {
            frame = current->CObjectFrame::frame;
            if (frame == NULL) {
                current = current->next;
                continue;
            }
            found = frame->SearchFrame(name);
            if (found != NULL) {
                return found;
            }
            current = current->next;
        } while (current != NULL);
    }
    return NULL;
}
void CActionChara::ResetParent() {
    mgCFrame *frame;

    next = NULL;
    frame = this->CObjectFrame::frame;
    if (frame != NULL) {
        frame->DeleteReference();
    }
}
int CActionChara::SetRef(CActionChara *other, char *name) {
    mgCFrame *object;
    mgCFrame *other_frame;
    CActionChara *tail;
    CActionChara *following;

    if (other == NULL) {
        return 0;
    }
    other_frame = other->CObjectFrame::frame;
    if (other_frame == NULL) {
        return 0;
    }
    object = SearchObject(name);
    if (object == NULL) {
        return 0;
    }
    other_frame->DeleteReference();
    other_frame->SetReference(object);
    tail = this;
    other->chara_kind = 1;
    for (;;) {
        following = tail->next;
        if (following == NULL) {
            tail->next = other;
            tail->next->parent = this;
            break;
        }
        tail = following;
    }
    return 1;
}
float CActionChara::GetTargetDist(CScene *scene) {
    float my_pos[4];
    float target_pos[4];
    s16 id;
    CActionChara *target;

    id = target_no;
    if (id != -1) {
        target = (CActionChara *)scene->GetCharacter(id);
        if (target != NULL) {
            GetPosition(my_pos);
            target->GetPosition(target_pos);
            return mgDistVector(my_pos, target_pos);
        }
    }
    return -1.0f;
}
int RockOn_TargetSel(CScene *scene, int index) {
    CActionChara *target;
    int tries;

    if (index != -1) {
        index -= 1;
        for (tries = 0; tries < MONSTER_ACTIVE_MAX; tries++) {
            index += 1;
            if (index >= MONSTER_ACTIVE_MAX * 2) {
                index = MONSTER_ACTIVE_MAX;
            }
            target = (CActionChara *)scene->GetCharacter(index);
            if (target != NULL && target->chara_kind == 2 && ((CActiveMonster *)target)->state == 1 &&
                ((CActiveMonster *)target)->catch_state != 1 &&
                !(((CActiveMonster *)target)->attrib & 1)) {
                return index;
            }
        }
        return -1;
    }
    for (tries = 0; tries < MONSTER_ACTIVE_MAX; tries++) {
        target = (CActionChara *)scene->GetCharacter(tries + MONSTER_ACTIVE_MAX);
        if (target != NULL && target->chara_kind == 2 && ((CActiveMonster *)target)->state == 1 &&
            ((CActiveMonster *)target)->catch_state != 1 &&
            !(((CActiveMonster *)target)->attrib & 1)) {
            return tries + MONSTER_ACTIVE_MAX;
        }
    }
    return -1;
}
int DistCheck_Action2(CScene *scene, float unused, float range, float *out_dist, int rank, int *out_rank) {
    float direction[4];
    float own_pos[4];
    float own_rot[4];
    float entry_pos[4];
    float front_vec[4];
    float dists[MONSTER_ACTIVE_MAX];
    int ids[MONSTER_ACTIVE_MAX];
    CActionChara *player;
    int count;
    int i;
    CActionChara *target;
    int best;
    float best_dist;
    float dist;
    int a;
    int min;
    int b;
    float key;
    int tmp_id;
    float tmp_dist;

    player = (CActionChara *)scene->GetCharacter(0);
    direction[3] = 1.0f;
    best_dist = range;
    player->GetPosition(own_pos);
    player->GetRotation(own_rot);
    sceVu0CopyVector(front_vec, player->front_vec);
    count = 0;
    best = -1;
    i = 0;
    do {
        target = (CActionChara *)scene->GetCharacter(i + MONSTER_ACTIVE_MAX);
        if (target != NULL && target->chara_kind == 2 && ((CActiveMonster *)target)->state == 1 &&
            ((CActiveMonster *)target)->catch_state != 1 &&
            !(((CActiveMonster *)target)->attrib & 1)) {
            ((CCharacter2 *)target)->GetEntryObjectPos(0, 0, entry_pos);
            dist = ((CActiveMonster *)target)->target_dist;
            if (dist < range || ((CActiveMonster *)target)->tbl->boss != 0) {
                if (!(best_dist <= dist) || ((CActiveMonster *)target)->tbl->boss != 0) {
                    best = i;
                    best_dist = dist;
                }
                direction[0] = entry_pos[0] - own_pos[0];
                direction[1] = entry_pos[1] - own_pos[1];
                direction[2] = entry_pos[2] - own_pos[2];
                sceVu0Normalize(direction, direction);
                sceVu0InnerProduct(front_vec, direction);
                dists[count] = dist;
                ids[count] = i;
                count++;
            }
        }
        i++;
    } while (i < MONSTER_ACTIVE_MAX);
    if (rank == 0 || count < 2) {
        if (best == -1) {
            return -1;
        }
        *out_dist = best_dist;
        return best + MONSTER_ACTIVE_MAX;
    }
    for (a = 0; a < count; a++) {
        min = a;
        for (b = a; b < count; b++) {
            if (b != a) {
                key = dists[b];
                if (!(key < 0.0f) && !(dists[min] <= key)) {
                    min = b;
                }
            }
        }
        if (a != min) {
            tmp_dist = dists[a];
            tmp_id = ids[a];
            dists[a] = dists[min];
            ids[a] = ids[min];
            dists[min] = tmp_dist;
            ids[min] = tmp_id;
        }
    }
    if (rank >= count) {
        rank = 0;
    }
    *out_dist = dists[rank];
    if (out_rank != NULL) {
        *out_rank = rank;
    }
    return ids[rank] + MONSTER_ACTIVE_MAX;
}
int Check_LockOn(CScene *scene, float range, int index) {
    float own_pos[4];
    float target_pos[4];
    CActionChara *player;
    CActionChara *target;
    int farther;

    player = (CActionChara *)scene->GetCharacter(0);
    player->GetPosition(own_pos);
    target = (CActionChara *)scene->GetCharacter(index);
    if (target == NULL) {
        return 0;
    }
    if (target->chara_kind != 2) {
        return 0;
    }
    if (((CActiveMonster *)target)->state != 1) {
        return 0;
    }
    if (((CActiveMonster *)target)->attrib & 1) {
        return 0;
    }
    if (((CActiveMonster *)target)->catch_state == 1) {
        return 0;
    }
    if (((CActiveMonster *)target)->tbl->boss != 0) {
        return 1;
    }
    ((CCharacter2 *)target)->GetEntryObjectPos(0, 0, target_pos);
    own_pos[3] = 1.0f;
    target_pos[3] = 1.0f;
    farther = 1;
    if (((CActiveMonster *)target)->target_dist <= range) {
        farther = 0;
    }

    return farther = farther ^ 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actionchara", CollisionCheck__12CActionCharaFPfPfPf);
void CActionChara::RockOn() {
    float own_pos[4];
    float target_pos[4];
    float to_target[4];
    float front_vec[4];
    int priority_index;
    u8 *scene_input;
    CCharacter2 *target;

    GetPosition(own_pos);

    scene_input = (u8 *)nowScene__2 + 0x2F90;
    target_dot = 0.0f;
    if (lock_on != 0) {
        target = nowScene__2->GetCharacter(target_no);
        if (target != NULL) {
            target->GetEntryObjectPos(0, 0, target_pos);
            sceVu0SubVector(to_target, target_pos, own_pos);
            sceVu0Normalize(to_target, to_target);
            sceVu0Normalize(front_vec, velocity);
            target_dot = sceVu0InnerProduct(to_target, front_vec);
        }
    }
    if (PadCtrl.Btn(0x34) != 0) {
        if (lock_on != 0) {
            if (target_dot < -0.2f) {
                sndSePlay(SystemSND_ID, 0x1B, 0);
                lock_on = 0;
                return;
            }

            if (*(s16 *)(scene_input + 0x9E) == 2) {
                if (target_no < 0) {
                    target_no = MONSTER_ACTIVE_MAX;
                } else {
                    target_no = target_no + 1;
                }
                if (target_no >= MONSTER_ACTIVE_MAX * 2) {
                    target_no = MONSTER_ACTIVE_MAX;
                }
                target_no = RockOn_TargetSel(nowScene__2, target_no);
                return;
            }
            target = nowScene__2->GetCharacter(target_no);
            if (target != NULL) {
                if (ActiveMonster->GetPriorityLevelIndex(
                        ((CActiveMonster *)target)->priority + 1, &priority_index) != NULL) {
                    sndSePlay(SystemSND_ID, 0x1A, 0);
                    target_no = priority_index;
                    return;
                }
                target_no = MONSTER_ACTIVE_MAX;
            }
        } else if (target_no != -1) {
            sndSePlay(SystemSND_ID, 0x1A, 0);
            lock_on = 1;
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actionchara", HumanMoveIF__12CActionCharaFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actionchara", HumanShrowMoveIF__12CActionCharaFv);
int CActionChara::HumanTameMoveIF() {
    float position[4];
    float movement[4];
    float camera_angle;
    float stick_x;
    float stick_y;
    float world_x;
    float world_z;

    GetPosition(position);
    sceVu0CopyVector(movement, velocity);
    camera_angle = action_info.camera->GetAngle();
    stick_x = GamePad__2.GetLXf();
    stick_y = GamePad__2.GetLYf();
    world_x = stick_x * cosf(camera_angle) + stick_y * sinf(camera_angle);
    world_z = -stick_x * sinf(camera_angle) + stick_y * cosf(camera_angle);
    world_x *= 0.4f;
    world_z *= 0.4f;
    movement[0] = 2.0f * world_x * (float)mgFrameRate;
    movement[2] = 2.0f * world_z * (float)mgFrameRate;
    if (world_x != 0.0f || world_z != 0.0f) {
        stand_flag = 0;
    } else {
        stand_flag = 1;
    }
    SetMotion(at_2333, 0, 1);
    if (world_x != 0.0f || world_z != 0.0f) {
        SetMotion(at_2334, 0, 1);
    }
    sceVu0CopyVector(velocity, movement);
    RockOn();
    return 1;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/actionchara", HumanGunMoveIF__12CActionCharaFPcPc);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actionchara", RoboWalkMoveIF__12CActionCharaFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actionchara", RoboTankMoveIF__12CActionCharaFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actionchara", RoboBikeMoveIF__12CActionCharaFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actionchara", RoboAirMoveIF__12CActionCharaFii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actionchara", MonsterMoveIF__12CActionCharaFv);

void HitEffectSet(CScene *scene, float *point) {
    float pos[4];
    float to_camera[4];
    float origin[4];
    float dir[4];
    ActionVector rect;
    CCameraControl *camera;
    CHitEffectImage *hit;
    CFlushEffect *flush;
    float speed = 50.0f;

    camera = (CCameraControl *)scene->GetCamera(scene->active_camera);
    if (camera == NULL) {
        return;
    }
    sceVu0CopyVector(origin, point);
    camera->GetPos(to_camera);
    sceVu0SubVector(to_camera, to_camera, origin);
    sceVu0Normalize(to_camera, to_camera);
    sceVu0ScaleVector(to_camera, to_camera, 20.0f);
    sceVu0AddVector(pos, origin, to_camera);
    *(ActionVector *)dir = *(ActionVector *)at_2846;
    if (BattleFX.hit == NULL) {
        hit = NULL;
    } else {
        hit = BattleFX.hit + BattleFX.hit_next;
        BattleFX.hit_next++;
        if (BattleFX.hit_next >= BattleFX.hit_num) {
            BattleFX.hit_next = 0;
        }
    }
    if (hit != NULL) {
        SethitEffect__15CHitEffectImageFPfPfffffii(hit, pos, dir, 30.0f, speed, 0.4f, 0.1f, 30, 32);
        hit->kind = 0;
    }
    if (BattleFX.flush == NULL) {
        flush = NULL;
    } else {
        flush = BattleFX.flush + BattleFX.flush_next;
        BattleFX.flush_next++;
        if (BattleFX.flush_next >= BattleFX.flush_num) {
            BattleFX.flush_next = 0;
        }
    }
    if (flush != NULL) {
        sceVu0CopyVector(flush->pos, origin);
        flush->fade_speed = 20.0f;
        flush->alpha = 160;
        flush->active = 1;
        flush->size = 10.0f;
        flush->grow = 2.0f;
        flush->tex_u = 64;
        flush->tex_v = 192;
        flush->tex_size = 64;
        flush->follow = NULL;
    }
    if (BattleFX.hit == NULL) {
        hit = NULL;
    } else {
        hit = BattleFX.hit + BattleFX.hit_next;
        BattleFX.hit_next++;
        if (BattleFX.hit_next >= BattleFX.hit_num) {
            BattleFX.hit_next = 0;
        }
    }
    if (hit != NULL) {
        SethitEffect__15CHitEffectImageFPfPfffffii(hit, pos, dir, 40.0f, 40.0f, 0.0f, 0.05f, 32,
                                                   32);
        hit->kind = 0;
        ((mgRect<int> *)&rect)->Set(0, 80, 16, 16);
        ActionVector copy = rect;
        hit->tex_rect.left = copy.i[0];
        hit->tex_rect.top = copy.i[1];
        hit->tex_rect.right = copy.i[2];
        hit->tex_rect.bottom = copy.i[3];
        hit->sprite_size = 2.0f;
    }
}
int CheckAmuletAvoid(int item_no) {
    CBattleCharaInfo *info;
    CGameDataUsed *item;
    int i;

    info = GetBattleCharaInfo();
    switch (info->chr_no) {
        case 1:
        case 0:
            item = (CGameDataUsed *)info->GetActiveItemInfo(0);
            i = 0;
            do {
                if (item_no == item->item_no) {
                    if (iRand(100) % 3 == 0) {
                        item->DeleteNum(1);
                    }
                    return 1;
                }
                i++;
                item = (CGameDataUsed *)((u8 *)item + sizeof(CGameDataUsed));
            } while (i < 3);
            return 0;
        default:
            return 1;
    }
}
int CheckEquipSetItem(int item_no) {
    CBattleCharaInfo *info;
    CGameDataUsed *item;
    int i;

    info = GetBattleCharaInfo();
    switch (info->chr_no) {
        case 1:
        case 0:
            item = (CGameDataUsed *)info->GetActiveItemInfo(0);
            i = 0;
            do {
                if (item_no == item->item_no) {
                    item->DeleteNum(1);
                    return 1;
                }
                i++;
                item = (CGameDataUsed *)((u8 *)item + sizeof(CGameDataUsed));
            } while (i < 3);
            return 0;
        default:
            return 0;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actionchara", CheckDamage__12CActionCharaFv);
int CActionChara::LoadActionFile(char *script, int size, mgCMemory *memory) {
    SetActionExtendTable();
    chara_kind = 2;
    script_buf = (char *)memory->stAlloc64(size / 16 + 1);
    memcpy(script_buf, script, size);
    SetActionScript(&this->script, script_buf, memory);
    return 1;
}
void CActionChara::InitScript() {
    ResetScript();
    action_info.chara = this;
    if (this->script.check_program(ACTION_PROG_INIT) != 0) {
        this->script.run(ACTION_PROG_INIT);
    }
    prog_no = 0xC8;
}
void CActionChara::SetHold() {
    if (this->script.check_program(ACTION_PROG_HOLD) != 0) {
        this->script.run(ACTION_PROG_HOLD);
        AllDeleteDamage();
        damage_req = 0;
        prog_no = -1;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actionchara", RunScript__12CActionCharaFP6CSceneP14RUN_SCRIPT_ENV);
int CActionChara::CheckReleaseTimming(int id) {
    if (id == -1) {
        return release_timing;
    }
    if (id == hold_type) {
        return release_timing;
    }
    return 0;
}
void CActionChara::StepParam() {
    float move_copy[4];
    float self_rot[4];
    float target_rot[4];
    float forward[4];
    float matrix[4][4];
    float self_rot2[4];
    float forward2[4];
    float matrix2[4][4];
    float knock[4];
    float push[4];
    CActionChara *target;
    int i;

    sceVu0CopyVector(move_copy, velocity);
    move_copy[0] = 0.0f;
    move_copy[2] = 0.0f;
    sceVu0CopyVector(velocity, move_copy);
    if (chara_type == 2) {
        target = SearchChara(at_2423);
        if (target != NULL) {
            GetRotation(self_rot);
            target->GetRotation(target_rot);
            self_rot[1] += target_rot[1];
            if (!(self_rot[1] <= 3.1415927f)) {
                self_rot[1] -= 6.2831855f;
            }
            if (self_rot[1] < -3.1415927f) {
                self_rot[1] += 6.2831855f;
            }
            *(ActionVector *)forward = *(ActionVector *)at_3289;
            sceVu0UnitMatrix(matrix);
            sceVu0RotMatrixY(matrix, matrix, self_rot[1]);
            sceVu0ApplyMatrix(front_vec, matrix, forward);
        }
    } else {
        GetRotation(self_rot2);
        *(ActionVector *)forward2 = *(ActionVector *)at_3291;
        sceVu0UnitMatrix(matrix2);
        sceVu0RotMatrixY(matrix2, matrix2, self_rot2[1]);
        sceVu0ApplyMatrix(front_vec, matrix2, forward2);
    }
    add_vec[1] = 0.0f;
    if (!(add_speed <= 0.0f) && add_time != 0) {
        sceVu0ScaleVectorXYZ(knock, add_vec, add_speed);
        sceVu0AddVector(velocity, velocity, knock);
        if (add_time > 0) {
            if (!(add_speed <= 0.0f)) {
                add_speed = add_speed - add_decel;
            }
            add_time--;
            if (add_time <= 0) {
                add_speed = 0.0f;
            }
        }
    }
    if (!(blow_speed <= 0.0f) && blow_time != 0) {
        sceVu0ScaleVectorXYZ(push, blow_vec, blow_speed);
        sceVu0AddVector(velocity, velocity, push);
        if (blow_time > 0) {
            if (!(blow_speed <= 0.0f)) {
                blow_speed = blow_speed - blow_decel;
            }
            blow_time--;
            if (blow_time <= 0) {
                blow_speed = 0.0f;
            }
        }
    }
    if (catch_state == 2) {
        sceVu0CopyVector(velocity, blow_vec);
        blow_vec[1] -= 0.6f;
    }
    if (unk_75e != 0) {
        unk_760 += 0.016666668f;
        if (!(unk_760 < 1.0f)) {
            unk_760 = 1.0f;
        }
    } else {
        unk_760 = unk_760 - 0.016666668f;
        if (unk_760 <= 0.0f) {
            unk_760 = 0.0f;
        }
    }
    if (stagger_time > 0) {
        stagger_time--;
        if (stagger_time <= 0 && stagger > 0) {
            stagger = 0;
        }
    }
    if (shot_wait > 0) {
        shot_wait--;
    }
    if (murderous_time > 0) {
        murderous_time--;
    }
    if (damage_time > 0) {
        damage_time--;
    }
    if (unk_be4 > 0) {
        unk_be4--;
    }
    if (muteki_time > 0) {
        muteki_time--;
    }
    if (no_hit_time > 0) {
        no_hit_time--;
    }
    i = 0;
    if (shake.time > 0) {
        shake.offset = 2.5f * mgRnd();
        shake.time--;
    }
    for (i = 0; i < 3; i++) {
        pallet[i].Step();
    }
    release_timing = 0;
}
void CActionChara::Step() {
    float held_pos[4];
    float rotation[4];
    float gun_pos[4];
    float target_pos[4];
    float matrix[4][4];
    float pitch_matrix[4][4];
    CActionChara *link;
    CCharacter2 *chained;
    CCharacter2 *self = (CCharacter2 *)this;
    mgCFrame *gun;

    StepParam();
    if (self->se_positional != 2) {
        self->se_positional = 1;
    }
    self->CCharacter2::Step();
    link = next;
    if (link != NULL) {
        do {
            chained = (CCharacter2 *)link;
            if (chained->se_positional != 2) {
                chained->se_positional = 0;
            }
            chained->CCharacter2::Step();
            link = link->next;
        } while (link != NULL);
    }
    if (hold_type == 4 && hold_parts != 0 && hold_frame != 0) {
        GetRotation(rotation);
        ((mgCFrame *)hold_frame)->GetWorldPosition0(held_pos);
        held_pos[3] = 1.0f;
        held_pos[1] -= 1.0f;
        ((CActionChara *)hold_parts)->SetPosition(held_pos);
        ((CActionChara *)hold_parts)->SetRotation(rotation);
    }
    gun = SearchObject(at_3389);
    if (gun != NULL) {
        if (init_3372 == 0) {
            ang_3371 = 0.0f;
            init_3372 = 1;
        }
        gun->GetWorldPosition0(gun_pos);
        if (lock_on != 0 && (s8)dir_gun != 0) {

            (*(CCharacter2 **)(((target_no - 24) << 2) + (int)ActiveMonster + 0x484))->GetEntryObjectPos(0, target_pos);
            sceVu0SubVector(gun_pos, target_pos, gun_pos);
            sceVu0CopyVector(target_pos, gun_pos);
            target_pos[3] = 1.0f;
            target_pos[1] = 0.0f;
            ang_3371 = -atan2f(gun_pos[1], mgDistVector(target_pos));
        } else {
            ang_3371 = 0.0f;
        }
        sceVu0CopyMatrix(matrix, gun->trans_matrix);
        sceVu0UnitMatrix(pitch_matrix);
        sceVu0RotMatrixZ(pitch_matrix, pitch_matrix, ang_3371);
        sceVu0MulMatrix(matrix, matrix, pitch_matrix);
        gun->SetTransMatrix(matrix);
    }
}
void CActionChara::ShadowStep() {
    CActionChara *current;

    current = this;
    if (this != NULL) {
        do {
            current->CCharacter2::ShadowStep();
            current = current->next;
        } while (current != NULL);
    }
}
void CActionChara::Initialize(mgCMemory *memory) {
    int i;
    int j;

    CCharacter2::Initialize();
    accume_effect = NULL;
    old_pos[2] = 0.0f;
    old_pos[1] = 0.0f;
    old_pos[0] = 0.0f;
    old_pos[3] = 1.0f;
    chara_kind = 0;
    script_buf = NULL;
    max_speed = 4.0f;
    prog = 0;
    pad_history = 0;
    parent = NULL;
    next = NULL;
    accele.speed = 0;
    accele.move_speed = 3.0f;
    *(int *)&accele.accele[0] = 0;
    *(int *)&accele.accele[1] = 0;
    *(int *)&accele.accele[2] = 0;
    *(int *)&accele.accele[3] = 0;
    acumu_pad = 0;
    now_status = 0;
    unk_bec = 0;
    unk_75e = 0;
    unk_760 = 0.0f;
    muteki_time = 0;
    guard_flag = 0;
    menu_flag = 0;
    *(int *)&add_speed = 0;
    add_time = 0;
    blow_vec[2] = 0.0f;
    blow_vec[1] = 0.0f;
    blow_vec[0] = 0.0f;
    blow_vec[3] = 1.0f;
    *(int *)&blow_speed = 0;
    blow_time = 0;
    unk_be4 = 0;
    damage_time = 0;
    stagger = 0;
    stagger_time = 0;
    mask_flag = 0;
    dir_gun = 0;
    default_motion = at_2210;
    shot_wait = 0;
    murderous = 0;
    murderous_time = 0;
    target_no = -1;
    lock_on = 0;
    damage_req = 0;
    catch_frame = NULL;
    catch_state = 0;
    no_hit_time = 0;
    release_timing = 0;
    hold_parts = 0;
    hold_frame = 0;
    hold_type = 0;
    unk_72a = -1;
    for (i = 0; i < 9; i++) {
        sw_effect[i].sword_no = 0;
        sw_effect[i].frame0 = NULL;
        sw_effect[i].frame1 = NULL;
        sw_effect[i].chara = NULL;
        sw_effect[i].motion = NULL;
        sw_effect[i].wait = 0;
        sw_effect_num = 0;
    }
    effect_man = NULL;
    shake.time = 0;
    for (j = 0; j < 3; j++) {
        pallet[j].Initialize();
    }
    ResetScript();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actionchara", Copy__12CActionCharaFR12CActionCharaP9mgCMemory);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actionchara", __as__11CCharacter2FRC11CCharacter2);

extern char at_2818[];
extern char at_2840[];

void GuardEffectSet(CScene *scene, float *point) {
    float to_camera[4];
    float position[4];
    ActionVector direction;
    CCameraControl *camera;
    CHitEffectImage *hit;
    CFlushEffect *flush;

    camera = (CCameraControl *)scene->GetCamera(scene->active_camera);
    if (camera == NULL) {
        return;
    }
    sceVu0CopyVector(position, point);
    camera->GetPos(to_camera);
    sceVu0SubVector(to_camera, to_camera, position);
    sceVu0Normalize(to_camera, to_camera);
    sceVu0ScaleVector(to_camera, to_camera, 20.0f);
    sceVu0AddVector(position, position, to_camera);
    direction = *(ActionVector *)at_2818;
    if (BattleFX.hit == NULL) {
        hit = NULL;
    } else {
        hit = BattleFX.hit + BattleFX.hit_next;
        BattleFX.hit_next++;
        if (BattleFX.hit_next >= BattleFX.hit_num) {
            BattleFX.hit_next = 0;
        }
    }
    float spread = 50.0f;
    SethitEffect__15CHitEffectImageFPfPfffffii(hit, position, direction.f,
                                          spread, 30.0f, 0.0f, 0.1f, 30, 32);
    hit->kind = 1;
    if (BattleFX.flush == NULL) {
        flush = NULL;
    } else {
        flush = BattleFX.flush + BattleFX.flush_next;
        BattleFX.flush_next++;
        if (BattleFX.flush_next >= BattleFX.flush_num) {
            BattleFX.flush_next = 0;
        }
    }
    if (flush != NULL) {
        sceVu0CopyVector(flush->pos, position);
        flush->fade_speed = 16.0f;
        flush->alpha = 160;
        flush->active = 1;
        flush->size = 10.0f;
        flush->grow = 3.0f;
        flush->tex_u = 65;
        flush->tex_v = 193;
        flush->tex_size = 62;
        flush->follow = NULL;
    }
    if (FxScriptMan != NULL) {
        FxScriptMan->CreateEffSpt(at_2840, 0, 0);
        FxScriptMan->SetScriptVect1(position, 0, -1);
    }
}



// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_1398__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2048__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2543__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2586__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2720__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2818__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2846__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_3289__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_3291__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_1325__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_1357__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_1358__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_1394__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_1427__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_1428__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2209__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2210__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2211__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2212__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2213__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2214__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2215__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2216__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2217__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2294__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2295__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2333__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2334__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2420__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2421__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2422__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2423__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2504__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2505__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2506__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2507__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2508__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2509__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2510__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2629__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2630__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2631__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2632__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2633__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2634__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2713__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2714__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_2840__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_3085__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_3262__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_3263__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", at_3389__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actionchara", __vt__12CActionChara__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(old_angle, 0x4);
INCLUDE_BSS(ang_3371, 0x4);
INCLUDE_BSS(init_3372, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(at_3107, 0x10);
