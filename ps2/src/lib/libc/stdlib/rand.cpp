#include "common.h"

extern char *_impure_ptr;
void srand(unsigned int seed) {
    *(unsigned int *)(_impure_ptr + 0x58) = seed;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/libc/stdlib/rand", rand);
