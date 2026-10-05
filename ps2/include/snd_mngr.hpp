#pragma once

#include "common.h"

/**
 * @file
 * Declares the sound manager: the sound ports that sound banks are loaded
 * into, the sound effects, sequences and sound-effect sequences played from
 * them, master and port volumes, reverb, the audio stream, the listener
 * position used for positional sound, and the manager of looping sound
 * effects that must be requested every frame to keep sounding.
 *
 * A sound ID, as returned by sndLoadSound, holds the game port number in its
 * top eight bits and the bank number in the next eight; sndCreateID places a
 * sound effect number in its low sixteen bits.
 */

class mgCMemory;
class sndCSeSeqData;

/**
 * Game sound ports that sound banks are loaded into, as named by the game's
 * port volume settings.
 */
enum sndPORT {
    SND_PORT_BGM = 0,     /**< Background music; its sequences are played on the voice-capable driver port. */
    SND_PORT_OB = 1,      /**< Sound effects of map objects. */
    SND_PORT_BASE = 3,    /**< Sound effects of the base map. */
    SND_PORT_EVENT = 4,   /**< Sound effects and sequences of events. */
    SND_PORT_ENEMY = 5,   /**< Sound effects of monsters. */
    SND_PORT_SYSTEM = 6,  /**< System sound effects, loaded once at boot. */
    SND_PORT_MENU = 8,    /**< Sound effects of menus. */
    SND_PORT_BGM2 = 11,   /**< Second background music port, sharing the first's sequence handling. */
    SND_PORT_NUM = 16,    /**< Number of game sound ports. */
};

/**
 * How a sound effect entry of a bank's sound effect table is played.
 */
enum sndSE_TYPE {
    SND_SE_TYPE_NONE = 0,  /**< No sound; the entry names a file that is not in the bank. */
    SND_SE_TYPE_KEYON = 1, /**< A program and key played directly on the sound driver. */
    SND_SE_TYPE_SQ = 2,    /**< A sequence played by the sound driver. */
    SND_SE_TYPE_SESEQ = 3, /**< A sound-effect sequence converted from a MIDI file. */
};

/**
 * Centre value for sound-effect pitch bend.
 */
// clang-format off
enum sndSE_CENTER {
    SND_SE_PITCH_CENTER = 0x2000, /**< Centre pitch bend. */
};
// clang-format on

/**
 * Playback state of the sequence of a sound port.
 */
enum sndSQ_STATE {
    SND_SQ_STATE_STOP = 0,       /**< No sequence is playing. */
    SND_SQ_STATE_PLAY = 1,       /**< The sequence is playing. */
    SND_SQ_STATE_PAUSE = 2,      /**< The sequence was paused through its sound effect. */
    SND_SQ_STATE_PORT_PAUSE = 3, /**< The sequence was paused through its port. */
};

/**
 * Reverb types, as named in a bank's sound effect and volume tables.
 */
enum sndREVERB_TYPE {
    SND_REVERB_OFF = 0,      /**< No reverb. */
    SND_REVERB_ROOM = 1,     /**< "Room". */
    SND_REVERB_STUDIO_A = 2, /**< "Studio_A". */
    SND_REVERB_STUDIO_B = 3, /**< "Studio_B". */
    SND_REVERB_STUDIO_C = 4, /**< "Studio_C". */
    SND_REVERB_HALL = 5,     /**< "Hall". */
    SND_REVERB_SPACE = 6,    /**< "Space". */
    SND_REVERB_ECHO = 7,     /**< "Echo". */
    SND_REVERB_DELAY = 8,    /**< "Delay". */
    SND_REVERB_PIPE = 9,     /**< "Pipe". */
    SND_REVERB_MAX = 10,     /**< "Max". */
};

/**
 * Looping sound effect kept sounding by a CLoopSeMngr for as long as it is
 * requested again within a number of frames.
 */
struct SND_LOOP_SE_SEQ {
    int se_id;     /**< Sound ID with the sound effect number, or -1 when the entry is free. */
    s16 keep_time; /**< Frames the sound keeps playing after the last request. */
    s16 count;     /**< Frames since the last request; 0 until the sound has been started. */
    s16 voice;     /**< Voice number the sound effect plays with. */
    s16 unk_a;
    float vol;     /**< Volume scale of the sound effect's default volume, or below 0 for the default. */
    float pan;     /**< Pan from -1 (left) to 1 (right). */

    /**
     * Creates the entry as free.
     *
     * @mangled __ct__15SND_LOOP_SE_SEQFv
     * @address 0x18DAE0
     * @size 0x20
     */
    SND_LOOP_SE_SEQ();
};
STATIC_ASSERT(sizeof(SND_LOOP_SE_SEQ) == 0x14);

/**
 * Manager of looping sound effects that keep playing while they are
 * requested every frame, and stop by themselves once requests cease.
 */
class CLoopSeMngr {
public:
    int loop_se_num;          /**< Number of entries of loop_se. */
    SND_LOOP_SE_SEQ *loop_se; /**< Looping sound effect entries, or NULL before Create. */

    /**
     * Creates the manager with no entries.
     */
    CLoopSeMngr() { Initialize(); }

    /**
     * Allocates a number of looping sound effect entries from the stack
     * region of a memory manager, returning non-zero on success.
     *
     * @mangled Create__11CLoopSeMngrFiP9mgCMemory
     * @address 0x18DA20
     * @size 0xC0
     */
    int Create(int num, mgCMemory *memory);

    /**
     * Forgets the entries without freeing them.
     *
     * @mangled Initialize__11CLoopSeMngrFv
     * @address 0x18DB00
     * @size 0x10
     */
    void Initialize();

    /**
     * Marks every entry as free without stopping its sound.
     *
     * @mangled Clear__11CLoopSeMngrFv
     * @address 0x18DB10
     * @size 0x50
     */
    void Clear();

    /**
     * Finds the entry playing a sound with a voice, setting found to 1, or
     * else a free entry with found 0; returns NULL when neither exists.
     *
     * @mangled GetLoopSe__11CLoopSeMngrFPiUii
     * @address 0x18DB60
     * @size 0xF0
     */
    SND_LOOP_SE_SEQ *GetLoopSe(int *found, unsigned int se_id, int voice);

    /**
     * Requests a looping sound effect at its default volume and the middle
     * pan for this frame, returning non-zero when an entry was available.
     *
     * @mangled SeLoopPlayStop__11CLoopSeMngrFUiiii
     * @address 0x18DC50
     * @size 0x20
     */
    int SeLoopPlayStop(unsigned int snd_id, int se_no, int keep_time, int voice);

    /**
     * Requests a looping sound effect with a volume scale and pan for this
     * frame, starting it when it is not already playing and keeping it
     * playing for keep_time frames, returning non-zero when an entry was
     * available.
     *
     * @mangled SeLoopPlayStop__11CLoopSeMngrFUiiiffi
     * @address 0x18DC70
     * @size 0xD0
     */
    int SeLoopPlayStop(unsigned int snd_id, int se_no, int keep_time, float vol, float pan, int voice);

    /**
     * Starts newly requested sounds, updates the volume and pan of the
     * others, and stops those not requested within their keep time.
     *
     * @mangled Step__11CLoopSeMngrFv
     * @address 0x18DD40
     * @size 0x170
     */
    void Step();

    /**
     * Stops every playing looping sound effect and frees its entry.
     *
     * @mangled AllSeStop__11CLoopSeMngrFv
     * @address 0x18DEB0
     * @size 0xB0
     */
    void AllSeStop();
};
STATIC_ASSERT(sizeof(CLoopSeMngr) == 0x8);

/**
 * Entry of a bank's sound effect table, describing how one sound effect
 * number is played.
 */
struct sndSeInfo {
    int unk_0;
    s8 type;    /**< How the sound effect is played, a sndSE_TYPE. */
    s8 prog;    /**< Program, sequence number or sound-effect sequence number, by type. */
    s8 key;     /**< Key number a key-on sound effect is played at. */
    s8 unk_7;
    s8 def_vol; /**< Default volume, 0 to 127. */
    s8 unk_9[3];

    /**
     * Creates the entry with no sound.
     *
     * @mangled __ct__9sndSeInfoFv
     * @address 0x191520
     * @size 0x10
     */
    sndSeInfo();
};
STATIC_ASSERT(sizeof(sndSeInfo) == 0xC);

/**
 * Sound bank loaded into a port: its sound effect table, the names of its
 * driver sequences and its sound-effect sequences.
 */
class sndBankInfo {
public:
    int unk_0;
    int se_num;               /**< Number of entries of se. */
    sndSeInfo *se;            /**< Sound effect table, indexed by sound effect number. */
    int sq_num;               /**< Number of entries of sq_name. */
    char **sq_name;           /**< Names of the driver sequences, indexed by sequence number. */
    int seseq_num;            /**< Number of entries of seseq. */
    sndCSeSeqData *seseq;     /**< Sound-effect sequences, indexed by sound-effect sequence number. */

    /**
     * Creates the bank empty.
     */
    sndBankInfo() {
        unk_0 = 0;
        se_num = 0;
        se = NULL;
        sq_num = 0;
        sq_name = NULL;
        seseq_num = 0;
        seseq = NULL;
    }

    /**
     * Finds how a sound effect named in the sound effect table is played:
     * "KeyOn" or a name without an extension is a key-on sound effect, a
     * sequence or sound-effect sequence name is that type with its number
     * stored to index, and any other file name gives no sound.
     *
     * @mangled SearchSeq__11sndBankInfoFPcPi
     * @address 0x190F50
     * @size 0x160
     */
    int SearchSeq(char *name, int *index);
};
STATIC_ASSERT(sizeof(sndBankInfo) == 0x1C);

/**
 * Sound-effect sequence started on a port, recording which sound effect it
 * plays so that it can be found again.
 */
struct sndPortSeSeq {
    s16 seseq_no; /**< Index of the sound-effect sequence player, or -1 when the entry is free. */
    s16 se_no;    /**< Sound effect number that started it. */
    s8 bank;      /**< Bank number of the sound effect. */
    s8 voice;     /**< Voice number it was started with. */
    s8 unk_6;
    s8 unk_7;

    /**
     * Creates the entry as free.
     */
    sndPortSeSeq() { seseq_no = -1; }
};
STATIC_ASSERT(sizeof(sndPortSeSeq) == 0x8);

/**
 * Game sound port: the sound driver ports it plays on, the banks loaded into
 * it, the state of its driver sequence and its sound-effect sequences.
 */
class sndPortInfo {
public:
    int port;                 /**< Sound driver port sound effects play on, or -1. */
    int sq_port;              /**< Sound driver port sequences play on, or -1. */
    int bank_num;             /**< Number of banks loaded. */
    sndBankInfo bank[16];     /**< Loaded banks. */
    u8 unk_1cc[0x40];
    int sq_no;                /**< Number of the driver sequence last started, or -1. */
    int sq_state;             /**< Playback state of the driver sequence, a sndSQ_STATE. */
    int sq_vol;               /**< Volume of the driver sequence, 0 to 127. */
    int sq_se_no;             /**< Sound effect number that started the driver sequence, or -1. */
    sndPortSeSeq seseq[16];   /**< Sound-effect sequences playing on the port. */

    /**
     * Creates the port with no driver ports and no banks.
     *
     * @mangled __ct__11sndPortInfoFv
     * @address 0x191C30
     * @size 0x1C0
     */
    sndPortInfo() {
        int i;

        port = -1;
        sq_port = -1;
        bank_num = 0;
        sq_no = -1;
        sq_state = SND_SQ_STATE_STOP;
        sq_vol = 0;
        sq_se_no = -1;
        for (i = 0; i < 16; i++) {
            seseq[i].seseq_no = -1;
        }
        for (i = 0; i < 16; i++) {
            bank[i].unk_0 = 0;
            bank[i].se_num = 0;
            bank[i].se = NULL;
            bank[i].sq_num = 0;
            bank[i].sq_name = NULL;
            bank[i].seseq_num = 0;
            bank[i].seseq = NULL;
        }
    }

    /**
     * Builds a bank's sound effect table from its text file, allocating it
     * from the stack region of a memory manager, and applies any reverb
     * line to the port's core.
     *
     * @mangled LoadSeInfoTxt__11sndPortInfoFiPciP9mgCMemory
     * @address 0x1910B0
     * @size 0x470
     */
    void LoadSeInfoTxt(int bank_no, char *text, int size, mgCMemory *memory);

    /**
     * Reads the default volumes of a bank's sound effects from its volume
     * text file, and applies any reverb line to the port's core.
     *
     * @mangled LoadVolInfoTxt__11sndPortInfoFiPci
     * @address 0x191530
     * @size 0x1F0
     */
    void LoadVolInfoTxt(int bank_no, char *text, int size);
};
STATIC_ASSERT(sizeof(sndPortInfo) == 0x29C);

/**
 * Returns the reverb depth last set on a core, or 0 for an invalid core.
 *
 * @mangled sndGetReverbDepth__Fi
 * @address 0x18DF60
 * @size 0x40
 */
int sndGetReverbDepth(int core);

/**
 * Combines the port and bank of a sound ID with a sound effect number.
 *
 * @mangled sndCreateID__FUii
 * @address 0x18DFA0
 * @size 0x20
 */
unsigned int sndCreateID(unsigned int snd_id, int se_no);

/**
 * Returns the sound effect number held in a sound ID.
 *
 * @mangled sndGetSeNo__FUi
 * @address 0x18DFC0
 * @size 0x10
 */
int sndGetSeNo(unsigned int snd_id);

/**
 * Starts the sound driver and its semaphore, sets both master volumes to
 * full and resets every port.
 *
 * @mangled sndInitMngr__Fv
 * @address 0x18E1A0
 * @size 0xE0
 */
void sndInitMngr();

/**
 * Waits on the semaphore guarding the sound driver.
 *
 * @mangled sndWaitSema__Fv
 * @address 0x18E280
 * @size 0x30
 */
void sndWaitSema();

/**
 * Releases the semaphore guarding the sound driver.
 *
 * @mangled sndSignalSema__Fv
 * @address 0x18E2B0
 * @size 0x30
 */
void sndSignalSema();

/**
 * Stops everything a port plays and forgets its driver ports, banks and
 * sound-effect sequences.
 *
 * @mangled sndInitPort__Fi
 * @address 0x18E2E0
 * @size 0x1B0
 */
void sndInitPort(int port_no);

/**
 * Frees every sound-effect sequence entry of a port without stopping it.
 *
 * @mangled sndInitSeSeq__Fi
 * @address 0x18E490
 * @size 0x70
 */
void sndInitSeSeq(int port_no);

/**
 * Sets the reverb type and depth of a core.
 *
 * @mangled sndSetReverb__Fiii
 * @address 0x18E500
 * @size 0x90
 */
void sndSetReverb(int core, int type, int depth);

/**
 * Stops a voice.
 *
 * @mangled sndStopVoice__Fi
 * @address 0x18E590
 * @size 0x60
 */
void sndStopVoice(int voice);

/**
 * Sets the master volume of a core, from 0 to 1, cancelling any fade.
 *
 * @mangled sndSetMasterVol__Fif
 * @address 0x18E790
 * @size 0x90
 */
void sndSetMasterVol(int core, float vol);

/**
 * Returns the master volume of a core, or the target of its fade.
 *
 * @mangled sndGetMasterVol__Fi
 * @address 0x18E820
 * @size 0x40
 */
float sndGetMasterVol(int core);

/**
 * Fades the master volume of a core to a target over a number of frames,
 * starting from a given volume, or from the current one when start is
 * below 0.
 *
 * @mangled sndMasterVolFadeInOut__Fiiff
 * @address 0x18E860
 * @size 0x170
 */
void sndMasterVolFadeInOut(int core, int frames, float target, float start);

/**
 * Sets the volume of a port, from 0 to 1.
 *
 * @mangled sndSetPortVol__Fif
 * @address 0x18E9D0
 * @size 0x110
 */
void sndSetPortVol(int port_no, float vol);

/**
 * Returns the volume last set on a port.
 *
 * @mangled sndGetPortVol__Fi
 * @address 0x18EAE0
 * @size 0x40
 */
float sndGetPortVol(int port_no);

/**
 * Returns non-zero once the sound driver has finished transferring wave
 * data.
 *
 * @mangled sndTransBdState__Fv
 * @address 0x18EB20
 * @size 0x10
 */
int sndTransBdState();

/**
 * Waits, one frame at a time, until the sound driver has finished
 * transferring wave data.
 *
 * @mangled sndWaitTransBd__Fv
 * @address 0x18EB30
 * @size 0x60
 */
void sndWaitTransBd();

/**
 * Advances every port's sound-effect sequences by a number of frames,
 * steps the master volume fades and flushes the sound driver.
 *
 * @mangled sndStep__Ff
 * @address 0x18EC00
 * @size 0xD0
 */
void sndStep(float frames);

/**
 * Steps the sound driver once per frame, under the semaphore.
 *
 * @mangled sndFlush__Fv
 * @address 0x18ECD0
 * @size 0x30
 */
void sndFlush();

/**
 * Stops the sound effects and sound-effect sequences of a port, or of
 * every non-music port when port_no is below 0.
 *
 * @mangled sndSeAllStop__Fi
 * @address 0x18ED70
 * @size 0xD0
 */
void sndSeAllStop(int port_no);

/**
 * Returns the default volume of a sound effect, or 0 when it does not exist.
 *
 * @mangled sndGetSeDefVol__FUii
 * @address 0x18EE40
 * @size 0x30
 */
int sndGetSeDefVol(unsigned int snd_id, int se_no);

/**
 * Loads a sound pack into a port as a new bank: its wave data, driver
 * sequences, sound-effect sequences, sound effect table and volume table,
 * returning the bank's sound ID, or -1 on failure.
 *
 * @mangled sndLoadSound__FiPUiP9mgCMemory
 * @address 0x18EFE0
 * @size 0x4D0
 */
unsigned int sndLoadSound(int port_no, unsigned int *pack, mgCMemory *memory);

/**
 * Releases a port's sound driver ports and resets the port.
 *
 * @mangled sndDeletePort__Fi
 * @address 0x18F4E0
 * @size 0x90
 */
void sndDeletePort(int port_no);

/**
 * Plays a sound effect at its default volume and the middle pan.
 *
 * @mangled sndSePlay__FUiii
 * @address 0x18F610
 * @size 0x20
 */
void sndSePlay(unsigned int snd_id, int se_no, int voice);

/**
 * Plays a sound effect at a volume and the middle pan.
 *
 * @mangled sndSePlayV__FUiiii
 * @address 0x18F630
 * @size 0x20
 */
void sndSePlayV(unsigned int snd_id, int se_no, int vol, int voice);

/**
 * Plays a sound effect at a volume and pan.
 *
 * @mangled sndSePlayVP__FUiiiii
 * @address 0x18F650
 * @size 0x20
 */
void sndSePlayVP(unsigned int snd_id, int se_no, int vol, int pan, int voice);

/**
 * Plays a sound effect at a scale of its default volume and a pan from -1
 * to 1.
 *
 * @mangled sndSePlayVPf__FUiiffi
 * @address 0x18F670
 * @size 0xD0
 */
void sndSePlayVPf(unsigned int snd_id, int se_no, float vol, float pan, int voice);

/**
 * Plays a sound effect at a scale of its default volume and the middle pan.
 *
 * @mangled sndSePlayVf__FUiifi
 * @address 0x18F740
 * @size 0x80
 */
void sndSePlayVf(unsigned int snd_id, int se_no, float vol, int voice);

/**
 * Pauses the driver sequence a sound effect plays, if it is playing.
 *
 * @mangled sndSePause__FUii
 * @address 0x18F7C0
 * @size 0x100
 */
void sndSePause(unsigned int snd_id, int se_no);

/**
 * Returns the sndSQ_STATE of the port's driver sequence when a sound effect
 * is a sequence, or -1.
 *
 * @mangled sndGetSeStatus__FUii
 * @address 0x18F8C0
 * @size 0x100
 */
int sndGetSeStatus(unsigned int snd_id, int se_no);

/**
 * Pauses a port's driver sequence, if it is playing.
 *
 * @mangled sndPortSqPause__Fi
 * @address 0x18F9C0
 * @size 0x50
 */
void sndPortSqPause(int port_no);

/**
 * Resumes a port's driver sequence paused by sndPortSqPause.
 *
 * @mangled sndPortSqReplay__Fi
 * @address 0x18FA10
 * @size 0x60
 */
void sndPortSqReplay(int port_no);

/**
 * Returns non-zero when a sound effect exists in its bank's table.
 *
 * @mangled sndSeCheck__FUii
 * @address 0x18FA70
 * @size 0xE0
 */
int sndSeCheck(unsigned int snd_id, int se_no);

/**
 * Plays a sound effect by its type: a key-on sound, the port's driver
 * sequence, or a sound-effect sequence. A volume below 0 uses the sound
 * effect's default volume.
 *
 * @mangled sndSePlaySeID__FUiiiiiii
 * @address 0x18FB50
 * @size 0x290
 */
void sndSePlaySeID(unsigned int snd_id, int se_no, int velocity, int vol, int pan, int pitch, int voice);

/**
 * Stops a sound effect by its type.
 *
 * @mangled sndSeStop__FUiii
 * @address 0x18FDE0
 * @size 0x1C0
 */
void sndSeStop(unsigned int snd_id, int se_no, int voice);

/**
 * Sets the volume of a playing sound effect by its type; a volume below 0
 * uses its default volume.
 *
 * @mangled sndSetSeVol__FUiiii
 * @address 0x18FFA0
 * @size 0x210
 */
void sndSetSeVol(unsigned int snd_id, int se_no, int vol, int voice);

/**
 * Sets the pan of a playing key-on sound effect.
 *
 * @mangled sndSetSePan__FUiiii
 * @address 0x1901B0
 * @size 0xE0
 */
void sndSetSePan(unsigned int snd_id, int se_no, int pan, int voice);

/**
 * Sets the volume of a playing sound effect to a scale of its default
 * volume.
 *
 * @mangled sndSetSeVolf__FUiifi
 * @address 0x190290
 * @size 0x80
 */
void sndSetSeVolf(unsigned int snd_id, int se_no, float vol, int voice);

/**
 * Sets the pan of a playing key-on sound effect from -1 to 1.
 *
 * @mangled sndSetSePanf__FUiifi
 * @address 0x190310
 * @size 0x80
 */
void sndSetSePanf(unsigned int snd_id, int se_no, float pan, int voice);

/**
 * Sets the pitch of a playing key-on sound effect.
 *
 * @mangled sndSetSePitch__FUiiii
 * @address 0x190390
 * @size 0xE0
 */
void sndSetSePitch(unsigned int snd_id, int se_no, int pitch, int voice);

/**
 * Sets the listener position and facing direction used for positional
 * sound.
 *
 * @mangled sndSetMicPos__FPfPf
 * @address 0x190470
 * @size 0x30
 */
void sndSetMicPos(float *pos, float *dir);

/**
 * Works out the volume scale and pan of a sound at a position, from its
 * distance to the listener between a full-volume and a silent distance, and
 * its direction to the listener's side.
 *
 * @mangled sndGetVolPan__FPfPfPfff
 * @address 0x1904A0
 * @size 0x1D0
 */
void sndGetVolPan(float *vol, float *pan, float *pos, float near_dist, float far_dist);

/**
 * Works out the volume scale and pan of a sound along a line, from the point
 * of the line nearest the listener.
 *
 * @mangled sndGetVolPan__FPfPfPfPfff
 * @address 0x190670
 * @size 0x80
 */
void sndGetVolPan(float *vol, float *pan, float *start, float *end, float near_dist, float far_dist);

/**
 * Clamps a volume to 0 to 127.
 *
 * @mangled sndVolLimit__Fi
 * @address 0x1906F0
 * @size 0x30
 */
int sndVolLimit(int vol);

/**
 * Plays a program and key on the port and bank of a sound ID.
 *
 * @mangled sndSePlayPrKr__FUiiiiiiii
 * @address 0x190720
 * @size 0x70
 */
void sndSePlayPrKr(unsigned int snd_id, int prog, int key, int velocity, int vol, int pan, int pitch, int voice);

/**
 * Stops a program and key on the port and bank of a sound ID.
 *
 * @mangled sndSeStopPrKr__FUiiii
 * @address 0x190790
 * @size 0x50
 */
void sndSeStopPrKr(unsigned int snd_id, int prog, int key, int voice);

/**
 * Sets the volume of a program and key on the port and bank of a sound ID.
 *
 * @mangled sndSetSeVolPrKr__FUiiiii
 * @address 0x1907E0
 * @size 0x60
 */
void sndSetSeVolPrKr(unsigned int snd_id, int prog, int key, int vol, int voice);

/**
 * Sets the pan of a program and key on the port and bank of a sound ID.
 *
 * @mangled sndSetSePanPrKr__FUiiiii
 * @address 0x190840
 * @size 0x60
 */
void sndSetSePanPrKr(unsigned int snd_id, int prog, int key, int pan, int voice);

/**
 * Sets the pitch of a program and key on the port and bank of a sound ID.
 *
 * @mangled sndSetSePitchPrKr__FUiiiii
 * @address 0x1908A0
 * @size 0x60
 */
void sndSetSePitchPrKr(unsigned int snd_id, int prog, int key, int pitch, int voice);

/**
 * Plays a program and key on a sound driver port and bank; a velocity or
 * volume below 0 is full.
 *
 * @mangled sndSePlayPBPrKr__Fiiiiiiiii
 * @address 0x190900
 * @size 0xD0
 */
void sndSePlayPBPrKr(int port, int bank, int prog, int key, int velocity, int vol, int pan, int pitch, int voice);

/**
 * Stops a program and key on a sound driver port and bank.
 *
 * @mangled sndSeStopPBPrKr__Fiiiii
 * @address 0x1909D0
 * @size 0x80
 */
void sndSeStopPBPrKr(int port, int bank, int prog, int key, int voice);

/**
 * Sets the volume of a program and key on a sound driver port and bank; a
 * volume below 0 is full.
 *
 * @mangled sndSetSeVolPBPrKr__Fiiiiii
 * @address 0x190A50
 * @size 0xA0
 */
void sndSetSeVolPBPrKr(int port, int bank, int prog, int key, int vol, int voice);

/**
 * Sets the pan of a program and key on a sound driver port and bank.
 *
 * @mangled sndSetSePanPBPrKr__Fiiiiii
 * @address 0x190AF0
 * @size 0x90
 */
void sndSetSePanPBPrKr(int port, int bank, int prog, int key, int pan, int voice);

/**
 * Sets the pitch of a program and key on a sound driver port and bank.
 *
 * @mangled sndSetSePitchPBPrKr__Fiiiiii
 * @address 0x190B80
 * @size 0x90
 */
void sndSetSePitchPBPrKr(int port, int bank, int prog, int key, int pitch, int voice);

/**
 * Starts a sequence on a sound driver port at a volume.
 *
 * @mangled sndSqPlay__Fiii
 * @address 0x190C10
 * @size 0x60
 */
void sndSqPlay(int port, int sq_no, int vol);

/**
 * Silences and stops the sequence of a sound driver port, stopping the
 * first voice as well on a music port.
 *
 * @mangled sndSqStop__Fii
 * @address 0x190C70
 * @size 0x90
 */
void sndSqStop(int port, int sq_no);

/**
 * Sets the volume of the sequence of a sound driver port.
 *
 * @mangled sndSetSqVol__Fiii
 * @address 0x190D00
 * @size 0x50
 */
void sndSetSqVol(int port, int sq_no, int vol);

/**
 * Resumes the sequence of a sound driver port.
 *
 * @mangled sndSqRePlay__Fii
 * @address 0x190D50
 * @size 0x40
 */
void sndSqRePlay(int port, int sq_no);

/**
 * Stops every sound-effect sequence playing on a port's sound driver port.
 *
 * @mangled sndStopSeSeq__Fi
 * @address 0x191720
 * @size 0x80
 */
void sndStopSeSeq(int port_no);

/**
 * Opens a file as the audio stream.
 *
 * @mangled sndStreamOpenFast__FPc
 * @address 0x191910
 * @size 0x40
 */
void sndStreamOpenFast(char *name);

/**
 * Returns the state of opening the audio stream.
 *
 * @mangled sndStreamOpenState__Fv
 * @address 0x191950
 * @size 0x40
 */
int sndStreamOpenState();

/**
 * Prepares the opened audio stream for playback.
 *
 * @mangled sndStreamStandBy__Fv
 * @address 0x191990
 * @size 0x30
 */
void sndStreamStandBy();

/**
 * Sets the left and right volumes of the audio stream, from 0 to 1.
 *
 * @mangled sndStreamSetVol__Fff
 * @address 0x1919C0
 * @size 0xF0
 */
void sndStreamSetVol(float left, float right);

/**
 * Starts playing the audio stream.
 *
 * @mangled sndStreamPlay__Fv
 * @address 0x191AB0
 * @size 0x30
 */
void sndStreamPlay();

/**
 * Pauses the audio stream.
 *
 * @mangled sndStreamPause__Fv
 * @address 0x191AE0
 * @size 0x30
 */
void sndStreamPause();

/**
 * Resumes the paused audio stream.
 *
 * @mangled sndStreamRePlay__Fv
 * @address 0x191B10
 * @size 0x30
 */
void sndStreamRePlay();

/**
 * Returns the playback state of the audio stream.
 *
 * @mangled sndStreamGetState__Fv
 * @address 0x191B40
 * @size 0x40
 */
int sndStreamGetState();

/**
 * Closes the audio stream.
 *
 * @mangled sndStreamClose__Fv
 * @address 0x191B80
 * @size 0x30
 */
void sndStreamClose();
