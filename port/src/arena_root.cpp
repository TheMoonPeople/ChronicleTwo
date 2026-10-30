#include "arena_root.hpp"

#include <algorithm>
#include <cstddef>
#include <cstdio>
#include <cstring>
#include <print>
#include <vector>

#include "character_motion.hpp"
#include "platform/arena.hpp"
#include "platform/memory.hpp"

u_long128 *ArenaRoot(const void *key, int quadwords, const char *name) {
    const std::size_t bytes = static_cast<std::size_t>(quadwords) * sizeof(u_long128) * kArenaHeadroom;
    unsigned char    *base = ArenaBlock(key, bytes);

    static std::vector<const void *> logged;

    if (std::ranges::find(logged, base) == logged.end()) {
        logged.push_back(base);
        std::println("arena: {} {} bytes at {}{}", name != nullptr && name[0] != '\0' ? name : "?", bytes,
                     static_cast<void *>(base), IsAbove4GiB(base) ? " (above 4 GiB)" : " (below 4 GiB)");
        // A PS2_UNIMPLEMENTED abort drops buffered stdout, and the mapping is what a failed run is read for.
        std::fflush(stdout);
    }

    return reinterpret_cast<u_long128 *>(base);
}

u_long128 *ArenaRootFromBuffer(const u_long128 *buffer, int quadwords, const char *name) {
    u_long128                       *base = ArenaRoot(buffer, quadwords, name);
    static std::vector<const void *> imported;

    // After the first import the game owns the mapped contents. Rebinding a cursor to the
    // same root must not replace live records with the original static buffer's bytes.
    if (std::ranges::find(imported, base) == imported.end()) {
        // The root may already be mapped for the same key, so the copy can land on registered motion storage.
        character_motion::ForgetStorage(base, base + quadwords);
        std::memcpy(base, buffer, static_cast<std::size_t>(quadwords) * sizeof(u_long128));
        imported.push_back(base);
    }
    return base;
}
