#pragma once

#include <nlohmann/json_fwd.hpp>

#include <string>
#include <vector>

#include "scriptinterpreter.hpp"

/**
 * Runs the typed command lists that character resources (.game.json) embed for their cloth and effect
 * scripts through those scripts' retail tag tables. These are scripts of the character model format,
 * not configuration documents; configurations are read as native semantic documents instead.
 */
namespace command_replay {

/**
 * Tells whether a script buffer holds a JSON command list rather than script text.
 */
bool IsCommandBuffer(const char *script, int size);

/**
 * Runs a {"commands": [...]} buffer through a tag table, as the interpreter runs a script.
 */
bool RunBuffer(const char *script, int size, std::span<const SPI_TAG_PARAM> tags);

/**
 * Builds the typed argument slots of one profile command, with strings kept in the given storage.
 */
std::vector<SPI_STACK> Arguments(const nlohmann::json &arguments, std::vector<std::string> &strings);

} // namespace command_replay
