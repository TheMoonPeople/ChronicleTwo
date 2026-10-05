#include "common.h"
#include "mg_memory.hpp"
#include "dataread.hpp"
#include "scriptinterpreter.hpp"
#include <cstdio>
#include "savedata.hpp"
#include "editriver.hpp"
#include "editdata.hpp"
#include <cstring>

void LoadEditAnalyzeData(char *script, int size, mgCMemory *stack);

static const int kEditConditionCount = 0x40;
static const int kEditPartsCount = 300;
static const int kEditGroupCount = 32;
static const int kEditPlaceSlotCount = 0x800;
static const int kEditPlaceFlagCount = 0x400;
static const int kAnalyzeSrcCount = 5;
static const int kAnalyzeEntryCount = 16;

extern SPI_TAG_PARAM tag__6[];

extern char at_1131__2[17];
extern char at_1281__4[10];
extern char at_1282__4[26];
extern "C" int __ct__18CScriptInterpreterFv(void *);
extern mgCMemory Stack_1272;
extern s8 init_1273;
extern u8 buff_1271[12288];
extern EditAnalyzeSrc AnalyzeSrc[kAnalyzeSrcCount];
extern EditAnalyzeSrc *eaAnaSrc;
extern EditAnalyzeDataSrc *eaAnaData;
extern mgCMemory *eaStack;
extern "C" int stSetBuffer__9mgCMemoryFP1i(void *memory, void *buffer, int blocks);

// Code (.text)
void EditAnalyzeDataSrc::Init(void) {
    message = NULL;
    percent = 0;
    geo_floor = 0;
    con_no[0] = -1;
    con_no[1] = -1;
    con_no[2] = -1;
    con_no[3] = -1;
    con_no[4] = -1;
    con_no[5] = -1;
    con_no[6] = -1;
    con_no[7] = -1;
    unk_10 = -1;
    on_parts = NULL;
    off_parts = NULL;
}
void EditAnalyzeSrc::Init() {
    for (int i = 0; i < kEditConditionCount; i++) {
        condition[i] = 0;
        geo_floor[i] = 0;
    }
    for (int i = 0; i < kAnalyzeEntryCount; i++) {
        data[i].Init();
    }
}
static EditAnalyzeDataSrc *GetAnalyzeDataSrc(int area, int entry) {
    if (area < 0 || area >= kAnalyzeSrcCount)
        return 0;
    if (entry < 0 || entry >= kAnalyzeEntryCount)
        return 0;
    for (int i = 0; i <= entry; i++) {
        if (AnalyzeSrc[area].data[i].message == 0)
            return 0;
    }
    return &AnalyzeSrc[area].data[entry];
}
void CEditData::Initialize(void) {
    memset(this, 0, sizeof(*this));
    InitPlaceData();
    memset(&analyze, 0, sizeof(analyze));
}
void CEditData::InitPlaceData(void) {
    int i;
    culture_point = 0;
    parts_max = kEditPartsCount;
    for (i = 0; i < parts_max; i++) {
        memset(&parts[i], 0, sizeof(EditDataParts));
    }
    house_max = kEditGroupCount;
    for (i = 0; i < house_max; i++) {
        memset(&house[i], 0, sizeof(EditDataHouse));
    }
    for (i = 0; i < kEditPlaceSlotCount; i++) {
        place_log[i].parts_no = -1;
    }
    for (i = 0; i < kEditPlaceFlagCount; i++) {
        grid[i] = 0;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdata", SaveData__8CEditMapFP9CEditData);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdata", LoadData__8CEditMapFP9CEditData);
int GetCulturePoint(CEditParts *parts, int) {
    if (parts == 0 || parts->info == 0)
        return 0;
    return parts->info->cpoint[1];
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdata", CultureAnalyzeParts__8CEditMapFii);
int CEditMap::CultureAnalyze(int mode) {
    int total;
    int pass = 0;
    do {
        total = 0;
        for (int i = 0; i < edit_parts_max; i++) {
            total += CultureAnalyzeParts(i, mode);
        }
        pass++;
    } while (pass <= 0);
    return total;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdata", GetOnOffParts__8CEditMapFPcPP9CMapPartsPP9CMapPiecei);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdata", PartsOnOff__8CEditMapFiP9CEditData);
int CEditData::GetPartsNumID(int parts_id) {
    int number = 0;
    EditDataParts *entry = parts;
    for (int i = 0; i < parts_max; i++, entry++) {
        if (entry->id != 0 && parts_id == entry->id && entry->state != 0)
            number++;
    }
    return number;
}
s8 CEditData::Analyze(int entry, int area, int *pending, int depth) {
    EditAnalyzeDataSrc *src;
    s8 result;
    int i;
    s8 flag_no;

    if (depth > kEditConditionCount) {
        printf(at_1131__2);
        return 0;
    }
    src = GetAnalyzeDataSrc(area, entry);
    if (src == NULL) {
        return 0;
    }
    result = 0;
    if (src->message == 0) {
        return 0;
    }
    for (i = 0; i < 8; i++) {
        flag_no = src->con_no[i];
        if (flag_no < 0) {
            break;
        }
        result = 1;
        if (pending[flag_no] >= 0) {
            analyze.condition[flag_no] = Analyze(pending[flag_no], area, pending, depth + 1);
            pending[flag_no] = -1;
        }
        if (analyze.condition[flag_no] == 0) {
            return 0;
        }
    }
    return result;
}
void CEditData::Analize(int area, int *flags, int *pending) {
    int i;
    int j;

    for (i = 0; i < kEditConditionCount; i++) {
        if (pending[i] < 0) {
            analyze.condition[i] = (s8)flags[i];
        }
    }
    for (j = 0; j < kEditConditionCount; j++) {
        if (pending[j] >= 0) {
            analyze.condition[j] = Analyze(pending[j], area, pending, 0);
            pending[j] = -1;
        }
    }
}
EditAnalyzeDataSrc *CEditData::GetAnalyzeData(int area, int entry) {
    return GetAnalyzeDataSrc(area, entry);
}
EditAnalyzeSrc *CEditData::GetAnalyzeSrc(int index) {
    if (index < 0 || index >= kAnalyzeSrcCount)
        return 0;
    return &AnalyzeSrc[index];
}
int CEditData::GetAnalyzePercent(int area) {
    int total;
    int entry_no;
    EditAnalyzeDataSrc *entry;

    total = 0;
    for (entry_no = 0; entry_no < kAnalyzeEntryCount; entry_no++) {
        entry = GetAnalyzeDataSrc(area, entry_no);
        if (entry == NULL) {
            return total;
        }
        if ((entry->message != 0) && (GetAnalyzeFlag(area, entry_no) != 0)) {
            total += entry->percent;
        }
    }
    return total;
}
int CEditData::GetAnalyzeFlag(int area, int entry, int *condition_nos, int *condition_values) {
    EditAnalyzeDataSrc *src = GetAnalyzeDataSrc(area, entry);
    int all_hold = 1;
    int i;
    if (src == NULL) {
        return 0;
    }
    for (i = 0; i < 8; i++) {
        int con_no = src->con_no[i];
        condition_nos[i] = con_no;
        if (con_no < 0) {
            if (i == 0) {
                return 0;
            }
            break;
        }
        condition_values[i] = analyze.condition[con_no];
        if (condition_values[i] == 0) {
            all_hold = 0;
        }
    }
    return all_hold;
}
int CEditData::GetAnalyzeFlag(int map_no, int data_no) {
    int condition_numbers[EDIT_ANALYZE_CON_NO_MAX];
    int condition_flags[EDIT_ANALYZE_CON_NO_MAX];
    return GetAnalyzeFlag(map_no, data_no, condition_numbers, condition_flags);
}
void CEditData::dbgSetContintionFlag(int area, int flag_no, int value) {
    if (flag_no < 0 || flag_no >= kEditConditionCount)
        return;
    analyze.condition[flag_no] = (u8)value;
}
void CEditData::dbgSetAnalyzeFlag(int map_no, int data_no, int flag) {
    EditAnalyzeDataSrc *request = GetAnalyzeData(map_no, data_no);
    if (request == NULL) {
        return;
    }
    for (int i = 0; i < EDIT_ANALYZE_CON_NO_MAX; i++) {
        s8 condition_no = request->con_no[i];
        if (condition_no < 0) {
            break;
        }
        dbgSetContintionFlag(map_no, condition_no, flag);
    }
}
void CEditData::dbgSetAllContintionFlag(int map_no, int flag) {
    int condition_no = 0;
    do {
        s8 *conditions = &analyze.condition[condition_no];
        conditions[0] = flag;
        conditions[1] = flag;
        conditions[2] = flag;
        conditions[3] = flag;
        conditions[4] = flag;
        conditions[5] = flag;
        conditions[6] = flag;
        conditions[7] = flag;
        condition_no += 8;
    } while (condition_no < EDIT_ANALYZE_CONDITION_MAX);
}
int CEditData::dbgGetContintionFlag(int area, int flag_no, char *name) {
    if (flag_no < 0 || flag_no >= kEditConditionCount) {
        return 0;
    }
    if (name != 0) {
        name[0] = 0;
        if (area >= 0 && area < kAnalyzeSrcCount + 1) {
            char *source = AnalyzeSrc[area].condition[flag_no];
            if (source != 0) {
                strcpy(name, source);
            }
        }
    }
    return analyze.condition[flag_no];
}
void LoadEditAnalyzeData(int area_no, u_long128 *dest) {
    char path[0x4C];
    int size;

    if (init_1273 == 0) {
        Stack_1272.Init();
        init_1273 = 1;
    }
    stSetBuffer__9mgCMemoryFP1i(&Stack_1272, (u_long128 *)&buff_1271, 0x300);
    sprintf(path, at_1281__4, area_no);
    if (LoadFile2(path, dest, &size, 0) != 0) {
        LoadEditAnalyzeData((char *)dest, size, &Stack_1272);
    }
    printf(at_1282__4, ((Stack_1272.stack_size - Stack_1272.stack_used) * 16) / 1024);
}
void LoadEditAnalyzeData(char *script, int size, mgCMemory *stack) {
    u8 interpreter[0xED0];
    eaStack = stack;
    eaAnaSrc = 0;
    __ct__18CScriptInterpreterFv(interpreter);
    ((CScriptInterpreter *)interpreter)->SetTag(tag__6);
    ((CScriptInterpreter *)interpreter)->SetScript(script, size);
    ((CScriptInterpreter *)interpreter)->Run();
}
int eaGEO_ANALYZE(SPI_STACK *stack, int) {
    eaAnaSrc = 0;
    int id = spiGetStackInt(stack);
    if (id < 0 || id >= kAnalyzeSrcCount)
        return 0;
    eaAnaSrc = &AnalyzeSrc[id];
    eaAnaSrc->Init();
    eaAnaData = 0;
    return 1;
}
int eaCONDITION(SPI_STACK *stack, int argc) {
    int con_no;
    if (eaAnaSrc == 0)
        return 0;
    con_no = spiGetStackInt(stack++);
    if (con_no < 0 || con_no >= kEditConditionCount)
        return 0;
    eaAnaSrc->condition[con_no] = mgCopyString(spiGetStackString(stack++), eaStack);
    if (argc >= 3) {
        eaAnaSrc->geo_floor[con_no] = spiGetStackInt(stack);
    }
    return 1;
}
int eaANALYZE(SPI_STACK *stack, int argc) {
    int entry_no;
    if (eaAnaSrc == 0)
        return 0;
    entry_no = spiGetStackInt(stack++);
    if (entry_no < 0 || entry_no >= kAnalyzeEntryCount)
        return 0;
    eaAnaData = &eaAnaSrc->data[entry_no];
    eaAnaData->unk_10 = spiGetStackInt(stack++);
    eaAnaData->message = mgCopyString(spiGetStackString(stack++), eaStack);
    eaAnaData->con_no[0] = -1;
    if (argc >= 4) {
        eaAnaData->geo_floor = spiGetStackInt(stack);
    }
    return 1;
}
int eaCON_NO(SPI_STACK *stack, int count) {
    if (eaAnaData == 0)
        return 0;
    if (count >= 8)
        return 0;
    for (int i = 0; i < count; i++) {
        eaAnaData->con_no[i] = spiGetStackInt(stack++);
    }
    eaAnaData->con_no[count] = -1;
    return 1;
}
int eaON_PARTS(SPI_STACK *stack, int) {
    if (eaAnaData == 0)
        return 0;
    eaAnaData->on_parts = mgCopyString(spiGetStackString(stack), eaStack);
    return 1;
}
int eaOFF_PARTS(SPI_STACK *stack, int) {
    if (eaAnaData == 0)
        return 0;
    eaAnaData->off_parts = mgCopyString(spiGetStackString(stack), eaStack);
    return 1;
}
int eaPERCENT(SPI_STACK *stack, int) {
    if (eaAnaData == NULL) {
        return 0;
    }
    eaAnaData->percent = spiGetStackInt(stack);
    return 1;
}
int eaEND_ANALYZE(SPI_STACK *, int) {
    eaAnaData = 0;
    return 1;
}
int eaEND_GEO_ANALYZE(SPI_STACK *, int) {
    eaAnaSrc = 0;
    return 1;
}
int GetMaxPolyn(int map_no) {
    int max_polygons = 0xFA0;
    if (map_no != 4) {
        max_polygons = 0x1770;
        switch (map_no) {
        case 0:
            return 0xFA0;
        case 1:
            return 0x1770;
        case 2:
            return 0x1770;
        case 3:
            return max_polygons;
        default:
            return 0;
        }
    } else {
        return max_polygons;
    }
}
int GetMaxDrawMem(int map_no) {
    int max_draw_memory = 0xBB80;
    if (map_no != 4) {
        max_draw_memory = 0xD2F0;
        switch (map_no) {
        case 0:
            return 0xBB80;
        case 1:
            return 0xC350;
        case 2:
            return 0xD2F0;
        case 3:
            return max_draw_memory;
        default:
            return 0;
        }
    } else {
        return max_draw_memory;
    }
}
EditAnalyzeSrc::EditAnalyzeSrc() {
    Init();
}
// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdata", __sinit_editdata_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", tag__6__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_713__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_714__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_917__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_1131__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_1281__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_1282__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_1290__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_1291__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_1292__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_1293__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_1294__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_1295__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_1296__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_1297__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", at_1298__3__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editdata", D_0037B050__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(init_1273, 0x4);
INCLUDE_BSS(eaAnaSrc, 0x4);
INCLUDE_BSS(eaAnaData, 0x4);
INCLUDE_BSS(eaStack, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(AnalyzeSrc, 0x1040);
INCLUDE_BSS(buff_1271, 0x3000);
INCLUDE_BSS(Stack_1272, 0x30);
