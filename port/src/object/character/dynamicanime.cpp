#include "common.h"

#include <cstdio>
#include <cstring>
#include <limits>

#include "dynamicanime.hpp"
#include "log/game_output.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "scriptinterpreter.hpp"

/**
 *
 * Dynamic animation receiving script commands.
 *
 */
static CDynamicAnime *dynNowDA;

/**
 *
 * Memory used by the current dynamic animation script.
 *
 */
static mgCMemory *dynStack;

namespace {
template <typename T>
std::size_t TableQuadwords(int count) {
    return count > 0 ? (static_cast<std::size_t>(count) * sizeof(T) + 15) / 16 : 0;
}

bool CanAllocateTables(mgCMemory *memory, std::size_t quadwords) {
    if (memory == nullptr || memory->lock != 0 || quadwords == 0 ||
        quadwords > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
        return false;
    }
    return quadwords < dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128);
}
} // namespace

/**
 *
 * Root frame used to resolve animation frame names.
 *
 */
static mgCFrame *dynTopFrame;

/**
 *
 * Number of animation frames read from the script.
 *
 */
static int dynFrameCount;

/**
 *
 * Number of animation vertices read from the script.
 *
 */
static int dynVertexCount;

/**
 *
 * Number of fixed vertices read from the script.
 *
 */
static int dynFixVertexCount;

/**
 *
 * Number of vertex bindings read from the script.
 *
 */
static int dynBindVertexCount;

/**
 *
 * Number of bounding boxes read from the script.
 *
 */
static int dynBBoxCount;

/**
 *
 * Number of collision shapes read from the script.
 *
 */
static int dynColCount;

/**
 *
 * Rounds a byte count up to a number of 16-byte allocation blocks.
 *
 */
static inline u_int align16_blocks(u_int size) {
    if (size & 15) {
        return (size >> 4) + 1;
    }

    return size >> 4;
}

/**
 *
 * Pulls two bound points toward their target separation.
 *
 */
static void BindPosition(float *a, float *b, float length, float rate) {
    float delta[4];
    float pull_a[4];
    float pull_b[4];
    float distance = {};
    float excess = {};

    sceVu0SubVector(delta, a, b);
    distance = mgDistVector(delta);
    excess = distance - length;
    sceVu0ScaleVector(pull_a, delta, (1.0f - rate) * excess / distance);
    sceVu0ScaleVector(pull_b, delta, rate * excess / distance);
    mgSubVector(a, pull_a);
    mgAddVector(b, pull_b);
}

void CDynamicAnime::ResetPosition() {
    float matrix[4][4];
    int   i = {};

    if (top_frame != nullptr) {
        top_frame->GetLWMatrix(matrix);
        mgApplyMatrixN(now_vertex, matrix, init_vertex, vertex_num);
    }

    for (i = 0; i < vertex_num; i++) {
        mgZeroVector(velocity[i]);
        std::memmove(&old_vertex[i], &now_vertex[i], sizeof(u_long128));
    }
}

/**
 *
 * Advances the wind's random sequence and gives its next value, between -1.0 and 1.0.
 *
 */
static inline float WindRand(int *seed) {
    *seed = *seed * 0x10DCD + 1;
    return static_cast<float>(*seed) / -2147483648.0f;
}

void CDynamicAnime::Step() {
    sceVu0FMATRIX   matrix;
    sceVu0FVECTOR   pull;
    sceVu0FVECTOR   max;
    sceVu0FVECTOR   min;
    sceVu0FVECTOR   wind;
    DA_FIX_VERTEX  *fixed = {};
    DA_BIND_VERTEX *bound = {};
    mgCFrame       *fixed_frame = {};
    float           stiffness = {};
    float           friction = {};
    int             hit = {};
    CDACollision   *volume = {};
    int             i = {};
    int             j = {};

    if (vertex_num <= 0) {
        return;
    }

    stiffness = k;

    if (top_frame != nullptr) {
        top_frame->GetLWMatrix(matrix);
    } else {
        stiffness = 0.0f;
    }

    if (stiffness > 0.0f) {
        mgApplyMatrixN(world_init_vertex, matrix, init_vertex, vertex_num);
    }

    for (i = 0; i < vertex_num; i++) {
        mgAddVector(velocity[i], gravity);
        velocity[i][3] = 0.0f;
        mgAddVector(now_vertex[i], velocity[i]);
    }

    for (j = 0; j < 6; j++) {
        for (i = 0; i < bind_vertex_num; i++) {
            bound = &bind_vertex[i];
            BindPosition(now_vertex[bound->vertex_id[0]], now_vertex[bound->vertex_id[1]], bound->length, bound->rate);
        }

        for (i = 0; i < vertex_num; i++) {
            fixed = &fix_vertex[i];

            if (fixed->weight >= 1.0f) {
                fixed_frame = GetFrame(fixed->frame_id);

                if (fixed_frame == nullptr) {
                    return;
                }

                fixed_frame->GetWorldPosition(now_vertex[i], fixed->position);
            }
        }
    }

    sceVu0CopyVector(max, now_vertex[0]);
    sceVu0CopyVector(min, now_vertex[0]);
    PreCollision();

    for (j = 0; j < vertex_num; j++) {
        sceVu0SubVector(velocity[j], now_vertex[j], old_vertex[j]);
        std::memmove(old_vertex[j], now_vertex[j], sizeof(u_long128));
        fixed = &fix_vertex[j];

        if (fixed->weight < 1.0f && fixed->weight > 0.0f) {
            fixed_frame = GetFrame(fixed->frame_id);

            if (fixed_frame != nullptr) {
                fixed_frame->GetWorldPosition(pull, fixed->position);
                mgSubVector(pull, now_vertex[j]);
                sceVu0ScaleVector(pull, pull, fixed->weight);
                mgAddVector(now_vertex[j], pull);
                sceVu0ScaleVector(pull, pull, fixed->velocity_rate);
                mgSubVector(velocity[j], pull);
            }
        }

        friction = 1.0f;
        hit = false;

        if (fixed->weight < 1.0f) {
            for (i = 0; i < collision_num; i++) {
                volume = collision[i];

                if (volume != nullptr) {
                    hit |= volume->CheckHit(now_vertex[j]);

                    if (friction > volume->friction) {
                        friction = volume->friction;
                    }
                }
            }

            if (hit) {
                sceVu0ScaleVector(velocity[j], velocity[j], friction);
            }
        }

        if (floor_enable) {
            if (now_vertex[j][1] < floor_y) {
                now_vertex[j][1] = floor_y;
                sceVu0ScaleVector(velocity[j], velocity[j], 0.3f);
            }
        }

        if (wind_power != 0.0f) {
            wind_gust += 0.5f * (WindRand(&wind_seed) - 0.5f);

            if (wind_gust > 1.0f) {
                wind_gust = 1.0f;
            }

            if (wind_gust < 0.0f) {
                wind_gust = 0.0f;
            }

            sceVu0ScaleVector(wind, wind_dir, wind_scale * (wind_power * wind_gust));
            mgAddVector(velocity[j], wind);
        }

        mgVectorMaxMin(max, min, max, min, now_vertex[j]);
    }

    for (i = 0; i < frame_num; i++) {
        FramePose(frame[i], &frame_pose[i]);
    }
}

int CDACollision::CheckHit(float *position) { return false; }

void CDynamicAnime::SetWind(float power, float *direction) {
    wind_power = power;
    sceVu0Normalize(wind_dir, direction);
}

void CDynamicAnime::ResetWind() {
    wind_power = 0.0f;
}

void CDynamicAnime::SetFloor(float height) {
    floor_enable = true;
    floor_y = height;
}

void CDynamicAnime::ResetFloor() {
    floor_enable = false;
}

void CDynamicAnime::FramePose(mgCFrame *frame, DA_FRAME_POSE *pose) {
    int           across_axis = {};
    sceVu0FMATRIX matrix;
    float        *v2 = {};
    int           cross_axis = {};
    int           along_axis = {};
    int           first_axis = {};
    int           second_axis = {};
    float        *v3 = {};
    float        *v0 = {};
    float        *v1 = {};

    if (frame == nullptr) {
        return;
    }

    across_axis = 0;
    cross_axis = 1;
    along_axis = 2;
    first_axis = 2;
    second_axis = 0;

    if (pose->type == DA_FRAME_POSE_BONE || pose->type == DA_FRAME_POSE_BONE_YX) {
        if (pose->type == DA_FRAME_POSE_BONE_YX) {
            cross_axis = 2;
            first_axis = 0;
            along_axis = 1;
            second_axis = 1;
            across_axis = 0;
        }
        sceVu0FVECTOR origin;
        sceVu0FVECTOR end;
        sceVu0FVECTOR across;
        sceVu0FVECTOR along;

        v0 = now_vertex[pose->vertex_id[0]];
        v1 = now_vertex[pose->vertex_id[1]];
        v2 = now_vertex[pose->vertex_id[2]];
        v3 = now_vertex[pose->vertex_id[3]];
        sceVu0AddVector(origin, v0, v1);
        sceVu0ScaleVector(origin, origin, 0.5f);
        sceVu0AddVector(end, v2, v3);
        sceVu0ScaleVector(end, end, 0.5f);
        sceVu0SubVector(along, v1, v0);
        sceVu0Normalize(matrix[along_axis], along);
        matrix[along_axis][3] = 0.0f;
        sceVu0SubVector(across, end, origin);
        sceVu0Normalize(matrix[across_axis], across);
        matrix[across_axis][3] = 0.0f;
        sceVu0OuterProduct(matrix[cross_axis], matrix[first_axis], matrix[second_axis]);
        matrix[cross_axis][3] = 0.0f;
        sceVu0OuterProduct(matrix[first_axis], matrix[second_axis], matrix[cross_axis]);
        sceVu0Normalize(matrix[first_axis], matrix[first_axis]);
        sceVu0CopyVector(matrix[3], origin);
        matrix[3][3] = 1.0f;

        switch (pose->local) {
            case 0:
                break;
            default:
                if (frame->parent != nullptr) {
                    sceVu0FMATRIX parent_matrix;

                    frame->parent->GetLWMatrix(parent_matrix);
                    mgInversMatrix(parent_matrix, parent_matrix);
                    mgMulMatrix(matrix, parent_matrix, matrix);
                }
        }

        frame->SetTransMatrix(matrix);
        return;
    }

    if (pose->type == DA_FRAME_POSE_B_CDLR) {
        sceVu0FVECTOR along;

        v0 = now_vertex[pose->vertex_id[0]];
        v2 = now_vertex[pose->vertex_id[2]];
        v3 = now_vertex[pose->vertex_id[3]];
        v1 = now_vertex[pose->vertex_id[1]];
        sceVu0SubVector(matrix[0], v1, v0);
        matrix[0][3] = 0.0f;
        sceVu0Normalize(matrix[0], matrix[0]);
        sceVu0SubVector(along, v2, v3);
        along[3] = 0.0f;
        sceVu0Normalize(matrix[2], along);
        sceVu0OuterProduct(matrix[1], matrix[2], matrix[0]);
        matrix[1][3] = 0.0f;
        sceVu0CopyVector(matrix[3], v0);
        matrix[3][3] = 1.0f;

        if (pose->local && frame->parent != nullptr) {
            sceVu0FMATRIX parent_matrix;

            frame->parent->GetLWMatrix(parent_matrix);
            mgInversMatrix(parent_matrix, parent_matrix);
            mgMulMatrix(matrix, parent_matrix, matrix);
        }

        frame->SetTransMatrix(matrix);
    }
}

void CDynamicAnime::PreCollision() {
    int           i = {};
    CDACollision *col = {};

    for (i = 0; i < collision_num; i++) {
        col = collision[i];

        if (col != nullptr) {
            col->frame = GetFrame(col->frame_id);

            if (col->frame != nullptr) {
                col->frame->GetLWMatrix(col->lw_matrix);
                mgInversMatrix(col->inverse_matrix, col->lw_matrix);
            }
        }
    }
}

void CDynamicAnime::Initialize() {
    top_frame = nullptr;
    frame_num = 0;
    frame = nullptr;
    frame_pose = nullptr;
    vertex_num = 0;
    init_vertex = nullptr;
    now_vertex = nullptr;
    old_vertex = nullptr;
    velocity = nullptr;
    world_init_vertex = nullptr;
    fix_vertex_num = 0;
    fix_vertex = nullptr;
    draw_frame_num = 0;
    draw_frame = nullptr;
    bind_vertex_num = 0;
    bind_vertex = nullptr;
    bbox_num = 0;
    bbox = nullptr;
    collision_num = 0;
    collision = nullptr;
    mgZeroVector(gravity);
    gravity[1] = -0.6f;
    k = 0.0f;
    wind_power = 0.0f;
    mgZeroVector(wind_dir);
    wind_seed = 0x1E69D;
    wind_gust = 0.0f;
    wind_scale = 1.0f;
    floor_enable = false;
    floor_y = -100000.0f;
}

void CDynamicAnime::NewFrameTable(int count, mgCMemory *memory) {
    frame_num = 0;
    frame = nullptr;
    frame_pose = nullptr;
    const auto frame_blocks = TableQuadwords<mgCFrame *>(count);
    const auto pose_blocks = TableQuadwords<DA_FRAME_POSE>(count);
    if (!CanAllocateTables(memory, frame_blocks + pose_blocks)) {
        return;
    }
    frame = dc2::memory::NewArray<mgCFrame *>(*memory, static_cast<std::size_t>(count));
    frame_pose = dc2::memory::NewArray<DA_FRAME_POSE>(*memory, static_cast<std::size_t>(count));
    if (frame == nullptr || frame_pose == nullptr) {
        frame = nullptr;
        frame_pose = nullptr;
        return;
    }
    frame_num = count;

    for (int i = 0; i < frame_num; i++) {
        frame[i] = nullptr;
        memset(&frame_pose[i], 0, sizeof(DA_FRAME_POSE));
    }
}

void CDynamicAnime::NewVertexTable(int count, mgCMemory *memory) {
    vertex_num = 0;
    init_vertex = nullptr;
    now_vertex = nullptr;
    old_vertex = nullptr;
    velocity = nullptr;
    world_init_vertex = nullptr;
    const auto blocks = TableQuadwords<sceVu0FVECTOR>(count);
    if (!CanAllocateTables(memory, blocks * 5)) {
        return;
    }
    init_vertex = dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(count));
    now_vertex = dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(count));
    old_vertex = dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(count));
    velocity = dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(count));
    world_init_vertex = dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(count));
    if (init_vertex == nullptr || now_vertex == nullptr || old_vertex == nullptr || velocity == nullptr ||
        world_init_vertex == nullptr) {
        init_vertex = now_vertex = old_vertex = velocity = world_init_vertex = nullptr;
        return;
    }
    vertex_num = count;

    for (int i = 0; i < vertex_num; i++) {
        mgZeroVector(init_vertex[i]);
        mgZeroVector(now_vertex[i]);
        mgZeroVector(old_vertex[i]);
        mgZeroVector(velocity[i]);
        mgZeroVector(world_init_vertex[i]);
    }
}

void CDynamicAnime::NewFixVertexTable(int count, mgCMemory *memory) {
    fix_vertex_num = 0;
    fix_vertex = nullptr;
    const auto blocks = TableQuadwords<DA_FIX_VERTEX>(count);
    if (!CanAllocateTables(memory, blocks)) {
        return;
    }
    fix_vertex = dc2::memory::NewArray<DA_FIX_VERTEX>(*memory, static_cast<std::size_t>(count));
    if (fix_vertex == nullptr) {
        return;
    }
    fix_vertex_num = count;

    for (int i = 0; i < fix_vertex_num; i++) {
        memset(&fix_vertex[i], 0, sizeof(DA_FIX_VERTEX));
    }
}

void CDynamicAnime::NewDrawFrameTable(int count, mgCMemory *memory) {
    draw_frame_num = 0;
    draw_frame = nullptr;
    const auto blocks = TableQuadwords<int>(count);
    if (!CanAllocateTables(memory, blocks)) {
        return;
    }
    draw_frame = dc2::memory::NewArray<int>(*memory, static_cast<std::size_t>(count));
    if (draw_frame == nullptr) {
        return;
    }
    draw_frame_num = count;

    for (int i = 0; i < draw_frame_num; i++) {
        draw_frame[i] = -1;
    }
}

void CDynamicAnime::NewBindVertexTable(int count, mgCMemory *memory) {
    bind_vertex_num = 0;
    bind_vertex = nullptr;
    const auto blocks = TableQuadwords<DA_BIND_VERTEX>(count);
    if (!CanAllocateTables(memory, blocks)) {
        return;
    }
    bind_vertex = dc2::memory::NewArray<DA_BIND_VERTEX>(*memory, static_cast<std::size_t>(count));
    if (bind_vertex == nullptr) {
        return;
    }
    bind_vertex_num = count;

    for (int i = 0; i < bind_vertex_num; i++) {
        memset(&bind_vertex[i], 0, sizeof(DA_BIND_VERTEX));
    }
}

void CDynamicAnime::NewBoundingBoxTable(int count, mgCMemory *memory) {
    bbox_num = 0;
    bbox = nullptr;
    const auto blocks = TableQuadwords<DA_BOUNDING_BOX>(count);
    if (!CanAllocateTables(memory, blocks)) {
        return;
    }
    bbox = dc2::memory::NewArray<DA_BOUNDING_BOX>(*memory, static_cast<std::size_t>(count));
    if (bbox == nullptr) {
        return;
    }
    bbox_num = count;

    for (int i = 0; i < bbox_num; i++) {
        memset(&bbox[i], 0, sizeof(DA_BOUNDING_BOX));
        bbox[i].frame_id = -1;
    }
}

void CDynamicAnime::NewCollisionTable(int count, mgCMemory *memory) {
    collision_num = 0;
    collision = nullptr;
    const auto blocks = TableQuadwords<CDACollision *>(count);
    if (!CanAllocateTables(memory, blocks)) {
        return;
    }
    collision = dc2::memory::NewArray<CDACollision *>(*memory, static_cast<std::size_t>(count));
    if (collision == nullptr) {
        return;
    }
    collision_num = count;

    for (int i = 0; i < collision_num; i++) {
        collision[i] = nullptr;
    }
}

void CDynamicAnime::SetFrame(int index, mgCFrame *new_frame) {
    if (index < 0 || index >= frame_num) {
        return;
    }

    frame[index] = new_frame;
}

mgCFrame *CDynamicAnime::GetFrame(int index) {
    if (index < 0 || index >= frame_num) {
        return nullptr;
    }

    return frame[index];
}

DA_FRAME_POSE *CDynamicAnime::pGetFramePose(int index) {
    if (index < 0 || index >= frame_num) {
        return nullptr;
    }

    return frame_pose + index;
}

int CDynamicAnime::CheckVertexID(int index) {
    if (index < 0 || index >= vertex_num) {
        return false;
    }

    return true;
}

void CDynamicAnime::SetInitVertex(int index, float *pos) {
    if (CheckVertexID(index)) {
        std::memmove(&init_vertex[index], pos, sizeof(u_long128));
    }
}

void CDynamicAnime::GetInitVertex(int index, float *pos) {
    if (CheckVertexID(index)) {
        std::memmove(pos, &init_vertex[index], sizeof(u_long128));
    }
}

void CDynamicAnime::SetNowVertex(int index, float *pos) {
    if (CheckVertexID(index)) {
        std::memmove(&now_vertex[index], pos, sizeof(u_long128));
    }
}

void CDynamicAnime::SetOldVertex(int index, float *pos) {
    if (CheckVertexID(index)) {
        std::memmove(&old_vertex[index], pos, sizeof(u_long128));
    }
}

DA_FIX_VERTEX *CDynamicAnime::pGetFixVertex(int index) {
    if (index < 0 || index >= fix_vertex_num) {
        return nullptr;
    }

    return fix_vertex + index;
}

void CDynamicAnime::SetDrawFrame(int index, int frame) {
    if (index < 0 || index >= draw_frame_num) {
        return;
    }

    draw_frame[index] = frame;
}

mgCFrame *CDynamicAnime::GetDrawFrame(int index) {
    if (index < 0 || index >= draw_frame_num) {
        return nullptr;
    }

    return GetFrame(draw_frame[index]);
}

DA_BIND_VERTEX *CDynamicAnime::pGetBindVertex(int index) {
    if (index < 0 || index >= bind_vertex_num) {
        return nullptr;
    }

    return bind_vertex + index;
}

DA_BOUNDING_BOX *CDynamicAnime::pGetBoundingBox(int index) {
    if (index < 0 || index >= bbox_num) {
        return nullptr;
    }

    return bbox + index;
}

void CDynamicAnime::SetCollision(int index, CDACollision *new_collision) {
    if (index < 0 || index >= collision_num) {
        return;
    }

    collision[index] = new_collision;
}

int CDynamicAnime::DrawSub(int direct) {
    int sum = 0;

    for (int i = 0; i < draw_frame_num; i++) {
        if (direct) {
            sum += mgDrawDirect(GetDrawFrame(i));
        } else {
            sum += mgDraw(GetDrawFrame(i));
        }
    }

    return sum;
}

void CDynamicAnime::Copy(CDynamicAnime &destination, mgCFrame *root, mgCMemory *memory) {
    int index = {};
    destination = *this;
    destination.top_frame = root;

    if (root == nullptr || memory == nullptr) {
        return;
    }

    if (frame_num > 0 && frame != nullptr) {
        destination.frame = dc2::memory::NewArray<mgCFrame *>(*memory, static_cast<std::size_t>(frame_num));

        if (destination.frame == nullptr) {
            destination.frame_num = 0;
            return;
        }

        for (index = 0; index < frame_num; index++) {
            destination.frame[index] = nullptr;

            if (frame[index] != nullptr) {
                destination.frame[index] = root->GetFrame(root->SearchFrameID(frame[index]->name));
            }
        }
    }

    if (vertex_num > 0) {
        if (init_vertex == nullptr || now_vertex == nullptr || old_vertex == nullptr ||
            velocity == nullptr || world_init_vertex == nullptr) {
            return;
        }
        destination.init_vertex = dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(vertex_num));
        destination.now_vertex = dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(vertex_num));
        destination.old_vertex = dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(vertex_num));
        destination.velocity = dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(vertex_num));
        destination.world_init_vertex = dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(vertex_num));
        if (destination.init_vertex == nullptr || destination.now_vertex == nullptr ||
            destination.old_vertex == nullptr || destination.velocity == nullptr ||
            destination.world_init_vertex == nullptr) {
            destination.vertex_num = 0;
            return;
        }

        for (index = 0; index < vertex_num; index++) {
            std::memmove(destination.init_vertex[index], init_vertex[index], sizeof(u_long128));
            std::memmove(destination.now_vertex[index], now_vertex[index], sizeof(u_long128));
            std::memmove(destination.old_vertex[index], old_vertex[index], sizeof(u_long128));
            std::memmove(destination.velocity[index], velocity[index], sizeof(u_long128));
            std::memmove(destination.world_init_vertex[index], world_init_vertex[index], sizeof(u_long128));
        }
    }
}

/**
 *
 * Allocates the frame reference table for a dynamic animation.
 *
 */
static int dynFRAME_START(dc2::script::TagArguments stack, int argc) {
    dynNowDA->NewFrameTable(dc2::script::TagInteger(stack), dynStack);
    return true;
}

/**
 *
 * Adds a named model frame to the dynamic animation.
 *
 */
static int dynFRAME(dc2::script::TagArguments stack, int argc) {
    char     *name = {};
    mgCFrame *frame = {};

    name = dc2::script::TagCString(stack);

    if (name == nullptr) {
        return false;
    }

    frame = dynTopFrame->SearchFrame(name);

    if (frame == nullptr) {
        dc2::log::PrintGame("not found %s\n", name);
    }

    dynNowDA->SetFrame(dynFrameCount++, frame);
    return true;
}

/**
 *
 * Accepts the end of the dynamic animation frame table.
 *
 */
static int dynFRAME_END(dc2::script::TagArguments stack, int argc) {
    return true;
}

/**
 *
 * Allocates the initial vertex table for a dynamic animation.
 *
 */
static int dynVERTEX_START(dc2::script::TagArguments stack, int argc) {
    dynNowDA->NewVertexTable(dc2::script::TagInteger(stack), dynStack);
    return true;
}

/**
 *
 * Adds an initial vertex offset from a frame world position.
 *
 */
static int dynVERTEX(dc2::script::TagArguments stack, int argc) {
    float     offset[4];
    float     world[4];
    mgCFrame *frame = {};
    int       frame_id = {};

    frame_id = dc2::script::TagInteger(stack++);
    dc2::script::TagVector(offset, stack);
    frame = dynNowDA->GetFrame(frame_id);

    if (frame != nullptr) {
        frame->GetWorldPosition0(world);
        world[3] = 1.0f;
        world[0] += offset[0];
        world[1] += offset[1];
        world[2] += offset[2];
        dynNowDA->SetInitVertex(dynVertexCount++, world);
    }

    return true;
}

/**
 *
 * Adds an initial vertex transformed from frame local coordinates.
 *
 */
static int dynVERTEX_L(dc2::script::TagArguments stack, int argc) {
    float     local[4];
    float     world[4];
    int       frame_id = {};
    mgCFrame *frame = {};
    int       vertex_index = {};

    frame_id = dc2::script::TagInteger(stack++);
    dc2::script::TagVector(local, stack);
    frame = dynNowDA->GetFrame(frame_id);

    if (frame != nullptr) {
        local[3] = 1.0f;
        frame->GetWorldPosition(world, local);
        vertex_index = dynVertexCount;
        world[3] = 1.0f;
        dynVertexCount = vertex_index + 1;
        dynNowDA->SetInitVertex(vertex_index, world);
    }

    return true;
}

/**
 *
 * Copies initial vertices into the current and previous positions.
 *
 */
static int dynVERTEX_END(dc2::script::TagArguments stack, int argc) {
    float vertex[4];
    int   i = {};
    int   count = {};

    count = dynNowDA->vertex_num;

    for (i = 0; i < count; i++) {
        dynNowDA->GetInitVertex(i, vertex);
        dynNowDA->SetOldVertex(i, vertex);
        dynNowDA->SetNowVertex(i, vertex);
    }

    return true;
}

/**
 *
 * Allocates the fixed vertex table for a dynamic animation.
 *
 */
static int dynFIX_VERTEX_START(dc2::script::TagArguments stack, int argc) {
    dc2::script::TagInteger(stack);
    dynNowDA->NewFixVertexTable(dynNowDA->vertex_num, dynStack);
    return true;
}

/**
 *
 * Finds and initializes a fixed vertex relative to its frame.
 *
 */
static DA_FIX_VERTEX *dynFixVertex(dc2::script::TagArguments stack, int argc) {
    int            frame_id = {};
    int            vertex_index = {};
    DA_FIX_VERTEX *fix = {};
    mgCFrame      *frame = {};
    float          matrix[4][4];
    float          init[4];

    frame_id = dc2::script::TagInteger(stack++);
    vertex_index = dc2::script::TagInteger(stack);
    fix = dynNowDA->pGetFixVertex(vertex_index);

    if (fix == nullptr) {
        return nullptr;
    }
    fix->frame_id = frame_id;

    frame = dynNowDA->GetFrame(fix->frame_id);

    if (frame == nullptr || !dynNowDA->CheckVertexID(vertex_index)) {
        fix->frame_id = -1;
        return nullptr;
    }

    dynNowDA->GetInitVertex(vertex_index, init);
    init[3] = 1.0f;
    frame->GetInverseMatrix(matrix);
    sceVu0ApplyMatrix(fix->position, matrix, init);
    fix->position[3] = 1.0f;
    fix->weight = 1.0f;
    fix->velocity_rate = 0.0f;
    fix->unk_1c = 1.0f;
    return fix;
}

/**
 *
 * Configures a fixed vertex without velocity transfer.
 *
 */
static int dynFIX_VERTEX(dc2::script::TagArguments stack, int argc) {
    DA_FIX_VERTEX *fix = {};

    fix = dynFixVertex(stack, argc);
    stack = stack + 2;

    if (fix == nullptr) {
        return false;
    }

    if (argc >= 3) {
        fix->weight = dc2::script::TagFloat(stack++);
    }

    if (argc >= 4) {
        fix->unk_1c = dc2::script::TagFloat(stack);
    }

    fix->velocity_rate = 0.0f;
    return true;
}

/**
 *
 * Configures a fixed vertex with positive velocity transfer.
 *
 */
static int dynFIX_VERTEX_C(dc2::script::TagArguments stack, int argc) {
    DA_FIX_VERTEX *fix = {};

    fix = dynFixVertex(stack, argc);
    stack = stack + 2;

    if (fix == nullptr) {
        return false;
    }

    if (argc >= 3) {
        fix->weight = dc2::script::TagFloat(stack++);
    }

    if (argc >= 4) {
        fix->unk_1c = dc2::script::TagFloat(stack);
    }

    fix->velocity_rate = 1.0f;
    return true;
}

/**
 *
 * Configures a fixed vertex with negative velocity transfer.
 *
 */
static int dynFIX_VERTEX_S(dc2::script::TagArguments stack, int argc) {
    DA_FIX_VERTEX *fix = {};

    fix = dynFixVertex(stack, argc);
    stack = stack + 2;

    if (fix == nullptr) {
        return false;
    }

    if (argc >= 3) {
        fix->weight = dc2::script::TagFloat(stack++);
    }

    if (argc >= 4) {
        fix->unk_1c = dc2::script::TagFloat(stack);
    }

    fix->velocity_rate = -1.0f;
    return true;
}

/**
 *
 * Accepts the end of the fixed vertex table.
 *
 */
static int dynFIX_VERTEX_END(dc2::script::TagArguments stack, int argc) {
    return true;
}

/**
 *
 * Creates a frame pose from a type and four vertex references.
 *
 */
static DA_FRAME_POSE *FRAME_POSE_Sub(dc2::script::TagArguments stack, int argc) {
    DA_FRAME_POSE *pose = {};
    char          *kind = {};
    int            i = {};

    pose = dynNowDA->pGetFramePose(dc2::script::TagInteger(stack++));
    kind = dc2::script::TagCString(stack++);

    if (pose == nullptr || kind == nullptr) {
        return nullptr;
    }

    pose->type = DA_FRAME_POSE_NONE;

    if (strcmp(kind, "bone") == 0) {
        if (argc < 6) {
            return nullptr;
        }

        pose->type = DA_FRAME_POSE_BONE;
        pose->vertex_num = 4;
    } else if (strcmp(kind, "bone_yx") == 0) {
        if (argc < 6) {
            return nullptr;
        }

        pose->type = DA_FRAME_POSE_BONE_YX;
        pose->vertex_num = 4;
    } else if (strcmp(kind, "b_cdlr") == 0) {
        if (argc < 6) {
            return nullptr;
        }

        pose->type = DA_FRAME_POSE_B_CDLR;
        pose->vertex_num = 4;
    } else {
        return nullptr;
    }

    if (dynStack == nullptr) {
        return nullptr;
    }
    pose->vertex_id = dc2::memory::NewArray<int>(*dynStack, static_cast<std::size_t>(pose->vertex_num));
    if (pose->vertex_id == nullptr) {
        pose->type = DA_FRAME_POSE_NONE;
        return nullptr;
    }

    for (i = 0; i < pose->vertex_num; i++) {
        pose->vertex_id[i] = dc2::script::TagInteger(stack++);

        if (!dynNowDA->CheckVertexID(pose->vertex_id[i])) {
            dc2::log::PrintGame("error vertex no %d!!\n", pose->vertex_id[i]);
            pose->type = DA_FRAME_POSE_NONE;
            return nullptr;
        }
    }

    return pose;
}

/**
 *
 * Marks a scripted frame pose as local to its frame.
 *
 */
static int dynFRAME_POSE_L(dc2::script::TagArguments stack, int argc) {
    DA_FRAME_POSE *pose = {};
    mgCFrame      *frame = {};

    pose = FRAME_POSE_Sub(stack, argc);
    frame = dynNowDA->GetFrame(dc2::script::TagInteger(stack));

    if (pose == nullptr || frame == nullptr) {
        return false;
    }

    pose->local = true;
    return true;
}

/**
 *
 * Marks a scripted frame pose as world-relative and detaches its frame.
 *
 */
static int dynFRAME_POSE(dc2::script::TagArguments stack, int argc) {
    mgCFrame      *frame = {};
    DA_FRAME_POSE *pose = {};

    pose = FRAME_POSE_Sub(stack, argc);
    frame = dynNowDA->GetFrame(dc2::script::TagInteger(stack));

    if (pose == nullptr || frame == nullptr) {
        return false;
    }

    pose->local = false;
    frame->DeleteParent();
    return true;
}

/**
 *
 * Sets the frames drawn by the dynamic animation.
 *
 */
static int dynDRAW_FRAME(dc2::script::TagArguments stack, int argc) {
    int i = {};

    dynNowDA->NewDrawFrameTable(argc, dynStack);

    for (i = 0; i < argc; i++) {
        dynNowDA->SetDrawFrame(i, dc2::script::TagInteger(stack++));
    }

    return true;
}

/**
 *
 * Allocates the vertex distance constraint table.
 *
 */
static int dynBIND_VERTEX_START(dc2::script::TagArguments stack, int argc) {
    dynNowDA->NewBindVertexTable(dc2::script::TagInteger(stack), dynStack);
    return true;
}

/**
 *
 * Connects two vertices with a weighted distance constraint.
 *
 */
static int dynBIND_VERTEX(dc2::script::TagArguments stack, int argc) {
    DA_BIND_VERTEX *bind = {};
    int             vertex1 = {};
    int             vertex2 = {};
    float           pos1[4];
    float           pos2[4];
    float           weight = {};

    bind = dynNowDA->pGetBindVertex(dynBindVertexCount++);

    if (bind == nullptr) {
        return false;
    }

    vertex1 = dc2::script::TagInteger(stack++);
    vertex2 = dc2::script::TagInteger(stack++);

    if (!dynNowDA->CheckVertexID(vertex1) || !dynNowDA->CheckVertexID(vertex2)) {
        dc2::log::PrintGame("error vertex no %d-%d!!!\n", vertex1, vertex2);
        return false;
    }

    bind->rate = 0.5f;

    if (argc >= 3) {
        weight = dc2::script::TagFloat(stack);
        bind->rate = weight;

        if (!(weight <= 1.0f) || weight < 0.0f) {
            bind->rate = 0.5f;
        }
    }

    bind->vertex_id[0] = vertex1;
    bind->vertex_id[1] = vertex2;
    dynNowDA->GetInitVertex(vertex1, pos1);
    dynNowDA->GetInitVertex(vertex2, pos2);
    bind->length = mgDistVector(pos1, pos2);
    return true;
}

/**
 *
 * Accepts the end of the vertex constraint table.
 *
 */
static int dynBIND_VERTEX_END(dc2::script::TagArguments stack, int argc) {
    return true;
}

/**
 *
 * Allocates the dynamic animation bounding box table.
 *
 */
static int dynBOUNDING_BOX_START(dc2::script::TagArguments stack, int argc) {
    dynNowDA->NewBoundingBoxTable(dc2::script::TagInteger(stack), dynStack);
    return true;
}

/**
 *
 * Adds a frame-bound box with optional coordinate bounds.
 *
 */
static int dynBOUNDING_BOX(dc2::script::TagArguments stack, int argc) {
    DA_BOUNDING_BOX *box = {};

    box = dynNowDA->pGetBoundingBox(dynBBoxCount++);

    if (box == nullptr) {
        return false;
    }

    box->frame_id = dc2::script::TagInteger(stack++);

    if (argc >= 4) {
        dc2::script::TagVector(box->min, stack);
        stack = stack + 3;
        std::memmove(box->max, box->min, sizeof(u_long128));
    }

    if (argc >= 7) {
        dc2::script::TagVector(box->max, stack);
    }

    return true;
}

/**
 *
 * Accepts the end of the bounding box table.
 *
 */
static int dynBOUNDING_BOX_END(dc2::script::TagArguments stack, int argc) {
    return true;
}

/**
 *
 * Allocates the dynamic animation collision table.
 *
 */
static int dynCOLLISION_START(dc2::script::TagArguments stack, int argc) {
    dynNowDA->NewCollisionTable(dc2::script::TagInteger(stack), dynStack);
    return true;
}

/**
 *
 * Constructs and registers a scripted pipe collision volume.
 *
 */
static int dynCOLLISION(dc2::script::TagArguments stack, int count) {
    char       *kind = {};
    CDAColPipe *pipe = {};

    kind = dc2::script::TagCString(stack++);

    if (kind == nullptr) {
        return false;
    }

    if (strcmp(kind, "pipe") == 0) {
        pipe = dynStack != nullptr ? dc2::memory::NewObject<CDAColPipe>(*dynStack) : nullptr;

        if (pipe == nullptr) {
            return false;
        }

        pipe->frame_id = dc2::script::TagInteger(stack++);
        dc2::script::TagVector(pipe->center, stack);
        dc2::script::TagVector(pipe->radius, stack + 3);
        stack = stack + 6;
        pipe->axis = dc2::script::TagInteger(stack++);

        if (count >= 10) {
            pipe->friction = dc2::script::TagFloat(stack);
        }

        dynNowDA->SetCollision(dynColCount++, pipe);
        return true;
    }

    return false;
}

void CDAColPipe::Initialize() {
    axis = 0;
    mgZeroVector(center);
    mgZeroVector(radius);
    friction = 0.8f;
}

void CDACollision::Initialize() {
    mgZeroVector(center);
    mgZeroVector(radius);
    friction = 0.8f;
}

/**
 *
 * Accepts the end of the dynamic animation collision table.
 *
 */
static int dynCOLLISION_END(dc2::script::TagArguments stack, int argc) {
    return true;
}

/**
 *
 * Sets the gravity vector for the dynamic animation.
 *
 */
static int dynGRAVITY(dc2::script::TagArguments stack, int argc) {
    dc2::script::TagVector(dynNowDA->gravity, stack);
    dynNowDA->gravity[3] = 0.0f;
    return true;
}

/**
 *
 * Sets the dynamic animation stiffness coefficient.
 *
 */
static int dynK(dc2::script::TagArguments stack, int argc) {
    dynNowDA->k = dc2::script::TagFloat(stack);
    return true;
}

/**
 *
 * Sets the wind response scale for the dynamic animation.
 *
 */
static int dynWind(dc2::script::TagArguments stack) {
    dynNowDA->wind_scale = dc2::script::TagFloat(stack);
    return true;
}

/**
 *
 * Script tags that define dynamic-animation geometry and forces.
 *
 */
static SPI_TAG_PARAM dynmc_tag[] = {
    {"FRAME_START",        dc2::script::AdaptTagArguments<dynFRAME_START>       },
    {"FRAME",              dc2::script::AdaptTagArguments<dynFRAME>             },
    {"FRAME_END",          dc2::script::AdaptTagArguments<dynFRAME_END>         },
    {"VERTEX_START",       dc2::script::AdaptTagArguments<dynVERTEX_START>      },
    {"VERTEX",             dc2::script::AdaptTagArguments<dynVERTEX>            },
    {"VERTEX_L",           dc2::script::AdaptTagArguments<dynVERTEX_L>          },
    {"VERTEX_END",         dc2::script::AdaptTagArguments<dynVERTEX_END>        },
    {"FIX_VERTEX_START",   dc2::script::AdaptTagArguments<dynFIX_VERTEX_START>  },
    {"FIX_VERTEX",         dc2::script::AdaptTagArguments<dynFIX_VERTEX>        },
    {"FIX_VERTEX_C",       dc2::script::AdaptTagArguments<dynFIX_VERTEX_C>      },
    {"FIX_VERTEX_S",       dc2::script::AdaptTagArguments<dynFIX_VERTEX_S>      },
    {"FIX_VERTEX_END",     dc2::script::AdaptTagArguments<dynFIX_VERTEX_END>    },
    {"FRAME_POSE",         dc2::script::AdaptTagArguments<dynFRAME_POSE>        },
    {"FRAME_POSE_L",       dc2::script::AdaptTagArguments<dynFRAME_POSE_L>      },
    {"DRAW_FRAME",         dc2::script::AdaptTagArguments<dynDRAW_FRAME>        },
    {"BIND_VERTEX_START",  dc2::script::AdaptTagArguments<dynBIND_VERTEX_START> },
    {"BIND_VERTEX",        dc2::script::AdaptTagArguments<dynBIND_VERTEX>       },
    {"BIND_VERTEX_END",    dc2::script::AdaptTagArguments<dynBIND_VERTEX_END>   },
    {"BOUNDING_BOX_START", dc2::script::AdaptTagArguments<dynBOUNDING_BOX_START>},
    {"BOUNDING_BOX",       dc2::script::AdaptTagArguments<dynBOUNDING_BOX>      },
    {"BOUNDING_BOX_END",   dc2::script::AdaptTagArguments<dynBOUNDING_BOX_END>  },
    {"COLLISION_START",    dc2::script::AdaptTagArguments<dynCOLLISION_START>   },
    {"COLLISION",          dc2::script::AdaptTagArguments<dynCOLLISION>         },
    {"COLLISION_END",      dc2::script::AdaptTagArguments<dynCOLLISION_END>     },
    {"GRAVITY",            dc2::script::AdaptTagArguments<dynGRAVITY>           },
    {"K",                  dc2::script::AdaptTagArguments<dynK>                 },
    {"WIND",               dc2::script::AdaptTagArguments<dynWind>              },
    {nullptr,              nullptr                                              }
};

void CDynamicAnime::Load(char *name, int size, mgCFrame *frame, mgCMemory *memory) {
    float position[4];
    float rotation[4];
    float scale[4];

    Initialize();
    dynStack = memory;
    dynNowDA = this;
    dynTopFrame = frame;
    dynFrameCount = 0;
    dynVertexCount = 0;
    dynFixVertexCount = 0;
    dynBindVertexCount = 0;
    dynBBoxCount = 0;
    dynColCount = 0;

    if (frame != nullptr) {
        top_frame = frame;
        dynTopFrame->GetPosition(position);
        dynTopFrame->GetRotation(rotation);
        dynTopFrame->GetScale(scale);
        dynTopFrame->SetPosition(0.0f, 0.0f, 0.0f);
        dynTopFrame->SetRotation(0.0f, 0.0f, 0.0f);
        dynTopFrame->SetScale(1.0f, 1.0f, 1.0f);
        PortRunDynamicAnimeScript(dynmc_tag, name, size);

        dynTopFrame->SetPosition(position);
        dynTopFrame->SetRotation(rotation);
        dynTopFrame->SetScale(scale);
    }
}

int CDAColPipe::CheckHit(float *point) {
    float offset[4];
    float local[4];
    float saved = {};

    point[3] = 1.0f;
    sceVu0ApplyMatrix(local, inverse_matrix, point);
    sceVu0SubVector(offset, local, center);
    offset[0] /= radius[0];
    offset[1] /= radius[1];
    offset[2] /= radius[2];

    if (1.0f < offset[axis]) {
        return false;
    }

    if (!(-1.0f <= offset[axis])) {
        return false;
    }

    offset[axis] = 0.0f;

    if (!(mgDistVector(offset) < 1.0f)) {
        return false;
    }

    sceVu0Normalize(offset, offset);
    offset[0] *= radius[0];
    offset[1] *= radius[1];
    offset[2] *= radius[2];
    saved = local[axis];
    sceVu0AddVector(local, center, offset);
    local[axis] = saved;
    local[3] = 1.0f;
    sceVu0ApplyMatrix(point, lw_matrix, local);
    return true;
}
