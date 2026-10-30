#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <cstring>
#include <limits>
#include <span>
#include <string>

#include "mdslist.hpp"
#include "mg_dataset.hpp"
#include "mg_shadow.hpp"
#include "visualmotion.hpp"

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

namespace {
/**
 * Allocates each clone fixture payload in an independently retireable heap block.
 */
template <class T>
T *CloneTestObject(mgCMemory &memory) {
    if (memory.StartStackMode(MG_STACK_MODE_FIT, 256) == nullptr) {
        return nullptr;
    }
    auto *object = dc2::memory::NewObject<T>(memory);
    memory.EndStackMode();
    return object;
}

/**
 * Allocates an exactly bounded name in the frame producer for graph validation.
 */
bool CloneTestName(mgCMemory &memory, mgCFrame &frame) {
    if (memory.StartStackMode(MG_STACK_MODE_FIT, 16) == nullptr) {
        return false;
    }
    auto *name = dc2::memory::NewArray<char>(memory, 5);
    if (name != nullptr) {
        std::memcpy(name, "root", 5);
        frame.SetName(name);
    }
    memory.EndStackMode();
    return name != nullptr;
}
} // namespace

TEST(MgDataset, ClonePayloadsRequireExactProducerRegistration) {
    std::array<u_long128, 4096> source_storage{}, destination_storage{};
    mgCMemory                   source, destination;
    source.stSetBuffer(source_storage.data(), static_cast<int>(source_storage.size()));
    destination.stSetBuffer(destination_storage.data(), static_cast<int>(destination_storage.size()));
    mgCFrame structural;
    EXPECT_NE(mgCopyFrame(&structural, &destination, 0), nullptr);
    mgCFrameAttr stack_attr;
    structural.attr = &stack_attr;
    EXPECT_EQ(mgCopyFrame(&structural, &destination, 0), nullptr);
    structural.attr = nullptr;
    mgCVisualFixMDT stack_visual;
    structural.visual = &stack_visual;
    EXPECT_EQ(mgCopyFrame(&structural, &destination, 1), nullptr);
    const auto stack_visual_inputs = stack_visual.clone_inputs;
    EXPECT_EQ(stack_visual_inputs.Clone(&stack_visual, &destination), nullptr);
    auto *frame = dc2::memory::NewObject<mgCFrame>(source);
    ASSERT_NE(frame, nullptr);
    frame->attr = dc2::memory::NewObject<mgCFrameAttr>(source);
    ASSERT_NE(frame->attr, nullptr);
    ASSERT_TRUE(dc2::render::FrameCloneInputs::Publish(source, *frame));
    frame->attr->draw = 37;
    auto *copy = mgCopyFrame(frame, &destination, 0);
    ASSERT_NE(copy, nullptr);
    EXPECT_NE(copy->attr, frame->attr);
    EXPECT_EQ(copy->attr->draw, 37);
    EXPECT_TRUE(copy->clone_inputs.Matches(*copy));
    frame->attr = &stack_attr;
    EXPECT_EQ(mgCopyFrame(frame, &destination, 0), nullptr);
}

TEST(MgDataset, ClonePayloadRetirementDoesNotRetireTransformGraph) {
    for (int retired = 0; retired < 4; ++retired) {
        std::array<u_long128, 4096> source_storage{}, destination_storage{};
        mgCMemory                   source, destination;
        source.SetHeapMem(source_storage.data(), static_cast<int>(source_storage.size()));
        destination.stSetBuffer(destination_storage.data(), static_cast<int>(destination_storage.size()));
        auto *frame = CloneTestObject<mgCFrame>(source);
        ASSERT_NE(frame, nullptr);
        ASSERT_TRUE(CloneTestName(source, *frame));
        frame->attr = CloneTestObject<mgCFrameAttr>(source);
        frame->bound = CloneTestObject<mgCFrame::BoundInfo>(source);
        auto *visual = CloneTestObject<mgCVisualFixMDT>(source);
        auto *material = CloneTestObject<mgMaterial>(source);
        ASSERT_NE(frame->attr, nullptr);
        ASSERT_NE(frame->bound, nullptr);
        ASSERT_NE(visual, nullptr);
        ASSERT_NE(material, nullptr);
        visual->material = material;
        visual->material_num = 1;
        visual->material[0].diffuse[0] = 0.625f;
        frame->SetVisual(visual);
        ASSERT_TRUE(dc2::render::VisualCloneInputs::Publish(source, *visual, dc2::render::VisualCloneKind::FixMdt));
        ASSERT_TRUE(dc2::render::FrameCloneInputs::Publish(source, *frame, visual->clone_inputs));
        const auto graph = dc2::world::FrameGraph::Capture(source, frame);
        ASSERT_TRUE(graph.IsLive());
        auto *copy = mgCopyFrame(frame, &destination, 1);
        ASSERT_NE(copy, nullptr);
        EXPECT_NE(copy->attr, frame->attr);
        EXPECT_NE(copy->bound, frame->bound);
        EXPECT_NE(copy->visual, frame->visual);
        EXPECT_FLOAT_EQ(static_cast<mgCVisualFixMDT *>(copy->visual)->material[0].diffuse[0], 0.625f);
        const auto visual_inputs = visual->clone_inputs;
        void      *payloads[] = {frame->attr, frame->bound, visual, material};
        source.Free(reinterpret_cast<u_long128 *>(payloads[retired]));
        EXPECT_TRUE(graph.IsLive());
        EXPECT_EQ(graph.FindFrame("root"), frame);
        EXPECT_FALSE(frame->clone_inputs.Matches(*frame));
        EXPECT_EQ(mgCopyFrame(frame, &destination, 1), nullptr);
        if (retired == 2 || retired == 3) {
            EXPECT_FALSE(visual_inputs.Matches(visual));
            EXPECT_EQ(visual_inputs.Clone(visual, &destination), nullptr);
        }
        EXPECT_TRUE(copy->clone_inputs.Matches(*copy));
        source.stReset();
        EXPECT_TRUE(copy->clone_inputs.Matches(*copy));
    }
}

TEST(MgDataset, CloneVisualKindsKeepSharedAndDeepCopySemantics) {
    using dc2::render::VisualCloneKind;
    for (const auto kind : {VisualCloneKind::Mdt, VisualCloneKind::FixMdt, VisualCloneKind::ShadowMdt,
                            VisualCloneKind::ShadowFixMdt, VisualCloneKind::MotionMdt}) {
        std::array<u_long128, 4096> source_storage{}, destination_storage{};
        mgCMemory                   source, destination;
        source.stSetBuffer(source_storage.data(), static_cast<int>(source_storage.size()));
        destination.stSetBuffer(destination_storage.data(), static_cast<int>(destination_storage.size()));
        auto *frame = dc2::memory::NewObject<mgCFrame>(source);
        ASSERT_NE(frame, nullptr);
        mgCVisualMDT *visual = nullptr;
        switch (kind) {
            case VisualCloneKind::Mdt:
                visual = dc2::memory::NewObject<mgCVisualMDT>(source);
                break;
            case VisualCloneKind::FixMdt:
                visual = dc2::memory::NewObject<mgCVisualFixMDT>(source);
                break;
            case VisualCloneKind::ShadowMdt:
                visual = dc2::memory::NewObject<mgCShadowMDT>(source);
                break;
            case VisualCloneKind::ShadowFixMdt:
                visual = dc2::memory::NewObject<mgCShadowFixMDT>(source);
                break;
            case VisualCloneKind::MotionMdt:
                visual = dc2::memory::NewObject<mgCVisualMotionMDT>(source);
                break;
        }
        ASSERT_NE(visual, nullptr);
        visual->material = dc2::memory::NewArray<mgMaterial>(source, 2);
        visual->material_num = 2;
        ASSERT_NE(visual->material, nullptr);
        ASSERT_TRUE(dc2::render::VisualCloneInputs::Publish(source, *visual, kind));
        const auto source_visual_inputs = visual->clone_inputs;
        EXPECT_EQ(source_visual_inputs.Clone(nullptr, &destination), nullptr);
        auto *direct_copy = source_visual_inputs.Clone(visual, &destination);
        ASSERT_NE(direct_copy, nullptr);
        const bool shared = kind != VisualCloneKind::FixMdt && kind != VisualCloneKind::MotionMdt;
        EXPECT_EQ(direct_copy == visual, shared);
        frame->SetVisual(visual);
        ASSERT_TRUE(dc2::render::FrameCloneInputs::Publish(source, *frame, visual->clone_inputs));
        visual->material[1].diffuse[0] = 0.75f;
        auto *copy = mgCopyFrame(frame, &destination, 1);
        ASSERT_NE(copy, nullptr);
        const bool deep = kind == VisualCloneKind::FixMdt || kind == VisualCloneKind::MotionMdt;
        EXPECT_EQ(copy->visual == visual, !deep);
        if (deep) {
            const auto *copied = static_cast<mgCVisualMDT *>(copy->visual);
            EXPECT_NE(copied->material, visual->material);
            EXPECT_FLOAT_EQ(copied->material[1].diffuse[0], 0.75f);
        }
        source.stReset();
        EXPECT_EQ(copy->clone_inputs.Matches(*copy), deep);
    }
}

TEST(MgDataset, CloneMaterialsRejectIdentityChangesAndInvalidExtents) {
    using dc2::render::VisualCloneInputs;
    using dc2::render::VisualCloneKind;
    std::array<u_long128, 4096> storage{}, copies{};
    mgCMemory                   producer, destination;
    producer.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    destination.stSetBuffer(copies.data(), static_cast<int>(copies.size()));
    auto *visual = dc2::memory::NewObject<mgCVisualMotionMDT>(producer);
    ASSERT_NE(visual, nullptr);
    ASSERT_TRUE(VisualCloneInputs::Publish(producer, *visual, VisualCloneKind::MotionMdt));
    auto clone_inputs = visual->clone_inputs;
    EXPECT_NE(clone_inputs.Clone(visual, &destination), nullptr);
    visual->material_num = -1;
    EXPECT_EQ(clone_inputs.Clone(visual, &destination), nullptr);
    EXPECT_FALSE(VisualCloneInputs::Publish(producer, *visual, VisualCloneKind::MotionMdt));
    visual->material_num = 1;
    EXPECT_FALSE(VisualCloneInputs::Publish(producer, *visual, VisualCloneKind::MotionMdt));
    visual->material = dc2::memory::NewArray<mgMaterial>(producer, 1);
    ASSERT_NE(visual->material, nullptr);
    ASSERT_TRUE(VisualCloneInputs::Publish(producer, *visual, VisualCloneKind::MotionMdt));
    clone_inputs = visual->clone_inputs;
    visual->material_num = std::numeric_limits<int>::max();
    EXPECT_FALSE(VisualCloneInputs::Publish(producer, *visual, VisualCloneKind::MotionMdt));
    EXPECT_EQ(clone_inputs.Clone(visual, &destination), nullptr);
    visual->material_num = 1;
    ASSERT_TRUE(VisualCloneInputs::Publish(producer, *visual, VisualCloneKind::MotionMdt));
    clone_inputs = visual->clone_inputs;
    auto *original = visual->material;
    visual->material = dc2::memory::NewArray<mgMaterial>(producer, 1);
    EXPECT_EQ(clone_inputs.Clone(visual, &destination), nullptr);
    visual->material = original;
    EXPECT_TRUE(visual->clone_inputs.Matches(visual));
    destination.stSetLocked(true);
    EXPECT_EQ(clone_inputs.Clone(visual, &destination), nullptr);
}

TEST(MgDataset, SameAddressVisualReplacementRequiresNewPublication) {
    std::array<u_long128, 4096> storage{}, copies{};
    mgCMemory                   producer, destination;
    producer.SetHeapMem(storage.data(), static_cast<int>(storage.size()));
    destination.stSetBuffer(copies.data(), static_cast<int>(copies.size()));
    auto *visual = CloneTestObject<mgCVisualFixMDT>(producer);
    ASSERT_NE(visual, nullptr);
    ASSERT_TRUE(dc2::render::VisualCloneInputs::Publish(producer, *visual, dc2::render::VisualCloneKind::FixMdt));
    const auto old = visual->clone_inputs;
    producer.Free(reinterpret_cast<u_long128 *>(visual));
    auto *replacement = CloneTestObject<mgCVisualFixMDT>(producer);
    ASSERT_EQ(replacement, visual);
    EXPECT_FALSE(old.Matches(replacement));
    const auto unpublished_inputs = replacement->clone_inputs;
    EXPECT_EQ(unpublished_inputs.Clone(replacement, &destination), nullptr);
    EXPECT_EQ(old.Clone(replacement, &destination), nullptr);
    ASSERT_TRUE(dc2::render::VisualCloneInputs::Publish(producer, *replacement, dc2::render::VisualCloneKind::FixMdt));
    EXPECT_TRUE(replacement->clone_inputs.Matches(replacement));
    EXPECT_FALSE(old.Matches(replacement));
    const auto replacement_inputs = replacement->clone_inputs;
    EXPECT_EQ(old.Clone(replacement, &destination), nullptr);
    EXPECT_NE(replacement_inputs.Clone(replacement, &destination), nullptr);
}

TEST(MgDataset, BoundOnlyCloneAndDestinationFailuresStayUnpublished) {
    std::array<u_long128, 4096> storage{};
    mgCMemory                   source;
    source.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *frame = dc2::memory::NewObject<mgCFrame>(source);
    ASSERT_NE(frame, nullptr);
    frame->bound = dc2::memory::NewObject<mgCFrame::BoundInfo>(source);
    ASSERT_NE(frame->bound, nullptr);
    ASSERT_TRUE(dc2::render::FrameCloneInputs::Publish(source, *frame));
    frame->bound->radius = 7.5f;
    bool copied = false;
    for (int capacity = 1; capacity < 1024; ++capacity) {
        std::array<u_long128, 1024> destination_storage{};
        mgCMemory                   destination;
        destination.stSetBuffer(destination_storage.data(), capacity);
        auto *copy = mgCopyFrame(frame, &destination, 0);
        if (copy != nullptr) {
            EXPECT_TRUE(copy->clone_inputs.Matches(*copy));
            EXPECT_NE(copy->bound, frame->bound);
            EXPECT_FLOAT_EQ(copy->bound->radius, 7.5f);
            copied = true;
            break;
        }
    }
    EXPECT_TRUE(copied);
    auto *previous = frame->bound;
    frame->SetBound(dc2::memory::NewObject<mgCFrame::BoundInfo>(source));
    EXPECT_FALSE(frame->clone_inputs.Matches(*frame));
    frame->bound = previous;
    EXPECT_FALSE(frame->clone_inputs.Matches(*frame));
    ASSERT_TRUE(dc2::render::FrameCloneInputs::Publish(source, *frame));
    frame->SetVisual(dc2::memory::NewObject<mgCVisualMDT>(source));
    EXPECT_FALSE(frame->clone_inputs.Matches(*frame));
}

TEST(MgDataset, CrossProducerAttributePublicationRetainsTheExactFrameOwner) {
    std::array<u_long128, 4096> frames{}, attrs{}, copies{};
    mgCMemory                   frame_producer, attr_producer, destination;
    frame_producer.stSetBuffer(frames.data(), static_cast<int>(frames.size()));
    attr_producer.stSetBuffer(attrs.data(), static_cast<int>(attrs.size()));
    destination.stSetBuffer(copies.data(), static_cast<int>(copies.size()));
    auto *frame = dc2::memory::NewObject<mgCFrame>(frame_producer);
    ASSERT_NE(frame, nullptr);
    ASSERT_TRUE(dc2::render::FrameCloneInputs::Publish(frame_producer, *frame));
    const auto previous = frame->clone_inputs;
    frame->attr = dc2::memory::NewObject<mgCFrameAttr>(attr_producer);
    ASSERT_NE(frame->attr, nullptr);
    frame->attr->draw = 51;
    ASSERT_TRUE(previous.PublishChanges(*frame, &attr_producer));
    auto *copy = mgCopyFrame(frame, &destination, 0);
    ASSERT_NE(copy, nullptr);
    EXPECT_EQ(copy->attr->draw, 51);
    attr_producer.stReset();
    EXPECT_EQ(mgCopyFrame(frame, &destination, 0), nullptr);
    EXPECT_TRUE(copy->clone_inputs.Matches(*copy));
}

TEST(MgDataset, SavedMotionCapabilityRejectsRetiredObjectAndMaterialsBeforeMemberEntry) {
    for (const bool retire_object : {false, true}) {
        std::array<u_long128, 4096> storage{}, copies{};
        mgCMemory                   producer, destination;
        producer.SetHeapMem(storage.data(), static_cast<int>(storage.size()));
        destination.stSetBuffer(copies.data(), static_cast<int>(copies.size()));
        auto *visual = CloneTestObject<mgCVisualMotionMDT>(producer);
        ASSERT_NE(visual, nullptr);
        visual->material = CloneTestObject<mgMaterial>(producer);
        ASSERT_NE(visual->material, nullptr);
        visual->material_num = 1;
        ASSERT_TRUE(dc2::render::VisualCloneInputs::Publish(producer, *visual, dc2::render::VisualCloneKind::MotionMdt));
        const auto visual_inputs = visual->clone_inputs;
        producer.Free(reinterpret_cast<u_long128 *>(retire_object ? static_cast<void *>(visual) : static_cast<void *>(visual->material)));
        EXPECT_EQ(visual_inputs.Clone(visual, &destination), nullptr);
    }
}

TEST(MgDataset, DeepVisualDestinationFailureSweepReturnsOnlyCompleteCopies) {
    std::array<u_long128, 4096> storage{};
    mgCMemory                   source;
    source.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *frame = dc2::memory::NewObject<mgCFrame>(source);
    auto *visual = dc2::memory::NewObject<mgCVisualFixMDT>(source);
    ASSERT_NE(frame, nullptr);
    ASSERT_NE(visual, nullptr);
    frame->attr = dc2::memory::NewObject<mgCFrameAttr>(source);
    frame->bound = dc2::memory::NewObject<mgCFrame::BoundInfo>(source);
    visual->material = dc2::memory::NewArray<mgMaterial>(source, 3);
    visual->material_num = 3;
    ASSERT_NE(frame->attr, nullptr);
    ASSERT_NE(frame->bound, nullptr);
    ASSERT_NE(visual->material, nullptr);
    ASSERT_TRUE(dc2::render::VisualCloneInputs::Publish(source, *visual, dc2::render::VisualCloneKind::FixMdt));
    frame->SetVisual(visual);
    ASSERT_TRUE(dc2::render::FrameCloneInputs::Publish(source, *frame, visual->clone_inputs));
    bool copied = false;
    for (int capacity = 1; capacity < 1024; ++capacity) {
        std::array<u_long128, 1024> destination_storage{};
        mgCMemory                   destination;
        destination.stSetBuffer(destination_storage.data(), capacity);
        auto *copy = mgCopyFrame(frame, &destination, 1);
        if (copy != nullptr) {
            EXPECT_TRUE(copy->clone_inputs.Matches(*copy));
            ASSERT_NE(copy->visual, visual);
            EXPECT_NE(static_cast<mgCVisualFixMDT *>(copy->visual)->material, visual->material);
            copied = true;
            break;
        }
    }
    EXPECT_TRUE(copied);
}

TEST(MgDataset, RepeatedVisualTransitionsReuseTheExactRetainedPayloadMetadata) {
    std::array<u_long128, 4096> storage{};
    mgCMemory                   producer;
    producer.SetHeapMem(storage.data(), static_cast<int>(storage.size()));
    auto *frame = CloneTestObject<mgCFrame>(producer);
    auto *first = CloneTestObject<mgCVisualMDT>(producer);
    auto *second = CloneTestObject<mgCVisualFixMDT>(producer);
    ASSERT_NE(frame, nullptr);
    ASSERT_NE(first, nullptr);
    ASSERT_NE(second, nullptr);
    frame->attr = CloneTestObject<mgCFrameAttr>(producer);
    frame->bound = CloneTestObject<mgCFrame::BoundInfo>(producer);
    ASSERT_NE(frame->attr, nullptr);
    ASSERT_NE(frame->bound, nullptr);
    ASSERT_TRUE(dc2::render::VisualCloneInputs::Publish(producer, *first, dc2::render::VisualCloneKind::Mdt));
    ASSERT_TRUE(dc2::render::VisualCloneInputs::Publish(producer, *second, dc2::render::VisualCloneKind::FixMdt));
    frame->SetVisual(first);
    ASSERT_TRUE(dc2::render::FrameCloneInputs::Publish(producer, *frame, first->clone_inputs));
    const auto original = frame->clone_inputs;
    EXPECT_FALSE(original.PublishChanges(*frame, nullptr, &second->clone_inputs));
    EXPECT_TRUE(frame->clone_inputs.Matches(*frame));
    EXPECT_TRUE(frame->clone_inputs.SharesPayloadMetadata(original));
    for (int transition = 0; transition < 10000; ++transition) {
        const auto current = frame->clone_inputs;
        mgCVisual *next = transition % 2 == 0 ? static_cast<mgCVisual *>(second) : static_cast<mgCVisual *>(first);
        frame->SetVisual(next);
        ASSERT_FALSE(current.Matches(*frame));
        ASSERT_TRUE(current.PublishChanges(*frame, nullptr, &next->clone_inputs));
        ASSERT_TRUE(frame->clone_inputs.SharesPayloadMetadata(original));
        ASSERT_TRUE(frame->clone_inputs.Matches(*frame));
    }
    const auto current = frame->clone_inputs;
    frame->SetVisual(second);
    ASSERT_TRUE(current.PublishChanges(*frame, nullptr, &second->clone_inputs));
    producer.Free(reinterpret_cast<u_long128 *>(second));
    EXPECT_FALSE(frame->clone_inputs.Matches(*frame));
    EXPECT_FALSE(original.Matches(*frame));
    const auto retired_visual = frame->clone_inputs;
    frame->SetVisual(first);
    ASSERT_TRUE(retired_visual.PublishChanges(*frame, nullptr, &first->clone_inputs));
    EXPECT_TRUE(frame->clone_inputs.SharesPayloadMetadata(original));
    EXPECT_TRUE(frame->clone_inputs.Matches(*frame));
    producer.Free(reinterpret_cast<u_long128 *>(frame->attr));
    const auto retired_attr = frame->clone_inputs;
    frame->SetVisual(nullptr);
    const dc2::render::VisualCloneInputs absent;
    EXPECT_FALSE(retired_attr.PublishChanges(*frame, nullptr, &absent));
}

namespace {
/**
 * Detects whether an ordinary visual consumer can bypass the capability dispatcher.
 */
template <class Visual>
concept HasPublicVisualCopy = requires(Visual &visual, mgCMemory *memory) { visual.Copy(memory); };

static_assert(!HasPublicVisualCopy<mgCVisual>);
static_assert(!HasPublicVisualCopy<mgCVisualMDT>);
static_assert(!HasPublicVisualCopy<mgCVisualFixMDT>);
static_assert(!HasPublicVisualCopy<mgCVisualMotionMDT>);
static_assert(!HasPublicVisualCopy<mgCShadowMDT>);
static_assert(!HasPublicVisualCopy<mgCShadowFixMDT>);
} // namespace
