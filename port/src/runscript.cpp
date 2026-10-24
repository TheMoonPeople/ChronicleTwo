#include "common.h"

#include "luau_runtime.hpp"
#include "runscript.hpp"
#include "script_guards.hpp"

// Retail's printf diagnostics, logged as the game's own (docs/LOGGING.md).
#include "ps2_printf.hpp"

PORT_OVERRIDE void CRunScript::DeleteProgram() {
    luau_runtime::Forget(this);
    PortRetailDeleteProgram();
}

// Externals that index fixed tables or copy into fixed fields with script values are checked first, so
// out-of-range arguments are refused like an illegal call instead of reaching past the table.
PORT_OVERRIDE void CRunScript::ext(RS_STACKDATA *command, int arg_count) {
    const int index = command->val.i;
    if (index < 0 || index >= ext_func_num || ext_func_table[index] == nullptr) {
        CtPs2Printf("not found ext %d\n", index);
        return;
    }

    const auto function = ext_func_table[index];
    if (!script_guards::AllowExternal(function, command + 1, arg_count - 1, index)) {
        return;
    }
    if (function(command + 1, arg_count - 1) == 0) {
        CtPs2Printf("illegal function call ext %d\n", command->val.i);
    }
}

PORT_OVERRIDE void CRunScript::load(RS_PROG_HEADER *program, RS_STACKDATA *values, int value_count, RS_CALLDATA *calls, int call_count) {
    // A Luau handle from the file layer names the module that replaces the program; the slots stay assigned for the engine's checks.
    if (const auto module = luau_runtime::HandleModule(program)) {
        stack = values;
        stack_num = value_count;
        stack_end = values + value_count;
        call = calls;
        call_num = call_count;
        call_end = calls + call_count;
        prog = program;
        code = nullptr;
        version = RS_VERSION_2;
        luau_runtime::Load(this, *module);
        return;
    }
    luau_runtime::Forget(this);
    PortRetailLoad(program, values, value_count, calls, call_count);
}

PORT_OVERRIDE void CRunScript::resume() {
    if (luau_runtime::Owns(this)) {
        luau_runtime::Resume(this);
        return;
    }
    PortRetailResume();
}

PORT_OVERRIDE int CRunScript::run(int no) {
    if (luau_runtime::Owns(this)) {
        return luau_runtime::Run(this, no);
    }
    return PortRetailRun(no);
}

PORT_OVERRIDE int CRunScript::check_program(int no) {
    if (luau_runtime::Owns(this)) {
        return luau_runtime::HasProgram(this, no) ? 1 : 0;
    }
    // Town characters can be reset without an action program, as run() also allows.
    if (prog == nullptr) {
        return 0;
    }
    const auto *entries = reinterpret_cast<const RS_PROGDATA *>(reinterpret_cast<const char *>(prog) + prog->prog);
    for (int i = 0; i < prog->prog_num; ++i) {
        if (entries[i].no == no) {
            return 1;
        }
    }
    return 0;
}

PORT_OVERRIDE void CRunScript::skip() {
    if (luau_runtime::Owns(this)) {
        luau_runtime::Skip(this);
        return;
    }
    PortRetailSkip();
}
