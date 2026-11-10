#pragma once

/**
 * @file
 * Defines the fixed-width integer aliases and basic C types used by the game.
 */

/** Unsigned 8-bit integer. */
typedef unsigned char u8;
/** Unsigned 16-bit integer. */
typedef unsigned short u16;
/** Unsigned 32-bit integer. */
typedef unsigned int u32;
/** Unsigned 64-bit integer. */
typedef unsigned long long u64;

/** Signed 8-bit integer. */
typedef char s8;
/** Signed 16-bit integer. */
typedef short s16;
/** Signed 32-bit integer. */
typedef int s32;
/** Signed 64-bit integer. */
typedef long long s64;

/** SDK spelling for an unsigned byte. */
typedef unsigned char u_char;
/** SDK spelling for an unsigned halfword. */
typedef unsigned short u_short;
/** SDK spelling for an unsigned word. */
typedef unsigned int u_int;
/** SDK spelling for an unsigned long. */
typedef unsigned long u_long;
/** SDK spelling for an unsigned quadword. */
typedef unsigned __int128 u_long128;

/** Size of an object in bytes on the PlayStation 2 target. */
typedef unsigned int size_t;

/** An address held in an integer: 32 bits on the PS2, pointer-wide on PC. */
#ifdef PORT
typedef __UINTPTR_TYPE__ uptr;
typedef __INTPTR_TYPE__ sptr;
#else
typedef unsigned int uptr;
typedef int sptr;
#endif

#define NULL 0
