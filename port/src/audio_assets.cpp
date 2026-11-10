#include "audio_assets.hpp"

#include "platform/datapacks.hpp"

std::vector<vfs::Ref> AudioAssetCandidates(std::string_view name) {
    const std::filesystem::path path(name);
    if (path.empty() || path.is_absolute() || name.contains('\\') || name.contains(':')) {
        return {};
    }
    for (const auto &part : path) {
        if (part == ".." || part == ".") {
            return {};
        }
    }
    return path.extension() == ".json" ? datapacks::GameplayCandidates(path) : datapacks::Candidates(path);
}

std::vector<std::string> AudioDocuments(std::string_view path) {
    std::vector<std::string> result;
    for (const auto &candidate : AudioAssetCandidates(path)) {
        std::vector<uint8_t> bytes;
        if (datapacks::ReadFileBytes(candidate, bytes)) {
            result.emplace_back(bytes.begin(), bytes.end());
        }
    }
    return result;
}

std::shared_ptr<audio::PcmTrack> LoadAudioTrack(std::string_view path, std::string &error) {
    for (const auto &candidate : AudioAssetCandidates(path)) {
        std::vector<uint8_t> bytes;
        if (!datapacks::ReadFileBytes(candidate, bytes)) {
            error = "cannot open the file";
            continue;
        }
        if (auto track = audio::LoadPcmTrack(bytes, std::filesystem::path(candidate.Name()).extension().string(), error)) {
            track->loop = false;
            return track;
        }
    }
    if (error.empty()) {
        error = "recording missing";
    }
    return nullptr;
}
