#include "common.h"

extern int *_impure_ptr;
int *__errno(void) {
    return _impure_ptr;
}

INCLUDE_BSS(errno, 0x30);
