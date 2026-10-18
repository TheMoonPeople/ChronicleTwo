// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include <nlohmann/json.hpp>
// clang-format on

#include "command_replay.hpp"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdio>
#include <deque>
#include <limits>
#include <print>
#include <stdexcept>

#include "platform/legacy_encoding.hpp"
#include "script_guards.hpp"
#include "stubs/dynamicanime.hpp"

namespace command_replay {
namespace {

using Json = nlohmann::json;

/**
 * Decodes the hexadecimal CP932 bytes of a string that readable text cannot reproduce.
 */
std::string GameBytes(const std::string &hex) {
    if (hex.size() % 2 != 0) {
        throw std::runtime_error("invalid game_bytes");
    }
    const auto digit = [](char value) {
        if (value >= '0' && value <= '9') {
            return value - '0';
        }
        if (value >= 'a' && value <= 'f') {
            return value - 'a' + 10;
        }
        if (value >= 'A' && value <= 'F') {
            return value - 'A' + 10;
        }
        throw std::runtime_error("invalid game_bytes");
    };
    std::string bytes;
    for (std::size_t index = 0; index < hex.size(); index += 2) {
        bytes.push_back(static_cast<char>((digit(hex[index]) * 16) + digit(hex[index + 1])));
    }
    return bytes;
}

/**
 * Fills one argument slot from a typed operand; a resource or invalid operand is an invalid slot.
 */
void Decode(const Json &argument, SPI_STACK &slot, std::string &storage) {
    slot = SPI_STACK{};
    slot.type = SPI_STACK_TYPE_INVALID;
    const auto type = argument.value("type", std::string{});
    if (type == "int") {
        const auto value = argument.at("value").get<std::int64_t>();
        if (value < std::numeric_limits<int>::min() || value > std::numeric_limits<int>::max()) {
            throw std::runtime_error("command integer out of range");
        }
        slot.type = SPI_STACK_TYPE_INT;
        slot.value.integer = static_cast<int>(value);
    } else if (type == "float") {
        const auto value = argument.at("value").get<float>();
        if (!std::isfinite(value)) {
            throw std::runtime_error("non-finite command float");
        }
        slot.type = SPI_STACK_TYPE_FLOAT;
        slot.value.real = value;
    } else if (type == "string") {
        storage = argument.contains("game_bytes") ? GameBytes(argument.at("game_bytes").get<std::string>()) : legacy_encoding::GameText(argument.at("value").get<std::string>());
        slot.type = SPI_STACK_TYPE_STRING;
        slot.value.string = storage.data();
    } else if (type != "invalid" && type != "resource") {
        throw std::runtime_error("unknown command argument type: " + type);
    }
}

/**
 * Runs a command list; each command's arguments overwrite the slots it gives and the slots past them
 * keep the previous command's values, as the retail interpreter's stack does.
 */
void Run(const Json &commands, SPI_TAG_PARAM *tags) {
    int tag_count = 0;
    while (tags[tag_count].name != nullptr && tags[tag_count].name[0] != '\0') {
        ++tag_count;
    }
    std::array<SPI_STACK, SPI_STACK_SIZE> stack{};
    std::deque<std::string>               strings(SPI_STACK_SIZE);
    for (const auto &command : commands) {
        const auto name = command.at("command").get<std::string>();
        int        index = -1;
        for (int candidate = 0; candidate < tag_count; ++candidate) {
            if (name == tags[candidate].name) {
                index = candidate;
                break;
            }
        }
        if (index < 0) {
            continue;
        }
        const auto &arguments = command.at("args");
        const int   count = static_cast<int>(std::min<std::size_t>(arguments.size(), SPI_STACK_SIZE));
        for (int slot = 0; slot < count; ++slot) {
            Decode(arguments[slot], stack[slot], strings[slot]);
        }
        if (tags[index].function == nullptr) {
            continue;
        }
        const int allowed = script_guards::TagArguments(tags[index].function, stack.data(), count, tags[index].name);
        if (allowed >= 0) {
            tags[index].function(stack.data(), allowed);
        }
    }
}

} // namespace

bool IsCommandBuffer(const char *script, int size) {
    if (script == nullptr || size <= 0) {
        return false;
    }
    const auto *end = script + size;
    const auto *first = std::find_if(script, end, [](char byte) { return byte != ' ' && byte != '\t' && byte != '\r' && byte != '\n'; });
    return first != end && *first == '{';
}

bool RunBuffer(const char *script, int size, SPI_TAG_PARAM *tags) {
    try {
        const auto document = Json::parse(script, script + size);
        Run(document.at("commands"), tags);
        return true;
    } catch (const std::exception &exception) {
        std::println(stderr, "command list: {}", exception.what());
        return false;
    }
}

std::vector<SPI_STACK> Arguments(const Json &arguments, std::vector<std::string> &strings) {
    strings.assign(arguments.size(), std::string{});
    std::vector<SPI_STACK> stack(arguments.size());
    for (std::size_t index = 0; index < stack.size(); ++index) {
        Decode(arguments[index], stack[index], strings[index]);
    }
    return stack;
}

} // namespace command_replay

void PortRunDynamicAnimeScript(SPI_TAG_PARAM *tags, char *script, int size) {
    if (command_replay::IsCommandBuffer(script, size)) {
        command_replay::RunBuffer(script, size, tags);
        return;
    }
    CScriptInterpreter interpreter;
    interpreter.SetTag(tags);
    interpreter.SetScript(script, size);
    interpreter.Run();
}
