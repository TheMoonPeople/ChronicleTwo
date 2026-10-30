// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include <nlohmann/json.hpp>
// clang-format on

#include "save_json.hpp"

#include <algorithm>
#include <bit>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <limits>
#include <span>
#include <type_traits>
#include <unordered_map>
#include <utility>

#include "editmap.hpp"
#include "gamedata.hpp"
#include "menusystemdata.hpp"
#include "platform/legacy_encoding.hpp"
#include "quest.hpp"
#include "savedatadungeon.hpp"
#include "stubs/editmap.hpp"
#include "text/bounded.hpp"
#include "userdata.hpp"

namespace {

using Json = nlohmann::json;
using OrderedJson = nlohmann::ordered_json;

constexpr char kFormat[] = "chronicletwo-save";
constexpr char kVersion[] = "dc2Ver4";
constexpr char kChecksumPrefix[] = "crc32:";

/**
 * Thrown by the reader to stop at the first problem with a document.
 */
struct Failure : std::exception {
    explicit Failure(SaveJsonError error) : error(error) {}

    SaveJsonError error; /**< What was wrong. */
};

[[noreturn]] void Fail(SaveJsonError error) {
    throw Failure(error);
}

// Migrations from each schema version to the next; entry n upgrades version n + 1 in place.
using Migration = void (*)(Json &document);
constexpr std::array<Migration, kSaveJsonSchemaVersion - 1> kMigrations{};

constexpr std::string_view kBase64Digits = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

std::string Base64(std::span<const u8> bytes) {
    std::string text;
    text.reserve((bytes.size() + 2) / 3 * 4);
    for (std::size_t i = 0; i < bytes.size(); i += 3) {
        const std::size_t   count = std::min<std::size_t>(3, bytes.size() - i);
        const std::uint32_t group = (static_cast<std::uint32_t>(bytes[i]) << 16) |
                                    (count > 1 ? static_cast<std::uint32_t>(bytes[i + 1]) << 8 : 0) | (count > 2 ? bytes[i + 2] : 0);
        for (std::size_t k = 0; k < 4; ++k) {
            text += k <= count ? kBase64Digits[(group >> (18 - (6 * k))) & 0x3F] : '=';
        }
    }
    return text;
}

std::vector<u8> FromBase64(std::string_view text) {
    if (text.size() % 4 != 0) {
        Fail(SaveJsonError::BadValue);
    }
    std::vector<u8> bytes;
    bytes.reserve(text.size() / 4 * 3);
    for (std::size_t i = 0; i < text.size(); i += 4) {
        std::uint32_t group = 0;
        int           padding = 0;
        for (std::size_t k = 0; k < 4; ++k) {
            const char digit = text[i + k];
            group <<= 6;
            if (digit == '=' && i + 4 == text.size() && k >= 2) {
                ++padding;
                continue;
            }
            const auto value = kBase64Digits.find(digit);
            if (value == std::string_view::npos || padding != 0) {
                Fail(SaveJsonError::BadValue);
            }
            group |= static_cast<std::uint32_t>(value);
        }
        bytes.push_back(static_cast<u8>(group >> 16));
        if (padding < 2) {
            bytes.push_back(static_cast<u8>(group >> 8));
        }
        if (padding < 1) {
            bytes.push_back(static_cast<u8>(group));
        }
    }
    return bytes;
}

std::uint32_t Crc32(std::string_view text) {
    static const auto table = [] {
        std::array<std::uint32_t, 256> entries{};
        for (std::uint32_t n = 0; n < entries.size(); ++n) {
            std::uint32_t c = n;
            for (int k = 0; k < 8; ++k) {
                c = (c & 1) != 0 ? 0xEDB88320U ^ (c >> 1) : c >> 1;
            }
            entries[n] = c;
        }
        return entries;
    }();
    std::uint32_t crc = 0xFFFFFFFFU;
    for (const char byte : text) {
        crc = table[(crc ^ static_cast<u8>(byte)) & 0xFF] ^ (crc >> 8);
    }
    return crc ^ 0xFFFFFFFFU;
}

std::string ChecksumText(std::string_view canonical) {
    std::array<char, 9> digits{};
    std::snprintf(digits.data(), digits.size(), "%08X", Crc32(canonical));
    return std::string(kChecksumPrefix) + digits.data();
}

// The fields of each record of the save, in declaration order. A field that the JSON names is read or written through
// io(name, field); unknown byte runs through io.Bytes and the game's fixed text fields through io.Text.

template <typename Io>
void Fields(Io &io, CMapFlagData &value) {
    io("flag", value.flag);
}

template <typename Io>
void Fields(Io &io, EditDataAnalyze &value) {
    io("data_open", value.data_open);
    io("condition", value.condition);
    io("condition_open", value.condition_open);
    io.Bytes("unk_90", value.unk_90);
}

// A town's layout lives in the save's towns array; its record keeps only the town's analysis.
template <typename Io>
void Fields(Io &io, CEditData &value) {
    io("save_count", value.save_count);
    io("culture_point", value.culture_point);
    io("analyze", value.analyze);
    io.Bytes("unk_5110", value.unk_5110);
}

template <typename Io>
void Fields(Io &io, SV_CONFIG_OPTION &value) {
    io("cursor_save", value.cursor_save);
    io("vibration", value.vibration);
    io("message_speed", value.message_speed);
    io("sound_mode", value.sound_mode);
    io("fast_time", value.fast_time);
    io("map", value.map);
    io.Bytes("unk_18", value.unk_18);
    io("enemy_hp", value.enemy_hp);
    io("damage_off", value.damage_off);
    io("unk_24", value.unk_24);
    io("monster_name", value.monster_name);
    io("anger_counter", value.anger_counter);
    io("dof_off", value.dof_off);
    io("caption_off", value.caption_off);
    io("pause_overlay_off", value.pause_overlay_off);
    io("eye_reverse", value.eye_reverse);
    io("rot_normal", value.rot_normal);
    io.Bytes("unk_38", value.unk_38);
}

template <typename Io>
void Fields(Io &io, DNG_FLOOR_SAVE &value) {
    io("unk_0", value.unk_0);
    io("fast_destroy_time", value.fast_destroy_time);
    io("unk_8", value.unk_8);
    io("unk_a", value.unk_a);
    io("unk_b", value.unk_b);
    io("spheda_clear", value.spheda_clear);
    io("flag", value.flag);
    io("kill_count", value.kill_count);
    io("visit_count", value.visit_count);
}

template <typename Io>
void Fields(Io &io, CSaveDataDungeon &value) {
    io("stage_id", value.stage_id);
    io("floor_id", value.floor_id);
    io("prev_floor_id", value.prev_floor_id);
    io("floor_info", value.floor_info);
}

template <typename Io>
void Fields(Io &io, COMMON_GAGE &value) {
    io("max", value.max);
    io("now", value.now);
}

template <typename Io>
void Fields(Io &io, ITEM_USED &value) {
    io("num", value.num);
    io("unk_2", value.unk_2);
    io.Bytes("unk_4", value.unk_4);
}

template <typename Io>
void Fields(Io &io, ATTACH_USED &value) {
    io("spectol_type", value.spectol_type);
    io("spectol_value", value.spectol_value);
    io("status", value.status);
    io("attribute", value.attribute);
    io("spectol_item_no", value.spectol_item_no);
    io("level", value.level);
    io.Bytes("unk_1a", value.unk_1a);
    io("special", value.special);
    io.Text("name", value.name);
    io("num", value.num);
    io.Bytes("unk_3c", value.unk_3c);
}

template <typename Io>
void Fields(Io &io, WEAPON_USED &value) {
    io("whp", value.whp);
    io("abs", value.abs);
    io("level", value.level);
    io("status", value.status);
    io("attribute", value.attribute);
    io("unk_26", value.unk_26);
    io("special", value.special);
    io("fusion_point", value.fusion_point);
    io("unk_2e", value.unk_2e);
    io("unk_30", value.unk_30);
    io("unk_32", value.unk_32);
    io.Text("name", value.name);
    io.Bytes("unk_53", value.unk_53);
}

template <typename Io>
void Fields(Io &io, ROBOPART_USED &value) {
    io("energy", value.energy);
    io("whp", value.whp);
    io("status", value.status);
    io("defence", value.defence);
    io("unk_26", value.unk_26);
    io.Bytes("unk_28", value.unk_28);
    io.Text("name", value.name);
    io.Bytes("unk_4c", value.unk_4c);
}

template <typename Io>
void Fields(Io &io, BREEDFISH_USED &value) {
    io.Text("name", value.name);
    io("sex", value.sex);
    io("kind", value.kind);
    io("unk_17", value.unk_17);
    io("size", value.size);
    io("weight", value.weight);
    io("unk_1c", value.unk_1c);
    io("hp", value.hp);
    io("fatigue", value.fatigue);
    io("param", value.param);
    io("timer", value.timer);
    io.Bytes("unk_32", value.unk_32);
    io("breed_feeds_remaining", value.breed_feeds_remaining);
    io("feeds_remaining", value.feeds_remaining);
    io("flags", value.flags);
    io("color", value.color);
    io("grow_count", value.grow_count);
    io("unk_3c", value.unk_3c);
    io("race_placement_flags", value.race_placement_flags);
    io.Bytes("unk_3e", value.unk_3e);
    io("tank_day", value.tank_day);
    io("tank_hour", value.tank_hour);
    io.Bytes("unk_48", value.unk_48);
}

template <typename Io>
void Fields(Io &io, GIFTBOX_USED &value) {
    io("item_no", value.item_no);
    io.Bytes("unk_6", value.unk_6);
}

template <typename Io>
void Fields(Io &io, BOILED_USED &value) {
    io("base_item_no", value.base_item_no);
    io.Text("name", value.name);
    io("value", value.value);
    io.Bytes("unk_1a", value.unk_1a);
}

// The item's data is the union member its family uses; a place of no family keeps the union's bytes.
template <typename Io>
void Fields(Io &io, CGameDataUsed &value) {
    io("used_type", value.used_type);
    io("item_no", value.item_no);
    io("item_type", value.item_type);
    io("rename_flag", value.rename_flag);
    io.Bytes("unk_6", value.unk_6);
    switch (value.used_type) {
        case USED_ITEM_TYPE_ITEM:
            io("item", value.data.item);
            break;
        case USED_ITEM_TYPE_ATTACH:
            io("attach", value.data.attach);
            break;
        case USED_ITEM_TYPE_WEAPON:
            io("weapon", value.data.weapon);
            break;
        case USED_ITEM_TYPE_ROBO_PART:
            io("robopart", value.data.robopart);
            break;
        case USED_ITEM_TYPE_FISH:
            io("fish", value.data.fish);
            break;
        case USED_ITEM_TYPE_GIFT_BOX:
            io("giftbox", value.data.giftbox);
            break;
        case USED_ITEM_TYPE_BOILED:
            io("boiled", value.data.boiled);
            break;
        default:
            io.Bytes("data", value.data);
            break;
    }
}

template <typename Io>
void Fields(Io &io, CHARA_DATA &value) {
    io("hp", value.hp);
    io("status_attr", value.status_attr);
    io("defence", value.defence);
    io("status_time", value.status_time);
    io.Bytes("unk_14", value.unk_14);
    io("keep_costume_on_equip_change", value.keep_costume_on_equip_change);
    io("active_item", value.active_item);
    io("equip", value.equip);
}

template <typename Io>
void Fields(Io &io, ROBO_DATA &value) {
    io.Bytes("unk_0", value.unk_0);
    io.Text("name", value.name);
    io("voice_unit", value.voice_unit);
    io("voice_flag", value.voice_flag);
    io.Bytes("unk_1e", value.unk_1e);
    io("hp", value.hp);
    io("abs", value.abs);
    io("parts", value.parts);
    io("status_time", value.status_time);
    io.Bytes("unk_1e6", value.unk_1e6);
    io("shield_kit_num", value.shield_kit_num);
    io.Bytes("unk_1ea", value.unk_1ea);
}

template <typename Io>
void Fields(Io &io, CFishAquarium &value) {
    io("active_tank", value.active_tank);
    io("unk_2", value.unk_2);
    io("fish_tank", value.fish_tank);
    io("sub_tank", value.sub_tank);
    io("breed_tank", value.breed_tank);
    io.Bytes("unk_514", value.unk_514);
    io("unk_518", value.unk_518);
    io("last_time", value.last_time);
    io("last_day", value.last_day);
    io("last_hour", value.last_hour);
}

template <typename Io>
void Fields(Io &io, MOS_CHANGE_PARAM &value) {
    io("no", value.no);
    io("level", value.level);
    io("class_level", value.class_level);
    io("progress", value.progress);
    io("monster_id", value.monster_id);
    io("enable", value.enable);
    io("unk_b", value.unk_b);
    io("hp", value.hp);
    io("abs", value.abs);
    io.Bytes("unk_1c", value.unk_1c);
    io("poison_time", value.poison_time);
    io("power_time", value.power_time);
    io.Bytes("unk_40", value.unk_40);
}

template <typename Io>
void Fields(Io &io, CMonsterBox &value) {
    io("monster", value.monster);
}

template <typename Io>
void Fields(Io &io, PARTY_CHARA_INFO &value) {
    io("chara_no", value.chara_no);
    io("status", value.status);
    io("point", value.point);
    io.Bytes("unk_6", value.unk_6);
}

// The photo's image is a host pointer bound when the album opens, so it is not saved; a read leaves it null.
template <typename Io>
void Fields(Io &io, USER_PICTURE_INFO &value) {
    io("used", value.used);
    io("is_new", value.is_new);
    io("map_no", value.map_no);
    io("npc_no", value.npc_no);
    io("monster_no", value.monster_no);
    io("unk_8", value.unk_8);
    io("neta_id", value.neta_id);
    io.Bytes("unk_c", value.unk_c);
}

template <typename Io>
void Fields(Io &io, INVENT_CREATED_ITEM &value) {
    io("item_id", value.item_id);
    io("unk_2", value.unk_2);
}

template <typename Io>
void Fields(Io &io, SCOOP_INFO &value) {
    io("known", value.known);
    io("obtained", value.obtained);
    io.Bytes("unk_2", value.unk_2);
}

template <typename Io>
void Fields(Io &io, CScoopDataManager &value) {
    io("info", value.info);
}

// The photo pixels are 16-bit colours, little-endian.
template <typename Io>
void Fields(Io &io, CInventUserData &value) {
    io("shutter_num", value.shutter_num);
    io("level", value.level);
    io("neta_id", value.neta_id);
    io("photo", value.photo);
    io("created_item", value.created_item);
    io("scoop", value.scoop);
    io.Bytes("unk_cd8", value.unk_cd8);
    io.Bytes("photo_work", value.photo_work);
    io.Bytes("unk_3cd60", value.unk_3cd60);
}

template <typename Io>
void Fields(Io &io, FISH_TOURNAMENT_ENTRY &value) {
    io("item_no", value.item_no);
    io("size", value.size);
    io("weight", value.weight);
    io("unk_6", value.unk_6);
}

template <typename Io>
void Fields(Io &io, CFishingTournament &value) {
    io.Bytes("unk_0", value.unk_0);
    io("rank", value.rank);
    io.Bytes("unk_6", value.unk_6);
    io("entry", value.entry);
}

template <typename Io>
void Fields(Io &io, FISH_RECORD &value) {
    io("size", value.size);
    io("prev_size", value.prev_size);
    io("weight", value.weight);
    io("prev_weight", value.prev_weight);
    io("num", value.num);
    io.Bytes("unk_14", value.unk_14);
}

template <typename Io>
void Fields(Io &io, CFishingRecord &value) {
    io.Bytes("unk_0", value.unk_0);
    io("record", value.record);
}

template <typename Io>
void Fields(Io &io, CUserDataManager &value) {
    io("used_data", value.used_data);
    io("chara_data", value.chara_data);
    io("robo_data", value.robo_data);
    io("esa", value.esa);
    io("aquarium", value.aquarium);
    io.Bytes("unk_4e88", value.unk_4e88);
    io("monster_box", value.monster_box);
    io("party_chara", value.party_chara);
    io("invent_data", value.invent_data);
    io("party_member", value.party_member);
    io("chara_change", value.chara_change);
    io("chara_change_mask", value.chara_change_mask);
    io("unk_44d95", value.unk_44d95);
    io("active_chr_no", value.active_chr_no);
    io("monster_id", value.monster_id);
    io.Bytes("unk_44d9a", value.unk_44d9a);
    io("money", value.money);
    io("yarikomi_medal", value.yarikomi_medal);
    io.Bytes("unk_44da2", value.unk_44da2);
    io("special_item_bought", value.special_item_bought);
    io.Bytes("unk_44dc2", value.unk_44dc2);
    io("unk_44dc8", value.unk_44dc8);
    io("photo_subject", value.photo_subject);
    io("unk_451d0", value.unk_451d0);
    io("last_refresh_time", value.last_refresh_time);
    io("npc_refresh_day", value.npc_refresh_day);
    io("npc_refresh_hour", value.npc_refresh_hour);
    io("fish_tournament", value.fish_tournament);
    io("fish_record", value.fish_record);
    io("costume_bit", value.costume_bit);
    io.Bytes("unk_455a0", value.unk_455a0);
}

template <typename Io>
void Fields(Io &io, QUEST_PLAY_DATA &value) {
    io("accepted", value.accepted);
    io("cleared", value.cleared);
    io.Bytes("unk_2", value.unk_2);
}

template <typename Io>
void Fields(Io &io, CQuestData &value) {
    io("play", value.play);
    io.Bytes("unk_400", value.unk_400);
}

template <typename Io>
void Fields(Io &io, MONSTER_BOOK_ENTRY &value) {
    io.Bytes("unk_0", value.unk_0);
    io("kill_count", value.kill_count);
    io.Bytes("unk_4", value.unk_4);
}

template <typename Io>
void Fields(Io &io, CMonsterBook &value) {
    io("entry", value.entry);
}

template <typename Io>
void Fields(Io &io, MENU_SYSTEM_LIST_CURSOR &value) {
    io("select", value.select);
    io("top", value.top);
}

template <typename Io>
void Fields(Io &io, MENU_SYSTEM_GHOBI &value) {
    io("item_no", value.item_no);
    io("unk_2", value.unk_2);
}

template <typename Io>
void Fields(Io &io, CMenuSystemData &value) {
    io("item_board_select", value.item_board_select);
    io("item_board_top", value.item_board_top);
    io("unk_4", value.unk_4);
    io("unk_6", value.unk_6);
    io("item_key_arg_no", value.item_key_arg_no);
    io("item_cursor", value.item_cursor);
    io.Bytes("unk_c", value.unk_c);
    io("invent_item", value.invent_item);
    io.Bytes("unk_24", value.unk_24);
    io("invent_memo_sort_mode", value.invent_memo_sort_mode);
    io("invent_card", value.invent_card);
    io("invent_photo", value.invent_photo);
    io("invent_album", value.invent_album);
    io("invent_memo", value.invent_memo);
    io.Bytes("unk_40", value.unk_40);
    io("georama_list", value.georama_list);
    io.Bytes("unk_6c", value.unk_6c);
    io("ghobi", value.ghobi);
}

template <typename Io>
void Fields(Io &io, SAVE_TOUR_INFO &value) {
    io("start_day", value.start_day);
    io("finish_day", value.finish_day);
    io("now_event", value.now_event);
    io("type", value.type);
    io("count", value.count);
    io("base_day", value.base_day);
    io.Bytes("unk_10", value.unk_10);
}

template <typename Io>
void Fields(Io &io, CSaveData &value) {
    io("bit_flag", value.bit_flag);
    io("short_flag", value.short_flag);
    io("map_flag", value.map_flag);
    io.Bytes("unk_1200", value.unk_1200);
    io("play_time", value.play_time);
    io("game_progress", value.game_progress);
    io("time_stop", value.time_stop);
    io("now_time", value.now_time);
    io("day", value.day);
    io("map_no", value.map_no);
    io("sub_map_no", value.sub_map_no);
    io("prev_map_no", value.prev_map_no);
    io("prev_sub_map_no", value.prev_sub_map_no);
    io("area_no", value.area_no);
    io("build_parts_num", value.build_parts_num);
    io("edit_data", value.edit_data);
    io("config", value.config);
    io("save_dungeon", value.save_dungeon);
    io.Bytes("unk_1D298", value.unk_1D298);
    io("user_data", value.user_data);
    io("quest_data", value.quest_data);
    io("monster_book", value.monster_book);
    io("menu_system_data", value.menu_system_data);
    io("bit_ctrl", value.bit_ctrl);
    io("skip_load_bgm", value.skip_load_bgm);
    io.Bytes("unk_643CA", value.unk_643CA);
    io("tour", value.tour);
    io.Bytes("unk_643EC", value.unk_643EC);
}

// The image's header without its version, check digits and incomplete flag, which the JSON file does not need.
template <typename Io>
void HeaderFields(Io &io, SAVEDATA_FORMAT &value) {
    io("costume_bit", value.costume_bit);
    io("debug_code", value.debug_code);
    io("unk_1A", value.unk_1A);
    io("unk_1C", value.unk_1C);
    io("unk_20", value.unk_20);
    io("unk_24", value.unk_24);
    io("map_no", value.map_no);
    io("program_loop_no", value.program_loop_no);
    io("dungeon_no", value.dungeon_no);
    io("floor_id", value.floor_id);
    io("progress", value.progress);
    io("dng_tree_flag", value.dng_tree_flag);
    io("omake_flag", value.omake_flag);
    io("unk_47", value.unk_47);
    io("fish_num", value.fish_num);
    io.Bytes("unk_4C", value.unk_4C);
    io("unique_counter", value.unique_counter);
    io.Bytes("unk_659B0", value.unk_659B0);
}

/**
 * Whether a fixed text field holds text that its UTF-8 form gives back exactly: terminated, zero after the
 * terminator, and valid CP932.
 */
std::optional<std::string> CleanText(std::span<const char> field) {
    const auto text = dc2::text::View(field.data(), field.size());
    if (text.size() == field.size() || !std::all_of(field.begin() + static_cast<std::ptrdiff_t>(text.size()), field.end(), [](char c) { return c == '\0'; })) {
        return std::nullopt;
    }
    auto readable = legacy_encoding::ReadableText(text);
    if (!readable) {
        return std::nullopt;
    }
    try {
        if (legacy_encoding::GameText(*readable) != text) {
            return std::nullopt;
        }
    } catch (const std::exception &) {
        return std::nullopt;
    }
    return readable;
}

/**
 * Builds the JSON of a record, field by field.
 */
class Writer {
public:
    explicit Writer(OrderedJson &object) : object(object) {}

    template <typename T>
    void operator()(const char *name, T &value) {
        object[name] = Value(value);
    }

    template <typename T>
    void Bytes(const char *name, T &value) {
        object[name] = Base64({reinterpret_cast<const u8 *>(&value), sizeof(value)});
    }

    // Text that would not come back byte for byte is kept as its bytes.
    template <std::size_t N>
    void Text(const char *name, char (&value)[N]) {
        if (auto text = CleanText(value)) {
            object[name] = *text;
        } else {
            object[name] = {
                {"base64", Base64({reinterpret_cast<const u8 *>(value), N})}
            };
        }
    }

    template <typename T>
    static OrderedJson Value(T &value) {
        if constexpr (std::is_floating_point_v<T>) {
            // JSON has no infinities or NaNs; their bits keep them.
            if (!std::isfinite(value)) {
                return {
                    {"float_bits", std::bit_cast<std::uint32_t>(value)}
                };
            }
            return value;
        } else if constexpr (std::is_same_v<T, char>) {
            // s8 is char, whose signedness differs between hosts; the file always holds it signed.
            return static_cast<signed char>(value);
        } else if constexpr (std::is_arithmetic_v<T>) {
            return value;
        } else if constexpr (std::is_array_v<T>) {
            OrderedJson array = OrderedJson::array();
            for (auto &element : value) {
                array.push_back(Value(element));
            }
            return array;
        } else {
            OrderedJson object = OrderedJson::object();
            Writer      writer(object);
            Fields(writer, value);
            return object;
        }
    }

private:
    OrderedJson &object;
};

/**
 * Fills a record from its JSON, field by field.
 */
class Reader {
public:
    explicit Reader(const Json &object) : object(object) {
        if (!object.is_object()) {
            Fail(SaveJsonError::WrongSchema);
        }
    }

    template <typename T>
    void operator()(const char *name, T &value) const {
        Read(At(name), value);
    }

    template <typename T>
    void Bytes(const char *name, T &value) const {
        const Json &text = At(name);
        if (!text.is_string()) {
            Fail(SaveJsonError::BadValue);
        }
        const auto bytes = FromBase64(text.get_ref<const std::string &>());
        if (bytes.size() != sizeof(value)) {
            Fail(SaveJsonError::BadValue);
        }
        std::memcpy(static_cast<void *>(&value), bytes.data(), bytes.size());
    }

    // UTF-8 text is cut to fit the field without splitting a character; bytes must fill it exactly.
    template <std::size_t N>
    void Text(const char *name, char (&value)[N]) const {
        const Json &text = At(name);
        std::memset(value, 0, N);
        if (text.is_string()) {
            try {
                dc2::text::Copy(value, legacy_encoding::GameText(text.get_ref<const std::string &>()));
            } catch (const std::exception &) {
                Fail(SaveJsonError::BadValue);
            }
            return;
        }
        Reader(text).Bytes("base64", value);
    }

    template <typename T>
    static void Read(const Json &value, T &out) {
        if constexpr (std::is_floating_point_v<T>) {
            if (value.is_object()) {
                const Reader  object(value);
                std::uint32_t bits = 0;
                object("float_bits", bits);
                out = std::bit_cast<T>(bits);
                return;
            }
            if (!value.is_number()) {
                Fail(SaveJsonError::BadValue);
            }
            out = static_cast<T>(value.get<double>());
            if (!std::isfinite(out)) {
                Fail(SaveJsonError::BadValue);
            }
        } else if constexpr (std::is_same_v<T, char>) {
            signed char number = 0;
            Read(value, number);
            out = static_cast<char>(number);
        } else if constexpr (std::is_arithmetic_v<T>) {
            if (value.is_number_unsigned()) {
                const auto number = value.get<std::uint64_t>();
                if (number > static_cast<std::uint64_t>(std::numeric_limits<T>::max())) {
                    Fail(SaveJsonError::BadValue);
                }
                out = static_cast<T>(number);
            } else if (value.is_number_integer()) {
                const auto number = value.get<std::int64_t>();
                if (!std::in_range<T>(number)) {
                    Fail(SaveJsonError::BadValue);
                }
                out = static_cast<T>(number);
            } else {
                Fail(SaveJsonError::BadValue);
            }
        } else if constexpr (std::is_array_v<T>) {
            if (!value.is_array() || value.size() != std::extent_v<T>) {
                Fail(SaveJsonError::BadValue);
            }
            for (std::size_t i = 0; i < std::extent_v<T>; ++i) {
                Read(value[i], out[i]);
            }
        } else {
            const Reader reader(value);
            Fields(reader, out);
        }
    }

    const Json &At(const char *name) const {
        const auto found = object.find(name);
        if (found == object.end()) {
            Fail(SaveJsonError::WrongSchema);
        }
        return *found;
    }

    const Json *Find(const char *name) const {
        const auto found = object.find(name);
        return found != object.end() ? &*found : nullptr;
    }

private:
    const Json &object;
};

OrderedJson TownJson(const TownLayout &town) {
    OrderedJson parts = OrderedJson::array();
    for (const TownPart &part : town.parts) {
        OrderedJson color = OrderedJson::array();
        for (const auto &rgb : part.color) {
            color.push_back(rgb);
        }
        parts.push_back({
            {"id",    part.id      },
            {"state", part.state   },
            {"angle", part.angle   },
            {"pos",   part.pos     },
            {"color", color        },
            {"house", part.house_no}
        });
    }
    OrderedJson houses = OrderedJson::array();
    for (const TownHouse &house : town.houses) {
        houses.push_back({
            {"npc_no", house.npc_no}
        });
    }
    OrderedJson place_log = OrderedJson::array();
    for (const EditPlaceLog &entry : town.place_log) {
        place_log.push_back({entry.parts_no, entry.base_no});
    }
    OrderedJson grids = OrderedJson::array();
    for (const TownGrid &grid : town.grids) {
        grids.push_back({
            {"num_x", grid.num_x        },
            {"num_z", grid.num_z        },
            {"pos",   grid.pos          },
            {"cells", Base64(grid.cells)}
        });
    }
    return {
        {"parts",     parts    },
        {"houses",    houses   },
        {"place_log", place_log},
        {"grids",     grids    }
    };
}

template <typename T>
T Number(const Json &value) {
    T out{};
    Reader::Read(value, out);
    return out;
}

template <typename T, std::size_t N>
void Numbers(const Json &value, std::array<T, N> &out) {
    if (!value.is_array() || value.size() != N) {
        Fail(SaveJsonError::BadValue);
    }
    for (std::size_t i = 0; i < N; ++i) {
        out[i] = Number<T>(value[i]);
    }
}

const Json &ArrayAt(const Reader &object, const char *name) {
    static const Json empty = Json::array();
    const Json       *found = object.Find(name);
    if (found == nullptr) {
        return empty;
    }
    if (!found->is_array()) {
        Fail(SaveJsonError::BadValue);
    }
    return *found;
}

TownLayout ReadTown(const Json &value) {
    const Reader object(value);
    TownLayout   town;
    const Json  &parts = ArrayAt(object, "parts");
    if (parts.size() > static_cast<std::size_t>(kPortEditSlotCeiling)) {
        Fail(SaveJsonError::BadValue);
    }
    for (const Json &entry : parts) {
        const Reader part_object(entry);
        TownPart     part;
        part.id = Number<s32>(part_object.At("id"));
        part.state = Number<s8>(part_object.At("state"));
        part.angle = Number<s8>(part_object.At("angle"));
        Numbers(part_object.At("pos"), part.pos);
        const Json &color = part_object.At("color");
        if (!color.is_array() || color.size() != part.color.size()) {
            Fail(SaveJsonError::BadValue);
        }
        for (std::size_t i = 0; i < part.color.size(); ++i) {
            Numbers(color[i], part.color[i]);
        }
        part.house_no = Number<s32>(part_object.At("house"));
        if (part.house_no < 0 || part.house_no > kPortEditSlotCeiling) {
            Fail(SaveJsonError::BadValue);
        }
        town.parts.push_back(part);
    }
    for (const Json &entry : ArrayAt(object, "houses")) {
        town.houses.push_back({.npc_no = Number<s16>(Reader(entry).At("npc_no"))});
    }
    if (town.houses.size() > static_cast<std::size_t>(kPortEditSlotCeiling)) {
        Fail(SaveJsonError::BadValue);
    }
    for (const Json &entry : ArrayAt(object, "place_log")) {
        std::array<s16, 2> pair{};
        Numbers(entry, pair);
        town.place_log.push_back({.parts_no = pair[0], .base_no = pair[1]});
    }
    if (town.place_log.size() > static_cast<std::size_t>(kPortEditSlotCeiling) * EDIT_MAP_LOG_PER_PARTS) {
        Fail(SaveJsonError::BadValue);
    }
    for (const Json &entry : ArrayAt(object, "grids")) {
        const Reader grid_object(entry);
        TownGrid     grid;
        grid.num_x = Number<s32>(grid_object.At("num_x"));
        grid.num_z = Number<s32>(grid_object.At("num_z"));
        Numbers(grid_object.At("pos"), grid.pos);
        const Json &cells = grid_object.At("cells");
        if (!cells.is_string() || grid.num_x < 0 || grid.num_z < 0 || grid.num_x > 0x1000 || grid.num_z > 0x1000) {
            Fail(SaveJsonError::BadValue);
        }
        grid.cells = FromBase64(cells.get_ref<const std::string &>());
        if (grid.cells.size() != static_cast<std::size_t>(grid.num_x) * static_cast<std::size_t>(grid.num_z)) {
            Fail(SaveJsonError::BadValue);
        }
        town.grids.push_back(std::move(grid));
    }
    if (town.grids.size() > EDIT_MAP_GRID_MAX) {
        Fail(SaveJsonError::BadValue);
    }
    return town;
}

OrderedJson SpawnJson(const AutosaveSpawn &spawn) {
    return {
        {"map_no",     spawn.map_no    },
        {"position",   spawn.position  },
        {"rotation",   spawn.rotation  },
        {"camera_pos", spawn.camera_pos},
        {"camera_ref", spawn.camera_ref}
    };
}

// A spot that is not usable is dropped rather than refusing the save.
std::optional<AutosaveSpawn> ReadSpawn(const Json &value, u64 counter) {
    try {
        const Reader  object(value);
        AutosaveSpawn spawn;
        spawn.counter = counter;
        spawn.map_no = Number<int>(object.At("map_no"));
        for (auto [name, vector] : {
                 std::pair{"position",   spawn.position  },
                 std::pair{"rotation",   spawn.rotation  },
                 std::pair{"camera_pos", spawn.camera_pos},
                 std::pair{"camera_ref", spawn.camera_ref}
        }) {
            std::array<float, 4> values{};
            Numbers(object.At(name), values);
            std::ranges::copy(values, vector);
        }
        return spawn;
    } catch (const Failure &) {
        return std::nullopt;
    }
}

/**
 * Parses a save file into its document, checking its format, version and checksum.
 */
Json ParseDocument(std::string_view text, bool verify) {
    if (text.size() > kSaveJsonMaxBytes) {
        Fail(SaveJsonError::BadValue);
    }
    Json document = Json::parse(text.begin(), text.end(), nullptr, false);
    if (document.is_discarded()) {
        Fail(SaveJsonError::NotJson);
    }
    if (!document.is_object()) {
        Fail(SaveJsonError::WrongSchema);
    }
    const Reader object(document);
    const Json  &format = object.At("format");
    if (!format.is_string() || format.get_ref<const std::string &>() != kFormat) {
        Fail(SaveJsonError::WrongSchema);
    }
    const Json &version = object.At("schema_version");
    if (!version.is_number_integer() || version.get<std::int64_t>() < 1) {
        Fail(SaveJsonError::WrongSchema);
    }
    const auto schema = version.get<std::int64_t>();
    if (schema > kSaveJsonSchemaVersion) {
        Fail(SaveJsonError::UnsupportedVersion);
    }
    if (verify) {
        if (const auto found = document.find("checksum"); found != document.end()) {
            if (!found->is_string()) {
                Fail(SaveJsonError::BadChecksum);
            }
            const std::string stored = found->get<std::string>();
            document.erase(found);
            if (stored != ChecksumText(document.dump())) {
                Fail(SaveJsonError::BadChecksum);
            }
        }
    }
    for (auto step = static_cast<std::size_t>(schema) - 1; step < kMigrations.size(); ++step) {
        kMigrations[step](document);
    }
    return document;
}

} // namespace

std::string SaveJsonWrite(const SaveDocument &document) {
    auto &image = const_cast<SAVEDATA_FORMAT &>(document.image);

    OrderedJson header = OrderedJson::object();
    header["version"] = kVersion;
    Writer header_writer(header);
    HeaderFields(header_writer, image);
    header["play_time"] = image.save_data.play_time;
    header["game_progress"] = image.save_data.game_progress;

    OrderedJson towns = OrderedJson::array();
    for (const TownLayout &town : document.towns) {
        towns.push_back(TownJson(town));
    }

    OrderedJson pc = OrderedJson::object();
    if (document.spawn) {
        pc["spawn"] = SpawnJson(*document.spawn);
    }

    OrderedJson root = {
        {"format",         kFormat                       },
        {"schema_version", kSaveJsonSchemaVersion        },
        {"header",         header                        },
        {"save",           Writer::Value(image.save_data)},
        {"towns",          towns                         },
        {"pc",             pc                            }
    };
    root["checksum"] = ChecksumText(Json(root).dump());
    return root.dump(2) + "\n";
}

SaveJsonError SaveJsonRead(std::string_view text, SaveDocument &document) {
    try {
        const Json   root = ParseDocument(text, true);
        const Reader object(root);

        SAVEDATA_FORMAT &image = document.image;
        std::memset(static_cast<void *>(&image), 0, sizeof(image));
        for (CEditData &data : image.save_data.edit_data) {
            data.InitPlaceData();
        }
        const Reader header(object.At("header"));
        const Json  &version = header.At("version");
        if (!version.is_string() || version.get_ref<const std::string &>() != kVersion) {
            Fail(SaveJsonError::UnsupportedVersion);
        }
        std::memcpy(image.version, kVersion, sizeof(kVersion));
        HeaderFields(header, image);
        Reader::Read(object.At("save"), image.save_data);

        document.towns = {};
        if (const Json *towns = object.Find("towns")) {
            if (!towns->is_array() || towns->size() != document.towns.size()) {
                Fail(SaveJsonError::BadValue);
            }
            for (std::size_t i = 0; i < document.towns.size(); ++i) {
                document.towns[i] = ReadTown((*towns)[i]);
            }
        }

        document.spawn.reset();
        if (const Json *pc = object.Find("pc")) {
            if (const Json *spawn = Reader(*pc).Find("spawn")) {
                document.spawn = ReadSpawn(*spawn, image.unique_counter);
            }
        }
        return SaveJsonError::None;
    } catch (const Failure &failure) {
        return failure.error;
    } catch (const nlohmann::json::exception &) {
        return SaveJsonError::BadValue;
    }
}

SaveJsonError SaveJsonReadHeader(std::string_view text, SAVEDATA_INFO &info) {
    try {
        const Json   root = ParseDocument(text, false);
        const Reader header(Reader(root).At("header"));
        info = {};
        info.state = 1;
        // The list keeps these in 16 bits, as retail's file information does.
        info.map_no = static_cast<s16>(Number<s32>(header.At("map_no")));
        info.dungeon_no = static_cast<s16>(Number<s32>(header.At("dungeon_no")));
        info.floor_id = static_cast<s16>(Number<s32>(header.At("floor_id")));
        info.progress = static_cast<s16>(Number<s32>(header.At("game_progress")));
        info.program_loop_no = static_cast<s16>(Number<s32>(header.At("program_loop_no")));
        info.omake_flag = Number<u8>(header.At("omake_flag"));
        info.debug_code = Number<s16>(header.At("debug_code"));
        info.costume_bit = Number<u64>(header.At("costume_bit"));
        info.play_time = static_cast<u64>(Number<s64>(header.At("play_time")));
        info.unique_counter = Number<u64>(header.At("unique_counter"));
        info.fish_num = Number<s32>(header.At("fish_num"));
        return SaveJsonError::None;
    } catch (const Failure &failure) {
        return failure.error;
    } catch (const nlohmann::json::exception &) {
        return SaveJsonError::BadValue;
    }
}

namespace {

std::unordered_map<const CEditData *, TownLayout> &TownStore() {
    static std::unordered_map<const CEditData *, TownLayout> store;
    return store;
}

} // namespace

TownLayout &PortTownLayout(const CEditData &data) {
    return TownStore()[&data];
}

const TownLayout *PortFindTownLayout(const CEditData &data) {
    const auto found = TownStore().find(&data);
    return found != TownStore().end() ? &found->second : nullptr;
}

void PortClearTownLayout(const CEditData &data) {
    TownStore().erase(&data);
}

TownLayout TownLayoutFromRecord(const CEditData &data) {
    TownLayout town;
    const int  parts_max = std::clamp(data.parts_max, 0, EDIT_DATA_PARTS_MAX);
    int        used = 0;
    for (int i = 0; i < parts_max; ++i) {
        if (data.parts[i].id != 0) {
            used = i + 1;
        }
    }
    // Indexes into the parts stay those of the record, so unused entries before the last used one stay too.
    for (int i = 0; i < used; ++i) {
        const EditDataParts &saved = data.parts[i];
        TownPart             part;
        part.id = saved.id;
        part.state = saved.state;
        part.angle = saved.angle;
        std::copy_n(saved.pos, 3, part.pos.begin());
        for (int c = 0; c < EDIT_DATA_COLOR_MAX; ++c) {
            std::copy_n(saved.color[c], 3, part.color[c].begin());
        }
        part.house_no = saved.house_no;
        town.parts.push_back(part);
    }
    const int house_max = std::clamp(data.house_max, 0, EDIT_DATA_HOUSE_MAX);
    for (int i = 0; i < house_max; ++i) {
        town.houses.push_back({.npc_no = data.house[i].npc_no});
    }
    for (const EditPlaceLog &entry : data.place_log) {
        if (entry.parts_no >= 0) {
            town.place_log.push_back(entry);
        }
    }
    // Each grid is its EditDataGrid header and then a byte per cell, padded to an even length.
    std::size_t offset = 0;
    while (town.grids.size() < EDIT_MAP_GRID_MAX && offset + sizeof(EditDataGrid) <= sizeof(data.grid)) {
        EditDataGrid header{};
        std::memcpy(&header, &data.grid[offset], sizeof(header));
        const std::size_t cells = static_cast<std::size_t>(header.num_x) * header.num_z;
        if (cells == 0 || offset + sizeof(EditDataGrid) + cells > sizeof(data.grid)) {
            break;
        }
        offset += sizeof(EditDataGrid);
        TownGrid grid{.num_x = header.num_x, .num_z = header.num_z, .pos = {}, .cells = {}};
        std::copy_n(header.pos, 3, grid.pos.begin());
        grid.cells.assign(data.grid + offset, data.grid + offset + cells);
        offset += cells + (cells & 1);
        town.grids.push_back(std::move(grid));
    }
    return town;
}
