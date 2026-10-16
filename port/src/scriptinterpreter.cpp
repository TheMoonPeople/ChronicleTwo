#include "scriptinterpreter.hpp"

#include <nlohmann/json.hpp>
#include <sifdev.h>

#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <deque>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

#include "dataread_port.hpp"
#include "native_config.hpp"
#include "platform/config_catalog.hpp"

namespace {

/**
 * Holds one native interpreter's typed arguments and mutable callback strings.
 */
struct NativeSession {
    std::shared_ptr<const config_catalog::Document> document;    /**< Decoded commands for the selected configuration. */
    std::array<SPI_STACK, SPI_STACK_SIZE>           arguments{}; /**< Argument stack used by the current native callback. */
    std::deque<std::string>                         strings;     /**< Stable mutable strings retained for inherited argument slots. */
};

/**
 * Retains typed native configuration state independently of the retail interpreter layout.
 */
std::unordered_map<const CScriptInterpreter *, NativeSession> &NativeSessions() {
    static std::unordered_map<const CScriptInterpreter *, NativeSession> sessions;
    return sessions;
}

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

bool RunNativeConfig(std::string_view game_name, SPI_TAG_PARAM *tags) {
    const std::string                               requested(game_name);
    const auto                                      path = DataReadAssetPath(requested.c_str());
    std::string                                     error;
    std::shared_ptr<const config_catalog::Document> document;
    bool                                            host_found = false;
    if (requested.starts_with("host:") || requested.starts_with("host0:")) {
        const int descriptor = sceOpen(requested.c_str(), SCE_RDONLY);
        if (descriptor >= 0) {
            host_found = true;

            struct CloseFile {
                int descriptor;

                ~CloseFile() { sceClose(descriptor); }
            } close_file{descriptor};

            const int length = sceLseek(descriptor, 0, SCE_SEEK_END);
            if (length >= 0 && sceLseek(descriptor, 0, SCE_SEEK_SET) >= 0) {
                std::vector<char> bytes(static_cast<std::size_t>(length));
                if (sceRead(descriptor, bytes.data(), length) == length) {
                    try {
                        document = config_catalog::Decode(nlohmann::json::parse(bytes.begin(), bytes.end()), error);
                    } catch (const std::exception &exception) {
                        error = exception.what();
                    }
                } else {
                    error = "could not read host configuration";
                }
            } else {
                error = "could not determine host configuration size";
            }
        }
    }
    if (!host_found) {
        document = config_catalog::Find(path.value_or(requested), error);
    }
    if (!document) {
        std::fprintf(stderr, "config: %s\n", error.c_str());
        return false;
    }
    CScriptInterpreter interpreter;
    interpreter.SetTag(tags);
    NativeSessions().emplace(&interpreter, NativeSession{std::move(document), {}, {}});

    struct Cleanup {
        CScriptInterpreter *interpreter;

        ~Cleanup() { NativeSessions().erase(interpreter); }
    } cleanup{&interpreter};

    interpreter.Run();
    return true;
}

PORT_OVERRIDE CScriptInterpreter::CScriptInterpreter() {
    buffer = nullptr;
    size = position = stack_count = stack_size = string_buff_size = binary = tag_count = 0;
    stack = nullptr;
    string_buff = string_buff_next = nullptr;
    tag = nullptr;
    hash_table = nullptr;
    NativeSessions().erase(this);
}

PORT_OVERRIDE void CScriptInterpreter::SetScript(char *script, int script_size) {
    NativeSessions().erase(this);
    buffer = script;
    size = script_size;
    position = stack_count = binary = 0;
    if (!script || script_size <= 0) {
        size = 0;
        return;
    }
    const auto first = std::find_if(script, script + script_size, [](unsigned char byte) { return byte != ' ' && byte != '\t' && byte != '\r' && byte != '\n'; });
    const auto path = DataReadBufferPath(script);
    if ((path && std::filesystem::path(*path).extension() == ".json") || (first != script + script_size && *first == '{')) {
        std::string                                     error;
        std::shared_ptr<const config_catalog::Document> document;
        try {
            document = path ? config_catalog::Find(*path, error) : config_catalog::Decode(nlohmann::json::parse(script, script + script_size), error);
        } catch (const std::exception &exception) {
            error = exception.what();
        }
        if (!document) {
            std::fprintf(stderr, "config: %s\n", error.c_str());
        }
        NativeSessions().emplace(this, NativeSession{std::move(document), {}, {}});
        return;
    }
    if (script_size >= 3 && std::memcmp(script, "BIN", 3) == 0) {
        binary = 1;
        position = std::min(script_size, 4);
    } else {
        PreprocessText(script, script_size);
    }
}

PORT_OVERRIDE int CScriptInterpreter::GetNextTAG(int call) {
    if (!tag) {
        return -1;
    }
    const auto found = NativeSessions().find(this);
    if (found != NativeSessions().end()) {
        auto &session = found->second;
        if (!session.document) {
            return -1;
        }
        while (position < static_cast<int>(session.document->commands.size())) {
            const auto &command = session.document->commands[position++];
            int         index = command.index.value_or(-1);
            if (!command.index) {
                for (int candidate = 0; candidate < tag_count; ++candidate) {
                    if (command.name == tag[candidate].name) {
                        index = candidate;
                        break;
                    }
                }
                if (index < 0) {
                    continue;
                }
            }
            if (index < 0) {
                return -1;
            }
            if (session.strings.size() < command.arguments.size()) {
                session.strings.resize(command.arguments.size());
            }
            SetStack(session.arguments.data(), SPI_STACK_SIZE);
            for (const auto &argument : command.arguments) {
                SPI_STACK value{};
                value.type = SPI_STACK_TYPE_INVALID;
                if (const auto *integer = std::get_if<int>(&argument.value)) {
                    value.type = SPI_STACK_TYPE_INT;
                    value.value.integer = *integer;
                } else if (const auto *real = std::get_if<float>(&argument.value)) {
                    value.type = SPI_STACK_TYPE_FLOAT;
                    value.value.real = *real;
                } else if (const auto *text = std::get_if<std::string>(&argument.value)) {
                    session.strings[stack_count] = *text;
                    value.type = SPI_STACK_TYPE_STRING;
                    value.value.string = session.strings[stack_count].data();
                }
                PushStack(value);
            }
            if (call && index < tag_count && tag[index].function) {
                tag[index].function(stack, stack_count);
            }
            return index;
        }
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
            tag[index].function(stack, count);
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
        int         byte;
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
                    int next;
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
                std::printf("SPI string buffer over!!\n");
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
