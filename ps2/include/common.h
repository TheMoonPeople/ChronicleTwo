#ifndef COMMON_H
#define COMMON_H

/**
 * @file
 * Provides the integer aliases, assembly inclusion markers and size assertion used by game code.
 */

#include "include_asm.h"
#include "types.h"

#define PI         3.1415927f   /**< Pi. */
#define TWO_PI     6.2831855f   /**< Two pi; one full turn in radians. */
#define HALF_PI    1.5707964f   /**< Half pi; a quarter turn in radians. */
#define QUARTER_PI 0.7853982f   /**< Quarter pi; an eighth of a turn in radians. */
#define DEG_TO_RAD 0.017453292f /**< Radians per degree. */

/** Checks a compile-time condition by forming an array type. */
#define STATIC_ASSERT(expr) typedef char _static_assert_##__COUNTER__[(expr) ? 1 : -1]

#endif
