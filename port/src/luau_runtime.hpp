#pragma once

#include <cstdint>
#include <filesystem>
#include <optional>
#include <string>
#include <string_view>

#include "runscript.hpp"

/**
 *
 * Runs action, effect and monster scripts as Luau modules in place of the retail script interpreter, exposing the native script commands to them.
 *
 */
namespace luau_runtime {

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
std::optional<std::string> HandleModule(const void *program);

/**
 *
 * Returns the Luau module for a folded .stb data key, or nullopt when the interpreter keeps running it.
 *
 */
std::optional<std::string> ModuleForScript(std::string_view key);

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
 * Returns the time Luau programs ran since the last call, in nanoseconds, and starts counting again.
 *
 */
std::uint64_t TakeScriptNanoseconds();

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
