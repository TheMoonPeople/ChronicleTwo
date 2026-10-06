#pragma once

#include "common.h"

/**
 * @file
 * Declares the master item tables read from the menu configuration scripts (common, weapon, item,
 * attachment, ridepod part, fish and guard data) and the accessors the rest of the game uses to
 * look an item number up in them.
 */

struct ATTACH_USED;
class CGameDataUsed;

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
    USED_ITEM_TYPE_UNK_4 = 4,     /**< The family of item types 5 to 10. */
    USED_ITEM_TYPE_ROBO_PART = 5, /**< A ridepod part with an entry in the ridepod part table. */
    USED_ITEM_TYPE_FISH = 6,      /**< A fish with an entry in the fish table. */
    USED_ITEM_TYPE_GIFT_BOX = 7,  /**< A gift box with an entry in the item table. */
    USED_ITEM_TYPE_BOILED = 8,    /**< A boiled item with an entry in the item table. */
};

/**
 *
 * Bits of CDataCommon::attribute.
 *
 */
enum ITEM_ATTRIBUTE {
    ITEM_ATTRIBUTE_TRUSH = 0x1,         /**< The item counts as rubbish. */
    ITEM_ATTRIBUTE_SPECTOL_TRANS = 0x2, /**< The item can be turned into an attachment by spectrumising. */
};

/**
 *
 * Bits of CDataItem::use_flags and USEITEM_EFFECT::use_flags.
 *
 */
// clang-format off
enum ITEM_USE_FLAG {
    ITEM_USE_FLAG_ADD_STATUS_UNK_8 = 0x4000,       /**< Adds CHARA_STATUS_UNK_8. */
    ITEM_USE_FLAG_CURE_STATUS_UNK_8 = 0x8000,      /**< Cures CHARA_STATUS_UNK_8. */
    ITEM_USE_FLAG_ADD_POISON = 0x10000,            /**< Adds poison. */
    ITEM_USE_FLAG_CURE_POISON = 0x20000,           /**< Cures poison. */
    ITEM_USE_FLAG_ADD_STATUS_UNK_4 = 0x40000,      /**< Adds CHARA_STATUS_UNK_4. */
    ITEM_USE_FLAG_CURE_STATUS_UNK_4 = 0x80000,     /**< Cures CHARA_STATUS_UNK_4. */
    ITEM_USE_FLAG_ADD_STATUS_UNK_2 = 0x100000,     /**< Adds CHARA_STATUS_UNK_2. */
    ITEM_USE_FLAG_CURE_STATUS_UNK_2 = 0x200000,    /**< Cures CHARA_STATUS_UNK_2. */
    ITEM_USE_FLAG_ADD_POWER = 0x400000,            /**< Adds the power status. */
    ITEM_USE_FLAG_CURE_ALL = 0x800000,             /**< Expands to the individual status cure effects when loaded. */
    ITEM_USE_FLAG_ADD_STATUS_UNK_20 = 0x02000000,  /**< Adds CHARA_STATUS_UNK_20. */
    ITEM_USE_FLAG_CURE_STATUS_UNK_20 = 0x04000000, /**< Cures CHARA_STATUS_UNK_20. */
    ITEM_USE_FLAG_ADD_STATUS_UNK_40 = 0x08000000,  /**< Adds CHARA_STATUS_UNK_40. */
    ITEM_USE_FLAG_CURE_STATUS_UNK_40 = 0x10000000, /**< Cures CHARA_STATUS_UNK_40. */
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
    u8    type;          /**< Item type, from which ConvertUsedItemType gives the family. */
    u8    unk_1;
    s16   item_no;       /**< Item number of this entry. */
    s16   list_no;       /**< Index of the item's entry in the table of its family. */
    s16   icon_no;       /**< Number of the item's menu icon. */
    s16   message_no;    /**< Base number of the item's messages. */
    u16   max_num;       /**< Largest count of the item one owned entry can hold. */
    char  file_name[16]; /**< Base name of the item's model files. */
    u8    active_set;    /**< Non-zero when the item can be set as an active item. */
    u8    unk_1d;
    s16   stack_num;     /**< Count of the item one stack can hold. */
    u8    unk_20;
    u8    unk_21[3];
    u32   attribute;     /**< ITEM_ATTRIBUTE bits. */
    char *name;          /**< Display name of the item, from the item message script. */
};
STATIC_ASSERT(sizeof(CDataCommon) == 0x2C);

/**
 *
 * Holds the effect data of a usable item.
 *
 */
class CDataItem {
public:
    u32 status_flags; /**< Status conditions the item acts on. */
    u32 use_flags;    /**< Effects the item has when used. */
    u16 target_flags; /**< Kinds of target the item can be used on. */
    s16 value[3];     /**< Amounts of the item's effects. */

    /**
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
    s16 status[2];    /**< First two parameters the attachment adds to a weapon. */
    s16 attribute[8]; /**< Attribute parameters the attachment adds to a weapon. */
    u32 special;      /**< Special ability bits the attachment gives. */

    /**
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
    s16 status[2];          /**< Starting values of the first two parameters. */
    s16 status_max[2];      /**< Limits of the first two parameters. */
    s16 attribute[8];       /**< Starting values of the attribute parameters. */
    s16 attribute_max[8];   /**< Limits of the attribute parameters. */
    u32 special;            /**< Special ability bits the weapon starts with. */
    u8  unk_30[8];
    u8  unk_38;
    u8  fusion_point;       /**< Synthesis points the weapon gains at each level-up. */
    s16 buildup_weapon[3];  /**< Item numbers of the weapons this weapon can build up into. */
    s16 buildup_monster[3]; /**< Monsters that must have been defeated to build up, or negative for none. */
    u8  pallet_color;       /**< Colour palette of the weapon's model. */
    u8  unk_47;
    u8  attack_type;        /**< Attack type of the weapon. */
    u8  model_no;           /**< Model number of the weapon. */
    u8  unk_4a[2];

    /**
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
    s16 unk_2;
    s16 unk_4;
    s16 unk_6;
    s16 unk_8;
    s16 unk_a;
    s16 unk_c[8];
    s16 unk_1c;
    s16 info_type_d;  /**< Attack type of a part of item type 0xD. */
    s16 info_type_e;  /**< Attack type of a part of item type 0xE. */
    u8  offset_no;    /**< Number of the joint and sound files of the part. */
    u8  unk_23;

    /**
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
    float size;     /**< Standard size of the fish. */
    s16   unk_4;
    s16   unk_6;
    s16   unk_8;
    s16   unk_a;
    s16   unk_c;
    s16   unk_e;
    s16   unk_10;
    s16   unk_12;

    /**
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
    u32 status_flags; /**< Status conditions the item acts on. */
    u16 target_flags; /**< Kinds of target the item can be used on. */
    u8  unk_a[2];
    int value[4];     /**< Amounts of the item's effects. */
};

/**
 *
 * Names the thing an item is being used on.
 *
 */
class CItemUseTarget {
public:
    int type;                /**< What the target is, an ITEM_USE_TARGET_TYPE. */
    union {
        void          *data; /**< Target of any kind. */
        CGameDataUsed *item; /**< Target owned item, for ITEM_USE_TARGET_ITEM. */
    } target;                /**< The target itself. */

    /**
     *
     * Creates a target that points at nothing.
     *
     */
    CItemUseTarget() { type = ITEM_USE_TARGET_NONE; }

    /**
     * Sets the kind of the target and, for a known kind, the target itself.
     *
     * @mangled SetPtr__14CItemUseTargetFiPv
     * @address 0x197B40
     * @size 0x58
     */
    void SetPtr(int type, void *target);
};
STATIC_ASSERT(sizeof(CItemUseTarget) == 0x8);

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
     * Points every table at its storage, empties them and clears the item names.
     *
     * @mangled Initialize__9CGameDataFv
     * @address 0x195AE0
     * @size 0x80
     */
    void Initialize();

    /**
     * Reads every item data script into the tables and finds the highest item number.
     *
     * @mangled LoadData__9CGameDataFv
     * @address 0x196980
     * @size 0xE4
     */
    int LoadData();

    /**
     * Reads the item name script of one language.
     *
     * @mangled LoadItemSystemMes__9CGameDataFi
     * @address 0x196A70
     * @size 0xDC
     */
    int LoadItemSystemMes(int language);

    /**
     * Clears the names of every item when asked to.
     *
     * @mangled InitItemMes__9CGameDataFii
     * @address 0x196B50
     * @size 0x50
     */
    void InitItemMes(int clear_name, int unused);

    /**
     * Gives the common data of an item number, or null for a number without any.
     *
     * @mangled GetCommonData__9CGameDataFi
     * @address 0x196BA0
     * @size 0x64
     */
    CDataCommon *GetCommonData(int item_no);

    /**
     * Gives the weapon data of an item number, or null when it is not a weapon.
     *
     * @mangled GetWeaponData__9CGameDataFi
     * @address 0x196C10
     * @size 0xAC
     */
    CDataWeapon *GetWeaponData(int item_no);

    /**
     * Gives the usable item data of an item number, or null when it has none.
     *
     * @mangled GetItemData__9CGameDataFi
     * @address 0x196CC0
     * @size 0xA4
     */
    CDataItem *GetItemData(int item_no);

    /**
     * Gives the attachment data of an item number, or null when it is not an attachment.
     *
     * @mangled GetAttachData__9CGameDataFi
     * @address 0x196D70
     * @size 0xA4
     */
    CDataAttach *GetAttachData(int item_no);

    /**
     * Gives the ridepod part data of an item number, or null when it has none.
     *
     * @mangled GetRoboData__9CGameDataFi
     * @address 0x196E20
     * @size 0x70
     */
    CDataRoboPart *GetRoboData(int item_no);

    /**
     * Gives the fish data of an item number, or null when it is not a fish.
     *
     * @mangled GetFishData__9CGameDataFi
     * @address 0x196E90
     * @size 0xA4
     */
    CDataBreedFish *GetFishData(int item_no);

    /**
     * Gives the guard data of an item number, or null when it has none.
     *
     * @mangled GetGuardData__9CGameDataFi
     * @address 0x196F40
     * @size 0x6C
     */
    s16 *GetGuardData(int item_no);

    /**
     * Gives the item type of an item number, or 0 for a number without common data.
     *
     * @mangled GetDataType__9CGameDataFi
     * @address 0x196FB0
     * @size 0x30
     */
    int GetDataType(int item_no);

    /**
     * Gives the first item number, in common data order, whose item type is the one given, or 0.
     *
     * @mangled GetDataTypeStartListNo__9CGameDataFi
     * @address 0x196FE0
     * @size 0x6C
     */
    s16 GetDataTypeStartListNo(int type);
};
STATIC_ASSERT(sizeof(CGameData) == 0x30);

/** Spectrumising table: for each item number from 1, the attachment parameter it raises and by how much. */
extern s8 etcitem_spectol_table[0x352];

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
 * Gives the game's master item tables.
 *
 * @mangled GetGameDataPt__Fv
 * @address 0x195A00
 * @size 0xC
 */
CGameData *GetGameDataPt();

/**
 * Gives the common data of an item number, or null for a number without any.
 *
 * @mangled GetCommonItemData__Fi
 * @address 0x197050
 * @size 0x10
 */
CDataCommon *GetCommonItemData(int item_no);

/**
 * Gives the usable item data of an item number, or null when it has none.
 *
 * @mangled GetItemInfoData__Fi
 * @address 0x197060
 * @size 0x10
 */
CDataItem *GetItemInfoData(int item_no);

/**
 * Gives the weapon data of an item number, or null when it is not a weapon.
 *
 * @mangled GetWeaponInfoData__Fi
 * @address 0x197070
 * @size 0x10
 */
CDataWeapon *GetWeaponInfoData(int item_no);

/**
 * Gives the ridepod part data of an item number, or null when it has none.
 *
 * @mangled GetRoboPartInfoData__Fi
 * @address 0x197080
 * @size 0x10
 */
CDataRoboPart *GetRoboPartInfoData(int item_no);

/**
 * Gives the fish data of an item number, or null when it is not a fish.
 *
 * @mangled GetBreedFishInfoData__Fi
 * @address 0x197090
 * @size 0x10
 */
CDataBreedFish *GetBreedFishInfoData(int item_no);

/**
 * Builds the model file name of an item, with the alternate suffix where the story calls for it
 * and the model extension when asked; gives null for an item without common data.
 *
 * @mangled GetItemFileName__Fii
 * @address 0x1970A0
 * @size 0xCC
 */
char *GetItemFileName(int item_no, int with_extension);

/**
 * Builds the path of an item's model file in the directory of its family, or for weapons and
 * item types 0xD and 0xE the path of their alternate model when asked.
 *
 * @mangled GetItemFilePath__Fii
 * @address 0x197170
 * @size 0x180
 */
char *GetItemFilePath(int item_no, int alternate);

/**
 * Gives the item type of an item number, or 0 for a number without common data.
 *
 * @mangled GetItemDataType__Fi
 * @address 0x1972F0
 * @size 0x10
 */
int GetItemDataType(int item_no);

/**
 * Gives the ITEM_ATTRIBUTE bits of an item number, or 0 for a number without common data.
 *
 * @mangled GetItemDataAttribute__Fi
 * @address 0x197300
 * @size 0x38
 */
u32 GetItemDataAttribute(int item_no);

/**
 * Gives the family, a USED_ITEM_TYPE, of an item type.
 *
 * @mangled ConvertUsedItemType__Fi
 * @address 0x197340
 * @size 0xCC
 */
int ConvertUsedItemType(int type);

/**
 * Gives the number of one of an item's messages, or -1 for an item without common data.
 *
 * @mangled GetItemMessageNo__Fii
 * @address 0x197410
 * @size 0x5C
 */
int GetItemMessageNo(int item_no, int message);

/**
 * Gives the display name of an item, or null for an item without common data.
 *
 * @mangled GetItemMessage__Fi
 * @address 0x197470
 * @size 0x38
 */
char *GetItemMessage(int item_no);

/**
 * Gives the menu icon number of an item, or -1 for an item without common data.
 *
 * @mangled GetItemIconNo__Fi
 * @address 0x1974B0
 * @size 0x38
 */
int GetItemIconNo(int item_no);

/**
 * Sets the attachment parameter that spectrumising an item raises, scaled by the item count.
 *
 * @mangled SetItemSpectolPoint__FiP11ATTACH_USEDi
 * @address 0x1974F0
 * @size 0x6C
 */
void SetItemSpectolPoint(int item_no, ATTACH_USED *attach, int num);

/**
 * Fills a list, ended by -1, with the message numbers of the menu commands an item offers,
 * and gives their count.
 *
 * @mangled GetMenuCommandMsg__FiPi
 * @address 0x1975D0
 * @size 0x37C
 */
int GetMenuCommandMsg(int item_no, int *message_list);

/**
 * Gives whether a character can equip an item.
 *
 * @mangled CheckItemEquip__Fii
 * @address 0x197950
 * @size 0x94
 */
int CheckItemEquip(int chara, int item_no);

/**
 * Gives the item number whose display name is the one given, or -1.
 *
 * @mangled SearchItemByName__FPc
 * @address 0x1979F0
 * @size 0x70
 */
int SearchItemByName(char *name);

/**
 * Gives the item number of one of the ridepod cores, or 0 for an index out of range.
 *
 * @mangled GetRidePodCore__Fi
 * @address 0x197A60
 * @size 0x3C
 */
int GetRidePodCore(int index);

/**
 * Copies the effect data of a usable item; gives 0 when it has none.
 *
 * @mangled GetUsedItemAfterEffect__FiP14USEITEM_EFFECT
 * @address 0x197AC0
 * @size 0x80
 */
int GetUsedItemAfterEffect(int item_no, USEITEM_EFFECT *effect);

int ItemCmdMsgSet(int item_no, int *messages);
