#include "common.h"
#include "mg_drawprim.hpp"
#include "automap.hpp"
#include "effscript.hpp"
#include "maintex.hpp"
#include "monster.hpp"
#include "font.hpp"
#include "mainloop.hpp"
#include "cameracontrol.hpp"
#include "event_func.hpp"
#include "event.hpp"
#include "menucommon.hpp"
#include "gameutil.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "quest.hpp"
#include "water.hpp"
#include "mapload.hpp"
#include "mglib.hpp"
#include "editriver.hpp"
#include <cmath>
#include <cstring>
#include <cstdlib>
#include <cstdio>
#include "savedatadungeon.hpp"
#include "sceneevent.hpp"
#include "snd_seseq.hpp"
#include "mg_math.hpp"
#include "dng_status.hpp"
#include "dng_debug.hpp"
#include "dng_main.hpp"
#include "character.hpp"
#include "collision.hpp"
#include "colprim.hpp"
#include "dng_effect.hpp"
#include "map.hpp"
#include "mg_camera.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_texture.hpp"
#include "prespr.hpp"
#include "dng_object.hpp"

union CopyVector { float f[4]; u_long128 word; };
extern "C" int fptosi(float value);
extern "C" void *__ct__11mgCDrawPrimFv(void *);
extern "C" void *__ct__12mgCFrameAttrFv(void *);
extern float at_1112[4];
extern float at_1240__3[4];
extern char at_1291__3[];
extern float anim_1410;
extern s8 init_1411;

#include <libvu0.h>
#include "dng_event.hpp"
#include "gamedata.hpp"
#include "mg_memory.hpp"
#include "scene.hpp"
#include "userdata.hpp"

#ifdef NONMATCHING
/**
 * Japanese names of monster badge families.
 */
static char *mons_attr_tbl[12] = {
    "",
    "\203P\203\202\203m",
    "\203J\203\211\203N\203\212",
    "\220\205\220\266\216\355",
    "\220A\225\250",
    "\226\202\226@\220\266\225\250",
    "\226\202\220l",
    "\227\263\221\260",
    "\220\270\227\354",
    "\225s\216\200",
    "\203g\203\211\203\223\203v",
    NULL,
};

/**
 * English names of monster badge families.
 */
static char *mons_attr_tbl2[12] = {
    "",
    "Beast",
    "Windup",
    "Aquatic",
    "Flora",
    "Magical Creature",
    "Darkling",
    "Reptile Family",
    "Spirit",
    "Undead",
    "Card",
    NULL,
};

/**
 * French names of monster badge families.
 */
static char *mons_attr_tbl3[12] = {
    "",
    "Beast",
    "Animal",
    "Robotis[UNI00e9]",
    "Aquatique",
    "V[UNI00e9]g[UNI00e9]tal",
    "Cr[UNI00e9]ature magique",
    "Cr[UNI00e9]ature obscure",
    "Reptile",
    "Esprit",
    "Mort-vivant",
    "Carte",
};

/**
 * German names of monster badge families.
 */
static char *mons_attr_tbl4[12] = {
    "",
    "Tier",
    "Aufzieh-Figur",
    "Wassertier",
    "Flora",
    "Zauberwesen",
    "D[UNI00fc]sterling",
    "Reptil",
    "Geist",
    "Untoter",
    "Karte",
    NULL,
};

/**
 * Italian names of monster badge families.
 */
static char *mons_attr_tbl5[12] = {
    "",
    "Bestia",
    "Robot",
    "Acquatico",
    "Flora",
    "Creatura magica",
    "Oscuro",
    "Rettile",
    "Spirito",
    "Nonmorto",
    "Carta",
    NULL,
};

/**
 * Spanish names of monster badge families.
 */
static char *mons_attr_tbl6[12] = {
    "",
    "Bestia",
    "Broma",
    "Acu[UNI00e1]tico",
    "Flora",
    "Criatura m[UNI00e1]gica",
    "Misterioso",
    "Familia de reptiles",
    "Esp[UNI00ed]ritu",
    "Muerto Viviente",
    "Carta",
    NULL,
};

/**
 * Messages displayed when a monster badge is already owned.
 */
static char *dung_progtxt_badge_already[8] = {
    "\203\202\203\223\203X\203^\201[\202\326\202\361\202\260\203o\203b\203W\201i%s\201j\202\360\n\214\251\202\302\202\257\202\275\201A\202\265\202\251\202\265\202\267\202\305\202\311\223\374\216\350\202\265\202\304\202\242\202\351",
    "You got a Monster Transformation\201i%s\201jBadge,\nbut you already have it.",
    "Tu as re[UNI00e7]u un [UNI00e9]cusson de monstromorphisme (%s),\nmais tu l'as d[UNI00e9]j[UNI00e0].",
    "%s-Monsterwandel-Marke erhalten ,\naber du hast schon einen.",
    "Hai ottenuto uno Stemma Mutazione in (%s) Mostro,\nma ce l\201fhai gi[UNI00e0].",
    "Has conseguido una Insignia de monstruomorfosis(%s),\npero ya la ten[UNI00ed]as.",
    "You got a Monster Transformation (%s) Badge,\nbut you already have it.",
    NULL,
};

/**
 * Messages displayed when a monster badge is acquired.
 */
static char *dung_progtxt_badge_get[8] = {
    "\203\202\203\223\203X\203^\201[\202\326\202\361\202\260\203o\203b\203W\201i%s\201j\202\360\n\216\350\202\311\223\374\202\352\202\275",
    "You got a Monster Transformation\201i%s\201jBadge.",
    "Tu as re[UNI00e7]u un [UNI00e9]cusson \nde monstromorphisme (%s).",
    "Du hast eine neue \n%s-Monsterwandel-Marke.",
    "Hai ottenuto uno Stemma Mutazione\nin (%s) Mostro.",
    "Has conseguido una Insignia de monstruomorfosis (%s).",
    "You got a Monster Transformation (%s)Badge.",
    NULL,
};

/**
 * Messages displayed when the gate key is acquired.
 */
static char *dung_progtxt_gkey_get[8] = {
    "\203Q\201[\203g\203L\201[\201u%s\201v\202\360\216\350\202\311\223\374\202\352\202\275",
    "You got the '%s'.",
    "Tu as trouv[UNI00e9] '%s'.",
    "'%s' erhalten.",
    "Hai trovato '%s'.",
    "Has conseguido '%s'.",
    "You got the '%s'.",
    NULL,
};

/**
 * Messages displayed when a stolen item is recovered.
 */
static char *dung_progtxt_steal[8] = {
    "\223G\202\251\202\347\201u%s\201v\202\360\223\220\202\335\216\346\202\301\202\275",
    "Stolen '%s' from the enemy.",
    "A d[UNI00e9]rob[UNI00e9] '%s' [UNI00e0] l'ennemi.",
    "'%s' erhalten.",
    "Hai rubato '%s' al nemico.",
    "Has robado '%s' al enemigo.",
    "Stolen '%s' from the enemy.",
    NULL,
};

/**
 * Singular and plural messages displayed when an item cannot fit.
 */
static char *dung_progtxt_getitem_overnum[8][2] = {
    {"\201w%s\201x\202\252\223\374\202\301\202\304\202\242\202\351\201B\n\202\265\202\251\202\265\202\261\202\352\210\310\217\343\201A\202\261\202\314\203A\203C\203e\203\200\202\360\216\235\202\302\202\261\202\306\202\252\202\305\202\253\202\310\202\242\201B", "\201w%s\201x\202\252%d\214\302\201A\223\374\202\301\202\304\202\242\202\351\201B\n\202\265\202\251\202\265\202\261\202\352\210\310\217\343\201A\202\261\202\314\203A\203C\203e\203\200\202\360\216\235\202\302\202\261\202\306\202\252\202\305\202\253\202\310\202\242\201B"},
    {"%s inside. \n But you can't carry any more items!", "%d %s inside. \n But you can't carry any more items!"},
    {"Contient %s. \n Mais tu ne peux rien porter d'autre !", "Contient %d %s. \n Mais tu ne peux rien porter d'autre !"},
    {"%s enthalten. \nAber du kannst nicht mehr davon tragen!", "%d %s enthalten. \nAber du kannst nicht mehr davon tragen!"},
    {"%s caricato. \nMa non puoi portare con te altri oggetti!", "%d %s caricato. \nMa non puoi portare con te altri oggetti!"},
    {"Hay %s. \n [UNI00a1]Pero no puedes llevar m[UNI00e1]s objetos!", "Hay %d %s. \n [UNI00a1]Pero no puedes llevar m[UNI00e1]s objetos!"},
    {"%s inside. \n But you can't carry any more items!", "%d %s inside. \n But you can't carry any more items!"},
    {NULL, NULL},
};

/**
 * Singular and plural messages displayed when an item is acquired.
 */
static char *dung_progtxt_getitem[8][2] = {
    {"\201w%s\201x\202\360%d\214\302\201A\216\350\202\311\223\374\202\352\202\275\201B", "\201w%s\201x\202\360%d\214\302\201A\216\350\202\311\223\374\202\352\202\275\201B"},
    {"You found %s.", "You found %d %s."},
    {"Tu as trouv[UNI00e9] %s.", "Tu as trouv[UNI00e9] %d %s."},
    {"%s gefunden.", "%d %s gefunden."},
    {"Hai trovato %s.", "Hai trovato %d %s."},
    {"Has encontrado %s.", "Has encontrado %d %s."},
    {"You found %s.", "You found %d %s."},
    {NULL, NULL},
};

/**
 * Monster badge family names selected by the current language.
 */
static char **mons_attr_list[8] = {
    mons_attr_tbl,
    mons_attr_tbl2,
    mons_attr_tbl3,
    mons_attr_tbl4,
    mons_attr_tbl5,
    mons_attr_tbl6,
    mons_attr_tbl6,
    mons_attr_tbl6,
};
#endif


// Code (.text)
void CRocketLauncher::SetPos(float *pos, float *muzzle_vec, float *direction_vec) {
    int i;
    Initialize();
    sceVu0CopyVector(start_pos, pos);
    sceVu0CopyVector(this->pos, pos);
    sceVu0CopyVector(target_pos, muzzle_vec);
    sceVu0CopyVector(dir, direction_vec);
    speed = 15.0f;
    state = SHOT_STATE_FIRED;
    trail_timer = 0;
    for (i = 0; i < 16; i++) {
        sceVu0CopyVector(trail[i], this->pos);
    }
    trail_len = 0;
    homing_delay = 15;
    homing_time = 60;
    life = 150;
    draw_flags = 3;
}
void CRocketLauncher::Step() {
    sceVu0FVECTOR    movement;
    sceVu0FVECTOR    old_pos;
    sceVu0FVECTOR    to_target;
    CCPoly          polys[128];
    mgVu0FBOX       box;
    sceVu0FVECTOR    hit_pos;
    sceVu0FVECTOR    effect_pos;
    CColPrim       *prim;
    CCharacter2    *target;
    mgCCamera      *camera;
    CHitEffectImage *hit;
    int             count;

    if (state == SHOT_STATE_FREE) {
        return;
    }
    if (state == SHOT_STATE_FIRED) {
        state = SHOT_STATE_FLYING;
    }
    if (state == SHOT_STATE_FLYING) {
        prim = ColPrimMan.GetID2Prim(col_prim_id);
        if (homing_delay > 0) {
            homing_delay--;
        }
        if (homing_time > 0) {
            homing_time--;
        }
        life--;
        if (homing_delay <= 0 && homing_time > 0) {
            if (target_chara != -1) {
                target = DngMainScene->GetCharacter(target_chara);
                if (target != NULL) {
                    target->GetEntryObjectPos(0, 0, target_pos);
                }
            }
            sceVu0SubVector(to_target, target_pos, pos);
            sceVu0Normalize(to_target, to_target);
            mgVectorInterpolate(dir, dir, to_target, 0.05235988f, 0);
        }
        sceVu0CopyVector(old_pos, pos);
        sceVu0ScaleVector(movement, dir, speed);
        sceVu0AddVector(pos, pos, movement);
        if (prim != NULL) {
            prim->SetCoord(pos, 5.0f);
        }
        box.max[3] = 1.0f;
        box.min[3] = 1.0f;
        box.max[0] = 20.0f + (pos[0] + speed);
        box.min[0] = (pos[0] - speed) - 20.0f;
        box.max[1] = 20.0f + (pos[1] + speed);
        box.min[1] = (pos[1] - speed) - 20.0f;
        box.max[2] = 20.0f + (pos[2] + speed);
        box.min[2] = (pos[2] - speed) - 20.0f;
        count = DngMainMap->GetColPoly(polys, box, 128);
        if (CheckHit(polys, count, pos, old_pos, hit_pos, 1, 4) >= 0) {
            state = SHOT_STATE_BURST;
            draw_flags &= ~SHOT_DRAW_MODEL;
        }
        if (prim != NULL && prim->hit_num > 0) {
            state = SHOT_STATE_BURST;
            draw_flags &= ~SHOT_DRAW_MODEL;
        }
        if (life <= 0) {
            state = SHOT_STATE_BURST;
            draw_flags &= ~SHOT_DRAW_MODEL;
        }
        if (state == SHOT_STATE_BURST) {
            camera = DngMainScene->GetCamera(DngMainScene->active_camera);
            if (camera != NULL) {
                camera->GetPos(effect_pos);
                sceVu0SubVector(effect_pos, effect_pos, pos);
                sceVu0Normalize(effect_pos, effect_pos);
                sceVu0ScaleVector(effect_pos, effect_pos, 20.0f);
                sceVu0AddVector(effect_pos, pos, effect_pos);
            }
            FxScriptMan->CreateEffSpt("\x82\x78\x83\x4f\x83\x8c\x82\x67", 0, -1);
            FxScriptMan->SetScriptVect1(effect_pos, -1, -1);
            sndSePlay(DngMainScene->se_battle_id, 31, 0);
            if (life > 0) {
                sceVu0FVECTOR hit_dir = { 0.0f, 1.0f, 0.0f, 1.0f };

                if (BattleFX.hit == NULL) {
                    hit = NULL;
                } else {
                    hit = BattleFX.hit + BattleFX.hit_next;
                    BattleFX.hit_next++;
                    if (BattleFX.hit_next >= BattleFX.hit_num) {
                        BattleFX.hit_next = 0;
                    }
                }
                if (hit != NULL) {
                    hit->SethitEffect(effect_pos, hit_dir, 50.0f, 30.0f, 0.0f, 0.1f, 30, 32);
                    hit->kind = HIT_EFFECT_SPARK_SHORT;
                }
            }
            if (prim != NULL) {
                prim->Delete(-1);
            }
        }
        trail_timer++;
        if (trail_timer >= 3) {
            sceVu0CopyVector(trail[trail_index], pos);
            trail_index++;
            if (trail_index >= 16) {
                trail_index = 0;
            }
            trail_timer = 0;
            trail_len += 5;
        }
    }
    if (state == SHOT_STATE_BURST) {
        trail_len--;
        if (trail_len < 3) {
            state = SHOT_STATE_FREE;
        }
    }
}
void CRocketLauncher::Draw(void) {
    union { CPreSprite sprite; };
    float smooth[128][4];
    int corner_a[4];
    int corner_b[4];
    float look_matrix[4][4];
    int points;
    int index;
    float fade;
    float size;
    if (state == 0) {
        return;
    }

    __ct__11mgCDrawPrimFv(&sprite);
    if (draw_flags & 2) {
        points = CreatSmoothPass(smooth, trail, 0x10, 6, trail_index, 0x10);
        if (points < trail_len) {
            trail_len = points;
        }
        sprite.Initialize(0, 0);
        sprite.Preset2D();
        sprite.AlphaBlendEnable(1);
        sprite.AlphaTestEnable(1);
        sprite.AlphaTest(1, 0);
        sprite.DepthTestEnable(1);
        sprite.ZMask(-1);
        sprite.Bilinear(1);
        sprite.TextureMapEnable(1);
        sprite.Coord(1);
        sprite.Begin(6);
        sprite.Texture(trail_texture);
        sprite.AlphaTestEnable(1);
        sprite.SetAlphaBlend(1);
        sprite.Color(0x80, 0x80, 0x80, 0x80);
        fade = 1.0f;
        size = 6.0f;
        index = points - 1;
        while (index >= points - trail_len + 1) {
            smooth[index][3] = 1.0f;
            if (mgTransWorldPrim3DSprite(corner_a, corner_b, smooth[index], size, size, 0) != 0) {
                int alpha = fptosi(128.0f * fade);
                sprite.Color(alpha, alpha, alpha, alpha);
                sprite.TextureCrd(0, 0);
                sprite.Vertex4(corner_a);
                sprite.TextureCrd(0x3F, 0x3F);
                sprite.Vertex4(corner_b);
            }
            index--;
            fade -= 1.0f / (float)trail_len;
            size += 12.0f / (float)trail_len;
        }
        sprite.End();
    }
    if (draw_flags & 1) {
        ((mgCFrame *)model)->SetPosition(pos);
        mgLookAtMatrixZ(look_matrix, dir);
        model->SetTransMatrix(look_matrix);
        mgDrawDirect(model);
    }
}
void CRocketLauncher::Initialize(void) {
    target_chara = -1;
    trail_len = 0;
    trail_index = 0;
    state = SHOT_STATE_FREE;
    col_prim_id = -1;
    draw_flags = 0;
}
CRocketLauncher *CRocketLauncherMan::Get(void) {
    for (int i = 0; i < 24; i++) {
        if (rocket[i].state == SHOT_STATE_FREE) {
            return &rocket[i];
        }
    }
    return 0;
}
void CRocketLauncherMan::Draw(void) {
    mgCTextureManager *manager = &mgTexManager;
    int i;
    int offset = 0;
    for (i = 0; i < 24; i++) {
        CRocketLauncher *entry = (CRocketLauncher *)((u8 *)this + offset);
        (manager)->ReloadTexture(entry->tex_block, (sceVif1Packet *)NULL);
        entry->Draw();
        offset += 0x190;
    }
}
void CRocketLauncherMan::Step(void) {
    for (int i = 0; i < 24; i++) {
        rocket[i].Step();
    }
}
void CRocketLauncherMan::Clear(void) {
    for (int i = 0; i < 24; i++) {
        rocket[i].Initialize();
    }
}
void CRocketLauncherMan::Initialize(mgCFrame *frame, int texture_id, mgCTexture *texture) {
    int i;
    int offset = 0;
    for (i = 0; i < 24; i++) {
        CRocketLauncher *entry = (CRocketLauncher *)((u8 *)this + offset);
        entry->Initialize();
        entry->model = frame;
        entry->tex_block = texture_id;
        offset += 0x190;
        entry->trail_texture = texture;
    }
}
void CMachineGun::Set(float *position, float *direction) {
    int slot = -1;
    int tries = 0;
    do {
        index++;
        if (index >= 16) {
            index = 0;
        }
        int candidate = index;
        if (active[candidate] == 0) {
            slot = candidate;
            break;
        }
        tries++;
    } while (tries < 16);
    if (slot >= 0) {
        sceVu0CopyVector(start_pos[slot], position);
        sceVu0Normalize(direction, direction);
        sceVu0ScaleVectorXYZ(direction, direction, 40.0f);
        sceVu0CopyVector(velocity[slot], direction);
        sceVu0CopyVector(pos[slot], position);
        active[slot] = 1;
        life[slot] = 90;
    }
}
void CMachineGun::Step(void) {
    int i;
    for (i = 0; i < 16; i++) {
        s16 state = active[i];
        if (state != 0 && state == 1) {
            CColPrim *col_prim = ColPrimMan.GetID2Prim(col_prim_id[i]);
            float previous_pos[4];
            CCPoly polys[128];
            mgVu0FBOX box;
            float hit[4];

            float *slot = (float *)((u8 *)this + i * 16);
            float *shot_pos = (slot + 0x80);
            sceVu0CopyVector(previous_pos, shot_pos);
            sceVu0AddVector(shot_pos, shot_pos, (slot + 0x40));
            if (col_prim != NULL) {
                col_prim->SetCoord(previous_pos, shot_pos, 5.0f);
            }
            box.max[3] = 1.0f;
            box.min[3] = 1.0f;
            box.max[0] = 20.0f + (40.0f + (slot + 0x80)[0]);
            box.min[0] = ((slot + 0x80)[0] - 40.0f) - 20.0f;
            box.max[1] = 20.0f + (40.0f + (slot + 0x80)[1]);
            box.min[1] = ((slot + 0x80)[1] - 40.0f) - 20.0f;
            box.max[2] = 20.0f + (40.0f + (slot + 0x80)[2]);
            box.min[2] = ((slot + 0x80)[2] - 40.0f) - 20.0f;
            int count = ((CMap *)DngMainMap)->GetColPoly(polys, box, 128);
            if (CheckHit(polys, count, shot_pos, previous_pos, hit, 1, 4) >= 0) {
                active[i] = 0;
                if (col_prim != NULL) {
                    col_prim->Delete(-1);
                }
                CopyVector dir;
                dir = *(CopyVector *)at_1112;
                CHitEffectImage *image;
                if (BattleFX.hit == NULL) {
                    image = NULL;
                } else {
                    CHitEffectImage *slot = BattleFX.hit + BattleFX.hit_next;
                    BattleFX.hit_next++;
                    if (BattleFX.hit_next >= BattleFX.hit_num) {
                        BattleFX.hit_next = 0;
                    }
                    image = slot;
                }
                if (image != NULL) {
                    float power = 0.0f;
                    float spread = 50.0f;
                    float speed = 30.0f;
                    float gravity = 0.1f;
                    image->SethitEffect(previous_pos, dir.f, spread, speed, power, gravity, 16, 8);
                    image->kind = 1;
                }
            } else if (col_prim != NULL && col_prim->hit_num > 0) {
                active[i] = 0;
                col_prim->Delete(-1);
            } else {
                life[i]--;
                if (life[i] <= 0) {
                    active[i] = 0;
                    if (col_prim != NULL) {
                        col_prim->Delete(-1);
                    }
                }
            }
        }
    }
}
void CLaserGun::SetPos(float *start, float *target, float *direction_vec) {
    int i;
    Initialize();
    sceVu0CopyVector(start_pos, start);
    sceVu0CopyVector(pos, start);
    sceVu0CopyVector(target_pos, target);
    sceVu0CopyVector(dir, direction_vec);
    *(int *)&speed = 0x41A00000;
    *(int *)&speed_add = 0;
    *(int *)&speed_max = 0x41A00000;
    state = SHOT_STATE_FIRED;
    trail_timer = 0;
    for (i = 0; i < 8; i++) {
        sceVu0CopyVector(trail[i], pos);
    }
    trail_len = 0;
    homing_delay = 15;
    homing_time = 60;
    life = 120;
    *(int *)&color[0] = 0;
    *(int *)&color[1] = 0x43000000;
    *(int *)&color[2] = 0x43000000;
    *(int *)&color[3] = 0x43000000;
    *(int *)&scale = 0x3F800000;
    *(int *)&scale_add = 0;
    *(int *)&scale_max = 0x3F800000;
    draw_flags = 3;
    visual_code = 0;
}
void CLaserGun::SetVisualCode(int code) {
    visual_code = (s16) code;
    if (code == 0) {
        scale = 0.1f;
        scale_add = 0.1f;
        scale_max = 0.5f;
        color[0] = 64.0f;
        color[1] = 128.0f;
        color[2] = 64.0f;
    }
    if (code == 1) {
        scale = 0.2f;
        scale_add = 0.4f;
        scale_max = 0.8f;
        speed = 30.0f;
        color[0] = 64.0f;
        color[1] = 64.0f;
        color[2] = 128.0f;
    }
    if (code == 2) {
        scale = 0.2f;
        scale_add = 0.4f;
        scale_max = 1.4f;
        speed = 15.0f;
        speed_add = 5.0f;
        speed_max = 40.0f;
        color[0] = 128.0f;
        color[1] = 32.0f;
        color[2] = 128.0f;
    }
    if (code == 3) {
        scale = 0.2f;
        scale_add = 0.2f;
        scale_max = 0.6f;
        speed = 0.0f;
        speed_add = 2.0f;
        speed_max = 35.0f;
        homing_delay = 0;
        homing_time = 99999;
        life = 75;
        color[0] = 0.0f;
        color[1] = 128.0f;
        color[2] = 128.0f;
    }
    if (code == 4) {
        scale = 0.4f;
        scale_add = 0.4f;
        scale_max = 1.8f;
        speed = 10.0f;
        speed_add = 5.0f;
        speed_max = 30.0f;
        homing_delay = 0;
        homing_time = 5;
        life = 75;
        color[0] = 128.0f;
        color[1] = 64.0f;
        color[2] = 0.0f;
    }
}
void CLaserGun::Step(void) {

    CLaserGun *gun = this;
    float gravity = 0.1f;
    float speed2 = 30.0f;
    float spread = 50.0f;
    float power = 0.0f;
    float move[4];
    float previous[4];
    float to_target[4];
    CCPoly polys[128];
    mgVu0FBOX box;
    float hit[4];
    float flash_pos[4];
    float flash_color[4];
    float flash_pos2[4];
    float flash_color2[4];
    float hit_effect_dir[4];
    if (state != 0) {
        if (state == 1) {
            state = SHOT_STATE_FLYING;
        }
        if (state == 2) {
            CColPrim *col_prim = ColPrimMan.GetID2Prim(col_prim_id);
            if (homing_delay > 0) {
                homing_delay--;
            }
            if (homing_time > 0) {
                homing_time--;
            }
            life--;
            if (homing_delay <= 0) {
                if (homing_time > 0) {
                    if (target_chara != -1) {
                        CCharacter2 *chara = DngMainScene->GetCharacter(target_chara);
                        if (chara != NULL) {
                            chara->GetEntryObjectPos(0, 0, target_pos);
                        }
                    }
                    sceVu0SubVector(to_target, target_pos, pos);
                    sceVu0Normalize(to_target, to_target);
                    mgVectorInterpolate(dir, dir, to_target, 0.05235988f, 0);
                }
            }
            sceVu0CopyVector(previous, pos);
            sceVu0ScaleVector(move, dir, gun->speed);
            sceVu0AddVector(pos, pos, move);
            if (col_prim != NULL) {
                col_prim->SetCoord(pos, 5.0f);
            }
            box.max[3] = 1.0f;
            box.min[3] = 1.0f;
            box.max[0] = 20.0f + (pos[0] + gun->speed);
            box.min[0] = (pos[0] - gun->speed) - 20.0f;
            box.max[1] = 20.0f + (pos[1] + gun->speed);
            box.min[1] = (pos[1] - gun->speed) - 20.0f;
            box.max[2] = 20.0f + (pos[2] + gun->speed);
            box.min[2] = (pos[2] - gun->speed) - 20.0f;
            int count = ((CMap *)DngMainMap)->GetColPoly(polys, box, 128);
            if (CheckHit(polys, count, pos, previous, hit, 1, 4) >= 0) {
                state = SHOT_STATE_BURST;
                draw_flags &= ~1;
                mgCCamera *camera = DngMainScene->GetCamera(DngMainScene->active_camera);
                if (camera != NULL) {
                    camera->GetPos(flash_pos);
                    sceVu0SubVector(flash_pos, flash_pos, pos);
                    sceVu0Normalize(flash_pos, flash_pos);
                    sceVu0ScaleVector(flash_pos, flash_pos, 20.0f);
                    sceVu0AddVector(flash_pos, pos, flash_pos);
                }
                sceVu0CopyVector(flash_color, &gun->color[0]);
                flash_color[3] *= 1.2f;
                flash_color[3] *= 1.2f;
                flash_color[3] *= 1.2f;
                flash_color[3] = 240.0f;
                FxScriptMan->CreateEffSpt(at_1291__3, 0, -1);
                FxScriptMan->SetScriptVect1(flash_pos, -1, -1);
                FxScriptMan->SetScriptVect2(&gun->color[0], -1, -1);
                FxScriptMan->SetValue(0, 1.8f, -1, -1);
                sndSePlay(DngMainScene->se_battle_id, 0x20, 0);
            }
            if (col_prim != NULL && col_prim->hit_num > 0) {
                state = SHOT_STATE_BURST;
                draw_flags &= ~1;
                mgCCamera *camera = DngMainScene->GetCamera(DngMainScene->active_camera);
                if (camera != NULL) {
                    camera->GetPos(flash_pos2);
                    sceVu0SubVector(flash_pos2, flash_pos2, pos);
                    sceVu0Normalize(flash_pos2, flash_pos2);
                    sceVu0ScaleVector(flash_pos2, flash_pos2, 20.0f);
                    sceVu0AddVector(flash_pos2, pos, flash_pos2);
                }
                sceVu0CopyVector(flash_color2, &gun->color[0]);
                flash_color2[3] *= 1.4f;
                flash_color2[3] *= 1.4f;
                flash_color2[3] *= 1.4f;
                flash_color2[3] = 240.0f;
                FxScriptMan->CreateEffSpt(at_1291__3, 0, -1);
                FxScriptMan->SetScriptVect1(flash_pos2, -1, -1);
                FxScriptMan->SetScriptVect2(&gun->color[0], -1, -1);
                FxScriptMan->SetValue(0, 1.8f, -1, -1);
                sndSePlay(DngMainScene->se_battle_id, 0x20, 0);
            }
            gun->speed += gun->speed_add;
            if (!(gun->speed <= gun->speed_max)) {
                gun->speed = gun->speed_max;
            }
            gun->scale += gun->scale_add;
            if (!(gun->scale <= gun->scale_max)) {
                gun->scale = gun->scale_max;
            }
            if (life <= 0) {
                state = SHOT_STATE_BURST;
                draw_flags &= ~1;
            }
            if (state == 3) {
                if (life > 0) {
                    *(CopyVector *)hit_effect_dir = *(CopyVector *)at_1240__3;
                    CHitEffectImage *image;
                    if (BattleFX.hit == NULL) {
                        image = NULL;
                    } else {
                        image = BattleFX.hit + BattleFX.hit_next;
                        BattleFX.hit_next++;
                        if (BattleFX.hit_next >= BattleFX.hit_num) {
                            BattleFX.hit_next = 0;
                        }
                    }
                    if (image != NULL) {
                        image->SethitEffect(pos, hit_effect_dir, spread, speed2, power, gravity,
                                            30, 32);
                        image->kind = 1;
                    }
                }
                if (col_prim != NULL) {
                    col_prim->Delete(-1);
                }
            }
            trail_timer += 1;
            if (trail_timer >= 3) {
                sceVu0CopyVector(trail[trail_index], pos);
                trail_index += 1;
                if (trail_index >= 8) {
                    trail_index = 0;
                }
                trail_timer = 0;
                trail_len += 5;
            }
        }
        if (state == 3) {
            trail_len -= 1;
            if (trail_len < 3) {
                state = SHOT_STATE_FREE;
            }
        }
    }
}
void CLaserGun::Draw(void) {
    float size;
    int index;
    float fade;
    float glow;
    int count;
    float t;
    union { CPreSprite sprite; };
    float smooth[256][4];
    int corner_a[4];
    int corner_b[4];
    float previous[4];
    float segment[4];
    float step[4];
    union { mgCFrameAttr attr; };
    float matrix[4][4];
    if (state != 0) {
        __ct__11mgCDrawPrimFv(&sprite);

        (mgTexManager).ReloadTexture(tex_block, (sceVif1Packet *)NULL);
        if (draw_flags & 2) {
            count = CreatSmoothPass(smooth, trail, 8, 6, trail_index, 8);
            if (count < trail_len) {
                trail_len = count;
            }
            sprite.Initialize(0, 0);
            sprite.Preset2D();
            sprite.AlphaBlendEnable(1);
            sprite.AlphaTestEnable(1);
            sprite.AlphaTest(1, 0);
            sprite.DepthTestEnable(1);
            sprite.ZMask(-1);
            sprite.Bilinear(1);
            sprite.TextureMapEnable(1);
            sprite.Coord(1);
            sprite.Begin(6);
            sprite.Texture(trail_texture);
            sprite.AlphaTestEnable(1);
            sprite.SetAlphaBlend(2);
            sprite.Color(0x80, 0x80, 0x80, 0x80);
            fade = 1.0f;
            size = 6.0f * scale;
            index = count - 1;
            for (; index >= count - trail_len + 1; index--) {
                smooth[index][3] = 1.0f;
                if (mgTransWorldPrim3DSprite(corner_a, corner_b, smooth[index], size, size, 0) != 0) {
                    int b;
                    int g;
                    int r;
                    r = fptosi(96.0f + color[0]);
                    g = fptosi(96.0f + color[1]);
                    b = fptosi(96.0f + color[2]);
                    sprite.Color(r, g, b, fptosi(128.0f * fade));
                    sprite.TextureCrd(0, 0);
                    sprite.Vertex4(corner_a);
                    sprite.TextureCrd(0x3F, 0x3F);
                    sprite.Vertex4(corner_b);
                }
                if (index != count - 1) {
                    t = 0.1f;
                    int b;
                    int g;
                    int r;
                    int i;
                    sceVu0SubVector(step, smooth[index], previous);
                    for (i = 0; i < 9; i++) {
                        sceVu0ScaleVector(segment, step, t);
                        sceVu0AddVector(segment, segment, previous);
                        if (mgTransWorldPrim3DSprite(corner_a, corner_b, segment, size, size, 0) !=
                            0) {
                            r = fptosi(64.0f + color[0]);
                            g = fptosi(64.0f + color[1]);
                            b = fptosi(64.0f + color[2]);
                            sprite.Color(r, g, b, fptosi(128.0f * fade));
                            sprite.TextureCrd(0, 0);
                            sprite.Vertex4(corner_a);
                            sprite.TextureCrd(0x3F, 0x3F);
                            sprite.Vertex4(corner_b);
                        }
                        t += 0.1f;
                    }
                }
                sceVu0CopyVector(previous, smooth[index]);
                glow = 4.0f * size;
                if (mgTransWorldPrim3DSprite(corner_a, corner_b, smooth[index], glow, glow, 0) != 0) {
                    int b;
                    int g;
                    int r;
                    r = fptosi(color[0]);
                    g = fptosi(color[1]);
                    b = fptosi(color[2]);
                    sprite.Color(r, g, b, fptosi(32.0f * fade));
                    sprite.TextureCrd(0, 0);
                    sprite.Vertex4(corner_a);
                    sprite.TextureCrd(0x3F, 0x3F);
                    sprite.Vertex4(corner_b);
                }
                fade -= 1.0f / (float)trail_len;
            }
            sprite.End();
        }
        if (draw_flags & 1) {

            __ct__12mgCFrameAttrFv(&attr);
            attr.no_light = 1;
            attr.color[0] = color[0];
            attr.color[1] = color[1];
            attr.color[2] = color[2];
            attr.color[3] = 128.0f;
            model->SetAttrParam(attr, 1, 0x10000);
            float model_scale = scale;
            ((mgCObject *)model)->SetScale(model_scale, model_scale, model_scale);
            model->SetPosition(pos);
            mgLookAtMatrixZ(matrix, dir);
            model->SetTransMatrix(matrix);
            mgDrawDirect(model);
        }
    }
}
void CLaserGun::Initialize(void) {
    target_chara = -1;
    trail_len = 0;
    trail_index = 0;
    state = SHOT_STATE_FREE;
    col_prim_id = -1;
    draw_flags = 0;
}
CLaserGun *CLaserGunMan::Get(void) {
    for (int i = 0; i < 16; i++) {
        if (laser[i].state == 0) {
            return &laser[i];
        }
    }
    return 0;
}
void CLaserGunMan::Draw(void) {
    mgCTextureManager *manager = &mgTexManager;
    int i;
    int offset = 0;
    for (i = 0; i < 16; i++) {
        CLaserGun *entry = (CLaserGun *)((u8 *)this + offset);
        (manager)->ReloadTexture(entry->tex_block, (sceVif1Packet *)NULL);
        entry->Draw();
        offset += 0x130;
    }
}
void CLaserGunMan::Step(void) {
    for (int i = 0; i < 16; i++) {
        laser[i].Step();
    }
}
void CLaserGunMan::Clear(void) {
    for (int i = 0; i < 16; i++) {
        laser[i].Initialize();
    }
}
void CLaserGunMan::Initialize(mgCFrame *frame, int texture_id, mgCTexture *texture) {
    int i;
    int offset = 0;
    for (i = 0; i < 16; i++) {
        CLaserGun *entry = (CLaserGun *)((u8 *)this + offset);
        entry->Initialize();
        entry->model = frame;
        entry->tex_block = texture_id;
        offset += 0x130;
        entry->trail_texture = texture;
    }
}
void CPullItem::Draw(mgCTexture *texture) {
    union { CPreSprite sprite; };
    int quad_a[4];
    int quad_b[4];
    float center[4];
    if (state != 0) {
        __ct__11mgCDrawPrimFv(&sprite);

        sprite.Initialize(0, 0);
        if (glow != 0) {
            sprite.AlphaBlend(2);
        } else {
            sprite.AlphaBlend(1);
        }
        sprite.AlphaBlendEnable(1);
        sprite.AlphaTestEnable(1);
        sprite.AlphaTest(1, 0);
        sprite.DepthTestEnable(1);
        sprite.ZMask(-1);
        sprite.Bilinear(1);
        sprite.TextureMapEnable(1);
        sprite.Coord(1);
        sprite.Begin(6);
        sprite.Texture(texture);
        sprite.AlphaTestEnable(1);
        sprite.Color(0x80, 0x80, 0x80, fptosi(alpha));
        pos[3] = 1.0f;
        int column = anim_frame / 4;
        int draw_u = this->tex_u + column * 16;
        sceVu0CopyVector(center, pos);
        center[1] += height / 2.0f;
        center[1] += bob_height * sinf(angle);
        if (init_1411 == 0) {
            anim_1410 = 0.0f;
            init_1411 = 1;
        }
        if (anim_1410 > 3.1415927f) {
            anim_1410 = 0.0f;
        } else {
            anim_1410 += 0.20943952f;
        }
        float base_width = width;
        float shadow_width = base_width + base_width * sinf(anim_1410);
        float base_height = height;
        float shadow_height = base_height + base_height * sinf(anim_1410);
        sceVu0CopyVector(draw_pos, center);
        if (glow != 0 &&
            mgTransWorldPrim3DSprite(quad_a, quad_b, center, shadow_width, shadow_height, 0) != 0) {
            sprite.TextureCrd(0x61, 1);
            sprite.Vertex4(quad_a);
            sprite.TextureCrd(0x7F, 0x1F);
            sprite.Vertex4(quad_b);
        }
        if (mgTransWorldPrim3DSprite(quad_a, quad_b, center, width, height, 0) != 0) {
            sprite.SetAlphaBlend(1);
            sprite.TextureCrd(draw_u, tex_v);
            sprite.Vertex4(quad_a);
            sprite.TextureCrd(draw_u + tex_w, tex_v + tex_h);
            sprite.Vertex4(quad_b);
        }
        sprite.End();
    }
}
#ifdef NONMATCHING
void CPullItem::Step() {
    CCharacter2  *player;
    sceVu0FVECTOR collect_pos;
    sceVu0FVECTOR player_pos;
    sceVu0FVECTOR from;
    sceVu0FVECTOR to;
    sceVu0FVECTOR hit_pos;
    mgVu0FBOX     bounds;
    CCPoly       *polys;
    int           poly_count;
    float         ground_dist;
    sceVu0FVECTOR money_direction;
    char          badge_message[256];
    sceVu0FVECTOR badge_spark;
    sceVu0FVECTOR item_direction;
    sceVu0FVECTOR item_spark;
    char          item_message[256];
    int           item_count;
    sceVu0FVECTOR key_direction;
    char          key_message[256];
    sceVu0FVECTOR stolen_direction;
    char          stolen_message[256];
    sceVu0FVECTOR exp_direction;
    float         distance;

    if (state == PULL_ITEM_STATE_FREE) {
        return;
    }
    player = DngMainScene->GetCharacter(0);
    if (player == NULL) {
        return;
    }
    player->GetPosition(player_pos);
    player->GetPosition(collect_pos);
    collect_pos[1] += player->body_height;
    if (type == PULL_ITEM_MONEY || type == PULL_ITEM_WEAPON_EXP) {
        anim_frame++;
        if (anim_frame >= 16) {
            anim_frame = 0;
        }
    }
    if (can_get != 0 && get_delay > 0) {
        get_delay--;
    }
    if (state == PULL_ITEM_STATE_FALL) {
        bounds.max[0] = 60.0f + pos[0];
        bounds.min[0] = pos[0] - 60.0f;
        bounds.max[1] = 60.0f + pos[1];
        bounds.min[1] = pos[1] - 60.0f;
        bounds.max[2] = 60.0f + pos[2];
        bounds.min[2] = pos[2] - 60.0f;
        bounds.max[3] = 1.0f;
        bounds.min[3] = 1.0f;
        BuffWorkData__2.stack_used = 0;
        BuffWorkData__2.lock = 0;
        polys = (CCPoly *)BuffWorkData__2.stAlloc64(641);
        poly_count = DngMainScene->GetColPoly(polys, bounds, 128);
        sceVu0CopyVector(from, pos);
        sceVu0AddVector(to, pos, velocity);
        if (CheckHit(polys, poly_count, from, to, hit_pos, 1, 0x4) > 0) {
            pos[0] = hit_pos[0];
            pos[2] = hit_pos[2];
            velocity[0] *= -0.6f;
            velocity[2] *= -0.6f;
        }
        sceVu0AddVector(pos, pos, velocity);
        if (velocity[1] > -3.0f) {
            velocity[1] -= 0.3f;
        }
        sceVu0CopyVector(from, pos);
        sceVu0CopyVector(to, pos);
        from[1] += 5.0f;
        to[1] -= 20.0f;
        if (CheckHit(polys, poly_count, from, to, hit_pos, 1, 0x4) >= 0) {
            ground_dist = pos[1] - hit_pos[1];
            if (ground_dist <= 1.0f) {
                can_get = 1;
                velocity[1] *= -0.6f;
                if (ground_dist <= 0.0f) {
                    pos[1] = hit_pos[1];
                }
                if (velocity[1] < 1.0f) {
                    state = PULL_ITEM_STATE_LAND;
                }
            }
        }
        fall_time--;
        if (fall_time <= 0) {
            state = PULL_ITEM_STATE_FADE;
            wait_time = 30;
        }
    }
    if (state == PULL_ITEM_STATE_LAND) {
        if (wait_time > 0) {
            wait_time--;
        }
        if (wait_time == 0) {
            wait_time = 30;
            state = PULL_ITEM_STATE_FADE;
        }
    }
    if (state == PULL_ITEM_STATE_FADE) {
        wait_time--;
        alpha -= 4.266667f;
        if (wait_time <= 0) {
            state = PULL_ITEM_STATE_FREE;
            if (wire_index >= 0) {
                afterWire[wire_index].SetMode(0);
                wire_index = -1;
            }
        }
    }
    if (state == PULL_ITEM_STATE_GOT) {
        sceVu0CopyVector(pos, collect_pos);
        get_delay--;
        if (get_delay <= 0) {
            state = PULL_ITEM_STATE_FREE;
        }
        if (angle < 2.3561945f) {
            angle += 0.1308997f;
        }
    }
    if (state == PULL_ITEM_STATE_FLOAT) {
        if (get_delay > 0) {
            get_delay--;
            angle += 0.20943952f;
            if (angle >= 3.1415927f) {
                angle -= 6.2831855f;
            }
        } else {
            can_get = 1;
            angle = 0.0f;
        }
    }
    if (state == PULL_ITEM_STATE_COLLECT) {
        if (type == PULL_ITEM_MONEY || type == PULL_ITEM_MONEY_LARGE) {
            angle += 0.15707964f;
            sceVu0SubVector(money_direction, player_pos, pos);
            sceVu0Normalize(money_direction, money_direction);
            sceVu0ScaleVectorXYZ(money_direction, money_direction, 2.5f);
            sceVu0AddVector(pos, pos, money_direction);
            distance = mgDistVector(player_pos, pos);
            if (angle >= 3.1415927f || distance <= 5.0f) {
                DngUserData->AddMoney(item_no);
                state = PULL_ITEM_STATE_FREE;
                sndSePlay(DngMainScene->se_battle_id, 3, 0);
            }
        }
        if (type == PULL_ITEM_BADGE) {
            char *&badge_name = mons_attr_list[LanguageCode][item_no];
            if (DngUserData->monster_box.IsChange(item_no) != 0) {
                sprintf(badge_message, dung_progtxt_badge_already[LanguageCode], badge_name);
                MsgTaskMan.Print(badge_message, 90, 8, 0);
                state = PULL_ITEM_STATE_FREE;
            } else {
                angle += 0.15707964f;
                if (angle >= 3.1415927f) {
                    sprintf(badge_message, dung_progtxt_badge_get[LanguageCode], badge_name);
                    MsgTaskMan.Print(badge_message, 60, 8, 0);
                    DngUserData->monster_box.EnableChange(item_no);
                    state = PULL_ITEM_STATE_FREE;
                }
                sceVu0CopyVector(badge_spark, draw_pos);
                badge_spark[0] += fRand(10.0f) - 5.0f;
                badge_spark[1] -= fRand(3.0f);
                badge_spark[2] += fRand(10.0f) - 5.0f;
                MiniEffPrimMan.CreatPrim(badge_spark, 0);
            }
        }
        if (type == PULL_ITEM_ITEM || type == PULL_ITEM_ITEM2) {
            if (mgDistVector(collect_pos, pos) > 5.0f) {
                angle += 0.15707964f;
                sceVu0SubVector(item_direction, player_pos, pos);
                sceVu0Normalize(item_direction, item_direction);
                sceVu0ScaleVectorXYZ(item_direction, item_direction, 2.5f);
                sceVu0AddVector(pos, pos, item_direction);
            }
            sceVu0CopyVector(item_spark, draw_pos);
            item_spark[0] += fRand(10.0f) - 5.0f;
            item_spark[1] -= fRand(3.0f);
            item_spark[2] += fRand(10.0f) - 5.0f;
            MiniEffPrimMan.CreatPrim(item_spark, 0);
            if (angle >= 3.1415927f) {
                angle = 0.0f;
                num = 1;
                if (CheckGetItemLimmitOver(item_no, num) < num) {
                    item_count = num;
                    if (LanguageCode == 0) {
                        sprintf(item_message, dung_progtxt_getitem_overnum[0][1], GetItemMessage(item_no), item_count);
                    } else if (item_count < 2) {
                        sprintf(item_message, dung_progtxt_getitem_overnum[LanguageCode][0], GetItemMessage(item_no));
                    } else {
                        sprintf(item_message, dung_progtxt_getitem_overnum[LanguageCode][1], num, GetItemMessage(item_no));
                    }
                    MsgTaskMan.Print(item_message, 90, 8, 0);
                    state = PULL_ITEM_STATE_LAND;
                    can_get = 1;
                    get_delay = 60;
                    wait_time = 300;
                } else {
                    item_count = num;
                    if (LanguageCode == 0) {
                        sprintf(item_message, dung_progtxt_getitem[0][1], GetItemMessage(item_no), item_count);
                    } else if (item_count < 2) {
                        sprintf(item_message, dung_progtxt_getitem[LanguageCode][0], GetItemMessage(item_no));
                    } else {
                        sprintf(item_message, dung_progtxt_getitem[LanguageCode][1], num, GetItemMessage(item_no));
                    }
                    MsgTaskMan.Print(item_message, 45, 8, 0);
                    DngUserData->GetItem(item_no, 1);
                    state = PULL_ITEM_STATE_FREE;
                }
            }
        }
        if (type == PULL_ITEM_GATE_KEY) {
            if (mgDistVector(collect_pos, pos) > 5.0f + pull_speed) {
                pull_speed += pull_accel;
                pull_speed += 0.2f;
                sceVu0SubVector(key_direction, collect_pos, pos);
                sceVu0Normalize(key_direction, key_direction);
                sceVu0ScaleVectorXYZ(key_direction, key_direction, pull_speed);
                key_direction[1] += 2.5f;
                sceVu0AddVector(pos, pos, key_direction);
            } else {
                sprintf(key_message, dung_progtxt_gkey_get[LanguageCode], GetItemMessage(item_no));
                MsgTaskMan.Print(key_message, 90, 8, 0);
                DngUserData->GetItem(item_no, 1);
                state = PULL_ITEM_STATE_GOT;
                get_delay = 60;
                bob_height = 30.0f;
            }
        }
        if (type == PULL_ITEM_STOLEN) {
            if (mgDistVector(collect_pos, pos) > 5.0f + pull_speed) {
                pull_speed += pull_accel;
                pull_speed += 0.2f;
                sceVu0SubVector(stolen_direction, collect_pos, pos);
                sceVu0Normalize(stolen_direction, stolen_direction);
                sceVu0ScaleVectorXYZ(stolen_direction, stolen_direction, pull_speed);
                stolen_direction[1] += 2.5f;
                sceVu0AddVector(pos, pos, stolen_direction);
            } else {
                sprintf(stolen_message, dung_progtxt_steal[LanguageCode], GetItemMessage(item_no));
                MsgTaskMan.Print(stolen_message, 90, 8, 0);
                DngUserData->GetItem(item_no, 1);
                state = PULL_ITEM_STATE_GOT;
                get_delay = 60;
                bob_height = 30.0f;
            }
        }
        if (type == PULL_ITEM_WEAPON_EXP) {
            if (mgDistVector(collect_pos, pos) > 5.0f + pull_speed) {
                pull_speed += pull_accel;
                pull_speed += 0.2f;
                sceVu0SubVector(exp_direction, collect_pos, pos);
                sceVu0Normalize(exp_direction, exp_direction);
                sceVu0ScaleVectorXYZ(exp_direction, exp_direction, pull_speed);
                exp_direction[1] += 2.5f;
                sceVu0AddVector(pos, pos, exp_direction);
            } else {
                AddExpWeaponParam(exp, exp_param, item_no);
                sndSePlay(DngMainScene->se_battle_id, 4, 0);
                state = PULL_ITEM_STATE_FREE;
                if (wire_index >= 0) {
                    afterWire[wire_index].SetMode(0);
                    wire_index = -1;
                }
            }
        }
    }
    if (wire_index >= 0) {
        afterWire[wire_index].SetPos(pos);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_object", Step__9CPullItemFv);
#endif
void CPullItem::IsGet(float *player_pos) {
    if (state == PULL_ITEM_STATE_FREE || can_get == 0 || get_delay > 0) {
        return;
    }
    if (type == PULL_ITEM_GATE_KEY || type == PULL_ITEM_STOLEN) {
        can_get = 0;
        state = PULL_ITEM_STATE_COLLECT;
        return;
    }
    if (mgDistVector(player_pos, pos) < 20.0f * get_range) {
        state = PULL_ITEM_STATE_COLLECT;
        can_get = 0;
        if (type == PULL_ITEM_ITEM || type == PULL_ITEM_BADGE) {
            sndSePlay(SystemSND_ID, 18, 0);
        }
    }
}
void CPullItem::SetItem(float *position, float *new_velocity, int kind) {
    sceVu0CopyVector(pos, position);
    sceVu0CopyVector(this->velocity, new_velocity);
    this->type = kind;
    angle = 0.0f;
    can_get = 0;
    fall_time = 300;
    exp_param = -1;
    item_no = -1;
    alpha = 128.0f;
    glow = 0;
    bob_height = 15.0f;
    wire_index = -1;
    switch (kind) {
        case 2:
            state = PULL_ITEM_STATE_FLOAT;
            tex_u = 0;
            tex_v = 0;
            tex_h = 32;
            tex_w = 32;
            width = 7.0f;
            height = 8.0f;
            get_range = 0.8f;
            anim_frame = 0;
            get_delay = 30;
            pull_speed = 1.8f;
            pull_accel = 0.1f;
            bob_height = 4.0f;
            glow = 1;
            return;
        case 7:
            state = PULL_ITEM_STATE_FLOAT;
            tex_u = 0x61;
            tex_v = 0x21;
            tex_h = 30;
            tex_w = 30;
            width = 7.0f;
            height = 8.0f;
            get_range = 0.8f;
            anim_frame = 0;
            get_delay = 30;
            pull_speed = 1.8f;
            pull_accel = 0.1f;
            bob_height = 4.0f;
            glow = 1;
            return;
        case 3:
            state = PULL_ITEM_STATE_FALL;
            tex_u = 32;
            tex_v = 0;
            tex_h = 32;
            tex_w = 32;
            width = 7.0f;
            height = 8.0f;
            get_range = 4.5f;
            anim_frame = 0;
            get_delay = 40;
            wait_time = 240;
            return;
        case 0:
            state = PULL_ITEM_STATE_FALL;
            tex_u = 0;
            tex_v = 32;
            tex_h = 16;
            tex_w = 16;
            width = 3.0f;
            height = 4.0f;
            get_range = 4.5f;
            anim_frame = iRand(16);
            get_delay = 40;
            wait_time = 180;
            return;
        case 1: {
            state = PULL_ITEM_STATE_FALL;
            tex_u = 1;
            tex_v = 0x31;
            tex_h = 14;
            tex_w = 14;
            width = 3.0f;
            height = 3.0f;
            get_range = 4.5f;
            get_delay = 30;
            wait_time = 180;
            pull_speed = 1.8f;
            pull_accel = 0.1f;
            glow = 1;
            int i = 0;
            for (; i < 16; i++) {
                if (afterWire[i].mode == 0) {
                    afterWire[i].SetMode(1);
                    wire_index = i;
                    return;
                }
            }
            return;
        }
        case 4:
            state = PULL_ITEM_STATE_FALL;
            tex_u = 64;
            tex_v = 0;
            tex_h = 31;
            tex_w = 31;
            width = 7.0f;
            height = 8.0f;
            get_range = 4.5f;
            anim_frame = 0;
            get_delay = 10;
            wait_time = 300;
            bob_height = 25.0f;
            return;
        case 5:
            state = PULL_ITEM_STATE_FALL;
            tex_u = 64;
            tex_v = 32;
            tex_h = 31;
            tex_w = 31;
            width = 7.0f;
            height = 7.0f;
            get_range = 4.5f;
            anim_frame = 0;
            get_delay = 10;
            wait_time = 300;
            bob_height = 25.0f;
            return;
        case 6:
            state = PULL_ITEM_STATE_FALL;
            tex_u = 64;
            tex_v = 0;
            tex_h = 31;
            tex_w = 31;
            width = 7.0f;
            height = 8.0f;
            get_range = 1.5f;
            anim_frame = 0;
            get_delay = 10;
            wait_time = 300;
            bob_height = 25.0f;
            return;
    }
}
void CPullItem::Clear(void) {
    wire_index = -1;
    state = PULL_ITEM_STATE_FREE;
}
void CPullItem::Initialize(void) {
    state = PULL_ITEM_STATE_FREE;
    wait_time = 0;
    tex_u = 0;
    tex_v = 0;
    tex_w = 32;
    tex_h = 32;
    can_get = 0;
    anim_frame = 0;
}
CPullItem *CPullItemManager::GetList(int start) {
    if (list == NULL || num <= 0) {
        return NULL;
    }
    CPullItem *item = list + start;
    for (int i = start; i < num; i++) {
        if (item->state == PULL_ITEM_STATE_FREE) {
            return item;
        }
        item++;
    }
    return NULL;
}
void CPullItemManager::Clear(void) {
    if (list != NULL) {
        for (int i = 0; i < num; i++) {
            list[i].Clear();
        }
    }
}
void CRoboVoiceSystem::SetStatus(int voice, int value) {
    status = 1;
    voice_no = voice;
    unk_10 = value;
}
void CRoboVoiceSystem::StartVoiceSystem(void) {
    status = 5;
    voice_no = -1;
    wait_time = iRand(240) + 60;
    stream_open = 0;
}
void CRoboVoiceSystem::StopVoice(int frames) {
    if (stream_open != 0) {
        do {
        } while (CSnd.StreamOpenState() != 0);
        CSnd.StreamClose(1);
    }
    stream_open = 0;
    status = 0;
    pause_time = (s16)frames;
}
void CRoboVoiceSystem::Step() {
    CBattleCharaInfo *battle_info;
    int               max_hp;
    int               now_hp;
    int               now_whp[2];
    float             hp_ratio;
    int               monster_count;

    if (status == ROBO_VOICE_OFF) {
        return;
    }

    if (pause_time > 0) {
        pause_time--;
        return;
    }

    battle_info = GetBattleCharaInfo();
    max_hp = battle_info->GetMaxHp_i();
    now_hp = battle_info->GetNowHp_i();
    battle_info->GetNowWhp(0, now_whp);
    hp_ratio = (float)now_hp / (float)max_hp;
    int               healthy_voices[4] = {30, 40, 60, 160};
    int               injured_voices[3] = {80, 90, 190};
    int               low_hp_voices[5] = {100, 110, 120, 170, 220};
    int               long_play_voices[3] = {70, 140, 150};
    int               nearby_voices[2] = {50, 180};
    int               crowded_voices[2] = {130, 200};
    int               critical_voices[4] = {120, 120, 220, 170};
    char              voice_file[64];
    play_time++;

    switch (status) {
        case ROBO_VOICE_WAIT:
            wait_time--;
            if (wait_time < 0) {
                wait_time = 0;
                if (voice_no == -1) {
                    if (hp_ratio > 0.8f) {
                        SetStatus(healthy_voices[iRand(4)], 0);
                    }

                    if (hp_ratio <= 0.8f && hp_ratio > 0.4f) {
                        SetStatus(injured_voices[iRand(3)], 0);
                    }

                    if (hp_ratio <= 0.4f) {
                        SetStatus(low_hp_voices[iRand(5)], 0);
                    }

                    if (iRand(100) % 4 == 0 && play_time >= 3600) {
                        SetStatus(long_play_voices[iRand(3)], 0);
                    }

                    if (iRand(100) % 2 != 0) {
                        monster_count = ActiveMonster->GetMonsterNum(340.0f);
                        if (monster_count > 0) {
                            if (monster_count >= 4) {
                                SetStatus(crowded_voices[iRand(2)], 0);
                            } else {
                                SetStatus(nearby_voices[iRand(2)], 0);
                            }
                        }
                    }

                    if (hp_ratio <= 0.2f) {
                        SetStatus(critical_voices[iRand(4)], 0);
                    }
                } else {
                    SetStatus(voice_no, 0);
                }
            }
            break;

        case ROBO_VOICE_OPEN:
            if (voice_no < 100) {
                sprintf(voice_file, "85200%d.wav", voice_no);
            } else {
                sprintf(voice_file, "8520%d.wav", voice_no);
            }

            CSnd.StreamOpenFast(1, voice_file);
            status = ROBO_VOICE_OPENING;
            stream_open = 1;
            break;

        case ROBO_VOICE_OPENING:
            if (CSnd.StreamOpenState() == 0) {
                CSnd.StreamStandBy(1);
                status = ROBO_VOICE_STANDBY;
            }
            break;

        case ROBO_VOICE_STANDBY:
            if (CSnd.StreamOpenState() == 0) {
                CSnd.StreamSetVol(1, 0x7FFF, 0x7FFF);
                CSnd.StreamPlay(1);
                status = ROBO_VOICE_PLAY;
            }
            break;

        case ROBO_VOICE_PLAY:
            if (CSnd.StreamGetState(1) == 0x8000) {
                CSnd.StreamClose(1);
                status = ROBO_VOICE_WAIT;
                stream_open = 0;
                wait_time = iRand(300) + 90;
                if (voice_no == 200) {
                    voice_no = 210;
                    wait_time = 45;
                } else {
                    voice_no = -1;
                }
            }
            break;
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_923__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1112__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1240__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", mons_attr_tbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", mons_attr_tbl2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", mons_attr_tbl3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", mons_attr_tbl4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", mons_attr_tbl5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", mons_attr_tbl6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", mons_attr_list__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", dung_progtxt_badge_already__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", dung_progtxt_badge_get__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", dung_progtxt_gkey_get__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", dung_progtxt_steal__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", dung_progtxt_getitem_overnum__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", dung_progtxt_getitem__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1800__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1801__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1802__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1803__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1806__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_961__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1291__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1428__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1429__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1430__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1431__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1432__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1433__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1434__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1435__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1436__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1437__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1438__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1439__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1440__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1441__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1442__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1443__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1444__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1445__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1446__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1447__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1448__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1449__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1450__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1451__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1452__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1453__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1454__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1455__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1456__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1457__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1458__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1459__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1460__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1461__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1462__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1463__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1464__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1465__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1466__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1467__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1468__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1469__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1470__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1471__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1472__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1473__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1474__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1475__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1476__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1477__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1478__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1479__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1480__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1481__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1482__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1483__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1484__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1485__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1486__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1487__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1488__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1489__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1490__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1491__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1492__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1493__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1494__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1495__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1496__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1497__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1498__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1499__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1500__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1501__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1502__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1503__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1504__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1505__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1506__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1507__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1508__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1509__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1510__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1511__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1512__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1513__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1514__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1515__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1516__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1517__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1518__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1519__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1520__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1521__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1522__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1523__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1524__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1525__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1526__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1527__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1528__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1529__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1530__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1531__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1736__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1853__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1854__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1804__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_object", at_1805__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(anim_1410, 0x4);
INCLUDE_BSS(init_1411, 0x4);
