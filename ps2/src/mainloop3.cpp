#include "common.h"
#include "mainloop3.hpp"
#include "hddinstall.hpp"
#include "dataread.hpp"
#include "editdata.hpp"
#include "font.hpp"
#include "gaiji.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "savedata.hpp"
#include "snd_mngr.hpp"
#include <cstdio>
#include <cstring>

extern CGamePad GamePad__2;
extern int select_795, sel_map_798;
extern char init_796, init_799;
extern int col_962;
extern char init_963;
extern char *txt_965;
extern char *emergency_mes[2];
extern const char at_882__5[];
extern mgCMemory buf0__2, buf1__2, dbuf0, dbuf1, Stack__2;

extern int HddConnect;
extern int AppInstall;
extern int FreeSpace;
extern int sel_hdd;
extern int now_install;
extern int error_code;
extern u_long128 *inst_work;

// Code (.text)
int FutureMapSelect() {
    if (init_796 == 0) {
        select_795 = 0;
        init_796 = 1;
    }
    if (init_799 == 0) {
        sel_map_798 = 0;
        init_799 = 1;
    }

    const int map_ids[4] = {0x19, 0x1A, 0x52, 0x66};
    int rows = 1;
    char text[1024];
    char *end = text;
    const char *cursor[2] = {"  ", ">>"};
    const char *next[2] = {"  ", "->"};
    const char *previous[2] = {"  ", "<-"};
    const char *flag_text[2] = {"X", "O"};
    int analyze_count = 0;
    CEditData *edit = GetSaveData()->GetEditData(sel_map_798);
    for (int index = 0; index < EDIT_ANALYZE_DATA_MAX; index++) {
        if (edit->GetAnalyzeData(sel_map_798, index) == NULL) {
            break;
        }
        analyze_count++;
    }
    rows += analyze_count;

    if (GamePad__2.Down(PAD_L1)) {
        select_795 = 0;
        sel_map_798--;
    }
    if (GamePad__2.Down(PAD_R1)) {
        select_795 = 0;
        sel_map_798++;
    }
    if (select_795 == 0) {
        if (GamePad__2.Down(PAD_RIGHT)) {
            sel_map_798++;
        }
        if (GamePad__2.Down(PAD_LEFT)) {
            sel_map_798--;
        }
        if (sel_map_798 < 0) {
            sel_map_798 = 0;
        }
        if (sel_map_798 >= 4) {
            sel_map_798 = 3;
        }
    }
    if (GamePad__2.Down(PAD_DOWN)) {
        select_795++;
    }
    if (GamePad__2.Down(PAD_UP)) {
        select_795--;
    }
    if (select_795 < 0) {
        select_795 = rows - 1;
    }
    if (select_795 >= rows) {
        select_795 = 0;
    }

    end += sprintf(end, "\x96\xA2\x97\x88\x83\x7D\x83\x62\x83\x76\x91\x49\x91\xF0\n");
    end += sprintf(end, "%smap  %s %s %s\n", cursor[select_795 == 0], previous[sel_map_798 > 0],
                   GetMapTitle(map_ids[sel_map_798]), next[sel_map_798 < 3]);
    for (int row = 0; row < analyze_count; row++) {
        EditAnalyzeDataSrc *data = edit->GetAnalyzeData(sel_map_798, row);
        int flag = edit->GetAnalyzeFlag(sel_map_798, row);
        if (data != NULL) {
            end += sprintf(end, "%s %s:%s\n", cursor[select_795 == row + 1], flag_text[flag], data->message);
        } else {
            sprintf(end, "\n");
        }
        if (row + 1 == select_795 && GamePad__2.Down(PAD_CIRCLE)) {
            edit->dbgSetAnalyzeFlag(sel_map_798, row, !flag);
        }
    }
    if ((select_795 == 0 && GamePad__2.Down(PAD_CIRCLE)) || GamePad__2.Down(PAD_TRIANGLE)) {
        INIT_LOOP_ARG arg;
        arg.map_no = map_ids[sel_map_798];
        arg.floor_no = 0;
        arg.event_no = 99;
        if (GamePad__2.Down(PAD_TRIANGLE)) {
            arg.event_no = 100;
        }
        NextLoop(1, arg);
        return FUTURE_MAP_SELECT_CHOSEN;
    }
    GetDebugFont()->DrawDirect(text, 10, 10);
    return GamePad__2.Down(PAD_CROSS) ? FUTURE_MAP_SELECT_CLOSED : FUTURE_MAP_SELECT_CONTINUE;
}
void InitHDDMenu(u_long128 *work) {
    HddConnect = HddConectCheck(0);
    AppInstall = CheckAppInstall();
    int space = CheckInstallSpace();
    inst_work = work;
    sel_hdd = HDD_MENU_INSTALL;
    FreeSpace = space;
    now_install = 0;
    error_code = 0;
}
int HDDMenuLoop() {
    const char *connect_text[2] = {"disconnect", at_882__5};
    const char *cursor[2] = {"  ", ">>"};
    char text[1024];
    char *end = text;
    end += sprintf(end, "HDD Debug Menu\n", connect_text);
    end += sprintf(end, "HDD       :%s\n", connect_text[HddConnect > 0]);
    end += sprintf(end, "Install   :");
    if (AppInstall > 0) end += sprintf(end, "O\n");
    if (AppInstall == 0) end += sprintf(end, "X\n");
    if (AppInstall < 0) end += sprintf(end, "Err %d\n", AppInstall);
    end += sprintf(end, "Free      :");
    if (FreeSpace > 0) end += sprintf(end, "O\n");
    if (FreeSpace == 0) end += sprintf(end, "X\n");
    if (FreeSpace < 0) end += sprintf(end, "Err %d\n", FreeSpace);
    end += sprintf(end, "%sUninstall\n", cursor[sel_hdd == HDD_MENU_UNINSTALL]);
    end += sprintf(end, "%sInstall\n", cursor[sel_hdd == HDD_MENU_INSTALL]);
    int mount_length;
    if (GetMainFileDev() != FILE_DEV_HDD) {
        mount_length = sprintf(end, "%sHDD Mount\n", cursor[sel_hdd == HDD_MENU_MOUNT]);
    } else {
        mount_length = sprintf(end, "%sHDD Unmount\n", cursor[sel_hdd == HDD_MENU_MOUNT]);
    }
    end += mount_length;
    if (!now_install) {
        if (GamePad__2.Down(PAD_DOWN)) ++sel_hdd;
        if (GamePad__2.Down(PAD_UP)) --sel_hdd;
        if (sel_hdd < HDD_MENU_UNINSTALL) sel_hdd = HDD_MENU_UNINSTALL;
        if (sel_hdd > HDD_MENU_MOUNT) sel_hdd = HDD_MENU_MOUNT;
        if (GamePad__2.Down(PAD_CIRCLE)) {
            if (sel_hdd == HDD_MENU_UNINSTALL) {
                if (GetMainFileDev() == FILE_DEV_HDD) ChangeDefaultFile();
                error_code = UninstallApp();
                HddConnect = HddConectCheck(NULL);
                AppInstall = CheckAppInstall();
                FreeSpace = CheckInstallSpace();
            }
            if (sel_hdd == HDD_MENU_INSTALL && AppInstall == 0 && FreeSpace > 0 &&
                CreateInstallThread(inst_work, 0xA0000)) now_install = 1;
            if (sel_hdd == HDD_MENU_MOUNT)
                error_code = GetMainFileDev() != FILE_DEV_HDD ? ChangeHddFile() : ChangeDefaultFile();
        }
        if (GamePad__2.Down(PAD_CROSS)) return HDD_MENU_CLOSED;
    } else {
        if (GamePad__2.Down(PAD_CROSS)) InstallCancel();
        int result = StepInstallThread();
        if (GamePad__2.Down(PAD_TRIANGLE)) InstallPause();
        if (result <= 0) {
            error_code = result;
            now_install = 0;
            DeleteInstallThread();
            HddConnect = HddConectCheck(NULL);
            AppInstall = CheckAppInstall();
            FreeSpace = CheckInstallSpace();
        }
        end += sprintf(end, "%d%%\n", (int)GetInstallProgress());
    }
    sprintf(end, "\nerr code = %d\n", error_code);
    GetDebugFont()->DrawDirect(text, 10, 10);
    return HDD_MENU_CONTINUE;
}

int EmergencyMessage(int error) {
    if (error >= 0) {
        return 0;
    }
    if (error != -5 && error != -0x10005) {
        return 0;
    }
    mgWaitFrame();
    sndSeAllStop(-1);
    mgCMemory *main_stack = GetMainStack();
    main_stack->stack_used = 0;
    main_stack->lock = 0;
    u_long128 *vif0 = main_stack->stAlloc64(10000);
    u_long128 *vif1 = main_stack->stAlloc64(10000);
    mgInitVif1Packet(vif0, vif1, 160000);
    buf0__2.stSetBuffer(main_stack->stAlloc64(10000), 10000);
    buf1__2.stSetBuffer(main_stack->stAlloc64(10000), 10000);
    dbuf0.stSetBuffer(main_stack->stAlloc64(50000), 50000);
    dbuf1.stSetBuffer(main_stack->stAlloc64(50000), 50000);
    Stack__2.stSetBuffer(main_stack->stAlloc64(500000), 500000);
    mgSetPacketBuffer(&buf0__2, &buf1__2);
    mgSetDataBuffer(&dbuf0, &dbuf1, 1);
    SetTextureTable(100, 20, &Stack__2);
    mgCTextureManager *texture_manager = &mgTexManager;
    texture_manager->DeleteBlock(1);
    texture_manager->EnterIMGFile(GetGaijiImgPtr(), 1, NULL, NULL);
    ReLoadFontTexture(1);
    texture_manager->EnterIMGFile(GetFontTex2ImgPtr(), 1, NULL, NULL);
    if (init_963 == 0) {
        col_962 = 0;
        init_963 = 1;
    }
    if (LanguageCode >= 0 && LanguageCode < 2) {
        txt_965 = emergency_mes[LanguageCode];
    }
    while (true) {
        mgSetBackGround(0.0f, 0.0f, 0.0f, 0.0f);
        mgBeginFrame(NULL);
        texture_manager->ReloadTexture(1, (sceVif1Packet *)NULL);
        if (txt_965 != NULL) {
            GetDebugFont()->DrawDirect(txt_965, 20, 100);
        }
        mgEndFrame(NULL);
        col_962++;
        col_962 %= 100;
    }
}

// Static initialiser (.init)
extern "C" void __sinit_mainloop3_cpp() {
    buf0__2.Init();
    buf1__2.Init();
    dbuf0.Init();
    dbuf1.Init();
    Stack__2.Init();
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_801__5__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_802__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_803__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_805__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_807__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_809__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_810__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_870__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_871__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_872__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_873__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_881__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_882__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_939__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_940__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_941__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_942__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_943__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_944__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_945__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_946__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_947__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_948__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_949__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_950__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_951__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_952__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_953__5__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", D_0037B09C__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_804__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_806__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_808__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_811__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_883__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", at_884__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mainloop3", emergency_mes__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(select_795, 0x4);
INCLUDE_BSS(init_796, 0x4);
INCLUDE_BSS(sel_map_798, 0x4);
INCLUDE_BSS(init_799, 0x4);
INCLUDE_BSS(HddConnect, 0x4);
INCLUDE_BSS(AppInstall, 0x4);
INCLUDE_BSS(FreeSpace, 0x4);
INCLUDE_BSS(sel_hdd, 0x4);
INCLUDE_BSS(now_install, 0x4);
INCLUDE_BSS(error_code, 0x4);
INCLUDE_BSS(inst_work, 0x4);
INCLUDE_BSS(col_962, 0x4);
INCLUDE_BSS(init_963, 0x4);
INCLUDE_BSS(txt_965, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(buf0__2, 0x30);
INCLUDE_BSS(buf1__2, 0x30);
INCLUDE_BSS(dbuf0, 0x30);
INCLUDE_BSS(dbuf1, 0x30);
INCLUDE_BSS(Stack__2, 0x30);
