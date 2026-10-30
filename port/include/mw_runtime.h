#pragma once

/**
 * @file
 * Declares CodeWarrior runtime conversion helpers used by game code.
 */

#ifdef __cplusplus
extern "C" {
#endif

/**
 *
 * Initialises the Metrowerks C/C++ runtime and static constructors.
 *
 * @mangled mwInit
 * @address 0x100190
 * @size 0x24
 */
void mwInit();

/**
 *
 * Converts a floating-point value to a signed integer using the runtime helper.
 *
 * @mangled fptosi
 * @address 0x28D000
 * @size 0x8C
 */
int fptosi(float value);

/**
 *
 * Converts a floating-point value to an unsigned integer using the runtime helper.
 *
 * @mangled fptoui
 * @address 0x28D090
 * @size 0x98
 */
unsigned int fptoui(float value);

/**
 *
 * Initializes an array allocated with the CodeWarrior placement-array layout.
 *
 * @mangled __construct_new_array
 * @address 0x1002F0
 * @size 0x14C
 */
void *__construct_new_array(void *buffer, void *(*constructor)(void *), void *destructor, unsigned int element_size,
                            int count);

#ifdef __cplusplus
}
#endif
