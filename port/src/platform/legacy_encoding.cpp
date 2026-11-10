#include "platform/legacy_encoding.hpp"

#include <stdexcept>
#include <vector>

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#else
#include <iconv.h>
#endif

namespace legacy_encoding {
#ifdef _WIN32
namespace {
constexpr UINT kCodePageCp932 = 932;
} // namespace
#endif

std::string GameText(std::string_view utf8) {
    if (utf8.contains('\0')) {
        throw std::runtime_error("config string contains a null byte");
    }
    if (utf8.empty()) {
        return {};
    }
#ifdef _WIN32
    const auto length = MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, utf8.data(), static_cast<int>(utf8.size()), nullptr, 0);
    if (!length) {
        throw std::runtime_error("config string is not valid UTF-8");
    }
    std::vector<wchar_t> wide(length);
    MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, utf8.data(), static_cast<int>(utf8.size()), wide.data(), length);
    BOOL       substituted = FALSE;
    const auto count = WideCharToMultiByte(kCodePageCp932, WC_NO_BEST_FIT_CHARS, wide.data(), length, nullptr, 0, nullptr, &substituted);
    if (!count || substituted) {
        throw std::runtime_error("config string cannot be represented in CP932");
    }
    std::string encoded(count, '\0');
    WideCharToMultiByte(kCodePageCp932, WC_NO_BEST_FIT_CHARS, wide.data(), length, encoded.data(), count, nullptr, &substituted);
    return encoded;
#else
    auto converter = iconv_open("CP932", "UTF-8");
    if (converter == reinterpret_cast<iconv_t>(-1)) {
        throw std::runtime_error("CP932 encoding unavailable");
    }
    std::string encoded(utf8.size() * 2 + 4, '\0');
    char       *input = const_cast<char *>(utf8.data());
    char       *output = encoded.data();
    auto        input_size = utf8.size();
    auto        output_size = encoded.size();
    const auto  result = iconv(converter, &input, &input_size, &output, &output_size);
    iconv_close(converter);
    if (result == static_cast<std::size_t>(-1) || input_size) {
        throw std::runtime_error("config string cannot be represented in CP932");
    }
    encoded.resize(encoded.size() - output_size);
    return encoded;
#endif
}

std::optional<std::string> ReadableText(std::string_view cp932) {
    if (cp932.contains('\0')) {
        return std::nullopt;
    }
    if (cp932.empty()) {
        return std::string{};
    }
#ifdef _WIN32
    const auto length = MultiByteToWideChar(kCodePageCp932, MB_ERR_INVALID_CHARS, cp932.data(), static_cast<int>(cp932.size()), nullptr, 0);
    if (!length) {
        return std::nullopt;
    }
    std::vector<wchar_t> wide(length);
    MultiByteToWideChar(kCodePageCp932, MB_ERR_INVALID_CHARS, cp932.data(), static_cast<int>(cp932.size()), wide.data(), length);
    const auto count = WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, wide.data(), length, nullptr, 0, nullptr, nullptr);
    if (!count) {
        return std::nullopt;
    }
    std::string text(count, '\0');
    WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, wide.data(), length, text.data(), count, nullptr, nullptr);
    return text;
#else
    auto converter = iconv_open("UTF-8", "CP932");
    if (converter == reinterpret_cast<iconv_t>(-1)) {
        return std::nullopt;
    }
    std::string text(cp932.size() * 3 + 4, '\0');
    char       *input = const_cast<char *>(cp932.data());
    char       *output = text.data();
    auto        input_size = cp932.size();
    auto        output_size = text.size();
    const auto  result = iconv(converter, &input, &input_size, &output, &output_size);
    iconv_close(converter);
    if (result == static_cast<std::size_t>(-1) || input_size) {
        return std::nullopt;
    }
    text.resize(text.size() - output_size);
    return text;
#endif
}
} // namespace legacy_encoding
