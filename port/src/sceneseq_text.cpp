#include "common.h"

#include <string_view>

#include "mg_math.hpp"
#include "pal_timing.hpp"
#include "sceneseq.hpp"
#include "text/bounded.hpp"

namespace {

/**
 *
 * Converts a positive frame count from NTSC to the build's timing, keeping at least one frame.
 *
 */
int TimedFrames(int frames) {
    if (frames <= 0) {
        return frames;
    }
    const int converted = frames * PAL_TIMING(50, 60) / 60;
    return converted > 0 ? converted : 1;
}

} // namespace

// The scene sequence setters copy event-script names into 32-byte node names without a bound; each
// copy here is held to the node's field.
void CSceneCmrSeq::SetSyncObj(int kind, float *offset, float angle, float height, float dist, int option, char *frame_name) {
    _SEN_CMR_SEQ *node = SearchNextAhdSeq();
    if (node == nullptr) {
        return;
    }
    node->cmd = SCENE_CMR_CMD_SET_SYNC_OBJ;
    sceVu0CopyVector(node->vec1, offset);
    node->vec0[0] = angle;
    node->vec0[1] = height;
    node->vec0[2] = dist;
    node->frame = kind;
    node->mode = option;
    dc2::text::Copy(node->name, dc2::text::View(frame_name));
}

void CSceneObjSeq::SetEohFramePos(int eoh_no, char *frame_name, int frames, float *offset) {
    _SEN_OBJ_SEQ *node = SearchNextPosSeq();
    if (node == nullptr) {
        return;
    }
    node->cmd = SCENE_OBJ_CMD_SET_EOH_FRAME_POS;
    node->no = eoh_no;
    dc2::text::Copy(node->name, dc2::text::View(frame_name));
    node->sub_frame = TimedFrames(frames);
    sceVu0CopyVector(node->vec, offset);
}

void CSceneObjSeq::SetMotion(char *name, int frames, float speed) {
    _SEN_OBJ_SEQ *node = SearchNextMotSeq();
    if (node == nullptr) {
        return;
    }
    node->cmd = SCENE_OBJ_CMD_SET_MOTION;
    dc2::text::Copy(node->name, dc2::text::View(name));
    node->frame = frames;
    node->step = speed;
    node->ease_rate = 0;
}

void CSceneObjSeq::NextMotion(char *name, int frames, float speed) {
    _SEN_OBJ_SEQ *node = SearchNextMotSeq();
    if (node == nullptr) {
        return;
    }
    node->cmd = SCENE_OBJ_CMD_NEXT_MOTION;
    dc2::text::Copy(node->name, dc2::text::View(name));
    node->frame = frames;
    node->step = speed;
    node->ease_rate = 0;
}

void CSceneObjSeq::TexAnime(char *name, int frames) {
    _SEN_OBJ_SEQ *node = SearchNextAnmSeq();
    if (node == nullptr) {
        return;
    }
    node->cmd = SCENE_OBJ_CMD_TEX_ANIME;
    dc2::text::Copy(node->name, dc2::text::View(name));
    node->frame = frames;
}
