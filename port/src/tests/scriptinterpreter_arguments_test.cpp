#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <cstdint>
#include <limits>
#include <optional>
#include <string>
#include <type_traits>
#include <utility>
#include <vector>

#include "command_replay.hpp"
#include "scriptinterpreter.hpp"

static_assert(!std::is_copy_constructible_v<CScriptInterpreter>);
static_assert(!std::is_copy_assignable_v<CScriptInterpreter>);
static_assert(!std::is_move_constructible_v<CScriptInterpreter>);
static_assert(!std::is_move_assignable_v<CScriptInterpreter>);

namespace {
using Json = nlohmann::json;

std::vector<std::array<float, 9>>        positions;           /**< Position arguments observed by callbacks. */
std::vector<std::array<std::string, 2>>  strings;             /**< String arguments observed by callbacks. */
std::vector<int>                         counts;              /**< Explicit argument counts observed by callbacks. */
int                                      remaining_depth = 0; /**< Additional nested text callbacks requested by a test. */
std::string                              checked_text;
int                                      checked_text_calls = 0;
std::optional<dc2::script::TagArguments> outer_arguments;

void Execute(std::string text, std::span<const SPI_TAG_PARAM> tags);

/**
 *
 * Copies one validated string from a tag invocation.
 *
 */
int CaptureCheckedText(dc2::script::TagArguments args) {
    checked_text = outer_arguments ? std::string(dc2::script::TagText(*outer_arguments)) + "/" +
                                         std::string(dc2::script::TagText(args))
                                   : std::string(dc2::script::TagText(args));
    ++checked_text_calls;
    return 1;
}

/**
 *
 * Reads a newly supplied string and a still-live inherited string.
 *
 */
int CaptureCheckedPair(dc2::script::TagArguments args, int explicit_count) {
    strings.push_back({std::string(dc2::script::TagText(args)),
                       std::string(dc2::script::TagText(args + 1))});
    counts.push_back(explicit_count);
    return 1;
}

/**
 *
 * Keeps an outer string readable while another interpreter invokes a tag.
 *
 */
int CaptureNestedCheckedText(dc2::script::TagArguments args) {
    const std::string before(dc2::script::TagText(args));
    outer_arguments = args;
    char          name[] = "INNER";
    SPI_TAG_PARAM tags[]{
        {.name = name,    .function = dc2::script::AdaptTagArguments<CaptureCheckedText>},
        {.name = nullptr, .function = nullptr                                           }
    };
    Execute("INNER \"nested\";", tags);
    outer_arguments.reset();
    strings.push_back({before, std::string(dc2::script::TagText(args))});
    return 1;
}

/**
 * Executes an independent text script, or a typed command list as character resources embed, with the supplied callback table.
 */
void Execute(std::string text, std::span<const SPI_TAG_PARAM> tags) {
    if (command_replay::IsCommandBuffer(text.data(), static_cast<int>(text.size()))) {
        ASSERT_TRUE(command_replay::RunBuffer(text.data(), static_cast<int>(text.size()), tags));
        return;
    }
    CScriptInterpreter interpreter;
    interpreter.SetScript(text.data(), static_cast<int>(text.size()));
    interpreter.SetTag(tags);
    interpreter.Run();
}

/**
 * Captures all position slots and optionally runs an independent nested script.
 */
int CapturePosition(dc2::script::TagArguments stack, int count) {
    std::array<float, 9> values{};
    for (std::size_t index = 0; index < values.size(); ++index) {
        values[index] = dc2::script::TagFloat(stack + index);
    }
    positions.push_back(values);
    counts.push_back(count);
    if (count == 9 && remaining_depth > 0) {
        const int     value = 100 + remaining_depth--;
        char          name[] = "POS";
        SPI_TAG_PARAM tags[]{
            {.name = name,    .function = dc2::script::AdaptTagArguments<CapturePosition>},
            {.name = nullptr, .function = nullptr                                        }
        };
        Execute("POS 0,1,2,3,4,5,6," + std::to_string(value) + "," + std::to_string(value) + ";POS 7,8,9,10,11,12,13;", tags);
    }
    return 0;
}

/**
 * Copies the current and inherited strings while callback storage is alive.
 */
int CaptureStrings(dc2::script::TagArguments stack, int count) {
    std::array<std::string, 2> values;
    for (std::size_t index = 0; index < values.size(); ++index) {
        const char *text = dc2::script::TagCString(stack + index);
        values[index] = text ? text : "<missing>";
    }
    strings.push_back(std::move(values));
    counts.push_back(count);
    return 0;
}

/**
 * Builds typed native position commands with two inherited trailing scales.
 */
std::string NativePositions() {
    Json commands = Json::array();
    for (int count : {9, 7}) {
        Json arguments = Json::array();
        for (int index = 0; index < count; ++index) {
            arguments.push_back({
                {"type",  "float"                                       },
                {"value", index < 7 ? static_cast<float>(index) : 100.0f}
            });
        }
        commands.push_back({
            {"command", "POS"    },
            {"args",    arguments}
        });
    }
    return Json{
        {"schema_version", 1       },
        {"commands",       commands}
    }
        .dump();
}

/**
 * Isolates callback captures and nested execution limits for each script test.
 */
class ScriptArguments : public testing::Test {
protected:
    void SetUp() override {
        positions.clear();
        strings.clear();
        counts.clear();
        remaining_depth = 0;
        checked_text.clear();
        checked_text_calls = 0;
        outer_arguments.reset();
    }

    void TearDown() override { remaining_depth = 0; }
};

/**
 * Checks each nested callback's scales after deeper scripts have returned.
 */
void ExpectNestedPositions() {
    ASSERT_EQ(positions.size(), 26u);
    ASSERT_EQ(counts.size(), positions.size());
    for (std::size_t index = 0; index < 13; ++index) {
        const float expected = index == 0 ? 100.0f : static_cast<float>(113 - index);
        const auto  reverse = positions.size() - index - 1;
        EXPECT_EQ(counts[index], 9);
        EXPECT_EQ(counts[reverse], 7);
        for (std::size_t slot : {7u, 8u}) {
            EXPECT_FLOAT_EQ(positions[index][slot], expected);
            EXPECT_FLOAT_EQ(positions[reverse][slot], expected);
        }
    }
}
} // namespace

TEST_F(ScriptArguments, CheckedNativeTextUsesItsOwnedBytesAndRejectsWrongKinds) {
    char          name[] = "TEXT";
    SPI_TAG_PARAM tags[]{
        {.name = name,    .function = dc2::script::AdaptTagArguments<CaptureCheckedText>},
        {.name = nullptr, .function = nullptr                                           }
    };
    Execute(R"({"commands":[{"command":"TEXT","args":[{"type":"string","game_bytes":"824f"}]}]})", tags);
    EXPECT_EQ(checked_text, std::string("\x82\x4f", 2));
    EXPECT_EQ(checked_text_calls, 1);

    Execute(R"({"commands":[{"command":"TEXT","args":[{"type":"int","value":7}]}]})", tags);
    EXPECT_EQ(checked_text, std::string("\x82\x4f", 2));
    EXPECT_EQ(checked_text_calls, 1);
}

TEST_F(ScriptArguments, CheckedNativeTextRetainsInitializedSlotsButRejectsMissingAndOverwrittenValues) {
    char          name[] = "TEXT";
    SPI_TAG_PARAM tags[]{
        {.name = name,    .function = dc2::script::AdaptTagArguments<CaptureCheckedPair>},
        {.name = nullptr, .function = nullptr                                           }
    };
    Execute(R"({"commands":[{"command":"TEXT","args":[]}]})", tags);
    EXPECT_TRUE(strings.empty());

    Execute(R"({"commands":[{"command":"TEXT","args":[{"type":"string","value":"first"},{"type":"string","value":"retained"}]},{"command":"TEXT","args":[{"type":"string","value":"later"}]},{"command":"TEXT","args":[{"type":"int","value":7}]}]})", tags);
    ASSERT_EQ(strings.size(), 2u);
    EXPECT_EQ(strings[0], (std::array<std::string, 2>{"first", "retained"}));
    EXPECT_EQ(strings[1], (std::array<std::string, 2>{"later", "retained"}));
    EXPECT_EQ(counts, (std::vector<int>{2, 1}));
}

TEST_F(ScriptArguments, CheckedTextParserRetainsStringSlotsAcrossShorterTags) {
    char          name[] = "TEXT";
    SPI_TAG_PARAM tags[]{
        {.name = name,    .function = dc2::script::AdaptTagArguments<CaptureCheckedPair>},
        {.name = nullptr, .function = nullptr                                           }
    };
    Execute("TEXT;", tags);
    EXPECT_TRUE(strings.empty());
    Execute("TEXT \"first\",\"retained\";TEXT \"later\";", tags);
    ASSERT_EQ(strings.size(), 2u);
    EXPECT_EQ(strings[0], (std::array<std::string, 2>{"first", "retained"}));
    EXPECT_EQ(strings[1], (std::array<std::string, 2>{"later", "retained"}));
    EXPECT_EQ(counts, (std::vector<int>{2, 1}));
    Execute("TEXT;", tags);
    EXPECT_EQ(strings.size(), 2u);
}

TEST_F(ScriptArguments, CheckedOuterStringSurvivesNestedInterpreterDispatch) {
    char          name[] = "TEXT";
    SPI_TAG_PARAM tags[]{
        {.name = name,    .function = dc2::script::AdaptTagArguments<CaptureNestedCheckedText>},
        {.name = nullptr, .function = nullptr                                                 }
    };
    Execute("TEXT \"outer\";", tags);
    ASSERT_EQ(strings.size(), 1u);
    EXPECT_EQ(strings.front(), (std::array<std::string, 2>{"outer", "outer"}));
    EXPECT_EQ(checked_text, "outer/nested");
}

TEST_F(ScriptArguments, NativeCommandsRetainOmittedTrailingScales) {
    char          name[] = "POS";
    SPI_TAG_PARAM tags[]{
        {.name = name,    .function = dc2::script::AdaptTagArguments<CapturePosition>},
        {.name = nullptr, .function = nullptr                                        }
    };
    Execute(NativePositions(), tags);
    ASSERT_EQ(positions.size(), 2u);
    EXPECT_EQ(counts, (std::vector<int>{9, 7}));
    EXPECT_FLOAT_EQ(positions[1][7], 100.0f);
    EXPECT_FLOAT_EQ(positions[1][8], 100.0f);
}

TEST_F(ScriptArguments, NativeInheritedStringsSurviveShorterAndLongerArgumentReplacements) {
    Json              commands = Json::array();
    const std::string retained(4096, 'r');
    commands.push_back({
        {"command", "TEXT"                                                                                            },
        {"args",    Json::array({{{"type", "string"}, {"value", "first"}}, {{"type", "string"}, {"value", retained}}})}
    });
    for (const std::string &value : {std::string(2048, 'x'), std::string("short")}) {
        commands.push_back({
            {"command", "TEXT"                                               },
            {"args",    Json::array({{{"type", "string"}, {"value", value}}})}
        });
    }
    char          name[] = "TEXT";
    SPI_TAG_PARAM tags[]{
        {.name = name,    .function = dc2::script::AdaptTagArguments<CaptureStrings>},
        {.name = nullptr, .function = nullptr                                       }
    };
    Execute(Json{
                {"schema_version", 1       },
                {"commands",       commands}
    }
                .dump(),
            tags);
    ASSERT_EQ(strings.size(), 3u);
    EXPECT_EQ(counts, (std::vector<int>{2, 1, 1}));
    EXPECT_EQ(strings[1][0], std::string(2048, 'x'));
    EXPECT_EQ(strings[2][0], "short");
    for (const auto &values : strings) {
        EXPECT_EQ(values[1], retained);
    }
}

TEST_F(ScriptArguments, TextCallbackStorageRemainsStableBeyondEightNestedScripts) {
    remaining_depth = 12;
    char          name[] = "POS";
    SPI_TAG_PARAM tags[]{
        {.name = name,    .function = dc2::script::AdaptTagArguments<CapturePosition>},
        {.name = nullptr, .function = nullptr                                        }
    };
    Execute("POS 0,1,2,3,4,5,6,100,100;POS 7,8,9,10,11,12,13;", tags);
    ExpectNestedPositions();
}

TEST_F(ScriptArguments, NativeArgumentsRemainIsolatedFromNestedTextScripts) {
    remaining_depth = 12;
    char          name[] = "POS";
    SPI_TAG_PARAM tags[]{
        {.name = name,    .function = dc2::script::AdaptTagArguments<CapturePosition>},
        {.name = nullptr, .function = nullptr                                        }
    };
    Execute(NativePositions(), tags);
    ExpectNestedPositions();
}

TEST_F(ScriptArguments, AlternatingInterpretersRetainTheirOwnInheritedSlots) {
    char          name[] = "PAIR";
    SPI_TAG_PARAM tags[] = {
        {name,    dc2::script::AdaptTagArguments<CaptureCheckedPair>},
        {nullptr, nullptr                                           },
    };
    std::string        first_text = "PAIR \"first\",\"first-tail\";PAIR \"next-first\";";
    std::string        second_text = "PAIR \"second\",\"second-tail\";PAIR \"next-second\";";
    CScriptInterpreter first;
    CScriptInterpreter second;
    first.SetScript(first_text.data(), static_cast<int>(first_text.size()));
    second.SetScript(second_text.data(), static_cast<int>(second_text.size()));
    first.SetTag(tags);
    second.SetTag(tags);
    ASSERT_GE(first.GetNextTAG(1), 0);
    ASSERT_GE(second.GetNextTAG(1), 0);
    ASSERT_GE(first.GetNextTAG(1), 0);
    ASSERT_GE(second.GetNextTAG(1), 0);
    ASSERT_EQ(strings.size(), 4u);
    EXPECT_EQ(strings[2][0], "next-first");
    EXPECT_EQ(strings[2][1], "first-tail");
    EXPECT_EQ(strings[3][0], "next-second");
    EXPECT_EQ(strings[3][1], "second-tail");
    EXPECT_EQ(counts, (std::vector<int>{2, 2, 1, 1}));
}

TEST_F(ScriptArguments, AssigningNewScriptDiscardsInheritedSlots) {
    char          name[] = "PAIR";
    SPI_TAG_PARAM tags[] = {
        {name,    dc2::script::AdaptTagArguments<CaptureCheckedPair>},
        {nullptr, nullptr                                           },
    };
    std::string        previous = "PAIR \"old\",\"old-tail\";";
    std::string        replacement = "PAIR \"new\";";
    CScriptInterpreter interpreter;
    interpreter.SetTag(tags);
    interpreter.SetScript(previous.data(), static_cast<int>(previous.size()));
    interpreter.Run();
    ASSERT_EQ(strings.size(), 1u);
    interpreter.SetScript(replacement.data(), static_cast<int>(replacement.size()));
    interpreter.Run();
    EXPECT_EQ(strings.size(), 1u);
}

TEST_F(ScriptArguments, NativeCommandsRejectOutOfRangeAndMistypedNumericPayloadsBeforeConversion) {
    char          name[] = "TEXT";
    SPI_TAG_PARAM tags[] = {
        {name,    dc2::script::AdaptTagArguments<CaptureCheckedText>},
        {nullptr, nullptr                                           }
    };
    const std::array<std::pair<std::string, Json>, 3> malformed{
        {
         {"int", 1e100},
         {"int", std::numeric_limits<std::uint64_t>::max()},
         {"float", 1e100},
         }
    };
    for (const auto &[kind, value] : malformed) {
        const Json document = {
            {"commands", Json::array({{{"command", "TEXT"}, {"args", Json::array({{{"type", kind}, {"value", value}}})}}})}
        };
        const std::string text = document.dump();
        EXPECT_FALSE(command_replay::RunBuffer(text.data(), static_cast<int>(text.size()), tags));
    }
    EXPECT_EQ(checked_text_calls, 0);
}

TEST_F(ScriptArguments, TruncatedBinaryTagCannotReuseAPreviousTagsStringArgument) {
    char          name[] = "TEXT";
    SPI_TAG_PARAM tags[] = {
        {name,    dc2::script::AdaptTagArguments<CaptureCheckedText>},
        {nullptr, nullptr                                           }
    };
    std::string program{'B', 'I', 'N', 0};
    const auto  append_short = [&](std::int16_t value) {
        program.append(reinterpret_cast<const char *>(&value), sizeof value);
    };
    const auto tag_header = [&] {
        append_short(0);
        append_short(1);
        program.push_back(static_cast<char>(SPI_BINARY_ARG_TYPE_STRING));
        while (program.size() % 4 != 0) {
            program.push_back(0);
        }
    };
    tag_header();
    program.append("first", 6);
    while (program.size() % 4 != 0) {
        program.push_back(0);
    }
    tag_header();
    program += "bad";
    Execute(program, tags);
    EXPECT_EQ(checked_text, "first");
    EXPECT_EQ(checked_text_calls, 1);
}

TEST(ScriptInterpreterArguments, OwnsAlignedTagEntriesAndNamesAfterTheirSourceDisappears) {
    checked_text.clear();
    checked_text_calls = 0;
    CScriptInterpreter interpreter;
    {
        std::vector<std::string> names;
        names.reserve(SPI_HASH_TAG_MAX + 1);
        std::vector<SPI_TAG_PARAM> tags;
        for (int index = 0; index <= SPI_HASH_TAG_MAX; ++index) {
            names.push_back("OWNED" + std::to_string(index));
            tags.push_back({names.back().data(), dc2::script::AdaptTagArguments<CaptureCheckedText>});
        }
        interpreter.SetTag(tags);
        for (auto &name : names) {
            name.assign(name.size(), 'X');
        }
    }
    std::string script = "OWNED0 \"first\";OWNED" + std::to_string(SPI_HASH_TAG_MAX) + " \"last\";";
    interpreter.SetScript(script.data(), static_cast<int>(script.size()));
    interpreter.Run();
    EXPECT_EQ(checked_text_calls, 2);
    EXPECT_EQ(checked_text, "last");
    for (const auto &entry : interpreter.hash_entries) {
        EXPECT_EQ(reinterpret_cast<std::uintptr_t>(&entry) % alignof(SPI_TAG_HASH), 0U);
    }
    interpreter.SetTag({});
    EXPECT_EQ(interpreter.tag_count, 0);
    EXPECT_TRUE(interpreter.hash_entries.empty());
}
