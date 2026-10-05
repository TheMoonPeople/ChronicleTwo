#include "common.h"
#include "std/fpcmp.hpp"

extern "C" int _dpfne(void) {
    return dpcmp() != 0;
}

extern "C" int _dpflt(void) {
    return dpcmp() < 0;
}

extern "C" int _dpfle(void) {
    return dpcmp() <= 0;
}

extern "C" int _dpfgt(void) {
    return dpcmp() > 0;
}

extern "C" int _dpfge(void) {
    return dpcmp() >= 0;
}
