#pragma once

#include <cstdint>

namespace audio {
class Mixer;
} // namespace audio

// HD haptics on a DualSense: its audio endpoint has four channels, the speaker on the front pair and
// the two voice-coil actuators on the rear pair. controller_speaker.cpp opens it with four channels
// when it can and asks HapticsRender for the rear pair. While haptics play, the HID rumble must stay
// off: SDL turns the pad's audio haptics off for as long as it drives the emulated rumble motors.
// iOS has no such endpoint; ios/Haptics.swift plays the same signal through Core Haptics.

// Whether the game's vibration plays on the actuators now: haptics are on and the pad's audio
// endpoint has the actuator channels. Also opens that endpoint while haptics are on.
bool HapticsActive();

// Whether sound effects should also be sent to HapticsMixer (input.dualsense_haptics "full").
bool HapticsEffectsActive();

// The retail DualShock 2 motors, restated every vertical blank by CGamePad::Step.
void HapticsSetMotors(bool small_motor, std::uint8_t large_motor);

// Reads the camera quakes of dungeons and scene sequences, once a vertical blank.
void HapticsPollGame();

// Sound effects mirrored here are low-passed into the actuators.
audio::Mixer &HapticsMixer();

// Renders frames of actuator signal, left and right interleaved, from the audio device's thread.
void HapticsRender(float *left_right, int frames);
