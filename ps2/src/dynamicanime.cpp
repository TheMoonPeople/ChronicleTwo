#include "common.h"

#include <cstdio>
#include <cstring>

#include "dynamicanime.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "scriptinterpreter.hpp"

/**
 * Dynamic animation receiving script commands.
 */
static CDynamicAnime *dynNowDA;

/**
 * Memory used by the current dynamic animation script.
 */
static mgCMemory *dynStack;

/**
 * Root frame used to resolve animation frame names.
 */
static mgCFrame *dynTopFrame;

/**
 * Number of animation frames read from the script.
 */
static int dynFrameCount;

/**
 * Number of animation vertices read from the script.
 */
static int dynVertexCount;

/**
 * Number of fixed vertices read from the script.
 */
static int dynFixVertexCount;

/**
 * Number of vertex bindings read from the script.
 */
static int dynBindVertexCount;

/**
 * Number of bounding boxes read from the script.
 */
static int dynBBoxCount;

/**
 * Number of collision shapes read from the script.
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

// Code (.text)
/**
 *
 * Pulls two bound points toward their target separation.
 *
 */
void BindPosition(float *a, float *b, float length, float rate) {
    float delta[4];
    float pull_a[4];
    float pull_b[4];
    float distance;
    float excess;

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
    int   i;

    if (top_frame != 0) {
        top_frame->GetLWMatrix(matrix);
        mgApplyMatrixN(now_vertex, matrix, init_vertex, vertex_num);
    }

    for (i = 0; i < vertex_num; i++) {
        mgZeroVector(velocity[i]);
        *(u_long128 *) &old_vertex[i] = *(u_long128 *) &now_vertex[i];
    }
}

static inline float WindRand(int *seed) {
    *seed = *seed * 0x10DCD + 1;
    return (float) *seed / -2147483648.0f;
}

void CDynamicAnime::Step() {
    sceVu0FMATRIX   matrix;
    sceVu0FVECTOR   pull;
    sceVu0FVECTOR   max;
    sceVu0FVECTOR   min;
    sceVu0FVECTOR   wind;
    DA_FIX_VERTEX  *fixed;
    DA_BIND_VERTEX *bound;
    mgCFrame       *fixed_frame;
    float           stiffness;
    float           friction;
    int             hit;
    CDACollision   *volume;
    int             i;
    int             j;

    if (vertex_num <= 0) {
        return;
    }

    stiffness = k;

    if (top_frame != NULL) {
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

                if (fixed_frame == NULL) {
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
        *(u_long128 *) old_vertex[j] = *(u_long128 *) now_vertex[j];
        fixed = &fix_vertex[j];

        if (fixed->weight < 1.0f && fixed->weight > 0.0f) {
            fixed_frame = GetFrame(fixed->frame_id);

            if (fixed_frame != NULL) {
                fixed_frame->GetWorldPosition(pull, fixed->position);
                mgSubVector(pull, now_vertex[j]);
                sceVu0ScaleVector(pull, pull, fixed->weight);
                mgAddVector(now_vertex[j], pull);
                sceVu0ScaleVector(pull, pull, fixed->velocity_rate);
                mgSubVector(velocity[j], pull);
            }
        }

        friction = 1.0f;
        hit = 0;

        if (fixed->weight < 1.0f) {
            for (i = 0; i < collision_num; i++) {
                volume = collision[i];

                if (volume != NULL) {
                    hit |= volume->CheckHit(now_vertex[j]);

                    if (friction > volume->friction) {
                        friction = volume->friction;
                    }
                }
            }

            if (hit != 0) {
                sceVu0ScaleVector(velocity[j], velocity[j], friction);
            }
        }

        if (floor_enable != 0) {
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

int CDACollision::CheckHit(float *position) { return 0; }

void CDynamicAnime::SetWind(float power, float *direction) {
    wind_power = power;
    sceVu0Normalize(wind_dir, direction);
}

void CDynamicAnime::ResetWind() {
    wind_power = 0.0f;
}

void CDynamicAnime::SetFloor(float height) {
    floor_enable = 1;
    floor_y = height;
}

void CDynamicAnime::ResetFloor() {
    floor_enable = 0;
}

void CDynamicAnime::FramePose(mgCFrame *frame, DA_FRAME_POSE *pose) {
    int           across_axis;
    sceVu0FMATRIX matrix;
    float        *v2;
    int           cross_axis;
    int           along_axis;
    int           first_axis;
    int           second_axis;
    float        *v3;
    float        *v0;
    float        *v1;

    if (frame == NULL) {
        return;
    }

    across_axis = 0;
    cross_axis = 1;
    along_axis = 2;
    first_axis = 2;
    second_axis = 0;

    if (pose->type == DA_FRAME_POSE_BONE) {
        goto bone;
    }

    if (pose->type == DA_FRAME_POSE_BONE_YX) {
        cross_axis = 2;
        first_axis = 0;
        along_axis = 1;
        second_axis = 1;
        across_axis = 0;
    bone:
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
                if (frame->parent != NULL) {
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

        if (pose->local != 0 && frame->parent != NULL) {
            sceVu0FMATRIX parent_matrix;

            frame->parent->GetLWMatrix(parent_matrix);
            mgInversMatrix(parent_matrix, parent_matrix);
            mgMulMatrix(matrix, parent_matrix, matrix);
        }

        frame->SetTransMatrix(matrix);
    }
}

void CDynamicAnime::PreCollision() {
    int           i;
    CDACollision *col;

    for (i = 0; i < collision_num; i++) {
        col = collision[i];

        if (col != NULL) {
            col->frame = GetFrame(col->frame_id);

            if (col->frame != NULL) {
                col->frame->GetLWMatrix(col->lw_matrix);
                mgInversMatrix(col->inverse_matrix, col->lw_matrix);
            }
        }
    }
}

void CDynamicAnime::Initialize() {
    top_frame = 0;
    frame_num = 0;
    frame = 0;
    frame_pose = 0;
    vertex_num = 0;
    init_vertex = 0;
    now_vertex = 0;
    old_vertex = 0;
    velocity = 0;
    fix_vertex_num = 0;
    fix_vertex = 0;
    draw_frame_num = 0;
    draw_frame = 0;
    bind_vertex_num = 0;
    bind_vertex = 0;
    bbox_num = 0;
    bbox = 0;
    collision_num = 0;
    collision = 0;
    mgZeroVector(gravity);
    gravity[1] = -0.6f;
    k = 0.0f;
    wind_power = 0.0f;
    mgZeroVector(wind_dir);
    wind_seed = 0x1E69D;
    wind_gust = 0;
    wind_scale = 1.0f;
    floor_enable = 0;
    floor_y = -100000.0f;
}

void CDynamicAnime::NewFrameTable(int count, mgCMemory *memory) {
    frame_num = count;
    frame = (mgCFrame **) memory->Alloc(align16_blocks(frame_num * 4));
    frame_pose = (DA_FRAME_POSE *) memory->Alloc(align16_blocks(frame_num * 0x10));

    for (int i = 0; i < frame_num; i++) {
        frame[i] = 0;
        memset(&frame_pose[i], 0, sizeof(DA_FRAME_POSE));
    }
}

void CDynamicAnime::NewVertexTable(int count, mgCMemory *memory) {
    vertex_num = count;
    init_vertex = (sceVu0FVECTOR *) memory->Alloc(align16_blocks(vertex_num * 16));
    now_vertex = (sceVu0FVECTOR *) memory->Alloc(align16_blocks(vertex_num * 16));
    old_vertex = (sceVu0FVECTOR *) memory->Alloc(align16_blocks(vertex_num * 16));
    velocity = (sceVu0FVECTOR *) memory->Alloc(align16_blocks(vertex_num * 16));
    world_init_vertex = (sceVu0FVECTOR *) memory->Alloc(align16_blocks(vertex_num * 16));

    for (int i = 0; i < vertex_num; i++) {
        mgZeroVector(init_vertex[i]);
        mgZeroVector(now_vertex[i]);
        mgZeroVector(old_vertex[i]);
        mgZeroVector(velocity[i]);
    }
}

void CDynamicAnime::NewFixVertexTable(int count, mgCMemory *memory) {
    fix_vertex_num = count;
    fix_vertex = (DA_FIX_VERTEX *) memory->Alloc(
        align16_blocks(fix_vertex_num * sizeof(DA_FIX_VERTEX)));

    for (int i = 0; i < vertex_num; i++) {
        memset(&fix_vertex[i], 0, sizeof(DA_FIX_VERTEX));
    }
}

void CDynamicAnime::NewDrawFrameTable(int count, mgCMemory *memory) {
    draw_frame_num = count;
    draw_frame = (int *) memory->Alloc(align16_blocks(draw_frame_num * sizeof(int)));

    for (int i = 0; i < draw_frame_num; i++) {
        draw_frame[i] = -1;
    }
}

void CDynamicAnime::NewBindVertexTable(int count, mgCMemory *memory) {
    bind_vertex_num = count;
    bind_vertex = (DA_BIND_VERTEX *) memory->Alloc(
        align16_blocks(bind_vertex_num * sizeof(DA_BIND_VERTEX)));

    for (int i = 0; i < bind_vertex_num; i++) {
        memset(&bind_vertex[i], 0, sizeof(DA_BIND_VERTEX));
    }
}

void CDynamicAnime::NewBoundingBoxTable(int count, mgCMemory *memory) {
    bbox_num = count;
    bbox = (DA_BOUNDING_BOX *) memory->Alloc(
        align16_blocks(bbox_num * sizeof(DA_BOUNDING_BOX)));

    for (int i = 0; i < bind_vertex_num; i++) {
        memset(&bbox[i], 0, sizeof(DA_BOUNDING_BOX));
        bbox[i].frame_id = -1;
    }
}

void CDynamicAnime::NewCollisionTable(int count, mgCMemory *memory) {
    collision_num = count;
    collision = (CDACollision **) memory->Alloc(
        align16_blocks(collision_num * sizeof(CDACollision *)));

    for (int i = 0; i < collision_num; i++) {
        collision[i] = 0;
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
        return 0;
    }

    return frame[index];
}

DA_FRAME_POSE *CDynamicAnime::pGetFramePose(int index) {
    if (index < 0 || index >= frame_num) {
        return 0;
    }

    return frame_pose + index;
}

int CDynamicAnime::CheckVertexID(int index) {
    if (index < 0 || index >= vertex_num) {
        return 0;
    }

    return 1;
}

void CDynamicAnime::SetInitVertex(int index, float *pos) {
    if (CheckVertexID(index) != 0) {
        *(u_long128 *) &init_vertex[index] = *(u_long128 *) pos;
    }
}

void CDynamicAnime::GetInitVertex(int index, float *pos) {
    if (CheckVertexID(index) != 0) {
        *(u_long128 *) pos = *(u_long128 *) &init_vertex[index];
    }
}

void CDynamicAnime::SetNowVertex(int index, float *pos) {
    if (CheckVertexID(index) != 0) {
        *(u_long128 *) &now_vertex[index] = *(u_long128 *) pos;
    }
}

void CDynamicAnime::SetOldVertex(int index, float *pos) {
    if (CheckVertexID(index) != 0) {
        *(u_long128 *) &old_vertex[index] = *(u_long128 *) pos;
    }
}

DA_FIX_VERTEX *CDynamicAnime::pGetFixVertex(int index) {
    if (index < 0 || index >= fix_vertex_num) {
        return 0;
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
        return 0;
    }

    return GetFrame(draw_frame[index]);
}

DA_BIND_VERTEX *CDynamicAnime::pGetBindVertex(int index) {
    if (index < 0 || index >= bind_vertex_num) {
        return 0;
    }

    return bind_vertex + index;
}

DA_BOUNDING_BOX *CDynamicAnime::pGetBoundingBox(int index) {
    if (index < 0 || index >= bbox_num) {
        return 0;
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
        if (direct != 0) {
            sum += mgDrawDirect(GetDrawFrame(i));
        } else {
            sum += mgDraw(GetDrawFrame(i));
        }
    }

    return sum;
}

void CDynamicAnime::Copy(CDynamicAnime &destination, mgCFrame *root, mgCMemory *memory) {
    int index;
    destination = *this;
    destination.top_frame = root;

    if (root == NULL) {
        return;
    }

    if (frame_num > 0 && frame != NULL) {
        destination.frame = new (memory->Alloc(
            align16_blocks(frame_num * sizeof(mgCFrame *)) + 2)) mgCFrame *[frame_num];

        if (destination.frame == NULL) {
            return;
        }

        for (index = 0; index < frame_num; index++) {
            destination.frame[index] = NULL;

            if (frame[index] != NULL) {
                destination.frame[index] = root->GetFrame(root->SearchFrameID(frame[index]->name));
            }
        }
    }

    if (vertex_num > 0) {
        destination.init_vertex = new (memory->Alloc(
            align16_blocks(vertex_num * sizeof(sceVu0FVECTOR)) + 2)) sceVu0FVECTOR[vertex_num];
        destination.now_vertex = new (memory->Alloc(
            align16_blocks(vertex_num * sizeof(sceVu0FVECTOR)) + 2)) sceVu0FVECTOR[vertex_num];
        destination.old_vertex = new (memory->Alloc(
            align16_blocks(vertex_num * sizeof(sceVu0FVECTOR)) + 2)) sceVu0FVECTOR[vertex_num];
        destination.velocity = new (memory->Alloc(
            align16_blocks(vertex_num * sizeof(sceVu0FVECTOR)) + 2)) sceVu0FVECTOR[vertex_num];
        destination.world_init_vertex = new (memory->Alloc(
            align16_blocks(vertex_num * sizeof(sceVu0FVECTOR)) + 2)) sceVu0FVECTOR[vertex_num];

        for (index = 0; index < vertex_num; index++) {
            *(u_long128 *) destination.init_vertex[index] = *(u_long128 *) init_vertex[index];
            *(u_long128 *) destination.now_vertex[index] = *(u_long128 *) now_vertex[index];
            *(u_long128 *) destination.old_vertex[index] = *(u_long128 *) old_vertex[index];
            *(u_long128 *) destination.velocity[index] = *(u_long128 *) velocity[index];
            *(u_long128 *) destination.world_init_vertex[index] = *(u_long128 *) world_init_vertex[index];
        }
    }
}

/**
 *
 * Allocates the frame reference table for a dynamic animation.
 *
 */
int dynFRAME_START(SPI_STACK *stack, int argc) {
    dynNowDA->NewFrameTable(spiGetStackInt(stack), dynStack);
    return 1;
}

/**
 *
 * Adds a named model frame to the dynamic animation.
 *
 */
int dynFRAME(SPI_STACK *stack, int argc) {
    char     *name;
    mgCFrame *frame;

    name = spiGetStackString(stack);

    if (name == NULL) {
        return 0;
    }

    frame = dynTopFrame->SearchFrame(name);

    if (frame == NULL) {
        printf("not found %s\n", name);
    }

    dynNowDA->SetFrame(dynFrameCount++, frame);
    return 1;
}

/**
 *
 * Accepts the end of the dynamic animation frame table.
 *
 */
int dynFRAME_END(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Allocates the initial vertex table for a dynamic animation.
 *
 */
int dynVERTEX_START(SPI_STACK *stack, int argc) {
    dynNowDA->NewVertexTable(spiGetStackInt(stack), dynStack);
    return 1;
}

/**
 *
 * Adds an initial vertex offset from a frame world position.
 *
 */
int dynVERTEX(SPI_STACK *stack, int argc) {
    float     offset[4];
    float     world[4];
    mgCFrame *frame;
    int       frame_id;

    frame_id = spiGetStackInt(stack++);
    spiGetStackVector(offset, stack);
    frame = dynNowDA->GetFrame(frame_id);

    if (frame != NULL) {
        frame->GetWorldPosition0(world);
        world[3] = 1.0f;
        world[0] += offset[0];
        world[1] += offset[1];
        world[2] += offset[2];
        dynNowDA->SetInitVertex(dynVertexCount++, world);
    }

    return 1;
}

/**
 *
 * Adds an initial vertex transformed from frame local coordinates.
 *
 */
int dynVERTEX_L(SPI_STACK *stack, int argc) {
    float     local[4];
    float     world[4];
    int       frame_id;
    mgCFrame *frame;
    int       vertex_index;

    frame_id = spiGetStackInt(stack++);
    spiGetStackVector(local, stack);
    frame = dynNowDA->GetFrame(frame_id);

    if (frame != NULL) {
        local[3] = 1.0f;
        frame->GetWorldPosition(world, local);
        vertex_index = dynVertexCount;
        world[3] = 1.0f;
        dynVertexCount = vertex_index + 1;
        dynNowDA->SetInitVertex(vertex_index, world);
    }

    return 1;
}

/**
 *
 * Copies initial vertices into the current and previous positions.
 *
 */
int dynVERTEX_END(SPI_STACK *stack, int argc) {
    float vertex[4];
    int   i;
    int   count;

    count = dynNowDA->vertex_num;

    for (i = 0; i < count; i++) {
        dynNowDA->GetInitVertex(i, vertex);
        dynNowDA->SetOldVertex(i, vertex);
        dynNowDA->SetNowVertex(i, vertex);
    }

    return 1;
}

/**
 *
 * Allocates the fixed vertex table for a dynamic animation.
 *
 */
int dynFIX_VERTEX_START(SPI_STACK *stack, int argc) {
    spiGetStackInt(stack);
    dynNowDA->NewFixVertexTable(dynNowDA->vertex_num, dynStack);
    return 1;
}

/**
 *
 * Finds and initializes a fixed vertex relative to its frame.
 *
 */
DA_FIX_VERTEX *dynFixVertex(SPI_STACK *stack, int argc) {
    int            frame_id;
    int            vertex_index;
    DA_FIX_VERTEX *fix;
    mgCFrame      *frame;
    float          matrix[4][4];
    float          init[4];

    frame_id = spiGetStackInt(stack++);
    vertex_index = spiGetStackInt(stack);
    fix = dynNowDA->pGetFixVertex(vertex_index);

    fix->frame_id = frame_id;

    if (fix == NULL) {
        return NULL;
    }

    frame = dynNowDA->GetFrame(fix->frame_id);

    if (frame == NULL || dynNowDA->CheckVertexID(vertex_index) == 0) {
        fix->frame_id = -1;
        return NULL;
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
int dynFIX_VERTEX(SPI_STACK *stack, int argc) {
    DA_FIX_VERTEX *fix;

    fix = dynFixVertex(stack, argc);
    stack += 2;

    if (fix == NULL) {
        return 0;
    }

    if (argc >= 3) {
        fix->weight = spiGetStackFloat(stack++);
    }

    if (argc >= 4) {
        fix->unk_1c = spiGetStackFloat(stack);
    }

    fix->velocity_rate = 0.0f;
    return 1;
}

/**
 *
 * Configures a fixed vertex with positive velocity transfer.
 *
 */
int dynFIX_VERTEX_C(SPI_STACK *stack, int argc) {
    DA_FIX_VERTEX *fix;

    fix = dynFixVertex(stack, argc);
    stack += 2;

    if (fix == NULL) {
        return 0;
    }

    if (argc >= 3) {
        fix->weight = spiGetStackFloat(stack++);
    }

    if (argc >= 4) {
        fix->unk_1c = spiGetStackFloat(stack);
    }

    fix->velocity_rate = 1.0f;
    return 1;
}

/**
 *
 * Configures a fixed vertex with negative velocity transfer.
 *
 */
int dynFIX_VERTEX_S(SPI_STACK *stack, int argc) {
    DA_FIX_VERTEX *fix;

    fix = dynFixVertex(stack, argc);
    stack += 2;

    if (fix == NULL) {
        return 0;
    }

    if (argc >= 3) {
        fix->weight = spiGetStackFloat(stack++);
    }

    if (argc >= 4) {
        fix->unk_1c = spiGetStackFloat(stack);
    }

    fix->velocity_rate = -1.0f;
    return 1;
}

/**
 *
 * Accepts the end of the fixed vertex table.
 *
 */
int dynFIX_VERTEX_END(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Creates a frame pose from a type and four vertex references.
 *
 */
DA_FRAME_POSE *FRAME_POSE_Sub(SPI_STACK *stack, int argc) {
    DA_FRAME_POSE *pose;
    char          *kind;
    int            i;

    pose = dynNowDA->pGetFramePose(spiGetStackInt(stack++));
    kind = spiGetStackString(stack++);

    if (pose == NULL || kind == NULL) {
        return NULL;
    }

    pose->type = 0;

    if (strcmp(kind, "bone") == 0) {
        if (argc < 6) {
            return NULL;
        }

        pose->type = 1;
        pose->vertex_num = 4;
    } else if (strcmp(kind, "bone_yx") == 0) {
        if (argc < 6) {
            return NULL;
        }

        pose->type = 2;
        pose->vertex_num = 4;
    } else if (strcmp(kind, "b_cdlr") == 0) {
        if (argc < 6) {
            return NULL;
        }

        pose->type = 3;
        pose->vertex_num = 4;
    } else {
        return NULL;
    }

    pose->vertex_id = (int *) dynStack->Alloc(1);

    for (i = 0; i < pose->vertex_num; i++) {
        pose->vertex_id[i] = spiGetStackInt(stack++);

        if (dynNowDA->CheckVertexID(pose->vertex_id[i]) == 0) {
            printf("error vertex no %d!!\n", pose->vertex_id[i]);
            pose->type = 0;
            return NULL;
        }
    }

    return pose;
}

/**
 *
 * Marks a scripted frame pose as local to its frame.
 *
 */
int dynFRAME_POSE_L(SPI_STACK *stack, int argc) {
    DA_FRAME_POSE *pose;
    mgCFrame      *frame;

    pose = FRAME_POSE_Sub(stack, argc);
    frame = dynNowDA->GetFrame(spiGetStackInt(stack));

    if ((pose == NULL) || (frame == NULL)) {
        return 0;
    }

    pose->local = 1;
    return 1;
}

/**
 *
 * Marks a scripted frame pose as world-relative and detaches its frame.
 *
 */
int dynFRAME_POSE(SPI_STACK *stack, int argc) {
    mgCFrame      *frame;
    DA_FRAME_POSE *pose;

    pose = FRAME_POSE_Sub(stack, argc);
    frame = dynNowDA->GetFrame(spiGetStackInt(stack));

    if ((pose == NULL) || (frame == NULL)) {
        return 0;
    }

    pose->local = 0;
    frame->DeleteParent();
    return 1;
}

/**
 *
 * Sets the frames drawn by the dynamic animation.
 *
 */
int dynDRAW_FRAME(SPI_STACK *stack, int argc) {
    int i;

    dynNowDA->NewDrawFrameTable(argc, dynStack);

    for (i = 0; i < argc; i++) {
        dynNowDA->SetDrawFrame(i, spiGetStackInt(stack++));
    }

    return 1;
}

/**
 *
 * Allocates the vertex distance constraint table.
 *
 */
int dynBIND_VERTEX_START(SPI_STACK *stack, int argc) {
    dynNowDA->NewBindVertexTable(spiGetStackInt(stack), dynStack);
    return 1;
}

/**
 *
 * Connects two vertices with a weighted distance constraint.
 *
 */
int dynBIND_VERTEX(SPI_STACK *stack, int argc) {
    DA_BIND_VERTEX *bind;
    int             vertex1;
    int             vertex2;
    float           pos1[4];
    float           pos2[4];
    float           weight;

    bind = dynNowDA->pGetBindVertex(dynBindVertexCount++);

    if (bind == NULL) {
        return 0;
    }

    vertex1 = spiGetStackInt(stack++);
    vertex2 = spiGetStackInt(stack++);

    if (dynNowDA->CheckVertexID(vertex1) == 0 || dynNowDA->CheckVertexID(vertex2) == 0) {
        printf("error vertex no %d-%d!!!\n", vertex1, vertex2);
        return 0;
    }

    bind->rate = 0.5f;

    if (argc >= 3) {
        weight = spiGetStackFloat(stack);
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
    return 1;
}

/**
 *
 * Accepts the end of the vertex constraint table.
 *
 */
int dynBIND_VERTEX_END(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Allocates the dynamic animation bounding box table.
 *
 */
int dynBOUNDING_BOX_START(SPI_STACK *stack, int argc) {
    dynNowDA->NewBoundingBoxTable(spiGetStackInt(stack), dynStack);
    return 1;
}

/**
 *
 * Adds a frame-bound box with optional coordinate bounds.
 *
 */
int dynBOUNDING_BOX(SPI_STACK *stack, int argc) {
    DA_BOUNDING_BOX *box;

    box = dynNowDA->pGetBoundingBox(dynBBoxCount++);

    if (box == NULL) {
        return 0;
    }

    box->frame_id = spiGetStackInt(stack++);

    if (argc >= 4) {
        spiGetStackVector(box->min, stack);
        stack += 3;
        *(u_long128 *) box->max = *(u_long128 *) box->min;
    }

    if (argc >= 7) {
        spiGetStackVector(box->max, stack);
    }

    return 1;
}

/**
 *
 * Accepts the end of the bounding box table.
 *
 */
int dynBOUNDING_BOX_END(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Allocates the dynamic animation collision table.
 *
 */
int dynCOLLISION_START(SPI_STACK *stack, int argc) {
    dynNowDA->NewCollisionTable(spiGetStackInt(stack), dynStack);
    return 1;
}

/**
 *
 * Constructs and registers a scripted pipe collision volume.
 *
 */
static int dynCOLLISION(SPI_STACK *stack, int count) {
    char       *kind;
    CDAColPipe *pipe;

    kind = spiGetStackString(stack++);

    if (kind == NULL) {
        return 0;
    }

    if (strcmp(kind, "pipe") == 0) {
        pipe = new (dynStack->Alloc(16)) CDAColPipe;

        if (pipe == NULL) {
            return 0;
        }

        pipe->frame_id = spiGetStackInt(stack++);
        spiGetStackVector(pipe->center, stack);
        spiGetStackVector(pipe->radius, stack + 3);
        stack += 6;
        pipe->axis = spiGetStackInt(stack++);

        if (count >= 10) {
            pipe->friction = spiGetStackFloat(stack);
        }

        dynNowDA->SetCollision(dynColCount++, pipe);
        return 1;
    }

    return 0;
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
int dynCOLLISION_END(SPI_STACK *stack, int argc) {
    return 1;
}

/**
 *
 * Sets the gravity vector for the dynamic animation.
 *
 */
int dynGRAVITY(SPI_STACK *stack, int argc) {
    spiGetStackVector(dynNowDA->gravity, stack);
    dynNowDA->gravity[3] = 0.0f;
    return 1;
}

/**
 *
 * Sets the dynamic animation stiffness coefficient.
 *
 */
int dynK(SPI_STACK *stack, int argc) {
    dynNowDA->k = spiGetStackFloat(stack);
    return 1;
}

/**
 *
 * Sets the wind response scale for the dynamic animation.
 *
 */
int dynWind(SPI_STACK *stack, int argc) {
    dynNowDA->wind_scale = spiGetStackFloat(stack);
    return 1;
}

static int dynCOLLISION(SPI_STACK *stack, int count);

/**
 * Script tags that define dynamic-animation geometry and forces.
 */
static SPI_TAG_PARAM dynmc_tag[] = {
    {"FRAME_START",        dynFRAME_START       },
    {"FRAME",              dynFRAME             },
    {"FRAME_END",          dynFRAME_END         },
    {"VERTEX_START",       dynVERTEX_START      },
    {"VERTEX",             dynVERTEX            },
    {"VERTEX_L",           dynVERTEX_L          },
    {"VERTEX_END",         dynVERTEX_END        },
    {"FIX_VERTEX_START",   dynFIX_VERTEX_START  },
    {"FIX_VERTEX",         dynFIX_VERTEX        },
    {"FIX_VERTEX_C",       dynFIX_VERTEX_C      },
    {"FIX_VERTEX_S",       dynFIX_VERTEX_S      },
    {"FIX_VERTEX_END",     dynFIX_VERTEX_END    },
    {"FRAME_POSE",         dynFRAME_POSE        },
    {"FRAME_POSE_L",       dynFRAME_POSE_L      },
    {"DRAW_FRAME",         dynDRAW_FRAME        },
    {"BIND_VERTEX_START",  dynBIND_VERTEX_START },
    {"BIND_VERTEX",        dynBIND_VERTEX       },
    {"BIND_VERTEX_END",    dynBIND_VERTEX_END   },
    {"BOUNDING_BOX_START", dynBOUNDING_BOX_START},
    {"BOUNDING_BOX",       dynBOUNDING_BOX      },
    {"BOUNDING_BOX_END",   dynBOUNDING_BOX_END  },
    {"COLLISION_START",    dynCOLLISION_START   },
    {"COLLISION",          dynCOLLISION         },
    {"COLLISION_END",      dynCOLLISION_END     },
    {"GRAVITY",            dynGRAVITY           },
    {"K",                  dynK                 },
    {"WIND",               dynWind              },
    {NULL,                 NULL                 }
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

    if (frame != 0) {
        top_frame = frame;
        dynTopFrame->GetPosition(position);
        dynTopFrame->GetRotation(rotation);
        dynTopFrame->GetScale(scale);
        dynTopFrame->SetPosition(0.0f, 0.0f, 0.0f);
        dynTopFrame->SetRotation(0.0f, 0.0f, 0.0f);
        dynTopFrame->SetScale(1.0f, 1.0f, 1.0f);
        CScriptInterpreter interp;
        interp.SetTag(dynmc_tag);
        interp.SetScript(name, size);
        interp.Run();
        dynTopFrame->SetPosition(position);
        dynTopFrame->SetRotation(rotation);
        dynTopFrame->SetScale(scale);
    }
}

int CDAColPipe::CheckHit(float *point) {
    float offset[4];
    float local[4];
    float saved;

    point[3] = 1.0f;
    sceVu0ApplyMatrix(local, inverse_matrix, point);
    sceVu0SubVector(offset, local, center);
    offset[0] /= radius[0];
    offset[1] /= radius[1];
    offset[2] /= radius[2];

    if (1.0f < offset[axis]) {
        return 0;
    }

    if (!(-1.0f <= offset[axis])) {
        return 0;
    }

    offset[axis] = 0.0f;

    if (!(mgDistVector(offset) < 1.0f)) {
        return 0;
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
    return 1;
}
