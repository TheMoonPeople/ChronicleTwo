#include "common.h"

#include "nd_meswin.hpp"

std::string PreMesMake(std::string_view source) {
    std::string output;
    for (std::size_t index = 0; index < source.size() && source[index] != '\0';) {
        const char value = source[index];
        if (value == '\\' && index + 1 < source.size() && source[index + 1] == 'n') {
            output.push_back('\n');
            index += 2;
        } else if (value == '\n') {
            if (index + 1 < source.size() && source[index + 1] == '@') {
                break;
            }
            output.push_back('\n');
            ++index;
        } else if (value == '\r' && index + 1 < source.size() && source[index + 1] == '\n') {
            if (index + 2 < source.size() && source[index + 2] == '@') {
                break;
            }
            output.push_back('\n');
            index += 2;
        } else {
            output.push_back(value);
            ++index;
        }
    }
    return output;
}
