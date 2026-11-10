#pragma once

// The logger's parts that log_test.cpp and game_output.cpp reach beyond log.hpp.

#include <filesystem>
#include <optional>
#include <string_view>
#include <utility>
#include <vector>

#include "log/log_config.hpp"

/**
 * Severity settings parsed from a command-line or environment override.
 */
struct LogSpec {
    std::optional<LogLevel>                       level;      /**< Global threshold, when specified. */
    std::vector<std::pair<LogCategory, LogLevel>> categories; /**< Per-category threshold overrides. */
};

/**
 * Parses a logging threshold specification and category overrides.
 */
std::optional<LogSpec> LogParseSpec(std::string_view spec);
/**
 * Returns the active threshold for a category after applying overrides.
 */
LogLevel LogEffectiveLevel(LogCategory category);
/**
 * Reports whether console output is enabled by the logging settings.
 */
bool LogConsoleEnabled();

/**
 * Receives diagnostic records on the logging backend thread.
 */
using LogCaptureHook = void (*)(std::string_view logger, LogLevel level, std::string_view message);
/**
 * Installs a callback that observes records delivered by the backend.
 */
void LogSetCaptureHook(LogCaptureHook hook);

/**
 * Removes older session logs beyond the configured retention count.
 */
void LogPruneDirectory(const std::filesystem::path &directory, int keep, const std::filesystem::path &current);

/**
 * Accumulates game printf text and logs complete lines in the PS2 category.
 */
void Ps2PrintfWrite(std::string_view text);
/**
 * Logs any incomplete game printf line waiting in the buffer.
 */
void Ps2PrintfFlush();
