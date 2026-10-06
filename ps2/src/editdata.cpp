#include "common.h"
#include "mg_memory.hpp"
#include "dataread.hpp"
#include "scriptinterpreter.hpp"
#include <cstdio>
#include "savedata.hpp"
#include "editriver.hpp"
#include "editdata.hpp"
#include "mdslist.hpp"
#include <cstring>
#include <cstdlib>

void LoadEditAnalyzeData(char *script, int size, mgCMemory *stack);

extern "C" int fptosi(float value);
static const int kEditConditionCount = 0x40;
static const int kEditPartsCount = 300;
static const int kEditGroupCount = 32;
static const int kEditPlaceSlotCount = 0x800;
static const int kEditPlaceFlagCount = 0x400;
static const int kAnalyzeSrcCount = 5;
static const int kAnalyzeEntryCount = 16;

extern SPI_TAG_PARAM tag__6[];

extern char at_1131__2[17];
extern char at_713__3[];
extern char at_714__2[];
extern char at_917__3[];
extern char at_1281__4[10];
extern char at_1282__4[26];
extern "C" int __ct__18CScriptInterpreterFv(void *);
extern mgCMemory Stack_1272;
extern s8 init_1273;
extern u8 buff_1271[12288];
EditAnalyzeSrc AnalyzeSrc[kAnalyzeSrcCount];
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
#ifdef NONMATCHING
void CEditMap::SaveData(CEditData *data) {
    EditDataParts *saved;
    EditPlaceLog *log;
    short remap[kEditPartsCount];
    float local[4];
    float rot[4];
    float pos[4];
    float color[4];
    float gridPos[4];
    int logCount;
    int unnamed;
    int unused;
    int savedCount;
    int i;
    int c;
    int k;
    int value;
    CEditParts *part;
    CEditGrid *river;
    u8 *out;
    EditDataGrid *header;
    short gridY;
    short gridZ;
    int x;
    int z;

    if (data == NULL) {
        return;
    }
    data->InitPlaceData();
    savedCount = 0;
    logCount = 0;
    saved = data->parts;
    log = data->place_log;
    for (i = 0; i < kEditPlaceSlotCount; i++) {
        log[i].parts_no = -1;
    }
    for (i = 0; i < place_log_max; i++) {
        unused = place_log[i].parts_no < 0;
        if (!unused) {
            log[logCount].parts_no = place_log[i].parts_no;
            log[logCount].base_no = place_log[i].base_no;
            logCount++;
        }
    }
    for (i = 0; i < kEditPartsCount; i++) {
        remap[i] = -1;
    }
    for (i = 0; i < edit_parts_max; i++) {
        part = &edit_parts[i];
        unnamed = part->name[0] == 0;
        if (!unnamed && part->info != NULL) {
            saved->id = part->info->id;
            saved->state = part->state;
            part->GetLocalPos(local);
            part->GetRotation(rot);
            saved->angle = ConvEditAngle(rot[1]);
            GetEditPos(pos, local);
            saved->pos[0] = fptosi(pos[0]);
            saved->pos[1] = fptosi(pos[1]);
            saved->pos[2] = fptosi(pos[2]);
            for (c = 0; c < EDIT_DATA_COLOR_MAX; c++) {
                if (part->GetColor(c, color) != 0) {
                    for (k = 0; k < 3; k++) {
                        value = fptosi(128.0f * color[k]);
                        if (value >= 0x100) {
                            value = 0xFF;
                        }
                        if (value < 0) {
                            value = 0;
                        }
                        saved->color[c][k] = value;
                    }
                }
            }
            if (part->house != NULL) {
                saved->house_no = (part->house - house) + 1;
            } else {
                saved->house_no = 0;
            }
            remap[i] = savedCount;
            savedCount++;
            saved++;
            if (savedCount >= data->parts_max) {
                printf(at_713__3);
                exit(0);
            }
        }
    }
    for (i = 0; i < logCount; i++) {
        if (log[i].parts_no >= 0) {
            log[i].parts_no = remap[log[i].parts_no];
        }
        if (log[i].base_no >= 0) {
            log[i].base_no = remap[log[i].base_no];
        }
    }
    for (i = 0; i < kEditGroupCount; i++) {
        data->house[i].npc_no = house[i].npc_no[0];
    }
    out = data->grid;
    memset(out, 0, kEditPlaceFlagCount);
    for (i = 0; i < grid_max; i++) {
        river = grid[i];
        if (river != NULL) {
            header = (EditDataGrid *)out;
            header->num_x = river->num_x;
            header->num_z = river->num_z;
            GetEditPos(gridPos, river->origin);
            gridY = fptosi(gridPos[1]);
            gridZ = fptosi(gridPos[2]);
            header->pos[0] = fptosi(gridPos[0]);
            header->pos[1] = gridY;
            header->pos[2] = gridZ;
            out += sizeof(EditDataGrid);
            for (x = 0; x < river->num_x; x++) {
                for (z = 0; z < river->num_z; z++) {
                    if (river->GetFast(x, z)->river != 0) {
                        *out |= 1;
                    }
                    out++;
                }
            }
            if ((int)out & 1) {
                out++;
            }
        }
    }
    if (out - data->grid >= kEditPlaceFlagCount) {
        printf(at_714__2);
        for (i = 0; i < 300; i++) {
            sceGsSyncV(0);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdata", SaveData__8CEditMapFP9CEditData);
#endif
#ifdef NONMATCHING
void CEditMap::LoadData(CEditData *data) {
    EditDataParts *saved;
    EditPlaceLog *log;
    int remap[kEditPartsCount];
    float placePos[4];
    float placeRot[4];
    float color[4];
    int logCount;
    int unnamed;
    int unused;
    int i;
    int j;
    int c;
    int changed;
    int no;
    CEditPartsInfo *info;
    CEditParts *part;
    CEditParts *placed;
    CEditParts *lower;
    CMapParts *model;
    CEditGrid *river;
    u8 *in;
    short *gridPos;
    int x;
    int z;

    logCount = 0;
    saved = data->parts;
    log = data->place_log;
    for (i = 0; i < place_log_max; i++) {
        place_log[i].parts_no = -1;
    }
    for (i = 0; i < kEditPlaceSlotCount; i++) {
        unused = log[i].parts_no < 0;
        if (!unused) {
            logCount++;
            place_log[logCount - 1].parts_no = log[i].parts_no;
            place_log[logCount - 1].base_no = log[i].base_no;
        }
    }
    for (i = 0; i < kEditPartsCount; i++) {
        remap[i] = -1;
    }
    for (i = 0; i < data->parts_max; i++, saved++) {
        if (saved->id != 0) {
            info = GetePartsInfoAtID(saved->id);
            if (info != NULL) {
                if (info->attr & 2) {
                    remap[i] = i;
                } else {
                    no = BuildEditParts(info->edit_name);
                    if (no >= 0) {
                        remap[i] = no;
                        if (saved->state != 0 && saved->state != 0) {
                            placePos[0] = (float)saved->pos[0];
                            placePos[1] = (float)saved->pos[1];
                            placePos[2] = (float)saved->pos[2];
                            placePos[3] = 1.0f;
                            placeRot[0] = 0.0f;
                            placeRot[1] = GetEditAngle(saved->angle);
                            placeRot[2] = 0.0f;
                            placed = GetePlaceParts(no);
                            if (placed != NULL && placed->GetPartsType() == 0xB) {
                                placed->state = EDIT_PARTS_STATE_RIVER;
                                placed->SetPosition(0.0f, -10000.0f, 0.0f);
                            } else {
                                model = PlaceEditParts(no, NULL, placePos, placeRot, NULL);
                                if (model != NULL) {
                                    part = (CEditParts *)model;
                                    if (saved->state == EDIT_PARTS_STATE_PLACED) {
                                        part->state = EDIT_PARTS_STATE_NONE;
                                    } else {
                                        part->state = saved->state;
                                    }
                                    if (saved->house_no > 0) {
                                        if (part->house != NULL) {
                                            memset(part->house, 0, sizeof(CEditHouse));
                                        }
                                        part->house = &house[saved->house_no - 1];
                                        part->house->active = 1;
                                    }
                                    for (c = 0; c < EDIT_DATA_COLOR_MAX; c++) {
                                        if (saved->color[c][0] > 0 && saved->color[c][1] > 0 &&
                                            saved->color[c][2] > 0) {
                                            color[0] = (float)saved->color[c][0] / 128.0f;
                                            color[1] = (float)saved->color[c][1] / 128.0f;
                                            color[2] = (float)saved->color[c][2] / 128.0f;
                                            color[3] = 128.0f;
                                            model->SetColor(c, color);
                                        }
                                    }
                                    model->UpdateColor();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    for (i = 0; i < kEditGroupCount; i++) {
        house[i].npc_no[0] = data->house[i].npc_no;
    }
    for (i = 0; i < logCount; i++) {
        if (place_log[i].parts_no >= 0) {
            place_log[i].parts_no = remap[place_log[i].parts_no];
        }
        if (place_log[i].base_no >= 0) {
            place_log[i].base_no = remap[place_log[i].base_no];
        }
    }
    do {
        changed = 0;
        for (i = 0; i < edit_parts_max; i++) {
            part = &edit_parts[i];
            unnamed = part->name[0] == 0;
            if (!unnamed && part->state == EDIT_PARTS_STATE_PLACED) {
                for (j = 0; j < logCount; j++) {
                    if (i == place_log[j].base_no) {
                        lower = GetePlaceParts(place_log[j].parts_no);
                        if (lower != NULL && lower->state == EDIT_PARTS_STATE_NONE) {
                            changed = 1;
                            lower->state = EDIT_PARTS_STATE_PLACED;
                            lower->ground = part->ground;
                        }
                    }
                }
            }
        }
        in = data->grid;
    } while (changed != 0);
    for (i = 0; i < grid_max; i++) {
        river = grid[i];
        if (river != NULL) {
            if (river->num_x == *in++) {
                if (river->num_z == *in++) {
                    gridPos = (short *)in;
                    printf(at_917__3, gridPos[0], gridPos[1], gridPos[2]);
                    in += sizeof(EditDataGrid) - 2;
                    for (x = 0; x < river->num_x; x++) {
                        for (z = 0; z < river->num_z; z++) {
                            if (*in & 1) {
                                river->SetRiver(x, z);
                            }
                            in++;
                        }
                    }
                    if ((int)in & 1) {
                        in++;
                    }
                    continue;
                }
            }
            return;
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdata", LoadData__8CEditMapFP9CEditData);
#endif
int GetCulturePoint(CEditParts *parts, int) {
    if (parts == 0 || parts->info == 0)
        return 0;
    return parts->info->cpoint[1];
}
#ifdef NONMATCHING
int CEditMap::CultureAnalyzeParts(int no, int cpoint_no) {
    int related[0x200];
    CEditParts *parts = GetePlaceParts(no);

    if (parts == NULL || parts->info == NULL) {
        return 0;
    }
    int empty = parts->name[0] == 0;
    if (empty || parts->state == 0) {
        return 0;
    }
    switch (parts->info->cpoint[0]) {
    case 6:
        return GetCulturePoint(parts, cpoint_no);
    case 1: {
        int total = GetCulturePoint(parts, cpoint_no);
        int count = GetTerritoryParts(no, related, 0x200);
        for (int i = 0; i < count; i++) {
            CEditParts *other = GetePlaceParts(related[i]);
            if (other != NULL && other->info != NULL && other->info->cpoint[0] == 2) {
                total += GetCulturePoint(other, cpoint_no);
            }
        }
        count = GetChildParts(no, related, 0x200);
        for (int i = 0; i < count; i++) {
            CEditParts *other = GetePlaceParts(related[i]);
            if (other != NULL && other->info != NULL) {
                int category = other->info->cpoint[0];
                if (category == 4 || category == 3) {
                    total += GetCulturePoint(other, cpoint_no);
                }
            }
        }
        return total;
    }
    default:
        return 0;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdata", CultureAnalyzeParts__8CEditMapFii);
#endif
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
#ifdef NONMATCHING
int CEditMap::GetOnOffParts(char *name, CMapParts **out_parts, CMapPiece **out_piece, int max) {
    int count;
    char part_name[0x40];
    char piece_name[0x40];

    if (name == NULL) {
        return 0;
    }
    count = 0;
    if (max <= 0) {
        return 0;
    }
    while (*name != 0) {
        if (count >= max) {
            return count;
        }
        char *part_cursor = part_name;
        part_name[0] = 0;
        char *piece_cursor = piece_name;
        piece_name[0] = 0;
        while (*name != '/' && *name != ';' && *name != 0) {
            *part_cursor = *name;
            name++;
            part_cursor++;
        }
        *part_cursor = 0;
        out_parts[count] = GetPlaceParts(part_name);
        out_piece[count] = NULL;
        if (*name == 0) {
            count++;
            return count;
        }
        if (*name != '/') {
            name++;
            count++;
            continue;
        }
        name++;
        while (*name != ';' && *name != 0) {
            *piece_cursor = *name;
            name++;
            piece_cursor++;
        }
        *piece_cursor = 0;
        if (out_parts[count] != NULL) {
            out_piece[count] = out_parts[count]->SearchPiece(piece_name);
        }
        if (*name == 0) {
            count++;
            return count;
        }
        name++;
        count++;
    }
    return count;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdata", GetOnOffParts__8CEditMapFPcPP9CMapPartsPP9CMapPiecei);
#endif
#ifdef NONMATCHING
void CEditMap::PartsOnOff(int map_no, CEditData *data) {
    CMapParts *parts[0x10];
    CMapPiece *pieces[0x10];
    int i;

    if (data == NULL) {
        return;
    }
    for (int data_no = 0; data_no < 0x10; data_no++) {
        EditAnalyzeDataSrc *request = data->GetAnalyzeData(map_no, data_no);
        if (request == NULL || request->message == 0) {
            continue;
        }
        int flag = data->GetAnalyzeFlag(map_no, data_no);
        int on_count = GetOnOffParts(request->on_parts, parts, pieces, 0x10);
        for (int i = 0; i < on_count; i++) {
            if (pieces[i] != NULL) {
                pieces[i]->Show(flag);
            } else if (parts[i] != NULL) {
                parts[i]->Show(flag);
            }
        }
        int off_count = GetOnOffParts(request->off_parts, parts, pieces, 0x10);
        for (i = 0; i < off_count; i++) {
            if (pieces[i] != NULL) {
                pieces[i]->Show((u8)((flag != 0) ^ 1));
            } else if (parts[i] != NULL) {
                parts[i]->Show((u8)((flag != 0) ^ 1));
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editdata", PartsOnOff__8CEditMapFiP9CEditData);
#endif
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

// Small uninitialised data (.sbss)
INCLUDE_BSS(init_1273, 0x4);
INCLUDE_BSS(eaAnaSrc, 0x4);
INCLUDE_BSS(eaAnaData, 0x4);
INCLUDE_BSS(eaStack, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(buff_1271, 0x3000);
INCLUDE_BSS(Stack_1272, 0x30);
