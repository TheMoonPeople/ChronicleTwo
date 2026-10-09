#include "common.h"

#include <eekernel.h>
#include <libcdvd.h>
#include <libdma.h>
#include <libgraph.h>
#include <libpkt.h>
#include <libsdr.h>
#include <sifdev.h>
#include <sifdma.h>
#include <sifrpc.h>

#include <cctype>
#include <cstdio>
#include <cstring>

#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "movie.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"

/**
 *
 * Whether playback has started.
 *
 */
static u8 isStarted;

/**
 *
 * Movie bytes remaining to demultiplex.
 *
 */
static int writerest;

/**
 *
 * Whether the second frame DMA transfer has completed.
 *
 */
static volatile u8 isFrameEnd;

/**
 *
 * Number of vblanks without a ready movie frame.
 *
 */
static u32 frd;

/**
 *
 * Whether the vblank handler advances frame display.
 *
 */
static volatile u8 isCountVblank;

/**
 *
 * Parity selecting the movie frame DMA chain.
 *
 */
static volatile int Cb;

/**
 *
 * Width of the decoded movie image.
 *
 */
static int MpegW;

/**
 *
 * Height of the decoded movie image.
 *
 */
static int MpegH;

/**
 *
 * MPEG decoder and compressed-video DMA state.
 *
 */
static VideoDec videoDec;

/**
 *
 * Movie stream file and its disc staging buffer.
 *
 */
static StrFile infile;

/**
 *
 * Texture name used to build the movie image transfer tags.
 *
 */
static char *TexName;

/**
 *
 * Compressed movie input ring buffer.
 *
 */
static ReadBuf *readBuf;

/**
 *
 * Movie bytes remaining to read from the file.
 *
 */
static int readrest;

/**
 *
 * Whether the movie file restarts at its end.
 *
 */
static u8 Loop;

/**
 *
 * Whether the movie includes an audio stream.
 *
 */
static u8 isWithAudio;

/**
 *
 * State reported by the movie streaming thread.
 *
 */
static volatile int stepMainStatus;

/**
 *
 * Exit request consumed by the movie streaming thread.
 *
 */
static int stepMainExitFlag;

/**
 *
 * Ring of decoded frames waiting for display.
 *
 */
static VoBuf voBuf;

/**
 *
 * PCM audio buffering and IOP transfer state.
 *
 */
static AudioDec audioDec;

/**
 *
 * Silence block transferred to the movie audio decoder.
 *
 */
static u8 _0_buf[2048];

/**
 *
 * Memory pools used by movie playback.
 *
 */
struct MoviePools {
    mgCMemory *pool[6]; /**< Movie playback pools. */
};

/**
 *
 * Whether movie streaming from the disc is initialized.
 *
 */
static u8 isStrFileInit;

static int voBufIsFull(VoBuf *buf);

extern u_long128 at_1276__2;

extern u_long128 at_1287__2;

// Code (.text)
static inline void *DmaAddr(void *addr) {
    return (void *) ((u32) addr & 0xFFFFFFF);
}

static inline void *UncAddr(void *addr) {
    return (void *) (((u32) addr & 0xFFFFFFF) | 0x20000000);
}
void CMovie::Load(char *name, mgCMemory **memory, int width, int height, bool with_audio, bool loop,
                  bool init_sound) {
    int i;
    u8 *area __attribute__((aligned(64)));
    int read_size;

    isWithAudio = with_audio;
    isStrFileInit = 0;
    isStarted = 0;
    is_playing = 0;
    isCountVblank = 0;
    isFrameEnd = 0;
    MpegW = width;
    MpegH = height;
    Loop = loop;
    Cb = 0;
    vo_data = (VoData *) memory[0]->stAlloc64(GetVoBufDataSize() / 16);
    vi_buf_data = memory[1]->stAlloc64(GetViBufDataSize() / 16);
    vi_buf_tag = memory[2]->stAlloc64(GetViBufTagSize() / 16);
    mpeg_work = (u_char *) memory[3]->stAlloc64(GetMpegWorkSize(MpegW, MpegH) / 16);
    readBuf = (ReadBuf *) memory[4]->stAlloc64(GetReadBufSize() / 16);
    for (i = 0; i < 2; i++) {
        image_tag[0][i] = (u_int *) memory[5]->stAlloc64(GetTagProgSize(MpegW, MpegH) / 16);
        image_tag[1][i] = (u_int *) memory[5]->stAlloc64(GetTagProgSize(MpegW, MpegH) / 16);
    }
    printf("voBufData: %d\n", GetVoBufDataSize() / 16);
    printf("viBufData: %d\n", GetViBufDataSize() / 16);
    printf("viBufTag: %d\n", GetViBufTagSize() / 16);
    printf("mpegWork: %d\n", GetMpegWorkSize(MpegW, MpegH) / 16);
    printf("readBuf: %d\n", GetReadBufSize() / 16);
    printf("tagProgData: %d\n", GetTagProgSize(MpegW, MpegH) / 16 * 2);
    *(int *) 0x1000E000 |= 3;
    *(int *) 0x1000E010 = 4;
    readBufCreate(readBuf);
    sceMpegInit();
    videoDecCreate(&videoDec, mpeg_work, GetMpegWorkSize(MpegW, MpegH), vi_buf_data, vi_buf_tag,
                   0x100, time_stamp, 0x200);
    if (init_sound) {
        sceSdRemoteInit();
        sceSdRemote(1, 0x8000, 0);
        sceSdRemote(1, 0x8070, 0xA, 0x80);
    }
    audioDecCreate(&audioDec, audio_buf, 0x18000, 0xC000);
    videoDecSetStream(&videoDec, 0, 0, (int (*)(sceMpeg *, sceMpegCbData *, void *)) videoCallback,
                      readBuf);
    if (isWithAudio) {
        videoDecSetStream(&videoDec, 2, 0,
                          (int (*)(sceMpeg *, sceMpegCbData *, void *)) pcmCallback, readBuf);
    }
    vo_tag[0].v[0] = image_tag[0][0];
    vo_tag[0].v[1] = image_tag[1][0];
    vo_tag[1].v[0] = image_tag[0][1];
    vo_tag[1].v[1] = image_tag[1][1];
    voBufCreate(&voBuf, (VoData *) UncAddr(vo_data), vo_tag, 2);
    while (strFileOpen(&infile, name) == 0) {
    }
    writerest = infile.size;
    readrest = infile.size;
    readBufBeginPut(readBuf, &area);
    read_size = strFileRead(&infile, area, 0x50000);
    readBufEndPut(readBuf, read_size);
    readrest -= read_size;
}
void CMovie::Load(char *name, mgCMemory *memory, int width, int height, bool with_audio, bool loop) {
    MoviePools pools = {};
    pools.pool[0] = memory;
    pools.pool[1] = memory;
    pools.pool[2] = memory;
    pools.pool[3] = memory;
    pools.pool[4] = memory;
    pools.pool[5] = memory;
    Load(name, pools.pool, width, height, with_audio, loop, true);
}

void CMovie::Load(char *name, mgCMemory *memory, int width, int height, bool with_audio, bool loop, bool init_sound) {
    MoviePools pools = {};
    pools.pool[0] = memory;
    pools.pool[1] = memory;
    pools.pool[2] = memory;
    pools.pool[3] = memory;
    pools.pool[4] = memory;
    pools.pool[5] = memory;
    Load(name, pools.pool, width, height, with_audio, loop, init_sound);
}

void CMovie::Play(char *path) {
    ThreadParam param;

    if (is_playing == 0) {
        TexName = path;
        param.entry = defMain;
        param.stack = def_stack;
        param.stackSize = 0x800;
        param.initPriority = 10;
        param.gpReg = &_gp;
        param.option = 0;
        def_thread = CreateThread(&param);
        StartThread(def_thread, 0);
        param.entry = videoDecMain;
        param.stack = video_stack;
        param.stackSize = 0x4000;
        param.initPriority = 10;
        param.gpReg = &_gp;
        param.option = 0;
        video_thread = CreateThread(&param);
        StartThread(video_thread, &videoDec);
        stepMainExitFlag = 0;
        param.entry = stepMain;
        param.stack = step_stack;
        param.stackSize = 0x4000;
        param.initPriority = 10;
        param.gpReg = &_gp;
        param.option = 0;
        step_thread = CreateThread(&param);
        StartThread(step_thread, 0);
        videoDec.hid_vblank = AddIntcHandler(2, vblankHandler, 0);
        EnableIntc(2);
        videoDec.hid_endimage = AddDmacHandler(2, handler_endimage, 0);
        EnableDmac(2);
        is_playing = 1;
    }
}

void CMovie::SwitchThread() {
    int turn;

    turn = 0;

    if (is_playing != 0) {
        do {
            switchThread();
            turn += 1;
        } while (turn < 4);
    }
}

void CMovie::Term() {
    if (is_playing != 0) {
        videoDecFlush(&videoDec);
        switchThread();
        stepMainExitFlag = 1;

        while (stepMainStatus == 0) {
            switchThread();
        }

        TerminateThread(step_thread);
        DeleteThread(step_thread);
        TerminateThread(video_thread);
        DeleteThread(video_thread);
        TerminateThread(def_thread);
        DeleteThread(def_thread);
        DisableDmac(2);
        RemoveDmacHandler(2, videoDec.hid_endimage);
        RemoveIntcHandler(2, videoDec.hid_vblank);
        is_playing = 0;
    }

    videoDecDelete(&videoDec);
    audioDecReset(&audioDec);
    audioDecDelete(&audioDec);
    strFileClose(&infile);
}

int CMovie::EndCheck() {
    if (writerest >= 5) {
        return videoDecGetState(&videoDec) == 3 ? 1 : 0;
    }

    return 1;
}

int CMovie::IsStarted() {
    return isStarted;
}

int CMovie::GetVoBufDataSize() { return 0x1C0000; }

int CMovie::GetViBufDataSize() { return 0x80000; }

s32 CMovie::GetViBufTagSize() {
    return 0x1010;
}

s32 CMovie::GetMpegWorkSize(s32 width, s32 height) {
    s32 half_work_units;
    s32 pixel_work_units;

    pixel_work_units = width * height * 9;
    half_work_units = pixel_work_units >> 1;

    if (pixel_work_units < 0) {
        half_work_units = (s32) (pixel_work_units + 1) >> 1;
    }

    return half_work_units + 0x1768;
}

int CMovie::GetReadBufSize() { return 0x50050; }

s32 CMovie::GetTagProgSize(s32 width, s32 height) {
    s32 macroblocks;
    s32 tag_pages;
    s32 tag_bytes_rounded;
    s32 macroblock_columns;
    s32 macroblock_groups;

    macroblock_columns = width >> 4;

    if (width < 0) {
        macroblock_columns = (s32) (width + 0xF) >> 4;
    }

    macroblocks = macroblock_columns * height;
    macroblock_groups = macroblocks >> 4;

    if (macroblocks < 0) {
        macroblock_groups = (s32) (macroblocks + 0xF) >> 4;
    }

    tag_bytes_rounded = (((macroblock_groups * 6) + 0x6E) * 4) + 0x3F;
    tag_pages = tag_bytes_rounded >> 6;

    if (tag_bytes_rounded < 0) {
        tag_pages = (s32) (tag_bytes_rounded + 0x3F) >> 6;
    }

    return tag_pages << 8;
}

int CMovie::videoDecCreate(VideoDec *dec, u8 *mpeg_buffer, int mpeg_size, u_long128 *data, u_long128 *tags,
                           int sectors, TimeStamp *ts, int ts_count) {
    sceMpegCreate(&dec->mpeg, mpeg_buffer, mpeg_size);
    sceMpegAddCallback(&dec->mpeg, sceMpegCbError, (sceMpegCallback) mpegError, 0);
    sceMpegAddCallback(&dec->mpeg, sceMpegCbNodata, mpegNodata, 0);
    sceMpegAddCallback(&dec->mpeg, sceMpegCbStopDMA, mpegStopDMA, 0);
    sceMpegAddCallback(&dec->mpeg, sceMpegCbRestartDMA, mpegRestartDMA, 0);
    sceMpegAddCallback(&dec->mpeg, sceMpegCbTimeStamp, (sceMpegCallback) mpegTS, 0);
    dec->state = 0;
    viBufCreate(&dec->vibuf, data, tags, sectors, ts, ts_count);
    return 1;
}

int CMovie::videoDecSetStream(VideoDec *dec, int id, int param, sceMpegCallback callback, void *user) {
    sceMpegAddStrCallback(&dec->mpeg, (sceMpegStrType) (id & 0xFF), param, callback, user);
    return 1;
}

int CMovie::videoDecDelete(VideoDec *dec) {
    viBufDelete(&dec->vibuf);
    sceMpegDelete(&dec->mpeg);
    return 1;
}

int CMovie::videoDecFlush(VideoDec *dec) {
    u8 *area1;
    u8 *area2;
    int size1;
    int size2;
    videoDecBeginPut(dec, &area1, &size1, &area2, &size2);

    if (size1 + size2 < 4) {
        return 0;
    }

    u8 *uncached1 = (u8 *) UncAddr(area1);
    u8 *uncached2 = (u8 *) UncAddr(area2);
    u8  end_code[4] = {0x00, 0x00, 0x01, 0xB7};
    videoDecEndPut(&videoDec, cpy2area(uncached1, size1, uncached2, size2, end_code, 4, NULL, 0));
    viBufFlush(&dec->vibuf);

    if (dec->state == 0) {
        dec->state = 2;
    }

    return 1;
}

void defMain(void *) {
    for (;;) {
        switchThread();
    }
}

void videoDecMain(void *arg) {
    VideoDec *dec = static_cast<VideoDec *>(arg);

    viBufReset(&dec->vibuf);
    voBufReset(&voBuf);
    decBs0(dec);

    while (voBuf.count != 0) {
    }

    videoDecSetState(dec, 3);
}

void stepMain(void *arg) {
    struct {
        u8 *put;
        u8  gap[0x38];
    } areas;

    u8       *get_area;
    VideoDec *dec = &videoDec;
    ReadBuf  *ring = readBuf;
    StrFile  *file = &infile;

    static int cnt = 0; // Step counter retained from retail; never read.

    stepMainStatus = 0;

    do {
        if (Loop != 0 && readrest < 0x50001) {
            strFileSeek(file);
            readrest = infile.size;
        }

        int room = readBufBeginPut(ring, &areas.put);

        if (readrest > 0 && room >= 0x10000) {
            int bytes_read = strFileRead(file, areas.put, 0x10000);
            readBufEndPut(ring, bytes_read);
            readrest -= bytes_read;
        }

        switchThread();
        int available = readBufBeginGet(ring, &get_area);

        if (available > 0) {
            int consumed = sceMpegDemuxPssRing(&dec->mpeg, get_area, available, ring->data, ring->size);
            readBufEndGet(ring, consumed);
            writerest -= consumed;

            if (writerest <= 0) {
                writerest = infile.size;
            }
        }

        audioDecSendToIOP(&audioDec);

        if (isStarted == 0 && voBufIsFull(&voBuf) != 0 && isAudioOK() != 0) {
            startDisplay(1);

            if (isWithAudio != 0) {
                audioDecStart(&audioDec);
            }

            isStarted = 1;
        }
    } while (stepMainExitFlag == 0);

    stepMainStatus = 1;
}

s32 mpegError(sceMpeg *mpeg, sceMpegCbDataError *error, void *user) {
    return 1;
}

int mpegNodata(sceMpeg *mpeg, sceMpegCbData *data, void *user) {
    switchThread();
    viBufAddDMA(&videoDec.vibuf);
    return 1;
}

int mpegStopDMA(sceMpeg *mpeg, sceMpegCbData *data, void *user) {
    viBufStopDMA(&videoDec.vibuf);
    return 1;
}

int mpegRestartDMA(sceMpeg *mpeg, sceMpegCbData *data, void *user) {
    viBufRestartDMA(&videoDec.vibuf);
    return 1;
}

int mpegTS(sceMpeg *mpeg, sceMpegCbDataTimeStamp *data, void *user) {
    TimeStamp ts;
    viBufGetTs(&videoDec.vibuf, &ts);
    data->pts = ts.pts;
    data->dts = ts.dts;
    return 1;
}
int videoCallback(sceMpeg *mpeg, sceMpegCbDataStr *str, void *user) {
    ReadBuf *buf = (ReadBuf *)user;
    u8 *area1;
    u8 *area2;
    int size1;
    u_int second;
    int size2;
    u8 *src;
    u_int first;
    int copied;
    int result;
    u8 *end;
    u_int total;
    u8 *uncached1;
    u8 *uncached2;

    end = (u8 *)buf + buf->size;
    src = str->data;
    total = str->len;
    first = end - src;
    if (first > total) {
        first = total;
    }
    second = str->len - first;
    videoDecBeginPut(&videoDec, &area1, &size1, &area2, &size2);
    uncached1 = (u8 *)UncAddr(area1);
    uncached2 = (u8 *)UncAddr(area2);
    copied = cpy2area(uncached1, size1, uncached2, size2, src, first, (u8 *)buf, second);
    if (copied > 0 && videoDecPutTs(&videoDec, str->pts, str->dts, area1, copied) == 0) {
        printf("pts buffer overflow\n");
    }
    videoDecEndPut(&videoDec, copied);
    result = 0;
    if (copied > 0) {
        result = 1;
    }
    return result;
}
int pcmCallback(sceMpeg *mpeg, sceMpegCbDataStr *str, void *user) {
    u8 *area1;
    u8 *area2;
    int size1;
    int size2;
    u8 *src;
    int total;
    int first;
    int ring_size;
    u8 *ring_end;
    src = &str->data[4];
    ReadBuf *ring = static_cast<ReadBuf *>(user);
    ring_size = ring->size;
    ring_end = &ring->data[ring_size];

    if (src >= ring_end) {
        src -= ring_size;
    }

    first = ring_end - src;
    total = str->len - 4;
    first = (total < first) ? total : first;
    audioDecBeginPut(&audioDec, &area1, &size1, &area2, &size2);
    int copied = cpy2area(area1, size1, area2, size2, src, first, ring->data, total - first);
    audioDecEndPut(&audioDec, copied);
    int result = 0;

    if (copied > 0) {
        result = 1;
    }

    return result;
}

#pragma global_optimizer off
#ifdef NONMATCHING
int vblankHandler(int irq) {
    if (isCountVblank) {
        VoTag *tag = voBufGetTag(&voBuf);
        if (tag == NULL) {
            frd++;
        } else {
            if (Cb == 0 && tag->status == VO_TAG_STATUS_READY) {
                sceDmaSend(DmaCH2, tag->v[0]);
                tag->status = VO_TAG_STATUS_FIRST;
            } else if (Cb == 1 && tag->status == VO_TAG_STATUS_FIRST) {
                sceDmaSend(DmaCH2, tag->v[1]);
                tag->status = VO_TAG_STATUS_FREE;
                isFrameEnd = 1;
            }
            Cb ^= 1;
        }
    }
    EIntr();
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", vblankHandler__Fi);
#endif
#pragma global_optimizer reset
#ifdef NONMATCHING
int handler_endimage(int irq) {
    if (isFrameEnd) {
        voBufDecCount(&voBuf);
        isFrameEnd = 0;
    }
    EIntr();
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", handler_endimage__Fi);
#endif
void voBufCreate(VoBuf *buf, VoData *data, VoTag *tags, int count) {
    buf->data = data;
    buf->tag = tags;
    buf->ring_tag = tags;
    buf->size = count;
    buf->count = 0;
    buf->write = 0;

    for (int i = 0; i < count; i++) {
        buf->tag[i].status = 0;
    }
}

void voBufReset(VoBuf *buffer) {
    buffer->write = 0;
    buffer->count = 0;
}

static s32 voBufIsFull(VoBuf *buffer) {
    return buffer->count == buffer->size;
}

void voBufIncCount(VoBuf *buf) {
    DIntr();
    buf->ring_tag[buf->write].status = 2;
    buf->count++;
    buf->write = (buf->write + 1) % buf->size;
    EIntr();
}

u8 *voBufGetData(VoBuf *buf) {
    if (voBufIsFull(buf)) {
        return 0;
    }

    return reinterpret_cast<u8 *>(&buf->data[buf->write]);
}

static s32 voBufIsEmpty(VoBuf *buffer) {
    return buffer->count == 0;
}

VoTag *voBufGetTag(VoBuf *buf) {
    if (voBufIsEmpty(buf)) {
        return 0;
    }

    return &buf->ring_tag[(buf->write - buf->count + buf->size) % buf->size];
}

void voBufDecCount(VoBuf *buf) {
    if (buf->count > 0) {
        buf->count = buf->count - 1;
    }
}

static u32 getFIFOindex(ViBuf *buf, void *addr) {
    if (addr == (void *) (((u32) buf->tag + (buf->n + 1) * 0x10) & 0xFFFFFFF)) {
        return 0;
    }

    return ((u32) addr - (u32) buf->data) >> 11;
}

void setD3_CHCR(u32 chcr) {
    DIntr();
    int mask = *(int *) 0x1000F520;
    *(int *) 0x1000F590 = mask | 0x10000;
    *(u32 *) 0x1000B000 = chcr;
    *(int *) 0x1000F590 = *(int *) 0x1000F520 & 0xFFFEFFFF;
    EIntr(mask, 0x1000F590);
}

void setD4_CHCR(u32 chcr) {
    DIntr();
    int mask = *(int *) 0x1000F520;
    *(int *) 0x1000F590 = mask | 0x10000;
    *(u32 *) 0x1000B400 = chcr;
    *(int *) 0x1000F590 = *(int *) 0x1000F520 & 0xFFFEFFFF;
    EIntr(mask, 0x1000F590);
}

static void scTag2(QWORD *tag, void *addr, u32 id, u32 count) {
    tag->l[0] = ((u64) (u32) addr << 32) | ((u64) id << 28) | (u64) count;
}

int viBufCreate(ViBuf *buf, u_long128 *data, u_long128 *tags, int sectors, TimeStamp *ts, int ts_count) {
    buf->data = data;
    buf->tag = (u_long128 *) (((u32) tags & 0xFFFFFFF) | 0x20000000);
    buf->n = sectors;
    buf->buff_size = sectors << 11;
    buf->ts = ts;
    buf->n_ts = ts_count;
    SemaParam sema;
    sema.initCount = 1;
    sema.maxCount = 1;
    buf->sema = CreateSema(&sema);
    viBufReset(buf);
    buf->total_bytes = 0;
    return 1;
}

int viBufReset(ViBuf *buf) {
    int i;

    buf->dma_start = 0;
    buf->dma_n = 0;
    buf->read_bytes = 0;
    buf->is_active = 1;
    buf->count_ts = 0;
    buf->wt_ts = 0;

    for (i = 0; i < buf->n_ts; i++) {
        buf->ts[i].pts = -1;
        buf->ts[i].dts = -1;
        buf->ts[i].pos = 0;
        buf->ts[i].len = 0;
    }

    for (i = 0; i < buf->n; i++) {
        scTag2((QWORD *) (buf->tag + i), DmaAddr(&buf->data[i * 0x80]), 3, 0x80);
    }

    scTag2((QWORD *) (buf->tag + i), DmaAddr(buf->tag), 2, 0);
    *(int *) 0x1000B420 = 0;
    *(int *) 0x1000B410 = (u32) buf->data & 0xFFFFFFF;
    *(int *) 0x1000B430 = (u32) buf->tag & 0xFFFFFFF;
    setD4_CHCR(5U);
    return 1;
}

void viBufBeginPut(ViBuf *buf, u8 **area1, int *size1, u8 **area2, int *size2) {
    WaitSema(buf->sema);
    int write_pos;
    int queued = buf->read_bytes;
    int used = buf->dma_n;
    int size = buf->buff_size;
    int end_bytes = (buf->dma_start + used) << 11;
    write_pos = (end_bytes + queued) % size;
    int free = (((buf->n - 2) - used) << 11) - queued;

    if (size - write_pos >= free) {
        *area1 = &buf->data_bytes[write_pos];
        *size1 = free;
        *area2 = NULL;
        *size2 = 0;
    } else {
        *area1 = &buf->data_bytes[write_pos];
        *size1 = buf->buff_size - write_pos;
        *area2 = buf->data_bytes;
        *size2 = free - (buf->buff_size - write_pos);
    }

    SignalSema(buf->sema);
}

void viBufEndPut(ViBuf *buf, int count) {
    WaitSema(buf->sema);
    buf->read_bytes += count;
    buf->total_bytes += count;
    SignalSema(buf->sema);
}

int viBufAddDMA(ViBuf *buf) {
    int chained = 0;
    WaitSema(buf->sema);

    if (buf->is_active == 0) {
        printf("DMA ADD not active\n");
        return 0;
    }

    setD4_CHCR(5);
    u32 chcr = *(u32 *) 0x1000B400;
    u32 madr = *(u32 *) 0x1000B410;
    int fifo_index = getFIFOindex(buf, (void *) madr);
    int consumed = (fifo_index + buf->n - buf->dma_start) % buf->n;
    buf->dma_start = (buf->dma_start + consumed) % buf->n;
    buf->dma_n -= consumed;
    int ready;
    int tail = (buf->dma_start + buf->dma_n) % buf->n;
    ready = buf->read_bytes / 0x800;
    buf->read_bytes %= 0x800;

    if (ready > 0) {
        int last = (buf->dma_start + buf->dma_n - 1 + buf->n) % buf->n;
        scTag2((QWORD *) (buf->tag + last), (void *) ((u8 *) buf->data + last * 0x800), 3,
               0x80);
        chained = 1;
    }

    for (int i = 0; i < ready; i++) {
        scTag2((QWORD *) (buf->tag + tail), (void *) ((u8 *) buf->data + tail * 0x800),
               i == ready - 1 ? 0 : 3, 0x80);
        tail = (tail + 1) % buf->n;
    }

    buf->dma_n += ready;

    if (buf->dma_n != 0) {
        if (chained) {
            chcr = (chcr & 0xFFFFFFF) | 0x30000000;
        }

        setD4_CHCR(chcr | 0x100);
    }

    SignalSema(buf->sema);
    return 1;
}

#pragma optimization_level 4

int viBufStopDMA(ViBuf *buf) {
    WaitSema(buf->sema);
    buf->is_active = 0;
    setD4_CHCR(5);
    buf->env.d4madr = *(u32 *) 0x1000B410;
    buf->env.d4tadr = *(u32 *) 0x1000B430;
    buf->env.d4qwc = *(u32 *) 0x1000B420;
    buf->env.d4chcr = *(u32 *) 0x1000B400;
    volatile u32 *ipu_ctrl = (volatile u32 *) 0x10002010;

    while ((*ipu_ctrl & 0xF0) != 0) {
    }

    setD3_CHCR(0);
    buf->env.d3madr = *(u32 *) 0x1000B010;
    buf->env.d3qwc = *(u32 *) 0x1000B020;
    buf->env.d3chcr = *(u32 *) 0x1000B000;
    buf->env.ipubp = *(u32 *) 0x10002020;
    buf->env.ipuctrl = *(u32 *) 0x10002010;
    SignalSema(buf->sema);
    return 1;
}

#pragma optimization_level reset
#ifdef NONMATCHING
#pragma optimization_level 4
enum {
    MOVIE_ADDR_MASK = 0xFFFFFFF,
};
int viBufRestartDMA(ViBuf *buf) {
    int fifo_bits;
    volatile int *ipu_ctrl;
    u32 tag_addr;
    u32 madr;
    int mode;
    u32 qwc;
    u32 ipubp;
    int fifo_index;
    int size;
    int pos;
    u32 chcr;
    int fifo_quads;
    int index;

    ipubp = buf->env.ipubp;
    fifo_bits = ipubp & 0x7F;
    fifo_quads = ((ipubp >> 16) & 3) + ((ipubp >> 8) & 0xF);
    madr = buf->env.d4madr - fifo_quads * 0x10;
    qwc = buf->env.d4qwc + fifo_quads;
    tag_addr = buf->env.d4tadr;
    chcr = buf->env.d4chcr | 0x100;

    WaitSema(buf->sema);
    if (madr < (u32)buf->data) {
        size = buf->n << 11;
        qwc = (u32)((u8 *)buf->data - madr) >> 4;
        tag_addr = (u32)DmaAddr(buf->tag);
        madr += size;
        mode = (buf->env.d4madr == (u32)buf->data || buf->env.d4madr == (u32)buf->data + size) ? 0 : 3;
        chcr = (buf->env.d4chcr & MOVIE_ADDR_MASK) | (mode << 28) | 0x100;
        pos = (buf->n - buf->dma_start) % buf->n;
        if (0 > pos || pos >= buf->dma_n) {
            buf->dma_start = buf->n - 1;
            buf->dma_n++;
        }
    } else {
        index = getFIFOindex(buf, (void *)buf->env.d4madr);
        fifo_index = getFIFOindex(buf, (void *)madr);
        if (index != fifo_index) {
            tag_addr = (u32)(buf->tag + index) & MOVIE_ADDR_MASK;
            qwc = (u32)(((u8 *)buf->data + (index << 11)) - madr) >> 4;
            mode = ((u32)buf->data + (buf->env.d4madr - (u32)buf->data) % (buf->n << 11) ==
                (u32)buf->data + ((buf->dma_start + buf->dma_n) % buf->n << 11)) ? 0 : 3;
            chcr = (buf->env.d4chcr & MOVIE_ADDR_MASK) | (mode << 28) | 0x100;
            pos = (fifo_index + buf->n - buf->dma_start) % buf->n;
            if (0 > pos || pos >= buf->dma_n) {
                buf->dma_start = fifo_index;
                buf->dma_n++;
            }
        }
    }
    if (buf->env.d3madr != 0 && buf->env.d3qwc != 0) {
        *(u32 *)0x1000B010 = buf->env.d3madr;
        *(u32 *)0x1000B020 = buf->env.d3qwc;
        setD3_CHCR(buf->env.d3chcr | 0x100);
    }
    if (buf->dma_n != 0) {
        ipu_ctrl = (volatile int *)0x10002010;
        while (*ipu_ctrl < 0) {
        }
        *(int *)0x10002000 = fifo_bits;
        while (*(volatile int *)0x10002010 < 0) {
        }
    }
    *(u32 *)0x1000B410 = madr;
    *(u32 *)0x1000B430 = tag_addr;
    *(u32 *)0x1000B420 = qwc;
    if (buf->dma_n != 0) {
        setD4_CHCR(chcr);
    }
    *(int *)0x10002010 = buf->env.ipuctrl;
    buf->is_active = 1;
    SignalSema(buf->sema);
    return 1;
}
#pragma optimization_level reset
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", viBufRestartDMA__FP5ViBuf);
#endif
int viBufDelete(ViBuf *buf) {
    setD4_CHCR(5U);
    *(int *) 0x1000B420 = 0;
    *(int *) 0x1000B410 = 0;
    *(int *) 0x1000B430 = 0;
    DeleteSema(buf->sema);
    return 1;
}

void viBufFlush(ViBuf *buf) {
    WaitSema(buf->sema);
    buf->read_bytes = (buf->read_bytes + 0x7FF) / 0x800 * 0x800;
    SignalSema(buf->sema);
}

#pragma divbyzerocheck on
int viBufModifyPts(ViBuf *buf, TimeStamp *ts) {
    int remaining;
    int index;
    int size;
    int inside;
    TimeStamp *entry;
    int keep_going;
    int len;
    int ts_len;
    int ts_pos;
    int remaining_ts;
    int pos;

    index = (buf->n_ts + (buf->wt_ts - buf->count_ts)) % buf->n_ts;
    size = buf->n << 11;
    keep_going = 1;
    if (buf->count_ts > 0) {
        do {
            entry = &buf->ts[index];
            len = entry->len;
            if (len == 0) break;
            ts_len = ts->len;
            if (ts_len == 0) break;
            pos = entry->pos;
            ts_pos = ts->pos;
            inside = ts_len > (pos + size - ts_pos) % size;
            if (inside) {
                remaining = ts_pos + ts_len - pos;
                len = (remaining > len) ? len : remaining;
                entry->pos = (pos + len) % size;
                entry->len -= len;
                if (entry->len == 0) {
                    if (entry->pts >= 0) {
                        entry->pts = -1;
                        entry->dts = -1;
                        entry->pos = 0;
                        entry->len = 0;
                    }
                    remaining_ts = buf->count_ts - 1;
                    buf->count_ts = (remaining_ts < 0) ? 0 : remaining_ts;
                }
            } else {
                keep_going = 0;
            }
            index = (index + 1) % buf->n_ts;
        } while (keep_going);
    }
    return 0;
}
#pragma divbyzerocheck reset

int viBufPutTs(ViBuf *buf, TimeStamp *ts) {
    int had_room = 0;
    WaitSema(buf->sema);

    if (buf->count_ts < buf->n_ts) {
        viBufModifyPts(buf, ts);

        if (ts->pts >= 0 || ts->dts >= 0) {
            buf->ts[buf->wt_ts].pts = ts->pts;
            buf->ts[buf->wt_ts].dts = ts->dts;
            buf->ts[buf->wt_ts].pos = ts->pos;
            buf->ts[buf->wt_ts].len = ts->len;
            buf->count_ts++;
            buf->wt_ts = (buf->wt_ts + 1) % buf->n_ts;
        }

        had_room = 1;
    }

    SignalSema(buf->sema);
    return had_room;
}

static inline int TsWritePos(int pos) { return pos; }

int viBufGetTs(ViBuf *buf, TimeStamp *ts) {
    int index;
    int base;
    int fifo_bits;
    int consumed;
    TimeStamp *entry;
    int dma_addr;
    int inside;
    int found = 0;
    u32 ipu_ctrl;
    int count;
    u32 size;
    u32 read_pos;
    int i;

    ipu_ctrl = *(u32 *)0x10002020;
    fifo_bits = buf->env.ipubp & 0x7F;
    dma_addr = *(int *)0x1000B410 - ((((ipu_ctrl >> 16) & 3) + ((ipu_ctrl >> 8) & 0xF)) * 0x10);
    size = buf->n << 11;

    WaitSema(buf->sema);
    ts->pts = -1;
    ts->dts = -1;
    read_pos = (size + (dma_addr + (fifo_bits >> 3)) - (u32)buf->data) % size;
    count = buf->count_ts;
    base = TsWritePos(buf->wt_ts) - count;
    for (i = 0; i < count && found == 0; i++) {
        index = (i + (buf->n_ts + base)) % buf->n_ts;
        entry = &buf->ts[index];
        inside = entry->len > (int)(read_pos + size - entry->pos) % (int)size;
        if (inside) {
            ts->pts = entry->pts;
            ts->dts = buf->ts[index].dts;
            buf->ts[index].pts = -1;
            buf->ts[index].dts = -1;
            found = 1;
            consumed = (buf->count_ts <= 0) ? buf->count_ts : 1;
            buf->count_ts -= consumed;
        }
    }
    SignalSema(buf->sema);
    return 1;
}

int strFileOpen(StrFile *file, char *path) {
    char       full_path[0x100];
    char       device[0x4C];
    sceCdRMode cd_mode;
    int        leftover;
    char      *colon = index(path, ':');

    if (colon != NULL) {
        int device_len = colon - path;
        strncpy(device, path, device_len);
        device[device_len] = 0;

        if (strcmp(device, "cdrom0") == 0) {
            int i;
            int length = strlen(colon + 1);
            i = 0;
            file->is_on_cd = 1;

            while (i < length) {
                if (colon[i + 1] == '/') {
                    colon[i + 1] = '\\';
                }

                colon[i + 1] = toupper(colon[i + 1]);
                i++;
            }

            sprintf(full_path, "%s%s;1", colon + 1, leftover);
        } else {
            file->is_on_cd = 0;
            sprintf(full_path, "%s:%s", device, colon + 1);
        }
    } else {
        strcpy(device, "host0");
        file->is_on_cd = 0;
        sprintf(full_path, "%s:%s", device, path);
    }

    file->is_on_cd = 1;
    strcpy(full_path, "\\MOVIE\\");
    strcat(full_path, path);
    strcat(full_path, ";1");
    printf("file:[%d] %s\n", file->is_on_cd, full_path);

    if (file->is_on_cd != 0) {
        if (isStrFileInit == 0) {
            sceCdDiskReady(0);
            isStrFileInit = 1;
        }

        file->iop_buf = iop_bd_addr;
        sceCdStInit(0x50, 5, (void *) (((u32) file->iop_buf + 0xF) & ~0xF));

        if (sceCdSearchFile(&file->fp, full_path) == 0) {
            printf("Cannot open '%s'(sceCdSearchFile)\n", full_path);

            for (;;) {
            }
        }

        file->size = file->fp.size;
        cd_mode.trycount = 0;
        cd_mode.spindlctrl = 0;
        cd_mode.datapattern = 0;
        sceCdStStart(file->fp.lsn, &cd_mode);
    } else {
        file->fd = sceOpen(full_path, 1);

        if (file->fd < 0) {
            printf("Cannot open '%s'(sceOpen)\n", full_path);
            return 0;
        }

        file->size = sceLseek(file->fd, 0, 2);

        if (file->size < 0) {
            printf("sceLseek() fails (%s): %d\n", full_path, file->size);
            sceClose(file->fd);
            return 0;
        }

        if (sceLseek(file->fd, 0, 0) < 0) {
            printf("sceLseek() fails (%s)\n", full_path);
            sceClose(file->fd);
            return 0;
        }
    }

    return 1;
}

void strFileSeek(StrFile *file) {
    if (file->is_on_cd != 0) {
        sceCdStSeekF(file->fp.lsn);
        return;
    }

    sceLseek(file->fd, 0, 0);
}

int strFileClose(StrFile *file) {
    if (file->is_on_cd != 0) {
        sceCdStStop();
    } else {
        sceClose(file->fd);
    }

    return 1;
}

int strFileRead(StrFile *file, void *buf, int size) {
    u32 err;

    if (file->is_on_cd != 0) {
        return sceCdStRead(size >> 11, buf, 1, &err) << 11;
    }

    return sceRead(file->fd, buf, size);
}

void readBufCreate(ReadBuf *buf) {
    buf->count = 0;
    buf->put = 0;
    buf->size = 0x50000;
}

int readBufBeginPut(ReadBuf *buf, u8 **out) {
    int room = buf->size - buf->count;

    if (room != 0) {
        *out = buf->data + buf->put;
    }

    return room;
}

int readBufEndPut(ReadBuf *buf, int count) {
    int room = buf->size - buf->count;
    int stored = (count < room) ? count : room;
    buf->put = (buf->put + stored) % buf->size;
    buf->count += stored;
    return stored;
}

int readBufBeginGet(ReadBuf *buf, u8 **out) {
    if (buf->count != 0) {
        *out = buf->data + (buf->put - buf->count + buf->size) % buf->size;
    }

    return buf->count;
}

int readBufEndGet(ReadBuf *buf, int count) {
    int avail = buf->count;
    int taken = (count < avail) ? count : avail;
    buf->count -= taken;
    return taken;
}

int audioDecCreate(AudioDec *dec, u8 *ring_buf, int ring_size, int iop_size) {
    int iop_buf;
    int iop_stub;

    dec->state = 0;
    dec->hdr_count = 0;
    dec->data = ring_buf;
    dec->put = 0;
    dec->count = 0;
    dec->size = ring_size;
    dec->total_bytes = 0;
    dec->total_bytes_sent = 0;
    dec->iop_buff_size = iop_size;
    dec->iop_last_pos = 0;
    dec->iop_pause_pos = 0;
    dec->iop_buff = (int) sceSifAllocIopHeap(iop_size);
    iop_buf = dec->iop_buff;

    if (iop_buf < 0) {
        printf("Cannot allocate IOP memory\n", iop_buf);
        return 0;
    }

    printf("IOP memory 0x%08x(size:%d) is allocated\n", iop_buf, iop_size);
    dec->iop_zero = (int) sceSifAllocIopHeap(0x800);
    iop_stub = dec->iop_zero;

    if (iop_stub < 0) {
        printf("Cannot allocate IOP memory\n", iop_stub);
        return 0;
    }

    printf("IOP memory 0x%08x(size:%d) is allocated\n", iop_stub, 0x800);
    memset(&_0_buf, 0, 0x800);
    sendToIOP(dec->iop_zero, &_0_buf[0], 0x800);
    changeMasterVolume(0x3FFFU);
    sndSetMasterVol(0, 1.0f);
    sndSetMasterVol(1, 1.0f);
    return 1;
}

int audioDecDelete(AudioDec *dec) {
    sceSifFreeIopHeap((void *) dec->iop_buff);
    sceSifFreeIopHeap((void *) dec->iop_zero);
    return 1;
}

void audioDecPause(AudioDec *dec) {
    dec->state = 3;
    changeInputVolume(0);
    dec->iop_pause_pos = (sceSdRemote(1, 0x80E0, 1, 2, 0, 0) & 0xFFFFFF) - dec->iop_buff;
    sceSdRemote(1, 0x80D0, 1, 0, dec->iop_zero, 0x4000, 0x800);
}

void audioDecResume(AudioDec *dec) {
    changeInputVolume(0x7FFF);
    int size = dec->iop_buff_size;
    int base = dec->iop_buff;
    sceSdRemote(1, 0x80E0, 1, 0x13, base, size / 0x400 * 0x400, base + dec->iop_pause_pos);
    dec->state = 2;
}

void audioDecStart(AudioDec *dec) {
    audioDecResume(dec);
}

void audioDecReset(AudioDec *dec) {
    audioDecPause(dec);
    dec->state = 0;
    dec->hdr_count = 0;
    dec->put = 0;
    dec->count = 0;
    dec->total_bytes = 0;
    dec->total_bytes_sent = 0;
    dec->iop_last_pos = 0;
    dec->iop_pause_pos = 0;
}

s32 audioDecIsPreset(AudioDec *decoder) {
    return decoder->total_bytes_sent >= decoder->iop_buff_size;
}

int audioDecSendToIOP(AudioDec *dec) {
    int iop_addr1;
    int iop_addr2;
    int iop_size1;
    int iop_size2;
    int sent = 0;

    switch (dec->state) {
        case 0:
            return 0;
        case 1:
            iop_addr1 = dec->iop_buff + dec->total_bytes_sent % dec->iop_buff_size;
            iop_size1 = dec->iop_buff_size - dec->total_bytes_sent;
            iop_size2 = 0;
            iop_addr2 = 0;
            break;
        case 2:
            iopGetArea(&iop_addr1, &iop_size1, &iop_addr2, &iop_size2, dec,
                       (sceSdRemote(1, 0x8100, 1) & 0xFFFFFF) - dec->iop_buff);
            break;
        case 3:
            return 0;
    }

    int ring_size = dec->size;
    u8 *read_pos = &dec->data[(ring_size + (dec->put - dec->count)) % ring_size];
    int used = dec->count;
    u8 *ring = dec->data;
    int blocks = used / 0x400;
    int whole = blocks * 0x400;
    int first = &ring[ring_size] - read_pos;

    if (whole < first) {
        first = whole;
    }

    int second = whole - first;

    if (iop_size1 + iop_size2 >= 0x400 && first + second >= 0x400) {
        sent = sendToIOP2area(iop_addr1, iop_size1, iop_addr2, iop_size2, read_pos, first, ring, second);
    }

    dec->count -= sent;
    dec->total_bytes_sent += sent;
    dec->iop_last_pos = (dec->iop_last_pos + sent) % dec->iop_buff_size;
    return sent;
}

void iopGetArea(int *addr1, int *size1, int *addr2, int *size2, AudioDec *dec, int wanted) {
    int room = (wanted + dec->iop_buff_size - dec->iop_last_pos - 0x400) % dec->iop_buff_size;
    int len = room / 0x400 * 0x400;

    if (!(dec->iop_buff_size - dec->iop_last_pos < len)) {
        *addr1 = dec->iop_buff + dec->iop_last_pos;
        *size1 = len;
        *size2 = 0;
        *addr2 = 0;
    } else {
        *addr1 = dec->iop_buff + dec->iop_last_pos;
        *size1 = dec->iop_buff_size - dec->iop_last_pos;
        *addr2 = dec->iop_buff;
        *size2 = len - (dec->iop_buff_size - dec->iop_last_pos);
    }
}

int sendToIOP2area(int dest1, int size1, int dest2, int size2, u8 *src1, int len1, u8 *src2,
                   int len2) {
    int end1 = size1 + size2;
    int end2 = len1 + len2;

    if (end1 < end2) {
        int excess = end2 - end1;

        if (excess >= len2) {
            len1 -= excess - len2;
            len2 = 0;
        } else {
            len2 -= excess;
        }
    }

    int rest = size1 - len1;

    if (len1 >= size1) {
        sendToIOP(dest1, src1, size1);
        sendToIOP(dest2, &src1[size1], len1 - size1);
        sendToIOP(dest2 + len1 - size1, src2, len2);
    } else if (len2 >= rest) {
        sendToIOP(dest1, src1, len1);
        sendToIOP(dest1 + len1, src2, rest);
        sendToIOP(dest2, &src2[size1] - len1, len2 - rest);
    } else {
        sendToIOP(dest1, src1, len1);
        sendToIOP(dest1 + len1, src2, len2);
    }

    return len1 + len2;
}

int sendToIOP(int iop_addr, u8 *src, int size) {
    if (size <= 0) {
        return 0;
    }

    sceSifDmaData dma;
    dma.data = src;
    dma.addr = (void *) iop_addr;
    dma.size = size;
    dma.mode = 0;
    FlushCache(0);
    int id = sceSifSetDma(&dma, 1);

    while (sceSifDmaStat(id) >= 0) {
    }

    return size;
}

void changeMasterVolume(u32 volume) {
    for (int core = 0; core < 2; core++) {
        sceSdRemote(1, 0x8010, core | 0x980, volume);
        sceSdRemote(1, 0x8010, core | 0xA80, volume);
    }
}

void changeInputVolume(u32 volume) {
    sceSdRemote(1, 0x8010, 0xF81, volume);
    sceSdRemote(1, 0x8010, 0x1081, volume);
}

void startDisplay(int field) {
    do {
    } while (field == sceGsSyncV(0));

    frd = 0;
    isCountVblank = 1;
}

int switchThread() {
    return RotateThreadReadyQueue(10);
}

u32 videoDecSetState(VideoDec *dec, u32 state) {
    u32 old = dec->state;
    dec->state = state;
    return old;
}

s32 videoDecGetState(VideoDec *decoder) {
    return decoder->state;
}

int decBs0(VideoDec *dec) {
    if (sceMpegIsEnd(&dec->mpeg) == 0) {
        do {
            u8 *picture = voBufGetData(&voBuf);

            if (picture == 0) {
                do {
                    switchThread();
                    picture = voBufGetData(&voBuf);
                } while (picture == 0);
            }

            int mb_width = MpegW / 16;
            int mb_count = mb_width * MpegH / 16;

            if (sceMpegGetPicture(&dec->mpeg, (sceIpuRGB32 *) picture, mb_count) < 0) {
                printf("sceMpegGetPicture() decode error");
            }

            int i = 0;

            if (dec->mpeg.frameCount == 0) {
                for (; i < voBuf.size; i++) {
                    setImageTag(voBuf.ring_tag[i].v[0], &voBuf.data[i], 0, dec->mpeg.width, dec->mpeg.height);
                    setImageTag(voBuf.ring_tag[i].v[1], &voBuf.data[i], 0, dec->mpeg.width, dec->mpeg.height);
                }
            }

            voBufIncCount(&voBuf);
            switchThread();
        } while (sceMpegIsEnd(&dec->mpeg) == 0);
    }

    sceMpegReset(&dec->mpeg);
    return 1;
}
struct GifTagData {
    u_long128 value;
};
void setImageTag(u32 *tag, void *data, int a, int width, int height) {
    sceGifPacket packet;
    GifTagData giftag = *(GifTagData *)&at_1276__2;
    int blocks_y;
    int blocks_x;
    int x;
    int y;

    sceGifPkInit(&packet, (u_long128 *)UncAddr(tag));
    sceGifPkReset(&packet);
    sceGsTex0 tex0 = mgTexManager.GetTexture(TexName, -1)->tex0;
    sceGifPkCnt(&packet, 0, 0, 0);
    sceGifPkOpenGifTag(&packet, *(u_long128 *)&giftag);
    sceGifPkAddGsAD(&packet, 0x50, SCE_GS_SET_BITBLTBUF(0, 0, 0, tex0.TBP0, (u_int)(int)tex0.TBW, 0));
    sceGifPkAddGsAD(&packet, 0x52, SCE_GS_SET_TRXREG(16, 16));
    sceGifPkCloseGifTag(&packet);
    blocks_x = width >> 4;
    blocks_y = height >> 4;
    for (x = 0; x < blocks_x; x++) {
        for (y = 0; y < blocks_y; y++) {
            sceGifPkCnt(&packet, 0, 0, 0);
            sceGifPkOpenGifTag(&packet, *(u_long128 *)&giftag);
            sceGifPkAddGsAD(&packet, 0x51, SCE_GS_SET_TRXPOS(0, 0, (u_int)(x * 16), (u_int)(y * 16), 0));
            sceGifPkAddGsAD(&packet, 0x53, 0);
            sceGifPkCloseGifTag(&packet);
            u_int *image_tag = sceGifPkReserve(&packet, 4);
            *(u_long *)image_tag = 0x40 | ((u_long)0x08000000 << 32);
            *(u_long *)(image_tag + 2) = 0;
            sceGifPkRef(&packet, (u_long128 *)DmaAddr(data), 0x40, 0, 0, 0);
            data = (u8 *)data + 0x400;
        }
    }
    GifTagData end_tag = *(GifTagData *)&at_1287__2;
    sceGifPkEnd(&packet, 0, 0, 0);
    sceGifPkOpenGifTag(&packet, *(u_long128 *)&end_tag);
    sceGifPkAddGsAD(&packet, 0x3F, 0);
    sceGifPkCloseGifTag(&packet);
    sceGifPkTerminate(&packet);
}
void videoDecBeginPut(VideoDec *dec, u8 **area1, int *size1, u8 **area2, int *size2) {
    viBufBeginPut(&dec->vibuf, area1, size1, area2, size2);
}

int videoDecPutTs(VideoDec *dec, long pts, long dts, u8 *area, int size) {
    TimeStamp stamp;
    stamp.pts = pts;
    stamp.dts = dts;
    stamp.pos = area - (u8 *) dec->vibuf.data;
    stamp.len = size;
    return viBufPutTs(&videoDec.vibuf, &stamp);
}

void videoDecEndPut(VideoDec *dec, int count) {
    viBufEndPut(&dec->vibuf, count);
}

int cpy2area(u8 *destination1, int capacity1, u8 *destination2, int capacity2,
             u8 *source1, int size1, u8 *source2, int size2) {
    int total = size1 + size2;

    if (capacity1 + capacity2 < total) {
        return 0;
    }

    int remaining = capacity1 - size1;

    if (size1 >= capacity1) {
        memcpy(destination1, source1, capacity1);
        memcpy(destination2, source1 + capacity1, size1 - capacity1);
        memcpy(destination2 + size1 - capacity1, source2, size2);
    } else if (size2 >= remaining) {
        memcpy(destination1, source1, size1);
        memcpy(destination1 + size1, source2, remaining);
        memcpy(destination2, source2 + capacity1 - size1, size2 - remaining);
    } else {
        memcpy(destination1, source1, size1);
        memcpy(destination1 + size1, source2, size2);
    }

    return total;
}

void audioDecBeginPut(AudioDec *dec, u8 **area1, int *size1, u8 **area2, int *size2) {
    if (dec->state == 0) {
        *area1 = (u8 *) ((int) dec->hdr + dec->hdr_count);
        *size1 = sizeof(dec->hdr) - dec->hdr_count;
        *area2 = dec->data;
        *size2 = dec->size;
    } else {
        int available = dec->size - dec->count;

        if (dec->size - dec->put >= available) {
            *area1 = dec->data + dec->put;
            *size1 = available;
            *area2 = NULL;
            *size2 = 0;
        } else {
            *area1 = dec->data + dec->put;
            *size1 = dec->size - dec->put;
            *area2 = dec->data;
            *size2 = available - (dec->size - dec->put);
        }
    }
}

void audioDecEndPut(AudioDec *dec, int count) {
    if (dec->state == 0) {
        int header_bytes = sizeof(dec->hdr) - dec->hdr_count;
        header_bytes = (unsigned int) header_bytes < (unsigned int) count ? header_bytes : count;
        dec->hdr_count += header_bytes;

        if ((unsigned int) dec->hdr_count >= sizeof(dec->hdr)) {
            dec->state = 1;
        }

        count -= header_bytes;
    }

    dec->put = (dec->put + count) % dec->size;
    dec->count += count;
    dec->total_bytes += count;
}

int isAudioOK() {
    return isWithAudio != 0 ? audioDecIsPreset(&audioDec) : 1;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1276__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1287__2__DATA);
