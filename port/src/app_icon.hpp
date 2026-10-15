#pragma once

#include <cstddef>
#include <cstdint>
#include <filesystem>
#include <vector>

// The game's icon is Max's wrench from the memory card save icon (dc2_ic.ico in menu/<lang>/save.pac). It is
// drawn from the user's own extracted data at launch, so no build or package carries a copy of it.

// Draws a PS2 memory card icon model (.ico) to size x size RGBA8 pixels with a transparent background.
// Returns an empty vector when the file is not a PS2 icon this decoder understands.
std::vector<std::uint8_t> AppIconRender(const std::uint8_t *ico, std::size_t ico_size, int size);

// Finds dc2_ic.ico in the extracted data and draws it; empty when the data has none.
std::vector<std::uint8_t> AppIconFromData(const std::filesystem::path &data_root, int size);

// Gives the window the wrench icon. On Windows it also writes chronicletwo.ico beside data/ and, the
// first time, a "Dark Chronicle" shortcut beside the executable that carries it.
void AppIconInstall(const std::filesystem::path &data_root);
