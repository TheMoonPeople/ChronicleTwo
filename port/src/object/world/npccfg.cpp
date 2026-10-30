// clang-format off
#include "platform/native_config.hpp"
#include "log/game_output.hpp"
// clang-format on

#include "common.h"

#include <cstdio>
#include <cstring>
#include <iterator>
#include <string_view>

#include "dataread.hpp"
#include "mainloop.hpp"
#include "menucommon.hpp"
#include "npccfg.hpp"
#include "text/bounded.hpp"

/**
 *
 * Number of initialized party-character entries.
 *
 */
static int NpcBaseDataTotalNum;

/**
 *
 * Party-character entries loaded from the NPC script, kept on a quadword boundary.
 *
 */
static NPC_BASE_DATA NpcBaseData[180] __attribute__((aligned(16)));

/**
 *
 * Message suffix for each party-character message category.
 *
 */
static signed char typetbl_853[16] = {0, 10, 20, 30, 2, 40, 45, 50, 55, 0, 90, 60, 0, 21, 25, 0};

int GetPartyCharaMessage(int chara_no, int type, int event) {
    if (GetPartyNPCData(chara_no) == nullptr || type < 0 || static_cast<std::size_t>(type) >= std::size(typetbl_853)) {
        return 0;
    }

    int message = typetbl_853[type] + chara_no * 100;

    if (type == 12) {
        message = chara_no + 3000;
    }

    if (event != 0) {
        message += 30000;
    }

    return message;
}

char *GetNPCModelName(int chara_no) {
    NPC_BASE_DATA *data = GetPartyNPCData(chara_no);

    if (data != nullptr) {
        return data->model;
    }

    return nullptr;
}

char *GetNPCName(int chara_no) {
    NPC_BASE_DATA *data = GetPartyNPCData(chara_no);

    if (data != nullptr) {
        return data->name;
    }

    return nullptr;
}

char *GetPartyCharaModelName(int chara_no, int type) {
    // Buffer holding the requested party-character model path.
    static char path[0x40];

    // Character information script name.
    static char infocfg[] = "info";

    if (chara_no <= 0 || chara_no > 0x20) {
        return nullptr;
    }

    path[0] = 0;
    NPC_BASE_DATA *data = GetPartyNPCData(chara_no);
    if (data == nullptr) {
        return nullptr;
    }

    if (type == NPC_MODEL_PATH_INFO) {
        return infocfg;
    }

    const std::string_view model = dc2::text::View(data->model);
    if (model.size() == sizeof data->model) {
        return nullptr;
    }

    std::string_view prefix;
    switch (type) {
        case NPC_MODEL_PATH_CHARA:
            prefix = "chara/";
            break;
        case NPC_MODEL_PATH_EVENT_TRAIN:
            prefix = "event/train/t";
            break;
        case NPC_MODEL_PATH_MENU:
            prefix = "menu/npc/t";
            break;
        default:
            return nullptr;
    }
    dc2::text::Copy(path, prefix);
    if (dc2::text::Append(path, model) != model.size() || dc2::text::Append(path, ".gltf") != 5) {
        return nullptr;
    }
    return path;
}

NPC_BASE_DATA *GetPartyNPCData(int chara_no) {
    for (int i = 0; i < NpcBaseDataTotalNum; i++) {
        if (NpcBaseData[i].chara_no == chara_no) {
            return &NpcBaseData[i];
        }
    }

    return nullptr;
}

// nlohmann must precede the game headers, whose macros it would otherwise see.
// clang-format off
// clang-format on

#include "common.h"

#include <array>
#include <cstring>
#include <format>
#include <iterator>
#include <optional>
#include <stdexcept>
#include <string>
#include <vector>

#include "mainloop.hpp"
#include "npccfg.hpp"
#include "stubs/npccfg.hpp"

namespace {

/**
 * One party character as a party_characters document lists it.
 */
struct PartyCharacter {
    int                        id;            /**< Party character number. */
    std::optional<std::string> name;          /**< CP932 display name, or nothing to keep the entry's name. */
    std::optional<std::string> model;         /**< CP932 model base name, or nothing to keep the entry's model. */
    int                        unk_31;        /**< Value stored in NPC_BASE_DATA::unk_31. */
    int                        ability_num;   /**< Number of abilities. */
    int                        max_npc_point; /**< Points the abilities draw on. */
    std::array<int, 4>         ability_cost;  /**< Points each ability uses. */
    int                        debug_flag;    /**< Whether the debug party-character selector lists the character. */
};

/**
 * Reads a nullable string member, refusing text that does not fit a fixed character field.
 */
std::optional<std::string> FieldText(const native_config::Json &object, const char *key, std::size_t capacity) {
    auto text = native_config::GameText(native_config::At(object, key));
    if (text && text->size() >= capacity) {
        throw std::runtime_error(std::string(key) + " is longer than its " + std::to_string(capacity - 1) + "-byte field");
    }
    return text;
}

/**
 * Parses a party_characters document.
 */
std::vector<PartyCharacter> ParsePartyCharacters(const native_config::Json &document) {
    using namespace native_config;
    std::vector<PartyCharacter> characters;
    for (const auto &character : Array(document, "characters")) {
        characters.push_back({
            .id = Int(character, "id"),
            .name = FieldText(character, "name", sizeof(NPC_BASE_DATA::name)),
            .model = FieldText(character, "model", sizeof(NPC_BASE_DATA::model)),
            .unk_31 = Int(character, "unk_31"),
            .ability_num = Int(character, "ability_num"),
            .max_npc_point = Int(character, "max_npc_point"),
            .ability_cost = Ints<4>(character, "ability_cost"),
            .debug_flag = Int(character, "debug_flag"),
        });
    }
    return characters;
}

/**
 * Stores one party character in its table entry as the NPC_INFO callback does.
 */
void ApplyPartyCharacter(NPC_BASE_DATA &data, const PartyCharacter &character) {
    data.chara_no = static_cast<s16>(character.id);
    if (character.name) {
        std::memcpy(data.name, character.name->c_str(), character.name->size() + 1);
    }
    if (character.model) {
        std::memcpy(data.model, character.model->c_str(), character.model->size() + 1);
    }
    data.unk_31 = static_cast<s8>(character.unk_31);
    data.ability_num = static_cast<s8>(character.ability_num);
    data.max_npc_point = static_cast<s8>(character.max_npc_point);
    for (std::size_t index = 0; index < character.ability_cost.size(); ++index) {
        data.ability_cost[index] = static_cast<u8>(character.ability_cost[index]);
    }
    data.debug_flag = static_cast<s8>(character.debug_flag);
}

} // namespace

void LoadNPCCfg() {
    const auto  path = std::format("npc{}.cfg.json", LanguageCode);
    std::size_t count = 0;
    if (const auto characters = native_config::ReadGame<std::vector<PartyCharacter>>(path.c_str(), "party_characters", ParsePartyCharacters)) {
        for (const auto &character : *characters) {
            // Retail writes past the table for an over-long list; the port keeps the entries that fit.
            if (count >= std::size(NpcBaseData)) {
                break;
            }
            ApplyPartyCharacter(NpcBaseData[count++], character);
        }
    }
    NpcBaseDataTotalNum = static_cast<int>(count);
}
