#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <cstring>
#include <limits>
#include <span>
#include <string>

#include "mg_dataset.hpp"

TEST(MgDataset, FrameNameConversionOwnsLongOutputAndStopsAtIncompleteAttributes) {
    EXPECT_EQ(ConvertFrameName("body__cN"), "body--c0n1");
    EXPECT_EQ(ConvertFrameName("body__a12"), "body--a12");
    EXPECT_EQ(ConvertFrameName("body__a"), "body--");
    EXPECT_EQ(ConvertFrameName("body__a1"), "body--");
    const std::string long_name = "x__" + std::string(300, 'c');
    const auto        converted = ConvertFrameName(long_name);
    std::string       expected = "x--";
    for (int index = 0; index < 300; ++index) {
        expected += "c0";
    }
    EXPECT_GT(converted.size(), 512u);
    EXPECT_EQ(converted, expected);
}

TEST(MgDataset, MaterialTextureNameFitsSerializedField) {
    std::array<u_long128, 256> storage{};
    mgCMemory                  memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    mgCMDTBuilder builder;
    builder.Begin(&memory);
    builder.BeginData(MG_MDT_DATA_MATERIAL);

    const float       colour[4] = {1.0f, 0.5f, 0.25f, 1.0f};
    const std::string long_name(100, 'x');
    MDT_MATERIAL_    *first = builder.material_cursor;
    builder.SetMaterial(colour, long_name.c_str());
    EXPECT_EQ(std::string(first->texture), long_name.substr(0, sizeof first->texture - 1));
    EXPECT_EQ(first->unk_54, 0);

    const std::string split_name = std::string(30, 'x') + "\x82\xA0";
    MDT_MATERIAL_    *second = builder.material_cursor;
    builder.SetMaterial(colour, split_name.c_str());
    EXPECT_EQ(std::string(second->texture), std::string(30, 'x'));
    EXPECT_EQ(second->unk_54, 0);
}

TEST(MgDataset, CopyFrameTableDoesNotOverlapFrames) {
    constexpr int                  count = 64;
    std::array<mgCFrame, count>    frames;
    std::array<mgCFrame *, count>  table{};
    std::array<std::string, count> names;
    for (int i = 0; i < count; ++i) {
        names[i] = "frame" + std::to_string(i);
        frames[i].SetName(names[i].data());
        frames[i].SetPosition(static_cast<float>(i), 2.0f, 3.0f);
        table[i] = &frames[i];
    }
    frames[0].frame_num = count;
    frames[0].frame_list = table.data();

    static u_long128 storage[4096];
    mgCMemory        memory;
    memory.stSetBuffer(storage, 4096);
    mgCFrame *copy = mgCopyFrame(frames.data(), &memory, 0);
    ASSERT_NE(copy, nullptr);
    ASSERT_EQ(copy->frame_num, count);
    ASSERT_NE(copy->frame_list, nullptr);
    ASSERT_LE(reinterpret_cast<std::uintptr_t>(copy->frame_list + count),
              reinterpret_cast<std::uintptr_t>(copy));
    for (int i = 0; i < count; ++i) {
        mgCFrame *node = copy->frame_list[i];
        ASSERT_EQ(node, copy + i);
        EXPECT_STREQ(node->name, names[i].c_str());
        EXPECT_FLOAT_EQ(node->position[0], static_cast<float>(i));
        EXPECT_EQ(node->parent, nullptr);
        EXPECT_EQ(node->child, nullptr);
        EXPECT_EQ(node->brother, nullptr);
        EXPECT_EQ(frames[i].name, names[i].data());
    }
}

TEST(MgDataset, CopyFrameRejectsWrappedCountAndInsufficientArenaBeforeMutation) {
    mgCFrame  frame;
    mgCFrame *table[] = {&frame, &frame};
    frame.frame_list = table;
    std::array<u_long128, 8> storage{};
    mgCMemory                memory;
    memory.stSetBuffer(storage.data(), 1);

    frame.frame_num = std::numeric_limits<int>::max();
    EXPECT_EQ(mgCopyFrame(&frame, &memory, 0), nullptr);
    EXPECT_EQ(memory.stGetUsed(), 0);

    frame.frame_num = 2;
    EXPECT_EQ(mgCopyFrame(&frame, &memory, 0), nullptr);
    EXPECT_EQ(memory.stGetUsed(), 0);

    frame.frame_num = -1;
    EXPECT_EQ(mgCopyFrame(&frame, &memory, 0), nullptr);
    EXPECT_EQ(memory.stGetUsed(), 0);
}

TEST(MgDataset, CopyFrameRebuildsHierarchyInCopiedFrames) {
    constexpr int                  count = 68;
    std::array<mgCFrame, count>    frames;
    std::array<mgCFrame *, count>  table{};
    std::array<std::string, count> names;
    for (int i = 0; i < count; ++i) {
        names[i] = "bone" + std::to_string(i);
        frames[i].SetName(names[i].data());
        table[i] = &frames[i];
        if (i > 0) {
            frames[i].SetParent(&frames[i - 1]);
        }
    }
    frames[0].frame_num = count;
    frames[0].frame_list = table.data();

    static u_long128 storage[4096];
    mgCMemory        memory;
    memory.stSetBuffer(storage, 4096);
    mgCFrame *copy = mgCopyFrame(frames.data(), &memory, 0);
    ASSERT_NE(copy, nullptr);
    ASSERT_EQ(copy->frame_num, count);
    ASSERT_EQ(copy->parent, nullptr);
    for (int i = 0; i < count; ++i) {
        ASSERT_EQ(copy->frame_list[i], copy + i);
        EXPECT_EQ(copy[i].parent, i > 0 ? copy + i - 1 : nullptr);
        EXPECT_EQ(copy[i].child, i + 1 < count ? copy + i + 1 : nullptr);
        EXPECT_EQ(copy[i].brother, nullptr);
        EXPECT_EQ(frames[i].parent, i > 0 ? &frames[i - 1] : nullptr);
    }
    EXPECT_EQ(copy->SearchFrame(names.back().data()), copy + count - 1);
}

TEST(MgDataset, BuilderRejectsOverflowBeforeTouchingArenaSentinel) {
    std::array<u_long128, 128> backing{};
    mgCMemory                  parent;
    parent.stSetBuffer(backing.data(), static_cast<int>(backing.size()));
    constexpr int capacity = static_cast<int>((sizeof(MDT_HEADER) + 15) / 16) + 3;
    u_long128    *storage = parent.stAlloc(capacity);
    std::memset(storage, 0xA5, static_cast<std::size_t>(capacity) * sizeof(u_long128));
    mgCMemory memory;
    memory.stSetBuffer(storage, capacity);
    mgCMDTBuilder builder;
    builder.Begin(&memory);
    ASSERT_NE(builder.header, nullptr);
    builder.BeginData(MG_MDT_DATA_VERTEX);
    for (int index = 0; index < 3; ++index) {
        builder.SetData(1.0f, 2.0f, 3.0f, 1.0f);
    }
    EXPECT_TRUE(builder.failed);
    builder.EndData();
    EXPECT_EQ(builder.End(), nullptr);
    const auto sentinel = std::as_bytes(std::span(storage + capacity - 1, 1));
    for (const auto byte : sentinel) {
        EXPECT_EQ(byte, std::byte{0xA5});
    }
}

TEST(MgDataset, BuilderRejectsResetOrInterveningAllocation) {
    std::array<u_long128, 128> backing{};
    mgCMemory                  parent;
    parent.stSetBuffer(backing.data(), static_cast<int>(backing.size()));
    u_long128 *storage = parent.stAlloc(32);
    mgCMemory  memory;
    memory.stSetBuffer(storage, 32);
    mgCMDTBuilder builder;
    builder.Begin(&memory);
    builder.BeginData(MG_MDT_DATA_VERTEX);
    ASSERT_NE(memory.Alloc(1), nullptr);
    builder.SetData(1.0f, 2.0f, 3.0f, 1.0f);
    EXPECT_TRUE(builder.failed);
    EXPECT_EQ(builder.End(), nullptr);

    memory.stReset();
    builder.Begin(&memory);
    builder.BeginData(MG_MDT_DATA_VERTEX);
    memory.stReset();
    std::memset(storage, 0xD3, 32 * sizeof(u_long128));
    builder.SetData(1.0f, 2.0f, 3.0f, 1.0f);
    EXPECT_TRUE(builder.failed);
    EXPECT_EQ(builder.End(), nullptr);
    for (const auto byte : std::as_bytes(std::span(storage, 32))) {
        EXPECT_EQ(byte, std::byte{0xD3});
    }
}

TEST(MgDataset, BuilderReservesOnlyItsCompletedModelExtent) {
    std::array<u_long128, 128> backing{};
    mgCMemory                  parent;
    parent.stSetBuffer(backing.data(), static_cast<int>(backing.size()));
    mgCMemory memory;
    memory.stSetBuffer(parent.stAlloc(32), 32);
    mgCMDTBuilder builder;
    builder.Begin(&memory);
    builder.BeginData(MG_MDT_DATA_VERTEX);
    builder.SetData(1.0f, 2.0f, 3.0f, 1.0f);
    builder.EndData();
    builder.BeginFaces();
    builder.BeginPrim(MG_FACE_NO_NORMAL | MG_FACE_NO_TEXTURE, -1);
    builder.AddFace(0);
    builder.EndPrim();
    builder.EndFaces();
    const auto *header = builder.End();
    ASSERT_NE(header, nullptr);
    EXPECT_EQ(header->vertex_num, 1);
    EXPECT_EQ(reinterpret_cast<std::uintptr_t>(memory.stGetTop()),
              reinterpret_cast<std::uintptr_t>(builder.end));
    EXPECT_NE(builder.End(), nullptr);
}

TEST(MgDataset, CopyFrameRejectsInsufficientNameStorageWithoutWritingPastArena) {
    std::array<u_long128, 256> backing{};
    mgCMemory                  parent;
    parent.stSetBuffer(backing.data(), static_cast<int>(backing.size()));
    constexpr int capacity = static_cast<int>((sizeof(mgCFrame) + 15) / 16) + 2;
    auto         *storage = parent.stAlloc(capacity);
    std::memset(storage, 0xA5, static_cast<std::size_t>(capacity) * sizeof(u_long128));
    mgCMemory memory;
    memory.stSetBuffer(storage, capacity);
    mgCFrame    source;
    std::string name(100, 'x');
    source.SetName(name.data());
    EXPECT_EQ(mgCopyFrame(&source, &memory, 0), nullptr);
    for (const auto byte : std::as_bytes(std::span(storage + capacity - 1, 1))) {
        EXPECT_EQ(byte, std::byte{0xA5});
    }
    EXPECT_EQ(source.name, name.data());
}
