#include "platform/native_config.hpp"

#include <sifdev.h>

#include <cmath>
#include <cstdint>
#include <filesystem>
#include <limits>
#include <list>
#include <mutex>
#include <print>
#include <string_view>
#include <utility>

#include "dataread_port.hpp"
#include "platform/config_catalog.hpp"
#include "platform/datapacks.hpp"
#include "platform/legacy_encoding.hpp"

namespace native_config {
namespace {

/**
 * Parsed document of one datapack candidate, kept while its mount is alive.
 */
struct CachedDocument {
    std::shared_ptr<const vfs::Mount> mount;    /**< Mount holding the candidate. */
    std::size_t                       index;    /**< Candidate's entry in its mount. */
    std::size_t                       digest;   /**< Hash of the bytes that were parsed. */
    std::size_t                       size;     /**< Number of bytes that were parsed. */
    std::shared_ptr<const Json>       document; /**< Parsed JSON, or null when the bytes were not JSON. */
};

/**
 * Number of parsed candidates kept; menu command documents are read on every menu action.
 */
constexpr std::size_t kCacheEntries = 96;

std::mutex                cache_mutex; /**< Guards the cache. */
std::list<CachedDocument> cache;       /**< Most recently used first. */

/**
 * Parses one candidate, reusing an earlier parse of the same entry while its bytes are unchanged.
 */
std::shared_ptr<const Json> Parse(const vfs::Ref &candidate) {
    std::vector<uint8_t> bytes;
    if (!datapacks::ReadFileBytes(candidate, bytes)) {
        return nullptr;
    }
    const std::size_t digest = std::hash<std::string_view>{}(std::string_view(reinterpret_cast<const char *>(bytes.data()), bytes.size()));
    {
        const std::scoped_lock lock(cache_mutex);
        for (auto entry = cache.begin(); entry != cache.end(); ++entry) {
            if (entry->mount == candidate.mount() && entry->index == candidate.index()) {
                if (entry->digest == digest && entry->size == bytes.size()) {
                    cache.splice(cache.begin(), cache, entry);
                    return cache.front().document;
                }
                cache.erase(entry);
                break;
            }
        }
    }
    std::shared_ptr<const Json> document;
    auto                        parsed = Json::parse(bytes.begin(), bytes.end(), nullptr, false);
    if (!parsed.is_discarded()) {
        document = std::make_shared<const Json>(std::move(parsed));
    }
    const std::scoped_lock lock(cache_mutex);
    cache.push_front({.mount = candidate.mount(), .index = candidate.index(), .digest = digest, .size = bytes.size(), .document = document});
    if (cache.size() > kCacheEntries) {
        cache.pop_back();
    }
    return document;
}

/**
 * Decodes the hexadecimal CP932 bytes of a string that readable text cannot reproduce.
 */
std::string GameBytes(const std::string &hex) {
    if (hex.size() % 2 != 0) {
        throw std::runtime_error("invalid game_bytes");
    }
    const auto digit = [](char value) {
        if (value >= '0' && value <= '9') {
            return value - '0';
        }
        if (value >= 'a' && value <= 'f') {
            return value - 'a' + 10;
        }
        if (value >= 'A' && value <= 'F') {
            return value - 'A' + 10;
        }
        throw std::runtime_error("invalid game_bytes");
    };
    std::string bytes;
    for (std::size_t index = 0; index < hex.size(); index += 2) {
        const auto value = static_cast<char>((digit(hex[index]) * 16) + digit(hex[index + 1]));
        if (value == '\0') {
            throw std::runtime_error("null byte in game_bytes");
        }
        bytes.push_back(value);
    }
    return bytes;
}

} // namespace

std::vector<std::shared_ptr<const Json> > Candidates(std::string_view relative, std::vector<std::string> &names) {
    std::vector<std::shared_ptr<const Json> > documents;
    names.clear();
    for (const auto &candidate : config_catalog::Paths(relative)) {
        auto document = Parse(candidate);
        if (!document) {
            Report(candidate.Display(), "configuration is not JSON");
            continue;
        }
        documents.push_back(std::move(document));
        names.push_back(candidate.Display());
    }
    return documents;
}

std::shared_ptr<const Json> Host(std::string_view host_name, std::string &error) {
    error.clear();
    const std::string name(host_name);
    const int         descriptor = sceOpen(name.c_str(), SCE_RDONLY);
    if (descriptor < 0) {
        return nullptr;
    }

    struct CloseFile {
        int descriptor;

        ~CloseFile() { sceClose(descriptor); }
    } close_file{descriptor};

    const int length = sceLseek(descriptor, 0, SCE_SEEK_END);
    if (length < 0 || sceLseek(descriptor, 0, SCE_SEEK_SET) < 0) {
        error = "could not determine host configuration size";
        return nullptr;
    }
    std::vector<char> bytes(static_cast<std::size_t>(length));
    if (sceRead(descriptor, bytes.data(), length) != length) {
        error = "could not read host configuration";
        return nullptr;
    }
    auto parsed = Json::parse(bytes.begin(), bytes.end(), nullptr, false);
    if (parsed.is_discarded()) {
        error = "host configuration is not JSON";
        return nullptr;
    }
    return std::make_shared<const Json>(std::move(parsed));
}

std::optional<std::string> BufferPath(const void *buffer) {
    return buffer != nullptr ? DataReadBufferPath(buffer) : std::nullopt;
}

std::optional<std::string> GamePath(const char *game_name) {
    return DataReadAssetPath(game_name);
}

void CheckKind(const Json &document, std::string_view kind) {
    if (!document.is_object()) {
        throw std::runtime_error("configuration is not an object");
    }
    if (document.contains("commands")) {
        throw std::runtime_error("command-list configuration documents are no longer read");
    }
    const auto version = document.find("schema_version");
    if (version == document.end() || !version->is_number_integer() || version->get<int>() != kSchemaVersion) {
        throw std::runtime_error("unsupported configuration schema");
    }
    const auto found = document.find("kind");
    if (found == document.end() || !found->is_string() || found->get_ref<const std::string &>() != kind) {
        throw std::runtime_error("configuration is not a " + std::string(kind) + " document");
    }
}

void Report(std::string_view path, std::string_view error) {
    std::println(stderr, "config: {:.{}}: {:.{}}", path.data(), static_cast<int>(path.size()), error.data(), static_cast<int>(error.size()));
}

const Json &At(const Json &object, const char *key) {
    if (!object.is_object()) {
        throw std::runtime_error(std::string("expected an object holding ") + key);
    }
    const auto found = object.find(key);
    if (found == object.end()) {
        throw std::runtime_error(std::string("missing ") + key);
    }
    return *found;
}

int Int(const Json &value) {
    if (!value.is_number_integer()) {
        throw std::runtime_error("expected an integer");
    }
    if (value.is_number_unsigned()) {
        if (value.get<std::uint64_t>() > static_cast<std::uint64_t>(std::numeric_limits<int>::max())) {
            throw std::runtime_error("integer out of range");
        }
        return static_cast<int>(value.get<std::uint64_t>());
    }
    const auto number = value.get<std::int64_t>();
    if (number < std::numeric_limits<int>::min() || number > std::numeric_limits<int>::max()) {
        throw std::runtime_error("integer out of range");
    }
    return static_cast<int>(number);
}

float Float(const Json &value) {
    if (!value.is_number()) {
        throw std::runtime_error("expected a number");
    }
    const auto number = static_cast<float>(value.get<double>());
    if (!std::isfinite(number)) {
        throw std::runtime_error("non-finite number");
    }
    return number;
}

int Int(const Json &object, const char *key) {
    return Int(At(object, key));
}

float Float(const Json &object, const char *key) {
    return Float(At(object, key));
}

std::optional<int> OptionalInt(const Json &object, const char *key) {
    const auto found = object.find(key);
    if (found == object.end()) {
        return std::nullopt;
    }
    return Int(*found);
}

std::optional<float> OptionalFloat(const Json &object, const char *key) {
    const auto found = object.find(key);
    if (found == object.end()) {
        return std::nullopt;
    }
    return Float(*found);
}

std::optional<std::string> GameText(const Json &value) {
    if (value.is_null()) {
        return std::nullopt;
    }
    if (value.is_string()) {
        auto text = legacy_encoding::GameText(value.get<std::string>());
        if (text.contains('\0')) {
            throw std::runtime_error("null byte in game text");
        }
        return text;
    }
    if (value.is_object()) {
        return GameBytes(At(value, "game_bytes").get<std::string>());
    }
    throw std::runtime_error("expected game text");
}

std::string Text(const Json &object, const char *key) {
    auto text = GameText(At(object, key));
    if (!text) {
        throw std::runtime_error(std::string(key) + " is null");
    }
    return std::move(*text);
}

std::string Text(const Json &object, const char *key, std::size_t capacity) {
    auto text = Text(object, key);
    if (text.size() >= capacity) {
        throw std::runtime_error(std::string(key) + " is longer than the game holds");
    }
    return text;
}

std::optional<std::string> OptionalText(const Json &object, const char *key) {
    const auto found = object.find(key);
    if (found == object.end()) {
        return std::nullopt;
    }
    return GameText(*found);
}

const Json &Array(const Json &object, const char *key) {
    const auto &value = At(object, key);
    if (!value.is_array()) {
        throw std::runtime_error(std::string(key) + " is not an array");
    }
    return value;
}

const Json &OptionalArray(const Json &object, const char *key) {
    static const Json empty = Json::array();
    const auto        found = object.find(key);
    if (found == object.end()) {
        return empty;
    }
    if (!found->is_array()) {
        throw std::runtime_error(std::string(key) + " is not an array");
    }
    return *found;
}

std::vector<int> IntList(const Json &object, const char *key) {
    std::vector<int> out;
    for (const auto &item : Array(object, key)) {
        out.push_back(Int(item));
    }
    return out;
}

RawValue Raw(const Json &value) {
    RawValue out;
    if (value.is_number_integer()) {
        out.type = RawValue::Type::Int;
        out.integer = Int(value);
    } else if (value.is_object() && value.contains("float")) {
        out.type = RawValue::Type::Float;
        out.real = Float(value.at("float"));
    } else if (auto text = GameText(value)) {
        out.type = RawValue::Type::String;
        out.text = std::move(*text);
    }
    return out;
}
} // namespace native_config
