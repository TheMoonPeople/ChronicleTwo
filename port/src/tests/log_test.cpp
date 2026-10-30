#include <gtest/gtest.h>

#include <chrono>
#include <cstdio>
#include <filesystem>
#include <format>
#include <fstream>
#include <iterator>
#include <mutex>
#include <optional>
#include <regex>
#include <set>
#include <string>
#include <string_view>
#include <thread>
#include <utility>
#include <vector>

#include "kazarov/log.hpp"
#include "log/game_output.hpp"
#include "log/log.hpp"
#include "log/log_internal.hpp"
#include "log_capture.hpp"
#include "platform/config.hpp"

namespace {

struct Captured {
    std::string logger;
    LogLevel    level;
    std::string message;
};

std::mutex            g_captured_mutex;
std::vector<Captured> g_captured;

void Capture(std::string_view logger, LogLevel level, std::string_view message) {
    const std::scoped_lock lock(g_captured_mutex);
    g_captured.push_back({.logger = std::string(logger), .level = level, .message = std::string(message)});
}

// The tests' settings: no file, so a later LogApplyConfig never reopens one in a removed directory.
LogConfig TestConfig() {
    LogConfig config;
    config.file = false;
    config.level = LogLevel::Info;
    return config;
}

class Log : public testing::Test {
protected:
    void SetUp() override {
        LogInit({});
        LogApplyConfig(TestConfig());
        LogFlush();
        {
            const std::scoped_lock lock(g_captured_mutex);
            g_captured.clear();
        }
        LogSetCaptureHook(Capture);
    }

    void TearDown() override {
        LogFlush();
        LogSetCaptureHook(nullptr);
        LogInit({});
        LogApplyConfig(TestConfig());
    }

    static std::vector<Captured> Lines() {
        LogFlush();
        const std::scoped_lock lock(g_captured_mutex);
        return g_captured;
    }

    static std::vector<std::string> Messages(std::string_view logger) {
        std::vector<std::string> messages;
        for (const Captured &line : Lines()) {
            if (line.logger == logger) {
                messages.push_back(line.message);
            }
        }
        return messages;
    }
};

TEST_F(Log, SessionIdIsDateTimeAndFourHexDigits) {
    const std::string id(LogSessionId());
    EXPECT_TRUE(std::regex_match(id, std::regex("[0-9]{8}-[0-9]{6}-[0-9a-f]{4}"))) << id;
    EXPECT_EQ(LogSessionId(), id);
}

TEST_F(Log, SpecsNameALevelAndCategoryLevels) {
    const std::optional<LogSpec> spec = LogParseSpec(" WARN, gfx=trace ,Audio=off");
    ASSERT_TRUE(spec.has_value());
    const LogSpec parsed = spec.value_or(LogSpec{});
    EXPECT_EQ(parsed.level, LogLevel::Warning);
    const std::vector<std::pair<LogCategory, LogLevel>> expected = {
        {LogCategory::Gfx,   LogLevel::Trace},
        {LogCategory::Audio, LogLevel::Off  },
    };
    EXPECT_EQ(parsed.categories, expected);
    const std::optional<LogSpec> category_only = LogParseSpec("data=debug");
    ASSERT_TRUE(category_only.has_value());
    EXPECT_FALSE(category_only.value_or(LogSpec{}).level.has_value());
    EXPECT_FALSE(LogSpecValid(""));
    EXPECT_FALSE(LogSpecValid("loud"));
    EXPECT_FALSE(LogSpecValid("gfx="));
    EXPECT_FALSE(LogSpecValid("nope=info"));
    EXPECT_FALSE(LogSpecValid("debug,"));
}

TEST_F(Log, LevelsFilterAndCategoriesOverrideThem) {
    LogConfig config = TestConfig();
    config.level = LogLevel::Warning;
    config.categories = {
        {LogCategory::Data, LogLevel::Debug}
    };
    LogApplyConfig(config);
    EXPECT_EQ(LogEffectiveLevel(LogCategory::Main), LogLevel::Warning);
    EXPECT_EQ(LogEffectiveLevel(LogCategory::Data), LogLevel::Debug);

    CT_LOG_INFO(Main, "hidden info");
    CT_LOG_WARN(Main, "shown warning");
    CT_LOG_DEBUG(Data, "shown debug {}", 1);
    CT_LOG_TRACE(Data, "hidden trace");
    EXPECT_EQ(Messages("main"), std::vector<std::string>{"shown warning"});
    EXPECT_EQ(Messages("data"), std::vector<std::string>{"shown debug 1"});

    config.level.reset();
    config.categories.clear();
    LogApplyConfig(config);
    EXPECT_EQ(LogEffectiveLevel(LogCategory::Main), kLogLevelDefault);
}

TEST_F(Log, BootSpecOutranksConfig) {
    LogConfig config = TestConfig();
    config.level = LogLevel::Debug;
    config.categories = {
        {LogCategory::Audio, LogLevel::Debug}
    };
    LogApplyConfig(config);
    LogInit({.level_override = "error,audio=trace"});
    EXPECT_EQ(LogEffectiveLevel(LogCategory::Main), LogLevel::Error);
    EXPECT_EQ(LogEffectiveLevel(LogCategory::Audio), LogLevel::Trace);
    LogInit({.level_override = "error"});
    EXPECT_EQ(LogEffectiveLevel(LogCategory::Audio), LogLevel::Error);
    LogInit({});
    EXPECT_EQ(LogEffectiveLevel(LogCategory::Main), LogLevel::Debug);
    EXPECT_EQ(LogEffectiveLevel(LogCategory::Audio), LogLevel::Debug);
}

TEST_F(Log, EveryThreadsLinesArriveByTheFlush) {
    constexpr int            thread_count = 4;
    constexpr int            line_count = 500;
    std::vector<std::thread> threads;
    threads.reserve(thread_count);
    for (int t = 0; t < thread_count; ++t) {
        threads.emplace_back([t] {
            LogThreadReady();
            for (int i = 0; i < line_count; ++i) {
                CT_LOG_INFO(Memory, "thread {} line {}", t, i);
            }
        });
    }
    for (std::thread &thread : threads) {
        thread.join();
    }
    const std::vector<std::string> messages = Messages("memory");
    EXPECT_EQ(messages.size(), static_cast<std::size_t>(thread_count * line_count));
    EXPECT_EQ(std::set<std::string>(messages.begin(), messages.end()).size(), messages.size());
}

TEST_F(Log, EveryJoinedBatchPrecedesItsFlushMarker) {
    constexpr int batch_count = 16;
    constexpr int thread_count = 4;
    constexpr int line_count = 32;
    for (int batch = 0; batch < batch_count; ++batch) {
        std::vector<std::thread> threads;
        threads.reserve(thread_count);
        for (int thread = 0; thread < thread_count; ++thread) {
            threads.emplace_back([batch, thread] {
                LogThreadReady();
                for (int line = 0; line < line_count; ++line) {
                    CT_LOG_INFO(Memory, "batch {} thread {} line {}", batch, thread, line);
                }
            });
        }
        for (auto &thread : threads) {
            thread.join();
        }
        CT_LOG_INFO(Main, "joined batch {}", batch);
        const auto lines = Lines();
        ASSERT_EQ(lines.size(), static_cast<std::size_t>((batch + 1) * (thread_count * line_count + 1)));
        EXPECT_EQ(lines.back().logger, "main");
        EXPECT_EQ(lines.back().message, std::format("joined batch {}", batch));
    }
}

TEST_F(Log, ConsoleShowsTheMessageAlone) {
    LogConfig config = TestConfig();
    config.categories = {
        {LogCategory::Ps2, LogLevel::Debug}
    };
    LogApplyConfig(config);
    CaptureLoggedStderr();
    CT_LOG_INFO(Data, "dataread: indexed {} files under {}", 3, "x");
    CT_LOG_FILE_INFO("session: file only");
    CT_LOG_DEBUG(Ps2, "ps2 line");
    CT_LOG_INFO(Gfx, "mglib: frame {} written to {}", 3, std::string("shot.png"));
    EXPECT_EQ(GetLoggedStderr(), "dataread: indexed 3 files under x\nmglib: frame 3 written to shot.png\n");

    config.console = false;
    LogApplyConfig(config);
    CaptureLoggedStderr();
    CT_LOG_ERROR(Main, "quiet");
    EXPECT_EQ(GetLoggedStderr(), "");
    EXPECT_EQ(Messages("main"), std::vector<std::string>{"quiet"});
}

TEST_F(Log, RateLimitedSitesFoldRepeats) {
    for (int i = 0; i < 100; ++i) {
        CT_LOG_INFO_LIMIT(std::chrono::hours{1}, Movie, "limited {}", i);
    }
    for (int i = 0; i < 10; ++i) {
        CT_LOG_INFO_EVERY_N(5, Movie, "every {}", i);
    }
    const std::vector<std::string> expected = {"limited 0 (1x)", "every 0", "every 5"};
    EXPECT_EQ(Messages("movie"), expected);
}

TEST_F(Log, Ps2PrintfJoinsPartialLines) {
    LogConfig config = TestConfig();
    config.categories = {
        {LogCategory::Ps2, LogLevel::Debug}
    };
    LogApplyConfig(config);
    Ps2PrintfWrite("ab");
    Ps2PrintfWrite("c\nde\r\nf");
    EXPECT_EQ(Messages("ps2"), (std::vector<std::string>{"abc", "de"}));
    Ps2PrintfFlush();
    EXPECT_EQ(Messages("ps2"), (std::vector<std::string>{"abc", "de", "f"}));

    testing::internal::CaptureStdout();
    EXPECT_EQ(dc2::log::PrintGame("x=%d %s\n", 5, "y"), 6);
    std::fflush(stdout);
    EXPECT_EQ(testing::internal::GetCapturedStdout(), "x=5 y\n");
    EXPECT_EQ(Messages("ps2").back(), "x=5 y");

    const std::string long_text(3000, 'z');
    dc2::log::PrintGame("%s\n", long_text.c_str());
    EXPECT_EQ(Messages("ps2").back(), long_text);
}

struct LogsWhenDestroyed {
    ~LogsWhenDestroyed() noexcept {
        try {
            CT_LOG_WARN(Memory, "late line {}", 7);
        } catch (...) { // NOLINT(bugprone-empty-catch): a destructor must not throw during thread exit.
        }
    }
};

TEST_F(Log, LinesFromAnExitingThreadAreWrittenAtOnce) {
    CaptureLoggedStderr();
    std::thread([] {
        // Constructed before the thread's first log line, so destroyed after the logger's thread state.
        thread_local LogsWhenDestroyed logs_when_destroyed;
        static_cast<void>(&logs_when_destroyed);
        CT_LOG_INFO(Memory, "early line");
    }).join();
    // The late line is written at once, so it may come before the queued one.
    const std::string text = GetLoggedStderr();
    EXPECT_NE(text.find("early line\n"), std::string::npos) << text;
    EXPECT_NE(text.find("late line 7\n"), std::string::npos) << text;
}

TEST_F(Log, KazarovLinesKeepTheirSubsystem) {
    kz::Log(kz::LogLevel::Warning, "gfx", "swapchain out of date");
    const std::vector<Captured> lines = Lines();
    ASSERT_FALSE(lines.empty());
    EXPECT_EQ(lines.back().logger, "kazarov");
    EXPECT_EQ(lines.back().level, LogLevel::Warning);
    EXPECT_EQ(lines.back().message, "gfx: swapchain out of date");
}

class LogFiles : public testing::Test {
protected:
    void SetUp() override {
        directory = std::filesystem::temp_directory_path() / ("ct-log-test-" + std::string(LogSessionId()));
        std::filesystem::remove_all(directory);
        std::filesystem::create_directories(directory);
    }

    void TearDown() override {
        std::error_code error;
        std::filesystem::remove_all(directory, error);
    }

    static void Touch(const std::filesystem::path &path) { std::ofstream(path) << "x"; }

    std::filesystem::path directory;
};

TEST_F(LogFiles, PruningKeepsTheNewestSessions) {
    for (int day = 10; day < 22; ++day) {
        Touch(directory / std::format("darkchronicle-202601{}-120000-abcd.log", day));
    }
    const std::filesystem::path current = directory / "darkchronicle-20260101-000000-0000.log";
    Touch(current);
    Touch(directory / "notes.txt");
    LogPruneDirectory(directory, 5, current);

    std::set<std::string> names;
    for (const auto &entry : std::filesystem::directory_iterator(directory)) {
        names.insert(entry.path().filename().string());
    }
    const std::set<std::string> expected = {
        "darkchronicle-20260101-000000-0000.log",
        "darkchronicle-20260118-120000-abcd.log",
        "darkchronicle-20260119-120000-abcd.log",
        "darkchronicle-20260120-120000-abcd.log",
        "darkchronicle-20260121-120000-abcd.log",
        "notes.txt",
    };
    EXPECT_EQ(names, expected);
}

TEST_F(LogFiles, SessionFileHasTimeLevelThreadAndCategory) {
    LogConfig config = TestConfig();
    config.file = true;
    CT_LOG_INFO(Data, "before the file");
    LogAttachFile(directory / "saves" / "", config);
    const std::filesystem::path path = LogFilePath();
    ASSERT_EQ(path.parent_path(), directory / "logs");
    EXPECT_EQ(path.filename().string(), std::format("darkchronicle-{}.log", LogSessionId()));
    CT_LOG_WARN(Save, "after the file {}", 2);
    LogFlush();
    LogApplyConfig(TestConfig());
    EXPECT_TRUE(LogFilePath().empty());

    std::ifstream     file(path, std::ios::binary);
    const std::string text{std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>()};
    EXPECT_NE(text.find(" data     before the file\n"), std::string::npos) << text;
    EXPECT_TRUE(std::regex_search(text, std::regex(R"(\n\d{4}-\d\d-\d\d \d\d:\d\d:\d\d\.\d{3} WARN  \[[^\]]+\] save     after the file 2\n)")))
        << text;
}

TEST(LogConfigKeys, RoundTripThroughConfigJson) {
    Config config;
    config.log.level = LogLevel::Trace;
    config.log.file = false;
    config.log.keep = 3;
    config.log.console = false;
    config.log.categories = {
        {LogCategory::Gfx,   LogLevel::Debug},
        {LogCategory::Audio, LogLevel::Off  },
    };
    EXPECT_EQ(ConfigParse(ConfigSerialize(config)), config);
    EXPECT_EQ(ConfigParse(ConfigSerialize(Config{})), Config{});
    EXPECT_FALSE(ConfigParse(R"({"log":{"level":"auto"}})").log.level.has_value());
}

TEST(LogConfigKeys, InvalidValuesKeepTheirDefaults) {
    const Config config = ConfigParse(R"({"log":{"level":"loud","keep":0,"file":"yes","categories":{"nope":"info","GFX":"debug","audio":"auto"}}})");
    EXPECT_FALSE(config.log.level.has_value());
    EXPECT_EQ(config.log.keep, kLogKeepDefault);
    EXPECT_TRUE(config.log.file);
    const std::vector<std::pair<LogCategory, LogLevel>> expected = {
        {LogCategory::Gfx, LogLevel::Debug}
    };
    EXPECT_EQ(config.log.categories, expected);
    EXPECT_EQ(ConfigParse(R"({"log":{"keep":1001}})").log.keep, kLogKeepDefault);
}

} // namespace
