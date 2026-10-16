#include "common.h"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <limits>
#include <optional>
#include <span>
#include <string>
#include <vector>

#include "asset_directory.hpp"
#include "character.hpp"
#include "dataread_port.hpp"
#include "effscript.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "platform/datapacks.hpp"
#include "platform/model_assets.hpp"
#include "script_timing.hpp"

int SetEffectScript(CRunScript *script, char *program, mgCMemory *memory);

namespace {
constexpr int Quadwords(std::size_t bytes) {
    return static_cast<int>((bytes + 15) / 16);
}
} // namespace

PORT_OVERRIDE int CEffectScriptMan::AssignCharacter(_EFF_SCRIPT *script, int count) {
    if (count < 0 || count > EFF_SPT_SUB_CHARA_MAX || script == nullptr ||
        script->chara == nullptr || work_memory == nullptr) {
        return 0;
    }
    const int object_size = Quadwords(sizeof(CCharacter2));
    // The allocator selects a gap before placement new can grow an allocation.
    // Budget native objects up front, with room for final 64-byte alignment and
    // the allocator's strict end-of-stack capacity check.
    const long long required = count * (static_cast<long long>(object_size) +
                                        std::max(0, script->chara->GetCopySize())) +
                               4;
    if (required > std::numeric_limits<int>::max()) {
        std::printf("------- es work max!! (assign character[%lld]) ---------\n", required);
        return 0;
    }
    u_long128 *token = work_memory->StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(required));
    if (token == nullptr) {
        std::printf("------- es work max!! (assign character[%lld]) ---------\n", required);
        return 0;
    }
    for (int i = 0; i < count; ++i) {
        script->sub_chara[i] = new (work_memory->Alloc(object_size)) CCharacter2;
        script->chara->Copy(*script->sub_chara[i], work_memory);
    }
    script->sub_chara_work = token;
    work_memory->stAlign64();
    work_memory->EndStackMode();
    return 1;
}

PORT_OVERRIDE _EFF_SCRIPT *CEffectScriptMan::CreateEffSpt(int base_no, int group, int register_in_group) {
    if (base_num <= 0) {
        std::printf("--- effect script (non base)!!! ---\n");
        return nullptr;
    }
    EFF_SPT_BASE *definition = nullptr;
    for (auto *candidate : base) {
        if (candidate != nullptr && candidate->base_no == base_no) {
            definition = candidate;
            break;
        }
    }
    if (definition == nullptr || work_memory == nullptr) {
        now = nullptr;
        std::printf("--- effect script (missing base or work stack)!!! ---\n");
        return nullptr;
    }

    int owner_slot = -1;
    if (register_in_group == 1) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX) {
            return nullptr;
        }
        for (int i = 0; i < EFF_SPT_OWNER_SLOT_MAX; ++i) {
            if (slot[group][i] == nullptr) {
                owner_slot = i;
                break;
            }
        }
        if (owner_slot < 0) {
            now = nullptr;
            std::printf("--- effect script (ent_tbl max)!!! ---\n");
            return nullptr;
        }
    }

    // Copy size already measures native frame/model allocations. Add the native
    // effect and character objects, interpreter arrays, and final 64-byte alignment.
    int required = Quadwords(sizeof(_EFF_SCRIPT)) + 2 + Quadwords(64 * sizeof(RS_STACKDATA)) +
                   Quadwords(2 * sizeof(RS_CALLDATA)) + 4;
    if (definition->chara != nullptr) {
        required += Quadwords(sizeof(CCharacter2)) + 2 + std::max(0, definition->chara->GetCopySize());
    }
    definition->work_size = required;
    u_long128 *token = work_memory->StartStackMode(MG_STACK_MODE_FIT, required);
    if (token == nullptr) {
        now = nullptr;
        std::printf("--- effect script work max[%d]!!! ---\n", work_memory->stack_size - work_memory->stack_used);
        return nullptr;
    }

    auto *effect = new (work_memory->Alloc(Quadwords(sizeof(_EFF_SCRIPT)) + 2)) _EFF_SCRIPT{};
    effect->work = token;
    effect->texb = definition->texb;
    effect->level = definition->level;
    if (definition->chara != nullptr) {
        effect->chara = new (work_memory->Alloc(Quadwords(sizeof(CCharacter2)) + 2)) CCharacter2;
        effect->chara->Initialize();
        definition->chara->Copy(*effect->chara, work_memory);
        effect->chara->SetPosition(0.0f, -10000.0f, 0.0f);
        effect->chara->SetRotation(0.0f, 0.0f, 0.0f);
    }
    SetEffectScript(&effect->run, definition->script, work_memory);
    effect->prog_no = 200;
    effect->user_id = group;
    effect->slot = owner_slot;
    effect->work_vect1[3] = effect->work_vect2[3] = 1.0f;
    effect->target_id = -1;
    work_memory->stAlign64();
    work_memory->EndStackMode();

    if (register_in_group == 1) {
        slot[group][owner_slot] = effect;
    }
    _EFF_SCRIPT *previous = nullptr;
    _EFF_SCRIPT *following = head;
    while (following != nullptr && following->texb <= effect->texb) {
        previous = following;
        following = following->next;
    }
    effect->prev = previous;
    effect->next = following;
    if (previous != nullptr) {
        previous->next = effect;
    } else {
        head = effect;
    }
    if (following != nullptr) {
        following->prev = effect;
    } else {
        tail = effect;
    }
    now = effect;
    return effect;
}

namespace {
/**
 * Selects a bounded retail effect definition without interpreting a resource archive.
 */
const EFF_SPT_BASE_DEF *EffectDefinition(int base_no) {
    return base_no >= 0 && base_no < EFF_SPT_BASE_DEF_NUM && eff_spt_base_def[base_no].name[0] ? &eff_spt_base_def[base_no] : nullptr;
}

/**
 * Describes the direct model or texture resource used by one effect base.
 */
struct EffectResource {
    std::string                model;       /**< Actual character glTF path, or empty for an unmodeled effect. */
    std::string                texture;     /**< Actual standalone texture JSON path. */
    std::string                bundle;      /**< Actual glTF path containing an embedded texture set. */
    std::optional<std::size_t> texture_set; /**< Embedded set selected by its retained texture name. */
};

/**
 * Reads and validates one directly named compiled VM program with its timing conversion.
 */
std::vector<unsigned char> EffectScript(const std::string &path) {
    for (const auto &candidate : datapacks::Candidates(path)) {
        std::ifstream input(candidate, std::ios::binary);
        if (!input) {
            continue;
        }
        std::vector<unsigned char> bytes{std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>()};
        if (bytes.size() > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
            continue;
        }
        const auto result = script_timing::Apply(path, bytes.data(), bytes.size());
        if (result.ok && result.decoded) {
            return bytes;
        }
    }
    return {};
}

/**
 * Builds a native effect base from explicit standard resources and bounded VM bytes.
 */
int BuildNativeEffect(CEffectScriptMan &manager, int base_no, const EffectResource &resource,
                      std::span<const unsigned char> script, mgCMemory *work, int requested_block) {
    auto       *memory = work ? work : manager.memory;
    const auto *definition = EffectDefinition(base_no);
    if (!memory || !definition || script.empty()) {
        return -1;
    }
    int index = -1;
    for (int candidate = 0; candidate < EFF_SPT_BASE_MAX; ++candidate) {
        if (manager.base[candidate] && manager.base[candidate]->base_no == base_no) {
            return 0;
        }
        if (!manager.base[candidate] && index < 0) {
            index = candidate;
        }
    }
    const int block = requested_block < 0 ? manager.texb_start + manager.texb_used : requested_block;
    if (index < 0 || (requested_block < 0 && manager.texb_used >= manager.texb_num) ||
        block < manager.texb_start || block >= manager.texb_start + manager.texb_num) {
        return -1;
    }
    memory->lock = 0;
    memory->Align64();
    auto *base = new (memory->Alloc(Quadwords(sizeof(EFF_SPT_BASE)) + 2)) EFF_SPT_BASE{};
    base->base_no = base_no;
    base->work_size = 0x7D + 0x24;
    base->texb = block;
    base->level = manager.level;
    bool owns_block = false;
    if (definition->type == EFF_SPT_BASE_CHR && !resource.model.empty()) {
        auto *source = manager.GetBaseChara(base_no);
        base->chara = new (memory->Alloc(Quadwords(sizeof(CCharacter2)) + 2)) CCharacter2;
        base->chara->Initialize();
        if (source) {
            source->Copy(*base->chara, memory);
            base->texb = source->texture_block;
        } else {
            if (requested_block < 0) {
                mgTexManager.DeleteBlock(block);
            }
            model_assets::CharacterLoadOptions options{memory, memory, memory, &mgTexManager, nullptr, block, false};
            std::string                        error;
            if (!model_assets::LoadCharacter(*base->chara, resource.model, "info", options, error)) {
                std::fprintf(stderr, "effect model: %s\n", error.c_str());
                return -1;
            }
            owns_block = requested_block < 0;
        }
        base->work_size += base->chara->GetCopySize();
    } else if (definition->type == EFF_SPT_BASE_IMG) {
        auto *texture = mgTexManager.GetTexture(const_cast<char *>(definition->file), -1);
        if (texture) {
            base->texb = texture->block;
        } else {
            if (requested_block < 0) {
                mgTexManager.DeleteBlock(block);
            }
            bool loaded = false;
            if (resource.texture_set) {
                std::string error;
                loaded = model_assets::LoadTextureSet(resource.bundle, *resource.texture_set, mgTexManager, block, *memory, error);
                if (!loaded) {
                    std::fprintf(stderr, "effect texture: %s\n", error.c_str());
                }
            } else if (!resource.texture.empty()) {
                MgTextureEnterDocument(&mgTexManager, resource.texture, block, memory, nullptr);
                loaded = mgTexManager.GetTexture(const_cast<char *>(definition->file), block) != nullptr;
            }
            if (!loaded) {
                return -1;
            }
            owns_block = requested_block < 0;
        }
    }
    base->script = reinterpret_cast<char *>(memory->stAlloc64(Quadwords(script.size()) + 1));
    if (!base->script) {
        return -1;
    }
    std::memcpy(base->script, script.data(), script.size());
    if (owns_block) {
        manager.texb_used++;
        base->texb_owned = 1;
    }
    manager.base[index] = base;
    manager.base_num++;
    return 1;
}

/**
 * Selects the embedded set containing the effect's actual texture name.
 */
std::optional<std::size_t> EffectTextureSet(const std::string &bundle, const char *name) {
    std::string error;
    const auto  game = model_assets::ReadGameplay(bundle, error);
    if (!game) {
        return std::nullopt;
    }
    const auto resource_fields = game->find("resources");
    if (resource_fields == game->end() || !resource_fields->is_object()) {
        return std::nullopt;
    }
    const auto &resources = *resource_fields;
    const auto  found = resources.find("texture_sets");
    if (found == resources.end() || !found->is_array()) {
        return std::nullopt;
    }
    const auto &sets = *found;
    for (std::size_t index = 0; index < sets.size(); ++index) {
        if (!sets[index].is_object() || !sets[index].contains("document") || !sets[index]["document"].is_object()) {
            continue;
        }
        const auto &document = sets[index]["document"];
        const auto  entries = document.find("entries");
        if (entries == document.end() || !entries->is_array()) {
            continue;
        }
        for (const auto &entry : *entries) {
            if (entry.is_object() && entry.contains("name") && entry["name"].is_string() && entry["name"] == name) {
                return index;
            }
        }
    }
    return std::nullopt;
}
} // namespace

PORT_OVERRIDE int CEffectScriptMan::BuildPack(int base_no, u_int *pack, mgCMemory *memory, int texture_block) {
    const auto *definition = EffectDefinition(base_no);
    const auto  path = DataReadBufferPath(pack);
    if (!definition || !path) {
        return -1;
    }
    EffectResource        resource;
    std::filesystem::path directory;
    if (std::filesystem::path(*path).extension() == ".gltf") {
        directory = std::filesystem::path(*path).replace_extension(".assets");
        if (definition->type == EFF_SPT_BASE_IMG) {
            resource.bundle = *path;
            resource.texture_set = EffectTextureSet(*path, definition->file);
        }
    } else if (const auto parent = AssetDirectoryPath(pack)) {
        directory = *parent;
        if (definition->type == EFF_SPT_BASE_IMG) {
            resource.texture = (directory / (std::string(definition->file) + ".json")).generic_string();
        }
    } else {
        return -1;
    }
    if (definition->type == EFF_SPT_BASE_CHR && definition->file[0]) {
        const auto model = (directory / (std::string(definition->file) + ".gltf")).generic_string();
        if (!datapacks::Candidates(model).empty()) {
            resource.model = model;
        }
    }
    const auto script_path = (directory / (std::string(definition->script) + ".stb")).generic_string();
    const auto script = EffectScript(script_path);
    return BuildNativeEffect(*this, base_no, resource, script, memory, texture_block);
}

PORT_OVERRIDE int CEffectScriptMan::LoadBaseEffSpt(int base_no, mgCMemory *memory, int texture_block) {
    const auto *definition = EffectDefinition(base_no);
    if (!definition) {
        return -1;
    }
    for (const auto *entry : base) {
        if (entry && entry->base_no == base_no) {
            return 0;
        }
    }
    EffectResource resource;
    if (definition->type == EFF_SPT_BASE_CHR && definition->file[0]) {
        const auto model = "dungeon/eff_script/" + std::string(definition->file) + ".gltf";
        if (!datapacks::Candidates(model).empty()) {
            resource.model = model;
        }
    } else if (definition->type == EFF_SPT_BASE_IMG) {
        resource.texture = "dungeon/eff_script/" + std::string(definition->file) + ".json";
    }
    const auto script = EffectScript("dungeon/eff_script/" + std::string(definition->script) + ".stb");
    return BuildNativeEffect(*this, base_no, resource, script, memory, texture_block);
}

PORT_OVERRIDE int CEffectScriptMan::BuildBase(int base_no, u_long128 *data, int, u_long128 *script, int script_size, mgCMemory *memory, int texture_block) {
    const auto *definition = EffectDefinition(base_no);
    if (!definition || !script || script_size <= 0) {
        return -1;
    }
    EffectResource resource;
    if (const auto path = DataReadBufferPath(data)) {
        if (definition->type == EFF_SPT_BASE_CHR && std::filesystem::path(*path).extension() == ".gltf") {
            resource.model = *path;
        } else if (definition->type == EFF_SPT_BASE_IMG && std::filesystem::path(*path).extension() == ".json") {
            resource.texture = *path;
        } else {
            return -1;
        }
    } else if (data) {
        return -1;
    }
    return BuildNativeEffect(*this, base_no, resource,
                             {reinterpret_cast<const unsigned char *>(script), static_cast<std::size_t>(script_size)}, memory, texture_block);
}

PORT_OVERRIDE int CEffectScriptMan::GetNeedFilePath(int base_no, char *resource, char *script) {
    const auto *definition = EffectDefinition(base_no);
    if (!definition || !resource || !script) {
        return 0;
    }
    std::sprintf(resource, "dungeon/eff_script/%s.%s", definition->file, definition->type == EFF_SPT_BASE_CHR ? "gltf" : "json");
    std::sprintf(script, "dungeon/eff_script/%s.stb", definition->script);
    return 1;
}
