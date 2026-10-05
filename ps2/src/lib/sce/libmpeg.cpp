#include "common.h"
#include "sce/libmpeg_internal.h"

extern char D_003651B8[];
extern char D_003651E8[];
extern char D_00365200[];
extern char D_00365238[];

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _motionComp0);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _getAllRefs);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _getRef0);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _doMC);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _rix_000);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ri0_000);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _rix_001);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ri0_001);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _rix_010);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ri0_010);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _rix_011);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ri0_011);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _rix_100);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ri0_100);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _rix_101);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ri0_101);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _rix_110);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ri0_110);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _rix_111);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ri0_111);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _copyAddRefImage);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _copyRefImage);


INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ipuSetMPEG1);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _waitBdecOut);

int _dmVector(int a) {
    return _ipuVdec(a, 3);
}


INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _dualPrimeVector);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _mbAddressIncrement);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _pictureData0);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sliceA0);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _slice0);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _skipMB0);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _decMB0);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _decode_motion_vector);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _motionVectors);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _motionVector);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sendIpuCommand);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _waitIpuIdle);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _waitIpuIdle64);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ipuVdec);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _peepBit);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _flushBuf);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _nextBit);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _nextStartCode);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sliceB);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _nextHeader);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _pictureHeader);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _extensionAndUserData);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _pictureCodingExtension);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _extrainfo);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _updateTempTackData);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _groupOfPicturesHeader);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _quantMatrixExtension);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _pictureDisplayExtension);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _copyrightExtension);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _decPicture);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _outputFrame);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _updateRefImage);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _isOutSizeOK);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _cpr8);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _markOutput);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _getPtsDtsFlags);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _dispRefImage);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _dispRefImageField);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", dmaRefImage);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", receiveDataFromIPU);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _doCSC);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ch3dmaCSC);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _doCSC2);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ch4dma);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _csc_storeRefImage);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sysbitInit);

int _sysbitNext(unsigned long long *p, int n) {
    return (int)(*p >> (64 - n));
}


INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sysbitFlush);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sysbitGet);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sysbitMarker);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sysbitJump);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sysbitPtr);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _type2id);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _id2type);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", sceMpegDemuxPssRing);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", sceMpegDemuxPss);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", sceMpegAddStrCallback);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _pack_header);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _system_header);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _PES_packet);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", sceMpegInit);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", sceMpegCreate);

int sceMpegDelete(sceMpeg *mpeg) {
    return 1;
}


INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", sceMpegAddBs);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", sceMpegGetPicture);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", sceMpegGetPictureRAW8);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", sceMpegGetPictureRAW8xy);

void sceMpegSetDecodeMode(sceMpeg *mpeg, int mode, int skip, int flags) {
    sceMpegWork *work = (sceMpegWork *)mpeg->sys;
    work->decode_mode = mode;
    work->decode_skip = skip;
    work->decode_flags = flags;
}


INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", sceMpegGetDecodeMode);

int sceMpegIsEnd(sceMpeg *mpeg) {
    return ((sceMpegWork *)mpeg->sys)->ended;
}


int sceMpegIsRefBuffEmpty(sceMpeg *mpeg) {
    return ((sceMpegWork *)mpeg->sys)->reference_count == 0;
}


INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", sceMpegReset);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", sceMpegClearRefBuff);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", sceMpegAddCallback);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _dispatchMpegCallback);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _dispatchMpegCbNodata);

void sceMpegSetDefaultPtsGap(sceMpeg *mpeg, long gap) {
    sceMpegWork *work = (sceMpegWork *)mpeg->sys;
    work->default_pts_gap_enabled = 1;
    work->default_pts_gap = gap;
}


void sceMpegResetDefaultPtsGap(sceMpeg *mpeg) {
    sceMpegWork *work = (sceMpegWork *)mpeg->sys;
    work->default_pts_gap_enabled = 0;
    work->default_pts_gap = 0;
}


void sceMpegSetImageBuff(sceMpeg *mpeg, void *buffer) {
    ((sceMpegWork *)mpeg->sys)->image_buffer = buffer;
}


int sceMpegDispWidth(sceMpeg *mpeg) {
    return ((sceMpegWork *)mpeg->sys)->display_width;
}


int sceMpegDispHeight(sceMpeg *mpeg) {
    return ((sceMpegWork *)mpeg->sys)->display_height;
}


int sceMpegDispCenterOffX(sceMpeg *mpeg) {
    return (int)((sceMpegWork *)mpeg->sys)->display_center;
}


int sceMpegDispCenterOffY(sceMpeg *mpeg) {
    return (int)((sceMpegWork *)mpeg->sys)->display_center;
}


int sceSetBrokenLink(sceMpeg *mpeg, int value) {
    sceMpegWork *work = (sceMpegWork *)mpeg->sys;
    int previous = work->broken_link;
    work->broken_link = value;
    return previous;
}


void sceSetPtm(sceMpeg *mpeg, long time) {
    sceMpegWork *work = (sceMpegWork *)mpeg->sys;
    work->presentation_time = time;
    work->presentation_time_set = 1;
}


void _alalcInit(int *p, int a, int b) {
    p[0] = a;
    p[1] = b;
    p[2] = a;
    p[3] = a;
}


void _alalcSetDynamic(int *p) {
    p[3] = p[2];
}


void _alalcFree(int *p) {
    p[2] = p[3];
}


INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _alalcAlloc);

int _alalcRest(int *p) {
    return p[0] + p[1] - p[2];
}


INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _getpic);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _decodeOrSkipFrame);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _decodeOrSkip);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _decodeOrSkipField);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sceMpegFlush);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _initSeqAgain);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _lastFrame);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _clearOnce);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _clearEach);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ErrMessage);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _Error1);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _Error);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sendDataToIPU);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _RefImageInit);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sequenceHeader);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _initSeq);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _initRefImages);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _setDefaultQM);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sequenceExtension);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _sequenceDisplayExtension);

void _sequenceScalableExtension(int arg0) {
    _Error(arg0, D_003651B8);
}


void _unknown_extension(int arg0) {
    _Error(arg0, D_003651E8);
}


void _pictureSpatialScalableExtension(int arg0) {
    _Error(arg0, D_00365200);
}


void _pictureTemporalScalableExtension(int arg0) {
    _Error(arg0, D_00365238);
}


void _defStopDMA(sceMpeg *mpeg) {
    sceMpegWork *work = (sceMpegWork *)mpeg->sys;
    sceIpuStopDMA(&work->dma);
}


void _defRestartDMA(sceMpeg *mpeg) {
    sceMpegWork *work = (sceMpegWork *)mpeg->sys;
    sceIpuRestartDMA(&work->dma);
}


INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _rix__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _ri0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _isDirty__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _showCount__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _strmap__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _defIQM__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", _defNIQM__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364D58__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364D80__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364DA0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364DC0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364DE0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364DF8__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364E18__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364E50__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364E70__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364E98__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364EB8__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364ED8__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364F08__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364F28__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364F58__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364F80__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364FB0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364FD0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00364FF0__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00365020__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00365038__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00365048__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00365080__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_003650A8__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_003650C8__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00365128__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00365148__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00365158__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00365170__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00365198__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_003651B8__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_003651E8__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00365200__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libmpeg", D_00365238__DATA);

INCLUDE_BSS(_sprtagdata_24, 0x200);
