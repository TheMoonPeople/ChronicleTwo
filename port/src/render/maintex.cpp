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

void MainTextureInterface(mgCMemory *stack, CScene *scene);

void calcWeaponParamWhp(CActiveMonster *monster, CColPrim *col_prim) {
    CBattleCharaInfo    *battle = {};
    BATTLE_WEAPON_PARAM *weapon_param = {};
    int                  kind = {};
    float                old_whp = {};
    float                wear = {};
    u32                  status = {};

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
            battle->AddAbsRate(0, -0.1f, nullptr);
        }
    }
}

void calcWeaponParam2(int type, int divisor) {
    CBattleCharaInfo    *battle = {};
    BATTLE_WEAPON_PARAM *weapon_param = {};
    u32                  status = {};
    float                old_whp = {};
    float                wear = {};

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
            battle->AddAbsRate(1, -0.1f, nullptr);
        }
    }
}

void SetDamageParam(CColPrim *prim, int slot_no) {
    CBattleCharaInfo    *info = GetBattleCharaInfo();
    int                  damage = {};
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
    int               slot{};
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
                info->AddAbs(0, amount, nullptr);
                break;
            case 3:
                info->AddAbs(0, amount, &leveled_up);
                slot = 0;
                break;
        }
    } else {
        switch (kind) {
            case DAMAGE_SOURCE_MAIN_WEAPON:
                info->AddAbs(0, amount, &leveled_up);
                slot = 0;
                break;
            case DAMAGE_SOURCE_SUB_WEAPON:
                info->AddAbs(1, amount, &leveled_up);
                slot = 1;
                break;
            case DAMAGE_SOURCE_ITEM: {
                float half = amount / 2.0f;

                if (!(info->AddAbs(0, half, &leveled_up) < 1.0f)) {
                    slot = 0;
                }

                if (!(info->AddAbs(1, half, &leveled_up) < 1.0f)) {
                    slot = 1;
                }

                break;
            }
            case DAMAGE_SOURCE_RIDEPOD:
                info->AddAbs(0, amount, nullptr);
                break;
            case 5:
            case 6:
            case 7:
                break;
            case DAMAGE_SOURCE_GENERIC:
                info->AddAbs(0, amount, &leveled_up);
                slot = 0;
                break;
        }
    }

    if (leveled_up != 0) {
        LevelupInfo.SetLevelUpInfo(0x100, mgScreenHeight / 2, slot, 0);
        sndSePlay(SystemSND_ID, SYSTEM_SE_PARAM_UP, 0);
    }
}

void SetSwordBlurEffect(CCharacter2 *chara, mgCMemory *stack, int blur_type) {
    if (chara == nullptr || stack == nullptr) {
        return;
    }
    int u = {};
    int v = {};

    auto *effect = dc2::memory::NewObject<CSWordAfterEffect>(*stack);
    if (effect == nullptr) {
        return;
    }
    effect->Initialize(stack, 12, 8);
    if (!dc2::character::RetainResource(*chara, dc2::character::ResourceChannel::Sword, 0, *stack)) {
        return;
    }
    chara->sword_effect[0] = effect;
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

#include "common.h"

#include <cstdio>
#include <stdexcept>
#include <string>

#include "dataread.hpp"
#include "dng_main.hpp"
#include "gaiji.hpp"
#include "maintex.hpp"
#include "mglib.hpp"
#include "photo.hpp"
#include "platform/texture_bundle.hpp"
#include "userdata.hpp"

namespace {
/** Names of the dungeon's mutable render-target textures. */
char work_name[] = "work";
char work2_name[] = "work2";
char fire_work_name[] = "fire_work";
char capture_name[] = "capture";
char water_work_name[] = "water_work";
} // namespace

void MainTextureInterface(mgCMemory *stack, CScene *scene) {
    mgTexManager.EnterIMGFile(GetGaijiImgPtr(), 0x58, nullptr, nullptr);
    ReLoadFontTexture(0x58);
    stack->Align64();
    auto *buffer = stack->stAllocTest(1);
    char  path[64];
    int   file_size = 0;
    std::snprintf(path, sizeof(path), "textures/img/esystem%d.json", LanguageCode);
    if (buffer == nullptr) {
        throw std::length_error("texture arena has no space for the system image");
    }
    LoadFile(path, dc2::memory::RemainingBytes(*stack), &file_size);
    if (file_size <= 0 || dc2::memory::NewArray<u_long128>(*stack, static_cast<std::size_t>(file_size) / 16 + 1) == nullptr) {
        throw std::length_error("texture arena cannot reserve the system image");
    }
    mgTexManager.EnterIMGFile(reinterpret_cast<u_char *>(buffer), 0x67, stack, nullptr);
    LoadTakePhoto(0x67, stack, buffer);
    stack->Align64();

    std::snprintf(path, sizeof(path), "dungeon/articles/tex01_%d.gltf", LanguageCode);
    std::string error;
    const auto  enter = [&](const char *entry, int block, mgCMemory *memory, bool optional = false) {
        if (!texture_bundle::Enter(path, entry, mgTexManager, block, memory, error, optional)) {
            throw std::runtime_error(error);
        }
    };
    enter("frame", 0x48, stack);
    enter("effect00", 0x49, stack);
    enter("sweff", 0x4A, stack);
    enter("potbeam", 0x4A, stack);
    enter("ref", 0x59, nullptr);
    enter("fire_wrk", 0x4B, stack);
    enter("bteffe_chi", 0x6B, stack, LanguageCode == 0);

    mgTexManager.EnterTexture(0x64, work_name, nullptr, mgScreenWidth, mgScreenHeight, 32, nullptr, 0, 0);
    mgTexManager.EnterTexture(0x64, work2_name, nullptr, mgScreenWidth / 3, mgScreenHeight / 3, 32, nullptr, 0, 0);
    mgTexManager.EnterTexture(0x4B, fire_work_name, nullptr, mgScreenWidth, mgScreenHeight, 32, nullptr, 0, 0);
    mgTexManager.EnterTexture(0x65, capture_name, nullptr, mgScreenWidth, mgScreenHeight, mgScreenDepth, nullptr, 0, 0);
    mgTexManager.EnterTexture(0x59, water_work_name, nullptr, mgScreenWidth, mgScreenHeight, mgScreenDepth, nullptr, 0, 0);
    scene->fade.SetCrossTexture(mgTexManager.GetTexture(capture_name, -1), BuffReadData + 0x20000);
    GetTextureInfo(scene);
}
