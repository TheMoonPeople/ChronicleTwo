#pragma once

// The port's logger (docs/LOGGING.md), on Quill. A CT_LOG_* call only copies its arguments into the calling
// thread's queue; the ct-log thread formats them and writes stderr and the session's log file.

// libgraph.h names GS register fields as one-letter macros, which Quill's bundled fmt uses as template parameters.
#pragma push_macro("A")
#pragma push_macro("B")
#pragma push_macro("G")
#pragma push_macro("R")
#undef A
#undef B
#undef G
#undef R
#include <quill/LogMacros.h>
#include <quill/Logger.h>
#pragma pop_macro("R")
#pragma pop_macro("G")
#pragma pop_macro("B")
#pragma pop_macro("A")

#include <atomic>
#include <chrono>
#include <concepts>
#include <cstddef>
#include <filesystem>
#include <format>
#include <string>
#include <string_view>

#include "log/log_config.hpp"

/**
 * Startup settings available before the game configuration is loaded.
 */
struct LogBootOptions {
    bool        headless = false;         /**< Whether startup runs without a visible window. */
    const char *level_override = nullptr; /**< Threshold specification from the command line or environment. */
};

/**
 * Starts console logging and creates the process session identifier.
 */
void LogInit(const LogBootOptions &options);
/**
 * Opens the session log beside the save root and applies retention settings.
 */
void LogAttachFile(const std::filesystem::path &save_root, const LogConfig &config);
/**
 * Applies updated console and category logging settings.
 */
void LogApplyConfig(const LogConfig &config);
/**
 * Waits until all previously queued diagnostic records are written.
 */
void LogFlush();
/**
 * Flushes queued records within a crash handler's time budget.
 */
bool LogFlushForCrash(std::chrono::milliseconds budget);
/**
 * Reports whether the caller runs on the logging backend thread.
 */
bool LogIsBackendThread();
/**
 * Drains pending records and stops the logging backend.
 */
void LogShutdown();
/**
 * Returns the identifier shared by all logs from this process.
 */
std::string_view LogSessionId();
/**
 * Returns the active session log path when a file is attached.
 */
const std::filesystem::path &LogFilePath();
/**
 * Prepares the caller's queue for later logging without allocation.
 */
void LogThreadReady();
/**
 * Checks whether a logging threshold specification is valid.
 */
bool LogSpecValid(std::string_view spec);

namespace log_detail {

/** Index of the file-only session logger after the category loggers. */
inline constexpr std::size_t kSessionLogger = static_cast<std::size_t>(LogCategory::Count);
/** Lazily initialized logger pointers for every category and the session. */
inline std::atomic<quill::Logger *> g_loggers[kSessionLogger + 1];
/** Whether the logging backend has stopped. */
inline std::atomic<bool> g_stopped{false};

// Set while the thread's thread_local objects are destroyed, Quill's queue among them: on a thread's exit, and on
// the thread that calls std::exit before the atexit handlers run.
/** Whether the caller's thread-local queue is being destroyed. */
inline thread_local bool t_exiting = false;

/**
 * Registers the caller's exit marker before using its logging queue.
 */
void MarkThreadUse();

/**
 * Creates the logger associated with an index on first use.
 */
quill::Logger *CreateLoggers(std::size_t index);
/**
 * Writes a diagnostic record directly after queueing becomes unavailable.
 */
void WriteLate(std::size_t index, LogLevel level, std::string_view message);
/**
 * Formats a diagnostic record outside the logging backend.
 */
std::string FormatLate(std::string_view format, std::format_args args);

/**
 * Returns a category logger or indicates that direct writing is required.
 */
inline quill::Logger *Logger(std::size_t index) {
    MarkThreadUse();
    if (t_exiting || g_stopped.load(std::memory_order_relaxed)) {
        return nullptr;
    }
    quill::Logger *logger = g_loggers[index].load(std::memory_order_acquire);
    return logger != nullptr ? logger : CreateLoggers(index);
}

/**
 * Reports whether a severity survives the compile-time logging threshold.
 */
constexpr bool Compiled(LogLevel level) {
    constexpr int quill_levels[] = {
        QUILL_COMPILE_ACTIVE_LOG_LEVEL_TRACE_L1,
        QUILL_COMPILE_ACTIVE_LOG_LEVEL_DEBUG,
        QUILL_COMPILE_ACTIVE_LOG_LEVEL_INFO,
        QUILL_COMPILE_ACTIVE_LOG_LEVEL_WARNING,
        QUILL_COMPILE_ACTIVE_LOG_LEVEL_ERROR,
        QUILL_COMPILE_ACTIVE_LOG_LEVEL_CRITICAL,
    };
    return level < LogLevel::Off && quill_levels[static_cast<std::size_t>(level)] >= QUILL_COMPILE_ACTIVE_LOG_LEVEL;
}

/**
 * Writes a record directly when the backend queue is unavailable.
 */
template <class... Args>
void Late(std::size_t index, LogLevel level, std::string_view format, const Args &...args) {
    if (!Compiled(level)) {
        return;
    }
    if constexpr ((std::formattable<Args, char> && ...)) {
        WriteLate(index, level, FormatLate(format, std::make_format_args(args...)));
    } else {
        WriteLate(index, level, format);
    }
}

} // namespace log_detail

#define CT_LOG_CALL_(quill_call, level, index, fmt, ...)                                  \
    do {                                                                                  \
        if (quill::Logger *ct_log_logger_ = ::log_detail::Logger(index)) {                \
            quill_call(ct_log_logger_, fmt, ##__VA_ARGS__);                               \
        } else {                                                                          \
            ::log_detail::Late(index, ::LogLevel::level, fmt __VA_OPT__(, ) __VA_ARGS__); \
        }                                                                                 \
    } while (0)

#define CT_LOG_INDEX_(category) static_cast<std::size_t>(::LogCategory::category)

// CT_LOG_INFO(Data, "dataread: indexed {} files", count): the message is what stderr shows, so it keeps
// its "<module>: " prefix; the category filters it and names it in the file. Arguments are formatted
// with Quill's fmt (std::format syntax) on the backend thread.
#define CT_LOG_TRACE(category, fmt, ...) CT_LOG_CALL_(QUILL_LOG_TRACE_L1, Trace, CT_LOG_INDEX_(category), fmt, ##__VA_ARGS__)
#define CT_LOG_DEBUG(category, fmt, ...) CT_LOG_CALL_(QUILL_LOG_DEBUG, Debug, CT_LOG_INDEX_(category), fmt, ##__VA_ARGS__)
#define CT_LOG_INFO(category, fmt, ...) CT_LOG_CALL_(QUILL_LOG_INFO, Info, CT_LOG_INDEX_(category), fmt, ##__VA_ARGS__)
#define CT_LOG_WARN(category, fmt, ...) CT_LOG_CALL_(QUILL_LOG_WARNING, Warning, CT_LOG_INDEX_(category), fmt, ##__VA_ARGS__)
#define CT_LOG_ERROR(category, fmt, ...) CT_LOG_CALL_(QUILL_LOG_ERROR, Error, CT_LOG_INDEX_(category), fmt, ##__VA_ARGS__)
#define CT_LOG_CRITICAL(category, fmt, ...) CT_LOG_CALL_(QUILL_LOG_CRITICAL, Critical, CT_LOG_INDEX_(category), fmt, ##__VA_ARGS__)

// For per-frame sites: at most one line per interval (a std::chrono duration) per call site and thread;
// the line ends " (Nx)" for the N calls it stands for.
#define CT_LOG_LIMIT_(quill_call, level, interval, category, fmt, ...)                                      \
    do {                                                                                                    \
        if (quill::Logger *ct_log_logger_ = ::log_detail::Logger(CT_LOG_INDEX_(category))) {                \
            quill_call(interval, ct_log_logger_, fmt, ##__VA_ARGS__);                                       \
        } else {                                                                                            \
            ::log_detail::Late(CT_LOG_INDEX_(category), ::LogLevel::level, fmt __VA_OPT__(, ) __VA_ARGS__); \
        }                                                                                                   \
    } while (0)
#define CT_LOG_TRACE_LIMIT(interval, category, fmt, ...) CT_LOG_LIMIT_(QUILL_LOG_TRACE_L1_LIMIT, Trace, interval, category, fmt, ##__VA_ARGS__)
#define CT_LOG_DEBUG_LIMIT(interval, category, fmt, ...) CT_LOG_LIMIT_(QUILL_LOG_DEBUG_LIMIT, Debug, interval, category, fmt, ##__VA_ARGS__)
#define CT_LOG_INFO_LIMIT(interval, category, fmt, ...) CT_LOG_LIMIT_(QUILL_LOG_INFO_LIMIT, Info, interval, category, fmt, ##__VA_ARGS__)
#define CT_LOG_WARN_LIMIT(interval, category, fmt, ...) CT_LOG_LIMIT_(QUILL_LOG_WARNING_LIMIT, Warning, interval, category, fmt, ##__VA_ARGS__)
#define CT_LOG_ERROR_LIMIT(interval, category, fmt, ...) CT_LOG_LIMIT_(QUILL_LOG_ERROR_LIMIT, Error, interval, category, fmt, ##__VA_ARGS__)

// Every nth occurrence per call site and thread, starting with the first.
#define CT_LOG_DEBUG_EVERY_N(n, category, fmt, ...) CT_LOG_LIMIT_(QUILL_LOG_DEBUG_LIMIT_EVERY_N, Debug, n, category, fmt, ##__VA_ARGS__)
#define CT_LOG_INFO_EVERY_N(n, category, fmt, ...) CT_LOG_LIMIT_(QUILL_LOG_INFO_LIMIT_EVERY_N, Info, n, category, fmt, ##__VA_ARGS__)
#define CT_LOG_WARN_EVERY_N(n, category, fmt, ...) CT_LOG_LIMIT_(QUILL_LOG_WARNING_LIMIT_EVERY_N, Warning, n, category, fmt, ##__VA_ARGS__)

// To the log file only, under "session": the session header and other lines stderr never showed.
#define CT_LOG_FILE_INFO(fmt, ...) CT_LOG_CALL_(QUILL_LOG_INFO, Info, ::log_detail::kSessionLogger, fmt, ##__VA_ARGS__)
