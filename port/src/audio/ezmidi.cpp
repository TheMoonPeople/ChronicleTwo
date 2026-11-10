#include "common.h"

#include "audio/mixer.hpp"
#include "audio/trace.hpp"
#include "ezmidi.hpp"

namespace {
// EZMIDI commands with a port number in the low four bits.
enum class EzMidiCommand : int {
    Play = 0x00,
    Stop = 0x20,
    Rewind = 0x30,
    SetAttribute = 0xA0,
    SetVolume = 0xB0,
    SetStereo = 0xC0,
    IsPlaying = 0x8090,
    GetVolume = 0x80E0,
};
} // namespace

int ezMidiInit() {
    return 1;
}

// Only the scalar commands reach here: the address-carrying ones are served by the host's own paths.
int ezMidi(int command, int argument) {
    audio::Mixer &mixer = audio::DefaultMixer();
    const int     port = command & 0x0F;

    switch (static_cast<EzMidiCommand>(command & ~0x0F)) {
        case EzMidiCommand::Play:
            mixer.Play(port);
            return 0;
        case EzMidiCommand::Stop:
            mixer.Stop(port);
            return 0;
        case EzMidiCommand::Rewind:
            mixer.Rewind(port, argument);
            return 0;
        case EzMidiCommand::SetAttribute:
            mixer.SetAttribute(port, argument);
            return 0;
        case EzMidiCommand::SetVolume:
            mixer.SetVolume(port, argument);
            return 0;
        case EzMidiCommand::SetStereo:
            mixer.SetStereo(argument != 0);
            return 0;
        case EzMidiCommand::IsPlaying:
            return mixer.IsPlaying(port) ? 1 : 0;
        case EzMidiCommand::GetVolume:
            return mixer.Volume(port);
        default:
            audio::Trace("ezmidi: command 0x%x argument 0x%x has no host equivalent", command, argument);
            return 0;
    }
}
