#include "common.h"

#include <libvu0.h>

#include <cmath>
#include <cstdio>
#include <cstring>

#include "actionchara.hpp"
#include "actscript.hpp"
#include "automap.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "colprim.hpp"
#include "dataread.hpp"
#include "dng_effect.hpp"
#include "dng_event.hpp"
#include "dng_main.hpp"
#include "dng_status.hpp"
#include "effect.hpp"
#include "effscript.hpp"
#include "gamedata.hpp"
#include "gameutil.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "map.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "menucommon.hpp"
#include "mg_camera.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "padcontrol.hpp"
#include "runscript.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "sceneload.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "sphida.hpp"
#include "swordeffect.hpp"
#include "userdata.hpp"

void           GuardEffectSet(CScene *scene, float *point);

/**
 *
 * Four action values viewed as floats, integers or one quadword.
 *
 */
union ActionVector {
    float     f[4]; /**< Floating point values. */
    int       i[4]; /**< Integer values. */
    u_long128 qw;   /**< Quadword value. */
};

/**
 *
 * Item numbers that a character can throw.
 *
 */
struct ThrowItemTable {
    int item_no[19]; /**< Item numbers. */
};

/**
 *
 * Previous stick direction used by character movement.
 *
 */
static float old_angle;
int                   RockOn_TargetSel(CScene *scene, int index);
int                   DistCheck_Action2(CScene *scene, float unused, float range, float *out_dist, int rank, int *out_rank);
int                   Check_LockOn(CScene *scene, float range, int index);
void                  HitEffectSet(CScene *scene, float *point);
int                   CheckAmuletAvoid(int item_no);
int                   CheckEquipSetItem(int item_no);

// Code (.text)
void CActionChara::ResetAccele() {
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

s32 CActionChara::CheckRunEvent() {
    s32 can_run = menu_flag;

    if (hold_type != 0) {
        can_run = 0;
    }

    return can_run;
}

void CActionChara::SetMaskFlag(int flag, int set) {
    if (set != 0) {
        mask_flag = mask_flag | flag;
    } else {
        mask_flag = mask_flag & ~flag;
    }
}

ACTION_OBJECT *CActionChara::EntryObject(char *name, int no) {
    mgCFrame *entry_frame;
    int       index;

    entry_frame = SearchObject(name);

    if (entry_frame == NULL) {
        return 0;
    }

    index = 0;

    if (no != -1) {
        object[no].frame = entry_frame;
        object[no].pos[2] = 0.0f;
        object[no].pos[1] = 0.0f;
        object[no].pos[0] = 0.0f;
        return &object[no];
    }

    for (; index < 8; index++) {
        if (object[index].frame == 0) {
            object[index].frame = entry_frame;
            object[index].pos[2] = 0.0f;
            object[index].pos[1] = 0.0f;
            object[index].pos[0] = 0.0f;
            return &object[index];
        }
    }

    return 0;
}

void CActionChara::CalcCollision() {
    ACTION_OBJECT *entry = object;
    s32            index = 0;

    do {
        mgCFrame *frame = entry->frame;

        if (frame != NULL) {
            frame->GetWorldPosition0(entry->pos);
        }

        index += 1;
        entry = &entry[1];
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
    int       i;
    float     start_frame;
    float     end_frame;

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
    int   i;
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
    int               i;

    slot = sw_effect;
    i = 0;

    do {
        if (slot->motion == 0) {
            return slot;
        }

        i += 1;
        slot = &slot[1];
    } while (i < 9);

    return NULL;
}

void CActionChara::SetSoundInfoCopy() {
    CActionChara     *chara;
    CHARA_SOUND_INFO *info;

    chara = next;
    info = &sound_info;

    if (chara != NULL) {
        do {
            memcpy(&chara->sound_info, info, sizeof(CHARA_SOUND_INFO));
            chara = chara->next;
        } while (chara != NULL);
    }
}

void CActionChara::SetFadeFlag(int flag) {
    CActionChara *chara = this;

    if (chara != NULL) {
        do {
            chara->fade = flag;
            chara = chara->next;
        } while (chara != NULL);
    }
}

void CActionChara::SetFarDist(float dist) {
    CActionChara *chara = this;

    if (chara != NULL) {
        do {
            chara->far_dist = dist;
            chara = chara->next;
        } while (chara != NULL);
    }
}

void CActionChara::SetNearDist(float dist) {
    CActionChara *chara = this;

    if (chara != NULL) {
        do {
            chara->near_dist = dist;
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
        chara->show = show;
        return;
    }

    if (chara != NULL) {
        do {
            chara->show = show;
            chara = chara->next;
        } while (chara != NULL);
    }
}

int CActionChara::GetShow(char *name) {
    CActionChara *current;
    int           show;

    show = 0;
    current = this;

    if (name != NULL) {
        if (this != NULL) {
            do {
                if (strcmp(current->name, name) == 0) {
                    return current->show;
                }

                current = current->next;
            } while (current != NULL);
        }
    } else {
        show = this->CObject::show;
    }

    return show;
}

int CActionChara::CheckKeri(char *name, int flag) {
    mgCFrame  *object;
    CMapParts *stone;
    CMapPiece *piece;
    float      pos[4];
    float      radius;

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

    stone = AutoMapGen.SearchRandomStone(pos, radius);

    if (stone != NULL) {
        if (flag != 0) {
            piece = stone->SearchPiece("rnd_obj01-a");

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
    mgCFrame         *object;
    CMapParts        *stone;
    CMapPiece        *piece;
    CActionChara     *other;
    CBattleCharaInfo *battle_info;
    float             pos[4];
    float             one;

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
        other = SearchChara("sword");

        if (other != NULL) {
            other->Show(0, 0);
        }

        battle_info = GetBattleCharaInfo();

        if (battle_info->chr_no == 0) {
            other = SearchChara("shot");

            if (other != NULL) {
                other->Show(0, 0);
            }
        }

        battle_info->AddHp_Rate(-0.05f, 3, one);
        return 1;
    }

    object->GetWorldPosition0(pos);
    pos[3] = 1.0f;
    stone = AutoMapGen.SearchRandomStone(pos, 30.0f);

    if (stone != NULL) {
        piece = stone->SearchPiece("rnd_obj01-a");

        if (piece != NULL) {
            piece->Show(0);
        }

        release_timing = 1;
        hold_frame = object;
        hold_parts = stone;
        hold_type = 4;
        other = SearchChara("sword");

        if (other != NULL) {
            other->Show(0, 0);
        }

        if ((GetBattleCharaInfo())->chr_no == 0) {
            other = SearchChara("shot");

            if (other != NULL) {
                other->Show(0, 0);
            }
        }

        return 1;
    }

    return 0;
}

void CActionChara::ThrowItemObject() {
    float          target[4];
    float          position[4];
    CGameDataUsed *item;

    if (hold_type != 0) {
        if (throw_effect >= 0) {
            effect_man->SetScriptProgNo(0x12C, 0, throw_effect);
            sceVu0CopyVector(target, front_vec);
            GetPosition(position);
            sceVu0ScaleVector(target, target, 120.0f);
            sceVu0AddVector(target, target, position);
            effect_man->SetScriptVect1(target, 0, throw_effect);
            hold_type = 0;

            item = GetBattleCharaInfo()->GetActiveItemInfo(0);
            item = &item[DngStatus.active_item];
            item->DeleteNum(1);
        }
    }
}

int CActionChara::UsedItemAction() {
    CBattleCharaInfo *battle_info;
    CGameDataUsed    *item;
    s16               item_no;
    CDataItem        *info;
    int               healing;

    battle_info = GetBattleCharaInfo();
    item = &battle_info->GetActiveItemInfo(0)[DngStatus.active_item];

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

                    effect_man->CreateEffSpt("\x92\xCA\x8F\xED\x89\xF1\x95\x9C", 0, 0);
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
    CGameDataUsed    *item;
    int               index;
    int               item_no;
    CBattleCharaInfo *battle_info;

    battle_info = GetBattleCharaInfo();
    item = &battle_info->GetActiveItemInfo(0)[DngStatus.active_item];
    item_no = item->item_no;
    ThrowItemTable table = {{
        0x114, 0x118, 0x119, 0x11A, 0x11B, 0x11C, 0x11D, 0x11E, 0x11F,
        0x120, 0x121, 0x122, 0x123, 0x124, 0x130, 0x186, 0x187, 0x133, -1
    }};
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

    throw_effect = effect_man->CreateEffSpt("\x8E\xE8\x93\x8A\x82\xB0\x94\x9A\x92" "e", 0, 1);

    if (throw_effect < 0) {
        printf("effect entry err\n");
    } else {
        effect_man->SetValue(0, 1, 0, throw_effect);
        effect_man->SetValue(1, item_no, 0, throw_effect);

        if (action_info.env != NULL) {
            effect_man->SetCharacter(
                &action_info.env->item_chara[index], 0, throw_effect);
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
    float         wait;

    wait = 0.0f;
    current = this;

    if (name != NULL) {
        if (this != NULL) {
            do {
                if (strcmp(current->name, name) == 0) {
                    return current->frame_ratio;
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
    float         frame;

    frame = 0.0f;
    current = this;

    if (name != NULL) {
        if (this != NULL) {
            do {
                if (strcmp(current->name, name) == 0) {
                    return current->frame;
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
    int           result;

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
    int           status;

    status = 0;
    current = this;

    if (name != NULL) {
        if (this != NULL) {
            do {
                if (strcmp(current->name, name) == 0) {
                    return current->motion_status;
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
    CActionChara    *chara;
    CHRINFO_KEY_SET *keys;
    float            frame;

    chara = this;
    frame = 0.0f;

    if (chara_name != NULL) {
        for (; chara != NULL; chara = chara->next) {
            if (strcmp(chara->name, chara_name) == 0) {
                keys = chara->GetKeyListPtr(motion, NULL);

                if (keys != NULL) {
                    return (float) keys->start_frame +
                           ratio * ((float) keys->end_frame - (float) keys->start_frame);
                }
            }
        }
    } else {
        keys = CCharacter2::GetKeyListPtr(motion, NULL);

        if (keys != NULL) {
            frame = (float) keys->start_frame + ratio * ((float) keys->end_frame - (float) keys->start_frame);
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
    float         draw_pos[4];
    float         saved_pos[4];
    float         ambient[4];
    int           result;
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
    float         draw_pos[4];
    float         saved_pos[4];
    float         ambient[4];
    float         pallet_color[4];
    int           result;
    CActionChara *chara;
    int           i;

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
    CActionChara     *watched;
    mgCFrame         *start_frame;
    mgCFrame         *end_frame;
    float             frame;
    int               i;

    i = 0;

    for (; i < sw_effect_num; i++) {

        slot = &sw_effect[i];

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
                                start_frame, end_frame, slot->length, slot->fade_time,
                                slot->hold_time);
                            slot->wait = 5;
                        }
                    }
                }
            }
        }
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
    mgCFrame     *frame;
    mgCFrame     *found;

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
    mgCFrame     *object;
    mgCFrame     *other_frame;
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
    float         my_pos[4];
    float         target_pos[4];
    s16           id;
    CActionChara *target;

    id = target_no;

    if (id != -1) {
        target = static_cast<CActionChara *>(scene->GetCharacter(id));

        if (target != NULL) {
            GetPosition(my_pos);
            target->GetPosition(target_pos);
            return mgDistVector(my_pos, target_pos);
        }
    }

    return -1.0f;
}

/**
 *
 * Finds the next valid monster target for lock-on selection.
 *
 */
int RockOn_TargetSel(CScene *scene, int index) {
    CActiveMonster *target;
    int             tries;

    if (index != -1) {
        index -= 1;

        for (tries = 0; tries < MONSTER_ACTIVE_MAX; tries++) {
            index += 1;

            if (index >= MONSTER_ACTIVE_MAX * 2) {
                index = MONSTER_ACTIVE_MAX;
            }

            target = static_cast<CActiveMonster *>(scene->GetCharacter(index));

            if (target != NULL && target->chara_kind == 2 && target->state == 1 &&
                target->catch_state != 1 &&
                !(target->attrib & 1)) {
                return index;
            }
        }

        return -1;
    }

    for (tries = 0; tries < MONSTER_ACTIVE_MAX; tries++) {
        target = static_cast<CActiveMonster *>(scene->GetCharacter(tries + MONSTER_ACTIVE_MAX));

        if (target != NULL && target->chara_kind == 2 && target->state == 1 &&
            target->catch_state != 1 &&
            !(target->attrib & 1)) {
            return tries + MONSTER_ACTIVE_MAX;
        }
    }

    return -1;
}

/**
 *
 * Selects a monster target by distance rank within a given range.
 *
 */
int DistCheck_Action2(CScene *scene, float unused, float range, float *out_dist, int rank, int *out_rank) {
    float           direction[4];
    float           own_pos[4];
    float           own_rot[4];
    float           entry_pos[4];
    float           front_vec[4];
    float           dists[MONSTER_ACTIVE_MAX];
    int             ids[MONSTER_ACTIVE_MAX];
    CActionChara   *player;
    int             count;
    int             i;
    CActiveMonster *target;
    int             best;
    float           best_dist;
    float           dist;
    int             a;
    int             min;
    int             b;
    float           key;
    int             tmp_id;
    float           tmp_dist;

    player = static_cast<CActionChara *>(scene->GetCharacter(0));
    direction[3] = 1.0f;
    best_dist = range;
    player->GetPosition(own_pos);
    player->GetRotation(own_rot);
    sceVu0CopyVector(front_vec, player->front_vec);
    count = 0;
    best = -1;
    i = 0;

    do {
        target = static_cast<CActiveMonster *>(scene->GetCharacter(i + MONSTER_ACTIVE_MAX));

        if (target != NULL && target->chara_kind == 2 && target->state == 1 &&
            target->catch_state != 1 &&
            !(target->attrib & 1)) {
            target->GetEntryObjectPos(0, 0, entry_pos);
            dist = target->target_dist;

            if (dist < range || target->tbl->boss != 0) {
                if (!(best_dist <= dist) || target->tbl->boss != 0) {
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

/**
 *
 * Checks whether a monster remains valid and within lock-on range.
 *
 */
int Check_LockOn(CScene *scene, float range, int index) {
    float           own_pos[4];
    float           target_pos[4];
    CActionChara   *player;
    CActiveMonster *target;
    int             farther;

    player = static_cast<CActionChara *>(scene->GetCharacter(0));
    player->GetPosition(own_pos);
    target = static_cast<CActiveMonster *>(scene->GetCharacter(index));

    if (target == NULL) {
        return 0;
    }

    if (target->chara_kind != 2) {
        return 0;
    }

    if (target->state != 1) {
        return 0;
    }

    if (target->attrib & 1) {
        return 0;
    }

    if (target->catch_state == 1) {
        return 0;
    }

    if (target->tbl->boss != 0) {
        return 1;
    }

    target->GetEntryObjectPos(0, 0, target_pos);
    own_pos[3] = 1.0f;
    target_pos[3] = 1.0f;
    farther = 1;

    if (target->target_dist <= range) {
        farther = 0;
    }

    return farther = farther ^ 1;
}
void CActionChara::CollisionCheck(float *pos, float *velocity, float *out_velocity) {
    sceVu0FVECTOR      next_position;
    sceVu0FVECTOR      flat_position;
    sceVu0FVECTOR      body_position;
    sceVu0FVECTOR      push_direction;
    CHARA_ENTRY_OBJECT *body;
    float              distance;
    float              separation;
    int                index;

    sceVu0CopyVector(out_velocity, velocity);
    next_position[0] = pos[0] + out_velocity[0];
    next_position[1] = 20.0f + (pos[1] + out_velocity[1]);
    next_position[2] = pos[2] + out_velocity[2];
    next_position[3] = 1.0f;
    sceVu0CopyVector(flat_position, next_position);
    flat_position[1] = 0.0f;

    for (index = 24; index < 48; index++) {
        CActiveMonster *monster = (CActiveMonster *)nowScene__2->GetCharacter(index);
        if (monster == NULL || monster->chara_kind != ACTION_KIND_SCRIPT ||
            monster->state == ACTIVE_MONSTER_NONE ||
            (monster->state == ACTIVE_MONSTER_DEAD && monster->alpha < 0.6f) ||
            monster->catch_state == 1 || monster->no_hit_time > 0 ||
            (monster->attrib & MONSTER_ATTRIB_NO_BODY_HIT) != 0) {
            continue;
        }
        int body_no = 0;
        for (body = monster->GetEntryObjectPos(4, body_no, body_position); body != NULL;
             body = monster->GetEntryObjectPos(4, body_no, body_position)) {
            if (body->enable == 0) {
                body_no++;
                continue;
            }
            if (next_position[1] + body->size < body_position[1] - body_height) {
                body_no++;
                continue;
            }
            if (!(next_position[1] - body->size <= body_position[1] + body_height)) {
                body_no++;
                continue;
            }
            body_position[1] = 0.0f;
            separation = 2.0f * body->size + 2.0f * body_width;
            distance = mgDistVector(body_position, flat_position);
            if (distance < separation) {
                separation -= distance;
                push_direction[0] = flat_position[0] - body_position[0];
                push_direction[1] = flat_position[1] - body_position[1];
                push_direction[2] = flat_position[2] - body_position[2];
                push_direction[3] = 1.0f;
                sceVu0Normalize(push_direction, push_direction);
                out_velocity[0] = (out_velocity[0] + push_direction[0] * separation) / 2.0f;
                out_velocity[1] = (out_velocity[1] + push_direction[1] * separation) / 2.0f;
                out_velocity[2] = (out_velocity[2] + push_direction[2] * separation) / 2.0f;
                out_velocity[3] = 1.0f;
                sceVu0ScaleVector(out_velocity, out_velocity, 1.5f);
            }
            body_no++;
        }
    }
}
void CActionChara::RockOn() {
    float            own_pos[4];
    float            target_pos[4];
    float            to_target[4];
    float            front_vec[4];
    int              priority_index;
    CActiveMonster  *target;
    DNG_BATTLE_AREA *scene_input;

    GetPosition(own_pos);

    scene_input = &nowScene__2->battle_area;
    target_dot = 0.0f;

    if (lock_on != 0) {
        target = static_cast<CActiveMonster *>(nowScene__2->GetCharacter(target_no));

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

            if (scene_input->lock_on_mode == 2) {
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

            target = static_cast<CActiveMonster *>(nowScene__2->GetCharacter(target_no));

            if (target != NULL) {
                if (ActiveMonster->GetPriorityLevelIndex(
                        target->priority + 1, &priority_index) != NULL) {
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
int CActionChara::HumanMoveIF() {
    sceVu0FVECTOR position;
    sceVu0FVECTOR rotation;
    sceVu0FVECTOR move_velocity;
    CActionChara *target;
    float         camera_angle;
    float         stick_x;
    float         stick_y;
    float         move_x;
    float         move_z;
    float         move_speed;
    float         acceleration_step;
    float         acceleration;
    float         stick_direction;
    float         angle_change;
    float         turn_penalty;
    float         relative_angle;
    float         facing;
    float         motion_speed;
    int           boss;
    GetPosition(position);
    GetRotation(rotation);
    sceVu0CopyVector(move_velocity, velocity);
    GetPosition(old_pos);
    camera_angle = action_info.camera->GetAngle();
    stick_x = GamePad__2.GetLXf();
    stick_y = GamePad__2.GetLYf();
    move_x = stick_x * cosf(camera_angle) + stick_y * sinf(camera_angle);
    move_z = -stick_x * sinf(camera_angle) + stick_y * cosf(camera_angle);
    if (GetBattleCharaInfo()->GetAttr() & 0x2) {
        move_x *= 0.5f;
        move_z *= 0.5f;
    }
    sceVu0FVECTOR stick_vector = {move_x, 0.0f, move_z, 1.0f};
    sceVu0FVECTOR target_position;
    move_speed = 3.0f;
    if (lock_on != 0) {
        move_speed = 1.8f;
    }
    acceleration = move_accel;
    acceleration_step = move_speed / 8.0f;
    if (acceleration_step > 0.5f) {
        acceleration_step = 0.5f;
    }
    acceleration += acceleration_step;
    if (acceleration > 1.0f) {
        acceleration = 1.0f;
    }
    move_accel = acceleration;
    stick_direction = atan2f(move_x, move_z);
    angle_change = old_angle - stick_direction;
    if (angle_change > 3.1415927f) {
        angle_change -= 6.2831855f;
    }
    if (angle_change < -3.1415927f) {
        angle_change += 6.2831855f;
    }
    angle_change = mgAbs(angle_change);
    old_angle = stick_direction;
    turn_penalty = 1.5f * (angle_change / 3.1415927f);
    if (turn_penalty > 1.0f) {
        turn_penalty = 1.0f;
    }
    acceleration -= turn_penalty;
    if (acceleration < 0.0f) {
        acceleration = 0.0f;
    }
    move_accel = acceleration;
    move_velocity[0] = acceleration * ((float)mgFrameRate * (move_x * move_speed));
    move_velocity[2] = acceleration * ((float)mgFrameRate * (move_z * move_speed));
    relative_angle = atan2f(move_x, move_z) - rotation[1];
    if (relative_angle > 3.1415927f) {
        relative_angle -= 6.2831855f;
    }
    if (relative_angle < -3.1415927f) {
        relative_angle += 6.2831855f;
    }
    angle_change = stick_angle - relative_angle;
    if (angle_change > 3.1415927f) {
        angle_change -= 6.2831855f;
    }
    if (angle_change < -3.1415927f) {
        angle_change += 6.2831855f;
    }
    angle_change = mgAbs(angle_change);
    if (angle_change / 3.1415927f < 0.3f) {
        stick_time++;
    } else {
        stick_time = 0;
        stick_angle = relative_angle;
    }
    if (GamePad__2.On(PAD_L2) != 0 && DebugInfo.chara_move > 0) {
        move_velocity[0] *= 2.0f;
        move_velocity[2] *= 2.0f;
    }
    target = NULL;
    boss = 0;
    if (lock_on != 0) {
        target = (CActionChara *)nowScene__2->GetCharacter(target_no);
        if (target != NULL) {
            boss = ((CActiveMonster *)target)->tbl->boss;
        }
    }
    if (move_x != 0.0f || move_z != 0.0f) {
        stand_flag = 0;
    } else {
        stand_flag = 1;
    }
    if (lock_on != 0 && boss == 0) {
        if (battle_stance != 0) {
            SetMotion("\x83o\x83g\x83\x8B\x97\xA7\x82\xBF", 0, 1);
        } else {
            SetMotion("\x97\xA7\x82\xBF", 0, 1);
        }
        if (target != NULL && target->chara_kind == ACTION_KIND_SCRIPT) {
            target->GetEntryObjectPos(0, 0, target_position);
            facing = unitRotation(CObjectFrame::frame, atan2f(target_position[0] - position[0], target_position[2] - position[2]), 5.0f);
            SetRotation(0.0f, facing, 0.0f);
            if (move_x != 0.0f || move_z != 0.0f) {
                relative_angle = facing - atan2f(move_x, move_z);
                if (relative_angle < -3.1415927f) {
                    relative_angle += 6.2831855f;
                }
                if (relative_angle > 3.1415927f) {
                    relative_angle -= 6.2831855f;
                }
                if (mgAbs(move_x) > mgAbs(move_z)) {
                    motion_speed = mgAbs(move_x);
                } else {
                    motion_speed = mgAbs(move_z);
                }
                if (relative_angle > -1.0f && relative_angle < 1.0f) {
                    SetMotion("\x83o\x83g\x83\x8B\x95\xE0\x82\xAB\x81i\x91O\x81j", 0, 1);
                }
                if (relative_angle < -2.4f || relative_angle > 2.4f) {
                    SetMotion("\x83o\x83g\x83\x8B\x95\xE0\x82\xAB\x81i\x8C\xE3\x81j", 0, 1);
                }
                if (relative_angle > 1.0f && relative_angle < 2.4f) {
                    SetMotion("\x83o\x83g\x83\x8B\x95\xE0\x82\xAB\x81i\x89" "E\x81j", 0, 1);
                }
                if (relative_angle < -1.0f && relative_angle > -2.4f) {
                    SetMotion("\x83o\x83g\x83\x8B\x95\xE0\x82\xAB\x81i\x8D\xB6\x81j", 0, 1);
                }
                if (motion_speed > 0.6f) {
                    motion_speed = 0.6f;
                }
                SetStep(0.5f * motion_speed);
            }
        }
    } else if (move_x != 0.0f || move_z != 0.0f) {
        SetRotation(0.0f, unitRotation(CObjectFrame::frame, atan2f(move_x, move_z), 5.0f), 0.0f);
        motion_speed = mgDistVector(stick_vector);
        if (motion_speed > 1.0f) {
            motion_speed = 1.0f;
        }
        if (motion_speed >= 0.65f) {
            SetMotion("\x91\x96\x82\xE8", 0, 1);
        } else {
            SetMotion("\x95\xE0\x82\xAB", 0, 1);
            SetStep(motion_speed);
        }
    } else {
        if (battle_stance != 0 || boss != 0) {
            SetMotion("\x83o\x83g\x83\x8B\x97\xA7\x82\xBF", 0, 1);
        } else {
            SetMotion("\x97\xA7\x82\xBF", 0, 1);
        }
        if (target != NULL && boss != 0 && target->chara_kind == ACTION_KIND_SCRIPT) {
            target->GetEntryObjectPos(0, 0, target_position);
            SetRotation(0.0f, unitRotation(CObjectFrame::frame, atan2f(target_position[0] - position[0], target_position[2] - position[2]), 5.0f), 0.0f);
        }
    }
    menu_flag = 1;
    if (GamePad__2.Down(PAD_RIGHT) != 0) {
        sndSePlay(SystemSND_ID, SYSTEM_SE_CURSOR, 0);
        if (DngStatus.active_item == 2) {
            DngStatus.active_item = 0;
        } else {
            DngStatus.active_item++;
        }
    }
    if (GamePad__2.Down(PAD_LEFT) != 0) {
        sndSePlay(SystemSND_ID, SYSTEM_SE_CURSOR, 0);
        if (DngStatus.active_item == 0) {
            DngStatus.active_item = 2;
        } else {
            DngStatus.active_item--;
        }
    }
    if (move_check.landed == 0) {
        menu_flag = 0;
        if (move_velocity[1] <= -3.5f) {
            SetMotion("\x97\x8E\x89\xBA\x92\x86", 0, 1);
        }
    }
    if (DebugInfo.chara_move >= 2) {
        if (GamePad__2.Down(PAD_SQUARE) != 0) {
            move_velocity[1] = 8.0f;
        }
    }
    sceVu0CopyVector(velocity, move_velocity);
    RockOn();
    return 1;
}
int CActionChara::HumanShrowMoveIF() {
    float         camera_angle;
    sceVu0FVECTOR position;
    float         stick_x;
    float         stick_y;
    sceVu0FVECTOR move_velocity;
    CActionChara *target;
    float         move_z;
    sceVu0FVECTOR target_position;
    float         rotation;
    float         speed;
    float         move_x;

    GetPosition(position);
    sceVu0CopyVector(move_velocity, velocity);
    camera_angle = action_info.camera->GetAngle();
    stick_x = GamePad__2.GetLXf();
    stick_y = GamePad__2.GetLYf();
    move_x = stick_x * cosf(camera_angle) + stick_y * sinf(camera_angle);
    move_z = -stick_x * sinf(camera_angle) + stick_y * cosf(camera_angle);
    if (GetBattleCharaInfo()->GetAttr() & 0x2) {
        move_x *= 0.5f;
        move_z *= 0.5f;
    }
    move_x *= 0.8f;
    move_z *= 0.8f;
    move_velocity[0] = 2.0f * move_x * (float)mgFrameRate;
    move_velocity[2] = 2.0f * move_z * (float)mgFrameRate;
    if (move_x != 0.0f || move_z != 0.0f) {
        stand_flag = 0;
    } else {
        stand_flag = 1;
    }
    SetMotion("\x8E\x9D\x82\xBF\x8F\xE3\x82\xB0\x92\xE2\x8E~", 0, 1);
    if (move_x != 0.0f || move_z != 0.0f) {
        rotation = unitRotation(CObjectFrame::frame, atan2f(move_x, move_z), 5.0f);
        SetRotation(0.0f, rotation, 0.0f);
        if (mgAbs(move_x) > mgAbs(move_z)) {
            speed = mgAbs(move_x);
        } else {
            speed = mgAbs(move_z);
        }
        if (speed > 0.5f) {
            speed = 0.5f;
        }
        SetMotion("\x8E\x9D\x82\xBF\x8F\xE3\x82\xB0\x95\xE0\x82\xAB", 0, 1);
        SetStep(0.5f * speed);
    } else if (lock_on != 0) {
        target = (CActionChara *)nowScene__2->GetCharacter(target_no);
        if (target->chara_kind == ACTION_KIND_SCRIPT) {
            target->GetEntryObjectPos(0, 0, target_position);
            rotation = unitRotation(CObjectFrame::frame, atan2f(target_position[0] - position[0], target_position[2] - position[2]), 5.0f);
            SetRotation(0.0f, rotation, 0.0f);
        }
    }
    sceVu0CopyVector(velocity, move_velocity);
    RockOn();
    return 1;
}
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
    movement[0] = 2.0f * world_x * (float) mgFrameRate;
    movement[2] = 2.0f * world_z * (float) mgFrameRate;

    if (world_x != 0.0f || world_z != 0.0f) {
        stand_flag = 0;
    } else {
        stand_flag = 1;
    }

    SetMotion("\x82\xBD\x82\xDF\x83\x8B\x81[\x83v", 0, 1);

    if (world_x != 0.0f || world_z != 0.0f) {
        SetMotion("\x82\xBD\x82\xDF\x88\xDA\x93\xAE", 0, 1);
    }

    sceVu0CopyVector(velocity, movement);
    RockOn();
    return 1;
}

int CActionChara::HumanGunMoveIF(char *stand_motion, char *move_motion) {
    sceVu0FVECTOR position;
    sceVu0FVECTOR move_velocity;
    sceVu0FVECTOR target_position;
    CActionChara *target;
    float         camera_angle;
    float         stick_x;
    float         stick_y;

    GetPosition(position);
    float move_x, move_z;
    sceVu0CopyVector(move_velocity, velocity);
    camera_angle = action_info.camera->GetAngle();
    CGamePad *pad = &GamePad__2;
    stick_x = pad->GetLXf();
    stick_y = pad->GetLYf();
    move_x = stick_x * cosf(camera_angle) + stick_y * sinf(camera_angle);
    move_z = -stick_x * sinf(camera_angle) + stick_y * cosf(camera_angle);
    move_x *= 0.2f;
    move_z *= 0.2f;
    move_velocity[0] = 2.0f * move_x * (float)mgFrameRate;
    move_velocity[2] = 2.0f * move_z * (float)mgFrameRate;
    SetMotion(stand_motion, 0, 1);
    if (move_x != 0.0f || move_z != 0.0f) {
        stand_flag = 0;
    } else {
        stand_flag = 1;
    }
    if (lock_on != 0) {
        target = (CActionChara *)nowScene__2->GetCharacter(target_no);
        if (target != NULL && target->chara_kind == ACTION_KIND_SCRIPT) {
            target->GetEntryObjectPos(0, 0, target_position);
            float target_angle = atan2f(target_position[0] - position[0], target_position[2] - position[2]);
            SetRotation(0.0f, unitRotation(CObjectFrame::frame, target_angle, 5.0f), 0.0f);
            if (move_x != 0.0f || move_z != 0.0f) {
                SetMotion(move_motion, 0, 1);
            }
        }
    } else if (move_x != 0.0f || move_z != 0.0f) {
        float move_angle = atan2f(move_x, move_z);
        SetRotation(0.0f, unitRotation(CObjectFrame::frame, move_angle, 5.0f), 0.0f);
        SetMotion(move_motion, 0, 1);
    }
    sceVu0CopyVector(velocity, move_velocity);
    RockOn();
    return 1;
}
int CActionChara::RoboWalkMoveIF(int mode) {
    sceVu0FVECTOR position;
    sceVu0FVECTOR move_velocity;
    sceVu0FVECTOR movement;
    sceVu0FVECTOR target_position;
    sceVu0FVECTOR rotation;
    CActionChara *target;
    CActionChara *arm;
    float         camera_angle;
    float         stick_x;
    float         stick_y;
    float         move_z;
    float         motion_speed;
    float         target_angle;

    GetPosition(position);
    sceVu0CopyVector(move_velocity, velocity);
    camera_angle = action_info.camera->GetAngle();
    stick_x = GamePad__2.GetLXf();
    stick_y = GamePad__2.GetLYf();
    float stick_world_x = stick_x * cosf(camera_angle) + stick_y * sinf(camera_angle);
    float move_x = stick_world_x;
    move_z = -stick_x * sinf(camera_angle) + stick_y * cosf(camera_angle);
    move_x = move_x * (2.0f * (float)mgFrameRate);
    move_z = move_z * (2.0f * (float)mgFrameRate);
    move_velocity[0] = move_x;
    move_velocity[2] = move_z;
    stand_flag = 0;
    if (lock_on != 0) {
        if (move_x != 0.0f || move_z != 0.0f) {
            SetRotation(0.0f, unitRotation(CObjectFrame::frame, atan2f(move_x, move_z), 5.0f), 0.0f);
            movement[0] = move_x;
            movement[1] = 0.0f;
            movement[2] = move_z;
            motion_speed = mgDistVector(movement) / max_speed;
            if (motion_speed > 1.0f) {
                motion_speed = 1.0f;
            }
            if (motion_speed >= 0.8f) {
                SetMotion("\x91\x96\x82\xE8-\x91\xAB", 0, mode);
            } else {
                SetMotion("\x95\xE0\x82\xAB-\x91\xAB", 0, mode);
            }
        } else {
            SetMotion("\x97\xA7\x82\xBF-\x91\xAB", 0, mode);
        }
        target = (CActionChara *)nowScene__2->GetCharacter(target_no);
        if (target && target->chara_kind == ACTION_KIND_SCRIPT) {
            target->GetPosition(target_position);
            target_angle = atan2f(target_position[0] - position[0], target_position[2] - position[2]);
            GetRotation(rotation);
            target_angle -= rotation[1];
            if (target_angle < -3.1415927f) {
                target_angle += 6.2831855f;
            }
            if (target_angle > 3.1415927f) {
                target_angle -= 6.2831855f;
            }
            arm = SearchChara("arm");
            if (arm != NULL) {
                arm->SetRotation(0.0f, unitRotation(arm->CObjectFrame::frame, target_angle, 3.0f), 0.0f);
            }
        }
    } else {
        arm = SearchChara("arm");
        if (arm != NULL) {
            arm->SetRotation(0.0f, unitRotation(arm->CObjectFrame::frame, 0.0f, 16.0f), 0.0f);
        }
        if (move_x != 0.0f || move_z != 0.0f) {
            sceVu0FVECTOR movement;
            SetRotation(0.0f, unitRotation(CObjectFrame::frame, atan2f(move_x, move_z), 10.0f), 0.0f);
            movement[0] = move_x;
            movement[1] = 0.0f;
            movement[2] = move_z;
            motion_speed = mgDistVector(movement) / max_speed;
            if (motion_speed > 1.0f) {
                motion_speed = 1.0f;
            }
            if (motion_speed >= 0.8f) {
                SetMotion("\x91\x96\x82\xE8-\x91\xAB", 0, mode);
            } else {
                SetMotion("\x95\xE0\x82\xAB-\x91\xAB", 0, mode);
            }
        } else {
            SetMotion("\x97\xA7\x82\xBF-\x91\xAB", 0, mode);
        }
    }
    sceVu0CopyVector(velocity, move_velocity);
    menu_flag = 1;
    RockOn();
    return 1;
}
int CActionChara::RoboTankMoveIF(int mode) {
    sceVu0FVECTOR position;
    sceVu0FVECTOR move_velocity;
    sceVu0FVECTOR movement;
    sceVu0FVECTOR target_position;
    sceVu0FVECTOR rotation;
    CActionChara *target;
    CActionChara *arm;
    float         camera_angle;
    float         stick_x;
    float         motion_speed;
    float         target_angle;
    mgCFrame     *wheel;
    float         wheel_step;

    GetPosition(position);
    sceVu0CopyVector(move_velocity, velocity);
    camera_angle = action_info.camera->GetAngle();
    stick_x = GamePad__2.GetLXf();
    float stick_y = GamePad__2.GetLYf();
    float stick_world_x = stick_x * cosf(camera_angle) + stick_y * sinf(camera_angle);
    float move_x = stick_world_x;
    float move_z = -stick_x * sinf(camera_angle) + stick_y * cosf(camera_angle);
    move_x *= 2.0f * (float)mgFrameRate;
    move_z = move_z * (2.0f * (float)mgFrameRate);
    if (move_type == ACTION_MOVE_ROBO_TANK) {
        sound_info.loop_se->SeLoopPlayStop(sound_info.se_bank, 14, 3, 12);
        if (move_x != 0.0f || move_z != 0.0f) {
            sound_info.foot_effect_wait = 6;
        }
    }
    if (move_type == ACTION_MOVE_ROBO_TANK2) {
        move_x *= 1.3f;
        move_z *= 1.3f;
    }
    move_velocity[0] = move_x;
    move_velocity[2] = move_z;
    stand_flag = 0;
    if (lock_on) {
        if (move_x != 0.0f || move_z != 0.0f) {
            SetRotation(0.0f, unitRotation(CObjectFrame::frame, atan2f(move_x, move_z), 5.0f), 0.0f);
            movement[0] = move_x;
            movement[1] = 0.0f;
            movement[2] = move_z;
            motion_speed = mgDistVector(movement) / max_speed;
            if (motion_speed > 1.0f) {
                motion_speed = 1.0f;
            }
            if (motion_speed >= 0.8f) {
                SetMotion("\x91\x96\x82\xE8-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
            } else {
                SetMotion("\x95\xE0\x82\xAB-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
            }
        } else {
            SetMotion("\x97\xA7\x82\xBF-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
        }
        CCharacter2 *target_chara = nowScene__2->GetCharacter(target_no);
        target = (CActionChara *)target_chara;
        if (target != NULL && target->chara_kind == ACTION_KIND_SCRIPT) {
            target->GetPosition(target_position);
            target_angle = atan2f(target_position[0] - position[0], target_position[2] - position[2]);
            GetRotation(rotation);
            target_angle -= rotation[1];
            if (target_angle < -3.1415927f) {
                target_angle += 6.2831855f;
            }
            if (target_angle > 3.1415927f) {
                target_angle -= 6.2831855f;
            }
            arm = SearchChara("arm");
            if (arm != NULL) {
                arm->SetRotation(0.0f, unitRotation(arm->CObjectFrame::frame, target_angle, 3.0f), 0.0f);
            }
        }
    } else {
        arm = SearchChara("arm");
        if (arm != NULL) {
            arm->SetRotation(0.0f, unitRotation(arm->CObjectFrame::frame, 0.0f, 16.0f), 0.0f);
        }
        if (move_x != 0.0f || move_z != 0.0f) {
            sceVu0FVECTOR movement;
            SetRotation(0.0f, unitRotation(CObjectFrame::frame, atan2f(move_x, move_z), 10.0f), 0.0f);
            movement[0] = move_x;
            movement[1] = 0.0f;
            movement[2] = move_z;
            motion_speed = mgDistVector(movement) / max_speed;
            if (motion_speed > 1.0f) {
                motion_speed = 1.0f;
            }
            if (motion_speed >= 0.8f) {
                SetMotion("\x91\x96\x82\xE8-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
            } else {
                SetMotion("\x95\xE0\x82\xAB-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
            }
        } else {
            SetMotion("\x97\xA7\x82\xBF-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
        }
    }
    if (move_type == ACTION_MOVE_ROBO_TANK2) {
        sceVu0FVECTOR wheel_rotation;
        float speed = mgDistVector(move_velocity);
        wheel_step = 0.034906585f * -speed;
        wheel = SearchObject("rf_tire");
        if (wheel != NULL) {
            wheel->SetRotType(2);
            wheel->GetRotation(wheel_rotation);
            wheel_rotation[2] += wheel_step;
            wheel_rotation[2] = mgAngleLimit(wheel_rotation[2]);
            wheel->SetRotation(wheel_rotation);
        }
        wheel = SearchObject("rb_tire");
        if (wheel != NULL) {
            wheel->SetRotType(2);
            wheel->GetRotation(wheel_rotation);
            wheel_rotation[2] += wheel_step;
            wheel_rotation[2] = mgAngleLimit(wheel_rotation[2]);
            wheel->SetRotation(wheel_rotation);
        }
        wheel = SearchObject("lf_tire");
        if (wheel != NULL) {
            wheel->SetRotType(2);
            wheel->GetRotation(wheel_rotation);
            wheel_rotation[2] += wheel_step;
            wheel_rotation[2] = mgAngleLimit(wheel_rotation[2]);
            wheel->SetRotation(wheel_rotation);
        }
        wheel = SearchObject("lb_tire");
        if (wheel != NULL) {
            wheel->SetRotType(2);
            wheel->GetRotation(wheel_rotation);
            wheel_rotation[2] += wheel_step;
            wheel_rotation[2] = mgAngleLimit(wheel_rotation[2]);
            wheel->SetRotation(wheel_rotation);
        }
    }
    sceVu0CopyVector(velocity, move_velocity);
    menu_flag = 1;
    RockOn();
    return 1;
}
int CActionChara::RoboBikeMoveIF(int mode) {
    sceVu0FVECTOR position;
    sceVu0FVECTOR leg_rotation;
    sceVu0FVECTOR movement;
    sceVu0FVECTOR rotation;
    int           poly_count;
    CActionChara *arm;
    CActionChara *target;
    CMap         *map;
    float         stick_x;
    float         stick_y;
    float         target_angle;
    CActionChara *leg;
    float         slope_angle;
    mgCFrame     *front_wheel;
    mgCFrame     *back_wheel;
    mgCFrame     *tilt;

    leg = SearchChara("leg");
    if (leg == NULL) {
        return 0;
    }
    GetPosition(position);
    leg->GetRotation(leg_rotation);
    stick_x = GamePad__2.GetLXf();
    stick_y = GamePad__2.GetLYf();
    stand_flag = 0;
    if (move_check.width_result & 0x8) {
        if (accele.speed != 0.0f) {
            if (accele.speed < 0.0f) {
                accele.speed += 0.1f;
                if (accele.speed > 0.0f) {
                    accele.speed = 0.0f;
                }
            }
            if (accele.speed > 0.0f) {
                accele.speed -= 0.1f;
                if (accele.speed < 0.0f) {
                    accele.speed = 0.0f;
                }
            }
        }
    }
    if (stick_y < 0.0f) {
        accele.speed += -0.2f * stick_y;
    }
    if (stick_y > 0.0f) {
        accele.speed += -0.15f * stick_y;
    }
    if (accele.speed > 12.0f) {
        accele.speed = 12.0f;
    }
    if (accele.speed < -3.0f) {
        accele.speed = -3.0f;
    }
    if (accele.speed > 0.2f) {
        sound_info.foot_effect_wait = 2;
        sound_info.loop_se->SeLoopPlayStop(sound_info.se_bank, 16, 3, 12);
    }
    if (GamePad__2.On(PAD_L1) != 0) {
        leg_rotation[1] += 0.8f * (0.034906585f * -stick_x * accele.speed);
    } else {
        leg_rotation[1] += 0.2f * (0.034906585f * -stick_x * accele.speed);
    }
    leg_rotation[1] = mgAngleLimit(leg_rotation[1]);
    leg->SetRotation(leg_rotation);
    if (leg != NULL) {
        leg->GetRotation(rotation);
        sceVu0FVECTOR direction = { 0.0f, 0.0f, 1.0f, 1.0f };
        sceVu0FMATRIX matrix;
        sceVu0UnitMatrix(matrix);
        sceVu0RotMatrixY(matrix, matrix, rotation[1]);
        sceVu0ApplyMatrix(movement, matrix, direction);
    } else {
        sceVu0CopyVector(movement, front_vec);
    }
    sceVu0ScaleVector(movement, movement, accele.speed);
    if (accele.speed != 0.0f) {
        SetMotion("\x95\xE0\x82\xAB-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
        if (stick_x > 0.5f) {
            SetMotion("\x89" "E\x90\xF9\x89\xF1", 0, mode);
        }
        if (stick_x < -0.5f) {
            SetMotion("\x8D\xB6\x90\xF9\x89\xF1", 0, mode);
        }
    } else {
        SetMotion("\x97\xA7\x82\xBF-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
    }
    if (lock_on != 0) {
        target = (CActionChara *)nowScene__2->GetCharacter(target_no);
        if (target != NULL && target->chara_kind == ACTION_KIND_SCRIPT) {
            sceVu0FVECTOR target_position;
            sceVu0FVECTOR target_rotation;
            target->GetPosition(target_position);
            target_angle = atan2f(target_position[0] - position[0], target_position[2] - position[2]);
            GetRotation(target_rotation);
            target_angle -= target_rotation[1];
            if (target_angle < -3.1415927f) {
                target_angle += 6.2831855f;
            }
            if (target_angle > 3.1415927f) {
                target_angle -= 6.2831855f;
            }
            arm = SearchChara("arm");
            if (arm != NULL) {
                target_angle = unitRotation(arm->CObjectFrame::frame, target_angle, 3.0f);
                arm->SetRotation(0.0f, target_angle, 0.0f);
            }
        }
    } else {
        arm = SearchChara("arm");
        if (arm != NULL) {
            float arm_angle = unitRotation(arm->CObjectFrame::frame, 0.0f, 8.0f);
            arm->SetRotation(0.0f, arm_angle, 0.0f);
        }
    }
    map = nowScene__2->GetMap(nowScene__2->active_map);
    CCPoly        polys[128];
    mgVu0FBOX     box;
    sceVu0FVECTOR wheel_rotation;
    sceVu0FVECTOR front_hit;
    sceVu0FVECTOR back_hit;
    sceVu0FVECTOR front_wheel_position;
    sceVu0FVECTOR back_wheel_position;

    box.max[0] = 50.0f + position[0];
    box.min[0] = position[0] - 50.0f;
    box.max[1] = 50.0f + position[1];
    box.min[1] = position[1] - 50.0f;
    box.max[2] = 50.0f + position[2];
    box.min[2] = position[2] - 50.0f;
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    poly_count = map->GetColPoly(polys, box, 128);
    front_wheel = SearchObject("f_tire");
    if (front_wheel != NULL) {
        front_wheel->SetRotType(2);
        front_wheel->GetRotation(wheel_rotation);
        wheel_rotation[2] += 0.034906585f * -accele.speed;
        wheel_rotation[2] = mgAngleLimit(wheel_rotation[2]);
        front_wheel->SetRotation(wheel_rotation);
        front_wheel->GetWorldPosition0(front_wheel_position);
        front_wheel_position[1] = 50.0f + position[1];
        if (CheckHitVertical(polys, poly_count, front_wheel_position, -100.0f, front_hit, 1) < 0) {
            sceVu0CopyVector(front_hit, front_wheel_position);
            front_hit[1] = position[1] - 10.0f;
        }
        if (position[1] - front_hit[1] > 20.0f) {
            front_hit[1] = position[1] - 20.0f;
        }
    }
    back_wheel = SearchObject("b_tire");
    if (back_wheel != NULL) {
        back_wheel->SetRotType(2);
        back_wheel->GetRotation(wheel_rotation);
        wheel_rotation[2] += 0.034906585f * -accele.speed;
        wheel_rotation[2] = mgAngleLimit(wheel_rotation[2]);
        back_wheel->SetRotation(wheel_rotation);
        back_wheel->GetWorldPosition0(back_wheel_position);
        back_wheel_position[1] = 50.0f + position[1];
        if (CheckHitVertical(polys, poly_count, back_wheel_position, -100.0f, back_hit, 1) < 0) {
            sceVu0CopyVector(back_hit, back_wheel_position);
            back_hit[1] = position[1] - 10.0f;
        }
        if (position[1] - back_hit[1] > 20.0f) {
            back_hit[1] = position[1] - 20.0f;
        }
    }
    sceVu0SubVector(front_hit, back_hit, front_hit);
    sceVu0CopyVector(back_hit, front_hit);
    back_hit[3] = 1.0f;
    back_hit[1] = 0.0f;
    slope_angle = atan2f(front_hit[1], mgDistVector(back_hit));
    tilt = SearchObject("katamuki");
    if (tilt != NULL) {
        sceVu0FVECTOR slope_rotation = { slope_angle, 0.0f, 0.0f, 1.0f };
        tilt->SetRotType(2);
        tilt->SetRotation(slope_rotation);
    }
    sceVu0FVECTOR old_velocity;
    sceVu0CopyVector(old_velocity, velocity);
    movement[1] = old_velocity[1];
    sceVu0CopyVector(velocity, movement);
    menu_flag = 1;
    RockOn();
    return 1;
}
int CActionChara::RoboAirMoveIF(int unk, int mode) {
    sceVu0FVECTOR position;
    sceVu0FVECTOR move_velocity;
    CActionChara *target;
    CActionChara *arm;
    float         camera_angle;
    float         stick_x;
    float         stick_y;
    float         move_x;
    float         move_z;
    float         motion_speed;
    float         target_angle;
    sceVu0FVECTOR propeller_rotation;
    mgCFrame     *propeller;
    float         turn_speed;
    float         speed_limit;

    GetPosition(position);
    sceVu0CopyVector(move_velocity, velocity);
    camera_angle = action_info.camera->GetAngle();
    stick_x = GamePad__2.GetLXf();
    stick_y = GamePad__2.GetLYf();
    move_x = stick_x * cosf(camera_angle) + stick_y * sinf(camera_angle);
    move_z = -stick_x * sinf(camera_angle) + stick_y * cosf(camera_angle);
    stand_flag = 0;
    speed_limit = 7.0f;
    turn_speed = 8.0f;
    accele.accele[0] += move_x;
    accele.accele[2] += move_z;
    if (move_type == ACTION_MOVE_ROBO_AIR2) {
        speed_limit = 8.0f;
        turn_speed = 4.0f;
    }
    if (accele.accele[0] > speed_limit) {
        accele.accele[0] = speed_limit;
    }
    if (accele.accele[0] < -speed_limit) {
        accele.accele[0] = -speed_limit;
    }
    if (accele.accele[2] > speed_limit) {
        accele.accele[2] = speed_limit;
    }
    if (accele.accele[2] < -speed_limit) {
        accele.accele[2] = -speed_limit;
    }
    move_x = accele.accele[0];
    move_velocity[0] = move_x;
    move_z = accele.accele[2];
    move_velocity[2] = move_z;
    accele.accele[0] *= 0.96f;
    accele.accele[2] *= 0.96f;
    if (move_type == ACTION_MOVE_ROBO_AIR) {
        sound_info.foot_effect_wait = 2;
        sound_info.loop_se->SeLoopPlayStop(sound_info.se_bank, 20, 3, 12);
        propeller = SearchObject("prop1");
        if (propeller != NULL) {
            propeller->GetRotation(propeller_rotation);
            propeller_rotation[1] -= 0.5067085f;
            propeller_rotation[1] = mgAngleLimit(propeller_rotation[1]);
            propeller->SetRotation(propeller_rotation);
        }
        propeller = SearchObject("prop2");
        if (propeller != NULL) {
            propeller->GetRotation(propeller_rotation);
            propeller_rotation[1] += 0.49087387f;
            propeller_rotation[1] = mgAngleLimit(propeller_rotation[1]);
            propeller->SetRotation(propeller_rotation);
        }
    }
    if (move_type == ACTION_MOVE_ROBO_AIR2) {
        sound_info.foot_effect_wait = 2;
        sound_info.loop_se->SeLoopPlayStop(sound_info.se_bank, 21, 3, 12);
    }
    if (lock_on != 0) {
        sceVu0FVECTOR movement;
        sceVu0FVECTOR target_position;
        sceVu0FVECTOR rotation;
        if (move_x != 0.0f || move_z != 0.0f) {
            SetRotation(0.0f, unitRotation(CObjectFrame::frame, atan2f(move_x, move_z), turn_speed), 0.0f);
            movement[0] = move_x;
            movement[1] = 0.0f;
            movement[2] = move_z;
            motion_speed = mgDistVector(movement) / max_speed;
            if (motion_speed > 1.0f) {
                motion_speed = 1.0f;
            }
            if (motion_speed >= 0.8f) {
                SetMotion("\x91\x96\x82\xE8-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
            } else {
                SetMotion("\x95\xE0\x82\xAB-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
            }
        } else {
            SetMotion("\x97\xA7\x82\xBF-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
        }
        target = (CActionChara *)nowScene__2->GetCharacter(target_no);
        if (target != NULL && target->chara_kind == ACTION_KIND_SCRIPT) {
            target->GetPosition(target_position);
            target_angle = atan2f(target_position[0] - position[0], target_position[2] - position[2]);
            GetRotation(rotation);
            target_angle -= rotation[1];
            if (target_angle < -3.1415927f) {
                target_angle += 6.2831855f;
            }
            if (target_angle > 3.1415927f) {
                target_angle -= 6.2831855f;
            }
            arm = SearchChara("arm");
            if (arm != NULL) {
                target_angle = unitRotation(arm->CObjectFrame::frame, target_angle, 3.0f);
                arm->SetRotation(0.0f, target_angle, 0.0f);
            }
        }
    } else {
        arm = SearchChara("arm");
        if (arm != NULL) {
            arm->SetRotation(0.0f, unitRotation(arm->CObjectFrame::frame, 0.0f, 16.0f), 0.0f);
        }
        if (move_x != float(0.0) || move_z != 0.0f) {
            sceVu0FVECTOR movement;
            float angle = atan2f(move_x, move_z);
            SetRotation(0.0f, unitRotation(CObjectFrame::frame, angle, turn_speed), 0.0f);
            movement[0] = move_x;
            movement[1] = 0.0f;
            movement[2] = move_z;
            motion_speed = mgDistVector(movement) / max_speed;
            if (motion_speed > 1.0f) {
                motion_speed = 1.0f;
            }
            if (motion_speed >= 0.8f) {
                SetMotion("\x91\x96\x82\xE8-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
            } else {
                SetMotion("\x95\xE0\x82\xAB-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
            }
        } else {
            SetMotion("\x97\xA7\x82\xBF-\x83L\x83\x83\x83^\x83s\x83\x89", 0, mode);
        }
    }
    sceVu0CopyVector(velocity, move_velocity);
    menu_flag = 1;
    RockOn();
    return 1;
}
int CActionChara::MonsterMoveIF() {
    sceVu0FVECTOR position;
    sceVu0FVECTOR rotation;
    sceVu0FVECTOR move_velocity;
    CActionChara *target;
    float         camera_angle;
    float         stick_x;
    float         stick_y;
    float         move_x;
    float         move_z;
    float         move_speed;
    float         acceleration_step;
    float         acceleration;
    float         stick_direction;
    float         angle_change;
    float         turn_penalty;
    float         relative_angle;
    float         motion_speed;
    float         abs_x;
    float         abs_z;

    GetPosition(position);
    GetRotation(rotation);
    sceVu0CopyVector(move_velocity, velocity);
    GetPosition(old_pos);
    stand_flag = 0;
    camera_angle = action_info.camera->GetAngle();
    stick_x = GamePad__2.GetLXf();
    stick_y = GamePad__2.GetLYf();
    move_x = stick_x * cosf(camera_angle) + stick_y * sinf(camera_angle);
    move_z = -stick_x * sinf(camera_angle) + stick_y * cosf(camera_angle);
    if (GetBattleCharaInfo()->GetAttr() & 0x2) {
        move_x *= 0.5f;
        move_z *= 0.5f;
    }
    sceVu0FVECTOR stick_vector = { 0.0f, 0.0f, 0.0f, 1.0f };
    stick_vector[0] = move_x;
    stick_vector[2] = move_z;
    move_speed = accele.move_speed;
    if (lock_on != 0) {
        move_speed *= 0.6f;
    }
    acceleration = move_accel;
    acceleration_step = move_speed / 8.0f;
    if (acceleration_step > 0.5f) {
        acceleration_step = 0.5f;
    }
    acceleration += acceleration_step;
    if (acceleration > 1.0f) {
        acceleration = 1.0f;
    }
    move_accel = acceleration;
    stick_direction = atan2f(move_x, move_z);
    angle_change = old_angle - stick_direction;
    if (angle_change > 3.1415927f) {
        angle_change -= 6.2831855f;
    }
    if (angle_change < -3.1415927f) {
        angle_change += 6.2831855f;
    }
    angle_change = angle_change < 0.0f ? -angle_change : angle_change;
    old_angle = stick_direction;
    turn_penalty = 1.5f * (angle_change / 3.1415927f);
    if (turn_penalty > 1.0f) {
        turn_penalty = 1.0f;
    }
    acceleration -= turn_penalty;
    if (acceleration < 0.0f) {
        acceleration = 0.0f;
    }
    move_accel = acceleration;
    move_velocity[0] = acceleration * ((float)mgFrameRate * (move_x * move_speed));
    move_velocity[2] = acceleration * ((float)mgFrameRate * (move_z * move_speed));
    relative_angle = atan2f(move_x, move_z) - rotation[1];
    if (relative_angle > 3.1415927f) {
        relative_angle -= 6.2831855f;
    }
    if (relative_angle < -3.1415927f) {
        relative_angle += 6.2831855f;
    }
    angle_change = stick_angle - relative_angle;
    if (angle_change > 3.1415927f) {
        angle_change -= 6.2831855f;
    }
    if (angle_change < -3.1415927f) {
        angle_change += 6.2831855f;
    }
    angle_change = angle_change < 0.0f ? -angle_change : angle_change;
    if (angle_change / 3.1415927f < 0.3f) {
        stick_time++;
    } else {
        stick_time = 0;
        stick_angle = relative_angle;
    }
    if (GamePad__2.On(PAD_L2) != 0 && DebugInfo.chara_move > 0) {
        move_velocity[0] *= 2.0f;
        move_velocity[2] *= 2.0f;
    }
    if (move_x != 0.0f || move_z != 0.0f) {
        SetRotation(0.0f, unitRotation(CObjectFrame::frame, atan2f(move_x, move_z), 5.0f), 0.0f);
        motion_speed = mgDistVector(stick_vector);
        if (motion_speed > 1.0f) {
            motion_speed = 1.0f;
        }
        if (motion_speed < 0.45f) {
            motion_speed = 0.45f;
        }
        if (motion_speed >= 0.65f) {
            SetMotion("\x91\x96\x82\xE8", 0, 1);
        } else {
            SetMotion("\x95\xE0\x82\xAB", 0, 1);
            SetStep(motion_speed);
        }
    } else if (lock_on != 0) {
        SetMotion("\x97\xA7\x82\xBF", 0, 1);
        target = (CActionChara *)nowScene__2->GetCharacter(target_no);
        if (target != NULL && target->chara_kind == ACTION_KIND_SCRIPT) {
            sceVu0FVECTOR target_position;
            target->GetEntryObjectPos(0, 0, target_position);
            SetRotation(0.0f, unitRotation(CObjectFrame::frame, atan2f(target_position[0] - position[0], target_position[2] - position[2]), 5.0f), 0.0f);
        }
    } else {
        SetMotion("\x97\xA7\x82\xBF", 0, 1);
    }
    if (DebugInfo.chara_move >= 2) {
        if (GamePad__2.Down(PAD_SQUARE) != 0) {
            move_velocity[1] = 8.0f;
        }
    }
    sceVu0CopyVector(velocity, move_velocity);
    menu_flag = 1;
    RockOn();
    return 1;
}

/**
 *
 * Creates hit effects at the impact point facing the active camera.
 *
 */
void HitEffectSet(CScene *scene, float *point) {
    float            pos[4];
    float            to_camera[4];
    float            origin[4];
    CCameraControl  *camera;
    CHitEffectImage *hit;
    CFlushEffect    *flush;
    float            speed = 50.0f;

    camera = (CCameraControl *) scene->GetCamera(scene->active_camera);

    if (camera == NULL) {
        return;
    }

    sceVu0CopyVector(origin, point);
    camera->GetPos(to_camera);
    sceVu0SubVector(to_camera, to_camera, origin);
    sceVu0Normalize(to_camera, to_camera);
    sceVu0ScaleVector(to_camera, to_camera, 20.0f);
    sceVu0AddVector(pos, origin, to_camera);
    ActionVector dir = {{0.0f, 1.0f, 0.0f, 1.0f}};
    ActionVector rect;

    if (BattleFX.hit == NULL) {
        hit = NULL;
    } else {
        int hit_index = BattleFX.hit_next;
        hit = &BattleFX.hit[hit_index];
        BattleFX.hit_next++;

        if (BattleFX.hit_next >= BattleFX.hit_num) {
            BattleFX.hit_next = 0;
        }
    }

    if (hit != NULL) {
        hit->SethitEffect(pos, dir.f, 30.0f, speed * 1.0f, 0.4f, 0.1f, 30, 32);
        hit->kind = 0;
    }

    if (BattleFX.flush == NULL) {
        flush = NULL;
    } else {
        flush = &BattleFX.flush[BattleFX.flush_next];
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
        int hit_index = BattleFX.hit_next;
        hit = &BattleFX.hit[hit_index];
        BattleFX.hit_next++;

        if (BattleFX.hit_next >= BattleFX.hit_num) {
            BattleFX.hit_next = 0;
        }
    }

    if (hit != NULL) {
        hit->SethitEffect(pos, dir.f, 40.0f, 40.0f, 0.0f, 0.05f, 32,
                          32);
        hit->kind = 0;
        ((mgRect<int> *) &rect)->Set(0, 80, 16, 16);
        ActionVector copy = rect;
        hit->tex_rect.left = copy.i[0];
        hit->tex_rect.top = copy.i[1];
        hit->tex_rect.right = copy.i[2];
        hit->tex_rect.bottom = copy.i[3];
        hit->sprite_size = 2.0f;
    }
}

/**
 *
 * Checks whether an active item prevents a status effect, occasionally consuming it.
 *
 */
int CheckAmuletAvoid(int item_no) {
    CBattleCharaInfo *info;
    CGameDataUsed    *item;
    int               i;

    info = GetBattleCharaInfo();

    switch (info->chr_no) {
        case 1:
        case 0:
            item = info->GetActiveItemInfo(0);
            i = 0;

            do {
                if (item_no == item->item_no) {
                    if (iRand(100) % 3 == 0) {
                        item->DeleteNum(1);
                    }

                    return 1;
                }

                i++;
                item = &item[1];
            } while (i < 3);

            return 0;
        default:
            return 1;
    }
}

/**
 *
 * Consumes a matching active item and reports whether one was found.
 *
 */
int CheckEquipSetItem(int item_no) {
    CBattleCharaInfo *info;
    CGameDataUsed    *item;
    int               i;

    info = GetBattleCharaInfo();

    switch (info->chr_no) {
        case 1:
        case 0:
            item = info->GetActiveItemInfo(0);
            i = 0;

            do {
                if (item_no == item->item_no) {
                    item->DeleteNum(1);
                    return 1;
                }

                i++;
                item = &item[1];
            } while (i < 3);

            return 0;
        default:
            return 0;
    }
}
int CActionChara::CheckDamage() {
    sceVu0FVECTOR    position;
    CBattleCharaInfo *battle;
    CColPrim        *hit;
    float            damage;
    u32              attributes;
    int              max_hp;
    int              now_hp;
    int              damage_points;
    int              guarded;
    int              immobilized;
    int              reaction;
    int              handled;
    int              element;
    int              strongest;
    int              index;

    if (nowScene__2 == NULL) {
        return 0;
    }
    DNG_BATTLE_AREA *battle_area = &nowScene__2->battle_area;
    u32 battle_sound = nowScene__2->se_battle_id;
    u32 chara_sound = sound_info.se_bank;
    battle = GetBattleCharaInfo();
    GetPosition(position);
    if (damage_time > 0) {
        return 0;
    }
    if (muteki_time > 0) {
        return 0;
    }
    handled = 0;
    hit = ColPrimMan.CheckHit(0);
    if (hit != NULL) {
        immobilized = 0;
        attributes = battle->GetAttr();
        if ((attributes & (CHARA_STATUS_UNK_8 | CHARA_STATUS_UNK_20)) != 0) {
            immobilized = 1;
        }
        max_hp = battle->GetMaxHp_i();
        now_hp = battle->GetNowHp_i();
        damage = hit->damage * (1.0f + fRand(0.15f));
        damage -= battle->GetDefenceVol();
        if (damage <= 0.0f) {
            damage = 0.0f;
        }
        if (hit->param->hit_count > 1) {
            damage /= hit->param->hit_count;
        }
        damage += 1.0f + fRand(2.0f);
        if ((hit->status & 0x1000) != 0) {
            damage = (int)(max_hp * (0.01f * hit->damage));
            if (now_hp - damage < 0.0f) {
                damage = now_hp - 1.0f;
            }
        }
        if ((hit->status & 0x2000) != 0) {
            damage = now_hp / 2;
            if (damage <= 1.0f) {
                damage = 1.0f;
            }
        }
        if ((int)damage <= 0) {
            damage = 0.0f;
        }
        guarded = guard_flag;
        if (guarded != 0) {
            damage *= 0.01f * hit->param->critical_rate;
        }
        if ((hit->param->hit_flags & 0x8) != 0) {
            guard_flag = 0;
            guarded = 0;
        }
        if (damage >= 0.0f) {
            damage = GetDispVolumeForFloat(damage);
        }
        battle->AddHp_Point(-damage, 0.0f);
        if ((damage_points = (int)damage) > 0) {
            if ((hit->status & 0x4) != 0 && iRand(100) < 30 &&
                (attributes & CHARA_STATUS_POISON) == 0 && CheckAmuletAvoid(0x101) == 0) {
                battle->SetAttr(CHARA_STATUS_POISON, 0);
                sndSePlay(battle_sound, 0x18, 0);
            }
            if ((hit->status & 0x10000) != 0 && battle_area->weather != 2 && iRand(100) < 30 &&
                (attributes & CHARA_STATUS_UNK_2) == 0 && CheckAmuletAvoid(0x100) == 0) {
                battle->SetAttrVol(CHARA_STATUS_UNK_2, 3600);
                sndSePlay(battle_sound, 0x52, 0);
            }
            if ((hit->status & 0x8000) != 0 && iRand(100) < 50 &&
                (attributes & CHARA_STATUS_UNK_20) == 0 && CheckAmuletAvoid(0xFD) == 0) {
                battle->SetAttrVol(CHARA_STATUS_UNK_20, 900);
                immobilized = 1;
                sndSePlay(battle_sound, 0x53, 0);
            }
            if ((hit->status & 0x8) != 0 && iRand(100) < 50 &&
                (attributes & CHARA_STATUS_UNK_8) == 0 && CheckAmuletAvoid(0xFE) == 0) {
                battle->SetAttrVol(CHARA_STATUS_UNK_8, 300);
                immobilized = 1;
                sndSePlay(battle_sound, 0x54, 0);
            }
            if ((hit->status & 0x20000) != 0 && iRand(100) < 50 &&
                (attributes & CHARA_STATUS_UNK_4) == 0 && CheckAmuletAvoid(0xFF) == 0) {
                battle->SetAttr(CHARA_STATUS_UNK_4, 0);
                sndSePlay(battle_sound, 0x55, 0);
            }
            if ((hit->status & 0x100000) != 0 && iRand(100) < 50) {
                battle->SetAttr(CHARA_STATUS_UNK_40, 0);
                sndSePlay(battle_sound, 0x52, 0);
            }
        }
        reaction = 2;
        if ((hit->param->hit_flags & 0x2) != 0) {
            reaction = 4;
        }
        if ((hit->param->hit_flags & 0x4) != 0) {
            reaction = 1;
        }
        if (guarded != 0) {
            reaction = 0;
        }
        if (immobilized != 0) {
            reaction = 3;
        }
        if (battle->GetNowHp_i() <= 0) {
            if (CheckEquipSetItem(0x111) == 0) {
                reaction = 6;
            } else {
                battle->SetHpRate(0.5f);
                pallet[0].SetAnim(96, 180, 255, 1, 45, 0);
                effect_man->CreateEffSpt("\x92\xCA\x8F\xED\x89\xF1\x95\x9C", 0, 0);
                effect_man->SetScriptTargetId(0, -1, -1);
                effect_man->SetValue(0, 0, 0, -1);
                sndSePlay(SystemSND_ID, 0xA, 0);
            }
        }
        sceVu0CopyVector(blow_vec, hit->hit_vec);
        blow_speed = 4.0f;
        blow_rate = 1.0f;
        blow_decel = 0.0f;
        blow_time = 5;
        if (guarded != 0) {
            sndSePlay(battle_sound, 0x21, 0);
            if (immobilized == 0) {
                sndSePlay(chara_sound, 0x1D, 0);
            }
            GuardEffectSet(nowScene__2, hit->hit_pos);
            if (battle->chr_no == USER_CHARA_MONICA) {
                element = -1;
                if (battle->equip->data.weapon.status[1] > 30) {
                    strongest = 0;
                    for (index = 0; index < 4; index++) {
                        if (strongest < hit->param->element[index]) {
                            strongest = hit->param->element[index];
                            element = index;
                        }
                    }
                    if (element >= 0) {
                        battle->SetMagicSwordPow(element, hit->damage);
                    }
                }
            }
            if (damage > 0.0f) {
                HitEffectSet(nowScene__2, hit->hit_pos);
                pallet[0].SetAnim(255, 128, 128, 1, 45, 0);
                shake.time = 6;
                DamageScore2.SetValue(0, damage_points, 0.0f);
                damage_time = hit->param->stun_time * 2;
                GamePad__2.SetVibration(0, 96, 6);
            } else {
                GamePad__2.SetVibration(0, 72, 6);
            }
        } else {
            if (reaction == 4) {
                damage_time = hit->param->stun_time * 7;
                pallet[0].SetAnim(255, 128, 128, 1, 90, 0);
                shake.time = 8;
                GamePad__2.SetVibration(1, 180, 30);
            } else {
                damage_time = hit->param->stun_time * 3;
                pallet[0].SetAnim(255, 128, 128, 1, 30, 0);
                shake.time = 8;
                GamePad__2.SetVibration(1, 128, 20);
            }
            if (immobilized == 0) {
                sndSePlay(chara_sound, 0x24, 0);
            }
            sndSePlay(battle_sound, 0x16, 0);
            HitEffectSet(nowScene__2, hit->hit_pos);
            DamageScore2.SetValue(0, damage_points, body_height);
        }
        switch (reaction) {
        case 0:
        case 1:
        case 5:
            break;
        case 3:
            handled = 1;
            damage_req = ACTION_DAMAGE_REQ_HOLD;
            break;
        case 2:
            stagger += hit->param->stagger;
            stagger_time = 60;
            if (stagger >= 2 || (menu_flag != 0 && stand_flag != 0)) {
                damage_req = ACTION_DAMAGE_REQ_SMALL;
            }
            handled = 1;
            break;
        case 4:
            handled = 1;
            damage_req = ACTION_DAMAGE_REQ_LARGE;
            break;
        case 6:
            handled = 1;
            break;
        }
    }
    if (handled != 0) {
        menu_flag = 0;
    }
    return handled;
}
int CActionChara::LoadActionFile(char *script, int size, mgCMemory *memory) {
    SetActionExtendTable();
    chara_kind = 2;
    script_buf = reinterpret_cast<char *>(memory->stAlloc64(size / 16 + 1));
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
static inline float MoveCheckRadius(float width) {
    return 4.0f + 2.0f * width;
}
void CActionChara::RunScript(CScene *scene, RUN_SCRIPT_ENV *env) {
    int               pallet_u;
    int               history;
    CBattleCharaInfo *battle;
    CSphida          *sphida;
    int               count;
    float             frame;
    int               effect;
    int               pallet_no;
    int               target;
    int               pallet_v;
    int               index;
    int               foot;
    ACTION_DAMAGE    *entry;
    DNG_BATTLE_AREA  *area;
    CColPrim         *reversed;
    CTreasureBoxManager *treasure;
    CMap             *map;
    float             target_distance;

    nowScene__2 = scene;
    area = &scene->battle_area;
    action_info.chara = this;
    action_info.camera = (mgCCameraFollow *)scene->GetCamera(scene->GetCameraID("MainCam"));
    action_info.env = env;
    sceVu0FVECTOR adjusted_velocity = { 0.0f, 0.0f, 0.0f, 0.0f };
    sceVu0FVECTOR old_velocity;
    sceVu0FVECTOR position;
    sceVu0FVECTOR rotation;
    sceVu0FVECTOR new_position;
    CCPoly polys[128];
    mgVu0FBOX box;
    menu_flag = 0;
    dir_gun = 0;
    history = action_info.chara->pad_history;
    history |= PadCtrl.Btn(PAD_BTN_ACTION_CONFIRM);
    action_info.chara->pad_history = history;
    if (PadCtrl.Btn(PAD_BTN_ACTION_HELD) != 0) {
        action_info.chara->acumu_pad++;
    } else {
        action_info.chara->acumu_pad = 0;
    }
    if (melee_hit != 0) {
        prog_no = 700;
        melee_hit = 0;
    }
    if (damage_req == ACTION_DAMAGE_REQ_DEAD) {
        AllDeleteDamage();
        prog_no = ACTION_PROG_DEAD;
        damage_req = ACTION_DAMAGE_REQ_NONE;
        scene->battle_area.script.event_no = 1200;
    }
    if (damage_req == ACTION_DAMAGE_REQ_HOLD) {
        AllDeleteDamage();
        prog_no = ACTION_PROG_HOLD;
        damage_req = ACTION_DAMAGE_REQ_NONE;
    }
    if (damage_req == ACTION_DAMAGE_REQ_SMALL) {
        AllDeleteDamage();
        prog_no = ACTION_PROG_DAMAGE_SMALL;
        damage_req = ACTION_DAMAGE_REQ_NONE;
    }
    if (damage_req == ACTION_DAMAGE_REQ_LARGE) {
        AllDeleteDamage();
        prog_no = ACTION_PROG_DAMAGE_LARGE;
        damage_req = ACTION_DAMAGE_REQ_NONE;
    }
    if (prog_no != ACTION_PROG_RUNNING) {
        if (script.check_program(prog_no) != 0) {
            script.run(prog_no);
            prog_no = ACTION_PROG_RUNNING;
        }
    } else {
        script.resume();
        if (script.end != 0) {
            prog_no = ACTION_PROG_MAIN;
        }
    }
    GetPosition(position);
    GetRotation(rotation);
    sceVu0CopyVector(old_velocity, velocity);
    CollisionCheck(position, old_velocity, adjusted_velocity);
    map = nowScene__2->GetMap(nowScene__2->active_map);
    box.max[0] = 40.0f + position[0];
    box.min[0] = position[0] - 40.0f;
    box.max[1] = 40.0f + position[1];
    box.min[1] = position[1] - 40.0f;
    box.max[2] = 40.0f + position[2];
    box.min[2] = position[2] - 40.0f;
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    count = map->GetColPoly(polys, box, 128);
    treasure = area->treasure_box;
    if (treasure != NULL) {
        count += treasure->PickupCollision(position, &polys[count], box, 128 - count);
    }
    sphida = GetSphidaPtr();
    if (sphida != NULL) {
        count += sphida->PickupCollision(position, &polys[count], box, 128 - count);
    }
    move_check.radius = MoveCheckRadius(body_width);
    MoveCheck(position, adjusted_velocity, new_position, &move_check, polys, count, 1);
    adjusted_velocity[0] = new_position[0] - position[0];
    adjusted_velocity[2] = new_position[2] - position[2];
    battle = GetBattleCharaInfo();
    if (move_check.landed != 0) {
        foot = move_check.ground_poly.foot_sound;
        if (foot == 0 && map != NULL) {
            foot = map->map_info.def_foot;
        }
        sound_info.foot_sound_id = foot;
        adjusted_velocity[1] = 0.0f;
    } else {
        if (battle->chr_no == USER_CHARA_ROBO) {
            adjusted_velocity[1] -= 3.0f;
            if (adjusted_velocity[1] <= -5.0f) {
                adjusted_velocity[1] = -5.0f;
            }
        } else {
            adjusted_velocity[1] -= 0.5f;
            if (adjusted_velocity[1] <= -3.5f) {
                adjusted_velocity[1] = -3.5f;
            }
        }
        sound_info.foot_sound_id = -1;
    }
    if (new_position[1] < -500.0f) {
        new_position[1] = 500.0f;
    }
    SetPosition(new_position);
    sceVu0CopyVector(velocity, adjusted_velocity);
    if (hold_type == ACTION_HOLD_NONE &&
        (battle->chr_no == USER_CHARA_MAX || battle->chr_no == USER_CHARA_MONICA) &&
        move_check.landed != 0 && old_velocity[1] <= -3.5f) {
        SetMotion("\x92\x85\x92\x6E", 6, 1);
        prog_no = ACTION_PROG_LAND;
    }
    if (move_check.landed == 0) {
        menu_flag = 0;
    }
    for (index = 0; index < 11; index++) {
        entry = &damage[index];
        if (entry->use != 0) {
            frame = GetNowFrame(entry->chara);
            if (entry->prim == NULL) {
                if (frame >= entry->start_frame && frame < entry->end_frame) {
                    entry->prim = ColPrimMan.GetPrim();
                    if (entry->prim != NULL) {
                        entry->prim->SetDamage(entry->damage, 0);
                        entry->prim->SetCoord(entry->frame0, entry->frame1, entry->radius);
                        SetDamageParam(entry->prim, 0);
                        entry->prim->damage = (int)(entry->prim->damage * entry->power_rate);
                    }
                }
            } else if (frame < entry->start_frame || frame > entry->end_frame) {
                entry->prim->Delete(-1);
                entry->prim = NULL;
            } else {
                reversed = ColPrimMan.IsReversVec(entry->prim);
                if (reversed != NULL) {
                    reversed->reversed = 1;
                    reversed->GetReversVec(reversed->revers_vec);
                }
            }
        }
    }
    pallet_no = battle->GetPalletNo(0);
    if (pallet_no >= 0) {
        pallet_u = pallet_no % 2;
        pallet_v = pallet_no / 2;
        for (effect = 0; effect < 3; effect++) {
            if (sword_effect[effect] != NULL) {
                sword_effect[effect]->SetTexture(pallet_u * 64, pallet_v * 32, 64, 32);
            }
        }
    }
    if (area->lock_on_mode == 2) {
        target_no = RockOn_TargetSel(scene, target_no);
    }
    if (area->lock_on_mode == 0) {
        if (lock_on == 0) {
            target_no = DistCheck_Action2(scene, 0.5f, 400.0f, &target_distance, 0, NULL);
        } else {
            lock_on = Check_LockOn(scene, 300.0f, target_no);
            if (lock_on == 0) {
                target = DistCheck_Action2(scene, 0.5f, 400.0f, &target_distance, 0, NULL);
                if (target != -1) {
                    target_no = target;
                    lock_on = 1;
                } else {
                    target_no = target;
                }
            }
        }
    }
}
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
    float         move_copy[4];
    float         self_rot[4];
    float         target_rot[4];
    CActionChara *target;
    int           i;

    sceVu0CopyVector(move_copy, velocity);
    move_copy[0] = 0.0f;
    move_copy[2] = 0.0f;
    sceVu0CopyVector(velocity, move_copy);

    if (chara_type == 2) {
        target = SearchChara("arm");

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

            ActionVector forward = {{0.0f, 0.0f, 1.0f, 1.0f}};
            float matrix[4][4];
            sceVu0UnitMatrix(matrix);
            sceVu0RotMatrixY(matrix, matrix, self_rot[1]);
            sceVu0ApplyMatrix(front_vec, matrix, forward.f);
        }
    } else {
        float self_rot2[4];
        GetRotation(self_rot2);
        ActionVector forward2 = {{0.0f, 0.0f, 1.0f, 1.0f}};
        float matrix2[4][4];
        sceVu0UnitMatrix(matrix2);
        sceVu0RotMatrixY(matrix2, matrix2, self_rot2[1]);
        sceVu0ApplyMatrix(front_vec, matrix2, forward2.f);
    }

    add_vec[1] = 0.0f;

    if (!(add_speed <= 0.0f) && add_time != 0) {
        float knock[4];
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
        float push[4];
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

    if (battle_stance != 0) {
        battle_stance_rate += 0.016666668f;

        if (!(battle_stance_rate < 1.0f)) {
            battle_stance_rate = 1.0f;
        }
    } else {
        battle_stance_rate = battle_stance_rate - 0.016666668f;

        if (battle_stance_rate <= 0.0f) {
            battle_stance_rate = 0.0f;
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
    float         held_pos[4];
    float         rotation[4];
    float         gun_pos[4];
    float         target_pos[4];
    float         matrix[4][4];
    float         pitch_matrix[4][4];
    CActionChara *link;
    CCharacter2  *chained;
    CCharacter2  *self = this;
    mgCFrame     *gun;
    int           monster_index;

    StepParam();

    if (self->sound_info.se_positional != 2) {
        self->sound_info.se_positional = 1;
    }

    self->CCharacter2::Step();
    link = next;

    if (link != NULL) {
        do {
            chained = link;

            if (chained->sound_info.se_positional != 2) {
                chained->sound_info.se_positional = 0;
            }

            chained->CCharacter2::Step();
            link = link->next;
        } while (link != NULL);
    }

    if (hold_type == 4 && hold_parts != 0 && hold_frame != 0) {
        GetRotation(rotation);
        hold_frame->GetWorldPosition0(held_pos);
        held_pos[3] = 1.0f;
        held_pos[1] -= 1.0f;
        hold_parts->SetPosition(held_pos);
        hold_parts->SetRotation(rotation);
    }

    gun = SearchObject("L_arm");

    if (gun != NULL) {
        static float ang = 0.0f;

        gun->GetWorldPosition0(gun_pos);

        if (lock_on != 0 && dir_gun != 0) {
            monster_index = target_no - 24;
            ActiveMonster->active[monster_index]->GetEntryObjectPos(0, target_pos);
            sceVu0SubVector(gun_pos, target_pos, gun_pos);
            sceVu0CopyVector(target_pos, gun_pos);
            target_pos[3] = 1.0f;
            target_pos[1] = 0.0f;
            ang = -atan2f(gun_pos[1], mgDistVector(target_pos));
        } else {
            ang = 0.0f;
        }

        sceVu0CopyMatrix(matrix, gun->trans_matrix);
        sceVu0UnitMatrix(pitch_matrix);
        sceVu0RotMatrixZ(pitch_matrix, pitch_matrix, ang);
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
    accele.accele[0] = 0.0f;
    accele.accele[1] = 0.0f;
    accele.accele[2] = 0.0f;
    accele.accele[3] = 0.0f;
    acumu_pad = 0;
    now_status = 0;
    melee_hit = 0;
    battle_stance = 0;
    battle_stance_rate = 0.0f;
    muteki_time = 0;
    guard_flag = 0;
    menu_flag = 0;
    add_speed = 0.0f;
    add_time = 0;
    blow_vec[2] = 0.0f;
    blow_vec[1] = 0.0f;
    blow_vec[0] = 0.0f;
    blow_vec[3] = 1.0f;
    blow_speed = 0.0f;
    blow_time = 0;
    unk_be4 = 0;
    damage_time = 0;
    stagger = 0;
    stagger_time = 0;
    mask_flag = 0;
    dir_gun = 0;
    default_motion = "\x97\xA7\x82\xBF";
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

void CActionChara::Copy(CActionChara &dest, mgCMemory *memory) {
    dest = *this;

    if (memory != NULL) {
        CCharacter2::Copy(dest, memory);
    }
}

/**
 *
 * Creates guard effects at the impact point facing the active camera.
 *
 */
void GuardEffectSet(CScene *scene, float *point) {
    float            to_camera[4];
    float            position[4];
    CCameraControl  *camera;
    CHitEffectImage *hit;
    CFlushEffect    *flush;
    float            spread = 50.0f;

    camera = (CCameraControl *) scene->GetCamera(scene->active_camera);

    if (camera == NULL) {
        return;
    }

    sceVu0CopyVector(position, point);
    camera->GetPos(to_camera);
    sceVu0SubVector(to_camera, to_camera, position);
    sceVu0Normalize(to_camera, to_camera);
    sceVu0ScaleVector(to_camera, to_camera, 20.0f);
    sceVu0AddVector(position, position, to_camera);
    ActionVector direction = {{0.0f, 1.0f, 0.0f, 1.0f}};

    if (BattleFX.hit == NULL) {
        hit = NULL;
    } else {
        hit = &BattleFX.hit[BattleFX.hit_next];
        ++BattleFX.hit_next;

        if (BattleFX.hit_next >= BattleFX.hit_num) {
            BattleFX.hit_next = 0;
        }
    }

    hit->SethitEffect(position, direction.f, spread, 30.0f, 0.0f, 0.1f, 30, 32);
    hit->kind = 1;

    if (BattleFX.flush == NULL) {
        flush = NULL;
    } else {
        flush = &BattleFX.flush[BattleFX.flush_next];
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
        FxScriptMan->CreateEffSpt("\x83K\x81[\x83h\x83G\x83t\x83" "F\x83N\x83g\x82`", 0, 0);
        FxScriptMan->SetScriptVect1(position, 0, -1);
    }
}
