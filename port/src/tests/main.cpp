#include <gtest/gtest.h>

#include "identity.hpp"
#include "log/log.hpp"

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>

#include <cstdlib>
#endif

namespace {

class LogFlushListener final : public testing::EmptyTestEventListener {
    void OnTestStart(const testing::TestInfo &) override { LogFlush(); }

    void OnTestEnd(const testing::TestInfo &) override { LogFlush(); }
};

} // namespace

int main(int argc, char **argv) {
    GameSetIdentity();
#ifdef _WIN32
    SetErrorMode(SEM_FAILCRITICALERRORS | SEM_NOGPFAULTERRORBOX | SEM_NOOPENFILEERRORBOX);
    _set_abort_behavior(0, _WRITE_ABORT_MSG | _CALL_REPORTFAULT);
#endif
    testing::InitGoogleTest(&argc, argv);
    // A death test's child re-runs the binary rather than forking: a forked child has none of the parent's threads,
    // so exit() would wait forever on the Tracy profiler's.
    GTEST_FLAG_SET(death_test_style, "threadsafe");
    // Lines logged by one test reach stderr before the next test starts capturing it.
    testing::UnitTest::GetInstance()->listeners().Append(new LogFlushListener);
    return RUN_ALL_TESTS();
}
