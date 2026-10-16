#include "character_metadata_bridge.hpp"

void PortCharacterMetadataBegin(CCharacter2 *character, mgCMemory *model, mgCMemory *motion,
                                mgCMemory *images, int block, CCharacter2 *parent, bool outline,
                                const char *skin_name) {
    nowChr = character;
    base_stack = now_stack = model;
    ext_stack = motion ? motion : model;
    img_stack = images ? images : model;
    set_imgblock = block;
    parent_chr = parent;
    outline_flag = outline;
    pack_file = nullptr;
    eff_pack_ptr = nullptr;
    eff_pack_size = 0;
    now_seq_ptr = nullptr;
    now_seqhd_ptr = nullptr;
    now_key_ptr = nullptr;
    now_se_header = nullptr;
    alloc_vertex_num = alloc_shadow_vertex_num = 0;
    now_cloth_id = now_motion_id = 0;
    outline_start = false;
    outline_start_tex = nullptr;
    root_skin_frame = skin_frame = nullptr;
    skin_name_ptr = const_cast<char *>(skin_name);
    load_img_ptr = nullptr;
    load_img_size = 0;
    for (int index = 0; index < CHARA_IMAGE_MAX; ++index) {
        img_ptr[index] = nullptr;
    }
}

bool PortCharacterMetadataApply(const char *command, SPI_STACK *arguments, int count, bool skin) {
    if (skin) {
        return false;
    }
    const SPI_TAG_PARAM native_tags[] = {
        {"V2",              _V2             },
        {"NAME",            _NAME           },
        {"BODY_SIZE",       _BODY_SIZE      },
        {"SCALE",           _SCALE          },
        {"MATERIAL_ANIME",  _MATERIAL_ANIME },
        {"POLY_NUM",        _POLY_NUM       },
        {"OBJECT_NAME",     _OBJECT_NAME    },
        {"OBJECT_NAME2",    _OBJECT_NAME2   },
        {"OUTLINE",         _OUTLINE        },
        {"VERTEX_ANIME",    _VERTEX_ANIME   },
        {"SHAPE_ANIME",     _SHAPE_ANIME    },
        {"KEY_START",       _KEY_START      },
        {"KEY",             _KEY            },
        {"KEY_END",         _KEY_END        },
        {"SEQ_START",       _SEQ_START      },
        {"SEQ",             _SEQ            },
        {"SEQ_END",         _SEQ_END        },
        {"CLOTH_START",     _CLOTH_START    },
        {"CLOTH_END",       _CLOTH_END      },
        {"POSITION",        _POSITION       },
        {"ROTATION",        _ROTATION       },
        {"SE_START",        _SE_START       },
        {"SE",              _SE             },
        {"SELP",            _SELP           },
        {"SE_END",          _SE_END         },
        {"MOTION_END",      _MOTION_END     },
        {"LOD_MODEL_START", _LOD_MODEL_START},
        {"LOD_MODEL_END",   _LOD_MODEL_END  },
        {nullptr,           nullptr         }
    };
    for (auto *entry = native_tags; entry->name && *entry->name; ++entry) {
        if (std::strcmp(command, entry->name) == 0) {
            if (entry->function) {
                entry->function(arguments, count);
            }
            return true;
        }
    }
    return false;
}

void PortCharacterMetadataMotionSlot(int slot) {
    now_motion_id = slot;
}

mgCreateVisualType *PortCharacterMetadataVisualTypes(bool skin) {
    static mgCreateVisualType types[64];
    int                       count = 0;
    if (skin) {
        for (int index = 0; index < nowChr->deform_frame_num; ++index) {
            if (!nowChr->deform_frame[index]) {
                continue;
            }
            types[count].name = nowChr->deform_frame[index]->name;
            types[count++].type = nowChr->shape_anime ? MG_VISUAL_CREATE_MDT : MG_VISUAL_CREATE_MOTION_MDT;
        }
    } else {
        for (int index = 0; index < alloc_vertex_num; ++index) {
            types[count].name = alloc_vertex[index];
            types[count++].type = nowChr->shape_anime ? MG_VISUAL_CREATE_MDT : MG_VISUAL_CREATE_MOTION_MDT;
        }
    }
    types[count].name = nullptr;
    types[count].type = MG_VISUAL_CREATE_END;
    return types;
}

void PortCharacterMetadataModel(mgCFrame *model) {
    nowChr->CObjectFrame::frame = model;
    nowChr->deform_frame_num = 0;
    for (int index = 0; model && index < alloc_vertex_num; ++index) {
        if (auto *frame = model->SearchFrame(alloc_vertex[index])) {
            nowChr->deform_frame[nowChr->deform_frame_num++] = frame;
        }
    }
}

int PortCharacterMetadataNextCloth() {
    if (now_cloth_id >= nowChr->dynamic_anime_num) {
        return -1;
    }
    return now_cloth_id++;
}
