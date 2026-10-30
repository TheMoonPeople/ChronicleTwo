#include "test_hooks.hpp"

#include <algorithm>
#include <charconv>
#include <cstdio>
#include <cstdlib>
#include <limits>
#include <optional>
#include <sstream>
#include <string>
#include <vector>

#include "actionchara.hpp"
#include "dng_main.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "gamedata.hpp"
#include "log/log.hpp"
#include "main.hpp"
#include "mapselect.hpp"
#include "options/screen.hpp"
#include "platform/config.hpp"
#include "platform/input.hpp"
#include "platform/vfs.hpp"
#include "savedata.hpp"
#include "title.hpp"
#include "userdata.hpp"

extern unsigned char PortGameBootInit asm("Title_GameBootInit");

namespace {
std::optional<GameJump>      target;
std::vector<int>             gifts;
bool                         fast_load = false;
bool                         skip_events = false;
bool                         invincible = false;
std::optional<std::uint32_t> seed;

// The dungeon script event that loads the selected floor without opening the floor list.
constexpr int kDungeonFloorLoadEvent = 1010;

constexpr int kNoLimit = std::numeric_limits<int>::max();

bool Number(std::string_view text, int &value, int maximum) {
    if (text.empty()) {
        return false;
    }
    auto [end, error] = std::from_chars(text.data(), text.data() + text.size(), value);
    return error == std::errc{} && end == text.data() + text.size() && value >= 0 && value <= maximum;
}

[[noreturn]] void BadTarget() {
    CT_LOG_ERROR(Main, "bad --jump: target is absent from the game tables");
    LogFlush();
    std::exit(2);
}

void RequireKnownItem(int item) {
    if (GetCommonItemData(item) == nullptr) {
        CT_LOG_ERROR(Main, "bad --give: unknown item {}", item);
        LogFlush();
        std::exit(2);
    }
}

bool ResolveEvent(int event, int &mode, INIT_LOOP_ARG &arg) {
    std::vector<std::uint8_t> bytes;
    vfs::Read(vfs::Find(vfs::Base(), "event/view_pal.txt"), bytes);
    std::istringstream file(std::string(bytes.begin(), bytes.end()));
    std::string        line;
    while (std::getline(file, line)) {
        std::vector<std::string_view> columns;
        std::string_view              rest = line;
        for (;;) {
            auto tab = rest.find('\t');
            columns.push_back(rest.substr(0, tab));
            if (tab == std::string_view::npos) {
                break;
            }
            rest.remove_prefix(tab + 1);
        }
        int id = 0;
        if (columns.size() < 4 || !Number(columns[3], id, kNoLimit) || id != event) {
            continue;
        }
        arg.event_no = id;
        mode = LOOP_EDIT;
        if (!columns[1].empty()) {
            int dungeon = 0;
            if (!Number(columns[1], dungeon, 7) || dungeon == 0 || !Number(columns[2], arg.floor_no, 99)) {
                return false;
            }
            arg.map_no = dungeon - 1;
            mode = LOOP_DUNGEON;
        } else {
            std::string name(columns[0]);
            arg.map_no = SearchMapNo(name.data());
        }
        return arg.map_no >= 0;
    }
    return false;
}
} // namespace

bool GameParseJump(std::string_view text, GameJump &jump) {
    GameJump parsed;
    auto     colon = text.find(':');
    auto     name = text.substr(0, colon);
    auto     arg = colon == std::string_view::npos ? std::string_view{} : text.substr(colon + 1);
    if (name == "town" || name == "edit") {
        parsed.mode = JumpMode::Town;
        if (colon != std::string_view::npos && !Number(arg, parsed.map, 188)) {
            return false;
        }
    } else if (name == "georama") {
        // The developer menu's "diorama map" row: the Georama towns are maps 0 to 4.
        parsed.mode = JumpMode::Georama;
        parsed.map = 0;
        if (colon != std::string_view::npos && !Number(arg, parsed.map, 4)) {
            return false;
        }
    } else if (name == "dungeon") {
        parsed.mode = JumpMode::Dungeon;
        parsed.map = 0;
        auto floor = arg.find(':');
        if (colon != std::string_view::npos && !Number(arg.substr(0, floor), parsed.map, 6)) {
            return false;
        }
        if (floor != std::string_view::npos && (!Number(arg.substr(floor + 1), parsed.floor, 99) || parsed.floor == 0)) {
            return false;
        }
        CSaveDataDungeon floors{};
        if (!floors.GetFloorInfoPtr(parsed.map, parsed.floor)) {
            return false;
        }
    } else if (name == "event") {
        parsed.mode = JumpMode::Event;
        if (colon == std::string_view::npos || !Number(arg, parsed.event, kNoLimit) || parsed.event == 0) {
            return false;
        }
    } else {
        if (colon != std::string_view::npos) {
            return false;
        }
        if (name == "title") {
            parsed.mode = JumpMode::Title;
        } else if (name == "opening") {
            parsed.mode = JumpMode::Opening;
        } else if (name == "menu") {
            parsed.mode = JumpMode::Menu;
        } else {
            return false;
        }
    }
    jump = parsed;
    return true;
}

bool GameParseGive(std::string_view text, std::vector<int> &items) {
    std::vector<int> parsed;
    for (;;) {
        auto comma = text.find(',');
        int  item = 0;
        if (!Number(text.substr(0, comma), item, 32767) || item == 0) {
            return false;
        }
        parsed.push_back(item);
        if (comma == std::string_view::npos) {
            break;
        }
        text.remove_prefix(comma + 1);
    }
    items = std::move(parsed);
    return true;
}

bool GameSetJump(std::string_view text) {
    GameJump parsed;
    if (!GameParseJump(text, parsed)) {
        return false;
    }
    target = parsed;
    return true;
}

bool GameSetGive(std::string_view text) { return GameParseGive(text, gifts); }

bool GameHasJump() { return target.has_value(); }

bool GameDebugEnabled() { return ConfigGet().debug_mode || GameHasJump(); }

void GameSetFastLoad(bool fast) { fast_load = fast; }

bool GameFastLoad() { return fast_load; }

void GameSetSkipEvents(bool skip) { skip_events = skip; }

bool GameSkipEvents() { return skip_events; }

void GameSetInvincible(bool value) { invincible = value; }

bool GameInvincible() { return invincible; }

void GameSetSeed(std::optional<std::uint32_t> value) { seed = value; }

std::optional<std::uint32_t> GameSeed() { return seed; }

void GameDebugFrame(int mode) {
    if (mode != LOOP_DUNGEON) {
        return;
    }
    if (invincible && MainChara__2 != nullptr) {
        // Keeps the hit check's invulnerability window open, so no hit lands or knocks the character back.
        MainChara__2->muteki_time = std::max(MainChara__2->muteki_time, 2);
    }
    if (skip_events && DngStatus.mode == DNG_STATUS_EVENT && EdEventInfo.skip_state == EVENT_SKIP_ENABLED) {
        SkipEventStart();
    }
}

void GamePrepareJump(int &mode, INIT_LOOP_ARG &arg) {
    for (int item : gifts) {
        RequireKnownItem(item);
    }
    if (!target) {
        return;
    }
    InitSaveData();
    auto jump = *target;
    arg = INIT_LOOP_ARG{};
    DebugFlag = 1;
    PortGameBootInit = 1;
    char town_config[] = "dbg/pb.cfg.json";
    char dungeon_config[] = "dbg/cap1.cfg.json";
    switch (jump.mode) {
        case JumpMode::Menu:
            mode = LOOP_MENU;
            break;
        case JumpMode::Title:
            mode = LOOP_TITLE;
            break;
        case JumpMode::Town:
            if (GetMapName(jump.map, nullptr) == nullptr || GetMapType(jump.map) < 0) {
                BadTarget();
            }
            LoadGameConfig(town_config);
            mode = LOOP_EDIT;
            arg.map_no = jump.map;
            arg.event_no = 100;
            break;
        case JumpMode::Georama: {
            char georama_config[] = "dbg/geo.cfg.json";
            LoadGameConfig(georama_config);
            mode = LOOP_EDIT;
            arg.map_no = jump.map;
            break;
        }
        case JumpMode::Dungeon:
            LoadGameConfig(dungeon_config);
            mode = LOOP_DUNGEON;
            arg.map_no = jump.map;
            arg.floor_no = jump.floor;
            if (skip_events) {
                arg.event_no = kDungeonFloorLoadEvent;
            }
            break;
        case JumpMode::Opening: {
            DebugGetItem(&GetSaveData()->user_data, 1);
            auto &user = GetSaveData()->user_data;
            user.LeavePartyMember(USER_CHARA_MAX);
            user.JoinPartyMember(USER_CHARA_MONICA);
            user.EnableCharaChange(USER_CHARA_MONICA);
            user.SetActiveChrNo(USER_CHARA_MONICA);
            mode = LOOP_DUNGEON;
            arg.map_no = 0;
            arg.floor_no = 20;
            arg.event_no = 1010;
            break;
        }
        case JumpMode::Event:
            DebugGetItem(&GetSaveData()->user_data, 0);
            if (!ResolveEvent(jump.event, mode, arg)) {
                BadTarget();
            }
            break;
    }
}

void GameGiveOnArrival(int mode) {
    if (mode != LOOP_EDIT && mode != LOOP_DUNGEON) {
        return;
    }
    auto &user = GetSaveData()->user_data;
    for (int item : gifts) {
        RequireKnownItem(item);
        if (user.SearchAllHaveItem(item) == nullptr) {
            user.GetItem(item, 1);
        }
    }
}

bool GameDeveloperMenuRequested(int mode) {
    static bool    held_before = false;
    constexpr auto chord = kInputStart | kInputSelect;
    const auto     buttons = InputGetPad(0).buttons;
    bool           held = (buttons & chord) == chord;
    // The debug_menu binding (F1 by default) stands in for the chord on a keyboard; its press is
    // consumed whether or not debug controls are enabled, so it cannot fire later.
    bool key = false;
    while (InputHostPressed(InputHostAction::DebugMenu)) {
        key = true;
    }
    bool pressed = (held && !held_before) || key;
    // A partial release must not re-arm a chord carried across a mode change.
    if ((buttons & chord) == 0) {
        held_before = false;
    } else if (held) {
        held_before = true;
    }
    return pressed && GameDebugEnabled() && mode != LOOP_MENU && !options::Capturing();
}

bool GameDebugPauseRequested(CGamePad &pad) {
    constexpr int modifier = PAD_L2 | PAD_SELECT;
    const bool    chord = GameDebugEnabled() && !pad.key_lock &&
                          (pad.pad[0].button & modifier) == modifier &&
                          !(pad.previous_pad[0].button & PAD_SELECT);
    return chord || pad.Down2(PAD_SELECT);
}

bool GameDebugPauseResumeRequested(CGamePad &pad) {
    constexpr int modifier = PAD_L2 | PAD_SELECT;
    const bool    single_debug = GameDebugEnabled() && (pad.pad[0].button & modifier) == modifier;
    const int     pad1_pressed = pad.pad[0].button & ~pad.previous_pad[0].button;
    return (!single_debug && !pad.key_lock && (pad1_pressed & PAD_START)) ||
           GameDebugPauseRequested(pad);
}
