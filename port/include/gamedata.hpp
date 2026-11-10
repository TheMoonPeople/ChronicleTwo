#pragma once

#include "common.h"

#include <optional>
#include <string>

/**
 * @file
 * Declares the master item tables read from the menu configuration scripts (common, weapon, item,
 * attachment, ridepod part, fish and guard data), the per-kind data an owned item carries, the
 * parameter record of a monster kind, and the accessors the rest of the game uses to look an item
 * number up in them.
 */

/**
 *
 * Identifies the family of an item, as ConvertUsedItemType derives it from the item's type.
 *
 */
enum USED_ITEM_TYPE {
    USED_ITEM_TYPE_NONE = 0,      /**< No item, or a type outside every family. */
    USED_ITEM_TYPE_ITEM = 1,      /**< A usable or key item with an entry in the item table. */
    USED_ITEM_TYPE_ATTACH = 2,    /**< An attachment with an entry in the attachment table. */
    USED_ITEM_TYPE_WEAPON = 3,    /**< A weapon with an entry in the weapon table. */
    USED_ITEM_TYPE_COSTUME = 4,   /**< A piece of clothing, headwear, footwear or accessory with only common data. */
    USED_ITEM_TYPE_ROBO_PART = 5, /**< A ridepod part with an entry in the ridepod part table. */
    USED_ITEM_TYPE_FISH = 6,      /**< A fish with an entry in the fish table. */
    USED_ITEM_TYPE_GIFT_BOX = 7,  /**< A gift box with an entry in the item table. */
    USED_ITEM_TYPE_BOILED = 8,    /**< A boiled item with an entry in the item table. */
};

/**
 *
 * Indices of the first two parameters of a weapon, attachment or ridepod part.
 *
 */
enum WEAPON_STAT {
    WEAPON_STAT_ATTACK = 0,     /**< Attack. */
    WEAPON_STAT_DURABILITY = 1, /**< Durable, the second parameter. */
};

/**
 *
 * Special ability bits of weapons and attachments, which collision primitives also carry as hit
 * attributes of attacks.
 *
 */
enum WEAPON_SPECIAL_FLAG {
    WEAPON_SPECIAL_WEALTH = 0x1,          /**< More money from defeated monsters (Wealth Coin). */
    WEAPON_SPECIAL_LESS_MONEY = 0x2,      /**< Less money from defeated monsters. */
    WEAPON_SPECIAL_POISON = 0x4,          /**< The hit can poison. */
    WEAPON_SPECIAL_STOP = 0x8,            /**< The hit can stop the target (Time Coin). */
    WEAPON_SPECIAL_STEAL = 0x10,          /**< The hit can steal an item. */
    WEAPON_SPECIAL_INCREASE_WEAR = 0x20,  /**< The weapon wears out faster. */
    WEAPON_SPECIAL_REDUCE_WEAR = 0x40,    /**< The weapon wears out slower (Indestructible Coin). */
    WEAPON_SPECIAL_DRAIN_HP = 0x80,       /**< The hit drains health (Absorption Coin). */
    WEAPON_SPECIAL_REGENERATE_HP = 0x100, /**< Health regenerates (Healing Coin). */
    WEAPON_SPECIAL_HP_COST_BOOST = 0x200, /**< Stronger hits that cost health (Dark Coin). */
    WEAPON_SPECIAL_CRITICAL = 0x400,      /**< Critical hits are more likely (Bull's-Eye Coin). */
    WEAPON_SPECIAL_ABS_UP = 0x800,        /**< More absorption from defeated monsters (Experience Coin). */
    WEAPON_SPECIAL_RATIO_DAMAGE = 0x1000, /**< The hit takes a percentage of the target's maximum health. */
    WEAPON_SPECIAL_HALF_HP = 0x2000,      /**< The hit takes half of the target's current health. */
    WEAPON_SPECIAL_STONE = 0x8000,        /**< The hit can petrify. */
    WEAPON_SPECIAL_SLOW = 0x10000,        /**< The hit can cover the target in goo and slow it. */
    WEAPON_SPECIAL_CURSE = 0x20000,       /**< The hit can curse. */
    WEAPON_SPECIAL_HOLY_WATER = 0x40000,  /**< The hit is holy water. */
    WEAPON_SPECIAL_BADGE_DROP = 0x80000,  /**< A killing hit with this bit makes monster 0xDC drop its badge while a Badge Box is held. */
    WEAPON_SPECIAL_DRY = 0x100000,        /**< The hit can make the target thirsty. */
};

/**
 *
 * Item numbers the code treats specially, named after the items' English names.
 *
 */
enum ITEM_ID {
    ITEM_ID_LAMBS_SWORD = 0x38,          /**< Lamb's Sword, Monica's sword whose strength follows the time of day. */
    ITEM_ID_ISLAND_KING = 0x58,          /**< Island King, Monica's sword whose model changes with the time of day. */
    ITEM_ID_DRUM_CAN_BODY = 0x87,        /**< Drum Can Body, the first ridepod body. */
    ITEM_ID_CANNONBALL_ARM = 0x91,       /**< Cannonball Arm, the first ridepod arm. */
    ITEM_ID_IRON_LEG = 0x9B,             /**< Iron Leg, the first ridepod leg. */
    ITEM_ID_ENERGY_PACK = 0xA5,          /**< Energy Pack, the first ridepod energy pack. */
    ITEM_ID_MONSTER_NOTES = 0xAC,        /**< Monster Notes. */
    ITEM_ID_SEAL_BREAKING_SCROLL = 0xAE, /**< Seal-Breaking Scroll. */
    ITEM_ID_SPECTOL = 0xB9,              /**< Attachment made by spectrumising an item. */
    ITEM_ID_CORE = 0xF6,                 /**< Core, the first ridepod core. */
    ITEM_ID_IMPROVED_CORE = 0xF7,        /**< Improved Core. */
    ITEM_ID_CORE_II = 0xF8,              /**< Core II. */
    ITEM_ID_CORE_III = 0xF9,             /**< Core III. */
    ITEM_ID_SUPER_CORE = 0xFA,           /**< Super Core. */
    ITEM_ID_HYPER_CORE = 0xFB,           /**< Hyper Core. */
    ITEM_ID_MASTER_GRADE_CORE = 0xFC,    /**< Master Grade Core, the last ridepod core. */
    ITEM_ID_ANTI_PETRIFY_AMULET = 0xFD,  /**< Anti-Petrify Amulet, which wards off petrification. */
    ITEM_ID_NON_STOP_AMULET = 0xFE,      /**< Non-Stop Amulet, which wards off being stopped. */
    ITEM_ID_ANTI_CURSE_AMULET = 0xFF,    /**< Anti-Curse Amulet, which wards off curses. */
    ITEM_ID_ANTI_GOO_AMULET = 0x100,     /**< Anti-Goo Amulet, which wards off goo. */
    ITEM_ID_ANTIDOTE_AMULET = 0x101,     /**< Antidote Amulet, which wards off poison. */
    ITEM_ID_DOUBLE_PUDDING = 0x10F,      /**< Double Pudding. */
    ITEM_ID_PLUM_RICE_BALL = 0x110,      /**< Plum Rice Ball, the food that can be eaten while thirsty. */
    ITEM_ID_RESURRECTION_POWDER = 0x111, /**< Resurrection Powder, which revives a fallen character. */
    ITEM_ID_STAMINA_DRINK = 0x112,       /**< Stamina Drink. */
    ITEM_ID_HEART_THROB_CHERRY = 0x11F,  /**< Heart-Throb Cherry. */
    ITEM_ID_MELLOW_BANANA = 0x124,       /**< Mellow Banana. */
    ITEM_ID_ESCAPE_POWDER = 0x125,       /**< Escape Powder. */
    ITEM_ID_MELEE_REPAIR = 0x126,        /**< Repair Powder, which repairs melee weapons. */
    ITEM_ID_LEVEL_UP_POWDER = 0x127,     /**< Level Up Powder, which levels a weapon up. */
    ITEM_ID_FRUIT_OF_EDEN = 0x128,       /**< Fruit of Eden, which raises a character's maximum health. */
    ITEM_ID_GUN_REPAIR = 0x12A,          /**< Gun Repair Powder, which repairs Max's guns. */
    ITEM_ID_FISHING_ROD = 0x12E,         /**< Fishing Rod. */
    ITEM_ID_LURE_ROD = 0x12F,            /**< Lure Rod. */
    ITEM_ID_GIFT_CAPSULE = 0x130,        /**< Gift Capsule, which is thrown with the items it holds. */
    ITEM_ID_MAP = 0x131,                 /**< Map, which reveals the rooms of a dungeon floor. */
    ITEM_ID_MAGIC_CRYSTAL = 0x132,       /**< Magic Crystal, which reveals the symbols of a dungeon floor. */
    ITEM_ID_BADGE_BOX = 0x134,           /**< Badge Box, which enables the monster transformation. */
    ITEM_ID_AQUARIUM = 0x135,            /**< Aquarium. */
    ITEM_ID_MEDAL_HOLDER = 0x137,        /**< Medal Holder, whose count is the number of medals. */
    ITEM_ID_ROPE = 0x159,                /**< Rope, a gate key of the fourth dungeon. */
    ITEM_ID_WHITE_WIND_VASE = 0x15B,     /**< White Wind Vase, a door key of the fourth dungeon. */
    ITEM_ID_MAGIC_REPAIR = 0x160,        /**< Armband Repair Powder, which repairs Monica's armbands. */
    ITEM_ID_INSIDE_SCOOP_MEMO = 0x163,   /**< Inside Scoop Memo. */
    ITEM_ID_PHOTO_ALBUM = 0x165,         /**< Photo Album, which enables the album page. */
    ITEM_ID_COOKING_STOVE = 0x166,       /**< Cooking Stove, which enables boiling fish. */
    ITEM_ID_HELP_RECEIVER = 0x167,       /**< Help Receiver, which enables the manual menu. */
    ITEM_ID_ELECTRIC_WORM = 0x168,       /**< Electric Worm, the food of electric fish. */
    ITEM_ID_CAMERA = 0x171,              /**< Camera, which takes photos and enables the invention menu. */
    ITEM_ID_RIDEPOD_FUEL = 0x17D,        /**< Ridepod Fuel. */
    ITEM_ID_MONSTER_DROP = 0x17F,        /**< Monster Drop. */
    ITEM_ID_NAME_CHANGE_TICKET = 0x180,  /**< Name-Change Ticket, which enables renaming weapons and ridepod parts. */
    ITEM_ID_NOTEBOOK = 0x182,            /**< Notebook. */
    ITEM_ID_POTATO_PIE = 0x184,          /**< Potato Pie, which raises Max's defence. */
    ITEM_ID_WITCH_PARFAIT = 0x185,       /**< Witch Parfait, which raises Monica's defence. */
    ITEM_ID_SHIELD_KIT = 0x1A7,          /**< Shield Kit, which gives the ridepod a shield. */
    ITEM_ID_BOILED_FISH = 0x1AA,         /**< Fish cooked on the Cooking Stove. */
};

/**
 *
 * Item types, as CDataCommon::type holds them; ConvertUsedItemType gives the family of each.
 *
 */
enum ITEM_DATA_TYPE {
    ITEM_DATA_NONE = 0,              /**< No item. */
    ITEM_DATA_MAX_MELEE = 1,         /**< Max's wrenches and hammers. */
    ITEM_DATA_MAX_GUN = 2,           /**< Max's guns. */
    ITEM_DATA_MONICA_MELEE = 3,      /**< Monica's swords. */
    ITEM_DATA_MONICA_MAGIC = 4,      /**< Monica's armbands. */
    ITEM_DATA_MAX_CLOTHES = 5,       /**< Max's outfits. */
    ITEM_DATA_MAX_HAT = 6,           /**< Max's hats. */
    ITEM_DATA_MAX_SHOES = 7,         /**< Max's shoes. */
    ITEM_DATA_MONICA_CLOTHES = 8,    /**< Monica's outfits. */
    ITEM_DATA_MONICA_ACCESSORY = 9,  /**< Monica's ribbons and hair accessories. */
    ITEM_DATA_MONICA_BOOTS = 10,     /**< Monica's boots. */
    ITEM_DATA_ROBO_CORE = 11,        /**< Ridepod cores. */
    ITEM_DATA_ROBO_BODY = 12,        /**< Ridepod bodies. */
    ITEM_DATA_ROBO_ARM = 13,         /**< Ridepod arms. */
    ITEM_DATA_ROBO_LEG = 14,         /**< Ridepod legs. */
    ITEM_DATA_ROBO_ENERGY_PACK = 15, /**< Ridepod energy packs. */
    ITEM_DATA_CRYSTAL = 16,          /**< Crystal attachments. */
    ITEM_DATA_SPECTOL = 17,          /**< Attachments made by spectrumising an item. */
    ITEM_DATA_GEM = 18,              /**< Gem attachments. */
    ITEM_DATA_COIN = 19,             /**< Coin attachments, which give special abilities. */
    ITEM_DATA_GEORAMA_MATERIAL = 20, /**< Georama materials. */
    ITEM_DATA_BADGE_BOX = 21,        /**< The Badge Box. */
    ITEM_DATA_RECOVERY = 22,         /**< Food, drinks and remedies. */
    ITEM_DATA_THROWING = 23,         /**< Bombs, stones and fruit that are thrown. */
    ITEM_DATA_POWDER = 24,           /**< Powders and the ridepod fuel. */
    ITEM_DATA_AMULET = 25,           /**< Amulets that ward off status conditions. */
    ITEM_DATA_DUNGEON_KEY = 26,      /**< Gate and door keys of the dungeons. */
    ITEM_DATA_KEY_ITEM = 27,         /**< Story items. */
    ITEM_DATA_GIFT_BOX = 28,         /**< The Gift Capsule. */
    ITEM_DATA_AQUARIUM = 29,         /**< The Aquarium. */
    ITEM_DATA_FISH = 30,             /**< Fish. */
    ITEM_DATA_LURE = 32,             /**< Lures, which fit only the Lure Rod. */
    ITEM_DATA_ETC = 33,              /**< Other items, such as maps, baits and tickets. */
    ITEM_DATA_MONSTER_DROP = 34,     /**< The Monster Drop attachment. */
    ITEM_DATA_BOILED = 35,           /**< Boiled fish. */
};

/**
 *
 * Bits of CDataCommon::attribute.
 *
 */
enum ITEM_ATTRIBUTE {
    ITEM_ATTRIBUTE_TRUSH = 0x1,            /**< The item counts as rubbish. */
    ITEM_ATTRIBUTE_SPECTOL_TRANS = 0x2,    /**< The item can be turned into an attachment by spectrumising. */
    ITEM_ATTRIBUTE_BAIT = 0x4,             /**< The item fits the bait slot of a fishing rod. */
    ITEM_ATTRIBUTE_GEORAMA_MATERIA = 0x10, /**< The item is listed among a dungeon floor's georama materials. */
    ITEM_ATTRIBUTE_USABLE = 0x20,          /**< The item has use effects that the menus show. */
    ITEM_ATTRIBUTE_UNIQUE = 0x40,          /**< Only max_num of the item can be held, counting every place. */
};

/**
 *
 * Bits of CDataItem::action_flags and USEITEM_EFFECT::action_flags: how an item is used.
 *
 */
enum ITEM_ACTION_FLAG {
    ITEM_ACTION_USE = 0x1,         /**< The item is used on its target. */
    ITEM_ACTION_THROW = 0x2,       /**< The item is thrown. */
    ITEM_ACTION_THROW_ALT = 0x4,   /**< The item is thrown; no item in the tables has this bit. */
    ITEM_ACTION_DRINK_WATER = 0x8, /**< The item is drunk as water, with the eating effect. */
    ITEM_ACTION_EAT = 0x10,        /**< Food, unusable by a fallen character; thirst blocks it except for Plum Rice Ball. */
};

/**
 *
 * Bits of CDataItem::target_flags and USEITEM_EFFECT::target_flags: what an item can be used on.
 *
 */
enum ITEM_TARGET_FLAG {
    ITEM_TARGET_MAX = 0x2,     /**< Max. */
    ITEM_TARGET_MONICA = 0x4,  /**< Monica. */
    ITEM_TARGET_RIDEPOD = 0x8, /**< The ridepod. */
    ITEM_TARGET_WEAPON = 0x20, /**< An owned weapon. */
    ITEM_TARGET_ENEMY = 0x40,  /**< Monsters, by throwing the item. */
};

/**
 *
 * Limits of the master item tables.
 *
 */
enum {
    ITEM_NO_MAX = 0x200,        /**< Item numbers the item number conversion table covers. */
    ITEM_COMMON_DATA_MAX = 432, /**< Entries of the common item data. */
};

/**
 *
 * Bits of BASE_MONSTER_TBL::flags.
 *
 */
enum MONSTER_TBL_FLAG {
    MONSTER_TBL_FLAG_NO_STAGGER = 0x1, /**< Hits never make the monster flinch. */
    MONSTER_TBL_FLAG_NO_KNOCK = 0x4,   /**< Hits never knock the monster back. */
};

/**
 *
 * Bits of BASE_MONSTER_TBL::lift_flags.
 *
 */
enum MONSTER_LIFT_FLAG {
    MONSTER_LIFT_FORBIDDEN = 0x1, /**< The monster cannot be lifted. */
};

/**
 *
 * Bits of CDataItem::use_flags and USEITEM_EFFECT::use_flags.
 *
 */
// clang-format off
enum ITEM_USE_FLAG {
    ITEM_USE_FLAG_ELEMENT_FIRE = 0x1,      /**< A thrown item that does fire damage. */
    ITEM_USE_FLAG_ELEMENT_ICE = 0x2,       /**< A thrown item that does ice damage. */
    ITEM_USE_FLAG_ELEMENT_THUNDER = 0x4,   /**< A thrown item that does thunder damage. */
    ITEM_USE_FLAG_ELEMENT_HOLY = 0x8,      /**< A thrown item that does holy damage. */
    ITEM_USE_FLAG_ELEMENT_WIND = 0x20,     /**< A thrown item that does wind damage. */
    ITEM_USE_FLAG_RESTORE_HP = 0x100,      /**< Restores health. */
    ITEM_USE_FLAG_REPAIR = 0x400,          /**< Restores durability. */
    ITEM_USE_FLAG_FILL_ABS = 0x1000,       /**< Fills the absorption gauge of a weapon. */
    ITEM_USE_FLAG_ADD_STOP = 0x4000,       /**< Stops the target (CHARA_STATUS_STOP). */
    ITEM_USE_FLAG_CURE_STOP = 0x8000,      /**< Cures being stopped (CHARA_STATUS_STOP). */
    ITEM_USE_FLAG_ADD_POISON = 0x10000,            /**< Adds poison. */
    ITEM_USE_FLAG_CURE_POISON = 0x20000,           /**< Cures poison. */
    ITEM_USE_FLAG_ADD_CURSE = 0x40000,      /**< Curses the target (CHARA_STATUS_CURSE). */
    ITEM_USE_FLAG_CURE_CURSE = 0x80000,     /**< Cures a curse (CHARA_STATUS_CURSE). */
    ITEM_USE_FLAG_ADD_SLOW = 0x100000,     /**< Adds CHARA_STATUS_SLOW. */
    ITEM_USE_FLAG_CURE_SLOW = 0x200000,    /**< Cures CHARA_STATUS_SLOW. */
    ITEM_USE_FLAG_ADD_POWER = 0x400000,            /**< Adds the power status. */
    ITEM_USE_FLAG_CURE_ALL = 0x800000,             /**< Expands to the individual status cure effects when loaded. */
    ITEM_USE_FLAG_CORE_CAPACITY = 0x01000000, /**< Sets the ridepod's energy capacity, for cores. */
    ITEM_USE_FLAG_ADD_STONE = 0x02000000,  /**< Petrifies the target (CHARA_STATUS_STONE). */
    ITEM_USE_FLAG_CURE_STONE = 0x04000000, /**< Cures petrification (CHARA_STATUS_STONE). */
    ITEM_USE_FLAG_ADD_DRY = 0x08000000,  /**< Makes the target thirsty (CHARA_STATUS_DRY). */
    ITEM_USE_FLAG_CURE_DRY = 0x10000000, /**< Cures thirst (CHARA_STATUS_DRY). */
};

// clang-format on

/**
 *
 * Identifies what a CItemUseTarget points at.
 *
 */
enum ITEM_USE_TARGET_TYPE {
    ITEM_USE_TARGET_CHARA = 0,   /**< A character's status. */
    ITEM_USE_TARGET_ITEM = 1,    /**< An owned item, a CGameDataUsed. */
    ITEM_USE_TARGET_ROBO = 2,    /**< The ridepod. */
    ITEM_USE_TARGET_MONSTER = 3, /**< The monster transformation. */
    ITEM_USE_TARGET_NONE = -1,   /**< No target. */
};

/**
 *
 * Holds the data every item number has, whatever its family; the entry for an item number is found
 * through the item number conversion table.
 *
 */
struct CDataCommon {
    u8    type; /**< Item type, from which ConvertUsedItemType gives the family. */
    u8    unk_1;
    s16   item_no;       /**< Item number of this entry. */
    s16   list_no;       /**< Index of the item's entry in the table of its family. */
    s16   icon_no;       /**< Number of the item's menu icon. */
    s16   message_no;    /**< Base number of the item's messages. */
    u16   max_num;       /**< Largest count of the item one owned entry can hold. */
    char  file_name[16]; /**< Base name of the item's model files. */
    u8    active_set;    /**< Non-zero when the item can be set as an active item. */
    u8    unk_1d;
    s16   stack_num;       /**< Count of the item one stack can hold. */
    u8    icon_texture_no; /**< Number of the texture used for the item icon. */
    u8    unk_21[3];
    u32   attribute; /**< ITEM_ATTRIBUTE bits. */
    char *name;      /**< Display name of the item, from the item message script. */
};

STATIC_ASSERT(sizeof(CDataCommon) == 0x2C);

/**
 *
 * Holds the effect data of a usable item.
 *
 */
class CDataItem {
public:
    u32 action_flags;   /**< ITEM_ACTION_FLAG bits: how the item is used. */
    u32 use_flags;      /**< Effects the item has when used. */
    u16 target_flags{}; /**< ITEM_TARGET_FLAG bits: what the item can be used on. */
    s16 value[3]{};     /**< Amounts of the item's effects. */

    /**
     *
     * Clears the effect data of the item.
     *
     * @mangled __ct__9CDataItemFv
     * @address 0x195A10
     * @size 0x1C
     */
    CDataItem();
};

STATIC_ASSERT(sizeof(CDataItem) == 0x10);

/**
 *
 * Holds the base parameters of an attachment.
 *
 */
class CDataAttach {
public:
    s16 status[2]{};    /**< First two parameters the attachment adds to a weapon. */
    s16 attribute[8]{}; /**< Attribute parameters the attachment adds to a weapon. */
    u32 special{};      /**< Special ability bits the attachment gives. */

    /**
     *
     * Clears the attachment data.
     *
     * @mangled __ct__11CDataAttachFv
     * @address 0x195A30
     * @size 0x30
     */
    CDataAttach();
};

STATIC_ASSERT(sizeof(CDataAttach) == 0x18);

/**
 *
 * Holds the base parameters, limits and build-up data of a weapon.
 *
 */
class CDataWeapon {
public:
    s16 durability;         /**< Durability gauge a new copy of the weapon starts with. */
    s16 levelup_exp;        /**< Experience needed to level up, grown by half of itself per level. */
    s16 status[2]{};        /**< Starting values of the first two parameters. */
    s16 status_max[2]{};    /**< Limits of the first two parameters. */
    s16 attribute[8]{};     /**< Starting values of the attribute parameters. */
    s16 attribute_max[8]{}; /**< Limits of the attribute parameters. */
    u32 special{};          /**< Special ability bits the weapon starts with. */
    u8  unk_30[8]{};
    u8  initial_fusion_point{}; /**< Synthesis points granted when the weapon is created. */
    u8  fusion_point{};         /**< Synthesis points the weapon gains at each level-up. */
    s16 buildup_weapon[3]{};    /**< Item numbers of the weapons this weapon can build up into. */
    s16 buildup_monster[3]{};   /**< Monsters that must have been defeated to build up, or negative for none. */
    u8  pallet_color{};         /**< Colour palette of the weapon's model. */
    u8  unk_47{};
    u8  attack_type{}; /**< Attack type of the weapon. @see WEAPON_ATTACK_TYPE */
    u8  model_no{};    /**< Model number of the weapon. */
    u8  unk_4a[2]{};

    /**
     *
     * Clears the weapon data and sets the default durability and level-up experience.
     *
     * @mangled __ct__11CDataWeaponFv
     * @address 0x195A60
     * @size 0x3C
     */
    CDataWeapon();
};

STATIC_ASSERT(sizeof(CDataWeapon) == 0x4C);

/**
 *
 * Holds the base parameters of a ridepod part.
 *
 */
class CDataRoboPart {
public:
    s16 use_capacity; /**< Energy capacity the part uses when fitted. */
    s16 energy;       /**< Energy provided by the robot part. */
    s16 unk_4;
    s16 durability; /**< Durability of the robot part. */
    s16 attack;
    s16 durable;
    s16 attribute[8];
    s16 defence; /**< Defence provided by the robot part. */
    s16 attack_type;
    s16 move_type;
    u8  offset_no; /**< Number of the joint and sound files of the part. */
    u8  unk_23;

    /**
     *
     * Gives the number of the joint and sound files of the part.
     *
     * @mangled GetOffsetNo__13CDataRoboPartFv
     * @address 0x195AA0
     * @size 0x8
     */
    int GetOffsetNo();
};

STATIC_ASSERT(sizeof(CDataRoboPart) == 0x24);

/**
 *
 * Holds the base parameters of a fish that can be bred or raced.
 *
 */
class CDataBreedFish {
public:
    float size{}; /**< Standard size of the fish. */
    s16   unk_4{};
    u16   battle{};    /**< Base battle ability of the fish. */
    u16   stamina{};   /**< Base stamina of the fish. */
    u16   boost{};     /**< Base boost ability of the fish. */
    u16   endurance{}; /**< Base endurance of the fish. */
    u16   tenacity{};  /**< Base tenacity of the fish. */
    s16   unk_10{};
    s16   unk_12{};

    /**
     *
     * Clears the fish data.
     *
     * @mangled __ct__14CDataBreedFishFv
     * @address 0x195AB0
     * @size 0x30
     */
    CDataBreedFish();
};

STATIC_ASSERT(sizeof(CDataBreedFish) == 0x14);

/**
 *
 * Effect data of a usable item, copied out of its CDataItem for the menus that use it.
 *
 */
struct USEITEM_EFFECT {
    u32 use_flags;    /**< Effects the item has when used. */
    u32 action_flags; /**< ITEM_ACTION_FLAG bits: how the item is used. */
    u16 target_flags; /**< ITEM_TARGET_FLAG bits: what the item can be used on. */
    u8  unk_a[2];
    int value[4]; /**< Amounts of the item's effects. */
};

/**
 *
 * Gauge with a capacity and a current amount, used for health, durability and absorption.
 *
 */
class COMMON_GAGE {
public:
    float max; /**< Capacity of the gauge. */
    float now; /**< Current amount, between 0 and max. */

    /**
     *
     * Gives whether the gauge is full.
     *
     * @mangled CheckFill__11COMMON_GAGEFv
     * @address 0x1981B0
     * @size 0x24
     */
    int CheckFill();

    /**
     *
     * Gives how full the gauge is, from 0 to 1, or 0 for a gauge without capacity.
     *
     * @mangled GetRate__11COMMON_GAGEFv
     * @address 0x1981E0
     * @size 0x3C
     */
    float GetRate();

    /**
     *
     * Fills the gauge to a fraction of its capacity.
     *
     * @mangled SetFillRate__11COMMON_GAGEFf
     * @address 0x198220
     * @size 0x10
     */
    void SetFillRate(float rate);

    /**
     *
     * Adds an amount to the gauge, keeping it between empty and full.
     *
     * @mangled AddPoint__11COMMON_GAGEFf
     * @address 0x198230
     * @size 0x48
     */
    void AddPoint(float amount);

    /**
     *
     * Adds a fraction of the capacity to the gauge, keeping it between empty and full.
     *
     * @mangled AddRate__11COMMON_GAGEFf
     * @address 0x198280
     * @size 0x4C
     */
    void AddRate(float rate);
};

STATIC_ASSERT(sizeof(COMMON_GAGE) == 0x8);

/**
 *
 * Owned-item data of a usable item, a key item or an item of family 4.
 *
 */
struct ITEM_USED {
    s16 num; /**< Count of the item held in this entry. */
    s16 unk_2;
    u8  unk_4[0x58];
};

/**
 *
 * Owned-item data of an attachment, including one made by spectrumising.
 *
 */
struct ATTACH_USED {
    u8   spectol_type;    /**< What a spectrumised attachment came from, a SPECTOL_TYPE. */
    u8   spectol_value;   /**< Count, level or strength of what a spectrumised attachment came from. */
    s16  status[2];       /**< First two parameters the attachment adds to a weapon; ten-parameter writes continue into attribute. */
    s16  attribute[8];    /**< Attribute parameters the attachment adds to a weapon. */
    s16  spectol_item_no; /**< Item number a spectrumised attachment came from. */
    s16  level;           /**< Level of the weapon a spectrumised attachment came from. */
    u8   unk_1a[2];
    u32  special;    /**< Special ability bits the attachment gives. */
    char name[0x1A]; /**< Name of a spectrumised attachment. */
    s16  num;        /**< Count of the attachment held in this entry. */
    u8   unk_3c[0x20];
};

/**
 *
 * Owned-item data of a weapon.
 *
 */
struct WEAPON_USED {
    COMMON_GAGE whp;          /**< Durability gauge. */
    COMMON_GAGE abs;          /**< Absorption gauge; the weapon levels up when it fills. */
    s16         level;        /**< Weapon level, up to 99. */
    s16         status[2];    /**< First two parameters; the second also sets the magic sword counter. */
    s16         attribute[8]; /**< Attribute parameters; the highest of the first four is the weapon's element. */
    s16         unk_26;
    u32         special;      /**< Special ability bits. */
    s16         fusion_point; /**< Synthesis points, up to 999, or 9999 for a fishing rod. */
    s16         unk_2e;
    s16         unk_30;
    u8          unk_32;
    char        name[0x20]; /**< Name of the weapon. */
    u8          unk_53[9];
};

/**
 *
 * Owned-item data of a ridepod part.
 *
 */
struct ROBOPART_USED {
    COMMON_GAGE energy;     /**< Energy gauge of the robot part. */
    COMMON_GAGE whp;        /**< Durability gauge. */
    s16         status[10]; /**< Status parameters of the part. */
    s16         defence;    /**< Defence the part gives. */
    s16         unk_26;
    u8          unk_28[4];
    char        name[0x20]; /**< Name of the part. */
    u8          unk_4c[0x10];
};

/**
 *
 * Racing parameters of a fish, as indices of BREEDFISH_USED::param.
 *
 */
enum BREEDFISH_STAT {
    BREEDFISH_STAT_BOOST = 0,     /**< Boost. */
    BREEDFISH_STAT_ENDURANCE = 1, /**< Endurance. */
    BREEDFISH_STAT_TENACITY = 2,  /**< Tenacity. */
    BREEDFISH_STAT_STAMINA = 3,   /**< Stamina. */
    BREEDFISH_STAT_BATTLE = 4,    /**< Battle. */
    BREEDFISH_STAT_COUNT = 5,     /**< Number of racing parameters. */
};

/**
 *
 * Owned-item data of a fish that can be bred or raced.
 *
 */
struct BREEDFISH_USED {
    char  name[0x15]; /**< Name of the fish. */
    s8    sex;        /**< Sex of the fish, a BREEDFISH_SEX. */
    u8    kind;       /**< Fish variety used to select its displayed name. */
    u8    unk_17;
    u16   size;   /**< Size of the fish. */
    u16   weight; /**< Weight of the fish. */
    int   unk_1c;
    int   hp;                          /**< Health of the fish, 0 to 100. */
    u16   fatigue;                     /**< Race fatigue counter. */
    u16   param[BREEDFISH_STAT_COUNT]; /**< Racing parameters of the fish. */
    u16   timer;                       /**< Time left, counted down by the game clock. */
    u8    unk_32[3];
    s8    breed_feeds_remaining; /**< Feedings left before this breeding fish stops eating. */
    u16   feeds_remaining;       /**< Feedings left before the fish stops eating. */
    u16   flags;                 /**< BREEDFISH_FLAGS of the fish. */
    u8    color;                 /**< Colour variant of the breeding fish. */
    s8    grow_count;            /**< Food eaten towards the next growth; the fish grows past 10. */
    u8    unk_3c;
    u8    race_placement_flags; /**< Race results; bit 0x1 marks a top-three finish in fish race 2, cleared with the fatigue. */
    u8    unk_3e[2];
    int   tank_day;  /**< Day the fish was put into the second aquarium tank. */
    float tank_hour; /**< Hour of the day the fish was put into the second aquarium tank. */
    u8    unk_48[0x14];
};

/**
 *
 * Owned-item data of a gift box.
 *
 */
struct GIFTBOX_USED {
    s16 item_no[3]; /**< Item numbers inside the box, or 0 for an empty place. */
    u8  unk_6[0x56];
};

/**
 *
 * Owned-item data of a boiled fish.
 *
 */
struct BOILED_USED {
    s16  base_item_no; /**< Item number of the fish that was boiled. */
    char name[0x16];   /**< Name of the boiled fish. */
    u16  value;        /**< Value worked out from the fish's level and parameters. */
    u8   unk_1a[0x42];
};

/**
 *
 * Shot kinds of a gun or ridepod arm, as CGameDataUsed::GetAttackType returns them.
 *
 */
enum WEAPON_ATTACK_TYPE {
    WEAPON_ATTACK_GUN = 0,            /**< An ordinary gun. */
    WEAPON_ATTACK_LAUNCHER = 10,      /**< A grenade or rocket launcher. */
    WEAPON_ATTACK_GUN_2 = 11,         /**< A gun that fires like an ordinary gun. */
    WEAPON_ATTACK_LASER = 20,         /**< A laser gun. */
    WEAPON_ATTACK_MACHINE_GUN = 30,   /**< A machine gun. */
    WEAPON_ATTACK_RIDEPOD_LASER = 40, /**< The ridepod's four-cannon laser. */
    WEAPON_ATTACK_MISSILE = 70,       /**< A missile launcher. */
    WEAPON_ATTACK_BEAM = 90,          /**< A two-muzzle beam. */
};

/**
 *
 * One owned item: an inventory place, an equipment slot, an aquarium tank place or a fishing bait.
 *
 */
class CGameDataUsed {
public:
    s16 used_type{};   /**< Family of the item, a USED_ITEM_TYPE, or 0 for an empty place. */
    s16 item_no{};     /**< Item number, or 0 for an empty place. */
    s8  item_type{};   /**< Item type from the item's common data. */
    s8  rename_flag{}; /**< Non-zero when the item's name differs from its item name. */
    u8  unk_6[0xA]{};

    union {
        ITEM_USED      item;     /**< Data of a usable item. */
        ATTACH_USED    attach;   /**< Data of an attachment. */
        WEAPON_USED    weapon;   /**< Data of a weapon. */
        ROBOPART_USED  robopart; /**< Data of a ridepod part. */
        BREEDFISH_USED fish;     /**< Data of a fish. */
        GIFTBOX_USED   giftbox;  /**< Data of a gift box. */
        BOILED_USED    boiled;   /**< Data of a boiled fish. */
    } data{};                    /**< Data of the item, by used_type. */

    /**
     *
     * Makes an empty place.
     *
     * @mangled __ct__13CGameDataUsedFv
     * @address 0x1985A0
     * @size 0x28
     */
    CGameDataUsed();

    /**
     *
     * Empties the place.
     *
     * @mangled Init__13CGameDataUsedFv
     * @address 0x1985D0
     * @size 0xC
     */
    void Init();

    /**
     *
     * Gives whether several of the item can share one place.
     *
     * @mangled CheckTypeEnableStack__13CGameDataUsedFv
     * @address 0x1985E0
     * @size 0x4C
     */
    int CheckTypeEnableStack();

    /**
     *
     * Gives an owned model path for this item when its catalog entry exists.
     *
     */
    std::optional<std::string> DataPath() const;

    /**
     *
     * Gives which character can equip the item, a USER_CHARA, or -1.
     *
     * @mangled IsWhoEquip__13CGameDataUsedFv
     * @address 0x198640
     * @size 0x98
     */
    int IsWhoEquip();

    /**
     *
     * Gives the level of a weapon or of a spectrumised attachment, or 0.
     *
     * @mangled GetLevel__13CGameDataUsedFv
     * @address 0x1986E0
     * @size 0x30
     */
    int GetLevel();

    /**
     *
     * Gives the colour palette of a weapon's model, or 0.
     *
     * @mangled GetPalletColor__13CGameDataUsedFv
     * @address 0x198710
     * @size 0x50
     */
    int GetPalletColor();

    /**
     *
     * Gives the item number a spectrumised attachment came from, or 0.
     *
     * @mangled GetSpectolNo__13CGameDataUsedFv
     * @address 0x198760
     * @size 0x20
     */
    int GetSpectolNo();

    /**
     *
     * Gives how many more of the item the place can hold.
     *
     * @mangled CheckStackRemain__13CGameDataUsedFv
     * @address 0x198780
     * @size 0x64
     */
    int CheckStackRemain();

    /**
     *
     * Gives the count of the item the place holds.
     *
     * @mangled GetNum__13CGameDataUsedFv
     * @address 0x1987F0
     * @size 0x7C
     */
    int GetNum();

    /**
     *
     * Gives whether the item can be set as an active item.
     *
     * @mangled GetActiveSetNum__13CGameDataUsedFv
     * @address 0x198870
     * @size 0x8
     */
    int GetActiveSetNum();

    /**
     *
     * Adds to the count of a stackable item, emptying the place when nothing is left if asked, and
     * gives the new count.
     *
     * @mangled AddNum__13CGameDataUsedFii
     * @address 0x198880
     * @size 0x10C
     */
    int AddNum(int count, int clear_empty);

    /**
     *
     * Gives the energy capacity a ridepod part uses.
     *
     * @mangled GetUseCapacity__13CGameDataUsedFv
     * @address 0x198990
     * @size 0x38
     */
    int GetUseCapacity();

    /**
     *
     * Adds to a fish's health, keeping it between 0 and 100, and gives the new health.
     *
     * @mangled AddFishHp__13CGameDataUsedFi
     * @address 0x1989D0
     * @size 0x48
     */
    int AddFishHp(int amount);

    /**
     *
     * Turns a fish into a boiled fish.
     *
     * @mangled Boiled__13CGameDataUsedFv
     * @address 0x198A20
     * @size 0xF4
     */
    int Boiled();

    /**
     *
     * Gives whether the item can be set as an active item.
     *
     * @mangled IsActiveSet__13CGameDataUsedFv
     * @address 0x198B20
     * @size 0x30
     */
    int IsActiveSet();

    /**
     *
     * Renames an attachment, fish, ridepod part or weapon.
     *
     * @mangled SetName__13CGameDataUsedFPc
     * @address 0x198B50
     * @size 0xD0
     */
    void SetName(char *name);

    /**
     *
     * Gives the display name of the item in an ITEM_NAME_TYPE form.
     *
     * @mangled GetName__13CGameDataUsedFi
     * @address 0x198C20
     * @size 0x2E8
     */
    char *GetName(int name_type);

    /**
     *
     * Packs a fish into its password form.
     *
     * @mangled TransToPassword__13CGameDataUsedFPci
     * @address 0x198F10
     * @size 0x21C
     */
    void TransToPassword(char *data, int length);

    /**
     *
     * Unpacks a fish from its password form.
     *
     * @mangled TransToData__13CGameDataUsedFPci
     * @address 0x199130
     * @size 0x114
     */
    void TransToData(char *data, int length);

    /**
     *
     * Takes some of the item away, emptying a place that cannot stack, and gives how many went.
     *
     * @mangled DeleteNum__13CGameDataUsedFi
     * @address 0x199250
     * @size 0x90
     */
    int DeleteNum(int count);

    /**
     *
     * Gives a weapon's synthesis points, or 0.
     *
     * @mangled RemainFusion__13CGameDataUsedFv
     * @address 0x1992E0
     * @size 0x20
     */
    int RemainFusion();

    /**
     *
     * Adds to a weapon's synthesis points and gives the new total.
     *
     * @mangled AddFusionPoint__13CGameDataUsedFi
     * @address 0x199300
     * @size 0x88
     */
    int AddFusionPoint(int point);

    /**
     *
     * Gives the effect names and strength of a weapon's element, and the element itself.
     *
     * @mangled GetEffectReadType__13CGameDataUsedFPPcPPcPi
     * @address 0x199390
     * @size 0xDC
     */
    int GetEffectReadType(char **effect, char **sound, int *power);

    /**
     *
     * Gives the name and extra figures the item's description message shows.
     *
     * @mangled GetMsgAddInfo__13CGameDataUsedFPPcPPcPi
     * @address 0x199470
     * @size 0x170
     */
    void GetMsgAddInfo(char **message, char **extra_message, int *value);

    /**
     *
     * Gives the durability of a weapon or ridepod part as a fraction, and its current and full
     * values.
     *
     * @mangled GetWHp__13CGameDataUsedFPi
     * @address 0x1995E0
     * @size 0xBC
     */
    float GetWHp(int *whp);

    /**
     *
     * Gives whether a weapon or ridepod part has lost durability.
     *
     * @mangled IsRepair__13CGameDataUsedFv
     * @address 0x1996A0
     * @size 0xE8
     */
    int IsRepair();

    /**
     *
     * Restores durability to a weapon or ridepod part.
     *
     * @mangled Repair__13CGameDataUsedFi
     * @address 0x199790
     * @size 0x7C
     */
    int Repair(int point);

    /**
     *
     * Gives the item number of the repair item that works on this item, or 0.
     *
     * @mangled GetEnableRepairItemNo__13CGameDataUsedFv
     * @address 0x199810
     * @size 0x68
     */
    int GetEnableRepairItemNo();

    /**
     *
     * Gives whether an item number is the repair item that works on this item.
     *
     * @mangled IsEnableUseRepair__13CGameDataUsedFi
     * @address 0x199880
     * @size 0x2C
     */
    int IsEnableUseRepair(int item_no);

    /**
     *
     * Gives the attack type of a ridepod body or arm, or -1.
     *
     * @mangled GetRoboInfoType__13CGameDataUsedFv
     * @address 0x1998B0
     * @size 0x64
     */
    int GetRoboInfoType();

    /**
     *
     * Builds the joint name of a ridepod body or arm as owned text.
     *
     */
    std::optional<std::string> RoboJointName();

    /**
     *
     * Builds the ridepod arm sound name as owned text.
     *
     */
    std::optional<std::string> RoboSoundFileName();

    /**
     *
     * Gives whether a ridepod energy pack has no durability left.
     *
     * @mangled IsBroken__13CGameDataUsedFv
     * @address 0x199A70
     * @size 0x44
     */
    int IsBroken();

    /**
     *
     * Gives whether a weapon has absorbed enough to level up.
     *
     * @mangled IsLevelUp__13CGameDataUsedFv
     * @address 0x199AC0
     * @size 0x74
     */
    int IsLevelUp();

    /**
     *
     * Levels a weapon up, raising its durability, parameters and synthesis points.
     *
     * @mangled LevelUp__13CGameDataUsedFv
     * @address 0x199B40
     * @size 0x324
     */
    void LevelUp();

    /**
     *
     * Gives whether the item counts as rubbish.
     *
     * @mangled IsTrush__13CGameDataUsedFv
     * @address 0x199E70
     * @size 0x78
     */
    int IsTrush();

    /**
     *
     * Gives whether the item can be spectrumised.
     *
     * @mangled IsSpectolTrans__13CGameDataUsedFv
     * @address 0x199EF0
     * @size 0x40
     */
    int IsSpectolTrans();

    /**
     *
     * Fills a place with the attachment that spectrumising a count of this item makes.
     *
     * @mangled ToSpectolTrans__13CGameDataUsedFP13CGameDataUsedi
     * @address 0x199F30
     * @size 0x3FC
     */
    void ToSpectolTrans(CGameDataUsed *attach, int num);

    /**
     *
     * Copies the ten status parameters of a weapon, attachment or ridepod part.
     *
     * @mangled GetStatusParam__13CGameDataUsedFPs
     * @address 0x19A330
     * @size 0x128
     */
    void GetStatusParam(short *param);

    /**
     *
     * Copies the ten status parameters, adjusting the attack of the weapon whose strength follows
     * the time of day.
     *
     * @mangled GetStatusParam__13CGameDataUsedFPsf
     * @address 0x19A460
     * @size 0x80
     */
    void GetStatusParam(short *param, float time);

    /**
     *
     * Gives how many weapons a weapon can build up into now, with the candidates and whether each
     * one's parameters are met.
     *
     * @mangled IsBuildUp__13CGameDataUsedFPiPiPi
     * @address 0x19A4E0
     * @size 0x2EC
     */
    int IsBuildUp(int *count, int *item_nos, int *flags);

    /**
     *
     * Gives whether the item is one of the two fishing rods.
     *
     * @mangled IsFishingRod__13CGameDataUsedFv
     * @address 0x19A7D0
     * @size 0x28
     */
    int IsFishingRod();

    /**
     *
     * Gives the element of a weapon, its highest of the first four attributes, or -1.
     *
     * @mangled GetActiveElem__13CGameDataUsedFv
     * @address 0x19A800
     * @size 0x58
     */
    int GetActiveElem();

    /**
     *
     * Gives the attack type of a weapon or ridepod part, or -1.
     *
     * @mangled GetAttackType__13CGameDataUsedFv
     * @address 0x19A860
     * @size 0x64
     */
    int GetAttackType();

    /**
     *
     * Gives the model number of a weapon, or -1.
     *
     * @mangled GetModelNo__13CGameDataUsedFv
     * @address 0x19A8D0
     * @size 0x40
     */
    int GetModelNo();

    /**
     *
     * Keeps the item's parameters within their limits.
     *
     * @mangled CheckParamLimmit__13CGameDataUsedFv
     * @address 0x19AA00
     * @size 0x34C
     */
    void CheckParamLimmit();

    /**
     *
     * Counts a fish's timer down by the time that has passed.
     *
     * @mangled TimeCheck__13CGameDataUsedFi
     * @address 0x19AD50
     * @size 0x30
     */
    void TimeCheck(int elapsed);

    /**
     *
     * Gives how many items a gift box holds.
     *
     * @mangled GetGiftBoxItemNum__13CGameDataUsedFv
     * @address 0x19AD80
     * @size 0x48
     */
    int GetGiftBoxItemNum();

    /**
     *
     * Puts an item number into a gift box, at a given place or the first free one.
     *
     * @mangled SetGiftBoxItem__13CGameDataUsedFii
     * @address 0x19ADD0
     * @size 0x68
     */
    int SetGiftBoxItem(int item_no, int slot);

    /**
     *
     * Gives the item number at one place of a gift box, or 0.
     *
     * @mangled GetGiftBoxItemNo__13CGameDataUsedFi
     * @address 0x19AE40
     * @size 0x3C
     */
    int GetGiftBoxItemNo(int slot);

    /**
     *
     * Gives how many of an item number a gift box holds.
     *
     * @mangled GetGiftBoxSameItemNum__13CGameDataUsedFi
     * @address 0x19AE80
     * @size 0x50
     */
    int GetGiftBoxSameItemNum(int item_no);

    /**
     *
     * Copies another owned item into this place, keeping the ridepod's energy in step when this
     * place is the ridepod body.
     *
     * @mangled CopyGameData__13CGameDataUsedFP13CGameDataUsed
     * @address 0x19AED0
     * @size 0xA0
     */
    void CopyGameData(CGameDataUsed *other);

    /**
     *
     * Fills the place with a new weapon.
     *
     * @mangled CopyDataWeapon__13CGameDataUsedFi
     * @address 0x19AF70
     * @size 0x128
     */
    int CopyDataWeapon(int item_no);

    /**
     *
     * Fills the place with a new attachment, or adds one to the same attachment.
     *
     * @mangled CopyDataAttach__13CGameDataUsedFi
     * @address 0x19B0A0
     * @size 0x108
     */
    int CopyDataAttach(int item_no);

    /**
     *
     * Fills the place with a new item, or adds one to the same item.
     *
     * @mangled CopyDataItem__13CGameDataUsedFi
     * @address 0x19B1B0
     * @size 0xA4
     */
    int CopyDataItem(int item_no);

    /**
     *
     * Fills the place with a new fish of random size, weight and sex.
     *
     * @mangled CopyDataFish__13CGameDataUsedFi
     * @address 0x19B260
     * @size 0x184
     */
    int CopyDataFish(int item_no);

    /**
     *
     * Fills the place with an empty gift box.
     *
     * @mangled CopyDataGiftBox__13CGameDataUsedFi
     * @address 0x19B3F0
     * @size 0x68
     */
    int CopyDataGiftBox(int item_no);

    /**
     *
     * Merges another owned item of the same kind into this place, or swaps the two.
     *
     * @mangled CopyDataItem__13CGameDataUsedFP13CGameDataUsed
     * @address 0x19B460
     * @size 0xF4
     */
    int CopyDataItem(CGameDataUsed *other);

    /**
     *
     * Fills the place with a new ridepod part.
     *
     * @mangled CopyDataRoboPart__13CGameDataUsedFi
     * @address 0x19B560
     * @size 0x118
     */
    int CopyDataRoboPart(int item_no);
};

STATIC_ASSERT(sizeof(CGameDataUsed) == 0x6C);

/**
 *
 * Names the thing an item is being used on.
 *
 */
class CItemUseTarget {
public:
    int type; /**< What the target is, an ITEM_USE_TARGET_TYPE. */

    struct {
        void *data; /**< Object selected by type; an owned item for ITEM_USE_TARGET_ITEM. */
    } target;       /**< The target itself. */

    /**
     *
     * Creates a target that points at nothing.
     *
     */
    CItemUseTarget() : type(ITEM_USE_TARGET_NONE), target{nullptr} {}

    /**
     *
     * Sets the kind of the target and, for a known kind, the target itself.
     *
     * @mangled SetPtr__14CItemUseTargetFiPv
     * @address 0x197B40
     * @size 0x58
     */
    void SetPtr(int new_type, void *new_ptr);
};

STATIC_ASSERT(sizeof(CItemUseTarget) == 0x8);

/**
 *
 * Describes one kind of monster: its name, files, life and battle parameters.
 *
 */
struct BASE_MONSTER_TBL {
    s16   id;         /**< Number of the monster kind; the table ends at an entry with an empty name. */
    s16   grade;      /**< Grade of the monster that its script reads. */
    char  name[32];   /**< Name shown for the monster, loaded per language. */
    char  model[16];  /**< Base name of the monster's model and settings files under dungeon/monster. */
    char  script[16]; /**< Base name of the monster's script file under dungeon/monster. */
    s16   gift_type;  /**< Kind that picks the monster's row of the gift item table. */
    s32   sound_no;   /**< Number of the monster's sound bank under snd2/mon; 0 or less for none. */
    s32   unk_4c;
    s32   life;         /**< Life that the monster starts with. */
    s8    user_mons_id; /**< Monster that the player can turn into to pass as this one; -1 for none. */
    u16   reward_exp;   /**< Experience awarded for defeating this monster. */
    u16   reward_money; /**< Money awarded for defeating this monster. */
    u16   unk_5a;
    float whp;               /**< Wear that a melee hit on the monster does to the main character's weapon. */
    u16   gekirin_num;       /**< Hits that fill the monster's rage. */
    s8    guard_rate;        /**< Chance out of 100 that the monster guards a hit. */
    s8    escape_rate0;      /**< Chance out of 100 that the monster dodges an attack of its target whose murderous mode is 0. */
    s8    escape_rate1;      /**< Chance out of 100 that the monster dodges an attack of its target whose murderous mode is 1. */
    u16   attack;            /**< Attack power of the monster. */
    u8    defense;           /**< Defence that is taken off the attack power of a hit. */
    s8    stagger;           /**< Stagger that hits must build up to make the monster flinch; 0 to flinch at every hit. */
    s8    boss;              /**< Nonzero for a boss, whose life is shown across the foot of the screen. */
    s8    sw_effect_num;     /**< Number of sword after-images that the monster's model carries. */
    s16   element_resist[8]; /**< Percentages that reduce damage from each element. */
    s16   ext_param[12];     /**< Percentages that scale the damage of each kind of attack. */
    u32   flags;             /**< MONSTER_TBL_FLAG bits that suppress damage reactions. */
    u32   lift_flags;        /**< MONSTER_LIFT_FLAG bits. */
    s32   next_id;           /**< Monster kind that is loaded along with this one; -1 for none. */

    s16 drop_item[3]; /**< Item numbers in the monster's drop slots. */

    u32 resist_attr;       /**< Hit attribute bits that cannot leave statuses on the monster. */
    s16 status_chance;     /**< Base chance used when applying a hit status. */
    s16 ratio_damage_rate; /**< Percentage used when scaling ratio-based damage. */
    s8  area_no;           /**< Area number assigned to this monster definition. */
    s16 memo_index;        /**< Index of this monster in the encyclopedia. */
    s16 share_model;       /**< Nonzero to share the loaded kind's model between its monsters instead of copying it. */
};

STATIC_ASSERT(sizeof(BASE_MONSTER_TBL) == 0xB8);

/**
 *
 * Manages the master item tables: where each family's table lives and how many entries it has.
 *
 */
class CGameData {
public:
    int             unk_0;
    CDataCommon    *common_data; /**< Common data of every item. */
    CDataItem      *item_data;   /**< Usable item table. */
    CDataWeapon    *weapon_data; /**< Weapon table. */
    s16            *guard_data;  /**< Guard table. */
    CDataAttach    *attach_data; /**< Attachment table. */
    CDataRoboPart  *robo_data;   /**< Ridepod part table. */
    CDataBreedFish *fish_data;   /**< Fish table. */
    u16             max_item_no; /**< Highest item number that has common data. */
    u16             common_num;  /**< Number of entries in the common data. */
    u16             item_num;    /**< Number of entries in the usable item table. */
    u16             weapon_num;  /**< Number of entries in the weapon table. */
    u16             guard_num;   /**< Number of entries in the guard table. */
    u16             attach_num;  /**< Number of entries in the attachment table. */
    u16             robo_num;    /**< Number of entries in the ridepod part table. */
    u16             fish_num;    /**< Number of entries in the fish table. */

    /**
     *
     * Points every table at its storage, empties them and clears the item names.
     *
     * @mangled Initialize__9CGameDataFv
     * @address 0x195AE0
     * @size 0x80
     */
    void Initialize();

    /**
     *
     * Reads every item data script into the tables and finds the highest item number.
     *
     * @mangled LoadData__9CGameDataFv
     * @address 0x196980
     * @size 0xE4
     */
    int LoadData();

    /**
     *
     * Reads the item name script of one language.
     *
     * @mangled LoadItemSystemMes__9CGameDataFi
     * @address 0x196A70
     * @size 0xDC
     */
    int LoadItemSystemMes(int language);

    /**
     *
     * Clears the names of every item when asked to.
     *
     * @mangled InitItemMes__9CGameDataFii
     * @address 0x196B50
     * @size 0x50
     */
    void InitItemMes(int clear_name, int unused);

    /**
     *
     * Gives the common data of an item number, or null for a number without any.
     *
     * @mangled GetCommonData__9CGameDataFi
     * @address 0x196BA0
     * @size 0x64
     */
    CDataCommon *GetCommonData(int item_no);

    /**
     *
     * Gives the weapon data of an item number, or null when it is not a weapon.
     *
     * @mangled GetWeaponData__9CGameDataFi
     * @address 0x196C10
     * @size 0xAC
     */
    CDataWeapon *GetWeaponData(int item_no);

    /**
     *
     * Gives the usable item data of an item number, or null when it has none.
     *
     * @mangled GetItemData__9CGameDataFi
     * @address 0x196CC0
     * @size 0xA4
     */
    CDataItem *GetItemData(int item_no);

    /**
     *
     * Gives the attachment data of an item number, or null when it is not an attachment.
     *
     * @mangled GetAttachData__9CGameDataFi
     * @address 0x196D70
     * @size 0xA4
     */
    CDataAttach *GetAttachData(int item_no);

    /**
     *
     * Gives the ridepod part data of an item number, or null when it has none.
     *
     * @mangled GetRoboData__9CGameDataFi
     * @address 0x196E20
     * @size 0x70
     */
    CDataRoboPart *GetRoboData(int item_no);

    /**
     *
     * Gives the fish data of an item number, or null when it is not a fish.
     *
     * @mangled GetFishData__9CGameDataFi
     * @address 0x196E90
     * @size 0xA4
     */
    CDataBreedFish *GetFishData(int item_no);

    /**
     *
     * Gives the guard data of an item number, or null when it has none.
     *
     * @mangled GetGuardData__9CGameDataFi
     * @address 0x196F40
     * @size 0x6C
     */
    s16 *GetGuardData(int item_no);

    /**
     *
     * Gives the item type of an item number, or 0 for a number without common data.
     *
     * @mangled GetDataType__9CGameDataFi
     * @address 0x196FB0
     * @size 0x30
     */
    int GetDataType(int item_no);

    /**
     *
     * Gives the first item number, in common data order, whose item type is the one given, or 0.
     *
     * @mangled GetDataTypeStartListNo__9CGameDataFi
     * @address 0x196FE0
     * @size 0x6C
     */
    int GetDataTypeStartListNo(int type);
};

STATIC_ASSERT(sizeof(CGameData) == 0x30);

/**
 *
 * Attachment parameter index and amount each item number from 1 raises when spectrumised.
 *
 */
extern s8 etcitem_spectol_table[0x1A9][2];

/** Weapon entry the weapon data script is filling. */
extern CDataWeapon *SpiWeaponPt;

/** Usable item entry the item data script is filling. */
extern CDataItem *SpiItemPt;

/** Attachment entry the attachment data script is filling. */
extern CDataAttach *SpiAttach;

/** Ridepod part entry the ridepod data script is filling. */
extern CDataRoboPart *SpiRoboPart;

/** Fish entry the fish data script is filling. */
extern CDataBreedFish *SpiFish;

/** The game's master item tables. */
extern CGameData GameItemDataManage;

/**
 *
 * Gives the game's master item tables.
 *
 * @mangled GetGameDataPt__Fv
 * @address 0x195A00
 * @size 0xC
 */
CGameData *GetGameDataPt();

/**
 *
 * Gives the common data of an item number, or null for a number without any.
 *
 * @mangled GetCommonItemData__Fi
 * @address 0x197050
 * @size 0x10
 */
CDataCommon *GetCommonItemData(int item_no);

/**
 *
 * Gives the usable item data of an item number, or null when it has none.
 *
 * @mangled GetItemInfoData__Fi
 * @address 0x197060
 * @size 0x10
 */
CDataItem *GetItemInfoData(int item_no);

/**
 *
 * Gives the weapon data of an item number, or null when it is not a weapon.
 *
 * @mangled GetWeaponInfoData__Fi
 * @address 0x197070
 * @size 0x10
 */
CDataWeapon *GetWeaponInfoData(int item_no);

/**
 *
 * Gives the ridepod part data of an item number, or null when it has none.
 *
 * @mangled GetRoboPartInfoData__Fi
 * @address 0x197080
 * @size 0x10
 */
CDataRoboPart *GetRoboPartInfoData(int item_no);

/**
 *
 * Gives the fish data of an item number, or null when it is not a fish.
 *
 * @mangled GetBreedFishInfoData__Fi
 * @address 0x197090
 * @size 0x10
 */
CDataBreedFish *GetBreedFishInfoData(int item_no);

/**
 *
 * Returns an owned model filename for an item, or no value when its record is absent.
 *
 */
std::optional<std::string> ItemFileName(int item_no, int variant);

/**
 *
 * Returns an owned model path for an item, or no value when its record is absent.
 *
 */
std::optional<std::string> ItemFilePath(int item_no, int variant);

/**
 *
 * Gives the item type of an item number, or 0 for a number without common data.
 *
 * @mangled GetItemDataType__Fi
 * @address 0x1972F0
 * @size 0x10
 */
int GetItemDataType(int item_no);

/**
 *
 * Gives the ITEM_ATTRIBUTE bits of an item number, or 0 for a number without common data.
 *
 * @mangled GetItemDataAttribute__Fi
 * @address 0x197300
 * @size 0x38
 */
u32 GetItemDataAttribute(int item_no);

/**
 *
 * Gives the family, a USED_ITEM_TYPE, of an item type.
 *
 * @mangled ConvertUsedItemType__Fi
 * @address 0x197340
 * @size 0xCC
 */
int ConvertUsedItemType(int item_type);

/**
 *
 * Gives the number of one of an item's messages, or -1 for an item without common data.
 *
 * @mangled GetItemMessageNo__Fii
 * @address 0x197410
 * @size 0x5C
 */
int GetItemMessageNo(int item_no, int message);

/**
 *
 * Gives the display name of an item, or null for an item without common data.
 *
 * @mangled GetItemMessage__Fi
 * @address 0x197470
 * @size 0x38
 */
char *GetItemMessage(int item_no);

/**
 *
 * Gives the menu icon number of an item, or -1 for an item without common data.
 *
 * @mangled GetItemIconNo__Fi
 * @address 0x1974B0
 * @size 0x38
 */
int GetItemIconNo(int item_no);

/**
 *
 * Sets the attachment parameter that spectrumising an item raises, scaled by the item count.
 *
 * @mangled SetItemSpectolPoint__FiP11ATTACH_USEDi
 * @address 0x1974F0
 * @size 0x6C
 */
void SetItemSpectolPoint(int item_no, ATTACH_USED *used, int multiplier);

/**
 *
 * Fills a list, ended by -1, with the message numbers of the menu commands an item offers,
 * and gives their count.
 *
 * @mangled GetMenuCommandMsg__FiPi
 * @address 0x1975D0
 * @size 0x37C
 */
int GetMenuCommandMsg(int item_no, int *message_list);

/**
 *
 * Gives whether a character can equip an item.
 *
 * @mangled CheckItemEquip__Fii
 * @address 0x197950
 * @size 0x94
 */
int CheckItemEquip(int chara, int item_no);

/**
 *
 * Gives the item number whose display name is the one given, or -1.
 *
 * @mangled SearchItemByName__FPc
 * @address 0x1979F0
 * @size 0x70
 */
int SearchItemByName(char *name);

/**
 *
 * Gives the item number of one of the ridepod cores, or 0 for an index out of range.
 *
 * @mangled GetRidePodCore__Fi
 * @address 0x197A60
 * @size 0x3C
 */
int GetRidePodCore(int index);

/**
 *
 * Copies the effect data of a usable item; gives false when it has none.
 *
 * @mangled GetUsedItemAfterEffect__FiP14USEITEM_EFFECT
 * @address 0x197AC0
 * @size 0x80
 */
int GetUsedItemAfterEffect(int item_no, USEITEM_EFFECT *effect);

/**
 *
 * Copies an item's available command message IDs into a terminated list.
 *
 * @mangled ItemCmdMsgSet__FiPi
 * @address 0x197560
 * @size 0x6C
 */
int ItemCmdMsgSet(int group, int *messages);
