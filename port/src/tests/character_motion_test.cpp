#include "common.h"

#include <gtest/gtest.h>

#include <array>
#include <cmath>
#include <cstddef>
#include <cstdlib>
#include <cstring>
#include <initializer_list>
#include <memory>
#include <new>
#include <stdexcept>
#include <string>

#include "character_metadata_bridge.hpp"
#include "character_motion.hpp"
#include "gameutil.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_visual.hpp"
#include "platform/arena.hpp"
#include "platform/arena_usage.hpp"

namespace {

/**
 * One effect frame with a material, under a root whose frame list the motion
 * keys index.
 */
struct EffectModel {
    mgCFrame                  root;
    mgCFrame                  effect;
    std::array<mgCFrame *, 2> frames{&root, &effect};
    mgCFrameAttr              attr;
    mgMaterial                material{};
    mgCVisualMDT              visual;

    EffectModel() {
        root.frame_list = frames.data();
        root.frame_num = 1;
        material.diffuse[0] = material.diffuse[1] = material.diffuse[2] =
            material.diffuse[3] = 1.0f;
        visual.material = &material;
        visual.material_num = 1;
        effect.SetVisual(&visual);
        effect.attr = &attr;
    }
};

/**
 * Key list of one channel driving frame 1's first material, on game frames 0,
 * 1, 2...
 */
struct Channel {
    sceVu0FVECTOR values[8]{};
    u32           frames[8]{};
    Mot_List      list{};

    Channel(int type, std::initializer_list<float> keys) {
        int index = 0;
        for (const float key : keys) {
            values[index][0] = values[index][1] = values[index][2] = key;
            values[index][3] = 0.0f;
            frames[index] = index;
            ++index;
        }
        list.frame = 1;
        list.target = 0;
        list.type = type;
        list.key_count = static_cast<u32>(keys.size());
        list.values = values;
        list.key_frames = frames;
    }
};

// Data that reused a released arena; read as a channel pointer it faults, as
// 0x8100000081 did in the crash report.
constexpr unsigned char kReused = 0x81;

constexpr int         kQuadwords = 256;
constexpr std::size_t kBytes = static_cast<std::size_t>(kQuadwords) * 16;
constexpr int         kListQuadwords = static_cast<int>((sizeof(Mot_List) + 15) / 16);

/**
 * One motion set laid out as its arena holds it: the anchor, then the channel
 * list of its only action.
 */
struct MotionSet {
    Mot_List       anchor{};
    Mot_List       channel{};
    tagMOTION_TYPE motion{};

    explicit MotionSet(bool with_channel) {
        motion.motion_list = &anchor;
        character_motion::Action idle{.name = "idle",
                                      .duration = 10,
                                      .base = 0,
                                      .head = with_channel ? &channel : nullptr};
        character_motion::Register(&anchor, {idle}, {});
    }
};

/**
 * One motion set allocated from an arena as BuildMotion allocates it: the
 * channel list of its only action, then the anchor at the end of the run.
 */
struct ArenaMotionSet {
    const std::byte *storage;  /**< Start of the allocation run. */
    Mot_List        *channel;  /**< Channels of the only action. */
    Mot_List        *anchor;   /**< Registry anchor following the channels. */
    tagMOTION_TYPE   motion{}; /**< Motion descriptor used by playback. */

    explicit ArenaMotionSet(mgCMemory &arena)
        : storage(reinterpret_cast<const std::byte *>(arena.stGetTop())),
          channel(::new (arena.Alloc(kListQuadwords)) Mot_List{}),
          anchor(::new (arena.Alloc(kListQuadwords)) Mot_List{}) {
        anchor->frame = -1;
        motion.motion_list = anchor;
        character_motion::Action idle{
            .name = "idle", .duration = 10, .base = 0, .head = channel};
        character_motion::Register(
            anchor, {idle},
            {storage, reinterpret_cast<const std::byte *>(arena.stGetTop())});
    }
};

u_long128 *ArenaBuffer() {
    static char key;
    auto       *buffer = reinterpret_cast<u_long128 *>(ArenaBlock(&key, kBytes));
    std::memset(buffer, 0, kBytes);
    return buffer;
}

class CharacterMotion : public ::testing::Test {
protected:
    void TearDown() override { character_motion::Clear(); }
};

TEST_F(CharacterMotion, MissingModelOrMotionDoesNotFormAnInvalidReference) {
    mgCFrame       root;
    tagMOTION_TYPE motion{};
    SetMotionTime(nullptr, &motion, 0.0f, nullptr);
    SetMotionTime(&root, nullptr, 0.0f, nullptr);
    SetMotionTime(nullptr, nullptr, 0.0f, nullptr);
    ChangeMotion(nullptr, &motion, 0, 1, 0.5f, nullptr);
    ChangeMotion(&root, nullptr, 0, 1, 0.5f, nullptr);
    ChangeMotion(nullptr, nullptr, 0, 1, 0.5f, nullptr);
    EXPECT_TRUE(character_motion::Actions(motion).empty());
}

// A sliced action's material channels end on its last frame, where the game's
// interpolation has no later key; an effect that fades out must keep its last
// key there rather than divide zero by zero into NaN.
TEST_F(CharacterMotion, MaterialAlphaHoldsItsLastKeyAtAndPastTheActionEnd) {
    EffectModel    model;
    Channel        transparency(MOTION_KEY_MATERIAL_ALPHA, {0.0f, 0.5f, 0.9f});
    tagMOTION_TYPE motion{};
    motion.motion_list = &transparency.list;
    character_motion::Register(motion.motion_list,
                               {
                                   {.name = "get_item",
                                    .duration = 2.0f,
                                    .base = 0,
                                    .head = &transparency.list}
    },
                               {});

    character_motion::Pose(model.root, motion, 1.5f, nullptr);
    EXPECT_NEAR(model.material.diffuse[3], 1.0f - 0.7f, 1e-5f);

    for (const float frame : {2.0f, 3.0f, 10.0f}) {
        model.material.diffuse[3] = 1.0f;
        character_motion::Pose(model.root, motion, frame, nullptr);
        ASSERT_FALSE(std::isnan(model.material.diffuse[3])) << "frame " << frame;
        EXPECT_NEAR(model.material.diffuse[3], 1.0f - 0.9f, 1e-5f)
            << "frame " << frame;
    }
}

TEST_F(CharacterMotion, MaterialColourHoldsItsLastKeyAtTheActionEnd) {
    EffectModel    model;
    Channel        colour(MOTION_KEY_MATERIAL_COLOR, {1.0f, 0.25f});
    tagMOTION_TYPE motion{};
    motion.motion_list = &colour.list;
    character_motion::Register(
        motion.motion_list,
        {
            {.name = "flash", .duration = 1.0f, .base = 0, .head = &colour.list}
    },
        {});

    character_motion::Pose(model.root, motion, 1.0f, nullptr);
    for (int component = 0; component < 3; ++component) {
        EXPECT_NEAR(model.material.diffuse[component], 0.25f, 1e-5f);
    }
}

// The blend into a different action poses the target's auxiliary channels
// unblended, through the same end hold.
TEST_F(CharacterMotion, BlendIntoAnActionEndKeepsItsMaterialAlpha) {
    EffectModel    model;
    Channel        first(MOTION_KEY_MATERIAL_ALPHA, {0.0f, 0.0f});
    Channel        second(MOTION_KEY_MATERIAL_ALPHA, {0.2f, 0.8f});
    tagMOTION_TYPE motion{};
    motion.motion_list = &first.list;
    character_motion::Register(
        motion.motion_list,
        {
            {.name = "start", .duration = 1.0f, .base = 0, .head = &first.list },
            {.name = "end",   .duration = 1.0f, .base = 3, .head = &second.list},
    },
        {});

    character_motion::Pose(model.root, motion, 0.0f, nullptr);
    character_motion::Blend(model.root, motion, 0.0f, 4.0f, 0.5f, nullptr);
    ASSERT_FALSE(std::isnan(model.material.diffuse[3]));
    EXPECT_NEAR(model.material.diffuse[3], 1.0f - 0.8f, 1e-5f);
}

TEST_F(CharacterMotion, ReleasedMotionSetStopsResolving) {
    MotionSet set(true);
    EXPECT_EQ(character_motion::Actions(set.motion).size(), 1u);
    const Mot_List anchor = set.anchor;
    std::memset(&set.anchor, kReused, sizeof(set.anchor));
    EXPECT_TRUE(character_motion::Actions(set.motion).empty());
    // The rejected set is erased, not just hidden: restoring the stamp does not
    // bring it back.
    set.anchor = anchor;
    EXPECT_TRUE(character_motion::Actions(set.motion).empty());
}

// Memory the arena hands out after the set's run belongs to someone else; the
// set stays registered.
TEST_F(CharacterMotion, AllocationPastMotionStorageKeepsSet) {
    mgCMemory arena;
    arena.stSetBuffer(ArenaBuffer(), kQuadwords);
    ArenaMotionSet set(arena);
    std::memset(arena.Alloc(kListQuadwords), kReused, sizeof(Mot_List));
    EXPECT_EQ(character_motion::Actions(set.motion).size(), 1u);
}

TEST_F(CharacterMotion, EmptyOverwriteInsideMotionStorageKeepsSet) {
    mgCMemory arena;
    arena.stSetBuffer(ArenaBuffer(), kQuadwords);
    ArenaMotionSet set(arena);
    const auto    *inside = reinterpret_cast<const std::byte *>(set.channel) + 1;
    character_motion::ForgetStorage(inside, inside);
    EXPECT_EQ(character_motion::Actions(set.motion).size(), 1u);
}

// A stage reset rewinds the arena and hands its front out again, over the
// channels; the anchor at the end of the run keeps its bytes, stamp included,
// but the set must stop resolving.
TEST_F(CharacterMotion, ResetArenaReusingChannelsReleasesSet) {
    mgCMemory arena;
    arena.stSetBuffer(ArenaBuffer(), kQuadwords);
    ArenaMotionSet                          set(arena);
    std::array<std::byte, sizeof(Mot_List)> anchor{};
    std::memcpy(anchor.data(), set.anchor, anchor.size());
    arena.stReset();
    std::memset(arena.Alloc(kListQuadwords), kReused, sizeof(Mot_List));
    ASSERT_EQ(std::memcmp(reinterpret_cast<const std::byte *>(set.anchor),
                          anchor.data(), anchor.size()),
              0);
    EXPECT_TRUE(character_motion::Actions(set.motion).empty());
}

// A heap block freed and claimed again by the next stack mode releases the sets
// it held.
TEST_F(CharacterMotion, FreedHeapBlockReusedReleasesSet) {
    mgCMemory arena;
    arena.SetHeapMem(ArenaBuffer(), kQuadwords);
    u_long128 *block = arena.StartStackMode(MG_STACK_MODE_FIRST, 0);
    ASSERT_NE(block, nullptr);
    ArenaMotionSet set(arena);
    arena.EndStackMode();
    arena.Free(block);
    ASSERT_EQ(arena.StartStackMode(MG_STACK_MODE_FIRST, 0), block);
    std::memset(arena.Alloc(kListQuadwords), kReused, sizeof(Mot_List));
    EXPECT_TRUE(character_motion::Actions(set.motion).empty());
    arena.EndStackMode();
}

// A town map change rewinds the character buffer and reserves the controlled
// character's memory again while the character stays loaded there; its motion
// set must keep resolving.
TEST_F(CharacterMotion, KeptReservationAfterRewindKeepsSet) {
    mgCMemory arena;
    arena.stSetBuffer(ArenaBuffer(), kQuadwords);
    ArenaMotionSet set(arena);
    const int      used = arena.stGetUsed();
    arena.stack_used = 0;
    ASSERT_NE(MemoryAllocKept(arena, used), nullptr);
    EXPECT_EQ(character_motion::Actions(set.motion).size(), 1u);
    // The set is still tracked, so handing the memory out for new data releases
    // it.
    arena.stReset();
    std::memset(arena.Alloc(kListQuadwords), kReused, sizeof(Mot_List));
    EXPECT_TRUE(character_motion::Actions(set.motion).empty());
}

// A heap set up over a buffer outside the arenas imports it into an arena root,
// and binding the same buffer again maps the same root and copies the buffer
// over it. The copy covers the buffer's own size, not the root's headroom, so
// it overwrites channels inside that size while an anchor in the headroom keeps
// its bytes.
TEST_F(CharacterMotion, RebindingHeapBufferReleasesSetInsideTheImport) {
    alignas(16) static u_long128 external[kQuadwords];
    std::memset(external, kReused, sizeof(external));
    mgCMemory arena;
    arena.SetHeapMem(external, kQuadwords);
    u_long128 *block = arena.StartStackMode(MG_STACK_MODE_FIRST, 0);
    ASSERT_NE(block, nullptr);
    const auto *storage = reinterpret_cast<const std::byte *>(arena.stGetTop());
    auto       *channel = ::new (arena.Alloc(kListQuadwords)) Mot_List{};
    arena.Alloc(kQuadwords);
    auto *anchor = ::new (arena.Alloc(kListQuadwords)) Mot_List{};
    ASSERT_GE(reinterpret_cast<u_long128 *>(anchor) - block, kQuadwords);
    tagMOTION_TYPE motion{};
    motion.motion_list = anchor;
    character_motion::Action idle{
        .name = "idle", .duration = 10, .base = 0, .head = channel};
    character_motion::Register(
        anchor, {idle},
        {storage, reinterpret_cast<const std::byte *>(arena.stGetTop())});
    arena.EndStackMode();
    std::array<std::byte, sizeof(Mot_List)> kept{};
    std::memcpy(kept.data(), anchor, kept.size());

    arena.SetHeapMem(external, kQuadwords);
    ASSERT_EQ(std::memcmp(reinterpret_cast<const std::byte *>(anchor),
                          kept.data(), kept.size()),
              0);
    ASSERT_EQ(reinterpret_cast<const unsigned char *>(channel)[0], kReused);
    EXPECT_TRUE(character_motion::Actions(motion).empty());
}

// An effect script copies its character's frame tree into work memory that the
// next script reuses; the new tree must not blend from the action the previous
// tree at that address posed, whose channels are gone.
TEST(CharacterMotionDeathTest,
     BlendIgnoresPoseOfFrameTreePreviouslyAtSameAddress) {
    EXPECT_EXIT(([] {
                    character_motion::Clear();
                    alignas(mgCFrame) unsigned char storage[sizeof(mgCFrame)];
                    auto                           *root = new (storage) mgCFrame;
                    MotionSet                       previous(true);
                    character_motion::Pose(*root, previous.motion, 5, nullptr);
                    // The arena reset reuses the channel; the anchor keeps its
                    // stamp, so only the new tree's construction can drop the old
                    // pose.
                    std::memset(&previous.channel, kReused,
                                sizeof(previous.channel));
                    root = new (storage) mgCFrame;
                    MotionSet next(false);
                    character_motion::Blend(*root, next.motion, 5, 5, .5f, nullptr);
                    std::exit(0);
                }()),
                testing::ExitedWithCode(0), "");
}

// A frame tree that outlives the motion set it last posed, released by an arena
// reset without Forget, must not blend from that set's channels.
TEST(CharacterMotionDeathTest, BlendIgnoresPoseFromReleasedMotionSet) {
    EXPECT_EXIT(([] {
                    character_motion::Clear();
                    mgCFrame  root;
                    MotionSet previous(true);
                    character_motion::Pose(root, previous.motion, 5, nullptr);
                    std::memset(&previous.anchor, kReused, sizeof(previous.anchor));
                    std::memset(&previous.channel, kReused,
                                sizeof(previous.channel));
                    MotionSet next(false);
                    character_motion::Blend(root, next.motion, 5, 5, .5f, nullptr);
                    std::exit(0);
                }()),
                testing::ExitedWithCode(0), "");
}

// The frame tree survives, so nothing drops its recorded pose; the arena reset
// that handed the front of the motion run out again overwrote the channels but
// left the anchor, stamp included, intact.
TEST(CharacterMotionDeathTest,
     SurvivingFrameIgnoresPoseFromResetArenaWithIntactAnchor) {
    EXPECT_EXIT(([] {
                    character_motion::Clear();
                    mgCMemory arena;
                    arena.stSetBuffer(ArenaBuffer(), kQuadwords);
                    mgCFrame       root;
                    ArenaMotionSet previous(arena);
                    character_motion::Pose(root, previous.motion, 5, nullptr);
                    arena.stReset();
                    std::memset(arena.Alloc(kListQuadwords), kReused,
                                sizeof(Mot_List));
                    MotionSet next(false);
                    character_motion::Blend(root, next.motion, 5, 5, .5f, nullptr);
                    std::exit(0);
                }()),
                testing::ExitedWithCode(0), "");
}

} // namespace

namespace {
SPI_STACK MetadataInteger(int value) {
    SPI_STACK result{};
    result.type = SPI_STACK_TYPE_INT;
    result.value.integer = value;
    return result;
}

SPI_STACK MetadataText(char *value) {
    SPI_STACK result{};
    result.type = SPI_STACK_TYPE_STRING;
    result.value.string = value;
    return result;
}
} // namespace

TEST(CharacterMetadata,
     KeyBuilderRejectsAnArenaTooSmallForItsSentinelWithoutWritingPastIt) {
    static char storage_key;
    auto       *storage = reinterpret_cast<u_long128 *>(
        ArenaBlock(&storage_key, 4 * sizeof(u_long128)));
    std::memset(storage + 2, 0x5a, 2 * sizeof(u_long128));
    mgCMemory memory;
    memory.stSetBuffer(storage, 2);
    CCharacter2                   character;
    dc2::character::MetadataScope context(&character, &memory,
                                          0, nullptr, false);
    EXPECT_TRUE(PortCharacterMetadataApply(
        "KEY_START", dc2::script::TagArguments({}), 0, false));
    EXPECT_TRUE(PortCharacterMetadataApply(
        "KEY_END", dc2::script::TagArguments({}), 0, false));
    EXPECT_EQ(character.key_list[0], nullptr);
    EXPECT_EQ(memory.stack_used, 0);
    const auto *guard = reinterpret_cast<const unsigned char *>(storage + 2);
    for (std::size_t index = 0; index < 2 * sizeof(u_long128); ++index) {
        EXPECT_EQ(guard[index], 0x5a);
    }
}

TEST(CharacterMetadata, SoundEntriesDoNotAdvancePastTheirDeclaredCount) {
    alignas(16) std::array<u_long128, 64> storage{};
    mgCMemory                             memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CCharacter2                   character;
    dc2::character::MetadataScope context(&character, &memory,
                                          0, nullptr, false);
    SPI_STACK                     count[] = {MetadataInteger(1)};
    EXPECT_TRUE(PortCharacterMetadataApply(
        "SE_START", dc2::script::TagArguments(count), 1, false));
    ASSERT_NE(character.se_list[0], nullptr);
    char      motion[] = "motion";
    SPI_STACK arguments[] = {MetadataText(motion), MetadataInteger(0),
                             MetadataInteger(7), MetadataInteger(3)};
    EXPECT_TRUE(PortCharacterMetadataApply(
        "SE", dc2::script::TagArguments(arguments, motion), 4, false));
    arguments[2] = MetadataInteger(99);
    EXPECT_TRUE(PortCharacterMetadataApply(
        "SE", dc2::script::TagArguments(arguments, motion), 4, false));
    EXPECT_EQ(character.se_list[0][0].se_no, 7);
    EXPECT_EQ(character.se_num[0], 1);
}

TEST(CharacterConstruction,
     PoisonedStorageStartsWithAnEmptyCharacterAndMetadataOwners) {
    alignas(CCharacter2) std::array<std::byte, sizeof(CCharacter2)> storage{};
    for (int reuse = 0; reuse < 2; ++reuse) {
        storage.fill(std::byte{0xA5});
        auto *character =
            std::construct_at(reinterpret_cast<CCharacter2 *>(storage.data()));
        EXPECT_EQ(character->body_width, 0.0f);
        EXPECT_EQ(character->body_height, 0.0f);
        EXPECT_EQ(character->body_depth, 0.0f);
        EXPECT_EQ(character->name[0], '\0');
        EXPECT_EQ(character->next_flags, 0);
        EXPECT_EQ(character->prev_flags, 0);
        EXPECT_EQ(character->now_flags, 0);
        EXPECT_EQ(character->shadow_link.num, 0);
        EXPECT_EQ(character->shadow_link.src_frame, nullptr);
        EXPECT_EQ(character->effect_list, nullptr);
        EXPECT_EQ(character->lod_num, 0);
        EXPECT_EQ(character->lod_no, -1);
        EXPECT_EQ(character->alpha, 1.0f);
        EXPECT_EQ(character->base_scale[0], 1.0f);
        std::destroy_at(character);
    }
    alignas(CHARA_EFFECT_MANAGER)
        std::array<std::byte, sizeof(CHARA_EFFECT_MANAGER)>
            effect_storage{};
    effect_storage.fill(std::byte{0xA5});
    auto *effect = std::construct_at(
        reinterpret_cast<CHARA_EFFECT_MANAGER *>(effect_storage.data()));
    EXPECT_EQ(effect->emitter_pool, nullptr);
    EXPECT_EQ(effect->particle_pool, nullptr);
    EXPECT_EQ(effect->frame_name[0], '\0');
    EXPECT_EQ(effect->motion_name[0], '\0');
    EXPECT_EQ(effect->start_ratio, 0.0f);
    std::destroy_at(effect);
    alignas(CDynamicAnime) std::array<std::byte, sizeof(CDynamicAnime)>
        dynamic_storage{};
    dynamic_storage.fill(std::byte{0xA5});
    auto *dynamic = std::construct_at(
        reinterpret_cast<CDynamicAnime *>(dynamic_storage.data()));
    EXPECT_EQ(dynamic->world_init_vertex, nullptr);
    EXPECT_EQ(dynamic->vertex_num, 0);
    EXPECT_EQ(dynamic->wind_scale, 1.0f);
    std::destroy_at(dynamic);
}

TEST(CharacterMetadata, MotionSoundsPublishOnlySuccessfullyInitializedCues) {
    std::array<u_long128, 64> bytes{};
    mgCMemory                 memory;
    memory.stSetBuffer(bytes.data(), static_cast<int>(bytes.size()));
    CCharacter2                   character;
    dc2::character::MetadataScope context(&character, &memory,
                                          0, nullptr, false);
    PortCharacterMetadataMotionSlot(0);
    auto count = MetadataInteger(2);
    ASSERT_TRUE(PortCharacterMetadataApply(
        "SE_START", dc2::script::TagArguments(std::span(&count, 1)), 1, false));
    EXPECT_EQ(character.se_num[0], 0);
    std::string name = "unused motion";
    SPI_STACK   args[4]{};
    args[0].type = SPI_STACK_TYPE_STRING;
    args[0].value.string = name.data();
    args[1] = MetadataInteger(CHRINFO_SE_SOUND);
    args[2] = MetadataInteger(7);
    args[3].type = SPI_STACK_TYPE_FLOAT;
    args[3].value.real = 5.0f;
    const std::span<const char> text(name.data(), name.size() + 1);
    ASSERT_TRUE(PortCharacterMetadataApply(
        "SE", dc2::script::TagArguments(args, {}, {}, std::span(&text, 1)), 4,
        false));
    EXPECT_EQ(character.se_num[0], 1);
    ASSERT_NE(character.se_list[0], nullptr);
    EXPECT_EQ(character.se_list[0][0].se_no, 7);
    EXPECT_EQ(character.se_list[0][0].wait, 0);
}

TEST(CharacterMetadata,
     NestedScopesRestoreOwnedTextAndEveryUnfinishedBuilderOnException) {
    using Scope = dc2::character::MetadataScope;
    std::array<u_long128, 1024> outer_storage{};
    std::array<u_long128, 1024> inner_storage{};
    mgCMemory                   outer_memory;
    mgCMemory                   inner_memory;
    outer_memory.stSetBuffer(outer_storage.data(),
                             static_cast<int>(outer_storage.size()));
    inner_memory.stSetBuffer(inner_storage.data(),
                             static_cast<int>(inner_storage.size()));
    CCharacter2 outer;
    CCharacter2 inner;
    const auto  empty = dc2::script::TagArguments(std::span<SPI_STACK>{});
    const auto  named = [](const char *command, std::string text,
                           bool key = false) {
        SPI_STACK             arguments[] = {MetadataText(text.data()), MetadataInteger(1),
                                             MetadataInteger(5), MetadataInteger(1)};
        const std::span<char> source(text.data(), text.size() + 1);
        return PortCharacterMetadataApply(
            command,
            dc2::script::TagArguments(std::span(arguments).first(key ? 4 : 1),
                                      source),
            key ? 4 : 1, false);
    };
    const auto sound = [](int number) {
        char      name[] = "unused";
        SPI_STACK arguments[] = {MetadataText(name),
                                 MetadataInteger(CHRINFO_SE_SOUND),
                                 MetadataInteger(number), MetadataInteger(5)};
        return PortCharacterMetadataApply(
            "SE", dc2::script::TagArguments(arguments, std::span(name)), 4, false);
    };
    EXPECT_FALSE(Scope::ActiveSkinName());
    EXPECT_FALSE(PortCharacterMetadataApply("KEY_START", empty, 0, false));
    {
        Scope context(&outer, &outer_memory, 0,
                      nullptr, false, std::string("outer-skin"));
        ASSERT_TRUE(Scope::ActiveSkinName());
        EXPECT_EQ(*Scope::ActiveSkinName(), "outer-skin");
        PortCharacterMetadataMotionSlot(2);
        ASSERT_TRUE(named("VERTEX_ANIME", "outer-vertex"));
        auto *visual_types = PortCharacterMetadataVisualTypes(false);
        ASSERT_NE(visual_types, nullptr);
        EXPECT_STREQ(visual_types[0].name, "outer-vertex");
        ASSERT_TRUE(PortCharacterMetadataApply("KEY_START", empty, 0, false));
        ASSERT_TRUE(named("KEY", "outer-one", true));
        ASSERT_TRUE(named("SEQ_START", "outer-sequence"));
        ASSERT_TRUE(named("SEQ", "outer-one"));
        auto count = MetadataInteger(2);
        ASSERT_TRUE(PortCharacterMetadataApply(
            "SE_START", dc2::script::TagArguments(std::span(&count, 1)), 1, false));
        ASSERT_TRUE(sound(7));
        try {
            std::string source = "inner-skin";
            Scope       nested(&inner, &inner_memory, 1,
                               nullptr, false, source);
            source.assign(4096, 'x');
            ASSERT_TRUE(Scope::ActiveSkinName());
            EXPECT_EQ(*Scope::ActiveSkinName(), "inner-skin");
            PortCharacterMetadataMotionSlot(1);
            ASSERT_TRUE(named("VERTEX_ANIME", "inner-vertex"));
            ASSERT_NE(PortCharacterMetadataVisualTypes(false), nullptr);
            ASSERT_TRUE(PortCharacterMetadataApply("KEY_START", empty, 0, false));
            ASSERT_TRUE(named("KEY", "inner-key", true));
            ASSERT_TRUE(named("SEQ_START", "inner-sequence"));
            ASSERT_TRUE(named("SEQ", "inner-key"));
            ASSERT_TRUE(PortCharacterMetadataApply(
                "SE_START", dc2::script::TagArguments(std::span(&count, 1)), 1,
                false));
            ASSERT_TRUE(sound(99));
            throw std::runtime_error("inner load failed");
        } catch (const std::runtime_error &) {
        }
        ASSERT_TRUE(Scope::ActiveSkinName());
        EXPECT_EQ(*Scope::ActiveSkinName(), "outer-skin");
        EXPECT_STREQ(visual_types[0].name, "outer-vertex");
        ASSERT_TRUE(named("KEY", "outer-two", true));
        ASSERT_TRUE(PortCharacterMetadataApply("KEY_END", empty, 0, false));
        ASSERT_EQ(outer.key_num[2], 3);
        EXPECT_STREQ(outer.key_list[2][0].name, "outer-one");
        EXPECT_STREQ(outer.key_list[2][1].name, "outer-two");
        EXPECT_EQ(outer.key_list[2][2].name[0], char{});
        EXPECT_TRUE(
            dc2::memory::AllocationBytes(inner_memory, outer.key_list[2]).empty());
        ASSERT_TRUE(named("SEQ", "outer-two"));
        ASSERT_TRUE(PortCharacterMetadataApply("SEQ_END", empty, 0, false));
        ASSERT_NE(outer.seq_list[2], nullptr);
        ASSERT_EQ(outer.seq_list[2]->seq_num, 3);
        EXPECT_STREQ(outer.seq_list[2]->seq[0].name, "outer-one");
        EXPECT_STREQ(outer.seq_list[2]->seq[1].name, "outer-two");
        ASSERT_TRUE(sound(8));
        ASSERT_EQ(outer.se_num[2], 2);
        EXPECT_EQ(outer.se_list[2][0].se_no, 7);
        EXPECT_EQ(outer.se_list[2][1].se_no, 8);
        EXPECT_EQ(inner.key_list[1], nullptr);
    }
    EXPECT_FALSE(Scope::ActiveSkinName());
    EXPECT_FALSE(PortCharacterMetadataApply("KEY_START", empty, 0, false));
    EXPECT_EQ(PortCharacterMetadataVisualTypes(false), nullptr);
    EXPECT_EQ(PortCharacterMetadataNextCloth(), -1);
}

TEST(
    CharacterConstruction,
    DynamicAnimationPublishesOnlyConstructedInitializedTablesFromReusedStorage) {
    static char key;
    auto       *storage =
        reinterpret_cast<u_long128 *>(ArenaBlock(&key, 512 * sizeof(u_long128)));
    mgCMemory memory;
    memory.stSetBuffer(storage, 512);
    std::memset(storage, 0xA5, 512 * sizeof(u_long128));
    CDynamicAnime dynamic;
    dynamic.NewFrameTable(2, &memory);
    ASSERT_EQ(dynamic.frame_num, 2);
    for (int index = 0; index < 2; ++index) {
        EXPECT_EQ(dynamic.frame[index], nullptr);
        EXPECT_EQ(dynamic.frame_pose[index].type, DA_FRAME_POSE_NONE);
        EXPECT_EQ(dynamic.frame_pose[index].vertex_num, 0);
        EXPECT_EQ(dynamic.frame_pose[index].vertex_id, nullptr);
        EXPECT_EQ(dynamic.frame_pose[index].local, 0);
    }
    dynamic.NewVertexTable(2, &memory);
    ASSERT_EQ(dynamic.vertex_num, 2);
    for (auto *table :
         {dynamic.init_vertex, dynamic.now_vertex, dynamic.old_vertex,
          dynamic.velocity, dynamic.world_init_vertex}) {
        ASSERT_NE(table, nullptr);
        for (int index = 0; index < 2; ++index) {
            for (int component = 0; component < 4; ++component) {
                EXPECT_FLOAT_EQ(table[index][component], 0.0f);
            }
        }
    }
}

TEST(CharacterMetadata,
     SoundCopyRejectsARetiredDestinationBeforeReservingItsOriginalBudget) {
    static char key;
    auto       *storage =
        reinterpret_cast<u_long128 *>(ArenaBlock(&key, 32 * sizeof(u_long128)));
    mgCMemory parent;
    parent.stSetBuffer(storage, 32);
    auto *allocation = parent.Alloc(16);
    ASSERT_NE(allocation, nullptr);
    mgCMemory child;
    child.stSetChildBuffer(parent, allocation, 16);
    CCharacter2                source;
    std::array<u_long128, 512> source_storage{};
    mgCMemory                  source_memory;
    source_memory.stSetBuffer(source_storage.data(), static_cast<int>(source_storage.size()));
    source.CObjectFrame::frame = dc2::memory::NewObject<mgCFrame>(source_memory);
    ASSERT_NE(source.CObjectFrame::frame, nullptr);
    ASSERT_TRUE(dc2::character::CaptureModelResources(source, source_memory));
    source.se_num[0] = 1;
    source.se_list[0] = dc2::memory::NewObject<CHRINFO_SE>(source_memory);
    ASSERT_NE(source.se_list[0], nullptr);
    auto                           *cue = source.se_list[0];
    const auto                      resources = source.resource_state.Acquire<dc2::character::ResourceState>();
    dc2::character::CloneAuxBuilder builder(resources->clone_inputs);
    ASSERT_TRUE(builder.RegisterSounds(source_memory, 0, {cue, 1}));
    ASSERT_TRUE(dc2::character::PublishCloneInputs(source, std::move(builder)));
    child.stSetLocked(true);
    EXPECT_EQ(source.GetSoundInfoCopy(&child), nullptr);
    EXPECT_EQ(child.stack_used, 0);
    child.stSetLocked(false);
    parent.stClearUsed();
    EXPECT_EQ(source.GetSoundInfoCopy(&child), nullptr);
    EXPECT_EQ(child.stack_used, 0);
    EXPECT_EQ(source.se_list[0], cue);
    EXPECT_EQ(source.se_num[0], 1);
}
