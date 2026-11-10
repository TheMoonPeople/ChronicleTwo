#include <gtest/gtest.h>

#include <csignal>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <span>
#include <stdexcept>
#include <type_traits>

#include "arena_root.hpp"
#include "mainloop.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "platform/arena.hpp"
#include "platform/arena_usage.hpp"
#include "platform/memory.hpp"
#include "platform_fixture.hpp"

namespace {

static_assert(!std::is_copy_constructible_v<mgCMemory>);
static_assert(!std::is_copy_assignable_v<mgCMemory>);
static_assert(!std::is_move_constructible_v<mgCMemory>);
static_assert(!std::is_move_assignable_v<mgCMemory>);

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

TEST(CtArena, ReadBufferBindingRejectsReusedArenaStorage) {
    alignas(u_long128) u_long128 backing_storage[64]{};
    mgCMemory                    backing;
    backing.stSetBuffer(backing_storage, 64);
    mgCMemory owner;
    owner.stSetBuffer(backing.stAlloc(24), 24);

    auto *buffer = owner.stAlloc(4);
    BindReadBuffer(std::span<u8>(reinterpret_cast<u8 *>(buffer), 4 * sizeof(u_long128)), owner, &backing);
    EXPECT_EQ(ReadBufferBytes().size(), 4 * sizeof(u_long128));

    owner.stAlloc(2);
    EXPECT_EQ(ReadBufferBytes().size(), 4 * sizeof(u_long128));

    owner.stReset();
    auto *replacement = owner.stAlloc(4);
    EXPECT_EQ(replacement, buffer);
    std::memset(replacement, 0xA5, 4 * sizeof(u_long128));
    EXPECT_TRUE(ReadBufferBytes().empty());
    EXPECT_EQ(reinterpret_cast<const u8 *>(replacement)[0], 0xA5);

    BindReadBuffer(std::span<u8>(reinterpret_cast<u8 *>(replacement), 4 * sizeof(u_long128)), owner, &backing);
    EXPECT_EQ(ReadBufferBytes().size(), 4 * sizeof(u_long128));
    backing.stReset();
    EXPECT_TRUE(ReadBufferBytes().empty());

    alignas(u_long128) u_long128 alien[4]{};
    BindReadBuffer(std::span<u8>(reinterpret_cast<u8 *>(alien), sizeof alien), owner);
    EXPECT_TRUE(ReadBufferBytes().empty());

    BindReadBuffer({}, owner);
}

TEST(CtArena, ChildArenaCannotExceedImmediateParentAllocation) {
    alignas(u_long128) u_long128 storage[64]{};
    mgCMemory                    parent;
    parent.stSetBuffer(storage, 64);
    auto     *lease = parent.stAlloc(8);
    mgCMemory child;

    EXPECT_DEATH(child.stSetBuffer(lease, 9), "child arena extent 9 exceeds allocated 8");
    child.stSetBuffer(lease, 8);
    EXPECT_EQ(child.stGetSize(), 8);
}

TEST(CtArena, ExternalRootMayReuseAddressOfDestroyedAllocation) {
    static char key;
    auto       *root = Block(&key, 0xA00);
    {
        mgCMemory previous;
        previous.stSetBuffer(root, 0xA00);
        ASSERT_EQ(previous.stAlloc(1), root);
    }

    mgCMemory external;
    external.stSetBuffer(root, 0xA00);
    EXPECT_EQ(external.stack, root);
    EXPECT_EQ(external.stGetSize(), 0xA00);
    ASSERT_EQ(external.stAlloc(1), root);
}

TEST(CtArena, RootMayRebindOverItsOwnPreviousAllocation) {
    static char key;
    auto       *root = Block(&key, 100);
    mgCMemory   arena;
    arena.stSetBuffer(root, 100);
    ASSERT_EQ(arena.stAlloc(40), root);

    arena.stSetBuffer(root, 64);
    EXPECT_EQ(arena.stack, root);
    EXPECT_EQ(arena.stGetSize(), 64);
    EXPECT_EQ(arena.stGetUsed(), 0);
}

TEST(CtArena, RootRebindCannotClaimBeyondPreviousRootOrInteriorTail) {
    static char key;
    auto       *root = Block(&key, 64);
    mgCMemory   arena;
    arena.stSetBuffer(root, 64);
    ASSERT_EQ(arena.stAlloc(40), root);

    EXPECT_DEATH(arena.stSetBuffer(root, 128), "arena rebind extent 128 exceeds current root");
    EXPECT_DEATH(arena.stSetBuffer(root + 10, 55), "arena rebind extent 55 exceeds current root");
    arena.stSetBuffer(root + 10, 54);
    EXPECT_EQ(arena.stack, root + 10);
    EXPECT_EQ(arena.stGetSize(), 54);
}

TEST(CtArena, AllocationLeaseTracksExactExtentAndReset) {
    alignas(u_long128) u_long128 storage[64]{};
    mgCMemory                    arena;
    arena.stSetBuffer(storage, 64);
    auto *first = arena.stAlloc(8);
    arena.stAlloc(4);

    EXPECT_EQ(dc2::memory::AllocationBytes(arena, first).size(), 8 * sizeof(u_long128));
    EXPECT_EQ(dc2::memory::AllocationBytes(arena, first + 2).size(), 6 * sizeof(u_long128));
    EXPECT_EQ(dc2::memory::AllocationBytes(arena, first + 8).size(), 4 * sizeof(u_long128));
    EXPECT_TRUE(dc2::memory::AllocationBytes(arena, first + 12).empty());

    arena.stReset();
    EXPECT_TRUE(dc2::memory::AllocationBytes(arena, first).empty());
    auto *replacement = arena.stAlloc(8);
    EXPECT_EQ(replacement, first);
    EXPECT_EQ(dc2::memory::AllocationBytes(arena, replacement).size(), 8 * sizeof(u_long128));

    arena.lock = 7;
    arena.stClearUsed();
    EXPECT_EQ(arena.lock, 7);
    EXPECT_EQ(arena.stGetUsed(), 0);
    EXPECT_TRUE(dc2::memory::AllocationBytes(arena, replacement).empty());
}

TEST(CtArena, PacketDataBufferRejectsShortPoolsBeforeChangingBinding) {
    alignas(u_long128) static u_long128 first_storage[0x900]{};
    alignas(u_long128) static u_long128 second_storage[0x900]{};
    alignas(u_long128) static u_long128 short_storage[0x100]{};
    mgCMemory                           first;
    mgCMemory                           second;
    mgCMemory                           short_pool;
    first.stSetBuffer(first_storage, 0x900);
    second.stSetBuffer(second_storage, 0x900);
    short_pool.stSetBuffer(short_storage, 0x100);
    const int expected_child_size = first.stGetRest() - 0x800;

    mgSetDataBuffer(&first, &second, 1);
    mgCMemory *bound = mgGetDataBuffer();
    ASSERT_NE(bound, nullptr);
    const auto *previous = bound->stack;
    EXPECT_EQ(bound->stGetSize(), expected_child_size);

    EXPECT_THROW(mgSetDataBuffer(&first, &short_pool, 1), std::length_error);
    EXPECT_THROW(mgSetDataBuffer(nullptr, &second, 1), std::length_error);
    EXPECT_EQ(bound->stack, previous);
    EXPECT_EQ(bound->stGetSize(), expected_child_size);
}

TEST(CtArena, PacketDataBufferRetainsTemporaryCursorBackingUntilItsOwnerResets) {
    static char allocation_key;
    mgCMemory   owner;
    owner.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&allocation_key, 0x3000 * sizeof(u_long128))), 0x3000);
    mgCMemory *bound = nullptr;
    {
        mgCMemory first;
        mgCMemory second;
        first.stSetBorrowedBuffer(owner, std::span(owner.stAlloc64(0x1000), 0x1000));
        second.stSetBorrowedBuffer(owner, std::span(owner.stAlloc64(0x1000), 0x1000));
        mgSetDataBuffer(&first, &second, 1);
        bound = mgGetDataBuffer();
        ASSERT_NE(bound, nullptr);
        ASSERT_TRUE(dc2::memory::ArenaStorageLive(*bound));
    }
    ASSERT_TRUE(dc2::memory::ArenaStorageLive(*bound));
    ASSERT_FALSE(dc2::memory::RemainingBytes(*bound).empty());
    EXPECT_NE(bound->Alloc(1), nullptr);
    owner.stReset();
    EXPECT_TRUE(dc2::memory::RemainingBytes(*bound).empty());
    EXPECT_EQ(bound->Alloc(1), nullptr);
}

TEST(CtArena, PacketDataBufferRetainsTheLifetimeOfAGenuinePoolOwner) {
    static char allocation_key;
    mgCMemory   owner;
    owner.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&allocation_key, 0x3000 * sizeof(u_long128))), 0x3000);
    mgCMemory *bound = nullptr;
    {
        mgCMemory first;
        mgCMemory second;
        first.stSetChildBuffer(owner, owner.stAlloc64(0x1000), 0x1000);
        second.stSetChildBuffer(owner, owner.stAlloc64(0x1000), 0x1000);
        mgSetDataBuffer(&first, &second, 1);
        bound = mgGetDataBuffer();
        ASSERT_NE(bound, nullptr);
        ASSERT_TRUE(dc2::memory::ArenaStorageLive(*bound));
    }
    EXPECT_TRUE(dc2::memory::RemainingBytes(*bound).empty());
    EXPECT_EQ(bound->Alloc(1), nullptr);
    EXPECT_TRUE(dc2::memory::ArenaStorageLive(owner));
}

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

TEST(CtArena, RemainingBytesUsesValidatedArenaExtent) {
    u_long128 storage[8]{};
    mgCMemory memory;
    memory.stSetBuffer(storage, 8);
    EXPECT_EQ(dc2::memory::RemainingBytes(memory).size(),
              static_cast<std::size_t>(memory.stack_size) * sizeof(u_long128));
    ASSERT_NE(memory.stAlloc(3), nullptr);
    EXPECT_EQ(dc2::memory::RemainingBytes(memory).data(),
              reinterpret_cast<u8 *>(memory.stGetTop()));
    EXPECT_EQ(dc2::memory::RemainingBytes(memory).size(),
              static_cast<std::size_t>(memory.stack_size - 3) * sizeof(u_long128));
    memory.stack_used = memory.stack_size + 1;
    EXPECT_TRUE(dc2::memory::RemainingBytes(memory).empty());
    memory.stack_used = -1;
    EXPECT_TRUE(dc2::memory::RemainingBytes(memory).empty());
}

TEST(CtArena, AvailableFromChecksBorrowedPointerAgainstArenaExtent) {
    u_long128 storage[8]{};
    mgCMemory memory;
    memory.stSetBuffer(storage, 8);
    auto      *inside = reinterpret_cast<u8 *>(memory.stack + 2) + 3;
    const auto available = dc2::memory::AvailableFrom(memory, inside);
    EXPECT_EQ(available.data(), inside);
    EXPECT_EQ(available.size(), static_cast<std::size_t>(memory.stack_size - 2) * sizeof(u_long128) - 3);
    EXPECT_TRUE(dc2::memory::AvailableFrom(memory, storage).empty());
    EXPECT_TRUE(dc2::memory::AvailableFrom(memory, memory.stack + memory.stack_size).empty());
    EXPECT_TRUE(dc2::memory::AvailableFrom(memory, nullptr).empty());
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

    auto             *base = reinterpret_cast<unsigned char *>(m.stack);
    const std::size_t end = std::size_t{256} * sizeof(u_long128) * kArenaHeadroom;
    auto              write_guard = [&] {
        std::signal(SIGSEGV, SIG_DFL);
#ifdef SIGBUS
        std::signal(SIGBUS, SIG_DFL);
#endif
        base[end] = 1;
    };
    KZ_ASSERT_FAULT(write_guard);
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
    EXPECT_EQ(dc2::memory::AllocationBytes(m, p).size(), 3 * sizeof(u_long128));
    EXPECT_EQ(m.Alloc(1), p + 3);
}

TEST(CtArena, TypedObjectAllocationKeepsTheFollowingLeaseSeparate) {
    static char key;
    mgCMemory   arena;
    arena.stSetBuffer(Block(&key, 16), 16);
    auto *object = dc2::memory::NewObject<Wide>(arena);
    ASSERT_NE(object, nullptr);
    auto *following = arena.Alloc(1);
    ASSERT_NE(following, nullptr);
    reinterpret_cast<u8 *>(following)[0] = 0x5A;
    object->bytes[sizeof object->bytes - 1] = 0xA5;
    EXPECT_GE(reinterpret_cast<std::uintptr_t>(following),
              reinterpret_cast<std::uintptr_t>(object) + sizeof(Wide));
    EXPECT_EQ(object->bytes[sizeof object->bytes - 1], 0xA5);
    EXPECT_EQ(reinterpret_cast<u8 *>(following)[0], 0x5A);
    EXPECT_EQ(dc2::memory::AllocationBytes(arena, object).size(), 3 * sizeof(u_long128));
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

TEST(CtArena, ReadBufferLeaseRejectsFreedHeapAllocationAtReusedAddress) {
    static char key;
    mgCMemory   memory;
    memory.SetHeapMem(Block(&key, 128), 128);
    ASSERT_NE(memory.StartStackMode(MG_STACK_MODE_FIT, 8), nullptr);
    auto *original = memory.Alloc(8);
    memory.EndStackMode();
    BindReadBuffer(std::span(reinterpret_cast<u8 *>(original), 8 * sizeof(u_long128)), memory);
    const auto previous = ReadBufferLease();
    ASSERT_EQ(previous.Bytes().size(), 8 * sizeof(u_long128));
    memory.Free(original);
    EXPECT_TRUE(ReadBufferBytes().empty());
    ASSERT_NE(memory.StartStackMode(MG_STACK_MODE_FIT, 8), nullptr);
    auto *replacement = memory.Alloc(8);
    memory.EndStackMode();
    ASSERT_EQ(replacement, original);
    EXPECT_TRUE(ReadBufferBytes().empty());
    EXPECT_TRUE(ReadBufferLease().Bytes().empty());
    EXPECT_TRUE(previous.Bytes().empty());
    BindReadBuffer(std::span(reinterpret_cast<u8 *>(replacement), 8 * sizeof(u_long128)), memory);
    EXPECT_EQ(ReadBufferLease().Bytes().size(), 8 * sizeof(u_long128));
    EXPECT_TRUE(previous.Bytes().empty());
    BindReadBuffer({}, memory);
}
