#pragma once

// State passed from the crashing thread to the report writer.

#include <cpptrace/basic.hpp>

#include <cstddef>
#include <cstdint>
#include <functional>
#include <string>
#include <string_view>

#include "crash/crash.hpp"

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#endif

namespace crash_detail {

inline constexpr std::size_t kMaxFrames = 128;   /**< Maximum number of captured stack frames. */
inline constexpr std::size_t kMaxRegisters = 40; /**< Maximum number of captured registers. */

/**
 * Stores the failure and the crashing thread's captured state.
 */
struct Capture {
    CrashKind     kind = CrashKind::Signal;            /**< Classifies the failure. */
    char          message[1024] = {};                  /**< Describes a controlled failure. */
    std::size_t   message_length = 0;                  /**< Length of the failure description. */
    bool          is_fault = false;                    /**< Distinguishes an OS fault from a controlled failure. */
    int           signal = 0;                          /**< POSIX signal number. */
    int           signal_code = 0;                     /**< POSIX signal detail. */
    std::uint32_t exception_code = 0;                  /**< Windows exception code. */
    int           access = -1;                         /**< Windows memory access type. */
    bool          has_fault_address = false;           /**< Indicates whether the fault address is known. */
    std::uint64_t fault_address = 0;                   /**< Address associated with the fault. */
    std::uint64_t thread_id = 0;                       /**< Identifier of the crashing thread. */
    bool          main_thread = false;                 /**< Indicates a failure on the main thread. */
    bool          log_backend_thread = false;          /**< Indicates a failure on the logging thread. */
    const char   *register_names[kMaxRegisters] = {};  /**< Names of captured registers. */
    std::uint64_t register_values[kMaxRegisters] = {}; /**< Values of captured registers. */
    std::size_t   register_count = 0;                  /**< Number of captured registers. */
    std::uint64_t frames[kMaxFrames] = {};             /**< Captured program counters. */
    std::size_t   frame_count = 0;                     /**< Number of captured program counters. */
#ifdef _WIN32
    CONTEXT context = {};          /**< Windows thread context for unwinding. */
    bool    has_context = false;   /**< Indicates whether a thread context was captured. */
    int     context_skip = 0;      /**< Handler frames excluded from the trace. */
    bool    context_exact = false; /**< Indicates whether the context points at the fault. */
#endif

    /**
     * Copies the failure description into the capture buffer.
     */
    void SetMessage(std::string_view text);
};

/**
 * Writes a crash bundle and shows its dialog when allowed.
 */
void WriteBundle(Capture &capture, bool show_dialog);
/**
 * Appends text to the current crash report or standard error.
 */
void AppendRaw(std::string_view text);
/**
 * Prepares build identity and unwinding before crash handling begins.
 */
void WriterWarmUp();
/**
 * Sets the paths and privacy roots used by crash bundles.
 */
void WriterSetBundleRoot(const std::string &save_root_utf8, const std::string &data_root_utf8);
/**
 * Reports whether a crash bundle destination is configured.
 */
bool WriterHasBundle();
/**
 * Returns the crash bundle directory as UTF-8.
 */
std::string_view WriterBundleDir();
/**
 * Returns the crash report path as UTF-8.
 */
std::string_view WriterReportPath();

/**
 * Finds the function name associated with a program address.
 */
std::string SymbolTableName(std::uint64_t address);

/**
 * Resolves unique program counters and restores every original physical and inlined frame.
 */
cpptrace::stacktrace ResolveFrames(const cpptrace::raw_trace                                              &raw,
                                   const std::function<cpptrace::stacktrace(const cpptrace::raw_trace &)> &resolver);

/**
 * Returns the current operating system thread identifier.
 */
std::uint64_t CurrentThreadId();
/**
 * Reports whether crash dialogs and notices are enabled.
 */
bool DialogsAllowed();

#ifdef _WIN32
/**
 * Shows the Windows crash dialog for a completed report.
 */
void ShowCrashDialog(std::string_view summary, std::string_view bundle_dir, std::string_view report_path);
#endif

} // namespace crash_detail
