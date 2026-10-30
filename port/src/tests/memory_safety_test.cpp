#include "common.h"

#include <gtest/gtest.h>

#include <array>
#include <cstring>
#include <limits>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

#include "effscript.hpp"
#include "event_func.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "native_script_program.hpp"
#include "platform/game_loop_state.hpp"
#include "runscript.hpp"
#include "savedata.hpp"
#include "script_guards.hpp"
#include "scriptinterpreter.hpp"
#include "text/bounded.hpp"
#include "userdata.hpp"

int _GET_VALUE(dc2::script::RunArguments args);
int _AUTO_SET_OFFSET(dc2::script::RunArguments args);
int _SPT_SET_TEXNAME(dc2::script::RunArguments args);
int _CHR_SET_POS2(dc2::script::RunArguments args);
int _CHR_SET_ROT2(dc2::script::RunArguments args);
int _CHR_SET_SCALE2(dc2::script::RunArguments args);
int _CHR_SET_MOTION2(dc2::script::RunArguments args);
int _CHR_ADD_POS2(dc2::script::RunArguments args);
int _CHR_ADD_ROT2(dc2::script::RunArguments args);
int _CHR_ADD_SCALE2(dc2::script::RunArguments args);
int _CHR_SET_SHOW2(dc2::script::RunArguments args);

namespace {

/**
 * Argument counts and first values a binary tag handler observed.
 */
std::vector<int> observed_counts;

int CaptureCount(dc2::script::TagArguments /*unused*/, int count) {
    observed_counts.push_back(count);
    return 1;
}

/**
 * Appends a little-endian value to a binary script.
 */
template <typename Value>
void Put(std::vector<char> &script, Value value) {
    const auto *bytes = reinterpret_cast<const char *>(&value);
    script.insert(script.end(), bytes, bytes + sizeof value);
}

/**
 * Runs a binary script against a one-tag table that records argument counts.
 */
int RunBinary(std::vector<char> script) {
    char          name[] = "TAG";
    SPI_TAG_PARAM tags[]{
        {.name = name,    .function = CaptureCount},
        {.name = nullptr, .function = nullptr     }
    };
    CScriptInterpreter interpreter;
    interpreter.SetTag(tags);
    interpreter.SetScript(script.data(), static_cast<int>(script.size()));
    return interpreter.GetNextTAG(1);
}

/**
 * Restores the language after a test changes it.
 */
struct LanguageScope {
    int previous = LanguageCode;

    explicit LanguageScope(int language) { LanguageCode = language; }

    ~LanguageScope() { LanguageCode = previous; }
};

} // namespace

TEST(BoundedText, CopyTruncatesWithoutSplittingShiftJis) {
    std::array<char, 4> field{'x', 'x', 'x', 'x'};
    EXPECT_EQ(dc2::text::Copy(field, "ab\x81w"), 2u);
    EXPECT_STREQ(field.data(), "ab");

    EXPECT_EQ(dc2::text::Copy(field, "a\x81wb"), 3u);
    EXPECT_EQ(std::string_view(field.data()), "a\x81w");
}

TEST(BoundedText, ViewStopsAtTheFieldEnd) {
    constexpr char unterminated[3] = {'a', 'b', 'c'};
    static_assert(dc2::text::View(unterminated) == "abc");
    EXPECT_EQ(dc2::text::View(unterminated), "abc");
    EXPECT_EQ(dc2::text::View(std::span<const char>()), "");
    EXPECT_TRUE(dc2::text::View(nullptr).empty());
}

TEST(BoundedText, CaptionTagsCountOnceAndMalformedTagsStopWithinTheSource) {
    EXPECT_EQ(dc2::text::CaptionPrefix("a[color=red]bc", 2), "a[color=red]");
    EXPECT_EQ(dc2::text::CaptionPrefix("a[unterminated", 99), "a");
    EXPECT_EQ(dc2::text::CaptionPrefix(std::string_view("a[x\0]hidden", 11), 99), "a");
    EXPECT_TRUE(dc2::text::CaptionPrefix("[tag]", 0).empty());
}

TEST(BoundedText, FontTagLookupRejectsEmptyUnknownAndNullInputs) {
    char empty[] = "";
    char unknown[] = "ordinary text";
    char known[] = "[select]";
    EXPECT_EQ(GetGaijiFontNo(nullptr), 0);
    EXPECT_EQ(GetGaijiFontNo(empty), 0);
    EXPECT_EQ(GetGaijiFontNo(unknown), 0);
    EXPECT_EQ(GetGaijiFontNo(known), 0xFD00);
    EXPECT_EQ(GetFontGaijiFontNo(nullptr), 0);
    EXPECT_EQ(GetFontGaijiFontNo(empty), 0);
}

TEST(BoundedText, CaptionsOwnTheirPrefixAndKeepCompleteShiftJisCharacters) {
    char source[]{'a', '\x81', '\x40', 'b'};
    EXPECT_EQ(dc2::text::CaptionPrefix(dc2::text::View(source), 2), "a");
    auto caption = dc2::text::CaptionPrefix(dc2::text::View(source), 3);
    EXPECT_EQ(caption, "a\x81\x40");
    std::memset(source, 'x', sizeof(source));
    EXPECT_EQ(caption, "a\x81\x40");
    EXPECT_EQ(dc2::text::CaptionPrefix("a\x81", 99), "a");
    EXPECT_EQ(dc2::text::CaptionPrefix("a\x81\x7f", 99), "a");
    EXPECT_EQ(dc2::text::CaptionPrefix("abc", std::numeric_limits<std::size_t>::max()), "abc");
}

TEST(BoundedText, RejectsIncompleteShiftJisAndEmbeddedTerminators) {
    std::array<char, 8> field{};
    EXPECT_EQ(dc2::text::Copy(field, std::string_view("a\x81", 2)), 1u);
    EXPECT_STREQ(field.data(), "a");
    EXPECT_EQ(dc2::text::Copy(field, std::string_view("a\x81\x7f", 3)), 1u);
    EXPECT_STREQ(field.data(), "a");
    EXPECT_EQ(dc2::text::Copy(field, std::string_view("a\0hidden", 8)), 1u);
    EXPECT_STREQ(field.data(), "a");
}

TEST(BoundedText, CopiesOverlappingAndEmptyFields) {
    std::array<char, 8> field{'a', 'b', 'c', 'd', 'e', '\0', 'x', 'x'};
    EXPECT_EQ(dc2::text::Copy(field, std::string_view(field.data() + 2, 3)), 3u);
    EXPECT_STREQ(field.data(), "cde");
    EXPECT_EQ(dc2::text::Copy(std::span<char>(), "unused"), 0u);
}

TEST(BoundedText, AppendKeepsCompleteShiftJisAndTerminates) {
    std::array<char, 6> field{'a', 'b', '\0', 'x', 'x', 'x'};
    EXPECT_EQ(dc2::text::Append(field, "c\x81\x40"), 3u);
    EXPECT_EQ(dc2::text::View(field), std::string_view("abc\x81\x40", 5));
    EXPECT_EQ(dc2::text::Append(field, "z"), 0u);
    EXPECT_EQ(field.back(), '\0');

    std::array<char, 4> unterminated{'a', 'b', 'c', 'd'};
    EXPECT_EQ(dc2::text::Append(unterminated, "z"), 0u);
    EXPECT_EQ(dc2::text::View(unterminated), "abc");
}

TEST(BoundedText, FixedSourcesAndSelfAppendStayWithinTheirFields) {
    char source[4]{'a', 'b', 'c', 'd'};
    char destination[6]{'x', '\0', '!', '!', '!', '!'};
    EXPECT_EQ(dc2::text::Copy(destination, source), 4u);
    EXPECT_STREQ(destination, "abcd");

    char appended[8]{'x', '\0', '!', '!', '!', '!', '!', '!'};
    EXPECT_EQ(dc2::text::Append(appended, source), 4u);
    EXPECT_STREQ(appended, "xabcd");
    EXPECT_EQ(dc2::text::Append(appended, appended), 2u);
    EXPECT_STREQ(appended, "xabcdxa");

    char full[4]{'a', 'b', 'c', 'd'};
    EXPECT_EQ(dc2::text::Append(full, full), 0u);
    EXPECT_STREQ(full, "abc");

    char one[1]{'x'};
    EXPECT_EQ(dc2::text::Copy(one, source), 0u);
    EXPECT_EQ(one[0], '\0');
    EXPECT_EQ(dc2::text::Append(one, source), 0u);
    EXPECT_EQ(one[0], '\0');
    EXPECT_EQ(dc2::text::Copy(std::span<char>{}, source), 0u);
    EXPECT_EQ(dc2::text::Append(std::span<char>{}, source), 0u);
}

TEST(BinaryScript, OversizedArgumentCountStaysInsideTheStack) {
    std::vector<char> script{'B', 'I', 'N', '\0'};
    Put<s16>(script, 0);
    Put<s16>(script, 300);
    script.insert(script.end(), 300, static_cast<char>(SPI_BINARY_ARG_TYPE_INT));
    for (int i = 0; i < 300; ++i) {
        Put<int>(script, i);
    }

    observed_counts.clear();
    RunBinary(script);
    ASSERT_EQ(observed_counts.size(), 1u);
    EXPECT_EQ(observed_counts[0], SPI_STACK_SIZE);
}

TEST(BinaryScript, TruncatedValuesStopAtTheScriptEnd) {
    std::vector<char> script{'B', 'I', 'N', '\0'};
    Put<s16>(script, 0);
    Put<s16>(script, 3);
    script.push_back(static_cast<char>(SPI_BINARY_ARG_TYPE_INT));
    script.push_back(static_cast<char>(SPI_BINARY_ARG_TYPE_STRING));
    script.push_back(static_cast<char>(SPI_BINARY_ARG_TYPE_INT));
    script.push_back('\0');
    Put<int>(script, 7);
    // An unterminated string ends the script.
    script.insert(script.end(), {'a', 'b', 'c'});

    observed_counts.clear();
    EXPECT_EQ(RunBinary(script), -1);
    EXPECT_TRUE(observed_counts.empty());
}

TEST(ItemNames, RenamedWeaponNameIsNotAFormat) {
    LanguageScope language(1);
    CGameDataUsed item;
    item.used_type = USED_ITEM_TYPE_WEAPON;
    item.rename_flag = 1;
    item.data.weapon.level = 3;
    dc2::text::Copy(item.data.weapon.name, "%s%n%99999d");

    EXPECT_STREQ(item.GetName(ITEM_NAME_TYPE_LEVEL), "%s%n%99999d + 3");
}

TEST(ItemNames, FishRenameIsHeldToTheFishField) {
    CGameDataUsed item;
    item.used_type = USED_ITEM_TYPE_FISH;
    item.item_no = 0;
    std::memset(item.data.fish.name, 0, sizeof item.data.fish.name);
    item.data.fish.sex = 5;

    char name[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ01234";
    item.SetName(name);
    EXPECT_EQ(std::strlen(item.data.fish.name), sizeof item.data.fish.name - 1);
    EXPECT_EQ(item.data.fish.sex, 5);
}

TEST(ItemNames, BoiledNameIsHeldToTheBoiledField) {
    LanguageScope language(3);
    CGameDataUsed item;
    item.used_type = USED_ITEM_TYPE_FISH;
    item.item_no = 0;
    std::memset(&item.data, 0, sizeof item.data);
    dc2::text::Copy(item.data.fish.name, "ABCDEFGHIJKLMNOPQRST");

    item.Boiled();
    EXPECT_EQ(item.used_type, USED_ITEM_TYPE_BOILED);
    EXPECT_LT(std::strlen(item.data.boiled.name), sizeof item.data.boiled.name);
}

TEST(ScriptGuards, RefusesEffectValueOutsideTheTable) {
    constexpr auto              handler = dc2::script::AdaptRunArguments<_GET_VALUE>;
    std::array<RS_STACKDATA, 2> args{};
    args[0].type = RS_INT;
    args[0].val.i = 8;
    EXPECT_FALSE(script_guards::AllowExternal(handler, dc2::script::RunArguments(std::span(args).first(2)), 2, 0));
    args[0].val.i = 7;
    EXPECT_TRUE(script_guards::AllowExternal(handler, dc2::script::RunArguments(std::span(args).first(2)), 2, 0));
    EXPECT_FALSE(script_guards::AllowExternal(handler, dc2::script::RunArguments(std::span(args).first(0)), 0, 0));
    char value[] = "7";
    args[0].type = RS_STR;
    args[0].val.s = value;
    EXPECT_FALSE(script_guards::AllowExternal(handler, dc2::script::RunArguments(std::span(args).first(2)), 2, 0));
    args[0].type = RS_FLOAT;
    args[0].val.f = std::numeric_limits<float>::infinity();
    EXPECT_FALSE(script_guards::AllowExternal(handler, dc2::script::RunArguments(std::span(args).first(2)), 2, 0));
}

TEST(ScriptGuards, RefusesMissingOrMistypedOptionalEffectFrameName) {
    constexpr auto              handler = dc2::script::AdaptRunArguments<_AUTO_SET_OFFSET>;
    std::array<RS_STACKDATA, 2> args{};
    EXPECT_FALSE(script_guards::AllowExternal(handler, dc2::script::RunArguments(std::span(args).first(0)), 0, 0));
    args[0].type = RS_INT;
    args[0].val.i = 3;
    EXPECT_TRUE(script_guards::AllowExternal(handler, dc2::script::RunArguments(std::span(args).first(1)), 1, 0));
    args[1].type = RS_INT;
    args[1].val.i = 7;
    EXPECT_FALSE(script_guards::AllowExternal(handler, dc2::script::RunArguments(std::span(args).first(2)), 2, 0));
}

TEST(ScriptGuards, SecondaryEffectCharacterAdaptersRetainIndexRules) {
    constexpr std::array handlers{
        dc2::script::AdaptRunArguments<_CHR_SET_POS2>,
        dc2::script::AdaptRunArguments<_CHR_SET_ROT2>,
        dc2::script::AdaptRunArguments<_CHR_SET_SCALE2>,
        dc2::script::AdaptRunArguments<_CHR_SET_MOTION2>,
        dc2::script::AdaptRunArguments<_CHR_ADD_POS2>,
        dc2::script::AdaptRunArguments<_CHR_ADD_ROT2>,
        dc2::script::AdaptRunArguments<_CHR_ADD_SCALE2>,
        dc2::script::AdaptRunArguments<_CHR_SET_SHOW2>,
    };
    RS_STACKDATA argument{};
    argument.type = RS_INT;
    for (const auto handler : handlers) {
        argument.val.i = EFF_SPT_SUB_CHARA_MAX;
        EXPECT_FALSE(script_guards::AllowExternal(handler, dc2::script::RunArguments(std::span(&argument, 1)), 1, 0));
        argument.val.i = -1;
        EXPECT_FALSE(script_guards::AllowExternal(handler, dc2::script::RunArguments(std::span(&argument, 1)), 1, 0));
        argument.val.i = 0;
        EXPECT_TRUE(script_guards::AllowExternal(handler, dc2::script::RunArguments(std::span(&argument, 1)), 1, 0));
    }
}

TEST(ScriptGuards, EffectTextRulesValidateTheInvocationStorageBeforeReading) {
    constexpr auto              offset_handler = dc2::script::AdaptRunArguments<_AUTO_SET_OFFSET>;
    constexpr auto              texture_handler = dc2::script::AdaptRunArguments<_SPT_SET_TEXNAME>;
    std::array<RS_STACKDATA, 2> args{};
    args[0].type = RS_INT;
    args[0].val.i = 1;
    args[1].type = RS_STR;
    char valid[] = "frame";
    args[1].val.s = valid;
    EXPECT_TRUE(script_guards::AllowExternal(offset_handler, dc2::script::RunArguments(args, valid), 2, 0));
    EXPECT_TRUE(script_guards::AllowExternal(texture_handler, dc2::script::RunArguments(std::span(args).subspan(1), valid), 1, 0));
    char unterminated[] = {'b', 'a', 'd'};
    args[1].val.s = unterminated;
    EXPECT_THROW(script_guards::AllowExternal(offset_handler, dc2::script::RunArguments(args, unterminated), 2, 0), dc2::script::ArgumentError);
    EXPECT_EQ(InvokeNativeExternal(offset_handler, args, {}, unterminated), 0);
    EXPECT_THROW(script_guards::AllowExternal(texture_handler, dc2::script::RunArguments(std::span(args).subspan(1), unterminated), 1, 0), dc2::script::ArgumentError);
    EXPECT_EQ(InvokeNativeExternal(texture_handler, std::span(args).subspan(1), {}, unterminated), 0);
    args[1].val.s = valid;
    EXPECT_THROW(script_guards::AllowExternal(offset_handler, dc2::script::RunArguments(args), 2, 0), dc2::script::ArgumentError);
    EXPECT_EQ(InvokeNativeExternal(offset_handler, args), 0);
}

TEST(CheckedRunArguments, EventFlagHandlerRejectsMissingAndMistypedValues) {
    CRunScript script;
    SetEventFunc(&script);
    const auto handler = script.ext_func_table[EVENT_EXT_SET_FLAG];
    ASSERT_NE(handler, nullptr);

    auto *previous_save = PortActiveSaveData;
    auto  save = std::make_unique<CSaveData>();
    save->Initialize();
    PortActiveSaveData = save.get();

    RS_STACKDATA arguments[2]{};
    arguments[0].type = RS_INT;
    arguments[0].val.i = 103;
    arguments[1].type = RS_INT;
    arguments[1].val.i = 1;
    EXPECT_FALSE(InvokeNativeExternal(handler, {}));
    EXPECT_FALSE(InvokeNativeExternal(handler, std::span(arguments).first(1)));
    EXPECT_EQ(save->GetBitFlag(103), 0);
    arguments[1].type = RS_STR;
    arguments[1].val.s = nullptr;
    EXPECT_FALSE(InvokeNativeExternal(handler, arguments));
    EXPECT_EQ(save->GetBitFlag(103), 0);
    arguments[1].type = RS_INT;
    arguments[1].val.i = 1;
    EXPECT_TRUE(InvokeNativeExternal(handler, arguments));
    EXPECT_EQ(save->GetBitFlag(103), 1);

    PortActiveSaveData = previous_save;
}

TEST(CheckedRunArguments, IndependentCursorsCheckOffsetsAndFiniteNumbers) {
    std::array<RS_STACKDATA, 2> values{};
    values[0].type = RS_INT;
    values[0].val.i = 7;
    values[1].type = RS_FLOAT;
    values[1].val.f = 2.5F;
    dc2::script::RunArguments first(values);
    const auto                second = first + 1;
    EXPECT_EQ(dc2::script::RunInteger(first), 7);
    EXPECT_EQ(dc2::script::RunInteger(second), 2);
    EXPECT_THROW(first + 3, dc2::script::ArgumentError);
    EXPECT_THROW(second.At(1), dc2::script::ArgumentError);
    values[1].val.f = std::numeric_limits<float>::infinity();
    EXPECT_THROW(dc2::script::RunInteger(second), dc2::script::ArgumentError);
}

TEST(CheckedTagArguments, NumericTypesAndMissingSlotsFailClosed) {
    SPI_STACK value{};
    value.type = SPI_STACK_TYPE_INT;
    value.value.integer = 4;
    dc2::script::TagArguments argument(std::span(&value, 1));
    EXPECT_EQ(dc2::script::TagInteger(argument), 4);
    EXPECT_FLOAT_EQ(dc2::script::TagFloat(argument), 4.0F);
    EXPECT_THROW(argument.At(1), dc2::script::ArgumentError);
    value.type = SPI_STACK_TYPE_STRING;
    value.value.string = nullptr;
    EXPECT_THROW(dc2::script::TagInteger(argument), dc2::script::ArgumentError);
    EXPECT_THROW(dc2::script::TagFloat(argument), dc2::script::ArgumentError);
    value.type = SPI_STACK_TYPE_FLOAT;
    value.value.real = std::numeric_limits<float>::infinity();
    EXPECT_THROW(dc2::script::TagInteger(argument), dc2::script::ArgumentError);
    EXPECT_THROW(dc2::script::TagFloat(argument), dc2::script::ArgumentError);
}

TEST(CheckedRunArguments, TextAndOutputReferencesNeedLiveStorage) {
    std::array<RS_STACKDATA, 2> arguments{};
    std::array<RS_STACKDATA, 2> writable{};
    char                        text[] = "abc";
    arguments[0].type = RS_STR;
    arguments[0].val.s = text;
    arguments[1].type = RS_PTR;
    arguments[1].val.p = &writable[1];
    dc2::script::RunArguments view(arguments, text, writable);
    EXPECT_EQ(dc2::script::RunText(view), "abc");
    EXPECT_EQ(&dc2::script::RunOutput(view + 1), &writable[1]);

    char foreign[] = "abc";
    arguments[0].val.s = foreign;
    EXPECT_THROW(dc2::script::RunText(view), dc2::script::ArgumentError);
    arguments[0].val.s = text;
    text[3] = 'x';
    EXPECT_THROW(dc2::script::RunText(view), dc2::script::ArgumentError);
    RS_STACKDATA foreign_slot{};
    arguments[1].val.p = &foreign_slot;
    EXPECT_THROW(dc2::script::RunOutput(view + 1), dc2::script::ArgumentError);
}

TEST(CheckedRunArguments, AdditionalNativeTextKeepsItsExactTerminatedExtent) {
    char                                 bytecode[] = "program";
    char                                 native_text[] = "luau";
    std::array<std::span<const char>, 1> sources{std::span<const char>(native_text)};
    RS_STACKDATA                         value{};
    value.type = RS_STR;
    value.val.s = native_text;
    dc2::script::RunArguments arguments(std::span(&value, 1), bytecode, {}, sources);
    EXPECT_EQ(dc2::script::RunText(arguments), "luau");
    native_text[4] = 'x';
    EXPECT_THROW(dc2::script::RunText(arguments), dc2::script::ArgumentError);
}

TEST(CheckedTagArguments, NestedViewsKeepTheirOwnTextStorage) {
    char      outer_text[] = "outer";
    char      inner_text[] = "inner";
    SPI_STACK outer_slot{};
    outer_slot.type = SPI_STACK_TYPE_STRING;
    outer_slot.value.string = outer_text;
    dc2::script::TagArguments outer_view(std::span(&outer_slot, 1), outer_text);
    EXPECT_EQ(dc2::script::TagText(outer_view), "outer");
    {
        SPI_STACK inner_slot{};
        inner_slot.type = SPI_STACK_TYPE_STRING;
        inner_slot.value.string = inner_text;
        dc2::script::TagArguments inner_view(std::span(&inner_slot, 1), inner_text);
        EXPECT_EQ(dc2::script::TagText(inner_view), "inner");
        EXPECT_EQ(dc2::script::TagText(outer_view), "outer");
    }
    EXPECT_EQ(dc2::script::TagText(outer_view), "outer");
}
