#ifndef COMMON_H
#define COMMON_H

/**
 * @file
 * Provides the integer aliases, math constants and size assertion used by game code.
 */

#include "types.h"

#define PI         3.1415927f   /**< Pi. */
#define TWO_PI     6.2831855f   /**< Two pi; one full turn in radians. */
#define HALF_PI    1.5707964f   /**< Half pi; a quarter turn in radians. */
#define QUARTER_PI 0.7853982f   /**< Quarter pi; an eighth of a turn in radians. */
#define DEG_TO_RAD 0.017453292f /**< Radians per degree. */

/** Checks a compile-time condition by forming an array type. */
#define STATIC_ASSERT(expr) typedef char _static_assert_##__COUNTER__[(expr) ? 1 : -1]
/** Checks the size of a record read from disc; compiled out on the PS2, a static_assert on PC. */
#ifndef PORT_RECORD_ASSERT
#define PORT_RECORD_ASSERT(expr)
#endif
/** Initializes a variable retail reads uninitialized; compiled out on the PS2, an initializer on PC. */
#ifndef PORT_INIT
#define PORT_INIT(value)
#endif
/** Returns a value where retail falls off the end of a function; compiled out on the PS2, a return on PC. */
#ifndef PORT_RETURN
#define PORT_RETURN(value)
#endif

#endif
