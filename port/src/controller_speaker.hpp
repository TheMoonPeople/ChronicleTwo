#pragma once

namespace audio {
class Mixer;
class StreamChannel;
} // namespace audio

// A second playback device for a few retail voice streams and sound effects: the speaker of a
// DualSense, found by its device name. Routing moves a stream channel out of the default mixer;
// releasing returns it. Sound effects play there through a mixer of their own.

// Takes the channel off the TV mix and plays it on the controller. False when no controller speaker
// can be opened; the channel then stays where it was.
bool ControllerSpeakerRoute(audio::StreamChannel *channel);

// Hands a routed channel back to the default mixer. Does nothing for a channel that was not routed.
void ControllerSpeakerRelease(audio::StreamChannel *channel);

// Opens the controller speaker if it is not open yet. False when there is none.
bool ControllerSpeakerOpen();

// Whether the open controller device also carries the DualSense's actuators (dualsense_haptics.hpp).
bool ControllerHapticsChannels();

// The mixer the controller speaker plays besides its routed channels, for the sound effects the
// sound driver sends there instead of the default mixer.
audio::Mixer &ControllerSpeakerMixer();
