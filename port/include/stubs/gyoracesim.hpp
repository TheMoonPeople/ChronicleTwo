#pragma once

// Xcode's libc++ declares std's float abs in the global namespace through <stdlib.h>, where it collides with
// the game's abs(float) in crandom.hpp. On iOS the game's abs goes under its own name in the two units that
// see it, crandom.cpp and gyoracesim.cpp.
#if defined(__APPLE__)
#include <TargetConditionals.h>
#if TARGET_OS_IPHONE
#define abs CRandom_abs // iOS only
#endif
#endif
