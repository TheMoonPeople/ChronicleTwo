#include "platform/datapacks.hpp"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <array>
#include <cstdio>
#include <fstream>
#include <iterator>
#include <limits>
#include <list>
#include <stdexcept>
#include <unordered_map>
#include <utility>

#define STBI_ONLY_PNG
#define STBI_NO_STDIO
#include "stb_image.h"

namespace datapacks {
namespace {

/**
 * Stores one pack's canonical root and case-insensitive asset index.
 */
struct Pack {
    std::filesystem::path                                  root;  /**< Canonical directory containing the pack. */
    std::unordered_map<std::string, std::filesystem::path> files; /**< Relative asset keys mapped to on-disk paths. */
};

/** Canonical converted-data directory used to locate PNG overlays. */
std::filesystem::path retail_root;
/** Enabled packs in increasing priority order. */
std::vector<Pack> packs;
/** Largest accepted physical texture extent on either axis. */
constexpr uint32_t kMaxDimension = 16384;
/** Maximum RGBA storage occupied by one decoded mip chain. */
constexpr uint64_t kMaxDecodedBytes = 256ull * 1024 * 1024;
/** Maximum compressed PNG size accepted before reading its contents. */
constexpr uint64_t kMaxFileBytes = 256ull * 1024 * 1024;
/** RGBA storage the decode cache keeps, least recently used first out. */
constexpr std::size_t kDecodeCacheBytes = 512ull * 1024 * 1024;

/**
 * One decoded catalog variant, kept so entering the same texture again copies it instead of re-reading
 * and re-decoding its PNGs. Upscaled packs make that decode slow enough to show: the dungeon's quick
 * character change re-enters the whole item icon sheet in a single frame.
 */
struct CachedDecode {
    DecodedTexture                   texture;
    std::size_t                      bytes = 0;
    std::list<std::string>::iterator use;
};

std::unordered_map<std::string, CachedDecode> decode_cache;
std::list<std::string>                        decode_uses; /**< Cache keys, most recently used first. */
std::size_t                                   decode_cache_bytes = 0;

void ClearDecodeCache() {
    decode_cache.clear();
    decode_uses.clear();
    decode_cache_bytes = 0;
}

/**
 * Converts a filesystem path to UTF-8 for keys and diagnostics.
 */
std::string Display(const std::filesystem::path &path) {
    const auto utf8 = path.generic_u8string();
    return std::string(utf8.begin(), utf8.end());
}

/**
 * Builds an ASCII case-insensitive asset lookup key.
 */
std::string Key(const std::filesystem::path &path) {
    std::string key = Display(path);
    for (char &character : key) {
        if (character >= 'A' && character <= 'Z') {
            character += 'a' - 'A';
        }
    }
    return key;
}

/**
 * Accepts relative asset paths without traversal or alternate-root syntax.
 */
bool Relative(const std::filesystem::path &path) {
    const auto text = Display(path);
    if (path.empty() || path.is_absolute() || path.has_root_name() || path.has_root_directory() ||
        text.find('\\') != std::string::npos || text.find(':') != std::string::npos ||
        text.find('\0') != std::string::npos) {
        return false;
    }
    for (const auto &part : path) {
        if (part.empty() || part == "." || part == "..") {
            return false;
        }
    }
    return true;
}

/**
 * Checks that a canonical path is a strict descendant of its permitted root.
 */
bool Within(const std::filesystem::path &root, const std::filesystem::path &path) {
    auto base = root.begin();
    auto candidate = path.begin();
    for (; base != root.end(); ++base, ++candidate) {
        if (candidate == path.end()) {
            return false;
        }
#ifdef _WIN32
        if (Key(*base) != Key(*candidate)) {
            return false;
        }
#else
        if (*base != *candidate) {
            return false;
        }
#endif
    }
    return candidate != path.end();
}

/**
 * Rejects missing files and symlinks that escape their pack root.
 */
bool SafeFile(const Pack &pack, const std::filesystem::path &path) {
    std::error_code error;
    const auto      canonical = std::filesystem::weakly_canonical(path, error);
    return !error && Within(pack.root, canonical) && std::filesystem::is_regular_file(canonical, error) && !error;
}

/**
 * Looks up a pack asset and rechecks its current filesystem containment.
 */
std::optional<std::filesystem::path> PackFile(const Pack &pack, const std::filesystem::path &relative) {
    const auto found = pack.files.find(Key(relative));
    if (found == pack.files.end() || !SafeFile(pack, found->second)) {
        return std::nullopt;
    }
    return found->second;
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
bool ReadPng(const std::filesystem::path &path, uint32_t &width, uint32_t &height,
             std::vector<uint8_t> &rgba, std::string &error) {
    std::error_code filesystem_error;
    const auto      size = std::filesystem::file_size(path, filesystem_error);
    if (filesystem_error || size < 33 || size > kMaxFileBytes) {
        error = "PNG is unreadable or exceeds the file-size limit";
        return false;
    }
    std::ifstream                 file(path, std::ios::binary);
    std::array<unsigned char, 33> header{};
    file.read(reinterpret_cast<char *>(header.data()), header.size());
    constexpr std::array<unsigned char, 8> signature{137, 80, 78, 71, 13, 10, 26, 10};
    if (!file || !std::equal(signature.begin(), signature.end(), header.begin()) ||
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
    file.seekg(0);
    std::vector<unsigned char> bytes(static_cast<std::size_t>(size));
    file.read(reinterpret_cast<char *>(bytes.data()), static_cast<std::streamsize>(bytes.size()));
    if (!file) {
        error = "cannot read PNG";
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
 * Clears all configured pack roots and their asset indexes.
 */
void Clear() {
    ClearDecodeCache();
    packs.clear();
    retail_root.clear();
}

/**
 * Loads and validates ordered pack folders beside the converted-data root.
 */
void Load(const std::filesystem::path &port_data_root) {
    Clear();
    std::error_code error;
    retail_root = std::filesystem::weakly_canonical(port_data_root, error);
    if (error) {
        Diagnostic(port_data_root, "cannot establish the converted-data root; packs disabled");
        return;
    }
    const auto directory = retail_root.parent_path() / "datapacks";
    const auto config = directory / "datapacks.json";
    if (!std::filesystem::exists(config, error) && !error) {
        return;
    }
    try {
        if (error || !std::filesystem::is_regular_file(config) || std::filesystem::file_size(config) > 1024 * 1024) {
            throw std::runtime_error("configuration is unreadable or exceeds 1 MiB");
        }
        std::ifstream input(config, std::ios::binary);
        if (!input) {
            throw std::runtime_error("cannot open configuration");
        }
        const auto root = nlohmann::json::parse(input);
        if (!root.is_object() || !root.contains("schema_version") || !root["schema_version"].is_number_integer() ||
            root["schema_version"] != 1 || !root.contains("load_order") || !root["load_order"].is_array()) {
            throw std::runtime_error("expected schema_version 1 and a load_order array");
        }
        const auto        pack_directory = std::filesystem::weakly_canonical(directory);
        std::vector<Pack> configured;
        for (const auto &item : root["load_order"]) {
            if (!item.is_string()) {
                throw std::runtime_error("load_order entries must be folder names");
            }
            const auto                  folder = item.get<std::string>();
            const std::filesystem::path name(std::u8string(folder.begin(), folder.end()));
            if (!Relative(name) || std::distance(name.begin(), name.end()) != 1) {
                throw std::runtime_error("load_order contains an unsafe folder name");
            }
            Pack pack;
            pack.root = std::filesystem::weakly_canonical(directory / name);
            if (!Within(pack_directory, pack.root)) {
                throw std::runtime_error("pack folder escapes datapacks");
            }
            if (!std::filesystem::is_directory(pack.root)) {
                Diagnostic(directory / name, "pack folder is missing; skipped");
                continue;
            }
            for (const auto &file : std::filesystem::recursive_directory_iterator(pack.root)) {
                if (!file.is_regular_file() || !SafeFile(pack, file.path())) {
                    continue;
                }
                const auto relative = file.path().lexically_relative(pack.root);
                const auto key = Key(relative);
                if (!pack.files.emplace(key, file.path()).second) {
                    throw std::runtime_error("pack contains paths differing only by ASCII case");
                }
            }
            configured.push_back(std::move(pack));
        }
        packs = std::move(configured);
    } catch (const std::exception &exception) {
        packs.clear();
        Diagnostic(config, std::string(exception.what()) + "; packs disabled");
    }
}

/**
 * Resolves a relative game-data asset from the highest-priority valid pack.
 */
std::optional<std::filesystem::path> Resolve(const std::filesystem::path &relative) {
    if (!Relative(relative)) {
        return std::nullopt;
    }
    for (auto pack = packs.rbegin(); pack != packs.rend(); ++pack) {
        if (auto path = PackFile(*pack, relative)) {
            return path;
        }
    }
    return std::nullopt;
}

const std::filesystem::path &Root() {
    return retail_root;
}

std::vector<std::filesystem::path> Candidates(const std::filesystem::path &relative) {
    std::vector<std::filesystem::path> candidates;
    if (!Relative(relative)) {
        return candidates;
    }
    for (auto pack = packs.rbegin(); pack != packs.rend(); ++pack) {
        if (auto path = PackFile(*pack, relative)) {
            candidates.push_back(*path);
        }
    }
    if (!retail_root.empty()) {
        Pack       retail{retail_root, {}};
        const auto path = retail_root / relative;
        if (SafeFile(retail, path)) {
            candidates.push_back(path);
        }
    }
    return candidates;
}

std::optional<std::filesystem::path> Asset(const std::filesystem::path &relative) {
    auto candidates = Candidates(relative);
    if (candidates.empty()) {
        return std::nullopt;
    }
    return candidates.front();
}

std::vector<std::filesystem::path> DirectoryMembers(const std::filesystem::path &relative) {
    if (!Relative(relative)) {
        return {};
    }
    std::unordered_map<std::string, std::filesystem::path> members;
    auto                                                   collect = [&](const Pack &pack) {
        const auto      directory = pack.root / relative;
        std::error_code error;
        const auto      canonical = std::filesystem::weakly_canonical(directory, error);
        if (error || !Within(pack.root, canonical) || !std::filesystem::is_directory(canonical, error)) {
            return;
        }
        for (const auto &entry : std::filesystem::directory_iterator(canonical, error)) {
            if (error) {
                break;
            }
            auto filename = relative / entry.path().filename();
            if (entry.is_regular_file(error) && SafeFile(pack, entry.path())) {
                members.insert_or_assign(Key(entry.path().filename()), filename);
            } else if (entry.is_directory(error) && SafeFile(pack, entry.path() / "pack.json")) {
                members.insert_or_assign(Key(entry.path().filename()), filename);
            }
        }
    };
    if (!retail_root.empty()) {
        collect(Pack{retail_root, {}});
    }
    for (const auto &pack : packs) {
        collect(pack);
    }
    std::vector<std::filesystem::path> result;
    for (const auto &[key, path] : members) {
        result.push_back(path);
    }
    std::sort(result.begin(), result.end(), [](const auto &left, const auto &right) { return Key(left) < Key(right); });
    return result;
}

/**
 * Decodes a catalog texture through PNG overlays into padded physical RGBA mip canvases.
 */
namespace {

/**
 * Lists the files that can supply one mip, highest-priority pack first and the converted original last.
 */
std::vector<std::filesystem::path> DecodeCandidates(const std::filesystem::path &level) {
    std::vector<std::filesystem::path> result;
    std::error_code                    path_error;
    const auto                         canonical = std::filesystem::weakly_canonical(level, path_error);
    if (!path_error && !retail_root.empty() && Within(retail_root, canonical)) {
        const auto relative = canonical.lexically_relative(retail_root);
        for (auto pack = packs.rbegin(); pack != packs.rend(); ++pack) {
            if (auto path = PackFile(*pack, relative)) {
                result.push_back(*path);
            }
        }
    }
    result.push_back(level);
    return result;
}

/**
 * Names a variant's decode by every file that can supply it, with each file's size and write time, so a
 * replaced or edited PNG makes a new key.
 */
std::string DecodeKey(const texture_catalog::Entry &entry, std::size_t variant_index) {
    std::vector<std::filesystem::path> sources;
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
                Diagnostic(path, reason + "; trying lower-priority asset");
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
                    Diagnostic(path, "expected original dimensions or uniform power-of-two upscale; trying lower-priority asset");
                    continue;
                }
                scale = candidate_scale;
                decoded.width = retail_width * scale;
                decoded.height = retail_height * scale;
            } else if (width != std::max(1u, (static_cast<uint32_t>(entry.width) * scale) >> mip) ||
                       height != std::max(1u, (static_cast<uint32_t>(entry.height) * scale) >> mip)) {
                Diagnostic(path, "mip dimensions do not match the selected base; trying lower-priority asset");
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

std::string ImageDecodeKey(std::string_view identity, std::span<const std::filesystem::path> sources) {
    std::string key = std::to_string(identity.size()) + ':' + std::string(identity);
    for (const auto &path : sources) {
        std::error_code error;
        const auto      size = std::filesystem::file_size(path, error);
        const auto      time = error ? std::filesystem::file_time_type{} : std::filesystem::last_write_time(path, error);
        const auto      name = Display(path);
        key += '|' + std::to_string(name.size()) + ':' + name + '|' + std::to_string(error ? 0 : size) + '|' +
               std::to_string(static_cast<unsigned long long>(time.time_since_epoch().count()));
    }
    return key;
}

bool DecodeCached(std::string_view identity, const std::function<bool(DecodedTexture &, std::string &)> &decoder,
                  DecodedTexture &decoded, std::string &error) {
    if (identity.empty()) {
        return decoder(decoded, error);
    }
    const std::string key(identity);
    if (const auto found = decode_cache.find(key); found != decode_cache.end()) {
        decode_uses.splice(decode_uses.begin(), decode_uses, found->second.use);
        decoded = found->second.texture;
        error.clear();
        return true;
    }
    if (!decoder(decoded, error)) {
        return false;
    }
    std::size_t bytes = 0;
    for (const auto &level : decoded.levels) {
        bytes += level.size();
    }
    if (bytes == 0 || bytes > kDecodeCacheBytes / 4) {
        return true;
    }
    while (decode_cache_bytes + bytes > kDecodeCacheBytes && !decode_uses.empty()) {
        const auto oldest = decode_cache.find(decode_uses.back());
        decode_cache_bytes -= oldest->second.bytes;
        decode_cache.erase(oldest);
        decode_uses.pop_back();
    }
    decode_uses.push_front(key);
    decode_cache.emplace(key, CachedDecode{decoded, bytes, decode_uses.begin()});
    decode_cache_bytes += bytes;
    return true;
}

} // namespace datapacks
