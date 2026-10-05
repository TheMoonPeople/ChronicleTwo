#pragma once

#include "common.h"
#include <libipu.h>

/**
 * State of one MPEG decoder, including the size and timing of the most
 * recently decoded picture.
 */
typedef struct sceMpeg {
    int width;       /**< Width of the stream's pictures, in pixels. */
    int height;      /**< Height of the stream's pictures, in pixels. */
    int frameCount;  /**< Number of pictures decoded since the stream began. */
    long pts;        /**< Presentation time stamp of the last picture. */
    long dts;        /**< Decoding time stamp of the last picture. */
    u_long flags;    /**< Picture flags of the last picture. */
    long pts2nd;     /**< Presentation time stamp of the second field. */
    long dts2nd;     /**< Decoding time stamp of the second field. */
    u_long flags2nd; /**< Picture flags of the second field. */
    void *sys;       /**< Library-private decoder state. */
} sceMpeg;

/**
 * Events a decoder reports to callbacks registered with sceMpegAddCallback.
 */
typedef enum sceMpegCbType {
    sceMpegCbError = 0,      /**< A decoding error occurred. */
    sceMpegCbNodata = 1,     /**< The decoder ran out of bit-stream data. */
    sceMpegCbStopDMA = 2,    /**< The decoder needs the IPU input DMA suspended. */
    sceMpegCbRestartDMA = 3, /**< The decoder lets the IPU input DMA resume. */
    sceMpegCbBackground = 4, /**< The decoder is idle while the IPU works. */
    sceMpegCbTimeStamp = 5,  /**< The decoder asks for the time stamp of the next picture. */
    sceMpegCbStr = 6,        /**< A demultiplexed elementary-stream packet is available. */
} sceMpegCbType;

/**
 * Elementary-stream kinds a demultiplexer callback can be registered for.
 */
typedef enum sceMpegStrType {
    sceMpegStrM2V = 0,   /**< MPEG-2 video. */
    sceMpegStrIPU = 1,   /**< IPU stream. */
    sceMpegStrPCM = 2,   /**< Linear PCM audio. */
    sceMpegStrADPCM = 3, /**< ADPCM audio. */
    sceMpegStrDATA = 4,  /**< Private data. */
} sceMpegStrType;

/**
 * Callback data for sceMpegCbError.
 */
typedef struct sceMpegCbDataError {
    sceMpegCbType type; /**< Event being reported. */
    char *errMessage;   /**< Description of the error. */
} sceMpegCbDataError;

/**
 * Callback data for sceMpegCbTimeStamp, to be filled in by the callback.
 */
typedef struct sceMpegCbDataTimeStamp {
    sceMpegCbType type; /**< Event being reported. */
    long pts;           /**< Presentation time stamp of the next picture. */
    long dts;           /**< Decoding time stamp of the next picture. */
} sceMpegCbDataTimeStamp;

/**
 * Callback data for sceMpegCbStr: one demultiplexed packet.
 */
typedef struct sceMpegCbDataStr {
    sceMpegCbType type; /**< Event being reported. */
    u_char *header;     /**< Packet header. */
    u_char *data;       /**< Packet payload. */
    u_int len;          /**< Payload length in bytes. */
    long pts;           /**< Presentation time stamp carried by the packet. */
    long dts;           /**< Decoding time stamp carried by the packet. */
} sceMpegCbDataStr;

/**
 * Data passed to every decoder callback, interpreted by its type.
 */
typedef union sceMpegCbData {
    sceMpegCbType type;        /**< Event being reported. */
    sceMpegCbDataError error;  /**< Data of sceMpegCbError. */
    sceMpegCbDataTimeStamp ts; /**< Data of sceMpegCbTimeStamp. */
    sceMpegCbDataStr str;      /**< Data of sceMpegCbStr. */
} sceMpegCbData;

/**
 * Decoder callback; returns non-zero when it handled the event.
 */
typedef int (*sceMpegCallback)(sceMpeg *mp, sceMpegCbData *cbdata, void *anyData);

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Initialises the MPEG library.
 */
int sceMpegInit(void);

/**
 * Creates a decoder that uses a caller-supplied work area.
 */
int sceMpegCreate(sceMpeg *mp, u_char *work_area, int work_area_size);

/**
 * Destroys a decoder.
 */
int sceMpegDelete(sceMpeg *mp);

/**
 * Resets a decoder to the start of a stream.
 */
int sceMpegReset(sceMpeg *mp);

/**
 * Decodes the next picture into a macroblock buffer; negative on error.
 */
int sceMpegGetPicture(sceMpeg *mp, sceIpuRGB32 *rgb32, int mbcount);

/**
 * Returns non-zero once the end of the stream has been decoded.
 */
int sceMpegIsEnd(sceMpeg *mp);

/**
 * Registers a callback for one decoder event and returns the previous one.
 */
sceMpegCallback sceMpegAddCallback(sceMpeg *mp, sceMpegCbType type, sceMpegCallback callback,
                                   void *anyData);

/**
 * Registers a demultiplexer callback for one elementary stream and returns
 * the previous one.
 */
sceMpegCallback sceMpegAddStrCallback(sceMpeg *mp, sceMpegStrType strType, int ch,
                                      sceMpegCallback callback, void *anyData);

/**
 * Demultiplexes program-stream data held in a ring buffer, returning the
 * number of bytes consumed.
 */
int sceMpegDemuxPssRing(sceMpeg *mp, u_char *start, int size, u_char *buf_start, int buf_size);
#ifdef __cplusplus
}
#endif
