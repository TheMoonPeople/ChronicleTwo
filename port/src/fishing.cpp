// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <array>
#include <cstring>
#include <optional>
#include <string>
#include <type_traits>
#include <vector>

#include "fishing.hpp"
#include "fishing_rod.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "mg_memory.hpp"
#include "platform/config.hpp"
#include "quick_loadout.hpp"
#include "snd_mngr.hpp"
#include "stubs/fishing.hpp"
#include "subgame.hpp"
#include "userdata.hpp"

namespace {

/**
 * Number of shape parameters of a fishing place.
 */
constexpr std::size_t kAreaParams = std::extent_v<decltype(FISH_PLACE_MAP::area_param)>;

/**
 * Number of fish entries of a fishing place.
 */
constexpr int kPlaceFish = std::extent_v<decltype(FISH_PLACE_MAP::fish)>;

/**
 * Area of a fishing place.
 */
struct PlaceArea {
    int                            area_type; /**< Shape of the area. */
    std::optional<std::string>     name;      /**< Name of the place, CP932. */
    std::array<float, kAreaParams> params;    /**< Shape parameters. */
};

/**
 * One fish that can bite at a place.
 */
struct PlaceFish {
    int   fish;      /**< Index of the fish. */
    float rate;      /**< Weight of the fish. */
    float wait_bias; /**< Bite-wait bias. */
};

/**
 * One fishing place of a fishing_places document.
 */
struct PlaceMap {
    int                      map;       /**< Map holding the place. */
    std::optional<int>       exclusive; /**< Whether its fish replace the others, when given. */
    std::optional<PlaceArea> place;     /**< Area, when given. */
    std::vector<PlaceFish>   fish;      /**< Fish in script order. */
};

/**
 * Typed contents of a fishing_places document.
 */
struct FishingPlaces {
    int                   count; /**< Entries of the place table. */
    std::vector<PlaceMap> maps;  /**< Places in script order. */
};

/**
 * Parses a fishing_places document.
 */
FishingPlaces ParseFishingPlaces(const native_config::Json &document) {
    using namespace native_config;
    FishingPlaces places{.count = Int(document, "count"), .maps = {}};
    if (places.count < 0) {
        throw std::runtime_error("negative fishing place count");
    }
    for (const auto &map : Array(document, "maps")) {
        PlaceMap entry{.map = Int(map, "map"), .exclusive = OptionalInt(map, "exclusive"), .place = std::nullopt, .fish = {}};
        if (map.contains("place")) {
            const auto &place = At(map, "place");
            entry.place = PlaceArea{.area_type = Int(place, "area_type"), .name = OptionalText(place, "name"), .params = Floats<kAreaParams>(place, "params")};
        }
        for (const auto &fish : Array(map, "fish")) {
            entry.fish.push_back({.fish = Int(fish, "fish"), .rate = Float(fish, "rate"), .wait_bias = Float(fish, "wait_bias")});
        }
        places.maps.push_back(std::move(entry));
    }
    return places;
}

} // namespace

PORT_OVERRIDE void LoadFishPlaceData(char *script, int /*size*/, mgCMemory *stack) {
    FishPlaceMapNum = 0;
    FishPlaceMap = nullptr;
    const auto places = native_config::ReadBuffer<FishingPlaces>(script, "fishing_places", ParseFishingPlaces);
    if (!places) {
        return;
    }
    FishPlaceMapNum = places->count;
    const u_int bytes = static_cast<u_int>(FishPlaceMapNum) * sizeof(FISH_PLACE_MAP);
    const u_int blocks = (bytes & 0xF) != 0 ? (bytes >> 4) + 1 : bytes >> 4;
    FishPlaceMap = new (stack->Alloc(static_cast<int>(blocks + 2))) FISH_PLACE_MAP[FishPlaceMapNum];
    int filled = 0;
    for (const auto &entry : places->maps) {
        // FISH_MAP past the table leaves no current place, so the rest of the entry does nothing.
        if (filled >= FishPlaceMapNum || FishPlaceMap == nullptr) {
            continue;
        }
        FISH_PLACE_MAP *map = &FishPlaceMap[filled];
        std::memset(static_cast<void *>(map), 0, sizeof(FISH_PLACE_MAP));
        map->map_no = entry.map;
        if (entry.exclusive) {
            map->exclusive = *entry.exclusive;
        }
        if (entry.place) {
            map->area_type = entry.place->area_type >= 0 && entry.place->area_type < FISH_PLACE_AREA_COUNT ? entry.place->area_type : 0;
            if (entry.place->name && !entry.place->name->empty()) {
                std::string name = *entry.place->name;
                map->name = mgCopyString(name.data(), stack);
            }
            for (std::size_t index = 0; index < kAreaParams; ++index) {
                map->area_param[index] = entry.place->params[index];
            }
        }
        for (const auto &fish : entry.fish) {
            if (map->fish_num >= kPlaceFish) {
                continue;
            }
            FISH_PLACE *place = &map->fish[map->fish_num++];
            place->fish_no = fish.fish;
            place->rate = fish.rate;
            place->wait_bias = fish.wait_bias;
        }
        ++filled;
    }
}

// L3 and R3 while Max walks with a rod out (port/src/fishing_rod.hpp).

FishingRebait FishingRodRebait(CUserDataManager *user, int last_bait, FishingItemLookup lookup) {
    const int      rod = user->GetFishingRodNo();
    CGameDataUsed *bait = user->GetActiveEsa(rod);
    if (bait == nullptr) {
        return FISHING_REBAIT_NONE;
    }
    auto fits = [&](CGameDataUsed *item) {
        CDataCommon *common = item->item_no > 0 ? lookup(item->item_no) : nullptr;
        return common != nullptr &&
               (rod == ITEM_ID_LURE_ROD ? common->type == ITEM_DATA_LURE : (common->attribute & ITEM_ATTRIBUTE_BAIT) != 0);
    };
    CGameDataUsed *items = user->GetUsedDataPtr(0);
    const int      count = user->GetItemBoardMaxNum(ITEM_BOARD_MAIN);
    auto           find = [&](int item_no) -> CGameDataUsed * {
        for (int i = 0; i < count; ++i) {
            if (items[i].item_no == item_no && fits(&items[i])) {
                return &items[i];
            }
        }
        return nullptr;
    };
    if (bait->GetNum() > 0) {
        CGameDataUsed *more = find(bait->item_no);
        if (more == nullptr) {
            return FISHING_REBAIT_NONE;
        }
        const int before = bait->GetNum();
        const int moved = bait->AddNum(more->GetNum(), 0) - before;
        if (moved <= 0) {
            return FISHING_REBAIT_NONE;
        }
        more->AddNum(-moved, 1);
        return FISHING_REBAIT_TOP_UP;
    }
    CGameDataUsed *next = last_bait > 0 ? find(last_bait) : nullptr;
    for (int i = 0; next == nullptr && i < count; ++i) {
        if (fits(&items[i])) {
            next = &items[i];
        }
    }
    if (next == nullptr) {
        return FISHING_REBAIT_NONE;
    }
    bait->CopyGameData(next);
    next->Init();
    return FISHING_REBAIT_CHANGED;
}

bool FishingRodReloads(FishingRebait result, bool hook_empty, int bait_left) {
    return result == FISHING_REBAIT_CHANGED || (hook_empty && bait_left > 0);
}

CGameDataUsed *FishingRodFallbackWeapon(CUserDataManager *user, FishingItemLookup lookup) {
    CGameDataUsed *items = user->GetUsedDataPtr(0);
    const int      count = user->GetItemBoardMaxNum(ITEM_BOARD_MAIN);
    for (int i = 0; i < count; ++i) {
        CDataCommon *common = items[i].item_no > 0 ? lookup(items[i].item_no) : nullptr;
        if (common != nullptr && common->type == ITEM_DATA_MAX_MELEE) {
            return &items[i];
        }
    }
    return nullptr;
}

void ExitFishing(CScene *scene);

namespace {

int last_bait[2]; // the bait last seen on each rod: the Fishing Rod, the Lure Rod

int &LastBait(int rod) { return last_bait[rod == ITEM_ID_LURE_ROD ? 1 : 0]; }

// Puts Max's weapon back in place of the rod: the one it replaced, else his first melee weapon on the item board.
bool PutRodAway(CUserDataManager *user) {
    ReEquipFishingGameWeapon();
    if (!user->chara_data[USER_CHARA_MAX].equip[CHARA_EQUIP_MELEE].IsFishingRod()) {
        return true;
    }
    CGameDataUsed *weapon = FishingRodFallbackWeapon(user, GetCommonItemData);
    return weapon != nullptr && user->SetChrEquip(USER_CHARA_MAX, weapon) &&
           !user->chara_data[USER_CHARA_MAX].equip[CHARA_EQUIP_MELEE].IsFishingRod();
}

void PlaySe(int se) { sndSePlay(SystemSND_ID, se, 0); }

} // namespace

PORT_OVERRIDE int sgLoopFishing(SubGameInfo *info) {
    CUserDataManager *user = GetUserDataMan();
    const int         rod = user->GetFishingRodNo();
    if (CGameDataUsed *bait = user->GetActiveEsa(rod); bait != nullptr && bait->item_no > 0) {
        LastBait(rod) = bait->item_no;
    }
    // Only while Max walks with the rod, the state in which the menu may open; casting and a fish on the line keep L3/R3.
    if (ConfigGet().fishing_rod_shortcuts && fgLoopMode == 1 && CharaMode == FISHING_CHARA_MODE_CONTROL &&
        !GamePad__2.key_lock) {
        if (GamePad__2.Down(PAD_L3)) {
            const bool          hook_empty = LocalEsaNo < 0;
            const FishingRebait result = FishingRodRebait(user, LastBait(rod), GetCommonItemData);
            CGameDataUsed      *bait = user->GetActiveEsa(rod);
            const bool          reload = FishingRodReloads(result, hook_empty, bait != nullptr ? bait->GetNum() : 0);
            if (reload) {
                info->esa_no = user->GetFishBait();
                sgRestartFishing(info);
            }
            PlaySe(result == FISHING_REBAIT_NONE && !reload ? SYSTEM_SE_CANCEL : SYSTEM_SE_DECIDE);
        } else if (GamePad__2.Down(PAD_R3)) {
            if (!PutRodAway(user)) {
                PlaySe(SYSTEM_SE_CANCEL);
            } else if (GetNowLoopNo() == LOOP_DUNGEON) {
                // Fishing ends before Max is loaded again holding the weapon, as quick loadout changes equipment. Its
                // exit drops every motion set but the first from the player in the scene, which must be the Max with
                // the rod, not the one loaded afresh; the reload's close then finds no fishing game to end.
                PlaySe(SYSTEM_SE_EQUIP);
                ExitFishing(info->scene);
                const int finished = PortRetailLoopFishing(info);
                PortQuickLoadoutReloadEquipment(USER_CHARA_MAX);
                return finished;
            } else {
                // In town Max carries no weapon: ending the game puts the rod out of his hands.
                PlaySe(SYSTEM_SE_EQUIP);
                ExitFishing(info->scene);
            }
        }
    }
    return PortRetailLoopFishing(info);
}
