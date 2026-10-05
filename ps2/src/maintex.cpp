#include "common.h"
#include "maintex.hpp"
#include "mglib.hpp"
#include "snd_mngr.hpp"
#include "mg_texture.hpp"
#include "mg_memory.hpp"
#include "gaiji.hpp"
#include "photo.hpp"
#include "dataread.hpp"
#include "mainloop.hpp"
#include "scenesnd.hpp"
#include "monster.hpp"
#include "colprim.hpp"
#include "userdata.hpp"
#include "character.hpp"
#include "swordeffect.hpp"
#include "dng_hud.hpp"
#include "sound.hpp"
#include <cstdio>

extern char at_792__2[];
extern char at_793__2[];
extern char at_794__2[];
extern char at_795__2[];
extern char at_796__2[];
extern char at_797__2[];
extern char at_798__2[];
extern char at_799__2[];
extern char at_800__2[];
extern char at_801__2[];
extern char at_802__2[];
extern char at_803__2[];
extern char at_804__2[];
extern char at_819__3[];
extern char at_820__3[];
extern char at_821__3[];
extern char at_822__3[];
extern char at_823__3[];
extern char at_824__3[];
extern char at_825__3[];
extern char at_826__3[];
extern char at_827__3[];
extern char at_828__4[];
extern char at_829__4[];
extern char at_830__5[];
extern char at_831__4[];
extern char at_832__4[];

// Code (.text)
void GetTextureInfo(CScene *scene) {
    TEX_ShadowTexture = mgTexManager.GetTexture(at_792__2, -1);
    TEX_SystenFrame = mgTexManager.GetTexture(at_793__2, -1);
    TEX_SystenFrame2 = mgTexManager.GetTexture(at_794__2, -1);
    TEX_StatusIcon = mgTexManager.GetTexture(at_795__2, -1);
    TEX_DummyIcon1 = mgTexManager.GetTexture(at_796__2, -1);
    TEX_DummyIcon2 = mgTexManager.GetTexture(at_797__2, -1);
    TEX_SystemEffect1 = mgTexManager.GetTexture(at_798__2, -1);
    TEX_SystemEffect2 = mgTexManager.GetTexture(at_799__2, -1);
    TEX_SystemEffect3 = mgTexManager.GetTexture(at_800__2, -1);
    TEX_SystemEffectSw = mgTexManager.GetTexture(at_801__2, -1);
    TEX_ExFx_FIRE = mgTexManager.GetTexture(at_802__2, -1);
    TEX_ExFx_ICE = mgTexManager.GetTexture(at_803__2, -1);
    TEX_ExFx_THUN = mgTexManager.GetTexture(at_804__2, -1);
}
void MainTextureInterface(mgCMemory *memory, CScene *scene) {
    char path[0x48];
    int size;
    int pack_size;

    mgTexManager.EnterIMGFile((u8 *)GetGaijiImgPtr(), 0x58, NULL, NULL);
    ReLoadFontTexture(0x58);
    mgTexManager.EnterIMGFile((u8 *)GetFontTex2ImgPtr(), 0x58, NULL, NULL);

    memory->Align64();
    u8 *buffer = (u8 *)memory->stAllocTest(1);
    sprintf(path, at_819__3, LanguageCode);
    LoadFile(path, buffer, &size);
    mgTexManager.EnterIMGFile(buffer, 0x67, memory, NULL);
    memory->Alloc(size / 16 + 1);
    LoadTakePhoto(0x67, memory, (u_long128 *)buffer);

    memory->Align64();
    buffer = (u8 *)memory->stAllocTest(1);
    sprintf(path, at_820__3, LanguageCode);
    LoadFile(path, buffer, &size);
    memory->Alloc(size / 16 + 1);

    mgTexManager.EnterIMGFile((u8 *)GetPackFile((u32 *)buffer, at_821__3, &pack_size), 0x48, memory, NULL);
    mgTexManager.EnterIMGFile((u8 *)GetPackFile((u32 *)buffer, at_822__3, &pack_size), 0x49, memory, NULL);
    mgTexManager.EnterIMGFile((u8 *)GetPackFile((u32 *)buffer, at_823__3, &pack_size), 0x4A, memory, NULL);
    mgTexManager.EnterIMGFile((u8 *)GetPackFile((u32 *)buffer, at_824__3, &pack_size), 0x4A, memory, NULL);
    mgTexManager.EnterIMGFile((u8 *)GetPackFile((u32 *)buffer, at_825__3, &pack_size), 0x59, NULL, NULL);
    mgTexManager.EnterIMGFile((u8 *)GetPackFile((u32 *)buffer, at_826__3, &pack_size), 0x4B, memory, NULL);
    mgTexManager.EnterIMGFile((u8 *)GetPackFile((u32 *)buffer, at_827__3, &pack_size), 0x6B, memory, NULL);

    printf(at_828__4, 0xAE);
    mgTexManager.EnterTexture(0x64, at_792__2, NULL, mgScreenWidth, mgScreenHeight, 0x20, 0, 0, 0);
    mgTexManager.EnterTexture(0x64, at_829__4, NULL, mgScreenWidth / 3, mgScreenHeight / 3, 0x20, 0, 0, 0);
    mgTexManager.EnterTexture(0x4B, at_830__5, NULL, mgScreenWidth, mgScreenHeight, 0x20, 0, 0, 0);
    mgTexManager.EnterTexture(0x65, at_831__4, NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth, 0, 0, 0);
    mgTexManager.EnterTexture(0x59, at_832__4, NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth, 0, 0, 0);
    scene->fade.SetCrossTexture(mgTexManager.GetTexture(at_831__4, -1),
                                 (u_long128 *)((u8 *)BuffReadData + 0x200000));
    GetTextureInfo(scene);
}
void calcWeaponParamWhp(CActiveMonster *monster, CColPrim *prim) {
    CBattleCharaInfo *info = GetBattleCharaInfo();
    int attack_kind = ((DAMAGE_PARAM *)prim->param)->kind;

    s16 *slot_words = (s16 *)info->weapon_param;
    if (attack_kind == 4 || attack_kind == 0 || attack_kind == 11 || attack_kind == 12) {
        float attack = (float)info->GetWhpNowVol(0);
        float power = (float)monster->whp;
        power *= 0.5f;
        float wear = power;
        wear -= (float)(power * (0.005 * slot_words[1]));
        int status = prim->status;
        if (status & 0x20)
            wear *= 1.3f;
        if (status & 0x40)
            wear *= 0.8f;
        if (info->AddWhp(0, -wear) <= 0.0f && !(attack <= 0.0f))
            info->AddAbsRate(0, -0.1f, NULL);
    }
}
void calcWeaponParam2(int hit_type, int divisor) {
    CBattleCharaInfo *info = GetBattleCharaInfo();

    s16 *slot_words = (s16 *)info->weapon_param;
    int status = info->GetSpecialStatus(1);
    if (hit_type == 1 || hit_type == 5) {
        float attack = (float)info->GetWhpNowVol(1);
        float wear = 1.0f;
        float scale = 1.0f;
        wear -= scale * (0.002 * slot_words[15]);
        if (status & 0x20)
            wear *= 1.3f;
        if (status & 0x40)
            wear *= 0.8f;
        wear /= (float)divisor;
        if (info->AddWhp(1, -wear) <= 0.0f && !(attack <= 0.0f))
            info->AddAbsRate(1, -0.1f, NULL);
    }
}
void SetDamageParam(CColPrim *prim, int slot_no) {
    CBattleCharaInfo *info = GetBattleCharaInfo();
    int damage;
    int mode = info->chr_no;
    BATTLE_WEAPON_PARAM *weapon_param = info->weapon_param;
    if (mode == 3) {
        prim->damage = weapon_param[slot_no].status[0];
    } else {
        damage = weapon_param[slot_no].status[0];
        int attack[2];
        info->GetNowWhp(slot_no, attack);
        if (attack[0] <= 0)
            damage = 0;
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
        if (status & 4) {
            if (iRand(10) != 1)
                status &= ~4;
        }
        if (status & 8) {
            if (iRand(20) != 1)
                status &= ~8;
        }
        prim->status = status;
    }
    prim->attacker = mode;
}
void AddExpWeaponParam(float amount, int weapon_owner, int kind) {
    CBattleCharaInfo *info = GetBattleCharaInfo();
    int slot;
    int chr_no = info->chr_no;
    int leveled_up = 0;
    if (chr_no != weapon_owner) {
        switch (chr_no) {
            case 0:
            case 1: {
                float half = amount / 2.0f;
                if (!(info->AddAbs(0, half, &leveled_up) < 1.0f))
                    slot = 0;
                if (!(info->AddAbs(1, half, &leveled_up) < 1.0f))
                    slot = 1;
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
                if (!(info->AddAbs(0, half, &leveled_up) < 1.0f))
                    slot = 0;
                if (!(info->AddAbs(1, half, &leveled_up) < 1.0f))
                    slot = 1;
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
void SetSwordBlurEffect(CCharacter2 *chara, mgCMemory *memory, int sword) {
    CSWordAfterEffect *effect =
        (CSWordAfterEffect *)operator new(sizeof(CSWordAfterEffect), memory->Alloc(12));
    if (effect != NULL) {
        effect->color0[0] = 0x80;
        effect->color0[1] = 0x80;
        effect->color0[2] = 0x80;
        effect->color0[3] = 0x80;
        effect->color1[0] = 0x80;
        effect->color1[1] = 0x80;
        effect->color1[2] = 0x80;
        effect->color1[3] = 0x80;
    }
    chara->sword_effect[0] = effect;
    chara->sword_effect[0]->Initialize(memory, 12, 8);
    int u = 0;
    int v = 32;
    if (sword == 0) {
        u = 64;
        v = 0;
    }
    if (sword == 1) {
        u = 0;
        v = 0;
    }
    chara->sword_effect[0]->SetTexture(74, TEX_SystemEffectSw, u, v, 64, 32);
}

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_792__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_793__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_794__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_795__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_796__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_797__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_798__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_799__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_800__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_801__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_802__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_803__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_804__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_819__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_820__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_821__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_822__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_823__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_824__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_825__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_826__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_827__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_828__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_829__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_830__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_831__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_832__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/maintex", at_936__3__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(TEX_ShadowTexture, 0x4);
INCLUDE_BSS(TEX_SystenFrame, 0x4);
INCLUDE_BSS(TEX_SystenFrame2, 0x4);
INCLUDE_BSS(TEX_StatusIcon, 0x4);
INCLUDE_BSS(TEX_DummyIcon1, 0x4);
INCLUDE_BSS(TEX_DummyIcon2, 0x4);
INCLUDE_BSS(TEX_SystemEffect1, 0x4);
INCLUDE_BSS(TEX_SystemEffect2, 0x4);
INCLUDE_BSS(TEX_SystemEffect3, 0x4);
INCLUDE_BSS(TEX_SystemEffectSw, 0x4);
INCLUDE_BSS(TEX_ExFx_FIRE, 0x4);
INCLUDE_BSS(TEX_ExFx_ICE, 0x4);
INCLUDE_BSS(TEX_ExFx_THUN, 0x4);
