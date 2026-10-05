/* Floating-point word-access macros from fdlibm (Sun Microsystems, 1993, "permission to use,
 * copy, modify, and distribute this software is freely granted, provided that this notice is
 * preserved"), as used by newlib. The Emotion Engine is little-endian: the high word is second. */

#ifndef GCC_IEEE754_H
#define GCC_IEEE754_H

#include <sys/config.h>

typedef union {
    double value;
    struct {
        __uint32_t lsw;
        __uint32_t msw;
    } parts;
} ieee_double_shape_type;

#define EXTRACT_WORDS(ix0, ix1, d)                                                                 \
    do {                                                                                           \
        ieee_double_shape_type ew_u;                                                               \
        ew_u.value = (d);                                                                          \
        (ix0) = ew_u.parts.msw;                                                                    \
        (ix1) = ew_u.parts.lsw;                                                                    \
    } while (0)

#define GET_HIGH_WORD(i, d)                                                                        \
    do {                                                                                           \
        ieee_double_shape_type gh_u;                                                               \
        gh_u.value = (d);                                                                          \
        (i) = gh_u.parts.msw;                                                                      \
    } while (0)

#define GET_LOW_WORD(i, d)                                                                         \
    do {                                                                                           \
        ieee_double_shape_type gl_u;                                                               \
        gl_u.value = (d);                                                                          \
        (i) = gl_u.parts.lsw;                                                                      \
    } while (0)

#define INSERT_WORDS(d, ix0, ix1)                                                                  \
    do {                                                                                           \
        ieee_double_shape_type iw_u;                                                               \
        iw_u.parts.msw = (ix0);                                                                    \
        iw_u.parts.lsw = (ix1);                                                                    \
        (d) = iw_u.value;                                                                          \
    } while (0)

#define SET_HIGH_WORD(d, v)                                                                        \
    do {                                                                                           \
        ieee_double_shape_type sh_u;                                                               \
        sh_u.value = (d);                                                                          \
        sh_u.parts.msw = (v);                                                                      \
        (d) = sh_u.value;                                                                          \
    } while (0)

#define SET_LOW_WORD(d, v)                                                                         \
    do {                                                                                           \
        ieee_double_shape_type sl_u;                                                               \
        sl_u.value = (d);                                                                          \
        sl_u.parts.lsw = (v);                                                                      \
        (d) = sl_u.value;                                                                          \
    } while (0)

typedef union {
    float value;
    __uint32_t word;
} ieee_float_shape_type;

#define GET_FLOAT_WORD(i, d)                                                                       \
    do {                                                                                           \
        ieee_float_shape_type gf_u;                                                                \
        gf_u.value = (d);                                                                          \
        (i) = gf_u.word;                                                                           \
    } while (0)

#define SET_FLOAT_WORD(d, i)                                                                       \
    do {                                                                                           \
        ieee_float_shape_type sf_u;                                                                \
        sf_u.word = (i);                                                                           \
        (d) = sf_u.value;                                                                          \
    } while (0)

#endif
