#include <gtest/gtest.h>

#include <array>
#include <cmath>
#include <cstddef>
#include <limits>
#include <memory>
#include <optional>
#include <span>
#include <stdexcept>
#include <string>

#include "actionchara.hpp"
#include "dng_main.hpp"
#include "mg_memory.hpp"
#include "monster.hpp"
#include "native_script_program.hpp"
#include "runscript.hpp"
#include "runscript_opcodes.hpp"

namespace {
struct ProgramTable {
    RS_PROG_HEADER header{};
    RS_PROGDATA    entries[2]{
        {.no = 7,   .func = 0},
        {.no = 150, .func = 0}
    };

    ProgramTable() {
        header.prog = offsetof(ProgramTable, entries);
        header.prog_num = 2;
    }
};
} // namespace

TEST(RunScriptProgram, UnloadedInterpreterHasNoOptionalPrograms) {
    CRunScript script;
    ASSERT_EQ(script.prog, nullptr);
    EXPECT_EQ(script.check_program(150), 0);
}

TEST(RunScriptProgram, InvalidSerializedNameIsNotDereferencedInTypeError) {
    RS_STACKDATA operand{};
    operand.type = RS_FLOAT;
    funcdata function{};
    function.name = 0xDEADBEEFu;

    EXPECT_DEATH((void) chk_int(operand, &function), "<unnamed function>");
}

TEST(RunScriptProgram, MonsterSharedVariablesUseTheirActualArrayAtBothEnds) {
    alignas(64) u_long128 storage[2048]{};
    mgCMemory             memory;
    memory.stSetBuffer(storage, 2048);
    NativeScriptProgram program;
    CRunScript          script;
    SetMonsterExtendTable();
    ASSERT_TRUE(SetMonsterScript(&script, program.Bytes(), &memory));
    ASSERT_NE(script.ext_func_table[RS_MONSTER_EXT_V_PUSH], nullptr);
    ASSERT_NE(script.ext_func_table[RS_MONSTER_EXT_V_POP], nullptr);

    auto         manager = std::make_unique<CMonsterMan>();
    CMonsterMan *previous = ActiveMonster;
    ActiveMonster = manager.get();
    for (int index : {static_cast<int>(MONSTER_VAR_MAX), static_cast<int>(MONSTER_VAR_MAX + MONSTER_SHARE_MAX - 1)}) {
        RS_STACKDATA arguments[2]{};
        arguments[0].type = RS_INT;
        arguments[0].val.i = index;
        arguments[1].type = RS_INT;
        arguments[1].val.i = index + 100;
        EXPECT_EQ(InvokeNativeExternal(script.ext_func_table[RS_MONSTER_EXT_V_PUSH], arguments), 1);
        EXPECT_EQ(manager->shared_script_vars[index - MONSTER_VAR_MAX].i, index + 100);

        RS_STACKDATA output{};
        RS_STACKDATA outside{};
        output.type = RS_INT;
        arguments[1].type = RS_PTR;
        arguments[1].val.p = &output;
        {
            EXPECT_EQ(InvokeNativeExternal(script.ext_func_table[RS_MONSTER_EXT_V_POP], arguments, std::span(&output, 1)), 1);
            arguments[1].val.p = &outside;
            EXPECT_EQ(InvokeNativeExternal(script.ext_func_table[RS_MONSTER_EXT_V_POP], arguments, std::span(&output, 1)), 0);
        }
        EXPECT_EQ(output.val.i, index + 100);
    }
    ActiveMonster = previous;
}

TEST(RunScriptProgram, LoadedProgramLookupAndDeletion) {
    ProgramTable program;
    CRunScript   script;
    script.prog = &program.header;
    EXPECT_EQ(script.check_program(7), 1);
    EXPECT_EQ(script.check_program(150), 1);
    EXPECT_EQ(script.check_program(151), 0);
    script.DeleteProgram();
    EXPECT_EQ(script.check_program(150), 0);
}

TEST(RunScriptProgram, TownCharacterResetsWithoutAnActionProgram) {
    CActionChara character{};
    character.Initialize(nullptr);
    ASSERT_EQ(character.script.prog, nullptr);
    character.add_speed = 3.0f;
    character.add_time = 5;
    character.blow_speed = 4.0f;
    character.blow_time = 7;
    character.ResetAction();
    EXPECT_EQ(character.add_speed, 0.0f);
    EXPECT_EQ(character.add_time, 0);
    EXPECT_EQ(character.blow_speed, 0.0f);
    EXPECT_EQ(character.blow_time, 0);
    EXPECT_EQ(character.prog_no, ACTION_PROG_MAIN);
}

namespace {
/**
 *
 * Executes one arithmetic operation through a complete native bytecode program.
 *
 */
int ArithmeticResult(int operation, int left, int right, std::optional<float> float_left = {}) {
    struct ArithmeticProgram {
        RS_PROG_HEADER header{};
        RS_PROGDATA    entry{};
        funcdata       function{};
        vmcode_t       instructions[4]{};
    } program;

    std::memcpy(program.header.magic, "SB2", 3);
    program.header.main = offsetof(ArithmeticProgram, function);
    program.header.code = offsetof(ArithmeticProgram, instructions);
    program.header.prog = offsetof(ArithmeticProgram, entry);
    program.header.prog_num = 1;
    program.entry.no = 100;
    program.entry.func = offsetof(ArithmeticProgram, function);
    program.instructions[0] = {.op = RS_OP_PUSH_CONST, .arg1 = RS_CONST_INT, .arg2 = left};
    program.instructions[1] = {.op = RS_OP_PUSH_CONST, .arg1 = RS_CONST_INT, .arg2 = right};
    program.instructions[2] = {.op = operation};
    program.instructions[3] = {.op = RS_OP_RET};
    if (float_left) {
        program.instructions[0].arg1 = RS_CONST_FLOAT;
        program.instructions[0].arg2_float = *float_left;
    }
    if (operation == RS_OP_NEG || operation == RS_OP_FTOI) {
        program.instructions[1] = program.instructions[2];
        program.instructions[2] = program.instructions[3];
    }
    std::array<RS_STACKDATA, 16> values{};
    std::array<RS_CALLDATA, 4>   calls{};
    CRunScript                   script;
    if (!script.load(ProgramBytes(program), values, calls)) {
        throw std::runtime_error("arithmetic program rejected");
    }
    script.run(100);
    return script.result;
}
} // namespace

TEST(RunScriptProgram, IntegerArithmeticKeepsItsLow32BitsAtSignedBoundaries) {
    constexpr int maximum = std::numeric_limits<int>::max();
    constexpr int minimum = std::numeric_limits<int>::min();
    EXPECT_EQ(ArithmeticResult(RS_OP_ADD, maximum, 1), minimum);
    EXPECT_EQ(ArithmeticResult(RS_OP_SUB, minimum, 1), maximum);
    EXPECT_EQ(ArithmeticResult(RS_OP_MUL, maximum, 2), -2);
    EXPECT_EQ(ArithmeticResult(RS_OP_NEG, minimum, 0), minimum);
    EXPECT_EQ(ArithmeticResult(RS_OP_DIV, minimum, -1), minimum);
    EXPECT_EQ(ArithmeticResult(RS_OP_MOD, minimum, -1), 0);
}

TEST(RunScriptProgram, FloatIntegerConversionRejectsNonfiniteAndOverflowingValues) {
    EXPECT_EQ(ArithmeticResult(RS_OP_FTOI, 0, 0, 127.9f), 127);
    EXPECT_DEATH((void) ArithmeticResult(RS_OP_FTOI, 0, 0, std::numeric_limits<float>::infinity()), "script float exceeds integer range");
    EXPECT_DEATH((void) ArithmeticResult(RS_OP_FTOI, 0, 0, std::numeric_limits<float>::quiet_NaN()), "script float exceeds integer range");
    EXPECT_DEATH((void) ArithmeticResult(RS_OP_FTOI, 0, 0, 2147483648.0f), "script float exceeds integer range");
}

TEST(RunScriptProgram, LoaderRejectsAnUnalignedProgramEntryTable) {
    NativeScriptProgram program;
    program.header.prog += 1;
    std::memmove(reinterpret_cast<u8 *>(&program) + program.header.prog, &program.entry, sizeof program.entry);
    std::array<RS_STACKDATA, 16> values{};
    std::array<RS_CALLDATA, 4>   calls{};
    CRunScript                   script;
    EXPECT_FALSE(script.load(program.Bytes(), values, calls));
    EXPECT_EQ(script.prog, nullptr);
}

TEST(RunScriptProgram, FloatIntegerConversionChecksBothRepresentableEdgesInWiderPrecision) {
    const float upper = 2147483648.0f;
    const float lower = -2147483648.0f;
    EXPECT_EQ(ArithmeticResult(RS_OP_FTOI, 0, 0, std::nextafter(upper, 0.0f)), 2147483520);
    EXPECT_EQ(ArithmeticResult(RS_OP_FTOI, 0, 0, lower), std::numeric_limits<int>::min());
    EXPECT_DEATH((void) ArithmeticResult(RS_OP_FTOI, 0, 0, std::nextafter(lower, -std::numeric_limits<float>::infinity())),
                 "script float exceeds integer range");
}

TEST(RunScriptProgram, UnknownOpcodeStopsBeforeReadingBeyondTheProgram) {
    NativeScriptProgram program;
    program.code.op = std::numeric_limits<int>::max();
    std::array<RS_STACKDATA, 16> values{};
    std::array<RS_CALLDATA, 4>   calls{};
    CRunScript                   script;
    ASSERT_TRUE(script.load(program.Bytes(), values, calls));
    EXPECT_DEATH((void) script.run(100), "invalid script opcode");
}

TEST(RunScriptProgram, ExecutionWithoutAProgramExtentCannotReadTheInstructionPointer) {
    CRunScript script;
    EXPECT_DEATH(script.exe(reinterpret_cast<vmcode_t *>(std::uintptr_t{1})), "invalid script instruction");
}

TEST(RunScriptProgram, RetainedTextSurvivesSourceDestructionAndReusesImmutableArenaEntries) {
    std::array<u_long128, 2048> storage{};
    mgCMemory                   memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    NativeScriptProgram program;
    CRunScript          script;
    SetMonsterExtendTable();
    ASSERT_TRUE(SetMonsterScript(&script, program.Bytes(), &memory));
    dc2::script::OwnedText retained;
    EXPECT_FALSE(retained.HasValue());
    const std::string expected(400, 'f');
    {
        std::string source = expected;
        retained = script.RetainText(source);
        source.assign(source.size(), 'x');
    }
    ASSERT_TRUE(retained.Text());
    EXPECT_EQ(*retained.Text(), expected);
    const auto copy = retained;
    const int  remaining = memory.stGetRest();
    if (remaining > 1) {
        ASSERT_NE(memory.stAlloc(remaining - 1), nullptr);
    }
    memory.stSetLocked(true);
    ASSERT_EQ(memory.stAlloc(1), nullptr);
    const int full_used = memory.stack_used;
    for (int index = 0; index < 100; ++index) {
        EXPECT_EQ(script.RetainText(expected).CString(), retained.CString());
    }
    EXPECT_EQ(memory.stack_used, full_used);
    script.RetainText("new text in a locked full arena");
    EXPECT_EQ(memory.stack_used, full_used);
    script.RetainText("different frame name");
    ASSERT_TRUE(copy.Text());
    EXPECT_EQ(*copy.Text(), expected);
}

TEST(RunScriptProgram, RetainedTextRejectsRetiredAllocationEvenAfterItsAddressIsReused) {
    std::array<u_long128, 2048> storage{};
    mgCMemory                   memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    NativeScriptProgram program;
    CRunScript          script;
    SetMonsterExtendTable();
    ASSERT_TRUE(SetMonsterScript(&script, program.Bytes(), &memory));
    const auto old = script.RetainText("before");
    memory.stClearUsed();
    EXPECT_TRUE(old.HasValue());
    EXPECT_EQ(old.CString(), nullptr);
    EXPECT_FALSE(old.Text());
    EXPECT_THROW((void) script.RetainText("retired"), dc2::script::ArgumentError);
    ASSERT_TRUE(SetMonsterScript(&script, program.Bytes(), &memory));
    const auto current = script.RetainText("after!");
    EXPECT_FALSE(old.Text());
    ASSERT_TRUE(current.Text());
    EXPECT_EQ(*current.Text(), "after!");
}

TEST(RunScriptProgram, RetainedTextValidatesItsAllocatorLeaseBeforeTheOwnerCanBeDereferenced) {
    std::array<u_long128, 2048> storage{};
    NativeScriptProgram         program;
    CRunScript                  script;
    dc2::script::OwnedText      retained;
    {
        mgCMemory memory;
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        SetMonsterExtendTable();
        ASSERT_TRUE(SetMonsterScript(&script, program.Bytes(), &memory));
        retained = script.RetainText("owner scope");
    }
    EXPECT_FALSE(retained.Text());
    EXPECT_THROW((void) script.RetainText("after owner destruction"), dc2::script::ArgumentError);
}

TEST(RunScriptProgram, RetainedTextFollowsItsCompletedHeapBlockInsteadOfTheCurrentStack) {
    std::array<u_long128, 2048> storage{};
    mgCMemory                   memory;
    memory.SetHeapMem(storage.data(), static_cast<int>(storage.size()));
    NativeScriptProgram program;
    CRunScript          first;
    CRunScript          second;
    SetMonsterExtendTable();
    auto *first_block = memory.StartStackMode(MG_STACK_MODE_FIT, 256);
    ASSERT_NE(first_block, nullptr);
    ASSERT_TRUE(SetMonsterScript(&first, program.Bytes(), &memory));
    memory.EndStackMode();
    const auto first_name = first.RetainText("completed first block");
    ASSERT_TRUE(first_name.Text());
    auto *second_block = memory.StartStackMode(MG_STACK_MODE_FIT, 256);
    ASSERT_NE(second_block, nullptr);
    ASSERT_TRUE(SetMonsterScript(&second, program.Bytes(), &memory));
    const auto second_name = second.RetainText("second block");
    memory.EndStackMode();
    ASSERT_TRUE(first_name.Text());
    ASSERT_TRUE(second_name.Text());
    memory.Free(first_block);
    EXPECT_FALSE(first_name.Text());
    EXPECT_THROW((void) first.RetainText("retired block"), dc2::script::ArgumentError);
    ASSERT_TRUE(second_name.Text());
    EXPECT_EQ(*second_name.Text(), "second block");
    memory.Free(second_block);
    EXPECT_FALSE(second_name.Text());
}
