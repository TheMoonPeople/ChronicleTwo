#pragma once

#include <cstdint>
#include <optional>
#include <string_view>
#include <vector>

#include "mainloop.hpp"

enum class JumpMode {
    Town,
    Georama,
    Dungeon,
    Event,
    Title,
    Opening,
    Menu
};

struct GameJump {
    JumpMode mode = JumpMode::Menu;
    int      map = 10;
    int      floor = 1;
    int      event = 0;
};

bool GameParseJump(std::string_view text, GameJump &jump);
bool GameParseGive(std::string_view text, std::vector<int> &items);
bool GameSetJump(std::string_view text);
bool GameSetGive(std::string_view text);
bool GameHasJump();
bool GameDebugEnabled();
void GameSetFastLoad(bool fast);
bool GameFastLoad();
void GameSetSkipEvents(bool skip);
bool GameSkipEvents();
void GameSetInvincible(bool invincible);
bool GameInvincible();
void GameDebugFrame(int mode);
void GamePrepareJump(int &mode, INIT_LOOP_ARG &arg);
void GameGiveOnArrival(int mode);
bool GameDeveloperMenuRequested(int mode);
bool GameDebugPauseRequested(CGamePad &pad);
bool GameDebugPauseResumeRequested(CGamePad &pad);

// Scene measurement: once the mode is under player control and warmed up, log one window a second, then exit.
void GameSetPerfSeconds(int seconds);
bool GamePerfEnabled();
// The game thread's work for one tick: its update and recording, then everything before its wait for the next tick.
void GamePerfTickTimes(double update_ms, double busy_ms);
void GamePerfStep(int mode);

void                         GameSetSeed(std::optional<std::uint32_t> seed);
std::optional<std::uint32_t> GameSeed();
