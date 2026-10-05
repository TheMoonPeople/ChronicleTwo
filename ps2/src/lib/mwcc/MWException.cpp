#include "common.h"
#include "std/exception.hpp"

extern char at_1073[];

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", __DecodeUnsignedNumber__FPcPUi);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", __DecodeSignedNumber__FPcPi);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", __end__catch);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", __ThrowHandler__FP12ThrowContext);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", FindExceptionHandler__FP12ThrowContextP13ExceptionInfoPl);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", __unexpected);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", __dt__Q23std13bad_exceptionFv);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", FindMostRecentException__FP12ThrowContextP13ExceptionInfo);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", UnwindStack__FP12ThrowContextP13ExceptionInfoPc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", NextAction__FP14ActionIterator);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", FindExceptionRecord__FPcP13ExceptionInfo);

const char *std::bad_exception::what() const {
    return at_1073;
}

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", at_408__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", at_454__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", at_455__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", at_510__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", at_748__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", at_1008__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", at_1069__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", at_1071__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", __RTTI__Q23std9exception__3__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", at_1070__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", __RTTI__Q23std13bad_exception__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", at_1073__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/mwcc/MWException", __vt__Q23std13bad_exception__DATA);
