#include <gtest/gtest.h>

#include <cstddef>
#include <cstdint>
#include <cstring>

#include "arena_root.hpp"
#include "mg_memory.hpp"
#include "mg_memory_port.hpp"
#include "platform/arena.hpp"
#include "platform/memory.hpp"
#include "platform_fixture.hpp"

namespace {

struct Wide {
    unsigned char bytes[40];
};

u_long128 *Block(const void *key, int quadwords) {
    return reinterpret_cast<u_long128 *>(ArenaBlock(key, static_cast<std::size_t>(quadwords) * sizeof(u_long128)));
}

void NameArena(mgCMemory &memory, const char *name) {
    std::strncpy(memory.name, name, sizeof memory.name);
}

std::uintptr_t AddressOf(const void *pointer) {
    return reinterpret_cast<std::uintptr_t>(pointer);
}

} // namespace

TEST(CtArena, RootBufferMovesToItsOwnBlock) {
    static u_long128 retail[100];
    std::memset(retail, 0x11, sizeof retail);

    mgCMemory m;
    m.stSetBuffer(retail, 100);

    EXPECT_NE(m.stack, retail);
    EXPECT_TRUE(ArenaContains(m.stack));
    EXPECT_EQ(m.stack_size, 400);
    EXPECT_EQ(std::memcmp(m.stack, retail, 1600), 0);
    EXPECT_EQ(AddressOf(m.stack) % 64, 0u);
#ifndef NDEBUG
    EXPECT_TRUE(IsAbove4GiB(m.stack));
#endif
}

TEST(CtArena, SameRootBufferSameBlock) {
    static u_long128 retail[100];

    mgCMemory first;
    mgCMemory second;
    first.stSetBuffer(retail, 100);
    second.stSetBuffer(retail, 100);
    EXPECT_EQ(first.stack, second.stack);

    u_long128 *used = first.Alloc(10);
    ASSERT_NE(used, nullptr);
    first.stSetBuffer(retail, 100);
    EXPECT_EQ(first.stack, second.stack);
    EXPECT_EQ(first.stack_used, 0);
    EXPECT_EQ(first.Alloc(10), used);
}

TEST(CtArena, ChildViewStaysInPlace) {
    static u_long128 retail[100];

    mgCMemory m;
    m.stSetBuffer(retail, 100);
    u_long128 *carve = m.stAlloc(10);
    ASSERT_NE(carve, nullptr);

    mgCMemory child;
    child.stSetBuffer(carve, 10);
    EXPECT_EQ(child.stack, carve);
    EXPECT_EQ(child.stack_size, 10);
}

TEST(CtArena, NullBufferStaysNull) {
    mgCMemory m;
    m.stSetBuffer(nullptr, 0);
    EXPECT_EQ(m.stack, nullptr);
    EXPECT_EQ(m.stack_size, 0);

    mgCMemory heap;
    heap.SetHeapMem(nullptr, 0);
    EXPECT_EQ(heap.heap, nullptr);
}

TEST(CtArena, HeapOverARootGetsHeadroom) {
    static u_long128 retail_heap[0x100];

    mgCMemory m;
    m.SetHeapMem(retail_heap, 0x100);

    EXPECT_NE(m.heap, retail_heap);
    EXPECT_TRUE(ArenaContains(m.heap));
    EXPECT_EQ(m.heap_size, 0x400u);

    u_long128 *region = m.StartStackMode(1, 0);
    ASSERT_NE(region, nullptr);
    EXPECT_TRUE(ArenaContains(region));
}

TEST(CtArena, GuardPageEndsARoot) {
    static u_long128 retail[256];

    mgCMemory m;
    m.stSetBuffer(retail, 256);

    auto *base = reinterpret_cast<unsigned char *>(m.stack);
    const std::size_t end = std::size_t{256} * sizeof(u_long128) * kArenaHeadroom;
    KZ_ASSERT_FAULT([&] { base[end] = 1; });
    base[end - 1] = 1;
    EXPECT_EQ(base[end - 1], 1);
}

TEST(CtArena, OverflowNamesTheArena) {
    static char key;

    mgCMemory child;
    NameArena(child, "CtTest");
    child.stSetBuffer(Block(&key, 10), 10);

    EXPECT_DEATH(child.stAlloc(10), "arena CtTest: allocation overflow, 10 of 10 quadwords");
}

TEST(CtArena, OverflowOfAnUnnamedArenaGivesItsAddress) {
    static char key;

    mgCMemory child;
    child.stSetBuffer(Block(&key, 10), 10);

    // The child of a Windows death test is a fresh process, so the address is not this one's.
    // macOS extended regex has no \w, and gtest's own Windows matcher has no bracket expressions.
#ifdef GTEST_USES_POSIX_RE
    EXPECT_DEATH(child.stAlloc(10), "arena [[:alnum:]]+: allocation overflow, 10 of 10 quadwords");
#else
    EXPECT_DEATH(child.stAlloc(10), "arena \\w+: allocation overflow, 10 of 10 quadwords");
#endif
}

TEST(CtArena, PlacementGrowsTheLastRun) {
    static char key;

    mgCMemory m;
    m.stSetBuffer(Block(&key, 100), 100);

    u_long128 *p = m.Alloc(1);
    ASSERT_NE(p, nullptr);
    new (p) Wide;
    EXPECT_EQ(m.stack_used, 3);
    EXPECT_EQ(m.Alloc(1), p + 3);
}

TEST(CtArena, PlacementGrowsAnArray) {
    static char key;

    mgCMemory m;
    m.stSetBuffer(Block(&key, 100), 100);

    new (m.Alloc(1)) Wide[3];
    EXPECT_EQ(m.stack_used, 8);
}

TEST(CtArena, PlacementGrowsAnAlignedRun) {
    static char key;

    mgCMemory m;
    m.stSetBuffer(Block(&key, 100), 100);

    m.stAlloc(1);
    u_long128 *p = m.stAlloc64(1);
    ASSERT_NE(p, nullptr);
    EXPECT_EQ(AddressOf(p) % 64, 0u);
    new (p) Wide;
    EXPECT_EQ(m.Alloc(1), p + 3);
}

TEST(CtArena, PlacementLeavesARunThatFits) {
    static char key;

    mgCMemory m;
    m.stSetBuffer(Block(&key, 100), 100);

    u_long128 *p = m.Alloc(4);
    ASSERT_NE(p, nullptr);
    new (p) Wide;
    EXPECT_EQ(m.stack_used, 4);
}

TEST(CtArena, PlacementLeavesARunThatIsNoLongerTheLast) {
    static char key;

    mgCMemory m;
    m.stSetBuffer(Block(&key, 100), 100);

    u_long128 *p = m.Alloc(1);
    ASSERT_NE(p, nullptr);
    m.Alloc(1);
    new (p) Wide;
    EXPECT_EQ(m.stack_used, 2);
}

TEST(CtArena, PlacementLeavesStorageNoArenaHandedOut) {
    static char key;

    mgCMemory m;
    m.stSetBuffer(Block(&key, 100), 100);
    ASSERT_NE(m.Alloc(1), nullptr);
    const int used = m.stack_used;

    alignas(16) u_long128 local[4];
    new (local) Wide;
    EXPECT_EQ(m.stack_used, used);
}

TEST(CtArena, PlacementPastTheEndAborts) {
    static char key;

    mgCMemory m;
    NameArena(m, "CtTest");
    m.stSetBuffer(Block(&key, 3), 3);

    u_long128 *p = m.Alloc(1);
    ASSERT_NE(p, nullptr);
    EXPECT_DEATH(new (p) Wide, "arena CtTest: allocation overflow, 3 of 3 quadwords");
}

TEST(CtArena, MainBufferLiesAboveFourGiB) {
    static char key;

    u_long128 *base = ArenaRoot(&key, 0x1000, "CtMain");
    EXPECT_EQ(AddressOf(base) % 64, 0u);
    EXPECT_TRUE(ArenaContains(base));
#ifndef NDEBUG
    EXPECT_TRUE(IsAbove4GiB(base));
#endif
}

TEST(CtArena, RootRebindKeepsLoadedContents) {
    static u_long128 retail[100] = {};
    mgCMemory        memory;
    memory.stSetBuffer(retail, 100);
    auto *loaded = memory.Alloc(4);
    ASSERT_NE(loaded, nullptr);
    std::memset(loaded, 0x5A, 4 * sizeof(u_long128));

    // A cursor reset must keep data referenced by a loaded sound bank alive.
    memory.stSetBuffer(retail, 100);
    EXPECT_EQ(memory.stack_used, 0);
    EXPECT_EQ(memory.stack, loaded);
    for (int i = 0; i < 4 * sizeof(u_long128); ++i) {
        EXPECT_EQ(reinterpret_cast<unsigned char *>(loaded)[i], 0x5A) << i;
    }
}
