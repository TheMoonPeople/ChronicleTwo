#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <atomic>
#include <functional>
#include <span>
#include <string>
#include <string_view>
#include <thread>
#include <vector>

#include "crash/crash.hpp"
#include "crash/crash_capture.hpp"
#include "crash/crash_detail.hpp"

namespace {

std::string Read(CrashKey key) {
    std::array<char, crash_detail::kSlotSize> buffer{};
    const std::size_t                         length = crash_detail::ContextRead(key, buffer);
    return {buffer.data(), length};
}

class CrashContext : public testing::Test {
protected:
    void SetUp() override { crash_detail::ContextReset(); }

    void TearDown() override { crash_detail::ContextReset(); }
};

TEST_F(CrashContext, UnsetSlotsReadEmpty) {
    EXPECT_EQ(Read(CrashKey::Map), "");
    EXPECT_EQ(Read(CrashKey::LastAsset), "");
}

TEST_F(CrashContext, TextAndIntegerSlots) {
    CrashContextSet(CrashKey::Loop, "dungeon");
    CrashContextSetInt(CrashKey::Frame, 1234);
    CrashContextSetInt(CrashKey::Floor, -1);
    EXPECT_EQ(Read(CrashKey::Loop), "dungeon");
    EXPECT_EQ(Read(CrashKey::Frame), "1234");
    EXPECT_EQ(Read(CrashKey::Floor), "-1");
}

TEST_F(CrashContext, LaterValueReplacesEarlierOfEitherKind) {
    CrashContextSetInt(CrashKey::Map, 7);
    CrashContextSet(CrashKey::Map, "town");
    EXPECT_EQ(Read(CrashKey::Map), "town");
    CrashContextSet(CrashKey::LastAsset, "a/long/name.bin");
    CrashContextSet(CrashKey::LastAsset, "b");
    EXPECT_EQ(Read(CrashKey::LastAsset), "b");
}

TEST_F(CrashContext, LongTextIsCutToTheSlot) {
    const std::string long_text(200, 'x');
    CrashContextSet(CrashKey::LastAsset, long_text);
    EXPECT_EQ(Read(CrashKey::LastAsset), std::string(crash_detail::kSlotSize, 'x'));
}

TEST_F(CrashContext, ConcurrentWritersNeverExposeMixedValues) {
    constexpr CrashKey         key = CrashKey::Map;
    const std::string          text_a(crash_detail::kSlotSize, 'A');
    const std::string          text_b(crash_detail::kSlotSize, 'B');
    constexpr std::string_view number = "1234567890123456789";
    std::atomic<bool>          start{false};
    std::atomic<bool>          invalid{false};
    auto                       writer = [&](const std::string &text) {
        while (!start.load(std::memory_order_acquire)) {
            std::this_thread::yield();
        }
        for (int i = 0; i < 20'000; i++) {
            CrashContextSet(key, text);
            CrashContextSetInt(key, 1234567890123456789LL);
        }
    };

    std::thread first(writer, std::cref(text_a));
    std::thread second(writer, std::cref(text_b));
    start.store(true, std::memory_order_release);
    for (int i = 0; i < 40'000; i++) {
        const std::string value = Read(key);
        if (!value.empty() && value != text_a && value != text_b && value != number) {
            invalid.store(true, std::memory_order_relaxed);
            break;
        }
    }

    first.join();
    second.join();
    EXPECT_FALSE(invalid.load(std::memory_order_relaxed));
}

TEST(CrashText, FormatsWithoutAllocating) {
    char               buffer[64];
    crash_detail::Text text(buffer, sizeof(buffer));
    text.Put("a=").Dec(-42).Put(' ').Hex(0xbeef).Put(' ').Pointer(0x10);
    EXPECT_EQ(text.View(), "a=-42 beef 0x0000000000000010");
    EXPECT_FALSE(text.Truncated());
}

TEST(CrashText, StopsAtCapacity) {
    char               buffer[4];
    crash_detail::Text text(buffer, sizeof(buffer));
    text.Put("abcdef");
    EXPECT_EQ(text.View(), "abcd");
    EXPECT_TRUE(text.Truncated());
}

TEST(CrashHeader, NamesBuildSessionAndFrame) {
    char               buffer[1024];
    crash_detail::Text out(buffer, sizeof(buffer));
    crash_detail::FormatHeader(out, {.kind = "crash",
                                     .session = "20261018-142233-7f3a",
                                     .build_id = "ABCDEF01",
                                     .build_type = "Debug",
                                     .platform = "x86_64-windows",
                                     .time_utc = "2026-10-18T14:25:01Z",
                                     .frame = 77});
    EXPECT_EQ(out.View(), "Dark Chronicle crash report\n"
                          "kind:       crash\n"
                          "session:    20261018-142233-7f3a\n"
                          "build id:   ABCDEF01\n"
                          "build type: Debug\n"
                          "platform:   x86_64-windows\n"
                          "time:       2026-10-18T14:25:01Z\n"
                          "frame:      77\n");
}

TEST(CrashHeader, MissingValuesShowADash) {
    char               buffer[1024];
    crash_detail::Text out(buffer, sizeof(buffer));
    crash_detail::FormatHeader(out, {.kind = "assert", .session = "", .build_id = "", .build_type = "", .platform = "arm64-linux", .time_utc = "t"});
    const std::string_view text = out.View();
    EXPECT_NE(text.find("session:    -\n"), std::string_view::npos);
    EXPECT_NE(text.find("build id:   -\n"), std::string_view::npos);
    EXPECT_NE(text.find("frame:      -\n"), std::string_view::npos);
}

TEST(CrashBuildId, PlatformNameIsArchThenOs) {
    const std::string_view name = crash_detail::PlatformName();
    EXPECT_TRUE(name.starts_with("x86_64-") || name.starts_with("arm64-"));
}

TEST(CrashRedact, ReplacesRootsAndHome) {
    const crash_detail::RedactRoots roots{.save_root = "/home/max/.local/share/chronicletwo/saves",
                                          .data_root = "/opt/dc2/data",
                                          .home = "/home/max"};
    EXPECT_EQ(crash_detail::RedactPath("/home/max/.local/share/chronicletwo/saves/config.json", roots), "<save>/config.json");
    EXPECT_EQ(crash_detail::RedactPath("data at /opt/dc2/data", roots), "data at <data>");
    EXPECT_EQ(crash_detail::RedactPath("/home/max/Games/x", roots), "<home>/Games/x");
    EXPECT_EQ(crash_detail::RedactPath("/home/maxine/x", roots), "/home/maxine/x");
    EXPECT_EQ(crash_detail::RedactPath("nothing here", roots), "nothing here");
}

TEST(CrashRedact, MatchesEitherSeparatorAndJsonEscaping) {
    const crash_detail::RedactRoots roots{.save_root = R"(C:\Users\Max\AppData\Local\chronicletwo\saves)",
                                          .data_root = "",
                                          .home = R"(C:\Users\Max)"};
    EXPECT_EQ(crash_detail::RedactPath(R"({"path": "C:\\Users\\Max\\AppData\\Local\\chronicletwo\\saves\\x"})", roots),
              R"({"path": "<save>\\x"})");
    EXPECT_EQ(crash_detail::RedactPath("C:/Users/Max/Documents", roots), "<home>/Documents");
    EXPECT_EQ(crash_detail::RedactPath("C:\\Users\\Max\\Documents", roots), "<home>\\Documents");
}

TEST(CrashTestOption, ParsesModesAndTiming) {
    const CrashTest segv = CrashTestParse("segv").value_or(CrashTest{});
    EXPECT_EQ(segv.mode, CrashTestMode::Segv);
    EXPECT_EQ(segv.when, CrashTestWhen::FirstFrame);
    const CrashTest early = CrashTestParse("audio-thread:early").value_or(CrashTest{});
    EXPECT_EQ(early.mode, CrashTestMode::AudioThread);
    EXPECT_EQ(early.when, CrashTestWhen::Early);
    EXPECT_FALSE(CrashTestParse("explode").has_value());
    EXPECT_FALSE(CrashTestParse("segv:late").has_value());
}

} // namespace

TEST(CrashSymbols, ReusesUniqueAddressesAndReplaysZeroAddressInlines) {
    cpptrace::raw_trace raw;
    raw.frames.assign(126, 84);
    raw.frames[0] = 42;
    raw.frames[2] = 42;
    unsigned   calls = 0;
    const auto trace = crash_detail::ResolveFrames(raw, [&](const cpptrace::raw_trace &unique) {
        calls++;
        EXPECT_EQ(unique.frames, (std::vector<cpptrace::frame_ptr>{42, 84}));
        return cpptrace::stacktrace{
            {
             {.raw_address = 0, .object_address = 0, .line = 19, .column = 3, .filename = "inline.cpp", .symbol = "inline_call", .is_inline = true},
             {.raw_address = 42, .object_address = 42, .line = 29, .column = {}, .filename = "caller.cpp", .symbol = "caller", .is_inline = false},
             {.raw_address = 84, .object_address = 84, .line = 39, .column = {}, .filename = "other.cpp", .symbol = "other", .is_inline = false},
             }
        };
    });
    EXPECT_EQ(calls, 1u);
    ASSERT_EQ(trace.frames.size(), 128u);
    EXPECT_EQ(std::ranges::count_if(trace.frames, [](const auto &frame) { return !frame.is_inline; }), 126);
    EXPECT_EQ(trace.frames.back().raw_address, 84u);
    EXPECT_TRUE(trace.frames[0].is_inline);
    EXPECT_EQ(trace.frames[0].raw_address, 0u);
    EXPECT_EQ(trace.frames[0].symbol, "inline_call");
    EXPECT_EQ(trace.frames[0].filename, "inline.cpp");
    EXPECT_EQ(trace.frames[0].line.value(), 19u);
    EXPECT_EQ(trace.frames[0].column.value(), 3u);
    EXPECT_FALSE(trace.frames[1].is_inline);
    EXPECT_EQ(trace.frames[1].raw_address, 42u);
    EXPECT_EQ(trace.frames[2].raw_address, 84u);
    EXPECT_TRUE(trace.frames[3].is_inline);
    EXPECT_FALSE(trace.frames[4].is_inline);
    EXPECT_TRUE(trace.frames[3] == trace.frames[0]);
    EXPECT_TRUE(trace.frames[4] == trace.frames[1]);
}

TEST(CrashSymbols, RetainsRepeatedUnresolvedFrames) {
    cpptrace::raw_trace raw;
    raw.frames = {1, 1};
    const auto trace = crash_detail::ResolveFrames(raw, [](const cpptrace::raw_trace &unique) {
        EXPECT_EQ(unique.frames, (std::vector<cpptrace::frame_ptr>{1}));
        return cpptrace::stacktrace{{{.raw_address = 1, .object_address = 0, .line = {}, .column = {}, .filename = {}, .symbol = {}, .is_inline = false}}};
    });
    ASSERT_EQ(trace.frames.size(), 2u);
    for (const auto &frame : trace.frames) {
        EXPECT_EQ(frame.raw_address, 1u);
        EXPECT_FALSE(frame.is_inline);
        EXPECT_TRUE(frame.symbol.empty());
        EXPECT_TRUE(frame.filename.empty());
        EXPECT_FALSE(frame.line.has_value());
    }
}

TEST(CrashSymbols, AcceptsEmptyCapturesAndEmptyResolution) {
    for (const cpptrace::raw_trace &raw : {cpptrace::raw_trace{}, cpptrace::raw_trace{{42, 42, 84}}}) {
        unsigned   calls = 0;
        const auto trace = crash_detail::ResolveFrames(raw, [&](const cpptrace::raw_trace &) {
            calls++;
            return cpptrace::stacktrace{};
        });
        EXPECT_EQ(calls, 1u);
        EXPECT_TRUE(trace.frames.empty());
    }
}
