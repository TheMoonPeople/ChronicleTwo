#include "photo_hd.hpp"

#include <cstdio>
#include <cstring>
#include <filesystem>
#include <system_error>
#include <unordered_map>
#include <unordered_set>

#include "gfx/gfx.hpp"
#include "platform/paths.hpp"
#include "platform/imagefile.hpp"

namespace {

std::unordered_map<uint64_t, std::vector<uint8_t>> photos;
std::unordered_set<uint64_t>                       missing;

uint64_t Hash(const uint8_t *bytes, size_t size) {
    uint64_t hash = 0xCBF29CE484222325ull;
    for (size_t i = 0; i < size; ++i) {
        hash = (hash ^ bytes[i]) * 0x100000001B3ull;
    }
    return hash;
}

std::filesystem::path PhotoPath(uint64_t hash) {
    char name[32];
    std::snprintf(name, sizeof name, "%016llx.png", static_cast<unsigned long long>(hash));
    return PathsSaveRoot() / "photos" / name;
}

} // namespace

bool PhotoHdIsWorkTexture(const char *name) {
    return name != nullptr && std::strcmp(name, "fix_work") == 0;
}

void PhotoHdRemember(const uint8_t *image16, size_t bytes, std::vector<uint8_t> rgba) {
    if (image16 == nullptr || rgba.size() != static_cast<size_t>(kPhotoHdSize) * kPhotoHdSize * 4) {
        return;
    }
    const uint64_t hash = Hash(image16, bytes);
    const auto     path = PhotoPath(hash);
    std::error_code error;
    std::filesystem::create_directories(path.parent_path(), error);
    if (!gfx::WritePng(path, rgba.data(), kPhotoHdSize, kPhotoHdSize)) {
        std::fprintf(stderr, "photo: could not write %s\n", path.string().c_str());
    }
    missing.erase(hash);
    photos[hash] = std::move(rgba);
}

const std::vector<uint8_t> *PhotoHdFind(const uint8_t *image16, size_t bytes) {
    if (image16 == nullptr) {
        return nullptr;
    }
    const uint64_t hash = Hash(image16, bytes);
    if (const auto found = photos.find(hash); found != photos.end()) {
        return &found->second;
    }
    if (missing.contains(hash)) {
        return nullptr;
    }
    int                  width = 0, height = 0;
    std::vector<uint8_t> rgba;
    if (!imagefile::LoadPng(PhotoPath(hash), width, height, rgba) || width != static_cast<int>(kPhotoHdSize) ||
        height != static_cast<int>(kPhotoHdSize)) {
        missing.insert(hash);
        return nullptr;
    }
    for (size_t i = 3; i < rgba.size(); i += 4) {
        rgba[i] = 0xFF; // Opaque in the renderer's units, as retail draws photos (TEXA TA0 = TA1 = 0x80).
    }
    return &(photos[hash] = std::move(rgba));
}
