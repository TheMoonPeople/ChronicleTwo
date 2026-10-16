#pragma once

#include <filesystem>
#include <memory>

#include "platform/vfs.hpp"

/**
 * Mounts a Kazarov ZIP asset archive, such as data.zip or a zipped datapack; throws std::runtime_error when it cannot
 * be opened or holds names that differ only by ASCII case.
 */
std::shared_ptr<const vfs::Mount> ArchiveMountOpen(const std::filesystem::path &path);
