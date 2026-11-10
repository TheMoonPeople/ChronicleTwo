#pragma once

struct HostSettings;

/**
 * Applies the game's look-axis convention and configured input preferences.
 */
void InputApplyGameConfig(const HostSettings &settings);

/**
 * Initializes input, keeping physical devices closed when no live input is wanted.
 */
void InputInitForRun(bool devices_closed);
