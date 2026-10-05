#include "common.h"

typedef struct {
    int a[4];
    int idx;
    int val;
} K7SA;
typedef struct {
    int a[7];
    int *tab;
} K7SB;

typedef struct {
    int a[4];
    int v;
} K7CA;
typedef struct {
    int a[2];
    int v;
} K7CB;

extern int soft_reg[];

extern char _data_table[];

void _set_sreg(K7SA *s, K7SB *d) {
    d->tab[s->idx] = s->val;
}

void _change_addr(K7CA *s, K7CB *d) {
    d->v = s->v;
}

int sceSifGetSreg(int n) {
    return soft_reg[n];
}

int sceSifSetSreg(int n, int v) {
    soft_reg[n] = v;
    return v;
}

void *sceSifGetDataTable(void) {
    return _data_table;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifcmd", sceSifInitCmd);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifcmd", sceSifExitCmd);

void *sceSifSetCmdBuffer(void *b, int n) {
    char *s = _data_table;
    void *o;
    __asm__("" : "+r"(s));
    o = *(void **)(s + 0x14);
    *(void **)(s + 0x14) = b;
    *(int *)(s + 0x18) = n;
    return o;
}

void *sceSifSetSysCmdBuffer(void *b, int n) {
    char *s = _data_table;
    void *o = *(void **)(s + 0xC);
    *(void **)(s + 0xC) = b;
    *(int *)(s + 0x10) = n;
    return o;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifcmd", sceSifAddCmdHandler);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifcmd", sceSifRemoveCmdHandler);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifcmd", _sceSifSendCmd);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifcmd", sceSifSendCmd);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifcmd", isceSifSendCmd);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifcmd", _sceSifCmdIntrHdlr);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifcmd", sceSifWriteBackDCache);








INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/kernl/sifcmd", _cmd_init_check__DATA);

INCLUDE_BSS(_pckt_buffer, 0x80);

INCLUDE_BSS(_send_buffer, 0x40);

INCLUDE_BSS(_csdata, 0x14);

INCLUDE_BSS(sif0_handleid, 0x4);

INCLUDE_BSS(_data_table, 0x8);

INCLUDE_BSS(D_0037FD20, 0x4);

INCLUDE_BSS(D_0037FD24, 0x8);

INCLUDE_BSS(D_0037FD2C, 0x14);

INCLUDE_BSS(_sys_buffer, 0x100);

INCLUDE_BSS(soft_reg, 0x80);
