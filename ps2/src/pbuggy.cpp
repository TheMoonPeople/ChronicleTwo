#include "common.h"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "effscript.hpp"
#include "mg_frame.hpp"
#include "nd_meswin.hpp"
#include "mg_drawprim.hpp"
#include "savedata.hpp"
#include "mainloop.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "scenesnd.hpp"
#include "subgame.hpp"
#include "snd_mngr.hpp"
#include "pbuggy.hpp"
#include "dataread.hpp"
#include "mglib.hpp"
#include "mg_math.hpp"
#include "editctrl.hpp"

#include "padcontrol.hpp"
#include <cstring>
#include <cmath>

void InitBuggy(CScene *scene);
void InitBomb(CScene *scene);
void BuggyControl(CScene *scene);
void BombControl(CScene *scene);
void BombCheck(CScene *scene);
extern "C" int fptosi(float value);
struct EffectScriptSpriteState {
    u_char padding[0x30];
    u_char sprite[0x1C];
    void *sprite_vtable;
};
extern void *__vt__9mgCVisual[];
extern void *__vt__11mgC3DSprite[];

extern int BuggyTexb;
extern int PorcussTexb;
extern int MucchoTexb;
extern int BombTexb;
extern int StarbullTexb;
extern int GunEffTexb;
extern int EffectTexb__2;
extern int EffectTexbNum;
extern int WorkBuff;
extern int CharaStatus;
extern mgCMemory EffectBuff;
extern sgCPlayVoice PolVoice;
extern int IntroHelpMesFlag;
extern CCharacter2 *PorcussChara;
extern CCharacter2 *MucchoChara;
extern CCharacter2 *StarbullChara;
extern int RunEventNo__2;
extern CCharacter2 *GunFireEff;
extern CCharacter2 *GunHitEff;
extern "C" void CharaControl__FP6CSceneP11CPadControl__3(CScene *scene, CPadControl *pad);

extern u32 BombHitObj;
extern u32 BuggyActCount;
extern u32 BuggyDamageMotion;
extern int BuggyHP;
extern u32 BuggyStatus;
extern u32 BuggyStatusStep;
extern u32 BombStatus;
extern u32 BombCount;
extern float BombVelo[4];
extern CCharacter2 *BombChara;
extern int SysTexb;
extern char at_1056[];
extern char at_1047__3[];
extern char at_1048__4[];
extern CCharacter2 *BuggyChara;
extern int BuggySidePos;
extern int SmokeEffHandle;
extern float BuggyHPf;
extern float TrainHP;
extern float BuggyVelo[4];
extern int GunFireEffDraw;
extern int GunHitEffDraw;
extern CEffectScriptMan *EffectMan__2;
extern char at_962__4[];
extern int BuggySndID;
extern char at_942__4[];
extern char at_943__5[];
extern char at_944__4[];
extern char at_945__6[];
extern char at_946__5[];
extern char at_947__5[];
extern char at_948__5[];
extern char at_949__6[];
extern char at_950__6[];
extern char at_951__5[];
extern char at_952__5[];
extern char at_953__4[];
extern char at_954__4[];
extern char at_955__3[];
extern char at_956__3[];
extern char at_957__3[];
extern char at_958__5[];
extern char at_959__5[];
extern char at_960__3[];
extern char at_961__4[];
extern char at_963__3[];
extern char at_964__3[];

// Code (.text)
int sgInitBuggy(SubGameInfo *info) {
    CScene *scene;
    mgCMemory *stack;
    int i;
    u32 *pack;
    mgCTextureManager *texture_manager;
    CCharacter2 *player;
    int img_size;
    CCameraControl *camera;
    ClsMes *message;
    mgCFrame *buggy_frame;
    mgCFrame *gun_fire_frame;
    mgCFrame *porcuss_frame;
    mgCFrame *muccho_frame;
    mgCFrame *frame;
    u32 *file;
    u8 *img_copy;
    CEffectScriptMan *effects;

    BuggyTexb = info->texb;
    EffectTexbNum = 5;
    PorcussTexb = BuggyTexb + 1;
    MucchoTexb = PorcussTexb + 1;
    BombTexb = MucchoTexb + 1;
    StarbullTexb = BombTexb + 1;
    GunEffTexb = StarbullTexb + 1;
    SysTexb = GunEffTexb + 1;
    EffectTexb__2 = SysTexb + 1;
    scene = info->scene;
    player = scene->GetCharacter(scene->player_chara);
    if (player == NULL) {
        return 0;
    }
    scene->AssignStack(5);
    stack = (mgCMemory *)scene->GetStack(5);
    pack = (u32 *)scene->read_buff;
    texture_manager = &mgTexManager;
    for (i = 0; i < info->texb_num; i++) {

        ((mgCTextureManager *)texture_manager)->DeleteBlock(info->texb + i);
    }
    WorkBuff = (int)operator new[](0x27100, stack->Alloc(0x2712));
    EffectBuff.SetHeapMem(stack->Alloc(0x4E20), 0x4E20);
    if (LoadFile2(at_942__4, pack, NULL, 0) == 0) {
        return 0;
    }
    if ((file = (u32 *)GetPackFile(pack, at_943__5, NULL)) != NULL) {
        scene->LoadChara(0x40, file, at_944__4, stack, stack, stack, BuggyTexb, 0);
    }
    if ((file = (u32 *)GetPackFile(pack, at_945__6, NULL)) != NULL) {
        scene->LoadChara(0x41, file, at_946__5, stack, stack, stack, PorcussTexb, 0);
    }
    if ((file = (u32 *)GetPackFile(pack, at_947__5, NULL)) != NULL) {
        scene->LoadChara(0x42, file, at_948__5, stack, stack, stack, MucchoTexb, 0);
    }
    if ((file = (u32 *)GetPackFile(pack, at_949__6, NULL)) != NULL) {
        scene->LoadChara(0x44, file, at_950__6, stack, stack, stack, StarbullTexb, 0);
    }
    if ((file = (u32 *)GetPackFile(pack, at_951__5, NULL)) != NULL) {
        scene->LoadChara(0x43, file, at_950__6, stack, stack, stack, BombTexb, 0);
    }
    if ((file = (u32 *)GetPackFile(pack, at_952__5, NULL)) != NULL) {
        scene->LoadChara(0x45, file, at_950__6, stack, stack, stack, GunEffTexb, 1);
    }
    if ((file = (u32 *)GetPackFile(pack, at_953__4, NULL)) != NULL) {
        scene->LoadChara(0x46, file, at_950__6, stack, stack, stack, GunEffTexb, 1);
    }
    BuggyChara = scene->GetCharacter(0x40);
    PorcussChara = scene->GetCharacter(0x41);
    MucchoChara = scene->GetCharacter(0x42);
    BombChara = scene->GetCharacter(0x43);
    StarbullChara = scene->GetCharacter(0x44);
    GunFireEff = (CCharacter2 *)scene->GetCharacter(0x45);
    GunHitEff = (CCharacter2 *)scene->GetCharacter(0x46);
    scene->SetActive(1, 0x40);
    ((CScene *)scene)->SetCharaTexb(0x40, BuggyTexb);
    scene->SetActive(1, 0x41);
    ((CScene *)scene)->SetCharaTexb(0x41, PorcussTexb);
    scene->SetActive(1, 0x42);
    ((CScene *)scene)->SetCharaTexb(0x42, MucchoTexb);
    ((CScene *)scene)->SetCharaTexb(0x43, BombTexb);
    scene->SetActive(1, 0x44);
    ((CScene *)scene)->SetCharaTexb(0x44, StarbullTexb);
    scene->SetActive(1, 0x45);
    ((CScene *)scene)->SetCharaTexb(0x45, GunEffTexb);
    scene->SetActive(1, 0x46);
    ((CScene *)scene)->SetCharaTexb(0x46, GunEffTexb);
    if (BuggyChara == NULL || PorcussChara == NULL || MucchoChara == NULL) {
        return 0;
    }
    if (BombChara == NULL || StarbullChara == NULL) {
        return 0;
    }
    if (GunFireEff == NULL || GunHitEff == NULL) {
        return 0;
    }
    buggy_frame = BuggyChara->CObjectFrame::frame;
    porcuss_frame = PorcussChara->CObjectFrame::frame;
    muccho_frame = MucchoChara->CObjectFrame::frame;
    gun_fire_frame = ((CCharacter2 *)GunFireEff)->CObjectFrame::frame;
    if (buggy_frame == NULL || porcuss_frame == NULL || muccho_frame == NULL || gun_fire_frame == NULL) {
        return 0;
    }
    porcuss_frame->SetReference(buggy_frame->SearchFrame(at_954__4));
    muccho_frame->SetReference(buggy_frame->SearchFrame(at_955__3));
    gun_fire_frame->SetReference(buggy_frame->SearchFrame(at_956__3));
    frame = gun_fire_frame->SearchFrame(at_957__3);
    if (frame != NULL) {
        *(int *)((u8 *)frame->attr + 0x18) = 0;
    }
    frame = gun_fire_frame->SearchFrame(at_958__5);
    if (frame != NULL) {
        *(int *)((u8 *)frame->attr + 0x18) = 0;
    }
    if ((file = (u32 *)GetPackFile(pack, at_959__5, NULL)) != NULL) {
        player->LoadPack(file, at_950__6, stack, stack, stack, 0, 0);
    }
    stack->Align64();
    if ((file = (u32 *)GetPackFile(pack, at_960__3, &img_size)) != NULL) {
        u32 blocks;
        if (img_size & 0xF) {
            blocks = ((u32)img_size >> 4) + 1;
        } else {
            blocks = (u32)img_size >> 4;
        }
        img_copy = (u8 *)stack->Alloc(blocks);
        if (img_copy != NULL) {
            memcpy(img_copy, file, img_size);
            ((mgCTextureManager *)texture_manager)->EnterIMGFile(img_copy, SysTexb, NULL, NULL);
        }
    }
    void *memory = operator new(sizeof(CEffectScriptMan), stack->Alloc(0x11B));
    effects = (CEffectScriptMan *)memory;
    if (memory != NULL) {
        EffectScriptSpriteState *sprite = (EffectScriptSpriteState *)effects;
        sprite->sprite_vtable = __vt__9mgCVisual;
        ((mgC3DSprite *)sprite->sprite)->Initialize();
        sprite->sprite_vtable = __vt__11mgC3DSprite;
        ((mgC3DSprite *)sprite->sprite)->Initialize();
        effects->Initialize(NULL, -1, -1);
    }
    effects->Initialize(stack, EffectTexb__2, EffectTexbNum);
    effects->load_buffer = (u_long128 *)pack;
    effects->SetWorkBuffer(&EffectBuff);
    effects->LoadBaseEffSpt(at_961__4, NULL, -1);
    effects->LoadBaseEffSpt(at_962__4, NULL, -1);
    ((CScene *)scene)->AssignEffect(7, effects, NULL);
    EffectMan__2 = (CEffectScriptMan *)scene->GetEffect(7);
    if (EffectMan__2 == NULL) {
        return 0;
    }
    BuggySndID = -1;
    if (LoadFile2(at_963__3, pack, NULL, 0) != 0) {
        sndInitPort(5);
        BuggySndID = sndLoadSound(5, pack, stack);
    }

    ((CScene *)scene)->LoadBGM(0xBF, (u_long128 *)pack);
    scene->PlayBGM(0, -1, 1.0f);
    InitBuggy(scene);
    InitBomb(scene);
    CharaStatus = 0;
    player->SetMotion(at_964__3, 4);
    RunEventNo__2 = -1;
    player->SetPosition(0.0f, 134.0f, -340.0f);
    player->SetRotation(0.0f, 0.0f, 0.0f);
    camera = (CCameraControl *)scene->GetCamera(scene->active_camera);
    if (camera != NULL) {
        camera->SetRotate(3.14f);
        camera->RotBack(2.6415927f);
        ((mgCCamera *)camera)->Step(-1);
    }
    message = scene->GetMessage(1);
    message->Preset(4);
    message->SetWindowMode(4);
    message->MakeMesWin(0x7D0);
    message->fukidashi_pos = 8;
    IntroHelpMesFlag = 1;
    PolVoice.step = 0;
    PolVoice.play = 0;
    PolVoice.vol_l = 1.0f;
    PolVoice.vol_r = 1.0f;
    PolVoice.SetVol(0.6f, -1.0f);
    return 1;
}
int sgExitBuggy(SubGameInfo *info) {
    CScene *scene;
    mgCTextureManager *tm;
    int i;
    int j;
    PolVoice.Close();
    scene = info->scene;
    if (scene->GetCharacter(scene->player_chara) == NULL) {
        return 0;
    }
    tm = &mgTexManager;
    for (i = 0; i < info->texb_num; i++) {
        tm->DeleteBlock(info->texb + i);
    }
    j = 0;
    do {
        scene->DeleteChara(j + 0x40);
        j++;
    } while (j < 0x28);
    scene->DeleteEffect(7);
    scene->StopBGM(0);
    return 1;
}
int sgLoopBuggy(SubGameInfo *info) {
    CScene *scene = info->scene;
    ClsMes *message;
    CPadControl *pad = &PadCtrl;
    if (IntroHelpMesFlag != 0) {
        if (pad->Btn(0) != 0) {
            message = scene->GetMessage(1);
            if (message->select < 0) {
                message->cursor_time = 0;
            }
            message->select = -1;
            message->draw_speed = message->GetDrawSpeedDef();
            message->mes_no = -1;
            message->unk_1e40 = 0;
            message->open = 0;
            message->fade = 0.0f;
            message->fukidashi_centre_x = -1;
            message->fukidashi_centre_y = -1;
            message->fukidashi_pos = 0;
            IntroHelpMesFlag = 0;
        }
        EditCameraControl(scene, NULL, NULL);
        void *camera = scene->GetCamera(scene->active_camera);
        if (camera != NULL) {
            ((mgCCamera *)camera)->Step(-1);
        }
    } else {
        CharaControl__FP6CSceneP11CPadControl__3(scene, pad);
        BombCheck(scene);
        BuggyControl(scene);
        BombControl(scene);
    }
    BuggyChara->Step();
    PorcussChara->Step();
    MucchoChara->Step();
    BombChara->Step();
    StarbullChara->Step();
    if (RunEventNo__2 <= 0) {
        if (BuggyHP <= 0) {
            RunEventNo__2 = 0x1F7;
            scene->fade.FadeOut(0x1E, 0.0f, 0.0f, 0.0f);
        }
        if (TrainHP <= 0.0f) {
            RunEventNo__2 = 0x1F6;
            scene->fade.FadeOut(0x5A, 0.0f, 0.0f, 0.0f);
        }
    } else if (scene->fade.FadeCheck() != 0) {
        scene->loop_se.AllSeStop();
        scene->RunEvent(RunEventNo__2, NULL);
        sgExitBuggy(info);
        return 1;
    }
    return 0;
}
int sgDrawBuggy(SubGameInfo *info) {
    CScene *scene;

    scene = info->scene;
    scene->DrawChara(0x40, 1);
    scene->DrawChara(0x41, 1);
    scene->DrawChara(0x42, 1);
    scene->DrawChara(0x44, 1);
    scene->DrawChara(0x43, 1);
    return 1;
}
int sgEffectDrawBuggy(SubGameInfo *info) {
    CScene *scene = info->scene;
    if (GunFireEffDraw > 0) {
        GunFireEffDraw--;
        GunFireEff->Step();
        scene->DrawChara(0x45, 1);
    }
    if (GunHitEffDraw > 0) {
        GunHitEffDraw--;
        GunHitEff->Step();
        scene->DrawChara(0x46, 1);
    }
    return 1;
}
int sgDrawShadowBuggy(SubGameInfo *info) {
    CScene *scene;

    scene = info->scene;
    scene->DrawCharaShadow(0x40);
    scene->DrawCharaShadow(0x44);
    scene->DrawCharaShadow(0x41);
    scene->DrawCharaShadow(0x42);
    return 1;
}
int sgSystemDrawBuggy(SubGameInfo *info) {

    int buggy_bar_x = 0x4F;
    float gauge_width = 173.0f;

    mgTexManager.ReloadTexture(SysTexb, (sceVif1Packet *)NULL);
    mgCTexture *gauge_texture = mgTexManager.GetTexture(at_1056, -1);

    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.AlphaBlendEnable(1);
    prim.DepthTestEnable(0);
    prim.Coord(0);
    prim.ZMask(-1);
    prim.TextureMapEnable(0);
    prim.Begin(6);
    prim.Color(0x1E, 0x2E, 0x1F, 0x60);
    prim.Vertex(0x3E, 0x26, 0);
    prim.Vertex(0xEB, 0x2C, 0);
    prim.End();
    prim.TextureMapEnable(1);
    prim.Begin(6);
    prim.Texture(gauge_texture);
    int train_width = fptosi(gauge_width * TrainHP);
    prim.Color(0x80, 0x80, 0x80, 0x80);
    prim.TextureCrd(0xF8, 0x39);
    prim.Vertex(0x3E, 0x26, 0);
    prim.TextureCrd(0xFE, 0x3F);
    prim.Vertex(train_width + 0x3E, 0x2C, 0);
    prim.TextureCrd(0, 0);
    prim.Vertex(0x14, 0x14, 0);
    prim.TextureCrd(0xE2, 0x28);
    prim.Vertex(0xF6, 0x3C, 0);
    prim.End();
    float target_hp = (float)(int)BuggyHP;
    int bar_y = mgScreenHeight - 0x3E;
    if (!(BuggyHPf <= target_hp)) {
        float eased = BuggyHPf - 0.05f;
        BuggyHPf = eased;
        if (eased < target_hp) {
            BuggyHPf = target_hp;
        }
    }
    float ratio = BuggyHPf / 3.0f;
    float color_full[4];
    float color_empty[4];
    *(u_long128 *)color_full = *(u_long128 *)at_1047__3;
    *(u_long128 *)color_empty = *(u_long128 *)at_1048__4;
    float color_delta[4];
    float color_now[4];
    sceVu0SubVector(color_delta, color_empty, color_full);
    sceVu0ScaleVector(color_delta, color_delta, ratio);
    sceVu0AddVector(color_now, color_full, color_delta);

    SV_CONFIG_OPTION *options = &GetSaveData()->config;
    if (options->enemy_hp != 0) {
        return 1;
    }
    prim.TextureMapEnable(0);
    prim.Shading(1);
    prim.Begin(4);
    prim.Color(color_full);
    prim.Vertex(buggy_bar_x, bar_y + 0x1F, 0);
    prim.Color(color_full);
    prim.Vertex(buggy_bar_x, bar_y + 0x25, 0);
    prim.Color(color_now);
    int bar_end = fptosi(gauge_width * ratio) + buggy_bar_x;
    prim.Vertex(bar_end, bar_y + 0x1F, 0);
    prim.Color(color_now);
    prim.Vertex(bar_end, bar_y + 0x25, 0);
    prim.End();
    prim.TextureMapEnable(1);
    prim.Begin(6);
    prim.Texture(gauge_texture);
    prim.Color(0x80, 0x80, 0x80, 0x80);
    prim.TextureCrd(0, 0x28);
    prim.Vertex(0x20, bar_y, 0);
    prim.TextureCrd(0xE8, 0x5A);
    prim.Vertex(0x108, bar_y + 0x32, 0);
    prim.End();
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/pbuggy", CharaControl__FP6CSceneP11CPadControl__3);
void InitBuggy(CScene *scene) {
    float x = 225.0f;
    float y = 0.0f;
    float z = -1100.0f;
    BuggyChara->SetPosition(x, y, z);
    BuggySidePos = 1;
    BuggyStatus = 0;
    BuggyStatusStep = 0;
    SmokeEffHandle = EffectMan__2->CreateEffSpt(at_962__4, 0x40, 1);
    BuggyHP = 3;
    BuggyHPf = 3.0f;
    TrainHP = 1.0f;
    mgZeroVector(BuggyVelo);
    GunFireEffDraw = 0;
    BuggyActCount = 0x64;
    GunHitEffDraw = 0;
}
void BuggyDamage(int damage_motion) {
    if (BuggyStatus != 1) {
        BuggyDamageMotion = damage_motion;
        BuggyStatus = 2;
        BuggyStatusStep = 0;
        BuggyActCount = 1;
        BombHitObj = 1;
        BuggyHP -= 1;
    }
}
void PlayBuggyLoopSe(CScene *scene, int state) {
    float position[4];
    float volume;
    float pan;
    CLoopSeMngr *loop_se = &scene->loop_se;

    BuggyChara->GetPosition(position);
    sndGetVolPan(&volume, &pan, position, 400.0f, 1600.0f);
    if (state == 2) {
        loop_se->SeLoopPlayStop(BuggySndID, 2, 3, volume, pan, 1);
    }
    if (state == 6) {
        loop_se->SeLoopPlayStop(BuggySndID, 6, 3, volume, pan, 2);
    }
    if (state == 4) {
        loop_se->SeLoopPlayStop(BuggySndID, 4, 3, volume, pan, 3);
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/pbuggy", BuggyControl__FP6CScene);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/pbuggy", InitBomb__FP6CScene);
int TakeBombCheck(void) {

    return (BombStatus != 3) ^ 1;
}
int TakeBomb(void) {
    if (TakeBombCheck() == 0) {
        return 0;
    }
    BombStatus = 4;
    return 1;
}
int ThrowBomb(float *velocity) {
    float matrix[4][4];
    BombCount = 0x32;
    *(u_long128 *)BombVelo = *(u_long128 *)velocity;
    BombStatus = 6;
    BombHitObj = 0;
    mgCFrame *frame = BombChara->CObjectFrame::frame;
    frame->GetLWMatrix(matrix);
    frame->DeleteReference();
    BombChara->SetPosition(matrix[3]);
    float yaw = atan2f(matrix[2][0], matrix[2][2]);
    BombChara->SetRotation(0.0f, yaw, 0.0f);
    return 1;
}
int BombBomb(void) {
    if (BombStatus == 6) {
        mgZeroVector(BombVelo);
        BombCount = 0;
        BombHitObj = 1;
        return 1;
    }
    return 0;
}
int NowPutBomb(void) {
    return BombStatus == 3;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/pbuggy", BombControl__FP6CScene);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/pbuggy", BombCheck__FP6CScene);

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/pbuggy", __sinit_pbuggy_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1047__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1048__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1074__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1193__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_942__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_943__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_944__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_945__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_946__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_947__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_948__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_949__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_950__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_951__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_952__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_953__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_954__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_955__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_956__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_957__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_958__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_959__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_960__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_961__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_962__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_963__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_964__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1056__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1156__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1157__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1158__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1159__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1160__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1161__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1302__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1303__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1304__9__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1305__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1306__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1307__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1316__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1433__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1434__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", at_1435__3__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", D_0037B090__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/pbuggy", BuggyHP__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(BuggyChara, 0x4);
INCLUDE_BSS(PorcussChara, 0x4);
INCLUDE_BSS(MucchoChara, 0x4);
INCLUDE_BSS(BombChara, 0x4);
INCLUDE_BSS(StarbullChara, 0x4);
INCLUDE_BSS(GunFireEff, 0x4);
INCLUDE_BSS(GunHitEff, 0x4);
INCLUDE_BSS(BombEffHandle, 0x4);
INCLUDE_BSS(SmokeEffHandle, 0x4);
INCLUDE_BSS(BuggyTexb, 0x4);
INCLUDE_BSS(PorcussTexb, 0x4);
INCLUDE_BSS(MucchoTexb, 0x4);
INCLUDE_BSS(EffectTexb__2, 0x4);
INCLUDE_BSS(EffectTexbNum, 0x4);
INCLUDE_BSS(BombTexb, 0x4);
INCLUDE_BSS(StarbullTexb, 0x4);
INCLUDE_BSS(GunEffTexb, 0x4);
INCLUDE_BSS(SysTexb, 0x4);
INCLUDE_BSS(EffectMan__2, 0x4);
INCLUDE_BSS(RunEventNo__2, 0x4);
INCLUDE_BSS(WorkBuff, 0x4);
INCLUDE_BSS(BuggySndID, 0x4);
INCLUDE_BSS(IntroHelpMesFlag, 0x4);
INCLUDE_BSS(CharaStatus, 0x4);
INCLUDE_BSS(BuggyStatus, 0x4);
INCLUDE_BSS(BuggyStatusStep, 0x4);
INCLUDE_BSS(BuggyHPf, 0x4);
INCLUDE_BSS(TrainHP, 0x4);
INCLUDE_BSS(BuggyActCount, 0x4);
INCLUDE_BSS(BuggySidePos, 0x4);
INCLUDE_BSS(BuggyDamageMotion, 0x4);
INCLUDE_BSS(GunFireEffDraw, 0x4);
INCLUDE_BSS(GunHitEffDraw, 0x4);
INCLUDE_BSS(BombStatus, 0x4);
INCLUDE_BSS(BombCount, 0x4);
INCLUDE_BSS(BombHitObj, 0x4);
INCLUDE_BSS(BombImpact, 0x4);
INCLUDE_BSS(test_1254, 0x4);
INCLUDE_BSS(init_1255, 0x4);
INCLUDE_BSS(reload_cnt_1350, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(StarbullPos, 0x10);
INCLUDE_BSS(EffectBuff, 0x30);
INCLUDE_BSS(BuggyVelo, 0x10);
INCLUDE_BSS(BombVelo, 0x10);
INCLUDE_BSS(PolVoice, 0x20);
