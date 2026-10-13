#pragma once

namespace audio {
class StreamChannel;
}

// A second playback device for a few retail voice streams: the speaker of a DualSense, found by its
// device name. Routing moves a stream channel out of the default mixer; releasing returns it.

// Takes the channel off the TV mix and plays it on the controller. False when no controller speaker
// can be opened; the channel then stays where it was.
bool ControllerSpeakerRoute(audio::StreamChannel *channel);

// Hands a routed channel back to the default mixer. Does nothing for a channel that was not routed.
void ControllerSpeakerRelease(audio::StreamChannel *channel);
