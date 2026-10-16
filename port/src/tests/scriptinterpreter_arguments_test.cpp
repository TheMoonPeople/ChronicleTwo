#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <string>
#include <vector>

#include "scriptinterpreter.hpp"

namespace {
using Json = nlohmann::json;

std::vector<std::array<float, 9> >       positions;           /**< Position arguments observed by callbacks. */
std::vector<std::array<std::string, 2> > strings;             /**< String arguments observed by callbacks. */
std::vector<int>                         counts;              /**< Explicit argument counts observed by callbacks. */
int                                      remaining_depth = 0; /**< Additional nested text callbacks requested by a test. */

/**
 * Executes an independent text or typed JSON script with the supplied callback table.
 */
void Execute(std::string text, SPI_TAG_PARAM *tags) {
    CScriptInterpreter interpreter;
    interpreter.SetScript(text.data(), static_cast<int>(text.size()));
    interpreter.SetTag(tags);
    interpreter.Run();
}

/**
 * Captures all position slots and optionally runs an independent nested script.
 */
int CapturePosition(SPI_STACK *stack, int count) {
    std::array<float, 9> values{};
    for (std::size_t index = 0; index < values.size(); ++index) {
        values[index] = spiGetStackFloat(stack + index);
    }
    positions.push_back(values);
    counts.push_back(count);
    if (count == 9 && remaining_depth > 0) {
        const int     value = 100 + remaining_depth--;
        char          name[] = "POS";
        SPI_TAG_PARAM tags[]{
            {name,    CapturePosition},
            {nullptr, nullptr        }
        };
        Execute("POS 0,1,2,3,4,5,6," + std::to_string(value) + "," + std::to_string(value) + ";POS 7,8,9,10,11,12,13;", tags);
    }
    return 0;
}

/**
 * Copies the current and inherited strings while callback storage is alive.
 */
int CaptureStrings(SPI_STACK *stack, int count) {
    std::array<std::string, 2> values;
    for (std::size_t index = 0; index < values.size(); ++index) {
        const char *text = spiGetStackString(stack + index);
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

TEST_F(ScriptArguments, NativeCommandsRetainOmittedTrailingScales) {
    char          name[] = "POS";
    SPI_TAG_PARAM tags[]{
        {name,    CapturePosition},
        {nullptr, nullptr        }
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
        {name,    CaptureStrings},
        {nullptr, nullptr       }
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
        {name,    CapturePosition},
        {nullptr, nullptr        }
    };
    Execute("POS 0,1,2,3,4,5,6,100,100;POS 7,8,9,10,11,12,13;", tags);
    ExpectNestedPositions();
}

TEST_F(ScriptArguments, NativeArgumentsRemainIsolatedFromNestedTextScripts) {
    remaining_depth = 12;
    char          name[] = "POS";
    SPI_TAG_PARAM tags[]{
        {name,    CapturePosition},
        {nullptr, nullptr        }
    };
    Execute(NativePositions(), tags);
    ExpectNestedPositions();
}
