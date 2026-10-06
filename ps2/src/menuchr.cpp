#include "mapselect.hpp"
#include "monster.hpp"
#include "npccfg.hpp"
#include "charasetup.hpp"
#include "dynamicanime.hpp"
#include "sound.hpp"
#include "dataread.hpp"
#include "prespr.hpp"
#include "mg_drawprim.hpp"
#include <cstdio>
#include <cstring>
#include <cmath>
#include <cstdlib>
#include "effscript.hpp"
#include "map.hpp"
#include "font.hpp"
#include "sysmes.hpp"
#include "scenesnd.hpp"
#include "savedata.hpp"
#include "userdata.hpp"
#include "gamedata.hpp"
#include "scriptinterpreter.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mainloop.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "menumain.hpp"
#include "menuaqua.hpp"
#include "common.h"
#include "menuchr.hpp"

extern void *__vt__9mgCObject[];
extern void *__vt__7CObject[];
extern void *__vt__12CObjectFrame[];
extern void *__vt__11CCharacter2[];
extern void *__vt__12CActionChara[];
extern "C" void *__ct__10CRunScriptFv(void *);

static inline CActionChara *NewMenuActionChara(mgCMemory *stack) {
    CActionChara *chara;
    if ((chara = (CActionChara *)operator new(sizeof(CActionChara), (u_long128 *)stack->Alloc(0x105))) != NULL) {
        *(void **)chara = __vt__9mgCObject;
        ((mgCObject *)chara)->Initialize();
        *(void **)chara = __vt__7CObject;
        ((mgCObject *)chara)->Initialize();
        *(void **)chara = __vt__12CObjectFrame;
        ((mgCObject *)chara)->Initialize();
        *(void **)chara = __vt__11CCharacter2;
        chara->shadow_link.num = 0;
        chara->shadow_link.dst_frame = 0;
        chara->shadow_link.src_frame = 0;
        ((mgCObject *)chara)->Initialize();
        *(void **)chara = __vt__12CActionChara;
        __ct__10CRunScriptFv(&chara->script);
        memset(&chara->move_check, 0, sizeof(chara->move_check));
    }
    return chara;
}

union WornCostumes {
    int id[4];
    u_long128 qw;
};
static inline int stack_free_size(mgCMemory *memory) {
    return memory->stack_size - memory->stack_used;
}
static inline u8 *stack_free_top(mgCMemory *memory) {
    return (u8*)(memory->stack + memory->stack_used);
}
static inline int memory_free_size(mgCMemory *memory) {
    return memory->stack_size - memory->stack_used;
}
static inline u8 *memory_free_top(mgCMemory *memory) {
    return (u8*)(memory->stack + memory->stack_used);
}
static inline void SetMemoryName(mgCMemory *memory, char *name) {
    if (strlen(name) < sizeof(memory->name)) {
        strcpy(memory->name, name);
    }
}
static inline void SetFormPoint(CMenuPosDataForm *form, int x, int y) {
    form->x = x;
    form->y = y;
}
static inline unsigned int blocks_for(unsigned int size) {
    return (size & 0xF) != 0 ? (size >> 4) + 1 : size >> 4;
}
const int kMonsterMemoCount = 0x119;
const int kModelDelayFrames = 20;
const int kModelFrameCap = 20;
enum { kBookBrowsing = 0, kBookFadingIn = 1, kBookFadingOut = 2 };
enum { kCmdClose = 0xA, kCmdTurnPage = 0x64 };
enum { kEnvStepSunMoon = 0x38, kTimeBandNight = 2 };
extern "C" void *__ct__9mgCCameraFf(void *, float);

extern short tbl_992[];
extern "C" int ClearBaseFromLevel__16CEffectScriptManFiPii(void *, int, int *, int);
extern "C" int ClearEffectFromChrid__16CEffectScriptManFi(void *, int);
extern signed char MenuNPCLoadFlag;
extern "C" int stSetBuffer__9mgCMemoryFP1i(mgCMemory *memory, void *buffer, int size);
extern "C" void *__ct__14CBaseMenuClassFv(void *self);
extern "C" void MenuMainFrameStep__Fv(void);
extern "C" void MenuBGReadInfo2Malloc__FP9mgCMemoryPi(mgCMemory *, int *);
extern "C" void MenuMainFrameModeSet__Fii(int, int);
extern int mos_effect_read_num;
extern "C" void BuildBase__16CEffectScriptManFPcP1iP1iP9mgCMemoryi(CEffectScriptMan *manager,
                                                                   char *name, int pathFile,
                                                                   int pathSize, int packFile,
                                                                   int packSize, int memory,
                                                                   int level);
extern "C" int DeleteBlock__17mgCTextureManagerFi(void *, int);
extern "C" int GetPutPosXY__16CMenuPosDataFormFPcRiRi(CMenuPosDataForm *, char *, int *, int *);
extern "C" void MenuPosStep__12CMenuKeyFuncFPiPi(CMenuKeyFunc *, int *, int *);
extern "C" void MenuSetPos__12CMenuKeyFuncFii(CMenuKeyFunc *, int, int);
extern "C" int MenuGlidKeyCheck__FiPiPiPiPiPii(int, int *, int *, int *, int *, int *, int);
extern "C" void GetCharacterSnd__FP16CUserDataManageriPc(CUserDataManager *, int, char *);
extern "C" int GetMonsterModelFile__FiiPc(int, int, char *);
extern "C" void sndInitPort__Fi(int);
extern "C" int sndLoadSound__FiPUiP9mgCMemory(int, u32 *, mgCMemory *);
extern "C" void *GetGameDataPt__Fv(void);
void SetupUnitMan(CScene *scene, CUserDataManager *userData, int unit, ROBO_INFO_DATA *robo);
void GetBajjiPosition(CMenuPosDataForm *form, int slot, int unused, int *pos);
void SetSwordBlurEffect(CCharacter2 *chara, mgCMemory *stack, int blur_type);

struct temp_v0_champs_a42004 {
    char pad0[0xF4];
      struct unkF4_champs_a42004 *unkF4;
};
struct unkF4_champs_a42004 {
    char pad0[0x18];
      int unk18;
};
struct MonsterBookBlock64 {
    u_long128 q[4];
};
struct MonsterBookBlock32 {
    u_long128 q[2];
};
struct MemoryList {
    mgCMemory *entry[7];
};
struct SceneCharaList {
    CActionChara *entry[7];
};
struct LoadTargetList {
    CActionChara *entry[3];
};
struct LoadStackList {
    mgCMemory *entry[3];
};
struct CharaPathKinds {
    s8 kind[MENU_CHARA_LOAD_MAX];
};
struct LoadWantedList {
    int entry[9];
};
struct RingCenter {
    float x;
    float y;
};
struct QuadTexCoords {
    float uv[4][2];
};
struct CameraPoint {
    float xyzw[4];
};
struct LoadTargetList8 {
    CActionChara *entry[8];
};
struct RoboCharaList {
    CActionChara *entry[6];
};
struct RoboStackList {
    mgCMemory *entry[6];
};
struct DebugLine {
    char text[0x80];
};
struct DebugText {
    char text[0x200];
};
struct DebugNpcText {
    char text[0x100];
};
struct MonsterNameList {
    char *name[1];
};
struct MenuCommandList {
    int mes[8];
};
struct MonsterNameTable {
    char *name[8];
};
struct BadgeInfoValues {
    int value[6];
};
struct SmallPair {
    int v[2];
};
struct FileNameBuf {
    char text[0x40];
};
struct NamePair {
    char *a;
    char *b;
};
extern "C" char at_2940[];
extern "C" char at_2941[];
extern "C" char at_2942[];
extern "C" char at_2943[];
extern "C" char at_2944[];
extern "C" MENUFORMPARTS_TYPE *GetPartInfo__16CMenuPosDataFormFPc(CMenuPosDataForm *, char *);
extern MOS_HENGE_PARAM *mos_effect_henge_param;
extern u8 *mos_effect_readbuff1[4];
extern int mos_effect_readbuff1_size[4];
extern u8 *mos_effect_readbuff2[4];
extern int mos_effect_readbuff2_size[4];
extern int max_3170;
extern int viewnum_3171;
extern int overcode_3172[4];
extern CMenuMosSelect *MenuMosSelectPtr;
extern "C" char at_3779[];
extern "C" char at_3780[];
extern "C" int GetTimeBand__Ff(float hour);
extern "C" int GetMenuMainFrameEndFlag__Fv();
extern "C" char at_3790[];
extern int MenuSoundCharaNo;
extern float at_4158;
extern "C" char *GetItemFileName__Fii(int, int);
extern "C" char *GetItemFilePath__Fii(int, int);
extern "C" char at_4186__2[];
extern "C" u8 *GetReadBGInfo__FPc(char *);
extern char at_4123[];
extern "C" char at_4296[];
extern "C" u8 at_4517__2[];
extern "C" int SearchFrame__8mgCFrameFPc(...);
extern mgCTexture *NowMainCharaChngTex;
extern mgCTexture *NowMainCharaFrameImage;
extern short NowMainCharaChngStatusBit;
extern int NowMainCharaChngTexMovePhase;
extern int NowMainCharaChngTexMoveX;
extern short NowReadMainCharaNo;
extern u8 *MenuPartyNPCModelReadBuffer;
extern short MenuCosutumeLoadPhase;
extern mgCMemory MenuChangeMemory;
extern unsigned long CostumeAttr;
extern CMenuCostumeSel *MenuCosPtr;
extern mgCMemory MosBookStack;
extern CMosBookMenu *MenuMosBookPtr;
extern u8 *MonsterBookPtr;
extern short MonsterBookBootMode;
extern mgCTexture *Tex_MBase;
extern mgCTexture *Tex_MBook;
extern mgCTexture *Tex_MBg;
extern u32 stand_bit_5472[];
extern char *monster_type_name[][12];
extern char *monster_jyakuten[][8];
extern char at_4950__2[];
extern char menu_infocfgname[];
extern u8 at_4967__2[16];
extern char at_5051[];
extern char at_5052[];
extern char at_5053[];
extern int tbl_5016[];
extern u8 at_5452[64];
extern u8 at_5482[32];
extern char at_5558__2[];
extern char at_5559__2[];
extern char at_3271[];
extern char at_5560__2[];
extern char at_5561[];
extern char at_5839[];
extern char at_5893[];
extern int tbl_5848[];
extern void *__vt__12CMosBookMenu[];
extern CDC2Mes *MenuDCMsg[9];
extern MemoryList at_1083__2;
extern char at_1104__4[];
extern char at_1131__3[];
extern char at_1132__5[];
extern char at_1133__4[];
extern char at_1134__3[];
extern char at_1135__3[];
extern "C" int fptosi(float value);
extern "C" char at_1319[11];
extern "C" char at_1361[];
extern char at_2287[];
extern char at_3969[];
extern s8 convtbl_4621[][MENU_CHARA_LOAD_MAX];
extern SceneCharaList at_3054__2;
extern mgCMemory MenuMonChangeLoadStack;
extern MENU_BGREAD_INFO2 *MenuMonsterBGInfo[8];
extern CharaPathKinds at_3810;
extern s8 pathtbl_3836[2];
extern char *menu_chara_chrtbl[2];
extern char *menu_chara_cfg_chrtbl[2];
extern char *menu_load_chrpathtbl_3811[];
extern char at_3913[];
extern LoadWantedList at_4728__2;
extern char at_4789[];
extern char at_4790[];
extern char at_4791[];
extern short NowReadMainCharaPhase;
extern CActionChara *NowReadMainChara;
extern short NowReadMainCharaMonsterNo;
extern sceVu0FVECTOR NowMainReadPosition;
extern sceVu0FVECTOR NowMainReadRotation;
extern char at_4868[];
extern RingCenter at_2371__4;
extern QuadTexCoords at_2372__4;
extern char at_1276__3[];
extern char at_1277__3[];
extern char at_1278__3[];
extern char at_1279__4[];
extern char at_1280__3[];
extern char at_1281__5[];
extern char at_1282__5[];
extern char at_1283__4[];
extern char at_1284__4[];
extern char at_1285__2[];
extern char *tbl_1233[4];
extern u32 *MenuCharaChangeCLUT;
extern void *__vt__14CMenuMosSelect[];
extern "C" void *__ct__7CDC2MesFv(void *mes);
extern "C" void *__ct__6ClsMesFv(void *mes);
extern "C" void *__ct__12CObjectFrameFv(void *frame);
extern "C" void Initialize__19CCharaFrameMatchingFv(void *matching);
extern int tbl_3186[MENU_CHARA_LOAD_MAX];
extern sceVu0FVECTOR posdef_3194;
extern sceVu0FVECTOR refdef_3195;
extern char *tbl_3196[];
extern char at_3269[];
extern char at_3270[];
extern char at_3272[];
extern char at_3273[];
extern char at_3274[];
extern char at_3275[];
extern char at_3276[];
extern mgCTexture *MenuMosTexture;
extern mgCMemory MenuMosLoadStack;
extern SceneCharaList at_3974;
extern SceneCharaList at_3975;
extern LoadTargetList8 at_3993;
extern sceVu0FVECTOR menu_old_chara_position;
extern RoboCharaList at_4300__2;
extern RoboStackList at_4327;
extern RoboStackList at_4328;
extern SceneCharaList at_4329;
extern DebugLine at_2674;
extern DebugLine at_2675;
extern DebugLine at_2676;
extern DebugText at_2691;
extern DebugNpcText at_2696;
extern char at_2770[];
extern char at_2771[];
extern char at_2772[];
extern char at_2773[];
extern char at_2774[];
extern char at_2775[];
extern char at_2776__2[];
extern char at_2777[];
extern char at_2778[];
extern char at_2779[];
extern char at_2780[];
extern char at_2781[];
extern char at_2782[];
extern char at_2783[];
extern char at_2784[];
extern char at_2785[];
extern short MenuDebugChangeSelectMode;
extern short MenuDebugCharaChangeSelect;
extern s8 menu_debug_npc_decide;
extern s8 menu_debug_npcselect;
struct NpcNameList {
    char *entry[1];
};
struct NpcCmdMesList {
    int entry[2];
};
struct GiftVolumeList {
    int entry[8];
};
extern s8 SelectedCmdNo_1415;
extern s8 init_1416;
extern NpcNameList at_1650__2;
extern NpcCmdMesList at_1684__2;
extern GiftVolumeList at_1806__2;
extern s8 nextIDtbl_1594[5][8];
extern s16 msgtbl1_1732[4];
extern s8 se_sndtbl_1749[3];
extern char at_2003__2[];
extern char at_2004__3[];
extern char at_2005__2[];
extern char at_2006__2[];
extern char at_2007__2[];
extern char at_2008__2[];
extern char at_2009[];
extern char at_2010[];
extern char at_2011[];
extern char at_2012[];
extern char at_2013[];
extern char at_2014[];
extern char at_2015[];
extern char at_2016[];
extern char at_2017[];
extern char at_2018__2[];
extern char at_2019__2[];
extern char at_2020__2[];
extern char at_2021__2[];
extern char at_2022[];
extern char at_2023[];
extern u8 tilergba_5203[4];
extern s8 convtbl_5238[3];
extern float putw_5262[];
extern char *infomsg_5256[];
extern s8 phasetbl_5119[COSTUME_LIST_NUM];
extern short tiletbl_5573[3][12];
extern short under_brdtbl_5576[12];
extern short put_under_offset_5577[16][2];
extern short ic_5580[7][2];
extern short line_5595[12];
extern short wakutbl_5600[3][12];
extern char *monstere_file_template[];
extern char *tbl_3725[MOS_SELECT_BADGE_NUM];
extern char at_3762[];
extern int menu_debug_select__2;
extern int select_monster_save_3371;
extern s8 init_3372__2;
extern MonsterNameList at_3412;
extern MonsterNameList at_3440;
extern MenuCommandList at_3481;
extern MonsterNameTable at_3511;
extern MonsterNameTable at_3529;
extern BadgeInfoValues at_3554;
extern s8 convert_table_3430[];
extern short ghobitbl_3437[];
extern char *get_stringtbl_3557[4];
extern char at_3685[];
extern char at_3686[];
extern char at_3687[];
extern char at_3688[];
extern char at_3689[];
extern char at_3690[];
extern char at_3691[];
extern char at_3692[];
extern char at_3693[];
extern char at_3694[];
extern char at_3695[];
extern char at_3696[];
extern char at_3697[];
extern char at_3698[];
extern char at_3699[];
extern char at_3700[];
extern char at_3701[];
extern char at_3702[];
extern char at_3703[];
extern char at_3704[];
extern char at_3705[];
extern char at_3706[];
extern char at_3707[];
extern char at_3708[];
int CosutmeSelDefaultSet(int costume_id, short *costume_list);
extern char at_2191__2[];
extern char at_2192__2[];
extern char at_2193__2[];
extern char at_2194__2[];
extern char at_2195__2[];
extern char at_2196__2[];
extern char *MonsterDataPath[];
extern char script_file_name[0x20];
extern short monster_load_id;
extern char at_4548[];
extern char at_3160__3[];
extern char at_3161__3[];
extern char at_3162__3[];
extern char at_3163__3[];
extern char at_3164__4[];
extern char at_3165__2[];
extern char at_3166__2[];
extern "C" char at_1304__6[15];
extern "C" char *partt_2332[6];
extern "C" char at_2363[14];
extern "C" char at_2364[15];
extern "C" char at_2365[13];
extern "C" char at_1171__2[];
extern "C" char at_1172[];
extern "C" char at_1173__2[];
extern "C" char at_1174[];
extern "C" char at_1175[];
extern "C" char at_1176[];
extern "C" char at_1177[];
extern "C" char at_1178[];
extern "C" char at_1179[];
extern "C" char at_1180[];
extern "C" char at_1181__2[];
extern "C" char at_2912[];
extern "C" char at_2913__2[];
extern "C" char at_2914[];
extern "C" char at_2915[];
extern "C" char at_2916[];
extern "C" char at_2917[];
extern "C" char at_2918[];
union MenuPositionVector {
    float f[4];
    u_long128 qw;
};
extern "C" MenuPositionVector at_1372__2;
extern "C" char at_1402__3[];
extern CMenuChrCngMenu *ChrChangMenuPt;
extern void *__vt__15CMenuChrCngMenu[];
extern int MenuCharaChangePosDataCfgBuffer;
extern int tbl_2483[];
extern "C" char at_2595__2[];
extern "C" char at_2596__3[];
extern "C" SmallPair at_2232;
extern "C" NamePair at_2288;
extern "C" SmallPair at_2289__2;
extern "C" char at_2303__2[];
extern "C" char at_2304[];
extern "C" char at_2305[];
extern "C" char at_2306[];
extern "C" char at_2307[];
extern "C" u8 cursor_revtbl_2237[5];
extern u8 MenuGetPartySeFlag;
extern mgCMemory ChrChangeInitTextureStack;
extern "C" FileNameBuf at_2629__3;
extern "C" char at_2197__2[];
extern "C" char at_2662__2[];
short GetCostumeList(unsigned long charaFlag, int kind, short *list);
int GetDngMapNo(int dungeonNo);
extern "C" int ReadBGSync__Fv(void);
static int MenuMemoryDivide(mgCMemory *memory, mgCMemory **list, int chara);
static void MenuItemCharaDataLoadPack(int chara_no, CActionChara *chara, CActionChara *body, int part,
                                      u_int *pack, mgCMemory *stack, int tex_block, int blur_type);
extern u16 menu_chr_memorytbl[MENU_CHARA_LOAD_MAX];
extern u16 menu_robo_memorytbl[MENU_CHARA_LOAD_MAX];
extern char at_1078__2[];
int ReadBGSync(void);

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
            MenuCharaBuild2[i] = (MENU_BGREAD_INFO2 *)memory->Alloc(8);
            InitMenuBGReadInfo2(MenuCharaBuild2[i]);
        } else {
            MenuCharaBuild2[i] = NULL;
        }
    }
}
extern "C" short ConvertCharaLoadDataPhase__Fii(int a0, int a1) {
    return tbl_992[a1 + a0 * 5];
}
int CheckBattleLoop() {
    if (MenuCommonInfo == NULL) {
        return 1;
    }
    short menuType = MenuCommonInfo->open_type;
    if (menuType == 1 || menuType == 17 || menuType == 14 || menuType == 21) {
        return 1;
    }
    return 0;
}
void SetMenuLoadItemNo(int who) {
    int count = 0;
    CUserDataManager *userData = GetUserDataMan();
    if (userData == NULL) {
        return;
    }
    switch (who) {
        case 0:
        case 1: {
            CHARA_DATA *chara = userData->GetCharaDataPtr(who);
            do {
                MenuLoadItemNo[count] = *(short *)((u8 *)chara + count * 0x6C + 0x172);
                count++;
            } while (count < 5);
            break;
        }
        case 2: {
            u8 *robo = (u8 *)userData;
            MenuLoadItemNo[0] = *(short *)(robo + 0x47D6);
            MenuLoadItemNo[1] = *(short *)(robo + 0x4692);
            MenuLoadItemNo[2] = *(short *)(robo + 0x46FE);
            MenuLoadItemNo[3] = 0;
            MenuLoadItemNo[4] = *(short *)(robo + 0x476A);
            count = 5;
            break;
        }
    }
    while (count < 12) {
        MenuLoadItemNo[count] = 0;
        count++;
    }
}
#ifdef NONMATCHING
static int MenuMemoryDivide(mgCMemory *memory, mgCMemory **list, int chara) {
    int total;
    memory->Align64();
    u_long128 *buffer = memory->stGetTop();
    total = 0;
    switch (chara) {
        case 0:
        case 1:
        case 2: {
            u16 *table = menu_chr_memorytbl;
            if (chara == 2) {
                table = menu_robo_memorytbl;
            }
            for (int i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
                char name[0x20];
                int size = table[i];
                if (size % 64 != 0) {
                    size += 64 - size % 64;
                }
                sprintf(name, at_1078__2, i);
                SetMemoryName(list[i], name);
                list[i]->stSetBuffer(buffer, size);
                total += size;
                buffer = list[i]->stGetTop() + size;
            }
            break;
        }
        case 3:
            list[0]->stSetBuffer(buffer, 0x6400);
            list[5]->stSetBuffer(buffer + 0x6400, 0x3C0);
            total = 0x67C0;
            break;
    }
    return total;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuMemoryDivide__FP9mgCMemoryPP9mgCMemoryi);
#endif
void MenuMemoryAdjust(mgCMemory *pool, mgCMemory *rest, mgCMemory *buffers, int chara) {
    int freeBlocks = pool->stack_size - pool->stack_used;
    MemoryList list = at_1083__2;
    list.entry[0] = buffers;
    list.entry[1] = buffers + 1;
    list.entry[2] = buffers + 2;
    list.entry[3] = buffers + 3;
    list.entry[4] = buffers + 4;
    list.entry[5] = buffers + 5;
    list.entry[6] = buffers + 6;
    int used = MenuMemoryDivide(pool, list.entry, chara);
    stSetBuffer__9mgCMemoryFP1i(rest, buffers->stack + buffers->stack_used + used,
                                freeBlocks - used);
    if (strlen(at_1104__4) < 16) {
        strcpy((char *)rest, at_1104__4);
    }
    rest->stack_used = 0;
    rest->lock = 0;
}
extern "C" void DeleteMonsterEffect__Fv(void) {
    if (FxScriptMan != NULL) {
        ClearEffectFromChrid__16CEffectScriptManFi(FxScriptMan, 0);
        FxScriptMan->level = 2;
        ClearBaseFromLevel__16CEffectScriptManFiPii(FxScriptMan, 2, NULL, -1);
    }
    mgTexManager.DeleteBlock(0xAA);
}
void SetMessagePositionNPCForm(CMenuPosDataForm *form, CDC2Mes *mes) {
    if (form == NULL || mes == NULL) {
        return;
    }
    int pos[10];
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
    ClsMes *bubble = (ClsMes *)mes;
    if (bubble == NULL || npc == NULL) {
        return;
    }
    int screenPos[4];
    bubble->fukidashi_pos = 5;
    bubble->tail_on = 1;
    GetScrPosFromChar(npc, screenPos);
    screenPos[2] = 0;
    screenPos[3] = 0xBE;
    bubble->AutoSet(screenPos);
}
void CMenuChrCngMenu::AttachForm() {
    char name[0x20];
    int i;
    int j;

    form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_1171__2);
    if (form != NULL) {
        gauge_part[0] = form->GetPartInfo(at_1172);
        gauge_part[1] = form->GetPartInfo(at_1173__2);
        gauge_part[2] = form->GetPartInfo(at_1174);
    }
    (&npc_mes_form)[0] = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_1175);
    (&npc_mes_form)[1] = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_1176);
    (&npc_mes_form)[2] = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_1177);
    (&npc_mes_form)[3] = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_1178);
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
void CMenuChrCngMenu::EnterDataMenu(u8 *pack) {
    char name[0x20];
    int size;
    mgCTextureManager *texManager = &mgTexManager;
    int block = tex_block[0];
    int i;

    texManager->EnterIMGFile((u_char *)GetPackFile((u_int *)pack, at_1276__3, NULL), block, NULL, NULL);
    char *cfg = (char *)GetPackFile((u_int *)pack, at_1277__3, &size);
    if (MenuCharaChangePosDataCfgBuffer == 0 && cfg != NULL) {
        MenuCharaChangePosDataCfgBuffer = (int)cfg;
        MenuDataAnalyze(cfg, size, &MenuChangeMemory);
    }
    MenuRepairMan->Initialize();
    MenuRepairMan->SetRepairData(&MenuChangeMemory, block, (u32 *)pack);
    script = (char *)GetPackFile((u_int *)pack, at_1278__3, &script_size);
    MenuCharaChangeStar_Tex = texManager->GetTexture(at_1279__4, -1);
    MenuCharaChangeBase_Tex = texManager->GetTexture(at_1280__3, -1);
    MenuCharaChangeCLUT = clut;
    texManager->ReloadTexture(block, (sceVif1Packet *)NULL);
    if (MenuCharaChangeCLUT_Tex == NULL) {
        MenuCharaChangeCLUT_Tex = new ((u_long128 *)MenuChangeMemory.Alloc(9)) mgCTexture;
    }
    memcpy(MenuCharaChangeCLUT_Tex, MenuCharaChangeBase_Tex, sizeof(mgCTexture));
    memcpy(MenuCharaChangeCLUT, MenuCharaChangeBase_Tex->clut, sizeof(clut));
    MenuCharaChangeCLUT_Tex->clut = (u_long128 *)MenuCharaChangeCLUT;
    u8 *color = (u8 *)MenuCharaChangeCLUT;
    for (i = 0; i < CHR_CNG_CLUT_NUM; i++) {
        float level = (color[0] + color[1] + color[2]) / 3;
        int step;
        for (step = 1; step < 33; step++) {
            if (8.0f * (step - 1) <= level && level < 8.0f * step) {
                break;
            }
        }
        color[0] = 7.75f * step;
        color[1] = 5.625f * step;
        color[2] = 4.6875f * step;
        color += 4;
    }
    MenuPosData->InitDrawList();
    AttachForm();
    AttachMessageForm();
    ExeScript(at_1281__5);
    party_member = MenuUserDataManPtr->GetNowPartyMember();
    enable_change = MenuUserDataManPtr->GetEnableCharaChangeFlag();
    for (int p = 0; p < 4; p++) {
        sprintf(name, at_1282__5, p);
        MENUFORMPARTS_TYPE *face = form->GetPartInfo(name);
        sprintf(name, at_1283__4, p);
        MENUFORMPARTS_TYPE *lock = form->GetPartInfo(name);
        sprintf(name, at_1284__4, p);
        MENUFORMPARTS_TYPE *frame = form->GetPartInfo(name);
        face->draw_flag = 1;
        int bit = 1 << p;
        if (party_member & bit) {
            frame->draw_flag = 1;
            face->draw_flag = 1;
            lock->draw_flag = 0;
            if ((p < 2 && (enable_change & bit)) || !(p < 2)) {
                face->draw_flag = 0;
            } else {
                lock->draw_flag = 1;
            }
        } else {
            frame->draw_flag = 0;
        }
    }
    UpdataLife();
    mes_data = (s16 *)GetPackFile((u_int *)pack, at_1285__2, NULL);
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
    npc_cmd_mes[0] = 0;
    npc_cmd_mes[1] = 0;
    npc_cmd_mes[2] = 0;
    npc_cmd_mes[3] = 0;
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
        int cmdMes = GetPartyCharaMessage(npc_no, 5, 0);
        for (i = 0; i < npc_data->ability_num; i++) {
            npc_cmd_mes[i] = cmdMes + i;
        }
        for (; i < 4; i++) {
            npc_cmd_mes[i] = 0;
        }
        if (npc_data->ability_num == 0) {
            npc_cmd_mes[0] = 10;
        }
        for (i = 0; i < npc_data->ability_num; i++) {
            form->SetNumber(tbl_1233[i], npc_data->ability_cost[i]);
        }
        for (; i < 4; i++) {
            form->SetPartDrawFlag(tbl_1233[i], false);
        }
    }
}
void CMenuChrCngMenu::LoadNPCFaceData(mgCMemory *memory, int mode) {
    char path[0x40];
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
        face_img = (u8*)(memory->stack + memory->stack_used);
        size = LoadFileMenu(path, (u_long128 *)face_img, mode);
        memory->Alloc((size & 0xF) ? (size >> 4) + 1 : size >> 4);
    }
}
void CMenuChrCngMenu::EnterNPCFaceData() {
    signed char loadState;

    if ((face_state == 0) && ((loadState = face_loaded, (loadState == 1)) ||
                              ((loadState == 0) && (ReadBGSync() == 0)))) {
        mgTexManager.EnterIMGFile(face_img, tex_block[0], NULL, NULL);
        face_state = 1;
        ExeScript(at_1319);
    }
}
int CMenuChrCngMenu::LoadBGNPCModel(int restart_read) {
    mgCMemory *stack = &MenuCharaLoadStack;
    stack->stReset();
    npc_chara = NewMenuActionChara(stack);
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
int CMenuChrCngMenu::CheckBGNPCModel() {
    int loadResult;
    float position[4];

    loadResult = 0;
    if (ReadBGSync() == 0) {
        loadResult = MenuNPCLoadCheck(npc_chara, &npc_build_stack, tex_block[1]);
    }
    if (npc_chara == NULL) {
        return 0;
    }
    if (key_arg_no == 3) {
        npc_y = npc_y + ((-2.8f - npc_y) / 6.0f);
    } else {
        npc_y = npc_y + ((-16.6f - npc_y) / 6.0f);
    }
    *(MenuPositionVector *)position = at_1372__2;
    position[1] = npc_y;
    if (loadResult == 1) {
        npc_loaded = 1;
        npc_wait = 0;
        ((CCharacter2 *)npc_chara)->SetRotation(0.0f, -0.07853982f, 0.0f);
        (&npc_mes_form)[2]->counter = 0;
    }
    if (npc_loaded != 0) {
        ((CCharacter2 *)npc_chara)->SetScale(1.0f, 1.0f, 1.0f);
        if (npc_no == 9) {
            MenuAdjustPolygonScale((CCharacter2 *)npc_chara, 5.655f);
        } else {
            MenuAdjustPolygonScale((CCharacter2 *)npc_chara, 6.96f);
        }
        ((CCharacter2 *)npc_chara)->SetPosition(position);
        ((CCharacter2 *)npc_chara)->Step();
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
    return loadResult;
}
void EditCharaPrepare() {
    CActionChara *chara = (CActionChara *)MenuMainScene->GetCharacter(1);
    if (chara != NULL) {
        chara->Initialize(NULL);
    }
    chara = (CActionChara *)MenuMainScene->GetCharacter(2);
    if (chara != NULL) {
        chara->Initialize(NULL);
    }
}
#ifdef NONMATCHING
int CMenuChrCngMenu::KeyChangeMain() {
    CMenuKeyFunc *keyFunc = MenuCommonInfo;
    keyFunc->SelDataInit();
    int keys = keyFunc->CheckSelectKey();
    int buttons = keyFunc->CheckPushButton();
    CDC2Mes *titleMes = MenuDCMsg[2];
    CDC2Mes *answerMes = MenuDCMsg[3];
    CDC2Mes *cmdMes = MenuDCMsg[4];
    CDC2Mes *npcMes = MenuDCMsg[5];
    CDC2Mes *repairMes = MenuDCMsg[7];
    int action = 0;
    CGameDataUsed *item = NULL;
    int cancelled = 0;

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
                    if (keyFunc->open_type == 4) {
                        if (buttons) {
                            mode = 2;
                            ExeScript(at_2003__2);
                        }
                    } else {
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
                    for (int i = 0; i < npcMes->page_num; i++) {
                        if (widest < npcMes->page_chars[i]) {
                            widest = npcMes->page_chars[i];
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
                                if (MenuCommonInfo->open_type != 0xE && 0 < npc_no) {
                                    action = 0x22;
                                }
                            } else {
                                action = 0x46;
                            }
                            break;
                        case 2:
                            action = 0x28;
                            if (MenuCommonInfo->open_type == 0xE) {
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
                                MenuMainScene->SetActive(1, MenuMainScene->SearchCharaID(npc_no));
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
            MenuLoadInfo.unk_3 = select;
            MenuLoadInfo.mode = 2;
            MenuLoadInfo.unk_4 = -1;
            MenuLoadInfo.unk_5 = 0;
            MenuLoadInfo.unk_6[1] = 1;
            ReEquipFishingGameWeapon();
            MenuCharaLoadStack.stack_used = 0;
            MenuCharaLoadStack.lock = 0;
            MenuCharaLoadStack.Align64();
            SetMenuLoadItemNo(change_chara);
            switch (change_chara) {
                case 0:
                case 1:
                    MenuLoadInfo.unk_2 = 1;
                    MenuLoadInfo.unk_4 = -1;
                    MenuItemCharaDataLoad(&MenuCharaLoadStack, change_chara, MenuCharaBuild2, 1);
                    break;
                case 2:
                    MenuLoadInfo.unk_2 = 1;
                    MenuCharaLoadStack.Alloc(blocks_for(MenuItemRoboDataLoad(&MenuCharaLoadStack, MenuCharaBuild2, 1)));
                    break;
            }
            change_phase = 1;
            change_ready = 0;
            break;
        }
        case 0x50:
            key_arg_no = 0;
            change_phase = 0;
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
            if (MenuLoadInfo.unk_1 == 1) {
                EditCharaPrepare();
            }
            if (GetMenuLoopType() == 1 && FxScriptMan != NULL) {
                CActionChara *player = (CActionChara *)MenuMainScene->GetCharacter(0);
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
            if (GetMenuLoopType() == 0) {
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
                for (int i = 0; i < npcMes->page_num; i++) {
                    if (widest < npcMes->page_chars[i]) {
                        widest = npcMes->page_chars[i];
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
            if (GetMenuLoopType() == 1) {
                inDungeon = 1;
            }
            int bossFloor = 0;
            DNG_BATTLE_AREA *area = &MenuMainScene->battle_area;
            if (area != NULL && area->floor_status & 4) {
                bossFloor = 1;
            }
            int bitCtrl = GetSaveData()->GetBitCtrl();
            int maxBad = CheckBadStatus(MenuUserDataManPtr->GetCharaStatusAttirbute(0));
            int monicaBad = CheckBadStatus(MenuUserDataManPtr->GetCharaStatusAttirbute(1));
            int maxHurt = 0;
            if (MenuUserDataManPtr->chara_data[0].hp.GetRate() < 1.0f) {
                maxHurt = 1;
            }
            int monicaHurt = 0;
            if (MenuUserDataManPtr->party_member & 2 && MenuUserDataManPtr->chara_data[1].hp.GetRate() < 1.0f) {
                monicaHurt = 1;
            }
            step = 2;
            GiftVolumeList volume = at_1806__2;
            int message = GetPartyCharaMessage(npc_no, 7, 0) + SelectedCmdNo_1415;
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
                        if (MenuMainScene->battle_area.boss_map && MenuMainScene->battle_area.unk_5c) {
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
                        MenuUserDataManPtr->SetCharaStatusAttirbute(0, 0x6F, 1);
                        MenuUserDataManPtr->SetCharaStatusAttirbute(1, 0x6F, 1);
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
                        MenuUserDataManPtr->SetCharaStatusAttirbute(0, 0x6F, 1);
                        MenuUserDataManPtr->SetCharaStatusAttirbute(1, 0x6F, 1);
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
                            MenuUserDataManPtr->chara_data[0].hp.SetFillRate(1.0f);
                            used = 1;
                        }
                        if (MenuUserDataManPtr->GetHp(1) < 1.0f) {
                            MenuUserDataManPtr->chara_data[1].hp.SetFillRate(1.0f);
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
                    int esa[8];
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
    char name[0x20];
    int itemPos[10][2];
    int pos[2];
    int framePos[2];
    MENUFORMPARTS_TYPE *icon;
    MENUFORMPARTS_TYPE *shadow;
    int i;

    if (form == NULL) {
        return;
    }
    float *frameTop = GetMenuMainFrameLeftTopPos(0);
    int x = (int)(frameTop[0] - 512.0f);
    int y = (int)frameTop[1];
    if (GetMenuMainFrameEndFlag__Fv() == 0) {
        SetFormPoint(form, x, y);
    } else {
        form->x = x;
    }
    int iconNum = 4;
    if (0 <= face_chara) {
        iconNum = 5;
    }
    for (i = 0; i < iconNum; i++) {
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
        form->GetPutPosXY(at_2193__2, itemPos[0][0], itemPos[0][1]);
        form->GetPutPosXY(at_2194__2, itemPos[1][0], itemPos[1][1]);
        MenuDCMsg[2]->SetMsgItemPos(itemPos[0], 2);
        for (i = 0; i < 4; i++) {
            if (cmd_part[i] != NULL) {
                itemPos[i][0] = (int)(form->x + cmd_part[i]->x);
                itemPos[i][1] = (int)(form->y + cmd_part[i]->y);
            }
        }
        if (key_arg_no != 0 || step != 2) {
            SetFormPoint(MenuMesForm[4], itemPos[0][0], itemPos[0][1]);
        }
        SetMessagePositionNPCForm(npc_mes_form, MenuDCMsg[3]);
        if (party_info != NULL && npc_data != NULL) {
            form->SetNumber(at_2195__2, party_info->point);
            form->SetNumber(at_2196__2, npc_data->max_npc_point);
            if (point_gauge_part != NULL) {
                float rate = 0.0f;
                if (npc_data->max_npc_point != 0) {
                    rate = (float)party_info->point / (float)npc_data->max_npc_point;
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
        form->GetPutPosXY(at_2197__2, framePos[0], framePos[1]);
        if (abs((int)((float)framePos[0] - MenuFormMI2->x)) < 8) {
            item_brd_arrived = 1;
        }
        if ((item_brd_arrived && mode != 2) || key_arg_no == 2 || MenuCommonInfo->open_type == 0xE) {
            MenuFormMI2->draw_flag = 1;
            CMenuPosDataForm *itemBoard = MenuFormMI2;
            itemBoard->x = framePos[0];
            itemBoard->y = framePos[1];
        }
    }
}
int CMenuChrCngMenu::CheckChrChange() {
    int result = 0;
    int readBusy = ReadBGSync();
    mgCMemory *stack = &MenuCharaLoadStack;
    CActionChara *chara;

    switch (change_phase) {
        case 0:
            break;
        case 1:
            if (change_ready != 0 && readBusy == 0) {
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
                change_phase = 2;
            }
            break;
        case 2:
            if (change_ready != 0 && readBusy == 0) {
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
                chara = (CActionChara *)MenuMainScene->GetCharacter(0);
                if (GetMenuLoopType() == 1) {
                    chara->effect_man = FxScriptMan;
                }
                if (chara != NULL && MenuLoadInfo.unk_1 == 0) {
                    chara->InitScript();
                }
                MenuCharaSoundEnter(MenuMainScene, chara, 1);
                CopyActiveItemAndWeapon(change_chara, -1);
                result = 2;
                change_phase += 1;
            }
            break;
        case 3:
            result = 2;
            break;
    }
    return result;
}
int CMenuChrCngMenu::MenuLocalLoop() {
    char name[0x20];
    int cursor[2];
    int result;
    int iconMode;
    int fadeDone;
    int frameEnd;
    int messageId;
    int itemNo;
    CGameDataUsed *item;
    CDC2Mes *mes;
    int nameX;
    int nameY;
    int width;

    KeyChangeMain();
    SmallPair step = at_2232;
    if (npc_no == 1 && this->step == 0x14) {
        ((CMenuPosDataManage *)MenuPosData)->GetPosMenuItemOnItemBrd(cursor, item_brd_select, 1);
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
    iconMode = 2;
    int *modeId = (int *)GetCommonMenuModeID();
    if (mode == 2) {
        iconMode = 0;
    }
    ((CMenuPosDataManage *)MenuPosData)->StepMainMenuIconMove(modeId, 4, iconMode);
    fadeDone = 1;
    if (MenuCommonInfo->open_type == 4 || close_on_end == 1 || MenuCommonInfo->open_type == 0xE) {
        fadeDone = FadeCheckMenu();
    }
    frameEnd = GetMenuMainFrameEndFlag__Fv();
    result = CheckChrChange();
    switch (mode) {
        case 1:
            EnterNPCFaceData();
            if (fadeDone != 0 && face_state != 0 && ReadBGSync() == 0) {
                short keyMode = MenuCommonInfo->open_type;
                if ((keyMode != 4 && frameEnd != 0) || keyMode == 4) {
                    mode = 0;
                    star_fade = 0;
                    star_spawn = 1;
                    open_wait = 0;
                    set_cursor = 1;
                    ExeScript(at_2304);
                    keyMode = MenuCommonInfo->open_type;
                    if (keyMode == 4) {
                        ExeScript(at_2305);
                    } else if (keyMode == 0xE) {
                        ExeScript(at_2306);
                    }
                    LoadBGNPCModel(1);
                }
            }
            break;
        case 2:
            if (fadeDone != 0 && frameEnd != 0) {
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
            if (MenuCommonInfo->open_type == 4 && MenuGetPartySeFlag == 0 && fadeDone != 0) {
                MenuGetPartySeFlag = 1;
                MenuSePlay(0x11);
            }
            CheckBGNPCModel();
            break;
    }
    MenuPosData->FormStep();
    CalcTex();
    messageId = select + 0x190;
    if (select == 4) {
        messageId = npc_mes_talk;
    }
    if (select < 4) {
        if (IsCheckParty(select) == 0) {
            messageId = 0x194;
        }
        if (CheckBitFlagMenu(0x36) == 0 && select == 1 && OmakeFlag == 0) {
            messageId = 0x199;
        }
    }
    MenuDCMsg[0]->MakeMsg(messageId);
    if (npc_no == 1) {
        itemNo = item_brd_select;
        if (0 <= itemNo && itemNo < GetNowBagMax(0)) {
            NamePair itemNames = at_2288;
            SmallPair itemVolumes = at_2289__2;
            item = MenuDrawItemInfo[item_brd_select];
            mes = MenuDCMsg[7];
            if (item != NULL) {
                itemNames.a = item->GetName(0);
                item->GetWHp(itemVolumes.v);
            }
            mes->SetMsgItemNo(&itemNames.a, 1);
            mes->SetMsgVolumeNo(itemVolumes.v, 2);
            mes->value_width[0] = 6;
            nameX = fptosi(MenuMesForm[7]->x + (float)(mes->abs_win.width >> 1));
            width = mes->GetStrWidth(0);
            nameX -= width / 2;
            nameY = fptosi(14.0f + MenuMesForm[7]->y);
            mes->line_pos[0][0] = nameX;
            mes->line_pos[0][1] = nameY;
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
    mgCTextureManager *texManager = &mgTexManager;

    if (MenuCharaChangeBase_Tex == NULL) {
        return;
    }
    texManager->ReloadTexture(MenuCharaChangeBase_Tex->block, (sceVif1Packet *)NULL);
    CMenuChrCngMenu *menu = ChrChangMenuPt;
    float size = menu->star_size;
    float offset = size / 2.0f - 2.0f;
    RingCenter center = at_2371__4;
    center.x = menu->star_x + offset;
    center.y = menu->star_y + 1.1538461f * offset;
    float angle = menu->star_angle;
    mgCDrawPrim *prim = GetMenuPrim();
    mgRect<int> baseRect(0x13F, 0xC0, 0x40, 0x40);
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
    prim->Begin(5);
    prim->Texture(MenuCharaChangeBase_Tex);
    prim->Color(0x80, 0x80, 0x80, (int)ChrChangMenuPt->star_alpha);
    for (int i = 0; i < 4; i++) {
        prim->TextureCrd((int)crd.uv[i][0], (int)crd.uv[i][1]);
        float x = 1.0f + (center.x + size * cosf(angle));
        prim->Vertex(x, center.y + 1.1538461f * (size * sinf(angle)), 0.0f);
        angle += 1.5707964f;
    }
    prim->End();

    mgRect<int> wakuRect(0x121, 0xE1, 0x1E, 0x1E);
    float wave = ChrChangMenuPt->star_wave;
    angle -= 0.15707964f;
    float ringSize = 0.546875f * ChrChangMenuPt->star_size;
    float pulse = sinf(ChrChangMenuPt->star_pulse);
    float halfAlpha = 0.5f * ChrChangMenuPt->star_alpha;
    if (pulse < 0.0f) {
        pulse = -pulse;
    }
    float pulseAlpha = halfAlpha * pulse;
    for (int j = 0; j < 2; j++) {
        float alpha = ChrChangMenuPt->star_alpha;
        float circle = 60.0f + 3.0f * sinf(wave);
        float x = ringSize * cosf(angle);
        float y = ringSize * sinf(angle);
        x = center.x + x;
        mgRect<float> inner(x - 0.5f * circle, 6.0f + (center.y + 1.1538461f * (y - 0.5f * circle)), circle,
                            circle);
        DrawWakuCircle(prim, MenuCharaChangeBase_Tex, inner, wakuRect, wave, ringSize, (int)alpha, 0x80, 0x80,
                       0x80);
        circle *= 1.4f;
        mgRect<float> outer(x - 0.5f * circle, 6.0f + (center.y + 1.1538461f * (y - 0.5f * circle)), circle,
                            circle);
        DrawWakuCircle(prim, MenuCharaChangeBase_Tex, outer, wakuRect, wave, ringSize, (int)pulseAlpha, 0x80, 0x80,
                       0x80);
        angle += 3.1415927f;
        wave += 3.1415927f;
    }

    if (MenuCharaChangeStar_Tex == NULL) {
        return;
    }
    texManager->ReloadTexture(MenuCharaChangeStar_Tex->block, (sceVif1Packet *)NULL);
    mgRect<short> starRect(0, 0x20, 8, 8);
    prim->Begin(6);
    prim->Texture(MenuCharaChangeStar_Tex);
    for (int k = 0; k < CHR_CNG_STAR_NUM; k++) {
        CHR_CNG_STAR *star = &ChrChangMenuPt->star[k];
        if (star->alpha > 0.0f) {
            float starX = star->x + ChrChangMenuPt->star_x;
            float starY = star->y + ChrChangMenuPt->star_y;
            prim->Color(0x80, 0x80, 0x80, (int)star->alpha);
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
int MenuCharaChangeInit(mgCMemory *memory, int *texBlock, int bootMode) {
    u8 *buffer;
    int size;
    unsigned int fileSize;
    CMenuChrCngMenu *menu;
    CRepairManager *repair;
    int i;
    mgCMemory *slot;
    CCharacter2 *chara;
    int offset;
    short partyChara;

    buffer = (u8*)memory->stack;
    if (bootMode == 4 || bootMode == 0xE) {
        fileSize = LoadFileMenu(at_2595__2, (u_long128 *)buffer, 1);
        memory->Alloc((fileSize & 0xF) ? (fileSize >> 4) + 1 : fileSize >> 4);
        memory->Align64();
    }
    ChrChangeInitTextureStack.stSetBuffer((u_long128 *)buffer, memory->stack_used);
    size = stack_free_size(memory);
    MenuChangeMemory.stSetBuffer((u_long128 *)stack_free_top(memory), size);
    MenuChangeMemory.Alloc(0x100);
    if ((menu = (CMenuChrCngMenu *)operator new(0x1F80, (u_long128 *)MenuChangeMemory.Alloc(0x1FA))) !=
        NULL) {
        __ct__14CBaseMenuClassFv(menu);
        *(void **)((u8*)menu + 0x10C) = __vt__15CMenuChrCngMenu;
        menu->npc_model_stack.Init();
        menu->npc_build_stack.Init();
        menu->change_phase = 0;
        menu->change_chara = -1;
        menu->change_ready = 0;
        MenuCharaChangePosDataCfgBuffer = 0;
        menu->unk_118 = 0;
        menu->select = 0;
        menu->last_select = 0;
        menu->star_fade = 0;
        menu->enable_change = 0;
        menu->party_member = 0;
        menu->item_brd_select = 0;
        *(int *)&menu->item_brd_pos = 0;
        menu->open_wait = -1;
        menu->set_cursor = 1;
        menu->cursor_wave = 0;
        menu->form = NULL;
        (&menu->npc_mes_form)[3] = NULL;
        (&menu->npc_mes_form)[2] = NULL;
        (&menu->npc_mes_form)[1] = NULL;
        (&menu->npc_mes_form)[0] = NULL;
        menu->chara_pos[0] = NULL;
        menu->chara_pos[1] = NULL;
        menu->chara_pos[2] = NULL;
        menu->chara_pos[3] = NULL;
        menu->chara_pos[4] = NULL;
        menu->npc_cmd_mes[0] = 0;
        menu->npc_cmd_mes[1] = 0;
        menu->npc_cmd_mes[2] = 0;
        menu->npc_cmd_mes[3] = 0;
        menu->unk_23C = 0;
        menu->cmd_part[0] = NULL;
        menu->cmd_part[1] = NULL;
        menu->cmd_part[2] = NULL;
        menu->cmd_part[3] = NULL;
        menu->point_gauge_part = NULL;
        menu->set_cursor = 0;
        menu->gauge_part[0] = NULL;
        menu->gauge_part[1] = NULL;
        menu->gauge_part[2] = NULL;
        menu->gauge[0] = NULL;
        menu->gauge[1] = NULL;
        menu->gauge[2] = NULL;
        menu->item_brd_arrived = 0;
        menu->party_info = 0;
        menu->npc_data = 0;
        menu->mes_data = 0;
        menu->sys_mes = NULL;
        menu->npc_no = 0;
        menu->sub_menu = -1;
        menu->sub_menu_next = -1;
        menu->face_state = -1;
        menu->face_chara = -1;
        menu->face_loaded = 0;
        menu->face_img = NULL;
        menu->npc_chara = NULL;
        menu->npc_loading = 0;
        menu->npc_loaded = 0;
        menu->npc_wait = 0;
        menu->npc_show = 0;
        menu->npc_y = 0;
        menu->InitStarInfo();
        menu->key_arg_no = 0;
        menu->close_on_end = 0;
        menu->got_item = 0;
        menu->gift_item = 0;
        menu->gift_num = 0;
        memset((u8 *)menu + 0x1A80, 0, 0x500);
        menu->npc_model_stack.stSetBuffer(NULL, 0);
        menu->npc_build_stack.stSetBuffer(NULL, 0);
    }
    ChrChangMenuPt = menu;
    menu->SetTexBlock(texBlock);
    partyChara = MenuUserDataManPtr->active_chr_no;
    *(int *)&ChrChangMenuPt->last_select = partyChara;
    ChrChangMenuPt->select = partyChara;
    if ((repair = (CRepairManager *)operator new(0x1EC, (u_long128 *)MenuChangeMemory.Alloc(0x21))) !=
        NULL) {
        slot = (mgCMemory *)&repair->effect_stack[0];
        do {
            slot->Init();
            slot = (mgCMemory *)((u8 *)slot + 0x30);
        } while ((unsigned int)slot < (unsigned int)&repair->unk_1a4);
        (&repair->model_stack)->Init();
    }
    MenuRepairMan = repair;
    repair->Initialize();
    i = 0;
    if (bootMode == 4) {
        ChrChangMenuPt->key_arg_no = 2;
        ChrChangMenuPt->last_select = 4;
        ChrChangMenuPt->select = 4;
    }
    offset = 0;
    do {
        chara = MenuMainScene->GetCharacter(i);
        i++;
        *(CCharacter2 **)((u8 *)MenuActionChara + offset) = chara;
        offset += 4;
    } while (i < 7);
    MenuBGReadInfo2Malloc__FP9mgCMemoryPi(&MenuChangeMemory, tbl_2483);
    MenuCharaChangeCLUT_Tex = 0;
    MenuMainFrameModeSet__Fii(4, 1);
    ChrChangMenuPt->EnterDataMenu((u8*)memory->stack);
    MenuChangeMemory.Align64();
    size = stack_free_size(&MenuChangeMemory);
    MenuChangeNpcMemory.stSetBuffer((u_long128 *)stack_free_top(&MenuChangeMemory), size);
    ChrChangMenuPt->LoadNPCFaceData(&MenuChangeNpcMemory, 0);
    MenuChangeNpcMemory.Align64();
    size = stack_free_size(&MenuChangeNpcMemory);
    MenuCharaLoadStack.stSetBuffer((u_long128 *)stack_free_top(&MenuChangeNpcMemory), size);
    MenuLoadInfo.unk_1 = 0;
    MenuCharaLoadStack.stack_used = 0;
    MenuCharaLoadStack.lock = 0;
    switch (bootMode) {
        case 0:
            MenuLoadInfo.unk_1 = 1;
            break;
    }
    MenuLoadInfo.mode = 2;
    if (ChrChangMenuPt->key_arg_no == 2 || bootMode == 0xE) {
        while (GetMenuMainFrameEndFlag() == 0) {
            MenuMainFrameStep__Fv();
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
int MenuCharaChangeKey(void) {
    int result;
    int fadeDone;
    int boxResult;
    int phase;
    int mode;
    int i;
    mgCMemory *stack;
    u8 *texture;
    CMenuPosDataForm *form;
    CMenuPosDataForm *cursorForm;
    FileNameBuf fileName;
    int pos[2];

    result = 0;
    fadeDone = ChrChangMenuPt->FadeCheckMenu();
    mode = 1;
    phase = ChrChangMenuPt->sub_menu;
    switch (phase) {
        case -1:
            if (ChrChangMenuPt->sub_menu_next == 1) {
                if (fadeDone != 0) {
                    ChrChangMenuPt->sub_menu = ChrChangMenuPt->sub_menu_next;
                    MenuCharaLoadStack.stack_used = 0;
                    MenuCharaLoadStack.lock = 0;
                    if (MenuLoadInfo.unk_1 == 1) {
                        mode = 0;
                    }
                    MenuMonsterBoxInit(&MenuCharaLoadStack, ChrChangMenuPt->tex_block, mode);
                }
            } else if (ChrChangMenuPt->sub_menu_next == -1 && fadeDone != 0) {
                result = ChrChangMenuPt->MenuLocalLoop();
            }
            break;
        case 1:
            if (ChrChangMenuPt->sub_menu_next == -1) {
                if (fadeDone != 0) {
                    ChrChangMenuPt->sub_menu = ChrChangMenuPt->sub_menu_next;
                }
            } else if (phase == 1) {
                boxResult = MenuMonsterBoxKey();
                if (boxResult != 0) {
                    if (boxResult == 1) {
                        ChrChangMenuPt->sub_menu_next = -1;
                        ChrChangMenuPt->sub_menu = -1;
                        MenuCharaLoadStack.stack_used = 0;
                        MenuCharaLoadStack.lock = 0;
                        texture = (u8*)ChrChangeInitTextureStack.stack;
                        fileName = at_2629__3;
                        LoadFileMenu(fileName.text, (u_long128 *)texture, 1);
                        ChrChangMenuPt->EnterDataMenu(texture);
                        ChrChangMenuPt->LoadNPCFaceData(&MenuChangeNpcMemory, 1);
                        ChrChangMenuPt->EnterNPCFaceData();
                        ChrChangMenuPt->LoadBGNPCModel(0);
                        ChrChangMenuPt->CheckBGNPCModel();
                        ((ClsMes *)MenuDCMsg[0])->SetBuff(ChrChangMenuPt->sys_mes);
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
                        MenuSetPos__12CMenuKeyFuncFii(MenuCommonInfo, pos[0], pos[1]);
                        ChrChangMenuPt->form->GetPutPosXY(at_2197__2, pos[0], pos[1]);
                        cursorForm = MenuFormMI2;
                        cursorForm->x = (float)pos[0];
                        cursorForm->y = (float)pos[1];
                        ChrChangMenuPt->FadeInMenu(0x28, 0.0f);
                        MenuCamInit(1.0f);
                    } else if (boxResult == 2) {
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
    int partyMember;
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
        mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
        if (ChrChangMenuPt->select != 4) {
            DrawMenuFillBox(20.0f, 20.0f, 300.0f, 220.0f, 0x60, 0, 0, 0);
            DebugLine party = at_2674;
            DebugLine change = at_2675;
            DebugLine mask = at_2676;
            partyMember = MenuUserDataManPtr->GetNowPartyMember();
            int charaChange = MenuUserDataManPtr->chara_change;
            int changeMask = MenuUserDataManPtr->chara_change_mask;
            int i;
            for (i = 0; i < 4; i++) {
                int bit = 1 << i;
                if (partyMember & bit) {
                    strcat(party.text, at_2770);
                } else {
                    strcat(party.text, at_2771);
                }
                if (charaChange & bit) {
                    strcat(change.text, at_2770);
                } else {
                    strcat(change.text, at_2771);
                }
                if (changeMask & bit) {
                    strcat(mask.text, at_2770);
                } else {
                    strcat(mask.text, at_2771);
                }
            }
            DebugText title = at_2691;
            font.SetStr(title.text);
            font.SetPos(0x28, 0x3C);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
            int cursorX = MenuDebugChangeSelectMode * 0x3C + 0x98;
            font.SetStr(at_2772);
            font.SetPos(cursorX, 0x14);
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
            int cursorY = MenuDebugCharaChangeSelect * 0x14 + 0x3C;
            font.SetStr(at_2776__2);
            font.SetPos(0x14, cursorY);
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
        CUserDataManager *userData = GetUserDataMan();
        mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
        int y = 0x46;
        font.SetStr(at_2779);
        font.SetPos(0x14, 0x1E);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
        DebugNpcText npcTitle = at_2696;
        strcpy(&npcTitle.text[menu_debug_npc_decide * 3 + 0x11], at_2780);
        font.SetStr(npcTitle.text);
        font.SetPos(0x14, 0x32);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
        for (int npc = menu_debug_npcselect; npc < 0xB3; npc++) {
            NPC_BASE_DATA *data = GetPartyNPCData(npc);
            if (data == NULL || data->debug_flag == 0) {
                continue;
            }
            PARTY_CHARA_INFO *info = userData->GetPartyCharaInfo(npc);
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
char *GetMonsterName(int monsterNo) {
    BASE_MONSTER_TBL *record = GetMonsterTable(monsterNo);
    if (record != NULL) {
        return record->name;
    }
    return NULL;
}
int get_gajji_id_from_monster_progress_table(int progressNo, int *columnOut) {
    int row;
    int column;
    int columnOffset;
    int rowOffset;
    for (row = 0, rowOffset = 0; row < 19; row++, rowOffset += 10) {
        for (column = 1, columnOffset = 2; column < 5; column++, columnOffset += 2) {
            if (progressNo == *(short *)(columnOffset + ((int)monster_progress_tbl + rowOffset))) {
                if (columnOut) {
                    *columnOut = column - 1;
                }
                return monster_progress_tbl[row * 5];
            }
        }
    }
    return -1;
}
int GetMonsterProgressTableNo(int column, int value) {
    int row = 0;
    int rowOffset = 0;
    do {
        if (value == *(short *)(rowOffset + (int)&monster_progress_tbl[column] + 2)) {
            return row;
        }
        row++;
        rowOffset += 10;
    } while (row < 19);
    return -1;
}
int get_monster_tbl_bajjilevel(int *list, int monsterId, int value, int column) {
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
            (0 <= value && column > 0 && value == (monster_progress_tbl + column)[row * 5])) {
            if (monsterId == *(short *)((u8 *)monster_progress_tbl + row * 10)) {
                list[count] = (monster_progress_tbl + column)[row * 5 + 1];
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
        if (id == monster_progress_tbl[row * 5]) {
            return row;
        }
    }
    return 0;
}
int GetMonsterModelFile(int monsterId, int kind, char *fileName) {
    char suffix[0x20];
    BASE_MONSTER_TBL *monster;
    char *baseName;
    int number;
    int *hengeParam;

    if (fileName == NULL) {
        return 0;
    }
    monster = GetMonsterTable(monsterId);
    baseName = monster->model;
    if (monster == NULL) {
        return 0;
    }
    if ((int)strlen(baseName) <= 0) {
        return 0;
    }
    strcpy(fileName, baseName);
    if (kind == 0) {
        strcat(fileName, at_2912);
    }
    if (kind == 1) {
        number = monster->sound_no;
        if (number < 0) {
            return 0;
        }
        strcpy(fileName, at_2913__2);
        if (number < 10) {
            sprintf(suffix, at_2914, number);
        } else if (number < 100) {
            sprintf(suffix, at_2915, number);
        } else {
            sprintf(suffix, at_2916, number);
        }
        strcat(fileName, suffix);
    }
    if (kind == 2) {
        hengeParam = (int*)GetMonsterHengeParam(monsterId);
        if (hengeParam != NULL) {
            sprintf(fileName, at_2917, hengeParam[2]);
        }
    }
    if (kind == 3) {
        strcpy(fileName, monster->model);
        strcat(fileName, at_2918);
    }
    return 1;
}
void CMenuMosSelect::AttachForm() {
    char name[0x20];
    MOS_CHANGE_PARAM *base;
    int i;
    int offset;
    badge_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_2940);
    model_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_2941);
    info_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_2942);
    Tex_BuildUpBoard = mgTexManager.GetTexture(at_2943, -1);
    GetUserDataMan();
    if (badge_form != NULL) {
        base = badge;
        i = 0;
        offset = 0;
        do {
            MENUFORMPARTS_TYPE *part;
            sprintf(name, at_2944, i);
            part = GetPartInfo__16CMenuPosDataFormFPc(badge_form, name);
            if (part != NULL) {
                part->draw_flag = ((MOS_CHANGE_PARAM *)((u8 *)base + offset))->enable != 0;
            }
            i += 1;
            offset += 0xBC;
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
int MonsterEffectRead(mgCMemory *stack, int monsterNo, int background) {
    char scriptPath[0x80];
    char packPath[0x80];
    int i;
    int offset;
    mos_effect_henge_param = GetMonsterHengeParam(monsterNo);
    mos_effect_read_num = 0;
    if (mos_effect_henge_param != NULL && stack != NULL) {
        i = 0;
        if (FxScriptMan != NULL) {
            offset = 0;
            do {
                char *effectName = *(char **)((u8 *)mos_effect_henge_param + offset + 0xC);
                if (effectName != NULL) {
                    FxScriptMan->GetNeedFilePath(effectName, scriptPath, packPath);
                    stack->Align64();
                    *(u8 **)((u8 *)mos_effect_readbuff1 + offset) =
                        (u8*)(stack->stack + stack->stack_used);

                    if (background != 0) {
                        if (LoadFileBG(scriptPath,
                                       (u_long128 *)*(u8 **)((u8 *)mos_effect_readbuff1 + offset),
                                       (int *)((u8 *)mos_effect_readbuff1_size + offset)) == 0) {
                            goto nextEffect;
                        }
                        goto scriptLoaded;
                    } else if (LoadFile2(scriptPath, *(u8 **)((u8 *)mos_effect_readbuff1 + offset),
                                         (int *)((u8 *)mos_effect_readbuff1_size + offset),
                                         0) != 0) {
                    scriptLoaded:
                        unsigned int total = *(int *)((u8 *)mos_effect_readbuff1_size + offset) + 0x800;
                        stack->Alloc((total & 0xF) ? (total >> 4) + 1 : total >> 4);
                        stack->Align64();
                        *(u8 **)((u8 *)mos_effect_readbuff2 + offset) =
                            (u8*)(stack->stack + stack->stack_used);
                        if (background != 0) {
                            if (LoadFileBG(
                                    packPath, (u_long128 *)*(u8 **)((u8 *)mos_effect_readbuff2 + offset),
                                    (int *)((u8 *)mos_effect_readbuff2_size + offset)) == 0) {
                                goto nextEffect;
                            }
                            goto packLoaded;
                        } else if (LoadFile2(
                                       packPath, *(u8 **)((u8 *)mos_effect_readbuff2 + offset),
                                       (int *)((u8 *)mos_effect_readbuff2_size + offset), 0) != 0) {
                        packLoaded:
                            total = *(int *)((u8 *)mos_effect_readbuff2_size + offset) + 0x800;
                            stack->Alloc((total & 0xF) ? (total >> 4) + 1 : total >> 4);
                            mos_effect_read_num += 1;
                        }
                    }
                }
            nextEffect:
                i += 1;
                offset += 4;
            } while (i < 4);
        }
    }
    return mos_effect_read_num;
}
extern "C" int MonsterEffectEnter__FP6CSceneP1i(CScene *scene, int loadBuffer, int texBlock) {
    int i;
    int savedBuffer;
    int offset;
    if (mos_effect_henge_param != NULL && 0 < mos_effect_read_num && FxScriptMan != NULL) {
        DeleteBlock__17mgCTextureManagerFi(&mgTexManager, texBlock);
        savedBuffer = *(int *)((u8 *)scene + 0x3C);
        offset = 0;
        i = 0;
        FxScriptMan->load_buffer = (u_long128*)loadBuffer;
        for (; i < mos_effect_read_num; i++) {
            char *effectName = *(char **)((u8 *)mos_effect_henge_param + offset + 0xC);
            if (effectName != NULL) {
                BuildBase__16CEffectScriptManFPcP1iP1iP9mgCMemoryi(
                    FxScriptMan, effectName, *(int *)((u8 *)mos_effect_readbuff1 + offset),
                    *(int *)((u8 *)mos_effect_readbuff1_size + offset),
                    *(int *)((u8 *)mos_effect_readbuff2 + offset),
                    *(int *)((u8 *)mos_effect_readbuff2_size + offset), (int)MorattaStack,
                    texBlock);
            }
            offset += 4;
        }
        FxScriptMan->load_buffer = (u_long128*)savedBuffer;
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
            if (MenuLoadInfo.unk_6[1] == 1) {
                MenuMainScene->AssignStack(5);
                stack = MenuMainScene->GetStack(5);
            }
            stack->stReset();
            MenuMonsterLoadBG(stack, MenuMonsterBGInfo, load_monster, 1);
            model_form->counter = -16;
            if (MenuLoadInfo.unk_6[1] == 1) {
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
                int texBlock = tex_block[1];
                MenuMonsterLoadBGCheck(MenuMonsterBGInfo, chara.entry, texBlock, MenuArg.chara_tex_block);
                if (MenuLoadInfo.unk_6[1] == 0) {
                    MonsterScaleCheck(chara.entry[0]);
                    chara.entry[0]->SetPosition(16.0f, 1.0f, 0.0f);
                    model_form->SetActionCharaPtr(monster, texBlock, -1);
                    model_form->counter = -14;
                    model_form->draw_flag = 1;
                    monster->Show(0, 1);
                    monster->fade = 1;
                    monster->fade_speed = 0.05f;
                }
                load_phase++;
                if (MenuLoadInfo.unk_6[1] == 1) {
                    load_phase++;
                    MenuSoundCharaNo = 3;
                    chara.entry[0] = (CActionChara *)MenuMainScene->GetCharacter(0);
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
        GetPutPosXY__16CMenuPosDataFormFPcRiRi(form, name, pos, pos + 1);
    }
}
void CMenuMosSelect::CalcCursorPosition() {
    int pos[2];
    if (BuildUpWeaponInfo.mode == 1) {
        int off = BuildUpWeaponInfo.select_no * 4;
        pos[0] = *(short *)((u8 *)&BuildUpNameXY[0][0] + off) - 0x14;
        pos[1] = *(short *)((u8 *)&BuildUpNameXY[0][1] + off);
    } else {
        GetBajjiPosition(badge_form, select, top, pos);
        pos[0] -= 0x1E;
        pos[1] += 0xE;
    }
    MenuPosStep__12CMenuKeyFuncFPiPi(MenuCommonInfo, pos, NULL);
    if (set_cursor != 0) {
        MenuSetPos__12CMenuKeyFuncFii(MenuCommonInfo, pos[0], pos[1]);
        set_cursor = 0;
    }
}
void CMenuMosSelect::CalcTex() {
    int item_pos[MES_ITEM_MAX][2];
    int win_pos[2];
    int badge_pos[2];
    int *pos;
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
    CDC2Mes *mes = MenuDCMsg[5];
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
    int oldCursor = select;
    MenuGlidKeyCheck__FiPiPiPiPiPii(keys, &select, &top, &max_3170, &viewnum_3171, overcode_3172,
                                    0xC);
    if (oldCursor != select) {
        MenuLoadInfo.unk_6[1] = 0;
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
void MenuMonsterBoxInit(mgCMemory *stack, int *tex_block, int mode) {
    CMenuMosSelect *menu;
    CActionChara *chara;
    int i;
    int size;

    mgCMemory memory;
    int rest = stack->stGetRest();
    memory.stSetBuffer(stack->stGetTop(), rest);
    stack = &memory;
    if ((menu = (CMenuMosSelect *)operator new(sizeof(CMenuMosSelect), (u_long128 *)stack->Alloc(0x769))) != NULL) {
        __ct__14CBaseMenuClassFv(menu);
        *(void **)((u8 *)menu + 0x10C) = __vt__14CMenuMosSelect;
        __ct__7CDC2MesFv(&menu->mes);
        __ct__6ClsMesFv(&menu->info_win);
        chara = menu->monster;
        do {
            __ct__12CObjectFrameFv(chara);
            *(void **)chara = __vt__11CCharacter2;
            Initialize__19CCharaFrameMatchingFv(&chara->shadow_link);
            ((CObject *)chara)->Initialize();
            *(void **)chara = __vt__12CActionChara;
            __ct__10CRunScriptFv(&chara->script);
            memset(&chara->move_check, 0, sizeof(chara->move_check));
            chara++;
        } while (chara < menu->monster + 1);
        __ct__12CObjectFrameFv(&menu->effect);
        *(void **)&menu->effect = __vt__11CCharacter2;
        Initialize__19CCharaFrameMatchingFv(&menu->effect.shadow_link);
        ((CObject *)&menu->effect)->Initialize();
        *(void **)&menu->effect = __vt__12CActionChara;
        __ct__10CRunScriptFv(&menu->effect.script);
        memset(&menu->effect.move_check, 0, sizeof(menu->effect.move_check));
        menu->effect_stack.Init();
        menu->unk_7620.Init();
        menu->key_arg_no = 0;
        menu->select = 0;
        menu->top = 0;
        menu->unk_5504 = 0;
        menu->mes_data = NULL;
        menu->monster->Initialize(NULL);
        menu->unk_765C = 0;
        menu->result = 0;
        menu->load_wait = 0;
        menu->load_phase = 0;
        menu->view_monster = -1;
        menu->pick_monster = -1;
        menu->load_monster = -1;
        menu->level_max = 0;
        menu->set_cursor = 1;
        menu->mes_show = 0;
        MenuMesInit(&menu->mes);
        menu->mes.texture_block = MenuArg.mes_tex_block;
        menu->badge = GetUserDataMan()->GetMonsterBajjiDataPtr(1);
        menu->select_badge = NULL;
        menu->info_win.texture_block = MenuArg.mes_tex_block;
        MenuMesInit(&menu->info_win);
        menu->info_win.SetWindowMode(4);
        menu->info_win.fuchi = 0;
        menu->info_win.fade_speed = 1.0f;
        menu->info_win.push_button = 0;
        menu->info_win.fukidashi_pos = 8;
        menu->info_win.alpha = 0;
        menu->effect_data = NULL;
        menu->effect_sound = NULL;
        menu->effect_show = 0;
        menu->effect_frame = 0;
        menu->info_win_show = 1;
        menu->skip_draw = 0;
        menu->change_wait = 0;
        menu->badge_form = NULL;
        menu->info_form = NULL;
        menu->model_form = NULL;
    }
    MenuMosSelectPtr = menu;
    menu->SetTexBlock(tex_block);
    MenuMosSelectPtr->FadeInMenu(40, 0.0f);
    for (i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
        MenuMonsterBGInfo[i] = NULL;
        if (tbl_3186[i]) {
            MenuMonsterBGInfo[i] = (MENU_BGREAD_INFO2 *)stack->Alloc(8);
            InitMenuBGReadInfo2(MenuMonsterBGInfo[i]);
        }
    }
    *(CameraPoint *)MenuMosSelectPtr->camera_pos = *(CameraPoint *)MenuDrawEnv->pos;
    *(CameraPoint *)MenuMosSelectPtr->camera_ref = *(CameraPoint *)MenuDrawEnv->ref;
    sceVu0CopyVector(MenuDrawEnv->pos, posdef_3194);
    sceVu0CopyVector(MenuDrawEnv->ref, refdef_3195);
    MenuDrawEnv->camera.SetPos(posdef_3194);
    MenuDrawEnv->camera.SetRef(refdef_3195);
    stack->Align64();
    u_int *pack = (u_int *)stack->stGetTop();
    size = LoadFileMenu(at_3269, (u_long128 *)pack, 1);
    stack->Alloc(blocks_for(size));
    u_char *image = (u_char *)GetPackFile(pack, at_3270, NULL);
    int block = MenuMosSelectPtr->tex_block[0];
    mgTexManager.EnterIMGFile(image, block, NULL, NULL);
    MenuMosTexture = mgTexManager.GetTexture(at_3271, block);
    MenuMosSelectPtr->mes_data = MenuDCMsg[0]->buff;
    s16 *boxMes = (s16 *)GetPackFile(pack, at_3272, NULL);
    MenuCommandAnalyzeInfo.system_mes_buff[0] = GetSystemMesBuffer();
    MenuCommandAnalyzeInfo.system_mes_buff[1] = boxMes;
    MenuCommandAnalyzeInfo.mes_buff[0] = MenuMosSelectPtr->mes_data;
    MenuCommandAnalyzeInfo.mes_buff[1] = boxMes;
    MenuMosSelectPtr->mes.SetMessData(GetSystemMesBuffer(), MenuMosSelectPtr->mes_data);
    MenuMosSelectPtr->info_win.SetBuff_system(GetSystemMesBuffer());
    MenuMosSelectPtr->info_win.SetBuff(MenuMosSelectPtr->mes_data);
    MenuMosSelectPtr->info_win.MakeMesWin(tbl_3196[LanguageCode], 1, 1);
    char *cfg = (char *)GetPackFile(pack, at_3273, &size);
    MenuDataAnalyze(cfg, size, stack);
    MenuMosSelectPtr->script = (char *)GetPackFile(pack, at_3274, &MenuMosSelectPtr->script_size);
    MenuMosSelectPtr->AttachForm();
    MenuMosSelectPtr->ExeScript(at_3275);
    MenuMosSelectPtr->ExeScript(at_3276);
    AttachMessageForm();
    stack->Align64();
    rest = stack->stGetRest();
    MenuMosLoadStack.stSetBuffer(stack->stGetTop(), rest);
    MenuLoadInfo.unk_2 = 1;
    MenuLoadInfo.mode = 0;
    MenuLoadInfo.unk_6[1] = 0;
    MenuMemoryAdjust(&MenuMosLoadStack, &MenuMonChangeLoadStack, MenuActionCharaBuffer, 3);
    int badgeNo = get_gajji_id_from_monster_progress_table(MenuUserDataManPtr->monster_id, NULL);
    if (badgeNo < 0) {
        badgeNo = 0;
    }
    if (badgeNo > MOS_SELECT_BADGE_NUM - 1) {
        badgeNo = 0;
    }
    MenuMosSelectPtr->select = badgeNo;
    if (MenuMosSelectPtr->badge[MenuMosSelectPtr->select].enable) {
        MenuMosSelectPtr->view_monster = MenuMosSelectPtr->badge[MenuMosSelectPtr->select].monster_id;
    }
}
#ifdef NONMATCHING
int CMenuMosSelect::KeyStep() {
    sceVu0FVECTOR effectPos;
    int size;
    int i;
    int keys = MenuCommonInfo->CheckSelectKey();
    int lrKeys = MenuCommonInfo->CheckLRKey();
    int buttons = MenuCommonInfo->CheckPushButton();
    int fadeEnd = MenuMosSelectPtr->FadeCheckMenu();
    CDC2Mes *command = MenuDCMsg[5];
    int showInfo = 0;
    int action;

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
                    CActionChara *player = (CActionChara *)MenuMainScene->GetCharacter(0);
                    if (player != NULL) {
                        player->effect_man = FxScriptMan;
                        player->InitScript();
                    }
                    MenuArg.end_code = 1;
                    MenuArg.result[0] = 3;
                }
                MenuDrawEnv->camera.SetPos(camera_pos);
                MenuDrawEnv->camera.SetRef(camera_ref);
                *(CameraPoint *)MenuDrawEnv->pos = *(CameraPoint *)camera_pos;
                *(CameraPoint *)MenuDrawEnv->ref = *(CameraPoint *)camera_ref;
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
                                if (select_badge == NULL || !select_badge->enable) {
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
                                effect_sound = (u32 *)((u8 *)effect_data + 0x39800);
                                effect_stack.stSetBuffer(
                                    MenuMonChangeLoadStack.stack + MenuMonChangeLoadStack.stack_size - 0x3B80, 0x3980);
                                StartReadBG();
                                LoadFileBG(at_3689, (u_long128 *)effect_sound, &size);
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
                                effect.LoadPack((u_int *)effect_data, at_3692, &effect_stack, &effect_stack, &effect_stack,
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
                            view_monster = monster_progress_tbl[select_badge->progress * (1 + MONSTER_PROGRESS_LEVEL_NUM) + 1 + cursor];
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
                    s16 *row = &monster_progress_tbl[select_badge->progress * (1 + MONSTER_PROGRESS_LEVEL_NUM)];
                    int count = select_badge->class_level + 1;
                    int level = -1;
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
                    int commandNum = 3;
                    int row = 0;
                    MenuCommandList commands = at_3481;
                    for (; row < commandNum; row++) {
                        if (commands.mes[row] == 0x14B6) {
                            if (MenuCommonInfo->now_mode == 2 || GetMenuLoopType() == 0) {
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
                        names.name[i] = GetMonsterName(monster_progress_tbl[select_badge->progress * (1 + MONSTER_PROGRESS_LEVEL_NUM) + 1 + i]);
                        if (GetUserDataMan()->active_chr_no == 3 &&
                            monster_progress_tbl[select_badge->progress * (1 + MONSTER_PROGRESS_LEVEL_NUM) + 1 + i] == GetUserDataMan()->monster_id &&
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
                    MenuLoadInfo.unk_6[1] = 1;
                    if (MenuLoadInfo.unk_6[1] == 1 && FxScriptMan != NULL) {
                        DeleteMonsterEffect();
                    }
                    GetCharaMemAllocPtr(MenuArg.chara_stack, MorattaStack, 3, 0);
                    MenuMosLoadStack.stReset();
                    MenuLoadInfo.mode = 2;
                    MenuLoadInfo.unk_6[1] = 1;
                    result = MOS_SELECT_RESULT_CHANGE;
                    monster->Initialize(NULL);
                    load_wait = 0;
                    load_phase = 0;
                    FadeOutMenu(40, 0.0f);
                    mode = 2;
                    MOS_CHANGE_PARAM *chosen = select_badge;
                    s16 monsterNo = monster_progress_tbl[chosen->progress * (1 + MONSTER_PROGRESS_LEVEL_NUM) + 1 + info->GetMsgCursor()];
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
                    BuildUpWeaponInfo.unk_0 = 1;
                    step = 10;
                    int monsterNo = monster_progress_tbl[select_badge->progress * (1 + MONSTER_PROGRESS_LEVEL_NUM) + 1 + select_badge->class_level];
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
        int base = view_monster * 10 + 10000;
        int degree = select_badge->GetDegreeLevel();
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
extern "C" void MenuMonsterBoxKey__Fv(void) {
    MenuMosSelectPtr->KeyStep();
}
void MenuMonsterBoxDraw() {
    MenuPosData->FormDraw();
    mgCTextureManager *texManager = &mgTexManager;
    texManager->ReloadTexture(MenuMosSelectPtr->mes.texture_block, (sceVif1Packet *)NULL);
    if (MenuMosSelectPtr->mes_show) {
        MenuMosSelectPtr->mes.StepMsg();
        MenuMosSelectPtr->mes.DrawMsg();
    }
    if (MenuMosSelectPtr->info_win_show) {
        MenuMosSelectPtr->info_win.Step();
        MenuMosSelectPtr->info_win.DrawMesWin();
    }
    if (MenuMosSelectPtr->effect_show && MenuMosSelectPtr->effect_frame > 20) {
        texManager->ReloadTexture(MenuMosSelectPtr->tex_block[2], (sceVif1Packet *)NULL);
        CActionChara *effect = &MenuMosSelectPtr->effect;
        effect->DrawDirect();
    }
    if (menu_debug_flag) {
        int y = 100;
        DrawMenuFillBox(350.0f, 100.0f, 100.0f, 260.0f, 0x40, 0, 0, 0);
        CMenuFont font;
        char text[0x40];
        font.SetStr(at_3762);
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
    if (GetTimeBand__Ff(scene->time) != kTimeBandNight) {
        sun->SetAttrParamDraw(1, 0);
        moon->SetAttrParamDraw(0, 0);
    } else {
        sun->SetAttrParamDraw(0, 0);
        moon->SetAttrParamDraw(1, 0);
    }
}
void MenuWeaponRealStepEnvFunc(CActionChara *chara, int step) {
    mgCFrame *object;
    float rotation[4];
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
    char name[MENU_CHARA_LOAD_MAX][0x40];
    CharaPathKinds pathKind;
    int i;

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
    pathKind = at_3810;
    for (u32 slot = 0; slot < MENU_CHARA_LOAD_MAX; slot++) {
        name[slot][0] = 0;
    }
    MenuLoadInfo.unk_3 = chara_no;
    strcpy(name[0], menu_chara_chrtbl[chara_no]);
    strcpy(name[1], GetItemFileName__Fii(MenuLoadItemNo[4], 1));
    switch (MenuLoadInfo.mode) {
        case 0:
        case 3:
            if (MenuLoadInfo.mode == 3) {
                strcpy(name[0], at_3913);
            }
            for (i = 0; i < 4; i++) {
                if (MenuLoadItemNo[i] > 0) {
                    strcpy(name[i + 2], GetItemFileName__Fii(MenuLoadItemNo[i], 1));
                } else if (MenuActionChara[i + 1] != NULL) {
                    MenuActionChara[i + 1]->ResetParent();
                    MenuActionChara[i + 1]->Initialize(NULL);
                }
            }
            break;
        case 1:
            strcpy(name[0], at_3913);
            if (0 < MenuLoadItemNo[2]) {
                strcpy(name[4], GetItemFileName__Fii(MenuLoadItemNo[2], 1));
            }
            if (0 < MenuLoadItemNo[3]) {
                strcpy(name[5], GetItemFileName__Fii(MenuLoadItemNo[3], 1));
            }
            break;
        case 2:
            pathKind.kind[0] = pathtbl_3836[MenuLoadInfo.unk_1];
            if (MenuLoadInfo.unk_1 == 0) {
                pathKind.kind[0] = 4;
                GetMainCharaModelName(chara_no, name[0], 0);
            }
            if (MenuLoadInfo.unk_1 == 1) {
                pathKind.kind[0] = 5;
                GetMainCharaModelName(chara_no, name[0], 1);
            }
            if (MenuLoadInfo.unk_4 < 0) {
                name[1][0] = 0;
            }
            if (0 < MenuLoadInfo.unk_4) {
                name[0][0] = 0;
                for (i = 0; i < 4; i++) {
                    if (MenuLoadItemNo[i] > 0) {
                        strcpy(name[i + 2], GetItemFileName__Fii(MenuLoadItemNo[i], 1));
                    }
                }
                strcpy(name[6], menu_chara_cfg_chrtbl[chara_no]);
                if (MenuLoadInfo.unk_1 == 1) {
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
        if (MenuLoadInfo.unk_2 == 1 || (MenuLoadInfo.unk_2 == 0 && i == MenuLoadInfo.unk_5)) {
            strcpy(info[i]->path, menu_load_chrpathtbl_3811[pathKind.kind[i]]);
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
static void MenuItemCharaDataLoadPack(int chara_no, CActionChara *chara, CActionChara *body, int part,
                                      u_int *pack, mgCMemory *stack, int tex_block, int blur_type) {
    mgCTextureManager *texManager = &mgTexManager;

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
                texManager->DeleteTexAnime(tex_block);
                body->LoadSkin(pack, menu_infocfgname, at_2287, stack, tex_block);
                break;
            case 2:
            case 3:
            case 4:
                if (MenuLoadInfo.mode != 2) {
                    if (part == 3 && body != NULL) {
                        for (int group = body->tex_anime_group_start; group < 24; group++) {
                            texManager->DeleteTexAnimeGroup(tex_block, group);
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
    int i;
    mgCTextureManager *texManager = &mgTexManager;
    CScene *scene = MenuMainScene;
    CActionChara *player = NULL;
    SceneCharaList sceneChara = at_3974;
    SceneCharaList menuChara = at_3975;

    if (chara != NULL) {
        menuChara.entry[0] = chara[0];
        menuChara.entry[1] = NULL;
        menuChara.entry[2] = chara[1];
        menuChara.entry[3] = chara[2];
        menuChara.entry[4] = chara[3];
        menuChara.entry[5] = chara[4];
        menuChara.entry[6] = chara[5];
    }
    if (scene != NULL && MenuLoadInfo.unk_6[1] != 0) {
        for (i = 0; i < MENU_CHARA_LOAD_MAX; i++) {
            sceneChara.entry[i] = (CActionChara *)scene->GetCharacter(i);
        }
        player = sceneChara.entry[0];
        if (MenuLoadInfo.mode == 0 || MenuLoadInfo.mode == 1) {
            sceneChara.entry[0] = NULL;
        }
        if (MenuLoadInfo.unk_1 == 1) {
            sceneChara.entry[1] = NULL;
            if (chara_no == 0) {
                sceneChara.entry[2] = NULL;
            }
        }
    }
    LoadTargetList8 sceneTarget = at_3993;
    sceneTarget.entry[0] = sceneChara.entry[0];
    sceneTarget.entry[1] = player;
    sceneTarget.entry[2] = sceneChara.entry[1];
    sceneTarget.entry[3] = sceneChara.entry[2];
    sceneTarget.entry[4] = sceneChara.entry[3];
    sceneTarget.entry[5] = sceneChara.entry[4];
    sceneTarget.entry[6] = sceneChara.entry[5];
    switch (MenuLoadInfo.mode) {
        case 2:
            if (MenuLoadInfo.unk_4 <= 0) {
                texManager->DeleteBlock(scene_tex_block);
            }
            break;
        default:
            if ((MenuLoadInfo.unk_2 == 0 && MenuLoadInfo.unk_4 < 0 && MenuLoadInfo.unk_5 == 0) ||
                MenuLoadInfo.unk_2 == 1 || MenuLoadInfo.mode == 1) {
                if (0 < tex_block) {
                    texManager->DeleteBlock(tex_block);
                    for (int slot = 0; slot < 6; slot++) {
                        if (menuChara.entry[slot] != NULL) {
                            menuChara.entry[slot]->Initialize(NULL);
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
        info[i]->chara = menuChara.entry[i];
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
                strcpy(texManager->name_suffix, at_4123);
                MenuItemCharaDataLoadPack(chara_no, info[i]->chara, info[0]->chara, i, (u_int *)read->buffer, buffer,
                                          tex_block, -1);
                texManager->name_suffix[0] = 0;
                break;
        }
        switch (MenuLoadInfo.mode) {
            case 0:
            case 2:
                if (sceneTarget.entry[i] != NULL) {
                    mgCMemory *sceneStack = &MorattaStack[i];
                    sceneStack->stReset();
                    MenuItemCharaDataLoadPack(chara_no, sceneTarget.entry[i], player, i, (u_int *)read->buffer,
                                              sceneStack, scene_tex_block, chara_no);
                    if (i == 0 && sceneTarget.entry[0] != NULL) {
                        player->SetPosition(menu_old_chara_position);
                    }
                }
                break;
        }
        info[i]->reading = 0;
    }
    if (MenuLoadInfo.unk_2 == 0) {
        if (MenuLoadInfo.unk_4 < 0) {
            MenuLoadInfo.unk_5++;
        } else {
            MenuLoadInfo.unk_5 = 7;
        }
    }
    if (MenuLoadInfo.mode == 2) {
        if (MenuLoadInfo.unk_4 <= 0) {
            MenuLoadInfo.unk_4 = 1;
        } else {
            MenuLoadInfo.unk_4 = 2;
        }
    }
    if (info[6] != NULL) {
        BG_READ_INFO *script = GetReadBGInfo(info[6]->path);
        if (script != NULL) {
            if (MenuLoadInfo.mode != 2) {
                info[0]->chara->LoadActionFile((char *)script->buffer, script->size, &MenuActionCharaBuffer[6]);
                info[6]->reading = 0;
            }
            if (MenuLoadInfo.unk_6[1] != 0) {
                MorattaStack[6].stReset();
                if (sceneChara.entry[0] != NULL) {
                    sceneChara.entry[0]->LoadActionFile((char *)script->buffer, script->size, &MorattaStack[6]);
                }
            }
            MenuLoadInfo.unk_5++;
        }
    }
    switch (MenuLoadInfo.unk_2) {
        case 0:
            if (MenuLoadInfo.unk_4 == -1 && MenuLoadInfo.unk_5 < 7) {
                stack->stReset();
                stack->Align64();
                MenuItemCharaDataLoad(stack, chara_no, info, 1);
            }
            break;
        case 1:
            switch (MenuLoadInfo.mode) {
                case 2:
                    if (MenuLoadInfo.unk_4 == 1) {
                        stack->stReset();
                        stack->Align64();
                        MenuItemCharaDataLoad(stack, chara_no, info, 1);
                    }
                    if (MenuLoadInfo.unk_4 == 2) {
                        MenuItemCharaDataLoadEndCheckAfter(info, chara_no);
                    }
                    break;
            }
            break;
    }
    switch (MenuLoadInfo.mode) {
        case 0:
        case 3:
            if (MenuLoadInfo.unk_2 == 1 || (MenuLoadInfo.unk_2 == 0 && MenuLoadInfo.unk_5 >= 6)) {
                MenuItemCharaDataLoadEndCheckAfter(info, chara_no);
                MenuLoadInfo.unk_4 = -2;
                return 1;
            }
            break;
    }
    return 0;
}
unsigned int MenuCharaSoundLoad(mgCMemory *stack, int charaNo, int background) {
    char path[0x60];
    int size;
    unsigned int blocks;
    CharaSndBuffer = NULL;
    MenuSoundCharaNo = charaNo;
    size = 0;
    stack->Align64();
    CharaSndBuffer = (u32*)(stack->stack + stack->stack_used);
    if (charaNo < 3) {
        GetCharacterSnd__FP16CUserDataManageriPc(GetUserDataMan(), charaNo, path);
    } else {
        GetMonsterModelFile__FiiPc(GetUserDataMan()->monster_id, 1, path);
    }
    if (background != 0) {
        LoadFileBG(path, (u_long128 *)CharaSndBuffer, &size);
    } else {
        LoadFile2(path, CharaSndBuffer, &size, 0);
    }
    blocks = (size & 0xF) ? ((unsigned int)size >> 4) + 1 : (unsigned int)size >> 4;
    stack->Alloc(blocks);
    return size;
}
void MenuCharaSoundEnter(CScene *scene, CActionChara *chara, int openPort) {
    signed char charaIds[4];
    if (scene != NULL && chara != NULL) {
        chara->sound_info.foot_se_bank = scene->se_base_id;
        chara->sound_info.foot_sound_id = -1;
        if (openPort != 0) {
            sndInitPort__Fi(7);
        }
        unsigned int *buffer = (unsigned int *)CharaSndBuffer;
        if (buffer != NULL) {
            int index;
            *(float *)charaIds = at_4158;
            index = MenuSoundCharaNo;
            if (index < 0) {
                index = 0;
            }
            chara->sound_info.se_bank =
                sndLoadSound__FiPUiP9mgCMemory(7, buffer, MorattaStack + charaIds[index]);
        }
        chara->sound_info.se_bank_2 = scene->se_battle_id;
        chara->SetSoundInfoCopy();
    }
}
unsigned int MenuItemChrLoad(mgCMemory *stack, int itemNo, int variant, MENU_BGREAD_INFO2 *info,
                    int restart) {
    unsigned int size;
    unsigned int blocks;
    if (restart != 0) {
        BreakReadBG();
        StartReadBG();
    }
    GetGameDataPt__Fv();
    info->reading = 1;
    info->chara = 0;
    strcpy((char *)info, GetItemFileName__Fii(itemNo, 0));
    if (variant == 1) {
        strcat((char *)info, at_4186__2);
    }
    strcpy((char *)&info->path, GetItemFilePath__Fii(itemNo, 1));
    size = 0;
    stack->Align64();
    if (LoadFileBG((char *)&info->path, (u_long128 *)(stack->stack + stack->stack_used),
                   (int *)&size) == 0) {
        info->reading = 0;
    } else {
        blocks = (size & 0xF) ? (size >> 4) + 1 : size >> 4;
        stack->Alloc(blocks);
        stack->Align64();
    }
    return size;
}
int MenuItemChrLoadEndCheck(MENU_BGREAD_INFO2 *info, CActionChara *chara, mgCMemory *memory,
                            int texBlock) {
    if (info->reading != 0) {
        u8 *loaded = GetReadBGInfo__FPc((char *)&info->path);
        u8 *texManager = (u8 *)&mgTexManager;
        int modelBuffer;
        DeleteBlock__17mgCTextureManagerFi(texManager, texBlock);
        modelBuffer = *(int *)(loaded + 0x110);
        memory->stack_used = 0;
        memory->lock = 0;
        info->chara = chara;
        if (chara != NULL) {
            strcpy((char *)(texManager + 0x1D8), at_4123);
            chara->Initialize(NULL);
            chara->LoadPack((u_int *)modelBuffer, menu_infocfgname, memory, memory, memory, texBlock,
                             0);
            texManager[0x1D8] = 0;
        }
        info->reading = 0;
        return 1;
    }
    return 0;
}
extern s8 convItoPhase_4229[6];
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
        } else if (MenuLoadInfo.unk_5 == convItoPhase_4229[i] || MenuLoadInfo.unk_2 == 1) {
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
            char *file = GetItemFileName__Fii(MenuLoadItemNo[i], 1);
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
    if (MenuLoadInfo.mode == 2 || (MenuLoadInfo.unk_2 == 0 && MenuLoadInfo.unk_5 == 6)) {
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
        mgCTextureManager *texManager = &mgTexManager;
        sprintf(name, at_4296, chara->outline_tex_no);
        if (alternate != 0) {
            strcat(name, at_4123);
        }
        texManager->DeleteTexture(name, -1);
    }
}
int MenuItemRoboDataLoadEndCheck(MENU_BGREAD_INFO2 **info, mgCMemory *stack, CActionChara **chara, int tex_block,
                                 int scene_tex_block) {
    CActionChara *parent = NULL;
    mgCTextureManager *texManager = &mgTexManager;
    CScene *scene = MenuMainScene;
    RoboCharaList sceneChara = at_4300__2;
    int i;
    mgCMemory *partStack;

    if (scene != NULL && MenuLoadInfo.unk_6[1] != 0) {
        for (i = 0; i < 6; i++) {
            sceneChara.entry[i] = (CActionChara *)scene->GetCharacter(i);
        }
    }
    if (MenuLoadInfo.mode == 2) {
        texManager->DeleteBlock(scene_tex_block);
    } else if ((MenuLoadInfo.unk_4 < 0 && MenuLoadInfo.unk_5 == 0) || MenuLoadInfo.unk_2 == 1) {
        if (0 < tex_block) {
            texManager->DeleteBlock(tex_block);
            if (MenuLoadInfo.unk_6[1] != 0) {
                texManager->DeleteBlock(scene_tex_block);
            }
        }
    }
    if (MenuLoadInfo.unk_2 == 0 && MenuLoadInfo.unk_4 == 0) {
        if (MenuLoadInfo.unk_6[1] != 0) {
            DeleteOutLineMenu(sceneChara.entry[0], 0);
        }
        if (chara[0] != NULL) {
            DeleteOutLineMenu(chara[0], 1);
        }
    }
    RoboStackList menuStack = at_4327;
    RoboStackList sceneStack = at_4328;
    sceneStack.entry[1] = &MorattaStack[1];
    sceneStack.entry[0] = &MorattaStack[0];
    sceneStack.entry[2] = &MorattaStack[2];
    sceneStack.entry[4] = &MorattaStack[3];
    sceneStack.entry[3] = &MorattaStack[2];
    sceneStack.entry[5] = &MorattaStack[2];
    SceneCharaList menuChara = at_4329;
    menuChara.entry[0] = chara[0];
    menuChara.entry[1] = chara[1];
    menuChara.entry[2] = chara[2];
    menuChara.entry[3] = chara[3];
    menuChara.entry[4] = chara[4];
    menuChara.entry[5] = chara[5];
    for (int part = 0; part < 6; part++) {
        if (info[part] == NULL || info[part]->reading == 0) {
            continue;
        }
        BG_READ_INFO *read = GetReadBGInfo(info[part]->path);
        if (read == NULL) {
            continue;
        }
        u_int *pack = (u_int *)read->buffer;
        CActionChara **slot = &menuChara.entry[part];
        info[part]->chara = *slot;
        if (MenuLoadInfo.mode == 2) {
            menuChara.entry[part] = NULL;
        }
        if (MenuLoadInfo.mode != 2) {
            if (part == 2) {
                strcpy(texManager->name_suffix, at_4123);
                if (menuChara.entry[2] != NULL) {
                    menuChara.entry[2]->DeleteImage();
                }
                if (menuChara.entry[3] != NULL) {
                    menuChara.entry[3]->DeleteImage();
                }
                if (menuChara.entry[5] != NULL) {
                    menuChara.entry[5]->DeleteImage();
                }
                texManager->name_suffix[0] = 0;
                if (MenuLoadInfo.unk_6[1] != 0) {
                    if (sceneChara.entry[2] != NULL) {
                        sceneChara.entry[2]->DeleteImage();
                    }
                    if (sceneChara.entry[3] != NULL) {
                        sceneChara.entry[3]->DeleteImage();
                    }
                    if (sceneChara.entry[5] != NULL) {
                        sceneChara.entry[5]->DeleteImage();
                    }
                }
            } else if (part != 3 && part != 5) {
                CActionChara *model = *slot;
                if (model != NULL) {
                    strcpy(texManager->name_suffix, at_4123);
                    model->DeleteImage();
                    texManager->name_suffix[0] = 0;
                }
                if (MenuLoadInfo.unk_6[1] != 0 && sceneChara.entry[part] != NULL) {
                    sceneChara.entry[part]->DeleteImage();
                }
            }
        }
        switch (MenuLoadInfo.mode) {
            case 2: {
                if (part > 0) {
                    parent = sceneChara.entry[0];
                }
                partStack = sceneStack.entry[part];
                if (part != 3 && part != 5 && partStack != NULL) {
                    partStack->stReset();
                }
                if (part == 0) {
                    sceneChara.entry[part]->AllDeleteDamage();
                    texManager->DeleteTexAnime(tex_block);
                }
                CActionChara *model = sceneChara.entry[part];
                if (model != NULL) {
                    model->Initialize(NULL);
                    model->LoadPack(pack, menu_infocfgname, partStack, partStack, partStack, scene_tex_block, parent);
                }
                if (parent != NULL && CheckBattleLoop() && part == 1) {
                    SetSwordBlurEffect(parent, partStack, 2);
                }
                break;
            }
            case 0: {
                strcpy(texManager->name_suffix, at_4123);
                CActionChara *model = *slot;
                if (model != NULL) {
                    if (part > 0) {
                        parent = menuChara.entry[0];
                    }
                    if (part == 0) {
                        texManager->DeleteTexAnime(tex_block);
                    }
                    partStack = menuStack.entry[part];
                    if (part != 3 && part != 5 && partStack != NULL) {
                        partStack->stReset();
                    }
                    partStack->Align64();
                    model->Initialize(NULL);
                    model->LoadPack(pack, menu_infocfgname, partStack, partStack, partStack, tex_block, parent);
                }
                texManager->name_suffix[0] = 0;
                CActionChara *sceneModel = sceneChara.entry[part];
                if (sceneModel != NULL && MenuLoadInfo.unk_6[1] != 0) {
                    if (part > 0) {
                        parent = sceneChara.entry[0];
                    }
                    if (part == 0) {
                        texManager->DeleteTexAnime(scene_tex_block);
                    }
                    partStack = sceneStack.entry[part];
                    if (part != 3 && part != 5 && partStack != NULL) {
                        partStack->stReset();
                    }
                    sceneModel->Initialize(NULL);
                    sceneModel->LoadPack(pack, menu_infocfgname, partStack, partStack, partStack, scene_tex_block,
                                         parent);
                    if (CheckBattleLoop()) {
                        if (part == 0) {
                            SetSwordBlurEffect(sceneChara.entry[0], partStack, 2);
                        }
                        if (part == 1) {
                            SetSwordBlurEffect(parent, partStack, 2);
                        }
                    }
                }
                break;
            }
        }
        info[part]->reading = 0;
    }
    if (MenuLoadInfo.unk_2 == 0) {
        if (MenuLoadInfo.unk_4 < 0) {
            if (MenuLoadInfo.unk_5 == 2) {
                MenuLoadInfo.unk_5 += 2;
            } else if (MenuLoadInfo.unk_5 == 4) {
                MenuLoadInfo.unk_5 += 2;
            } else {
                MenuLoadInfo.unk_5++;
            }
        } else {
            MenuLoadInfo.unk_5 = 7;
        }
    }
    BG_READ_INFO *script = GetReadBGInfo(info[6]->path);
    if (script != NULL) {
        mgCMemory *scriptStack = &MorattaStack[4];
        switch (MenuLoadInfo.mode) {
            case 2:
                if (sceneChara.entry[0] != NULL) {
                    scriptStack->stReset();
                    sceneChara.entry[0]->LoadActionFile((char *)script->buffer, script->size, scriptStack);
                }
                break;
            default:
                if (sceneChara.entry[0] != NULL) {
                    scriptStack->stReset();
                    sceneChara.entry[0]->LoadActionFile((char *)script->buffer, script->size, scriptStack);
                }
                info[6]->reading = 0;
                break;
        }
        MenuLoadInfo.unk_5++;
    }
    if (MenuLoadInfo.unk_2 == 0 && MenuLoadInfo.unk_4 == -1 && MenuLoadInfo.unk_5 < 7) {
        stack->stReset();
        stack->Align64();
        MenuItemRoboDataLoad(stack, info, 1);
    }
    if (MenuLoadInfo.unk_2 == 1 || (MenuLoadInfo.unk_2 == 0 && MenuLoadInfo.unk_5 > 6)) {
        MenuItemCharaDataLoadEndCheckAfter(info, 2);
        MenuLoadInfo.unk_4 = -2;
    }
    return 0;
}
extern "C" void MenuRoboPartsLightOff__FP8mgCFrame(mgCFrame *arg0) {
    struct temp_v0_champs_a42004 *temp_v0;

    if (arg0 != NULL) {
        temp_v0 =
            (struct temp_v0_champs_a42004 *)(SearchFrame__8mgCFrameFPc(arg0, &at_4517__2));
        if (temp_v0 != NULL) {
            temp_v0->unkF4->unk18 = 0;
        }
    }
}
#ifdef NONMATCHING
int MenuMonsterLoadBG(mgCMemory *stack, MENU_BGREAD_INFO2 **info, int monster_no, int restart_read) {
    char model[0x40];
    char script[0x40];
    char path[0x6C];
    int size;

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
    monster_load_id = monster_no;
    if (GetMonsterModelFile(monster_no, 0, model) == 0) {
        return 0;
    }
    GetMonsterModelFile(monster_no, 2, script);
    strcpy(info[0]->name, model);
    strcpy(path, MonsterDataPath[dir]);
    strcat(path, model);
    strcpy(info[0]->path, path);
    stack->Align64();
    if (LoadFileBG(info[0]->path, stack->stGetTop(), &size) == 0) {
        return 1;
    }
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
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuMonsterLoadBG__FP9mgCMemoryPP17MENU_BGREAD_INFO2ii);
#endif
extern SceneCharaList at_4565;
extern LoadTargetList at_4585;
extern LoadStackList at_4586;
int MenuMonsterLoadBGCheck(MENU_BGREAD_INFO2 **info, CActionChara **chara, int tex_block,
                           int scene_tex_block) {
    SceneCharaList sceneChara;
    char path[0x80];
    char name[0x20];
    mgCTextureManager *texManager = &mgTexManager;
    int i;

    if (MenuLoadInfo.mode == 2) {
        texManager->DeleteBlock(scene_tex_block);
    } else if (0 < tex_block) {
        texManager->DeleteBlock(tex_block);
    }
    CScene *scene = MenuMainScene;
    sceneChara = at_4565;
    if (MenuLoadInfo.unk_6[1] != 0 || MenuLoadInfo.mode == 2) {
        for (i = 0; i < 7; i++) {
            sceneChara.entry[i] = (CActionChara *)scene->GetCharacter(i);
        }
    }
    info[0]->reading = 0;
    BG_READ_INFO *model = GetReadBGInfo(info[0]->path);
    if (model == NULL) {
        return 0;
    }
    u_int *pack = (u_int *)model->buffer;
    info[0]->chara = chara[0];
    GetMonsterModelFile(monster_load_id, 3, name);
    if (MenuLoadInfo.mode != 2) {
        mgCMemory *buffer = MenuActionCharaBuffer;
        buffer->stReset();
        strcpy(texManager->name_suffix, at_4123);
        if (chara[0] != NULL) {
            chara[0]->Initialize(NULL);
            chara[0]->LoadPackNoLine(pack, name, buffer, buffer, buffer, tex_block, NULL);
        }
        texManager->name_suffix[0] = 0;
    } else {
        info[0]->chara = NULL;
        mgCMemory *stack = MorattaStack;
        stack->stReset();
        if (sceneChara.entry[0] != NULL) {
            sceneChara.entry[0]->AllDeleteDamage();
            sceneChara.entry[0]->Initialize(NULL);
            sceneChara.entry[0]->LoadPack(pack, name, stack, stack, stack, scene_tex_block, NULL);
            SetSwordBlurEffect(sceneChara.entry[0], stack, 3);
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
        targets.entry[2] = sceneChara.entry[0];
        LoadStackList stacks = at_4586;
        stacks.entry[2] = &MorattaStack[5];
        mgCMemory *stack = stacks.entry[MenuLoadInfo.mode];
        CActionChara *target = targets.entry[MenuLoadInfo.mode];
        stack->stReset();
        if (target != NULL) {
            target->LoadActionFile((char *)script->buffer, script->size, stack);
        }
        info[5]->reading = 0;
        MenuLoadInfo.unk_5++;
    }
    MenuItemCharaDataLoadEndCheckAfter(info, 3);
    MenuLoadInfo.unk_4 = -2;
    return 1;
}
#ifdef NONMATCHING
void MenuItemCharaDataLoadEndCheckAfter(MENU_BGREAD_INFO2 **info, int chara_no) {
    CUserDataManager *userData = MenuUserDataManPtr;
    ROBO_INFO_DATA *robo = GetRoboPartsInfo(userData);
    if (MenuLoadInfo.unk_6[1] != 0) {
        SetupUnitMan(MenuMainScene, userData, chara_no, robo);
    }
    if (MenuLoadInfo.mode == 2) {
        return;
    }
    CScene scene;
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
#ifdef NONMATCHING
void InitMainCharaBG(int chara_no, mgCMemory *stack, int mode) {
    int reason;
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
    int rest = stack->stGetRest();
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
    MenuLoadInfo.unk_2 = 1;
    MenuLoadInfo.unk_1 = mode;
    MenuLoadInfo.unk_3 = NowReadMainCharaNo;
    MenuLoadInfo.unk_4 = -1;
    MenuLoadInfo.unk_5 = 0;
    MenuLoadInfo.unk_6[0] = 0;
    MenuLoadInfo.unk_6[1] = 1;
    NowReadMainChara = (CActionChara *)MenuMainScene->GetCharacter(0);
    if (NowReadMainChara != NULL) {
        NowReadMainChara->GetPosition(NowMainReadPosition);
        NowReadMainChara->GetRotation(NowMainReadRotation);
    }
    MenuUserParam.chara[0] = GetUserDataMan()->GetCharaDataPtr(0);
    MenuUserParam.chara[1] = GetUserDataMan()->GetCharaDataPtr(1);
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
            if (MenuLoadInfo.unk_1 == 1) {
                EditCharaPrepare();
            }
            MenuLoadInfo.unk_4 = -1;
            MenuItemCharaDataLoad(&MenuCharaLoadStack, NowReadMainCharaNo, MenuCharaBuild2, 1);
            break;
        case 2:
            MenuItemRoboDataLoad(&MenuCharaLoadStack, MenuCharaBuild2, 1);
            break;
        case 3:
            NowReadMainCharaMonsterNo = GetUserDataMan()->monster_id;
            if (NowReadMainCharaMonsterNo < 0) {
                GetUserDataMan()->monster_id = 0x34;
                NowReadMainCharaMonsterNo = 0x34;
            }
            for (int i = 1; i < 5; i++) {
                CActionChara *chara = (CActionChara *)MenuMainScene->GetCharacter(i);
                if (chara != NULL) {
                    chara->Initialize(NULL);
                }
            }
            MenuMonsterLoadBG(&MenuCharaLoadStack, MenuCharaBuild2, NowReadMainCharaMonsterNo, 1);
            break;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", InitMainCharaBG__FiP9mgCMemoryi);
#endif
int ReadMainCharaBG() {
    char model[0x48];
    int size;
    int scriptSize;

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
                CharaSndBuffer = (u32 *)MenuCharaLoadStack.stGetTop();
                LoadFileBG(model, (u_long128 *)CharaSndBuffer, &size);
                MenuCharaLoadStack.Alloc(blocks_for(size + 0x2800));
            }
            if (MenuLoadInfo.unk_1 == 0 && NowReadMainCharaNo < 3) {
                MenuCharaLoadStack.Align64();
                LoadFileBG(at_4868, MenuCharaLoadStack.stGetTop(), &scriptSize);
            }
            NowReadMainCharaPhase++;
            break;
        case 2:
            switch (NowReadMainCharaNo) {
                case 0:
                case 1:
                case 2:
                    if (MenuLoadInfo.unk_1 != 1) {
                        mgTexManager.EnterIMGFile((u_char *)GetReadBGFile(1)->buffer, MenuCommonInfo->tex_block[1],
                                                  NULL, NULL);
                        CopyActiveItemAndWeapon(NowReadMainCharaNo, -1);
                        mgTexManager.DeleteBlock(MenuCommonInfo->tex_block[1]);
                    }
                    break;
                case 3:
                    break;
            }
            if (MenuLoadInfo.unk_1 == 0) {
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
int KeyMainCharaBG(void) {
    int readState;

    readState = ReadMainCharaBG();
    if (MenuLoadInfo.unk_1 == 1) {
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
    if (readState == 2) {
        if (mgScreenWidth <= NowMainCharaChngTexMoveX) {
            NowMainCharaChngTex = NULL;
            NowReadMainCharaNo = -1;
            return 1;
        }
    }
    return 0;
}
void DrawMainCharaBG(void) {
    mgRect<int> frameRect;
    mgRect<int> slideRect;
    int loadedTex;

    loadedTex = -1;
    if (NowMainCharaFrameImage != NULL) {
        MenuReloadTexture(loadedTex, NowMainCharaFrameImage->block);
        frameRect.Set(0, 0, 0x200, mgScreenHeight);
        PrimQuad(NowMainCharaFrameImage, 0.0f, 0.0f, frameRect, 0x80, 0x80, 0x80, 0x80);
    }
    if (!(NowMainCharaChngStatusBit & 2)) {
        MenuReloadTexture(loadedTex, MenuArg.mes_tex_block);
        MenuDCMsg[0]->StepMsg();
        MenuDCMsg[0]->DrawMsg();
        return;
    }
    if (NowMainCharaChngTex != NULL) {
        MenuReloadTexture(loadedTex, NowMainCharaChngTex->block);
        slideRect.Set(0, NowReadMainCharaNo << 6, 0x100, 0x40);
        PrimQuad(NowMainCharaChngTex, (float)NowMainCharaChngTexMoveX, 180.0f, slideRect, 0x80, 0x80,
                 0x80, 0x80);
    }
}
int MenuNPCModelLoad(mgCMemory *memory, int charaNo, int background) {
    int size;
    u8 *buffer;
    char *name;

    MenuNPCLoadFlag = 0;
    memory->Align64();
    name = GetPartyCharaModelName(charaNo, 3);
    buffer = memory_free_top(memory);
    MenuPartyNPCModelReadBuffer = buffer;
    if (name == NULL) {
        return 0;
    }
    if (background != 0) {
        LoadFileBG(name, (u_long128 *)buffer, &size);
    } else {
        LoadFile2(name, buffer, &size, 0);
    }
    if (size > 0) {
        MenuNPCLoadFlag = 1;
    }
    memory->Alloc(blocks_for(size));
    return MenuNPCLoadFlag;
}
int MenuNPCLoadCheck(CActionChara *chara, mgCMemory *memory, int texBlock) {
    if (MenuNPCLoadFlag == 1) {
        if (chara != NULL) {

            u8 *texManager = (u8 *)&mgTexManager;
            memory->stack_used = 0;
            memory->lock = 0;
            DeleteBlock__17mgCTextureManagerFi(texManager, texBlock);
            strcpy((char *)(texManager + 0x1D8), at_4950__2);
            chara->Initialize(NULL);
            chara->LoadPack((u_int*)MenuPartyNPCModelReadBuffer, menu_infocfgname, memory, memory, memory,
                             texBlock, 0);
            texManager[0x1D8] = 0;
            MenuNPCLoadFlag = 0;
            return 1;
        }
    }
    return 0;
}
void CMenuCostumeSel::UpdateCostumeList(int mode, unsigned long charaFlag) {
    WornCostumes worn;
    u8 *chara_data;
    int kind;
    int index;

    chara_data = (u8 *)GetUserDataMan()->GetCharaDataPtr(0);
    if (mode == 0) {
        this->costume_num[0] = GetCostumeList(charaFlag, 6, this->costume_list[1]);
        this->costume_num[1] = GetCostumeList(charaFlag, 5, this->costume_list[0]);
        this->costume_num[2] = GetCostumeList(charaFlag, 7, this->costume_list[2]);
    }
    if (mode == 1) {
        chara_data = (u8 *)GetUserDataMan()->GetCharaDataPtr(1);
        this->costume_num[0] = GetCostumeList(charaFlag, 9, this->costume_list[1]);
        this->costume_num[1] = GetCostumeList(charaFlag, 8, this->costume_list[0]);
        this->costume_num[2] = GetCostumeList(charaFlag, 10, this->costume_list[2]);
    }
    if (chara_data == NULL) {
        return;
    }
    worn = *(WornCostumes *)at_4967__2;
    worn.id[0] = *(short *)((u8*)chara_data + 0x24A);
    worn.id[1] = *(short *)((u8*)chara_data + 0x322);
    worn.id[2] = *(short *)((u8*)chara_data + 0x2B6);
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
void CMenuCostumeSel::LoadMenuData(mgCMemory *stack, int *texBlock) {
    int i;
    mgCTextureManager *texManager;
    u8 *buffer;
    unsigned int size;
    u8 *icons;
    short *systemMes;
    int freeSize;

    ((CBaseMenuClass *)this)->SetTexBlock(texBlock);
    for (i = 0; i < 7; i++) {
        MenuActionChara[i] = NewMenuActionChara(stack);
        MenuActionChara[i]->Initialize(NULL);
    }
    texManager = &mgTexManager;
    buffer = memory_free_top(stack);
    size = LoadFileMenu(at_5051, (u_long128 *)buffer, 1);
    stack->Alloc((int)size / 16 + 0x10);
    stack->Align64();
    mgTexManager.EnterIMGFile(buffer, *texBlock, NULL, NULL);
    this->tile_tex = mgTexManager.GetTexture(at_5052, -1);
    icons = (u8*)GetMenuMainIMGPtr();
    if (icons != NULL) {
        texManager->EnterIMGFile(icons, *texBlock, NULL, NULL);
    }
    this->cursor_tex = texManager->GetTexture(at_5053, -1);
    this->cursor_x = 0;
    this->cursor_y = 0;
    this->cursor_wave = 0;
    this->unk_2BC = 0;
    AttachMessageForm();
    systemMes = GetSystemMesBuffer();
    MenuDCMsg[0]->SetMessData(systemMes, GetMenuMainMessageBuffer());
    MenuDCMsg[0]->MsgPreset(0xA);
    MenuDCMsg[0]->SetAbsPos(8);
    systemMes = GetSystemMesBuffer();
    MenuDCMsg[7]->SetMessData(systemMes, GetMenuMainMessageBuffer());
    MenuDCMsg[7]->MsgPreset(0xB);
    MenuDCMsg[7]->SetAbsPos(8);
    *(int *)&MenuDrawEnv->speed = 0x40000000;
    MenuBGReadInfo2Malloc__FP9mgCMemoryPi(stack, tbl_5016);
    MenuLoadInfo.mode = 3;
    MenuLoadInfo.unk_1 = 1;
    MenuLoadInfo.unk_2 = 1;
    MenuLoadInfo.unk_5 = 0;
    MenuLoadInfo.unk_4 = -1;
    MenuLoadInfo.unk_3 = 0;
    MenuLoadInfo.unk_6[1] = 0;
    MenuLoadInfo.unk_6[0] = 1;
    freeSize = memory_free_size(stack);
    this->stack.stSetBuffer((u_long128 *)memory_free_top(stack), freeSize);
    MenuMemoryAdjust(&this->stack, &MenuCharaLoadStack, MenuActionCharaBuffer, 0);
    SetMenuLoadItemNo(0);
    MenuItemCharaDataLoad(&MenuCharaLoadStack, 0, MenuCharaBuild2, 1);
    do {
    } while (ReadBGSync__Fv() == 0);
    this->load_wait = 0;
    MenuCosutumeLoadPhase = 2;
}
int CMenuCostumeSel::KeyStep() {
    CActionChara *model = MenuActionChara[0];
    CDC2Mes *ask = MenuDCMsg[7];
    sceVu0FVECTOR pos;
    int fadeEnd = FadeCheckMenu();

    switch (mode) {
        case 1:
            if (fadeEnd && load_wait > 15 && MenuCosutumeLoadPhase >= 4) {
                MenuCommonInfo->key_enable = 1;
                mode = 0;
                step = -1;
                loading = 1;
                MenuDCMsg[0]->MakeMsg(0x11F9);
            }
            break;
        case 2:
            if (fadeEnd) {
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
                    int moveY = 0;
                    int moveX = 0;
                    if (keys & 1) {
                        moveY--;
                    }
                    if (keys & 2) {
                        moveY++;
                    }
                    if (keys & 4) {
                        moveX--;
                    }
                    if (keys & 8) {
                        moveX++;
                    }
                    float turn = 0.0f;
                    float zoom = turn;
                    if (MenuCosutumeLoadPhase == 4) {
                        turn = GamePad__2.GetRXf();
                        zoom = -GamePad__2.GetRYf();
                    }
                    if (MenuCosutumeLoadPhase < 3) {
                        moveX = 0;
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
                    if (moveY) {
                        select += moveY;
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
                    if (moveX) {
                        if (select < 3) {
                            costume_select[select] += moveX;
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
                            MenuLoadInfo.unk_5 = phasetbl_5119[select];
                        } else {
                            moveX = 0;
                        }
                    }
                    if (moveY || moveX) {
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
                            GetUserDataMan()->GetCharaDataPtr(1)->unk_2b = 0;
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
                            MenuLoadInfo.unk_3 = 1;
                            chara_data = GetUserDataMan()->GetCharaDataPtr(1);
                            chara_data->unk_2b = 1;
                            UpdateCostumeList(1, CostumeAttr);
                            costume_select[0] = CosutmeSelDefaultSet(0x7F, costume_list[1]);
                            costume_select[1] = CosutmeSelDefaultSet(0x10A, costume_list[0]);
                            costume_select[2] = CosutmeSelDefaultSet(0x85, costume_list[2]);
                            MenuLoadInfo.mode = 0;
                            MenuLoadInfo.unk_2 = 1;
                            MenuLoadInfo.unk_5 = 0;
                            MenuLoadInfo.unk_4 = -1;
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
            model->GetRotation(unk_270);
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
                MenuLoadInfo.unk_2 = 0;
                model->SetPosition(chara_pos);
                model->SetRotation(unk_270);
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
    texManager->ReloadTexture(tile_tex->block, (sceVif1Packet *)NULL);
    mgCDrawPrim *prim = GetMenuPrim();
    DrawMenuTilePattern(prim, tile_tex, tile_scroll, tile_scroll, mgRect<int>(0x100, 0, 0x100, 0x100), 0,
                        tilergba_5203);
    PrimQuad(prim, tile_tex, 24.0f, 24.0f, mgRect<int>(0, 0xEA, 0xC8, 0x16), 0x80, 0x80, 0x80, 0x80);
    if (MenuCosutumeLoadPhase == 4) {
        texManager->ReloadTexture(tex_block[3], (sceVif1Packet *)NULL);
        MenuActionChara[0]->DrawDirect();
    }
    texManager->ReloadTexture(tile_tex->block, (sceVif1Packet *)NULL);
    mgRect<int> lineRect(0, 0, 0xB0, 0x20);
    mgRect<int> labelRect(0, 0xB6, 0x38, 0x1A);
    mgRect<int> charaRect(0, 0xD0, 0x78, 0x1A);
    mgRect<int> leftRect(0, 0x20, 0x10, 0x16);
    mgRect<int> rightRect(0x10, 0x20, 0x10, 0x16);
    int i;
    int cursorY = select * 0x42 + 0x6E;
    int y = 0x50;
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(tile_tex);
    for (i = 0; i < COSTUME_LIST_NUM; i++) {
        int lineY = y + 0x1E;
        prim->Color(0, 0, 0, 0x30);
        PrimQuad(prim, 50.0f, (float)(y + 4), labelRect);
        PrimQuad(prim, 74.0f, (float)(lineY + 4), lineRect);
        float wave = 6.0f * sinf(line_wave[i]);
        if (wave < 0.0f) {
            wave = -wave;
        }
        float leftX;
        float rightX;
        float arrowY;
        leftX = 55.0f - wave;
        arrowY = (float)(lineY + 3);
        rightX = wave + (float)(lineRect.right + 0x49);
        PrimQuad(prim, 4.0f + leftX, 4.0f + arrowY, leftRect);
        PrimQuad(prim, 4.0f + rightX, 4.0f + arrowY, rightRect);
        if (i == select) {
            prim->Color(0xA4, 0xA4, 0xA4, 0x80);
        } else {
            prim->Color(0x80, 0x80, 0x80, 0x80);
        }
        PrimQuad(prim, 46.0f, (float)y, labelRect);
        PrimQuad(prim, 70.0f, (float)lineY, lineRect);
        PrimQuad(prim, leftX, arrowY, leftRect);
        PrimQuad(prim, rightX, arrowY, rightRect);
        labelRect.left += labelRect.right;
        y += 0x42;
    }
    int charaY = y + 0xA;
    int exitY = charaY + 0x28;
    if (mode == 0 && (step == 0 || step == 3)) {
        prim->Color(0, 0, 0, 0x30);
        PrimQuad(prim, 116.0f, (float)(charaY + 4), charaRect);
        if (select == 3) {
            prim->Color(0xA4, 0xA4, 0xA4, 0x80);
        } else {
            prim->Color(0x80, 0x80, 0x80, 0x80);
        }
        PrimQuad(prim, 112.0f, (float)charaY, charaRect);
        if (chara == 1) {
            mgRect<int> exitRect(0, 0x9C, 0xAA, 0x1A);
            prim->Color(0, 0, 0, 0x30);
            PrimQuad(prim, 78.0f, (float)(exitY + 4), exitRect);
            if (select == 4) {
                prim->Color(0xA4, 0xA4, 0xA4, 0x80);
            } else {
                prim->Color(0x80, 0x80, 0x80, 0x80);
            }
            PrimQuad(prim, 74.0f, (float)exitY, exitRect);
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
    CalcMenu1((float)cursorY, &cursor_y, 4.0f, 0.0f, 0);
    if (cursor_tex != NULL && cursor_show) {
        float cursorPos[2];
        cursorPos[0] = cursor_x + 6.0f * cosf(cursor_wave);
        cursorPos[1] = cursor_y + 4.0f * sinf(unk_2BC);
        MenuCursorDraw(cursor_tex, cursorPos, 0.0f, 0, 0x80, 1.0f);
        cursor_wave += 0.05235988f;
        unk_2BC += 0.10471976f;
        if (!(cursor_wave < 3.1415927f)) {
            cursor_wave -= 6.2831855f;
        }
        if (!(unk_2BC < 3.1415927f)) {
            unk_2BC -= 6.2831855f;
        }
    }
    texManager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
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
        DrawMenuFillBox(36.0f, (float)mgScreenHeight - 40.0f - 8.0f, putw_5262[LanguageCode], 32.0f, 0x40, 0, 0,
                        0);
        CMenuFont help;
        help.DrawDirect(infomsg_5256[LanguageCode], 0x28, mgScreenHeight - 0x28);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", Draw__15CMenuCostumeSelFv);
#endif
extern void *__vt__15CMenuCostumeSel[];
extern u_long CostumeOptionEnv;
extern "C" void *__ct__15mgCCameraFollowFffff(void *camera, float distance, float height, float angle,
                                               float speed);
void MenuCostumeInit(mgCMemory *stack, int *tex_block, int mode) {
    int i;
    CMenuCostumeSel *menu;

    int size = memory_free_size(stack);
    MenuChangeMemory.stSetBuffer((u_long128 *)memory_free_top(stack), size);
    if ((menu = (CMenuCostumeSel *)operator new(sizeof(CMenuCostumeSel),
                                                (u_long128 *)MenuChangeMemory.Alloc(0x2F))) != NULL) {
        __ct__14CBaseMenuClassFv(menu);
        float distance = 40.0f, height = 30.0f, angle = 0.0f, width = 8.0f;
        void **vtable = (void **)((u8 *)menu + 0x10C);
        *vtable = __vt__15CMenuCostumeSel;
        __ct__15mgCCameraFollowFffff(&menu->camera, distance, height, angle, width);
        menu->stack.Init();
        menu->select = 0;
        MenuCosutumeLoadPhase = 0;
        menu->tile_scroll = 0.0f;
        menu->chara_data = GetUserDataMan()->GetCharaDataPtr(0);
        menu->costume_select[0] = 0;
        menu->costume_select[1] = 0;
        menu->costume_select[2] = 0;
        menu->line_wave[0] = 0.0f;
        menu->line_wave[1] = 0.0f;
        menu->line_wave[2] = 0.0f;
        menu->load_wait = 0;
        menu->loading = 0;
        menu->wait_load = 0;
        menu->show_help = 0;
        menu->cursor_show = 0;
        menu->chara = 0;
        menu->monica_enabled = 0;
        menu->tile_tex = NULL;
        menu->cursor_tex = NULL;
        menu->chara_pos[0] = 15.0f;
        menu->chara_pos[1] = -14.0f;
        menu->chara_pos[2] = 4.0f;
        menu->chara_pos[3] = 1.0f;
        menu->unk_270[0] = 0.0f;
        menu->unk_270[1] = 0.1f;
        menu->unk_270[2] = 0.0f;
        menu->unk_270[3] = 1.0f;
        for (i = 0; i < COSTUME_LIST_MAX; i++) {
            menu->costume_list[0][i] = 0;
            menu->costume_list[1][i] = 0;
            menu->costume_list[2][i] = 0;
        }
        menu->list[0] = menu->costume_list[1];
        menu->list[1] = menu->costume_list[0];
        menu->list[2] = menu->costume_list[2];
        menu->unk_220 = 0;
        menu->unk_280 = 0;
        menu->change_chara = 0;
        menu->camera.SetDistance(100.0f);
        menu->camera.SetAngle(0.0f);
        menu->camera.SetHeight(3.0f);
        menu->camera.SetSpeed(4.0f, -1.0f);
        menu->camera.SetFollow(0.0f, 0.0f, 0.0f);
        menu->camera.Step(-1);
    }
    MenuCosPtr = menu;
    CostumeAttr = 0x1274521CBUL;
    if (MenuArg.param[0] == 1) {
        menu->monica_enabled = 1;
        CostumeAttr |= CostumeOptionEnv;
    }
    MenuCosPtr->UpdateCostumeList(0, CostumeAttr);
    MenuCosPtr->LoadMenuData(&MenuChangeMemory, tex_block);
    MenuCosPtr->FadeInMenu(40, 0.0f);
    MenuArg.end_code = 0;
    MenuArg.result[0] = 0;
    MenuArg.result[1] = 0;
    MenuArg.result[2] = 0;
    MenuCamInit(1.0f);
}
int MenuCostumeKey() {
    return MenuCosPtr->KeyStep();
}
void MenuCostumeDraw(void) {
    MenuCosPtr->Draw();
}
BASE_MONSTER_TBL *GetMonsterBaseInfoForMonsterMemoIndex(int memoIndex) {
    BASE_MONSTER_TBL *monster;
    int i;

    monster = GetMonsterBaseInfo(0);
    for (i = 0; i < 0x14A; i++) {
        if (monster->unk_b2 == memoIndex) {
            return monster;
        }
        monster++;
    }
    return NULL;
}
void CMosBookMenu::InitMonsterInfo(void) {
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
    char localAreaNames[2][32];
    int weakList[8];
    char *area;
    char **typeNames;
    char *message;
    int i;
    int itemCount;
    int j;
    int k;
    int weakCount;
    int n;

    this->InitMonsterInfo();
    if (monster != NULL) {
        strcpy(this->name, monster->name);
        area = NULL;
        if (0 <= monster->unk_b0) {
            area = GetMapTitle(GetDngMapNo(monster->unk_b0));
        }

        *(MonsterBookBlock64 *)localAreaNames = *(MonsterBookBlock64 *)at_5452;
        if (LanguageCode == 1) {
            if (monster->unk_b0 == 1) {
                area = localAreaNames[0];
            }
        }
        if (LanguageCode == 2 && monster->unk_b0 == 1) {
            area = localAreaNames[1];
        }
        if (area != NULL) {
            strcpy(this->area_name, area);
        }
        typeNames = monster_type_name[LanguageCode];
        if (typeNames[0] != NULL) {
            strcpy(this->type_name, typeNames[monster->user_mons_id]);
        }
        this->hp = monster->unk_56;
        this->abs = monster->unk_58;
        this->kill_num = KillMonsterCount(monster->id, 0);
        itemCount = 0;
        for (i = 0; i < 3; i++) {
            if (0 < monster->drop_items[i]) {
                message = GetItemMessage(monster->drop_items[i]);
                if (message != NULL) {
                    strcpy(this->drop_item[itemCount], message);
                    itemCount++;
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
        weakCount = 0;
        *(MonsterBookBlock32 *)weakList = *(MonsterBookBlock32 *)at_5482;
        for (k = 0; k < 8; k++) {
            if (monster->unk_6c[k] >= 50) {
                weakList[weakCount] = k;
                weakCount++;
            }
        }
        if (weakCount > 0) {
            if (monster_jyakuten[LanguageCode][0] != NULL) {
                strcpy(this->weak_name, monster_jyakuten[LanguageCode][weakList[0]]);
                for (n = 1; n < weakCount; n++) {
                    strcat(this->weak_name, monster_jyakuten[LanguageCode][weakList[n]]);
                }
            }
        }
    }
}
void CMosBookMenu::InitEnd(void) {
    u8 *buffer;
    unsigned int size;
    int freeSize;
    int i;
    BASE_MONSTER_TBL *entry;

    buffer = memory_free_top(&MosBookStack);
    size = LoadFileMenu(at_5558__2, (u_long128 *)buffer, 1);
    MosBookStack.Alloc(blocks_for(size));
    mgTexManager.EnterIMGFile((u8*)GetPackFile((unsigned int *)buffer, at_5559__2, NULL),
                              this->tex_block[0], NULL, NULL);
    Tex_MBase = mgTexManager.GetTexture(at_3271, -1);
    Tex_MBook = mgTexManager.GetTexture(at_5560__2, -1);
    Tex_MBg = mgTexManager.GetTexture(at_5561, -1);
    this->tex_block_no = this->tex_block[4];
    mgCMemory scratch;
    freeSize = memory_free_size(&MosBookStack);
    scratch.stSetBuffer((u_long128 *)memory_free_top(&MosBookStack), freeSize);
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
    ((CBaseMenuClass *)this)->FadeInMenu(0x32, 0.0f);
}
void CMosBookMenu::Draw() {
    sceVu0FMATRIX view;
    sceVu0FVECTOR eye;
    mgRect<int> scissor;
    mgRect<int> numberRect;

    if (Tex_MBg == NULL || Tex_MBook == NULL || Tex_MBase == NULL) {
        return;
    }
    mgCTextureManager *texManager = &mgTexManager;
    texManager->ReloadTexture(Tex_MBase->block, (sceVif1Packet *)NULL);
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    DrawMenuTilePattern(prim, Tex_MBg, bg_scroll, bg_scroll, mgRect<int>(0, 0, 0x100, 0x100), 0, NULL);
    prim->Begin(6);
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
    int boxW = 0xB6;
    if (CheckNowEurope()) {
        boxW = 0xBE;
    }
    float x = 52.0f, y = 101.0f;
    DrawMenuFillBox(x, y, (float)boxW, 220.0f, 0x80, 0xD, 0xD, 0xD);
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(Tex_MBase);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    Menu3DivideTextureDraw(prim,
                           mgRect<int>(put_under_offset_5577[1][0] + 0x16, put_under_offset_5577[1][1] + 0x47, 0x52,
                                       0x20),
                           under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim,
                           mgRect<int>(put_under_offset_5577[1][0] + 0x6E, put_under_offset_5577[1][1] + 0x47, 0x52,
                                       0x20),
                           under_brdtbl_5576, 1);
    int shift = 0;
    int boardW = 0xB0;
    int shortShift = 0;
    int shortW = boardW;
    if (CheckNowEurope()) {
        shift = 2;
        boardW = 0xB6;
        shortShift = 4;
        shortW = 0xBE;
    }
    Menu3DivideTextureDraw(prim,
                           mgRect<int>(put_under_offset_5577[3][0] + 0x16 - shift,
                                       put_under_offset_5577[3][1] + 0x47, boardW, 0x20),
                           under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim,
                           mgRect<int>(put_under_offset_5577[5][0] + 0x16 - shift,
                                       put_under_offset_5577[5][1] + 0x47, boardW, 0x20),
                           under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim,
                           mgRect<int>(put_under_offset_5577[7][0] + 0x16 - shift,
                                       put_under_offset_5577[7][1] + 0x47, boardW, 0x20),
                           under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim,
                           mgRect<int>(put_under_offset_5577[9][0] + 0x16 - shift,
                                       put_under_offset_5577[9][1] + 0x47, boardW, 0x20),
                           under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim,
                           mgRect<int>(put_under_offset_5577[9][0] + 0x16 - shift,
                                       put_under_offset_5577[9][1] + 0x69, boardW, 0x20),
                           under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim,
                           mgRect<int>(put_under_offset_5577[9][0] + 0x16 - shift,
                                       put_under_offset_5577[9][1] + 0x8B, boardW, 0x20),
                           under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim,
                           mgRect<int>(put_under_offset_5577[11][0] + 0x16 - shortShift,
                                       put_under_offset_5577[11][1] + 0x47, shortW, 0x20),
                           under_brdtbl_5576, 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x140, 0x27, 0x9C, 0x20), under_brdtbl_5576, 1);
    prim->End();
    prim->Begin(6);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    prim->Texture(Tex_MBook);
    PrimQuad(prim, 18.0f, 16.0f, mgRect<int>(0, 0, 0xA8, 0x16));
    int titleX = put_under_offset_5577[0][0] + 0x16;
    int titleY = put_under_offset_5577[0][1] + 0x47;
    PrimQuad(prim, (float)titleX, (float)(put_under_offset_5577[0][1] + 0x47), mgRect<int>(0, 0x82, 0xB0, 0x12));
    PrimQuad(prim, (float)(titleX + 0xB), (float)(titleY + 0x19), mgRect<int>(0xC, 0x2C, 0xC, 0x10));
    PrimQuad(prim, (float)(titleX + 0x5E), (float)(titleY + 0x15), mgRect<int>(0xC, 0x16, 0x14, 0x16));
    PrimQuad(prim, (float)(put_under_offset_5577[2][0] + 0x16), (float)(put_under_offset_5577[2][1] + 0x47),
             mgRect<int>(0, 0x94, 0xB0, 0x12));
    PrimQuad(prim, (float)(put_under_offset_5577[4][0] + 0x16), (float)(put_under_offset_5577[4][1] + 0x47),
             mgRect<int>(0, 0xA6, 0xB0, 0x12));
    PrimQuad(prim, (float)(put_under_offset_5577[6][0] + 0x16), (float)(put_under_offset_5577[6][1] + 0x47),
             mgRect<int>(0, 0xB8, 0xB0, 0x12));
    PrimQuad(prim, (float)(put_under_offset_5577[8][0] + 0x16), (float)(put_under_offset_5577[8][1] + 0x47),
             mgRect<int>(0, 0xCA, 0xB0, 0x12));
    PrimQuad(prim, (float)(put_under_offset_5577[10][0] + 0x16), (float)(put_under_offset_5577[10][1] + 0x47),
             mgRect<int>(0, 0xDC, 0xB0, 0x12));
    PrimQuad(prim, (float)(put_under_offset_5577[12][0] + 0x16), (float)(put_under_offset_5577[12][1] + 0x47),
             mgRect<int>(0, 0xEE, 0xB0, 0x12));
    int iconX = put_under_offset_5577[4][0] + 0x1D;
    int iconY = put_under_offset_5577[4][1] + 0x5C;
    for (int bit = 0; bit < 8; bit++) {
        if (strong_bit & (1 << bit)) {
            PrimQuad(prim, (float)iconX, (float)iconY, mgRect<int>(ic_5580[bit][0], ic_5580[bit][1], 0x16, 0x16));
            iconX += 0x16;
        }
    }
    iconX = put_under_offset_5577[4][0] + 0x1D;
    iconY = put_under_offset_5577[4][1] + 0x8E;
    for (int bit = 0; bit < 8; bit++) {
        if (weak_bit & (1 << bit)) {
            PrimQuad(prim, (float)iconX, (float)iconY, mgRect<int>(ic_5580[bit][0], ic_5580[bit][1], 0x16, 0x16));
            iconX += 0x16;
        }
    }
    Menu3DivideTextureDraw(prim, mgRect<int>(0xFB, 0x55, 0xC, 0x13C), line_5595, 0);
    prim->End();
    camera.GetCameraMatrix(view);
    camera.GetPos(eye);
    mgSetViewMatrix(view, eye);
    if (monster != NULL && load_phase == 4 && show_wait > 16) {
        scissor.Set(0x20, 0x69, 0xE8, 0x135);
        SetMenuScissor(scissor);
        texManager->ReloadTexture(tex_block_no, (sceVif1Packet *)NULL);
        monster->DrawDirect();
        ResetMenuScissor();
    }
    texManager->ReloadTexture(Tex_MBase->block, (sceVif1Packet *)NULL);
    int frameW = 0xD6;
    if (CheckNowEurope()) {
        frameW = 0xDA;
    }
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(Tex_MBase);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x20, 0x55, frameW, 0x36), wakutbl_5600[0], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x20, 0x8B, frameW, 0x92), wakutbl_5600[1], 1);
    Menu3DivideTextureDraw(prim, mgRect<int>(0x20, 0x11D, frameW, 0x32), wakutbl_5600[2], 1);
    prim->End();
    numberRect.Set(0, 0x14A, 0xC, 0xD);
    prim->Begin(6);
    prim->Texture(Tex_MBase);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    PrimDrawNumber(prim, hp, 0, 0x156, 0x6D, numberRect, -1, 0);
    PrimDrawNumber(prim, abs, 0, 0x1AE, 0x6D, numberRect, -1, 0);
    PrimDrawNumber(prim, kill_num, 0, 0xEC, 0x185, numberRect, -2, 0);
    prim->End();
    texManager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
    CMenuFont font;
    char text[0x80];
    int nameH;
    int nameW;
    font.SetStr(name);
    font.CalcDrawWH(font.str, &nameW, &nameH);
    int nameX = 0x92 - nameW / 2;
    font.SetStr(name);
    font.SetPos(nameX, 0x6D);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
    font.SetStr(type_name);
    font.SetStr(type_name);
    font.SetPos(0x4E, 0x123);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
    int areaH;
    int areaW;
    font.SetStr(area_name);
    font.CalcDrawWH(font.str, &areaW, &areaH);
    int areaX = 0x92 - areaW / 2;
    font.SetStr(area_name);
    font.SetPos(areaX, 0x163);
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
    int page = select + 1;
    if (list_num <= 0) {
        page = 0;
    }
    sprintf(text, monstere_file_template[LanguageCode], page, list_num);
    font.SetStr(text);
    font.SetPos(0x14C, 0x2D);
    font.DrawDirect(font.str, font.pos_x, font.pos_y);
}
int CMosBookMenu::KeyStep(void) {
    int select;
    int lr;
    int push;
    int fade;
    int cmd;
    int i;
    float scroll;
    float half;

    select = MenuCommonInfo->CheckSelectKey();
    lr = MenuCommonInfo->CheckLRKey();
    push = MenuCommonInfo->CheckPushButton();
    fade = ((CBaseMenuClass *)this)->FadeCheckMenu();
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
                ((CBaseMenuClass *)this)->DeleteTexBlock();
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
                ((CBaseMenuClass *)this)->FadeOutMenu(0x3C, 0.0f);
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
            if (ReadBGSync__Fv() == 0) {
                this->load_phase += 1;
                this->show_wait = 0;
                this->monster = NewMenuActionChara(&this->stack);
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
                MonsterScaleCheck((CCharacter2 *)this->monster);
            }
            break;
        case 4:
            this->skip_draw ^= 1;
            if ((s8)this->skip_draw != 0) {
                this->monster->Step();
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
void MonsterBookInit(mgCMemory *memory, int *texBlock, int bootMode) {
    CMosBookMenu *book;
    int i;
    int size;

    size = memory_free_size(memory);
    MosBookStack.stSetBuffer((u_long128 *)memory_free_top(memory), size);
    if ((book = (CMosBookMenu *)operator new(sizeof(CMosBookMenu),
                                             (u_long128 *)MosBookStack.Alloc(0x9A))) != NULL) {
        __ct__14CBaseMenuClassFv(book);
        *(void**)((u8*)book + 0x10C) = __vt__12CMosBookMenu;
        __ct__9mgCCameraFf(&book->camera, 8.0f);
        book->stack.Init();

        *(int *)&book->bg_scroll = 0;
        book->monster = NULL;
        ((int*)&book->unk_1BC)[0] = 0;
        ((int*)&book->unk_1BC)[1] = 0;
        ((int*)&book->unk_1BC)[2] = 0;
        ((int*)&book->unk_1BC)[3] = 0;
        ((int*)&book->unk_1BC)[4] = 0;
        book->load_phase = 0;
        book->show_wait = 0;
        book->load_wait = 0;
        book->monster_info = NULL;
        book->select = 0;
        book->skip_draw = 0;
        book->list_num = 0;
        for (i = 0; i < 0x180; i++) {
            book->list[i] = -1;
        }
        book->InitMonsterInfo();
        book->camera.SetPos(0.0f, 0.0f, 100.0f);
        book->camera.SetRef(0.0f, 0.0f, 0.0f);
    }
    MenuMosBookPtr = book;
    ((CBaseMenuClass *)book)->SetTexBlock(texBlock);
    MonsterBookPtr = (u8*)&GetSaveData()->monster_book;
    MonsterBookBootMode = bootMode;
    MenuBGReadInfo2Malloc__FP9mgCMemoryPi(&MosBookStack, tbl_5848);
    MenuLoadInfo.mode = 4;
    MenuLoadInfo.unk_2 = 1;
    MenuLoadInfo.unk_6[1] = 0;
    MenuLoadInfo.unk_1 = 0;
    MenuLoadInfo.unk_4 = -1;
    MenuLoadInfo.unk_5 = 0;
    MosBookStack.Align64();
    ((CMosBookMenu *)MenuMosBookPtr)->InitEnd();
}
int MonsterBookKey() {
    return MenuMosBookPtr->KeyStep();
}
#ifdef NONMATCHING
void MonsterBookDraw() {
    MenuMosBookPtr->Draw();
    if (menu_debug_flag) {
        DrawMenuFillBox(20.0f, 40.0f, 200.0f, 24.0f, 0x40, 0, 0, 0);
        CMenuFont font;
        font.SetStr(at_5893);
        font.SetPos(20, 40);
        font.DrawDirect(font.str, font.pos_x, font.pos_y);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MonsterBookDraw__Fv);
#endif
extern "C" void Set__9mgRect_s_Fssss(mgRect<short> *rect, short x, short y, short w, short h) {
    rect->left = x;
    rect->top = y;
    rect->right = w;
    rect->bottom = h;
}

// Static initialiser (.init)
extern mgCMemory MenuMosBuildStack;
extern "C" void *__construct_array(void *array, void *(*constructor)(void *),
                                    void *destructor, unsigned int size, unsigned int count);
extern "C" void *__ct__9mgCMemoryFv(void *memory);
extern "C" void __sinit_menuchr_cpp() {
    __construct_array(MenuActionCharaBuffer, __ct__9mgCMemoryFv, NULL,
                      sizeof(mgCMemory), MENU_CHARA_LOAD_MAX);
    MenuChangeMemory.Init();
    MenuChangeNpcMemory.Init();
    ChrChangeInitTextureStack.Init();
    MenuMonChangeLoadStack.Init();
    MenuMosBuildStack.Init();
    MenuMosLoadStack.Init();
    SwordEffectStack.Init();
    MosBookStack.Init();
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", monster_progress_tbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", tbl_992__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", menu_robo_memorytbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", menu_chr_memorytbl__DATA);
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
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", tiletbl_5573__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", under_brdtbl_5576__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", put_under_offset_5577__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", ic_5580__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", line_5595__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", wakutbl_5600__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", tbl_5848__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_1078__2__DATA);
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
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", at_3762__DATA);
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

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuchr", D_0037B05C__DATA);

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
INCLUDE_BSS(MenuActionCharaBuffer, 0x150);
INCLUDE_BSS(MenuLoadItemNo, 0x20);
INCLUDE_BSS(at_1083__2, 0x20);
INCLUDE_BSS(MenuChangeMemory, 0x30);
INCLUDE_BSS(MenuChangeNpcMemory, 0x30);
INCLUDE_BSS(ChrChangeInitTextureStack, 0x30);
INCLUDE_BSS(at_1806__2, 0x20);
INCLUDE_BSS(at_2372__4, 0x20);
INCLUDE_BSS(at_2674, 0x80);
INCLUDE_BSS(at_2675, 0x80);
INCLUDE_BSS(at_2676, 0x80);
INCLUDE_BSS(MenuMonChangeLoadStack, 0x30);
INCLUDE_BSS(MenuMosBuildStack, 0x30);
INCLUDE_BSS(MenuMosLoadStack, 0x30);
INCLUDE_BSS(MenuMonsterBGInfo, 0x20);
INCLUDE_BSS(mos_effect_readbuff1, 0x10);
INCLUDE_BSS(mos_effect_readbuff2, 0x10);
INCLUDE_BSS(mos_effect_readbuff1_size, 0x10);
INCLUDE_BSS(mos_effect_readbuff2_size, 0x10);
INCLUDE_BSS(at_3054__2, 0x20);
INCLUDE_BSS(at_3511, 0x20);
INCLUDE_BSS(at_3529, 0x20);
INCLUDE_BSS(at_3554, 0x20);
INCLUDE_BSS(SwordEffectStack, 0x30);
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
INCLUDE_BSS(MosBookStack, 0x30);
INCLUDE_BSS(at_5482, 0x20);
