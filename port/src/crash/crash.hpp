#pragma once

#include <cstdint>
#include <filesystem>
#include <optional>
#include <string_view>

/**
 * Identifies a game-state value included in a crash report.
 */
enum class CrashKey : std::uint8_t {
    Loop,
    Map,
    Floor,
    Event,
    Frame,
    Scene,
    LastAsset,
    Fiber,
    Count,
};

/**
 * Identifies the failure that ended the process.
 */
enum class CrashKind : std::uint8_t {
    Assert,
    Unimplemented,
    Fatal,
    Abort,
    Terminate,
    Signal,
};

/**
 * Controls whether crash reporting may show a dialog.
 */
struct CrashInitOptions {
    bool headless = false; /**< Suppresses dialogs during unattended runs. */
};

/**
 * Installs signal, exception, and termination handlers after logging starts.
 */
void CrashInit(const CrashInitOptions &options);
/**
 * Sets the save directory used for crash report bundles.
 */
void CrashSetBundleRoot(const std::filesystem::path &save_root);
/**
 * Records a game-state value for future crash reports.
 */
void CrashContextSet(CrashKey key, std::string_view value);
/**
 * Records an integer game-state value for future crash reports.
 */
void CrashContextSetInt(CrashKey key, long long value);
/**
 * Reports a controlled failure and ends the process with its exit status.
 */
[[noreturn]] void CrashReportAndExit(CrashKind kind, std::string_view message, int exit_status);
/**
 * Shows the previous crash notice when the window is available.
 */
void CrashShowLastReportNotice();

/**
 * Selects a controlled failure for crash reporting tests.
 */
enum class CrashTestMode : std::uint8_t {
    None,
    Segv,
    Abort,
    Assert,
    Unimplemented,
    Terminate,
    StackOverflow,
    AudioThread,
};

/**
 * Selects when a crash reporting test fires.
 */
enum class CrashTestWhen : std::uint8_t {
    Early,
    FirstFrame,
};

/**
 * Stores a crash reporting test and its trigger time.
 */
struct CrashTest {
    CrashTestMode mode = CrashTestMode::None;       /**< Selects the deliberate failure. */
    CrashTestWhen when = CrashTestWhen::FirstFrame; /**< Selects the failure trigger time. */
};

/**
 * Parses a crash reporting test option.
 */
std::optional<CrashTest> CrashTestParse(std::string_view text);
/**
 * Arms a crash reporting test or fires an early test immediately.
 */
void CrashTestArm(const CrashTest &test, CrashTestWhen now);
/**
 * Triggers a deliberate failure for a crash reporting test.
 */
[[noreturn]] void CrashTestFire(CrashTestMode mode);

namespace crash_detail {
inline CrashTestMode g_armed_test = CrashTestMode::None; /**< Test armed for the next game frame. */
} // namespace crash_detail

/**
 * Records the frame number and fires an armed crash reporting test.
 */
inline void CrashFrameEnd(int frame) {
    CrashContextSetInt(CrashKey::Frame, frame);
    if (crash_detail::g_armed_test != CrashTestMode::None) [[unlikely]] {
        CrashTestFire(crash_detail::g_armed_test);
    }
}
