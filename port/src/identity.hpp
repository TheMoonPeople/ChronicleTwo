#pragma once

#include <cstdint>

void GameSetIdentity();

// Window icon pixels (size x size RGBA8); they must stay alive until the window is created.
void GameSetIcon(const std::uint8_t *rgba, int size);
