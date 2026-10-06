#define MenuEffect MenuEffectUnbounded
const int kMenuAskParamOffset = 0x58;
const int kBaseMenuWord0xF8Offset = 0xF8;
const int kBagSlotCount = 0x96;
#include "dng_main.hpp"
#include "charasetup.hpp"
#include "dynamicanime.hpp"
#include "effscript.hpp"
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
#include "nameregi.hpp"
#include "password.hpp"
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
int GetItemCommandMsg(CGameDataUsed *item, int *cmds, u32 *colors, short *values, short *marks, int type,
                      int arg);
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
struct ScreenPos {
    int x;
    int y;
} __attribute__((aligned(8)));
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
extern ScreenPos at_2564;
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
extern ITEMCMD_RET_PARA MenuItemCmdRet;
extern CDC2Mes *TrushMesCls[4];
extern int FxScriptManPauseFlag;
extern short MenuItemBoardTotalNum;
extern short MenuItemBoardTotalLine;
extern CActionChara *MenuWeaponEnvSetChara;
extern s16 MenuWeaponEnvSetListNo;
extern CMenuItemInfo class_menu_item_info;
void MenuWeaponStatusInfoFormSet(CGameDataUsed *item, CDataWeapon *data);
extern s8 TrushMesWindowFlag;
extern CMenuPosDataForm *MenuSpectolSatusCheckForm;
extern CMenuPosDataForm *MenuSpectolSatusCheckBGFadeForm;
extern CItemSelect *ItemSelectPtr;
extern "C" int GetSpectolNo__13CGameDataUsedFv(CGameDataUsed *self);
extern "C" u8 __vt__14CBaseMenuClass[];
extern "C" float sinf(float);
extern float MenuWeaponBasePos[4];
extern float SpectolFramePosValue;
extern float SpectolFrameFadeAlpha;
extern float SpectolFrameScaleAngle;
extern CActionChara *SpectolFrame;
extern NameList at_1545;
extern signed char MenuRoboEquipTable[8];
extern signed char tbl_4094[2];
extern signed char SameviewmodeTable_8406[4];
extern signed char menuitem_initmenumode[4];
extern char at_5757[];
extern char at_3822[];
extern char at_3823[];
extern char at_3824[];
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
extern int MenuRepairTargetWeaponPos[2];
extern char at_5265[];
extern char at_5271[];
extern char at_7540[];
extern short MenuItem_ItemBoardTopSelect;
extern u32 *MenuItemSpectolTransSoundBuffer;
extern void *Save_AskParamInfo_7099;
extern short SpectolFusion_LeftOrRight;
extern signed char diffent_weapon_dispflag_7125;
extern signed char fusion_blinkcnt_7120;
extern signed char init_7121;
extern signed char init_7126;
extern MENUFORMPARTS_TYPE *BuildUpFormInfoIndex[12];
extern MENUFORMPARTS_TYPE *BuildUpFormInfoStatusVol[10];
extern "C" float at_3407[4];
extern "C" u8 padtbl_3359[16];
extern "C" char at_2545__2[];
extern "C" char at_2546__2[];
extern "C" char at_2584[];
extern "C" char at_2585[];
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
int MenuItemSelectDiffer(int select);
void MenuItemCharaActWepInfoDraw(CMenuPosDataForm *form, CGameDataUsed *equip, int chara_no, int flag);
int MenuAquaKey(void);
int NameRegistKey(void);
int MenuNPCQuestViewKey(void);
void MenuAquaDraw(void);
void NameRegistDraw(void);
void MenuNPCQuestViewDraw(void);
void MenuItemDebugDraw(void);
void MenuItemInfoCursorSet(int mode);
void MenuItemCharaViewCheck(CHARA_DATA *chara, int chara_no, int flag);
void MenuPosFormValueSetCharaRobo(ROBO_DATA *robo, int flag);
void MenuPosFormValueSetMonster(MOS_CHANGE_PARAM *monster, CHARA_DATA *chara);
int CheckFishCondition(void);
extern s8 menu_camera_reference_id;
extern s8 menu_camera_reference_no;

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
int CBaseMenuClass::MenuItemMoveItemCommand(CGameDataUsed *item, int arg_pos, int mes_no, CMenuPosDataForm *form, int chara) {
    if (MenuCommonInfo->have_item.item_no > 0) {
        MenuSePlay(5);
        return 0;
    }
    if (MenuItemCommnadSelectPrepare(item, arg_pos, chara)) {
        MenuItemCmdRet.result = 0;
        MenuItemCmdRet.cmd = -1;
        MenuItemCmdRet.unk_2 = -2;
        MenuItemCmdRet.item2 = NULL;
        MenuItemCmdRet.item = NULL;
        MenuItemCmdRet.unk_A = 0;
        MenuItemCmdRet.item_no = 0;
        mode = MENU_ASK_MODE_ITEM_COMMAND;
        step = 0;
        MENU_ASKMODE_PARA param;
        param.cmd_num = GetItemCommandMsg(item, &param, arg_pos, chara);
        MenuItemCmdArgPos = arg_pos;
        param.mes_no = mes_no;
        param.form = form;
        param.arg0 = chara;
        param.item = item;
        SetAskParam(&param);
        CDC2Mes *message = MenuDCMsg[param.mes_no];
        message->MsgPreset(6);
        message->SetMsgItemNo(param.cmd_msg, 20);
        message->MakeMsg(param.cmd_num);
        message->SetMsgCursor(0);
        message->rows = param.cmd_num;
        for (int i = 0; i < param.cmd_num; i++) {
            if (param.cmd_color[i] == 0x80202020) {
                if (i >= 0 && i < MES_LINE_MAX) {
                    message->line_shade[i] = MES_SHADE_FAINT;
                }
            } else if (i >= 0 && i < MES_LINE_MAX) {
                message->line_shade[i] = MES_SHADE_AUTO;
            }
        }
        param.form->draw_flag = 1;
        if (MenuCommonInfo->cursor_form != NULL) {
            MenuCommonInfo->cursor_form->draw_flag = 0;
        }
        MenuSePlay(19);
        return 1;
    }
    MenuSePlay(5);
    return 0;
}
extern s8 init_1049;
extern s8 cmd_counter_1048;
#ifdef NONMATCHING
int CBaseMenuClass::MenuItemCommandSelect(int select_key, int push_button) {
    CGameDataUsed *used_data = MenuUserParam.used_data;
    CUserDataManager *user = GetUserDataMan();
    MenuItemCmdRet.cmd = -1;
    int decided = 0;
    CDC2Mes *mes = MenuDCMsg[ask_para.mes_no];
    int ret = 0;
    switch (step) {
    case 0: {
        if (init_1049 == 0) {
            init_1049 = 1;
            cmd_counter_1048 = 0;
        }
        cmd_counter_1048++;
        if (cmd_counter_1048 >= 50) {
            cmd_counter_1048 = 0;
        }
        for (int i = 0; i < 16; i++) {
            if (ask_para.cmd_mark[i] == 1) {
                if (i >= 0 && i < MES_LINE_MAX) {
                    mes->line_color[i] = 0x80DC4848;
                }
                if (cmd_counter_1048 >= 26 && i >= 0 && i < MES_LINE_MAX) {
                    mes->line_color[i] = 0x80686A6B;
                }
            }
        }
        int select = -1;
        if (LanguageCode > 0) {
            if (push_button & 1) {
                select = 0;
            } else if (push_button & 2) {
                select = 1;
            }
        } else if (push_button & 0xD) {
            select = 0;
        } else if (push_button & 2) {
            select = 1;
        }
        mes->CommandMsgCursor();
        switch (select) {
        case 0: {
            if (ask_para.item == NULL) {
                break;
            }
            int cursor = mes->GetMsgCursor();
            int cmd = ask_para.cmd_msg[cursor] - 5000;
            int space = user->SearchSpaceUsedData();
            CGameDataUsed *space_item = NULL;
            if (0 <= space && space < GetNowBagMax(0)) {
                space_item = &MenuUserParam.used_data[space];
            }
            MenuItemCmdRet.unk_2 = cmd;
            if (cmd == -1) {
                MenuItemCmdRet.cmd = 5;
            } else if (cmd == 0) {
                MenuItemCmdRet.cmd = 5;
            } else if (cmd == 1) {
                MenuItemCmdRet.cmd = 1;
            } else if (cmd == 2) {
                MenuItemCmdRet.result = -1;
                int item_no = ask_para.item->item_no;
                GetItemDataType(item_no);
                int slot = -1;
                MenuItemCmdRet.chara = IsItemtypeWhoisEquip(item_no, &slot);
                CHARA_DATA *chara = MenuUserParam.chara[MenuItemCmdRet.chara];
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 0x1C;
                    int attribute = MenuUserDataManPtr->GetCharaStatusAttirbute(MenuItemCmdRet.chara);
                    if (attribute & 8) {
                        MenuItemCmdRet.item_no = 2;
                    }
                    if (attribute & 0x20) {
                        MenuItemCmdRet.item_no = 3;
                    }
                    if (attribute & 4) {
                        MenuItemCmdRet.item_no = 1;
                    }
                    break;
                }
                if (ask_para.item->IsFishingRod() && !CheckFishCondition()) {
                    MenuItemCmdRet.cmd = 0x1C;
                    break;
                }
                if (slot < 0) {
                    MenuItemCmdRet.cmd = 0x1C;
                    break;
                }
                MenuItemCmdRet.item2 = &chara->equip[slot];
                GameDataSwap(MenuItemCmdRet.item2, ask_para.item, 1);
                MenuItemCmdRet.cmd = 8;
                MenuItemCmdRet.result = slot;
            } else if (cmd == 10) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 0x1C;
                } else {
                    ROBO_DATA *robo = MenuUserParam.robo;
                    int item_no = ask_para.item->item_no;
                    GetItemDataType(item_no);
                    int slot = -1;
                    MenuItemCmdRet.chara = IsItemtypeWhoisEquip(item_no, &slot);
                    if (MenuItemCmdRet.chara != 2) {
                        MenuItemCmdRet.cmd = 0x1C;
                        break;
                    }
                    if (slot < 0) {
                        MenuItemCmdRet.cmd = 0x1C;
                        break;
                    }
                    MenuItemCmdRet.item2 = &robo->parts[slot];
                    GameDataSwap(MenuItemCmdRet.item2, ask_para.item, 0);
                    MenuItemCmdRet.cmd = 8;
                    MenuItemCmdRet.result = slot;
                }
            } else if (cmd == 3 || cmd == 8) {
                MenuItemCmdRet.cmd = 1;
            } else if (cmd == 4) {
                MenuItemCmdRet.cmd = 5;
                CGameDataUsed *repair = user->SearchAllHaveItem(ask_para.item->GetEnableRepairItemNo());
                if (MenuItemUse.UseItem(repair, 1, ask_para.item) == 0) {
                    MenuItemCmdRet.cmd = 5;
                } else {
                    MenuItemCmdRet.cmd = -1;
                    decided = 1;
                    MenuItemCmdRet.result = 1;
                }
            } else if (cmd == 5) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.result = -1;
                    MenuItemCmdRet.cmd = 0x1C;
                    break;
                }
                CHARA_DATA *chara = MenuUserParam.chara[CMenuItemInfoPt->sub_view];
                int item_no = ask_para.item->item_no;
                if (GetItemInfoData(item_no) == NULL || chara == NULL) {
                    MenuItemCmdRet.cmd = 0x1C;
                    MenuItemCmdRet.result = -1;
                    break;
                }
                int active_slot = user->SearchActiveItemTableSpace(CMenuItemInfoPt->sub_view, item_no);
                MenuItemCmdRet.result = active_slot;
                if (active_slot < 0) {
                    MenuItemCmdRet.cmd = 0x1C;
                } else {
                    MenuItemCmdRet.cmd = 1;
                    MenuItemCmdRet.item = &chara->active_item[active_slot];
                    CGameDataUsed *active = MenuItemCmdRet.item;
                    if (active->item_no == ask_para.item->item_no) {
                        MenuItemCmdRet.unk_A = active->GetActiveSetNum() - active->GetNum();
                        if (ask_para.item->GetNum() > MenuItemCmdRet.unk_A) {
                            MenuItemCmdRet.item_no = 10;
                        }
                    }
                }
            } else if (cmd == 6 || cmd == 7) {
                MenuItemCmdRet.result = space;
                if (space < 0) {
                    MenuItemCmdRet.cmd = 5;
                } else {
                    MenuItemCmdRet.item = &used_data[space];
                    int num = MenuItemCmdRet.item->GetNum();
                    if (num > 0) {
                        MenuItemCmdRet.unk_A = num;
                    }
                    MenuItemCmdRet.cmd = 1;
                }
            } else if (cmd == 9) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 5;
                    break;
                }
                int num = ask_para.item->GetNum();
                if (space_item == NULL) {
                    space_item = ask_para.item;
                }
                MenuItemCmdRet.item = space_item;
                if (space < 0 && num > 100) {
                    MenuItemCmdRet.item = NULL;
                    MenuItemCmdRet.cmd = 5;
                } else {
                    MenuItemCmdRet.cmd = 1;
                }
            } else if (cmd == 11 || cmd == 12 || cmd == 29 || cmd == 47) {
                MenuItemCmdRet.cmd = 1;
            } else if (cmd == 13) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 5;
                    break;
                }
                if (ask_para.item->GetGiftBoxItemNum() > 0) {
                    MenuItemCmdRet.cmd = 1;
                }
            } else if (cmd == 14) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 5;
                } else {
                    MenuItemCmdRet.cmd = 6;
                    user->FishInAquarium(ask_para.item, 0);
                }
            } else if (cmd == 42) {
                ask_para.item->Boiled();
            } else if (cmd == 15 || cmd == 16) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 5;
                    CHARA_DATA *target_chara = NULL;
                    if (cmd == 15) {
                        target_chara = MenuUserParam.chara[0];
                    }
                    if (cmd == 16) {
                        target_chara = MenuUserParam.chara[1];
                    }
                    CItemUseTarget target;
                    target.SetPtr(0, target_chara);
                    MenuUseItemCheckFunc(ask_para.item, &target, 0);
                    if (MenuUsedNotErrorCode == 1) {
                        MenuItemCmdRet.result = 10;
                    }
                } else {
                    MenuItemCmdRet.item_no = ask_para.item->item_no;
                    MenuItemCmdRet.result = MenuItemUse.UseItem(ask_para.item, 0, MenuUserParam.chara[cmd - 15]);
                    if (0 < MenuItemCmdRet.result &&
                        (MenuItemCmdRet.item_no == 0x124 || MenuItemCmdRet.item_no == 0x110)) {
                        MenuItemCmdRet.result = 1;
                    }
                }
            } else if (cmd == 17) {
            } else if (cmd == 18) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 5;
                } else {
                    MenuItemCmdRet.item_no = ask_para.item->item_no;
                    MenuItemCmdRet.result = MenuItemUse.UseItem(ask_para.item, 3, MenuUserParam.monster);
                }
            } else if (cmd == 19 || cmd == 20) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 5;
                } else {
                    MenuItemCmdRet.result = MenuItemUse.UseItem(
                        ask_para.item, 1, &MenuUserParam.chara[CMenuItemInfoPt->sub_view]->equip[cmd - 19]);
                }
            } else if (cmd == 21 || cmd == 22) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 5;
                } else if (ask_para.item != NULL && cmd == 22) {
                    CGameDataUsed *core = MenuUserDataManPtr->SearchItemOnItemBrd(0x17D, 1);
                    if (core != NULL) {
                        MenuItemCmdRet.result = MenuItemUse.UseItem(core, 2, ask_para.item);
                    }
                } else {
                    s8 part_slot[4] = {0, 2, -1, -1};
                    MenuItemCmdRet.result =
                        MenuItemUse.UseItem(ask_para.item, 1, &MenuUserParam.robo->parts[part_slot[cmd - 21]]);
                }
            } else if (cmd == 23) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 5;
                }
            } else if (cmd == 26) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 5;
                } else {
                    MenuItemCmdRet.cmd = 1;
                }
            } else if (cmd == 24 || cmd == 25) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 5;
                } else {
                    MenuItemCmdRet.cmd = 1;
                    CGameDataUsed *esa = user->GetActiveEsa();
                    int esa_no = esa->item_no;
                    MenuItemCmdRet.item2 = NULL;
                    MenuItemCmdRet.item = NULL;
                    if (esa_no > 0) {
                        MenuItemCmdRet.item_no = user->SearchSpaceUsedData(esa_no);
                        MenuItemCmdRet.item = user->SearchSpaceUsedDataPtr(esa_no);
                        if (MenuItemCmdRet.item != NULL) {
                            MenuItemCmdRet.item->CopyDataItem(esa_no);
                        }
                    }
                    esa->CopyDataItem(ask_para.item->item_no);
                    ask_para.item->DeleteNum(1);
                    MenuItemCmdRet.result = GetSameAdrressUserData(ask_para.item, 0);
                    MenuItemCmdRet.item2 = esa;
                }
            } else if (cmd == 27 || cmd == 28 || cmd == 32 || cmd == 33) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 5;
                } else {
                    MenuItemCmdRet.cmd = 1;
                    int rod_no = user->GetFishingRodNo();
                    MenuItemCmdRet.unk_8 = 0;
                    if (user->NowFishingStyle() == 0) {
                        rod_no = ask_para.item->item_no;
                        MenuItemCmdRet.unk_8 = 1;
                    }
                    CGameDataUsed *esa = user->GetActiveEsa(rod_no);
                    MenuItemCmdRet.result = user->SearchSpaceUsedData(esa->item_no);
                    CGameDataUsed *esa_space = user->SearchSpaceUsedDataPtr(esa->item_no);
                    if (MenuItemCmdRet.unk_8 == 1) {
                        if (esa_space != NULL) {
                            if (esa_space->item_no > 0) {
                                esa_space->AddNum(1, 1);
                            } else {
                                user->CopyGameData(esa_space, esa->item_no);
                            }
                            esa->DeleteNum(1);
                        }
                    } else {
                        GameDataSwap(esa, esa_space, 0);
                        MenuItemCmdRet.item2 = esa_space;
                    }
                }
            } else if (cmd == 30) {
                MenuItemCmdRet.item2 = ask_para.item;
            } else if (cmd == 34 || cmd == 35) {
                if (cmd == 34) {
                    user->SetRoboVoiceFlag(1);
                } else {
                    user->SetRoboVoiceFlag(0);
                }
                MenuSePlay(1);
            } else if (cmd == 37) {
                CGameDataUsed *core = MenuUserDataManPtr->SearchItemOnItemBrd(MenuUserDataManPtr->CheckRobotCore(), 1);
                MenuItemCmdRet.result = MenuItemUse.UseItem(ask_para.item, 1, core);
                decided = 1;
            } else if (cmd == 38) {
                decided = 1;
                MenuItemCmdRet.cmd = 1;
            } else if (cmd == 43) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 5;
                } else {
                    MenuItemCmdRet.cmd = 1;
                }
            } else if (cmd == 44) {
                if (ask_para.cmd_color[cursor] == 0x80202020) {
                    MenuItemCmdRet.cmd = 5;
                } else {
                    MenuItemCmdRet.result = 1;
                }
            } else if (cmd == 45) {
                MenuItemCmdRet.cmd = 1;
            } else if (cmd == 46) {
                MenuItemCmdRet.cmd = 1;
            } else {
                MenuItemCmdRet.cmd = 5;
            }
            if (MenuItemCmdRet.cmd != 5 && MenuItemCmdRet.cmd != 0x1C) {
                decided = 1;
                mes->MakeMsg(-100);
            }
            break;
        }
        case 1:
            decided = 1;
            MenuItemCmdRet.cmd = 5;
            MenuItemCmdRet.unk_2 = -1;
            break;
        }
        if (decided) {
            if (MenuCommonInfo->cursor_form != NULL) {
                MenuCommonInfo->cursor_form->draw_flag = 1;
            }
            MenuCommonInfo->SetVibeCnt(60, 30);
            ask_para.form->draw_flag = 0;
            mode = MENU_ASK_MODE_NONE;
        }
        break;
    }
    case 1:
    case 2:
        if (push_button) {
            ret = 1;
        }
        break;
    }
    return ret;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemCommandSelect__14CBaseMenuClassFii);
#endif
extern s8 wakutbl_1411[2];
extern s8 tartbl_1412[2];
#ifdef NONMATCHING
void CBaseMenuClass::SetItemCmdMsgPos(int *item_pos) {
    int pos[2] = {0, 0};
    int width = 0;
    int lines = 0;
    pos[0] = item_pos[0] + 4;
    pos[1] = item_pos[1] + 0x2A;
    int cmd_num = ask_para.cmd_num;
    MenuItemCommandDir = 1;
    CDC2Mes *message = MenuDCMsg[ask_para.mes_no];
    if (message == NULL) {
        return;
    }
    for (int i = 0; i < cmd_num; i++) {
        if (message->item_mes[i] < 0) {
            break;
        }
        int line_width = message->GetMesWidth_system(message->item_mes[i]);
        if (width < line_width) {
            width = line_width;
        }
        lines++;
    }
    int height = message->font_h * lines;
    CMenuPosDataForm *form = ask_para.form;
    CGameDataUsed *item = ask_para.item;
    int fishing_rod = 0;
    if (mode == MENU_ASK_MODE_ITEM_COMMAND) {
        if (item == NULL) {
            return;
        }
        if (form == NULL) {
            return;
        }
        if (item->item_no == 0x130) {
            fishing_rod = 1;
        }
    }
    switch (MenuItemCmdArgPos) {
        case 0:
            if (fishing_rod) {
                pos[0] += 0x3E;
                pos[1] -= 0x1E;
                message->point_x = -0x28;
                message->point_y = 0x12;
            } else {
                message->point_x = 0x1A;
                pos[1] += 0x1E;
            }
            break;
        case 1:
        case 2:
            pos[1] = item_pos[1] - height - 0x14;
            message->point_x = wakutbl_1411[MenuCommonInfo->cursor];
            pos[0] += tartbl_1412[MenuCommonInfo->cursor];
            message->point_y = height * 2;
            break;
        case 3:
        case 4:
        case 9:
            if (fishing_rod) {
                pos[1] -= 0x1E;
                message->point_y = 0x14;
                if (mgScreenWidth - 0x96 < pos[0]) {
                    pos[0] -= width + 0x2E;
                    message->point_x = width + 0x28;
                } else {
                    pos[0] += 0x32;
                    message->point_x = -0x1E;
                }
            } else {
                pos[0] -= 0x12;
                pos[1] += 0x1C;
                if (pos[1] + height >= 0x133) {
                    pos[1] = pos[1] - height - 0x5E;
                    message->point_y = height * 3;
                }
                if (pos[1] < 0x14) {
                    while (item_pos[0] < pos[0] + width + 0x1A) {
                        pos[0] -= 2;
                    }
                    while (pos[1] + height < item_pos[1] + 0x32) {
                        pos[1] += 2;
                    }
                    message->point_x = width + 0x1E;
                    message->point_y = height - 0xE;
                    while (pos[1] < 0x14) {
                        pos[1]++;
                        message->point_y--;
                    }
                    MenuItemCommandDir = 2;
                }
                if (pos[0] + width >= 0x1E5) {
                    pos[0] = 0x1D0 - width;
                    message->point_x = item_pos[0] + 0x1A - pos[0];
                }
            }
            break;
        case 5:
        case 6:
            pos[0] += 0x4A;
            pos[1] -= 0x40;
            message->point_x = -0x28;
            message->point_y = 0x32;
            while (pos[0] + width >= 0x1D7) {
                pos[0] -= width + 0x6A;
                message->point_x += width + 0x6C;
            }
            break;
        case 7:
            message->point_x = 0x14;
            message->point_y = 0x3C;
            pos[0] += 0x3C;
            pos[1] -= 0x78;
            break;
        case 8:
            break;
        case 10:
            pos[1] -= height + 0x40;
            message->point_x = 0x1A;
            message->point_y = height * 2;
            break;
    }
    if (form != NULL) {
        form->x = pos[0];
        form->y = pos[1];
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", SetItemCmdMsgPos__14CBaseMenuClassFPi);
#endif
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
void CBaseMenuClass::MenuItemAskMode_HowMuch(int select_key, int push_button) {
    int ask_mode;
    int end;
    MenuHowMuchNumSelect(select_key, ask_para.item, -1);
    ask_mode = mode;
    end = 0;
    switch (push_button) {
    case MENU_PUSH_BUTTON_TRIANGLE:
    case MENU_PUSH_BUTTON_DECIDE:
    case MENU_PUSH_BUTTON_SQUARE:
        switch (ask_mode) {
        case MENU_ASK_MODE_HOW_MUCH:
            MenuCommonInfo->MenuSwapItem(ask_para.item, &swap_info, MenuHowHaveMuchNum, true);
            MenuSePlay(3);
            break;
        }
        end = 1;
        MenuHowHaveMuchNum = 1;
        break;
    case MENU_PUSH_BUTTON_CANCEL:
        MenuSePlay(5);
        end = 1;
        break;
    }
    if (end) {
        mode = MENU_ASK_MODE_NONE;
        MenuCommonInfo->how_much_form->draw_flag = 0;
        MenuCommonInfo->MenuPosPlay();
    }
    MenuCommonInfo->how_much_form->SetNumber(at_1493__2, MenuHowHaveMuchNum);
}
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
extern int trans_spectol_rgb;
extern s8 spegetflag;
extern s16 MenuSpectolTransPos;
void TransSpectolDataSave(CGameDataUsed *item, int count);
#ifdef NONMATCHING
int CBaseMenuClass::IsSpectolTrans(int select_key, int push_button) {
    int cancel = 0;
    CDC2Mes *message = MenuDCMsg[ask_para.mes_no];
    CMenuPosDataForm *form = MenuMesForm[ask_para.mes_no];
    int result = 0;
    switch (step) {
        case 0:
            message->YesNoCursor();
            switch (push_button) {
                case 1:
                case 4:
                    if (message->GetMsgCursor() == 0) {
                        if (CheckEquipFishRod(ask_para.item) == 1) {
                            MenuSePlay(5);
                        } else {
                            trans_spectol_pos = ask_para.arg0;
                            if (SpectolBreakNum == ask_para.item->GetNum()) {
                                MenuSpectolTransPos = ask_para.arg0;
                            } else {
                                int pos = MenuUserDataManPtr->SearchSpaceUsedData();
                                if (pos < 0) {
                                    MenuSePlay(5);
                                    break;
                                }
                                MenuSpectolTransPos = pos;
                            }
                            trans_spectol_cnt = 0.0f;
                            trans_spectol_rgb = 0x80;
                            step = 1;
                            form->draw_flag = 0;
                            MenuSePlay(1);
                            result = 2;
                            if (MenuCommonInfo->cursor_form != NULL) {
                                MenuCommonInfo->cursor_form->draw_flag = 0;
                            }
                        }
                        break;
                    }
                case 2:
                    cancel = 1;
                    break;
            }
            break;
        case 1: {
            CMenuEffect *effect = MenuEffect[0];
            int effect_type = effect->type;
            if (effect->end) {
                if (effect_type == 18) {
                    TransSpectolDataSave(ask_para.item, SpectolBreakNum);
                    trans_spectol_pos = MenuSpectolTransPos;
                    ask_para.item2 = MenuUserDataManPtr->GetUsedDataPtr(trans_spectol_pos);
                }
                spegetflag = 0;
                if (effect_type == 20) {
                    result = 3;
                    break;
                }
            }
            if (spegetflag == 0 && effect_type == 20) {
                MENU_EFFECT_INFO *info = &MenuEffect[0]->info[111];
                if (info->unk_1c == 1.0f || !(info->unk_18 < 29.0f)) {
                    SpectolTransBefore.ToSpectolTrans(ask_para.item2, -1);
                    spegetflag = 1;
                }
            }
            if (MenuEffect[0]->run == 0) {
                CheckEnableHaveItemNum();
                MenuCommonInfo->FadeInMenuBGMVol(9);
                IsAskEnd(-1, form);
                trans_spectol_cnt = 0.0f;
                trans_spectol_pos = -1;
                if (spegetflag == 0) {
                    SpectolTransBefore.ToSpectolTrans(ask_para.item2, -1);
                }
                spegetflag = 0;
                result = 4;
            }
            break;
        }
        case 10: {
            if (MenuHowMuchNumSelect(select_key, ask_para.item, SpectolBreakNum_Limit)) {
                UpdataInfoSpectolBreakItem(message, ask_para.item, MenuHowHaveMuchNum);
            }
            if (push_button & 1) {
                SpectolBreakNum = MenuHowHaveMuchNum;
                if (MenuUserDataManPtr->SearchSpaceUsedData() < 0 && MenuHowHaveMuchNum < ask_para.item->GetNum()) {
                    MenuSePlay(5);
                } else {
                    MenuCommonInfo->how_much_form->draw_flag = 0;
                    step = 0;
                    if (MenuCommonInfo->cursor_form != NULL) {
                        MenuCommonInfo->cursor_form->draw_flag = 0;
                    }
                    message->MsgPreset(0xB);
                    message->SetAbsPos(0x12);
                    char *name = ask_para.item->GetName(1);
                    if (name != NULL) {
                        strcpy(message->name[0], name);
                    }
                    message->MakeMsg(0xAE);
                    message->SetMsgCursor(1);
                    MenuSePlay(1);
                }
            } else if (push_button & 2) {
                cancel = 1;
            }
            break;
        }
        default:
            return 1;
    }
    if (cancel) {
        MenuCommonInfo->how_much_form->draw_flag = 0;
        form->draw_flag = 0;
        if (MenuCommonInfo->cursor_form != NULL) {
            MenuCommonInfo->cursor_form->draw_flag = 1;
        }
        mode = MENU_ASK_MODE_NONE;
        step = 0;
        MenuSePlay(5);
        result = 1;
    }
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", IsSpectolTrans__14CBaseMenuClassFii);
#endif
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
        menu->ItemCmdAfter(result, &MenuItemCmdRet);
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
extern float addtbl_2178[4];
extern float fusion_color_val;
extern float fusion_ambient[4];
extern float fusion_color_ang[4];
void FusionColor(int type, int step, float *color) {
    if (type == 1) {
        fusion_ambient[0] = 128.0f + fusion_color_val * sinf(fusion_color_ang[0]);
        fusion_ambient[1] = 128.0f + fusion_color_val * sinf(fusion_color_ang[1]);
        fusion_ambient[2] = 128.0f + fusion_color_val * sinf(fusion_color_ang[2]);
        fusion_ambient[3] = 128.0f * (1.0f + 0.02f * sinf(fusion_color_ang[3]));
        fusion_color_val -= 0.38f;
        if (fusion_color_val < 0.0f) {
            fusion_color_val = 0.0f;
        }
        for (int i = 0; i < 4; i++) {
            fusion_color_ang[i] += addtbl_2178[i];
            fusion_color_ang[i] = mgAngleLimit(fusion_color_ang[i]);
        }
    } else {
        fusion_color_ang[0] = 0.0f;
        fusion_color_val = 86.0f;
        fusion_ambient[0] = 64.0f;
        fusion_ambient[3] = 128.0f;
        fusion_ambient[1] = 64.0f;
        fusion_ambient[2] = 64.0f;
        fusion_color_ang[3] = 0.0f;
        fusion_color_ang[1] = 2.0943952f + fusion_color_ang[0];
        fusion_color_ang[2] = 2.0943952f + fusion_color_ang[1];
    }
    if (step != 0) {
        *(u_long128 *)color = *(u_long128 *)fusion_ambient;
    }
}
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
#pragma divbyzerocheck on
int MenuGlidKeyCheck(int select_key, int *pos, int *top_line, int *size, int *disp, int *limit, int max) {
    int result = 0;
    int moved[2] = {0, 0};
    int step[2] = {0, 0};
    if (select_key & MENU_SELECT_KEY_UP) {
        step[0] -= size[1];
    } else if (select_key & MENU_SELECT_KEY_DOWN) {
        step[0] += size[1];
    }
    if (select_key & MENU_SELECT_KEY_LEFT) {
        step[1] -= 1;
    } else if (select_key & MENU_SELECT_KEY_RIGHT) {
        step[1] += 1;
    }
    if (step[0] < 0) {
        if (limit[0] == 0) {
            moved[0] = CalcMenuAdd2(pos, step[0], 0);
        }
        if (limit[1] == 1) {
            while (*pos + disp[1] * 2 < max) {
                *pos += disp[1];
            }
        }
    }
    if (step[0] > 0) {
        if (limit[1] == 0) {
            moved[0] = CalcMenuAdd2(pos, step[0], size[0] * size[1] - 1);
        }
        if (limit[1] == 1) {
            while (0 < *pos - disp[1] * 2) {
                *pos -= disp[1];
            }
        }
    }
    if (step[0] != 0 && moved[0] == 0) {
        moved[0] = 1;
    }
    int line = *pos / size[1];
    MenuCheckLine(top_line, line, disp[0]);
    if (step[1] < 0) {
        if (limit[2] == 0) {
            moved[1] = CalcMenuAdd2(pos, step[1], line * size[1]);
        }
        if (limit[2] == 2) {
            moved[1] = CalcMenuAdd2(pos, step[1], line * size[1]);
            if (moved[1] > 0) {
                result = 2;
            }
        }
    }
    if (step[1] > 0) {
        if (limit[3] == 0) {
            moved[1] = CalcMenuAdd2(pos, step[1], (line + 1) * size[1] - 1);
        }
        if (limit[3] == 2) {
            moved[1] = CalcMenuAdd2(pos, step[1], (line + 1) * size[1] - 1);
            if (moved[1] > 0) {
                result = 2;
            }
        }
    }
    return result;
}
#pragma divbyzerocheck reset
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
extern s8 ret_tbl1_2511[2];
#ifdef NONMATCHING
int MenuDataSwap(CGameDataUsed *destination, CGameDataUsed *source, int quantity) {
    if (destination == NULL || source == NULL) {
        return 0;
    }
    int dst_no = destination->item_no;
    s8 result = 1;
    int src_no = source->item_no;
    int dst_type = GetItemDataType__Fi(dst_no);
    int src_type = GetItemDataType__Fi(src_no);
    int dst_used = destination->used_type;
    int src_used = source->used_type;
    CDataCommon *dst_common = GetCommonItemData(dst_no);
    CDataCommon *src_common = GetCommonItemData(src_no);
    if (dst_used == USED_ITEM_TYPE_GIFT_BOX && destination->GetGiftBoxItemNum() < 3 && src_common != NULL &&
        (src_common->attribute & ITEM_ATTRIBUTE_TRUSH) &&
        ((src_used == USED_ITEM_TYPE_ITEM && src_type != 0x1D && src_type != 0x1E && src_type != 0x15 &&
          src_type != 0x1A && src_type != 0x1B) ||
         (src_used == USED_ITEM_TYPE_ATTACH && src_type != 0x11 && src_type != 0x22))) {
        result = 4;
        if (destination->SetGiftBoxItem(src_no, -1) >= 0) {
            source->DeleteNum(1);
            result = 4;
        }
    } else if (dst_type == 0x1D && src_used == USED_ITEM_TYPE_FISH) {
        MenuUserDataManPtr->FishInAquarium(source, 0);
        result = 7;
    } else if (destination == MenuUserDataManPtr->GetActiveEsa()) {
        result = 1;
        if (destination->GetNum() <= 0) {
            destination->CopyDataItem(src_no);
            source->DeleteNum(1);
        } else if (source->CopyDataItem(destination) == 0) {
            result = 0;
        }
    } else if (destination->CheckTypeEnableStack() && destination->GetNum() >= 2 && src_used == 0) {
        memcpy(source, destination, sizeof(CGameDataUsed));
        source->AddNum(-destination->GetNum(), 0);
        source->AddNum(quantity, 1);
        destination->AddNum(-quantity, 1);
    } else if (source->CheckTypeEnableStack() && source->GetNum() > 0 && dst_no == src_no) {
        int add = source->GetNum();
        while (dst_common->stack_num < add + destination->GetNum()) {
            add--;
        }
        if (add == 0) {
            GameDataSwap(destination, source, 1);
        } else {
            destination->AddNum(add, 1);
            source->AddNum(-add, 1);
        }
        result = 5;
    } else {
        int had_dst = 0;
        int had_src = 0;
        GameDataSwap(destination, source, 1);
        if (dst_no > 0) {
            had_dst = 1;
        }
        if (src_no > 0) {
            had_src = 1;
        }
        s8 results[2] = {0, 2};
        results[0] = ret_tbl1_2511[had_src];
        result = results[had_dst];
    }
    CheckEnableHaveItemNum();
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuDataSwap__FP13CGameDataUsedP13CGameDataUsedi);
#endif
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
#ifdef NONMATCHING
int CMenuKeyFunc::MenuPosStep(int *pos, int *offset) {
    ScreenPos waku_pos;
    int end;
    if (waku_form != NULL) {
        waku_form->SetNextMovePos(pos, 2);
        waku_form->GetNextMovePos(&waku_pos.x);
    }
    ScreenPos next = at_2564;
    int put[2];
    next = waku_pos;
    if (offset != NULL) {
        next.x += offset[0];
        next.y += offset[1];
    }
    cursor_form->SetNextMovePos(&next.x, 2);
    end = cursor_form->CheckMoveEnd(next.x, next.y);
    cursor_form->GetPutPosXY(at_2545__2, put[0], put[1]);
    CMenuPosDataForm *form = how_much_form;
    if (form != NULL) {
        form->x = put[0] + 10;
        form->y = put[1] + 40;
    }
    if (have_item.item_no > 0) {
        SetHaveItemInfo(1, 0);
    }
    how_much_form->SetPartRGBA(at_2584, 0x60, 0x60, 0x60, 0x80);
    how_much_form->SetPartRGBA(at_2585, 0x60, 0x60, 0x60, 0x80);
    if (0 < up_arrow_cnt) {
        how_much_form->SetPartRGBA(at_2584, 0x80, 0x80, 0x80, 0x80);
        up_arrow_cnt--;
    }
    if (0 < down_arrow_cnt) {
        how_much_form->SetPartRGBA(at_2585, 0x80, 0x80, 0x80, 0x80);
        down_arrow_cnt--;
    }
    return end;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuPosStep__12CMenuKeyFuncFPiPi);
#endif
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
#ifdef NONMATCHING
int CMenuKeyFunc::EnableSwapNowPos(MENU_SWAPITEM_INFO *swap) {
    ROBO_DATA *robo = NULL;
    CHARA_DATA *chara = NULL;
    s16 held_no = have_item.item_no;
    int result = 0;
    s16 held_used = have_item.used_type;
    CDataCommon *common = GameItemDataManage.GetCommonData(held_no);
    s16 chara_no = swap->chara;
    int data_type = GetItemDataType__Fi(held_no);
    switch (chara_no) {
        case 0:
        case 1:
            chara = MenuUserParam.chara[chara_no];
            break;
        case 2:
            robo = MenuUserParam.robo;
            break;
    }
    switch (swap->type) {
        case 0:
            if (common != NULL && common->active_set == 0) {
                result = 1;
            } else {
                if (chara == NULL || swap->no < 0 || swap->no >= 4) {
                    return 9;
                }
                CGameDataUsed *active = &chara->active_item[swap->no];
                if (active == NULL || CheckItemEquip(chara_no, held_no) == 0) {
                    return 9;
                }
                int num = active->GetNum();
                if (common == NULL) {
                    if (num >= 2) {
                        result = 4;
                    }
                } else if (held_no != active->item_no) {
                    result = 0;
                }
            }
            break;
        case 1:
            if (held_used != 0 && (held_used == 2 || (u32)(held_used - 5) < 3 || held_used == 4)) {
                result = 1;
                break;
            }
            if (chara == NULL) {
                return 9;
            }
            if (chara->status_attr & CHARA_STATUS_UNK_4) {
                result = 8;
            } else if (chara->status_attr & CHARA_STATUS_UNK_8) {
                result = 8;
            } else if (chara->status_attr & CHARA_STATUS_UNK_20) {
                result = 8;
            } else {
                result = 9;
                if (held_used != 0) {
                    if (data_type == SearchEquipType(chara_no, swap->no)) {
                        result = 0;
                        if (have_item.IsFishingRod() && !CheckFishCondition()) {
                            return 9;
                        }
                    } else {
                        result = 1;
                        if (MenuItemUse.CheckItemUseEnable(&have_item, 1, &chara->equip[swap->no])) {
                            result = 5;
                        }
                    }
                }
            }
            break;
        case 2:
            if (held_used != 0 && held_used != 5) {
                result = 1;
                if (held_used != 1) {
                    break;
                }
            }
            if (robo == NULL) {
                return 9;
            }
            if (held_used != 1) {
                result = 9;
                if (held_used != 0) {
                    result = 3;
                    if (data_type == SearchEquipType(2, swap->no)) {
                        result = 0;
                        if (!IsEnableChangeRoboParts(&have_item)) {
                            result = 3;
                        }
                    }
                }
            } else {
                result = 1;
                if (MenuItemUse.CheckItemUseEnable(&have_item, 1, &robo->parts[swap->no])) {
                    result = 5;
                }
            }
            break;
        case 3:
        case 4:
        case 9: {
            CGameDataUsed *used = &MenuUserParam.used_data[swap->no];
            if (used == NULL) {
                return 9;
            }
            s16 used_type = used->used_type;
            result = 0;
            if (MenuItemUse.CheckItemUseEnable(&have_item, 1, used)) {
                result = 5;
            } else if (used_type != USED_ITEM_TYPE_GIFT_BOX && used->CheckTypeEnableStack()) {
                int num = used->GetNum();
                if (held_used == 0 && num >= 2) {
                    result = 4;
                }
            }
            break;
        }
        case 10: {
            CGameDataUsed *esa = GetUserDataMan()->GetActiveEsa();
            if (esa == NULL) {
                return 9;
            }
            if (common == NULL) {
                result = 0;
            } else if (common->type != 0x20 && !(common->attribute & 4)) {
                result = 9;
            } else {
                result = 0;
                if (have_item.GetNum() >= 2 && esa->GetNum() > 0 && have_item.item_no != esa->item_no) {
                    result = 9;
                }
                int rod_no = GetUserDataMan()->GetFishingRodNo();
                if (rod_no == 0x12F && (common->attribute & 4)) {
                    result = 9;
                }
                if (rod_no == 0x12E && common->type == 0x20) {
                    return 9;
                }
            }
            break;
        }
    }
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", EnableSwapNowPos__12CMenuKeyFuncFP18MENU_SWAPITEM_INFO);
#endif
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
    return GetItemCommandMsg(item, param->cmd_msg, param->cmd_color, param->unk_48, param->cmd_mark, slot, arg);
}
extern s8 human_tbl_2871[5][2];
int GetItemCommandMsg(CGameDataUsed *item, int *cmds, u32 *colors, short *values, short *marks, int type,
                      int arg) {
    int item_no = item->item_no;
    int num = GetMenuCommandMsg(item_no, cmds);
    MenuUserDataManPtr->GetNowPartyMember();
    CDataCommon *common = GetCommonItemData(item_no);
    int human = 1;
    if (item_no == 0x184 || item_no == 0x185) {
        human = 0;
    }
    int robo_parts = 0;
    if (0 < GetUserItemHaveNum(0x180) && (item->used_type == 5 || item->used_type == 3)) {
        robo_parts = 1;
    }
    int i = 0;
    int esa_cmd = 0;
    switch (type) {
    case 1:
        for (; i < num; i++) {
            if (cmds[i] == 0x138A || cmds[i] == 0x1391 || cmds[i] == 0x1389 || cmds[i] == 0x13A2) {
                local_sort1(i, &num, cmds);
            }
        }
        esa_cmd = 1;
        break;
    case 0:
        for (; i < num; i++) {
            if (cmds[i] == 0x138D) {
                cmds[i] = 0x138F;
            }
            if (cmds[i] == 0x1391) {
                local_sort1(i, &num, cmds);
            }
            if (cmds[i] == 0x13A0) {
                local_sort1(i, &num, cmds);
            }
            if (arg < 2 && cmds[i] >= 0x1397 && cmds[i] <= 0x1398) {
                cmds[i] = human_tbl_2871[arg][0] + 5000;
                i++;
                cmds[i] = human_tbl_2871[arg][1] + 5000;
            }
        }
        break;
    case 2:
        for (; i < num; i++) {
            if (cmds[i] == 0x1391 || cmds[i] == 0x1389 || cmds[i] == 0x1392 || cmds[i] == 0x13A2) {
                local_sort1(i, &num, cmds);
            }
        }
        break;
    case 3:
        while (i < num) {
            if (arg != 2 && human && cmds[i] >= 0x1397 && cmds[i] <= 0x1398) {
                cmds[i] = human_tbl_2871[arg][0] + 5000;
                i++;
                cmds[i] = human_tbl_2871[arg][1] + 5000;
            }
            if (item->item_type == 15 && cmds[i] == 0x139E) {
                local_sort1(i, &num, cmds);
            } else if (cmds[i] == 0x13A2 && !robo_parts) {
                local_sort1(i, &num, cmds);
            } else {
                i++;
            }
        }
        esa_cmd = 1;
        break;
    case 4:
    case 9: {
        for (; i < num; i++) {
            if (cmds[i] != 0x1396 && cmds[i] != 0x1389) {
                cmds[i] = -1;
            }
        }
        int count = 0;
        for (i = 0; i < num; i++) {
            if (0 <= cmds[i]) {
                cmds[count++] = cmds[i];
            }
        }
        num = count;
        break;
    }
    case 7:
        cmds[0] = 0x139F;
        cmds[1] = -1;
        num = 1;
        break;
    case 10:
        cmds[0] = 0x13A3;
        if (MenuUserDataManPtr->GetFishingRodNo() == 0x12F) {
            cmds[0] = 0x13A4;
        }
        cmds[1] = 0x1389;
        num = 2;
        cmds[2] = -1;
        break;
    }
    DNG_BATTLE_AREA *battle_area = &GetMainScene()->battle_area;
    int bit_ctrl = GetSaveData()->GetBitCtrl();
    if (esa_cmd) {
        CGameDataUsed *rod_esa = MenuUserDataManPtr->GetActiveEsa(item->item_no);
        if (item->IsFishingRod() && rod_esa != NULL && rod_esa->item_no > 0) {
            if (item->item_no == 0x12E) {
                cmds[num] = 0x13A3;
                num++;
                cmds[num] = -1;
            }
            if (item->item_no == 0x12F) {
                cmds[num] = 0x13A4;
                num++;
                cmds[num] = -1;
            }
        }
    }
    int space = MenuUserDataManPtr->SearchSpaceUsedData();
    MenuUserDataManPtr->SearchSpaceUsedData(item_no);
    CGameDataUsed *repair_item = MenuUserDataManPtr->SearchAllHaveItem(item->GetEnableRepairItemNo());
    MenuItemCommand_RoboPackBreakFlag = 0;
    int robo_change = IsEnableChangeRoboParts(item);
    int build_num;
    int build_up = CheckBuildUp(item, &build_num, NULL, NULL);
    GameItemDataManage.GetWeaponData(item_no);
    CGameDataUsed *esa = MenuUserDataManPtr->GetActiveEsa();
    int esa_no = 0;
    if (MenuUserDataManPtr->SearchEquip(0, 0x12E)) {
        int bait = 0;
        if (common->attribute & 4) {
            bait = 1;
        }
        esa_no = esa->item_no;
        if (esa != item && MenuCommonInfo->now_mode == 2 && bait == 1 && type != 0) {
            for (int k = num - 1; k >= 0; k--) {
                cmds[k + 1] = cmds[k];
            }
            cmds[0] = 0x13A0;
            num++;
        }
    }
    if (common->type == 0x20 && !MenuUserDataManPtr->SearchEquip(0, 0x12F)) {
        i = 0;
        local_sort1(i, &num, cmds);
    }
    int fishing_ng = 0;
    if (item->IsFishingRod() && !CheckFishCondition()) {
        fishing_ng = 1;
    }
    int aquarium_item = 0;
    if (MenuUserDataManPtr->SearchItemOnItemBrd(0x135, 0)) {
        aquarium_item = 1;
    }
    int aquarium_space = 0;
    if (0 <= MenuUserDataManPtr->aquarium.SearchAqua1NotUsed(0)) {
        aquarium_space = 1;
    }
    int item_166 = 0;
    if (MenuUserDataManPtr->SearchItemOnItemBrd(0x166, 0)) {
        item_166 = 1;
    }
    int flag_1a8 = 0;
    if (CheckBitFlagMenu(0x1A8)) {
        flag_1a8 = 1;
    }
    int trush_ok = 1;
    if (CheckFishingWeapon(item) == 1) {
        if (CheckTrushWeapon(item) == NULL) {
            trush_ok = 0;
        }
    } else {
        trush_ok = IsDispTrushCommand(item);
    }
    if (CheckTrushMenu() || CheckItemOver() || CheckItemLimmitOver()) {
        robo_parts = 0;
    }
    int robo_member = 0;
    if (MenuUserDataManPtr->GetNowPartyMember() & 4) {
        robo_member = 1;
    }
    int voice_unit = 0;
    int voice_on = 0;
    if (MenuUserDataManPtr->CheckVoiceUnit()) {
        voice_unit = 1;
        if (MenuUserDataManPtr->CheckRoboVoiceFlag()) {
            voice_on = 1;
        }
    }
    int floor_flag = 0;
    if (battle_area->floor_status & 4) {
        floor_flag = 1;
    }
    int trush_ng = 0;
    int spectol_ng = 0;
    if (item_no == 9 && CheckBitFlagMenu(0x138) == 1 && CheckBitFlagMenu(0x13D) == 0) {
        trush_ng = 1;
        spectol_ng = trush_ng;
    }
    if ((common->attribute & 0x40) && GetUserItemHaveNum(item_no) > 1) {
        cmds[num] = 0x1389;
        num++;
    }
    i = 0;
    while (i < num) {
        if (cmds[i] == 0x1397 || cmds[i] == 0x1398) {
            int chara_no = cmds[i] - 0x1397;
            if (arg == 3 && chara_no == 1) {
                chara_no = 3;
                cmds[i] = 0x139A;
            }
            if (IsCheckParty(chara_no)) {
                if (chara_no < 2) {
                    CHARA_DATA *chara = MenuUserParam.chara[chara_no];
                    if (chara != NULL) {
                        if (!MenuItemUse.CheckItemUseEnable(item, 0, chara)) {
                            colors[i] = 0x80202020;
                        }
                        if (item_no == 0x11F && !(chara->status_attr & 8)) {
                            colors[i] = 0x80202020;
                        }
                    }
                } else if (!MenuItemUse.CheckItemUseEnable(item, 3, MenuUserParam.monster)) {
                    colors[i] = 0x80202020;
                }
            } else {
                local_sort1(i, &num, cmds);
                continue;
            }
        }
        if (cmds[i] == 0x138A) {
            int who = IsItemtypeWhoisEquip(item_no, NULL);
            if (!IsCheckParty(who)) {
                local_sort1(i, &num, cmds);
                continue;
            }
            if (fishing_ng) {
                colors[i] = 0x80202020;
            } else {
                CHARA_DATA *chara = MenuUserParam.chara[who];
                if (chara->status_attr & 4) {
                    colors[i] = 0x80202020;
                }
                if (chara->status_attr & 8) {
                    colors[i] = 0x80202020;
                }
                if (chara->status_attr & 0x20) {
                    colors[i] = 0x80202020;
                }
            }
        }
        if (cmds[i] == 0x138D) {
            if (common->active_set == 0 || arg == 2 || arg == 3 || CMenuItemInfoPt->view_mode == 2) {
                local_sort1(i, &num, cmds);
                continue;
            }
            if (arg == 0 || arg == 1) {
                if (!CheckItemEquip(arg, item_no)) {
                    local_sort1(i, &num, cmds);
                    continue;
                }
                if (MenuUserDataManPtr->SearchActiveItemTableSpace(arg, item_no) < 0) {
                    colors[i] = 0x80202020;
                }
            }
        }
        if (cmds[i] == 0x1391) {
            if (!item->IsSpectolTrans() || !trush_ok || spectol_ng || OmakeFlag == 1) {
                local_sort1(i, &num, cmds);
                continue;
            }
            if (space < 0 && item->GetNum() > 100) {
                colors[i] = 0x80202020;
            }
        }
        if ((cmds[i] == 0x138E || cmds[i] == 0x138F) && space < 0) {
            colors[i] = 0x80202020;
        }
        if (cmds[i] == 0x1392) {
            if (!IsCheckParty(2)) {
                local_sort1(i, &num, cmds);
                continue;
            }
            if (!robo_change) {
                colors[i] = 0x80202020;
            }
        }
        if (cmds[i] == 0x139F) {
            if (build_num <= 0 || OmakeFlag == 1) {
                local_sort1(i, &num, cmds);
                continue;
            }
            if (build_up > 0) {
                marks[i] = 1;
            }
        }
        if (cmds[i] == 0x138C && (!item->IsRepair() || repair_item == NULL)) {
            colors[i] = 0x80202020;
        }
        if (cmds[i] == 0x1395) {
            colors[i] = 0x80202020;
            int stackable = 0;
            int empty = 0;
            for (int k = 0; k < 3; k++) {
                int gift_no = item->GetGiftBoxItemNo(k);
                CGameDataUsed *slot = MenuUserDataManPtr->SearchSpaceUsedDataPtr(gift_no);
                if (slot != NULL && slot->CheckStackRemain() > 0) {
                    stackable++;
                }
                if (gift_no <= 0) {
                    empty++;
                }
            }
            if (0 < stackable || 0 <= space) {
                colors[i] = 0x80303030;
            }
            if (empty >= 3) {
                colors[i] = 0x80202020;
            }
        }
        if (cmds[i] == 0x1396) {
            if (!aquarium_item) {
                local_sort1(i, &num, cmds);
                continue;
            }
            if (!aquarium_space) {
                colors[i] = 0x80202020;
            }
        }
        if (cmds[i] == 0x13B2 && !item_166) {
            local_sort1(i, &num, cmds);
            continue;
        }
        if (cmds[i] == 0x139B || cmds[i] == 0x139C) {
            if (arg < 2) {
                CGameDataUsed *equip = &MenuUserParam.chara[arg]->equip[cmds[i] - 0x139B];
                if (item_no == 0x127) {
                    if (equip->IsLevelUp() || equip->IsFishingRod()) {
                        colors[i] = 0x80202020;
                    }
                } else if (item_no != equip->GetEnableRepairItemNo()) {
                    local_sort1(i, &num, cmds);
                    i--;
                } else {
                    if (equip == NULL) {
                        colors[i] = 0x80202020;
                    }
                    if (equip != NULL && !equip->IsRepair()) {
                        colors[i] = 0x80202020;
                    }
                }
            } else if (arg == 2) {
                if (cmds[i] == 0x139C) {
                    local_sort1(i, &num, cmds);
                    continue;
                }
                if (item_no == 0x127) {
                    local_sort1(i, &num, cmds);
                    continue;
                }
                cmds[i] = 0x139D;
                if (repair_item == NULL || !MenuUserParam.robo->parts[0].IsRepair() || !robo_member) {
                    colors[i] = 0x80202020;
                }
            } else {
                colors[i] = 0x80202020;
            }
        }
        if (cmds[i] == 0x139E && (repair_item == NULL || 1.0f <= MenuUserParam.robo->AddPoint(0.0f) ||
                                  floor_flag == 1)) {
            colors[i] = 0x80202020;
        }
        if (cmds[i] == 0x13A2 && !robo_parts) {
            colors[i] = 0x80202020;
        }
        if (cmds[i] == 0x13A0 || cmds[i] == 0x13A1) {
            if (esa == NULL) {
                colors[i] = 0x80202020;
            } else if (esa_no == item->item_no) {
                colors[i] = 0x80202020;
            } else if (0 < esa_no && MenuUserDataManPtr->SearchSpaceUsedDataPtr(esa_no) == NULL) {
                colors[i] = 0x80202020;
            }
        }
        if ((cmds[i] == 0x13A3 || cmds[i] == 0x13A4 || cmds[i] == 0x13A8 || cmds[i] == 0x13A9) &&
            MenuUserDataManPtr->SearchSpaceUsedData(esa_no) < 0) {
            colors[i] = 0x80202020;
        }
        if (cmds[i] == 0x1389 && (!item->IsTrush() || !trush_ok || trush_ng)) {
            local_sort1(i, &num, cmds);
        }
        if (cmds[i] == 0x138B && item->item_type == 11 && !robo_member) {
            local_sort1(i, &num, cmds);
        }
        if (cmds[i] == 0x13AA) {
            if (!voice_unit) {
                local_sort1(i, &num, cmds);
                continue;
            }
            if (voice_on == 1) {
                cmds[i] = 0x13AB;
            }
        }
        if (cmds[i] == 0x13B3) {
            if (GetMenuLoopType() == 0) {
                colors[i] = 0x80202020;
            }
            if ((bit_ctrl & 1) || (bit_ctrl & 1)) {
                colors[i] = 0x80202020;
            }
            if (0 < MenuUserDataManPtr->GetNumStackOverBoard()) {
                colors[i] = 0x80202020;
            }
        }
        if (cmds[i] == 0x13B4) {
            if (GetMenuLoopType() == 0) {
                colors[i] = 0x80202020;
            } else {
                DNG_BATTLE_AREA *battle = (DNG_BATTLE_AREA *)menu_GetBattleAreaScene();
                if (battle != NULL && !(battle->floor_status & 1) && !(battle->floor_status & 2) &&
                    !(battle->floor_status & 4)) {
                    colors[i] = 0x80202020;
                }
            }
        }
        if (cmds[i] == 0x13B5 && !flag_1a8) {
            local_sort1(i, &num, cmds);
            continue;
        }
        i++;
    }
    return num;
}
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
int MenuDataSwap(CGameDataUsed *destination, CGameDataUsed *source, int quantity);
int CMenuKeyFunc::MenuSwapItem(CGameDataUsed *item, MENU_SWAPITEM_INFO *swap, int quantity, bool flag) {
    if (item == NULL) {
        return 0;
    }
    int result = MenuDataSwap(item, &have_item, quantity);
    if (have_swap.flag == 0) {
        have_swap.flag = swap->flag;
        have_swap.type = swap->type;
        have_swap.no = swap->no;
        have_swap.chara = swap->chara;
        have_swap.flag = 1;
    }
    if (have_item.item_no <= 0) {
        SetHaveItemInfo(0, 1);
        have_swap.flag = 0;
    } else {
        SetHaveItemInfo(1, 1);
    }
    if (item->item_no <= 0) {
        item->Init();
    }
    return result;
}
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
int CMenuKeyFunc::ReturnItemMenu(int hide) {
    if (have_item.item_no <= 0) {
        return 0;
    }
    CGameDataUsed *target = GetGameDataUsedForSWAPINFO(&have_swap);
    if (target == NULL) {
        return 0;
    }
    CUserDataManager *manager = GetUserDataMan();
    if (have_swap.type == 0) {
        CDataCommon *common = GameItemDataManage.GetCommonData(have_item.item_no);
        if (common != NULL && common->active_set == 0) {
            have_swap.type = 3;
            have_swap.no = manager->SearchSpaceUsedData();
            if (have_swap.no < 0) {
                return 0;
            }
            target = GetGameDataUsedForSWAPINFO(&have_swap);
        }
    }
    int result = MenuDataSwap(target, &have_item, have_item.GetNum());
    if (have_item.item_no <= 0 || have_item.used_type == 0) {
        InitHaveData();
    }
    if (have_item.item_no <= 0) {
        SetHaveItemInfo(0, 1);
    } else {
        SetHaveItemInfo(1, 1);
    }
    if (hide != 0) {
        SetHaveItemInfo(0, 1);
        if (have_item.item_no > 0) {
            return_item = 1;
        }
    }
    return result;
}
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
#pragma divbyzerocheck on
int CMenuKeyFunc::menu_inputkey_limmit_check_glid(int select_key) {
    int x;
    int y;
    int columns;
    int rows;
    int disp_columns;
    int disp_lines;
    int result;
    int *pos = &cursor;
    MENU_INPUTKEY_ARG *arg = key_arg;
    int i;
    int *axis_pos;
    int *top_line;
    int *axis_disp;
    int *axis_max;
    int ret;

    result = -1;
    columns = arg->columns;
    rows = arg->rows;
    disp_columns = arg->disp_columns;
    disp_lines = arg->disp_lines;
    for (i = 0; i < 4 && result < 0; i++) {
        if (select_key & MenuCheckKey[i]) {
            x = *pos % arg->columns;
            y = *pos / arg->columns;
            top_line = NULL;
            axis_pos = &x;
            axis_disp = &disp_columns;
            axis_max = &columns;
            if (i < 2) {
                top_line = pos + 1;
                axis_pos = &y;
                axis_disp = &disp_lines;
                axis_max = &rows;
            }
            ret = MenuKeySelectCheck(arg->step[i], axis_pos, top_line, arg->min, *axis_max, *axis_disp, arg->limit[i]);
            *pos = x + y * arg->columns;
            if (ret == 3) {
                result = arg->exit_no[i];
                break;
            }
        }
    }
    return result;
}
#pragma divbyzerocheck reset
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
#ifdef NONMATCHING
void CheckEnableHaveItemNum(void) {
    CGameData *item_data = &GameItemDataManage;
    CUserDataManager *user_data = GetUserDataMan();
    int have_num[512];
    s16 full[512];
    memset(have_num, 0, sizeof(have_num));
    memset(full, 0, sizeof(full));
    CGameDataUsed *used = user_data->GetUsedDataPtr(0);
    int bag_max = GetNowBagMax(1);
    int i;
    for (i = 0; i < bag_max; i++, used++) {
        s16 item_no = used->item_no;
        if (item_no > 0) {
            have_num[item_no] += used->GetNum();
            if (0 < used->GetGiftBoxItemNum()) {
                for (int j = 0; j < 3; j++) {
                    int gift_no = used->GetGiftBoxItemNo(j);
                    if (gift_no > 0) {
                        have_num[gift_no]++;
                    }
                }
            }
        }
    }
    CHARA_DATA *chara = user_data->GetCharaDataPtr(0);
    for (int c = 0; c < 2; c++, chara++) {
        for (int k = 0; k < 3; k++) {
            CGameDataUsed *active = &chara->active_item[k];
            s16 item_no = active->item_no;
            if (item_no > 0) {
                have_num[item_no] += active->GetNum();
                if (0 < active->GetGiftBoxItemNum()) {
                    for (int j = 0; j < 3; j++) {
                        int gift_no = active->GetGiftBoxItemNo(j);
                        if (gift_no > 0) {
                            have_num[gift_no]++;
                        }
                    }
                }
            }
        }
    }
    for (i = 1; i < item_data->max_item_no; i++) {
        CDataCommon *common = item_data->GetCommonData(i);
        if (common != NULL && have_num[i] >= common->max_num) {
            full[i] = 1;
        }
    }
    used = user_data->GetUsedDataPtr(0);
    for (i = 0; i < bag_max; i++, used++) {
        menu_limmit_displayflag[i] = 0;
        if (used->item_no > 0 && full[used->item_no] != 0) {
            menu_limmit_displayflag[i] = 1;
        }
    }
    chara = user_data->GetCharaDataPtr(0);
    for (int c = 0; c < 2; c++, chara++) {
        for (int k = 0; k < 3; k++) {
            menu_chara_activeItem_limmit_check[c * 3 + k] = 0;
            s16 item_no = chara->active_item[k].item_no;
            if (item_no > 0 && full[item_no] != 0) {
                menu_chara_activeItem_limmit_check[c * 3 + k] = 1;
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", CheckEnableHaveItemNum__Fv);
#endif
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
extern char at_3825[];
extern char at_3826[];
extern char at_3827[];
extern char at_3828[];
extern char *WepStatusInfoStatusVolStrTable[10];
void MenuPosFormValueSetWeapon(CGameDataUsed *item) {
    if (item != NULL && item->item_no > 0) {
        s16 type = item->used_type;
        if (type != USED_ITEM_TYPE_ITEM && type != USED_ITEM_TYPE_UNK_4 && type != USED_ITEM_TYPE_GIFT_BOX &&
            type != USED_ITEM_TYPE_ATTACH) {
            CMenuPosDataForm *form;
            int fusion_point = 0;
            form = CMenuItemInfoPt->view_form[2];
            float rates[2] = {0.0f, 0.0f};
            s16 values[12] = {0};
            float max;
            float now;
            if (type == USED_ITEM_TYPE_WEAPON) {
                WEAPON_USED *weapon = &item->data.weapon;
                max = weapon->whp.max;
                now = weapon->whp.now;
                rates[0] = weapon->whp.GetRate();
                rates[1] = weapon->abs.GetRate();
                fusion_point = weapon->fusion_point;
            } else if (type == USED_ITEM_TYPE_ROBO_PART) {
                ROBOPART_USED *robo_part = &item->data.robopart;
                max = robo_part->gage1.max;
                now = robo_part->gage1.now;
                rates[0] = robo_part->gage1.GetRate();
            }
            item->GetStatusParam(values, MenuMainScene->time);
            MENUFORMPARTS_TYPE *part = form->GetPartInfo(at_3822);
            if (part != NULL) {
                part->w = (int)(94.0f * rates[0]);
                part->draw_flag = 1;
            }
            form->SetNumber(at_3823, GetDispVolumeForFloat(now));
            form->SetNumber(at_3824, (int)max);
            form->SetPartDrawFlag(at_3825, true);
            form->SetPartDrawFlag(at_3826, true);
            form->SetPartDrawFlag(at_3823, true);
            form->SetPartDrawFlag(at_3824, true);
            form->SetPartDrawFlag(at_3827, true);
            part = form->GetPartInfo(at_3828);
            if (part != NULL) {
                part->w = (int)(94.0f * rates[1]);
            }
            form->SetNumber(WepStatusInfoStatusVolStrTable[0], values[0]);
            form->SetNumber(WepStatusInfoStatusVolStrTable[1], values[1]);
            for (int i = 0; i < 8; i++) {
                form->SetNumber(WepStatusInfoStatusVolStrTable[i + 2], values[i + 2]);
            }
            form->SetNumber(at_3829, fusion_point);
        }
    }
}
extern char at_3893[];
extern char at_3894[];
extern char at_3895[];
extern char *WepStatusInfoStrTable[10];
extern s8 count_time_3839;
extern s8 init_3840;
void MenuFormUpdataAttachInfo(CMenuPosDataForm *form, CGameDataUsed *item, int item_no, int reset, s16 *before) {
    s16 param[10];
    int raised[10];
    int i;
    if (form == NULL || item == NULL) {
        return;
    }
    s16 type = item->used_type;
    if (type == USED_ITEM_TYPE_ATTACH || type == USED_ITEM_TYPE_WEAPON) {
        form->SetAction(at_3893);
        if (!init_3840) {
            count_time_3839 = 0;
            init_3840 = 1;
        }
        count_time_3839++;
        if (count_time_3839 > 59) {
            count_time_3839 = 0;
        }
        if (reset) {
            count_time_3839 = 0;
        }
        item->GetStatusParam(param);
        for (i = 0; i < 10; i++) {
            raised[i] = 0;
            if (before == NULL) {
                if (0 < param[i]) {
                    raised[i] = 1;
                }
            } else {
                if (0 < before[i] && 0 < param[i]) {
                    raised[i] = 1;
                }
                if (count_time_3839 >= 25) {
                    raised[i] = 0;
                }
            }
        }
        form->SetPartDrawFlag(WepStatusInfoStatusVolStrTable[0], true);
        form->SetPartDrawFlag(at_3894, false);
        if ((s8)item->data.attach.spectol_type == SPECTOL_TYPE_WEAPON) {
            form->SetPartDrawFlag(at_3894, true);
            form->SetPartDrawFlag(WepStatusInfoStatusVolStrTable[0], false);
        }
        for (i = 0; i < 10; i++) {
            char *vol_name = WepStatusInfoStatusVolStrTable[i];
            form->SetNumber(vol_name, param[i]);
            if (before != NULL && raised[i] == 0) {
                form->SetNumber(vol_name, param[i] - before[i]);
            }
            form->SetPartRGBA(WepStatusInfoStrTable[i], kColorNormal, kColorNormal, kColorNormal, 0x80);
            form->SetPartRGBA(vol_name, kColorNormal, kColorNormal, kColorNormal, 0x80);
            if (raised[i]) {
                form->SetPartRGBA(WepStatusInfoStrTable[i], kColorRaisedR, kColorRaisedG, kColorRaisedB, 0x80);
                form->SetPartRGBA(vol_name, kColorRaisedR, kColorRaisedG, kColorRaisedB, 0x80);
            }
        }
        MENUFORMPARTS_TYPE *part = form->GetPartInfo(at_3895);
        if (part != NULL) {
            part->draw_flag = 1;
            part->etc_info[0] = 0;
            if (item_no == 0xB9) {
                part->draw_flag = 0;
            } else {
                part->etc_info[1] = item_no;
                part->etc_info[2] = 0;
            }
        }
    }
}
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
    sub_menu = -1;
    next_sub_menu = -1;
    build_up_chara = NULL;
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
#ifdef NONMATCHING
int CMenuItemInfo::CheckEquipListNo(int check) {
    int chara = GetActiveCharaNo();
    int changed = 0;
    if (chara < 2) {
        CGameDataUsed *equip = MenuUserParam.chara[chara]->equip;
        if (check == 0) {
            for (int i = 0; i < 2; equip++, i++) {
                if (equip_flag[i] || equip_list[i] != equip->item_no) {
                    changed = 1;
                    equip_flag[i] = 1;
                }
            }
        } else if (check == 1) {
            for (int i = 0; i < 5; equip++, i++) {
                if (equip_flag[i] || equip_list[i] != equip->item_no) {
                    changed = 1;
                    equip_flag[i] = 1;
                }
            }
        }
        if (chara == 1 && equip_flag[0]) {
            CBattleCharaInfo *info = GetBattleCharaInfo();
            if (info != NULL) {
                info->ClearMagicSwordPow();
            }
        }
    } else if (chara == 2) {
        CGameDataUsed *part = MenuUserParam.robo->parts;
        for (int i = 0; i < 4; part++, i++) {
            if (equip_flag[i] || equip_list[i] != part->item_no) {
                changed = 1;
                equip_flag[i] = 1;
            }
        }
        if (equip_flag[4] || MenuUserParam.chara[0]->equip[4].item_no != equip_list[4]) {
            changed = 1;
            equip_flag[4] = 1;
        }
        if (equip_flag[5] || MenuUserParam.chara[0]->equip[2].item_no != equip_list[5]) {
            changed = 1;
            equip_flag[5] = 1;
        }
    }
    return changed;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", CheckEquipListNo__13CMenuItemInfoFi);
#endif
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
CGameDataUsed *CMenuItemInfo::SearchNowPosItemExist() {
    int cursor = MenuCommonInfo->cursor;
    CHARA_DATA *chara = MenuUserParam.chara[sub_view];
    CGameDataUsed *item = NULL;
    if (key_arg_no == 2) {
        item = &MenuUserParam.used_data[cursor];
        if (menu_debug_flag != 0) {
            debug_item.Init();
            MenuUserDataManPtr->CopyGameData(&debug_item, debug_item_no);
            item = &debug_item;
        }
    } else if (key_arg_no == 0) {
        item = &chara->active_item[cursor];
    } else if (key_arg_no == 1) {
        item = &chara->equip[cursor];
    } else if (key_arg_no == 7) {
        item = &MenuUserParam.robo->parts[tbl_4094[cursor]];
    } else if (key_arg_no == 4) {
        item = view_weapon;
    } else if (key_arg_no == 9) {
        item = view_weapon;
    } else if (key_arg_no == 11) {
        item = MenuUserDataManPtr->GetActiveEsa();
    }
    return item;
}
void CMenuItemInfo::IsCancelNoneLoadItem() {
    MENU_SWAPITEM_INFO swap;
    swap.Set(-1, 0, -1, 0);
    memcpy(&swap, &MenuCommonInfo->have_swap, sizeof(swap));
    swap.flag = 0;
    CGameDataUsed *target = GetGameDataUsedForSWAPINFO(&swap);
    CGameDataUsed previous_item;
    CGameDataUsed carried_item;
    previous_item.CopyGameData(target);
    carried_item.CopyGameData(&MenuCommonInfo->have_item);
    CheckViewWeaponStatus(1);
    int result = MenuCommonInfo->ReturnItemMenu(1);
    if (0 < result) {
        target->CopyGameData(&previous_item);
        MenuCommonInfo->have_item.CopyGameData(&carried_item);
        int equipped = 0;
        if ((view_mode == 0 && swap.chara == 0) ||
            (view_mode == 1 && swap.chara == 1) ||
            (view_mode == 3 && load_item_no == swap.chara)) {
            equipped = 1;
        }
        int movement[2][4];
        if (ExchangeItemInfoMake(&swap, movement, 0, equipped) != 0) {
            CommonSetMoveItemClass(movement);
        }
        MenuSePlay(menu_item_swap_sndtbl[result]);
    } else {
        ReturnActiveCharaViewMode(0);
        MenuSePlay(5);
    }
}
int CMenuItemInfo::IsCancelLoadItem() {
    int result = 1;
    if (GetItemDataType(MenuCommonInfo->have_item.item_no) == 0) {
        if (ReturnActiveCharaViewMode(0) == 0) {
            result = 2;
        }
        MenuSePlay(5);
    } else {
        MENU_SWAPITEM_INFO *source = &MenuCommonInfo->have_swap;
        int needs_load = 0;
        int ridepod = 0;
        if (source->type == 1 || source->type == 2) {
            needs_load = 1;
        }
        int slot = source->no;
        if (source->type == 2) {
            ridepod = 1;
        }
        MENU_SWAPITEM_INFO swap;
        swap.Set(-1, 0, -1, 0);
        memcpy(&swap, &MenuCommonInfo->have_swap, sizeof(swap));
        swap.flag = 0;
        CGameDataUsed *target = GetGameDataUsedForSWAPINFO(&swap);
        CGameDataUsed previous_item;
        CGameDataUsed carried_item;
        previous_item.CopyGameData(target);
        carried_item.CopyGameData(&MenuCommonInfo->have_item);
        CheckViewWeaponStatus(1);
        if (0 < MenuCommonInfo->ReturnItemMenu(1)) {
            CheckLoadItemNo();
            MenuCommonInfo->SetHaveItemInfo(0, 1);
            target->CopyGameData(&previous_item);
            MenuCommonInfo->have_item.CopyGameData(&carried_item);
            if (needs_load != 0) {
                MenuLoadInfo.unk_2 = 0;
                if (ridepod == 0) {
                    CheckLoadInfo(sub_view);
                    MenuLoadInfo.unk_4 = ConvertCharaLoadDataPhase(sub_view, slot);
                    MenuLoadInfo.unk_5 = MenuLoadInfo.unk_4;
                } else if (ridepod == 1) {
                    CheckLoadInfo(2);
                    MenuLoadInfo.unk_4 = ConvertCharaLoadDataPhase(2, slot);
                }
                ModelReadStart(view_mode, 0, 1);
                MenuSePlay(8);
            } else {
                MenuSePlay(4);
            }
            int equipped = 0;
            if ((view_mode == 0 && swap.chara == 0) ||
                (view_mode == 1 && swap.chara == 1) ||
                (view_mode == 3 && load_item_no == swap.chara)) {
                equipped = 1;
            }
            int movement[2][4];
            if (ExchangeItemInfoMake(&swap, movement, 0, equipped) != 0) {
                CommonSetMoveItemClass(movement);
            }
            result = 3;
        }
    }
    return result;
}
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
int CMenuItemInfo::ReturnActiveCharaViewMode(int mode) {
    int active_character = GetActiveCharaNo();
    if ((view_mode == 0 && active_character == 0) ||
        (view_mode == 1 && active_character == 1) ||
        (view_mode != 0 && view_mode == unk_112)) {
        return 0;
    }
    if (unk_112 == 0 || unk_112 == 1) {
        sub_view = active_character;
    }
    if (unk_112 == 3) {
        MenuActionChara[5]->Initialize(NULL);
    }
    MenuCommonInfo->cursor = 0;
    key_arg_no = menuitem_initmenumode[active_character];
    view_mode = unk_112;
    MenuCommonInfo->key_arg = &item_menu_argtbl[key_arg_no];
    MenuLoadInfo.unk_2 = 1;
    MenuLoadInfo.unk_5 = 0;
    MenuLoadInfo.unk_4 = -1;
    CheckLoadInfo(active_character);
    MenuLoadInfo.unk_6[1] = 1;
    MenuMemoryAdjust(&MenuItemMemory, &MenuCharaLoadStack, MenuActionCharaBuffer, active_character);
    ModelReadStart(view_mode, 1, 1);
    return 1;
}
void CMenuItemInfo::NextModeBuildUpInfo(CGameDataUsed *weapon) {
    char *names[4];
    BUILDUP_WEAPON_INFO *info = &BuildUpWeaponInfo;
    info->weapon = weapon;
    info->build_up = CheckBuildUp(info->weapon, &info->select_num, info->weapon_no, info->enable);
    if (info->select_num <= 0) {
        MenuSePlay(5);
        return;
    }
    info->mode = 1;
    info->select_no = 0;
    char *hatena = GetHatena();
    CDC2Mes *msg = MenuDCMsg[6];
    msg->MsgPreset(2);
    msg->fuchi = 5;
    names[0] = GetItemMessage(info->weapon->item_no);
    for (int i = 0; i < info->select_num; i++) {
        int weapon_no = info->weapon_no[i];
        info->weapon_data[i] = GetWeaponInfoData(weapon_no);
        msg->SetItemMes(i + 1, weapon_no);
        names[i + 1] = GetItemMessage(weapon_no);
        if (!info->enable[i]) {
            names[i + 1] = hatena;
            msg->SetItemMes(i + 1, 0);
        }
    }
    msg->SetMsgItemNo(names, info->select_num + 1);
    msg->MakeMsg(0xB5);
    msg->StepMsg();
    mode = MENU_ASK_MODE_EXTEND;
    step = 0;
    ask_para.unk_70 = 2;
    if (MenuCommonInfo->cursor_form != NULL) {
        MenuCommonInfo->cursor_form->draw_flag = 1;
    }
    MenuSePlay(1);
}
#ifdef NONMATCHING
int CMenuItemInfo::EquipDirect(int chara, CGameDataUsed *item, int &slot) {
    CGameDataUsed *target;
    s16 item_no = item->item_no;
    int data_type = GetItemDataType__Fi(item_no);
    int chara_no = chara;
    if (item->IsFishingRod() && !CheckFishCondition()) {
        return 0;
    }
    int who = IsItemtypeWhoisEquip(item_no, &slot);
    int status = MenuUserDataManPtr->GetCharaStatusAttirbute(chara);
    if ((status & CHARA_STATUS_UNK_4) || (status & CHARA_STATUS_UNK_8) || (status & CHARA_STATUS_UNK_20)) {
        return 0;
    }
    int robo_slot4 = 0;
    int robo_slot2 = 0;
    if (view_mode == 3 && data_type == 5) {
        robo_slot4 = 1;
    }
    if (view_mode == 3 && data_type == 6) {
        robo_slot2 = 1;
    }
    if (view_mode == 0 && who != 0) {
        slot = -1;
    }
    if (view_mode == 1 && who != 1) {
        slot = -1;
    }
    if (view_mode == 3) {
        if (who != 2) {
            slot = -1;
        }
        if (robo_slot4 == 1) {
            chara = 0;
            slot = 4;
        }
        if (robo_slot2 == 1) {
            chara = 0;
            slot = 2;
        }
    }
    if (slot < 0) {
        return 0;
    }
    MENU_SWAPITEM_INFO swap;
    swap.Set(1, slot, chara_no, 0);
    if (chara < 2) {
        target = &MenuUserParam.chara[chara_no]->equip[slot];
        swap.type = 1;
        if (robo_slot4 == 1) {
            slot = 1;
            target = &MenuUserParam.chara[0]->equip[4];
            swap.type = 2;
        }
        if (robo_slot2 == 1) {
            slot = 1;
            target = &MenuUserParam.chara[0]->equip[2];
            swap.type = 2;
        }
    } else if (chara == 2) {
        if (IsEnableChangeRoboParts(&MenuCommonInfo->have_item) == 1) {
            swap.type = 2;
            target = &MenuUserParam.robo->parts[slot];
        } else {
            return 0;
        }
    }
    return MenuCommonInfo->MenuSwapItem(target, &swap, 1, true) != 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", EquipDirect__13CMenuItemInfoFiP13CGameDataUsedRi);
#endif
void CMenuItemInfo::CheckLoadInfo(int chara) {
    if (CheckEquipListNo(1) && chara == GetActiveCharaNo()) {
        MenuLoadInfo.unk_6[1] = 1;
        if (chara == 0 || chara == 1) {
            s16 weapon_no = MenuUserParam.chara[GetActiveCharaNo()]->equip[1].item_no;
            if (load_weapon_no != weapon_no) {
                sound_load = 1;
            }
        }
        if (chara == 2 && load_weapon_no != MenuUserParam.robo->parts[0].item_no) {
            sound_load = 1;
        }
    } else {
        MenuLoadInfo.unk_6[1] = 0;
    }
}
extern CGameDataUsed MenuMoveTempGameDataUsed;
extern char *exename_4332[4];
extern char at_4659[];
extern char at_4660[];
extern char at_4661[];
extern char at_4662[];
extern char at_4663[];
extern char at_4664[];
extern char at_4665[];
extern char at_4666[];
extern char at_4667[];
extern char at_4668[];
extern char at_4669[];
extern char at_4670[];
extern char at_4671[];
extern char at_4673[];
int CMenuItemInfo::ItemCmdAfter(int cmd_ret, ITEMCMD_RET_PARA *ret) {
    switch (step) {
    case 0: {
        if (ret->unk_2 < -1) {
            break;
        }
        int mes_no = ask_para.mes_no;
        MenuSePlay(ret->cmd);
        mgCMemory *load_stack = &MenuCharaLoadStack;
        int cursor = MenuCommonInfo->cursor;
        switch (ret->unk_2) {
        case 1:
            SetPreCmdTrush(this, mes_no, ask_para.item, MenuMesForm[mes_no]);
            if (MenuCommonInfo->cursor_form != NULL) {
                MenuCommonInfo->cursor_form->draw_flag = 0;
            }
            break;
        case 2:
            if (MenuItemCmdRet.result < 0) {
                if (MenuItemCmdRet.item_no > 0) {
                    ExeScript(exename_4332[MenuItemCmdRet.item_no]);
                    step = 1;
                }
                break;
            }
            if (view_mode == 2 || view_mode == 5) {
                view_chara = view_weapon->item_no;
                if (view_chara == 0x12E || view_chara == 0x12F) {
                    view_mode = 5;
                } else {
                    view_mode = 2;
                }
                ModelReadStart(view_mode, 1, 1);
            }
            if ((view_mode == 0 && ret->chara == 0) || (view_mode == 1 && ret->chara == 1)) {
                CheckLoadInfo(ret->chara);
                MenuLoadInfo.unk_4 = ConvertCharaLoadDataPhase(sub_view, ret->result);
                MenuLoadInfo.unk_5 = MenuLoadInfo.unk_4;
                MenuLoadInfo.unk_2 = 0;
                ModelReadStart(view_mode, 1, 1);
                GameDataSwap(ret->item2, ask_para.item, 0);
                int movement[2][4] = {{0, 0, 1, 0}, {1, 0, 0, 0}};
                movement[0][1] = ret->chara;
                movement[0][3] = ret->result;
                movement[1][3] = cursor;
                CommonSetMoveItemClass(movement);
                SetEquipListNo(GetActiveCharaNo());
            }
            if (view_mode == 3 && ret->chara == 0 &&
                (ask_para.item->item_type == 5 || ask_para.item->item_type == 6)) {
                CheckLoadInfo(2);
                MenuLoadInfo.unk_4 = 2;
                MenuLoadInfo.unk_5 = 2;
                MenuLoadInfo.unk_2 = 0;
                ModelReadStart(view_mode, 1, 1);
            }
            break;
        case 10:
            if (ret->cmd == 5 || ret->cmd == 0x1C) {
                if (MenuItemCommand_RoboPackBreakFlag == 1) {
                    ExeScript(at_4659);
                    step = 1;
                }
                if (MenuItemCommand_RoboPackBreakFlag == 2) {
                    ExeScript(at_4660);
                    char *name[2] = {NULL};
                    name[0] = ask_para.item->GetName(1);
                    MenuDCMsg[7]->SetMsgItemNo(name, 20);
                    step = 1;
                }
                break;
            }
            if (view_mode == 3) {
                CheckLoadInfo(2);
                MenuLoadInfo.unk_4 = ConvertCharaLoadDataPhase(2, ret->result);
                MenuLoadInfo.unk_5 = MenuLoadInfo.unk_4;
                MenuLoadInfo.unk_2 = 0;
                ModelReadStart(view_mode, 1, 1);
                GameDataSwap(ret->item2, ask_para.item, 0);
                int movement[2][4] = {{0, 0, 1, 0}, {1, 0, 0, 0}};
                movement[0][1] = ret->chara;
                movement[0][3] = ret->result;
                movement[1][3] = cursor;
                CommonSetMoveItemClass(movement);
                SetEquipListNo(GetActiveCharaNo());
            }
            if (view_mode == 2) {
                view_chara = view_weapon->item_no;
                view_mode = 2;
                ModelReadStart(view_mode, 1, 1);
            }
            break;
        case 3:
        case 8: {
            int data_type = GetItemDataType(ask_para.item->item_no);
            int read = 1;
            if ((data_type > 0 && data_type <= 4) || data_type == 13) {
                view_weapon = ask_para.item;
                view_chara = ask_para.item->item_no;
                view_mode = 2;
                key_arg_no = 4;
                MenuCommonInfo->cursor = 0;
                if (view_weapon->IsFishingRod()) {
                    view_mode = 5;
                    key_arg_no = 9;
                }
            } else if ((data_type >= 16 && data_type <= 18) || data_type == 34) {
                MenuFormUpdataAttachInfo(MenuSpectolSatusCheckForm, ask_para.item, ask_para.item->item_no, 1, NULL);
                read = 0;
                unk_198 = 1;
            } else if (view_mode == 3) {
                read = 0;
            } else {
                MenuCommonInfo->cursor = 0;
                view_mode = 3;
                key_arg_no = 6;
                MenuLoadInfo.unk_4 = -1;
                MenuLoadInfo.unk_2 = 0;
                MenuLoadInfo.unk_5 = 0;
                CheckLoadInfo(2);
                MenuMemoryAdjust(&MenuItemMemory, load_stack, MenuActionCharaBuffer, 2);
                MenuActionChara[5]->Initialize(NULL);
            }
            if (read) {
                MenuCommonInfo->key_arg = &item_menu_argtbl[key_arg_no];
                ModelReadStart(view_mode, 1, 1);
            }
            break;
        }
        case 4:
        case 19:
        case 20:
        case 21:
        case 22:
            if (MenuItemCmdRet.result == 1) {
                CheckEnableHaveItemNum();
                SetItemEffect();
            }
            break;
        case 5:
            if (0 <= ret->result && ((view_mode != 4 && view_mode != 3) || sub_view == 1)) {
                int move_type = 1;
                if (ret->item_no == 10) {
                    memcpy(&MenuMoveTempGameDataUsed, ask_para.item, sizeof(CGameDataUsed));
                    ask_para.item->DeleteNum(ret->unk_A);
                    MenuMoveTempGameDataUsed.DeleteNum(ask_para.item->GetNum());
                    move_type = 3;
                }
                int movement[2][4] = {{0}};
                movement[0][1] = sub_view;
                movement[0][3] = ret->result;
                movement[1][0] = move_type;
                movement[1][3] = cursor;
                CommonSetMoveItemClass(movement);
            }
            break;
        case 7:
            if (ret->result >= 0) {
                int movement[2][4] = {{1, 0, 0, 0}, {0, 0, 0, 0}};
                movement[0][3] = ret->result;
                movement[1][1] = sub_view;
                movement[1][3] = cursor;
                CommonSetMoveItemClass(movement);
            }
            break;
        case 6:
            if (ret->result >= 0) {
                int movement[2][4] = {{1, 0, 0, 0}, {0, 0, 1, 0}};
                movement[0][3] = ret->result;
                movement[1][1] = sub_view;
                movement[1][3] = cursor;
                CommonSetMoveItemClass(movement);
            }
            MenuItemCharaDataLoadEndCheckAfter(MenuCharaBuild2, sub_view);
            break;
        case 9:
            if (ret->cmd == 1) {
                SetPreCmdSpectolBreak(this, 4, MenuMesForm[4], ask_para.item, ret->item);
                step = 10;
                CDC2Mes *mes = MenuDCMsg[4];
                CGameDataUsed spectol;
                ask_para.item->ToSpectolTrans(&spectol, SpectolBreakNum);
                if (ask_para.item->used_type == 3) {
                    SpectolBreakSpPoint = ask_para.item->data.weapon.fusion_point;
                } else {
                    SpectolBreakSpPoint = 1;
                }
                if (SpectolBreakNum_Limit > 1) {
                    MenuHowHaveMuchNum = SpectolBreakNum;
                    ExeScript(at_4661);
                    int volumes[4] = {0};
                    volumes[0] = MenuHowHaveMuchNum;
                    volumes[1] = SpectolBreakSpPoint * MenuHowHaveMuchNum;
                    mes->SetMsgVolumeNo(volumes, 2);
                } else {
                    ExeScript(at_4662);
                    step = 0;
                }
                char *name = ask_para.item->GetName(1);
                if (name != NULL) {
                    strcpy(mes->name[0], name);
                }
                mes->put_centering = 1;
                if ((s8)spectol.data.attach.spectol_type == 3) {
                    mes->MakeMsg(0xBF);
                    mes->SetAbsPos(5);
                } else {
                    mes->StepMsg();
                    MenuFormUpdataAttachInfo(MenuSpectolSatusCheckForm, &spectol, ask_para.item->item_no, 1, NULL);
                    if (MenuSpectolSatusCheckBGFadeForm != NULL) {
                        MenuSpectolSatusCheckBGFadeForm->draw_flag = 1;
                    }
                }
            }
            break;
        case 11:
            if (ret->cmd == 1) {
                next_sub_menu = 0;
                FadeOutMenu(40, 0.0f);
            }
            break;
        case 12:
            if (ret->cmd == 1) {
                next_sub_menu = 1;
                if (chara_poly_form[0] != NULL) {
                    chara_poly_form[0]->draw_flag = 0;
                }
                if (chara_poly_form[1] != NULL) {
                    chara_poly_form[1]->draw_flag = 0;
                }
                FadeOutMenu(40, 0.0f);
            }
            break;
        case 13:
            if (ret->cmd == 1) {
                NowGiftBoxPtr = ask_para.item;
                SetPreCmdGiftBoxSelect(CMenuItemInfoPt, ask_para.item);
                if (MenuCommonInfo->cursor_form != NULL) {
                    MenuCommonInfo->cursor_form->draw_flag = 0;
                }
            }
            break;
        case 29:
        case 38:
        case 47:
            if (ret->cmd == 1) {
                if (ret->unk_2 == 29) {
                    next_sub_menu = 3;
                }
                if (ret->unk_2 == 38) {
                    next_sub_menu = 4;
                }
                if (ret->unk_2 == 47) {
                    next_sub_menu = 5;
                }
                FadeOutMenu(40, 0.0f);
            }
            break;
        case 23:
            view_weapon = ask_para.item;
            view_chara = ask_para.item->item_no;
            view_mode = 2;
            key_arg_no = 4;
            MenuCommonInfo->key_arg = &item_menu_argtbl[key_arg_no];
            ModelReadStart(view_mode, 1, 1);
            CMenuItemInfoPt->NextModeBuildUpInfo(CMenuItemInfoPt->view_weapon);
            break;
        case 15:
        case 16:
        case 18:
            if (MenuItemCmdRet.result == 1) {
                SetItemEffect();
                CheckEnableHaveItemNum();
                if (MenuItemCmdRet.item_no == 0x184 || MenuItemCmdRet.item_no == 0x185) {
                    step = 2;
                    int msg = 0xB8;
                    if (MenuItemCmdRet.item_no == 0x185) {
                        msg = 0xB9;
                    }
                    ExeScript(at_4663);
                    MenuDCMsg[7]->MakeMsg(msg);
                    mode = MENU_ASK_MODE_ITEM_COMMAND;
                }
            }
            if (MenuItemCmdRet.result == 10) {
                ExeScript(at_4664);
                step = 1;
            }
            if (MenuItemCmdRet.result == 20) {
                step = 2;
                int msg_no[2] = {10, -1};
                if (MenuItemCmdRet.item_no == 0x185) {
                    msg_no[0] = 11;
                }
                ExeScript(at_4665);
                MenuDCMsg[7]->SetMsgItemNo(msg_no, 1);
                mode = MENU_ASK_MODE_ITEM_COMMAND;
            }
            break;
        case 26:
            if (ret->cmd == 1) {
                Nameregi_Target.target = 0;
                Nameregi_Target.item = ask_para.item;
                if (ask_para.item->item_type == 11) {
                    Nameregi_Target.target = 1;
                    Nameregi_Target.item = NULL;
                }
                next_sub_menu = 2;
                FadeOutMenu(40, 0.0f);
            }
            break;
        case 24:
        case 25:
            if (ret->cmd == 1 && view_mode == 0 && ret->item2 != NULL) {
                int esa_no = ret->item2->item_no;
                ret->item2->Init();
                ask_para.item->CopyDataItem(esa_no);
                int movement[2][4] = {{5, 0, 0, 0}, {1, 0, 0, 0}};
                movement[1][3] = ret->result;
                CommonSetMoveItemClass(movement);
            }
            break;
        case 27:
        case 28:
        case 32:
        case 33:
            if (ret->cmd == 1 && view_mode == 0 && ret->unk_8 == 0) {
                GameDataSwap(ret->item2, GetUserDataMan()->GetActiveEsa(), 0);
                int movement[2][4] = {{1, 0, 0, 0}, {5, 0, 0, 0}};
                movement[0][3] = ret->result;
                CommonSetMoveItemClass(movement);
            }
            break;
        case 46:
            if (ret->cmd == 1) {
                view_weapon = ask_para.item;
                view_chara = ask_para.item->item_no;
                unk_160 = 1;
                SpectolInfoStay.CopyGameData(ask_para.item);
                MenuCommonInfo->cursor = 0;
                key_arg_no = 10;
                MenuCommonInfo->key_arg = &item_menu_argtbl[key_arg_no];
                view_mode = 5;
                ModelReadStart(view_mode, 1, 1);
                ExeScript(at_4666);
                mode = 15;
                step = 0;
            }
            break;
        case 30: {
            MENU_SWAPITEM_INFO swap;
            swap.Set(3, MenuCommonInfo->cursor, -1, 0);
            MenuSePlay(menu_item_swap_sndtbl[MenuCommonInfo->MenuSwapItem(MenuItemCmdRet.item2, &swap, 1, true)]);
            break;
        }
        case 37:
            if (ret->result == 0) {
                ExeScript(at_4667);
                mode = MENU_ASK_MODE_ITEM_COMMAND;
                step = 1;
            }
            break;
        case 43:
            if (ret->cmd == 1) {
                ExeScript(at_4668);
                mode = MENU_ASK_MODE_ITEM_COMMAND;
                step = 3;
            }
            break;
        case 45:
            if (ret->cmd == 1) {
                mode = MENU_ASK_MODE_ITEM_COMMAND;
                step = 2;
                ExeScript(at_4669);
                ask_para.item->CheckParamLimmit();
                u8 code[0x40];
                ask_para.item->TransToPassword((char *)code, 14);
                char password[0x20];
                EncodePassword(code, 16, (u8 *)ask_para.item->GetName(0), 20, password, 70);
                char text[0x80];
                text[44] = '\0';
                text[45] = '\0';
                strcpy(text, password);
                char space[0x20] = "  ";
                char *names[3] = {NULL};
                names[0] = ask_para.item->GetName(0);
                names[1] = space;
                names[2] = text;
                MenuDCMsg[7]->SetMsgItemNo(names, 3);
            }
            break;
        case 44:
            if (ret->result == 1) {
                load_stack->stReset();
                load_stack->Align64();
                StartReadBG();
                int size;
                LoadFileBG(at_4670, load_stack->stGetTop(), &size);
                DNG_BATTLE_AREA *battle_scene = (DNG_BATTLE_AREA *)menu_GetBattleAreaScene();
                ask_para.item->DeleteNum(1);
                if (battle_scene != NULL) {
                    battle_scene->floor_status &= ~7;
                }
                step = 4;
                mode = MENU_ASK_MODE_ITEM_COMMAND;
            }
            break;
        case 42: {
            load_stack->stReset();
            StartReadBG();
            load_stack->Align64();
            int size;
            LoadFileBG(at_4671, load_stack->stGetTop(), &size);
            u32 file_size = size;
            load_stack->Alloc((file_size & 0xF) ? (file_size >> 4) + 1 : file_size >> 4);
            step = 10;
            mode = MENU_ASK_MODE_ITEM_COMMAND;
            int pos[2];
            MenuPosData->GetPosMenuItemOnItemBrd(pos, MenuCommonInfo->cursor, 0);
            InitFishBoiledEffect(pos, (mgCTexture *)mgTexManager.GetTexture(at_4672, -1));
            break;
        }
        }
        break;
    }
    case 1:
        if (cmd_ret != 0) {
            IsAskEnd(1, MenuMesForm[7]);
            MenuMesForm[7]->draw_flag = 0;
        }
        break;
    case 2:
        if (cmd_ret != 0) {
            IsAskEnd(1, MenuMesForm[7]);
            MenuMesForm[7]->draw_flag = 0;
            if (MenuCommonInfo->cursor_form != NULL) {
                MenuCommonInfo->cursor_form->draw_flag = 0;
            }
            step = 0;
            mode = MENU_ASK_MODE_NONE;
        }
        break;
    case 3: {
        int answer = MenuDCMsg[7]->YesNoCursor2(0);
        if (answer == 1) {
            ask_para.item->DeleteNum(1);
            MenuSePlay(1);
            mode = MENU_ASK_MODE_CLOSE;
            step = 0;
            unk_170 = 1;
            sound_loaded = 0;
            unk_174 = 0;
            FadeOutMenu(40, 0.0f);
        }
        if (answer == 2) {
            IsAskEnd(5, MenuMesForm[7]);
            MenuMesForm[7]->draw_flag = 0;
            if (MenuCommonInfo->cursor_form != NULL) {
                MenuCommonInfo->cursor_form->draw_flag = 0;
            }
            step = 0;
            mode = MENU_ASK_MODE_NONE;
        }
        break;
    }
    case 10:
        if (ReadBGSync() == 0) {
            BG_READ_INFO *file = GetReadBGFile(0);
            if (file != NULL) {
                MenuSePlay(0, (u32 *)file->buffer, &MenuSoundBuffer);
            }
            step = 0;
            mode = MENU_ASK_MODE_NONE;
        }
        break;
    case 4:
        if (ReadBGSync() == 0) {
            BG_READ_INFO *file = GetReadBGFile(0);
            if (file != NULL) {
                MenuSePlay(0, (u32 *)file->buffer, &MenuSoundBuffer);
            }
            ExeScript(at_4673);
            mode = MENU_ASK_MODE_ITEM_COMMAND;
            step = 2;
        }
        break;
    }
    return 1;
}
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
extern int Effect_Counter_4682;
extern s8 init_4683;
extern u8 BuildEndFlag_4703;
extern s8 init_4704;
extern char at_4950[];
extern char at_4951[];
extern char at_4952[];
extern char at_4953[];
extern char at_4955[];
extern char at_4956[];
extern char at_4957[];
#ifdef NONMATCHING
int CMenuItemInfo::IsAskExtend(int select_key, int push_button) {
    mgCMemory *load_stack = &MenuCharaLoadStack;
    int close = 0;
    mgCMemory work;
    MENU_ASKMODE_PARA *para = &ask_para;
    if (!init_4683) {
        Effect_Counter_4682 = 0;
        init_4683 = 1;
    }
    mgCTextureManager *tex_manager = &mgTexManager;
    CMenuPosDataForm *mes_form = MenuMesForm[7];
    int reading = ReadBGSync();
    float position[4];
    int size;
    switch (para->unk_70) {
        case 1:
            switch (step) {
                case 0:
                    MenuRepairMan->LoadDataBG(load_stack);
                    step++;
                    break;
                case 1:
                    if (reading == 0) {
                        int repair_tex_block = tex_block[2];
                        MenuRepairMan->CheckDataBG(repair_tex_block);
                        MenuActionChara[0]->GetPosition(position);
                        if (unk_16C) {
                            MenuRepairMan->GeneratePoly(position, repair_tex_block);
                            if (MenuActionChara[0] != NULL) {
                                MenuActionChara[0]->pallet[0].SetAnim(0xEB, 0xEB, 0x3C, 1, 0x29, 0);
                            }
                        }
                        MenuRepairMan->Generate(MenuRepairTargetWeaponPos[0], MenuRepairTargetWeaponPos[1]);
                        step++;
                    }
                    break;
                case 2:
                    if (unk_16C == 0 || (unk_16C == 1 && !MenuRepairMan->IsRun())) {
                        if (MenuCommonInfo->cursor_form != NULL) {
                            MenuCommonInfo->cursor_form->draw_flag = 1;
                        }
                        unk_16C = 0;
                        step = 0;
                        para->unk_70 = 0;
                        mode = MENU_ASK_MODE_NONE;
                    }
                    break;
            }
            break;
        case 2: {
            if (!init_4704) {
                BuildEndFlag_4703 = 0;
                init_4704 = 1;
            }
            BUILDUP_WEAPON_INFO *info = &BuildUpWeaponInfo;
            CActionChara *chara = MenuActionChara[0];
            CDC2Mes *name_message = MenuDCMsg[6];
            CDC2Mes *message = MenuDCMsg[7];
            switch (step) {
                case 0: {
                    int old_select = info->select_no;
                    if (select_key & MENU_SELECT_KEY_UP) {
                        info->select_no--;
                    }
                    if (select_key & MENU_SELECT_KEY_DOWN) {
                        info->select_no++;
                    }
                    if (info->select_no < 0) {
                        info->select_no = 0;
                    }
                    if (info->select_no >= info->select_num) {
                        info->select_no = info->select_num - 1;
                    }
                    int select = info->select_no;
                    CDataWeapon *data = info->weapon_data[select];
                    if (old_select != select) {
                        MenuSePlay(0);
                    }
                    MenuWeaponStatusInfoFormSet(info->weapon, data);
                    if (push_button == MENU_PUSH_BUTTON_CANCEL) {
                        info->mode = 0;
                        MenuSePlay(5);
                        close = 1;
                    } else if (push_button == 8 || push_button == 4 || push_button == 1) {
                        if (info->enable[select] == 1) {
                            if (CheckBuildUpMonsterCondition(data)) {
                                ExeScript(at_4950);
                                if (name_message->name[select + 1] != NULL) {
                                    strcpy(message->name[0], name_message->name[select + 1]);
                                }
                                message->StepMsg();
                                step++;
                            } else {
                                ExeScript(at_4951);
                                step = 5;
                            }
                        } else {
                            MenuSePlay(5);
                        }
                    }
                    break;
                }
                case 1: {
                    int choice = message->YesNoCursor();
                    if (push_button == MENU_PUSH_BUTTON_CANCEL) {
                        if (MenuCommonInfo->cursor_form != NULL) {
                            MenuCommonInfo->cursor_form->draw_flag = 1;
                        }
                        MenuSePlay(5);
                        step = 0;
                    } else if (push_button == 8 || push_button == 4 || push_button == 1) {
                        if (choice != 0) {
                            if (MenuCommonInfo->cursor_form != NULL) {
                                MenuCommonInfo->cursor_form->draw_flag = 1;
                            }
                            MenuSePlay(5);
                            step = 0;
                        } else {
                            MenuSePlay(1);
                            BuildEndFlag_4703 = 0;
                            info->mode = 0;
                            load_stack->stReset();
                            load_stack->Align64();
                            u_long128 *buffer = load_stack->stGetTop();
                            StartReadBG();
                            LoadFileBG(at_4952, buffer, &size);
                            load_stack->Alloc(QuadwordsFor(size + 0x800));
                            load_stack->Align64();
                            LoadFileBG(at_4953, load_stack->stGetTop(), &size);
                            load_stack->Alloc(QuadwordsFor(size + 0x800));
                            itemmenu_chr_rotflag = 0;
                            step++;
                        }
                    }
                    if (push_button != 0) {
                        mes_form->draw_flag = 0;
                    }
                    break;
                }
                case 2:
                    if (reading == 0) {
                        BG_READ_INFO *model_file = GetReadBGFile(0);
                        BG_READ_INFO *sound_file = GetReadBGFile(1);
                        if (sound_file != NULL) {
                            mgCMemory sound_stack;
                            sound_stack.stSetBuffer(load_stack->stGetTop(), 0x1C0);
                            load_stack->Alloc(0x1C0);
                            MenuSePlay(0, (u_int *)sound_file->buffer, &sound_stack);
                        }
                        chara->GetPosition(position);
                        tex_manager->DeleteBlock(tex_block[2]);
                        load_stack->Align64();
                        int rest = load_stack->stGetRest();
                        work.stSetBuffer(load_stack->stGetTop(), rest);
                        build_up_chara = NewMenuActionChara(&work);
                        build_up_chara->Initialize(NULL);
                        build_up_chara->LoadPack((u_int *)model_file->buffer, at_4954, &work, &work, &work, tex_block[2], NULL);
                        build_up_chara->SetScale(1.5f, 1.5f, 1.5f);
                        build_up_chara->SetPosition(position);
                        build_up_chara->SetMotion(at_4955, 0, 1);
                        build_up_chara->Step();
                        mgCFrame *frame = build_up_chara->CObjectFrame::frame;
                        if (frame != NULL && frame->attr != NULL) {
                            frame->attr->z_test = -1;
                            frame->SetAttrParam(*frame->attr, 1, MG_FRAME_ATTR_Z_TEST);
                        }
                        work.Alloc(0x100);
                        BuildEndFlag_4703 = 0;
                        char *path = GetItemFilePath(name_message->item_mes[info->select_no + 1], 1);
                        work.Align64();
                        u_long128 *buffer = work.stGetTop();
                        StartReadBG();
                        LoadFileBG(path, buffer, &size);
                        unk_2F8 = 1;
                        step++;
                    }
                    break;
                case 3: {
                    build_up_chara->Step();
                    if (!BuildEndFlag_4703) {
                        float frame_no = build_up_chara->GetNowFrame(NULL);
                        if (28.0f < frame_no) {
                            chara->Show(0, 1);
                        }
                        if (34.0f < frame_no) {
                            chara_poly_form[0]->counter = -6;
                        }
                        if (reading == 0 && 40.0f < frame_no) {
                            BG_READ_INFO *file = GetReadBGFile(0);
                            int new_item_no = name_message->item_mes[info->select_no + 1];
                            BuildUpWeaponTrans(info->weapon, new_item_no);
                            int weapon_tex_block = tex_block[1];
                            mgCTextureManager *textures = &mgTexManager;
                            textures->DeleteBlock(weapon_tex_block);
                            strcpy(textures->name_suffix, at_4956);
                            MenuActionCharaBuffer[0].stReset();
                            chara->Initialize(NULL);
                            chara->LoadPack((u_int *)file->buffer, at_4954, MenuActionCharaBuffer, MenuActionCharaBuffer,
                                            MenuActionCharaBuffer, weapon_tex_block, NULL);
                            textures->name_suffix[0] = 0;
                            WeaponBuildCheck(chara, new_item_no, weapon_tex_block);
                            BuildEndFlag_4703 = 1;
                        }
                    }
                    if (BuildEndFlag_4703 == 1 && build_up_chara->CheckMotionEnd(NULL)) {
                        unk_2F8 = 0;
                        build_up_chara = NULL;
                        ExeScript(at_4957);
                        if (name_message->name[info->select_no + 1] != NULL) {
                            strcpy(message->name[0], name_message->name[info->select_no + 1]);
                        }
                        step++;
                    }
                    break;
                }
                case 4:
                    if (push_button != 0) {
                        close = 1;
                        mes_form->draw_flag = 0;
                        MenuSePlay(1);
                        itemmenu_chr_rotflag = 1;
                    }
                    break;
                case 5:
                    if (push_button != 0) {
                        mes_form->draw_flag = 0;
                        if (MenuCommonInfo->cursor_form != NULL) {
                            MenuCommonInfo->cursor_form->draw_flag = 1;
                        }
                        MenuSePlay(5);
                        step = 0;
                    }
                    break;
            }
            if (close == 1) {
                MenuWeaponStatusInfoFormSet(NULL, NULL);
                step = 0;
                mode = MENU_ASK_MODE_NONE;
                para->unk_70 = 0;
            }
            break;
        }
        case 0:
            break;
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", IsAskExtend__13CMenuItemInfoFii);
#endif
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
#ifdef NONMATCHING
void CommonSetMoveItemClass(int (*table)[4]) {
    int goal[2];
    int start[2];
    int clear_source = 0;
    CGameDataUsed *items[2] = {NULL, NULL};
    MENU_ITEM_MOVE_INFO info[2];
    for (int i = 0; i < 2; i++) {
        MENU_ITEM_MOVE_INFO *move = &info[i];
        int *slot = table[i];
        move->active = 1;
        move->mode = MENU_MOVE_ITEM_COPY;
        move->from[0] = slot[0];
        move->from[1] = slot[1];
        move->from[2] = slot[2];
        move->from[3] = slot[3];
        if (move->from[0] == 0) {
            if (move->from[1] < 2) {
                if (move->from[2] == 0) {
                    items[i] = &MenuUserParam.chara[slot[1]]->active_item[slot[3]];
                } else if (move->from[2] == 1) {
                    items[i] = &MenuUserParam.chara[move->from[1]]->equip[move->from[3]];
                }
            } else {
                move->from[2] = 1;
                items[i] = &MenuUserParam.robo->parts[slot[3]];
            }
        } else if (move->from[0] == 1) {
            clear_source = 1;
            items[i] = &MenuUserParam.used_data[slot[3]];
        } else if (move->from[0] == 2) {
            clear_source = 1;
            items[i] = &MenuCommonInfo->have_item;
        } else if (move->from[0] == 3) {
            clear_source = 0;
            items[i] = &MenuMoveTempGameDataUsed;
            move->from[0] = 1;
            slot[0] = 1;
        } else if (move->from[0] == 5) {
            clear_source = 1;
            items[i] = GetUserDataMan()->GetActiveEsa();
        }
    }
    MenuMoveItemPos(table[0], start, 0);
    MenuMoveItemPos(table[1], goal, 0);
    info[0].dest = items[1];
    info[1].dest = items[0];
    memcpy(&info[0].item, items[0], sizeof(CGameDataUsed));
    memcpy(&info[1].item, items[1], sizeof(CGameDataUsed));
    if (info[0].from[0] == 5) {
        info[1].mode = MENU_MOVE_ITEM_ONE;
        MenuMoveItemPtr->SetMoveItemInfo(&info[1], goal, start);
        if (clear_source && items[1] != NULL) {
            items[1]->DeleteNum(1);
        }
    } else if (info[0].item.CheckTypeEnableStack() && info[0].item.item_no == info[1].item.item_no) {
        info[1].mode = MENU_MOVE_ITEM_STACK;
        MenuMoveItemPtr->SetMoveItemInfo(&info[1], goal, start);
        if (clear_source && items[1] != NULL) {
            items[1]->Init();
        }
    } else {
        MenuMoveItemPtr->SetMoveItemInfo(&info[0], start, goal);
        MenuMoveItemPtr->SetMoveItemInfo(&info[1], goal, start);
        if (info[0].dest != NULL) {
            info[0].dest->Init();
        }
        if (info[1].dest != NULL) {
            info[1].dest->Init();
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", CommonSetMoveItemClass__FPA4_i);
#endif
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
            field_chara->sound_info.se_bank = Robo_Sound_ID_Save;
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
extern char at_5259[];
extern char at_5260[];
extern char at_5261[];
extern char at_5262[];
extern char at_5263[];
extern char at_5264[];
extern char at_5266[];
extern char at_5267[];
extern char at_5268[];
extern char at_5269[];
extern char at_5270[];
extern char at_5272[];
extern char at_5273[];
extern char at_5274[];
extern char at_5275[];
extern char at_5276[];
extern char at_5277[];
extern char at_5278[];
extern char at_5279[];
extern char at_5280[];
extern char at_5282[];
extern char at_5283[];
extern char *ItemMenuFormNameTbl[6];
void CMenuItemInfo::AttachFormInfo(void) {
    int i;
    for (i = 0; i < 6; i++) {
        view_form[i] = (CMenuPosDataForm *)MenuPosData->GetFormInfo(ItemMenuFormNameTbl[i]);
    }
    MenuSpectolSatusCheckForm = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_5259);
    MenuSpectolSatusCheckBGFadeForm = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_5260);
    unk_198 = 0;
    for (i = 0; i < 2; i++) {
        CMenuPosDataForm *form = view_form[i];
        wep_parts[i][4] = form->GetPartInfo(at_5261);
        wep_parts[i][5] = form->GetPartInfo(at_5262);
        wep_parts[i][6] = form->GetPartInfo(at_5263);
        wep_parts[i][7] = form->GetPartInfo(at_5264);
        wep_parts[i][8] = form->GetPartInfo(at_5265);
        wep_parts[i][9] = form->GetPartInfo(at_5266);
        wep_parts[i][10] = form->GetPartInfo(at_5267);
        wep_parts[i][11] = form->GetPartInfo(at_5268);
        wep_parts[i][12] = form->GetPartInfo(at_5269);
        wep_parts[i][13] = form->GetPartInfo(at_5270);
        wep_parts[i][14] = form->GetPartInfo(at_5271);
        wep_parts[i][15] = form->GetPartInfo(at_5272);
        hp_bar[i] = form->GetPartInfo(at_3822);
        item_parts[i][0] = form->GetPartInfo(local_over_flow_baseposname[0]);
        item_parts[i][1] = form->GetPartInfo(local_over_flow_baseposname[1]);
        item_parts[i][2] = form->GetPartInfo(local_over_flow_baseposname[2]);
        item_num[i][0] = form->GetPartInfo(at_2548);
        item_num[i][1] = form->GetPartInfo(at_5273);
        item_num[i][2] = form->GetPartInfo(at_5274);
    }
    for (i = 0; i < 10; i++) {
        BuildUpFormInfoIndex[i] = view_form[2]->GetPartInfo(WepStatusInfoStrTable[i]);
    }
    BuildUpFormInfoStatusVol[0] = view_form[2]->GetPartInfo(WepStatusInfoStatusVolStrTable[0]);
    BuildUpFormInfoStatusVol[1] = view_form[2]->GetPartInfo(WepStatusInfoStatusVolStrTable[1]);
    for (i = 0; i < 8; i++) {
        BuildUpFormInfoStatusVol[i + 2] = view_form[2]->GetPartInfo(WepStatusInfoStatusVolStrTable[i + 2]);
    }
    CMenuPosDataForm *robo_form = view_form[3];
    voice_part = robo_form->GetPartInfo(at_5275);
    robo_parts[0] = robo_form->GetPartInfo(at_5276);
    robo_parts[1] = robo_form->GetPartInfo(at_5262);
    robo_parts[2] = robo_form->GetPartInfo(at_5263);
    robo_parts[3] = robo_form->GetPartInfo(at_5264);
    robo_parts[4] = robo_form->GetPartInfo(at_5265);
    robo_parts[5] = robo_form->GetPartInfo(at_5266);
    item_board_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_5277);
    item_board_icon = NULL;
    if (item_board_form != NULL) {
        item_board_icon = item_board_form->GetPartInfo(at_5278);
    }
    money_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_5279);
    fill_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_5280);
    chara_poly_form[0] = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_5281);
    chara_poly_form[1] = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_5282);
    GiftBoxViewForm = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_5283);
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
extern s8 init_5412;
extern s8 checkmoveFlag_5411;
extern u8 itemmenu_calcmode_tbl_5410[6];
extern char at_5758[];
extern char at_5759[];
#ifdef NONMATCHING
void CMenuItemInfo::CalcTex() {
    int held_type;
    Func_MenuItemBrdPosStep(MenuItem_ItemBoardTopLine);
    int cursor = MenuCommonInfo->cursor;
    if (init_5412 == 0) {
        checkmoveFlag_5411 = 0;
        init_5412 = 1;
    }
    int i;
    int check_move = MenuMoveItemPtr->CheckMove();
    int view_flag[6];
    for (i = 0; i < 6; i++) {
        if (itemmenu_calcmode_tbl_5410[i] != view_mode) {
            view_form[i]->SetAction(at_5757);
        } else {
            view_form[i]->SetAction(at_3893);
            if (mode == MENU_ASK_MODE_CLOSE && CheckTrushMenu() == 0 && unk_170 == 0) {
                view_form[i]->SetAction(at_5757);
            }
        }
        view_flag[i] = -1;
    }
    MenuItemInfoCursorSet(CMenuItemInfoPt->mode);
    if (view_form[0]->x < -180.0f) {
        view_form[0]->draw_flag = 0;
    } else {
        view_form[0]->draw_flag = 1;
        if (view_form[0]->rgba[3] <= 0) {
            view_form[0]->draw_flag = 0;
        }
        MenuItemCharaViewCheck(MenuUserParam.chara[0], 0, view_flag[0]);
    }
    if (view_form[1]->x < -180.0f) {
        view_form[1]->draw_flag = 0;
    } else {
        view_form[1]->draw_flag = 1;
        if (view_form[1]->rgba[3] <= 0) {
            view_form[1]->draw_flag = 0;
        }
        MenuItemCharaViewCheck(MenuUserParam.chara[1], 1, view_flag[0]);
    }
    if (view_form[2]->x < -172.0f) {
        view_form[2]->draw_flag = 0;
    } else {
        view_form[2]->draw_flag = 1;
        MenuPosFormValueSetWeapon(view_weapon);
    }
    if (view_form[3]->x < -172.0f) {
        view_form[3]->draw_flag = 0;
    } else {
        view_form[3]->draw_flag = 1;
        MenuPosFormValueSetCharaRobo(MenuUserParam.robo, view_flag[3]);
    }
    if (view_form[4]->x < -172.0f) {
        view_form[4]->draw_flag = 0;
    } else {
        view_form[4]->draw_flag = 1;
        MenuPosFormValueSetMonster(MenuUserParam.monster1, MenuUserParam.chara[1]);
    }
    if (view_form[5] != NULL) {
        if (view_form[5]->x < -172.0f) {
            view_form[5]->draw_flag = 0;
        } else {
            view_form[5]->draw_flag = 1;
            MenuPosFormValueSetFishingRod(view_weapon);
        }
    }
    for (i = 0; i < 2; i++) {
        if (i != view_mode) {
            view_form[i]->SetRGBACalcParam(3, -4, 0);
        } else {
            view_form[i]->SetRGBACalcParam(3, 6, 0x80);
        }
    }
    s16 reference_ids[6] = {0, 1, view_chara, 2, 3, view_chara};
    int held_item_no = MenuCommonInfo->have_item.item_no;
    int reference_id = reference_ids[view_mode];
    int reference_no = -1;
    if (view_mode == 2 || view_mode == 5) {
        reference_id = 4;
        reference_no = 0;
    } else if (held_item_no <= 0) {
        if (key_arg_no == 1 || key_arg_no == 7) {
            reference_no = cursor;
        }
    } else {
        held_type = GetItemDataType(held_item_no);
        for (i = 0; i < 4; i++) {
            if (held_type == SearchEquipType(reference_id, i)) {
                reference_no = i;
            }
        }
    }
    CActionChara *chara = MenuActionChara[0];
    menu_camera_reference_id = reference_id;
    menu_camera_reference_no = reference_no;
    if (chara != NULL) {
        chara_poly_form[0]->ambient[0] = 64.0f;
        chara_poly_form[0]->ambient[1] = 64.0f;
        chara_poly_form[0]->ambient[2] = 64.0f;
        chara_poly_form[0]->ambient[3] = 128.0f;
        switch (view_mode) {
        case 0:
        case 1:
            if (reference_id == 1) {
                sceVu0FVECTOR rotation;
                chara->GetRotation(rotation);
                if (reference_no == 2) {
                    if (rotation[1] < 3.1415927f) {
                        rotation[1] += 0.15707964f;
                    } else {
                        rotation[1] = 3.1415927f;
                    }
                } else {
                    if (rotation[1] > 0.0f) {
                        rotation[1] -= 0.15707964f;
                    } else {
                        rotation[1] = 0.0f;
                    }
                }
                chara->SetRotation(rotation);
            }
            MenuWeaponRealStepEnvFunc(MenuWeaponEnvSetChara, MenuWeaponEnvSetListNo);
            break;
        case 3:
        case 4:
            AddRotationCharaY(chara, 0.01308997f);
            break;
        case 2:
        case 5:
            if ((s8)itemmenu_chr_rotflag != 0) {
                AddRotationCharaY(chara, 0.01308997f);
                MenuWeaponRealStepEnvFunc(MenuWeaponEnvSetChara, MenuWeaponEnvSetListNo);
            }
            break;
        }
    }
    int fusing = 0;
    int spectol_view = 0;
    int chara_view = 0;
    if ((view_mode == 2 || view_mode == 5) && SpectolInfo[0] != NULL && view_weapon == SpectolInfo[0]) {
        spectol_view = 1;
    }
    if (view_mode == 0 || view_mode == 1) {
        chara_view = 1;
    }
    int effect_pos[2];
    if (mode == MENU_ASK_MODE_FUSION && step > 0) {
        if (step == 1) {
            fusing = 1;
        }
        MenuPosData->GetPosMenuItemOnItemBrd(effect_pos, trans_spectol_pos, 0);
        if (key_arg_no == 2) {
            MenuEffect[0]->base_info[0] = effect_pos[0];
            MenuEffect[0]->base_info[1] = effect_pos[1];
        } else if ((spectol_view != 0 || chara_view != 0) && SpectolFusionTargetChara != NULL &&
                   chara_poly_form[0] != NULL && chara_poly_form[0]->draw_flag != 0) {
            mgCFrame *frame = NULL;
            if (spectol_view != 0) {
                frame = MenuActionChara[0]->GetFrame();
            }
            if (chara_view != 0) {
                frame = MenuActionChara[0]->SearchObject(
                    focusnametbl[sub_view * 4 + SpectolFusion_LeftOrRight]);
            }
            sceVu0IVECTOR screen_pos;
            Trans3DPosTo2DPos(&MenuDrawEnv->camera, frame, screen_pos);
            effect_pos[0] = screen_pos[0] >> 4;
            effect_pos[1] = screen_pos[1] >> 4;
            MenuEffect[0]->base_info[0] = effect_pos[0];
            MenuEffect[0]->base_info[1] = effect_pos[1];
        }
        MenuEffect[1]->base_info[0] = effect_pos[0];
        MenuEffect[1]->base_info[1] = effect_pos[1];
    }
    if (mode == MENU_ASK_MODE_SPECTOL && step > 0) {
        MenuPosData->GetPosMenuItemBrdForEffect(effect_pos, ask_para.arg0, 0);
        MenuEffect[0]->base_info[0] = effect_pos[0];
        MenuEffect[0]->base_info[1] = effect_pos[1];
        MenuPosData->GetPosMenuItemBrdForEffect(effect_pos, trans_spectol_pos, 0);
        MenuEffect[0]->base_info[4] = effect_pos[0];
        MenuEffect[0]->base_info[5] = effect_pos[1];
    }
    FusionColor(fusing, spectol_view, chara_poly_form[0]->ambient);
    if (view_mode == 2 || view_mode == 5) {
        SpectolFrameCalc(MenuActionChara[0], fusing && spectol_view);
        CMenuPosDataForm *poly_form = chara_poly_form[1];
        poly_form->draw_flag = (fusing && spectol_view) != 0;
    }
    int item_mes[6] = {10, 11, 1, 1, 1, 1};
    int volumes[6] = {0};
    char *names[8] = {at_5132, at_5132, at_5132, at_5132, at_5132, at_5132, at_5132};
    if (view_weapon != NULL) {
        names[2] = view_weapon->GetName(1);
        names[5] = names[2];
    }
    if (MenuUserDataManPtr != NULL) {
        names[3] = MenuUserDataManPtr->GetRoboName();
    }
    int monster_id = GetUserDataMan()->monster_id;
    if (0 <= monster_id) {
        names[4] = GetMonsterName(monster_id);
        MOS_CHANGE_PARAM *badge = MenuUserDataManPtr->GetMonsterBajjiDataPtrMosId(monster_id);
        if (badge != NULL) {
            volumes[0] = badge->level + 1;
        }
    }
    CDC2Mes *status_mes = MenuDCMsg[3];
    status_mes->value_sign = 0;
    if (view_form[0]->rgba[3] < 0x80) {
        item_mes[0] = 1;
    }
    if (view_form[1]->rgba[3] < 0x80) {
        item_mes[1] = 1;
    }
    int name_pos[6][2];
    int mes_index = 0;
    for (i = 0; i < 6; i++) {
        view_form[i]->GetPutPosXY(at_5758, name_pos[i][0], name_pos[i][1]);
        name_pos[i][1] += 4;
        if (i == 2) {
            continue;
        }
        if (name_pos[i][0] < 10) {
            item_mes[mes_index] = 1;
        }
        mes_index++;
    }
    status_mes->SetMsgItemNo(item_mes, 6);
    status_mes->SetMsgItemNo(names, 6);
    status_mes->SetMsgVolumeNo(volumes, 2);
    status_mes->SetMsgItemPos(&name_pos[0][0], 6);
    status_mes->MakeMsg(0x91);
    CDC2Mes *info_mes = MenuDCMsg[0];
    int insert_mes[6] = {-1, -1, -1, -1, -1, -1};
    int key_no = key_arg_no;
    int mes_no = key_no;
    switch (view_mode) {
    case 0:
    case 1:
        if (key_no == 3) {
            mes_no = 0x6A;
            insert_mes[0] = sub_view + 10;
            info_mes->SetMsgItemNo(insert_mes, 20);
        }
        break;
    case 2: {
        s16 slot_mes[2] = {10000, 22};
        if (key_no == 4) {
            mes_no = GetItemMessageNo(view_chara, 1);
        } else if (key_no != 2) {
            mes_no = cursor + (slot_mes[key_no - 4U] + 100);
            info_mes->SetMsgItemNo(insert_mes, 4);
        }
        break;
    }
    case 3:
        if (key_no == 6) {
            insert_mes[0] = 12;
            mes_no = 0x6A;
            info_mes->SetMsgItemNo(insert_mes, 20);
        }
        break;
    case 4: {
        char *monster_name[1] = {NULL};
        mes_no = 0x6C;
        monster_name[0] = GetMonsterName(GetUserDataMan()->monster_id);
        info_mes->SetMsgItemNo(monster_name, 1);
        break;
    }
    case 5:
        mes_no = cursor + 0x85;
        if (key_no == 9) {
            mes_no = GetItemMessageNo(view_chara, 1);
        }
        break;
    }
    CGameDataUsed *item = SearchNowPosItemExist();
    if (item != NULL) {
        info_mes->MakeMsg(item);
        CGameDataUsed *held = &MenuCommonInfo->have_item;
        if (held->item_no == 0xB9 && item != NULL) {
            info_mes->MakeMsg(held, item);
        }
    } else {
        info_mes->MakeMsg(mes_no);
    }
    CGameDataUsed *held = &MenuCommonInfo->have_item;
    if (held->item_no > 0) {
        Func_MenuItemBrdPrepare2(item_board_icon, MenuUserParam.used_data, held);
    } else {
        CheckItemBoardFunc_MenuIconDrawPrepare(MenuUserDataManPtr, item_board_icon);
    }
    NowGiftBoxPtr = SearchNowPosItemExist();
    if (GiftBoxViewForm != NULL) {
        int gift_pos[2];
        if (key_arg_no == 2) {
            MenuPosData->GetPosMenuItemOnItemBrd(gift_pos, cursor, 0);
        } else if (key_arg_no == 0) {
            char part_name[32];
            sprintf(part_name, at_5759, MenuCommonInfo->cursor);
            view_form[sub_view]->GetPutPosXY(part_name, gift_pos[0], gift_pos[1]);
        }
        CMenuPosDataForm *gift_form = GiftBoxViewForm;
        gift_form->x = gift_pos[0];
        gift_form->y = gift_pos[1];
        if (mode == MENU_ASK_MODE_CLOSE) {
            NowGiftBoxPtr = NULL;
        }
    }
    if (check_move != checkmoveFlag_5411) {
        if (view_mode == 0) {
            MenuItemCharaDataLoadEndCheckAfter(MenuCharaBuild2, 0);
        } else if (view_mode == 1) {
            MenuItemCharaDataLoadEndCheckAfter(MenuCharaBuild2, 1);
        } else if (view_mode == 3) {
            MenuItemCharaDataLoadEndCheckAfter(MenuCharaBuild2, 2);
        }
    }
    checkmoveFlag_5411 = check_move;
    EffectDrawCheck(item_board_form);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", CalcTex__13CMenuItemInfoFv);
#endif
extern char at_5879[];
extern char at_5880[];
extern char at_5881[];
extern char at_5882[];
extern char at_5883[];
extern s8 waku_infotbl_5836[][2];
extern s8 wakutypeTbl_5837[];
#ifdef NONMATCHING
void CMenuItemInfo::CalcCursorPosition(void) {
    if (mode == MENU_ASK_MODE_CLOSE) {
        MenuCommonInfo->SetWakuType(-1);
        return;
    }
    char name[0x20];
    char part_name[0x20];
    CMenuPosDataForm *form = NULL;
    int pos[2] = {0, 0};
    s16 arg_no = key_arg_no;
    int cursor = MenuCommonInfo->cursor;
    s16 waku_no = arg_no;
    if (arg_no != 12) {
        if (arg_no < 0) {
            key_arg_no = 0;
        }
        form = view_form[sub_view];
        CMenuPosDataForm *forms[12] = {form, form, item_board_form, form, view_form[2], view_form[2],
                                       view_form[3], view_form[3], view_form[4], view_form[5], view_form[5], form};
        if (key_arg_no != 0 && key_arg_no != 1) {
            form = forms[key_arg_no];
        }
    }
    form->GetPutPosXY(NULL, pos[0], pos[1]);
    int msg_pos[2];
    if (arg_no == 2) {
        MenuPosData->GetPosMenuItemOnItemBrd(pos, cursor, 1);
        pos[0] -= 8;
        pos[1] -= 10;
        msg_pos[0] = pos[0];
        msg_pos[1] = pos[1];
    } else {
        int offset[2] = {0, 0};
        if (arg_no == 4 || arg_no == 9) {
            strcpy(part_name, at_5879);
            if (form != NULL) {
                form->GetPutPosXY(part_name, pos[0], pos[1]);
                pos[0] += offset[0];
                pos[1] += offset[1];
            }
        } else if (arg_no == 5 || arg_no == 10) {
            strcpy(part_name, WepStatusInfoStrTable[cursor]);
            if (form != NULL) {
                form->GetPutPosXY(part_name, pos[0], pos[1]);
                pos[0] += offset[0];
                pos[1] += offset[1];
            }
        } else if (arg_no == 0) {
            sprintf(name, at_5759, cursor);
            form->GetPutPosXY(name, pos[0], pos[1]);
            pos[1] -= 8;
        } else if (arg_no == 1 || arg_no == 7) {
            int no = cursor;
            if (cursor < 0 || cursor >= 2) {
                no = 0;
            }
            sprintf(name, at_5880, no);
            form->GetPutPosXY(name, pos[0], pos[1]);
        } else if (arg_no == 3 || arg_no == 6 || arg_no == 8) {
            form->GetPutPosXY(at_5881, pos[0], pos[1]);
        } else if (arg_no == 11) {
            form->GetPutPosXY(at_5882, pos[0], pos[1]);
        }
        msg_pos[0] = pos[0];
        msg_pos[1] = pos[1];
    }
    if (mode == MENU_ASK_MODE_NONE) {
        for (int i = 0; i < 10; i++) {
            BuildUpFormInfoIndex[i]->rgba[0] = 0x80;
            BuildUpFormInfoIndex[i]->rgba[1] = 0x80;
            BuildUpFormInfoIndex[i]->rgba[2] = 0x80;
        }
    }
    if (arg_no == 5) {
        BuildUpFormInfoIndex[cursor]->rgba[0] = 0xA4;
        BuildUpFormInfoIndex[cursor]->rgba[1] = 0xA4;
        BuildUpFormInfoIndex[cursor]->rgba[2] = 0xA4;
    }
    if (BuildUpWeaponInfo.mode != 0) {
        pos[0] = BuildUpNameXY[BuildUpWeaponInfo.select_no][0] - 0x20;
        pos[1] = BuildUpNameXY[BuildUpWeaponInfo.select_no][1];
    }
    if (menu_debug_flag != 0 && key_arg_no == 2) {
        pos[0] = 0x64;
        pos[1] = 0x50;
    }
    MenuItemCommandDir = -1;
    if (mode == MENU_ASK_MODE_ITEM_COMMAND) {
        SetItemCmdMsgPos(msg_pos);
    }
    int cursor_offset[2] = {0, 0};
    if (arg_no < 12) {
        sprintf(name, at_5883, arg_no);
        MenuPosData->GetEtcTblValue(name, cursor_offset[0], cursor_offset[1]);
    }
    MenuCommonInfo->MenuPosStep(pos, cursor_offset);
    if (MenuCommonInfo->cursor_form->draw_flag == 0) {
        waku_no = -1;
    }
    if (waku_no >= 0) {
        MenuCommonInfo->SetWakuWH(wakutypeTbl_5837[arg_no], waku_infotbl_5836[waku_no][0], waku_infotbl_5836[waku_no][1]);
        MenuCommonInfo->SetWakuType(wakutypeTbl_5837[arg_no]);
    } else {
        MenuCommonInfo->SetWakuType(-1);
    }
    if (unk_13A) {
        MenuCommonInfo->MenuSetPos(pos[0], pos[1]);
        unk_13A = 0;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", CalcCursorPosition__13CMenuItemInfoFv);
#endif
extern s16 trans_spectol_posold;
#ifdef NONMATCHING
void CBaseMenuClass::EffectDrawCheck(CMenuPosDataForm *form) {
    MENUFORMPARTS_TYPE *part = &form->parts[trans_spectol_pos];
    int effect_type = MenuEffect[0]->type;
    if (mode == MENU_ASK_MODE_SPECTOL && step == 1) {
        if (part != NULL) {
            switch (effect_type) {
                case 19:
                    trans_spectol_posold = ask_para.arg0;
                    trans_spectol_rgb = (int)(128.0f + 96.0f * sinf(0.05235988f * trans_spectol_cnt));
                    trans_spectol_cnt += 1.0f;
                    part->rgba[3] = (s8)trans_spectol_rgb;
                    break;
                case 18:
                    part->draw_flag = 0;
                    form->parts[trans_spectol_posold].rgba[3] = 0x80;
                    break;
                case 20:
                    part->draw_flag = 0;
                    if (spegetflag != 0) {
                        part->draw_flag = 1;
                    }
                    break;
            }
        }
    } else if (mode == MENU_ASK_MODE_FUSION) {
        if (effect_type == 10) {
            switch (step) {
                case 1:
                    trans_spectol_posold = trans_spectol_pos;
                    part->rgba[0] = fusion_ambient[0];
                    part->rgba[1] = fusion_ambient[1];
                    part->rgba[2] = fusion_ambient[2];
                    part->rgba[3] = fusion_ambient[3];
                    trans_spectol_cnt += 1.0f;
                    break;
                case 2: {
                    MENUFORMPARTS_TYPE *old_part = &form->parts[trans_spectol_posold];
                    if (old_part != NULL) {
                        old_part->rgba[0] = 0x80;
                        old_part->rgba[1] = 0x80;
                        old_part->rgba[2] = 0x80;
                        old_part->rgba[3] = 0x80;
                    }
                    break;
                }
            }
        }
        if (MenuEffect[1]->run != 0 && MenuEffect[1]->info != NULL) {
            MenuEffect[1]->info->unk_28 = fusion_ambient[3] / 3.0f;
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", EffectDrawCheck__14CBaseMenuClassFP16CMenuPosDataForm);
#endif
extern s8 menuitem_initviewtbl[4];
extern char at_6011[];
extern char at_6012[];
extern char at_6013[];
extern char at_6014[];
extern char at_6015[];
extern char at_6016[];
int MenuItemInit(mgCMemory *stack, int *tex_block, int mode) {
    FxScriptManPauseFlag = 0;
    u_long128 *buffer = stack->stack;
    stack->Alloc(0x80);
    MenuItemBGDataMemory.stSetBuffer(buffer, stack->stack_used);
    u_int *pack = (u_int *)buffer;
    mgCMemory work;
    int rest = stack->stGetRest();
    work.stSetBuffer(stack->stGetTop(), rest);
    CMenuItemInfoPt = &class_menu_item_info;
    CMenuItemInfoPt->Initialize();
    CMenuItemInfoPt->SetTexBlock(tex_block);
    if (GetNowLoopNo() == 2) {
        MenuMainScene->AssignStack(5);
        mgCMemory *scene_stack = MenuMainScene->GetStack(5);
        int size = scene_stack->stGetSize();
        MainCharaReadStack.stSetBuffer(scene_stack->stGetTop(), size);
    }
    MenuWeaponEnvSetListNo = -1;
    MenuWeaponEnvSetChara = NULL;
    int script_size;
    char *layout = (char *)GetPackFile(pack, at_6011, &script_size);
    MenuDataAnalyze(layout, script_size, &work);
    CMenuItemInfoPt->script = (char *)GetPackFile(pack, at_6012, &CMenuItemInfoPt->script_size);
    rest = work.stGetRest();
    MenuItemMainMemory.stSetBuffer(work.stGetTop(), rest);
    CMenuItemInfoPt->MenuModeMalloc(&MenuItemMainMemory);
    MenuPosData->GetEtcTbl2Value(at_6013, CMenuItemInfoPt->camera_ref, 3);
    MenuPosData->GetEtcTbl2Value(at_6014, CMenuItemInfoPt->camera_pos, 3);
    CMenuItemInfoPt->AttachFormInfo();
    AttachMessageForm();
    CMenuItemInfoPt->ExeScript(at_6015);
    CMenuItemInfoPt->EnterDataMenu(pack);
    MenuCommonInfo->SetWakuMoveMethod(0);
    MenuCommonInfo->key_enable = 1;
    MenuCommonInfo->CursorFadeIn(1.0f, 0);
    CMenuItemInfoPt->ExeScript(at_6016);
    int chara_no = CMenuItemInfoPt->GetActiveCharaNo();
    CMenuItemInfoPt->unk_172 = -1;
    if (chara_no < 2) {
        CMenuItemInfoPt->unk_172 = MenuUserParam.chara[chara_no]->equip[0].GetModelNo();
    }
    MenuLoadInfo.unk_1 = 0;
    if (GetMenuLoopType() == 0) {
        MenuLoadInfo.unk_1 = 1;
        CMenuItemInfoPt->unk_172 = -1;
    }
    MenuLoadInfo.mode = 0;
    MenuLoadInfo.unk_5 = 0;
    MenuLoadInfo.unk_4 = -1;
    MenuLoadInfo.unk_6[1] = 1;
    MenuLoadInfo.unk_2 = 1;
    s8 view_mode = menuitem_initviewtbl[chara_no];
    CMenuItemInfoPt->view_mode = view_mode;
    CMenuItemInfoPt->unk_112 = view_mode;
    CMenuItemInfoPt->key_arg_no = 2;
    MenuCommonInfo->cursor = 0;
    CheckEnableHaveItemNum();
    if (0 <= chara_no && chara_no < 2) {
        CMenuItemInfoPt->sub_view = chara_no;
    }
    if (chara_no == 2) {
        Robo_Sound_ID_Save = MenuMainScene->GetCharacter(0)->sound_info.se_bank;
    }
    CMenuItemInfoPt->SetEquipListNo(chara_no);
    if (chara_no == 2) {
        CMenuItemInfoPt->load_weapon_no = MenuUserParam.robo->parts[0].item_no;
    }
    if (chara_no == 0 || chara_no == 1) {
        CMenuItemInfoPt->load_weapon_no = MenuUserParam.chara[chara_no]->equip[1].item_no;
    }
    CMenuItemInfoPt->CheckLoadInfo(chara_no);
    MenuMemoryAdjust(&MenuItemMemory, &MenuCharaLoadStack, MenuActionCharaBuffer, chara_no);
    StartReadBG();
    CMenuItemInfoPt->ModelReadStart(CMenuItemInfoPt->view_mode, 1, 0);
    MenuCamInit(1.0f);
    MenuItem_ItemBoardTopSelect = 0;
    MenuItem_ItemBoardTopLine = 0;
    if (CursorSaveOptionState()) {
        MenuItem_ItemBoardTopSelect = MenuSystemDataPtr->item_board_select;
        MenuItem_ItemBoardTopLine = MenuSystemDataPtr->item_board_top;
    }
    MenuItemBoardTotalNum = GetNowBagMax(0);
    int trush = CheckTrushMenu();
    if (trush) {
        MenuItemBoardTotalNum = GetNowBagMax(1);
        MenuItem_ItemBoardTopLine = MenuItemBoardTotalNum / 6 - 5;
        MenuItem_ItemBoardTopSelect = GetNowBagMax(0);
    }
    MenuItemBoardTotalLine = MenuItemBoardTotalNum / 6;
    while (MenuItemBoardTotalLine - 5 < MenuItem_ItemBoardTopLine) {
        MenuItem_ItemBoardTopLine--;
    }
    while (MenuItem_ItemBoardTopSelect >= MenuItemBoardTotalNum) {
        MenuItem_ItemBoardTopSelect -= 6;
    }
    item_menu_argtbl[2].max = MenuItemBoardTotalNum;
    item_menu_argtbl[2].rows = MenuItemBoardTotalLine;
    MenuCommonInfo->cursor = MenuItem_ItemBoardTopSelect;
    MenuCommonInfo->top_line = MenuItem_ItemBoardTopLine;
    MenuCommonInfo->key_arg = &item_menu_argtbl[CMenuItemInfoPt->key_arg_no];
    MenuItemBrdSetInfo(MenuCommonInfo->cursor, MenuCommonInfo->top_line, MenuItemBoardTotalLine, 5);
    MenuItemBrdCalcManner = 0;
    itemmenu_chr_rotflag = 1;
    if (!trush) {
        CMenuItemInfoPt->FadeInMenu(1, 0.0f);
    }
    MenuMainFrameModeSet(2, 1);
    SetSpectolInfo(NULL, NULL);
    BuildUpWeaponInfo.weapon = &MenuUserParam.chara[0]->equip[1];
    MenuWeaponStatusInfoFormSet(NULL, NULL);
    BuildUpWeaponInfo.mode = 0;
    BuildUpWeaponInfo.select_num = 0;
    BuildUpWeaponInfo.unk_0 = 0;
    InitFishBoiledEffect(NULL, NULL);
    if (!MenuUserParam.chara[0]->equip[0].IsFishingRod()) {
        SetFishingGamePreEquip(NULL);
    }
    SetModeMenuDrawItemBoard(0);
    return 1;
}
extern mgCMemory MenuDebugStack;
extern int MenuDebugSize;
extern mgCCamera *MenuDebugCamera;
extern CActionChara *MenuDebugItemModel;
extern s8 MenuDebugModelDrawFlag;
extern s8 MenuDebugModel_AdjustFlag;
extern CDataCommon *debug_common_data;
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
extern char *attrtable_6472[7];
extern char *stchar_6508[13];
extern char at_6760[];
extern char at_6761[];
extern char at_6762[];
extern char at_6763[];
extern char at_6764[];
extern char at_6765[];
extern char at_6766[];
extern char at_6767[];
extern char at_6768[];
extern char at_6769[];
extern char at_6770[];
extern char at_6771[];
extern char at_6772[];
extern char at_6773[];
extern char at_6774[];
extern char at_6775[];
extern char at_6776[];
extern char at_6777[];
extern char at_6778[];
extern char at_6779[];
extern char at_6780[];
extern char at_6781[];
extern char at_6782[];
extern char at_6783[];
extern char at_6784[];
extern char at_6785[];
extern char at_6786[];
extern char at_6787[];
extern char at_6788[];
extern char at_6789[];
extern char at_6790[];
extern char at_6791[];
extern char at_6792[];
extern char at_6793[];
extern char at_6794[];
extern char at_6795[];
extern char at_6796[];
extern char at_6797[];
extern char at_6798[];
extern char at_6799[];
extern char at_6800[];
extern char at_6801[];
extern char at_6802[];
extern char at_6803[];
extern char at_6804[];
extern char at_6805[];
extern char at_6806[];
extern char at_6807[];
extern char at_6808[];
extern char at_6809[];
extern char at_6810[];
extern char at_6811[];
extern char at_6812[];
extern char at_6813[];
#ifdef NONMATCHING
static inline void DebugPrint(CMenuFont *font, char *text, int x, int y) {
    font->SetStr(text);
    font->SetPos(x, y);
    font->DrawDirect(font->str, font->pos_x, font->pos_y);
}
void MenuItemDebugDraw(void) {
    CMenuFont menu_font;
    mgCTextureManager *tex_manager = &mgTexManager;
    CMenuFont *font = &menu_font;
    mgCDrawPrim prim;
    CGameDataUsed *weapon = CMenuItemInfoPt->view_weapon;
    char text[0x100];
    switch (CMenuItemInfoPt->key_arg_no) {
    case 2: {
        tex_manager->ReloadTexture(MenuCommonInfo->tex_block[1], (sceVif1Packet *)NULL);
        SetSpriteEnv(&prim, 2);
        prim.Begin(6);
        prim.Color(0, 0, 0, 0x40);
        prim.Vertex(0, 0, 0);
        prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
        prim.Color(0, 0, 0, 0x80);
        prim.Vertex(20, 60, 0);
        prim.Vertex(276, 316, 0);
        prim.End();
        SetSpriteEnv(&prim, 0);
        u8 color[4] = {0x80, 0x80, 0x80, 0x80};
        int page = (CMenuItemInfoPt->debug_item_no - 1) / 64;
        for (int row = 0; row < 8; row++) {
            for (int col = 0; col < 8; col++) {
                int item_no = page * 64 + 1 + row * 8 + col;
                if (item_no == CMenuItemInfoPt->debug_item_no) {
                    int x = col * 32 + 24;
                    int y = row * 32 + 60;
                    SetSpriteEnv(&prim, 2);
                    prim.Begin(6);
                    prim.Color(0x40, 0x40, 0x40, 0x94);
                    prim.Vertex(x, y, 0);
                    prim.Vertex(x + 32, y + 32, 0);
                    prim.End();
                    SetSpriteEnv(&prim, 0);
                }
                DrawOneItem(&prim, mgRect<float>(col * 32 + 24, row * 32 + 60, 32.0f, 32.0f), item_no, 0, NULL, color, 0);
            }
        }
        tex_manager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
        DrawMenuFillBox(20.0f, 40.0f, 340.0f, 20.0f, 0x60, 0, 0, 0);
        char title[0x80];
        CMenuItemInfo *info = CMenuItemInfoPt;
        sprintf(title, at_6760, CMenuItemInfoPt->debug_item_no, GetItemMessage(info->debug_item_no),
                info->unk_300);
        DebugPrint(font, title, 26, 40);
        if (MenuDebugModelDrawFlag == 1) {
            DrawMenuFillBox(0.0f, 0.0f, mgScreenWidth, mgScreenHeight, 0x80, 0, 0, 0);
        }
        DrawMenuFillBox(20.0f, 330.0f, 500.0f, 200.0f, 0x52, 0, 0, 0);
        if (MenuDebugModelDrawFlag == 0) {
            DebugPrint(font, at_6761, 20, 350);
            DebugPrint(font, at_6762, 20, 370);
            DebugPrint(font, at_6763, 20, 390);
            DebugPrint(font, at_6764, 170, 370);
            char *file_name = GetItemFileName(CMenuItemInfoPt->debug_item_no, 0);
            if (file_name != NULL) {
                char file_text[0x80];
                sprintf(file_text, at_6765, file_name);
                DebugPrint(font, file_text, 150, 330);
            } else {
                DebugPrint(font, at_6766, 150, 330);
            }
            DebugPrint(font, at_6767, 20, 330);
            strcpy(text, at_6768);
            if (debug_common_data != NULL) {
                sprintf(text, at_6769, debug_common_data->max_num);
                DebugPrint(font, text, 300, 350);
                sprintf(text, at_6770, debug_common_data->file_name);
                DebugPrint(font, text, 300, 370);
                sprintf(text, at_6771, CheckGetItemRemainNum(debug_common_data->item_no));
                DebugPrint(font, text, 300, 390);
            }
        } else {
            DebugPrint(font, at_6772, 290, 60);
            DebugPrint(font, at_6773, 290, 80);
            DebugPrint(font, at_6774, 290, 100);
            DebugPrint(font, at_6775, 290, 120);
            char size_text[0x40];
            sprintf(size_text, at_6776, MenuDebugSize);
            DebugPrint(font, size_text, 290, 140);
            if (debug_common_data == NULL && MenuDebugItemModel != NULL) {
                DebugPrint(font, at_6777, 290, 20);
            }
        }
        if (MenuDebugModelDrawFlag != 0) {
            if (MenuDebugCamera != NULL && MenuDebugItemModel != NULL) {
                sceVu0FVECTOR rotation;
                sceVu0FVECTOR scale;
                MenuDebugItemModel->GetRotation(rotation);
                MenuDebugItemModel->GetScale(scale);
                sprintf(text, at_6778, scale[0]);
                DebugPrint(font, text, 290, 260);
                sprintf(text, at_6779, rotation[0], rotation[1], rotation[2]);
                DebugPrint(font, text, 290, 280);
                sceVu0FVECTOR camera_pos;
                sceVu0FMATRIX camera_matrix;
                sceVu0FMATRIX world_matrix;
                sceVu0FMATRIX unit_matrix;
                MenuDebugCamera->GetCameraMatrix(camera_matrix);
                MenuDebugCamera->GetPos(camera_pos);
                sceVu0UnitMatrix(unit_matrix);
                sceVu0MulMatrix(world_matrix, unit_matrix, camera_matrix);
                tex_manager->ReloadTexture(CMenuItemInfoPt->tex_block[4], (sceVif1Packet *)NULL);
                MenuDebugItemModel->Step();
                MenuDebugItemModel->DrawDirect();
            } else {
                DebugPrint(font, at_6780, 290, 260);
            }
        }
        break;
    }
    case 3: {
        DrawMenuFillBox(236.0f, 60.0f, 230.0f, 200.0f, 0x80, 0, 0, 0);
        DebugPrint(font, at_6781, 236, 60);
        DebugPrint(font, at_6782, 236, 80);
        DebugPrint(font, at_6783, 236, 100);
        DebugPrint(font, at_6784, 236, 120);
        DebugPrint(font, at_6785, 236, 140);
        DebugPrint(font, at_6786, 236, 160);
        DebugPrint(font, at_6787, 236, 180);
        int attribute = MenuUserDataManPtr->GetCharaStatusAttirbute(CMenuItemInfoPt->sub_view);
        char status[0x100] = "Status : ";
        int count = 0;
        for (int i = 0; i < 6; i++) {
            if (attribute & (1 << i)) {
                if (count == 3) {
                    strcat(status, at_6788);
                }
                strcat(status, attrtable_6472[i]);
                count++;
            }
        }
        DebugPrint(font, status, 236, 200);
        break;
    }
    case 4: {
        DrawMenuFillBox(236.0f, 60.0f, 230.0f, 300.0f, 0x80, 0, 0, 0);
        DebugPrint(font, at_6789, 236, 60);
        DebugPrint(font, at_6790, 236, 80);
        DebugPrint(font, at_6791, 236, 100);
        DebugPrint(font, at_6792, 236, 120);
        int build_item[3];
        char *build_name[3];
        if (weapon != NULL) {
            sprintf(text, at_6793, (int)weapon->data.weapon.abs.now, (int)weapon->data.weapon.abs.max);
            DebugPrint(font, text, 336, 120);
            CheckBuildUp(weapon, NULL, build_item, NULL);
            for (int i = 0; i < 3; i++) {
                build_name[i] = GetItemMessage(build_item[i]);
            }
        }
        DebugPrint(font, at_6794, 236, 140);
        DebugPrint(font, at_6795, 236, 160);
        DebugPrint(font, at_6796, 236, 180);
        DebugPrint(font, at_6797, 236, 200);
        DebugPrint(font, at_6798, 236, 220);
        DebugPrint(font, at_6799, 236, 240);
        DebugPrint(font, at_6800, 236, 260);
        for (int i = 0; i < 3; i++) {
            char *name = build_name[i];
            sprintf(text, at_6801, i + 1, name);
            if (name != NULL) {
                sprintf(text, at_6802, i + 1, name);
            }
            DebugPrint(font, text, 236, i * 20 + 280);
        }
        break;
    }
    case 5: {
        if (weapon == NULL) {
            break;
        }
        DrawMenuFillBox(236.0f, 60.0f, 230.0f, 260.0f, 0x80, 0, 0, 0);
        DebugPrint(font, at_6803, 236, 60);
        DebugPrint(font, at_6804, 236, 100);
        DebugPrint(font, at_6805, 236, 120);
        char special[0x100];
        special[0] = '\0';
        int count = 0;
        for (int i = 0; i < 12 && stchar_6508[i] != NULL; i++) {
            if (weapon->data.weapon.special & (1 << i)) {
                strcat(special, stchar_6508[i]);
                count++;
                if (count % 4 == 3) {
                    strcat(special, at_6806);
                }
            }
        }
        DebugPrint(font, at_6807, 236, 140);
        DebugPrint(font, special, 236, 160);
        break;
    }
    case 6:
        DrawMenuFillBox(236.0f, 60.0f, 230.0f, 260.0f, 0x80, 0, 0, 0);
        DebugPrint(font, at_6792, 236, 80);
        DebugPrint(font, at_6808, 236, 100);
        DebugPrint(font, at_6809, 236, 120);
        DebugPrint(font, at_6810, 236, 140);
        break;
    case 7: {
        DrawMenuFillBox(236.0f, 60.0f, 230.0f, 260.0f, 0x80, 0, 0, 0);
        int cursor = MenuCommonInfo->cursor;
        if (cursor == 0) {
            DebugPrint(font, at_6811, 236, 60);
            DebugPrint(font, at_6812, 236, 80);
        }
        if (cursor == 1) {
            DebugPrint(font, at_6813, 236, 60);
            DebugPrint(font, at_6812, 236, 80);
        }
        break;
    }
    case 0:
    case 1:
    case 8:
    case 9:
    case 10:
    case 11:
        break;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemDebugDraw__Fv);
#endif
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
extern float WeaponWarningCounter;
extern char *whptbl_7376[2][2];
extern char at_7438[];
extern char at_7439[];
extern char at_7440[];
extern char at_7441[];
extern char at_7442[];
extern char at_7443[];
#ifdef NONMATCHING
void MenuItemCharaActWepInfoDraw(CMenuPosDataForm *form, CGameDataUsed *equip, int chara_no, int flag) {
    CItemUseTarget target;
    int blink = (int)(64.0f * sinf(WeaponWarningCounter));
    for (int i = 0; i < 2; i++) {
        int red = 0x80;
        CGameDataUsed *weapon = &equip[i];
        MENUFORMPARTS_TYPE *batu = CMenuItemInfoPt->wep_parts[chara_no][i * 6 + 9];
        int green = 0x80;
        if (batu != NULL) {
            batu->draw_flag = 0;
        }
        int item_no = weapon->item_no;
        int whp[2];
        float rate = weapon->GetWHp(whp);
        if (rate < 0.2f && item_no > 0) {
            red = 0x80 - blink;
            green = red;
            if (rate == 0.0f) {
                red = blink + 0x80;
                if (batu != NULL) {
                    batu->draw_flag = 1;
                }
            }
        }
        for (int k = 0; k < 6; k++) {
            MENUFORMPARTS_TYPE *part = CMenuItemInfoPt->wep_parts[chara_no][i * 6 + 4 + k];
            part->rgba[0] = red;
            part->rgba[1] = green;
            part->rgba[2] = green;
        }
        MENUFORMPARTS_TYPE *icon = CMenuItemInfoPt->wep_parts[chara_no][i * 6 + 8];
        local_item_infoview_set(icon, weapon);
        target.SetPtr(ITEM_USE_TARGET_ITEM, weapon);
        icon->item_flag = 0;
        icon->item_flag = CheckItemUseVariable(&MenuCommonInfo->have_item, &target);
        form->SetNumber(whptbl_7376[i][0], whp[0]);
        form->SetNumber(whptbl_7376[i][1], whp[1]);
        char name[0x20];
        sprintf(name, at_7438, i);
        MENUFORMPARTS_TYPE *bar = form->GetPartInfo(name);
        if (bar != NULL) {
            bar->w = (int)(95.0f * rate);
        }
        sprintf(name, at_7439, i);
        bar = form->GetPartInfo(name);
        if (bar != NULL) {
            bar->w = (int)(95.0f * GetCommonGageRate(&weapon->data.weapon.abs));
        }
    }
    if (chara_no == 0) {
        int is_rod = equip->IsFishingRod();
        CGameDataUsed *esa = MenuUserDataManPtr->GetActiveEsa();
        int esa_num = 0;
        if (is_rod) {
            MENUFORMPARTS_TYPE *esa_part = form->GetPartInfo(at_4985);
            if (esa_part != NULL) {
                esa_part->etc_info[1] = esa->item_no;
            }
            esa_num = esa->GetNum();
        }
        bool show = is_rod != 0;
        form->SetPartDrawFlag(at_7440, show);
        form->SetPartDrawFlag(at_4985, show);
        form->SetPartDrawFlag(at_7441, show);
        form->SetPartDrawFlag(at_7442, show);
        form->SetNumber(at_7443, esa_num);
        if (is_rod && MenuUserDataManPtr->GetFishingRodNo() == 0x12E) {
            form->SetPartDrawFlag(at_7442, false);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemCharaActWepInfoDraw__FP16CMenuPosDataFormP13CGameDataUsedii);
#endif
extern char at_7478[];
void MenuItemCharaViewCheck(CHARA_DATA *chara, int chara_no, int flag) {
    CMenuPosDataForm *form = CMenuItemInfoPt->view_form[chara_no];
    if (form->draw_flag != 0 && form->rgba[3] > 0) {
        int blink = (int)(64.0f * sinf(WeaponWarningCounter));
        float hp_rate = GetCommonGageRate(&chara->hp);
        MENUFORMPARTS_TYPE *hp_bar = CMenuItemInfoPt->hp_bar[chara_no];
        if (hp_bar != NULL) {
            hp_bar->w = (int)(168.0f * hp_rate);
            if (168.0f < hp_bar->w) {
                hp_bar->w = 168.0f;
            }
            hp_bar->rgba[0] = 0x80;
            hp_bar->rgba[1] = 0x80;
            hp_bar->rgba[2] = 0x80;
            if (hp_rate < 0.2f) {
                hp_bar->rgba[0] = blink + 0x80;
                hp_bar->rgba[1] = hp_bar->rgba[2] = 0x80 - blink;
            }
        }
        form->SetNumber(at_3823, GetDispVolumeForFloat(chara->hp.now));
        form->SetNumber(at_3824, (int)chara->hp.max);
        for (int i = 0; i < 3; i++) {
            MENUFORMPARTS_TYPE *icon = CMenuItemInfoPt->item_parts[chara_no][i];
            if (icon != NULL) {
                icon->etc_info[1] = chara->active_item[i].item_no;
                MENUFORMPARTS_TYPE *num = CMenuItemInfoPt->item_num[chara_no][i];
                num->etc_info[1] = chara->active_item[i].GetNum();
                if (menu_chara_activeItem_limmit_check[chara_no * 3 + i] != 0) {
                    num->rgba[0] = 0x52;
                    num->rgba[1] = 0x52;
                    num->rgba[2] = 0x94;
                } else {
                    num->rgba[0] = 0x80;
                    num->rgba[1] = 0x80;
                    num->rgba[2] = 0x80;
                }
            }
        }
        form->SetNumber(at_7478, MenuUserDataManPtr->GetDefenceVol(chara_no));
        MenuItemCharaActWepInfoDraw(form, chara->equip, chara_no, flag);
    }
}
extern char at_7534[];
extern char at_7539[];
extern char at_7535[];
extern char at_7536[];
extern char at_7537[];
extern char at_7538[];
extern char at_7541[];
extern float counter_7509;
extern s8 init_7510;
#ifdef NONMATCHING
void MenuPosFormValueSetCharaRobo(ROBO_DATA *robo, int flag) {
    if (robo == NULL) {
        return;
    }
    CMenuPosDataForm *form = CMenuItemInfoPt->view_form[3];
    if (form == NULL) {
        return;
    }
    int red = 0x80;
    int green = 0x80;
    int blink = (int)(64.0f * sinf(WeaponWarningCounter));
    CGameDataUsed *parts = robo->parts;
    MENUFORMPARTS_TYPE *hp_part = form->GetPartInfo(at_3822);
    if (hp_part != NULL) {
        hp_part->w = (int)(140.0f * GetCommonGageRate(&robo->hp));
    }
    MENUFORMPARTS_TYPE *hp_end = form->GetPartInfo(at_7534);
    if (hp_end != NULL && hp_part != NULL) {
        hp_end->x = hp_part->x + hp_part->w - 4.0f;
        hp_end->y = hp_part->y - 10.0f;
    }
    form->SetNumber(at_3823, GetDispVolumeForFloat(robo->hp.now));
    form->SetNumber(at_3824, (int)robo->hp.max);
    int capacity = 0;
    form->SetNumber(at_7535, CheckNowRoboUseCapacity(&capacity));
    form->SetNumber(at_7536, capacity);
    s16 part_defence = MenuUserParam.robo->parts[1].data.robopart.defence;
    int defence = MenuUserParam.robo->GetDefenceVol();
    form->SetNumber(at_7537, GetShiledKitLimmit(MenuUserDataManPtr->CheckRobotCore()) * 4);
    form->SetNumber(at_7538, defence - part_defence);
    form->SetNumber(at_7478, part_defence);
    local_item_infoview_set(form->GetPartInfo(at_5265), parts);
    int whp[2];
    float rate = parts->GetWHp(whp);
    if (rate < 0.2f) {
        red = 0x80 - blink;
        green = red;
        if (rate == 0.0f) {
            red = blink + 0x80;
        }
    }
    for (int i = 0; i < 6; i++) {
        CMenuItemInfoPt->robo_parts[i]->rgba[0] = red;
        CMenuItemInfoPt->robo_parts[i]->rgba[1] = green;
        CMenuItemInfoPt->robo_parts[i]->rgba[2] = green;
    }
    form->SetNumber(at_5262, whp[0]);
    form->SetNumber(at_5264, whp[1]);
    MENUFORMPARTS_TYPE *whp_bar = form->GetPartInfo(at_7539);
    if (whp_bar != NULL) {
        whp_bar->w = (int)(108.0f * rate);
    }
    MENUFORMPARTS_TYPE *batu = form->GetPartInfo(at_5266);
    if (batu != NULL) {
        batu->draw_flag = 0;
        if (rate == 0.0f) {
            batu->draw_flag = 1;
        }
    }
    local_item_infoview_set(form->GetPartInfo(at_7540), &parts[2]);
    if (CMenuItemInfoPt->voice_part != NULL) {
        if (!init_7510) {
            counter_7509 = 0.0f;
            init_7510 = 1;
        }
        counter_7509 += 1.0f;
        if (!(counter_7509 <= 44.0f)) {
            counter_7509 = 0.0f;
        }
        CMenuItemInfoPt->voice_part->draw_flag = robo->voice_unit != 0;
        CMenuItemInfoPt->voice_part->x = 150.0f;
        CMenuItemInfoPt->voice_part->y = -252.0f;
        if (robo->voice_flag != 0) {
            float sway = 8.0f * sinf(0.06981317f * counter_7509);
            CMenuItemInfoPt->voice_part->x += sway;
            CMenuItemInfoPt->voice_part->y -= sway;
        }
    }
    form->SetNumber(at_7541, GetDispVolumeForFloat(robo->abs.now));
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuPosFormValueSetCharaRobo__FP9ROBO_DATAi);
#endif
extern char at_7560[];
extern char at_7561[];
extern char at_7562[];
extern char at_7563[];
extern char at_7564[];
void MenuPosFormValueSetMonster(MOS_CHANGE_PARAM *monster, CHARA_DATA *chara) {
    CMenuPosDataForm *form = CMenuItemInfoPt->view_form[4];
    if (form == NULL || monster == NULL || chara == NULL) {
        return;
    }
    MENUFORMPARTS_TYPE *part;
    MOS_CHANGE_PARAM *mos = &monster[get_gajji_id_from_monster_progress_table(CMenuItemInfoPt->mos_id, NULL)];
    part = form->GetPartInfo(at_3822);
    if (part != NULL) {
        part->w = (int)(168.0f * GetCommonGageRate(&chara->hp));
    }
    form->SetNumber(at_3823, GetDispVolumeForFloat(chara->hp.now));
    form->SetNumber(at_3824, (int)chara->hp.max);
    form->SetNumber(at_7560, mos->GetAttackVol(-1));
    form->SetNumber(at_7561, mos->GetDefenceVol(-1));
    part = form->GetPartInfo(at_7539);
    if (part != NULL) {
        part->w = (int)(140.0f * GetCommonGageRate(&mos->hp));
    }
    form->SetNumber(at_7562, GetDispVolumeForFloat(mos->hp.now));
    form->SetNumber(at_7563, (int)mos->hp.max);
    part = form->GetPartInfo(at_7564);
    if (part != NULL) {
        part->w = (int)(140.0f * mos->abs.GetRate());
    }
}
int CheckBuildUp(CGameDataUsed *weapon, int *result0, int *result1, int *result2) {
    if (weapon != NULL) {
        return weapon->IsBuildUp(result0, result1, result2);
    }
    return 0;
}
int BuildUpWeaponTrans(CGameDataUsed *item, int item_no) {
    CDataWeapon *data = GameItemDataManage.GetWeaponData(item_no);
    if (item == NULL) {
        return 0;
    }
    if (data == NULL) {
        return 0;
    }
    int old_item_no = item->item_no;
    item->item_no = item_no;
    item->item_type = GameItemDataManage.GetDataType(item_no);
    WEAPON_USED *weapon = &item->data.weapon;
    if (strcmp(item->GetName(0), GetItemMessage(old_item_no)) == 0) {
        item->SetName(GetItemMessage(item_no));
    }
    weapon->level = 0;
    float rate = 0.0f;
    if (weapon->abs.max != 0.0f) {
        rate = weapon->abs.now / weapon->abs.max;
    }
    weapon->abs.max = data->levelup_exp;
    weapon->abs.now = data->levelup_exp * rate;
    weapon->status[0] += 0.1f * data->status[0];
    for (int i = 0; i < 8; i++) {
        weapon->attribute[i] += 0.1f * data->attribute[i];
    }
    weapon->special = CheckWeaponAttribute(weapon->special, data->special);
    item->CheckParamLimmit();
    GetSaveData()->SetBitFlag(0x31, 1);
    return 1;
}
void BuildUpWeaponNameBoardDraw(mgCDrawPrim *prim, float x, float y, int width) {
    mgRect<int> left_rect(0xAC, 0x76, 8, 0x20);
    mgRect<int> middle_rect(0xB4, 0x76, 4, 0x20);
    mgRect<int> right_rect(0xB8, 0x76, 8, 0x20);
    PrimQuad(prim, x, y, left_rect);
    mgRect<int> put_rect(x + 8.0f, y, width - 16, 0x20);
    PrimQuad(prim, put_rect, middle_rect);
    PrimQuad(prim, x + width - 8.0f, y, right_rect);
}
extern s16 backboard_table_x_7625[5];
extern u8 backboard_table_y_7626[3];
extern s8 backboard_table_w_7627[5];
extern s8 backboard_x_repeat_drawnum_7628[5];
extern s8 backboard_y_repeat_drawnum_7629[3];
extern s16 mos_repeat_table_x_7694[5];
extern char *strtbl_7727[7];
#ifdef NONMATCHING
#pragma divbyzerocheck on
void MenuWeaponBuildUpDraw(int &tex_block) {
    if (BuildUpWeaponInfo.mode == 0) {
        return;
    }
    CDC2Mes *mes = MenuDCMsg[6];
    int top_y = 30;
    if (BuildUpWeaponInfo.unk_0 == 0) {
    } else if (BuildUpWeaponInfo.unk_0 == 1) {
        top_y = 80;
    }
    if (mes == NULL) {
        return;
    }
    MenuReloadTexture(tex_block, Tex_BuildUpBoard->block);
    mgRect<int> unused_rect(0x96, 0x82, 0x16, 0x14);
    mgRect<int> line_left_rect(0x9A, 0x7C, 4, 6);
    mgRect<int> line_middle_rect(0x9E, 0x7C, 4, 6);
    mgRect<int> line_right_rect(0xA2, 0x7C, 4, 6);
    mgRect<int> bar_top_rect(0xA6, 0x76, 6, 4);
    mgRect<int> bar_middle_rect(0xA6, 0x7A, 6, 4);
    mgRect<int> bar_bottom_rect(0xA6, 0x7E, 6, 4);
    int y = top_y;
    int height = 0;
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(Tex_BuildUpBoard);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    int row;
    for (row = 0; row < 3; row++) {
        for (int n = 0; n < backboard_y_repeat_drawnum_7629[row]; n++) {
            int x = 20;
            for (int col = 0; col < 5; col++) {
                mgRect<int> tile(backboard_table_x_7625[col], backboard_table_y_7626[row],
                                 backboard_table_w_7627[col], 28);
                for (int k = 0; k < backboard_x_repeat_drawnum_7628[col]; k++) {
                    PrimQuad(prim, x, y, tile);
                    x += tile.right;
                }
            }
            y += 28;
            height += 28;
        }
    }
    prim->End();
    int name_x = 0x3A;
    int name_w = 0xAC;
    int center_y = top_y + ((height - 28) >> 1);
    int msg_x = 0x46;
    int list_msg_x = 0x130;
    int list_y[3] = {0};
    int list_x = 0x124;
    if (LanguageCode > 0) {
        list_x = 0x11A;
        name_x = 0x32;
        name_w = 0xBE;
        msg_x = 0x3A;
        list_msg_x = 0x122;
    }
    int num = BuildUpWeaponInfo.select_num;
    int list_name_x = list_x - 20;
    int step = (height - 40) / num;
    float center = 0.5f * (num - 1.0f);
    for (int i = 0; i < num; i++) {
        list_y[i] = center_y - step * (center - i);
    }
    int name_y;
    if (num % 2 == 1) {
        name_y = list_y[(num - 1) / 2];
    } else {
        name_y = list_y[0] + (list_y[num - 1] - list_y[0]) / 2.0f;
    }
    int bar_h = step * (num - 1);
    int bar_y = list_y[0] + 14;
    prim->Begin(6);
    prim->Texture(Tex_BuildUpBoard);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    if (BuildUpWeaponInfo.unk_0 == 0) {
        float title_y = top_y + 38;
        mgRect<int> title_rect(0xBE, 0x24, 0x6C, 0x1A);
        if (LanguageCode > 0) {
            title_rect.left = 0xC8;
        }
        PrimQuad(prim, 48.0f, title_y, title_rect);
    }
    if (BuildUpWeaponInfo.unk_0 == 1) {
        float title_y = top_y + 38;
        mgRect<int> title_rect(0xBE, 0x40, 0x6C, 0x1A);
        if (LanguageCode > 0) {
            title_rect.left = 0xC8;
        }
        PrimQuad(prim, 48.0f, title_y, title_rect);
    }
    BuildUpWeaponNameBoardDraw(prim, name_x, name_y, name_w);
    int i;
    for (i = 0; i < BuildUpWeaponInfo.select_num; i++) {
        BuildUpWeaponNameBoardDraw(prim, list_x, list_y[i], name_w);
    }
    prim->End();
    mes->SetMovePosGyou(0, 0x208, 0);
    mes->SetMovePosGyou(1, msg_x, name_y + 5);
    for (i = 0; i < 3; i++) {
        BuildUpNameXY[i][0] = list_name_x;
        BuildUpNameXY[i][1] = list_y[i] + 5;
        MenuDCMsg[6]->SetMovePosGyou(i + 2, list_msg_x, BuildUpNameXY[i][1]);
    }
    prim->Begin(6);
    prim->Texture(Tex_BuildUpBoard);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    for (i = 0; i < BuildUpWeaponInfo.select_num; i++) {
        int line_y = list_y[i] + 12;
        PrimQuad(prim, 258.0f, line_y, line_left_rect);
        mgRect<int> line_rect(0x106, line_y, list_x - 0x104, 6);
        PrimQuad(prim, line_rect, line_middle_rect);
        PrimQuad(prim, list_x, line_y, line_right_rect);
    }
    if (0 < BuildUpWeaponInfo.select_num) {
        PrimQuad(prim, 256.0f, bar_y, bar_top_rect);
        mgRect<int> bar_rect(0x100, bar_y + 4, 6, bar_h - 4);
        PrimQuad(prim, bar_rect, bar_middle_rect);
        PrimQuad(prim, 256.0f, bar_y + bar_h, bar_bottom_rect);
    }
    int line_y = name_y + 12;
    int line_x = name_x + name_w;
    PrimQuad(prim, line_x, line_y, line_left_rect);
    mgRect<int> line_rect(line_x + 4, line_y, 0x100 - line_x, 6);
    PrimQuad(prim, line_rect, line_middle_rect);
    PrimQuad(prim, 256.0f, line_y, line_right_rect);
    prim->End();
    if (BuildUpWeaponInfo.unk_0 == 0) {
        int mos_name_x = 0x11E;
        int mark_x = 0x10A;
        CDataWeapon *data = BuildUpWeaponInfo.weapon_data[BuildUpWeaponInfo.select_no];
        char *mos_names[3] = {NULL};
        int mos_y = mgScreenHeight - 180;
        int board_y = mos_y - 30;
        if (LanguageCode > 0) {
            mos_name_x = 0x114;
            mark_x = 0x102;
        }
        int text_x = mos_name_x + 6;
        if (data != NULL && 0 <= data->buildup_monster[0]) {
            s8 mos_rows[3] = {1, 4, 1};
            if (LanguageCode == 2) {
                mos_rows[1] = 5;
            }
            SetSpriteEnv(prim, 0);
            prim->Begin(6);
            prim->Texture(Tex_BuildUpBoard);
            prim->Color(0x80, 0x80, 0x80, 0x80);
            for (row = 0; row < 3; row++) {
                for (int n = 0; n < mos_rows[row]; n++) {
                    int x = 232;
                    for (int col = 0; col < 5; col++) {
                        mgRect<int> tile(backboard_table_x_7625[col], backboard_table_y_7626[row],
                                         backboard_table_w_7627[col], 28);
                        for (int k = 0; k < mos_repeat_table_x_7694[col]; k++) {
                            PrimQuad(prim, x, board_y, tile);
                            x += tile.right;
                        }
                    }
                    board_y += 28;
                    height += 28;
                }
            }
            int mark_y = mos_y;
            for (i = 0; i < 3; i++) {
                mos_names[i] = GetMonsterName(data->buildup_monster[i]);
                if (mos_names[i] != NULL) {
                    BuildUpWeaponNameBoardDraw(prim, mos_name_x, mark_y, name_w);
                    int mark_u = 0x15A;
                    if (0 < KillMonsterCount(data->buildup_monster[i], 0)) {
                        mark_u = 0x16A;
                    }
                    mgRect<int> mark_rect(mark_u, 0xD0, 16, 16);
                    PrimQuad(prim, mark_x, mark_y + 7, mark_rect);
                }
                mark_y += 32;
            }
            prim->End();
        }
        MenuReloadTexture(tex_block, mes->texture_block);
        mes->DrawMsg();
        if (mos_names[0] != NULL) {
            int text_y = mos_y + 4;
            CMenuFont font;
            for (i = 0; i < 3; i++) {
                if (mos_names[i] != NULL) {
                    font.SetStr(mos_names[i]);
                    font.SetPos(text_x, text_y);
                    font.DrawDirect(font.str, font.pos_x, font.pos_y);
                }
                text_y += 32;
            }
            int note_y = mos_y + 100;
            int note_x = 0x100;
            if (LanguageCode == 1) {
                note_x += 0x12;
            } else if (CheckNowEurope()) {
                font.SetStr(strtbl_7727[LanguageCode]);
                int w;
                int h;
                font.CalcDrawWH(font.str, &w, &h);
                note_x = 0x167 - w / 2;
            }
            font.SetStr(strtbl_7727[LanguageCode]);
            font.SetPos(note_x, note_y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
        }
    }
    if (BuildUpWeaponInfo.unk_0 == 1) {
        MenuReloadTexture(tex_block, mes->texture_block);
        mes->DrawMsg();
    }
}
#pragma divbyzerocheck reset
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuWeaponBuildUpDraw__FRi);
#endif
extern s8 count_7867;
extern s8 init_7868;
void MenuWeaponStatusInfoFormSet(CGameDataUsed *item, CDataWeapon *data) {
    int i;
    if (CMenuItemInfoPt->view_form[2] == NULL) {
        return;
    }
    for (i = 0; i < 10; i++) {
        BuildUpFormInfoIndex[i]->rgba[0] = 0x80;
        BuildUpFormInfoIndex[i]->rgba[1] = 0x80;
        BuildUpFormInfoIndex[i]->rgba[2] = 0x80;
    }
    if (!init_7868) {
        count_7867 = 0;
        init_7868 = 1;
    }
    count_7867++;
    bool blink = false;
    if (count_7867 > 25) {
        blink = true;
    }
    if (count_7867 > 50) {
        count_7867 = 0;
    }
    if (data != NULL) {
        WEAPON_USED *weapon = &item->data.weapon;
        if (weapon->status[0] < 0.9f * data->status[0]) {
            if (blink) {
                BuildUpFormInfoIndex[0]->rgba[0] = 0xC0;
                BuildUpFormInfoIndex[0]->rgba[1] = 0x40;
                BuildUpFormInfoIndex[0]->rgba[2] = 0x40;
            }
        }
        for (i = 0; i < 8; i++) {
            if (weapon->attribute[i] < 0.9f * data->attribute[i]) {
                if (blink) {
                    BuildUpFormInfoIndex[i + 2]->rgba[0] = 0xC0;
                    BuildUpFormInfoIndex[i + 2]->rgba[1] = 0x40;
                    BuildUpFormInfoIndex[i + 2]->rgba[2] = 0x40;
                }
            }
        }
    }
}
extern s8 argtblno_7927[][6];
extern s8 sel_7928[][6];
extern s8 conv_7932[];
#ifdef NONMATCHING
#pragma divbyzerocheck on
int MenuItemSelectDiffer(int select) {
    if (CMenuItemInfoPt->unk_160) {
        return 0;
    }
    CMenuKeyFunc *key = MenuCommonInfo;
    MENU_INPUTKEY_ARG *arg = &item_menu_argtbl[select];
    key->key_arg = arg;
    int prev_arg_no = CMenuItemInfoPt->key_arg_no;
    switch (prev_arg_no) {
        case 2: {
            s16 line = key->cursor / item_menu_argtbl[2].disp_columns - key->top_line;
            select = argtblno_7927[CMenuItemInfoPt->view_mode][line];
            key->key_arg = &item_menu_argtbl[select];
            key->top_line = 0;
            key->cursor = sel_7928[CMenuItemInfoPt->view_mode][line];
            break;
        }
        default:
            switch (select) {
                case 2: {
                    int line_offset = conv_7932[prev_arg_no];
                    key->top_line = MenuItem_ItemBoardTopLine;
                    key->cursor = key->key_arg->disp_columns * (key->top_line + line_offset);
                    break;
                }
                case 0:
                case 1:
                    if (key->cursor >= 3) {
                        key->cursor = 2;
                    }
                    if (CMenuItemInfoPt->key_arg_no == 3) {
                        key->cursor = 0;
                    }
                    break;
                case 3:
                case 4:
                case 6:
                case 9:
                    key->cursor = 0;
                    key->top_line = 0;
                    break;
                case 5:
                    key->top_line = 0;
                    if (key->cursor > 1) {
                        key->cursor = 1;
                    }
                    if (key->cursor < 0) {
                        key->cursor = 0;
                    }
                    break;
                case 11:
                    if (GetUserDataMan()->GetActiveEsa() == NULL || CMenuItemInfoPt->view_mode != 0 ||
                        CMenuItemInfoPt->sub_view != 0) {
                        select = 1;
                        key->key_arg = &item_menu_argtbl[1];
                    } else {
                        key->cursor = 0;
                    }
                    break;
                default:
                    key->cursor = 0;
                    break;
            }
            if (key->cursor >= arg->max) {
                key->cursor = arg->max - 1;
            }
            if (key->cursor <= arg->min) {
                key->cursor = arg->min;
            }
            break;
    }
    CMenuItemInfoPt->key_arg_no = select;
    return 1;
}
#pragma divbyzerocheck reset
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemSelectDiffer__Fi);
#endif
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
extern s8 MonicaRotationFlag;
extern float MonicaRotationData[4];
extern char at_8083[];
int CMenuItemInfo::ModelReadStart(int mode, int check_item, int restart_read) {
    int result = 0;
    MenuCharaLoadStack.stReset();
    mgCMemory *load_stack = &MenuCharaLoadStack;
    load_stack->Align64();
    if (check_item) {
        CheckLoadItemNo();
    }
    MenuWeaponEnvSetListNo = -1;
    MonicaRotationFlag = 0;
    MenuWeaponEnvSetChara = 0;
    MenuRepairMan->Clear();
    SetBuildUpInfoChara(NULL, 0.0f);
    if (GetActiveCharaNo() == 2 && mode != 3) {
        equip_flag[0] = 1;
    }
    int i;
    switch (mode) {
        case 0:
        case 1: {
            int chara_no = sub_view;
            if (mode == 0) {
                chara_no = 0;
            }
            if (mode == 1) {
                chara_no = 1;
            }
            if (MenuActionChara[0] != NULL && MenuLoadInfo.unk_4 == 4) {
                MonicaRotationFlag = 1;
                MenuActionChara[0]->GetRotation(MonicaRotationData);
            }
            MenuItemCharaDataLoad(load_stack, chara_no, MenuCharaBuild2, restart_read);
            break;
        }
        case 2:
        case 5: {
            mgCMemory stack;
            int rest = MenuItemMemory.stGetRest();
            stack.stSetBuffer(MenuItemMemory.stGetTop(), rest);
            MenuMemoryAdjust(&stack, &MenuCharaLoadStack, MenuActionCharaBuffer, 0);
            MenuActionCharaBuffer[0].stSetBuffer(stack.stGetTop(), 0x5A00);
            stack.Alloc(0x5000);
            rest = stack.stGetRest();
            load_stack->stSetBuffer(stack.stGetTop(), rest);
            result = MenuItemChrLoad(load_stack, view_chara, 1, MenuCharaBuild2[0], restart_read);
            if (result > 0) {
                for (i = 1; i < 6; i++) {
                    InitMenuBGReadInfo2(MenuCharaBuild2[i]);
                }
            }
            for (int j = 0; j < 6; j++) {
                MenuActionChara[j]->Initialize(NULL);
            }
            break;
        }
        case 3:
            if (MenuLoadInfo.unk_2 == 1) {
                for (int j = 0; j < 7; j++) {
                    if (MenuActionChara[j] != NULL) {
                        MenuActionChara[j]->Initialize(NULL);
                    }
                }
            }
            MenuItemRoboDataLoad(load_stack, MenuCharaBuild2, restart_read);
            break;
        case 4:
            MenuCharaBuild2[1]->reading = 0;
            MenuCharaBuild2[2]->reading = 0;
            MenuCharaBuild2[3]->reading = 0;
            MenuCharaBuild2[4]->reading = 0;
            MenuMonsterLoadBG(load_stack, MenuCharaBuild2, mos_id, restart_read);
            break;
    }
    int model_tex_block = tex_block[5];
    chara_poly_form[0]->draw_flag = 0;
    chara_poly_form[0]->SetActionCharaPtr(NULL, -1, model_tex_block);
    chara_poly_form[0]->counter = -17;
    chara_poly_form[1]->draw_flag = 0;
    chara_poly_form[1]->SetActionCharaPtr(NULL, -1, model_tex_block);
    chara_poly_form[1]->counter = -17;
    CMenuPosDataForm *fill = fill_form;
    fill->rgba[0] = 0x80;
    fill->rgba[1] = 0x80;
    fill->rgba[2] = 0x80;
    fill->rgba[3] = 0x80;
    for (i = 0; i < 4; i++) {
        fill->SetRGBACalcParam(i, 0, 0x80);
    }
    if (this->mode != MENU_ASK_MODE_OPEN) {
        ExeScript(at_8083);
    }
    if (mode == 2 || mode == 5) {
        chara_poly_form[1]->draw_flag = 1;
    }
    return result;
}
void CMenuItemInfo::WeaponBuildCheck(CActionChara *chara, int chara_no, int tex_block) {
    mgCFrame *frame = chara->CObjectFrame::frame;
    ActiveMenuWeaponCharaRange = 4.2f;
    MenuWeaponBasePos[0] = -16.0f;
    MenuWeaponBasePos[1] = 7.5f;
    MenuWeaponBasePos[2] = -10.0f;
    MenuWeaponBasePos[3] = 1.0f;
    if (view_weapon != NULL && view_weapon->used_type == USED_ITEM_TYPE_ROBO_PART) {
        MenuWeaponBasePos[2] = -10.0f;
        ActiveMenuWeaponCharaRange = 6.2f;
        MenuWeaponBasePos[3] = 1.0f;
        MenuWeaponBasePos[0] = -16.7f;
        MenuWeaponBasePos[1] = 7.1f;
    }
    if (view_weapon->IsFishingRod()) {
        MenuWeaponBasePos[0] = -16.0f;
        MenuWeaponBasePos[1] = 3.0f;
        MenuWeaponBasePos[2] = -10.0f;
        MenuWeaponBasePos[3] = 1.0f;
    }
    float scale = MenuAdjustPolygonScale(frame, ActiveMenuWeaponCharaRange);
    chara->SetPosition(MenuWeaponBasePos);
    chara->SetScale(scale, scale, scale);
    chara->Copy(*SpectolFrame, MenuActionCharaBuffer);
    chara_poly_form[1]->SetActionCharaPtr(SpectolFrame, tex_block, -1);
    mgCFrame *spectol_frame = SpectolFrame->CObjectFrame::frame;
    mgCFrameAttr *attr = spectol_frame->attr;
    attr->alpha_blend = MG_ALPHA_MACRO_BLEND;
    attr->obj_alpha = 1.0f;
    spectol_frame->SetAttrParam(*attr, 1, MG_FRAME_ATTR_OBJ_ALPHA | MG_FRAME_ATTR_ALPHA_BLEND);
    ActiveMenuWeaponCharaRange *= 1.2f;
    CActionChara *build_chara = NULL;
    if (0 < view_weapon->IsBuildUp(NULL, NULL, NULL)) {
        build_chara = chara;
    }
    SetBuildUpInfoChara((CCharacter2 *)build_chara, ActiveMenuWeaponCharaRange);
}
extern s8 cnttbl_8130[6];
extern float robo_stand_pos_8151[][3];
extern char at_8199[];
#ifdef NONMATCHING
int CMenuItemInfo::ModelReadEndCheck(void) {
    int result = 0;
    if (MenuLoadFileCheck(MenuCharaBuild2) && ReadBGSync() == 0) {
        int chara_tex_block = MenuArg.chara_tex_block;
        int load_tex_block = tex_block[1];
        switch (view_mode) {
            case 0:
            case 1:
                MenuItemCharaDataLoadEndCheck(MenuCharaBuild2, &MenuCharaLoadStack, MenuActionChara, view_mode,
                                              load_tex_block, chara_tex_block);
                break;
            case 2:
            case 5:
                MenuItemChrLoadEndCheck(MenuCharaBuild2[0], MenuActionChara[0], MenuActionCharaBuffer, load_tex_block);
                for (int i = 0; i < 6; i++) {
                    if (MenuCharaBuild2[i]->chara != NULL) {
                        MenuCharaBuild2[i]->chara->ResetParent();
                    }
                }
                break;
            case 3:
                MenuItemRoboDataLoadEndCheck(MenuCharaBuild2, &MenuCharaLoadStack, MenuActionChara, load_tex_block,
                                             chara_tex_block);
                break;
            case 4:
                MenuMonsterLoadBGCheck(MenuCharaBuild2, MenuActionChara, load_tex_block, chara_tex_block);
                if (MenuCharaBuild2[0]->reading == 0) {
                    MenuCharaBuild2[1]->reading = 0;
                    MenuCharaBuild2[2]->reading = 0;
                    MenuCharaBuild2[3]->reading = 0;
                    MenuCharaBuild2[4]->reading = 0;
                    MenuCharaBuild2[5]->reading = 0;
                }
                break;
        }
        MenuCommonInfo->key_enable = 1;
        CActionChara *chara = MenuCharaBuild2[0]->chara;
        if (MenuLoadFileCheck(MenuCharaBuild2)) {
            chara_poly_form[0]->counter = cnttbl_8130[view_mode];
        } else {
            chara_poly_form[0]->counter = 13;
            chara->SetScale(1.0f, 1.0f, 1.0f);
            switch (view_mode) {
                case 0:
                case 1:
                    chara->UpdatePosition();
                    for (int i = 0; i < chara->dynamic_anime_num; i++) {
                        chara->dynamic_anime[i].ResetPosition();
                    }
                    chara->SetRotation(0.0f, 0.0f, 0.0f);
                    if (MonicaRotationFlag) {
                        chara->SetRotation(MonicaRotationData);
                    }
                    break;
                case 2:
                case 5:
                    WeaponBuildCheck(chara, view_chara, load_tex_block);
                    break;
                case 3: {
                    chara->SetPosition(-44.0f, -20.0f, -180.0f);
                    CDataRoboPart *core = GetRoboPartInfoData(GetUserDataMan()->robo_data.parts[3].item_no);
                    int offset_no = 0;
                    if (core != NULL) {
                        offset_no = core->GetOffsetNo();
                    }
                    chara->SetPosition(robo_stand_pos_8151[offset_no][0], robo_stand_pos_8151[offset_no][1],
                                       robo_stand_pos_8151[offset_no][2]);
                    MenuRoboPartsLightOff(MenuActionChara[2]->CObjectFrame::frame);
                    break;
                }
                case 4:
                    chara->SetPosition(-34.0f, -18.0f, -120.0f);
                    break;
            }
            chara->Step();
            result = 1;
            chara_poly_form[0]->draw_flag = 1;
            chara_poly_form[0]->SetActionCharaPtr(chara, load_tex_block, tex_block[5]);
            MenuWeaponEnvSetChara = NULL;
            MenuWeaponEnvSetListNo = -1;
            if (view_mode == 1) {
                MenuWeaponEnvSetChara = MenuActionChara[0];
                MenuWeaponEnvSetListNo = MenuLoadItemNo[0];
            }
            if (view_mode == 2) {
                MenuWeaponEnvSetChara = MenuActionChara[0];
                if (view_weapon != NULL) {
                    MenuWeaponEnvSetListNo = view_weapon->item_no;
                }
            }
            MenuTimeStepEnvFunc(MenuMainScene, MenuWeaponEnvSetChara, MenuWeaponEnvSetListNo);
        }
        MenuCharaLoadStack.stReset();
        ExeScript(at_8083);
    }
    if (mode != MENU_ASK_MODE_CLOSE) {
        if (chara_poly_form[0]->draw_flag == 1 && chara_poly_form[0]->counter >= 14) {
            ExeScript(at_8199);
        }
    }
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", ModelReadEndCheck__13CMenuItemInfoFv);
#endif
void CMenuItemInfo::SearchEffectDisplayPosition(int *position, CGameDataUsed *item) {
    int item_index = GetSameAdrressUserData(item, 0);
    if (0 <= item_index) {
        MenuPosData->GetPosMenuItemBrdKoma(MenuRepairTargetWeaponPos, item_index, 0);
        int item_line = item_index / 6;
        if (item_line < MenuItem_ItemBoardTopLine || MenuItem_ItemBoardTopLine + 5 < item_line) {
            effect_pos = 0;
        }
    } else {
        if (view_mode == 0 || view_mode == 1) {
            CMenuPosDataForm *form = view_form[sub_view];
            CHARA_DATA *character = MenuUserParam.chara[sub_view];
            if (&character->equip[0] == item) {
                form->GetPutPosXY(at_5265, MenuRepairTargetWeaponPos[0], MenuRepairTargetWeaponPos[1]);
            } else if (&character->equip[1] == item) {
                form->GetPutPosXY(at_5271, MenuRepairTargetWeaponPos[0], MenuRepairTargetWeaponPos[1]);
            }
            position[0] -= 7;
        }
        if (view_mode == 3) {
            ROBO_DATA *ridepod = MenuUserParam.robo;
            if (&ridepod->parts[2] == item) {
                view_form[3]->GetPutPosXY(at_7540, MenuRepairTargetWeaponPos[0], MenuRepairTargetWeaponPos[1]);
            } else if (&ridepod->parts[0] == item) {
                view_form[3]->GetPutPosXY(at_5265, MenuRepairTargetWeaponPos[0], MenuRepairTargetWeaponPos[1]);
            }
            position[0] -= 7;
        }
    }
}
extern int effparamtbl_8275[2][5];
extern char at_8315[];
void CMenuItemInfo::SetItemEffect(void) {
    CCharacter2 *field_chara = MenuMainScene->GetCharacter(0);
    int item_no = MenuUsedItemNo;
    int target_type = MenuUsedTarget.type;
    int chara_effect = 0;
    int weapon_effect = 0;
    int repair_effect = 0;
    int level_effect = 0;
    u8 always = item_no == 0x10F || item_no == 0x111 || item_no == 0x1AA || item_no == 0x124;
    if (((view_mode == 0 || view_mode == 1) && target_type == ITEM_USE_TARGET_CHARA &&
         MenuUsedTarget.target.data == MenuUserParam.chara[sub_view]) ||
        always) {
        chara_effect = 1;
    }
    if ((view_mode == 4 && target_type == 3) || always) {
        chara_effect = 1;
    }
    if (view_mode == 2 && target_type == ITEM_USE_TARGET_ITEM && MenuUsedTarget.target.item == view_weapon) {
        weapon_effect = 1;
    }
    if (target_type == ITEM_USE_TARGET_ITEM) {
        CGameDataUsed *target = MenuUsedTarget.target.item;
        if (target != NULL && (target->used_type == USED_ITEM_TYPE_WEAPON || target->used_type == USED_ITEM_TYPE_ROBO_PART)) {
            repair_effect = 1;
        }
    }
    if (target_type == ITEM_USE_TARGET_ITEM && MenuUsedTarget.target.item != NULL && item_no == 0x127) {
        level_effect = 1;
    }
    if (GetMenuLoopType() == 0) {
        chara_effect = 0;
    }
    u32 use_type = MenuUsedItemType;
    if ((use_type & 0x100) || (use_type & 0x8000) || (use_type & 0x20000) || (use_type & 0x80000) ||
        (use_type & 0x200000) || (use_type & 0x4000000) || (use_type & 0x400000) || (use_type & 0x10000000)) {
        if (chara_effect == 1) {
            float position[4];
            MenuActionChara[0]->GetPosition(position);
            field_chara->SetPosition(position);
            FxScriptManPauseFlag = 1;
            MenuActionChara[0]->effect_man = FxScriptMan;
            FxScriptMan->CreateEffSpt(at_8315, 0, 0);
            FxScriptMan->SetScriptTargetId(0, -1, -1);
            int param_no = 0;
            if (MenuUsedItemType & 0x400000) {
                param_no = 1;
            }
            int *param = effparamtbl_8275[param_no];
            MenuActionChara[0]->pallet[0].SetAnim(param[0], param[1], param[2], param[3], param[4], 0);
            FxScriptMan->SetValue(0, param_no, 0, -1);
        }
    }
    if (MenuUsedItemType & 0x400) {
        unk_16C = 0;
        effect_pos = 0;
        if (weapon_effect) {
            mode = MENU_ASK_MODE_EXTEND;
            step = 0;
            ask_para.unk_70 = 1;
            unk_16C = 1;
        }
        if (repair_effect) {
            mode = MENU_ASK_MODE_EXTEND;
            step = 0;
            ask_para.unk_70 = 1;
            effect_pos = 1;
            MenuRepairTargetWeaponPos[0] = -100;
            MenuRepairTargetWeaponPos[1] = -100;
            SearchEffectDisplayPosition(MenuRepairTargetWeaponPos, MenuUsedTarget.target.item);
        }
        if (unk_16C && MenuCommonInfo->cursor_form != NULL) {
            MenuCommonInfo->cursor_form->draw_flag = 0;
        }
    }
    if (level_effect) {
        MenuRepairTargetWeaponPos[0] = -100;
        MenuRepairTargetWeaponPos[1] = -100;
        SearchEffectDisplayPosition(MenuRepairTargetWeaponPos, MenuUsedTarget.target.item);
        int who = MenuUsedTarget.target.item->IsWhoEquip();
        MenuLevelUpMan.Generate(who, MenuRepairTargetWeaponPos[0], MenuRepairTargetWeaponPos[1]);
        if (weapon_effect) {
            MenuLevelUpMan.spark_tex = mgTexManager.GetTexture(at_4672, -1);
            MenuLevelUpMan.Generate(who, (CCharacter2 *)MenuActionChara[0]);
        }
    }
}
#ifdef NONMATCHING
int CMenuItemInfo::LRCheck(int key) {
    if (mode != MENU_ASK_MODE_NONE) {
        return 0;
    }
    if (unk_160) {
        return 0;
    }
    int dir = 0;
    if ((key & MENU_SELECT_KEY_L1) || (key & MENU_SELECT_KEY_L2)) {
        dir--;
    } else if ((key & MENU_SELECT_KEY_R1) || (key & MENU_SELECT_KEY_R2)) {
        dir++;
    }
    if (dir == 0) {
        return 0;
    }
    if (key != MENU_SELECT_KEY_R2 && key != MENU_SELECT_KEY_L2 && key != MENU_SELECT_KEY_R1 &&
        key != MENU_SELECT_KEY_L1) {
        return 0;
    }
    int page_view[8];
    int page_chara[8];
    int page_arg_no[8];
    mgCMemory *item_memory = &MenuItemMemory;
    mgCMemory *load_stack = &MenuCharaLoadStack;
    int page_num = 0;
    int active = GetActiveCharaNo();
    int party = MenuUserDataManPtr->GetNowPartyMember();
    if (party & 1) {
        page_view[page_num] = 0;
        page_arg_no[page_num] = 3;
        page_num++;
        page_chara[0] = 0;
    }
    if (party & 2) {
        if (active != 3) {
            page_view[page_num] = 1;
            page_arg_no[page_num] = 3;
            page_chara[page_num] = 1;
            page_num++;
        }
    }
    if (party & 4) {
        page_view[page_num] = 3;
        page_chara[page_num] = 2;
        page_arg_no[page_num] = 6;
        page_num++;
    }
    if (party & 8) {
        if (active == 3) {
            page_view[page_num] = 4;
            page_chara[page_num] = 3;
            page_arg_no[page_num] = 8;
            page_num++;
        }
    }
    int page = -1;
    for (int i = 0; i < page_num; i++) {
        if (view_mode == page_view[i]) {
            page = i;
        }
    }
    page += dir;
    if (page < 0) {
        page = page_num - 1;
    }
    if (page_num <= page) {
        page = 0;
    }
    int next_view = page_view[page];
    int next_chara = page_chara[page];
    int next_arg_no = page_arg_no[page];
    if (view_mode != next_view) {
        int held_type = ConvertUsedItemType(GetItemDataType__Fi(MenuCommonInfo->have_item.item_no));
        if ((view_mode == 0 || view_mode == 1) &&
            (held_type == USED_ITEM_TYPE_WEAPON || held_type == USED_ITEM_TYPE_UNK_4)) {
        } else if (view_mode == 3 && held_type == USED_ITEM_TYPE_ROBO_PART) {
        } else {
        MenuMemoryAdjust(item_memory, load_stack, MenuActionCharaBuffer, next_chara);
        MenuLoadInfo.unk_2 = 1;
        MenuLoadInfo.unk_4 = -1;
        MenuLoadInfo.unk_5 = 0;
        view_mode = next_view;
        if (view_mode == 0 || view_mode == 1) {
            sub_view = next_chara;
        }
        int load_chara = view_mode;
        if (load_chara != 4) {
            if (load_chara == 3) {
                load_chara = 2;
            }
            CheckLoadInfo(load_chara);
        }
        if (view_mode == 3) {
            MenuLoadInfo.unk_4 = -1;
            MenuLoadInfo.unk_5 = 0;
            MenuActionChara[5]->Initialize(NULL);
        }
        key_arg_no = next_arg_no;
        MenuCommonInfo->key_arg = &item_menu_argtbl[key_arg_no];
        ModelReadStart(view_mode, 1, 1);
        MenuSePlay(1);
        }
    }
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", LRCheck__13CMenuItemInfoFi);
#endif
void MenuItemInfoCursorSet(int mode) {
    MENU_ITEM_CURSOR_INFO *info = &MenuItemCursorInfo;
    info->enable = 0;
    info->arrow[0] = 0;
    info->arrow[1] = 0;
    info->arrow[2] = 0;
    info->arrow[3] = 0;
    info->arrow[4] = 0;
    info->chara_mark = 0;
    if (mode == 4) {
        info->enable = 1;
        int msg_item = MenuDCMsg[5]->GetMsgItemNo(MenuDCMsg[5]->GetMsgCursor()) - 5000;
        switch (msg_item) {
        case 15:
        case 16:
        case 17:
        case 18:
            if (CMenuItemInfoPt->view_mode == SameviewmodeTable_8406[msg_item - 15]) {
                info->chara_mark = 1;
                if (SameviewmodeTable_8406[msg_item - 15] == 0 && CMenuItemInfoPt->sub_view != msg_item - 15) {
                    info->chara_mark = 0;
                }
            }
            break;
        case 19:
        case 20:
            info->arrow[msg_item - 16] = 1;
            break;
        case 21:
        case 22:
            if (CMenuItemInfoPt->view_mode == 3) {
                info->arrow[msg_item - 18] = 1;
            }
            break;
        }
    }
}
extern u32 status_table_8427[7];
extern s8 xytable_8428[7][2];
extern s8 xytable_wep_8429[12][2];
extern u32 draw_tbl_8453[12];
void MenuCharaStatusDraw(int &tex_block) {
    if (MenuStatusTex == NULL) {
        return;
    }
    if (MenuStatusMode == 0) {
        if (CMenuItemInfoPt->view_mode == 0 || CMenuItemInfoPt->view_mode == 1) {
            CMenuPosDataForm *form;
            int status = MenuUserDataManPtr->GetCharaStatusAttirbute(CMenuItemInfoPt->sub_view);
            form = CMenuItemInfoPt->view_form[CMenuItemInfoPt->sub_view];
            if (status != 0 && form != NULL) {
                MenuReloadTexture(tex_block, MenuStatusTex->block);
                float x = 16.0f + form->x;
                float y = form->y - 200.0f;
                for (int i = 0; i < 7; i++) {
                    if (status & status_table_8427[i]) {
                        mgRect<int> rect;
                        rect.Set(xytable_8428[i][0], xytable_8428[i][1], 24, 24);
                        PrimQuad(MenuStatusTex, x, y, rect, form->rgba[3], 0x80, 0x80, 0x80);
                        x += 24.0f;
                    }
                }
            }
        }
        if (CMenuItemInfoPt->view_mode == 2) {
            u32 special = 0;
            if (CMenuItemInfoPt->view_weapon != NULL &&
                CMenuItemInfoPt->view_weapon->used_type == USED_ITEM_TYPE_WEAPON) {
                special = CMenuItemInfoPt->view_weapon->data.weapon.special;
            }
            CMenuPosDataForm *form = CMenuItemInfoPt->view_form[2];
            if (special != 0 && form != NULL) {
                MenuReloadTexture(tex_block, MenuStatusTex->block);
                float x = 26.0f + form->x;
                float y = form->y - 42.0f;
                for (int i = 0; i < 12; i++) {
                    if (special & draw_tbl_8453[i]) {
                        mgRect<int> rect;
                        rect.Set(xytable_wep_8429[i][0], xytable_wep_8429[i][1], 21, 21);
                        PrimQuad(MenuStatusTex, x, y, rect, form->rgba[3], 0x80, 0x80, 0x80);
                        x += 24.0f;
                    }
                }
            }
        }
    }
}
#ifdef NONMATCHING
void MenuItemInfoCursorDraw(int &tex_block) {
    if (MenuItemCursorInfo.enable == 0) {
        return;
    }
    mgCTexture *texture = Tex_BuildUpBoard;
    if (texture == NULL) {
        return;
    }
    float wave = sinf(0.12566371f * MenuItemCursorInfo.counter);
    MenuReloadTexture(tex_block, texture->block);
    mgRect<int> up_rect;
    mgRect<int> down_rect;
    mgRect<int> left_rect;
    mgRect<int> put_rect;
    up_rect.Set(0x18C, 0xCA, 0x16, 0x1E);
    down_rect.Set(0x18C, 0xE5, 0x16, -0x1D);
    left_rect.Set(0x1A2, 0xC8, -0x16, 0x1E);
    put_rect.Set(0, 0, 0x1F, 0x29);
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Bilinear(1);
    prim->Begin(6);
    prim->Texture(texture);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    s16 view_mode = CMenuItemInfoPt->view_mode;
    if (view_mode == 0 || view_mode == 1) {
        int i;
        float bob_x = 7.5f * wave;
        float bob_y = 10.0f * wave;
        int x = 0x36;
        put_rect.top = (int)(91.0f - bob_y);
        for (i = 0; i < 3; i++) {
            if (MenuItemCursorInfo.arrow[i] != 0) {
                put_rect.left = (int)(x + bob_x);
                PrimQuad(prim, put_rect, down_rect);
            }
            x += 0x2A;
        }
        put_rect.top = (int)(294.0f - bob_y);
        if (MenuItemCursorInfo.arrow[3] != 0) {
            put_rect.left = (int)(46.0f + bob_x);
            PrimQuad(prim, put_rect, up_rect);
        }
        if (MenuItemCursorInfo.arrow[4] != 0) {
            put_rect.left = (int)(180.0f - bob_x);
            PrimQuad(prim, put_rect, left_rect);
        }
    }
    if (CMenuItemInfoPt->view_mode == 3) {
        float bob_x = 7.5f * wave;
        put_rect.top = (int)(310.0f - 10.0f * wave);
        if (MenuItemCursorInfo.arrow[3] != 0) {
            put_rect.left = (int)(166.0f - bob_x);
            PrimQuad(prim, put_rect, left_rect);
        }
        put_rect.top -= 0x30;
        if (MenuItemCursorInfo.arrow[4] != 0) {
            put_rect.left = (int)(166.0f + bob_x - 120.0f);
            PrimQuad(prim, put_rect, up_rect);
        }
    }
    prim->End();
    prim->Begin(5);
    prim->Texture(texture);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    if (MenuItemCursorInfo.chara_mark == 1) {
        float bob_x = 10.0f * wave;
        float bob_y = 7.0f * wave;
        switch (CMenuItemInfoPt->view_mode) {
            case 0:
            case 1:
                put_rect.left = (int)(70.0f - bob_x);
                put_rect.top = (int)(190.0f + bob_y);
                break;
            case 2:
            case 5:
                put_rect.left = 0x14;
                put_rect.top = 0x78;
                break;
            case 3:
                put_rect.left = 0x5A;
                put_rect.top = 0x82;
                break;
            case 4:
                put_rect.left = (int)(70.0f - bob_x);
                put_rect.top = (int)(230.0f + bob_y);
                break;
        }
        int right = put_rect.left + put_rect.right;
        int tex_right = up_rect.left + up_rect.right;
        int bottom = put_rect.top + put_rect.bottom;
        int tex_bottom = up_rect.top + up_rect.bottom;
        prim->TextureCrd(up_rect.left, tex_bottom);
        prim->Vertex(right, put_rect.top, 0);
        prim->TextureCrd(up_rect.left, up_rect.top);
        prim->Vertex(put_rect.left, put_rect.top, 0);
        prim->TextureCrd(tex_right, up_rect.top);
        prim->Vertex(put_rect.left, bottom, 0);
        prim->TextureCrd(tex_right, tex_bottom);
        prim->Vertex(right, bottom, 0);
    }
    prim->End();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemInfoCursorDraw__FRi);
#endif
void CMenuItemInfo::KeyStepLocal(int select_key, int push_button, int flag) {
    int select = -1;
    if (GamePad__2.Down(0x400) && menu_debug_flag == 1) {
        int rest = MenuCharaLoadStack.stGetRest();
        MenuDebugStack.stSetBuffer(MenuCharaLoadStack.stGetTop(), rest);
        MenuDebugItemModel = NULL;
        MenuDebugCamera = NULL;
        MenuDebugModelDrawFlag = 0;
    }
    if (menu_debug_flag != 0) {
        if (select_key & MENU_SELECT_KEY_L1) {
            select_key ^= MENU_SELECT_KEY_L1;
        }
        if (select_key & MENU_SELECT_KEY_L2) {
            select_key ^= MENU_SELECT_KEY_L2;
        }
        if (select_key & MENU_SELECT_KEY_R1) {
            select_key ^= MENU_SELECT_KEY_R1;
        }
        if (select_key & MENU_SELECT_KEY_R2) {
            select_key ^= MENU_SELECT_KEY_R2;
        }
    }
    if (MenuMoveItemPtr->move_on) {
        push_button = 0;
        select_key ^= MENU_SELECT_KEY_L1 | MENU_SELECT_KEY_R1 | MENU_SELECT_KEY_L2 | MENU_SELECT_KEY_R2;
    }
    int cursor_move = 0;
    if (mode == MENU_ASK_MODE_NONE) {
        if (LRCheck(select_key)) {
            select = -1;
        }
        cursor_move = 1;
    }
    if (mode == MENU_ASK_MODE_OPEN) {
        cursor_move = 1;
    }
    if (menu_debug_flag != 0 && key_arg_no == 2) {
        cursor_move = 0;
    }
    if (cursor_move) {
        select = MenuCommonInfo->CheckMoveSelect(select_key);
    }
    int cursor = MenuCommonInfo->cursor;
    if (select >= 0 || MenuCommonInfo->save_cursor != cursor) {
        MenuSePlay(0);
    }
    if (MenuCommonInfo->CheckKeyInput() && key_arg_no == 2) {
        MenuItem_ItemBoardTopLine = MenuCommonInfo->GetTopLine();
        MenuItem_ItemBoardTopSelect = cursor;
    }
    if (select >= 0) {
        MenuItemSelectDiffer(select);
        if (unk_198 != 0 && MenuSpectolSatusCheckForm != NULL && (select_key != 0 || push_button != 0)) {
            MenuSpectolSatusCheckForm->SetAction(at_5757);
            unk_198 = 0;
        }
    } else if (!MenuLoadFileCheck(MenuCharaBuild2)) {
        PushKey(select_key, push_button);
    }
}
extern char at_8711[];
int CMenuItemInfo::KeyStep(void) {
    int result = 0;
    s8 loading = MenuLoadFileCheck(MenuCharaBuild2);
    int reading = ReadBGSync();
    MenuCommonInfo->CheckSelectKey();
    int lr_key = MenuCommonInfo->CheckLRKey();
    int push_button = MenuCommonInfo->CheckPushButton();
    MenuCommonInfo->CheckKeyInput();
    switch (mode) {
        case MENU_ASK_MODE_OPEN:
            switch (step) {
                case 0:
                    if (!opened && reading == 0) {
                        opened = 1;
                    }
                    KeyStepLocal(lr_key, push_button, 0);
                    if (opened) {
                        MenuMoveItemPtr->AttachForm();
                        ExeScript(at_8711);
                        opened = 1;
                        mode = MENU_ASK_MODE_NONE;
                        MenuItemBrdCalcManner = 0;
                        TrushMesWindowFlag = 0;
                        if (CheckTrushMenu() == 1) {
                            TrushMesWindowFlag = 1;
                            step = 1;
                            mode = MENU_ASK_MODE_OPEN;
                            if (MenuCommonInfo->cursor_form != NULL) {
                                MenuCommonInfo->cursor_form->draw_flag = 0;
                            }
                            int over_num = GetUserDataMan()->GetItemBoardOverNum();
                            mgCMemory stack;
                            int rest = MenuCharaLoadStack.stGetRest();
                            stack.stSetBuffer(MenuCharaLoadStack.stGetTop(), rest);
                            int bag_max = GetNowBagMax(0);
                            for (int i = 0; i < over_num; i++) {
                                s16 item_no = MenuUserDataManPtr->GetUsedDataPtr(bag_max + i)->item_no;
                                if (item_no > 0) {
                                    TrushMesCls[0] = new (stack.Alloc(0x2A7)) CDC2Mes;
                                    CDC2Mes *message = TrushMesCls[0];
                                    message->SetBuff(GetMenuMainMessageBuffer());
                                    message->SetBuff_system(GetSystemMesBuffer());
                                    message->MsgPreset(0xA);
                                    message->SetAbsPos(5);
                                    GetUserItemHaveNum(item_no);
                                    GetCommonItemData(item_no);
                                    message->MakeMsg(0xA0);
                                    break;
                                }
                            }
                        }
                    }
                    break;
                case 1:
                    if (push_button) {
                        TrushMesWindowFlag = 0;
                        for (int i = 0; i < 8; i++) {
                            TrushMesCls[i] = NULL;
                        }
                        step = 0;
                        mode = MENU_ASK_MODE_NONE;
                        if (MenuCommonInfo->cursor_form != NULL) {
                            MenuCommonInfo->cursor_form->draw_flag = 1;
                        }
                    }
                    break;
            }
            break;
        case MENU_ASK_MODE_CLOSE:
            if ((CheckTrushMenu() && ItemOverFlowCheckFlag == 0) || unk_170 == 1) {
                if (reading == 0 && FadeCheckMenu()) {
                    ExitEnd();
                    result = 1;
                    if (unk_170) {
                        MenuArg.result[0] = 1;
                        MenuArg.end_code = 5;
                        MenuArg.result[1] = 1;
                        result = 2;
                        MenuArg.result[2] = 0;
                    }
                }
            } else if (GetMenuMainFrameEndFlag() && reading == 0) {
                if (ItemOverFlowCheckFlag) {
                    MenuCommonInfo->next_mode = -1;
                }
                ExitEnd();
                result = 1;
            }
            break;
        default:
            KeyStepLocal(lr_key, push_button, 1);
            break;
    }
    if (mode != MENU_ASK_MODE_OPEN || step != 0) {
        ModelReadEndCheck();
        loading = MenuLoadFileCheck(MenuCharaBuild2);
    }
    CActionChara *chara = MenuCharaBuild2[0]->chara;
    if (chara != NULL && loading == 0 && MenuCommonInfo->unk_0 != 0) {
        chara->Step();
        MenuCharaBuild2[0]->chara->StepEffect();
        if (GetNowLoopNo() == 2 && FxScriptMan != NULL) {
            FxScriptMan->PauseFromLevel(3, 3);
            FxScriptMan->PauseFromLevel(1, 3);
            FxScriptMan->Step();
            FxScriptMan->PauseFromLevel(3, 0);
            FxScriptMan->PauseFromLevel(1, 0);
        }
    }
    int *mode_id = GetCommonMenuModeID();
    int icon_mode = 2;
    if (mode == MENU_ASK_MODE_CLOSE) {
        icon_mode = 0;
    }
    if (CheckTrushMenu()) {
        icon_mode = 2;
    }
    if (unk_170) {
        icon_mode = 2;
    }
    MenuPosData->StepMainMenuIconMove(mode_id, 2, icon_mode);
    MenuPosData->FormStep();
    CalcTex();
    CalcCursorPosition();
    MenuEffect[0]->Step();
    MenuEffect[1]->Step();
    MenuRepairMan->Step();
    MenuLevelUpMan.Step();
    StepBuildUpInfoEffect();
    WeaponWarningCounter += 0.09817477f;
    if (!(WeaponWarningCounter <= 3.1415927f)) {
        WeaponWarningCounter -= 3.1415927f;
    }
    MenuItemCursorInfo.counter++;
    if (MenuItemCursorInfo.counter >= 25) {
        MenuItemCursorInfo.counter = 0;
    }
    return result;
}
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

    switch (CMenuItemInfoPt->sub_menu) {
        case -1: {
            int faded;

            ret = 0;
            faded = CMenuItemInfoPt->FadeCheckMenu();
            switch (CMenuItemInfoPt->next_sub_menu) {
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
                    if (CMenuItemInfoPt->next_sub_menu == 1) {
                        MenuCommonInfo->SetWakuType(-1);
                        MenuMonsterBoxInit(&MenuItemMemory, (int *)&CMenuItemInfoPt->tex_block[0], 0);
                    }
                    if (CMenuItemInfoPt->next_sub_menu == 0) {
                        SetMenuFrameRate(2);
                        MenuAquaInit(&MenuItemMemory, (int *)&CMenuItemInfoPt->tex_block[0], 0);
                    }
                    if (CMenuItemInfoPt->next_sub_menu == 2) {
                        NameRegistInit(&MenuItemMemory, (int *)&CMenuItemInfoPt->tex_block[0], 0);
                    }
                    if (CMenuItemInfoPt->next_sub_menu == 3) {
                        MenuNPCQuestViewInit(&MenuItemMemory, (int *)&CMenuItemInfoPt->tex_block[0],
                                             0);
                    }
                    if (CMenuItemInfoPt->next_sub_menu == 4) {
                        MenuNPCQuestViewInit(&MenuItemMemory, (int *)&CMenuItemInfoPt->tex_block[0],
                                             1);
                    }
                    if (CMenuItemInfoPt->next_sub_menu == 5) {
                        MonsterBookInit(&MenuItemMemory, (int *)&CMenuItemInfoPt->tex_block[0], 0);
                    }
                    CMenuItemInfoPt->sub_menu = CMenuItemInfoPt->next_sub_menu;
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
            if (CMenuItemInfoPt->sub_menu == 0) {
                ret = MenuAquaKey();
            }
            if (CMenuItemInfoPt->sub_menu == 1) {
                ret = MenuMonsterBoxKey();
            }
            if (CMenuItemInfoPt->sub_menu == 2) {
                ret = NameRegistKey();
            }
            if (CMenuItemInfoPt->sub_menu == 3 || CMenuItemInfoPt->sub_menu == 4) {
                ret = MenuNPCQuestViewKey();
            }
            if (CMenuItemInfoPt->sub_menu == 5) {
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
                if (CMenuItemInfoPt->sub_menu == 1) {
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
                CMenuItemInfoPt->next_sub_menu = -1;
                CMenuItemInfoPt->sub_menu = -1;
                CMenuItemInfoPt->FadeInMenu(0x28, 0.0f);
                CMenuItemInfoPt->unk_13A = 1;
            }
            return 0;
        default:
            return 0;
    }
}
int CheckFishCondition(void);
extern s8 menu_camera_reference_id;
extern s8 menu_camera_reference_no;
void MenuItemDraw(void) {
    DrawMenuFillBox(0x80, 0, 0, 0);
    switch (CMenuItemInfoPt->sub_menu) {
        case -1: {
            if (CMenuItemInfoPt->view_mode == 2 || CMenuItemInfoPt->view_mode == 5) {
                MenuDrawEnv->camera.SetRef(CMenuItemInfoPt->camera_ref);
                MenuDrawEnv->camera.SetPos(CMenuItemInfoPt->camera_pos);
            } else {
                MenuEquipCameraSetEnv(MenuActionChara[0], &MenuDrawEnv->camera, menu_camera_reference_id,
                                      menu_camera_reference_no);
            }
            int loaded_tex_no = -1;
            CMenuPosDataForm *form = MenuPosData->GetDrawTopList();
            int effect_drawn = 0;
            while (form != NULL) {
                form->MenuFormDraw(loaded_tex_no);
                if (!effect_drawn && strcmp(form->name, at_5281) == 0) {
                    DrawBuildUpInfoEffect();
                    loaded_tex_no = -1;
                    effect_drawn = 1;
                }
                form = form->next;
                if (form == NULL) {
                    break;
                }
            }
            MenuEffect[0]->Draw();
            MenuEffect[1]->Draw();
            mgCTextureManager *tex_manager = &mgTexManager;
            if (CMenuItemInfoPt->build_up_chara != NULL) {
                tex_manager->ReloadTexture(CMenuItemInfoPt->tex_block[2], (sceVif1Packet *)NULL);
                CMenuItemInfoPt->build_up_chara->DrawDirect();
            }
            MenuRepairMan->Draw();
            if (MenuLevelUpMan.IsRun() && MenuLevelUpMan.label_tex != NULL) {
                tex_manager->ReloadTexture(MenuLevelUpMan.label_tex->block, (sceVif1Packet *)NULL);
                MenuLevelUpMan.Draw();
            }
            if (StepFishBoiledEffect()) {
                tex_manager->ReloadTexture(MenuLevelUpMan.label_tex->block, (sceVif1Packet *)NULL);
                DrawFishBoiledEffect();
            }
            if (menu_debug_flag != 0) {
                MenuItemDebugDraw();
            }
            if (TrushMesWindowFlag != 0) {
                DrawTrushMenuMessage();
            }
            break;
        }
        case 0:
            MenuAquaDraw();
            break;
        case 1:
            MenuMonsterBoxDraw();
            break;
        case 2:
            NameRegistDraw();
            break;
        case 3:
        case 4:
            MenuNPCQuestViewDraw();
            break;
        case 5:
            MonsterBookDraw();
            break;
    }
}
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
extern s8 MenuItemSelectMode;
extern char *imgtbl_8945[];
extern char at_9032[];
extern char at_9033[];
#ifdef NONMATCHING
int CItemSelect::KeyStep(void) {
    int end = 0;
    if (mode == MENU_ASK_MODE_CLOSE) {
        if (alpha <= 0) {
            end = 1;
        }
    } else if (mode == MENU_ASK_MODE_OPEN) {
        if (ReadBGSync() == 0) {
            mgCTextureManager *tex_manager = &mgTexManager;
            tex_manager->DeleteBlock(tex_block[1]);
            BG_READ_INFO *file = GetReadBGFile(0);
            if (file != NULL) {
                MenuMainImageDataEnter(tex_block[1]);
                for (int i = 0; imgtbl_8945[i] != NULL; i++) {
                    tex_manager->EnterIMGFile((u8 *)GetPackFile((u_int *)file->buffer, imgtbl_8945[i], NULL),
                                              tex_block[1], NULL, NULL);
                }
                MenuItemIconTextureBlock = tex_block[1];
                MenuPosData->AttachCommonTexInfo();
                MenuItemIconTextureBlock = tex_block[1];
                MenuPosData->MallocPallet(&MenuItemMainMemory);
                MenuDCMsg[0]->SetBuff(GetMenuMainMessageBuffer());
            }
            texture = tex_manager->GetTexture(at_9032, -1);
            alpha_step = 0xC;
            MenuCommonInfo->key_enable = 1;
            mode = MENU_ASK_MODE_NONE;
        }
    } else {
        int select_key = MenuCommonInfo->CheckSelectKey();
        int push_button = MenuCommonInfo->CheckPushButton();
        int max = (int)(5.0f * line_num);
        int old_cursor = cursor;
        if (select_key & MENU_SELECT_KEY_UP) {
            cursor = old_cursor - 5;
        } else if (select_key & MENU_SELECT_KEY_DOWN) {
            cursor = old_cursor + 5;
        } else if (select_key & MENU_SELECT_KEY_RIGHT) {
            if (old_cursor % 5 != 4) {
                cursor = old_cursor + 1;
                if (cursor >= max) {
                    cursor = max - 1;
                }
            }
        } else if (select_key & MENU_SELECT_KEY_LEFT) {
            if (old_cursor % 5 != 0) {
                cursor = old_cursor - 1;
                if (cursor < 0) {
                    cursor = 0;
                }
            }
        }
        while (cursor < 0) {
            cursor += 5;
        }
        while (cursor >= max) {
            cursor -= 5;
        }
        MenuCheckLine(&top_line, cursor / 5, 2);
        if (old_cursor != cursor) {
            MenuSePlay(0);
        }
        CGameDataUsed *item = GetExistThisPosData(cursor);
        if (push_button & MENU_PUSH_BUTTON_DECIDE) {
            if (item == NULL) {
                MenuSePlay(5);
            } else {
                mode = MENU_ASK_MODE_CLOSE;
                alpha_step = -8;
                MenuArg.result[2] = 0;
                MenuArg.result[3] = 0;
                MenuSePlay(1);
                if (MenuItemSelectMode == 1) {
                    MenuArg.end_code = 0xF;
                    MenuArg.result[0] = item->item_no;
                    MenuArg.result[1] = 0;
                    if (item->used_type == USED_ITEM_TYPE_FISH) {
                        MenuArg.result[1] = 1;
                        BREEDFISH_USED *fish = &item->data.fish;
                        if (fish == NULL || (fish->flags & 1)) {
                            MenuArg.result[1] = 0;
                            goto step_alpha;
                        }
                        MenuArg.result[2] = fish->size;
                        MenuArg.result[3] = fish->weight;
                        MenuArg.result[4] = 0;
                        CDataBreedFish *info = GetBreedFishInfoData(MenuArg.result[0]);
                        if (info != NULL) {
                            MenuArg.result[4] = (int)info->size;
                        }
                        GetUserDataMan()->fish_tournament.EntryFish(item->item_no, fish->size, fish->weight);
                        item->DeleteNum(1);
                    }
                } else {
                    MenuArg.end_code = 7;
                    MenuArg.result[0] = item->item_no;
                    MenuArg.result[1] = GetSameAdrressUserData(item, 0);
                    CheckUse(item);
                }
            }
        } else if (push_button & MENU_PUSH_BUTTON_CANCEL) {
            MenuSePlay(5);
            mode = MENU_ASK_MODE_CLOSE;
            alpha_step = -8;
            MenuArg.end_code = 7;
            MenuArg.result[1] = -1;
            MenuArg.result[0] = 0;
        }
        if (item != NULL) {
            MenuDCMsg[0]->MakeMsg(item);
        } else if (LanguageCode == 0) {
            MenuDCMsg[0]->MakeMsg(at_9033);
        } else {
            MenuDCMsg[0]->MakeMsg(at_5132);
        }
    }
step_alpha:
    if (alpha_step < 0) {
        CalcMenuAdd(&alpha, alpha_step, 0);
    } else {
        CalcMenuAdd(&alpha, alpha_step, 0x80);
    }
    CalcMenuAdd(&bg_alpha, 8, 0x80);
    DrawMenuWakuStep();
    return end;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", KeyStep__11CItemSelectFv);
#endif
struct ItemSelectColor {
    u8 rgba[4];
};
extern ItemSelectColor at_9055;
extern char at_9179[];
#ifdef NONMATCHING
void CItemSelect::Draw(void) {
    if (texture == NULL) {
        return;
    }
    mgCTextureManager *tex_manager = &mgTexManager;
    tex_manager->ReloadTexture(texture->block, (sceVif1Packet *)NULL);
    mgCDrawPrim *prim = GetMenuPrim();
    mgRect<int> frame_rect;
    frame_rect.Set(1, 0, 0x110, 0xFE);
    mgRect<float> *list = &list_rect;
    mgRect<int> scissor;
    scissor.Set(0, (int)(37.0f + list_rect.top), mgScreenWidth - 1, (int)(147.0f + list_rect.top));
    SetMenuScissor(scissor);
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    float scroll_top = 37.0f + list->top - 55.0f * top_line;
    item_rect.top += (scroll_top - item_rect.top) / 4.0f;
    if (37.0f + list->top < item_rect.top) {
        item_rect.top = scroll_top;
    }
    prim->Texture(texture);
    prim->Color(0x80, 0x80, 0x80, alpha);
    mgRect<int> cell_rect;
    cell_rect.Set(0x111, 0, 0x2C, 0x37);
    int drawn = 0;
    for (int line = 0; line < 50; line++) {
        float y = item_rect.top + 55.0f * line;
        if (!(y <= 90.0f)) {
            float x = item_rect.left;
            for (int column = 0; column < 5; column++) {
                PrimQuad(prim, x, y, cell_rect);
                x += 44.0f;
            }
            drawn++;
            if (drawn >= 5) {
                break;
            }
        }
    }
    prim->End();
    mgRect<float> icon_rect(4.0f + item_rect.left, 8.0f + item_rect.top, item_rect.right, item_rect.bottom);
    icon_rect.right = 32.0f;
    icon_rect.bottom = 40.0f;
    ItemSelectColor color = at_9055;
    color.rgba[3] = alpha;
    mgCTexture *number_tex = tex_manager->GetTexture(at_9179, -1);
    mgRect<int> number_rect;
    number_rect.Set(0, 0xF4, 0xA, 0xD);
    int index = 0;
    for (int line = 0; line < line_num && item_list[line * 5] != NULL; line++) {
        icon_rect.left = 4.0f + item_rect.left;
        for (int column = 0; column < 5; column++, index++) {
            if (icon_rect.top <= 0.0f) {
                continue;
            }
            if (index >= item_num) {
                break;
            }
            CGameDataUsed *item = item_list[index];
            DrawOneItem(prim, icon_rect, item->item_no, 0, NULL, color.rgba, 0);
            int num = item->GetNum();
            s16 item_no = item->item_no;
            if (item_no == 0x137) {
                num = GetUserDataMan()->yarikomi_medal;
            }
            if (num >= 2 || item_no == 0x137) {
                prim->Bilinear(1);
                prim->Begin(6);
                prim->Texture(number_tex);
                if (limit_disp[index] != 0) {
                    prim->Color(0x52, 0x52, 0x94, alpha);
                } else {
                    prim->Color(0x80, 0x80, 0x80, alpha);
                }
                if (item_no == 0x137) {
                    prim->Color(0xA4, 0xA4, 0x40, alpha);
                }
                PrimDrawNumber(prim, num, 0, (int)(32.0f + icon_rect.left), (int)(26.0f + icon_rect.top), number_rect, -1, 0);
                prim->End();
            }
            icon_rect.left += 44.0f;
        }
        icon_rect.top += 55.0f;
        if (mgScreenHeight - 1 <= icon_rect.top) {
            break;
        }
    }
    ResetMenuScissor();
    float list_x = list->left;
    float list_y = list->top;
    SetSpriteEnv(prim, 0);
    prim->Bilinear(1);
    prim->Begin(6);
    prim->Color(0x80, 0x80, 0x80, alpha);
    prim->Texture(texture);
    PrimQuad(prim, list_x, list_y, frame_rect);
    prim->End();
    float lines = line_num - 2.0f;
    if (lines <= 0.0f) {
        lines = 1.0f;
    }
    float bar_h = 120.0f / lines;
    float bar_y = 33.0f + list_y + top_line * ((120.0f - bar_h) / lines);
    if (scroll <= 10.0f) {
        scroll = bar_y;
    } else {
        scroll += 0.25f * (bar_y - scroll);
    }
    float scroll_y = scroll;
    float bar_x = 250.0f + list->left;
    prim->Bilinear(1);
    prim->Begin(6);
    mgRect<int> tex_rect;
    mgRect<int> put_rect;
    tex_rect.Set(0x13E, 0, 6, 4);
    int x = (int)bar_x;
    put_rect.Set(x, (int)scroll_y, 6, 4);
    PrimQuad(prim, put_rect, tex_rect);
    mgRect<int> body_tex;
    mgRect<int> body_put;
    body_tex.Set(0x13E, 4, 6, 0x12);
    float body_y = 4.0f + scroll_y;
    body_put.Set(x, (int)body_y, 6, (int)(bar_h - 8.0f));
    PrimQuad(prim, body_put, body_tex);
    mgRect<int> end_tex;
    mgRect<int> end_put;
    end_tex.Set(0x13E, 0x18, 6, 4);
    end_put.Set(x, (int)(body_y + bar_h - 8.0f), 6, 4);
    PrimQuad(prim, end_put, end_tex);
    prim->End();
    mgRect<float> cursor_rect;
    cursor_rect.Set(item_rect.left, 40.0f + list->top, item_rect.right, item_rect.bottom);
    cursor_rect.left += (cursor % 5) * item_rect.right - 4.0f;
    cursor_rect.top += item_rect.bottom * (cursor / 5 - top_line);
    if (cursor_x == 0.0f) {
        cursor_x = cursor_rect.left;
        cursor_y = cursor_rect.top;
    } else {
        cursor_x += (cursor_rect.left - cursor_x) / 4.0f;
        cursor_y += (cursor_rect.top - cursor_y) / 4.0f;
    }
    mgRect<int> waku_tex;
    waku_tex.Set(0x10, 0x20, 0x12, 0xC);
    mgRect<float> waku_rect(cursor_x - 2.0f, cursor_y - 4.0f, cursor_rect.right, 40.0f);
    DrawMenuWakuRect(MenuPosData->icon_effect_tex, waku_rect, waku_tex, alpha, 0x80, 0x80, 0x80);
    if (mode == MENU_ASK_MODE_NONE) {
        int mes_pos[2];
        mes_pos[0] = (int)(16.0f + list->left);
        mes_pos[1] = (int)(164.0f + list->top);
        tex_manager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
        MenuDCMsg[0]->SetPutPos(mes_pos);
        MenuDCMsg[0]->StepMsg();
        MenuDCMsg[0]->DrawMsg();
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", Draw__11CItemSelectFv);
#endif
extern char at_9215[];
extern char at_9216[];
#ifdef NONMATCHING
extern "C" u8 __vt__11CItemSelect[];
void MenuItemSelectInit(mgCMemory *stack, int *tex_block, int mode) {
    int size;
    CItemSelect *select;
    int rest = stack->stGetRest();
    MenuItemMainMemory.stSetBuffer(stack->stGetTop(), rest);
    if ((select = (CItemSelect *)operator new(sizeof(CItemSelect), MenuItemMainMemory.Alloc(0x47))) != NULL) {
        __ct__14CBaseMenuClassFv(select);
        *(u8 **)((u8 *)select + 0x10C) = __vt__11CItemSelect;
        select->list_rect.Set(0.0f, 0.0f, 0.0f, 0.0f);
        select->item_rect.Set(0.0f, 0.0f, 0.0f, 0.0f);
        select->alpha_step = 0;
        select->alpha = 0;
        select->bg_alpha = 0;
        select->item_num = 0;
        select->cursor_y = 0.0f;
        select->cursor_x = 0.0f;
        select->scroll = 0.0f;
        select->texture = NULL;
        select->list_rect.Set(120.0f, mgScreenHeight - 0x10A, 0.0f, 200.0f);
        select->item_rect.Set(select->list_rect.left + 20.0f, select->list_rect.top + 370.0f, 44.0f, 55.0f);
        select->top_line = 0;
        select->cursor = 0;
        select->line_num = 1.0f;
        CheckEnableHaveItemNum();
        select->SetPtrList();
    }
    ItemSelectPtr = select;
    ItemSelectPtr->SetTexBlock(tex_block);
    MenuItemSelectMode = 0;
    if (mode == 22) {
        MenuItemSelectMode = 1;
    }
    MenuBGTextureBlock = ItemSelectPtr->tex_block[0];
    MenuCapture(MenuBGTextureBlock, &MenuItemMainMemory, 1);
    MenuPosData->AttachCommonTexInfo();
    MenuItemMainMemory.Align64();
    StartReadBG();
    if (mode == 9) {
        size = LoadFileMenu(at_9215, MenuItemMainMemory.stGetTop(), 0);
    }
    if (mode == 22) {
        size = LoadFileMenu(at_9216, MenuItemMainMemory.stGetTop(), 0);
    }
    MenuItemMainMemory.Alloc(QuadwordsFor(size));
    MenuDCMsg[0]->MsgPreset(2);
    MenuDCMsg[0]->fuchi = 5;
    MenuDCMsg[0]->MakeMsg(0);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menusys", MenuItemSelectInit__FP9mgCMemoryPii);
#endif
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
MENU_ASKMODE_PARA MenuAskParam;
CMENU_USERPARAM MenuUserParam;
mgCMemory MainCharaReadStack;
CItemUseTarget MenuItemUseTarget;
INCLUDE_BSS(MainCharaReadBuffer, 0x10);
INCLUDE_BSS(MenuLevelUpMan, 0x190);
INCLUDE_BSS(MenuItemCursorInfo, 0x10);
INCLUDE_BSS(BuildUpFormInfoIndex, 0x30);
INCLUDE_BSS(BuildUpFormInfoStatusVol, 0x30);
INCLUDE_BSS(TrushMesCls, 0x10);
mgCMemory MenuItemMainMemory;
mgCMemory MenuItemBGDataMemory;
mgCMemory MenuItemMemory;
mgCMemory MenuItemMemory2;
mgCMemory MenuCharaLoadStack;
INCLUDE_BSS(BuildUpWeaponInfo, 0x50);
CGameDataUsed SpectolInfoStay;
CGameDataUsed SepectolFusionBeforeAfterCheck;
INCLUDE_BSS(save_spectol_fusion_param, 0x20);
CGameDataUsed SpectolTransBefore;
INCLUDE_BSS(at_1557, 0x10);
INCLUDE_BSS(fusion_ambient, 0x10);
INCLUDE_BSS(fusion_color_ang, 0x10);
INCLUDE_BSS(MenuWeaponBasePos, 0x10);
INCLUDE_BSS(at_2333__3, 0x10);
INCLUDE_BSS(at_3407, 0x10);
INCLUDE_BSS(at_3792__2, 0x20);
CGameDataUsed MenuMoveTempGameDataUsed;
INCLUDE_BSS(at_4406, 0x20);
INCLUDE_BSS(at_4423__2, 0x10);
INCLUDE_BSS(at_4510, 0x10);
INCLUDE_BSS(at_5532, 0x18);
INCLUDE_BSS(BuildUpNameXY, 0x18);
INCLUDE_BSS(at_5774, 0x30);
CMenuItemInfo class_menu_item_info;
mgCMemory MenuDebugStack;
INCLUDE_BSS(at_7650, 0x10);
INCLUDE_BSS(at_7688, 0x10);
INCLUDE_BSS(MonicaRotationData, 0x10);
