#pragma once

#include <strings.h>
#include <sys/types.h>

#include <cstddef>
#include <cstdio>
#include <new>
#ifdef _WIN32
#include <cstring>

// mingw's <strings.h> has no BSD index(); the PS2 libc's index() is strchr().
inline char *index(const char *s, int c) {
    return const_cast<char *>(strchr(s, c));
}
#endif

/**
 *
 * Stops execution when a native game routine has no implementation.
 *
 */
[[noreturn]] void Ps2Unimplemented(const char *function, const char *file, int line);
#define PS2_UNIMPLEMENTED() Ps2Unimplemented(__func__, __FILE__, __LINE__)

// Keep the SDK's u_long distinct from the host typedef while the native game aliases are read.
// The host's <sys/types.h> declares its own u_long. It is read above, so its include guard stops a later read
// from expanding the alias below; the PS2 typedef is renamed while types.h is read.
#define u_long ps2_native_u_long
#include "types.h"
#undef u_long
#define u_long u64

// The PS2 layouts (32-bit pointers, 64-bit long) are what STATIC_ASSERT checks against; on the host
// every check would fail, so it checks nothing.
#include "common.h"
#undef STATIC_ASSERT
#define STATIC_ASSERT(expr)

// Records keep the disc's layout on PC too, so their size checks stay on.
#undef PORT_RECORD_ASSERT
#define PORT_RECORD_ASSERT(expr) static_assert(expr)

#include "../src/asset_directory.hpp"
