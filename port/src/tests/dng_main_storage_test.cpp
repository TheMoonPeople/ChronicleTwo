#include "common.h"

#include <gtest/gtest.h>

#include "mg_memory.hpp"

// dng_main.hpp declares six stacks; the port's definition holds the seventh, retail's BuffTempData.
extern mgCMemory BaseCharacter[7];

TEST(DngMain, BaseCharacterHoldsTheTempStack) {
    static u_long128 buffer[16];

    EXPECT_EQ(sizeof(BaseCharacter), 7 * sizeof(mgCMemory));
    EXPECT_EQ(BaseCharacter[6].name[0], '\0');

    BaseCharacter[6].stSetBuffer(buffer, 16);
    EXPECT_NE(BaseCharacter[6].Alloc(4), nullptr);
}
