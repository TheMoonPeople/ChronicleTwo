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
        chara->shadow_link_num = 0;
        chara->shadow_link_shadow = 0;
        chara->shadow_link_model = 0;
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
extern "C" void KeyStep__14CMenuMosSelectFv(void *);
extern "C" void GetCharacterSnd__FP16CUserDataManageriPc(CUserDataManager *, int, char *);
extern "C" int GetMonsterModelFile__FiiPc(int, int, char *);
extern "C" void sndInitPort__Fi(int);
extern "C" int sndLoadSound__FiPUiP9mgCMemory(int, u32 *, mgCMemory *);
extern "C" void *GetGameDataPt__Fv(void);
void SetupUnitMan(CScene *scene, CUserDataManager *userData, int unit, ROBO_INFO_DATA *robo);
void GetBajjiPosition(CMenuPosDataForm *form, int slot, int unused, int *pos);

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
extern "C" void *MenuMosSelectPtr;
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
extern int Tex_MBase;
extern int Tex_MBook;
extern int Tex_MBg;
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
int MenuMemoryDivide(mgCMemory *memory, mgCMemory **list, int chara);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuMemoryDivide__FP9mgCMemoryPP9mgCMemoryi);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", EnterDataMenu__15CMenuChrCngMenuFPUc);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", LoadBGNPCModel__15CMenuChrCngMenuFi);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", KeyChangeMain__15CMenuChrCngMenuFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", CalcTex__15CMenuChrCngMenuFv);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuCharaChangeStarDraw__Fv);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuCharaChangeDraw__Fv);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MonsterScaleCheck__FP11CCharacter2);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", CheckLoadBGMonster__14CMenuMosSelectFv);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", CalcTex__14CMenuMosSelectFv);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuMonsterBoxInit__FP9mgCMemoryPii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", KeyStep__14CMenuMosSelectFv);
extern "C" void MenuMonsterBoxKey__Fv(void) {
    KeyStep__14CMenuMosSelectFv(MenuMosSelectPtr);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuMonsterBoxDraw__Fv);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuItemCharaDataLoad__FP9mgCMemoryiPP17MENU_BGREAD_INFO2i);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuItemCharaDataLoadPack__FiP12CActionCharaP12CActionCharaiPUiP9mgCMemoryii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuItemCharaDataLoadEndCheck__FPP17MENU_BGREAD_INFO2P9mgCMemoryPP12CActionCharaiii);
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
        chara->foot_se_bank = scene->se_base_id;
        chara->foot_sound_id = -1;
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
            chara->se_bank =
                sndLoadSound__FiPUiP9mgCMemory(7, buffer, MorattaStack + charaIds[index]);
        }
        chara->se_bank_2 = scene->se_battle_id;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuItemRoboDataLoad__FP9mgCMemoryPP17MENU_BGREAD_INFO2i);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuItemRoboDataLoadEndCheck__FPP17MENU_BGREAD_INFO2P9mgCMemoryPP12CActionCharaii);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuMonsterLoadBG__FP9mgCMemoryPP17MENU_BGREAD_INFO2ii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuMonsterLoadBGCheck__FPP17MENU_BGREAD_INFO2PP12CActionCharaii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuItemCharaDataLoadEndCheckAfter__FPP17MENU_BGREAD_INFO2i);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", InitMainCharaBG__FiP9mgCMemoryi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", ReadMainCharaBG__Fv);
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
            chara->Initialize(0);
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
        MenuActionChara[i]->Initialize(0);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", KeyStep__15CMenuCostumeSelFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", Draw__15CMenuCostumeSelFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MenuCostumeInit__FP9mgCMemoryPii);
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
    Tex_MBase = (int)mgTexManager.GetTexture(at_3271, -1);
    Tex_MBook = (int)mgTexManager.GetTexture(at_5560__2, -1);
    Tex_MBg = (int)mgTexManager.GetTexture(at_5561, -1);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", Draw__12CMosBookMenuFv);
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
                this->monster->Initialize(0);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", MonsterBookDraw__Fv);
extern "C" void Set__9mgRect_s_Fssss(mgRect<short> *rect, short x, short y, short w, short h) {
    rect->left = x;
    rect->top = y;
    rect->right = w;
    rect->bottom = h;
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuchr", __sinit_menuchr_cpp);

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
