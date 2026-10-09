#include "common.h"

#include <cstdio>

#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "fishing.hpp"
#include "gyorace.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "object.hpp"
#include "padcontrol.hpp"
#include "pbuggy.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "subgame.hpp"

/**
 *
 * Currently running sub game.
 *
 */
static int SubGame;

/**
 *
 * Whether menus may open during the running sub game.
 *
 */
static int MenuOpenFlag;

/**
 *
 * Whether a sub-game reward could not fit in the inventory.
 *
 */
static int ItemOver;

/**
 *
 * Parameters retained for the running sub game.
 *
 */
static SubGameInfo GameInfo;

// Code (.text)
void InitSubGame(CScene *scene) {
    SubGame = SUBGAME_NONE;
    MenuOpenFlag = 0;
    ItemOver = 0;

    if (scene->GetCharacter(scene->player_chara) != 0) {
        mgCTextureManager *tex_manager = &mgTexManager;

        for (int i = 0; i < scene->tex_block_count; i++) {
            tex_manager->DeleteBlock(scene->tex_block_base + i);
        }

        for (int j = 0; j < 0x28; j++) {
            scene->DeleteChara(j + 0x40);
        }

        scene->DeleteEffect(7);
    }
}

int SubGameRunning() {
    return SubGame != 0;
}

int GetSubGameNo() {
    return SubGame;
}

SubGameInfo *GetNowSubGameInfo() {
    return &GameInfo;
}

int sgMenuOpenEnable() {
    return SubGameRunning() != 0 ? MenuOpenFlag : 1;
}

void sgSetMenuOpenEnableFlag(int value) {
    MenuOpenFlag = value;
}

int sgGetItemOver() {
    return ItemOver;
}

void sgGetItemOverReset() {
    ItemOver = 0;
}

void sgGetItemOverFlagOn() {
    ItemOver = 1;
}

int sgInitSubGame(int type, SubGameInfo *info) {
    int result;

    MenuOpenFlag = 0;
    ItemOver = 0;
    SubGame = type;

    if (type <= SUBGAME_NONE || type >= SUBGAME_MAX) {
        return 0;
    }

    result = 0;
    GameInfo = *info;
    GameInfo.texb = GameInfo.scene->tex_block_base;
    GameInfo.texb_num = GameInfo.scene->tex_block_count;

    switch (type) {
        case SUBGAME_FISHING:
            result = sgInitFishing(&GameInfo);
            break;
        case SUBGAME_GYORACE:
            result = sgInitGyoRace(&GameInfo);
            break;
        case SUBGAME_BUGGY:
            result = sgInitBuggy(&GameInfo);
            break;
        case SUBGAME_UNUSED:
            break;
    }

    if (result == 0) {
        SubGame = SUBGAME_NONE;
    }

    return result;
}

int sgLoopSubGame() {
    int finished;

    if (SubGameRunning() == 0) {
        return 0;
    }

    finished = 0;

    switch (SubGame) {
        case SUBGAME_FISHING:
            finished = sgLoopFishing(&GameInfo);
            break;
        case SUBGAME_GYORACE:
            finished = sgLoopGyoRace(&GameInfo);
            break;
        case SUBGAME_BUGGY:
            finished = sgLoopBuggy(&GameInfo);
            break;
        case SUBGAME_UNUSED:
            finished = 1;
            break;
    }

    if (finished != 0) {
        SubGame = SUBGAME_NONE;
    }

    return 0;
}

int sgLoopSubGame2() {
    if (SubGameRunning() == 0) {
        return 0;
    }

    switch (SubGame) {
        case SUBGAME_FISHING:
            sgLoopFishing2(&GameInfo);
            break;
        case SUBGAME_GYORACE:
        case SUBGAME_BUGGY:
        case SUBGAME_UNUSED:
            break;
    }

    return 0;
}

int sgExitSubGame() {
    int result = 0;

    if (SubGameRunning() == 0) {
        return 0;
    }

    switch (SubGame) {
        case SUBGAME_FISHING:
            result = sgExitFishing(&GameInfo);
            break;
        case SUBGAME_GYORACE:
        case SUBGAME_BUGGY:
        case SUBGAME_UNUSED:
            break;
    }

    SubGame = SUBGAME_NONE;
    return result;
}

int sgRestartSubGame(SubGameInfo *info) {
    int result = 0;

    if (SubGameRunning() == 0) {
        return 0;
    }

    switch (SubGame) {
        case SUBGAME_FISHING:
            result = sgRestartFishing(info);
            break;
        case SUBGAME_GYORACE:
        case SUBGAME_BUGGY:
        case SUBGAME_UNUSED:
            break;
    }

    return result;
}

int sgBreakSubGame() {
    int result = 0;

    if (SubGameRunning() == 0) {
        return 0;
    }

    switch (SubGame) {
        case SUBGAME_FISHING:
            result = sgBreakFishing();
            break;
        case SUBGAME_GYORACE:
        case SUBGAME_BUGGY:
        case SUBGAME_UNUSED:
            break;
    }

    SubGame = SUBGAME_NONE;
    return result;
}

int sgDrawSubGameMap() {
    if (SubGameRunning() == 0) {
        return 0;
    }

    if (SubGame != SUBGAME_GYORACE) {
        return 0;
    }

    return sgMapDrawGyoRace(&GameInfo);
}

int sgDrawSubGameCharaShadow() {
    if (SubGameRunning() == 0) {
        return 0;
    }

    switch (SubGame) {
        case SUBGAME_FISHING:
        case SUBGAME_GYORACE:
            break;
        case SUBGAME_BUGGY:
            return sgDrawShadowBuggy(&GameInfo);
        case SUBGAME_UNUSED:
            break;
    }

    return 0;
}

int sgDrawSubGameChara() {
    if (SubGameRunning() == 0) {
        return 0;
    }

    switch (SubGame) {
        case SUBGAME_FISHING:
            return sgDrawFishing(&GameInfo);
        case SUBGAME_GYORACE:
            return sgCharaDrawGyoRace(&GameInfo);
        case SUBGAME_BUGGY:
            return sgDrawBuggy(&GameInfo);
        default:
        case SUBGAME_UNUSED:
            return 0;
    }
}

int sgDrawSubGameEffect() {
    if (SubGameRunning() == 0) {
        return 0;
    }

    switch (SubGame) {
        case SUBGAME_GYORACE:
            return sgEffectDrawGyoRace(&GameInfo);
        case SUBGAME_BUGGY:
            return sgEffectDrawBuggy(&GameInfo);
        default:
            return 0;
    }
}

int sgDrawSubGameSystem() {
    if (SubGameRunning() == 0) {
        return 0;
    }

    switch (SubGame) {
        case SUBGAME_FISHING:
            return sgSystemDrawFishing(&GameInfo);
        case SUBGAME_GYORACE:
            return sgSysDrawGyoRace(&GameInfo);
        case SUBGAME_BUGGY:
            return sgSystemDrawBuggy(&GameInfo);
        default:
        case SUBGAME_UNUSED:
            return 0;
    }
}

void sgCPlayVoice::Open(int file) {
    if (step > SG_PLAY_VOICE_IDLE) {
        Close();
    }

    step = SG_PLAY_VOICE_OPEN;
    file_no = file;
    play = 0;
}

void sgCPlayVoice::SetVol(float left, float right) {
    float left_volume = left;
    float right_volume = right;

    if (left_volume < 0.0f) {
        left_volume = 0.0f;
    }

    if (!(left_volume <= 1.0f)) {
        left_volume = 1.0f;
    }

    vol_l = left_volume;

    if (right_volume < 0.0f) {
        right_volume = left_volume;
    }

    if (!(right_volume <= 1.0f)) {
        right_volume = 1.0f;
    }

    vol_r = right_volume;
}

void sgCPlayVoice::Play() {
    play = 1;
}

int sgCPlayVoice::Step() {
    char name[0x80];

    if (step <= 0) {
        return 0;
    }

    switch (step) {
        case 1:
            sprintf(name, "%d.wav", file_no);
            sndStreamOpenFast(name);
            step++;
            break;
        case 2:
            if (sndStreamOpenState() == 0) {
                sndStreamStandBy();
                step++;
            }

            break;
        case 3:
            if (sndStreamOpenState() == 0) {
                step++;
            }

            break;
        case 4:
            if (play != 0) {
                sndStreamSetVol(vol_l, vol_r);
                sndStreamPlay();
                step++;
            }

            break;
        case 5:
            if (sndStreamGetState() != 0x1000) {
                sndStreamClose();
                step = 0;
                return 0;
            }

            break;
    }

    return 1;
}

void sgCPlayVoice::Close() {
    if (step > 0) {
        sndStreamClose();
        step = 0;
    }
}
