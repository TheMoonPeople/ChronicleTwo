#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <memory>
#include <vector>

#include "dng_effect.hpp"
#include "effscript.hpp"
#include "menudraw.hpp"
#include "mg_memory.hpp"
#include "native_script_program.hpp"
#include "runscript.hpp"

void SetEffectScriptFunc();
int  SetEffectScript(CRunScript *script, std::span<u8> program, mgCMemory *memory);

TEST(AfterImageMemory, PoisonedConstructionHasNoRibbonOrWireState) {
    alignas(CSWordAfterImage) std::array<std::byte, sizeof(CSWordAfterImage)> bytes{};
    bytes.fill(std::byte{0xA5});
    auto *image = ::new (bytes.data()) CSWordAfterImage;
    EXPECT_EQ(image->edge_point, nullptr);
    EXPECT_EQ(image->smooth_life, nullptr);
    EXPECT_EQ(image->point_num, 0);
    EXPECT_EQ(image->smooth_num, 0);
    EXPECT_EQ(image->active, 0);
    image->Step();
    image->Draw();
    std::destroy_at(image);
    alignas(CAfterWire) std::array<std::byte, sizeof(CAfterWire)> wire_bytes{};
    wire_bytes.fill(std::byte{0xA5});
    auto *wire = ::new (wire_bytes.data()) CAfterWire;
    EXPECT_EQ(wire->mode, 0);
    EXPECT_EQ(wire->point_num, 0);
    EXPECT_EQ(wire->smooth_num, 0);
    EXPECT_EQ(wire->oldest, 0);
    std::destroy_at(wire);
}

TEST(AfterImageMemory, InvalidAndExhaustedRibbonStorageIsRejectedBeforeAllocation) {
    std::vector<u_long128> bytes(1);
    mgCMemory              memory;
    memory.stSetBuffer(bytes.data(), bytes.size());
    CSWordAfterImage image;
    EXPECT_FALSE(image.Initialize(&memory, -1, 4));
    EXPECT_FALSE(image.Initialize(&memory, 4, -1));
    EXPECT_FALSE(image.Initialize(&memory, 4, std::numeric_limits<int>::max()));
    EXPECT_FALSE(image.Initialize(&memory, std::numeric_limits<int>::max(), 4));
    EXPECT_FALSE(image.Initialize(&memory, 4, 4));
    EXPECT_FALSE(image.Initialize(nullptr, 4, 4));
    EXPECT_EQ(memory.stack_used, 0);
    EXPECT_EQ(image.edge_point, nullptr);
    EXPECT_EQ(image.point_max, 0);
    EXPECT_EQ(image.active, 0);
}

TEST(AfterImageMemory, RibbonArraysRejectNonfiniteInputAndRetiredAllocationReuse) {
    std::vector<u_long128> bytes(128);
    mgCMemory              memory;
    memory.stSetBuffer(bytes.data(), bytes.size());
    CSWordAfterImage image;
    ASSERT_TRUE(image.Initialize(&memory, 4, 4));
    float edge[4] = {1.0f, 2.0f, 3.0f, 1.0f};
    float back[4] = {2.0f, 3.0f, 4.0f, 1.0f};
    image.AddPoint(edge, back, std::numeric_limits<float>::quiet_NaN());
    EXPECT_EQ(image.point_num, 0);
    for (int index = 0; index < 3; ++index) {
        image.AddPoint(edge, back, 1.0f);
    }
    image.CreatPointList();
    EXPECT_EQ(image.smooth_num, 4);
    EXPECT_TRUE(std::isfinite(image.smooth_life[0]));
    memory.stClearUsed();
    auto *reused = dc2::memory::NewArray<u8>(memory, 64);
    ASSERT_NE(reused, nullptr);
    std::fill_n(reused, 64, 0xA5);
    image.AddPoint(edge, back, 1.0f);
    image.Step();
    image.CreatPointList();
    image.Draw();
    EXPECT_EQ(image.edge_point, nullptr);
    EXPECT_EQ(image.point_num, 0);
    EXPECT_EQ(image.active, 0);
    EXPECT_TRUE(std::all_of(reused, reused + 64, [](u8 value) { return value == 0xA5; }));
}

TEST(AfterImageMemory, SharedSmoothingPreflightsOutputAndRingBounds) {
    sceVu0FVECTOR points[3] = {
        {0, 0, 0, 1},
        {1, 1, 1, 1},
        {2, 2, 2, 1}
    };
    sceVu0FVECTOR output[16];
    for (auto &point : output) {
        std::fill(std::begin(point), std::end(point), 17.0f);
    }
    EXPECT_EQ(CreatSmoothPass(std::span(output).first(4), points, 3, 4, 0), 0);
    EXPECT_EQ(CreatSmoothPass(output, points, 3, 0, 0), 0);
    EXPECT_EQ(CreatSmoothPass(output, points, 3, 4, 3), 0);
    for (const auto &point : output) {
        for (const float value : point) {
            EXPECT_FLOAT_EQ(value, 17.0f);
        }
    }
    // The exclusive two-thirds endpoint emits t=0 and t=1/3 for each of the two segments.
    EXPECT_EQ(CreatSmoothPass(output, points, 3, 4, 0), 4);
    EXPECT_FLOAT_EQ(output[0][3], 1.0f);
    EXPECT_FLOAT_EQ(output[0][0], 0.0f);
    EXPECT_NEAR(output[1][0], 7.0f / 27.0f, 0.000001f);
    EXPECT_FLOAT_EQ(output[2][0], 1.0f);
    EXPECT_NEAR(output[3][0], 37.0f / 27.0f, 0.000001f);
    EXPECT_FLOAT_EQ(output[4][0], 17.0f);
}

TEST(AfterImageMemory, DecorativeLinePointsRetainTheirRowExtentAndExactLease) {
    std::vector<u_long128> bytes(128);
    mgCMemory              memory;
    memory.stSetBuffer(bytes.data(), bytes.size());
    auto *points = dc2::memory::NewArray<int[2]>(memory, 50);
    ASSERT_NE(points, nullptr);
    dc2::menu::BindRandomLinePoints(memory, {points, 50});
    ASSERT_EQ(dc2::menu::RandomLinePoints().size(), 50);
    EXPECT_EQ(dc2::menu::RandomLinePoints()[49][1], 0);
    memory.stClearUsed();
    EXPECT_TRUE(dc2::menu::RandomLinePoints().empty());
    dc2::menu::BindRandomLinePoints(memory, {});
}

TEST(DungeonEffectMemory, PoolAllocationRejectsInvalidCountsAndExhaustionBeforePublication) {
    std::vector<u_long128> storage(1);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    const auto bytes = dc2::memory::RemainingBytes(memory);
    std::fill(bytes.begin(), bytes.end(), 0xA5);
    BattleEffectMan manager;
    for (int kind = BATTLE_EFFECT_HIT; kind <= BATTLE_EFFECT_CHARA; ++kind) {
        EXPECT_FALSE(manager.AllocEffect(kind, &memory, 1));
        EXPECT_FALSE(manager.AllocEffect(kind, &memory, -1));
        EXPECT_FALSE(manager.AllocEffect(kind, &memory, std::numeric_limits<int>::max()));
        EXPECT_FALSE(manager.AllocEffect(kind, nullptr, 1));
    }
    EXPECT_EQ(memory.stack_used, 0);
    EXPECT_TRUE(std::all_of(bytes.begin(), bytes.end(), [](u8 value) { return value == 0xA5; }));
    EXPECT_EQ(manager.hit, nullptr);
    EXPECT_EQ(manager.flush, nullptr);
    EXPECT_EQ(manager.power, nullptr);
    EXPECT_EQ(manager.dead, nullptr);
    EXPECT_EQ(manager.chara, nullptr);
    EXPECT_EQ(manager.hit_num, 0);
    EXPECT_EQ(manager.flush_num, 0);
    EXPECT_EQ(manager.power_num, 0);
    EXPECT_EQ(manager.dead_num, 0);
    EXPECT_EQ(manager.chara_num, 0);
}

TEST(DungeonEffectMemory, TypedPoolsStartInactiveAndFailedReplacementPreservesThem) {
    std::vector<u_long128> storage(8192);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    std::fill(dc2::memory::RemainingBytes(memory).begin(), dc2::memory::RemainingBytes(memory).end(), 0xA5);
    BattleEffectMan manager;
    for (int kind = BATTLE_EFFECT_HIT; kind <= BATTLE_EFFECT_CHARA; ++kind) {
        ASSERT_TRUE(manager.AllocEffect(kind, &memory, 2));
    }
    EXPECT_EQ(manager.hit[0].live_num, 0);
    EXPECT_EQ(manager.hit_prim[0].life, 0);
    EXPECT_EQ(manager.flush[0].active, 0);
    EXPECT_EQ(manager.power[0].duration, 0);
    EXPECT_EQ(manager.power_prim[0].life, 0);
    EXPECT_EQ(manager.dead[0].duration, 0);
    EXPECT_EQ(manager.dead_prim[0].life, 0);
    EXPECT_EQ(manager.chara_slot[0].chara, &manager.chara[0]);
    manager.hit_next = -1;
    manager.flush_next = std::numeric_limits<int>::max();
    manager.dead_next = -9;
    EXPECT_EQ(manager.NextHit(), &manager.hit[0]);
    EXPECT_EQ(manager.NextFlush(), &manager.flush[0]);
    EXPECT_EQ(manager.NextDead(), &manager.dead[0]);
    auto      *hit = manager.hit;
    const auto used = memory.stack_used;
    memory.stSetLocked(true);
    EXPECT_FALSE(manager.AllocEffect(BATTLE_EFFECT_HIT, &memory, 3));
    EXPECT_EQ(manager.hit, hit);
    EXPECT_EQ(manager.hit_num, 2);
    EXPECT_EQ(memory.stack_used, used);
    memory.stSetLocked(false);
    memory.stClearUsed();
    EXPECT_EQ(manager.NextHit(), nullptr);
    EXPECT_EQ(manager.NextFlush(), nullptr);
    EXPECT_EQ(manager.NextDead(), nullptr);
    EXPECT_EQ(manager.chara, nullptr);
    EXPECT_EQ(manager.chara_num, 0);
    manager.Step();
    manager.Draw();
}

TEST(DungeonEffectMemory, LightBallStorageUsesTypedInactiveEntriesAndRejectsFailedReplacement) {
    std::vector<u_long128> storage(128);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    CMapEffectsManeger manager;
    manager.Init_LightBoll(&memory, 2);
    ASSERT_NE(manager.sprite, nullptr);
    EXPECT_EQ(manager.sprite_num, 2);
    EXPECT_EQ(manager.sprite[0].life, 0);
    EXPECT_EQ(manager.sprite[1].life, 0);
    auto      *sprites = manager.sprite;
    const auto used = memory.stack_used;
    manager.Init_LightBoll(&memory, -1);
    manager.Init_LightBoll(nullptr, 1);
    memory.stSetLocked(true);
    manager.Init_LightBoll(&memory, 3);
    EXPECT_EQ(manager.sprite, sprites);
    EXPECT_EQ(manager.sprite_num, 2);
    EXPECT_EQ(memory.stack_used, used);
    memory.stSetLocked(false);
    memory.stClearUsed();
    manager.Step(nullptr);
    manager.Draw(nullptr);
    EXPECT_EQ(manager.sprite, nullptr);
    EXPECT_EQ(manager.sprite_num, 0);
}

TEST(EffectDistance, LengthCallbackPreservesTheCallerAndWritesTheOutputReference) {
    // A write to the fourth vector lane clobbers a saved register in RelWithDebInfo; Debug's stack layout hides it.
    std::vector<u_long128> storage(256);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    NativeScriptProgram program;
    CRunScript          script;
    SetEffectScriptFunc();
    ASSERT_TRUE(SetEffectScript(&script, program.Bytes(), &memory));

    RS_STACKDATA output = {};
    output.type = RS_FLOAT;
    output.val.f = -123.0f;
    RS_STACKDATA args[4] = {};
    args[0].type = RS_FLOAT;
    args[0].val.f = 3.0f;
    args[1].type = RS_INT;
    args[1].val.i = 4;
    args[2].type = RS_FLOAT;
    args[2].val.f = 12.0f;
    args[3].type = RS_PTR;
    args[3].val.p = &output;

    ASSERT_EQ(InvokeNativeExternal(script.ext_func_table[EFF_EXT_DIST_VECTOR], std::span(args).first(4), std::span(&output, 1)), 1);
    EXPECT_FLOAT_EQ(output.val.f, 13.0f);
    EXPECT_FLOAT_EQ(args[0].val.f, 3.0f);
    EXPECT_EQ(args[1].val.i, 4);
    EXPECT_FLOAT_EQ(args[2].val.f, 12.0f);
    EXPECT_EQ(args[3].val.p, &output);
    EXPECT_EQ(script.stack_num, 64);
}

TEST(EffectDistance, BetweenTwoVectorsPreservesInputsAndOutputReference) {
    // A write to the fourth vector lane clobbers a saved register in RelWithDebInfo; Debug's stack layout hides it.
    std::vector<u_long128> storage(256);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    NativeScriptProgram program;
    CRunScript          script;
    SetEffectScriptFunc();
    ASSERT_TRUE(SetEffectScript(&script, program.Bytes(), &memory));

    RS_STACKDATA output{};
    output.type = RS_FLOAT;
    output.val.f = -123;
    RS_STACKDATA args[7]{};
    const float  values[6] = {0, 0, 0, 3, 4, 12};
    for (int i = 0; i < 6; ++i) {
        args[i].type = RS_FLOAT;
        args[i].val.f = values[i];
    }
    args[6].type = RS_PTR;
    args[6].val.p = &output;
    ASSERT_EQ(InvokeNativeExternal(script.ext_func_table[EFF_EXT_DIST_VECTOR2], std::span(args).first(7), std::span(&output, 1)), 1);
    EXPECT_FLOAT_EQ(output.val.f, 13);
    for (int i = 0; i < 6; ++i) {
        EXPECT_FLOAT_EQ(args[i].val.f, values[i]);
    }
    EXPECT_EQ(args[6].val.p, &output);
}

TEST(DungeonEffectMemory, RandomIndicesExcludeTheFloatRoundedUpperEndpoint) {
    ASSERT_EXIT(([] {
                    constexpr unsigned maximum_seed = 2378021662u;
                    std::srand(maximum_seed);
                    if (std::rand() != std::numeric_limits<int>::max()) {
                        std::_Exit(2);
                    }
                    for (int limit : std::array<int, 3>{1, 2, std::numeric_limits<int>::max()}) {
                        std::srand(maximum_seed);
                        if (iRand(limit) != limit - 1) {
                            std::_Exit(3);
                        }
                    }
                    if (iRand(0) != 0 || iRand(std::numeric_limits<int>::min()) != 0) {
                        std::_Exit(4);
                    }
                    std::_Exit(0);
                }()),
                testing::ExitedWithCode(0), "");
}
