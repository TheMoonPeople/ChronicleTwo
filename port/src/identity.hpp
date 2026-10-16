#pragma once

#include "platform/game_icon.hpp"

void GameSetIdentity();

/**
 * Installs the native title/dc2_ic.gltf icon, retaining the bundled icon if no valid model is available.
 */
void GameSetDataIcon();
/**
 * Describes the native title icon and its datapack fallback candidates.
 */
GameIconSource GameDataIconSource();
