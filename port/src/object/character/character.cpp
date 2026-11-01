#include "common.h"
#include "mw_runtime.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <limits>
#include <new>
#include <optional>
#include <string>
#include <utility>
#include <vector>

#include "actscript.hpp"
#include "character.hpp"
#include "character_metadata_bridge.hpp"
#include "colprim.hpp"
#include "dataread.hpp"
#include "dng_event.hpp"
#include "dng_main.hpp"
#include "dng_status.hpp"
#include "dynamicanime.hpp"
#include "effect.hpp"
#include "effscript.hpp"
#include "gameutil.hpp"
#include "log/game_output.hpp"
#include "map.hpp"
#include "mdslist.hpp"
#include "memory/tracked_copy.hpp"
#include "mg_camera.hpp"
#include "mg_dataset.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "object.hpp"
#include "outline.hpp"
#include "pal_timing.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "sceneload.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "swordeffect.hpp"
#include "text/bounded.hpp"
#include "visualmotion.hpp"

namespace dc2::character {
namespace {
/**
 * Retains an exact sound allocation, construction capacity and finalized used count.
 */
struct SoundCloneBinding {
    CHRINFO_SE              *pointer = nullptr; /**< Expected current sound array identity. */
    int                      count = 0;         /**< Expected finalized number of readable sound cues. */
    std::size_t              capacity = 0;      /**< Actual producer allocation capacity in sound records. */
    dc2::memory::ArenaBuffer storage;           /**< Exact source sound allocation capability. */

    /**
     * Checks identities and exact storage before any sound record is read.
     */
    bool Matches(CHRINFO_SE *expected, int expected_count) const {
        return expected == pointer && expected_count == count && count >= 0 &&
               static_cast<std::size_t>(count) <= capacity &&
               (capacity == 0 ? pointer == nullptr : storage.Bytes().size() == capacity * sizeof(CHRINFO_SE));
    }
};
} // namespace

/**
 * Owns immutable fixed-frame remapping names and exact sound-channel allocation identities.
 */
struct CloneAuxState {
    dc2::world::FrameGraph                                           graph;            /**< Producer graph retained for explicit model extensions. */
    std::array<dc2::world::FrameNameBinding, CHARA_ENTRY_FRAME_MAX>  entries;          /**< Exact fixed entry frame bindings. */
    std::array<dc2::world::FrameNameBinding, CHARA_ENTRY_OBJECT_MAX> objects;          /**< Exact fixed object frame bindings. */
    std::array<dc2::world::FrameNameBinding, CHARA_DEFORM_FRAME_MAX> deform;           /**< Exact active deformation frame bindings. */
    int                                                              deform_count = 0; /**< Expected bounded active deformation slot count. */
    std::array<SoundCloneBinding, CHARA_MOTION_SET_MAX>              sounds;           /**< Exact sound records for every motion set. */

    /**
     * Validates fixed identities and all sound allocations without raw frame entry.
     */
    bool Matches(const CCharacter2 &character) const {
        if (character.deform_frame_num != deform_count || deform_count < 0 || deform_count > CHARA_DEFORM_FRAME_MAX) {
            return false;
        }
        for (std::size_t slot = 0; slot < entries.size(); ++slot) {
            if (!entries[slot].Matches(character.entry_frame[slot])) {
                return false;
            }
        }
        for (std::size_t slot = 0; slot < objects.size(); ++slot) {
            if (!objects[slot].Matches(character.entry_object[slot].frame)) {
                return false;
            }
        }
        for (int slot = 0; slot < deform_count; ++slot) {
            if (!deform[static_cast<std::size_t>(slot)].Matches(character.deform_frame[slot])) {
                return false;
            }
        }
        for (std::size_t slot = 0; slot < sounds.size(); ++slot) {
            if (!sounds[slot].Matches(character.se_list[slot], character.se_num[slot])) {
                return false;
            }
        }
        return true;
    }
};

CloneAuxBuilder::CloneAuxBuilder(std::shared_ptr<const CloneAuxState> inherited)
    : state(inherited ? std::make_shared<CloneAuxState>(*inherited) : std::make_shared<CloneAuxState>()), original(std::move(inherited)) {}

bool CloneAuxBuilder::ClearSounds(int slot) {
    if (slot < 0 || slot >= CHARA_MOTION_SET_MAX) {
        return false;
    }
    state->sounds[static_cast<std::size_t>(slot)] = {};
    produced_sounds[static_cast<std::size_t>(slot)] = true;
    return true;
}

bool CloneAuxBuilder::RegisterSounds(mgCMemory &producer, int slot, std::span<CHRINFO_SE> allocation) {
    if (slot < 0 || slot >= CHARA_MOTION_SET_MAX || allocation.size() > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
        allocation.size() > std::numeric_limits<std::size_t>::max() / sizeof(CHRINFO_SE)) {
        return false;
    }
    if (allocation.empty()) {
        return ClearSounds(slot);
    }
    SoundCloneBinding binding;
    binding.pointer = allocation.data();
    binding.capacity = allocation.size();
    binding.storage = dc2::memory::ArenaBuffer::Bind(producer, {reinterpret_cast<u8 *>(allocation.data()), allocation.size_bytes()});
    if (binding.storage.Bytes().size() != allocation.size_bytes()) {
        return false;
    }
    state->sounds[static_cast<std::size_t>(slot)] = binding;
    produced_sounds[static_cast<std::size_t>(slot)] = true;
    return true;
}

bool CloneAuxBuilder::CaptureFrames(const CCharacter2 &character, const dc2::world::FrameGraph &graph) {
    if (character.deform_frame_num < 0 || character.deform_frame_num > CHARA_DEFORM_FRAME_MAX) {
        return false;
    }
    const auto capture = [&graph](auto *frame, auto &binding) {
        if (frame == nullptr) {
            binding = {};
            return true;
        }
        const auto captured = graph.BindName(frame);
        if (!captured) {
            return false;
        }
        binding = *captured;
        return true;
    };
    auto updated = *state;
    updated.graph = graph;
    for (std::size_t slot = 0; slot < updated.entries.size(); ++slot) {
        if (!capture(character.entry_frame[slot], updated.entries[slot])) {
            return false;
        }
    }
    for (std::size_t slot = 0; slot < updated.objects.size(); ++slot) {
        if (!capture(character.entry_object[slot].frame, updated.objects[slot])) {
            return false;
        }
    }
    updated.deform_count = character.deform_frame_num;
    for (int slot = 0; slot < character.deform_frame_num; ++slot) {
        if (!capture(character.deform_frame[slot], updated.deform[static_cast<std::size_t>(slot)])) {
            return false;
        }
    }
    *state = std::move(updated);
    return true;
}

bool CloneAuxBuilder::CaptureFrames(const CCharacter2 &character, mgCMemory &producer) {
    const auto *imported = SourceGraph();
    if (imported != nullptr && imported->MatchesRootAllocation(character.CObjectFrame::frame) && CaptureFrames(character, *imported)) {
        return true;
    }
    auto graph = dc2::world::FrameGraph::Capture(producer, character.CObjectFrame::frame);
    if (!graph.IsLive() && imported != nullptr) {
        graph = dc2::world::FrameGraph::Capture(producer, character.CObjectFrame::frame, imported);
    }
    return graph.IsLive() && CaptureFrames(character, graph);
}

const dc2::world::FrameGraph *CloneAuxBuilder::SourceGraph() const {
    return state->graph.HasValue() ? &state->graph : nullptr;
}

std::shared_ptr<const CloneAuxState> CloneAuxBuilder::Finish(const CCharacter2 &character) {
    auto completed = std::make_shared<CloneAuxState>(*state);
    for (std::size_t slot = 0; slot < completed->sounds.size(); ++slot) {
        if (produced_sounds[slot]) {
            completed->sounds[slot].count = character.se_num[slot];
        }
    }
    if (!completed->Matches(character)) {
        return nullptr;
    }
    if (original && ((!completed->graph.HasValue() && !original->graph.HasValue()) || completed->graph.SameIdentity(original->graph)) && completed->deform_count == original->deform_count &&
        std::ranges::equal(completed->entries, original->entries, [](const auto &left, const auto &right) { return left.SameIdentity(right); }) &&
        std::ranges::equal(completed->objects, original->objects, [](const auto &left, const auto &right) { return left.SameIdentity(right); }) &&
        std::ranges::equal(completed->deform, original->deform, [](const auto &left, const auto &right) { return left.SameIdentity(right); }) &&
        std::ranges::equal(completed->sounds, original->sounds, [](const auto &left, const auto &right) {
            return left.pointer == right.pointer && left.count == right.count && left.capacity == right.capacity && left.storage.SameIdentity(right.storage);
        })) {
        return original;
    }
    return completed;
}

bool CloneInputsLive(const CCharacter2 &character) {
    if (!ResourcesLive(character)) {
        return false;
    }
    if (const auto resources = character.resource_state.Acquire<ResourceState>(); resources && resources->clone_inputs) {
        return resources->clone_inputs->Matches(character);
    }
    return character.deform_frame_num == 0 &&
           std::ranges::all_of(character.entry_frame, [](const auto *frame) { return frame == nullptr; }) &&
           std::ranges::all_of(character.entry_object, [](const auto &entry) { return entry.frame == nullptr; }) &&
           std::ranges::all_of(character.se_list, [](const auto *sounds) { return sounds == nullptr; }) &&
           std::ranges::all_of(character.se_num, [](int count) { return count == 0; });
}

bool PublishCloneInputs(CCharacter2 &character, CloneAuxBuilder builder) {
    const auto resources = character.resource_state.Acquire<ResourceState>();
    if (!resources) {
        return false;
    }
    auto updated = *resources;
    updated.clone_inputs = builder.Finish(character);
    return updated.clone_inputs != nullptr && PublishResources(character, std::move(updated));
}

namespace {
/**
 * Validates one saved sound capability before the direct sound-copy helper reads its array.
 */
bool SoundsLive(const CCharacter2 &character, std::size_t slot) {
    const auto resources = character.resource_state.Acquire<ResourceState>();
    return resources && resources->clone_inputs && resources->clone_inputs->sounds[slot].Matches(character.se_list[slot], character.se_num[slot]);
}
} // namespace
} // namespace dc2::character

namespace {
/**
 *
 * Reserves character storage only while the allocator's exact binding remains live.
 *
 */
u_long128 *AllocateCharacterStorage(mgCMemory *memory, std::size_t quadwords) {
    if (memory == nullptr || memory->lock != 0 || quadwords == 0 ||
        quadwords > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
        dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128) <= quadwords) {
        return nullptr;
    }
    return memory->Alloc(static_cast<int>(quadwords));
}
} // namespace

/**
 * Character whose model or info script is being loaded.
 */
static CCharacter2 *nowChr;
/**
 *
 * Memory used for the character model and frame data.
 *
 */
static mgCMemory *base_stack;
/**
 *
 * Texture block receiving the character images.
 *
 */
static int set_imgblock;
/**
 *
 * Memory used for the current motion or sequence records.
 *
 */
static mgCMemory *now_stack;
/**
 *
 * Motion sequence entries awaiting checked arena allocation.
 *
 */
static std::optional<std::vector<CHRINFO_SEQ>> sequence_entries;
/**
 *
 * Sequence header currently being parsed.
 *
 */
static CHRINFO_SEQ_HEADER *now_seqhd_ptr;
/**
 *
 * Number of model objects that need deformable vertices.
 *
 */
static int alloc_vertex_num;
/**
 *
 * Names of model objects that need deformable vertices.
 *
 */
static char alloc_vertex[25][16];
/**
 *
 * Whether the character loader creates outlines.
 *
 */
static int outline_flag;
/**
 *
 * Parent character supplying a shared outline texture.
 *
 */
static CCharacter2 *parent_chr;
/**
 *
 * Whether an outline texture has been selected.
 *
 */
static int outline_start;
/**
 *
 * Outline texture selected for the character.
 *
 */
static mgCTexture *outline_start_tex;
/**
 *
 * Cloth record currently being parsed.
 *
 */
static int now_cloth_id;
/**
 *
 * Motion set currently being parsed.
 *
 */
static int now_motion_id;
/**
 *
 * Motion keys awaiting checked arena allocation.
 *
 */
static std::optional<std::vector<CHRINFO_KEY_SET>> key_entries;

/**
 *
 * Sound event array currently being parsed.
 *
 */
static CHRINFO_SE *now_se_header;
/**
 *
 * Sound event slots remaining in the declared motion array.
 *
 */
static int sound_entries_remaining = 0;

/**
 *
 * Frame-visual selections borrowed only during the active metadata parse.
 *
 */
static std::array<mgCreateVisualType, 64> metadata_visual_types{};

/**
 *
 * Rounds a byte count up to a number of 16-byte allocation blocks.
 *
 */
static inline u32 DynAnimeAlign16Blocks(u32 n) {
    if (n & 0xF) {
        return (n >> 4) + 1;
    }

    return n >> 4;
}

static int _V2(dc2::script::TagArguments stack, int argc);
static int _NAME(dc2::script::TagArguments stack, int argc);
static int _BODY_SIZE(dc2::script::TagArguments stack, int argc);
static int _SCALE(dc2::script::TagArguments stack, int argc);
static int _MATERIAL_ANIME(dc2::script::TagArguments stack, int argc);
static int _POLY_NUM(dc2::script::TagArguments stack, int argc);
static int _OUTLINE(dc2::script::TagArguments stack, int argc);
static int _OBJECT_NAME(dc2::script::TagArguments stack, int argc);
static int _OBJECT_NAME2(dc2::script::TagArguments stack, int argc);
static int _VERTEX_ANIME(dc2::script::TagArguments stack, int argc);
static int _SHAPE_ANIME(dc2::script::TagArguments stack, int argc);
static int _KEY_START(dc2::script::TagArguments stack, int argc);
static int _KEY(dc2::script::TagArguments stack, int argc);
static int _KEY_END(dc2::script::TagArguments stack, int argc);
static int _SEQ(dc2::script::TagArguments stack, int argc);
static int _SEQ_END(dc2::script::TagArguments stack, int argc);
static int _CLOTH_START(dc2::script::TagArguments stack, int argc);
static int _CLOTH_END(dc2::script::TagArguments stack, int argc);
static int _POSITION(dc2::script::TagArguments stack, int argc);
static int _ROTATION(dc2::script::TagArguments stack, int argc);
static int _SE_START(dc2::script::TagArguments stack, int argc);
static int _SE(dc2::script::TagArguments stack, int argc);
static int _SELP(dc2::script::TagArguments stack, int argc);
static int _SE_END(dc2::script::TagArguments stack, int argc);
static int _MOTION_END(dc2::script::TagArguments stack, int argc);
static int _LOD_MODEL_START(dc2::script::TagArguments stack, int argc);
static int _LOD_MODEL_END(dc2::script::TagArguments stack, int argc);
static int _SEQ_START(dc2::script::TagArguments stack, int argument_count);

void CCharacter2::SetPosition(float *pos) {
    mgCObject::SetPosition(pos);
}

void CCharacter2::AddOutLine(char *name, COutLineDraw *line) {
    mgCFrame     *target = {};
    COutLineDraw *existing = {};
    COutLineDraw *last = {};
    COutLineDraw *next_line = {};

    if (name != nullptr) {
        target = this->CObjectFrame::frame;

        if (name[0] != 0) {
            target = target->SearchFrame(name);

            if (target == nullptr) {
                for (existing = outline; existing != nullptr; existing = existing->next) {
                    target = existing->frame->SearchFrame(name);

                    if (target != nullptr) {
                        break;
                    }
                }
            }
        }

        if (target != nullptr) {
            if (target->parent != nullptr) {
                mgCFrameAttr *attr = target->attr;

                if (attr != nullptr) {
                    attr->draw |= MG_FRAME_DRAW_SKIP_BY_PARENT;
                }
            }

            line->SetFrame(target);
            last = outline;

            if (last == nullptr) {
                outline = line;
                return;
            }

            if (last != nullptr) {
                do {
                    next_line = last->next;

                    if (next_line == nullptr) {
                        break;
                    }

                    last = next_line;
                } while (next_line != nullptr);
            }

            last->next = line;
        }
    }
}

void CCharacter2::CopyOutLine(CCharacter2 *other) {
    COutLineDraw *line = {};
    mgCTexture   *texture = {};

    if (other == nullptr) {
        return;
    }
    auto destination_resources = resource_state.Acquire<dc2::character::ResourceState>();
    auto source_resources = other->resource_state.Acquire<dc2::character::ResourceState>();
    if (!destination_resources || !source_resources) {
        return;
    }

    if (other->outline == nullptr) {
        return;
    }

    texture = other->outline->texture;

    if (texture == nullptr) {
        return;
    }

    auto state = *destination_resources;
    std::erase_if(state.producers, [](const auto &entry) { return entry.channel == dc2::character::ResourceChannel::ParentOutline; });
    for (const auto &producer : source_resources->producers) {
        if (producer.channel == dc2::character::ResourceChannel::Model || producer.channel == dc2::character::ResourceChannel::Copy ||
            producer.channel == dc2::character::ResourceChannel::Image || producer.channel == dc2::character::ResourceChannel::ParentOutline) {
            state.producers.push_back({dc2::character::ResourceChannel::ParentOutline, producer.index, producer.lifetime});
        }
    }
    if (!dc2::character::PublishResources(*this, std::move(state))) {
        return;
    }
    for (line = outline; line != nullptr; line = line->next) {
        line->texture = texture;
    }
}

int CCharacter2::Draw() {
    sceVu0FVECTOR world_position;
    float         draw_alpha = {};
    float         clip_alpha = {};
    int           count = {};
    int           i = {};

    if (!CheckDraw()) {
        return 0;
    }

    draw_alpha = alpha;

    if (!FarClip(mgGetDistFromCamera(position), &clip_alpha)) {
        return 0;
    }

    draw_alpha *= clip_alpha;

    if (CObjectFrame::frame != nullptr) {
        CObjectFrame::frame->SetPosition(position);
        CObjectFrame::frame->SetRotation(rotation);
        CObjectFrame::frame->SetScale(scale);
        CObjectFrame::frame->GetWorldPosition0(world_position);
    }

    SetDeformMesh();
    count = 0;

    if (CObjectFrame::frame != nullptr) {
        CObjectFrame::frame->SetAttrParamObjAlpha(draw_alpha, 1);
    }

    count += mgDraw(CObjectFrame::frame);

    for (i = 0; i < dynamic_anime_num; i++) {
        count += dynamic_anime[i].DrawSub(0);
    }

    return count;
}

void CCharacter2::SetDeformMesh() {
    sceVu0FVECTOR max;
    sceVu0FVECTOR min;
    int           i = {};

    for (i = 0; i < deform_frame_num; i++) {
        if (deform_frame[i] != nullptr) {
            deform_frame[i]->RemakeBBox(max, min);
        }
    }
}

void CCharacter2::DrawStep() {
    float clip_alpha = {};

    FarClip(GetCameraDist(), &clip_alpha);
}

float CCharacter2::GetCameraDist() {
    sceVu0FVECTOR head_position;
    sceVu0FVECTOR camera_position;
    sceVu0FVECTOR closest_position;
    float         height = {};

    height = body_height;

    if (height < 1.0f) {
        height = 34.0f;
    }

    std::memmove(head_position, position, sizeof(u_long128));
    head_position[1] += height;
    mgGetCameraPos(camera_position);
    return mgDistLinePoint(camera_position, position, head_position, closest_position);
}

int CCharacter2::DrawDirect() {
    float world_pos[4];
    std::memmove(world_pos, position, sizeof world_pos);

    COutLineDraw  lod_line;
    float         entry_pos[4];
    float         view_pos[4];
    float         step_alpha = {};
    COutLineDraw *line = {};
    CCharaLOD    *lod_entry = {};
    mgCFrame     *lod_frame = {};
    float         alpha = {};
    float         camera_dist = {};
    float         fade = {};
    int           lod_no = {};
    int           count = {};
    int           i = {};
    int           j = {};

    alpha = this->alpha;
    camera_dist = GetCameraDist();

    if (!FarClip(camera_dist, &step_alpha)) {
        return 0;
    }

    alpha *= step_alpha;

    if (!CheckDraw()) {
        return 0;
    }

    if (CObjectFrame::frame != nullptr) {
        CObjectFrame::frame->SetPosition(position);
        CObjectFrame::frame->SetRotation(rotation);
        CObjectFrame::frame->SetScale(scale);
        CObjectFrame::frame->GetWorldPosition0(world_pos);
    }

    lod_no = 0;

    for (j = 0; j < lod_num - 1; j++) {
        if (lod[j].distance < camera_dist) {
            lod_no = j + 1;
        }
    }

    if (lod_no >= lod_num) {
        lod_no = lod_num - 1;
    }

    lod_frame = ChangeLOD(lod_no);
    line = outline;

    if (lod_frame != nullptr) {
        if (line == nullptr) {
            return mgDrawDirect(lod_frame);
        }

        lod_line = *line;
        lod_line.next = nullptr;
        lod_line.SetFrame(lod_frame);
        line = &lod_line;
    }

    SetDeformMesh();
    count = 0;

    if (line != nullptr) {
        fade = 1.0f;

        if (entry_frame[0] != nullptr) {
            GetEntryObjectPos(0, entry_pos);
        } else {
            std::memmove(entry_pos, world_pos, sizeof(u_long128));
            entry_pos[3] = 1.0f;
        }

        mgTransWorldView(view_pos, entry_pos);

        if (!(view_pos[2] <= 10.0f)) {
            fade = 1.0f - (view_pos[2] - 10.0f) / 300.0f;

            if (fade < 0.0f) {
                fade = 0.0f;
            }
        }

        if (alpha < 1.0f) {
            COutLineDraw *walk = outline;

            while (walk != nullptr) {
                if (walk->frame != nullptr) {
                    mgCFrameAttr *attr = walk->frame->attr;

                    if (attr != nullptr) {
                        attr->draw &= ~MG_FRAME_DRAW_SKIP_BY_PARENT;
                    }
                }

                walk = walk->next;
            }

            line = outline;
            if (line != nullptr) {
                count += line->Draw(position, fade, alpha);
            }

            while (line != nullptr) {
                if (line->frame != nullptr) {
                    mgCFrameAttr *attr = line->frame->attr;

                    if (attr != nullptr) {
                        attr->draw |= MG_FRAME_DRAW_SKIP_BY_PARENT;
                    }
                }

                line = line->next;
            }
        } else {
            while (line != nullptr) {
                if (line != nullptr) {
                    count += line->Draw(position, fade, alpha);
                }
                line = line->next;
            }
        }
    } else {
        if (CObjectFrame::frame != nullptr) {
            CObjectFrame::frame->SetAttrParamObjAlpha(alpha, 1);
        }

        count += mgDrawDirect(CObjectFrame::frame);
    }

    for (i = 0; i < dynamic_anime_num; i++) {
        count += dynamic_anime[i].DrawSub(1);
    }

    return count;
}

int CCharacter2::DrawShadowDirect() {
    if (!show) {
        return 0;
    }

    if (!CheckDraw()) {
        return 0;
    }

    if (shadow_frame == nullptr) {
        return 0;
    }

    CCharacter2::ShadowStep();
    shadow_frame->SetPosition(position);
    shadow_frame->SetRotation(rotation);
    shadow_frame->SetScale(scale);

    if (now_set >= 0 && now_set < CHARA_MOTION_SET_MAX) {
        DeformMesh(shadow_frame, &shadow_motion[now_set], shadow_frame_info_view, false);
    }

    return mgDrawDirect(shadow_frame);
}

void CCharacter2::UpdatePosition() {
    if (CObjectFrame::frame != nullptr) {
        CObjectFrame::frame->SetPosition(position);
        CObjectFrame::frame->SetRotation(rotation);
        CObjectFrame::frame->SetScale(scale);
    }

    if (shadow_frame != nullptr) {
        shadow_frame->SetPosition(position);
        shadow_frame->SetRotation(rotation);
        shadow_frame->SetScale(scale);
    }
}

void CCharacter2::ResetDAPosition() {
    int i = {};

    UpdatePosition();

    if (dynamic_anime_num == 0 || dynamic_anime == nullptr) {
        return;
    }

    for (i = 0; i < dynamic_anime_num; i++) {
        dynamic_anime[i].ResetPosition();
    }
}

float CCharacter2::GetDefaultStep() {
    if (now_key != nullptr) {
        return now_key->step;
    }

    return 0.0f;
}

void CCharacter2::SetStep(float frame_step) {
    step = frame_step;
}

void CCharacter2::ResetMotion() {
    now_key = nullptr;
    next_key = nullptr;
    now_seq = nullptr;
    next_seq = nullptr;
}

float CCharacter2::GetChgStepWait() {
    if (motion_status != CHARA_MOTION_STATUS_BLEND) {
        return -1.0f;
    }

    return blend;
}

int CCharacter2::CheckMotionEnd() {
    if (now_key == nullptr) {
        return true;
    }

    float margin = PAL_TIMING(1.2f, 1.0f) * step;

    if (frame <= now_key->end_frame && !(frame + 2.0f * margin < now_key->end_frame)) {
        return true;
    }

    return false;
}

void CCharacter2::SetMotion(int no, int flags) {
    CHRINFO_KEY_SET *key = {};
    int              set = {};

    key = GetKeyListIndexPtr(no, &set);

    if (key != nullptr) {
        next_key = key;
        next_flags = flags;
        next_set = set;
        blend_speed = 0.2f;
        seq_mode = false;
        now_seq = nullptr;
        seq_state = CHARA_SEQ_STATE_NONE;
    }
}

void CCharacter2::SetMotion(char *name, int flags) {
    SetMotionPara(name, flags, -1);
}

void CCharacter2::SetNowFrameWeight(float weight) {
    float range = {};

    if (now_key != nullptr) {
        if (weight < 0.0f) {
            weight = 0.0f;
        }

        if (weight > 1.0f) {
            weight = 1.0f;
        }

        range = static_cast<float>(now_key->end_frame - now_key->start_frame);
        SetNowFrame(static_cast<float>(now_key->start_frame) + range * weight);
    }
}

void CCharacter2::SetMotionPara(char *name, int flags, int keep_seq) {
    CHRINFO_KEY_SET    *key = {};
    CHRINFO_SEQ_HEADER *sequence = {};
    int                 set = {};

    key = GetKeyListPtr(name, &set);

    if (key != nullptr) {
        next_key = key;
        next_flags = flags;
        next_set = set;
        blend_speed = 0.2f;

        if (keep_seq == -1 || keep_seq == 0) {
            seq_mode = false;
            now_seq = nullptr;
            seq_state = CHARA_SEQ_STATE_NONE;
        }
    } else {
        sequence = GetSeqHeaderPtr(name, &set);

        switch ((uptr) sequence) {
            case 0:
                break;
            default:
                next_seq = sequence;
                seq_mode = true;
                seq_flags = flags;
        }
    }
}

void CCharacter2::SetDAnimeEnable(int enable) {
    if (enable) {
        dynamic_anime_flags &= ~CHARA_DYNAMIC_ANIME_DISABLE;
    } else {
        dynamic_anime_flags |= CHARA_DYNAMIC_ANIME_DISABLE;
    }
}

CHRINFO_SE *CCharacter2::GetSoundInfoCopy(mgCMemory *memory) {
    if (memory == nullptr || se_num[0] <= 0 || se_list[0] == nullptr || !dc2::character::SoundsLive(*this, 0)) {
        return nullptr;
    }

    const auto blocks = dc2::memory::ArrayQuadwords<CHRINFO_SE>(static_cast<std::size_t>(se_num[0]));
    if (!blocks || *blocks > std::numeric_limits<int>::max() - 2 || memory->lock != 0 ||
        memory->stGetRest() <= *blocks + 2) {
        return nullptr;
    }
    auto *storage = AllocateCharacterStorage(memory, static_cast<std::size_t>(*blocks) + 2);
    if (storage == nullptr) {
        return nullptr;
    }
    auto *copy = new (storage) CHRINFO_SE[se_num[0]];
    dc2::memory::CopyTrackedBytes(copy, se_list[0], static_cast<std::size_t>(se_num[0]) * sizeof(CHRINFO_SE));
    return copy;
}

int CCharacter2::CheckFootEffect() {
    if (sound_info.foot_effect_wait <= 0) {
        return -1;
    }

    return sound_info.foot_sound_id;
}

void CCharacter2::SePlay() {
    CHRINFO_SE *key = {};
    float       pos[4];
    float       passed = {};
    float       low = {};
    float       high = {};
    int         i = {};

    if (sound_info.foot_effect_wait > 0) {
        sound_info.foot_effect_wait--;
    }

    float now = frame;
    passed = PAL_TIMING(1.6f * (1.2f * step), 1.5f * step);
    key = se_list[now_set];
    low = now - passed;
    high = now + passed;

    if (key == nullptr) {
        return;
    }

    sound_info.se_volume = 1.0f;
    sound_info.se_pan = 0.0f;
    i = 0;

    if (sound_info.se_positional == CHARA_SE_POSITIONAL_HEAD) {
        GetEntryObjectPos(0, pos);
        float far_dist = 1200.0f;
        float near_dist = 160.0f;
        sndGetVolPan(&sound_info.se_volume, &sound_info.se_pan, pos, 160.0f, 1200.0f);
    }

    for (i = 0; i < se_num[now_set]; key++, i++) {
        if (key->loop_slot > 0) {
            if (!(frame < key->frame) && frame <= key->end_frame) {
                if (key->kind == CHRINFO_SE_SOUND) {
                    if (sound_info.loop_se != nullptr) {
                        sound_info.loop_se->SeLoopPlayStop(sound_info.se_bank, key->se_no, key->loop_slot,
                                                           13);
                    }
                }

                if (key->kind == CHRINFO_SE_SOUND_2) {
                    if (sound_info.loop_se != nullptr) {
                        sound_info.loop_se->SeLoopPlayStop(sound_info.se_bank_2, key->se_no, key->loop_slot,
                                                           13);
                    }
                }
            }

            key->wait = 0;
        } else if (low < key->frame && !(high <= key->frame) && key->wait == 0) {
            if (key->kind < CHRINFO_SE_SOUND && sound_info.foot_sound_enable) {
                if (sound_info.foot_sound_id >= 0) {
                    sndSePlayVPf(sound_info.foot_se_bank, key->kind + sound_info.foot_sound_id * 2, sound_info.se_volume, sound_info.se_pan, 0);
                }

                sound_info.foot_effect_wait = 1;
                key->wait = 6;
            }

            if (key->kind == CHRINFO_SE_SOUND) {
                sndSePlayVPf(sound_info.se_bank, key->se_no, sound_info.se_volume, sound_info.se_pan, 0);
                key->wait = 6;
            }

            if (key->kind == CHRINFO_SE_SOUND_FOOT) {
                sndSePlayVPf(sound_info.se_bank, key->se_no, sound_info.se_volume, sound_info.se_pan, 0);
                key->wait = 6;
                sound_info.foot_effect_wait = 1;
            }

            if (key->kind == CHRINFO_SE_SOUND_2) {
                sndSePlayVPf(sound_info.se_bank_2, key->se_no, sound_info.se_volume, sound_info.se_pan, 0);
                key->wait = 6;
            }
        }

        if (key->wait > 0) {
            key->wait--;
        }
    }
}

void CCharacter2::Step() {
    float        matrix[4][4];
    int          sequence_done = {};
    int          reset_dynamic_anime = {};
    int          motion_state = {};
    int          step_flags = {};
    float        entry_angle = {};
    CHRINFO_SEQ *playing = {};
    float       *entry_pos = {};

    if (!CheckDraw()) {
        return;
    }

    UpdatePosition();

    if (!motion_enable) {
        return;
    }

    SePlay();

    if (!seq_mode) {
        NormalDrive();
    }

    if (seq_mode == true) {
        if (next_seq != now_seq) {
            now_seq = next_seq;
            seq_step = nullptr;
            seq_loop = 0;
            seq_advance = 0;
            seq_state = CHARA_SEQ_STATE_NONE;

            if (now_seq != nullptr) {
                seq_step = now_seq->seq;

                if (seq_step != nullptr) {
                    seq_state = CHARA_SEQ_STATE_START;
                    step_flags = seq_flags;

                    switch (seq_step->type) {
                        case CHRINFO_SEQ_LOOP:
                            seq_loop = seq_step->loop_count;
                            break;
                        default:
                        case CHRINFO_SEQ_ONCE:
                        case CHRINFO_SEQ_HOLD_WAIT:
                            step_flags |= CHARA_MOTION_HOLD;
                            break;
                        case CHRINFO_SEQ_WAIT:
                        case CHRINFO_SEQ_LOOP_WAIT:
                            break;
                    }

                    SetMotionPara(seq_step->name, step_flags, 1);
                    blend_speed = seq_step->blend_speed;

                    if (!(blend_speed < 1.0f)) {
                        blend = 1.0f;
                    }

                    NormalDrive();
                    return;
                }
            }
        }

        if (now_seq == nullptr) {
            return;
        }

        if (seq_step == nullptr) {
            return;
        }

        seq_state = CHARA_SEQ_STATE_PLAY;
        sequence_done = false;
        motion_state = GetMotionStatus();

        switch (seq_step->type) {
            case CHRINFO_SEQ_ONCE:
                if (motion_state == CHARA_MOTION_STATUS_END) {
                    sequence_done = true;
                }

                break;
            case CHRINFO_SEQ_LOOP:
                if (motion_state == CHARA_MOTION_STATUS_END) {
                    seq_loop--;

                    if (seq_loop <= 0) {
                        sequence_done = true;
                    }
                }

                break;
            case CHRINFO_SEQ_HOLD_WAIT:
            case CHRINFO_SEQ_LOOP_WAIT:
                if (motion_state == CHARA_MOTION_STATUS_END) {
                    seq_state = CHARA_SEQ_STATE_WAIT;

                    if (seq_advance != 0) {
                        sequence_done = true;
                    }
                }

                break;
            case CHRINFO_SEQ_WAIT:
                seq_state = CHARA_SEQ_STATE_WAIT;

                if (seq_advance != 0) {
                    sequence_done = true;
                }

                break;
        }

        if (sequence_done) {
            playing = seq_step;

            if (playing[1].name[0] == 0) {
                seq_state = CHARA_SEQ_STATE_END;
                return;
            }

            seq_step = playing + 1;
            seq_loop = 0;
            seq_advance = 0;

            if (seq_step != nullptr) {
                step_flags = 0;

                switch (seq_step->type) {
                    case CHRINFO_SEQ_LOOP:
                        seq_loop = seq_step->loop_count;
                        break;
                    case CHRINFO_SEQ_ONCE:
                    case CHRINFO_SEQ_HOLD_WAIT:
                        step_flags = CHARA_MOTION_HOLD;
                        break;
                    case CHRINFO_SEQ_WAIT:
                    case CHRINFO_SEQ_LOOP_WAIT:
                        break;
                }

                SetMotionPara(seq_step->name, step_flags, 1);
                blend_speed = seq_step->blend_speed;

                if (!(blend_speed < 1.0f)) {
                    blend = 1.0f;
                }
            }
        }

        NormalDrive();
    }

    reset_dynamic_anime = false;
    GetEntryObjectPos(0, matrix);
    entry_pos = matrix[3];

    if (mgDistVector(entry_pos, entry_matrix[3]) > 20.0f) {
        reset_dynamic_anime = true;
    }

    if (!reset_dynamic_anime) {
        entry_angle = atan2f(matrix[2][0], matrix[2][2]);

        if (mgAngleCmp(entry_angle, atan2f(entry_matrix[2][0], entry_matrix[2][2]), QUARTER_PI) != 0) {
            reset_dynamic_anime = true;
        }
    }

    std::memmove(entry_matrix[0], matrix[0], sizeof(u_long128));
    std::memmove(entry_matrix[1], matrix[1], sizeof(u_long128));
    std::memmove(entry_matrix[2], matrix[2], sizeof(u_long128));
    std::memmove(entry_matrix[3], entry_pos, sizeof(u_long128));

    if (reset_dynamic_anime) {
        ResetDAPosition();
    }

    StepDA(1);
    CtrlEffect();
}

void CCharacter2::StepDA(int count) {
    int index = {};
    int iteration = {};

    if (dynamic_anime_flags & CHARA_DYNAMIC_ANIME_DISABLE) {
        return;
    }

    if (dynamic_anime_num == 0 || dynamic_anime == nullptr) {
        return;
    }

    for (index = 0; index < dynamic_anime_num; index++) {
        if (count < 0) {
            dynamic_anime[index].ResetPosition();
        } else {
            for (iteration = 0; iteration < count; iteration++) {
                dynamic_anime[index].Step();
            }
        }
    }
}

void CCharacter2::SetWind(float power, float *dir) {
    int index = {};

    for (index = 0; index < dynamic_anime_num; index++) {
        dynamic_anime[index].SetWind(power, dir);
    }
}

void CCharacter2::ResetWind() {
    int index = {};

    for (index = 0; index < dynamic_anime_num; index++) {
        dynamic_anime[index].ResetWind();
    }
}

void CCharacter2::SetFloor(float y) {
    int index = {};

    for (index = 0; index < dynamic_anime_num; index++) {
        dynamic_anime[index].SetFloor(y);
    }
}

void CCharacter2::ResetFloor() {
    int index = {};

    for (index = 0; index < dynamic_anime_num; index++) {
        dynamic_anime[index].ResetFloor();
    }
}

void CCharacter2::NormalDrive() {
    float frame_step = {};
    float motion_speed = PAL_TIMING(1.2f, 1.0f);

    if (next_key != now_key && next_key != nullptr) {
        posed_key = now_key;
        prev_flags = now_flags;
        prev_set = now_set;
        prev_frame = frame;
        now_key = next_key;
        step = now_key->step;
        now_set = next_set;
        now_flags = next_flags;
        blend = 0.1f;
        motion_status = CHARA_MOTION_STATUS_START;

        if (next_flags & CHARA_MOTION_RESTART) {
            posed_key = next_key;
            frame = now_key->start_frame;
        }

        ExecEntryEffect(now_key);
    } else if (now_flags != next_flags && next_key != nullptr) {
        now_flags = next_flags;

        if (next_flags & CHARA_MOTION_RESTART) {
            motion_status = CHARA_MOTION_STATUS_START;
            posed_key = next_key;
            frame = now_key->start_frame;
        }
    }

    if (now_key == nullptr) {
        return;
    }

    if (posed_key == now_key) {
        frame_step = step * motion_speed;

        if (now_flags & CHARA_MOTION_PAUSE) {
            frame_step = 0.0f;
        }

        frame += frame_step;

        if (!(frame_step <= 0.0f)) {
            motion_status = CHARA_MOTION_STATUS_PLAY;
        }

        if (frame < now_key->start_frame + step * motion_speed && !(frame < now_key->start_frame)) {
            frame = now_key->start_frame;
            motion_status = CHARA_MOTION_STATUS_START;
        }

        if (!(frame + step * motion_speed <= now_key->end_frame)) {
            if (now_flags & CHARA_MOTION_HOLD) {
                frame = now_key->end_frame;
                motion_status = CHARA_MOTION_STATUS_END;
                step = 0.0f;
            } else {
                frame = now_key->start_frame;
                motion_status = CHARA_MOTION_STATUS_END;
                ExecEntryEffect(now_key);
            }
        }
    }

    if (posed_key == now_key) {
        frame_ratio = now_key->end_frame - now_key->start_frame;
        frame_ratio = (frame - now_key->start_frame) / frame_ratio;
        SetMotionTime(CObjectFrame::frame, &motion[now_set], frame, nullptr);
        return;
    }

    if (!(blend < 1.0f)) {
        posed_key = now_key;
        frame = now_key->start_frame;
        motion_status = CHARA_MOTION_STATUS_START;
        return;
    }

    frame_ratio = 0.0f;
    motion_status = CHARA_MOTION_STATUS_BLEND;
    ChangeMotion(CObjectFrame::frame, &motion[now_set], static_cast<int>(0.9f + frame), now_key->start_frame, blend, nullptr);
    blend += blend_speed;

    if (!(blend < 1.0f)) {
        posed_key = now_key;
        frame = now_key->start_frame;
        motion_status = CHARA_MOTION_STATUS_START;
    }
}

void CCharacter2::ShadowStep() {
    int       i = {};
    mgCFrame *source = {};
    mgCFrame *root = {};
    mgCFrame *shadow = {};
    float     matrix[4][4];
    float     scale_vec[4];

    if (shadow_frame != nullptr && CheckDraw() && motion_enable && now_key != nullptr) {
        root = CObjectFrame::frame;

        for (i = 0; i < shadow_link.num; i++) {
            source = root->GetFrame(shadow_link.src_frame[i]);

            if (source != nullptr) {
                shadow = shadow_frame->GetFrame(shadow_link.dst_frame[i]);

                if (shadow != nullptr) {
                    source->GetScale(scale_vec);
                    sceVu0CopyMatrix(matrix, source->trans_matrix);
                    shadow->SetTransMatrix(matrix);
                    shadow->SetScale(scale_vec);
                }
            }
        }
    }
}

CHRINFO_KEY_SET *CCharacter2::GetKeyListIndexPtr(int motion_no, int *out_list) {
    int              number = {};
    int              list = {};
    int              i = {};
    CHRINFO_KEY_SET *key = {};

    number = 0;
    list = 0;

    do {
        key = key_list[list];

        if (key != nullptr) {
            for (i = 0; i < key_num[list]; i++) {
                if (key->name[0] == 0) {
                    break;
                }

                if (number == motion_no) {
                    if (out_list != nullptr) {
                        *out_list = list;
                    }

                    return key;
                }

                key++;
                number++;
            }
        }

        list++;
    } while (list < CHARA_MOTION_SET_MAX);

    return nullptr;
}

CHRINFO_KEY_SET *CCharacter2::GetKeyListPtr(char *name, int *out_list) {
    CHRINFO_KEY_SET *entry = {};
    int              list = 0;
    int              i = {};

    do {
        entry = key_list[list];

        if (entry != nullptr) {
            for (i = 0; i < key_num[list]; i++) {
                if (entry->name[0] == 0) {
                    break;
                }

                if (strcmp(entry->name, name) == 0) {
                    if (out_list != nullptr) {
                        *out_list = list;
                    }

                    return entry;
                }

                entry++;
            }
        }

        list++;
    } while (list < CHARA_MOTION_SET_MAX);

    return nullptr;
}

CHRINFO_SEQ_HEADER *CCharacter2::GetSeqHeaderPtr(char *name, int *out_list) {
    CHRINFO_SEQ_HEADER *header = {};
    int                 list = 0;

    do {
        header = seq_list[list];

        if (header != nullptr) {
            while (header != nullptr) {
                if (strcmp(header->name, name) == 0) {
                    if (out_list != nullptr) {
                        *out_list = list;
                    }

                    return header;
                }

                header = header->next;
            }
        }

        list++;
    } while (list < CHARA_MOTION_SET_MAX);

    return nullptr;
}

int CCharacter2::GetEntryObjectPos(int index, float *out) {
    mgCFrame *entry = {};

    GetPosition(out);

    if (index < 0 || index > 2) {
        return false;
    }

    entry = entry_frame[index];

    if (entry == nullptr) {
        return false;
    }

    entry->GetWorldPosition0(out);
    return true;
}

int CCharacter2::GetEntryObjectPos(int index, float (*out)[4]) {
    mgCFrame *entry = {};
    float     position[4];
    float     rotation[4];

    if (index < 0 || index > 2) {
        index = 0;
    }

    entry = entry_frame[index];

    if (entry == nullptr) {
        GetPosition(position);
        GetRotation(rotation);
        mgCreateMatrixPY(out, position, rotation[1]);
        return false;
    }

    entry->GetLWMatrix(out);
    return true;
}

CHARA_ENTRY_OBJECT *CCharacter2::GetEntryObjectPos(int id, int nth, float *out) {
    int found = {};
    int i = {};

    GetPosition(out);

    if (nth < 0 || nth > CHARA_ENTRY_OBJECT_MAX) {
        return nullptr;
    }

    found = -1;
    i = 0;

    for (; i < CHARA_ENTRY_OBJECT_MAX; i++) {
        if (entry_object[i].frame != nullptr && entry_object[i].group == id) {
            found++;
        }

        if (found == nth) {
            entry_object[i].frame->GetWorldPosition0(out);
            return &entry_object[i];
        }
    }

    return nullptr;
}

float CCharacter2::GetWaitToFrame(char *name, float wait) {
    float wait_frame = 0.0f;

    CHRINFO_KEY_SET *key = nowChr->GetKeyListPtr(name, nullptr);

    if (key != nullptr) {
        wait_frame = static_cast<float>(key->start_frame) + wait * (static_cast<float>(key->end_frame) - static_cast<float>(key->start_frame));
    }

    return wait_frame;
}

void CCharacter2::LoadPack(unsigned int *pack, const char *name, mgCMemory *model_stack, mgCMemory *motion_stack, mgCMemory *image_stack, int image_block, CCharacter2 *parent) {
    LoadChrFile(pack, name, model_stack, motion_stack, image_stack, image_block, parent, 1);
}

void CCharacter2::LoadPackNoLine(unsigned int *pack, const char *name, mgCMemory *model_stack, mgCMemory *motion_stack, mgCMemory *image_stack, int image_block, CCharacter2 *parent) {
    LoadChrFile(pack, name, model_stack, motion_stack, image_stack, image_block, parent, 0);
}

void CCharacter2::Initialize() {
    int j = {};
    int i = {};

    CObjectFrame::Initialize();
    resource_state = {};
    velocity[2] = 0.0f;
    velocity[1] = 0.0f;
    velocity[0] = 0.0f;
    velocity[3] = 1.0f;
    base_scale[3] = 1.0f;
    base_scale[2] = 1.0f;
    base_scale[1] = 1.0f;
    base_scale[0] = 1.0f;
    move_accel = 0.0f;
    alpha = 1.0f;
    mgUnitMatrix(entry_matrix);
    CObjectFrame::frame = nullptr;
    load_size = 0;
    copy_size = 0;
    shadow_poly_num = 0;
    poly_num = 0;
    dynamic_anime_flags = 0;
    outline = nullptr;
    shadow_frame = nullptr;
    frame = 0;
    main_frame_info = nullptr;
    motion_status = CHARA_MOTION_STATUS_NONE;
    shape_anime = 0;
    sound_info.foot_sound_id = -1;
    sound_info.foot_sound_enable = true;
    sound_info.se_positional = CHARA_SE_POSITIONAL_HEAD;
    sound_info.se_volume = 1.0f;
    sound_info.se_pan = 0.0f;
    sound_info.foot_effect_wait = -1;
    sound_info.loop_se = nullptr;

    for (i = 0; i < CHARA_MOTION_SET_MAX; i++) {
        se_list[i] = nullptr;
        se_num[i] = 0;
    }

    sword_effect[0] = nullptr;
    sword_effect[1] = nullptr;
    sword_effect[2] = nullptr;
    dynamic_anime_num = 0;
    dynamic_anime = nullptr;

    for (i = 0; i < CHARA_IMAGE_MAX; i++) {
        images[i] = nullptr;
    }

    tex_anime_group_num = 0;
    tex_anime_group_start = 0;
    entry_frame[0] = nullptr;
    entry_frame[1] = nullptr;

    for (i = 0; i < CHARA_ENTRY_OBJECT_MAX; i++) {
        entry_object[i].frame = nullptr;
        entry_object[i].size = 0.0f;
        entry_object[i].group = -1;
        entry_object[i].enable = false;
    }

    for (j = 0; j < CHARA_DEFORM_FRAME_MAX; j++) {
        deform_frame[j] = nullptr;
    }

    deform_frame_num = 0;

    for (i = 0; i < CHARA_MOTION_SET_MAX; i++) {
        key_list[i] = nullptr;
        key_num[i] = 0;
        seq_list[i] = nullptr;
    }

    for (auto &state : motion) {
        state = {};
    }
    for (auto &state : shadow_motion) {
        state = {};
    }
    now_set = 0;
    next_set = 0;
    next_key = nullptr;
    now_key = nullptr;
    posed_key = nullptr;
    next_seq = nullptr;
    now_seq = nullptr;
    seq_step = nullptr;
    main_frame_info = nullptr;
    shadow_frame_info = nullptr;
    shadow_frame_info_view = {};
    lod_num = 0;
    lod = nullptr;
    lod_no = -1;
    motion_enable = true;
    shadow_link.num = 0;
    shadow_link.dst_frame = nullptr;
    shadow_link.src_frame = nullptr;
    InitEffect();
}

/**
 *
 * Accepts the character script version marker.
 *
 */
int _V2(dc2::script::TagArguments stack, int argc) {
    return true;
}

/**
 *
 * Accepts the character name script tag.
 *
 */
int _NAME(dc2::script::TagArguments stack, int argc) {
    return true;
}

/**
 *
 * Sets character body dimensions from script values.
 *
 */
int _BODY_SIZE(dc2::script::TagArguments stack, int argc) {
    auto next = stack + 1;

    if (nowChr == nullptr) {
        return false;
    }

    const float height = static_cast<float>(dc2::script::TagInteger(stack));
    const float width = static_cast<float>(dc2::script::TagInteger(next++));
    const float depth = static_cast<float>(dc2::script::TagInteger(next));
    nowChr->body_height = height;
    nowChr->body_width = width;
    nowChr->body_depth = depth;
    return true;
}

/**
 *
 * Sets the base scale of the character model and shadow.
 *
 */
int _SCALE(dc2::script::TagArguments stack, int argc) {
    if (nowChr == nullptr) {
        return false;
    }

    dc2::script::TagVector(nowChr->base_scale, stack);
    nowChr->base_scale[3] = 1.0f;

    if (nowChr->CObjectFrame::frame != nullptr) {
        nowChr->SetScale(nowChr->base_scale);
    }

    if (nowChr->shadow_frame != nullptr) {
        nowChr->shadow_frame->SetScale(nowChr->base_scale);
    }

    return true;
}

/**
 *
 * Accepts the material animation script tag.
 *
 */
int _MATERIAL_ANIME(dc2::script::TagArguments stack, int argc) {
    return true;
}

/**
 *
 * Sets polygon counts for the character model and shadow.
 *
 */
int _POLY_NUM(dc2::script::TagArguments stack, int argc) {
    nowChr->poly_num = 0;
    nowChr->shadow_poly_num = 0;

    if (argc > 0) {
        nowChr->poly_num += dc2::script::TagInteger(stack++);
    }

    if (argc == 2) {
        nowChr->shadow_poly_num += dc2::script::TagInteger(stack);
    }

    return true;
}

/**
 *
 * Loads and registers an outline effect for the character.
 *
 */
int _OUTLINE(dc2::script::TagArguments stack, int argc) {
    char               name[0x40];
    char               texture_name[0x20];
    auto               arg = stack + 1;
    float              width = {};
    mgCTextureManager *tex_manager = {};
    COutLineDraw      *outline = {};
    mgCTexture        *texture = {};

    if (!outline_flag) {
        return true;
    }

    dc2::text::Copy(name, dc2::text::View(dc2::script::TagCString(stack)));
    width = dc2::script::TagFloat(arg);
    tex_manager = &mgTexManager;

    if (tex_manager == nullptr || set_imgblock == -1 || base_stack == nullptr || nowChr == nullptr) {
        return false;
    }

    const int blocks = (sizeof(COutLineDraw) + sizeof(u_long128) - 1) / sizeof(u_long128);
    if (base_stack->stack == nullptr || base_stack->lock != 0 || base_stack->stGetRest() <= blocks) {
        return false;
    }
    outline = dc2::memory::NewObject<COutLineDraw>(*base_stack);
    if (outline == nullptr) {
        return false;
    }
    outline->width = width;

    if (!outline_start) {
        if (parent_chr != nullptr) {
            if (parent_chr->outline == nullptr) {
                return false;
            }

            if ((outline_start_tex = parent_chr->outline->texture) == nullptr) {
                return false;
            }
        } else {
            /**
             *
             * Identifier assigned to each newly allocated outline texture.
             *
             */
            static int outline_num = 1;
            if (outline_num == std::numeric_limits<int>::max()) {
                return false;
            }
            outline_num += 1;
            const int length = std::snprintf(texture_name, sizeof texture_name, "out_line2%d", outline_num);
            if (length < 0 || static_cast<std::size_t>(length) >= sizeof texture_name) {
                return false;
            }
            nowChr->outline_tex_no = outline_num;
            texture = tex_manager->EnterTexture(
                set_imgblock, texture_name, nullptr, mgScreenWidth, mgScreenHeight,
                mgScreenDepth, nullptr, 0, 0);
            outline_start_tex = texture;
            outline_start = true;

            if (texture == nullptr) {
                return false;
            }
        }
    }

    outline->texture = outline_start_tex;
    nowChr->AddOutLine(name, outline);
    return true;
}

/**
 *
 * Registers named model frames as character entry objects.
 *
 */
int _OBJECT_NAME(dc2::script::TagArguments stack, int argc) {
    char      name[0x40];
    int       frame_slot = -1;
    int       object_slot = {};
    int       n = {};
    int       i = {};
    int       j = {};
    mgCFrame *root = {};
    mgCFrame *found = {};

    for (i = 0; i < CHARA_ENTRY_FRAME_MAX; i++) {
        if (nowChr->entry_frame[i] == nullptr) {
            frame_slot = i;
            break;
        }
    }

    object_slot = -1;

    if (frame_slot == -1) {
        return false;
    }

    for (j = 0; j < CHARA_ENTRY_OBJECT_MAX; j++) {
        if (nowChr->entry_object[j].frame == nullptr) {
            object_slot = j;
            break;
        }
    }

    if (object_slot == -1) {
        return false;
    }

    root = nowChr->CObjectFrame::frame;

    if (root == nullptr) {
        return false;
    }

    for (n = 0; n < argc; n++) {
        if (frame_slot >= CHARA_ENTRY_FRAME_MAX || object_slot >= CHARA_ENTRY_OBJECT_MAX) {
            return false;
        }

        dc2::text::Copy(name, dc2::text::View(dc2::script::TagCString(stack++)));
        found = root->SearchFrame(name);

        if (found != nullptr) {
            nowChr->entry_frame[frame_slot++] = found;
            nowChr->entry_object[object_slot].frame = found;
            nowChr->entry_object[object_slot].size = 0.0f;
            nowChr->entry_object[object_slot].group = object_slot;
            nowChr->entry_object[object_slot++].enable = true;
        }
    }

    return true;
}

/**
 *
 * Registers grouped entry objects with frame values.
 *
 */
int _OBJECT_NAME2(dc2::script::TagArguments stack, int argc) {
    char      name[0x40];
    int       object_slot = -1;
    int       id = {};
    mgCFrame *root = {};
    int       pair_count = {};
    int       n = {};
    mgCFrame *found = {};
    float     value = {};
    int       i = {};

    for (i = 0; i < CHARA_ENTRY_OBJECT_MAX; i++) {
        if (nowChr->entry_object[i].frame == nullptr) {
            object_slot = i;
            break;
        }
    }

    if (object_slot == -1) {
        return false;
    }

    id = dc2::script::TagInteger(stack++);
    if (id < 0) {
        return false;
    }
    root = nowChr->CObjectFrame::frame;

    if (root == nullptr) {
        return false;
    }

    pair_count = (argc - 1) / 2;

    if (argc < 3) {
        pair_count = 1;
    }

    for (n = 0; n < pair_count; n++) {
        if (object_slot >= CHARA_ENTRY_OBJECT_MAX) {
            return false;
        }

        dc2::text::Copy(name, dc2::text::View(dc2::script::TagCString(stack++)));
        found = root->SearchFrame(name);
        value = 0.0f;

        if (id >= CHARA_ENTRY_FRAME_MAX) {
            value = dc2::script::TagFloat(stack++);
        } else if (argc >= 3) {
            value = dc2::script::TagFloat(stack++);
        }

        if (found != nullptr) {
            if (id < CHARA_ENTRY_FRAME_MAX) {
                nowChr->entry_frame[id] = found;
            }

            nowChr->entry_object[object_slot].frame = found;
            nowChr->entry_object[object_slot].size = value;
            nowChr->entry_object[object_slot].group = id;
            nowChr->entry_object[object_slot++].enable = true;
        }
    }

    return true;
}

/**
 *
 * Lists model frames whose vertices are animated.
 *
 */
int _VERTEX_ANIME(dc2::script::TagArguments stack, int argc) {
    int i = {};

    for (i = 0; i < argc; i++) {
        if (alloc_vertex_num >= CHARA_DEFORM_FRAME_MAX) {
            return false;
        }

        dc2::text::Copy(alloc_vertex[alloc_vertex_num++], dc2::text::View(dc2::script::TagCString(stack++)));
    }

    return true;
}

/**
 *
 * Sets the character shape animation mode.
 *
 */
int _SHAPE_ANIME(dc2::script::TagArguments stack, int argc) {
    if (argc != 1) {
        return false;
    }

    nowChr->shape_anime = dc2::script::TagInteger(stack);
    return true;
}

/**
 *
 * Begins the key frame list for the current motion.
 *
 */
int _KEY_START(dc2::script::TagArguments stack, int argc) {
    if (nowChr == nullptr || now_stack == nullptr || now_motion_id < 0 || now_motion_id >= CHARA_MOTION_SET_MAX) {
        return false;
    }
    key_entries.emplace();
    return true;
}

/**
 *
 * Adds a named key frame interval to the current motion.
 *
 */
int _KEY(dc2::script::TagArguments stack, int argc) {
    if (argc < 4 || !key_entries || now_stack == nullptr || now_stack->stGetRest() <= 0 ||
        key_entries->size() + 2 > static_cast<std::size_t>(now_stack->stGetRest()) * sizeof(u_long128) / sizeof(CHRINFO_KEY_SET)) {
        return false;
    }
    CHRINFO_KEY_SET entry{};
    const auto      name = dc2::script::TagText(stack++);
    entry.start_frame = dc2::script::TagInteger(stack++);
    entry.end_frame = dc2::script::TagInteger(stack++);
    entry.step = dc2::script::TagFloat(stack);
    if (!dc2::text::Copy(entry.name, name)) {
        return false;
    }
    key_entries->push_back(entry);
    return true;
}

/**
 *
 * Ends and allocates the current motion key frame list.
 *
 */
int _KEY_END(dc2::script::TagArguments stack, int argc) {
    if (!key_entries || now_stack == nullptr || nowChr == nullptr || now_motion_id < 0 || now_motion_id >= CHARA_MOTION_SET_MAX) {
        return false;
    }
    key_entries->push_back({.name = {}, .start_frame = -1, .end_frame = -1, .step = 0.0f});
    auto *entries = dc2::memory::NewArray<CHRINFO_KEY_SET>(*now_stack, key_entries->size());
    if (entries == nullptr) {
        key_entries.reset();
        return false;
    }
    std::copy(key_entries->begin(), key_entries->end(), entries);
    nowChr->key_list[now_motion_id] = entries;
    nowChr->key_num[now_motion_id] = static_cast<int>(key_entries->size());
    key_entries.reset();
    return true;
}

/**
 *
 * Allocates a named motion sequence and links it to the current motion.
 *
 */
static int _SEQ_START(dc2::script::TagArguments stack, int count) {
    if (count <= 0 || now_stack == nullptr || nowChr == nullptr || now_motion_id < 0 || now_motion_id >= CHARA_MOTION_SET_MAX) {
        return false;
    }
    const auto name = dc2::script::TagText(stack);
    if (name.size() >= sizeof(CHRINFO_SEQ_HEADER::name)) {
        return false;
    }
    auto *header = dc2::memory::NewObject<CHRINFO_SEQ_HEADER>(*now_stack);
    if (header == nullptr) {
        return false;
    }
    *header = {};
    dc2::text::Copy(header->name, name);
    if (now_seqhd_ptr == nullptr) {
        nowChr->seq_list[now_motion_id] = header;
    } else {
        now_seqhd_ptr->next = header;
    }
    now_seqhd_ptr = header;
    sequence_entries.emplace();
    return true;
}

/**
 *
 * Adds a named motion to the current sequence.
 *
 */
int _SEQ(dc2::script::TagArguments stack, int argc) {
    if (!sequence_entries || now_seqhd_ptr == nullptr || now_stack == nullptr || now_stack->stGetRest() <= 0 ||
        sequence_entries->size() + 2 > static_cast<std::size_t>(now_stack->stGetRest()) * sizeof(u_long128) / sizeof(CHRINFO_SEQ)) {
        return false;
    }
    CHRINFO_SEQ entry{};
    entry.type = CHRINFO_SEQ_ONCE;
    entry.loop_count = -1;
    entry.blend_speed = -1.0f;
    const auto name = dc2::script::TagText(stack++);
    if (argc >= 2) {
        entry.blend_speed = dc2::script::TagFloat(stack++);
    }
    if (argc >= 3) {
        entry.type = static_cast<u8>(dc2::script::TagInteger(stack++));
    }
    if (argc == 4) {
        entry.loop_count = dc2::script::TagInteger(stack);
    }
    if (!dc2::text::Copy(entry.name, name)) {
        return false;
    }
    sequence_entries->push_back(entry);
    return true;
}

/**
 *
 * Ends and allocates the current motion sequence.
 *
 */
int _SEQ_END(dc2::script::TagArguments stack, int argc) {
    if (!sequence_entries || now_seqhd_ptr == nullptr || now_stack == nullptr) {
        return false;
    }
    sequence_entries->push_back({.name = {}, .type = CHRINFO_SEQ_ONCE, .unk_23 = 0, .loop_count = -1, .blend_speed = -1.0f});
    auto *entries = dc2::memory::NewArray<CHRINFO_SEQ>(*now_stack, sequence_entries->size());
    if (entries == nullptr) {
        sequence_entries.reset();
        return false;
    }
    std::copy(sequence_entries->begin(), sequence_entries->end(), entries);
    now_seqhd_ptr->seq = entries;
    now_seqhd_ptr->seq_num = static_cast<int>(sequence_entries->size());
    sequence_entries.reset();
    return true;
}

/**
 *
 * Allocates dynamic animation objects for character cloth.
 *
 */
int _CLOTH_START(dc2::script::TagArguments stack, int argc) {
    int count = dc2::script::TagInteger(stack);

    if (count <= 0) {
        return false;
    }

    if (now_stack == nullptr || nowChr == nullptr) {
        return false;
    }
    auto *animations = dc2::memory::NewArray<CDynamicAnime>(*now_stack, static_cast<std::size_t>(count));
    if (animations == nullptr) {
        return false;
    }
    nowChr->dynamic_anime = animations;

    nowChr->dynamic_anime_num = count;
    return true;
}

CDynamicAnime::CDynamicAnime() {
    Initialize();
}

/**
 *
 * Accepts the end of the cloth animation list.
 *
 */
int _CLOTH_END(dc2::script::TagArguments stack, int argc) {
    return true;
}

/**
 *
 * Sets the initial character position from script values.
 *
 */
int _POSITION(dc2::script::TagArguments stack, int argc) {
    float x = dc2::script::TagFloat(stack++);
    float y = dc2::script::TagFloat(stack++);
    float z = dc2::script::TagFloat(stack);
    nowChr->SetPosition(x, y, z);
    return true;
}

/**
 *
 * Sets the initial character rotation from script values.
 *
 */
int _ROTATION(dc2::script::TagArguments stack, int argc) {
    float x = dc2::script::TagFloat(stack++);
    float y = dc2::script::TagFloat(stack++);
    float z = dc2::script::TagFloat(stack);
    nowChr->SetRotation(x, y, z);
    return true;
}

/**
 *
 * Allocates sound cue entries for the current motion.
 *
 */
int _SE_START(dc2::script::TagArguments stack, int argc) {
    if (nowChr == nullptr || now_stack == nullptr || now_motion_id < 0 ||
        now_motion_id >= CHARA_MOTION_SET_MAX || argc != 1) {
        return false;
    }
    now_se_header = nullptr;
    sound_entries_remaining = 0;
    nowChr->se_num[now_motion_id] = 0;
    nowChr->se_list[now_motion_id] = nullptr;

    const int count = dc2::script::TagInteger(stack);
    if (count < 0) {
        return false;
    }
    if (count == 0) {
        return dc2::character::MetadataScope::RegisterSounds(*now_stack, now_motion_id, {});
    }
    if (static_cast<std::size_t>(count) > std::numeric_limits<std::size_t>::max() / sizeof(CHRINFO_SE)) {
        return false;
    }
    const auto bytes = static_cast<std::size_t>(count) * sizeof(CHRINFO_SE);
    const auto blocks = (bytes + sizeof(u_long128) - 1) / sizeof(u_long128) + 2;
    if (blocks > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
        now_stack->stGetRest() <= 0 || blocks >= static_cast<std::size_t>(now_stack->stGetRest())) {
        return false;
    }
    auto *storage = AllocateCharacterStorage(now_stack, blocks);
    if (storage == nullptr) {
        return false;
    }
    nowChr->se_list[now_motion_id] = new (storage) CHRINFO_SE[count];
    nowChr->se_num[now_motion_id] = 0;
    now_se_header = nowChr->se_list[now_motion_id];
    sound_entries_remaining = count;
    return dc2::character::MetadataScope::RegisterSounds(*now_stack, now_motion_id, {nowChr->se_list[now_motion_id], static_cast<std::size_t>(count)});
}

/**
 *
 * Adds a sound cue at a frame of a named motion.
 *
 */
int _SE(dc2::script::TagArguments stack, int argc) {
    char *name = {};
    auto  arg = stack;
    int   kind = {};
    int   se_no = {};
    float frame = {};

    if (now_se_header == nullptr || sound_entries_remaining <= 0) {
        return false;
    }

    arg = stack + 1;

    if (argc != 4) {
        return false;
    }

    name = dc2::script::TagCString(stack);
    kind = dc2::script::TagInteger(arg++);
    se_no = dc2::script::TagInteger(arg++);
    frame = dc2::script::TagFloat(arg);

    if (frame <= 1.0f) {
        frame = nowChr->GetWaitToFrame(name, frame);
    }

    if (frame <= 0.0f) {
        return false;
    }

    now_se_header->frame = frame;
    now_se_header->end_frame = 0.0f;
    now_se_header->kind = kind;
    now_se_header->se_no = se_no;
    now_se_header->loop_slot = 0;
    now_se_header->wait = 0;
    now_se_header++;
    --sound_entries_remaining;
    ++nowChr->se_num[now_motion_id];
    return true;
}

/**
 *
 * Adds a timed loop sound cue to a named motion.
 *
 */
int _SELP(dc2::script::TagArguments stack, int argc) {
    char *name = {};
    auto  arg = stack;
    int   kind = {};
    int   se_no = {};
    float start = {};
    float end = {};
    int   loop_slot = {};
    float start_time = {};
    float end_time = {};

    if (now_se_header == nullptr || sound_entries_remaining <= 0) {
        return false;
    }

    arg = stack + 1;

    if (argc != 6) {
        return false;
    }

    name = dc2::script::TagCString(stack);
    kind = dc2::script::TagInteger(arg++);
    se_no = dc2::script::TagInteger(arg++);
    start = dc2::script::TagFloat(arg++);
    end = dc2::script::TagFloat(arg++);
    loop_slot = dc2::script::TagInteger(arg);

    if (start <= 1.0f) {
        start_time = nowChr->GetWaitToFrame(name, start);
    } else {
        start_time = start;
    }

    if (end <= 1.0f) {
        end_time = nowChr->GetWaitToFrame(name, end);
    } else {
        end_time = end;
    }

    if (start_time <= 0.0f || end_time <= 0.0f) {
        return false;
    }

    now_se_header->frame = start_time;
    now_se_header->end_frame = end_time;
    now_se_header->kind = kind;
    now_se_header->se_no = se_no;
    now_se_header->loop_slot = loop_slot;
    now_se_header->wait = 0;
    now_se_header++;
    --sound_entries_remaining;
    ++nowChr->se_num[now_motion_id];
    return true;
}

/**
 *
 * Accepts the end of the motion sound cue list.
 *
 */
int _SE_END(dc2::script::TagArguments stack, int argc) {
    return true;
}

/**
 *
 * Accepts the end of a character motion definition.
 *
 */
int _MOTION_END(dc2::script::TagArguments stack, int argc) {
    return true;
}

void CCharacter2::InitEffect() {
    int index = {};

    for (index = 0; index < CHARA_ENTRY_EFFECT_MAX; index++) {
        entry_effect[index].effect = nullptr;
        entry_effect[index].active = false;
        entry_effect[index].running = false;
    }

    effect_list = nullptr;
    effect_enable = true;
    effect_image_list = nullptr;
    effect_image_load = true;
}

void CCharacter2::ExecEntryEffect(CHRINFO_KEY_SET *key_set) {
    int             i = {};
    int             count = {};
    CHRINFO_EFFECT *node = {};

    for (i = 0; i < CHARA_ENTRY_EFFECT_MAX; i++) {
        if (entry_effect[i].active && entry_effect[i].running) {
            entry_effect[i].effect->Stop();
        }

        entry_effect[i].effect = nullptr;
        entry_effect[i].active = false;
        entry_effect[i].running = false;
    }

    if (!effect_enable) {
        return;
    }

    node = effect_list;

    if (key_set == nullptr) {
        return;
    }

    count = 0;

    while (node != nullptr) {

        if (strcmp(node->effect->motion_name, now_key->name) == 0) {
            entry_effect[count].effect = node->effect;
            entry_effect[count].active = true;
            count++;
        }

        node = node->next;
    }
}

void CCharacter2::CtrlEffect() {
    for (int i = 0; i < CHARA_ENTRY_EFFECT_MAX; i++) {
        if (!entry_effect[i].active) {
            continue;
        }

        if (entry_effect[i].running) {
            continue;
        }

        CHARA_EFFECT_MANAGER *manager = entry_effect[i].effect;
        CHRINFO_KEY_SET      *key = now_key;
        float                 progress = (frame - static_cast<float>(key->start_frame)) /
                                         (static_cast<float>(key->end_frame) - static_cast<float>(key->start_frame));

        if (progress > manager->start_ratio) {
            manager->Run();
            entry_effect[i].running = true;
        }
    }
}

void CCharacter2::StepEffect() {
    CHRINFO_EFFECT *effect = {};
    int             index = {};

    for (index = 0; index < CHARA_SWORD_EFFECT_MAX; index++) {
        if (sword_effect[index] != nullptr) {
            sword_effect[index]->Step();
            sword_effect[index]->CreatPointList();
        }
    }

    for (effect = effect_list; effect != nullptr; effect = effect->next) {
        effect->effect->Ctrl();
        effect->effect->Step(1);
    }
}

void CCharacter2::DrawEffect() {
    CHRINFO_EFFECT *effect = {};
    mgCFrame       *effect_frame = {};
    int             index = {};

    for (index = 0; index < CHARA_SWORD_EFFECT_MAX; index++) {
        if (sword_effect[index] != nullptr) {
            sword_effect[index]->Draw();
        }
    }

    for (effect = effect_list; effect != nullptr; effect = effect->next) {
        mgC3DSprite   sprite;
        sceVu0FMATRIX world_matrix;
        sceVu0FVECTOR world_position;
        mgUnitMatrix(world_matrix);
        world_position[3] = 0.0f;
        world_position[2] = 0.0f;
        world_position[1] = 0.0f;
        world_position[0] = 0.0f;

        if (strcmp(effect->effect->frame_name, "") != 0) {
            effect_frame = CObjectFrame::frame->SearchFrame(effect->effect->frame_name);

            if (effect_frame != nullptr) {
                effect_frame->GetWorldPosition0(world_position);
                sceVu0TransMatrix(world_matrix, world_matrix, effect->effect->offset);
                sceVu0RotMatrix(world_matrix, world_matrix, rotation);
                sceVu0TransMatrix(world_matrix, world_matrix, world_position);
            }
        }

        if (effect->effect->local_draw != 0) {
            effect->effect->CreatePacket(&sprite);
            mgDrawDirect(&sprite, world_matrix);
        } else {
            effect->effect->SetOrigin(world_matrix[3]);
            effect->effect->Draw();
        }
    }
}

/**
 *
 * Loads a frame model and rebinds its weighted visuals to a target model.
 *
 */
mgCFrame *CreateChangeFrame(mgLoadData *data, mgCFrame *target) {
    mgCFrame  *source = mgLoadMDSFile(data);
    char     **name = {};
    int        target_id = {};
    mgCVisual *visual = {};
    mgCFrame **frame_list = {};
    float (*matrix)[4][4] = {};
    int                 i = {};
    mgCreateVisualType *list = {};
    mgCFrame           *found = {};
    mgCreateVisualType *entry = {};
    int                 source_id = {};

    if (source == nullptr) {
        return nullptr;
    }

    list = data->visual_type;
    i = 0;

    for (;;) {
        entry = &list[i];

        if (entry->type == MG_VISUAL_CREATE_END) {
            break;
        }

        name = &entry->name;

        if (target->SearchFrame(*name) != nullptr) {
            found = source->SearchFrame(*name);

            if (found != nullptr) {
                visual = found->visual;

                if (visual != nullptr && visual->Iam() == MG_VISUAL_KIND_MOTION_MDT) {
                    target_id = target->SearchFrameID(*name);
                    source_id = source->SearchFrameID(*name);
                    frame_list = target->frame_list;
                    matrix = target->init_matrix;

                    if (data->matrix != nullptr) {
                        dc2::memory::CopyTrackedBytes(matrix[target_id], data->matrix[source_id], sizeof(matrix[target_id]));
                    }

                    (static_cast<mgCVisualMotionMDT *>(visual))->ChangeWeight(frame_list, matrix, target_id);
                }
            }
        }

        i++;
    }

    return source;
}

/**
 *
 * Allocates level-of-detail model records for the character.
 *
 */
int _LOD_MODEL_START(dc2::script::TagArguments stack, int argc) {
    int count = dc2::script::TagInteger(stack);

    if (count <= 0 || base_stack == nullptr || nowChr == nullptr) {
        return false;
    }

    const auto bytes = static_cast<std::size_t>(count) * sizeof(CCharaLOD);
    const auto blocks = (bytes + sizeof(u_long128) - 1) / sizeof(u_long128) + 2;
    if (blocks > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
        base_stack->stGetRest() <= 0 || blocks >= static_cast<std::size_t>(base_stack->stGetRest())) {
        return false;
    }
    u_long128 *block = AllocateCharacterStorage(base_stack, blocks);
    if (block == nullptr) {
        return false;
    }
    nowChr->lod = new (block) CCharaLOD[count];
    nowChr->lod_num = count;

    return true;
}

CCharaLOD::CCharaLOD() {
    link_num = 0;
    link = nullptr;
    frame = nullptr;
    distance = 0.0f;
    standalone = false;
    motion = false;
}

/**
 *
 * Clears the active level-of-detail selection.
 *
 */
int _LOD_MODEL_END(dc2::script::TagArguments stack, int argc) {
    nowChr->lod_no = -1;
    return true;
}

mgCFrame *CCharacter2::ChangeLOD(int index) {
    CCharaLOD *level = {};
    mgCFrame  *root = {};
    mgCFrame  *lod_frame = {};
    mgCFrame **root_frames = {};
    int (*pair)[2] = {};
    int        i = {};
    mgCFrame  *target = {};
    mgCFrame  *source = {};
    mgCVisual *visual = {};
    float      box_min[4];
    float      box_max[4];

    if (lod_no < 0 && index != 0) {
        ChangeLOD(0);
    }

    if (index < 0 || index >= lod_num) {
        return nullptr;
    }

    level = lod + index;
    motion_enable = level->motion;

    if (!level->standalone && index == lod_no) {
        return nullptr;
    }

    lod_no = index;
    root = CObjectFrame::frame;
    lod_frame = level->frame;

    if (root == nullptr || lod_frame == nullptr) {
        return nullptr;
    }

    lod_frame->SetPosition(position);
    lod_frame->SetRotation(rotation);
    lod_frame->SetScale(scale);

    if (level->standalone) {
        return lod_frame;
    }

    root_frames = root->frame_list;
    pair = level->link;

    for (i = 0; i < level->link_num; i++, pair++) {
        target = root->GetFrame((*pair)[0]);

        if (target != nullptr) {
            source = lod_frame->GetFrame((*pair)[1]);

            if (source != nullptr && source->clone_inputs.Matches(*source) && target->clone_inputs.Matches(*target)) {
                visual = source->visual;

                if (visual != nullptr && visual->clone_inputs.Kind(visual) == dc2::render::VisualCloneKind::MotionMdt) {
                    (static_cast<mgCVisualMotionMDT *>(visual))->frame = root_frames;
                }

                const auto clone_inputs = target->clone_inputs;
                target->SetVisual(visual);
                const auto visual_inputs = visual != nullptr ? visual->clone_inputs : dc2::render::VisualCloneInputs{};
                if (!clone_inputs.PublishChanges(*target, nullptr, &visual_inputs)) {
                    target->clone_inputs = {};
                }
                source->GetBBox(box_min, box_max);
                target->SetBBox(box_min, box_max);
            }
        }
    }

    return nullptr;
}

bool CCharacter2::Copy(CCharacter2 &dest, mgCMemory *memory) try {
    const auto fail = [&] {
        dest.Initialize();
        return false;
    };
    if (!dc2::character::ResourcesLive(*this) || dynamic_anime_num < 0 || lod_num < 0 ||
        deform_frame_num < 0 || static_cast<std::size_t>(deform_frame_num) > std::size(deform_frame) ||
        se_num[0] < 0 || (dynamic_anime_num > 0 && dynamic_anime == nullptr) ||
        (lod_num > 0 && lod == nullptr) || (se_num[0] > 0 && se_list[0] == nullptr) || !dc2::character::CloneInputsLive(*this)) {
        return fail();
    }
    if (&dest == this) {
        return true;
    }
    if (memory != nullptr && CObjectFrame::frame == nullptr) {
        return fail();
    }
    dest = *this;
    if (memory == nullptr) {
        return true;
    }
    const auto                      inherited = resource_state.Acquire<dc2::character::ResourceState>();
    const auto                      source_clone_inputs = inherited ? inherited->clone_inputs : nullptr;
    dc2::character::CloneAuxBuilder destination_inputs(source_clone_inputs);
    const int                       start_used = memory->stack_used;
    dest.CObjectFrame::frame = mgCopyFrame(CObjectFrame::frame, memory, 1);
    if (dest.CObjectFrame::frame == nullptr) {
        return fail();
    }
    if (inherited) {
        auto state = *inherited;
        state.anchor = dc2::memory::ArenaBuffer::Bind(*memory, std::span<u8>(reinterpret_cast<u8 *>(dest.CObjectFrame::frame), sizeof(mgCFrame)));
        state.producers.push_back({dc2::character::ResourceChannel::Copy, 0, dc2::memory::ArenaLifetime::Capture(*memory)});
        if (!dc2::character::PublishResources(dest, std::move(state))) {
            return fail();
        }
    }
    dest.shadow_frame = shadow_frame;
    if (outline_tex_no > 0 && outline != nullptr) {
        dest.outline = nullptr;
        dest.outline_tex_no = 0;
        for (auto *source_outline = outline; source_outline != nullptr; source_outline = source_outline->next) {
            if (source_outline->frame == nullptr) {
                return fail();
            }
            char  root_name[] = "";
            char *name = source_outline->frame == CObjectFrame::frame ? root_name : source_outline->frame->name;
            auto *target = name == nullptr ? nullptr : name[0] == '\0' ? dest.CObjectFrame::frame
                                                                       : dest.CObjectFrame::frame->SearchFrame(name);
            if (target == nullptr) {
                return fail();
            }
            auto *line = dc2::memory::NewObject<COutLineDraw>(*memory);
            if (line == nullptr) {
                return fail();
            }
            *line = *source_outline;
            line->next = nullptr;
            dest.AddOutLine(name, line);
            if (line->frame != target) {
                return fail();
            }
        }
    }
    if (dynamic_anime_num > 0) {
        dest.dynamic_anime = dc2::memory::NewArray<CDynamicAnime>(*memory, static_cast<std::size_t>(dynamic_anime_num));
        if (dest.dynamic_anime == nullptr) {
            return fail();
        }
        for (int index = 0; index < dynamic_anime_num; ++index) {
            if (!dynamic_anime[index].Copy(dest.dynamic_anime[index], dest.CObjectFrame::frame, memory)) {
                return fail();
            }
        }
    }
    const auto remap = [&dest](const dc2::world::FrameNameBinding &binding) -> mgCFrame * {
        const auto name = binding.Name();
        return name ? dest.CObjectFrame::frame->SearchFrame(const_cast<char *>(name->data())) : nullptr;
    };
    for (std::size_t index = 0; index < std::size(entry_frame); ++index) {
        dest.entry_frame[index] = entry_frame[index] != nullptr ? remap(source_clone_inputs->entries[index]) : nullptr;
        if (entry_frame[index] != nullptr && dest.entry_frame[index] == nullptr) {
            return fail();
        }
    }
    for (std::size_t index = 0; index < std::size(entry_object); ++index) {
        dest.entry_object[index].frame = entry_object[index].frame != nullptr ? remap(source_clone_inputs->objects[index]) : nullptr;
        if (entry_object[index].frame != nullptr && dest.entry_object[index].frame == nullptr) {
            return fail();
        }
    }
    for (int index = 0; index < deform_frame_num; ++index) {
        dest.deform_frame[index] = deform_frame[index] != nullptr ? remap(source_clone_inputs->deform[static_cast<std::size_t>(index)]) : nullptr;
        if (deform_frame[index] != nullptr && dest.deform_frame[index] == nullptr) {
            return fail();
        }
    }
    if (lod_num > 0) {
        dest.lod = dc2::memory::NewArray<CCharaLOD>(*memory, static_cast<std::size_t>(lod_num));
        if (dest.lod == nullptr) {
            return fail();
        }
        for (int index = 0; index < lod_num; ++index) {
            dest.lod[index] = lod[index];
            dest.lod[index].frame = mgCopyFrame(lod[index].frame, memory, 1);
            if (dest.lod[index].frame == nullptr) {
                return fail();
            }
        }
    }
    if (se_num[0] > 0) {
        auto *sounds = GetSoundInfoCopy(memory);
        if (sounds == nullptr) {
            return fail();
        }
        dest.se_list[0] = sounds;
        if (!destination_inputs.RegisterSounds(*memory, 0, {sounds, static_cast<std::size_t>(se_num[0])})) {
            return fail();
        }
    }
    for (std::size_t index = 0; index < std::size(sword_effect); ++index) {
        if (sword_effect[index] != nullptr) {
            dest.sword_effect[index] = dc2::memory::NewObject<CSWordAfterEffect>(*memory);
            if (dest.sword_effect[index] == nullptr || !sword_effect[index]->Copy(*dest.sword_effect[index], memory)) {
                return fail();
            }
        }
    }
    const auto destination_graph = dc2::world::FrameGraph::Capture(*memory, dest.CObjectFrame::frame);
    if (!destination_graph.IsLive() || !destination_inputs.CaptureFrames(dest, destination_graph) ||
        !dc2::character::PublishCloneInputs(dest, std::move(destination_inputs)) || !dc2::character::ResourcesLive(dest)) {
        return fail();
    }
    lod_no = -1;
    copy_size = memory->stack_used - start_used;
    return true;
} catch (const std::bad_alloc &) {
    dest.Initialize();
    return false;
}

#include "common.h"

#include <cstdio>

#include "assets/data_registry.hpp"
#include "character.hpp"
#include "character_metadata_bridge.inc"
#include "character_motion.hpp"
#include "log/log.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/model_assets.hpp"

void CCharacter2::LoadChrFile(u32 *data, const char *profile, mgCMemory *model,
                              mgCMemory *motion, mgCMemory *images, int block, CCharacter2 *parent, int outline) {
    model_assets::CharacterLoadOptions options{.model_memory = model, .motion_memory = motion, .image_memory = images, .textures = &mgTexManager, .parent = parent, .texture_block = block, .outline = outline != 0};
    std::string                        error;
    const auto                         path = DataReadBufferPath(data);
    if (!path) {
        CT_LOG_ERROR(Data, "character: direct glTF path required");
        return;
    }
    const bool loaded = model_assets::LoadCharacter(*this, std::filesystem::path(*path), profile ? profile : "", options, error);
    if (!loaded) {
        CT_LOG_ERROR(Data, "character: {}", error);
    }
}

void CCharacter2::LoadSkin(u32 *data, char *profile, char *name, mgCMemory *memory, int block) {
    model_assets::CharacterLoadOptions options{.model_memory = memory, .motion_memory = memory, .image_memory = memory, .textures = &mgTexManager, .parent = nullptr, .texture_block = block, .outline = false};
    std::string                        error;
    const auto                         path = DataReadBufferPath(data);
    if (!path) {
        CT_LOG_ERROR(Data, "character skin: direct glTF path required");
        return;
    }
    const bool loaded = model_assets::LoadSkin(*this, std::filesystem::path(*path), profile ? profile : "", name ? name : "", options, error);
    if (!loaded) {
        CT_LOG_ERROR(Data, "character skin: {}", error);
    }
}

void CCharacter2::DeleteExtMotion() {
    auto resources = resource_state.Acquire<dc2::character::ResourceState>();
    if (resource_state.HasValue() && !resources) {
        Initialize();
        return;
    }
    // Detach every extension pointer before its producer arena can be reset.
    for (int slot = 1; slot < CHARA_MOTION_SET_MAX; ++slot) {
        motion[slot].frame_info = shadow_motion[slot].frame_info = nullptr;
        motion[slot].frame_info_view = shadow_motion[slot].frame_info_view = {};
        character_motion::Forget(motion[slot].motion_list);
        motion[slot] = {};
        shadow_motion[slot] = {};
        key_list[slot] = nullptr;
        seq_list[slot] = nullptr;
        key_num[slot] = 0;
    }
    next_key = nullptr;
    if (auto *base = GetKeyListIndexPtr(0, nullptr)) {
        SetMotion(base->name, CHARA_MOTION_RESTART);
        frame = static_cast<float>(base->start_frame);
    }
    now_key = posed_key = next_key;
    now_flags = prev_flags = next_flags;
    prev_frame = frame;
    blend = 0.0f;
    now_set = prev_set = next_set = 0;
    next_seq = now_seq = nullptr;
    seq_step = nullptr;
    seq_mode = 0;
    seq_state = CHARA_SEQ_STATE_NONE;
    if (tex_anime_group_start > 0) {
        for (int group = tex_anime_group_start; group < tex_anime_group_num; ++group) {
            mgTexManager.DeleteTexAnimeGroup(texture_block, group);
        }
    } else {
        mgTexManager.DeleteTexAnime(texture_block);
    }
    model_assets::DeleteCharacterTextures(*this, 1, CHARA_IMAGE_MAX - 1);
    for (int slot = 1; slot < CHARA_IMAGE_MAX; ++slot) {
        images[slot] = nullptr;
    }
    for (int slot = 1; slot < CHARA_MOTION_SET_MAX; ++slot) {
        se_list[slot] = nullptr;
        se_num[slot] = 0;
    }
    if (resources) {
        auto                            state = *resources;
        dc2::character::CloneAuxBuilder builder(state.clone_inputs);
        for (int slot = 1; slot < CHARA_MOTION_SET_MAX; ++slot) {
            static_cast<void>(builder.ClearSounds(slot));
        }
        state.clone_inputs = builder.Finish(*this);
        if (!state.clone_inputs) {
            Initialize();
            return;
        }
        std::erase_if(state.producers, [](const auto &entry) {
            return entry.index > 0 && (entry.channel == dc2::character::ResourceChannel::Motion ||
                                       entry.channel == dc2::character::ResourceChannel::ShadowMotion || entry.channel == dc2::character::ResourceChannel::Image);
        });
        if (!dc2::character::PublishResources(*this, std::move(state))) {
            Initialize();
        }
    }
}

void CCharacter2::DeleteImage() {
    int group_count = 0;
    mgTexManager.GetGroupNameList(texture_block, &group_count);
    if (tex_anime_group_start > 0) {
        for (int group = tex_anime_group_start; group < tex_anime_group_num; ++group) {
            mgTexManager.DeleteTexAnimeGroup(texture_block, group);
        }
    }
    model_assets::DeleteCharacterTextures(*this, 0, 0);
    images[0] = nullptr;
}

namespace dc2::character {
bool ResourcesLive(const CCharacter2 &character) {
    if (character.resource_state.HasValue()) {
        return character.resource_state.IsLive();
    }
    return character.CObjectFrame::frame == nullptr && character.shadow_frame == nullptr &&
           character.dynamic_anime == nullptr && character.lod == nullptr && character.outline == nullptr &&
           character.effect_list == nullptr && character.effect_image_list == nullptr &&
           character.main_frame_info == nullptr && character.shadow_frame_info == nullptr &&
           character.next_key == nullptr && character.now_key == nullptr && character.posed_key == nullptr &&
           character.next_seq == nullptr && character.now_seq == nullptr && character.seq_step == nullptr &&
           character.shadow_link.src_frame == nullptr && character.shadow_link.dst_frame == nullptr &&
           std::ranges::all_of(character.se_list, [](const auto *sounds) { return sounds == nullptr; }) &&
           std::ranges::all_of(character.seq_list, [](const auto *sequences) { return sequences == nullptr; }) &&
           std::ranges::all_of(character.sword_effect, [](const auto *effect) { return effect == nullptr; }) &&
           std::ranges::all_of(character.images, [](const auto *image) { return image == nullptr; }) &&
           std::ranges::all_of(character.key_list, [](const auto *keys) { return keys == nullptr; }) &&
           std::ranges::all_of(character.motion, [](const auto &motion) { return motion.frame_info == nullptr && motion.motion_list == nullptr && motion.skin_list == nullptr && motion.base_matrices == nullptr; }) &&
           std::ranges::all_of(character.shadow_motion, [](const auto &motion) { return motion.frame_info == nullptr && motion.motion_list == nullptr && motion.skin_list == nullptr && motion.base_matrices == nullptr; });
}

bool ResourcesWouldRetireOnReset(const CCharacter2 &character, const mgCMemory &memory,
                                 dc2::memory::ArenaResetKind kind) {
    return character.resource_state.WouldRetireOnReset(memory, kind);
}

bool PublishResources(CCharacter2 &character, ResourceState state) {
    std::stable_sort(state.producers.begin(), state.producers.end(), [](const auto &left, const auto &right) {
        return left.channel < right.channel || (left.channel == right.channel && left.index < right.index);
    });
    std::vector<ResourceProducer> unique_producers;
    unique_producers.reserve(state.producers.size());
    for (const auto &producer : state.producers) {
        if (std::ranges::find(unique_producers, producer) == unique_producers.end()) {
            unique_producers.push_back(producer);
        }
    }
    state.producers = std::move(unique_producers);
    if (auto previous = character.resource_state.Acquire<ResourceState>()) {
        const auto before = previous->anchor.Bytes();
        const auto after = state.anchor.Bytes();
        if (before.data() == after.data() && before.size() == after.size() &&
            previous->producers == state.producers && previous->model_context == state.model_context && previous->clone_inputs == state.clone_inputs) {
            return true;
        }
    }
    std::vector<dc2::memory::ArenaLifetime> dependencies;
    for (const auto &producer : state.producers) {
        if (!producer.lifetime.IsLive()) {
            return false;
        }
        if (std::ranges::find(dependencies, producer.lifetime) == dependencies.end()) {
            dependencies.push_back(producer.lifetime);
        }
    }
    const auto anchor = state.anchor;
    auto       handle = dc2::memory::ArenaResource::Store(anchor, std::make_shared<ResourceState>(std::move(state)), dependencies);
    if (!handle.IsLive()) {
        return false;
    }
    character.resource_state = handle;
    return true;
}
} // namespace dc2::character

namespace dc2::character {
bool CaptureModelResources(CCharacter2 &character, mgCMemory &memory) {
    if (character.CObjectFrame::frame == nullptr) {
        return false;
    }
    ResourceState state;
    state.anchor = dc2::memory::ArenaBuffer::Bind(memory, std::span<u8>(reinterpret_cast<u8 *>(character.CObjectFrame::frame), sizeof(mgCFrame)));
    state.producers.push_back({ResourceChannel::Model, 0, dc2::memory::ArenaLifetime::Capture(memory, character.CObjectFrame::frame)});
    const auto      prior = character.resource_state.Acquire<ResourceState>();
    CloneAuxBuilder builder(prior ? prior->clone_inputs : nullptr);
    if (!builder.CaptureFrames(character, memory)) {
        return false;
    }
    state.clone_inputs = builder.Finish(character);
    return state.clone_inputs != nullptr && PublishResources(character, std::move(state));
}
} // namespace dc2::character

namespace dc2::character {
bool RetainResource(CCharacter2 &character, ResourceChannel channel, int index, mgCMemory &memory) {
    auto previous = character.resource_state.Acquire<ResourceState>();
    if (!previous) {
        return false;
    }
    auto state = *previous;
    std::erase_if(state.producers, [&](const auto &entry) { return entry.channel == channel && entry.index == index; });
    state.producers.push_back({channel, index, dc2::memory::ArenaLifetime::Capture(memory)});
    return PublishResources(character, std::move(state));
}

bool ReleaseResource(CCharacter2 &character, ResourceChannel channel, int index) {
    auto previous = character.resource_state.Acquire<ResourceState>();
    if (!previous) {
        return false;
    }
    auto state = *previous;
    std::erase_if(state.producers, [&](const auto &entry) { return entry.channel == channel && entry.index == index; });
    return PublishResources(character, std::move(state));
}
} // namespace dc2::character
