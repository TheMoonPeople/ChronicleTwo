#pragma once

#include "common.h"

/**
 * @file
 * Declares the camera mode in which Max takes photos: aiming and zooming,
 * capturing the frame buffer into a carried picture, and drawing the
 * on-screen prompts, photo title and photography level messages.
 */

class CPadControl;
class CInventUserData;
class mgCMemory;
struct USER_PICTURE_INFO;

/**
 *
 * Steps of the camera mode, as TakePhotoMode holds them.
 *
 */
// clang-format off
enum TakePhotoState {
    TAKE_PHOTO_OFF       = 0, /**< Camera mode is not active. */
    TAKE_PHOTO_AIM       = 2, /**< Aiming: zoom and shutter respond, and the photo menu may open. */
    TAKE_PHOTO_SHUTTER   = 3, /**< The shutter was pressed; the frame buffer is copied into the work texture next draw. */
    TAKE_PHOTO_STORE     = 5, /**< The captured image and subject distance are stored into the picture next draw. */
    TAKE_PHOTO_AFTERSHOT = 4, /**< The shutter animation plays before aiming resumes. */
    TAKE_PHOTO_OPEN_MENU = 6, /**< Raises the open-menu request and returns to aiming. */
};

// clang-format on

/**
 *
 * Messages of the camera mode, indexing the per-language message table.
 *
 */
// clang-format off
enum PhotoMessage {
    PHOTO_MES_CONFIRM  = 0, /**< Prompt to confirm the pictures taken. */
    PHOTO_MES_TAKE     = 1, /**< Prompt to take a picture. */
    PHOTO_MES_LEVEL_UP = 2, /**< Announcement that the photography level rose. */
    PHOTO_MES_ZOOM     = 3, /**< Prompt to zoom or go back. */
    PHOTO_MES_NUM      = 4, /**< Number of messages per language. */
};

// clang-format on

/**
 *
 * Gives a camera-mode message in the current language, or an empty
 * string when the message or language is out of range.
 *
 * @mangled GetMesTxt__Fi
 * @address 0x313880
 * @size 0x60
 */
char *GetMesTxt(int message);

/**
 *
 * Gives the projection offset the camera zoom adds while camera mode is
 * active, or zero outside it.
 *
 * @mangled PhotoAddProjection__Fv
 * @address 0x3138E0
 * @size 0x30
 */
float PhotoAddProjection();

/**
 *
 * Resets the camera mode to inactive, clearing the zoom, the shown title
 * and every display counter.
 *
 * @mangled InitTakePhoto__Fv
 * @address 0x313920
 * @size 0x40
 */
void InitTakePhoto();

/**
 *
 * Registers the work texture that captured photos are drawn into, keeps
 * the camera overlay's texture, and sets up the camera-mode font.
 *
 * @mangled LoadTakePhoto__FiP9mgCMemoryP1
 * @address 0x313960
 * @size 0xA0
 */
void LoadTakePhoto(int tex_block, mgCMemory *memory, u_long128 *buffer);

/**
 *
 * Enters camera mode, starting in the aiming step.
 *
 * @mangled StartTakePhoto__Fv
 * @address 0x313A00
 * @size 0x30
 */
void StartTakePhoto();

/**
 *
 * Leaves camera mode, resetting it to inactive.
 *
 * @mangled EndTakePhoto__Fv
 * @address 0x313A30
 * @size 0x10
 */
void EndTakePhoto();

/**
 *
 * Tells whether camera mode is active.
 *
 * @mangled NowTakePhoto__Fv
 * @address 0x313A40
 * @size 0x10
 */
int NowTakePhoto();

/**
 *
 * Tells whether the camera is in the aiming step, where the photo menu
 * may be opened.
 *
 * @mangled IsEnablePhotoMenu__Fv
 * @address 0x313A50
 * @size 0x10
 */
int IsEnablePhotoMenu();

/**
 *
 * Hides the most recently taken photo.
 *
 * @mangled HidePhoto__Fv
 * @address 0x313A60
 * @size 0x10
 */
void HidePhoto();

/**
 *
 * Tells whether the camera is in one of the shutter's capture steps,
 * when the scene drawn is the one the photo records.
 *
 * @mangled GhostPhotoTiming__Fv
 * @address 0x313A70
 * @size 0x30
 */
int GhostPhotoTiming();

/**
 *
 * Updates camera mode for one frame: zooms with the right stick, fires
 * the shutter when a picture slot is free, and runs the shutter
 * animation down.
 *
 * @mangled LoopTakePhoto__FP11CPadControlP15CInventUserData
 * @address 0x313AA0
 * @size 0x130
 */
void LoopTakePhoto(CPadControl *pad, CInventUserData *user_data);

/**
 *
 * Draws the camera overlay and the last photo taken, and performs the
 * capture steps of the shutter, storing the image into a picture and the
 * subject's distance into the given float; tells whether a picture was
 * filled.
 *
 * @mangled DrawTakePhoto__FP17USER_PICTURE_INFOPf
 * @address 0x313BD0
 * @size 0xE10
 */
int DrawTakePhoto(USER_PICTURE_INFO *picture, float *distance);

/**
 *
 * Records a newly taken picture: shows its title when it names a
 * subject, counts the shot, and shows the level-up message when the
 * photography level rises.
 *
 * @mangled SetTookPhotoData__FP17USER_PICTURE_INFO
 * @address 0x3149E0
 * @size 0x90
 */
void SetTookPhotoData(USER_PICTURE_INFO *photo);

/**
 *
 * Draws the camera-mode text: the button prompts or the photo title, the
 * level-up message, and the count of pictures carried against the limit.
 *
 * @mangled DrawTakePhotoSystem__FiP15CInventUserData
 * @address 0x314A70
 * @size 0x340
 */
void DrawTakePhotoSystem(int texture, CInventUserData *user_data);
