#pragma once

#include "common.h"

#include "character.hpp"
#include "colprim.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "monster.hpp"
#include "scenesnd.hpp"

/**
 * @file
 * Declares the dungeon's shared system textures, which are registered and
 * looked up when a dungeon starts, together with the helpers that wear down,
 * level up and apply the stats of the party's weapons and that attach the
 * sword trail effect to a character.
 */

/**
 *
 * Off-screen work texture ("work") the dungeon renders shadows and depth of field into.
 *
 */
extern mgCTexture *TEX_ShadowTexture;

/**
 *
 * Status board frame texture ("frame") the dungeon HUD, gauges and minimap draw with.
 *
 */
extern mgCTexture *TEX_SystenFrame;

/**
 *
 * Second frame texture ("frame2") the startup episode title draws with.
 *
 */
extern mgCTexture *TEX_SystenFrame2;

/**
 *
 * Status condition icon texture ("status_icon") of the main character's status board.
 *
 */
extern mgCTexture *TEX_StatusIcon;

/**
 *
 * First icon texture ("icon_dmy1") of the main character's status board.
 *
 */
extern mgCTexture *TEX_DummyIcon1;

/**
 *
 * Second icon texture ("icon_dmy2") of the status boards.
 *
 */
extern mgCTexture *TEX_DummyIcon2;

/**
 *
 * Shared dungeon effect texture ("effect00") of hit, healing, death and marker effects.
 *
 */
extern mgCTexture *TEX_SystemEffect1;

/**
 *
 * Second dungeon effect texture ("effect01") of the flash effect.
 *
 */
extern mgCTexture *TEX_SystemEffect2;

/**
 *
 * Third dungeon effect texture ("effect02").
 *
 */
extern mgCTexture *TEX_SystemEffect3;

/**
 *
 * Sword trail texture ("sweff") that sword after-effects draw with.
 *
 */
extern mgCTexture *TEX_SystemEffectSw;

/**
 *
 * Fire element hit effect texture ("bteffe_fla").
 *
 */
extern mgCTexture *TEX_ExFx_FIRE;

/**
 *
 * Ice element hit effect texture ("bteffe_chi").
 *
 */
extern mgCTexture *TEX_ExFx_ICE;

/**
 *
 * Lightning element hit effect texture ("bteffe_lig").
 *
 */
extern mgCTexture *TEX_ExFx_THUN;

/**
 *
 * Looks up the dungeon's system textures by name and stores them in the TEX_ globals.
 *
 * @mangled GetTextureInfo__FP6CScene
 * @address 0x1E9580
 * @size 0x180
 */
void GetTextureInfo(CScene *scene);

/**
 *
 * Loads and registers the dungeon's system textures and work textures, then looks them up.
 *
 * @mangled MainTextureInterface__FP9mgCMemoryP6CScene
 * @address 0x1E9700
 * @size 0x430
 */
void MainTextureInterface(mgCMemory *stack, CScene *scene);

/**
 *
 * Wears down the main character's weapon after a melee hit on a monster.
 *
 * @mangled calcWeaponParamWhp__FP14CActiveMonsterP8CColPrim
 * @address 0x1E9B30
 * @size 0x1B0
 */
void calcWeaponParamWhp(CActiveMonster *monster, CColPrim *col_prim);

/**
 *
 * Wears down the second character's weapon after she attacks with it.
 *
 * @mangled calcWeaponParam2__Fii
 * @address 0x1E9CE0
 * @size 0x1A0
 */
void calcWeaponParam2(int type, int divisor);

/**
 *
 * Copies a character's current weapon stats into an attack's collision primitive.
 *
 * @mangled SetDamageParam__FP8CColPrimi
 * @address 0x1E9E80
 * @size 0x160
 */
void SetDamageParam(CColPrim *col_prim, int slot_no);

/**
 *
 * Adds absorption points to the active characters' weapons and announces any level up.
 *
 * @mangled AddExpWeaponParam__Ffii
 * @address 0x1E9FE0
 * @size 0x290
 */
void AddExpWeaponParam(float amount, int weapon_owner, int kind);

/**
 *
 * Creates a character's sword trail effect, drawing one region of the sword trail texture.
 *
 * @mangled SetSwordBlurEffect__FP11CCharacter2P9mgCMemoryi
 * @address 0x1EA270
 * @size 0xD0
 */
void SetSwordBlurEffect(CCharacter2 *chara, mgCMemory *stack, int blur_type);
