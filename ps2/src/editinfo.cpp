#include "common.h"

#include <cstring>

#include "editinfo.hpp"
#include "editmap.hpp"
#include "editparts.hpp"
#include "menucommon.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "scriptinterpreter.hpp"

/**
 *
 * Rectangle of the edit map with its part type and endpoint positions.
 *
 */
struct EditMapRect {
    int   type; /**< Part type assigned to the rectangle. */
    int   unk_04[3];
    float start[4]; /**< First endpoint. */
    float end[4];   /**< Second endpoint. */
};

/**
 * Manager filled by the edit information script.
 */
static CEditInfoMngr *emapInfo;

/**
 * Storage for the edit information tables and strings.
 */
static mgCMemory *emapStack;

/**
 * Index of the next edit part definition.
 */
static int emapIdx;

/**
 * Index of the next material in the current part definition.
 */
static int emapMatID;

/**
 * Part definition currently filled by the script.
 */
static CEditPartsInfo *emapNowInfo;

/**
 * Part type assigned to each rectangle record.
 */
static int emapRectType;

/**
 * Rectangle records currently filled by the script.
 */
static EditMapRect *emapRect;

/**
 * Number of records in the current rectangle list.
 */
static int emapRectNum;

/**
 * Index of the next rectangle record.
 */
static int emapRectIdx;

/**
 * Number of fixed part placements read by the script.
 */
static int emapFixNum;

/**
 * Index of the next fixed part placement.
 */
static int emapFixIdx;

/**
 *
 * Rounds a byte count up to a number of 16-byte allocation blocks.
 *
 */
static inline u32 align16_blocks(u32 n) {
    if (n & 0xF) {
        return (n >> 4) + 1;
    }

    return n >> 4;
}

// Code (.text)
void CEditInfoMngr::Initialize() {
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
    int             index = 0;
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
    int             index = 0;
    CEditPartsInfo *part = parts_info;

    for (; index < parts_info_num; index++, part++) {
        if (type == part->GetPartsType()) {
            return part;
        }
    }

    return NULL;
}

/**
 *
 * Allocates the edit part information table for a script.
 *
 */
static int emapEDIT_PARTS_NUM(SPI_STACK *stack, int argument_count) {
    int parts_count = spiGetStackInt(stack);

    if (parts_count <= 0) {
        return 0;
    }

    CEditPartsInfo *table = new (emapStack->Alloc(
        align16_blocks(parts_count * sizeof(CEditPartsInfo)) + 2)) CEditPartsInfo[parts_count];
    emapInfo->SetePartsInfoTable(table, parts_count);
    return 1;
}

/**
 *
 * Begins a named edit part information record.
 *
 */
static int emapEDIT_PARTS(SPI_STACK *stack, int argument_count) {
    char  converted_name[256];
    char *name;
    char *name_buffer;
    emapNowInfo = emapInfo->GetePartsInfo(emapIdx++);

    if (emapNowInfo == NULL) {
        return 0;
    }

    name = spiGetStackString(stack);
    ConvertFontCode(name, converted_name);
    name_buffer = reinterpret_cast<char *>(emapStack->Alloc(align16_blocks(strlen(converted_name) + 1)));

    if (name != NULL && name_buffer != NULL) {
        strcpy(name_buffer, converted_name);
        emapNowInfo->edit_name = name_buffer;
    }

    emapMatID = 0;
    return 1;
}

/**
 *
 * Sets the identifier of the current edit part.
 *
 */
static int emapID(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == 0) {
        return 0;
    }

    emapNowInfo->id = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the model part name of the current edit part.
 *
 */
static int emapPARTS_NAME(SPI_STACK *stack, int argument_count) {
    char *text;
    char *buffer;

    if (emapNowInfo == NULL) {
        return 0;
    }

    text = spiGetStackString(stack);
    buffer = (char *) emapStack->Alloc(align16_blocks(strlen(text) + 1));

    if (text != NULL) {
        if (buffer != NULL) {
            strcpy(buffer, text);
            emapNowInfo->parts_name = buffer;
        }
    }

    return 1;
}

/**
 *
 * Adds attribute flags to the current edit part.
 *
 */
static int emapPARTS_ATR(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->attr |= spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Adds an item and quantity to the current part material list.
 *
 */
static int emapPARTS_MATERIAL(SPI_STACK *stack, int argument_count) {
    int                index;
    EditPartsMaterial *material;

    if ((emapNowInfo == NULL) || (argument_count < 2)) {
        return 0;
    }

    index = emapMatID;
    emapMatID = index + 1;
    material = emapNowInfo->GetMaterial(index);

    if (material == NULL) {
        return 0;
    }

    material->item_no = spiGetStackInt(stack++);
    material->num = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the descriptive comment of the current edit part.
 *
 */
static int emapPARTS_COMMENT(SPI_STACK *stack, int argument_count) {
    char *text;
    char *buffer;

    if (emapNowInfo == NULL) {
        return 0;
    }

    text = spiGetStackString(stack);
    buffer = (char *) emapStack->Alloc(align16_blocks(strlen(text) + 1));

    if (text != NULL) {
        if (buffer != NULL) {
            strcpy(buffer, text);
            emapNowInfo->comment = buffer;
        }
    }

    return 1;
}

/**
 *
 * Sets the culture point values of the current edit part.
 *
 */
static int emapCPOINT(SPI_STACK *stack, int argument_count) {
    SPI_STACK *second;

    second = stack + 1;

    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->cpoint[0] = spiGetStackInt(stack);
    emapNowInfo->cpoint[1] = spiGetStackInt(second);
    return 1;
}

/**
 *
 * Sets the weight of the current edit part.
 *
 */
static int emapWEIGHT(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->weight = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the geostone requirement of the current edit part.
 *
 */
static int emapGEO_STONE(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->geo_stone = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the maximum placement count of the current edit part.
 *
 */
static int emapMAX_NUM(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->max_num = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the paint count of the current edit part.
 *
 */
static int emapPAINT_NUM(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->paint_num = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the paint use value of the current edit part.
 *
 */
static int emapPAINT_USED(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->paint_used = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the type of the current edit part.
 *
 */
static int emapPARTS_TYPE(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->parts_type = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the placement tolerance of the current edit part.
 *
 */
static int emapPLACE_EPS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->place_eps = spiGetStackFloat(stack);
    return 1;
}

/**
 *
 * Sets the map number of the current edit part.
 *
 */
static int emapMAP_NO(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->map_no = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets collision polygon limits for the current edit part.
 *
 */
static int emapPOLYN(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->polyn[0] = spiGetStackInt(stack++);

    if (argument_count >= 2) {
        emapNowInfo->polyn[1] = spiGetStackInt(stack++);
    }

    if (argument_count >= 3) {
        emapNowInfo->polyn[2] = spiGetStackInt(stack);
    }

    return 1;
}

/**
 *
 * Marks the current edit part as ground.
 *
 */
static int emapGROUND_PARTS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->attr = emapNowInfo->attr | EDIT_PARTS_ATR_GROUND;
    return 1;
}

/**
 *
 * Marks the current edit part as a block.
 *
 */
static int emapBLOCK_PARTS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->attr = emapNowInfo->attr | EDIT_PARTS_ATR_BLOCK;
    return 1;
}

/**
 *
 * Marks the current edit part as river terrain.
 *
 */
static int emapRIVER_PARTS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->attr = emapNowInfo->attr | EDIT_PARTS_ATR_RIVER;
    return 1;
}

/**
 *
 * Marks the current edit part as a fence.
 *
 */
static int emapFENCE_PARTS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == NULL) {
        return 0;
    }

    emapNowInfo->attr = emapNowInfo->attr | EDIT_PARTS_ATR_FENCE;
    return 1;
}

/**
 *
 * Adds a typed rectangular area to the current edit part.
 *
 */
static int emapRECT(SPI_STACK *stack, int argument_count) {
    if (emapRect == NULL) {
        return 0;
    }

    if (emapRectIdx < 0 || emapRectIdx >= emapRectNum) {
        return 0;
    }

    EditMapRect *rect = &emapRect[emapRectIdx];
    rect->type = emapRectType;
    spiGetStackVector(rect->start, stack);
    rect->start[3] = 1.0f;
    spiGetStackVector(rect->end, stack + 3);
    rect->end[3] = 1.0f;
    emapRectIdx++;
    return 1;
}

/**
 *
 * Begins the placement rectangle list of the current edit part.
 *
 */
static int emapPLACE_RECT(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == 0) {
        return 0;
    }

    emapRectNum = spiGetStackInt(stack);
    emapRectIdx = 0;
    return 1;
}

/**
 *
 * Ends the placement rectangle list.
 *
 */
static int emapPLACE_RECT_END(SPI_STACK *, int) {
    emapRect = 0;
    return 1;
}

/**
 *
 * Begins the part rectangle list of the current edit part.
 *
 */
static int emapPARTS_RECT(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == 0) {
        return 0;
    }

    emapRectNum = spiGetStackInt(stack);
    emapRectIdx = 0;
    return 1;
}

/**
 *
 * Ends the part rectangle list.
 *
 */
static int emapPARTS_RECT_END(SPI_STACK *, int) {
    emapRect = 0;
    return 1;
}

/**
 *
 * Begins the put rectangle list of the current edit part.
 *
 */
static int emapPUT_RECT(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo == 0) {
        return 0;
    }

    emapRectNum = spiGetStackInt(stack);
    emapRectIdx = 0;
    return 1;
}

/**
 *
 * Ends the put rectangle list.
 *
 */
static int emapPUT_RECT_END(SPI_STACK *, int) {
    emapRect = 0;
    return 1;
}

/**
 *
 * Ends the current edit part information record.
 *
 */
static int emapEDIT_PARTS_END(SPI_STACK *, int) {
    emapNowInfo = 0;
    return 1;
}

/**
 * Commands that fill the edit part information records.
 */
static SPI_TAG_PARAM emap_tag[] = {
    {"EDIT_PARTS_NUM", emapEDIT_PARTS_NUM},
    {"EDIT_PARTS",     emapEDIT_PARTS    },
    {"ID",             emapID            },
    {"PARTS_NAME",     emapPARTS_NAME    },
    {"PARTS_ATR",      emapPARTS_ATR     },
    {"PARTS_MATERIAL", emapPARTS_MATERIAL},
    {"PARTS_COMMENT",  emapPARTS_COMMENT },
    {"GROUND_PARTS",   emapGROUND_PARTS  },
    {"BLOCK_PARTS",    emapBLOCK_PARTS   },
    {"RIVER_PARTS",    emapRIVER_PARTS   },
    {"FENCE_PARTS",    emapFENCE_PARTS   },
    {"CPOINT",         emapCPOINT        },
    {"WEIGHT",         emapWEIGHT        },
    {"GEO_STONE",      emapGEO_STONE     },
    {"MAX_NUM",        emapMAX_NUM       },
    {"PAINT_NUM",      emapPAINT_NUM     },
    {"PAINT_USED",     emapPAINT_USED    },
    {"PARTS_TYPE",     emapPARTS_TYPE    },
    {"PLACE_EPS",      emapPLACE_EPS     },
    {"MAP_NO",         emapMAP_NO        },
    {"POLYN",          emapPOLYN         },
    {"RECT",           emapRECT          },
    {"PLACE_RECT",     emapPLACE_RECT    },
    {"PLACE_RECT_END", emapPLACE_RECT_END},
    {"PARTS_RECT",     emapPARTS_RECT    },
    {"PARTS_RECT_END", emapPARTS_RECT_END},
    {"PUT_RECT",       emapPUT_RECT      },
    {"PUT_RECT_END",   emapPUT_RECT_END  },
    {"EDIT_PARTS_END", emapEDIT_PARTS_END},
    {NULL,             NULL              },
};

void CEditInfoMngr::LoadEditInfo(char *script, int size, mgCMemory *memory) {
    emapInfo = this;
    emapStack = memory;
    emapIdx = 0;
    emapNowInfo = NULL;
    emapRect = NULL;
    emapRectNum = 0;
    emapRectIdx = 0;
    emapFixNum = 0;
    emapFixIdx = 0;
    CScriptInterpreter interpreter;
    interpreter.SetTag(emap_tag);
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

    int         index = 0;
    CEditParts *part = edit_parts;

    for (; index < edit_parts_max; index++, part++) {
        if (part->func_point_mngr.flag & FUNC_POINT_MNGR_EVENT) {
            int unnamed = part->name[0] == 0;

            if (unnamed == 0 && part->GetShow() != 0 &&
                part->state != EDIT_PARTS_STATE_NONE && part->info != NULL) {
                CFuncPointMngr *manager = &part->func_point_mngr;
                manager->GetStart(FUNC_POINT_EVENT);
                int         accepted;
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
