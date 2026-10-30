#include "object/world/data_packets.hpp"

#include <climits>
#include <cstddef>
#include <stdexcept>

#include "platform/arena.hpp"

namespace dc2::world {
namespace {
/**
 * Temporarily enables allocation while preserving the caller's arena lock.
 */
class ArenaUnlock {
    mgCMemory &memory;     /**< Controller temporarily unlocked for prefix reservation. */
    bool       was_locked; /**< Lock restored when the reservation ends. */

public:
    /**
     * Unlocks an arena for one validated reservation.
     */
    explicit ArenaUnlock(mgCMemory &source) : memory(source), was_locked(source.lock != 0) {
        memory.stSetLocked(false);
    }

    /**
     * Restores the original allocation lock.
     */
    ~ArenaUnlock() { memory.stSetLocked(was_locked); }

    ArenaUnlock(const ArenaUnlock &) = delete;
    ArenaUnlock &operator=(const ArenaUnlock &) = delete;
    ArenaUnlock(ArenaUnlock &&) = delete;
    ArenaUnlock &operator=(ArenaUnlock &&) = delete;
};

/**
 * Gives the allocation size of a supported packet layout.
 */
int PacketQuadwords(DataPacketMode mode) {
    switch (mode) {
        case DataPacketMode::Bootstrap:
            return 5000;
        case DataPacketMode::Map:
            return 70000;
        case DataPacketMode::Georama:
            return 115000;
    }
    throw std::invalid_argument("unsupported native data packet layout");
}
} // namespace

PreparedDataPackets DataPacketStorage::Prepare(DataPacketMode requested_mode, mgCMemory &character_memory,
                                               std::size_t character_quadwords) & {
    const int quadwords = PacketQuadwords(requested_mode);
    if (requested_mode != DataPacketMode::Bootstrap) {
        if (character_memory.stack_used < 0 || character_memory.stack_size < 0) {
            throw std::length_error("invalid character storage extent");
        }
        const auto used = static_cast<std::size_t>(character_memory.stack_used);
        if (character_quadwords > used) {
            const auto missing = character_quadwords - used;
            const auto available = dc2::memory::RemainingBytes(character_memory).size() / sizeof(u_long128);
            if (missing >= available || missing > static_cast<std::size_t>(INT_MAX)) {
                throw std::length_error("character prefix exceeds its live storage");
            }
            const ArenaUnlock unlocked(character_memory);
            static_cast<void>(character_memory.Alloc(static_cast<int>(missing)));
        }
    }
    if (mode == requested_mode && requested_mode != DataPacketMode::Bootstrap) {
        return {buffers, false};
    }
    for (auto &buffer : buffers) {
        auto *storage = ArenaBlock(&buffer, static_cast<std::size_t>(quadwords) * sizeof(u_long128));
        buffer.stSetBuffer(reinterpret_cast<u_long128 *>(storage), quadwords);
    }
    mode = requested_mode;
    return {buffers, true};
}
} // namespace dc2::world
