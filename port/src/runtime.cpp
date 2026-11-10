#include "mw_runtime.h"

#include <climits>
#include <cstdio>
#include <cstdlib>
#include <format>
#include <print>

#include "crash/crash.hpp"
#include "exitcodes.hpp"

// stdout is flushed first so the game's own context (LoadFile names the file) precedes the message.
// The exit skips static destructors, which would tear the renderer down under a frame still in progress.
extern "C" [[noreturn]] void __assert(const char *file, int line, const char *expression) {
    std::fflush(stdout);
    CrashReportAndExit(CrashKind::Assert, std::format("{}:{}: assertion failed: {}", file, line, expression), kExitGameAssert);
}

// glibc declares these noexcept; Apple's libc and the Windows CRT do not.
#if defined(__APPLE__) || defined(_WIN32)
#define LIBC_NOEXCEPT
#else
#define LIBC_NOEXCEPT noexcept
#endif

// Retail's generator, not the host's: the game seeds it from game state (fishing, the title) and
// relies on the exact sequence that follows.
namespace {
unsigned int g_rand_state = 1;
}

extern "C" void srand(unsigned int seed) LIBC_NOEXCEPT {
    g_rand_state = seed;
}

extern "C" int rand() LIBC_NOEXCEPT {
    g_rand_state = g_rand_state * 1103515245u + 12345u;
    return static_cast<int>(g_rand_state & 0x7FFFFFFFu);
}

// The host runs the static constructors mwInit would have run.
extern "C" void mwInit() {}

extern "C" [[noreturn]] void exit__2(int status) {
    std::exit(status);
}

// Saturates, and maps NaN to 0, as the MWCC helper does; a bare cast is undefined for these inputs.
extern "C" int fptosi(float value) {
    if (value >= 2147483648.0f) {
        return INT_MAX;
    }
    if (value >= -2147483648.0f) {
        return static_cast<int>(value);
    }
    if (value < 0.0f) {
        return INT_MIN;
    }
    return 0;
}

// Negatives and NaN convert to 0; values at or above 2^32 saturate.
extern "C" unsigned int fptoui(float value) {
    if (value >= 4294967296.0f) {
        return UINT_MAX;
    }
    if (value > 0.0f) {
        return static_cast<unsigned int>(value);
    }
    return 0;
}

// The MWCC layout: element size and count in the first 16 bytes, elements after. Every caller
// passes a null destructor and no constructor throws in the port, so the partial-construction
// cleanup is not reproduced.
extern "C" void *__construct_new_array(void        *allocation, void *(*constructor)(void *), void        */*unused*/,
                                       unsigned int element_size, int count) {
    if (allocation == nullptr) {
        return nullptr;
    }

    auto *header = static_cast<unsigned int *>(allocation);
    header[0] = element_size;
    header[1] = static_cast<unsigned int>(count);
    char *array = static_cast<char *>(allocation) + 16;

    if (constructor != nullptr) {
        for (int index = 0; index < count; index++) {
            constructor(array + static_cast<size_t>(index) * element_size);
        }
    }

    return array;
}
