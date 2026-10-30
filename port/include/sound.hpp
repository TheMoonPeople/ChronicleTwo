#pragma once

#include "common.h"

/**
 * @file
 * Declares the sound driver: the EE side of the EZMIDI sequencer and EZBGM
 * stream servers on the IOP, the sound processor setup, and the bookkeeping
 * of the banks and sequences each MIDI port holds.
 */

/**
 *
 * Limits of the MIDI ports the sound driver addresses.
 *
 */
// clang-format off
enum MidiPortLimit {
    MIDI_PORT_COUNT      = 16, /**< Number of MIDI ports the sequencer holds. */
    MIDI_PORT_MSIN_FIRST = 7,  /**< First port whose messages go through the MIDI stream input module. */
    MIDI_PORT_BANK_MAX   = 16, /**< Most banks one port can hold. */
    MIDI_PORT_SEQ_MAX    = 10, /**< Number of sequence slots one port holds. */
    MIDI_MSIN_PORT_COUNT = 9,  /**< Number of ports fed through the MIDI stream input module. */
};

// clang-format on

/**
 *
 * Directions a port's banks are laid out in sound processor memory.
 *
 */
// clang-format off
enum SpuAllocDirection {
    SPU_ALLOC_UPWARD   = 0, /**< Each bank body goes at the port's next address, which then moves past it. */
    SPU_ALLOC_DOWNWARD = 1, /**< Each bank body goes just below the port's next address, which then moves down to it. */
};

// clang-format on

/**
 *
 * One volume fade the sequencer advances once a frame.
 *
 */
struct MIDI_FADE {
    s32   active;        /**< Non-zero while the fade runs. */
    s32   target_volume; /**< Volume the fade stops at. */
    float volume;        /**< Volume the fade has reached. */
    float step;          /**< Volume added each frame. */
};

STATIC_ASSERT(sizeof(MIDI_FADE) == 0x10);

/**
 *
 * What the sound driver holds for one MIDI port: the banks loaded into the
 * sound processor for it, the sequences loaded beside them, the ports that
 * share its memory, and its fades.
 *
 */
struct MIDI_PORT {
    s32       unk_00;
    u8        spu_direction;                      /**< Direction the port's banks are laid out in, a SpuAllocDirection. */
    s32       linked_port;                        /**< Port that is given every bank this port loads, or -1. */
    s32       dependent_port[MIDI_PORT_BANK_MAX]; /**< Ports placed at this port's sound processor address, reset when it loads or is deleted. */
    s32       dependent_port_count;               /**< Number of entries in dependent_port. */
    void     *bank[MIDI_PORT_BANK_MAX];           /**< IOP address of each loaded bank header. */
    s32       bank_count;                         /**< Number of banks loaded. */
    s32       spu_address;                        /**< Sound processor address the port's first bank body loads to. */
    s32       ezmidi_param;                       /**< Value sent with the port's EZMIDI 0xA0 message after a bank loads. */
    s32       spu_next_address;                   /**< Sound processor address the port's next bank body loads at. */
    void     *sequence[MIDI_PORT_SEQ_MAX];        /**< IOP address of each loaded sequence. */
    void     *resident_sequence;                  /**< IOP address of the sequence the sequencer is given for the port, kept when the port is deleted. */
    s32       unk_CC[MIDI_PORT_SEQ_MAX];
    s32       sequence_count; /**< Number of sequences loaded. */
    MIDI_FADE fade[2];        /**< The port's two volume fades. */
    s32       unk_118;
    s32       unk_11C;
    s32       unk_120;
};

STATIC_ASSERT(sizeof(MIDI_PORT) == 0x124);

/**
 *
 * What the sound driver holds for the sequencer, one record per port.
 *
 */
struct MIDI_STATE {
    MIDI_PORT port[MIDI_PORT_COUNT]; /**< State of each port. */
};

STATIC_ASSERT(sizeof(MIDI_STATE) == 0x1240);

/**
 *
 * The bank a load hands to the sequencer: its number within the port, where
 * its header and body sit in IOP memory and where the body goes in the sound
 * processor.
 *
 */
struct MIDI_BANK {
    s32   bank_no;     /**< Index of the bank within the port's banks. */
    void *hd_address;  /**< IOP address of the bank header. */
    void *bd_address;  /**< IOP address the bank body is staged at. */
    s32   bd_size;     /**< Size of the bank body in bytes. */
    s32   spu_address; /**< Sound processor address the body loads to. */
    u8    unk_14[0x30];
};

STATIC_ASSERT(sizeof(MIDI_BANK) == 0x44);

/**
 *
 * One buffer of MIDI messages queued for the MIDI stream input module,
 * copied across to the IOP once a frame.
 *
 */
struct MSIN_BUFFER {
    s32 size;            /**< Size of the buffer in bytes. */
    s32 length;          /**< Bytes of messages waiting to be sent. */
    u8  messages[0x1F8]; /**< MIDI messages the stream input library queues for the IOP. */
};

STATIC_ASSERT(sizeof(MSIN_BUFFER) == 0x200);

/**
 *
 * Names sent to the stream server when opening an audio file in a pack.
 *
 */
struct STREAM_PACK_REQUEST {
    char name[52];      /**< Name of the audio file within the pack. */
    char pack_name[12]; /**< Name of the pack holding the audio file. */
};

STATIC_ASSERT(sizeof(STREAM_PACK_REQUEST) == 0x40);

/**
 *
 * The sound driver the whole game plays through. It holds nothing of its
 * own: every call reaches the sound processor or an IOP server behind it.
 *
 */
class CSound {
public:
    /**
     *
     * Silences every voice of one sound processor core.
     *
     * @mangled StopVoice__6CSoundFi
     * @address 0x189E30
     * @size 0x50
     */
    void StopVoice(int core);

    /**
     *
     * Routes the sound processor's inputs into reverberation, or keeps them
     * out of it.
     *
     * @mangled SndInReverb__6CSoundFb
     * @address 0x189E80
     * @size 0x70
     */
    void SndInReverb(bool enable);

    /**
     *
     * Sets the reverberation mode and depth of one sound processor core.
     *
     * @mangled SetReverb__6CSoundFiii
     * @address 0x189EF0
     * @size 0x100
     */
    void SetReverb(int core, int mode, int depth);

    /**
     *
     * Starts the sound processor, the EZMIDI and EZBGM servers and the MIDI
     * stream input module, and sets every port to its starting layout.
     *
     * @mangled Init__6CSoundFiiii
     * @address 0x18A410
     * @size 0x77C
     */
    int Init(int mode0, int mode1, int depth0, int depth1);

    /**
     *
     * Stops every port, frees the IOP memory its banks and sequences hold
     * and releases the bank staging area.
     *
     * @mangled Exit__6CSoundFv
     * @address 0x18AB90
     * @size 0x130
     */
    int Exit();

    /**
     *
     * Stops a port and the ports linked to and dependent on it, and frees
     * the sequences they hold beyond the resident one.
     *
     * @mangled DEL_PORT__6CSoundFi
     * @address 0x18ACC0
     * @size 0x370
     */
    void DEL_PORT(int port);

    /**
     *
     * Starts one of a port's loaded sequences playing at a volume.
     *
     * @mangled SQ_Play__6CSoundFiii
     * @address 0x18B030
     * @size 0x130
     */
    void SQ_Play(int port, int seq_no, int volume);

    /**
     *
     * Starts a port's sequence again.
     *
     * @mangled SQ_RePlay__6CSoundFi
     * @address 0x18B160
     * @size 0x60
     */
    void SQ_RePlay(int port);

    /**
     *
     * Plays one sound effect note on a port with every parameter given.
     *
     * @mangled SE_Play__6CSoundFiiiiiiiii
     * @address 0x18B1C0
     * @size 0x1D0
     */
    void SE_Play(int port, int bank, int program, int key, int pan, int velocity, int volume, int pitch, int id);

    /**
     *
     * Sets the volume of a sounding effect note.
     *
     * @mangled SE_SetVol__6CSoundFiiiiii
     * @address 0x18B390
     * @size 0x110
     */
    void SE_SetVol(int port, int bank, int program, int key, int volume, int id);

    /**
     *
     * Sets the stereo position of a sounding effect note.
     *
     * @mangled SE_SetPan__6CSoundFiiiiii
     * @address 0x18B4A0
     * @size 0x110
     */
    void SE_SetPan(int port, int bank, int program, int key, int pan, int id);

    /**
     *
     * Stops a sounding effect note.
     *
     * @mangled SE_Stop__6CSoundFiiiii
     * @address 0x18B5B0
     * @size 0x100
     */
    void SE_Stop(int port, int bank, int program, int key, int id);

    /**
     *
     * Advances the ports' fades and sends the queued MIDI stream input
     * messages to the IOP, once a frame.
     *
     * @mangled Step__6CSoundFv
     * @address 0x18B6B0
     * @size 0x180
     */
    void Step();

    /**
     *
     * Stops a port's sequence.
     *
     * @mangled Stop__6CSoundFi
     * @address 0x18B830
     * @size 0x40
     */
    void Stop(int port);

    /**
     *
     * Sets a port's sequence volume, out of 256.
     *
     * @mangled SetVol__6CSoundFii
     * @address 0x18B870
     * @size 0x60
     */
    void SetVol(int port, int volume);

    /**
     *
     * Chooses between stereo and monaural output.
     *
     * @mangled SetStereoMode__6CSoundFi
     * @address 0x18B8D0
     * @size 0x10
     */
    void SetStereoMode(int mode);

    /**
     *
     * Sets the master volume of one sound processor core.
     *
     * @mangled SetMasterVol__6CSoundFii
     * @address 0x18B8E0
     * @size 0x60
     */
    void SetMasterVol(int core, int volume);

    /**
     *
     * Loads a port's first bank, replacing the banks and sequences it
     * held.
     *
     * @mangled LoadHdBd__6CSoundFiiiii
     * @address 0x18B940
     * @size 0x10
     */
    void LoadHdBd(int port, int hd, int hd_size, int bd, int bd_size);

    /**
     *
     * Loads a port's first bank into the sound processor, replacing the
     * banks and sequences it and its linked port held, and places its
     * dependent ports after it.
     *
     * @mangled LoadHdBd2__6CSoundFiiiii
     * @address 0x18B950
     * @size 0x600
     */
    void LoadHdBd2(int port, int hd, int hd_size, int bd, int bd_size);

    /**
     *
     * Loads one more bank for a port into the sound processor, after the
     * banks it already holds.
     *
     * @mangled LoadHdBdAdd__6CSoundFiiiii
     * @address 0x18BF50
     * @size 0x2E0
     */
    int LoadHdBdAdd(int port, int hd, int hd_size, int bd, int bd_size);

    /**
     *
     * Copies one sequence into IOP memory and adds it to a port's
     * sequences.
     *
     * @mangled LoadSeq__6CSoundFiii
     * @address 0x18C230
     * @size 0x180
     */
    int LoadSeq(int port, int address, int size);

    /**
     *
     * Sets the pitch bend of a sounding effect note.
     *
     * @mangled SE_SetPitch__6CSoundFiiiiii
     * @address 0x18C3B0
     * @size 0xF0
     */
    void SE_SetPitch(int port, int bank, int program, int key, int pitch, int id);

    /**
     *
     * Opens a streamed audio file on one stream channel.
     *
     * @mangled StreamOpenFast__6CSoundFiPc
     * @address 0x18C4A0
     * @size 0x60
     */
    void StreamOpenFast(int channel, char *name);

    /**
     *
     * Opens a streamed audio file held in a file pack on one stream
     * channel.
     *
     * @mangled StreamOpenFromFPLFast__6CSoundFiPcPc
     * @address 0x18C500
     * @size 0x70
     */
    void StreamOpenFromFPLFast(int channel, char *name, char *pack_name);

    /**
     *
     * Starts a stream channel playing.
     *
     * @mangled StreamPlay__6CSoundFi
     * @address 0x18C570
     * @size 0x10
     */
    void StreamPlay(int channel);

    /**
     *
     * Halts a stream channel where it is, by the same request as
     * StreamPause.
     *
     * @mangled StreamStop__6CSoundFi
     * @address 0x18C580
     * @size 0x10
     */
    void StreamStop(int channel);

    /**
     *
     * Stops and closes a stream channel.
     *
     * @mangled StreamClose__6CSoundFi
     * @address 0x18C590
     * @size 0x50
     */
    void StreamClose(int channel);

    /**
     *
     * Ends and closes a stream channel.
     *
     * @mangled StreamEND__6CSoundFi
     * @address 0x18C5E0
     * @size 0x50
     */
    void StreamEND(int channel);

    /**
     *
     * Pauses a stream channel.
     *
     * @mangled StreamPause__6CSoundFi
     * @address 0x18C630
     * @size 0x10
     */
    void StreamPause(int channel);

    /**
     *
     * Resumes a paused stream channel.
     *
     * @mangled StreamRePlay__6CSoundFi
     * @address 0x18C640
     * @size 0x10
     */
    void StreamRePlay(int channel);

    /**
     *
     * Sets the left and right volumes of a stream channel.
     *
     * @mangled StreamSetVol__6CSoundFiii
     * @address 0x18C650
     * @size 0x10
     */
    void StreamSetVol(int channel, int left, int right);

    /**
     *
     * Gives the state of a stream channel, without its low twelve bits.
     *
     * @mangled StreamGetState__6CSoundFi
     * @address 0x18C660
     * @size 0x30
     */
    int StreamGetState(int channel);

    /**
     *
     * Gives the output level of a stream channel, the left level in the
     * high half and the right in the low half.
     *
     * @mangled StreamGetLevel__6CSoundFi
     * @address 0x18C690
     * @size 0x10
     */
    int StreamGetLevel(int channel);

    /**
     *
     * Readies an opened stream channel, setting it up for its file's mono
     * or stereo layout, and starts it buffering.
     *
     * @mangled StreamStandBy__6CSoundFi
     * @address 0x18C6A0
     * @size 0xB0
     */
    void StreamStandBy(int channel);

    /**
     *
     * Gives the state of the transfer of a bank body into the sound
     * processor on one channel; zero while it runs.
     *
     * @mangled TransBdState__6CSoundFi
     * @address 0x18C750
     * @size 0x20
     */
    int TransBdState(int channel);

    /**
     *
     * Gives the state of the last request sent to the EZBGM server;
     * non-zero while it runs.
     *
     * @mangled StreamOpenState__6CSoundFv
     * @address 0x28ED80
     * @size 0x10
     */
    int StreamOpenState();
};

STATIC_ASSERT(sizeof(CSound) == 1);

/**
 *
 * Starts the sound processor and sets the reverberation mode and depth of
 * both of its cores.
 *
 * @mangled set_spu__Fiiii
 * @address 0x189FF0
 * @size 0x150
 */
void set_spu(int mode0, int mode1, int depth0, int depth1);

/**
 *
 * Copies a bank header into newly allocated IOP memory and sends the bank
 * body into the sound processor through the staging area, filling gBank.
 *
 * @mangled TransHdBd__Fiiii
 * @address 0x18A140
 * @size 0x2D0
 */
int TransHdBd(int hd, int hd_size, int bd, int bd_size);

/**
 *
 * IOP memory bank bodies are staged in before they are sent into the sound
 * processor.
 *
 * @address 0x37D0F8
 * @size 0x4
 */
extern void *iop_bd_addr;

extern CSound CSnd;
