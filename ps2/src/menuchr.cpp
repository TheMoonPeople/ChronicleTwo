#include "common.h"
#include "mw_runtime.h"

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "charasetup.hpp"
#include "dataread.hpp"
#include "dynamicanime.hpp"
#include "effscript.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "map.hpp"
#include "mapload.hpp"
#include "mapselect.hpp"
#include "memcard.hpp"
#include "menuaqua.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "menusys.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "npccfg.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "title.hpp"
#include "userdata.hpp"

/**
 *
 * Configuration data for the party change layout.
 *
 */
static u_int *MenuCharaChangePosDataCfgBuffer;

/**
 *
 * Rounds a byte count up to the number of 16-byte memory blocks it occupies.
 *
 */
static inline u_int align16_blocks(u_int size) {
    if (size & 0xF) {
        return (size >> 4) + 1;
    }

    return size >> 4;
}

inline CMenuChrCngMenu::CMenuChrCngMenu() {
    change_phase = (int) CHR_CNG_PHASE_NONE;
    change_chara = -1;
    change_ready = 0;
    MenuCharaChangePosDataCfgBuffer = NULL;
    unk_118 = 0;
    select = 0;
    last_select = 0;
    star_fade = 0;
    enable_change = 0;
    party_member = 0;
    item_brd_select = 0;
    item_brd_pos = 0;
    open_wait = -1;
    set_cursor = 1;
    cursor_wave = 0;
    form = NULL;
    npc_sub_form2 = NULL;
    npc_chara_form = NULL;
    npc_sub_form = NULL;
    npc_mes_form = NULL;
    chara_pos[0] = NULL;
    chara_pos[1] = NULL;
    chara_pos[2] = NULL;
    chara_pos[3] = NULL;
    chara_pos[4] = NULL;
    npc_cmd_mes[0] = 0;
    npc_cmd_mes[1] = 0;
    npc_cmd_mes[2] = 0;
    npc_cmd_mes[3] = 0;
    unk_23C = 0;
    cmd_part[0] = NULL;
    cmd_part[1] = NULL;
    cmd_part[2] = NULL;
    cmd_part[3] = NULL;
    point_gauge_part = NULL;
    set_cursor = 0;
    gauge_part[0] = NULL;
    gauge_part[1] = NULL;
    gauge_part[2] = NULL;
    gauge[0] = NULL;
    gauge[1] = NULL;
    gauge[2] = NULL;
    item_brd_arrived = 0;
    party_info = 0;
    npc_data = 0;
    mes_data = 0;
    sys_mes = NULL;
    npc_no = 0;
    sub_menu = -1;
    sub_menu_next = -1;
    face_state = -1;
    face_chara = -1;
    face_loaded = 0;
    face_img = NULL;
    npc_chara = NULL;
    npc_loading = 0;
    npc_loaded = 0;
    npc_wait = 0;
    npc_show = 0;
    npc_y = 0;
    InitStarInfo();
    key_arg_no = 0;
    close_on_end = 0;
    got_item = 0;
    gift_item = 0;
    gift_num = 0;
    memset(clut_storage, 0, sizeof(clut_storage));
    npc_model_stack.stSetBuffer(NULL, 0);
    npc_build_stack.stSetBuffer(NULL, 0);
}

/**
 *
 * Returns the unused size of a character model stack.
 *
 */
static inline int stack_free_size(mgCMemory *memory) {
    return memory->stack_size - memory->stack_used;
}

/**
 *
 * Returns the current allocation position in a character model stack.
 *
 */
static inline u8 *stack_free_top(mgCMemory *memory) {
    return (u8 *) (memory->stack + memory->stack_used);
}

/**
 *
 * Returns the unused size of a character menu memory region.
 *
 */
static inline int memory_free_size(mgCMemory *memory) {
    return memory->stack_size - memory->stack_used;
}

/**
 *
 * Returns the current allocation position in a character menu memory region.
 *
 */
static inline u8 *memory_free_top(mgCMemory *memory) {
    return (u8 *) (memory->stack + memory->stack_used);
}

/**
 *
 * Names a memory region when the name fits its fixed-size buffer.
 *
 */
static inline void SetMemoryName(mgCMemory *memory, char *name) {
    if (strlen(name) < sizeof(memory->name)) {
        strcpy(memory->name, name);
    }
}

/**
 *
 * Sets the position of a character menu form.
 *
 */
static inline void SetFormPoint(CMenuPosDataForm *form, int x, int y) {
    form->x = x;
    form->y = y;
}

/**
 *
 * Rounds a byte count up to the number of 16-byte memory blocks.
 *
 */
static inline unsigned int blocks_for(unsigned int size) {
    return (size & 0xF) != 0 ? (size >> 4) + 1 : size >> 4;
}

/**
 *
 * Number of monster memo entries.
 *
 */
const int kMonsterMemoCount = 0x119;
/**
 *
 * Frames waited before starting a monster preview load.
 *
 */
const int kModelDelayFrames = 20;
/**
 *
 * Maximum value of the monster preview display wait counter.
 *
 */
const int kModelFrameCap = 20;

/**
 *
 * Commands used to close the monster book or turn its page.
 *
 */
enum {
    kCmdClose = 0xA,
    kCmdTurnPage = 0x64
};

enum {
    kEnvStepSunMoon = 0x38
};

/**
 *
 * Non-zero while the party townsperson model is loading.
 *
 */
static signed char MenuNPCLoadFlag;

/**
 *
 * Number of transformation effect resource pairs read.
 *
 */
static int mos_effect_read_num;

void SetupUnitMan(CScene *scene, CUserDataManager *user_data, int unit, ROBO_INFO_DATA *robo);
void GetBajjiPosition(CMenuPosDataForm *form, int slot, int unused, int *pos);
void SetSwordBlurEffect(CCharacter2 *chara, mgCMemory *stack, int blur_type);

/**
 *
 * Stores a four-component camera point.
 *
 */
struct CameraPoint {
    float xyzw[4]; /**< Camera-space point components. */
};

/**
 *
 * Message numbers of the monster box's badge commands.
 *
 */
enum MOS_SELECT_COMMAND_MSG {
    MOS_SELECT_CMD_TRANSFORM = 0x14B6,   /**< Turns Monica into one of the badge's monsters. */
    MOS_SELECT_CMD_STATUS = 0x14B7,      /**< Shows the status of the badge's monster. */
    MOS_SELECT_CMD_CLASS_CHANGE = 0x14B8 /**< Moves the badge on to a higher class of monster. */
};

/**
 *
 * Page of the monster box shown, as CBaseMenuClass::key_arg_no holds it.
 *
 */
enum MOS_SELECT_PAGE {
    MOS_SELECT_PAGE_BADGE = 0,   /**< The cursor moves over the badges. */
    MOS_SELECT_PAGE_COMMAND = 1, /**< A command of the chosen badge is picked and run. */
    MOS_SELECT_PAGE_STATUS = 2   /**< The status of the badge's monster forms is shown. */
};

/**
 *
 * Step of the badge command page, as CBaseMenuClass::step holds it while key_arg_no is MOS_SELECT_PAGE_COMMAND.
 *
 */
enum MOS_SELECT_COMMAND_STEP {
    MOS_SELECT_STEP_COMMAND = 0,            /**< A badge command is chosen. */
    MOS_SELECT_STEP_ERROR = 1,              /**< A message that the command is not possible waits for a button. */
    MOS_SELECT_STEP_CLASS_SELECT = 10,      /**< The monster to change class to is chosen. */
    MOS_SELECT_STEP_CLASS_CONFIRM = 11,     /**< The class change waits for its yes/no answer. */
    MOS_SELECT_STEP_CLASS_EFFECT = 12,      /**< The class-change effect loads and plays. */
    MOS_SELECT_STEP_CLASS_DONE = 13,        /**< The class change's end message waits for a button. */
    MOS_SELECT_STEP_CLASS_REWARD = 14,      /**< The monster-drop reward message waits for a button. */
    MOS_SELECT_STEP_CLASS_LAST_REWARD = 15, /**< The last class's item reward message waits for a button. */
    MOS_SELECT_STEP_FORM_SELECT = 20        /**< The monster form to transform into is chosen. */
};

/**
 *
 * Transformation effect resources selected for the monster menu.
 *
 */
static MOS_HENGE_PARAM *mos_effect_henge_param;

/**
 *
 * Script buffer for each loaded transformation effect.
 *
 */
static u8 *mos_effect_readbuff1[4];

/**
 *
 * Script byte count for each loaded transformation effect.
 *
 */
static int mos_effect_readbuff1_size[4];

/**
 *
 * Pack buffer for each loaded transformation effect.
 *
 */
static u8 *mos_effect_readbuff2[4];

/**
 *
 * Pack byte count for each loaded transformation effect.
 *
 */
static int mos_effect_readbuff2_size[4];

/**
 *
 * Dimensions of the monster badge grid.
 *
 */
enum {
    MOS_SELECT_GRID_COLUMNS = 4, /**< Columns of monster badges. */
    MOS_SELECT_GRID_ROWS = 3     /**< Rows of monster badges. */
};

/**
 *
 * Active monster selection menu.
 *
 */
static CMenuMosSelect *MenuMosSelectPtr;

/**
 *
 * Character whose menu sound archive is loaded.
 *
 */
static int MenuSoundCharaNo = -1;

/**
 *
 * Texture sliding across the main character background.
 *
 */
static mgCTexture *NowMainCharaChngTex;

/**
 *
 * Frame texture of the main character background.
 *
 */
static mgCTexture *NowMainCharaFrameImage;

/**
 *
 * Status flags for the main character background transition.
 *
 */
static short NowMainCharaChngStatusBit;

/**
 *
 * Current phase of the sliding character texture.
 *
 */
static int NowMainCharaChngTexMovePhase;

/**
 *
 * Horizontal position of the sliding character texture.
 *
 */
static int NowMainCharaChngTexMoveX;

/**
 *
 * Main character whose quick-change background load is pending.
 *
 */
static short NowReadMainCharaNo = -1;

/**
 *
 * Pack data read for the party townsperson model.
 *
 */
static u_int *MenuPartyNPCModelReadBuffer;

/**
 *
 * Current phase of the costume menu model load.
 *
 */
static short MenuCosutumeLoadPhase;

/**
 *
 * Bit mask of costumes available to the costume menu.
 *
 */
static unsigned long CostumeAttr;

/**
 *
 * Active costume selection menu.
 *
 */
static CMenuCostumeSel *MenuCosPtr;

/**
 *
 * Active monster book menu.
 *
 */
static CMosBookMenu *MenuMosBookPtr;

/**
 *
 * Saved monster book records displayed by the menu.
 *
 */
static u8 *MonsterBookPtr;

/**
 *
 * Opening mode of the monster book.
 *
 */
static short MonsterBookBootMode;

/**
 *
 * Panel texture of the monster book.
 *
 */
static mgCTexture *Tex_MBase;

/**
 *
 * Heading texture of the monster book.
 *
 */
static mgCTexture *Tex_MBook;

/**
 *
 * Background texture of the monster book.
 *
 */
static mgCTexture *Tex_MBg;

/**
 *
 * Monster family names displayed by the book for each supported language.
 *
 */
static char *monster_type_name[LANG_CHINESE + 1][12] = {
    {
     "",
     "",
     "",
     "",
     "",
     "",
     "",
     "",
     "",
     "",
     "",
     "",
     },
    {
     "???",
     "Beast",
     "Windup",
     "Aquatic",
     "Flora",
     "Magical Creature",
     "Darkling",
     "Reptile Family",
     "Spirit",
     "Undead",
     "Card",
     "???",
     },
    {
     "???",
     "Animal",
     "Robotis[UNI00e9]",
     "Aquatique",
     "V[UNI00e9]g[UNI00e9]tal",
     "Cr[UNI00e9]ature magique",
     "Cr[UNI00e9]ature obscure",
     "Reptile",
     "Esprit",
     "Mort-vivant",
     "Carte",
     "???",
     },
    {
     "???",
     "Tier",
     "Aufzieh-Figur",
     "Wassertier",
     "Flora",
     "Zauberwesen",
     "D[UNI00fc]sterling",
     "Reptil",
     "Geist",
     "Untoter",
     "Karte",
     "???",
     },
    {
     "???",
     "Bestia",
     "Robot",
     "Acquatico",
     "Flora",
     "Creatura magica",
     "Oscuro",
     "Rettile",
     "Spirito",
     "Nonmorto",
     "Carta",
     "???",
     },
    {
     "???",
     "Bestia",
     "Broma",
     "Acu[UNI00e1]tico",
     "Flora",
     "Criatura m[UNI00e1]gica",
     "Misterioso",
     "Familia de reptiles",
     "Esp[UNI00ed]ritu",
     "Muerto Viviente",
     "Carta",
     "???",
     },
    {
     "???",
     "Beast",
     "Windup",
     "Aquatic",
     "Flora",
     "Magical Creature",
     "Darkling",
     "Reptile Family",
     "Spirit",
     "Undead",
     "Card",
     "???",
     },
};

/**
 *
 * Weakness names displayed by the book for each supported language.
 *
 */
static char *monster_jyakuten[LANG_CHINESE + 1][8] = {
    {
     "",
     "",
     "",
     "",
     "",
     "",
     "",
     "",
     },
    {
     "Fl.",
     "Ch.",
     "Li.",
     "Cy.",
     "Sm.",
     "Ex.",
     "Be.",
     "Sc.",
     },
    {
     "Fe.",
     "Fr.",
     "[UNI00c9]c.",
     "Cy.",
     "Ma.",
     "Ex.",
     "An.",
     "[UNI00c9]c.",
     },
    {
     "Hi.",
     "K[UNI00e4].",
     "Bl.",
     "To.",
     "Ze.",
     "Ex.",
     "Ti.",
     "Sc.",
     },
    {
     "Fu.",
     "Gh.",
     "Li.",
     "Ci.",
     "Di.",
     "Es.",
     "Be.",
     "Sq.",
     },
    {
     "Ll.",
     "Fr.",
     "Ra.",
     "Ci.",
     "Ap.",
     "Ex.",
     "Co.",
     "De.",
     },
    {
     "Fl.",
     "Ch.",
     "Li.",
     "Cy.",
     "Sm.",
     "Ex.",
     "Be.",
     "Sc.",
     },
};

/**
 *
 * Character model information configuration filename.
 *
 */
static char menu_infocfgname[10] = "info.cfg";

/**
 *
 * Background read requests for the monster menu character slots.
 *
 */
static MENU_BGREAD_INFO2 *MenuMonsterBGInfo[MENU_CHARA_LOAD_MAX];

/**
 *
 * Main character model archive names.
 *
 */
static char *menu_chara_chrtbl[2] = {
    "c01b_menu.chr",
    "c02a_menu.chr",
};

/**
 *
 * Main character animation configuration names.
 *
 */
static char *menu_chara_cfg_chrtbl[2] = {
    "c01.stb",
    "c02.stb",
};

/**
 *
 * Current phase of the main character background read.
 *
 */
static short NowReadMainCharaPhase;

/**
 *
 * Main character model loaded for the menu background.
 *
 */
static CActionChara *NowReadMainChara;

/**
 *
 * Monster used by the pending main character background load.
 *
 */
static short NowReadMainCharaMonsterNo = -1;

/**
 *
 * Position preserved while replacing the main character background model.
 *
 */
static sceVu0FVECTOR NowMainReadPosition;

/**
 *
 * Rotation preserved while replacing the main character background model.
 *
 */
static sceVu0FVECTOR NowMainReadRotation;

/**
 *
 * Darkened palette used by the party change ring.
 *
 */
static CHR_CNG_CLUT_COLOR *MenuCharaChangeCLUT;

/**
 *
 * Background texture of the monster selection menu.
 *
 */
static mgCTexture *MenuMosTexture;

/**
 *
 * Character category selected by the party change debug controls.
 *
 */
static short MenuDebugChangeSelectMode;

/**
 *
 * Character index selected by the party change debug controls.
 *
 */
static short MenuDebugCharaChangeSelect;

/**
 *
 * Non-zero when the debug townsperson selection is confirmed.
 *
 */
static s8 menu_debug_npc_decide;

/**
 *
 * Townsperson selected by the party change debug controls.
 *
 */
static s8 menu_debug_npcselect;

/**
 *
 * Number of resistance or weakness icons that the monster book can display.
 *
 */
enum {
    MOS_BOOK_AFFINITY_NUM = 8
};

/**
 *
 * Page counter format of the monster book for each supported language.
 *
 */
static char *monstere_file_template[LANG_CHINESE + 1] = {
    " ",
    "  File  %3d/%3d",
    "Fichier %3d/%3d",
    "  Datei %3d/%3d",
    "  File  %3d/%3d",
    "Archivo %3d/%3d",
    "  File  %3d/%3d",
};

/**
 *
 * Monster selected by the monster menu debug controls.
 *
 */
static int menu_debug_select__2;

int CosutmeSelDefaultSet(int costume_id, short *costume_list);

/**
 *
 * Monster resource directories indexed by model file category.
 *
 */
static char *MonsterDataPath[3] = {
    "menu/mhenge/",
    "dungeon/monster/",
    "menu/monster/",
};

/**
 *
 * Script name associated with the monster model being read.
 *
 */
static char script_file_name[0x20];

/**
 *
 * Monster whose menu model background load is pending.
 *
 */
static short monster_load_id = -1;

/**
 *
 * Active party change menu.
 *
 */
static CMenuChrCngMenu *ChrChangMenuPt;

/**
 *
 * Non-zero after the party acquisition sound has played.
 *
 */
static u8 MenuGetPartySeFlag;

static int  MenuMemoryDivide(mgCMemory *memory, mgCMemory **list, int chara);
static void MenuItemCharaDataLoadPack(int chara_no, CActionChara *chara, CActionChara *body, int part,
                                      u_int *pack, mgCMemory *stack, int tex_block, int blur_type);
/**
 *
 * Quadword capacities of the ridepod menu work buffers.
 *
 */
static const u16 menu_robo_memorytbl[MENU_CHARA_LOAD_MAX] = {
    0x5240, 0x4514, 0x6E80, 0x1240, 0x05DC, 0, 0};

/**
 *
 * Quadword capacities of the human character menu work buffers.
 *
 */
static const u16 menu_chr_memorytbl[MENU_CHARA_LOAD_MAX] = {
    0x1B80, 0x9AC0, 0x1C84, 0x11C0, 0x0BC0, 0x26C0, 0x0708};
int ReadBGSync();

// Code (.text)
void InitMenuBGReadInfo2(MENU_BGREAD_INFO2 *info) {
    info->reading = 0;
    info->chara = NULL;
    info->name[0] = 0;
    info->path[0] = 0;
}

int MenuLoadFileCheck(MENU_BGREAD_INFO2 **slots) {
    int found = 0;

    for (int i = 0; i < 7; i++) {
        if (slots[i] != NULL && slots[i]->reading != 0) {
            found = 1;
        }
    }

    return found;
}

void MenuBGReadInfo2Malloc(mgCMemory *memory, int *wanted) {
    for (int i = 0; i < 7; i++) {
        if (wanted[i] != 0) {
            MenuCharaBuild2[i] = (MENU_BGREAD_INFO2 *) memory->Alloc(8);
            InitMenuBGReadInfo2(MenuCharaBuild2[i]);
        } else {
            MenuCharaBuild2[i] = NULL;
        }
    }
}

short ConvertCharaLoadDataPhase(int a0, int a1) {
    /**
     *
     * Loading phase of each playable character and equipment part.
     *
     */
    static short tbl[USER_CHARA_NUM * 5] = {2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 1, 2, 4, 0, 0, 0, 0, 0, 0, 0};

    return tbl[a1 + a0 * 5];
}

int CheckBattleLoop() {
    if (MenuCommonInfo == NULL) {
        return 1;
    }

    short menu_type = MenuCommonInfo->open_type;

    if (menu_type == 1 || menu_type == 17 || menu_type == 14 || menu_type == 21) {
        return 1;
    }

    return 0;
}

void SetMenuLoadItemNo(int who) {
    int               count = 0;
    CUserDataManager *user_data = GetUserDataMan();

    if (user_data == NULL) {
        return;
    }

    switch (who) {
        case 0:
        case 1: {
            CHARA_DATA *chara = user_data->GetCharaDataPtr(who);

            do {
                MenuLoadItemNo[count] = chara->equip[count].item_no;
                count++;
            } while (count < 5);

            break;
        }
        case 2: {
            ROBO_DATA &robo = user_data->robo_data;
            MenuLoadItemNo[0] = robo.parts[3].item_no;
            MenuLoadItemNo[1] = robo.parts[0].item_no;
            MenuLoadItemNo[2] = robo.parts[1].item_no;
            MenuLoadItemNo[3] = 0;
            MenuLoadItemNo[4] = robo.parts[2].item_no;
            count = 5;
            break;
        }
    }

    while (count < 12) {
        MenuLoadItemNo[count] = 0;
        count++;
    }
}

/**
 *
 * Partitions character menu memory among its work buffers.
 *
 */
static int MenuMemoryDivide(mgCMemory *memory, mgCMemory **list, int chara) {
    int total;
    memory->Align64();
    u_long128 *buffer = memory->stGetTop();
    total = 0;

    switch (chara) {
        case USER_CHARA_MAX:
        case USER_CHARA_MONICA:
        case USER_CHARA_ROBO: {
            const u16 *table = menu_chr_memorytbl;

            if (chara == USER_CHARA_ROBO) {
                table = menu_robo_memorytbl;
            }

            for (int i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
                char name[0x20];
                int  size = table[i];

                if (table[i] % 64 != 0) {
                    size = (64 - table[i] % 64) + table[i];
                }

                sprintf(name, "stack %d\n", i);
                SetMemoryName(list[i], name);
                list[i]->stSetBuffer(buffer, size);
                total += size;
                buffer = &list[i]->stGetTop()[size];
            }

            break;
        }
        case USER_CHARA_MONSTER:
            list[0]->stSetBuffer(buffer, 0x6400);
            list[5]->stSetBuffer(&buffer[0x6400], 0x3C0);
            total = 0x67C0;
            break;
    }

    return total;
}

void MenuMemoryAdjust(mgCMemory *pool, mgCMemory *rest, mgCMemory *buffers, int chara) {
    int        free_blocks = pool->stack_size - pool->stack_used;
    mgCMemory *list[7] = {NULL, NULL, NULL, NULL, NULL, NULL, NULL};
    list[0] = buffers;
    list[1] = buffers + 1;
    list[2] = buffers + 2;
    list[3] = buffers + 3;
    list[4] = buffers + 4;
    list[5] = buffers + 5;
    list[6] = buffers + 6;
    int used = MenuMemoryDivide(pool, list, chara);
    rest->stSetBuffer(buffers->stack + buffers->stack_used + used,
                      free_blocks - used);

    if (strlen("LOAD STACK") < 16) {
        strcpy(rest->name, "LOAD STACK");
    }

    rest->stack_used = 0;
    rest->lock = 0;
}

void DeleteMonsterEffect() {
    if (FxScriptMan != NULL) {
        FxScriptMan->ClearEffectFromChrid(0);
        FxScriptMan->level = 2;
        FxScriptMan->ClearBaseFromLevel(2, NULL, -1);
    }

    mgTexManager.DeleteBlock(0xAA);
}

void SetMessagePositionNPCForm(CMenuPosDataForm *form, CDC2Mes *mes) {
    if (form == NULL || mes == NULL) {
        return;
    }

    int  pos[10];
    int *point;
    form->GetPutPosXY("pname", pos[0], pos[1]);
    point = &pos[2];
    form->GetPutPosXY("setu0", point[0], point[1]);
    point = &pos[4];
    form->GetPutPosXY("setu1", point[0], point[1]);
    point = &pos[6];
    form->GetPutPosXY("setu2", point[0], point[1]);
    point = &pos[8];
    form->GetPutPosXY("setu3", point[0], point[1]);
    mes->SetMsgItemPos(pos, 5);
    mes->SetMovePosCenteringGyou(0, pos[0], pos[1]);
}

void AdjustNPCTalk(CDC2Mes *mes, CCharacter2 *npc) {
    ClsMes *bubble = (ClsMes *) mes;

    if (bubble == NULL || npc == NULL) {
        return;
    }

    int screen_pos[4];
    bubble->fukidashi_pos = 5;
    bubble->tail_on = 1;
    GetScrPosFromChar(npc, screen_pos);
    screen_pos[2] = 0;
    screen_pos[3] = 0xBE;
    bubble->AutoSet(screen_pos);
}

void CMenuChrCngMenu::AttachForm() {
    char name[0x20];
    int  i;
    int  j;

    form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("chr_bg");

    if (form != NULL) {
        gauge_part[0] = form->GetPartInfo("hpfill0");
        gauge_part[1] = form->GetPartInfo("hpfill1");
        gauge_part[2] = form->GetPartInfo("hpfill2");
    }

    (&npc_mes_form)[0] = (CMenuPosDataForm *) MenuPosData->GetFormInfo("polywin");
    (&npc_mes_form)[1] = (CMenuPosDataForm *) MenuPosData->GetFormInfo("polywin_bg");
    (&npc_mes_form)[2] = (CMenuPosDataForm *) MenuPosData->GetFormInfo("polychr");
    (&npc_mes_form)[3] = (CMenuPosDataForm *) MenuPosData->GetFormInfo("polywin_chrhide");
    (&npc_mes_form)[2]->SetActionCharaPtr(NULL, 0, -1);

    for (i = 0; i < 5; i++) {
        sprintf(name, "namep%d", i);
        chara_pos[i] = MenuPosData->GetEtcTbl(name);
    }

    point_gauge_part = form->GetPartInfo("stbar");

    for (j = 0; j < 4; j++) {
        sprintf(name, "cmd%d", j);
        cmd_part[j] = form->GetPartInfo(name);
    }
}

void CMenuChrCngMenu::EnterDataMenu(u_char *pack) {
    /**
     *
     * Part names of townsperson command point costs.
     *
     */
    static char *tbl[CHR_CNG_NPC_COMMAND_NUM] = {
        "sp0",
        "sp1",
        "sp2",
        "sp3",
    };

    int                 i;
    mgCTextureManager  *tex_manager = &mgTexManager;
    int                 block = tex_block[0];
    int                 size;
    int                 palette_index;
    CHR_CNG_CLUT_COLOR *color;

    tex_manager->EnterIMGFile((u_char *) GetPackFile(reinterpret_cast<u_int *>(pack), "chr_bg.img", NULL), block,
                              NULL, NULL);
    u_int *cfg = GetPackFile(reinterpret_cast<u_int *>(pack), "chrchg.cfg", &size);

    if (MenuCharaChangePosDataCfgBuffer == NULL && cfg != NULL) {
        MenuCharaChangePosDataCfgBuffer = cfg;
        MenuDataAnalyze((char *) cfg, size, &MenuChangeMemory);
    }

    MenuRepairMan->Initialize();
    MenuRepairMan->SetRepairData(&MenuChangeMemory, block, reinterpret_cast<u_int *>(pack));
    script = (char *) GetPackFile(reinterpret_cast<u_int *>(pack), "chr_com.cfg", &script_size);
    MenuCharaChangeStar_Tex = tex_manager->GetTexture("menueff0", -1);
    MenuCharaChangeBase_Tex = tex_manager->GetTexture("chr0", -1);
    MenuCharaChangeCLUT = palette.clut;
    tex_manager->ReloadTexture(block, (sceVif1Packet *) NULL);

    if (MenuCharaChangeCLUT_Tex == NULL) {
        MenuCharaChangeCLUT_Tex = new (MenuChangeMemory.Alloc(9)) mgCTexture;
    }

    memcpy(MenuCharaChangeCLUT_Tex, MenuCharaChangeBase_Tex, sizeof(mgCTexture));
    memcpy(MenuCharaChangeCLUT, MenuCharaChangeBase_Tex->clut, sizeof(palette.clut));
    MenuCharaChangeCLUT_Tex->clut = (u_long128 *) MenuCharaChangeCLUT;

    // Darken the copied palette into brightness bands, keeping each colour's alpha.
    for (palette_index = 0, color = MenuCharaChangeCLUT; palette_index < CHR_CNG_CLUT_NUM; palette_index++, color++) {
        float luminance = (float) ((color->r + color->g + color->b) / 3);
        int   step = 1;

        do {
            if (8.0f * (float) (step - 1) <= luminance && luminance < 8.0f * (float) step) {
                break;
            }

            step++;
        } while (step < CHR_CNG_CLUT_BAND_NUM + 1);

        color->r = (u8) (7.75f * (float) step);
        color->g = (u8) (5.625f * (float) step);
        color->b = (u8) (4.6875f * (float) step);
    }

    MenuPosData->InitDrawList();
    AttachForm();
    AttachMessageForm();
    ExeScript("INIT_FORM");
    party_member = MenuUserDataManPtr->GetNowPartyMember();
    enable_change = MenuUserDataManPtr->GetEnableCharaChangeFlag();

    for (i = 0; i < USER_CHARA_NUM; i++) {
        char name[32];
        sprintf(name, "clut%d", i);
        MENUFORMPARTS_TYPE *locked = form->GetPartInfo(name);
        sprintf(name, "clut0%d", i);
        MENUFORMPARTS_TYPE *other = form->GetPartInfo(name);
        sprintf(name, "fc%d", i);
        MENUFORMPARTS_TYPE *face = form->GetPartInfo(name);
        locked->draw_flag = 1;

        if (party_member & (1 << i)) {
            face->draw_flag = 1;
            locked->draw_flag = 1;
            other->draw_flag = 0;

            if ((i < USER_CHARA_ROBO && (enable_change & (1 << i))) || i >= USER_CHARA_ROBO) {
                locked->draw_flag = 0;
            } else {
                other->draw_flag = 1;
            }
        } else {
            face->draw_flag = 0;
        }
    }

    UpdataLife();
    mes_data = (s16 *) GetPackFile(reinterpret_cast<u_int *>(pack), "npcmsg.mes", NULL);
    sys_mes = MenuDCMsg[0]->buff;
    MenuCommandAnalyzeInfo.system_mes_buff[0] = GetSystemMesBuffer();
    MenuCommandAnalyzeInfo.system_mes_buff[1] = mes_data;
    MenuCommandAnalyzeInfo.mes_buff[0] = sys_mes;
    MenuCommandAnalyzeInfo.mes_buff[1] = mes_data;

    if (key_arg_no == 2) {
        MenuDCMsg[0]->SetBuff(mes_data);
    }

    npc_mes_talk = 0;
    npc_mes_cmd = 0;
    npc_mes_cancel = 0;

    for (i = 0; i < CHR_CNG_NPC_COMMAND_NUM; i++) {
        npc_cmd_mes[i] = 0;
    }

    unk_23C = 0;
    party_info = NULL;
    npc_data = NULL;
    npc_no = MenuUserDataManPtr->NowPartyCharaID();

    if (npc_no > 0) {
        party_info = MenuUserDataManPtr->GetPartyCharaInfo(npc_no);
        npc_data = GetPartyNPCData(npc_no);
        npc_mes_talk = GetPartyCharaMessage(npc_no, 1, 0);
        npc_mes_cmd = GetPartyCharaMessage(npc_no, 0, 0);
        npc_mes_cancel = GetPartyCharaMessage(npc_no, 3, 0);
        int first_message = GetPartyCharaMessage(npc_no, 5, 0);

        // Each ability's command takes the message after the previous one; unused slots stay empty.
        for (i = 0; i < npc_data->ability_num; i++) {
            npc_cmd_mes[i] = first_message + i;
        }

        for (; i < CHR_CNG_NPC_COMMAND_NUM; i++) {
            npc_cmd_mes[i] = 0;
        }

        if (npc_data->ability_num == 0) {
            npc_cmd_mes[0] = 10;
        }

        for (i = 0; i < npc_data->ability_num; i++) {
            form->SetNumber(tbl[i], npc_data->ability_cost[i]);
        }

        for (; i < CHR_CNG_NPC_COMMAND_NUM; i++) {
            form->SetPartDrawFlag(tbl[i], 0);
        }
    }
}

void CMenuChrCngMenu::LoadNPCFaceData(mgCMemory *memory, int mode) {
    char         path[0x40];
    unsigned int size;

    memory->stack_used = 0;
    memory->lock = 0;
    face_loaded = mode;
    face_img = NULL;
    face_chara = MenuUserDataManPtr->NowPartyCharaID();

    if (face_chara < 0) {
        face_loaded = 1;
        face_state = -1;
    } else {
        face_state = 0;

        if (face_chara <= 0) {
            face_chara = 1;
        }

        if (face_chara > 26) {
            face_chara = 26;
        }

        sprintf(path, "npcface/%d.img", face_chara);
        memory->Align64();
        face_img = reinterpret_cast<u8 *>(memory->stGetTop());
        size = LoadFileMenu(path, (u_long128 *) face_img, mode);
        memory->Alloc((size & 0xF) ? (size >> 4) + 1 : size >> 4);
    }
}

void CMenuChrCngMenu::EnterNPCFaceData() {
    signed char load_state;

    if ((face_state == 0) && ((load_state = face_loaded, (load_state == 1)) ||
                              ((load_state == 0) && (ReadBGSync() == 0)))) {
        mgTexManager.EnterIMGFile(face_img, tex_block[0], NULL, NULL);
        face_state = 1;
        ExeScript("NPCFACEEND");
    }
}

#pragma inline_depth(8)

int CMenuChrCngMenu::LoadBGNPCModel(int restart_read) {
    mgCMemory *stack = &MenuCharaLoadStack;
    stack->stReset();
    npc_chara = new (stack->Alloc(0x105)) CActionChara;
    npc_chara->Initialize(NULL);
    stack->Align64();
    npc_build_stack.stSetBuffer(stack->stGetTop(), 0xCD00);
    stack->Alloc(0xCD00);
    int rest = stack->stGetRest();
    npc_model_stack.stSetBuffer(stack->stGetTop(), rest);
    npc_loading = 0;
    npc_loaded = 0;
    npc_wait = 0;
    npc_show = 0;

    if (restart_read) {
        BreakReadBG();
        StartReadBG();
    }

    int size = MenuNPCModelLoad(&npc_model_stack, face_chara, restart_read);
    npc_y = 0.0f;

    if (size > 0) {
        npc_loading = 1;
    } else {
        npc_chara = NULL;
    }

    ExeScript("CHRFADEPRE");
    return size;
}

#pragma inline_depth reset

int CMenuChrCngMenu::CheckBGNPCModel() {
    int load_result;

    load_result = 0;

    if (ReadBGSync() == 0) {
        load_result = MenuNPCLoadCheck(npc_chara, &npc_build_stack, tex_block[1]);
    }

    if (npc_chara == NULL) {
        return 0;
    }

    if (key_arg_no == 3) {
        npc_y = npc_y + ((-2.8f - npc_y) / 6.0f);
    } else {
        npc_y = npc_y + ((-16.6f - npc_y) / 6.0f);
    }

    sceVu0FVECTOR position = {14.0f, 0.0f, 0.0f, 1.0f};
    position[1] = npc_y;

    if (load_result == 1) {
        npc_loaded = 1;
        npc_wait = 0;
        ((CCharacter2 *) npc_chara)->SetRotation(0.0f, -0.07853982f, 0.0f);
        (&npc_mes_form)[2]->counter = 0;
    }

    if (npc_loaded != 0) {
        ((CCharacter2 *) npc_chara)->SetScale(1.0f, 1.0f, 1.0f);

        if (npc_no == 9) {
            MenuAdjustPolygonScale((CCharacter2 *) npc_chara, 5.655f);
        } else {
            MenuAdjustPolygonScale((CCharacter2 *) npc_chara, 6.96f);
        }

        ((CCharacter2 *) npc_chara)->SetPosition(position);
        ((CCharacter2 *) npc_chara)->Step();

        if ((&npc_mes_form)[2]->counter >= 0xF && (&npc_mes_form)[1]->y < 60.0f) {
            ExeScript("CHRFADEIN");
        }

        if (npc_wait < 0x15) {
            npc_wait = npc_wait + 1;
        } else {
            npc_show = 1;
        }

        if (npc_show != 0) {
            (&npc_mes_form)[2]->SetActionCharaPtr(npc_chara, tex_block[1], -1);
        }

        if (key_arg_no != 3) {
            npc_show = 0;
        }

        if (-166.0f < form->y) {
            npc_show = 0;
        }

        if (select != 4) {
            npc_show = 0;
        }

        if (36.0f < (&npc_mes_form)[2]->y) {
            npc_show = 0;
        }

        (&npc_mes_form)[2]->draw_flag = npc_show != 0;
    }

    return load_result;
}

void EditCharaPrepare() {
    CActionChara *chara = (CActionChara *) MenuMainScene->GetCharacter(1);

    if (chara != NULL) {
        chara->Initialize(NULL);
    }

    chara = (CActionChara *) MenuMainScene->GetCharacter(2);

    if (chara != NULL) {
        chara->Initialize(NULL);
    }
}

int CMenuChrCngMenu::KeyChangeMain() {
    /**
     *
     * Selection the character cursor moves to, eight directions (up, then clockwise)
     * for each of the five selections, read as [select * 8 + direction].
     *
     */
    static s8 nextIDtbl[40] = {
        0, 0, 2, 2, 2, 1, 1, 0,
        3, 0, 0, 1, 4, 4, 3, 3,
        0, 0, 2, 2, 2, 2, 0, 0,
        3, 3, 1, 1, 1, 3, 3, 3,
        1, 1, 1, 1, 4, 4, 4, 4};

    /**
     *
     * Party character message numbers used by character change commands.
     *
     */
    static s16 msgtbl1[USER_CHARA_NUM] = {410, 411, 412, 413};

    /**
     *
     * Sounds selected by the party change action outcome.
     *
     */
    static s8 se_sndtbl[3] = {1, 1, 15};

    CMenuKeyFunc *key_func = MenuCommonInfo;
    key_func->SelDataInit();
    int            keys = key_func->CheckSelectKey();
    int            buttons = key_func->CheckPushButton();
    CDC2Mes       *title_mes = MenuDCMsg[2];
    CDC2Mes       *answer_mes = MenuDCMsg[3];
    CDC2Mes       *cmd_mes = MenuDCMsg[4];
    CDC2Mes       *npc_mes = MenuDCMsg[5];
    CDC2Mes       *repair_mes = MenuDCMsg[7];
    int            action = 0;
    CGameDataUsed *item = NULL;
    int            cancelled = 0;
    static s8      SelectedCmdNo = -1;

    switch (key_arg_no) {
        case 2:
            if (buttons) {
                action = 0x1E;
            }

            break;
        case 3:
            switch (step) {
                case 0: {
                    int last_cmd = npc_data->ability_num - 1;

                    if (last_cmd < 0) {
                        last_cmd = 0;
                    }

                    switch (key_func->open_type) {
                        case MENU_OPEN_CHARA_CHANGE: {
                            if (buttons) {
                                mode = MENU_ASK_MODE_CLOSE;
                                ExeScript("GET_P_END");
                            }

                            break;
                        }
                        default: {
                            if (npc_data->ability_num > 0) {
                                cmd_mes->AddMsgCursor2(0, last_cmd, 1);
                            }

                            if (menu_debug_flag) {
                                if (keys & MENU_SELECT_KEY_RIGHT) {
                                    party_info->point++;
                                }

                                if (keys & MENU_SELECT_KEY_LEFT) {
                                    party_info->point--;
                                }

                                if (npc_data->max_npc_point < party_info->point) {
                                    party_info->point = npc_data->max_npc_point;
                                }

                                if (party_info->point < 0) {
                                    party_info->point = 0;
                                }
                            }

                            SelectedCmdNo = -1;

                            switch (buttons) {
                                case MENU_PUSH_BUTTON_DECIDE:
                                case MENU_PUSH_BUTTON_TRIANGLE:
                                    action = 5;

                                    if (npc_data->ability_num > 0) {
                                        action = 100;
                                        SelectedCmdNo = cmd_mes->GetMsgCursor();
                                    }

                                    break;
                                case MENU_PUSH_BUTTON_CANCEL:
                                    action = 0x3C;
                                    break;
                            }

                            break;
                        }
                    }

                    break;
                }
                case 1:
                case 2:
                    if (buttons) {
                        cancelled = 1;
                        action = 0x1E;

                        if (close_on_end) {
                            mode = MENU_ASK_MODE_CLOSE;
                            ExeScript("GET_P_END");
                            action = -1;
                            MenuArg.end_code = 5;
                            MenuArg.result[0] = 1;
                            MenuArg.result[1] = 1;
                            MenuArg.result[2] = 0;
                        }

                        if (got_item) {
                            step = 3;
                        }
                    }

                    break;
                case 3:
                    break;
                case 10: {
                    int widest;

                    if (npc_mes->page_num <= 0) {
                        widest = 0;
                    } else {
                        int max_chars = 0;

                        for (int i = 0; i < npc_mes->page_num; i++) {
                            if (max_chars < npc_mes->page_chars[i]) {
                                max_chars = npc_mes->page_chars[i];
                            }
                        }

                        widest = max_chars;
                    }

                    int cursor = npc_mes->AddMsgCursor2(widest - 2, widest - 1, 1);

                    switch (buttons) {
                        case MENU_PUSH_BUTTON_DECIDE:
                            if (cursor - (widest - 2) == 0) {
                                action = 0x5A;

                                if (npc_no == 1) {
                                    if (SelectedCmdNo == 0) {
                                        action = 0xC8;
                                    }

                                    if (SelectedCmdNo == 1) {
                                        action = 0xC9;
                                    }
                                }

                                break;
                            }
                        case MENU_PUSH_BUTTON_CANCEL:
                            action = 0x1E;
                            cancelled = 1;
                            break;
                    }

                    break;
                }
                case 11:
                    break;
                case 20:
                    MenuItemBrdKey(keys, &item_brd_select, &item_brd_pos, 0);

                    switch (buttons) {
                        case MENU_PUSH_BUTTON_DECIDE:
                        case MENU_PUSH_BUTTON_TRIANGLE:
                            item = MenuDrawItemInfo[item_brd_select];
                            action = 5;

                            if (item != NULL && item->IsRepair()) {
                                action = 0x5A;
                            }

                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            action = 0x1E;
                            ExeScript("BACK_NPCVIEW");
                            MenuCommonInfo->SetWakuType(-1);
                            break;
                    }

                    break;
            }

            break;
        case 1: {
            int answer = cmd_mes->YesNoCursor();

            switch (buttons) {
                case MENU_PUSH_BUTTON_DECIDE:
                case MENU_PUSH_BUTTON_TRIANGLE:
                case MENU_PUSH_BUTTON_SQUARE:
                    if (answer == 0) {
                        action = 0x14;
                        break;
                    }
                case MENU_PUSH_BUTTON_CANCEL:
                    action = 0x50;
                    break;
            }

            break;
        }
        case 0:
            if (change_phase) {
                keys = 0;
            }

            if (0 < open_wait) {
                if (buttons) {
                    ExeScript("CHANGE_CANCEL");
                    MenuCommonInfo->CursorFadeIn(6.0f, 0);
                    open_wait = 0;
                }

                break;
            }

            if (menu_debug_flag) {
                if (select != 4) {
                    int lr = MenuCommonInfo->CheckLRKey();

                    if (lr & MENU_SELECT_KEY_R1 || lr & MENU_SELECT_KEY_RIGHT) {
                        MenuDebugChangeSelectMode++;
                    }

                    if (lr & MENU_SELECT_KEY_L1 || lr & MENU_SELECT_KEY_LEFT) {
                        MenuDebugChangeSelectMode--;
                    }

                    if (MenuDebugChangeSelectMode < 0) {
                        MenuDebugChangeSelectMode = 2;
                    }

                    if (MenuDebugChangeSelectMode > 2) {
                        MenuDebugChangeSelectMode = 0;
                    }

                    if (MenuDebugChangeSelectMode == 0) {
                        if (lr & MENU_SELECT_KEY_UP) {
                            MenuDebugCharaChangeSelect--;
                        }

                        if (lr & MENU_SELECT_KEY_DOWN) {
                            MenuDebugCharaChangeSelect++;
                        }

                        if (MenuDebugCharaChangeSelect < 0) {
                            MenuDebugCharaChangeSelect = 3;
                        }

                        if (MenuDebugCharaChangeSelect > 3) {
                            MenuDebugCharaChangeSelect = 0;
                        }

                        if (buttons & MENU_PUSH_BUTTON_DECIDE && MenuDebugCharaChangeSelect < 4) {
                            MenuUserDataManPtr->JoinPartyMember(MenuDebugCharaChangeSelect);
                        }

                        if (buttons & MENU_PUSH_BUTTON_CANCEL && MenuDebugCharaChangeSelect < 4) {
                            MenuUserDataManPtr->LeavePartyMember(MenuDebugCharaChangeSelect);
                        }
                    }

                    if (MenuDebugChangeSelectMode == 1) {
                        if (lr & MENU_SELECT_KEY_UP) {
                            MenuDebugCharaChangeSelect--;
                        }

                        if (lr & MENU_SELECT_KEY_DOWN) {
                            MenuDebugCharaChangeSelect++;
                        }

                        if (MenuDebugCharaChangeSelect < 0) {
                            MenuDebugCharaChangeSelect = 3;
                        }

                        if (MenuDebugCharaChangeSelect > 3) {
                            MenuDebugCharaChangeSelect = 0;
                        }

                        if (buttons & MENU_PUSH_BUTTON_DECIDE) {
                            MenuUserDataManPtr->EnableCharaChange(MenuDebugCharaChangeSelect);
                        }

                        if (buttons & MENU_PUSH_BUTTON_CANCEL) {
                            MenuUserDataManPtr->DisableCharaChange(MenuDebugCharaChangeSelect);
                        }
                    }

                    if (MenuDebugChangeSelectMode == 2) {
                        if (lr & MENU_SELECT_KEY_UP) {
                            MenuDebugCharaChangeSelect--;
                        }

                        if (lr & MENU_SELECT_KEY_DOWN) {
                            MenuDebugCharaChangeSelect++;
                        }

                        if (MenuDebugCharaChangeSelect < 0) {
                            MenuDebugCharaChangeSelect = 3;
                        }

                        if (MenuDebugCharaChangeSelect > 3) {
                            MenuDebugCharaChangeSelect = 0;
                        }

                        if (buttons & MENU_PUSH_BUTTON_DECIDE) {
                            MenuUserDataManPtr->EnableCharaChangeMask(MenuDebugCharaChangeSelect);
                        }

                        if (buttons & MENU_PUSH_BUTTON_CANCEL) {
                            MenuUserDataManPtr->DisableCharaChangeMask(MenuDebugCharaChangeSelect);
                        }
                    }

                    if (buttons & MENU_PUSH_BUTTON_TRIANGLE) {
                        MenuUserDataManPtr->JoinPartyMember(USER_CHARA_MAX);
                        MenuUserDataManPtr->JoinPartyMember(USER_CHARA_MONICA);
                        MenuUserDataManPtr->EnableCharaChange(0);
                        MenuUserDataManPtr->EnableCharaChange(1);
                        MenuUserDataManPtr->EnableCharaChange(2);
                        MenuUserDataManPtr->EnableCharaChange(3);
                        MenuUserDataManPtr->EnableCharaChangeMask(0);
                        MenuUserDataManPtr->EnableCharaChangeMask(1);
                        MenuUserDataManPtr->EnableCharaChangeMask(2);
                        MenuUserDataManPtr->EnableCharaChangeMask(3);
                    }
                } else {
                    if (keys & MENU_SELECT_KEY_UP) {
                        menu_debug_npcselect--;
                    }

                    if (keys & MENU_SELECT_KEY_DOWN) {
                        menu_debug_npcselect++;
                    }

                    if (menu_debug_npcselect < 1) {
                        menu_debug_npcselect = 1;
                    }

                    if (menu_debug_npcselect >= 0x1B) {
                        menu_debug_npcselect = 0x1A;
                    }

                    if (keys & MENU_SELECT_KEY_RIGHT) {
                        menu_debug_npc_decide++;
                    }

                    if (keys & MENU_SELECT_KEY_LEFT) {
                        menu_debug_npc_decide--;
                    }

                    if (menu_debug_npc_decide < 0) {
                        menu_debug_npc_decide = 0;
                    }

                    if (menu_debug_npc_decide > 1) {
                        menu_debug_npc_decide = 1;
                    }

                    if (buttons & MENU_PUSH_BUTTON_DECIDE || buttons & MENU_PUSH_BUTTON_CANCEL) {
                        int npc = menu_debug_npcselect;

                        if (GetUserDataMan()->GetPartyCharaStatus(npc) == 0) {
                            GetUserDataMan()->JoinPartyChara(npc, 0x80, 1);
                        }

                        if (menu_debug_npc_decide == 0) {
                            GetUserDataMan()->SetPartyCharaStatus(npc, 1);
                        }

                        if (menu_debug_npc_decide == 1) {
                            GetUserDataMan()->SetPartyCharaStatus(npc, 2);
                        }

                        if (menu_debug_npc_decide == 2) {
                            GetUserDataMan()->SetPartyCharaStatus(npc, 4);
                        }
                    }
                }

                return 0;
            }

            switch (step) {
                case 0: {
                    int last_select = select;
                    int dir = -1;

                    if (keys & MENU_SELECT_KEY_UP) {
                        dir = 0;
                    }

                    if (keys & MENU_SELECT_KEY_UP && keys & MENU_SELECT_KEY_RIGHT) {
                        dir = 1;
                    }

                    if (keys & MENU_SELECT_KEY_RIGHT) {
                        dir = 2;
                    }

                    if (keys & MENU_SELECT_KEY_DOWN && keys & MENU_SELECT_KEY_RIGHT) {
                        dir = 3;
                    }

                    if (keys & MENU_SELECT_KEY_DOWN) {
                        dir = 4;
                    }

                    if (keys & MENU_SELECT_KEY_DOWN && keys & MENU_SELECT_KEY_LEFT) {
                        dir = 5;
                    }

                    if (keys & MENU_SELECT_KEY_LEFT) {
                        dir = 6;
                    }

                    if (keys & MENU_SELECT_KEY_UP && keys & MENU_SELECT_KEY_LEFT) {
                        dir = 7;
                    }

                    int next = -1;

                    if (dir >= 0) {
                        next = nextIDtbl[select * 8 + dir];
                    }

                    if (next >= 0) {
                        select = next;
                    }

                    if (last_select != select) {
                        MenuSePlay(SYSTEM_SE_CURSOR);

                        if (select == 4) {
                            MenuDCMsg[0]->SetBuff(mes_data);
                        }

                        if (last_select == 4) {
                            MenuDCMsg[0]->SetBuff(sys_mes);
                        }
                    }

                    switch (buttons) {
                        case MENU_PUSH_BUTTON_DECIDE:
                            switch (select) {
                                case 4:
                                    action = 5;

                                    if (MenuCommonInfo->open_type != MENU_OPEN_CHARA_CHANGE_DUNGEON && 0 < npc_no) {
                                        action = 0x22;
                                    }

                                    break;
                                case USER_CHARA_MONSTER:
                                    action = 0x32;
                                    break;
                                default:
                                    action = 0x46;
                                    break;
                            }

                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            action = 0x28;

                            if (MenuCommonInfo->open_type == MENU_OPEN_CHARA_CHANGE_DUNGEON) {
                                action = 5;

                                if (MenuUserDataManPtr->GetHp(MenuUserDataManPtr->active_chr_no) < 1.0f) {
                                    action = 5;
                                } else {
                                    mode = MENU_ASK_MODE_CLOSE;
                                    FadeOutMenu(40, 0.0f);
                                }
                            }

                            break;
                    }

                    break;
                }
                case 1: {
                    int last = 1;

                    if (npc_no == 0x1A) {
                        last = 0;
                    }

                    int cursor = npc_mes->AddMsgCursor2(0, last, 1);

                    switch (buttons) {
                        case MENU_PUSH_BUTTON_DECIDE:
                            if (cursor == 0) {
                                action = 0x1E;
                            }

                            if (cursor == 1) {
                                step = 2;
                                ExeScript("NPC_\x8A\x4F\x82\xB7\x81\x48");
                                char *names[1] = {GetNPCName(npc_no)};
                                cmd_mes->SetMsgItemNo(names, 1);

                                if (party_info->status & 4) {
                                    cmd_mes->MakeMsg(0x1B0);
                                } else {
                                    cmd_mes->MakeMsg(0x1AF);
                                }
                            }

                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            step = 0;
                            ExeScript("NPC_CMDEND");
                            break;
                    }

                    break;
                }
                case 2: {
                    int answer = cmd_mes->YesNoCursor2(0);

                    if (answer == 1) {
                        if (party_info->status & 4) {
                            party_info->status = 4;
                        } else {
                            party_info->status = 2;
                            int map_no = MenuNowMapNo;

                            if (map_no == SearchMapNo("s07") || map_no == SearchMapNo("s38")) {
                                MenuMainScene->SetActive(SCENE_DATA_CHARA, MenuMainScene->SearchCharaID(npc_no));
                            }
                        }

                        npc_no = 0;
                        party_info = NULL;
                        npc_mes_talk = 0;
                        npc_mes_cmd = -1;
                        npc_mes_cancel = -1;
                        ExeScript("NPC\x8A\x4F\x82\xB7");
                        step = 0;
                    }

                    if (answer == 2) {
                        step = 1;
                        ExeScript("NPC_\x8A\x4F\x82\xB7\x81\x48"
                                  "END");
                    }

                    break;
                }
            }

            break;
    }

    int active_chara = key_func->GetActiveCharaNo();

    switch (action) {
        case 5:
            MenuSePlay(SYSTEM_SE_CANCEL);
            break;
        case 0x22:
            if (party_info->status & 4) {
                ExeScript("NPC_CMD2");
            } else {
                ExeScript("NPC_CMD");
            }

            if (npc_no == 0x1A) {
                MenuDCMsg[5]->MakeMsg(0x1B3);
            }

            MenuSePlay(SYSTEM_SE_WINDOW);
            step = 1;
            npc_mes->point_x = 20;
            npc_mes->point_y = 200;
            break;
        case 0x1E:
            if (mode == MENU_ASK_MODE_OPEN) {
                break;
            }

            if (0 < npc_no) {
                if (npc_chara == NULL) {
                    LoadBGNPCModel(1);
                } else {
                    npc_chara->Show(1, 1);
                }

                MenuSePlay(2);
                key_arg_no = 3;
                star_stop_wait = 20;
                step = 0;
                ExeScript("NPCSETBUF");

                if (cancelled != 1) {
                    ExeScript("GOTONPCVIEW");
                    npc_chara_form->counter = 0;
                }

                title_mes->MakeMsg(0x1E);
                title_mes->StepMsg();
                int answers[2] = {npc_mes_cmd, npc_mes_cancel};
                answer_mes->fuchi = 5;
                answer_mes->SetMsgItemNo(answers, 2);
                answer_mes->MakeMsg(0xB);
                answer_mes->StepMsg();
                cmd_mes->MakeMsg(0x1F);
                cmd_mes->SetMsgItemNo(npc_cmd_mes, CHR_CNG_NPC_COMMAND_NUM);
                cmd_mes->font_h = 0x1C;
                cmd_mes->SetMsgCursor(-1);

                if (npc_data->ability_num > 0) {
                    cmd_mes->SetMsgCursor(0);

                    if (0 <= SelectedCmdNo) {
                        cmd_mes->SetMsgCursor(SelectedCmdNo);
                    }
                }

                star_fade_out = 0;

                if (key_func->open_type == MENU_OPEN_CHARA_CHANGE) {
                    cmd_mes->SetMsgCursor(-1);
                } else {
                    star_fade_out = 1;
                }

                MenuItemBrdCalcManner = 1;
                item_brd_select = 0;
                item_brd_pos = 0;
                MenuItemBrdSetInfo(item_brd_select, item_brd_pos, GetNowBagMax(0) / 6, 5);
            } else {
                MenuSePlay(SYSTEM_SE_CANCEL);
            }

            break;
        case 0x46: {
            COMMON_GAGE *robo_hp = &MenuUserParam.robo->hp;

            if (active_chara == select) {
                MenuSePlay(SYSTEM_SE_CANCEL);

                if (select == USER_CHARA_ROBO && robo_hp->now < 1.0f) {
                    open_wait = 1;
                    ExeScript("Change_ERR");
                    cmd_mes->MakeMsg(0x1A4);
                }

                break;
            }

            int attr = MenuUserDataManPtr->GetCharaStatusAttirbute(active_chara);

            if (attr & CHARA_STATUS_UNK_8 || attr & CHARA_STATUS_UNK_20) {
                open_wait = 1;
                ExeScript("Change_ERR");
                cmd_mes->MakeMsg(select + 0x1A5);
                break;
            }

            party_member = MenuUserDataManPtr->GetNowPartyMember();
            enable_change = MenuUserDataManPtr->GetEnableCharaChangeFlag();
            int bit = 1 << select;

            if (!(party_member & bit)) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                break;
            }

            if (!(enable_change & bit) && select != USER_CHARA_MONSTER) {
                mode = 0xD;
                open_wait = 1;
                ExeScript("Change_ERR");
                cmd_mes->MakeMsg(select + 0x1A5);
                break;
            }

            if (key_func->open_type == MENU_OPEN_MAIN_TOWN && select == USER_CHARA_ROBO) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                break;
            }

            if (select == USER_CHARA_ROBO && robo_hp->now < 1.0f) {
                open_wait = 1;
                ExeScript("Change_ERR");
                cmd_mes->MakeMsg(0x1A4);
                break;
            }

            if (select == USER_CHARA_MAX || select == USER_CHARA_MONICA) {
                if (gauge[select]->now <= 0.0f) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    break;
                }

                attr = MenuUserDataManPtr->GetCharaStatusAttirbute(select);

                if (attr & CHARA_STATUS_UNK_8 || attr & CHARA_STATUS_UNK_20) {
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    break;
                }
            }

            if (select == USER_CHARA_MONSTER && gauge[USER_CHARA_MONICA]->now <= 0.0f) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                break;
            }

            if (select == USER_CHARA_ROBO && gauge[USER_CHARA_MAX]->now <= 0.0f) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                break;
            }

            key_arg_no = 1;
            ExeScript("\x83\x4C\x83\x83\x83\x89\x83\x60\x83\x46\x83\x93\x83\x57\x8A\x6D\x94\x46");
            cmd_mes->MakeMsg(msgtbl1[select]);
            npc_chara = NULL;

            for (int i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
                InitMenuBGReadInfo2(MenuCharaBuild2[i]);
            }

            change_chara = select;
            MENU_LOAD_INFO *load_info = &MenuLoadInfo;
            load_info->chara_no = select;
            load_info->mode = 2;
            load_info->request_phase = -1;
            load_info->load_phase = 0;
            load_info->update_scene = 1;
            ReEquipFishingGameWeapon();
            MenuCharaLoadStack.stack_used = 0;
            MenuCharaLoadStack.lock = 0;
            MenuCharaLoadStack.Align64();
            SetMenuLoadItemNo(change_chara);

            switch (change_chara) {
                case USER_CHARA_MAX:
                case USER_CHARA_MONICA:
                    load_info->load_all = 1;
                    load_info->request_phase = -1;
                    MenuItemCharaDataLoad(&MenuCharaLoadStack, change_chara, MenuCharaBuild2, 1);
                    break;
                case USER_CHARA_ROBO:
                    load_info->load_all = 1;
                    MenuCharaLoadStack.Alloc(blocks_for(MenuItemRoboDataLoad(&MenuCharaLoadStack, MenuCharaBuild2, 1)));
                    break;
            }

            change_phase = CHR_CNG_PHASE_LOAD;
            change_ready = 0;
            break;
        }
        case 0x50:
            key_arg_no = 0;
            change_phase = CHR_CNG_PHASE_NONE;
            ExeScript("CHANGE_CANCEL");
            break;
        case 0x14: {
            change_ready = 1;
            ExeScript("CHNG_BEGIN");
            MenuArg.end_code = 1;
            MenuArg.result[0] = select;
            int last_chara = GetUserDataMan()->active_chr_no;
            GetUserDataMan()->SetActiveChrNo(MenuArg.result[0]);

            if (key_func->open_type == MENU_OPEN_MAIN_TOWN) {
                GetCharaMemAllocPtr(MenuArg.chara_stack, MorattaStack, change_chara, 1);
            } else {
                if (last_chara == USER_CHARA_MONSTER) {
                    DeleteMonsterEffect();
                }

                GetCharaMemAllocPtr(MenuArg.chara_stack, MorattaStack, change_chara, 0);
            }

            last_select = select;
            MenuSePlay(se_sndtbl[select]);

            if (MenuLoadInfo.alternate_model == 1) {
                EditCharaPrepare();
            }

            if (GetMenuLoopType() == MENU_LOOP_DUNGEON && FxScriptMan != NULL) {
                CActionChara *player = (CActionChara *) MenuMainScene->GetCharacter(0);

                if (player->effect_man != NULL && player->throw_effect >= 0) {
                    for (int i = 0; i < 120; i++) {
                        player->effect_man->PauseFromLevel(3, 3);
                        player->effect_man->PauseFromLevel(1, 3);
                        player->effect_man->Step();
                        player->effect_man->PauseFromLevel(3, 0);
                        player->effect_man->PauseFromLevel(1, 0);
                    }
                }
            }

            break;
        }
        case 0x28: {
            mode = MENU_ASK_MODE_CLOSE;
            ReturnMenuIntern(0);
            ExeScript("PREEND");
            MenuMainFrameModeSet(5, 0);
            CMenuPosDataForm *main_form = MenuFormMI2;

            if (main_form != NULL) {
                main_form->rate_x = 4.0f;
                main_form->rate_y = 9.0f;
            }

            break;
        }
        case 0x32:
            if (!GetMenuMainFrameEndFlag()) {
                break;
            }

            if (!IsCheckParty(USER_CHARA_MONSTER)) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                break;
            }

            enable_change = MenuUserDataManPtr->GetEnableCharaChangeFlag();
            sub_menu = CHR_CNG_SUB_MENU_NONE;
            sub_menu_next = CHR_CNG_SUB_MENU_MONSTER_BOX;
            FadeOutMenu(40, 0.0f);
            MenuSePlay(SYSTEM_SE_DECIDE);
            break;
        case 0x3C:
            MenuSePlay(2);
            ExeScript("RETURN_CHANGESELECT");

            if (npc_chara != NULL) {
                npc_chara->Show(0, 1);
            }

            key_func->MenuPosPlay();
            key_arg_no = 0;
            star_fade_out = 0;
            star_stop_wait = 20;
            step = 0;
            break;
        case 100:
            if (npc_data == NULL || party_info == NULL) {
                MenuSePlay(SYSTEM_SE_CANCEL);
                break;
            }

            got_item = 0;
            ExeScript("NPCCMD_PRE");

            if (!MenuUserDataManPtr->UseNpcAbility(npc_no, SelectedCmdNo, 0)) {
                step = 1;
                ExeScript("POINT\x95\x73\x91\xAB");
                npc_mes->MakeMsg(GetPartyCharaMessage(npc_no, 8, 0) + SelectedCmdNo);
                npc_mes->StepMsg();
                AdjustNPCTalk(npc_mes, npc_chara);
                break;
            }

            if (GetMenuLoopType() == MENU_LOOP_TOWN) {
                int dungeon_only = 0;

                switch (npc_no) {
                    case 5:
                    case 6:
                    case 0x12:
                    case 0x13:
                    case 0x15:
                    case 0x16:
                    case 0x17:
                        dungeon_only = 1;
                        break;
                }

                if (dungeon_only) {
                    npc_mes->MakeMsg(GetPartyCharaMessage(npc_no, 8, 0) + SelectedCmdNo);
                    npc_mes->StepMsg();
                    AdjustNPCTalk(npc_mes, npc_chara);
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    step = 2;
                    break;
                }
            }

            {
                npc_mes->MakeMsg(GetPartyCharaMessage(npc_no, 6, 0) + SelectedCmdNo);
                npc_mes->StepMsg();
                int widest;

                if (npc_mes->page_num <= 0) {
                    widest = 0;
                } else {
                    int i;
                    int max_chars = 0;

                    for (i = 0; i < npc_mes->page_num; i++) {
                        if (max_chars < npc_mes->page_chars[i]) {
                            max_chars = npc_mes->page_chars[i];
                        }
                    }

                    widest = max_chars;
                }

                npc_mes->SetMsgCursor(widest - 1);
                npc_mes->draw_speed = 0.0f;
                AdjustNPCTalk(npc_mes, npc_chara);
                MenuSePlay(SYSTEM_SE_CURSOR);
                step = 10;
            }
            break;
        case 0x5A: {
            MenuMesForm[6]->draw_flag = 0;
            npc_mes->push_button = 0;
            npc_mes->SetMsgCursor(-1);
            int sound_mode = 0;

            if (party_info->point - npc_data->ability_cost[SelectedCmdNo] < 0) {
                step = 1;
                ExeScript("POINT\x95\x73\x91\xAB");
                npc_mes->MakeMsg(GetPartyCharaMessage(npc_no, 8, 0) + SelectedCmdNo);
                break;
            }

            int se = 5;
            int used = 0;
            int in_dungeon = 0;

            if (GetMenuLoopType() == MENU_LOOP_DUNGEON) {
                in_dungeon = 1;
            }

            int              boss_floor = 0;
            DNG_BATTLE_AREA *area = &MenuMainScene->battle_area;

            if (area != NULL && area->floor_status & DNG_FLOOR_DISABLE_ITEMS) {
                boss_floor = 1;
            }

            int bit_ctrl = GetSaveData()->GetBitCtrl();
            int max_bad = CheckBadStatus(MenuUserDataManPtr->GetCharaStatusAttirbute(USER_CHARA_MAX));
            int monica_bad = CheckBadStatus(MenuUserDataManPtr->GetCharaStatusAttirbute(USER_CHARA_MONICA));
            int max_hurt = 0;

            if (MenuUserDataManPtr->chara_data[USER_CHARA_MAX].hp.GetRate() < 1.0f) {
                max_hurt = 1;
            }

            int monica_hurt = 0;

            if (MenuUserDataManPtr->party_member & (1 << USER_CHARA_MONICA) && MenuUserDataManPtr->chara_data[USER_CHARA_MONICA].hp.GetRate() < 1.0f) {
                monica_hurt = 1;
            }

            step = 2;
            int volume[8] = {0};
            int message = GetPartyCharaMessage(npc_no, 7, 0) + SelectedCmdNo;

            switch (npc_no) {
                case 1:
                    if (SelectedCmdNo == 2) {
                        if (1.0f <= MenuUserDataManPtr->robo_data.AddPoint(0.0f)) {
                            used = 0;
                            message = GetPartyCharaMessage(1, 8, 0);
                        } else {
                            MenuUserDataManPtr->robo_data.AddPoint(999.0f);
                            se = 10;
                            UpdataLife();
                            used = 1;
                        }
                    } else {
                        int pos[2];
                        item->Repair(999);
                        se = 10;
                        MenuPosData->GetPosMenuItemBrdKoma(pos, item_brd_select, 0);
                        MenuRepairMan->Generate(pos[0], pos[1]);
                        UpdataLife();
                        used = 1;
                        step = 20;
                        message = 0;
                    }

                    break;
                case 0x16:
                    used = 0;

                    if (in_dungeon && ActiveMonster != NULL) {
                        ActiveMonster->SetNearAreaPiyori(350.0f);
                        se = 10;
                        used = 1;
                    } else {
                        message = GetPartyCharaMessage(0x16, 8, 0);
                    }

                    break;
                case 5:
                    used = 0;

                    if (in_dungeon) {
                        used = 1;
                        area = &MenuMainScene->battle_area;

                        if (bit_ctrl & 1) {
                            used = 0;
                        }

                        if (area->boss_map && area->battle_clear) {
                            used = 0;
                        }
                    }

                    if (used) {
                        close_on_end = 1;
                    } else {
                        message = GetPartyCharaMessage(5, 8, 0);
                    }

                    break;
                case 6:
                    if (in_dungeon && !boss_floor && (max_bad || monica_bad)) {
                        used = 1;
                        se = 0x56;
                        sound_mode = 1;
                        MenuUserDataManPtr->SetCharaStatusAttirbute(USER_CHARA_MAX, CHARA_STATUS_ALL & ~CHARA_STATUS_POWER, 1);
                        MenuUserDataManPtr->SetCharaStatusAttirbute(USER_CHARA_MONICA, CHARA_STATUS_ALL & ~CHARA_STATUS_POWER, 1);
                    }

                    if (!used) {
                        message = GetPartyCharaMessage(6, 8, 0);
                    }

                    break;
                case 0x17:
                    if (in_dungeon && !boss_floor && (max_bad || monica_bad || max_hurt || monica_hurt)) {
                        used = 1;
                        se = 10;
                        MenuUserDataManPtr->AddHp(USER_CHARA_MAX, 999);
                        MenuUserDataManPtr->AddHp(USER_CHARA_MONICA, 999);
                        MenuUserDataManPtr->SetCharaStatusAttirbute(USER_CHARA_MAX, CHARA_STATUS_ALL & ~CHARA_STATUS_POWER, 1);
                        MenuUserDataManPtr->SetCharaStatusAttirbute(USER_CHARA_MONICA, CHARA_STATUS_ALL & ~CHARA_STATUS_POWER, 1);
                        UpdataLife();
                    }

                    if (!used) {
                        message = GetPartyCharaMessage(0x17, 8, 0);
                    }

                    break;
                case 0x12:
                    if (in_dungeon && !boss_floor) {
                        used = 0;

                        if (MenuUserDataManPtr->GetHp(0) < 1.0f) {
                            MenuUserDataManPtr->chara_data[(int) USER_CHARA_MAX].hp.SetFillRate(1.0f);
                            used = 1;
                        }

                        if (MenuUserDataManPtr->GetHp(1) < 1.0f) {
                            MenuUserDataManPtr->chara_data[(int) USER_CHARA_MONICA].hp.SetFillRate(1.0f);
                            used = 1;
                        }
                    }

                    if (used) {
                        sound_mode = 1;
                        se = 0x56;
                        UpdataLife();
                    } else {
                        message = GetPartyCharaMessage(0x12, 8, 0);
                    }

                    break;
                case 0x15:
                    if (in_dungeon) {
                        used = 0;

                        for (int chara = 0; chara < 2; chara++) {
                            if (MenuUserDataManPtr->GetNowPartyMember() & (1 << chara) &&
                                1.0f <= MenuUserDataManPtr->GetHp(chara)) {
                                MenuUserDataManPtr->SetCharaStatusAttirbuteVol(chara, CHARA_STATUS_POWER, 750);
                                used = 1;
                            }
                        }
                    }

                    if (used) {
                        sound_mode = 1;
                        se = 0x56;
                    } else {
                        message = GetPartyCharaMessage(0x15, 8, 0);
                    }

                    break;
                case 7:
                case 0xC:
                case 0xD:
                case 0x14:
                case 0x19: {
                    /**
                     *
                     * Capacity of the aquarium-food list supplied by a townsperson.
                     *
                     */
                    enum {
                        NPC_GIFT_FOOD_CAPACITY = 32
                    };

                    int esa[NPC_GIFT_FOOD_CAPACITY];
                    gift_item = -1;
                    gift_num = 1;

                    if (npc_no == 7) {
                        gift_item = 0x10E;
                    }

                    if (npc_no == 0xC) {
                        gift_item = 0x10C;
                    }

                    if (npc_no == 0xD) {
                        gift_item = 0x186;
                        gift_num = 3;
                    }

                    if (npc_no == 0x14) {
                        int count = GetUseableEsaNo(esa);

                        if (count > 0) {
                            gift_item = esa[GetRandI(count)];

                            if (gift_item == 0x168) {
                                gift_item = 0x138;
                            }
                        } else {
                            gift_item = 0x138;
                        }

                        gift_num = 3;
                    }

                    if (npc_no == 0x19) {
                        gift_item = 0x10D;
                        gift_num = 1;
                    }

                    gift_num = CheckGetItemLimmitOver(gift_item, gift_num);
                    npc_mes->SetMsgVolumeNoOne(volume[0]);

                    if (gift_num == 0) {
                        message = GetPartyCharaMessage(npc_no, 0xB, 0);
                    } else {
                        used = 1;
                        got_item = 1;
                        se = 0x12;
                        MenuUserDataManPtr->GetItem(gift_item, gift_num);
                    }

                    break;
                }
            }

            if (used) {
                MenuUserDataManPtr->UseNpcAbility(npc_no, SelectedCmdNo, 1);
            }

            npc_mes->MakeMsg(message);
            npc_mes->StepMsg();
            AdjustNPCTalk(npc_mes, npc_chara);

            if (sound_mode == 0) {
                MenuSePlay(se);
            }

            if (sound_mode == 1) {
                sndSePlay(MenuMainScene->se_battle_id, se, 0);
            }

            break;
        }
        case 0xC8:
        case 0xC9:
        case 0xCA:
            MenuMesForm[6]->draw_flag = 0;
            MenuMesForm[5]->draw_flag = 0;

            if (npc_no == 1) {
                step = 20;
                MenuCommonInfo->SetWakuType(0);
                ExeScript("\x83\x58\x83\x5E\x81\x5B\x83\x75\x83\x8B\x8F\x43\x97\x9D");
                repair_mes->abs_win.width = 0xDC;
                repair_mes->abs_win.height = 0x4E;
                repair_mes->value_sign = 0;
                repair_mes->value_zero = 1;
                repair_mes->push_button = 0;
                repair_mes->ClsMes::mes_no = -1;
                repair_mes->MakeMsg(0x1C3);
                item_brd_select = 0;
                item_brd_pos = 0;
                MenuItemBrdCalcManner = 0;

                if (SelectedCmdNo == 0) {
                    SetModeMenuDrawItemBoard(1);
                }

                if (SelectedCmdNo == 1) {
                    SetModeMenuDrawItemBoard(2);
                }

                if (SelectedCmdNo == 2) {
                    SetModeMenuDrawItemBoard(3);
                }
            }

            break;
    }

    return 0;
}

void CMenuChrCngMenu::CalcTex() {
    char                name[0x20];
    int                 item_pos[10][2];
    int                 pos[2];
    int                 frame_pos[2];
    MENUFORMPARTS_TYPE *icon;
    MENUFORMPARTS_TYPE *shadow;
    int                 i;

    if (form == NULL) {
        return;
    }

    float *frame_top = GetMenuMainFrameLeftTopPos(0);
    int    x = (int) (frame_top[0] - 512.0f);
    int    y = (int) frame_top[1];

    if (GetMenuMainFrameEndFlag() == 0) {
        SetFormPoint(form, x, y);
    } else {
        form->x = x;
    }

    int icon_num = 4;

    if (0 <= face_chara) {
        icon_num = 5;
    }

    for (i = 0; i < icon_num; i++) {
        sprintf(name, "fc%dname", i);
        icon = form->GetPartInfo(name);
        strcat(name, "sh");
        shadow = form->GetPartInfo(name);
        shadow->draw_flag = 0;

        if ((party_member & (1 << i)) || (i == 4 && 0 < npc_no)) {
            icon->x = chara_pos[i]->value[0];
            icon->y = chara_pos[i]->value[1];

            if (i == select) {
                icon->y += 8.0f * sinf(cursor_wave);
                shadow->x = 3.0f + icon->x;
                shadow->y = 3.0f + icon->y;
                shadow->draw_flag = 1;
            }

            icon->draw_flag = 1;

            if (form->y + shadow->y <= 10.0f) {
                icon->draw_flag = 0;
                shadow->draw_flag = 0;
            }
        } else {
            icon->draw_flag = 0;
        }
    }

    cursor_wave += 0.0581776425f;

    if (!(cursor_wave < 3.1415927f)) {
        cursor_wave -= 6.2831855f;
    }

    sprintf(name, "fc%d", last_select);
    MENUFORMPARTS_TYPE *ring = form->GetPartInfo(name);

    if (ring != NULL && (star_spawn != 0 || star_fade == 0 || mode == 2)) {
        star_x = form->x + ring->x;
        star_y = form->y + ring->y;

        if (star_fade == 0) {
            star_size = ring->w;
        }
    }

    if (star_fade == 0) {
        CalcMenuAdd(&star_alpha, 14.0f, 128.0f);
    } else if (star_fade == 1) {
        star_angle += 0.06829549f;

        if (CalcMenuAdd(&star_alpha, -14.0f, 0.0f)) {
            star_fade = 0;
        }
    }

    if (star_fade_out == 1) {
        CalcMenuAdd(&star_alpha, -28.0f, 0.0f);
    }

    star_wave += 0.07853982f;

    if (!(star_wave < 6.2831855f)) {
        star_wave -= 6.2831855f;
    }

    star_pulse += 0.02617994f;

    if (!(star_pulse < 6.2831855f)) {
        star_pulse -= 6.2831855f;
    }

    star_angle += 0.06283186f;

    if (!(star_angle < 3.1415927f)) {
        star_angle -= 6.2831855f;
    }

    if (mode == 2) {
        star_fade = 1;
    }

    float center = 0.5f * star_size - 2.0f;
    float radius = 0.5625f * star_size;
    float angle = star_angle - 0.06981317f;

    for (int half = 0; half < 2; half++) {
        int spawn = 2;

        for (i = 0; i < CHR_CNG_STAR_NUM / 2; i++) {
            CHR_CNG_STAR *star = &this->star[i];

            if (0.0f < star->alpha) {
                star->alpha -= 1.7f;
                star->life -= 1.0f;
            } else if ((0 < spawn && mode != 2) || star_spawn != 0) {
                star->life = 30.0f + GetRandF(8.0f);
                float spread = radius * (0.95f + 0.1f * sinf(GetRandF(6.2831855f)));
                star->x = center + spread * cosf(angle);
                star->y = center + spread * sinf(angle);
                star->alpha = star_alpha * (1.05f + 0.2f * cosf(GetRandF(3.1415927f)));
                spawn--;
            }

            if (mode == 2 || star_stop_wait > 0) {
                star->alpha -= 14.0f;
            }
        }

        angle += 3.1415927f;
    }

    if (star_stop_wait > 0) {
        star_stop_wait--;
    }

    if (npc_mes_form != NULL && 0 < npc_no) {
        form->GetPutPosXY("polywin", pos[0], pos[1]);
        SetFormPoint(npc_mes_form, pos[0], pos[1]);
        SetFormPoint(npc_sub_form, pos[0], pos[1]);
        SetFormPoint(npc_sub_form2, pos[0], pos[1]);
        form->GetPutPosXY("stpt", item_pos[0][0], item_pos[0][1]);
        form->GetPutPosXY("dousuru", item_pos[1][0], item_pos[1][1]);
        MenuDCMsg[2]->SetMsgItemPos(item_pos[0], 2);

        for (i = 0; i < 4; i++) {
            if (cmd_part[i] != NULL) {
                item_pos[i][0] = (int) (form->x + cmd_part[i]->x);
                item_pos[i][1] = (int) (form->y + cmd_part[i]->y);
            }
        }

        if (key_arg_no != 0 || step != 2) {
            SetFormPoint(MenuMesForm[4], item_pos[0][0], item_pos[0][1]);
        }

        SetMessagePositionNPCForm(npc_mes_form, MenuDCMsg[3]);

        if (party_info != NULL && npc_data != NULL) {
            form->SetNumber("sp_n", party_info->point);
            form->SetNumber("sp_m", npc_data->max_npc_point);

            if (point_gauge_part != NULL) {
                float rate = 0.0f;

                if (npc_data->max_npc_point != 0) {
                    rate = (float) party_info->point / (float) npc_data->max_npc_point;
                }

                if (rate <= 0.0f) {
                    rate = 0.0f;
                }

                point_gauge_part->w = 112.0f * rate;
            }
        }
    }

    Func_MenuItemBrdPosStep(item_brd_pos);

    if (MenuFormMI2 != NULL) {
        form->GetPutPosXY("mi2", frame_pos[0], frame_pos[1]);

        if (abs((int) ((float) frame_pos[0] - MenuFormMI2->x)) < 8) {
            item_brd_arrived = 1;
        }

        if ((item_brd_arrived && mode != 2) || key_arg_no == 2 || MenuCommonInfo->open_type == (int) MENU_OPEN_CHARA_CHANGE_DUNGEON) {
            MenuFormMI2->draw_flag = 1;
            CMenuPosDataForm *item_board = MenuFormMI2;
            item_board->x = frame_pos[0];
            item_board->y = frame_pos[1];
        }
    }
}

int CMenuChrCngMenu::CheckChrChange() {
    int           result = 0;
    int           read_busy = ReadBGSync();
    mgCMemory    *stack = &MenuCharaLoadStack;
    CActionChara *chara;

    switch (change_phase) {
        case CHR_CNG_PHASE_NONE:
            break;
        case CHR_CNG_PHASE_LOAD:
            if (change_ready != 0 && read_busy == 0) {
                switch (change_chara) {
                    case 0:
                    case 1:
                        MenuItemCharaDataLoadEndCheck(MenuCharaBuild2, stack, MenuActionChara,
                                                      change_chara, -1, MenuArg.chara_tex_block);
                        break;
                    case 2:
                        break;
                }

                MenuCharaSoundLoad(stack, change_chara, 1);
                change_phase = (int) CHR_CNG_PHASE_ENTER;
            }

            break;
        case CHR_CNG_PHASE_ENTER:
            if (change_ready != 0 && read_busy == 0) {
                switch (change_chara) {
                    case 0:
                    case 1:
                        MenuItemCharaDataLoadEndCheck(MenuCharaBuild2, stack, MenuActionChara,
                                                      change_chara, -1, MenuArg.chara_tex_block);
                        break;
                    case 2:
                        MenuItemRoboDataLoadEndCheck(MenuCharaBuild2, stack, MenuActionChara, -1,
                                                     MenuArg.chara_tex_block);
                        break;
                }

                chara = (CActionChara *) MenuMainScene->GetCharacter(0);

                if (GetMenuLoopType() == (int) MENU_LOOP_DUNGEON) {
                    chara->effect_man = FxScriptMan;
                }

                if (chara != NULL && MenuLoadInfo.alternate_model == 0) {
                    chara->InitScript();
                }

                MenuCharaSoundEnter(MenuMainScene, chara, 1);
                CopyActiveItemAndWeapon(change_chara, -1);
                result = 2;
                change_phase += 1;
            }

            break;
        case CHR_CNG_PHASE_DONE:
            result = 2;
            break;
    }

    return result;
}

int CMenuChrCngMenu::MenuLocalLoop() {
    /**
     *
     * Cursor reversal flag for each party menu selection.
     *
     */
    static u8 cursor_revtbl[USER_CHARA_NUM + 1] = {1, 0, 0, 0, 0};

    char           name[0x20];
    int            cursor[2];
    int            result;
    int            icon_mode;
    int            fade_done;
    int            frame_end;
    int            message_id;
    int            item_no;
    CGameDataUsed *item;
    CDC2Mes       *mes;
    int            name_x;
    int            name_y;
    int            width;

    KeyChangeMain();
    int step[2] = {0, 0};

    if (npc_no == 1 && this->step == 0x14) {
        (MenuPosData)->GetPosMenuItemOnItemBrd(cursor, item_brd_select, 1);
        cursor[0] -= 8;
        cursor[1] -= 10;
        step[0] = -0x2E;
        step[1] = 0x12;
    } else {
        sprintf(name, "cur%d", select);
        form->GetPutPosXY(name, cursor[0], cursor[1]);
        MenuCursorReverseFlag = cursor_revtbl[select];
    }

    MenuCommonInfo->MenuPosStep(cursor, step);

    if (set_cursor != 0) {
        MenuCommonInfo->MenuSetPos(cursor[0], cursor[1]);
        set_cursor = 0;
    }

    icon_mode = 2;
    int *mode_id = GetCommonMenuModeID();

    if (mode == 2) {
        icon_mode = 0;
    }

    (MenuPosData)->StepMainMenuIconMove(mode_id, 4, icon_mode);
    fade_done = 1;

    if (MenuCommonInfo->open_type == (int) MENU_OPEN_CHARA_CHANGE || close_on_end == 1 || MenuCommonInfo->open_type == (int) MENU_OPEN_CHARA_CHANGE_DUNGEON) {
        fade_done = FadeCheckMenu();
    }

    frame_end = GetMenuMainFrameEndFlag();
    result = CheckChrChange();

    switch (mode) {
        case 1:
            EnterNPCFaceData();

            if (fade_done != 0 && face_state != 0 && ReadBGSync() == 0) {
                short key_mode = MenuCommonInfo->open_type;

                if ((key_mode != 4 && frame_end != 0) || key_mode == 4) {
                    mode = 0;
                    star_fade = 0;
                    star_spawn = 1;
                    open_wait = 0;
                    set_cursor = 1;
                    ExeScript("INI0");
                    key_mode = MenuCommonInfo->open_type;

                    if (key_mode == 4) {
                        ExeScript("INIT1");
                    } else if (key_mode == 0xE) {
                        ExeScript("INIT2");
                    }

                    LoadBGNPCModel(1);
                }
            }

            break;
        case 2:
            if (fade_done != 0 && frame_end != 0) {
                DeleteTexBlock();
                (&MenuCommonInfo->cursor)[0] = 1;
                MenuCursorReverseFlag = 0;
                ExeScript("\x8F\x49\x97\xB9\x8F\x88\x97\x9D");
                result = 1;

                if (close_on_end != 0) {
                    result = 2;
                }
            }

            break;
        default:
            if (MenuCommonInfo->open_type == (int) MENU_OPEN_CHARA_CHANGE && MenuGetPartySeFlag == 0 && fade_done != 0) {
                MenuGetPartySeFlag = 1;
                MenuSePlay(0x11);
            }

            CheckBGNPCModel();
            break;
    }

    MenuPosData->FormStep();
    CalcTex();
    message_id = select + 0x190;

    if (select == 4) {
        message_id = npc_mes_talk;
    }

    if (select < 4) {
        if (IsCheckParty(select) == 0) {
            message_id = 0x194;
        }

        if (CheckBitFlagMenu(0x36) == 0 && select == 1 && OmakeFlag == 0) {
            message_id = 0x199;
        }
    }

    MenuDCMsg[0]->MakeMsg(message_id);

    if (npc_no == 1) {
        item_no = item_brd_select;

        if (0 <= item_no && item_no < GetNowBagMax(0)) {
            char *item_names[2] = {" ", ""};
            int   item_volumes[2] = {0, 0};
            item = MenuDrawItemInfo[item_brd_select];
            mes = MenuDCMsg[7];

            if (item != NULL) {
                item_names[0] = item->GetName(0);
                item->GetWHp(item_volumes);
            }

            mes->SetMsgItemNo(item_names, 1);
            mes->SetMsgVolumeNo(item_volumes, 2);
            mes->value_width[0] = 6;
            name_x = fptosi(MenuMesForm[7]->x + (float) (mes->abs_win.width >> 1));
            width = mes->GetStrWidth(0);
            name_x -= width / 2;
            name_y = fptosi(14.0f + MenuMesForm[7]->y);
            mes->line_pos[0][0] = name_x;
            mes->line_pos[0][1] = name_y;
            mes->line_pos_on[0] = 1;
            mes->MakeMsg(0x1C3);
            mes->StepMsg();
        }
    }

    return result;
}

void CMenuChrCngMenu::InitStarInfo() {
    int i;

    star_fade = -1;
    star_spawn = 0;
    star_y = 0.0f;
    star_x = 0.0f;
    unk_260 = 0;
    star_size = 0.0f;
    star_angle = 0.0f;
    star_alpha = 0.0f;

    for (i = 0; i < 256; i++) {
        star[i].alpha = 0.0f;
    }

    star_stop_wait = 0;
    star_fade_out = 0;
    star_pulse = 0.0f;
}

void CMenuChrCngMenu::UpdataLife() {
    /**
     *
     * Current and maximum gauge label part names of the party menu.
     *
     */
    static char *partt[6] = {
        "hp_now0",
        "hp_max0",
        "hp_now1",
        "hp_max1",
        "hp_now2",
        "hp_max2",
    };

    int i;

    i = 0;
    gauge[0] = &MenuUserParam.chara[0]->hp;
    gauge[1] = &MenuUserParam.chara[1]->hp;
    gauge[2] = &MenuUserParam.robo->hp;

    do {
        form->SetNumber(partt[i * 2], GetDispVolumeForFloat(gauge[i]->now));
        form->SetNumber(partt[i * 2 + 1], fptosi(gauge[i]->max));

        if (gauge_part[i] != NULL && gauge[i] != NULL) {
            gauge_part[i]->w = GetDispVolumeForFloat(66.0f * gauge[i]->GetRate());
        }

        i++;
    } while (i < 3);

    if (!(party_member & 1)) {
        ExeScript("YURIS_OFFLIFE");
    }

    if (!(party_member & 2)) {
        ExeScript("MONICA_OFFLIFE");
    }

    if (!(party_member & 4)) {
        ExeScript("ROBO_OFFLIFE");
    }
}

void MenuCharaChangeStarDraw() {
    mgCTextureManager *tex_manager = &mgTexManager;

    if (MenuCharaChangeBase_Tex == NULL) {
        return;
    }

    tex_manager->ReloadTexture(MenuCharaChangeBase_Tex->block, (sceVif1Packet *) NULL);

    CMenuChrCngMenu *menu = ChrChangMenuPt;
    float            angle;
    float            size = menu->star_size;
    float            offset = size / 2.0f - 2.0f;
    float            center[2] = {menu->star_x + offset, menu->star_y + 1.1538461f * offset};
    angle = menu->star_angle;
    mgCDrawPrim *prim = GetMenuPrim();
    int          i;

    // The ring texture is drawn as a square fan rotated by the ring angle.
    mgRect<int> base_rect(0x13F, 0xC0, 0x40, 0x40);
    float       u1 = base_rect.left + base_rect.right;
    float       v1 = base_rect.top + base_rect.bottom;
    float       u0 = base_rect.left;
    float       v0 = base_rect.top;
    float       uv[4][2] = {
        {u0, v0},
        {u1, v0},
        {u1, v1},
        {u0, v1}
    };
    SetSpriteEnv(prim, 4);
    prim->Bilinear(1);
    prim->Begin(MG_PRIM_TRIANGLE_FAN);
    prim->Texture(MenuCharaChangeBase_Tex);
    prim->Color(0x80, 0x80, 0x80, (int) ChrChangMenuPt->star_alpha);

    for (i = 0; i < 4; i++) {
        prim->TextureCrd((int) uv[i][0], (int) uv[i][1]);
        float x = 1.0f + (center[0] + size * cosf(angle));
        prim->Vertex(x, center[1] + 1.1538461f * (size * sinf(angle)), 0.0f);
        angle += 1.5707964f;
    }

    prim->End();

    // Two pairs of circles orbit opposite each other, the outer one of each pair pulsing.
    mgRect<int> waku_rect(0x121, 0xE1, 0x1E, 0x1E);
    float       circle;
    float       alpha;
    float       wave;
    float       pulse_alpha;
    float       y;
    float       x;
    size = 0.546875f * ChrChangMenuPt->star_size;
    wave = ChrChangMenuPt->star_wave;
    angle -= 0.15707964f;
    float pulse = sinf(ChrChangMenuPt->star_pulse);
    pulse_alpha = 0.5f * ChrChangMenuPt->star_alpha * (pulse < 0.0f ? -pulse : pulse);

    for (i = 0; i < 2; i++) {
        alpha = ChrChangMenuPt->star_alpha;
        circle = 60.0f + 3.0f * sinf(wave);
        x = size * cosf(angle);
        y = size * sinf(angle);
        DrawWakuCircle(prim, MenuCharaChangeBase_Tex,
                       mgRect<float>(center[0] + x - 0.5f * circle,
                                     6.0f + (center[1] + 1.1538461f * (y - 0.5f * circle)), circle, circle),
                       waku_rect, wave, size, (int) alpha, 0x80, 0x80, 0x80);
        circle *= 1.4f;
        DrawWakuCircle(prim, MenuCharaChangeBase_Tex,
                       mgRect<float>(center[0] + x - 0.5f * circle,
                                     6.0f + (center[1] + 1.1538461f * (y - 0.5f * circle)), circle, circle),
                       waku_rect, wave, size, (int) pulse_alpha, 0x80, 0x80, 0x80);
        angle += 3.1415927f;
        wave += 3.1415927f;
    }

    if (MenuCharaChangeStar_Tex == NULL) {
        return;
    }

    tex_manager->ReloadTexture(MenuCharaChangeStar_Tex->block, (sceVif1Packet *) NULL);
    mgRect<short> star_rect(0, 0x20, 8, 8);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(MenuCharaChangeStar_Tex);

    for (i = 0; i < CHR_CNG_STAR_NUM; i++) {
        if (0.0f < ChrChangMenuPt->star[i].alpha) {
            float star_x = ChrChangMenuPt->star[i].x + ChrChangMenuPt->star_x;
            float star_y = ChrChangMenuPt->star[i].y + ChrChangMenuPt->star_y;
            prim->Color(0x80, 0x80, 0x80, (int) ChrChangMenuPt->star[i].alpha);
            prim->TextureCrd(star_rect.left, star_rect.top);
            prim->Vertex(star_x, star_y, 0.0f);
            prim->TextureCrd(star_rect.left + star_rect.right, star_rect.top + star_rect.bottom);
            prim->Vertex(star_x + star_rect.right, star_y + star_rect.bottom, 0.0f);
        }
    }

    prim->End();
}

int MenuCharaChangeInit(mgCMemory *stack, int *tex_block, int mode) {
    u_long128       *buffer;
    int              size;
    unsigned int     file_size;
    CMenuChrCngMenu *menu;
    CRepairManager  *repair;
    int              i;
    CCharacter2     *chara;
    short            party_chara;
    static int       tbl[MENU_CHARA_LOAD_MAX] = {1, 1, 1, 1, 1, 1, 1};

    buffer = stack->stack;

    if (mode == 4 || mode == 0xE) {
        file_size = LoadFileMenu("chrchg0.pac", buffer, 1);
        stack->Alloc((file_size & 0xF) ? (file_size >> 4) + 1 : file_size >> 4);
        stack->Align64();
    }

    ChrChangeInitTextureStack.stSetBuffer(buffer, stack->stack_used);
    size = stack->stGetRest();
    MenuChangeMemory.stSetBuffer(stack->stGetTop(), size);
    MenuChangeMemory.Alloc(0x100);

    menu = new (MenuChangeMemory.Alloc(align16_blocks(sizeof(CMenuChrCngMenu)) + 2)) CMenuChrCngMenu;

    ChrChangMenuPt = menu;
    menu->SetTexBlock(tex_block);
    party_chara = MenuUserDataManPtr->active_chr_no;
    ChrChangMenuPt->last_select = party_chara;
    ChrChangMenuPt->select = party_chara;

    repair = new (MenuChangeMemory.Alloc(align16_blocks(sizeof(CRepairManager)) + 2)) CRepairManager;

    MenuRepairMan = repair;
    repair->Initialize();

    if (mode == 4) {
        ChrChangMenuPt->key_arg_no = 2;
        ChrChangMenuPt->last_select = 4;
        ChrChangMenuPt->select = 4;
    }

    for (i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
        chara = MenuMainScene->GetCharacter(i);
        MenuActionChara[i] = static_cast<CActionChara *>(chara);
    }

    MenuBGReadInfo2Malloc(&MenuChangeMemory, tbl);
    MenuCharaChangeCLUT_Tex = 0;
    MenuMainFrameModeSet(4, 1);
    ChrChangMenuPt->EnterDataMenu((u8 *) stack->stack);
    MenuChangeMemory.Align64();
    size = MenuChangeMemory.stGetRest();
    MenuChangeNpcMemory.stSetBuffer(MenuChangeMemory.stGetTop(), size);
    ChrChangMenuPt->LoadNPCFaceData(&MenuChangeNpcMemory, 0);
    MenuChangeNpcMemory.Align64();
    size = stack_free_size(&MenuChangeNpcMemory);
    MenuCharaLoadStack.stSetBuffer((u_long128 *) stack_free_top(&MenuChangeNpcMemory), size);
    MenuLoadInfo.alternate_model = 0;
    MenuCharaLoadStack.stack_used = 0;
    MenuCharaLoadStack.lock = 0;

    switch (mode) {
        case 0:
            MenuLoadInfo.alternate_model = 1;
            break;
    }

    MenuLoadInfo.mode = 2;

    if (ChrChangMenuPt->key_arg_no == 2 || mode == 0xE) {
        while (GetMenuMainFrameEndFlag() == 0) {
            MenuMainFrameStep();
        }

        ChrChangMenuPt->FadeOutMenu(0x1E, 0.0f);
        ChrChangMenuPt->ExeScript("JOININIT");
    } else {
        MenuMainScene->fade.FadeIn(1);
        MenuMainScene->fade.FadeStep();
    }

    MenuCommonInfo->key_enable = 0;
    MenuCommonInfo->cursor = 0;
    MenuGetPartySeFlag = 0;
    MenuDCMsg[0]->MsgPreset(3);
    return 1;
}

int MenuCharaChangeKey() {
    int               result;
    int               fade_done;
    int               box_result;
    int               phase;
    int               mode;
    int               i;
    mgCMemory        *stack;
    u8               *texture;
    CMenuPosDataForm *form;
    CMenuPosDataForm *cursor_form;
    int               pos[2];

    result = 0;
    fade_done = ChrChangMenuPt->FadeCheckMenu();
    mode = 1;
    phase = ChrChangMenuPt->sub_menu;

    switch (phase) {
        case -1:
            if (ChrChangMenuPt->sub_menu_next == 1) {
                if (fade_done != 0) {
                    ChrChangMenuPt->sub_menu = ChrChangMenuPt->sub_menu_next;
                    MenuCharaLoadStack.stack_used = 0;
                    MenuCharaLoadStack.lock = 0;

                    if (MenuLoadInfo.alternate_model == 1) {
                        mode = 0;
                    }

                    MenuMonsterBoxInit(&MenuCharaLoadStack, ChrChangMenuPt->tex_block, mode);
                }
            } else if (ChrChangMenuPt->sub_menu_next == -1 && fade_done != 0) {
                result = ChrChangMenuPt->MenuLocalLoop();
            }

            break;
        case 1:
            if (ChrChangMenuPt->sub_menu_next == -1) {
                if (fade_done != 0) {
                    ChrChangMenuPt->sub_menu = ChrChangMenuPt->sub_menu_next;
                }
            } else if (phase == 1) {
                box_result = MenuMonsterBoxKey();

                if (box_result != 0) {
                    if (box_result == 1) {
                        ChrChangMenuPt->sub_menu_next = -1;
                        ChrChangMenuPt->sub_menu = -1;
                        MenuCharaLoadStack.stack_used = 0;
                        MenuCharaLoadStack.lock = 0;
                        texture = (u8 *) ChrChangeInitTextureStack.stack;
                        char file_name[0x40] = "chrchg0.pac";
                        LoadFileMenu(file_name, (u_long128 *) texture, 1);
                        ChrChangMenuPt->EnterDataMenu(texture);
                        ChrChangMenuPt->LoadNPCFaceData(&MenuChangeNpcMemory, 1);
                        ChrChangMenuPt->EnterNPCFaceData();
                        ChrChangMenuPt->LoadBGNPCModel(0);
                        ChrChangMenuPt->CheckBGNPCModel();
                        ((ClsMes *) MenuDCMsg[0])->SetBuff(ChrChangMenuPt->sys_mes);
                        MenuDCMsg[0]->MakeMsg(ChrChangMenuPt->select + 0x190);
                        form = MenuMesForm[7];
                        form->rgba[0] = 0x80;
                        form->rgba[1] = 0x80;
                        form->rgba[2] = 0x80;
                        form->rgba[3] = 0;
                        i = 0;

                        do {
                            form->SetRGBACalcParam(i, 0, 0x80);
                            i++;
                        } while (i < 4);

                        ChrChangMenuPt->InitStarInfo();
                        ChrChangMenuPt->star_fade = 0;
                        ChrChangMenuPt->set_cursor = 1;
                        ChrChangMenuPt->form->GetPutPosXY("cur3", pos[0], pos[1]);
                        MenuCommonInfo->MenuSetPos(pos[0], pos[1]);
                        ChrChangMenuPt->form->GetPutPosXY("mi2", pos[0], pos[1]);
                        cursor_form = MenuFormMI2;
                        cursor_form->x = (float) pos[0];
                        cursor_form->y = (float) pos[1];
                        ChrChangMenuPt->FadeInMenu(0x28, 0.0f);
                        MenuCamInit(1.0f);
                    } else if (box_result == 2) {
                        SetupUnitMan(MenuMainScene, MenuUserDataManPtr, 3, NULL);
                        result = 2;
                        MenuArg.result[0] = 3;
                    }
                }
            }

            break;
    }

    return result;
}

void MenuCharaChangeDraw() {
    int party_member;

    if (ChrChangMenuPt->sub_menu == CHR_CNG_SUB_MENU_NONE) {
        MenuPosData->FormDraw();

        if (MenuRepairMan != NULL) {
            MenuRepairMan->Step();
            MenuRepairMan->Draw();
        }

        if (menu_debug_flag == 0) {
            return;
        }

        CMenuFont font;
        mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);

        if (ChrChangMenuPt->select != 4) {
            DrawMenuFillBox(20.0f, 20.0f, 300.0f, 220.0f, 0x60, 0, 0, 0);
            char party[0x80] = {0};
            char change[0x80] = {0};
            char mask[0x80] = {0};
            party_member = MenuUserDataManPtr->GetNowPartyMember();
            int chara_change = MenuUserDataManPtr->chara_change;
            int change_mask = MenuUserDataManPtr->chara_change_mask;
            int i;

            for (i = 0; i < 4; i++) {
                int bit = 1 << i;

                if (party_member & bit) {
                    strcat(party, "\x81\x9B\x0A");
                } else {
                    strcat(party, "\x81\x7E\x0A");
                }

                if (chara_change & bit) {
                    strcat(change, "\x81\x9B\x0A");
                } else {
                    strcat(change, "\x81\x7E\x0A");
                }

                if (change_mask & bit) {
                    strcat(mask, "\x81\x9B\x0A");
                } else {
                    strcat(mask, "\x81\x7E\x0A");
                }
            }

            char title[0x200] = "Max\nMonica\nRidepod\nMonster";
            font.SetStr(title);
            font.SetPos(0x28, 0x3C);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            int cursor_x = MenuDebugChangeSelectMode * 0x3C + 0x98;
            font.SetStr("NowMode");
            font.SetPos(cursor_x, 0x14);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            font.SetStr("Party");
            font.SetPos(0x98, 0x28);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            font.SetStr(party);
            font.SetPos(0x98, 0x3C);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            font.SetStr("Shift");
            font.SetPos(0xD4, 0x28);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            font.SetStr(change);
            font.SetPos(0xD4, 0x3C);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            font.SetStr("MASK");
            font.SetPos(0x110, 0x28);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            font.SetStr(mask);
            font.SetPos(0x110, 0x3C);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            int cursor_y = MenuDebugCharaChangeSelect * 0x14 + 0x3C;
            font.SetStr("\x81\xA8");
            font.SetPos(0x14, cursor_y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);

            if (LanguageCode == 0) {
                font.SetStr("Control \nL1 R1:Mode Change\n(O):Join or Shift Enable\n(X):Leave or Shift Disable");
                font.SetPos(0x28, 0xA0);
                font.DrawDirect(font.str, font.pos_x, font.pos_y);
                return;
            }

            font.SetStr("Control \nL1 R1:Mode Change\n(X):Join or Shift Enable\n(O):Leave or Shift Disable");
            font.SetPos(0x28, 0xA0);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            return;
        }

        DrawMenuFillBox(20.0f, 26.0f, 280.0f, 300.0f, 0x60, 0, 0, 0);
        CUserDataManager *user_data = GetUserDataMan();
        mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
        int y = 0x46;
        font.SetStr("                  Pa:Tr:Ge");
        font.SetPos(0x14, 0x1E);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
        char npc_title[0x100] = "                           ";
        strcpy(&npc_title[menu_debug_npc_decide * 3 + 0x11], "\x81\xAB");
        font.SetStr(npc_title);
        font.SetPos(0x14, 0x32);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);

        for (int npc = menu_debug_npcselect; npc < 0xB3; npc++) {
            NPC_BASE_DATA *data = GetPartyNPCData(npc);

            if (data == NULL || data->debug_flag == 0) {
                continue;
            }

            PARTY_CHARA_INFO *info = user_data->GetPartyCharaInfo(npc);

            if (info == NULL) {
                continue;
            }

            char *name = GetNPCName(npc);

            if (name == NULL) {
                continue;
            }

            char line[0x100];
            sprintf(line, "  :%14s", name);

            if (info->status & 1) {
                strcat(line, "o:");
            } else {
                strcat(line, "x:");
            }

            if (info->status & 2) {
                strcat(line, "o:");
            } else {
                strcat(line, "x:");
            }

            if (info->status & 4) {
                strcat(line, "o");
            } else {
                strcat(line, "x");
            }

            font.SetStr(line);
            font.SetPos(0x1A, y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            y += 0x14;

            if (y >= 0x137) {
                break;
            }
        }

        font.SetStr("\x81\xA8");
        font.SetPos(0x14, 0x46);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
    } else if (ChrChangMenuPt->sub_menu == CHR_CNG_SUB_MENU_MONSTER_BOX) {
        MenuMonsterBoxDraw();
    }
}

char *GetMonsterName(int monster_no) {
    BASE_MONSTER_TBL *record = GetMonsterTable(monster_no);

    if (record != NULL) {
        return record->name;
    }

    return NULL;
}

int get_gajji_id_from_monster_progress_table(int progress_no, int *column_out) {
    int row;
    int column;

    for (row = 0; row < MONSTER_PROGRESS_NUM; row++) {
        for (column = 1; column < 1 + MONSTER_PROGRESS_LEVEL_NUM; column++) {
            if (progress_no == monster_progress_tbl[row][column]) {
                if (column_out) {
                    *column_out = column - 1;
                }

                return monster_progress_tbl[row][0];
            }
        }
    }

    return -1;
}

int GetMonsterProgressTableNo(int column, int value) {
    int row = 0;

    do {
        if (value == monster_progress_tbl[row][column + 1]) {
            return row;
        }

        row++;
    } while (row < MONSTER_PROGRESS_NUM);

    return -1;
}

int get_monster_tbl_bajjilevel(int *list, int monster_id, int value, int column) {
    int row;
    int count;
    int entry;
    int j;

    if (column < 0 || column > 3) {
        return 0;
    }

    count = 0;
    row = 0;

    for (; row < 19; row++) {
        if (value < 0 ||
            (0 <= value && column > 0 && value == monster_progress_tbl[row][column])) {
            if (monster_id == monster_progress_tbl[row][0]) {
                list[count] = monster_progress_tbl[row][column + 1];
                count++;
            }
        }
    }

    row = 0;

    for (; row < count; row++) {
        entry = list[row];

        for (j = row + 1; j < count; j++) {
            if (entry == list[j]) {
                local_sort1(row, &count, list);
            }
        }
    }

    return count;
}

int get_default_monster_progresstbl(int id) {
    int row;

    for (row = 0; row < 19; row++) {
        if (id == monster_progress_tbl[row][0]) {
            return row;
        }
    }

    return 0;
}

int GetMonsterModelFile(int monster_id, int kind, char *file_name) {
    char              suffix[0x20];
    BASE_MONSTER_TBL *monster;
    char             *base_name;
    int               number;
    int              *henge_param;

    if (file_name == NULL) {
        return 0;
    }

    monster = GetMonsterTable(monster_id);
    base_name = monster->model;

    if (monster == NULL) {
        return 0;
    }

    if ((int) strlen(base_name) <= 0) {
        return 0;
    }

    strcpy(file_name, base_name);

    if (kind == 0) {
        strcat(file_name, ".chr");
    }

    if (kind == 1) {
        number = monster->sound_no;

        if (number < 0) {
            return 0;
        }

        strcpy(file_name, "snd2/mon/");

        if (number < 10) {
            sprintf(suffix, "EN_00%d.snd", number);
        } else if (number < 100) {
            sprintf(suffix, "EN_0%d.snd", number);
        } else {
            sprintf(suffix, "EN_%d.snd", number);
        }

        strcat(file_name, suffix);
    }

    if (kind == 2) {
        henge_param = (int *) GetMonsterHengeParam(monster_id);

        if (henge_param != NULL) {
            sprintf(file_name, "%s.stb", henge_param[2]);
        }
    }

    if (kind == 3) {
        strcpy(file_name, monster->model);
        strcat(file_name, ".cfg");
    }

    return 1;
}

void CMenuMosSelect::AttachForm() {
    char              name[0x20];
    MOS_CHANGE_PARAM *base;
    int               i;
    badge_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("\x83\x82\x83\x93\x83\x58\x83\x5E\x81\x5B\x83\x6F\x83\x62\x83\x57\x94\xA0");
    model_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("\x83\x82\x83\x93\x83\x58\x83\x5E\x81\x5B\x83\x7C\x83\x8A");
    info_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("\x83\x82\x83\x93\x83\x58\x83\x5E\x81\x5B\x83\x58\x83\x65\x81\x5B\x83\x5E\x83\x58");
    Tex_BuildUpBoard = mgTexManager.GetTexture("itembrd", -1);
    GetUserDataMan();

    if (badge_form != NULL) {
        base = badge;
        i = 0;

        do {
            MENUFORMPARTS_TYPE *part;
            sprintf(name, "B%d", i);
            part = badge_form->GetPartInfo(name);

            if (part != NULL) {
                part->draw_flag = base[i].enable != 0;
            }

            i += 1;
        } while (i < 0xC);
    }
}

void MonsterScaleCheck(CCharacter2 *chara) {
    float height = chara->GetBodyHeight();
    float scale = 1.0f;
    float size = height < 0.0f ? -height : height;

    if (size > 1.0f) {
        scale = 5.8f / height;
    }

    chara->SetScale(scale, scale, scale);
}

int MonsterEffectRead(mgCMemory *stack, int monster_no, int background) {
    char script_path[0x80];
    char pack_path[0x80];
    int  i;

    mos_effect_henge_param = GetMonsterHengeParam(monster_no);
    mos_effect_read_num = 0;

    if (mos_effect_henge_param != NULL && stack != NULL) {
        if (FxScriptMan != NULL) {
            for (i = 0; i < 4; i++) {
                char *effect_name = mos_effect_henge_param->effect_name[i];

                if (effect_name == NULL) {
                    continue;
                }

                FxScriptMan->GetNeedFilePath(effect_name, script_path, pack_path);
                stack->Align64();
                mos_effect_readbuff1[i] = (u8 *) stack->stGetTop();

                if (background != 0) {
                    if (LoadFileBG(script_path, (u_long128 *) mos_effect_readbuff1[i],
                                   &mos_effect_readbuff1_size[i]) == 0) {
                        continue;
                    }
                } else if (LoadFile2(script_path, mos_effect_readbuff1[i],
                                     &mos_effect_readbuff1_size[i], 0) == 0) {
                    continue;
                }

                unsigned int total = mos_effect_readbuff1_size[i] + 0x800;
                stack->Alloc((total & 0xF) ? (total >> 4) + 1 : total >> 4);
                stack->Align64();
                mos_effect_readbuff2[i] = (u8 *) stack->stGetTop();

                if (background != 0) {
                    if (LoadFileBG(pack_path, (u_long128 *) mos_effect_readbuff2[i],
                                   &mos_effect_readbuff2_size[i]) == 0) {
                        continue;
                    }
                } else if (LoadFile2(pack_path, mos_effect_readbuff2[i],
                                     &mos_effect_readbuff2_size[i], 0) == 0) {
                    continue;
                }

                total = mos_effect_readbuff2_size[i] + 0x800;
                stack->Alloc((total & 0xF) ? (total >> 4) + 1 : total >> 4);
                mos_effect_read_num += 1;
            }
        }
    }

    return mos_effect_read_num;
}

int MonsterEffectEnter(CScene *scene, u_long128 *buffer, int tex_block) {
    int        i;
    u_long128 *saved_buffer;

    if (mos_effect_henge_param != NULL && 0 < mos_effect_read_num && FxScriptMan != NULL) {
        mgTexManager.DeleteBlock(tex_block);
        saved_buffer = scene->read_buff;
        i = 0;
        FxScriptMan->load_buffer = (u_long128 *) buffer;

        for (; i < mos_effect_read_num; i++) {
            char *effect_name = mos_effect_henge_param->effect_name[i];

            if (effect_name != NULL) {
                FxScriptMan->BuildBase(effect_name, (u_long128 *) mos_effect_readbuff1[i],
                                       mos_effect_readbuff1_size[i],
                                       (u_long128 *) mos_effect_readbuff2[i],
                                       mos_effect_readbuff2_size[i], MorattaStack, tex_block);
            }
        }

        FxScriptMan->load_buffer = saved_buffer;
        return 1;
    }

    return 0;
}

int CMenuMosSelect::CheckLoadBGMonster() {
    switch (load_phase) {
        case 0: {
            load_wait = load_wait - 1;

            if (load_wait > 0) {
                break;
            }

            if (view_monster < 0) {
                load_monster = -1;
                load_phase = -1;
                model_form->draw_flag = 0;
                break;
            }

            if (load_monster == view_monster) {
                load_phase = 2;
                return 0;
            }

            BreakReadBG();
            StartReadBG();
            mgCMemory *stack = &MenuMonChangeLoadStack;
            load_monster = view_monster;
            stack->stReset();

            if (MenuLoadInfo.update_scene == 1) {
                MenuMainScene->AssignStack(5);
                stack = MenuMainScene->GetStack(5);
            }

            stack->stReset();
            MenuMonsterLoadBG(stack, MenuMonsterBGInfo, load_monster, 1);
            model_form->counter = -16;

            if (MenuLoadInfo.update_scene == 1) {
                MenuCharaSoundLoad(stack, 3, 1);
            }

            load_phase++;
            model_form->draw_flag = 0;
            break;
        }
        case 1:
            if (MenuMonsterBGInfo[0]->reading && ReadBGSync() == 0) {
                CActionChara *chara[7] = {NULL, NULL, NULL, NULL, NULL, NULL, NULL};
                chara[0] = monster;
                int tex_block = this->tex_block[1];
                MenuMonsterLoadBGCheck(MenuMonsterBGInfo, chara, tex_block, MenuArg.chara_tex_block);

                if (MenuLoadInfo.update_scene == 0) {
                    MonsterScaleCheck(chara[0]);
                    chara[0]->SetPosition(float(16.0), 1.0f, 0.0f);
                    model_form->SetActionCharaPtr(monster, tex_block, -1);
                    model_form->counter = -14;
                    model_form->draw_flag = 1;
                    monster->Show(0, 1);
                    monster->fade = 1;
                    monster->fade_speed = 0.05f;
                }

                load_phase++;

                if (MenuLoadInfo.update_scene == 1) {
                    load_phase++;
                    MenuSoundCharaNo = 3;
                    chara[0] = (CActionChara *) MenuMainScene->GetCharacter(0);
                    MenuCharaSoundEnter(MenuMainScene, chara[0], 1);
                    mgCMemory *stack = MenuMainScene->GetStack(5);
                    stack->stReset();
                    StartReadBG();
                    MonsterEffectRead(stack, load_monster, 1);
                }
            }

            return 1;
        case 2:
            break;
        case 3:
            if (ReadBGSync() == 0) {
                load_phase++;
                mgCMemory *stack = &MenuMonChangeLoadStack;
                u_long128 *buffer = NULL;

                if (stack != NULL) {
                    buffer = stack->stGetTop();
                }

                MonsterEffectEnter(MenuMainScene, buffer, 0xAA);
            }

            break;
    }

    monster->GetPosition(model_pos);

    if (model_side == 0) {
        model_pos[0] += (16.0f - model_pos[0]) / 4.0f;
    } else if (model_side == 1) {
        model_pos[0] += (-15.0f - model_pos[0]) / 4.0f;
    }

    monster->SetPosition(model_pos);

    if (model_form->counter >= 15) {
        monster->Show(1, 1);
    }

    if (skip_draw) {
        monster->Step();
    }

    skip_draw ^= 1;
    return 0;
}

void GetBajjiPosition(CMenuPosDataForm *form, int slot, int unused, int *pos) {
    char name[0x20];

    if (form != NULL) {
        sprintf(name, "B%d", slot);
        form->GetPutPosXY(name, pos[0], pos[1]);
    }
}

void CMenuMosSelect::CalcCursorPosition() {
    int pos[2];

    if (BuildUpWeaponInfo.mode == 1) {
        int selected = BuildUpWeaponInfo.select_no;
        pos[0] = BuildUpNameXY[selected][0] - 0x14;
        pos[1] = BuildUpNameXY[selected][1];
    } else {
        GetBajjiPosition(badge_form, select, top, pos);
        pos[0] -= 0x1E;
        pos[1] += 0xE;
    }

    MenuCommonInfo->MenuPosStep(pos, NULL);

    if (set_cursor != 0) {
        MenuCommonInfo->MenuSetPos(pos[0], pos[1]);
        set_cursor = 0;
    }
}

void CMenuMosSelect::CalcTex() {
    int      item_pos[MES_ITEM_MAX][2];
    int      win_pos[2];
    int      badge_pos[2];
    int     *pos;
    CDC2Mes *ask = MenuDCMsg[7];

    if (info_form != NULL && ask != NULL) {
        info_form->GetPutPosXY("\x96\xBC\x91\x4F", item_pos[0][0], item_pos[0][1]);
        int *choice = item_pos[1];
        info_form->GetPutPosXY("\x8F\xCC\x8D\x86", choice[0], choice[1]);
        pos = item_pos[2];
        info_form->GetPutPosXY("\x81\x9B", pos[0], pos[1]);
        pos = item_pos[3];
        info_form->GetPutPosXY("\x81\xA1", pos[0], pos[1]);
        pos = item_pos[4];
        info_form->GetPutPosXY("\x8B\x5A"
                               "1",
                               pos[0], pos[1]);
        pos = item_pos[5];
        info_form->GetPutPosXY("\x8B\x5A"
                               "2",
                               pos[0], pos[1]);
        item_pos[0][0] -= ask->GetStrWidth(0) >> 1;
        int width = ask->GetMesWidth_system(ask->item_mes[1]);
        choice[0] -= width >> 1;
        ask->SetMsgItemPos(item_pos[0], 6);
        info_form->GetPutPosXY("\x90\xE0\x96\xBE", win_pos[0], win_pos[1]);
        info_win.abs_win.x = win_pos[0];
        info_win.abs_win.y = win_pos[1];
    }

    CMenuPosDataForm *form = MenuMesForm[5];
    CDC2Mes          *mes = MenuDCMsg[5];

    if (mes != NULL && form != NULL) {
        GetBajjiPosition(badge_form, select, top, badge_pos);

        if (select / 3 - top == 3) {
            badge_pos[1] -= 0x4C;
            mes->point_x = 16;
            mes->point_y = 100;
        } else {
            badge_pos[1] += 0x4C;
            mes->point_x = 16;
            mes->point_y = -20;
        }

        form->x = badge_pos[0];
        form->y = badge_pos[1];
    }

    if (step == 20) {
        badge_pos[0] += 0x6E;
        mes = MenuDCMsg[6];
        mes->point_x = -40;
        mes->point_y = 20;
        form = MenuMesForm[6];
        form->x = badge_pos[0];
        form->y = badge_pos[1];
    }
}

int CMenuMosSelect::KeyNormalMode(int keys, int a, int b) {
    /**
     *
     * Total columns and rows of the monster badge grid.
     *
     */
    static int max[2] = {MOS_SELECT_GRID_COLUMNS, MOS_SELECT_GRID_ROWS};

    /**
     *
     * Visible columns and rows of the monster badge grid.
     *
     */
    static int viewnum[2] = {MOS_SELECT_GRID_COLUMNS, MOS_SELECT_GRID_ROWS};

    /**
     *
     * Directional edge overrides of the monster badge grid.
     *
     */
    static int overcode[4] = {0, 0, 0, 0};

    int old_cursor = select;
    MenuGlidKeyCheck(keys, &select, &top, max, viewnum, overcode,
                     0xC);

    if (old_cursor != select) {
        MenuLoadInfo.update_scene = 0;
        view_monster = -1;

        if (select < 0xA) {
            MOS_CHANGE_PARAM *entry = badge + select;

            if (entry != NULL) {
                if (entry->enable != 0) {
                    view_monster = entry->monster_id;
                }
            }
        }

        MenuSePlay(0);
    }

    return 1;
}

inline CMenuMosSelect::CMenuMosSelect() {
    key_arg_no = 0;
    select = 0;
    top = 0;
    unk_5504 = 0;
    mes_data = NULL;
    monster->Initialize(NULL);
    unk_765C = 0;
    result = 0;
    load_wait = 0;
    load_phase = 0;
    view_monster = -1;
    pick_monster = -1;
    load_monster = -1;
    level_max = 0;
    set_cursor = 1;
    mes_show = 0;
    MenuMesInit(&mes);
    mes.texture_block = MenuArg.mes_tex_block;
    badge = GetUserDataMan()->GetMonsterBajjiDataPtr(1);
    select_badge = NULL;
    info_win.texture_block = MenuArg.mes_tex_block;
    MenuMesInit(&info_win);
    info_win.SetWindowMode(4);
    info_win.fuchi = 0;
    info_win.fade_speed = 1.0f;
    info_win.push_button = 0;
    info_win.fukidashi_pos = 8;
    info_win.alpha = 0;
    effect_data = NULL;
    effect_sound = NULL;
    effect_show = 0;
    effect_frame = 0;
    info_win_show = 1;
    skip_draw = 0;
    change_wait = 0;
    badge_form = NULL;
    info_form = NULL;
    model_form = NULL;
}

#pragma inline_depth(smart)

void MenuMonsterBoxInit(mgCMemory *stack, int *tex_block, int mode) {
    /**
     *
     * Default camera position for the monster selection menu.
     *
     */
    static sceVu0FVECTOR posdef = {0.0f, 0.0f, 100.0f, 1.0f};

    /**
     *
     * Default camera target for the monster selection menu.
     *
     */
    static sceVu0FVECTOR refdef = {0.0f, 9.0f, 0.0f, 1.0f};

    /**
     *
     * Localized help messages for monster transformation selection.
     *
     */
    static char *tbl[LANG_CHINESE + 1] = {
        ":",
        "[l1][r1]:View same type of monster",
        "[l1][r1]: voir m[UNI00ea]me type de monstre",
        "[l1][r1]: Selbe Monster anzeigen.",
        "[l1][r1]: Vis. stesso tipo di mostro",
        "[l1][r1]: Ver mismo tipo de monstruo",
        "[l1][r1]:View same type of monster",
    };

    CMenuMosSelect *menu;
    CActionChara   *chara;
    int             i;
    int             size;

    mgCMemory memory;
    int       rest = stack->stGetRest();
    memory.stSetBuffer(stack->stGetTop(), rest);
    stack = &memory;

    menu = new (stack->Alloc(0x769)) CMenuMosSelect;

    MenuMosSelectPtr = menu;
    menu->SetTexBlock(tex_block);
    MenuMosSelectPtr->FadeInMenu(40, 0.0f);

    for (i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
        /**
         *
         * Character slots that require monster menu background read requests.
         *
         */
        static int tbl[MENU_CHARA_LOAD_MAX] = {1, 0, 0, 0, 0, 1, 0};

        MenuMonsterBGInfo[i] = NULL;

        if (tbl[i]) {
            MenuMonsterBGInfo[i] = (MENU_BGREAD_INFO2 *) stack->Alloc(8);
            InitMenuBGReadInfo2(MenuMonsterBGInfo[i]);
        }
    }

    *(CameraPoint *) MenuMosSelectPtr->camera_pos = *(CameraPoint *) MenuDrawEnv->pos;
    *(CameraPoint *) MenuMosSelectPtr->camera_ref = *(CameraPoint *) MenuDrawEnv->ref;
    sceVu0CopyVector(MenuDrawEnv->pos, posdef);
    sceVu0CopyVector(MenuDrawEnv->ref, refdef);
    MenuDrawEnv->camera.SetPos(posdef);
    MenuDrawEnv->camera.SetRef(refdef);
    stack->Align64();
    u_int *pack = (u_int *) stack->stGetTop();
    size = LoadFileMenu("mosbox.pac", (u_long128 *) pack, 1);
    stack->Alloc(blocks_for(size));
    u_char *image = (u_char *) GetPackFile(pack, "mosbox.img", NULL);
    int     block = MenuMosSelectPtr->tex_block[0];
    mgTexManager.EnterIMGFile(image, block, NULL, NULL);
    MenuMosTexture = mgTexManager.GetTexture("mosbox", block);
    MenuMosSelectPtr->mes_data = MenuDCMsg[0]->buff;
    s16 *box_mes = (s16 *) GetPackFile(pack, "menumos.mes", NULL);
    MenuCommandAnalyzeInfo.system_mes_buff[0] = GetSystemMesBuffer();
    MenuCommandAnalyzeInfo.system_mes_buff[1] = box_mes;
    MenuCommandAnalyzeInfo.mes_buff[0] = MenuMosSelectPtr->mes_data;
    MenuCommandAnalyzeInfo.mes_buff[1] = box_mes;
    MenuMosSelectPtr->mes.SetMessData(GetSystemMesBuffer(), MenuMosSelectPtr->mes_data);
    MenuMosSelectPtr->info_win.SetBuff_system(GetSystemMesBuffer());
    MenuMosSelectPtr->info_win.SetBuff(MenuMosSelectPtr->mes_data);
    MenuMosSelectPtr->info_win.MakeMesWin(tbl[LanguageCode], 1, 1);
    char *cfg = (char *) GetPackFile(pack, "mosbox.cfg", &size);
    MenuDataAnalyze(cfg, size, stack);
    MenuMosSelectPtr->script = (char *) GetPackFile(pack, "mosbox_com.cfg", &MenuMosSelectPtr->script_size);
    MenuMosSelectPtr->AttachForm();
    MenuMosSelectPtr->ExeScript("MSG\x8F\x89\x8A\xFA\x89\xBB");
    MenuMosSelectPtr->ExeScript("FORM_INIT");
    AttachMessageForm();
    stack->Align64();
    rest = stack->stGetRest();
    MenuMosLoadStack.stSetBuffer(stack->stGetTop(), rest);
    MenuLoadInfo.load_all = 1;
    MenuLoadInfo.mode = 0;
    MenuLoadInfo.update_scene = 0;
    MenuMemoryAdjust(&MenuMosLoadStack, &MenuMonChangeLoadStack, MenuActionCharaBuffer, 3);
    int badge_no = get_gajji_id_from_monster_progress_table(MenuUserDataManPtr->monster_id, NULL);

    if (badge_no < 0) {
        badge_no = 0;
    }

    if (badge_no > MOS_SELECT_BADGE_NUM - 1) {
        badge_no = 0;
    }

    MenuMosSelectPtr->select = badge_no;

    if (MenuMosSelectPtr->badge[MenuMosSelectPtr->select].enable) {
        MenuMosSelectPtr->view_monster = MenuMosSelectPtr->badge[MenuMosSelectPtr->select].monster_id;
    }
}

#pragma inline_depth reset

int CMenuMosSelect::KeyStep() {
    /**
     *
     * Reward parameter index of each displayed monster badge.
     *
     */
    static s8 convert_table[10] = {8, 4, 9, 2, 3, 5, 0, 6, 7, 1};

    /**
     *
     * Growth title message number of each monster badge family.
     *
     */
    static short ghobitbl[10] = {186, 187, 188, 189, 190, 191, 192, 193, 194, 196};

    /**
     *
     * Monster badge health and growth number part names.
     *
     */
    static char *get_stringtbl[4] = {
        "\x82\xD6\x82\xF1\x82\xB0\x8D\xA1",
        "\x82\xD6\x82\xF1\x82\xB0\x8D\xC5\x91\xE5",
        "\x8F\x6E\x97\xFB\x8D\xA1",
        "\x8F\x6E\x97\xFB\x8D\xC5\x91\xE5",
    };

    /**
     *
     * Actions requested by the badge, command, form-list and status keys.
     *
     */
    enum MosSelectAction {
        MOS_SELECT_ACTION_NONE = 0,              /**< No action requested. */
        MOS_SELECT_ACTION_REJECT = 5,            /**< Rejects the key with the cancel sound. */
        MOS_SELECT_ACTION_TRANSFORM = 10,        /**< Turns Monica into the monster form chosen in the form list. */
        MOS_SELECT_ACTION_CANNOT_TRANSFORM = 11, /**< Shows that the transformation is not possible. */
        MOS_SELECT_ACTION_FORM_LIST = 12,        /**< Opens the list of the badge's monster forms to transform into. */
        MOS_SELECT_ACTION_STATUS = 20,           /**< Opens the status page of the badge's monster. */
        MOS_SELECT_ACTION_CLASS_CHANGE = 30,     /**< Opens the list of monsters the badge can change class to. */
        MOS_SELECT_ACTION_BADGES = 500,          /**< Returns to the badge selection. */
        MOS_SELECT_ACTION_COMMANDS = 600,        /**< Opens the chosen badge's command window. */
        MOS_SELECT_ACTION_CLOSE = 1000           /**< Closes the monster box. */
    };

    int      size;
    int      i;
    int      keys = MenuCommonInfo->CheckSelectKey();
    int      lr_keys = MenuCommonInfo->CheckLRKey();
    int      buttons = MenuCommonInfo->CheckPushButton();
    int      fade_end = MenuMosSelectPtr->FadeCheckMenu();
    CDC2Mes *command = MenuDCMsg[5];
    int      show_info = 0;
    int      action;

    switch (mode) {
        case MENU_ASK_MODE_OPEN:
            if (fade_end) {
                mode = MENU_ASK_MODE_NONE;
                select_badge = NULL;
            }

            break;
        case MENU_ASK_MODE_CLOSE:
            if (fade_end && (result == MOS_SELECT_RESULT_CLOSE || (result == MOS_SELECT_RESULT_CHANGE && load_phase == 4))) {
                if (result == MOS_SELECT_RESULT_CHANGE) {
                    CActionChara *player = (CActionChara *) MenuMainScene->GetCharacter(0);

                    if (player != NULL) {
                        player->effect_man = FxScriptMan;
                        player->InitScript();
                    }

                    MenuArg.end_code = 1;
                    MenuArg.result[0] = USER_CHARA_MONSTER;
                }

                MenuDrawEnv->camera.SetPos(camera_pos);
                MenuDrawEnv->camera.SetRef(camera_ref);
                *(CameraPoint *) MenuDrawEnv->pos = *(CameraPoint *) camera_pos;
                *(CameraPoint *) MenuDrawEnv->ref = *(CameraPoint *) camera_ref;
                ExeScript("\x8F\x49\x97\xB9\x8F\x88\x97\x9D");
                MenuPosData->TexGetInfoClear(0xAA, 0x100);
                MenuPosData->FormInfoClear(0x3C, 0x4F);
                return result;
            }

            break;
        case MENU_ASK_MODE_NONE: {
            action = MOS_SELECT_ACTION_NONE;

            if (menu_debug_flag) {
                if (keys & MENU_SELECT_KEY_UP) {
                    menu_debug_select__2--;
                }

                if (keys & MENU_SELECT_KEY_DOWN) {
                    menu_debug_select__2++;
                }

                if (menu_debug_select__2 < 0) {
                    menu_debug_select__2 = MOS_SELECT_BADGE_NUM - 1;
                }

                if (menu_debug_select__2 >= MOS_SELECT_BADGE_NUM) {
                    menu_debug_select__2 = 0;
                }

                MOS_CHANGE_PARAM *debug_badge = &badge[menu_debug_select__2];

                if (debug_badge != NULL) {
                    COMMON_GAGE *gauge = &debug_badge->hp;

                    if (GamePad__2.On(PAD_SQUARE)) {
                        gauge = &debug_badge->abs;
                    }

                    if (keys & MENU_SELECT_KEY_RIGHT) {
                        gauge->AddPoint(1.0f);
                    } else if (keys & MENU_SELECT_KEY_LEFT) {
                        gauge->AddPoint(-1.0f);
                    }

                    if (buttons & MENU_PUSH_BUTTON_DECIDE) {
                        if (debug_badge->enable) {
                            debug_badge->enable = 0;
                        } else {
                            GetUserDataMan()->monster_box.EnableChange(menu_debug_select__2 + 1);
                        }

                        MenuSePlay(SYSTEM_SE_DECIDE);
                    }

                    if (buttons & MENU_PUSH_BUTTON_TRIANGLE) {
                        if (debug_badge->enable) {
                            debug_badge->abs.SetFillRate(1.0f);
                            debug_badge->LevelUp();
                        }
                    }

                    if (buttons & MENU_PUSH_BUTTON_CANCEL) {
                        for (i = 0; i < MOS_SELECT_BADGE_NUM; i++) {
                            MOS_CHANGE_PARAM *entry = &badge[i];
                            GetUserDataMan()->monster_box.EnableChange(i + 1);
                            entry->level = 98;
                        }
                    }
                }

                return 0;
            }

            CDC2Mes *info = MenuDCMsg[6];

            switch (key_arg_no) {
                case MOS_SELECT_PAGE_BADGE:
                    KeyNormalMode(keys, lr_keys, buttons);

                    switch (buttons) {
                        case MENU_PUSH_BUTTON_DECIDE:
                        case MENU_PUSH_BUTTON_TRIANGLE:
                            if (select > 9) {
                                action = MOS_SELECT_ACTION_REJECT;
                            } else {
                                select_badge = &badge[select];

                                if (select_badge == NULL || (select_badge != NULL && !select_badge->enable)) {
                                    MenuSePlay(SYSTEM_SE_CANCEL);
                                    select_badge = NULL;
                                } else {
                                    action = MOS_SELECT_ACTION_COMMANDS;
                                }
                            }

                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            select_badge = NULL;
                            action = MOS_SELECT_ACTION_CLOSE;
                            break;
                    }

                    break;
                case MOS_SELECT_PAGE_COMMAND:
                    switch (step) {
                        case MOS_SELECT_STEP_COMMAND: {
                            int cursor = command->CommandMsgCursor();

                            switch (buttons) {
                                case MENU_PUSH_BUTTON_DECIDE:
                                case MENU_PUSH_BUTTON_TRIANGLE: {
                                    int mes = command->item_mes[cursor];

                                    if (mes == MOS_SELECT_CMD_STATUS) {
                                        action = MOS_SELECT_ACTION_STATUS;
                                    }

                                    if (mes == MOS_SELECT_CMD_TRANSFORM) {
                                        action = MOS_SELECT_ACTION_FORM_LIST;
                                    }

                                    if (mes == MOS_SELECT_CMD_CLASS_CHANGE) {
                                        action = MOS_SELECT_ACTION_CLASS_CHANGE;
                                    }

                                    if (action == MOS_SELECT_ACTION_FORM_LIST && command->line_color[cursor] == MES_COLOR_DARK) {
                                        action = MOS_SELECT_ACTION_REJECT;
                                    }

                                    break;
                                }
                                case MENU_PUSH_BUTTON_CANCEL:
                                    action = MOS_SELECT_ACTION_BADGES;
                                    break;
                            }

                            break;
                        }
                        case MOS_SELECT_STEP_ERROR:
                            if (buttons) {
                                ExeScript("ERRMSGOFF");
                                step = MOS_SELECT_STEP_COMMAND;
                            }

                            break;
                        case MOS_SELECT_STEP_CLASS_SELECT:
                            /**
                             *
                             * Class-change monster chosen in the growth list, kept for the change steps.
                             *
                             */
                            static int select_monster_save = 0;

                            {
                                int old_select = BuildUpWeaponInfo.select_no;

                                if (keys & MENU_SELECT_KEY_UP) {
                                    BuildUpWeaponInfo.select_no = old_select - 1;
                                }

                                if (keys & MENU_SELECT_KEY_DOWN) {
                                    BuildUpWeaponInfo.select_no++;
                                }

                                if (BuildUpWeaponInfo.select_no < 0) {
                                    BuildUpWeaponInfo.select_no = 0;
                                }

                                if (BuildUpWeaponInfo.select_num <= BuildUpWeaponInfo.select_no) {
                                    BuildUpWeaponInfo.select_no = BuildUpWeaponInfo.select_num - 1;
                                }

                                if (old_select != BuildUpWeaponInfo.select_no) {
                                    MenuSePlay(SYSTEM_SE_CURSOR);
                                }

                                switch (buttons) {
                                    case MENU_PUSH_BUTTON_DECIDE: {
                                        select_monster_save = BuildUpWeaponInfo.select_no;
                                        step = MOS_SELECT_STEP_CLASS_CONFIRM;
                                        ExeScript("\x83\x4E\x83\x89\x83\x58\x83\x60\x83\x46\x83\x93\x83\x57\x81\x48");
                                        mes_show = 1;
                                        mes.MsgPreset(MENU_SCRIPT_MES_YESNO);
                                        mes.ClsMes::mes_no = -1;
                                        char *name = GetMonsterName(level_monster[select_monster_save]);

                                        if (name != NULL) {
                                            strcpy(mes.name[0], name);
                                        }

                                        mes.SetAbsPos(5);
                                        mes.MakeMsg(0x1D8);
                                        mes.SetMsgCursor(1);
                                        break;
                                    }
                                    case MENU_PUSH_BUTTON_CANCEL:
                                        step = MOS_SELECT_STEP_COMMAND;
                                        ExeScript("\x83\x4E\x83\x89\x83\x58\x83\x60\x83\x46\x83\x93\x83\x57"
                                                  "2OFF");
                                        MenuSePlay(SYSTEM_SE_CANCEL);
                                        BuildUpWeaponInfo.mode = 0;
                                        break;
                                }

                                break;
                            }
                        case MOS_SELECT_STEP_CLASS_CONFIRM: {
                            int answer = mes.YesNoCursor2(0);

                            if (answer == MES_YESNO_YES && ReadBGSync() == 0) {
                                mes_show = 0;
                                BuildUpWeaponInfo.mode = 0;
                                change_wait = 0;
                                step = MOS_SELECT_STEP_CLASS_EFFECT;
                                ExeScript("\x83\x4E\x83\x89\x83\x58\x83\x60\x83\x46\x83\x93\x83\x57\x81\x49");
                                MenuMonChangeLoadStack.stReset();
                                effect.Initialize(NULL);
                                effect_show = 0;
                                effect_data = MenuMonChangeLoadStack.stack;
                                effect_sound = reinterpret_cast<u32 *>(&effect_data[0x3980]);
                                effect_stack.stSetBuffer(
                                    MenuMonChangeLoadStack.stack + MenuMonChangeLoadStack.stack_size - 0x3B80, 0x3980);
                                StartReadBG();
                                LoadFileBG("snd2/sp/SP_045.snd", (u_long128 *) effect_sound, &size);
                                LoadFileBG("menu/eff/mos_chn.chr", effect_data, &size);
                            }

                            if (answer == MES_YESNO_NO) {
                                mes_show = 0;
                                BuildUpWeaponInfo.mode = 1;
                                step = MOS_SELECT_STEP_CLASS_SELECT;
                                ExeScript("\x83\x4E\x83\x89\x83\x58\x83\x60\x83\x46\x83\x93\x83\x57\x8E\x7E\x82\xDF");
                            }

                            break;
                        }
                        case MOS_SELECT_STEP_CLASS_EFFECT: {
                            change_wait++;

                            if (ReadBGSync() == 0 && effect_show == 0) {
                                if (effect_sound != NULL) {
                                    mgCMemory sound_stack;
                                    sound_stack.stSetBuffer(
                                        MenuMonChangeLoadStack.stack + MenuMonChangeLoadStack.stack_size - 0x200, 0x140);
                                    MenuSePlay(0, effect_sound, &sound_stack);
                                }

                                mgTexManager.DeleteBlock(tex_block[2]);
                                effect.Initialize(NULL);
                                effect.LoadPack((u_int *) effect_data, "info.cfg", &effect_stack, &effect_stack, &effect_stack,
                                                tex_block[2], NULL);
                                effect.SetScale(1.5f, 1.5f, 1.5f);
                                sceVu0FVECTOR effect_pos;
                                monster->GetPosition(effect_pos);
                                effect_pos[1] += 10.2f;
                                effect_pos[0] -= 3.4f;
                                effect_pos[2] += 18.0f;
                                effect.SetPosition(effect_pos);
                                effect.SetMotion("\x83\x4E\x83\x89\x83\x58\x83\x60\x83\x46\x83\x93\x83\x57", 6, 1);
                                effect.Step();
                                effect_show = 1;
                                effect_frame = 0;
                            }

                            if (effect_show) {
                                effect_frame++;

                                if (effect_frame >= 20) {
                                    effect.Step();
                                }

                                if (effect_frame == 10) {
                                    load_phase = 0;
                                    select_badge->class_level++;
                                    select_badge->monster_id = level_monster[select_monster_save];
                                    view_monster = select_badge->monster_id;
                                    select_badge->progress =
                                        GetMonsterProgressTableNo(select_badge->class_level, select_badge->monster_id);
                                }
                            }

                            if (change_wait < 100 && effect_show) {
                                model_form->counter = 10;
                            }

                            effect.GetNowFrame(NULL);

                            if (change_wait > 900 || (effect_show && effect.CheckMotionEnd(NULL))) {
                                effect_show = 0;
                                effect.Initialize(NULL);
                                step = MOS_SELECT_STEP_CLASS_DONE;
                                ExeScript("\x83\x4E\x83\x89\x83\x58\x83\x60\x83\x46\x83\x93\x83\x57\x8F\x49\x97\xB9MSG");
                                MenuSePlay(0x1E);
                                char *grown[1] = {NULL};
                                grown[0] = GetMonsterName(level_monster[select_monster_save]);
                                info->SetMsgItemNo(grown, 1);
                            }

                            break;
                        }
                        case MOS_SELECT_STEP_CLASS_DONE:
                        case MOS_SELECT_STEP_CLASS_REWARD:
                        case MOS_SELECT_STEP_CLASS_LAST_REWARD:
                            if (!(buttons & MENU_PUSH_BUTTON_DECIDE) && !(buttons & MENU_PUSH_BUTTON_CANCEL)) {
                                break;
                            }

                            if (step == MOS_SELECT_STEP_CLASS_DONE) {
                                level_max = 0;
                                step = MOS_SELECT_STEP_CLASS_REWARD;
                                CGameDataUsed *place = GetUserDataMan()->SearchSpaceUsedDataPtr();

                                if (place != NULL) {
                                    CGameDataUsed reward;
                                    reward.Init();
                                    int badge_index = select;
                                    reward.item_no = 0x17F;
                                    reward.used_type = USED_ITEM_TYPE_ATTACH;
                                    reward.item_type = ITEM_DATA_UNK_22;
                                    reward.data.attach.spectol_value = select_badge->class_level + 1;
                                    s16 *param = reward.data.attach.status;

                                    if (select_badge->class_level == 3) {
                                        level_max = 1;
                                    }

                                    for (int j = 0; j < 10; j++) {
                                        param[j] = select_badge->class_level + 3;
                                    }

                                    param[convert_table[badge_index]] += select_badge->class_level * 2;
                                    place->CopyGameData(&reward);
                                    ExeScript("\x83\x82\x83\x93\x83\x58\x83\x5E\x81\x5B\x82\xB5\x82\xB8\x82\xAD");
                                } else {
                                    ExeScript("\x83\x82\x83\x93\x83\x58\x83\x5E\x81\x5B\x82\xB5\x82\xB8\x82\xADNOT");
                                }
                            } else if (step == MOS_SELECT_STEP_CLASS_REWARD) {
                                if (level_max) {
                                    int got = MenuUserDataManPtr->GetItem(ghobitbl[select], 5);

                                    if (0 < got) {
                                        ExeScript("GET_LAST");
                                        char *item[1] = {NULL};
                                        item[0] = GetItemMessage(ghobitbl[select]);
                                        MenuDCMsg[6]->SetMsgItemNo(item, 1);
                                        MenuDCMsg[6]->SetMsgVolumeNoOne(got);
                                    } else {
                                        ExeScript("\x83\x4E\x83\x89\x83\x58\x83\x60\x83\x46\x83\x93\x83\x57\x8F\x49\x97\xB9");
                                        action = MOS_SELECT_ACTION_BADGES;
                                    }

                                    step++;
                                } else {
                                    ExeScript("\x83\x4E\x83\x89\x83\x58\x83\x60\x83\x46\x83\x93\x83\x57\x8F\x49\x97\xB9");
                                    action = MOS_SELECT_ACTION_BADGES;
                                }
                            } else if (step == MOS_SELECT_STEP_CLASS_LAST_REWARD) {
                                action = MOS_SELECT_ACTION_BADGES;
                            }

                            break;
                        case MOS_SELECT_STEP_FORM_SELECT: {
                            int cursor = info->AddMsgCursor2(0, select_badge->class_level, 1);
                            view_monster = monster_progress_tbl[select_badge->progress][1 + cursor];

                            switch (buttons) {
                                case MENU_PUSH_BUTTON_DECIDE:
                                    if (GetUserDataMan()->GetActiveChrNo() == USER_CHARA_MONSTER &&
                                        GetUserDataMan()->GetMonsterID() == view_monster) {
                                        MenuSePlay(SYSTEM_SE_CANCEL);
                                    } else {
                                        action = MOS_SELECT_ACTION_TRANSFORM;
                                    }

                                    break;
                                case MENU_PUSH_BUTTON_CANCEL:
                                    action = MOS_SELECT_ACTION_COMMANDS;
                                    break;
                            }

                            break;
                        }
                    }

                    break;
                case MOS_SELECT_PAGE_STATUS: {
                    s16 *row = monster_progress_tbl[select_badge->progress];
                    int  level = -1;

                    for (int j = 0; j < select_badge->class_level + 1; j++) {
                        if (view_monster == row[1 + j]) {
                            level = j;
                            break;
                        }
                    }

                    int move = 0;

                    if ((lr_keys & MENU_SELECT_KEY_R1) || (lr_keys & MENU_SELECT_KEY_R2)) {
                        move = 1;
                    }

                    if ((lr_keys & MENU_SELECT_KEY_L1) || (lr_keys & MENU_SELECT_KEY_L2)) {
                        move = -1;
                    }

                    int old_level = level;
                    level += move;

                    if (level < 0) {
                        level = select_badge->class_level;
                    }

                    if (select_badge->class_level < level) {
                        level = 0;
                    }

                    if (level != old_level) {
                        view_monster = monster_progress_tbl[select_badge->progress][1 + level];
                        show_info = 1;
                        pick_monster = view_monster;
                        load_wait = 0;
                        load_phase = 0;
                        MenuSePlay(SYSTEM_SE_CURSOR);
                    }

                    switch (buttons) {
                        case MENU_PUSH_BUTTON_DECIDE:
                        case MENU_PUSH_BUTTON_TRIANGLE:
                            action = MOS_SELECT_ACTION_REJECT;
                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            action = MOS_SELECT_ACTION_BADGES;
                            break;
                    }

                    break;
                }
            }

            switch (action) {
                case MOS_SELECT_ACTION_REJECT:
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    break;
                case MOS_SELECT_ACTION_BADGES:
                    ExeScript("\x83\x6F\x83\x62\x83\x57\x91\x49\x91\xF0\x82\xC9\x96\xDF\x82\xE9");
                    model_side = 0;
                    key_arg_no = MOS_SELECT_PAGE_BADGE;
                    break;
                case MOS_SELECT_ACTION_COMMANDS: {
                    ExeScript("\x83\x6F\x83\x62\x83\x57\x83\x52\x83\x7D\x83\x93\x83\x68");
                    int command_num = 3;
                    int row;
                    int commands[8] = {MOS_SELECT_CMD_TRANSFORM, MOS_SELECT_CMD_STATUS, MOS_SELECT_CMD_CLASS_CHANGE, -1, -1, -1};
                    row = 0;

                    for (; row < command_num; row++) {
                        if (commands[row] == MOS_SELECT_CMD_TRANSFORM) {
                            if (MenuCommonInfo->now_mode == MENU_MODE_ITEM || GetMenuLoopType() == MENU_LOOP_TOWN) {
                                local_sort1(row, &command_num, commands);
                            } else {
                                if (MenuUserDataManPtr->CheckEnableCharaChange(USER_CHARA_MONSTER, NULL) == 0 && row >= 0 && row < MES_LINE_MAX) {
                                    command->line_color[row] = MES_COLOR_DARK;
                                }

                                if (select_badge != NULL) {
                                    if (select_badge->hp.GetRate() <= 0.0f && row >= 0 && row < MES_LINE_MAX) {
                                        command->line_color[row] = MES_COLOR_DARK;
                                    }

                                    int attr = MenuUserDataManPtr->GetCharaStatusAttirbute(MenuUserDataManPtr->active_chr_no);

                                    if (((attr & CHARA_STATUS_UNK_4) || (attr & CHARA_STATUS_UNK_8) || (attr & CHARA_STATUS_UNK_20)) && row >= 0 && row < MES_LINE_MAX) {
                                        command->line_color[row] = MES_COLOR_DARK;
                                    }
                                }
                            }
                        }

                        if (commands[row] == MOS_SELECT_CMD_CLASS_CHANGE && select_badge != NULL && !select_badge->CheckClassChange()) {
                            local_sort1(row, &command_num, commands);
                        }
                    }

                    command->MakeMsg(command_num);
                    command->SetMsgItemNo(commands, command_num);
                    command->SetMsgCursor(0);
                    MenuMesForm[6]->draw_flag = 0;
                    step = MOS_SELECT_STEP_COMMAND;
                    key_arg_no = MOS_SELECT_PAGE_COMMAND;
                    MenuSePlay(SYSTEM_SE_WINDOW);
                    break;
                }
                case MOS_SELECT_ACTION_CLOSE:
                    mode = MENU_ASK_MODE_CLOSE;
                    result = MOS_SELECT_RESULT_CLOSE;
                    FadeOutMenu(40, 0.0f);
                    MenuSePlay(SYSTEM_SE_CANCEL);
                    break;
                case MOS_SELECT_ACTION_FORM_LIST: {
                    step = MOS_SELECT_STEP_FORM_SELECT;
                    MenuMesForm[6]->draw_flag = 1;
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    info->MsgPreset(MENU_SCRIPT_MES_ITEMCMD);
                    char *names[8] = {NULL};

                    for (int name_index = 0; name_index < select_badge->class_level + 1; name_index++) {
                        names[name_index] = GetMonsterName(monster_progress_tbl[select_badge->progress][1 + name_index]);

                        if (GetUserDataMan()->GetActiveChrNo() == USER_CHARA_MONSTER &&
                            GetUserDataMan()->GetMonsterID() == monster_progress_tbl[select_badge->progress][1 + name_index] &&
                            name_index >= 0 && name_index < MES_LINE_MAX) {
                            info->line_color[name_index] = MES_COLOR_DARK;
                        }
                    }

                    info->SetMsgItemNo(names, select_badge->class_level + 1);
                    info->MakeMsg(select_badge->class_level + 0x32);
                    info->SetMsgCursor(0);
                    break;
                }
                case MOS_SELECT_ACTION_TRANSFORM: {
                    MenuLoadInfo.update_scene = 1;

                    if (MenuLoadInfo.update_scene == 1 && FxScriptMan != NULL) {
                        DeleteMonsterEffect();
                    }

                    GetCharaMemAllocPtr(MenuArg.chara_stack, MorattaStack, USER_CHARA_MONSTER, 0);
                    MenuLoadInfo.mode = 2;
                    MenuLoadInfo.update_scene = 1;
                    MenuMosLoadStack.stReset();
                    result = MOS_SELECT_RESULT_CHANGE;
                    monster->Initialize(NULL);
                    load_wait = 0;
                    load_phase = 0;
                    FadeOutMenu(40, 0.0f);
                    mode = MENU_ASK_MODE_CLOSE;
                    MOS_CHANGE_PARAM *chosen = select_badge;
                    s16               monster_no = monster_progress_tbl[chosen->progress][1 + info->GetMsgCursor()];
                    chosen->monster_id = monster_no;
                    view_monster = monster_no;
                    load_monster = -1;
                    MenuUserDataManPtr->SetActiveChrNo(USER_CHARA_MONSTER);
                    MenuUserDataManPtr->monster_id = monster_no;
                    MenuSePlay(0x10);
                    break;
                }
                case MOS_SELECT_ACTION_CANNOT_TRANSFORM:
                    ExeScript("NOT_\x95\xCF\x89\xBB");
                    step = MOS_SELECT_STEP_ERROR;
                    break;
                case MOS_SELECT_ACTION_STATUS:
                    key_arg_no = MOS_SELECT_PAGE_STATUS;
                    ExeScript("\x83\x58\x83\x65\x81\x5B\x83\x5E\x83\x58\x82\xF0\x8C\xA9\x82\xE9");
                    view_monster = select_badge->monster_id;

                    if (select_badge != NULL) {
                        show_info = 1;
                    }

                    model_side = 1;
                    MenuSePlay(2);
                    break;
                case MOS_SELECT_ACTION_CLASS_CHANGE: {
                    BuildUpWeaponInfo.monster_mode = 1;
                    step = MOS_SELECT_STEP_CLASS_SELECT;
                    int monster_no = monster_progress_tbl[select_badge->progress][1 + select_badge->class_level];
                    level_num = get_monster_tbl_bajjilevel(level_monster, select, monster_no, select_badge->class_level + 1);
                    char *names[8] = {NULL};
                    ExeScript("\x83\x4E\x83\x89\x83\x58\x83\x60\x83\x46\x83\x93\x83\x57"
                              "2");
                    names[0] = "  ";
                    names[1] = GetMonsterName(monster_no);

                    for (int name_index = 0; name_index < level_num; name_index++) {
                        names[2 + name_index] = GetMonsterName(level_monster[name_index]);
                    }

                    info->MakeMsg(level_num + 0x33);
                    info->SetMsgItemNo(names, level_num + 2);
                    info->StepMsg();
                    BuildUpWeaponInfo.select_no = 0;
                    BuildUpWeaponInfo.mode = 1;
                    BuildUpWeaponInfo.select_num = level_num;
                    break;
                }
            }

            break;
        }
    }

    if (pick_monster != view_monster) {
        load_wait = 17;
        load_phase = 0;
        pick_monster = view_monster;
    }

    if (select_badge != NULL) {
        if (select_badge->enable == 1 && select_badge->class_level > 0) {
            if (key_arg_no == MOS_SELECT_PAGE_STATUS) {
                info_win.alpha += 8;

                if (info_win.alpha > 0x80) {
                    info_win.alpha = 0x80;
                }
            } else {
                int alpha = info_win.alpha - 8;

                if (alpha < 0) {
                    alpha = 0;
                }

                info_win.alpha = alpha;
            }
        } else {
            info_win.alpha = 0;
        }
    }

    if (show_info && select_badge != NULL) {
        int values[6] = {0};
        int base = view_monster * 10 + 10000;
        values[1] = select_badge->GetDegreeLevel() + 1 + select * 20;
        values[2] = base + 10;
        values[3] = base + 11;
        values[4] = -1;
        CDC2Mes *desc = MenuDCMsg[7];
        desc->ClsMes::mes_no = -1;
        desc->value_zero = 1;
        desc->value_half = 0;
        desc->value_space = -3;

        if (CheckNowEurope()) {
            desc->value_half = 1;
            desc->value_space = 1;
        }

        desc->SetMsgItemNo(values, 4);
        desc->SetMsgVolumeNoOne(select_badge->level + 1);
        char *name = GetMonsterName(view_monster);

        if (name != NULL) {
            strcpy(desc->name[0], name);
        }

        desc->MakeMsg(0x4B0);
        desc->StepMsg();
        MOS_CHANGE_PARAM *shown = &badge[select];

        if (info_form != NULL) {
            if (shown != NULL) {
                info_form->SetNumber(get_stringtbl[0], GetDispVolumeForFloat(shown->hp.now));
                info_form->SetNumber(get_stringtbl[1], GetDispVolumeForFloat(shown->hp.max));
                float abs_rate = shown->abs.GetRate();
                info_form->SetNumber(get_stringtbl[2], GetDispVolumeForFloat(100.0f * abs_rate));
                info_form->SetNumber(get_stringtbl[3], 100);
                MENUFORMPARTS_TYPE *hp_bar = info_form->GetPartInfo("life");

                if (hp_bar != NULL) {
                    hp_bar->w = 168.0f * shown->hp.GetRate();
                }

                MENUFORMPARTS_TYPE *abs_bar = info_form->GetPartInfo("abs");

                if (abs_bar != NULL) {
                    abs_bar->w = 168.0f * abs_rate;
                }

                info_form->SetNumber("\x8D\x55\x90\x94", shown->GetAttackVol(view_monster));
                info_form->SetNumber("\x96\x68\x90\x94", shown->GetDefenceVol(view_monster));
            } else {
                info_form->SetNumber(get_stringtbl[0], 0);
                info_form->SetNumber(get_stringtbl[2], 0);
                info_form->SetNumber(get_stringtbl[3], 100);
            }
        }
    }

    CheckLoadBGMonster();
    MenuPosData->FormStep();
    CalcTex();
    CalcCursorPosition();
    return 0;
}

int MenuMonsterBoxKey() {
    return MenuMosSelectPtr->KeyStep();
}

void MenuMonsterBoxDraw() {
    /**
     *
     * Monster badge item-number label part names.
     *
     */
    static char *tbl[MOS_SELECT_BADGE_NUM] = {
        "  %d:Beast   %d",
        "  %d:Machine %d",
        "  %d:Aquatic %d",
        "  %d:Plant   %d",
        "  %d:Magical %d",
        "  %d:Devil   %d",
        "  %d:Dragon  %d",
        "  %d:Element %d",
        "  %d:Undead  %d",
        "  %d:Card    %d",
        "  %d:Sun     %d",
        "  %d:Moon    %d",
    };

    MenuPosData->FormDraw();
    mgCTextureManager *tex_manager = &mgTexManager;
    tex_manager->ReloadTexture(MenuMosSelectPtr->mes.texture_block, (sceVif1Packet *) NULL);

    if (MenuMosSelectPtr->mes_show) {
        MenuMosSelectPtr->mes.StepMsg();
        MenuMosSelectPtr->mes.DrawMsg();
    }

    if (MenuMosSelectPtr->info_win_show) {
        MenuMosSelectPtr->info_win.Step();
        MenuMosSelectPtr->info_win.DrawMesWin();
    }

    if (MenuMosSelectPtr->effect_show && MenuMosSelectPtr->effect_frame > 20) {
        tex_manager->ReloadTexture(MenuMosSelectPtr->tex_block[2], (sceVif1Packet *) NULL);
        CActionChara *effect = &MenuMosSelectPtr->effect;
        effect->DrawDirect();
    }

    if (menu_debug_flag) {
        int y = 100;
        DrawMenuFillBox(350.0f, 100.0f, 100.0f, 260.0f, 0x40, 0, 0, 0);
        CMenuFont font;
        char      text[0x40];
        font.SetStr("Ctrl\x81\x46\x81\xaa\x81\xab\nChange\x81\x46\x81\x9b\x81\x7e");
        font.SetPos(350, y);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
        y += 40;
        GetUserDataMan();

        for (int i = 0; i < MOS_SELECT_BADGE_NUM; i++) {
            strcpy(text, tbl[i]);

            if (i == menu_debug_select__2) {
                text[0] = '>';
            }

            MOS_CHANGE_PARAM *badge = &MenuMosSelectPtr->badge[i];

            if (badge != NULL) {
                sprintf(text, text, badge->enable, badge->level + 1);
            }

            font.SetStr(text);
            font.SetPos(354, y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            y += 20;
        }
    }
}

void MenuTimeStepEnvFunc(CScene *scene, CActionChara *chara, int step) {
    mgCFrame *sun;
    mgCFrame *moon;

    if (scene == NULL || chara == NULL) {
        return;
    }

    if (step != kEnvStepSunMoon) {
        return;
    }

    sun = chara->SearchObject("w15a");
    moon = chara->SearchObject("w15b");

    if (sun == NULL || moon == NULL) {
        return;
    }

    if (GetTimeBand(scene->time) != MAP_TIME_BAND_NIGHT) {
        sun->SetAttrParamDraw(1, 0);
        moon->SetAttrParamDraw(0, 0);
    } else {
        sun->SetAttrParamDraw(0, 0);
        moon->SetAttrParamDraw(1, 0);
    }
}

void MenuWeaponRealStepEnvFunc(CActionChara *chara, int step) {
    mgCFrame *object;
    float     rotation[4];

    if (step == 0x58) {
        object = chara->SearchObject("parts01");

        if (object != NULL) {
            object->GetRotation(rotation);
            rotation[1] += 0.13962634f;
            rotation[1] = mgAngleLimit(rotation[1]);
            object->SetRotation(rotation);
        }
    }
}

int MenuItemCharaDataLoad(mgCMemory *stack, int chara_no, MENU_BGREAD_INFO2 **info, int restart_read) {
    /**
     *
     * Character model path category selected by alternate model mode.
     *
     */
    static s8 pathtbl[2] = {4, 5};

    /**
     *
     * Model directories indexed by character background path category.
     *
     */
    static char *menu_load_chrpathtbl[6] = {
        "menu/chara4/",
        "mainchr/",
        "mainchr/",
        "mainchr/",
        "mainchr/",
        "chara/",
    };

    char name[MENU_CHARA_LOAD_MAX][0x40];
    int  i;

    if (restart_read) {
        BreakReadBG();
        StartReadBG();

        for (i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
            if (info[i] != NULL) {
                info[i]->reading = 0;
            }
        }
    }

    if (chara_no < 0 || chara_no > 1) {
        chara_no = 0;
    }

    stack->Align64();
    s8 path_kind[MENU_CHARA_LOAD_MAX] = {0, 2, 1, 1, 2, 2, 3};

    for (u32 slot = 0; slot < MENU_CHARA_LOAD_MAX; slot++) {
        name[slot][0] = 0;
    }

    MenuLoadInfo.chara_no = chara_no;
    strcpy(name[0], menu_chara_chrtbl[chara_no]);
    strcpy(name[1], GetItemFileName(MenuLoadItemNo[4], 1));

    switch (MenuLoadInfo.mode) {
        case 0:
        case 3:
            if (MenuLoadInfo.mode == 3) {
                strcpy(name[0], "c01b_think.chr");
            }

            for (i = 0; i < 4; i++) {
                if (MenuLoadItemNo[i] > 0) {
                    strcpy(name[i + 2], GetItemFileName(MenuLoadItemNo[i], 1));
                } else if (MenuActionChara[i + 1] != NULL) {
                    MenuActionChara[i + 1]->ResetParent();
                    MenuActionChara[i + 1]->Initialize(NULL);
                }
            }

            break;
        case 1:
            strcpy(name[0], "c01b_think.chr");

            if (0 < MenuLoadItemNo[2]) {
                strcpy(name[4], GetItemFileName(MenuLoadItemNo[2], 1));
            }

            if (0 < MenuLoadItemNo[3]) {
                strcpy(name[5], GetItemFileName(MenuLoadItemNo[3], 1));
            }

            break;
        case 2:
            path_kind[0] = pathtbl[MenuLoadInfo.alternate_model];

            if (MenuLoadInfo.alternate_model == 0) {
                path_kind[0] = 4;
                GetMainCharaModelName(chara_no, name[0], 0);
            }

            if (MenuLoadInfo.alternate_model == 1) {
                path_kind[0] = 5;
                GetMainCharaModelName(chara_no, name[0], 1);
            }

            if (MenuLoadInfo.request_phase < 0) {
                name[1][0] = 0;
            }

            if (0 < MenuLoadInfo.request_phase) {
                name[0][0] = 0;

                for (i = 0; i < 4; i++) {
                    if (MenuLoadItemNo[i] > 0) {
                        strcpy(name[i + 2], GetItemFileName(MenuLoadItemNo[i], 1));
                    }
                }

                strcpy(name[6], menu_chara_cfg_chrtbl[chara_no]);

                if (MenuLoadInfo.alternate_model == 1) {
                    name[2][0] = 0;

                    if (chara_no == 0) {
                        name[3][0] = 0;
                    }

                    name[6][0] = 0;
                }
            }

            break;
    }

    int size = 0;
    int total = 0;

    for (i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
        if (info[i] == NULL || name[i][0] == 0) {
            continue;
        }

        if (MenuLoadInfo.load_all == 1 || (MenuLoadInfo.load_all == 0 && i == MenuLoadInfo.load_phase)) {
            strcpy(info[i]->path, menu_load_chrpathtbl[path_kind[i]]);
            info[i]->chara = NULL;
            strcpy(info[i]->name, name[i]);
            strcat(info[i]->path, info[i]->name);
            u_long128 *buffer = stack->stGetTop();
            size = 0;
            info[i]->reading = 0;

            if (LoadFileBG(info[i]->path, buffer, &size)) {
                info[i]->reading = 1;
            }

            stack->Alloc(blocks_for(size));
            stack->Align64();
            total += size;
        }
    }

    return total;
}

/**
 *
 * Loads a character model, skin, or equipped part for the menu preview.
 *
 */
static void MenuItemCharaDataLoadPack(int chara_no, CActionChara *chara, CActionChara *body, int part,
                                      u_int *pack, mgCMemory *stack, int tex_block, int blur_type) {
    mgCTextureManager *tex_manager = &mgTexManager;

    if ((chara != NULL && part != 1) || part == 1) {
        switch (part) {
            case 0:
                if (MenuLoadInfo.mode == 2) {
                    chara->AllDeleteDamage();
                    chara->Initialize(stack);
                    AccumulateEffect.frame = NULL;
                    AccumulateEffect.unk_320 = 0;
                    AccumulateEffect.mode = 0;
                    chara->accume_effect = &AccumulateEffect;
                } else {
                    chara->Initialize(stack);
                }

                chara->LoadPack(pack, menu_infocfgname, stack, stack, stack, tex_block, NULL);
                break;
            case 1:
                tex_manager->DeleteTexAnime(tex_block);
                body->LoadSkin(pack, menu_infocfgname, "", stack, tex_block);
                break;
            case 2:
            case 3:
            case 4:
                if (MenuLoadInfo.mode != 2) {
                    if (part == 3 && body != NULL) {
                        for (int group = body->tex_anime_group_start; group < 24; group++) {
                            tex_manager->DeleteTexAnimeGroup(tex_block, group);
                        }
                    }

                    chara->tex_anime_group_start = 0;
                    chara->DeleteImage();
                }

                chara->Initialize(NULL);

                if (chara_no == 0 && MenuUserParam.chara[0]->equip[0].IsFishingRod()) {
                    chara->LoadPackNoLine(pack, menu_infocfgname, stack, stack, stack, tex_block, body);
                } else {
                    chara->LoadPack(pack, menu_infocfgname, stack, stack, stack, tex_block, body);
                }

                if (body != NULL && part == 2 && stack != NULL && CheckBattleLoop()) {
                    int rest = stack->stGetRest();
                    SwordEffectStack.stSetBuffer(stack->stGetTop(), rest);
                    SetSwordBlurEffect(body, &SwordEffectStack, blur_type);
                }

                break;
            case 5:
                if (chara != NULL && chara != body) {
                    chara->Initialize(NULL);
                }

                body->LoadSkin(pack, menu_infocfgname, "skin3", stack, tex_block);
                break;
        }
    }
}

int MenuItemCharaDataLoadEndCheck(MENU_BGREAD_INFO2 **info, mgCMemory *stack, CActionChara **chara, int chara_no,
                                  int tex_block, int scene_tex_block) {
    int                i;
    mgCTextureManager *tex_manager = &mgTexManager;
    CScene            *scene = MenuMainScene;
    CActionChara      *player = NULL;
    CActionChara      *scene_chara[7] = {NULL, NULL, NULL, NULL, NULL, NULL, NULL};
    CActionChara      *menu_chara[7] = {NULL, NULL, NULL, NULL, NULL, NULL, NULL};

    if (chara != NULL) {
        menu_chara[0] = chara[0];
        menu_chara[1] = NULL;
        menu_chara[2] = chara[1];
        menu_chara[3] = chara[2];
        menu_chara[4] = chara[3];
        menu_chara[5] = chara[4];
        menu_chara[6] = chara[5];
    }

    if (scene != NULL && MenuLoadInfo.update_scene != 0) {
        for (i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
            scene_chara[i] = (CActionChara *) scene->GetCharacter(i);
        }

        player = scene_chara[0];

        if (MenuLoadInfo.mode == 0 || MenuLoadInfo.mode == 1) {
            scene_chara[0] = NULL;
        }

        if (MenuLoadInfo.alternate_model == 1) {
            scene_chara[1] = NULL;

            if (chara_no == 0) {
                scene_chara[2] = NULL;
            }
        }
    }

    CActionChara *scene_target[8] = {NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
    scene_target[0] = scene_chara[0];
    scene_target[1] = player;
    scene_target[2] = scene_chara[1];
    scene_target[3] = scene_chara[2];
    scene_target[4] = scene_chara[3];
    scene_target[5] = scene_chara[4];
    scene_target[6] = scene_chara[5];

    switch (MenuLoadInfo.mode) {
        case 2:
            if (MenuLoadInfo.request_phase <= 0) {
                tex_manager->DeleteBlock(scene_tex_block);
            }

            break;
        default:
            if ((MenuLoadInfo.load_all == 0 && MenuLoadInfo.request_phase < 0 && MenuLoadInfo.load_phase == 0) ||
                MenuLoadInfo.load_all == 1 || MenuLoadInfo.mode == 1) {
                if (0 < tex_block) {
                    tex_manager->DeleteBlock(tex_block);

                    for (int slot = 0; slot < 6; slot++) {
                        if (menu_chara[slot] != NULL) {
                            menu_chara[slot]->Initialize(NULL);
                        }
                    }
                }
            }

            break;
    }

    for (i = 0; i < 6; i++) {
        if (info[i] == NULL || info[i]->reading == 0) {
            continue;
        }

        BG_READ_INFO *read = GetReadBGInfo(info[i]->path);

        if (read == NULL) {
            continue;
        }

        info[i]->chara = menu_chara[i];
        mgCMemory *buffer = &MenuActionCharaBuffer[i];

        if (buffer != NULL) {
            buffer->stReset();
        }

        if (MenuLoadInfo.mode == 2) {
            info[i]->chara = NULL;
        }

        switch (MenuLoadInfo.mode) {
            case 0:
            case 1:
            case 3:
                strcpy(tex_manager->name_suffix, "_menu");
                MenuItemCharaDataLoadPack(chara_no, info[i]->chara, info[0]->chara, i, (u_int *) read->buffer, buffer,
                                          tex_block, -1);
                tex_manager->name_suffix[0] = 0;
                break;
        }

        switch (MenuLoadInfo.mode) {
            case 0:
            case 2:
                if (scene_target[i] != NULL) {
                    mgCMemory *scene_stack = &MorattaStack[i];
                    scene_stack->stReset();
                    MenuItemCharaDataLoadPack(chara_no, scene_target[i], player, i, (u_int *) read->buffer,
                                              scene_stack, scene_tex_block, chara_no);

                    if (i == 0 && scene_target[0] != NULL) {
                        player->SetPosition(menu_old_chara_position);
                    }
                }

                break;
        }

        info[i]->reading = 0;
    }

    if (MenuLoadInfo.load_all == 0) {
        if (MenuLoadInfo.request_phase < 0) {
            MenuLoadInfo.load_phase++;
        } else {
            MenuLoadInfo.load_phase = 7;
        }
    }

    if (MenuLoadInfo.mode == 2) {
        if (MenuLoadInfo.request_phase <= 0) {
            MenuLoadInfo.request_phase = 1;
        } else {
            MenuLoadInfo.request_phase = 2;
        }
    }

    if (info[6] != NULL) {
        BG_READ_INFO *script = GetReadBGInfo(info[6]->path);

        if (script != NULL) {
            if (MenuLoadInfo.mode != 2) {
                info[0]->chara->LoadActionFile((char *) script->buffer, script->size, &MenuActionCharaBuffer[6]);
                info[6]->reading = 0;
            }

            if (MenuLoadInfo.update_scene != 0) {
                MorattaStack[6].stReset();

                if (scene_chara[0] != NULL) {
                    scene_chara[0]->LoadActionFile((char *) script->buffer, script->size, &MorattaStack[6]);
                }
            }

            MenuLoadInfo.load_phase++;
        }
    }

    switch (MenuLoadInfo.load_all) {
        case 0:
            if (MenuLoadInfo.request_phase == -1 && MenuLoadInfo.load_phase < 7) {
                stack->stReset();
                stack->Align64();
                MenuItemCharaDataLoad(stack, chara_no, info, 1);
            }

            break;
        case 1:
            switch (MenuLoadInfo.mode) {
                case 2:
                    if (MenuLoadInfo.request_phase == 1) {
                        stack->stReset();
                        stack->Align64();
                        MenuItemCharaDataLoad(stack, chara_no, info, 1);
                    }

                    if (MenuLoadInfo.request_phase == 2) {
                        MenuItemCharaDataLoadEndCheckAfter(info, chara_no);
                    }

                    break;
            }

            break;
    }

    switch (MenuLoadInfo.mode) {
        case 0:
        case 3:
            if (MenuLoadInfo.load_all == 1 || (MenuLoadInfo.load_all == 0 && MenuLoadInfo.load_phase >= 6)) {
                MenuItemCharaDataLoadEndCheckAfter(info, chara_no);
                MenuLoadInfo.request_phase = -2;
                return 1;
            }

            break;
    }

    return 0;
}

unsigned int MenuCharaSoundLoad(mgCMemory *stack, int chara_no, int background) {
    char         path[0x60];
    int          size;
    unsigned int blocks;
    CharaSndBuffer = NULL;
    MenuSoundCharaNo = chara_no;
    size = 0;
    stack->Align64();
    CharaSndBuffer = (u32 *) (stack->stack + stack->stack_used);

    if (chara_no < 3) {
        GetCharacterSnd(GetUserDataMan(), chara_no, path);
    } else {
        GetMonsterModelFile(GetUserDataMan()->monster_id, 1, path);
    }

    if (background != 0) {
        LoadFileBG(path, (u_long128 *) CharaSndBuffer, &size);
    } else {
        LoadFile2(path, CharaSndBuffer, &size, 0);
    }

    blocks = (size & 0xF) ? ((unsigned int) size >> 4) + 1 : (unsigned int) size >> 4;
    stack->Alloc(blocks);
    return size;
}

void MenuCharaSoundEnter(CScene *scene, CActionChara *chara, int open_port) {

    if (scene != NULL && chara != NULL) {
        chara->sound_info.foot_se_bank = scene->se_base_id;
        chara->sound_info.foot_sound_id = -1;

        if (open_port != 0) {
            sndInitPort(7);
        }

        unsigned int *buffer = (unsigned int *) CharaSndBuffer;

        if (buffer != NULL) {
            int         index;
            signed char chara_ids[USER_CHARA_NUM] = {3, 3, 1, 0};
            index = MenuSoundCharaNo;

            if (index < 0) {
                index = 0;
            }

            chara->sound_info.se_bank =
                sndLoadSound((int) SND_PORT_CHARA, buffer, MorattaStack + chara_ids[index]);
        }

        chara->sound_info.se_bank_2 = scene->se_battle_id;
        chara->SetSoundInfoCopy();
    }
}

unsigned int MenuItemChrLoad(mgCMemory *stack, int item_no, int variant, MENU_BGREAD_INFO2 *info,
                             int restart) {
    unsigned int size;
    unsigned int blocks;

    if (restart != 0) {
        BreakReadBG();
        StartReadBG();
    }

    GetGameDataPt();
    info->reading = 1;
    info->chara = 0;
    strcpy(info->name, GetItemFileName(item_no, 0));

    if (variant == 1) {
        strcat(info->name, "_item.chr");
    }

    strcpy((char *) &info->path, GetItemFilePath(item_no, 1));
    size = 0;
    stack->Align64();

    if (LoadFileBG((char *) &info->path, (stack->stack + stack->stack_used),
                   (int *) &size) == 0) {
        info->reading = 0;
    } else {
        blocks = (size & 0xF) ? (size >> 4) + 1 : size >> 4;
        stack->Alloc(blocks);
        stack->Align64();
    }

    return size;
}

int MenuItemChrLoadEndCheck(MENU_BGREAD_INFO2 *info, CActionChara *chara, mgCMemory *stack,
                            int tex_block) {
    if (info->reading != 0) {
        BG_READ_INFO      *loaded = GetReadBGInfo(info->path);
        mgCTextureManager *tex_manager = &mgTexManager;
        u_int             *model_buffer;
        tex_manager->DeleteBlock(tex_block);
        model_buffer = (u_int *) loaded->buffer;
        stack->stack_used = 0;
        stack->lock = 0;
        info->chara = chara;

        if (chara != NULL) {
            strcpy(tex_manager->name_suffix, "_menu");
            chara->Initialize(NULL);
            chara->LoadPack(model_buffer, menu_infocfgname, stack, stack, stack, tex_block,
                            0);
            tex_manager->name_suffix[0] = 0;
        }

        info->reading = 0;
        return 1;
    }

    return 0;
}

int MenuItemRoboDataLoad(mgCMemory *stack, MENU_BGREAD_INFO2 **info, int restart_read) {
    /**
     *
     * Background loading phase associated with each ridepod part.
     *
     */
    static s8 convItoPhase[6] = {0, 1, 2, 2, 4, 2};

    int i;
    int size;
    int load;

    if (restart_read) {
        BreakReadBG();
        StartReadBG();

        for (i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
            if (info[i] != NULL) {
                info[i]->reading = 0;
            }
        }
    }

    ROBO_INFO_DATA *robo = GetRoboPartsInfo(MenuUserDataManPtr);
    size = 0;
    int total = 0;

    for (i = 0; i < 6; i++) {
        if (info[i] == NULL) {
            continue;
        }

        load = 0;

        if (MenuLoadInfo.mode == 2) {
            load = 1;
        } else if (MenuLoadInfo.load_phase == convItoPhase[i] || MenuLoadInfo.load_all == 1) {
            load = 1;
        }

        if (!load) {
            continue;
        }

        strcpy(info[i]->path, "dungeon/robo/");
        info[i]->chara = NULL;
        info[i]->name[0] = 0;

        if (i == 3) {
            strcpy(info[i]->name, robo->model_name[i]);
            strcat(info[i]->path, info[i]->name);
        } else if (i == 5) {
            strcpy(info[i]->path, robo->hat_file);
            char *slash = strrchr(robo->hat_file, '/');

            if (slash != NULL) {
                strcpy(info[i]->name, slash + 1);
            }
        } else {
            char *file = GetItemFileName(MenuLoadItemNo[i], 1);

            if (file != NULL) {
                strcpy(info[i]->name, file);
            }

            strcat(info[i]->path, info[i]->name);
        }

        size = 0;
        info[i]->reading = 0;

        if (LoadFileBG(info[i]->path, stack->stGetTop(), &size)) {
            info[i]->reading = 1;
            stack->Alloc(blocks_for(size));
            stack->Align64();
            total += size;
        }
    }

    if (MenuLoadInfo.mode == 2 || (MenuLoadInfo.load_all == 0 && MenuLoadInfo.load_phase == 6)) {
        MENU_BGREAD_INFO2 *hat = info[6];
        hat->reading = 1;
        hat->chara = NULL;
        strcpy(hat->name, "robo.stb");
        strcpy(hat->path, "dungeon/act_script/robo.stb");
        LoadFileBG(hat->path, stack->stGetTop(), &size);
        stack->Alloc(blocks_for(size));
        stack->Align64();
        total += size;
    }

    return total;
}

void DeleteOutLineMenu(CActionChara *chara, int alternate) {
    char name[0x20];

    if (chara != NULL) {
        mgCTextureManager *tex_manager = &mgTexManager;
        sprintf(name, "out_line2%d", chara->outline_tex_no);

        if (alternate != 0) {
            strcat(name, "_menu");
        }

        tex_manager->DeleteTexture(name, -1);
    }
}

int MenuItemRoboDataLoadEndCheck(MENU_BGREAD_INFO2 **info, mgCMemory *stack, CActionChara **chara, int tex_block,
                                 int scene_tex_block) {
    CActionChara      *parent = NULL;
    mgCTextureManager *tex_manager = &mgTexManager;
    CScene            *scene = MenuMainScene;
    CActionChara      *scene_chara[6] = {NULL, NULL, NULL, NULL, NULL, NULL};
    int                i;
    mgCMemory         *part_stack;

    if (scene != NULL && MenuLoadInfo.update_scene != 0) {
        for (i = 0; i < 6; i++) {
            scene_chara[i] = (CActionChara *) scene->GetCharacter(i);
        }
    }

    if (MenuLoadInfo.mode == 2) {
        tex_manager->DeleteBlock(scene_tex_block);
    } else if ((MenuLoadInfo.request_phase < 0 && MenuLoadInfo.load_phase == 0) || MenuLoadInfo.load_all == 1) {
        if (0 < tex_block) {
            tex_manager->DeleteBlock(tex_block);

            if (MenuLoadInfo.update_scene != 0) {
                tex_manager->DeleteBlock(scene_tex_block);
            }
        }
    }

    if (MenuLoadInfo.load_all == 0 && MenuLoadInfo.request_phase == 0) {
        if (MenuLoadInfo.update_scene != 0) {
            DeleteOutLineMenu(scene_chara[0], 0);
        }

        if (chara[0] != NULL) {
            DeleteOutLineMenu(chara[0], 1);
        }
    }

    mgCMemory *menu_stack[6] = {&MenuActionCharaBuffer[0], &MenuActionCharaBuffer[1], &MenuActionCharaBuffer[2], &MenuActionCharaBuffer[2], &MenuActionCharaBuffer[3], &MenuActionCharaBuffer[2]};
    mgCMemory *scene_stack[6] = {NULL, NULL, NULL, NULL, NULL, NULL};
    scene_stack[1] = &MorattaStack[1];
    scene_stack[0] = &MorattaStack[0];
    scene_stack[2] = &MorattaStack[2];
    scene_stack[4] = &MorattaStack[3];
    scene_stack[3] = &MorattaStack[2];
    scene_stack[5] = &MorattaStack[2];
    CActionChara *menu_chara[7] = {NULL, NULL, NULL, NULL, NULL, NULL, NULL};
    menu_chara[0] = chara[0];
    menu_chara[1] = chara[1];
    menu_chara[2] = chara[2];
    menu_chara[3] = chara[3];
    menu_chara[4] = chara[4];
    menu_chara[5] = chara[5];

    for (int part = 0; part < 6; part++) {
        if (info[part] == NULL || info[part]->reading == 0) {
            continue;
        }

        BG_READ_INFO *read = GetReadBGInfo(info[part]->path);

        if (read == NULL) {
            continue;
        }

        u_int         *pack = (u_int *) read->buffer;
        CActionChara **slot = &menu_chara[part];
        info[part]->chara = *slot;

        if (MenuLoadInfo.mode == 2) {
            menu_chara[part] = NULL;
        }

        if (MenuLoadInfo.mode != 2) {
            if (part == 2) {
                strcpy(tex_manager->name_suffix, "_menu");

                if (menu_chara[2] != NULL) {
                    menu_chara[2]->DeleteImage();
                }

                if (menu_chara[3] != NULL) {
                    menu_chara[3]->DeleteImage();
                }

                if (menu_chara[5] != NULL) {
                    menu_chara[5]->DeleteImage();
                }

                tex_manager->name_suffix[0] = 0;

                if (MenuLoadInfo.update_scene != 0) {
                    if (scene_chara[2] != NULL) {
                        scene_chara[2]->DeleteImage();
                    }

                    if (scene_chara[3] != NULL) {
                        scene_chara[3]->DeleteImage();
                    }

                    if (scene_chara[5] != NULL) {
                        scene_chara[5]->DeleteImage();
                    }
                }
            } else if (part != 3 && part != 5) {
                CActionChara *model = *slot;

                if (model != NULL) {
                    strcpy(tex_manager->name_suffix, "_menu");
                    model->DeleteImage();
                    tex_manager->name_suffix[0] = 0;
                }

                if (MenuLoadInfo.update_scene != 0 && scene_chara[part] != NULL) {
                    scene_chara[part]->DeleteImage();
                }
            }
        }

        switch (MenuLoadInfo.mode) {
            case 2: {
                if (part > 0) {
                    parent = scene_chara[0];
                }

                part_stack = scene_stack[part];

                if (part != 3 && part != 5 && part_stack != NULL) {
                    part_stack->stReset();
                }

                if (part == 0) {
                    scene_chara[part]->AllDeleteDamage();
                    tex_manager->DeleteTexAnime(tex_block);
                }

                CActionChara *model = scene_chara[part];

                if (model != NULL) {
                    model->Initialize(NULL);
                    model->LoadPack(pack, menu_infocfgname, part_stack, part_stack, part_stack, scene_tex_block, parent);
                }

                if (parent != NULL && CheckBattleLoop() && part == 1) {
                    SetSwordBlurEffect(parent, part_stack, 2);
                }

                break;
            }
            case 0: {
                strcpy(tex_manager->name_suffix, "_menu");
                CActionChara *model = *slot;

                if (model != NULL) {
                    if (part > 0) {
                        parent = menu_chara[0];
                    }

                    if (part == 0) {
                        tex_manager->DeleteTexAnime(tex_block);
                    }

                    part_stack = menu_stack[part];

                    if (part != 3 && part != 5 && part_stack != NULL) {
                        part_stack->stReset();
                    }

                    part_stack->Align64();
                    model->Initialize(NULL);
                    model->LoadPack(pack, menu_infocfgname, part_stack, part_stack, part_stack, tex_block, parent);
                }

                tex_manager->name_suffix[0] = 0;
                CActionChara *scene_model = scene_chara[part];

                if (scene_model != NULL && MenuLoadInfo.update_scene != 0) {
                    if (part > 0) {
                        parent = scene_chara[0];
                    }

                    if (part == 0) {
                        tex_manager->DeleteTexAnime(scene_tex_block);
                    }

                    part_stack = scene_stack[part];

                    if (part != 3 && part != 5 && part_stack != NULL) {
                        part_stack->stReset();
                    }

                    scene_model->Initialize(NULL);
                    scene_model->LoadPack(pack, menu_infocfgname, part_stack, part_stack, part_stack, scene_tex_block,
                                          parent);

                    if (CheckBattleLoop()) {
                        if (part == 0) {
                            SetSwordBlurEffect(scene_chara[0], part_stack, 2);
                        }

                        if (part == 1) {
                            SetSwordBlurEffect(parent, part_stack, 2);
                        }
                    }
                }

                break;
            }
        }

        info[part]->reading = 0;
    }

    if (MenuLoadInfo.load_all == 0) {
        if (MenuLoadInfo.request_phase < 0) {
            if (MenuLoadInfo.load_phase == 2) {
                MenuLoadInfo.load_phase += 2;
            } else if (MenuLoadInfo.load_phase == 4) {
                MenuLoadInfo.load_phase += 2;
            } else {
                MenuLoadInfo.load_phase++;
            }
        } else {
            MenuLoadInfo.load_phase = 7;
        }
    }

    BG_READ_INFO *script = GetReadBGInfo(info[6]->path);

    if (script != NULL) {
        mgCMemory *script_stack = &MorattaStack[4];

        switch (MenuLoadInfo.mode) {
            case 2:
                if (scene_chara[0] != NULL) {
                    script_stack->stReset();
                    scene_chara[0]->LoadActionFile((char *) script->buffer, script->size, script_stack);
                }

                break;
            default:
                if (scene_chara[0] != NULL) {
                    script_stack->stReset();
                    scene_chara[0]->LoadActionFile((char *) script->buffer, script->size, script_stack);
                }

                info[6]->reading = 0;
                break;
        }

        MenuLoadInfo.load_phase++;
    }

    if (MenuLoadInfo.load_all == 0 && MenuLoadInfo.request_phase == -1 && MenuLoadInfo.load_phase < 7) {
        stack->stReset();
        stack->Align64();
        MenuItemRoboDataLoad(stack, info, 1);
    }

    if (MenuLoadInfo.load_all == 1 || (MenuLoadInfo.load_all == 0 && MenuLoadInfo.load_phase > 6)) {
        MenuItemCharaDataLoadEndCheckAfter(info, 2);
        MenuLoadInfo.request_phase = -2;
    }

    return 0;
}

void MenuRoboPartsLightOff(mgCFrame *frame) {
    mgCFrame *part;

    if (frame != NULL) {
        part = frame->SearchFrame("light");

        if (part != NULL) {
            part->attr->draw = 0;
        }
    }
}

int MenuMonsterLoadBG(mgCMemory *stack, MENU_BGREAD_INFO2 **info, int monster_no, int restart_read) {
    char model_buffer[0x40];
    char script_buffer[0x40];
    char path[0x6C];
    int  size;

    if (restart_read) {
        BreakReadBG();
        StartReadBG();
    }

    info[0]->chara = NULL;
    int dir = 0;

    if (MenuLoadInfo.mode == 2) {
        dir = 1;
    }

    if (MenuLoadInfo.mode == 4) {
        dir = 2;
    }

    char *model = model_buffer;
    monster_load_id = monster_no;

    if (GetMonsterModelFile(monster_no, 0, model) == 0) {
        return 0;
    }

    char *script = script_buffer;
    GetMonsterModelFile(monster_no, 2, script);
    strcpy(info[0]->name, model);
    strcpy(path, MonsterDataPath[dir]);
    strcat(path, model);
    strcpy(info[0]->path, path);
    stack->Align64();
    u_long128 *model_data = stack->stGetTop();

    if (LoadFileBG(info[0]->path, model_data, &size) != 0) {
        info[0]->reading = 1;
        stack->Alloc(blocks_for(size));

        if (MenuLoadInfo.mode == 2) {
            stack->Align64();
            u_long128 *buffer = stack->stGetTop();
            strcpy(path, "dungeon/act_script/");
            strcat(path, script);
            strcpy(script_file_name, script);
            LoadFileBG(path, buffer, &size);
            stack->Alloc(blocks_for(size));
        }
    }

    return 1;
}

int MenuMonsterLoadBGCheck(MENU_BGREAD_INFO2 **info, CActionChara **chara, int tex_block,
                           int scene_tex_block) {
    mgCTextureManager *tex_manager = &mgTexManager;
    int                i;

    if (MenuLoadInfo.mode == 2) {
        tex_manager->DeleteBlock(scene_tex_block);
    } else if (0 < tex_block) {
        tex_manager->DeleteBlock(tex_block);
    }

    CScene       *scene = MenuMainScene;
    CActionChara *scene_chara[7] = {NULL, NULL, NULL, NULL, NULL, NULL, NULL};
    char          path[0x80];
    char          name[0x20];

    if (MenuLoadInfo.update_scene != 0 || MenuLoadInfo.mode == 2) {
        for (i = 0; i < 7; i++) {
            scene_chara[i] = (CActionChara *) scene->GetCharacter(i);
        }
    }

    info[0]->reading = 0;
    BG_READ_INFO *model = GetReadBGInfo(info[0]->path);

    if (model == NULL) {
        return 0;
    }

    u_int *pack = (u_int *) model->buffer;
    info[0]->chara = chara[0];
    GetMonsterModelFile(monster_load_id, 3, name);

    if (MenuLoadInfo.mode != 2) {
        mgCMemory *buffer = MenuActionCharaBuffer;
        buffer->stReset();
        strcpy(tex_manager->name_suffix, "_menu");

        if (chara[0] != NULL) {
            chara[0]->Initialize(NULL);
            chara[0]->LoadPackNoLine(pack, name, buffer, buffer, buffer, tex_block, NULL);
        }

        tex_manager->name_suffix[0] = 0;
    } else {
        info[0]->chara = NULL;
        mgCMemory *stack = MorattaStack;
        stack->stReset();

        if (scene_chara[0] != NULL) {
            scene_chara[0]->AllDeleteDamage();
            scene_chara[0]->Initialize(NULL);
            scene_chara[0]->LoadPack(pack, name, stack, stack, stack, scene_tex_block, NULL);
            SetSwordBlurEffect(scene_chara[0], stack, 3);
        }
    }

    GetCurrentDir(path);
    strcat(path, "dungeon/act_script/");
    strcat(path, script_file_name);
    BG_READ_INFO *script = GetReadBGFile(path);

    if (script != NULL) {
        CActionChara *targets[3] = {NULL, NULL, NULL};
        targets[0] = info[0]->chara;
        targets[1] = info[0]->chara;
        targets[2] = scene_chara[0];
        mgCMemory *stacks[3] = {&MenuActionCharaBuffer[5], &MenuActionCharaBuffer[5], NULL};
        stacks[2] = &MorattaStack[5];
        mgCMemory    *stack = stacks[MenuLoadInfo.mode];
        CActionChara *target = targets[MenuLoadInfo.mode];
        stack->stReset();

        if (target != NULL) {
            target->LoadActionFile((char *) script->buffer, script->size, stack);
        }

        info[5]->reading = 0;
        MenuLoadInfo.load_phase++;
    }

    MenuItemCharaDataLoadEndCheckAfter(info, 3);
    MenuLoadInfo.request_phase = -2;
    return 1;
}

#pragma inline_depth(8)

void MenuItemCharaDataLoadEndCheckAfter(MENU_BGREAD_INFO2 **info, int chara_no) {
    /**
     *
     * Scene character slot supplied by each party member loading slot.
     *
     */
    static s8 convtbl[USER_CHARA_NUM][MENU_CHARA_LOAD_MAX] = {
        {0, 2,  3,  4,  5,  6,  -1},
        {0, 2,  3,  4,  5,  6,  -1},
        {0, 1,  2,  3,  4,  5,  -1},
        {0, -1, -1, -1, -1, -1, -1}
    };

    CUserDataManager *user_data = MenuUserDataManPtr;
    ROBO_INFO_DATA   *robo = GetRoboPartsInfo(user_data);

    if (MenuLoadInfo.update_scene != 0) {
        SetupUnitMan(MenuMainScene, user_data, chara_no, robo);
    }

    switch (MenuLoadInfo.mode) {
        case 2:
            return;
    }

    CScene       scene;
    CCharacter2 *chara;

    for (int i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
        chara = NULL;
        int slot = convtbl[chara_no][i];

        if (0 <= slot && info[slot] != NULL) {
            chara = info[slot]->chara;
        }

        scene.DeleteChara(i);
        scene.AssignChara(i, chara, NULL);
    }

    SetupUnitMan(&scene, user_data, chara_no, robo);
}

#pragma inline_depth reset

void InitMainCharaBG(int chara_no, mgCMemory *stack, int mode) {
    int                reason;
    mgCTextureManager *tex_manager;

    if (stack == NULL) {
        return;
    }

    int active_chara = GetUserDataMan()->active_chr_no;
    tex_manager = &mgTexManager;
    NowReadMainCharaNo = chara_no;
    tex_manager->DeleteBlock(MenuCommonInfo->tex_block[0]);
    tex_manager->EnterTexture(MenuCommonInfo->tex_block[0], "mnworkk23456", NULL, 0x80, 0x80, 0x20, NULL, 0, 0);
    NowMainCharaFrameImage = tex_manager->EnterTexture(MenuCommonInfo->tex_block[0], "mnworkk22", NULL,
                                                       mgScreenWidth, mgScreenHeight, 0x18, NULL, 0, 0);
    SetBGFrameForMenu(MenuCommonInfo->tex_block[0], "mnworkk22");
    MenuPosData->AttachCommonTexInfo();
    NowMainCharaChngStatusBit = GetUserDataMan()->CheckQuickChange(NowReadMainCharaNo, &reason);
    NowReadMainCharaPhase = 0;
    NowReadMainChara = NULL;
    MenuCommonInfo->key_enable = 1;

    if ((NowMainCharaChngStatusBit & 2) == 0) {
        MenuDCMsg[0]->MsgPreset(0x12);
        MenuDCMsg[0]->SetAbsPos(8);
        MenuDCMsg[0]->MakeMsg(NowReadMainCharaNo + 0x1A5);
        return;
    }

    GetUserDataMan()->SetActiveChrNo(chara_no);
    mgCMemory memory;
    int       rest = stack->stGetRest();
    memory.stSetBuffer(stack->stGetTop(), rest);
    int wanted[9] = {1, 1, 1, 1, 1, 1, 1, 1, 1};
    MenuBGReadInfo2Malloc(&memory, wanted);
    memory.Alloc(0x100);
    memory.Align64();
    rest = memory.stGetRest();
    MenuCharaLoadStack.stSetBuffer(memory.stGetTop(), rest);
    NowMainCharaChngTex = tex_manager->GetTexture("change_logo", -1);
    NowMainCharaChngTexMovePhase = 0;
    NowMainCharaChngTexMoveX = -0x100;
    MenuMainScene = GetMainScene();
    MorattaStack = MenuArg.base_chara_stack;
    MenuLoadInfo.mode = 2;
    MenuLoadInfo.load_all = 1;
    MenuLoadInfo.alternate_model = mode;
    MenuLoadInfo.chara_no = NowReadMainCharaNo;
    MenuLoadInfo.request_phase = -1;
    MenuLoadInfo.load_phase = 0;
    MenuLoadInfo.target_flags = 0;
    MenuLoadInfo.update_scene = 1;
    NowReadMainChara = (CActionChara *) MenuMainScene->GetCharacter(0);

    if (NowReadMainChara != NULL) {
        NowReadMainChara->GetPosition(NowMainReadPosition);
        NowReadMainChara->GetRotation(NowMainReadRotation);
    }

    MenuUserParam.chara[0] = GetUserDataMan()->GetCharaDataPtr(USER_CHARA_MAX);
    MenuUserParam.chara[1] = GetUserDataMan()->GetCharaDataPtr(USER_CHARA_MONICA);
    MenuUserParam.robo = &GetUserDataMan()->robo_data;

    if ((NowReadMainCharaNo == 1 && active_chara == 3) || NowReadMainCharaNo == 3) {
        DeleteMonsterEffect();
    }

    ReEquipFishingGameWeapon();

    if (mode == 1) {
        GetCharaMemAllocPtr(MenuArg.chara_stack, MorattaStack, NowReadMainCharaNo, 1);
    } else {
        GetCharaMemAllocPtr(MenuArg.chara_stack, MorattaStack, NowReadMainCharaNo, 0);
    }

    SetMenuLoadItemNo(NowReadMainCharaNo);

    switch (NowReadMainCharaNo) {
        case 0:
        case 1:
            if (MenuLoadInfo.alternate_model == 1) {
                EditCharaPrepare();
            }

            MenuLoadInfo.request_phase = -1;
            MenuItemCharaDataLoad(&MenuCharaLoadStack, NowReadMainCharaNo, MenuCharaBuild2, 1);
            break;
        case 2:
            MenuItemRoboDataLoad(&MenuCharaLoadStack, MenuCharaBuild2, 1);
            break;
        case 3:
            NowReadMainCharaMonsterNo = GetUserDataMan()->monster_id;

            if (NowReadMainCharaMonsterNo < 0) {
                CUserDataManager *user_data = GetUserDataMan();
                user_data->monster_id = 0x34;
                NowReadMainCharaMonsterNo = 0x34;
            }

            for (int i = 1; i < 5; i++) {
                CActionChara *chara = (CActionChara *) MenuMainScene->GetCharacter(i);

                if (chara != NULL) {
                    chara->Initialize(NULL);
                }
            }

            MenuMonsterLoadBG(&MenuCharaLoadStack, MenuCharaBuild2, NowReadMainCharaMonsterNo, 1);
            break;
    }
}

int ReadMainCharaBG() {
    char model[0x48];
    int  size;
    int  script_size;

    if (NowReadMainCharaNo < 0) {
        return 0;
    }

    if ((NowMainCharaChngStatusBit & 2) == 0) {
        if (MenuCommonInfo->CheckPushButton()) {
            MenuSePlay(5);
            NowReadMainCharaNo = -1;
            NowMainCharaChngTexMoveX = 600;
            NowMainCharaChngTexMovePhase = 2;
            return 2;
        }

        return 0;
    }

    if (NowReadMainCharaNo == 3 && NowReadMainCharaMonsterNo < 0) {
        return 2;
    }

    if (NowReadMainChara == NULL) {
        return 0;
    }

    ReadBG();

    if (ReadBGSync() != 0) {
        return 1;
    }

    switch (NowReadMainCharaPhase) {
        case 0:
            switch (NowReadMainCharaNo) {
                case 0:
                case 1:
                    MenuItemCharaDataLoadEndCheck(MenuCharaBuild2, &MenuCharaLoadStack, MenuActionChara,
                                                  NowReadMainCharaNo, -1, MenuArg.chara_tex_block);
                    break;
                case 2:
                    break;
                case 3:
                    if (NowReadMainCharaMonsterNo < 0) {
                        return 2;
                    }

                    MenuMonsterLoadBGCheck(MenuCharaBuild2, MenuActionChara, -1, MenuArg.chara_tex_block);
                    MenuCharaLoadStack.stReset();
                    StartReadBG();
                    MonsterEffectRead(&MenuCharaLoadStack, NowReadMainCharaMonsterNo, 1);
                    break;
            }

            NowReadMainCharaPhase++;
            break;
        case 1:
            switch (NowReadMainCharaNo) {
                case 0:
                case 1:
                    MenuItemCharaDataLoadEndCheck(MenuCharaBuild2, &MenuCharaLoadStack, MenuActionChara,
                                                  NowReadMainCharaNo, -1, MenuArg.chara_tex_block);
                    break;
                case 2:
                    MenuItemRoboDataLoadEndCheck(MenuCharaBuild2, &MenuCharaLoadStack, MenuActionChara, -1,
                                                 MenuArg.chara_tex_block);
                    break;
                case 3:
                    MenuCharaLoadStack.Alloc(0x280);
                    MonsterEffectEnter(MenuMainScene,
                                       MenuCharaLoadStack.stack + MenuCharaLoadStack.stack_size - 0x2300, 0xAA);
                    break;
            }

            NowReadMainChara->SetPosition(NowMainReadPosition);
            MenuCharaLoadStack.stReset();
            StartReadBG();

            if (NowReadMainCharaNo < 3) {
                MenuCharaSoundLoad(&MenuCharaLoadStack, NowReadMainCharaNo, 1);
            }

            if (NowReadMainCharaNo == 3 && GetMonsterModelFile(GetUserDataMan()->monster_id, 1, model) == 1) {
                StartReadBG();
                CharaSndBuffer = (u32 *) MenuCharaLoadStack.stGetTop();
                LoadFileBG(model, (u_long128 *) CharaSndBuffer, &size);
                MenuCharaLoadStack.Alloc(blocks_for(size + 0x2800));
            }

            if (MenuLoadInfo.alternate_model == 0 && NowReadMainCharaNo < 3) {
                MenuCharaLoadStack.Align64();
                LoadFileBG("img/allitem.img", MenuCharaLoadStack.stGetTop(), &script_size);
            }

            NowReadMainCharaPhase++;
            break;
        case 2:
            switch (NowReadMainCharaNo) {
                case 0:
                case 1:
                case 2:
                    if (MenuLoadInfo.alternate_model != 1) {
                        mgTexManager.EnterIMGFile((u_char *) GetReadBGFile(1)->buffer, MenuCommonInfo->tex_block[1],
                                                  NULL, NULL);
                        CopyActiveItemAndWeapon(NowReadMainCharaNo, -1);
                        mgTexManager.DeleteBlock(MenuCommonInfo->tex_block[1]);
                    }

                    break;
                case 3:
                    break;
            }

            if (MenuLoadInfo.alternate_model == 0) {
                NowReadMainChara->effect_man = FxScriptMan;
                NowReadMainChara->InitScript();
            }

            NowReadMainChara->SetPosition(NowMainReadPosition);
            NowReadMainChara->SetRotation(NowMainReadRotation);
            MenuCharaSoundEnter(GetMainScene(), NowReadMainChara, 1);
            NowMainCharaChngTexMovePhase = 1;
            MenuArg.end_code = 0x15;
            NowReadMainCharaPhase++;
            break;
        case 3:
            return 2;
    }

    return 1;
}

int KeyMainCharaBG() {
    int read_state;

    read_state = ReadMainCharaBG();

    if (MenuLoadInfo.alternate_model == 1) {
        NowMainCharaChngTexMoveX = NowMainCharaChngTexMoveX + 0x12;
    } else {
        NowMainCharaChngTexMoveX += 0xC;

        if (NowReadMainCharaNo >= 2) {
            NowMainCharaChngTexMoveX += 8;
        }

        if (NowMainCharaChngTexMovePhase > 0) {
            NowMainCharaChngTexMoveX = NowMainCharaChngTexMoveX + 0xC;
        }
    }

    if (NowMainCharaChngTexMoveX > 0x208) {
        NowMainCharaChngTexMoveX = 0x208;
    }

    switch (NowMainCharaChngTexMovePhase) {
        case 0:
            if (NowMainCharaChngTexMoveX > 0x80) {
                NowMainCharaChngTexMoveX = 0x80;
            }

            break;
        default:
            break;
    }

    if (read_state == 2) {
        if (mgScreenWidth <= NowMainCharaChngTexMoveX) {
            NowMainCharaChngTex = NULL;
            NowReadMainCharaNo = -1;
            return 1;
        }
    }

    return 0;
}

void DrawMainCharaBG() {
    mgRect<int> frame_rect;
    mgRect<int> slide_rect;
    int         loaded_tex;

    loaded_tex = -1;

    if (NowMainCharaFrameImage != NULL) {
        MenuReloadTexture(loaded_tex, NowMainCharaFrameImage->block);
        frame_rect.Set(0, 0, 0x200, mgScreenHeight);
        PrimQuad(NowMainCharaFrameImage, 0.0f, 0.0f, frame_rect, 0x80, 0x80, 0x80, 0x80);
    }

    if (!(NowMainCharaChngStatusBit & 2)) {
        MenuReloadTexture(loaded_tex, MenuArg.mes_tex_block);
        MenuDCMsg[0]->StepMsg();
        MenuDCMsg[0]->DrawMsg();
        return;
    }

    if (NowMainCharaChngTex != NULL) {
        MenuReloadTexture(loaded_tex, NowMainCharaChngTex->block);
        slide_rect.Set(0, NowReadMainCharaNo << 6, 0x100, 0x40);
        PrimQuad(NowMainCharaChngTex, (float) NowMainCharaChngTexMoveX, 180.0f, slide_rect, 0x80, 0x80,
                 0x80, 0x80);
    }
}

int MenuNPCModelLoad(mgCMemory *memory, int chara_no, int background) {
    int    size;
    u_int *buffer;
    char  *name;

    MenuNPCLoadFlag = 0;
    memory->Align64();
    name = GetPartyCharaModelName(chara_no, (int) NPC_MODEL_PATH_MENU);
    buffer = reinterpret_cast<u_int *>(memory_free_top(memory));
    MenuPartyNPCModelReadBuffer = buffer;

    if (name == NULL) {
        return 0;
    }

    if (background != 0) {
        LoadFileBG(name, reinterpret_cast<u_long128 *>(buffer), &size);
    } else {
        LoadFile2(name, buffer, &size, 0);
    }

    if (size > 0) {
        MenuNPCLoadFlag = 1;
    }

    memory->Alloc(blocks_for(size));
    return MenuNPCLoadFlag;
}

int MenuNPCLoadCheck(CActionChara *chara, mgCMemory *memory, int tex_block) {
    if (MenuNPCLoadFlag == 1) {
        if (chara != NULL) {

            mgCTextureManager *tex_manager = static_cast<mgCTextureManager *>(&mgTexManager);
            memory->stack_used = 0;
            memory->lock = 0;
            tex_manager->DeleteBlock(tex_block);
            strcpy(tex_manager->name_suffix, "_mn");
            chara->Initialize(NULL);
            chara->LoadPack(MenuPartyNPCModelReadBuffer, menu_infocfgname, memory, memory, memory,
                            tex_block, 0);
            tex_manager->name_suffix[0] = 0;
            MenuNPCLoadFlag = 0;
            return 1;
        }
    }

    return 0;
}

void CMenuCostumeSel::UpdateCostumeList(int mode, unsigned long chara_flag) {
    CHARA_DATA *chara_data;
    int         kind;
    int         index;

    chara_data = GetUserDataMan()->GetCharaDataPtr(USER_CHARA_MAX);

    if (mode == 0) {
        this->costume_num[0] = GetCostumeList(chara_flag, 6, this->costume_list[1]);
        this->costume_num[1] = GetCostumeList(chara_flag, 5, this->costume_list[0]);
        this->costume_num[2] = GetCostumeList(chara_flag, 7, this->costume_list[2]);
    }

    if (mode == 1) {
        chara_data = GetUserDataMan()->GetCharaDataPtr(USER_CHARA_MONICA);
        this->costume_num[0] = GetCostumeList(chara_flag, 9, this->costume_list[1]);
        this->costume_num[1] = GetCostumeList(chara_flag, 8, this->costume_list[0]);
        this->costume_num[2] = GetCostumeList(chara_flag, 10, this->costume_list[2]);
    }

    if (chara_data == NULL) {
        return;
    }

    int worn[COSTUME_LIST_NUM + 1] = {0, 0, 0, -1};
    worn[0] = chara_data->equip[2].item_no;
    worn[1] = chara_data->equip[4].item_no;
    worn[2] = chara_data->equip[3].item_no;

    for (kind = 0; kind < 3; kind++) {
        this->costume_select[kind] = 0;

        for (index = 0; index < this->costume_num[kind]; index++) {
            if (worn[kind] == this->list[kind][index]) {
                this->costume_select[kind] = index;
            }
        }
    }
}

int CosutmeSelDefaultSet(int costume_id, short *costume_list) {
    for (int index = 0; index < 5; index++) {
        if (costume_id == costume_list[index]) {
            return index;
        }
    }

    return 0;
}

#pragma inline_depth(8)

void CMenuCostumeSel::LoadMenuData(mgCMemory *stack, int *tex_block) {
    /**
     *
     * Character slots that require costume menu background read requests.
     *
     */
    static int tbl[MENU_CHARA_LOAD_MAX] = {1, 1, 0, 0, 1, 1, 1};

    int                i;
    mgCTextureManager *tex_manager;
    u8                *buffer;
    unsigned int       size;
    u8                *icons;
    short             *system_mes;
    int                free_size;

    SetTexBlock(tex_block);

    for (i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
        MenuActionChara[i] = new (stack->Alloc(0x105)) CActionChara;
        MenuActionChara[i]->Initialize(NULL);
    }

    tex_manager = &mgTexManager;
    buffer = (u8 *) stack->stGetTop();
    size = LoadFileMenu("fukusel.img", (u_long128 *) buffer, MENU_FILE_LOAD_DIRECT);
    stack->Alloc((int) size / 16 + 0x10);
    stack->Align64();
    mgTexManager.EnterIMGFile(buffer, *tex_block, NULL, NULL);
    this->tile_tex = mgTexManager.GetTexture("fukusen", -1);
    icons = GetMenuMainIMGPtr();

    if (icons != NULL) {
        tex_manager->EnterIMGFile(icons, *tex_block, NULL, NULL);
    }

    this->cursor_tex = tex_manager->GetTexture("mnmain", -1);
    this->cursor_x = 0.0f;
    this->cursor_y = 0.0f;
    this->cursor_wave = 0.0f;
    this->cursor_wave_y = 0.0f;
    AttachMessageForm();
    system_mes = GetSystemMesBuffer();
    MenuDCMsg[0]->SetMessData(system_mes, GetMenuMainMessageBuffer());
    MenuDCMsg[0]->MsgPreset(0xA);
    MenuDCMsg[0]->SetAbsPos(8);
    system_mes = GetSystemMesBuffer();
    MenuDCMsg[7]->SetMessData(system_mes, GetMenuMainMessageBuffer());
    MenuDCMsg[7]->MsgPreset(0xB);
    MenuDCMsg[7]->SetAbsPos(8);
    MenuDrawEnv->speed = 2.0f;
    MenuBGReadInfo2Malloc(stack, tbl);
    MenuLoadInfo.mode = 3;
    MenuLoadInfo.alternate_model = 1;
    MenuLoadInfo.load_all = 1;
    MenuLoadInfo.load_phase = 0;
    MenuLoadInfo.request_phase = -1;
    MenuLoadInfo.chara_no = USER_CHARA_MAX;
    MenuLoadInfo.update_scene = 0;
    MenuLoadInfo.target_flags = 1;
    free_size = stack->stGetRest();
    this->stack.stSetBuffer(stack->stGetTop(), free_size);
    MenuMemoryAdjust(&this->stack, &MenuCharaLoadStack, MenuActionCharaBuffer, USER_CHARA_MAX);
    SetMenuLoadItemNo(0);
    MenuItemCharaDataLoad(&MenuCharaLoadStack, USER_CHARA_MAX, MenuCharaBuild2, 1);

    do {
    } while (ReadBGSync() == 0);

    this->load_wait = 0;
    MenuCosutumeLoadPhase = 2;
}

#pragma inline_depth reset

int CMenuCostumeSel::KeyStep() {
    /**
     *
     * Background load phase associated with each costume list.
     *
     */
    static s8 phasetbl[COSTUME_LIST_NUM] = {4, 1, 5};

    CActionChara *model = MenuActionChara[0];
    CDC2Mes      *ask = MenuDCMsg[7];
    sceVu0FVECTOR pos;
    int           fade_end = FadeCheckMenu();

    switch (mode) {
        case 1:
            if (fade_end && load_wait > 15 && MenuCosutumeLoadPhase >= 4) {
                MenuCommonInfo->key_enable = 1;
                mode = 0;
                step = -1;
                loading = 1;
                MenuDCMsg[0]->MakeMsg(0x11F9);
            }

            break;
        case 2:
            if (fade_end) {
                if (MenuArg.end_code == 12) {
                    MenuArg.result[0] = costume_list[1][costume_select[0]];
                    MenuArg.result[1] = costume_list[0][costume_select[1]];
                    MenuArg.result[2] = costume_list[2][costume_select[2]];

                    if (change_chara) {
                        GetUserDataMan()->SetChrEquipDirect(1, 0x7F);
                        GetUserDataMan()->SetChrEquipDirect(1, 0x85);
                        GetUserDataMan()->SetChrEquipDirect(1, 0x10A);
                    }
                }

                return 1;
            }

            break;
        case 0: {
            int keys = MenuCommonInfo->CheckSelectKey();
            int buttons = MenuCommonInfo->CheckPushButton();

            switch (step) {
                case -1:
                case 2:
                    if (buttons) {
                        loading = 0;
                        show_help = 1;
                        step++;
                        cursor_show = 1;
                        MenuSePlay(1);
                    }

                    break;
                case 0:
                case 3: {
                    int move_y = 0;
                    int move_x = 0;

                    if (keys & MENU_SELECT_KEY_UP) {
                        move_y--;
                    }

                    if (keys & MENU_SELECT_KEY_DOWN) {
                        move_y++;
                    }

                    if (keys & MENU_SELECT_KEY_LEFT) {
                        move_x--;
                    }

                    if (keys & MENU_SELECT_KEY_RIGHT) {
                        move_x++;
                    }

                    float turn = 0.0f;
                    float zoom = turn;

                    if (MenuCosutumeLoadPhase == 4) {
                        turn = GamePad__2.GetRXf();
                        zoom = -GamePad__2.GetRYf();
                    }

                    if (MenuCosutumeLoadPhase < 3) {
                        move_x = 0;
                    }

                    model->GetPosition(pos);
                    float shift = 0.1f * zoom;
                    float z = 0.9f * zoom;
                    z = pos[2] + z;

                    if (!(z < 4.0f) && !(21.0f < z)) {
                        pos[2] = z;
                        pos[0] -= shift;
                    }

                    chara_pos[0] = pos[0];
                    chara_pos[2] = pos[2];
                    model->SetPosition(pos);
                    AddRotationCharaY(model, 0.05f * turn);

                    if (move_y) {
                        select += move_y;

                        if (chara == 0) {
                            if (select < 0) {
                                select = 3;
                            }

                            if (select > 3) {
                                select = 0;
                            }
                        }

                        if (chara == 1) {
                            if (select < 0) {
                                select = 4;
                            }

                            if (select > 4) {
                                select = 0;
                            }
                        }
                    }

                    if (move_x) {
                        if (select < 3) {
                            costume_select[select] += move_x;

                            if (costume_select[select] < 0) {
                                costume_select[select] = costume_num[select] - 1;

                                if (costume_select[select] < 0) {
                                    costume_select[select] = 0;
                                }
                            }

                            if (costume_select[select] >= costume_num[select]) {
                                costume_select[select] = 0;
                            }

                            GetUserDataMan()->SetChrEquipDirect(chara, list[select][costume_select[select]]);
                            MenuCosutumeLoadPhase = 1;
                            MenuLoadInfo.load_phase = phasetbl[select];
                        } else {
                            move_x = 0;
                        }
                    }

                    if (move_y || move_x) {
                        MenuSePlay(0);
                    }

                    for (int i = 0; i < COSTUME_LIST_NUM; i++) {
                        line_wave[i] += 0.07853982f;

                        if (i != select) {
                            line_wave[i] = 0.0f;
                        }
                    }

                    if (buttons & MENU_PUSH_BUTTON_CANCEL) {
                        wait_load = 0;
                        mode = 2;
                        MenuArg.end_code = 0;
                        MenuCommonInfo->key_enable = 0;
                        FadeOutMenu(40, 0.0f);
                        MenuSePlay(5);
                    } else if (buttons & MENU_PUSH_BUTTON_DECIDE) {
                        if (select == 3) {
                            step++;
                            wait_load = 1;
                            cursor_show = 0;
                            ask->ClsMes::mes_no = -1;

                            if (chara == 0) {
                                ask->MakeMsg(0x11F8);
                            } else if (chara == 1) {
                                ask->MakeMsg(0x11FB);
                            }

                            ask->SetMsgCursor(1);
                            MenuSePlay(1);
                        }

                        if (select == 4) {
                            step++;
                            wait_load = 1;
                            cursor_show = 0;
                            ask->ClsMes::mes_no = -1;
                            ask->MakeMsg(0x11FD);
                            ask->SetMsgCursor(1);
                            MenuSePlay(1);
                        }
                    }

                    break;
                }
                case 1:
                case 4:
                case 5: {
                    int answer = ask->YesNoCursor2(0);

                    if (answer == 1) {
                        if (select == 4) {
                            GetUserDataMan()->GetCharaDataPtr(USER_CHARA_MONICA)->keep_costume_on_equip_change = 0;
                            change_chara = 1;
                            wait_load = 0;
                            mode = 2;
                            MenuArg.end_code = 12;
                            MenuCommonInfo->key_enable = 0;
                            FadeOutMenu(40, 0.0f);
                            MenuSePlay(1);
                            break;
                        }

                        if (monica_enabled == 1 && chara == 0) {
                            chara = 1;
                            MenuLoadInfo.chara_no = 1;
                            chara_data = GetUserDataMan()->GetCharaDataPtr(USER_CHARA_MONICA);
                            chara_data->keep_costume_on_equip_change = 1;
                            UpdateCostumeList(1, CostumeAttr);
                            costume_select[0] = CosutmeSelDefaultSet(0x7F, costume_list[1]);
                            costume_select[1] = CosutmeSelDefaultSet(0x10A, costume_list[0]);
                            costume_select[2] = CosutmeSelDefaultSet(0x85, costume_list[2]);
                            MenuLoadInfo.mode = 0;
                            MenuLoadInfo.load_all = 1;
                            MenuLoadInfo.load_phase = 0;
                            MenuLoadInfo.request_phase = -1;
                            loading = 1;
                            wait_load = 0;
                            MenuCosutumeLoadPhase = 1;
                            step = 2;
                            MenuDCMsg[0]->MakeMsg(0x11FC);
                        } else {
                            wait_load = 0;
                            mode = 2;
                            MenuArg.end_code = 12;
                            MenuCommonInfo->key_enable = 0;
                            FadeOutMenu(40, 0.0f);
                            MenuSePlay(1);
                        }
                    }

                    if (answer == 2) {
                        step = 0;
                        wait_load = 0;
                        cursor_show = 1;
                        MenuSePlay(5);
                    }

                    break;
                }
            }

            break;
        }
    }

    camera.Step(1);

    switch (MenuCosutumeLoadPhase) {
        case 0:
            break;
        case 1:
            model->GetRotation(costume_rotation);
            MenuCharaLoadStack.stReset();
            SetMenuLoadItemNo(chara);
            MenuItemCharaDataLoad(&MenuCharaLoadStack, chara, MenuCharaBuild2, 1);
            MenuCosutumeLoadPhase++;
            break;
        case 2:
            if (ReadBGSync() == 0) {
                MenuItemCharaDataLoadEndCheck(MenuCharaBuild2, &MenuCharaLoadStack, MenuActionChara, chara,
                                              tex_block[3], -1);
                MenuItemCharaDataLoadEndCheckAfter(MenuCharaBuild2, chara);
                MenuLoadInfo.load_all = 0;
                model->SetPosition(chara_pos);
                model->SetRotation(costume_rotation);
                model->Step();
                MenuCosutumeLoadPhase++;
                load_wait = 0;
            }

            break;
        case 3:
            load_wait++;
            model->Step();

            if (load_wait > 15) {
                MenuCosutumeLoadPhase++;
                model->Show(1, 1);
            }

            break;
        case 4:
            model->Step();
            break;
    }

    tile_scroll += 0.5f;

    if (0.0f <= tile_scroll) {
        tile_scroll = -256.0f;
    }

    return 0;
}

void CMenuCostumeSel::Draw() {
    /**
     *
     * Red, green, blue and alpha of the costume menu background tiles.
     *
     */
    static u8 tilergba[4] = {108, 108, 108, 128};

    /**
     *
     * Equipment slot displayed by each costume list.
     *
     */
    static s8 convtbl[COSTUME_LIST_NUM] = {2, 4, 3};

    /**
     *
     * Help panel width of the costume menu for each supported language.
     *
     */
    static float putw[LANG_CHINESE + 1] = {246.0f, 206.0f, 270.0f, 234.0f, 236.0f, 246.0f, 256.0f};

    /**
     *
     * Localized costume selection help text.
     *
     */
    static char *infomsg[LANG_CHINESE + 1] = {
        " ",
        "(R)L/R:Turn (R)U/D:Zoom",
        "(R)G/D: tourner (R)H/B: avancer",
        "(R)L/R: drehen (R)O/U: bew.",
        "(R)S/D: gira (R)S/G: sposta",
        "(R)I/D: girar (R)A/AB: zoom",
        "(R)L/R:Turn (R)U/D:Zoom",
    };

    sceVu0FMATRIX view;
    sceVu0FVECTOR eye;

    if (tile_tex == NULL) {
        return;
    }

    camera.GetCameraMatrix(view);
    camera.GetPos(eye);
    mgSetViewMatrix(view, eye);
    mgCTextureManager *tex_manager = &mgTexManager;
    tex_manager->ReloadTexture(tile_tex->block, (sceVif1Packet *) NULL);
    mgCDrawPrim *prim = GetMenuPrim();
    DrawMenuTilePattern(prim, tile_tex, tile_scroll, tile_scroll, mgRect<int>(0x100, 0, 0x100, 0x100), 0,
                        tilergba);
    PrimQuad(prim, tile_tex, 24.0f, 24.0f, mgRect<int>(0, 0xEA, 0xC8, 0x16), 0x80, 0x80, 0x80, 0x80);

    if (MenuCosutumeLoadPhase == 4) {
        tex_manager->ReloadTexture(tex_block[3], (sceVif1Packet *) NULL);
        MenuActionChara[0]->DrawDirect();
    }

    tex_manager->ReloadTexture(tile_tex->block, (sceVif1Packet *) NULL);
    mgRect<int> line_rect(0, 0, 0xB0, 0x20);
    mgRect<int> label_rect(0, 0xB6, 0x38, 0x1A);
    mgRect<int> chara_rect(0, 0xD0, 0x78, 0x1A);
    mgRect<int> left_rect(0, 0x20, 0x10, 0x16);
    mgRect<int> right_rect(0x10, 0x20, 0x10, 0x16);
    int         i;
    int         cursor_y_pos = select * 0x42 + 0x6E;
    int         y = 0x50;
    SetSpriteEnv(prim, 0);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(tile_tex);

    for (i = 0; i < COSTUME_LIST_NUM; i++) {
        int line_y = y + 0x1E;
        prim->Color(0, 0, 0, 0x30);
        PrimQuad(prim, 50.0f, (float) (y + 4), label_rect);
        PrimQuad(prim, 74.0f, (float) (line_y + 4), line_rect);
        float wave = 6.0f * sinf(line_wave[i]);
        wave = wave < 0.0f ? -wave : wave;
        float left_x;
        float right_x;
        float arrow_y;
        right_x = wave + (float) (line_rect.right + 0x49);
        left_x = 55.0f - wave;
        arrow_y = (float) (line_y + 3);
        PrimQuad(prim, 4.0f + left_x, 4.0f + arrow_y, left_rect);
        PrimQuad(prim, 4.0f + right_x, 4.0f + arrow_y, right_rect);

        if (i == select) {
            prim->Color(0xA4, 0xA4, 0xA4, 0x80);
        } else {
            prim->Color(0x80, 0x80, 0x80, 0x80);
        }

        PrimQuad(prim, 46.0f, (float) y, label_rect);
        PrimQuad(prim, 70.0f, (float) line_y, line_rect);
        PrimQuad(prim, left_x, arrow_y, left_rect);
        PrimQuad(prim, right_x, arrow_y, right_rect);
        label_rect.left += label_rect.right;
        y += 0x42;
    }

    int chara_y = y + 0xA;
    int exit_y = chara_y + 0x28;

    if (mode == MENU_ASK_MODE_NONE && (step == 0 || step == 3)) {
        prim->Color(0, 0, 0, 0x30);
        PrimQuad(prim, 116.0f, (float) (chara_y + 4), chara_rect);

        if (select == 3) {
            prim->Color(0xA4, 0xA4, 0xA4, 0x80);
        } else {
            prim->Color(0x80, 0x80, 0x80, 0x80);
        }

        PrimQuad(prim, 112.0f, (float) chara_y, chara_rect);

        if (chara == USER_CHARA_MONICA) {
            mgRect<int> exit_rect(0, 0x9C, 0xAA, 0x1A);
            prim->Color(0, 0, 0, 0x30);
            PrimQuad(prim, 78.0f, (float) (exit_y + 4), exit_rect);

            if (select == 4) {
                prim->Color(0xA4, 0xA4, 0xA4, 0x80);
            } else {
                prim->Color(0x80, 0x80, 0x80, 0x80);
            }

            PrimQuad(prim, 74.0f, (float) exit_y, exit_rect);
        }
    }

    prim->End();
    float cursor_x_pos = 0.0f;

    if (select == 3) {
        cursor_x_pos = 70.0f;
        cursor_y_pos = chara_y;
    }

    if (select == 4) {
        cursor_x_pos = 32.0f;
        cursor_y_pos = exit_y;
    }

    CalcMenu1(cursor_x_pos, &cursor_x, 4.0f, 0.0f, 0);
    CalcMenu1((float) cursor_y_pos, &cursor_y, 4.0f, 0.0f, 0);

    if (cursor_tex != NULL && cursor_show) {
        float cursor_pos[2];
        cursor_pos[0] = cursor_x + 6.0f * cosf(cursor_wave);
        cursor_pos[1] = cursor_y + 4.0f * sinf(cursor_wave_y);
        MenuCursorDraw(cursor_tex, cursor_pos, 0.0f, 0, 0x80, 1.0f);
        cursor_wave += 0.05235988f;
        cursor_wave_y += 0.10471976f;

        if (!(cursor_wave < 3.1415927f)) {
            cursor_wave -= 6.2831855f;
        }

        if (!(cursor_wave_y < 3.1415927f)) {
            cursor_wave_y -= 6.2831855f;
        }
    }

    tex_manager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
    int name_y = 0x72;

    if (chara_data != NULL) {
        CMenuFont font;

        for (i = 0; i < COSTUME_LIST_NUM; i++) {
            char *name = chara_data->equip[convtbl[i]].GetName(1);

            if (name != NULL) {
                font.SetStr(name);
                font.SetPos(0x4E, name_y);
                font.DrawDirect(font.str, font.pos_x, font.pos_y);
            }

            name_y += 0x42;
        }
    }

    if (loading) {
        MenuDCMsg[0]->StepMsg();
        MenuDCMsg[0]->DrawMsg();
    }

    if (wait_load) {
        MenuDCMsg[7]->StepMsg();
        MenuDCMsg[7]->DrawMsg();
    }

    if (show_help && !loading && !wait_load) {
        DrawMenuFillBox(36.0f, (float) mgScreenHeight - 40.0f - 8.0f, putw[LanguageCode], 32.0f, 0x40, 0, 0,
                        0);
        CMenuFont help;
        help.DrawDirect(infomsg[LanguageCode], 0x28, mgScreenHeight - 0x28);
    }
}

inline CMenuCostumeSel::CMenuCostumeSel() : camera(40.0f, 30.0f, 0.0f, 8.0f) {
    select = 0;
    MenuCosutumeLoadPhase = 0;
    tile_scroll = 0.0f;
    chara_data = GetUserDataMan()->GetCharaDataPtr(USER_CHARA_MAX);
    costume_select[0] = 0;
    costume_select[1] = 0;
    costume_select[2] = 0;
    line_wave[0] = 0.0f;
    line_wave[1] = 0.0f;
    line_wave[2] = 0.0f;
    load_wait = 0;
    loading = 0;
    wait_load = 0;
    show_help = 0;
    cursor_show = 0;
    chara = 0;
    monica_enabled = 0;
    tile_tex = NULL;
    cursor_tex = NULL;
    chara_pos[0] = 15.0f;
    chara_pos[1] = -14.0f;
    chara_pos[2] = 4.0f;
    chara_pos[3] = 1.0f;
    costume_rotation[0] = 0.0f;
    costume_rotation[1] = 0.1f;
    costume_rotation[2] = 0.0f;
    costume_rotation[3] = 1.0f;

    for (int i = 0; i < COSTUME_LIST_MAX; i++) {
        costume_list[0][i] = 0;
        costume_list[1][i] = 0;
        costume_list[2][i] = 0;
    }

    list[0] = costume_list[1];
    list[1] = costume_list[0];
    list[2] = costume_list[2];
    unk_220 = 0;
    unk_280 = 0;
    change_chara = 0;
    camera.SetDistance(100.0f);
    camera.SetAngle(0.0f);
    camera.SetHeight(3.0f);
    camera.SetSpeed(4.0f, -1.0f);
    camera.SetFollow(0.0f, 0.0f, 0.0f);
    camera.Step(-1);
}

void MenuCostumeInit(mgCMemory *stack, int *tex_block, int mode) {
    int rest = stack->stGetRest();
    MenuChangeMemory.stSetBuffer(stack->stGetTop(), rest);
    MenuCosPtr = new (MenuChangeMemory.Alloc(0x2F)) CMenuCostumeSel;
    CostumeAttr = 0x1274521CBULL;

    if (MenuArg.param[0] == 1) {
        MenuCosPtr->monica_enabled = 1;
        CostumeAttr |= CostumeOptionEnv;
    }

    MenuCosPtr->UpdateCostumeList(0, CostumeAttr);
    MenuCosPtr->LoadMenuData(&MenuChangeMemory, tex_block);
    MenuCosPtr->FadeInMenu(0x28, 0.0f);
    MenuArg.end_code = 0;
    MenuArg.result[0] = 0;
    MenuArg.result[1] = 0;
    MenuArg.result[2] = 0;
    MenuCamInit(1.0f);
}

int MenuCostumeKey() {
    return MenuCosPtr->KeyStep();
}

void MenuCostumeDraw() {
    MenuCosPtr->Draw();
}

BASE_MONSTER_TBL *GetMonsterBaseInfoForMonsterMemoIndex(int memo_index) {
    BASE_MONSTER_TBL *monster;
    int               i;

    monster = GetMonsterBaseInfo(0);

    for (i = 0; i < 0x14A; i++) {
        if (monster->memo_index == memo_index) {
            return monster;
        }

        monster++;
    }

    return NULL;
}

void CMosBookMenu::InitMonsterInfo() {
    area_name[0] = 0;
    name[0] = 0;
    type_name[0] = 0;
    hp = 0;
    abs = 0;
    kill_num = 0;
    strong_bit = 0;
    weak_bit = 0;
    drop_item[0][0] = 0;
    drop_item[1][0] = 0;
    drop_item[2][0] = 0;
    weak_name[0] = 0;
}

void CMosBookMenu::SetMonsterInfo(BASE_MONSTER_TBL *monster) {
    /**
     *
     * Resistance and weakness display bits of each monster property.
     *
     */
    static u32 stand_bit[14] = {1, 4, 16, 8, 2, 32, 64, 64, 64, 64, 0, 0, 0, 0};

    char  *area;
    char **type_names;
    char  *message;
    int    i;
    int    item_count;
    int    j;
    int    k;
    int    weak_count;
    int    n;

    this->InitMonsterInfo();

    if (monster != NULL) {
        strcpy(this->name, monster->name);
        area = NULL;

        if (0 <= monster->area_no) {
            area = GetMapTitle(GetDngMapNo(monster->area_no));
        }

        char local_area_names[2][32] = {"Rainbow Butterfly Wd.", "Bois Pap. arc-en-ciel"};

        if (LanguageCode == 1) {
            if (monster->area_no == 1) {
                area = local_area_names[0];
            }
        }

        if (LanguageCode == 2 && monster->area_no == 1) {
            area = local_area_names[1];
        }

        if (area != NULL) {
            strcpy(this->area_name, area);
        }

        type_names = monster_type_name[LanguageCode];

        if (type_names[0] != NULL) {
            strcpy(this->type_name, type_names[monster->user_mons_id]);
        }

        this->hp = monster->reward_exp;
        this->abs = monster->reward_money;
        this->kill_num = KillMonsterCount(monster->id, 0);
        item_count = 0;

        for (i = 0; i < 3; i++) {
            if (0 < monster->drop_items[i]) {
                message = GetItemMessage(monster->drop_items[i]);

                if (message != NULL) {
                    strcpy(this->drop_item[item_count], message);
                    item_count++;
                }
            }
        }

        for (j = 0; j < 12; j++) {
            if (monster->ext_param[j] >= 101) {
                this->strong_bit = this->strong_bit | stand_bit[j];
            }

            if (monster->ext_param[j] < 51) {
                this->weak_bit = this->weak_bit | stand_bit[j];
            }
        }

        weak_count = 0;
        int weak_list[8] = {0, 0, 0, 0, 0, 0, 0, 0};

        for (k = 0; k < 8; k++) {
            if (monster->element_resist[k] >= 50) {
                weak_list[weak_count] = k;
                weak_count++;
            }
        }

        if (weak_count > 0) {
            if (monster_jyakuten[LanguageCode][0] != NULL) {
                strcpy(this->weak_name, monster_jyakuten[LanguageCode][weak_list[0]]);

                for (n = 1; n < weak_count; n++) {
                    strcat(this->weak_name, monster_jyakuten[LanguageCode][weak_list[n]]);
                }
            }
        }
    }
}

void CMosBookMenu::InitEnd() {
    u8               *buffer;
    unsigned int      size;
    int               free_size;
    int               i;
    BASE_MONSTER_TBL *entry;

    buffer = memory_free_top(&MosBookStack);
    size = LoadFileMenu("memomos.pac", (u_long128 *) buffer, 1);
    MosBookStack.Alloc(blocks_for(size));
    mgTexManager.EnterIMGFile((u8 *) GetPackFile((unsigned int *) buffer, "out.img", NULL),
                              this->tex_block[0], NULL, NULL);
    Tex_MBase = mgTexManager.GetTexture("mosbox", -1);
    Tex_MBook = mgTexManager.GetTexture("memomos", -1);
    Tex_MBg = mgTexManager.GetTexture("mosbg", -1);
    this->tex_block_no = this->tex_block[4];
    mgCMemory scratch;
    free_size = memory_free_size(&MosBookStack);
    scratch.stSetBuffer((u_long128 *) memory_free_top(&MosBookStack), free_size);
    MenuMemoryAdjust(&scratch, &this->stack, MenuActionCharaBuffer, 3);
    this->list_num = 0;

    for (i = 0; i < kMonsterMemoCount; i++) {
        entry = GetMonsterBaseInfoForMonsterMemoIndex(i);

        if (entry != NULL && 0 < KillMonsterCount(entry->id, 0)) {
            this->list[this->list_num] = entry->id;
            this->list_num++;
        }
    }

    for (i = this->list_num; i < kMonsterMemoCount; i++) {
        this->list[i] = -1;
    }

    this->monster_info = GetMonsterBaseInfo(this->list[this->select]);
    this->SetMonsterInfo(this->monster_info);
    FadeInMenu(0x32, 0.0f);
}

void CMosBookMenu::Draw() {
    /**
     *
     * Texture rectangles of the three monster-book background strips.
     *
     */
    static short tiletbl[3][12] = {
        {0x77, 0xBD, 0x26, 0x24, 0x9C, 0xBD, 0x4, 0x24, 0xA1, 0xBD, 0x26, 0x24},
        {0x77, 0xE1, 0x26, 0xC,  0x9C, 0xE1, 0x4, 0xC,  0xA1, 0xE1, 0x26, 0xC },
        {0x77, 0xED, 0x26, 0x24, 0x9C, 0xED, 0x4, 0x24, 0xA1, 0xED, 0x26, 0x24}
    };

    /**
     *
     * Texture rectangles of the monster-book description underboards.
     *
     */
    static short under_brdtbl[12] = {0x93, 0x2D, 0xA, 0x20, 0x9D, 0x2D, 0x2, 0x20, 0xA1, 0x2D, 0xA, 0x20};

    /**
     *
     * Positions of the monster-book headings and description panels.
     *
     */
    static short put_under_offset[16][2] = {
        {0xFE,  0xE  },
        {0xFE,  0x1E },
        {0xFE,  0x40 },
        {0xFE,  0x50 },
        {0xFE,  0x72 },
        {0xFE,  0x82 },
        {0xFE,  0xA4 },
        {0xFE,  0xB4 },
        {0xFE,  0xD6 },
        {0xFE,  0xE6 },
        {0x20,  0x104},
        {0x20,  0x116},
        {0x20,  0x13C},
        {0x20,  0x168},
        {0x104, 0x118},
        {0x0,   0x0  }
    };

    /**
     *
     * Texture coordinates of the monster book resistance and weakness icons.
     *
     */
    static short ic[][2] = {
        {0xA8, 0x0 },
        {0xBE, 0x0 },
        {0xD4, 0x0 },
        {0xEA, 0x0 },
        {0xBE, 0x16},
        {0xD4, 0x16},
        {0xEA, 0x16}
    };

    /**
     *
     * Texture rectangles of the monster-book vertical divider.
     *
     */
    static short line[12] = {0x0, 0x16, 0xC, 0x14, 0x0, 0x2A, 0xC, 0x4, 0x0, 0x2E, 0xC, 0x14};

    /**
     *
     * Texture rectangles of the three monster-model frame strips.
     *
     */
    static short wakutbl[3][12] = {
        {0x1E, 0xA5, 0x32, 0x36, 0x50, 0xA5, 0x2, 0x36, 0x54, 0xA5, 0x22, 0x36},
        {0x1E, 0xDA, 0x32, 0x4,  0x50, 0xDA, 0x2, 0x4,  0x54, 0xDA, 0x22, 0x4 },
        {0x1E, 0xDF, 0x32, 0x32, 0x50, 0xDF, 0x2, 0x32, 0x54, 0xDF, 0x22, 0x32}
    };

    if (Tex_MBg == NULL || Tex_MBook == NULL || Tex_MBase == NULL) {
        return;
    }

    mgCTextureManager *tex_manager = &mgTexManager;
    tex_manager->ReloadTexture(Tex_MBase->block, (sceVif1Packet *) NULL);
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    DrawMenuTilePattern(prim, Tex_MBg, bg_scroll, bg_scroll,
                        mgRect<int>(0, 0, 0x100, 0x100), 0, NULL);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(Tex_MBase);
    prim->Color(0, 0, 0, 0x40);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x1A, 0x4B, 0x1CC, 0x24), tiletbl[0], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x1A, 0x6F, 0x1CC, 0x116), tiletbl[1], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x1A, 0x185, 0x1CC, 0x24), tiletbl[2], 1);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x16, 0x47, 0x1CC, 0x24), tiletbl[0], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x16, 0x6B, 0x1CC, 0x116), tiletbl[1], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x16, 0x181, 0x1CC, 0x24), tiletbl[2], 1);
    prim->End();
    int model_width = 0xB6;

    if (CheckNowEurope()) {
        model_width = 0xBE;
    }

    DrawMenuFillBox(52.0f, 101.0f, (float) model_width, 220.0f, 0x80, 0xD, 0xD, 0xD);
    SetSpriteEnv(prim, 0);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(Tex_MBase);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset[1][0] + 0x16, put_under_offset[1][1] + 0x47, 0x52, 0x20), under_brdtbl, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset[1][0] + 0x6E, put_under_offset[1][1] + 0x47, 0x52, 0x20), under_brdtbl, 1);
    int box_shift = 0;
    int box_width = 0xB0;
    int last_shift = 0;
    int last_width = 0xB0;

    if (CheckNowEurope()) {
        box_shift = 2;
        box_width = 0xB6;
        last_shift = 4;
        last_width = 0xBE;
    }

    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset[3][0] + 0x16 - box_shift, put_under_offset[3][1] + 0x47, box_width, 0x20), under_brdtbl, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset[5][0] + 0x16 - box_shift, put_under_offset[5][1] + 0x47, box_width, 0x20), under_brdtbl, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset[7][0] + 0x16 - box_shift, put_under_offset[7][1] + 0x47, box_width, 0x20), under_brdtbl, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset[9][0] + 0x16 - box_shift, put_under_offset[9][1] + 0x47, box_width, 0x20), under_brdtbl, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset[9][0] + 0x16 - box_shift, put_under_offset[9][1] + 0x69, box_width, 0x20), under_brdtbl, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset[9][0] + 0x16 - box_shift, put_under_offset[9][1] + 0x8B, box_width, 0x20), under_brdtbl, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset[11][0] + 0x16 - last_shift, put_under_offset[11][1] + 0x47, last_width, 0x20), under_brdtbl, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x140, 0x27, 0x9C, 0x20), under_brdtbl, 1);
    prim->End();
    prim->Begin(MG_PRIM_SPRITE);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    prim->Texture(Tex_MBook);
    PrimQuad(prim, 18.0f, 16.0f, mgRect<int>(0, 0, 0xA8, 0x16));
    int base_x = put_under_offset[0][0] + 0x16;
    int base_y = put_under_offset[0][1] + 0x47;
    PrimQuad(prim, (float) base_x, (float) (put_under_offset[0][1] + 0x47), mgRect<int>(0, 0x82, 0xB0, 0x12));
    PrimQuad(prim, (float) (base_x + 0xB), (float) (base_y + 0x19), mgRect<int>(0xC, 0x2C, 0xC, 0x10));
    PrimQuad(prim, (float) (base_x + 0x5E), (float) (base_y + 0x15), mgRect<int>(0xC, 0x16, 0x14, 0x16));
    PrimQuad(prim, (float) (put_under_offset[2][0] + 0x16),
             (float) (put_under_offset[2][1] + 0x47), mgRect<int>(0, 0x94, 0xB0, 0x12));
    PrimQuad(prim, (float) (put_under_offset[4][0] + 0x16),
             (float) (put_under_offset[4][1] + 0x47), mgRect<int>(0, 0xA6, 0xB0, 0x12));
    PrimQuad(prim, (float) (put_under_offset[6][0] + 0x16),
             (float) (put_under_offset[6][1] + 0x47), mgRect<int>(0, 0xB8, 0xB0, 0x12));
    PrimQuad(prim, (float) (put_under_offset[8][0] + 0x16),
             (float) (put_under_offset[8][1] + 0x47), mgRect<int>(0, 0xCA, 0xB0, 0x12));
    PrimQuad(prim, (float) (put_under_offset[10][0] + 0x16),
             (float) (put_under_offset[10][1] + 0x47), mgRect<int>(0, 0xDC, 0xB0, 0x12));
    PrimQuad(prim, (float) (put_under_offset[12][0] + 0x16),
             (float) (put_under_offset[12][1] + 0x47), mgRect<int>(0, 0xEE, 0xB0, 0x12));
    int icon_x = put_under_offset[4][0] + 0x1D;
    int strong_y = put_under_offset[4][1] + 0x5C;

    for (int i = 0; i < MOS_BOOK_AFFINITY_NUM; i++) {
        if (strong_bit & (1 << i)) {
            PrimQuad(prim, (float) icon_x, (float) strong_y,
                     mgRect<int>(ic[i][0], ic[i][1], 0x16, 0x16));
            icon_x += 0x16;
        }
    }

    int weak_i = 0;
    icon_x = put_under_offset[4][0] + 0x1D;
    int weak_y = put_under_offset[4][1] + 0x8E;

    for (; weak_i < MOS_BOOK_AFFINITY_NUM; weak_i++) {
        if (weak_bit & (1 << weak_i)) {
            PrimQuad(prim, (float) icon_x, (float) weak_y,
                     mgRect<int>(ic[weak_i][0], ic[weak_i][1], 0x16, 0x16));
            icon_x += 0x16;
        }
    }

    Menu3DivideTextureDraw(prim, mgRect<int>(0xFB, 0x55, 0xC, 0x13C), line, 0);
    prim->End();
    sceVu0FMATRIX view;
    sceVu0FVECTOR eye;
    camera.GetCameraMatrix(view);
    camera.GetPos(eye);
    mgSetViewMatrix(view, eye);

    if (monster != NULL && load_phase == 4 && show_wait > 0x10) {
        mgRect<int> scissor(0x20, 0x69, 0xE8, 0x135);
        SetMenuScissor(scissor);
        tex_manager->ReloadTexture(tex_block_no, (sceVif1Packet *) NULL);
        monster->DrawDirect();
        ResetMenuScissor();
    }

    tex_manager->ReloadTexture(Tex_MBase->block, (sceVif1Packet *) NULL);
    int frame_width = 0xD6;

    if (CheckNowEurope()) {
        frame_width = 0xDA;
    }

    SetSpriteEnv(prim, 0);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(Tex_MBase);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x20, 0x55, frame_width, 0x36), wakutbl[0], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x20, 0x8B, frame_width, 0x92), wakutbl[1], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x20, 0x11D, frame_width, 0x32), wakutbl[2], 1);
    prim->End();
    mgRect<int> digit_rect(0, 0x14A, 0xC, 0xD);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(Tex_MBase);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    PrimDrawNumber(prim, hp, (int) MENU_NUMBER_ALIGN_RIGHT, 0x156, 0x6D, digit_rect, -1, 0);
    PrimDrawNumber(prim, abs, (int) MENU_NUMBER_ALIGN_RIGHT, 0x1AE, 0x6D, digit_rect, -1, 0);
    PrimDrawNumber(prim, kill_num, (int) MENU_NUMBER_ALIGN_RIGHT, 0xEC, 0x185, digit_rect, -2, 0);
    prim->End();
    tex_manager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
    CMenuFont font;
    int       name_height, name_width;
    font.SetStr(name);
    font.CalcDrawWH(font.str, &name_width, &name_height);
    int name_x = 0x92 - name_width / 2;
    font.SetStr(name);
    font.SetPos(name_x, 0x6D);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
    font.SetStr(type_name);
    font.SetStr(type_name);
    font.SetPos(0x4E, 0x123);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
    int area_height, area_width;
    font.SetStr(area_name);
    font.CalcDrawWH(font.str, &area_width, &area_height);
    int area_x = 0x92 - area_width / 2;
    font.SetStr(area_name);
    font.SetPos(area_x, 0x163);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
    font.SetStr(weak_name);
    font.SetStr(weak_name);
    font.SetPos(0x11E, 0x9D);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
    font.SetStr(drop_item[0]);
    font.SetPos(0x11A, 0x131);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
    font.SetStr(drop_item[1]);
    font.SetPos(0x11A, 0x153);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
    font.SetStr(drop_item[2]);
    font.SetPos(0x11A, 0x175);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
    char position[0x80];
    int  number = select + 1;

    if (list_num <= 0) {
        number = 0;
    }

    sprintf(position, monstere_file_template[LanguageCode], number, list_num);
    font.SetStr(position);
    font.SetPos(0x14C, 0x2D);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
}

#pragma inline_depth(8)

int CMosBookMenu::KeyStep() {
    int select;
    int lr;
    int push;
    int fade;
    int cmd;
    int i;

    select = MenuCommonInfo->CheckSelectKey();
    lr = MenuCommonInfo->CheckLRKey();
    push = MenuCommonInfo->CheckPushButton();
    fade = FadeCheckMenu();
    cmd = -1;

    switch (this->mode) {
        case MENU_ASK_MODE_OPEN:
            if (fade != 0) {
                this->mode = MENU_ASK_MODE_NONE;
                MenuCommonInfo->key_enable = 1;
                this->load_phase = 1;
            }

            break;
        case MENU_ASK_MODE_CLOSE:
            if (fade != 0) {
                DeleteTexBlock();

                if (MonsterBookBootMode == 1) {
                    return 2;
                }

                return 1;
            }

            break;
        case MENU_ASK_MODE_NONE:
            if ((lr & MENU_SELECT_KEY_L1) || (lr & MENU_SELECT_KEY_R1) ||
                (select & MENU_SELECT_KEY_LEFT) || (select & MENU_SELECT_KEY_RIGHT)) {
                cmd = kCmdTurnPage;

                if (select & MENU_SELECT_KEY_LEFT) {
                    this->select -= 1;
                }

                if (select & MENU_SELECT_KEY_RIGHT) {
                    this->select += 1;
                }

                if ((lr & MENU_SELECT_KEY_L2) || (lr & MENU_SELECT_KEY_L1)) {
                    this->select -= 10;
                }

                if ((lr & MENU_SELECT_KEY_R2) || (lr & MENU_SELECT_KEY_R1)) {
                    this->select += 10;
                }

                if (this->select < 0) {
                    this->select = this->list_num - 1;
                }

                if (this->list_num <= this->select) {
                    this->select = 0;
                }

                if (this->select < 0) {
                    this->select = 0;
                }

                this->monster_info = GetMonsterBaseInfo(this->list[this->select]);
                this->SetMonsterInfo(this->monster_info);
            } else if (push & MENU_PUSH_BUTTON_CANCEL) {
                cmd = kCmdClose;
                MenuSePlay(SYSTEM_SE_CANCEL);
            } else if (menu_debug_flag != 0) {
                if (push & MENU_PUSH_BUTTON_TRIANGLE) {
                    for (i = 0; i < kMonsterMemoCount; i++) {
                        if (i != 0x30 && i != 0x44) {
                            KillMonsterCount(i, 1);
                        }
                    }

                    MenuSePlay(SYSTEM_SE_DECIDE);
                }
            }

            break;
    }

    if (0 <= cmd) {
        switch (cmd) {
            case kCmdClose:
                this->mode = MENU_ASK_MODE_CLOSE;
                FadeOutMenu(0x3C, 0.0f);
                break;
            case kCmdTurnPage:
                this->load_phase = 1;
                break;
        }
    }

    switch (this->load_phase) {
        case 0:
            break;
        case 1:
            this->load_wait = 0;
            this->load_phase += 1;

            break;
        case 2:
            this->load_wait += 1;

            if (this->load_wait >= kModelDelayFrames) {
                StartReadBG();

                this->stack.stack_used = 0;
                this->stack.lock = 0;
                MenuMonsterLoadBG(&this->stack, MenuCharaBuild2, this->list[this->select], 1);
                this->monster = NULL;
                this->load_phase += 1;

                if (MenuCharaBuild2[0]->reading == 0) {
                    this->load_phase = 0;
                }
            }

            break;
        case 3:
            if (ReadBGSync() == 0) {
                this->load_phase += 1;
                this->show_wait = 0;
                this->monster = new (this->stack.Alloc(0x105)) CActionChara;
                this->monster->Initialize(NULL);
                MenuMonsterLoadBGCheck(MenuCharaBuild2, &this->monster, this->tex_block_no, -1);
                this->monster->SetPosition(-12.8f, -6.6f, 0.0f);
                this->monster->SetMotion("\x97\xA7\x82\xBF", 0, 1);
                MonsterScaleCheck(this->monster);
            }

            break;
        case 4:
            this->skip_draw ^= 1;

            if (this->skip_draw != 0) {
                this->monster->Step();
            }

            this->show_wait += 1;

            if (this->show_wait > kModelFrameCap) {
                this->show_wait = kModelFrameCap;
            }

            break;
    }

    this->bg_scroll += 0.5f;

    if (0.0f <= this->bg_scroll) {
        this->bg_scroll -= 256.0f;
    }

    return 0;
}

#pragma inline_depth reset

void MonsterBookInit(mgCMemory *stack, int *tex_block, int mode) {
    /**
     *
     * Character slots that require monster book background read requests.
     *
     */
    static int tbl[MENU_CHARA_LOAD_MAX] = {1, 1, 1, 1, 1, 1, 1};

    CMosBookMenu *book;
    int           size;

    size = stack->stGetRest();
    MosBookStack.stSetBuffer(stack->stGetTop(), size);

    book = new (MosBookStack.Alloc(0x9A)) CMosBookMenu;

    MenuMosBookPtr = book;
    book->SetTexBlock(tex_block);
    MonsterBookPtr = (u8 *) &GetSaveData()->monster_book;
    MonsterBookBootMode = mode;
    MenuBGReadInfo2Malloc(&MosBookStack, tbl);
    MenuLoadInfo.mode = 4;
    MenuLoadInfo.load_all = 1;
    MenuLoadInfo.update_scene = 0;
    MenuLoadInfo.alternate_model = 0;
    MenuLoadInfo.request_phase = -1;
    MenuLoadInfo.load_phase = 0;
    MosBookStack.Align64();
    (MenuMosBookPtr)->InitEnd();
}

int MonsterBookKey() {
    return MenuMosBookPtr->KeyStep();
}

void MonsterBookDraw() {
    MenuMosBookPtr->Draw();

    if (menu_debug_flag) {
        DrawMenuFillBox(float(20.0), 40.0f, 200.0f, float(24.0), 0x40, 0, 0, 0);
        CMenuFont font;
        font.SetStr("(A):All Monster Beaten");
        font.SetPos(20, 40);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
    }
}

// Initialised data (.data)
s16 monster_progress_tbl[MONSTER_PROGRESS_NUM][1 + MONSTER_PROGRESS_LEVEL_NUM] = {
    {0, 0,   1,   2,   3  },
    {0, 0,   1,   22,  23 },
    {0, 0,   136, 137, 139},
    {1, 220, 221, 222, 223},
    {3, 52,  53,  54,  55 },
    {3, 52,  53,  102, 103},
    {2, 8,   9,   10,  11 },
    {2, 8,   9,   150, 151},
    {7, 44,  45,  46,  47 },
    {9, 224, 236, 228, 232},
    {8, 176, 177, 180, 183},
    {8, 176, 177, 186, 187},
    {5, 72,  73,  74,  75 },
    {5, 72,  73,  154, 155},
    {4, 24,  25,  26,  27 },
    {4, 24,  25,  166, 167},
    {6, 124, 116, 120, 112},
    {6, 124, 116, 120, 128},
    {9, 224, 236, 228, 240},
};

// Constants (.rodata)

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", __vt__15CMenuChrCngMenu__DATA);

// Small uninitialised data (.sbss)
mgCMemory *MorattaStack;

MENU_LOAD_INFO MenuLoadInfo;

mgCTexture *MenuCharaChangeBase_Tex;

mgCTexture *MenuCharaChangeCLUT_Tex;

mgCTexture *MenuCharaChangeStar_Tex;

u32 *CharaSndBuffer;

// Uninitialised data (.bss)
MENU_BGREAD_INFO2 *MenuCharaBuild2[MENU_CHARA_LOAD_MAX];

CActionChara *MenuActionChara[MENU_CHARA_LOAD_MAX];

mgCMemory MenuActionCharaBuffer[MENU_CHARA_LOAD_MAX];
s16       MenuLoadItemNo[MENU_LOAD_ITEM_MAX];

mgCMemory MenuChangeMemory;
mgCMemory MenuChangeNpcMemory;
mgCMemory ChrChangeInitTextureStack;
mgCMemory MenuMonChangeLoadStack;
mgCMemory MenuMosBuildStack;
mgCMemory MenuMosLoadStack;
mgCMemory SwordEffectStack;
mgCMemory MosBookStack;
