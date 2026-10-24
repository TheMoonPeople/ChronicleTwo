#pragma once

// What the game calls in the iOS port. The UIKit code is Swift (port/src/ios/*.swift), which exports these with
// @_cdecl; it calls back into the game through bridge.hpp.

#include <filesystem>

extern "C" {

/**
 * Shows the launcher until the player starts the game: the state of the game data under data_root, its extraction
 * from a disc image in Documents or one chosen in Files, and the APP SETTINGS rows. Returns once the data is current
 * and the player tapped Play. Called on the main thread, before the game's window exists.
 */
void IosLauncherRunAt(const char *data_root);

/**
 * Shows the on-screen gamepad over the game's window from now on, while InputTouchOverlayVisible() holds: no
 * gamepad, keyboard or mouse connected. Its buttons and sticks drive pad 0. Called on the main thread.
 */
void IosTouchOverlayStart(void);

/**
 * Whether a DualSense's HD haptics play through Core Haptics: iOS gives apps no audio endpoint for the pad, so a
 * thread renders the actuator signal of dualsense_haptics.hpp and plays, on each handle, its strength as the
 * intensity and its pitch as the sharpness of a continuous haptic event. Starts that thread on its first call.
 */
bool IosHapticsReady(void);
}

inline void IosLauncherRun(const std::filesystem::path &data_root) { IosLauncherRunAt(data_root.c_str()); }
