#include <gtest/gtest.h>

#include <cstdint>
#include <cstring>
#include <limits>
#include <string>

#include "scriptinterpreter.hpp"

TEST(ScriptInterpreter, PushStackPreservesHostStringPointer) {
    CScriptInterpreter interpreter;
    SPI_STACK          stack[2]{};
    char               text[] = "string argument";
    ASSERT_GT(reinterpret_cast<std::uintptr_t>(text), UINT32_MAX);
    interpreter.SetStack(stack, 2);
    SPI_STACK argument{};
    argument.type = SPI_STACK_TYPE_STRING;
    argument.value.string = text;
    interpreter.PushStack(argument);
    ASSERT_EQ(interpreter.stack_count, 1);
    ASSERT_EQ(stack[0].value.string, text);
    EXPECT_STREQ(stack[0].value.string, text);
}

TEST(ScriptInterpreter, EmptyQuotedStringAndMissingArgumentKeepTheirTypes) {
    CScriptInterpreter interpreter;
    SPI_STACK          stack[4]{};
    char               strings[64]{};
    char               script[] = "\"\",,42;";
    interpreter.SetScript(script, std::strlen(script));
    interpreter.SetStack(stack, 4);
    interpreter.SetStringBuff(strings, sizeof(strings));
    ASSERT_EQ(interpreter.GetArg(), 3);
    ASSERT_EQ(interpreter.stack_count, 3);
    EXPECT_EQ(stack[0].type, SPI_STACK_TYPE_STRING);
    ASSERT_EQ(stack[0].value.string, strings);
    EXPECT_STREQ(strings, "");
    EXPECT_EQ(stack[1].type, SPI_STACK_TYPE_INVALID);
    EXPECT_EQ(stack[1].value.string, nullptr);
    EXPECT_EQ(stack[2].type, SPI_STACK_TYPE_INT);
    EXPECT_EQ(stack[2].value.integer, 42);
}

TEST(ScriptInterpreter, QuotedTextRespectsStringBufferCapacity) {
    for (const std::size_t length : {std::size_t{3}, std::size_t{4}}) {
        CScriptInterpreter interpreter;
        SPI_STACK          stack[1]{};
        char               strings[5]{'x', 'x', 'x', 'x', '!'};
        std::string        script = "\"" + std::string(length, 'a') + "\";";
        interpreter.SetScript(script.data(), static_cast<int>(script.size()));
        interpreter.SetStack(stack, 1);
        interpreter.SetStringBuff(strings, 4);

        EXPECT_EQ(interpreter.GetArg(), 1);
        EXPECT_EQ(strings[4], '!');
        EXPECT_EQ(interpreter.string_buff_next, strings + (length == 3 ? 4 : 0));
        if (length == 3) {
            ASSERT_NE(stack[0].value.string, nullptr);
            EXPECT_STREQ(stack[0].value.string, "aaa");
        } else {
            EXPECT_EQ(stack[0].value.string, nullptr);
        }
    }
}

TEST(ScriptInterpreter, NumericAndEscapedTextArgumentsKeepTheirValues) {
    CScriptInterpreter interpreter;
    SPI_STACK          stack[6]{};
    char               strings[64]{};
    char               script[] = " -7, 1.5,\"a\\\"b\",bad,12 trailing,\"\x81\x5c\";";
    interpreter.SetScript(script, std::strlen(script));
    interpreter.SetStack(stack, 6);
    interpreter.SetStringBuff(strings, sizeof(strings));
    ASSERT_EQ(interpreter.GetArg(), 6);
    EXPECT_EQ(stack[0].value.integer, -7);
    EXPECT_FLOAT_EQ(stack[1].value.real, 1.5f);
    ASSERT_EQ(stack[2].type, SPI_STACK_TYPE_STRING);
    EXPECT_STREQ(stack[2].value.string, "a\"b");
    EXPECT_EQ(stack[3].type, SPI_STACK_TYPE_INVALID);
    EXPECT_EQ(stack[3].value.string, nullptr);
    EXPECT_EQ(stack[4].value.integer, 12);
    ASSERT_EQ(stack[5].type, SPI_STACK_TYPE_STRING);
    EXPECT_STREQ(stack[5].value.string, "\x81\x5c");
}

TEST(ScriptInterpreter, DecimalArgumentsRejectMalformedAndOutOfRangeValues) {
    for (const std::string text : {".", "-.", "1.2.3", "1.-2", "9999999999999999999999999999999999999999.0",
                                   "0.00000000000000000000000000000000000000000000001"}) {
        CScriptInterpreter interpreter;
        SPI_STACK          stack[1]{};
        std::string        script = text + ";";
        interpreter.SetScript(script.data(), static_cast<int>(script.size()));
        interpreter.SetStack(stack, 1);
        ASSERT_EQ(interpreter.GetArg(), 1) << text;
        EXPECT_EQ(stack[0].type, SPI_STACK_TYPE_INVALID) << text;
    }
}

TEST(ScriptInterpreter, DecimalArgumentsPreserveSubnormalsAndSignedZero) {
    CScriptInterpreter interpreter;
    SPI_STACK          stack[3]{};
    char               script[] = "0.000000000000000000000000000000000000000000001,-0.0,.5;";
    interpreter.SetScript(script, std::strlen(script));
    interpreter.SetStack(stack, 3);
    ASSERT_EQ(interpreter.GetArg(), 3);
    for (const auto &argument : stack) {
        ASSERT_EQ(argument.type, SPI_STACK_TYPE_FLOAT);
    }
    EXPECT_EQ(stack[0].value.real, std::numeric_limits<float>::denorm_min());
    EXPECT_EQ(stack[1].value.real, 0.0f);
    EXPECT_TRUE(std::signbit(stack[1].value.real));
    EXPECT_FLOAT_EQ(stack[2].value.real, 0.5f);
}

TEST(ScriptInterpreter, ByteReaderStopsAtItsExactSourceExtent) {
    input_str input;
    char      bytes[] = {'a'};
    input.buffer = bytes;
    input.size = 1;
    int value = -1;
    EXPECT_EQ(input.get(&value), 1);
    EXPECT_EQ(value, 'a');
    EXPECT_EQ(input.get(&value), 0);
    EXPECT_EQ(value, 0);
    input.position = -1;
    EXPECT_EQ(input.get(&value), 0);
}

TEST(ScriptInterpreter, LineReaderDoesNotCompareATerminatorPastTheSourceEnd) {
    input_str input;
    char      bytes[] = {'a', 'b', 'c'};
    input.buffer = bytes;
    input.size = 3;
    char line[8];
    EXPECT_EQ(input.GetLine(line, sizeof line, nullptr), 0);
    EXPECT_STREQ(line, "abc");
    char sentinel = 'x';
    EXPECT_EQ(input.GetLine(&sentinel, 0, nullptr), 0);
    EXPECT_EQ(sentinel, 'x');
}

TEST(ScriptInterpreter, TextNumbersOutsideTheirRepresentableRangeAreInvalidSlots) {
    CScriptInterpreter interpreter;
    SPI_STACK          slots[2]{};
    char               text[] = "999999999999999999999999999999999,9999999999999999999999999999999999999999.0;";
    interpreter.buffer = text;
    interpreter.size = sizeof text - 1;
    interpreter.position = 0;
    interpreter.SetStack(slots, 2);
    EXPECT_EQ(interpreter.GetArg(), 2);
    EXPECT_EQ(slots[0].type, SPI_STACK_TYPE_INVALID);
    EXPECT_EQ(slots[1].type, SPI_STACK_TYPE_INVALID);
}
