#include <gtest/gtest.h>

#include "platform/config.hpp"
#include "sphida_port.hpp"

// The handicap adds its shots to retail's par, never past the 99 the counter shows unless retail's own par was higher.
TEST(SphedaHandicap, AddsTheExtraShotsToParWithinTheCounter) {
    EXPECT_EQ(SphedaHandicapPar(4, 0), 4);
    EXPECT_EQ(SphedaHandicapPar(4, 3), 7);
    EXPECT_EQ(SphedaHandicapPar(1, kSphedaHandicapMax), 1 + kSphedaHandicapMax);
    EXPECT_EQ(SphedaHandicapPar(97, 3), 99);
    EXPECT_EQ(SphedaHandicapPar(99, 3), 99);
    // A hand-edited setting outside the range adds no more than the most the setting offers, and never takes shots.
    EXPECT_EQ(SphedaHandicapPar(4, 50), 4 + kSphedaHandicapMax);
    EXPECT_EQ(SphedaHandicapPar(4, -2), 4);
}
