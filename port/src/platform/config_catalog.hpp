#pragma once

#include <nlohmann/json_fwd.hpp>

#include <filesystem>
#include <memory>
#include <optional>
#include <string>
#include <string_view>
#include <variant>
#include <vector>

namespace config_catalog {
/**
 * Holds one typed argument with strings already encoded for native game callbacks.
 */
struct Argument {
    std::variant<std::monostate, int, float, std::string> value; /**< Invalid, integer, floating-point, or game-text value. */
};

/**
 * Holds a command selected by readable tag name or the original tag-table index.
 */
struct Command {
    std::string           name;      /**< Named text-script command, or empty for an indexed binary command. */
    std::optional<int>    index;     /**< Original binary tag-table index when the command uses one. */
    std::vector<Argument> arguments; /**< Ordered typed arguments for the command's callback. */
};

/**
 * Contains decoded native commands from one converted configuration document.
 */
struct Document {
    std::vector<Command> commands; /**< Commands executed in document order. */
};

/**
 * Loads extraction-owned source identities for native JSON configuration documents.
 */
bool Load(const std::filesystem::path &catalog, std::string &error);
/**
 * Clears catalog identities and cached configuration documents.
 */
void Clear();
/**
 * Tests whether a retail configuration identity has a converted document.
 */
bool Contains(std::string_view alias);
/**
 * Lists native configuration documents through datapack priority for specialized configuration consumers.
 */
std::vector<std::filesystem::path> Paths(std::string_view alias);
/**
 * Reads typed configuration commands through datapack priority with invalid-overlay fallback.
 */
std::shared_ptr<const Document> Find(std::string_view alias, std::string &error);
/**
 * Decodes a native command document without filesystem lookup or source identities.
 */
std::shared_ptr<const Document> Decode(const nlohmann::json &data, std::string &error);
} // namespace config_catalog
