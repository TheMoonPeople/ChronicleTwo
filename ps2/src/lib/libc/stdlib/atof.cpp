#include "common.h"

double strtod(const char *, char **);
double atof(const char *s) {
    return strtod(s, 0);
}
