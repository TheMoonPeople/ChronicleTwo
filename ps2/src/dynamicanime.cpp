#include "common.h"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "scriptinterpreter.hpp"
#include "dynamicanime.hpp"
#include <cstdio>
#include <cstring>

extern CDynamicAnime *dynNowDA;
extern mgCMemory *dynStack;
extern mgCFrame *dynTopFrame;
extern int dynFrameCount;
extern int dynVertexCount;
extern int dynFixVertexCount;
extern int dynBindVertexCount;
extern int dynBBoxCount;
extern int dynColCount;
extern SPI_TAG_PARAM dynmc_tag[];
extern char at_855__2[];
extern char at_976[];
extern char at_977[];
extern char at_978[];
extern char at_979[];
extern char at_1025[];

static inline u_int align16_blocks(u_int size) {
    if (size & 15) {
        return (size >> 4) + 1;
    }
    return size >> 4;
}

// Code (.text)
extern "C" void BindPosition__FPfPfff(float *pointA, float *pointB, float length, float weight) {
    float delta[4];
    float pull_a[4];
    float pull_b[4];
    float distance;
    float excess;

    sceVu0SubVector(delta, pointA, pointB);
    distance = mgDistVector(delta);
    excess = distance - length;
    sceVu0ScaleVector(pull_a, delta, (1.0f - weight) * excess / distance);
    sceVu0ScaleVector(pull_b, delta, weight * excess / distance);
    mgSubVector(pointA, pull_a);
    mgAddVector(pointB, pull_b);
}
void CDynamicAnime::ResetPosition(void) {
    float matrix[4][4];
    int i;

    if (top_frame != 0) {
        top_frame->GetLWMatrix(matrix);
        mgApplyMatrixN((float(*)[4])now_vertex, matrix, (float(*)[4])init_vertex, vertex_num);
    }
    for (i = 0; i < vertex_num; i++) {
        mgZeroVector(velocity[i]);
        *(u_long128 *)&old_vertex[i] = *(u_long128 *)&now_vertex[i];
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dynamicanime", Step__13CDynamicAnimeFv);
int CDACollision::CheckHit(float *position) { return 0; }
void CDynamicAnime::SetWind(float power, float *direction) {
    wind_power = power;
    sceVu0Normalize(wind_dir, direction);
}
void CDynamicAnime::ResetWind(void) {
    wind_power = 0.0f;
}
void CDynamicAnime::SetFloor(float height) {
    floor_enable = 1;
    floor_y = height;
}
void CDynamicAnime::ResetFloor(void) {
    floor_enable = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dynamicanime", FramePose__13CDynamicAnimeFP8mgCFrameP13DA_FRAME_POSE);
void CDynamicAnime::PreCollision(void) {
    int i;
    CDACollision *col;

    for (i = 0; i < collision_num; i++) {
        col = collision[i];
        if (col != NULL) {
            col->frame = GetFrame(col->frame_id);
            if (col->frame != NULL) {
                col->frame->GetLWMatrix((float(*)[4])col->lw_matrix);
                mgInversMatrix((float(*)[4])col->inverse_matrix, (float(*)[4])col->lw_matrix);
            }
        }
    }
}
void CDynamicAnime::Initialize(void) {
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
    frame = (mgCFrame **)memory->Alloc(align16_blocks(frame_num * 4));
    frame_pose = (DA_FRAME_POSE *)memory->Alloc(align16_blocks(frame_num * 0x10));
    for (int i = 0; i < frame_num; i++) {
        frame[i] = 0;
        memset(&frame_pose[i], 0, sizeof(DA_FRAME_POSE));
    }
}
void CDynamicAnime::NewVertexTable(int count, mgCMemory *memory) {
    vertex_num = count;
    init_vertex = (sceVu0FVECTOR *)memory->Alloc(align16_blocks(vertex_num * 16));
    now_vertex = (sceVu0FVECTOR *)memory->Alloc(align16_blocks(vertex_num * 16));
    old_vertex = (sceVu0FVECTOR *)memory->Alloc(align16_blocks(vertex_num * 16));
    velocity = (sceVu0FVECTOR *)memory->Alloc(align16_blocks(vertex_num * 16));
    world_init_vertex = (sceVu0FVECTOR *)memory->Alloc(align16_blocks(vertex_num * 16));
    for (int i = 0; i < vertex_num; i++) {
        mgZeroVector(init_vertex[i]);
        mgZeroVector(now_vertex[i]);
        mgZeroVector(old_vertex[i]);
        mgZeroVector(velocity[i]);
    }
}
void CDynamicAnime::NewFixVertexTable(int count, mgCMemory *memory) {
    fix_vertex_num = count;
    fix_vertex = (DA_FIX_VERTEX *)memory->Alloc(
        align16_blocks(fix_vertex_num * sizeof(DA_FIX_VERTEX)));
    for (int i = 0; i < vertex_num; i++) {
        memset(&fix_vertex[i], 0, sizeof(DA_FIX_VERTEX));
    }
}
void CDynamicAnime::NewDrawFrameTable(int count, mgCMemory *memory) {
    draw_frame_num = count;
    draw_frame = (int *)memory->Alloc(align16_blocks(draw_frame_num * sizeof(int)));
    for (int i = 0; i < draw_frame_num; i++) {
        draw_frame[i] = -1;
    }
}
void CDynamicAnime::NewBindVertexTable(int count, mgCMemory *memory) {
    bind_vertex_num = count;
    bind_vertex = (DA_BIND_VERTEX *)memory->Alloc(
        align16_blocks(bind_vertex_num * sizeof(DA_BIND_VERTEX)));
    for (int i = 0; i < bind_vertex_num; i++) {
        memset(&bind_vertex[i], 0, sizeof(DA_BIND_VERTEX));
    }
}
void CDynamicAnime::NewBoundingBoxTable(int count, mgCMemory *memory) {
    bbox_num = count;
    bbox = (DA_BOUNDING_BOX *)memory->Alloc(
        align16_blocks(bbox_num * sizeof(DA_BOUNDING_BOX)));
    for (int i = 0; i < bind_vertex_num; i++) {
        memset(&bbox[i], 0, sizeof(DA_BOUNDING_BOX));
        bbox[i].frame_id = -1;
    }
}
void CDynamicAnime::NewCollisionTable(int count, mgCMemory *memory) {
    collision_num = count;
    collision = (CDACollision **)memory->Alloc(
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
        *(u_long128 *)&init_vertex[index] = *(u_long128 *)pos;
    }
}
void CDynamicAnime::GetInitVertex(int index, float *pos) {
    if (CheckVertexID(index) != 0) {
        *(u_long128 *)pos = *(u_long128 *)&init_vertex[index];
    }
}
void CDynamicAnime::SetNowVertex(int index, float *pos) {
    if (CheckVertexID(index) != 0) {
        *(u_long128 *)&now_vertex[index] = *(u_long128 *)pos;
    }
}
void CDynamicAnime::SetOldVertex(int index, float *pos) {
    if (CheckVertexID(index) != 0) {
        *(u_long128 *)&old_vertex[index] = *(u_long128 *)pos;
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
        destination.frame = new ((u_long128 *)memory->Alloc(
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
        destination.init_vertex = new ((u_long128 *)memory->Alloc(
            align16_blocks(vertex_num * sizeof(sceVu0FVECTOR)) + 2)) sceVu0FVECTOR[vertex_num];
        destination.now_vertex = new ((u_long128 *)memory->Alloc(
            align16_blocks(vertex_num * sizeof(sceVu0FVECTOR)) + 2)) sceVu0FVECTOR[vertex_num];
        destination.old_vertex = new ((u_long128 *)memory->Alloc(
            align16_blocks(vertex_num * sizeof(sceVu0FVECTOR)) + 2)) sceVu0FVECTOR[vertex_num];
        destination.velocity = new ((u_long128 *)memory->Alloc(
            align16_blocks(vertex_num * sizeof(sceVu0FVECTOR)) + 2)) sceVu0FVECTOR[vertex_num];
        destination.world_init_vertex = new ((u_long128 *)memory->Alloc(
            align16_blocks(vertex_num * sizeof(sceVu0FVECTOR)) + 2)) sceVu0FVECTOR[vertex_num];
        for (index = 0; index < vertex_num; index++) {
            *(u_long128 *)destination.init_vertex[index] = *(u_long128 *)init_vertex[index];
            *(u_long128 *)destination.now_vertex[index] = *(u_long128 *)now_vertex[index];
            *(u_long128 *)destination.old_vertex[index] = *(u_long128 *)old_vertex[index];
            *(u_long128 *)destination.velocity[index] = *(u_long128 *)velocity[index];
            *(u_long128 *)destination.world_init_vertex[index] = *(u_long128 *)world_init_vertex[index];
        }
    }
}
int dynFRAME_START(SPI_STACK *stack, int argc) {
    dynNowDA->NewFrameTable(spiGetStackInt(stack), dynStack);
    return 1;
}
int dynFRAME(SPI_STACK *stack, int argc) {
    char *name;
    mgCFrame *frame;

    name = spiGetStackString(stack);
    if (name == NULL) {
        return 0;
    }
    frame = dynTopFrame->SearchFrame(name);
    if (frame == NULL) {
        printf(at_855__2, name);
    }
    dynNowDA->SetFrame(dynFrameCount++, frame);
    return 1;
}
int dynFRAME_END(SPI_STACK *stack, int argc) {
    return 1;
}
int dynVERTEX_START(SPI_STACK *stack, int argc) {
    dynNowDA->NewVertexTable(spiGetStackInt(stack), dynStack);
    return 1;
}
int dynVERTEX(SPI_STACK *stack, int argc) {
    float offset[4];
    float world[4];
    mgCFrame *frame;
    int frame_id;

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
int dynVERTEX_L(SPI_STACK *stack, int argc) {
    float local[4];
    float world[4];
    int frame_id;
    mgCFrame *frame;
    int vertex_index;

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
int dynVERTEX_END(SPI_STACK *stack, int argc) {
    float vertex[4];
    int i;
    int count;

    count = dynNowDA->vertex_num;
    for (i = 0; i < count; i++) {
        dynNowDA->GetInitVertex(i, vertex);
        dynNowDA->SetOldVertex(i, vertex);
        dynNowDA->SetNowVertex(i, vertex);
    }
    return 1;
}
int dynFIX_VERTEX_START(SPI_STACK *stack, int argc) {
    spiGetStackInt(stack);
    dynNowDA->NewFixVertexTable(dynNowDA->vertex_num, dynStack);
    return 1;
}
DA_FIX_VERTEX *dynFixVertex(SPI_STACK *stack, int argc) {
    int frame_id;
    int vertex_index;
    DA_FIX_VERTEX *fix;
    mgCFrame *frame;
    float matrix[4][4];
    float init[4];

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
int dynFIX_VERTEX_END(SPI_STACK *stack, int argc) {
    return 1;
}
DA_FRAME_POSE *FRAME_POSE_Sub(SPI_STACK *stack, int argc) {
    DA_FRAME_POSE *pose;
    char *kind;
    int i;

    pose = dynNowDA->pGetFramePose(spiGetStackInt(stack++));
    kind = spiGetStackString(stack++);
    if (pose == NULL || kind == NULL) {
        return NULL;
    }
    pose->type = 0;
    if (strcmp(kind, at_976) == 0) {
        if (argc < 6) {
            return NULL;
        }
        pose->type = 1;
        pose->vertex_num = 4;
    } else if (strcmp(kind, at_977) == 0) {
        if (argc < 6) {
            return NULL;
        }
        pose->type = 2;
        pose->vertex_num = 4;
    } else if (strcmp(kind, at_978) == 0) {
        if (argc < 6) {
            return NULL;
        }
        pose->type = 3;
        pose->vertex_num = 4;
    } else {
        return NULL;
    }
    pose->vertex_id = (int *)dynStack->Alloc(1);
    for (i = 0; i < pose->vertex_num; i++) {
        pose->vertex_id[i] = spiGetStackInt(stack++);
        if (dynNowDA->CheckVertexID(pose->vertex_id[i]) == 0) {
            printf(at_979, pose->vertex_id[i]);
            pose->type = 0;
            return NULL;
        }
    }
    return pose;
}
int dynFRAME_POSE_L(SPI_STACK *stack, int argc) {
    DA_FRAME_POSE *pose;
    mgCFrame *frame;

    pose = FRAME_POSE_Sub(stack, argc);
    frame = dynNowDA->GetFrame(spiGetStackInt(stack));
    if ((pose == NULL) || (frame == NULL)) {
        return 0;
    }
    pose->local = 1;
    return 1;
}
int dynFRAME_POSE(SPI_STACK *stack, int argc) {
    mgCFrame *frame;
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
int dynDRAW_FRAME(SPI_STACK *stack, int argc) {
    int i;

    dynNowDA->NewDrawFrameTable(argc, dynStack);
    for (i = 0; i < argc; i++) {
        dynNowDA->SetDrawFrame(i, spiGetStackInt(stack++));
    }
    return 1;
}
int dynBIND_VERTEX_START(SPI_STACK *stack, int argc) {
    dynNowDA->NewBindVertexTable(spiGetStackInt(stack), dynStack);
    return 1;
}
int dynBIND_VERTEX(SPI_STACK *stack, int argc) {
    DA_BIND_VERTEX *bind;
    int vertex1;
    int vertex2;
    float pos1[4];
    float pos2[4];
    float weight;

    bind = dynNowDA->pGetBindVertex(dynBindVertexCount++);
    if (bind == NULL) {
        return 0;
    }
    vertex1 = spiGetStackInt(stack++);
    vertex2 = spiGetStackInt(stack++);
    if (dynNowDA->CheckVertexID(vertex1) == 0 || dynNowDA->CheckVertexID(vertex2) == 0) {
        printf(at_1025, vertex1, vertex2);
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
int dynBIND_VERTEX_END(SPI_STACK *stack, int argc) {
    return 1;
}
int dynBOUNDING_BOX_START(SPI_STACK *stack, int argc) {
    dynNowDA->NewBoundingBoxTable(spiGetStackInt(stack), dynStack);
    return 1;
}
int dynBOUNDING_BOX(SPI_STACK *stack, int argc) {
    DA_BOUNDING_BOX *box;

    box = dynNowDA->pGetBoundingBox(dynBBoxCount++);
    if (box == NULL) {
        return 0;
    }
    box->frame_id = spiGetStackInt(stack++);
    if (argc >= 4) {
        spiGetStackVector(box->unk_0, stack);
        stack += 3;
        *(u_long128 *)box->unk_10 = *(u_long128 *)box->unk_0;
    }
    if (argc >= 7) {
        spiGetStackVector(box->unk_10, stack);
    }
    return 1;
}
int dynBOUNDING_BOX_END(SPI_STACK *stack, int argc) {
    return 1;
}
int dynCOLLISION_START(SPI_STACK *stack, int argc) {
    dynNowDA->NewCollisionTable(spiGetStackInt(stack), dynStack);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dynamicanime", dynCOLLISION__FP9SPI_STACKi);
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
int dynCOLLISION_END(SPI_STACK *stack, int argc) {
    return 1;
}
int dynGRAVITY(SPI_STACK *stack, int argc) {
    spiGetStackVector(dynNowDA->gravity, stack);
    dynNowDA->gravity[3] = 0.0f;
    return 1;
}
int dynK(SPI_STACK *stack, int argc) {
    dynNowDA->k = spiGetStackFloat(stack);
    return 1;
}
int dynWind(SPI_STACK *stack, int argc) {
    dynNowDA->wind_scale = spiGetStackFloat(stack);
    return 1;
}
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
        interp.SetTag((SPI_TAG_PARAM *)dynmc_tag);
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
    sceVu0ApplyMatrix(local, (float(*)[4])inverse_matrix, point);
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
    sceVu0ApplyMatrix(point, (float(*)[4])lw_matrix, local);
    return 1;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", dynmc_tag__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_816__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_817__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_818__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_819__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_820__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_821__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_822__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_823__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_824__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_825__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_826__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_827__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_828__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_829__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_830__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_831__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_832__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_833__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_834__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_835__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_836__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_837__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_838__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_839__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_840__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_841__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_842__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_855__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_976__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_977__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_978__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_979__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_1025__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", at_1074__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", __vt__10CDAColPipe__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dynamicanime", __vt__12CDACollision__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(dynNowDA, 0x4);
INCLUDE_BSS(dynStack, 0x4);
INCLUDE_BSS(dynTopFrame, 0x4);
INCLUDE_BSS(dynFrameCount, 0x4);
INCLUDE_BSS(dynVertexCount, 0x4);
INCLUDE_BSS(dynFixVertexCount, 0x4);
INCLUDE_BSS(dynBindVertexCount, 0x4);
INCLUDE_BSS(dynBBoxCount, 0x4);
INCLUDE_BSS(dynColCount, 0x4);
