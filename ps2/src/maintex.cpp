#include "common.h"

#include <cstdio>

#include "character.hpp"
#include "colprim.hpp"
#include "dataread.hpp"
#include "dng_effect.hpp"
#include "dng_hud.hpp"
#include "dng_main.hpp"
#include "effectlist.hpp"
#include "gaiji.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "photo.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "swordeffect.hpp"
#include "userdata.hpp"

mgCTexture *TEX_ShadowTexture;
mgCTexture *TEX_SystenFrame;
mgCTexture *TEX_SystenFrame2;
mgCTexture *TEX_StatusIcon;
mgCTexture *TEX_DummyIcon1;
mgCTexture *TEX_DummyIcon2;
mgCTexture *TEX_SystemEffect1;
mgCTexture *TEX_SystemEffect2;
mgCTexture *TEX_SystemEffect3;
mgCTexture *TEX_SystemEffectSw;
mgCTexture *TEX_ExFx_FIRE;
mgCTexture *TEX_ExFx_ICE;
mgCTexture *TEX_ExFx_THUN;

// Code (.text)
void GetTextureInfo(CScene *scene) {
    TEX_ShadowTexture = mgTexManager.GetTexture("work", -1);
    TEX_SystenFrame = mgTexManager.GetTexture("frame", -1);
    TEX_SystenFrame2 = mgTexManager.GetTexture("frame2", -1);
    TEX_StatusIcon = mgTexManager.GetTexture("status_icon", -1);
    TEX_DummyIcon1 = mgTexManager.GetTexture("icon_dmy1", -1);
    TEX_DummyIcon2 = mgTexManager.GetTexture("icon_dmy2", -1);
    TEX_SystemEffect1 = mgTexManager.GetTexture("effect00", -1);
    TEX_SystemEffect2 = mgTexManager.GetTexture("effect01", -1);
    TEX_SystemEffect3 = mgTexManager.GetTexture("effect02", -1);
    TEX_SystemEffectSw = mgTexManager.GetTexture("sweff", -1);
    TEX_ExFx_FIRE = mgTexManager.GetTexture("bteffe_fla", -1);
    TEX_ExFx_ICE = mgTexManager.GetTexture("bteffe_chi", -1);
    TEX_ExFx_THUN = mgTexManager.GetTexture("bteffe_lig", -1);
}

void MainTextureInterface(mgCMemory *stack, CScene *scene) {
    char       path[64];
    int        file_size;
    int        member_size;
    u_long128 *buffer;

    mgTexManager.EnterIMGFile(GetGaijiImgPtr(), 0x58, NULL, NULL);
    ReLoadFontTexture(0x58);
    mgTexManager.EnterIMGFile(GetFontTex2ImgPtr(), 0x58, NULL, NULL);
    stack->Align64();
    buffer = stack->stAllocTest(1);
    sprintf(path, "img/esystem%d.img", LanguageCode);
    LoadFile(path, buffer, &file_size);
    mgTexManager.EnterIMGFile((u_char *) buffer, 0x67, stack, NULL);
    stack->Alloc(file_size / 16 + 1);
    LoadTakePhoto(0x67, stack, buffer);
    stack->Align64();
    buffer = stack->stAllocTest(1);
    sprintf(path, "dungeon/articles/tex01_%d.chr", LanguageCode);
    LoadFile(path, buffer, &file_size);
    stack->Alloc(file_size / 16 + 1);
    mgTexManager.EnterIMGFile((u_char *) GetPackFile((u_int *) buffer, "frame_basic.img", &member_size), 0x48, stack, NULL);
    mgTexManager.EnterIMGFile((u_char *) GetPackFile((u_int *) buffer, "effect00.img", &member_size), 0x49, stack, NULL);
    mgTexManager.EnterIMGFile((u_char *) GetPackFile((u_int *) buffer, "beffect_00.img", &member_size), 0x4A, stack, NULL);
    mgTexManager.EnterIMGFile((u_char *) GetPackFile((u_int *) buffer, "potbeam.img", &member_size), 0x4A, stack, NULL);
    mgTexManager.EnterIMGFile((u_char *) GetPackFile((u_int *) buffer, "water_ref.img", &member_size), 0x59, NULL, NULL);
    mgTexManager.EnterIMGFile((u_char *) GetPackFile((u_int *) buffer, "fire.img", &member_size), 0x4B, stack, NULL);
    mgTexManager.EnterIMGFile((u_char *) GetPackFile((u_int *) buffer, "bteffe_4ex.img", &member_size), 0x6B, stack, NULL);
    printf("TEXBLK_LAST = %d\n", 0xAE);
    mgTexManager.EnterTexture(0x64, "work", NULL, mgScreenWidth, mgScreenHeight, 32, NULL, 0, 0);
    mgTexManager.EnterTexture(0x64, "work2", NULL, mgScreenWidth / 3, mgScreenHeight / 3, 32, NULL, 0, 0);
    mgTexManager.EnterTexture(0x4B, "fire_work", NULL, mgScreenWidth, mgScreenHeight, 32, NULL, 0, 0);
    mgTexManager.EnterTexture(0x65, "capture", NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth, NULL, 0, 0);
    mgTexManager.EnterTexture(0x59, "water_work", NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth, NULL, 0, 0);
    scene->fade.SetCrossTexture(mgTexManager.GetTexture("capture", -1), BuffReadData + 0x20000);
    GetTextureInfo(scene);
}

void calcWeaponParamWhp(CActiveMonster *monster, CColPrim *col_prim) {
    CBattleCharaInfo    *battle;
    BATTLE_WEAPON_PARAM *weapon_param;
    int                  kind;
    float                old_whp;
    float                wear;
    u32                  status;

    battle = GetBattleCharaInfo();
    weapon_param = battle->weapon_param;
    kind = col_prim->param->kind;

    if (kind == DAMAGE_KIND_MONICA_MELEE || kind == DAMAGE_KIND_MAX_MELEE ||
        kind == DAMAGE_KIND_RIDEPOD_PUNCH || kind == DAMAGE_KIND_RIDEPOD_SWORD) {
        old_whp = (float) battle->GetWhpNowVol(0);
        wear = (float) (u_int) monster->whp;
        wear *= 0.5f;
        wear -= (float) (wear * (0.005 * weapon_param[0].status[WEAPON_STAT_DURABILITY]));
        status = col_prim->status;

        if (status & WEAPON_SPECIAL_INCREASE_WEAR) {
            wear *= 1.3f;
        }

        if (status & WEAPON_SPECIAL_REDUCE_WEAR) {
            wear *= 0.8f;
        }

        if (battle->AddWhp(0, -wear) <= 0.0f && old_whp > 0.0f) {
            battle->AddAbsRate(0, -0.1f, NULL);
        }
    }
}

void calcWeaponParam2(int type, int divisor) {
    CBattleCharaInfo    *battle;
    BATTLE_WEAPON_PARAM *weapon_param;
    u32                  status;
    float                old_whp;
    float                wear;

    battle = GetBattleCharaInfo();
    weapon_param = battle->weapon_param;
    status = battle->GetSpecialStatus(1);

    if (type == DAMAGE_KIND_MAX_GUN || type == DAMAGE_KIND_MONICA_MAGIC) {
        old_whp = (float) battle->GetWhpNowVol(1);
        wear = 1.0f;
        wear -= (float) (wear * (0.002 * weapon_param[1].status[WEAPON_STAT_DURABILITY]));

        if (status & WEAPON_SPECIAL_INCREASE_WEAR) {
            wear *= 1.3f;
        }

        if (status & WEAPON_SPECIAL_REDUCE_WEAR) {
            wear *= 0.8f;
        }

        wear /= (float) divisor;

        if (battle->AddWhp(1, -wear) <= 0.0f && old_whp > 0.0f) {
            battle->AddAbsRate(1, -0.1f, NULL);
        }
    }
}

void SetDamageParam(CColPrim *prim, int slot_no) {
    CBattleCharaInfo    *info = GetBattleCharaInfo();
    int                  damage;
    int                  mode = info->chr_no;
    BATTLE_WEAPON_PARAM *weapon_param = info->weapon_param;

    if (mode == 3) {
        prim->damage = weapon_param[slot_no].status[WEAPON_STAT_ATTACK];
    } else {
        damage = weapon_param[slot_no].status[WEAPON_STAT_ATTACK];
        int attack[2];
        info->GetNowWhp(slot_no, attack);

        if (attack[0] <= 0) {
            damage = 0;
        }

        prim->damage = damage;
        prim->element[0] = info->weapon_param[slot_no].status[2];
        prim->element[1] = info->weapon_param[slot_no].status[3];
        prim->element[2] = info->weapon_param[slot_no].status[4];
        prim->element[3] = info->weapon_param[slot_no].status[5];
        prim->element[4] = info->weapon_param[slot_no].status[6];
        prim->element[5] = info->weapon_param[slot_no].status[7];
        prim->element[6] = info->weapon_param[slot_no].status[8];
        prim->element[7] = info->weapon_param[slot_no].status[9];
        int status = info->GetSpecialStatus(slot_no);

        if (status & WEAPON_SPECIAL_POISON) {
            if (iRand(10) != 1) {
                status &= ~WEAPON_SPECIAL_POISON;
            }
        }

        if (status & 8) {
            if (iRand(20) != 1) {
                status &= ~8;
            }
        }

        prim->status = status;
    }

    prim->attacker = mode;
}

void AddExpWeaponParam(float amount, int weapon_owner, int kind) {
    CBattleCharaInfo *info = GetBattleCharaInfo();
    int               slot;
    int               chr_no = info->chr_no;
    int               leveled_up = 0;

    if (chr_no != weapon_owner) {
        switch (chr_no) {
            case 0:
            case 1: {
                float half = amount / 2.0f;

                if (!(info->AddAbs(0, half, &leveled_up) < 1.0f)) {
                    slot = 0;
                }

                if (!(info->AddAbs(1, half, &leveled_up) < 1.0f)) {
                    slot = 1;
                }

                break;
            }
            case 2:
                info->AddAbs(0, amount, NULL);
                break;
            case 3:
                info->AddAbs(0, amount, &leveled_up);
                slot = 0;
                break;
        }
    } else {
        switch (kind) {
            case 1:
                info->AddAbs(0, amount, &leveled_up);
                slot = 0;
                break;
            case 2:
                info->AddAbs(1, amount, &leveled_up);
                slot = 1;
                break;
            case 3: {
                float half = amount / 2.0f;

                if (!(info->AddAbs(0, half, &leveled_up) < 1.0f)) {
                    slot = 0;
                }

                if (!(info->AddAbs(1, half, &leveled_up) < 1.0f)) {
                    slot = 1;
                }

                break;
            }
            case 4:
                info->AddAbs(0, amount, NULL);
                break;
            case 5:
            case 6:
            case 7:
                break;
            case 8:
                info->AddAbs(0, amount, &leveled_up);
                slot = 0;
                break;
        }
    }

    if (leveled_up != 0) {
        LevelupInfo.SetLevelUpInfo(0x100, mgScreenHeight / 2, slot, 0);
        sndSePlay(SystemSND_ID, 30, 0);
    }
}

void SetSwordBlurEffect(CCharacter2 *chara, mgCMemory *stack, int blur_type) {
    int u;
    int v;

    chara->sword_effect[0] = new (stack->Alloc(12)) CSWordAfterEffect;
    chara->sword_effect[0]->Initialize(stack, 12, 8);
    u = 0;
    v = 32;

    if (blur_type == 0) {
        u = 64;
        v = 0;
    }

    if (blur_type == 1) {
        u = 0;
        v = 0;
    }

    chara->sword_effect[0]->SetTexture(0x4A, TEX_SystemEffectSw, u, v, 64, 32);
}
