#include "test_hooks.hpp"

#include <charconv>
#include <cstdio>
#include <cstdlib>
#include <optional>
#include <sstream>
#include <string>
#include <vector>

#include "gamedata.hpp"
#include "main.hpp"
#include "mapselect.hpp"
#include "platform/config.hpp"
#include "platform/input.hpp"
#include "platform/vfs.hpp"
#include "savedata.hpp"
#include "title.hpp"
#include "userdata.hpp"

extern unsigned char PortGameBootInit asm("Title_GameBootInit");

namespace {
std::optional<GameJump> target;
std::vector<int>        gifts;
bool                    fast_load = false;

bool Number(std::string_view text, int &value, int maximum) {
    if (text.empty()) {
        return false;
    }
    auto [end, error] = std::from_chars(text.data(), text.data() + text.size(), value);
    return error == std::errc{} && end == text.data() + text.size() && value >= 0 && value <= maximum;
}

[[noreturn]] void BadTarget() {
    std::fprintf(stderr, "bad --jump: target is absent from the game tables\n");
    std::exit(2);
}

bool ResolveEvent(int event, int &mode, INIT_LOOP_ARG &arg) {
    std::vector<std::uint8_t> bytes;
    vfs::Read(vfs::Find(vfs::Base(), "event/view_pal.txt"), bytes);
    std::istringstream file(std::string(bytes.begin(), bytes.end()));
    std::string   line;
    while (std::getline(file, line)) {
        std::vector<std::string_view> columns;
        std::string_view              rest = line;
        for (;;) {
            auto tab = rest.find('\t');
            columns.push_back(rest.substr(0, tab));
            if (tab == rest.npos) {
                break;
            }
            rest.remove_prefix(tab + 1);
        }
        int id = 0;
        if (columns.size() < 4 || !Number(columns[3], id, 2147483647) || id != event) {
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
    auto     arg = colon == text.npos ? std::string_view{} : text.substr(colon + 1);
    if (name == "town" || name == "edit") {
        parsed.mode = JumpMode::Town;
        if (colon != text.npos && !Number(arg, parsed.map, 188)) {
            return false;
        }
    } else if (name == "dungeon") {
        parsed.mode = JumpMode::Dungeon;
        parsed.map = 0;
        auto floor = arg.find(':');
        if (colon != text.npos && !Number(arg.substr(0, floor), parsed.map, 6)) {
            return false;
        }
        if (floor != arg.npos && (!Number(arg.substr(floor + 1), parsed.floor, 99) || parsed.floor == 0)) {
            return false;
        }
        CSaveDataDungeon floors;
        if (!floors.GetFloorInfoPtr(parsed.map, parsed.floor)) {
            return false;
        }
    } else if (name == "event") {
        parsed.mode = JumpMode::Event;
        if (colon == text.npos || !Number(arg, parsed.event, 2147483647) || parsed.event == 0) {
            return false;
        }
    } else {
        if (colon != text.npos) {
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
    do {
        auto comma = text.find(',');
        int  item = 0;
        if (!Number(text.substr(0, comma), item, 32767) || item == 0) {
            return false;
        }
        parsed.push_back(item);
        if (comma == text.npos) {
            break;
        }
        text.remove_prefix(comma + 1);
    } while (true);
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

void GamePrepareJump(int &mode, INIT_LOOP_ARG &arg) {
    for (int item : gifts) {
        if (!GetCommonItemData(item)) {
            std::fprintf(stderr, "bad --give: unknown item %d\n", item);
            std::exit(2);
        }
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
        case JumpMode::Dungeon:
            LoadGameConfig(dungeon_config);
            mode = LOOP_DUNGEON;
            arg.map_no = jump.map;
            arg.floor_no = jump.floor;
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
        if (GetCommonItemData(item) == nullptr) {
            std::fprintf(stderr, "bad --give: unknown item %d\n", item);
            std::exit(2);
        }
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
    bool           pressed = held && !held_before;
    // A partial release must not re-arm a chord carried across a mode change.
    if ((buttons & chord) == 0) {
        held_before = false;
    } else if (held) {
        held_before = true;
    }
    return pressed && GameDebugEnabled() && mode != LOOP_MENU;
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
