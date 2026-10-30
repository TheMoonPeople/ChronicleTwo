#include "common.h"

#include <charconv>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <locale>
#include <sstream>

#include "log/game_output.hpp"
#include "scriptinterpreter.hpp"

int dc2::script::InvokeTagFunction(TagFunction function, TagArguments arguments, int count) {
    if (function == nullptr || count < 0 || static_cast<std::size_t>(count) > arguments.Remaining()) {
        return 0;
    }
    try {
        return function(arguments, count);
    } catch (const ArgumentError &) {
        return 0;
    }
}

static int  SkipSpace(input_str &in);
static u8   CheckChar(char c);
static void PreProcess(input_str &in);

int input_str::GetLine(char *line, int line_size, char *terminator) {
    char crlf[] = "\r\n";
    int  count = {};
    int  found = {};
    int  c = {};

    if (terminator == nullptr) {
        terminator = crlf;
    }

    if (line == nullptr || line_size <= 0) {
        return 0;
    }
    if (buffer == nullptr || size < 0 || position < 0 || position > size) {
        line[0] = '\0';
        return 0;
    }
    const std::size_t terminator_length = std::strlen(terminator);
    count = 0;
    found = 1;

    for (;;) {
        if (position <= size && terminator_length <= static_cast<std::size_t>(size - position) &&
            std::memcmp(buffer + position, terminator, terminator_length) == 0) {
            position += static_cast<int>(terminator_length);
            break;
        }

        if (!get(&c)) {
            found = 0;
            break;
        }

        if (count < line_size - 1) {
            line[count++] = c;
        }
    }

    line[count] = '\0';
    return found;
}

void CScriptInterpreter::PushStack(SPI_STACK argument) {
    if (stack_count >= stack_size) {
        dc2::log::PrintGame("SPI stack over!!\n");
        return;
    }

    stack[stack_count] = argument;
    stack_count++;
}

void CScriptInterpreter::Run() {
    while (GetNextTAG(1) >= 0) {
    }
}

int CScriptInterpreter::hash(char *name) {
    u8 value = 0;

    while (*name != '\0') {
        value = ((value << 8) + *name++) % SPI_HASH_BUCKET_COUNT;
    }

    return value;
}

void CScriptInterpreter::SetTag(std::span<const SPI_TAG_PARAM> tags) {
    std::size_t count = 0;
    while (count < tags.size() && tags[count].name != nullptr && tags[count].name[0] != char{}) {
        ++count;
    }
    if (count > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
        throw std::length_error("too many script tags");
    }
    std::vector<std::string> names;
    names.reserve(count);
    std::vector<SPI_TAG_PARAM> callbacks;
    callbacks.reserve(count);
    for (const auto &entry : tags.first(count)) {
        names.emplace_back(entry.name);
        callbacks.push_back({nullptr, entry.function});
    }
    std::vector<SPI_TAG_HASH> entries(count);
    tag_names = std::move(names);
    owned_tags = std::move(callbacks);
    hash_entries = std::move(entries);
    tag_count = static_cast<int>(count);
    tag = owned_tags.data();
    hash_buckets.fill(nullptr);
    hash_table = hash_buckets.data();
    for (std::size_t index = 0; index < count; ++index) {
        auto &entry = hash_entries[index];
        tag[index].name = tag_names[index].data();
        entry.name = tag[index].name;
        entry.index = static_cast<int>(index);
        auto **tail = &hash_buckets[static_cast<std::size_t>(hash(entry.name))];
        while (*tail != nullptr) {
            tail = &(*tail)->next;
        }
        *tail = &entry;
    }
}

/**
 *
 * Moves a reader past spaces, tabs and line breaks;
 * gives 1 when text remains to be read and 0 at its end.
 *
 */
static int SkipSpace(input_str &in) {
    char *buffer = in.buffer;
    int   position = in.position;

    while (position < in.size) {
        if (CheckChar(buffer[position])) {
            break;
        }

        position++;
    }

    in.position = position;

    if (position >= in.size) {
        return 0;
    }

    return 1;
}

/**
 *
 * Tells whether a character is part of a word: gives 0 for
 * a space, a tab or a line break and 1 for anything else.
 *
 */
static u8 CheckChar(char c) {
    int space = 0;

    if (c == ' ') {
        space = 1;
    }

    if (c == '\t') {
        space = 1;
    }

    if (c == '\n') {
        space = 1;
    }

    if (c == '\r') {
        space = 1;
    }

    return (space != 0) ^ 1;
}

/**
 *
 * Overwrites the line comments and block comments of a text
 * script with spaces, so that the parser passes over them.
 *
 */
static void PreProcess(input_str &in) {
    u8 *text = reinterpret_cast<u8 *>(in.buffer);
    int i = 0;

    while (i < in.size) {
        if (text[i] == '/' && text[i + 1] == '/') {
            for (; i < in.size; i++) {
                if (text[i] == '\n' || text[i] == '\r') {
                    break;
                }

                text[i] = ' ';
            }
        }

        if (text[i] == '/' && text[i + 1] == '*') {
            for (; i < in.size; i++) {
                if (text[i] == '*' && text[i + 1] == '/') {
                    text[i] = ' ';
                    text[i + 1] = ' ';
                    break;
                }

                text[i] = ' ';
            }
        } else {
            i++;
        }
    }
}

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
#include "scriptinterpreter.hpp"

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
 *
 * Isolates nested callbacks within the interpreter that owns their retained arguments.
 *
 */
struct DepthScope {
    CScriptInterpreter &interpreter; /**< Interpreter that owns the active depth and slots. */

    explicit DepthScope(CScriptInterpreter &owner) : interpreter(owner) {
        if (interpreter.invocation_storage.size() <= interpreter.invocation_depth) {
            interpreter.invocation_storage.resize(interpreter.invocation_depth + 1);
        }
        ++interpreter.invocation_depth;
    }

    ~DepthScope() { --interpreter.invocation_depth; }
};

} // namespace

CScriptInterpreter::CScriptInterpreter() : stack(nullptr), string_buff(string_buff_next = nullptr) {
    buffer = nullptr;
    size = position = stack_count = stack_size = string_buff_size = binary = tag_count = 0;

    tag = nullptr;
    hash_table = nullptr;
}

void CScriptInterpreter::SetScript(char *script, int script_size) {
    buffer = script;
    size = script_size;
    position = stack_count = binary = 0;
    live_stack_slots = 0;
    ++script_generation;
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
void CallTag(const SPI_TAG_PARAM &tag, SPI_STACK *stack, int count, std::span<char> text_storage,
             std::span<const std::span<const char>> other_text, std::size_t live_count) {
    dc2::script::InvokeTagFunction(tag.function,
                                   dc2::script::TagArguments(std::span(stack, live_count), text_storage, {}, other_text), count);
}

} // namespace

int CScriptInterpreter::GetNextTAG(int call) {
    if (!tag) {
        return -1;
    }
    DepthScope scope(*this);
    auto      &storage = invocation_storage[invocation_depth - 1];
    if (storage.generation != script_generation) {
        storage = {};
        storage.generation = script_generation;
    }
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
        if (count < 0) {
            return -1;
        }
        storage.live_count = std::max(storage.live_count, static_cast<std::size_t>(stack_count));
        live_stack_slots = storage.live_count;
        if (call && count >= 0 && index >= 0 && index < tag_count && tag[index].function) {
            // A tag with more arguments than the stack holds sees only those that were pushed.
            std::span<char> text_storage;
            if (binary && buffer != nullptr && size > 0) {
                text_storage = {buffer, static_cast<std::size_t>(size)};
            } else if (!binary && string_buff != nullptr && string_buff_next != nullptr &&
                       string_buff_size > 0) {
                const auto used = string_buff_next - string_buff;
                if (used >= 0 && used <= string_buff_size) {
                    text_storage = {string_buff, static_cast<std::size_t>(used)};
                }
            }
            std::array<std::span<const char>, SPI_STACK_SIZE> other_text{};
            std::size_t                                       text_count = 0;
            if (!binary) {
                for (int slot = 0; slot < stack_count; ++slot) {
                    if (stack[slot].type != SPI_STACK_TYPE_STRING) {
                        continue;
                    }
                    try {
                        const auto view = dc2::script::TagArguments(
                                              std::span(stack, static_cast<std::size_t>(stack_count)), text_storage)
                                              .Text(stack[slot].value.string);
                        storage.owned_text[slot].assign(view);
                        stack[slot].value.string = storage.owned_text[slot].data();
                    } catch (const dc2::script::ArgumentError &) {
                        return index;
                    }
                }
                for (std::size_t slot = 0; slot < storage.live_count; ++slot) {
                    if (stack[slot].type == SPI_STACK_TYPE_STRING) {
                        other_text[text_count++] = {
                            storage.owned_text[slot].data(), storage.owned_text[slot].size() + 1};
                    }
                }
                text_storage = {};
            }
            CallTag(tag[index], stack, std::min(count, stack_count), text_storage,
                    std::span(other_text).first(text_count), storage.live_count);
        }
        return index;
    }
}

int CScriptInterpreter::GetArg() {
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
            const std::size_t capacity = static_cast<std::size_t>(std::max(string_buff_size, 0));
            const std::size_t used = string_buff != nullptr && string_buff_next != nullptr
                                         ? static_cast<std::size_t>(string_buff_next - string_buff)
                                         : 0;
            if (string_buff == nullptr || string_buff_next == nullptr || used > capacity || bytes > capacity - used) {
                std::println("SPI string buffer over!!");
            } else {
                argument.value.string = string_buff_next;
                std::memcpy(string_buff_next, value, bytes);
                string_buff_next += bytes;
            }
        } else if (text.empty() || non_numeric) {
            argument.type = SPI_STACK_TYPE_INVALID;
        } else if (argument.type == SPI_STACK_TYPE_FLOAT) {
            float              value = 0.0f;
            std::istringstream input(text);
            input.imbue(std::locale::classic());
            input >> std::noskipws >> value;
            // Some standard libraries report underflow for representable subnormals.
            const bool subnormal = value != 0.0f && std::fabs(value) < std::numeric_limits<float>::min();
            // A nonzero decimal that rounds to zero is outside the float range.
            const bool underflow = value == 0.0f && text.find_first_of("123456789") != std::string::npos;
            if ((!input && !subnormal) || !input.eof() || !std::isfinite(value) || underflow) {
                argument.type = SPI_STACK_TYPE_INVALID;
            } else {
                argument.value.real = value;
            }
        } else {
            int        value = 0;
            const auto parsed = std::from_chars(text.data(), text.data() + text.size(), value);
            if (parsed.ec != std::errc{} || parsed.ptr != text.data() + text.size()) {
                argument.type = SPI_STACK_TYPE_INVALID;
            } else {
                argument.value.integer = value;
            }
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
    void Align() {
        const auto offset = static_cast<std::size_t>(std::max(position, 0));
        position = static_cast<int>(std::min(bytes.size(), (offset + 3) & ~std::size_t{3}));
    }

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
int CScriptInterpreter::GetArgBin() {
    BinaryReader reader{
        .bytes = {buffer, static_cast<std::size_t>(std::max(size, 0))},
        .position = position
    };
    s16 count = 0;
    if (!reader.Read(count) || count < 0) {
        position = size;
        return -1;
    }
    if (count == 0) {
        return 0;
    }

    std::vector<int> types(static_cast<std::size_t>(count), SPI_STACK_TYPE_INVALID);
    for (auto &type : types) {
        u8 code = 0;
        if (!reader.Read(code)) {
            return -1;
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
                position = size;
                return -1;
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
            return -1;
        }
        PushStack(argument);
    }
    return stack_count;
}

// Retail copies a text tag's name into 256 bytes with no limit and reads one byte past the script; the
// native reader keeps the name in a string and stops at the script's end.
int CScriptInterpreter::SearchCommand(int *tag_index) {
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
