#include "platform/config_catalog.hpp"

#include <filesystem>
#include <stdexcept>
#include <string>

#include "platform/datapacks.hpp"

namespace config_catalog {
namespace {
/**
 * Checks a converted-data-relative configuration path.
 */
std::filesystem::path Relative(const std::string &name) {
    const std::filesystem::path path(name);
    if (name.empty() || path.is_absolute() || path.has_root_name() || name.contains(':') || name.contains('\\')) {
        throw std::runtime_error("unsafe config path");
    }
    for (const auto &part : path) {
        if (part == "." || part == "..") {
            throw std::runtime_error("unsafe config path");
        }
    }
    return path;
}

} // namespace

bool Contains(std::string_view path) {
    return !Paths(path).empty();
}

std::vector<vfs::Ref> Paths(std::string_view path) {
    try {
        const auto relative = Relative(std::string(path));
        return relative.extension() == ".json" ? datapacks::GameplayCandidates(relative) : std::vector<vfs::Ref>{};
    } catch (const std::exception &) {
        return {};
    }
}

} // namespace config_catalog
