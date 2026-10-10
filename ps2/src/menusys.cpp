/**
 *
 * Inventory slots available to the item selector.
 *
 */
const int kBagSlotCount = 0x96;
#include "common.h"
#include "mw_runtime.h"

#include <libvu0.h>

#include <cmath>
#include <cstdio>
#include <cstring>

#include "charasetup.hpp"
#include "dataread.hpp"
#include "dng_main.hpp"
#include "dynamicanime.hpp"
#include "effscript.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "map.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menushop.hpp"
#include "menusys.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nameregi.hpp"
#include "password.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

/**
 *
 * Rounds a byte count up to the number of 16-byte allocation blocks.
 *
 */
inline unsigned int QuadwordsFor(int bytes) {
    return ((unsigned int) bytes & 0xF) ? ((unsigned int) bytes >> 4) + 1 : ((unsigned int) bytes >> 4);
}

enum {
    kPadUp = 1,
    kPadDown = 2,
    kPadLeft = 4,
    kPadRight = 8
};

/**
 *
 * Identifies the inventory area currently used by the item menu.
 *
 */
enum ItemArea {
    kAreaHand = 0,
    kAreaEquip = 1,
    kAreaRobo = 2,
    kAreaBag = 3,
    kAreaSelected = 7,
    kAreaBait = 0xA
};

/**
 *
 * Tracks the item menu browsing and transformation states.
 *
 */
enum ItemMenuState {
    kStateBrowse = 0,
    kStateClosing = 2,
    kStateSpectolBreak = 7,
    kStateSpectolFusion = 8,
    kStateExtended9 = 9,
    kStateOverLimit = 0xD,
    kStateTuneBuildUp = 0xF
};

/**
 *
 * Tracks the confirmation stage of weapon build-up tuning.
 *
 */
enum TuneBuildUpStep {
    kTuneAdjust = 0,
    kTuneConfirmSave = 1,
    kTuneConfirmDiscard = 2
};

/**
 *
 * Defines numeric limits used while tuning a weapon build-up.
 *
 */
enum BuildUpTuning {
    kPointsPerStep = 100,
    kStatMax = 100
};

enum {
    kBlinkPeriod = 0x3C,
    kBlinkLastOn = 0x19
};

/**
 *
 * Defines the colours used to show a raised fusion value.
 *
 */
enum FusionColors {
    kColorNormal = 0x80,
    kColorRaisedR = 0x54,
    kColorRaisedG = 0x54,
    kColorRaisedB = 0xA4
};

/**
 *
 * Identifies an action returned by the item menu.
 *
 */
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

void MenuAquaInit(mgCMemory *memory, int *data, int arg);
void NameRegistInit(mgCMemory *memory, int *data, int arg);
void MenuNPCQuestViewInit(mgCMemory *memory, int *data, int arg);
int  GetItemCommandMsg(CGameDataUsed *item, MENU_ASKMODE_PARA *param, int slot, int arg);
int  GetItemCommandMsg(CGameDataUsed *item, int *cmds, u32 *colors, short *values, short *marks, int type,
                       int arg);
void MenuFormUpdataAttachInfo(CMenuPosDataForm *form, CGameDataUsed *item, int item_no, int reset,
                              short *b);
void SetSwordBlurEffect(CCharacter2 *chara, mgCMemory *stack, int chara_no);
void SetupUnitMan(CScene *scene, CUserDataManager *user_data, int unit, ROBO_INFO_DATA *robo);
void InitSpectol();

static void MenuItemDebugKey();

/**
 *
 * Groups the model, skin, and outline data loaded for a menu character.
 *
 */
struct MenuCharaReadBuffers {
    u_int *model;   /**< Loaded model data. */
    u_int *skin;    /**< Loaded skin data. */
    u_int *outline; /**< Loaded outline data. */
};

extern CDC2Mes      *MenuDCMsg[9];
extern CGameDataUsed SpectolTransBefore;
extern CGameDataUsed SpectolInfoStay;
extern CMenuItemInfo class_menu_item_info;
void                 MenuWeaponStatusInfoFormSet(CGameDataUsed *item, CDataWeapon *data);
extern mgCMemory     MainCharaReadStack;
extern CGamePad      GamePad__2;
extern mgCMemory     MenuItemMemory;
extern mgCMemory     MenuItemMemory2;
extern mgCMemory     MenuItemMainMemory;
extern mgCMemory     MenuItemBGDataMemory;
int                  ReadBGSync();

int         AfterSpectolFusion(CGameDataUsed *item, CGameDataUsed *part);
void        local_item_infoview_set(MENUFORMPARTS_TYPE *part, CGameDataUsed *item);
int         MenuItemSelectDiffer(int select);
void        MenuItemCharaActWepInfoDraw(CMenuPosDataForm *form, CGameDataUsed *equip, int chara_no, int flag);
int         MenuAquaKey();
int         NameRegistKey();
int         MenuNPCQuestViewKey();
void        MenuAquaDraw();
void        NameRegistDraw();
void        MenuNPCQuestViewDraw();
static void MenuItemDebugDraw();
void        MenuItemInfoCursorSet(int mode);
void        MenuItemCharaViewCheck(CHARA_DATA *chara, int chara_no, int flag);
static void MenuPosFormValueSetCharaRobo(ROBO_DATA *robo, int flag);
void        MenuPosFormValueSetMonster(MOS_CHANGE_PARAM *monster, CHARA_DATA *chara);
int         CheckFishCondition();

/**
 *
 * Next write address for character model data.
 *
 */
static u8 *MainCharaReadStackReadAdr;

/**
 *
 * Weapon repair effect of the item menu.
 *
 */
CRepairManager *MenuRepairMan;

/**
 *
 * Saved top row of the inventory board.
 *
 */
static s16 MenuItem_ItemBoardTopLine;

/**
 *
 * Saved selection on the inventory board.
 *
 */
static s16 MenuItem_ItemBoardTopSelect;

/**
 *
 * Owned-item limit flags for each character's three active slots.
 *
 */
u8 menu_chara_activeItem_limmit_check[6];

/**
 *
 * Status comparison form for a spectrum fusion.
 *
 */
static CMenuPosDataForm *MenuSpectolSatusCheckForm;

/**
 *
 * Background fade form behind the spectrum status comparison.
 *
 */
static CMenuPosDataForm *MenuSpectolSatusCheckBGFadeForm;

/**
 *
 * Visibility state of the discard message window.
 *
 */
static s8 TrushMesWindowFlag;

/**
 *
 * Motion range of the equipped weapon preview.
 *
 */
static float ActiveMenuWeaponCharaRange;

/**
 *
 * Character whose weapon preview environment is active.
 *
 */
static CActionChara *MenuWeaponEnvSetChara;

/**
 *
 * Non-zero while the character status texture is hidden.
 *
 */
s8 MenuStatusMode;

/**
 *
 * Texture of the character status display.
 *
 */
mgCTexture *MenuStatusTex;

/**
 *
 * Active item-menu controller.
 *
 */
static CMenuItemInfo *CMenuItemInfoPt;

/**
 *
 * Effects of the current spectrumisation or fusion.
 *
 */
CMenuEffect *MenuEffect[2];

/**
 *
 * Loaded spectrumisation sound data.
 *
 */
static u32 *MenuItemSpectolTransSoundBuffer;

/**
 *
 * Attachment and weapon participating in a spectrum fusion.
 *
 */
CGameDataUsed *SpectolInfo[2];

/**
 *
 * Selected side of the spectrum fusion view.
 *
 */
static s16 SpectolFusion_LeftOrRight;

/**
 *
 * Character model receiving the spectrum fusion effect.
 *
 */
CCharacter2 *SpectolFusionTargetChara;

/**
 *
 * Saved special-ability difference for the fusion status display.
 *
 */
static int save_spectol_fusion_spstatus;

/**
 *
 * Position of the item whose command list is open.
 *
 */
s16 MenuItemCmdArgPos;

/**
 *
 * Ridepod pack spectrumisation command variant.
 *
 */
static s16 MenuItemCommand_RoboPackBreakFlag;

/**
 *
 * Side of the screen used by the item command window.
 *
 */
int MenuItemCommandDir;

/**
 *
 * Quantity currently selected by the how-many question.
 *
 */
static int MenuHowHaveMuchNum;

/**
 *
 * Maximum number of items available to spectrumise.
 *
 */
static s16 SpectolBreakNum_Limit;

/**
 *
 * Number of items selected for spectrumisation.
 *
 */
static s16 SpectolBreakNum;

/**
 *
 * Synthesis points supplied by each spectrumised item.
 *
 */
static s16 SpectolBreakSpPoint;

/**
 *
 * Frame counter of the spectrumisation effect.
 *
 */
float trans_spectol_cnt;

/**
 *
 * Acquisition latch for the spectrumisation result.
 *
 */
static s8 spegetflag;

/**
 *
 * Model framing the spectrumisation preview.
 *
 */
static CActionChara *SpectolFrame;

/**
 *
 * Pending spectrumisation inventory position.
 *
 */
static s16 MenuSpectolTransPos;

/**
 *
 * Non-zero while the preview character rotates.
 *
 */
s8 itemmenu_chr_rotflag;

/**
 *
 * Number of items selected for discard.
 *
 */
static s16 MenuTrushNum;

/**
 *
 * Amplitude of the fusion preview colour oscillation.
 *
 */
static float fusion_color_val;

/**
 *
 * Phase of the spectrumisation frame scale oscillation.
 *
 */
static float SpectolFrameScaleAngle;

/**
 *
 * Opacity of the spectrumisation frame.
 *
 */
static float SpectolFrameFadeAlpha;

/**
 *
 * Non-zero while menu effect scripts are paused.
 *
 */
static int FxScriptManPauseFlag;

/**
 *
 * Item metadata displayed by the debug browser.
 *
 */
static CDataCommon *debug_common_data;

/**
 *
 * Non-zero when the viewed weapon needs refreshing.
 *
 */
static u8 view_weapon_flag;

/**
 *
 * Previous weapon used by the preview comparison.
 *
 */
static CGameDataUsed *OldViewWep;

/**
 *
 * Current weapon used by the preview comparison.
 *
 */
static CGameDataUsed *NewViewWep;

/**
 *
 * Screen coordinates of the weapon repair target.
 *
 */
static int MenuRepairTargetWeaponPos[2];

/**
 *
 * Texture of the weapon build-up board.
 *
 */
mgCTexture *Tex_BuildUpBoard;

/**
 *
 * Ridepod sound bank saved before a preview reload.
 *
 */
static int Robo_Sound_ID_Save;

/**
 *
 * Visibility state of the debug model preview.
 *
 */
static s8 MenuDebugModelDrawFlag;

/**
 *
 * Byte count of the loaded debug model data.
 *
 */
static int MenuDebugSize;

/**
 *
 * Character model displayed by the debug preview.
 *
 */
static CActionChara *MenuDebugItemModel;

/**
 *
 * Camera of the debug model preview.
 *
 */
static mgCCamera *MenuDebugCamera;

/**
 *
 * Phase of the weapon durability warning pulse.
 *
 */
static float WeaponWarningCounter;

/**
 *
 * Non-zero when Monica's saved preview rotation is valid.
 *
 */
static u8 MonicaRotationFlag;

/**
 *
 * Mode of the event-requested item selector.
 *
 */
static s8 MenuItemSelectMode;

/**
 *
 * Active event-requested item selector.
 *
 */
static CItemSelect *ItemSelectPtr;

/**
 *
 * Outcome of the most recent item command.
 *
 */
static ITEMCMD_RET_PARA MenuItemCmdRet;

/**
 *
 * Model, skin and outline buffers of the preview character.
 *
 */
static MenuCharaReadBuffers MainCharaReadBuffer;

/**
 *
 * Manager of the menu's weapon level-up effects.
 *
 */
static CLevelUpEffectManager MenuLevelUpMan;

/**
 *
 * Arrows and marks surrounding the item-menu cursor.
 *
 */
MENU_ITEM_CURSOR_INFO MenuItemCursorInfo;

/**
 *
 * Parameter-label parts of the weapon build-up display.
 *
 */
static MENUFORMPARTS_TYPE *BuildUpFormInfoIndex[12];

/**
 *
 * Parameter-value parts of the weapon build-up display.
 *
 */
static MENUFORMPARTS_TYPE *BuildUpFormInfoStatusVol[12];

/**
 *
 * Message windows of the discard menu.
 *
 */
static CDC2Mes *TrushMesCls[4];

/**
 *
 * State of the weapon build-up view.
 *
 */
BUILDUP_WEAPON_INFO BuildUpWeaponInfo;

/**
 *
 * Saved parameter differences for the spectrum fusion display.
 *
 */
static s16 save_spectol_fusion_param[12];

/**
 *
 * Ambient colour of the fusion preview model.
 *
 */
static float fusion_ambient[4];

/**
 *
 * Phase of each fusion preview colour component.
 *
 */
static float fusion_color_ang[4];

/**
 *
 * Base position of the equipped weapon preview.
 *
 */
static float MenuWeaponBasePos[4];

/**
 *
 * Screen position of each prospective build-up weapon name.
 *
 */
s16 BuildUpNameXY[3][2];

/**
 *
 * Saved rotation of Monica's preview model.
 *
 */
static float MonicaRotationData[4];

/**
 *
 * Weapon parameter label parts.
 *
 */
static char *WepStatusInfoStrTable[10] = {"index0", "index1", "index2", "index3", "index4", "index5", "index6", "index7", "index8", "index9"};

/**
 *
 * Weapon parameter value parts.
 *
 */
static char *WepStatusInfoStatusVolStrTable[10] = {"st0", "st1", "el0", "el1", "el2", "el3", "el4", "el5", "el6", "el7"};

/**
 *
 * Direction bits associated with the four cursor movements.
 *
 */
static int MenuCheckKey[4] = {MENU_SELECT_KEY_UP, MENU_SELECT_KEY_DOWN, MENU_SELECT_KEY_LEFT, MENU_SELECT_KEY_RIGHT};

/**
 *
 * Preview-camera attachment names for character equipment.
 *
 */
static char *focusnametbl[21] = {"ef00", "gun_hand", "hat", "R_foot", "sword_hand", "wr", "ac", "R_foot", "", "", "", "", "", "", "", "", "", "", "", "", ""};

/**
 *
 * Cursor limits and edge transitions of each item-menu layout.
 *
 */
static MENU_INPUTKEY_ARG item_menu_argtbl[12] = {
    {{0, 102, -1, 1},        MENU_INPUTKEY_TYPE_LINE, 0, 3,   1, 3, 1,  3, {2, 2, 0, 2}, {-1, 3, -1, 2} },
    {{101, 102, -1, 1},      MENU_INPUTKEY_TYPE_GLID, 0, 2,   1, 2, 1,  2, {2, 2, 0, 2}, {3, 11, -1, 2} },
    {{-1, 1, -1, 1},         MENU_INPUTKEY_TYPE_GLID, 0, 144, 5, 6, 24, 6, {0, 0, 2, 0}, {-1, -1, 0, -1}},
    {{-101, 102, -1, 104},   MENU_INPUTKEY_TYPE_LINE, 0, 1,   1, 1, 1,  1, {2, 2, 0, 2}, {0, 1, -1, 2}  },
    {{0, 102, 0, 104},       MENU_INPUTKEY_TYPE_LINE, 0, 1,   1, 1, 1,  1, {0, 2, 0, 2}, {-1, 5, -1, 2} },
    {{-1, 1, -1, 1},         MENU_INPUTKEY_TYPE_GLID, 0, 10,  5, 2, 5,  2, {2, 0, 0, 2}, {4, -1, -1, 2} },
    {{-101, 102, -103, 104}, MENU_INPUTKEY_TYPE_LINE, 0, 1,   1, 1, 1,  1, {0, 2, 0, 2}, {-1, 7, -1, 2} },
    {{-101, 102, -1, 1},     MENU_INPUTKEY_TYPE_LINE, 0, 2,   1, 2, 1,  2, {2, 0, 0, 2}, {6, -1, -1, 2} },
    {{0, 102, 0, 104},       MENU_INPUTKEY_TYPE_LINE, 0, 1,   1, 1, 1,  1, {0, 0, 0, 2}, {-1, -1, -1, 2}},
    {{0, 102, 0, 104},       MENU_INPUTKEY_TYPE_LINE, 0, 1,   1, 1, 1,  1, {0, 2, 0, 2}, {-1, 10, -1, 2}},
    {{-1, 1, -1, 104},       MENU_INPUTKEY_TYPE_GLID, 0, 5,   5, 1, 5,  1, {2, 0, 0, 2}, {9, -1, -1, 2} },
    {{101, 0, 103, 104},     MENU_INPUTKEY_TYPE_LINE, 0, 1,   1, 1, 1,  1, {2, 0, 0, 2}, {1, -1, 1, 1}  }
};

/**
 *
 * Forms of the item-menu preview pages.
 *
 */
static char *ItemMenuFormNameTbl[6] = {"form_view00", "form_view01", "form_view1", "form_view2", "form_view3", "form_view4"};

/**
 *
 * Part names positioning overflow items.
 *
 */
static char *local_over_flow_baseposname[3] = {"item0", "item1", "item2"};

/**
 *
 * Sound effect for each item exchange result.
 *
 */
s16 menu_item_swap_sndtbl[8] = {-1, 3, 3, 4, 1, 4, 3, 6};

/**
 *
 * Inventory equipment slots associated with ridepod commands.
 *
 */
static s8 MenuRoboEquipTable[4] = {2, 0, -1, -1};

/**
 *
 * Number of inventory slots shown by the item board.
 *
 */
static s16 MenuItemBoardTotalNum = 144;

/**
 *
 * Number of inventory rows shown by the item board.
 *
 */
static s16 MenuItemBoardTotalLine = 90;

/**
 *
 * Weapon-list entry used by the preview environment.
 *
 */
static s16 MenuWeaponEnvSetListNo = -1;

/**
 *
 * Inventory slot of the item being spectrumised.
 *
 */
int trans_spectol_pos = -1;

/**
 *
 * Previous inventory slot used by spectrumisation.
 *
 */
static s16 trans_spectol_posold = -1;

/**
 *
 * Alpha of the spectrumisation item icon.
 *
 */
static int trans_spectol_rgb = 128;

/**
 *
 * Position oscillation amplitude of the spectrumisation frame.
 *
 */
static float SpectolFramePosValue = 1.39999998f;

/**
 *
 * Character attachment category selected by the preview camera.
 *
 */
static s8 menu_camera_reference_id = -1;

void MenuAquaInit(mgCMemory *memory, int *data, int arg);
void NameRegistInit(mgCMemory *memory, int *data, int arg);

int  GetItemCommandMsg(CGameDataUsed *item, MENU_ASKMODE_PARA *param, int slot, int arg);
int  GetItemCommandMsg(CGameDataUsed *item, int *cmds, u32 *colors, short *values, short *marks, int type,
                       int arg);
void MenuFormUpdataAttachInfo(CMenuPosDataForm *form, CGameDataUsed *item, int item_no, int reset,
                              short *b);

void SetupUnitMan(CScene *scene, CUserDataManager *user_data, int unit, ROBO_INFO_DATA *robo);
void InitSpectol();
void MenuItemDebugKey();

/**
 *
 * Equipment attachment selected by the preview camera.
 *
 */
static s8 menu_camera_reference_no = -1;

/**
 *
 * Initial preview page for each player-character selection.
 *
 */
static s8 menuitem_initviewtbl[4] = {MENU_ITEM_VIEW_MAX, MENU_ITEM_VIEW_MONICA, MENU_ITEM_VIEW_ROBO, MENU_ITEM_VIEW_MONSTER};

/**
 *
 * Initial cursor layout for each player-character selection.
 *
 */
static s8 menuitem_initmenumode[4] = {3, 3, 6, 8};

/**
 *
 * Form displaying inventory overflow items.
 *
 */
static char *OverFlowFormName = "overitem";

/**
 *
 * Non-zero when debug model adjustments are enabled.
 *
 */
static s8 MenuDebugModel_AdjustFlag = 1;

/**
 *
 * Preview page associated with each cursor character command.
 *
 */
static s8 SameviewmodeTable_8406[4] = {0, 1, 3, 4};

// Code (.text)
/**
 *
 * Advances and draws the active message windows in the trash menu.
 *
 */
void DrawTrushMenuMessage() {
    int i;
    mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) 0);

    for (i = 0; i < 4; i++) {
        if (TrushMesCls[i]) {
            TrushMesCls[i]->StepMsg();
            TrushMesCls[i]->DrawMsg();
        }
    }
}

CBaseMenuClass::CBaseMenuClass() {
    int i;

    swap_info.Set(-1, 0, -1, 0);
    memset(this, 0, sizeof(CBaseMenuClass));
    opened = 0;
    mode = MENU_ASK_MODE_OPEN;
    step = 0;
    message_type = 0;
    script = NULL;
    script_size = 0;
    unk_10 = 0x80;
    key_arg_no = 0;

    for (i = 0; i < 16; i++) {
        tex_block[i] = -1;
    }

    cmd_arg_pos = -1;
    unk_F8 = 0;
    step = 0;
    SetAskParam(NULL);
    memset(&make_item_no, 0, 0x10);
}

void CBaseMenuClass::SetTexBlock(int *block) {
    int i;

    for (i = 0; i < 16; i++) {
        tex_block[i] = block[i];

        if (tex_block[i] <= 0) {
            tex_block[i] = -1;
            break;
        }
    }

    DeleteTexBlock();
}

void CBaseMenuClass::DeleteTexBlock() {
    MenuDeleteTextureBlock(tex_block);
}

int CBaseMenuClass::MenuItemCommnadSelectPrepare(CGameDataUsed *item, int slot, int arg) {

    if (item == NULL) {
        return 0;
    }

    if (item->used_type > 0) {
        cmd_arg_pos = slot;
        MENU_ASKMODE_PARA param;
        return (GetItemCommandMsg(item, &param, cmd_arg_pos, arg) <= 0) ^ 1;
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
        MenuItemCmdRet.menu_cmd = -2;
        MenuItemCmdRet.item2 = NULL;
        MenuItemCmdRet.item = NULL;
        MenuItemCmdRet.num = 0;
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

template <typename T>
static inline T Ident(T v) { return v; }

int CBaseMenuClass::MenuItemCommandSelect(int select_key, int push_button) {
    CGameDataUsed    *used_data = MenuUserParam.used_data;
    u_long            target;
    CUserDataManager *user = GetUserDataMan();
    MenuItemCmdRet.cmd = -1;
    int      decided = 0;
    CDC2Mes *mes = MenuDCMsg[ask_para.mes_no];
    int      ret = 0;

    switch (step) {
        case 0: {
            /**
             *
             * Delay counter of the item command selection.
             *
             */
            static s8 cmd_counter = 0;
            cmd_counter++;

            if (cmd_counter >= 50) {
                cmd_counter = 0;
            }

            for (int i = 0; i < 16; i++) {
                if (ask_para.cmd_mark[i] == 1) {
                    if (i >= 0 && i < MES_LINE_MAX) {
                        mes->line_color[i] = 0x80DC4848;
                    }

                    if (cmd_counter > 25 && i >= 0 && i < MES_LINE_MAX) {
                        mes->line_color[i] = 0x80686A6B;
                    }
                }
            }

            int select = -1;

            if (LanguageCode > 0) {
                if (push_button & MENU_PUSH_BUTTON_DECIDE) {
                    select = 0;
                } else if (push_button & MENU_PUSH_BUTTON_CANCEL) {
                    select = 1;
                }
            } else if (push_button & (MENU_PUSH_BUTTON_DECIDE | MENU_PUSH_BUTTON_TRIANGLE | MENU_PUSH_BUTTON_SQUARE)) {
                select = 0;
            } else if (push_button & MENU_PUSH_BUTTON_CANCEL) {
                select = 1;
            }

            mes->CommandMsgCursor();

            switch (select) {
                case 0: {
                    if (ask_para.item == NULL) {
                        break;
                    }

                    int            cursor = mes->GetMsgCursor();
                    int            cmd = ask_para.cmd_msg[cursor] - 5000;
                    int            space = user->SearchSpaceUsedData();
                    CGameDataUsed *space_item = NULL;

                    if (0 <= space && space < GetNowBagMax(0)) {
                        space_item = &MenuUserParam.used_data[space];
                    }

                    MenuItemCmdRet.menu_cmd = cmd;

                    if (cmd == -1) {
                        MenuItemCmdRet.cmd = 5;
                    } else if (cmd == 0) {
                        MenuItemCmdRet.cmd = 5;
                    } else if (cmd == 1) {
                        MenuItemCmdRet.cmd = 1;
                    } else if (cmd == ITEM_MENU_COMMAND_EQUIP) {
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
                        MenuItemCmdRet.result = slot;
                        MenuItemCmdRet.cmd = 8;
                    } else if (cmd == ITEM_MENU_COMMAND_EQUIP_RIDEPOD_PART) {
                        if (ask_para.cmd_color[cursor] == 0x80202020) {
                            MenuItemCmdRet.cmd = 0x1C;
                        } else {
                            ROBO_DATA *robo = MenuUserParam.robo;
                            int        item_no = ask_para.item->item_no;
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
                            MenuItemCmdRet.result = slot;
                            MenuItemCmdRet.cmd = 8;
                        }
                    } else if (cmd == 3 || cmd == 8) {
                        MenuItemCmdRet.cmd = 1;
                    } else if (cmd == ITEM_MENU_COMMAND_REPAIR) {
                        MenuItemCmdRet.cmd = 5;
                        CGameDataUsed *repair = user->SearchAllHaveItem(ask_para.item->GetEnableRepairItemNo());

                        if (MenuItemUse.UseItem(repair, ITEM_USE_TARGET_ITEM, ask_para.item) == 0) {
                            MenuItemCmdRet.cmd = 5;
                        } else {
                            MenuItemCmdRet.cmd = -1;
                            decided = 1;
                            MenuItemCmdRet.result = 1;
                        }
                    } else if (cmd == ITEM_MENU_COMMAND_SET_ACTIVE_ITEM) {
                        if (ask_para.cmd_color[cursor] == 0x80202020) {
                            MenuItemCmdRet.result = -1;
                            MenuItemCmdRet.cmd = 0x1C;
                            break;
                        }

                        CHARA_DATA *chara = MenuUserParam.chara[CMenuItemInfoPt->sub_view];
                        int         item_no = ask_para.item->item_no;

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

                            if (Ident(ask_para.item->item_no) == MenuItemCmdRet.item->item_no) {
                                MenuItemCmdRet.num = MenuItemCmdRet.item->GetActiveSetNum() - MenuItemCmdRet.item->GetNum();

                                if (ask_para.item->GetNum() > MenuItemCmdRet.num) {
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
                                MenuItemCmdRet.num = num;
                            }

                            MenuItemCmdRet.cmd = 1;
                        }
                    } else if (cmd == ITEM_MENU_COMMAND_SPECTRUMIZE) {
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
                    } else if (cmd == ITEM_MENU_COMMAND_GIFT_BOX_CONTENTS) {
                        if (ask_para.cmd_color[cursor] == 0x80202020) {
                            MenuItemCmdRet.cmd = 5;
                            break;
                        }

                        if (ask_para.item->GetGiftBoxItemNum() > 0) {
                            MenuItemCmdRet.cmd = 1;
                        }
                    } else if (cmd == ITEM_MENU_COMMAND_PUT_IN_AQUARIUM) {
                        if (ask_para.cmd_color[cursor] == 0x80202020) {
                            MenuItemCmdRet.cmd = 5;
                        } else {
                            MenuItemCmdRet.cmd = 6;
                            user->FishInAquarium(ask_para.item, 0);
                        }
                    } else if (cmd == ITEM_MENU_COMMAND_BOIL_FISH) {
                        ask_para.item->Boiled();
                    } else if (cmd == ITEM_MENU_COMMAND_USE_ON_MAX || cmd == ITEM_MENU_COMMAND_USE_ON_MONICA) {
                        CHARA_DATA *target_chara;

                        if (ask_para.cmd_color[cursor] == 0x80202020) {
                            MenuItemCmdRet.cmd = 5;
                            target_chara = NULL;

                            if (cmd == ITEM_MENU_COMMAND_USE_ON_MAX) {
                                target_chara = MenuUserParam.chara[0];
                            }

                            if (cmd == ITEM_MENU_COMMAND_USE_ON_MONICA) {
                                target_chara = MenuUserParam.chara[1];
                            }

                            ((CItemUseTarget *) &target)->SetPtr((int) ITEM_USE_TARGET_CHARA, target_chara);
                            MenuUseItemCheckFunc(ask_para.item, (CItemUseTarget *) &target, 0);

                            if (MenuUsedNotErrorCode == 1) {
                                MenuItemCmdRet.result = 10;
                            }
                        } else {
                            target_chara = MenuUserParam.chara[cmd - ITEM_MENU_COMMAND_USE_ON_MAX];
                            MenuItemCmdRet.item_no = ask_para.item->item_no;
                            MenuItemCmdRet.result = MenuItemUse.UseItem(ask_para.item, ITEM_USE_TARGET_CHARA, target_chara);

                            if (0 < MenuItemCmdRet.result &&
                                (MenuItemCmdRet.item_no == 0x124 || MenuItemCmdRet.item_no == 0x110)) {
                                MenuItemCmdRet.result = 1;
                            }
                        }
                    } else if (cmd == 17) {
                    } else if (cmd == ITEM_MENU_COMMAND_USE_ON_MONSTER) {
                        if (ask_para.cmd_color[cursor] == 0x80202020) {
                            MenuItemCmdRet.cmd = 5;
                        } else {
                            MenuItemCmdRet.item_no = ask_para.item->item_no;
                            MenuItemCmdRet.result = MenuItemUse.UseItem(ask_para.item, ITEM_USE_TARGET_MONSTER, MenuUserParam.monster);
                        }
                    } else if (cmd == ITEM_MENU_COMMAND_USE_ON_PRIMARY_WEAPON || cmd == ITEM_MENU_COMMAND_USE_ON_SECONDARY_WEAPON) {
                        if (ask_para.cmd_color[cursor] == 0x80202020) {
                            MenuItemCmdRet.cmd = 5;
                        } else {
                            MenuItemCmdRet.result = MenuItemUse.UseItem(ask_para.item, ITEM_USE_TARGET_ITEM, &Ident(MenuUserParam.chara[CMenuItemInfoPt->sub_view])->equip[cmd - ITEM_MENU_COMMAND_USE_ON_PRIMARY_WEAPON]);
                        }
                    } else if (cmd == 21 || cmd == 22) {
                        if (ask_para.cmd_color[cursor] == 0x80202020) {
                            MenuItemCmdRet.cmd = 5;
                        } else if (ask_para.item != NULL && cmd == 22) {
                            CGameDataUsed *core = MenuUserDataManPtr->SearchItemOnItemBrd((int) ITEM_ID_RIDEPOD_FUEL, 1);

                            if (core != NULL) {
                                MenuItemCmdRet.result = MenuItemUse.UseItem(core, ITEM_USE_TARGET_ROBO, ask_para.item);
                            }
                        } else {
                            s8 part_slot[4] = {0, 2, -1, -1};
                            MenuItemCmdRet.result =
                                MenuItemUse.UseItem(ask_para.item, ITEM_USE_TARGET_ITEM, &MenuUserParam.robo->parts[part_slot[cmd - 21]]);
                        }
                    } else if (cmd == ITEM_MENU_COMMAND_VIEW_BUILD_UP) {
                        if (ask_para.cmd_color[cursor] == 0x80202020) {
                            MenuItemCmdRet.cmd = 5;
                        }
                    } else if (cmd == ITEM_MENU_COMMAND_RENAME) {
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
                            int            esa_no = esa->item_no;
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
                            MenuItemCmdRet.no_equipped_rod = 0;

                            if (user->NowFishingStyle() == 0) {
                                rod_no = ask_para.item->item_no;
                                MenuItemCmdRet.no_equipped_rod = 1;
                            }

                            CGameDataUsed *esa = user->GetActiveEsa(rod_no);
                            MenuItemCmdRet.result = user->SearchSpaceUsedData(esa->item_no);
                            CGameDataUsed *esa_space = user->SearchSpaceUsedDataPtr(esa->item_no);

                            if (MenuItemCmdRet.no_equipped_rod == 1) {
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
                    } else if (cmd == ITEM_MENU_COMMAND_ENABLE_RIDEPOD_VOICE || cmd == ITEM_MENU_COMMAND_DISABLE_RIDEPOD_VOICE) {
                        if (cmd == ITEM_MENU_COMMAND_ENABLE_RIDEPOD_VOICE) {
                            user->SetRoboVoiceFlag(1);
                        } else {
                            user->SetRoboVoiceFlag(0);
                        }

                        MenuSePlay(SYSTEM_SE_DECIDE);
                    } else if (cmd == 37) {
                        CGameDataUsed *core = MenuUserDataManPtr->SearchItemOnItemBrd(MenuUserDataManPtr->CheckRobotCore(), 1);
                        MenuItemCmdRet.result = MenuItemUse.UseItem(ask_para.item, ITEM_USE_TARGET_ITEM, core);
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
                    } else if (cmd == ITEM_MENU_COMMAND_VIEW_FISHING_ROD) {
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
                    MenuItemCmdRet.menu_cmd = -1;
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

void CBaseMenuClass::SetItemCmdMsgPos(int *item_pos) {
    /**
     *
     * Message box horizontal offset for each equipment cursor.
     *
     */
    static s8 tartbl[2] = {16, 0};

    /**
     *
     * Message pointer horizontal position for each equipment cursor.
     *
     */
    static s8 wakutbl[2] = {16, 30};

    int pos[2] = {item_pos[0] + 4, item_pos[1] + 0x2A};
    int cmd_num = ask_para.cmd_num;
    int width = 0;
    int lines = 0;
    MenuItemCommandDir = 1;
    CDC2Mes *message = MenuDCMsg[ask_para.mes_no];

    if (message == NULL) {
        return;
    }

    for (int i = 0; i < cmd_num; i++, lines++) {
        if (message->item_mes[i] < 0) {
            break;
        }

        int line_width = message->GetMesWidth_system(message->item_mes[i]);

        if (width < line_width) {
            width = line_width;
        }
    }

    int               height = message->font_h * lines;
    CMenuPosDataForm *form = ask_para.form;
    CGameDataUsed    *item = ask_para.item;
    int               fishing_rod = 0;

    if (mode == MENU_ASK_MODE_ITEM_COMMAND) {
        if (item == NULL || form == NULL) {
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
            {
                int cursor = MenuCommonInfo->cursor;
                message->point_x = wakutbl[cursor];
                pos[0] += tartbl[cursor];
            }
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
                int *pos_y = &pos[1];
                pos[0] -= 0x12;
                *pos_y += 0x1C;

                if (*pos_y + height > 0x132) {
                    *pos_y = *pos_y - height - 0x5E;
                    message->point_y = height * 3;
                }

                if (*pos_y < 0x14) {
                    while (item_pos[0] < pos[0] + width + 0x1A) {
                        pos[0] -= 2;
                    }

                    while (*pos_y + height < item_pos[1] + 0x32) {
                        *pos_y += 2;
                    }

                    message->point_x = width + 0x1E;
                    message->point_y = height - 0xE;

                    while (*pos_y < 0x14) {
                        (*pos_y)++;
                        message->point_y--;
                    }

                    MenuItemCommandDir = 2;
                }

                if (pos[0] + width > 0x1E4) {
                    pos[0] = 0x1D0 - width;
                    message->point_x = item_pos[0] + 0x1A - pos[0];
                }
            }

            break;
        case 7:
            message->point_x = 0x14;
            message->point_y = 0x3C;
            pos[0] += 0x3C;
            pos[1] -= 0x78;
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

/**
 *
 * Changes the selected item quantity within the available or supplied limit.
 *
 */
int MenuHowMuchNumSelect(int key, CGameDataUsed *item, int limit) {
    short step = 0;
    int   max_num;
    int   before;
    int   changed;

    if (key & MENU_SELECT_KEY_UP) {
        step += 1;
    } else if (key & MENU_SELECT_KEY_DOWN) {
        step -= 1;
    }

    if ((key & MENU_SELECT_KEY_L1) || (key & MENU_SELECT_KEY_L2)) {
        step -= 5;
    } else if ((key & MENU_SELECT_KEY_R1) || (key & MENU_SELECT_KEY_R2)) {
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

    MenuCommonInfo->how_much_form->SetNumber("num", MenuHowHaveMuchNum);
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

    MenuCommonInfo->how_much_form->SetNumber("num", MenuHowHaveMuchNum);
}

CGameDataUsed *CheckTrushWeapon(CGameDataUsed *item) {
    CGameDataUsed *slot = GetUserDataMan()->GetUsedDataPtr(0);
    int            bag_max = GetNowBagMax(1);
    int            i;

    for (i = 0; i < bag_max; i++, slot++) {
        if (slot != item && slot->item_type == ITEM_DATA_MAX_MELEE && !slot->IsFishingRod()) {
            return slot;
        }
    }

    return NULL;
}

int CBaseMenuClass::CheckSpectolFusion(CGameDataUsed *item, int panel, CMenuPosDataForm *form) {
    CDC2Mes       *message;
    int            held_type;
    CGameDataUsed *held = (CGameDataUsed *) (&MenuCommonInfo->have_item);
    held_type = GetItemDataType(MenuCommonInfo->have_item.item_no);
    GetItemDataType(item->item_no);
    int kind = item->used_type;

    if (kind == 0) {
        return 0;
    }

    if (held_type == 0x11) {
        mode = (int) MENU_ASK_MODE_FUSION;
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
                CGameDataUsed before;
                CGameDataUsed after;
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

        char *names[1] = {NULL};
        names[0] = item->GetName(1);
        message->SetMsgItemNo(names, 1);
        SetAskParam(&param);
        message->SetAbsPos(abs_pos);
        return 1;
    }

    return 0;
}

/**
 *
 * Updates the spectol breakdown message and resulting attachment preview.
 *
 */
void UpdataInfoSpectolBreakItem(CDC2Mes *mes, CGameDataUsed *item, int count) {
    int volume[4] = {0, 0, 0, 0};
    volume[0] = count;
    volume[1] = SpectolBreakSpPoint * count;
    mes->SetMsgVolumeNo(volume, 2);
    mes->fade_speed = 1.0f;
    CGameDataUsed result;
    item->ToSpectolTrans(&result, count);
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

void TransSpectolDataSave(CGameDataUsed *item, int count);

int CBaseMenuClass::IsSpectolTrans(int select_key, int push_button) {
    CDC2Mes          *message = MenuDCMsg[ask_para.mes_no];
    CMenuPosDataForm *form = MenuMesForm[ask_para.mes_no];
    int               cancel = 0;
    int               result = 0;

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
                            MenuSePlay(SYSTEM_SE_DECIDE);

                            if (MenuCommonInfo->cursor_form != NULL) {
                                MenuCommonInfo->cursor_form->draw_flag = 0;
                            }

                            result = 2;
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
            int          effect_type = effect->type;

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

            if (push_button & MENU_PUSH_BUTTON_DECIDE) {
                SpectolBreakNum = MenuHowHaveMuchNum;

                if (MenuUserDataManPtr->SearchSpaceUsedData() < 0 && ask_para.item->GetNum() > MenuHowHaveMuchNum) {
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
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }
            } else if (push_button & MENU_PUSH_BUTTON_CANCEL) {
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

int CBaseMenuClass::IsSpectolFusion(int key, int command) {
    CDC2Mes          *message;
    CMenuPosDataForm *form;

    /**
     *
     * Non-zero after the fusion sound begins.
     *
     */
    static s8 sndflag = 0;

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
                        sndflag = 0;
                        return 2;
                    }
                case 2:
                    form->draw_flag = 0;

                    if (MenuCommonInfo->cursor_form != NULL) {
                        MenuCommonInfo->cursor_form->draw_flag = 1;
                    }

                    mode = (int) MENU_ASK_MODE_NONE;
                    step = 0;
                    itemmenu_chr_rotflag = 1;
                    MenuSePlay(5);
                    return 1;
            }

            break;
        case 1: {
            if (!sndflag && ReadBGSync() == 0) {
                sndflag = 1;
                void *file = GetReadBGFile(0);

                if (file != NULL) {
                    MenuSePlay(0, *(unsigned int **) ((u8 *) file + 0x110), &MenuSoundBuffer);
                }
            }

            if (*(&MenuEffect[0]->run) == 0) {
                MenuEffect[0]->run = 0;
                MenuEffect[1]->run = 0;
                int raised = AfterSpectolFusion(SpectolInfo[0], &SpectolInfoStay);
                message->MsgPreset(10);
                message->SetAbsPos(0x12);
                char *names[2] = {NULL, NULL};
                names[0] = SpectolInfo[0]->GetName(1);
                message->SetMsgItemNo(names, 1);

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

    if (item->item_type == ITEM_DATA_MAX_MELEE) {
        CUserDataManager *user_data = GetUserDataMan();
        CGameDataUsed    *slot = user_data->GetUsedDataPtr(0);
        int               weapon_count = 0;
        int               bag_max = GetNowBagMax(1);
        int               i;

        for (i = 0; i < bag_max; i++, slot++) {
            if (slot->item_type == ITEM_DATA_MAX_MELEE && !slot->IsFishingRod()) {
                weapon_count++;
            }
        }

        if (weapon_count < 2 && user_data->chara_data[(int) USER_CHARA_MAX].equip[0].IsFishingRod()) {
            show = 0;
        }
    }

    return show;
}

int CBaseMenuClass::IsTrush(int key, int command) {
    CMenuPosDataForm *form = MenuMesForm[ask_para.mes_no];
    CDC2Mes          *message = MenuDCMsg[ask_para.mes_no];

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
    int            before;
    CGameDataUsed *gift_box;
    int            item_no;
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
            mode = (int) MENU_ASK_MODE_NONE;
            GiftBoxViewFlag = 0;
            MenuSePlay(5);
            break;
    }

    return 0;
}

/**
 *
 * Positions the quantity selection board around the current menu cursor.
 *
 */
void SetConditionHowMuchBoard() {
    CMenuPosDataForm *board = MenuCommonInfo->how_much_form;
    int               cursor_pos[2];

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
    mode = (int) MENU_ASK_MODE_HOW_MUCH;
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
    int i;

    if (param == NULL) {
        ask_para.Initialize();
        return;
    }

    ask_para.unk_0 = param->unk_0;
    ask_para.mes_no = param->mes_no;
    ask_para.cmd_num = param->cmd_num;

    for (i = 0; i < 16; i++) {
        ask_para.cmd_message_and_color_words[i] = param->cmd_message_and_color_words[i];
        ask_para.cmd_color_and_mark_words[i] = param->cmd_color_and_mark_words[i];
        ask_para.cmd_mark_words[i] = param->cmd_mark_words[i];
    }

    ask_para.unk_74 = param->unk_74;
    ask_para.form = param->form;
    ask_para.ask_mode = param->ask_mode;
    ask_para.arg0 = param->arg0;
    ask_para.item = param->item;
    ask_para.arg1 = param->arg1;
    ask_para.item2 = param->item2;
    ask_para.unk_6C = param->unk_6C;
    ask_para.unk_84 = param->unk_84;
    ask_para.unk_6E = param->unk_6E;
    ask_para.unk_88 = param->unk_88;
}

void CBaseMenuClass::ExeScript(char *script) {
    MenuCommandAnalyze(this->script, script_size, script);
}

int CBaseMenuClass::ExtendCommand(int key, int command) {
    int                result = 0;
    CBaseMenuClass    *menu = this;
    short              ask_mode = mode;
    MENU_ASKMODE_PARA *param = &menu->ask_para;

    if (ask_mode == (int) MENU_ASK_MODE_ITEM_COMMAND) {
        result = MenuItemCommandSelect(key, command);
        menu->ItemCmdAfter(result, &MenuItemCmdRet);
    } else if (ask_mode == (int) MENU_ASK_MODE_SPECTOL) {
        result = IsSpectolTrans(key, command);
    } else if (ask_mode == (int) MENU_ASK_MODE_HOW_MUCH) {
        MenuItemAskMode_HowMuch(key, command);
    } else if (ask_mode == (int) MENU_ASK_MODE_FUSION) {
        result = IsSpectolFusion(key, command);
    } else if (ask_mode == (int) MENU_ASK_MODE_TRUSH) {
        result = IsTrush(key, command);
    } else if (ask_mode == (int) MENU_ASK_MODE_ITEM_USE_NUM) {
        result = IsItemUseNum(param->mes_no, key, command, (CGameDataUsed *) (&MenuCommonInfo->have_item),
                              &MenuItemUseTarget);
    } else if (ask_mode == (int) MENU_ASK_MODE_GIFT_BOX) {
        result = SelectInGiftBox(key, command);
    } else if (ask_mode == (int) MENU_ASK_MODE_CREATE) {
        result = menu->IsCreateObject(key, command);
    } else if (ask_mode == (int) MENU_ASK_MODE_MAKE) {
        result = menu->IsMakeObject(key, command);
    } else if (ask_mode == (int) MENU_ASK_MODE_EXTEND) {
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

    mode = (int) MENU_ASK_MODE_NONE;
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
    menu->mode = (int) MENU_ASK_MODE_TRUSH;
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
    menu->mode = (int) MENU_ASK_MODE_SPECTOL;
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
    menu->mode = (int) MENU_ASK_MODE_GIFT_BOX;
    menu->step = 0;
    GiftBoxViewFlag = 1;
    MENU_ASKMODE_PARA param;
    param.item = item;
    menu->SetAskParam(&param);
}

/**
 *
 * Checks whether fishing is available on the current map and battle state.
 *
 */
int CheckFishCondition() {
    CScene          *scene;
    DNG_BATTLE_AREA *battle_scene;
    int              map_no;
    int              enabled;
    int              result;

    scene = GetMainScene();
    battle_scene = menu_GetBattleAreaScene();
    map_no = scene->now_map_no;
    enabled = 1;

    if (map_no == 0x7D) {
        enabled = 0;
    }

    if ((map_no == 0x63) || (map_no == 0x5F)) {
        enabled = 0;
    }

    result = enabled;

    if (GetMenuLoopType() == (int) MENU_LOOP_DUNGEON) {
        if (battle_scene->battle_clear == 0) {
            enabled = 0;
        }

        result = enabled;
    }

    return result;
}

void CMENU_USERPARAM::Initialize() {
    chara[1] = NULL;
    chara[0] = NULL;
    robo = NULL;
    monster = NULL;
    used_data = NULL;
    monster1 = NULL;
}

void CMENU_USERPARAM::AttachInfo() {
    Initialize();
    chara[0] = MenuUserDataManPtr->GetCharaDataPtr(USER_CHARA_MAX);
    chara[1] = MenuUserDataManPtr->GetCharaDataPtr(USER_CHARA_MONICA);
    robo = &MenuUserDataManPtr->robo_data;
    used_data = MenuUserDataManPtr->GetUsedDataPtr(0);
    monster1 = MenuUserDataManPtr->GetMonsterBajjiDataPtr(1);
    monster = MenuUserDataManPtr->GetMonsterBajjiDataPtrMosId(MenuUserDataManPtr->monster_id);
}

void MENU_ASKMODE_PARA::Initialize() {
    memset(this, 0, sizeof(*this));
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

    if (part->used_type == USED_ITEM_TYPE_ROBO_PART) {
        int    capacity = 0;
        int    used;
        int    slot;
        int    type;
        short *cost;
        used = CheckNowRoboUseCapacity(MenuUserParam.robo, &capacity);
        type = part->item_type;
        cost = (short *) GameItemDataManage.GetRoboData(part->item_no);
        slot = 0;

        for (; slot < 4; slot++) {
            if (type == MenuUserParam.robo->parts[slot].item_type) {
                short *equipped_cost =
                    (short *) GameItemDataManage.GetRoboData(MenuUserParam.robo->parts[slot].item_no);

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

        if (part->item_type == ITEM_DATA_ROBO_ENERGY_PACK) {
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

/**
 *
 * Initializes the second spectol information panel when present.
 *
 */
void InitSpectol() {
    if (SpectolInfo[1] != NULL) {
        SpectolInfo[1]->Init();
    }
}

/**
 *
 * Applies an attachment's spectol values to a weapon and counts raised stats.
 *
 */
int AfterSpectolFusion(CGameDataUsed *item, CGameDataUsed *part) {
    WEAPON_USED *target;
    ATTACH_USED *spectol;
    int          first;
    int          lowest;
    unsigned int attribute;
    int          raised;
    int          i;

    if (item == NULL) {
        return 0;
    }

    target = &item->data.weapon;
    spectol = &part->data.attach;
    item->GetStatusParam(save_spectol_fusion_param);

    if (*(s8 *) &spectol->spectol_type == SPECTOL_TYPE_WEAPON) {
        lowest = target->status[WEAPON_STAT_ATTACK];
        first = lowest;

        if (lowest < spectol->status[WEAPON_STAT_ATTACK]) {
            first = spectol->status[WEAPON_STAT_ATTACK];
        } else {
            lowest = spectol->status[WEAPON_STAT_ATTACK];
        }

        target->status[WEAPON_STAT_ATTACK] = first + lowest / 4;
    } else {
        target->status[WEAPON_STAT_ATTACK] = target->status[WEAPON_STAT_ATTACK] + spectol->status[WEAPON_STAT_ATTACK];
    }

    target->status[WEAPON_STAT_DURABILITY] += spectol->status[WEAPON_STAT_DURABILITY];
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
    save_spectol_fusion_param[0] = target->status[WEAPON_STAT_ATTACK] - save_spectol_fusion_param[0];
    save_spectol_fusion_param[1] = target->status[WEAPON_STAT_DURABILITY] - save_spectol_fusion_param[1];
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

void FusionColor(int type, int step, float *color) {
    /**
     *
     * Phase increments of the fusion preview colour oscillation.
     *
     */
    static float addtbl[4] = {0.0981747732f, 0.0897597894f, 0.08267349f, 0.0668423995f};

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
            fusion_color_ang[i] += addtbl[i];
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
        *(u_long128 *) color = *(u_long128 *) fusion_ambient;
    }
}

/**
 *
 * Positions and animates the character frame shown during spectol conversion.
 *
 */
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

/**
 *
 * Saves the source item state and consumes the amount converted to spectol.
 *
 */
void TransSpectolDataSave(CGameDataUsed *item, int count) {
    memcpy(&SpectolTransBefore, item, sizeof(CGameDataUsed));

    if (SpectolTransBefore.used_type == USED_ITEM_TYPE_ITEM) {
        SpectolTransBefore.data.item.num = count;
    } else if (SpectolTransBefore.used_type == USED_ITEM_TYPE_ATTACH) {
        SpectolTransBefore.data.attach.num = count;
    }

    item->DeleteNum(count);
}

int CheckNowRoboUseCapacity(int *capacity) {
    int    used;
    short *item_info;

    used = CheckNowRoboUseCapacity(MenuUserParam.robo, capacity);

    if (*capacity == 0) {
        item_info = (short *) GetItemInfoData(MenuCommonInfo->have_item.item_no);

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
                       int limit_mode) {
    int before = *cursor;
    int result = (int) MENU_CURSOR_UNCHANGED;
    *cursor = before + step;

    if (limit_mode == (int) MENU_CURSOR_LIMIT_CLAMP) {
        if (*cursor < min) {
            *cursor = min;
        }

        if (max <= *cursor) {
            *cursor = max - 1;
        }

        if (before != *cursor) {
            result = (int) MENU_CURSOR_MOVED;
        }
    } else if (limit_mode == (int) MENU_CURSOR_LIMIT_WRAP) {
        if (*cursor < min) {
            *cursor = max - 1;
        }

        if (max <= *cursor) {
            *cursor = min;
        }

        if (before != *cursor) {
            result = (int) MENU_CURSOR_MOVED;
        }
    } else if (limit_mode == (int) MENU_CURSOR_LIMIT_EXIT) {
        if (before != *cursor) {
            result = (int) MENU_CURSOR_MOVED;
        }

        if (*cursor < min) {
            *cursor = min;
            result = (int) MENU_CURSOR_EXIT;
        }

        if (*cursor >= max) {
            result = (int) MENU_CURSOR_EXIT;
            *cursor = max - 1;
        }
    } else if (limit_mode == (int) MENU_CURSOR_LIMIT_REJECT) {
        if (before != *cursor) {
            result = (int) MENU_CURSOR_MOVED;
        }

        if (*cursor < min) {
            result = (int) MENU_CURSOR_BLOCKED;
        }

        if (*cursor >= max) {
            result = (int) MENU_CURSOR_BLOCKED;
        }

        if (result == (int) MENU_CURSOR_BLOCKED) {
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
    int key_mask[2][2] = {
        {MENU_SELECT_KEY_UP,   MENU_SELECT_KEY_DOWN },
        {MENU_SELECT_KEY_LEFT, MENU_SELECT_KEY_RIGHT}
    };
    int *key_ptr = key_mask[key_pair];

    if (keys & key_ptr[0]) {
        *cursor -= 1;
    }

    if (keys & key_ptr[1]) {
        *cursor += 1;
    }

    int wrap[2][2] = {
        {0, 0},
        {0, 0}
    };
    int *wrap_ptr = wrap[wrap_kind];
    wrap[0][1] = count - 1;
    wrap[1][0] = count - 1;

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

int MenuListSelectKeyCheck(int keys, int page_size) {
    int step = 0;

    if (keys & (int) MENU_SELECT_KEY_UP) {
        step -= 1;
    } else if (keys & (int) MENU_SELECT_KEY_DOWN) {
        step += 1;
    }

    if (keys & (int) MENU_SELECT_KEY_L1) {
        step -= page_size - 1;
    } else if (keys & (int) MENU_SELECT_KEY_R1) {
        step += page_size - 1;
    }

    return step;
}

int MenuItemBrdKey(int keys, int *cursor, int *scroll, int board) {
    int before;
    int row;
    int result;
    int column_step;
    int bag_max;
    int row_step;

    before = *cursor;
    row_step = 0;

    if (keys & (int) MENU_SELECT_KEY_UP) {
        row_step -= 1;
    }

    if (keys & (int) MENU_SELECT_KEY_DOWN) {
        row_step += 1;
    }

    bag_max = GetNowBagMax(board);

    if (row_step < 0) {
        CalcMenuAdd2(cursor, -6, 0);
    }

    if (row_step > 0) {
        CalcMenuAdd2(cursor, 6, bag_max - 1);
    }

    row = *cursor / 6;

    if (row - *scroll < 0) {
        *scroll = row;
    }

    while (!(row < *scroll + 5)) {
        *scroll += 1;
    }

    column_step = 0;

    if (keys & (int) MENU_SELECT_KEY_LEFT) {
        column_step -= 1;
    }

    result = 0;

    if (keys & (int) MENU_SELECT_KEY_RIGHT) {
        column_step += 1;
    }

    if (column_step < 0) {
        result = CalcMenuAdd2(cursor, column_step, row * 6);
    }

    if (column_step > 0) {
        CalcMenuAdd2(cursor, column_step, (row + 1) * 6 - 1);
    }

    if (before != *cursor) {
        MenuSePlay(0);
    }

    return result;
}

/**
 *
 * Identifies the result of exchanging items between menu slots.
 *
 */
enum MENU_SWAP_RESULT {
    MENU_SWAP_RESULT_FAILED = 0,               /**< The requested exchange cannot run. */
    MENU_SWAP_RESULT_NORMAL = 1,               /**< The exchange uses the ordinary completion path. */
    MENU_SWAP_RESULT_DESTINATION_OCCUPIED = 2, /**< The general exchange starts with an occupied destination. */
    MENU_SWAP_RESULT_DESTINATION_EMPTY = 3,    /**< The general exchange places an item in an empty destination. */
    MENU_SWAP_RESULT_GIFT_BOX = 4,             /**< The destination handles gift-box insertion. */
    MENU_SWAP_RESULT_STACK = 5,                /**< Matching stackable items handle the exchange. */
    MENU_SWAP_RESULT_AQUARIUM = 7,             /**< The aquarium handles the source fish. */
};

/**
 *
 * Exchanges menu items through gift-box, bait, stacking and aquarium handling.
 *
 * @mangled MenuDataSwap__FP13CGameDataUsedP13CGameDataUsedi
 * @address 0x23DD80
 * @size 0x38C
 */
static int MenuDataSwap(CGameDataUsed *destination, CGameDataUsed *source, int quantity) {
    /**
     *
     * Selects the general exchange result from the source slot's original item presence.
     *
     */
    static s8 ret_tbl1[2] = {MENU_SWAP_RESULT_NORMAL, MENU_SWAP_RESULT_DESTINATION_EMPTY};

    int          dst_type;
    int          dst_no;
    CDataCommon *src_common;
    int          src_used;
    int          src_type;
    CDataCommon *dst_common;
    int          src_no;
    int          result;
    int          dst_used;

    if (destination == NULL || source == NULL) {
        return MENU_SWAP_RESULT_FAILED;
    }

    result = MENU_SWAP_RESULT_NORMAL;
    dst_no = destination->item_no;
    src_no = source->item_no;
    dst_type = GetItemDataType(dst_no);
    src_type = GetItemDataType(src_no);
    dst_used = destination->used_type;
    src_used = source->used_type;
    dst_common = GetCommonItemData(dst_no);
    src_common = GetCommonItemData(src_no);

    if (dst_used == USED_ITEM_TYPE_GIFT_BOX && destination->GetGiftBoxItemNum() < 3 && src_common != NULL && (src_common->attribute & ITEM_ATTRIBUTE_TRUSH) && ((src_used == USED_ITEM_TYPE_ITEM && src_type != ITEM_DATA_AQUARIUM && src_type != ITEM_DATA_FISH && src_type != ITEM_DATA_UNK_15 && src_type != ITEM_DATA_DUNGEON_KEY && src_type != ITEM_DATA_UNK_1B) || (src_used == USED_ITEM_TYPE_ATTACH && src_type != ITEM_DATA_UNK_11 && src_type != ITEM_DATA_UNK_22))) {
        if (destination->SetGiftBoxItem(src_no, -1) >= 0) {
            source->DeleteNum(1);
        }

        result = MENU_SWAP_RESULT_GIFT_BOX;
    } else if (dst_type == ITEM_DATA_AQUARIUM && src_used == USED_ITEM_TYPE_FISH) {
        MenuUserDataManPtr->FishInAquarium(source, 0);
        result = MENU_SWAP_RESULT_AQUARIUM;
    } else if (destination == MenuUserDataManPtr->GetActiveEsa()) {
        result = MENU_SWAP_RESULT_NORMAL;

        if (destination->GetNum() <= 0) {
            destination->CopyDataItem(src_no);
            source->DeleteNum(1);
        } else if (source->CopyDataItem(destination) == 0) {
            result = MENU_SWAP_RESULT_FAILED;
        }
    } else if (destination->CheckTypeEnableStack() && destination->GetNum() > 1 && src_used == USED_ITEM_TYPE_NONE) {
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

        result = MENU_SWAP_RESULT_STACK;
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

        result = ret_tbl1[had_src];
        s8 results[2] = {MENU_SWAP_RESULT_FAILED, MENU_SWAP_RESULT_DESTINATION_OCCUPIED};
        results[0] = result;
        result = results[had_dst];
    }

    CheckEnableHaveItemNum();
    return result;
}

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
    frame_parity = 0;
    have_item.Init();
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
    cursor_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("cursor0");

    if (cursor_form != NULL) {
        have_icon = cursor_form->GetPartInfo("item0");
        have_shadow = cursor_form->GetPartInfo("item0sdw");
        have_num = cursor_form->GetPartInfo("item0num");
        have_num->etc_info[2] = 1;
    }

    waku_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("cur_waku0");
    how_much_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("howmachbrd");
}

int CMenuKeyFunc::GetActiveCharaNo() {
    return MenuArg.active_chara_no;
}

int CMenuKeyFunc::MenuPosStep(int *pos, int *offset) {
    int waku_pos[2];

    if (waku_form != NULL) {
        waku_form->SetNextMovePos(pos, 2);
        waku_form->GetNextMovePos(waku_pos);
    }

    int next[2] = {waku_pos[0], waku_pos[1]};
    int put[2];

    if (offset != NULL) {
        next[0] += offset[0];
        next[1] += offset[1];
    }

    cursor_form->SetNextMovePos(next, 2);
    int end = cursor_form->CheckMoveEnd(next[0], next[1]);
    cursor_form->GetPutPosXY("cursor0", put[0], put[1]);
    CMenuPosDataForm *form = how_much_form;

    if (form != NULL) {
        int x = put[0] + 10;
        int y = put[1] + 40;
        form->x = x;
        form->y = y;
    }

    if (have_item.item_no > 0) {
        SetHaveItemInfo(1, 0);
    }

    how_much_form->SetPartRGBA("up", 0x60, 0x60, 0x60, 0x80);
    how_much_form->SetPartRGBA("down", 0x60, 0x60, 0x60, 0x80);

    if (0 < up_arrow_cnt) {
        how_much_form->SetPartRGBA("up", 0x80, 0x80, 0x80, 0x80);
        up_arrow_cnt--;
    }

    if (0 < down_arrow_cnt) {
        how_much_form->SetPartRGBA("down", 0x80, 0x80, 0x80, 0x80);
        down_arrow_cnt--;
    }

    return end;
}

void CMenuKeyFunc::MenuSetPos(int x, int y) {
    CMenuPosDataForm *form = cursor_form;
    float             fx = (float) x;
    float             fy = (float) y;
    form->x = fx;
    form->y = fy;
    form = waku_form;
    form->x = fx;
    form->y = fy;
}

void CMenuKeyFunc::MenuPosStop() {
    cursor_form->step_stop = 1;
    waku_form->step_stop = 1;
}

void CMenuKeyFunc::MenuPosPlay() {
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
    cursor_form->GetPutPosXY("item0", pos[0], pos[1]);
}

void CMenuKeyFunc::SetWakuType(int type) {
    char                name[0x20];
    int                 i;
    MENUFORMPARTS_TYPE *part;

    waku_type = type;

    if (waku_form != NULL) {
        i = 0;

        do {
            sprintf(name, "waku%d", i);
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
    char                name[0x20];
    MENUFORMPARTS_TYPE *info;

    sprintf(name, "waku%d", part);
    info = waku_form->GetPartInfo(name);

    if (info != NULL) {
        info->w = (float) width;
        info->h = (float) height;
    }
}

void CMenuKeyFunc::SetVibeCnt(int count, int rate) {
    MENUFORMPARTS_TYPE *part = cursor_form->GetPartInfo("cursor0");
    part->vibe_cnt[0] = count;
    part->vibe_cnt[1] = rate;
}

void CMenuKeyFunc::SetVibeR(int strength, int speed) {
    /**
     *
     * Held-item cursor, count, icon and shadow parts.
     *
     */
    static char *n[4] = {"cursor0", "item0num", "item0", "item0sdw"};

    int                 i;
    MENUFORMPARTS_TYPE *part;

    if (cursor_form != NULL) {
        i = 0;

        do {
            part = cursor_form->GetPartInfo(n[i]);

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
    cursor_form->GetPutPosXY("cursor0", pos[0], pos[1]);
}

void CMenuKeyFunc::CursorFadeIn(float speed, int steps) {
    if (cursor_form != NULL) {
        cursor_form->FormFadeIn((int) speed, steps);
    }

    if (waku_form != NULL) {
        waku_form->FormFadeIn((int) speed, steps);
    }
}

void CMenuKeyFunc::CursorFadeOut(float speed, int steps) {
    if (cursor_form != NULL) {
        cursor_form->FormFadeOut((int) speed, steps);
    }

    if (waku_form != NULL) {
        waku_form->FormFadeOut((int) speed, steps);
    }
}

int CMenuKeyFunc::EnableSwapNowPos(MENU_SWAPITEM_INFO *swap) {
    int          result = 0;
    s32          used_type;
    CHARA_DATA  *chara = NULL;
    u32          held_no = have_item.item_no;
    ROBO_DATA   *robo = NULL;
    CDataCommon *common;
    int          held_used = have_item.used_type;
    common = GameItemDataManage.GetCommonData(held_no);
    int data_type = GetItemDataType(held_no);

    switch (swap->chara) {
        case 0:
        case 1:
            chara = MenuUserParam.chara[swap->chara];
            break;
        case 2:
            robo = MenuUserParam.robo;
            break;
    }

    switch (swap->type) {
        int num;
        case MENU_SWAP_TYPE_ACTIVE_ITEM: {
            if (common != NULL && common->active_set == 0) {
                result = 1;
                break;
            }

            if (chara == NULL || swap->no < 0 || swap->no > 3) {
                result = 9;
                break;
            }

            CGameDataUsed *active = &chara->active_item[swap->no];

            if (active == NULL) {
                result = 9;
                break;
            }

            if (CheckItemEquip(swap->chara, held_no) == 0) {
                result = 9;
                break;
            }

            int num = active->GetNum();

            if (common == NULL) {
                if (num > 1) {
                    result = 4;
                }
            } else if (held_no != active->item_no) {
                if (held_used == 1 && active->used_type == USED_ITEM_TYPE_GIFT_BOX) {
                    result = 0;
                } else {
                    result = 0;
                }
            }

            break;
        }
        case MENU_SWAP_TYPE_EQUIP:
            if (held_used != 0) {
                if (held_used == 2 || (u32) (held_used - 5) <= 2 || held_used == 4) {
                    result = 1;
                    break;
                }
            }

            if (chara == NULL) {
                result = 9;
                break;
            }

            if (chara->status_attr & CHARA_STATUS_UNK_4) {
                result = 8;
                break;
            }

            if (chara->status_attr & CHARA_STATUS_UNK_8) {
                result = 8;
                break;
            }

            if (chara->status_attr & CHARA_STATUS_UNK_20) {
                result = 8;
                break;
            }

            switch (held_used) {
                case 0:
                    result = 9;
                    break;
                default:
                    if (data_type == SearchEquipType(swap->chara, swap->no)) {
                        result = 0;

                        if (have_item.IsFishingRod()) {
                            if (CheckFishCondition()) {
                            } else {
                                result = 9;
                            }
                        }
                    } else if (MenuItemUse.CheckItemUseEnable(&have_item, 1, &chara->equip[swap->no])) {
                        result = 5;
                    } else {
                        result = 1;
                    }

                    break;
            }

            break;
        case MENU_SWAP_TYPE_ROBO_PART:
            if (held_used != 0 && held_used != 5) {
                result = 1;

                if (held_used != 1) {
                    result = 1;
                    break;
                }
            }

            if (robo == NULL) {
                result = 9;
                break;
            }

            switch (held_used) {
                case 0:
                    result = 9;
                    break;
                case 1:
                    if (MenuItemUse.CheckItemUseEnable(&have_item, 1, &robo->parts[swap->no])) {
                        result = 5;
                    } else {
                        result = 1;
                    }

                    break;
                default:
                    if (data_type == SearchEquipType(2, swap->no)) {
                        result = 0;

                        if (!IsEnableChangeRoboParts(&have_item)) {
                            result = 3;
                        }
                    } else {
                        result = 3;
                    }

                    break;
            }

            break;
        case MENU_SWAP_TYPE_ITEM_BOARD:
        case MENU_SWAP_TYPE_UNK_4:
        case MENU_SWAP_TYPE_UNK_9: {
            CGameDataUsed *used = &MenuUserParam.used_data[swap->no];

            if (used == NULL) {
                result = 9;
                break;
            }

            result = 0;
            used_type = used->used_type;

            if (MenuItemUse.CheckItemUseEnable(&have_item, 1, used)) {
                result = 5;
            } else {
                if (used_type == USED_ITEM_TYPE_GIFT_BOX) {
                    if (held_used == 1) {
                        result = 0;
                    }
                } else if (used->CheckTypeEnableStack()) {
                    num = used->GetNum();

                    if (held_used == 0) {
                        if (num > 1) {
                            result = 4;
                        }
                    } else if (have_item.CheckTypeEnableStack()) {
                        result = 0;
                    } else if (held_no != used->item_no) {
                        result = 0;
                    } else {
                        result = 0;
                    }
                }
            }

            break;
        }
        case MENU_SWAP_TYPE_ACTIVE_ESA: {
            CGameDataUsed *esa = GetUserDataMan()->GetActiveEsa();

            if (esa == NULL) {
                result = 9;
                break;
            }

            if (common == NULL) {
                result = 0;
                break;
            }

            if (common->type == 0x20 || (common->attribute & 4)) {
                result = 0;

                if (have_item.GetNum() > 1 && 0 < esa->GetNum() && have_item.item_no != esa->item_no) {
                    result = 9;
                }

                int rod_no = GetUserDataMan()->GetFishingRodNo();

                if (rod_no == (int) ITEM_ID_LURE_ROD && (common->attribute & 4)) {
                    result = 9;
                }

                if (rod_no == (int) ITEM_ID_FISHING_ROD && common->type == 0x20) {
                    result = 9;
                }
            } else {
                result = 9;
            }

            break;
        }
    }

    return result;
}

int CMenuKeyFunc::GetItemAll(CGameDataUsed *item, MENU_SWAPITEM_INFO *info) {
    int slot;

    if (item == NULL || info == NULL) {
        return 0;
    }

    slot = MenuSwapItem(item, info, item->GetNum(), 1);
    MenuSePlay(menu_item_swap_sndtbl[slot]);
    return 1;
}

/**
 *
 * Fills an item's available command messages in an ask-mode parameter record.
 *
 */
int GetItemCommandMsg(CGameDataUsed *item, MENU_ASKMODE_PARA *param, int slot, int arg) {
    return GetItemCommandMsg(item, param->cmd_msg, param->cmd_color, param->cmd_shade, param->cmd_mark, slot, arg);
}

/**
 *
 * Builds the commands, colors, values, and markers available for an item.
 *
 */
int GetItemCommandMsg(CGameDataUsed *item, int *cmds, u32 *colors, short *values, short *marks, int type,
                      int arg) {
    /**
     *
     * Paired item-use command offsets for each target character.
     *
     */
    static s8 human_tbl[5][2] = {
        {15, 16},
        {16, 15},
        {17, -1},
        {16, 15},
        {-1, -1}
    };

    int item_no = item->item_no;
    int num = GetMenuCommandMsg(item_no, cmds);
    MenuUserDataManPtr->GetNowPartyMember();
    CDataCommon *common = GetCommonItemData(item_no);
    int          human = 1;

    if (item_no == 0x184 || item_no == 0x185) {
        human = 0;
    }

    int robo_parts = 0;

    if (0 < GetUserItemHaveNum(0x180) && (item->used_type == USED_ITEM_TYPE_ROBO_PART || item->used_type == USED_ITEM_TYPE_WEAPON)) {
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
                    cmds[i] = human_tbl[arg][0] + 5000;
                    i++;
                    cmds[i] = human_tbl[arg][1] + 5000;
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
                    cmds[i] = human_tbl[arg][0] + 5000;
                    i++;
                    cmds[i] = human_tbl[arg][1] + 5000;
                }

                if (item->item_type == ITEM_DATA_ROBO_ENERGY_PACK && cmds[i] == 0x139E) {
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

            if (MenuUserDataManPtr->GetFishingRodNo() == (int) ITEM_ID_LURE_ROD) {
                cmds[0] = 0x13A4;
            }

            cmds[1] = 0x1389;
            num = 2;
            cmds[2] = -1;
            break;
    }

    DNG_BATTLE_AREA *battle_area = &GetMainScene()->battle_area;
    int              bit_ctrl = GetSaveData()->GetBitCtrl();

    if (esa_cmd) {
        CGameDataUsed *rod_esa = MenuUserDataManPtr->GetActiveEsa(item->item_no);

        if (item->IsFishingRod() && rod_esa != NULL && rod_esa->item_no > 0) {
            if (item->item_no == (int) ITEM_ID_FISHING_ROD) {
                cmds[num] = 0x13A3;
                num++;
                cmds[num] = -1;
            }

            if (item->item_no == (int) ITEM_ID_LURE_ROD) {
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
    int            esa_no = 0;

    if (MenuUserDataManPtr->SearchEquip(0, (int) ITEM_ID_FISHING_ROD)) {
        int bait = 0;

        if (common->attribute & 4) {
            bait = 1;
        }

        esa_no = esa->item_no;

        if (esa != item && MenuCommonInfo->now_mode == (int) MENU_MODE_ITEM && bait == 1 && type != 0) {
            for (int k = num - 1; k >= 0; k--) {
                cmds[k + 1] = cmds[k];
            }

            cmds[0] = 0x13A0;
            num++;
        }
    }

    if (common->type == 0x20 && !MenuUserDataManPtr->SearchEquip(0, (int) ITEM_ID_LURE_ROD)) {
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

    if (0 <= MenuUserDataManPtr->aquarium.SearchAqua1NotUsed(AQUARIUM_TANK_FIRST)) {
        aquarium_space = 1;
    }

    int item_166 = 0;

    if (MenuUserDataManPtr->SearchItemOnItemBrd(0x166, 0)) {
        item_166 = 1;
    }

    int finny_frenzy_unlocked = 0;

    if (CheckBitFlagMenu(SAVE_FLAG_FINNY_FRENZY_UNLOCKED)) {
        finny_frenzy_unlocked = 1;
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

    if (battle_area->floor_status & DNG_FLOOR_DISABLE_ITEMS) {
        floor_flag = 1;
    }

    int trush_ng = 0;
    int spectol_ng = 0;

    if (item_no == 9 && CheckBitFlagMenu(0x138) == 1 && CheckBitFlagMenu(SAVE_FLAG_SPHEDA_UNLOCKED) == 0) {
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
            if (common->active_set == 0 || arg == 2 || arg == 3 || CMenuItemInfoPt->view_mode == MENU_ITEM_VIEW_WEAPON) {
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
                int            gift_no = item->GetGiftBoxItemNo(k);
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

        if (cmds[i] == 0x138B && item->item_type == ITEM_DATA_ROBO_CORE && !robo_member) {
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
            if (GetMenuLoopType() == (int) MENU_LOOP_TOWN) {
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
            if (GetMenuLoopType() == (int) MENU_LOOP_TOWN) {
                colors[i] = 0x80202020;
            } else {
                DNG_BATTLE_AREA *battle = menu_GetBattleAreaScene();

                if (battle != NULL && !(battle->floor_status & DNG_FLOOR_DISABLE_MAX) && !(battle->floor_status & DNG_FLOOR_DISABLE_MONICA) &&
                    !(battle->floor_status & DNG_FLOOR_DISABLE_ITEMS)) {
                    colors[i] = 0x80202020;
                }
            }
        }

        if (cmds[i] == 0x13B5 && !finny_frenzy_unlocked) {
            local_sort1(i, &num, cmds);
            continue;
        }

        i++;
    }

    return num;
}

void CMenuKeyFunc::SelDataInit() {
    select_key = 0;
    push_button = 0;
    save_cursor = cursor;
    save_top_line = top_line;
    key_input = 0;
}

int CMenuKeyFunc::CheckSelectKey() {
    if (GamePad__2.Down(PAD_UP) != 0) {
        select_key |= MENU_SELECT_KEY_UP;
    } else if (GamePad__2.Down(PAD_DOWN) != 0) {
        select_key |= MENU_SELECT_KEY_DOWN;
    }

    if (GamePad__2.Down(PAD_LEFT) != 0) {
        select_key |= MENU_SELECT_KEY_LEFT;
    } else if (GamePad__2.Down(PAD_RIGHT) != 0) {
        select_key |= MENU_SELECT_KEY_RIGHT;
    }

    if (key_enable == 0) {
        select_key = 0;
    }

    return select_key;
}

int CMenuKeyFunc::CheckLRKey() {
    if (GamePad__2.Down(PAD_L1) != 0) {
        select_key = MENU_SELECT_KEY_L1;
    } else if (GamePad__2.Down(PAD_R1) != 0) {
        select_key = MENU_SELECT_KEY_R1;
    } else if (GamePad__2.Down(PAD_L2) != 0) {
        select_key = MENU_SELECT_KEY_L2;
    } else if (GamePad__2.Down(PAD_R2) != 0) {
        select_key = MENU_SELECT_KEY_R2;
    }

    if (key_enable == 0) {
        select_key = 0;
    }

    return select_key;
}

int MenuCheckPushButton() {
    /**
     *
     * Confirm and cancel actions for each language button layout.
     *
     */
    static int padtbl[2][2] = {
        {MENU_PUSH_BUTTON_DECIDE, MENU_PUSH_BUTTON_CANCEL},
        {MENU_PUSH_BUTTON_CANCEL, MENU_PUSH_BUTTON_DECIDE}
    };

    int  pushed;
    int *table;

    pushed = 0;
    table = padtbl[0];

    if (LanguageCode > 0) {
        table = padtbl[1];
    }

    if (GamePad__2.Down(PAD_CIRCLE) != 0) {
        pushed = table[0];
    } else if (GamePad__2.Down(PAD_CROSS) != 0) {
        pushed = table[1];
    } else if (GamePad__2.Down(PAD_TRIANGLE) != 0) {
        pushed = MENU_PUSH_BUTTON_TRIANGLE;
    } else if (GamePad__2.Down(PAD_SQUARE) != 0) {
        pushed = MENU_PUSH_BUTTON_SQUARE;
    } else if (GamePad__2.Down(PAD_SELECT) != 0) {
        pushed = MENU_PUSH_BUTTON_SELECT;
    } else if (GamePad__2.Down(PAD_START) != 0) {
        pushed = MENU_PUSH_BUTTON_START;
    } else if (GamePad__2.Down(PAD_L3) != 0) {
        pushed = MENU_PUSH_BUTTON_L3;
    } else if (GamePad__2.Down(PAD_R3) != 0) {
        pushed = MENU_PUSH_BUTTON_R3;
    }

    return pushed;
}

int ConvertCheckPushButton(int buttons) {
    if (LanguageCode != 0 && LanguageCode > 0 && (buttons & MENU_PUSH_BUTTON_TRIANGLE)) {
        buttons &= ~MENU_PUSH_BUTTON_TRIANGLE;
        buttons |= MENU_PUSH_BUTTON_CANCEL;
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

u8 CMenuKeyFunc::CheckKeyInput() {
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

    if (GamePad__2.On2(PAD_UP) != 0) {
        held |= 1;
    }

    if (GamePad__2.On2(PAD_DOWN) != 0) {
        held |= 2;
    }

    if (GamePad__2.On2(PAD_LEFT) != 0) {
        held |= 4;
    }

    if (GamePad__2.On2(PAD_RIGHT) != 0) {
        held |= 8;
    }

    if (GamePad__2.On2(PAD_L1) != 0) {
        held |= 0x10;
    } else if (GamePad__2.On2(PAD_R1) != 0) {
        held |= 0x20;
    } else if (GamePad__2.On2(PAD_L2) != 0) {
        held |= 0x40;
    } else if (GamePad__2.On2(PAD_R2) != 0) {
        held |= 0x80;
    }

    if (GamePad__2.Down2(PAD_CIRCLE) != 0) {
        pressed = 1;
    } else if (GamePad__2.Down2(PAD_CROSS) != 0) {
        pressed = 2;
    } else if (GamePad__2.Down2(PAD_TRIANGLE) != 0) {
        pressed = 4;
    } else if (GamePad__2.Down2(PAD_SQUARE) != 0) {
        pressed = 8;
    } else if (GamePad__2.Down2(PAD_SELECT) != 0) {
        pressed = 0x20;
    } else if (GamePad__2.Down2(PAD_START) != 0) {
        pressed = 0x10;
    }

    return 1;
}

static int MenuDataSwap(CGameDataUsed *destination, CGameDataUsed *source, int quantity);

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
    short          owner = info->chara;

    if (0 <= owner) {
        CHARA_DATA *chara = MenuUserParam.chara[owner];
        ROBO_DATA  *robo = MenuUserParam.robo;
        short       kind = info->type;

        if (kind == MENU_SWAP_TYPE_ACTIVE_ITEM) {
            item = &chara->active_item[info->no];
        }

        if (kind == MENU_SWAP_TYPE_EQUIP) {
            item = &chara->equip[info->no];
        }

        if (kind == MENU_SWAP_TYPE_ROBO_PART) {
            item = &robo->parts[info->no];
        }

        if (kind == MENU_SWAP_TYPE_ACTIVE_ESA) {
            return MenuUserDataManPtr->GetActiveEsa();
        }

        return item;
    }

    return &MenuUserParam.used_data[info->no];
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

    if (have_item.item_no <= 0 || have_item.used_type == USED_ITEM_TYPE_NONE) {
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
    have_item.Init();
    have_swap.Set(-1, 0, -1, 0);
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
        if (have_shadow->etc_info[1] == (int) ITEM_ID_SPECTOL) {
            have_icon->etc_info[2] = have_item.GetSpectolNo();
            Func_MenuItemIconSetEffectOne(have_icon);
        } else if (have_shadow->etc_info[1] == 0x1AA) {
            have_icon->etc_info[2] = have_item.data.item.num;
        }
    }

    have_icon->item_flag = 0;

    if (CheckBuildUp(&have_item, NULL, NULL, NULL)) {
        have_icon->item_flag |= (int) MENU_ITEM_ICON_BUILD_UP;
    }

    have_num->etc_info[2] = 1;

    if (have_item.CheckTypeEnableStack()) {
        have_num->etc_info[1] = have_item.GetNum();
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
    int                result;
    int               *cursor = &this->cursor;
    MENU_INPUTKEY_ARG *limit = key_arg;
    int                i;

    result = -1;
    i = 0;

    while (i < 4 && result < 0) {
        if ((keys & MenuCheckKey[i]) &&
            MenuKeySelectCheck(limit->step[i], cursor, cursor + 1, limit->min, limit->max,
                               limit->disp_lines, limit->limit[i]) == (int) MENU_CURSOR_EXIT) {
            result = limit->exit_no[i];
        }

        i += 1;
    }

    return result;
}

int CMenuKeyFunc::menu_inputkey_limmit_check_glid(int select_key) {
    int                x;
    int                y;
    int                columns;
    int                rows;
    int                disp_columns;
    int                disp_lines;
    int                result;
    int               *pos = &cursor;
    MENU_INPUTKEY_ARG *arg = key_arg;
    int                i;
    int               *axis_pos;
    int               *top_line;
    int               *axis_disp;
    int               *axis_max;
    int                ret;

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

            if (ret == (int) MENU_CURSOR_EXIT) {
                result = arg->exit_no[i];
                break;
            }
        }
    }

    return result;
}

int CMenuKeyFunc::CheckMoveSelect(int arg) {
    int result = -1;

    if (key_enable != 0) {
        switch (key_arg->type) {
            case MENU_INPUTKEY_TYPE_LINE:
                result = menu_inputkey_limmit_check_line(arg);
                break;
            case MENU_INPUTKEY_TYPE_GLID:
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
    bgm_target = (short) value;

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

void CheckEnableHaveItemNum() {
    CGameData        *item_data = &GameItemDataManage;
    int               i;
    CUserDataManager *user_data = GetUserDataMan();
    int               have_num[512];
    int               j, k, gift_no;
    s16               full[512];

    memset(have_num, 0, sizeof(have_num));
    memset(full, 0, sizeof(full));
    CGameDataUsed *used = user_data->GetUsedDataPtr(0);
    int            bag_max = GetNowBagMax(1);

    for (i = 0; i < bag_max; i++, used++) {
        int item_no = used->item_no;

        if (item_no > 0) {
            have_num[item_no] += used->GetNum();

            if (0 < used->GetGiftBoxItemNum()) {
                for (j = 0; j < 3; j++) {
                    gift_no = used->GetGiftBoxItemNo(j);

                    if (gift_no > 0) {
                        have_num[gift_no]++;
                    }
                }
            }
        }
    }

    CHARA_DATA *chara = user_data->GetCharaDataPtr(USER_CHARA_MAX);

    for (i = 0; i < 2; i++) {
        chara = &chara[i];

        for (k = 0; k < 3; k++) {
            CGameDataUsed *active = &chara->active_item[k];
            int            item_no = active->item_no;

            if (item_no > 0) {
                have_num[item_no] += active->GetNum();

                if (0 < active->GetGiftBoxItemNum()) {
                    for (int gift_slot = 0; gift_slot < 3; gift_slot++) {
                        gift_no = active->GetGiftBoxItemNo(gift_slot);

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

        if (common != NULL && common->max_num <= have_num[i]) {
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

    chara = user_data->GetCharaDataPtr(USER_CHARA_MAX);

    for (
        i = 0;
        i < 2; i++, chara++) {
        for (j = 0; j < 3; j++) {
            menu_chara_activeItem_limmit_check[i * 3 + j] = 0;

            if (chara->active_item[j].item_no > 0 && full[chara->active_item[j].item_no] != 0) {
                menu_chara_activeItem_limmit_check[i * 3 + j] = 1;
            }
        }
    }
}

/**
 *
 * Positions the equipment preview camera around a character or its selected part.
 *
 */
void MenuEquipCameraSetEnv(CActionChara *chara, mgCCamera *camera, int type, int index) {
    mgCFrame *frame;
    char     *focus_name;
    bool      is_special;

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

    if (*(signed char *) focus_name != 0) {
        frame = chara->SearchObject(focus_name);
    }

    if (frame == NULL) {
        MenuCamInit(5.0f);
        return;
    }

    float position[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float offset[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    char  name[0x20];
    float table[4];
    frame->GetWorldPosition(position, offset);
    sprintf(name, "test%d%d", type, index);
    MenuPosData->GetEtcTbl2Value(name, table, 3);
    sceVu0AddVector(position, position, table);
    *(u_long128 *) MenuDrawEnv->ref = *(u_long128 *) position;
    sprintf(name, "ttest%d%d", type, index);
    MenuPosData->GetEtcTbl2Value(name, table, 3);
    sceVu0AddVector(position, position, table);
    *(u_long128 *) MenuDrawEnv->pos = *(u_long128 *) position;
    MenuDrawEnv->speed = 7.0f;
}

/**
 *
 * Updates the weapon status forms for the selected inventory item.
 *
 */
void MenuPosFormValueSetWeapon(CGameDataUsed *item) {
    if (item != NULL && item->item_no > 0) {
        s16 type = item->used_type;

        if (type != USED_ITEM_TYPE_ITEM && type != USED_ITEM_TYPE_COSTUME && type != USED_ITEM_TYPE_GIFT_BOX &&
            type != USED_ITEM_TYPE_ATTACH) {
            CMenuPosDataForm *form;
            int               fusion_point = 0;
            form = CMenuItemInfoPt->view_form[2];
            float rates[2] = {0.0f, 0.0f};
            s16   values[12] = {0};
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
                max = robo_part->whp.max;
                now = robo_part->whp.now;
                rates[0] = robo_part->whp.GetRate();
            }

            item->GetStatusParam(values, MenuMainScene->time);
            MENUFORMPARTS_TYPE *part = form->GetPartInfo("hp_bar");

            if (part != NULL) {
                part->w = (int) (94.0f * rates[0]);
                part->draw_flag = 1;
            }

            form->SetNumber("hp0", GetDispVolumeForFloat(now));
            form->SetNumber("hp1", (int) max);
            form->SetPartDrawFlag("hpbgfil", true);
            form->SetPartDrawFlag("hpbar", true);
            form->SetPartDrawFlag("hp0", true);
            form->SetPartDrawFlag("hp1", true);
            form->SetPartDrawFlag("slu", true);
            part = form->GetPartInfo("abs_bar");

            if (part != NULL) {
                part->w = (int) (94.0f * rates[1]);
            }

            form->SetNumber(WepStatusInfoStatusVolStrTable[0], values[0]);
            form->SetNumber(WepStatusInfoStatusVolStrTable[1], values[1]);

            for (int i = 0; i < 8; i++) {
                form->SetNumber(WepStatusInfoStatusVolStrTable[i + 2], values[i + 2]);
            }

            form->SetNumber("funum", fusion_point);
        }
    }
}

/**
 *
 * Updates an attachment or weapon form with current and changed status values.
 *
 */
void MenuFormUpdataAttachInfo(CMenuPosDataForm *form, CGameDataUsed *item, int item_no, int reset, s16 *before) {
    s16 param[10];
    int raised[10];
    int i;

    if (form == NULL || item == NULL) {
        return;
    }

    s16 type = item->used_type;

    if (type == USED_ITEM_TYPE_ATTACH || type == USED_ITEM_TYPE_WEAPON) {
        form->SetAction("\x92\x86\x82\xD6");

        /**
         *
         * Pulse counter of the attachment information display.
         *
         */
        static s8 count_time = 0;

        count_time++;

        if (count_time > 59) {
            count_time = 0;
        }

        if (reset) {
            count_time = 0;
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

                if (count_time >= 25) {
                    raised[i] = 0;
                }
            }
        }

        form->SetPartDrawFlag(WepStatusInfoStatusVolStrTable[0], true);
        form->SetPartDrawFlag("\x81\x48", false);

        if ((s8) item->data.attach.spectol_type == SPECTOL_TYPE_WEAPON) {
            form->SetPartDrawFlag("\x81\x48", true);
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

        MENUFORMPARTS_TYPE *part = form->GetPartInfo("item");

        if (part != NULL) {
            part->draw_flag = 1;
            part->etc_info[0] = 0;

            if (item_no == (int) ITEM_ID_SPECTOL) {
                part->draw_flag = 0;
            } else {
                part->etc_info[1] = item_no;
                part->etc_info[2] = 0;
            }
        }
    }
}

/**
 *
 * Updates the fishing rod status form for the selected item.
 *
 */
void MenuPosFormValueSetFishingRod(CGameDataUsed *item) {
    int               values[8];
    char              name[0x20];
    CMenuPosDataForm *form;
    int               i;
    WEAPON_USED      *rod;

    if (item != NULL && item->IsFishingRod() != 0) {
        rod = &item->data.weapon;
        i = 0;
        form = CMenuItemInfoPt->view_form[5];
        values[0] = item->data.weapon.attribute[0];
        values[1] = item->data.weapon.attribute[1];
        values[2] = item->data.weapon.attribute[2];
        values[3] = item->data.weapon.attribute[3];
        values[4] = item->data.weapon.attribute[4];

        do {
            sprintf(name, "fps%d", i);
            form->SetNumber(name, values[i]);
            i += 1;
        } while (i < 5);

        form->SetNumber("funum", rod->fusion_point);
    }
}

void CMenuItemInfo::Initialize() {
    int i;

    view_mode = MENU_ITEM_VIEW_MAX;
    active_chara_view_mode = MENU_ITEM_VIEW_MAX;
    sub_view = 0;
    view_chara = 0;
    load_item_no = 0;
    load_item_no = 2;
    mos_id = MenuUserDataManPtr->monster_id;
    view_weapon = NULL;
    unk_F8 = 0;
    SetEquipListNo(4);
    load_weapon_no = 0;
    repair_running = 0;
    effect_pos = 0;
    sub_menu = -1;
    next_sub_menu = -1;
    build_up_chara = NULL;
    build_loading = 0;
    reset_cursor_pos = 0;
    sound_load = 0;
    opened = 0;
    mode = 1;
    step = 0;
    item_consumed = 0;
    equipped_model_no = -1;
    chara_reload = 0;
    sound_loaded = 0;

    for (i = 0; i < 8; i++) {
        equip_flag[i] = 0;
        equip_list[i] = 0;
    }

    viewing_weapon = 0;
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

int CMenuItemInfo::CheckEquipListNo(int check) {
    int            chara = GetActiveCharaNo();
    int            changed = 0;
    CGameDataUsed *equip;
    int            i;

    if (chara < 2) {
        equip = MenuUserParam.chara[chara]->equip;

        if (check == 0) {
            for (i = 0; i < 2; equip++, i++) {
                if (equip_flag[i] || equip_list[i] != equip->item_no) {
                    changed = 1;
                    equip_flag[i] = 1;
                }
            }
        } else if (check == 1) {
            for (i = 0; i < 5; equip++, i++) {
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

        if (equip_flag[4] || Ident(MenuUserParam.chara[0]->equip[4].item_no) != equip_list[4]) {
            changed = 1;
            equip_flag[4] = 1;
        }

        if (equip_flag[5] || Ident(MenuUserParam.chara[0]->equip[2].item_no) != equip_list[5]) {
            changed = 1;
            equip_flag[5] = 1;
        }
    }

    return changed;
}

int CMenuItemInfo::CheckSoundLoad() {
    sound_loaded = 0;
    int chara_no = GetActiveCharaNo();

    if (GetMenuLoopType() == (int) MENU_LOOP_TOWN) {
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
    /**
     *
     * Ridepod equipment slots eligible for spectrum fusion.
     *
     */
    static s8 tbl[2] = {2, 0};

    int            cursor = MenuCommonInfo->cursor;
    CHARA_DATA    *chara = MenuUserParam.chara[sub_view];
    CGameDataUsed *item = NULL;

    if (key_arg_no == (int) ITEM_MENU_PANEL_BAG) {
        item = &MenuUserParam.used_data[cursor];

        if (menu_debug_flag != 0) {
            debug_item.Init();
            MenuUserDataManPtr->CopyGameData(&debug_item, debug_item_no);
            item = &debug_item;
        }
    } else if (key_arg_no == (int) ITEM_MENU_PANEL_ACTIVE_ITEMS) {
        item = &chara->active_item[cursor];
    } else if (key_arg_no == (int) ITEM_MENU_PANEL_EQUIPMENT) {
        item = &chara->equip[cursor];
    } else if (key_arg_no == (int) ITEM_MENU_PANEL_RIDEPOD_PARTS) {
        item = &MenuUserParam.robo->parts[tbl[cursor]];
    } else if (key_arg_no == (int) ITEM_MENU_PANEL_WEAPON) {
        item = view_weapon;
    } else if (key_arg_no == (int) ITEM_MENU_PANEL_FISHING_ROD) {
        item = view_weapon;
    } else if (key_arg_no == (int) ITEM_MENU_PANEL_FISHING_BAIT) {
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
    CGameDataUsed  previous_item;
    CGameDataUsed  carried_item;
    previous_item.CopyGameData(target);
    carried_item.CopyGameData(&MenuCommonInfo->have_item);
    CheckViewWeaponStatus(1);
    int result = MenuCommonInfo->ReturnItemMenu(1);

    if (0 < result) {
        target->CopyGameData(&previous_item);
        MenuCommonInfo->have_item.CopyGameData(&carried_item);
        int equipped = 0;

        if ((view_mode == MENU_ITEM_VIEW_MAX && swap.chara == 0) ||
            (view_mode == MENU_ITEM_VIEW_MONICA && swap.chara == 1) ||
            (view_mode == MENU_ITEM_VIEW_ROBO && load_item_no == swap.chara)) {
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

    if (GetItemDataType(MenuCommonInfo->have_item.item_no) == (int) ITEM_DATA_NONE) {
        if (ReturnActiveCharaViewMode(0) == 0) {
            result = 2;
        }

        MenuSePlay(5);
    } else {
        MENU_SWAPITEM_INFO *source = &MenuCommonInfo->have_swap;
        int                 needs_load = 0;
        int                 ridepod = 0;

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
        CGameDataUsed  previous_item;
        CGameDataUsed  carried_item;
        previous_item.CopyGameData(target);
        carried_item.CopyGameData(&MenuCommonInfo->have_item);
        CheckViewWeaponStatus(1);

        if (0 < MenuCommonInfo->ReturnItemMenu(1)) {
            CheckLoadItemNo();
            MenuCommonInfo->SetHaveItemInfo(0, 1);
            target->CopyGameData(&previous_item);
            MenuCommonInfo->have_item.CopyGameData(&carried_item);

            if (needs_load != 0) {
                MenuLoadInfo.load_all = 0;

                if (ridepod == 0) {
                    CheckLoadInfo(sub_view);
                    MenuLoadInfo.request_phase = ConvertCharaLoadDataPhase(sub_view, slot);
                    MenuLoadInfo.load_phase = MenuLoadInfo.request_phase;
                } else if (ridepod == 1) {
                    CheckLoadInfo(2);
                    MenuLoadInfo.request_phase = ConvertCharaLoadDataPhase(2, slot);
                }

                ModelReadStart(view_mode, 0, 1);
                MenuSePlay(8);
            } else {
                MenuSePlay(4);
            }

            int equipped = 0;

            if ((view_mode == MENU_ITEM_VIEW_MAX && swap.chara == 0) ||
                (view_mode == MENU_ITEM_VIEW_MONICA && swap.chara == 1) ||
                (view_mode == MENU_ITEM_VIEW_ROBO && load_item_no == swap.chara)) {
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

void CMenuItemInfo::SaveViewWeaponStatus() {
    int            mode_now;
    CGameDataUsed *cursor_item;

    view_weapon_flag = 0;
    mode_now = view_mode;

    if ((mode_now == MENU_ITEM_VIEW_WEAPON) || (mode_now == MENU_ITEM_VIEW_FISHING_ROD)) {
        cursor_item = SearchNowPosItemExist();

        if (cursor_item == view_weapon) {
            OldViewWep = cursor_item;
            NewViewWep = (&MenuCommonInfo->have_item);

            if (key_arg_no == (int) ITEM_MENU_PANEL_WEAPON) {
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

    if ((view_mode == MENU_ITEM_VIEW_MAX && active_character == 0) ||
        (view_mode == MENU_ITEM_VIEW_MONICA && active_character == 1) ||
        (view_mode != MENU_ITEM_VIEW_MAX && view_mode == active_chara_view_mode)) {
        return 0;
    }

    if (active_chara_view_mode == MENU_ITEM_VIEW_MAX || active_chara_view_mode == MENU_ITEM_VIEW_MONICA) {
        sub_view = active_character;
    }

    if (active_chara_view_mode == MENU_ITEM_VIEW_ROBO) {
        MenuActionChara[5]->Initialize(NULL);
    }

    MenuCommonInfo->cursor = 0;
    key_arg_no = menuitem_initmenumode[active_character];
    view_mode = active_chara_view_mode;
    MenuCommonInfo->key_arg = &item_menu_argtbl[key_arg_no];
    MenuLoadInfo.load_all = 1;
    MenuLoadInfo.load_phase = 0;
    MenuLoadInfo.request_phase = -1;
    CheckLoadInfo(active_character);
    MenuLoadInfo.update_scene = 1;
    MenuMemoryAdjust(&MenuItemMemory, &MenuCharaLoadStack, MenuActionCharaBuffer, active_character);
    ModelReadStart(view_mode, 1, 1);
    return 1;
}

void CMenuItemInfo::NextModeBuildUpInfo(CGameDataUsed *weapon) {
    char                *names[4];
    BUILDUP_WEAPON_INFO *info = &BuildUpWeaponInfo;
    info->weapon = weapon;
    info->build_up = CheckBuildUp(info->weapon, &info->select_num, info->weapon_no, info->enable);

    if (info->select_num <= 0) {
        MenuSePlay(5);
        return;
    }

    info->mode = 1;
    info->select_no = 0;
    char    *hatena = GetHatena();
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
    ask_para.ask_mode = 2;

    if (MenuCommonInfo->cursor_form != NULL) {
        MenuCommonInfo->cursor_form->draw_flag = 1;
    }

    MenuSePlay(1);
}

int CMenuItemInfo::EquipDirect(int chara, CGameDataUsed *item, int &slot) {
    int            who;
    int            robo_slot4;
    s16            item_no = item->item_no;
    int            status;
    int            robo_slot2;
    int            data_type = GetItemDataType(item_no);
    CGameDataUsed *target;
    int            chara_no = chara;

    if (item->IsFishingRod() && !CheckFishCondition()) {
        return 0;
    }

    who = IsItemtypeWhoisEquip(item_no, &slot);
    status = MenuUserDataManPtr->GetCharaStatusAttirbute(chara);

    if ((status & CHARA_STATUS_UNK_4) || (status & CHARA_STATUS_UNK_8) || (status & CHARA_STATUS_UNK_20)) {
        return 0;
    }

    robo_slot4 = 0;
    robo_slot2 = 0;

    if (view_mode == MENU_ITEM_VIEW_ROBO && data_type == 5) {
        robo_slot4 = 1;
    }

    if (view_mode == MENU_ITEM_VIEW_ROBO && data_type == 6) {
        robo_slot2 = 1;
    }

    if (view_mode == MENU_ITEM_VIEW_MAX && who != 0) {
        slot = -1;
    }

    if (view_mode == MENU_ITEM_VIEW_MONICA && who != 1) {
        slot = -1;
    }

    if (view_mode == MENU_ITEM_VIEW_ROBO) {
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
    swap.Set(MENU_SWAP_TYPE_EQUIP, slot, chara_no, 0);

    if (chara < 2) {
        target = &MenuUserParam.chara[chara_no]->equip[slot];
        swap.type = 1;

        if (robo_slot4 == 1) {
            target = &MenuUserParam.chara[0]->equip[4];
            slot = 1;
            swap.type = 2;
        }

        if (robo_slot2 == 1) {
            target = &MenuUserParam.chara[0]->equip[2];
            slot = 1;
            swap.type = 2;
        }
    } else if (chara == 2) {
        if (IsEnableChangeRoboParts(&MenuCommonInfo->have_item) == 1) {
            target = &MenuUserParam.robo->parts[slot];
            swap.type = 2;
        } else {
            return 0;
        }
    }

    return MenuCommonInfo->MenuSwapItem(target, &swap, 1, true) != 0;
}

void CMenuItemInfo::CheckLoadInfo(int chara) {
    if (CheckEquipListNo(1) && chara == GetActiveCharaNo()) {
        MenuLoadInfo.update_scene = 1;

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
        MenuLoadInfo.update_scene = 0;
    }
}

extern CGameDataUsed MenuMoveTempGameDataUsed;

int CMenuItemInfo::ItemCmdAfter(int cmd_ret, ITEMCMD_RET_PARA *ret) {
    /**
     *
     * Item-use status scripts for each character preview.
     *
     */
    static char *exename[4] = {NULL, "\x8E\xF4\x82\xA2", "\x92\xE2\x8E\x7E", "\x90\xCE\x89\xBB"};

    switch (step) {
        case 0: {
            if (ret->menu_cmd < -1) {
                break;
            }

            int mes_no = ask_para.mes_no;
            MenuSePlay(ret->cmd);
            mgCMemory *load_stack = &MenuCharaLoadStack;
            int        cursor = MenuCommonInfo->cursor;

            switch (ret->menu_cmd) {
                case 1:
                    SetPreCmdTrush(this, mes_no, ask_para.item, MenuMesForm[mes_no]);

                    if (MenuCommonInfo->cursor_form != NULL) {
                        MenuCommonInfo->cursor_form->draw_flag = 0;
                    }

                    break;
                case ITEM_MENU_COMMAND_EQUIP:
                    if (MenuItemCmdRet.result < 0) {
                        if (MenuItemCmdRet.item_no > 0) {
                            ExeScript(exename[MenuItemCmdRet.item_no]);
                            step = 1;
                        }

                        break;
                    }

                    if (view_mode == MENU_ITEM_VIEW_WEAPON || view_mode == MENU_ITEM_VIEW_FISHING_ROD) {
                        view_chara = view_weapon->item_no;

                        if (view_chara == (int) ITEM_ID_FISHING_ROD || view_chara == (int) ITEM_ID_LURE_ROD) {
                            view_mode = MENU_ITEM_VIEW_FISHING_ROD;
                        } else {
                            view_mode = MENU_ITEM_VIEW_WEAPON;
                        }

                        ModelReadStart(view_mode, 1, 1);
                    }

                    if ((view_mode == MENU_ITEM_VIEW_MAX && ret->chara == 0) || (view_mode == MENU_ITEM_VIEW_MONICA && ret->chara == 1)) {
                        CheckLoadInfo(ret->chara);
                        MenuLoadInfo.request_phase = ConvertCharaLoadDataPhase(sub_view, ret->result);
                        MenuLoadInfo.load_phase = MenuLoadInfo.request_phase;
                        MenuLoadInfo.load_all = 0;
                        ModelReadStart(view_mode, 1, 1);
                        GameDataSwap(ret->item2, ask_para.item, 0);
                        int movement[2][4] = {
                            {0, 0, 1, 0},
                            {1, 0, 0, 0}
                        };
                        movement[0][1] = ret->chara;
                        movement[0][3] = ret->result;
                        movement[1][3] = cursor;
                        CommonSetMoveItemClass(movement);
                        SetEquipListNo(GetActiveCharaNo());
                    }

                    if (view_mode == MENU_ITEM_VIEW_ROBO && ret->chara == 0 &&
                        (ask_para.item->item_type == 5 || ask_para.item->item_type == 6)) {
                        CheckLoadInfo(2);
                        MenuLoadInfo.request_phase = 2;
                        MenuLoadInfo.load_phase = 2;
                        MenuLoadInfo.load_all = 0;
                        ModelReadStart(view_mode, 1, 1);
                    }

                    break;
                case ITEM_MENU_COMMAND_EQUIP_RIDEPOD_PART:
                    if (ret->cmd == 5 || ret->cmd == 0x1C) {
                        if (MenuItemCommand_RoboPackBreakFlag == 1) {
                            ExeScript("\x83\x4C\x83\x83\x83\x70\x91\xAB\x82\xE8\x82\xC8\x82\xA2");
                            step = 1;
                        }

                        if (MenuItemCommand_RoboPackBreakFlag == 2) {
                            ExeScript("\x83\x70\x81\x5B\x83\x63\x89\xF3");
                            char *name[2] = {NULL};
                            name[0] = ask_para.item->GetName(1);
                            MenuDCMsg[7]->SetMsgItemNo(name, 20);
                            step = 1;
                        }

                        break;
                    }

                    if (view_mode == MENU_ITEM_VIEW_ROBO) {
                        CheckLoadInfo(2);
                        MenuLoadInfo.request_phase = ConvertCharaLoadDataPhase(2, ret->result);
                        MenuLoadInfo.load_phase = MenuLoadInfo.request_phase;
                        MenuLoadInfo.load_all = 0;
                        ModelReadStart(view_mode, 1, 1);
                        GameDataSwap(ret->item2, ask_para.item, 0);
                        int movement[2][4] = {
                            {0, 0, 1, 0},
                            {1, 0, 0, 0}
                        };
                        movement[0][1] = ret->chara;
                        movement[0][3] = ret->result;
                        movement[1][3] = cursor;
                        CommonSetMoveItemClass(movement);
                        SetEquipListNo(GetActiveCharaNo());
                    }

                    if (view_mode == MENU_ITEM_VIEW_WEAPON) {
                        view_chara = view_weapon->item_no;
                        view_mode = MENU_ITEM_VIEW_WEAPON;
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
                        view_mode = MENU_ITEM_VIEW_WEAPON;
                        key_arg_no = (int) ITEM_MENU_PANEL_WEAPON;
                        MenuCommonInfo->cursor = 0;

                        if (view_weapon->IsFishingRod()) {
                            view_mode = MENU_ITEM_VIEW_FISHING_ROD;
                            key_arg_no = (int) ITEM_MENU_PANEL_FISHING_ROD;
                        }
                    } else if ((data_type >= 16 && data_type <= 18) || data_type == 34) {
                        MenuFormUpdataAttachInfo(MenuSpectolSatusCheckForm, ask_para.item, ask_para.item->item_no, 1, NULL);
                        read = 0;
                        status_check_ready = 1;
                    } else if (view_mode == MENU_ITEM_VIEW_ROBO) {
                        read = 0;
                    } else {
                        MenuCommonInfo->cursor = 0;
                        view_mode = MENU_ITEM_VIEW_ROBO;
                        key_arg_no = 6;
                        MenuLoadInfo.request_phase = -1;
                        MenuLoadInfo.load_all = 0;
                        MenuLoadInfo.load_phase = 0;
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
                case ITEM_MENU_COMMAND_REPAIR:
                case ITEM_MENU_COMMAND_USE_ON_PRIMARY_WEAPON:
                case ITEM_MENU_COMMAND_USE_ON_SECONDARY_WEAPON:
                case 21:
                case 22:
                    if (MenuItemCmdRet.result == 1) {
                        CheckEnableHaveItemNum();
                        SetItemEffect();
                    }

                    break;
                case ITEM_MENU_COMMAND_SET_ACTIVE_ITEM:
                    if (0 <= ret->result && ((view_mode != MENU_ITEM_VIEW_MONSTER && view_mode != MENU_ITEM_VIEW_ROBO) || sub_view == 1)) {
                        int move_type = 1;

                        if (ret->item_no == 10) {
                            memcpy(&MenuMoveTempGameDataUsed, ask_para.item, sizeof(CGameDataUsed));
                            ask_para.item->DeleteNum(ret->num);
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
                        int movement[2][4] = {
                            {1, 0, 0, 0},
                            {0, 0, 0, 0}
                        };
                        movement[0][3] = ret->result;
                        movement[1][1] = sub_view;
                        movement[1][3] = cursor;
                        CommonSetMoveItemClass(movement);
                    }

                    break;
                case 6:
                    if (ret->result >= 0) {
                        int movement[2][4] = {
                            {1, 0, 0, 0},
                            {0, 0, 1, 0}
                        };
                        movement[0][3] = ret->result;
                        movement[1][1] = sub_view;
                        movement[1][3] = cursor;
                        CommonSetMoveItemClass(movement);
                    }

                    MenuItemCharaDataLoadEndCheckAfter(MenuCharaBuild2, sub_view);
                    break;
                case ITEM_MENU_COMMAND_SPECTRUMIZE:
                    if (ret->cmd == 1) {
                        SetPreCmdSpectolBreak(this, 4, MenuMesForm[4], ask_para.item, ret->item);
                        step = 10;
                        CDC2Mes      *mes = MenuDCMsg[4];
                        CGameDataUsed spectol;
                        ask_para.item->ToSpectolTrans(&spectol, SpectolBreakNum);

                        if (ask_para.item->used_type == USED_ITEM_TYPE_WEAPON) {
                            SpectolBreakSpPoint = ask_para.item->data.weapon.fusion_point;
                        } else {
                            SpectolBreakSpPoint = 1;
                        }

                        if (SpectolBreakNum_Limit > 1) {
                            MenuHowHaveMuchNum = SpectolBreakNum;
                            ExeScript("SPBREAK");
                            int volumes[4] = {0};
                            volumes[0] = MenuHowHaveMuchNum;
                            volumes[1] = SpectolBreakSpPoint * MenuHowHaveMuchNum;
                            mes->SetMsgVolumeNo(volumes, 2);
                        } else {
                            ExeScript("SPBREAKONE");
                            step = 0;
                        }

                        char *name = ask_para.item->GetName(1);

                        if (name != NULL) {
                            strcpy(mes->name[0], name);
                        }

                        mes->put_centering = 1;

                        if ((s8) spectol.data.attach.spectol_type == SPECTOL_TYPE_WEAPON_LOW) {
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
                case ITEM_MENU_COMMAND_GIFT_BOX_CONTENTS:
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
                        if (ret->menu_cmd == 29) {
                            next_sub_menu = 3;
                        }

                        if (ret->menu_cmd == 38) {
                            next_sub_menu = 4;
                        }

                        if (ret->menu_cmd == 47) {
                            next_sub_menu = 5;
                        }

                        FadeOutMenu(40, 0.0f);
                    }

                    break;
                case ITEM_MENU_COMMAND_VIEW_BUILD_UP:
                    view_weapon = ask_para.item;
                    view_chara = ask_para.item->item_no;
                    view_mode = MENU_ITEM_VIEW_WEAPON;
                    key_arg_no = (int) ITEM_MENU_PANEL_WEAPON;
                    MenuCommonInfo->key_arg = &item_menu_argtbl[key_arg_no];
                    ModelReadStart(view_mode, 1, 1);
                    CMenuItemInfoPt->NextModeBuildUpInfo(CMenuItemInfoPt->view_weapon);
                    break;
                case ITEM_MENU_COMMAND_USE_ON_MAX:
                case ITEM_MENU_COMMAND_USE_ON_MONICA:
                case ITEM_MENU_COMMAND_USE_ON_MONSTER:
                    if (MenuItemCmdRet.result == 1) {
                        SetItemEffect();
                        CheckEnableHaveItemNum();

                        if (MenuItemCmdRet.item_no == 0x184 || MenuItemCmdRet.item_no == 0x185) {
                            step = 2;
                            int msg = 0xB8;

                            if (MenuItemCmdRet.item_no == 0x185) {
                                msg = 0xB9;
                            }

                            ExeScript("\x96\x68\x8C\xE4\x82\x74\x82\x6F");
                            MenuDCMsg[7]->MakeMsg(msg);
                            mode = MENU_ASK_MODE_ITEM_COMMAND;
                        }
                    }

                    if (MenuItemCmdRet.result == 10) {
                        ExeScript("\x8A\x89\x82\xAB");
                        step = 1;
                    }

                    if (MenuItemCmdRet.result == 20) {
                        step = 2;
                        int msg_no[2] = {10, -1};

                        if (MenuItemCmdRet.item_no == 0x185) {
                            msg_no[0] = 11;
                        }

                        ExeScript("\x96\x68\x8C\xE4\x4E\x4F\x54\x55\x50");
                        MenuDCMsg[7]->SetMsgItemNo(msg_no, 1);
                        mode = MENU_ASK_MODE_ITEM_COMMAND;
                    }

                    break;
                case ITEM_MENU_COMMAND_RENAME:
                    if (ret->cmd == 1) {
                        Nameregi_Target.target = 0;
                        Nameregi_Target.item = ask_para.item;

                        if (ask_para.item->item_type == ITEM_DATA_ROBO_CORE) {
                            Nameregi_Target.target = 1;
                            Nameregi_Target.item = NULL;
                        }

                        next_sub_menu = 2;
                        FadeOutMenu(40, 0.0f);
                    }

                    break;
                case 24:
                case 25:
                    if (ret->cmd == 1 && view_mode == MENU_ITEM_VIEW_MAX && ret->item2 != NULL) {
                        int esa_no = ret->item2->item_no;
                        ret->item2->Init();
                        ask_para.item->CopyDataItem(esa_no);
                        int movement[2][4] = {
                            {5, 0, 0, 0},
                            {1, 0, 0, 0}
                        };
                        movement[1][3] = ret->result;
                        CommonSetMoveItemClass(movement);
                    }

                    break;
                case 27:
                case 28:
                case 32:
                case 33:
                    if (ret->cmd == 1 && view_mode == MENU_ITEM_VIEW_MAX && ret->no_equipped_rod == 0) {
                        GameDataSwap(ret->item2, GetUserDataMan()->GetActiveEsa(), 0);
                        int movement[2][4] = {
                            {1, 0, 0, 0},
                            {5, 0, 0, 0}
                        };
                        movement[0][3] = ret->result;
                        CommonSetMoveItemClass(movement);
                    }

                    break;
                case ITEM_MENU_COMMAND_VIEW_FISHING_ROD:
                    if (ret->cmd == 1) {
                        view_weapon = ask_para.item;
                        view_chara = ask_para.item->item_no;
                        viewing_weapon = 1;
                        SpectolInfoStay.CopyGameData(ask_para.item);
                        MenuCommonInfo->cursor = 0;
                        key_arg_no = (int) ITEM_MENU_PANEL_FISHING_ROD_STATS;
                        MenuCommonInfo->key_arg = &item_menu_argtbl[key_arg_no];
                        view_mode = MENU_ITEM_VIEW_FISHING_ROD;
                        ModelReadStart(view_mode, 1, 1);
                        ExeScript("FPMODEIN");
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
                        ExeScript("\x83\x52\x83\x41\x4E\x4F\x54\x55\x50");
                        mode = MENU_ASK_MODE_ITEM_COMMAND;
                        step = 1;
                    }

                    break;
                case 43:
                    if (ret->cmd == 1) {
                        ExeScript("\x92\x45\x8F\x6F\x3F");
                        mode = MENU_ASK_MODE_ITEM_COMMAND;
                        step = 3;
                    }

                    break;
                case 45:
                    if (ret->cmd == 1) {
                        mode = MENU_ASK_MODE_ITEM_COMMAND;
                        step = 2;
                        ExeScript("\x8B\x9B\x88\xC3\x8D\x86");
                        ask_para.item->CheckParamLimmit();
                        u8 code[0x40];
                        ask_para.item->TransToPassword((char *) code, 14);
                        char password[0x20];
                        EncodePassword(code, 16, (u8 *) ask_para.item->GetName(0), 20, password, 70);
                        char text[0x80];
                        text[44] = '\0';
                        text[45] = '\0';
                        strcpy(text, password);
                        char  space[0x20] = "  ";
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
                        LoadFileBG("snd2/sp/SP_053.snd", load_stack->stGetTop(), &size);
                        DNG_BATTLE_AREA *battle_scene = menu_GetBattleAreaScene();
                        ask_para.item->DeleteNum(1);

                        if (battle_scene != NULL) {
                            battle_scene->floor_status &= ~DNG_FLOOR_SEAL_MASK;
                        }

                        step = 4;
                        mode = MENU_ASK_MODE_ITEM_COMMAND;
                    }

                    break;
                case ITEM_MENU_COMMAND_BOIL_FISH: {
                    load_stack->stReset();
                    StartReadBG();
                    load_stack->Align64();
                    int size;
                    LoadFileBG("snd2/sp/SP_046.snd", load_stack->stGetTop(), &size);
                    u32 file_size = size;
                    load_stack->Alloc((file_size & 0xF) ? (file_size >> 4) + 1 : file_size >> 4);
                    step = 10;
                    mode = MENU_ASK_MODE_ITEM_COMMAND;
                    int pos[2];
                    MenuPosData->GetPosMenuItemOnItemBrd(pos, MenuCommonInfo->cursor, 0);
                    InitFishBoiledEffect(pos, (mgCTexture *) mgTexManager.GetTexture("menueff0", -1));
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
                item_consumed = 1;
                sound_loaded = 0;
                chara_reload = 0;
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
                    MenuSePlay(0, (u32 *) file->buffer, &MenuSoundBuffer);
                }

                step = 0;
                mode = MENU_ASK_MODE_NONE;
            }

            break;
        case 4:
            if (ReadBGSync() == 0) {
                BG_READ_INFO *file = GetReadBGFile(0);

                if (file != NULL) {
                    MenuSePlay(0, (u32 *) file->buffer, &MenuSoundBuffer);
                }

                ExeScript("\x95\x95\x88\xF3\x89\xF0\x8F\x9C\x3F");
                mode = MENU_ASK_MODE_ITEM_COMMAND;
                step = 2;
            }

            break;
    }

    return 1;
}

/**
 *
 * Extended item-menu question handled by the weapon preview.
 *
 */
enum MENU_ITEM_EXTEND_KIND {
    MENU_ITEM_EXTEND_NONE = 0,     /**< No extended question is active. */
    MENU_ITEM_EXTEND_REPAIR = 1,   /**< Repair animation is running. */
    MENU_ITEM_EXTEND_BUILD_UP = 2, /**< Weapon build-up is being selected or shown. */
};

/**
 *
 * Stages of the item-menu repair animation.
 *
 */
enum MENU_REPAIR_STEP {
    MENU_REPAIR_LOAD = 0,     /**< Starts loading the repair resources. */
    MENU_REPAIR_GENERATE = 1, /**< Creates the repair effect after loading. */
    MENU_REPAIR_ANIMATE = 2,  /**< Waits for the repair animation to finish. */
};

/**
 *
 * Stages of the item-menu weapon build-up preview.
 *
 */
enum MENU_BUILD_UP_STEP {
    MENU_BUILD_UP_SELECT = 0,  /**< Selects a prospective build-up weapon. */
    MENU_BUILD_UP_CONFIRM = 1, /**< Asks whether to perform the build-up. */
    MENU_BUILD_UP_LOAD = 2,    /**< Creates the build-up character after loading. */
    MENU_BUILD_UP_ANIMATE = 3, /**< Transforms the weapon during the preview animation. */
    MENU_BUILD_UP_FINISH = 4,  /**< Waits for dismissal of the completion message. */
    MENU_BUILD_UP_BLOCKED = 5, /**< Waits for dismissal of a failed condition message. */
};

/**
 *
 * Rounds a byte count up to a number of 16-byte allocation blocks.
 *
 */
static inline u_int align16_blocks(u_int size) {
    if (size & 0xF) {
        return (size >> 4) + 1;
    }

    return size >> 4;
}

#pragma inline_depth(8)

int CMenuItemInfo::IsAskExtend(int select_key, int push_button) {
    mgCMemory         *load_stack = &MenuCharaLoadStack;
    mgCMemory          work;
    MENU_ASKMODE_PARA *para = &ask_para;
    /**
     *
     * Counter of the extended weapon build-up effect.
     *
     */
    static int         Effect_Counter = 0;
    mgCTextureManager *tex_manager = &mgTexManager;
    CMenuPosDataForm  *mes_form = MenuMesForm[7];
    int                reading = ReadBGSync();
    float              position[4];
    int                size;

    switch (para->ask_mode) {
        case MENU_ITEM_EXTEND_NONE:
            break;
        case MENU_ITEM_EXTEND_REPAIR:
            switch (step) {
                case MENU_REPAIR_LOAD:
                    MenuRepairMan->LoadDataBG(load_stack);
                    step++;
                    break;
                case MENU_REPAIR_GENERATE:
                    if (reading == 0) {
                        int repair_tex_block = tex_block[2];
                        MenuRepairMan->CheckDataBG(repair_tex_block);
                        MenuActionChara[0]->GetPosition(position);

                        if (repair_running) {
                            MenuRepairMan->GeneratePoly(position, repair_tex_block);

                            if (MenuActionChara[0] != NULL) {
                                MenuActionChara[0]->pallet[0].SetAnim(0xEB, 0xEB, 0x3C, 1, 0x29, 0);
                            }
                        }

                        MenuRepairMan->Generate(MenuRepairTargetWeaponPos[0], MenuRepairTargetWeaponPos[1]);
                        step++;
                    }

                    break;
                case MENU_REPAIR_ANIMATE:
                    if (repair_running == 0 || (repair_running == 1 && !MenuRepairMan->IsRun())) {
                        if (MenuCommonInfo->cursor_form != NULL) {
                            MenuCommonInfo->cursor_form->draw_flag = 1;
                        }

                        repair_running = 0;
                        step = MENU_REPAIR_LOAD;
                        para->ask_mode = MENU_ITEM_EXTEND_NONE;
                        mode = MENU_ASK_MODE_NONE;
                    }

                    break;
            }

            break;
        case MENU_ITEM_EXTEND_BUILD_UP: {
            int                  close;
            BUILDUP_WEAPON_INFO *info = &BuildUpWeaponInfo;
            /**
             *
             * Non-zero when the extended weapon build-up finishes.
             *
             */
            static u8     BuildEndFlag = 0;
            CActionChara *chara = MenuActionChara[0];
            CDC2Mes      *name_message = MenuDCMsg[6];
            CDC2Mes      *message = MenuDCMsg[7];
            close = 0;

            switch (step) {
                case MENU_BUILD_UP_SELECT: {
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

                    if (info->select_num <= info->select_no) {
                        info->select_no = info->select_num - 1;
                    }

                    int          select = info->select_no;
                    CDataWeapon *data = info->weapon_data[select];

                    if (old_select != select) {
                        MenuSePlay(SYSTEM_SE_CURSOR);
                    }

                    MenuWeaponStatusInfoFormSet(info->weapon, data);

                    switch (push_button) {
                        case MENU_PUSH_BUTTON_DECIDE:
                        case MENU_PUSH_BUTTON_TRIANGLE:
                        case MENU_PUSH_BUTTON_SQUARE:
                            if (info->enable[select] == 1) {
                                if (CheckBuildUpMonsterCondition(data)) {
                                    ExeScript("\x83\x72\x83\x8B\x83\x68\x83\x41\x83\x62\x83\x76\x81\x48");

                                    if (name_message->name[select + 1] != NULL) {
                                        strcpy(message->name[0], name_message->name[select + 1]);
                                    }

                                    message->StepMsg();
                                    step++;
                                } else {
                                    ExeScript("\x83\x72\x83\x8b\x83\x68\x83\x41\x83\x62\x83\x76\x4e\x47");
                                    step = MENU_BUILD_UP_BLOCKED;
                                }
                            } else {
                                MenuSePlay(SYSTEM_SE_CANCEL);
                            }

                            break;
                        case MENU_PUSH_BUTTON_CANCEL:
                            info->mode = 0;
                            close = 1;
                            MenuSePlay(SYSTEM_SE_CANCEL);
                            break;
                    }

                    break;
                }
                case MENU_BUILD_UP_CONFIRM: {
                    int choice = message->YesNoCursor();

                    switch (push_button) {
                        case MENU_PUSH_BUTTON_DECIDE:
                        case MENU_PUSH_BUTTON_TRIANGLE:
                        case MENU_PUSH_BUTTON_SQUARE:
                            if (choice == 0) {
                                MenuSePlay(SYSTEM_SE_DECIDE);
                                BuildEndFlag = 0;
                                info->mode = 0;
                                load_stack->stReset();
                                load_stack->Align64();
                                u_long128 *buffer = load_stack->stGetTop();
                                StartReadBG();
                                LoadFileBG("menu/eff/buildup.chr", buffer, &size);
                                load_stack->Alloc(QuadwordsFor(size + 0x800));
                                load_stack->Align64();
                                LoadFileBG("snd2/sp/SP_045.snd", load_stack->stGetTop(), &size);
                                load_stack->Alloc(QuadwordsFor(size + 0x800));
                                itemmenu_chr_rotflag = 0;
                                step++;
                                break;
                            }
                        case MENU_PUSH_BUTTON_CANCEL:
                            if (MenuCommonInfo->cursor_form != NULL) {
                                MenuCommonInfo->cursor_form->draw_flag = 1;
                            }

                            step = MENU_BUILD_UP_SELECT;
                            MenuSePlay(SYSTEM_SE_CANCEL);
                            break;
                    }

                    if (push_button != 0) {
                        mes_form->draw_flag = 0;
                    }

                    break;
                }
                case MENU_BUILD_UP_LOAD:
                    if (reading == 0) {
                        BG_READ_INFO *model_file = GetReadBGFile(0);
                        BG_READ_INFO *sound_file = GetReadBGFile(1);

                        if (sound_file != NULL) {
                            mgCMemory sound_stack;
                            sound_stack.stSetBuffer(load_stack->stGetTop(), 0x1C0);
                            load_stack->Alloc(0x1C0);
                            MenuSePlay(0, (u_int *) sound_file->buffer, &sound_stack);
                        }

                        chara->GetPosition(position);
                        tex_manager->DeleteBlock(tex_block[2]);
                        load_stack->Align64();
                        int rest = load_stack->stGetRest();
                        work.stSetBuffer(load_stack->stGetTop(), rest);
                        build_up_chara = new (work.Alloc(align16_blocks(sizeof(CActionChara)) + 2)) CActionChara;
                        build_up_chara->Initialize(NULL);
                        build_up_chara->LoadPack((u_int *) model_file->buffer, "info.cfg", &work, &work, &work, tex_block[2], NULL);
                        build_up_chara->SetScale(1.5f, 1.5f, 1.5f);
                        build_up_chara->SetPosition(position);
                        build_up_chara->SetMotion("\x94\xAD\x93\xAE", 0, 1);
                        build_up_chara->Step();
                        mgCFrame *frame = build_up_chara->CObjectFrame::frame;

                        if (frame != NULL) {
                            mgCFrameAttr *const attr = frame->attr;

                            if (attr != NULL) {
                                attr->z_test = -1;
                                frame->SetAttrParam(*attr, 1, MG_FRAME_ATTR_Z_TEST);
                            }
                        }

                        work.Alloc(0x100);
                        BuildEndFlag = 0;
                        char *path = GetItemFilePath(name_message->item_mes[info->select_no + 1], 1);
                        work.Align64();
                        u_long128 *buffer = work.stGetTop();
                        StartReadBG();
                        LoadFileBG(path, buffer, &size);
                        build_loading = 1;
                        step++;
                    }

                    break;
                case MENU_BUILD_UP_ANIMATE: {
                    build_up_chara->Step();

                    if (!BuildEndFlag) {
                        float frame_no = build_up_chara->GetNowFrame(NULL);

                        if (28.0f < frame_no) {
                            chara->Show(0, 1);
                        }

                        if (34.0f < frame_no) {
                            chara_poly_form[0]->counter = -6;
                        }

                        if (reading == 0 && 40.0f < frame_no) {
                            BG_READ_INFO *file = GetReadBGFile(0);
                            int           new_item_no = name_message->item_mes[info->select_no + 1];
                            BuildUpWeaponTrans(info->weapon, new_item_no);
                            int weapon_tex_block = tex_block[1];
                            tex_manager = &mgTexManager;
                            mgCTextureManager *const textures = tex_manager;
                            textures->DeleteBlock(weapon_tex_block);
                            strcpy(textures->name_suffix, "_mn");
                            MenuActionCharaBuffer[0].stReset();
                            chara->Initialize(NULL);
                            chara->LoadPack((u_int *) file->buffer, "info.cfg", MenuActionCharaBuffer, MenuActionCharaBuffer,
                                            MenuActionCharaBuffer, weapon_tex_block, NULL);
                            textures->name_suffix[0] = 0;
                            WeaponBuildCheck(chara, new_item_no, weapon_tex_block);
                            BuildEndFlag = 1;
                        }
                    }

                    if (BuildEndFlag == 1 && build_up_chara->CheckMotionEnd(NULL)) {
                        build_loading = 0;
                        build_up_chara = NULL;
                        ExeScript("\x83\x72\x83\x8B\x83\x68\x83\x41\x83\x62\x83\x76\x8F\x49\x97\xB9");

                        if (name_message->name[info->select_no + 1] != NULL) {
                            strcpy(message->name[0], name_message->name[info->select_no + 1]);
                        }

                        step++;
                    }

                    break;
                }
                case MENU_BUILD_UP_FINISH:
                    if (push_button != 0) {
                        close = 1;
                        mes_form->draw_flag = 0;
                        itemmenu_chr_rotflag = 1;
                        MenuSePlay(SYSTEM_SE_DECIDE);
                    }

                    break;
                case MENU_BUILD_UP_BLOCKED:
                    if (push_button != 0) {
                        mes_form->draw_flag = 0;

                        if (MenuCommonInfo->cursor_form != NULL) {
                            MenuCommonInfo->cursor_form->draw_flag = 1;
                        }

                        step = MENU_BUILD_UP_SELECT;
                        MenuSePlay(SYSTEM_SE_CANCEL);
                    }

                    break;
            }

            if (close == 1) {
                MenuWeaponStatusInfoFormSet(NULL, NULL);
                step = MENU_BUILD_UP_SELECT;
                mode = MENU_ASK_MODE_NONE;
                para->ask_mode = MENU_ITEM_EXTEND_NONE;
            }

            break;
        }
    }

    return 0;
}

#pragma inline_depth reset

void MenuMoveItemPos(int *item, int *pos, int phase) {
    /**
     *
     * Forms displaying the two characters and the ridepod during item movement.
     *
     */
    static char *tbl[3] = {"form_view00", "form_view01", "form_view2"};

    /**
     *
     * Part-name formats for item movement slots.
     *
     */
    static char *plist[3] = {"item%d", "wep%d", "esa0"};

    char part_name[0x20];

    if (phase == 0) {
        int kind = item[0];

        if (kind == 0) {
            if (item[2] == 0 || item[2] == 1 || item[2] == 2) {
                sprintf(part_name, plist[item[2]], item[3]);
            } else {
                strcpy(part_name, "chara");
            }

            ((CMenuPosDataForm *) MenuPosData->GetFormInfo(tbl[item[1]]))
                ->GetPutPosXY(part_name, pos[0], pos[1]);
        } else if (kind == 1) {
            (MenuPosData)->GetPosMenuItemOnItemBrd(pos, item[3], 0);
        } else if (kind == 2) {
            MenuCommonInfo->GetItemPos(pos);
        } else if (kind == 4) {
            ((CMenuPosDataForm *) MenuPosData->GetFormInfo(OverFlowFormName))
                ->GetPutPosXY(local_over_flow_baseposname[item[3]], pos[0], pos[1]);
        } else if (kind == 5) {
            ((CMenuPosDataForm *) MenuPosData->GetFormInfo(tbl[0]))
                ->GetPutPosXY("esa0", pos[0], pos[1]);
        }
    }

    if (phase == 1) {
        int kind = item[0];

        if (kind == 1) {
            (MenuPosData)->GetPosMenuItemOnItemBrd(pos, item[3], 0);
        } else if (kind == 2) {
            MenuCommonInfo->GetItemPos(pos);
        }
    }
}

void CommonSetMoveItemClass(int (*table)[4]) {
    int                 goal[2];
    int                 start[2];
    int                 clear_source = 0;
    CGameDataUsed      *items[2] = {NULL, NULL};
    MENU_ITEM_MOVE_INFO info[2];

    for (int i = 0; i < 2; i++) {
        MENU_ITEM_MOVE_INFO *move = &info[i];
        move->active = 1;
        move->mode = MENU_MOVE_ITEM_COPY;

        for (int j = 0; j < 4; j++) {
            move->from[j] = table[i][j];
        }

        int *slot = table[i];

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
            items[i] = &MenuUserParam.used_data[slot[3]];
            clear_source = 1;
        } else if (move->from[0] == 2) {
            clear_source = 1;
            items[i] = &MenuCommonInfo->have_item;
        } else if (move->from[0] == 3) {
            clear_source = 0;
            items[i] = &MenuMoveTempGameDataUsed;
            move->from[0] = 1;
            slot[0] = 1;
        } else if (move->from[0] == 5) {
            items[i] = GetUserDataMan()->GetActiveEsa();
            clear_source = 1;
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

void CMenuItemInfo::EnterDataMenu(unsigned int *pack) {
    int                sound_size;
    mgCTextureManager *textures;
    u8                *item_image = (u8 *) GetPackFile(pack, "item.img", NULL);
    int                block = tex_block[0];
    textures = &mgTexManager;
    textures->DeleteBlock(block);
    textures->EnterIMGFile(item_image, block, NULL, NULL);
    MenuPosData->ResetTextureInfoAll();
    money_form->SetNumber("num", MenuUserDataManPtr->money);
    Tex_BuildUpBoard = textures->GetTexture("item0", -1);
    MenuItemSpectolTransSoundBuffer = GetPackFile(pack, "SP_002.snd", &sound_size);

    if (MenuDCMsg[3] != NULL) {
        int i = 0;

        do {
            strcpy(MenuDCMsg[3]->name[0], " ");
            i += 1;
            MenuDCMsg[3]->item_mes[0] = 1;
        } while (i < 4);

        MenuDCMsg[3]->MakeMsg(-1);
    }

    MenuStatusMode = 0;
    MenuStatusTex = textures->GetTexture("mtetc", -1);
    MenuLevelUpMan.label_tex = textures->GetTexture("mt0", -1);
}

int CMenuItemInfo::GetActiveCharaIDForItemCmd() {
    short current = view_mode;

    if (current == MENU_ITEM_VIEW_MAX) {
        return 0;
    }

    if (current == MENU_ITEM_VIEW_MONICA) {
        return 1;
    }

    if (current == MENU_ITEM_VIEW_WEAPON || current == MENU_ITEM_VIEW_FISHING_ROD) {
        return MenuUserDataManPtr->active_chr_no;
    }

    if (current == MENU_ITEM_VIEW_ROBO) {
        return 2;
    }

    if (current == MENU_ITEM_VIEW_MONSTER) {
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
    int           chara_no;
    CActionChara *chara;
    int           equip_list_no;
    mgCMemory    *stack;

    field_chara = (CActionChara *) MenuMainScene->GetCharacter(0);

    if (sound_loaded != 0) {
        MenuCharaSoundEnter(MenuMainScene, field_chara, 1);
    }

    if (chara_reload != 0) {
        chara_no = GetActiveCharaNo();
        chara = (CActionChara *) MenuMainScene->GetCharacter(0);
        DeleteOutLineMenu(chara, 0);
        ((CCharacter2 *) chara)->DeleteImage();
        stack = MorattaStack;
        stack->stack_used = 0;
        stack->lock = 0;
        chara->AllDeleteDamage();
        chara->Initialize(MorattaStack);
        AccumulateEffect.frame = 0;
        AccumulateEffect.unk_320 = 0;
        AccumulateEffect.mode = 0;
        chara->accume_effect = &AccumulateEffect;
        chara->LoadPack(MainCharaReadBuffer.model, "info.cfg", MorattaStack, MorattaStack, MorattaStack,
                        MenuArg.chara_tex_block, 0);
        SwordEffectStack.stack_used = 0;
        SwordEffectStack.lock = 0;
        SetSwordBlurEffect((CCharacter2 *) chara, &SwordEffectStack, chara_no);
        stack = MorattaStack;
        stack[1].stack_used = 0;
        stack[1].lock = 0;
        mgCTextureManager *textures = &mgTexManager;
        textures->DeleteTexAnime(MenuArg.chara_tex_block);
        ((CCharacter2 *) chara)
            ->LoadSkin(MainCharaReadBuffer.skin, "info.cfg", "", MorattaStack + 1,
                       MenuArg.chara_tex_block);
        stack = MorattaStack;
        stack[5].stack_used = 0;
        stack[5].lock = 0;
        ((CCharacter2 *) chara)
            ->LoadSkin(MainCharaReadBuffer.outline, "info.cfg", "skin3", MorattaStack + 5,
                       MenuArg.chara_tex_block);
        SetupUnitMan(MenuMainScene, (CUserDataManager *) GetUserDataMan(), chara_no, NULL);
        chara->effect_man = FxScriptMan;
    }

    equip_list_no = CheckEquipListNo(0);

    if ((equip_list_no != 0 || GetActiveCharaNo() == 2) && MenuMainScene != NULL &&
        GetMenuLoopType() == (int) MENU_LOOP_DUNGEON) {
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
    MenuSystemDataPtr->item_cursor = (int) *(void **) &MenuCommonInfo->cursor;
    CopyActiveItemAndWeapon(MenuArg.active_chara_no, -1);
    ExeScript("EXITEND");
    MenuPosData->TexGetInfoClear(0x5A, 0x100);
    MenuPosData->EtcTblClear(0x1E, 0x60);
    MenuCommonInfo->have_item.Init();
    MenuMainFrameModeSet(0, 0);
}

void CMenuItemInfo::AttachFormInfo() {
    int i;

    for (i = 0; i < 6; i++) {
        view_form[i] = (CMenuPosDataForm *) MenuPosData->GetFormInfo(ItemMenuFormNameTbl[i]);
    }

    MenuSpectolSatusCheckForm = (CMenuPosDataForm *) MenuPosData->GetFormInfo("SPECHECK");
    MenuSpectolSatusCheckBGFadeForm = (CMenuPosDataForm *) MenuPosData->GetFormInfo("SPEFADE");
    status_check_ready = 0;

    for (i = 0; i < 2; i++) {
        CMenuPosDataForm *form = view_form[i];
        wep_parts[i][4] = form->GetPartInfo("wepfrm0");
        wep_parts[i][5] = form->GetPartInfo("whp00");
        wep_parts[i][6] = form->GetPartInfo("slu1");
        wep_parts[i][7] = form->GetPartInfo("whp01");
        wep_parts[i][8] = form->GetPartInfo("wep0");
        wep_parts[i][9] = form->GetPartInfo("batu0");
        wep_parts[i][10] = form->GetPartInfo("wepfrm1");
        wep_parts[i][11] = form->GetPartInfo("whp10");
        wep_parts[i][12] = form->GetPartInfo("slu2");
        wep_parts[i][13] = form->GetPartInfo("whp11");
        wep_parts[i][14] = form->GetPartInfo("wep1");
        wep_parts[i][15] = form->GetPartInfo("batu1");
        hp_bar[i] = form->GetPartInfo("hp_bar");
        item_parts[i][0] = form->GetPartInfo(local_over_flow_baseposname[0]);
        item_parts[i][1] = form->GetPartInfo(local_over_flow_baseposname[1]);
        item_parts[i][2] = form->GetPartInfo(local_over_flow_baseposname[2]);
        item_num[i][0] = form->GetPartInfo("item0num");
        item_num[i][1] = form->GetPartInfo("item1num");
        item_num[i][2] = form->GetPartInfo("item2num");
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
    voice_part = robo_form->GetPartInfo("VOICE");
    robo_parts[0] = robo_form->GetPartInfo("wepfrm");
    robo_parts[1] = robo_form->GetPartInfo("whp00");
    robo_parts[2] = robo_form->GetPartInfo("slu1");
    robo_parts[3] = robo_form->GetPartInfo("whp01");
    robo_parts[4] = robo_form->GetPartInfo("wep0");
    robo_parts[5] = robo_form->GetPartInfo("batu0");
    item_board_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("itembrd");
    item_board_icon = NULL;

    if (item_board_form != NULL) {
        item_board_icon = item_board_form->GetPartInfo("icon");
    }

    money_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("moneybrd");
    fill_form = (CMenuPosDataForm *) MenuPosData->GetFormInfo("mainform_filldmy");
    chara_poly_form[0] = (CMenuPosDataForm *) MenuPosData->GetFormInfo("poly_chr0");
    chara_poly_form[1] = (CMenuPosDataForm *) MenuPosData->GetFormInfo("poly_chr1");
    GiftBoxViewForm = (CMenuPosDataForm *) MenuPosData->GetFormInfo("giftview");
}

#pragma inline_depth(8)

void CMenuItemInfo::MenuModeMalloc(mgCMemory *stack) {
    /**
     *
     * Background-read reservation mode for each menu memory area.
     *
     */
    static int tbl[7] = {1, 1, 1, 1, 1, 1, 1};

    int             i;
    CMenuMoveItem  *move_item;
    CMenuEffect    *effect;
    CRepairManager *repair;

    int free_blocks = stack->stack_size - stack->stack_used;
    MenuItemMemory2.stSetBuffer((stack->stack + stack->stack_used),
                                free_blocks);

    for (i = 0; i < 7; i++) {
        MenuActionChara[i] = new (MenuItemMemory2.Alloc(0x105)) CActionChara;
        MenuActionChara[i]->Initialize(NULL);
    }

    MenuBGReadInfo2Malloc(&MenuItemMemory2, tbl);

    move_item = new (MenuItemMemory2.Alloc(0x13)) CMenuMoveItem;

    MenuMoveItemPtr = move_item;
    MenuMoveItemPtr->AttachForm();
    SpectolFrame = new (MenuItemMemory2.Alloc(0x105)) CActionChara;

    if ((effect = (CMenuEffect *) operator new(sizeof(CMenuEffect), MenuItemMemory2.Alloc(6))) != NULL) {
        effect->Initialize();
    }

    MenuEffect[0] = effect;

    if ((effect = (CMenuEffect *) operator new(sizeof(CMenuEffect), MenuItemMemory2.Alloc(6))) != NULL) {
        effect->Initialize();
    }

    MenuEffect[1] = effect;

    repair = new (MenuItemMemory2.Alloc(0x21)) CRepairManager;

    MenuRepairMan = repair;
    repair->Initialize();
    MenuLevelUpMan.Initialize();
    InitBuildUpInfoEffect(&MenuItemMemory2, (mgCTexture *) mgTexManager.GetTexture("menueff0", -1), 8,
                          20.0f);
    free_blocks = MenuItemMemory2.stack_size - MenuItemMemory2.stack_used;
    MenuItemMemory.stSetBuffer(
        (MenuItemMemory2.stack + MenuItemMemory2.stack_used), free_blocks);
}

#pragma inline_depth reset

void CMenuItemInfo::CalcTex() {
    /**
     *
     * View-page number associated with each preview form.
     *
     */
    static u8 itemmenu_calcmode_tbl[6] = {0, 1, 2, 3, 4, 5};

    int slot;
    Func_MenuItemBrdPosStep(MenuItem_ItemBoardTopLine);
    int cursor = MenuCommonInfo->cursor;
    /**
     *
     * Previous preview movement state used when refreshing character data.
     *
     */
    static s8 checkmoveFlag = 0;
    int       i;
    int       check_move = MenuMoveItemPtr->CheckMove();
    int       view_flag[6];

    for (i = 0; i < 6; i++) {
        if (itemmenu_calcmode_tbl[i] != view_mode) {
            view_form[i]->SetAction("\x8A\x4F\x82\xD6");
        } else {
            view_form[i]->SetAction("\x92\x86\x82\xD6");

            if (mode == MENU_ASK_MODE_CLOSE && CheckTrushMenu() == 0 && item_consumed == 0) {
                view_form[i]->SetAction("\x8A\x4F\x82\xD6");
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

    if (view_mode == MENU_ITEM_VIEW_WEAPON || view_mode == MENU_ITEM_VIEW_FISHING_ROD) {
        reference_id = 4;
        reference_no = 0;
    } else if (held_item_no <= 0) {
        if (key_arg_no == (int) ITEM_MENU_PANEL_EQUIPMENT || key_arg_no == (int) ITEM_MENU_PANEL_RIDEPOD_PARTS) {
            reference_no = cursor;
        }
    } else {
        int held_type = GetItemDataType(held_item_no);

        for (slot = 0; slot < 4; slot++) {
            if (held_type == SearchEquipType(reference_id, slot)) {
                reference_no = slot;
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
            case MENU_ITEM_VIEW_MAX:
            case MENU_ITEM_VIEW_MONICA:
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
            case MENU_ITEM_VIEW_ROBO:
            case MENU_ITEM_VIEW_MONSTER:
                AddRotationCharaY(chara, 0.01308997f);
                break;
            case MENU_ITEM_VIEW_WEAPON:
            case MENU_ITEM_VIEW_FISHING_ROD:
                if (itemmenu_chr_rotflag != 0) {
                    AddRotationCharaY(chara, 0.01308997f);
                    MenuWeaponRealStepEnvFunc(MenuWeaponEnvSetChara, MenuWeaponEnvSetListNo);
                }

                break;
        }
    }

    int fusing = 0;
    int spectol_view = 0;
    int chara_view = 0;

    if ((view_mode == MENU_ITEM_VIEW_WEAPON || view_mode == MENU_ITEM_VIEW_FISHING_ROD) && SpectolInfo[0] != NULL && view_weapon == SpectolInfo[0]) {
        spectol_view = 1;
    }

    if (view_mode == MENU_ITEM_VIEW_MAX || view_mode == MENU_ITEM_VIEW_MONICA) {
        chara_view = 1;
    }

    int effect_pos[2];

    if (mode == MENU_ASK_MODE_FUSION && step > 0) {
        if (step == 1) {
            fusing = 1;
        }

        MenuPosData->GetPosMenuItemOnItemBrd(effect_pos, trans_spectol_pos, 0);

        if (key_arg_no == (int) ITEM_MENU_PANEL_BAG) {
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

    if (view_mode == MENU_ITEM_VIEW_WEAPON || view_mode == MENU_ITEM_VIEW_FISHING_ROD) {
        SpectolFrameCalc(MenuActionChara[0], fusing && spectol_view);
        CMenuPosDataForm *poly_form = chara_poly_form[1];
        poly_form->draw_flag = (fusing && spectol_view) != 0;
    }

    int   item_mes[6] = {10, 11, 1, 1, 1, 1};
    int   volumes[6] = {0};
    char *names[8] = {" ", " ", " ", " ", " ", " ", " "};

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
        view_form[i]->GetPutPosXY("name", name_pos[i][0], name_pos[i][1]);
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
    int      insert_mes[6] = {-1, -1, -1, -1, -1, -1};
    int      key_no = key_arg_no;
    int      mes_no = key_no;

    switch (view_mode) {
        case MENU_ITEM_VIEW_MAX:
        case MENU_ITEM_VIEW_MONICA:
            if (key_no == 3) {
                mes_no = 0x6A;
                insert_mes[0] = sub_view + 10;
                info_mes->SetMsgItemNo(insert_mes, 20);
            }

            break;
        case MENU_ITEM_VIEW_WEAPON: {
            s16 slot_mes[2] = {10000, 22};

            if (key_no == 4) {
                mes_no = GetItemMessageNo(view_chara, 1);
            } else if (key_no != 2) {
                mes_no = cursor + (slot_mes[key_no - 4U] + 100);
                info_mes->SetMsgItemNo(insert_mes, 4);
            }

            break;
        }
        case MENU_ITEM_VIEW_ROBO:
            if (key_no == 6) {
                insert_mes[0] = 12;
                mes_no = 0x6A;
                info_mes->SetMsgItemNo(insert_mes, 20);
            }

            break;
        case MENU_ITEM_VIEW_MONSTER: {
            char *monster_name[1] = {NULL};
            mes_no = 0x6C;
            monster_name[0] = GetMonsterName(GetUserDataMan()->monster_id);
            info_mes->SetMsgItemNo(monster_name, 1);
            break;
        }
        case MENU_ITEM_VIEW_FISHING_ROD:
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

        if (held->item_no == (int) ITEM_ID_SPECTOL && item != NULL) {
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

        if (key_arg_no == (int) ITEM_MENU_PANEL_BAG) {
            MenuPosData->GetPosMenuItemOnItemBrd(gift_pos, cursor, 0);
        } else if (key_arg_no == (int) ITEM_MENU_PANEL_ACTIVE_ITEMS) {
            char part_name[32];
            sprintf(part_name, "c_i%d", MenuCommonInfo->cursor);
            view_form[sub_view]->GetPutPosXY(part_name, gift_pos[0], gift_pos[1]);
        }

        CMenuPosDataForm *gift_form = GiftBoxViewForm;
        gift_form->x = gift_pos[0];
        gift_form->y = gift_pos[1];

        if (mode == MENU_ASK_MODE_CLOSE) {
            NowGiftBoxPtr = NULL;
        }
    }

    if (check_move != checkmoveFlag) {
        if (view_mode == MENU_ITEM_VIEW_MAX) {
            MenuItemCharaDataLoadEndCheckAfter(MenuCharaBuild2, USER_CHARA_MAX);
        } else if (view_mode == MENU_ITEM_VIEW_MONICA) {
            MenuItemCharaDataLoadEndCheckAfter(MenuCharaBuild2, USER_CHARA_MONICA);
        } else if (view_mode == MENU_ITEM_VIEW_ROBO) {
            MenuItemCharaDataLoadEndCheckAfter(MenuCharaBuild2, USER_CHARA_ROBO);
        }
    }

    checkmoveFlag = check_move;
    EffectDrawCheck(item_board_form);
}

void CMenuItemInfo::CalcCursorPosition() {
    /**
     *
     * Cursor frame type for each key layout.
     *
     */
    static s8 wakutypeTbl[12] = {1, 1, 0, -1, -1, -1, -1, 1, -1, -1, -1, 1};

    /**
     *
     * Cursor frame width and height for each key layout.
     *
     */
    static s8 waku_infotbl[12][2] = {
        {72, 72},
        {82, 82},
        {36, 42},
        {0,  0 },
        {0,  0 },
        {80, 40},
        {0,  0 },
        {72, 72},
        {0,  0 },
        {0,  0 },
        {0,  0 },
        {66, 66}
    };

    if (mode == MENU_ASK_MODE_CLOSE) {
        MenuCommonInfo->SetWakuType(-1);
        return;
    }

    char              name[0x20];
    CMenuPosDataForm *form = NULL;
    int               pos[2] = {0, 0};
    int               cursor;
    int               arg_no = key_arg_no;
    cursor = MenuCommonInfo->cursor;
    int waku_no = arg_no;

    if (arg_no != 12) {
        if (arg_no < 0) {
            key_arg_no = (int) ITEM_MENU_PANEL_ACTIVE_ITEMS;
        }

        CMenuPosDataForm *forms[12] = {view_form[sub_view], view_form[sub_view], item_board_form, view_form[sub_view], view_form[2], view_form[2],
                                       view_form[3], view_form[3], view_form[4], view_form[5], view_form[5], view_form[sub_view]};
        form = view_form[sub_view];

        if (key_arg_no == (int) ITEM_MENU_PANEL_ACTIVE_ITEMS || key_arg_no == (int) ITEM_MENU_PANEL_EQUIPMENT) {
            form = view_form[sub_view];
        } else {
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
        char part_name[0x20];
        int  offset[2] = {0, 0};

        if (arg_no == 4 || arg_no == 9) {
            strcpy(part_name, "chrpos");

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
            sprintf(name, "c_i%d", cursor);
            form->GetPutPosXY(name, pos[0], pos[1]);
            pos[1] -= 8;
        } else if (arg_no == 1 || arg_no == 7) {
            int no = cursor;

            if (cursor < 0 || cursor > 1) {
                no = 0;
            }

            sprintf(name, "c_w%d", no);
            form->GetPutPosXY(name, pos[0], pos[1]);
        } else if (arg_no == 3 || arg_no == 6 || arg_no == 8) {
            form->GetPutPosXY("chr_cur", pos[0], pos[1]);
        } else if (arg_no == 11) {
            form->GetPutPosXY("esac", pos[0], pos[1]);
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

    if (menu_debug_flag != 0 && key_arg_no == (int) ITEM_MENU_PANEL_BAG) {
        pos[0] = 0x64;
        pos[1] = 0x50;
    }

    MenuItemCommandDir = -1;

    if (mode == MENU_ASK_MODE_ITEM_COMMAND) {
        SetItemCmdMsgPos(msg_pos);
    }

    int cursor_offset[2] = {0, 0};

    if (arg_no < 12) {
        sprintf(name, "cur_off%d", arg_no);
        MenuPosData->GetEtcTblValue(name, cursor_offset[0], cursor_offset[1]);
    }

    MenuCommonInfo->MenuPosStep(pos, cursor_offset);

    if (MenuCommonInfo->cursor_form->draw_flag == 0) {
        waku_no = -1;
    }

    if (waku_no >= 0) {
        MenuCommonInfo->SetWakuWH(wakutypeTbl[arg_no], waku_infotbl[waku_no][0], waku_infotbl[waku_no][1]);
        MenuCommonInfo->SetWakuType(wakutypeTbl[arg_no]);
    } else {
        MenuCommonInfo->SetWakuType(-1);
    }

    if (reset_cursor_pos) {
        MenuCommonInfo->MenuSetPos(pos[0], pos[1]);
        reset_cursor_pos = 0;
    }
}

void CBaseMenuClass::EffectDrawCheck(CMenuPosDataForm *form) {
    MENUFORMPARTS_TYPE *part = &form->parts[trans_spectol_pos];
    int                 effect_type = MenuEffect[0]->type;

    if (mode == MENU_ASK_MODE_SPECTOL && step == 1) {
        if (part != NULL) {
            switch (effect_type) {
                case 19:
                    trans_spectol_posold = ask_para.arg0;
                    trans_spectol_rgb = (int) (128.0f + 96.0f * sinf(0.05235988f * trans_spectol_cnt));
                    trans_spectol_cnt += 1.0f;
                    part->rgba[3] = (s8) trans_spectol_rgb;
                    break;
                case 18:
                    part->draw_flag = 0;
                    part = &form->parts[trans_spectol_posold];
                    part->rgba[3] = 0x80;
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
                        int full_alpha = 0x80;
                        old_part->rgba[3] = full_alpha;
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

int MenuItemInit(mgCMemory *stack, int *tex_block, int mode) {
    FxScriptManPauseFlag = 0;
    u_long128 *buffer = stack->stack;
    stack->Alloc(0x80);
    MenuItemBGDataMemory.stSetBuffer(buffer, stack->stack_used);
    u_int    *pack = (u_int *) buffer;
    mgCMemory work;
    int       rest = stack->stGetRest();
    work.stSetBuffer(stack->stGetTop(), rest);
    CMenuItemInfoPt = &class_menu_item_info;
    CMenuItemInfoPt->Initialize();
    CMenuItemInfoPt->SetTexBlock(tex_block);

    if (GetNowLoopNo() == (int) LOOP_DUNGEON) {
        MenuMainScene->AssignStack(5);
        mgCMemory *scene_stack = MenuMainScene->GetStack(5);
        int        size = scene_stack->stGetSize();
        MainCharaReadStack.stSetBuffer(scene_stack->stGetTop(), size);
    }

    MenuWeaponEnvSetListNo = -1;
    MenuWeaponEnvSetChara = NULL;
    int   script_size;
    char *layout = (char *) GetPackFile(pack, "item.cfg", &script_size);
    MenuDataAnalyze(layout, script_size, &work);
    CMenuItemInfoPt->script = (char *) GetPackFile(pack, "item_com.cfg", &CMenuItemInfoPt->script_size);
    rest = work.stGetRest();
    MenuItemMainMemory.stSetBuffer(work.stGetTop(), rest);
    CMenuItemInfoPt->MenuModeMalloc(&MenuItemMainMemory);
    MenuPosData->GetEtcTbl2Value("camref", CMenuItemInfoPt->camera_ref, 3);
    MenuPosData->GetEtcTbl2Value("campos", CMenuItemInfoPt->camera_pos, 3);
    CMenuItemInfoPt->AttachFormInfo();
    AttachMessageForm();
    CMenuItemInfoPt->ExeScript("ITEMINIT");
    CMenuItemInfoPt->EnterDataMenu(pack);
    MenuCommonInfo->SetWakuMoveMethod(0);
    MenuCommonInfo->key_enable = 1;
    MenuCommonInfo->CursorFadeIn(1.0f, 0);
    CMenuItemInfoPt->ExeScript("MSGINIT");
    int chara_no = CMenuItemInfoPt->GetActiveCharaNo();
    CMenuItemInfoPt->equipped_model_no = -1;

    if (chara_no < 2) {
        CMenuItemInfoPt->equipped_model_no = MenuUserParam.chara[chara_no]->equip[0].GetModelNo();
    }

    MenuLoadInfo.alternate_model = 0;

    if (GetMenuLoopType() == (int) MENU_LOOP_TOWN) {
        MenuLoadInfo.alternate_model = 1;
        CMenuItemInfoPt->equipped_model_no = -1;
    }

    MenuLoadInfo.mode = 0;
    MenuLoadInfo.load_phase = 0;
    MenuLoadInfo.request_phase = -1;
    MenuLoadInfo.update_scene = 1;
    MenuLoadInfo.load_all = 1;
    s8 view_mode = menuitem_initviewtbl[chara_no];
    CMenuItemInfoPt->view_mode = view_mode;
    CMenuItemInfoPt->active_chara_view_mode = view_mode;
    CMenuItemInfoPt->key_arg_no = (int) ITEM_MENU_PANEL_BAG;
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

    item_menu_argtbl[(int) ITEM_MENU_PANEL_BAG].max = MenuItemBoardTotalNum;
    item_menu_argtbl[(int) ITEM_MENU_PANEL_BAG].rows = MenuItemBoardTotalLine;
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
    BuildUpWeaponInfo.monster_mode = 0;
    InitFishBoiledEffect(NULL, NULL);

    if (!MenuUserParam.chara[0]->equip[0].IsFishingRod()) {
        SetFishingGamePreEquip(NULL);
    }

    SetModeMenuDrawItemBoard(0);
    return 1;
}

extern mgCMemory MenuDebugStack;
#pragma inline_depth(5)

/**
 *
 * Handles debug controls for item previews, character parameters and equipment.
 *
 */
static void MenuItemDebugKey() {
    /**
     *
     * Character-status flags offered by the debug preview.
     *
     */
    static u32 table[7] = {CHARA_STATUS_POISON, CHARA_STATUS_SLOW, CHARA_STATUS_UNK_4, CHARA_STATUS_UNK_8, CHARA_STATUS_POWER, CHARA_STATUS_UNK_20, CHARA_STATUS_UNK_40};

    /**
     *
     * Fallback model path used when the selected item has no model.
     *
     */
    static char    dbox_path[] = "item/d_box.chr";
    float          rotation[4];
    s32            file_size;
    s32            buttons;
    CGameDataUsed *item;

    buttons = MenuCommonInfo->CheckPushButton();
    item = CMenuItemInfoPt->view_weapon;

    switch (CMenuItemInfoPt->key_arg_no) {
        case 2:
            if (MenuDebugModelDrawFlag == 0) {
                s32              direction;
                mgCCameraFollow *camera;
                CActionChara    *model;
                s32              count_step;
                s32              item_no;
                s32              model_loaded;
                void            *buffer;
                s32              stack_used_before_load;
                char            *model_path;

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
                    CMenuItemInfoPt->debug_item_count += count_step;
                }

                if (direction & 0x40) {
                    CMenuItemInfoPt->debug_item_count -= count_step;
                }

                if (CMenuItemInfoPt->debug_item_count <= 0) {
                    CMenuItemInfoPt->debug_item_count = 1;
                }

                if (CMenuItemInfoPt->debug_item_count > 0x64) {
                    CMenuItemInfoPt->debug_item_count = 0x64;
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
                    MenuSePlay(SYSTEM_SE_DECIDE);
                    DebugGetItem(NULL, 0);
                    CheckEnableHaveItemNum();
                }

                if (buttons & MENU_PUSH_BUTTON_DECIDE) {
                    if (debug_common_data != NULL) {
                        MenuUserDataManPtr->GetItemNotOver(
                            CMenuItemInfoPt->debug_item_no,
                            CMenuItemInfoPt->debug_item_count);

                        if (CheckItemOver() &&
                            (MenuCommonInfo->open_type == (int) MENU_OPEN_MAIN_TOWN ||
                             MenuCommonInfo->open_type == (int) MENU_OPEN_MAIN_DUNGEON)) {
                            MenuCommonInfo->open_type += 0x10;
                            ItemOverFlowCheckFlag = 1;
                        }

                        if (CheckTrushMenu()) {
                            MenuItemBoardTotalNum = GetNowBagMax(1);
                            MenuItem_ItemBoardTopLine = MenuItemBoardTotalNum / 6 - 5;
                            MenuItem_ItemBoardTopSelect = GetNowBagMax(0);
                        }

                        item_menu_argtbl[(int) ITEM_MENU_PANEL_BAG].max = MenuItemBoardTotalNum;
                        MenuItemBoardTotalLine = MenuItemBoardTotalNum / 6;
                        item_menu_argtbl[(int) ITEM_MENU_PANEL_BAG].rows = MenuItemBoardTotalLine;
                        CheckEnableHaveItemNum();
                    }
                } else if (buttons & MENU_PUSH_BUTTON_L3) {
                    GameItemDataManage.LoadData();
                    GameItemDataManage.LoadItemSystemMes(LanguageCode);
                } else if (buttons & MENU_PUSH_BUTTON_SQUARE) {
                    MenuDebugStack.stack_used = 0;
                    MenuDebugStack.lock = 0;
                    MenuDebugCamera = NULL;
                    MenuDebugItemModel = NULL;
                    MenuDebugModelDrawFlag = 1;

                    camera = new (MenuDebugStack.Alloc(sizeof(mgCCameraFollow) / 16 + 2))
                        mgCCameraFollow(40.0f, 30.0f, 0.0f, 8.0f);
                    MenuDebugCamera = camera;

                    MenuDebugItemModel = model = new (MenuDebugStack.Alloc(sizeof(CActionChara) / 16 + 2)) CActionChara;
                    model->Initialize(NULL);
                    MenuDebugStack.Align64();

                    buffer = MenuDebugStack.stGetTop();
                    model_loaded = 0;

                    if (debug_common_data != NULL) {
                        model_path = GetItemFilePath(CMenuItemInfoPt->debug_item_no, 0);

                        if (model_path != NULL && LoadFile2(model_path, buffer, &file_size, LOAD_FILE_READ)) {
                            MenuDebugStack.Alloc(file_size / 16 + 1);
                            stack_used_before_load = MenuDebugStack.stack_used;
                            mgTexManager.DeleteBlock(CMenuItemInfoPt->tex_block[4]);
                            MenuDebugItemModel->LoadPack((u_int *) buffer, "info.cfg", &MenuDebugStack,
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
                        buffer = MenuDebugStack.stGetTop();
                        LoadFile2(dbox_path, buffer, &file_size, LOAD_FILE_READ);
                        MenuDebugStack.Alloc(file_size / 16 + 1);
                        stack_used_before_load = MenuDebugStack.stack_used;
                        mgTexManager.DeleteBlock(CMenuItemInfoPt->tex_block[4]);
                        MenuDebugItemModel->LoadPack((u_int *) buffer, "info.cfg", &MenuDebugStack,
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
                    s32   camera_control;

                    MenuDebugItemModel->GetRotation(rotation);
                    x = GamePad__2.GetLXf() / 10.0f;
                    y = GamePad__2.GetLYf() / 10.0f;
                    camera_control = 0;

                    if (GamePad__2.On(PAD_L2)) {
                        camera_control = 1;
                    }

                    if (camera_control) {
                        ((mgCCameraFollow *) MenuDebugCamera)->GetAngle();
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

                if (buttons & MENU_PUSH_BUTTON_TRIANGLE) {
                    MenuDebugItemModel->SetScale(1.0f, 1.0f, 1.0f);
                    MenuDebugItemModel->SetRotation(0.0f, 0.0f, 0.0f);
                    MenuDebugModel_AdjustFlag = 0;
                } else if (buttons & MENU_PUSH_BUTTON_SQUARE) {
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
                } else if (buttons & MENU_PUSH_BUTTON_CANCEL) {
                    MenuDebugModelDrawFlag = 0;
                    MenuDebugItemModel = NULL;
                    MenuDebugCamera = NULL;
                    GamePad__2.MenuModeOn(0x78);
                }
            }

            break;

        case 3: {
            CHARA_DATA *chara;
            s32         change_maximum;

            chara = MenuUserParam.chara[CMenuItemInfoPt->sub_view];

            if (chara != NULL) {
                float health_input[2] = {0.0f, 0.0f};
                MenuCommonInfo->CheckAnalogKey(0, health_input);
                change_maximum = 0;

                if (GamePad__2.On(PAD_L2)) {
                    change_maximum = 1;
                }

                if (change_maximum == 0) {
                    chara->hp.now = chara->hp.now + (float) (s32) health_input[0];
                }

                if (change_maximum == 1) {
                    chara->hp.max = chara->hp.max + (float) (s32) health_input[0];
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
                // The increment wraps at 16 bits before the stored value is capped.
                u16 defence = (u16) chara->defence;
                defence++;
                chara->defence = defence;

                if ((u16) chara->defence > 0x80) {
                    chara->defence = 0x80;
                }
            } else if (GamePad__2.On(PAD_CROSS)) {
                s32 count = (u16) chara->defence;

                if (0 < count) {
                    chara->defence = count - 1;
                }
            }

            if (buttons & MENU_PUSH_BUTTON_TRIANGLE) {
                MenuUserDataManPtr->AddMoney(1000);
                CMenuItemInfoPt->money_form->SetNumber(
                    "num", MenuUserDataManPtr->AddMoney(0));
            }

            if (buttons & MENU_PUSH_BUTTON_SQUARE) {
                /**
                 *
                 * Counter of the debug character-status selection.
                 *
                 */
                static int cnt = 0;
                MenuUserDataManPtr->SetCharaStatusAttirbuteVol(
                    CMenuItemInfoPt->sub_view, table[cnt], 0x78);
                cnt += 1;

                if (cnt > 6) {
                    cnt = 0;
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

            float gauge_input[2] = {0.0f, 0.0f};
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

                if (buttons & MENU_PUSH_BUTTON_DECIDE) {
                    item->AddFusionPoint(1);
                }

                if (buttons & MENU_PUSH_BUTTON_CANCEL) {
                    item->AddFusionPoint(-1);
                }

                if (buttons & MENU_PUSH_BUTTON_SQUARE) {
                    item->AddFusionPoint(500);
                }

                if (buttons & MENU_PUSH_BUTTON_TRIANGLE) {
                    item->LevelUp();
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }
            }

            return;
        }

        case 5: {
            s32          status_index;
            CDataWeapon *info;

            if (item == NULL) {
                break;
            }

            if (item->used_type == USED_ITEM_TYPE_WEAPON) {
                info = GetWeaponInfoData(item->item_no);
                MenuCommonInfo->CheckSelectKey();
                CMenuKeyFunc *common = MenuCommonInfo;

                status_index = common->cursor;
                float weapon_status_input[2] = {0.0f, 0.0f};
                common->CheckAnalogKey(0, weapon_status_input);

                if (status_index < 2) {
                    item->data.weapon.status[status_index] += (s16) (s32) weapon_status_input[0];

                    if (item->data.weapon.status[status_index] < 0) {
                        item->data.weapon.status[status_index] = 0;
                    }

                    if (info->status_max[status_index] < item->data.weapon.status[status_index]) {
                        item->data.weapon.status[status_index] = info->status_max[status_index];
                    }
                } else {
                    int attr = status_index - 2;

                    item->data.weapon.attribute[attr] += (s16) (s32) weapon_status_input[0];

                    if (item->data.weapon.attribute[attr] < 0) {
                        item->data.weapon.attribute[attr] = 0;
                    }

                    if (info->attribute_max[attr] < item->data.weapon.attribute[attr]) {
                        item->data.weapon.attribute[attr] = info->attribute_max[attr];
                    }
                }
            }

            if (item->used_type == USED_ITEM_TYPE_ROBO_PART) {
                MenuCommonInfo->CheckSelectKey();
                CMenuKeyFunc *common = MenuCommonInfo;

                status_index = common->cursor;
                float ridepod_status_input[2] = {0.0f, 0.0f};
                common->CheckAnalogKey(0, ridepod_status_input);

                if (status_index < 2) {
                    item->data.robopart.status[status_index] += (s16) (s32) ridepod_status_input[0];

                    if (item->data.robopart.status[status_index] < 0) {
                        item->data.robopart.status[status_index] = 0;
                    }

                    if (item->data.robopart.status[status_index + 1] > 255) {
                        item->data.robopart.status[status_index + 1] = 255;
                    }
                } else {
                    // Entries 2 through 9 hold the eight ridepod attributes.
                    s16 *attribute = &item->data.robopart.status[2];
                    int  attr = status_index - 2;
                    s16 *field = &attribute[attr];

                    *field += (s16) (s32) ridepod_status_input[0];

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
            float ridepod_gauge_input[2] = {0.0f, 0.0f};
            common->CheckAnalogKey(0, ridepod_gauge_input);

            if (status_index == 0) {
                MenuUserParam.robo->AddPoint(ridepod_gauge_input[WEAPON_STAT_ATTACK]);
            } else if (status_index == 1) {
                MenuUserDataManPtr->AddWhp(2, 0, (s32) ridepod_gauge_input[WEAPON_STAT_ATTACK]);
            }

            break;
        }

        case 10: {
            s32          status_index;
            CDataWeapon *info;

            if (item->IsFishingRod()) {
                info = GetWeaponInfoData(item->item_no);
                MenuCommonInfo->CheckSelectKey();
                CMenuKeyFunc *common = MenuCommonInfo;

                status_index = common->cursor;
                float rod_status_input[2] = {0.0f, 0.0f};
                common->CheckAnalogKey(0, rod_status_input);

                item->data.weapon.attribute[status_index] += (s16) (s32) rod_status_input[0];

                if (item->data.weapon.attribute[status_index] < 0) {
                    item->data.weapon.attribute[status_index] = 0;
                }

                if (info->attribute_max[status_index] < item->data.weapon.attribute[status_index]) {
                    item->data.weapon.attribute[status_index] = info->attribute_max[status_index];
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

                if (buttons & MENU_PUSH_BUTTON_TRIANGLE) {
                    item->data.weapon.status[0] = info->status_max[0];
                    item->data.weapon.status[WEAPON_STAT_DURABILITY] = info->status_max[WEAPON_STAT_DURABILITY];
                    item->data.weapon.attribute[0] = info->attribute_max[0];
                    item->data.weapon.attribute[1] = info->attribute_max[1];
                    item->data.weapon.attribute[2] = info->attribute_max[2];
                    item->data.weapon.attribute[3] = info->attribute_max[3];
                    item->data.weapon.attribute[4] = info->attribute_max[4];
                    item->data.weapon.attribute[5] = info->attribute_max[5];
                    item->data.weapon.attribute[6] = info->attribute_max[6];
                    item->data.weapon.attribute[7] = info->attribute_max[7];
                }

                if (buttons & MENU_PUSH_BUTTON_SQUARE) {
                    item->data.weapon.status[WEAPON_STAT_ATTACK] = info->status[WEAPON_STAT_ATTACK];
                    item->data.weapon.status[WEAPON_STAT_DURABILITY] = info->status[WEAPON_STAT_DURABILITY];
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
                    /**
                     *
                     * Counter of the debug spectrumisation effect test.
                     *
                     */
                    static int testcnt = 0;

                    u32 mask = 0;

                    mask |= 1 << testcnt;
                    item->data.weapon.special = CheckWeaponAttribute(item->data.weapon.special, mask);
                    testcnt += 1;

                    if (testcnt >= 0xC) {
                        testcnt = 0;
                    }
                }
            }

            break;
    }
}

#pragma inline_depth reset

/**
 *
 * Draws the debug item browser and the character and weapon information pages.
 *
 * @mangled MenuItemDebugDraw__Fv
 * @address 0x2494E0
 * @size 0x13A4
 */
static void MenuItemDebugDraw() {
    /**
     *
     * Character-status labels of the debug preview.
     *
     */
    static char *attrtable[7] = {"Poison,", "Slowly,", "Curse,", "Stop,", "Binbin,", "Stone", "Dry"};

    /**
     *
     * Weapon special-ability labels of the debug preview.
     *
     */
    static char *stchar[13] = {"Rich", "Poor", "Poison", "Stop", "Steal", "Break Easy", "Break Hard", "Drain", "Heal", "Dark", "Critical", "ABS2", NULL};

    CMenuFont          menu_font;
    mgCTextureManager *tex_manager = &mgTexManager;
    CMenuFont         *font = &menu_font;
    mgCDrawPrim        prim;
    CGameDataUsed     *weapon = CMenuItemInfoPt->view_weapon;
    char               text[0x100];

    switch (CMenuItemInfoPt->key_arg_no) {
        case 2: {
            tex_manager->ReloadTexture(MenuCommonInfo->tex_block[1], (sceVif1Packet *) NULL);
            SetSpriteEnv(&prim, 2);
            prim.Begin(MG_PRIM_SPRITE);
            prim.Color(0, 0, 0, 0x40);
            prim.Vertex(0, 0, 0);
            prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
            prim.Color(0, 0, 0, 0x80);
            prim.Vertex(20, 60, 0);
            prim.Vertex(276, 316, 0);
            prim.End();
            SetSpriteEnv(&prim, 0);
            u8  color[4] = {0x80, 0x80, 0x80, 0x80};
            int page = (CMenuItemInfoPt->debug_item_no - 1) / 64;

            for (int row = 0; row < 8; row++) {
                int col;

                for (col = 0; col < 8; col++) {
                    int item_no = page * 64 + 1 + row * 8 + col;

                    if (item_no == CMenuItemInfoPt->debug_item_no) {
                        int x = col * 32 + 24;
                        int y = row * 32 + 60;
                        SetSpriteEnv(&prim, 2);
                        prim.Begin(MG_PRIM_SPRITE);
                        prim.Color(0x40, 0x40, 0x40, 0x94);
                        prim.Vertex(x, y, 0);
                        prim.Vertex(x + 32, y + 32, 0);
                        prim.End();
                        SetSpriteEnv(&prim, 0);
                    }

                    DrawOneItem(&prim, mgRect<float>(col * 32 + 24, row * 32 + 60, 32.0f, 32.0f), item_no, 0, NULL, color, 0);
                }
            }

            tex_manager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
            DrawMenuFillBox(20.0f, 40.0f, 340.0f, 20.0f, 0x60, 0, 0, 0);
            char title[0x80];
            sprintf(title, "[%3d]%s :Now GetNum : %d", CMenuItemInfoPt->debug_item_no,
                    GetItemMessage(CMenuItemInfoPt->debug_item_no), CMenuItemInfoPt->debug_item_count);
            font->SetStr(title);
            font->SetPos(26, 40);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);

            if (MenuDebugModelDrawFlag == 1) {
                DrawMenuFillBox(0.0f, 0.0f, mgScreenWidth, mgScreenHeight, 0x80, 0, 0, 0);
            }

            DrawMenuFillBox(20.0f, 330.0f, 500.0f, 200.0f, 0x52, 0, 0, 0);

            if (MenuDebugModelDrawFlag == 0) {
                font->SetStr("\x4D\x6F\x76\x65\x3A\x81\xAA\x81\xAB\x81\xA9\x81\xA8");
                font->SetPos(20, 350);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                font->SetStr("Num: R2:+1 L2:-1");
                font->SetPos(20, 370);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                font->SetStr("\x4E\x75\x6D\x35\x3A\x20\x81\x7E\x2B\x52\x32\x20\x6F\x72\x20\x81\x7E\x2B\x4C\x32");
                font->SetPos(20, 390);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                font->SetStr("L3:Load DataFile");
                font->SetPos(170, 370);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                char *file_name = GetItemFileName(CMenuItemInfoPt->debug_item_no, 0);

                if (file_name != NULL) {
                    char file_text[0x80];
                    sprintf(file_text, "\x81\xA1\x3A\x44\x69\x73\x70\x6C\x61\x79\x20\x4D\x6F\x64\x65\x6C\x20\x20\x25\x73", file_name);
                    font->SetStr(file_text);
                    font->SetPos(150, 330);
                    font->DrawDirect(font->str, font->pos_x, font->pos_y);
                } else {
                    font->SetStr("\x81\xA1\x3A\x43\x61\x6E\x27\x74\x20\x4C\x6F\x61\x64");
                    font->SetPos(150, 330);
                    font->DrawDirect(font->str, font->pos_x, font->pos_y);
                }

                font->SetStr("(O):Get");
                font->SetPos(20, 330);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                strcpy(text, "Item: None");

                if (debug_common_data != NULL) {
                    sprintf(text, "Limmit   : %d", debug_common_data->max_num);
                    font->SetStr(text);
                    font->SetPos(300, 350);
                    font->DrawDirect(font->str, font->pos_x, font->pos_y);
                    sprintf(text, "ModelName: %s", debug_common_data->file_name);
                    font->SetStr(text);
                    font->SetPos(300, 370);
                    font->DrawDirect(font->str, font->pos_x, font->pos_y);
                    sprintf(text, "Remain: %d", CheckGetItemRemainNum(debug_common_data->item_no));
                    font->SetStr(text);
                    font->SetPos(300, 390);
                    font->DrawDirect(font->str, font->pos_x, font->pos_y);
                }
            } else {
                font->SetStr("\x82\x77\x3A\x52\x65\x74\x75\x72\x6E");
                font->SetPos(290, 60);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                font->SetStr("\x81\xA2\x3A\x44\x65\x66\x61\x75\x6C\x74");
                font->SetPos(290, 80);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                font->SetStr("\x53\x63\x61\x6C\x65\x81\x40\x20\x20\x3A\x20\x41\x6E\x61\x6C\x6F\x67\x52");
                font->SetPos(290, 100);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                font->SetStr("Rotation : AnalogL");
                font->SetPos(290, 120);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                char size_text[0x40];
                sprintf(size_text, "BuildSize: %d K", MenuDebugSize);
                font->SetStr(size_text);
                font->SetPos(290, 140);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);

                if (debug_common_data == NULL && MenuDebugItemModel != NULL) {
                    font->SetStr("\x83\x41\x83\x43\x83\x65\x83\x80\x82\xC9\x0A\x93\x6F\x98\x5E\x82\xB3\x82\xEA\x82\xC4\x82\xA2\x82\xDC\x82\xB9\x82\xF1");
                    font->SetPos(290, 20);
                    font->DrawDirect(font->str, font->pos_x, font->pos_y);
                }
            }

            if (MenuDebugModelDrawFlag != 0) {
                if (MenuDebugCamera != NULL && MenuDebugItemModel != NULL) {
                    sceVu0FVECTOR rotation;
                    sceVu0FVECTOR scale;
                    MenuDebugItemModel->GetRotation(rotation);
                    MenuDebugItemModel->GetScale(scale);
                    sprintf(text, "SCALE %5f", scale[0]);
                    font->SetStr(text);
                    font->SetPos(290, 260);
                    font->DrawDirect(font->str, font->pos_x, font->pos_y);
                    sprintf(text, "ROTATION X:%4f\n         Y:%4f\n         Z:%4f", rotation[0], rotation[1], rotation[2]);
                    font->SetStr(text);
                    font->SetPos(290, 280);
                    font->DrawDirect(font->str, font->pos_x, font->pos_y);
                    sceVu0FVECTOR camera_pos;
                    sceVu0FMATRIX camera_matrix;
                    sceVu0FMATRIX world_matrix;
                    sceVu0FMATRIX unit_matrix;
                    MenuDebugCamera->GetCameraMatrix(camera_matrix);
                    MenuDebugCamera->GetPos(camera_pos);
                    sceVu0UnitMatrix(unit_matrix);
                    sceVu0MulMatrix(world_matrix, unit_matrix, camera_matrix);
                    tex_manager->ReloadTexture(CMenuItemInfoPt->tex_block[4], (sceVif1Packet *) NULL);
                    MenuDebugItemModel->Step();
                    MenuDebugItemModel->DrawDirect();
                } else {
                    font->SetStr("CAN'T BUILD MODEL");
                    font->SetPos(290, 260);
                    font->DrawDirect(font->str, font->pos_x, font->pos_y);
                }
            }

            break;
        }
        case 3:
            DrawMenuFillBox(236.0f, 60.0f, 230.0f, 200.0f, 0x80, 0, 0, 0);
            font->SetStr("HP control");
            font->SetPos(236, 60);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr(" Now : Press AnalogR with none");
            font->SetPos(236, 80);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr(" Max : Press AnalogR with L2");
            font->SetPos(236, 100);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr(" Money");
            font->SetPos(236, 120);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("\x20\x41\x64\x64\x20\x2B\x31\x30\x30\x30\x20\x3A\x20\x81\xA2");
            font->SetPos(236, 140);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("\x20\x44\x65\x66\x55\x70\x20\x20\x20\x20\x20\x3A\x20\x81\x9B");
            font->SetPos(236, 160);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("\x20\x44\x65\x66\x44\x6F\x77\x6E\x20\x20\x20\x3A\x20\x81\x7E");
            font->SetPos(236, 180);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            int  attribute = MenuUserDataManPtr->GetCharaStatusAttirbute(CMenuItemInfoPt->sub_view);
            char status[0x100] = "Status : ";
            int  count = 0;
            int  i;

            for (i = 0; i < 6; i++) {
                if (attribute & (1 << i)) {
                    if (count == 3) {
                        strcat(status, "\n         ");
                    }

                    strcat(status, attrtable[i]);
                    count++;
                }
            }

            font->SetStr(status);
            font->SetPos(236, 200);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            break;
        case 4: {
            DrawMenuFillBox(236.0f, 60.0f, 230.0f, 300.0f, 0x80, 0, 0, 0);
            font->SetStr("WHP control");
            font->SetPos(236, 60);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr(" Now : AnalogR with R2");
            font->SetPos(236, 80);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr(" Max : AnalogR with L2");
            font->SetPos(236, 100);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("Change Abs");
            font->SetPos(236, 120);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            int   build_item[3];
            char *build_name[3];

            if (weapon != NULL) {
                sprintf(text, "%d/%d", (int) weapon->data.weapon.abs.now, (int) weapon->data.weapon.abs.max);
                font->SetStr(text);
                font->SetPos(336, 120);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                CheckBuildUp(weapon, NULL, build_item, NULL);

                for (i = 0; i < 3; i++) {
                    build_name[i] = GetItemMessage(build_item[i]);
                }
            }

            font->SetStr(" Now : AnalogR with R1");
            font->SetPos(236, 140);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr(" Max : AnalogR with L1");
            font->SetPos(236, 160);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("\x4C\x65\x76\x65\x6C\x55\x70\x3A\x20\x81\xA2");
            font->SetPos(236, 180);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("Spectol Point");
            font->SetPos(236, 200);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("\x20\x75\x70\x20\x20\x20\x3A\x20\x81\x9B");
            font->SetPos(236, 220);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("\x20\x64\x6F\x77\x6E\x20\x3A\x20\x81\x7E");
            font->SetPos(236, 240);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("BuildUp");
            font->SetPos(236, 260);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);

            for (int i = 0; i < 3; i++) {
                sprintf(text, "%d : None ", i + 1, build_name[i]);

                if (build_name[i] != NULL) {
                    sprintf(text, "%d : %s", i + 1, build_name[i]);
                }

                font->SetStr(text);
                font->SetPos(236, i * 20 + 280);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
            }

            break;
        }
        case 5: {
            if (weapon == NULL) {
                break;
            }

            DrawMenuFillBox(236.0f, 60.0f, 230.0f, 260.0f, 0x80, 0, 0, 0);
            font->SetStr("Change Status\n  Press AnalogR");
            font->SetPos(236, 60);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("\x20\x53\x65\x74\x20\x4D\x61\x78\x20\x53\x74\x61\x74\x75\x73\x20\x20\x20\x20\x20\x3A\x20\x81\xA2");
            font->SetPos(236, 100);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("\x20\x53\x65\x74\x20\x44\x65\x66\x61\x75\x6C\x74\x20\x53\x74\x61\x74\x75\x73\x20\x3A\x20\x81\xA1");
            font->SetPos(236, 120);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            char special[0x100];
            special[0] = '\0';
            int count = 0;

            for (int i = 0; i < 12 && stchar[i] != NULL; i++) {
                if (weapon->data.weapon.special & (1 << i)) {
                    strcat(special, stchar[i]);
                    count++;

                    if (count % 4 == 3) {
                        strcat(special, "\n");
                    }
                }
            }

            font->SetStr(" Set Special : R1");
            font->SetPos(236, 140);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr(special);
            font->SetPos(236, 160);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            break;
        }
        case 6:
            DrawMenuFillBox(236.0f, 60.0f, 230.0f, 260.0f, 0x80, 0, 0, 0);
            font->SetStr("Change Abs");
            font->SetPos(236, 80);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("\x20\x75\x70\x20\x20\x2B\x31\x20\x3A\x20\x81\x9B");
            font->SetPos(236, 100);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("\x20\x64\x6F\x77\x6E\x2D\x31\x20\x3A\x20\x82\x77");
            font->SetPos(236, 120);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            font->SetStr("\x56\x6F\x69\x63\x65\x20\x55\x6E\x69\x74\x20\x4F\x6E\x4F\x66\x66\x20\x3A\x20\x81\xA2");
            font->SetPos(236, 140);
            font->DrawDirect(font->str, font->pos_x, font->pos_y);
            break;
        case 7: {
            DrawMenuFillBox(236.0f, 60.0f, 230.0f, 260.0f, 0x80, 0, 0, 0);
            int cursor = MenuCommonInfo->cursor;

            if (cursor == 0) {
                font->SetStr("\x20\x43\x68\x61\x6E\x67\x65\x20\x28\x83\x6F\x83\x62\x83\x4F\x83\x70\x83\x62\x83\x4E\x29");
                font->SetPos(236, 60);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                font->SetStr("\x20\x4E\x6F\x77\x20\x3A\x20\x83\x41\x83\x69\x83\x8D\x83\x4F\x82\x71\x8D\xB6\x89\x45");
                font->SetPos(236, 80);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
            }

            if (cursor == 1) {
                font->SetStr("\x20\x43\x68\x61\x6E\x67\x65\x20\x57\x48\x70\x20\x28\x83\x41\x81\x5B\x83\x80\x29");
                font->SetPos(236, 60);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
                font->SetStr("\x20\x4E\x6F\x77\x20\x3A\x20\x83\x41\x83\x69\x83\x8D\x83\x4F\x82\x71\x8D\xB6\x89\x45");
                font->SetPos(236, 80);
                font->DrawDirect(font->str, font->pos_x, font->pos_y);
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

int CMenuItemInfo::PushKey(int pad, int trigger) {
    /**
     *
     * Temporary command parameters saved while handling item-menu input.
     *
     */
    static void *Save_AskParamInfo;

    int               leaving = 0;
    CHARA_DATA       *chara;
    short             held_item_no;
    int               area;
    int               command;
    CGameDataUsed    *target;
    CGameDataUsed    *held_item;
    int               cursor;
    int               item_type;
    int               fusion_target;
    CMenuPosDataForm *message_form;

    MENU_SWAPITEM_INFO swap;
    int                equip_slot;
    int                robo_equip_slot;

    if (MenuCommonInfo->key_enable == 0) {
        return 0;
    }

    short state = this->mode;

    switch (state) {
        case kStateBrowse: {
            held_item_no = MenuCommonInfo->have_item.item_no;
            cursor = MenuCommonInfo->select_pos[0];
            command = kCmdNone;
            target = NULL;
            area = -1;
            chara = MenuUserParam.chara[this->sub_view];
            item_type = ConvertUsedItemType(GetItemDataType(held_item_no));
            fusion_target = 0;

            if (pad != 0 || trigger != 0) {
                if (MenuSpectolSatusCheckForm != NULL && this->status_check_ready != 0) {
                    MenuSpectolSatusCheckForm->SetAction("\x8A\x4F\x82\xD6");
                    this->status_check_ready = 0;
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
                    target = &MenuUserParam.robo->parts[robo_slot];
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
            held_item = (CGameDataUsed *) (&MenuCommonInfo->have_item);
            this->SaveViewWeaponStatus();

            switch (command) {
                case kCmdDenied:
                    MenuSePlay(5);
                    break;
                case kCmdOpenCommandMenu:
                    if (MenuItemMoveItemCommand(target, area, 5, MenuMesForm[5],
                                                GetActiveCharaIDForItemCmd()) != 0) {
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
                                            MenuLoadInfo.request_phase =
                                                ConvertCharaLoadDataPhase(this->sub_view, cursor);
                                            MenuLoadInfo.load_phase = MenuLoadInfo.request_phase;
                                            MenuLoadInfo.load_all = 0;
                                            this->ModelReadStart(this->view_mode, 1, 1);
                                            break;
                                        case kAreaRobo:
                                            this->CheckLoadInfo(2);
                                            MenuLoadInfo.request_phase = ConvertCharaLoadDataPhase(
                                                2, MenuRoboEquipTable[cursor]);
                                            MenuLoadInfo.load_all = 0;
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
                                    item_used = MenuItemUse.UseItem(held_item, ITEM_USE_TARGET_ITEM, target);
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
                        MenuCommonInfo->have_item.item_no <= 0) {
                        MenuCommonInfo->GetItemAll(target, &swap);
                        this->CheckViewWeaponStatus(0);
                    }

                    break;
                case kCmdSortBag: {
                    int           found = 0;
                    CGameDataUsed saved_item;
                    short         view_mode = this->view_mode;

                    if ((view_mode == MENU_ITEM_VIEW_WEAPON || view_mode == MENU_ITEM_VIEW_FISHING_ROD) &&
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
                                MenuLoadInfo.request_phase =
                                    ConvertCharaLoadDataPhase(this->sub_view, equip_slot);
                                MenuLoadInfo.load_phase = MenuLoadInfo.request_phase;
                                MenuLoadInfo.load_all = 0;
                                this->ModelReadStart(this->view_mode, 1, 1);
                            }

                            break;
                        }
                        default: {
                            CHARA_DATA *chr = MenuUserParam.chara[this->sub_view];

                            if (held_item_no == (int) ITEM_ID_MELEE_REPAIR) {
                                if (MenuItemUse.UseItem(held_item, ITEM_USE_TARGET_ITEM, &chr->equip[0]) == 0 &&
                                    MenuItemUse.UseItem(held_item, ITEM_USE_TARGET_ITEM, &chr->equip[1]) == 0) {
                                    MenuSePlay(5);
                                }
                            } else if (MenuItemUse.CheckItemUseEnable(held_item, 0, chr) != 0) {
                                item_used = MenuItemUse.UseItem(held_item, ITEM_USE_TARGET_CHARA, chr);

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
                        item_used = MenuItemUse.UseItem(held_item, ITEM_USE_TARGET_ITEM, this->view_weapon);
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
                                MenuLoadInfo.request_phase =
                                    ConvertCharaLoadDataPhase(this->load_item_no, robo_equip_slot);
                                MenuLoadInfo.load_all = 0;
                                this->ModelReadStart(this->view_mode, 1, 1);
                            }

                            break;
                        }
                        default:
                            item_used = MenuItemUse.UseItem(held_item, ITEM_USE_TARGET_ROBO, MenuUserParam.robo);

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
                    item_used = MenuItemUse.UseItem(held_item, ITEM_USE_TARGET_MONSTER, MenuUserParam.monster);
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

                                char *item_name[1] = {NULL};
                                item_name[0] = GetItemMessage(over_item_no);
                                CDataCommon *data = GetCommonItemData(over_item_no);
                                msg->SetMsgItemNo(item_name, 1);
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
                    MenuSpectolSatusCheckForm->SetAction("\x8A\x4F\x82\xD6");
                    this->status_check_ready = 0;
                }

                if (CheckTrushMenu() != 0 && ItemOverFlowCheckFlag == 1) {
                    MenuCommonInfo->open_type -= 0x10;
                }

                StartReadBG();
                this->chara_reload = 0;

                if (0 <= this->equipped_model_no) {
                    int          chara_no;
                    CHARA_DATA **chr_ptr =
                        &MenuUserParam.chara[chara_no = this->GetActiveCharaNo()];
                    int model_no = (*chr_ptr)->equip[0].GetModelNo();

                    if (this->equipped_model_no != model_no) {
                        char path[0x40];
                        char full_path[0x60];
                        int  file_size;
                        SetMenuEtcFlag(1);
                        MainCharaReadStackReadAdr =
                            (u8 *) MainCharaReadStack.stGetTop();
                        GetMainCharaModelName(chara_no, path, 0);
                        MainCharaReadBuffer.model = (u_int *) MainCharaReadStackReadAdr;
                        sprintf(full_path, "mainchr/%s", path);
                        LoadFileBG(full_path, (u_long128 *) MainCharaReadBuffer.model, &file_size);
                        unsigned int blocks = QuadwordsFor(file_size);
                        MainCharaReadStack.Alloc(blocks);
                        MainCharaReadStack.Align64();
                        MainCharaReadBuffer.skin =
                            (u_int *) MainCharaReadStack.stGetTop();

                        char *file = (*chr_ptr)->equip[4].GetDataPath();

                        if (file != NULL) {
                            LoadFileBG(file, (u_long128 *) MainCharaReadBuffer.skin, &file_size);
                            blocks = QuadwordsFor(file_size);
                            MainCharaReadStack.Alloc(blocks);
                        }

                        MainCharaReadStack.Align64();
                        MainCharaReadBuffer.outline =
                            (u_int *) MainCharaReadStack.stGetTop();
                        file = (*chr_ptr)->equip[3].GetDataPath();

                        if (file != NULL) {
                            LoadFileBG(file, (u_long128 *) MainCharaReadBuffer.outline, &file_size);
                            blocks = QuadwordsFor(file_size);
                            MainCharaReadStack.Alloc(blocks);
                        }

                        this->chara_reload = 1;
                    }
                }

                InitFishBoiledEffect(NULL, NULL);
                this->CheckSoundLoad();

                if (CheckTrushMenu() != 0) {
                    this->FadeOutMenu(0x28, 0.0f);
                } else {
                    this->ExeScript("\x91\x4F\x8F\x49\x97\xB9\x8F\x88\x97\x9D");
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
                    WEAPON_USED   *saved_weapon = &SpectolInfoStay.data.weapon;
                    WEAPON_USED   *weapon = &item->data.weapon;
                    int            spare_points = weapon->fusion_point / kPointsPerStep;
                    int            selected = MenuCommonInfo->select_pos[0];
                    short          value = weapon->attribute[selected];

                    if (0 < value - saved_weapon->attribute[selected]) {
                        if (0 < value) {
                            if (pad & kPadLeft) {
                                weapon->attribute[selected] = value - 1;
                                weapon->fusion_point += kPointsPerStep;
                                MenuSePlay(0);
                            }
                        }
                    }

                    if (0 < spare_points) {
                        if (weapon->attribute[MenuCommonInfo->select_pos[0]] < kStatMax &&
                            (pad & kPadRight)) {
                            weapon->fusion_point -= kPointsPerStep;
                            weapon->attribute[MenuCommonInfo->select_pos[0]] += 1;

                            if (weapon->fusion_point < 0) {
                                weapon->fusion_point = 0;
                            }

                            MenuSePlay(0);
                        }
                    }

                    if (trigger & 1) {
                        int changed = 0;
                        int i = 0;

                        do {
                            if (saved_weapon->attribute[i] < weapon->attribute[i]) {
                                changed = 1;
                            }

                            i += 1;
                        } while (i < 5);

                        if (changed != 0) {
                            this->step = kTuneConfirmSave;
                            this->ExeScript("FPOK");
                            MenuSePlay(1);
                        } else {
                            MenuSePlay(5);
                        }
                    } else if (trigger & 2) {
                        this->step = kTuneConfirmDiscard;
                        this->ExeScript("FPCANCEL");
                    }

                    break;
                }
                case kTuneConfirmSave: {
                    int answer = MenuDCMsg[7]->YesNoCursor2(0);

                    if (answer == 1) {
                        MenuSePlay(0x1E);
                        this->viewing_weapon = 0;
                        this->mode = kStateBrowse;
                        this->ExeScript("RET_FPMODE");
                    }

                    if (answer == 2) {
                        this->step = kTuneAdjust;
                        this->ExeScript("RET_FPMODE");
                        MenuSePlay(5);
                    }

                    break;
                }
                case kTuneConfirmDiscard: {
                    int answer = MenuDCMsg[7]->YesNoCursor2(0);

                    if (answer == 1) {
                        this->view_weapon->CopyGameData(&SpectolInfoStay);
                        this->viewing_weapon = 0;
                        this->mode = kStateBrowse;
                        this->step = kTuneAdjust;
                        this->ExeScript("RET_FPMODE");
                        MenuSePlay(1);
                    }

                    if (answer == 2) {
                        this->step = kTuneAdjust;
                        this->ExeScript("RET_FPMODE");
                        MenuSePlay(5);
                    }

                    break;
                }
            }

            break;
        }
        default: {
            mgCMemory *load_stack = &MenuCharaLoadStack;
            int        extend_result = this->ExtendCommand(pad, trigger);

            switch (this->mode) {
                case kStateSpectolBreak:
                    if (extend_result == 2) {
                        SetEffectSpectolBreak(load_stack, MenuEffect[0], (this->ask_para.item)->item_no);
                        MenuCommonInfo->FadeOutMenuBGMVol(-6, 0x18);
                        MenuSePlay(0, MenuItemSpectolTransSoundBuffer, load_stack);
                        Save_AskParamInfo = (void *) this->ask_para.item;
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

                        MenuCommonInfo->top_line = MenuItem_ItemBoardTopLine;
                        MenuItem_ItemBoardTopSelect = index;
                        MenuCommonInfo->select_pos[0] = (short) index;
                    }

                    break;
                case kStateSpectolFusion:
                    /**
                     *
                     * Blink counter of the raised fusion parameters.
                     *
                     */
                    static s8 fusion_blinkcnt = 0;

                    fusion_blinkcnt += 1;

                    if (fusion_blinkcnt >= kBlinkPeriod) {
                        fusion_blinkcnt = 0;
                    }

                    /**
                     *
                     * Non-zero while a different weapon's fusion preview is shown.
                     *
                     */
                    static s8 diffent_weapon_dispflag = 0;

                    if (extend_result == 2) {
                        diffent_weapon_dispflag = 0;
                        SetEffectSpectolFusion(load_stack, MenuEffect, SpectolInfo[0],
                                               this->key_arg_no == (int) ITEM_MENU_PANEL_WEAPON);
                        int top_line = MenuItem_ItemBoardTopLine;

                        if (trans_spectol_pos < top_line || top_line + 5 < trans_spectol_pos) {
                            MenuEffect[1]->SetTexInfo(NULL, NULL);
                        }

                        if (this->key_arg_no == (int) ITEM_MENU_PANEL_WEAPON) {
                            MenuEffect[1]->SetTexInfo(NULL, NULL);
                        }

                        load_stack->Alloc(0x100);
                        MenuCommonInfo->FadeOutMenuBGMVol(-6, 0x18);
                        StartReadBG();
                        int fusion_file_size;
                        LoadFileBG("snd2/sp/SP_005.snd", load_stack->stGetTop(), &fusion_file_size);
                        unsigned int blocks = QuadwordsFor(fusion_file_size);
                        load_stack->Alloc(blocks);
                        SpectolFusionTargetChara = NULL;
                        SpectolFusion_LeftOrRight = 0;

                        if (this->view_mode == MENU_ITEM_VIEW_WEAPON) {
                            SpectolFusionTargetChara = MenuActionChara[0];

                            if (this->view_weapon != SpectolInfo[0]) {
                                diffent_weapon_dispflag = 1;
                            }
                        }

                        int weapon_kind = SpectolInfo[0]->item_type;

                        if (this->key_arg_no == (int) ITEM_MENU_PANEL_EQUIPMENT) {
                            if (weapon_kind == 2 || weapon_kind == 4) {
                                SpectolFusion_LeftOrRight = 1;
                            }
                        }
                    }

                    if (extend_result == 3) {
                        if (this->view_mode == MENU_ITEM_VIEW_WEAPON) {
                            CActionChara *chara = NULL;

                            if (0 < this->view_weapon->IsBuildUp(NULL, NULL, NULL)) {
                                chara = MenuActionChara[0];
                            }

                            SetBuildUpInfoChara((CCharacter2 *) chara, ActiveMenuWeaponCharaRange);
                        }

                        if (this->view_mode != MENU_ITEM_VIEW_WEAPON || diffent_weapon_dispflag == 1) {
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
                        int                 i;
                        int                 blink_on;
                        MENUFORMPARTS_TYPE *volume_part;
                        blink_on = 1;

                        if (fusion_blinkcnt > kBlinkLastOn) {
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
                    if (extend_result == 2 && this->view_mode == MENU_ITEM_VIEW_WEAPON) {
                        if (this->view_weapon == this->ask_para.item && (this->ask_para.item)->item_no <= 0) {
                            this->ReturnActiveCharaViewMode(0);
                        }
                    }

                    break;
            }

            if (state == kStateSpectolFusion) {
                if (extend_result != 0 && MenuSpectolSatusCheckForm != NULL) {
                    MenuSpectolSatusCheckForm->SetAction("\x8A\x4F\x82\xD6");
                }
            }

            if (state == kStateSpectolBreak && extend_result != 0) {
                if (MenuSpectolSatusCheckForm != NULL) {
                    MenuSpectolSatusCheckForm->SetAction("\x8A\x4F\x82\xD6");
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
                    if (extend_result == 4 && this->view_mode == MENU_ITEM_VIEW_WEAPON &&
                        (void *) this->view_weapon == Save_AskParamInfo) {
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

/**
 *
 * Assigns an item's number to a visible information form part.
 *
 */
void local_item_infoview_set(MENUFORMPARTS_TYPE *part, CGameDataUsed *item) {
    if (part != NULL) {
        part->etc_info[0] = 0;
        part->etc_info[1] = item->item_no;
        part->draw_flag = 1;
    }
}

/**
 *
 * Updates a character's equipped weapon indicators and warning colors.
 *
 */
void MenuItemCharaActWepInfoDraw(CMenuPosDataForm *form, CGameDataUsed *equip, int chara_no, int flag) {
    /**
     *
     * Durability and warning-mark parts for each active weapon.
     *
     */
    static char *whptbl[3][2] = {
        {"whp00", "whp01"},
        {"whp10", "whp11"},
        {"batu0", "batu1"}
    };

    CGameDataUsed      *weapon;
    MENUFORMPARTS_TYPE *icon;
    int                 blink;
    MENUFORMPARTS_TYPE *bar;
    int                 is_rod;
    MENUFORMPARTS_TYPE *part;
    bool                show;
    int                 base;
    int                 item_no;
    int                 green;
    CItemUseTarget      target;
    blink = (int) (64.0f * sinf(WeaponWarningCounter));
    base = 4;

    for (int i = 0; i < 2; i++, base += 6) {
        int red = 0x80;
        weapon = &equip[i];
        MENUFORMPARTS_TYPE *batu = CMenuItemInfoPt->wep_parts[chara_no][base + 5];
        green = 0x80;

        if (batu != NULL) {
            batu->draw_flag = 0;
        }

        item_no = weapon->item_no;
        int   whp[2];
        float rate = weapon->GetWHp(whp);

        if (rate < 0.2f && item_no > 0) {
            red = 0x80 - blink;
            green = red;

            if (rate == 0.0f) {
                red = blink + 0x80;

                if (batu != NULL) {
                    batu->draw_flag = 1;
                }
            } else {
                green = red;
            }
        }

        for (int k = 0; k < 6; k++) {
            part = CMenuItemInfoPt->wep_parts[chara_no][base + k];
            part->rgba[0] = red;
            part->rgba[1] = green;
            part->rgba[2] = green;
        }

        icon = CMenuItemInfoPt->wep_parts[chara_no][base + 4];
        local_item_infoview_set(icon, weapon);
        target.SetPtr(ITEM_USE_TARGET_ITEM, weapon);
        icon->item_flag = 0;
        icon->item_flag = CheckItemUseVariable(&MenuCommonInfo->have_item, &target);
        WEAPON_USED *data = &weapon->data.weapon;
        form->SetNumber(whptbl[i][0], whp[0]);
        form->SetNumber(whptbl[i][1], whp[1]);
        char name[0x20];
        sprintf(name, "whp%d", i);
        bar = form->GetPartInfo(name);

        if (bar != NULL) {
            bar->w = (int) (95.0f * rate);
        }

        sprintf(name, "abs%d", i);
        bar = form->GetPartInfo(name);

        if (bar != NULL) {
            bar->w = (int) (95.0f * GetCommonGageRate(&data->abs));
        }
    }

    if (chara_no == 0) {
        is_rod = equip->IsFishingRod();
        CGameDataUsed *esa = MenuUserDataManPtr->GetActiveEsa();
        int            esa_num = 0;

        if (is_rod) {
            MENUFORMPARTS_TYPE *esa_part = form->GetPartInfo("esa0");

            if (esa_part != NULL) {
                esa_part->etc_info[1] = esa->item_no;
            }

            esa_num = esa->GetNum();
        }

        show = is_rod != 0;
        form->SetPartDrawFlag("\x83\x47\x83\x54\x94\xC2", is_rod != 0);
        form->SetPartDrawFlag("esa0", show);
        form->SetPartDrawFlag("\x83\x47\x83\x54", show);
        form->SetPartDrawFlag("\x83\x8B\x83\x41\x81\x5B", show);
        form->SetNumber("esanum", esa_num);

        if (is_rod && MenuUserDataManPtr->GetFishingRodNo() == (int) ITEM_ID_FISHING_ROD) {
            form->SetPartDrawFlag("\x83\x8B\x83\x41\x81\x5B", false);
        }
    }
}

/**
 *
 * Updates a character's visible health and equipment preview forms.
 *
 */
void MenuItemCharaViewCheck(CHARA_DATA *chara, int chara_no, int flag) {
    CMenuPosDataForm *form = CMenuItemInfoPt->view_form[chara_no];

    if (form->draw_flag != 0 && form->rgba[3] > 0) {
        int                 blink = (int) (64.0f * sinf(WeaponWarningCounter));
        float               hp_rate = GetCommonGageRate(&chara->hp);
        MENUFORMPARTS_TYPE *hp_bar = CMenuItemInfoPt->hp_bar[chara_no];

        if (hp_bar != NULL) {
            hp_bar->w = (int) (168.0f * hp_rate);

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

        form->SetNumber("hp0", GetDispVolumeForFloat(chara->hp.now));
        form->SetNumber("hp1", (int) chara->hp.max);

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

        form->SetNumber("DEF", MenuUserDataManPtr->GetDefenceVol(chara_no));
        MenuItemCharaActWepInfoDraw(form, chara->equip, chara_no, flag);
    }
}

/**
 *
 * Updates the ridepod status form's health, capacity, defence and part warning colours.
 *
 * @mangled MenuPosFormValueSetCharaRobo__FP9ROBO_DATAi
 * @address 0x24CB20
 * @size 0x498
 */
static void MenuPosFormValueSetCharaRobo(ROBO_DATA *robo, int flag) {
    float               sway;
    MENUFORMPARTS_TYPE *hp_part;
    float               rate;
    MENUFORMPARTS_TYPE *batu;
    int                 green;
    CGameDataUsed      *parts;
    MENUFORMPARTS_TYPE *whp_bar;
    int                 capacity;

    if (robo == NULL) {
        return;
    }

    CMenuPosDataForm *form = CMenuItemInfoPt->view_form[3];

    if (form == NULL) {
        return;
    }

    int red = 0x80;
    green = red;
    int blink = (int) (64.0f * sinf(WeaponWarningCounter));
    parts = robo->parts;
    COMMON_GAGE *hp = &robo->hp;
    hp_part = form->GetPartInfo("hp_bar");

    if (hp_part != NULL) {
        hp_part->w = (int) (140.0f * GetCommonGageRate(hp));
    }

    MENUFORMPARTS_TYPE *hp_end = form->GetPartInfo("needle");

    if (hp_end != NULL && hp_part != NULL) {
        hp_end->x = hp_part->x + hp_part->w - 4.0f;
        hp_end->y = hp_part->y - 10.0f;
    }

    form->SetNumber("hp0", GetDispVolumeForFloat(hp->now));
    form->SetNumber("hp1", (int) hp->max);
    capacity = 0;
    form->SetNumber("capuse", CheckNowRoboUseCapacity(&capacity));
    form->SetNumber("capmax", capacity);
    int part_defence = MenuUserParam.robo->parts[1].data.robopart.defence;
    int defence = MenuUserParam.robo->GetDefenceVol();
    form->SetNumber("shkitm", GetShiledKitLimmit(MenuUserDataManPtr->CheckRobotCore()) * 4);
    form->SetNumber("shkitn", defence - part_defence);
    form->SetNumber("DEF", part_defence);
    local_item_infoview_set(form->GetPartInfo("wep0"), parts);
    int whp[2];
    rate = parts->GetWHp(whp);

    if (rate < 0.2f) {
        green = red = 0x80 - blink;

        if (rate == 0.0f) {
            red = blink + 0x80;
        }
    }

    for (int i = 0; i < 6; i++) {
        MENUFORMPARTS_TYPE *part = CMenuItemInfoPt->robo_parts[i];
        part->rgba[0] = red;
        part->rgba[1] = green;
        part->rgba[2] = green;
    }

    form->SetNumber("whp00", whp[0]);
    form->SetNumber("whp01", whp[1]);
    whp_bar = form->GetPartInfo("whp_bar");

    if (whp_bar != NULL) {
        whp_bar->w = (int) (108.0f * rate);
    }

    batu = form->GetPartInfo("batu0");

    if (batu != NULL) {
        batu->draw_flag = 0;

        if (rate == 0.0f) {
            batu->draw_flag = 1;
        }
    }

    local_item_infoview_set(form->GetPartInfo("wep2"), &parts[2]);

    if (CMenuItemInfoPt->voice_part != NULL) {
        /**
         *
         * Pulse phase of the character voice indicator.
         *
         */
        static float counter = 0.0f;
        counter += 1.0f;

        if (!(counter <= 44.0f)) {
            counter = 0.0f;
        }

        CMenuItemInfoPt->voice_part->draw_flag = robo->voice_unit != 0;
        CMenuItemInfoPt->voice_part->x = 150.0f;
        CMenuItemInfoPt->voice_part->y = -252.0f;

        if (robo->voice_flag != 0) {
            sway = 8.0f * sinf(0.06981317f * counter);
            CMenuItemInfoPt->voice_part->x += sway;
            CMenuItemInfoPt->voice_part->y -= sway;
        }
    }

    form->SetNumber("corep", GetDispVolumeForFloat(robo->abs.now));
}

/**
 *
 * Updates monster transformation status and health on its menu form.
 *
 */
void MenuPosFormValueSetMonster(MOS_CHANGE_PARAM *monster, CHARA_DATA *chara) {
    CMenuPosDataForm *form = CMenuItemInfoPt->view_form[4];

    if (form == NULL || monster == NULL || chara == NULL) {
        return;
    }

    MENUFORMPARTS_TYPE *part;
    MOS_CHANGE_PARAM   *mos = &monster[get_gajji_id_from_monster_progress_table(CMenuItemInfoPt->mos_id, NULL)];
    part = form->GetPartInfo("hp_bar");

    if (part != NULL) {
        part->w = (int) (168.0f * GetCommonGageRate(&chara->hp));
    }

    form->SetNumber("hp0", GetDispVolumeForFloat(chara->hp.now));
    form->SetNumber("hp1", (int) chara->hp.max);
    form->SetNumber("at", mos->GetAttackVol(-1));
    form->SetNumber("def", mos->GetDefenceVol(-1));
    part = form->GetPartInfo("whp_bar");

    if (part != NULL) {
        part->w = (int) (140.0f * GetCommonGageRate(&mos->hp));
    }

    form->SetNumber("whp0", GetDispVolumeForFloat(mos->hp.now));
    form->SetNumber("whp1", (int) mos->hp.max);
    part = form->GetPartInfo("abs");

    if (part != NULL) {
        part->w = (int) (140.0f * mos->abs.GetRate());
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
    weapon->status[WEAPON_STAT_ATTACK] += 0.1f * data->status[WEAPON_STAT_ATTACK];

    for (int i = 0; i < 8; i++) {
        weapon->attribute[i] += 0.1f * data->attribute[i];
    }

    weapon->special = CheckWeaponAttribute(weapon->special, data->special);
    item->CheckParamLimmit();
    GetSaveData()->SetBitFlag(0x31, 1);
    return 1;
}

/**
 *
 * Draws the three texture sections of a weapon name board.
 *
 */
void BuildUpWeaponNameBoardDraw(mgCDrawPrim *prim, float x, float y, int width) {
    mgRect<int> left_rect(0xAC, 0x76, 8, 0x20);
    mgRect<int> middle_rect(0xB4, 0x76, 4, 0x20);
    mgRect<int> right_rect(0xB8, 0x76, 8, 0x20);
    PrimQuad(prim, x, y, left_rect);
    mgRect<int> put_rect(x + 8.0f, y, width - 16, 0x20);
    PrimQuad(prim, put_rect, middle_rect);
    PrimQuad(prim, x + width - 8.0f, y, right_rect);
}

void MenuWeaponBuildUpDraw(int &tex_block) {
    /**
     *
     * Enemy requirement messages for each menu language.
     *
     */
    static char *strtbl[7] = {" ", "Defeat these enemies.", "Tu dois tuer les\nennemis ci-avant.", "T[UNI00f6]te obige Gegner.", "Devi uccidere questi nemici.", "Mata a estos enemigos.", "Defeat these enemies."};

    /**
     *
     * Horizontal repeat count of each build-up board tile column.
     *
     */
    static s8 backboard_x_repeat_drawnum[5] = {1, 7, 1, 7, 1};

    /**
     *
     * Horizontal texture coordinates of the build-up board tiles.
     *
     */
    static s16 backboard_table_x[5] = {150, 176, 204, 238, 266};

    /**
     *
     * Horizontal tile repeats of the monster build-up board.
     *
     */
    static s16 mos_repeat_table_x[5] = {1, 3, 1, 3, 1};

    /**
     *
     * Vertical repeat count of each build-up board tile row.
     *
     */
    static s8 backboard_y_repeat_drawnum[3] = {1, 5, 1};

    /**
     *
     * Vertical texture coordinates of the build-up board tiles.
     *
     */
    static u8 backboard_table_y[3] = {150, 178, 206};

    /**
     *
     * Widths of the build-up board tiles.
     *
     */
    static s8 backboard_table_w[5] = {26, 28, 34, 28, 26};

    if (BuildUpWeaponInfo.mode == 0) {
        return;
    }

    CDC2Mes *mes = MenuDCMsg[6];
    int      top_y = 30;

    if (BuildUpWeaponInfo.monster_mode == 0) {
    } else if (BuildUpWeaponInfo.monster_mode == 1) {
        top_y = 80;
    }

    if (MenuDCMsg[6] == NULL) {
        return;
    }

    MenuReloadTexture(tex_block, Tex_BuildUpBoard->block);
    mgRect<int>  unused_rect(0x96, 0x82, 0x16, 0x14);
    mgRect<int>  line_left_rect(0x9A, 0x7C, 4, 6);
    mgRect<int>  line_middle_rect(0x9E, 0x7C, 4, 6);
    mgRect<int>  line_right_rect(0xA2, 0x7C, 4, 6);
    mgRect<int>  bar_top_rect(0xA6, 0x76, 6, 4);
    mgRect<int>  bar_middle_rect(0xA6, 0x7A, 6, 4);
    mgRect<int>  bar_bottom_rect(0xA6, 0x7E, 6, 4);
    int          y = top_y;
    int          height = 0;
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, 0);
    prim->Begin(6);
    prim->Texture(Tex_BuildUpBoard);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    int row;
    int col;

    for (row = 0; row < 3; row++) {
        for (int n = 0; n < backboard_y_repeat_drawnum[row]; n++) {
            int k;
            int x = 20;

            for (col = 0; col < 5; col++) {
                mgRect<int> tile(backboard_table_x[col], backboard_table_y[row],
                                 backboard_table_w[col], 28);

                for (k = 0; k < backboard_x_repeat_drawnum[col]; k++) {
                    PrimQuad(prim, x, y, tile);
                    x += tile.right;
                }
            }

            y += 28;
            height += 28;
        }
    }

    prim->End();
    int center_y = top_y + ((height - 28) >> 1);
    int name_x = 0x3A;
    int name_w = 0xAC;
    int list_x = 0x124;
    int list_y[3] = {0};
    int msg_x = 0x46;
    int list_msg_x = 0x130;

    if (LanguageCode > 0) {
        list_x = 0x11A;
        name_x = 0x32;
        name_w = 0xBE;
        msg_x = 0x3A;
        list_msg_x = 0x122;
    }

    int   num = BuildUpWeaponInfo.select_num;
    int   list_name_x = list_x - 20;
    int   step = (height - 40) / num;
    float center = 0.5f * (num - 1.0f);
    int   i;

    for (i = 0; i < BuildUpWeaponInfo.select_num; i++) {
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

    if (BuildUpWeaponInfo.monster_mode == 0) {
        float       title_y = top_y + 38;
        mgRect<int> title_rect(0xBE, 0x24, 0x6C, 0x1A);

        if (LanguageCode > 0) {
            title_rect.left = 0xC8;
        }

        PrimQuad(prim, 48.0f, title_y, title_rect);
    }

    if (BuildUpWeaponInfo.monster_mode == 1) {
        float       title_y = top_y + 38;
        mgRect<int> title_rect(0xBE, 0x40, 0x6C, 0x1A);

        if (LanguageCode > 0) {
            title_rect.left = 0xC8;
        }

        PrimQuad(prim, 48.0f, title_y, title_rect);
    }

    BuildUpWeaponNameBoardDraw(prim, name_x, name_y, name_w);

    for (i = 0; i < BuildUpWeaponInfo.select_num; i++) {
        BuildUpWeaponNameBoardDraw(prim, list_x, list_y[i], name_w);
    }

    prim->End();
    mes->SetMovePosGyou(0, 0x208, 0);
    mes->SetMovePosGyou(1, msg_x, name_y + 5);

    for (int k = 0; k < 3; k++) {
        BuildUpNameXY[k][0] = list_name_x;
        BuildUpNameXY[k][1] = list_y[k] + 5;
        MenuDCMsg[6]->SetMovePosGyou(k + 2, list_msg_x, BuildUpNameXY[k][1]);
    }

    prim->Begin(6);
    prim->Texture(Tex_BuildUpBoard);
    prim->Color(0x80, 0x80, 0x80, 0x80);

    for (i = 0; i < BuildUpWeaponInfo.select_num; i++) {
        int line_y = list_y[i] + 12;
        PrimQuad(prim, 258.0f, line_y, line_left_rect);
        PrimQuad(prim, mgRect<int>(0x106, line_y, list_x - 0x104, 6), line_middle_rect);
        PrimQuad(prim, list_x, line_y, line_right_rect);
    }

    if (0 < BuildUpWeaponInfo.select_num) {
        PrimQuad(prim, 256.0f, bar_y, bar_top_rect);
        PrimQuad(prim, mgRect<int>(0x100, bar_y + 4, 6, bar_h - 4), bar_middle_rect);
        PrimQuad(prim, 256.0f, bar_y + bar_h, bar_bottom_rect);
    }

    int line_y = name_y + 12;
    int line_x = name_x + name_w;
    PrimQuad(prim, line_x, line_y, line_left_rect);
    PrimQuad(prim, mgRect<int>(line_x + 4, line_y, 0x100 - line_x, 6), line_middle_rect);
    PrimQuad(prim, 256.0f, line_y, line_right_rect);
    prim->End();

    if (BuildUpWeaponInfo.monster_mode == 0) {
        CDataWeapon *data;
        int          mos_y;
        int          mos_name_x;
        int          mark_x;
        data = BuildUpWeaponInfo.weapon_data[BuildUpWeaponInfo.select_no];
        char *mos_names[3] = {NULL};
        mos_name_x = 0x11E;
        mark_x = 0x10A;
        mos_y = mgScreenHeight - 180;
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
                    int k;
                    int x = 232;

                    for (col = 0; col < 5; col++) {
                        mgRect<int> tile(backboard_table_x[col], backboard_table_y[row],
                                         backboard_table_w[col], 28);

                        for (k = 0; k < mos_repeat_table_x[col]; k++) {
                            PrimQuad(prim, x, board_y, tile);
                            x += tile.right;
                        }
                    }

                    board_y += 28;
                    height += 28;
                }
            }

            int mark_y = mos_y;

            for (int i = 0; i < 3; i++) {
                mos_names[i] = GetMonsterName(data->buildup_monster[i]);

                if (mos_names[i] != NULL) {
                    BuildUpWeaponNameBoardDraw(prim, mos_name_x, mark_y, name_w);
                    int mark_u = 0x15A;

                    if (0 < KillMonsterCount(data->buildup_monster[i], 0)) {
                        mark_u = 0x16A;
                    }

                    PrimQuad(prim, mark_x, mark_y + 7, mgRect<int>(mark_u, 0xD0, 16, 16));
                }

                mark_y += 32;
            }

            prim->End();
        }

        MenuReloadTexture(tex_block, mes->texture_block);
        mes->DrawMsg();

        if (mos_names[0] != NULL) {
            int       text_y = mos_y + 4;
            CMenuFont font;

            for (int i = 0; i < 3; i++) {
                if (mos_names[i] != NULL) {
                    font.SetStr(mos_names[i]);
                    font.SetPos(text_x, text_y);
                    font.DrawDirect(font.str, font.pos_x, font.pos_y);
                }

                text_y += 32;
            }

            int note_x = 0x100;
            int note_y = mos_y + 100;

            if (LanguageCode == 1) {
                note_x += 0x12;
            } else if (CheckNowEurope()) {
                font.SetStr(strtbl[LanguageCode]);
                int h;
                int w;
                font.CalcDrawWH(font.str, &w, &h);
                note_x = 0x167 - w / 2;
            }

            font.SetStr(strtbl[LanguageCode]);
            font.SetPos(note_x, note_y);
            font.DrawDirect(font.str, font.pos_x, font.pos_y);
        }
    }

    if (BuildUpWeaponInfo.monster_mode == 1) {
        MenuReloadTexture(tex_block, mes->texture_block);
        mes->DrawMsg();
    }
}

/**
 *
 * Updates the weapon upgrade status form for a selected weapon.
 *
 */
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

    /**
     *
     * Counter of the weapon build-up status warning.
     *
     */
    static s8 count = 0;

    count++;
    bool blink = false;

    if (count > 25) {
        blink = true;
    }

    if (count > 50) {
        count = 0;
    }

    if (data != NULL) {
        WEAPON_USED *weapon = &item->data.weapon;

        if (weapon->status[WEAPON_STAT_ATTACK] < 0.9f * data->status[WEAPON_STAT_ATTACK]) {
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

int MenuItemSelectDiffer(int select) {
    /**
     *
     * Destination cursor selection for each preview page and inventory row.
     *
     */
    static s8 sel[6][6] = {
        {2, 2, 0, 0, 1, 1},
        {2, 2, 0, 0, 1, 1},
        {0, 0, 0, 1, 1, 3},
        {0, 0, 0, 1, 1, 1},
        {0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0}
    };

    /**
     *
     * Destination key layout for each preview page and inventory row.
     *
     */
    static s8 argtblno[6][6] = {
        {0, 3, 3, 3,  3,  3 },
        {0, 3, 3, 3,  3,  3 },
        {4, 4, 4, 5,  5,  5 },
        {6, 6, 6, 6,  7,  7 },
        {8, 8, 8, 8,  8,  8 },
        {9, 9, 9, 10, 10, 10}
    };

    /**
     *
     * Inventory row offset associated with each previous key layout.
     *
     */
    static s8 conv[12] = {0, 4, 1, 2, 2, 3, 2, 4, 2, 2, 3, 0};

    if (CMenuItemInfoPt->viewing_weapon) {
        return 0;
    }

    MENU_INPUTKEY_ARG *arg;
    int                prev_arg_no;
    CMenuKeyFunc      *key;
    key = MenuCommonInfo;
    key->key_arg = &item_menu_argtbl[select];
    arg = &item_menu_argtbl[select];
    prev_arg_no = CMenuItemInfoPt->key_arg_no;

    switch (prev_arg_no) {
        case ITEM_MENU_PANEL_BAG: {
            s16 line = key->cursor / item_menu_argtbl[(int) ITEM_MENU_PANEL_BAG].disp_columns - key->top_line;
            select = argtblno[CMenuItemInfoPt->view_mode][line];
            key->key_arg = &item_menu_argtbl[select];
            key->top_line = 0;
            key->cursor = sel[CMenuItemInfoPt->view_mode][line];
            break;
        }
        default:
            switch (select) {
                case ITEM_MENU_PANEL_BAG: {
                    int line_offset = conv[prev_arg_no];
                    key->top_line = MenuItem_ItemBoardTopLine;
                    key->cursor = key->key_arg->disp_columns * (key->top_line + line_offset);
                    break;
                }
                case ITEM_MENU_PANEL_ACTIVE_ITEMS:
                case ITEM_MENU_PANEL_EQUIPMENT:
                    if (key->cursor >= 3) {
                        key->cursor = 2;
                    }

                    if (CMenuItemInfoPt->key_arg_no == 3) {
                        key->cursor = 0;
                    }

                    break;
                case 3:
                case ITEM_MENU_PANEL_WEAPON:
                case 6:
                case ITEM_MENU_PANEL_FISHING_ROD:
                    key->cursor = 0;
                    key->top_line = 0;
                    break;
                case ITEM_MENU_PANEL_WEAPON_STATS:
                    key->top_line = 0;

                    if (key->cursor > 1) {
                        key->cursor = 1;
                    }

                    if (key->cursor < 0) {
                        key->cursor = 0;
                    }

                    break;
                case ITEM_MENU_PANEL_FISHING_BAIT:
                    if (GetUserDataMan()->GetActiveEsa() == NULL || CMenuItemInfoPt->view_mode != MENU_ITEM_VIEW_MAX ||
                        CMenuItemInfoPt->sub_view != 0) {
                        select = (int) ITEM_MENU_PANEL_EQUIPMENT;
                        key->key_arg = &item_menu_argtbl[(int) ITEM_MENU_PANEL_EQUIPMENT];
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

void CMenuItemInfo::CheckLoadItemNo() {
    if (view_mode == MENU_ITEM_VIEW_MAX) {
        SetMenuLoadItemNo(0);
    } else if (view_mode == MENU_ITEM_VIEW_MONICA) {
        SetMenuLoadItemNo(1);
    } else if (view_mode == MENU_ITEM_VIEW_ROBO) {
        load_item_no = 2;

        if (MenuLoadInfo.request_phase < 0) {
            MenuLoadInfo.load_phase = 0;
        } else {
            MenuLoadInfo.load_phase = MenuLoadInfo.request_phase;
        }

        SetMenuLoadItemNo(load_item_no);
    }
}

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

    if (GetActiveCharaNo() == 2 && mode != MENU_ITEM_VIEW_ROBO) {
        equip_flag[0] = 1;
    }

    int i;

    switch (mode) {
        case MENU_ITEM_VIEW_MAX:
        case MENU_ITEM_VIEW_MONICA: {
            int chara_no = sub_view;

            if (mode == MENU_ITEM_VIEW_MAX) {
                chara_no = 0;
            }

            if (mode == MENU_ITEM_VIEW_MONICA) {
                chara_no = 1;
            }

            if (MenuActionChara[0] != NULL && MenuLoadInfo.request_phase == 4) {
                MonicaRotationFlag = 1;
                MenuActionChara[0]->GetRotation(MonicaRotationData);
            }

            MenuItemCharaDataLoad(load_stack, chara_no, MenuCharaBuild2, restart_read);
            break;
        }
        case MENU_ITEM_VIEW_WEAPON:
        case MENU_ITEM_VIEW_FISHING_ROD: {
            mgCMemory stack;
            int       rest = MenuItemMemory.stGetRest();
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
        case MENU_ITEM_VIEW_ROBO:
            if (MenuLoadInfo.load_all == 1) {
                for (int j = 0; j < 7; j++) {
                    if (MenuActionChara[j] != NULL) {
                        MenuActionChara[j]->Initialize(NULL);
                    }
                }
            }

            MenuItemRoboDataLoad(load_stack, MenuCharaBuild2, restart_read);
            break;
        case MENU_ITEM_VIEW_MONSTER:
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
        ExeScript("ITEMCHRFADEIN");
    }

    if (mode == MENU_ITEM_VIEW_WEAPON || mode == MENU_ITEM_VIEW_FISHING_ROD) {
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
    mgCFrame     *spectol_frame = SpectolFrame->CObjectFrame::frame;
    mgCFrameAttr *attr = spectol_frame->attr;
    attr->alpha_blend = MG_ALPHA_MACRO_BLEND;
    attr->obj_alpha = 1.0f;
    spectol_frame->SetAttrParam(*attr, 1, MG_FRAME_ATTR_OBJ_ALPHA | MG_FRAME_ATTR_ALPHA_BLEND);
    ActiveMenuWeaponCharaRange *= 1.2f;
    CActionChara *build_chara = NULL;

    if (0 < view_weapon->IsBuildUp(NULL, NULL, NULL)) {
        build_chara = chara;
    }

    SetBuildUpInfoChara((CCharacter2 *) build_chara, ActiveMenuWeaponCharaRange);
}

int CMenuItemInfo::ModelReadEndCheck() {
    /**
     *
     * Preview-form animation counter for each view page.
     *
     */
    static s8 cnttbl[6] = {-10, -10, -10, -7, -7, -7};

    /**
     *
     * Ridepod preview position for each core height offset.
     *
     */
    static float robo_stand_pos[11][3] = {
        {-44.0f, -20.0f, -180.0f},
        {-44.0f, -20.0f, -180.0f},
        {-44.0f, -22.0f, -180.0f},
        {-44.0f, -29.0f, -180.0f},
        {-44.0f, -24.0f, -180.0f},
        {-44.0f, -21.0f, -180.0f},
        {-44.0f, -21.0f, -180.0f},
        {-44.0f, -21.0f, -180.0f},
        {-44.0f, -26.0f, -180.0f},
        {-44.0f, -26.0f, -180.0f},
        {-44.0f, -20.0f, -180.0f}
    };

    int loaded = MenuLoadFileCheck(MenuCharaBuild2);
    int result = 0;

    if (loaded && ReadBGSync() == 0) {
        int chara_tex_block = MenuArg.chara_tex_block;
        int load_tex_block = tex_block[1];

        switch (view_mode) {
            case MENU_ITEM_VIEW_MAX:
            case MENU_ITEM_VIEW_MONICA:
                MenuItemCharaDataLoadEndCheck(MenuCharaBuild2, &MenuCharaLoadStack, MenuActionChara, view_mode,
                                              load_tex_block, chara_tex_block);
                break;
            case MENU_ITEM_VIEW_WEAPON:
            case MENU_ITEM_VIEW_FISHING_ROD:
                MenuItemChrLoadEndCheck(MenuCharaBuild2[0], MenuActionChara[0], MenuActionCharaBuffer, load_tex_block);

                for (int i = 0; i < 6; i++) {
                    if (MenuCharaBuild2[i]->chara != NULL) {
                        MenuCharaBuild2[i]->chara->ResetParent();
                    }
                }

                break;
            case MENU_ITEM_VIEW_ROBO:
                MenuItemRoboDataLoadEndCheck(MenuCharaBuild2, &MenuCharaLoadStack, MenuActionChara, load_tex_block,
                                             chara_tex_block);
                break;
            case MENU_ITEM_VIEW_MONSTER:
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
        int           ready = MenuLoadFileCheck(MenuCharaBuild2);
        CActionChara *chara = MenuCharaBuild2[0]->chara;

        if (ready) {
            chara_poly_form[0]->counter = cnttbl[view_mode];
        } else {
            chara_poly_form[0]->counter = 13;
            chara->SetScale(1.0f, 1.0f, 1.0f);

            switch (view_mode) {
                case MENU_ITEM_VIEW_MAX:
                case MENU_ITEM_VIEW_MONICA:
                    chara->UpdatePosition();

                    if (chara->dynamic_anime_num > 0) {
                        for (int i = 0; i < chara->dynamic_anime_num; i++) {
                            chara->dynamic_anime[i].ResetPosition();
                        }
                    }

                    chara->SetRotation(0.0f, 0.0f, 0.0f);

                    if (MonicaRotationFlag) {
                        chara->SetRotation(MonicaRotationData);
                    }

                    break;
                case MENU_ITEM_VIEW_WEAPON:
                case MENU_ITEM_VIEW_FISHING_ROD:
                    WeaponBuildCheck(chara, view_chara, load_tex_block);
                    break;
                case MENU_ITEM_VIEW_ROBO: {
                    chara->SetPosition(-44.0f, -20.0f, -180.0f);
                    CDataRoboPart *leg_info = GetRoboPartInfoData(GetUserDataMan()->robo_data.parts[3].item_no);
                    int            offset_no = 0;

                    if (leg_info != NULL) {
                        offset_no = leg_info->GetOffsetNo();
                    }

                    chara->SetPosition(robo_stand_pos[offset_no][0], robo_stand_pos[offset_no][1],
                                       robo_stand_pos[offset_no][2]);
                    MenuRoboPartsLightOff(MenuActionChara[2]->CObjectFrame::frame);
                    break;
                }
                case MENU_ITEM_VIEW_MONSTER:
                    chara->SetPosition(-34.0f, -18.0f, -120.0f);
                    break;
            }

            chara->Step();
            result = 1;
            chara_poly_form[0]->draw_flag = 1;
            chara_poly_form[0]->SetActionCharaPtr(chara, load_tex_block, tex_block[5]);
            MenuWeaponEnvSetChara = NULL;
            MenuWeaponEnvSetListNo = -1;

            if (view_mode == MENU_ITEM_VIEW_MONICA) {
                MenuWeaponEnvSetChara = MenuActionChara[0];
                MenuWeaponEnvSetListNo = MenuLoadItemNo[0];
            }

            if (view_mode == MENU_ITEM_VIEW_WEAPON) {
                MenuWeaponEnvSetChara = MenuActionChara[0];

                if (view_weapon != NULL) {
                    MenuWeaponEnvSetListNo = view_weapon->item_no;
                }
            }

            MenuTimeStepEnvFunc(MenuMainScene, MenuWeaponEnvSetChara, MenuWeaponEnvSetListNo);
        }

        MenuCharaLoadStack.stReset();
        ExeScript("ITEMCHRFADEIN");
    }

    if (mode != MENU_ASK_MODE_CLOSE) {
        if (chara_poly_form[0]->draw_flag == 1 && chara_poly_form[0]->counter >= 14) {
            ExeScript("ITEMCHRFADEOUT");
        }
    }

    return result;
}

void CMenuItemInfo::SearchEffectDisplayPosition(int *position, CGameDataUsed *item) {
    int item_index = GetSameAdrressUserData(item, 0);

    if (0 <= item_index) {
        MenuPosData->GetPosMenuItemBrdKoma(MenuRepairTargetWeaponPos, item_index, 0);
        int item_line = item_index / 6;

        if (item_line < MenuItem_ItemBoardTopLine || MenuItem_ItemBoardTopLine + 5 < item_line) {
            effect_pos = 0;
        }
    } else {
        if (view_mode == MENU_ITEM_VIEW_MAX || view_mode == MENU_ITEM_VIEW_MONICA) {
            CMenuPosDataForm *form = view_form[sub_view];
            CHARA_DATA       *character = MenuUserParam.chara[sub_view];

            if (&character->equip[0] == item) {
                form->GetPutPosXY("wep0", MenuRepairTargetWeaponPos[0], MenuRepairTargetWeaponPos[1]);
            } else if (&character->equip[1] == item) {
                form->GetPutPosXY("wep1", MenuRepairTargetWeaponPos[0], MenuRepairTargetWeaponPos[1]);
            }

            position[0] -= 7;
        }

        if (view_mode == MENU_ITEM_VIEW_ROBO) {
            ROBO_DATA *ridepod = MenuUserParam.robo;

            if (&ridepod->parts[2] == item) {
                view_form[3]->GetPutPosXY("wep2", MenuRepairTargetWeaponPos[0], MenuRepairTargetWeaponPos[1]);
            } else if (&ridepod->parts[0] == item) {
                view_form[3]->GetPutPosXY("wep0", MenuRepairTargetWeaponPos[0], MenuRepairTargetWeaponPos[1]);
            }

            position[0] -= 7;
        }
    }
}

void CMenuItemInfo::SetItemEffect() {
    /**
     *
     * Colour, pulse count and duration of the cure and power-up palette effects.
     *
     */
    static int effparamtbl[2][5] = {
        {96,  180, 255, 1, 45},
        {250, 220, 64,  1, 45}
    };

    CCharacter2 *field_chara = MenuMainScene->GetCharacter(0);
    int          item_no = MenuUsedItemNo;
    int          target_type = MenuUsedTarget.type;
    int          chara_effect = 0;
    int          weapon_effect = 0;
    int          repair_effect = 0;
    int          level_effect = 0;
    u8           always = item_no == 0x10F || item_no == 0x111 || item_no == 0x1AA || item_no == 0x124;

    if (((view_mode == MENU_ITEM_VIEW_MAX || view_mode == MENU_ITEM_VIEW_MONICA) && target_type == ITEM_USE_TARGET_CHARA &&
         MenuUsedTarget.target.data == MenuUserParam.chara[sub_view]) ||
        always) {
        chara_effect = 1;
    }

    if ((view_mode == MENU_ITEM_VIEW_MONSTER && target_type == 3) || always) {
        chara_effect = 1;
    }

    if (view_mode == MENU_ITEM_VIEW_WEAPON && target_type == ITEM_USE_TARGET_ITEM && MenuUsedTarget.target.item == view_weapon) {
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

    if (GetMenuLoopType() == (int) MENU_LOOP_TOWN) {
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
            FxScriptMan->CreateEffSpt("\x92\xCA\x8F\xED\x89\xF1\x95\x9C", 0, 0);
            FxScriptMan->SetScriptTargetId(0, -1, -1);
            int param_no = 0;

            if (MenuUsedItemType & 0x400000) {
                param_no = 1;
            }

            int *param = effparamtbl[param_no];
            MenuActionChara[0]->pallet[0].SetAnim(param[0], param[1], param[2], param[3], param[4], 0);
            FxScriptMan->SetValue(0, param_no, 0, -1);
        }
    }

    if (MenuUsedItemType & 0x400) {
        repair_running = 0;
        effect_pos = 0;

        if (weapon_effect) {
            mode = MENU_ASK_MODE_EXTEND;
            step = 0;
            ask_para.ask_mode = 1;
            repair_running = 1;
        }

        if (repair_effect) {
            mode = MENU_ASK_MODE_EXTEND;
            step = 0;
            ask_para.ask_mode = 1;
            effect_pos = 1;
            MenuRepairTargetWeaponPos[0] = -100;
            MenuRepairTargetWeaponPos[1] = -100;
            SearchEffectDisplayPosition(MenuRepairTargetWeaponPos, MenuUsedTarget.target.item);
        }

        if (repair_running && MenuCommonInfo->cursor_form != NULL) {
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
            MenuLevelUpMan.spark_tex = mgTexManager.GetTexture("menueff0", -1);
            MenuLevelUpMan.Generate(who, (CCharacter2 *) MenuActionChara[0]);
        }
    }
}

int CMenuItemInfo::LRCheck(int key) {
    if (mode != MENU_ASK_MODE_NONE) {
        return 0;
    }

    if (viewing_weapon) {
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

    switch (key) {
        case MENU_SELECT_KEY_L1:
        case MENU_SELECT_KEY_R1:
        case MENU_SELECT_KEY_L2:
        case MENU_SELECT_KEY_R2: {
            int        page_view[8];
            int        page_chara[8];
            int        page_arg_no[8];
            mgCMemory *item_memory = &MenuItemMemory;
            mgCMemory *load_stack = &MenuCharaLoadStack;
            int        page_num = 0;
            int        active = GetActiveCharaNo();
            int        party = MenuUserDataManPtr->GetNowPartyMember();

            if (party & (1 << USER_CHARA_MAX)) {
                page_view[page_num] = MENU_ITEM_VIEW_MAX;
                page_arg_no[page_num] = 3;
                page_num++;
                page_chara[0] = USER_CHARA_MAX;
            }

            if (party & (1 << USER_CHARA_MONICA)) {
                if (active != USER_CHARA_MONSTER) {
                    page_view[page_num] = MENU_ITEM_VIEW_MONICA;
                    page_arg_no[page_num] = 3;
                    page_chara[page_num] = USER_CHARA_MONICA;
                    page_num++;
                }
            }

            if (party & (1 << USER_CHARA_ROBO)) {
                page_view[page_num] = MENU_ITEM_VIEW_ROBO;
                page_chara[page_num] = USER_CHARA_ROBO;
                page_arg_no[page_num] = 6;
                page_num++;
            }

            if (party & (1 << USER_CHARA_MONSTER)) {
                if (active == USER_CHARA_MONSTER) {
                    page_view[page_num] = MENU_ITEM_VIEW_MONSTER;
                    page_chara[page_num] = USER_CHARA_MONSTER;
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
                int held_type = ConvertUsedItemType(GetItemDataType(MenuCommonInfo->have_item.item_no));

                if ((view_mode == MENU_ITEM_VIEW_MAX || view_mode == MENU_ITEM_VIEW_MONICA) &&
                    (held_type == USED_ITEM_TYPE_WEAPON || held_type == USED_ITEM_TYPE_COSTUME)) {
                } else if (view_mode != MENU_ITEM_VIEW_ROBO || held_type != USED_ITEM_TYPE_ROBO_PART) {
                    MenuMemoryAdjust(item_memory, load_stack, MenuActionCharaBuffer, next_chara);
                    MenuLoadInfo.load_all = 1;
                    MenuLoadInfo.request_phase = -1;
                    MenuLoadInfo.load_phase = 0;
                    view_mode = next_view;

                    if (view_mode == MENU_ITEM_VIEW_MAX || view_mode == MENU_ITEM_VIEW_MONICA) {
                        sub_view = next_chara;
                    }

                    int load_chara = view_mode;

                    if (load_chara != MENU_ITEM_VIEW_MONSTER) {
                        if (load_chara == MENU_ITEM_VIEW_ROBO) {
                            load_chara = USER_CHARA_ROBO;
                        }

                        CheckLoadInfo(load_chara);
                    }

                    if (view_mode == MENU_ITEM_VIEW_ROBO) {
                        MenuLoadInfo.request_phase = -1;
                        MenuLoadInfo.load_phase = 0;
                        MenuActionChara[5]->Initialize(NULL);
                    }

                    key_arg_no = next_arg_no;
                    MenuCommonInfo->key_arg = &item_menu_argtbl[key_arg_no];
                    ModelReadStart(view_mode, 1, 1);
                    MenuSePlay(SYSTEM_SE_DECIDE);
                }
            }

            break;
        }
    }

    return 0;
}

/**
 *
 * Sets the item information cursor indicators for the active menu mode.
 *
 */
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
                if (CMenuItemInfoPt->view_mode == MENU_ITEM_VIEW_ROBO) {
                    info->arrow[msg_item - 18] = 1;
                }

                break;
        }
    }
}

void MenuCharaStatusDraw(int &tex_block) {
    /**
     *
     * Character-status masks controlling the displayed icons.
     *
     */
    static u32 status_table[7] = {CHARA_STATUS_POISON, CHARA_STATUS_SLOW, CHARA_STATUS_UNK_4, CHARA_STATUS_UNK_8, CHARA_STATUS_POWER, CHARA_STATUS_UNK_20, CHARA_STATUS_UNK_40};

    /**
     *
     * Texture coordinates of the character-status icons.
     *
     */
    static s8 xytable[7][2] = {
        {0,  0 },
        {24, 24},
        {48, 0 },
        {0,  24},
        {24, 0 },
        {48, 24},
        {72, 0 }
    };

    /**
     *
     * Texture coordinates of the weapon special-ability icons.
     *
     */
    static s8 xytable_wep[12][2] = {
        {0,   48},
        {20,  48},
        {40,  48},
        {60,  48},
        {80,  48},
        {100, 48},
        {0,   68},
        {20,  68},
        {40,  68},
        {60,  68},
        {80,  68},
        {100, 68}
    };

    /**
     *
     * Weapon special-ability masks controlling the displayed icons.
     *
     */
    static u32 draw_tbl[12] = {MENU_WEAPON_ABILITY_RICH, MENU_WEAPON_ABILITY_POOR, MENU_WEAPON_ABILITY_POISON, MENU_WEAPON_ABILITY_STOP, MENU_WEAPON_ABILITY_STEAL, MENU_WEAPON_ABILITY_BREAK_EASY, MENU_WEAPON_ABILITY_BREAK_HARD, MENU_WEAPON_ABILITY_DRAIN, MENU_WEAPON_ABILITY_HEAL, MENU_WEAPON_ABILITY_DARK, MENU_WEAPON_ABILITY_CRITICAL, MENU_WEAPON_ABILITY_ABS2};

    if (MenuStatusTex == NULL) {
        return;
    }

    if (MenuStatusMode == 0) {
        if (CMenuItemInfoPt->view_mode == MENU_ITEM_VIEW_MAX || CMenuItemInfoPt->view_mode == MENU_ITEM_VIEW_MONICA) {
            CMenuPosDataForm *form;
            int               status = MenuUserDataManPtr->GetCharaStatusAttirbute(CMenuItemInfoPt->sub_view);
            form = CMenuItemInfoPt->view_form[CMenuItemInfoPt->sub_view];

            if (status != 0 && form != NULL) {
                MenuReloadTexture(tex_block, MenuStatusTex->block);
                float x = 16.0f + form->x;
                float y = form->y - 200.0f;

                for (int i = 0; i < 7; i++) {
                    if (status & status_table[i]) {
                        mgRect<int> rect;
                        rect.Set(xytable[i][0], xytable[i][1], 24, 24);
                        PrimQuad(MenuStatusTex, x, y, rect, form->rgba[3], 0x80, 0x80, 0x80);
                        x += 24.0f;
                    }
                }
            }
        }

        if (CMenuItemInfoPt->view_mode == MENU_ITEM_VIEW_WEAPON) {
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
                    if (special & draw_tbl[i]) {
                        mgRect<int> rect;
                        rect.Set(xytable_wep[i][0], xytable_wep[i][1], 21, 21);
                        PrimQuad(MenuStatusTex, x, y, rect, form->rgba[3], 0x80, 0x80, 0x80);
                        x += 24.0f;
                    }
                }
            }
        }
    }
}

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

    if (view_mode == MENU_ITEM_VIEW_MAX || view_mode == MENU_ITEM_VIEW_MONICA) {
        int   i;
        float bob_x = 7.5f * wave;
        float bob_y = 10.0f * wave;
        int   x = 0x36;
        put_rect.top = (int) (91.0f - bob_y);

        for (i = 0; i < 3; i++) {
            if (MenuItemCursorInfo.arrow[i] != 0) {
                put_rect.left = (int) (x + bob_x);
                PrimQuad(prim, put_rect, down_rect);
            }

            x += 0x2A;
        }

        put_rect.top = (int) (294.0f - bob_y);

        if (MenuItemCursorInfo.arrow[3] != 0) {
            put_rect.left = (int) (46.0f + bob_x);
            PrimQuad(prim, put_rect, up_rect);
        }

        if (MenuItemCursorInfo.arrow[4] != 0) {
            put_rect.left = (int) (180.0f - bob_x);
            PrimQuad(prim, put_rect, left_rect);
        }
    }

    if (CMenuItemInfoPt->view_mode == MENU_ITEM_VIEW_ROBO) {
        float bob_x = 7.5f * wave;
        float bob_y = 10.0f * wave;
        put_rect.top = (int) (310.0f - bob_y);

        if (MenuItemCursorInfo.arrow[3] != 0) {
            put_rect.left = (int) (166.0f - bob_x);
            PrimQuad(prim, put_rect, left_rect);
        }

        put_rect.top -= 0x30;

        if (MenuItemCursorInfo.arrow[4] != 0) {
            put_rect.left = (int) (166.0f + bob_x - 120.0f);
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
        int   view = CMenuItemInfoPt->view_mode;

        if (view == 0 || view == 1) {
            put_rect.left = (int) (70.0f - bob_x);
            put_rect.top = (int) (190.0f + bob_y);
        } else if (view == 2 || view == 5) {
            put_rect.left = 0x14;
            put_rect.top = 0x78;
        } else if (view == 3) {
            put_rect.left = 0x5A;
            put_rect.top = 0x82;
        } else if (view == 4) {
            put_rect.left = (int) (70.0f - bob_x);
            put_rect.top = (int) (230.0f + bob_y);
        }

        int put_x2 = put_rect.left + put_rect.bottom;
        int put_y2 = put_rect.top + put_rect.right;
        int tex_right = up_rect.left + up_rect.right;
        int tex_bottom = up_rect.top + up_rect.bottom;
        prim->TextureCrd(up_rect.left, tex_bottom);
        prim->Vertex(put_x2, put_rect.top, 0);
        prim->TextureCrd(up_rect.left, up_rect.top);
        prim->Vertex(put_rect.left, put_rect.top, 0);
        prim->TextureCrd(tex_right, up_rect.top);
        prim->Vertex(put_rect.left, put_y2, 0);
        prim->TextureCrd(tex_right, tex_bottom);
        prim->Vertex(put_x2, put_y2, 0);
    }

    prim->End();
}

void CMenuItemInfo::KeyStepLocal(int select_key, int push_button, int flag) {
    int select = -1;

    if (GamePad__2.Down(PAD_R3) && menu_debug_flag == 1) {
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

        if (status_check_ready != 0 && MenuSpectolSatusCheckForm != NULL && (select_key != 0 || push_button != 0)) {
            MenuSpectolSatusCheckForm->SetAction("\x8A\x4F\x82\xD6");
            status_check_ready = 0;
        }
    } else if (!MenuLoadFileCheck(MenuCharaBuild2)) {
        PushKey(select_key, push_button);
    }
}

int CMenuItemInfo::KeyStep() {
    int result = 0;
    s8  loading = MenuLoadFileCheck(MenuCharaBuild2);
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
                        ExeScript("INITEND");
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

                            int       over_num = GetUserDataMan()->GetItemBoardOverNum();
                            mgCMemory stack;
                            int       rest = MenuCharaLoadStack.stGetRest();
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
            if ((CheckTrushMenu() && ItemOverFlowCheckFlag == 0) || item_consumed == 1) {
                if (reading == 0 && FadeCheckMenu()) {
                    ExitEnd();
                    result = 1;

                    if (item_consumed) {
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

    if (chara != NULL && loading == 0 && MenuCommonInfo->frame_parity != 0) {
        chara->Step();
        MenuCharaBuild2[0]->chara->StepEffect();

        if (GetNowLoopNo() == (int) LOOP_DUNGEON && FxScriptMan != NULL) {
            FxScriptMan->PauseFromLevel(3, 3);
            FxScriptMan->PauseFromLevel(1, 3);
            FxScriptMan->Step();
            FxScriptMan->PauseFromLevel(3, 0);
            FxScriptMan->PauseFromLevel(1, 0);
        }
    }

    int *mode_id = GetCommonMenuModeID();
    int  icon_mode = 2;

    if (mode == MENU_ASK_MODE_CLOSE) {
        icon_mode = 0;
    }

    if (CheckTrushMenu()) {
        icon_mode = 2;
    }

    if (item_consumed) {
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

int MenuItemKey() {
    int ret;

    /**
     *
     * Previous item preview page remembered by the menu input handler.
     *
     */
    static int old_viewmode = 0;

    /**
     *
     * Previous preview character remembered by the menu input handler.
     *
     */
    static int old_chrid = 0;

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

                    old_viewmode = CMenuItemInfoPt->view_mode;
                    old_chrid = CMenuItemInfoPt->sub_view;

                    if (CMenuItemInfoPt->next_sub_menu == 1) {
                        MenuCommonInfo->SetWakuType(-1);
                        MenuMonsterBoxInit(&MenuItemMemory, (&CMenuItemInfoPt->tex_block[0]), 0);
                    }

                    if (CMenuItemInfoPt->next_sub_menu == 0) {
                        SetMenuFrameRate(2);
                        MenuAquaInit(&MenuItemMemory, (&CMenuItemInfoPt->tex_block[0]), 0);
                    }

                    if (CMenuItemInfoPt->next_sub_menu == 2) {
                        NameRegistInit(&MenuItemMemory, (&CMenuItemInfoPt->tex_block[0]), 0);
                    }

                    if (CMenuItemInfoPt->next_sub_menu == 3) {
                        MenuNPCQuestViewInit(&MenuItemMemory, (&CMenuItemInfoPt->tex_block[0]),
                                             0);
                    }

                    if (CMenuItemInfoPt->next_sub_menu == 4) {
                        MenuNPCQuestViewInit(&MenuItemMemory, (&CMenuItemInfoPt->tex_block[0]),
                                             1);
                    }

                    if (CMenuItemInfoPt->next_sub_menu == 5) {
                        MonsterBookInit(&MenuItemMemory, (&CMenuItemInfoPt->tex_block[0]), 0);
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
                    u8 *buffer = (u8 *) MenuItemBGDataMemory.stack;
                    LoadFileMenu("itemmn0.pac", (u_long128 *) buffer, 1);
                    CMenuItemInfoPt->EnterDataMenu((unsigned int *) buffer);
                }

                if (CMenuItemInfoPt->sub_menu == 1) {
                    MenuPosData->InitDrawList();
                    MenuPosData->FormReLink("main_form_dmy1", "poly_chr0");
                    MenuPosData->FormReLink("msg0", "msg5");
                }

                LoadFileMenu("mb2.pac", MenuMainTextureReadBuf.stack, 1);
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
                MenuLoadInfo.load_all = 0;
                MenuLoadInfo.load_phase = 0;
                MenuLoadInfo.request_phase = -1;
                MenuLoadInfo.alternate_model = 0;

                if (!GetMenuLoopType()) {
                    MenuLoadInfo.alternate_model = 1;
                }

                {
                    int chara = CMenuItemInfoPt->GetActiveCharaNo();
                    MenuLoadInfo.chara_no = chara;

                    if (MenuLoadInfo.chara_no == 0 || MenuLoadInfo.chara_no == 1) {
                        MenuLoadInfo.load_all = 1;
                    }

                    CMenuItemInfoPt->view_mode = CMenuItemInfoPt->active_chara_view_mode;

                    if (CMenuItemInfoPt->view_mode == MENU_ITEM_VIEW_MAX) {
                        CMenuItemInfoPt->sub_view = 0;
                    }

                    if (CMenuItemInfoPt->view_mode == MENU_ITEM_VIEW_MONICA) {
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
                BuildUpWeaponInfo.monster_mode = 0;
                CMenuItemInfoPt->mode = 0;
                CMenuItemInfoPt->next_sub_menu = -1;
                CMenuItemInfoPt->sub_menu = -1;
                CMenuItemInfoPt->FadeInMenu(0x28, 0.0f);
                CMenuItemInfoPt->reset_cursor_pos = 1;
            }

            return 0;
        default:
            return 0;
    }
}

int CheckFishCondition();

void MenuItemDraw() {
    DrawMenuFillBox(0x80, 0, 0, 0);

    switch (CMenuItemInfoPt->sub_menu) {
        case -1: {
            if (CMenuItemInfoPt->view_mode == MENU_ITEM_VIEW_WEAPON || CMenuItemInfoPt->view_mode == MENU_ITEM_VIEW_FISHING_ROD) {
                MenuDrawEnv->camera.SetRef(CMenuItemInfoPt->camera_ref);
                MenuDrawEnv->camera.SetPos(CMenuItemInfoPt->camera_pos);
            } else {
                MenuEquipCameraSetEnv(MenuActionChara[0], &MenuDrawEnv->camera, menu_camera_reference_id,
                                      menu_camera_reference_no);
            }

            int               loaded_tex_no = -1;
            CMenuPosDataForm *form = MenuPosData->GetDrawTopList();
            int               effect_drawn = 0;

            while (form != NULL) {
                form->MenuFormDraw(loaded_tex_no);

                if (!effect_drawn && strcmp(form->name, "poly_chr0") == 0) {
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
                tex_manager->ReloadTexture(CMenuItemInfoPt->tex_block[2], (sceVif1Packet *) NULL);
                CMenuItemInfoPt->build_up_chara->DrawDirect();
            }

            MenuRepairMan->Draw();

            if (MenuLevelUpMan.IsRun() && MenuLevelUpMan.label_tex != NULL) {
                tex_manager->ReloadTexture(MenuLevelUpMan.label_tex->block, (sceVif1Packet *) NULL);
                MenuLevelUpMan.Draw();
            }

            if (StepFishBoiledEffect()) {
                tex_manager->ReloadTexture(MenuLevelUpMan.label_tex->block, (sceVif1Packet *) NULL);
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
    int            i;

    item_num = 0;
    entries = MenuUserParam.used_data;

    for (i = 0; i < kBagSlotCount; i++) {
        if (entries[i].item_no > 0 && !(0 < entries[i].GetSpectolNo()) &&
            entries[i].used_type != USED_ITEM_TYPE_BOILED) {
            item_list[item_num] = &entries[i];
            limit_disp[item_num] = 0;

            if (((s8 *) menu_limmit_displayflag)[i] == 1) {
                limit_disp[item_num] = 1;
            }

            item_num++;
        }
    }

    for (i = item_num; i < kBagSlotCount; i++) {
        item_list[i] = NULL;
    }

    line_num = (float) (item_num / 5 + 1);
}

CGameDataUsed *CItemSelect::GetExistThisPosData(int pos) {
    if (pos < 0 || item_num < pos) {
        return NULL;
    }

    return item_list[pos];
}

void CItemSelect::CheckUse(CGameDataUsed *item) {
    int  i;
    int *use_nos;
    int  offset;
    int  use_no;

    if (item != NULL) {
        use_nos = &MenuArg.param[1];

        if (MenuArg.param[0] != 0 && MenuArg.param[0] == 1) {

            for (i = 0, offset = 0; i < 10; i++, offset += 4) {
                use_no = *(int *) ((u8 *) use_nos + offset);

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

int CItemSelect::KeyStep() {
    /**
     *
     * Texture package entries of the item selector.
     *
     */
    static char *imgtbl[4] = {"img.img", "allitem.img", "edmenu.img", NULL};

    int end = 0;

    switch (mode) {
        case MENU_ASK_MODE_OPEN: {
            if (ReadBGSync() == 0) {
                mgCTextureManager *tex_manager = &mgTexManager;
                tex_manager->DeleteBlock(tex_block[1]);
                BG_READ_INFO *file = GetReadBGFile(0);

                if (file != NULL) {
                    MenuMainImageDataEnter(tex_block[1]);

                    for (int i = 0; imgtbl[i] != NULL; i++) {
                        tex_manager->EnterIMGFile((u8 *) GetPackFile((u_int *) file->buffer, imgtbl[i], NULL),
                                                  tex_block[1], NULL, NULL);
                    }

                    MenuItemIconTextureBlock = tex_block[1];
                    MenuPosData->AttachCommonTexInfo();
                    MenuItemIconTextureBlock = tex_block[1];
                    MenuPosData->MallocPallet(&MenuItemMainMemory);
                    MenuDCMsg[0]->SetBuff(GetMenuMainMessageBuffer());
                }

                texture = tex_manager->GetTexture("eventmn", -1);
                alpha_step = 0xC;
                MenuCommonInfo->key_enable = 1;
                mode = MENU_ASK_MODE_NONE;
            }

            break;
        }
        case MENU_ASK_MODE_CLOSE:
            if (alpha <= 0) {
                end = 1;
            }

            break;
        default: {
            int select_key = MenuCommonInfo->CheckSelectKey();
            int push_button = MenuCommonInfo->CheckPushButton();
            int max = (int) (5.0f * line_num);
            int old_cursor = cursor;

            if (select_key & MENU_SELECT_KEY_UP) {
                cursor = old_cursor - 5;
            } else if (select_key & MENU_SELECT_KEY_DOWN) {
                cursor = old_cursor + 5;
            } else if (select_key & MENU_SELECT_KEY_RIGHT) {
                if (old_cursor % 5 != 4) {
                    cursor = old_cursor + 1;

                    if (max <= cursor) {
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
                MenuSePlay(SYSTEM_SE_CURSOR);
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
                    MenuSePlay(SYSTEM_SE_DECIDE);

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
                                MenuArg.result[4] = (int) info->size;
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
                MenuDCMsg[0]->MakeMsg("\x81\x40");
            } else {
                MenuDCMsg[0]->MakeMsg(" ");
            }

            break;
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

void CItemSelect::Draw() {
    if (texture == NULL) {
        return;
    }

    mgCTextureManager *tex_manager = &mgTexManager;
    tex_manager->ReloadTexture(texture->block, (sceVif1Packet *) NULL);
    mgCDrawPrim *prim = GetMenuPrim();
    mgRect<int>  frame_rect;
    frame_rect.Set(1, 0, 0x110, 0xFE);
    mgRect<float> *list = &list_rect;
    SetMenuScissor(mgRect<int>(0, (int) (37.0f + list_rect.top), mgScreenWidth - 1, (int) (147.0f + list_rect.top)));
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
    int line;
    int column;
    int drawn = 0;

    for (line = 0; line < 50; line++) {
        float y = item_rect.top + 55.0f * line;

        if (!(y <= 90.0f)) {
            float x = item_rect.left;

            for (column = 0; column < 5; column++) {
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
    u8 color[4] = {0x80, 0x80, 0x80, 0};
    color[3] = alpha;
    mgCTexture *number_tex = tex_manager->GetTexture("mnmain", -1);
    mgRect<int> number_rect;
    number_rect.Set(0, 0xF4, 0xA, 0xD);
    int index = 0;

    for (line = 0; line < item_num && item_list[line] != NULL; line++) {
        icon_rect.left = 4.0f + item_rect.left;

        for (column = 0; column < 5; column++, index++) {
            if (icon_rect.top <= 0.0f) {
                continue;
            }

            if (index >= item_num) {
                break;
            }

            DrawOneItem(prim, icon_rect, item_list[index]->item_no, 0, NULL, color, 0);
            int item_no;
            int num;
            num = item_list[index]->GetNum();
            item_no = item_list[index]->item_no;

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

                PrimDrawNumber(prim, num, (int) MENU_NUMBER_ALIGN_RIGHT, (int) (32.0f + icon_rect.left), (int) (26.0f + icon_rect.top), number_rect, -1, 0);
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

    float scroll_y;
    float bar_x;
    bar_x = 250.0f + list->left;
    scroll_y = scroll;
    prim->Bilinear(1);
    prim->Begin(6);
    PrimQuad(prim, mgRect<int>((int) bar_x, (int) scroll_y, 6, 4), mgRect<int>(0x13E, 0, 6, 4));
    float body_y;
    PrimQuad(prim, mgRect<int>((int) bar_x, (int) (body_y = 4.0f + scroll_y), 6, (int) (bar_h - 8.0f)), mgRect<int>(0x13E, 4, 6, 0x12));
    PrimQuad(prim, mgRect<int>((int) bar_x, (int) (body_y + bar_h - 8.0f), 6, 4), mgRect<int>(0x13E, 0x18, 6, 4));
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

    DrawMenuWakuRect(MenuPosData->icon_effect_tex, mgRect<float>(cursor_x - 2.0f, cursor_y - 4.0f, cursor_rect.right, 40.0f),
                     mgRect<int>(0x10, 0x20, 0x12, 0xC), alpha, 0x80, 0x80, 0x80);

    if (mode == MENU_ASK_MODE_NONE) {
        int mes_pos[2] = {(int) (16.0f + list->left), (int) (164.0f + list->top)};
        tex_manager->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *) NULL);
        MenuDCMsg[0]->SetPutPos(mes_pos);
        MenuDCMsg[0]->StepMsg();
        MenuDCMsg[0]->DrawMsg();
    }
}

/**
 *
 * Creates the inventory choice with its screen rectangles and available items.
 *
 */
inline CItemSelect::CItemSelect() {
    alpha_step = 0;
    alpha = 0;
    bg_alpha = 0;
    item_num = 0;
    cursor_y = 0.0f;
    cursor_x = 0.0f;
    scroll = 0.0f;
    texture = NULL;
    list_rect.Set(120.0f, (float) (mgScreenHeight - 0x10A), 0.0f, 200.0f);
    item_rect.Set(20.0f + list_rect.left, 370.0f + list_rect.top, 44.0f, 55.0f);
    top_line = 0;
    cursor = 0;
    line_num = 1.0f;
    CheckEnableHaveItemNum();
    SetPtrList();
}

void MenuItemSelectInit(mgCMemory *stack, int *tex_block, int mode) {
    int        rest = stack->stGetRest();
    u_long128 *top = stack->stGetTop();
    MenuItemMainMemory.stSetBuffer(top, rest);
    ItemSelectPtr = new (MenuItemMainMemory.Alloc(QuadwordsFor(sizeof(CItemSelect)) + 2)) CItemSelect;
    ItemSelectPtr->SetTexBlock(tex_block);
    MenuItemSelectMode = 0;

    if (mode == MENU_OPEN_USE_ITEM_B) {
        MenuItemSelectMode = 1;
    }

    MenuBGTextureBlock = ItemSelectPtr->tex_block[0];
    MenuCapture(MenuBGTextureBlock, &MenuItemMainMemory, 1);
    MenuPosData->AttachCommonTexInfo();
    MenuItemMainMemory.Align64();
    StartReadBG();

    int size;

    if (mode == MENU_OPEN_USE_ITEM) {
        size = LoadFileMenu("itemsel.pac", MenuItemMainMemory.stGetTop(), MENU_FILE_LOAD_BG);
    }

    if (mode == MENU_OPEN_USE_ITEM_B) {
        size = LoadFileMenu("fishsel.pac", MenuItemMainMemory.stGetTop(), MENU_FILE_LOAD_BG);
    }

    MenuItemMainMemory.Alloc(QuadwordsFor(size));
    MenuDCMsg[0]->MsgPreset(2);
    MenuDCMsg[0]->fuchi = 5;
    MenuDCMsg[0]->MakeMsg(0);
}

int MenuItemSelectKey() {
    int result;

    result = 1;

    if (ItemSelectPtr != NULL) {
        result = ItemSelectPtr->KeyStep();
    }

    return result;
}

void MenuItemSelectDraw() {
    int loaded_tex_no = -1;

    u8 *prim = (u8 *) GetMenuPrim();
    *(int *) (prim + 0x110) = 0;
    *(int *) (prim + 0x114) = 0;
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
    *(int *) (prim + 0x110) = 0;
    *(int *) (prim + 0x114) = 0;

    if (ItemSelectPtr != NULL) {
        ItemSelectPtr->Draw();
    }
}

// Uninitialised data (.bss)
MENU_ASKMODE_PARA MenuAskParam;

CMENU_USERPARAM MenuUserParam;

mgCMemory MainCharaReadStack;

CItemUseTarget MenuItemUseTarget;

mgCMemory MenuItemMainMemory;

mgCMemory MenuItemBGDataMemory;

mgCMemory MenuItemMemory;

mgCMemory MenuItemMemory2;

mgCMemory MenuCharaLoadStack;

CGameDataUsed SpectolInfoStay;

CGameDataUsed SepectolFusionBeforeAfterCheck;

CGameDataUsed SpectolTransBefore;

CGameDataUsed MenuMoveTempGameDataUsed;

CMenuItemInfo class_menu_item_info;

mgCMemory MenuDebugStack;
