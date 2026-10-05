#include "common.h"
#include "event.hpp"
#include "event_func.hpp"
#include "scenesnd.hpp"
#include "mg_memory.hpp"
#include "mg_camera.hpp"
#include "mg_math.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "sceneseq.hpp"
#include "mainloop.hpp"
#include "dataread.hpp"
#include "menucommon.hpp"
#include "savedata.hpp"
#include "nd_meswin.hpp"
#include "sound.hpp"
#include "snd_mngr.hpp"
#include "dbg_font.hpp"
#include "character.hpp"
#include "gamepad.hpp"
#include <cstdio>
#include <cstring>
#include <cmath>
#include <libvu0.h>
#include <sifdev.h>
extern CRunScript EventScript;
extern char vv_984[];
extern char at_819__4[];
extern char at_820__4[];
extern char at_1002__4[];
extern char D_0037B038[];
extern CSound CSnd;

// Code (.text)
int LoadNpcTalkMes(mgCMemory *memory) {
    char path[0x4C];
    int size;
    u8 *buffer = (u8 *)(memory->stack + memory->stack_used);
    if (buffer == NULL) {
        return 0;
    }
    sprintf(path, at_819__4, GetNowChapter(GetSaveData()), LanguageCode);
    if (LoadFile2(path, buffer, &size, 0) == 0) {
        sprintf(path, at_820__4, LanguageCode);
        if (LoadFile2(path, buffer, &size, 0) == 0) {
            return 0;
        }
    }
    memory->Alloc(size / 16 + 1);
    EdEventInfo.npc_talk_text = (char *)buffer;
    EdEventInfo.npc_talk_size = size;
    return 1;
}
void ResetNpcTalkMes(void) {
    EdEventInfo.npc_talk_text = 0;
    EdEventInfo.npc_talk_size = 0;
}
int GetSquareEvent(void) {
    CSaveData *saveData;

    saveData = GetSaveData();
    if (saveData == NULL) {
        return 0;
    }
    if (saveData->CheckNowTourEvent() == 0) {
        return 0;
    }
    return saveData->CheckNowTourType();
}
void InitEvent(CScene *scene) {
    EventSeqInit();
    EventScene = scene;
    EdEventInfo.projection = mgGetProjection();
}
void SetEventScript(char *script, char *name, mgCMemory *memory) {
    RS_STACKDATA *stackData;
    RS_CALLDATA *callData;
    if (script == NULL || memory == NULL) {
        EventScript.DeleteProgram();
        return;
    }
    stackData = (RS_STACKDATA *)memory->Alloc(0x40);
    callData = (RS_CALLDATA *)memory->Alloc(0x180);
    EventScript.load((RS_PROG_HEADER *)script, stackData, 0x80, callData, 0x200);
    SetEventFunc(&EventScript);
}
int RunEvent(int event_no, CScene *scene) {
    EventScene = scene;
    return EventScript.run(event_no);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event", EventDoorLoop__Fii);
int StartEventSyori(void) {
    int started = -1;
    if (EdEventInfo.event_no != -1) {
        if (EventScene != NULL) {
            started = EdEventInfo.event_no;
            EventScene->RunEvent(EdEventInfo.event_no, NULL);
            EdEventInfo.event_no = -1;
        }
    }
    return started;
}
void SkipEventStart(void) {
    (&EventScene->fade)->FadeOut(30, EdEventInfo.skip_fade_color[0], EdEventInfo.skip_fade_color[1], EdEventInfo.skip_fade_color[2]);
    EdEventInfo.skip_state = 2;
}
void SkipEvent(void) {
    ClsMes *message = GetEventMessage(0);
    if (message != NULL) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->unk_1e40 = 0;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
    }
    message = GetEventMessage(1);
    if (message != NULL) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->unk_1e40 = 0;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
    }
    CSnd.StreamClose(1);
    EdEventInfo.stream_reading = 0;
    EventScript.skip();
}
bool CheckEventSkip(void) {
    return EdEventInfo.skip_state != 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event", EventLoop__Fv);
ClsMes *GetEventMessage(int index) {
    ClsMes *message;

    message = NULL;
    if (EventScene != NULL) {
        message = EventScene->GetMessage(index);
    }
    return message;
}
mgCCamera *GetActiveCamera(void) {
    mgCCamera *camera;

    camera = NULL;
    if (EventScene != NULL) {
        camera = (mgCCamera *)EventScene->GetCamera(EventScene->active_camera);
    }
    return camera;
}
CCharacter2 *GetCharacter(int index) {
    CCharacter2 *character;

    character = NULL;
    if (EventScene != NULL) {
        character = EventScene->GetCharacter(index);
    }
    return character;
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event", __sinit_event_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event", vv_984__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event", at_819__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event", at_820__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event", at_1002__4__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event", D_0037B038__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(EventScene, 0x4);
INCLUDE_BSS(cnt_1056, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(EventScript, 0x60);
