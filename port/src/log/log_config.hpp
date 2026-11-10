#pragma once

// The logger's settings, without Quill: platform/config.hpp holds them in Config.

#include <cstdint>
#include <optional>
#include <string_view>
#include <utility>
#include <vector>

/**
 * Subsystems that each have a configurable logging level.
 */
enum class LogCategory : std::uint8_t {
    Main,
    Config,
    Data,
    Gfx,
    Audio,
    Input,
    Save,
    Menu,
    Event,
    Dungeon,
    Town,
    Movie,
    Script,
    Memory,
    Ps2,
    Kazarov,
    Crash,
    Count,
};

/**
 * Severity thresholds used to filter diagnostic messages.
 */
enum class LogLevel : std::uint8_t {
    Trace,
    Debug,
    Info,
    Warning,
    Error,
    Critical,
    Off,
};

/** Default logging threshold selected for the build configuration. */
#ifdef NDEBUG
inline constexpr LogLevel kLogLevelDefault = LogLevel::Info;
#else
inline constexpr LogLevel kLogLevelDefault = LogLevel::Debug;
#endif

/** Default number of session log files to retain. */
inline constexpr int kLogKeepDefault = 10;
/** Maximum accepted number of session log files to retain. */
inline constexpr int kLogKeepMax = 1000;

/**
 * Runtime settings for log delivery, retention, and category thresholds.
 */
struct LogConfig {
    std::optional<LogLevel>                       level;                  /**< Global threshold, or the build default when unset. */
    bool                                          file = true;            /**< Whether to write a session log in the save directory. */
    int                                           keep = kLogKeepDefault; /**< Number of session logs to retain. */
    bool                                          console = true;         /**< Whether to echo diagnostic lines to the console. */
    std::vector<std::pair<LogCategory, LogLevel>> categories;             /**< Per-category threshold overrides. */

    /**
     * Compares all logging settings for equality.
     */
    bool operator==(const LogConfig &) const = default;
};

/**
 * Returns the lowercase configuration name of a logging category.
 */
std::string_view LogCategoryName(LogCategory category);
/**
 * Returns the lowercase configuration name of a severity level.
 */
std::string_view LogLevelName(LogLevel level);
/**
 * Resolves a category name without regard to letter case.
 */
std::optional<LogCategory> LogCategoryFromName(std::string_view name);
/**
 * Resolves a severity name without regard to letter case.
 */
std::optional<LogLevel> LogLevelFromName(std::string_view name);
