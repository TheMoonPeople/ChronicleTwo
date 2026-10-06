#pragma once

#include "common.h"
#include <libcdvd.h>
#include <libmpeg.h>

/**
 * @file
 * Declares the full-screen movie player: a PSS stream read from disc,
 * demultiplexed into MPEG-2 video decoded by the IPU and PCM audio streamed
 * to the SPU, with decoded frames shown by vblank-driven DMA.
 */

class mgCMemory;

/**
 * Progress of the video decoder thread, kept in VideoDec::state.
 */
enum VideoDecState {
    VIDEO_DEC_STATE_NORMAL = 0, /**< Decoding is under way. */
    VIDEO_DEC_STATE_FLUSH = 2,  /**< The remaining bit stream has been flushed to the decoder. */
    VIDEO_DEC_STATE_END = 3,    /**< Every picture has been decoded and shown. */
};

/**
 * Playback state of the movie's audio stream, kept in AudioDec::state.
 */
enum AudioDecState {
    AUDIO_DEC_STATE_HEADER = 0, /**< Collecting the stream header. */
    AUDIO_DEC_STATE_PRESET = 1, /**< Header complete; buffering audio before playback. */
    AUDIO_DEC_STATE_PLAY = 2,   /**< The SPU is playing the IOP ring buffer. */
    AUDIO_DEC_STATE_PAUSE = 3,  /**< Playback is paused and the input muted. */
};

/**
 * Display state of one decoded frame, kept in VoTag::status.
 */
enum VoTagStatus {
    VO_TAG_STATUS_FREE = 0,  /**< The frame has been shown on both vblanks and may be reused. */
    VO_TAG_STATUS_FIRST = 1, /**< The frame has been sent for its first vblank. */
    VO_TAG_STATUS_READY = 2, /**< The frame is decoded and waiting to be shown. */
};

/**
 * Presentation and decoding times of the video data at one position of the
 * bit-stream buffer.
 */
struct TimeStamp {
    long pts; /**< Presentation time stamp, or -1 when unset. */
    long dts; /**< Decoding time stamp, or -1 when unset. */
    int pos;  /**< Byte offset of the timed data within the bit-stream buffer. */
    int len;  /**< Length in bytes of the timed data. */
};
STATIC_ASSERT(sizeof(TimeStamp) == 0x18);

/**
 * One quadword of a DMA chain, viewed as a whole or as two doublewords.
 */
union QWORD {
    u_long128 q; /**< Whole quadword. */
    u_long l[2]; /**< Lower and upper doublewords; the lower holds a DMA tag. */
};
STATIC_ASSERT(sizeof(QWORD) == 0x10);

/**
 * Ring of 2048-byte bit-stream blocks fed to the IPU through a DMA chain,
 * with the time stamps of the video data it holds.
 */
struct ViBuf {
    u_long128 *data;  /**< Bit-stream blocks. */
    u_long128 *tag;   /**< DMA chain with one tag per block plus a closing tag, accessed uncached. */
    int n;            /**< Number of blocks. */
    int dma_start;    /**< First block queued for DMA. */
    int dma_n;        /**< Number of blocks queued for DMA. */
    int read_bytes;   /**< Bytes written past the queued blocks and not yet queued. */
    int buff_size;    /**< Size of the block area in bytes. */
    sceIpuDmaEnv env; /**< IPU and DMA state saved while transfers are stopped. */
    int sema;         /**< Semaphore guarding the ring. */
    int is_active;    /**< Non-zero while the IPU input DMA may run. */
    long total_bytes; /**< Bytes written since the ring was created. */
    TimeStamp *ts;    /**< Ring of time stamps. */
    int n_ts;         /**< Capacity of the time-stamp ring. */
    int count_ts;     /**< Number of time stamps held. */
    int wt_ts;        /**< Next time-stamp slot to write. */
};
STATIC_ASSERT(sizeof(ViBuf) == 0x60);

/**
 * MPEG video decoder: the library decoder, its bit-stream ring and the
 * interrupt handlers that display its output.
 */
struct VideoDec {
    sceMpeg mpeg;         /**< Library decoder state. */
    ViBuf vibuf;          /**< Bit-stream ring feeding the IPU. */
    volatile u_int state; /**< Decoder progress, a VideoDecState. */
    int unk_ac;
    int hid_endimage;     /**< Handler id of the GIF DMA end-of-transfer handler. */
    int hid_vblank;       /**< Handler id of the vblank interrupt handler. */
};
STATIC_ASSERT(sizeof(VideoDec) == 0xB8);

/**
 * Pixels of one decoded 512x448 frame, in 32-bit macroblock order.
 */
struct VoData {
    u_int v[512 * 448]; /**< Decoded pixels. */
};
STATIC_ASSERT(sizeof(VoData) == 0xE0000);

/**
 * Display record of one decoded frame: its state and the GIF DMA chains
 * that upload it on each of the two vblanks it is shown for.
 */
struct VoTag {
    volatile int status; /**< Display state, a VoTagStatus. */
    int unk_4[15];
    u_int *v[2];         /**< Upload chain for the first and second vblank. */
};
STATIC_ASSERT(sizeof(VoTag) == 0x48);

/**
 * Ring of decoded frames between the decoder thread and the vblank handler.
 */
struct VoBuf {
    VoData *data;       /**< Frame pixel buffers, accessed uncached. */
    VoTag *tag;         /**< Display records, cleared on creation. */
    VoTag *ring_tag;    /**< Display records indexed by ring position. */
    volatile int write; /**< Next frame slot the decoder fills. */
    volatile int count; /**< Number of frames decoded and not yet shown. */
    int size;           /**< Number of frame slots. */
};
STATIC_ASSERT(sizeof(VoBuf) == 0x18);

/**
 * Movie file opened either through CD streaming or through the host file
 * system.
 */
struct StrFile {
    sceCdlFILE fp; /**< Disc location of the file, when streamed from CD. */
    int unk_20;
    int fd;        /**< File descriptor, when read through the file system. */
    int is_on_cd;  /**< Non-zero when the file is streamed from CD. */
    int size;      /**< File size in bytes. */
    void *iop_buf; /**< IOP memory used as the CD streaming buffer. */
};
STATIC_ASSERT(sizeof(StrFile) == 0x34);

/**
 * Ring buffer of PSS data read from the file and waiting to be
 * demultiplexed.
 */
struct ReadBuf {
    u_char data[0x50000]; /**< Ring storage. */
    int put;              /**< Next byte to write. */
    int count;            /**< Bytes held. */
    int size;             /**< Capacity of the ring in bytes. */
};

/**
 * PCM audio streamer: an EE ring buffer of demultiplexed audio sent to an
 * IOP ring buffer that the SPU plays from.
 */
struct AudioDec {
    int state;            /**< Playback state, an AudioDecState. */
    u_char hdr[0x28];     /**< Audio stream header collected before the body. */
    int hdr_count;        /**< Bytes of the header collected. */
    u_char *data;         /**< EE ring buffer of audio body data. */
    int put;              /**< Next byte to write in the EE ring. */
    int count;            /**< Bytes held in the EE ring. */
    int size;             /**< Capacity of the EE ring in bytes. */
    int total_bytes;      /**< Body bytes received since the last reset. */
    int iop_buff;         /**< IOP address of the SPU's ring buffer. */
    int iop_buff_size;    /**< Size of the IOP ring buffer in bytes. */
    int iop_last_pos;     /**< Next byte of the IOP ring to write. */
    int iop_pause_pos;    /**< Playback position within the IOP ring when paused. */
    int total_bytes_sent; /**< Bytes sent to the IOP since the last reset. */
    int iop_zero;         /**< IOP address of a block of silence played while paused. */
};
STATIC_ASSERT(sizeof(AudioDec) == 0x5C);

/**
 * Movie player: owns the work buffers, the thread stacks and the threads
 * that read, decode and display one movie.
 */
class CMovie {
public:
    int unk_0;
    VoData *vo_data;             /**< Decoded frame buffers. */
    u_long128 *vi_buf_data;      /**< Bit-stream blocks of the video ring. */
    u_long128 *vi_buf_tag;       /**< DMA chain of the video ring. */
    u_char *mpeg_work;           /**< Work area of the MPEG decoder. */
    u_int *image_tag[2][2];      /**< Frame upload chains, by vblank then frame slot. */
    u_char unk_24[0x1C];
    VoTag vo_tag[2];             /**< Display records of the two frame slots. */
    u_char unk_d0[0x30];
    u_char def_stack[0x800];     /**< Stack of the idle thread. */
    u_char video_stack[0x4000];  /**< Stack of the video decoding thread. */
    u_char step_stack[0x4000];   /**< Stack of the reading and demultiplexing thread. */
    u_char audio_buf[0x18000];   /**< EE ring buffer of audio body data. */
    TimeStamp time_stamp[0x200]; /**< Time-stamp ring of the video bit stream. */
    bool is_playing;             /**< Whether the threads and interrupt handlers are running. */
    int video_thread;            /**< Thread id of the video decoding thread. */
    int def_thread;              /**< Thread id of the idle thread. */
    int step_thread;             /**< Thread id of the reading and demultiplexing thread. */
    u_char unk_23910[0x30];

    /**
     * Allocates the work buffers from six memory managers, opens the movie
     * file, sets up the decoders and pre-reads the start of the stream.
     *
     * @mangled Load__6CMovieFPcPP9mgCMemoryiibbb
     * @address 0x29C470
     * @size 0x480
     */
    void Load(char *name, mgCMemory **memory, int width, int height, bool with_audio, bool loop,
              bool init_sound);

    /**
     * Allocates every work buffer from one memory manager, loads the movie
     * and initialises the IOP sound library.
     *
     * @mangled Load__6CMovieFPcP9mgCMemoryiibb
     * @address 0x29C8F0
     * @size 0x60
     */
    void Load(char *name, mgCMemory *memory, int width, int height, bool with_audio, bool loop);

    /**
     * Allocates every work buffer from one memory manager and loads the
     * movie.
     *
     * @mangled Load__6CMovieFPcP9mgCMemoryiibbb
     * @address 0x29C950
     * @size 0x50
     */
    void Load(char *name, mgCMemory *memory, int width, int height, bool with_audio, bool loop,
              bool init_sound);

    /**
     * Starts the movie's threads and interrupt handlers, drawing frames into
     * the named texture.
     *
     * @mangled Play__6CMovieFPc
     * @address 0x29C9A0
     * @size 0x200
     */
    void Play(char *texture_name);

    /**
     * Yields the CPU to the movie's threads several times while playing.
     *
     * @mangled SwitchThread__6CMovieFv
     * @address 0x29CBA0
     * @size 0x60
     */
    void SwitchThread();

    /**
     * Stops the movie's threads and handlers and releases the decoders and
     * the file.
     *
     * @mangled Term__6CMovieFv
     * @address 0x29CC00
     * @size 0x150
     */
    void Term();

    /**
     * Returns non-zero once the whole stream has been read and decoded.
     *
     * @mangled EndCheck__6CMovieFv
     * @address 0x29CD50
     * @size 0x40
     */
    int EndCheck();

    /**
     * Returns whether enough frames and audio are buffered for display to
     * have begun.
     *
     * @mangled IsStarted__6CMovieFv
     * @address 0x29CD90
     * @size 0x10
     */
    int IsStarted();

    /**
     * Returns the size in bytes of the decoded frame buffers.
     *
     * @mangled GetVoBufDataSize__6CMovieFv
     * @address 0x29CDA0
     * @size 0x10
     */
    int GetVoBufDataSize();

    /**
     * Returns the size in bytes of the video bit-stream blocks.
     *
     * @mangled GetViBufDataSize__6CMovieFv
     * @address 0x29CDB0
     * @size 0x10
     */
    int GetViBufDataSize();

    /**
     * Returns the size in bytes of the video bit-stream DMA chain.
     *
     * @mangled GetViBufTagSize__6CMovieFv
     * @address 0x29CDC0
     * @size 0x10
     */
    int GetViBufTagSize();

    /**
     * Returns the size in bytes of the MPEG decoder's work area for a
     * picture size.
     *
     * @mangled GetMpegWorkSize__6CMovieFii
     * @address 0x29CDD0
     * @size 0x30
     */
    int GetMpegWorkSize(int width, int height);

    /**
     * Returns the size in bytes of the PSS read buffer.
     *
     * @mangled GetReadBufSize__6CMovieFv
     * @address 0x29CE00
     * @size 0x10
     */
    int GetReadBufSize();

    /**
     * Returns the size in bytes of one frame upload chain for a picture
     * size.
     *
     * @mangled GetTagProgSize__6CMovieFii
     * @address 0x29CE10
     * @size 0x60
     */
    int GetTagProgSize(int width, int height);

    /**
     * Creates the MPEG decoder, registers its callbacks and creates its
     * bit-stream ring.
     *
     * @mangled videoDecCreate__6CMovieFP8VideoDecPUciP1P1iP9TimeStampi
     * @address 0x29CE70
     * @size 0x100
     */
    int videoDecCreate(VideoDec *vd, u_char *mpeg_work, int mpeg_work_size, u_long128 *data,
                       u_long128 *tag, int n, TimeStamp *ts, int n_ts);

    /**
     * Registers the demultiplexer callback for one elementary stream.
     *
     * @mangled videoDecSetStream__6CMovieFP8VideoDeciiPFP7sceMpegP13sceMpegCbDataPv_iPv
     * @address 0x29CF70
     * @size 0x40
     */
    int videoDecSetStream(VideoDec *vd, int str_type, int ch,
                          int (*callback)(sceMpeg *, sceMpegCbData *, void *), void *data);

    /**
     * Stops the bit-stream DMA and destroys the MPEG decoder.
     *
     * @mangled videoDecDelete__6CMovieFP8VideoDec
     * @address 0x29CFB0
     * @size 0x40
     */
    int videoDecDelete(VideoDec *vd);

    /**
     * Appends an end code to the bit stream and pads it to a whole block so
     * the decoder can finish.
     *
     * @mangled videoDecFlush__6CMovieFP8VideoDec
     * @address 0x29CFF0
     * @size 0xD0
     */
    int videoDecFlush(VideoDec *vd);
};
STATIC_ASSERT(sizeof(CMovie) == 0x23940);

int mpegError(sceMpeg *mpeg, sceMpegCbDataError *error, void *user);
int mpegNodata(sceMpeg *mpeg, sceMpegCbData *data, void *user);
int mpegStopDMA(sceMpeg *mpeg, sceMpegCbData *data, void *user);
int mpegRestartDMA(sceMpeg *mpeg, sceMpegCbData *data, void *user);
int mpegTS(sceMpeg *mpeg, sceMpegCbDataTimeStamp *data, void *user);
int pcmCallback(sceMpeg *mpeg, sceMpegCbDataStr *str, void *user);
int videoCallback(sceMpeg *mpeg, sceMpegCbDataStr *str, void *user);
int decBs0(VideoDec *dec);
void videoDecMain(void *arg);
int defMain(void *);
void stepMain(void *arg);
int vblankHandler(int irq);
int handler_endimage(int irq);
int videoDecGetState(VideoDec *dec);
u32 videoDecSetState(VideoDec *dec, u32 state);
int switchThread(void);
int viBufCreate(ViBuf *buf, u_long128 *data, u_long128 *tags, int sectors, TimeStamp *ts, int ts_count);
int viBufReset(ViBuf *buf);
int viBufAddDMA(ViBuf *buf);
int viBufStopDMA(ViBuf *buf);
int viBufRestartDMA(ViBuf *buf);
int viBufModifyPts(ViBuf *buf, TimeStamp *range);
int viBufPutTs(ViBuf *buf, TimeStamp *ts);
int viBufGetTs(ViBuf *buf, TimeStamp *ts);
int viBufDelete(ViBuf *buf);
void videoDecBeginPut(VideoDec *dec, u8 **area1, int *size1, u8 **area2, int *size2);
void videoDecEndPut(VideoDec *dec, int count);
int isAudioOK(void);
int audioDecSendToIOP(AudioDec *dec);
int videoDecPutTs(VideoDec *dec, long pts, long dts, u8 *area, int size);
void viBufFlush(ViBuf *buf);
VoTag *voBufGetTag(VoBuf *buf);
void voBufReset(VoBuf *buf);
void voBufDecCount(VoBuf *buf);
void voBufIncCount(VoBuf *buf);
u8 *voBufGetData(VoBuf *buf);
void audioDecBeginPut(AudioDec *dec, u8 **area1, int *size1, u8 **area2, int *size2);
void audioDecEndPut(AudioDec *dec, int count);
void audioDecResume(AudioDec *dec);
void audioDecPause(AudioDec *dec);
int cpy2area(u8 *dst1, int size1, u8 *dst2, int size2, u8 *src1, int len1, u8 *src2, int len2);
int sendToIOP(int iop_addr, u8 *src, int size);
void changeMasterVolume(u32 volume);
void changeInputVolume(u32 volume);
void setD4_CHCR(u32 chcr);
int audioDecDelete(AudioDec *dec);
void audioDecReset(AudioDec *dec);
int strFileClose(StrFile *file);
void startDisplay(int field);
void iopGetArea(int *addr1, int *size1, int *addr2, int *size2, AudioDec *dec, int wanted);
int sendToIOP2area(int dest1, int size1, int dest2, int size2, u8 *src1, int len1, u8 *src2,
                   int len2);
void audioDecStart(AudioDec *dec);
void strFileSeek(StrFile *file);
int strFileRead(StrFile *file, void *buf, int size);
int readBufBeginPut(ReadBuf *buf, u8 **out);
int readBufEndPut(ReadBuf *buf, int count);
int readBufBeginGet(ReadBuf *buf, u8 **out);
int readBufEndGet(ReadBuf *buf, int count);
void setImageTag(u32 *tag, void *data, int a, int width, int height);
void voBufCreate(VoBuf *buf, VoData *data, VoTag *tags, int count);
void readBufCreate(ReadBuf *buf);
int audioDecCreate(AudioDec *dec, u8 *ring_buf, int ring_size, int iop_size);
int strFileOpen(StrFile *file, char *path);

void viBufBeginPut(ViBuf *buf, u8 **area1, int *size1, u8 **area2, int *size2);

void viBufEndPut(ViBuf *buf, int count);

int audioDecIsPreset(AudioDec *dec);
