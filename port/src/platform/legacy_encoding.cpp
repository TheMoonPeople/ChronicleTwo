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
std::string GameText(std::string_view utf8) {
    if (utf8.find('\0') != std::string_view::npos) {
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
    const auto count = WideCharToMultiByte(932, WC_NO_BEST_FIT_CHARS, wide.data(), length, nullptr, 0, nullptr, &substituted);
    if (!count || substituted) {
        throw std::runtime_error("config string cannot be represented in CP932");
    }
    std::string encoded(count, '\0');
    WideCharToMultiByte(932, WC_NO_BEST_FIT_CHARS, wide.data(), length, encoded.data(), count, nullptr, &substituted);
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
} // namespace legacy_encoding
