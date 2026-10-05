#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "actionchara.hpp"
#include "scene.hpp"
#include "object.hpp"
#include "padcontrol.hpp"
#include "cameracontrol.hpp"
#include "gyorace.hpp"
#include "subgame.hpp"
#include "scenesnd.hpp"

struct CHitEffectImage;
extern int EffectTexb;
extern u_char water_cam;
extern CHitEffectImage *battle_effect;
extern "C" void Step__15CHitEffectImageFv(CHitEffectImage *effect);
extern "C" void Draw__15CHitEffectImageFv(CHitEffectImage *effect);
extern "C" void DivSpriteScreen__FR11mgCDrawPrim__2(mgCDrawPrim *prim);

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", sgInitGyoRace__FP11SubGameInfo);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", sgLoopGyoRace__FP11SubGameInfo);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", AutoCam__FP11SubGameInfo);
int sgMapDrawGyoRace(SubGameInfo *info) {
    return 0;
}
int sgCharaDrawGyoRace(SubGameInfo *info) {
    CScene *scene;
    int i;
    int offset;
    scene = info->scene;
    i = 0;
    offset = 0;
    do {
        scene->DrawChara(*(int *)((u_char *)fish_inf + offset + 4), 1);
        i++;
        offset += 0x2C;
    } while (i < 6);
    mgTexManager.ReloadTexture(EffectTexb, (sceVif1Packet *)NULL);
    int j = 0;
    offset = 0;
    CHitEffectImage *effect;
    do {
        effect = (CHitEffectImage *)((u_char *)battle_effect + offset);
        if (effect != 0) {
            Step__15CHitEffectImageFv(effect);
            Draw__15CHitEffectImageFv(effect);
        }
        j++;
        offset += 0x60;
    } while (j < 0x60);
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", DivSpriteScreen__FR11mgCDrawPrim__2);
int sgEffectDrawGyoRace(SubGameInfo *info) {
    mgCDrawPrim prim;
    if (water_cam == 0) {
        return 0;
    }
    prim.Initialize(0, 0);
    mgCTexture frame;
    mgGetFrameBuffer(&frame);
    frame.swizzled = 0;
    prim.DepthTestEnable(0);
    prim.AlphaTestEnable(0);
    prim.AlphaBlendEnable(0);
    prim.ZMask(-1);
    prim.TextureMapEnable(1);
    prim.Begin2();
    prim.BeginPrim2(6);
    prim.Texture(&frame);
    prim.Direct(0x3B, 0x8080 | ((unsigned long)0x80 << 32));
    prim.Color(0x80, 0x80, 0x80, 0x80);
    prim.EndPrim2();
    DivSpriteScreen__FR11mgCDrawPrim__2(&prim);
    prim.End2();
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", sgSysDrawGyoRace__FP11SubGameInfo);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", Jikkyou__FP11SubGameInfo);

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gyorace", __sinit_gyorace_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", fish_name__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", cam_pos__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1027__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1028__9__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1481__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1524__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1547__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1548__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1766__3__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_903__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_904__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_905__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_906__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_907__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_908__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_909__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_910__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_911__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_912__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_913__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_914__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_915__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_916__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_917__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_918__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_919__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_920__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1373__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1374__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1375__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1376__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1377__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1378__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1379__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1380__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1381__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1382__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1383__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1384__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1696__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1697__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1698__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1699__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1700__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1701__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1702__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", at_1703__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", D_0037B07C__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gyorace", old_cam_no__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(gyore_snd_id, 0x4);
INCLUDE_BSS(race_cnt, 0x4);
INCLUDE_BSS(race_proc_cnt, 0x4);
INCLUDE_BSS(race_mode, 0x4);
INCLUDE_BSS(time_max, 0x4);
INCLUDE_BSS(rank_count, 0x4);
INCLUDE_BSS(EffectTex, 0x4);
INCLUDE_BSS(EffectTex2, 0x4);
INCLUDE_BSS(wind_tex, 0x4);
INCLUDE_BSS(hero_no, 0x4);
INCLUDE_BSS(water_cam, 0x4);
INCLUDE_BSS(cam_no, 0x4);
INCLUDE_BSS(win_alpha, 0x4);
INCLUDE_BSS(effect_cnt, 0x4);
INCLUDE_BSS(mes_count, 0x4);
INCLUDE_BSS(jyunkai_flg, 0x4);
INCLUDE_BSS(hantei_flg, 0x4);
INCLUDE_BSS(goal_cnt, 0x4);
INCLUDE_BSS(battle_effect, 0x4);
INCLUDE_BSS(battle_EffectPara, 0x4);
INCLUDE_BSS(camera_id, 0x8);
INCLUDE_BSS(race_rank, 0x8);
INCLUDE_BSS(gyo_mes, 0x4);
INCLUDE_BSS(CharaTexb, 0x4);
INCLUDE_BSS(WindowTexb, 0x4);
INCLUDE_BSS(EffectTexb, 0x4);
INCLUDE_BSS(ras_off_1762, 0x4);
INCLUDE_BSS(init_1763, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(fish_game_data, 0xE0);
INCLUDE_BSS(RaceInfo, 0x1E0);
INCLUDE_BSS(old_prog, 0x90);
INCLUDE_BSS(fish_rank, 0x1C);
INCLUDE_BSS(D_01F5971C, 0x4);
INCLUDE_BSS(old_fish_rank, 0x20);
INCLUDE_BSS(game_data, 0x20);
INCLUDE_BSS(old_ambient, 0x10);
INCLUDE_BSS(BuffTextureData, 0x30);
INCLUDE_BSS(BuffWorkData, 0x30);
INCLUDE_BSS(camera0, 0x70);
INCLUDE_BSS(fish_inf, 0x110);
INCLUDE_BSS(at_1765__2, 0x10);
INCLUDE_BSS(at_1775, 0x10);
INCLUDE_BSS(at_1776, 0x10);
INCLUDE_BSS(lap_inf_1798, 0x30);
INCLUDE_BSS(lap_inf2_1799, 0x50);
