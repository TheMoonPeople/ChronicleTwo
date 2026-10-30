#include "common.h"

#include <cstring>
#include <string>

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

void CEditInfoMngr::Initialize() {
    parts_info_num = 0;
    parts_info = nullptr;
    fix_parts_num = 0;
    fix_parts = nullptr;
    init_parts_num = 0;
    init_parts = nullptr;
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
        return nullptr;
    }

    return parts_info + index;
}

CEditPartsInfo *CEditInfoMngr::GetePartsInfo(char *name) {
    int             index = 0;
    CEditPartsInfo *part = parts_info;

    for (; index < parts_info_num; index++, part++) {
        if (part->edit_name != nullptr && strcmp(part->edit_name, name) == 0) {
            return part;
        }
    }

    return nullptr;
}

CEditPartsInfo *CEditInfoMngr::GetePartsInfoAtID(int id) {
    if (id < 0) {
        return nullptr;
    }

    CEditPartsInfo *part = parts_info;

    if (part == nullptr) {
        return nullptr;
    }

    for (int index = 0; index < parts_info_num; index++, part++) {
        if (part->id == id) {
            return part;
        }
    }

    return nullptr;
}

CEditPartsInfo *CEditInfoMngr::GetePartsInfoAtType(int type) {
    int             index = 0;
    CEditPartsInfo *part = parts_info;

    for (; index < parts_info_num; index++, part++) {
        if (type == part->GetPartsType()) {
            return part;
        }
    }

    return nullptr;
}

/**
 *
 * Allocates the edit part information table for a script.
 *
 */
static int emapEDIT_PARTS_NUM(dc2::script::TagArguments stack, int argument_count) {
    const int count = dc2::script::TagInteger(stack);
    if (emapInfo == nullptr || emapStack == nullptr || count <= 0) {
        return 0;
    }
    auto *table = dc2::memory::NewArray<CEditPartsInfo>(*emapStack, static_cast<std::size_t>(count));
    if (table == nullptr) {
        return 0;
    }
    emapInfo->SetePartsInfoTable(table, count);
    return 1;
}

/**
 *
 * Begins a named edit part information record.
 *
 */
static int emapEDIT_PARTS(dc2::script::TagArguments stack, int argument_count) {
    std::string name(dc2::script::TagText(stack));
    ConvertFontCode(name.data(), name.data());
    if (emapInfo == nullptr || emapStack == nullptr) {
        return 0;
    }
    auto *entry = emapInfo->GetePartsInfo(emapIdx);
    if (entry == nullptr) {
        return 0;
    }
    char *stored_name = mgCopyString(name.data(), emapStack);
    if (stored_name == nullptr) {
        return 0;
    }
    ++emapIdx;
    emapNowInfo = entry;
    entry->edit_name = stored_name;
    emapMatID = 0;
    return 1;
}

/**
 *
 * Sets the identifier of the current edit part.
 *
 */
static int emapID(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapNowInfo->id = dc2::script::TagInteger(stack);
    return 1;
}

/**
 *
 * Sets the model part name of the current edit part.
 *
 */
static int emapPARTS_NAME(dc2::script::TagArguments stack, int argument_count) {
    char *text = dc2::script::TagCString(stack);
    if (emapNowInfo == nullptr || emapStack == nullptr) {
        return 0;
    }
    char *stored = mgCopyString(text, emapStack);
    if (stored == nullptr) {
        return 0;
    }
    emapNowInfo->parts_name = stored;
    return 1;
}

/**
 *
 * Adds attribute flags to the current edit part.
 *
 */
static int emapPARTS_ATR(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapNowInfo->attr |= dc2::script::TagInteger(stack);
    return 1;
}

/**
 *
 * Adds an item and quantity to the current part material list.
 *
 */
static int emapPARTS_MATERIAL(dc2::script::TagArguments stack, int argument_count) {
    int                index = {};
    EditPartsMaterial *material = {};

    if ((emapNowInfo == nullptr) || (argument_count < 2)) {
        return 0;
    }

    index = emapMatID;
    emapMatID = index + 1;
    material = emapNowInfo->GetMaterial(index);

    if (material == nullptr) {
        return 0;
    }

    material->item_no = dc2::script::TagInteger(stack++);
    material->num = dc2::script::TagInteger(stack);
    return 1;
}

/**
 *
 * Sets the descriptive comment of the current edit part.
 *
 */
static int emapPARTS_COMMENT(dc2::script::TagArguments stack, int argument_count) {
    char *text = dc2::script::TagCString(stack);
    if (emapNowInfo == nullptr || emapStack == nullptr) {
        return 0;
    }
    char *stored = mgCopyString(text, emapStack);
    if (stored == nullptr) {
        return 0;
    }
    emapNowInfo->comment = stored;
    return 1;
}

/**
 *
 * Sets the culture point values of the current edit part.
 *
 */
static int emapCPOINT(dc2::script::TagArguments stack, int argument_count) {
    const auto second = stack + 1;

    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapNowInfo->cpoint[0] = dc2::script::TagInteger(stack);
    emapNowInfo->cpoint[1] = dc2::script::TagInteger(second);
    return 1;
}

/**
 *
 * Sets the weight of the current edit part.
 *
 */
static int emapWEIGHT(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapNowInfo->weight = dc2::script::TagInteger(stack);
    return 1;
}

/**
 *
 * Sets the geostone requirement of the current edit part.
 *
 */
static int emapGEO_STONE(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapNowInfo->geo_stone = dc2::script::TagInteger(stack);
    return 1;
}

/**
 *
 * Sets the maximum placement count of the current edit part.
 *
 */
static int emapMAX_NUM(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapNowInfo->max_num = 9999;
    return 1;
}

/**
 *
 * Sets the paint count of the current edit part.
 *
 */
static int emapPAINT_NUM(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapNowInfo->paint_num = dc2::script::TagInteger(stack);
    return 1;
}

/**
 *
 * Sets the paint use value of the current edit part.
 *
 */
static int emapPAINT_USED(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapNowInfo->paint_used = dc2::script::TagInteger(stack);
    return 1;
}

/**
 *
 * Sets the type of the current edit part.
 *
 */
static int emapPARTS_TYPE(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapNowInfo->parts_type = dc2::script::TagInteger(stack);
    return 1;
}

/**
 *
 * Sets the placement tolerance of the current edit part.
 *
 */
static int emapPLACE_EPS(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapNowInfo->place_eps = dc2::script::TagFloat(stack);
    return 1;
}

/**
 *
 * Sets the map number of the current edit part.
 *
 */
static int emapMAP_NO(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapNowInfo->map_no = dc2::script::TagInteger(stack);
    return 1;
}

/**
 *
 * Sets collision polygon limits for the current edit part.
 *
 */
static int emapPOLYN(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapNowInfo->polyn[0] = dc2::script::TagInteger(stack++);

    if (argument_count >= 2) {
        emapNowInfo->polyn[1] = dc2::script::TagInteger(stack++);
    }

    if (argument_count >= 3) {
        emapNowInfo->polyn[2] = dc2::script::TagInteger(stack);
    }

    return 1;
}

/**
 *
 * Marks the current edit part as ground.
 *
 */
static int emapGROUND_PARTS(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
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
static int emapBLOCK_PARTS(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
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
static int emapRIVER_PARTS(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
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
static int emapFENCE_PARTS(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
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
static int emapRECT(dc2::script::TagArguments stack, int argument_count) {
    if (emapRect == nullptr) {
        return 0;
    }

    if (emapRectIdx < 0 || emapRectIdx >= emapRectNum) {
        return 0;
    }

    EditMapRect *rect = &emapRect[emapRectIdx];
    rect->type = emapRectType;
    dc2::script::TagVector(rect->start, stack);
    rect->start[3] = 1.0f;
    dc2::script::TagVector(rect->end, stack + 3);
    rect->end[3] = 1.0f;
    emapRectIdx++;
    return 1;
}

/**
 *
 * Begins the placement rectangle list of the current edit part.
 *
 */
static int emapPLACE_RECT(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapRectNum = dc2::script::TagInteger(stack);
    emapRectIdx = 0;
    return 1;
}

/**
 *
 * Ends the placement rectangle list.
 *
 */
static int emapPLACE_RECT_END(dc2::script::TagArguments, int) {
    emapRect = nullptr;
    return 1;
}

/**
 *
 * Begins the part rectangle list of the current edit part.
 *
 */
static int emapPARTS_RECT(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapRectNum = dc2::script::TagInteger(stack);
    emapRectIdx = 0;
    return 1;
}

/**
 *
 * Ends the part rectangle list.
 *
 */
static int emapPARTS_RECT_END(dc2::script::TagArguments, int) {
    emapRect = nullptr;
    return 1;
}

/**
 *
 * Begins the put rectangle list of the current edit part.
 *
 */
static int emapPUT_RECT(dc2::script::TagArguments stack, int argument_count) {
    if (emapNowInfo == nullptr) {
        return 0;
    }

    emapRectNum = dc2::script::TagInteger(stack);
    emapRectIdx = 0;
    return 1;
}

/**
 *
 * Ends the put rectangle list.
 *
 */
static int emapPUT_RECT_END(dc2::script::TagArguments, int) {
    emapRect = nullptr;
    return 1;
}

/**
 *
 * Ends the current edit part information record.
 *
 */
static int emapEDIT_PARTS_END(dc2::script::TagArguments, int) {
    emapNowInfo = nullptr;
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
    {nullptr,          nullptr           },
};

void CEditInfoMngr::LoadEditInfo(char *script, int size, mgCMemory *memory) {
    emapInfo = this;
    emapStack = memory;
    emapIdx = 0;
    emapNowInfo = nullptr;
    emapRect = nullptr;
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
    if (info != nullptr) {
        info->event_no = 0;
        mgUnitMatrix(info->matrix);
        info->point_no = -1;
        info->parts_no = -1;
    }

    CFuncPoint *point = CMap::GetEvent(position, check_type, info);

    if (point != nullptr) {
        return point;
    }

    int         index = 0;
    CEditParts *part = edit_parts;

    for (; index < edit_parts_max; index++, part++) {
        if (part->func_point_mngr.flag & FUNC_POINT_MNGR_EVENT) {
            int unnamed = part->name[0] == 0;

            if (unnamed == 0 && part->GetShow() != 0 &&
                part->state != EDIT_PARTS_STATE_NONE && part->info != nullptr) {
                CFuncPointMngr *manager = &part->func_point_mngr;
                manager->GetStart(FUNC_POINT_EVENT);
                int         accepted = {};
                CFuncPoint *point = {};

                if ((point = manager->Get()) != nullptr) {
                    do {
                        point->frame.SetReference(&part->frame);
                        accepted = CheckFuncEvent(point, position, check_type, info, nullptr);
                        point->frame.DeleteReference();

                        if (accepted != 0) {
                            info->parts_no = index;
                            return point;
                        }
                    } while ((point = manager->Get()) != nullptr);
                }
            }
        }
    }

    return nullptr;
}
