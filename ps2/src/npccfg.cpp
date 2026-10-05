#include "common.h"
#include "npccfg.hpp"
#include "scriptinterpreter.hpp"
#include "dataread.hpp"
#include "mainloop.hpp"
#include "menucommon.hpp"
#include <cstdio>
#include <cstring>

/** Number of initialized party-character entries. */
extern int NpcBaseDataTotalNum;
/** Party-character entries loaded from the NPC script. */
extern NPC_BASE_DATA NpcBaseData[180];
/** Next free party-character entry while the NPC script runs. */
extern u8 npc_spi_count_num;
extern const char at_838__4[];
extern const char at_898__4[];
extern const char at_899__4[];
extern const char at_900__5[];
extern const char at_901__3[];
extern signed char typetbl_853[16];
extern char path_885[0x40];
extern char infocfg_886[];
extern const char at_847__3[];
// Code (.text)
extern SPI_TAG_PARAM npc_spitag[3];

/**
 * Records the number of party characters declared by the NPC script.
 */
int _NPC_NUM(SPI_STACK *stack, int argument_count) {
    NpcBaseDataTotalNum = spiGetStackInt(stack);
    return 1;
}

/**
 * Reads one party-character record from the NPC script's stack.
 */
int _NPC_INFO(SPI_STACK *stack, int argument_count) {
    NPC_BASE_DATA *data = &NpcBaseData[npc_spi_count_num++];
    int id = spiGetStackInt(stack++);
    char *name = spiGetStackString(stack++);
    char *model = spiGetStackString(stack++);
    data->chara_no = id;
    if (name != 0) {
        strcpy(data->name, name);
        if (strlen(name) > 0x1B) {
            printf(at_838__4, name);
        }
    }
    if (model != 0) {
        strcpy(data->model, model);
    }
    data->unk_31 = spiGetStackInt(stack++);
    data->ability_num = spiGetStackInt(stack++);
    data->max_npc_point = spiGetStackInt(stack++);
    data->ability_cost[0] = spiGetStackInt(stack++);
    data->ability_cost[1] = spiGetStackInt(stack++);
    data->ability_cost[2] = spiGetStackInt(stack++);
    data->ability_cost[3] = spiGetStackInt(stack++);
    data->debug_flag = spiGetStackInt(stack);
    return 1;
}
void LoadNPCCfg() {
    u_long128 work[2048];
    char path[32];
    int size;
    u_long128 *buffer = MenuCalcBufAlignment(work);
    sprintf(path, at_847__3, LanguageCode);
    npc_spi_count_num = 0;
    if (LoadFile2(path, buffer, &size, 0) != 0) {
        CScriptInterpreter interpreter;
        interpreter.SetTag(npc_spitag);
        interpreter.SetScript((char *)buffer, size);
        interpreter.Run();
    }
    NpcBaseDataTotalNum = npc_spi_count_num;
}
int GetPartyCharaMessage(int chara_no, int type, int event) {
    if (GetPartyNPCData(chara_no) == 0) {
        return 0;
    }
    int message = typetbl_853[type] + chara_no * 100;
    if (type == 12) {
        message = chara_no + 3000;
    }
    if (event != 0) {
        message += 30000;
    }
    return message;
}
char *GetNPCModelName(int chara_no) {
    NPC_BASE_DATA *data = GetPartyNPCData(chara_no);
    if (data != 0) {
        return data->model;
    }
    return 0;
}

char *GetNPCName(int chara_no) {
    NPC_BASE_DATA *data = GetPartyNPCData(chara_no);
    if (data != 0) {
        return data->name;
    }
    return 0;
}
char *GetPartyCharaModelName(int chara_no, int type) {
    char *model;
    if (chara_no <= 0 || chara_no > 0x20) {
        return 0;
    }
    path_885[0] = 0;
    model = GetNPCModelName(chara_no);
    if (model != 0) {
        if (type == 0) {
            strcpy(path_885, at_898__4);
            strcat(path_885, model);
            strcat(path_885, at_899__4);
            return path_885;
        }
        if (type == 1) {
            return infocfg_886;
        }
        if (type == 2) {
            sprintf(path_885, at_900__5, model);
            return path_885;
        }
        if (type == 3) {
            sprintf(path_885, at_901__3, model);
            return path_885;
        }
    }
    return 0;
}
NPC_BASE_DATA *GetPartyNPCData(int chara_no) {
    for (int i = 0; i < NpcBaseDataTotalNum; i++) {
        if (NpcBaseData[i].chara_no == chara_no) {
            return &NpcBaseData[i];
        }
    }
    return 0;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/npccfg", npc_spitag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/npccfg", typetbl_853__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/npccfg", infocfg_886__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/npccfg", at_838__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/npccfg", at_839__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/npccfg", at_840__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/npccfg", at_847__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/npccfg", at_898__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/npccfg", at_899__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/npccfg", at_900__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/npccfg", at_901__3__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(NpcBaseDataTotalNum, 0x4);
INCLUDE_BSS(npc_spi_count_num, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(NpcBaseData, 0x2600);
INCLUDE_BSS(path_885, 0x40);
