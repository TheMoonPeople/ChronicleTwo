#pragma once

#include "common.h"

#include <cstdint>
#include <limits>
#include <memory>
#include <new>
#include <optional>
#include <span>
#include <string_view>
#include <type_traits>
#include <utility>

#if defined(__has_feature)
#if __has_feature(address_sanitizer)
#define CT_ARENA_POISONING 1
#endif
#endif
#if defined(__SANITIZE_ADDRESS__) && !defined(CT_ARENA_POISONING)
#define CT_ARENA_POISONING 1
#endif
#ifdef CT_ARENA_POISONING
#include <sanitizer/asan_interface.h>
#endif

class mgCMemory;

namespace dc2::memory {
std::uint64_t ArenaGeneration(const mgCMemory &memory);
void          InvalidateArenaGeneration(const mgCMemory &memory);
/**
 *
 * Reports whether an arena's root mapping and explicit parent leases remain live.
 *
 */
bool ArenaStorageLive(const mgCMemory &memory);
/**
 *
 * Retires stack leases while preserving unrelated completed heap blocks.
 *
 */
void          ResetArenaStack(const mgCMemory &memory);
std::span<u8> AllocationBytes(const mgCMemory &memory, const void *pointer);

/**
 * Distinguishes resetting the current stack from replacing the complete arena binding.
 */
enum class ArenaResetKind {
    Stack,
    Rebind,
};

/**
 * Tracks an explicit producer's generation and optional heap-block identity.
 */
class ArenaLifetime {
public:
    /**
     * Captures a live standalone arena or its current active heap block.
     */
    static ArenaLifetime Capture(const mgCMemory &memory);

    /**
     * Captures the live producer block containing a specific allocation.
     */
    static ArenaLifetime Capture(const mgCMemory &memory, const void *allocation);

    /**
     * Reports whether the captured generation, parent chain and heap block remain live.
     */
    [[nodiscard]] bool IsLive() const;

    /**
     * Distinguishes an absent resource channel from a captured capability that has expired.
     */
    [[nodiscard]] bool HasValue() const noexcept { return owner != nullptr; }

    /**
     * Reports whether an operation would retire this currently live producer capability.
     */
    [[nodiscard]] bool WouldRetireOnReset(const mgCMemory &memory, ArenaResetKind kind = ArenaResetKind::Stack) const;

    /**
     * Compares exact producer generations and heap-block identities.
     */
    friend bool operator==(const ArenaLifetime &, const ArenaLifetime &) = default;

private:
    friend class ArenaResource;
    const mgCMemory *owner = nullptr; /**< Explicit producer whose storage supplies the resources. */
    std::uint64_t    generation = 0;  /**< Producer generation captured without retaining its controller. */
    std::uint64_t    heap_block = 0;  /**< Exact producer heap block, or zero for a standalone binding. */
};

static_assert(std::is_trivially_copyable_v<ArenaLifetime>);
static_assert(std::is_trivially_destructible_v<ArenaLifetime>);

/**
 *
 * Holds a non-owning byte view backed by explicit live arena and allocation identities.
 *
 */
class ArenaBuffer {
public:
    /**
     *
     * Captures a bounded allocation through its logical owner and optional backing owner.
     *
     */
    static ArenaBuffer Bind(mgCMemory &logical_owner, std::span<u8> storage, mgCMemory *backing = nullptr);

    /**
     *
     * Returns the byte view only while both owners and its exact allocation remain live.
     *
     */
    [[nodiscard]] std::span<u8> Bytes() const;

    /**
     * Compares exact captured owners, allocation identity and byte extent without rebinding storage.
     */
    [[nodiscard]] bool SameIdentity(const ArenaBuffer &other) const noexcept;

    /**
     * Reports whether an operation would retire this currently live allocation view.
     */
    [[nodiscard]] bool WouldRetireOnReset(const mgCMemory &memory, ArenaResetKind kind = ArenaResetKind::Stack) const;

    /**
     *
     * Returns a bounded subview retaining the exact allocation and owner identities.
     *
     */
    [[nodiscard]] ArenaBuffer Subspan(std::size_t offset, std::size_t count) const;

    /**
     *
     * Keeps an auxiliary resource alive until this exact allocation or either owner retires.
     *
     */
    [[nodiscard]] bool Retain(std::shared_ptr<const void> resource) const;

private:
    friend class ArenaText;
    friend class ArenaResource;
    const mgCMemory *owner = nullptr;         /**< Logical owner whose resets retire the view. */
    const mgCMemory *backing_owner = nullptr; /**< Owner of the exact source allocation. */
    std::uint64_t    owner_generation = 0;    /**< Logical owner's generation when captured. */
    std::uint64_t    backing_generation = 0;  /**< Backing owner's generation when captured. */
    std::uint64_t    allocation = 0;          /**< Exact backing allocation identity. */
    std::span<u8>    storage;                 /**< Requested byte extent within the captured allocation. */
};

/**
 * Owns immutable native metadata through an exact allocation and explicit producer dependencies.
 */
class ArenaResource {
public:
    /**
     * Stores metadata whose destruction does not call arena registry APIs.
     */
    template <class T>
    static ArenaResource Store(const ArenaBuffer &anchor, std::shared_ptr<T> value,
                               std::span<const ArenaLifetime> dependencies = {}) {
        return StoreErased(anchor, std::move(value), &type_key<std::remove_cv_t<T>>, dependencies);
    }

    /**
     * Acquires immutable metadata only while its allocation and every producer remain live.
     */
    template <class T>
    [[nodiscard]] std::shared_ptr<const T> Acquire() const {
        return std::static_pointer_cast<const T>(AcquireErased(&type_key<std::remove_cv_t<T>>));
    }

    /**
     * Distinguishes an absent metadata handle from one whose producers have retired.
     */
    [[nodiscard]] bool HasValue() const noexcept { return owner != nullptr; }

    /**
     * Reports whether the allocation and all captured dependencies remain live.
     */
    [[nodiscard]] bool IsLive() const;

    /**
     * Predicts whether resetting an arena would retire the allocation or a producer.
     */
    [[nodiscard]] bool WouldRetireOnReset(const mgCMemory &memory, ArenaResetKind kind = ArenaResetKind::Stack) const;

private:
    template <class T>
    static inline constexpr unsigned char type_key = 0; /**< Distinguishes exact metadata types without RTTI. */
    /**
     * Publishes metadata only after validating the allocation and explicit producers.
     */
    static ArenaResource StoreErased(const ArenaBuffer &anchor, std::shared_ptr<const void> value,
                                     const void *type, std::span<const ArenaLifetime> dependencies);
    /**
     * Returns a strong metadata owner only while its type and all dependencies match.
     */
    [[nodiscard]] std::shared_ptr<const void> AcquireErased(const void *type) const;
    const mgCMemory                          *owner = nullptr; /**< Registry owning the metadata entry. */
    std::uint64_t                             resource = 0;    /**< Monotonic identity that cannot revive after retirement. */
};

static_assert(std::is_trivially_copyable_v<ArenaResource>);
static_assert(std::is_trivially_destructible_v<ArenaResource>);

/**
 *
 * Borrows immutable auxiliary text while its exact arena allocation remains live.
 *
 */
class ArenaText {
public:
    /**
     *
     * Copies or interns text without consuming the arena's game storage.
     *
     */
    static ArenaText Copy(const ArenaBuffer &anchor, std::string_view text);
    /**
     *
     * Returns text only while its captured allocation identity is live.
     *
     */
    [[nodiscard]] std::optional<std::string_view> Text() const;

private:
    const mgCMemory *owner = nullptr; /**< Registry owner of the immutable resource. */
    std::uint64_t    resource = 0;    /**< Unique resource identity that never revives after retirement. */
};

static_assert(std::is_trivially_copyable_v<ArenaText>);
static_assert(std::is_trivially_destructible_v<ArenaText>);

static_assert(std::is_trivially_copyable_v<ArenaBuffer>);
static_assert(std::is_trivially_destructible_v<ArenaBuffer>);

} // namespace dc2::memory

/**
 * @file
 * Declares the engine's quadword memory manager: a block heap carved from a
 * caller-supplied buffer, plus a stack region that hands out memory linearly.
 */

/**
 *
 * Ways StartStackMode picks the free gap in the heap that becomes the
 * stack region.
 *
 */
enum mgSTACK_MODE {
    MG_STACK_MODE_FIRST = 1,   /**< First gap with room for at least one quadword after the header. */
    MG_STACK_MODE_LARGEST = 2, /**< Largest gap in the heap. */
    MG_STACK_MODE_FIT = 3,     /**< First gap with room for more than the requested quadwords. */
};

/**
 *
 * Header that precedes every block in an mgCMemory heap, linking the
 * blocks in address order.
 *
 */
struct mgMEMORY_BLOCK {
    u_long128      *data; /**< Start of the block's contents, directly after this header. */
    int             size; /**< Quadwords the block occupies, header included. */
    int             unk_8;
    mgMEMORY_BLOCK *next; /**< Following block, or NULL for the terminating header. */
};

STATIC_ASSERT(sizeof(mgMEMORY_BLOCK) == 0x10);

/**
 *
 * Quadword memory manager over one buffer, either as a block heap or as a
 * linear stack region allocated from the start of a buffer.
 *
 */
class mgCMemory {
public:
    char            name[0x10]{}; /**< Name shown in overflow messages. */
    u_int           heap_size{};  /**< Heap buffer size, in quadwords. */
    u_long128      *heap{};       /**< Heap buffer. */
    mgMEMORY_BLOCK *heap_top{};   /**< First block header of the heap, at the start of the heap buffer. */
    int             lock{};       /**< Non-zero refuses every stack allocation and alignment. */

    union {
        u_long128 *stack{};
        u8        *stack_bytes;
    }; /**< Stack region allocations are taken from. */

    int             stack_used{};  /**< Quadwords of the stack region in use. */
    int             stack_size{};  /**< Quadwords available in the stack region. */
    mgMEMORY_BLOCK *stack_block{}; /**< Heap block holding the stack region while stack mode is active. */

    /**
     *
     * Creates a manager with no buffers attached.
     *
     * @mangled __ct__9mgCMemoryFv
     * @address 0x1466A0
     * @size 0x30
     */
    mgCMemory() { Init(); }

    mgCMemory(const mgCMemory &) = delete;
    mgCMemory &operator=(const mgCMemory &) = delete;
    mgCMemory(mgCMemory &&) = delete;
    mgCMemory &operator=(mgCMemory &&) = delete;

    ~mgCMemory();

    int stGetUsed() {
        return stack_used;
    }

    int stGetSize() {
        return stack_size;
    }

    int stGetRest() {
        return stack_size - stack_used;
    }

    u_long128 *stGetTop() {
        if (!dc2::memory::ArenaStorageLive(*this) || stack == nullptr || stack_used < 0 || stack_used > stack_size) {
            return nullptr;
        }
        return stack + stack_used;
    }

    /**
     *
     * Rewinds stack allocations while preserving the allocation lock.
     *
     */
    void stClearUsed();

    /**
     * Resets current stack allocations and unlocks native allocation.
     */
    void stReset();

    /**
     *
     * Enables or disables stack allocation without changing live storage.
     *
     */
    void stSetLocked(bool value);

    /**
     *
     * Detaches the heap and stack buffers and clears the name, leaving
     * nothing to allocate from.
     *
     * @mangled Init__9mgCMemoryFv
     * @address 0x139F70
     * @size 0x30
     */
    void Init();

    /**
     *
     * Makes a buffer the heap, as one free gap ending in a terminating header;
     * a NULL buffer or one under sixteen quadwords resets the manager instead.
     *
     * @mangled SetHeapMem__9mgCMemoryFP1i
     * @address 0x139FA0
     * @size 0xA0
     */
    void SetHeapMem(u_long128 *buffer, int size);

    /**
     *
     * Discards everything in the heap and the stack region, keeping the
     * current heap buffer as an empty heap.
     *
     * @mangled ClearHeapMem__9mgCMemoryFv
     * @address 0x13A040
     * @size 0x50
     */
    void ClearHeapMem();

    /**
     *
     * Unlinks the heap block whose contents start at the given address,
     * halting with a message when no block matches.
     *
     * @mangled Free__9mgCMemoryFP1
     * @address 0x13A090
     * @size 0x80
     */
    void Free(u_long128 *data);

    /**
     *
     * Claims a free gap in the heap as a new block and makes its space the
     * stack region; gives the region's start, or NULL when no gap qualifies.
     *
     * @mangled StartStackMode__9mgCMemoryFii
     * @address 0x13A110
     * @size 0x130
     */
    u_long128 *StartStackMode(int mode, int size);

    /**
     *
     * Grows the stack-mode block to cover what the stack region used and
     * detaches the stack region.
     *
     * @mangled EndStackMode__9mgCMemoryFv
     * @address 0x13A240
     * @size 0x40
     */
    void EndStackMode();

    /**
     *
     * Allocates quadwords from the stack region starting on a 64-byte
     * boundary.
     *
     * @mangled stAlloc64__9mgCMemoryFi
     * @address 0x13A280
     * @size 0x40
     */
    u_long128 *stAlloc64(int size);

    /**
     *
     * Gives the address the next stack allocation of the given size would
     * return, without claiming it, or NULL when it would not fit.
     *
     * @mangled stAllocTest__9mgCMemoryFi
     * @address 0x13A2C0
     * @size 0x60
     */
    u_long128 *stAllocTest(int size);

    /**
     *
     * Allocates quadwords from the stack region, or gives NULL when the
     * manager is locked, the size is not positive or the region is full.
     *
     * @mangled stAlloc__9mgCMemoryFi
     * @address 0x13A320
     * @size 0x70
     */
    u_long128 *stAlloc(int size);

    /**
     *
     * Allocates quadwords from the stack region, or gives NULL when the
     * manager is locked, the size is not positive or the region is full.
     *
     * @mangled Alloc__9mgCMemoryFi
     * @address 0x13A390
     * @size 0x70
     */
    u_long128 *Alloc(int size);

    /**
     *
     * Advances the stack region's next allocation to a 64-byte boundary,
     * clamped to the region's end.
     *
     * @mangled stAlign64__9mgCMemoryFv
     * @address 0x13A400
     * @size 0x70
     */
    void stAlign64();

    /**
     *
     * Advances the stack region's next allocation to a 64-byte boundary,
     * clamped to the region's end.
     *
     * @mangled Align64__9mgCMemoryFv
     * @address 0x13A470
     * @size 0x70
     */
    void Align64();

    /**
     *
     * Makes a buffer the stack region, empty and holding the given
     * number of quadwords.
     *
     * @mangled stSetBuffer__9mgCMemoryFP1i
     * @address 0x13A4E0
     * @size 0x10
     */
    void stSetBuffer(u_long128 *buffer, int size);

    /**
     *
     * Binds a child stack to a live, explicitly identified parent allocation.
     *
     */
    void stSetChildBuffer(mgCMemory &parent, u_long128 *buffer, int size);

    /**
     *
     * Binds an explicitly shared view of an owner's bounded, live stack storage.
     *
     */
    void stSetBorrowedBuffer(mgCMemory &owner, std::span<u_long128> storage);

    /**
     *
     * Shares a checked stack subview with an unlocked independent cursor, retaining its explicit owner.
     *
     */
    bool stShareBuffer(const mgCMemory &source, std::span<u_long128> storage);

    /**
     *
     * Shares validated stack storage, cursor, and allocation-lock state without copying allocator identity or heap ownership.
     *
     */
    bool stShareStack(const mgCMemory &source);

    /**
     *
     * Returns the stack region as bytes.
     *
     */
    u8 *stGetBuffer() {
        return stack_bytes;
    }
};

STATIC_ASSERT(sizeof(mgCMemory) == 0x30);

namespace dc2::memory {
/**
 *
 * Under AddressSanitizer, marks arena bytes no allocation holds, so any access to them is reported.
 *
 */
inline void PoisonArenaBytes([[maybe_unused]] const void *start, [[maybe_unused]] std::size_t bytes) {
#ifdef CT_ARENA_POISONING
    ASAN_POISON_MEMORY_REGION(start, bytes);
#endif
}

/**
 *
 * Under AddressSanitizer, marks arena bytes an allocation or a caller now holds as addressable.
 *
 */
inline void UnpoisonArenaBytes([[maybe_unused]] const void *start, [[maybe_unused]] std::size_t bytes) {
#ifdef CT_ARENA_POISONING
    ASAN_UNPOISON_MEMORY_REGION(start, bytes);
#endif
}

/**
 *
 * Returns the writable bytes left in an arena's stack region, which the caller may fill before allocating them.
 *
 */
inline std::span<u8> RemainingBytes(mgCMemory &memory) {
    if (!ArenaStorageLive(memory) || memory.stack == nullptr || memory.stack_size < 0 || memory.stack_used < 0 ||
        memory.stack_used > memory.stack_size) {
        return {};
    }
    const std::span<u8> remaining{reinterpret_cast<u8 *>(memory.stack + memory.stack_used),
                                  static_cast<std::size_t>(memory.stack_size - memory.stack_used) * sizeof(u_long128)};
    UnpoisonArenaBytes(remaining.data(), remaining.size());
    return remaining;
}

/**
 *
 * Returns the writable arena bytes from a borrowed pointer through the arena's end.
 *
 */
inline std::span<u8> AvailableFrom(mgCMemory &memory, void *pointer) {
    if (!ArenaStorageLive(memory) || memory.stack == nullptr || pointer == nullptr || memory.stack_size < 0 ||
        memory.stack_used < 0 || memory.stack_used > memory.stack_size) {
        return {};
    }
    const auto base = reinterpret_cast<std::uintptr_t>(memory.stack);
    const auto address = reinterpret_cast<std::uintptr_t>(pointer);
    const auto bytes = static_cast<std::size_t>(memory.stack_size) * sizeof(u_long128);
    if (base % alignof(u_long128) != 0 || bytes > UINTPTR_MAX - base ||
        address < base || address >= base + bytes) {
        return {};
    }
    return {static_cast<u8 *>(pointer), base + bytes - address};
}
} // namespace dc2::memory

/**
 *
 * Gives an address back unchanged, printing a stack overflow message
 * naming the caller's context when it is NULL.
 *
 * @mangled MG_ADDRESS_CHECK__FPvPc
 * @address 0x139F20
 * @size 0x30
 */
void *MG_ADDRESS_CHECK(void *address, char *where);

/**
 *
 * Constructs an object in memory taken from an mgCMemory.
 *
 * @mangled __nw__FUiP1
 * @address 0x139F50
 * @size 0x10
 */
void *operator new(size_t size, u_long128 *buffer);

/**
 *
 * Constructs an array in memory taken from an mgCMemory.
 *
 * @mangled __nwa__FUiP1
 * @address 0x139F60
 * @size 0x10
 */
void *operator new[](size_t size, u_long128 *buffer);

namespace dc2::memory {
/**
 *
 * Constructs an object in enough checked arena storage for its host size and alignment.
 *
 */
template <class T, class... Args>
T *NewObject(mgCMemory &memory, Args &&...args) {
    static_assert(alignof(T) <= alignof(u_long128));
    static_assert(std::is_trivially_destructible_v<T>, "arena reset cannot run object destructors");
    constexpr std::size_t quadwords = sizeof(T) / sizeof(u_long128) + (sizeof(T) % sizeof(u_long128) != 0);
    static_assert(quadwords < static_cast<std::size_t>(std::numeric_limits<int>::max()));
    if (memory.lock != 0 || RemainingBytes(memory).size() / sizeof(u_long128) <= quadwords) {
        return nullptr;
    }
    auto *storage = memory.Alloc(static_cast<int>(quadwords));
    if (storage == nullptr) {
        return nullptr;
    }
    if constexpr (sizeof...(Args) == 0) {
        return new (storage) T;
    } else {
        return new (storage) T(std::forward<Args>(args)...);
    }
}

/**
 *
 * Gives the checked quadword size of an array constructed without an ABI array cookie.
 *
 */
template <class T>
constexpr std::optional<int> ArrayQuadwords(std::size_t count) {
    static_assert(alignof(T) <= alignof(u_long128));
    if (count == 0 || count > std::numeric_limits<std::size_t>::max() / sizeof(T)) {
        return std::nullopt;
    }
    const std::size_t bytes = count * sizeof(T);
    const std::size_t quadwords = bytes / sizeof(u_long128) + (bytes % sizeof(u_long128) != 0);
    if (quadwords >= static_cast<std::size_t>(std::numeric_limits<int>::max())) {
        return std::nullopt;
    }
    return static_cast<int>(quadwords);
}

/**
 *
 * Constructs an array in a checked arena lease using the nonallocating placement form.
 *
 */
template <class T>
T *NewArray(mgCMemory &memory, std::size_t count) {
    static_assert(std::is_trivially_destructible_v<T>, "arena reset cannot run array destructors");
    const auto quadwords = ArrayQuadwords<T>(count);
    if (!quadwords || memory.lock != 0 ||
        RemainingBytes(memory).size() / sizeof(u_long128) <= static_cast<std::size_t>(*quadwords)) {
        return nullptr;
    }
    auto *storage = memory.Alloc(*quadwords);
    if (storage == nullptr) {
        return nullptr;
    }
    return ::new (static_cast<void *>(storage)) T[count];
}

/**
 *
 * Copies bounded text and its terminator into a checked arena allocation.
 *
 */
char *CopyText(mgCMemory &memory, std::string_view text);

} // namespace dc2::memory

/**
 *
 * Copies a string into stack memory of a manager, giving the copy, or
 * NULL when either argument is NULL or the memory is full.
 *
 * @mangled mgCopyString__FPcP9mgCMemory
 * @address 0x13A4F0
 * @size 0x90
 */
char *mgCopyString(char *source, mgCMemory *memory);
