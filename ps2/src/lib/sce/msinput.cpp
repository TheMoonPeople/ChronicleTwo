#include "common.h"

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/msinput", sceMSIn_Init);

int sceMSIn_ATick(void) {
    return 0;
}

int sceMSIn_Load(void) {
    return 0;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/msinput", put_message);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/msinput", sceMSIn_PutMsg);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/msinput", sceMSIn_PutExcMsg);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/msinput", sceMSIn_PutHsMsg);
