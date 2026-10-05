#include "common.h"
#include "mg_memory.hpp"
#include "scriptinterpreter.hpp"
#include "villagermngr.hpp"
#include "vlgr_info.hpp"
#include "dataread.hpp"
#include <cstring>
#include <cstdio>

extern int PlaceInfoNum;
extern CVillagerPlaceInfo *PlaceInfo;
extern int VlgrInfoNum;
extern CVillagerInfo *VlgrInfo;
extern CVillagerPlace VlgrPlace[VLGR_PLACE_MAX];
extern mgCMemory *niStack;
extern CVillagerPlace *niVlgr;
extern int niProgNum;
extern int niProgTime;
extern int niProgDupliID;
extern int niProgCon;
extern CVillagerPlace::ProgressInfo *niProgInfo;
extern CVillagerPlace::ProgressInfo *niNowProgInfo;
extern CVillagerPlaceInfo *niPlaceInfo;
extern int niPlaceInfoNum;
extern int niVlgrInfoIdx;
extern mgCMemory *vpiStack;
extern CVillagerPlaceInfo *vpiInfo;
extern SPI_TAG_PARAM ni_tag[];
extern SPI_TAG_PARAM tag__9[];
extern SPI_TAG_PARAM gi_tag[];
extern char at_214[];
extern char at_250[];
extern char at_351[];
extern char at_352[];
extern char at_353__2[];
extern char at_354[];
extern char at_355[];
extern char at_356__2[];
extern char at_357__2[];
extern char at_358__3[];
extern char at_359__2[];
extern char at_364__2[];
extern char at_365__2[];
extern char at_366__2[];
extern char at_367__2[];
extern char at_368__3[];
extern char at_369__5[];
extern char at_370__4[];
extern char at_371__3[];
extern char at_372__3[];
extern char at_373__4[];
extern char at_374__3[];
extern char at_439__2[];
extern char at_450__2[];
extern char at_495[];
extern char at_496[];
extern char at_497__2[];
extern char at_498[];
extern char at_509[];
extern char at_555[];
extern char at_556[];
extern char at_557[];
extern int ProgressNum;
extern GAME_PROGRESS_INFO ProgressInfo[GAME_PROGRESS_MAX];
extern GAME_PROGRESS_INFO *giGamePI;
extern mgCMemory *giStack;

// Code (.text)
CVillagerPlaceInfo *GetVlgrPlaceInfo(int index) {
    if (index < 0 || index >= PlaceInfoNum) {
        return NULL;
    }
    return PlaceInfo + index;
}
CVillagerPlace *GetVlgrPlaceTable(int *count) {
    *count = VLGR_PLACE_MAX;
    return VlgrPlace;
}
CVillagerInfo *GetVillagerInfo(int villager_no) {
    CVillagerInfo *table = VlgrInfo;
    int low;
    int high;
    int middle;

    if (table == NULL || VlgrInfoNum <= 0) {
        return NULL;
    }
    low = 0;
    high = VlgrInfoNum - 1;
    if (0 < high) {
        do {
            middle = (low + high) / 2;
            if (table[middle].vlgr_id < villager_no) {
                low = middle + 1;
            } else {
                high = middle;
            }
        } while (low < high);
    }
    if (villager_no == table[low].vlgr_id) {
        return &table[low];
    }
    return NULL;
}
int GetVillagerModelName(int villager_no, char *path) {
    CVillagerInfo *info;

    info = GetVillagerInfo(villager_no);
    *path = 0;
    if (info == NULL) {
        return 0;
    }
    sprintf(path, at_214, info->model_name);
    return 1;
}
int niNPC(SPI_STACK *stack, int argument_count) {
    niVlgr = NULL;
    int villager_no = spiGetStackInt(stack);
    if (villager_no < 0 || villager_no >= VLGR_PLACE_MAX) {
        return 0;
    }
    niVlgr = VlgrPlace + villager_no;
    memset(niVlgr, 0, sizeof(CVillagerPlace));
    niProgNum = 0;
    niProgTime = 0;
    niProgDupliID = 0;
    return 1;
}
int niNPC_END(SPI_STACK *stack, int argc) {
    niVlgr = 0;
    return 1;
}
int niPROGRESS(SPI_STACK *stack, int argument_count) {
    int progress = spiGetStackInt(stack++);
    niNowProgInfo = NULL;
    for (int index = 0; index < niProgNum; index++) {
        if (progress == niProgInfo[index].progress) {
            niNowProgInfo = niProgInfo + index;
            break;
        }
    }
    if (niNowProgInfo == NULL) {
        if (niProgNum >= GAME_PROGRESS_MAX) {
            return 0;
        }
        niNowProgInfo = niProgInfo + niProgNum++;
        niNowProgInfo->Init();
    }
    niNowProgInfo->progress = progress;
    niProgDupliID = spiGetStackInt(stack++);
    niProgCon = 0;
    char *condition = spiGetStackString(stack);
    if (condition != NULL && strcmp(condition, at_250) == 0) {
        niProgCon = 1;
    }
    niNowProgInfo->after = niProgCon;
    return 1;
}
int niPROGRESS_END(SPI_STACK *stack, int argument_count) {
    if (niVlgr == NULL) {
        return 0;
    }
    if (niProgNum <= 0) {
        return 1;
    }
    u32 size = niProgNum * sizeof(CVillagerPlace::ProgressInfo);
    u32 blocks;
    if (size & 0xF) {
        blocks = (size >> 4) + 1;
    } else {
        blocks = size >> 4;
    }
    niVlgr->prog_info = new (niStack->Alloc(blocks + 2)) CVillagerPlace::ProgressInfo[niProgNum];
    niVlgr->prog_num = 0;
    if (niVlgr->prog_info == NULL) {
        return 0;
    }
    niVlgr->prog_num = niProgNum;
    for (int index = 0; index < niProgNum; index++) {
        niVlgr->prog_info[index] = niProgInfo[index];
    }
    return 1;
}
int niPLACE(SPI_STACK *stack, int argc) {
    return 1;
}
int niNOON_PLACE(SPI_STACK *stack, int argc) {
    int place_no = spiGetStackInt(stack);
    if (place_no < 0 || place_no >= niPlaceInfoNum) {
        return 0;
    }
    niNowProgInfo->place[niProgDupliID][0] = niPlaceInfo + place_no;
    return 1;
}
int niNIGHT_PLACE(SPI_STACK *stack, int argc) {
    int place_no = spiGetStackInt(stack);
    if (place_no < 0 || place_no >= niPlaceInfoNum) {
        return 0;
    }
    niNowProgInfo->place[niProgDupliID][1] = niPlaceInfo + place_no;
    return 1;
}
int niNPC_INFO_NUM(SPI_STACK *stack, int argument_count) {
    VlgrInfoNum = spiGetStackInt(stack);
    int count = VlgrInfoNum;
    u32 size = count * sizeof(CVillagerInfo);
    u32 blocks;
    if (size & 0xF) {
        blocks = (size >> 4) + 1;
    } else {
        blocks = size >> 4;
    }
    VlgrInfo = (CVillagerInfo *)(int)new (niStack->Alloc(blocks + 2)) CVillagerInfo[count];
    if (VlgrInfo == NULL) {
        VlgrInfoNum = 0;
    }
    niVlgrInfoIdx = 0;
    return 1;
}
CVillagerInfo::CVillagerInfo(void) {
    vlgr_id = -1;
    model_name = NULL;
    house_type = 0;
    hide_frames = NULL;
    show_frames = NULL;
    unk_18 = -1;
    unk_14 = -1;
}
int niNPC_INFO(SPI_STACK *stack, int argument_count) {
    if (niVlgrInfoIdx >= VlgrInfoNum) {
        return 0;
    }
    CVillagerInfo *info = VlgrInfo + niVlgrInfoIdx;
    info->vlgr_id = spiGetStackInt(stack++);
    char *name = spiGetStackString(stack++);
    if (name != NULL) {
        info->model_name = mgCopyString(name, niStack);
    }
    if (argument_count >= 3) {
        info->house_type = spiGetStackInt(stack++);
    }
    if (argument_count >= 4) {
        char *show_frames = spiGetStackString(stack++);
        if (show_frames != NULL) {
            info->show_frames = mgCopyString(show_frames, niStack);
        }
    }
    if (argument_count >= 5) {
        char *hide_frames = spiGetStackString(stack++);
        if (hide_frames != NULL) {
            info->hide_frames = mgCopyString(hide_frames, niStack);
        }
    }
    if (argument_count >= 7) {
        info->unk_14 = spiGetStackInt(stack++);
        info->unk_18 = spiGetStackInt(stack);
    }
    niVlgrInfoIdx++;
    return 1;
}
void LoadNPCInfo(char *script, int length, mgCMemory *memory) {
    CVillagerPlace::ProgressInfo progressTable[GAME_PROGRESS_MAX];

    niProgInfo = progressTable;
    niStack = memory;
    niVlgr = 0;
    niProgNum = 0;
    niNowProgInfo = NULL;
    niPlaceInfo = PlaceInfo;
    niPlaceInfoNum = PlaceInfoNum;
    CScriptInterpreter interpreter;
    interpreter.SetTag(ni_tag);
    interpreter.SetScript(script, length);
    interpreter.Run();
}
void LoadPlaceInfo(char *script, int length, mgCMemory *memory) {
    vpiStack = memory;
    vpiInfo = NULL;
    CScriptInterpreter interpreter;
    interpreter.SetTag(tag__9);
    interpreter.SetScript(script, length);
    interpreter.Run();
}
int vpiNPC_PLACE_NUM(SPI_STACK *stack, int argc) {
    int count = spiGetStackInt(stack);
    if (count <= 0) {
        return 0;
    }

    u32 blocks;
    if (((u32)count * sizeof(CVillagerPlaceInfo)) & 0xF) {
        blocks = (((u32)count * sizeof(CVillagerPlaceInfo)) >> 4) + 1;
    } else {
        blocks = ((u32)count * sizeof(CVillagerPlaceInfo)) >> 4;
    }
    void *block = vpiStack->Alloc(blocks + 2);
    CVillagerPlaceInfo *places = new ((u_long128 *)block) CVillagerPlaceInfo[count];
    if (places == NULL) {
        return 0;
    }
    PlaceInfo = places;
    PlaceInfoNum = count;
    return 1;
}
CVillagerPlaceInfo::CVillagerPlaceInfo() {
    memset(this, 0, sizeof(CVillagerPlaceInfo));
    map_no = -1;
}
int vpiNPC_PLACE(SPI_STACK *stack, int argc) {
    int place_no = spiGetStackInt(stack++);
    int id = spiGetStackInt(stack);
    vpiInfo = PlaceInfo + place_no;
    vpiInfo->map_no = id;
    vpiInfo->move_motion = 1;
    return 1;
}
int vpiNPC_PLACE_END(SPI_STACK *stack, int argc) {
    vpiInfo = NULL;
    return 1;
}
int vpiPLACE_POS(SPI_STACK *stack, int argc) {
    if (vpiInfo == NULL) {
        return 0;
    }
    spiGetStackVector(vpiInfo->pos, stack);
    vpiInfo->pos[3] = spiGetStackFloat(stack += 3);
    return 1;
}
int vpiMOVE_TO(SPI_STACK *stack, int argc) {
    if (vpiInfo == NULL) {
        return 0;
    }
    CVillagerPlaceInfo::Node *node = vpiInfo->Add(vpiStack);
    if (node == NULL) {
        return 0;
    }
    node->type = 1;
    spiGetStackVector(node->pos, stack);
    node->pos[3] = spiGetStackFloat(stack += 3);
    return 1;
}
int vpiWAIT(SPI_STACK *stack, int argc) {
    if (vpiInfo == NULL) {
        return 0;
    }
    CVillagerPlaceInfo::Node *node = vpiInfo->Add(vpiStack);
    if (node == NULL) {
        return 0;
    }
    node->type = 2;
    char *posture = spiGetStackString(stack++);
    int motion_end = 0;
    if (posture != NULL) {
        if (strcmp(posture, at_439__2) == 0) {
            motion_end = 1;
        }
    }
    node->wait.motion_end = motion_end;
    node->wait.time = spiGetStackInt(stack++);
    char *motion_name = NULL;
    if (argc >= 3) {
        motion_name = spiGetStackString(stack);
    }
    node->wait.motion = vpiGetMotionID(motion_name);
    return 1;
}
int vpiMOTION(SPI_STACK *stack, int argc) {
    char *name;

    if (vpiInfo == NULL) {
        return 0;
    }
    name = spiGetStackString(stack);
    if (name == NULL) {
        return 1;
    }
    if (strcmp(name, at_450__2) == 0) {
        vpiInfo->motion = 4;
    }
    return 1;
}
int vpiTALK_OFFSET(SPI_STACK *stack, int argc) {
    if (vpiInfo == NULL) {
        return 0;
    }
    spiGetStackVector(vpiInfo->talk_offset, stack);
    return 1;
}
int vpiMOVE_MOTION(SPI_STACK *stack, int argc) {
    char *name;

    if (vpiInfo == NULL) {
        return 0;
    }
    name = spiGetStackString(stack);
    if (name == NULL) {
        return 1;
    }
    vpiInfo->move_motion = vpiGetMotionID(name);
    return 1;
}
int vpiMOVE_SPEED(SPI_STACK *stack, int argc) {
    if (vpiInfo == NULL) {
        return 0;
    }
    vpiInfo->move_speed = spiGetStackFloat(stack);
    return 1;
}
int vpiSHADOW(SPI_STACK *stack, int argc) {
    if (vpiInfo == NULL) {
        return 0;
    }

    vpiInfo->no_shadow = (int)(((spiGetStackInt(stack) != 0) ^ 1) & 0xFF);
    return 1;
}
int vpiGetMotionID(char *name) {
    if (name == NULL || *(s8 *)name == 0) {
        return -1;
    }
    if (strcmp(name, at_450__2) == 0) {
        return 4;
    }
    if (strcmp(name, at_495) == 0) {
        return 0;
    }
    if (strcmp(name, at_496) == 0) {
        return 8;
    }
    if (strcmp(name, at_497__2) == 0) {
        return 1;
    }
    return (strcmp(name, at_498) == 0) ? 2 : -1;
}
int giPROG_INFO(SPI_STACK *stack, int argument_count) {
    int progress = spiGetStackInt(stack++);
    if (progress < 0 || progress >= GAME_PROGRESS_MAX) {
        return 0;
    }
    giGamePI[progress].chapter = spiGetStackInt(stack++);
    giGamePI[progress].section = spiGetStackInt(stack++);
    giGamePI[progress].order = spiGetStackInt(stack++);
    char *name = spiGetStackString(stack);
    if (name != NULL) {
        giGamePI[progress].name = mgCopyString(name, giStack);
    }
    return 1;
}
void LoadGameInfo(mgCMemory *memory) {
    int script_size;
    char script[0x19000];
    if (LoadFile2(at_555, script, &script_size, 0) == 0) {
        return;
    }
    LoadPlaceInfo(script, script_size, memory);
    for (int progress = 0; progress < GAME_PROGRESS_MAX; progress++) {
        ProgressInfo[progress].section = 0;
        ProgressInfo[progress].chapter = 0;
        ProgressInfo[progress].name = NULL;
        ProgressInfo[progress].order = 0;
    }
    if (LoadFile2(at_556, script, &script_size, 0) == 0) {
        return;
    }
    giGamePI = ProgressInfo;
    giStack = memory;
    ProgressNum = GAME_PROGRESS_MAX;
    CScriptInterpreter interpreter;
    interpreter.SetTag(gi_tag);
    interpreter.SetScript(script, script_size);
    interpreter.Run();
    LoadNPCInfo(script, script_size, memory);
    printf(at_557, memory->stack_size - memory->stack_used);
}
GAME_PROGRESS_INFO *GetGameProgressInfo(int index) {
    if (index < 0 || index >= ProgressNum) {
        return NULL;
    }
    return &ProgressInfo[index];
}
int GetGameChapter(int index) {
    GAME_PROGRESS_INFO *info = GetGameProgressInfo(index);

    if (info != NULL) {
        return info->chapter;
    }
    return 0;
}
int GetGameProgressNum(void) {
    return ProgressNum;
}
CVillagerPlace::CVillagerPlace() {
    memset(this, 0, sizeof(CVillagerPlace));
}

extern "C" void *__construct_array(void *array, void *(*constructor)(void *),
                                    void *destructor, unsigned int size, unsigned int count);
extern "C" void *__ct__14CVillagerPlaceFv(void *place);
extern "C" void __sinit_vlgr_info_cpp() {
    __construct_array(VlgrPlace, __ct__14CVillagerPlaceFv, NULL,
                      sizeof(CVillagerPlace), VLGR_PLACE_MAX);
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", ni_tag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", tag__9__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", gi_tag__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_214__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_250__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_351__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_352__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_353__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_354__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_355__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_356__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_357__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_358__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_359__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_364__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_365__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_366__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_367__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_368__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_369__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_370__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_371__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_372__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_373__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_374__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_439__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_450__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_495__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_496__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_497__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_498__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_509__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_555__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_556__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", at_557__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/vlgr_info", D_0037B098__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(PlaceInfoNum, 0x4);
INCLUDE_BSS(PlaceInfo, 0x4);
INCLUDE_BSS(VlgrInfoNum, 0x4);
INCLUDE_BSS(VlgrInfo, 0x4);
INCLUDE_BSS(ProgressNum, 0x4);
INCLUDE_BSS(niStack, 0x4);
INCLUDE_BSS(niVlgr, 0x4);
INCLUDE_BSS(niProgNum, 0x4);
INCLUDE_BSS(niProgTime, 0x4);
INCLUDE_BSS(niProgDupliID, 0x4);
INCLUDE_BSS(niProgCon, 0x4);
INCLUDE_BSS(niProgInfo, 0x4);
INCLUDE_BSS(niNowProgInfo, 0x4);
INCLUDE_BSS(niPlaceInfo, 0x4);
INCLUDE_BSS(niPlaceInfoNum, 0x4);
INCLUDE_BSS(niVlgrInfoIdx, 0x4);
INCLUDE_BSS(vpiStack, 0x4);
INCLUDE_BSS(vpiInfo, 0x4);
INCLUDE_BSS(giGamePI, 0x4);
INCLUDE_BSS(giStack, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(VlgrPlace, 0x1000);
INCLUDE_BSS(ProgressInfo, 0xC00);
