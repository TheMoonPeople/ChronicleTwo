#include <array>
#include <climits>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>

#include "arena_root.hpp"
#include "dataread_port.hpp"
#include "mg_memory_port.hpp"
#include "platform/arena.hpp"
#include "texture_source.hpp"

namespace {

constexpr std::uintptr_t kQuadwordBytes = sizeof(u_long128);

// A PS2 header is one quadword. A host header holds two 8-byte pointers, 24 bytes, so it takes two
// quadwords. Every size and gap below counts in quadwords, header included.
constexpr int kHeaderQuadwords = static_cast<int>((sizeof(mgMEMORY_BLOCK) + kQuadwordBytes - 1) / kQuadwordBytes);

using NameCopy = std::array<char, sizeof(mgCMemory::name) + 1>;

NameCopy CopyName(const char *name) {
    NameCopy copy{};
    std::memcpy(copy.data(), name, sizeof(mgCMemory::name));
    return copy;
}

// Placement new grows the run AllocQuadwords handed out last, since retail's quadword counts for
// host objects were written for the PS2 and a host object holding pointers is larger.
struct LastRun {
    mgCMemory *arena = nullptr;
    u_long128 *start = nullptr;
    int        quadwords = 0;
};

LastRun g_last_run;

void ForgetRun(const mgCMemory *memory) {
    if (g_last_run.arena == memory) {
        g_last_run = LastRun{};
    }
}

std::uintptr_t AddressOf(const void *pointer) {
    return reinterpret_cast<std::uintptr_t>(pointer);
}

u_long128 *QuadwordsFrom(const void *base, std::ptrdiff_t quadwords) {
    return reinterpret_cast<u_long128 *>(static_cast<unsigned char *>(const_cast<void *>(base)) +
                                         quadwords * static_cast<std::ptrdiff_t>(kQuadwordBytes));
}

std::ptrdiff_t QuadwordsBetween(const void *from, const void *to) {
    return (static_cast<const unsigned char *>(to) - static_cast<const unsigned char *>(from)) /
           static_cast<std::ptrdiff_t>(kQuadwordBytes);
}

mgMEMORY_BLOCK *BlockAt(const void *base, std::ptrdiff_t quadwords) {
    return reinterpret_cast<mgMEMORY_BLOCK *>(QuadwordsFrom(base, quadwords));
}

struct PeakEntry {
    const mgCMemory *memory;
    bool             heap;
    int              capacity;
    int              peak;
    // Arenas may be destroyed without MemoryForget, so the log prints this copy and never dereferences memory.
    NameCopy name;
};

// Function-local so arenas constructed during static initialisation can reach it.
std::vector<PeakEntry> &PeakTable() {
    static std::vector<PeakEntry> table;
    return table;
}

PeakEntry *FindPeak(const mgCMemory *memory) {
    for (PeakEntry &entry : PeakTable()) {
        if (entry.memory == memory) {
            return &entry;
        }
    }

    return nullptr;
}

void ResetPeak(const mgCMemory *memory, bool heap, int capacity) {
    PeakEntry *entry = FindPeak(memory);
    PeakEntry  fresh{memory, heap, capacity, 0, {}};
    std::memcpy(fresh.name.data(), memory->name, sizeof(memory->name));

    if (entry == nullptr) {
        PeakTable().push_back(fresh);
    } else {
        *entry = fresh;
    }
}

int HeapAllocatedQuadwords(const mgCMemory &memory) {
    if (memory.heap_top == nullptr) {
        return 0;
    }

    int total = 0;

    for (const mgMEMORY_BLOCK *block = memory.heap_top->next; block->next != nullptr; block = block->next) {
        // The active stack block keeps size at its header until EndStackMode folds stack_used in.
        total += block->size + (block == memory.stack_block ? memory.stack_used : 0);
    }

    return total;
}

void NotePeak(const mgCMemory &memory) {
    PeakEntry *entry = FindPeak(&memory);

    if (entry == nullptr) {
        return;
    }

    const int used = entry->heap ? HeapAllocatedQuadwords(memory) : memory.stack_used;

    if (used > entry->peak) {
        entry->peak = used;
    }
}

[[noreturn]] void Overflow(const mgCMemory &memory, long long used) {
    const int clamped = used > INT_MAX ? INT_MAX : static_cast<int>(used);

    if (memory.name[0] != '\0') {
        const NameCopy name = CopyName(memory.name);
        ArenaOverflow(name.data(), clamped, memory.stack_size);
    }

    ArenaOverflow(static_cast<const void *>(&memory), clamped, memory.stack_size);
}

u_long128 *AllocQuadwords(mgCMemory &memory, int size) {
    if (memory.lock != 0 || size <= 0) {
        return nullptr;
    }

    // Summed in 64 bits so a huge request fails the capacity check instead of wrapping past it.
    const long long new_used = static_cast<long long>(memory.stack_used) + size;

    if (new_used >= memory.stack_size) {
        Overflow(memory, new_used);
    }

    u_long128 *data = QuadwordsFrom(memory.stack, memory.stack_used);
    memory.stack_used = static_cast<int>(new_used);
    g_last_run = {&memory, data, size};
    NotePeak(memory);
    return data;
}

void GrowLastRun(u_long128 *buffer, std::size_t bytes) {
    LastRun &run = g_last_run;

    if (run.arena == nullptr || run.start != buffer) {
        return;
    }

    mgCMemory &memory = *run.arena;
    const int  quadwords = static_cast<int>((bytes + kQuadwordBytes - 1) / kQuadwordBytes);

    if (quadwords <= run.quadwords ||
        QuadwordsFrom(run.start, run.quadwords) != QuadwordsFrom(memory.stack, memory.stack_used)) {
        return;
    }

    const long long new_used = static_cast<long long>(memory.stack_used) + (quadwords - run.quadwords);

    if (new_used >= memory.stack_size) {
        Overflow(memory, new_used);
    }

    memory.stack_used = static_cast<int>(new_used);
    run.quadwords = quadwords;
    NotePeak(memory);
}

void AlignStack(mgCMemory &memory) {
    if (memory.lock) {
        return;
    }

    // Quadword-aligned on both hosts, so the misalignment is a multiple of 16 and the step is exact.
    const std::uintptr_t misalign = AddressOf(QuadwordsFrom(memory.stack, memory.stack_used)) & 0x3F;

    if (misalign != 0) {
        memory.stack_used += static_cast<int>(64 - misalign) / 16;
    }

    if (memory.stack_used >= memory.stack_size) {
        memory.stack_used = memory.stack_size;
    }

    NotePeak(memory);
}

} // namespace

PORT_OVERRIDE void mgCMemory::Init() {
    ForgetRun(this);
    heap_size = 0;
    heap = nullptr;
    heap_top = nullptr;
    name[0] = '\0';
    stack = nullptr;
    stack_used = 0;
    stack_size = 0;
    stack_block = nullptr;
    lock = 0;
}

PORT_OVERRIDE void mgCMemory::SetHeapMem(u_long128 *buffer, int size) {
    ForgetRun(this);

    if (buffer != nullptr && size >= 0x10 && !ArenaContains(buffer)) {
        const NameCopy label = CopyName(name);
        u_long128     *block = ArenaRoot(buffer, size, label.data());
        std::memcpy(block, buffer, static_cast<std::size_t>(size) * sizeof(u_long128));
        TextureSourceCopy(buffer, block, static_cast<std::size_t>(size) * sizeof(u_long128));
        DataReadCopyBuffer(buffer, block, static_cast<std::size_t>(size) * sizeof(u_long128));
        buffer = block;
        size *= kArenaHeadroom;
    }

    // Signed on purpose: an unsigned compare would take a negative size as huge and map the terminator
    // past the end of the buffer.
    if (buffer == nullptr || size < 0x10) {
        Init();
        ResetPeak(this, true, 0);
        return;
    }

    heap = buffer;
    heap_size = static_cast<u_int>(size);
    heap_top = reinterpret_cast<mgMEMORY_BLOCK *>(buffer);
    heap_top->data = nullptr;
    heap_top->size = kHeaderQuadwords;
    heap_top->next = BlockAt(buffer, static_cast<std::ptrdiff_t>(heap_size) - kHeaderQuadwords);
    heap_top->next->data = nullptr;
    heap_top->next->size = 0;
    heap_top->next->next = nullptr;
    ResetPeak(this, true, size);
}

PORT_OVERRIDE void mgCMemory::Free(u_long128 *data) {
    if (data == nullptr) {
        return;
    }

    mgMEMORY_BLOCK *prev = nullptr;
    mgMEMORY_BLOCK *found = nullptr;

    for (mgMEMORY_BLOCK *block = heap_top; block->next != nullptr; block = block->next) {
        if (block->data == data) {
            found = block;
            break;
        }

        prev = block;
    }

    if (found == nullptr) {
        // Retail halts here. A host process that spins would hang the test run, so it aborts instead.
        std::fprintf(stderr, "Illegal Free Memory %p\n", static_cast<void *>(data));
        std::abort();
    }

    prev->next = found->next;
}

PORT_OVERRIDE u_long128 *mgCMemory::StartStackMode(int mode, int size) {
    stack_block = nullptr;
    mgMEMORY_BLOCK *block = heap_top;

    if (block == nullptr) {
        return nullptr;
    }

    mgMEMORY_BLOCK *chosen = nullptr;
    mgMEMORY_BLOCK *chosen_previous = nullptr;
    std::ptrdiff_t  chosen_count = 0;
    std::ptrdiff_t  best_count = 0;

    for (mgMEMORY_BLOCK *next; (next = block->next) != nullptr; block = next) {
        mgMEMORY_BLOCK      *gap = BlockAt(block, block->size);
        const std::ptrdiff_t count = QuadwordsBetween(gap, next);

        if (mode == 1 && count > kHeaderQuadwords) {
            chosen = gap;
            chosen_previous = block;
            chosen_count = count;
            break;
        }

        // A host header does not fit a one-quadword gap, which retail's one-quadword header does.
        if (mode == 2 && count >= kHeaderQuadwords && best_count < count) {
            chosen = gap;
            chosen_previous = block;
            chosen_count = count;
            best_count = count;
        }

        if (mode == 3 && size + kHeaderQuadwords < count) {
            chosen = gap;
            chosen_previous = block;
            chosen_count = count;
            break;
        }
    }

    if (chosen == nullptr) {
        return nullptr;
    }

    // Sized from the chosen gap. Retail sizes it from the last gap examined, so mode 2 can run the
    // stack region past the end of the gap it claimed and over the next header.
    stack_block = chosen;
    stack_block->next = chosen_previous->next;
    chosen_previous->next = stack_block;
    stack_block->size = kHeaderQuadwords;
    stack_block->data = QuadwordsFrom(stack_block, kHeaderQuadwords);
    stack = stack_block->data;
    stack_size = static_cast<int>(chosen_count - kHeaderQuadwords);
    NotePeak(*this);
    return stack_block->data;
}

PORT_OVERRIDE u_long128 *mgCMemory::stAllocTest(int size) {
    if (lock) {
        return nullptr;
    }

    const long long new_used = static_cast<long long>(stack_used) + size;

    if (new_used >= stack_size) {
        std::printf("stack over %lld/%d at %.16s\n", new_used, stack_size, name);
        return nullptr;
    }

    return QuadwordsFrom(stack, stack_used);
}

PORT_OVERRIDE u_long128 *mgCMemory::stAlloc(int size) {
    return AllocQuadwords(*this, size);
}

PORT_OVERRIDE u_long128 *mgCMemory::Alloc(int size) {
    return AllocQuadwords(*this, size);
}

PORT_OVERRIDE void mgCMemory::stAlign64() {
    AlignStack(*this);
}

PORT_OVERRIDE void mgCMemory::Align64() {
    AlignStack(*this);
}

PORT_OVERRIDE void mgCMemory::stSetBuffer(u_long128 *buffer, int size) {
    if (buffer != nullptr && size > 0 && !ArenaContains(buffer)) {
        const NameCopy label = CopyName(name);
        // The imported arena owns subsequent writes. Owners that reinitialize data
        // must clear/write the live root, rather than the original static buffer.
        buffer = ArenaRootFromBuffer(buffer, size, label.data());
        size *= kArenaHeadroom;
    }

    ForgetRun(this);
    stack = buffer;
    stack_used = 0;
    stack_size = size;
    ResetPeak(this, false, size);
}

PORT_OVERRIDE void *operator new(size_t size, u_long128 *buffer) {
    GrowLastRun(buffer, size);
    return buffer;
}

PORT_OVERRIDE void *operator new[](size_t size, u_long128 *buffer) {
    GrowLastRun(buffer, size);
    return buffer;
}

mgMemoryUsage MemoryUsage(const mgCMemory &memory) {
    const PeakEntry *entry = FindPeak(&memory);
    return {memory.name, entry ? entry->capacity : 0, entry ? entry->peak : 0};
}

void MemoryLogPeaks() {
    for (const PeakEntry &entry : PeakTable()) {
        if (entry.name[0] == '\0') {
            std::printf("mg_memory: ? [%p] peak %d of %d quadwords (%d free)\n", static_cast<const void *>(entry.memory),
                        entry.peak, entry.capacity, entry.capacity - entry.peak);
        } else {
            std::printf("mg_memory: %.16s peak %d of %d quadwords (%d free)\n", entry.name.data(), entry.peak,
                        entry.capacity, entry.capacity - entry.peak);
        }
    }
}

void MemoryForget(const mgCMemory &memory) {
    std::vector<PeakEntry> &table = PeakTable();

    for (auto it = table.begin(); it != table.end(); ++it) {
        if (it->memory == &memory) {
            table.erase(it);
            return;
        }
    }
}
