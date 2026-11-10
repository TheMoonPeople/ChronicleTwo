#pragma once

#include <span>

#include "runscript.hpp"
#include "scriptinterpreter.hpp"

/**
 *
 * Checks the arguments of script handlers that index fixed tables or copy into fixed fields with values a script supplies.
 *
 */
namespace script_guards {

/**
 *
 * External function a run script calls.
 *
 */
using RunScriptFunction = dc2::script::RunFunction;

/**
 *
 * Whether a run-script external may be called with its arguments; a refused call is reported once per handler.
 *
 */
bool AllowExternal(RunScriptFunction function, dc2::script::RunArguments args, int argc, int index);

/**
 *
 * Guards the event externals, which retail defines static, through their slots in the event table.
 *
 */
void GuardEventExternals(std::span<RunScriptFunction> table);

} // namespace script_guards
