#include "sound.hpp"
#include "prespr.hpp"
#include "mg_drawprim.hpp"
#include <cstdio>
#include "font.hpp"
#include "scenesnd.hpp"
#include "savedata.hpp"
#include "userdata.hpp"
#include "gamedata.hpp"
#include "scriptinterpreter.hpp"
#include "mg_math.hpp"
#include "menusys.hpp"
#include "common.h"
#include "menuop.hpp"
#include "menucls1.hpp"
#include "menudraw.hpp"
#include "memcard.hpp"
#include "mainloop.hpp"
#include "mglib.hpp"
#include "menucommon.hpp"
#include "mapselect.hpp"
#include "dataread.hpp"
#include "menumain.hpp"
#include "sysmes.hpp"
#include "mg_texture.hpp"
#include <cstring>

extern "C" void *__ct__14CBaseMenuClassFv(void *);
extern "C" void *__ct__9CMenuFontFv(void *font);
extern "C" void LocalFunc_AdjustScrlBar__FPP18MENUFORMPARTS_TYPEPiPiiffi(MENUFORMPARTS_TYPE **,
                                                                         int *, int *, int, float,
                                                                         float, int);
extern "C" void StepMainMenuIconMove__18CMenuPosDataManageFPiii(void *, void *, int, int);

struct IntPair {
    int a;
    int b;
};
extern "C" int fptosi(float value);
extern CMenuPosDataForm *LocalMenuBGForm;
extern CMenuPosDataForm *LocalMenuClipForm;
extern signed char manual_list_mesclstbl[5];
extern float config_option_num_f;
extern char at_1512__5[];
extern char at_1513__5[];
extern char at_1514__5[];
extern char at_1515__2[];
extern char at_1516__2[];
extern char at_1517__3[];
extern char at_1518__2[];
extern char at_1519__2[];
extern void *ManualMovie;
extern int ManualMovieTex;
extern mgCMemory StaticMenuLocalStack;
extern mgCMemory StaticMenuLocalStack2;
extern short Movie_BossFlag;
extern short Movie_DungeonFlag;
extern short MovieBgmBattleCheckStopFlag;
extern signed char MovieBattleBGMPhase;
extern float config_option_num_i;
extern IntPair at_1614__2;
extern IntPair at_1615__3;
extern IntPair at_1616__2;
extern IntPair at_1523__2;
extern char at_1428__4[];
extern char at_1429__3[];
extern char at_1648__2[];
extern char at_1649[];
extern char at_1650__3[];
extern char at_1651__2[];
extern char at_1652__2[];
extern char at_1653__2[];
extern char at_1654__3[];
extern char at_1655__4[];
extern char at_1656__4[];
extern CMenuPosDataForm *OptionButtonForm;
extern CSound CSnd;
extern CGamePad GamePad__2;
extern "C" void *__ct__18CMemoryCardManagerFv(void *);
extern "C" void *__ct__7CDC2MesFv(void *);
extern "C" void *__vt__14CSaveMenuClass[];
extern mgCMemory SaveMenuStack;
extern CDC2Mes *SaveFileList[13];
extern char *b_2715[3];
extern char at_2764[];
extern char at_2765[];
extern char at_2766[];
extern char at_2767[];
extern char at_2768[];
extern char at_2769[];
extern char at_2770__2[];
extern char at_2771__2[];
extern char at_2772__2[];
extern char at_2773__2[];
extern char at_2774__2[];
extern char at_2775__2[];
extern short SubGameSaveBlock;
extern mgCTexture *Tex_SaveFile;
extern float SubSaveTileXY;
extern char at_2821__2[];
extern char at_2822[];
extern char at_2823[];
extern char at_2824[];
extern char at_2825[];
extern char at_2826__2[];
extern char at_2827[];
void InitMnOnePictTex(void);
extern "C" int ReadBGSync__Fv(void);

extern CDC2Mes *MenuDCMsg[9];
extern CMemoryCardManager *MemoryCardPtr;
extern CSaveMenuClass *SaveMenuPtr;
extern CMenuOption *CMenuOptionPtr;
extern CManualMenu *CManualPtr;
extern CDC2Mes *MenuReturnMsg;
extern u8 MenuReturnMsgDrawFlag;
extern int OmakeFlag;
extern int MnOnePictTex[8];
extern char *dngmap_2627[];
extern char *SubGameSaveCFGBuffer;
extern int SubGameSaveCFGBufferSize;
extern SaveIconSet at_2609__2;
extern short MenuMapInfoSave_DngNo;

static const int kDungeonNoOffset = 0x1C5B4;

// Code (.text)
void InitMenuReturnMsg(mgCMemory *stack) {
    CDC2Mes *window;
    short *system_mes;
    ClsMes *mes;
    int width;
    int height;

    MenuReturnMsg = NULL;
    if (LanguageCode > 0) {
        window = new (stack->Alloc(0x2A7)) CDC2Mes;
        MenuReturnMsg = window;
        MenuReturnMsg->texture_block = MenuArg.mes_tex_block;
        MenuReturnMsg->buff = NULL;
        system_mes = GetSystemMesBuffer();
        MenuReturnMsg->SetMessData(system_mes, GetMenuMainMessageBuffer());
        MenuReturnMsg->MsgPreset(3);
        ((ClsMes *)MenuReturnMsg)->mes_no = -1;
        MenuReturnMsg->MakeMsg(0x5A);
        MenuReturnMsg->StepMsg();
        mes = MenuReturnMsg;
        width = mes->text_w;
        width += 0x20;
        height = mes->text_h;
        height += 0x1A;
        MenuReturnMsg->SetPutPos(0x100 - (width >> 1), (mgScreenHeight - height) - 0x18, width,
                                 height);
    }
    MenuReturnMsgDrawFlag = 0;
}
void SetMenuReturnMsgCtrl(int show) {
    MenuReturnMsgDrawFlag = show != 0;
    if (LanguageCode == 0) {
        MenuReturnMsgDrawFlag = 0;
    }
    if (MenuReturnMsg == NULL) {
        MenuReturnMsgDrawFlag = 0;
    }
}
void DrawMenuReturnMsg() {
    if ((MenuReturnMsgDrawFlag != 0) && (MenuReturnMsg != NULL)) {
        mgTexManager.ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)NULL);
        MenuReturnMsg->StepMsg();
        MenuReturnMsg->DrawMsg();
    }
}
int CheckOmakeVtuto(int entry) {
    if (OmakeFlag == 1) {
        if (GetNowLoopNo() == 2) {
            if (entry == 0x23 || entry == 0x24) {
                return 1;
            }
        }
    }
    return 0;
}
void InitMnOnePictTex() {
    MnOnePictTex[0] = 0;
    MnOnePictTex[1] = 0;
    MnOnePictTex[2] = 0;
    MnOnePictTex[3] = 0;
    MnOnePictTex[4] = 0;
    MnOnePictTex[5] = 0;
    MnOnePictTex[6] = 0;
    MnOnePictTex[7] = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuop", MenuManualInit__FP9mgCMemoryPii);
int MenuManualKey() {
    return CManualPtr->KeyStep();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuop", MenuManualDraw__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuop", KeyStep__11CManualMenuFv);
void CManualMenu::CalcTex(void) {
    CMenuPosDataForm *bgForm;
    int slideIn;
    int slideInFlag;
    float *leftTop;
    int xy[2];
    float speed;
    float target;
    int columnShift;
    int shifted;
    signed char *listTbl;
    int list;
    CDC2Mes *mes;
    CMenuPosDataForm *panel;
    int itemPos[10][2];
    int item;
    int firstY;
    CMenuPosDataForm *form;
    MENUFORMPARTS_TYPE *bar[3];
    int scrollRange[2];
    int visibleTop;

    bgForm = LocalMenuBGForm;
    if (bgForm == NULL) {
        return;
    }
    slideIn = 0;
    slideInFlag = 0;
    leftTop = (float *)GetMenuMainFrameLeftTopPos(0);
    xy[0] = fptosi(leftTop[0]);
    xy[1] = fptosi(480.0f + leftTop[1]);
    if (GetMenuMainFrameEndFlag() == 0) {
        slideIn = 1;
        slideInFlag = 1;
        bgForm->x = (float)xy[0];
        bgForm->y = (float)xy[1];
    } else {
        bgForm->x = (float)xy[0];
    }
    bgForm->GetPutPosXY(at_1512__5, xy[0], xy[1]);
    speed = 3.5f;
    if (mode == 2 || mode == 1) {
        speed = 1.0f;
    }
    target = (float)(xy[1] - top * 24);
    CalcMenu1(target, &list_y, speed, speed, 0);
    if ((float)xy[1] < list_y) {
        list_y = target;
    }
    xy[1] = fptosi(list_y);
    columnShift = 0;
    shifted = 0;
    listTbl = manual_list_mesclstbl;
    for (list = 0; list < 5; list++) {
        firstY = xy[1];
        mes = MenuDCMsg[listTbl[list]];
        panel = MenuMesForm[listTbl[list]];
        for (item = 0; item < 10; item++) {
            itemPos[item][0] = xy[0] + columnShift;
            itemPos[item][1] = xy[1];
            xy[1] += 24;
            if (CheckNowEurope() != 0 && shifted == 0 && item >= 8) {
                columnShift = 8;
                shifted = 1;
            }
        }
        mes->SetMsgItemPos(&itemPos[0][0], 10);
        if (xy[1] < 0x48 || firstY > 0x186) {
            panel->draw_flag = 0;
        } else {
            panel->draw_flag = 1;
        }
    }
    bgForm->GetPutPosXY(at_1513__5, xy[0], xy[1]);
    form = MenuMesForm[3];
    if (form != NULL) {
        form->x = (float)xy[0];
        form->y = (float)xy[1];
    }
    bar[0] = bgForm->GetPartInfo(at_1514__5);
    bar[1] = bgForm->GetPartInfo(at_1515__2);
    bar[2] = bgForm->GetPartInfo(at_1516__2);
    bgForm->GetPutPosXY(at_1517__3, itemPos[0][0], itemPos[0][1]);
    MenuPosData->GetEtcTblValue(at_1518__2, scrollRange[0], scrollRange[1]);
    if (slideInFlag == 0) {
        visibleTop = top;
        LocalFunc_AdjustScrlBar__FPP18MENUFORMPARTS_TYPEPiPiiffi(bar, &itemPos[0][0], scrollRange,
                                                                 visibleTop, 46.0f, 10.0f, slideIn);
    }
    if (LocalMenuClipForm != NULL) {
        LocalMenuBGForm->GetPutPosXY(at_1519__2, xy[0], xy[1]);
        form = LocalMenuClipForm;
        form->x = (float)xy[0];
        form->y = (float)xy[1];
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuop", CalcCursorPosition__11CManualMenuFv);
int CMenuOption::KeyStep(void) {
    int finished;
    int moveType;
    int frameEnd;
    int changed;
    int step;
    int keys;
    int pushed;
    int prevChoice;

    finished = 0;
    moveType = 2;
    if (mode == 2) {
        moveType = 0;
    }
    if (MenuArg.open_type == MENU_OPEN_OPTION) {
        moveType = 2;
    }
    StepMainMenuIconMove__18CMenuPosDataManageFPiii(MenuPosData, GetCommonMenuModeID(), 7,
                                                    moveType);
    frameEnd = GetMenuMainFrameEndFlag();
    switch (mode) {
        case 1:
            if (this->step == 0 && ReadBGSync__Fv() == 0 && frameEnd != 0) {
                GamePad__2.KeyLock(0);
                MenuCommonInfo->SetWakuType(0);
                MenuCommonInfo->SetMoveMethod(2);
                cursor_jump = 1;
                mode = 0;
                ((CBaseMenuClass *)this)->ExeScript(at_1648__2);
                if (MenuArg.open_type == MENU_OPEN_OPTION) {
                    ((CBaseMenuClass *)this)->ExeScript(at_1649);
                    this->step = 1;
                    mode = 1;
                }
            }
            if (this->step == 1 && ((CBaseMenuClass *)this)->FadeCheckMenu() != 0) {
                this->step = 0;
                mode = 0;
            }
            break;
        case 2:
            if (MenuArg.open_type == MENU_OPEN_OPTION) {
                if (((CBaseMenuClass *)this)->FadeCheckMenu() != 0) {
                    return 1;
                }
                break;
            }
            if (frameEnd != 0) {
                ((CBaseMenuClass *)this)->ExeScript(at_1428__4);
                if (MenuConfigPtr != NULL) {
                    printf(at_1650__3, MenuConfigPtr->eye_reverse);
                    printf(at_1651__2, MenuConfigPtr->unk_37);
                    if (MenuConfigPtr->sound_mode != 0) {
                        CSnd.SetStereoMode(0);
                    } else {
                        CSnd.SetStereoMode(1);
                    }
                }
                MenuCommonInfo->SetMoveMethod(2);
                finished = 1;
            }
            break;
        case 0:
            changed = 0;
            MenuCommonInfo->CheckSelectKey();
            pushed = MenuCommonInfo->CheckPushButton();
            keys = MenuCommonInfo->CheckLRKey();
            step = MenuListSelectKeyCheck(keys, 9);
            if (MenuKeySelectCheck(step, &select, &top, 0, fptosi(config_option_num_i), 9,
                                   0) != 0) {
                changed = 1;
            }
            prevChoice = choice;
            if (keys & 4) {
                choice = prevChoice - 1;
            }
            if (keys & 8) {
                choice += 1;
            }
            if (choice < 0) {
                choice = 0;
            }
            if (choice_num[select] <= choice) {
                choice = choice_num[select] - 1;
            }
            if (prevChoice != choice) {
                changed = 1;
            }
            if (changed != 0) {
                MenuSePlay(0);
            }
            switch (ConvertCheckPushButton(pushed)) {
                case 1:
                    if (select == 12) {
                        config.caption_off = choice;
                    } else if (select == 13) {
                        config.unk_35 = choice;
                    } else if (select == 14) {
                        config.eye_reverse = choice;
                    } else if (select == 15) {
                        config.unk_37 = choice;
                    } else if (select != 8 || config.enemy_hp != 1) {
                        *value[select] = choice;
                        if (select == 7 && choice == 1) {
                            *value[8] = 1;
                        }
                    }
                    UpdateOptionForm();
                    MenuSePlay(1);
                    break;
                case 8:
                    MenuSePlay(1);
                    InitSV_CONFIG_OPTION((SV_CONFIG_OPTION *)&config);
                    UpdateOptionForm();
                    break;
                case 2:
                    mode = 2;
                    memcpy(MenuConfigPtr, &config, 0x40);
                    MenuCommonInfo->SetMoveMethod(-1);
                    MenuCommonInfo->SetWakuType(-1);
                    if (MenuArg.open_type == MENU_OPEN_OPTION) {
                        ((CBaseMenuClass *)this)->ExeScript(at_1652__2);
                    } else {
                        MenuMainFrameModeSet(9, 0);
                        ReturnMenuIntern(0);
                        MenuCommonInfo->SetWakuType(-1);
                        ((CBaseMenuClass *)this)->ExeScript(at_1429__3);
                    }
                    break;
            }
            break;
    }
    CalcTex();
    MenuPosData->FormStep();
    {
        IntPair pos = at_1614__2;
        IntPair size = at_1615__3;
        IntPair velocity = at_1616__2;
        int limit[2];
        char name[0x20];
        int rowNo;
        int choiceNo;

        switch (mode) {
            case 1:
                if (MenuArg.open_type != MENU_OPEN_OPTION) {
                    break;
                }
            case 0:
                rowNo = select;
                choiceNo = choice;
                if (rowNo < 10) {
                    sprintf(name, at_1653__2, rowNo, choiceNo);
                } else {
                    sprintf(name, at_1654__3, rowNo, choiceNo);
                }
                OptionButtonForm->GetPutPosXY(name, pos.a, pos.b);
                pos.a -= 2;
                pos.b -= 3;
                sprintf(name, at_1655__4, select);
                MenuPosData->GetEtcTblValue(name, size.a, size.b);
                MenuCommonInfo->SetWakuWH(0, size.a, size.b);
                MenuPosData->GetEtcTblValue(at_1656__4, limit[0], limit[1]);
                if (pos.b < limit[0]) {
                    pos.b = limit[0];
                }
                if (limit[1] < pos.b) {
                    pos.b = limit[1];
                }
                MenuCommonInfo->MenuPosStep(&pos.a, &velocity.a);
                break;
        }
        if (cursor_jump != 0) {
            MenuCommonInfo->MenuSetPos(pos.a, pos.b);
            cursor_jump = 0;
        }
    }
    return finished;
}
void CMenuOption::CalcTex(void) {
    CMenuPosDataForm *bgForm;
    int slideIn;
    int slideInFlag;
    float *leftTop;
    int xy[2];
    float speed;
    float target;
    signed char *listTbl;
    int list;
    CMenuPosDataForm *mesForm;
    CMenuPosDataForm *clipForm;
    int itemPos[10][2];
    int item;
    CMenuPosDataForm *form;
    MENUFORMPARTS_TYPE *bar[3];
    int scrollRange[2];

    bgForm = LocalMenuBGForm;
    if (bgForm == NULL) {
        return;
    }
    slideIn = 0;
    slideInFlag = 0;
    leftTop = (float *)GetMenuMainFrameLeftTopPos(0);
    xy[0] = fptosi(leftTop[0]);
    xy[1] = fptosi(480.0f + leftTop[1]);
    if (GetMenuMainFrameEndFlag() == 0) {
        slideIn = 1;
        slideInFlag = 1;
        bgForm->x = (float)xy[0];
        bgForm->y = (float)xy[1];
    } else {
        bgForm->x = (float)xy[0];
    }
    bgForm->GetPutPosXY(at_1512__5, xy[0], xy[1]);
    speed = 3.5f;
    if (mode == 2) {
        speed = 2.0f;
    }
    target = (float)(xy[1] - top * 24);
    CalcMenu1(target, &list_y, speed, speed, 0);
    if ((float)xy[1] < list_y) {
        list_y = target;
    }
    xy[1] = fptosi(list_y);
    listTbl = manual_list_mesclstbl;
    for (list = 0; list < 3; list++) {
        for (item = 0; item < 10; item++) {
            itemPos[item][0] = xy[0];
            itemPos[item][1] = xy[1];
            xy[1] += 24;
        }
        MenuDCMsg[listTbl[list]]->SetMsgItemPos(&itemPos[0][0], 10);
    }
    form = OptionButtonForm;
    if (form != NULL) {
        xy[1] = fptosi(list_y - 3.0f);
        form->x = (float)xy[0];
        form->y = (float)xy[1];
    }
    bgForm->GetPutPosXY(at_1513__5, xy[0], xy[1]);
    mesForm = MenuMesForm[3];
    if (mesForm != NULL) {
        mesForm->x = (float)xy[0];
        mesForm->y = (float)xy[1];
    }
    bar[0] = bgForm->GetPartInfo(at_1514__5);
    bar[1] = bgForm->GetPartInfo(at_1515__2);
    bar[2] = bgForm->GetPartInfo(at_1516__2);
    bgForm->GetPutPosXY(at_1517__3, itemPos[0][0], itemPos[0][1]);
    MenuPosData->GetEtcTblValue(at_1518__2, scrollRange[0], scrollRange[1]);
    if (slideInFlag == 0) {
        LocalFunc_AdjustScrlBar__FPP18MENUFORMPARTS_TYPEPiPiiffi(
            bar, &itemPos[0][0], scrollRange, top, config_option_num_f, 9.0f, slideIn);
    }
    if (LocalMenuClipForm != NULL) {
        bgForm->GetPutPosXY(at_1519__2, xy[0], xy[1]);
        clipForm = LocalMenuClipForm;
        clipForm->x = (float)xy[0];
        clipForm->y = (float)xy[1];
    }
}
void CMenuOption::DefaultButton(MENUFORMPARTS_TYPE **row) {
    int i;
    for (i = 0; i < 3; i++) {
        if (row[i] != NULL) {
            row[i]->rgba[0] = 0x40;
            row[i]->rgba[1] = 0x40;
            row[i]->rgba[2] = 0x40;
        }
    }
}
void CMenuOption::EnableButton(MENUFORMPARTS_TYPE *button) {
    button->rgba[0] = 0x80;
    button->rgba[1] = 0x80;
    button->rgba[2] = 0x80;
}
void CMenuOption::UpdateOptionForm(void) {
    SV_CONFIG_OPTION *config;
    MENUFORMPARTS_TYPE **row;
    int i;
    int offset;
    MENUFORMPARTS_TYPE **loopRow;

    if (OptionButtonForm != NULL) {
        config = &this->config;
        if (config != NULL) {
            row = this->button[0];
            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->cursor_save]);
            }
            row = this->button[1];
            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->vibration]);
            }
            row = this->button[2];
            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->message_speed]);
            }
            row = this->button[3];
            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->sound_mode]);
            }
            row = this->button[4];
            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->fast_time]);
            }
            loopRow = this->button[5];
            if (loopRow != NULL) {
                DefaultButton(loopRow);

                for (i = 0, offset = 0; i < 3; i++, offset += 4) {
                    if (config->map == i) {
                        EnableButton(*(MENUFORMPARTS_TYPE **)((u8 *)loopRow + offset));
                    }
                }
            }
            row = this->button[6];
            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->damage_off]);
            }
            row = this->button[7];
            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->enemy_hp]);
            }
            row = this->button[8];
            if (row != NULL) {
                DefaultButton(row);
                if (config->enemy_hp == 0) {
                    EnableButton(row[config->anger_counter]);
                }
            }
            row = this->button[9];
            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[*(int *)config->unk_24]);
            }
            row = this->button[10];
            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->monster_name]);
            }
            row = this->button[11];
            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[config->dof_off]);
            }
            row = this->button[12];
            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[(signed char)config->caption_off]);
            }
            row = this->button[13];
            if (row != NULL) {
                DefaultButton(row);
                EnableButton(row[(signed char)config->unk_35]);
            }
            row = this->button[14];
            if ((int)LanguageCode > 0) {
                if (row != NULL) {
                    DefaultButton(row);
                    EnableButton(row[config->eye_reverse]);
                }
                row = this->button[15];
                if (row != NULL) {
                    DefaultButton(row);
                    EnableButton(row[config->unk_37]);
                }
            }
        }
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuop", MenuOptionInit__FP9mgCMemoryPii);
int MenuOptionKey() {
    return CMenuOptionPtr->KeyStep();
}
void MenuOptionDraw() {
    MenuPosData->FormDraw();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuop", LocalFunc_AdjustScrlBar__FPP18MENUFORMPARTS_TYPEPiPiiffi);
void CSaveMenuClass::SetDlInfoMsg(int load, int show) {
    int message_no = 0xC08;
    if (load == 1) {
        message_no = 0xC09;
    }
    MenuDCMsg[7]->MakeMsg(message_no);
    MenuDCMsg[7]->StepMsg();
    CMenuPosDataForm *form;
    (form = MenuMesForm[7])->x = (mgScreenWidth - MenuDCMsg[7]->line_w[0]) >> 1;
    form->y = 168.0f;
    MenuMesForm[7]->draw_flag = show != 0;
}
void CSaveMenuClass::EnvSetSave(int kind) {
    CDC2Mes *save_mes;
    int func_no;
    int size_kind;
    int data_size;

    dl_base = 0;
    if (kind == 0) {
        func_no = 6;
        phase = 2;
        size_kind = 1;
    } else {
        func_no = 3;
        phase = 0xA;
        size_kind = 0;
    }
    MemoryCardPtr->file_no = select;
    MemoryCardPtr->SetFuncNo(func_no);
    data_size = MemoryCardPtr->GetSaveDataSize(size_kind);
    if (kind == 1) {
        data_size -= 0x1000;
    }
    save_mes = MenuDCMsg[2];
    save_mes->MsgPreset(0xA, LanguageCode);
    save_mes->push_button = 0;
    save_mes->SetAbsPos(8);
    save_mes->MakeMsg(0xBBF);
    save_mes->SetMsgVolumeNoOne(slot + 1);
    if (cursor_form != NULL) {
        cursor_form->draw_flag = 0;
    }
    InitMenuDl(dl_tex, data_size);
    SetDlInfoMsg(0, 1);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuop", KeyStep__14CSaveMenuClassFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuop", SaveFileListDraw__FRiPfi);
void SetMCIconData(u_int *pack, int slot) {
    SaveIconSet icons = at_2609__2;
    for (int i = 0; i < 3; i++) {
        MC_ICON_DATA *icon = &icons.file[i];
        icon->data = GetPackFile(pack, icon->name, &icon->size);
    }
    MemoryCardPtr->SetIconData(icons.file, slot);
}
int GetDngMapNo(int dungeon) {
    if (dungeon < 0) {
        return 0;
    }
    if (dungeon > 6) {
        return 0;
    }
    return SearchMapNo(dngmap_2627[dungeon]);
}
void SaveMapInfo(int dungeon) {
    memcpy(MenuMapInfoSave, &GetSaveData()->map_no, 0xC);
    int saved_dungeon = *(int *)((u8 *)GetSaveData() + kDungeonNoOffset);
    MenuMapInfoSave_DngNo = saved_dungeon;
    if (0 <= dungeon) {
        short *map_info = &GetSaveData()->map_no;
        CSaveData *save_data = GetSaveData();
        short previous = *map_info;
        save_data->prev_map_no = previous;
        map_info = &GetSaveData()->map_no;
        *map_info = GetDngMapNo(dungeon);
        saved_dungeon = *(int *)((u8 *)GetSaveData() + kDungeonNoOffset);
        MenuMapInfoSave_DngNo = saved_dungeon;
        *(int *)((u8 *)GetSaveData() + kDungeonNoOffset) = dungeon;
    }
}
void ResetMapInfo() {
    memcpy(&GetSaveData()->map_no, MenuMapInfoSave, 0xC);
    short dungeon_no = MenuMapInfoSave_DngNo;
    *(int *)((u8 *)GetSaveData() + kDungeonNoOffset) = dungeon_no;
}
void MenuSaveInit(mgCMemory *memory, int *texBlock, int mode) {
    CSaveMenuClass *menu;
    CMemoryCardManager *card;
    u8 *pack;
    unsigned int script_size;
    unsigned int blocks;
    short *mainMessages;
    CDC2Mes *window;
    int mesLayout;
    int i;
    int part;
    int dataSize;
    int freeSize;

    freeSize = memory->stGetRest();
    SaveMenuStack.stSetBuffer(memory->stGetTop(), freeSize);
    if ((menu = (CSaveMenuClass *)operator new(sizeof(CSaveMenuClass),
                                               (u_long128 *)SaveMenuStack.Alloc(0x1D))) != NULL) {
        __ct__14CBaseMenuClassFv(menu);
        *(void ***)((u_char *)menu + 0x10C) = __vt__14CSaveMenuClass;
        menu->first_step = 1;
        menu->slot = 0;
        menu->list_jump = 0;
        menu->top = 0;
        menu->select = 0;
        menu->mode = 0;
        menu->dl_base = 0;
        menu->save_kind = 1;
        menu->need_kb = 0;
        menu->save_kb = 0;
        menu->check_kb = 0;
        menu->chapter8_start = 0;
        menu->save_count = 0;
        menu->unk_154 = 0;
        menu->dl_tex = NULL;
        menu->title_form = NULL;
        menu->slot_form[0] = NULL;
        menu->slot_form[1] = NULL;
        menu->cursor_form = NULL;
        menu->list_form = NULL;
        menu->scrlbar_form = NULL;
        menu->scrlbar_parts[0] = NULL;
        menu->scrlbar_parts[1] = NULL;
        menu->scrlbar_parts[2] = NULL;
        menu->scrlbar_pos[0] = 0;
        menu->scrlbar_pos[1] = 9;
        menu->card_ok = 0;
        menu->card_changed = 0;
    }
    SaveMenuPtr = menu;
    if ((card = (CMemoryCardManager *)operator new(0x1100, (u_long128 *)SaveMenuStack.Alloc(0x112))) !=
        NULL) {
        card = (CMemoryCardManager *)__ct__18CMemoryCardManagerFv(card);
    }
    MemoryCardPtr = card;
    InitMenuReturnMsg(&SaveMenuStack);
    SetMenuReturnMsgCtrl(1);
    MemoryCardPtr->Initialize(&SaveMenuStack);
    MemoryCardPtr->SetBuff_Album(NULL);
    if (MemoryCardPtr->InitForMC() == 0) {
        SaveMenuStack.stAlloc64(0x800);
        SaveMenuPtr->SetTexBlock(texBlock);
        if (mode == 7) {
            SaveMenuPtr->mode = 0;
        }
        if (mode == 8) {
            SaveMenuPtr->mode = 1;
        }
        if (mode == 0x1E) {
            SaveMenuPtr->mode = 2;
        }
        SaveMenuStack.Align64();
        pack = (u8 *)(SaveMenuStack.stack + SaveMenuStack.stack_used);
        script_size = LoadFileMenu(at_2764, (u_long128 *)pack, 1);
        blocks = (script_size & 0xF) != 0 ? (script_size >> 4) + 1 : script_size >> 4;
        SaveMenuStack.Alloc(blocks);
        mgTexManager.EnterIMGFile((u_char *)GetPackFile((unsigned int *)pack, at_2765, NULL), SaveMenuPtr->tex_block[1],
                                  NULL, NULL);
        mgTexManager.EnterIMGFile((u_char *)GetPackFile((unsigned int *)pack, at_2766, NULL), SaveMenuPtr->tex_block[1],
                                  NULL, NULL);
        Tex_SaveFile = mgTexManager.GetTexture(at_2767, -1);
        SaveMenuPtr->dl_tex = GetMenuDlTexture();
        InitMenuDl(NULL, 0);
        mainMessages = GetMenuMainMessageBuffer();
        window = MenuDCMsg[2];
        window->SetMessData(GetSystemMesBuffer(), mainMessages);
        window = MenuDCMsg[3];
        window->SetMessData(mainMessages, mainMessages);
        window->MsgPreset(0x10, LanguageCode);
        window->MakeMsg(0xC1C);
        window = MenuDCMsg[4];
        window->SetMessData(mainMessages, mainMessages);
        window->MsgPreset(0x10, LanguageCode);
        window->MakeMsg(0xC1F);
        window = MenuDCMsg[5];
        window->SetMessData(mainMessages, mainMessages);
        window->MsgPreset(0x10, LanguageCode);
        window->MakeMsg(0xC20);
        window = MenuDCMsg[6];
        window->SetMessData(mainMessages, mainMessages);
        window->MsgPreset(0x10, LanguageCode);
        if (SaveMenuPtr->mode == 0) {
            window->MakeMsg(0xC3B);
        } else {
            window->MakeMsg(0xC3A);
        }
        MenuDCMsg[7]->SetMessData(mainMessages, mainMessages);
        MenuDCMsg[7]->MsgPreset(0x10);
        mesLayout = -4;
        if (CheckNowEurope() != 0) {
            mesLayout = 0;
        }
        for (i = 0; i < 13; i++) {
            if ((window = (CDC2Mes *)operator new(0x2A50, (u_long128 *)SaveMenuStack.Alloc(0x2A7))) !=
                NULL) {
                window = (CDC2Mes *)__ct__7CDC2MesFv(window);
            }
            SaveFileList[i] = window;
            SaveFileList[i]->SetMessData(mainMessages, mainMessages);
            SaveFileList[i]->MsgPreset(0x10);
            SaveFileList[i]->value_zero = 1;
            SaveFileList[i]->value_space = mesLayout;
        }
        SetMCIconData((unsigned int *)pack, 2);
        char *data = (char *)GetPackFile((unsigned int *)pack, at_2768, &dataSize);
        MenuDataAnalyze(data, dataSize, &SaveMenuStack);
        SaveMenuPtr->script = (char *)GetPackFile((unsigned int *)pack, at_2769, &SaveMenuPtr->script_size);
        ((CMenuPosDataManage *)MenuPosData)->AttachCommonTexInfo();
        MenuPosData->ResetTextureBlockNo(at_2767, SaveMenuPtr->tex_block[1]);
        MenuPosData->ResetTextureInfoAll();
        SaveMenuPtr->title_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_2770__2);
        SaveMenuPtr->slot_form[0] = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_2771__2);
        SaveMenuPtr->slot_form[1] = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_2772__2);
        SaveMenuPtr->cursor_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_2773__2);
        SaveMenuPtr->list_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_2774__2);
        SaveMenuPtr->scrlbar_form = (CMenuPosDataForm *)MenuPosData->GetFormInfo(at_2775__2);
        part = 0;
        if (SaveMenuPtr->scrlbar_form != NULL) {
            for (; part < 3; part++) {
                SaveMenuPtr->scrlbar_parts[part] =
                    SaveMenuPtr->scrlbar_form->GetPartInfo(b_2715[part]);
            }
        }
        AttachMessageForm();
        SaveMenuStack.Align64();
        if (SaveMenuPtr->mode == 0) {
            StopEnvSoundMenu(1);
            MenuMainScene->GetActiveBgmStatus(&SaveMenuPtr->bgm_status);
            MenuMainScene->StopBGM(0);
            MenuMainScene->LoadBGM(0x30, (u_long128 *)(SaveMenuStack.stack + SaveMenuStack.stack_used));
            MenuMainScene->PlayBGM(0, -1, 1.0f);
        }
        SaveMenuPtr->FadeInMenu(0x3C, 0.0f);
    }
}
int MenuSaveKey() {
    return SaveMenuPtr->KeyStep();
}
void MenuSaveDraw(void) {
    char text[0x200];
    MenuPosData->FormDraw();
    DrawMenuReturnMsg();
    if (DebugFlag != 0 && menu_debug_flag != 0) {
        CMenuFont menuFont;
        int mode = SaveMenuPtr->mode;
        if (mode == 1 || mode == 2) {
            menuFont.SetStr(at_2821__2);
            menuFont.SetPos(0x14, 0x28);
            menuFont.DrawDirect(menuFont.str, menuFont.pos_x, menuFont.pos_y);
        } else {
            menuFont.SetStr(at_2822);
            menuFont.SetPos(0x14, 0x28);
            menuFont.DrawDirect(menuFont.str, menuFont.pos_x, menuFont.pos_y);
        }
        sprintf(text, at_2823, MemoryCardPtr->GetSaveDataSize(0) / 1024);
        menuFont.SetStr(text);
        menuFont.SetPos(0x14, 0x3C);
        menuFont.DrawDirect(menuFont.str, menuFont.pos_x, menuFont.pos_y);
        sprintf(text, at_2824, 0x196);
        menuFont.SetStr(text);
        menuFont.SetPos(0x14, 0x50);
        menuFont.DrawDirect(menuFont.str, menuFont.pos_x, menuFont.pos_y);
        sprintf(text, at_2825, MemoryCardPtr->GetSaveDataSize(5));
        menuFont.SetStr(text);
        menuFont.SetPos(0x14, 0x64);
        menuFont.DrawDirect(menuFont.str, menuFont.pos_x, menuFont.pos_y);
        sprintf(text, at_2826__2, MemoryCardPtr->GetIconDataSize() / 1024);
        menuFont.SetStr(text);
        menuFont.SetPos(0x14, 0x78);
        menuFont.DrawDirect(menuFont.str, menuFont.pos_x, menuFont.pos_y);
        MC_CARD_INFO *card;
        int port = MemoryCardPtr->port;
        if (port == 0 || port == 1) {
            card = &MemoryCardPtr->card[port];
        } else {
            card = NULL;
        }
        sprintf(text, at_2827, card->type, card->formatted, card->free_size);
        menuFont.SetStr(text);
        menuFont.SetPos(0x14, 0x8C);
        menuFont.DrawDirect(menuFont.str, menuFont.pos_x, menuFont.pos_y);
    }
}
void SubGameCFGAnalyze(char *command) {
    MenuCommandAnalyze(SubGameSaveCFGBuffer, SubGameSaveCFGBufferSize, command);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuop", SubGameSaveInit__FP9mgCMemoryPii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuop", SubGameSaveKey__Fv);
void SubGameSaveDraw(void) {
    mgCTextureManager *textures = &mgTexManager;
    textures->ReloadTexture(SubGameSaveBlock, (sceVif1Packet *)0);
    if (Tex_SaveFile != NULL) {
        mgCDrawPrim *prim = GetMenuPrim();
        mgRect<int> rect;
        rect.Set(0x100, 0x100, 0x100, 0x100);
        DrawMenuTilePattern(prim, Tex_SaveFile, SubSaveTileXY, SubSaveTileXY, rect, 0, NULL);
    }
    textures->ReloadTexture(MenuArg.mes_tex_block, (sceVif1Packet *)0);
    MenuDCMsg[0]->DrawMsg();
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/menuop", __sinit_menuop_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", manual_boot_event_no__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", submap_table_1022__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", fillw_1125__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1315__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", tp_2083__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", conv_2316__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2609__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", dngmap_2627__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", b_2715__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1023__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1024__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1025__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1026__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1027__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1028__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1029__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1030__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1031__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1032__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1033__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1034__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1035__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1036__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1037__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1038__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1039__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1040__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1041__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1042__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1043__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1102__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1103__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1104__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1105__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1106__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1107__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1108__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1109__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1237__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1238__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1428__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1429__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1430__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1431__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1432__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1433__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1434__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1435__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1436__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1437__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1438__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1439__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1440__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1441__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1512__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1513__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1514__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1515__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1516__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1517__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1518__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1519__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1648__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1649__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1650__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1651__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1652__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1653__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1654__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1655__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1656__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1900__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1901__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1902__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1903__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1904__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1905__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1906__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2024__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2025__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2084__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2085__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2086__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2498__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2499__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2500__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2501__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2502__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2503__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2504__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2505__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2506__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2507__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2508__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2509__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2510__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2511__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2512__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2513__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2514__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2515__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2518__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2517__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2603__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2604__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2605__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2628__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2629__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2630__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2631__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2632__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2633__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2634__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2764__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2765__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2766__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2767__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2768__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2769__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2770__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2771__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2772__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2773__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2774__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2775__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2821__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2822__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2823__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2824__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2825__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2826__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2827__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2895__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3198__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3199__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3200__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3201__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3202__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3203__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3204__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3205__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3206__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_3207__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", D_0037B060__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", __vt__14CSaveMenuClass__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", __vt__11CMenuOption__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", __vt__11CManualMenu__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", manual_list_mesclstbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", config_option_num_i__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", config_option_num_f__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_1616__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", tbl_2023__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2335__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/menuop", at_2342__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(ManualMovie, 0x4);
INCLUDE_BSS(ManualMovieTex, 0x4);
INCLUDE_BSS(LocalMenuBGForm, 0x4);
INCLUDE_BSS(LocalMenuClipForm, 0x4);
INCLUDE_BSS(MenuReturnMsg, 0x4);
INCLUDE_BSS(MenuReturnMsgDrawFlag, 0x4);
INCLUDE_BSS(MovieBattleBGMPhase, 0x4);
INCLUDE_BSS(MoviePreBattleBGMVol_Save, 0x4);
INCLUDE_BSS(MoviePreBattleBGMVol, 0x4);
INCLUDE_BSS(Movie_DungeonFlag, 0x4);
INCLUDE_BSS(Movie_BossFlag, 0x4);
INCLUDE_BSS(MovieBgmBattleCheckStopFlag, 0x4);
INCLUDE_BSS(CManualPtr, 0x4);
INCLUDE_BSS(MovieViewFlag, 0x4);
INCLUDE_BSS(ManualMovieFadeCount_1253, 0x4);
INCLUDE_BSS(init_1254, 0x8);
INCLUDE_BSS(at_1306__5, 0x8);
INCLUDE_BSS(at_1342__3, 0x8);
INCLUDE_BSS(at_1523__2, 0x8);
INCLUDE_BSS(OptionButtonForm, 0x8);
INCLUDE_BSS(at_1614__2, 0x8);
INCLUDE_BSS(at_1615__3, 0x8);
INCLUDE_BSS(CMenuOptionPtr, 0x4);
INCLUDE_BSS(MemoryCardPtr, 0x4);
INCLUDE_BSS(SaveMenuPtr, 0x4);
INCLUDE_BSS(FormatCase_1968, 0x4);
INCLUDE_BSS(init_1969, 0x4);
INCLUDE_BSS(DarkClonicleFileMax_2004, 0x4);
INCLUDE_BSS(init_2005, 0x4);
INCLUDE_BSS(input_wait_counter_2067, 0x4);
INCLUDE_BSS(init_2068, 0x8);
INCLUDE_BSS(at_2115__3, 0x8);
INCLUDE_BSS(at_2276, 0x8);
INCLUDE_BSS(at_2319, 0x4);
INCLUDE_BSS(at_2326__2, 0x4);
INCLUDE_BSS(at_2327, 0x4);
INCLUDE_BSS(at_2328__2, 0x4);
INCLUDE_BSS(at_2330__2, 0x4);
INCLUDE_BSS(at_2331__2, 0x4);
INCLUDE_BSS(Tex_SaveFile, 0x4);
INCLUDE_BSS(space_2549, 0x4);
INCLUDE_BSS(init_2550, 0x4);
INCLUDE_BSS(MenuMapInfoSave_DngNo, 0x4);
INCLUDE_BSS(SubGameSaveOrLoad, 0x4);
INCLUDE_BSS(SubGameSaveOrLoadPhase, 0x4);
INCLUDE_BSS(SubGameSaveLoadStatus, 0x4);
INCLUDE_BSS(SubGameMCPort, 0x4);
INCLUDE_BSS(SubGameSaveBlock, 0x8);
INCLUDE_BSS(SubTrueTotalSaveFileSize, 0x4);
INCLUDE_BSS(SubCheckTotalSaveFileSize, 0x4);
INCLUDE_BSS(SubSaveTileXY, 0x4);
INCLUDE_BSS(SubGameSaveCFGBuffer, 0x4);
INCLUDE_BSS(SubGameSaveCFGBufferSize, 0x8);
INCLUDE_BSS(at_3070, 0x8);
INCLUDE_BSS(at_3091, 0x8);

// Uninitialised data (.bss)
INCLUDE_BSS(MnOnePictTex, 0x20);
INCLUDE_BSS(StaticMenuLocalStack, 0x30);
INCLUDE_BSS(StaticMenuLocalStack2, 0x30);
INCLUDE_BSS(SaveMenuStack, 0x30);
INCLUDE_BSS(SaveFileList, 0x38);
INCLUDE_BSS(MenuMapInfoSave, 0x18);
INCLUDE_BSS(SubGameDataBgm, 0x20);
