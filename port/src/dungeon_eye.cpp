#include "common.h"

#include "dng_main.hpp"
#include "render/renderer.hpp"

void ResetEyeView(CActionChara *chara) {
    const bool eye_view = DngStatus.eye_view;
    dc2::dungeon::ResetEyeViewCore(chara);
    if (eye_view && !DngStatus.eye_view) {
        mgPortCutCameraInterpolation();
    }
}
