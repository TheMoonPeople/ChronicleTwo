#include "common.h"

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/diei", DIntr);

int EIntr(void) {
    unsigned int s, r;
    __asm__ volatile("mfc0 %0, $12" : "=r"(s));
    r = s & 0x10000;
    __asm__ volatile("ei");
    return r != 0;
}
