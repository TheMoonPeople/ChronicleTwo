#include "common.h"
#include "scriptinterpreter.hpp"
#include "mg_memory.hpp"
#include "editparts.hpp"
#include "editinfo.hpp"
#include <cstring>

extern CEditPartsInfo *emapNowInfo__2;
extern mgCMemory *emapStack__2;
extern void *emapRect__2;
extern int emapRectNum__2;
extern int emapRectIdx__2;

const int kPartsGround = 0x07;
const int kPartsBlock = 0x30;
const int kPartsRiver = 0x80;
const int kPartsFence = 0x130;

extern int emapMatID;

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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editinfo", GetePartsInfo__13CEditInfoMngrFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editinfo", GetePartsInfo__13CEditInfoMngrFPc);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editinfo", GetePartsInfoAtID__13CEditInfoMngrFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editinfo", GetePartsInfoAtType__13CEditInfoMngrFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editinfo", emapEDIT_PARTS_NUM__FP9SPI_STACKi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editinfo", emapEDIT_PARTS__FP9SPI_STACKi);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editinfo", emapPARTS_ATR__FP9SPI_STACKi);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editinfo", emapRECT__FP9SPI_STACKi);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editinfo", LoadEditInfo__13CEditInfoMngrFPciP9mgCMemory);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/editinfo", GetEvent__8CEditMapFPfiP12MapEventInfo);

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
