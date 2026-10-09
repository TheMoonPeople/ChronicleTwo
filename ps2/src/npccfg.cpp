#include "common.h"

#include <cstdio>
#include <cstring>

#include "dataread.hpp"
#include "mainloop.hpp"
#include "menucommon.hpp"
#include "npccfg.hpp"
#include "scriptinterpreter.hpp"

/**
 *
 * Number of initialized party-character entries.
 *
 */
static int NpcBaseDataTotalNum;

/**
 *
 * Party-character entries loaded from the NPC script.
 *
 */
static NPC_BASE_DATA NpcBaseData[180] __attribute__((aligned(16)));

/**
 *
 * Next free party-character entry while the NPC script runs.
 *
 */
static u8 npc_spi_count_num;

// Code (.text)

/**
 *
 * Records the number of party characters declared by the NPC script.
 *
 */
static int _NPC_NUM(SPI_STACK *stack, int argument_count) {
    NpcBaseDataTotalNum = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Reads one party-character record from the NPC script's stack.
 *
 */
static int _NPC_INFO(SPI_STACK *stack, int argument_count) {
    NPC_BASE_DATA *data = &NpcBaseData[npc_spi_count_num++];
    int            id = spiGetStackInt(stack++);
    char          *name = spiGetStackString(stack++);
    char          *model = spiGetStackString(stack++);
    data->chara_no = id;

    if (name != 0) {
        strcpy(data->name, name);

        if (strlen(name) > 0x1B) {
            printf("NAME OVER!!!!!!:%s\n", name);
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

/**
 *
 * Script commands that populate the party-character table.
 *
 */
static SPI_TAG_PARAM npc_spitag[3] = {
    {"NPC_NUM", _NPC_NUM},
    {"NPC_INFO", _NPC_INFO},
    {NULL, NULL},
};

void LoadNPCCfg() {
    u_long128  work[2048];
    char       path[32];
    int        size;
    u_long128 *buffer = MenuCalcBufAlignment(work);
    sprintf(path, "npc%d.cfg", LanguageCode);
    npc_spi_count_num = 0;

    if (LoadFile2(path, buffer, &size, 0) != 0) {
        CScriptInterpreter interpreter;
        interpreter.SetTag(npc_spitag);
        interpreter.SetScript((char *) buffer, size);
        interpreter.Run();
    }

    NpcBaseDataTotalNum = npc_spi_count_num;
}

/**
 *
 * Message suffix for each party-character message category.
 *
 */
static signed char typetbl_853[16] = {0, 10, 20, 30, 2, 40, 45, 50, 55, 0, 90, 60, 0, 21, 25, 0};

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
    /**
     *
     * Buffer holding the requested party-character model path.
     *
     */
    static char path[0x40];

    /**
     *
     * Character information script name.
     *
     */
    static char infocfg[] = "info.cfg";

    char *model;

    if (chara_no <= 0 || chara_no > 0x20) {
        return 0;
    }

    path[0] = 0;
    model = GetNPCModelName(chara_no);

    if (model != 0) {
        if (type == NPC_MODEL_PATH_CHARA) {
            strcpy(path, "chara/");
            strcat(path, model);
            strcat(path, ".chr");
            return path;
        }

        if (type == NPC_MODEL_PATH_INFO) {
            return infocfg;
        }

        if (type == NPC_MODEL_PATH_EVENT_TRAIN) {
            sprintf(path, "event/train/t%s.chr", model);
            return path;
        }

        if (type == NPC_MODEL_PATH_MENU) {
            sprintf(path, "menu/npc/t%s.chr", model);
            return path;
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
