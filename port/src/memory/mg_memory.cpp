#include "common.h"

#include <algorithm>
#include <array>
#include <atomic>
#include <climits>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <memory>
#include <mutex>
#include <print>
#include <string>
#include <unordered_map>
#include <vector>

#include "arena_root.hpp"
#include "assets/data_registry.hpp"
#include "character_motion.hpp"
#include "log/game_output.hpp"
#include "log/log.hpp"
#include "mg_memory.hpp"
#include "platform/arena.hpp"
#include "platform/arena_usage.hpp"
#include "texture_source.hpp"

namespace {
void ForgetRun(const mgCMemory *memory);
} // namespace

namespace dc2::memory {
namespace {
/**
 *
 * Distinguishes allocated storage from explicitly shared, unreserved stack views.
 *
 */
enum class LeaseKind {
    Allocation,
    HeapBlock,
    BorrowedView,
};

/**
 *
 * Identifies one live allocation or explicitly shared stack view.
 *
 */
struct AllocationLease {
    std::uintptr_t start; /**< First byte of the allocation or view. */
    std::size_t    bytes; /**< Extent in bytes. */
    std::uint64_t  id;    /**< Identity preserved until this particular storage is retired. */
    LeaseKind      kind;  /**< Storage ownership represented by this lease. */
};

/**
 *
 * Separates allocation controllers from explicitly shareable cursor views.
 *
 */
enum class BindingRole : std::uint64_t {
    Owner,
    SharedView,
};

/**
 *
 * Carries the root mapping and optional parent lease backing one arena.
 *
 */
struct ArenaBinding {
    kz::arena::Region root;                      /**< Physical root mapping containing the arena. */
    const mgCMemory  *parent = nullptr;          /**< Explicit source owner, without extending its lifetime. */
    std::uint64_t     parent_generation = 0;     /**< Source owner's generation when the binding was made. */
    std::uint64_t     parent_lease = 0;          /**< Exact source allocation or shared-view identity. */
    std::uintptr_t    start = 0;                 /**< First bound byte. */
    std::size_t       bytes = 0;                 /**< Complete bound extent. */
    BindingRole       role = BindingRole::Owner; /**< Whether independent cursor views may retain the upstream lease directly. */
};

/**
 *
 * Captures the exact producer identity required by immutable metadata.
 *
 */
struct AuxiliaryDependency {
    const mgCMemory *owner;      /**< Explicit producer identity. */
    std::uint64_t    generation; /**< Captured producer generation. */
    std::uint64_t    heap_block; /**< Exact optional heap-block identity. */
};

/**
 * Owns auxiliary data with the exact allocation identity that permits its use.
 */
struct AuxiliaryResource {
    const mgCMemory                   *owner;              /**< Logical anchor owner. */
    const mgCMemory                   *backing;            /**< Backing allocation owner. */
    std::uint64_t                      generation;         /**< Logical generation captured at creation. */
    std::uint64_t                      backing_generation; /**< Backing generation captured at creation. */
    std::uint64_t                      allocation;         /**< Exact allocation identity. */
    std::uintptr_t                     start;              /**< First anchor byte. */
    std::size_t                        bytes;              /**< Complete anchor extent. */
    std::uint64_t                      id;                 /**< Unique immutable text identity. */
    std::unique_ptr<const std::string> text;               /**< Stable terminated text independent of game storage. */
    std::shared_ptr<const void>        resource;           /**< Optional immutable native input owned by the allocation. */
    const void                        *type = nullptr;     /**< Exact metadata type identity. */
    std::vector<AuxiliaryDependency>   dependencies;       /**< Explicit producers required by the metadata. */
};

/**
 *
 * Tracks an arena's identity, storage binding and live allocation leases.
 *
 */
struct ArenaState {
    std::uint64_t                  generation = 1; /**< Identity renewed when the whole owner is reset. */
    std::uint64_t                  next_lease = 1; /**< Next allocation identity for this owner address. */
    std::vector<AllocationLease>   leases;         /**< Current allocations and shared views ordered by increasing identity. */
    std::uint64_t                  next_text = 1;  /**< Next immutable resource identity. */
    std::vector<AuxiliaryResource> texts;          /**< Auxiliary storage ordered by increasing identity and released with its anchor. */
    std::optional<ArenaBinding>    binding;        /**< Root or parent storage backing the arena. */
};

/**
 * Finds an exact live allocation identity without scanning unrelated storage.
 */
const AllocationLease *FindLease(const ArenaState &state, std::uint64_t identity) {
    const auto lease = std::ranges::lower_bound(state.leases, identity, {}, &AllocationLease::id);
    return lease != state.leases.end() && lease->id == identity ? &*lease : nullptr;
}

/**
 * Finds immutable metadata by its monotonically assigned identity.
 */
auto FindResource(ArenaState &state, std::uint64_t identity) {
    return std::ranges::lower_bound(state.texts, identity, {}, &AuxiliaryResource::id);
}

/**
 *
 * Serializes arena identities and their live allocation provenance.
 *
 */
struct GenerationRegistry {
    std::mutex                                        mutex;  /**< Protects arena bindings and allocation identities. */
    std::unordered_map<const mgCMemory *, ArenaState> values; /**< State retained for each owner address. */
};

GenerationRegistry &Generations() {
    static GenerationRegistry registry;
    return registry;
}

/**
 *
 * Changes, under the registry mutex, before any change that can end an arena's storage or generation.
 *
 */
std::atomic<std::uint64_t> liveness_epoch{1};

void EndLivenessLocked() {
    liveness_epoch.fetch_add(1, std::memory_order_acq_rel);
}

/**
 *
 * One arena's liveness and generation, valid while neither the registry nor the root mappings have changed.
 *
 */
struct LivenessCacheEntry {
    const mgCMemory *memory = nullptr;       /**< Arena the entry describes. */
    std::uint64_t    epoch = 0;              /**< liveness_epoch when it was read. */
    std::uint64_t    mapping_epoch = 0;      /**< kz::arena::Epoch() when it was read. */
    bool             live = false;           /**< Whether its storage was live. */
    bool             has_generation = false; /**< Whether `generation` was read. */
    std::uint64_t    generation = 0;         /**< Its generation. */
};

/**
 *
 * The epochs a liveness result read under the registry mutex is valid for.
 *
 */
struct LivenessEpochs {
    std::uint64_t epoch;         /**< liveness_epoch. */
    std::uint64_t mapping_epoch; /**< kz::arena::Epoch(). */
};

LivenessEpochs CurrentLivenessEpochs() {
    return {.epoch = liveness_epoch.load(std::memory_order_acquire), .mapping_epoch = kz::arena::Epoch()};
}

LivenessCacheEntry &LivenessCacheSlot(const mgCMemory &memory) {
    thread_local std::array<LivenessCacheEntry, 64> cache;
    return cache[(reinterpret_cast<std::uintptr_t>(&memory) >> 4) % cache.size()];
}

bool LivenessCacheCurrent(const LivenessCacheEntry &entry) {
    const LivenessEpochs epochs = CurrentLivenessEpochs();
    return entry.epoch == epochs.epoch && entry.mapping_epoch == epochs.mapping_epoch;
}

void LivenessCacheStore(LivenessCacheEntry &entry, const mgCMemory &memory, const LivenessEpochs &epochs) {
    if (entry.memory != &memory || entry.epoch != epochs.epoch || entry.mapping_epoch != epochs.mapping_epoch) {
        entry = {.memory = &memory, .epoch = epochs.epoch, .mapping_epoch = epochs.mapping_epoch};
    }
}

/**
 *
 * Checks a binding's complete parent chain without dereferencing any arena owner.
 *
 */
bool StorageLiveLocked(const GenerationRegistry &registry, const mgCMemory *memory, std::size_t depth = 0) {
    const auto entry = registry.values.find(memory);
    if (entry == registry.values.end() || !entry->second.binding || depth > registry.values.size()) {
        return false;
    }
    const ArenaBinding &binding = *entry->second.binding;
    if (!kz::arena::IsLive(binding.root)) {
        return false;
    }
    if (binding.parent == nullptr) {
        return true;
    }
    const auto parent = registry.values.find(binding.parent);
    if (parent == registry.values.end() || parent->second.generation != binding.parent_generation ||
        !StorageLiveLocked(registry, binding.parent, depth + 1)) {
        return false;
    }
    const auto *lease = FindLease(parent->second, binding.parent_lease);
    return lease != nullptr && binding.start >= lease->start && binding.start - lease->start <= lease->bytes &&
           binding.bytes <= lease->bytes - static_cast<std::size_t>(binding.start - lease->start);
}

/**
 * Reports whether an operation renews the complete owner's generation.
 */
bool ResetsWholeOwner(const mgCMemory &memory, ArenaResetKind kind) {
    return kind == ArenaResetKind::Rebind || (memory.stack_block == nullptr && memory.heap_top == nullptr);
}

/**
 * Predicts the same allocation retirement performed by a stack reset without mutating the registry.
 */
bool LeaseRetiresOnReset(const GenerationRegistry &registry, const mgCMemory &memory,
                         std::uint64_t identity, ArenaResetKind kind) {
    if (ResetsWholeOwner(memory, kind)) {
        return true;
    }
    if (memory.stack_block == nullptr) {
        return false;
    }
    const auto entry = registry.values.find(&memory);
    if (entry == registry.values.end()) {
        return false;
    }
    const auto  begin = reinterpret_cast<std::uintptr_t>(memory.stack);
    const auto  bytes = static_cast<std::size_t>(std::max(0, memory.stack_size)) * sizeof(u_long128);
    const auto *lease = FindLease(entry->second, identity);
    return lease != nullptr && (lease->start == begin ||
                                (lease->start > begin ? lease->start - begin < bytes : begin - lease->start < lease->bytes));
}

/**
 * Follows only registered parent identities to predict a reset's effect on a live binding.
 */
bool BindingRetiresOnReset(const GenerationRegistry &registry, const mgCMemory *owner,
                           const mgCMemory &memory, ArenaResetKind kind) {
    for (std::size_t depth = 0; owner != nullptr && depth <= registry.values.size(); ++depth) {
        if (owner == &memory && ResetsWholeOwner(memory, kind)) {
            return true;
        }
        const auto entry = registry.values.find(owner);
        if (entry == registry.values.end() || !entry->second.binding) {
            return true;
        }
        const auto &binding = *entry->second.binding;
        if (binding.parent == &memory && LeaseRetiresOnReset(registry, memory, binding.parent_lease, kind)) {
            return true;
        }
        owner = binding.parent;
    }
    return owner != nullptr;
}

/**
 *
 * Checks that a byte range remains inside its captured arena extent.
 *
 */
bool RangeFits(const ArenaBinding &binding, const void *buffer, std::size_t bytes) {
    const auto address = reinterpret_cast<std::uintptr_t>(buffer);
    return address >= binding.start && address - binding.start <= binding.bytes &&
           bytes <= binding.bytes - static_cast<std::size_t>(address - binding.start);
}

/**
 *
 * Checks retained resources without recursively locking the registry.
 *
 */
bool LifetimeLiveLocked(const GenerationRegistry &registry, const AuxiliaryDependency &dependency) {
    const auto entry = registry.values.find(dependency.owner);
    if (entry == registry.values.end() || entry->second.generation != dependency.generation ||
        !StorageLiveLocked(registry, dependency.owner)) {
        return false;
    }
    const auto *block = FindLease(entry->second, dependency.heap_block);
    return dependency.heap_block == 0 || (block != nullptr && block->kind == LeaseKind::HeapBlock);
}

bool ResourceLiveLocked(const GenerationRegistry &registry, const AuxiliaryResource &text) {
    const auto logical = registry.values.find(text.owner);
    const auto backing = registry.values.find(text.backing);
    if (logical == registry.values.end() || backing == registry.values.end() ||
        logical->second.generation != text.generation || backing->second.generation != text.backing_generation ||
        !StorageLiveLocked(registry, text.owner) || !StorageLiveLocked(registry, text.backing) ||
        !RangeFits(*logical->second.binding, reinterpret_cast<const void *>(text.start), text.bytes)) {
        return false;
    }
    const auto *lease = FindLease(backing->second, text.allocation);
    return std::ranges::all_of(text.dependencies, [&registry](const AuxiliaryDependency &dependency) { return LifetimeLiveLocked(registry, dependency); }) &&
           lease != nullptr && text.start >= lease->start && text.start - lease->start < lease->bytes &&
           text.bytes <= lease->bytes - static_cast<std::size_t>(text.start - lease->start);
}

/**
 *
 * Collects an arena and every arena bound inside it, directly or through further bindings.
 *
 */
std::vector<const mgCMemory *> BoundArenasLocked(const GenerationRegistry &registry, const mgCMemory *changed) {
    std::vector<const mgCMemory *> arenas{changed};
    const auto                     contains = [&arenas](const mgCMemory *memory) { return std::ranges::find(arenas, memory) != arenas.end(); };
    for (bool grew = true; grew;) {
        grew = false;
        for (const auto &[owner, state] : registry.values) {
            if (state.binding && state.binding->parent != nullptr && contains(state.binding->parent) && !contains(owner)) {
                arenas.push_back(owner);
                grew = true;
            }
        }
    }
    return arenas;
}

/**
 *
 * Releases auxiliary resources whose allocation or ancestor retired with a change to one arena.
 *
 */
void PruneResourcesLocked(GenerationRegistry &registry, const mgCMemory &changed) {
    // A resource's liveness reads only its owner, backing and producer arenas and their binding chains, so
    // only resources naming an arena bound within the changed one can have retired.
    const auto arenas = BoundArenasLocked(registry, &changed);
    const auto affected = [&arenas](const mgCMemory *memory) { return std::ranges::find(arenas, memory) != arenas.end(); };
    for (auto &[owner, state] : registry.values) {
        static_cast<void>(owner);
        std::erase_if(state.texts, [&](const AuxiliaryResource &text) {
            const bool named = affected(text.owner) || affected(text.backing) ||
                               std::ranges::any_of(text.dependencies, [&](const AuxiliaryDependency &dependency) { return affected(dependency.owner); });
            return named && !ResourceLiveLocked(registry, text);
        });
    }
}

} // namespace

ArenaLifetime ArenaLifetime::Capture(const mgCMemory &memory) {
    ArenaLifetime                     result;
    auto                             &registry = Generations();
    const std::lock_guard             lock(registry.mutex);
    if (!StorageLiveLocked(registry, &memory)) {
        return result;
    }
    const auto &state = registry.values.find(&memory)->second;
    if (memory.heap_top != nullptr) {
        if (memory.stack_block == nullptr) {
            return result;
        }
        const auto start = reinterpret_cast<std::uintptr_t>(memory.stack);
        const auto block = std::ranges::find_if(state.leases, [start](const AllocationLease &lease) {
            return lease.kind == LeaseKind::HeapBlock && lease.start == start;
        });
        if (block == state.leases.end()) {
            return result;
        }
        result.heap_block = block->id;
    }
    result.owner = &memory;
    result.generation = state.generation;
    return result;
}

bool ArenaLifetime::IsLive() const {
    auto                             &registry = Generations();
    const std::lock_guard             lock(registry.mutex);
    const auto                        entry = registry.values.find(owner);
    if (entry == registry.values.end() || entry->second.generation != generation || !StorageLiveLocked(registry, owner)) {
        return false;
    }
    const auto *block = FindLease(entry->second, heap_block);
    return heap_block == 0 || (block != nullptr && block->kind == LeaseKind::HeapBlock);
}

bool ArenaLifetime::WouldRetireOnReset(const mgCMemory &memory, ArenaResetKind kind) const {
    auto                             &registry = Generations();
    const std::lock_guard             lock(registry.mutex);
    const auto                        entry = registry.values.find(owner);
    if (entry == registry.values.end() || entry->second.generation != generation ||
        !StorageLiveLocked(registry, owner)) {
        return false;
    }
    const auto *block = FindLease(entry->second, heap_block);
    if (heap_block != 0 && (block == nullptr || block->kind != LeaseKind::HeapBlock)) {
        return false;
    }
    return BindingRetiresOnReset(registry, owner, memory, kind) ||
           (owner == &memory && heap_block != 0 && LeaseRetiresOnReset(registry, memory, heap_block, kind));
}

std::uint64_t ArenaGeneration(const mgCMemory &memory) {
    LivenessCacheEntry &cached = LivenessCacheSlot(memory);
    if (cached.memory == &memory && cached.has_generation && LivenessCacheCurrent(cached)) {
        return cached.generation;
    }
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    const LivenessEpochs  epochs = CurrentLivenessEpochs();
    const std::uint64_t   generation = registry.values.try_emplace(&memory).first->second.generation;
    LivenessCacheStore(cached, memory, epochs);
    cached.has_generation = true;
    cached.generation = generation;
    return generation;
}

bool ArenaStorageLive(const mgCMemory &memory) {
    LivenessCacheEntry &cached = LivenessCacheSlot(memory);
    if (cached.memory == &memory && cached.live && LivenessCacheCurrent(cached)) {
        return true;
    }
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    const LivenessEpochs  epochs = CurrentLivenessEpochs();
    const bool            live = StorageLiveLocked(registry, &memory);
    LivenessCacheStore(cached, memory, epochs);
    cached.live = live;
    return live;
}

namespace {

/**
 *
 * Detaches the storage provenance of an initialized or destroyed owner.
 *
 */
void ForgetArenaBinding(const mgCMemory &memory) {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    EndLivenessLocked();
    registry.values[&memory].binding.reset();
    PruneResourcesLocked(registry, memory);
}

/**
 *
 * Preserves a live self binding only within its previous extent.
 *
 */
std::optional<ArenaBinding> RebindProof(const mgCMemory &memory, const void *buffer, std::size_t bytes) {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    const auto            entry = registry.values.find(&memory);
    if (!StorageLiveLocked(registry, &memory) || !RangeFits(*entry->second.binding, buffer, bytes)) {
        return std::nullopt;
    }
    auto binding = *entry->second.binding;
    binding.start = reinterpret_cast<std::uintptr_t>(buffer);
    binding.bytes = bytes;
    return binding;
}

/**
 *
 * Identifies a requested address inside this owner's previous binding.
 *
 */
bool SelfContains(const mgCMemory &memory, const void *buffer) {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    const auto            entry = registry.values.find(&memory);
    return entry != registry.values.end() && entry->second.binding &&
           RangeFits(*entry->second.binding, buffer, 0);
}

/**
 *
 * Binds a child range to one exact live allocation of its explicit parent.
 *
 */
std::optional<ArenaBinding> ChildProof(const mgCMemory &parent, const void *buffer, std::size_t bytes) {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    const auto            entry = registry.values.find(&parent);
    if (!StorageLiveLocked(registry, &parent)) {
        return std::nullopt;
    }
    const auto address = reinterpret_cast<std::uintptr_t>(buffer);
    for (auto lease = entry->second.leases.rbegin(); lease != entry->second.leases.rend(); ++lease) {
        if (lease->kind != LeaseKind::BorrowedView && address >= lease->start && address - lease->start < lease->bytes &&
            bytes <= lease->bytes - static_cast<std::size_t>(address - lease->start)) {
            return ArenaBinding{.root = entry->second.binding->root,
                                .parent = &parent,
                                .parent_generation = entry->second.generation,
                                .parent_lease = lease->id,
                                .start = address,
                                .bytes = bytes};
        }
    }
    return std::nullopt;
}

/**
 *
 * Registers an explicitly shared view within its logical owner's live stack.
 *
 */
std::optional<ArenaBinding> BorrowProof(const mgCMemory &parent, const void *buffer, std::size_t bytes) {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    auto                 &entry = registry.values[&parent];
    if (!StorageLiveLocked(registry, &parent) || parent.stack == nullptr || parent.stack_size < 0 ||
        !RangeFits(*entry.binding, buffer, bytes)) {
        return std::nullopt;
    }
    const auto address = reinterpret_cast<std::uintptr_t>(buffer);
    const auto stack_begin = reinterpret_cast<std::uintptr_t>(parent.stack);
    const auto stack_bytes = static_cast<std::size_t>(parent.stack_size) * sizeof(u_long128);
    if (address < stack_begin || address - stack_begin > stack_bytes ||
        bytes > stack_bytes - static_cast<std::size_t>(address - stack_begin) ||
        entry.next_lease == std::numeric_limits<std::uint64_t>::max()) {
        return std::nullopt;
    }
    const auto lease_id = entry.next_lease++;
    entry.leases.push_back({address, bytes, lease_id, LeaseKind::BorrowedView});
    return ArenaBinding{.root = entry.binding->root,
                        .parent = &parent,
                        .parent_generation = entry.generation,
                        .parent_lease = lease_id,
                        .start = address,
                        .bytes = bytes,
                        .role = BindingRole::SharedView};
}

/**
 *
 * Checks a canonical root binding against the platform mapping's actual extent.
 *
 */
std::optional<ArenaBinding> RootProof(const void *buffer, std::size_t bytes) {
    const auto region = kz::arena::RegionFor(buffer);
    if (!region || buffer != region->root) {
        return std::nullopt;
    }
    ArenaBinding binding{.root = *region,
                         .start = reinterpret_cast<std::uintptr_t>(region->writable.data()),
                         .bytes = region->writable.size()};
    if (!RangeFits(binding, buffer, bytes)) {
        return std::nullopt;
    }
    binding.start = reinterpret_cast<std::uintptr_t>(buffer);
    binding.bytes = bytes;
    return binding;
}

/**
 *
 * Rebinds an explicitly cleared root without reviving a stale child lease.
 *
 */
std::optional<ArenaBinding> RenewRootProof(const mgCMemory &memory, const void *buffer, std::size_t bytes) {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    const auto            entry = registry.values.find(&memory);
    if (entry == registry.values.end() || !entry->second.binding || entry->second.binding->parent != nullptr) {
        return std::nullopt;
    }
    const auto root = RootProof(buffer, bytes);
    if (!root || root->root.generation == entry->second.binding->root.generation) {
        return std::nullopt;
    }
    return root;
}

/**
 *
 * Rejects a backing relationship that would make an arena depend on itself.
 *
 */
bool BindingIndependentOf(const ArenaBinding &binding, const mgCMemory &memory) {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    const mgCMemory      *parent = binding.parent;
    for (std::size_t depth = 0; parent != nullptr && depth <= registry.values.size(); ++depth) {
        if (parent == &memory) {
            return false;
        }
        const auto entry = registry.values.find(parent);
        if (entry == registry.values.end() || !entry->second.binding) {
            return false;
        }
        parent = entry->second.binding->parent;
    }
    return parent == nullptr;
}

/**
 *
 * Shares the backing of an explicit cursor view while preserving genuine allocation-owner lifetimes.
 *
 */
std::optional<ArenaBinding> ShareProof(const mgCMemory &source, std::span<u_long128> storage) {
    if (source.stack == nullptr || source.stack_size <= 0 || source.stack_used < 0 ||
        source.stack_used > source.stack_size || storage.empty()) {
        return std::nullopt;
    }
    const auto begin = reinterpret_cast<std::uintptr_t>(source.stack);
    const auto address = reinterpret_cast<std::uintptr_t>(storage.data());
    const auto capacity = static_cast<std::size_t>(source.stack_size) * sizeof(u_long128);
    if (address < begin || address - begin > capacity || storage.size_bytes() > capacity - (address - begin)) {
        return std::nullopt;
    }
    auto binding = RebindProof(source, storage.data(), storage.size_bytes());
    if (!binding) {
        return std::nullopt;
    }
    if (binding->role == BindingRole::SharedView && source.stack_block == nullptr) {
        return binding;
    }
    return BorrowProof(source, storage.data(), storage.size_bytes());
}

/**
 *
 * Stores the validated backing relationship for a newly bound arena.
 *
 */
void InstallArenaBinding(const mgCMemory &memory, ArenaBinding binding) {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    EndLivenessLocked();
    registry.values[&memory].binding = binding;
    PruneResourcesLocked(registry, memory);
}

} // namespace

void InvalidateArenaGeneration(const mgCMemory &memory) {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    EndLivenessLocked();
    if (const auto it = registry.values.find(&memory); it != registry.values.end()) {
        if (it->second.generation == std::numeric_limits<std::uint64_t>::max()) {
            std::abort();
        }
        ++it->second.generation;
        it->second.leases.clear();
        PruneResourcesLocked(registry, memory);
    }
}

namespace {

/**
 *
 * Assigns a unique identity to each allocation or active heap block.
 *
 */
void RecordArenaAllocation(const mgCMemory &memory, const void *start, std::size_t bytes, LeaseKind kind = LeaseKind::Allocation) {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    auto                 &state = registry.values[&memory];
    if (state.next_lease == std::numeric_limits<std::uint64_t>::max()) {
        std::abort();
    }
    state.leases.push_back({reinterpret_cast<std::uintptr_t>(start), bytes, state.next_lease++, kind});
}

/**
 *
 * Retires allocations and shared views contained in a released heap block.
 *
 */
void RetireArenaRange(const mgCMemory &memory, const void *start, std::size_t bytes) {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    EndLivenessLocked();
    auto                 &leases = registry.values[&memory].leases;
    const auto            begin = reinterpret_cast<std::uintptr_t>(start);
    std::erase_if(leases, [begin, bytes](const AllocationLease &lease) {
        return lease.start == begin ||
               (lease.start > begin ? lease.start - begin < bytes : begin - lease.start < lease.bytes);
    });
    PruneResourcesLocked(registry, memory);
}

/**
 *
 * Shrinks a completed heap block and retires views extending beyond it.
 *
 */
void ResizeHeapBlock(const mgCMemory &memory, const void *start, std::size_t bytes) {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    EndLivenessLocked();
    auto                 &leases = registry.values[&memory].leases;
    const auto            address = reinterpret_cast<std::uintptr_t>(start);
    std::size_t           old_bytes = 0;
    for (auto lease = leases.rbegin(); lease != leases.rend(); ++lease) {
        if (lease->kind == LeaseKind::HeapBlock && lease->start == address) {
            old_bytes = lease->bytes;
            lease->bytes = bytes;
            break;
        }
    }
    std::erase_if(leases, [address, bytes, old_bytes](const AllocationLease &lease) {
        return lease.kind != LeaseKind::HeapBlock && lease.start >= address && lease.start - address < old_bytes &&
               (lease.start - address > bytes || lease.bytes > bytes - static_cast<std::size_t>(lease.start - address));
    });
    PruneResourcesLocked(registry, memory);
}

} // namespace

void ResetArenaStack(const mgCMemory &memory) {
    ::ForgetRun(&memory);
    if (memory.stack_block == nullptr) {
        if (memory.heap_top == nullptr) {
            InvalidateArenaGeneration(memory);
        }
    } else {
        RetireArenaRange(memory, memory.stack, static_cast<std::size_t>(std::max(0, memory.stack_size)) * sizeof(u_long128));
        RecordArenaAllocation(memory, memory.stack,
                              static_cast<std::size_t>(std::max(0, memory.stack_size)) * sizeof(u_long128), LeaseKind::HeapBlock);
    }
}

namespace {

void GrowArenaAllocation(const mgCMemory &memory, const void *start, std::size_t bytes) {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    auto                 &leases = registry.values[&memory].leases;
    for (auto lease = leases.rbegin(); lease != leases.rend(); ++lease) {
        if (lease->kind == LeaseKind::Allocation && lease->start == reinterpret_cast<std::uintptr_t>(start)) {
            lease->bytes = bytes;
            return;
        }
    }
}

} // namespace

std::span<u8> AllocationBytes(const mgCMemory &memory, const void *pointer) {
    if (pointer == nullptr) {
        return {};
    }
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    const auto            it = registry.values.find(&memory);
    if (it == registry.values.end() || !StorageLiveLocked(registry, &memory)) {
        return {};
    }
    const std::uintptr_t address = reinterpret_cast<std::uintptr_t>(pointer);
    for (auto lease = it->second.leases.rbegin(); lease != it->second.leases.rend(); ++lease) {
        if (lease->kind != LeaseKind::BorrowedView && address >= lease->start && address - lease->start < lease->bytes) {
            return {static_cast<u8 *>(const_cast<void *>(pointer)),
                    lease->bytes - (address - lease->start)};
        }
    }
    return {};
}

bool ArenaBuffer::Retain(std::shared_ptr<const void> resource) const {
    if (!resource) {
        return false;
    }
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    AuxiliaryResource     candidate{owner, backing_owner, owner_generation, backing_generation, allocation, reinterpret_cast<std::uintptr_t>(storage.data()), storage.size(), 0, {}, resource, nullptr, {}};
    if (!ResourceLiveLocked(registry, candidate)) {
        return false;
    }
    auto &state = registry.values.at(backing_owner);
    for (const auto &existing : state.texts) {
        if (existing.owner == candidate.owner && existing.generation == candidate.generation &&
            existing.backing == candidate.backing && existing.backing_generation == candidate.backing_generation &&
            existing.allocation == candidate.allocation && existing.start == candidate.start &&
            existing.bytes == candidate.bytes && existing.resource == resource) {
            return true;
        }
    }
    state.texts.push_back(std::move(candidate));
    return true;
}

ArenaResource ArenaResource::StoreErased(const ArenaBuffer &anchor, std::shared_ptr<const void> value,
                                         const void *type, std::span<const ArenaLifetime> dependencies) {
    if (!value) {
        return {};
    }
    auto                             &registry = Generations();
    const std::lock_guard             lock(registry.mutex);
    AuxiliaryResource                 candidate{anchor.owner, anchor.backing_owner, anchor.owner_generation, anchor.backing_generation, anchor.allocation, reinterpret_cast<std::uintptr_t>(anchor.storage.data()), anchor.storage.size(), 0, {}, std::move(value), type, {}};
    for (const auto &dependency : dependencies) {
        candidate.dependencies.push_back({dependency.owner, dependency.generation, dependency.heap_block});
    }
    if (!ResourceLiveLocked(registry, candidate)) {
        return {};
    }
    auto &state = registry.values.at(anchor.backing_owner);
    if (state.next_text == std::numeric_limits<std::uint64_t>::max()) {
        std::abort();
    }
    candidate.id = state.next_text++;
    ArenaResource result;
    result.owner = anchor.backing_owner;
    result.resource = candidate.id;
    state.texts.push_back(std::move(candidate));
    return result;
}

std::shared_ptr<const void> ArenaResource::AcquireErased(const void *type) const {
    auto                             &registry = Generations();
    const std::lock_guard             lock(registry.mutex);
    const auto                        state = registry.values.find(owner);
    if (state == registry.values.end()) {
        return {};
    }
    const auto entry = FindResource(state->second, resource);
    if (entry == state->second.texts.end() || entry->id != resource) {
        return {};
    }
    if (!ResourceLiveLocked(registry, *entry)) {
        state->second.texts.erase(entry);
        return {};
    }
    return entry->type == type ? entry->resource : nullptr;
}

bool ArenaResource::IsLive() const {
    auto                             &registry = Generations();
    const std::lock_guard             lock(registry.mutex);
    const auto                        state = registry.values.find(owner);
    if (state == registry.values.end()) {
        return false;
    }
    const auto entry = FindResource(state->second, resource);
    return entry != state->second.texts.end() && entry->id == resource && entry->type != nullptr && ResourceLiveLocked(registry, *entry);
}

bool ArenaResource::WouldRetireOnReset(const mgCMemory &memory, ArenaResetKind kind) const {
    auto                             &registry = Generations();
    const std::lock_guard             lock(registry.mutex);
    const auto                        state = registry.values.find(owner);
    if (state == registry.values.end()) {
        return false;
    }
    for (const auto &entry : state->second.texts) {
        if (entry.id != resource || entry.type == nullptr || !ResourceLiveLocked(registry, entry)) {
            continue;
        }
        if (BindingRetiresOnReset(registry, entry.owner, memory, kind) ||
            BindingRetiresOnReset(registry, entry.backing, memory, kind) ||
            (entry.backing == &memory && LeaseRetiresOnReset(registry, memory, entry.allocation, kind))) {
            return true;
        }
        return std::ranges::any_of(entry.dependencies, [&registry, &memory, kind](const AuxiliaryDependency &dependency) {
            return BindingRetiresOnReset(registry, dependency.owner, memory, kind) ||
                   (dependency.owner == &memory && dependency.heap_block != 0 && LeaseRetiresOnReset(registry, memory, dependency.heap_block, kind));
        });
    }
    return false;
}

ArenaText ArenaText::Copy(const ArenaBuffer &anchor, std::string_view text) {
    ArenaText             result;
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    AuxiliaryResource     candidate{anchor.owner, anchor.backing_owner, anchor.owner_generation, anchor.backing_generation, anchor.allocation, reinterpret_cast<std::uintptr_t>(anchor.storage.data()), anchor.storage.size(), 0, {}, {}, nullptr, {}};
    if (!ResourceLiveLocked(registry, candidate)) {
        return result;
    }
    auto &state = registry.values.at(anchor.backing_owner);
    for (const auto &existing : state.texts) {
        if (existing.owner == candidate.owner && existing.generation == candidate.generation &&
            existing.backing == candidate.backing && existing.backing_generation == candidate.backing_generation &&
            existing.allocation == candidate.allocation && existing.start == candidate.start &&
            existing.bytes == candidate.bytes && existing.text && *existing.text == text) {
            result.owner = anchor.backing_owner;
            result.resource = existing.id;
            return result;
        }
    }
    if (state.next_text == std::numeric_limits<std::uint64_t>::max()) {
        std::abort();
    }
    candidate.id = state.next_text++;
    candidate.text = std::make_unique<const std::string>(text);
    result.owner = anchor.backing_owner;
    result.resource = candidate.id;
    state.texts.push_back(std::move(candidate));
    return result;
}

std::optional<std::string_view> ArenaText::Text() const {
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    const auto            state = registry.values.find(owner);
    if (state == registry.values.end()) {
        return std::nullopt;
    }
    const auto text = FindResource(state->second, resource);
    if (text != state->second.texts.end() && text->id == resource && text->text && ResourceLiveLocked(registry, *text)) {
        return *text->text;
    }
    return std::nullopt;
}

ArenaBuffer ArenaBuffer::Bind(mgCMemory &logical_owner, std::span<u8> storage, mgCMemory *backing) {
    ArenaBuffer result;
    if (storage.empty()) {
        return result;
    }
    const mgCMemory      *source_owner = backing != nullptr ? backing : &logical_owner;
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    if (!StorageLiveLocked(registry, &logical_owner) || !StorageLiveLocked(registry, source_owner)) {
        return result;
    }
    const auto logical = registry.values.find(&logical_owner);
    const auto source = registry.values.find(source_owner);
    if (!RangeFits(*logical->second.binding, storage.data(), storage.size())) {
        return result;
    }
    const auto address = reinterpret_cast<std::uintptr_t>(storage.data());
    for (auto lease = source->second.leases.rbegin(); lease != source->second.leases.rend(); ++lease) {
        if (lease->kind != LeaseKind::BorrowedView && address >= lease->start && address - lease->start < lease->bytes &&
            storage.size() <= lease->bytes - static_cast<std::size_t>(address - lease->start)) {
            result.owner = &logical_owner;
            result.backing_owner = source_owner;
            result.owner_generation = logical->second.generation;
            result.backing_generation = source->second.generation;
            result.allocation = lease->id;
            result.storage = storage;
            break;
        }
    }
    return result;
}

bool ArenaBuffer::SameIdentity(const ArenaBuffer &other) const noexcept {
    return owner == other.owner && backing_owner == other.backing_owner && owner_generation == other.owner_generation &&
           backing_generation == other.backing_generation && allocation == other.allocation &&
           storage.data() == other.storage.data() && storage.size() == other.storage.size();
}

std::span<u8> ArenaBuffer::Bytes() const {
    if (storage.empty()) {
        return {};
    }
    auto                 &registry = Generations();
    const std::lock_guard lock(registry.mutex);
    const auto            logical = registry.values.find(owner);
    const auto            source = registry.values.find(backing_owner);
    if (logical == registry.values.end() || source == registry.values.end() ||
        logical->second.generation != owner_generation || source->second.generation != backing_generation ||
        !StorageLiveLocked(registry, owner) || !StorageLiveLocked(registry, backing_owner) ||
        !RangeFits(*logical->second.binding, storage.data(), storage.size())) {
        return {};
    }
    const auto  address = reinterpret_cast<std::uintptr_t>(storage.data());
    const auto *lease = FindLease(source->second, allocation);
    if (lease != nullptr && address >= lease->start && address - lease->start < lease->bytes &&
        storage.size() <= lease->bytes - static_cast<std::size_t>(address - lease->start)) {
        return storage;
    }
    return {};
}

bool ArenaBuffer::WouldRetireOnReset(const mgCMemory &memory, ArenaResetKind kind) const {
    if (storage.empty()) {
        return false;
    }
    auto                             &registry = Generations();
    const std::lock_guard             lock(registry.mutex);
    const auto                        logical = registry.values.find(owner);
    const auto                        source = registry.values.find(backing_owner);
    if (logical == registry.values.end() || source == registry.values.end() ||
        logical->second.generation != owner_generation || source->second.generation != backing_generation ||
        !StorageLiveLocked(registry, owner) || !StorageLiveLocked(registry, backing_owner) ||
        !RangeFits(*logical->second.binding, storage.data(), storage.size())) {
        return false;
    }
    const auto  address = reinterpret_cast<std::uintptr_t>(storage.data());
    const auto *exact = FindLease(source->second, allocation);
    if (exact == nullptr || address < exact->start || address - exact->start >= exact->bytes ||
        storage.size() > exact->bytes - static_cast<std::size_t>(address - exact->start)) {
        return false;
    }
    return BindingRetiresOnReset(registry, owner, memory, kind) ||
           BindingRetiresOnReset(registry, backing_owner, memory, kind) ||
           (backing_owner == &memory && LeaseRetiresOnReset(registry, memory, allocation, kind));
}

ArenaBuffer ArenaBuffer::Subspan(std::size_t offset, std::size_t count) const {
    const auto live = Bytes();
    if (offset > live.size() || count > live.size() - offset) {
        return {};
    }
    ArenaBuffer result = *this;
    result.storage = live.subspan(offset, count);
    return result;
}

} // namespace dc2::memory

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
    mgCMemory    *arena = nullptr;
    u_long128    *start = nullptr;
    int           quadwords = 0;
    std::uint64_t generation = 0;
};

LastRun g_last_run;

/**
 *
 * Captures the immediate allocating owner, an existing self binding, or an actual root extent.
 *
 */
std::optional<dc2::memory::ArenaBinding> BindingProof(const mgCMemory &memory, const void *buffer, std::size_t bytes) {
    if (g_last_run.arena != nullptr && g_last_run.arena != &memory && g_last_run.start == buffer &&
        g_last_run.generation == dc2::memory::ArenaGeneration(*g_last_run.arena)) {
        const auto binding = dc2::memory::ChildProof(*g_last_run.arena, buffer, bytes);
        if (!binding) {
            std::println(stderr, "child arena extent {} exceeds allocated {} quadwords", bytes / sizeof(u_long128),
                         g_last_run.quadwords);
        }
        return binding;
    }
    if (auto binding = dc2::memory::RebindProof(memory, buffer, bytes)) {
        return binding;
    }
    if (dc2::memory::SelfContains(memory, buffer)) {
        if (dc2::memory::ArenaStorageLive(memory)) {
            std::println(stderr, "arena rebind extent {} exceeds current root", bytes / sizeof(u_long128));
        } else if (auto renewed = dc2::memory::RenewRootProof(memory, buffer, bytes)) {
            return renewed;
        }
        return std::nullopt;
    }
    return dc2::memory::RootProof(buffer, bytes);
}

/**
 *
 * Stops an invalid arena binding before it can access unowned storage.
 *
 */
[[noreturn]] void InvalidBinding(int size) {
    std::println(stderr, "arena binding extent {} has no live source allocation", size);
    std::abort();
}

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

/**
 * Invalidates motion data in arena storage before a new allocation or block header overwrites it.
 */
void Reuse(const void *start, std::ptrdiff_t quadwords) {
    if (quadwords > 0) {
        character_motion::ForgetStorage(start, QuadwordsFrom(start, quadwords));
    }
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
    PeakEntry  fresh{.memory = memory, .heap = heap, .capacity = capacity, .peak = 0, .name = {}};
    std::memcpy(fresh.name.data(), memory->name, sizeof(memory->name));

    if (entry == nullptr) {
        PeakTable().push_back(fresh);
    } else {
        *entry = fresh;
    }
}

/**
 *
 * Attaches a standalone stack after detaching heap state from the previous binding.
 *
 */
void CommitStackBinding(mgCMemory &memory, u_long128 *buffer, int size) {
    memory.heap = nullptr;
    memory.heap_top = nullptr;
    memory.heap_size = 0;
    memory.stack_block = nullptr;
    memory.stack = buffer;
    memory.stack_used = 0;
    memory.stack_size = size;
    ResetPeak(&memory, false, size);
}

int HeapAllocatedQuadwords(const mgCMemory &memory) {
    if (memory.heap_top == nullptr || !dc2::memory::ArenaStorageLive(memory)) {
        return 0;
    }

    long long total = 0;

    for (const mgMEMORY_BLOCK *block = memory.heap_top->next; block->next != nullptr; block = block->next) {
        // The active stack block keeps size at its header until EndStackMode folds stack_used in.
        total += static_cast<long long>(block->size) + (block == memory.stack_block ? memory.stack_used : 0);
    }

    return static_cast<int>(std::min(total, static_cast<long long>(INT_MAX)));
}

void NotePeak(const mgCMemory &memory) {
    PeakEntry *entry = FindPeak(&memory);

    if (entry == nullptr) {
        return;
    }

    const int used = entry->heap ? HeapAllocatedQuadwords(memory) : memory.stack_used;

    entry->peak = std::max(used, entry->peak);
}

[[noreturn]] void Overflow(const mgCMemory &memory, long long used) {
    const int clamped = used > INT_MAX ? INT_MAX : static_cast<int>(used);

    if (memory.name[0] != '\0') {
        const NameCopy name = CopyName(memory.name);
        ArenaOverflow(name.data(), clamped, memory.stack_size);
    }

    ArenaOverflow(static_cast<const void *>(&memory), clamped, memory.stack_size);
}

/**
 * Whether memory an arena hands out again still holds what the game left there.
 */
enum class Contents {
    Released, /**< Handed out for new data. */
    Kept,     /**< Reserved again by its owner, which goes on using what it holds. */
};

u_long128 *AllocQuadwords(mgCMemory &memory, int size, Contents contents = Contents::Released) {
    if (memory.lock != 0 || size <= 0 || memory.stack == nullptr || memory.stack_size <= 0 ||
        memory.stack_used < 0 || memory.stack_used > memory.stack_size || !dc2::memory::ArenaStorageLive(memory)) {
        return nullptr;
    }

    // Summed in 64 bits so a huge request fails the capacity check instead of wrapping past it.
    const long long new_used = static_cast<long long>(memory.stack_used) + size;

    if (new_used >= memory.stack_size) {
        Overflow(memory, new_used);
    }

    u_long128 *data = QuadwordsFrom(memory.stack, memory.stack_used);
    memory.stack_used = static_cast<int>(new_used);
    g_last_run = {.arena = &memory, .start = data, .quadwords = size, .generation = dc2::memory::ArenaGeneration(memory)};
    dc2::memory::RecordArenaAllocation(memory, data, static_cast<std::size_t>(size) * sizeof(u_long128));
    if (contents == Contents::Released) {
        Reuse(data, size);
    }
    NotePeak(memory);
    return data;
}

void GrowLastRun(const u_long128 *buffer, std::size_t bytes) {
    LastRun &run = g_last_run;

    if (run.arena == nullptr || run.start != buffer ||
        run.generation != dc2::memory::ArenaGeneration(*run.arena) ||
        dc2::memory::AllocationBytes(*run.arena, buffer).size() <
            static_cast<std::size_t>(run.quadwords) * sizeof(u_long128)) {
        return;
    }

    mgCMemory &memory = *run.arena;
    if (bytes > static_cast<std::size_t>(INT_MAX) * kQuadwordBytes) {
        Overflow(memory, INT_MAX);
    }
    const int quadwords = static_cast<int>(bytes / kQuadwordBytes + (bytes % kQuadwordBytes != 0));

    if (quadwords <= run.quadwords ||
        QuadwordsFrom(run.start, run.quadwords) != QuadwordsFrom(memory.stack, memory.stack_used)) {
        return;
    }

    const long long new_used = static_cast<long long>(memory.stack_used) + (quadwords - run.quadwords);

    if (new_used >= memory.stack_size) {
        Overflow(memory, new_used);
    }

    Reuse(QuadwordsFrom(run.start, run.quadwords), quadwords - run.quadwords);
    memory.stack_used = static_cast<int>(new_used);
    run.quadwords = quadwords;
    dc2::memory::GrowArenaAllocation(memory, run.start,
                                     static_cast<std::size_t>(quadwords) * sizeof(u_long128));
    NotePeak(memory);
}

void AlignStack(mgCMemory &memory) {
    if (memory.lock || memory.stack == nullptr || memory.stack_used < 0 || memory.stack_used >= memory.stack_size ||
        !dc2::memory::ArenaStorageLive(memory)) {
        return;
    }

    // Quadword-aligned on both hosts, so the misalignment is a multiple of 16 and the step is exact.
    const std::uintptr_t misalign = AddressOf(QuadwordsFrom(memory.stack, memory.stack_used)) & 0x3F;

    if (misalign != 0) {
        memory.stack_used = static_cast<int>(std::min(static_cast<long long>(memory.stack_used) +
                                                          static_cast<int>(64 - misalign) / 16,
                                                      static_cast<long long>(memory.stack_size)));
    }

    memory.stack_used = std::min(memory.stack_used, memory.stack_size);

    NotePeak(memory);
}

} // namespace

mgCMemory::~mgCMemory() {
    dc2::memory::InvalidateArenaGeneration(*this);
    dc2::memory::ForgetArenaBinding(*this);
    ForgetRun(this);
}

void *MG_ADDRESS_CHECK(void *address, char *where) {
    if (address == nullptr) {
        dc2::log::PrintGame("stack over at %s\n", where != nullptr ? where : "?");
    }
    return address;
}

void mgCMemory::Init() {
    dc2::memory::InvalidateArenaGeneration(*this);
    dc2::memory::ForgetArenaBinding(*this);
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

void mgCMemory::SetHeapMem(u_long128 *buffer, int size) {
    if (buffer != nullptr && reinterpret_cast<std::uintptr_t>(buffer) % alignof(u_long128) != 0) {
        InvalidBinding(size);
    }

    if (buffer != nullptr && size >= 0x10 && !ArenaContains(buffer)) {
        if (size > INT_MAX / kArenaHeadroom) {
            Overflow(*this, static_cast<long long>(size) * kArenaHeadroom);
        }
        const NameCopy label = CopyName(name);
        u_long128     *block = ArenaRoot(buffer, size, label.data());
        // Binding the same buffer again maps the same root, so the copy lands on whatever the heap held.
        Reuse(block, size);
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

    auto binding = BindingProof(*this, buffer, static_cast<std::size_t>(size) * sizeof(u_long128));
    if (!binding || !dc2::memory::BindingIndependentOf(*binding, *this)) {
        InvalidBinding(size);
    }
    binding->role = dc2::memory::BindingRole::Owner;
    dc2::memory::InvalidateArenaGeneration(*this);
    dc2::memory::InstallArenaBinding(*this, *binding);
    ForgetRun(this);
    stack = nullptr;
    stack_size = 0;
    stack_used = 0;
    stack_block = nullptr;
    Reuse(buffer, kHeaderQuadwords);
    Reuse(BlockAt(buffer, size - kHeaderQuadwords), kHeaderQuadwords);
    heap = buffer;
    heap_size = static_cast<u_int>(size);
    heap_top = std::construct_at(reinterpret_cast<mgMEMORY_BLOCK *>(buffer));
    heap_top->data = nullptr;
    heap_top->size = kHeaderQuadwords;
    heap_top->next = std::construct_at(BlockAt(buffer, static_cast<std::ptrdiff_t>(heap_size) - kHeaderQuadwords));
    heap_top->next->data = nullptr;
    heap_top->next->size = 0;
    heap_top->next->next = nullptr;
    ResetPeak(this, true, size);
}

void mgCMemory::ClearHeapMem() {
    u_long128  *buffer = heap;
    const u_int size = heap_size;

    lock = 0;
    SetHeapMem(buffer, static_cast<int>(size));
}

void mgCMemory::Free(u_long128 *data) {
    if (data == nullptr || heap_top == nullptr || !dc2::memory::ArenaStorageLive(*this)) {
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
        CT_LOG_CRITICAL(Memory, "Illegal Free Memory {}", static_cast<void *>(data));
        LogFlush();
        std::abort();
    }

    const auto released_quads = found == stack_block ? static_cast<std::size_t>(stack_size)
                                                     : static_cast<std::size_t>(found->size) - kHeaderQuadwords;
    dc2::memory::RetireArenaRange(*this, found->data, released_quads * sizeof(u_long128));
    prev->next = found->next;
    if (found == stack_block) {
        stack_block = nullptr;
        stack = nullptr;
        stack_size = 0;
        stack_used = 0;
    }
    ForgetRun(this);
}

u_long128 *mgCMemory::StartStackMode(int mode, int size) {
    if (lock != 0 || !dc2::memory::ArenaStorageLive(*this)) {
        return nullptr;
    }
    ForgetRun(this);
    stack_block = nullptr;
    mgMEMORY_BLOCK *block = heap_top;

    if (block == nullptr) {
        return nullptr;
    }

    mgMEMORY_BLOCK *chosen = nullptr;
    mgMEMORY_BLOCK *chosen_previous = nullptr;
    std::ptrdiff_t  chosen_count = 0;
    std::ptrdiff_t  best_count = 0;

    for (mgMEMORY_BLOCK *next = nullptr; (next = block->next) != nullptr; block = next) {
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

        if (mode == 3 && static_cast<long long>(size) + kHeaderQuadwords < count) {
            chosen = gap;
            chosen_previous = block;
            chosen_count = count;
            break;
        }
    }

    if (chosen == nullptr) {
        return nullptr;
    }

    Reuse(chosen, kHeaderQuadwords);
    // Sized from the chosen gap. Retail sizes it from the last gap examined, so mode 2 can run the
    // stack region past the end of the gap it claimed and over the next header.
    stack_block = std::construct_at(chosen);
    stack_block->next = chosen_previous->next;
    chosen_previous->next = stack_block;
    stack_block->size = kHeaderQuadwords;
    stack_block->data = QuadwordsFrom(stack_block, kHeaderQuadwords);
    stack = stack_block->data;
    stack_size = static_cast<int>(chosen_count - kHeaderQuadwords);
    stack_used = 0;
    dc2::memory::RecordArenaAllocation(*this, stack, static_cast<std::size_t>(stack_size) * sizeof(u_long128), dc2::memory::LeaseKind::HeapBlock);
    NotePeak(*this);
    return stack_block->data;
}

void mgCMemory::EndStackMode() {
    ForgetRun(this);
    if (stack_block != nullptr) {
        if (dc2::memory::ArenaStorageLive(*this)) {
            const auto count = static_cast<u_int>(stack_used);
            dc2::memory::ResizeHeapBlock(*this, stack, static_cast<std::size_t>(count) * sizeof(u_long128));
            stack_block->size += count;
        }
        stack_block = nullptr;
        stack = nullptr;
        stack_size = 0;
        stack_used = 0;
    }
}

u_long128 *mgCMemory::stAllocTest(int size) {
    if (lock || size <= 0 || stack == nullptr || stack_used < 0 || stack_used > stack_size ||
        !dc2::memory::ArenaStorageLive(*this)) {
        return nullptr;
    }

    const long long new_used = static_cast<long long>(stack_used) + size;

    if (new_used >= stack_size) {
        std::println("stack over {}/{} at {:.16}", new_used, stack_size, name);
        return nullptr;
    }

    return QuadwordsFrom(stack, stack_used);
}

u_long128 *mgCMemory::stAlloc(int size) {
    return AllocQuadwords(*this, size);
}

u_long128 *mgCMemory::stAlloc64(int size) {
    stAlign64();
    return stAlloc(size);
}

u_long128 *mgCMemory::Alloc(int size) {
    return AllocQuadwords(*this, size);
}

void mgCMemory::stAlign64() {
    AlignStack(*this);
}

void mgCMemory::Align64() {
    AlignStack(*this);
}

void mgCMemory::stSetBuffer(u_long128 *buffer, int size) {
    if (buffer != nullptr && reinterpret_cast<std::uintptr_t>(buffer) % alignof(u_long128) != 0) {
        InvalidBinding(size);
    }
    if (buffer == nullptr || size <= 0) {
        dc2::memory::InvalidateArenaGeneration(*this);
        dc2::memory::ForgetArenaBinding(*this);
        ForgetRun(this);
        CommitStackBinding(*this, nullptr, 0);
        return;
    }
    if (!ArenaContains(buffer)) {
        if (size > INT_MAX / kArenaHeadroom) {
            Overflow(*this, static_cast<long long>(size) * kArenaHeadroom);
        }
        const NameCopy label = CopyName(name);
        buffer = ArenaRootFromBuffer(buffer, size, label.data());
        size *= kArenaHeadroom;
    }
    const auto binding = BindingProof(*this, buffer, static_cast<std::size_t>(size) * sizeof(u_long128));
    if (!binding || !dc2::memory::BindingIndependentOf(*binding, *this)) {
        InvalidBinding(size);
    }
    dc2::memory::InvalidateArenaGeneration(*this);
    dc2::memory::InstallArenaBinding(*this, *binding);
    ForgetRun(this);
    CommitStackBinding(*this, buffer, size);
}

void mgCMemory::stSetChildBuffer(mgCMemory &parent, u_long128 *buffer, int size) {
    if (&parent == this || buffer == nullptr || size <= 0 ||
        reinterpret_cast<std::uintptr_t>(buffer) % alignof(u_long128) != 0) {
        InvalidBinding(size);
    }
    const auto binding = dc2::memory::ChildProof(parent, buffer, static_cast<std::size_t>(size) * sizeof(u_long128));
    if (!binding || !dc2::memory::BindingIndependentOf(*binding, *this)) {
        InvalidBinding(size);
    }
    dc2::memory::InvalidateArenaGeneration(*this);
    dc2::memory::InstallArenaBinding(*this, *binding);
    ForgetRun(this);
    CommitStackBinding(*this, buffer, size);
}

void mgCMemory::stSetBorrowedBuffer(mgCMemory &owner, std::span<u_long128> storage) {
    if (&owner == this || storage.empty() || storage.size() >= static_cast<std::size_t>(INT_MAX) ||
        reinterpret_cast<std::uintptr_t>(storage.data()) % alignof(u_long128) != 0) {
        InvalidBinding(0);
    }
    const auto binding = dc2::memory::BorrowProof(owner, storage.data(), storage.size_bytes());
    if (!binding || !dc2::memory::BindingIndependentOf(*binding, *this)) {
        InvalidBinding(static_cast<int>(storage.size()));
    }
    dc2::memory::InvalidateArenaGeneration(*this);
    dc2::memory::InstallArenaBinding(*this, *binding);
    ForgetRun(this);
    CommitStackBinding(*this, storage.data(), static_cast<int>(storage.size()));
}

bool mgCMemory::stShareBuffer(const mgCMemory &source, std::span<u_long128> storage) {
    if (storage.empty() || storage.size() >= static_cast<std::size_t>(INT_MAX) ||
        reinterpret_cast<std::uintptr_t>(storage.data()) % alignof(u_long128) != 0) {
        return false;
    }
    const auto label = CopyName(source.name);
    auto       binding = &source == this ? dc2::memory::RebindProof(source, storage.data(), storage.size_bytes())
                                         : dc2::memory::ShareProof(source, storage);
    if (!binding) {
        return false;
    }
    if (!dc2::memory::BindingIndependentOf(*binding, *this)) {
        binding = dc2::memory::RebindProof(*this, storage.data(), storage.size_bytes());
        if (!binding || !dc2::memory::BindingIndependentOf(*binding, *this)) {
            return false;
        }
    }
    dc2::memory::InvalidateArenaGeneration(*this);
    dc2::memory::InstallArenaBinding(*this, *binding);
    ForgetRun(this);
    std::memcpy(name, label.data(), sizeof(name));
    CommitStackBinding(*this, storage.data(), static_cast<int>(storage.size()));
    stSetLocked(false);
    return true;
}

bool mgCMemory::stShareStack(const mgCMemory &source) {
    if (source.stack == nullptr || source.stack_size <= 0 || source.stack_used < 0 || source.stack_used > source.stack_size) {
        return false;
    }
    const auto bytes = static_cast<std::size_t>(source.stack_size) * sizeof(u_long128);
    if (!dc2::memory::RebindProof(source, source.stack, bytes)) {
        return false;
    }
    const int  used = source.stack_used;
    const bool source_locked = source.lock != 0;
    if (!stShareBuffer(source, std::span(source.stack, static_cast<std::size_t>(source.stack_size)))) {
        return false;
    }
    stack_used = used;
    stSetLocked(source_locked);
    NotePeak(*this);
    return true;
}

void *operator new(size_t size, u_long128 *buffer) {
    GrowLastRun(buffer, size);
    return buffer;
}

void *operator new[](size_t size, u_long128 *buffer) {
    GrowLastRun(buffer, size);
    return buffer;
}

u_long128 *MemoryAllocKept(mgCMemory &memory, int size) {
    return AllocQuadwords(memory, size, Contents::Kept);
}

mgMemoryUsage MemoryUsage(const mgCMemory &memory) {
    const PeakEntry *entry = FindPeak(&memory);
    return {.name = memory.name, .capacity = entry ? entry->capacity : 0, .peak = entry ? entry->peak : 0};
}

void MemoryLogPeaks() {
    for (const PeakEntry &entry : PeakTable()) {
        if (entry.name[0] == '\0') {
            CT_LOG_INFO(Memory, "mg_memory: ? [{}] peak {} of {} quadwords ({} free)",
                        static_cast<const void *>(entry.memory), entry.peak, entry.capacity,
                        entry.capacity - entry.peak);
        } else {
            CT_LOG_INFO(Memory, "mg_memory: {:.16} peak {} of {} quadwords ({} free)", entry.name.data(), entry.peak,
                        entry.capacity, entry.capacity - entry.peak);
        }
    }
}

void MemoryForget(const mgCMemory &memory) {
    std::erase_if(PeakTable(), [&memory](const PeakEntry &entry) { return entry.memory == &memory; });
}

void mgCMemory::stClearUsed() {
    dc2::memory::ResetArenaStack(*this);
    stack_used = 0;
}

void mgCMemory::stReset() {
    stClearUsed();
    lock = 0;
}

void mgCMemory::stSetLocked(bool value) {
    lock = value ? 1 : 0;
}

char *dc2::memory::CopyText(mgCMemory &memory, std::string_view text) {
    if (text.size() == std::numeric_limits<std::size_t>::max()) {
        return nullptr;
    }
    const auto size = text.size() + 1;
    auto      *copy = NewArray<char>(memory, size);
    if (copy == nullptr) {
        return nullptr;
    }
    const auto destination = std::span(copy, size);
    if (!text.empty()) {
        std::memmove(destination.data(), text.data(), text.size());
    }
    destination.back() = '\0';
    return copy;
}

char *mgCopyString(char *source, mgCMemory *memory) {
    if (source == nullptr || memory == nullptr) {
        return nullptr;
    }
    return dc2::memory::CopyText(*memory, source);
}
