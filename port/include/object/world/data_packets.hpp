#pragma once

#include <array>
#include <cstddef>
#include <optional>
#include <span>

#include "mg_memory.hpp"

namespace dc2::world {
/**
 * Selects bounded native packet storage for startup, ordinary maps, or Georama.
 */
enum class DataPacketMode {
    Bootstrap,
    Map,
    Georama
};

/**
 * Reports the live packet arenas and whether their layout needs publication.
 */
struct PreparedDataPackets {
    std::span<mgCMemory, 2> buffers; /**< Stable arenas owned by the supplying storage object. */
    bool                    changed; /**< Whether the renderer must adopt the prepared layout. */
};

/**
 * Owns double-buffered packet arenas independently of persistent character storage.
 */
class DataPacketStorage {
    std::array<mgCMemory, 2>      buffers{}; /**< Independent allocation controllers for the two packet frames. */
    std::optional<DataPacketMode> mode{};    /**< Layout currently bound to the packet arenas. */

public:
    /**
     * Constructs independent packet allocation controllers.
     */
    DataPacketStorage() = default;
    /**
     * Keeps allocation-controller identities at their original addresses.
     */
    DataPacketStorage(const DataPacketStorage &) = delete;
    /**
     * Keeps allocation-controller identities at their original addresses.
     */
    DataPacketStorage &operator=(const DataPacketStorage &) = delete;
    /**
     * Keeps allocation-controller identities at their original addresses.
     */
    DataPacketStorage(DataPacketStorage &&) = delete;
    /**
     * Keeps allocation-controller identities at their original addresses.
     */
    DataPacketStorage &operator=(DataPacketStorage &&) = delete;

    /**
     * Reserves any missing character prefix without retiring it and prepares separate packet buffers.
     */
    [[nodiscard]] PreparedDataPackets Prepare(DataPacketMode requested_mode, mgCMemory &character_memory,
                                              std::size_t character_quadwords) &;
    /**
     * Prevents packet views from escaping a temporary storage owner.
     */
    PreparedDataPackets Prepare(DataPacketMode, mgCMemory &, std::size_t) && = delete;
};
} // namespace dc2::world
