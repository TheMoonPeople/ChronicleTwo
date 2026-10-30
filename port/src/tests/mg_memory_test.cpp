#include <gtest/gtest.h>

#include <array>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <limits>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>

#include "mg_memory.hpp"
#include "platform/arena.hpp"
#include "platform/arena_usage.hpp"
#include "platform/memory.hpp"
#include "platform_fixture.hpp"
#include "scenesnd.hpp"

namespace {

struct alignas(16) ArenaArrayProbe {
    static inline int constructed = 0;
    static inline int throw_at = 0;
    int               ordinal;
    int               payload[3];

    ArenaArrayProbe() : ordinal(++constructed), payload{11, 22, 33} {
        if (ordinal == throw_at) {
            throw std::runtime_error("array construction probe");
        }
    }
};

static_assert(std::is_trivially_destructible_v<ArenaArrayProbe>);

constexpr int         kQuadwords = 4096;
constexpr std::size_t kBytes = static_cast<std::size_t>(kQuadwords) * 16;
constexpr int         kHeader = static_cast<int>((sizeof(mgMEMORY_BLOCK) + 15) / 16);

std::uintptr_t AddressOf(const void *pointer) {
    return reinterpret_cast<std::uintptr_t>(pointer);
}

void NameArena(mgCMemory &memory, const char *name) {
    std::strncpy(memory.name, name, sizeof memory.name);
}

// Each buffer is a child view of an ArenaBlock, so the manager runs retail's arithmetic on it as-is.
class MgMemory : public testing::Test {
protected:
    void SetUp() override {
        static char key;
        buffer_ = reinterpret_cast<u_long128 *>(ArenaBlock(&key, kBytes));
        std::memset(buffer_, 0, kBytes);
    }

    bool Inside(const void *pointer, int quadwords) const {
        const std::uintptr_t start = AddressOf(buffer_);
        const std::uintptr_t at = AddressOf(pointer);
        return at >= start && at + static_cast<std::uintptr_t>(quadwords) * 16 <= start + kBytes;
    }

    u_long128 *buffer_ = nullptr;
};

} // namespace

TEST_F(MgMemory, StackAllocationStopsAtRetailCapacity) {
    mgCMemory memory;
    memory.stSetBuffer(buffer_, 40);
    NameArena(memory, "MgStack");

    // Retail refuses a request whose total would reach the capacity, so 39 of 40 quadwords are usable.
    for (int i = 0; i < 39; ++i) {
        ASSERT_NE(memory.Alloc(1), nullptr) << i;
    }

    EXPECT_EQ(memory.stGetUsed(), 39);
    EXPECT_EQ(memory.stGetRest(), 1);
    EXPECT_DEATH(memory.Alloc(1), "arena MgStack: allocation overflow, 40 of 40 quadwords");
    EXPECT_DEATH(memory.stAlloc(1), "arena MgStack: allocation overflow, 40 of 40 quadwords");
    EXPECT_EQ(memory.Alloc(0), nullptr);
    EXPECT_EQ(memory.Alloc(-1), nullptr);
    EXPECT_EQ(memory.stGetUsed(), 39);
}

TEST_F(MgMemory, StackAllocationsAreContiguousAndInside) {
    mgCMemory memory;
    memory.stSetBuffer(buffer_, 100);

    u_long128 *first = memory.Alloc(3);
    u_long128 *second = memory.stAlloc(5);

    EXPECT_EQ(first, buffer_);
    EXPECT_EQ(second, buffer_ + 3);
    EXPECT_EQ(memory.stGetTop(), buffer_ + 8);
    EXPECT_TRUE(Inside(first, 3));
    EXPECT_TRUE(Inside(second, 5));
}

TEST_F(MgMemory, CopiedStringsUseWholeQuadwordsAndKeepTheTerminator) {
    mgCMemory memory;
    memory.stSetBuffer(buffer_, 100);
    char short_text[] = "native";
    char exact_text[] = "123456789012345";

    EXPECT_EQ(mgCopyString(nullptr, &memory), nullptr);
    EXPECT_EQ(mgCopyString(short_text, nullptr), nullptr);
    char *first = mgCopyString(short_text, &memory);
    char *second = mgCopyString(exact_text, &memory);
    ASSERT_NE(first, nullptr);
    ASSERT_NE(second, nullptr);
    EXPECT_STREQ(first, short_text);
    EXPECT_STREQ(second, exact_text);
    EXPECT_EQ(second, reinterpret_cast<char *>(buffer_ + 1));
    EXPECT_EQ(memory.stGetUsed(), 2);
}

TEST_F(MgMemory, Stack64AlignmentAdvancesToTheBoundary) {
    mgCMemory parent;
    parent.stSetBuffer(buffer_, kQuadwords);
    auto *allocation = parent.Alloc(101);
    ASSERT_NE(allocation, nullptr);
    mgCMemory memory;
    memory.stSetChildBuffer(parent, allocation + 1, 100);

    memory.Align64();
    EXPECT_EQ(memory.stGetUsed(), 3);
    EXPECT_EQ(AddressOf(memory.stGetTop()) & 63, 0u);

    memory.Align64();
    EXPECT_EQ(memory.stGetUsed(), 3);

    u_long128 *aligned = memory.stAlloc64(2);
    EXPECT_EQ(aligned, buffer_ + 4);
    EXPECT_EQ(AddressOf(aligned) & 63, 0u);
    EXPECT_EQ(memory.stGetUsed(), 5);
}

TEST_F(MgMemory, Stack64AlignmentClampsAtTheEnd) {
    mgCMemory parent;
    parent.stSetBuffer(buffer_, kQuadwords);
    auto *allocation = parent.Alloc(3);
    ASSERT_NE(allocation, nullptr);
    mgCMemory memory;
    memory.stSetChildBuffer(parent, allocation + 1, 2);

    memory.stAlign64();
    EXPECT_EQ(memory.stGetUsed(), 2);
    EXPECT_EQ(memory.stGetRest(), 0);
}

TEST_F(MgMemory, StackLockRefusesAllocationAndAlignment) {
    mgCMemory parent;
    parent.stSetBuffer(buffer_, kQuadwords);
    auto *allocation = parent.Alloc(101);
    ASSERT_NE(allocation, nullptr);
    mgCMemory memory;
    memory.stSetChildBuffer(parent, allocation + 1, 100);
    memory.lock = 1;

    EXPECT_EQ(memory.Alloc(1), nullptr);
    EXPECT_EQ(memory.stAlloc64(1), nullptr);
    memory.stAlign64();
    EXPECT_EQ(memory.stGetUsed(), 0);

    memory.stReset();
    EXPECT_EQ(memory.lock, 0);
    EXPECT_NE(memory.Alloc(1), nullptr);
}

TEST_F(MgMemory, StackTestDoesNotClaim) {
    mgCMemory memory;
    memory.stSetBuffer(buffer_, 10);

    EXPECT_EQ(memory.stAllocTest(9), buffer_);
    EXPECT_EQ(memory.stAllocTest(10), nullptr);
    EXPECT_EQ(memory.stGetUsed(), 0);
}

TEST_F(MgMemory, StackPushPopAndReset) {
    mgCMemory memory;
    memory.stSetBuffer(buffer_, 100);

    memory.Alloc(10);
    const int  mark = memory.stGetUsed();
    u_long128 *scratch = memory.Alloc(20);
    EXPECT_EQ(scratch, buffer_ + 10);

    // Retail has no pop; the mark is restored through the public used count.
    memory.stack_used = mark;
    EXPECT_EQ(memory.Alloc(20), scratch);

    memory.stReset();
    EXPECT_EQ(memory.stGetUsed(), 0);
    EXPECT_EQ(memory.Alloc(1), buffer_);
}

TEST_F(MgMemory, StackAllocationsAreQuadwordAlignedAndInside) {
    mgCMemory parent;
    parent.stSetBuffer(buffer_, kQuadwords);
    auto *allocation = parent.Alloc(kQuadwords - 1);
    ASSERT_NE(allocation, nullptr);
    mgCMemory memory;
    memory.stSetChildBuffer(parent, allocation + 1, kQuadwords - 2);

    for (int size : {1, 2, 7, 16, 33}) {
        u_long128 *p = memory.Alloc(size);
        ASSERT_NE(p, nullptr);
        EXPECT_EQ(AddressOf(p) & 15, 0u);
        EXPECT_TRUE(Inside(p, size));

        u_long128 *aligned = memory.stAlloc64(size);
        ASSERT_NE(aligned, nullptr);
        EXPECT_EQ(AddressOf(aligned) & 63, 0u);
        EXPECT_TRUE(Inside(aligned, size));
    }
}

TEST_F(MgMemory, HeapFirstGapHoldsTheStackRegion) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, kQuadwords);

    u_long128 *region = memory.StartStackMode(1, 0);
    ASSERT_NE(region, nullptr);
    EXPECT_EQ(region, buffer_ + 2 * kHeader);
    EXPECT_EQ(memory.stGetSize(), kQuadwords - 3 * kHeader);
    EXPECT_TRUE(Inside(region, memory.stGetSize()));
    EXPECT_EQ(memory.stGetUsed(), 0);
}

TEST_F(MgMemory, HeapFreeMakesTheGapReusable) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, kQuadwords);

    u_long128 *first = memory.StartStackMode(1, 0);
    ASSERT_NE(first, nullptr);
    ASSERT_NE(memory.Alloc(4), nullptr);
    memory.EndStackMode();

    u_long128 *second = memory.StartStackMode(1, 0);
    ASSERT_NE(second, nullptr);
    EXPECT_EQ(second, buffer_ + 10);
    memory.EndStackMode();

    memory.Free(first);
    EXPECT_EQ(memory.StartStackMode(1, 0), first);
}

TEST_F(MgMemory, HeapFitModeNeedsMoreThanTheRequest) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, kQuadwords);

    EXPECT_EQ(memory.StartStackMode(3, kQuadwords - 3 * kHeader), nullptr);
    EXPECT_EQ(memory.StartStackMode(3, kQuadwords - 3 * kHeader - 1), buffer_ + 2 * kHeader);
    EXPECT_EQ(memory.stGetSize(), kQuadwords - 3 * kHeader);
}

TEST_F(MgMemory, HeapLargestModeAndUnknownModes) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, kQuadwords);

    EXPECT_EQ(memory.StartStackMode(0, 0), nullptr);
    EXPECT_EQ(memory.StartStackMode(2, 0), buffer_ + 2 * kHeader);
}

TEST_F(MgMemory, HeapLargestModeSizesTheStackFromTheChosenGap) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, kQuadwords);

    // Block a leaves a 1002-quadword gap at the front; block b fills the tail, so the last gap examined is
    // one quadword. Mode 2 must size the region from the front gap it chooses.
    u_long128 *a = memory.StartStackMode(1, 0);
    ASSERT_NE(a, nullptr);
    ASSERT_NE(memory.Alloc(1000), nullptr);
    memory.EndStackMode();

    u_long128 *b = memory.StartStackMode(1, 0);
    ASSERT_NE(b, nullptr);
    ASSERT_NE(memory.Alloc(memory.stGetSize() - 1), nullptr);
    memory.EndStackMode();

    memory.Free(a);
    EXPECT_EQ(memory.StartStackMode(2, 0), buffer_ + 2 * kHeader);
    EXPECT_EQ(memory.stGetSize(), 1002 - kHeader);
    EXPECT_TRUE(Inside(buffer_ + 2 * kHeader, memory.stGetSize()));
}

TEST_F(MgMemory, HeapStackModeRefusesPastItsRegion) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, kQuadwords);
    NameArena(memory, "MgHeap");

    ASSERT_NE(memory.StartStackMode(1, 0), nullptr);
    ASSERT_NE(memory.Alloc(memory.stGetSize() - 1), nullptr);
    const std::string size = std::to_string(memory.stGetSize());
    EXPECT_DEATH(memory.Alloc(1), "arena MgHeap: allocation overflow, " + size + " of " + size + " quadwords");
    EXPECT_EQ(memory.stGetUsed(), memory.stGetSize() - 1);
}

TEST_F(MgMemory, HeapReturnsNullWhenNoGapFits) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, kQuadwords);

    ASSERT_NE(memory.StartStackMode(1, 0), nullptr);
    ASSERT_NE(memory.Alloc(memory.stGetSize() - 1), nullptr);
    memory.EndStackMode();

    // One quadword is left between the stack block and the terminating header.
    EXPECT_EQ(memory.StartStackMode(1, 0), nullptr);
    EXPECT_EQ(memory.StartStackMode(2, 0), nullptr);
    EXPECT_EQ(memory.StartStackMode(3, 0), nullptr);
}

TEST_F(MgMemory, HeapClearRestoresAnEmptyHeap) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, kQuadwords);

    ASSERT_NE(memory.StartStackMode(1, 0), nullptr);
    memory.EndStackMode();

    memory.ClearHeapMem();
    EXPECT_EQ(memory.StartStackMode(1, 0), buffer_ + 2 * kHeader);
    EXPECT_EQ(memory.stGetSize(), kQuadwords - 3 * kHeader);
}

TEST_F(MgMemory, HeapRefusesBuffersTooSmallOrNull) {
    mgCMemory memory;
    memory.SetHeapMem(nullptr, kQuadwords);
    EXPECT_EQ(memory.StartStackMode(1, 0), nullptr);

    memory.SetHeapMem(buffer_, 15);
    EXPECT_EQ(memory.StartStackMode(1, 0), nullptr);

    memory.SetHeapMem(buffer_, -1);
    EXPECT_EQ(memory.heap_top, nullptr);
    EXPECT_EQ(memory.StartStackMode(1, 0), nullptr);
}

TEST_F(MgMemory, HeapPointersAreAlignedInsideAndOrdered) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, kQuadwords);

    u_long128 *previous_end = nullptr;
    for (int size : {3, 5, 7, 9}) {
        u_long128 *region = memory.StartStackMode(1, 0);
        ASSERT_NE(region, nullptr);
        EXPECT_EQ(AddressOf(region) & 15, 0u);
        EXPECT_TRUE(Inside(region, memory.stGetSize()));
        if (previous_end != nullptr) {
            EXPECT_GT(region, previous_end);
        }

        ASSERT_NE(memory.Alloc(size), nullptr);
        EXPECT_TRUE(Inside(region, size));
        previous_end = region + size;
        memory.EndStackMode();
    }
}

TEST_F(MgMemory, HeapStoresPointersThatRoundTrip) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, kQuadwords);

    u_long128 *region = memory.StartStackMode(1, 0);
    ASSERT_NE(region, nullptr);
    memory.EndStackMode();

    // Free finds the block by the data pointer its header stores, so a truncated header pointer fails here.
#ifndef NDEBUG
    EXPECT_TRUE(IsAbove4GiB(region));
#endif

    memory.Free(region);
    EXPECT_EQ(memory.StartStackMode(1, 0), region);
}

TEST_F(MgMemory, HeapFreeOfAnUnknownPointerAborts) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, kQuadwords);
    ASSERT_NE(memory.StartStackMode(1, 0), nullptr);
    memory.EndStackMode();

    KZ_ASSERT_ABORT([&] { memory.Free(buffer_ + 3); });
}

TEST_F(MgMemory, UsageTracksTheStackHighWaterMark) {
    mgCMemory memory;
    memory.stSetBuffer(buffer_, 100);

    ASSERT_NE(memory.Alloc(10), nullptr);
    ASSERT_NE(memory.Alloc(20), nullptr);
    memory.stReset();
    ASSERT_NE(memory.Alloc(5), nullptr);

    const mgMemoryUsage usage = MemoryUsage(memory);
    EXPECT_EQ(usage.capacity, 100);
    EXPECT_EQ(usage.peak, 30);

    MemoryForget(memory);
}

TEST_F(MgMemory, UsageResetsWhenTheBufferIsSetAgain) {
    mgCMemory memory;
    memory.stSetBuffer(buffer_, 100);
    ASSERT_NE(memory.Alloc(40), nullptr);

    memory.stSetBuffer(buffer_, 64);
    const mgMemoryUsage reset = MemoryUsage(memory);
    EXPECT_EQ(reset.capacity, 64);
    EXPECT_EQ(reset.peak, 0);

    ASSERT_NE(memory.Alloc(3), nullptr);
    EXPECT_EQ(MemoryUsage(memory).peak, 3);

    MemoryForget(memory);
}

TEST_F(MgMemory, UsageTracksTheHeapHighWaterMark) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, kQuadwords);

    ASSERT_NE(memory.StartStackMode(1, 0), nullptr);
    ASSERT_NE(memory.Alloc(10), nullptr);
    memory.EndStackMode();

    u_long128 *second = memory.StartStackMode(1, 0);
    ASSERT_NE(second, nullptr);
    ASSERT_NE(memory.Alloc(20), nullptr);
    memory.EndStackMode();

    // Two allocated blocks of 10 and 20 quadwords, each with a two-quadword header.
    const int two_blocks = 2 * kHeader + 30;
    EXPECT_EQ(MemoryUsage(memory).peak, two_blocks);

    memory.Free(buffer_ + 2 * kHeader);
    const mgMemoryUsage after_free = MemoryUsage(memory);
    EXPECT_EQ(after_free.capacity, kQuadwords);
    EXPECT_EQ(after_free.peak, two_blocks);

    MemoryForget(memory);
}

TEST_F(MgMemory, ExplicitChildLeaseRejectsParentResetAndSameAddressReuse) {
    mgCMemory parent;
    parent.stSetBuffer(buffer_, 128);
    auto *allocation = parent.Alloc(16);
    ASSERT_NE(parent.Alloc(1), nullptr);
    mgCMemory child;
    child.stSetChildBuffer(parent, allocation, 16);
    ASSERT_NE(child.Alloc(1), nullptr);
    parent.stReset();
    EXPECT_FALSE(dc2::memory::ArenaStorageLive(child));
    EXPECT_TRUE(dc2::memory::RemainingBytes(child).empty());
    EXPECT_EQ(child.stGetTop(), nullptr);
    EXPECT_EQ(child.Alloc(1), nullptr);
    EXPECT_EQ(child.stAllocTest(1), nullptr);
    auto *replacement = parent.Alloc(16);
    ASSERT_EQ(replacement, allocation);
    EXPECT_EQ(child.Alloc(1), nullptr);
    child.stSetChildBuffer(parent, replacement, 16);
    EXPECT_NE(child.Alloc(1), nullptr);
    ASSERT_NE(parent.Alloc(1), nullptr);
    EXPECT_DEATH(child.stSetBuffer(replacement, 17), "exceeds current root");
    parent.stSetBuffer(buffer_, 128);
    EXPECT_EQ(child.Alloc(1), nullptr);
}

TEST_F(MgMemory, DestroyedAndRecreatedParentCannotResurrectChildLease) {
    std::optional<mgCMemory> parent;
    parent.emplace();
    parent->stSetBuffer(buffer_, 128);
    auto     *allocation = parent->Alloc(16);
    mgCMemory child;
    child.stSetChildBuffer(*parent, allocation, 16);
    parent.reset();
    EXPECT_EQ(child.Alloc(1), nullptr);
    parent.emplace();
    parent->stSetBuffer(buffer_, 128);
    auto *replacement = parent->Alloc(16);
    ASSERT_EQ(replacement, allocation);
    EXPECT_EQ(child.Alloc(1), nullptr);
    child.stSetChildBuffer(*parent, replacement, 16);
    EXPECT_NE(child.Alloc(1), nullptr);
}

TEST_F(MgMemory, ClosedHeapBlocksKeepIndependentChildLeasesUntilTheirOwnFree) {
    mgCMemory parent;
    parent.SetHeapMem(buffer_, 128);
    ASSERT_NE(parent.StartStackMode(MG_STACK_MODE_FIT, 16), nullptr);
    auto *first = parent.Alloc(16);
    parent.EndStackMode();
    mgCMemory first_child;
    first_child.stSetChildBuffer(parent, first, 16);
    ASSERT_NE(first_child.Alloc(1), nullptr);

    ASSERT_NE(parent.StartStackMode(MG_STACK_MODE_FIT, 16), nullptr);
    auto *second = parent.Alloc(16);
    parent.EndStackMode();
    mgCMemory second_child;
    second_child.stSetChildBuffer(parent, second, 16);
    parent.Free(second);
    EXPECT_NE(first_child.Alloc(1), nullptr);
    EXPECT_EQ(second_child.Alloc(1), nullptr);
    parent.Free(first);
    EXPECT_EQ(first_child.Alloc(1), nullptr);
}

TEST_F(MgMemory, RootGrowthInvalidatesOldBindingsAndRejectsRetiredStorage) {
    static char key;
    auto       *root = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 64 * sizeof(u_long128)));
    mgCMemory   memory;
    memory.stSetBuffer(root, 64);
    const auto region = kz::arena::RegionFor(root);
    ASSERT_TRUE(region);
    auto *replacement = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 128 * sizeof(u_long128)));
    ASSERT_NE(replacement, root);
    EXPECT_FALSE(kz::arena::IsLive(*region));
    EXPECT_FALSE(kz::arena::RegionFor(root));
    EXPECT_TRUE(ArenaContains(root));
    EXPECT_EQ(memory.Alloc(1), nullptr);
    EXPECT_DEATH(memory.stSetBuffer(root, 64), "no live source allocation");
    memory.stSetBuffer(replacement, 128);
    EXPECT_NE(memory.Alloc(1), nullptr);
}

TEST_F(MgMemory, AllocationProbeRejectsNonpositiveCounts) {
    mgCMemory memory;
    memory.stSetBuffer(buffer_, 16);
    EXPECT_EQ(memory.stAllocTest(-1), nullptr);
    EXPECT_EQ(memory.stAllocTest(0), nullptr);
    EXPECT_EQ(memory.stGetUsed(), 0);
}

TEST_F(MgMemory, ExplicitBorrowedViewTracksItsLogicalOwnerWithoutReservingIt) {
    mgCMemory parent;
    parent.stSetBuffer(buffer_, 128);
    mgCMemory first;
    mgCMemory second;
    first.stSetBorrowedBuffer(parent, std::span(buffer_ + 32, 16));
    second.stSetBorrowedBuffer(parent, std::span(buffer_ + 32, 16));
    EXPECT_EQ(parent.stGetUsed(), 0);
    EXPECT_NE(first.Alloc(1), nullptr);
    EXPECT_NE(second.Alloc(1), nullptr);
    EXPECT_DEATH(first.stSetBorrowedBuffer(parent, std::span(buffer_ + 127, 2)), "no live source allocation");
    parent.stReset();
    EXPECT_EQ(first.Alloc(1), nullptr);
    EXPECT_EQ(second.Alloc(1), nullptr);
}

TEST_F(MgMemory, RootExtentQueryExcludesTheGuardAndUnrequestedPadding) {
    static char key;
    auto       *root = ArenaBlock(&key, 17);
    const auto  region = kz::arena::RegionFor(root);
    ASSERT_TRUE(region);
    EXPECT_EQ(region->writable.size(), 17);
    EXPECT_TRUE(kz::arena::RegionFor(root + 16));
    EXPECT_FALSE(kz::arena::RegionFor(root + 17));
    EXPECT_FALSE(kz::arena::RegionFor(root + 63));
    EXPECT_FALSE(kz::arena::RegionFor(root - 1));
}

TEST_F(MgMemory, FreeingActiveHeapBlockRevokesEverySuballocationAndStopsFurtherWrites) {
    mgCMemory parent;
    parent.SetHeapMem(buffer_, 128);
    ASSERT_NE(parent.StartStackMode(MG_STACK_MODE_FIT, 16), nullptr);
    auto     *block = parent.Alloc(4);
    auto     *later = parent.Alloc(4);
    mgCMemory child;
    child.stSetChildBuffer(parent, later, 4);
    parent.Free(block);
    EXPECT_EQ(child.Alloc(1), nullptr);
    EXPECT_EQ(parent.Alloc(1), nullptr);
    EXPECT_EQ(parent.stGetTop(), nullptr);
    parent.EndStackMode();
}

TEST_F(MgMemory, ActiveHeapResetRevokesItsChildrenAndPreservesOtherBlocks) {
    mgCMemory parent;
    parent.SetHeapMem(buffer_, 128);
    ASSERT_NE(parent.StartStackMode(MG_STACK_MODE_FIT, 16), nullptr);
    auto *first = parent.Alloc(8);
    parent.EndStackMode();
    mgCMemory first_child;
    first_child.stSetChildBuffer(parent, first, 8);
    ASSERT_NE(parent.StartStackMode(MG_STACK_MODE_FIT, 16), nullptr);
    auto     *second = parent.Alloc(8);
    mgCMemory second_child;
    second_child.stSetChildBuffer(parent, second, 8);
    parent.stReset();
    EXPECT_NE(first_child.Alloc(1), nullptr);
    EXPECT_EQ(second_child.Alloc(1), nullptr);
    auto *replacement = parent.Alloc(8);
    ASSERT_EQ(replacement, second);
    EXPECT_EQ(second_child.Alloc(1), nullptr);
    second_child.stSetChildBuffer(parent, replacement, 8);
    parent.EndStackMode();
    EXPECT_NE(first_child.Alloc(1), nullptr);
    EXPECT_NE(second_child.Alloc(1), nullptr);
}

TEST_F(MgMemory, ArenaBufferTracksLogicalResetAndExactAllocationIdentity) {
    mgCMemory parent;
    parent.stSetBuffer(buffer_, 128);
    auto     *owner_storage = parent.Alloc(32);
    mgCMemory owner;
    owner.stSetChildBuffer(parent, owner_storage, 32);
    auto *allocation = owner.Alloc(8);
    auto  bytes = std::span(reinterpret_cast<u8 *>(allocation), 8 * sizeof(u_long128));
    auto  direct = dc2::memory::ArenaBuffer::Bind(owner, bytes);
    auto  backed = dc2::memory::ArenaBuffer::Bind(owner, bytes, &parent);
    EXPECT_EQ(direct.Bytes().size(), bytes.size());
    EXPECT_EQ(backed.Bytes().size(), bytes.size());
    EXPECT_TRUE(dc2::memory::ArenaBuffer::Bind(parent, std::span(reinterpret_cast<u8 *>(buffer_ + 120), 16)).Bytes().empty());
    owner.stReset();
    EXPECT_TRUE(direct.Bytes().empty());
    EXPECT_TRUE(backed.Bytes().empty());
    ASSERT_EQ(owner.Alloc(8), allocation);
    EXPECT_TRUE(direct.Bytes().empty());
    EXPECT_TRUE(backed.Bytes().empty());
    auto replacement = dc2::memory::ArenaBuffer::Bind(owner, bytes, &parent);
    EXPECT_FALSE(replacement.Bytes().empty());
    parent.stReset();
    EXPECT_TRUE(replacement.Bytes().empty());
}

TEST_F(MgMemory, ArenaBufferSubspansPreserveTheOriginalLeaseIdentity) {
    mgCMemory memory;
    memory.stSetBuffer(buffer_, 64);
    auto *allocation = memory.Alloc(16);
    auto  whole = dc2::memory::ArenaBuffer::Bind(memory, std::span(reinterpret_cast<u8 *>(allocation), 16 * sizeof(u_long128)));
    auto  first = whole.Subspan(0, 8 * sizeof(u_long128));
    auto  second = whole.Subspan(8 * sizeof(u_long128), 8 * sizeof(u_long128));
    ASSERT_EQ(first.Bytes().size(), 8 * sizeof(u_long128));
    ASSERT_EQ(second.Bytes().data(), reinterpret_cast<u8 *>(allocation + 8));
    EXPECT_TRUE(whole.SameIdentity(dc2::memory::ArenaBuffer::Bind(memory, std::span(reinterpret_cast<u8 *>(allocation), 16 * sizeof(u_long128)))));
    EXPECT_FALSE(whole.SameIdentity(first));
    EXPECT_TRUE(whole.Subspan(16 * sizeof(u_long128), 1).Bytes().empty());
    EXPECT_TRUE(whole.Subspan(std::numeric_limits<std::size_t>::max(), 1).Bytes().empty());
    memory.stReset();
    ASSERT_EQ(memory.Alloc(16), allocation);
    const auto replacement = dc2::memory::ArenaBuffer::Bind(memory, std::span(reinterpret_cast<u8 *>(allocation), 16 * sizeof(u_long128)));
    EXPECT_FALSE(whole.SameIdentity(replacement));
    EXPECT_TRUE(first.Bytes().empty());
    EXPECT_TRUE(second.Bytes().empty());
    EXPECT_TRUE(whole.Subspan(0, 1).Bytes().empty());
}

TEST_F(MgMemory, EmbeddedSceneSoundScratchHasAnIndependentRootAndOwnerLifetime) {
    static char key;
    auto       *storage = ArenaBlock(&key, sizeof(CScene));
    static_assert(alignof(CScene) <= 64);
    auto *scene = std::construct_at(reinterpret_cast<CScene *>(storage));
    scene->InitLooSeMngr();
    EXPECT_NE(scene->loop_se_stack.stack, scene->loop_se_buff);
    EXPECT_EQ(scene->loop_se_stack.stGetSize(), static_cast<int>(std::size(scene->loop_se_buff)) * kArenaHeadroom);
    auto *allocation = scene->loop_se_stack.Alloc(1);
    ASSERT_NE(allocation, nullptr);
    const auto view = dc2::memory::ArenaBuffer::Bind(scene->loop_se_stack,
                                                     std::span(reinterpret_cast<u8 *>(allocation), sizeof(u_long128)));
    EXPECT_FALSE(view.Bytes().empty());
    std::destroy_at(scene);
    EXPECT_TRUE(view.Bytes().empty());
}

TEST_F(MgMemory, StandaloneRebindingDetachesAnActiveHeapAndItsLeases) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, 128);
    ASSERT_NE(memory.StartStackMode(MG_STACK_MODE_FIT, 16), nullptr);
    auto     *allocation = memory.Alloc(8);
    mgCMemory child;
    child.stSetChildBuffer(memory, allocation, 8);
    memory.stSetBuffer(buffer_, 128);
    EXPECT_EQ(memory.heap, nullptr);
    EXPECT_EQ(memory.heap_top, nullptr);
    EXPECT_EQ(memory.stack_block, nullptr);
    EXPECT_EQ(child.Alloc(1), nullptr);
    memory.EndStackMode();
    EXPECT_EQ(memory.stGetTop(), buffer_);
    EXPECT_EQ(memory.Alloc(1), buffer_);
    memory.Free(allocation);
}

TEST_F(MgMemory, IdleHeapStackResetPreservesClosedBlocksAndAllocationLockGatesNewBlocks) {
    mgCMemory memory;
    memory.SetHeapMem(buffer_, 128);
    memory.stSetLocked(true);
    EXPECT_EQ(memory.StartStackMode(MG_STACK_MODE_FIT, 16), nullptr);
    memory.stSetLocked(false);
    ASSERT_NE(memory.StartStackMode(MG_STACK_MODE_FIT, 16), nullptr);
    auto *allocation = memory.Alloc(8);
    memory.EndStackMode();
    mgCMemory child;
    child.stSetChildBuffer(memory, allocation, 8);
    memory.stReset();
    EXPECT_NE(child.Alloc(1), nullptr);
    memory.ClearHeapMem();
    EXPECT_EQ(child.Alloc(1), nullptr);
}

TEST_F(MgMemory, SharedTemporaryViewsRetainTheRealOwnerAndTheirCursor) {
    mgCMemory parent;
    parent.stSetBuffer(buffer_, 128);
    auto     *storage = parent.Alloc(32);
    mgCMemory shared;
    {
        mgCMemory temporary;
        temporary.stSetBorrowedBuffer(parent, std::span(storage, 32));
        ASSERT_NE(temporary.Alloc(7), nullptr);
        ASSERT_TRUE(shared.stShareStack(temporary));
        EXPECT_EQ(shared.stGetTop(), storage + 7);
    }
    EXPECT_EQ(shared.stGetTop(), storage + 7);
    EXPECT_EQ(shared.Alloc(1), storage + 7);
    parent.stReset();
    EXPECT_EQ(shared.stGetTop(), nullptr);
}

TEST_F(MgMemory, SharingAGenuineChildOwnerPreservesItsOwnLifetime) {
    mgCMemory parent;
    parent.stSetBuffer(buffer_, 128);
    auto     *storage = parent.Alloc(32);
    mgCMemory shared;
    {
        mgCMemory owner;
        owner.stSetChildBuffer(parent, storage, 32);
        ASSERT_TRUE(shared.stShareBuffer(owner, std::span(storage + 4, 8)));
        EXPECT_EQ(shared.stGetTop(), storage + 4);
        EXPECT_FALSE(shared.stShareBuffer(owner, std::span(storage + 30, 4)));
    }
    EXPECT_EQ(shared.stGetTop(), nullptr);
    EXPECT_TRUE(dc2::memory::ArenaStorageLive(parent));
}

TEST_F(MgMemory, DirectChildBindingCannotCreateAnOwnerCycle) {
    mgCMemory parent;
    parent.stSetBuffer(buffer_, 128);
    auto     *storage = parent.Alloc(32);
    mgCMemory child;
    child.stSetChildBuffer(parent, storage, 32);
    auto *allocation = child.Alloc(4);
    EXPECT_DEATH(parent.stSetChildBuffer(child, allocation, 4), "no live source allocation");
    EXPECT_EQ(parent.stGetTop(), buffer_ + 32);
    EXPECT_NE(child.Alloc(1), nullptr);
}

TEST_F(MgMemory, SameMappingExtentGrowthInvalidatesOldLeasesButSmallerRequestsPreserveThem) {
    static char key;
    static char other_key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 33));
    auto       *other_storage = reinterpret_cast<u_long128 *>(ArenaBlock(&other_key, 64));
    mgCMemory   parent;
    mgCMemory   other;
    parent.stSetBuffer(storage, 2);
    other.stSetBuffer(other_storage, 4);
    auto      *allocated = parent.Alloc(1);
    const auto before = kz::arena::RegionFor(storage);
    ASSERT_TRUE(before);
    const auto old = dc2::memory::ArenaBuffer::Bind(parent, std::span(reinterpret_cast<u8 *>(allocated), 16));
    const auto unrelated = dc2::memory::ArenaBuffer::Bind(other, std::span(reinterpret_cast<u8 *>(other.Alloc(1)), 16));
    ASSERT_FALSE(old.Bytes().empty());
    ASSERT_FALSE(unrelated.Bytes().empty());
    EXPECT_EQ(ArenaBlock(&key, 49), reinterpret_cast<unsigned char *>(storage));
    EXPECT_FALSE(kz::arena::IsLive(*before));
    EXPECT_TRUE(old.Bytes().empty());
    EXPECT_EQ(parent.stGetTop(), nullptr);
    EXPECT_FALSE(unrelated.Bytes().empty());
    parent.stSetBuffer(storage, 3);
    auto      *replacement = parent.Alloc(1);
    const auto live = dc2::memory::ArenaBuffer::Bind(parent, std::span(reinterpret_cast<u8 *>(replacement), 16));
    const auto current = kz::arena::RegionFor(storage);
    ASSERT_TRUE(current);
    EXPECT_EQ(current->writable.size(), 49);
    EXPECT_EQ(ArenaBlock(&key, 8), reinterpret_cast<unsigned char *>(storage));
    EXPECT_TRUE(kz::arena::IsLive(*current));
    EXPECT_FALSE(live.Bytes().empty());
    EXPECT_FALSE(unrelated.Bytes().empty());
}

TEST_F(MgMemory, SharedWorkspacesUnlockTheirCursorWhileStackSnapshotsPreserveTheSourceLock) {
    mgCMemory parent;
    parent.stSetBuffer(buffer_, 128);
    auto *storage = parent.Alloc(32);
    parent.stSetLocked(true);
    mgCMemory workspace;
    workspace.stSetLocked(true);
    ASSERT_TRUE(workspace.stShareBuffer(parent, std::span(storage, 32)));
    EXPECT_EQ(workspace.stack_used, 0);
    EXPECT_EQ(workspace.lock, 0);
    EXPECT_NE(workspace.Alloc(1), nullptr);
    EXPECT_NE(parent.lock, 0);
    mgCMemory snapshot;
    ASSERT_TRUE(snapshot.stShareStack(parent));
    EXPECT_EQ(snapshot.stack_used, parent.stack_used);
    EXPECT_NE(snapshot.lock, 0);
    EXPECT_EQ(snapshot.Alloc(1), nullptr);
    parent.stReset();
    EXPECT_EQ(workspace.stGetTop(), nullptr);
    EXPECT_EQ(snapshot.stGetTop(), nullptr);
    mgCMemory rejected;
    EXPECT_FALSE(rejected.stShareBuffer(workspace, std::span(storage, 32)));
    EXPECT_EQ(rejected.stGetTop(), nullptr);
}

TEST_F(MgMemory, RootExtentIncludesOnlyTheRequestedLeadAndPayload) {
    static char key;
    auto       *root = ArenaBlock(&key, 17, 3);
    const auto  region = kz::arena::RegionFor(root);
    ASSERT_TRUE(region);
    EXPECT_EQ(region->writable.data(), root - 3);
    EXPECT_EQ(region->writable.size(), 20);
    EXPECT_TRUE(kz::arena::RegionFor(root - 3));
    EXPECT_FALSE(kz::arena::RegionFor(root - 4));
    EXPECT_TRUE(kz::arena::RegionFor(root + 16));
    EXPECT_FALSE(kz::arena::RegionFor(root + 17));
    EXPECT_TRUE(kz::arena::IsLive(*region));
    static char lead_key;
    auto       *lead_only = ArenaBlock(&lead_key, 0, 16);
    const auto  lead = kz::arena::RegionFor(lead_only - 1);
    ASSERT_TRUE(lead);
    EXPECT_EQ(lead->writable.size(), 16);
    EXPECT_FALSE(kz::arena::RegionFor(lead_only));
    EXPECT_TRUE(kz::arena::IsLive(*lead));
}

TEST_F(MgMemory, HeapHeadersStartTheirTypedLifetimeWithInitializedFields) {
    std::memset(buffer_, 0xA5, 128 * sizeof(u_long128));
    mgCMemory memory;
    memory.SetHeapMem(buffer_, 128);
    ASSERT_NE(memory.heap_top, nullptr);
    EXPECT_EQ(memory.heap_top->unk_8, 0);
    ASSERT_NE(memory.heap_top->next, nullptr);
    EXPECT_EQ(memory.heap_top->next->unk_8, 0);
    EXPECT_NE(memory.StartStackMode(MG_STACK_MODE_FIRST, 0), nullptr);
    ASSERT_NE(memory.stack_block, nullptr);
    EXPECT_EQ(memory.stack_block->unk_8, 0);
}

TEST_F(MgMemory, StringCopyRejectsTheStrictEndAndLockedOrRetiredStorageBeforeAllocating) {
    static char key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 8 * sizeof(u_long128)));
    mgCMemory   parent;
    parent.stSetBuffer(storage, 8);
    mgCMemory memory;
    ASSERT_TRUE(memory.stShareBuffer(parent, std::span(storage, 2)));
    std::memset(storage, 0xA5, 8 * sizeof(u_long128));
    char exact[] = "0123456789abcdef";
    EXPECT_EQ(mgCopyString(exact, &memory), nullptr);
    EXPECT_EQ(memory.stack_used, 0);
    char short_text[] = "x";
    memory.stSetLocked(true);
    EXPECT_EQ(mgCopyString(short_text, &memory), nullptr);
    EXPECT_EQ(memory.stack_used, 0);
    const auto *bytes = reinterpret_cast<const unsigned char *>(storage);
    for (std::size_t index = 0; index < 8 * sizeof(u_long128); ++index) {
        ASSERT_EQ(bytes[index], 0xA5) << index;
    }
    memory.stSetLocked(false);
    auto *parent_allocation = parent.Alloc(4);
    ASSERT_NE(parent_allocation, nullptr);
    mgCMemory child;
    child.stSetChildBuffer(parent, parent_allocation, 4);
    parent.stClearUsed();
    EXPECT_EQ(mgCopyString(short_text, &child), nullptr);
    EXPECT_EQ(child.stack_used, 0);
}

TEST_F(MgMemory, StringCopyPreservesOverlappingInputAlreadyWrittenAtTheArenaCursor) {
    static char key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 8 * sizeof(u_long128)));
    mgCMemory   memory;
    memory.stSetBuffer(storage, 8);
    auto *bytes = reinterpret_cast<char *>(storage);
    std::memcpy(bytes + 2, "overlapping", sizeof("overlapping"));
    auto *copy = mgCopyString(bytes + 2, &memory);
    ASSERT_EQ(copy, bytes);
    EXPECT_STREQ(copy, "overlapping");
    EXPECT_EQ(memory.stack_used, 1);
}

TEST_F(MgMemory, TypedArrayConstructionHasNoCookieAndPreservesAdjacentStorage) {
    std::memset(buffer_, 0xA5, 128);
    mgCMemory memory;
    memory.stSetBuffer(buffer_, kQuadwords);
    ASSERT_NE(memory.Alloc(1), nullptr);
    ArenaArrayProbe::constructed = 0;
    ArenaArrayProbe::throw_at = 0;
    auto *objects = dc2::memory::NewArray<ArenaArrayProbe>(memory, 3);
    ASSERT_EQ(static_cast<void *>(objects), static_cast<void *>(buffer_ + 1));
    EXPECT_EQ(memory.stack_used, 4);
    EXPECT_EQ(ArenaArrayProbe::constructed, 3);
    for (std::size_t index = 0; index < 3; ++index) {
        EXPECT_EQ(objects[index].ordinal, static_cast<int>(index) + 1);
        EXPECT_EQ(objects[index].payload[2], 33);
    }
    auto bytes = std::as_bytes(std::span(buffer_, 8));
    for (std::size_t index = 0; index < 16; ++index) {
        EXPECT_EQ(bytes[index], std::byte{0xA5});
        EXPECT_EQ(bytes[64 + index], std::byte{0xA5});
    }
    auto *characters = dc2::memory::NewArray<char>(memory, 17);
    ASSERT_EQ(static_cast<void *>(characters), static_cast<void *>(buffer_ + 4));
    const auto representation = std::as_bytes(std::span(characters, 17));
    for (const auto byte : representation) {
        EXPECT_EQ(byte, std::byte{0xA5});
    }
}

TEST_F(MgMemory, ThrowingArrayConstructionConsumesOnlyItsReservedExtent) {
    std::memset(buffer_, 0xA5, 128);
    mgCMemory memory;
    memory.stSetBuffer(buffer_, kQuadwords);
    ASSERT_NE(memory.Alloc(1), nullptr);
    ArenaArrayProbe::constructed = 0;
    ArenaArrayProbe::throw_at = 3;
    EXPECT_THROW(dc2::memory::NewArray<ArenaArrayProbe>(memory, 4), std::runtime_error);
    EXPECT_EQ(ArenaArrayProbe::constructed, 3);
    EXPECT_EQ(memory.stack_used, 5);
    const auto bytes = std::as_bytes(std::span(buffer_, 8));
    for (std::size_t index = 0; index < 16; ++index) {
        EXPECT_EQ(bytes[index], std::byte{0xA5});
        EXPECT_EQ(bytes[80 + index], std::byte{0xA5});
    }
    ArenaArrayProbe::throw_at = 0;
}

TEST_F(MgMemory, TypedArraysRejectLockedAndStrictEndViewsBeforeConstruction) {
    mgCMemory parent;
    parent.stSetBuffer(buffer_, kQuadwords);
    mgCMemory view;
    ASSERT_TRUE(view.stShareBuffer(parent, std::span(buffer_, 2)));
    ArenaArrayProbe::constructed = 0;
    ArenaArrayProbe::throw_at = 0;
    EXPECT_EQ(dc2::memory::NewArray<ArenaArrayProbe>(view, 2), nullptr);
    view.stSetLocked(true);
    EXPECT_EQ(dc2::memory::NewArray<ArenaArrayProbe>(view, 1), nullptr);
    EXPECT_EQ(ArenaArrayProbe::constructed, 0);
    EXPECT_EQ(view.stack_used, 0);
    view.stSetLocked(false);
    ASSERT_NE(dc2::memory::NewArray<ArenaArrayProbe>(view, 1), nullptr);
    EXPECT_EQ(ArenaArrayProbe::constructed, 1);
    EXPECT_EQ(view.stack_used, 1);
}

TEST_F(MgMemory, ProducerLifetimesPredictParentAndChildResetWithoutMutatingEither) {
    mgCMemory parent;
    parent.stSetBuffer(buffer_, 128);
    const auto root_lifetime = dc2::memory::ArenaLifetime::Capture(parent);
    EXPECT_FALSE(dc2::memory::ArenaLifetime{}.HasValue());
    EXPECT_TRUE(root_lifetime.HasValue());
    ASSERT_TRUE(root_lifetime.IsLive());
    auto *storage = parent.Alloc(32);
    ASSERT_NE(storage, nullptr);
    mgCMemory child;
    child.stSetChildBuffer(parent, storage, 32);
    const auto child_lifetime = dc2::memory::ArenaLifetime::Capture(child);
    auto      *data = child.Alloc(4);
    ASSERT_NE(data, nullptr);
    const auto view = dc2::memory::ArenaBuffer::Bind(child,
                                                     std::span(reinterpret_cast<u8 *>(data), 4 * sizeof(u_long128)));
    ASSERT_FALSE(view.Bytes().empty());
    EXPECT_TRUE(root_lifetime.WouldRetireOnReset(parent));
    EXPECT_FALSE(root_lifetime.WouldRetireOnReset(child));
    EXPECT_TRUE(child_lifetime.WouldRetireOnReset(parent));
    EXPECT_TRUE(child_lifetime.WouldRetireOnReset(child));
    EXPECT_TRUE(view.WouldRetireOnReset(parent));
    EXPECT_TRUE(view.WouldRetireOnReset(child));
    EXPECT_EQ(parent.stGetUsed(), 32);
    EXPECT_EQ(child.stGetUsed(), 4);
    EXPECT_TRUE(root_lifetime.IsLive());
    EXPECT_TRUE(child_lifetime.IsLive());
    child.stReset();
    EXPECT_TRUE(root_lifetime.IsLive());
    EXPECT_FALSE(child_lifetime.IsLive());
    EXPECT_TRUE(view.Bytes().empty());
    parent.stReset();
    EXPECT_FALSE(root_lifetime.IsLive());
    EXPECT_TRUE(root_lifetime.HasValue());
}

TEST_F(MgMemory, ProducerLifetimesDistinguishActiveIdleAndUnrelatedHeapBlocks) {
    mgCMemory heap;
    heap.SetHeapMem(buffer_, 128);
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, 16), nullptr);
    const auto first_lifetime = dc2::memory::ArenaLifetime::Capture(heap);
    ASSERT_TRUE(first_lifetime.IsLive());
    auto *first = heap.Alloc(8);
    ASSERT_NE(first, nullptr);
    const auto first_view = dc2::memory::ArenaBuffer::Bind(heap,
                                                           std::span(reinterpret_cast<u8 *>(first), 8 * sizeof(u_long128)));
    heap.EndStackMode();
    EXPECT_TRUE(first_lifetime.IsLive());
    EXPECT_FALSE(first_lifetime.WouldRetireOnReset(heap));
    EXPECT_FALSE(first_view.WouldRetireOnReset(heap));
    EXPECT_TRUE(first_lifetime.WouldRetireOnReset(heap, dc2::memory::ArenaResetKind::Rebind));
    EXPECT_TRUE(first_view.WouldRetireOnReset(heap, dc2::memory::ArenaResetKind::Rebind));
    heap.stReset();
    EXPECT_TRUE(first_lifetime.IsLive());
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, 16), nullptr);
    const auto second_lifetime = dc2::memory::ArenaLifetime::Capture(heap);
    auto      *second = heap.Alloc(4);
    ASSERT_NE(second, nullptr);
    const auto second_view = dc2::memory::ArenaBuffer::Bind(heap,
                                                            std::span(reinterpret_cast<u8 *>(second), 4 * sizeof(u_long128)));
    ASSERT_TRUE(second_lifetime.IsLive());
    EXPECT_FALSE(first_lifetime.WouldRetireOnReset(heap));
    EXPECT_FALSE(first_view.WouldRetireOnReset(heap));
    EXPECT_TRUE(second_lifetime.WouldRetireOnReset(heap));
    EXPECT_TRUE(second_view.WouldRetireOnReset(heap));
    heap.stReset();
    EXPECT_TRUE(first_lifetime.IsLive());
    EXPECT_FALSE(second_lifetime.IsLive());
    EXPECT_FALSE(first_view.Bytes().empty());
    EXPECT_TRUE(second_view.Bytes().empty());
    heap.EndStackMode();
}

TEST_F(MgMemory, ProducerLifetimeRejectsFreedBlockIdentityAfterItsAddressIsReused) {
    mgCMemory heap;
    heap.SetHeapMem(buffer_, 128);
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, 32), nullptr);
    const auto original = dc2::memory::ArenaLifetime::Capture(heap);
    auto      *first = heap.Alloc(8);
    ASSERT_NE(first, nullptr);
    ASSERT_NE(heap.Alloc(1), nullptr);
    heap.EndStackMode();
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, 32), nullptr);
    const auto other = dc2::memory::ArenaLifetime::Capture(heap);
    ASSERT_NE(heap.Alloc(8), nullptr);
    heap.EndStackMode();
    heap.Free(first);
    EXPECT_FALSE(original.IsLive());
    EXPECT_TRUE(other.IsLive());
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIRST, 0), nullptr);
    const auto replacement = dc2::memory::ArenaLifetime::Capture(heap);
    EXPECT_EQ(heap.Alloc(4), first);
    EXPECT_TRUE(replacement.IsLive());
    EXPECT_FALSE(original.IsLive());
    EXPECT_TRUE(other.IsLive());
    heap.EndStackMode();
}

TEST_F(MgMemory, ProducerLifetimeRejectsDestroyedAndReconstructedControllers) {
    std::optional<mgCMemory> owner;
    owner.emplace();
    owner->stSetBuffer(buffer_, 128);
    const auto original = dc2::memory::ArenaLifetime::Capture(*owner);
    ASSERT_TRUE(original.IsLive());
    owner.reset();
    EXPECT_FALSE(original.IsLive());
    owner.emplace();
    owner->stSetBuffer(buffer_, 128);
    EXPECT_FALSE(original.IsLive());
    EXPECT_TRUE(dc2::memory::ArenaLifetime::Capture(*owner).IsLive());
}

TEST_F(MgMemory, ProducerLifetimesFollowTheExactActiveParentBlockOfSharedViews) {
    mgCMemory heap;
    heap.SetHeapMem(buffer_, 128);
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, 32), nullptr);
    auto *allocation = heap.Alloc(16);
    ASSERT_NE(allocation, nullptr);
    mgCMemory shared;
    shared.stSetBorrowedBuffer(heap, std::span(allocation, 16));
    const auto producer = dc2::memory::ArenaLifetime::Capture(shared);
    const auto view = dc2::memory::ArenaBuffer::Bind(shared,
                                                     std::span(reinterpret_cast<u8 *>(allocation), 16 * sizeof(u_long128)), &heap);
    ASSERT_TRUE(producer.IsLive());
    ASSERT_FALSE(view.Bytes().empty());
    EXPECT_TRUE(producer.WouldRetireOnReset(heap));
    EXPECT_TRUE(view.WouldRetireOnReset(heap));
    heap.EndStackMode();
    EXPECT_TRUE(producer.IsLive());
    EXPECT_FALSE(producer.WouldRetireOnReset(heap));
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, 32), nullptr);
    ASSERT_NE(heap.Alloc(8), nullptr);
    EXPECT_FALSE(producer.WouldRetireOnReset(heap));
    EXPECT_FALSE(view.WouldRetireOnReset(heap));
    EXPECT_TRUE(producer.WouldRetireOnReset(heap, dc2::memory::ArenaResetKind::Rebind));
    EXPECT_TRUE(view.WouldRetireOnReset(heap, dc2::memory::ArenaResetKind::Rebind));
    heap.EndStackMode();
    heap.Free(allocation);
    EXPECT_FALSE(producer.IsLive());
    EXPECT_TRUE(view.Bytes().empty());
}

TEST_F(MgMemory, ImmutableResourcesValidateTypesAndEveryProducerBeforeAcquisition) {
    mgCMemory anchor_owner;
    anchor_owner.stSetBuffer(buffer_, 128);
    auto       *storage = anchor_owner.Alloc(1);
    const auto  anchor = dc2::memory::ArenaBuffer::Bind(anchor_owner, std::span(reinterpret_cast<u8 *>(storage), sizeof(u_long128)));
    static char producer_key;
    mgCMemory   producer;
    producer.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(&producer_key, 128 * sizeof(u_long128))), 128);
    const auto       dependency = dc2::memory::ArenaLifetime::Capture(producer);
    const std::array dependencies{dependency};
    const auto       resource = dc2::memory::ArenaResource::Store(anchor, std::make_shared<const std::string>("immutable metadata"), dependencies);
    ASSERT_TRUE(resource.HasValue());
    ASSERT_TRUE(resource.IsLive());
    const auto acquired = resource.Acquire<std::string>();
    ASSERT_NE(acquired, nullptr);
    EXPECT_EQ(*acquired, "immutable metadata");
    EXPECT_EQ(resource.Acquire<int>(), nullptr);
    EXPECT_TRUE(resource.WouldRetireOnReset(producer));
    EXPECT_TRUE(resource.WouldRetireOnReset(anchor_owner));
    EXPECT_EQ(dependency, dc2::memory::ArenaLifetime::Capture(producer));
    producer.stReset();
    EXPECT_FALSE(resource.IsLive());
    EXPECT_EQ(resource.Acquire<std::string>(), nullptr);
    EXPECT_EQ(*acquired, "immutable metadata");
    EXPECT_NE(dependency, dc2::memory::ArenaLifetime::Capture(producer));
    EXPECT_FALSE(dc2::memory::ArenaResource::Store(anchor, std::make_shared<int>(7), dependencies).HasValue());
}

TEST_F(MgMemory, ImmutableResourcesRejectAnchorAddressReuseAndReleaseRetiredMetadata) {
    mgCMemory memory;
    memory.stSetBuffer(buffer_, 128);
    auto                    *first = memory.Alloc(1);
    const auto               anchor = dc2::memory::ArenaBuffer::Bind(memory, std::span(reinterpret_cast<u8 *>(first), sizeof(u_long128)));
    auto                     value = std::make_shared<int>(42);
    const std::weak_ptr<int> weak = value;
    const auto               resource = dc2::memory::ArenaResource::Store(anchor, value);
    value.reset();
    ASSERT_FALSE(weak.expired());
    memory.stReset();
    EXPECT_TRUE(weak.expired());
    ASSERT_EQ(memory.Alloc(1), first);
    EXPECT_EQ(resource.Acquire<int>(), nullptr);
    EXPECT_FALSE(resource.IsLive());
}

TEST_F(MgMemory, ImmutableResourcesPreserveUnrelatedCompletedHeapDependencies) {
    mgCMemory heap;
    heap.SetHeapMem(buffer_, 128);
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, 32), nullptr);
    auto            *first = heap.Alloc(4);
    const auto       dependency = dc2::memory::ArenaLifetime::Capture(heap);
    const auto       anchor = dc2::memory::ArenaBuffer::Bind(heap, std::span(reinterpret_cast<u8 *>(first), sizeof(u_long128)));
    const std::array dependencies{dependency};
    const auto       resource = dc2::memory::ArenaResource::Store(anchor, std::make_shared<int>(7), dependencies);
    heap.EndStackMode();
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, 32), nullptr);
    auto *other = heap.Alloc(4);
    ASSERT_NE(other, nullptr);
    EXPECT_FALSE(resource.WouldRetireOnReset(heap));
    heap.stReset();
    ASSERT_NE(resource.Acquire<int>(), nullptr);
    heap.EndStackMode();
    heap.Free(first);
    EXPECT_EQ(resource.Acquire<int>(), nullptr);
}

TEST_F(MgMemory, BoundedTextReadsOnlyItsDeclaredExtentAndPreservesAdjacentStorage) {
    constexpr std::array<char, 3> source{'a', 'b', 'c'};
    constexpr std::size_t         capacity = 2 * sizeof(u_long128);
    std::memset(buffer_, 0xA5, capacity);
    mgCMemory memory;
    memory.stSetBuffer(buffer_, 2);
    const auto *copy = dc2::memory::CopyText(memory, std::string_view(source.data(), source.size()));
    ASSERT_NE(copy, nullptr);
    EXPECT_STREQ(copy, "abc");
    EXPECT_EQ(memory.stGetUsed(), 1);
    const auto *bytes = reinterpret_cast<const unsigned char *>(buffer_);
    for (std::size_t index = source.size() + 1; index < capacity; ++index) {
        EXPECT_EQ(bytes[index], 0xA5);
    }
}

TEST_F(MgMemory, EmptyBoundedTextNeedsNoSourcePointerAndOwnsItsTerminator) {
    std::memset(buffer_, 0xA5, 2 * sizeof(u_long128));
    mgCMemory memory;
    memory.stSetBuffer(buffer_, 2);
    const auto *copy = dc2::memory::CopyText(memory, std::string_view{});
    ASSERT_NE(copy, nullptr);
    EXPECT_STREQ(copy, "");
    EXPECT_EQ(memory.stGetUsed(), 1);
}

TEST_F(MgMemory, BoundedTextPreservesEmbeddedZeroesWithoutReadingPastTheView) {
    constexpr std::array<char, 4> source{'a', '\0', 'b', 'c'};
    mgCMemory                     memory;
    memory.stSetBuffer(buffer_, 2);
    const auto *copy = dc2::memory::CopyText(memory, std::string_view(source.data(), source.size()));
    ASSERT_NE(copy, nullptr);
    EXPECT_EQ(std::memcmp(copy, source.data(), source.size()), 0);
    EXPECT_EQ(copy[source.size()], '\0');
}

TEST_F(MgMemory, ImmutableResourceIdentitiesRemainExactAcrossLeaseGaps) {
    constexpr std::size_t per_block = 256;
    mgCMemory             heap;
    heap.SetHeapMem(buffer_, kQuadwords);
    std::array<dc2::memory::ArenaResource, per_block * 3> resources;
    std::array<mgCMemory, 3>                              children;
    std::array<u_long128 *, 3>                            blocks{};
    for (std::size_t block = 0; block < blocks.size(); ++block) {
        ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(per_block + 16)), nullptr);
        for (std::size_t offset = 0; offset < per_block; ++offset) {
            auto *storage = heap.Alloc(1);
            ASSERT_NE(storage, nullptr);
            if (offset == 0) {
                blocks[block] = storage;
            }
            if (offset == per_block - 1) {
                children[block].stSetChildBuffer(heap, storage, 1);
                ASSERT_TRUE(dc2::memory::ArenaStorageLive(children[block]));
            }
            const auto anchor = dc2::memory::ArenaBuffer::Bind(heap, std::span(reinterpret_cast<u8 *>(storage), sizeof(u_long128)));
            const auto index = block * per_block + offset;
            resources[index] = dc2::memory::ArenaResource::Store(anchor, std::make_shared<const std::size_t>(index));
            ASSERT_TRUE(resources[index].IsLive());
        }
        heap.EndStackMode();
    }
    heap.Free(blocks[1]);
    for (std::size_t index = 0; index < resources.size(); ++index) {
        const auto value = resources[index].Acquire<std::size_t>();
        if (index / per_block == 1) {
            EXPECT_EQ(value, nullptr) << index;
        } else {
            ASSERT_NE(value, nullptr) << index;
            EXPECT_EQ(*value, index);
        }
    }
    EXPECT_TRUE(dc2::memory::ArenaStorageLive(children[0]));
    EXPECT_FALSE(dc2::memory::ArenaStorageLive(children[1]));
    EXPECT_TRUE(dc2::memory::ArenaStorageLive(children[2]));
    ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, 32), nullptr);
    auto *replacement = heap.Alloc(1);
    ASSERT_NE(replacement, nullptr);
    const auto anchor = dc2::memory::ArenaBuffer::Bind(heap, std::span(reinterpret_cast<u8 *>(replacement), sizeof(u_long128)));
    const auto resource = dc2::memory::ArenaResource::Store(anchor, std::make_shared<const std::size_t>(resources.size()));
    ASSERT_NE(resource.Acquire<std::size_t>(), nullptr);
    EXPECT_EQ(*resource.Acquire<std::size_t>(), resources.size());
    EXPECT_EQ(resources[per_block].Acquire<std::size_t>(), nullptr);
    EXPECT_FALSE(dc2::memory::ArenaStorageLive(children[1]));
}
