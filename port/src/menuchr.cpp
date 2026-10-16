#include "menuchr.hpp"

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <limits>

#include "actionchara.hpp"
#include "dataread_port.hpp"
#include "dng_effect.hpp"
#include "dng_main.hpp"
#include "mainloop.hpp"
#include "mainloop_port.hpp"
#include "menu_character_assets.hpp"
#include "menuchr_port.hpp"
#include "menudraw.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/arena.hpp"
#include "platform/model_assets.hpp"
#include "prespr.hpp"
#include "quick_loadout.hpp"
#include "swordeffect.hpp"
#include "userdata.hpp"

namespace {

// Disc capacities in quadwords, before MenuMemoryDivide's 64-block rounding.
constexpr int kHumanCapacity[MENU_CHARA_LOAD_MAX] = {
    0x1B80, 0x9AC0, 0x1C84, 0x11C0, 0x0BC0, 0x26C0, 0x0708};
constexpr int kRidepodCapacity[MENU_CHARA_LOAD_MAX] = {
    0x5240, 0x4514, 0x6E80, 0x1240, 0x05DC, 0, 0};

// A quick change (L3, R3) whose target can be loaded, from InitMainCharaBG until KeyMainCharaBG finishes it.
bool quick_change_pending = false;

// The character the pending quick change loads, for the banner that names it afterwards.
int quick_change_chara = -1;

// Character-change banner layout and slide timing in native gameplay ticks.
constexpr int   kBannerWidth = 0x100;
constexpr int   kBannerHeight = 0x40;
constexpr int   kBannerBottomMargin = 40;
constexpr float kBannerSlideInSpeed = 18.0f;
constexpr float kBannerSlideOutSpeed = 24.0f;
constexpr int   kBannerHoldTicks = 50;
constexpr int   kBannerStripAlpha = 0x48;
constexpr int   kBannerStripPad = 6;

/**
 * Character-change banner slide phase.
 */
enum BannerPhase {
    BANNER_IN,   /**< Sliding in from the left edge. */
    BANNER_HOLD, /**< Resting at the bottom centre. */
    BANNER_OUT   /**< Sliding out past the right edge. */
};

int   banner_chara = -1;
int   banner_loop = -1;
int   banner_phase = BANNER_IN;
int   banner_hold = 0;
float banner_x = 0.0f;

// Character-change effect timing in game frames, adapted from Dark Cloud's GAME_TASK_CHARA_CHANGED.
constexpr int   kChangeFadeFrames = 24;
constexpr int   kChangeSparkFrames = 2;
constexpr int   kChangeSparksPerFrame = 18;
constexpr int   kChangeSparkMax = 64;
constexpr float kChangeSparkGravity = 0.07f;
constexpr float kChangeSparkDrag = 0.95f;
constexpr int   kChangeSparkAlpha = 0x50;

/**
 * One star of the character-change splash.
 */
struct alignas(16) ChangeSpark {
    float pos[4]; /**< Offset from the character's position. */
    float vel[4]; /**< Per-frame movement. */
    float size;   /**< Screen sprite size before twinkling. */
    float phase;  /**< Twinkle phase in radians. */
    int   age;    /**< Frames since the star spawned. */
    int   life;   /**< Frames the star lives. */
};

ChangeSpark change_sparks[kChangeSparkMax];
int         change_spark_count = 0;
bool        change_fx_pending = false;
int         change_fx_loop = -1;
int         change_fade_frames = 0;
int         change_spark_frames = 0;

// Maximum synchronous loading steps before normal menu pacing resumes.
constexpr int kQuickChangeMaxSteps = 256;

} // namespace

bool menu_character::PrepareArena(mgCMemory &memory, const std::filesystem::path &model, std::string_view profile,
                                  std::string &error, std::size_t extra_quadwords) {
    if (memory.stack_used != 0) {
        error = "menu character arena must be reset before construction";
        return false;
    }
    const auto estimate = model_assets::EstimateCharacterMemory(model, profile, error);
    if (!estimate) {
        return false;
    }
    const auto quadwords = (*estimate + sizeof(u_long128) - 1) / sizeof(u_long128) + extra_quadwords + 1;
    if (quadwords > static_cast<std::size_t>(std::numeric_limits<int>::max() - 63)) {
        error = "menu character exceeds native arena capacity";
        return false;
    }
    const int capacity = static_cast<int>((quadwords + 63) / 64 * 64);
    if (memory.stack_size < capacity || !memory.stack) {
        auto *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&memory, static_cast<std::size_t>(capacity) * sizeof(u_long128)));
        memory.stSetBuffer(storage, capacity);
    }
    error.clear();
    return true;
}

void PortPrepareMenuCharacterArena(mgCMemory &memory, const void *model, const char *profile, int part) {
    const auto  path = DataReadBufferPath(model);
    std::string error;
    // Equipped melee weapons reserve the native twelve-point, eight-subdivision sword trail.
    const std::size_t trail = part == 2 ? (sizeof(CSWordAfterEffect) + 15) / 16 + 2 + 2 * (12 + 1) + 2 * (12 * (8 + 2) + 1) : 0;
    if (!path || !menu_character::PrepareArena(memory, *path, profile ? profile : "", error, trail)) {
        std::fprintf(stderr, "menu character %s: %s\n", path ? path->c_str() : "unknown asset", path ? error.c_str() : "actual glTF filename required");
        std::exit(1);
    }
}

void PortRetailInitMainCharaBG(int, mgCMemory *, int) asm("MenuChr_InitMainCharaBG");
int  PortRetailKeyMainCharaBG() asm("MenuChr_KeyMainCharaBG");
int  PortRetailChangeSetUnit(int) asm("DngMain_ChangeSetUnit");

PORT_OVERRIDE void MenuMemoryAdjust(mgCMemory *pool, mgCMemory *rest, mgCMemory *buffers, int chara) {
    int capacities[MENU_CHARA_LOAD_MAX]{};
    if (chara == USER_CHARA_MAX || chara == USER_CHARA_MONICA || chara == USER_CHARA_ROBO) {
        const int *table = chara == USER_CHARA_ROBO ? kRidepodCapacity : kHumanCapacity;
        for (int i = 0; i < MENU_CHARA_LOAD_MAX; ++i) {
            capacities[i] = (table[i] + 63) / 64 * 64;
        }
    } else if (chara == USER_CHARA_MONSTER) {
        capacities[0] = 0x6400;
        capacities[5] = 0x3C0;
    }

    pool->Align64();
    int partitions = 0;
    for (int blocks : capacities) {
        partitions += blocks;
    }
    const int remaining = pool->stack_size - pool->stack_used;
    if (partitions > remaining) {
        std::fprintf(stderr, "menu character partitions exceed aligned pool: %d of %d blocks\n",
                     partitions, remaining);
        std::abort();
    }

    u_long128 *cursor = pool->stGetTop();
    for (int i = 0; i < MENU_CHARA_LOAD_MAX; ++i) {
        // Monster menus only replace these two views; the others retain their
        // owners just as in MenuMemoryDivide.
        if (chara == USER_CHARA_MONSTER && i != 0 && i != 5) {
            continue;
        }
        if (chara == USER_CHARA_MAX || chara == USER_CHARA_MONICA || chara == USER_CHARA_ROBO ||
            chara == USER_CHARA_MONSTER) {
            buffers[i].stSetBuffer(cursor, capacities[i]);
            if (chara != USER_CHARA_MONSTER) {
                std::snprintf(buffers[i].name, sizeof(buffers[i].name), "stack %d\n", i);
            }
            cursor += capacities[i];
        }
    }
    rest->stSetBuffer(cursor, remaining - partitions);
    std::strcpy(rest->name, "LOAD STACK");
    rest->stack_used = 0;
    rest->lock = 0;
}

/**
 * Starts a character change and records whether it can use synchronous loading.
 */
PORT_OVERRIDE void InitMainCharaBG(int chara_no, mgCMemory *stack, int mode) {
    quick_change_pending = false;

    if (stack != nullptr) {
        int reason;
        quick_change_pending = (GetUserDataMan()->CheckQuickChange(chara_no, &reason) & QUICK_CHANGE_STATE_ENABLED) != 0;
        quick_change_chara = chara_no;
    }

    PortRetailInitMainCharaBG(chara_no, stack, mode);
}

/**
 * Completes an eligible quick change within a bounded number of loading steps.
 */
PORT_OVERRIDE int KeyMainCharaBG() {
    if (!quick_change_pending) {
        const int done = PortRetailKeyMainCharaBG();
        if (done != 0) {
            PortQuickLoadoutReloadDone();
        }
        return done;
    }

    for (int step = 0; step < kQuickChangeMaxSteps; ++step) {
        if (PortRetailKeyMainCharaBG() != 0) {
            quick_change_pending = false;
            // A quick loadout loads the same character again with other equipment: the effect, but no name.
            if (!PortQuickLoadoutReloading()) {
                banner_chara = quick_change_chara;
                banner_loop = PortLoopNo;
                banner_phase = BANNER_IN;
                banner_hold = 0;
                banner_x = static_cast<float>(-kBannerWidth);
            }
            PortQuickLoadoutReloadDone();
            change_fx_pending = true;
            change_fx_loop = PortLoopNo;
            return 1;
        }
    }

    std::fprintf(stderr, "quick change: not finished after %d steps, continuing frame by frame\n", kQuickChangeMaxSteps);
    quick_change_pending = false;
    return 0;
}

namespace {

/**
 * Reports whether the last quick change's effect is still playing.
 */
bool ChangeEffectRunning() {
    return change_fx_pending || change_fade_frames > 0 || change_spark_frames > 0 || change_spark_count > 0;
}

/**
 * Ends the character-change effect and discards its stars.
 */
void StopChangeEffect() {
    change_fx_pending = false;
    change_fade_frames = 0;
    change_spark_frames = 0;
    change_spark_count = 0;
}

/**
 * Spawns one star bursting out and up from around the character's waist.
 */
void SpawnChangeSpark(CActionChara *chara) {
    if (change_spark_count >= kChangeSparkMax) {
        return;
    }

    ChangeSpark &spark = change_sparks[change_spark_count++];
    const float  angle = fRand(2.0f * PI);
    const float  out = 0.6f + fRand(0.8f);
    const float  start = 0.5f + fRand(1.5f);
    spark.pos[0] = start * cosf(angle);
    spark.pos[1] = (0.2f + fRand(0.3f)) * chara->GetBodyHeight();
    spark.pos[2] = start * sinf(angle);
    spark.pos[3] = 0.0f;
    spark.vel[0] = out * cosf(angle);
    spark.vel[1] = 0.8f + fRand(0.8f);
    spark.vel[2] = out * sinf(angle);
    spark.vel[3] = 0.0f;
    spark.size = 3.0f + fRand(2.5f);
    spark.phase = fRand(2.0f * PI);
    spark.age = 0;
    spark.life = 26 + static_cast<int>(fRand(10.0f));
}

/**
 * Moves and ages the stars, dropping those that have expired.
 */
void StepChangeSparks() {
    int kept = 0;

    for (int i = 0; i < change_spark_count; i++) {
        ChangeSpark &spark = change_sparks[i];
        spark.age++;

        if (spark.age >= spark.life) {
            continue;
        }

        spark.pos[0] += spark.vel[0];
        spark.pos[1] += spark.vel[1];
        spark.pos[2] += spark.vel[2];
        spark.vel[0] *= kChangeSparkDrag;
        spark.vel[2] *= kChangeSparkDrag;
        // +y is up.
        spark.vel[1] -= kChangeSparkGravity;
        change_sparks[kept++] = spark;
    }

    change_spark_count = kept;
}

/**
 * Draws the stars as soft additive four-pointed fans, depth-tested against the scene.
 */
void DrawChangeSparks(const sceVu0FVECTOR base) {
    if (change_spark_count <= 0) {
        return;
    }

    // Untextured, so the stars need no effect texture from the current loop.
    CPreSprite prim;
    prim.Initialize(nullptr, nullptr);
    prim.Preset2D();
    prim.Coord(1);
    prim.DepthTestEnable(1);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.TextureMapEnable(0);
    prim.Shading(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);

    for (int i = 0; i < change_spark_count; i++) {
        ChangeSpark  &spark = change_sparks[i];
        const float   t = static_cast<float>(spark.age) / static_cast<float>(spark.life);
        const float   envelope = t < 0.08f ? t / 0.08f : std::min(1.0f, 2.0f - 2.0f * t);
        const float   twinkle = 0.75f + 0.25f * sinf(spark.phase + 0.9f * static_cast<float>(spark.age));
        const int     alpha = static_cast<int>(static_cast<float>(kChangeSparkAlpha) * envelope * twinkle);
        const float   size = spark.size * twinkle;
        int           top_left[4];
        int           bottom_right[4];
        sceVu0FVECTOR world;
        world[0] = base[0] + spark.pos[0];
        world[1] = base[1] + spark.pos[1];
        world[2] = base[2] + spark.pos[2];
        world[3] = 1.0f;

        if (alpha <= 0 || mgTransWorldPrim3DSprite(top_left, bottom_right, world, size, size, 0) == 0) {
            continue;
        }

        const int cx = (top_left[0] + bottom_right[0]) / 2;
        const int cy = (top_left[1] + bottom_right[1]) / 2;
        const int rx = std::abs(bottom_right[0] - top_left[0]) / 2;
        const int ry = std::abs(bottom_right[1] - top_left[1]) / 2;
        int       vertex[4] = {cx, cy, top_left[2], top_left[3]};

        // A warm centre fading to clear tips, with dimmer notches between the four points.
        prim.Begin(MG_PRIM_TRIANGLE_FAN);
        prim.Color(0xFF, 0xF4, 0xD0, alpha);
        prim.Vertex4(vertex);

        for (int k = 0; k <= 8; k++) {
            const float angle = static_cast<float>(k % 8) * (PI / 4.0f);
            const float reach = (k % 2) == 0 ? 1.0f : 0.22f;
            vertex[0] = cx + static_cast<int>(static_cast<float>(rx) * reach * sinf(angle));
            vertex[1] = cy - static_cast<int>(static_cast<float>(ry) * reach * cosf(angle));
            prim.Color(0xFF, 0xF4, 0xD0, (k % 2) == 0 ? 0 : alpha / 2);
            prim.Vertex4(vertex);
        }

        prim.End();
    }
}

} // namespace

/**
 * Clears the character-change banner and effect before a gameplay mode transition.
 */
void PortCancelQuickChangeBanner() {
    banner_chara = -1;
    StopChangeEffect();
}

/**
 * Reports whether a new quick change must wait for the last one's effect.
 */
bool PortQuickChangeCoolingDown() {
    return ChangeEffectRunning();
}

/**
 * Refuses a dungeon quick change while the last one's effect is still playing.
 */
PORT_OVERRIDE int ChangeSetUnit(int change) {
    if (ChangeEffectRunning()) {
        return -1;
    }

    return PortRetailChangeSetUnit(change);
}

/**
 * Plays the character-change effect: a fade from white and a splash of stars around the new character.
 */
void PortStepQuickChangeEffect() {
    if (PortLoopNo != change_fx_loop) {
        StopChangeEffect();
        return;
    }

    if (MenuPosData != nullptr) {
        return;
    }

    CScene       *scene = GetMainScene();
    const int     index = scene != nullptr && scene->player_chara >= 0 ? scene->player_chara : 0;
    CActionChara *chara = scene != nullptr ? static_cast<CActionChara *>(scene->GetCharacter(index)) : nullptr;

    if (chara == nullptr) {
        StopChangeEffect();
        return;
    }

    if (change_fx_pending) {
        change_fx_pending = false;
        // The effect replaces the town's cross-fade from the old character. The menu end code that requests the
        // cross-fade must stay, since MenuMainExit reads MENU_END_CHARA_CHANGE as a menu choice.
        if (scene->fade.cross) {
            scene->fade.ResetFade();
        }
        change_fade_frames = kChangeFadeFrames;
        change_spark_frames = kChangeSparkFrames;
        change_spark_count = 0;
    }

    if (change_fade_frames > 0) {
        // The falling half of one white pulse, reapplied every frame so a character set up again still gets it.
        CPalletAnime &fade = chara->pallet[ACTION_PALLET_MAX - 1];
        fade.SetAnim(0xFF, 0xFF, 0xFF, 1, kChangeFadeFrames * 2, 0);
        fade.elapsed = kChangeFadeFrames * 2 - change_fade_frames;
        change_fade_frames--;
    }

    StepChangeSparks();

    if (change_spark_frames > 0) {
        change_spark_frames--;

        for (int i = 0; i < kChangeSparksPerFrame; i++) {
            SpawnChangeSpark(chara);
        }
    }

    sceVu0FVECTOR base;
    chara->GetPosition(base);
    DrawChangeSparks(base);
}

/**
 * Slides the active character-change banner across the bottom of the screen while its gameplay mode remains active.
 */
void PortDrawQuickChangeBanner() {
    if (banner_chara < 0) {
        return;
    }

    if (PortLoopNo != banner_loop) {
        banner_chara = -1;
        return;
    }

    const int   ticks = mgFrameRate > 0 ? mgFrameRate : 1;
    const float rest_x = static_cast<float>((mgScreenWidth - kBannerWidth) / 2);

    // An open menu hides the banner without pausing its slide.
    switch (banner_phase) {
        case BANNER_IN:
            banner_x += kBannerSlideInSpeed * static_cast<float>(ticks);
            if (banner_x >= rest_x) {
                banner_x = rest_x;
                banner_phase = BANNER_HOLD;
            }
            break;
        case BANNER_HOLD:
            banner_hold += ticks;
            if (banner_hold >= kBannerHoldTicks) {
                banner_phase = BANNER_OUT;
            }
            break;
        default:
            banner_x += kBannerSlideOutSpeed * static_cast<float>(ticks);
            break;
    }

    if (banner_x >= static_cast<float>(mgScreenWidth)) {
        banner_chara = -1;
        return;
    }

    if (MenuPosData != nullptr) {
        return;
    }

    static char logo_name[] = "change_logo";
    mgCTexture *logo = mgTexManager.GetTexture(logo_name, -1);

    if (logo == nullptr) {
        return;
    }

    // The strip fades in with the slide in and out with the slide out.
    float strip = 1.0f;
    if (banner_phase == BANNER_IN) {
        strip = (banner_x + kBannerWidth) / (rest_x + kBannerWidth);
    } else if (banner_phase == BANNER_OUT) {
        strip = 1.0f - (banner_x - rest_x) / (static_cast<float>(mgScreenWidth) - rest_x);
    }
    strip = std::clamp(strip, 0.0f, 1.0f);

    const float top = static_cast<float>(mgScreenHeight - kBannerHeight - kBannerBottomMargin);
    DrawMenuFillBox(0.0f, top + kBannerStripPad, static_cast<float>(mgScreenWidth),
                    static_cast<float>(kBannerHeight - 2 * kBannerStripPad), static_cast<int>(kBannerStripAlpha * strip), 0, 0, 0);

    mgRect<int> row;
    row.Set(0, banner_chara * kBannerHeight, kBannerWidth, kBannerHeight);
    mgTexManager.ReloadTexture(logo->block, static_cast<sceVif1Packet *>(nullptr));
    PrimQuad(logo, banner_x, top, row, 0x80, 0x80, 0x80, 0x80);
}
