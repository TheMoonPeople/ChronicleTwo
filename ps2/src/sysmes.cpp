#include "sound.hpp"
#include "dataread.hpp"
#include "prespr.hpp"
#include "mg_drawprim.hpp"
#include <cstdio>
#include <cstring>
#include "font.hpp"
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
#include "sysmes.hpp"

extern "C" int CreateSystemMes__Fii(int, int);

extern ClsMes SystemMessage;
extern ClsMes SystemMessage2;
extern ClsMes SystemMessage3;
extern short SystemMesBuffer[];
extern short SysMesBuffer[];
#include "dataread.hpp"
#include "mainloop.hpp"
#include "nd_meswin.hpp"

// Data supplied by the assembly fallbacks until the unit's data is migrated.
extern short SystemMesBuffer[];
extern short SysMesBuffer[];
extern ClsMes SystemMessage;
extern ClsMes SystemMessage2;
extern ClsMes SystemMessage3;

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
void CreateSystemMes(void) {
    CreateSystemMes(0, 0);
    CreateSystemMes(1, 0);
    CreateSystemMes(2, 0);
}

#ifdef NONMATCHING
void CreateSystemMes(int index, int unused) {
    ClsMes *message = GetSystemMessage(index);
    message->Init();
    GetSystemMessage(index)->Preset(5);
    GetSystemMessage(index)->SetBuff(GetSysMesBuffer());
    GetSystemMessage(index)->SetBuff_system(GetSystemMesBuffer());
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sysmes", CreateSystemMes__Fii);
#endif

// Static initialiser (.init)
extern "C" void *__ct__6ClsMesFv(void *);

extern "C" void __sinit_sysmes_cpp() {
    SystemMesStack.Init();
    __ct__6ClsMesFv(&SystemMessage);
    __ct__6ClsMesFv(&SystemMessage2);
    __ct__6ClsMesFv(&SystemMessage3);
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

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sysmes", D_0037B000__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(SystemMesStack, 0x30);
INCLUDE_BSS(SystemMesBuffer, 0xD000);
INCLUDE_BSS(SysMesBuffer, 0x13880);
INCLUDE_BSS(SystemMessage, 0x2960);
INCLUDE_BSS(SystemMessage2, 0x2960);
INCLUDE_BSS(SystemMessage3, 0x2960);
