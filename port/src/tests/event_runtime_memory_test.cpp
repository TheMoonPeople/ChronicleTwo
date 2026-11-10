#include <gtest/gtest.h>

#include <cstddef>
#include <cstring>

#include "event.hpp"
#include "mg_memory.hpp"
#include "native_script_program.hpp"
#include "platform/arena.hpp"
#include "runscript.hpp"
#include "stubs/event.hpp"

namespace {
struct EventProgram {
    RS_PROG_HEADER header{};
    RS_PROGDATA    entry{.no = 100, .func = offsetof(EventProgram, function)};
    funcdata       function{};
    vmcode_t       code{.op = RS_OP_END, .arg1 = 0, .arg2 = 0};

    EventProgram() {
        std::memcpy(header.magic, "SB2", 3);
        header.main = offsetof(EventProgram, function);
        header.code = offsetof(EventProgram, code);
        header.prog = offsetof(EventProgram, entry);
        header.prog_num = 1;
    }
};
} // namespace

TEST(EventRuntimeMemory, ScriptBytesCanUseTheRetailBufferBudget) {
    static char key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 20000 * sizeof(u_long128)));
    mgCMemory   memory;
    memory.stSetBuffer(storage, 20000);
    // The d05 chapter script occupies 19333 quadwords. Native interpreter arrays
    // need 896 more, while the retail arrays need 448 and fit the 20000 budget.
    char        *bytes = reinterpret_cast<char *>(memory.Alloc(19333));
    EventProgram program;
    std::memcpy(bytes, &program, sizeof(program));
    SetEventScript(std::span<u8>(reinterpret_cast<u8 *>(bytes), sizeof program), &memory);
    EXPECT_NE(EventScript.prog, nullptr);
    EXPECT_EQ(RunEvent(100, nullptr), 0);
    EXPECT_EQ(memory.stack_used, 19333);
    SetEventScript({}, nullptr);
    EXPECT_EQ(RunEvent(100, nullptr), -1);
}

TEST(EventRuntimeMemory, ReplacingAProgramRetainsTheInterpreterStackCapacity) {
    EventProgram first;
    EventProgram second;
    second.entry.no = 101;
    alignas(64) u_long128 storage[1024]{};
    mgCMemory             memory;
    memory.stSetBuffer(storage, 1024);
    SetEventScript(ProgramBytes(first), &memory);
    EXPECT_EQ(RunEvent(100, nullptr), 0);
    SetEventScript(ProgramBytes(second), &memory);
    EXPECT_EQ(RunEvent(101, nullptr), 0);
    EXPECT_EQ(RunEvent(100, nullptr), -1);
    SetEventScript({}, nullptr);
}
