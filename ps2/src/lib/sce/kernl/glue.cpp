#include "common.h"

extern int ttyinit;

void sceResetttyinit(void) {
    ttyinit = 0;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/glue", VSync);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/glue", VSync2);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/glue", write);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/glue", read);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/glue", open);

int close(int fd) {
    return -1;
}

int ioctl(int fd, int cmd, int arg) {
    return -1;
}

int lseek(int fd, int off, int whence) {
    return -1;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/glue", sbrk);

int isatty(int fd) {
    return 1;
}

int fstat(int fd, char *st) {
    *(long long *)(st + 0x48) = 0;
    *(int *)(st + 4) = 0x2000;
    return 0;
}

int getpid(void) {
    return 1;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/glue", kill);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/glue", stat);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/glue", unlink);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/glue", ttyinit__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/glue", heap_ptr_30__DATA);
