// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"
#include "mw_runtime.h"

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstring>
#include <iterator>
#include <optional>
#include <stdexcept>
#include <string>
#include <variant>
#include <vector>

#include "arena_root.hpp"
#include "dataread.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menucommon.hpp"
#include "mg_memory.hpp"
#include "platform/arena.hpp"
#include "stubs/gamedata.hpp"

namespace {
/**
 * Key of the arena root holding the loaded item names.
 */
char message_root;

/**
 * Values one COM row gives a common item record.
 */
struct CommonRecord {
    int                        item_no;         /**< Item number the record describes. */
    int                        type;            /**< Item type. */
    int                        list_no;         /**< Entry of the item in its family's table. */
    int                        active_set;      /**< Non-zero when the item can be set as an active item. */
    int                        stack_num;       /**< Count one stack holds. */
    int                        max_num;         /**< Largest count one owned entry holds, before the weapon limit. */
    int                        icon_texture_no; /**< Texture of the item's icon. */
    int                        icon_no;         /**< Menu icon of the item. */
    int                        message_no;      /**< Base number of the item's messages. */
    std::optional<std::string> file_name;       /**< Base name of the item's model files, when given. */
    int                        attribute;       /**< ITEM_ATTRIBUTE bits. */
};

/**
 * Typed contents of an item_common document.
 */
struct CommonTable {
    std::optional<int>        count;   /**< COMINIT count, which also restarts the table when given. */
    std::vector<CommonRecord> records; /**< Records in table order. */
};

/**
 * Values the seven rows of one weapon give its record.
 */
struct WeaponRecord {
    int                                durability;           /**< Starting durability gauge. */
    int                                levelup_exp;          /**< Experience needed to level up. */
    std::array<int, 2>                 status;               /**< Starting first two parameters. */
    std::array<int, 2>                 status_max;           /**< Limits of the first two parameters. */
    std::array<int, 8>                 attribute;            /**< Starting attribute parameters. */
    std::array<int, 8>                 attribute_max;        /**< Limits of the attribute parameters. */
    float                              initial_fusion_point; /**< Synthesis points granted at creation. */
    int                                pallet_color;         /**< Colour palette of the model. */
    int                                unk_47;               /**< Value stored in CDataWeapon::unk_47. */
    int                                fusion_point;         /**< Synthesis points gained per level. */
    int                                special;              /**< Special ability bits. */
    std::optional<int>                 attack_type;          /**< Attack type, or none for 0. */
    std::optional<int>                 model_no;             /**< Model number, or none for 0. */
    std::array<int, 3>                 buildup_weapon;       /**< Weapons this weapon builds up into. */
    std::optional<std::array<int, 3> > buildup_monster;      /**< Monsters required to build up, when given. */
};

/**
 * Effect values one ITEM row gives a usable item.
 */
struct UsableItemRecord {
    int                item_no;      /**< Item number. */
    int                use_flags;    /**< Use effects, before the cure-all bit expands. */
    int                action_flags; /**< ITEM_ACTION_FLAG bits. */
    int                target_flags; /**< ITEM_TARGET_FLAG bits. */
    std::array<int, 3> value;        /**< Effect amounts. */
};

/**
 * Values the three rows of one attachment give its record.
 */
struct AttachmentRecord {
    std::array<int, 2> status;    /**< First two parameters added to a weapon. */
    std::array<int, 8> attribute; /**< Attribute parameters added to a weapon. */
    int                special;   /**< Special ability bits. */
};

/**
 * Values one RB_PARTS row gives a ridepod part; which are set depends on the part type.
 */
struct RidepodPartRecord {
    int                item_no;      /**< Item number. */
    int                type;         /**< Part type: 0 body, 1 arm, 2 leg, 3 energy pack. */
    int                use_capacity; /**< Energy capacity used when fitted. */
    int                offset_no;    /**< Joint and sound file number. */
    int                defence;      /**< Defence of a type 0 part. */
    int                durability;   /**< Durability of a type 1 part. */
    int                attack;       /**< Attack of a type 1 part. */
    int                durable;      /**< Durable value of a type 1 part. */
    std::array<int, 8> attribute;    /**< Attribute parameters of a type 1 part. */
    int                attack_type;  /**< Attack type of a type 1 part. */
    int                unk_4;        /**< CDataRoboPart::unk_4 of a type 2 part. */
    int                move_type;    /**< Movement type of a type 2 part. */
    int                energy;       /**< Energy of a type 3 part. */
};

/**
 * Values one FISH row gives a fish record.
 */
struct FishRecord {
    int                item_no;   /**< Item number. */
    float              size;      /**< Standard size. */
    int                unk_4;     /**< CDataBreedFish::unk_4. */
    int                battle;    /**< Base battle ability. */
    int                boost;     /**< Base boost ability. */
    int                endurance; /**< Base endurance. */
    int                tenacity;  /**< Base tenacity. */
    int                stamina;   /**< Base stamina. */
    std::optional<int> unk_10;    /**< CDataBreedFish::unk_10, when given. */
};

/**
 * Guard value one GRD row gives an item.
 */
struct GuardRecord {
    int item_no; /**< Item number. */
    int value;   /**< Guard value. */
};

/**
 * A table whose leading count command sets its loaded count independently of its rows.
 */
template <typename Row>
struct CountedTable {
    int              count; /**< Count the table's count command gives. */
    std::vector<Row> rows;  /**< Rows in script order. */
};

/**
 * Typed contents of any item table document.
 */
using ItemTable = std::variant<CommonTable, CountedTable<WeaponRecord>, CountedTable<UsableItemRecord>, CountedTable<AttachmentRecord>,
                               CountedTable<RidepodPartRecord>, CountedTable<FishRecord>, CountedTable<GuardRecord> >;

/**
 * Display name one MES_SYS row gives an item.
 */
struct ItemMessage {
    int                        item_no; /**< Item number. */
    std::optional<std::string> name;    /**< CP932 name, or none when the operand was not text. */
};

/**
 * Typed contents of an item_messages document.
 */
struct ItemMessages {
    std::vector<ItemMessage> messages; /**< Names in script order. */
};

/**
 * Reads a fixed-length integer array member.
 */
template <std::size_t N>
std::array<int, N> IntArray(const native_config::Json &object, const char *key) {
    return native_config::Ints<N>(object, key);
}

/**
 * Parses an item_common document.
 */
CommonTable ParseCommon(const native_config::Json &document) {
    using namespace native_config;
    CommonTable table{.count = OptionalInt(document, "count"), .records = {}};
    for (const auto &entry : Array(document, "records")) {
        CommonRecord record{.item_no = Int(entry, "item_no"), .type = Int(entry, "type"), .list_no = Int(entry, "list_no"), .active_set = Int(entry, "active_set"), .stack_num = Int(entry, "stack_num"), .max_num = Int(entry, "max_num"), .icon_texture_no = Int(entry, "icon_texture_no"), .icon_no = Int(entry, "icon_no"), .message_no = Int(entry, "message_no"), .file_name = OptionalText(entry, "file_name"), .attribute = Int(entry, "attribute")};
        if (record.file_name && record.file_name->size() >= sizeof(CDataCommon::file_name)) {
            throw std::runtime_error("file_name does not fit the common item record");
        }
        table.records.push_back(std::move(record));
    }
    return table;
}

/**
 * Parses a weapons document.
 */
CountedTable<WeaponRecord> ParseWeapons(const native_config::Json &document) {
    using namespace native_config;
    CountedTable<WeaponRecord> table{.count = Int(document, "count"), .rows = {}};
    for (const auto &weapon : Array(document, "weapons")) {
        const auto                        &special = At(weapon, "special");
        std::optional<std::array<int, 3> > monster;
        if (weapon.contains("buildup_monster")) {
            monster = IntArray<3>(weapon, "buildup_monster");
        }
        table.rows.push_back({.durability = Int(weapon, "durability"), .levelup_exp = Int(weapon, "levelup_exp"), .status = IntArray<2>(weapon, "status"), .status_max = IntArray<2>(weapon, "status_max"), .attribute = IntArray<8>(weapon, "attribute"), .attribute_max = IntArray<8>(weapon, "attribute_max"), .initial_fusion_point = Float(special, "initial_fusion_point"), .pallet_color = Int(special, "pallet_color"), .unk_47 = Int(special, "unk_47"), .fusion_point = Int(special, "fusion_point"), .special = Int(special, "special"), .attack_type = OptionalInt(special, "attack_type"), .model_no = OptionalInt(special, "model_no"), .buildup_weapon = IntArray<3>(weapon, "buildup_weapon"), .buildup_monster = monster});
    }
    return table;
}

/**
 * Parses an items document.
 */
CountedTable<UsableItemRecord> ParseItems(const native_config::Json &document) {
    using namespace native_config;
    CountedTable<UsableItemRecord> table{.count = Int(document, "count"), .rows = {}};
    for (const auto &item : Array(document, "items")) {
        table.rows.push_back({.item_no = Int(item, "item_no"), .use_flags = Int(item, "use_flags"), .action_flags = Int(item, "action_flags"), .target_flags = Int(item, "target_flags"), .value = IntArray<3>(item, "value")});
    }
    return table;
}

/**
 * Parses an attachments document.
 */
CountedTable<AttachmentRecord> ParseAttachments(const native_config::Json &document) {
    using namespace native_config;
    CountedTable<AttachmentRecord> table{.count = Int(document, "count"), .rows = {}};
    for (const auto &attachment : Array(document, "attachments")) {
        table.rows.push_back({.status = IntArray<2>(attachment, "status"), .attribute = IntArray<8>(attachment, "attribute"), .special = Int(attachment, "special")});
    }
    return table;
}

/**
 * Parses a ridepod_parts document, reading the fields its part type has.
 */
CountedTable<RidepodPartRecord> ParseRidepodParts(const native_config::Json &document) {
    using namespace native_config;
    CountedTable<RidepodPartRecord> table{.count = Int(document, "count"), .rows = {}};
    for (const auto &part : Array(document, "parts")) {
        RidepodPartRecord record{};
        record.item_no = Int(part, "item_no");
        record.type = Int(part, "type");
        record.use_capacity = Int(part, "use_capacity");
        record.offset_no = Int(part, "offset_no");
        switch (record.type) {
            case 0:
                record.defence = Int(part, "defence");
                break;
            case 1:
                record.durability = Int(part, "durability");
                record.attack = Int(part, "attack");
                record.durable = Int(part, "durable");
                record.attribute = IntArray<8>(part, "attribute");
                record.attack_type = Int(part, "attack_type");
                break;
            case 2:
                record.unk_4 = Int(part, "unk_4");
                record.move_type = Int(part, "move_type");
                break;
            case 3:
                record.energy = Int(part, "energy");
                break;
            default:
                break;
        }
        table.rows.push_back(record);
    }
    return table;
}

/**
 * Parses a fish document.
 */
CountedTable<FishRecord> ParseFish(const native_config::Json &document) {
    using namespace native_config;
    CountedTable<FishRecord> table{.count = Int(document, "count"), .rows = {}};
    for (const auto &fish : Array(document, "fish")) {
        table.rows.push_back({.item_no = Int(fish, "item_no"), .size = Float(fish, "size"), .unk_4 = Int(fish, "unk_4"), .battle = Int(fish, "battle"), .boost = Int(fish, "boost"), .endurance = Int(fish, "endurance"), .tenacity = Int(fish, "tenacity"), .stamina = Int(fish, "stamina"), .unk_10 = OptionalInt(fish, "unk_10")});
    }
    return table;
}

/**
 * Parses a guards document.
 */
CountedTable<GuardRecord> ParseGuards(const native_config::Json &document) {
    using namespace native_config;
    CountedTable<GuardRecord> table{.count = Int(document, "count"), .rows = {}};
    for (const auto &guard : Array(document, "guards")) {
        table.rows.push_back({.item_no = Int(guard, "item_no"), .value = Int(guard, "value")});
    }
    return table;
}

/**
 * Parses an item_messages document.
 */
ItemMessages ParseMessages(const native_config::Json &document) {
    using namespace native_config;
    ItemMessages messages;
    for (const auto &message : Array(document, "messages")) {
        messages.messages.push_back({.item_no = Int(message, "item_no"), .name = OptionalText(message, "name")});
    }
    return messages;
}

/**
 * Parser of one item table kind.
 */
struct ItemTableKind {
    const char *kind;                                        /**< Document kind. */
    ItemTable (*parse)(const native_config::Json &document); /**< Parses a document of the kind. */
};

/**
 * Parses a document with one kind's parser into the item table variant.
 */
template <auto Parse>
ItemTable ParseAs(const native_config::Json &document) {
    return Parse(document);
}

/**
 * Every item table kind LoadGameDataAnalyze accepts.
 */
constexpr std::array kItemTableKinds{
    ItemTableKind{.kind = "item_common",   .parse = ParseAs<ParseCommon>      },
    ItemTableKind{.kind = "weapons",       .parse = ParseAs<ParseWeapons>     },
    ItemTableKind{.kind = "items",         .parse = ParseAs<ParseItems>       },
    ItemTableKind{.kind = "attachments",   .parse = ParseAs<ParseAttachments> },
    ItemTableKind{.kind = "ridepod_parts", .parse = ParseAs<ParseRidepodParts>},
    ItemTableKind{.kind = "fish",          .parse = ParseAs<ParseFish>        },
    ItemTableKind{.kind = "guards",        .parse = ParseAs<ParseGuards>      },
};

/**
 * Parses an item table document of whichever item table kind it declares.
 */
ItemTable ParseItemTable(const native_config::Json &document) {
    const auto found = document.is_object() ? document.find("kind") : document.end();
    const auto kind = found != document.end() && found->is_string() ? found->get<std::string>() : std::string();
    const auto *const entry = std::ranges::find_if(kItemTableKinds, [&](const ItemTableKind &item) { return kind == item.kind; });
    if (entry == kItemTableKinds.end()) {
        native_config::CheckKind(document, "item table");
        throw std::runtime_error("configuration is not an item table document");
    }
    native_config::CheckKind(document, entry->kind);
    return entry->parse(document);
}

/**
 * Reads the highest-priority valid item table a game path names.
 */
std::optional<ItemTable> ReadItemTable(const std::string &game_name) {
    const auto  path = native_config::GamePath(game_name.c_str());
    std::string relative = path ? *path : game_name;
    if (!relative.ends_with(".json")) {
        relative += ".json";
    }
    std::vector<std::string> names;
    const auto               documents = native_config::Candidates(relative, names);
    for (std::size_t index = 0; index < documents.size(); ++index) {
        try {
            return ParseItemTable(*documents[index]);
        } catch (const std::exception &exception) {
            native_config::Report(names[index], exception.what());
        }
    }
    if (documents.empty()) {
        native_config::Report(relative, "native configuration document missing");
    }
    return std::nullopt;
}

/**
 * Whether an index lies inside an array.
 */
template <typename Array>
bool Inside(const Array &array, int index) {
    return index >= 0 && static_cast<std::size_t>(index) < std::size(array);
}

/**
 * Fills common item records through the common cursor, as COMINIT and COM do.
 */
void Apply(const CommonTable &table) {
    CGameData &data = GameItemDataManage;
    if (table.count) {
        data.common_num = static_cast<u16>(*table.count);
        comdatapt_num = 0;
        comdatapt = data.common_data;
        std::memset(local_itemdatano_converttable, -1, sizeof(local_itemdatano_converttable));
    }
    for (const auto &source : table.records) {
        // Retail runs its cursor past the 432-entry table; records past it are dropped.
        if (!Inside(local_com_itemdata, comdatapt_num)) {
            continue;
        }
        CDataCommon &record = local_com_itemdata[comdatapt_num];
        record.item_no = static_cast<s16>(source.item_no);
        record.type = static_cast<u8>(source.type);
        record.list_no = static_cast<s16>(source.list_no);
        record.active_set = static_cast<u8>(source.active_set);
        record.stack_num = static_cast<s16>(source.stack_num);
        record.max_num = static_cast<u16>(source.max_num);
        if (ConvertUsedItemType(record.type) == USED_ITEM_TYPE_WEAPON && record.max_num > 0x64) {
            record.max_num = 0x90;
        }
        record.icon_texture_no = static_cast<u8>(source.icon_texture_no);
        record.icon_no = static_cast<s16>(source.icon_no);
        record.message_no = static_cast<s16>(source.message_no);
        if (source.file_name) {
            std::memcpy(record.file_name, source.file_name->c_str(), source.file_name->size() + 1);
        }
        record.attribute = static_cast<u32>(source.attribute);
        record.name = nullptr;
        // Retail indexes the item-number lookup unchecked.
        if (Inside(local_itemdatano_converttable, record.item_no)) {
            local_itemdatano_converttable[record.item_no] = static_cast<short>(comdatapt_num);
        }
        comdatapt = &record + 1;
        ++comdatapt_num;
    }
}

/**
 * Stores integers into a short array.
 */
template <std::size_t N>
void CopyValues(s16 (&target)[N], const std::array<int, N> &source) {
    for (std::size_t index = 0; index < N; ++index) {
        target[index] = static_cast<s16>(source[index]);
    }
}

/**
 * Fills weapon records through the weapon cursor, as WEPNUM and the WEP rows do.
 */
void Apply(const CountedTable<WeaponRecord> &table) {
    CGameData &data = GameItemDataManage;
    data.weapon_num = static_cast<u16>(table.count);
    SpiWeaponPt = data.weapon_data;
    for (const auto &source : table.rows) {
        if (SpiWeaponPt == nullptr) {
            break;
        }
        CDataWeapon &weapon = *SpiWeaponPt;
        weapon.durability = static_cast<s16>(source.durability);
        weapon.levelup_exp = static_cast<s16>(source.levelup_exp);
        CopyValues(weapon.status, source.status);
        CopyValues(weapon.status_max, source.status_max);
        CopyValues(weapon.attribute, source.attribute);
        CopyValues(weapon.attribute_max, source.attribute_max);
        weapon.initial_fusion_point = static_cast<u8>(fptoui(source.initial_fusion_point));
        weapon.pallet_color = static_cast<u8>(source.pallet_color);
        weapon.unk_47 = static_cast<u8>(source.unk_47);
        weapon.fusion_point = static_cast<u8>(source.fusion_point);
        weapon.special = static_cast<u32>(source.special);
        weapon.attack_type = static_cast<u8>(source.attack_type.value_or(0));
        weapon.model_no = static_cast<u8>(source.model_no.value_or(0));
        CopyValues(weapon.buildup_weapon, source.buildup_weapon);
        if (source.buildup_monster) {
            CopyValues(weapon.buildup_monster, *source.buildup_monster);
        }
        // Retail advances the cursor past the 116-entry table; it becomes null at the table's end.
        if (++SpiWeaponPt == std::end(local_weapondata)) {
            SpiWeaponPt = nullptr;
        }
    }
}

/**
 * Fills usable item records by item number, as ITEMINIT and ITEM do.
 */
void Apply(const CountedTable<UsableItemRecord> &table) {
    CGameData &data = GameItemDataManage;
    data.item_num = static_cast<u16>(table.count);
    SpiItemPt = data.item_data;
    for (const auto &source : table.rows) {
        SpiItemPt = GetItemInfoData(source.item_no);
        if (SpiItemPt == nullptr) {
            continue;
        }
        auto flags = static_cast<u32>(source.use_flags);
        if ((flags & ITEM_USE_FLAG_CURE_ALL) != 0) {
            flags = (flags & ~ITEM_USE_FLAG_CURE_ALL) | ITEM_USE_FLAG_CURE_STOP | ITEM_USE_FLAG_CURE_POISON | ITEM_USE_FLAG_CURE_CURSE |
                    ITEM_USE_FLAG_CURE_SLOW | ITEM_USE_FLAG_CURE_STONE | ITEM_USE_FLAG_CURE_DRY;
        }
        SpiItemPt->use_flags = flags;
        SpiItemPt->action_flags = static_cast<u32>(source.action_flags);
        SpiItemPt->target_flags = static_cast<u16>(source.target_flags);
        CopyValues(SpiItemPt->value, source.value);
    }
}

/**
 * Fills attachment records through the attachment cursor, as AT_INIT and the AT rows do.
 */
void Apply(const CountedTable<AttachmentRecord> &table) {
    CGameData &data = GameItemDataManage;
    data.attach_num = static_cast<u16>(table.count);
    SpiAttach = data.attach_data;
    for (const auto &source : table.rows) {
        if (SpiAttach == nullptr) {
            break;
        }
        CopyValues(SpiAttach->status, source.status);
        CopyValues(SpiAttach->attribute, source.attribute);
        SpiAttach->special = static_cast<u32>(source.special);
        // Retail advances the cursor past the 38-entry table; it becomes null at the table's end.
        if (++SpiAttach == std::end(local_attachdata)) {
            SpiAttach = nullptr;
        }
    }
}

/**
 * Fills ridepod part records by item number, as ROBOINIT and RB_PARTS do.
 */
void Apply(const CountedTable<RidepodPartRecord> &table) {
    CGameData &data = GameItemDataManage;
    data.robo_num = static_cast<u16>(table.count);
    SpiRoboPart = data.robo_data;
    for (const auto &source : table.rows) {
        SpiRoboPart = data.GetRoboData(source.item_no);
        if (SpiRoboPart == nullptr) {
            continue;
        }
        CDataRoboPart &part = *SpiRoboPart;
        part.use_capacity = static_cast<s16>(source.use_capacity);
        part.offset_no = static_cast<u8>(source.offset_no);
        switch (source.type) {
            case 0:
                part.defence = static_cast<s16>(source.defence);
                break;
            case 1:
                part.durability = static_cast<s16>(source.durability);
                part.attack = static_cast<s16>(source.attack);
                part.durable = static_cast<s16>(source.durable);
                CopyValues(part.attribute, source.attribute);
                part.attack_type = static_cast<s16>(source.attack_type);
                break;
            case 2:
                part.unk_4 = static_cast<s16>(source.unk_4);
                part.move_type = static_cast<s16>(source.move_type);
                break;
            case 3:
                part.energy = static_cast<s16>(source.energy);
                break;
            default:
                break;
        }
        ++SpiRoboPart;
    }
}

/**
 * Fills fish records by item number, as FISHINIT and FISH do.
 */
void Apply(const CountedTable<FishRecord> &table) {
    CGameData &data = GameItemDataManage;
    data.fish_num = static_cast<u16>(table.count);
    SpiFish = data.fish_data;
    for (const auto &source : table.rows) {
        SpiFish = data.GetFishData(source.item_no);
        if (SpiFish == nullptr) {
            continue;
        }
        SpiFish->size = source.size;
        SpiFish->unk_4 = static_cast<s16>(source.unk_4);
        SpiFish->battle = static_cast<u16>(source.battle);
        SpiFish->boost = static_cast<u16>(source.boost);
        SpiFish->endurance = static_cast<u16>(source.endurance);
        SpiFish->tenacity = static_cast<u16>(source.tenacity);
        SpiFish->stamina = static_cast<u16>(source.stamina);
        if (source.unk_10) {
            SpiFish->unk_10 = static_cast<s16>(*source.unk_10);
        }
    }
}

/**
 * Fills guard values by item number, as GRDNUM and GRD do.
 */
void Apply(const CountedTable<GuardRecord> &table) {
    CGameData &data = GameItemDataManage;
    data.guard_num = static_cast<u16>(table.count);
    for (const auto &source : table.rows) {
        if (s16 *guard = data.GetGuardData(source.item_no)) {
            *guard = static_cast<s16>(source.value);
        }
    }
}

/**
 * Copies an item name into the message arena, converting font codes for the languages that use them.
 */
char *CopyItemName(std::optional<std::string> name, mgCMemory *memory) {
    if (LanguageCode >= 2 && LanguageCode < 6) {
        // ConvertFontCode only shortens text, so the source length bounds the result.
        std::vector<char> converted(std::max<std::size_t>(0x100, name ? name->size() + 1 : 0), '\0');
        if (name) {
            ConvertFontCode(name->data(), converted.data());
        }
        return mgCopyString(converted.data(), memory);
    }
    return mgCopyString(name ? name->data() : nullptr, memory);
}

} // namespace

PORT_OVERRIDE int LoadGameDataAnalyze(char *name) {
    if (name == nullptr) {
        return 0;
    }
    SetCurrentDir(nullptr);
    const auto table = ReadItemTable("menu/cfg7/" + std::string(name));
    if (!table) {
        return 0;
    }
    std::visit([](const auto &contents) { Apply(contents); }, *table);
    return 1;
}

PORT_OVERRIDE int CGameData::LoadItemSystemMes(int language) {
    // Cleared here on every language load: cursor rebinding elsewhere must keep live sound records.
    auto *root = ArenaRoot(&message_root, 0x280, "ItemMessages");
    std::memset(root, 0, 0x2800 * kArenaHeadroom);
    mgCMemory memory;
    memory.stSetBuffer(root, 0x280 * kArenaHeadroom);
    const auto path = "menu/cfg7/comdatmes" + std::to_string(language) + ".cfg.json";
    if (auto messages = native_config::ReadGame<ItemMessages>(path.c_str(), "item_messages", ParseMessages)) {
        for (auto &message : messages->messages) {
            if (CDataCommon *record = GameItemDataManage.GetCommonData(message.item_no)) {
                record->name = CopyItemName(std::move(message.name), &memory);
            }
        }
    }
    return 1;
}
