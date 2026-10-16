#pragma once

#include <cstdint>

// Drives the retail pad 0 motors on every gamepad SDL has open. The game is single player, but
// DSX and Steam Input show one DualSense as two devices (the pad itself and a virtual Xbox pad),
// and only the one that tool forwards to actually shakes; sending to every open pad reaches it.
// small_motor is the DualShock 2's on/off motor, large_motor its 0-255 one.
void PortPadRumble(bool small_motor, std::uint8_t large_motor);
