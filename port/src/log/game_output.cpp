#include "game_output.hpp"

#include <cstdarg>
#include <cstddef>
#include <cstdio>
#include <string>
#include <string_view>

#include "log/log_internal.hpp"

int dc2::log::PrintGame(const char *format, ...) {
    char    stack[1024];
    va_list args{};
    va_start(args, format);
    va_list again{};
    va_copy(again, args);
    const int size = std::vsnprintf(stack, sizeof stack, format, args);
    va_end(args);
    if (size < 0) {
        va_end(again);
        return size;
    }
    std::string      heap;
    std::string_view text;
    if (static_cast<std::size_t>(size) >= sizeof stack) {
        heap.resize(static_cast<std::size_t>(size) + 1);
        std::vsnprintf(heap.data(), heap.size(), format, again);
        heap.resize(static_cast<std::size_t>(size));
        text = heap;
    } else {
        text = std::string_view(stack, static_cast<std::size_t>(size));
    }
    va_end(again);
    if (LogConsoleEnabled()) {
        std::fwrite(text.data(), 1, text.size(), stdout);
    }
    Ps2PrintfWrite(text);
    return size;
}
