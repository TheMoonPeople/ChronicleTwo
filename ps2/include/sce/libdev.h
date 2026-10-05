#pragma once

#include "common.h"

extern "C" {

/**
 * Initializes the development console renderer.
 */
void sceDevConsInit();

/**
 * Opens a console at GS coordinates with a width and height in characters.
 */
int sceDevConsOpen(u_int x, u_int y, u_int width, u_int height);

/**
 * Closes a development console handle.
 */
void sceDevConsClose(int handle);

/**
 * Sets the drawing attributes of a development console.
 */
void sceDevConsAttribute(int handle, u_char attributes);

/**
 * Draws a development console.
 */
void sceDevConsDraw(int handle);

}
