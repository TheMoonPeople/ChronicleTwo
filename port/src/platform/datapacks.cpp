#include "platform/datapacks.hpp"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <array>
#include <atomic>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <iterator>
#include <limits>
#include <list>
#include <map>
#include <mutex>
#include <stdexcept>
#include <thread>
#include <unordered_map>
#include <unordered_set>
#include <utility>

#define STBI_ONLY_PNG
#define STBI_NO_STDIO
#include "stb_image.h"

#include "platform/archive_mount.hpp"

namespace datapacks {
namespace {

/**
 * Holds one enabled pack's mounted files.
 */
struct Pack {
    std::filesystem::path             location; /**< Pack folder or ZIP archive. */
    std::shared_ptr<const vfs::Mount> mount;    /**< Pack contents. */
};

/** Converted-data location given to Load. */
std::filesystem::path retail_root;
/** Mount holding the converted original data. */
std::shared_ptr<const vfs::Mount> base;
/** Enabled packs in increasing priority order. */
std::vector<Pack> packs;
/** Folded relative names mapped to every pack file replacing them, highest priority first. */
std::unordered_map<std::string, std::vector<vfs::Ref> > overrides;
/** Largest accepted physical texture extent on either axis. */
constexpr uint32_t kMaxDimension = 16384;
/** Maximum RGBA storage occupied by one decoded mip chain. */
constexpr uint64_t kMaxDecodedBytes = 256ull * 1024 * 1024;
/** Maximum compressed PNG size accepted before reading its contents. */
constexpr uint64_t kMaxFileBytes = 256ull * 1024 * 1024;
/** RGBA storage the decode cache keeps, least recently used first out. */
constexpr std::size_t kDecodeCacheBytes = 512ull * 1024 * 1024;

/** Largest number of Prefetch worker threads. */
constexpr unsigned kMaxPrefetchWorkers = 8;

/**
 * One decoded catalog variant, kept so entering the same texture again copies it instead of re-reading
 * and re-decoding its PNGs. Upscaled packs make that decode slow enough to show: the dungeon's quick
 * character change re-enters the whole item icon sheet in a single frame.
 */
struct CachedDecode {
    std::shared_ptr<const DecodedTexture> texture;   /**< Immutable decoded pixels shared with readers. */
    std::size_t                           bytes = 0; /**< RGBA bytes counted against the cache budget. */
    std::list<std::string>::iterator      use;       /**< Position of this key in the recency list. */
};

/** Guards the decode cache, its recency list and byte total. */
std::mutex decode_mutex;
/** Cached decodes keyed by identity. */
std::unordered_map<std::string, CachedDecode> decode_cache;
/** Cache keys, most recently used first. */
std::list<std::string> decode_uses;
/** RGBA bytes currently held by the decode cache. */
std::size_t decode_cache_bytes = 0;

/** Guards the path memos and the stamp memo. */
std::mutex memo_mutex;
/** Candidates results per relative path for the current pack configuration. */
std::unordered_map<std::string, std::vector<vfs::Ref> > candidates_memo;
/** Host file stamps per display name while a StampScope is alive. */
std::unordered_map<std::string, std::string> stamp_memo;
/** Number of live StampScope objects. */
unsigned stamp_scopes = 0;

/**
 * Accumulates named load counters and prints them to stderr at exit.
 */
struct TraceCounters {
    std::mutex                                         mutex;  /**< Guards totals. */
    std::map<std::string, std::uint64_t, std::less<> > totals; /**< Counter totals sorted by name. */

    ~TraceCounters() {
        const std::lock_guard lock(mutex);
        for (const auto &[name, total] : totals) {
            std::fprintf(stderr, "texture-trace: %s = %llu\n", name.c_str(), static_cast<unsigned long long>(total));
        }
    }
};

/**
 * Returns the process-wide trace counters, constructed on first use.
 */
TraceCounters &Counters() {
    static TraceCounters counters;
    return counters;
}

void ClearDecodeCache() {
    const std::lock_guard lock(decode_mutex);
    decode_cache.clear();
    decode_uses.clear();
    decode_cache_bytes = 0;
}

/**
 * Forgets every path memo so the next lookups observe the current pack configuration.
 */
void ClearMemos() {
    const std::lock_guard lock(memo_mutex);
    candidates_memo.clear();
    stamp_memo.clear();
}

/**
 * Returns a cached decode and marks it most recently used, or null when it is not cached.
 */
std::shared_ptr<const DecodedTexture> CacheFind(const std::string &key) {
    const std::lock_guard lock(decode_mutex);
    const auto            found = decode_cache.find(key);
    if (found == decode_cache.end()) {
        return nullptr;
    }
    decode_uses.splice(decode_uses.begin(), decode_uses, found->second.use);
    return found->second.texture;
}

/**
 * Reports whether a decode is cached without changing its recency.
 */
bool CacheContains(const std::string &key) {
    const std::lock_guard lock(decode_mutex);
    return decode_cache.contains(key);
}

/**
 * Returns the RGBA bytes a decode would occupy in the cache, or zero when it is empty or too large to keep.
 */
std::size_t CacheBytes(const DecodedTexture &texture) {
    std::size_t bytes = 0;
    for (const auto &level : texture.levels) {
        bytes += level.size();
    }
    return bytes > kDecodeCacheBytes / 4 ? 0 : bytes;
}

/**
 * Stores a decode under its identity, evicting least recently used decodes to stay within the budget.
 */
void CacheInsert(const std::string &key, std::shared_ptr<const DecodedTexture> texture) {
    const std::size_t bytes = CacheBytes(*texture);
    if (bytes == 0) {
        return;
    }
    std::uint64_t         evictions = 0;
    const std::lock_guard lock(decode_mutex);
    if (const auto found = decode_cache.find(key); found != decode_cache.end()) {
        decode_uses.splice(decode_uses.begin(), decode_uses, found->second.use);
        return;
    }
    while (decode_cache_bytes + bytes > kDecodeCacheBytes && !decode_uses.empty()) {
        const auto oldest = decode_cache.find(decode_uses.back());
        decode_cache_bytes -= oldest->second.bytes;
        decode_cache.erase(oldest);
        decode_uses.pop_back();
        ++evictions;
    }
    decode_uses.push_front(key);
    decode_cache.emplace(key, CachedDecode{std::move(texture), bytes, decode_uses.begin()});
    decode_cache_bytes += bytes;
    Trace("decode cache inserts");
    if (evictions) {
        Trace("decode cache evictions", evictions);
    }
}

/**
 * Returns a file's stamp; host files are queried once while a StampScope is alive and archive stamps are fixed.
 */
std::string FileStamp(const vfs::Ref &file, const std::string &name) {
    if (!vfs::HostPath(file)) {
        return vfs::Stamp(file);
    }
    {
        const std::lock_guard lock(memo_mutex);
        if (stamp_scopes) {
            if (const auto found = stamp_memo.find(name); found != stamp_memo.end()) {
                Trace("stamp memo hits");
                return found->second;
            }
        }
    }
    auto                  stamp = vfs::Stamp(file);
    const std::lock_guard lock(memo_mutex);
    if (stamp_scopes) {
        Trace("stamp memo misses");
        stamp_memo.insert_or_assign(name, stamp);
    }
    return stamp;
}

/**
 * Converts a filesystem path to UTF-8 for keys and diagnostics.
 */
std::string Display(const std::filesystem::path &path) {
    const auto utf8 = path.generic_u8string();
    return std::string(utf8.begin(), utf8.end());
}

/**
 * Returns the replacements of a folded name, highest priority first, or null when no pack replaces it.
 */
const std::vector<vfs::Ref> *Overrides(std::string_view relative) {
    if (overrides.empty()) {
        return nullptr;
    }
    const auto found = overrides.find(vfs::FoldKey(relative));
    return found == overrides.end() ? nullptr : &found->second;
}

/**
 * Mounts one load_order entry: an archive named by the entry or by the entry plus .zip, else a folder.
 */
std::optional<Pack> OpenPack(const std::filesystem::path &directory, const std::filesystem::path &name) {
    std::error_code error;
    auto            archive = directory / name;
    if (vfs::FoldKey(Display(name)).ends_with(".zip") && std::filesystem::is_regular_file(archive, error)) {
        return Pack{archive, ArchiveMountOpen(archive)};
    }
    archive = directory / name;
    archive += ".zip";
    if (std::filesystem::is_regular_file(archive, error)) {
        return Pack{archive, ArchiveMountOpen(archive)};
    }
    const auto folder = directory / name;
    if (std::filesystem::is_directory(folder, error)) {
        return Pack{folder, vfs::OpenDirectory(folder, true)};
    }
    return std::nullopt;
}

/**
 * Reports a rejected configuration or asset with its path.
 */
void Diagnostic(const std::filesystem::path &path, const std::string &message) {
    std::fprintf(stderr, "datapacks: %s: %s\n", Display(path).c_str(), message.c_str());
}

/**
 * Rounds a validated logical extent up to the retail GS canvas size.
 */
uint32_t PowerOfTwo(uint32_t value) {
    uint32_t result = 1;
    while (result < value) {
        result <<= 1;
    }
    return result;
}

/**
 * Checks physical texture dimensions and cumulative RGBA mip storage.
 */
bool ChainFits(uint32_t width, uint32_t height, std::size_t count) {
    if (!width || !height || width > kMaxDimension || height > kMaxDimension) {
        return false;
    }
    uint64_t total = 0;
    for (std::size_t mip = 0; mip < count; ++mip) {
        total += uint64_t{std::max(1u, width >> mip)} * std::max(1u, height >> mip) * 4;
    }
    return total <= kMaxDecodedBytes && total <= std::numeric_limits<std::size_t>::max();
}

/**
 * Preflights PNG dimensions and file size before decoding any PNG format to RGBA.
 */
bool ReadPng(const vfs::Ref &path, uint32_t &width, uint32_t &height,
             std::vector<uint8_t> &rgba, std::string &error) {
    std::vector<uint8_t> bytes;
    if (!ReadFileBytes(path, bytes, kMaxFileBytes) || bytes.size() < 33) {
        error = "PNG is unreadable or exceeds the file-size limit";
        return false;
    }
    Trace("png files read");
    Trace("png bytes read", bytes.size());
    const std::span<const uint8_t, 33> header(bytes.data(), 33);
    constexpr std::array<unsigned char, 8> signature{137, 80, 78, 71, 13, 10, 26, 10};
    if (!std::equal(signature.begin(), signature.end(), header.begin()) ||
        header[8] || header[9] || header[10] || header[11] != 13 ||
        !std::equal(header.begin() + 12, header.begin() + 16, "IHDR") ||
        header[26] || header[27] || header[28] > 1) {
        error = "expected a PNG image";
        return false;
    }
    const auto word = [&](std::size_t offset) {
        return (uint32_t{header[offset]} << 24) | (uint32_t{header[offset + 1]} << 16) |
               (uint32_t{header[offset + 2]} << 8) | header[offset + 3];
    };
    width = word(16);
    height = word(20);
    if (!ChainFits(width, height, 1)) {
        error = "PNG dimensions exceed the texture or memory limit";
        return false;
    }
    int            decoded_width = 0, decoded_height = 0, channels = 0;
    unsigned char *pixels = stbi_load_from_memory(bytes.data(), static_cast<int>(bytes.size()),
                                                  &decoded_width, &decoded_height, &channels, 4);
    if (!pixels || decoded_width != static_cast<int>(width) || decoded_height != static_cast<int>(height)) {
        stbi_image_free(pixels);
        error = "cannot decode PNG";
        return false;
    }
    rgba.assign(pixels, pixels + static_cast<std::size_t>(width) * height * 4);
    stbi_image_free(pixels);
    Trace("stbi decodes");
    Trace("stbi decoded bytes", rgba.size());
    return true;
}

/**
 * Copies logical image pixels into a transparent physical canvas.
 */
std::vector<uint8_t> Pad(std::vector<uint8_t> pixels, uint32_t width, uint32_t height,
                         uint32_t canvas_width, uint32_t canvas_height) {
    if (width == canvas_width && height == canvas_height) {
        return pixels;
    }
    std::vector<uint8_t> canvas(static_cast<std::size_t>(canvas_width) * canvas_height * 4);
    for (uint32_t row = 0; row < height; ++row) {
        std::copy_n(pixels.begin() + static_cast<std::size_t>(row) * width * 4, width * 4,
                    canvas.begin() + static_cast<std::size_t>(row) * canvas_width * 4);
    }
    return canvas;
}

/**
 * Builds the next physical mip canvas with a two-by-two box filter.
 */
std::vector<uint8_t> Downsample(const std::vector<uint8_t> &pixels, uint32_t width, uint32_t height) {
    const uint32_t       next_width = std::max(1u, width / 2), next_height = std::max(1u, height / 2);
    std::vector<uint8_t> next(static_cast<std::size_t>(next_width) * next_height * 4);
    for (uint32_t y = 0; y < next_height; ++y) {
        for (uint32_t x = 0; x < next_width; ++x) {
            for (uint32_t channel = 0; channel < 4; ++channel) {
                unsigned sum = 0;
                for (uint32_t dy = 0; dy < 2; ++dy) {
                    for (uint32_t dx = 0; dx < 2; ++dx) {
                        const auto offset = (static_cast<std::size_t>(std::min(height - 1, y * 2 + dy)) * width +
                                             std::min(width - 1, x * 2 + dx)) *
                                                4 +
                                            channel;
                        sum += pixels[offset];
                    }
                }
                next[(static_cast<std::size_t>(y) * next_width + x) * 4 + channel] = (sum + 2) / 4;
            }
        }
    }
    return next;
}

} // namespace

/**
 * Clears the base mount, all configured packs and the override index.
 */
void Clear() {
    ClearDecodeCache();
    ClearMemos();
    packs.clear();
    overrides.clear();
    base.reset();
    retail_root.clear();
    vfs::SetBase(nullptr);
}

/**
 * Mounts the converted data at native_root, a directory or a ZIP archive, and loads its sibling packs.
 */
void Load(const std::filesystem::path &native_root) {
    Clear();
    if (native_root.empty()) {
        return;
    }
    std::error_code                   error;
    std::shared_ptr<const vfs::Mount> mount;
    try {
        mount = std::filesystem::is_regular_file(native_root, error) ? ArchiveMountOpen(native_root) : vfs::OpenDirectory(native_root);
    } catch (const std::exception &exception) {
        Diagnostic(native_root, std::string(exception.what()) + "; data unavailable");
        return;
    }
    Load(std::move(mount), native_root);
}

/**
 * Loads and validates ordered packs beside the converted-data location and builds the merged override index.
 */
void Load(std::shared_ptr<const vfs::Mount> base_mount, const std::filesystem::path &native_root) {
    Clear();
    const TraceTimer timer("datapacks load us");
    base = std::move(base_mount);
    vfs::SetBase(base);
    std::error_code error;
    retail_root = std::filesystem::weakly_canonical(native_root, error);
    if (error) {
        Diagnostic(native_root, "cannot establish the converted-data location; packs disabled");
        return;
    }
    const auto directory = retail_root.parent_path() / "datapacks";
    const auto config = directory / "datapacks.json";
    if (!std::filesystem::exists(config, error) && !error) {
        return;
    }
    try {
        std::vector<uint8_t> text;
        if (error || !std::filesystem::is_regular_file(config) || !ReadFileBytes(config, text, 1024 * 1024)) {
            throw std::runtime_error("configuration is unreadable or exceeds 1 MiB");
        }
        const auto root = nlohmann::json::parse(text);
        if (!root.is_object() || !root.contains("schema_version") || !root["schema_version"].is_number_integer() ||
            root["schema_version"] != 1 || !root.contains("load_order") || !root["load_order"].is_array()) {
            throw std::runtime_error("expected schema_version 1 and a load_order array");
        }
        std::vector<Pack> configured;
        for (const auto &item : root["load_order"]) {
            if (!item.is_string()) {
                throw std::runtime_error("load_order entries must be pack names");
            }
            const auto                  folder = item.get<std::string>();
            const std::filesystem::path name(std::u8string(folder.begin(), folder.end()));
            if (!vfs::SafeRelative(folder) || std::distance(name.begin(), name.end()) != 1) {
                throw std::runtime_error("load_order contains an unsafe pack name");
            }
            auto pack = OpenPack(directory, name);
            if (!pack) {
                Diagnostic(directory / name, "pack is missing; skipped");
                continue;
            }
            configured.push_back(std::move(*pack));
        }
        // One merged index resolves load_order once: each name maps to its replacements, highest priority first.
        std::unordered_map<std::string, std::vector<vfs::Ref> > merged;
        for (auto pack = configured.rbegin(); pack != configured.rend(); ++pack) {
            const auto count = pack->mount->Count();
            for (std::size_t index = 0; index < count; ++index) {
                merged[vfs::FoldKey(pack->mount->Name(index))].emplace_back(pack->mount, index);
            }
        }
        packs = std::move(configured);
        overrides = std::move(merged);
    } catch (const std::exception &exception) {
        packs.clear();
        overrides.clear();
        Diagnostic(config, std::string(exception.what()) + "; packs disabled");
    }
}

const std::shared_ptr<const vfs::Mount> &Base() {
    return base;
}

/**
 * Resolves a relative game-data asset from the highest-priority pack.
 */
std::optional<vfs::Ref> Resolve(const std::filesystem::path &relative) {
    const auto name = vfs::RelativeName(relative);
    if (!name) {
        return std::nullopt;
    }
    const auto *replacements = Overrides(*name);
    if (!replacements) {
        return std::nullopt;
    }
    return replacements->front();
}

const std::filesystem::path &Root() {
    return retail_root;
}

std::vector<vfs::Ref> Candidates(const std::filesystem::path &relative) {
    const auto name = vfs::RelativeName(relative);
    if (!name) {
        return {};
    }
    {
        const std::lock_guard lock(memo_mutex);
        if (const auto found = candidates_memo.find(*name); found != candidates_memo.end()) {
            Trace("candidates memo hits");
            return found->second;
        }
    }
    Trace("candidates memo misses");
    std::vector<vfs::Ref> candidates;
    if (const auto *replacements = Overrides(*name)) {
        candidates = *replacements;
    }
    if (auto original = vfs::Find(base, *name)) {
        candidates.push_back(std::move(original));
    }
    const std::lock_guard lock(memo_mutex);
    candidates_memo.insert_or_assign(*name, candidates);
    return candidates;
}

std::optional<vfs::Ref> Asset(const std::filesystem::path &relative) {
    auto candidates = Candidates(relative);
    if (candidates.empty()) {
        return std::nullopt;
    }
    return candidates.front();
}

bool IsReplacement(const vfs::Ref &file) {
    return file && file.mount() != base;
}

std::vector<std::filesystem::path> DirectoryMembers(const std::filesystem::path &relative) {
    const auto name = vfs::RelativeName(relative);
    if (!name) {
        return {};
    }
    std::unordered_map<std::string, std::string> members;
    auto                                         collect = [&](const std::shared_ptr<const vfs::Mount> &mount) {
        if (!mount) {
            return;
        }
        for (const auto &member : mount->List(*name)) {
            const auto path = *name + '/' + member.name;
            if (!member.directory || mount->Find(path + "/pack.json")) {
                members.insert_or_assign(vfs::FoldKey(member.name), path);
            }
        }
    };
    collect(base);
    for (const auto &pack : packs) {
        collect(pack.mount);
    }
    std::vector<std::pair<std::string, std::filesystem::path> > sorted;
    sorted.reserve(members.size());
    for (const auto &[key, path] : members) {
        sorted.emplace_back(vfs::FoldKey(path), std::filesystem::path(std::u8string(path.begin(), path.end())));
    }
    std::sort(sorted.begin(), sorted.end(), [](const auto &left, const auto &right) { return left.first < right.first; });
    std::vector<std::filesystem::path> result;
    result.reserve(sorted.size());
    for (auto &[key, path] : sorted) {
        result.push_back(std::move(path));
    }
    return result;
}

namespace {

/**
 * Lists the files that can supply one mip, highest-priority pack first and the converted original last.
 */
std::vector<vfs::Ref> DecodeCandidates(const texture_catalog::Entry::Level &level) {
    std::vector<vfs::Ref> result;
    if (vfs::SafeRelative(level.path)) {
        if (const auto *replacements = Overrides(level.path)) {
            result = *replacements;
        }
    }
    if (level.file) {
        result.push_back(level.file);
    }
    return result;
}

/**
 * Names a variant's decode by every file that can supply it, with each file's stamp, so a replaced or edited
 * PNG makes a new key.
 */
std::string DecodeKey(const texture_catalog::Entry &entry, std::size_t variant_index) {
    std::vector<vfs::Ref> sources;
    for (const auto &level : entry.variants[variant_index].levels) {
        const auto candidates = DecodeCandidates(level);
        sources.insert(sources.end(), candidates.begin(), candidates.end());
    }
    return ImageDecodeKey("texture|" + std::to_string(variant_index) + '|' + std::to_string(entry.width) + 'x' + std::to_string(entry.height), sources);
}

bool DecodeUncached(const texture_catalog::Entry &entry, std::size_t variant_index, DecodedTexture &decoded,
                    std::string &error) {
    decoded = {};
    if (entry.type != "texture" || entry.bpp != 32 || entry.width <= 0 || entry.height <= 0 ||
        entry.width > static_cast<int>(kMaxDimension) || entry.height > static_cast<int>(kMaxDimension) ||
        variant_index >= entry.variants.size()) {
        error = "invalid texture entry or RGBA variant";
        return false;
    }
    const auto &variant = entry.variants[variant_index];
    if (variant.levels.size() > 4 || (!entry.no_image && variant.levels.empty())) {
        error = "missing or invalid PNG mip chain";
        return false;
    }
    const uint32_t retail_width = PowerOfTwo(entry.width), retail_height = PowerOfTwo(entry.height);
    decoded.width = retail_width;
    decoded.height = retail_height;
    if (variant.levels.empty()) {
        error.clear();
        return true;
    }
    const auto candidates = [&](std::size_t mip) { return DecodeCandidates(variant.levels[mip]); };
    uint32_t   scale = 0;
    for (std::size_t mip = 0; mip < variant.levels.size(); ++mip) {
        bool selected = false;
        for (const auto &path : candidates(mip)) {
            uint32_t             width = 0, height = 0;
            std::vector<uint8_t> pixels;
            std::string          reason;
            if (!ReadPng(path, width, height, pixels, reason)) {
                Diagnostic(path.Display(), reason + "; trying lower-priority asset");
                continue;
            }
            if (mip == 0) {
                const auto     logical_width = static_cast<uint32_t>(entry.width);
                const auto     logical_height = static_cast<uint32_t>(entry.height);
                const uint32_t candidate_scale = width / logical_width;
                if (width % logical_width || height % logical_height || candidate_scale == 0 ||
                    candidate_scale != height / logical_height || (candidate_scale & (candidate_scale - 1)) ||
                    !ChainFits(retail_width * uint64_t{candidate_scale}, retail_height * uint64_t{candidate_scale},
                               variant.levels.size())) {
                    Diagnostic(path.Display(), "expected original dimensions or uniform power-of-two upscale; trying lower-priority asset");
                    continue;
                }
                scale = candidate_scale;
                decoded.width = retail_width * scale;
                decoded.height = retail_height * scale;
            } else if (width != std::max(1u, (static_cast<uint32_t>(entry.width) * scale) >> mip) ||
                       height != std::max(1u, (static_cast<uint32_t>(entry.height) * scale) >> mip)) {
                Diagnostic(path.Display(), "mip dimensions do not match the selected base; trying lower-priority asset");
                continue;
            }
            decoded.levels.push_back(Pad(std::move(pixels), width, height,
                                         std::max(1u, decoded.width >> mip), std::max(1u, decoded.height >> mip)));
            selected = true;
            break;
        }
        if (!selected) {
            if (mip == 0) {
                decoded = {};
                error = "cannot load a valid base texture PNG";
                return false;
            }
            decoded.levels.push_back(Downsample(decoded.levels.back(), std::max(1u, decoded.width >> (mip - 1)),
                                                std::max(1u, decoded.height >> (mip - 1))));
        }
    }
    error.clear();
    return true;
}

} // namespace

/**
 * Decodes a catalog texture, from the decode cache when the same variant was decoded before.
 */
bool Decode(const texture_catalog::Entry &entry, std::size_t variant_index, DecodedTexture &decoded,
            std::string &error) {
    if (entry.type != "texture" || entry.bpp != 32 || entry.width <= 0 || entry.height <= 0 ||
        entry.width > static_cast<int>(kMaxDimension) || entry.height > static_cast<int>(kMaxDimension) ||
        variant_index >= entry.variants.size() || entry.variants[variant_index].levels.empty()) {
        return DecodeUncached(entry, variant_index, decoded, error);
    }
    return DecodeCached(DecodeKey(entry, variant_index), [&](DecodedTexture &out, std::string &failure) { return DecodeUncached(entry, variant_index, out, failure); }, decoded, error);
}

std::string ImageDecodeKey(std::string_view identity, std::span<const vfs::Ref> sources) {
    std::string key = std::to_string(identity.size()) + ':' + std::string(identity);
    for (const auto &file : sources) {
        const auto name = file.Display();
        key += '|' + std::to_string(name.size()) + ':' + name + '|' + FileStamp(file, name);
    }
    return key;
}

bool DecodeCached(std::string_view identity, const std::function<bool(DecodedTexture &, std::string &)> &decoder,
                  DecodedTexture &decoded, std::string &error) {
    if (identity.empty()) {
        return decoder(decoded, error);
    }
    const std::string key(identity);
    if (const auto found = CacheFind(key)) {
        Trace("decode cache hits");
        decoded = *found;
        error.clear();
        return true;
    }
    Trace("decode cache misses");
    DecodedTexture fresh;
    if (!decoder(fresh, error)) {
        decoded = std::move(fresh);
        return false;
    }
    if (CacheBytes(fresh) == 0) {
        decoded = std::move(fresh);
        return true;
    }
    auto shared = std::make_shared<const DecodedTexture>(std::move(fresh));
    CacheInsert(key, shared);
    decoded = *shared;
    return true;
}

std::shared_ptr<const DecodedTexture> DecodeShared(std::string_view                                            identity,
                                                   const std::function<bool(DecodedTexture &, std::string &)> &decoder,
                                                   std::string                                                &error) {
    const std::string key(identity);
    if (!key.empty()) {
        if (auto found = CacheFind(key)) {
            Trace("decode cache hits");
            error.clear();
            return found;
        }
        Trace("decode cache misses");
    }
    DecodedTexture fresh;
    if (!decoder(fresh, error)) {
        return nullptr;
    }
    auto shared = std::make_shared<const DecodedTexture>(std::move(fresh));
    if (!key.empty()) {
        CacheInsert(key, shared);
    }
    return shared;
}

bool ReadFileBytes(const std::filesystem::path &path, std::vector<uint8_t> &bytes, std::uint64_t max_bytes) {
    bytes.clear();
    std::ifstream file(path, std::ios::binary | std::ios::ate);
    if (!file) {
        return false;
    }
    const auto end = static_cast<std::streamoff>(file.tellg());
    if (end < 0 || static_cast<std::uint64_t>(end) > max_bytes ||
        static_cast<std::uint64_t>(end) > std::numeric_limits<std::size_t>::max()) {
        return false;
    }
    file.seekg(0);
    bytes.resize(static_cast<std::size_t>(end));
    if (!bytes.empty() && !file.read(reinterpret_cast<char *>(bytes.data()), static_cast<std::streamsize>(bytes.size()))) {
        bytes.clear();
        return false;
    }
    Trace("files read");
    Trace("file bytes read", bytes.size());
    return true;
}

bool ReadFileBytes(const vfs::Ref &file, std::vector<uint8_t> &bytes, std::uint64_t max_bytes) {
    if (!vfs::Read(file, bytes, max_bytes)) {
        bytes.clear();
        return false;
    }
    Trace("files read");
    Trace("file bytes read", bytes.size());
    return true;
}

void Prefetch(std::span<DecodeJob> jobs) {
    const TraceTimer timer("prefetch wall us");
    // Each identity is decoded at most once per batch, and only when the cache does not hold it already.
    std::vector<DecodeJob *>        pending;
    std::unordered_set<std::string> seen;
    for (auto &job : jobs) {
        if (job.identity.empty() || !job.decoder || !seen.insert(job.identity).second || CacheContains(job.identity)) {
            continue;
        }
        pending.push_back(&job);
    }
    Trace("prefetch jobs", pending.size());
    if (pending.empty()) {
        return;
    }
    std::atomic<std::size_t> next = 0;
    std::atomic<std::size_t> decoded = 0;
    const auto               work = [&] {
        for (std::size_t index = next++; index < pending.size(); index = next++) {
            const auto    &job = *pending[index];
            DecodedTexture fresh;
            std::string    error;
            bool           succeeded = false;
            try {
                succeeded = job.decoder(fresh, error);
            } catch (...) {
                succeeded = false;
            }
            if (succeeded) {
                CacheInsert(job.identity, std::make_shared<const DecodedTexture>(std::move(fresh)));
                ++decoded;
            }
        }
    };
    const auto workers = std::min<std::size_t>(std::clamp(std::thread::hardware_concurrency(), 1u, kMaxPrefetchWorkers),
                                               pending.size());
    {
        std::vector<std::jthread> threads;
        threads.reserve(workers - 1);
        for (std::size_t worker = 1; worker < workers; ++worker) {
            threads.emplace_back(work);
        }
        work();
    }
    Trace("prefetch decoded", decoded);
}

StampScope::StampScope() {
    const std::lock_guard lock(memo_mutex);
    ++stamp_scopes;
}

StampScope::~StampScope() {
    const std::lock_guard lock(memo_mutex);
    if (--stamp_scopes == 0) {
        stamp_memo.clear();
    }
}

bool Tracing() {
    static const bool enabled = [] {
        const char *value = std::getenv("KZ_TEXTURE_TRACE");
        return value && std::string_view(value) == "1";
    }();
    return enabled;
}

void Trace(std::string_view counter, std::uint64_t value) {
    if (!Tracing()) {
        return;
    }
    auto                 &counters = Counters();
    const std::lock_guard lock(counters.mutex);
    if (const auto found = counters.totals.find(counter); found != counters.totals.end()) {
        found->second += value;
    } else {
        counters.totals.emplace(std::string(counter), value);
    }
}

TraceTimer::TraceTimer(std::string_view counter) : counter(counter), start(std::chrono::steady_clock::now()) {}

TraceTimer::~TraceTimer() {
    if (Tracing()) {
        Trace(counter, static_cast<std::uint64_t>(std::chrono::duration_cast<std::chrono::microseconds>(
                                                      std::chrono::steady_clock::now() - start)
                                                      .count()));
    }
}

} // namespace datapacks
