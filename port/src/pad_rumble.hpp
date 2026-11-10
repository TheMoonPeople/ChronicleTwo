#pragma once

#include <cstdint>

// Drives the retail pad 0 motors on every open gamepad: DSX and Steam Input show one DualSense as two
// devices and only the one they forward to shakes. small_motor is the DualShock 2's on/off motor,
// large_motor its 0-255 one.
void PortPadRumble(bool small_motor, std::uint8_t large_motor);
