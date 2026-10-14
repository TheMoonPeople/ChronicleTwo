#include "common.h"

#include <algorithm>
#include <vector>

#include "inventmn.hpp"
#include "mglib.hpp"
#include "mg_texture_port.hpp"
#include "mglib_port.hpp"
#include "padcontrol.hpp"
#include "photo.hpp"
#include "photo_hd.hpp"
#include "stubs/photo.hpp"

PORT_OVERRIDE void LoopTakePhoto(CPadControl *pad, CInventUserData *user) {
    if (user == nullptr) {
        return;
    }
    // Capture at a higher resolution than retail's 64x64; mgStoreImage keeps that detail for the idea board.
    if (WorkTex != nullptr) {
        MgTextureSetPhysicalScale(WorkTex, kPhotoWorkScale);
    }
    if (TakePhotoMode == TAKE_PHOTO_AIM) {
        AddProj -= 10.0f * pad->Analog(PAD_ANALOG_RIGHT_Y);
        if (!(AddProj <= 200.0f)) {
            AddProj = 200.0f;
        }
        if (AddProj < -200.0f) {
            AddProj = -200.0f;
        }
        if (user->IsPhotoSpace(nullptr) && pad->Btn(PAD_BTN_ACTION_SQUARE)) {
            TakePhotoMode = TAKE_PHOTO_SHUTTER;
        }
        ShowTakePhotoCnt = std::max(0, ShowTakePhotoCnt - 1);
    }
    if (TakePhotoMode == TAKE_PHOTO_AFTERSHOT && --ShutterAnmCnt < 0) {
        ShutterAnmCnt = 0;
        TakePhotoMode = TAKE_PHOTO_AIM;
    }
    if (TakePhotoMode == TAKE_PHOTO_OPEN_MENU) {
        OpenMenu = 1;
        TakePhotoMode = TAKE_PHOTO_AIM;
    }
    if (TakePhotoMode == TAKE_PHOTO_SHUTTER && WorkTex != nullptr) {
        // Recording defers GPU work to the frame boundary. Request the capture
        // there so the following STORE frame receives this shot, including depth.
        std::vector<uint8_t> ignored;
        uint32_t             width = 0, height = 0;
        mgPortReadColor(mgPortRenderTarget(WorkTex), ignored, width, height);
        mgRect<int> lens(252, 204, 260, 212);
        u_long128   depth[16];
        mgStoreZBuffImage(lens, depth);
    }
}
