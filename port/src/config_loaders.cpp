// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <algorithm>
#include <array>
#include <cstring>
#include <optional>
#include <stdexcept>
#include <string>
#include <vector>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "editdata.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "menuchr.hpp"
#include "savedata.hpp"
#include "savedatadungeon.hpp"
#include "userdata.hpp"

/** Debug menu row values of mainloop.cpp; MAP_NO sets the editor row. */
extern int SelectArg[32] asm("MainLoop_SelectArg");

namespace {

/**
 * Save-state action of one game setup command.
 */
enum class SetupAction {
    Map,             /**< MAP_NO: the map the debug menu starts the editor in. */
    Progress,        /**< PROGRESS: the story progress. */
    BitFlagsOn,      /**< BIT_FLAG_ON: sets save bit flags. */
    BitFlagsOff,     /**< BIT_FLAG_OFF: clears save bit flags. */
    StartEvent,      /**< START_EVENT: the event debug maps start with. */
    GeoramaComplete, /**< GEO_COMPLETE: lifts georama conditions and opens each listed town's conditions. */
    GeoramaDebug,    /**< GEO_DEBUG: lifts georama placement conditions. */
    ItemSet,         /**< ITEM_SET: gives a debug item set. */
    GetItems,        /**< GET_ITEM: gives one of each listed item. */
    GetItemsCounted, /**< GET_N_ITEM: gives items in given quantities. */
    Equip,           /**< EQUIP: equips an item on a character. */
    Defense,         /**< DEFENSE or DEFENCE: sets a character's defence. */
    Hp,              /**< HP: sets a character's hit points. */
    AllGeoramaParts, /**< ALL_GEO_PARTS: unlocks geostones and town conditions and grants materials. */
    ParamDraw,       /**< PARAM_DRAW: shows or hides the parameter display. */
    Option,          /**< OPTION: sets a named game option. */
    Monica,          /**< MONICA: adds Monica to the party. */
    Steve,           /**< STEVE: adds the ridepod and its core. */
    Monsters,        /**< MONSTER: adds monster transformation and its badges. */
    Party,           /**< PARTY: adds a townsperson to the party. */
    ActiveChara      /**< ACTIVE_CHARA: selects the active character. */
};

/**
 * Operand shape a game setup action keeps in its document.
 */
enum class SetupShape {
    None,     /**< No operands. */
    Map,      /**< A raw-typed map. */
    One,      /**< One integer field. */
    Two,      /**< Two integer fields. */
    Optional, /**< One optional integer field. */
    List,     /**< One integer list field. */
    Counted,  /**< Item and count pairs. */
    Option    /**< An option name and value. */
};

/**
 * Document name, action and fields of one game setup action.
 */
struct SetupKind {
    const char *name;   /**< Document action name. */
    SetupAction action; /**< Action performed. */
    SetupShape  shape;  /**< Operands kept. */
    const char *first;  /**< First field name, when the shape has one. */
    const char *second; /**< Second field name, when the shape has two. */
};

/**
 * Every action a game_setup document may hold.
 */
constexpr std::array kSetupKinds{
    SetupKind{.name = "map",               .action = SetupAction::Map,             .shape = SetupShape::Map,      .first = "map",   .second = nullptr},
    SetupKind{.name = "progress",          .action = SetupAction::Progress,        .shape = SetupShape::One,      .first = "value", .second = nullptr},
    SetupKind{.name = "bit_flags_on",      .action = SetupAction::BitFlagsOn,      .shape = SetupShape::List,     .first = "flags", .second = nullptr},
    SetupKind{.name = "bit_flags_off",     .action = SetupAction::BitFlagsOff,     .shape = SetupShape::List,     .first = "flags", .second = nullptr},
    SetupKind{.name = "start_event",       .action = SetupAction::StartEvent,      .shape = SetupShape::One,      .first = "event", .second = nullptr},
    SetupKind{.name = "georama_complete",  .action = SetupAction::GeoramaComplete, .shape = SetupShape::List,     .first = "towns", .second = nullptr},
    SetupKind{.name = "georama_debug",     .action = SetupAction::GeoramaDebug,    .shape = SetupShape::None,     .first = nullptr, .second = nullptr},
    SetupKind{.name = "item_set",          .action = SetupAction::ItemSet,         .shape = SetupShape::One,      .first = "set",   .second = nullptr},
    SetupKind{.name = "get_items",         .action = SetupAction::GetItems,        .shape = SetupShape::List,     .first = "items", .second = nullptr},
    SetupKind{.name = "get_items_counted", .action = SetupAction::GetItemsCounted, .shape = SetupShape::Counted,  .first = "items", .second = nullptr},
    SetupKind{.name = "equip",             .action = SetupAction::Equip,           .shape = SetupShape::Two,      .first = "chara", .second = "item" },
    SetupKind{.name = "defense",           .action = SetupAction::Defense,         .shape = SetupShape::Two,      .first = "chara", .second = "value"},
    SetupKind{.name = "defence",           .action = SetupAction::Defense,         .shape = SetupShape::Two,      .first = "chara", .second = "value"},
    SetupKind{.name = "hp",                .action = SetupAction::Hp,              .shape = SetupShape::Two,      .first = "chara", .second = "value"},
    SetupKind{.name = "all_georama_parts", .action = SetupAction::AllGeoramaParts, .shape = SetupShape::Optional, .first = "mode",  .second = nullptr},
    SetupKind{.name = "param_draw",        .action = SetupAction::ParamDraw,       .shape = SetupShape::One,      .first = "show",  .second = nullptr},
    SetupKind{.name = "option",            .action = SetupAction::Option,          .shape = SetupShape::Option,   .first = "name",  .second = "value"},
    SetupKind{.name = "monica",            .action = SetupAction::Monica,          .shape = SetupShape::None,     .first = nullptr, .second = nullptr},
    SetupKind{.name = "steve",             .action = SetupAction::Steve,           .shape = SetupShape::Optional, .first = "core",  .second = nullptr},
    SetupKind{.name = "monsters",          .action = SetupAction::Monsters,        .shape = SetupShape::List,     .first = "ids",   .second = nullptr},
    SetupKind{.name = "party",             .action = SetupAction::Party,           .shape = SetupShape::One,      .first = "chara", .second = nullptr},
    SetupKind{.name = "active_chara",      .action = SetupAction::ActiveChara,     .shape = SetupShape::One,      .first = "chara", .second = nullptr},
};

/**
 * One typed game setup action.
 */
struct GameSetupStep {
    SetupAction                      action;     /**< Action performed. */
    native_config::RawValue          map;        /**< Map, by name or number, of a map action. */
    int                              first = 0;  /**< First integer operand. */
    int                              second = 0; /**< Second integer operand. */
    std::optional<int>               optional;   /**< Optional operand: the parts mode or the ridepod core. */
    std::vector<int>                 values;     /**< Integer list of a list action. */
    std::vector<std::array<int, 2> > counted;    /**< Item and count pairs. */
    std::optional<std::string>       name;       /**< CP932 option name, or none when it was not text. */
};

/**
 * Parses a game_setup document into its ordered actions.
 */
std::vector<GameSetupStep> ParseGameSetup(const native_config::Json &document) {
    using namespace native_config;
    std::vector<GameSetupStep> steps;
    for (const auto &entry : Array(document, "actions")) {
        const auto name = Text(entry, "action");
        const auto *const kind = std::ranges::find_if(kSetupKinds, [&](const SetupKind &item) { return name == item.name; });
        if (kind == kSetupKinds.end()) {
            throw std::runtime_error("unknown game setup action " + name);
        }
        GameSetupStep step{.action = kind->action, .map = {}, .first = 0, .second = 0, .optional = std::nullopt, .values = {}, .counted = {}, .name = std::nullopt};
        switch (kind->shape) {
            case SetupShape::None:
                break;
            case SetupShape::Map:
                step.map = Raw(At(entry, kind->first));
                break;
            case SetupShape::One:
                step.first = Int(entry, kind->first);
                break;
            case SetupShape::Two:
                step.first = Int(entry, kind->first);
                step.second = Int(entry, kind->second);
                break;
            case SetupShape::Optional:
                step.optional = OptionalInt(entry, kind->first);
                break;
            case SetupShape::List:
                step.values = IntList(entry, kind->first);
                break;
            case SetupShape::Counted:
                for (const auto &item : Array(entry, kind->first)) {
                    step.counted.push_back({Int(item, "item"), Int(item, "count")});
                }
                break;
            case SetupShape::Option:
                step.name = OptionalText(entry, kind->first);
                step.first = Int(entry, kind->second);
                break;
        }
        steps.push_back(std::move(step));
    }
    return steps;
}

/**
 * Gives the map number a map action names, as gcMAP_NO reads its operand.
 */
int MapNumber(const native_config::RawValue &map) {
    switch (map.type) {
        case native_config::RawValue::Type::String: {
            std::string name = map.text;
            return SearchMapNo(name.data());
        }
        case native_config::RawValue::Type::Int:
            return map.integer;
        case native_config::RawValue::Type::Float:
            return static_cast<int>(map.real);
        case native_config::RawValue::Type::Invalid:
            break;
    }
    return 0;
}

/**
 * Unlocks every geostone and town condition and grants georama materials, as gcALL_GEO_PARTS does.
 */
void AllGeoramaParts(int mode) {
    CSaveDataDungeon *dungeon = &GetSaveData()->save_dungeon;
    for (int stage = 0; stage < SAVE_DUNGEON_NUM; ++stage) {
        for (int floor_no = 0; floor_no < 40; ++floor_no) {
            if (DNG_FLOOR_SAVE *floor = dungeon->GetFloorInfoPtr(stage, floor_no)) {
                floor->flag |= DNG_FLOOR_FLAG_GEOSTONE_FOUND | DNG_FLOOR_FLAG_GEOSTONE_READ;
            }
        }
    }
    for (int town = 0; town < SAVE_EDIT_DATA_MAX; ++town) {
        if (CEditData *edit = GetSaveData()->GetEditData(town)) {
            for (auto &open : edit->analyze.data_open) {
                open = true;
            }
            for (auto &open : edit->analyze.condition_open) {
                open = true;
            }
        }
    }
    if (mode == 0) {
        for (int index = 0; index < 999; ++index) {
            GetSaveData()->SetBuildPartsNum(index, 30);
        }
    }
    if (mode == 1) {
        for (int item_no = 210; item_no < 245; ++item_no) {
            GetSaveData()->GetItem(item_no, 99);
        }
    }
}

/**
 * Sets one named game option, as gcOPTION does.
 */
void SetOption(const std::optional<std::string> &name, int value) {
    if (!name) {
        return;
    }
    SV_CONFIG_OPTION *options = &GetSaveData()->config;
    if (*name == "MonsterName") {
        options->monster_name = value;
    } else if (*name == "Map") {
        options->map = value;
    } else if (*name == "EnemyHP") {
        options->enemy_hp = value;
    } else if (*name == "AngerCounter") {
        options->anger_counter = value;
    }
}

/**
 * Adds monster transformation and enables each listed monster's badge, as gcMONSTER does.
 */
void AddMonsters(const std::vector<int> &ids) {
    CUserDataManager *manager = GetUserDataMan();
    if (manager == nullptr) {
        return;
    }
    manager->JoinPartyMember(USER_CHARA_MONSTER);
    manager->GetItemNotOver(ITEM_ID_BADGE_BOX, 1);
    for (const int monster_id : ids) {
        int       class_level = 0;
        const int badge_no = get_gajji_id_from_monster_progress_table(monster_id, &class_level) + 1;
        manager->monster_box.EnableChange(badge_no);
        if (MOS_CHANGE_PARAM *badge = manager->monster_box.GetMonsterBajjiData(badge_no)) {
            badge->class_level = class_level;
            badge->monster_id = monster_id;
            badge->progress = GetMonsterProgressTableNo(class_level, monster_id);
        }
        manager->monster_id = monster_id;
    }
}

/**
 * Performs one game setup action with the effects of its retail tag callback.
 */
void Perform(const GameSetupStep &step) {
    switch (step.action) {
        case SetupAction::Map:
            SelectArg[LOOP_EDIT] = MapNumber(step.map);
            break;
        case SetupAction::Progress:
            GetSaveData()->game_progress = step.first;
            break;
        case SetupAction::BitFlagsOn:
        case SetupAction::BitFlagsOff:
            for (const int flag : step.values) {
                GetSaveData()->SetBitFlag(flag, step.action == SetupAction::BitFlagsOn);
            }
            break;
        case SetupAction::StartEvent:
            DefStartEventNo = step.first;
            break;
        case SetupAction::GeoramaComplete:
            DebugInfo.georama_debug = true;
            for (const int index : step.values) {
                if (CEditData *edit_data = GetSaveData()->GetEditData(index)) {
                    edit_data->dbgSetAllContintionFlag(index, 1);
                }
            }
            break;
        case SetupAction::GeoramaDebug:
            DebugInfo.georama_debug = true;
            break;
        case SetupAction::ItemSet:
            DebugGetItem(&GetSaveData()->user_data, step.first);
            break;
        case SetupAction::GetItems:
            for (const int item_no : step.values) {
                GetSaveData()->user_data.GetItem(item_no, 1);
            }
            break;
        case SetupAction::GetItemsCounted:
            for (const auto &[item_no, count] : step.counted) {
                GetSaveData()->user_data.GetItem(item_no, count);
            }
            break;
        case SetupAction::Equip:
            GetSaveData()->user_data.SetChrEquip(step.first, step.second);
            break;
        case SetupAction::Defense:
            if (CHARA_DATA *chara = GetSaveData()->user_data.GetCharaDataPtr(step.first)) {
                chara->defence = step.second;
            }
            break;
        case SetupAction::Hp:
            if (CHARA_DATA *chara = GetSaveData()->user_data.GetCharaDataPtr(step.first)) {
                chara->hp.max = step.second;
                chara->hp.now = step.second;
            }
            break;
        case SetupAction::AllGeoramaParts:
            AllGeoramaParts(step.optional.value_or(0));
            break;
        case SetupAction::ParamDraw:
            DebugInfo.param_off = step.first == 0;
            break;
        case SetupAction::Option:
            SetOption(step.name, step.first);
            break;
        case SetupAction::Monica:
            if (CUserDataManager *manager = GetUserDataMan()) {
                manager->JoinPartyMember(USER_CHARA_MONICA);
            }
            break;
        case SetupAction::Steve:
            if (CUserDataManager *manager = GetUserDataMan()) {
                manager->JoinPartyMember(USER_CHARA_ROBO);
                manager->GetItemNotOver(ITEM_ID_CORE, 1);
                // Retail swaps the core only when STEVE had exactly two operands, which the core marks.
                if (step.optional) {
                    manager->DeleteItem(ITEM_ID_CORE, 1);
                    manager->GetItemNotOver(GetRidePodCore(*step.optional), 1);
                }
            }
            break;
        case SetupAction::Monsters:
            AddMonsters(step.values);
            break;
        case SetupAction::Party:
            if (step.first > 0 && step.first <= 0x1A) {
                if (CUserDataManager *manager = GetUserDataMan()) {
                    manager->JoinPartyChara(step.first, PARTY_CHARA_STATUS_JOIN, 1);
                    manager->SetPartyCharaStatus(step.first, PARTY_CHARA_STATUS_IN_PARTY);
                }
            }
            break;
        case SetupAction::ActiveChara: {
            int chara_no = step.first;
            chara_no = std::max<int>(chara_no, USER_CHARA_MAX);
            chara_no = std::min<int>(chara_no, USER_CHARA_MONICA);
            if (CUserDataManager *manager = GetUserDataMan()) {
                manager->SetActiveChrNo(chara_no);
            }
            break;
        }
    }
}

/**
 * Reads a game setup document and performs its actions in order.
 */
void RunGameSetup(const char *game_name) {
    if (const auto steps = native_config::ReadGame<std::vector<GameSetupStep> >(game_name, "game_setup", ParseGameSetup)) {
        for (const auto &step : *steps) {
            Perform(step);
        }
    }
}

} // namespace

// The retail signature takes a mutable path.
// NOLINTNEXTLINE(readability-non-const-parameter)
PORT_OVERRIDE void LoadGameConfig(char *path) {
    if (path == nullptr) {
        SetCurrentDir(nullptr);
    }
    // The root game.cfg is optional; only a named configuration reports a missing document.
    if (path != nullptr || DataReadAssetPath("game.cfg.json")) {
        RunGameSetup(path != nullptr ? path : "game.cfg.json");
    }
    if (path == nullptr) {
        SetCurrentDir(nullptr);
    }
}
