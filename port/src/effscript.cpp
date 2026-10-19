#include "common.h"
#include "mw_runtime.h"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <limits>
#include <optional>
#include <print>
#include <span>
#include <string>
#include <unordered_map>
#include <vector>

#include "asset_directory.hpp"
#include "character.hpp"
#include "dataread_port.hpp"
#include "effscript.hpp"
#include "effscript_port.hpp"
#include "log/log.hpp"
#include "map.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mg_sprite_port.hpp"
#include "mg_texture.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/datapacks.hpp"
#include "platform/model_assets.hpp"
#include "scenesnd.hpp"
#include "script_timing.hpp"

int SetEffectScript(CRunScript *script, char *program, mgCMemory *memory);
// Retail's sprite commands under their bridge names (port/include/stubs/effscript.hpp).
int PortRetailSptAssignSprite(RS_STACKDATA *stack, int argument_count) asm("EffScript_SptAssignSprite");
int PortRetailSptInitSprite(RS_STACKDATA *stack, int argument_count) asm("EffScript_SptInitSprite");
// The effect whose script is running (port/src/effscript_config_bridge.inc).
_EFF_SCRIPT *PortRunningEffect();

namespace {
constexpr int Quadwords(std::size_t bytes) {
    return static_cast<int>((bytes + 15) / 16);
}

/**
 * The sprite incarnations of a running recovery effect. A slot's incarnation is a serial that no sprite has had
 * before, renewed when the script assigns the effect's sprites or resets the slot, so a particle reset and shown again
 * in place between two game frames never blends from the one it replaced.
 */
struct RecoveryEffect {
    const CEffectScriptMan *manager = nullptr; /**< Manager that started the effect. */
    const _ES_SPRITE       *sprites = nullptr; /**< Sprites the incarnations number; null before any are assigned. */
    std::vector<uint64_t>   incarnations;      /**< One per sprite slot. */
};

/**
 * Recovery effects only. CreateEffSpt adds one and replaces any entry left at the same address; DeleteEffSpt, which
 * every stop and clear goes through, removes it. Effects a game mode leaves behind when it retires its arena without
 * clearing them go when their manager is reset (Initialize, which its construction runs). Until then their entries are
 * inspected by that cleanup but never used to dereference a retired effect. Built on first use, so a manager
 * constructed during static initialisation finds it.
 */
std::unordered_map<const _EFF_SCRIPT *, RecoveryEffect> &RecoveryEffects() {
    static std::unordered_map<const _EFF_SCRIPT *, RecoveryEffect> effects;
    return effects;
}

uint64_t next_incarnation = 0;

void Renumber(RecoveryEffect &effect, const _EFF_SCRIPT *script) {
    effect.sprites = script->sprite;
    effect.incarnations.resize(script->sprite != nullptr ? static_cast<std::size_t>(std::max(0, script->sprite_num)) : 0);
    for (uint64_t &incarnation : effect.incarnations) {
        incarnation = ++next_incarnation;
    }
}

// The effect's entry, its incarnations numbering its current sprites, or null for an effect that is not one.
RecoveryEffect *Recovery(const _EFF_SCRIPT *script) {
    const auto found = RecoveryEffects().find(script);
    if (found == RecoveryEffects().end()) {
        return nullptr;
    }
    RecoveryEffect &effect = found->second;
    const auto      count = static_cast<std::size_t>(script->sprite != nullptr ? std::max(0, script->sprite_num) : 0);
    if (effect.sprites != script->sprite || effect.incarnations.size() != count) {
        Renumber(effect, script);
    }
    return &effect;
}

// Retail's GetStackInt: a float argument converts through fptosi, which saturates and takes NaN to 0.
int StackInt(const RS_STACKDATA &slot) {
    return slot.type == RS_FLOAT ? fptosi(slot.val.f) : slot.val.i;
}

/**
 * The recovery effect (the healing point, food and drink, Resurrection Powder, items used from the menu) and the
 * sparkles it starts. Their sprites drift, spin and fade while the effect follows its character.
 */
bool SpritesInterpolate(int base_no) {
    if (base_no < 0 || base_no >= EFF_SPT_BASE_DEF_NUM) {
        return false;
    }
    const char *script = eff_spt_base_def[base_no].script;
    return std::strcmp(script, "n_heal") == 0 || std::strcmp(script, "n_heal_sub") == 0;
}
} // namespace

PORT_OVERRIDE int CEffectScriptMan::AssignCharacter(_EFF_SCRIPT *script, int count) {
    if (count < 0 || count > EFF_SPT_SUB_CHARA_MAX || script == nullptr ||
        script->chara == nullptr || work_memory == nullptr) {
        return 0;
    }
    const int object_size = Quadwords(sizeof(CCharacter2));
    // The allocator picks its gap before placement new runs, so native objects are budgeted up front,
    // with room for the final 64-byte alignment and the strict end-of-stack check.
    const long long required = count * (static_cast<long long>(object_size) +
                                        std::max(0, script->chara->GetCopySize())) +
                               4;
    if (required > std::numeric_limits<int>::max()) {
        std::println("------- es work max!! (assign character[{}]) ---------", required);
        return 0;
    }
    u_long128 *token = work_memory->StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(required));
    if (token == nullptr) {
        std::println("------- es work max!! (assign character[{}]) ---------", required);
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
        std::println("--- effect script (non base)!!! ---");
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
        std::println("--- effect script (missing base or work stack)!!! ---");
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
            std::println("--- effect script (ent_tbl max)!!! ---");
            return nullptr;
        }
    }

    // The copy size covers native frame and model allocations; add the effect and character objects,
    // interpreter arrays and final 64-byte alignment.
    int required = Quadwords(sizeof(_EFF_SCRIPT)) + 2 + Quadwords(64 * sizeof(RS_STACKDATA)) +
                   Quadwords(2 * sizeof(RS_CALLDATA)) + 4;
    if (definition->chara != nullptr) {
        required += Quadwords(sizeof(CCharacter2)) + 2 + std::max(0, definition->chara->GetCopySize());
    }
    definition->work_size = required;
    u_long128 *token = work_memory->StartStackMode(MG_STACK_MODE_FIT, required);
    if (token == nullptr) {
        now = nullptr;
        std::println("--- effect script work max[{}]!!! ---", work_memory->stack_size - work_memory->stack_used);
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
    if (SpritesInterpolate(base_no)) {
        RecoveryEffects()[effect] = {.manager = this};
    } else {
        RecoveryEffects().erase(effect);
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
    std::string                model;       /**< Character glTF path, or empty for an unmodeled effect. */
    std::string                texture;     /**< Standalone texture JSON path. */
    std::string                bundle;      /**< glTF path containing an embedded texture set. */
    std::optional<std::size_t> texture_set; /**< Embedded set selected by its retained texture name. */
};

/**
 * Reads and validates one directly named compiled VM program with its timing conversion.
 */
std::vector<unsigned char> EffectScript(const std::string &path) {
    for (const auto &candidate : datapacks::Candidates(path)) {
        std::vector<unsigned char> bytes;
        if (!datapacks::ReadFileBytes(candidate, bytes) || bytes.size() > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
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
            model_assets::CharacterLoadOptions options{.model_memory = memory, .motion_memory = memory, .image_memory = memory, .textures = &mgTexManager, .parent = nullptr, .texture_block = block, .outline = false};
            std::string                        error;
            if (!model_assets::LoadCharacter(*base->chara, resource.model, "info", options, error)) {
                CT_LOG_ERROR(Data, "effect model: {}", error);
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
                    CT_LOG_ERROR(Data, "effect texture: {}", error);
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
            const auto name = std::string(definition->file) + ".json";
            if (const auto *texture = AssetDirectoryRead(pack, name.c_str(), nullptr)) {
                resource.texture = DataReadBufferPath(texture).value_or(std::string{});
            }
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
    const auto script = EffectScript((directory / (std::string(definition->script) + ".stb")).generic_string());
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
        resource.texture = "textures/dungeon/eff_script/" + std::string(definition->file) + ".json";
    }
    const auto script = EffectScript("dungeon/eff_script/" + std::string(definition->script) + ".stb");
    return BuildNativeEffect(*this, base_no, resource, script, memory, texture_block);
}

PORT_OVERRIDE int CEffectScriptMan::BuildBase(int base_no, u_long128 *data, int /*unused*/, u_long128 *script, int script_size, mgCMemory *memory, int texture_block) {
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
    std::sprintf(resource, "%sdungeon/eff_script/%s.%s", definition->type == EFF_SPT_BASE_CHR ? "" : "textures/", definition->file,
                 definition->type == EFF_SPT_BASE_CHR ? "gltf" : "json");
    std::sprintf(script, "dungeon/eff_script/%s.stb", definition->script);
    return 1;
}

gfx::Interp2D PortEffectSpriteTag(const _EFF_SCRIPT *script, int index) {
    const RecoveryEffect *effect = Recovery(script);
    if (effect == nullptr || index < 0 || static_cast<std::size_t>(index) >= effect->incarnations.size()) {
        return {};
    }
    return {.key = static_cast<gfx::InterpKey>(reinterpret_cast<uintptr_t>(&script->sprite[index])),
            .generation = effect->incarnations[static_cast<std::size_t>(index)],
            .world_corners = true,
            .teleport_distance = kMgPortFrameTeleportDistance};
}

std::size_t PortRecoveryEffectCount() {
    return RecoveryEffects().size();
}

// A new sprite array, even one allocated where the last was, numbers every slot afresh. A refused assignment (the
// effect already has sprites, or the work memory is full) changes nothing, so neither does it here.
PORT_OVERRIDE int _SPT_ASSIGN_SPRITE(RS_STACKDATA *stack, int argument_count) {
    const int    result = PortRetailSptAssignSprite(stack, argument_count);
    _EFF_SCRIPT *script = PortRunningEffect();
    if (const auto found = RecoveryEffects().find(script); result != 0 && found != RecoveryEffects().end()) {
        Renumber(found->second, script);
    }
    return result;
}

// A reset slot is a new particle. Retail resets the slots it reaches before an invalid one; so does this.
PORT_OVERRIDE int _SPT_INIT_SPRITE(RS_STACKDATA *stack, int argument_count) {
    const int       result = PortRetailSptInitSprite(stack, argument_count);
    RecoveryEffect *effect = Recovery(PortRunningEffect());
    if (effect != nullptr) {
        const int first = StackInt(stack[0]);
        const int count = argument_count >= 2 ? StackInt(stack[1]) : 1;
        for (int i = first; i < first + count && i >= 0 && static_cast<std::size_t>(i) < effect->incarnations.size(); i++) {
            effect->incarnations[static_cast<std::size_t>(i)] = ++next_incarnation;
        }
    }
    return result;
}

// Every stop and clear of an effect comes here, so a stopped recovery effect leaves no entry.
PORT_OVERRIDE void CEffectScriptMan::DeleteEffSpt(_EFF_SCRIPT *script) {
    RecoveryEffects().erase(script);
    PortRetailDeleteEffSpt(script);
}

// A reset manager has no effects: those it ran are gone with the arena or the mode that held them.
PORT_OVERRIDE void CEffectScriptMan::Initialize(mgCMemory *memory, int texb_start, int texb_num) {
    std::erase_if(RecoveryEffects(), [this](const auto &entry) { return entry.second.manager == this; });
    PortRetailInitialize(memory, texb_start, texb_num);
}

// Retail's DrawEffSptSprite batches every sprite of an effect that shares a blend into one draw at the tick's screen
// corners, so the sprites' drift, spin and fade moved at the game rate. An interpolated effect's sprites are each a batch
// of their own, keyed by the sprite, so display frames blend their world corners; a hidden or culled sprite leaves no
// gap that would shift another's match. The images drawn are unchanged.
void PortDrawEffectSprites(_EFF_SCRIPT *script, mgCTexture *texture, float *offset, mgC3DSprite *renderer) {
    _ES_SPRITE *sprites = script->sprite;
    const int   count = script->sprite_num;
    int         alpha = sprites->alpha;
    // A tag already current (the player's effects on the dungeon pause frame) is kept for every sprite.
    const bool keyed = gfx::CurrentInterp2D().key == 0 && PortEffectSpriteTag(script, 0).key != 0;
    auto       begin = [&](int blend) {
        mgCDrawEnv environment(*mgGetpDrawEnv(0));
        sceGsTest *test = &environment.test;
        test->bits.zte = 1;
        test->bits.ztst = 2;
        environment.SetZBuf(MG_ZBUF_NO_WRITE);
        environment.SetAlpha(blend);
        renderer->CPSetDrawEnv(&environment);
        renderer->CPSetTexture(texture);
        renderer->BeginCPSprite();
    };
    begin(alpha);

    for (int i = 0; i < count; i++) {
        if (sprites[i].draw_flag == 0) {
            continue;
        }

        _ES_SPRITE *sprite = &sprites[i];

        if (alpha != sprite->alpha || keyed) {
            alpha = sprite->alpha;
            renderer->EndCPSprite();
            begin(alpha);
        }

        if (keyed) {
            mgPortTag3DSpriteBatch(renderer, PortEffectSpriteTag(script, i));
        }

        sceVu0FVECTOR size = {0.0f, 0.0f, 0.0f, 0.0f};
        sceVu0FVECTOR uv0, uv1, position;
        sceVu0FVECTOR color;
        mgZeroVector(uv0);
        mgZeroVector(uv1);
        sceVu0AddVector(position, sprite->pos, offset);
        position[3] = 1.0f;
        *(u_long128 *) color = *(u_long128 *) sprite->color;

        if (0.0f != sprite->blink_speed) {
            for (int component = 0; component < 4; component++) {
                color[component] += sinf(sprite->blink_phase) * sprite->blink_amp[component];
                color[component] = std::clamp(color[component], 0.0f, 255.0f);
            }

            sprite->blink_phase += sprite->blink_speed;
            sprite->blink_phase = mgAngleLimit(sprite->blink_phase);
        } else {
            for (int component = 0; component < 4; component++) {
                color[component] = std::clamp(color[component], 0.0f, 255.0f);
            }
        }

        if (script->light_flag) {
            sceVu0FMATRIX light_direction, light_color;
            sceVu0FVECTOR ambient;
            mgGetLight(light_direction, light_color);
            mgGetAmbient(ambient);
            color[0] = 0.3 * light_color[0][0] + ambient[0];
            color[1] = light_color[0][1] * 0.3 + ambient[1];
            color[2] = light_color[0][2] * 0.3 + ambient[2];
        }

        size[0] = sprite->put_size[0] * sprite->scale[0];
        size[1] = sprite->put_size[1] * sprite->scale[1];
        size[2] = mgAngleLimit(sprite->rotz);
        uv0[0] = sprite->uv[0];
        uv0[1] = sprite->uv[1];
        uv1[0] = sprite->uv[0] + sprite->uv[2];
        uv1[1] = sprite->uv[1] + sprite->uv[3];
        renderer->CPSetSprite(position, size, color, uv0, uv1);
    }

    renderer->EndCPSprite();
}

namespace {
/**
 * Where an effect's model and sprites are placed: its origin, plus its target character's position, or that of the
 * character's named frame, when the effect follows it. Retail's Draw computes it for the models and the sprites alike.
 */
void EffectOffset(_EFF_SCRIPT *script, sceVu0FVECTOR offset) {
    mgZeroVector(offset);

    // Retail tests target_id >= 0 || target_id < 128, which every id passes.
    if (script->auto_offset) {
        CCharacter2 *character = now_scene->GetCharacter(script->target_id);

        if (character != nullptr) {
            sceVu0FVECTOR character_position;
            character->GetPosition(character_position);

            if (std::strcmp(script->offset_frame, "") != 0) {
                mgCFrame *frame = character->CObjectFrame::frame;

                if (frame != nullptr) {
                    frame = frame->SearchFrame(script->offset_frame);

                    if (frame != nullptr) {
                        sceVu0FVECTOR frame_position;
                        frame->GetWorldPosition0(frame_position);
                        *(u_long128 *) character_position = *(u_long128 *) frame_position;
                    }
                }
            }

            *(u_long128 *) offset = *(u_long128 *) character_position;
        }
    }

    sceVu0AddVector(offset, offset, script->origin);
    offset[3] = 0.0f;
}

bool Hidden(const _EFF_SCRIPT *script) {
    return script->state == EFF_SPT_STATE_HIDE_STOP || script->state == EFF_SPT_STATE_HIDE;
}
} // namespace

// Retail's Draw: every effect's models, then every effect's sprites, the sprites built by PortDrawEffectSprites.
PORT_OVERRIDE void CEffectScriptMan::Draw() {
    mgCTextureManager *textures = &mgTexManager;
    CMap              *map = now_scene->GetMap(now_scene->active_map);
    CMapLightingInfo   lighting;

    if (map != nullptr) {
        map->GetLightInfo(&lighting);
    }

    for (_EFF_SCRIPT *script = head; script != nullptr; script = script->next) {
        if (Hidden(script) || script->chara == nullptr) {
            continue;
        }

        sceVu0FVECTOR offset;
        EffectOffset(script, offset);
        textures->ReloadTexture(script->texb, (sceVif1Packet *) nullptr);
        sceVu0FVECTOR position;
        script->chara->GetPosition(position);
        sceVu0AddVector(position, position, offset);
        position[3] = 1.0f;
        script->chara->SetPosition(position);
        script->chara->DrawDirect();
        sceVu0SubVector(position, position, offset);
        position[3] = 1.0f;
        script->chara->SetPosition(position);

        for (CCharacter2 *sub : script->sub_chara) {
            if (sub != nullptr) {
                sceVu0FVECTOR sub_position;
                sub->GetPosition(sub_position);
                sceVu0AddVector(sub_position, sub_position, offset);
                sub_position[3] = 1.0f;
                sub->SetPosition(sub_position);
                sub->DrawDirect();
                sceVu0SubVector(sub_position, sub_position, offset);
                sub_position[3] = 1.0f;
                sub->SetPosition(sub_position);
            }
        }
    }

    for (_EFF_SCRIPT *script = head; script != nullptr; script = script->next) {
        if (Hidden(script) || script->sprite == nullptr) {
            continue;
        }

        sceVu0FVECTOR offset;
        EffectOffset(script, offset);
        textures->ReloadTexture(script->texb, (sceVif1Packet *) nullptr);
        mgCTexture *texture = textures->GetTexture(script->tex_name, script->texb);

        if (texture != nullptr) {
            sprite.Initialize();
            sprite.BeginCreatePacket(1, nullptr);
            PortDrawEffectSprites(script, texture, offset, &sprite);
            sprite.EndCreatePacket();
            sceVu0FMATRIX matrix;
            mgUnitMatrix(matrix);
            mgDrawDirect(&sprite, matrix);
        }
    }
}
