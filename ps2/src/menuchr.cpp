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
#include "userdata.hpp"

extern int MenuCharaChangePosDataCfgBuffer;

inline CMenuChrCngMenu::CMenuChrCngMenu() {
    change_phase = (int) CHR_CNG_PHASE_NONE;
    change_chara = -1;
    change_ready = 0;
    MenuCharaChangePosDataCfgBuffer = 0;
    unk_118 = 0;
    select = 0;
    last_select = 0;
    star_fade = 0;
    enable_change = 0;
    party_member = 0;
    item_brd_select = 0;
    item_brd_pos = 0;
    open_wait = -1;
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
 * Views four worn costume IDs as one quadword.
 *
 */
union WornCostumes {
    int       id[4]; /**< IDs of the four worn costumes. */
    u_long128 qw;    /**< Combined 128-bit representation. */
};

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

const int kMonsterMemoCount = 0x119;
const int kModelDelayFrames = 20;
const int kModelFrameCap = 20;

enum {
    kBookBrowsing = 0,
    kBookFadingIn = 1,
    kBookFadingOut = 2
};

enum {
    kCmdClose = 0xA,
    kCmdTurnPage = 0x64
};

enum {
    kEnvStepSunMoon = 0x38
};

extern short       tbl_992[];
extern signed char MenuNPCLoadFlag;
extern int         mos_effect_read_num;
void               SetupUnitMan(CScene *scene, CUserDataManager *user_data, int unit, ROBO_INFO_DATA *robo);
void               GetBajjiPosition(CMenuPosDataForm *form, int slot, int unused, int *pos);

/**
 *
 * Stores a 64-byte block of monster book data.
 *
 */
struct MonsterBookBlock64 {
    u_long128 q[4]; /**< Four quadwords of monster book data. */
};

/**
 *
 * Stores a 32-byte block of monster book data.
 *
 */
struct MonsterBookBlock32 {
    u_long128 q[2]; /**< Two quadwords of monster book data. */
};

/**
 *
 * Groups the seven memory stacks used by the character menu.
 *
 */
struct MemoryList {
    mgCMemory *entry[7]; /**< Memory stack for each character slot. */
};

/**
 *
 * Groups character instances used by the character menu.
 *
 */
struct SceneCharaList {
    CActionChara *entry[7]; /**< Character in each scene slot. */
};

/**
 *
 * Lists the three character targets for loading.
 *
 */
struct LoadTargetList {
    CActionChara *entry[3]; /**< Character target in each load slot. */
};

/**
 *
 * Lists the three memory stacks used while loading characters.
 *
 */
struct LoadStackList {
    mgCMemory *entry[3]; /**< Memory stack in each load slot. */
};

/**
 *
 * Stores the path category for each character load.
 *
 */
struct CharaPathKinds {
    s8 kind[MENU_CHARA_LOAD_MAX]; /**< Path category for each load slot. */
};

/**
 *
 * Tracks the character data requested for loading.
 *
 */
struct LoadWantedList {
    int entry[9]; /**< Requested load entry for each slot. */
};

/**
 *
 * Stores the centre of a menu ring.
 *
 */
struct RingCenter {
    float x; /**< Horizontal centre coordinate. */
    float y; /**< Vertical centre coordinate. */
};

/**
 *
 * Stores texture coordinates for a quadrilateral.
 *
 */
struct QuadTexCoords {
    float uv[4][2]; /**< Texture coordinates of its four corners. */
};

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
 * Lists eight character targets for loading.
 *
 */
struct LoadTargetList8 {
    CActionChara *entry[8]; /**< Character target in each load slot. */
};

/**
 *
 * Groups the six robot-part character instances.
 *
 */
struct RoboCharaList {
    CActionChara *entry[6]; /**< Character instance for each robot part. */
};

/**
 *
 * Groups the six memory stacks for robot parts.
 *
 */
struct RoboStackList {
    mgCMemory *entry[6]; /**< Memory stack for each robot part. */
};

/**
 *
 * Holds one line of character-menu debug text.
 *
 */
struct DebugLine {
    char text[0x80]; /**< Debug text line. */
};

/**
 *
 * Holds a character-menu debug text block.
 *
 */
struct DebugText {
    char text[0x200]; /**< Debug text block. */
};

/**
 *
 * Holds debug text for a non-player character.
 *
 */
struct DebugNpcText {
    char text[0x100]; /**< Non-player character debug text. */
};

/**
 *
 * Holds a monster name used by the menu.
 *
 */
struct MonsterNameList {
    char *name[1]; /**< Name of the monster. */
};

/**
 *
 * Stores message numbers for menu commands.
 *
 */
struct MenuCommandList {
    int mes[8]; /**< Message number for each command. */
};

/**
 *
 * Stores names shown in the monster menu.
 *
 */
struct MonsterNameTable {
    char *name[8]; /**< Monster name in each table slot. */
};

/**
 *
 * Stores values displayed for badge information.
 *
 */
struct BadgeInfoValues {
    int value[6]; /**< Badge information values. */
};

/**
 *
 * Pairs two integer menu values.
 *
 */
struct SmallPair {
    int v[2]; /**< The two values in the pair. */
};

/**
 *
 * Holds a file name used while loading menu assets.
 *
 */
struct FileNameBuf {
    char text[0x40]; /**< Menu asset file name. */
};

/**
 *
 * Pairs two names used by the character menu.
 *
 */
struct NamePair {
    char *a; /**< First name in the pair. */
    char *b; /**< Second name in the pair. */
};

extern char               at_2940[];
extern char               at_2941[];
extern char               at_2942[];
extern char               at_2943[];
extern char               at_2944[];
extern MOS_HENGE_PARAM   *mos_effect_henge_param;
extern u8                *mos_effect_readbuff1[4];
extern int                mos_effect_readbuff1_size[4];
extern u8                *mos_effect_readbuff2[4];
extern int                mos_effect_readbuff2_size[4];
extern int                max_3170;
extern int                viewnum_3171;
extern int                overcode_3172[4];
extern CMenuMosSelect    *MenuMosSelectPtr;
extern char               at_3779[];
extern char               at_3780[];
extern char               at_3790[];
extern int                MenuSoundCharaNo;
extern float              at_4158;
extern char               at_4186__2[];
extern char               at_4123[];
extern char               at_4296[];
extern u8                 at_4517__2[];
extern mgCTexture        *NowMainCharaChngTex;
extern mgCTexture        *NowMainCharaFrameImage;
extern short              NowMainCharaChngStatusBit;
extern int                NowMainCharaChngTexMovePhase;
extern int                NowMainCharaChngTexMoveX;
extern short              NowReadMainCharaNo;
extern u_int             *MenuPartyNPCModelReadBuffer;
extern short              MenuCosutumeLoadPhase;
extern mgCMemory          MenuChangeMemory;
extern unsigned long      CostumeAttr;
extern CMenuCostumeSel   *MenuCosPtr;
extern mgCMemory          MosBookStack;
extern CMosBookMenu      *MenuMosBookPtr;
extern u8                *MonsterBookPtr;
extern short              MonsterBookBootMode;
extern mgCTexture        *Tex_MBase;
extern mgCTexture        *Tex_MBook;
extern mgCTexture        *Tex_MBg;
extern u32                stand_bit_5472[];
extern char              *monster_type_name[][12];
extern char              *monster_jyakuten[][8];
extern char               at_4950__2[];
extern char               menu_infocfgname[];
extern u8                 at_4967__2[16];
extern char               at_5051[];
extern char               at_5052[];
extern char               at_5053[];
extern int                tbl_5016[];
extern u8                 at_5452[64];
extern u8                 at_5482[32];
extern char               at_5558__2[];
extern char               at_5559__2[];
extern char               at_3271[];
extern char               at_5560__2[];
extern char               at_5561[];
extern char               at_5839[];
extern char               at_5893[];
extern int                tbl_5848[];
extern CDC2Mes           *MenuDCMsg[9];
extern MemoryList         at_1083__2;
extern char               at_1104__4[];
extern char               at_1131__3[];
extern char               at_1132__5[];
extern char               at_1133__4[];
extern char               at_1134__3[];
extern char               at_1135__3[];
extern char               at_1319[11];
extern char               at_1361[];
extern char               at_2287[];
extern char               at_3969[];
extern s8                 convtbl_4621[][MENU_CHARA_LOAD_MAX];
extern SceneCharaList     at_3054__2;
extern mgCMemory          MenuMonChangeLoadStack;
extern MENU_BGREAD_INFO2 *MenuMonsterBGInfo[8];
extern CharaPathKinds     at_3810;
extern s8                 pathtbl_3836[2];
extern char              *menu_chara_chrtbl[2];
extern char              *menu_chara_cfg_chrtbl[2];
extern char              *menu_load_chrpathtbl_3811[];
extern char               at_3913[];
extern LoadWantedList     at_4728__2;
extern char               at_4789[];
extern char               at_4790[];
extern char               at_4791[];
extern short              NowReadMainCharaPhase;
extern CActionChara      *NowReadMainChara;
extern short              NowReadMainCharaMonsterNo;
extern sceVu0FVECTOR      NowMainReadPosition;
extern sceVu0FVECTOR      NowMainReadRotation;
extern char               at_4868[];
extern RingCenter         at_2371__4;
extern QuadTexCoords      at_2372__4;
extern char               at_1276__3[];
extern char               at_1277__3[];
extern char               at_1278__3[];
extern char               at_1279__4[];
extern char               at_1280__3[];
extern char               at_1281__5[];
extern char               at_1282__5[];
extern char               at_1283__4[];
extern char               at_1284__4[];
extern char               at_1285__2[];
extern char              *tbl_1233[4];
extern u32               *MenuCharaChangeCLUT;
extern int                tbl_3186[MENU_CHARA_LOAD_MAX];
extern sceVu0FVECTOR      posdef_3194;
extern sceVu0FVECTOR      refdef_3195;
extern char              *tbl_3196[];
extern char               at_3269[];
extern char               at_3270[];
extern char               at_3272[];
extern char               at_3273[];
extern char               at_3274[];
extern char               at_3275[];
extern char               at_3276[];
extern mgCTexture        *MenuMosTexture;
extern mgCMemory          MenuMosLoadStack;
extern SceneCharaList     at_3974;
extern SceneCharaList     at_3975;
extern LoadTargetList8    at_3993;
extern sceVu0FVECTOR      menu_old_chara_position;
extern RoboCharaList      at_4300__2;
extern RoboStackList      at_4327;
extern RoboStackList      at_4328;
extern SceneCharaList     at_4329;
extern DebugLine          at_2674;
extern DebugLine          at_2675;
extern DebugLine          at_2676;
extern DebugText          at_2691;
extern DebugNpcText       at_2696;
extern char               at_2770[];
extern char               at_2771[];
extern char               at_2772[];
extern char               at_2773[];
extern char               at_2774[];
extern char               at_2775[];
extern char               at_2776__2[];
extern char               at_2777[];
extern char               at_2778[];
extern char               at_2779[];
extern char               at_2780[];
extern char               at_2781[];
extern char               at_2782[];
extern char               at_2783[];
extern char               at_2784[];
extern char               at_2785[];
extern short              MenuDebugChangeSelectMode;
extern short              MenuDebugCharaChangeSelect;
extern s8                 menu_debug_npc_decide;
extern s8                 menu_debug_npcselect;

/**
 *
 * Holds the selected non-player character name.
 *
 */
struct NpcNameList {
    char *entry[1]; /**< Name of the selected non-player character. */
};

/**
 *
 * Stores message numbers for non-player character commands.
 *
 */
struct NpcCmdMesList {
    int entry[2]; /**< Message number for each command. */
};

/**
 *
 * Stores sound volumes for gift actions.
 *
 */
struct GiftVolumeList {
    int entry[8]; /**< Sound volume for each gift action. */
};

extern s8               SelectedCmdNo_1415;
extern s8               init_1416;
extern NpcNameList      at_1650__2;
extern NpcCmdMesList    at_1684__2;
extern GiftVolumeList   at_1806__2;
extern s8               nextIDtbl_1594[5][8];
extern s16              msgtbl1_1732[4];
extern s8               se_sndtbl_1749[3];
extern char             at_2003__2[];
extern char             at_2004__3[];
extern char             at_2005__2[];
extern char             at_2006__2[];
extern char             at_2007__2[];
extern char             at_2008__2[];
extern char             at_2009[];
extern char             at_2010[];
extern char             at_2011[];
extern char             at_2012[];
extern char             at_2013[];
extern char             at_2014[];
extern char             at_2015[];
extern char             at_2016[];
extern char             at_2017[];
extern char             at_2018__2[];
extern char             at_2019__2[];
extern char             at_2020__2[];
extern char             at_2021__2[];
extern char             at_2022[];
extern char             at_2023[];
extern u8               tilergba_5203[4];
extern s8               convtbl_5238[3];
extern float            putw_5262[];
extern char            *infomsg_5256[];
extern s8               phasetbl_5119[COSTUME_LIST_NUM];
/**
 *
 * Number of resistance or weakness icons that the monster book can display.
 *
 */
enum { MOS_BOOK_AFFINITY_NUM = 8 };

/**
 *
 * Texture rectangles of the three monster-book background strips.
 *
 */
static short tiletbl_5573[3][12] = {
    {0x77, 0xBD, 0x26, 0x24, 0x9C, 0xBD, 0x4, 0x24, 0xA1, 0xBD, 0x26, 0x24},
    {0x77, 0xE1, 0x26, 0xC, 0x9C, 0xE1, 0x4, 0xC, 0xA1, 0xE1, 0x26, 0xC},
    {0x77, 0xED, 0x26, 0x24, 0x9C, 0xED, 0x4, 0x24, 0xA1, 0xED, 0x26, 0x24}
};
/**
 *
 * Texture rectangles of the monster-book description underboards.
 *
 */
static short under_brdtbl_5576[12] = {0x93, 0x2D, 0xA, 0x20, 0x9D, 0x2D, 0x2, 0x20, 0xA1, 0x2D, 0xA, 0x20};
/**
 *
 * Positions of the monster-book headings and description panels.
 *
 */
static short put_under_offset_5577[16][2] = {
    {0xFE, 0xE},
    {0xFE, 0x1E},
    {0xFE, 0x40},
    {0xFE, 0x50},
    {0xFE, 0x72},
    {0xFE, 0x82},
    {0xFE, 0xA4},
    {0xFE, 0xB4},
    {0xFE, 0xD6},
    {0xFE, 0xE6},
    {0x20, 0x104},
    {0x20, 0x116},
    {0x20, 0x13C},
    {0x20, 0x168},
    {0x104, 0x118},
    {0x0, 0x0}
};
/**
 *
 * Texture coordinates of the eight monster affinity icon slots.
 *
 */
static const short ic_5580[MOS_BOOK_AFFINITY_NUM][2] = {
    {0xA8, 0x0},
    {0xBE, 0x0},
    {0xD4, 0x0},
    {0xEA, 0x0},
    {0xBE, 0x16},
    {0xD4, 0x16},
    {0xEA, 0x16},
    {0x0, 0x0}
};
/**
 *
 * Texture rectangles of the monster-book vertical divider.
 *
 */
static short line_5595[12] = {0x0, 0x16, 0xC, 0x14, 0x0, 0x2A, 0xC, 0x4, 0x0, 0x2E, 0xC, 0x14};
/**
 *
 * Texture rectangles of the three monster-model frame strips.
 *
 */
static short wakutbl_5600[3][12] = {
    {0x1E, 0xA5, 0x32, 0x36, 0x50, 0xA5, 0x2, 0x36, 0x54, 0xA5, 0x22, 0x36},
    {0x1E, 0xDA, 0x32, 0x4, 0x50, 0xDA, 0x2, 0x4, 0x54, 0xDA, 0x22, 0x4},
    {0x1E, 0xDF, 0x32, 0x32, 0x50, 0xDF, 0x2, 0x32, 0x54, 0xDF, 0x22, 0x32}
};
extern char            *monstere_file_template[];
extern char            *tbl_3725[MOS_SELECT_BADGE_NUM];
extern int              menu_debug_select__2;
extern int              select_monster_save_3371;
extern s8               init_3372__2;
extern MonsterNameList  at_3412;
extern MonsterNameList  at_3440;
extern MenuCommandList  at_3481;
extern MonsterNameTable at_3511;
extern MonsterNameTable at_3529;
extern BadgeInfoValues  at_3554;
extern s8               convert_table_3430[];
extern short            ghobitbl_3437[];
extern char            *get_stringtbl_3557[4];
extern char             at_3685[];
extern char             at_3686[];
extern char             at_3687[];
extern char             at_3688[];
extern char             at_3689[];
extern char             at_3690[];
extern char             at_3691[];
extern char             at_3692[];
extern char             at_3693[];
extern char             at_3694[];
extern char             at_3695[];
extern char             at_3696[];
extern char             at_3697[];
extern char             at_3698[];
extern char             at_3699[];
extern char             at_3700[];
extern char             at_3701[];
extern char             at_3702[];
extern char             at_3703[];
extern char             at_3704[];
extern char             at_3705[];
extern char             at_3706[];
extern char             at_3707[];
extern char             at_3708[];
int                     CosutmeSelDefaultSet(int costume_id, short *costume_list);
extern char             at_2191__2[];
extern char             at_2192__2[];
extern char             at_2193__2[];
extern char             at_2194__2[];
extern char             at_2195__2[];
extern char             at_2196__2[];
extern char            *MonsterDataPath[];
extern char             script_file_name[0x20];
extern short            monster_load_id;
extern char             at_4548[];
extern char             at_3160__3[];
extern char             at_3161__3[];
extern char             at_3162__3[];
extern char             at_3163__3[];
extern char             at_3164__4[];
extern char             at_3165__2[];
extern char             at_3166__2[];
extern char             at_1304__6[15];
extern char            *partt_2332[6];
extern char             at_2363[14];
extern char             at_2364[15];
extern char             at_2365[13];
extern char             at_1171__2[];
extern char             at_1172[];
extern char             at_1173__2[];
extern char             at_1174[];
extern char             at_1175[];
extern char             at_1176[];
extern char             at_1177[];
extern char             at_1178[];
extern char             at_1179[];
extern char             at_1180[];
extern char             at_1181__2[];
extern char             at_2912[];
extern char             at_2913__2[];
extern char             at_2914[];
extern char             at_2915[];
extern char             at_2916[];
extern char             at_2917[];
extern char             at_2918[];

/**
 *
 * Views a four-component menu position as one quadword.
 *
 */
union MenuPositionVector {
    float     f[4]; /**< Four components of the menu position. */
    u_long128 qw;   /**< Combined 128-bit representation. */
};

extern MenuPositionVector at_1372__2;
extern char               at_1402__3[];
extern CMenuChrCngMenu   *ChrChangMenuPt;
extern int                MenuCharaChangePosDataCfgBuffer;
extern int                tbl_2483[];
extern char               at_2595__2[];
extern char               at_2596__3[];
extern SmallPair          at_2232;
extern NamePair           at_2288;
extern SmallPair          at_2289__2;
extern char               at_2303__2[];
extern char               at_2304[];
extern char               at_2305[];
extern char               at_2306[];
extern char               at_2307[];
extern u8                 cursor_revtbl_2237[5];
extern u8                 MenuGetPartySeFlag;
extern mgCMemory          ChrChangeInitTextureStack;
extern FileNameBuf        at_2629__3;
extern char               at_2197__2[];
extern char               at_2662__2[];
static int                MenuMemoryDivide(mgCMemory *memory, mgCMemory **list, int chara);
static void               MenuItemCharaDataLoadPack(int chara_no, CActionChara *chara, CActionChara *body, int part,
                                                    u_int *pack, mgCMemory *stack, int tex_block, int blur_type);
/**
 *
 * Quadword capacities of the ridepod menu work buffers.
 *
 */
static const u16 menu_robo_memorytbl[MENU_CHARA_LOAD_MAX] = {
    0x5240, 0x4514, 0x6E80, 0x1240, 0x05DC, 0, 0
};

/**
 *
 * Quadword capacities of the human character menu work buffers.
 *
 */
static const u16 menu_chr_memorytbl[MENU_CHARA_LOAD_MAX] = {
    0x1B80, 0x9AC0, 0x1C84, 0x11C0, 0x0BC0, 0x26C0, 0x0708
};
int                       ReadBGSync();

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
    return tbl_992[a1 + a0 * 5];
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
                int size = table[i];
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
    MemoryList list = at_1083__2;
    list.entry[0] = buffers;
    list.entry[1] = buffers + 1;
    list.entry[2] = buffers + 2;
    list.entry[3] = buffers + 3;
    list.entry[4] = buffers + 4;
    list.entry[5] = buffers + 5;
    list.entry[6] = buffers + 6;
    int used = MenuMemoryDivide(pool, list.entry, chara);
    rest->stSetBuffer(buffers->stack + buffers->stack_used + used,
                      free_blocks - used);

    if (strlen(at_1104__4) < 16) {
        strcpy((char *) rest, at_1104__4);
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
    form->GetPutPosXY(at_1131__3, pos[0], pos[1]);
    point = &pos[2];
    form->GetPutPosXY(at_1132__5, point[0], point[1]);
    point = &pos[4];
    form->GetPutPosXY(at_1133__4, point[0], point[1]);
    point = &pos[6];
    form->GetPutPosXY(at_1134__3, point[0], point[1]);
    point = &pos[8];
    form->GetPutPosXY(at_1135__3, point[0], point[1]);
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

    form = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_1171__2);

    if (form != NULL) {
        gauge_part[0] = form->GetPartInfo(at_1172);
        gauge_part[1] = form->GetPartInfo(at_1173__2);
        gauge_part[2] = form->GetPartInfo(at_1174);
    }

    (&npc_mes_form)[0] = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_1175);
    (&npc_mes_form)[1] = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_1176);
    (&npc_mes_form)[2] = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_1177);
    (&npc_mes_form)[3] = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_1178);
    (&npc_mes_form)[2]->SetActionCharaPtr(NULL, 0, -1);

    for (i = 0; i < 5; i++) {
        sprintf(name, at_1179, i);
        chara_pos[i] = MenuPosData->GetEtcTbl(name);
    }

    point_gauge_part = form->GetPartInfo(at_1180);

    for (j = 0; j < 4; j++) {
        sprintf(name, at_1181__2, j);
        cmd_part[j] = form->GetPartInfo(name);
    }
}
#ifdef NONMATCHING
void CMenuChrCngMenu::EnterDataMenu(u_char *pack) {
    mgCTextureManager *tex_manager = &mgTexManager;
    int block = tex_block[0];
    tex_manager->EnterIMGFile((u_char *) GetPackFile(reinterpret_cast<u_int *>(pack), "chr_bg.img", NULL),
                              block, NULL, NULL);
    int    size;
    u_int *cfg = GetPackFile(reinterpret_cast<u_int *>(pack), "chrchg.cfg", &size);
    if (MenuCharaChangePosDataCfgBuffer == 0 && cfg != NULL) {
        MenuCharaChangePosDataCfgBuffer = (int) cfg;
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
    memcpy(MenuCharaChangeCLUT, MenuCharaChangeBase_Tex->clut, 0x400);
    MenuCharaChangeCLUT_Tex->clut = (u_long128 *) MenuCharaChangeCLUT;
    /**
     *
     * A byte-addressable RGBA colour in the copied character-change palette.
     *
     */
    typedef u8 PaletteColor[4];
    /**
     *
     * Components, quantization bands, and command slots of the character-change screen.
     *
     */
    enum {
        PALETTE_RED = 0,
        PALETTE_GREEN = 1,
        PALETTE_BLUE = 2,
        PALETTE_BAND_NUM = 32,
        NPC_COMMAND_NUM = 4
    };
    PaletteColor *colors = reinterpret_cast<PaletteColor *>(MenuCharaChangeCLUT);
    for (int palette_index = 0; palette_index < CHR_CNG_CLUT_NUM; palette_index++) {
        PaletteColor &color = colors[palette_index];
        float         luminance = (float) ((color[PALETTE_RED] + color[PALETTE_GREEN] + color[PALETTE_BLUE]) / 3);
        // Quantize brightness without changing the palette alpha byte.
        int step = 1;
        do {
            if (8.0f * (float) (step - 1) <= luminance && luminance < 8.0f * (float) step) {
                break;
            }
            step++;
        } while (step < PALETTE_BAND_NUM + 1);
        color[PALETTE_RED] = (u8) (7.75f * (float) step);
        color[PALETTE_GREEN] = (u8) (5.625f * (float) step);
        color[PALETTE_BLUE] = (u8) (4.6875f * (float) step);
    }
    MenuPosData->InitDrawList();
    AttachForm();
    AttachMessageForm();
    ExeScript("INIT_FORM");
    party_member = MenuUserDataManPtr->GetNowPartyMember();
    enable_change = MenuUserDataManPtr->GetEnableCharaChangeFlag();
    for (int i = 0; i < USER_CHARA_NUM; i++) {
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
    for (int i = 0; i < NPC_COMMAND_NUM; i++) {
        npc_cmd_mes[i] = 0;
    }
    unk_23C = 0;
    party_info = NULL;
    npc_data = NULL;
    npc_no = MenuUserDataManPtr->NowPartyCharaID();
    if (npc_no > 0) {
        party_info = (PARTY_CHARA_INFO *) MenuUserDataManPtr->GetPartyCharaInfo(npc_no);
        npc_data = GetPartyNPCData(npc_no);
        npc_mes_talk = GetPartyCharaMessage(npc_no, 1, 0);
        npc_mes_cmd = GetPartyCharaMessage(npc_no, 0, 0);
        npc_mes_cancel = GetPartyCharaMessage(npc_no, 3, 0);
        int first_message = GetPartyCharaMessage(npc_no, 5, 0);
        int i = 0;
        for (; i < npc_data->ability_num; i++) {
            npc_cmd_mes[i] = first_message + i;
        }
        for (; i < NPC_COMMAND_NUM; i++) {
            npc_cmd_mes[i] = 0;
        }
        if (npc_data->ability_num == 0) {
            npc_cmd_mes[0] = 10;
        }
        i = 0;
        for (; i < npc_data->ability_num; i++) {
            form->SetNumber(tbl_1233[i], npc_data->ability_cost[i]);
        }
        for (; i < NPC_COMMAND_NUM; i++) {
            form->SetPartDrawFlag(tbl_1233[i], 0);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", EnterDataMenu__15CMenuChrCngMenuFPUc);
#endif
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

        sprintf(path, at_1304__6, face_chara);
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
        ExeScript(at_1319);
    }
}

#pragma inline_depth(8)

#ifdef NONMATCHING
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

    ExeScript(at_1361);
    return size;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", LoadBGNPCModel__15CMenuChrCngMenuFi);
#endif

#pragma inline_depth reset

int CMenuChrCngMenu::CheckBGNPCModel() {
    int   load_result;
    float position[4];

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

    *(MenuPositionVector *) position = at_1372__2;
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
            ExeScript(at_1402__3);
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
#ifdef NONMATCHING
int CMenuChrCngMenu::KeyChangeMain() {
    CMenuKeyFunc *keyFunc = MenuCommonInfo;
    keyFunc->SelDataInit();
    int            keys = keyFunc->CheckSelectKey();
    int            buttons = keyFunc->CheckPushButton();
    CDC2Mes       *titleMes = MenuDCMsg[2];
    CDC2Mes       *answerMes = MenuDCMsg[3];
    CDC2Mes       *cmdMes = MenuDCMsg[4];
    CDC2Mes       *npcMes = MenuDCMsg[5];
    CDC2Mes       *repairMes = MenuDCMsg[7];
    int            action = 0;
    CGameDataUsed *item = NULL;
    int            cancelled = 0;

    if (!init_1416) {
        SelectedCmdNo_1415 = -1;
        init_1416 = 1;
    }
    switch (key_arg_no) {
        case 2:
            if (buttons) {
                action = 0x1E;
            }
            break;
        case 3:
            switch (step) {
                case 0: {
                    int lastCmd = npc_data->ability_num - 1;
                    if (lastCmd < 0) {
                        lastCmd = 0;
                    }
                    switch (keyFunc->open_type) {
                        case MENU_OPEN_CHARA_CHANGE: {
                            if (buttons) {
                                mode = 2;
                                ExeScript(at_2003__2);
                            }
                            break;
                        }
                        default: {
                            if (npc_data->ability_num > 0) {
                                cmdMes->AddMsgCursor2(0, lastCmd, 1);
                            }
                            if (menu_debug_flag) {
                                if (keys & 8) {
                                    party_info->point++;
                                }
                                if (keys & 4) {
                                    party_info->point--;
                                }
                                if (npc_data->max_npc_point < party_info->point) {
                                    party_info->point = npc_data->max_npc_point;
                                }
                                if (party_info->point < 0) {
                                    party_info->point = 0;
                                }
                            }
                            SelectedCmdNo_1415 = -1;
                            switch (buttons) {
                                case 1:
                                case 4:
                                    action = 5;
                                    if (npc_data->ability_num > 0) {
                                        action = 100;
                                        SelectedCmdNo_1415 = cmdMes->GetMsgCursor();
                                    }
                                    break;
                                case 2:
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
                            mode = 2;
                            ExeScript(at_2003__2);
                            MenuArg.end_code = 5;
                            MenuArg.result[0] = 1;
                            MenuArg.result[1] = 1;
                            MenuArg.result[2] = 0;
                            action = -1;
                        }
                        if (got_item) {
                            step = 3;
                        }
                    }
                    break;
                case 3:
                    break;
                case 10: {
                    int widest = 0;
                    if (npcMes->page_num > 0) {
                        for (int i = 0; i < npcMes->page_num; i++) {
                            if (widest < npcMes->page_chars[i]) {
                                widest = npcMes->page_chars[i];
                            }
                        }
                    }
                    int cursor = npcMes->AddMsgCursor2(widest - 2, widest - 1, 1);
                    switch (buttons) {
                        case 1:
                            if (cursor == widest - 2) {
                                action = 0x5A;
                                if (npc_no == 1) {
                                    if (SelectedCmdNo_1415 == 0) {
                                        action = 0xC8;
                                    }
                                    if (SelectedCmdNo_1415 == 1) {
                                        action = 0xC9;
                                    }
                                }
                                break;
                            }
                        case 2:
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
                        case 1:
                        case 4:
                            item = MenuDrawItemInfo[item_brd_select];
                            action = 5;
                            if (item != NULL && item->IsRepair()) {
                                action = 0x5A;
                            }
                            break;
                        case 2:
                            ExeScript(at_2004__3);
                            action = 0x1E;
                            MenuCommonInfo->SetWakuType(-1);
                            break;
                    }
                    break;
            }
            break;
        case 1: {
            int answer = cmdMes->YesNoCursor();
            switch (buttons) {
                case 1:
                case 4:
                case 8:
                    if (answer == 0) {
                        action = 0x14;
                    } else {
                        action = 0x50;
                    }
                    break;
                case 2:
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
                    ExeScript(at_2005__2);
                    MenuCommonInfo->CursorFadeIn(6.0f, 0);
                    open_wait = 0;
                }
                break;
            }
            if (menu_debug_flag) {
                if (select != 4) {
                    int lr = MenuCommonInfo->CheckLRKey();
                    if (lr & 0x20 || lr & 8) {
                        MenuDebugChangeSelectMode++;
                    }
                    if (lr & 0x10 || lr & 4) {
                        MenuDebugChangeSelectMode--;
                    }
                    if (MenuDebugChangeSelectMode < 0) {
                        MenuDebugChangeSelectMode = 2;
                    }
                    if (MenuDebugChangeSelectMode > 2) {
                        MenuDebugChangeSelectMode = 0;
                    }
                    if (MenuDebugChangeSelectMode == 0) {
                        if (lr & 1) {
                            MenuDebugCharaChangeSelect--;
                        }
                        if (lr & 2) {
                            MenuDebugCharaChangeSelect++;
                        }
                        if (MenuDebugCharaChangeSelect < 0) {
                            MenuDebugCharaChangeSelect = 3;
                        }
                        if (MenuDebugCharaChangeSelect > 3) {
                            MenuDebugCharaChangeSelect = 0;
                        }
                        if (buttons & 1 && MenuDebugCharaChangeSelect < 4) {
                            MenuUserDataManPtr->JoinPartyMember(MenuDebugCharaChangeSelect);
                        }
                        if (buttons & 2 && MenuDebugCharaChangeSelect < 4) {
                            MenuUserDataManPtr->LeavePartyMember(MenuDebugCharaChangeSelect);
                        }
                    }
                    if (MenuDebugChangeSelectMode == 1) {
                        if (lr & 1) {
                            MenuDebugCharaChangeSelect--;
                        }
                        if (lr & 2) {
                            MenuDebugCharaChangeSelect++;
                        }
                        if (MenuDebugCharaChangeSelect < 0) {
                            MenuDebugCharaChangeSelect = 3;
                        }
                        if (MenuDebugCharaChangeSelect > 3) {
                            MenuDebugCharaChangeSelect = 0;
                        }
                        if (buttons & 1) {
                            MenuUserDataManPtr->EnableCharaChange(MenuDebugCharaChangeSelect);
                        }
                        if (buttons & 2) {
                            MenuUserDataManPtr->DisableCharaChange(MenuDebugCharaChangeSelect);
                        }
                    }
                    if (MenuDebugChangeSelectMode == 2) {
                        if (lr & 1) {
                            MenuDebugCharaChangeSelect--;
                        }
                        if (lr & 2) {
                            MenuDebugCharaChangeSelect++;
                        }
                        if (MenuDebugCharaChangeSelect < 0) {
                            MenuDebugCharaChangeSelect = 3;
                        }
                        if (MenuDebugCharaChangeSelect > 3) {
                            MenuDebugCharaChangeSelect = 0;
                        }
                        if (buttons & 1) {
                            MenuUserDataManPtr->EnableCharaChangeMask(MenuDebugCharaChangeSelect);
                        }
                        if (buttons & 2) {
                            MenuUserDataManPtr->DisableCharaChangeMask(MenuDebugCharaChangeSelect);
                        }
                    }
                    if (buttons & 4) {
                        MenuUserDataManPtr->JoinPartyMember(0);
                        MenuUserDataManPtr->JoinPartyMember(1);
                        MenuUserDataManPtr->EnableCharaChange(0);
                        MenuUserDataManPtr->EnableCharaChange(1);
                        MenuUserDataManPtr->EnableCharaChange(2);
                        MenuUserDataManPtr->EnableCharaChange(3);
                        MenuUserDataManPtr->EnableCharaChangeMask(0);
                        MenuUserDataManPtr->EnableCharaChangeMask(1);
                        MenuUserDataManPtr->EnableCharaChangeMask(2);
                        MenuUserDataManPtr->EnableCharaChangeMask(3);
                    }
                    return 0;
                }
                if (keys & 1) {
                    menu_debug_npcselect--;
                }
                if (keys & 2) {
                    menu_debug_npcselect++;
                }
                if (menu_debug_npcselect < 1) {
                    menu_debug_npcselect = 1;
                }
                if (menu_debug_npcselect >= 0x1B) {
                    menu_debug_npcselect = 0x1A;
                }
                if (keys & 8) {
                    menu_debug_npc_decide++;
                }
                if (keys & 4) {
                    menu_debug_npc_decide--;
                }
                if (menu_debug_npc_decide < 0) {
                    menu_debug_npc_decide = 0;
                }
                if (menu_debug_npc_decide > 1) {
                    menu_debug_npc_decide = 1;
                }
                if (buttons & 1 || buttons & 2) {
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
                return 0;
            }
            switch (step) {
                case 0: {
                    int lastSelect = select;
                    int dir = -1;
                    if (keys & 1) {
                        dir = 0;
                    }
                    if (keys & 1 && keys & 8) {
                        dir = 1;
                    }
                    if (keys & 8) {
                        dir = 2;
                    }
                    if (keys & 2 && keys & 8) {
                        dir = 3;
                    }
                    if (keys & 2) {
                        dir = 4;
                    }
                    if (keys & 2 && keys & 4) {
                        dir = 5;
                    }
                    if (keys & 4) {
                        dir = 6;
                    }
                    if (keys & 1 && keys & 4) {
                        dir = 7;
                    }
                    int next = -1;
                    if (dir >= 0) {
                        next = nextIDtbl_1594[lastSelect][dir];
                    }
                    if (next >= 0) {
                        select = next;
                    }
                    if (lastSelect != select) {
                        MenuSePlay(0);
                        if (select == 4) {
                            MenuDCMsg[0]->SetBuff(mes_data);
                        }
                        if (lastSelect == 4) {
                            MenuDCMsg[0]->SetBuff(sys_mes);
                        }
                    }
                    switch (buttons) {
                        case 1:
                            if (select == 3) {
                                action = 0x32;
                            } else if (select == 4) {
                                action = 5;
                                if (MenuCommonInfo->open_type != (int) MENU_OPEN_CHARA_CHANGE_DUNGEON && 0 < npc_no) {
                                    action = 0x22;
                                }
                            } else {
                                action = 0x46;
                            }
                            break;
                        case 2:
                            action = 0x28;
                            if (MenuCommonInfo->open_type == (int) MENU_OPEN_CHARA_CHANGE_DUNGEON) {
                                action = 5;
                                if (MenuUserDataManPtr->GetHp(MenuUserDataManPtr->active_chr_no) < 1.0f) {
                                    break;
                                }
                                mode = 2;
                                FadeOutMenu(40, 0.0f);
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
                    int cursor = npcMes->AddMsgCursor2(0, last, 1);
                    switch (buttons) {
                        case 1:
                            if (cursor == 0) {
                                action = 0x1E;
                            }
                            if (cursor == 1) {
                                step = 2;
                                ExeScript(at_2006__2);
                                NpcNameList names = at_1650__2;
                                names.entry[0] = GetNPCName(npc_no);
                                cmdMes->SetMsgItemNo(names.entry, 1);
                                if (party_info->status & 4) {
                                    cmdMes->MakeMsg(0x1B0);
                                } else {
                                    cmdMes->MakeMsg(0x1AF);
                                }
                            }
                            break;
                        case 2:
                            step = 0;
                            ExeScript(at_2007__2);
                            break;
                    }
                    break;
                }
                case 2: {
                    int answer = cmdMes->YesNoCursor2(0);
                    if (answer == 1) {
                        if (party_info->status & 4) {
                            party_info->status = 4;
                        } else {
                            party_info->status = 2;
                            int mapNo = MenuNowMapNo;
                            if (mapNo == SearchMapNo(at_2008__2) || mapNo == SearchMapNo(at_2009)) {
                                MenuMainScene->SetActive(SCENE_DATA_CHARA, MenuMainScene->SearchCharaID(npc_no));
                            }
                        }
                        npc_no = 0;
                        party_info = NULL;
                        npc_mes_talk = 0;
                        npc_mes_cmd = -1;
                        npc_mes_cancel = -1;
                        ExeScript(at_2010);
                        step = 0;
                    }
                    if (answer == 2) {
                        step = 1;
                        ExeScript(at_2011);
                    }
                    break;
                }
            }
            break;
    }

    int activeChara = keyFunc->GetActiveCharaNo();
    switch (action) {
        case 5:
            MenuSePlay(5);
            break;
        case 0x22:
            if (party_info->status & 4) {
                ExeScript(at_2012);
            } else {
                ExeScript(at_2013);
            }
            if (npc_no == 0x1A) {
                MenuDCMsg[5]->MakeMsg(0x1B3);
            }
            MenuSePlay(0x13);
            step = 1;
            npcMes->point_x = 20;
            npcMes->point_y = 200;
            break;
        case 0x1E:
            if (mode == 1) {
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
                ExeScript(at_2014);
                if (cancelled != 1) {
                    ExeScript(at_2015);
                    npc_chara_form->counter = 0;
                }
                titleMes->MakeMsg(0x1E);
                titleMes->StepMsg();
                NpcCmdMesList answers = at_1684__2;
                answers.entry[0] = npc_mes_cmd;
                answers.entry[1] = npc_mes_cancel;
                answerMes->fuchi = 5;
                answerMes->SetMsgItemNo(answers.entry, 2);
                answerMes->MakeMsg(0xB);
                answerMes->StepMsg();
                cmdMes->MakeMsg(0x1F);
                cmdMes->SetMsgItemNo(npc_cmd_mes, 4);
                cmdMes->font_h = 0x1C;
                cmdMes->SetMsgCursor(-1);
                if (npc_data->ability_num > 0) {
                    cmdMes->SetMsgCursor(0);
                    if (SelectedCmdNo_1415 >= 0) {
                        cmdMes->SetMsgCursor(SelectedCmdNo_1415);
                    }
                }
                star_fade_out = 0;
                if (keyFunc->open_type == 4) {
                    cmdMes->SetMsgCursor(-1);
                } else {
                    star_fade_out = 1;
                }
                MenuItemBrdCalcManner = 1;
                item_brd_select = 0;
                item_brd_pos = 0;
                MenuItemBrdSetInfo(item_brd_select, item_brd_pos, GetNowBagMax(0) / 6, 5);
            } else {
                MenuSePlay(5);
            }
            break;
        case 0x46: {
            COMMON_GAGE *roboHp = &MenuUserParam.robo->hp;
            if (activeChara == select) {
                MenuSePlay(5);
                if (select == 2 && roboHp->now < 1.0f) {
                    open_wait = 1;
                    ExeScript(at_2016);
                    cmdMes->MakeMsg(0x1A4);
                }
                break;
            }
            int attr = MenuUserDataManPtr->GetCharaStatusAttirbute(activeChara);
            if (attr & 8 || attr & 0x20) {
                open_wait = 1;
                ExeScript(at_2016);
                cmdMes->MakeMsg(select + 0x1A5);
                break;
            }
            party_member = MenuUserDataManPtr->GetNowPartyMember();
            enable_change = MenuUserDataManPtr->GetEnableCharaChangeFlag();
            int bit = 1 << select;
            if (!(party_member & bit)) {
                MenuSePlay(5);
                break;
            }
            if (!(enable_change & bit) && select != 3) {
                mode = 0xD;
                open_wait = 1;
                ExeScript(at_2016);
                cmdMes->MakeMsg(select + 0x1A5);
                break;
            }
            if (keyFunc->open_type == 0 && select == 2) {
                MenuSePlay(5);
                break;
            }
            if (select == 2 && roboHp->now < 1.0f) {
                open_wait = 1;
                ExeScript(at_2016);
                cmdMes->MakeMsg(0x1A4);
                break;
            }
            switch (select) {
                case 1:
                case 0:
                    if (gauge[select]->now <= 0.0f) {
                        MenuSePlay(5);
                        return 0;
                    }
                    attr = MenuUserDataManPtr->GetCharaStatusAttirbute(select);
                    if (attr & 8 || attr & 0x20) {
                        MenuSePlay(5);
                        return 0;
                    }
                    break;
            }
            if (select == 3 && gauge[1]->now <= 0.0f) {
                MenuSePlay(5);
                break;
            }
            if (select == 2 && gauge[0]->now <= 0.0f) {
                MenuSePlay(5);
                break;
            }
            key_arg_no = 1;
            ExeScript(at_2017);
            cmdMes->MakeMsg(msgtbl1_1732[select]);
            npc_chara = NULL;
            for (int i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
                InitMenuBGReadInfo2(MenuCharaBuild2[i]);
            }
            change_chara = select;
            MenuLoadInfo.chara_no = select;
            MenuLoadInfo.mode = 2;
            MenuLoadInfo.request_phase = -1;
            MenuLoadInfo.load_phase = 0;
            MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] = 1;
            ReEquipFishingGameWeapon();
            MenuCharaLoadStack.stack_used = 0;
            MenuCharaLoadStack.lock = 0;
            MenuCharaLoadStack.Align64();
            SetMenuLoadItemNo(change_chara);
            switch (change_chara) {
                case 0:
                case 1:
                    MenuLoadInfo.load_all = 1;
                    MenuLoadInfo.request_phase = -1;
                    MenuItemCharaDataLoad(&MenuCharaLoadStack, change_chara, MenuCharaBuild2, 1);
                    break;
                case 2:
                    MenuLoadInfo.load_all = 1;
                    MenuCharaLoadStack.Alloc(blocks_for(MenuItemRoboDataLoad(&MenuCharaLoadStack, MenuCharaBuild2, 1)));
                    break;
            }
            change_phase = (int) CHR_CNG_PHASE_LOAD;
            change_ready = 0;
            break;
        }
        case 0x50:
            key_arg_no = 0;
            change_phase = (int) CHR_CNG_PHASE_NONE;
            ExeScript(at_2005__2);
            break;
        case 0x14: {
            change_ready = 1;
            ExeScript(at_2018__2);
            MenuArg.end_code = 1;
            MenuArg.result[0] = select;
            int lastChara = GetUserDataMan()->active_chr_no;
            GetUserDataMan()->SetActiveChrNo(MenuArg.result[0]);
            if (keyFunc->open_type == 0) {
                GetCharaMemAllocPtr(MenuArg.chara_stack, MorattaStack, change_chara, 1);
            } else {
                if (lastChara == 3) {
                    DeleteMonsterEffect();
                }
                GetCharaMemAllocPtr(MenuArg.chara_stack, MorattaStack, change_chara, 0);
            }
            last_select = select;
            MenuSePlay(se_sndtbl_1749[select]);
            if (MenuLoadInfo.alternate_model == 1) {
                EditCharaPrepare();
            }
            if (GetMenuLoopType() == (int) MENU_LOOP_DUNGEON && FxScriptMan != NULL) {
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
        case 0x28:
            mode = 2;
            ReturnMenuIntern(0);
            ExeScript(at_2019__2);
            MenuMainFrameModeSet(5, 0);
            if (MenuFormMI2 != NULL) {
                MenuFormMI2->rate_x = 4.0f;
                MenuFormMI2->rate_y = 9.0f;
            }
            break;
        case 0x32:
            if (!GetMenuMainFrameEndFlag()) {
                break;
            }
            if (!IsCheckParty(3)) {
                MenuSePlay(5);
                break;
            }
            enable_change = MenuUserDataManPtr->GetEnableCharaChangeFlag();
            sub_menu = -1;
            sub_menu_next = 1;
            FadeOutMenu(40, 0.0f);
            MenuSePlay(1);
            break;
        case 0x3C:
            MenuSePlay(2);
            ExeScript(at_2020__2);
            if (npc_chara != NULL) {
                npc_chara->Show(0, 1);
            }
            keyFunc->MenuPosPlay();
            key_arg_no = 0;
            star_fade_out = 0;
            star_stop_wait = 20;
            step = 0;
            break;
        case 100:
            if (npc_data == NULL || party_info == NULL) {
                MenuSePlay(5);
                break;
            }
            got_item = 0;
            ExeScript(at_2021__2);
            if (!MenuUserDataManPtr->UseNpcAbility(npc_no, SelectedCmdNo_1415, 0)) {
                step = 1;
                ExeScript(at_2022);
                npcMes->MakeMsg(GetPartyCharaMessage(npc_no, 8, 0) + SelectedCmdNo_1415);
                npcMes->StepMsg();
                AdjustNPCTalk(npcMes, npc_chara);
                break;
            }
            if (GetMenuLoopType() == (int) MENU_LOOP_TOWN) {
                int dungeonOnly = 0;
                switch (npc_no) {
                    case 5:
                    case 6:
                    case 0x12:
                    case 0x13:
                    case 0x15:
                    case 0x16:
                    case 0x17:
                        dungeonOnly = 1;
                        break;
                }
                if (dungeonOnly) {
                    npcMes->MakeMsg(GetPartyCharaMessage(npc_no, 8, 0) + SelectedCmdNo_1415);
                    npcMes->StepMsg();
                    AdjustNPCTalk(npcMes, npc_chara);
                    MenuSePlay(5);
                    step = 2;
                    break;
                }
            }
            {
                npcMes->MakeMsg(GetPartyCharaMessage(npc_no, 6, 0) + SelectedCmdNo_1415);
                npcMes->StepMsg();
                int widest = 0;
                if (npcMes->page_num > 0) {
                    for (int i = 0; i < npcMes->page_num; i++) {
                        if (widest < npcMes->page_chars[i]) {
                            widest = npcMes->page_chars[i];
                        }
                    }
                }
                npcMes->SetMsgCursor(widest - 1);
                npcMes->draw_speed = 0.0f;
                AdjustNPCTalk(npcMes, npc_chara);
                MenuSePlay(0);
                step = 10;
            }
            break;
        case 0x5A: {
            MenuMesForm[6]->draw_flag = 0;
            npcMes->push_button = 0;
            npcMes->SetMsgCursor(-1);
            if (party_info->point - npc_data->ability_cost[SelectedCmdNo_1415] < 0) {
                step = 1;
                ExeScript(at_2022);
                npcMes->MakeMsg(GetPartyCharaMessage(npc_no, 8, 0) + SelectedCmdNo_1415);
                break;
            }
            int se = 5;
            int used = 0;
            int soundMode = 0;
            int inDungeon = 0;
            if (GetMenuLoopType() == (int) MENU_LOOP_DUNGEON) {
                inDungeon = 1;
            }
            int              bossFloor = 0;
            DNG_BATTLE_AREA *area = &MenuMainScene->battle_area;
            if (area != NULL && area->floor_status & DNG_FLOOR_DISABLE_ITEMS) {
                bossFloor = 1;
            }
            int bitCtrl = GetSaveData()->GetBitCtrl();
            int maxBad = CheckBadStatus(MenuUserDataManPtr->GetCharaStatusAttirbute(USER_CHARA_MAX));
            int monicaBad = CheckBadStatus(MenuUserDataManPtr->GetCharaStatusAttirbute(USER_CHARA_MONICA));
            int maxHurt = 0;
            if (MenuUserDataManPtr->chara_data[(int) USER_CHARA_MAX].hp.GetRate() < 1.0f) {
                maxHurt = 1;
            }
            int monicaHurt = 0;
            if (MenuUserDataManPtr->party_member & 2 && MenuUserDataManPtr->chara_data[(int) USER_CHARA_MONICA].hp.GetRate() < 1.0f) {
                monicaHurt = 1;
            }
            step = 2;
            GiftVolumeList volume = at_1806__2;
            int            message = GetPartyCharaMessage(npc_no, 7, 0) + SelectedCmdNo_1415;
            switch (npc_no) {
                case 1:
                    if (SelectedCmdNo_1415 == 2) {
                        if (MenuUserDataManPtr->robo_data.AddPoint(0.0f) >= 1.0f) {
                            used = 0;
                            message = GetPartyCharaMessage(1, 8, 0);
                        } else {
                            MenuUserDataManPtr->robo_data.AddPoint(999.0f);
                            UpdataLife();
                            se = 10;
                            used = 1;
                        }
                    } else {
                        int pos[2];
                        item->Repair(999);
                        MenuPosData->GetPosMenuItemBrdKoma(pos, item_brd_select, 0);
                        se = 10;
                        MenuRepairMan->Generate(pos[0], pos[1]);
                        UpdataLife();
                        used = 1;
                        step = 20;
                        message = 0;
                    }
                    break;
                case 0x16:
                    used = 0;
                    if (inDungeon && ActiveMonster != NULL) {
                        ActiveMonster->SetNearAreaPiyori(350.0f);
                        se = 10;
                        used = 1;
                    } else {
                        message = GetPartyCharaMessage(0x16, 8, 0);
                    }
                    break;
                case 5:
                    used = 0;
                    if (inDungeon) {
                        used = 1;
                        if (bitCtrl & 1) {
                            used = 0;
                        }
                        if (MenuMainScene->battle_area.boss_map && MenuMainScene->battle_area.battle_clear) {
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
                    if (inDungeon && !bossFloor && (maxBad || monicaBad)) {
                        used = 1;
                        se = 0x56;
                        soundMode = 1;
                        MenuUserDataManPtr->SetCharaStatusAttirbute(USER_CHARA_MAX, 0x6F, 1);
                        MenuUserDataManPtr->SetCharaStatusAttirbute(USER_CHARA_MONICA, 0x6F, 1);
                    }
                    if (!used) {
                        message = GetPartyCharaMessage(6, 8, 0);
                    }
                    break;
                case 0x17:
                    if (inDungeon && !bossFloor && (maxBad || monicaBad || maxHurt || monicaHurt)) {
                        used = 1;
                        se = 10;
                        MenuUserDataManPtr->AddHp(0, 999);
                        MenuUserDataManPtr->AddHp(1, 999);
                        MenuUserDataManPtr->SetCharaStatusAttirbute(USER_CHARA_MAX, 0x6F, 1);
                        MenuUserDataManPtr->SetCharaStatusAttirbute(USER_CHARA_MONICA, 0x6F, 1);
                        UpdataLife();
                    }
                    if (!used) {
                        message = GetPartyCharaMessage(0x17, 8, 0);
                    }
                    break;
                case 0x12:
                    if (inDungeon && !bossFloor) {
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
                        soundMode = 1;
                        UpdataLife();
                        se = 0x56;
                    } else {
                        message = GetPartyCharaMessage(0x12, 8, 0);
                    }
                    break;
                case 0x15:
                    if (inDungeon) {
                        used = 0;
                        for (int chara = 0; chara < 2; chara++) {
                            if (MenuUserDataManPtr->GetNowPartyMember() & (1 << chara) &&
                                MenuUserDataManPtr->GetHp(chara) >= 1.0f) {
                                MenuUserDataManPtr->SetCharaStatusAttirbuteVol(chara, 0x10, 750);
                                used = 1;
                            }
                        }
                    }
                    if (used) {
                        soundMode = 1;
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
                    enum { NPC_GIFT_FOOD_CAPACITY = 32 };
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
                    npcMes->SetMsgVolumeNoOne(volume.entry[0]);
                    if (gift_num == 0) {
                        message = GetPartyCharaMessage(npc_no, 0xB, 0);
                    } else {
                        used = 1;
                        got_item = 1;
                        MenuUserDataManPtr->GetItem(gift_item, gift_num);
                        se = 0x12;
                    }
                    break;
                }
            }
            if (used) {
                MenuUserDataManPtr->UseNpcAbility(npc_no, SelectedCmdNo_1415, 1);
            }
            npcMes->MakeMsg(message);
            npcMes->StepMsg();
            AdjustNPCTalk(npcMes, npc_chara);
            if (soundMode == 0) {
                MenuSePlay(se);
            }
            if (soundMode == 1) {
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
                ExeScript(at_2023);
                repairMes->abs_win.width = 0xDC;
                repairMes->abs_win.height = 0x4E;
                repairMes->value_sign = 0;
                repairMes->value_zero = 1;
                repairMes->push_button = 0;
                repairMes->ClsMes::mes_no = -1;
                repairMes->MakeMsg(0x1C3);
                item_brd_select = 0;
                item_brd_pos = 0;
                MenuItemBrdCalcManner = 0;
                if (SelectedCmdNo_1415 == 0) {
                    SetModeMenuDrawItemBoard(1);
                }
                if (SelectedCmdNo_1415 == 1) {
                    SetModeMenuDrawItemBoard(2);
                }
                if (SelectedCmdNo_1415 == 2) {
                    SetModeMenuDrawItemBoard(3);
                }
            }
            break;
        default:
            return 0;
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", KeyChangeMain__15CMenuChrCngMenuFv);
#endif
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
        sprintf(name, at_2191__2, i);
        icon = form->GetPartInfo(name);
        strcat(name, at_2192__2);
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

    sprintf(name, at_1284__4, last_select);
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
        form->GetPutPosXY(at_1175, pos[0], pos[1]);
        SetFormPoint(npc_mes_form, pos[0], pos[1]);
        SetFormPoint(npc_sub_form, pos[0], pos[1]);
        SetFormPoint(npc_sub_form2, pos[0], pos[1]);
        form->GetPutPosXY(at_2193__2, item_pos[0][0], item_pos[0][1]);
        form->GetPutPosXY(at_2194__2, item_pos[1][0], item_pos[1][1]);
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
            form->SetNumber(at_2195__2, party_info->point);
            form->SetNumber(at_2196__2, npc_data->max_npc_point);

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
        form->GetPutPosXY(at_2197__2, frame_pos[0], frame_pos[1]);

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
    SmallPair step = at_2232;

    if (npc_no == 1 && this->step == 0x14) {
        (MenuPosData)->GetPosMenuItemOnItemBrd(cursor, item_brd_select, 1);
        cursor[0] -= 8;
        cursor[1] -= 10;
        step.v[0] = -0x2E;
        step.v[1] = 0x12;
    } else {
        sprintf(name, at_2303__2, select);
        form->GetPutPosXY(name, cursor[0], cursor[1]);
        MenuCursorReverseFlag = cursor_revtbl_2237[select];
    }

    MenuCommonInfo->MenuPosStep(cursor, step.v);

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
                    ExeScript(at_2304);
                    key_mode = MenuCommonInfo->open_type;

                    if (key_mode == 4) {
                        ExeScript(at_2305);
                    } else if (key_mode == 0xE) {
                        ExeScript(at_2306);
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
                ExeScript(at_2307);
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
            NamePair  item_names = at_2288;
            SmallPair item_volumes = at_2289__2;
            item = MenuDrawItemInfo[item_brd_select];
            mes = MenuDCMsg[7];

            if (item != NULL) {
                item_names.a = item->GetName(0);
                item->GetWHp(item_volumes.v);
            }

            mes->SetMsgItemNo(&item_names.a, 1);
            mes->SetMsgVolumeNo(item_volumes.v, 2);
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
    int i;

    i = 0;
    gauge[0] = &MenuUserParam.chara[0]->hp;
    gauge[1] = &MenuUserParam.chara[1]->hp;
    gauge[2] = &MenuUserParam.robo->hp;

    do {
        form->SetNumber(partt_2332[i * 2], GetDispVolumeForFloat(gauge[i]->now));
        form->SetNumber(partt_2332[i * 2 + 1], fptosi(gauge[i]->max));

        if (gauge_part[i] != NULL && gauge[i] != NULL) {
            gauge_part[i]->w = GetDispVolumeForFloat(66.0f * gauge[i]->GetRate());
        }

        i++;
    } while (i < 3);

    if (!(party_member & 1)) {
        ExeScript(at_2363);
    }

    if (!(party_member & 2)) {
        ExeScript(at_2364);
    }

    if (!(party_member & 4)) {
        ExeScript(at_2365);
    }
}
#ifdef NONMATCHING
void MenuCharaChangeStarDraw() {

    if (MenuCharaChangeBase_Tex == NULL) {
        return;
    }
    mgTexManager.ReloadTexture(MenuCharaChangeBase_Tex->block, (sceVif1Packet *) NULL);
    CMenuChrCngMenu *menu = ChrChangMenuPt;
    float            angle;
    float            size = menu->star_size;
    float            offset = size / 2.0f - 2.0f;
    RingCenter       center = at_2371__4;
    center.x = menu->star_x + offset;
    center.y = menu->star_y + 1.1538461f * offset;
    angle = menu->star_angle;
    mgCDrawPrim  *prim = GetMenuPrim();
    mgRect<int>   baseRect(0x13F, 0xC0, 0x40, 0x40);
    QuadTexCoords crd = at_2372__4;
    crd.uv[0][0] = baseRect.left;
    crd.uv[3][0] = baseRect.left;
    crd.uv[1][0] = baseRect.left + baseRect.right;
    crd.uv[2][0] = baseRect.left + baseRect.right;
    crd.uv[2][1] = baseRect.top + baseRect.bottom;
    crd.uv[3][1] = baseRect.top + baseRect.bottom;
    crd.uv[0][1] = baseRect.top;
    crd.uv[1][1] = baseRect.top;
    SetSpriteEnv(prim, 4);
    prim->Bilinear(1);
    prim->Begin(MG_PRIM_TRIANGLE_FAN);
    prim->Texture(MenuCharaChangeBase_Tex);
    prim->Color(0x80, 0x80, 0x80, (int) ChrChangMenuPt->star_alpha);
    for (int i = 0; i < 4; i++) {
        prim->TextureCrd((int) crd.uv[i][0], (int) crd.uv[i][1]);
        float x = 1.0f + (center.x + size * cosf(angle));
        prim->Vertex(x, center.y + 1.1538461f * (size * sinf(angle)), 0.0f);
        angle += 1.5707964f;
    }
    prim->End();

    mgRect<int> wakuRect(0x121, 0xE1, 0x1E, 0x1E);
    float       ringSize = 0.546875f * ChrChangMenuPt->star_size;
    float       wave = ChrChangMenuPt->star_wave;
    angle -= 0.15707964f;
    float pulse = sinf(ChrChangMenuPt->star_pulse);
    if (pulse < 0.0f) {
        pulse = -pulse;
    }
    float pulseAlpha = 0.5f * ChrChangMenuPt->star_alpha * pulse;
    for (int j = 0; j < 2; j++) {
        float alpha = ChrChangMenuPt->star_alpha;
        float circle = 60.0f + 3.0f * sinf(wave);
        float x = ringSize * cosf(angle);
        float y = ringSize * sinf(angle);
        x = center.x + x;
        mgRect<float> inner(x - 0.5f * circle, 6.0f + (center.y + 1.1538461f * (y - 0.5f * circle)), circle,
                            circle);
        DrawWakuCircle(prim, MenuCharaChangeBase_Tex, inner, wakuRect, wave, ringSize, (int) alpha, 0x80, 0x80,
                       0x80);
        circle *= 1.4f;
        mgRect<float> outer(x - 0.5f * circle, 6.0f + (center.y + 1.1538461f * (y - 0.5f * circle)), circle,
                            circle);
        DrawWakuCircle(prim, MenuCharaChangeBase_Tex, outer, wakuRect, wave, ringSize, (int) pulseAlpha, 0x80, 0x80,
                       0x80);
        angle += 3.1415927f;
        wave += 3.1415927f;
    }

    if (MenuCharaChangeStar_Tex == NULL) {
        return;
    }
    mgTexManager.ReloadTexture(MenuCharaChangeStar_Tex->block, (sceVif1Packet *) NULL);
    mgRect<short> starRect(0, 0x20, 8, 8);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(MenuCharaChangeStar_Tex);
    for (int k = 0; k < CHR_CNG_STAR_NUM; k++) {
        CHR_CNG_STAR *star = &ChrChangMenuPt->star[k];
        if (star->alpha > 0.0f) {
            float starX = star->x + ChrChangMenuPt->star_x;
            float starY = star->y + ChrChangMenuPt->star_y;
            prim->Color(0x80, 0x80, 0x80, (int) star->alpha);
            prim->TextureCrd(starRect.left, starRect.top);
            prim->Vertex(starX, starY, 0.0f);
            prim->TextureCrd(starRect.left + starRect.right, starRect.top + starRect.bottom);
            prim->Vertex(starX + starRect.right, starY + starRect.bottom, 0.0f);
        }
    }
    prim->End();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuCharaChangeStarDraw__Fv);
#endif
#ifdef NONMATCHING
int MenuCharaChangeInit(mgCMemory *stack, int *tex_block, int mode) {
    u_long128       *buffer;
    int              size;
    unsigned int     file_size;
    CMenuChrCngMenu *menu;
    CRepairManager  *repair;
    int              i;
    CCharacter2     *chara;
    short            party_chara;

    buffer = stack->stack;

    if (mode == 4 || mode == 0xE) {
        file_size = LoadFileMenu(at_2595__2, buffer, 1);
        stack->Alloc((file_size & 0xF) ? (file_size >> 4) + 1 : file_size >> 4);
        stack->Align64();
    }

    ChrChangeInitTextureStack.stSetBuffer(buffer, stack->stack_used);
    size = stack->stGetRest();
    MenuChangeMemory.stSetBuffer(stack->stGetTop(), size);
    MenuChangeMemory.Alloc(0x100);

    menu = new (MenuChangeMemory.Alloc(0x1FA)) CMenuChrCngMenu;

    ChrChangMenuPt = menu;
    menu->SetTexBlock(tex_block);
    party_chara = MenuUserDataManPtr->active_chr_no;
    ChrChangMenuPt->last_select = party_chara;
    ChrChangMenuPt->select = party_chara;

    repair = new (MenuChangeMemory.Alloc(0x21)) CRepairManager;

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

    MenuBGReadInfo2Malloc(&MenuChangeMemory, tbl_2483);
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
        ChrChangMenuPt->ExeScript(at_2596__3);
    } else {
        MenuMainScene->fade.FadeIn(1);
        MenuMainScene->fade.FadeStep();
    }

    MenuCommonInfo->key_enable = 0;
    (&MenuCommonInfo->cursor)[0] = 0;
    MenuGetPartySeFlag = 0;
    MenuDCMsg[0]->MsgPreset(3);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuCharaChangeInit__FP9mgCMemoryPii);
#endif

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
    FileNameBuf       file_name;
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
                        file_name = at_2629__3;
                        LoadFileMenu(file_name.text, (u_long128 *) texture, 1);
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
                        ChrChangMenuPt->form->GetPutPosXY(at_2662__2, pos[0], pos[1]);
                        MenuCommonInfo->MenuSetPos(pos[0], pos[1]);
                        ChrChangMenuPt->form->GetPutPosXY(at_2197__2, pos[0], pos[1]);
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
            DebugLine party = at_2674;
            DebugLine change = at_2675;
            DebugLine mask = at_2676;
            party_member = MenuUserDataManPtr->GetNowPartyMember();
            int chara_change = MenuUserDataManPtr->chara_change;
            int change_mask = MenuUserDataManPtr->chara_change_mask;
            int i;

            for (i = 0; i < 4; i++) {
                int bit = 1 << i;

                if (party_member & bit) {
                    strcat(party.text, at_2770);
                } else {
                    strcat(party.text, at_2771);
                }

                if (chara_change & bit) {
                    strcat(change.text, at_2770);
                } else {
                    strcat(change.text, at_2771);
                }

                if (change_mask & bit) {
                    strcat(mask.text, at_2770);
                } else {
                    strcat(mask.text, at_2771);
                }
            }

            DebugText title = at_2691;
            font.SetStr(title.text);
            font.SetPos(0x28, 0x3C);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            int cursor_x = MenuDebugChangeSelectMode * 0x3C + 0x98;
            font.SetStr(at_2772);
            font.SetPos(cursor_x, 0x14);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            font.SetStr(at_2773);
            font.SetPos(0x98, 0x28);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            font.SetStr(party.text);
            font.SetPos(0x98, 0x3C);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            font.SetStr(at_2774);
            font.SetPos(0xD4, 0x28);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            font.SetStr(change.text);
            font.SetPos(0xD4, 0x3C);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            font.SetStr(at_2775);
            font.SetPos(0x110, 0x28);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            font.SetStr(mask.text);
            font.SetPos(0x110, 0x3C);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            int cursor_y = MenuDebugCharaChangeSelect * 0x14 + 0x3C;
            font.SetStr(at_2776__2);
            font.SetPos(0x14, cursor_y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);

            if (LanguageCode == 0) {
                font.SetStr(at_2777);
                font.SetPos(0x28, 0xA0);
                font.DrawDirect(font.str, font.pos_x, font.pos_y);
                return;
            }

            font.SetStr(at_2778);
            font.SetPos(0x28, 0xA0);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            return;
        }

        DrawMenuFillBox(20.0f, 26.0f, 280.0f, 300.0f, 0x60, 0, 0, 0);
        CUserDataManager *user_data = GetUserDataMan();
        mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
        int y = 0x46;
        font.SetStr(at_2779);
        font.SetPos(0x14, 0x1E);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
        DebugNpcText npc_title = at_2696;
        strcpy(&npc_title.text[menu_debug_npc_decide * 3 + 0x11], at_2780);
        font.SetStr(npc_title.text);
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
            sprintf(line, at_2781, name);

            if (info->status & 1) {
                strcat(line, at_2782);
            } else {
                strcat(line, at_2783);
            }

            if (info->status & 2) {
                strcat(line, at_2782);
            } else {
                strcat(line, at_2783);
            }

            if (info->status & 4) {
                strcat(line, at_2784);
            } else {
                strcat(line, at_2785);
            }

            font.SetStr(line);
            font.SetPos(0x1A, y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            y += 0x14;

            if (y >= 0x137) {
                break;
            }
        }

        font.SetStr(at_2776__2);
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
        strcat(file_name, at_2912);
    }

    if (kind == 1) {
        number = monster->sound_no;

        if (number < 0) {
            return 0;
        }

        strcpy(file_name, at_2913__2);

        if (number < 10) {
            sprintf(suffix, at_2914, number);
        } else if (number < 100) {
            sprintf(suffix, at_2915, number);
        } else {
            sprintf(suffix, at_2916, number);
        }

        strcat(file_name, suffix);
    }

    if (kind == 2) {
        henge_param = (int *) GetMonsterHengeParam(monster_id);

        if (henge_param != NULL) {
            sprintf(file_name, at_2917, henge_param[2]);
        }
    }

    if (kind == 3) {
        strcpy(file_name, monster->model);
        strcat(file_name, at_2918);
    }

    return 1;
}

void CMenuMosSelect::AttachForm() {
    char              name[0x20];
    MOS_CHANGE_PARAM *base;
    int               i;
    badge_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_2940);
    model_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_2941);
    info_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo(at_2942);
    Tex_BuildUpBoard = mgTexManager.GetTexture(at_2943, -1);
    GetUserDataMan();

    if (badge_form != NULL) {
        base = badge;
        i = 0;

        do {
            MENUFORMPARTS_TYPE *part;
            sprintf(name, at_2944, i);
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

            if (MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] == 1) {
                MenuMainScene->AssignStack(5);
                stack = MenuMainScene->GetStack(5);
            }

            stack->stReset();
            MenuMonsterLoadBG(stack, MenuMonsterBGInfo, load_monster, 1);
            model_form->counter = -16;

            if (MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] == 1) {
                MenuCharaSoundLoad(stack, 3, 1);
            }

            load_phase++;
            model_form->draw_flag = 0;
            break;
        }
        case 1:
            if (MenuMonsterBGInfo[0]->reading && ReadBGSync() == 0) {
                SceneCharaList chara = at_3054__2;
                chara.entry[0] = monster;
                int tex_block = this->tex_block[1];
                MenuMonsterLoadBGCheck(MenuMonsterBGInfo, chara.entry, tex_block, MenuArg.chara_tex_block);

                if (MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] == 0) {
                    MonsterScaleCheck(chara.entry[0]);
                    chara.entry[0]->SetPosition(float(16.0), 1.0f, 0.0f);
                    model_form->SetActionCharaPtr(monster, tex_block, -1);
                    model_form->counter = -14;
                    model_form->draw_flag = 1;
                    monster->Show(0, 1);
                    monster->fade = 1;
                    monster->fade_speed = 0.05f;
                }

                load_phase++;

                if (MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] == 1) {
                    load_phase++;
                    MenuSoundCharaNo = 3;
                    chara.entry[0] = (CActionChara *) MenuMainScene->GetCharacter(0);
                    MenuCharaSoundEnter(MenuMainScene, chara.entry[0], 1);
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
        sprintf(name, at_2944, slot);
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
        info_form->GetPutPosXY(at_3160__3, item_pos[0][0], item_pos[0][1]);
        int *choice = item_pos[1];
        info_form->GetPutPosXY(at_3161__3, choice[0], choice[1]);
        pos = item_pos[2];
        info_form->GetPutPosXY(at_3162__3, pos[0], pos[1]);
        pos = item_pos[3];
        info_form->GetPutPosXY(at_3163__3, pos[0], pos[1]);
        pos = item_pos[4];
        info_form->GetPutPosXY(at_3164__4, pos[0], pos[1]);
        pos = item_pos[5];
        info_form->GetPutPosXY(at_3165__2, pos[0], pos[1]);
        item_pos[0][0] -= ask->GetStrWidth(0) >> 1;
        int width = ask->GetMesWidth_system(ask->item_mes[1]);
        choice[0] -= width >> 1;
        ask->SetMsgItemPos(item_pos[0], 6);
        info_form->GetPutPosXY(at_3166__2, win_pos[0], win_pos[1]);
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
    int old_cursor = select;
    MenuGlidKeyCheck(keys, &select, &top, &max_3170, &viewnum_3171, overcode_3172,
                     0xC);

    if (old_cursor != select) {
        MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] = 0;
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

#pragma inline_depth(3)

void MenuMonsterBoxInit(mgCMemory *stack, int *tex_block, int mode) {
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
        MenuMonsterBGInfo[i] = NULL;

        if (tbl_3186[i]) {
            MenuMonsterBGInfo[i] = (MENU_BGREAD_INFO2 *) stack->Alloc(8);
            InitMenuBGReadInfo2(MenuMonsterBGInfo[i]);
        }
    }

    *(CameraPoint *) MenuMosSelectPtr->camera_pos = *(CameraPoint *) MenuDrawEnv->pos;
    *(CameraPoint *) MenuMosSelectPtr->camera_ref = *(CameraPoint *) MenuDrawEnv->ref;
    sceVu0CopyVector(MenuDrawEnv->pos, posdef_3194);
    sceVu0CopyVector(MenuDrawEnv->ref, refdef_3195);
    MenuDrawEnv->camera.SetPos(posdef_3194);
    MenuDrawEnv->camera.SetRef(refdef_3195);
    stack->Align64();
    u_int *pack = (u_int *) stack->stGetTop();
    size = LoadFileMenu(at_3269, (u_long128 *) pack, 1);
    stack->Alloc(blocks_for(size));
    u_char *image = (u_char *) GetPackFile(pack, at_3270, NULL);
    int     block = MenuMosSelectPtr->tex_block[0];
    mgTexManager.EnterIMGFile(image, block, NULL, NULL);
    MenuMosTexture = mgTexManager.GetTexture(at_3271, block);
    MenuMosSelectPtr->mes_data = MenuDCMsg[0]->buff;
    s16 *box_mes = (s16 *) GetPackFile(pack, at_3272, NULL);
    MenuCommandAnalyzeInfo.system_mes_buff[0] = GetSystemMesBuffer();
    MenuCommandAnalyzeInfo.system_mes_buff[1] = box_mes;
    MenuCommandAnalyzeInfo.mes_buff[0] = MenuMosSelectPtr->mes_data;
    MenuCommandAnalyzeInfo.mes_buff[1] = box_mes;
    MenuMosSelectPtr->mes.SetMessData(GetSystemMesBuffer(), MenuMosSelectPtr->mes_data);
    MenuMosSelectPtr->info_win.SetBuff_system(GetSystemMesBuffer());
    MenuMosSelectPtr->info_win.SetBuff(MenuMosSelectPtr->mes_data);
    MenuMosSelectPtr->info_win.MakeMesWin(tbl_3196[LanguageCode], 1, 1);
    char *cfg = (char *) GetPackFile(pack, at_3273, &size);
    MenuDataAnalyze(cfg, size, stack);
    MenuMosSelectPtr->script = (char *) GetPackFile(pack, at_3274, &MenuMosSelectPtr->script_size);
    MenuMosSelectPtr->AttachForm();
    MenuMosSelectPtr->ExeScript(at_3275);
    MenuMosSelectPtr->ExeScript(at_3276);
    AttachMessageForm();
    stack->Align64();
    rest = stack->stGetRest();
    MenuMosLoadStack.stSetBuffer(stack->stGetTop(), rest);
    MenuLoadInfo.load_all = 1;
    MenuLoadInfo.mode = 0;
    MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] = 0;
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
#ifdef NONMATCHING
int CMenuMosSelect::KeyStep() {
    sceVu0FVECTOR effectPos;
    int           size;
    int           i;
    int           keys = MenuCommonInfo->CheckSelectKey();
    int           lrKeys = MenuCommonInfo->CheckLRKey();
    int           buttons = MenuCommonInfo->CheckPushButton();
    int           fadeEnd = MenuMosSelectPtr->FadeCheckMenu();
    CDC2Mes      *command = MenuDCMsg[5];
    int           showInfo = 0;
    int           action;

    switch (mode) {
        case 1:
            if (fadeEnd) {
                mode = 0;
                select_badge = NULL;
            }
            break;
        case 2:
            if (fadeEnd && (result == MOS_SELECT_RESULT_CLOSE || (result == MOS_SELECT_RESULT_CHANGE && load_phase == 4))) {
                if (result == MOS_SELECT_RESULT_CHANGE) {
                    CActionChara *player = (CActionChara *) MenuMainScene->GetCharacter(0);
                    if (player != NULL) {
                        player->effect_man = FxScriptMan;
                        player->InitScript();
                    }
                    MenuArg.end_code = 1;
                    MenuArg.result[0] = 3;
                }
                MenuDrawEnv->camera.SetPos(camera_pos);
                MenuDrawEnv->camera.SetRef(camera_ref);
                *(CameraPoint *) MenuDrawEnv->pos = *(CameraPoint *) camera_pos;
                *(CameraPoint *) MenuDrawEnv->ref = *(CameraPoint *) camera_ref;
                ExeScript(at_2307);
                MenuPosData->TexGetInfoClear(0xAA, 0x100);
                MenuPosData->FormInfoClear(0x3C, 0x4F);
                return result;
            }
            break;
        case 0: {
            action = 0;
            if (menu_debug_flag) {
                if (keys & 1) {
                    menu_debug_select__2--;
                }
                if (keys & 2) {
                    menu_debug_select__2++;
                }
                if (menu_debug_select__2 < 0) {
                    menu_debug_select__2 = MOS_SELECT_BADGE_NUM - 1;
                }
                if (menu_debug_select__2 >= MOS_SELECT_BADGE_NUM) {
                    menu_debug_select__2 = 0;
                }
                MOS_CHANGE_PARAM *debugBadge = &badge[menu_debug_select__2];
                if (debugBadge != NULL) {
                    COMMON_GAGE *gauge = &debugBadge->hp;
                    if (GamePad__2.On(0x80)) {
                        gauge = &debugBadge->abs;
                    }
                    if (keys & 8) {
                        gauge->AddPoint(1.0f);
                    } else if (keys & 4) {
                        gauge->AddPoint(-1.0f);
                    }
                    if (buttons & 1) {
                        if (debugBadge->enable) {
                            debugBadge->enable = 0;
                        } else {
                            GetUserDataMan()->monster_box.EnableChange(menu_debug_select__2 + 1);
                        }
                        MenuSePlay(1);
                    }
                    if (buttons & 4) {
                        if (debugBadge->enable) {
                            debugBadge->abs.SetFillRate(1.0f);
                            debugBadge->LevelUp();
                        }
                    }
                    if (buttons & 2) {
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
                case 0:
                    KeyNormalMode(keys, lrKeys, buttons);
                    switch (buttons) {
                        case 1:
                        case 4:
                            if (select > 9) {
                                action = 5;
                            } else {
                                select_badge = &badge[select];
                                if (select_badge == NULL || (select_badge != NULL && !select_badge->enable)) {
                                    MenuSePlay(5);
                                    select_badge = NULL;
                                } else {
                                    action = 600;
                                }
                            }
                            break;
                        case 2:
                            select_badge = NULL;
                            action = 1000;
                            break;
                    }
                    break;
                case 1:
                    switch (step) {
                        case 0: {
                            int cursor = command->CommandMsgCursor();
                            switch (buttons) {
                                case 1:
                                case 4:
                                    int mes = command->item_mes[cursor];
                                    if (mes == 0x14B7) {
                                        action = 20;
                                    }
                                    if (mes == 0x14B6) {
                                        action = 12;
                                    }
                                    if (mes == 0x14B8) {
                                        action = 30;
                                    }
                                    if (action == 12 && command->line_color[cursor] == 0x80202020) {
                                        action = 5;
                                    }
                                    break;
                                case 2:
                                    action = 500;
                                    break;
                            }
                            break;
                        }
                        case 1:
                            if (buttons) {
                                ExeScript(at_3685);
                                step = 0;
                            }
                            break;
                        case 10: {
                            if (!init_3372__2) {
                                init_3372__2 = 1;
                                select_monster_save_3371 = 0;
                            }
                            int oldSelect = BuildUpWeaponInfo.select_no;
                            if (keys & 1) {
                                BuildUpWeaponInfo.select_no = oldSelect - 1;
                            }
                            if (keys & 2) {
                                BuildUpWeaponInfo.select_no++;
                            }
                            if (BuildUpWeaponInfo.select_no < 0) {
                                BuildUpWeaponInfo.select_no = 0;
                            }
                            if (!(BuildUpWeaponInfo.select_no < BuildUpWeaponInfo.select_num)) {
                                BuildUpWeaponInfo.select_no = BuildUpWeaponInfo.select_num - 1;
                            }
                            if (oldSelect != BuildUpWeaponInfo.select_no) {
                                MenuSePlay(0);
                            }
                            switch (buttons) {
                                case 1:
                                    select_monster_save_3371 = BuildUpWeaponInfo.select_no;
                                    step = 11;
                                    ExeScript(at_3686);
                                    mes_show = 1;
                                    mes.MsgPreset(0xB);
                                    mes.ClsMes::mes_no = -1;
                                    char *name = GetMonsterName(level_monster[select_monster_save_3371]);
                                    if (name != NULL) {
                                        strcpy(mes.name[0], name);
                                    }
                                    mes.SetAbsPos(5);
                                    mes.MakeMsg(0x1D8);
                                    mes.SetMsgCursor(1);
                                    break;
                                case 2:
                                    step = 0;
                                    ExeScript(at_3687);
                                    MenuSePlay(5);
                                    BuildUpWeaponInfo.mode = 0;
                                    break;
                            }
                            break;
                        }
                        case 11: {
                            int answer = mes.YesNoCursor2(0);
                            if (answer == 1 && ReadBGSync() == 0) {
                                mes_show = 0;
                                BuildUpWeaponInfo.mode = 0;
                                change_wait = 0;
                                step = 12;
                                ExeScript(at_3688);
                                MenuMonChangeLoadStack.stReset();
                                effect.Initialize(NULL);
                                effect_show = 0;
                                effect_data = MenuMonChangeLoadStack.stack;
                                effect_sound = reinterpret_cast<u32 *>(&effect_data[0x3980]);
                                effect_stack.stSetBuffer(
                                    MenuMonChangeLoadStack.stack + MenuMonChangeLoadStack.stack_size - 0x3B80, 0x3980);
                                StartReadBG();
                                LoadFileBG(at_3689, (u_long128 *) effect_sound, &size);
                                LoadFileBG(at_3690, effect_data, &size);
                            }
                            if (answer == 2) {
                                mes_show = 0;
                                BuildUpWeaponInfo.mode = 1;
                                step = 10;
                                ExeScript(at_3691);
                            }
                            break;
                        }
                        case 12:
                            change_wait++;
                            if (ReadBGSync() == 0 && effect_show == 0) {
                                if (effect_sound != NULL) {
                                    mgCMemory soundStack;
                                    soundStack.stSetBuffer(
                                        MenuMonChangeLoadStack.stack + MenuMonChangeLoadStack.stack_size - 0x200, 0x140);
                                    MenuSePlay(0, effect_sound, &soundStack);
                                }
                                mgTexManager.DeleteBlock(tex_block[2]);
                                effect.Initialize(NULL);
                                effect.LoadPack((u_int *) effect_data, at_3692, &effect_stack, &effect_stack, &effect_stack,
                                                tex_block[2], NULL);
                                effect.SetScale(1.5f, 1.5f, 1.5f);
                                monster->GetPosition(effectPos);
                                effectPos[1] += 10.2f;
                                effectPos[0] -= 3.4f;
                                effectPos[2] += 18.0f;
                                effect.SetPosition(effectPos);
                                effect.SetMotion(at_3693, 6, 1);
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
                                    select_badge->monster_id = level_monster[select_monster_save_3371];
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
                                step = 13;
                                ExeScript(at_3694);
                                MenuSePlay(0x1E);
                                MonsterNameList grown = at_3412;
                                grown.name[0] = GetMonsterName(level_monster[select_monster_save_3371]);
                                info->SetMsgItemNo(grown.name, 1);
                            }
                            break;
                        case 13:
                        case 14:
                        case 15:
                            if (!(buttons & 1) && !(buttons & 2)) {
                                break;
                            }
                            if (step == 13) {
                                level_max = 0;
                                step = 14;
                                CGameDataUsed *place = GetUserDataMan()->SearchSpaceUsedDataPtr();
                                if (place != NULL) {
                                    CGameDataUsed reward;
                                    reward.Init();
                                    reward.item_no = 0x17F;
                                    reward.used_type = 2;
                                    reward.item_type = 0x22;
                                    reward.data.attach.spectol_value = select_badge->class_level + 1;
                                    if (select_badge->class_level == 3) {
                                        level_max = 1;
                                    }
                                    s16 *param = reward.data.attach.status;
                                    for (i = 0; i < 10; i++) {
                                        param[i] = select_badge->class_level + 3;
                                    }
                                    param[convert_table_3430[select]] += select_badge->class_level * 2;
                                    place->CopyGameData(&reward);
                                    ExeScript(at_3695);
                                } else {
                                    ExeScript(at_3696);
                                }
                            } else if (step == 14) {
                                if (level_max) {
                                    int got = MenuUserDataManPtr->GetItem(ghobitbl_3437[select], 5);
                                    if (0 < got) {
                                        ExeScript(at_3697);
                                        MonsterNameList item = at_3440;
                                        item.name[0] = GetItemMessage(ghobitbl_3437[select]);
                                        MenuDCMsg[6]->SetMsgItemNo(item.name, 1);
                                        MenuDCMsg[6]->SetMsgVolumeNoOne(got);
                                    } else {
                                        ExeScript(at_3698);
                                        action = 500;
                                    }
                                    step++;
                                } else {
                                    ExeScript(at_3698);
                                    action = 500;
                                }
                            } else if (step == 15) {
                                action = 500;
                            }
                            break;
                        case 20: {
                            int cursor = info->AddMsgCursor2(0, select_badge->class_level, 0);
                            view_monster = monster_progress_tbl[select_badge->progress][1 + cursor];
                            switch (buttons) {
                                case 1:
                                    if (GetUserDataMan()->active_chr_no == 3 &&
                                        view_monster == GetUserDataMan()->monster_id) {
                                        MenuSePlay(5);
                                    } else {
                                        action = 10;
                                    }
                                    break;
                                case 2:
                                    action = 600;
                                    break;
                            }
                            break;
                        }
                    }
                    break;
                case 2: {
                    s16 *row = monster_progress_tbl[select_badge->progress];
                    int  count = select_badge->class_level + 1;
                    int  level = -1;
                    for (i = 0; i < count; i++) {
                        if (view_monster == row[1 + i]) {
                            level = i;
                            break;
                        }
                    }
                    int move = 0;
                    if ((lrKeys & 0x20) || (lrKeys & 0x80)) {
                        move = 1;
                    }
                    if ((lrKeys & 0x10) || (lrKeys & 0x40)) {
                        move = -1;
                    }
                    int oldLevel = level;
                    level += move;
                    if (level < 0) {
                        level = select_badge->class_level;
                    }
                    if (select_badge->class_level < level) {
                        level = 0;
                    }
                    if (level != oldLevel) {
                        showInfo = 1;
                        view_monster = row[1 + level];
                        pick_monster = view_monster;
                        load_wait = 0;
                        load_phase = 0;
                        MenuSePlay(0);
                    }
                    switch (buttons) {
                        case 1:
                        case 4:
                            action = 5;
                            break;
                        case 2:
                            action = 500;
                            break;
                    }
                    break;
                }
            }
            switch (action) {
                case 5:
                    MenuSePlay(5);
                    break;
                case 500:
                    ExeScript(at_3699);
                    model_side = 0;
                    key_arg_no = 0;
                    break;
                case 600: {
                    ExeScript(at_3700);
                    int             commandNum = 3;
                    int             row = 0;
                    MenuCommandList commands = at_3481;
                    for (; row < commandNum; row++) {
                        if (commands.mes[row] == 0x14B6) {
                            if (MenuCommonInfo->now_mode == (int) MENU_MODE_ITEM || GetMenuLoopType() == (int) MENU_LOOP_TOWN) {
                                local_sort1(row, &commandNum, commands.mes);
                            } else {
                                if (MenuUserDataManPtr->CheckEnableCharaChange(3, NULL) == 0 && row >= 0 && row < 20) {
                                    command->line_color[row] = 0x80202020;
                                }
                                if (select_badge != NULL && select_badge->hp.GetRate() <= 0.0f && row >= 0 && row < 20) {
                                    command->line_color[row] = 0x80202020;
                                }
                                int attr = MenuUserDataManPtr->GetCharaStatusAttirbute(MenuUserDataManPtr->active_chr_no);
                                if (((attr & 4) || (attr & 8) || (attr & 0x20)) && row >= 0 && row < 20) {
                                    command->line_color[row] = 0x80202020;
                                }
                            }
                        }
                        if (commands.mes[row] == 0x14B8 && select_badge != NULL && !select_badge->CheckClassChange()) {
                            local_sort1(row, &commandNum, commands.mes);
                        }
                    }
                    command->MakeMsg(commandNum);
                    command->SetMsgItemNo(commands.mes, commandNum);
                    command->SetMsgCursor(0);
                    MenuMesForm[6]->draw_flag = 0;
                    step = 0;
                    key_arg_no = 1;
                    MenuSePlay(0x13);
                    break;
                }
                case 1000:
                    mode = 2;
                    result = MOS_SELECT_RESULT_CLOSE;
                    FadeOutMenu(40, 0.0f);
                    MenuSePlay(5);
                    break;
                case 12: {
                    step = 2;
                    MenuMesForm[6]->draw_flag = 1;
                    MenuSePlay(1);
                    info->MsgPreset(6);
                    MonsterNameTable names = at_3511;
                    for (i = 0; i < select_badge->class_level + 1; i++) {
                        names.name[i] = GetMonsterName(monster_progress_tbl[select_badge->progress][1 + i]);
                        if (GetUserDataMan()->active_chr_no == 3 &&
                            monster_progress_tbl[select_badge->progress][1 + i] == GetUserDataMan()->monster_id &&
                            i >= 0 && i < 20) {
                            info->line_color[i] = 0x80202020;
                        }
                    }
                    info->SetMsgItemNo(names.name, select_badge->class_level + 1);
                    info->MakeMsg(select_badge->class_level + 0x32);
                    info->SetMsgCursor(0);
                    break;
                }
                case 10: {
                    MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] = 1;
                    if (MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] == 1 && FxScriptMan != NULL) {
                        DeleteMonsterEffect();
                    }
                    GetCharaMemAllocPtr(MenuArg.chara_stack, MorattaStack, 3, 0);
                    MenuMosLoadStack.stReset();
                    MenuLoadInfo.mode = 2;
                    MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] = 1;
                    result = MOS_SELECT_RESULT_CHANGE;
                    monster->Initialize(NULL);
                    load_wait = 0;
                    load_phase = 0;
                    FadeOutMenu(40, 0.0f);
                    mode = 2;
                    MOS_CHANGE_PARAM *chosen = select_badge;
                    s16               monsterNo = monster_progress_tbl[chosen->progress][1 + info->GetMsgCursor()];
                    chosen->monster_id = monsterNo;
                    view_monster = monsterNo;
                    load_monster = -1;
                    MenuUserDataManPtr->SetActiveChrNo(3);
                    MenuUserDataManPtr->monster_id = monsterNo;
                    MenuSePlay(0x10);
                    break;
                }
                case 11:
                    ExeScript(at_3701);
                    step = 1;
                    break;
                case 20:
                    key_arg_no = 2;
                    ExeScript(at_3702);
                    view_monster = select_badge->monster_id;
                    if (select_badge != NULL) {
                        showInfo = 1;
                    }
                    model_side = 1;
                    MenuSePlay(2);
                    break;
                case 30: {
                    BuildUpWeaponInfo.monster_mode = 1;
                    step = 10;
                    int monsterNo = monster_progress_tbl[select_badge->progress][1 + select_badge->class_level];
                    level_num = get_monster_tbl_bajjilevel(level_monster, select, monsterNo, select_badge->class_level + 1);
                    MonsterNameTable names = at_3529;
                    ExeScript(at_3703);
                    names.name[0] = at_3704;
                    names.name[1] = GetMonsterName(monsterNo);
                    for (i = 0; i < level_num; i++) {
                        names.name[2 + i] = GetMonsterName(level_monster[i]);
                    }
                    info->MakeMsg(level_num + 0x33);
                    info->SetMsgItemNo(names.name, level_num + 2);
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
    if (select_badge != NULL && select_badge->enable == 1 && select_badge->class_level > 0) {
        if (key_arg_no == 2) {
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
    if (showInfo && select_badge != NULL) {
        BadgeInfoValues values = at_3554;
        int             base = view_monster * 10 + 10000;
        int             degree = select_badge->GetDegreeLevel();
        values.value[2] = base + 10;
        values.value[3] = base + 11;
        values.value[4] = -1;
        values.value[1] = select * 20 + degree + 1;
        CDC2Mes *desc = MenuDCMsg[7];
        desc->ClsMes::mes_no = -1;
        desc->value_zero = 1;
        desc->value_half = 0;
        desc->value_space = -3;
        if (CheckNowEurope()) {
            desc->value_half = 1;
            desc->value_space = 1;
        }
        desc->SetMsgItemNo(values.value, 4);
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
                info_form->SetNumber(get_stringtbl_3557[0], GetDispVolumeForFloat(shown->hp.now));
                info_form->SetNumber(get_stringtbl_3557[1], GetDispVolumeForFloat(shown->hp.max));
                float absRate = shown->abs.GetRate();
                info_form->SetNumber(get_stringtbl_3557[2], GetDispVolumeForFloat(100.0f * absRate));
                info_form->SetNumber(get_stringtbl_3557[3], 100);
                MENUFORMPARTS_TYPE *hpBar = info_form->GetPartInfo(at_3705);
                if (hpBar != NULL) {
                    hpBar->w = 168.0f * shown->hp.GetRate();
                }
                MENUFORMPARTS_TYPE *absBar = info_form->GetPartInfo(at_3706);
                if (absBar != NULL) {
                    absBar->w = 168.0f * absRate;
                }
                info_form->SetNumber(at_3707, shown->GetAttackVol(view_monster));
                info_form->SetNumber(at_3708, shown->GetDefenceVol(view_monster));
            } else {
                info_form->SetNumber(get_stringtbl_3557[0], 0);
                info_form->SetNumber(get_stringtbl_3557[2], 0);
                info_form->SetNumber(get_stringtbl_3557[3], 100);
            }
        }
    }
    CheckLoadBGMonster();
    MenuPosData->FormStep();
    CalcTex();
    CalcCursorPosition();
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", KeyStep__14CMenuMosSelectFv);
#endif
int MenuMonsterBoxKey() {
    return MenuMosSelectPtr->KeyStep();
}

void MenuMonsterBoxDraw() {
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
            strcpy(text, tbl_3725[i]);

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

    sun = chara->SearchObject(at_3779);
    moon = chara->SearchObject(at_3780);

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
        object = chara->SearchObject(at_3790);

        if (object != NULL) {
            object->GetRotation(rotation);
            rotation[1] += 0.13962634f;
            rotation[1] = mgAngleLimit(rotation[1]);
            object->SetRotation(rotation);
        }
    }
}

int MenuItemCharaDataLoad(mgCMemory *stack, int chara_no, MENU_BGREAD_INFO2 **info, int restart_read) {
    char           name[MENU_CHARA_LOAD_MAX][0x40];
    CharaPathKinds path_kind;
    int            i;

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
    path_kind = at_3810;

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
                strcpy(name[0], at_3913);
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
            strcpy(name[0], at_3913);

            if (0 < MenuLoadItemNo[2]) {
                strcpy(name[4], GetItemFileName(MenuLoadItemNo[2], 1));
            }

            if (0 < MenuLoadItemNo[3]) {
                strcpy(name[5], GetItemFileName(MenuLoadItemNo[3], 1));
            }

            break;
        case 2:
            path_kind.kind[0] = pathtbl_3836[MenuLoadInfo.alternate_model];

            if (MenuLoadInfo.alternate_model == 0) {
                path_kind.kind[0] = 4;
                GetMainCharaModelName(chara_no, name[0], 0);
            }

            if (MenuLoadInfo.alternate_model == 1) {
                path_kind.kind[0] = 5;
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
            strcpy(info[i]->path, menu_load_chrpathtbl_3811[path_kind.kind[i]]);
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
                body->LoadSkin(pack, menu_infocfgname, at_2287, stack, tex_block);
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

                body->LoadSkin(pack, menu_infocfgname, at_3969, stack, tex_block);
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
    SceneCharaList     scene_chara = at_3974;
    SceneCharaList     menu_chara = at_3975;

    if (chara != NULL) {
        menu_chara.entry[0] = chara[0];
        menu_chara.entry[1] = NULL;
        menu_chara.entry[2] = chara[1];
        menu_chara.entry[3] = chara[2];
        menu_chara.entry[4] = chara[3];
        menu_chara.entry[5] = chara[4];
        menu_chara.entry[6] = chara[5];
    }

    if (scene != NULL && MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] != 0) {
        for (i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
            scene_chara.entry[i] = (CActionChara *) scene->GetCharacter(i);
        }

        player = scene_chara.entry[0];

        if (MenuLoadInfo.mode == 0 || MenuLoadInfo.mode == 1) {
            scene_chara.entry[0] = NULL;
        }

        if (MenuLoadInfo.alternate_model == 1) {
            scene_chara.entry[1] = NULL;

            if (chara_no == 0) {
                scene_chara.entry[2] = NULL;
            }
        }
    }

    LoadTargetList8 scene_target = at_3993;
    scene_target.entry[0] = scene_chara.entry[0];
    scene_target.entry[1] = player;
    scene_target.entry[2] = scene_chara.entry[1];
    scene_target.entry[3] = scene_chara.entry[2];
    scene_target.entry[4] = scene_chara.entry[3];
    scene_target.entry[5] = scene_chara.entry[4];
    scene_target.entry[6] = scene_chara.entry[5];

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
                        if (menu_chara.entry[slot] != NULL) {
                            menu_chara.entry[slot]->Initialize(NULL);
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

        info[i]->chara = menu_chara.entry[i];
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
                strcpy(tex_manager->name_suffix, at_4123);
                MenuItemCharaDataLoadPack(chara_no, info[i]->chara, info[0]->chara, i, (u_int *) read->buffer, buffer,
                                          tex_block, -1);
                tex_manager->name_suffix[0] = 0;
                break;
        }

        switch (MenuLoadInfo.mode) {
            case 0:
            case 2:
                if (scene_target.entry[i] != NULL) {
                    mgCMemory *scene_stack = &MorattaStack[i];
                    scene_stack->stReset();
                    MenuItemCharaDataLoadPack(chara_no, scene_target.entry[i], player, i, (u_int *) read->buffer,
                                              scene_stack, scene_tex_block, chara_no);

                    if (i == 0 && scene_target.entry[0] != NULL) {
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

            if (MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] != 0) {
                MorattaStack[6].stReset();

                if (scene_chara.entry[0] != NULL) {
                    scene_chara.entry[0]->LoadActionFile((char *) script->buffer, script->size, &MorattaStack[6]);
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
    signed char chara_ids[4];

    if (scene != NULL && chara != NULL) {
        chara->sound_info.foot_se_bank = scene->se_base_id;
        chara->sound_info.foot_sound_id = -1;

        if (open_port != 0) {
            sndInitPort(7);
        }

        unsigned int *buffer = (unsigned int *) CharaSndBuffer;

        if (buffer != NULL) {
            int index;
            *(float *) chara_ids = at_4158;
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
    strcpy((char *) info, GetItemFileName(item_no, 0));

    if (variant == 1) {
        strcat((char *) info, at_4186__2);
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
            strcpy(tex_manager->name_suffix, at_4123);
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

extern s8   convItoPhase_4229[6];
extern char at_4276__2[];
extern char at_4277[];
extern char at_4278[];

int MenuItemRoboDataLoad(mgCMemory *stack, MENU_BGREAD_INFO2 **info, int restart_read) {
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
        } else if (MenuLoadInfo.load_phase == convItoPhase_4229[i] || MenuLoadInfo.load_all == 1) {
            load = 1;
        }

        if (!load) {
            continue;
        }

        strcpy(info[i]->path, at_4276__2);
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
        strcpy(hat->name, at_4277);
        strcpy(hat->path, at_4278);
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
        sprintf(name, at_4296, chara->outline_tex_no);

        if (alternate != 0) {
            strcat(name, at_4123);
        }

        tex_manager->DeleteTexture(name, -1);
    }
}

int MenuItemRoboDataLoadEndCheck(MENU_BGREAD_INFO2 **info, mgCMemory *stack, CActionChara **chara, int tex_block,
                                 int scene_tex_block) {
    CActionChara      *parent = NULL;
    mgCTextureManager *tex_manager = &mgTexManager;
    CScene            *scene = MenuMainScene;
    RoboCharaList      scene_chara = at_4300__2;
    int                i;
    mgCMemory         *part_stack;

    if (scene != NULL && MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] != 0) {
        for (i = 0; i < 6; i++) {
            scene_chara.entry[i] = (CActionChara *) scene->GetCharacter(i);
        }
    }

    if (MenuLoadInfo.mode == 2) {
        tex_manager->DeleteBlock(scene_tex_block);
    } else if ((MenuLoadInfo.request_phase < 0 && MenuLoadInfo.load_phase == 0) || MenuLoadInfo.load_all == 1) {
        if (0 < tex_block) {
            tex_manager->DeleteBlock(tex_block);

            if (MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] != 0) {
                tex_manager->DeleteBlock(scene_tex_block);
            }
        }
    }

    if (MenuLoadInfo.load_all == 0 && MenuLoadInfo.request_phase == 0) {
        if (MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] != 0) {
            DeleteOutLineMenu(scene_chara.entry[0], 0);
        }

        if (chara[0] != NULL) {
            DeleteOutLineMenu(chara[0], 1);
        }
    }

    RoboStackList menu_stack = at_4327;
    RoboStackList scene_stack = at_4328;
    scene_stack.entry[1] = &MorattaStack[1];
    scene_stack.entry[0] = &MorattaStack[0];
    scene_stack.entry[2] = &MorattaStack[2];
    scene_stack.entry[4] = &MorattaStack[3];
    scene_stack.entry[3] = &MorattaStack[2];
    scene_stack.entry[5] = &MorattaStack[2];
    SceneCharaList menu_chara = at_4329;
    menu_chara.entry[0] = chara[0];
    menu_chara.entry[1] = chara[1];
    menu_chara.entry[2] = chara[2];
    menu_chara.entry[3] = chara[3];
    menu_chara.entry[4] = chara[4];
    menu_chara.entry[5] = chara[5];

    for (int part = 0; part < 6; part++) {
        if (info[part] == NULL || info[part]->reading == 0) {
            continue;
        }

        BG_READ_INFO *read = GetReadBGInfo(info[part]->path);

        if (read == NULL) {
            continue;
        }

        u_int         *pack = (u_int *) read->buffer;
        CActionChara **slot = &menu_chara.entry[part];
        info[part]->chara = *slot;

        if (MenuLoadInfo.mode == 2) {
            menu_chara.entry[part] = NULL;
        }

        if (MenuLoadInfo.mode != 2) {
            if (part == 2) {
                strcpy(tex_manager->name_suffix, at_4123);

                if (menu_chara.entry[2] != NULL) {
                    menu_chara.entry[2]->DeleteImage();
                }

                if (menu_chara.entry[3] != NULL) {
                    menu_chara.entry[3]->DeleteImage();
                }

                if (menu_chara.entry[5] != NULL) {
                    menu_chara.entry[5]->DeleteImage();
                }

                tex_manager->name_suffix[0] = 0;

                if (MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] != 0) {
                    if (scene_chara.entry[2] != NULL) {
                        scene_chara.entry[2]->DeleteImage();
                    }

                    if (scene_chara.entry[3] != NULL) {
                        scene_chara.entry[3]->DeleteImage();
                    }

                    if (scene_chara.entry[5] != NULL) {
                        scene_chara.entry[5]->DeleteImage();
                    }
                }
            } else if (part != 3 && part != 5) {
                CActionChara *model = *slot;

                if (model != NULL) {
                    strcpy(tex_manager->name_suffix, at_4123);
                    model->DeleteImage();
                    tex_manager->name_suffix[0] = 0;
                }

                if (MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] != 0 && scene_chara.entry[part] != NULL) {
                    scene_chara.entry[part]->DeleteImage();
                }
            }
        }

        switch (MenuLoadInfo.mode) {
            case 2: {
                if (part > 0) {
                    parent = scene_chara.entry[0];
                }

                part_stack = scene_stack.entry[part];

                if (part != 3 && part != 5 && part_stack != NULL) {
                    part_stack->stReset();
                }

                if (part == 0) {
                    scene_chara.entry[part]->AllDeleteDamage();
                    tex_manager->DeleteTexAnime(tex_block);
                }

                CActionChara *model = scene_chara.entry[part];

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
                strcpy(tex_manager->name_suffix, at_4123);
                CActionChara *model = *slot;

                if (model != NULL) {
                    if (part > 0) {
                        parent = menu_chara.entry[0];
                    }

                    if (part == 0) {
                        tex_manager->DeleteTexAnime(tex_block);
                    }

                    part_stack = menu_stack.entry[part];

                    if (part != 3 && part != 5 && part_stack != NULL) {
                        part_stack->stReset();
                    }

                    part_stack->Align64();
                    model->Initialize(NULL);
                    model->LoadPack(pack, menu_infocfgname, part_stack, part_stack, part_stack, tex_block, parent);
                }

                tex_manager->name_suffix[0] = 0;
                CActionChara *scene_model = scene_chara.entry[part];

                if (scene_model != NULL && MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] != 0) {
                    if (part > 0) {
                        parent = scene_chara.entry[0];
                    }

                    if (part == 0) {
                        tex_manager->DeleteTexAnime(scene_tex_block);
                    }

                    part_stack = scene_stack.entry[part];

                    if (part != 3 && part != 5 && part_stack != NULL) {
                        part_stack->stReset();
                    }

                    scene_model->Initialize(NULL);
                    scene_model->LoadPack(pack, menu_infocfgname, part_stack, part_stack, part_stack, scene_tex_block,
                                          parent);

                    if (CheckBattleLoop()) {
                        if (part == 0) {
                            SetSwordBlurEffect(scene_chara.entry[0], part_stack, 2);
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
                if (scene_chara.entry[0] != NULL) {
                    script_stack->stReset();
                    scene_chara.entry[0]->LoadActionFile((char *) script->buffer, script->size, script_stack);
                }

                break;
            default:
                if (scene_chara.entry[0] != NULL) {
                    script_stack->stReset();
                    scene_chara.entry[0]->LoadActionFile((char *) script->buffer, script->size, script_stack);
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
            strcpy(path, at_4548);
            strcat(path, script);
            strcpy(script_file_name, script);
            LoadFileBG(path, buffer, &size);
            stack->Alloc(blocks_for(size));
        }
    }
    return 1;
}
extern SceneCharaList at_4565;
extern LoadTargetList at_4585;
extern LoadStackList  at_4586;

int MenuMonsterLoadBGCheck(MENU_BGREAD_INFO2 **info, CActionChara **chara, int tex_block,
                           int scene_tex_block) {
    SceneCharaList     scene_chara;
    char               path[0x80];
    char               name[0x20];
    mgCTextureManager *tex_manager = &mgTexManager;
    int                i;

    if (MenuLoadInfo.mode == 2) {
        tex_manager->DeleteBlock(scene_tex_block);
    } else if (0 < tex_block) {
        tex_manager->DeleteBlock(tex_block);
    }

    CScene *scene = MenuMainScene;
    scene_chara = at_4565;

    if (MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] != 0 || MenuLoadInfo.mode == 2) {
        for (i = 0; i < 7; i++) {
            scene_chara.entry[i] = (CActionChara *) scene->GetCharacter(i);
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
        strcpy(tex_manager->name_suffix, at_4123);

        if (chara[0] != NULL) {
            chara[0]->Initialize(NULL);
            chara[0]->LoadPackNoLine(pack, name, buffer, buffer, buffer, tex_block, NULL);
        }

        tex_manager->name_suffix[0] = 0;
    } else {
        info[0]->chara = NULL;
        mgCMemory *stack = MorattaStack;
        stack->stReset();

        if (scene_chara.entry[0] != NULL) {
            scene_chara.entry[0]->AllDeleteDamage();
            scene_chara.entry[0]->Initialize(NULL);
            scene_chara.entry[0]->LoadPack(pack, name, stack, stack, stack, scene_tex_block, NULL);
            SetSwordBlurEffect(scene_chara.entry[0], stack, 3);
        }
    }

    GetCurrentDir(path);
    strcat(path, at_4548);
    strcat(path, script_file_name);
    BG_READ_INFO *script = GetReadBGFile(path);

    if (script != NULL) {
        LoadTargetList targets = at_4585;
        targets.entry[0] = info[0]->chara;
        targets.entry[1] = info[0]->chara;
        targets.entry[2] = scene_chara.entry[0];
        LoadStackList stacks = at_4586;
        stacks.entry[2] = &MorattaStack[5];
        mgCMemory    *stack = stacks.entry[MenuLoadInfo.mode];
        CActionChara *target = targets.entry[MenuLoadInfo.mode];
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
#ifdef NONMATCHING
void MenuItemCharaDataLoadEndCheckAfter(MENU_BGREAD_INFO2 **info, int chara_no) {
    CUserDataManager *userData = MenuUserDataManPtr;
    ROBO_INFO_DATA   *robo = GetRoboPartsInfo(userData);
    if (MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] != 0) {
        SetupUnitMan(MenuMainScene, userData, chara_no, robo);
    }
    if (MenuLoadInfo.mode == 2) {
        return;
    }
    CScene       scene;
    CCharacter2 *chara;
    for (int i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
        chara = NULL;
        int slot = convtbl_4621[chara_no][i];
        if (0 <= slot && info[slot] != NULL) {
            chara = info[slot]->chara;
        }
        scene.DeleteChara(i);
        scene.AssignChara(i, chara, NULL);
    }
    SetupUnitMan(&scene, userData, chara_no, robo);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuItemCharaDataLoadEndCheckAfter__FPP17MENU_BGREAD_INFO2i);
#endif
void InitMainCharaBG(int chara_no, mgCMemory *stack, int mode) {
    int                reason;
    mgCTextureManager *texManager;

    if (stack == NULL) {
        return;
    }
    int activeChara = GetUserDataMan()->active_chr_no;
    texManager = &mgTexManager;
    NowReadMainCharaNo = chara_no;
    texManager->DeleteBlock(MenuCommonInfo->tex_block[0]);
    texManager->EnterTexture(MenuCommonInfo->tex_block[0], at_4789, NULL, 0x80, 0x80, 0x20, NULL, 0, 0);
    NowMainCharaFrameImage = texManager->EnterTexture(MenuCommonInfo->tex_block[0], at_4790, NULL,
                                                      mgScreenWidth, mgScreenHeight, 0x18, NULL, 0, 0);
    SetBGFrameForMenu(MenuCommonInfo->tex_block[0], at_4790);
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
    LoadWantedList wanted = at_4728__2;
    MenuBGReadInfo2Malloc(&memory, wanted.entry);
    memory.Alloc(0x100);
    memory.Align64();
    rest = memory.stGetRest();
    MenuCharaLoadStack.stSetBuffer(memory.stGetTop(), rest);
    NowMainCharaChngTex = texManager->GetTexture(at_4791, -1);
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
    MenuLoadInfo.target_flags[0] = 0;
    MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] = 1;
    NowReadMainChara = (CActionChara *) MenuMainScene->GetCharacter(0);
    if (NowReadMainChara != NULL) {
        NowReadMainChara->GetPosition(NowMainReadPosition);
        NowReadMainChara->GetRotation(NowMainReadRotation);
    }
    MenuUserParam.chara[0] = GetUserDataMan()->GetCharaDataPtr(USER_CHARA_MAX);
    MenuUserParam.chara[1] = GetUserDataMan()->GetCharaDataPtr(USER_CHARA_MONICA);
    MenuUserParam.robo = &GetUserDataMan()->robo_data;
    if ((NowReadMainCharaNo == 1 && activeChara == 3) || NowReadMainCharaNo == 3) {
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
                LoadFileBG(at_4868, MenuCharaLoadStack.stGetTop(), &script_size);
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
            strcpy(tex_manager->name_suffix, at_4950__2);
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
    WornCostumes worn;
    CHARA_DATA  *chara_data;
    int          kind;
    int          index;

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

    worn = *(WornCostumes *) at_4967__2;
    worn.id[0] = chara_data->equip[2].item_no;
    worn.id[1] = chara_data->equip[4].item_no;
    worn.id[2] = chara_data->equip[3].item_no;

    for (kind = 0; kind < 3; kind++) {
        this->costume_select[kind] = 0;

        for (index = 0; index < this->costume_num[kind]; index++) {
            if (worn.id[kind] == this->list[kind][index]) {
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

#ifdef NONMATCHING
void CMenuCostumeSel::LoadMenuData(mgCMemory *stack, int *tex_block) {
    int                i;
    mgCTextureManager *tex_manager;
    u8                *buffer;
    unsigned int       size;
    u8                *icons;
    short             *system_mes;
    int                free_size;

    SetTexBlock(tex_block);

    for (i = 0; i < 7; i++) {
        MenuActionChara[i] = new (stack->Alloc(0x105)) CActionChara;
        MenuActionChara[i]->Initialize(NULL);
    }

    tex_manager = &mgTexManager;
    buffer = memory_free_top(stack);
    size = LoadFileMenu(at_5051, (u_long128 *) buffer, 1);
    stack->Alloc((int) size / 16 + 0x10);
    stack->Align64();
    mgTexManager.EnterIMGFile(buffer, *tex_block, NULL, NULL);
    this->tile_tex = mgTexManager.GetTexture(at_5052, -1);
    icons = (u8 *) GetMenuMainIMGPtr();

    if (icons != NULL) {
        tex_manager->EnterIMGFile(icons, *tex_block, NULL, NULL);
    }

    this->cursor_tex = tex_manager->GetTexture(at_5053, -1);
    this->cursor_x = 0;
    this->cursor_y = 0;
    this->cursor_wave = 0;
    this->cursor_wave_y = 0;
    AttachMessageForm();
    system_mes = GetSystemMesBuffer();
    MenuDCMsg[0]->SetMessData(system_mes, GetMenuMainMessageBuffer());
    MenuDCMsg[0]->MsgPreset(0xA);
    MenuDCMsg[0]->SetAbsPos(8);
    system_mes = GetSystemMesBuffer();
    MenuDCMsg[7]->SetMessData(system_mes, GetMenuMainMessageBuffer());
    MenuDCMsg[7]->MsgPreset(0xB);
    MenuDCMsg[7]->SetAbsPos(8);
    *(int *) &MenuDrawEnv->speed = 0x40000000;
    MenuBGReadInfo2Malloc(stack, tbl_5016);
    MenuLoadInfo.mode = 3;
    MenuLoadInfo.alternate_model = 1;
    MenuLoadInfo.load_all = 1;
    MenuLoadInfo.load_phase = 0;
    MenuLoadInfo.request_phase = -1;
    MenuLoadInfo.chara_no = 0;
    MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] = 0;
    MenuLoadInfo.target_flags[0] = 1;
    free_size = memory_free_size(stack);
    this->stack.stSetBuffer((u_long128 *) memory_free_top(stack), free_size);
    MenuMemoryAdjust(&this->stack, &MenuCharaLoadStack, MenuActionCharaBuffer, 0);
    SetMenuLoadItemNo(0);
    MenuItemCharaDataLoad(&MenuCharaLoadStack, 0, MenuCharaBuild2, 1);

    do {
    } while (ReadBGSync() == 0);

    this->load_wait = 0;
    MenuCosutumeLoadPhase = 2;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", LoadMenuData__15CMenuCostumeSelFP9mgCMemoryPi);
#endif

#pragma inline_depth reset

int CMenuCostumeSel::KeyStep() {
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

                    if (keys & 1) {
                        move_y--;
                    }

                    if (keys & 2) {
                        move_y++;
                    }

                    if (keys & 4) {
                        move_x--;
                    }

                    if (keys & 8) {
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
                            MenuLoadInfo.load_phase = phasetbl_5119[select];
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

                    if (buttons & 2) {
                        wait_load = 0;
                        mode = 2;
                        MenuArg.end_code = 0;
                        MenuCommonInfo->key_enable = 0;
                        FadeOutMenu(40, 0.0f);
                        MenuSePlay(5);
                    } else if (buttons & 1) {
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
#ifdef NONMATCHING
void CMenuCostumeSel::Draw() {
    sceVu0FMATRIX view;
    sceVu0FVECTOR eye;

    if (tile_tex == NULL) {
        return;
    }
    camera.GetCameraMatrix(view);
    camera.GetPos(eye);
    mgSetViewMatrix(view, eye);
    mgCTextureManager *texManager = &mgTexManager;
    texManager->ReloadTexture(tile_tex->block, (sceVif1Packet *) NULL);
    mgCDrawPrim *prim = GetMenuPrim();
    DrawMenuTilePattern(prim, tile_tex, tile_scroll, tile_scroll, mgRect<int>(0x100, 0, 0x100, 0x100), 0,
                        tilergba_5203);
    PrimQuad(prim, tile_tex, 24.0f, 24.0f, mgRect<int>(0, 0xEA, 0xC8, 0x16), 0x80, 0x80, 0x80, 0x80);
    if (MenuCosutumeLoadPhase == 4) {
        texManager->ReloadTexture(tex_block[3], (sceVif1Packet *) NULL);
        MenuActionChara[0]->DrawDirect();
    }
    texManager->ReloadTexture(tile_tex->block, (sceVif1Packet *) NULL);
    mgRect<int> lineRect(0, 0, 0xB0, 0x20);
    mgRect<int> labelRect(0, 0xB6, 0x38, 0x1A);
    mgRect<int> charaRect(0, 0xD0, 0x78, 0x1A);
    mgRect<int> leftRect(0, 0x20, 0x10, 0x16);
    mgRect<int> rightRect(0x10, 0x20, 0x10, 0x16);
    int         i;
    int         cursorY = select * 0x42 + 0x6E;
    int         y = 0x50;
    SetSpriteEnv(prim, 0);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(tile_tex);
    for (i = 0; i < COSTUME_LIST_NUM; i++) {
        int lineY = y + 0x1E;
        prim->Color(0, 0, 0, 0x30);
        PrimQuad(prim, 50.0f, (float) (y + 4), labelRect);
        PrimQuad(prim, 74.0f, (float) (lineY + 4), lineRect);
        float wave = 6.0f * sinf(line_wave[i]);
        if (wave < 0.0f) {
            wave = -wave;
        }
        float leftX;
        float rightX;
        float arrowY;
        rightX = wave + (float) (lineRect.right + 0x49);
        leftX = 55.0f - wave;
        arrowY = (float) (lineY + 3);
        PrimQuad(prim, 4.0f + leftX, 4.0f + arrowY, leftRect);
        PrimQuad(prim, 4.0f + rightX, 4.0f + arrowY, rightRect);
        if (i == select) {
            prim->Color(0xA4, 0xA4, 0xA4, 0x80);
        } else {
            prim->Color(0x80, 0x80, 0x80, 0x80);
        }
        PrimQuad(prim, 46.0f, (float) y, labelRect);
        PrimQuad(prim, 70.0f, (float) lineY, lineRect);
        PrimQuad(prim, leftX, arrowY, leftRect);
        PrimQuad(prim, rightX, arrowY, rightRect);
        labelRect.left += labelRect.right;
        y += 0x42;
    }
    int charaY = y + 0xA;
    int exitY = charaY + 0x28;
    if (mode == 0 && (step == 0 || step == 3)) {
        prim->Color(0, 0, 0, 0x30);
        PrimQuad(prim, 116.0f, (float) (charaY + 4), charaRect);
        if (select == 3) {
            prim->Color(0xA4, 0xA4, 0xA4, 0x80);
        } else {
            prim->Color(0x80, 0x80, 0x80, 0x80);
        }
        PrimQuad(prim, 112.0f, (float) charaY, charaRect);
        if (chara == 1) {
            mgRect<int> exitRect(0, 0x9C, 0xAA, 0x1A);
            prim->Color(0, 0, 0, 0x30);
            PrimQuad(prim, 78.0f, (float) (exitY + 4), exitRect);
            if (select == 4) {
                prim->Color(0xA4, 0xA4, 0xA4, 0x80);
            } else {
                prim->Color(0x80, 0x80, 0x80, 0x80);
            }
            PrimQuad(prim, 74.0f, (float) exitY, exitRect);
        }
    }
    prim->End();
    float cursorX = 0.0f;
    if (select == 3) {
        cursorX = 70.0f;
        cursorY = charaY;
    }
    if (select == 4) {
        cursorX = 32.0f;
        cursorY = exitY;
    }
    CalcMenu1(cursorX, &cursor_x, 4.0f, 0.0f, 0);
    CalcMenu1((float) cursorY, &cursor_y, 4.0f, 0.0f, 0);
    if (cursor_tex != NULL && cursor_show) {
        float cursorPos[2];
        cursorPos[0] = cursor_x + 6.0f * cosf(cursor_wave);
        cursorPos[1] = cursor_y + 4.0f * sinf(cursor_wave_y);
        MenuCursorDraw(cursor_tex, cursorPos, 0.0f, 0, 0x80, 1.0f);
        cursor_wave += 0.05235988f;
        cursor_wave_y += 0.10471976f;
        if (!(cursor_wave < 3.1415927f)) {
            cursor_wave -= 6.2831855f;
        }
        if (!(cursor_wave_y < 3.1415927f)) {
            cursor_wave_y -= 6.2831855f;
        }
    }
    texManager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
    int nameY = 0x72;
    if (chara_data != NULL) {
        CMenuFont font;
        for (i = 0; i < COSTUME_LIST_NUM; i++) {
            char *name = chara_data->equip[convtbl_5238[i]].GetName(1);
            if (name != NULL) {
                font.SetStr(name);
                font.SetPos(0x4E, nameY);
                font.DrawDirect(font.str, font.pos_x, font.pos_y);
            }
            nameY += 0x42;
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
        DrawMenuFillBox(36.0f, (float) mgScreenHeight - 40.0f - 8.0f, putw_5262[LanguageCode], 32.0f, 0x40, 0, 0,
                        0);
        CMenuFont help;
        help.DrawDirect(infomsg_5256[LanguageCode], 0x28, mgScreenHeight - 0x28);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", Draw__15CMenuCostumeSelFv);
#endif
extern u_long CostumeOptionEnv;
#ifdef NONMATCHING
void MenuCostumeInit(mgCMemory *stack, int *tex_block, int mode) {
    MenuChangeMemory.stSetBuffer(stack->stGetTop(), stack->stGetRest());
    MenuCosPtr = new (MenuChangeMemory.Alloc(0x2F)) CMenuCostumeSel;
    MenuCosutumeLoadPhase = 0;
    MenuCosPtr->chara_data = GetUserDataMan()->GetCharaDataPtr(USER_CHARA_MAX);
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuCostumeInit__FP9mgCMemoryPii);
#endif
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
    char   local_area_names[2][32];
    int    weak_list[8];
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

        *(MonsterBookBlock64 *) local_area_names = *(MonsterBookBlock64 *) at_5452;

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
                this->strong_bit = this->strong_bit | stand_bit_5472[j];
            }

            if (monster->ext_param[j] < 51) {
                this->weak_bit = this->weak_bit | stand_bit_5472[j];
            }
        }

        weak_count = 0;
        *(MonsterBookBlock32 *) weak_list = *(MonsterBookBlock32 *) at_5482;

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
    size = LoadFileMenu(at_5558__2, (u_long128 *) buffer, 1);
    MosBookStack.Alloc(blocks_for(size));
    mgTexManager.EnterIMGFile((u8 *) GetPackFile((unsigned int *) buffer, at_5559__2, NULL),
                              this->tex_block[0], NULL, NULL);
    Tex_MBase = mgTexManager.GetTexture(at_3271, -1);
    Tex_MBook = mgTexManager.GetTexture(at_5560__2, -1);
    Tex_MBg = mgTexManager.GetTexture(at_5561, -1);
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
    Menu3DivideTextureDraw(prim, mgRect<int>(0x1A, 0x4B, 0x1CC, 0x24), tiletbl_5573[0], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x1A, 0x6F, 0x1CC, 0x116), tiletbl_5573[1], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x1A, 0x185, 0x1CC, 0x24), tiletbl_5573[2], 1);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x16, 0x47, 0x1CC, 0x24), tiletbl_5573[0], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x16, 0x6B, 0x1CC, 0x116), tiletbl_5573[1], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x16, 0x181, 0x1CC, 0x24), tiletbl_5573[2], 1);
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
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset_5577[1][0] + 0x16,
        put_under_offset_5577[1][1] + 0x47, 0x52, 0x20), under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset_5577[1][0] + 0x6E,
        put_under_offset_5577[1][1] + 0x47, 0x52, 0x20), under_brdtbl_5576, 1);
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
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset_5577[3][0] + 0x16 - box_shift,
        put_under_offset_5577[3][1] + 0x47, box_width, 0x20), under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset_5577[5][0] + 0x16 - box_shift,
        put_under_offset_5577[5][1] + 0x47, box_width, 0x20), under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset_5577[7][0] + 0x16 - box_shift,
        put_under_offset_5577[7][1] + 0x47, box_width, 0x20), under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset_5577[9][0] + 0x16 - box_shift,
        put_under_offset_5577[9][1] + 0x47, box_width, 0x20), under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset_5577[9][0] + 0x16 - box_shift,
        put_under_offset_5577[9][1] + 0x69, box_width, 0x20), under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset_5577[9][0] + 0x16 - box_shift,
        put_under_offset_5577[9][1] + 0x8B, box_width, 0x20), under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(put_under_offset_5577[11][0] + 0x16 - last_shift,
        put_under_offset_5577[11][1] + 0x47, last_width, 0x20), under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x140, 0x27, 0x9C, 0x20), under_brdtbl_5576, 1);
    prim->End();
    prim->Begin(MG_PRIM_SPRITE);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    prim->Texture(Tex_MBook);
    PrimQuad(prim, 18.0f, 16.0f, mgRect<int>(0, 0, 0xA8, 0x16));
    int base_x = put_under_offset_5577[0][0] + 0x16;
    int base_y = put_under_offset_5577[0][1] + 0x47;
    PrimQuad(prim, (float) base_x, (float) (put_under_offset_5577[0][1] + 0x47), mgRect<int>(0, 0x82, 0xB0, 0x12));
    PrimQuad(prim, (float) (base_x + 0xB), (float) (base_y + 0x19), mgRect<int>(0xC, 0x2C, 0xC, 0x10));
    PrimQuad(prim, (float) (base_x + 0x5E), (float) (base_y + 0x15), mgRect<int>(0xC, 0x16, 0x14, 0x16));
    PrimQuad(prim, (float) (put_under_offset_5577[2][0] + 0x16),
        (float) (put_under_offset_5577[2][1] + 0x47), mgRect<int>(0, 0x94, 0xB0, 0x12));
    PrimQuad(prim, (float) (put_under_offset_5577[4][0] + 0x16),
        (float) (put_under_offset_5577[4][1] + 0x47), mgRect<int>(0, 0xA6, 0xB0, 0x12));
    PrimQuad(prim, (float) (put_under_offset_5577[6][0] + 0x16),
        (float) (put_under_offset_5577[6][1] + 0x47), mgRect<int>(0, 0xB8, 0xB0, 0x12));
    PrimQuad(prim, (float) (put_under_offset_5577[8][0] + 0x16),
        (float) (put_under_offset_5577[8][1] + 0x47), mgRect<int>(0, 0xCA, 0xB0, 0x12));
    PrimQuad(prim, (float) (put_under_offset_5577[10][0] + 0x16),
        (float) (put_under_offset_5577[10][1] + 0x47), mgRect<int>(0, 0xDC, 0xB0, 0x12));
    PrimQuad(prim, (float) (put_under_offset_5577[12][0] + 0x16),
        (float) (put_under_offset_5577[12][1] + 0x47), mgRect<int>(0, 0xEE, 0xB0, 0x12));
    int icon_x = put_under_offset_5577[4][0] + 0x1D;
    int strong_y = put_under_offset_5577[4][1] + 0x5C;
    for (int i = 0; i < MOS_BOOK_AFFINITY_NUM; i++) {
        if (strong_bit & (1 << i)) {
            PrimQuad(prim, (float) icon_x, (float) strong_y,
                mgRect<int>(ic_5580[i][0], ic_5580[i][1], 0x16, 0x16));
            icon_x += 0x16;
        }
    }
    int weak_i = 0;
    icon_x = put_under_offset_5577[4][0] + 0x1D;
    int weak_y = put_under_offset_5577[4][1] + 0x8E;
    for (; weak_i < MOS_BOOK_AFFINITY_NUM; weak_i++) {
        if (weak_bit & (1 << weak_i)) {
            PrimQuad(prim, (float) icon_x, (float) weak_y,
                mgRect<int>(ic_5580[weak_i][0], ic_5580[weak_i][1], 0x16, 0x16));
            icon_x += 0x16;
        }
    }
    Menu3DivideTextureDraw(prim, mgRect<int>(0xFB, 0x55, 0xC, 0x13C), line_5595, 0);
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
    Menu3DivideTextureDraw(prim, mgRect<int>(0x20, 0x55, frame_width, 0x36), wakutbl_5600[0], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x20, 0x8B, frame_width, 0x92), wakutbl_5600[1], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x20, 0x11D, frame_width, 0x32), wakutbl_5600[2], 1);
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
    int name_height, name_width;
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
    int number = select + 1;
    if (list_num <= 0) {
        number = 0;
    }
    sprintf(position, monstere_file_template[LanguageCode], number, list_num);
    font.SetStr(position);
    font.SetPos(0x14C, 0x2D);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
}

#pragma inline_depth(8)

#ifdef NONMATCHING
int CMosBookMenu::KeyStep() {
    int   select;
    int   lr;
    int   push;
    int   fade;
    int   cmd;
    int   i;
    float scroll;
    float half;

    select = MenuCommonInfo->CheckSelectKey();
    lr = MenuCommonInfo->CheckLRKey();
    push = MenuCommonInfo->CheckPushButton();
    fade = FadeCheckMenu();
    cmd = -1;

    switch (this->mode) {
        case kBookFadingIn:
            if (fade != 0) {
                this->mode = kBookBrowsing;
                MenuCommonInfo->key_enable = 1;
                this->load_phase = 1;
            }

            break;
        case kBookFadingOut:

            if (fade != 0) {
                DeleteTexBlock();

                if (MonsterBookBootMode == 1) {
                    return 2;
                }

                return 1;
            }

            break;
        case kBookBrowsing:
            if ((lr & 0x10) || (lr & 0x20) || (select & 4) || (select & 8)) {
                cmd = kCmdTurnPage;

                if (select & 4) {

                    this->select -= 1;
                }

                if (select & 8) {

                    this->select += 1;
                }

                if ((lr & 0x40) || (lr & 0x10)) {

                    this->select -= 10;
                }

                if ((lr & 0x80) || (lr & 0x20)) {

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
            } else if (push & 2) {
                cmd = kCmdClose;
                MenuSePlay(5);
            } else if (menu_debug_flag != 0) {
                if (push & 4) {
                    for (i = 0; i < kMonsterMemoCount; i++) {
                        if (i != 0x30 && i != 0x44) {
                            KillMonsterCount(i, 1);
                        }
                    }

                    MenuSePlay(1);
                }
            }

            break;
    }

    if (0 <= cmd) {
        switch (cmd) {
            case kCmdClose:
                this->mode = kBookFadingOut;
                ((CBaseMenuClass *) this)->FadeOutMenu(0x3C, 0.0f);
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
                float x = -12.8f;
                float y = -6.6f;
                float z = 0.0f;
                x = x;
                y = y;
                z = z;
                this->monster->SetPosition(x, y, z);
                this->monster->SetMotion(at_5839, 0, 1);
                MonsterScaleCheck((CCharacter2 *) this->monster);
            }

            break;
        case 4:
            this->skip_draw ^= 1;

            if (this->skip_draw !=
                0) {
                this->monster
                    ->Step();
            }

            this->show_wait += 1;

            if (this->show_wait > kModelFrameCap) {

                this->show_wait = kModelFrameCap;
            }

            break;
    }

    half = 0.5f;
    scroll = this->bg_scroll + half;
    this->bg_scroll = scroll;

    if (0.0f <= scroll) {
        this->bg_scroll = scroll - 256.0f;
    }

    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", KeyStep__12CMosBookMenuFv);
#endif

#pragma inline_depth reset

void MonsterBookInit(mgCMemory *stack, int *tex_block, int mode) {
    CMosBookMenu *book;
    int           size;

    size = stack->stGetRest();
    MosBookStack.stSetBuffer(stack->stGetTop(), size);

    book = new (MosBookStack.Alloc(0x9A)) CMosBookMenu;

    MenuMosBookPtr = book;
    book->SetTexBlock(tex_block);
    MonsterBookPtr = (u8 *) &GetSaveData()->monster_book;
    MonsterBookBootMode = mode;
    MenuBGReadInfo2Malloc(&MosBookStack, tbl_5848);
    MenuLoadInfo.mode = 4;
    MenuLoadInfo.load_all = 1;
    MenuLoadInfo.target_flags[MENU_LOAD_TARGET_SCENE] = 0;
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
        font.SetStr(at_5893);
        font.SetPos(20, 40);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
    }
}

/**
 *
 * Short rectangle used for screen positions and bounds.
 *
 */
class mgRect_s_ {
public:
    short left;   /**< Left edge. */
    short top;    /**< Top edge. */
    short right;  /**< Right edge. */
    short bottom; /**< Bottom edge. */

    /** Sets the four sides of the rectangle. */
    void Set(short x, short y, short w, short h);
};

void mgRect_s_::Set(short x, short y, short w, short h) {
    left = x;
    top = y;
    right = w;
    bottom = h;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", monster_progress_tbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", tbl_992__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", tbl_1233__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1372__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", nextIDtbl_1594__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", partt_2332__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", tbl_2483__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2629__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2691__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2696__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", overcode_3172__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", tbl_3186__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", posdef_3194__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", refdef_3195__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", tbl_3196__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", convert_table_3430__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", ghobitbl_3437__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3481__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", get_stringtbl_3557__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", tbl_3725__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", menu_load_chrpathtbl_3811__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", menu_infocfgname__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4327__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", MonsterDataPath__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4586__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", convtbl_4621__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4728__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4967__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", tbl_5016__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", infomsg_5256__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", putw_5262__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", monster_type_name__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", monster_jyakuten__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", monstere_file_template__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5452__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", stand_bit_5472__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", tbl_5848__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1104__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1131__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1132__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1133__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1134__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1135__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1171__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1172__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1173__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1174__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1175__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1176__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1177__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1178__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1179__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1180__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1181__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1234__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1235__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1236__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1237__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1276__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1277__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1278__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1279__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1280__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1281__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1282__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1283__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1284__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1285__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1304__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1319__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1361__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1402__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2003__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2004__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2005__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2006__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2007__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2008__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2009__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2010__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2011__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2012__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2013__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2014__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2015__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2016__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2017__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2018__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2019__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2020__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2021__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2022__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2023__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2191__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2192__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2193__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2194__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2195__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2196__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2197__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2286__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2287__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2303__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2304__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2305__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2306__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2307__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2333__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2334__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2335__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2336__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2337__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2338__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2363__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2364__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2365__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2595__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2596__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2662__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2770__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2771__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2772__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2773__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2774__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2775__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2776__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2777__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2778__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2779__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2780__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2781__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2782__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2783__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2784__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2785__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2912__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2913__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2914__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2915__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2916__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2917__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2918__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2940__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2941__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2942__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2943__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2944__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3160__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3161__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3162__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3163__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3164__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3165__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3166__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3197__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3198__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3199__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3200__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3201__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3202__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3269__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3270__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3271__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3272__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3273__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3274__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3275__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3276__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3558__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3559__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3560__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3561__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3685__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3686__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3687__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3688__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3689__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3690__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3691__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3692__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3693__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3694__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3695__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3696__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3697__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3698__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3699__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3700__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3701__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3702__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3703__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3704__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3705__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3706__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3707__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3708__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3726__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3727__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3728__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3729__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3730__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3731__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3732__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3733__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3734__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3735__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3736__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3737__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3779__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3780__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3790__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3791__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3792__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3793__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3794__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3812__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3813__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3814__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3913__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3969__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3970__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4123__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4186__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4276__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4277__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4278__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4296__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4517__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4518__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4519__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4520__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4548__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4789__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4790__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4791__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4868__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4950__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5051__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5052__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5053__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5197__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5257__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5258__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5259__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5260__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5261__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5356__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5357__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5358__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5359__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5360__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5361__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5362__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5363__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5364__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5365__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5366__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5367__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5368__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5369__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5370__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5371__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5372__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5373__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5374__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5375__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5376__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5377__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5378__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5379__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5380__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5381__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5382__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5383__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5384__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5385__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5386__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5387__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5388__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5389__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5390__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5391__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5392__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5393__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5394__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5395__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5396__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5397__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5398__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5399__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5400__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5401__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5402__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5403__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5404__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5405__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5406__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5407__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5408__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5409__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5410__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5411__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5412__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5413__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5414__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5415__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5416__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5417__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5418__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5419__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5420__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5421__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5422__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5423__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5424__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5425__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5426__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5427__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5428__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5429__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5430__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5431__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5432__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5433__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5434__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5435__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5558__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5559__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5560__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5561__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5839__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_5893__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", __vt__12CMosBookMenu__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", __vt__15CMenuCostumeSel__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", __vt__14CMenuMosSelect__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", __vt__15CMenuChrCngMenu__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", MenuSoundCharaNo__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", msgtbl1_1732__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", se_sndtbl_1749__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", cursor_revtbl_2237__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_2288__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", max_3170__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", viewnum_3171__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", menu_chara_chrtbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", menu_chara_cfg_chrtbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3810__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", pathtbl_3836__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_4158__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", convItoPhase_4229__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", monster_load_id__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", NowReadMainCharaNo__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", NowReadMainCharaMonsterNo__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", phasetbl_5119__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", tilergba_5203__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", convtbl_5238__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(MorattaStack, 0x4);
INCLUDE_BSS(MenuLoadInfo, 0x8);
INCLUDE_BSS(MenuCharaChangeBase_Tex, 0x4);
INCLUDE_BSS(MenuCharaChangeCLUT_Tex, 0x4);
INCLUDE_BSS(MenuCharaChangeStar_Tex, 0x4);
INCLUDE_BSS(MenuCharaChangeCLUT, 0x4);
INCLUDE_BSS(MenuCharaChangePosDataCfgBuffer, 0x4);
INCLUDE_BSS(menu_debug_npcselect, 0x4);
INCLUDE_BSS(menu_debug_npc_decide, 0x4);
INCLUDE_BSS(MenuDebugChangeSelectMode, 0x4);
INCLUDE_BSS(MenuDebugCharaChangeSelect, 0x4);
INCLUDE_BSS(SelectedCmdNo_1415, 0x4);
INCLUDE_BSS(init_1416, 0x4);
INCLUDE_BSS(at_1650__2, 0x4);
INCLUDE_BSS(at_1684__2, 0x8);
INCLUDE_BSS(MenuGetPartySeFlag, 0x8);
INCLUDE_BSS(at_2232, 0x8);
INCLUDE_BSS(at_2289__2, 0x8);
INCLUDE_BSS(ChrChangMenuPt, 0x8);
INCLUDE_BSS(at_2371__4, 0x8);
INCLUDE_BSS(MenuMosTexture, 0x4);
INCLUDE_BSS(CharaSndBuffer, 0x4);
INCLUDE_BSS(mos_effect_henge_param, 0x4);
INCLUDE_BSS(mos_effect_read_num, 0x4);
INCLUDE_BSS(MenuMosSelectPtr, 0x4);
INCLUDE_BSS(menu_debug_select__2, 0x4);
INCLUDE_BSS(select_monster_save_3371, 0x4);
INCLUDE_BSS(init_3372__2, 0x4);
INCLUDE_BSS(at_3412, 0x4);
INCLUDE_BSS(at_3440, 0x4);
INCLUDE_BSS(NowReadMainCharaPhase, 0x4);
INCLUDE_BSS(NowReadMainChara, 0x4);
INCLUDE_BSS(NowMainCharaChngTex, 0x4);
INCLUDE_BSS(NowMainCharaChngTexMoveX, 0x4);
INCLUDE_BSS(NowMainCharaChngTexMovePhase, 0x4);
INCLUDE_BSS(NowMainCharaFrameImage, 0x4);
INCLUDE_BSS(NowMainCharaChngStatusBit, 0x4);
INCLUDE_BSS(MenuNPCLoadFlag, 0x4);
INCLUDE_BSS(MenuPartyNPCModelReadBuffer, 0x4);
INCLUDE_BSS(MenuCosutumeLoadPhase, 0x4);
INCLUDE_BSS(CostumeAttr, 0x8);
INCLUDE_BSS(MenuCosPtr, 0x4);
INCLUDE_BSS(MonsterBookPtr, 0x4);
INCLUDE_BSS(Tex_MBook, 0x4);
INCLUDE_BSS(Tex_MBase, 0x4);
INCLUDE_BSS(Tex_MBg, 0x4);
INCLUDE_BSS(MonsterBookBootMode, 0x4);
INCLUDE_BSS(MenuMosBookPtr, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(MenuCharaBuild2, 0x1C);
INCLUDE_BSS(D_01F3C7FC, 0x4);
INCLUDE_BSS(MenuActionChara, 0x20);
mgCMemory MenuActionCharaBuffer[MENU_CHARA_LOAD_MAX];
INCLUDE_BSS(MenuLoadItemNo, 0x20);
INCLUDE_BSS(at_1083__2, 0x20);
mgCMemory MenuChangeMemory;
mgCMemory MenuChangeNpcMemory;
mgCMemory ChrChangeInitTextureStack;
INCLUDE_BSS(at_1806__2, 0x20);
INCLUDE_BSS(at_2372__4, 0x20);
INCLUDE_BSS(at_2674, 0x80);
INCLUDE_BSS(at_2675, 0x80);
INCLUDE_BSS(at_2676, 0x80);
mgCMemory MenuMonChangeLoadStack;
mgCMemory MenuMosBuildStack;
mgCMemory MenuMosLoadStack;
INCLUDE_BSS(MenuMonsterBGInfo, 0x20);
INCLUDE_BSS(mos_effect_readbuff1, 0x10);
INCLUDE_BSS(mos_effect_readbuff2, 0x10);
INCLUDE_BSS(mos_effect_readbuff1_size, 0x10);
INCLUDE_BSS(mos_effect_readbuff2_size, 0x10);
INCLUDE_BSS(at_3054__2, 0x20);
INCLUDE_BSS(at_3511, 0x20);
INCLUDE_BSS(at_3529, 0x20);
INCLUDE_BSS(at_3554, 0x20);
mgCMemory SwordEffectStack;
INCLUDE_BSS(at_3974, 0x20);
INCLUDE_BSS(at_3975, 0x20);
INCLUDE_BSS(at_3993, 0x20);
INCLUDE_BSS(at_4300__2, 0x20);
INCLUDE_BSS(at_4328, 0x20);
INCLUDE_BSS(at_4329, 0x20);
INCLUDE_BSS(script_file_name, 0x20);
INCLUDE_BSS(at_4565, 0x20);
INCLUDE_BSS(at_4585, 0x10);
INCLUDE_BSS(NowMainReadPosition, 0x10);
INCLUDE_BSS(NowMainReadRotation, 0x10);
mgCMemory MosBookStack;
INCLUDE_BSS(at_5482, 0x20);
