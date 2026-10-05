#pragma once

#include "common.h"

/**
 * @file
 * Declares the sound-effect sequencer: Standard MIDI File data converted
 * into a compact event list, and the player that steps through it to
 * trigger, stop and modulate sound effects track by track.
 */

class mgCMemory;

/**
 * MIDI status bytes, with the channel nibble cleared, that a sound-effect
 * sequence handles.
 */
enum sndMIDI_STATUS {
    SND_MIDI_NOTE_OFF = 0x80,    /**< Note off: key, velocity. */
    SND_MIDI_NOTE_ON = 0x90,     /**< Note on: key, velocity; velocity 0 acts as note off. */
    SND_MIDI_CTRL_CHG = 0xB0,    /**< Control change: controller, value. */
    SND_MIDI_PROG_CHG = 0xC0,    /**< Program change: program. */
    SND_MIDI_CH_PRESSURE = 0xD0, /**< Channel pressure: one data byte, stored but ignored. */
    SND_MIDI_PITCH_BEND = 0xE0,  /**< Pitch bend: LSB, MSB. */
    SND_MIDI_META = 0xFF,        /**< Meta event in the file; never stored in the event list. */
};

/**
 * MIDI meta event types the sequence loader recognises.
 */
enum sndMIDI_META {
    SND_MIDI_META_END_OF_TRACK = 0x2F, /**< End of track: stops loading. */
};

/**
 * MIDI controller numbers a sound-effect sequence acts on.
 */
enum sndMIDI_CTRL {
    SND_MIDI_CTRL_VOLUME = 7,      /**< Track volume. */
    SND_MIDI_CTRL_PAN = 10,        /**< Track pan. */
    SND_MIDI_CTRL_EXPRESSION = 11, /**< Track expression, scaling the volume. */
    SND_MIDI_CTRL_LOOP = 110,      /**< Loop marker: value 0 marks the loop start, 127 the loop end. */
};

/**
 * Values of the loop marker controller.
 */
enum sndMIDI_LOOP {
    SND_MIDI_LOOP_START = 0, /**< Marks the event the sequence loops back to. */
    SND_MIDI_LOOP_END = 127, /**< Marks the point the sequence loops from. */
};

/**
 * One channel event of a sound-effect sequence, as converted from a
 * Standard MIDI File track.
 */
struct sndSeSeqEvent {
    s16 delta;  /**< Ticks to wait after the previous event. */
    u8 status;  /**< MIDI status byte with channel, or 0 for the terminating event. */
    u8 unk_3;
    s8 data[2]; /**< MIDI data bytes; unused bytes are left undefined. */
};
STATIC_ASSERT(sizeof(sndSeSeqEvent) == 0x6);

/**
 * Sounding note of a sequence track, kept so that it can be stopped and
 * have its volume, pan and pitch updated.
 */
struct sndSeSeqVoice {
    s8 active; /**< Non-zero while the note is playing. */
    s8 prog;   /**< Program the note was started with. */
    s8 key;    /**< Key number of the note. */
    s8 se_id;  /**< Sound effect ID the note was started with. */

    /**
     * Creates the voice as silent.
     */
    sndSeSeqVoice() { active = 0; }
};
STATIC_ASSERT(sizeof(sndSeSeqVoice) == 0x4);

/**
 * Sound-effect sequence converted from a format 0 Standard MIDI File:
 * its event list and playback rate.
 */
class sndCSeSeqData {
public:
    char *name;             /**< Name of the sequence. */
    int tick_rate;          /**< Ticks the sequence advances per second. */
    int event_num;          /**< Number of entries in the event list, the terminating event included. */
    sndSeSeqEvent *event;   /**< Event list, ending in an event with status 0, or NULL when none is loaded. */

    /**
     * Creates the sequence with no events.
     *
     * @mangled __ct__13sndCSeSeqDataFv
     * @address 0x18F4B0
     * @size 0x30
     */
    sndCSeSeqData();

    /**
     * Clears the event list and resets the tick rate.
     *
     * @mangled Initialize__13sndCSeSeqDataFv
     * @address 0x18CAC0
     * @size 0x20
     */
    void Initialize();

    /**
     * Converts a format 0 Standard MIDI File into the event list, allocated
     * from the stack region of the given memory manager.
     *
     * @mangled LoadSMF__13sndCSeSeqDataFPciP9mgCMemory
     * @address 0x18CAE0
     * @size 0x350
     */
    void LoadSMF(char *smf, int size, mgCMemory *memory);
};
STATIC_ASSERT(sizeof(sndCSeSeqData) == 0x10);

/**
 * Channel state of a sound-effect sequence: controller values and the
 * note it is sounding.
 */
class sndTrack {
public:
    s8 vol;                  /**< Volume controller value. */
    s8 expression;           /**< Expression controller value. */
    s8 prog;                 /**< Current program. */
    s8 pan;                  /**< Pan controller value. */
    s8 bend_lsb;             /**< Pitch bend low seven bits. */
    s8 bend_msb;             /**< Pitch bend high seven bits. */
    s8 se_id;                /**< Sound effect ID new notes are started with. */
    s8 unk_7;
    int voice_num;           /**< Number of usable entries of voice. */
    sndSeSeqVoice voice[1];  /**< Notes the track is sounding. */

    /**
     * Creates the track with default controller values.
     */
    sndTrack() { Initialize(); }

    /**
     * Resets the controllers to their defaults and silences every voice.
     *
     * @mangled Initialize__8sndTrackFv
     * @address 0x18CA60
     * @size 0x60
     */
    void Initialize();

    /**
     * Finds the active voice playing a key with a program, or NULL when
     * none is.
     *
     * @mangled SaerchVoice__8sndTrackFii
     * @address 0x18D840
     * @size 0x60
     */
    sndSeSeqVoice *SaerchVoice(int prog, int key);

    /**
     * Finds a silent voice, or NULL when every voice is active.
     *
     * @mangled GetEmptyVoice__8sndTrackFv
     * @address 0x18D8A0
     * @size 0x50
     */
    sndSeSeqVoice *GetEmptyVoice();

    /**
     * Claims a voice for a key on the current program, returning non-zero
     * when the key is now held and the sound effect should be started.
     *
     * @mangled NoteOn__8sndTrackFii
     * @address 0x18D8F0
     * @size 0x80
     */
    int NoteOn(int key, int velocity);

    /**
     * Releases the voice holding a key on the current program, returning
     * non-zero when one was found and its sound effect should be stopped.
     *
     * @mangled NoteOff__8sndTrackFii
     * @address 0x18D970
     * @size 0x40
     */
    int NoteOff(int key, int velocity);

    /**
     * Stores a volume, expression or pan controller value, returning
     * non-zero.
     *
     * @mangled CtrlChg__8sndTrackFii
     * @address 0x18D9B0
     * @size 0x50
     */
    int CtrlChg(int ctrl, int value);

    /**
     * Selects the program new notes are started with, returning zero.
     *
     * @mangled ProgChg__8sndTrackFi
     * @address 0x18DA00
     * @size 0x10
     */
    int ProgChg(int prog);

    /**
     * Stores the pitch bend, returning non-zero.
     *
     * @mangled PitchBend__8sndTrackFii
     * @address 0x18DA10
     * @size 0x10
     */
    int PitchBend(int msb, int lsb);
};
STATIC_ASSERT(sizeof(sndTrack) == 0x10);

/**
 * Player of one sound-effect sequence on a sound port, driving each MIDI
 * channel of the sequence as a track of sound effects.
 */
class sndCSeSeq {
public:
    int port;                  /**< Sound driver port the sound effects play on. */
    int bank;                  /**< Bank the sound effects are taken from. */
    sndCSeSeqData *data;       /**< Sequence being played, or NULL when the player is free. */
    sndSeSeqEvent *event;      /**< Next event to process, or NULL before playback starts. */
    int tick;                  /**< Ticks elapsed since playback started. */
    int wait;                  /**< Ticks elapsed since the previous event was processed. */
    int vol;                   /**< Volume applied to every track, 0 to 127. */
    int loop_tick;             /**< Value of tick at the loop start marker. */
    sndSeSeqEvent *loop_event; /**< Loop start controller event to revisit. */
    int loop;                  /**< Non-zero once the loop end marker has been reached during a step. */
    int pause;                 /**< Non-zero keeps Step from advancing the sequence. */
    int track_num;             /**< Number of tracks in use. */
    sndTrack track[8];         /**< Track of each MIDI channel. */

    /**
     * Creates an idle player.
     *
     * @mangled __ct__9sndCSeSeqFv
     * @address 0x191BB0
     * @size 0x80
     */
    sndCSeSeq() { Initialize(); }

    /**
     * Detaches the sequence and resets the volume and every track, giving
     * the tracks consecutive sound effect IDs.
     *
     * @mangled Initialize__9sndCSeSeqFv
     * @address 0x18CE30
     * @size 0xA0
     */
    void Initialize();

    /**
     * Gives the tracks consecutive sound effect IDs starting from a base.
     *
     * @mangled SetSeID__9sndCSeSeqFi
     * @address 0x18CED0
     * @size 0x40
     */
    void SetSeID(int id);

    /**
     * Advances the tick counters by the ticks that pass in a number of
     * frames.
     *
     * @mangled Count__9sndCSeSeqFf
     * @address 0x18CF10
     * @size 0x70
     */
    void Count(float frames);

    /**
     * Stops every sounding note and detaches the sequence.
     *
     * @mangled Stop__9sndCSeSeqFv
     * @address 0x18CF80
     * @size 0x40
     */
    void Stop();

    /**
     * Advances the sequence by a number of frames, processing every event
     * that falls due, returning non-zero when the player is free or the
     * sequence has ended.
     *
     * @mangled Step__9sndCSeSeqFf
     * @address 0x18CFC0
     * @size 0x1E0
     */
    int Step(float frames);

    /**
     * Returns non-zero when a track number is in range.
     *
     * @mangled chk_trk__9sndCSeSeqFi
     * @address 0x18D1A0
     * @size 0x30
     */
    int chk_trk(int trk);

    /**
     * Starts a key on a track's current program, or releases it when the
     * velocity is zero.
     *
     * @mangled NoteOn__9sndCSeSeqFiii
     * @address 0x18D1D0
     * @size 0x120
     */
    void NoteOn(int trk, int key, int velocity);

    /**
     * Stops a key on a track's current program.
     *
     * @mangled NoteOff__9sndCSeSeqFiii
     * @address 0x18D2F0
     * @size 0x90
     */
    void NoteOff(int trk, int key, int velocity);

    /**
     * Stops every sounding note on every track.
     *
     * @mangled AllNoteOff__9sndCSeSeqFv
     * @address 0x18D380
     * @size 0x50
     */
    void AllNoteOff();

    /**
     * Stops every sounding note on a track.
     *
     * @mangled TrackNoteOff__9sndCSeSeqFi
     * @address 0x18D3D0
     * @size 0xA0
     */
    void TrackNoteOff(int trk);

    /**
     * Applies a control change to a track and updates the volume or pan of
     * its sounding notes.
     *
     * @mangled CtrlChg__9sndCSeSeqFiii
     * @address 0x18D470
     * @size 0xB0
     */
    void CtrlChg(int trk, int ctrl, int value);

    /**
     * Applies a program change to a track.
     *
     * @mangled ProgChg__9sndCSeSeqFii
     * @address 0x18D520
     * @size 0x60
     */
    void ProgChg(int trk, int prog);

    /**
     * Applies a pitch bend to a track and updates the pitch of its sounding
     * notes.
     *
     * @mangled PitchBend__9sndCSeSeqFiii
     * @address 0x18D580
     * @size 0x80
     */
    void PitchBend(int trk, int msb, int lsb);

    /**
     * Sends a track's volume, scaled by its expression and the player
     * volume, to its sounding notes.
     *
     * @mangled SendVol__9sndCSeSeqFi
     * @address 0x18D600
     * @size 0xF0
     */
    void SendVol(int trk);

    /**
     * Sends a track's pan to its sounding notes.
     *
     * @mangled SendPan__9sndCSeSeqFi
     * @address 0x18D6F0
     * @size 0xA0
     */
    void SendPan(int trk);

    /**
     * Sends a track's pitch bend to its sounding notes.
     *
     * @mangled SendPitch__9sndCSeSeqFi
     * @address 0x18D790
     * @size 0xB0
     */
    void SendPitch(int trk);
};
STATIC_ASSERT(sizeof(sndCSeSeq) == 0xB0);
