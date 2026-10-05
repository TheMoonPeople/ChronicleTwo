#include "common.h"
#include "movie.hpp"
#include "mg_memory.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include <eekernel.h>
#include <libdma.h>
#include <libgraph.h>
#include <libsdr.h>
#include <sifdev.h>
#include <sifdma.h>
#include <sifrpc.h>
#include <cctype>
#include <cstdio>
#include <cstring>

extern "C" {
int DIntr();
int EIntr(...);
int AddIntcHandler(int cause, int (*handler)(int), int next);
int RemoveIntcHandler(int cause, int handler);
int EnableIntc(int cause);
int AddDmacHandler(int channel, int (*handler)(int), int next);
int RemoveDmacHandler(int channel, int handler);
int EnableDmac(int channel);
int DisableDmac(int channel);
int sceCdDiskReady(int mode);
int sceCdStInit(int sectors, int banks, void *buffer);
int sceCdStStart(unsigned int sector, sceCdRMode *mode);
int sceCdStSeekF(unsigned int sector);
int sceCdStStop();
int sceCdStRead(unsigned int sectors, void *buffer, unsigned int mode, unsigned int *error);
}

extern u8 isStarted;
extern int writerest;
extern u8 isFrameEnd;
extern u32 frd;
extern u8 isCountVblank;
extern int Cb;
extern sceDmaChan *DmaCH2;
extern int MpegW;
extern int MpegH;
extern VideoDec videoDec;
extern StrFile infile;
extern char *TexName;
extern ReadBuf *readBuf;
extern int readrest;
extern u8 Loop;
extern u8 isWithAudio;
extern int cnt_513;
extern s8 init_514;
extern volatile int stepMainStatus;
extern int stepMainExitFlag;
extern VoBuf voBuf;
extern AudioDec audioDec;
extern u8 _0_buf[2048];
struct MoviePools {
    mgCMemory *pool[6];
};
extern MoviePools at_344;
extern MoviePools at_349;
extern u8 isStrFileInit;

static int voBufIsFull(VoBuf *buf);

extern "C" char *index(const char *, int);
extern char at_810__3[];
extern char at_1028__5[];
extern char at_1029__4[];
extern char at_1030__3[];
extern char at_1031__3[];
extern char at_1032__4[];
extern char at_1033__4[];
extern char at_1034__3[];
extern char at_1035__3[];
extern char at_1036__3[];
extern char at_1037__3[];
extern char at_1038__3[];
extern char at_1109[];
extern char at_1110__2[];
extern char at_1270__3[];

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", Load__6CMovieFPcPP9mgCMemoryiibbb);
int CMovie::Load(char *name, mgCMemory *memory, int width, int height, bool with_audio, bool loop) {
    MoviePools pools = at_344;
    pools.pool[0] = memory;
    pools.pool[1] = memory;
    pools.pool[2] = memory;
    pools.pool[3] = memory;
    pools.pool[4] = memory;
    pools.pool[5] = memory;
    return Load(name, pools.pool, width, height, with_audio, loop, true);
}
int CMovie::Load(char *name, mgCMemory *memory, int width, int height, bool with_audio, bool loop, bool init_sound) {
    MoviePools pools = at_349;
    pools.pool[0] = memory;
    pools.pool[1] = memory;
    pools.pool[2] = memory;
    pools.pool[3] = memory;
    pools.pool[4] = memory;
    pools.pool[5] = memory;
    return Load(name, pools.pool, width, height, with_audio, loop, init_sound);
}
void CMovie::Play(char *path) {
    ThreadParam param;
    if (is_playing == 0) {
        TexName = path;
        param.entry = (void (*)(void *))defMain;
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
        param.entry = (void (*)(void *))stepMain;
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
int CMovie::IsStarted(void) {
    return isStarted;
}
int CMovie::GetVoBufDataSize() { return 0x1C0000; }
int CMovie::GetViBufDataSize() { return 0x80000; }
s32 CMovie::GetViBufTagSize(void) {
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
    sceMpegAddCallback(&dec->mpeg, sceMpegCbError, (sceMpegCallback)mpegError, 0);
    sceMpegAddCallback(&dec->mpeg, sceMpegCbNodata, mpegNodata, 0);
    sceMpegAddCallback(&dec->mpeg, sceMpegCbStopDMA, mpegStopDMA, 0);
    sceMpegAddCallback(&dec->mpeg, sceMpegCbRestartDMA, mpegRestartDMA, 0);
    sceMpegAddCallback(&dec->mpeg, sceMpegCbTimeStamp, (sceMpegCallback)mpegTS, 0);
    dec->state = 0;
    viBufCreate(&dec->vibuf, data, tags, sectors, ts, ts_count);
    return 1;
}
int CMovie::videoDecSetStream(VideoDec *dec, int id, int param, sceMpegCallback callback, void *user) {
    sceMpegAddStrCallback(&dec->mpeg, (sceMpegStrType)(id & 0xFF), param, callback, user);
    return 1;
}
int CMovie::videoDecDelete(VideoDec *dec) {
    viBufDelete(&dec->vibuf);
    sceMpegDelete(&dec->mpeg);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", videoDecFlush__6CMovieFP8VideoDec);
int defMain(void *) {
    for (;;) {
        switchThread();
    }
}
void videoDecMain(void *arg) {
    VideoDec *dec = (VideoDec *)arg;

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
        u8 gap[0x38];
    } areas;
    u8 *get_area;
    VideoDec *dec = &videoDec;
    ReadBuf *ring = readBuf;
    StrFile *file = &infile;
    if (init_514 == 0) {
        cnt_513 = 0;
        init_514 = 1;
    }
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", videoCallback__FP7sceMpegP16sceMpegCbDataStrPv);
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
    src = str->data + 4;
    ring_size = ((ReadBuf *)user)->size;
    ring_end = (u8 *)user + ring_size;
    if (src >= ring_end) {
        src -= ring_size;
    }
    first = ring_end - src;
    total = str->len - 4;
    first = (total < first) ? total : first;
    audioDecBeginPut(&audioDec, &area1, &size1, &area2, &size2);
    int copied = cpy2area(area1, size1, area2, size2, src, first, (u8 *)user, total - first);
    audioDecEndPut(&audioDec, copied);
    int result = 0;
    if (copied > 0) {
        result = 1;
    }
    return result;
}
#pragma global_optimizer off
int vblankHandler(int irq) {
    if (isCountVblank) {
        VoTag *tag = voBufGetTag(&voBuf);
        if (tag == 0) {
            frd++;
            asm {
                sync
                ei
            }
            return 0;
        }
        if (Cb == 0 && tag->status == 2) {
            sceDmaSend(DmaCH2, tag->v[0]);
            tag->status = 1;
        } else if (Cb == 1 && tag->status == 1) {
            sceDmaSend(DmaCH2, tag->v[1]);
            tag->status = 0;
            isFrameEnd = 1;
        }
        Cb ^= 1;
    }
    asm {
        sync
        ei
    }
    return 0;
}
#pragma global_optimizer reset
int handler_endimage(int irq) {
    if (isFrameEnd) {
        voBufDecCount(&voBuf);
        isFrameEnd = 0;
    }
    asm {
        sync
        ei
    }
    return 0;
}
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
#pragma divbyzerocheck on
void voBufIncCount(VoBuf *buf) {
    DIntr();
    buf->ring_tag[buf->write].status = 2;
    buf->count++;
    buf->write = (buf->write + 1) % buf->size;
    EIntr();
}
#pragma divbyzerocheck reset
u8 *voBufGetData(VoBuf *buf) {
    if (voBufIsFull(buf)) {
        return 0;
    }
    return (u8 *)buf->data + buf->write * 0xE0000;
}
static s32 voBufIsEmpty(VoBuf *buffer) {
    return buffer->count == 0;
}
#pragma divbyzerocheck on
VoTag *voBufGetTag(VoBuf *buf) {
    if (voBufIsEmpty(buf)) {
        return 0;
    }
    return &buf->ring_tag[(buf->write - buf->count + buf->size) % buf->size];
}
#pragma divbyzerocheck reset
void voBufDecCount(VoBuf *buf) {
    if (buf->count > 0)
        buf->count = buf->count - 1;
}
static u32 getFIFOindex(ViBuf *buf, void *addr) {
    if (addr == (void *)(((u32)buf->tag + (buf->n + 1) * 0x10) & 0xFFFFFFF)) {
        return 0;
    }
    return ((u32)addr - (u32)buf->data) >> 11;
}
void setD3_CHCR(u32 chcr) {
    DIntr();
    int mask = *(int *)0x1000F520;
    *(int *)0x1000F590 = mask | 0x10000;
    *(u32 *)0x1000B000 = chcr;
    *(int *)0x1000F590 = *(int *)0x1000F520 & 0xFFFEFFFF;
    EIntr(mask, 0x1000F590);
}
void setD4_CHCR(u32 chcr) {
    DIntr();
    int mask = *(int *)0x1000F520;
    *(int *)0x1000F590 = mask | 0x10000;
    *(u32 *)0x1000B400 = chcr;
    *(int *)0x1000F590 = *(int *)0x1000F520 & 0xFFFEFFFF;
    EIntr(mask, 0x1000F590);
}
static void scTag2(QWORD *tag, void *addr, u32 id, u32 count) {
    tag->l[0] = ((u64)(u32)addr << 32) | ((u64)id << 28) | (u64)count;
}
int viBufCreate(ViBuf *buf, u_long128 *data, u_long128 *tags, int sectors, TimeStamp *ts, int ts_count) {
    buf->data = data;
    buf->tag = (u_long128 *)(((u32)tags & 0xFFFFFFF) | 0x20000000);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", viBufReset__FP5ViBuf);
#pragma divbyzerocheck on
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
        *area1 = (u8 *)buf->data + write_pos;
        *size1 = free;
        *area2 = NULL;
        *size2 = 0;
    } else {
        *area1 = (u8 *)buf->data + write_pos;
        *size1 = buf->buff_size - write_pos;
        *area2 = (u8 *)buf->data;
        *size2 = free - (buf->buff_size - write_pos);
    }
    SignalSema(buf->sema);
}
#pragma divbyzerocheck reset
void viBufEndPut(ViBuf *buf, int count) {
    WaitSema(buf->sema);
    buf->read_bytes += count;
    buf->total_bytes += count;
    SignalSema(buf->sema);
}
#pragma divbyzerocheck on
int viBufAddDMA(ViBuf *buf) {
    int chained = 0;
    WaitSema(buf->sema);
    if (buf->is_active == 0) {
        printf(at_810__3);
        return 0;
    }
    setD4_CHCR(5);
    u32 chcr = *(u32 *)0x1000B400;
    u32 madr = *(u32 *)0x1000B410;
    int fifo_index = getFIFOindex(buf, (void *)madr);
    int consumed = (fifo_index + buf->n - buf->dma_start) % buf->n;
    buf->dma_start = (buf->dma_start + consumed) % buf->n;
    buf->dma_n -= consumed;
    int ready;
    int tail = (buf->dma_start + buf->dma_n) % buf->n;
    ready = buf->read_bytes / 0x800;
    buf->read_bytes %= 0x800;
    if (ready > 0) {
        int last = (buf->dma_start + buf->dma_n - 1 + buf->n) % buf->n;
        scTag2((QWORD *)(buf->tag + last), (void *)((u8 *)buf->data + last * 0x800), 3,
               0x80);
        chained = 1;
    }
    for (int i = 0; i < ready; i++) {
        scTag2((QWORD *)(buf->tag + tail), (void *)((u8 *)buf->data + tail * 0x800),
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
#pragma divbyzerocheck reset
#pragma optimization_level 4
int viBufStopDMA(ViBuf *buf) {
    WaitSema(buf->sema);
    buf->is_active = 0;
    setD4_CHCR(5);
    buf->env.d4madr = *(u32 *)0x1000B410;
    buf->env.d4tadr = *(u32 *)0x1000B430;
    buf->env.d4qwc = *(u32 *)0x1000B420;
    buf->env.d4chcr = *(u32 *)0x1000B400;
    volatile u32 *ipu_ctrl = (volatile u32 *)0x10002010;
    while ((*ipu_ctrl & 0xF0) != 0) {
    }
    setD3_CHCR(0);
    buf->env.d3madr = *(u32 *)0x1000B010;
    buf->env.d3qwc = *(u32 *)0x1000B020;
    buf->env.d3chcr = *(u32 *)0x1000B000;
    buf->env.ipubp = *(u32 *)0x10002020;
    buf->env.ipuctrl = *(u32 *)0x10002010;
    SignalSema(buf->sema);
    return 1;
}
#pragma optimization_level reset
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", viBufRestartDMA__FP5ViBuf);
int viBufDelete(ViBuf *buf) {
    setD4_CHCR(5U);
    *(int *)0x1000B420 = 0;
    *(int *)0x1000B410 = 0;
    *(int *)0x1000B430 = 0;
    DeleteSema(buf->sema);
    return 1;
}
void viBufFlush(ViBuf *buf) {
    WaitSema(buf->sema);
    buf->read_bytes = (buf->read_bytes + 0x7FF) / 0x800 * 0x800;
    SignalSema(buf->sema);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", viBufModifyPts__FP5ViBufP9TimeStamp);
#pragma divbyzerocheck on
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
#pragma divbyzerocheck reset
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", viBufGetTs__FP5ViBufP9TimeStamp);
int strFileOpen(StrFile *file, char *path) {
    char full_path[0x100];
    char device[0x4C];
    sceCdRMode cd_mode;
    int leftover;
    s8 *colon = (s8 *)index(path, ':');
    if (colon != NULL) {
        int device_len = colon - (s8 *)path;
        strncpy(device, path, device_len);
        device[device_len] = 0;
        if (strcmp(device, at_1028__5) == 0) {
            int i;
            int length = strlen((char *)colon + 1);
            i = 0;
            file->is_on_cd = 1;
            while (i < length) {
                if (colon[i + 1] == '/') {
                    colon[i + 1] = '\\';
                }
                colon[i + 1] = toupper(colon[i + 1]);
                i++;
            }
            sprintf(full_path, at_1029__4, colon + 1, leftover);
        } else {
            file->is_on_cd = 0;
            sprintf(full_path, at_1030__3, device, colon + 1);
        }
    } else {
        strcpy(device, at_1031__3);
        file->is_on_cd = 0;
        sprintf(full_path, at_1030__3, device, path);
    }
    file->is_on_cd = 1;
    strcpy(full_path, at_1032__4);
    strcat(full_path, path);
    strcat(full_path, at_1033__4);
    printf(at_1034__3, file->is_on_cd, full_path);
    if (file->is_on_cd != 0) {
        if (isStrFileInit == 0) {
            sceCdDiskReady(0);
            isStrFileInit = 1;
        }
        file->iop_buf = iop_bd_addr;
        sceCdStInit(0x50, 5, (void *)(((u32)file->iop_buf + 0xF) & ~0xF));
        if (sceCdSearchFile(&file->fp, full_path) == 0) {
            printf(at_1035__3, full_path);
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
            printf(at_1036__3, full_path);
            return 0;
        }
        file->size = sceLseek(file->fd, 0, 2);
        if (file->size < 0) {
            printf(at_1037__3, full_path, file->size);
            sceClose(file->fd);
            return 0;
        }
        if (sceLseek(file->fd, 0, 0) < 0) {
            printf(at_1038__3, full_path);
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
#pragma divbyzerocheck on
int readBufEndPut(ReadBuf *buf, int count) {
    int room = buf->size - buf->count;
    int stored = (count < room) ? count : room;
    buf->put = (buf->put + stored) % buf->size;
    buf->count += stored;
    return stored;
}
#pragma divbyzerocheck reset
#pragma divbyzerocheck on
int readBufBeginGet(ReadBuf *buf, u8 **out) {
    if (buf->count != 0) {
        *out = buf->data + (buf->put - buf->count + buf->size) % buf->size;
    }
    return buf->count;
}
#pragma divbyzerocheck reset
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
    dec->iop_buff = (int)sceSifAllocIopHeap(iop_size);
    iop_buf = (int)(dec->iop_buff);
    if (iop_buf < 0) {
        printf(at_1109, iop_buf);
        return 0;
    }
    printf(at_1110__2, iop_buf, iop_size);
    dec->iop_zero = (int)sceSifAllocIopHeap(0x800);
    iop_stub = (int)(dec->iop_zero);
    if (iop_stub < 0) {
        printf(at_1109, iop_stub);
        return 0;
    }
    printf(at_1110__2, iop_stub, 0x800);
    memset(&_0_buf, 0, 0x800);
    sendToIOP(dec->iop_zero, &_0_buf[0], 0x800);
    changeMasterVolume(0x3FFFU);
    sndSetMasterVol(0, 1.0f);
    sndSetMasterVol(1, 1.0f);
    return 1;
}
int audioDecDelete(AudioDec *dec) {
    sceSifFreeIopHeap((void *)dec->iop_buff);
    sceSifFreeIopHeap((void *)dec->iop_zero);
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
#pragma divbyzerocheck on
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
#pragma divbyzerocheck reset
#pragma divbyzerocheck on
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
#pragma divbyzerocheck reset
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
    dma.addr = (void *)iop_addr;
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
int switchThread(void) {
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
            if (sceMpegGetPicture(&dec->mpeg, (sceIpuRGB32 *)picture, mb_count) < 0) {
                printf(at_1270__3);
            }
            int i = 0;
            if (dec->mpeg.frameCount == 0) {
                int data_offset = 0;
                int tag_offset = 0;
                for (; i < voBuf.size; i++) {
                    setImageTag(((VoTag *)((u8 *)voBuf.ring_tag + tag_offset))->v[0],
                                (u8 *)voBuf.data + data_offset, 0, dec->mpeg.width, dec->mpeg.height);
                    setImageTag(((VoTag *)((u8 *)voBuf.ring_tag + tag_offset))->v[1],
                                (u8 *)voBuf.data + data_offset, 0, dec->mpeg.width, dec->mpeg.height);
                    tag_offset += 0x48;
                    data_offset += 0xE0000;
                }
            }
            voBufIncCount(&voBuf);
            switchThread();
        } while (sceMpegIsEnd(&dec->mpeg) == 0);
    }
    sceMpegReset(&dec->mpeg);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", setImageTag__FPUiPviii);
void videoDecBeginPut(VideoDec *dec, u8 **area1, int *size1, u8 **area2, int *size2) {
    viBufBeginPut(&dec->vibuf, area1, size1, area2, size2);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", videoDecPutTs__FP8VideoDecllPUci);
void videoDecEndPut(VideoDec *dec, int count) {
    viBufEndPut(&dec->vibuf, count);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", cpy2area__FPUciPUciPUciPUci);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", audioDecBeginPut__FP8AudioDecPPUcPiPPUcPi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/movie", audioDecEndPut__FP8AudioDeci);
int isAudioOK(void) {
    return isWithAudio != 0 ? audioDecIsPreset(&audioDec) : 1;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1276__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1287__2__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_318__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_319__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_320__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_321__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_322__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_323__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_584__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_810__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1028__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1029__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1030__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1031__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1032__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1033__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1034__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1035__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1036__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1037__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1038__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1109__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1110__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_1270__3__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movie", at_468__2__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(frd, 0x4);
INCLUDE_BSS(TexName, 0x4);
INCLUDE_BSS(readBuf, 0x4);
INCLUDE_BSS(writerest, 0x4);
INCLUDE_BSS(readrest, 0x4);
INCLUDE_BSS(isWithAudio, 0x4);
INCLUDE_BSS(isStarted, 0x4);
INCLUDE_BSS(isStrFileInit, 0x4);
INCLUDE_BSS(Loop, 0x4);
INCLUDE_BSS(MpegW, 0x4);
INCLUDE_BSS(MpegH, 0x4);
INCLUDE_BSS(isCountVblank, 0x4);
INCLUDE_BSS(isFrameEnd, 0x4);
INCLUDE_BSS(Cb, 0x4);
INCLUDE_BSS(stepMainStatus, 0x4);
INCLUDE_BSS(stepMainExitFlag, 0x4);
INCLUDE_BSS(cnt_513, 0x4);
INCLUDE_BSS(init_514, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(videoDec, 0xC0);
INCLUDE_BSS(audioDec, 0x60);
INCLUDE_BSS(voBuf, 0x20);
INCLUDE_BSS(infile, 0x40);
INCLUDE_BSS(_0_buf, 0x800);
INCLUDE_BSS(at_344, 0x20);
INCLUDE_BSS(at_349, 0x20);
