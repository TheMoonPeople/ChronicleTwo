#pragma once

#include <cstddef>
#include <cstring>
#include <span>

#include "runscript.hpp"

/**
 *
 * A complete one-function SB2 program for native interpreter boundary tests.
 *
 */
struct NativeScriptProgram {
    RS_PROG_HEADER header{};
    RS_PROGDATA    entry{.no = 100, .func = offsetof(NativeScriptProgram, function)};
    funcdata       function{};
    vmcode_t       code{.op = RS_OP_END, .arg1 = 0, .arg2 = 0};

    NativeScriptProgram() {
        std::memcpy(header.magic, "SB2", 3);
        header.main = offsetof(NativeScriptProgram, function);
        header.code = offsetof(NativeScriptProgram, code);
        header.prog = offsetof(NativeScriptProgram, entry);
        header.prog_num = 1;
    }

    std::span<u8> Bytes() { return {reinterpret_cast<u8 *>(this), sizeof *this}; }
};

/**
 *
 * Views all bytes of a complete synthetic program with its actual extent.
 *
 */
template <typename Program>
std::span<u8> ProgramBytes(Program &program) {
    return {reinterpret_cast<u8 *>(&program), sizeof program};
}

/**
 *
 * Calls a registered external with explicitly scoped argument, text and writable extents.
 *
 */
inline int InvokeNativeExternal(dc2::script::RunFunction function, std::span<RS_STACKDATA> arguments,
                                std::span<RS_STACKDATA>                writable = {},
                                std::span<char>                        text = {},
                                std::span<const std::span<const char>> other_text = {}) {
    return dc2::script::InvokeRunFunction(function,
                                          dc2::script::RunArguments(arguments, text, writable, other_text),
                                          static_cast<int>(arguments.size()));
}
