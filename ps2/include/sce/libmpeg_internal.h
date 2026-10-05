#pragma once

#include "sce/libmpeg.h"

typedef struct sceMpegWork {
    int ended;
    int reference_count;
    u_char reserved_08[0x44];
    sceIpuDmaEnv dma;
    int default_pts_gap_enabled;
    int reserved_74;
    long default_pts_gap;
    u_char reserved_80[0x14];
    int decode_mode;
    int decode_skip;
    int decode_flags;
    u_char reserved_a0[0x14];
    u_char display_center[0x18];
    int display_width;
    int display_height;
    int reserved_d4;
    void *image_buffer;
    u_char reserved_dc[0x0c];
    int broken_link;
    int reserved_ec;
    long presentation_time;
    int presentation_time_set;
} sceMpegWork;

#ifdef __cplusplus
extern "C" {
#endif
void sceIpuStopDMA(sceIpuDmaEnv *save);
void sceIpuRestartDMA(sceIpuDmaEnv *save);
int _ipuVdec(int value, int mode);
void _Error(int decoder, char *message);
#ifdef __cplusplus
}
#endif
