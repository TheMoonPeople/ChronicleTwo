#include "asset_directory.hpp"

const char *AssetMemberName(const char *path) {
    if (!path) {
        return nullptr;
    }
    const char *name = path;
    for (const char *cursor = path; *cursor; ++cursor) {
        if (*cursor == '/' || *cursor == '\\') {
            name = cursor + 1;
        }
    }
    return name;
}
