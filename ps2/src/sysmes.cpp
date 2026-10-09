#include "common.h"

#include <cstdio>
#include <cstring>

#include "dataread.hpp"
#include "font.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "prespr.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "sound.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"

// Code (.text)
ClsMes *GetSystemMessage() {
    return GetSystemMessage(0);
}

ClsMes *GetSystemMessage(int index) {
    if (index == 2) {
        return &SystemMessage3;
    }

    if (index == 1) {
        return &SystemMessage2;
    }

    return &SystemMessage;
}

void LoadSystemMes() {
    int size;

    switch (LanguageCode) {
        case LANG_JAPANESE:
            LoadFile("meswin/system.mes", SystemMesBuffer, &size);
            LoadFile("meswin/sysmes.mes", SysMesBuffer, NULL);
            break;
        case LANG_FRENCH:
            LoadFile("meswin/system_2.mes", SystemMesBuffer, &size);
            LoadFile("meswin/sysmes_2.mes", SysMesBuffer, NULL);
            break;
        case LANG_GERMAN:
            LoadFile("meswin/system_3.mes", SystemMesBuffer, &size);
            LoadFile("meswin/sysmes_3.mes", SysMesBuffer, NULL);
            break;
        case LANG_ITALIAN:
            LoadFile("meswin/system_4.mes", SystemMesBuffer, &size);
            LoadFile("meswin/sysmes_4.mes", SysMesBuffer, NULL);
            break;
        case LANG_SPANISH:
            LoadFile("meswin/system_5.mes", SystemMesBuffer, &size);
            LoadFile("meswin/sysmes_5.mes", SysMesBuffer, NULL);
            break;
        case LANG_ENGLISH:
        default:
            LoadFile("meswin/system_1.mes", SystemMesBuffer, &size);
            LoadFile("meswin/sysmes_1.mes", SysMesBuffer, NULL);
            break;
    }
}

short *GetSystemMesBuffer() {
    return SystemMesBuffer;
}

short *GetSysMesBuffer() {
    return SysMesBuffer;
}

void CreateSystemMes() {
    CreateSystemMes(0, 0);
    CreateSystemMes(1, 0);
    CreateSystemMes(2, 0);
}

void CreateSystemMes(int index, int unused) {
    GetSystemMessage(index)->Init();
    GetSystemMessage(index)->Preset(5);
    GetSystemMessage(index)->SetBuff(GetSysMesBuffer());
    GetSystemMessage(index)->SetBuff_system(GetSystemMesBuffer());
}

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", at_482__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", at_483__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", at_484__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", at_485__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", at_486__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", at_487__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", at_488__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", at_489__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", at_490__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", at_491__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", at_492__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", at_493__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", at_494__DATA);

// Uninitialised data (.bss)
mgCMemory SystemMesStack;
INCLUDE_BSS(SystemMesBuffer, 0xD000);
INCLUDE_BSS(SysMesBuffer, 0x13880);
ClsMes SystemMessage;
ClsMes SystemMessage2;
ClsMes SystemMessage3;
