#include "common.h"

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/libc/stdlib/malloc", malloc);
#include <reent.h>
void _free_r(struct _reent *, void *);
void free(void *p) {
    _free_r(_REENT, p);
}
