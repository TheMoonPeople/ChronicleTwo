#include "hang_watchdog.hpp"

#include <atomic>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <thread>

#ifndef _WIN32
#include <csignal>
#include <pthread.h>
#endif

#if defined(__APPLE__)
#include <dlfcn.h>
#include <mach/mach.h>
#endif

#include "log/log.hpp"
#include "sce/threads.hpp"

namespace {

std::atomic<unsigned long long> g_frames = 0;

#if defined(__APPLE__) && defined(__aarch64__)
void PrintFrame(int index, std::uintptr_t address) {
    Dl_info info{};
    if (dladdr(reinterpret_cast<void *>(address), &info) != 0 && info.dli_fbase != nullptr) {
        const char *image = info.dli_fname ? std::strrchr(info.dli_fname, '/') : nullptr;
        std::fprintf(stderr, "hang: #%-2d %s+0x%lx %s+0x%lx\n", index, image ? image + 1 : "?",
                     static_cast<unsigned long>(address - reinterpret_cast<std::uintptr_t>(info.dli_fbase)),
                     info.dli_sname ? info.dli_sname : "?",
                     static_cast<unsigned long>(info.dli_saddr ? address - reinterpret_cast<std::uintptr_t>(info.dli_saddr)
                                                               : 0));
    } else {
        std::fprintf(stderr, "hang: #%-2d 0x%lx\n", index, static_cast<unsigned long>(address));
    }
}

// Follows a chain of saved frame pointers, printing each return address.
void PrintFrames(int index, std::uintptr_t *frame) {
    for (; index < 64 && frame != nullptr && (reinterpret_cast<std::uintptr_t>(frame) & 7) == 0; ++index) {
        const std::uintptr_t return_address = frame[1];
        if (return_address == 0) {
            break;
        }
        PrintFrame(index, return_address);
        auto *next = reinterpret_cast<std::uintptr_t *>(frame[0]);
        if (next <= frame) {
            break;
        }
        frame = next;
    }
}

// The PS2 threads the game thread switches between, each from where its context was saved.
void PrintPs2Threads() {
    KzThreadInfo      threads[32];
    const std::size_t count = KzThreadsSnapshot(threads, 32);
    for (std::size_t i = 0; i < count && i < 32; ++i) {
        const KzThreadInfo &t = threads[i];
        std::fprintf(stderr, "hang: ps2 thread %d priority %d state %d waiting on %d\n", t.id, t.priority, t.state,
                     t.waiting_on);
        if (t.pc != 0) {
            PrintFrame(0, t.pc);
            PrintFrames(1, reinterpret_cast<std::uintptr_t *>(t.fp));
        }
    }
}

// Writes the stopped thread's stack, walked through its frame pointers, to stderr. It goes straight to stderr: the
// thread may hold the logger's or the allocator's locks, so nothing here takes a lock or allocates.
void PrintStack(pthread_t game) {
    const mach_port_t thread = pthread_mach_thread_np(game);
    if (thread_suspend(thread) != KERN_SUCCESS) {
        std::fprintf(stderr, "hang: cannot suspend the game thread\n");
        return;
    }
    arm_thread_state64_t   state{};
    mach_msg_type_number_t count = ARM_THREAD_STATE64_COUNT;
    if (thread_get_state(thread, ARM_THREAD_STATE64, reinterpret_cast<thread_state_t>(&state), &count) ==
        KERN_SUCCESS) {
        // Pointer authentication is off in an arm64 app, so the saved addresses are plain.
        PrintFrame(0, static_cast<std::uintptr_t>(arm_thread_state64_get_pc(state)));
        PrintFrame(1, static_cast<std::uintptr_t>(arm_thread_state64_get_lr(state)));
        PrintFrames(2, reinterpret_cast<std::uintptr_t *>(arm_thread_state64_get_fp(state)));
    }
    // Read while the game thread is stopped, so the scheduler does not change underneath.
    PrintPs2Threads();
    thread_resume(thread);
}
#endif

} // namespace

void HangWatchdogFrame() {
#ifndef _WIN32
    static const int seconds = [] {
        const char *setting = std::getenv("DC2_HANG_ABORT_SECONDS");
        return setting ? std::atoi(setting) : 0;
    }();
    if (seconds <= 0) {
        return;
    }
    static const bool started = [] {
        // The thread that ends frames is the one the watchdog reports on.
        const pthread_t game = pthread_self();
        std::thread([game] {
            unsigned long long last = g_frames.load();
            auto               since = std::chrono::steady_clock::now();
            for (;;) {
                std::this_thread::sleep_for(std::chrono::milliseconds(500));
                const unsigned long long now = g_frames.load();
                if (now != last) {
                    last = now;
                    since = std::chrono::steady_clock::now();
                    continue;
                }
                if (std::chrono::steady_clock::now() - since < std::chrono::seconds(seconds)) {
                    continue;
                }
                std::fprintf(stderr, "hang: no frame ended for %d s after frame %llu\n", seconds, now);
#if defined(__APPLE__) && defined(__aarch64__)
                // Where the thread is, read without stopping it for good: a lock it holds would also block a
                // crash handler run on it.
                PrintStack(game);
                std::fflush(stderr);
                since = std::chrono::steady_clock::now();
#else
                CT_LOG_ERROR(Main, "hang: no frame ended for {} s after frame {}; aborting the game thread", seconds,
                             now);
                LogFlush();
                pthread_kill(game, SIGABRT);
                return;
#endif
            }
        }).detach();
        return true;
    }();
    (void)started;
    g_frames.fetch_add(1);
#endif
}
