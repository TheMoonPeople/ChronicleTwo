#include "log/log.hpp"

#include <quill/Backend.h>
#include <quill/Frontend.h>
#include <quill/sinks/Sink.h>

#include <algorithm>
#include <array>
#include <cctype>
#include <charconv>
#include <cstdint>
#include <cstdio>
#include <ctime>
#include <format>
#include <memory>
#include <mutex>
#include <print>
#include <random>
#include <string>
#include <system_error>
#include <thread>

#ifdef __linux__
#include <cerrno> // program_invocation_short_name
#endif
#ifndef _WIN32
#include <pthread.h>
#endif
#if defined(__APPLE__)
#include <TargetConditionals.h>
#if TARGET_OS_IPHONE
#include <sys/qos.h>
#endif
#endif

#include "kazarov/log.hpp"
#include "log/log_internal.hpp"
#include "platform/paths.hpp"
#include "platform/settings.hpp"

namespace {

/** Number of diagnostic categories with independently configured thresholds. */
constexpr std::size_t kCategoryCount = static_cast<std::size_t>(LogCategory::Count);

/** Lowercase names used for category configuration and file records. */
constexpr std::array<std::string_view, kCategoryCount> kCategoryNames = {
    "main",
    "config",
    "data",
    "gfx",
    "audio",
    "input",
    "save",
    "menu",
    "event",
    "dungeon",
    "town",
    "movie",
    "script",
    "memory",
    "ps2",
    "kazarov",
    "crash",
};
/** Lowercase names accepted in severity configuration. */
constexpr std::array<std::string_view, 7> kLevelNames = {"trace", "debug", "info", "warning", "error", "critical", "off"};
/** Name used for messages written only to the session file. */
constexpr std::string_view kSessionLoggerName = "session";
/** Name used for records that acknowledge a crash flush. */
constexpr std::string_view kFlushLoggerName = "ct-log-flush";
/** Prefix identifying session log files. */
constexpr std::string_view kLogPrefix = "darkchronicle-";
/** Suffix identifying session log files. */
constexpr std::string_view kLogSuffix = ".log";
// Past this the file only takes warnings and worse, so a runaway loop cannot fill the disk.
/** Maximum file size before low-severity records are discarded. */
constexpr std::uint64_t kSoftCapBytes = 256ull << 20;
// Lines logged before LogAttachFile, held for the file.
/** Maximum buffer for records emitted before the file opens. */
constexpr std::size_t kEarlyBufferBytes = 1 << 20;

std::string Lower(std::string_view text) {
    std::string lower(text);
    std::ranges::transform(lower, lower.begin(), [](unsigned char c) { return static_cast<char>(std::tolower(c)); });
    return lower;
}

std::string_view Trim(std::string_view text) {
    constexpr std::string_view space = " \t";
    const std::size_t          first = text.find_first_not_of(space);
    if (first == std::string_view::npos) {
        return {};
    }
    return text.substr(first, text.find_last_not_of(space) - first + 1);
}

quill::LogLevel QuillLevel(LogLevel level) {
    switch (level) {
        case LogLevel::Trace:
            return quill::LogLevel::TraceL1;
        case LogLevel::Debug:
            return quill::LogLevel::Debug;
        case LogLevel::Info:
            return quill::LogLevel::Info;
        case LogLevel::Warning:
            return quill::LogLevel::Warning;
        case LogLevel::Error:
            return quill::LogLevel::Error;
        case LogLevel::Critical:
            return quill::LogLevel::Critical;
        case LogLevel::Off:
            break;
    }
    return quill::LogLevel::None;
}

LogLevel PortLevel(quill::LogLevel level) {
    switch (level) {
        case quill::LogLevel::TraceL3:
        case quill::LogLevel::TraceL2:
        case quill::LogLevel::TraceL1:
            return LogLevel::Trace;
        case quill::LogLevel::Debug:
            return LogLevel::Debug;
        case quill::LogLevel::Info:
        case quill::LogLevel::Notice:
            return LogLevel::Info;
        case quill::LogLevel::Warning:
            return LogLevel::Warning;
        case quill::LogLevel::Error:
            return LogLevel::Error;
        default:
            return LogLevel::Critical;
    }
}

std::string_view FileLevelName(LogLevel level) {
    constexpr std::array<std::string_view, 7> short_names = {"TRACE", "DEBUG", "INFO ", "WARN ", "ERROR", "CRIT ", "OFF  "};
    return short_names[static_cast<std::size_t>(level)];
}

/** Whether the console sink currently writes records. */
std::atomic<bool> g_console{true};
/** Callback used to observe records delivered by the backend. */
std::atomic<LogCaptureHook> g_capture{nullptr};
/** Most recent crash flush marker acknowledged by the backend. */
std::atomic<std::uint64_t> g_flush_done{0};
/** Most recent crash flush marker requested by a caller. */
std::atomic<std::uint64_t> g_flush_requested{0};

// Settings, guarded by g_state_mutex; levels are pushed into the loggers whenever they change.
/** Protects logging settings and the attached file path. */
std::mutex g_state_mutex;
/** Current settings loaded from the game configuration. */
LogConfig g_config;
/** Overrides supplied at process startup. */
LogSpec g_boot_spec;
/** Root directory for the session log. */
std::filesystem::path g_save_root;
/** Whether the save root has been attached to logging. */
bool g_file_attached = false;
/** Path to the current session log file. */
std::filesystem::path g_file_path;

/**
 * Values delivered to a sink for one diagnostic record.
 */
struct Record {
    std::uint64_t    timestamp_ns; /**< Time when the record was created. */
    LogLevel         level;        /**< Severity assigned to the record. */
    std::string_view thread;       /**< Name or identifier of the producing thread. */
    std::string_view logger;       /**< Category or session name of the record. */
    std::string_view message;      /**< Formatted diagnostic message. */
};

/**
 * Converts Quill callbacks into diagnostic records for specialized sinks.
 */
class RecordSink : public quill::Sink {
protected:
    virtual void Take(const Record &record) = 0;

    void write_log(const quill::MacroMetadata * /*log_metadata*/, std::uint64_t log_timestamp,
                   std::string_view thread_id, std::string_view thread_name, const std::string & /*process_id*/,
                   std::string_view logger_name, quill::LogLevel log_level,
                   std::string_view /*log_level_description*/, std::string_view /*log_level_short_code*/,
                   const std::vector<std::pair<std::string, std::string> > * /*named_args*/,
                   std::string_view log_message, std::string_view /*log_statement*/) final {
#if defined(__APPLE__) && TARGET_OS_IPHONE
        // Sinks run on the ct-log thread, which writes in the background: on iOS it takes the utility class the first
        // time, so the scheduler prefers the efficiency cores for it over the game's and the renderer's cores.
        static thread_local const bool background = [] { return pthread_set_qos_class_self_np(QOS_CLASS_UTILITY, 0) == 0; }();
        (void) background;
#endif
        Take({.timestamp_ns = log_timestamp,
              .level = PortLevel(log_level),
              .thread = Named(thread_name) ? thread_name : thread_id,
              .logger = logger_name,
              .message = log_message});
    }

    void flush_sink() override {}

private:
    // Quill reads no thread names on MinGW and says so in the name. An unnamed Linux thread carries the program's
    // name (cut to the kernel's 15 characters), inherited from the thread that started it, so its id is shown.
    static bool Named(std::string_view thread_name) {
#ifdef __linux__
        return !thread_name.empty() && thread_name != "ThreadNameDisabled" &&
               thread_name != std::string_view(program_invocation_short_name).substr(0, 15);
#else
        return !thread_name.empty() && thread_name != "ThreadNameDisabled";
#endif
    }
};

/**
 * Writes diagnostic messages to stderr without metadata prefixes.
 */
class ConsoleSink final : public RecordSink {
protected:
    void Take(const Record &record) override {
        if (!g_console.load(std::memory_order_relaxed)) {
            return;
        }
        // One write per line keeps it whole beside Kazarov's and the game's own stderr output.
        line.assign(record.message);
        line.push_back('\n');
        std::fwrite(line.data(), 1, line.size(), stderr);
    }

    void flush_sink() override { std::fflush(stderr); }

private:
    std::string line; /**< Reusable output buffer for one console record. */
};

/**
 * Writes timestamped diagnostic records to the session log file.
 */
class FileSink final : public RecordSink {
public:
    bool Open(const std::filesystem::path &path) {
        const std::scoped_lock lock(mutex);
        if (file != nullptr) {
            return true;
        }
#ifdef _WIN32
        file = _wfopen(path.c_str(), L"ab");
#else
        file = std::fopen(path.c_str(), "ab");
#endif
        if (file == nullptr) {
            early.clear();
            buffering = false;
            return false;
        }
        std::fwrite(early.data(), 1, early.size(), file);
        bytes += early.size();
        early.clear();
        early.shrink_to_fit();
        buffering = false;
        std::fflush(file);
        return true;
    }

    void Close() {
        const std::scoped_lock lock(mutex);
        if (file != nullptr) {
            std::fclose(file);
            file = nullptr;
        }
        early.clear();
        early.shrink_to_fit();
        buffering = false;
    }

    // A line from a thread that cannot queue it, written now.
    void WriteDirect(LogLevel level, std::string_view logger_name, std::string_view message) {
        const auto             now = std::chrono::system_clock::now().time_since_epoch();
        const auto             thread = std::to_string(quill::detail::get_thread_id());
        const std::scoped_lock lock(mutex);
        Append({.timestamp_ns =
                    static_cast<std::uint64_t>(std::chrono::duration_cast<std::chrono::nanoseconds>(now).count()),
                .level = level,
                .thread = thread,
                .logger = logger_name,
                .message = message});
        if (file != nullptr) {
            std::fflush(file);
        }
    }

    // Writes what has reached the sink; the backend thread calls it, or a crash handler when the backend is gone.
    void FlushNow() {
        const std::scoped_lock lock(mutex);
        if (file != nullptr) {
            std::fflush(file);
        }
    }

protected:
    void Take(const Record &record) override {
        const std::scoped_lock lock(mutex);
        Append(record);
    }

    void flush_sink() override { FlushNow(); }

private:
    // mutex held.
    void Append(const Record &record) {
        if (file == nullptr && !buffering) {
            return;
        }
        if (capped && record.level < LogLevel::Warning) {
            return;
        }
        line.clear();
        AppendTime(record.timestamp_ns);
        std::format_to(std::back_inserter(line), " {} [{}] {:<8} {}\n", FileLevelName(record.level), record.thread,
                       record.logger, record.message);
        if (!capped && bytes + line.size() > kSoftCapBytes) {
            capped = true;
            std::string notice = line.substr(0, 23);
            std::format_to(std::back_inserter(notice),
                           " WARN  [{}] {:<8} log: the file reached {} MiB; only warnings and errors follow\n",
                           record.thread, kSessionLoggerName, kSoftCapBytes >> 20);
            Write(notice);
            if (record.level < LogLevel::Warning) {
                return;
            }
        }
        Write(line);
    }

    void Write(std::string_view text) {
        bytes += text.size();
        if (file != nullptr) {
            std::fwrite(text.data(), 1, text.size(), file);
        } else if (early.size() + text.size() <= kEarlyBufferBytes) {
            early.append(text);
        }
    }

    // yyyy-mm-dd hh:mm:ss.mmm in local time; the date and time are reformatted once a second.
    void AppendTime(std::uint64_t timestamp_ns) {
        const auto seconds = static_cast<std::time_t>(timestamp_ns / 1'000'000'000);
        if (seconds != cached_second) {
            cached_second = seconds;
            std::tm local{};
#ifdef _WIN32
            localtime_s(&local, &seconds);
#else
            localtime_r(&seconds, &local);
#endif
            char              text[32];
            const std::size_t size = std::strftime(text, sizeof text, "%Y-%m-%d %H:%M:%S", &local);
            cached_time.assign(text, size);
        }
        line.append(cached_time);
        std::format_to(std::back_inserter(line), ".{:03}", timestamp_ns / 1'000'000 % 1000);
    }

    std::mutex    mutex;              /**< Protects the file and its output buffers. */
    std::FILE    *file = nullptr;     /**< Current session log file, when open. */
    bool          buffering = true;   /**< Whether early records are retained before opening a file. */
    bool          capped = false;     /**< Whether the soft file size cap has been reached. */
    std::uint64_t bytes = 0;          /**< Total bytes accepted for this session log. */
    std::string   early;              /**< Records awaiting attachment of the session file. */
    std::string   line;               /**< Reusable output buffer for one file record. */
    std::time_t   cached_second = -1; /**< Second represented by cached_time. */
    std::string   cached_time;        /**< Formatted date and time prefix for cached_second. */
};

/**
 * Forwards diagnostic records to an installed capture callback.
 */
class CaptureSink final : public RecordSink {
protected:
    void Take(const Record &record) override {
        if (LogCaptureHook hook = g_capture.load(std::memory_order_acquire); hook != nullptr) {
            hook(record.logger, record.level, record.message);
        }
    }
};

/** File sink retained for diagnostics emitted during static destruction. */
FileSink *g_file_sink = nullptr;
/** Effective thresholds used when records bypass the backend queue. */
std::atomic<LogLevel> g_levels[kCategoryCount];

/**
 * Acknowledges crash flush markers after the backend writes pending records.
 */
class FlushMarkerSink final : public RecordSink {
protected:
    void Take(const Record &record) override {
        std::uint64_t marker = 0;
        std::from_chars(record.message.data(), record.message.data() + record.message.size(), marker);
        std::fflush(stderr);
        g_file_sink->FlushNow();
        std::uint64_t done = g_flush_done.load(std::memory_order_relaxed);
        while (done < marker && !g_flush_done.compare_exchange_weak(done, marker, std::memory_order_release)) {
        }
    }
};

/** Logger that sends crash flush markers to the backend. */
quill::Logger *g_flush_logger = nullptr;

// Pushes the current settings into the loggers; g_state_mutex held.
void ApplyLevelsLocked() {
    for (std::size_t i = 0; i < kCategoryCount; ++i) {
        const LogLevel level = LogEffectiveLevel(static_cast<LogCategory>(i));
        g_levels[i].store(level, std::memory_order_relaxed);
        if (quill::Logger *logger = log_detail::g_loggers[i].load(std::memory_order_acquire)) {
            logger->set_log_level(QuillLevel(level));
        }
    }
    g_console.store(g_config.console, std::memory_order_relaxed);
}

/** Ensures that the logging backend and its sinks start once. */
std::once_flag g_start_once;

quill::BackendOptions PortBackendOptions() {
    quill::BackendOptions options;
    options.thread_name = "ct-log";
    options.sleep_duration = std::chrono::milliseconds{1};
    // UTF-8 paths and the game's Shift-JIS text pass through as they are.
    options.check_printable_char = {};
    options.error_notifier = [](const std::string &error) { std::println(stderr, "log: {}", error); };
    return options;
}

#ifndef _WIN32
/** Whether the parent process restarts the backend after a fork. */
bool g_restart_after_fork = false;

// A forked child (a test's) has no backend thread, and one stopped mid-wait would leave its condition variable
// unusable there, hanging the child's exit. So the backend is stopped, its queues drained, before a fork and
// restarted in the parent after; the child writes its lines directly.
void InstallForkHandlers() {
    pthread_atfork(
        [] {
            g_restart_after_fork = !log_detail::g_stopped.load(std::memory_order_acquire) &&
                                   quill::Backend::is_running() && !LogIsBackendThread();
            if (g_restart_after_fork) {
                quill::Backend::stop();
            }
        },
        [] {
            if (g_restart_after_fork) {
                quill::Backend::start(PortBackendOptions());
            }
        },
        [] { log_detail::g_stopped.store(true, std::memory_order_release); });
}
#endif

void Start() {
    quill::Backend::start(PortBackendOptions());
#ifndef _WIN32
    InstallForkHandlers();
#endif

    const quill::PatternFormatterOptions pattern{"%(message)"};
    auto                                 console = quill::Frontend::create_or_get_sink<ConsoleSink>("ct-console");
    auto                                 file = quill::Frontend::create_or_get_sink<FileSink>("ct-file");
    auto                                 capture = quill::Frontend::create_or_get_sink<CaptureSink>("ct-capture");
    static const auto *const             kept_file = new std::shared_ptr<quill::Sink>(file);
    g_file_sink = static_cast<FileSink *>(kept_file->get());
    for (std::size_t i = 0; i <= kCategoryCount; ++i) {
        std::vector<std::shared_ptr<quill::Sink> > sinks;
        // The game's printf reaches stdout directly (ps2_printf.cpp); the session logger is the file's alone.
        if (i < kCategoryCount && static_cast<LogCategory>(i) != LogCategory::Ps2) {
            sinks.push_back(console);
        }
        sinks.push_back(file);
        sinks.push_back(capture);
        const std::string name(i < kCategoryCount ? kCategoryNames[i] : kSessionLoggerName);
        quill::Logger    *logger = quill::Frontend::create_or_get_logger(name, std::move(sinks), pattern);
        log_detail::g_loggers[i].store(logger, std::memory_order_release);
    }
    log_detail::g_loggers[log_detail::kSessionLogger].load()->set_log_level(quill::LogLevel::Info);
    g_flush_logger = quill::Frontend::create_or_get_logger(
        std::string(kFlushLoggerName), quill::Frontend::create_or_get_sink<FlushMarkerSink>("ct-flush"), pattern);

    const std::scoped_lock lock(g_state_mutex);
    ApplyLevelsLocked();
}

void EnsureStarted() {
    std::call_once(g_start_once, Start);
}

void KazarovSink(kz::LogLevel level, std::string_view subsystem, std::string_view message) {
    switch (level) {
        case kz::LogLevel::Debug:
            CT_LOG_DEBUG(Kazarov, "{}: {}", subsystem, message);
            break;
        case kz::LogLevel::Info:
            CT_LOG_INFO(Kazarov, "{}: {}", subsystem, message);
            break;
        case kz::LogLevel::Warning:
            CT_LOG_WARN(Kazarov, "{}: {}", subsystem, message);
            break;
        case kz::LogLevel::Error:
            CT_LOG_ERROR(Kazarov, "{}: {}", subsystem, message);
            // Kazarov often aborts right after an error, and death tests read it from stderr.
            LogFlush();
            break;
        case kz::LogLevel::Fatal:
            CT_LOG_CRITICAL(Kazarov, "{}: {}", subsystem, message);
            LogFlush();
            break;
    }
}

// Opens or closes the file to match the settings; g_state_mutex held.
void ApplyFileLocked() {
    if (!g_file_attached) {
        return;
    }
    const char *env = SettingsEnv("LOG_FILE");
    const bool  wanted = g_config.file && (env == nullptr || std::string_view(env) != "0") && !g_save_root.empty();
    if (!wanted) {
        g_file_sink->Close();
        g_file_path.clear();
        return;
    }
    if (!g_file_path.empty()) {
        return;
    }
    const std::filesystem::path directory = (g_save_root / ".." / "logs").lexically_normal();
    std::error_code             error;
    std::filesystem::create_directories(directory, error);
    std::filesystem::path path = directory / std::format("{}{}{}", kLogPrefix, LogSessionId(), kLogSuffix);
    if (!g_file_sink->Open(path)) {
        CT_LOG_WARN(Main, "log: could not open {}; logging to stderr only", PathsDisplay(path));
        return;
    }
    g_file_path = std::move(path);
    LogPruneDirectory(directory, g_config.keep, g_file_path);
}

/** Protects the partial game printf line. */
std::mutex g_ps2_mutex;
/** Game printf text held until its terminating newline. */
std::string g_ps2_pending;

} // namespace

void log_detail::MarkThreadUse() {
    if (t_exiting) {
        return;
    }

    /**
     * Marks the caller as exiting before its logging queue is destroyed.
     */
    struct ExitMark {
        ~ExitMark() { t_exiting = true; }
    };

    thread_local ExitMark exit_mark;
    static_cast<void>(&exit_mark);
}

void log_detail::WriteLate(std::size_t index, LogLevel level, std::string_view message) {
    const bool session = index == kSessionLogger;
    if (level < (session ? LogLevel::Info : g_levels[index].load(std::memory_order_relaxed))) {
        return;
    }
    const auto category = session ? LogCategory::Count : static_cast<LogCategory>(index);
    if (!session && category != LogCategory::Ps2 && g_console.load(std::memory_order_relaxed)) {
        std::string line(message);
        line.push_back('\n');
        std::fwrite(line.data(), 1, line.size(), stderr);
    }
    if (g_file_sink != nullptr) {
        g_file_sink->WriteDirect(level, session ? kSessionLoggerName : kCategoryNames[index], message);
    }
}

std::string log_detail::FormatLate(std::string_view format, std::format_args args) {
    try {
        return std::vformat(format, args);
    } catch (const std::format_error &) {
        return std::string(format);
    }
}

quill::Logger *log_detail::CreateLoggers(std::size_t index) {
    EnsureStarted();
    return g_loggers[index].load(std::memory_order_acquire);
}

std::string_view LogCategoryName(LogCategory category) {
    return kCategoryNames[static_cast<std::size_t>(category)];
}

std::string_view LogLevelName(LogLevel level) {
    return kLevelNames[static_cast<std::size_t>(level)];
}

std::optional<LogCategory> LogCategoryFromName(std::string_view name) {
    const std::string lower = Lower(name);
    for (std::size_t i = 0; i < kCategoryCount; ++i) {
        if (lower == kCategoryNames[i]) {
            return static_cast<LogCategory>(i);
        }
    }
    return std::nullopt;
}

std::optional<LogLevel> LogLevelFromName(std::string_view name) {
    const std::string lower = Lower(name);
    if (lower == "warn") {
        return LogLevel::Warning;
    }
    for (std::size_t i = 0; i < kLevelNames.size(); ++i) {
        if (lower == kLevelNames[i]) {
            return static_cast<LogLevel>(i);
        }
    }
    return std::nullopt;
}

std::optional<LogSpec> LogParseSpec(std::string_view spec) {
    LogSpec result;
    if (Trim(spec).empty()) {
        return std::nullopt;
    }
    for (bool more = true; more;) {
        const std::size_t      comma = spec.find(',');
        const std::string_view item = Trim(spec.substr(0, comma));
        more = comma != std::string_view::npos;
        spec = more ? spec.substr(comma + 1) : std::string_view{};
        const std::size_t equals = item.find('=');
        if (equals == std::string_view::npos) {
            const std::optional<LogLevel> level = LogLevelFromName(item);
            if (!level) {
                return std::nullopt;
            }
            result.level = level;
            continue;
        }
        const std::optional<LogCategory> category = LogCategoryFromName(Trim(item.substr(0, equals)));
        const std::optional<LogLevel>    level = LogLevelFromName(Trim(item.substr(equals + 1)));
        if (!category || !level) {
            return std::nullopt;
        }
        result.categories.emplace_back(*category, *level);
    }
    return result;
}

bool LogSpecValid(std::string_view spec) {
    return LogParseSpec(spec).has_value();
}

LogLevel LogEffectiveLevel(LogCategory category) {
    const auto find = [category](const std::vector<std::pair<LogCategory, LogLevel> > &levels) {
        const auto it = std::ranges::find_if(levels, [category](const auto &entry) { return entry.first == category; });
        return it == levels.end() ? std::nullopt : std::optional(it->second);
    };
    if (const std::optional<LogLevel> level = find(g_boot_spec.categories)) {
        return *level;
    }
    if (g_boot_spec.level) {
        return *g_boot_spec.level;
    }
    if (const std::optional<LogLevel> level = find(g_config.categories)) {
        return *level;
    }
    return g_config.level.value_or(kLogLevelDefault);
}

bool LogConsoleEnabled() {
    return g_console.load(std::memory_order_relaxed);
}

void LogSetCaptureHook(LogCaptureHook hook) {
    EnsureStarted();
    g_capture.store(hook, std::memory_order_release);
}

void LogInit(const LogBootOptions &options) {
    EnsureStarted();
    LogSpec spec;
    bool    valid = true;
    if (options.level_override != nullptr && *options.level_override != '\0') {
        if (std::optional<LogSpec> parsed = LogParseSpec(options.level_override)) {
            spec = std::move(*parsed);
        } else {
            valid = false;
        }
    }
    {
        const std::scoped_lock lock(g_state_mutex);
        g_boot_spec = std::move(spec);
        ApplyLevelsLocked();
    }
    if (!valid) {
        CT_LOG_WARN(Main, "log: ignoring the log level \"{}\"", options.level_override);
    }
    kz::SetLogSink(KazarovSink);
}

void LogAttachFile(const std::filesystem::path &save_root, const LogConfig &config) {
    EnsureStarted();
    const std::scoped_lock lock(g_state_mutex);
    g_save_root = save_root;
    g_config = config;
    g_file_attached = true;
    ApplyLevelsLocked();
    ApplyFileLocked();
}

void LogApplyConfig(const LogConfig &config) {
    EnsureStarted();
    const std::scoped_lock lock(g_state_mutex);
    g_config = config;
    ApplyLevelsLocked();
    ApplyFileLocked();
}

void LogFlush() {
    if (log_detail::t_exiting || log_detail::g_stopped.load(std::memory_order_acquire) || !quill::Backend::is_running() || LogIsBackendThread()) {
        return;
    }
    EnsureStarted();
    g_flush_logger->flush_log();
}

bool LogFlushForCrash(std::chrono::milliseconds budget) {
    if (g_flush_logger == nullptr || LogIsBackendThread()) {
        return false;
    }
    if (log_detail::g_stopped.load(std::memory_order_acquire) || !quill::Backend::is_running()) {
        // Nothing is queued once the backend has stopped; what reached the file only needs writing.
        g_file_sink->FlushNow();
        return true;
    }
    if (log_detail::t_exiting) {
        // This thread can no longer queue the marker.
        g_file_sink->FlushNow();
        return false;
    }
    const std::uint64_t marker = g_flush_requested.fetch_add(1, std::memory_order_relaxed) + 1;
    QUILL_LOG_CRITICAL(g_flush_logger, "{}", marker);
    const auto deadline = std::chrono::steady_clock::now() + budget;
    while (g_flush_done.load(std::memory_order_acquire) < marker) {
        if (std::chrono::steady_clock::now() >= deadline) {
            return false;
        }
        quill::Backend::notify();
        std::this_thread::sleep_for(std::chrono::milliseconds{1});
    }
    return true;
}

bool LogIsBackendThread() {
    const std::uint32_t backend = quill::Backend::get_thread_id();
    return backend != 0 && backend == quill::detail::get_thread_id();
}

void LogShutdown() {
    if (log_detail::g_stopped.load(std::memory_order_acquire) || g_flush_logger == nullptr) {
        return;
    }
    // Called from atexit, the thread's own queue may already be gone, so nothing is queued here.
    log_detail::g_stopped.store(true, std::memory_order_release);
    quill::Backend::stop();
    g_file_sink->FlushNow();
}

std::string_view LogSessionId() {
    static const std::string id = [] {
        const std::time_t now = std::time(nullptr);
        std::tm           local{};
#ifdef _WIN32
        localtime_s(&local, &now);
#else
        localtime_r(&now, &local);
#endif
        char text[32];
        std::strftime(text, sizeof text, "%Y%m%d-%H%M%S", &local);
        std::random_device random;
        return std::format("{}-{:04x}", text, random() & 0xffff);
    }();
    return id;
}

const std::filesystem::path &LogFilePath() {
    return g_file_path;
}

void LogThreadReady() {
    EnsureStarted();
    quill::Frontend::preallocate();
}

void LogPruneDirectory(const std::filesystem::path &directory, int keep, const std::filesystem::path &current) {
    std::error_code                    error;
    std::vector<std::filesystem::path> logs;
    for (const auto &entry : std::filesystem::directory_iterator(directory, error)) {
        const std::string name = PathsDisplay(entry.path().filename());
        if (name.starts_with(kLogPrefix) && name.ends_with(kLogSuffix) && entry.path() != current &&
            entry.is_regular_file(error)) {
            logs.push_back(entry.path());
        }
    }
    // Session ids start with the date and time, so names sort oldest first.
    std::ranges::sort(logs, std::greater{});
    const std::size_t others = static_cast<std::size_t>(std::max(keep, 1) - (current.empty() ? 0 : 1));
    for (std::size_t i = others; i < logs.size(); ++i) {
        std::filesystem::remove(logs[i], error);
    }
}

void Ps2PrintfWrite(std::string_view text) {
    const std::scoped_lock lock(g_ps2_mutex);
    while (!text.empty()) {
        const std::size_t newline = text.find('\n');
        if (newline == std::string_view::npos) {
            g_ps2_pending.append(text);
            return;
        }
        g_ps2_pending.append(text.substr(0, newline));
        text.remove_prefix(newline + 1);
        if (g_ps2_pending.ends_with('\r')) {
            g_ps2_pending.pop_back();
        }
        CT_LOG_DEBUG(Ps2, "{}", g_ps2_pending);
        g_ps2_pending.clear();
    }
}

void Ps2PrintfFlush() {
    const std::scoped_lock lock(g_ps2_mutex);
    if (!g_ps2_pending.empty()) {
        CT_LOG_DEBUG(Ps2, "{}", g_ps2_pending);
        g_ps2_pending.clear();
    }
}
