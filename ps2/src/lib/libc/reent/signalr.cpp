#include "common.h"

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/libc/reent/signalr", _kill_r);
struct _reent;
int getpid(void);
int _getpid_r(struct _reent *p) {
    return getpid();
}
