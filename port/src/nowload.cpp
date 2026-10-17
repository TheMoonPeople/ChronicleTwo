#include "common.h"

#include <cstdio>

#include "dataread.hpp"
#include "gamepad.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nowload.hpp"
#include "nowload_port.hpp"
#include "padcontrol.hpp"
#include "platform/config.hpp"
#include "test_hooks.hpp"
#include "title.hpp"

static int start_vcount;

PORT_OVERRIDE void SCElogoFade(int fade_out, mgCMemory *memory) {
    const bool skip_logos = ConfigGet().skip_intro;

    mgCMemory  packet0, packet1, data0, data1;
    u_long128 *vif0 = memory->stAlloc64(0x2710);
    u_long128 *vif1 = memory->stAlloc64(0x2710);
    mgInitVif1Packet(vif0, vif1, 0x27100);
    packet0.stSetBuffer(memory->stAlloc64(0x2710), 0x2710);
    packet1.stSetBuffer(memory->stAlloc64(0x2710), 0x2710);
    mgSetPacketBuffer(&packet0, &packet1);
    data0.stSetBuffer(memory->stAlloc64(0x2710), 0x2710);
    u_long128        *data1_buffer = memory->stAlloc64(0x2710);
    mgCMemory        *data1_pointer = &data1;
    mgCMemory *const &data1_memory = data1_pointer;
    data1_memory->stSetBuffer(data1_buffer, 0x2710);
    mgSetDataBuffer(&data0, data1_memory, 1);
    mgCTextureManager *tex = &mgTexManager;
    tex->SetTableBuffer(10, 10, memory);
    tex->Initialize(mgGetTopVRAMAddress(), -1);
    memory->Align64();
    int   language;
    void *image = &memory->stack[memory->stack_used];

    if (!fade_out) {
        GamePad__2.WaitEnable();
        GamePad__2.UpDate();
        TitleLangSelInit(memory);

        do {
            mgBeginFrame(NULL);
            language = TitleLangSelKey();
            TitleLangSelDraw();
            GamePad__2.UpDate();
            mgEndFrame(NULL);
        } while (!(0 < language));

        LanguageCode = language;
        char path[0x80];
        sprintf(path, "title/title%d.img", language);
        int image_size;

        if (LoadFile2(path, image, &image_size, 0)) {
            tex->EnterIMGFile((unsigned char *) image, 0, NULL, NULL);
            memory->Alloc(image_size / 16 + 1);
        }

        start_vcount = mgGetVSyncCount();
        if (skip_logos) {
            return;
        }
    } else {
        if (skip_logos) {
            return;
        }

        int end_count = start_vcount + 300;
        int remaining = end_count - mgGetVSyncCount();

        if (remaining > 0 && remaining < 300) {
            for (int frame = 0; frame < 65; ++frame) {
                sceGsSyncV(0);
            }
        }
    }

    int         frame;
    mgCTexture *logo;
    int         opacity_value;
    frame = 0;
    opacity_value = 0;

    for (; frame <= 22; ++frame, opacity_value += 128) {
        mgBeginFrame(NULL);
        tex->ReloadTexture(0, (sceVif1Packet *) NULL);
        logo = tex->GetTexture("moji", -1);
        mgCDrawPrim prim;
        prim.Initialize(NULL, NULL);
        prim.AlphaBlendEnable(1);
        prim.TextureMapEnable(1);
        prim.Begin(MG_PRIM_SPRITE);
        int opacity = opacity_value / 20;

        if (opacity > 128) {
            opacity = 128;
        }

        if (fade_out) {
            prim.Color(128, 128, 128, 128 - opacity);
        } else {
            prim.Color(128, 128, 128, opacity);
        }

        prim.Texture(logo);
        prim.TextureCrd(0, 324);
        prim.Vertex(0, 176, 0);
        prim.TextureCrd(512, 384);
        prim.Vertex(512, 236, 0);
        prim.End();
        mgEndFrame(NULL);
    }
}

PORT_OVERRIDE void NowLoadingBarSteEnd() {
    PortProgBarCnt = PortLoadInfo.step_count;
    PortProgBarWidthStep = GameFastLoad() ? 1.0f : 0.05f;
}
