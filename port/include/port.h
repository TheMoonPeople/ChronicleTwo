#pragma once

#include <cstddef>
#include <new>
#include <strings.h>
#include <sys/types.h>
#ifdef _WIN32
#include <cstring>
// mingw's <strings.h> has no BSD index(); the PS2 libc's index() is strchr().
inline char *index(const char *s, int c) {
    return const_cast<char *>(strchr(s, c));
}
#endif

#include <kazarov/port.h>

// types.h names the PS2's size_t and NULL. Included under other names, the host's stay in force,
// and #pragma once keeps the game from including types.h again.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmacro-redefined"
#pragma push_macro("NULL")
#define size_t ps2_size_t
// The host's <sys/types.h> declares its own u_long. It is read above, so its include guard stops a later read
// from expanding the alias below; the PS2 typedef is renamed while types.h is read.
#define u_long ps2_native_u_long
#include "types.h"
#undef u_long
#define u_long u64
#undef size_t
#pragma pop_macro("NULL")
#pragma clang diagnostic pop

// The PS2 layouts (32-bit pointers, 64-bit long) are what STATIC_ASSERT checks against; on the host
// every check would fail, so it checks nothing.
#include "common.h"
#undef STATIC_ASSERT
#define STATIC_ASSERT(expr)

// Records keep the disc's layout on PC too, so their size checks stay on.
#undef PORT_RECORD_ASSERT
#define PORT_RECORD_ASSERT(expr) static_assert(expr)

#ifdef CT_PS2_TEXTURE_COPY
#include "texture_copy.hpp"
#endif
#include "../src/asset_directory.hpp"
