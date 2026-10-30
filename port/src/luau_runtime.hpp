#pragma once

#include <cstdint>
#include <filesystem>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <variant>
#include <vector>

#include "runscript.hpp"

/**
 *
 * Runs action, effect, monster and event scripts as Luau modules in place of the retail script interpreter, exposing the native script commands to them.
 *
 */
namespace luau_runtime {

/**
 *
 * A tagged value emitted by an argument-data module.
 *
 */
using EventArgValue = std::variant<std::int32_t, float, std::string>;

/**
 *
 * One ordered command emitted by an argument-data module.
 *
 */
struct EventArgAction {
    int                        command = 0; /**< Numeric argument command identifier. */
    std::vector<EventArgValue> args;        /**< Typed values passed to the command. */
};

/**
 *
 * Builds the in-memory program the file layer returns in place of a script's bytes, naming the module Luau runs.
 *
 */
std::string MakeHandle(std::string_view module);

/**
 *
 * Returns the module a program names when it is a Luau handle, or nullopt for retail program data.
 *
 */
std::optional<std::string> HandleModule(std::span<const char> program);

/**
 *
 * Returns the Luau module for a folded .stb data key, or nullopt when the interpreter keeps running it.
 *
 */
std::optional<std::string> ModuleForScript(std::string_view key);

/**
 *
 * Loads the ordered argument commands of an event argument-data module, or nullopt when the module is missing or malformed.
 *
 */
std::optional<std::vector<EventArgAction>> ReadEventArgData(std::string_view module);

/**
 *
 * Loads a module's programs into a script instance.
 *
 */
void Load(CRunScript *script, std::string_view module);

/**
 *
 * Reports whether Luau runs this script instance.
 *
 */
bool Owns(const CRunScript *script);

/**
 *
 * Drops the Luau state a script instance holds.
 *
 */
void Forget(CRunScript *script);

/**
 *
 * Retires an arena-backed instance when its exact interpreter stack allocation expires.
 *
 */
void BindStorage(CRunScript *script, dc2::memory::ArenaBuffer anchor,
                 std::optional<dc2::memory::ArenaBuffer> controller);

/**
 *
 * Runs a program of a script instance, returning -1 when the program is missing, 0 when it finished and 1 when it suspended.
 *
 */
int Run(CRunScript *script, int no);

/**
 *
 * Resumes a suspended program of a script instance.
 *
 */
void Resume(CRunScript *script);

/**
 *
 * Enters skip mode and resumes a suspended program, which runs through its waits to the next skip end.
 *
 */
void Skip(CRunScript *script);

/**
 *
 * Reports whether the instance's program table holds a program under the number.
 *
 */
bool HasProgram(const CRunScript *script, int no);

/**
 *
 * Overrides the scripts directory the modules load from; an empty path restores the search.
 *
 */
void SetScriptsRoot(const std::filesystem::path &root);

/**
 *
 * Sets how many interrupts one program entry may take before the script is stopped.
 *
 */
void SetInterruptBudget(std::int64_t interrupts);

/**
 *
 * Closes the Luau state and forgets every script instance.
 *
 */
void Shutdown();

} // namespace luau_runtime
