#include "crash/crash.hpp"

#include <cstdio>
#include <cstdlib>
#include <exception>

#include "log/log.hpp"

/**
 * Records uncaught C++ failures in the console diagnostics before termination.
 */
void CrashInit([[maybe_unused]] const CrashInitOptions &options) {
    std::set_terminate([] {
        if (const auto exception = std::current_exception()) {
            try {
                std::rethrow_exception(exception);
            } catch (const std::exception &error) {
                CrashReportAndExit(CrashKind::Terminate, error.what(), EXIT_FAILURE);
            } catch (...) {
            }
        }
        CrashReportAndExit(CrashKind::Terminate, "unhandled C++ exception", EXIT_FAILURE);
    });
}

/**
 * Retains the common crash interface when console diagnostics own failure reports.
 */
void CrashSetBundleRoot([[maybe_unused]] const std::filesystem::path &save_root) {}

/**
 * Leaves previous console failures available through the development-unit diagnostics.
 */
void CrashShowLastReportNotice() {}

/**
 * Writes a controlled failure to the application log and ends the process.
 */
[[noreturn]] void CrashReportAndExit(CrashKind kind, std::string_view message, int exit_status) {
    std::fprintf(stderr, "Dark Chronicle failure %u: %.*s\n", static_cast<unsigned>(kind),
                 static_cast<int>(message.size()), message.data());
    if (!LogIsBackendThread()) {
        LogFlush();
    }
    std::exit(exit_status);
}
