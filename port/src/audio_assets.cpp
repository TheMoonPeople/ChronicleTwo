#include "audio_assets.hpp"

#include <fstream>
#include <iterator>

#include "platform/datapacks.hpp"

std::vector<std::filesystem::path> AudioAssetCandidates(std::string_view name) {
    const std::filesystem::path path(name);
    if (path.empty() || path.is_absolute() || name.find('\\') != std::string_view::npos || name.find(':') != std::string_view::npos) {
        return {};
    }
    for (const auto &part : path) {
        if (part == ".." || part == ".") {
            return {};
        }
    }
    return datapacks::Candidates(path);
}

std::vector<std::string> AudioDocuments(std::string_view path) {
    std::vector<std::string> result;
    for (const auto &candidate : AudioAssetCandidates(path)) {
        std::ifstream input(candidate, std::ios::binary);
        if (input) {
            result.emplace_back(std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>());
        }
    }
    return result;
}

std::shared_ptr<audio::PcmTrack> LoadAudioTrack(std::string_view path, std::string &error) {
    for (const auto &candidate : AudioAssetCandidates(path)) {
        if (auto track = audio::LoadPcmTrack(candidate, error)) {
            track->loop = false;
            return track;
        }
    }
    if (error.empty()) {
        error = "recording missing";
    }
    return nullptr;
}
