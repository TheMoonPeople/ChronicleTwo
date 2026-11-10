#pragma once

#include <cstdarg>
#include <cstddef>
#include <cstdio>
#include <cstring>
#include <span>
#include <string>
#include <string_view>
#include <type_traits>

/**
 *
 * Bounded reads and writes of the game's fixed-size, NUL-terminated text fields.
 *
 */
namespace dc2::text {

/**
 *
 * Whether a byte opens a two-byte Shift-JIS character.
 *
 */
constexpr bool IsShiftJisLead(unsigned char byte) {
    return (byte >= 0x81 && byte <= 0x9F) || (byte >= 0xE0 && byte <= 0xFC);
}

/**
 *
 * Whether a byte can finish a two-byte Shift-JIS character.
 *
 */
constexpr bool IsShiftJisTrail(unsigned char byte) {
    return (byte >= 0x40 && byte <= 0x7E) || (byte >= 0x80 && byte <= 0xFC);
}

/**
 *
 * Views the terminated prefix of a bounded text field.
 *
 */
constexpr std::string_view View(std::span<const char> field) {
    if (field.empty()) {
        return {};
    }
    std::size_t length = 0;
    while (length < field.size() && field[length] != '\0') {
        ++length;
    }
    return {field.data(), length};
}

/**
 *
 * Views a fixed field without reading beyond its array.
 *
 */
template <std::size_t N>
constexpr std::string_view View(const char (&field)[N]) {
    return View(std::span<const char, N>(field));
}

/**
 *
 * Views a field's text up to its terminator or the end of the field, whichever comes first.
 *
 */
constexpr std::string_view View(const char *text, std::size_t capacity) {
    if (text == nullptr) {
        return {};
    }
    return View(std::span<const char>(text, capacity));
}

/**
 *
 * Views a terminated string, treating a null pointer as empty text.
 *
 */
template <typename Pointer>
constexpr std::string_view View(Pointer text)
    requires(std::is_same_v<Pointer, const char *> || std::is_same_v<Pointer, char *>)
{
    return text != nullptr ? std::string_view(text) : std::string_view();
}

/**
 *
 * Treats an absent string as empty text.
 *
 */
constexpr std::string_view View(std::nullptr_t) {
    return {};
}

/**
 *
 * Gives the longest prefix of the text that fits in limit bytes without splitting a Shift-JIS character.
 *
 */
constexpr std::string_view Fit(std::string_view text, std::size_t limit) {
    std::size_t length = 0;
    while (length < text.size() && length < limit) {
        const auto byte = static_cast<unsigned char>(text[length]);
        if (byte == 0) {
            break;
        }
        const bool lead = IsShiftJisLead(byte);
        if (lead && (length + 1 >= text.size() || !IsShiftJisTrail(static_cast<unsigned char>(text[length + 1])))) {
            break;
        }
        const std::size_t width = lead ? 2 : 1;
        if (width > limit - length) {
            break;
        }
        length += width;
    }
    return text.substr(0, length);
}

/**
 * Reveals caption bytes without splitting Shift-JIS characters, counting each complete bracketed tag once.
 */
inline std::string CaptionPrefix(std::string_view text, std::size_t visible_bytes) {
    text = text.substr(0, text.find('\0'));
    std::size_t length = 0;
    while (length < text.size() && visible_bytes != 0) {
        if (text[length] == '[') {
            const auto close = text.find(']', length + 1);
            if (close == std::string_view::npos) {
                break;
            }
            length = close + 1;
            --visible_bytes;
            continue;
        }
        const bool        lead = IsShiftJisLead(static_cast<unsigned char>(text[length]));
        const std::size_t width = lead ? 2 : 1;
        if (width > visible_bytes || width > text.size() - length ||
            (lead && !IsShiftJisTrail(static_cast<unsigned char>(text[length + 1])))) {
            break;
        }
        length += width;
        visible_bytes -= width;
    }
    return std::string(text.substr(0, length));
}

/**
 *
 * Copies text into a field, truncating it so the terminator always fits, and returns the bytes copied.
 *
 */
inline std::size_t Copy(std::span<char> field, std::string_view text) {
    if (field.empty()) {
        return 0;
    }
    const auto fitted = Fit(text, field.size() - 1);
    if (!fitted.empty()) {
        std::memmove(field.data(), fitted.data(), fitted.size());
    }
    field[fitted.size()] = '\0';
    return fitted.size();
}

/**
 *
 * Copies from a fixed field without scanning beyond its array for a terminator.
 *
 */
template <std::size_t N>
inline std::size_t Copy(std::span<char> field, const char (&text)[N]) {
    return Copy(field, View(text));
}

/**
 *
 * Appends complete characters to a bounded text field and terminates the result.
 *
 */
inline std::size_t Append(std::span<char> field, std::string_view text) {
    if (field.empty()) {
        return 0;
    }
    const std::string_view existing = View(std::span<const char>(field));
    const std::size_t      length = Fit(existing, field.size() - 1).size();
    field[length] = '\0';
    return Copy(field.subspan(length), text);
}

/**
 *
 * Appends from a fixed field without scanning beyond its array for a terminator.
 *
 */
template <std::size_t N>
inline std::size_t Append(std::span<char> field, const char (&text)[N]) {
    return Append(field, View(text));
}

/**
 *
 * Whether the text and its terminator fit in a field of the given capacity.
 *
 */
constexpr bool Fits(std::string_view text, std::size_t capacity) {
    return text.size() < capacity;
}

/**
 *
 * Appends printf-formatted game text without guessing a fixed output capacity.
 *
 */
#if defined(__GNUC__) || defined(__clang__)
__attribute__((format(printf, 2, 3)))
#endif
inline bool AppendFormatted(std::string &text, const char *format, ...) {
    if (format == nullptr) {
        return false;
    }

    va_list arguments;
    va_start(arguments, format);
    va_list measurement;
    va_copy(measurement, arguments);
    const int required = std::vsnprintf(nullptr, 0, format, measurement);
    va_end(measurement);
    if (required < 0 || static_cast<std::size_t>(required) >= text.max_size() - text.size()) {
        va_end(arguments);
        return false;
    }

    std::string addition(static_cast<std::size_t>(required) + 1, '\0');
    const int   written = std::vsnprintf(addition.data(), addition.size(), format, arguments);
    va_end(arguments);
    if (written != required) {
        return false;
    }
    addition.resize(static_cast<std::size_t>(required));
    text += addition;
    return true;
}

} // namespace dc2::text
