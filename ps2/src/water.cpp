#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "water.hpp"
#include <cstring>
#include <cmath>
#include <cstdlib>

// Code (.text)
void CFireRaster::Step(void) {
    FireRasterParticle *free_slot = 0;
    int i = 0;
    FireRasterParticle *particle_slot;
    int phase = 0;
    for (; i < 20; i++, phase += 2) {
        particle_slot = &particle[i];
        if (particle_slot->life <= 0) {
            free_slot = particle_slot;
        } else if (particle_slot->time >= particle_slot->life) {
            memset(particle_slot, 0, sizeof(FireRasterParticle));
        } else {
            particle_slot->position[1] += 1.2f;
            particle_slot->position[0] = 10.0f * sinf(3.1415927f * ((float)(particle_slot->time + phase) / 10.0f));
            particle_slot->position[2] = 10.0f * sinf(3.1415927f * ((float)(particle_slot->time + phase + 10) / 8.0f));
            particle_slot->size -= 0.1f;
            particle_slot->time++;
        }
    }
    if (free_slot != 0) {
        mgZeroVectorW((float *)free_slot);
        free_slot->size = 13.0f;
        free_slot->time = rand() % 20;
        free_slot->life = 30;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/water", SetTexture__11CFireRasterFP10mgCTexture);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/water", Draw__11CFireRasterFPfPf);
void CFireRaster::Initialize(void) {
    int index = 0;
    do {
        memset(&particle[index], 0, sizeof(particle[index]));
        index++;
    } while (index < 20);
}
void CThunderEffect::Init(void) {
    unk_00 = 0;
    unk_90 = 0;
    unk_94 = 0;
    unk_98 = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/water", Hamon__6CWaterFv);
void CWater::SetVertex(float *a, float *b) {
    mgVectorMaxMin(max, min, a, b);
}
#pragma divbyzerocheck on
void CWater::Shake(int x, int z, float amount) {
    int last_x;
    int last_z;
    float *height;

    x = x % rows;
    z = z % columns;
    if (x <= 0) {
        x = 1;
    }
    if (z <= 0) {
        z = 1;
    }
    last_x = rows - 2;
    if (x > last_x) {
        x = last_x;
    }
    last_z = columns - 2;
    if (z > last_z) {
        z = last_z;
    }
    height = &this->height[z] + x * columns;
    *height += amount;
}
#pragma divbyzerocheck reset
INCLUDE_ASM("ps2/asm/pal/nonmatchings/water", Shake__11CWaterFrameFfff);
CWater *CWaterFrame::GetWater(void) {
    return (CWater *)visual;
}
void CWater::SetSize(int x, int z, mgCMemory *memory) {
    int blocks = x * z / 4 + 1;
    int i;

    height_a = (float *)memory->Alloc(blocks);
    height_b = (float *)memory->Alloc(blocks);
    rows = x;
    columns = z;
    for (i = 0; i < rows * columns; i++) {
        *(int *)&height_b[i] = 0;
        *(int *)&height_a[i] = 0;
    }
    height = height_a;
    unk_50 = 0;
}
void CWater::SetParam(float wave_speed, float wave_damping, float param_48, float param_4c) {
    speed = wave_speed;
    damping = wave_damping;
    unk_48 = param_48;
    unk_4c = param_4c;
}
void CWater::SetColor(u_char red, u_char green, u_char blue, u_char alpha) {
    color[0] = red;
    color[1] = green;
    color[2] = blue;
    color[3] = alpha;
}
CWater::CWater() {
    rows = 0;
    columns = 0;
    texture = NULL;
    color[0] = 128;
    color[1] = 128;
    color[2] = 128;
    color[3] = 128;
    speed = 0.1f;
    damping = 0.015f;
    unk_48 = 0;
    unk_4c = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/water", CreateRenderInfoPacket__6CWaterFPUiPA4_fP13mgRENDER_INFO);
int CWater::Draw(u_int *tag, float (*matrix)[4], mgCDrawManager *draw_manager) {
    if (draw_manager == NULL) {
        draw_manager = &mgDrawManager;
    }
    mgRENDER_INFO *render_info = draw_manager->render_info;
    texture_manager = draw_manager->texture_manager;
    mgCMemory *data_memory = (mgCMemory *)draw_manager->data_memory;
    int render_info_packet = (int)data_memory->stAllocTest(0x3C);
    data_memory->Alloc(
        CreateRenderInfoPacket((u_int *)render_info_packet, matrix, (mgRENDER_INFO *)render_info));
    int water_packet = packet;
    if (tag != NULL) {
        u_int *cursor = tag + 4;
        tag[0] = 0x50000000;
        tag[1] = render_info_packet;
        tag[2] = 0;
        tag[3] = 0;
        cursor += mgSendVuProg(cursor, MG_VU_PROG_USER);
        cursor[0] = 0x50000000;
        cursor[1] = water_packet;
        cursor[2] = 0;
        cursor[3] = 0;
        return (int)(cursor + 4 - tag) / 4;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/water", CreatePacket__6CWaterFP14mgCDrawManager);
void CWaterFrame::SetTexture(mgCTexture *texture) {
    CWater *surface = GetWater();
    if (surface) {
        surface->texture = texture;
    }
}
void CWaterFrame::Step(void) {
    CWater *surface = GetWater();
    if (surface == 0 || stop != 0) {
        return;
    }
    surface->Hamon();
}
void CWaterFrame::SetParam(float p0, float p1, float p2, float p3) {
    CWater *surface = GetWater();
    if (surface) {
        surface->SetParam(p0, p1, p2, p3);
    }
}
void CWaterFrame::SetColor(u_char r, u_char g, u_char b, u_char a) {
    CWater *surface = GetWater();
    if (surface) {
        surface->SetColor(r, g, b, a);
    }
}
void CWaterFrame::Shake(int x, int z, float amount) {
    CWater *surface = GetWater();
    if (surface) {
        surface->Shake(x, z, amount);
    }
}
void CWaterFrame::CreatePacket(void) {
    GetWater()->CreatePacket(&mgDrawManager);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/water", CreateWaterFrame__FiiPfPfP9mgCMemory);
void CWaterFrame::Initialize(void) {
    unk_110 = 0;
    stop = 0;
    ((mgCFrame *)this)->Initialize();
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/water", prog_vif_351__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/water", progf_vif_352__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/water", __vt__11CWaterFrame__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/water", __vt__6CWater__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(at_287__2, 0x10);
