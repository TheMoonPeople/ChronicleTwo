#include "common.h"

#include <cstdio>
#include <cstring>

#include "dataread.hpp"
#include "editdata.hpp"
#include "font.hpp"
#include "gaiji.hpp"
#include "gamepad.hpp"
#include "hddinstall.hpp"
#include "mainloop.hpp"
#include "mainloop3.hpp"
#include "mapselect.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "savedata.hpp"
#include "snd_mngr.hpp"

/**
 *
 * Messages for an unrecoverable hard-disk read error in Japanese and English.
 *
 */
static char *emergency_mes[2] = {
    "\x93\xC7\x82\xDD\x8D\x9E\x82\xDD\x83G\x83\x89\x81[\x82\xAA\x94\xAD\x90\xB6\x82\xB5\x82\xDC\x82\xB5\x82\xBD\x81" "B\n"
    "\n"
    "\x81hPlayStation 2\x81h\x90\xEA\x97p\x83n\x81[\x83h\x83" "f\x83" "B\x83X\x83N\x83h\x83\x89\x83" "C\x83u\x82\xC9\x95t\x91\xAE\x82\xCC\x8E\xE6\x88\xB5\x90\xE0\x96\xBE\x8F\x91\x82\xCC\n"
    "\x8Ew\x8E\xA6\x82\xC9\x8F]\x82\xC1\x82\xC4\x81" "A\x81hPlayStation 2\x81h\x90\xEA\x97p\x83n\x81[\x83h\x83" "f\x83" "B\x83X\x83N\x83h\x83\x89\x83" "C\x83u\x82\xCC\x8F" "C\x95\x9C\n"
    "\x82\xF0\x8Ds\x82\xC1\x82\xC4\x82\xAD\x82\xBE\x82\xB3\x82\xA2\x81" "B",
    "error.",
};

/**
 *
 * Packet buffers for the hard-disk error display.
 *
 */
static mgCMemory buf0, buf1;

/**
 *
 * Data buffers for the hard-disk error display.
 *
 */
static mgCMemory dbuf0, dbuf1;

/**
 *
 * Texture-table storage for the hard-disk error display.
 *
 */
static mgCMemory Stack;

/**
 *
 * Connection status of the debug-menu hard disk.
 *
 */
static int HddConnect;

/**
 *
 * Status of the installed game image on the hard disk.
 *
 */
static int AppInstall;

/**
 *
 * Result of the free-space check for installation.
 *
 */
static int FreeSpace;

/**
 *
 * Selected hard-disk debug-menu command.
 *
 */
static int sel_hdd;

/**
 *
 * Whether an installation thread is active.
 *
 */
static int now_install;

/**
 *
 * Most recent hard-disk operation result.
 *
 */
static int error_code;

/**
 *
 * Memory used by the hard-disk installer.
 *
 */
static u_long128 *inst_work;

// Code (.text)
int FutureMapSelect() {
    // Selected row of the future-map debug menu.
    static int select = 0;

    // Future map selected by the debug menu.
    static int sel_map = 0;

    const int   map_ids[4] = {0x19, 0x1A, 0x52, 0x66};
    int         rows = 1;
    char        text[1024];
    char       *end = text;
    const char *cursor[2] = {"  ", ">>"};
    const char *next[2] = {"  ", "->"};
    const char *previous[2] = {"  ", "<-"};
    const char *flag_text[2] = {"X", "O"};
    int         analyze_count = 0;
    CEditData  *edit = GetSaveData()->GetEditData(sel_map);

    for (int index = 0; index < EDIT_ANALYZE_DATA_MAX; index++) {
        if (edit->GetAnalyzeData(sel_map, index) == NULL) {
            break;
        }

        analyze_count++;
    }

    rows += analyze_count;

    if (GamePad__2.Down(PAD_L1)) {
        select = 0;
        sel_map--;
    }

    if (GamePad__2.Down(PAD_R1)) {
        select = 0;
        sel_map++;
    }

    if (select == 0) {
        if (GamePad__2.Down(PAD_RIGHT)) {
            sel_map++;
        }

        if (GamePad__2.Down(PAD_LEFT)) {
            sel_map--;
        }

        if (sel_map < 0) {
            sel_map = 0;
        }

        if (sel_map >= 4) {
            sel_map = 3;
        }
    }

    if (GamePad__2.Down(PAD_DOWN)) {
        select++;
    }

    if (GamePad__2.Down(PAD_UP)) {
        select--;
    }

    if (select < 0) {
        select = rows - 1;
    }

    if (select >= rows) {
        select = 0;
    }

    end += sprintf(end, "\x96\xA2\x97\x88\x83\x7D\x83\x62\x83\x76\x91\x49\x91\xF0\n");
    end += sprintf(end, "%smap  %s %s %s\n", cursor[select == 0], previous[sel_map > 0],
                   GetMapTitle(map_ids[sel_map]), next[sel_map < 3]);

    for (int row = 0; row < analyze_count; row++) {
        EditAnalyzeDataSrc *data = edit->GetAnalyzeData(sel_map, row);
        int                 flag = edit->GetAnalyzeFlag(sel_map, row);

        if (data != NULL) {
            end += sprintf(end, "%s %s:%s\n", cursor[select == row + 1], flag_text[flag], data->message);
        } else {
            sprintf(end, "\n");
        }

        if (row + 1 == select && GamePad__2.Down(PAD_CIRCLE)) {
            edit->dbgSetAnalyzeFlag(sel_map, row, !flag);
        }
    }

    if ((select == 0 && GamePad__2.Down(PAD_CIRCLE)) || GamePad__2.Down(PAD_TRIANGLE)) {
        INIT_LOOP_ARG arg;
        arg.map_no = map_ids[sel_map];
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
    const char *connect_text[2] = {"disconnect", "connect"};
    const char *cursor[2] = {"  ", ">>"};
    char        text[1024];
    char       *end = text;
    end += sprintf(end, "HDD Debug Menu\n", connect_text);
    end += sprintf(end, "HDD       :%s\n", connect_text[HddConnect > 0]);
    end += sprintf(end, "Install   :");

    if (AppInstall > 0) {
        end += sprintf(end, "O\n");
    }

    if (AppInstall == 0) {
        end += sprintf(end, "X\n");
    }

    if (AppInstall < 0) {
        end += sprintf(end, "Err %d\n", AppInstall);
    }

    end += sprintf(end, "Free      :");

    if (FreeSpace > 0) {
        end += sprintf(end, "O\n");
    }

    if (FreeSpace == 0) {
        end += sprintf(end, "X\n");
    }

    if (FreeSpace < 0) {
        end += sprintf(end, "Err %d\n", FreeSpace);
    }

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
        if (GamePad__2.Down(PAD_DOWN)) {
            ++sel_hdd;
        }

        if (GamePad__2.Down(PAD_UP)) {
            --sel_hdd;
        }

        if (sel_hdd < HDD_MENU_UNINSTALL) {
            sel_hdd = HDD_MENU_UNINSTALL;
        }

        if (sel_hdd > HDD_MENU_MOUNT) {
            sel_hdd = HDD_MENU_MOUNT;
        }

        if (GamePad__2.Down(PAD_CIRCLE)) {
            if (sel_hdd == HDD_MENU_UNINSTALL) {
                if (GetMainFileDev() == FILE_DEV_HDD) {
                    ChangeDefaultFile();
                }

                error_code = UninstallApp();
                HddConnect = HddConectCheck(NULL);
                AppInstall = CheckAppInstall();
                FreeSpace = CheckInstallSpace();
            }

            if (sel_hdd == HDD_MENU_INSTALL && AppInstall == 0 && FreeSpace > 0 &&
                CreateInstallThread(inst_work, 0xA0000)) {
                now_install = 1;
            }

            if (sel_hdd == HDD_MENU_MOUNT) {
                error_code = GetMainFileDev() != FILE_DEV_HDD ? ChangeHddFile() : ChangeDefaultFile();
            }
        }

        if (GamePad__2.Down(PAD_CROSS)) {
            return HDD_MENU_CLOSED;
        }
    } else {
        if (GamePad__2.Down(PAD_CROSS)) {
            InstallCancel();
        }

        int result = StepInstallThread();

        if (GamePad__2.Down(PAD_TRIANGLE)) {
            InstallPause();
        }

        if (result <= 0) {
            error_code = result;
            now_install = 0;
            DeleteInstallThread();
            HddConnect = HddConectCheck(NULL);
            AppInstall = CheckAppInstall();
            FreeSpace = CheckInstallSpace();
        }

        end += sprintf(end, "%d%%\n", (int) GetInstallProgress());
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
    buf0.stSetBuffer(main_stack->stAlloc64(10000), 10000);
    buf1.stSetBuffer(main_stack->stAlloc64(10000), 10000);
    dbuf0.stSetBuffer(main_stack->stAlloc64(50000), 50000);
    dbuf1.stSetBuffer(main_stack->stAlloc64(50000), 50000);
    Stack.stSetBuffer(main_stack->stAlloc64(500000), 500000);
    mgSetPacketBuffer(&buf0, &buf1);
    mgSetDataBuffer(&dbuf0, &dbuf1, 1);
    SetTextureTable(100, 20, &Stack);
    mgCTextureManager *texture_manager = &mgTexManager;
    texture_manager->DeleteBlock(1);
    texture_manager->EnterIMGFile(GetGaijiImgPtr(), 1, NULL, NULL);
    ReLoadFontTexture(1);
    texture_manager->EnterIMGFile(GetFontTex2ImgPtr(), 1, NULL, NULL);

    // Frame counter wrapping after one hundred error-display iterations.
    static int col = 0;

    // Localized message shown by the hard-disk error display.
    static char *txt;

    if (LanguageCode >= 0 && LanguageCode < 2) {
        txt = emergency_mes[LanguageCode];
    }

    while (true) {
        mgSetBackGround(0.0f, 0.0f, 0.0f, 0.0f);
        mgBeginFrame(NULL);
        texture_manager->ReloadTexture(1, (sceVif1Packet *) NULL);

        if (txt != NULL) {
            GetDebugFont()->DrawDirect(txt, 20, 100);
        }

        mgEndFrame(NULL);
        col++;
        col %= 100;
    }
}
