#include "common.h"

#include <cstdarg>
#include <cstdio>
#include <cstring>

#include "dbg_font.hpp"

namespace {

unsigned long SjisToJis(unsigned long sjis) {
    unsigned long hi = (sjis >> 8) & 0xFF;
    unsigned long lo = sjis & 0xFF;

    if (hi >= 0x81 && hi < 0xA0) {
        hi -= 0x81;
    } else if (hi >= 0xE0 && hi < 0xF0) {
        hi -= 0xC1;
    }

    hi <<= 1;

    if (lo >= 0x40 && lo < 0x7F) {
        lo -= 0x40;
    } else if (lo >= 0x80 && lo < 0x9F) {
        lo -= 0x41;
    } else if (lo >= 0x9F && lo < 0xFD) {
        lo -= 0x9F;
        hi += 1;
    }

    return ((hi + 1) << 8) + lo + 0x2021;
}

unsigned long SjisToSerno(unsigned long sjis) {
    unsigned long jis = SjisToJis(sjis);
    unsigned long row = (jis >> 8) - 0x21;

    return row * 94 + ((jis & 0xFF) - 0x21);
}

// Indexed by byte - 0xA1 for the half-width kana range 0xA1..0xDF. 0xB0 has no entry in retail's switch and falls to UNKNOWN.
// clang-format off
const unsigned long kKanaSerno[] = {
    0x212C, 0x215F, 0x2160, 0x212B, 0x212F, 0x2237, 0x21E6, 0x21E8, 0x21EA, 0x21EC, 0x21EE, 0x2228, 0x222A, 0x222C, 0x2208,
    DBG_FONT_SERNO_UNKNOWN,
    0x21E7, 0x21E9, 0x21EB, 0x21ED, 0x21EF, 0x21F0, 0x21F2, 0x21F4, 0x21F6, 0x21F8, 0x21FA, 0x21FC, 0x21FE, 0x2200, 0x2202,
    0x2204, 0x2206, 0x2209, 0x220B, 0x220D, 0x220F, 0x2210, 0x2211, 0x2212, 0x2213, 0x2214, 0x2217, 0x221A, 0x221D, 0x2220, 0x2223,
    0x2224, 0x2225, 0x2226, 0x2227, 0x2229, 0x222B, 0x222D, 0x222E, 0x222F, 0x2230, 0x2231, 0x2232, 0x2234, 0x2238,
    DBG_FONT_SERNO_DAKUTEN, DBG_FONT_SERNO_HANDAKUTEN,
};
// clang-format on

unsigned long KanaSerno(unsigned char ch) {
    return kKanaSerno[ch - 0xA1];
}

} // namespace

PORT_OVERRIDE void dbgCJISFont::PrintDirect(int start_x, int start_y, char *format, ...) {
    char  text[0x408];
    char  escape[8];
    char *cursor = text;
    char  ch = 0;
    int   length = 0;

    x = start_x;
    y = start_y;
    prev_serno = 0;

    va_list args;
    va_start(args, format);
    std::vsnprintf(text, sizeof text, format, args);
    va_end(args);

    while ((ch = *cursor) != '\0') {
        long code = ch;

        if (!(code & 0x80)) {
            switch (code) {
                case '\n':
                    cursor++;
                    y += char_height;
                    x = 0;
                    break;
                case '\t':
                    cursor++;
                    x += char_width * 2;
                    break;
                case 'E':
                    length = 0;

                    while (length < 5 && cursor[length] != '\0') {
                        escape[length] = cursor[length];
                        length++;
                    }

                    // escape is not NUL-terminated; strcmp would read past its five bytes.
                    if (length >= 5) {
                        if (std::memcmp(escape, "ESC[$", 5) == 0) {
                            cursor += 5;
                            back_enable = ~back_enable;
                            break;
                        }
                        if (std::memcmp(escape, "ESC[#", 5) == 0) {
                            cursor += 5;
                            shadow_enable = ~shadow_enable;
                            break;
                        }
                    }
                    [[fallthrough]];
                default:
                    __putc(*cursor + DBG_FONT_SERNO_ASCII);
                    cursor++;
                    break;
            }
        } else {
            unsigned char byte = *cursor;

            if (byte >= 0xA1 && byte < 0xE0) {
                unsigned long serno = KanaSerno(byte);

                if (serno == DBG_FONT_SERNO_DAKUTEN && prev_serno != 0) {
                    serno = prev_serno + 1;
                    prev_serno = 0;
                    x -= char_width - 8;
                } else if (serno == DBG_FONT_SERNO_HANDAKUTEN && prev_serno != 0) {
                    serno = prev_serno + 2;
                    prev_serno = 0;
                    x -= char_width - 8;
                } else {
                    prev_serno = serno;
                }

                __putc(serno);
                cursor++;
            } else {
                // A lead byte with no trail byte before the terminator ends the text; retail reads past the terminator.
                if (cursor[1] == '\0') {
                    break;
                }

                unsigned long sjis = (static_cast<unsigned long>(byte) << 8) | static_cast<unsigned char>(cursor[1]);
                cursor += 2;
                __putc(SjisToSerno(sjis));
            }
        }
    }

    loaded_texture_id = -1;
}
