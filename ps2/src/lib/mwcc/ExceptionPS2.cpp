#include "common.h"
#include "std/exception.hpp"


INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/ExceptionPS2", __TransferControl__FP12ThrowContextP13ExceptionInfoPc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/ExceptionPS2", __throw);

void __SkipUnwindInfo(char *info) {
    unsigned int skipped;
    int has_third_number;
    char *next;

    has_third_number = *(signed char *)info & 0x40;
    next = __DecodeUnsignedNumber(__DecodeUnsignedNumber(info + 1, &skipped), &skipped);
    if (has_third_number != 0) {
        __DecodeUnsignedNumber(next, &skipped);
    }
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/ExceptionPS2", __FindExceptionTable__FP13ExceptionInfoPc);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/ExceptionPS2", __SetupFrameInfo__FP12ThrowContextP13ExceptionInfo);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/mwcc/ExceptionPS2", __PopStackFrame__FP12ThrowContextP13ExceptionInfo);
