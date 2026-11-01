// The report writer: runs on its own thread once a crash has been captured.

#include <cpptrace/basic.hpp>
#include <platform/paths.hpp>

#include <algorithm>
#include <array>
#include <atomic>
#include <cctype>
#include <chrono>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <filesystem>
#include <format>
#include <fstream>
#include <iterator>
#include <span>
#include <sstream>
#include <string>
#include <system_error>
#include <vector>

#include "crash/crash_capture.hpp"
#include "crash/crash_detail.hpp"
#include "log/log.hpp"

#ifndef _WIN32
#include <dlfcn.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>

#include <cerrno>
#include <csignal>
extern char **environ;
#endif

#ifdef __linux__
#include <link.h>
#elifdef __APPLE__
#include <mach-o/dyld.h>
#include <mach-o/loader.h>
#endif

#ifndef CT_CRASH_BUILD_TYPE
#define CT_CRASH_BUILD_TYPE ""
#endif

namespace {

using crash_detail::Capture;
using crash_detail::Text;

// Where this file sits in the source tree tells the tree's root, which symbolised paths are shown relative to.
constexpr std::string_view SourceRoot() {
    constexpr std::string_view file = __FILE__;
    constexpr std::string_view tail = "port/src/crash/crash_report.cpp";
    if (file.size() < tail.size()) {
        return {};
    }
    return file.substr(0, file.size() - tail.size());
}

/**
 * Stores the paths and privacy roots for one crash report bundle.
 */
struct Bundle {
    bool                      ready = false;   /**< Indicates configured bundle paths. */
    std::string               crashes_dir;     /**< UTF-8 path to the crash directory. */
    std::string               dir;             /**< UTF-8 path to the current bundle. */
    std::string               report;          /**< UTF-8 path to the report file. */
    std::filesystem::path     crashes_path;    /**< Filesystem path to the crash directory. */
    std::filesystem::path     dir_path;        /**< Filesystem path to the current bundle. */
    std::filesystem::path     report_path;     /**< Filesystem path to the report file. */
    std::filesystem::path     last_crash_path; /**< Filesystem path to the previous crash notice. */
    std::filesystem::path     config_path;     /**< Filesystem path to the game configuration. */
    crash_detail::RedactRoots roots;           /**< Private paths replaced in report content. */
};

Bundle            g_bundle;                    /**< Destination and paths for a crash bundle. */
std::string       g_build_id;                  /**< Identifier of the running executable. */
std::atomic<bool> g_exiting{false};            /**< Indicates that static destruction has begun. */
char              g_session_fallback[24] = {}; /**< Session identifier used before logging starts. */

#ifdef _WIN32
HANDLE g_report = INVALID_HANDLE_VALUE; /**< Handle of the active report file. */
#else
int g_report = -1; /**< Descriptor of the active report file. */
#endif

char g_scratch[16 * 1024]; /**< Scratch buffer used while writing report sections. */

void WriteTo(std::string_view text, bool to_stderr) {
#ifdef _WIN32
    HANDLE handle = to_stderr ? GetStdHandle(STD_ERROR_HANDLE) : g_report;
    if (handle == INVALID_HANDLE_VALUE || handle == nullptr) {
        return;
    }
    while (!text.empty()) {
        DWORD written = 0;
        if (!WriteFile(handle, text.data(), static_cast<DWORD>(std::min<std::size_t>(text.size(), 1 << 20)), &written, nullptr) ||
            written == 0) {
            return;
        }
        text.remove_prefix(written);
    }
#else
    const int fd = to_stderr ? STDERR_FILENO : g_report;
    if (fd < 0) {
        return;
    }
    while (!text.empty()) {
        const ssize_t written = write(fd, text.data(), text.size());
        if (written <= 0) {
            return;
        }
        text.remove_prefix(static_cast<std::size_t>(written));
    }
#endif
}

bool ReportOpen() {
#ifdef _WIN32
    return g_report != INVALID_HANDLE_VALUE;
#else
    return g_report >= 0;
#endif
}

// Without a bundle the report goes to stderr whole.
void Emit(std::string_view text) {
    WriteTo(text, !ReportOpen());
}

void Emit(const Text &text) {
    Emit(text.View());
}

bool MakeDirectory(const std::filesystem::path &path) {
#ifdef _WIN32
    return CreateDirectoryW(path.c_str(), nullptr) != 0 || GetLastError() == ERROR_ALREADY_EXISTS;
#else
    return mkdir(path.c_str(), 0755) == 0 || errno == EEXIST;
#endif
}

void OpenReport() {
    if (!g_bundle.ready || !MakeDirectory(g_bundle.crashes_path) || !MakeDirectory(g_bundle.dir_path)) {
        return;
    }
#ifdef _WIN32
    g_report = CreateFileW(g_bundle.report_path.c_str(), GENERIC_WRITE, FILE_SHARE_READ, nullptr, CREATE_ALWAYS,
                           FILE_ATTRIBUTE_NORMAL, nullptr);
#else
    g_report = open(g_bundle.report_path.c_str(), O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644);
#endif
}

void CloseReport() {
#ifdef _WIN32
    if (g_report != INVALID_HANDLE_VALUE) {
        FlushFileBuffers(g_report);
        CloseHandle(g_report);
        g_report = INVALID_HANDLE_VALUE;
    }
#else
    if (g_report >= 0) {
        fsync(g_report);
        close(g_report);
        g_report = -1;
    }
#endif
}

std::string_view Session() {
    const std::string_view session = LogSessionId();
    return session.empty() ? std::string_view(g_session_fallback) : session;
}

void FormatTimeUtc(Text &out) {
    int year = 0;
    int month = 0;
    int day = 0;
    int hour = 0;
    int minute = 0;
    int second = 0;
#ifdef _WIN32
    SYSTEMTIME now;
    GetSystemTime(&now);
    year = now.wYear;
    month = now.wMonth;
    day = now.wDay;
    hour = now.wHour;
    minute = now.wMinute;
    second = now.wSecond;
#else
    const std::time_t now = std::time(nullptr);
    std::tm           parts{};
    gmtime_r(&now, &parts);
    year = parts.tm_year + 1900;
    month = parts.tm_mon + 1;
    day = parts.tm_mday;
    hour = parts.tm_hour;
    minute = parts.tm_min;
    second = parts.tm_sec;
#endif
    auto two = [&](int value) {
        out.Put(static_cast<char>('0' + value / 10 % 10)).Put(static_cast<char>('0' + value % 10));
    };
    out.Dec(year).Put('-');
    two(month);
    out.Put('-');
    two(day);
    out.Put('T');
    two(hour);
    out.Put(':');
    two(minute);
    out.Put(':');
    two(second);
    out.Put('Z');
}

std::string_view ExceptionName(const Capture &capture) {
#ifdef _WIN32
    switch (capture.exception_code) {
        case EXCEPTION_ACCESS_VIOLATION:
            return "EXCEPTION_ACCESS_VIOLATION";
        case EXCEPTION_ARRAY_BOUNDS_EXCEEDED:
            return "EXCEPTION_ARRAY_BOUNDS_EXCEEDED";
        case EXCEPTION_BREAKPOINT:
            return "EXCEPTION_BREAKPOINT";
        case EXCEPTION_DATATYPE_MISALIGNMENT:
            return "EXCEPTION_DATATYPE_MISALIGNMENT";
        case EXCEPTION_FLT_DIVIDE_BY_ZERO:
            return "EXCEPTION_FLT_DIVIDE_BY_ZERO";
        case EXCEPTION_FLT_INVALID_OPERATION:
            return "EXCEPTION_FLT_INVALID_OPERATION";
        case EXCEPTION_ILLEGAL_INSTRUCTION:
            return "EXCEPTION_ILLEGAL_INSTRUCTION";
        case EXCEPTION_IN_PAGE_ERROR:
            return "EXCEPTION_IN_PAGE_ERROR";
        case EXCEPTION_INT_DIVIDE_BY_ZERO:
            return "EXCEPTION_INT_DIVIDE_BY_ZERO";
        case EXCEPTION_INT_OVERFLOW:
            return "EXCEPTION_INT_OVERFLOW";
        case EXCEPTION_PRIV_INSTRUCTION:
            return "EXCEPTION_PRIV_INSTRUCTION";
        case EXCEPTION_STACK_OVERFLOW:
            return "EXCEPTION_STACK_OVERFLOW";
        case 0xC0000374:
            return "STATUS_HEAP_CORRUPTION";
        case 0xC0000409:
            return "STATUS_STACK_BUFFER_OVERRUN";
        default:
            return "exception";
    }
#else
    switch (capture.signal) {
        case SIGSEGV:
            return "SIGSEGV";
        case SIGBUS:
            return "SIGBUS";
        case SIGILL:
            return "SIGILL";
        case SIGFPE:
            return "SIGFPE";
        case SIGABRT:
            return "SIGABRT";
        case SIGTRAP:
            return "SIGTRAP";
        default:
            return "signal";
    }
#endif
}

#ifndef _WIN32
std::string_view SignalCodeName(int signal, int code) {
    if (code == SI_USER) {
        return "SI_USER";
    }
    switch (signal) {
        case SIGSEGV:
            return code == SEGV_MAPERR ? "SEGV_MAPERR" : code == SEGV_ACCERR ? "SEGV_ACCERR"
                                                                             : "";
        case SIGBUS:
            return code == BUS_ADRALN ? "BUS_ADRALN" : code == BUS_ADRERR ? "BUS_ADRERR"
                                                   : code == BUS_OBJERR   ? "BUS_OBJERR"
                                                                          : "";
        case SIGFPE:
            return code == FPE_INTDIV ? "FPE_INTDIV" : code == FPE_INTOVF ? "FPE_INTOVF"
                                                   : code == FPE_FLTDIV   ? "FPE_FLTDIV"
                                                   : code == FPE_FLTINV   ? "FPE_FLTINV"
                                                                          : "";
        case SIGILL:
            return code == ILL_ILLOPC ? "ILL_ILLOPC" : code == ILL_PRVOPC ? "ILL_PRVOPC"
                                                   : code == ILL_ILLOPN   ? "ILL_ILLOPN"
                                                                          : "";
        default:
            return "";
    }
}
#endif

#ifdef _WIN32
std::string_view AccessVerb(int access) {
    switch (access) {
        case 1:
            return " writing ";
        case 8:
            return " executing ";
        default:
            return " reading ";
    }
}
#endif

// One line saying what happened, for the report, stderr and the dialog.
void FormatSummary(Text &out, const Capture &capture) {
    if (capture.is_fault) {
        out.Put(ExceptionName(capture));
#ifdef _WIN32
        if (capture.exception_code == EXCEPTION_ACCESS_VIOLATION) {
            out.Put(AccessVerb(capture.access)).Pointer(capture.fault_address);
        } else {
            out.Put(" (0x").Hex(capture.exception_code, 8).Put(") at ").Pointer(capture.fault_address);
        }
#else
        const std::string_view code = SignalCodeName(capture.signal, capture.signal_code);
        if (!code.empty()) {
            out.Put(" (").Put(code).Put(')');
        }
        if (capture.has_fault_address) {
            out.Put(" at ").Pointer(capture.fault_address);
        }
#endif
        return;
    }
    out.Put(crash_detail::CrashKindName(capture.kind)).Put(": ").Put(std::string_view(capture.message, capture.message_length));
}

// --- Raw frames ----------------------------------------------------------------------------------

#ifdef _WIN32
bool Readable(std::uint64_t address) {
    MEMORY_BASIC_INFORMATION info;
    // NOLINTNEXTLINE(performance-no-int-to-ptr): a code or stack address from the unwinder
    if (VirtualQuery(reinterpret_cast<const void *>(address), &info, sizeof(info)) == 0) {
        return false;
    }
    constexpr DWORD readable = PAGE_READONLY | PAGE_READWRITE | PAGE_WRITECOPY | PAGE_EXECUTE_READ | PAGE_EXECUTE_READWRITE | PAGE_EXECUTE_WRITECOPY;
    return info.State == MEM_COMMIT && (info.Protect & readable) != 0 && (info.Protect & PAGE_GUARD) == 0;
}

// Walks the crashed thread's stack from its saved context with the images' unwind tables.
void UnwindContext(Capture &capture) {
    CONTEXT     context = capture.context;
    int         skip = capture.context_skip;
    std::size_t n = 0;
    for (int depth = 0; depth < 512 && n < crash_detail::kMaxFrames; depth++) {
#if defined(_M_ARM64) || defined(__aarch64__)
        DWORD64 &pc = context.Pc;
        DWORD64 &sp = context.Sp;
#else
        DWORD64 &pc = context.Rip;
        DWORD64 &sp = context.Rsp;
#endif
        if (pc == 0 || !Readable(sp)) {
            break;
        }
        const bool exact = depth == 0 && capture.context_exact;
        if (skip > 0) {
            skip--;
        } else {
            capture.frames[n++] = exact ? pc : pc - 1;
        }
        const DWORD64 previous_pc = pc;
        const DWORD64 previous_sp = sp;
        DWORD64       image_base = 0;
        if (PRUNTIME_FUNCTION function = RtlLookupFunctionEntry(pc, &image_base, nullptr); function != nullptr) {
            void   *handler_data = nullptr;
            DWORD64 establisher = 0;
            RtlVirtualUnwind(UNW_FLAG_NHANDLER, image_base, pc, function, &context, &handler_data, &establisher, nullptr);
        } else {
#if defined(_M_ARM64) || defined(__aarch64__)
            pc = context.Lr;
#else
            // NOLINTNEXTLINE(performance-no-int-to-ptr): a code or stack address from the unwinder
            pc = *reinterpret_cast<const DWORD64 *>(sp);
            sp += 8;
#endif
        }
        if (pc == previous_pc && sp == previous_sp) {
            break;
        }
    }
    capture.frame_count = n;
}
#endif

// The module holding address: its file name (not its path) and load base.
std::string_view ModuleFor(std::uint64_t address, std::span<char, 260> name, std::uint64_t &base) {
    base = 0;
#ifdef _WIN32
    HMODULE module = nullptr;
    if (!GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                            // NOLINTNEXTLINE(performance-no-int-to-ptr): a code address from the unwinder
                            reinterpret_cast<LPCWSTR>(address), &module)) {
        return {};
    }
    wchar_t     path[MAX_PATH];
    const DWORD length = GetModuleFileNameW(module, path, MAX_PATH);
    if (length == 0) {
        return {};
    }
    const wchar_t *file = path;
    for (DWORD i = 0; i < length; i++) {
        if (path[i] == L'\\' || path[i] == L'/') {
            file = path + i + 1;
        }
    }
    const int written = WideCharToMultiByte(CP_UTF8, 0, file, static_cast<int>(path + length - file), name.data(),
                                            static_cast<int>(name.size()), nullptr, nullptr);
    base = reinterpret_cast<std::uintptr_t>(module);
    return {name.data(), static_cast<std::size_t>(std::max(written, 0))};
#else
    Dl_info info{};
    // NOLINTNEXTLINE(performance-no-int-to-ptr): a code or stack address from the unwinder
    if (dladdr(reinterpret_cast<void *>(address), &info) == 0 || info.dli_fbase == nullptr) {
        return {};
    }
    base = reinterpret_cast<std::uintptr_t>(info.dli_fbase);
    const char *file = info.dli_fname != nullptr ? info.dli_fname : "";
    if (const char *slash = std::strrchr(file, '/'); slash != nullptr) {
        file = slash + 1;
    }
    const std::size_t length = std::min(std::strlen(file), name.size());
    std::memcpy(name.data(), file, length);
    return {name.data(), length};
#endif
}

// --- Sections ------------------------------------------------------------------------------------

void WriteHeader(const Capture &capture) {
    char              frame_text[crash_detail::kSlotSize + 1] = {};
    const std::size_t frame_length = crash_detail::ContextRead(CrashKey::Frame, std::span<char, crash_detail::kSlotSize>(frame_text, crash_detail::kSlotSize));
    long long         frame = -1;
    if (frame_length > 0) {
        frame = std::strtoll(frame_text, nullptr, 10);
    }
    char time_buffer[32];
    Text time(time_buffer, sizeof(time_buffer));
    FormatTimeUtc(time);
    const crash_detail::HeaderInfo info{
        .kind = crash_detail::CrashKindName(capture.kind),
        .session = Session(),
        .build_id = g_build_id,
        .build_type = CT_CRASH_BUILD_TYPE,
        .platform = crash_detail::PlatformName(),
        .time_utc = time.View(),
        .frame = frame,
    };
    Text out(g_scratch, sizeof(g_scratch));
    crash_detail::FormatHeader(out, info);
    Emit(out);
}

void WriteException(const Capture &capture) {
    Text out(g_scratch, sizeof(g_scratch));
    out.Put("\n== exception ==\n");
    FormatSummary(out, capture);
    out.Put('\n');
    if (capture.is_fault && capture.message_length > 0) {
        out.Put("message: ").Put(std::string_view(capture.message, capture.message_length)).Put('\n');
    }
    out.Put("thread: ").Dec(static_cast<long long>(capture.thread_id));
    if (capture.main_thread) {
        out.Put(" (main)");
    } else if (capture.log_backend_thread) {
        out.Put(" (log backend)");
    }
    out.Put('\n');
    if (capture.register_count > 0) {
        out.Put("\n== registers ==\n");
        for (std::size_t i = 0; i < capture.register_count; i++) {
            const std::string_view name = capture.register_names[i];
            out.Put(name);
            for (std::size_t pad = name.size(); pad < 7; pad++) {
                out.Put(' ');
            }
            out.Pointer(capture.register_values[i]).Put((i % 4 == 3 || i + 1 == capture.register_count) ? '\n' : ' ');
        }
    }
    Emit(out);
}

void WriteContext() {
    Text out(g_scratch, sizeof(g_scratch));
    out.Put("\n== game state ==\n");
    for (std::size_t i = 0; i < static_cast<std::size_t>(CrashKey::Count); i++) {
        const auto        key = static_cast<CrashKey>(i);
        char              value[crash_detail::kSlotSize];
        const std::size_t length = crash_detail::ContextRead(key, value);
        out.Put(crash_detail::CrashKeyName(key)).Put(": ").Put(length > 0 ? std::string_view(value, length) : "-").Put('\n');
    }
    Emit(out);
}

void WriteRawFrames(const Capture &capture) {
    Text out(g_scratch, sizeof(g_scratch));
    out.Put("\n== raw frames ==\n");
    for (std::size_t i = 0; i < capture.frame_count; i++) {
        char                   name_buffer[260];
        std::uint64_t          base = 0;
        const std::string_view name = ModuleFor(capture.frames[i], name_buffer, base);
        out.Put('#').Dec(static_cast<long long>(i));
        if (i < 10) {
            out.Put(' ');
        }
        out.Put(' ');
        if (name.empty()) {
            out.Put("??+0x").Hex(capture.frames[i]);
        } else {
            out.Put(name).Put("+0x").Hex(capture.frames[i] - base);
        }
        out.Put('\n');
        if (out.View().size() > sizeof(g_scratch) - 512) {
            Emit(out);
            out.Clear();
        }
    }
    Emit(out);
}

void PutJsonString(Text &out, std::string_view text) {
    out.Put('"');
    for (const char c : text) {
        if (c == '"' || c == '\\') {
            out.Put('\\').Put(c);
        } else if (static_cast<unsigned char>(c) < 0x20) {
            out.Put("\\u00").Hex(static_cast<unsigned char>(c), 2);
        } else {
            out.Put(c);
        }
    }
    out.Put('"');
}

// crashes/last_crash.json names the newest bundle for the next launch's notice.
void WriteLastCrash(const Capture &capture, bool notified) {
    if (!g_bundle.ready) {
        return;
    }
    static char buffer[4096];
    Text        out(buffer, sizeof(buffer));
    char        summary_buffer[1200];
    Text        summary(summary_buffer, sizeof(summary_buffer));
    FormatSummary(summary, capture);
    out.Put("{\n  \"session\": ");
    PutJsonString(out, Session());
    out.Put(",\n  \"kind\": ");
    PutJsonString(out, crash_detail::CrashKindName(capture.kind));
    out.Put(",\n  \"summary\": ");
    PutJsonString(out, summary.View());
    out.Put(",\n  \"bundle\": ");
    PutJsonString(out, g_bundle.dir);
    out.Put(",\n  \"report\": ");
    PutJsonString(out, g_bundle.report);
    out.Put(",\n  \"notified\": ").Put(notified ? "true" : "false").Put("\n}\n");
#ifdef _WIN32
    HANDLE file = CreateFileW(g_bundle.last_crash_path.c_str(), GENERIC_WRITE, 0, nullptr, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
    if (file != INVALID_HANDLE_VALUE) {
        DWORD written = 0;
        WriteFile(file, out.View().data(), static_cast<DWORD>(out.View().size()), &written, nullptr);
        CloseHandle(file);
    }
#else
    const int file = open(g_bundle.last_crash_path.c_str(), O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644);
    if (file >= 0) {
        const ssize_t written = write(file, out.View().data(), out.View().size());
        static_cast<void>(written);
        close(file);
    }
#endif
}

std::string DisplaySourcePath(std::string_view file) {
    std::string path(file);
    std::ranges::replace(path, '\\', '/');
    std::string root(SourceRoot());
    std::ranges::replace(root, '\\', '/');
    if (!root.empty() && path.size() > root.size()) {
        const bool match = std::equal(root.begin(), root.end(), path.begin(), [](char a, char b) {
            return std::tolower(static_cast<unsigned char>(a)) == std::tolower(static_cast<unsigned char>(b));
        });
        if (match) {
            return path.substr(root.size());
        }
    }
    return crash_detail::RedactPath(path, g_bundle.roots);
}

void WriteSymbolised(const Capture &capture) {
    std::string out = "\n== stack trace ==\n";
    if (g_exiting.load(std::memory_order_acquire)) {
        Emit(out + "skipped: the process was exiting; tools/crash/symbolize.py resolves the raw frames\n");
        return;
    }
    try {
        cpptrace::raw_trace raw;
        const auto          frames = std::span(capture.frames).first(capture.frame_count);
        raw.frames.assign(frames.begin(), frames.end());
        const cpptrace::stacktrace trace = crash_detail::ResolveFrames(raw, [](const cpptrace::raw_trace &unique) { return unique.resolve(); });
        std::size_t                index = 0;
        for (const cpptrace::stacktrace_frame &frame : trace.frames) {
            out += frame.is_inline ? "    " : std::format("#{:<3}", index);
            out += frame.symbol.empty() ? std::string("??") : frame.symbol;
            if (!frame.filename.empty()) {
                out += " at ";
                out += DisplaySourcePath(frame.filename);
                if (frame.line.has_value()) {
                    out += std::format(":{}", frame.line.value());
                }
            }
            out += frame.is_inline ? " (inlined)\n" : "\n";
            if (!frame.is_inline) {
                index++;
            }
        }
    } catch (const std::exception &error) {
        out += std::format("symbolisation failed: {}\n", error.what());
    }
    Emit(out);
}

void WriteEnvironment() {
    std::string out = "\n== environment ==\n";
#ifdef _WIN32
    if (wchar_t *block = GetEnvironmentStringsW(); block != nullptr) {
        for (const wchar_t *entry = block; *entry != L'\0'; entry += std::wcslen(entry) + 1) {
            if (std::wcsncmp(entry, L"DC2_", 4) == 0) {
                out += crash_detail::RedactPath(PathsDisplay(std::filesystem::path(entry)), g_bundle.roots) + "\n";
            }
        }
        FreeEnvironmentStringsW(block);
    }
#else
    for (char **entry = environ; entry != nullptr && *entry != nullptr; entry++) {
        if (std::strncmp(*entry, "DC2_", 4) == 0) {
            out += crash_detail::RedactPath(*entry, g_bundle.roots) + "\n";
        }
    }
#endif
    Emit(out);
}

void CopyLog(const Capture &capture) {
    std::string out = "\n== log ==\n";
    if (capture.log_backend_thread) {
        out += "not flushed: the log backend thread crashed\n";
    } else if (!LogFlushForCrash(std::chrono::milliseconds(2000))) {
        out += "flush incomplete\n";
    }
    const std::filesystem::path &log = LogFilePath();
    if (log.empty()) {
        out += "no session log file\n";
    } else if (!g_bundle.ready) {
        out += crash_detail::RedactPath(PathsDisplay(log), g_bundle.roots) + "\n";
    } else {
        // A copy, not a move: the backend still holds the file open.
        std::error_code error;
        std::filesystem::copy_file(log, g_bundle.dir_path / "darkchronicle.log", std::filesystem::copy_options::overwrite_existing, error);
        out += error ? std::format("copy failed: {}\n", error.message()) : std::string("darkchronicle.log\n");
    }
    Emit(out);
}

void CopyConfig() {
    if (!g_bundle.ready) {
        return;
    }
    std::ifstream input(g_bundle.config_path, std::ios::binary);
    if (!input) {
        return;
    }
    std::ostringstream contents;
    contents << input.rdbuf();
    std::ofstream output(g_bundle.dir_path / "config.json", std::ios::binary | std::ios::trunc);
    output << crash_detail::RedactPath(contents.str(), g_bundle.roots);
}

#ifdef _WIN32
std::string ReadBuildId() {
    const auto                 *base = reinterpret_cast<const std::uint8_t *>(GetModuleHandleW(nullptr));
    const auto                 *dos = reinterpret_cast<const IMAGE_DOS_HEADER *>(base);
    const auto                 *nt = reinterpret_cast<const IMAGE_NT_HEADERS *>(base + dos->e_lfanew);
    const IMAGE_DATA_DIRECTORY &directory = nt->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_DEBUG];
    const auto                 *entries = reinterpret_cast<const IMAGE_DEBUG_DIRECTORY *>(base + directory.VirtualAddress);
    for (std::size_t i = 0; directory.VirtualAddress != 0 && i < directory.Size / sizeof(IMAGE_DEBUG_DIRECTORY); i++) {
        if (entries[i].Type != IMAGE_DEBUG_TYPE_CODEVIEW || entries[i].AddressOfRawData == 0) {
            continue;
        }
        const std::uint8_t *record = base + entries[i].AddressOfRawData;
        if (std::memcmp(record, "RSDS", 4) != 0) {
            continue;
        }
        // The symbol-server key: GUID fields in their printed order, then the age.
        GUID          guid;
        std::uint32_t age = 0;
        std::memcpy(&guid, record + 4, sizeof(guid));
        std::memcpy(&age, record + 20, sizeof(age));
        return std::format("{:08X}{:04X}{:04X}{:02X}{:02X}{:02X}{:02X}{:02X}{:02X}{:02X}{:02X}{:X}", guid.Data1, guid.Data2,
                           guid.Data3, guid.Data4[0], guid.Data4[1], guid.Data4[2], guid.Data4[3], guid.Data4[4],
                           guid.Data4[5], guid.Data4[6], guid.Data4[7], age);
    }
    return std::format("{:08X}{:X}", nt->FileHeader.TimeDateStamp, nt->OptionalHeader.SizeOfImage);
}
#elifdef __linux__
std::string ReadBuildId() {
    std::string id;
    dl_iterate_phdr(
        [](dl_phdr_info *info, std::size_t, void *data) -> int {
            auto &out = *static_cast<std::string *>(data);
            for (int i = 0; i < info->dlpi_phnum; i++) {
                const ElfW(Phdr) &header = info->dlpi_phdr[i];
                if (header.p_type != PT_NOTE) {
                    continue;
                }
                const auto *at = reinterpret_cast<const std::uint8_t *>(info->dlpi_addr + header.p_vaddr);
                const auto *end = at + header.p_memsz;
                while (at + sizeof(ElfW(Nhdr)) <= end) {
                    const auto *note = reinterpret_cast<const ElfW(Nhdr) *>(at);
                    const auto *name = at + sizeof(ElfW(Nhdr));
                    const auto *desc = name + ((note->n_namesz + 3) & ~3U);
                    if (note->n_type == NT_GNU_BUILD_ID && note->n_namesz == 4 && std::memcmp(name, "GNU", 4) == 0) {
                        for (std::size_t b = 0; b < note->n_descsz; b++) {
                            out += std::format("{:02x}", desc[b]);
                        }
                        return 1;
                    }
                    at = desc + ((note->n_descsz + 3) & ~3U);
                }
            }
            return 1; // the first object is the executable
        },
        &id);
    return id;
}
#elifdef __APPLE__
std::string ReadBuildId() {
    const auto *header = reinterpret_cast<const mach_header_64 *>(_dyld_get_image_header(0));
    const auto *at = reinterpret_cast<const std::uint8_t *>(header + 1);
    for (std::uint32_t i = 0; i < header->ncmds; i++) {
        const auto *command = reinterpret_cast<const load_command *>(at);
        if (command->cmd == LC_UUID) {
            const auto *uuid = reinterpret_cast<const uuid_command *>(at);
            std::string id;
            for (const std::uint8_t byte : uuid->uuid) {
                id += std::format("{:02X}", byte);
            }
            return id;
        }
        at += command->cmdsize;
    }
    return {};
}
#else
std::string ReadBuildId() {
    return {};
}
#endif

} // namespace

namespace crash_detail {

void WriterWarmUp() {
    g_build_id = ReadBuildId();
    // Loads the unwinder's back end (dbghelp on Windows) now rather than in a crash. Symbol tables are read
    // only when a report needs them: a reader still busy when the process exits would race its teardown.
    static_cast<void>(cpptrace::generate_raw_trace(0, 4));
    // Runs before the static destructors of everything built so far, cpptrace's caches among them.
    std::atexit([] { g_exiting.store(true, std::memory_order_release); });
}

void WriterSetBundleRoot(const std::string &save_root_utf8, const std::string &data_root_utf8) {
    Bundle bundle;
    bundle.roots.save_root = save_root_utf8;
    bundle.roots.data_root = data_root_utf8;
#ifdef _WIN32
    const char *home = std::getenv("USERPROFILE");
#else
    const char *home = std::getenv("HOME");
#endif
    bundle.roots.home = home != nullptr ? home : "";
    if (LogSessionId().empty() && g_session_fallback[0] == '\0') {
        const auto now = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
        std::tm    parts{};
#ifdef _WIN32
        gmtime_s(&parts, &now);
#else
        gmtime_r(&now, &parts);
#endif
        std::strftime(g_session_fallback, sizeof(g_session_fallback), "%Y%m%d-%H%M%S-0000", &parts);
    }
    const std::filesystem::path save_root = PathsFromUtf8(save_root_utf8);
    bundle.crashes_path = save_root / "crashes";
    bundle.dir_path = bundle.crashes_path / PathsFromUtf8(Session());
    bundle.report_path = bundle.dir_path / "report.txt";
    bundle.last_crash_path = bundle.crashes_path / "last_crash.json";
    bundle.config_path = (save_root / ".." / "config.json").lexically_normal();
    bundle.crashes_dir = PathsDisplay(bundle.crashes_path);
    bundle.dir = PathsDisplay(bundle.dir_path);
    bundle.report = PathsDisplay(bundle.report_path);
    bundle.ready = true;
    g_bundle = std::move(bundle);
}

bool WriterHasBundle() {
    return g_bundle.ready;
}

std::string_view WriterBundleDir() {
    return g_bundle.dir;
}

std::string_view WriterReportPath() {
    return g_bundle.report;
}

void AppendRaw(std::string_view text) {
    Emit(text);
}

void WriteBundle(Capture &capture, bool show_dialog) {
#ifdef _WIN32
    if (capture.has_context) {
        UnwindContext(capture);
    }
#endif
    OpenReport();
    // Steps 1-4 allocate nothing: a corrupt heap still leaves these.
    WriteHeader(capture);
    WriteException(capture);
    WriteContext();
    WriteRawFrames(capture);
    WriteLastCrash(capture, false);
    {
        Text out(g_scratch, sizeof(g_scratch));
        out.Put("crash: ");
        FormatSummary(out, capture);
        out.Put('\n');
        if (ReportOpen()) {
            out.Put("crash: report written to ").Put(g_bundle.report).Put('\n');
        }
        WriteTo(out.View(), true);
    }
    WriteSymbolised(capture);
    WriteEnvironment();
    CopyLog(capture);
    CopyConfig();
    Emit("\n== end ==\n");
    CloseReport();
#ifdef _WIN32
    if (show_dialog && g_bundle.ready) {
        Text summary(g_scratch, sizeof(g_scratch));
        FormatSummary(summary, capture);
        ShowCrashDialog(summary.View(), g_bundle.dir, g_bundle.report);
        WriteLastCrash(capture, true);
    }
#else
    static_cast<void>(show_dialog);
#endif
}

std::string_view CrashKindName(CrashKind kind) {
    switch (kind) {
        case CrashKind::Assert:
            return "assert";
        case CrashKind::Unimplemented:
            return "unimplemented";
        case CrashKind::Fatal:
            return "fatal";
        case CrashKind::Abort:
            return "abort";
        case CrashKind::Terminate:
            return "terminate";
        case CrashKind::Signal:
            return "crash";
    }
    return "?";
}

void FormatHeader(Text &out, const HeaderInfo &info) {
    out.Put("Dark Chronicle crash report\n");
    out.Put("kind:       ").Put(info.kind).Put('\n');
    out.Put("session:    ").Put(info.session.empty() ? "-" : info.session).Put('\n');
    out.Put("build id:   ").Put(info.build_id.empty() ? "-" : info.build_id).Put('\n');
    out.Put("build type: ").Put(info.build_type.empty() ? "-" : info.build_type).Put('\n');
    out.Put("platform:   ").Put(info.platform).Put('\n');
    out.Put("time:       ").Put(info.time_utc).Put('\n');
    out.Put("frame:      ");
    if (info.frame >= 0) {
        out.Dec(info.frame);
    } else {
        out.Put('-');
    }
    out.Put('\n');
}

std::string_view PlatformName() {
#if defined(_M_ARM64) || defined(__aarch64__)
#define CT_CRASH_ARCH "arm64"
#else
#define CT_CRASH_ARCH "x86_64"
#endif
#ifdef _WIN32
    return CT_CRASH_ARCH "-windows";
#elifdef __APPLE__
    return CT_CRASH_ARCH "-macos";
#else
    return CT_CRASH_ARCH "-linux";
#endif
#undef CT_CRASH_ARCH
}

std::string_view BuildId() {
    return g_build_id;
}

std::string RedactPath(std::string_view text, const RedactRoots &roots) {
    struct Replacement {
        std::string      from;
        std::string_view to;
    };

    std::vector<Replacement> replacements;
    auto                     add = [&](const std::string &root, std::string_view placeholder) {
        std::string trimmed = root;
        while (trimmed.size() > 1 && (trimmed.back() == '/' || trimmed.back() == '\\')) {
            trimmed.pop_back();
        }
        if (trimmed.empty()) {
            return;
        }
        std::string forward = trimmed;
        std::ranges::replace(forward, '\\', '/');
        std::string back = trimmed;
        std::ranges::replace(back, '/', '\\');
        std::string escaped;
        for (const char c : back) {
            escaped += c;
            if (c == '\\') {
                escaped += '\\';
            }
        }
        std::array<std::string, 3> spellings{std::move(escaped), std::move(back), std::move(forward)};
        for (std::string &spelling : spellings) {
            if (std::ranges::none_of(replacements, [&](const Replacement &r) { return r.from == spelling; })) {
                replacements.push_back({.from = std::move(spelling), .to = placeholder});
            }
        }
    };
    add(roots.save_root, "<save>");
    add(roots.data_root, "<data>");
    add(roots.home, "<home>");
    std::ranges::stable_sort(replacements, [](const Replacement &a, const Replacement &b) { return a.from.size() > b.from.size(); });

#ifdef _WIN32
    constexpr bool fold_case = true;
#else
    constexpr bool fold_case = false;
#endif
    auto matches = [&](std::string_view at, std::string_view root) {
        if (at.size() < root.size()) {
            return false;
        }
        for (std::size_t i = 0; i < root.size(); i++) {
            const char a = at[i];
            const char b = root[i];
            if (a != b && (!fold_case || std::tolower(static_cast<unsigned char>(a)) != std::tolower(static_cast<unsigned char>(b)))) {
                return false;
            }
        }
        // A root matches whole path components only.
        if (at.size() == root.size()) {
            return true;
        }
        const char next = at[root.size()];
        return next == '/' || next == '\\' || next == '"' || !std::isalnum(static_cast<unsigned char>(next));
    };
    std::string out;
    out.reserve(text.size());
    std::size_t i = 0;
    while (i < text.size()) {
        bool replaced = false;
        for (const Replacement &replacement : replacements) {
            if (matches(text.substr(i), replacement.from)) {
                out += replacement.to;
                i += replacement.from.size();
                replaced = true;
                break;
            }
        }
        if (!replaced) {
            out += text[i++];
        }
    }
    return out;
}

} // namespace crash_detail
