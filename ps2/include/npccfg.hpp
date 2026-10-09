#pragma once

#include "common.h"

/**
 * @file
 * Declares the table of party characters (NPCs who can join the party),
 * read from the language's NPC configuration script, and the lookups that
 * give a character's name, model files and message numbers.
 */

/**
 *
 * Files GetPartyCharaModelName gives the path of, as its type argument holds them.
 *
 */
// clang-format off
enum NpcModelPathType {
    NPC_MODEL_PATH_CHARA       = 0, /**< Character model, "chara/<model>.chr". */
    NPC_MODEL_PATH_INFO        = 1, /**< Character information script, "info.cfg". */
    NPC_MODEL_PATH_EVENT_TRAIN = 2, /**< Event model, "event/train/t<model>.chr". */
    NPC_MODEL_PATH_MENU        = 3, /**< Menu model, "menu/npc/t<model>.chr". */
};

// clang-format on

/**
 *
 * One party character's entry in the NPC configuration table, as an NPC_INFO script tag fills it.
 *
 */
struct NPC_BASE_DATA {
    s16  chara_no;      /**< Party character number the entry describes. */
    s8   debug_flag;    /**< Non-zero when the debug party-character selector lists the character. */
    char name[0x1C];    /**< Character's display name. */
    char model[0x10];   /**< Base name of the character's model files. */
    s8   max_npc_point; /**< Points the character's abilities draw on, given on joining and the limit they recover to. */
    s8   ability_num;   /**< Number of abilities the character has. */
    s8   unk_31;
    u8   ability_cost[4]; /**< Points each ability uses. */
};

STATIC_ASSERT(sizeof(NPC_BASE_DATA) == 0x36);

/**
 *
 * Reads the current language's NPC configuration script and fills the party character table from it.
 *
 * @mangled LoadNPCCfg__Fv
 * @address 0x2AF740
 * @size 0xC0
 */
void LoadNPCCfg();

/**
 *
 * Gives the message number of a kind of message a party character says, or 0 for an unknown character.
 *
 * @mangled GetPartyCharaMessage__Fiii
 * @address 0x2AF800
 * @size 0x90
 */
int GetPartyCharaMessage(int chara_no, int type, int event);

/**
 *
 * Gives the base name of a party character's model files, or NULL for an unknown character.
 *
 * @mangled GetNPCModelName__Fi
 * @address 0x2AF890
 * @size 0x30
 */
char *GetNPCModelName(int chara_no);

/**
 *
 * Gives a party character's display name, or NULL for an unknown character.
 *
 * @mangled GetNPCName__Fi
 * @address 0x2AF8C0
 * @size 0x30
 */
char *GetNPCName(int chara_no);

/**
 *
 * Gives the path of one of a party character's files (an NpcModelPathType), or NULL when there is none.
 *
 * @mangled GetPartyCharaModelName__Fii
 * @address 0x2AF8F0
 * @size 0x110
 */
char *GetPartyCharaModelName(int chara_no, int type);

/**
 *
 * Finds a party character's entry in the NPC configuration table, or NULL when it has none.
 *
 * @mangled GetPartyNPCData__Fi
 * @address 0x2AFA00
 * @size 0x60
 */
NPC_BASE_DATA *GetPartyNPCData(int chara_no);
