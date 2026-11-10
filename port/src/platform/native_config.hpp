#pragma once

#include <nlohmann/json.hpp>

#include <array>
#include <cstddef>
#include <cstdio>
#include <exception>
#include <functional>
#include <memory>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

/**
 * Reads native semantic configuration documents (schema 2) through datapack priority.
 */
namespace native_config {
using Json = nlohmann::json;

/**
 * Schema version of every native configuration document.
 */
inline constexpr int kSchemaVersion = 2;

/**
 * Lists the parsed JSON of every datapack candidate of a converted-data-relative path in priority order.
 */
std::vector<std::shared_ptr<const Json>> Candidates(std::string_view relative, std::vector<std::string> &names);

/**
 * Parses the JSON of a host save-directory file such as "host:gyorace.cfg.json".
 */
std::shared_ptr<const Json> Host(std::string_view host_name, std::string &error);

/**
 * Returns the converted-data-relative file a loaded configuration buffer was read from.
 */
std::optional<std::string> BufferPath(const void *buffer);

/**
 * Returns the converted-data-relative file a game path names, after its device and directory rules.
 */
std::optional<std::string> GamePath(const char *game_name);

/**
 * Throws unless a document has the native envelope with the requested kind.
 */
void CheckKind(const Json &document, std::string_view kind);

/**
 * Prints one configuration diagnostic for a document that could not be used.
 */
void Report(std::string_view path, std::string_view error);

/**
 * Parses the highest-priority candidate of a path whose envelope and typed contents are valid.
 */
template <typename T>
std::optional<T> Read(std::string_view relative, std::string_view kind, const std::function<T(const Json &)> &parse) {
    std::vector<std::string> names;
    const auto               documents = Candidates(relative, names);
    for (std::size_t index = 0; index < documents.size(); ++index) {
        try {
            CheckKind(*documents[index], kind);
            return parse(*documents[index]);
        } catch (const std::exception &exception) {
            Report(names[index], exception.what());
        }
    }
    if (documents.empty()) {
        Report(relative, "native configuration document missing");
    }
    return std::nullopt;
}

/**
 * Parses a configuration named by a game path, or by a "host:" save-directory path.
 */
template <typename T>
std::optional<T> ReadGame(const char *game_name, std::string_view kind, const std::function<T(const Json &)> &parse) {
    const std::string_view name = game_name != nullptr ? game_name : "";
    if (name.starts_with("host:") || name.starts_with("host0:")) {
        std::string error;
        if (const auto document = Host(name, error)) {
            try {
                CheckKind(*document, kind);
                return parse(*document);
            } catch (const std::exception &exception) {
                Report(name, exception.what());
                return std::nullopt;
            }
        }
        if (!error.empty()) {
            Report(name, error);
            return std::nullopt;
        }
    }
    const auto path = GamePath(game_name);
    return Read(path ? *path : std::string(name), kind, parse);
}

/**
 * Parses the configuration whose bytes a retail loader read into a buffer.
 */
template <typename T>
std::optional<T> ReadBuffer(const void *buffer, std::string_view kind, const std::function<T(const Json &)> &parse) {
    const auto path = BufferPath(buffer);
    if (!path) {
        Report("<buffer>", "configuration buffer has no native source");
        return std::nullopt;
    }
    return Read(*path, kind, parse);
}

/**
 * Returns a required member of an object.
 */
const Json &At(const Json &object, const char *key);
/**
 * Reads a 32-bit integer.
 */
int Int(const Json &value);
/**
 * Reads a finite number as a float.
 */
float Float(const Json &value);
/**
 * Reads a required integer member.
 */
int Int(const Json &object, const char *key);
/**
 * Reads a required float member.
 */
float Float(const Json &object, const char *key);
/**
 * Reads an optional integer member.
 */
std::optional<int> OptionalInt(const Json &object, const char *key);
/**
 * Reads an optional float member.
 */
std::optional<float> OptionalFloat(const Json &object, const char *key);
/**
 * Encodes readable game text, or a {"text","game_bytes"} object, as the game's CP932 bytes; null gives nothing.
 */
std::optional<std::string> GameText(const Json &value);
/**
 * Reads a required, non-null game text member.
 */
std::string Text(const Json &object, const char *key);
/**
 * Reads a required, non-null game text member that must fit a buffer of the given size with its terminator.
 */
std::string Text(const Json &object, const char *key, std::size_t capacity);
/**
 * Reads a game text member that may be null or missing.
 */
std::optional<std::string> OptionalText(const Json &object, const char *key);
/**
 * Returns a required array member.
 */
const Json &Array(const Json &object, const char *key);
/**
 * Returns an optional array member, or an empty array.
 */
const Json &OptionalArray(const Json &object, const char *key);

/**
 * Reads a fixed-length array of floats.
 */
template <std::size_t N>
std::array<float, N> Floats(const Json &object, const char *key) {
    const auto &items = Array(object, key);
    if (items.size() != N) {
        throw std::runtime_error(std::string(key) + " needs " + std::to_string(N) + " numbers");
    }
    std::array<float, N> out{};
    for (std::size_t index = 0; index < N; ++index) {
        out[index] = Float(items[index]);
    }
    return out;
}

/**
 * Reads a fixed-length array of integers.
 */
template <std::size_t N>
std::array<int, N> Ints(const Json &object, const char *key) {
    const auto &items = Array(object, key);
    if (items.size() != N) {
        throw std::runtime_error(std::string(key) + " needs " + std::to_string(N) + " integers");
    }
    std::array<int, N> out{};
    for (std::size_t index = 0; index < N; ++index) {
        out[index] = Int(items[index]);
    }
    return out;
}

/**
 * Reads an array of integers of any length.
 */
std::vector<int> IntList(const Json &object, const char *key);

/**
 * A value kept with the type its script operand had: an integer, a float or game text.
 */
struct RawValue {
    enum class Type {
        Int,    /**< An integer operand. */
        Float,  /**< A floating-point operand. */
        String, /**< A string operand. */
        Invalid /**< A missing or unreadable operand. */
    };

    Type        type = Type::Invalid; /**< Operand type. */
    int         integer = 0;          /**< Integer value. */
    float       real = 0.0f;          /**< Floating-point value. */
    std::string text;                 /**< CP932 text. */
};

/**
 * Reads a raw-typed value: an integer, {"float": x}, game text or null.
 */
RawValue Raw(const Json &value);
} // namespace native_config
