#include "types.h"

#include <gtest/gtest.h>

TEST(Smoke, NativeAddressWidth) {
    EXPECT_EQ(sizeof(uptr), sizeof(void *));
    EXPECT_GE(sizeof(uptr), sizeof(u32));
}
