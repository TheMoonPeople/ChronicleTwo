#define MenuEffect MenuEffectUnbounded
const int kMenuAskParamOffset = 0x58;
const int kBaseMenuWord0xF8Offset = 0xF8;
const int kBagSlotCount = 0x96;
#include "dng_main.hpp"
#include "charasetup.hpp"
#include "dynamicanime.hpp"
#include "sound.hpp"
#include "dataread.hpp"
#include "prespr.hpp"
#include "mg_drawprim.hpp"
#include <cstdio>
#include "map.hpp"
#include "inventmn.hpp"
#include "menuchr.hpp"
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
#include "menumain.hpp"
#include "common.h"
#include "menusys.hpp"
#include "menudraw.hpp"
#include <cstring>
#undef MenuEffect

inline unsigned int QuadwordsFor(int bytes) {
    return ((unsigned int)bytes & 0xF) ? ((unsigned int)bytes >> 4) + 1 : ((unsigned int)bytes >> 4);
}

enum { kPadUp = 1, kPadDown = 2, kPadLeft = 4, kPadRight = 8 };

enum ItemArea {
    kAreaHand = 0,
    kAreaEquip = 1,
    kAreaRobo = 2,
    kAreaBag = 3,
    kAreaSelected = 7,
    kAreaBait = 0xA
};

enum ItemMenuState {
    kStateBrowse = 0,
    kStateClosing = 2,
    kStateSpectolBreak = 7,
    kStateSpectolFusion = 8,
    kStateExtended9 = 9,
    kStateOverLimit = 0xD,
    kStateTuneBuildUp = 0xF
};

enum TuneBuildUpStep { kTuneAdjust = 0, kTuneConfirmSave = 1, kTuneConfirmDiscard = 2 };

enum BuildUpTuning {
    kStatWord = 11,
    kSpareWord = 22,
    kPointsPerStep = 100,
    kStatMax = 100
};

enum { kBlinkPeriod = 0x3C, kBlinkLastOn = 0x19 };

enum FusionColors {
    kColorNormal = 0x80,
    kColorRaisedR = 0x54,
    kColorRaisedG = 0x54,
    kColorRaisedB = 0xA4
};

enum ItemMenuCommand {
    kCmdNone = 0,
    kCmdDenied = 5,
    kCmdOpenCommandMenu = 10,
    kCmdPlaceItem = 0x14,
    kCmdTakeAll = 0x1E,
    kCmdSortBag = 0x28,
    kCmdCancel = 0x32,
    kCmdUseOnChara = 0x3C,
    kCmdFuseSelected = 0x46,
    kCmdUseOnRobo = 0x50,
    kCmdUseOnMonster = 0x5A,
    kCmdCancelNoLoad = 100,
    kCmdUnused = 0x6E,
    kCmdBuildUpInfo = 0x78
};

extern "C" void Func_MenuItemIconSetEffectOne__FP18MENUFORMPARTS_TYPE(MENUFORMPARTS_TYPE *);
extern "C" void GetWorldPosition__8mgCFrameFPfPf(mgCFrame *frame, float *position, float *offset);
extern "C" void sceVu0AddVector(float *result, float *a, float *b);
extern "C" void __ct__13CGameDataUsedFv(void *);
extern "C" void ToSpectolTrans__13CGameDataUsedFP13CGameDataUsedi(CGameDataUsed *item,
                                                                  CGameDataUsed *out, int count);
extern "C" MENU_ASKMODE_PARA *__ct__17MENU_ASKMODE_PARAFv(MENU_ASKMODE_PARA *param);
extern "C" int GetItemDataType__Fi(int itemNo);
void MenuAquaInit(mgCMemory *memory, int *data, int arg);
void NameRegistInit(mgCMemory *memory, int *data, int arg);
void MenuNPCQuestViewInit(mgCMemory *memory, int *data, int arg);
int GetItemCommandMsg(CGameDataUsed *item, MENU_ASKMODE_PARA *param, int slot, int arg);
int GetItemCommandMsg(CGameDataUsed *item, int *slots, u32 *flags, short *values, short *extra,
                      int slot, int arg);
void MenuFormUpdataAttachInfo(CMenuPosDataForm *form, CGameDataUsed *item, int itemNo, int a,
                              short *b);
void SetSwordBlurEffect(CCharacter2 *chara, mgCMemory *stack, int charaNo);
void SetupUnitMan(CScene *scene, CUserDataManager *userData, int unit, ROBO_INFO_DATA *robo);
extern "C" void MenuBGReadInfo2Malloc__FP9mgCMemoryPi(mgCMemory *, int *);
void InitSpectol(void);
void MenuItemDebugKey();

struct NameList {
    char *name;
};
struct NamePair {
    char *a;
    char *b;
};
struct KeyPairTable {
    int v[2][2];
};
struct SpectolBreakTable {
    int v[4];
};

struct MenuCharaReadBuffers { u_int *model; u_int *skin; u_int *outline; };
extern MenuCharaReadBuffers MainCharaReadBuffer;
extern CGameDataUsed *NewViewWep;
extern CGameDataUsed *OldViewWep;
extern u8 view_weapon_flag;
extern CDC2Mes *MenuDCMsg[9];
extern CGameDataUsed SpectolTransBefore;
extern CMenuEffect *MenuEffect[2];
extern CGameDataUsed SpectolInfoStay;
extern NamePair at_1685;
extern KeyPairTable at_2328;
extern KeyPairTable at_2333__3;
extern SpectolBreakTable at_1557;
extern char at_1493__2[];
extern int MenuHowHaveMuchNum;
extern short MenuTrushNum;
extern short SpectolBreakNum;
extern short SpectolBreakNum_Limit;
extern short SpectolBreakSpPoint;
extern short MenuItemCommand_RoboPackBreakFlag;
extern short save_spectol_fusion_param[10];
extern int save_spectol_fusion_spstatus;
extern signed char sndflag_1665;
extern signed char init_1666;
extern ITEMCMD_RET_PARA MenuItemCmdRet[];
extern CDC2Mes *TrushMesCls[4];
extern CMenuPosDataForm *MenuSpectolSatusCheckForm;
extern CMenuPosDataForm *MenuSpectolSatusCheckBGFadeForm;
extern CItemSelect *ItemSelectPtr;
extern "C" int GetSpectolNo__13CGameDataUsedFv(CGameDataUsed *self);
extern "C" u8 __vt__14CBaseMenuClass[];
extern "C" float sinf(float);
extern float MenuWeaponBasePos[3];
extern float SpectolFramePosValue;
extern float SpectolFrameFadeAlpha;
extern float SpectolFrameScaleAngle;
extern CActionChara *SpectolFrame;
extern NameList at_1545;
extern signed char MenuRoboEquipTable[8];
extern char at_5757[];
extern char at_7342[];
extern char at_7343[];
extern char at_7344[];
extern char at_7345[];
extern char at_7346[];
extern char at_7347[];
extern float at_7021;
extern MENU_INPUTKEY_ARG item_menu_argtbl[];
extern float ActiveMenuWeaponCharaRange;
extern mgCMemory MainCharaReadStack;
extern u8 *MainCharaReadStackReadAdr;
extern CMenuItemInfo *CMenuItemInfoPt;
extern short MenuItem_ItemBoardTopLine;
extern short MenuItem_ItemBoardTopSelect;
extern u32 *MenuItemSpectolTransSoundBuffer;
extern void *Save_AskParamInfo_7099;
extern short SpectolFusion_LeftOrRight;
extern signed char diffent_weapon_dispflag_7125;
extern signed char fusion_blinkcnt_7120;
extern signed char init_7121;
extern signed char init_7126;
extern MENUFORMPARTS_TYPE *BuildUpFormInfoIndex[10];
extern MENUFORMPARTS_TYPE *BuildUpFormInfoStatusVol[10];
extern "C" float at_3407[4];
extern "C" u8 padtbl_3359[16];
extern "C" char at_2545__2[];
extern "C" char at_2546__2[];
extern "C" char at_2651[];
extern "C" char at_2547[];
extern "C" char at_2548[];
extern "C" char at_2549[];
extern "C" char at_2550[];
extern "C" char *n_2667[4];
extern "C" int CheckBuildUp__FP13CGameDataUsedPiPiPi(CGameDataUsed *, int *, int *, int *);
extern "C" int MenuCheckKey[4];
extern "C" char *focusnametbl[21];
extern "C" float at_3771[4];
extern "C" float at_3772[4];
extern "C" char at_3774__2[];
extern "C" char at_3775__2[];
extern "C" mgCFrame *SearchObject__12CActionCharaFPc(CActionChara *chara, char *name);
extern "C" char at_3924[];
extern "C" char at_3829[];
extern CGamePad GamePad__2;
extern "C" char at_5022[];
extern "C" char at_4985[];
extern char *tbl_4981[3];
extern char *plist_4982[3];
extern char *local_over_flow_baseposname[3];
extern char *OverFlowFormName;
extern "C" char at_5130[];
extern "C" char at_5131[];
extern "C" char at_5132[];
extern "C" char at_5133[];
extern "C" char at_5134[];
extern CLevelUpEffectManager MenuLevelUpMan;
extern "C" char at_4954[];
extern "C" char at_3751[];
extern "C" char at_5210[];
extern "C" char at_5211[];
extern int Robo_Sound_ID_Save;
extern "C" char at_4672[];
extern int tbl_5293[];
extern mgCMemory MenuItemMemory;
extern mgCMemory MenuItemMemory2;
extern mgCMemory MenuItemMainMemory;
extern mgCMemory MenuItemBGDataMemory;
extern int old_viewmode_8715;
extern signed char init_8716;
extern int old_chrid_8718;
extern signed char init_8719;
extern char at_8819[];
extern char at_8820[];
extern char at_8821[];
extern char at_8822[];
extern char at_8823[];
extern char at_5281[];
int ReadBGSync(void);

int AfterSpectolFusion(CGameDataUsed *item, CGameDataUsed *part);
void local_item_infoview_set(MENUFORMPARTS_TYPE *part, CGameDataUsed *item);
int MenuAquaKey(void);
int NameRegistKey(void);
int MenuNPCQuestViewKey(void);

// Code (.text)
void DrawTrushMenuMessage() {
    int i;
    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)0);
    for (i = 0; i < 4; i++) {
        if (TrushMesCls[i]) {
            TrushMesCls[i]->StepMsg();
            TrushMesCls[i]->DrawMsg();
        }
    }
}
extern "C" CBaseMenuClass *__ct__14CBaseMenuClassFv(CBaseMenuClass *self) {
    u8 *raw = (u8 *)self;
    int i;
    *(u8 **)(raw + 0x10C) = __vt__14CBaseMenuClass;
    __ct__17MENU_ASKMODE_PARAFv((MENU_ASKMODE_PARA *)(raw + kMenuAskParamOffset));
    (&self->swap_info)->Set(-1, 0, -1, 0);
    memset(self, 0, 0x110);
    *(signed char *)(raw + 4) = 0;
    self->mode = 1;
    self->step = 0;
    *(short *)(raw + 6) = 0;
    self->script = NULL;
    self->script_size = 0;
    self->unk_10 = 0x80;
    self->key_arg_no = 0;
    for (i = 0; i < 16; i++) {
        *(int *)(raw + 0x18 + i * 4) = -1;
    }
    self->cmd_arg_pos = -1;
    *(int *)(raw + 0xF8) = 0;
    self->step = 0;
    self->SetAskParam(NULL);
    memset(raw + 0xFC, 0, 0x10);
    return self;
}
void CBaseMenuClass::SetTexBlock(int *block) {

    int *dst = (int *)this;
    int i;
    for (i = 0; i < 16; i++) {
        dst[6 + i] = block[i];
        if (dst[6 + i] <= 0) {
            dst[6 + i] = -1;
            break;
        }
    }
    DeleteTexBlock();
}
void CBaseMenuClass::DeleteTexBlock() {
    MenuDeleteTextureBlock((int *)((u8 *)this + 0x18));
}
int CBaseMenuClass::MenuItemCommnadSelectPrepare(CGameDataUsed *item, int slot, int arg) {

    u8 param[sizeof(MENU_ASKMODE_PARA)];
    if (item == NULL) {
        return 0;
    }
    if (item->used_type > 0) {
        cmd_arg_pos = slot;
        __ct__17MENU_ASKMODE_PARAFv((MENU_ASKMODE_PARA *)param);
        return (GetItemCommandMsg(item, (MENU_ASKMODE_PARA *)param, cmd_arg_pos, arg) <= 0) ^ 1;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemMoveItemCommand__14CBaseMenuClassFP13CGameDataUsediiP16CMenuPosDataFormi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemCommandSelect__14CBaseMenuClassFii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", SetItemCmdMsgPos__14CBaseMenuClassFPi);
int MenuHowMuchNumSelect(int key, CGameDataUsed *item, int limit) {
    short step = 0;
    int max_num;
    int before;
    int changed;
    if (key & 1) {
        step += 1;
    } else if (key & 2) {
        step -= 1;
    }
    if ((key & 0x10) || (key & 0x40)) {
        step -= 5;
    } else if ((key & 0x20) || (key & 0x80)) {
        step += 5;
    }
    max_num = 1;
    if (item != NULL) {
        max_num = item->GetNum();
    }
    if (limit > 0) {
        max_num = limit;
    }
    before = MenuHowHaveMuchNum;
    MenuHowHaveMuchNum += step;
    if (MenuHowHaveMuchNum <= 0) {
        MenuHowHaveMuchNum = 1;
    }
    if (max_num < MenuHowHaveMuchNum) {
        MenuHowHaveMuchNum = max_num;
    }
    changed = 0;
    if (before != MenuHowHaveMuchNum) {
        MenuSePlay(0x1D);
        MenuCommonInfo->down_arrow_cnt = 0;
        MenuCommonInfo->up_arrow_cnt = 0;
        if (0 < step) {
            MenuCommonInfo->up_arrow_cnt = 8;
        } else {
            MenuCommonInfo->down_arrow_cnt = 8;
        }
        changed = 1;
    }
    MenuCommonInfo->how_much_form->SetNumber(at_1493__2, MenuHowHaveMuchNum);
    return changed;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemAskMode_HowMuch__14CBaseMenuClassFii);
CGameDataUsed *CheckTrushWeapon(CGameDataUsed *item) {
    CGameDataUsed *slot = GetUserDataMan()->GetUsedDataPtr(0);
    int bag_max = GetNowBagMax(1);
    int i;
    for (i = 0; i < bag_max; i++, slot++) {
        if (slot != item && slot->item_type == 1 && !slot->IsFishingRod()) {
            return slot;
        }
    }
    return NULL;
}
int CBaseMenuClass::CheckSpectolFusion(CGameDataUsed *item, int panel, CMenuPosDataForm *form) {
    CDC2Mes *message;
    int held_type;
    CGameDataUsed *held = (CGameDataUsed *)(&MenuCommonInfo->have_item);
    held_type = GetItemDataType__Fi(MenuCommonInfo->have_item.item_no);
    GetItemDataType__Fi(item->item_no);
    int kind = item->used_type;
    if (kind == 0) {
        return 0;
    }
    if (held_type == 0x11) {
        mode = 8;
        form->draw_flag = 1;
        message = MenuDCMsg[panel];
        MENU_ASKMODE_PARA param;
        param.mes_no = panel;
        int abs_pos = 5;
        param.form = form;
        if (kind == 3 && !item->IsFishingRod()) {
            if (item->RemainFusion() >= held->data.attach.spectol_value) {
                SetSpectolInfo(item, held);
                param.item = held;
                param.item2 = item;
                union { CGameDataUsed before; };
                union { CGameDataUsed after; };
                __ct__13CGameDataUsedFv(&before);
                __ct__13CGameDataUsedFv(&after);
                before.CopyGameData(item);
                after.CopyGameData(held);
                SepectolFusionBeforeAfterCheck.Init();
                SepectolFusionBeforeAfterCheck.CopyGameData(item);
                int raised = AfterSpectolFusion(&SepectolFusionBeforeAfterCheck, held);
                message->MsgPreset(0xB);
                if (0 < raised) {
                    message->MakeMsg(0xAC);
                } else if (save_spectol_fusion_spstatus == 0) {
                    message->MakeMsg(0xC0);
                } else {
                    message->MakeMsg(0xCE);
                }
                abs_pos = 0x12;
                message->SetMsgCursor(1);
                MenuFormUpdataAttachInfo(MenuSpectolSatusCheckForm, &SepectolFusionBeforeAfterCheck,
                                         0, 1, save_spectol_fusion_param);
            } else {
                message->MsgPreset(0xA);
                message->MakeMsg(0xBA);
                step = 3;
            }
        } else {
            message->MsgPreset(0xA);
            message->MakeMsg(0xBB);
            step = 3;
        }
        NameList names = at_1545;
        names.name = item->GetName(1);
        message->SetMsgItemNo(&names.name, 1);
        SetAskParam(&param);
        message->SetAbsPos(abs_pos);
        return 1;
    }
    return 0;
}
void UpdataInfoSpectolBreakItem(CDC2Mes *mes, CGameDataUsed *item, int count) {
    SpectolBreakTable volume = at_1557;
    volume.v[0] = count;
    volume.v[1] = SpectolBreakSpPoint * count;
    mes->SetMsgVolumeNo(volume.v, 2);
    mes->fade_speed = 1.0f;
    union { CGameDataUsed result; };
    __ct__13CGameDataUsedFv(&result);
    ToSpectolTrans__13CGameDataUsedFP13CGameDataUsedi(item, &result, count);
    MenuFormUpdataAttachInfo(MenuSpectolSatusCheckForm, &result, item->item_no, 1, 0);
    if (MenuSpectolSatusCheckBGFadeForm) {
        MenuSpectolSatusCheckBGFadeForm->draw_flag = 1;
    }
}
int CheckEquipFishRod(CGameDataUsed *item) {
    int result = 0;
    if (CheckFishingWeapon(item) == 1) {
        CGameDataUsed *weapon = CheckTrushWeapon(item);
        if (weapon) {
            SetFishingGamePreEquip(weapon);
            result = 2;
        } else {
            MenuSePlay(5);
            result = 1;
        }
    }
    return result;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", IsSpectolTrans__14CBaseMenuClassFii);
int CBaseMenuClass::IsSpectolFusion(int key, int command) {
    CDC2Mes *message;
    CMenuPosDataForm *form;
    if (!init_1666) {
        sndflag_1665 = 0;
        init_1666 = 1;
    }
    message = MenuDCMsg[ask_para.mes_no];
    form = MenuMesForm[ask_para.mes_no];
    switch (step) {
        case 0:
            int choice = message->YesNoCursor();
            switch (command) {
                case 1:
                case 4:
                case 8:
                    if (choice == 0) {
                        step = 1;
                        form->draw_flag = 0;
                        MenuSePlay(1);
                        if (MenuCommonInfo->cursor_form != NULL) {
                            MenuCommonInfo->cursor_form->draw_flag = 0;
                        }
                        SpectolInfoStay.CopyGameData(SpectolInfo[1]);
                        MenuCommonInfo->InitHaveData();
                        InitSpectol();
                        sndflag_1665 = 0;
                        return 2;
                    }
                case 2:
                    form->draw_flag = 0;
                    if (MenuCommonInfo->cursor_form != NULL) {
                        MenuCommonInfo->cursor_form->draw_flag = 1;
                    }
                    mode = 0;
                    step = 0;
                    itemmenu_chr_rotflag = 1;
                    MenuSePlay(5);
                    return 1;
            }
            break;
        case 1: {
            if (!sndflag_1665 && ReadBGSync() == 0) {
                sndflag_1665 = 1;
                void *file = GetReadBGFile(0);
                if (file != NULL) {
                    MenuSePlay(0, *(unsigned int **)((u8 *)file + 0x110), &MenuSoundBuffer);
                }
            }
            if (*(u8 *)&MenuEffect[0]->run == 0) {
                MenuEffect[0]->run = 0;
                MenuEffect[1]->run = 0;
                int raised = AfterSpectolFusion(SpectolInfo[0], &SpectolInfoStay);
                message->MsgPreset(10);
                message->SetAbsPos(0x12);
                NamePair names = at_1685;
                names.a = SpectolInfo[0]->GetName(1);
                message->SetMsgItemNo(&names.a, 1);
                if (0 < raised) {
                    message->MakeMsg(0xAD);
                } else {
                    message->MakeMsg(0xCA);
                    if (save_spectol_fusion_spstatus == 1) {
                        message->MakeMsg(0xCB);
                    }
                }
                form->draw_flag = 1;
                step += 1;
                itemmenu_chr_rotflag = 1;
                trans_spectol_pos = -1;
                MenuCommonInfo->FadeInMenuBGMVol(9);
                return 3;
            }
            break;
        }
        case 2:
        case 3:
            if (command != 0) {
                IsAskEnd(1, form);
                itemmenu_chr_rotflag = 1;
                return 1;
            }
            break;
        case 4:
            break;
    }
    return 0;
}
int IsDispTrushCommand(CGameDataUsed *item) {
    int show = 1;
    if (item->item_type == 1) {
        CUserDataManager *user_data = GetUserDataMan();
        CGameDataUsed *slot = user_data->GetUsedDataPtr(0);
        int weapon_count = 0;
        int bag_max = GetNowBagMax(1);
        int i;
        for (i = 0; i < bag_max; i++, slot++) {
            if (slot->item_type == 1 && !slot->IsFishingRod()) {
                weapon_count++;
            }
        }
        if (weapon_count < 2 && user_data->chara_data[0].equip[0].IsFishingRod()) {
            show = 0;
        }
    }
    return show;
}
int CBaseMenuClass::IsTrush(int key, int command) {
    CMenuPosDataForm *form = MenuMesForm[ask_para.mes_no];
    CDC2Mes *message = MenuDCMsg[ask_para.mes_no];
    if (step == 0) {
        message->YesNoCursor();
        switch (command) {
            case 1:
                if (message->GetMsgCursor() == 0) {
                    if (CheckEquipFishRod(ask_para.item) == 1) {
                        MenuSePlay(5);
                        break;
                    }
                    form->draw_flag = 0;
                    if (MenuCommonInfo->cursor_form != NULL) {
                        MenuCommonInfo->cursor_form->draw_flag = 1;
                    }
                    MenuCommonInfo->InitHaveData();
                    ask_para.item->DeleteNum(MenuTrushNum);
                    MenuSePlay(7);
                    CheckEnableHaveItemNum();
                    step += 1;
                    return 2;
                }
            case 2:
                IsAskEnd(5, form);
                return 0;
        }
    } else if (step == 1) {
        IsAskEnd(-1, form);
        return 0;
    } else if (step == 3) {
        MenuHowMuchNumSelect(key, ask_para.item, -1);
        switch (command) {
            case 1:
                MenuTrushNum = MenuHowHaveMuchNum;
                step = 0;
                MenuCommonInfo->how_much_form->draw_flag = 0;
                form->draw_flag = 1;
                message->MakeMsg(0xB0);
                message->values[0] = MenuHowHaveMuchNum;
                message->value_width[0] = 0;
                message->SetMsgCursor(1);
                MenuSePlay(1);
                break;
            case 2:
                MenuCommonInfo->how_much_form->draw_flag = 0;
                IsAskEnd(5, form);
                return 0;
        }
    }
    return 0;
}
int CBaseMenuClass::IsItemUseNum(int panel, int key, int command, CGameDataUsed *item,
                                 CItemUseTarget *target) {
    if (step == 0) {
        MenuItemUse.UseItem(item, target);
        if (item->GetNum() <= 0) {
            MenuCommonInfo->SetHaveItemInfo(0, 1);
        } else {
            MenuCommonInfo->SetHaveItemInfo(1, 1);
        }
        step += 1;
        step = 0;
        mode = 0;
    } else {
        step = 0;
        mode = 0;
    }
    return 0;
}
int CBaseMenuClass::SelectInGiftBox(int key, int command) {
    int before;
    CGameDataUsed *gift_box;
    int item_no;
    CGameDataUsed *slot;
    before = NowGiftBoxSelect;
    if (key & 8) {
        NowGiftBoxSelect += 1;
    }
    if (key & 4) {
        NowGiftBoxSelect -= 1;
    }
    if (NowGiftBoxSelect < 0) {
        NowGiftBoxSelect = 0;
    }
    if (NowGiftBoxSelect >= 3) {
        NowGiftBoxSelect = 2;
    }
    if (before != NowGiftBoxSelect) {
        MenuSePlay(0);
    }
    gift_box = ask_para.item;
    switch (command) {
        case 4:
        case 8:
        case 1:
            item_no = gift_box->GetGiftBoxItemNo(NowGiftBoxSelect);
            if (0 < item_no) {
                slot = MenuUserDataManPtr->SearchSpaceUsedDataPtr(item_no);
                if (slot != NULL) {
                    MenuUserDataManPtr->CopyGameData(slot, item_no);
                    gift_box->SetGiftBoxItem(0, NowGiftBoxSelect);
                    MenuSePlay(1);
                } else {
                    slot = MenuUserDataManPtr->SearchSpaceUsedDataPtr();
                    if (slot != NULL) {
                        MenuUserDataManPtr->CopyGameData(slot, item_no);
                        gift_box->SetGiftBoxItem(0, NowGiftBoxSelect);
                        MenuSePlay(1);
                    } else {
                        MenuSePlay(5);
                    }
                }
            } else {
                MenuSePlay(5);
            }
            break;
        case 2:
            NowGiftBoxSelect = 1;
            SetAskParam(NULL);
            mode = 0;
            GiftBoxViewFlag = 0;
            MenuSePlay(5);
            break;
    }
    return 0;
}
void SetConditionHowMuchBoard() {
    CMenuPosDataForm *board = MenuCommonInfo->how_much_form;
    int cursor_pos[2];
    if (board) {
        board->draw_flag = 1;
        MenuCommonInfo->down_arrow_cnt = 0;
        MenuCommonInfo->up_arrow_cnt = 0;
        MenuCommonInfo->GetCursorPos(cursor_pos);
        board->parts[0].y = -8.0f;
        board->parts[1].y = 2.0f;
        board->parts[2].y = 32.0f;
        board->parts[3].y = 10.0f;
        if (cursor_pos[1] > 0x140) {
            board->parts[0].y = -98.0f;
            board->parts[1].y = -88.0f;
            board->parts[2].y = -58.0f;
            board->parts[3].y = -80.0f;
        }
    }
}
void CBaseMenuClass::SetAskHowMuchItemNum(MENU_SWAPITEM_INFO *info, CGameDataUsed *item) {
    mode = 3;
    SetConditionHowMuchBoard();
    if (item != NULL) {
        if (info != NULL) {
            MenuHowHaveMuchNum = item->GetNum();
        }
    }
    MENU_ASKMODE_PARA param;
    param.item = item;
    SetAskParam(&param);
    MenuCommonInfo->MenuPosStop();
    if (info != NULL) {
        swap_info.flag = info->flag;
        swap_info.type = info->type;
        swap_info.no = info->no;
        swap_info.chara = info->chara;
    }
}
void CBaseMenuClass::SetAskParam(MENU_ASKMODE_PARA *param) {
    if (param == NULL) {
        ((MENU_ASKMODE_PARA *)((u8 *)this + kMenuAskParamOffset))->Initialize();
        return;
    }
    u8 *dst = (u8 *)this;
    u8 *src = (u8 *)param;
    int i;
    *(short *)(dst + 0x58) = *(short *)(src + 0x0);
    *(short *)(dst + 0x5A) = *(short *)(src + 0x2);
    *(short *)(dst + 0x5C) = *(short *)(src + 0x4);
    for (i = 0; i < 16; i++) {
        *(int *)(dst + 0x60 + i * 4) = *(int *)(src + 0x8 + i * 4);
        *(int *)(dst + 0x80 + i * 4) = *(int *)(src + 0x28 + i * 4);
        *(short *)(dst + 0xA0 + i * 2) = *(short *)(src + 0x48 + i * 2);
    }
    *(int *)(dst + 0xCC) = *(int *)(src + 0x74);
    *(int *)(dst + 0xD0) = *(int *)(src + 0x78);
    *(short *)(dst + 0xC8) = *(short *)(src + 0x70);
    *(short *)(dst + 0xC0) = *(short *)(src + 0x68);
    *(int *)(dst + 0xD4) = *(int *)(src + 0x7C);
    *(short *)(dst + 0xC2) = *(short *)(src + 0x6A);
    *(int *)(dst + 0xD8) = *(int *)(src + 0x80);
    *(short *)(dst + 0xC4) = *(short *)(src + 0x6C);
    *(int *)(dst + 0xDC) = *(int *)(src + 0x84);
    *(short *)(dst + 0xC6) = *(short *)(src + 0x6E);
    *(int *)(dst + 0xE0) = *(int *)(src + 0x88);
}
void CBaseMenuClass::ExeScript(char *script) {
    MenuCommandAnalyze((char *)this->script, script_size, script);
}
int CBaseMenuClass::ExtendCommand(int key, int command) {
    int result = 0;
    CBaseMenuClass *menu = this;
    short ask_mode = mode;
    MENU_ASKMODE_PARA *param = (MENU_ASKMODE_PARA *)((u8 *)menu + kMenuAskParamOffset);
    if (ask_mode == 4) {
        result = MenuItemCommandSelect(key, command);
        menu->ItemCmdAfter(result, MenuItemCmdRet);
    } else if (ask_mode == 7) {
        result = IsSpectolTrans(key, command);
    } else if (ask_mode == 3) {
        MenuItemAskMode_HowMuch(key, command);
    } else if (ask_mode == 8) {
        result = IsSpectolFusion(key, command);
    } else if (ask_mode == 9) {
        result = IsTrush(key, command);
    } else if (ask_mode == 10) {
        result = IsItemUseNum(param->mes_no, key, command, (CGameDataUsed *)(&MenuCommonInfo->have_item),
                              &MenuItemUseTarget);
    } else if (ask_mode == 11) {
        result = SelectInGiftBox(key, command);
    } else if (ask_mode == 5) {
        result = menu->IsCreateObject(key, command);
    } else if (ask_mode == 6) {
        result = menu->IsMakeObject(key, command);
    } else if (ask_mode == 12) {
        result = menu->IsAskExtend(key, command);
    }
    return result;
}
int CBaseMenuClass::SelectMakeObject(int keys) {
    int old_column = make_cursor;
    int direction;
    if (keys & 2) {
        make_cursor = 1;
    }
    if (keys & 1) {
        make_cursor = 0;
    }
    if (old_column != make_cursor) {
        MenuSePlay(0);
    }
    direction = 0;
    if (make_cursor == 0) {
        int old_row = make_num;
        int mode = 0;
        if (keys & 8) {
            mode += 1;
        }
        if (keys & 4) {
            mode -= 1;
        }
        if (keys & 0x20) {
            mode += 5;
        }
        if (keys & 0x10) {
            mode -= 5;
        }
        if (mode < 0) {
            direction = -1;
        }
        if (0 < mode) {
            direction = 1;
        }
        make_num += mode;
        if (make_num <= 0) {
            make_num = 1;
        }
        if (make_num_max <= make_num) {
            make_num = make_num_max;
        }
        if (old_row != make_num) {
            MenuSePlay(29);
        }
    }
    return direction;
}
void CBaseMenuClass::IsAskEnd(int se, CMenuPosDataForm *form) {
    if (form) {
        form->draw_flag = 0;
    }
    MenuCommonInfo->key_enable = 1;
    if (MenuCommonInfo->cursor_form) {
        MenuCommonInfo->cursor_form->draw_flag = 1;
    }
    mode = 0;
    step = 0;
    MenuSePlay(se);
}
void CBaseMenuClass::FadeInMenu(int frames, float rate) {
    (&MenuMainScene->fade)->FadeIn(frames);
    (&MenuMainScene->fade)->FadeStep();
}
void CBaseMenuClass::FadeOutMenu(int frames, float rate) {
    (&MenuMainScene->fade)->FadeOut(frames, 0.0f, 0.0f, 0.0f);
    (&MenuMainScene->fade)->FadeStep();
}
int CBaseMenuClass::FadeCheckMenu() {
    return (&MenuMainScene->fade)->FadeCheck();
}
void SetPreCmdTrush(CBaseMenuClass *menu, int panel, CGameDataUsed *item, CMenuPosDataForm *form) {
    menu->mode = 9;
    MENU_ASKMODE_PARA param;
    param.mes_no = panel;
    param.form = form;
    param.item = item;
    menu->SetAskParam(&param);
    CDC2Mes *message = MenuDCMsg[panel];
    menu->step = 3;
    message->MsgPreset(0xB);
    message->SetAbsPos(5);
    char *name = item->GetName(1);
    if (name != NULL) {
        strcpy(message->name[0], name);
    }
    MenuTrushNum = item->GetNum();
    if (MenuTrushNum == 1) {
        menu->step = 0;
        message->MakeMsg(0xB6);
        message->values[0] = 1;
        message->value_width[0] = 0;
        message->SetMsgCursor(1);
        form->draw_flag = 1;
        if (MenuCommonInfo->cursor_form != NULL) {
            MenuCommonInfo->cursor_form->draw_flag = 0;
        }
    } else {
        MenuHowHaveMuchNum = MenuTrushNum;
        SetConditionHowMuchBoard();
    }
}
void SetPreCmdSpectolBreak(CBaseMenuClass *menu, int panel, CMenuPosDataForm *form,
                           CGameDataUsed *item, CGameDataUsed *target) {
    menu->mode = 7;
    menu->step = 0;
    MENU_ASKMODE_PARA param;
    param.mes_no = panel;
    param.form = form;
    param.arg0 = GetSameAdrressUserData(item, 0);
    param.item2 = target;
    param.item = item;
    param.arg1 = GetSameAdrressUserData(target, 0);
    menu->SetAskParam(&param);
    SpectolBreakNum = 1;
    SpectolBreakNum_Limit = item->GetNum();
    if (SpectolBreakNum_Limit > 100) {
        SpectolBreakNum_Limit = 100;
    }
    if (item->item_type == 0x13) {
        SpectolBreakNum_Limit = 1;
    }
}
void SetPreCmdGiftBoxSelect(CBaseMenuClass *menu, CGameDataUsed *item) {
    menu->mode = 11;
    menu->step = 0;
    GiftBoxViewFlag = 1;
    MENU_ASKMODE_PARA param;
    param.item = item;
    menu->SetAskParam(&param);
}
int CheckFishCondition(void) {
    CScene *scene;
    DNG_BATTLE_AREA *battle_scene;
    int map_no;
    int enabled;
    int result;

    scene = GetMainScene();
    battle_scene = (DNG_BATTLE_AREA*)menu_GetBattleAreaScene();
    map_no = scene->now_map_no;
    enabled = 1;
    if (map_no == 0x7D) {
        enabled = 0;
    }
    if ((map_no == 0x63) || (map_no == 0x5F)) {
        enabled = 0;
    }
    result = enabled;
    if (GetMenuLoopType() == 1) {
        if (battle_scene->unk_5c == 0) {
            enabled = 0;
        }
        result = enabled;
    }
    return result;
}
void CMENU_USERPARAM::Initialize(void) {
    chara[1] = NULL;
    chara[0] = NULL;
    robo = NULL;
    monster = NULL;
    used_data = NULL;
    monster1 = NULL;
}
void CMENU_USERPARAM::AttachInfo(void) {
    Initialize();
    chara[0] = MenuUserDataManPtr->GetCharaDataPtr(0);
    chara[1] = MenuUserDataManPtr->GetCharaDataPtr(1);
    robo = &MenuUserDataManPtr->robo_data;
    used_data = MenuUserDataManPtr->GetUsedDataPtr(0);
    monster1 = MenuUserDataManPtr->GetMonsterBajjiDataPtr(1);
    monster = MenuUserDataManPtr->GetMonsterBajjiDataPtrMosId(MenuUserDataManPtr->monster_id);
}
void MENU_ASKMODE_PARA::Initialize() {
    memset(this, 0, 0x94);
}
MENU_ASKMODE_PARA::MENU_ASKMODE_PARA() {
    unk_8C = -1;
    Initialize();
}
void MENU_SWAPITEM_INFO::Set(int type, int no, int chara, int flag) {
    this->type = type;
    this->no = no;
    this->chara = chara;
    this->flag = flag;
}
int IsEnableChangeRoboParts(CGameDataUsed *part) {
    int enabled = 0;
    if (part->used_type == 5) {
        int capacity = 0;
        int used;
        int slot;
        int type;
        int offset;
        short *cost;
        used = CheckNowRoboUseCapacity(MenuUserParam.robo, &capacity);
        type = part->item_type;
        cost = (short *)GameItemDataManage.GetRoboData(part->item_no);
        slot = 0;
        offset = 0;
        for (; slot < 4; slot++, offset += sizeof(CGameDataUsed)) {

            u8 *equipped = (u8 *)MenuUserParam.robo + offset;
            if (type == *(signed char *)(equipped + 0x34)) {
                short *equipped_cost =
                    (short *)GameItemDataManage.GetRoboData(*(short *)(equipped + 0x32));
                if (equipped_cost != NULL) {
                    used -= *equipped_cost;
                }
            }
        }
        MenuItemCommand_RoboPackBreakFlag = 1;
        if (capacity - used >= *cost) {
            enabled = 1;
            MenuItemCommand_RoboPackBreakFlag = 0;
        }
        if (part->item_type == 0xF) {
            if (part->IsBroken() != 0) {
                enabled = 0;
                MenuItemCommand_RoboPackBreakFlag = 2;
            }
        }
    }
    return enabled;
}
void SetSpectolInfo(CGameDataUsed *item, CGameDataUsed *part) {
    SpectolInfo[0] = item;
    SpectolInfo[1] = part;
}
void InitSpectol(void) {
    if (SpectolInfo[1] != NULL) {
        SpectolInfo[1]->Init();
    }
}
int AfterSpectolFusion(CGameDataUsed *item, CGameDataUsed *part) {
    WEAPON_USED *target;
    ATTACH_USED *spectol;
    int first;
    int lowest;
    unsigned int attribute;
    int raised;
    int i;
    if (item == NULL) {
        return 0;
    }

    target = &item->data.weapon;
    spectol = &part->data.attach;
    item->GetStatusParam(save_spectol_fusion_param);
    if (*(s8 *)&spectol->spectol_type == 1) {
        lowest = target->status[0];
        first = lowest;
        if (lowest < spectol->status[0]) {
            first = spectol->status[0];
        } else {
            lowest = spectol->status[0];
        }
        target->status[0] = first + lowest / 4;
    } else {
        target->status[0] = target->status[0] + spectol->status[0];
    }
    target->status[1] += spectol->status[1];
    target->attribute[0] += spectol->attribute[0];
    target->attribute[1] += spectol->attribute[1];
    target->attribute[2] += spectol->attribute[2];
    target->attribute[3] += spectol->attribute[3];
    target->attribute[4] += spectol->attribute[4];
    target->attribute[5] += spectol->attribute[5];
    target->attribute[6] += spectol->attribute[6];
    target->attribute[7] += spectol->attribute[7];
    attribute = target->special;
    target->special = CheckWeaponAttribute(target->special, spectol->special);
    save_spectol_fusion_spstatus = 0;
    if (target->special != attribute) {
        save_spectol_fusion_spstatus = 1;
    }
    item->AddFusionPoint(-spectol->spectol_value);
    item->CheckParamLimmit();
    raised = 0;
    save_spectol_fusion_param[0] = target->status[0] - save_spectol_fusion_param[0];
    save_spectol_fusion_param[1] = target->status[1] - save_spectol_fusion_param[1];
    save_spectol_fusion_param[2] = target->attribute[0] - save_spectol_fusion_param[2];
    save_spectol_fusion_param[3] = target->attribute[1] - save_spectol_fusion_param[3];
    save_spectol_fusion_param[4] = target->attribute[2] - save_spectol_fusion_param[4];
    save_spectol_fusion_param[5] = target->attribute[3] - save_spectol_fusion_param[5];
    save_spectol_fusion_param[6] = target->attribute[4] - save_spectol_fusion_param[6];
    save_spectol_fusion_param[7] = target->attribute[5] - save_spectol_fusion_param[7];
    save_spectol_fusion_param[8] = target->attribute[6] - save_spectol_fusion_param[8];
    save_spectol_fusion_param[9] = target->attribute[7] - save_spectol_fusion_param[9];
    for (i = 0; i < 10; i++) {
        if (0 < save_spectol_fusion_param[i]) {
            raised += 1;
        }
    }
    return raised;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", FusionColor__FiiPf);
void SpectolFrameCalc(CActionChara *chara, int active) {
    float scale[4];
    float rot[4];
    float pos[3];
    if (chara != NULL) {
        if (active == 0) {
            chara->SetPosition(MenuWeaponBasePos);
            SpectolFramePosValue = 1.8f;
            SpectolFrameFadeAlpha = 0.8f;
            return;
        }
        chara->GetScale(scale);
        chara->GetRotation(rot);
        float jitter = 0.25f * SpectolFramePosValue;
        pos[0] = MenuWeaponBasePos[0] + jitter * sinf(GetRandF(6.2831855f));
        pos[1] = MenuWeaponBasePos[1] + jitter * sinf(GetRandF(6.2831855f));
        pos[2] = MenuWeaponBasePos[2] + jitter * sinf(GetRandF(6.2831855f));
        chara->SetPosition(pos);
        pos[0] = MenuWeaponBasePos[0] + SpectolFramePosValue * sinf(GetRandF(6.2831855f));
        pos[1] = MenuWeaponBasePos[1] + SpectolFramePosValue * sinf(GetRandF(6.2831855f));
        pos[2] = MenuWeaponBasePos[2] + SpectolFramePosValue * sinf(GetRandF(6.2831855f));
        SpectolFrame->SetPosition(pos);
        SpectolFramePosValue *= 0.98f;
        SpectolFrame->SetScale(scale[0], scale[0], scale[0]);
        SpectolFrame->SetRotation(rot);
        SpectolFrame->SetFadeFlag(1);
        SpectolFrame->fade_alpha = SpectolFrameFadeAlpha;
        SpectolFrameFadeAlpha *= 0.98f;
        SpectolFrameScaleAngle += 0.31415927f;
    }
}
void TransSpectolDataSave(CGameDataUsed *item, int count) {
    memcpy(&SpectolTransBefore, item, sizeof(CGameDataUsed));
    if (SpectolTransBefore.used_type == 1) {
        SpectolTransBefore.data.item.num = count;
    } else if (SpectolTransBefore.used_type == 2) {
        SpectolTransBefore.data.attach.num = count;
    }
    item->DeleteNum(count);
}
int CheckNowRoboUseCapacity(int *capacity) {
    int used;
    short *item_info;

    used = CheckNowRoboUseCapacity(MenuUserParam.robo, capacity);
    if (*capacity == 0) {
        item_info = (short *)GetItemInfoData(MenuCommonInfo->have_item.item_no);
        if (item_info != NULL) {
            *capacity = item_info[5];
        }
    }
    return used;
}
int ExchangeItemInfoMake(MENU_SWAPITEM_INFO *info, int (*row)[4], int mode, int is_equip) {
    int made = 0;
    row[1][0] = 2;
    row[1][3] = 0;
    row[1][2] = 0;
    row[1][1] = 0;
    if (mode == 0) {
        short kind = info->type;
        if (kind == 0 || kind == 1 || kind == 2) {
            if (is_equip != 0) {
                row[0][0] = 0;
                made = 1;
                row[0][1] = info->chara;
                row[0][2] = made;
                if (info->type == 0) {
                    row[0][2] = 0;
                }
                row[0][3] = info->no;
                if (info->type == 2) {
                    row[0][3] = MenuRoboEquipTable[info->no];
                }
                return made;
            }
        }
        if (kind == 3 || kind == 9) {
            made = 1;
            row[0][0] = made;
            row[0][3] = info->no;
        } else if (kind == 10) {
            made = 1;
            row[0][0] = 5;
        }
    } else if (mode == 1) {
        if (info->type == 4) {
            row[0][0] = 1;
            made = 1;
            row[0][3] = info->no;
        }
    }
    return made;
}
void MenuCheckLine(int *top_line, int cursor, int visible_rows) {
    if (top_line) {
        if (cursor - *top_line < 0) {
            *top_line = cursor;
        }
        while (!(cursor < *top_line + visible_rows)) {
            *top_line += 1;
        }
    }
}
int MenuKeySelectCheck(int step, int *cursor, int *scroll, int min, int max, int visible,
                       int mode) {
    int before = *cursor;
    int result = 0;
    *cursor = before + step;
    if (mode == 0) {
        if (*cursor < min) {
            *cursor = min;
        }
        if (max <= *cursor) {
            *cursor = max - 1;
        }
        if (before != *cursor) {
            result = 1;
        }
    } else if (mode == 1) {
        if (*cursor < min) {
            *cursor = max - 1;
        }
        if (max <= *cursor) {
            *cursor = min;
        }
        if (before != *cursor) {
            result = 1;
        }
    } else if (mode == 2) {
        if (before != *cursor) {
            result = 1;
        }
        if (*cursor < min) {
            *cursor = min;
            result = 3;
        }
        if (*cursor >= max) {
            result = 3;
            *cursor = max - 1;
        }
    } else if (mode == 3) {
        if (before != *cursor) {
            result = 1;
        }
        if (*cursor < min) {
            result = 4;
        }
        if (*cursor >= max) {
            result = 4;
        }
        if (result == 4) {
            *cursor -= step;
        }
    }
    if (scroll != NULL) {
        if (*cursor - *scroll < 0) {
            *scroll = *cursor;
        }
        while (*scroll + visible <= *cursor) {
            *scroll += 1;
        }
    }
    return result;
}
int MenuListKeyCheck(int keys, int *cursor, int *top_line, int count, int visible_rows, int key_pair,
                     int wrap_kind) {
    int before = *cursor;
    KeyPairTable key_mask = at_2328;
    int *key_ptr = key_mask.v[key_pair];
    if (keys & key_ptr[0]) {
        *cursor -= 1;
    }
    if (keys & key_ptr[1]) {
        *cursor += 1;
    }
    KeyPairTable wrap = at_2333__3;
    int *wrap_ptr = wrap.v[wrap_kind];
    wrap.v[0][1] = count - 1;
    wrap.v[1][0] = count - 1;
    if (*cursor < 0) {
        *cursor = wrap_ptr[0];
    }
    if (*cursor > count - 1) {
        *cursor = wrap_ptr[1];
    }
    MenuCheckLine(top_line, *cursor, visible_rows);
    int moved = 0;
    if (before != *cursor) {
        moved = 1;
    }
    return moved;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuGlidKeyCheck__FiPiPiPiPiPii);
int MenuListSelectKeyCheck(int keys, int page_size) {
    int step = 0;
    if (keys & 1) {
        step -= 1;
    } else if (keys & 2) {
        step += 1;
    }
    if (keys & 0x10) {
        step -= page_size - 1;
    } else if (keys & 0x20) {
        step += page_size - 1;
    }
    return step;
}
int MenuItemBrdKey(int keys, int *cursor, int *scroll, int board) {
    int before;
    int row;
    int result;
    int dy;
    int bag_max;
    int dx;

    before = *cursor;
    dx = 0;
    if (keys & 1) {
        dx -= 1;
    }
    if (keys & 2) {
        dx += 1;
    }
    bag_max = GetNowBagMax(board);
    if (dx < 0) {
        CalcMenuAdd2(cursor, -6, 0);
    }
    if (dx > 0) {
        CalcMenuAdd2(cursor, 6, bag_max - 1);
    }
    row = *cursor / 6;
    if (row - *scroll < 0) {
        *scroll = row;
    }
    while (!(row < *scroll + 5)) {
        *scroll += 1;
    }
    dy = 0;
    if (keys & 4) {
        dy -= 1;
    }
    result = 0;
    if (keys & 8) {
        dy += 1;
    }
    if (dy < 0) {
        result = CalcMenuAdd2(cursor, dy, row * 6);
    }
    if (dy > 0) {
        CalcMenuAdd2(cursor, dy, (row + 1) * 6 - 1);
    }
    if (before != *cursor) {
        MenuSePlay(0);
    }
    return result;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuDataSwap__FP13CGameDataUsedP13CGameDataUsedi);
void CMenuKeyFunc::Initialize() {
    int i;

    memset(this, 0, sizeof(CMenuKeyFunc));
    key_enable = 1;
    key_input = 0;
    open_type = -1;
    now_mode = -1;
    next_mode = -1;
    pack = 0;
    pack_size = 0;
    waku_type = 0;
    unk_0 = 0;
    ((CGameDataUsed *)(&have_item))->Init();
    cursor_form = NULL;
    waku_form = NULL;
    how_much_form = NULL;
    have_icon = 0;
    have_shadow = 0;
    have_num = 0;
    up_arrow_cnt = 0;
    down_arrow_cnt = 0;
    bgm_vol = 0;
    bgm_step = 0;
    bgm_target = 0;
    bgm_fading = 0;
    for (i = 0; i < 16; i++) {
        tex_block[i] = -1;
    }
}
void CMenuKeyFunc::AttachFuncData() {
    cursor_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_2545__2);
    if (cursor_form != NULL) {
        have_icon = cursor_form->GetPartInfo(at_2546__2);
        have_shadow = cursor_form->GetPartInfo(at_2547);
        have_num = cursor_form->GetPartInfo(at_2548);
        *(int *)((u8 *)have_num + 0x38) = 1;
    }
    waku_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_2549);
    how_much_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_2550);
}
int CMenuKeyFunc::GetActiveCharaNo() {
    return MenuArg.active_chara_no;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuPosStep__12CMenuKeyFuncFPiPi);
void CMenuKeyFunc::MenuSetPos(int x, int y) {
    CMenuPosDataForm *form = cursor_form;
    float fx = (float)x;
    float fy = (float)y;
    form->x = fx;
    form->y = fy;
    form = waku_form;
    form->x = fx;
    form->y = fy;
}
void CMenuKeyFunc::MenuPosStop(void) {
    cursor_form->step_stop = 1;
    waku_form->step_stop = 1;
}
void CMenuKeyFunc::MenuPosPlay(void) {
    cursor_form->step_stop = 0;
    waku_form->step_stop = 0;
}
void CMenuKeyFunc::SetMoveMethod(int method) {
    cursor_form->mtype = method;
    SetWakuMoveMethod(method);
}
void CMenuKeyFunc::SetWakuMoveMethod(int method) {
    waku_form->mtype = method;
}
void CMenuKeyFunc::GetItemPos(int *pos) {
    cursor_form->GetPutPosXY(at_2546__2, pos[0], pos[1]);
}
void CMenuKeyFunc::SetWakuType(int type) {
    char name[0x20];
    int i;
    MENUFORMPARTS_TYPE *part;

    waku_type = type;
    if (waku_form != NULL) {
        i = 0;
        do {
            sprintf(name, at_2651, i);
            part = waku_form->GetPartInfo(name);
            if (part != NULL) {
                part->draw_flag = 0;
                if (i == waku_type) {
                    part->draw_flag = 1;
                }
            }
            i += 1;
        } while (i < 3);
        waku_form->draw_flag = 1;
        if (waku_type < 0) {
            waku_form->draw_flag = 0;
        }
    }
}
void CMenuKeyFunc::SetWakuWH(int part, int width, int height) {
    char name[0x20];
    MENUFORMPARTS_TYPE *info;

    sprintf(name, at_2651, part);
    info = waku_form->GetPartInfo(name);
    if (info != NULL) {
        info->w = (float)width;
        info->h = (float)height;
    }
}
void CMenuKeyFunc::SetVibeCnt(int count, int rate) {
    MENUFORMPARTS_TYPE *part = cursor_form->GetPartInfo(at_2545__2);
    part->vibe_cnt[0] = count;
    part->vibe_cnt[1] = rate;
}
void CMenuKeyFunc::SetVibeR(int strength, int speed) {
    int i;
    MENUFORMPARTS_TYPE *part;

    if (cursor_form != NULL) {
        i = 0;
        do {
            part = cursor_form->GetPartInfo(n_2667[i]);
            if (part == NULL) {
                break;
            }
            i += 1;
            part->viber[0] = strength;
            part->viber[1] = speed;
        } while (i < 4);
    }
}
void CMenuKeyFunc::GetCursorPos(int *pos) {
    cursor_form->GetPutPosXY(at_2545__2, pos[0], pos[1]);
}
void CMenuKeyFunc::CursorFadeIn(float speed, int steps) {
    if (cursor_form != NULL) {
        cursor_form->FormFadeIn((int)speed, steps);
    }
    if (waku_form != NULL) {
        waku_form->FormFadeIn((int)speed, steps);
    }
}
void CMenuKeyFunc::CursorFadeOut(float speed, int steps) {
    if (cursor_form != NULL) {
        cursor_form->FormFadeOut((int)speed, steps);
    }
    if (waku_form != NULL) {
        waku_form->FormFadeOut((int)speed, steps);
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", EnableSwapNowPos__12CMenuKeyFuncFP18MENU_SWAPITEM_INFO);
int CMenuKeyFunc::GetItemAll(CGameDataUsed *item, MENU_SWAPITEM_INFO *info) {
    int slot;
    if (item == NULL || info == NULL) {
        return 0;
    }
    slot = MenuSwapItem(item, info, item->GetNum(), 1);
    MenuSePlay(menu_item_swap_sndtbl[slot]);
    return 1;
}
int GetItemCommandMsg(CGameDataUsed *item, MENU_ASKMODE_PARA *param, int slot, int arg) {
    return GetItemCommandMsg(item, (int *)param + 2, (unsigned int *)param + 10, (short *)param + 0x24,
                             (short *)param + 0x2c, slot, arg);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", GetItemCommandMsg__FP13CGameDataUsedPiPUiPsPsii);
void CMenuKeyFunc::SelDataInit(void) {
    select_key = 0;
    push_button = 0;
    save_cursor = cursor;
    save_top_line = top_line;
    key_input = 0;
}
int CMenuKeyFunc::CheckSelectKey() {
    if (GamePad__2.Down(0x1000) != 0) {
        select_key |= 1;
    } else if (GamePad__2.Down(0x4000) != 0) {
        select_key |= 2;
    }
    if (GamePad__2.Down(0x8000) != 0) {
        select_key |= 4;
    } else if (GamePad__2.Down(0x2000) != 0) {
        select_key |= 8;
    }
    if (key_enable == 0) {
        select_key = 0;
    }
    return select_key;
}
int CMenuKeyFunc::CheckLRKey() {
    if (GamePad__2.Down(4) != 0) {
        select_key = 0x10;
    } else if (GamePad__2.Down(8) != 0) {
        select_key = 0x20;
    } else if (GamePad__2.Down(1) != 0) {
        select_key = 0x40;
    } else if (GamePad__2.Down(2) != 0) {
        select_key = 0x80;
    }
    if (key_enable == 0) {
        select_key = 0;
    }
    return select_key;
}
int MenuCheckPushButton() {
    int pushed;
    int *table;

    pushed = 0;
    table = (int *)padtbl_3359;
    if (LanguageCode > 0) {
        table = (int *)(padtbl_3359 + 8);
    }
    if (GamePad__2.Down(0x20) != 0) {
        pushed = table[0];
    } else if (GamePad__2.Down(0x40) != 0) {
        pushed = table[1];
    } else if (GamePad__2.Down(0x10) != 0) {
        pushed = 4;
    } else if (GamePad__2.Down(0x80) != 0) {
        pushed = 8;
    } else if (GamePad__2.Down(0x100) != 0) {
        pushed = 0x20;
    } else if (GamePad__2.Down(0x800) != 0) {
        pushed = 0x10;
    } else if (GamePad__2.Down(0x200) != 0) {
        pushed = 0x80;
    } else if (GamePad__2.Down(0x400) != 0) {
        pushed = 0x40;
    }
    return pushed;
}
int ConvertCheckPushButton(int buttons) {
    if (LanguageCode != 0 && LanguageCode > 0 && (buttons & 4)) {
        buttons &= ~4;
        buttons |= 2;
    }
    return buttons;
}
int CMenuKeyFunc::CheckPushButton() {
    push_button = MenuCheckPushButton();
    if (key_enable == 0) {
        push_button = 0;
    }
    return push_button;
}
float CMenuKeyFunc::CheckAnalogKey(int stick, float *dir) {
    float input[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    if (stick == 0 || stick == 2) {
        input[0] = GamePad__2.GetRXf();
        input[1] = GamePad__2.GetRYf();
    }
    if (stick == 1 || stick == 2) {
        input[2] = GamePad__2.GetLXf();
        input[3] = GamePad__2.GetLYf();
    }
    if (stick == 2) {
        dir[0] = 0.5f * (input[0] + input[2]);
        dir[1] = 0.5f * (input[1] + input[3]);
    } else {
        dir[0] = input[0] + input[2];
        dir[1] = input[1] + input[3];
    }
    return 1.0f;
}
u8 CMenuKeyFunc::CheckKeyInput(void) {
    if (key_enable == 0) {
        select_key = 0;
        push_button = 0;
    }
    if (select_key != 0) {
        key_input = 1;
    }
    return key_input;
}
int CMenuKeyFunc::GetDebugInputKey(int &held, int &pressed) {
    held = 0;
    pressed = 0;
    if (GamePad__2.On2(0x1000) != 0) {
        held |= 1;
    }
    if (GamePad__2.On2(0x4000) != 0) {
        held |= 2;
    }
    if (GamePad__2.On2(0x8000) != 0) {
        held |= 4;
    }
    if (GamePad__2.On2(0x2000) != 0) {
        held |= 8;
    }
    if (GamePad__2.On2(4) != 0) {
        held |= 0x10;
    } else if (GamePad__2.On2(8) != 0) {
        held |= 0x20;
    } else if (GamePad__2.On2(1) != 0) {
        held |= 0x40;
    } else if (GamePad__2.On2(2) != 0) {
        held |= 0x80;
    }
    if (GamePad__2.Down2(0x20) != 0) {
        pressed = 1;
    } else if (GamePad__2.Down2(0x40) != 0) {
        pressed = 2;
    } else if (GamePad__2.Down2(0x10) != 0) {
        pressed = 4;
    } else if (GamePad__2.Down2(0x80) != 0) {
        pressed = 8;
    } else if (GamePad__2.Down2(0x100) != 0) {
        pressed = 0x20;
    } else if (GamePad__2.Down2(0x800) != 0) {
        pressed = 0x10;
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuSwapItem__12CMenuKeyFuncFP13CGameDataUsedP18MENU_SWAPITEM_INFOib);
CGameDataUsed *GetGameDataUsedForSWAPINFO(MENU_SWAPITEM_INFO *info) {
    CGameDataUsed *item = NULL;
    short owner = info->chara;
    if (0 <= owner) {
        u8 *base = (u8 *)MenuUserParam.chara[owner];
        u8 *robo = (u8 *)MenuUserParam.robo;
        short kind = info->type;
        if (kind == 0) {
            item = (CGameDataUsed *)(base + info->no * 0x6C + 0x2C);
        }
        if (kind == 1) {
            item = (CGameDataUsed *)(base + info->no * 0x6C + 0x170);
        }
        if (kind == 2) {
            item = (CGameDataUsed *)(robo + info->no * 0x6C + 0x30);
        }
        if (kind == 10) {
            return MenuUserDataManPtr->GetActiveEsa();
        }
        return item;
    }
    return (CGameDataUsed *)((u8 *)MenuUserParam.used_data + info->no * 0x6C);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", ReturnItemMenu__12CMenuKeyFuncFi);
void CMenuKeyFunc::InitHaveData() {
    ((CGameDataUsed *)(&have_item))->Init();
    ((MENU_SWAPITEM_INFO *)(&have_swap))->Set(-1, 0, -1, 0);
    SetHaveItemInfo(0, 1);
}
void CMenuKeyFunc::SetHaveItemInfo(int visible, int detail) {
    u8 shown = (visible != 0);
    have_shadow->draw_flag = shown;
    have_icon->draw_flag = shown;
    have_num->draw_flag = shown;
    have_shadow->etc_info[0] = 0;
    have_icon->etc_info[0] = 0;
    int held_item_no = have_item.item_no;
    have_icon->etc_info[1] = held_item_no;
    have_shadow->etc_info[1] = held_item_no;
    have_icon->rgba[0] = 0x80;
    have_icon->rgba[1] = 0x80;
    have_icon->rgba[2] = 0x80;
    if (detail) {
        if (have_shadow->etc_info[1] == 0xB9) {
            *(int *)&have_icon->etc_info[2] = ((CGameDataUsed *)(&have_item))->GetSpectolNo();
            Func_MenuItemIconSetEffectOne__FP18MENUFORMPARTS_TYPE(have_icon);
        } else if (have_shadow->etc_info[1] == 0x1AA) {
            *(int *)&have_icon->etc_info[2] = *(short *)((u8 *)this + 0xD0);
        }
    }
    have_icon->item_flag = 0;
    if (CheckBuildUp__FP13CGameDataUsedPiPiPi((CGameDataUsed *)(&have_item), NULL, NULL, NULL)) {
        have_icon->item_flag |= 2;
    }
    have_num->etc_info[2] = 1;
    if (((CGameDataUsed *)(&have_item))->CheckTypeEnableStack()) {
        have_num->etc_info[1] = ((CGameDataUsed *)(&have_item))->GetNum();
        have_num->rgba[0] = 0x80;
        have_num->rgba[1] = 0x80;
        have_num->rgba[2] = 0x80;
        if (have_icon->etc_info[1] == 0x137) {
            have_num->etc_info[1] = GetUserDataMan()->yarikomi_medal;
            have_num->etc_info[2] = 0;
            have_num->rgba[0] = 0xA4;
            have_num->rgba[1] = 0xA4;
            have_num->rgba[2] = 0x40;
        }
    } else {
        have_num->etc_info[1] = 0;
    }
}
int CMenuKeyFunc::menu_inputkey_limmit_check_line(int keys) {
    int result;
    int *cursor = &this->cursor;
    MENU_INPUTKEY_ARG *limit = *(MENU_INPUTKEY_ARG **)((u8 *)this + 0x134);
    int i;

    result = -1;
    i = 0;
    while (i < 4 && result < 0) {
        if ((keys & MenuCheckKey[i]) &&
            MenuKeySelectCheck(limit->step[i], cursor, cursor + 1, limit->min, limit->max,
                               limit->disp_lines, limit->limit[i]) == 3) {
            result = limit->exit_no[i];
        }
        i += 1;
    }
    return result;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", menu_inputkey_limmit_check_glid__12CMenuKeyFuncFi);
int CMenuKeyFunc::CheckMoveSelect(int arg) {
    int result = -1;
    if (key_enable != 0) {
        switch (*(int *)(*(u8 **)((u8 *)this + 0x134) + 8)) {
            case 0:
                result = menu_inputkey_limmit_check_line(arg);
                break;
            case 1:
                result = menu_inputkey_limmit_check_glid(arg);
                break;
        }
    }
    return result;
}
void CMenuKeyFunc::FadeOutMenuBGMVol(int arg, int value) {
    if (bgm_fading == 0) {
        bgm_vol = MenuMainScene->GetVolBGM();
    }
    bgm_step = arg;
    bgm_target = (short)value;
    if (bgm_target < 0) {
        bgm_target = 0;
    }
    bgm_fading = 1;
}
void CMenuKeyFunc::FadeInMenuBGMVol(int step) {
    bgm_step = step;
    bgm_target = bgm_vol;
    bgm_fading = 1;
}
short CMenuKeyFunc::StepMenuBGM() {
    int volume;

    if (bgm_fading == 1) {
        volume = MenuMainScene->GetVolBGM();
        volume += bgm_step;
        if (volume < bgm_target && bgm_step < 0) {
            volume = bgm_target;
        }
        if (bgm_vol < volume && bgm_step > 0) {
            volume = bgm_vol;
        }
        MenuMainScene->SetVolBGM(volume);
        if (volume == bgm_target) {
            bgm_fading = 0;
        }
    }
    return bgm_fading;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", CheckEnableHaveItemNum__Fv);
void MenuEquipCameraSetEnv(CActionChara *chara, mgCCamera *camera, int type, int index) {
    float position[4];
    float offset[4];
    char name[0x20];
    float table[4];
    mgCFrame *frame;
    char *focus_name;
    bool is_special;

    if (camera == NULL || chara == NULL) {
        return;
    }
    is_special = false;
    if (index == 10) {
        is_special = true;
    }
    if (type < 0 || type >= 3 || index < 0 || index > 3) {
        type = 3;
        index = 0;
    }
    focus_name = focusnametbl[type * 4 + index];
    if (is_special) {
        focus_name = focusnametbl[type * 4 + 3];
    }
    frame = NULL;
    if (*(signed char *)focus_name != 0) {
        frame = SearchObject__12CActionCharaFPc(chara, focus_name);
    }
    if (frame == NULL) {
        MenuCamInit(5.0f);
        return;
    }
    *(u_long128 *)position = *(u_long128 *)at_3771;
    *(u_long128 *)offset = *(u_long128 *)at_3772;
    GetWorldPosition__8mgCFrameFPfPf(frame, position, offset);
    sprintf(name, at_3774__2, type, index);
    MenuPosData->GetEtcTbl2Value(name, table, 3);
    sceVu0AddVector(position, position, table);
    *(u_long128 *)((u8 *)MenuDrawEnv + 0x80) = *(u_long128 *)position;
    sprintf(name, at_3775__2, type, index);
    MenuPosData->GetEtcTbl2Value(name, table, 3);
    sceVu0AddVector(position, position, table);
    *(u_long128 *)((u8 *)MenuDrawEnv + 0x90) = *(u_long128 *)position;
    *(float *)((u8 *)MenuDrawEnv + 0xA0) = 7.0f;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuPosFormValueSetWeapon__FP13CGameDataUsed);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuFormUpdataAttachInfo__FP16CMenuPosDataFormP13CGameDataUsediiPs);
void MenuPosFormValueSetFishingRod(CGameDataUsed *item) {
    int values[8];
    char name[0x20];
    CMenuPosDataForm *form;
    int i;
    u8 *rod;

    if (item != NULL && item->IsFishingRod() != 0) {
        rod = (u8 *)item + 0x10;
        i = 0;
        form = CMenuItemInfoPt->view_form[5];
        values[0] = item->data.weapon.attribute[0];
        values[1] = item->data.weapon.attribute[1];
        values[2] = item->data.weapon.attribute[2];
        values[3] = item->data.weapon.attribute[3];
        values[4] = item->data.weapon.attribute[4];
        do {
            sprintf(name, at_3924, i);
            form->SetNumber(name, values[i]);
            i += 1;
        } while (i < 5);
        form->SetNumber(at_3829, *(short *)(rod + 0x2C));
    }
}
void CMenuItemInfo::Initialize(void) {
    int i;

    view_mode = 0;
    unk_112 = 0;
    sub_view = 0;
    view_chara = 0;
    load_item_no = 0;
    load_item_no = 2;
    mos_id = MenuUserDataManPtr->monster_id;
    view_weapon = NULL;
    *(int *)((u8 *)this + kBaseMenuWord0xF8Offset) = 0;
    SetEquipListNo(4);
    load_weapon_no = 0;
    unk_16C = 0;
    effect_pos = 0;
    unk_176 = -1;
    unk_178 = -1;
    model_tex_block = 0;
    unk_2F8 = 0;
    unk_13A = 0;
    sound_load = 0;
    opened = 0;
    mode = 1;
    step = 0;
    unk_170 = 0;
    unk_172 = -1;
    unk_174 = 0;
    sound_loaded = 0;
    for (i = 0; i < 8; i++) {
        equip_flag[i] = 0;
        equip_list[i] = 0;
    }
    unk_160 = 0;
}
void CMenuItemInfo::SetEquipListNo(int list_no) {
    if (list_no < 2) {
        CHARA_DATA *chara = MenuUserParam.chara[list_no];
        equip_list[0] = chara->equip[0].item_no;
        equip_list[1] = chara->equip[1].item_no;
        equip_list[2] = chara->equip[2].item_no;
        equip_list[3] = chara->equip[3].item_no;
        equip_list[4] = chara->equip[4].item_no;
    } else if (list_no == 2) {
        equip_list[0] = MenuUserParam.robo->parts[0].item_no;
        equip_list[1] = MenuUserParam.robo->parts[1].item_no;
        equip_list[2] = MenuUserParam.robo->parts[2].item_no;
        equip_list[3] = MenuUserParam.robo->parts[3].item_no;
        equip_list[4] = MenuUserParam.chara[0]->equip[4].item_no;
        equip_list[5] = MenuUserParam.chara[0]->equip[2].item_no;
    } else {
        equip_list[0] = equip_list[1] = equip_list[2] = equip_list[3] = 0;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", CheckEquipListNo__13CMenuItemInfoFi);
int CMenuItemInfo::CheckSoundLoad() {
    sound_loaded = 0;
    int chara_no = GetActiveCharaNo();
    if (GetMenuLoopType() == 0) {
        return 0;
    }
    if (sound_load != 0) {
        MenuCharaSoundLoad(&MenuCharaLoadStack, chara_no, 1);
        sound_loaded = 1;
        return 1;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", SearchNowPosItemExist__13CMenuItemInfoFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", IsCancelNoneLoadItem__13CMenuItemInfoFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", IsCancelLoadItem__13CMenuItemInfoFv);
void CMenuItemInfo::SaveViewWeaponStatus(void) {
    int mode_now;
    CGameDataUsed *cursor_item;

    view_weapon_flag = 0;
    mode_now = view_mode;
    if ((mode_now == 2) || (mode_now == 5)) {
        cursor_item = SearchNowPosItemExist();
        if (cursor_item == view_weapon) {
            OldViewWep = cursor_item;
            NewViewWep = (&MenuCommonInfo->have_item);
            if (key_arg_no == 4) {
                NewViewWep = view_weapon;
            }
            view_weapon_flag = 1;
        }
        CGameDataUsed *have_data = (&MenuCommonInfo->have_item);
        if (have_data == view_weapon) {
            OldViewWep = have_data;
            view_weapon_flag = 1;
            NewViewWep = cursor_item;
        }
    }
}
void CMenuItemInfo::CheckViewWeaponStatus(int revert) {
    if (view_weapon_flag != 0) {
        if (revert == 0) {
            view_weapon = NewViewWep;
            return;
        }
        if ((&MenuCommonInfo->have_item) == view_weapon) {
            view_weapon = GetGameDataUsedForSWAPINFO((&MenuCommonInfo->have_swap));
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", ReturnActiveCharaViewMode__13CMenuItemInfoFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", NextModeBuildUpInfo__13CMenuItemInfoFP13CGameDataUsed);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", EquipDirect__13CMenuItemInfoFiP13CGameDataUsedRi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", CheckLoadInfo__13CMenuItemInfoFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", ItemCmdAfter__13CMenuItemInfoFiP16ITEMCMD_RET_PARA);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", IsAskExtend__13CMenuItemInfoFii);
void MenuMoveItemPos(int *item, int *pos, int phase) {
    char part_name[0x20];
    if (phase == 0) {
        int kind = item[0];
        if (kind == 0) {
            if (item[2] == 0 || item[2] == 1 || item[2] == 2) {
                sprintf(part_name, plist_4982[item[2]], item[3]);
            } else {
                strcpy(part_name, at_5022);
            }
            ((CMenuPosDataForm *)MenuPosData->GetFormInfo(tbl_4981[item[1]]))
                ->GetPutPosXY(part_name, pos[0], pos[1]);
        } else if (kind == 1) {
            ((CMenuPosDataManage *)MenuPosData)->GetPosMenuItemOnItemBrd(pos, item[3], 0);
        } else if (kind == 2) {
            MenuCommonInfo->GetItemPos(pos);
        } else if (kind == 4) {
            ((CMenuPosDataForm *)MenuPosData->GetFormInfo(OverFlowFormName))
                ->GetPutPosXY(local_over_flow_baseposname[item[3]], pos[0], pos[1]);
        } else if (kind == 5) {
            ((CMenuPosDataForm *)MenuPosData->GetFormInfo(tbl_4981[0]))
                ->GetPutPosXY(at_4985, pos[0], pos[1]);
        }
    }
    if (phase == 1) {
        int kind = item[0];
        if (kind == 1) {
            ((CMenuPosDataManage *)MenuPosData)->GetPosMenuItemOnItemBrd(pos, item[3], 0);
        } else if (kind == 2) {
            MenuCommonInfo->GetItemPos(pos);
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", CommonSetMoveItemClass__FPA4_i);
void CMenuItemInfo::EnterDataMenu(unsigned int *pack) {
    int sound_size;
    mgCTextureManager *textures;
    u8 *item_image = (u8*)GetPackFile(pack, at_5130, NULL);
    int block = tex_block[0];
    textures = &mgTexManager;
    textures->DeleteBlock(block);
    textures->EnterIMGFile(item_image, block, NULL, NULL);
    MenuPosData->ResetTextureInfoAll();
    money_form->SetNumber(at_1493__2, MenuUserDataManPtr->money);
    Tex_BuildUpBoard = textures->GetTexture(at_2546__2, -1);
    MenuItemSpectolTransSoundBuffer = GetPackFile(pack, at_5131, &sound_size);
    if (MenuDCMsg[3] != NULL) {
        int i = 0;
        do {
            strcpy(MenuDCMsg[3]->name[0], at_5132);
            i += 1;
            MenuDCMsg[3]->item_mes[0] = 1;
        } while (i < 4);
        MenuDCMsg[3]->MakeMsg(-1);
    }
    MenuStatusMode = 0;
    MenuStatusTex = textures->GetTexture(at_5133, -1);
    MenuLevelUpMan.label_tex = textures->GetTexture(at_5134, -1);
}
short CMenuItemInfo::GetActiveCharaIDForItemCmd() {
    short current = view_mode;
    if (current == 0) {
        return 0;
    }
    if (current == 1) {
        return 1;
    }
    if (current == 2 || current == 5) {
        return MenuUserDataManPtr->active_chr_no;
    }
    if (current == 3) {
        return 2;
    }
    if (current == 4) {
        return 3;
    }
    return 0;
}
int CMenuItemInfo::GetActiveCharaNo() {
    int var_v0;

    var_v0 = MenuCommonInfo->GetActiveCharaNo();
    if ((var_v0 == 3) && (sub_view == 1)) {
        sub_view = 0;
        var_v0 = 3;
    }
    return var_v0;
}
void CMenuItemInfo::ExitEnd() {
    CActionChara *field_chara;
    int chara_no;
    CActionChara *chara;
    int equip_list_no;
    mgCMemory *stack;

    field_chara = (CActionChara *)MenuMainScene->GetCharacter(0);
    if (sound_loaded != 0) {
        MenuCharaSoundEnter(MenuMainScene, field_chara, 1);
    }
    if (unk_174 != 0) {
        chara_no = GetActiveCharaNo();
        chara = (CActionChara *)MenuMainScene->GetCharacter(0);
        DeleteOutLineMenu(chara, 0);
        ((CCharacter2 *)chara)->DeleteImage();
        stack = MorattaStack;
        stack->stack_used = 0;
        stack->lock = 0;
        chara->AllDeleteDamage();
        chara->Initialize(MorattaStack);
        AccumulateEffect.frame = 0;
        AccumulateEffect.unk_320 = 0;
        AccumulateEffect.mode = 0;
        chara->accume_effect = &AccumulateEffect;
        chara->LoadPack(MainCharaReadBuffer.model, at_4954, MorattaStack, MorattaStack, MorattaStack,
                         MenuArg.chara_tex_block, 0);
        SwordEffectStack.stack_used = 0;
        SwordEffectStack.lock = 0;
        SetSwordBlurEffect((CCharacter2 *)chara, &SwordEffectStack, chara_no);
        stack = MorattaStack;
        stack[1].stack_used = 0;
        stack[1].lock = 0;
        mgCTextureManager *textures = &mgTexManager;
        textures->DeleteTexAnime(MenuArg.chara_tex_block);
        ((CCharacter2 *)chara)
            ->LoadSkin(MainCharaReadBuffer.skin, at_4954, at_3751, MorattaStack + 1,
                       MenuArg.chara_tex_block);
        stack = MorattaStack;
        stack[5].stack_used = 0;
        stack[5].lock = 0;
        ((CCharacter2 *)chara)
            ->LoadSkin(MainCharaReadBuffer.outline, at_4954, at_5210, MorattaStack + 5,
                       MenuArg.chara_tex_block);
        SetupUnitMan(MenuMainScene, (CUserDataManager *)GetUserDataMan(), chara_no, NULL);
        chara->effect_man = FxScriptMan;
    }
    equip_list_no = CheckEquipListNo(0);
    if ((equip_list_no != 0 || GetActiveCharaNo() == 2) && MenuMainScene != NULL &&
        GetMenuLoopType() == 1) {
        if (field_chara != NULL) {
            if (equip_list_no != 0) {
                field_chara->InitScript();
            }
        }
        if (GetActiveCharaNo() == 2) {
            CharaSndBuffer = NULL;
            MenuCharaSoundEnter(MenuMainScene, field_chara, 0);
            field_chara->se_bank = Robo_Sound_ID_Save;
            field_chara->effect_man = FxScriptMan;
        }
    }
    MenuSystemDataPtr->item_board_select = MenuItem_ItemBoardTopSelect;
    MenuSystemDataPtr->item_board_top = MenuItem_ItemBoardTopLine;
    MenuSystemDataPtr->unk_6 = 0;
    MenuSystemDataPtr->unk_4 = 0;
    MenuSystemDataPtr->item_key_arg_no = key_arg_no;
    MenuSystemDataPtr->item_cursor = (int)*(void **)((u8 *)MenuCommonInfo + 0x70);
    CopyActiveItemAndWeapon(MenuArg.active_chara_no, -1);
    ExeScript(at_5211);
    MenuPosData->TexGetInfoClear(0x5A, 0x100);
    MenuPosData->EtcTblClear(0x1E, 0x60);
    ((CGameDataUsed *)(&MenuCommonInfo->have_item))->Init();
    MenuMainFrameModeSet(0, 0);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", AttachFormInfo__13CMenuItemInfoFv);
extern "C" u8 __vt__9mgCObject[];
extern "C" u8 __vt__7CObject[];
extern "C" u8 __vt__12CObjectFrame[];
extern "C" u8 __vt__11CCharacter2[];
extern "C" u8 __vt__12CActionChara[];
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
void CMenuItemInfo::MenuModeMalloc(mgCMemory *stack) {
    int i;
    CMenuMoveItem *move_item;
    u8 *slot;
    CMenuEffect *effect;
    CRepairManager *repair;
    u8 *buffer;

    int free_blocks = stack->stack_size - stack->stack_used;
    MenuItemMemory2.stSetBuffer((u_long128 *)(stack->stack + stack->stack_used),
                                free_blocks);
    for (i = 0; i < 7; i++) {
        MenuActionChara[i] = NewMenuActionChara(&MenuItemMemory2);
        MenuActionChara[i]->Initialize(NULL);
    }
    MenuBGReadInfo2Malloc__FP9mgCMemoryPi(&MenuItemMemory2, tbl_5293);
    if ((move_item = (CMenuMoveItem *)operator new(0x104, (u_long128*)MenuItemMemory2.Alloc(0x13))) != NULL) {
        slot = (u8 *)move_item + 0xC;
        do {
            __ct__13CGameDataUsedFv(slot + 8);
            slot += 0x7C;
        } while (slot < (u8 *)move_item + 0x104);
        move_item->Initialize();
    }
    MenuMoveItemPtr = move_item;
    MenuMoveItemPtr->AttachForm();
    SpectolFrame = NewMenuActionChara(&MenuItemMemory2);
    if ((effect = (CMenuEffect *)operator new(0x38, (u_long128*)MenuItemMemory2.Alloc(6))) != NULL) {
        effect->Initialize();
    }
    MenuEffect[0] = effect;
    if ((effect = (CMenuEffect *)operator new(0x38, (u_long128*)MenuItemMemory2.Alloc(6))) != NULL) {
        effect->Initialize();
    }
    MenuEffect[1] = effect;
    if ((repair = (CRepairManager *)operator new(0x1EC, (u_long128*)MenuItemMemory2.Alloc(0x21))) != NULL) {
        buffer = (u8*)&repair->effect_stack[0];
        do {
            ((mgCMemory *)buffer)->Init();
            buffer += 0x30;
        } while (buffer < (u8 *)repair + 0x1A4);
        (&repair->model_stack)->Init();
    }
    MenuRepairMan = repair;
    repair->Initialize();
    MenuLevelUpMan.Initialize();
    InitBuildUpInfoEffect(&MenuItemMemory2, (mgCTexture *)mgTexManager.GetTexture(at_4672, -1), 8,
                          20.0f);
    free_blocks = MenuItemMemory2.stack_size - MenuItemMemory2.stack_used;
    MenuItemMemory.stSetBuffer(
        (u_long128 *)(MenuItemMemory2.stack + MenuItemMemory2.stack_used), free_blocks);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", CalcTex__13CMenuItemInfoFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", CalcCursorPosition__13CMenuItemInfoFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", EffectDrawCheck__14CBaseMenuClassFP16CMenuPosDataForm);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemInit__FP9mgCMemoryPii);
extern mgCMemory MenuDebugStack;
extern int MenuDebugSize;
extern mgCCamera *MenuDebugCamera;
extern CActionChara *MenuDebugItemModel;
extern s8 MenuDebugModelDrawFlag;
extern s8 MenuDebugModel_AdjustFlag;
extern CDataCommon *debug_common_data;
extern short MenuItemBoardTotalNum;
extern short MenuItemBoardTotalLine;
extern int cnt_6161;
extern s8 init_6162;
extern int testcnt_6298;
extern s8 init_6299;
extern u32 table_6164[7];
extern char dbox_path_6083[];
extern u64 at_6133;
extern u64 at_6176;
extern u64 at_6220;
extern u64 at_6234;
extern u64 at_6256;
extern u64 at_6265;
#ifdef NONMATCHING
void MenuItemDebugKey(void) {
    float rotation[4];
    float health_input[2];
    float gauge_input[2];
    float weapon_status_input[2];
    float ridepod_status_input[2];
    float ridepod_gauge_input[2];
    float rod_status_input[2];
    s32 file_size;
    s32 buttons;
    CGameDataUsed *item;

    buttons = MenuCommonInfo->CheckPushButton();
    item = CMenuItemInfoPt->view_weapon;

    switch (CMenuItemInfoPt->key_arg_no) {
    case 2:
        if (MenuDebugModelDrawFlag == 0) {
            s32 direction;
            mgCCameraFollow *camera;
            CActionChara *model;
            s32 count_step;
            s32 item_no;
            s32 model_loaded;
            void *buffer;
            s32 stack_used_before_load;
            char *model_path;

            direction = MenuCommonInfo->CheckSelectKey();
            if (direction & 0x20) {
                CMenuItemInfoPt->debug_item_no += 0x40;
            }
            if (direction & 0x10) {
                CMenuItemInfoPt->debug_item_no -= 0x40;
            }
            if (direction & 1) {
                CMenuItemInfoPt->debug_item_no -= 8;
            }
            if (direction & 2) {
                CMenuItemInfoPt->debug_item_no += 8;
            }
            if (direction & 8) {
                CMenuItemInfoPt->debug_item_no += 1;
            }
            if (direction & 4) {
                CMenuItemInfoPt->debug_item_no -= 1;
            }

            count_step = 1;
            if (GamePad__2.On(PAD_CROSS)) {
                count_step = 5;
            }
            if (direction & 0x80) {
                CMenuItemInfoPt->unk_300 += count_step;
            }
            if (direction & 0x40) {
                CMenuItemInfoPt->unk_300 -= count_step;
            }
            if (CMenuItemInfoPt->unk_300 <= 0) {
                CMenuItemInfoPt->unk_300 = 1;
            }
            if (CMenuItemInfoPt->unk_300 > 0x64) {
                CMenuItemInfoPt->unk_300 = 0x64;
            }
            if (CMenuItemInfoPt->debug_item_no <= 0) {
                CMenuItemInfoPt->debug_item_no = 1;
            }
            item_no = CMenuItemInfoPt->debug_item_no;
            if (GetGameDataPt()->max_item_no < item_no) {
                CMenuItemInfoPt->debug_item_no = GetGameDataPt()->max_item_no;
            }
            debug_common_data = GetCommonItemData(CMenuItemInfoPt->debug_item_no);

            if (GamePad__2.Down(PAD_TRIANGLE)) {
                MenuSePlay(1);
                DebugGetItem(NULL, 0);
                CheckEnableHaveItemNum();
            }

            if (buttons & 1) {
                if (debug_common_data != NULL) {
                    MenuUserDataManPtr->GetItemNotOver(
                        CMenuItemInfoPt->debug_item_no,
                        CMenuItemInfoPt->unk_300);
                    if (CheckItemOver() &&
                        (MenuCommonInfo->open_type == 0 ||
                         MenuCommonInfo->open_type == 1)) {
                        MenuCommonInfo->open_type += 0x10;
                        ItemOverFlowCheckFlag = 1;
                    }
                    if (CheckTrushMenu()) {
                        MenuItemBoardTotalNum = GetNowBagMax(1);
                        MenuItem_ItemBoardTopLine = MenuItemBoardTotalNum / 6 - 5;
                        MenuItem_ItemBoardTopSelect = GetNowBagMax(0);
                    }
                    item_menu_argtbl[2].max = MenuItemBoardTotalNum;
                    MenuItemBoardTotalLine = MenuItemBoardTotalNum / 6;
                    item_menu_argtbl[2].rows = MenuItemBoardTotalLine;
                    CheckEnableHaveItemNum();
                }
            } else if (buttons & 0x80) {
                GameItemDataManage.LoadData();
                GameItemDataManage.LoadItemSystemMes(LanguageCode);
            } else if (buttons & 8) {
                MenuDebugStack.stack_used = 0;
                MenuDebugStack.lock = 0;
                MenuDebugCamera = NULL;
                MenuDebugItemModel = NULL;
                MenuDebugModelDrawFlag = 1;

                camera = new ((u_long128 *)MenuDebugStack.Alloc(sizeof(mgCCameraFollow) / 16 + 2))
                    mgCCameraFollow(40.0f, 30.0f, 0.0f, 8.0f);
                MenuDebugCamera = camera;

                model = new ((u_long128 *)MenuDebugStack.Alloc(sizeof(CActionChara) / 16 + 2)) CActionChara;
                MenuDebugItemModel = model;

                model->Initialize(NULL);
                MenuDebugStack.Align64();

                buffer = MenuDebugStack.stack + MenuDebugStack.stack_used;
                model_loaded = 0;
                if (debug_common_data != NULL) {
                    model_path = GetItemFilePath(CMenuItemInfoPt->debug_item_no, 0);
                    if (model_path != NULL && LoadFile2(model_path, buffer, &file_size, 0)) {
                        MenuDebugStack.Alloc(file_size / 16 + 1);
                        stack_used_before_load = MenuDebugStack.stack_used;
                        mgTexManager.DeleteBlock(CMenuItemInfoPt->tex_block[4]);
                        MenuDebugItemModel->LoadPack((u_int *)buffer, at_4954, &MenuDebugStack,
                            &MenuDebugStack, &MenuDebugStack,
                            CMenuItemInfoPt->tex_block[4], 0);
                        MenuDebugItemModel->SetPosition(0.0f, 0.0f, 0.0f);
                        MenuDebugItemModel->SetScale(1.0f, 1.0f, 1.0f);
                        MenuDebugCamera->SetRef(0.0f, 0.0f, 0.0f);
                        MenuDebugCamera->SetPos(0.0f, 0.0f, 100.0f);
                        MenuDebugSize = MenuDebugStack.stack_used - stack_used_before_load;
                        MenuDebugSize = MenuDebugSize * 16 / 1024;
                        model_loaded = 1;
                    }
                }
                if (model_loaded == 0) {
                    buffer = (u8 *)MenuDebugStack.stack +
                             MenuDebugStack.stack_used * 0x10;
                    LoadFile2(dbox_path_6083, buffer, &file_size, 0);
                    MenuDebugStack.Alloc(file_size / 16 + 1);
                    stack_used_before_load = MenuDebugStack.stack_used;
                    mgTexManager.DeleteBlock(CMenuItemInfoPt->tex_block[4]);
                    MenuDebugItemModel->LoadPack((u_int *)buffer, at_4954, &MenuDebugStack,
                        &MenuDebugStack, &MenuDebugStack,
                        CMenuItemInfoPt->tex_block[4], 0);
                    MenuDebugItemModel->SetPosition(0.0f, 0.0f, 0.0f);
                    MenuDebugItemModel->SetScale(1.0f, 1.0f, 1.0f);
                    MenuDebugItemModel->Step();
                    MenuDebugCamera->SetRef(0.0f, 0.0f, 0.0f);
                    MenuDebugCamera->SetPos(0.0f, 0.0f, 100.0f);
                    MenuDebugSize = MenuDebugStack.stack_used - stack_used_before_load;
                    MenuDebugSize = MenuDebugSize * 16 / 1024;
                }
                if (MenuDebugModel_AdjustFlag != 0 && MenuDebugItemModel != NULL) {
                    float scale =
                        MenuAdjustPolygonScale(MenuDebugItemModel->CObjectFrame::frame, 7.0f);
                    MenuDebugItemModel->SetScale(scale, scale, scale);
                }
                GamePad__2.MenuModeOff();
            }
        } else if (MenuDebugModelDrawFlag == 1) {
            if (MenuDebugItemModel != NULL) {
                float x;
                float y;
                s32 camera_control;

                MenuDebugItemModel->GetRotation(rotation);
                x = GamePad__2.GetLXf() / 10.0f;
                y = GamePad__2.GetLYf() / 10.0f;
                camera_control = 0;
                if (GamePad__2.On(PAD_L2)) {
                    camera_control = 1;
                }
                if (camera_control) {
                    ((mgCCameraFollow *)MenuDebugCamera)->GetAngle();
                } else {
                    rotation[1] += x;
                    rotation[0] += y;
                }
                if (rotation[0] > 3.1415927f) {
                    rotation[0] -= 6.2831855f;
                } else if (rotation[0] < -3.1415927f) {
                    rotation[0] += 6.2831855f;
                }
                if (rotation[1] > 3.1415927f) {
                    rotation[1] -= 6.2831855f;
                } else if (rotation[1] < -3.1415927f) {
                    rotation[1] += 6.2831855f;
                }
                if (rotation[2] > 3.1415927f) {
                    rotation[2] -= 6.2831855f;
                } else if (rotation[2] < -3.1415927f) {
                    rotation[2] += 6.2831855f;
                }
                MenuDebugItemModel->SetRotation(rotation);
                MenuDebugItemModel->GetScale(rotation);
                rotation[0] += GamePad__2.GetRYf() / 10.0f;
                if (rotation[0] <= 0.1f) {
                    rotation[0] = 0.1f;
                }
                if (rotation[0] >= 100.0f) {
                    rotation[0] = 100.0f;
                }
                MenuDebugItemModel->SetScale(rotation[0], rotation[0], rotation[0]);
            }
            MenuDebugCamera->Step(1);
            if (buttons & 4) {
                MenuDebugItemModel->SetScale(1.0f, 1.0f, 1.0f);
                MenuDebugItemModel->SetRotation(0.0f, 0.0f, 0.0f);
                MenuDebugModel_AdjustFlag = 0;
            } else if (buttons & 8) {
                if (MenuDebugItemModel != NULL) {
                    MenuDebugModel_AdjustFlag ^= 1;
                    if (MenuDebugModel_AdjustFlag != 0) {
                        float scale = MenuAdjustPolygonScale(
                            MenuDebugItemModel->CObjectFrame::frame, 7.0f);
                        MenuDebugItemModel->SetScale(scale, scale, scale);
                    } else {
                        MenuDebugItemModel->SetScale(1.0f, 1.0f, 1.0f);
                    }
                }
            } else if (buttons & 2) {
                MenuDebugModelDrawFlag = 0;
                MenuDebugItemModel = NULL;
                MenuDebugCamera = NULL;
                GamePad__2.MenuModeOn(0x78);
            }
        }
        break;

    case 3: {
        CHARA_DATA *chara;
        s32 change_maximum;

        chara = MenuUserParam.chara[CMenuItemInfoPt->sub_view];
        if (chara != NULL) {
            *(u64 *)health_input = at_6133;
            MenuCommonInfo->CheckAnalogKey(0, health_input);
            change_maximum = 0;
            if (GamePad__2.On(PAD_L2)) {
                change_maximum = 1;
            }
            if (change_maximum == 0) {
                chara->hp.now = chara->hp.now + (float)(s32)health_input[0];
            }
            if (change_maximum == 1) {
                chara->hp.max = chara->hp.max + (float)(s32)health_input[0];
            }
            chara->hp.max = GetDispVolumeForFloat(chara->hp.max);
            if (chara->hp.now >= chara->hp.max) {
                chara->hp.now = chara->hp.max;
            }
            if (chara->hp.now <= 0.0f) {
                chara->hp.now = 0.0f;
            }
            if (chara->hp.max > 255.0f) {
                chara->hp.max = 255.0f;
            }
            if (chara->hp.max <= 0.0f) {
                chara->hp.max = 0.0f;
            }
        }
        if (GamePad__2.On(PAD_CIRCLE)) {
            (u16 &)chara->defence += 1;
            if ((u16)chara->defence > 0x80) {
                chara->defence = 0x80;
            }
        } else if (GamePad__2.On(PAD_CROSS)) {
            s32 count = (u16)chara->defence;

            if (0 < count) {
                chara->defence = count - 1;
            }
        }
        if (buttons & 4) {
            MenuUserDataManPtr->AddMoney(1000);
            CMenuItemInfoPt->money_form->SetNumber(
                at_1493__2, MenuUserDataManPtr->AddMoney(0));
        }
        if (buttons & 8) {
            if (init_6162 == 0) {
                cnt_6161 = 0;
                init_6162 = 1;
            }
            MenuUserDataManPtr->SetCharaStatusAttirbuteVol(
                CMenuItemInfoPt->sub_view, table_6164[cnt_6161], 0x78);
            cnt_6161 += 1;
            if (cnt_6161 > 6) {
                cnt_6161 = 0;
            }
        }
        return;
    }

    case 4: {
        s32 change_maximum;
        s32 change_durability;
        s32 change_experience;

        if (item == NULL) {
            break;
        }
        change_maximum = 0;
        change_durability = 0;
        change_experience = 0;
        if (GamePad__2.On(PAD_L2 | PAD_R2)) {
            change_durability = 1;
        }
        if (GamePad__2.On(PAD_L1 | PAD_R1)) {
            change_experience = 1;
        }
        if (GamePad__2.On(PAD_L2 | PAD_L1)) {
            change_maximum = 1;
        }
        *(u64 *)gauge_input = at_6176;
        MenuCommonInfo->CheckAnalogKey(0, gauge_input);
        if (item->used_type == USED_ITEM_TYPE_WEAPON) {
            if (change_durability) {
                if (change_maximum == 0) {
                    item->data.weapon.whp.now += gauge_input[0];
                }
                if (change_maximum == 1) {
                    item->data.weapon.whp.max += gauge_input[0];
                }
                if (item->data.weapon.whp.max < 1.0f) {
                    item->data.weapon.whp.max = 1.0f;
                }
                if (255.0f < item->data.weapon.whp.max) {
                    item->data.weapon.whp.max = 255.0f;
                }
                item->data.weapon.whp.max = GetDispVolumeForFloat(item->data.weapon.whp.max);
                if (item->data.weapon.whp.now < 0.0f) {
                    item->data.weapon.whp.now = 0.0f;
                }
                if (item->data.weapon.whp.max < item->data.weapon.whp.now) {
                    item->data.weapon.whp.now = item->data.weapon.whp.max;
                }
            }
            if (change_experience) {
                if (change_maximum == 0) {
                    item->data.weapon.abs.now += gauge_input[0];
                }
                if (change_maximum == 1) {
                    item->data.weapon.abs.max += gauge_input[0];
                }
                if (item->data.weapon.abs.max < 1.0f) {
                    item->data.weapon.abs.max = 1.0f;
                }
                if (99999.0f < item->data.weapon.abs.max) {
                    item->data.weapon.abs.max = 99999.0f;
                }
                item->data.weapon.abs.max = GetDispVolumeForFloat(item->data.weapon.abs.max);
                if (item->data.weapon.abs.now < 0.0f) {
                    item->data.weapon.abs.now = 0.0f;
                }
                if (item->data.weapon.abs.max < item->data.weapon.abs.now) {
                    item->data.weapon.abs.now = item->data.weapon.abs.max;
                }
            }
            if (buttons & 1) {
                item->AddFusionPoint(1);
            }
            if (buttons & 2) {
                item->AddFusionPoint(-1);
            }
            if (buttons & 8) {
                item->AddFusionPoint(500);
            }
            if (buttons & 4) {
                item->LevelUp();
                MenuSePlay(1);
            }
        }
        return;
    }

    case 5: {
        s32 status_index;
        CDataWeapon *info;

        if (item == NULL) {
            break;
        }
        if (item->used_type == USED_ITEM_TYPE_WEAPON) {
            info = GetWeaponInfoData(item->item_no);
            MenuCommonInfo->CheckSelectKey();
            CMenuKeyFunc *common = MenuCommonInfo;

            status_index = common->cursor;
            *(u64 *)weapon_status_input = at_6220;
            common->CheckAnalogKey(0, weapon_status_input);
            if (status_index < 2) {

                s16 *field = &item->data.weapon.status[status_index];

                *field += (s16)(s32)weapon_status_input[0];
                if (*field < 0) {
                    *field = 0;
                }
                if (info->status_max[status_index] < *field) {
                    *field = info->status_max[status_index];
                }
            } else {
                s16 *field = &item->data.weapon.attribute[status_index - 2];

                *field += (s16)(s32)weapon_status_input[0];
                if (*field < 0) {
                    *field = 0;
                }
                if (info->attribute_max[status_index - 2] < *field) {
                    *field = info->attribute_max[status_index - 2];
                }
            }
        }
        if (item->used_type == USED_ITEM_TYPE_ROBO_PART) {
            s16 *field;

            MenuCommonInfo->CheckSelectKey();
            CMenuKeyFunc *common = MenuCommonInfo;

            status_index = common->cursor;
            *(u64 *)ridepod_status_input = at_6234;
            common->CheckAnalogKey(0, ridepod_status_input);
            if (status_index < 2) {
                field = &item->data.robopart.status[status_index];
                *field += (s16)(s32)ridepod_status_input[0];
                if (*field < 0) {
                    *field = 0;
                }
                if (item->data.robopart.status[status_index + 1] > 255) {
                    item->data.robopart.status[status_index + 1] = 255;
                }
            } else {
                field = &item->data.robopart.status[status_index];
                *field += (s16)(s32)ridepod_status_input[0];
                if (*field < 0) {
                    *field = 0;
                }
                if (*field > 0xFF) {
                    *field = 0xFF;
                }
            }
        }
        break;
    }

    case 6: {
        float amount;

        amount = 1.0f;
        if (GamePad__2.On(PAD_L1 | PAD_R1)) {
            amount = 100.0f;
        }
        if (GamePad__2.On(PAD_CIRCLE)) {
            MenuUserDataManPtr->AddRoboAbs(amount);
        }
        if (GamePad__2.On(PAD_CROSS)) {
            MenuUserDataManPtr->AddRoboAbs(-amount);
        }
        if (GamePad__2.Down(PAD_TRIANGLE)) {
            MenuUserParam.robo->voice_unit ^= 1;
        }
        return;
    }

    case 7: {
        s32 status_index;

        CMenuKeyFunc *common = MenuCommonInfo;

        status_index = common->cursor;
        *(u64 *)ridepod_gauge_input = at_6256;
        common->CheckAnalogKey(0, ridepod_gauge_input);
        if (status_index == 0) {
            MenuUserParam.robo->AddPoint(ridepod_gauge_input[0]);
        } else if (status_index == 1) {
            MenuUserDataManPtr->AddWhp(2, 0, (s32)ridepod_gauge_input[0]);
        }
        break;
    }

    case 10: {
        s32 status_index;
        CDataWeapon *info;
        s16 *field;

        if (item->IsFishingRod()) {
            info = GetWeaponInfoData(item->item_no);
            MenuCommonInfo->CheckSelectKey();
            CMenuKeyFunc *common = MenuCommonInfo;

            status_index = common->cursor;
            *(u64 *)rod_status_input = at_6265;
            common->CheckAnalogKey(0, rod_status_input);
            field = &item->data.weapon.attribute[status_index];
            *field += (s16)(s32)rod_status_input[0];
            if (*field < 0) {
                *field = 0;
            }
            if (info->attribute_max[status_index] < *field) {
                *field = info->attribute_max[status_index];
            }
            if (GamePad__2.On(PAD_CIRCLE)) {
                item->AddFusionPoint(1);
            }
            if (GamePad__2.On(PAD_CROSS)) {
                item->AddFusionPoint(-1);
            }
            if (GamePad__2.On(PAD_TRIANGLE)) {
                item->AddFusionPoint(-500);
            }
            if (GamePad__2.On(PAD_SQUARE)) {
                item->AddFusionPoint(500);
            }
        }
        break;
    }

    case 11:
        break;
    }

    switch (CMenuItemInfoPt->key_arg_no) {
    case 5:
        if (item != NULL) {
            CDataWeapon *info = GetWeaponInfoData(item->item_no);

            if (buttons & 4) {
                item->data.weapon.status[0] = info->status_max[0];
                item->data.weapon.status[1] = info->status_max[1];
                item->data.weapon.attribute[0] = info->attribute_max[0];
                item->data.weapon.attribute[1] = info->attribute_max[1];
                item->data.weapon.attribute[2] = info->attribute_max[2];
                item->data.weapon.attribute[3] = info->attribute_max[3];
                item->data.weapon.attribute[4] = info->attribute_max[4];
                item->data.weapon.attribute[5] = info->attribute_max[5];
                item->data.weapon.attribute[6] = info->attribute_max[6];
                item->data.weapon.attribute[7] = info->attribute_max[7];
            }
            if (buttons & 8) {
                item->data.weapon.status[0] = info->status[0];
                item->data.weapon.status[1] = info->status[1];
                item->data.weapon.attribute[0] = info->attribute[0];
                item->data.weapon.attribute[1] = info->attribute[1];
                item->data.weapon.attribute[2] = info->attribute[2];
                item->data.weapon.attribute[3] = info->attribute[3];
                item->data.weapon.attribute[4] = info->attribute[4];
                item->data.weapon.attribute[5] = info->attribute[5];
                item->data.weapon.attribute[6] = info->attribute[6];
                item->data.weapon.attribute[7] = info->attribute[7];
            }
            if (GamePad__2.Down(PAD_R1)) {
                if (init_6299 == 0) {
                    testcnt_6298 = 0;
                    init_6299 = 1;
                }

                u32 mask = 0;

                mask |= 1 << testcnt_6298;
                item->data.weapon.special = CheckWeaponAttribute(item->data.weapon.special, mask);
                testcnt_6298 += 1;
                if (testcnt_6298 >= 0xC) {
                    testcnt_6298 = 0;
                }
            }
        }
        break;
    }
}

#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemDebugKey__Fv);
#endif
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemDebugDraw__Fv);
extern "C" int GetActiveCharaIDForItemCmd__13CMenuItemInfoFv(CMenuItemInfo *);
extern "C" int GetModelNo__13CGameDataUsedFv(CGameDataUsed *);
int CMenuItemInfo::PushKey(int pad, int trigger) {
    int leaving = 0;
    CHARA_DATA *chara;
    short held_item_no;
    int area;
    int command;
    CGameDataUsed *target;
    CGameDataUsed *held_item;
    int cursor;
    int item_type;
    int fusion_target;
    CMenuPosDataForm *message_form;
    union { CGameDataUsed saved_item; };
    char path[0x40];
    char full_path[0x60];
    MENU_SWAPITEM_INFO swap;
    int equip_slot;
    int robo_equip_slot;
    char *item_name;
    int file_size;
    int fusion_file_size;
    if (MenuCommonInfo->key_enable == 0) {
        return 0;
    }
    short state = this->mode;
    switch (state) {
        case kStateBrowse: {
            held_item_no = ((CGameDataUsed *)(&MenuCommonInfo->have_item))->item_no;
            cursor = MenuCommonInfo->select_pos[0];
            command = kCmdNone;
            target = NULL;
            area = -1;
            chara = MenuUserParam.chara[this->sub_view];
            item_type = ConvertUsedItemType(GetItemDataType(held_item_no));
            fusion_target = 0;
            if (pad != 0 || trigger != 0) {
                if (MenuSpectolSatusCheckForm != NULL && this->unk_198 != 0) {
                    MenuSpectolSatusCheckForm->SetAction(at_5757);
                    this->unk_198 = 0;
                    goto done;
                }
            }
            swap.Set(-1, 0, -1, 0);
            switch (this->key_arg_no) {
                case 0:
                    target = &chara->active_item[cursor];
                    swap.Set(kAreaHand, cursor, this->sub_view, 0);
                    area = kAreaHand;
                    switch (trigger) {
                        case 4:
                            command = kCmdPlaceItem;
                            break;
                        case 8:
                            command = kCmdTakeAll;
                            break;
                        case 1:
                            command = kCmdOpenCommandMenu;
                            if (held_item_no > 0) {
                                command = kCmdPlaceItem;
                            }
                            break;
                        case 2:
                            command = kCmdCancel;
                            break;
                    }
                    break;
                case 1:
                    fusion_target = 1;
                    target = &chara->equip[cursor];
                    swap.Set(fusion_target, cursor, this->sub_view, 0);
                    area = kAreaEquip;
                    switch (trigger) {
                        case 4:
                        case 8:
                            command = kCmdPlaceItem;
                            break;
                        case 1:
                            command = kCmdOpenCommandMenu;
                            if (held_item_no > 0) {
                                command = kCmdPlaceItem;
                            }
                            break;
                        case 2:
                            command = kCmdCancel;
                            break;
                    }
                    break;
                case 2:
                    fusion_target = 1;
                    target = &MenuUserParam.used_data[cursor];
                    swap.Set(kAreaBag, cursor, -1, 0);
                    area = kAreaBag;
                    switch (trigger) {
                        case 4:
                            command = kCmdPlaceItem;
                            break;
                        case 8:
                            command = kCmdTakeAll;
                            break;
                        case 1:
                            command = kCmdOpenCommandMenu;
                            if (held_item_no > 0) {
                                command = kCmdPlaceItem;
                            }
                            break;
                        case 2:
                            command = kCmdCancel;
                            break;
                        case 32:
                            command = kCmdSortBag;
                            break;
                    }
                    break;
                case 3:
                    switch (trigger) {
                        case 4:
                        case 8:
                        case 1:
                            command = kCmdUseOnChara;
                            break;
                        case 2:
                            command = kCmdCancel;
                            break;
                    }
                    break;
                case 4:
                case 9:
                    fusion_target = 1;
                    target = this->view_weapon;
                    swap.Set(kAreaSelected, -1, -1, 0);
                    area = kAreaSelected;
                    if (trigger != 2) {
                        switch (trigger) {
                            case 4:
                            case 8:
                            case 1:
                                command = kCmdOpenCommandMenu;
                                if (0 < held_item_no) {
                                    command = kCmdFuseSelected;
                                }
                                break;
                        }
                    } else {
                        command = kCmdCancel;
                    }
                    break;
                case 5:
                    switch (trigger) {
                        case 4:
                        case 8:
                        case 1:
                            command = kCmdDenied;
                            break;
                        case 2:
                            command = kCmdCancelNoLoad;
                            break;
                    }
                    break;
                case 10:
                    switch (trigger) {
                        case 4:
                        case 8:
                        case 1:
                            command = kCmdDenied;
                            break;
                        case 2:
                            command = kCmdCancelNoLoad;
                            break;
                    }
                    break;
                case 6:
                    switch (trigger) {
                        case 4:
                        case 8:
                        case 1:
                            command = kCmdUseOnRobo;
                            break;
                        case 2:
                            command = kCmdCancel;
                            break;
                    }
                    break;
                case 7: {
                    signed char robo_slot = MenuRoboEquipTable[cursor];
                    target = &MenuUserParam.robo->parts[0] + robo_slot;
                    swap.Set(kAreaRobo, robo_slot, 2, 0);
                    area = kAreaRobo;
                    switch (trigger) {
                        case 4:
                        case 8:
                            command = kCmdPlaceItem;
                            break;
                        case 1:
                            command = kCmdOpenCommandMenu;
                            if (0 < held_item_no) {
                                command = kCmdPlaceItem;
                            }
                            break;
                        case 2:
                            command = kCmdCancel;
                            break;
                    }
                    break;
                }
                case 8:
                    switch (trigger) {
                        case 4:
                        case 8:
                        case 1:
                            command = kCmdUseOnMonster;
                            break;
                        case 2:
                            command = kCmdCancel;
                            break;
                    }
                    break;
                case 11:
                    target = GetUserDataMan()->GetActiveEsa();
                    swap.Set(kAreaBait, cursor, this->sub_view, 0);
                    area = kAreaBait;
                    switch (trigger) {
                        case 4:
                            command = kCmdPlaceItem;
                            break;
                        case 8:
                            command = kCmdTakeAll;
                            break;
                        case 1:
                            command = kCmdOpenCommandMenu;
                            if (held_item_no > 0) {
                                command = kCmdPlaceItem;
                            }
                            break;
                        case 2:
                            command = kCmdCancel;
                            break;
                    }
                    break;
            }
            if (menu_debug_flag != 0) {
                MenuItemDebugKey();
                return 0;
            }
            int item_used = 0;
            message_form = MenuMesForm[4];
            held_item = (CGameDataUsed *)(&MenuCommonInfo->have_item);
            this->SaveViewWeaponStatus();
            switch (command) {
                case kCmdDenied:
                    MenuSePlay(5);
                    break;
                case kCmdOpenCommandMenu:
                    if (MenuItemMoveItemCommand(target, area, 5, MenuMesForm[5],
                                                GetActiveCharaIDForItemCmd__13CMenuItemInfoFv(this)) != 0) {
                        CMenuPosDataForm *form = MenuCommonInfo->cursor_form;
                        if (form != NULL) {
                            form->draw_flag = 0;
                        }
                    }
                    break;
                case kCmdPlaceItem:
                    if (fusion_target != 0 &&
                        this->CheckSpectolFusion(target, 4, message_form) != 0) {
                        CMenuPosDataForm *form = MenuCommonInfo->cursor_form;
                        if (form != NULL) {
                            form->draw_flag = 0;
                        }
                        MenuSePlay(1);
                        if (target == this->view_weapon) {
                            itemmenu_chr_rotflag = 0;
                        }
                    } else {
                        unsigned int swap_state = MenuCommonInfo->EnableSwapNowPos(&swap);
                        switch (swap_state) {
                            case 0: {
                                int moved = MenuCommonInfo->MenuSwapItem(target, &swap, 1, true);
                                MenuSePlay(menu_item_swap_sndtbl[moved]);
                                this->CheckViewWeaponStatus(0);
                                if (moved > 0) {
                                    switch (area) {
                                        case kAreaEquip:
                                            this->CheckLoadInfo(this->sub_view);
                                            MenuLoadInfo.unk_4 =
                                                ConvertCharaLoadDataPhase(this->sub_view, cursor);
                                            MenuLoadInfo.unk_5 = MenuLoadInfo.unk_4;
                                            MenuLoadInfo.unk_2 = 0;
                                            this->ModelReadStart(this->view_mode, 1, 1);
                                            break;
                                        case kAreaRobo:
                                            this->CheckLoadInfo(2);
                                            MenuLoadInfo.unk_4 = ConvertCharaLoadDataPhase(
                                                2, MenuRoboEquipTable[cursor]);
                                            MenuLoadInfo.unk_2 = 0;
                                            this->ModelReadStart(this->view_mode, 1, 1);
                                            break;
                                    }
                                }
                                break;
                            }
                            case 1:
                            case 2:
                            case 8:
                            case 9:
                                MenuSePlay(5);
                                break;
                            case 4:
                                this->SetAskHowMuchItemNum(&swap, target);
                                MenuSePlay(1);
                                break;
                            case 3:
                                MenuSePlay(0x1C);
                                break;
                            case 5:
                                if (MenuItemUse.CheckItemUseEnable(held_item, 1, target) != 0) {
                                    item_used = MenuItemUse.UseItem(held_item, 1, target);
                                    MenuCommonInfo->SetHaveItemInfo(1, 1);
                                    if (held_item->GetNum() <= 0) {
                                        MenuCommonInfo->SetHaveItemInfo(0, 1);
                                    }
                                } else {
                                    MenuSePlay(5);
                                }
                                break;
                        }
                    }
                    break;
                case kCmdTakeAll:
                    if (MenuCommonInfo->EnableSwapNowPos(&swap) == 0 ||
                        ((CGameDataUsed *)(&MenuCommonInfo->have_item))->item_no <= 0) {
                        MenuCommonInfo->GetItemAll(target, &swap);
                        this->CheckViewWeaponStatus(0);
                    }
                    break;
                case kCmdSortBag: {
                    int found = 0;
                    __ct__13CGameDataUsedFv(&saved_item);
                    short view_mode = this->view_mode;
                    if ((view_mode == 2 || view_mode == 5) &&
                        0 <= GetSameAdrressUserData(this->view_weapon, 0)) {
                        found = 1;
                        saved_item.CopyGameData(this->view_weapon);
                    }
                    MenuSeiton(MenuUserParam.used_data, 0x96);
                    if (found != 0) {
                        int i = 0;
                        do {
                            if (memcmp(&saved_item, &MenuUserParam.used_data[i], sizeof(CGameDataUsed)) ==
                                0) {
                                this->view_weapon = &MenuUserParam.used_data[i];
                                break;
                            }
                            i += 1;
                        } while (i < 0x96);
                    }
                    CheckEnableHaveItemNum();
                    MenuSePlay(1);
                    break;
                }
                case kCmdUseOnChara:
                    switch (item_type) {
                        case 3:
                        case 4:
                        case 5: {
                            equip_slot = -1;
                            if (this->EquipDirect(this->sub_view, held_item, equip_slot) == 0) {
                                MenuSePlay(0x1C);
                            } else {
                                MenuSePlay(8);
                                this->CheckLoadInfo(this->sub_view);
                                MenuLoadInfo.unk_4 =
                                    ConvertCharaLoadDataPhase(this->sub_view, equip_slot);
                                MenuLoadInfo.unk_5 = MenuLoadInfo.unk_4;
                                MenuLoadInfo.unk_2 = 0;
                                this->ModelReadStart(this->view_mode, 1, 1);
                            }
                            break;
                        }
                        default: {
                            CHARA_DATA *chr = MenuUserParam.chara[this->sub_view];
                            if (held_item_no == 0x126) {
                                if (MenuItemUse.UseItem(held_item, 1, &chr->equip[0]) == 0 &&
                                    MenuItemUse.UseItem(held_item, 1, &chr->equip[1]) == 0) {
                                    MenuSePlay(5);
                                }
                            } else if (MenuItemUse.CheckItemUseEnable(held_item, 0, chr) != 0) {
                                item_used = MenuItemUse.UseItem(held_item, 0, chr);
                                if (held_item->GetNum() <= 0) {
                                    MenuCommonInfo->SetHaveItemInfo(0, 1);
                                } else {
                                    MenuCommonInfo->SetHaveItemInfo(1, 1);
                                }
                            } else {
                                MenuSePlay(5);
                            }
                            break;
                        }
                    }
                    break;
                case kCmdFuseSelected:
                    if (this->CheckSpectolFusion(this->view_weapon, 4, message_form) != 0) {
                        CMenuPosDataForm *form = MenuCommonInfo->cursor_form;
                        if (form != NULL) {
                            form->draw_flag = 0;
                        }
                        MenuSePlay(1);
                        itemmenu_chr_rotflag = 0;
                    } else {
                        item_used = MenuItemUse.UseItem(held_item, 1, this->view_weapon);
                        MenuCommonInfo->SetHaveItemInfo(1, 1);
                        if (held_item->GetNum() <= 0) {
                            MenuCommonInfo->SetHaveItemInfo(0, 1);
                        }
                        if (item_used == 0) {
                            MenuSePlay(5);
                        }
                    }
                    break;
                case kCmdUseOnRobo:
                    switch (item_type) {
                        case 3:
                        case 4:
                        case 5: {
                            robo_equip_slot = -1;
                            if (this->EquipDirect(2, held_item, robo_equip_slot) == 0) {
                                MenuSePlay(0x1C);
                            } else {
                                this->CheckLoadInfo(2);
                                MenuSePlay(8);
                                MenuLoadInfo.unk_4 =
                                    ConvertCharaLoadDataPhase(this->load_item_no, robo_equip_slot);
                                MenuLoadInfo.unk_2 = 0;
                                this->ModelReadStart(this->view_mode, 1, 1);
                            }
                            break;
                        }
                        default:
                            item_used = MenuItemUse.UseItem(held_item, 2, MenuUserParam.robo);
                            if (held_item->GetNum() <= 0) {
                                MenuCommonInfo->SetHaveItemInfo(0, 1);
                            } else {
                                MenuCommonInfo->SetHaveItemInfo(1, 1);
                            }
                            if (item_used == 0) {
                                MenuSePlay(5);
                            }
                            break;
                    }
                    break;
                case kCmdUseOnMonster:
                    item_used = MenuItemUse.UseItem(held_item, 3, MenuUserParam.monster);
                    MenuCommonInfo->SetHaveItemInfo(1, 1);
                    if (held_item->GetNum() <= 0) {
                        MenuCommonInfo->SetHaveItemInfo(0, 1);
                    }
                    if (item_used == 0) {
                        MenuSePlay(5);
                    }
                    break;
                case kCmdCancel:
                    if (this->IsCancelLoadItem() == 2) {
                        int over_item_no;
                        leaving = 1;
                        over_item_no = CheckItemLimmitOver();
                        if (CheckItemOver() != 0 || over_item_no != 0) {
                            CDC2Mes *msg;
                            leaving = 0;
                            this->mode = kStateOverLimit;
                            MenuMesForm[7]->draw_flag = 1;
                            msg = MenuDCMsg[7];
                            msg->MsgPreset(0xA);
                            msg->SetAbsPos(5);
                            msg->MakeMsg(0x96);
                            if (over_item_no != 0) {
                                msg->MakeMsg(0x99);

                                *(float *)&item_name = at_7021;
                                item_name = (char *)GetItemMessage(over_item_no);
                                CDataCommon *data = GetCommonItemData(over_item_no);
                                msg->SetMsgItemNo(&item_name, 1);
                                msg->SetMsgVolumeNoOne(data->max_num);
                            }
                            CMenuPosDataForm *form = MenuCommonInfo->cursor_form;
                            if (form != NULL) {
                                form->draw_flag = 0;
                            }
                        }
                    }
                    break;
                case kCmdCancelNoLoad:
                    this->IsCancelNoneLoadItem();
                    break;
                case kCmdUnused:
                    break;
                case kCmdBuildUpInfo:
                    this->NextModeBuildUpInfo(this->view_weapon);
                    break;
            }
            if (item_used != 0) {
                this->SetItemEffect();
            }
            if (leaving == 1) {
                this->mode = kStateClosing;
                MenuCommonInfo->key_enable = 0;
                MenuRepairMan->Clear();
                if (MenuSpectolSatusCheckForm != NULL) {
                    MenuSpectolSatusCheckForm->SetAction(at_5757);
                    this->unk_198 = 0;
                }
                if (CheckTrushMenu() != 0 && ItemOverFlowCheckFlag == 1) {
                    MenuCommonInfo->open_type -= 0x10;
                }
                StartReadBG();
                this->unk_174 = 0;
                if (0 <= this->unk_172) {
                    int chara_no;
                    CHARA_DATA **chr_ptr =
                        &MenuUserParam.chara[chara_no = this->GetActiveCharaNo()];
                    int model_no = GetModelNo__13CGameDataUsedFv(&(*chr_ptr)->equip[0]);
                    if (this->unk_172 != model_no) {
                        SetMenuEtcFlag(1);
                        MainCharaReadStackReadAdr =
                            (u8*)(MainCharaReadStack.stack + MainCharaReadStack.stack_used);
                        GetMainCharaModelName(chara_no, path, 0);
                        MainCharaReadBuffer.model = (u_int *)MainCharaReadStackReadAdr;
                        sprintf(full_path, at_7342, path);
                        LoadFileBG(full_path, (u_long128 *)MainCharaReadBuffer.model, &file_size);
                        unsigned int blocks = QuadwordsFor(file_size);
                        MainCharaReadStack.Alloc(blocks);
                        MainCharaReadStack.Align64();
                        MainCharaReadBuffer.skin =
                            (u_int *)(MainCharaReadStack.stack + MainCharaReadStack.stack_used);

                        char *file = (char *)(*chr_ptr)->equip[4].GetDataPath();
                        if (file != NULL) {
                            LoadFileBG(file, (u_long128 *)MainCharaReadBuffer.skin, &file_size);
                            blocks = QuadwordsFor(file_size);
                            MainCharaReadStack.Alloc(blocks);
                        }
                        MainCharaReadStack.Align64();
                        MainCharaReadBuffer.outline =
                            (u_int *)(MainCharaReadStack.stack + MainCharaReadStack.stack_used);
                        file = (char *)(*chr_ptr)->equip[3].GetDataPath();
                        if (file != NULL) {
                            LoadFileBG(file, (u_long128 *)MainCharaReadBuffer.outline, &file_size);
                            blocks = QuadwordsFor(file_size);
                            MainCharaReadStack.Alloc(blocks);
                        }
                        this->unk_174 = 1;
                    }
                }
                InitFishBoiledEffect(NULL, NULL);
                this->CheckSoundLoad();
                if (CheckTrushMenu() != 0) {
                    this->FadeOutMenu(0x28, 0.0f);
                } else {
                    this->ExeScript(at_7343);
                    MenuMainFrameModeSet(3, 1);
                    ReturnMenuIntern(0);
                    if (MenuActionChara[0] != NULL) {
                        MenuActionChara[0]->SetFadeFlag(1);
                        MenuActionChara[0]->Show(0, 1);
                    }
                }
            }
            break;
        }
        case kStateOverLimit:
            if (trigger != 0) {
                this->mode = kStateBrowse;
                MenuMesForm[7]->draw_flag = 0;
                CMenuPosDataForm *form = MenuCommonInfo->cursor_form;
                if (form != NULL) {
                    form->draw_flag = 1;
                }
                MenuSePlay(1);
            }
            break;
        case kStateTuneBuildUp: {
            switch (this->step) {
                case kTuneAdjust: {
                    int previous = MenuCommonInfo->select_pos[0];
                    if (pad & kPadUp) {
                        MenuCommonInfo->select_pos[0] = previous - 1;
                    }
                    if (pad & kPadDown) {
                        MenuCommonInfo->select_pos[0] += 1;
                    }
                    if (MenuCommonInfo->select_pos[0] < 0) {
                        MenuCommonInfo->select_pos[0] = 0;
                    }
                    if (MenuCommonInfo->select_pos[0] > 4) {
                        MenuCommonInfo->select_pos[0] = 4;
                    }
                    if (previous != MenuCommonInfo->select_pos[0]) {
                        MenuSePlay(0);
                    }
                    CGameDataUsed *item = this->view_weapon;
                    short *saved_words = (short *)&SpectolInfoStay.data.weapon.whp;
                    short *words = (short *)&item->data.weapon.whp;
                    int spare_points = *(short *)((u8 *)item + 0x3C) / kPointsPerStep;
                    int selected = MenuCommonInfo->select_pos[0];
                    short *entry = (short *)((selected << 1) + (int)words);
                    short *stat_slot = &entry[kStatWord];
                    short value = entry[kStatWord];
                    if (0 < value - saved_words[selected + kStatWord]) {
                        if (0 < value) {
                            if (pad & kPadLeft) {
                                *stat_slot = value - 1;
                                words[kSpareWord] += kPointsPerStep;
                                MenuSePlay(0);
                            }
                        }
                    }
                    if (0 < spare_points) {
                        if (words[MenuCommonInfo->select_pos[0] + kStatWord] < kStatMax &&
                            (pad & kPadRight)) {
                            words[kSpareWord] -= kPointsPerStep;
                            words[MenuCommonInfo->select_pos[0] + kStatWord] += 1;
                            if (words[kSpareWord] < 0) {
                                words[kSpareWord] = 0;
                            }
                            MenuSePlay(0);
                        }
                    }
                    if (trigger & 1) {
                        int changed = 0;
                        int i = 0;
                        int offset = 0;
                        do {
                            if (*(short *)((u8 *)saved_words + offset + 0x16) <
                                *(short *)((u8 *)words + offset + 0x16)) {
                                changed = 1;
                            }
                            i += 1;
                            offset += 2;
                        } while (i < 5);
                        if (changed != 0) {
                            this->step = kTuneConfirmSave;
                            this->ExeScript(at_7344);
                            MenuSePlay(1);
                        } else {
                            MenuSePlay(5);
                        }
                    } else if (trigger & 2) {
                        this->step = kTuneConfirmDiscard;
                        this->ExeScript(at_7345);
                    }
                    break;
                }
                case kTuneConfirmSave: {
                    int answer = MenuDCMsg[7]->YesNoCursor2(0);
                    if (answer == 1) {
                        MenuSePlay(0x1E);
                        this->unk_160 = 0;
                        this->mode = kStateBrowse;
                        this->ExeScript(at_7346);
                    }
                    if (answer == 2) {
                        this->step = kTuneAdjust;
                        this->ExeScript(at_7346);
                        MenuSePlay(5);
                    }
                    break;
                }
                case kTuneConfirmDiscard: {
                    int answer = MenuDCMsg[7]->YesNoCursor2(0);
                    if (answer == 1) {
                        this->view_weapon->CopyGameData(&SpectolInfoStay);
                        this->unk_160 = 0;
                        this->mode = kStateBrowse;
                        this->step = kTuneAdjust;
                        this->ExeScript(at_7346);
                        MenuSePlay(1);
                    }
                    if (answer == 2) {
                        this->step = kTuneAdjust;
                        this->ExeScript(at_7346);
                        MenuSePlay(5);
                    }
                    break;
                }
            }
            break;
        }
        default: {
            mgCMemory *load_stack = &MenuCharaLoadStack;
            int extend_result = this->ExtendCommand(pad, trigger);
            switch (this->mode) {
                case kStateSpectolBreak:
                    if (extend_result == 2) {
                        SetEffectSpectolBreak(load_stack, MenuEffect[0], (this->ask_para.item)->item_no);
                        MenuCommonInfo->FadeOutMenuBGMVol(-6, 0x18);
                        MenuSePlay(0, MenuItemSpectolTransSoundBuffer, load_stack);
                        Save_AskParamInfo_7099 = (void *)this->ask_para.item;
                    }
                    if (extend_result == 3) {
                        int index = GetSameAdrressUserData(this->ask_para.item2, 0);
                        int line = index / 6;
                        if (line < MenuItem_ItemBoardTopLine) {
                            while (line < MenuItem_ItemBoardTopLine) {
                                MenuItem_ItemBoardTopLine -= 1;
                            }
                        } else if (MenuItem_ItemBoardTopLine + 5 <= line) {
                            while (MenuItem_ItemBoardTopLine + 5 <= line) {
                                MenuItem_ItemBoardTopLine += 1;
                            }
                        }
                        (&MenuCommonInfo->cursor)[1] = MenuItem_ItemBoardTopLine;
                        MenuItem_ItemBoardTopSelect = index;
                        MenuCommonInfo->select_pos[0] = (short)index;
                    }
                    break;
                case kStateSpectolFusion:
                    if (init_7121 == 0) {
                        fusion_blinkcnt_7120 = 0;
                        init_7121 = 1;
                    }
                    fusion_blinkcnt_7120 += 1;
                    if (fusion_blinkcnt_7120 >= kBlinkPeriod) {
                        fusion_blinkcnt_7120 = 0;
                    }
                    if (init_7126 == 0) {
                        diffent_weapon_dispflag_7125 = 0;
                        init_7126 = 1;
                    }
                    if (extend_result == 2) {
                        diffent_weapon_dispflag_7125 = 0;
                        SetEffectSpectolFusion(load_stack, MenuEffect, SpectolInfo[0],
                                               this->key_arg_no == 4);
                        int top_line = MenuItem_ItemBoardTopLine;
                        if (trans_spectol_pos < top_line || top_line + 5 < trans_spectol_pos) {
                            MenuEffect[1]->SetTexInfo(NULL, NULL);
                        }
                        if (this->key_arg_no == 4) {
                            MenuEffect[1]->SetTexInfo(NULL, NULL);
                        }
                        load_stack->Alloc(0x100);
                        MenuCommonInfo->FadeOutMenuBGMVol(-6, 0x18);
                        StartReadBG();
                        LoadFileBG(at_7347,
                                   (u_long128 *)(load_stack->stack + load_stack->stack_used),
                                   &fusion_file_size);
                        unsigned int blocks = QuadwordsFor(fusion_file_size);
                        load_stack->Alloc(blocks);
                        SpectolFusionTargetChara = NULL;
                        SpectolFusion_LeftOrRight = 0;
                        if (this->view_mode == 2) {
                            SpectolFusionTargetChara = MenuActionChara[0];
                            if (this->view_weapon != SpectolInfo[0]) {
                                diffent_weapon_dispflag_7125 = 1;
                            }
                        }
                        int weapon_kind = SpectolInfo[0]->item_type;
                        if (this->key_arg_no == 1) {
                            if (weapon_kind == 2 || weapon_kind == 4) {
                                SpectolFusion_LeftOrRight = 1;
                            }
                        }
                    }
                    if (extend_result == 3) {
                        if (this->view_mode == 2) {
                            CActionChara *chara = NULL;
                            if (0 < this->view_weapon->IsBuildUp(NULL, NULL, NULL)) {
                                chara = MenuActionChara[0];
                            }
                            SetBuildUpInfoChara((CCharacter2 *)chara, ActiveMenuWeaponCharaRange);
                        }
                        if (this->view_mode != 2 || diffent_weapon_dispflag_7125 == 1) {
                            this->key_arg_no = 4;
                            this->view_mode = 2;
                            MenuCommonInfo->key_arg = &item_menu_argtbl[this->key_arg_no];
                            this->view_weapon = SpectolInfo[0];
                            CMenuItemInfoPt->view_chara = this->view_weapon->item_no;
                            this->ModelReadStart(this->view_mode, 1, 1);
                            SetSpectolInfo(NULL, NULL);
                        }
                    }
                    if (this->step == 0) {
                        MenuFormUpdataAttachInfo(MenuSpectolSatusCheckForm,
                                                 &SepectolFusionBeforeAfterCheck, 0, 0,
                                                 save_spectol_fusion_param);
                    }
                    if (this->step == 2) {

                        MENUFORMPARTS_TYPE *index_part;
                        int i;
                        int blink_on;
                        MENUFORMPARTS_TYPE *volume_part;
                        blink_on = 1;
                        if (fusion_blinkcnt_7120 > kBlinkLastOn) {
                            blink_on = 0;
                        }
                        i = 0;
                        do {
                            index_part = BuildUpFormInfoIndex[i];
                            volume_part = BuildUpFormInfoStatusVol[i];
                            if (index_part != NULL && volume_part != NULL) {
                                index_part->rgba[0] = kColorNormal;
                                index_part->rgba[1] = kColorNormal;
                                index_part->rgba[2] = kColorNormal;
                                volume_part->rgba[0] = kColorNormal;
                                volume_part->rgba[1] = kColorNormal;
                                volume_part->rgba[2] = kColorNormal;
                                if (0 < save_spectol_fusion_param[i] && blink_on != 0) {
                                    index_part->rgba[0] = kColorRaisedR;
                                    index_part->rgba[1] = kColorRaisedG;
                                    index_part->rgba[2] = kColorRaisedB;
                                    volume_part->rgba[0] = kColorRaisedR;
                                    volume_part->rgba[1] = kColorRaisedG;
                                    volume_part->rgba[2] = kColorRaisedB;
                                }
                            }
                            i += 1;
                        } while (i < 10);
                    }
                    break;
                case kStateExtended9:
                    if (extend_result == 2 && this->view_mode == 2) {
                        if (this->view_weapon == this->ask_para.item && (this->ask_para.item)->item_no <= 0) {
                            this->ReturnActiveCharaViewMode(0);
                        }
                    }
                    break;
            }
            if (state == kStateSpectolFusion) {
                if (extend_result != 0 && MenuSpectolSatusCheckForm != NULL) {
                    MenuSpectolSatusCheckForm->SetAction(at_5757);
                }
            }
            if (state == kStateSpectolBreak && extend_result != 0) {
                if (MenuSpectolSatusCheckForm != NULL) {
                    MenuSpectolSatusCheckForm->SetAction(at_5757);
                }
                if (MenuSpectolSatusCheckBGFadeForm != NULL) {
                    MenuSpectolSatusCheckBGFadeForm->draw_flag = 0;
                }
                MenuDCMsg[4]->put_centering = 0;
            }
            if (this->mode == 0) {
                CMenuPosDataForm *form = MenuCommonInfo->cursor_form;
                if (form != NULL) {
                    form->draw_flag = 1;
                }
                if (state == kStateSpectolBreak) {
                    if (extend_result == 4 && this->view_mode == 2 &&
                        (void *)this->view_weapon == Save_AskParamInfo_7099) {
                        this->ReturnActiveCharaViewMode(0);
                    }
                }
                if (state == kStateSpectolFusion) {
                    int i = 0;
                    do {
                        MENUFORMPARTS_TYPE *index = BuildUpFormInfoIndex[i];
                        MENUFORMPARTS_TYPE *volume = BuildUpFormInfoStatusVol[i];
                        if (index != NULL && volume != NULL) {
                            index->rgba[0] = kColorNormal;
                            index->rgba[1] = kColorNormal;
                            index->rgba[2] = kColorNormal;
                            volume->rgba[0] = kColorNormal;
                            volume->rgba[1] = kColorNormal;
                            volume->rgba[2] = kColorNormal;
                        }
                        i += 1;
                    } while (i < 10);
                }
            }
            break;
        }
    }
done:
    return 1;
}
void local_item_infoview_set(MENUFORMPARTS_TYPE *part, CGameDataUsed *item) {
    if (part != NULL) {
        part->etc_info[0] = 0;
        part->etc_info[1] = item->item_no;
        part->draw_flag = 1;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemCharaActWepInfoDraw__FP16CMenuPosDataFormP13CGameDataUsedii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemCharaViewCheck__FP10CHARA_DATAii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuPosFormValueSetCharaRobo__FP9ROBO_DATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuPosFormValueSetMonster__FP16MOS_CHANGE_PARAMP10CHARA_DATA);
int CheckBuildUp(CGameDataUsed *weapon, int *result0, int *result1, int *result2) {
    if (weapon != NULL) {
        return weapon->IsBuildUp(result0, result1, result2);
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", BuildUpWeaponTrans__FP13CGameDataUsedi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", BuildUpWeaponNameBoardDraw__FP11mgCDrawPrimffi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuWeaponBuildUpDraw__FRi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuWeaponStatusInfoFormSet__FP13CGameDataUsedP11CDataWeapon);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemSelectDiffer__Fi);
void CMenuItemInfo::CheckLoadItemNo() {
    if (view_mode == 0) {
        SetMenuLoadItemNo(0);
    } else if (view_mode == 1) {
        SetMenuLoadItemNo(1);
    } else if (view_mode == 3) {
        load_item_no = 2;
        if (MenuLoadInfo.unk_4 < 0) {
            MenuLoadInfo.unk_5 = 0;
        } else {
            MenuLoadInfo.unk_5 = MenuLoadInfo.unk_4;
        }
        SetMenuLoadItemNo(load_item_no);
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", ModelReadStart__13CMenuItemInfoFiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", WeaponBuildCheck__13CMenuItemInfoFP12CActionCharaii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", ModelReadEndCheck__13CMenuItemInfoFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", SearchEffectDisplayPosition__13CMenuItemInfoFPiP13CGameDataUsed);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", SetItemEffect__13CMenuItemInfoFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", LRCheck__13CMenuItemInfoFi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemInfoCursorSet__Fi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuCharaStatusDraw__FRi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemInfoCursorDraw__FRi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", KeyStepLocal__13CMenuItemInfoFiii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", KeyStep__13CMenuItemInfoFv);
int MenuItemKey(void) {
    int ret;

    if (!init_8716) {
        old_viewmode_8715 = 0;
        init_8716 = 1;
    }
    if (!init_8719) {
        old_chrid_8718 = 0;
        init_8719 = 1;
    }

    switch (CMenuItemInfoPt->unk_176) {
        case -1: {
            int faded;

            ret = 0;
            faded = CMenuItemInfoPt->FadeCheckMenu();
            switch (CMenuItemInfoPt->unk_178) {
                case 0:
                case 1:
                case 2:
                case 3:
                case 4:
                case 5: {
                    int i;

                    if (!faded) {
                        break;
                    }
                    CMenuItemInfoPt->DeleteTexBlock();
                    MenuItemMemory.stack_used = 0;
                    MenuItemMemory.lock = 0;
                    for (i = 0; i < 3; i++) {
                        CMenuItemInfoPt->chara_poly_form[i]->SetActionCharaPtr(NULL, -1, -1);
                    }

                    old_viewmode_8715 = CMenuItemInfoPt->view_mode;
                    old_chrid_8718 = CMenuItemInfoPt->sub_view;
                    if (CMenuItemInfoPt->unk_178 == 1) {
                        MenuCommonInfo->SetWakuType(-1);
                        MenuMonsterBoxInit(&MenuItemMemory, (int *)&CMenuItemInfoPt->tex_block[0], 0);
                    }
                    if (CMenuItemInfoPt->unk_178 == 0) {
                        SetMenuFrameRate(2);
                        MenuAquaInit(&MenuItemMemory, (int *)&CMenuItemInfoPt->tex_block[0], 0);
                    }
                    if (CMenuItemInfoPt->unk_178 == 2) {
                        NameRegistInit(&MenuItemMemory, (int *)&CMenuItemInfoPt->tex_block[0], 0);
                    }
                    if (CMenuItemInfoPt->unk_178 == 3) {
                        MenuNPCQuestViewInit(&MenuItemMemory, (int *)&CMenuItemInfoPt->tex_block[0],
                                             0);
                    }
                    if (CMenuItemInfoPt->unk_178 == 4) {
                        MenuNPCQuestViewInit(&MenuItemMemory, (int *)&CMenuItemInfoPt->tex_block[0],
                                             1);
                    }
                    if (CMenuItemInfoPt->unk_178 == 5) {
                        MonsterBookInit(&MenuItemMemory, (int *)&CMenuItemInfoPt->tex_block[0], 0);
                    }
                    CMenuItemInfoPt->unk_176 = CMenuItemInfoPt->unk_178;
                    break;
                }
                case -1:
                    if (faded) {
                        ret = CMenuItemInfoPt->KeyStep();
                    } else {
                        MenuPosData->FormStep();
                        CMenuItemInfoPt->CalcTex();
                        CMenuItemInfoPt->CalcCursorPosition();
                    }
                    break;
                default:
                    break;
            }
            return ret;
        }
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            ret = 0;
            if (CMenuItemInfoPt->unk_176 == 0) {
                ret = MenuAquaKey();
            }
            if (CMenuItemInfoPt->unk_176 == 1) {
                ret = MenuMonsterBoxKey();
            }
            if (CMenuItemInfoPt->unk_176 == 2) {
                ret = NameRegistKey();
            }
            if (CMenuItemInfoPt->unk_176 == 3 || CMenuItemInfoPt->unk_176 == 4) {
                ret = MenuNPCQuestViewKey();
            }
            if (CMenuItemInfoPt->unk_176 == 5) {
                ret = MonsterBookKey();
            }
            if (ret == 1) {
                SetMenuFrameRate(1);
                MenuItemMemory.stack_used = 0;
                MenuItemMemory.lock = 0;
                MenuItemMemory2.stack_used = 0;
                MenuItemMemory2.lock = 0;
                CMenuItemInfoPt->MenuModeMalloc(&MenuItemMainMemory);
                {
                    u8 *buffer = (u8*)MenuItemBGDataMemory.stack;
                    LoadFileMenu(at_8819, (u_long128 *)buffer, 1);
                    CMenuItemInfoPt->EnterDataMenu((unsigned int *)buffer);
                }
                if (CMenuItemInfoPt->unk_176 == 1) {
                    MenuPosData->InitDrawList();
                    MenuPosData->FormReLink(at_8820, at_5281);
                    MenuPosData->FormReLink(at_8821, at_8822);
                }
                LoadFileMenu(at_8823, MenuMainTextureReadBuf.stack, 1);
                MenuBaseTextureReEnter();
                {
                    short *system = GetSystemMesBuffer();
                    MenuDCMsg[0]->SetMessData(system, GetMenuMainMessageBuffer());
                }
                MenuDCMsg[0]->msg_change = 1;
                MenuMoveItemPtr->AttachForm();
                AttachMessageForm();
                MenuMainFrameModeSet(2, 0);
                MenuLoadInfo.mode = 0;
                MenuLoadInfo.unk_2 = 0;
                MenuLoadInfo.unk_5 = 0;
                MenuLoadInfo.unk_4 = -1;
                MenuLoadInfo.unk_1 = 0;
                if (!GetMenuLoopType()) {
                    MenuLoadInfo.unk_1 = 1;
                }
                {
                    int chara = CMenuItemInfoPt->GetActiveCharaNo();
                    MenuLoadInfo.unk_3 = chara;
                    if (MenuLoadInfo.unk_3 == 0 || MenuLoadInfo.unk_3 == 1) {
                        MenuLoadInfo.unk_2 = 1;
                    }
                    CMenuItemInfoPt->view_mode = CMenuItemInfoPt->unk_112;
                    if (CMenuItemInfoPt->view_mode == 0) {
                        CMenuItemInfoPt->sub_view = 0;
                    }
                    if (CMenuItemInfoPt->view_mode == 1) {
                        CMenuItemInfoPt->sub_view = 1;
                    }
                    CheckEnableHaveItemNum();
                    MenuMemoryAdjust(&MenuItemMemory, &MenuCharaLoadStack, MenuActionCharaBuffer,
                                     chara);
                }
                CMenuItemInfoPt->ModelReadStart(CMenuItemInfoPt->view_mode, 1, 1);
                if (ReadBGSync()) {
                    do {
                        ReadBG();
                        MenuPosData->FormStep();
                        CMenuItemInfoPt->CalcTex();
                    } while (ReadBGSync());
                }
                CMenuItemInfoPt->ModelReadEndCheck();
                BuildUpWeaponInfo.unk_0 = 0;
                CMenuItemInfoPt->mode = 0;
                CMenuItemInfoPt->unk_178 = -1;
                CMenuItemInfoPt->unk_176 = -1;
                CMenuItemInfoPt->FadeInMenu(0x28, 0.0f);
                CMenuItemInfoPt->unk_13A = 1;
            }
            return 0;
        default:
            return 0;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemDraw__Fv);
void CItemSelect::SetPtrList() {
    CGameDataUsed *entries;
    int i;

    item_num = 0;
    entries = MenuUserParam.used_data;
    for (i = 0; i < kBagSlotCount; i++) {
        if (entries[i].item_no > 0 && !(0 < GetSpectolNo__13CGameDataUsedFv(&entries[i])) &&
            entries[i].used_type != 8) {
            item_list[item_num] = &entries[i];
            limit_disp[item_num] = 0;
            if (((s8 *)menu_limmit_displayflag)[i] == 1) {
                limit_disp[item_num] = 1;
            }
            item_num++;
        }
    }
    for (i = item_num; i < kBagSlotCount; i++) {
        item_list[i] = NULL;
    }
    line_num = (float)(item_num / 5 + 1);
}
CGameDataUsed *CItemSelect::GetExistThisPosData(int pos) {
    if (pos < 0 || item_num < pos) {
        return NULL;
    }
    return item_list[pos];
}
void CItemSelect::CheckUse(CGameDataUsed *item) {
    int i;
    int *use_nos;
    int offset;
    int use_no;

    if (item != NULL) {
        use_nos = &MenuArg.param[1];
        if (MenuArg.param[0] != 0 && MenuArg.param[0] == 1) {

            for (i = 0, offset = 0; i < 10; i++, offset += 4) {
                use_no = *(int *)((u8 *)use_nos + offset);
                if (use_no <= 0) {
                    break;
                }
                if (use_no == item->item_no) {
                    item->DeleteNum(1);
                    break;
                }
            }
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", KeyStep__11CItemSelectFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", Draw__11CItemSelectFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemSelectInit__FP9mgCMemoryPii);
int MenuItemSelectKey(void) {
    int result;

    result = 1;
    if (ItemSelectPtr != NULL) {
        result = ItemSelectPtr->KeyStep();
    }
    return result;
}
void MenuItemSelectDraw(void) {
    int loaded_tex_no = -1;

    u8 *prim = (u8 *)GetMenuPrim();
    *(int *)(prim + 0x110) = 0;
    *(int *)(prim + 0x114) = 0;
    mgRect<int> dest;
    mgRect<int> source;
    source.Set(0, 0, mgScreenWidth / 2, mgScreenHeight / 2);
    dest.Set(0, 0, mgScreenWidth, mgScreenHeight);
    DrawMenuMainFrmImg(loaded_tex_no, dest, source, 128, 128, 128, 128, 1);
    mgRect<int> dest2;
    mgRect<int> source2;
    source2.Set(0, 0, mgScreenWidth / 2, mgScreenHeight / 2);
    dest2.Set(-1, -1, mgScreenWidth + 1, mgScreenHeight + 1);
    DrawMenuMainFrmImg(loaded_tex_no, dest2, source2, 128, 128, 128, ItemSelectPtr->bg_alpha, 0);
    *(int *)(prim + 0x110) = 0;
    *(int *)(prim + 0x114) = 0;
    if (ItemSelectPtr != NULL) {
        ItemSelectPtr->Draw();
    }
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", __sinit_menusys_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", WepStatusInfoStrTable__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", WepStatusInfoStatusVolStrTable__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", addtbl_2178__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_2328__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", n_2667__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", human_tbl_2871__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", padtbl_3359__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", MenuCheckKey__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", focusnametbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3771__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3772__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", item_menu_argtbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", exename_4332__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4350__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4369__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4410__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4414__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4485__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4495__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4509__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", ItemMenuFormNameTbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", local_over_flow_baseposname__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", tbl_4981__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", plist_4982__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", tbl_5293__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5458__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5531__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5534__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5556__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", waku_infotbl_5836__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", wakutypeTbl_5837__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", dbox_path_6083__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", table_6164__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", attrtable_6472__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6480__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", stchar_6508__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", whptbl_7376__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", backboard_table_x_7625__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", mos_repeat_table_x_7694__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", strtbl_7727__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", argtblno_7927__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", sel_7928__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", conv_7932__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", robo_stand_pos_8151__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", effparamtbl_8275__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", status_table_8427__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", xytable_8428__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", xytable_wep_8429__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", draw_tbl_8453__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", imgtbl_8945__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", menu_item_swap_sndtbl__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_919__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_920__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_921__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_922__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_923__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_924__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_925__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_926__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_927__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_928__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_929__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_930__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_931__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_932__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_933__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_934__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_935__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_936__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_937__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_938__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_1462__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_1493__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_2545__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_2546__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_2547__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_2548__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_2549__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_2550__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_2584__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_2585__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_2651__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3316__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3744__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3745__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3746__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3747__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3748__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3749__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3750__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3751__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3774__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3775__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3822__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3823__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3824__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3825__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3826__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3827__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3828__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3829__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3893__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3894__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3895__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_3924__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4333__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4334__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4335__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4659__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4660__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4661__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4662__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4663__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4664__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4665__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4666__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4667__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4668__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4669__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4670__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4671__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4672__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4673__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4674__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4950__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4951__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4952__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4953__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4954__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4955__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4956__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4957__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4958__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4967__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4968__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4969__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4970__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4971__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4972__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4973__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4974__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4975__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4983__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4984__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4985__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5022__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5130__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5131__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5132__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5133__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5134__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5210__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5211__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5259__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5260__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5261__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5262__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5263__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5264__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5265__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5266__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5267__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5268__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5269__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5270__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5271__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5272__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5273__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5274__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5275__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5276__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5277__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5278__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5279__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5280__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5281__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5282__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5283__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5757__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5758__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5759__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5763__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5760__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5879__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5880__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5881__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5882__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5883__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6011__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6012__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6013__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6014__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6015__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6016__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6424__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6473__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6474__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6475__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6476__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6477__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6478__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6479__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6509__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6510__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6511__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6512__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6513__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6514__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6515__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6516__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6517__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6518__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6519__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6520__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6760__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6761__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6762__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6763__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6764__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6765__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6766__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6767__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6768__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6769__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6770__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6771__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6772__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6773__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6774__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6775__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6776__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6777__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6778__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6779__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6780__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6781__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6782__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6783__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6784__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6785__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6786__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6787__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6788__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6789__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6790__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6791__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6792__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6793__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6794__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6795__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6796__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6797__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6798__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6799__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6800__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6801__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6802__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6803__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6804__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6805__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6806__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6807__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6808__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6809__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6810__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6811__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6812__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6813__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6814__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7342__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7343__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7344__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7345__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7346__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7347__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7349__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7348__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7438__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7439__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7440__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7441__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7442__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7443__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7478__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7534__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7535__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7536__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7537__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7538__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7539__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7540__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7541__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7560__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7561__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7562__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7563__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7564__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7728__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7729__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7730__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7731__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7732__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7968__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8083__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8084__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8199__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8201__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8200__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8315__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8421__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8711__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8819__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8820__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8821__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8822__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8823__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8825__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8824__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8869__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8946__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8947__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_8948__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_9032__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_9033__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_9179__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_9215__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_9216__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", D_0037B034__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", __vt__11CItemSelect__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", __vt__13CMenuItemInfo__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", __vt__14CBaseMenuClass__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", MenuRoboEquipTable__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", MenuItemBoardTotalNum__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", MenuItemBoardTotalLine__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", MenuWeaponEnvSetListNo__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_1232__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", wakutbl_1411__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", tartbl_1412__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", trans_spectol_pos__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", trans_spectol_posold__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", trans_spectol_rgb__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", SpectolFramePosValue__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", ret_tbl1_2511__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_2512__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", menu_camera_reference_id__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", menu_camera_reference_no__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", tbl_4094__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", menuitem_initviewtbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", menuitem_initmenumode__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_4469__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", OverFlowFormName__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", itemmenu_calcmode_tbl_5410__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_5563__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", MenuDebugModel_AdjustFlag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_6438__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", backboard_table_y_7626__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", backboard_table_w_7627__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", backboard_x_repeat_drawnum_7628__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", backboard_y_repeat_drawnum_7629__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_7695__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", cnttbl_8130__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", SameviewmodeTable_8406__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menusys", at_9055__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(MainCharaReadStackReadAdr, 0x4);
INCLUDE_BSS(MenuRepairMan, 0x4);
INCLUDE_BSS(MenuItem_ItemBoardTopLine, 0x4);
INCLUDE_BSS(MenuItem_ItemBoardTopSelect, 0x4);
INCLUDE_BSS(menu_chara_activeItem_limmit_check, 0x8);
INCLUDE_BSS(MenuSpectolSatusCheckForm, 0x4);
INCLUDE_BSS(MenuSpectolSatusCheckBGFadeForm, 0x4);
INCLUDE_BSS(TrushMesWindowFlag, 0x4);
INCLUDE_BSS(ActiveMenuWeaponCharaRange, 0x4);
INCLUDE_BSS(MenuWeaponEnvSetChara, 0x4);
INCLUDE_BSS(MenuStatusMode, 0x4);
INCLUDE_BSS(MenuStatusTex, 0x8);
INCLUDE_BSS(MenuItemUseTarget, 0x8);
INCLUDE_BSS(CMenuItemInfoPt, 0x8);
INCLUDE_BSS(MenuEffect, 0x8);
INCLUDE_BSS(MenuItemSpectolTransSoundBuffer, 0x8);
INCLUDE_BSS(SpectolInfo, 0x8);
INCLUDE_BSS(SpectolFusion_LeftOrRight, 0x4);
INCLUDE_BSS(SpectolFusionTargetChara, 0x4);
INCLUDE_BSS(save_spectol_fusion_spstatus, 0x4);
INCLUDE_BSS(MenuItemCmdArgPos, 0x4);
INCLUDE_BSS(MenuItemCommand_RoboPackBreakFlag, 0x4);
INCLUDE_BSS(cmd_counter_1048, 0x4);
INCLUDE_BSS(init_1049, 0x4);
INCLUDE_BSS(MenuItemCommandDir, 0x4);
INCLUDE_BSS(at_1385__2, 0x8);
INCLUDE_BSS(MenuHowHaveMuchNum, 0x4);
INCLUDE_BSS(SpectolBreakNum_Limit, 0x4);
INCLUDE_BSS(SpectolBreakNum, 0x4);
INCLUDE_BSS(SpectolBreakSpPoint, 0x4);
INCLUDE_BSS(at_1545, 0x4);
INCLUDE_BSS(trans_spectol_cnt, 0x4);
INCLUDE_BSS(spegetflag, 0x4);
INCLUDE_BSS(SpectolFrame, 0x4);
INCLUDE_BSS(MenuSpectolTransPos, 0x4);
INCLUDE_BSS(itemmenu_chr_rotflag, 0x4);
INCLUDE_BSS(sndflag_1665, 0x4);
INCLUDE_BSS(init_1666, 0x4);
INCLUDE_BSS(at_1685, 0x8);
INCLUDE_BSS(MenuTrushNum, 0x4);
INCLUDE_BSS(fusion_color_val, 0x4);
INCLUDE_BSS(SpectolFrameScaleAngle, 0x4);
INCLUDE_BSS(SpectolFrameFadeAlpha, 0x4);
INCLUDE_BSS(at_2345__2, 0x8);
INCLUDE_BSS(at_2346__2, 0x8);
INCLUDE_BSS(at_2564, 0x8);
INCLUDE_BSS(at_3791__2, 0x8);
INCLUDE_BSS(count_time_3839, 0x4);
INCLUDE_BSS(init_3840, 0x4);
INCLUDE_BSS(FxScriptManPauseFlag, 0x4);
INCLUDE_BSS(debug_common_data, 0x4);
INCLUDE_BSS(view_weapon_flag, 0x4);
INCLUDE_BSS(OldViewWep, 0x4);
INCLUDE_BSS(NewViewWep, 0x8);
INCLUDE_BSS(MenuRepairTargetWeaponPos, 0x8);
INCLUDE_BSS(at_4365__2, 0x8);
INCLUDE_BSS(Effect_Counter_4682, 0x4);
INCLUDE_BSS(init_4683, 0x4);
INCLUDE_BSS(BuildEndFlag_4703, 0x4);
INCLUDE_BSS(init_4704, 0x4);
INCLUDE_BSS(at_5026, 0x8);
INCLUDE_BSS(Tex_BuildUpBoard, 0x4);
INCLUDE_BSS(Robo_Sound_ID_Save, 0x4);
INCLUDE_BSS(checkmoveFlag_5411, 0x4);
INCLUDE_BSS(init_5412, 0x4);
INCLUDE_BSS(at_5573, 0x4);
INCLUDE_BSS(MenuDebugModelDrawFlag, 0x4);
INCLUDE_BSS(at_5769, 0x8);
INCLUDE_BSS(at_5782, 0x8);
INCLUDE_BSS(at_5829, 0x8);
INCLUDE_BSS(MenuDebugSize, 0x4);
INCLUDE_BSS(MenuDebugItemModel, 0x4);
INCLUDE_BSS(MenuDebugCamera, 0x8);
INCLUDE_BSS(at_6133, 0x8);
INCLUDE_BSS(cnt_6161, 0x4);
INCLUDE_BSS(init_6162, 0x4);
INCLUDE_BSS(at_6176, 0x8);
INCLUDE_BSS(at_6220, 0x8);
INCLUDE_BSS(at_6234, 0x8);
INCLUDE_BSS(at_6256, 0x8);
INCLUDE_BSS(at_6265, 0x8);
INCLUDE_BSS(testcnt_6298, 0x4);
INCLUDE_BSS(init_6299, 0x4);
INCLUDE_BSS(at_7021, 0x4);
INCLUDE_BSS(Save_AskParamInfo_7099, 0x4);
INCLUDE_BSS(fusion_blinkcnt_7120, 0x4);
INCLUDE_BSS(init_7121, 0x4);
INCLUDE_BSS(diffent_weapon_dispflag_7125, 0x4);
INCLUDE_BSS(init_7126, 0x4);
INCLUDE_BSS(WeaponWarningCounter, 0x4);
INCLUDE_BSS(counter_7509, 0x4);
INCLUDE_BSS(init_7510, 0x4);
INCLUDE_BSS(count_7867, 0x4);
INCLUDE_BSS(init_7868, 0x4);
INCLUDE_BSS(MonicaRotationFlag, 0x4);
INCLUDE_BSS(old_viewmode_8715, 0x4);
INCLUDE_BSS(init_8716, 0x4);
INCLUDE_BSS(old_chrid_8718, 0x4);
INCLUDE_BSS(init_8719, 0x4);
INCLUDE_BSS(MenuItemSelectMode, 0x8);
INCLUDE_BSS(at_9093, 0x8);
INCLUDE_BSS(ItemSelectPtr, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(MenuItemCmdRet, 0x20);
INCLUDE_BSS(MenuAskParam, 0xA0);
INCLUDE_BSS(MenuUserParam, 0x20);
INCLUDE_BSS(MainCharaReadStack, 0x30);
INCLUDE_BSS(MainCharaReadBuffer, 0x10);
INCLUDE_BSS(MenuLevelUpMan, 0x190);
INCLUDE_BSS(MenuItemCursorInfo, 0x10);
INCLUDE_BSS(BuildUpFormInfoIndex, 0x30);
INCLUDE_BSS(BuildUpFormInfoStatusVol, 0x30);
INCLUDE_BSS(TrushMesCls, 0x10);
INCLUDE_BSS(MenuItemMainMemory, 0x30);
INCLUDE_BSS(MenuItemBGDataMemory, 0x30);
INCLUDE_BSS(MenuItemMemory, 0x30);
INCLUDE_BSS(MenuItemMemory2, 0x30);
INCLUDE_BSS(MenuCharaLoadStack, 0x30);
INCLUDE_BSS(BuildUpWeaponInfo, 0x50);
INCLUDE_BSS(SpectolInfoStay, 0x70);
INCLUDE_BSS(SepectolFusionBeforeAfterCheck, 0x70);
INCLUDE_BSS(save_spectol_fusion_param, 0x20);
INCLUDE_BSS(SpectolTransBefore, 0x70);
INCLUDE_BSS(at_1557, 0x10);
INCLUDE_BSS(fusion_ambient, 0x10);
INCLUDE_BSS(fusion_color_ang, 0x10);
INCLUDE_BSS(MenuWeaponBasePos, 0x10);
INCLUDE_BSS(at_2333__3, 0x10);
INCLUDE_BSS(at_3407, 0x10);
INCLUDE_BSS(at_3792__2, 0x20);
INCLUDE_BSS(MenuMoveTempGameDataUsed, 0x70);
INCLUDE_BSS(at_4406, 0x20);
INCLUDE_BSS(at_4423__2, 0x10);
INCLUDE_BSS(at_4510, 0x10);
INCLUDE_BSS(at_5532, 0x18);
INCLUDE_BSS(BuildUpNameXY, 0x18);
INCLUDE_BSS(at_5774, 0x30);
INCLUDE_BSS(class_menu_item_info, 0x370);
INCLUDE_BSS(MenuDebugStack, 0x30);
INCLUDE_BSS(at_7650, 0x10);
INCLUDE_BSS(at_7688, 0x10);
INCLUDE_BSS(MonicaRotationData, 0x10);
