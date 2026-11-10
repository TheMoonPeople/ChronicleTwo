#pragma once

class mgCTexture;

extern unsigned int TakePhotoMode asm("Photo_CaptureState");
extern mgCTexture  *WorkTex asm("Photo_CaptureTexture");
extern float        AddProj asm("Photo_Zoom");
extern int          ShowTakePhotoCnt asm("Photo_PreviewFrames");
extern int          ShutterAnmCnt asm("Photo_ShutterFrames");
extern unsigned int OpenMenu asm("Photo_OpenMenu");
/** Texture block containing the camera viewfinder artwork. */
extern unsigned int CameraTexb asm("Photo_CameraTexture");
