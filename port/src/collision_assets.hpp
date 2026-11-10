#pragma once

#include <filesystem>
#include <string_view>

class CColFrame;
class mgCMemory;

/**
 * Builds collision frames from a glTF file, optionally selecting a named standard scene.
 */
CColFrame *LoadCollisionModel(const std::filesystem::path &gltf, mgCMemory *memory, std::string_view scene = {});
