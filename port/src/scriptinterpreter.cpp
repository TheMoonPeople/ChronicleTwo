#include "scriptinterpreter.hpp"

#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <deque>
#include <print>
#include <span>
#include <string>
#include <utility>
#include <vector>

#include "script_guards.hpp"

namespace {

/**
 * Blanks comments in non-configuration game scripts before their text lexer runs.
 */
void PreprocessText(char *script, int size) {
    for (int index = 0; index + 1 < size;) {
        if (script[index] == '/' && script[index + 1] == '/') {
            while (index < size && script[index] != '\n' && script[index] != '\r') {
                script[index++] = ' ';
            }
        } else if (script[index] == '/' && script[index + 1] == '*') {
            script[index++] = ' ';
            script[index++] = ' ';
            while (index < size) {
                if (index + 1 < size && script[index] == '*' && script[index + 1] == '/') {
                    script[index++] = ' ';
                    script[index++] = ' ';
                    break;
                }
                script[index++] = ' ';
            }
        } else {
            ++index;
        }
    }
}

bool IsSpace(char byte) {
    return byte == ' ' || byte == '\t' || byte == '\n' || byte == '\r';
}

bool SkipArgumentSpace(input_str &input) {
    while (input.position < input.size && IsSpace(input.buffer[input.position])) {
        ++input.position;
    }
    return input.position < input.size;
}

/**
 * Retains omitted text-script arguments at each callback nesting depth.
 */
struct TagStorage {
    std::array<char, SPI_STRING_BUFF_SIZE> strings{};   /**< Mutable text-script string storage. */
    std::array<SPI_STACK, SPI_STACK_SIZE>  arguments{}; /**< Current and inherited typed argument slots. */
};

std::deque<TagStorage> persistent_storage; /**< Stable argument storage for every active callback depth. */
std::size_t            tag_depth = 0;      /**< Number of nested text-script callbacks. */

/**
 * Isolates a text-script callback's persistent argument storage.
 */
struct DepthScope {
    DepthScope() {
        if (persistent_storage.size() <= tag_depth) {
            persistent_storage.resize(tag_depth + 1);
        }
        ++tag_depth;
    }

    ~DepthScope() { --tag_depth; }
};

} // namespace

PORT_OVERRIDE CScriptInterpreter::CScriptInterpreter() : stack(nullptr), string_buff(string_buff_next = nullptr) {
    buffer = nullptr;
    size = position = stack_count = stack_size = string_buff_size = binary = tag_count = 0;

    tag = nullptr;
    hash_table = nullptr;
}

PORT_OVERRIDE void CScriptInterpreter::SetScript(char *script, int script_size) {
    buffer = script;
    size = script_size;
    position = stack_count = binary = 0;
    if (!script || script_size <= 0) {
        size = 0;
        return;
    }
    if (script_size >= 3 && std::memcmp(script, "BIN", 3) == 0) {
        binary = 1;
        position = std::min(script_size, 4);
    } else {
        PreprocessText(script, script_size);
    }
}

namespace {

/**
 * Calls a tag handler with the arguments its guard allows, skipping a call the guard refuses.
 */
void CallTag(const SPI_TAG_PARAM &tag, SPI_STACK *stack, int count) {
    const int allowed = script_guards::TagArguments(tag.function, stack, count, tag.name);
    if (allowed >= 0) {
        tag.function(stack, allowed);
    }
}

} // namespace

PORT_OVERRIDE int CScriptInterpreter::GetNextTAG(int call) {
    if (!tag) {
        return -1;
    }
    DepthScope scope;
    auto      &storage = persistent_storage[tag_depth - 1];
    SetStringBuff(storage.strings.data(), SPI_STRING_BUFF_SIZE);
    for (;;) {
        SetStack(storage.arguments.data(), SPI_STACK_SIZE);
        int index = -1;
        if (!SearchCommand(&index)) {
            return -1;
        }
        if (!binary && (index < 0 || index >= tag_count)) {
            int character = 0;
            while (get(&character) && character != ';') {
            }
            continue;
        }
        const auto count = binary ? GetArgBin() : GetArg();
        if (call && index >= 0 && index < tag_count && tag[index].function) {
            // A tag with more arguments than the stack holds sees only those that were pushed.
            CallTag(tag[index], stack, std::min(count, stack_count));
        }
        return index;
    }
}

PORT_OVERRIDE int CScriptInterpreter::GetArg() {
    int  count = 0;
    bool more = true;
    while (more && SkipArgumentSpace(*this)) {
        std::string text;
        bool        inside_quotes = false;
        int         byte = 0;
        for (;;) {
            if (!get(&byte)) {
                return count;
            }
            if (byte == '"') {
                inside_quotes = !inside_quotes;
            }
            if (inside_quotes) {
                if ((byte & 0x80) && (byte < 0xA1 || byte > 0xDF)) {
                    text.push_back(static_cast<char>(byte));
                    if (!get(&byte)) {
                        return count;
                    }
                } else if (byte == '\\') {
                    int next = 0;
                    if (!get(&next) || next != '"') {
                        back();
                    } else {
                        byte = next;
                    }
                }
            }
            if (!inside_quotes && (byte == ',' || byte == ';')) {
                more = byte == ',';
                break;
            }
            text.push_back(static_cast<char>(byte));
        }
        if (text.empty() && !more) {
            break;
        }

        // A missing argument before a comma is invalid. It has no final
        // character to inspect, unlike a quoted empty string.
        int quotes = !text.empty() && text.front() == '"' ? 1 : 0;
        if (!text.empty() && text.back() == '"') {
            text.pop_back();
            ++quotes;
        }
        SPI_STACK argument{};
        argument.value.string = nullptr;
        argument.type = SPI_STACK_TYPE_INT;
        bool non_numeric = false;
        if (quotes == 0) {
            for (std::size_t i = 0; i < text.size(); ++i) {
                const char c = text[i];
                if (c == '.') {
                    argument.type = SPI_STACK_TYPE_FLOAT;
                }
                if (IsSpace(c)) {
                    text.resize(i);
                    break;
                }
                if (c != '-' && c != '.' && (c < '0' || c > '9')) {
                    non_numeric = true;
                }
            }
        }

        if (quotes == 2) {
            argument.type = SPI_STACK_TYPE_STRING;
            const char       *value = text.c_str() + 1;
            const std::size_t bytes = std::strlen(value) + 1;
            if (string_buff_next + bytes > string_buff + string_buff_size) {
                std::println("SPI string buffer over!!");
            } else {
                argument.value.string = string_buff_next;
                std::memcpy(string_buff_next, value, bytes);
                string_buff_next += bytes;
            }
        } else if (text.empty() || non_numeric) {
            argument.type = SPI_STACK_TYPE_INVALID;
        } else if (argument.type == SPI_STACK_TYPE_FLOAT) {
            argument.value.real = std::atof(text.c_str());
        } else {
            argument.value.integer = std::atoi(text.c_str());
        }
        PushStack(argument);
        ++count;
    }
    return count;
}

namespace {

/**
 * Reads typed values from a binary script without leaving its bytes.
 */
struct BinaryReader {
    std::span<const char> bytes;    /**< Whole binary script. */
    int                  &position; /**< Interpreter offset of the next byte. */

    /**
     * Copies the next value out of the script, or moves to its end when the value does not fit.
     */
    template <typename Value>
    bool Read(Value &value) {
        if (position < 0 || static_cast<std::size_t>(position) > bytes.size() || bytes.size() - position < sizeof value) {
            position = static_cast<int>(bytes.size());
            return false;
        }
        std::memcpy(&value, bytes.data() + position, sizeof value);
        position += static_cast<int>(sizeof value);
        return true;
    }

    /**
     * Moves to the next four-byte boundary, no further than the script's end.
     */
    void Align() { position = std::min(static_cast<int>(bytes.size()), (position + 3) & ~3); }

    /**
     * Gives the terminated string at the reader and moves past it and its padding, or null when it is unterminated.
     */
    char *String() {
        if (position < 0 || static_cast<std::size_t>(position) >= bytes.size()) {
            return nullptr;
        }
        const auto rest = bytes.subspan(position);
        const auto end = std::ranges::find(rest, '\0');
        if (end == rest.end()) {
            position = static_cast<int>(bytes.size());
            return nullptr;
        }
        char *text = const_cast<char *>(rest.data());
        position += static_cast<int>(end - rest.begin()) + 1;
        Align();
        return text;
    }
};

} // namespace

// Retail reads each binary tag's argument count from the script into a 256-entry type table and reads
// the values without checking the script's length; the native reader stays inside both.
PORT_OVERRIDE int CScriptInterpreter::GetArgBin() {
    BinaryReader reader{
        .bytes = {buffer, static_cast<std::size_t>(std::max(size, 0))},
        .position = position
    };
    s16 count = 0;
    if (!reader.Read(count) || count <= 0) {
        return 0;
    }

    std::vector<int> types(static_cast<std::size_t>(count), SPI_STACK_TYPE_INVALID);
    for (auto &type : types) {
        u8 code = 0;
        if (!reader.Read(code)) {
            return stack_count;
        }
        switch (code) {
            case SPI_BINARY_ARG_TYPE_INT:
                type = SPI_STACK_TYPE_INT;
                break;
            case SPI_BINARY_ARG_TYPE_FLOAT:
                type = SPI_STACK_TYPE_FLOAT;
                break;
            case SPI_BINARY_ARG_TYPE_STRING:
                type = SPI_STACK_TYPE_STRING;
                break;
            default:
                break;
        }
    }
    reader.Align();

    for (const int type : types) {
        SPI_STACK argument{};
        argument.type = type;
        bool read = true;
        switch (type) {
            case SPI_STACK_TYPE_INT:
                read = reader.Read(argument.value.integer);
                break;
            case SPI_STACK_TYPE_FLOAT:
                read = reader.Read(argument.value.real);
                break;
            case SPI_STACK_TYPE_STRING:
                argument.value.string = reader.String();
                read = argument.value.string != nullptr;
                break;
            default:
                break;
        }
        if (!read) {
            break;
        }
        PushStack(argument);
    }
    return stack_count;
}

// Retail copies a text tag's name into 256 bytes with no limit and reads one byte past the script; the
// native reader keeps the name in a string and stops at the script's end.
PORT_OVERRIDE int CScriptInterpreter::SearchCommand(int *tag_index) {
    if (binary) {
        BinaryReader reader{
            .bytes = {buffer, static_cast<std::size_t>(std::max(size, 0))},
            .position = position
        };
        s16 index = -1;
        if (!reader.Read(index)) {
            return 0;
        }
        *tag_index = index;
        return index >= 0;
    }

    if (!SkipArgumentSpace(*this)) {
        return 0;
    }

    std::string name;
    for (;;) {
        if (position >= size) {
            position = size + 1;
            return 0;
        }
        const char byte = buffer[position++];
        if (IsSpace(byte) || byte == ';') {
            // The semicolon ends the arguments, so it is read again by GetArg.
            if (byte == ';') {
                back();
            }
            break;
        }
        name.push_back(byte);
    }

    *tag_index = -1;
    if (name.empty() || name.front() < 'A' || name.front() > 'Z') {
        return 1;
    }

    if (hash_table != nullptr) {
        for (SPI_TAG_HASH *link = hash_table[hash(name.data())]; link != nullptr; link = link->next) {
            if (name == link->name) {
                *tag_index = link->index;
                return 1;
            }
        }
    } else {
        for (int i = 0; i < tag_count; ++i) {
            if (name == tag[i].name) {
                *tag_index = i;
                return 1;
            }
        }
    }
    return 1;
}
