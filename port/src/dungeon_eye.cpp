#include "common.h"

#include "dng_main.hpp"
#include "mglib_port.hpp"

void PortRetailResetEyeView(CActionChara *) asm("DngMain_ResetEyeView");

PORT_OVERRIDE void ResetEyeView(CActionChara *chara) {
    const bool eye_view = DngStatus.eye_view;
    PortRetailResetEyeView(chara);
    if (eye_view && !DngStatus.eye_view) {
        mgPortCutCameraInterpolation();
    }
}
