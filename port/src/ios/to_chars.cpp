// std::to_chars for floating point, defined in the executable on iOS.
//
// libc++'s headers say the system library has these from iOS 16.3, but an iPhone XS on iOS 16.3.1
// has none of them, and dyld kills the app at launch over the missing import. std::format calls
// them for every float it prints, so the app carries its own: a definition in the executable wins
// over the dylib's, and nothing is imported. Digits come from the C library's printf, which rounds
// exactly; the shortest forms take the fewest significant digits that read back to the same value.

// The headers mark these unavailable before iOS 16.3; this unit defines them, so it must see them plainly.
#define _LIBCPP_DISABLE_AVAILABILITY
#include <charconv>

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <string>

namespace {

std::to_chars_result Put(char *first, char *last, const std::string &text) {
    if (text.size() > static_cast<size_t>(last - first)) {
        return {last, std::errc::value_too_large};
    }
    std::memcpy(first, text.data(), text.size());
    return {first + text.size(), std::errc{}};
}

std::string Printf(const char *format, int precision, double value) {
    int         length = std::snprintf(nullptr, 0, format, precision, value);
    std::string text(static_cast<size_t>(length), '\0');
    std::snprintf(text.data(), text.size() + 1, format, precision, value);
    return text;
}

// "inf", "-inf", "nan" or "-nan", as std::to_chars writes them; empty for a finite value.
std::string NonFinite(double value) {
    if (std::isinf(value)) {
        return std::signbit(value) ? "-inf" : "inf";
    }
    if (std::isnan(value)) {
        return std::signbit(value) ? "-nan" : "nan";
    }
    return {};
}

// %a without its "0x", which std::to_chars leaves out. With no precision %a is already the shortest exact form.
std::string Hex(double value, int precision) {
    std::string text;
    if (precision < 0) {
        int length = std::snprintf(nullptr, 0, "%a", value);
        text.assign(static_cast<size_t>(length), '\0');
        std::snprintf(text.data(), text.size() + 1, "%a", value);
    } else {
        text = Printf("%.*a", precision, value);
    }
    if (size_t prefix = text.find("0x"); prefix != std::string::npos) {
        text.erase(prefix, 2);
    }
    if (precision < 0) {
        // Some C libraries pad the shortest %a with zeros.
        size_t p = text.find('p');
        size_t end = p;
        while (end > 0 && text[end - 1] == '0' && text.find('.') < end - 1) {
            end--;
        }
        if (end > 0 && text[end - 1] == '.') {
            end--;
        }
        text.erase(end, p - end);
    }
    return text;
}

// The fewest significant digits that read back as the value, and its decimal exponent.
template <typename T> void Shortest(T value, std::string &digits, int &exponent, bool &negative) {
    negative = std::signbit(value);
    double magnitude = std::fabs(static_cast<double>(value));
    std::string scientific;
    for (int precision = 0; precision < std::numeric_limits<T>::max_digits10; precision++) {
        scientific = Printf("%.*e", precision, magnitude);
        T back = static_cast<T>(0);
        if constexpr (sizeof(T) == sizeof(float)) {
            back = std::strtof(scientific.c_str(), nullptr);
        } else {
            back = static_cast<T>(std::strtod(scientific.c_str(), nullptr));
        }
        if (back == static_cast<T>(magnitude)) {
            break;
        }
    }
    size_t e = scientific.find('e');
    exponent = std::atoi(scientific.c_str() + e + 1);
    digits.clear();
    for (size_t i = 0; i < e; i++) {
        if (scientific[i] != '.') {
            digits += scientific[i];
        }
    }
    while (digits.size() > 1 && digits.back() == '0') {
        digits.pop_back();
    }
    if (digits == "0") {
        exponent = 0;
    }
}

// An integral value is written whole and exact, as std::to_chars does, not as its shortest digits and zeros.
std::string Fixed(double value, const std::string &digits, int exponent, bool negative) {
    std::string text = negative ? "-" : "";
    int         count = static_cast<int>(digits.size());
    if (exponent >= count - 1) {
        return Printf("%.*f", 0, value);
    } else if (exponent >= 0) {
        text += digits.substr(0, static_cast<size_t>(exponent + 1)) + "." + digits.substr(static_cast<size_t>(exponent + 1));
    } else {
        text += "0." + std::string(static_cast<size_t>(-exponent - 1), '0') + digits;
    }
    return text;
}

std::string Scientific(const std::string &digits, int exponent, bool negative) {
    std::string text = negative ? "-" : "";
    text += digits.substr(0, 1);
    if (digits.size() > 1) {
        text += "." + digits.substr(1);
    }
    char suffix[16];
    std::snprintf(suffix, sizeof(suffix), "e%c%02d", exponent < 0 ? '-' : '+', exponent < 0 ? -exponent : exponent);
    return text + suffix;
}

template <typename T> std::to_chars_result ShortestChars(char *first, char *last, T value, std::chars_format format) {
    if (std::string special = NonFinite(static_cast<double>(value)); !special.empty()) {
        return Put(first, last, special);
    }
    if (format == std::chars_format::hex) {
        return Put(first, last, Hex(static_cast<double>(value), -1));
    }
    std::string digits;
    int         exponent = 0;
    bool        negative = false;
    Shortest(value, digits, exponent, negative);
    std::string fixed = Fixed(static_cast<double>(value), digits, exponent, negative);
    std::string scientific = Scientific(digits, exponent, negative);
    switch (format) {
        case std::chars_format::fixed:
            return Put(first, last, fixed);
        case std::chars_format::scientific:
            return Put(first, last, scientific);
        case std::chars_format::general: {
            // %g's rule at its default precision of 6, with the shortest digits.
            return Put(first, last, exponent < -4 || exponent >= 6 ? scientific : fixed);
        }
        default:
            // No format: whichever is shorter, fixed on a tie.
            return Put(first, last, scientific.size() < fixed.size() ? scientific : fixed);
    }
}

std::to_chars_result PrecisionChars(char *first, char *last, double value, std::chars_format format, int precision) {
    if (std::string special = NonFinite(value); !special.empty()) {
        return Put(first, last, special);
    }
    precision = precision < 0 ? 6 : precision;
    switch (format) {
        case std::chars_format::fixed:
            return Put(first, last, Printf("%.*f", precision, value));
        case std::chars_format::scientific:
            return Put(first, last, Printf("%.*e", precision, value));
        case std::chars_format::hex:
            return Put(first, last, Hex(value, precision));
        default:
            return Put(first, last, Printf("%.*g", precision, value));
    }
}

// The format overload's value for "no format given".
constexpr std::chars_format kPlain = static_cast<std::chars_format>(0);

} // namespace

// Plainly, not through _LIBCPP_BEGIN_NAMESPACE_STD, whose attributes the declarations do not carry.
namespace std {
inline namespace _LIBCPP_ABI_NAMESPACE {

to_chars_result to_chars(char *first, char *last, float value) { return ShortestChars(first, last, value, kPlain); }
to_chars_result to_chars(char *first, char *last, double value) { return ShortestChars(first, last, value, kPlain); }
to_chars_result to_chars(char *first, char *last, long double value) {
    return ShortestChars(first, last, static_cast<double>(value), kPlain);
}
to_chars_result to_chars(char *first, char *last, float value, chars_format format) {
    return ShortestChars(first, last, value, format);
}
to_chars_result to_chars(char *first, char *last, double value, chars_format format) {
    return ShortestChars(first, last, value, format);
}
to_chars_result to_chars(char *first, char *last, long double value, chars_format format) {
    return ShortestChars(first, last, static_cast<double>(value), format);
}
to_chars_result to_chars(char *first, char *last, float value, chars_format format, int precision) {
    return PrecisionChars(first, last, value, format, precision);
}
to_chars_result to_chars(char *first, char *last, double value, chars_format format, int precision) {
    return PrecisionChars(first, last, value, format, precision);
}
to_chars_result to_chars(char *first, char *last, long double value, chars_format format, int precision) {
    return PrecisionChars(first, last, static_cast<double>(value), format, precision);
}

} // namespace _LIBCPP_ABI_NAMESPACE
} // namespace std
