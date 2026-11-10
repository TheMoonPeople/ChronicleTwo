#include "common.h"

#include <format>
#include <string>

#include "charasetup.hpp"
#include "userdata.hpp"

namespace dc2::character {

std::string SoundAssetPath(CUserDataManager *user_data, int unit) {
    if (user_data == nullptr) {
        return {};
    }
    std::string sound;
    if (unit == USER_CHARA_MAX) {
        const CHARA_DATA *chara = user_data->GetCharaDataPtr(unit);
        if (chara == nullptr) {
            return {};
        }
        const int item_no = chara->equip[CHARA_EQUIP_SUB].item_no;
        if (item_no < 0x16 || item_no > 0x28) {
            sound = "snd2/chara/CH_000.sound.json";
        } else {
            sound = std::format("snd2/chara/CH_{:03}.sound.json", item_no - 0x16);
        }
    }
    if (unit == USER_CHARA_MONICA) {
        sound = "snd2/chara/CH_020.sound.json";
    }
    if (unit == USER_CHARA_ROBO) {
        const auto name = user_data->robo_data.parts[ROBO_PART_ARM].RoboSoundFileName();
        if (name && !name->empty()) {
            sound = std::format("snd2/chara/{}.sound.json", *name);
        }
    }
    return sound;
}

} // namespace dc2::character
