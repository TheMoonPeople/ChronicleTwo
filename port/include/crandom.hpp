#pragma once

#include "common.h"

/**
 * @file
 * Declares the random number generator that gives normally distributed values.
 */

/**
 *
 * Steps a linear congruential seed to make random values that follow
 * a normal distribution, for small random changes to the fish of the
 * fish race.
 *
 */
class CRandom {
public:
    u32 seed; /**< State of the linear congruential generator; each step makes it seed * 0x5D588B65 + 1. */

    /**
     *
     * Gives a random value with a mean of zero and a variance of one, as the
     * sum of twelve uniform values in [0, 1) less six.
     *
     * @mangled nget__7CRandomFv
     * @address 0x321850
     * @size 0x310
     */
    float nget();
};

STATIC_ASSERT(sizeof(CRandom) == 0x4);

/**
 *
 * Gives the magnitude of a value, without its sign.
 *
 * @mangled abs__Ff
 * @address 0x321B60
 * @size 0x24
 */
float CRandomAbs(float value);
