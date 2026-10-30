#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstring>
#include <limits>
#include <memory>
#include <vector>

#include "character.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "native_script_program.hpp"
#include "platform/arena.hpp"
#include "runscript.hpp"
#include "scenesnd.hpp"
#include "stubs/event.hpp"
#include "swordeffect.hpp"

namespace {
class EventSwordMemory : public testing::Test {
protected:
    void SetUp() override {
        memory.stSetBuffer(storage, 1024);
        SetEventScript(program.Bytes(), &memory);
        character.Initialize();
        auto *frame = dc2::memory::NewObject<mgCFrame>(memory);
        ASSERT_NE(frame, nullptr);
        character.CObjectFrame::frame = frame;
        ASSERT_TRUE(dc2::character::CaptureModelResources(character, memory));
        auto *effect_storage = dc2::memory::NewArray<CSWordAfterEffect>(memory, CHARA_SWORD_EFFECT_MAX);
        ASSERT_NE(effect_storage, nullptr);
        effects = std::span(effect_storage, CHARA_SWORD_EFFECT_MAX);
        scene.chara_num = 1;
        scene.AssignChara(0, dc2::scene::CharacterResource::FromOwned(character_owner));
        EventScene = &scene;
        for (int i = 0; i < CHARA_SWORD_EFFECT_MAX; ++i) {
            character.sword_effect[i] = &effects[i];
            ASSERT_TRUE(dc2::character::RetainResource(character, dc2::character::ResourceChannel::Sword, i, memory));
        }
    }

    void TearDown() override {
        SetEventScript({}, nullptr);
        EventScene = nullptr;
    }

    void Colors(int slot) {
        RS_STACKDATA args[10]{};
        for (int i = 0; i < 10; ++i) {
            args[i].type = RS_INT;
            args[i].val.i = i + 10;
        }
        args[0].val.i = 0;
        args[1].val.i = slot;
        ASSERT_TRUE(InvokeNativeExternal(EventScript.ext_func_table[EVENT_EXT_SWE_SET_COLOR], std::span(args).first(10)));
        for (int i = 0; i < CHARA_SWORD_EFFECT_MAX; ++i) {
            for (int lane = 0; lane < 4; ++lane) {
                EXPECT_EQ(effects[i].color0[lane], i == slot ? lane + 12 : 128);
                EXPECT_EQ(effects[i].color1[lane], i == slot ? lane + 16 : 128);
            }
        }
    }

    alignas(64) u_long128 storage[1024]{};
    mgCMemory                    memory;
    NativeScriptProgram          program;
    CScene                       scene;
    std::shared_ptr<CCharacter2> character_owner = std::make_shared<CCharacter2>();
    CCharacter2                 &character = *character_owner;
    std::span<CSWordAfterEffect> effects;
};
} // namespace

TEST(SWordMemory, PoisonedDefaultStorageCannotStepAnUninitializedFrame) {
    alignas(CSWordAfterEffect) std::array<std::byte, sizeof(CSWordAfterEffect)> bytes{};
    std::memset(bytes.data(), 0xA5, bytes.size());
    auto *trail = std::construct_at(reinterpret_cast<CSWordAfterEffect *>(bytes.data()));
    EXPECT_EQ(trail->active, 0);
    EXPECT_EQ(trail->frame0, nullptr);
    EXPECT_EQ(trail->frame1, nullptr);
    EXPECT_EQ(trail->point0, nullptr);
    EXPECT_EQ(trail->point1, nullptr);
    EXPECT_EQ(trail->smooth0, nullptr);
    EXPECT_EQ(trail->smooth1, nullptr);
    EXPECT_EQ(trail->point_max, 0);
    EXPECT_EQ(trail->point_num, 0);
    EXPECT_EQ(trail->smooth_num, 0);
    trail->Step();
    trail->CreatPointList();
    trail->Draw();
    std::destroy_at(trail);
}

TEST(SWordMemory, InvalidOrShortArrayReservationsLeaveTheArenaUntouched) {
    static char identity;
    mgCMemory   memory;
    auto       *root = reinterpret_cast<u_long128 *>(ArenaBlock(&identity, 8 * sizeof(u_long128)));
    memory.stSetBuffer(root, 8);
    std::memset(root, 0xA5, 8 * sizeof(u_long128));
    CSWordAfterEffect trail;
    for (const auto dimensions : {
             std::array{12, 8                              },
             std::array{-1, 8                              },
             std::array{12, std::numeric_limits<int>::max()},
             std::array{12, 0                              }
    }) {
        trail.Initialize(&memory, dimensions[0], dimensions[1]);
        EXPECT_EQ(memory.stGetUsed(), 0);
        EXPECT_EQ(trail.point0, nullptr);
        EXPECT_EQ(trail.point_max, 0);
        EXPECT_EQ(trail.active, 0);
    }
    const auto bytes = std::as_bytes(std::span(root, 8));
    EXPECT_TRUE(std::ranges::all_of(bytes, [](std::byte value) { return value == std::byte{0xA5}; }));
}

TEST(SWordMemory, CopyPreservesOnlyInitializedRingAndCurveEntries) {
    static char identity;
    mgCMemory   memory;
    auto       *root = reinterpret_cast<u_long128 *>(ArenaBlock(&identity, 512 * sizeof(u_long128)));
    memory.stSetBuffer(root, 512);
    CSWordAfterEffect source;
    source.Initialize(&memory, 4, 8);
    ASSERT_NE(source.point0, nullptr);
    for (int index = 0; index < 3; ++index) {
        float first[4]{static_cast<float>(index), 2, 3, 1};
        float second[4]{static_cast<float>(index + 10), 5, 6, 1};
        source.AddPoint(first, second);
    }
    source.active = 1;
    source.CreatPointList();
    ASSERT_GT(source.smooth_num, 0);
    CSWordAfterEffect copy;
    ASSERT_TRUE(source.Copy(copy, &memory));
    ASSERT_NE(copy.point0, nullptr);
    EXPECT_NE(copy.point0, source.point0);
    EXPECT_EQ(copy.point_num, source.point_num);
    EXPECT_EQ(copy.smooth_num, source.smooth_num);
    for (int index = 0; index < source.point_num; ++index) {
        const auto slot = (source.head_index + index) % source.point_max;
        for (int lane = 0; lane < 4; ++lane) {
            EXPECT_FLOAT_EQ(copy.point0[slot][lane], source.point0[slot][lane]);
            EXPECT_FLOAT_EQ(copy.point1[slot][lane], source.point1[slot][lane]);
        }
    }
    for (int index = 0; index < source.smooth_num; ++index) {
        for (int lane = 0; lane < 4; ++lane) {
            EXPECT_FLOAT_EQ(copy.smooth0[index][lane], source.smooth0[index][lane]);
            EXPECT_FLOAT_EQ(copy.smooth1[index][lane], source.smooth1[index][lane]);
        }
    }
}

TEST_F(EventSwordMemory, FirstSlotKeepsItsExistingColorBehavior) { Colors(0); }

TEST_F(EventSwordMemory, SecondSlotUsesACompleteNativePointer) { Colors(1); }

TEST_F(EventSwordMemory, ThirdSlotDoesNotWriteTheSecondEffect) { Colors(2); }

TEST_F(EventSwordMemory, StartUsesTheSelectedEffectAndNamedFrames) {
    auto *root_storage = dc2::memory::NewObject<mgCFrame>(memory);
    ASSERT_NE(root_storage, nullptr);
    auto &root = *root_storage;
    char  frame_name[] = "root";
    root.name = frame_name;
    character.CObjectFrame::frame = &root;
    effects[2].point_max = 8;
    RS_STACKDATA args[7]{};
    for (auto &arg : args) {
        arg.type = RS_INT;
    }
    args[0].val.i = 0;
    args[1].val.i = 2;
    args[2].type = RS_STR;
    args[2].val.s = root.name;
    args[3].type = RS_STR;
    args[3].val.s = root.name;
    args[4].val.i = 6;
    args[5].val.i = 12;
    args[6].val.i = 4;
    ASSERT_TRUE(InvokeNativeExternal(EventScript.ext_func_table[EVENT_EXT_SWE_START_EFFECT], std::span(args).first(7), {}, frame_name));
    EXPECT_EQ(effects[2].frame0, &root);
    EXPECT_EQ(effects[2].frame1, &root);
    EXPECT_EQ(effects[2].length, 6);
    EXPECT_EQ(effects[2].hold_time, 4);
    EXPECT_EQ(effects[2].write_index, 7);
    EXPECT_FLOAT_EQ(effects[2].fade_speed, 1.0f / 12.0f);
}

TEST_F(EventSwordMemory, TextureUsesTheSelectedSlotAndPreservesItsRectangle) {
    std::vector<u_long128> texture_storage(1024);
    mgCMemory              texture_memory;
    texture_memory.stSetBuffer(texture_storage.data(), static_cast<int>(texture_storage.size()));
    mgTexManager.SetTableBuffer(8, 8, &texture_memory);
    mgTexManager.Initialize(0x1000, -1);
    mgCTexture texture{};
    std::strcpy(texture.name, "trail");
    texture.block = 7;
    const int      bucket = mgTexManager.hash(texture.name);
    mgTEXTURE_HASH link{.texture = &texture, .next = mgTexManager.hash_table[bucket]};
    mgTexManager.hash_table[bucket] = &link;
    for (auto &effect : effects) {
        effect.texture = nullptr;
    }
    RS_STACKDATA args[8]{};
    for (auto &arg : args) {
        arg.type = RS_INT;
    }
    args[0].val.i = 0;
    args[1].val.i = 2;
    args[2].val.i = texture.block;
    args[3].type = RS_STR;
    args[3].val.s = texture.name;
    for (int i = 4; i < 8; ++i) {
        args[i].val.i = 10 + i;
    }
    const int result = InvokeNativeExternal(EventScript.ext_func_table[EVENT_EXT_SWE_SET_TEXTURE], std::span(args).first(8), {}, texture.name);
    mgTexManager.hash_table[bucket] = link.next;
    mgTexManager.Initialize(0x1000, -1);
    ASSERT_TRUE(result);
    EXPECT_EQ(effects[0].texture, nullptr);
    EXPECT_EQ(effects[1].texture, nullptr);
    EXPECT_EQ(effects[2].texture, &texture);
    EXPECT_EQ(effects[2].tex_block, 7);
    EXPECT_EQ(effects[2].tex_u, 14);
    EXPECT_EQ(effects[2].tex_v, 15);
    EXPECT_EQ(effects[2].tex_w, 16);
    EXPECT_EQ(effects[2].tex_h, 17);
}

TEST_F(EventSwordMemory, MissingCharacterOrEffectReturnsFailure) {
    RS_STACKDATA args[10]{};
    for (auto &arg : args) {
        arg.type = RS_INT;
    }
    args[0].val.i = 1;
    EXPECT_FALSE(InvokeNativeExternal(EventScript.ext_func_table[EVENT_EXT_SWE_SET_COLOR], std::span(args).first(10)));
    args[0].val.i = 0;
    args[1].val.i = 1;
    character.sword_effect[1] = nullptr;
    EXPECT_FALSE(InvokeNativeExternal(EventScript.ext_func_table[EVENT_EXT_SWE_SET_COLOR], std::span(args).first(10)));
}

TEST_F(EventSwordMemory, RejectsSwordEffectSlotsOutsideTheCharacterArray) {
    RS_STACKDATA args[10]{};
    for (auto &arg : args) {
        arg.type = RS_INT;
    }
    args[0].val.i = 0;
    for (const int slot : {-1, CHARA_SWORD_EFFECT_MAX}) {
        args[1].val.i = slot;
        EXPECT_FALSE(InvokeNativeExternal(EventScript.ext_func_table[EVENT_EXT_SWE_INIT], std::span(args).first(5)));
        EXPECT_FALSE(InvokeNativeExternal(EventScript.ext_func_table[EVENT_EXT_SWE_SET_COLOR], std::span(args).first(10)));
        EXPECT_FALSE(InvokeNativeExternal(EventScript.ext_func_table[EVENT_EXT_SWE_SET_TEXTURE], std::span(args).first(8)));
        EXPECT_FALSE(InvokeNativeExternal(EventScript.ext_func_table[EVENT_EXT_SWE_START_EFFECT], std::span(args).first(7)));
    }
}
