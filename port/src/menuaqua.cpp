// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <cstdio>
#include <print>
#include <string>
#include <vector>

#include "character.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "mainloop.hpp"
#include "menuaqua.hpp"
#include "platform/model_assets.hpp"
#include "record_bridges.hpp"
#include "stubs/menuaqua.hpp"
#include "userdata.hpp"

PORT_OVERRIDE int FishIMGReplace(u_long128 *data, CCharacter2 *character, int item_no, BREEDFISH_USED *fish) {
    if (!data || !character || !fish || (fish->flags & BREEDFISH_FLAG_ELECTRIC)) {
        return 0;
    }
    char path[128];
    if (!GetFishImgPath(path, item_no, fish)) {
        return 0;
    }
    const auto relative = DataReadAssetPath(("/" + std::string(path)).c_str());
    if (!relative) {
        return 0;
    }
    std::string error;
    if (!model_assets::ReplaceCharacterTextureDocument(*character, *relative, error)) {
        std::println(stderr, "fish texture: {}", error);
    }
    return 0;
}

namespace {

/**
 * Parses a fish_prizes document.
 */
NativeFishPrizes ParseFishPrizes(const native_config::Json &document) {
    using namespace native_config;
    NativeFishPrizes prizes{.count = Int(document, "count"), .groups = {}};
    if (prizes.count < 0) {
        throw std::runtime_error("negative prize group count");
    }
    for (const auto &group : Array(document, "groups")) {
        NativeFishPrizeGroup parsed{.prize_count = Int(group, "prize_count"), .rates = Ints<8>(group, "rates"), .prizes = {}};
        if (parsed.prize_count < 0) {
            throw std::runtime_error("negative prize count");
        }
        for (const auto &prize : Array(group, "prizes")) {
            NativeFishPrize entry{.rate = Int(prize, "rate"), .ranks = {}};
            const auto     &ranks = Array(prize, "ranks");
            if (ranks.size() != entry.ranks.size()) {
                throw std::runtime_error("a prize has three ranks");
            }
            for (std::size_t rank = 0; rank < ranks.size(); ++rank) {
                if (!ranks[rank].is_array() || ranks[rank].size() != 2) {
                    throw std::runtime_error("a prize rank is [item, count]");
                }
                entry.ranks[rank] = {Int(ranks[rank][0]), Int(ranks[rank][1])};
            }
            parsed.prizes.push_back(entry);
        }
        prizes.groups.push_back(std::move(parsed));
    }
    return prizes;
}

/**
 * One race fish of a race_fish document.
 */
struct RaceFish {
    int         id;        /**< Item number the fish copies its data from. */
    std::string name;      /**< Fish name, CP932. */
    int         kind;      /**< Kind. */
    int         battle;    /**< Battle stat. */
    int         boost;     /**< Boost stat. */
    int         endurance; /**< Endurance stat. */
    int         tenacity;  /**< Tenacity stat. */
    int         stamina;   /**< Stamina stat. */
    int         size;      /**< Size. */
};

/**
 * One race class of a race_fish document.
 */
struct RaceClass {
    int                   race_class; /**< Class number. */
    int                   count;      /**< Fish records the class allocates. */
    std::vector<RaceFish> fish;       /**< Fish in script order. */
};

/**
 * Parses a race_fish document.
 */
std::vector<RaceClass> ParseRaceFish(const native_config::Json &document) {
    using namespace native_config;
    std::vector<RaceClass> classes;
    for (const auto &item : Array(document, "classes")) {
        RaceClass race{.race_class = Int(item, "class"), .count = Int(item, "count"), .fish = {}};
        if (race.race_class < 0 || race.race_class >= 4 || race.count < 0 || race.count > 0x7FFF) {
            throw std::runtime_error("race class or fish count out of range");
        }
        for (const auto &fish : Array(item, "fish")) {
            race.fish.push_back({.id = Int(fish, "id"), .name = Text(fish, "name", sizeof(BREEDFISH_USED::name)), .kind = Int(fish, "kind"), .battle = Int(fish, "battle"), .boost = Int(fish, "boost"), .endurance = Int(fish, "endurance"), .tenacity = Int(fish, "tenacity"), .stamina = Int(fish, "stamina"), .size = Int(fish, "size")});
        }
        classes.push_back(std::move(race));
    }
    return classes;
}

} // namespace

PORT_OVERRIDE int LoadFishPrize(int goods_type, mgCMemory *pool) {
    InitFishPrize();
    FishTournamentGoodsType = static_cast<signed char>(goods_type);
    if (FishTournamentGoodsType < 0 || FishTournamentGoodsType >= 2) {
        FishTournamentGoodsType = 0;
    }
    const char *name = FishTournamentGoodsType == 0 ? "gyop.cfg.json" : "uofp.cfg.json";
    if (const auto prizes = native_config::ReadGame<NativeFishPrizes>(name, "fish_prizes", ParseFishPrizes)) {
        PortApplyFishPrizes(*prizes, pool);
    }
    RefreshFishPrize();
    return 1;
}

PORT_OVERRIDE int CGyoraceFishData::LoadData(mgCMemory *memory, u_long128 * /*buffer*/) {
    if (memory == nullptr) {
        return 0;
    }
    for (int race_class = 0; race_class < 4; ++race_class) {
        fish[race_class] = nullptr;
        fish_num[race_class] = 0;
    }
    char saved_dir[0x80];
    GetCurrentDir(saved_dir);
    SetCurrentDir(nullptr);
    const std::string path = "sg/gyo/rfd" + std::to_string(LanguageCode) + ".cfg.json";
    if (const auto classes = native_config::ReadGame<std::vector<RaceClass> >(path.c_str(), "race_fish", ParseRaceFish)) {
        for (const auto &race : *classes) {
            fish_num[race.race_class] = static_cast<s16>(race.count);
            const unsigned int bytes = race.count * sizeof(CGameDataUsed);
            const unsigned int blocks = (bytes & 0xF) != 0 ? (bytes >> 4) + 1 : bytes >> 4;
            auto              *entries = new (memory->Alloc(static_cast<int>(blocks + 2))) CGameDataUsed[race.count];
            fish[race.race_class] = entries;
            int filled = 0;
            for (const auto &item : race.fish) {
                if (filled >= race.count) {
                    break;
                }
                CGameDataUsed *entry = &entries[filled++];
                entry->CopyDataFish(item.id);
                std::string fish_name = item.name;
                entry->SetName(fish_name.data());
                BREEDFISH_USED *breed = &entry->data.fish;
                breed->kind = item.kind;
                breed->param[BREEDFISH_STAT_BATTLE] = item.battle;
                breed->param[BREEDFISH_STAT_BOOST] = item.boost;
                breed->param[BREEDFISH_STAT_ENDURANCE] = item.endurance;
                breed->param[BREEDFISH_STAT_TENACITY] = item.tenacity;
                breed->param[BREEDFISH_STAT_STAMINA] = item.stamina;
                breed->size = item.size;
            }
        }
    }
    SetCurrentDir(saved_dir);
    return 1;
}
