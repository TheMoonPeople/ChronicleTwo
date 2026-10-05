#include "common.h"
#include "mg_memory.hpp"
#include "savedata.hpp"
#include "mainloop.hpp"
#include "scriptinterpreter.hpp"
#include "quest.hpp"
#include "mainloop.hpp"
#include "savedata.hpp"
#include "scriptinterpreter.hpp"
#include "mg_memory.hpp"
#include <cstring>

extern CQuestManager *spi_questman;
extern mgCMemory *spi_queststack;
extern QUEST_INFO *spi_quest_info;
extern SPI_TAG_PARAM quest_cmd_tag[];
#ifdef NONMATCHING
static CQuestManager *spi_questman; /**< Request list currently being read from a script. */
static mgCMemory *spi_queststack; /**< Heap used for the request list. */
static QUEST_INFO *spi_quest_info; /**< Request currently being filled. */


static SPI_TAG_PARAM quest_cmd_tag[] = {
    {"NUM", quest_NUM},
    {"NEW", quest_NEW},
    {"COMMENT", quest_COMMENT},
    {"END", quest_END},
    {NULL, NULL},
};
#endif

// Code (.text)
static CQuestData *GetQuestData() {
    CSaveData *save_data = GetSaveData();
    return save_data != NULL ? &save_data->quest_data : NULL;
}
void CQuestManager::Initialize(void) {
    num = 0;
    info = NULL;
}
QUEST_INFO *CQuestManager::GetQuestInfo(int id) {
    for (int index = 0; index < num; ++index) {
        if (info[index].id == id) {
            return &info[index];
        }
    }
    return NULL;
}
int quest_NUM(SPI_STACK *stack, int arg_count) {
    int num;
    u32 size;
    u32 blocks;

    num = spiGetStackInt(stack);
    spi_questman->num = num;
    size = num * sizeof(QUEST_INFO);
    if (size & 0xF) {
        blocks = (size >> 4) + 1;
    } else {
        blocks = size >> 4;
    }
    spi_questman->info =
        (QUEST_INFO *)operator new[](size, (u_long128 *)spi_queststack->Alloc(blocks + 2));
    spi_quest_info = spi_questman->info;
    return 1;
}
int quest_NEW(SPI_STACK *stack, int arg_count) {
    int id = spiGetStackInt(stack++);
    char *name = spiGetStackString(stack);
    spi_quest_info->id = id;
    strcpy(spi_quest_info->name, name);
    return 1;
}
int quest_COMMENT(SPI_STACK *stack, int arg_count) {
    int index = spiGetStackInt(stack++);
    char *text = spiGetStackString(stack);
    if (index == 0) {
        strcpy(spi_quest_info->comment, text);
    }
    if (index > 0) {
        strcpy(spi_quest_info->reaction[index - 1], text);
    }
    return 1;
}
int quest_END(SPI_STACK *stack, int arg_count) {
    spi_quest_info++;
    return 1;
}
void CQuestManager::LoadCfg(mgCMemory *memory, char *script, int length) {
    spi_questman = this;
    spi_queststack = memory;
    CScriptInterpreter interpreter;
    interpreter.SetTag(quest_cmd_tag);
    interpreter.SetScript(script, length);
    interpreter.Run();
}
void CQuestData::Initialize() {
    memset(this, 0, sizeof(*this));
}
void CQuestData::SetQuestFlag(int index, int value) {
    if (index < 0 || index >= QUEST_PLAY_DATA_MAX)
        return;
    play[index].accepted = value;
}
void CQuestData::QuestClear(int index) {
    if (index < 0 || index >= QUEST_PLAY_DATA_MAX)
        return;
    play[index].cleared = 1;
}
QUEST_PLAY_DATA *CQuestData::GetPlayQuestData(int index) {
    if (index < 0 || index >= QUEST_PLAY_DATA_MAX)
        return 0;
    return &play[index];
}
void QuestRequestSetFlag(int id, int flag) {
    CQuestData *quest_data = GetQuestData();
    if (quest_data != NULL) {
        quest_data->SetQuestFlag(id, flag);
    }
}
void QuestRequestClear(int id, int unused) {
    CQuestData *quest_data = GetQuestData();
    if (quest_data != NULL) {
        quest_data->QuestClear(id);
    }
}
int GetQuestRequestStatus(int id) {
    CQuestData *quest_data = GetQuestData();
    if (quest_data == NULL) {
        return QUEST_REQUEST_STATUS_INVALID;
    }
    QUEST_PLAY_DATA *progress = quest_data->GetPlayQuestData(id);
    if (progress == NULL) {
        return QUEST_REQUEST_STATUS_INVALID;
    }
    if (progress->cleared != 0) {
        return QUEST_REQUEST_STATUS_CLEARED;
    }
    return progress->accepted != 0;
}
int CMonsterBook::CountKill(int monster, int amount) {
    if (monster < 0)
        return 0;
    if (monster >= MONSTER_BOOK_ENTRY_MAX)
        return 0;
    entry[monster].kill_count += (u16)amount;
    if (entry[monster].kill_count > 60000)
        entry[monster].kill_count = 60000;
    return entry[monster].kill_count;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/quest", quest_cmd_tag__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/quest", at_878__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/quest", at_879__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/quest", at_880__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/quest", at_881__4__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(spi_questman, 0x4);
INCLUDE_BSS(spi_queststack, 0x4);
INCLUDE_BSS(spi_quest_info, 0x4);
