#include "common.h"
#include "object.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"

// Code (.text)
void CObject::GetMatrix(float (*matrix)[4]) {
    mgUnitMatrix(matrix);
    matrix[0][0] = scale[0];
    matrix[1][1] = scale[1];
    matrix[2][2] = scale[2];
    if (rotation[0] != 0.0f) {
        sceVu0RotMatrixX(matrix, matrix, rotation[0]);
    }
    if (rotation[1] != 0.0f) {
        sceVu0RotMatrixY(matrix, matrix, rotation[1]);
    }
    if (rotation[2] != 0.0f) {
        sceVu0RotMatrixZ(matrix, matrix, rotation[2]);
    }
    *(u_long128 *)matrix[3] = *(u_long128 *)position;
    matrix[3][3] = 1.0f;
}
int CObject::FarClip(float dist, float *outAlpha) {
    int visible;
    int drawn;
    float step;

    *outAlpha = 1.0f;
    step = fade_speed;
    visible = 1;
    if (far_dist > 0.0f && !(dist <= far_dist)) {
        visible = 0;
    }
    if (near_dist > 0.0f) {
        if (dist < near_dist) {
            visible = 0;
            step *= 2.0f;
        }
    }
    drawn = visible != 0;
    if (drawn != 0) {
        drawn = show != 0;
    }
    if (drawn != 0) {
        drawn = (draw_off != 0) ^ 1;
    }
    visible = drawn & 0xFF;
    if (fade_alpha < 0.0f) {
        if (visible != 0) {
            fade_alpha = 1.0f;
        } else {
            fade_alpha = 0.0f;
        }
    }
    if (fade != 0) {
        if (visible != 0) {
            fade_alpha = fade_alpha + step;
            if (!(fade_alpha <= 1.0f)) {
                fade_alpha = 1.0f;
            }
        } else {
            fade_alpha = fade_alpha - step;
            if (fade_alpha <= 0.0f) {
                fade_alpha = 0.0f;
                visible = 0;
            } else {
                visible = 1;
            }
        }
        *outAlpha = fade_alpha;
    }
    return visible;
}
float CObject::GetCameraDist() {
    return mgGetDistFromCamera(((mgCObject *)this)->position);
}
int CObject::CheckDraw() {
    float dist;

    if (fade != 0) {
        if (fade_alpha != 0.0f) {
            return 1;
        }
        return 0;
    }
    if (show == 0 || draw_off != 0) {
        return 0;
    }
    dist = GetCameraDist();
    if (far_dist > 0.0f) {
        if (dist > far_dist) {
            return 0;
        }
    }
    if (near_dist > 0.0f) {
        if (dist < near_dist) {
            return 0;
        }
    }
    return 1;
}
void CObject::DrawStep() {
    float matrix;
    FarClip(GetCameraDist(), &matrix);
}
float CObject::GetAlpha() {
    if (fade != 0) {
        return fade_alpha;
    }
    if (CheckDraw() != 0) {
        return 1.0f;
    }
    return 0.0f;
}
int CObject::PreDraw() {
    if (show == 0 || draw_off != 0) {
        return 0;
    }
    return 1;
}
void CObject::Initialize() {
    SetPosition(0.0f, 0.0f, 0.0f);
    SetRotation(0.0f, 0.0f, 0.0f);
    SetScale(1.0f, 1.0f, 1.0f);
    far_dist = -1.0f;
    fade = 0;
    fade_alpha = -1.0f;
    fade_speed = 0.2f;
    near_dist = -1.0f;
    show = 1;
    draw_off = 0;
}
void CObjectFrame::UpDatePosition() {
    mgCObject *object = (mgCObject *)this;

    if (frame != NULL) {
        ((mgCFrame *)frame)->SetPosition(object->position);
        ((mgCFrame *)frame)->SetRotation(object->rotation);
        ((mgCFrame *)frame)->SetScale(object->scale);
    }
}
void CObjectFrame::DrawStep() {
    CObject::DrawStep();
}
float CObjectFrame::GetCameraDist() {
    float position[4];

    frame->GetWorldPosition0(position);
    return mgGetDistFromCamera(position);
}
int CObjectFrame::PreDraw() {
    int result;
    float alpha;

    result = 0;
    if (frame != NULL) {
        UpDatePosition();
        CObject::PreDraw();
        result = FarClip(GetCameraDist(), &alpha);
        if (result != 0) {
            if (((CObject *)this)->fade != 0) {
                frame->SetAttrParamObjAlpha(alpha, 1);
            }
        }
    }
    return result;
}
int CObjectFrame::Draw() {
    if (CObjectFrame::PreDraw() == 0) {
        return 0;
    }
    mgDraw(frame);
    return 0;
}
int CObjectFrame::DrawDirect() {
    if (CObjectFrame::PreDraw() == 0) {
        return 0;
    }
    mgDrawDirect(frame);
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/object", Copy__12CObjectFrameFR12CObjectFrameP9mgCMemory);
void CObjectFrame::Initialize() {
    frame = 0;

    CObject::Initialize();
}

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/object", __vt__12CObjectFrame__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/object", __vt__7CObject__DATA);
