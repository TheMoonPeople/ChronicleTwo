#pragma once

#include <chrono>
#include <cstddef>
#include <cstdint>
#include <filesystem>
#include <functional>
#include <memory>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <vector>

#include "platform/texture_catalog.hpp"
#include "platform/vfs.hpp"

namespace datapacks {

/**
 * Holds physical RGBA canvases while the catalog retains the game's logical dimensions.
 */
struct DecodedTexture {
    std::vector<std::vector<uint8_t> > levels;     /**< RGBA mip canvases, largest first. */
    uint32_t                           width = 0;  /**< Padded physical width of the base level. */
    uint32_t                           height = 0; /**< Padded physical height of the base level. */
};

/**
 * Mounts a converted-data directory or ZIP archive as the base and loads the sibling datapacks/datapacks.json.
 */
void Load(const std::filesystem::path &native_root);

/**
 * Uses an open base mount and loads datapacks/datapacks.json beside native_root; later load_order packs win.
 */
void Load(std::shared_ptr<const vfs::Mount> base, const std::filesystem::path &native_root);

/**
 * Clears the base mount, all configured packs and the override index.
 */
void Clear();

/**
 * Returns the mount holding the converted original data, or null before Load.
 */
const std::shared_ptr<const vfs::Mount> &Base();

/**
 * Finds the highest-priority pack replacement for a relative game-data path, ignoring ASCII case.
 */
std::optional<vfs::Ref> Resolve(const std::filesystem::path &relative);

/**
 * Returns the converted-data location given to Load.
 */
const std::filesystem::path &Root();

/**
 * Lists pack replacements in priority order followed by the original asset.
 */
std::vector<vfs::Ref> Candidates(const std::filesystem::path &relative);
/**
 * Lists merged direct file and child-directory names through datapack priority.
 */
std::vector<std::filesystem::path> DirectoryMembers(const std::filesystem::path &relative);

/**
 * Finds the highest-priority replacement or the corresponding original asset.
 */
std::optional<vfs::Ref> Asset(const std::filesystem::path &relative);

/**
 * Reports whether a file comes from a datapack rather than the base data.
 */
bool IsReplacement(const vfs::Ref &file);

/**
 * Decodes a catalog variant through PNG overlays, falling back to valid lower-priority assets.
 */
bool Decode(const texture_catalog::Entry &entry, std::size_t variant, DecodedTexture &decoded, std::string &error);

/**
 * Names the pixels Decode produces for a variant, or returns an empty string when they cannot be named.
 */
std::string DecodeIdentity(const texture_catalog::Entry &entry, std::size_t variant);

/**
 * Names decoded pixels by a semantic image identity and every possible source file's current stamp.
 */
std::string ImageDecodeKey(std::string_view identity, std::span<const vfs::Ref> sources);
/**
 * Reuses immutable decoded image pixels within the shared 512 MiB least-recently-used cache.
 */
bool DecodeCached(std::string_view                                            identity,
                  const std::function<bool(DecodedTexture &, std::string &)> &decoder,
                  DecodedTexture &decoded, std::string &error);

/**
 * Shares cached decoded pixels without copying them, decoding and caching them on a miss; returns null on failure.
 */
std::shared_ptr<const DecodedTexture> DecodeShared(std::string_view                                            identity,
                                                   const std::function<bool(DecodedTexture &, std::string &)> &decoder,
                                                   std::string                                                &error);

/**
 * Reads a whole file with one sized read; returns false when it is missing, unreadable or larger than max_bytes.
 */
bool ReadFileBytes(const std::filesystem::path &path, std::vector<uint8_t> &bytes, std::uint64_t max_bytes = 256ull * 1024 * 1024);
/**
 * Reads a whole data file; returns false when it is missing, unreadable or larger than max_bytes.
 */
bool ReadFileBytes(const vfs::Ref &file, std::vector<uint8_t> &bytes, std::uint64_t max_bytes = 256ull * 1024 * 1024);

/**
 * One decode the cache may not hold yet: its DecodeCached identity and the decoder that produces it.
 */
struct DecodeJob {
    std::string                                          identity; /**< DecodeCached identity naming the result. */
    std::function<bool(DecodedTexture &, std::string &)> decoder;  /**< Thread-safe decoder producing the pixels. */
};

/**
 * Decodes the jobs whose identities are not cached on worker threads and stores the results in the decode cache.
 * Failures are not cached; a later DecodeCached call reruns them serially and reports the error.
 */
void Prefetch(std::span<DecodeJob> jobs);

/**
 * Decodes, on worker threads, the catalog textures Decode would otherwise decode one by one; the results wait in
 * the decode cache.
 */
void PrefetchEntries(std::span<const texture_catalog::Entry *const> entries);

/**
 * Memoises the source-file stamps ImageDecodeKey reads while alive; the memo clears when the outermost scope ends.
 */
struct StampScope {
    StampScope();
    ~StampScope();
    StampScope(const StampScope &) = delete;
    StampScope &operator=(const StampScope &) = delete;
};

/**
 * Adds value to a named load counter when KZ_TEXTURE_TRACE=1; thread-safe; totals print to stderr at exit.
 */
void Trace(std::string_view counter, std::uint64_t value = 1);

/**
 * Returns true when KZ_TEXTURE_TRACE=1 (cached).
 */
bool Tracing();

/**
 * Adds the microseconds between construction and destruction to a named load counter while tracing.
 */
struct TraceTimer {
    explicit TraceTimer(std::string_view counter);
    ~TraceTimer();
    TraceTimer(const TraceTimer &) = delete;
    TraceTimer &operator=(const TraceTimer &) = delete;

    /**
     * Records the elapsed time now instead of at destruction.
     */
    void Stop();

    bool                                  stopped = false; /**< Whether the time was already recorded. */
    std::string_view                      counter; /**< Static counter name receiving the elapsed time. */
    std::chrono::steady_clock::time_point start;   /**< Construction time. */
};

} // namespace datapacks
