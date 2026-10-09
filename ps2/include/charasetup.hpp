#pragma once

#include "common.h"

/**
 * @file
 * Declares the loading and linking of the player's characters: Max, Monica,
 * the ridepod with Max aboard, and a monster that Monica has transformed into.
 */

class mgCMemory;
class CScene;
class CUserDataManager;

/**
 *
 * Scene characters that make up the ridepod, as the indices of ROBO_INFO_DATA's model_name.
 *
 */
enum ROBO_MODEL_SLOT {
    ROBO_MODEL_LEG = 0,   /**< Legs, the character the other parts hang from. */
    ROBO_MODEL_ARM = 1,   /**< Arm. */
    ROBO_MODEL_BODY = 2,  /**< Body. */
    ROBO_MODEL_MINTS = 3, /**< Max riding in the body. */
    ROBO_MODEL_BPACK = 4, /**< Back pack. */
    ROBO_MODEL_NUM = 5,   /**< Number of ridepod parts with a model file. */
};

/**
 *
 * Model and joint names of one ridepod body.
 *
 */
struct ROBO_INFO_BODY {
    char body_file[13]; /**< Model file of the body. */
    char arm_name[24];  /**< Name of the arm that the body carries. */
};

STATIC_ASSERT(sizeof(ROBO_INFO_BODY) == 0x25);

/**
 *
 * Files and behaviour of the ridepod as its equipped parts make it up.
 *
 */
struct ROBO_INFO_DATA {
    char *model_name[ROBO_MODEL_NUM]; /**< Model file of each part, indexed by ROBO_MODEL_SLOT; Max's is a full file name, the rest lack the extension. */
    char *hat_file;                   /**< Path of the model of the hat that Max wears. */
    char *arm_name;                   /**< Arm name of the equipped body's robo_info_body row; NULL without a body. */
    s32   move_type;                  /**< Way of moving that the legs give, an ACTION_MOVE_TYPE value. */
    s32   attack_type;                /**< Attack type that the arm gives. */
};

STATIC_ASSERT(sizeof(ROBO_INFO_DATA) == 0x24);

/**
 *
 * Model and arm names of each ridepod body, indexed by the body's type
 * less one.
 *
 * @mangled robo_info_body
 * @address 0x351E20
 * @size 0x197
 */
extern ROBO_INFO_BODY robo_info_body[11];

/**
 *
 * Record of the ridepod's files and behaviour that GetRoboPartsInfo
 * fills and returns.
 *
 * @mangled robo_dat
 * @address 0x1EF7830
 * @size 0x24
 */
extern ROBO_INFO_DATA robo_dat;

/**
 *
 * Writes the path of the sound bank of a main character: Max's chosen by
 * his equipped weapon, Monica's, or the ridepod's from its arm.
 *
 * @mangled GetCharacterSnd__FP16CUserDataManageriPc
 * @address 0x1EA340
 * @size 0x100
 */
void GetCharacterSnd(CUserDataManager *user_data, int unit, char *path);

/**
 *
 * Loads the models, weapons, skins and action script of a main character
 * into the scene's characters and links them; returns 0 if the scene lacks
 * a character.
 *
 * @mangled SetupMainUnit__FP1P9mgCMemoryP9mgCMemoryiP6CSceneP16CUserDataManagerii
 * @address 0x1EA440
 * @size 0xC30
 */
int SetupMainUnit(u_long128 *read_buffer, mgCMemory *memory, mgCMemory *stacks, int image_block, CScene *scene, CUserDataManager *user_data, int chara_type, int edit_mode);

/**
 *
 * Returns the size of memory that the character stacks need for the largest
 * of the main characters, plus a quadword of slack.
 *
 * @mangled GetCharaMemAllocSize__Fv
 * @address 0x1EB070
 * @size 0x80
 */
int GetCharaMemAllocSize();

/**
 *
 * Empties a memory and carves from it the stacks that a main character's
 * parts load into; returns 0 if the memory runs out.
 *
 * @mangled GetCharaMemAllocPtr__FP9mgCMemoryP9mgCMemoryii
 * @address 0x1EB0F0
 * @size 0x160
 */
int GetCharaMemAllocPtr(mgCMemory *memory, mgCMemory *stacks, int chara_type, int edit_mode);

/**
 *
 * Attaches a main character's loaded parts to it, points it at the scene's
 * effects, and passes it to AtraMiriaOnOff when a save data control bit is set.
 *
 * @mangled SetupUnitMan__FP6CSceneP16CUserDataManageriP14ROBO_INFO_DATA
 * @address 0x1EB250
 * @size 0x100
 */
void SetupUnitMan(CScene *scene, CUserDataManager *user_data, int unit, ROBO_INFO_DATA *robo_info);

/**
 *
 * Gathers the files and behaviour of the ridepod from its equipped parts
 * into a shared record and returns it.
 *
 * @mangled GetRoboPartsInfo__FP16CUserDataManager
 * @address 0x1EB920
 * @size 0x2A0
 */
ROBO_INFO_DATA *GetRoboPartsInfo(CUserDataManager *user_data);
