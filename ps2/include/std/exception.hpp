#ifndef STD_EXCEPTION_HPP
#define STD_EXCEPTION_HPP

#include "common.h"

namespace std {
class exception {
public:
    const char *what() const;
};

class bad_alloc : public exception {
public:
    const char *what() const;
};

class bad_exception : public exception {
public:
    const char *what() const;
};
}

extern "C" int dpcmp(...);

char *__DecodeUnsignedNumber(char *bytes, unsigned int *value);

#endif
