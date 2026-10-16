#pragma once
#include <filesystem>
#include <string>
#include <string_view>
#include <vector>

#include "audio/pcm.hpp"
/**
 * Lists replacements and the base file for a direct native audio resource path.
 */
std::vector<std::filesystem::path> AudioAssetCandidates(std::string_view path);
/**
 * Reads standard JSON resource candidates in datapack precedence order.
 */
std::vector<std::string> AudioDocuments(std::string_view path);
/**
 * Loads the first valid WAV resource while preserving its channel count.
 */
std::shared_ptr<audio::PcmTrack> LoadAudioTrack(std::string_view path, std::string &error);
