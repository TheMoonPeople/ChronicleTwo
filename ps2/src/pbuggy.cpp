#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdlib>
#include <cstring>

#include "cameracontrol.hpp"
#include "character.hpp"
#include "dataread.hpp"
#include "editctrl.hpp"
#include "effscript.hpp"
#include "gameutil.hpp"
#include "mainloop.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "padcontrol.hpp"
#include "pbuggy.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "subgame.hpp"

void InitBuggy(CScene *scene);
void InitBomb(CScene *scene);
void BuggyControl(CScene *scene);
void BombControl(CScene *scene);
void BombCheck(CScene *scene);
int  TakeBombCheck();
int  TakeBomb();
int  ThrowBomb(float *velocity);
int  NowPutBomb();

extern mgCMemory    EffectBuff;
extern sgCPlayVoice PolVoice;
void                CharaControl(CScene *scene, CPadControl *pad);

extern char              at_962__4[];
extern char              at_942__4[];
extern char              at_943__5[];
extern char              at_944__4[];
extern char              at_945__6[];
extern char              at_946__5[];
extern char              at_947__5[];
extern char              at_948__5[];
extern char              at_949__6[];
extern char              at_950__6[];
extern char              at_951__5[];
extern char              at_952__5[];
extern char              at_953__4[];
extern char              at_954__4[];
extern char              at_955__3[];
extern char              at_956__3[];
extern char              at_957__3[];
extern char              at_958__5[];
extern char              at_959__5[];
extern char              at_960__3[];
extern char              at_961__4[];
extern char              at_963__3[];
extern char              at_964__3[];

/**
 *
 * Buggy effect vector viewed as floats or a quadword.
 *
 */
union BuggyQuad {
    float     values[4]; /**< Floating point components. */
    u_long128 quadword;  /**< The same components as one quadword. */
};

extern BuggyQuad   at_1193;
extern BuggyQuad   at_1074__4;

/**
 * Remaining hits the buggy can withstand.
 */
static int BuggyHP = 1;

/**
 * Enemy buggy character.
 */
static CCharacter2      * BuggyChara;

/**
 * Porcuss character in the buggy game.
 */
static CCharacter2 * PorcussChara;

/**
 * Muccho character in the buggy game.
 */
static CCharacter2 * MucchoChara;

/**
 * Bomb character manipulated by the player.
 */
static CCharacter2      * BombChara;

/**
 * Starbull character in the buggy game.
 */
static CCharacter2 * StarbullChara;

/**
 * Gun muzzle-flash character.
 */
static CCharacter2 * GunFireEff;

/**
 * Gun impact-effect character.
 */
static CCharacter2 * GunHitEff;

/**
 * Handle of the bomb explosion effect.
 */
static int BombEffHandle;

/**
 * Handle of the buggy smoke effect.
 */
static int SmokeEffHandle;

/**
 * Texture block for the buggy character.
 */
int BuggyTexb;

/**
 * Texture block for Porcuss.
 */
int PorcussTexb;

/**
 * Texture block for Muccho.
 */
int MucchoTexb;

/**
 * First texture block for buggy effects.
 */
int EffectTexb__2;

/**
 * Number of texture blocks reserved for buggy effects.
 */
int EffectTexbNum;

/**
 * Texture block for the bomb character.
 */
int BombTexb;

/**
 * Texture block for Starbull.
 */
int StarbullTexb;

/**
 * Texture block for gun effects.
 */
int GunEffTexb;

/**
 * Texture block for the buggy HUD.
 */
static int SysTexb;

/**
 * Script manager for buggy-game effects.
 */
static CEffectScriptMan * EffectMan__2;

/**
 * End event queued until the fade completes.
 */
static int RunEventNo__2;

/**
 * Work buffer allocated for the buggy game.
 */
u8 * WorkBuff;

/**
 * Sound-bank identifier for the buggy game.
 */
static int BuggySndID;

/**
 * Whether the introductory help message is active.
 */
static int IntroHelpMesFlag;

/**
 * Current bomb interaction state of the player.
 */
static int CharaStatus;

/**
 * Current buggy action state.
 */
static u32 BuggyStatus;

/**
 * Step within the current buggy action state.
 */
static u32 BuggyStatusStep;

/**
 * Smoothed buggy health used by the HUD.
 */
static float BuggyHPf;

/**
 * Health of the train defended by the player.
 */
static float TrainHP;

/**
 * Frames remaining in the current buggy action.
 */
static int BuggyActCount;

/**
 * Side of the train used by the buggy.
 */
static int BuggySidePos;

/**
 * Left or right damage animation selected for the buggy.
 */
static u32 BuggyDamageMotion;

/**
 * Frames remaining to draw the muzzle-flash character.
 */
static int GunFireEffDraw;

/**
 * Frames remaining to draw the impact-effect character.
 */
static int GunHitEffDraw;

/**
 * Current state of the player's bomb.
 */
static u32 BombStatus;

/**
 * Countdown for the current bomb state.
 */
static int BombCount;

/**
 * Whether impact has stopped the explosion movement.
 */
static u32 BombHitObj;

/**
 * Frames remaining in the explosion damage window.
 */
static int BombImpact;

/**
 * World position of Starbull.
 */
static float StarbullPos[4];

/**
 * Velocity of the buggy.
 */
static float BuggyVelo[4];

/**
 * Velocity of the bomb.
 */
static float BombVelo[4];

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/pbuggy", sgInitBuggy__FP11SubGameInfo);

int sgExitBuggy(SubGameInfo *info) {
    CScene            *scene;
    mgCTextureManager *tm;
    int                i;
    int                j;
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
    CScene      *scene = info->scene;
    ClsMes      *message;
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
            message->text_ptr = 0;
            message->open = 0;
            message->fade = 0.0f;
            message->fukidashi_centre_x = -1;
            message->fukidashi_centre_y = -1;
            message->fukidashi_pos = 0;
            IntroHelpMesFlag = 0;
        }

        EditCameraControl(scene, NULL, NULL);
        mgCCamera *camera = scene->GetCamera(scene->active_camera);

        if (camera != NULL) {
            camera->Step(-1);
        }
    } else {
        CharaControl(scene, pad);
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

    int   buggy_bar_x = 0x4F;
    float gauge_width = 173.0f;

    mgTexManager.ReloadTexture(SysTexb, (sceVif1Packet *) NULL);
    mgCTexture *gauge_texture = mgTexManager.GetTexture("train_hp", -1);

    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.AlphaBlendEnable(1);
    prim.DepthTestEnable(0);
    prim.Coord(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.TextureMapEnable(0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0x1E, 0x2E, 0x1F, 0x60);
    prim.Vertex(0x3E, 0x26, 0);
    prim.Vertex(0xEB, 0x2C, 0);
    prim.End();
    prim.TextureMapEnable(1);
    prim.Begin(MG_PRIM_SPRITE);
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
    float target_hp = (float) BuggyHP;
    int   bar_y = mgScreenHeight - 0x3E;

    if (!(BuggyHPf <= target_hp)) {
        float eased = BuggyHPf - 0.05f;
        BuggyHPf = eased;

        if (eased < target_hp) {
            BuggyHPf = target_hp;
        }
    }

    float ratio = BuggyHPf / 3.0f;
    float color_full[4] = {255.0f, 96.0f, 0.0f, 128.0f};
    float color_empty[4] = {255.0f, 255.0f, 0.0f, 128.0f};
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
    prim.Begin(MG_PRIM_TRIANGLE_STRIP);
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
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(gauge_texture);
    prim.Color(0x80, 0x80, 0x80, 0x80);
    prim.TextureCrd(0, 0x28);
    prim.Vertex(0x20, bar_y, 0);
    prim.TextureCrd(0xE8, 0x5A);
    prim.Vertex(0x108, bar_y + 0x32, 0);
    prim.End();
    return 1;
}
static inline int BombCPoly(CCPoly *polys, float *bomb, float *pos) { return CreateCharaCPoly(polys, 0x10, bomb, pos, 1.0f, 20.0f); }
/**
 *
 * Steps of the player's bomb pickup, carrying and throwing motions.
 *
 */
enum BUGGY_CHARA_STATE {
    BUGGY_CHARA_FREE = 0,         /**< Moves without carrying a bomb. */
    BUGGY_CHARA_PICKUP_START = 1, /**< Starts the bomb pickup motion. */
    BUGGY_CHARA_PICKING_UP = 2,   /**< Takes the bomb during its pickup motion. */
    BUGGY_CHARA_CARRYING = 3,     /**< Moves with the bomb and accepts a throw. */
    BUGGY_CHARA_THROWING = 4,     /**< Releases the bomb during its throw motion. */
};

/**
 *
 * Steps of the buggy game's bomb from reloading to its explosion.
 *
 */
enum BUGGY_BOMB_STATE {
    BUGGY_BOMB_RELOAD_START = 1, /**< Starts the bomb carrier's reload motion. */
    BUGGY_BOMB_RELOADING = 2,    /**< Releases a new bomb from the carrier's hand. */
    BUGGY_BOMB_PLACED = 3,       /**< Waits for the player to pick it up. */
    BUGGY_BOMB_CARRIED = 4,      /**< Attaches the bomb to the player's hand. */
    BUGGY_BOMB_THROWN = 6,       /**< Moves the thrown bomb until impact or timeout. */
    BUGGY_BOMB_EXPLODING = 7,    /**< Displays the explosion before reloading. */
};

/**
 *
 * Moves the player character and handles bomb input during the buggy game.
 *
 */
void CharaControl(CScene *scene, CPadControl *pad) {
    char             *walk_motion;
    char             *idle_motion;
    char             *run_motion;
    char             *carry_idle_motion;
    char             *carry_walk_motion;
    CCharacter2      *player;
    mgCCamera        *base_camera;
    CCameraControl   *camera;
    sceVu0FVECTOR     player_position;
    sceVu0FVECTOR     velocity;
    sceVu0FVECTOR     player_rotation;
    sceVu0FVECTOR     bomb_position;
    sceVu0FVECTOR     to_bomb;
    sceVu0FVECTOR     direction;
    float             direction_matrix[4][4];
    sceVu0FVECTOR     buggy_position;
    sceVu0FVECTOR     throw_velocity;
    sceVu0FVECTOR     turn_rotation;
    EditMoveCharaInfo move;
    CCPoly            bomb_polys[0x10];
    float             angle;
    float             stick_x;
    float             stick_y;
    float             speed_x;
    float             speed_z;
    float             frame_now;
    float             frame_next;
    float             anim_scale;
    float             target_angle;
    float             next_angle;
    float             angle_error;
    float             strength;
    float             step_scale;
    int               stopped;

    if (pad == NULL) {
        return;
    }
    player = scene->GetCharacter(scene->player_chara);
    if (player != NULL) {
        base_camera = scene->GetCamera(scene->active_camera);
        if (base_camera != NULL) {
            switch (base_camera->Iam()) {
                case CAMERA_KIND_CONTROL:
                    break;
                default:
                    return;
            }
            camera = (CCameraControl *) base_camera;
            BombChara->GetPosition(bomb_position);
            player->GetPosition(player_position);
            player->GetRotation(player_rotation);
            sceVu0SubVector(to_bomb, bomb_position, player_position);
            *(u_long128 *) velocity = *(u_long128 *) player->velocity;
            angle = camera->GetAngle();
            stick_x = pad->Analog(5);
            stick_y = pad->Analog(4);
            speed_x = stick_x * cosf(angle) + stick_y * sinf(angle);
            speed_z = -stick_x * sinf(angle) + stick_y * cosf(angle);
            speed_x *= 5.0f;
            speed_z *= 3.5f;
            if (DebugInfo.chara_move) {
                if (GamePad__2.On(1)) {
                    speed_x *= 3.0f;
                    speed_z *= 3.0f;
                }
                if (pad->Btn(1)) {
                    velocity[1] = 8.0f;
                }
            }
            velocity[0] = speed_x;
            velocity[2] = speed_z;
            velocity[1] -= 0.6f;
            idle_motion = at_964__3;
            walk_motion = "\x83o\x83g\x83\x8b\x95\xe0\x82\xab";
            run_motion = "\x83o\x83g\x83\x8b\x91\x96\x82\xe8";
            carry_idle_motion = "\x8e\x9d\x82\xbf\x8f\xe3\x82\xb0\x92\xe2\x8e~";
            carry_walk_motion = "\x8e\x9d\x82\xbf\x8f\xe3\x82\xb0\x95\xe0\x82\xab";
            anim_scale = 1.0f;
            frame_now = player->GetNowFrame();
            frame_next = frame_now + player->GetStep();
            *(BuggyQuad *) direction = at_1074__4;
            mgUnitMatrix(direction_matrix);
            sceVu0RotMatrixY(direction_matrix, direction_matrix, player_rotation[1]);
            sceVu0ApplyMatrix(direction, direction_matrix, direction);
            sceVu0Normalize(direction, direction);
            switch (CharaStatus) {
                case BUGGY_CHARA_FREE:
                    if (pad->Btn(0) && pad->Btn(0x36) && TakeBombCheck() &&
                        mgDistVector(player_position, bomb_position) <= 40.0f &&
                        mgAngleCmp(player_rotation[1], atan2f(to_bomb[0], to_bomb[2]), 2.0f) == 0) {
                        CharaStatus = BUGGY_CHARA_PICKUP_START;
                    }
                    break;
                case BUGGY_CHARA_PICKUP_START:
                    player->SetMotion("\x8e\x9d\x82\xbf\x8f\xe3\x82\xb0", 6);
                    CharaStatus = BUGGY_CHARA_PICKING_UP;
                    break;
                case BUGGY_CHARA_PICKING_UP:
                    if (frame_now <= 15.0f && !(frame_next <= 15.0f)) {
                        TakeBomb();
                        sndSePlay(BuggySndID, 0xA, 0);
                    }
                    if (player->CheckMotionEnd() != 0) {
                        CharaStatus = BUGGY_CHARA_CARRYING;
                    }
                    break;
                case BUGGY_CHARA_CARRYING:
                    if (pad->Btn(0) != 0) {
                        player->SetMotion("\x94\x9a\x92" "e\x93\x8a\x82\xb0", 6);
                        CharaStatus = BUGGY_CHARA_THROWING;
                    }
                    BuggyChara->GetPosition(buggy_position);
                    camera->RotBack(mgAngleLimit(atan2f(buggy_position[0] - player_position[0],
                                                        buggy_position[2] - player_position[2]) -
                                                 3.1415927f));
                    break;
                case BUGGY_CHARA_THROWING:
                    if (frame_now <= 44.0f && !(frame_next <= 44.0f)) {
                        sceVu0Normalize(direction, direction);
                        sceVu0ScaleVector(throw_velocity, direction, 10.0f);
                        throw_velocity[1] = 6.0f;
                        ThrowBomb(throw_velocity);
                        sndSePlay(BuggySndID, 0xB, 0);
                    }
                    if (player->CheckMotionEnd() != 0) {
                        CharaStatus = BUGGY_CHARA_FREE;
                    }
                    break;
            }
            stopped = 0;
            switch (CharaStatus) {
                case BUGGY_CHARA_PICKUP_START:
                case BUGGY_CHARA_PICKING_UP:
                case BUGGY_CHARA_THROWING:
                    speed_x = 0.0f;
                    velocity[0] = 0.0f;
                    velocity[2] = 0.0f;
                    stopped = 1;
                    speed_z = 0.0f;
                    break;
                case BUGGY_CHARA_CARRYING:
                    idle_motion = carry_idle_motion;
                    walk_motion = carry_walk_motion;
                    anim_scale = 0.3f;
                    run_motion = NULL;
                    break;
            }
            if (!stopped) {
                if (speed_x != 0.0f || speed_z != 0.0f) {
                    player->GetRotation(turn_rotation);
                    target_angle = atan2f(speed_x, speed_z);
                    next_angle = mgAngleInterpolate(turn_rotation[1], target_angle, 0.3f, 0);
                    angle_error = target_angle - next_angle;
                    if (angle_error < 0.0f) {
                        angle_error = -angle_error;
                    }
                    if (!((float) fptosi(angle_error) <= 1.0f)) {
                        velocity[0] *= 0.5f;
                        velocity[2] *= 0.5f;
                    }
                    player->SetRotation(0.0f, next_angle, 0.0f);
                    strength = sqrtf(stick_x * stick_x + stick_y * stick_y);
                    if (strength < 0.8f || run_motion == NULL) {
                        step_scale = 0.1f + strength / 0.8f;
                        if (!(step_scale <= 1.0f)) {
                            step_scale = 1.0f;
                        }
                        player->SetMotion(walk_motion, 0);
                        player->SetStep(anim_scale * step_scale);
                    } else {
                        player->SetMotion(run_motion, 0);
                    }
                } else {
                    player->SetMotion(idle_motion, 0);
                }
            }
            BombChara->GetPosition(bomb_position);
            memset(&move.move_info, 0, sizeof(move.move_info));
            memset(&move, 0, sizeof(move));
            if (NowPutBomb() != 0) {
                move.polys = bomb_polys;
                move.poly_num = CreateCharaCPoly(bomb_polys, 0x10, bomb_position, player_position, 1.0f, 20.0f);
            }
            EditMoveChara(scene, velocity, &move);
            if (camera != NULL) {
                camera->SetRotCameraCancel(1);
            }
            switch (BombStatus) {
                case BUGGY_BOMB_RELOAD_START: {
                    mgCObject &player_object = *player;
                    player_object.SetPosition(0.0f, 134.0f, -340.0f);
                    player_object.SetRotation(0.0f, 0.0f, 0.0f);
                    camera->SetHeight(20.0f);
                    camera->RotBack(2.6415927f);
                    EditCameraControl(scene, pad, NULL);
                    camera->SetHeight(20.0f);
                    camera->Step(-1);
                    break;
                }
                case BUGGY_BOMB_EXPLODING:
                    player->SetPosition(0.0f, 134.0f, -340.0f);
                    player->SetRotation(0.0f, 0.0f, 0.0f);
                case BUGGY_BOMB_THROWN:
                    camera->RotBack(0.0f);
                    EditCameraControl(scene, NULL, &bomb_position);
                    break;
                default:
                    EditCameraControl(scene, pad, NULL);
                    break;
            }
            if (camera != NULL) {
                camera->SetRotCameraCancel(0);
            }
        }
    }
}

/**
 *
 * Places the buggy and resets its health, movement, and visual effects.
 *
 */
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

/**
 *
 * Starts a buggy damage reaction and subtracts one health point.
 *
 */
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

/**
 *
 * Updates a positional looping buggy sound for the selected state.
 *
 */
void PlayBuggyLoopSe(CScene *scene, int state) {
    float        position[4];
    float        volume;
    float        pan;
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

/**
 *
 * Advances the buggy, its attacks, collisions, damage, and movement.
 *
 */
void BuggyControl(CScene *scene) {
    float     position[4];
    CCPoly    polys[0x200];
    float     muzzle_start[4];
    float     muzzle_end[4];
    float     hit_point[4];
    float     muzzle_matrix[4][4];
    mgVu0FBOX box;
    float     entry_position[4];
    int       poly_count;

    BuggyChara->GetPosition(position);
    poly_count = 0;
    mgCFrame *muzzle = BuggyChara->CObjectFrame::frame->SearchFrame(at_956__3);
    *(BuggyQuad *) muzzle_end = at_1193;

    if (muzzle != NULL) {
        muzzle->GetWorldPosition0(muzzle_start);
        muzzle->GetLWMatrix(muzzle_matrix);
        sceVu0ApplyMatrix(muzzle_end, muzzle_matrix, muzzle_end);
        mgVectorMaxMin(box.max, box.min, muzzle_start, muzzle_end);
        poly_count = scene->GetColPoly(polys, box, 0x200);
    }

    switch (BuggyStatus) {
        case 0:
            BuggyChara->SetMotion("\x91\x96\x8ds", 0);
            BuggyActCount--;
            PlayBuggyLoopSe(scene, 2);
            break;
        case 3:
            PlayBuggyLoopSe(scene, 2);

            switch (BuggyStatusStep) {
                case 0:
                    if (BuggySidePos == 1) {
                        BuggyChara->SetMotion("\x8d\xb6\x91\xa4\x82\xa9\x82\xe7\x8dU\x8c\x82", 6);
                    } else {
                        BuggyChara->SetMotion("\x89" "E\x91\xa4\x82\xa9\x82\xe7\x8dU\x8c\x82", 6);
                    }

                    if ((rand() >> 16) % 2 != 0) {
                        PolVoice.Open(0x82EBB4);
                    } else {
                        PolVoice.Open(0x82EBBE);
                    }

                    PolVoice.Play();
                    BuggyStatusStep++;
                    break;
                case 1:
                    PlayBuggyLoopSe(scene, 6);

                    if (BuggyChara->CheckMotionEnd() != 0) {
                        BuggyStatusStep++;
                    }

                    GunFireEffDraw = 1;

                    if (GunHitEffDraw <= 0 &&
                        CheckHit(polys, poly_count, muzzle_start, muzzle_end, hit_point, 1, 0) >= 0) {
                        GunHitEffDraw = 3;
                        GunHitEff->SetScale(2.0f, 2.0f, 2.0f);
                        hit_point[1] += 10.0f;
                        GunHitEff->SetPosition(hit_point);
                        float yaw = atan2f(muzzle_start[0] - muzzle_end[0], muzzle_start[2] - muzzle_end[2]);
                        GunHitEff->SetRotation(0.0f, yaw, 0.0f);
                    }

                    TrainHP -= 0.00125f;
                    break;
                case 2:
                    BuggyChara->SetMotion("\x91\x96\x8ds", 4);
                    BuggyActCount = 0;
                    break;
            }

            break;
        case 1:
            switch (BuggyStatusStep) {
                case 0:
                    BuggyChara->SetMotion("\x83W\x83\x83\x83\x93\x83v", 6);
                    BuggyStatusStep++;
                    PlayBuggyLoopSe(scene, 2);

                    if ((rand() >> 16) % 4 == 0) {
                        PolVoice.Open(0x82EBAA);
                        PolVoice.Play();
                    }

                    break;
                case 1:
                    PlayBuggyLoopSe(scene, 2);

                    if (!(BuggyChara->GetNowFrameWait() < 0.1f)) {
                        BuggyStatusStep++;

                        if (BuggySidePos == 1) {
                            BuggyVelo[0] = (-245.0f - position[0]) / 65.0f;
                        } else {
                            BuggyVelo[0] = (245.0f - position[0]) / 65.0f;
                        }

                        PlayBuggyLoopSe(scene, 4);
                    }

                    break;
                case 2:
                    PlayBuggyLoopSe(scene, 4);

                    if (!(BuggyChara->GetNowFrameWait() < 0.83f)) {
                        BuggyStatusStep++;
                    }

                    position[0] += BuggyVelo[0];
                    break;
                case 3:
                    PlayBuggyLoopSe(scene, 4);
                    PlayBuggyLoopSe(scene, 2);

                    if (BuggyChara->CheckMotionEnd() != 0) {
                        BuggyStatusStep++;
                        BuggyChara->SetMotion("\x91\x96\x8ds", 4);
                        BuggyActCount = 0;

                        if (BuggySidePos == 1) {
                            BuggySidePos = 0;
                        } else {
                            BuggySidePos = 1;
                        }

                        BuggyVelo[0] = 0.0f;
                    }

                    break;
            }

            break;
        case 2:
            switch (BuggyStatusStep) {
                case 0:
                    sndSePlay(BuggySndID, 0x12, 0);

                    if (BuggyDamageMotion == 1) {
                        BuggyChara->SetMotion("\x8d\xb6\x91\xa4\x82\xc5\x83_\x83\x81\x81[\x83W", 6);
                    } else {
                        BuggyChara->SetMotion("\x89" "E\x91\xa4\x82\xc5\x83_\x83\x81\x81[\x83W", 6);
                    }

                    BuggyStatusStep++;

                    if (BuggyHP >= 2) {
                        PolVoice.Open(0x82EBC8);
                    }

                    if (BuggyHP == 1) {
                        PolVoice.Open(0x82EBD2);
                    }

                    if (BuggyHP == 0) {
                        PolVoice.Open(0x82EBDC);
                    }

                    PolVoice.Play();
                    break;
                case 1:
                    if (BuggyChara->CheckMotionEnd() != 0) {
                        BuggyStatus = 0;
                        BuggyActCount = 0x3C;
                        BuggyStatusStep = 0;
                    }

                    break;
            }

            break;
    }

    BuggyChara->GetEntryObjectPos(0, entry_position);

    if (!(entry_position[1] <= 40.0f)) {
        EffectMan__2->Pause(1, 0x40, SmokeEffHandle);
    } else {
        EffectMan__2->Pause(0, 0x40, SmokeEffHandle);
    }

    if (BuggyActCount <= 0) {
        BuggyStatusStep = 0;

        // Selects the next action in the buggy action cycle.
        static int test = 0;

        switch (test % 3) {
            case 0:
                BuggyStatus = 0;
                BuggyActCount = rand() % 60 + 60;
                break;
            case 1:
                BuggyStatus = 3;
                BuggyActCount = 99999;
                break;
            case 2:
                BuggyStatus = 1;
                BuggyActCount = 999991;
                break;
        }

        test++;
    }

    if (BuggyStatus != 1) {
        BuggyVelo[0] += 0.5f * (mgRnd() - 0.5f);
        BuggyVelo[2] += 0.5f * (mgRnd() - 0.5f);

        if (!(BuggyVelo[0] <= 10.0f)) {
            BuggyVelo[0] = 10.0f;
        }

        if (BuggyVelo[0] < -10.0f) {
            BuggyVelo[0] = -10.0f;
        }

        if (!(BuggyVelo[2] <= 10.0f)) {
            BuggyVelo[2] = 10.0f;
        }

        if (BuggyVelo[2] < -10.0f) {
            BuggyVelo[2] = -10.0f;
        }

        position[0] += BuggyVelo[0];
        position[2] += BuggyVelo[2];

        if (BuggySidePos == 1) {
            if (!(position[0] <= 345.0f)) {
                position[0] = 345.0f;
                BuggyVelo[0] = 0.0f;
            }

            if (position[0] < 145.0f) {
                position[0] = 145.0f;
                BuggyVelo[0] = 0.0f;
            }
        } else {
            if (!(position[0] <= -145.0f)) {
                position[0] = -145.0f;
                BuggyVelo[0] = 0.0f;
            }

            if (position[0] < -345.0f) {
                position[0] = -345.0f;
                BuggyVelo[0] = 0.0f;
            }
        }

        if (!(position[2] <= -1100.0f)) {
            position[2] = -1100.0f;
            BuggyVelo[2] = 0.0f;
        }

        if (position[2] < -1350.0f) {
            position[2] = -1350.0f;
            BuggyVelo[2] = 0.0f;
        }
    }

    BuggyChara->SetPosition(position);
    PolVoice.Step();
}

/**
 *
 * Places the bomb and its carrier in their initial state.
 *
 */
void InitBomb(CScene *scene) {
    BombStatus = 3;
    scene->SetActive(1, 67);
    BombChara->SetPosition(-0.8f, 136.5f, -320.0f);
    StarbullPos[0] = 0.0f;
    StarbullPos[1] = 113.0f;
    StarbullPos[2] = -300.0f;
    StarbullChara->SetPosition(StarbullPos);
    StarbullChara->SetRotation(0.0f, 3.1415927f, 0.0f);
    StarbullChara->SetMotion("\x97\xa7\x82\xbf", 0);
}

/**
 *
 * Reports whether the bomb is available to pick up.
 *
 */
int TakeBombCheck() {

    return (BombStatus != 3) ^ 1;
}

/**
 *
 * Marks the available bomb as carried by the player.
 *
 */
int TakeBomb() {
    if (TakeBombCheck() == 0) {
        return 0;
    }

    BombStatus = 4;
    return 1;
}

/**
 *
 * Detaches the bomb from its carrier and starts its thrown motion.
 *
 */
int ThrowBomb(float *velocity) {
    float matrix[4][4];
    BombCount = 0x32;
    *(u_long128 *) BombVelo = *(u_long128 *) velocity;
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

/**
 *
 * Stops a thrown bomb when it hits an object.
 *
 */
int BombBomb() {
    if (BombStatus == 6) {
        mgZeroVector(BombVelo);
        BombCount = 0;
        BombHitObj = 1;
        return 1;
    }

    return 0;
}

/**
 *
 * Reports whether the bomb is resting in its placed state.
 *
 */
int NowPutBomb() {
    return BombStatus == 3;
}

/**
 *
 * Advances the bomb through its carried, thrown, and explosion states.
 *
 */
void BombControl(CScene *scene) {
    // Frames since the bomb entered its reload state.
    static int reload_cnt;
    float     matrix[4][4];
    float     rest_position[4];
    float     position[4];
    float     previous[4];
    float     hit_point[4];
    float     effect_position[4];
    CCPoly    polys[0x200];
    mgVu0FBOX box;
    float     explode_position[4];

    CCharacter2 *player = scene->GetCharacter(scene->player_chara);

    if (player == NULL) {
        return;
    }

    int status = BombStatus;

    if (status == 1) {
        reload_cnt = 0;
        BombImpact = 0;
        StarbullChara->SetMotion("\x94\x9a\x92" "e\x82\xf0\x8e\xe6\x82\xe9", 6);
        BombChara->SetPosition(0.0f, 0.0f, 0.0f);
        BombChara->UpdatePosition();
        BombStatus = 2;
        scene->ResetActive(1, 0x43);
    } else if (status == 2) {
        float     frame_now = StarbullChara->GetNowFrame();
        float     frame_next = frame_now + StarbullChara->GetStep();
        mgCFrame *hand_frame = StarbullChara->CObjectFrame::frame;
        mgCFrame *bomb_frame = BombChara->CObjectFrame::frame;

        if (hand_frame != NULL) {
            hand_frame = hand_frame->SearchFrame("bomb");
        }

        if (frame_now <= 18.0f && !(frame_next <= 18.0f) && bomb_frame != NULL) {
            bomb_frame->SetReference(hand_frame);
        }

        if (!(frame_now < 18.0f)) {
            scene->SetActive(1, 0x43);
        }

        if (frame_now <= 30.9f && !(frame_next <= 30.9f)) {
            bomb_frame->GetLWMatrix(matrix);
            bomb_frame->DeleteReference();
            BombChara->SetPosition(matrix[3]);
            BombChara->SetRotation(0.0f, atan2f(matrix[2][0], matrix[2][2]), 0.0f);
            BombChara->UpdatePosition();
        }

        reload_cnt++;

        if (StarbullChara->CheckMotionEnd() != 0) {
            StarbullChara->SetMotion("\x97\xa7\x82\xbf", 0);
            BombStatus = 3;
        }
    } else if (status == 3) {
        BombChara->GetPosition(rest_position);
    } else if (status == 4) {
        mgCFrame *hand_frame = player->CObjectFrame::frame;

        if (hand_frame != NULL) {
            hand_frame = hand_frame->SearchFrame("nage");
        }

        mgCFrame *bomb_frame = BombChara->CObjectFrame::frame;
        BombChara->SetPosition(0.0f, 0.0f, 0.0f);
        bomb_frame->SetReference(hand_frame);
    } else if (status == 6) {
        BombChara->GetPosition(previous);
        BombChara->GetPosition(position);
        mgAddVector(position, BombVelo);

        if (BombCount <= 0) {
            BombChara->GetPosition(effect_position);
            BombEffHandle = EffectMan__2->CreateEffSpt(at_961__4, 0x43, 1);
            CCharacter2 *effect = EffectMan__2->GetCharacter(0x43, BombEffHandle);

            if (effect != NULL) {
                effect->SetScale(2.0f, 2.0f, 2.0f);
            }

            BombVelo[0] = 0.0f;
            BombVelo[1] = 0.0f;
            BombVelo[2] = -25.0f;
            BombStatus = 7;
            BombCount = 0x28;
            scene->ResetActive(1, 0x43);
            BombImpact = 8;
        } else {
            mgVectorMaxMin(box.max, box.min, position, previous);
            int poly_count = scene->GetColPoly(polys, box, 0x200);

            if (CheckHit(polys, poly_count, previous, position, hit_point, 0, 4) >= 0 &&
                !(hit_point[1] <= 100.0f)) {
                *(u_long128 *) position = *(u_long128 *) hit_point;
                BombBomb();
                TrainHP -= 0.1f;
            }

            if (!(position[0] <= 400.0f)) {
                position[0] = 400.0f;
            }

            if (position[0] < -400.0f) {
                position[0] = -400.0f;
            }

            if (position[1] < 0.0f) {
                BombVelo[1] *= -0.5f;
                position[1] = 0.0f;
                BombVelo[2] += 0.3f * (-50.0f - BombVelo[2]);
                sndSePlay(BuggySndID, 0xC, 0);
            }

            BombVelo[1] -= 0.6f;
        }

        BombChara->SetPosition(position);
        BombCount--;
    } else if (status == 7) {
        BombChara->GetPosition(explode_position);

        if (BombHitObj == 0) {
            mgAddVector(explode_position, BombVelo);
        }

        BombChara->SetPosition(explode_position);
        EffectMan__2->SetOrigin(explode_position, 0x43, BombEffHandle);
        BombCount--;
        BombImpact--;

        if (BombImpact < 0) {
            BombImpact = 0;
        }

        if (BombCount <= 0) {
            BombStatus = 1;
        }
    }
}

/**
 *
 * Checks bomb proximity to the buggy and handles a nearby hit.
 *
 */
void BombCheck(CScene *scene) {
    sceVu0FVECTOR bomb_position;
    sceVu0FVECTOR buggy_position;
    sceVu0FVECTOR next_position;
    sceVu0FVECTOR nearest;
    sceVu0FVECTOR upper_position;
    BuggyChara->GetPosition(buggy_position);
    *(u_long128 *) upper_position = *(u_long128 *) buggy_position;
    upper_position[1] += 40.0f;
    BombChara->GetPosition(bomb_position);
    sceVu0AddVector(next_position, bomb_position, BombVelo);
    float lower_distance = mgDistLinePoint(buggy_position, bomb_position, next_position, nearest);
    float upper_distance = mgDistLinePoint(upper_position, bomb_position, next_position, nearest);

    if (lower_distance < 40.0f || upper_distance < 30.0f) {
        BombBomb();
    }

    int impact = BombImpact;

    if (impact > 0 && impact < 8) {
        if (mgDistVector(bomb_position, buggy_position) < 150.0f) {
            int damage_motion = 0;

            if (bomb_position[0] < buggy_position[0]) {
                damage_motion = 1;
            }

            BuggyDamage(damage_motion);
            BombImpact = 0;
        }
    }
}

// Initialised data (.data)
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

// Uninitialised data (.bss)
mgCMemory EffectBuff;
sgCPlayVoice PolVoice __attribute__((aligned(16)));
