#ifndef GCC_COMMON_H
#define GCC_COMMON_H

#include <sys/types.h>
typedef int u_long128 __attribute__((mode(TI)));
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef unsigned long u64;
typedef signed char s8;
typedef short s16;
typedef int s32;
typedef long s64;

#define INCLUDE_ASM(FOLDER, NAME)
#define INCLUDE_RODATA(FOLDER, NAME)
#define INCLUDE_BSS(NAME, SIZE) unsigned char NAME##__DATA[SIZE] __attribute__((section(".bss." #NAME)))

#endif
