#pragma once

#include "common.h"

/**
 * @file
 * Declares the loaders of the language-dependent gaiji image, the texture
 * holding the special symbols drawn inside the game's text and its buffer accessor.
 */

/**
 *
 * Loads the gaiji image of the current language into the gaiji buffer.
 *
 * @mangled LoadGaijiImg__Fv
 * @address 0x2DD5D0
 * @size 0x100
 */
int LoadGaijiImg();

/**
 *
 * Returns the buffer holding the loaded gaiji image.
 *
 * @mangled GetGaijiImgPtr__Fv
 * @address 0x2DD6D0
 * @size 0x10
 */
u_char *GetGaijiImgPtr();
