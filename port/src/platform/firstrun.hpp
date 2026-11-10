#pragma once

#include <filesystem>
#include <string>

bool        FirstRunDataMissing(const std::filesystem::path &root);
std::string FirstRunDataMessage(const std::filesystem::path &root);

/**
 * Prepares missing data in a desktop setup window, or exits with kExitNoData if unavailable or cancelled. On iOS it
 * shows the launcher instead, every time, and returns once the player starts the game.
 */
void FirstRunRequireData(const std::filesystem::path &root, bool headless);
