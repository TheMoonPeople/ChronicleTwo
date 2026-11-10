#pragma once

// stderr capture around code that logs: the logger writes stderr from its own thread, so both ends wait for
// what was logged before them.

#include <gtest/gtest.h>

#include <string>

#include "log/log.hpp"

inline void CaptureLoggedStderr() {
    LogFlush();
    testing::internal::CaptureStderr();
}

inline std::string GetLoggedStderr() {
    LogFlush();
    return testing::internal::GetCapturedStderr();
}
