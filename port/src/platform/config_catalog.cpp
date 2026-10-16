#include "platform/config_catalog.hpp"

#include <nlohmann/json.hpp>

#include <cmath>
#include <fstream>
#include <limits>
#include <stdexcept>

#include "platform/datapacks.hpp"
#include "platform/legacy_encoding.hpp"

namespace config_catalog {
namespace {
/**
 * Checks a converted-data-relative configuration path.
 */
std::filesystem::path Relative(const std::string &name) {
    const std::filesystem::path path(name);
    if (name.empty() || path.is_absolute() || path.has_root_name() || name.find(':') != std::string::npos || name.find('\\') != std::string::npos) {
        throw std::runtime_error("unsafe config path");
    }
    for (const auto &part : path) {
        if (part == "." || part == "..") {
            throw std::runtime_error("unsafe config path");
        }
    }
    return path;
}

/**
 * Decodes exceptional original game strings that have no valid Unicode representation.
 */
std::string GameBytes(const std::string &hex) {
    if (hex.size() % 2) {
        throw std::runtime_error("invalid config game_bytes");
    }
    auto digit = [](char value) {
        if (value >= '0' && value <= '9') {
            return value - '0';
        }
        if (value >= 'a' && value <= 'f') {
            return value - 'a' + 10;
        }
        if (value >= 'A' && value <= 'F') {
            return value - 'A' + 10;
        }
        throw std::runtime_error("invalid config game_bytes");
    };
    std::string bytes;
    for (std::size_t index = 0; index < hex.size(); index += 2) {
        const auto value = static_cast<char>(digit(hex[index]) * 16 + digit(hex[index + 1]));
        if (!value) {
            throw std::runtime_error("null byte in config game_bytes");
        }
        bytes.push_back(value);
    }
    return bytes;
}

/**
 * Validates one JSON configuration and creates typed native callback arguments.
 */
std::shared_ptr<const Document> Read(const nlohmann::json &data) {
    const auto kind = data.value("kind", std::string{});
    if (!kind.empty() && kind != "commands") {
        throw std::runtime_error("configuration requires its specialized consumer: " + kind);
    }
    if (data.at("schema_version") != 1 || !data.at("commands").is_array()) {
        throw std::runtime_error("unsupported config schema");
    }
    auto document = std::make_shared<Document>();
    for (const auto &item : data.at("commands")) {
        Command command;
        if (item.contains("command") == item.contains("tag_index")) {
            throw std::runtime_error("config command requires one name or tag_index");
        }
        if (item.contains("command")) {
            command.name = item.at("command").get<std::string>();
        } else {
            command.index = item.at("tag_index").get<int>();
        }
        if (!item.at("args").is_array()) {
            throw std::runtime_error("config arguments must be an array");
        }
        if (item.at("args").size() > 64) {
            throw std::runtime_error("config command exceeds native argument capacity");
        }
        std::size_t string_bytes = 0;
        for (const auto &arg : item.at("args")) {
            Argument   argument;
            const auto type = arg.at("type").get<std::string>();
            if (type == "int") {
                if (!arg.at("value").is_number_integer()) {
                    throw std::runtime_error("config integer has non-integer value");
                }
                if (arg.at("value").is_number_unsigned() && arg.at("value").get<uint64_t>() > static_cast<uint64_t>(std::numeric_limits<int>::max())) {
                    throw std::runtime_error("config integer out of range");
                }
                const auto value = arg.at("value").get<int64_t>();
                if (value < std::numeric_limits<int>::min() || value > std::numeric_limits<int>::max()) {
                    throw std::runtime_error("config integer out of range");
                }
                argument.value = static_cast<int>(value);
            } else if (type == "float") {
                const auto value = arg.at("value").get<float>();
                if (!std::isfinite(value)) {
                    throw std::runtime_error("nonfinite config float");
                }
                argument.value = value;
            } else if (type == "string") {
                auto value = arg.contains("game_bytes") ? GameBytes(arg.at("game_bytes")) : legacy_encoding::GameText(arg.at("value").get<std::string>());
                string_bytes += value.size() + 1;
                if (string_bytes > 0x2800) {
                    throw std::runtime_error("config command exceeds native string capacity");
                }
                argument.value = std::move(value);
            } else if (type != "invalid") {
                throw std::runtime_error("unknown config argument type: " + type);
            }
            command.arguments.push_back(std::move(argument));
        }
        document->commands.push_back(std::move(command));
    }
    return document;
}
} // namespace

void Clear() {}

bool Load(const std::filesystem::path &, std::string &error) {
    error.clear();
    return true;
}

bool Contains(std::string_view path) {
    for (const auto &candidate : Paths(path)) {
        if (std::filesystem::is_regular_file(candidate)) {
            return true;
        }
    }
    return false;
}

std::vector<std::filesystem::path> Paths(std::string_view path) {
    try {
        const auto relative = Relative(std::string(path));
        return relative.extension() == ".json" ? datapacks::Candidates(relative) : std::vector<std::filesystem::path>{};
    } catch (const std::exception &) {
        return {};
    }
}

std::shared_ptr<const Document> Find(std::string_view path, std::string &error) {
    for (const auto &candidate : Paths(path)) {
        if (!std::filesystem::is_regular_file(candidate)) {
            continue;
        }
        try {
            std::ifstream input(candidate);
            auto          document = Read(nlohmann::json::parse(input));
            error.clear();
            return document;
        } catch (const std::exception &exception) {
            error = exception.what();
        }
    }
    if (error.empty()) {
        error = "native configuration document missing: " + std::string(path);
    }
    return {};
}

std::shared_ptr<const Document> Decode(const nlohmann::json &data, std::string &error) {
    try {
        auto document = Read(data);
        error.clear();
        return document;
    } catch (const std::exception &exception) {
        error = exception.what();
        return {};
    }
}
} // namespace config_catalog
