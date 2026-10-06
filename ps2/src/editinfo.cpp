#include "common.h"
#include "scriptinterpreter.hpp"
#include "mg_memory.hpp"
#include "editparts.hpp"
#include "editinfo.hpp"
#include "editmap.hpp"
#include "mg_math.hpp"
#include "menucommon.hpp"
#include <cstring>

extern CEditPartsInfo *emapNowInfo__2;
extern mgCMemory *emapStack__2;
struct EditMapRect {
    int type;
    int unk_04[3];
    float start[4];
    float end[4];
};

extern EditMapRect *emapRect__2;
extern int emapRectType;
extern int emapRectNum__2;
extern int emapRectIdx__2;

const int kPartsGround = 0x07;
const int kPartsBlock = 0x30;
const int kPartsRiver = 0x80;
const int kPartsFence = 0x130;

extern int emapMatID;
extern CEditInfoMngr *emapInfo__2;
extern int emapIdx__2;
extern int emapFixNum__2;
extern int emapFixIdx__2;
extern SPI_TAG_PARAM emap_tag__2[];

static inline u32 align16_blocks(u32 n) {
    if (n & 0xF) {
        return (n >> 4) + 1;
    }
    return n >> 4;
}

// Code (.text)
void CEditInfoMngr::Initialize(void) {
    parts_info_num = 0;
    parts_info = NULL;
    fix_parts_num = 0;
    fix_parts = NULL;
    init_parts_num = 0;
    init_parts = NULL;
}
void CEditInfoMngr::SetePartsInfoTable(CEditPartsInfo *table, int num) {
    parts_info_num = num;
    parts_info = table;
}
void CEditInfoMngr::SeteFixPartsTable(ePlaceData *table, int num) {
    fix_parts_num = num;
    fix_parts = table;
}
CEditPartsInfo *CEditInfoMngr::GetePartsInfo(int index) {
    if (index < 0 || index >= parts_info_num) {
        return NULL;
    }
    return parts_info + index;
}
CEditPartsInfo *CEditInfoMngr::GetePartsInfo(char *name) {
    int index = 0;
    CEditPartsInfo *part = parts_info;
    for (; index < parts_info_num; index++, part++) {
        if (part->edit_name != NULL && strcmp(part->edit_name, name) == 0) {
            return part;
        }
    }
    return NULL;
}
CEditPartsInfo *CEditInfoMngr::GetePartsInfoAtID(int id) {
    if (id < 0) {
        return NULL;
    }
    CEditPartsInfo *part = parts_info;
    if (part == NULL) {
        return NULL;
    }
    for (int index = 0; index < parts_info_num; index++, part++) {
        if (part->id == id) {
            return part;
        }
    }
    return NULL;
}
CEditPartsInfo *CEditInfoMngr::GetePartsInfoAtType(int type) {
    int index = 0;
    CEditPartsInfo *part = parts_info;
    for (; index < parts_info_num; index++, part++) {
        if (type == part->GetPartsType()) {
            return part;
        }
    }
    return NULL;
}
int emapEDIT_PARTS_NUM(SPI_STACK *stack, int argument_count) {
    int parts_count = spiGetStackInt(stack);
    if (parts_count <= 0) {
        return 0;
    }
    CEditPartsInfo *table = new (emapStack__2->Alloc(
        align16_blocks(parts_count * sizeof(CEditPartsInfo)) + 2)) CEditPartsInfo[parts_count];
    emapInfo__2->SetePartsInfoTable(table, parts_count);
    return 1;
}
int emapEDIT_PARTS(SPI_STACK *stack, int argument_count) {
    char converted_name[256];
    char *name;
    char *name_buffer;
    emapNowInfo__2 = emapInfo__2->GetePartsInfo(emapIdx__2++);
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    name = spiGetStackString(stack);
    ConvertFontCode(name, converted_name);
    name_buffer = (char *)emapStack__2->Alloc(align16_blocks(strlen(converted_name) + 1));
    if (name != NULL && name_buffer != NULL) {
        strcpy(name_buffer, converted_name);
        emapNowInfo__2->edit_name = name_buffer;
    }
    emapMatID = 0;
    return 1;
}
int emapID(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == 0)
        return 0;
    emapNowInfo__2->id = spiGetStackInt(stack);
    return 1;
}
int emapPARTS_NAME(SPI_STACK *stack, int argument_count) {
    char *text;
    int buffer;

    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    text = spiGetStackString(stack);
    buffer = (int)emapStack__2->Alloc(align16_blocks(strlen(text) + 1));
    if (text != 0) {
        if (buffer != 0) {
            strcpy((char *)buffer, text);
            emapNowInfo__2->parts_name = (char *)buffer;
        }
    }
    return 1;
}
int emapPARTS_ATR(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->attr |= spiGetStackInt(stack);
    return 1;
}
int emapPARTS_MATERIAL(SPI_STACK *stack, int argument_count) {
    int index;
    EditPartsMaterial *material;

    if ((emapNowInfo__2 == NULL) || (argument_count < 2)) {
        return 0;
    }
    index = emapMatID;
    emapMatID = index + 1;
    material = emapNowInfo__2->GetMaterial(index);
    if (material == NULL) {
        return 0;
    }
    material->item_no = spiGetStackInt(stack++);
    material->num = spiGetStackInt(stack);
    return 1;
}
int emapPARTS_COMMENT(SPI_STACK *stack, int argument_count) {
    char *text;
    int buffer;

    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    text = spiGetStackString(stack);
    buffer = (int)emapStack__2->Alloc(align16_blocks(strlen(text) + 1));
    if (text != 0) {
        if (buffer != 0) {
            strcpy((char *)buffer, text);
            emapNowInfo__2->comment = (char *)buffer;
        }
    }
    return 1;
}
int emapCPOINT(SPI_STACK *stack, int argument_count) {
    SPI_STACK *second;

    second = stack + 1;
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->cpoint[0] = spiGetStackInt(stack);
    emapNowInfo__2->cpoint[1] = spiGetStackInt(second);
    return 1;
}
int emapWEIGHT(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->weight = spiGetStackInt(stack);
    return 1;
}
int emapGEO_STONE(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->geo_stone = spiGetStackInt(stack);
    return 1;
}
int emapMAX_NUM(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->max_num = spiGetStackInt(stack);
    return 1;
}
int emapPAINT_NUM(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->paint_num = spiGetStackInt(stack);
    return 1;
}
int emapPAINT_USED(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->paint_used = spiGetStackInt(stack);
    return 1;
}
int emapPARTS_TYPE(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->parts_type = spiGetStackInt(stack);
    return 1;
}
int emapPLACE_EPS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->place_eps = spiGetStackFloat(stack);
    return 1;
}
int emapMAP_NO(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->map_no = spiGetStackInt(stack);
    return 1;
}
int emapPOLYN(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->polyn[0] = spiGetStackInt(stack++);
    if (argument_count >= 2) {
        emapNowInfo__2->polyn[1] = spiGetStackInt(stack++);
    }
    if (argument_count >= 3) {
        emapNowInfo__2->polyn[2] = spiGetStackInt(stack);
    }
    return 1;
}
int emapGROUND_PARTS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->attr = emapNowInfo__2->attr | kPartsGround;
    return 1;
}
int emapBLOCK_PARTS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->attr = emapNowInfo__2->attr | kPartsBlock;
    return 1;
}
int emapRIVER_PARTS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->attr = emapNowInfo__2->attr | kPartsRiver;
    return 1;
}
int emapFENCE_PARTS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }
    emapNowInfo__2->attr = emapNowInfo__2->attr | kPartsFence;
    return 1;
}
int emapRECT(SPI_STACK *stack, int argument_count) {
    if (emapRect__2 == NULL) {
        return 0;
    }
    if (emapRectIdx__2 < 0 || emapRectIdx__2 >= emapRectNum__2) {
        return 0;
    }
    EditMapRect *rect = &emapRect__2[emapRectIdx__2];
    rect->type = emapRectType;
    spiGetStackVector(rect->start, stack);
    rect->start[3] = 1.0f;
    spiGetStackVector(rect->end, stack + 3);
    rect->end[3] = 1.0f;
    emapRectIdx__2++;
    return 1;
}

int emapPLACE_RECT(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == 0) {
        return 0;
    }
    emapRectNum__2 = spiGetStackInt(stack);
    emapRectIdx__2 = 0;
    return 1;
}
int emapPLACE_RECT_END(SPI_STACK *, int) {
    emapRect__2 = 0;
    return 1;
}
int emapPARTS_RECT(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == 0) {
        return 0;
    }
    emapRectNum__2 = spiGetStackInt(stack);
    emapRectIdx__2 = 0;
    return 1;
}
int emapPARTS_RECT_END(SPI_STACK *, int) {
    emapRect__2 = 0;
    return 1;
}
int emapPUT_RECT(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == 0) {
        return 0;
    }
    emapRectNum__2 = spiGetStackInt(stack);
    emapRectIdx__2 = 0;
    return 1;
}
int emapPUT_RECT_END(SPI_STACK *, int) {
    emapRect__2 = 0;
    return 1;
}
int emapEDIT_PARTS_END(SPI_STACK *, int) {
    emapNowInfo__2 = 0;
    return 1;
}
void CEditInfoMngr::LoadEditInfo(char *script, int size, mgCMemory *memory) {
    emapInfo__2 = this;
    emapStack__2 = memory;
    emapIdx__2 = 0;
    emapNowInfo__2 = NULL;
    emapRect__2 = NULL;
    emapRectNum__2 = 0;
    emapRectIdx__2 = 0;
    emapFixNum__2 = 0;
    emapFixIdx__2 = 0;
    CScriptInterpreter interpreter;
    interpreter.SetTag(emap_tag__2);
    interpreter.SetScript(script, size);
    interpreter.Run();
}
CFuncPoint *CEditMap::GetEvent(float *position, int check_type, MapEventInfo *info) {
    if (info != NULL) {
        info->event_no = 0;
        mgUnitMatrix(info->matrix);
        info->point_no = -1;
        info->parts_no = -1;
    }
    CFuncPoint *point = CMap::GetEvent(position, check_type, info);
    if (point != NULL) {
        return point;
    }
    int index = 0;
    CEditParts *part = edit_parts;
    for (; index < edit_parts_max; index++, part++) {
        if (part->func_point_mngr.flag & FUNC_POINT_MNGR_EVENT) {
            int unnamed = part->name[0] == 0;
            if (unnamed == 0 && part->GetShow() != 0 &&
                part->state != EDIT_PARTS_STATE_NONE && part->info != NULL) {
                CFuncPointMngr *manager = &part->func_point_mngr;
                manager->GetStart(FUNC_POINT_EVENT);
                int accepted;
                CFuncPoint *point;
                if ((point = manager->Get()) != NULL) {
                    do {
                        point->frame.SetReference(&part->frame);
                        accepted = CheckFuncEvent(point, position, check_type, info, NULL);
                        point->frame.DeleteReference();
                        if (accepted != 0) {
                            info->parts_no = index;
                            return point;
                        }
                    } while ((point = manager->Get()) != NULL);
                }
            }
        }
    }
    return NULL;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", emap_tag__2__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_368__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_369__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_370__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_371__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_372__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_373__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_374__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_375__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_376__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_377__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_378__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_379__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_380__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_381__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_382__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_383__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_384__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_385__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_386__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_387__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_388__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_389__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_390__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_391__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_392__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_393__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_394__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_395__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/editinfo", at_396__2__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(emapInfo__2, 0x4);
INCLUDE_BSS(emapStack__2, 0x4);
INCLUDE_BSS(emapIdx__2, 0x4);
INCLUDE_BSS(emapMatID, 0x4);
INCLUDE_BSS(emapNowInfo__2, 0x4);
INCLUDE_BSS(emapRectType, 0x4);
INCLUDE_BSS(emapRect__2, 0x4);
INCLUDE_BSS(emapRectNum__2, 0x4);
INCLUDE_BSS(emapRectIdx__2, 0x4);
INCLUDE_BSS(emapFixNum__2, 0x4);
INCLUDE_BSS(emapFixIdx__2, 0x4);
