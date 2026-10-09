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
static CEditInfoMngr *emapInfo__2;

/**
 * Storage for the edit information tables and strings.
 */
static mgCMemory *emapStack__2;

/**
 * Index of the next edit part definition.
 */
static int emapIdx__2;

/**
 * Index of the next material in the current part definition.
 */
static int emapMatID;

/**
 * Part definition currently filled by the script.
 */
static CEditPartsInfo *emapNowInfo__2;

/**
 * Part type assigned to each rectangle record.
 */
static int emapRectType;

/**
 * Rectangle records currently filled by the script.
 */
static EditMapRect *emapRect__2;

/**
 * Number of records in the current rectangle list.
 */
static int emapRectNum__2;

/**
 * Index of the next rectangle record.
 */
static int emapRectIdx__2;

/**
 * Number of fixed part placements read by the script.
 */
static int emapFixNum__2;

/**
 * Index of the next fixed part placement.
 */
static int emapFixIdx__2;

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

    CEditPartsInfo *table = new (emapStack__2->Alloc(
        align16_blocks(parts_count * sizeof(CEditPartsInfo)) + 2)) CEditPartsInfo[parts_count];
    emapInfo__2->SetePartsInfoTable(table, parts_count);
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
    emapNowInfo__2 = emapInfo__2->GetePartsInfo(emapIdx__2++);

    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    name = spiGetStackString(stack);
    ConvertFontCode(name, converted_name);
    name_buffer = reinterpret_cast<char *>(emapStack__2->Alloc(align16_blocks(strlen(converted_name) + 1)));

    if (name != NULL && name_buffer != NULL) {
        strcpy(name_buffer, converted_name);
        emapNowInfo__2->edit_name = name_buffer;
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
    if (emapNowInfo__2 == 0) {
        return 0;
    }

    emapNowInfo__2->id = spiGetStackInt(stack);
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

    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    text = spiGetStackString(stack);
    buffer = (char *) emapStack__2->Alloc(align16_blocks(strlen(text) + 1));

    if (text != NULL) {
        if (buffer != NULL) {
            strcpy(buffer, text);
            emapNowInfo__2->parts_name = buffer;
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
    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->attr |= spiGetStackInt(stack);
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

/**
 *
 * Sets the descriptive comment of the current edit part.
 *
 */
static int emapPARTS_COMMENT(SPI_STACK *stack, int argument_count) {
    char *text;
    char *buffer;

    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    text = spiGetStackString(stack);
    buffer = (char *) emapStack__2->Alloc(align16_blocks(strlen(text) + 1));

    if (text != NULL) {
        if (buffer != NULL) {
            strcpy(buffer, text);
            emapNowInfo__2->comment = buffer;
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

    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->cpoint[0] = spiGetStackInt(stack);
    emapNowInfo__2->cpoint[1] = spiGetStackInt(second);
    return 1;
}

/**
 *
 * Sets the weight of the current edit part.
 *
 */
static int emapWEIGHT(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->weight = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the geostone requirement of the current edit part.
 *
 */
static int emapGEO_STONE(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->geo_stone = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the maximum placement count of the current edit part.
 *
 */
static int emapMAX_NUM(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->max_num = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the paint count of the current edit part.
 *
 */
static int emapPAINT_NUM(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->paint_num = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the paint use value of the current edit part.
 *
 */
static int emapPAINT_USED(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->paint_used = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the type of the current edit part.
 *
 */
static int emapPARTS_TYPE(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->parts_type = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the placement tolerance of the current edit part.
 *
 */
static int emapPLACE_EPS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->place_eps = spiGetStackFloat(stack);
    return 1;
}

/**
 *
 * Sets the map number of the current edit part.
 *
 */
static int emapMAP_NO(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->map_no = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Sets collision polygon limits for the current edit part.
 *
 */
static int emapPOLYN(SPI_STACK *stack, int argument_count) {
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

/**
 *
 * Marks the current edit part as ground.
 *
 */
static int emapGROUND_PARTS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->attr = emapNowInfo__2->attr | EDIT_PARTS_ATR_GROUND;
    return 1;
}

/**
 *
 * Marks the current edit part as a block.
 *
 */
static int emapBLOCK_PARTS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->attr = emapNowInfo__2->attr | EDIT_PARTS_ATR_BLOCK;
    return 1;
}

/**
 *
 * Marks the current edit part as river terrain.
 *
 */
static int emapRIVER_PARTS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->attr = emapNowInfo__2->attr | EDIT_PARTS_ATR_RIVER;
    return 1;
}

/**
 *
 * Marks the current edit part as a fence.
 *
 */
static int emapFENCE_PARTS(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == NULL) {
        return 0;
    }

    emapNowInfo__2->attr = emapNowInfo__2->attr | EDIT_PARTS_ATR_FENCE;
    return 1;
}

/**
 *
 * Adds a typed rectangular area to the current edit part.
 *
 */
static int emapRECT(SPI_STACK *stack, int argument_count) {
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

/**
 *
 * Begins the placement rectangle list of the current edit part.
 *
 */
static int emapPLACE_RECT(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == 0) {
        return 0;
    }

    emapRectNum__2 = spiGetStackInt(stack);
    emapRectIdx__2 = 0;
    return 1;
}

/**
 *
 * Ends the placement rectangle list.
 *
 */
static int emapPLACE_RECT_END(SPI_STACK *, int) {
    emapRect__2 = 0;
    return 1;
}

/**
 *
 * Begins the part rectangle list of the current edit part.
 *
 */
static int emapPARTS_RECT(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == 0) {
        return 0;
    }

    emapRectNum__2 = spiGetStackInt(stack);
    emapRectIdx__2 = 0;
    return 1;
}

/**
 *
 * Ends the part rectangle list.
 *
 */
static int emapPARTS_RECT_END(SPI_STACK *, int) {
    emapRect__2 = 0;
    return 1;
}

/**
 *
 * Begins the put rectangle list of the current edit part.
 *
 */
static int emapPUT_RECT(SPI_STACK *stack, int argument_count) {
    if (emapNowInfo__2 == 0) {
        return 0;
    }

    emapRectNum__2 = spiGetStackInt(stack);
    emapRectIdx__2 = 0;
    return 1;
}

/**
 *
 * Ends the put rectangle list.
 *
 */
static int emapPUT_RECT_END(SPI_STACK *, int) {
    emapRect__2 = 0;
    return 1;
}

/**
 *
 * Ends the current edit part information record.
 *
 */
static int emapEDIT_PARTS_END(SPI_STACK *, int) {
    emapNowInfo__2 = 0;
    return 1;
}

/**
 * Commands that fill the edit part information records.
 */
static SPI_TAG_PARAM emap_tag__2[] = {
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
