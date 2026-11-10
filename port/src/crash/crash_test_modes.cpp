// The deliberate failures behind --crash-test. Each lives in its own named function, which a report's
// symbolised stack must show.

#include <SDL3/SDL.h>
#include <kazarov/port.h>

#include <array>
#include <cstdint>
#include <cstdlib>
#include <stdexcept>
#include <string_view>

#include "crash/crash.hpp"

// The game's assert handler (port/src/runtime.cpp), which MWCC's assert macro calls.
extern "C" [[noreturn]] void __assert(const char *file, int line, const char *expression);

namespace {

/**
 * Pairs a crash test option with its deliberate failure.
 */
struct ModeName {
    std::string_view name; /**< Command-line spelling of the failure. */
    CrashTestMode    mode; /**< Failure triggered by the option. */
};

// Crash modes accepted by the hidden test option.
constexpr std::array kModes = {
    ModeName{.name = "segv",          .mode = CrashTestMode::Segv         },
    ModeName{.name = "abort",         .mode = CrashTestMode::Abort        },
    ModeName{.name = "assert",        .mode = CrashTestMode::Assert       },
    ModeName{.name = "unimplemented", .mode = CrashTestMode::Unimplemented},
    ModeName{.name = "terminate",     .mode = CrashTestMode::Terminate    },
    ModeName{.name = "stackoverflow", .mode = CrashTestMode::StackOverflow},
    ModeName{.name = "audio-thread",  .mode = CrashTestMode::AudioThread  },
};

volatile std::uintptr_t g_bad_address = 0x10; /**< Invalid address used by the fault test. */

[[gnu::noinline]] void CrashTestSegv() {
    // NOLINTNEXTLINE(performance-no-int-to-ptr): the bad address is the point
    *reinterpret_cast<volatile int *>(g_bad_address) = 1;
}

[[gnu::noinline]] void CrashTestAbort() {
    std::abort();
}

[[gnu::noinline]] void CrashTestAssert() {
    __assert(__FILE__, __LINE__, "crash test");
}

[[gnu::noinline]] void CrashTestUnimplemented() {
    PS2_UNIMPLEMENTED();
}

[[gnu::noinline]] void CrashTestTerminate() {
    throw std::runtime_error("crash test");
}

[[gnu::noinline, clang::disable_tail_calls]] int CrashTestStackOverflow(int depth) {
    volatile char frame[4096];
    for (auto &byte : frame) {
        byte = static_cast<char>(depth);
    }
    // Four GiB of recursive frames exhausts the process stack before this finite stress budget.
    constexpr int frame_limit = 1 << 20;
    if (depth >= frame_limit) {
        return frame[0];
    }
    return CrashTestStackOverflow(depth + 1) + frame[0];
}

// Not a tail call, so the callback keeps its own frame in the trace.
[[clang::disable_tail_calls]] void SDLCALL CrashTestAudioCallback([[maybe_unused]] void *user_data, [[maybe_unused]] SDL_AudioStream *stream,
                                                                  [[maybe_unused]] int additional, [[maybe_unused]] int total) {
    CrashTestSegv();
}

// Faults on SDL's audio thread, through a stream of its own (the dummy driver where there is no device).
[[gnu::noinline]] void CrashTestAudioThread() {
    if (!SDL_InitSubSystem(SDL_INIT_AUDIO)) {
        SDL_SetHint(SDL_HINT_AUDIO_DRIVER, "dummy");
        SDL_InitSubSystem(SDL_INIT_AUDIO);
    }
    const SDL_AudioSpec spec{.format = SDL_AUDIO_S16, .channels = 2, .freq = 48000};
    SDL_AudioStream    *stream = SDL_OpenAudioDeviceStream(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, &spec, CrashTestAudioCallback, nullptr);
    if (stream == nullptr) {
        SDL_QuitSubSystem(SDL_INIT_AUDIO);
        SDL_SetHint(SDL_HINT_AUDIO_DRIVER, "dummy");
        SDL_InitSubSystem(SDL_INIT_AUDIO);
        stream = SDL_OpenAudioDeviceStream(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, &spec, CrashTestAudioCallback, nullptr);
    }
    if (stream != nullptr) {
        SDL_ResumeAudioStreamDevice(stream);
        // The callback ends the process; this thread waits for it.
        for (int i = 0; i < 1000; i++) {
            SDL_Delay(10);
        }
    }
    CrashReportAndExit(CrashKind::Fatal, "crash test: no audio thread ran", 1);
}

} // namespace

std::optional<CrashTest> CrashTestParse(std::string_view text) {
    CrashTest test;
    if (const std::size_t colon = text.find(':'); colon != std::string_view::npos) {
        if (text.substr(colon + 1) != "early") {
            return std::nullopt;
        }
        test.when = CrashTestWhen::Early;
        text = text.substr(0, colon);
    }
    for (const ModeName &entry : kModes) {
        if (entry.name == text) {
            test.mode = entry.mode;
            return test;
        }
    }
    return std::nullopt;
}

void CrashTestArm(const CrashTest &test, CrashTestWhen now) {
    if (test.mode == CrashTestMode::None || test.when != now) {
        return;
    }
    if (now == CrashTestWhen::Early) {
        CrashTestFire(test.mode);
    }
    crash_detail::g_armed_test = test.mode;
}

void CrashTestFire(CrashTestMode mode) {
    crash_detail::g_armed_test = CrashTestMode::None;
    switch (mode) {
        case CrashTestMode::Segv:
            CrashTestSegv();
            break;
        case CrashTestMode::Abort:
            CrashTestAbort();
        case CrashTestMode::Assert:
            CrashTestAssert();
        case CrashTestMode::Unimplemented:
            CrashTestUnimplemented();
        case CrashTestMode::Terminate:
            CrashTestTerminate();
            break;
        case CrashTestMode::StackOverflow:
            CrashTestStackOverflow(0);
            break;
        case CrashTestMode::AudioThread:
            CrashTestAudioThread();
            break;
        case CrashTestMode::None:
            break;
    }
    CrashReportAndExit(CrashKind::Fatal, "crash test: the failure did not end the process", 1);
}
