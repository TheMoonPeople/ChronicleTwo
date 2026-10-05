#include "common.h"
#include "object.hpp"

#include <libvu0.h>

#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"

// Code (.text)
void CObject::GetMatrix(float (*out_matrix)[4]) {
    mgUnitMatrix(out_matrix);
    out_matrix[0][0] = scale[0];
    out_matrix[1][1] = scale[1];
    out_matrix[2][2] = scale[2];

    if (rotation[0] != 0.0f) {
        sceVu0RotMatrixX(out_matrix, out_matrix, rotation[0]);
    }

    if (rotation[1] != 0.0f) {
        sceVu0RotMatrixY(out_matrix, out_matrix, rotation[1]);
    }

    if (rotation[2] != 0.0f) {
        sceVu0RotMatrixZ(out_matrix, out_matrix, rotation[2]);
    }

    *(u_long128 *)out_matrix[3] = *(u_long128 *)position;
    out_matrix[3][3] = 1.0f;
}

int CObject::FarClip(float dist, float *out_alpha) {
    float speed;
    int   in_range;
    int   draw;

    *out_alpha = 1.0f;
    speed = fade_speed;
    in_range = 1;

    if (far_dist > 0.0f && dist > far_dist) {
        in_range = 0;
    }

    // Leaving through the near distance fades twice as fast.
    if (near_dist > 0.0f && dist < near_dist) {
        in_range = 0;
        speed *= 2.0f;
    }

    draw = in_range && show && !draw_off;

    if (fade_alpha < 0.0f) {
        if (draw) {
            fade_alpha = 1.0f;
        } else {
            fade_alpha = 0.0f;
        }
    }

    if (fade) {
        if (draw) {
            fade_alpha += speed;
            if (fade_alpha > 1.0f) {
                fade_alpha = 1.0f;
            }
        } else {
            // Still drawn while it fades out.
            fade_alpha -= speed;
            if (fade_alpha <= 0.0f) {
                fade_alpha = 0.0f;
                draw = 0;
            } else {
                draw = 1;
            }
        }

        *out_alpha = fade_alpha;
    }

    return draw;
}

float CObject::GetCameraDist() {
    return mgGetDistFromCamera(position);
}

int CObject::CheckDraw() {
    float dist;

    if (fade) {
        if (fade_alpha != 0.0f) {
            return 1;
        }

        return 0;
    }

    if (!show || draw_off) {
        return 0;
    }

    dist = GetCameraDist();

    if (far_dist > 0.0f && dist > far_dist) {
        return 0;
    }

    if (near_dist > 0.0f && dist < near_dist) {
        return 0;
    }

    return 1;
}

void CObject::DrawStep() {
    float alpha;

    FarClip(GetCameraDist(), &alpha);
}

float CObject::GetAlpha() {
    if (fade) {
        return fade_alpha;
    }

    if (CheckDraw()) {
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
    if (frame != NULL) {
        frame->SetPosition(position);
        frame->SetRotation(rotation);
        frame->SetScale(scale);
    }
}

void CObjectFrame::DrawStep() {
    CObject::DrawStep();
}

float CObjectFrame::GetCameraDist() {
    sceVu0FVECTOR world_position;

    frame->GetWorldPosition0(world_position);
    return mgGetDistFromCamera(world_position);
}

int CObjectFrame::PreDraw() {
    float alpha;
    int   draw;

    draw = 0;

    if (frame != NULL) {
        UpDatePosition();
        CObject::PreDraw();
        draw = FarClip(GetCameraDist(), &alpha);

        if (draw && fade) {
            frame->SetAttrParamObjAlpha(alpha, 1);
        }
    }

    return draw;
}
int CObjectFrame::Draw() {
    if (CObjectFrame::PreDraw() == 0) {
        return 0;
    }
    mgDraw(frame);
    return 0;
}

int CObjectFrame::DrawDirect() {
    if (!CObjectFrame::PreDraw()) {
        return 0;
    }

    mgDrawDirect(frame);
    return 0;
}

void CObjectFrame::Copy(CObjectFrame &dest, mgCMemory *memory) {
    (CObject &)dest = *this;

    // The frame is shared whether or not the copy has memory to duplicate it into.
    if (memory == NULL) {
        dest.frame = frame;
    } else {
        dest.frame = frame;
    }

    dest.far_dist = far_dist;
    dest.fade = fade;
    dest.fade_alpha = -1.0f;
}

void CObjectFrame::Initialize() {
    frame = NULL;
    CObject::Initialize();
}

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/object", __vt__12CObjectFrame__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/object", __vt__7CObject__DATA);
