#include "common.h"
#include "port.h"

#include <gtest/gtest.h>

#include "movie.hpp"

#if defined(PORT_OVERRIDE) || defined(PORT_INIT) || defined(PORT_RETURN) || defined(PORT_FIX)
#error "Port compatibility macros must not reach native compilation"
#endif

TEST(NativeArchitecture, LegacyPortMacrosAreAbsentFromNativeHeaders) {
    SUCCEED();
}
