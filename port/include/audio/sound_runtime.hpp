#pragma once
#include <cstddef>
#include <memory>
#include <span>
#include <string_view>

namespace audio {
class StreamChannel;
class Bank;
} // namespace audio

// Retail CSound passes bank and sequence addresses in int parameters; the host loads through these instead.
void SoundLoadHdBd(int port, const void *hd, int hd_size, const void *bd, int bd_size);
int  SoundLoadHdBdAdd(int port, const void *hd, int hd_size, const void *bd, int bd_size);
int  SoundLoadSeq(int port, const void *sq, int size, const char *name = nullptr);
/**
 * Binds a bank described by the published semantic JSON schema.
 */
int SoundLoadBankJson(int port, std::string_view document, bool add = false);
/**
 * Binds a fully loaded PCM sample bank to the game driver and its linked ports.
 */
int SoundBindBank(int port, const std::shared_ptr<audio::Bank> &bank, bool add = false);
/**
 * Loads a sequence of normalized MIDI events from its published JSON document.
 */
int SoundLoadSequenceJson(int port, std::string_view document, const char *name = nullptr);
// Config volume is a final gain, independent of retail fades and core volumes.
void SoundApplySettings();

// ezBgm's open commands carry the name's address in int; these take it as a pointer.
int EzBgmOpen(int channel, const char *name);
int EzBgmOpenFromPack(int channel, const char *name, const char *pack_name);

// Moves the stream channels on by one sound step when no audio output renders them.
void EzBgmStep();

audio::StreamChannel &EzBgmChannel(int channel);

class mgCMemory;
/**
 * Loads a bounded sound bundle document and its explicit native resource references.
 */
unsigned SoundLoadBundleData(int port_no, std::span<const std::byte> document, mgCMemory *memory);
/**
 * Loads a directly named sound bundle through enabled datapacks.
 */
unsigned SoundLoadBundlePath(int port_no, std::string_view path, mgCMemory *memory);
