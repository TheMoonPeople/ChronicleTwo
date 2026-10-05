#include "common.h"

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/libc/locale/locale", _setlocale_r);
extern int lconv;
int *_localeconv_r(void) {
    return &lconv;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/libc/locale/locale", setlocale);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/libc/locale/locale", localeconv);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/libc/locale/locale", __mb_cur_max__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/libc/locale/locale", lc_ctype_3__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/libc/locale/locale", last_lc_ctype_4__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/libc/locale/locale", lconv__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/libc/locale/locale", D_00366890__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/libc/locale/locale", D_00366898__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/libc/locale/locale", D_003668A0__DATA);
