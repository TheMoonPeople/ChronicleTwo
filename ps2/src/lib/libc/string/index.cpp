#include "common.h"

char *strchr(const char *, int);
char *index(const char *s, int c) {
    return strchr(s, c);
}
