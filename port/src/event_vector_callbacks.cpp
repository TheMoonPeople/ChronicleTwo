#include "common.h"
#include "mw_runtime.h"

#include "dng_main.hpp"
#include "event_func.hpp"
#include "event_vector_callbacks.hpp"
#include "mg_math.hpp"
#include "sceneseq.hpp"

namespace {
int Integer(const RS_STACKDATA &slot) {
    return slot.type == RS_FLOAT ? fptosi(slot.val.f) : slot.val.i;
}

float Number(const RS_STACKDATA &slot) {
    return slot.type == RS_INT ? static_cast<float>(slot.val.i) : slot.val.f;
}

void Vector(float *out, const RS_STACKDATA *slots) {
    for (int i = 0; i < 3; ++i) {
        out[i] = Number(slots[i]);
    }
    out[3] = 1.0f;
}

int Distance(RS_STACKDATA *stack, int /*unused*/) {
    float vector[4];
    Vector(vector, stack);
    if (stack[3].type == RS_PTR) {
        stack[3].val.p->val.f = mgDistVector(vector);
    }
    return true;
}

int DistanceBetween(RS_STACKDATA *stack, int /*unused*/) {
    float from[4];
    float to[4];
    Vector(from, stack);
    Vector(to, stack + 3);
    if (stack[6].type == RS_PTR) {
        stack[6].val.p->val.f = mgDistVector(from, to);
    }
    return true;
}

int AttributeStatus(RS_STACKDATA *stack, int argc) {
    if (argc != 4) {
        return false;
    }
    float position[4];
    Vector(position, stack);
    if (stack[3].type == RS_PTR) {
        stack[3].val.p->val.i = AutoMapGen.GetAttrStatus(position);
    }
    return true;
}

int SetFramePosition(RS_STACKDATA *stack, int argc) {
    int   slot = 0;
    int   handle = 0;
    int   frames = 0;
    char *name = nullptr;
    float offset[4]{};
    switch (argc) {
        case 3:
        case 4:
        case 6:
        case 7:
            slot = Integer(stack[0]);
            handle = Integer(stack[1]);
            name = stack[2].val.s;
            if (argc == 4) {
                frames = Integer(stack[3]);
            }
            if (argc >= 6) {
                Vector(offset, stack + 3);
            }
            if (argc == 7) {
                frames = Integer(stack[6]);
            }
            break;
        default:
            return false;
    }
    if (slot < 0 || slot >= EVENT_OBJECT_SEQ_NUM) {
        return false;
    }
    ObjectSeq[slot].SetEohFramePos(handle, name, frames, offset);
    return true;
}
} // namespace

void ReplaceEventVectorCallbacks(int (**table)(RS_STACKDATA *, int)) {
    table[EVENT_EXT_DIST_VECTOR] = Distance;
    table[EVENT_EXT_DIST_VECTOR2] = DistanceBetween;
    table[EVENT_EXT_AMG_GET_ATTR_STATUS] = AttributeStatus;
    table[EVENT_EXT_OBJS_SET_EOH_FRAME_POS] = SetFramePosition;
}
