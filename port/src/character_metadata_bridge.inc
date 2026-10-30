#include "character_metadata_bridge.hpp"

namespace {
/**
 *
 * Gives one character parse an empty set of scratch builders and resource selections.
 *
 */
void InitializeMetadata(CCharacter2 *character, mgCMemory *model, int block, CCharacter2 *parent, bool outline) {
    nowChr = character;
    base_stack = now_stack = model;
    set_imgblock = block;
    parent_chr = parent;
    outline_flag = outline;
    sequence_entries.reset();
    now_seqhd_ptr = nullptr;
    key_entries.reset();
    now_se_header = nullptr;
    sound_entries_remaining = 0;
    alloc_vertex_num = 0;
    now_cloth_id = now_motion_id = 0;
    outline_start = false;
    outline_start_tex = nullptr;
    std::ranges::fill(std::as_writable_bytes(std::span(alloc_vertex)), std::byte{});
    metadata_visual_types.fill({});
}

} // namespace

namespace dc2::character {
/**
 *
 * Preserves all mutable metadata scratch storage while an inner parse owns the globals.
 *
 */
struct MetadataScope::State {
    CloneAuxBuilder                     clone_inputs;                                                 /**< Explicit allocation capabilities owned by this parse. */
    std::string                         skin_name;                                                    /**< Stable owned input text for the active skin parse. */
    bool                                has_skin_name;                                                /**< Whether this context supplied a skin selector. */
    State                              *previous_active = MetadataScope::active;                      /**< Enclosing lexical metadata owner. */
    decltype(::nowChr)                  previous_character = ::nowChr;                                /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::base_stack)              previous_base_stack = ::base_stack;                           /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::set_imgblock)            previous_set_imgblock = ::set_imgblock;                       /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::now_stack)               previous_now_stack = ::now_stack;                             /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::now_seqhd_ptr)           previous_now_seqhd_ptr = ::now_seqhd_ptr;                     /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::alloc_vertex_num)        previous_alloc_vertex_num = ::alloc_vertex_num;               /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::outline_flag)            previous_outline_flag = ::outline_flag;                       /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::parent_chr)              previous_parent_chr = ::parent_chr;                           /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::outline_start)           previous_outline_start = ::outline_start;                     /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::outline_start_tex)       previous_outline_start_tex = ::outline_start_tex;             /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::now_cloth_id)            previous_now_cloth_id = ::now_cloth_id;                       /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::now_motion_id)           previous_now_motion_id = ::now_motion_id;                     /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::now_se_header)           previous_now_se_header = ::now_se_header;                     /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::sound_entries_remaining) previous_sound_entries_remaining = ::sound_entries_remaining; /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::sequence_entries)        previous_sequences = std::move(::sequence_entries);           /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::key_entries)             previous_keys = std::move(::key_entries);                     /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::alloc_vertex)            previous_vertices{};                                          /**< Enclosing metadata value restored when this parse finishes. */
    decltype(::metadata_visual_types)   previous_visual_types = ::metadata_visual_types;              /**< Enclosing metadata value restored when this parse finishes. */

    /**
     *
     * Saves the enclosing builders after copying the new skin selector.
     *
     */
    explicit State(std::string_view value, std::shared_ptr<const CloneAuxState> inherited) : clone_inputs(std::move(inherited)), skin_name(value), has_skin_name(value.data() != nullptr) {
        std::memcpy(previous_vertices, ::alloc_vertex, sizeof(previous_vertices));
    }

    /**
     *
     * Restores every enclosing pointer, counter, name table and owned builder.
     *
     */
    ~State() {
        MetadataScope::active = previous_active;
        ::nowChr = previous_character;
        ::base_stack = previous_base_stack;
        ::set_imgblock = previous_set_imgblock;
        ::now_stack = previous_now_stack;
        ::now_seqhd_ptr = previous_now_seqhd_ptr;
        ::alloc_vertex_num = previous_alloc_vertex_num;
        ::outline_flag = previous_outline_flag;
        ::parent_chr = previous_parent_chr;
        ::outline_start = previous_outline_start;
        ::outline_start_tex = previous_outline_start_tex;
        ::now_cloth_id = previous_now_cloth_id;
        ::now_motion_id = previous_now_motion_id;
        ::now_se_header = previous_now_se_header;
        ::sound_entries_remaining = previous_sound_entries_remaining;
        ::sequence_entries = std::move(previous_sequences);
        ::key_entries = std::move(previous_keys);
        std::memcpy(::alloc_vertex, previous_vertices, sizeof(previous_vertices));
        ::metadata_visual_types = previous_visual_types;
    }
};

MetadataScope::MetadataScope(CCharacter2 *character, mgCMemory *model, int block, CCharacter2 *parent, bool outline,
                             std::string_view skin_name, std::shared_ptr<const CloneAuxState> inherited_clone_inputs)
    : state(std::make_unique<State>(skin_name, std::move(inherited_clone_inputs))) {
    active = state.get();
    InitializeMetadata(character, model, block, parent, outline);
}

MetadataScope::State *MetadataScope::active = nullptr;

MetadataScope::~MetadataScope() = default;

bool MetadataScope::RegisterSounds(mgCMemory &producer, int slot, std::span<CHRINFO_SE> allocation) {
    return active != nullptr && active->clone_inputs.RegisterSounds(producer, slot, allocation);
}

bool MetadataScope::FinishCloneInputs(ResourceState &resources, mgCMemory &model) {
    if (!state->clone_inputs.CaptureFrames(*nowChr, model)) {
        return false;
    }
    resources.clone_inputs = state->clone_inputs.Finish(*nowChr);
    return resources.clone_inputs != nullptr;
}

std::optional<std::string_view> MetadataScope::ActiveSkinName() {
    if (active == nullptr || !active->has_skin_name) {
        return std::nullopt;
    }
    return active->skin_name;
}
} // namespace dc2::character

bool PortCharacterMetadataApply(const char *command, dc2::script::TagArguments arguments, int count, bool skin) {
    if (skin || nowChr == nullptr || command == nullptr) {
        return false;
    }

    struct MetadataTag {
        const char *name;
        int (*function)(dc2::script::TagArguments, int);
    };

    const MetadataTag native_tags[] = {
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
                dc2::script::InvokeTagFunction(entry->function, arguments, count);
            }
            return true;
        }
    }
    return false;
}

void PortCharacterMetadataMotionSlot(int slot) {
    if (nowChr != nullptr && slot >= 0 && slot < CHARA_MOTION_SET_MAX) {
        now_motion_id = slot;
    }
}

mgCreateVisualType *PortCharacterMetadataVisualTypes(bool skin) {
    if (nowChr == nullptr) {
        return nullptr;
    }
    auto &types = metadata_visual_types;
    int   count = 0;
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
    return types.data();
}

void PortCharacterMetadataModel(mgCFrame *model) {
    if (nowChr == nullptr) {
        return;
    }
    nowChr->CObjectFrame::frame = model;
    nowChr->deform_frame_num = 0;
    for (int index = 0; model && index < alloc_vertex_num; ++index) {
        if (auto *frame = model->SearchFrame(alloc_vertex[index])) {
            nowChr->deform_frame[nowChr->deform_frame_num++] = frame;
        }
    }
}

int PortCharacterMetadataNextCloth() {
    if (nowChr == nullptr || now_cloth_id >= nowChr->dynamic_anime_num) {
        return -1;
    }
    return now_cloth_id++;
}
