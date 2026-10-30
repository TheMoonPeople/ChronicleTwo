#include "common.h"

#include <algorithm>
#include <cstdio>
#include <cstring>
#include <format>
#include <stdexcept>
#include <string>

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
    "\x93\xC7\x82\xDD\x8D\x9E\x82\xDD\x83G\x83\x89\x81[\x82\xAA\x94\xAD\x90\xB6\x82\xB5\x82\xDC\x82\xB5\x82\xBD\x81"
    "B\n"
    "\n"
    "\x81hPlayStation 2\x81h\x90\xEA\x97p\x83n\x81[\x83h\x83"
    "f\x83"
    "B\x83X\x83N\x83h\x83\x89\x83"
    "C\x83u\x82\xC9\x95t\x91\xAE\x82\xCC\x8E\xE6\x88\xB5\x90\xE0\x96\xBE\x8F\x91\x82\xCC\n"
    "\x8Ew\x8E\xA6\x82\xC9\x8F]\x82\xC1\x82\xC4\x81"
    "A\x81hPlayStation 2\x81h\x90\xEA\x97p\x83n\x81[\x83h\x83"
    "f\x83"
    "B\x83X\x83N\x83h\x83\x89\x83"
    "C\x83u\x82\xCC\x8F"
    "C\x95\x9C\n"
    "\x82\xF0\x8Ds\x82\xC1\x82\xC4\x82\xAD\x82\xBE\x82\xB3\x82\xA2\x81"
    "B",
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
 * Non-zero while an installation thread is running.
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

int FutureMapSelect() {
    // Selected row of the future-map debug menu.
    static int select = 0;

    // Future map selected by the debug menu.
    static int sel_map = 0;

    const int   map_ids[4] = {0x19, 0x1A, 0x52, 0x66};
    int         rows = 1;
    std::string text;
    const char *cursor[2] = {"  ", ">>"};
    const char *next[2] = {"  ", "->"};
    const char *previous[2] = {"  ", "<-"};
    const char *flag_text[2] = {"X", "O"};
    int         analyze_count = 0;

    if (GamePad__2.Down(PAD_L1)) {
        select = 0;
        sel_map--;
    }

    if (GamePad__2.Down(PAD_R1)) {
        select = 0;
        sel_map++;
    }

    sel_map = std::clamp(sel_map, 0, 3);

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

    CEditData *edit = GetSaveData()->GetEditData(sel_map);
    for (int index = 0; index < EDIT_ANALYZE_DATA_MAX; index++) {
        if (edit->GetAnalyzeData(sel_map, index) == nullptr) {
            break;
        }
        analyze_count++;
    }
    rows += analyze_count;

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

    text = "\x96\xA2\x97\x88\x83\x7D\x83\x62\x83\x76\x91\x49\x91\xF0\n";
    text += std::format("{}map  {} {} {}\n", cursor[select == 0], previous[sel_map > 0],
                        GetMapTitle(map_ids[sel_map]), next[sel_map < 3]);

    for (int row = 0; row < analyze_count; row++) {
        EditAnalyzeDataSrc *data = edit->GetAnalyzeData(sel_map, row);
        int                 flag = edit->GetAnalyzeFlag(sel_map, row);

        if (data != nullptr) {
            text += std::format("{} {}:{}\n", cursor[select == row + 1], flag_text[flag != 0], data->message);
        } else {
            text += '\n';
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

        NextLoop(LOOP_EDIT, arg);
        return FUTURE_MAP_SELECT_CHOSEN;
    }

    GetDebugFont()->DrawDirect(text.data(), 10, 10);
    return GamePad__2.Down(PAD_CROSS) ? FUTURE_MAP_SELECT_CLOSED : FUTURE_MAP_SELECT_CONTINUE;
}

void InitHDDMenu(u_long128 *work) {
    HddConnect = HddConectCheck(nullptr);
    AppInstall = CheckAppInstall();
    int space = CheckInstallSpace();
    inst_work = work;
    sel_hdd = HDD_MENU_INSTALL;
    FreeSpace = space;
    now_install = false;
    error_code = 0;
}

int HDDMenuLoop() {
    const char *connect_text[2] = {"disconnect", "connect"};
    const char *cursor[2] = {"  ", ">>"};
    std::string text = std::format("HDD Debug Menu\nHDD       :{}\nInstall   :", connect_text[HddConnect > 0]);

    if (AppInstall > 0) {
        text += "O\n";
    }

    if (AppInstall == 0) {
        text += "X\n";
    }

    if (AppInstall < 0) {
        text += std::format("Err {}\n", AppInstall);
    }

    text += "Free      :";

    if (FreeSpace > 0) {
        text += "O\n";
    }

    if (FreeSpace == 0) {
        text += "X\n";
    }

    if (FreeSpace < 0) {
        text += std::format("Err {}\n", FreeSpace);
    }

    text += std::format("{}Uninstall\n{}Install\n", cursor[sel_hdd == HDD_MENU_UNINSTALL], cursor[sel_hdd == HDD_MENU_INSTALL]);

    if (GetMainFileDev() != FILE_DEV_HDD) {
        text += std::format("{}HDD Mount\n", cursor[sel_hdd == HDD_MENU_MOUNT]);
    } else {
        text += std::format("{}HDD Unmount\n", cursor[sel_hdd == HDD_MENU_MOUNT]);
    }

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
                HddConnect = HddConectCheck(nullptr);
                AppInstall = CheckAppInstall();
                FreeSpace = CheckInstallSpace();
            }

            if (sel_hdd == HDD_MENU_INSTALL && AppInstall == 0 && FreeSpace > 0 &&
                CreateInstallThread(inst_work, 0xA0000)) {
                now_install = true;
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
            now_install = false;
            DeleteInstallThread();
            HddConnect = HddConectCheck(nullptr);
            AppInstall = CheckAppInstall();
            FreeSpace = CheckInstallSpace();
        }

        text += std::format("{}%\n", static_cast<int>(GetInstallProgress()));
    }

    text += std::format("\nerr code = {}\n", error_code);
    GetDebugFont()->DrawDirect(text.data(), 10, 10);
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
    if (main_stack == nullptr) {
        throw std::length_error("emergency menu arena is unavailable");
    }
    main_stack->stReset();
    const auto reserve = [main_stack](int quadwords) {
        auto *storage = main_stack->stAlloc64(quadwords);
        if (storage == nullptr) {
            throw std::length_error("emergency menu arena exhausted");
        }
        return storage;
    };
    u_long128 *vif0 = reserve(10000);
    u_long128 *vif1 = reserve(10000);
    mgInitVif1Packet(vif0, vif1, 160000);
    buf0.stSetChildBuffer(*main_stack, reserve(10000), 10000);
    buf1.stSetChildBuffer(*main_stack, reserve(10000), 10000);
    dbuf0.stSetChildBuffer(*main_stack, reserve(50000), 50000);
    dbuf1.stSetChildBuffer(*main_stack, reserve(50000), 50000);
    Stack.stSetChildBuffer(*main_stack, reserve(500000), 500000);
    mgSetPacketBuffer(&buf0, &buf1);
    mgSetDataBuffer(&dbuf0, &dbuf1, 1);
    SetTextureTable(100, 20, &Stack);
    mgCTextureManager *texture_manager = &mgTexManager;
    texture_manager->DeleteBlock(1);
    texture_manager->EnterIMGFile(GetGaijiImgPtr(), 1, nullptr, nullptr);
    ReLoadFontTexture(1);

    // Frame counter wrapping after one hundred error-display iterations.
    static int col = 0;

    // Localized message shown by the hard-disk error display.
    static char *txt;

    if (LanguageCode >= LANG_JAPANESE && LanguageCode <= LANG_ENGLISH) {
        txt = emergency_mes[LanguageCode];
    }

    while (true) {
        mgSetBackGround(0.0f, 0.0f, 0.0f, 0.0f);
        mgBeginFrame(nullptr);
        texture_manager->ReloadTexture(1, (sceVif1Packet *) nullptr);

        if (txt != nullptr) {
            GetDebugFont()->DrawDirect(txt, 20, 100);
        }

        mgEndFrame(nullptr);
        col++;
        col %= 100;
    }
}
