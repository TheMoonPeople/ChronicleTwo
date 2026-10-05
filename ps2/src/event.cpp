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

#ifdef NONMATCHING
#include "character.hpp"
#include "dataread.hpp"
#include "dng_main.hpp"
#include "editloop.hpp"
#include "effectlist.hpp"
#include "event_func.hpp"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "menucommon.hpp"
#include "mg_camera.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "padcontrol.hpp"
#include "runscript.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include <cstdio>
#include <cstring>

CScene *EventScene;
static int door_frame;
static CRunScript EventScript;
extern float vv_984[3][4];

#endif

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

#ifdef NONMATCHING
int EventDoorLoop(int frame, int use_scene_se) {
    float character_pos[4] = { EdEventInfo.func_fparam[0], EdEventInfo.func_fparam[1], EdEventInfo.func_fparam[2], 0.0f };
    float character_rot[4] = { 0.0f, EdEventInfo.func_fparam[3], 0.0f, 0.0f };
    float camera_pos[4] = { EdEventInfo.func_fparam[4], EdEventInfo.func_fparam[5], EdEventInfo.func_fparam[6], 0.0f };
    CCharacter2 *character = GetCharacter(EdEventInfo.func_iparam[0]);
    mgCCamera *camera = GetActiveCamera();
    switch (frame) {
    case 25: {
        int effect = EdEventInfo.func_iparam[2];
        if (!use_scene_se) {
            switch (EdEventInfo.door_type) {
            case 1: effect = 2; break;
            case 2: effect = 4; break;
            case 3: effect = 6; break;
            case 4: effect = 8; break;
            case 5: effect = 13; break;
            default: effect = 0; break;
            }
            EdEventInfo.door_type = 0;
        }
        sndSePlay(EventScene->se_base_id, effect, 0);
        break;
    }
    case 30: EventScene->fade.FadeOut(30, 0.0f, 0.0f, 0.0f); break;
    default:
        character->SetPosition(character_pos);
        character->SetRotation(character_rot);
        character->SetMotion((char *)"\x83\x68\x83\x41\x8A\x4A\x82\xAF", 2);
        break;
    }
    if (frame >= 61) return 1;
    float camera_ref[4] = { character_pos[0] + EdEventInfo.func_fparam[7], character_pos[1] + EdEventInfo.func_fparam[8], character_pos[2] + EdEventInfo.func_fparam[9], 0.0f };
    if (camera != NULL) { ((mgCCameraFollow *)camera)->FollowOff(); camera->SetRef(camera_ref); }
    if (camera_pos[0] == 0.0f && camera_pos[1] == 0.0f && camera_pos[2] == 0.0f) {
        sceVu0FMATRIX rotation;
        float rotated_offset[4];
        sceVu0UnitMatrix(rotation);
        sceVu0RotMatrixY(rotation, rotation, character_rot[1]);
        sceVu0ApplyMatrix(rotated_offset, rotation, vv_984[1]);
        sceVu0AddVector(rotated_offset, camera_ref, rotated_offset);
        if (camera != NULL) camera->SetPos(rotated_offset);
    } else if (camera != NULL) camera->SetPos(camera_pos);
    return 0;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event", EventDoorLoop__Fii);
#endif
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

#ifdef NONMATCHING
static bool ReloadEventScript() {
    char map_name[0x20];
    char path[0x40], directory[0x40], name[0x40], file_path[0x40];
    int index = 0;
    while (index < 0x20 && EdEventInfo.script_name[index] != '/' && EdEventInfo.script_name[index] != 0) {
        map_name[index] = EdEventInfo.script_name[index]; ++index;
    }
    map_name[index] = 0;
    GetMapPath(path, map_name);
    DivPathName(path, directory, name);
    strcat(name, &EdEventInfo.script_name[index + 1]);
    mgCMemory *buffer;
    switch (GetNowLoopNo()) {
    case 1: buffer = &ScriptBuffer__2; break;
    case 2: buffer = &BuffScriptData; break;
    default: EdEventEnd(); return false;
    }
    strcpy(file_path, name);
    buffer->stack_used = 0;
    buffer->lock = 0;
    buffer->Align64();
    void *program = &buffer->stack[buffer->stack_used];
    int file_size;
    if (LoadFile2(file_path, program, &file_size, 0) || LoadFile2(name, program, &file_size, 0)) {
        buffer->Alloc((file_size + 15) / 16);
        SetEventScript((char *)program, NULL, buffer);
        int event_no = StartEventSyori();
        if (GetNowLoopNo() == 2 && event_no >= 0) {
            EventScene->event_run = 0;
            RunEvent(event_no, EventScene);
        }
    }
    return true;
}
int EventLoop() {
    if (EdEventInfo.skip_state == EVENT_SKIP_ENABLED && EdEventInfo.skip_button == 20 && PadCtrl.Btn(EdEventInfo.skip_button)) SkipEventStart();
    if (EdEventInfo.skip_state == EVENT_SKIP_FADE_OUT && EventScene->fade.FadeCheck()) {
        EventScene->fade.FadeOut(0, EdEventInfo.skip_fade_color[0], EdEventInfo.skip_fade_color[1], EdEventInfo.skip_fade_color[2]);
        EdEventInfo.skip_state = EVENT_SKIP_WAIT_SOUND;
    }
    if (EdEventInfo.skip_state == EVENT_SKIP_WAIT_SOUND) {
        if (CSnd.StreamOpenState() == 0) {
            BreakReadBG(); SkipEvent();
            EdEventInfo.skip_state = EVENT_SKIP_NONE;
            EdEventInfo.request = EVENT_REQUEST_NONE;
        }
        return EdEventInfo.request;
    }
    mgCCamera *camera = EventScene->GetCamera(EventScene->active_camera);
    SetCamWorldCoordGyaku(camera);
    if (EdEventInfo.command_mode == EVENT_COMMAND_DOOR) {
        if (EventDoorLoop(door_frame, 1)) {
            door_frame = 0;
            EdEventInfo.command_mode = EVENT_COMMAND_RUN;
            EdEventInfo.request = EVENT_REQUEST_NONE;
        } else ++door_frame;
    } else if (EdEventInfo.command_mode == EVENT_COMMAND_SUB_MODE) {
        EdEventInfo.command_mode = EVENT_COMMAND_RUN;
        EdEventInfo.request = EVENT_REQUEST_NONE;
        SetCamWorldCoord(camera);
        return EVENT_REQUEST_SUB_MODE;
    } else if (EdEventInfo.command_mode != EVENT_COMMAND_UNK_1 && EdEventInfo.command_mode != EVENT_COMMAND_UNK_2) {
        door_frame = 0;
        EventScript.resume();
    }
    if (!EventScript.end) EdEventStep();
    SetCamWorldCoord(EventScene->GetCamera(EventScene->active_camera));
    int request = EdEventInfo.request;
    switch (request) {
    case EVENT_REQUEST_RESTART_EDIT: case EVENT_REQUEST_RESET_EDIT: case EVENT_REQUEST_EDIT_MODE:
    case EVENT_REQUEST_OUTSIDE: case EVENT_REQUEST_INTERIOR: case EVENT_REQUEST_MAP_JUMP:
        EdEventInfo.request = EVENT_REQUEST_NONE; return request;
    case EVENT_REQUEST_LOAD_SCRIPT:
        if (!ReloadEventScript()) return EVENT_REQUEST_END;
        EdEventInfo.request = EVENT_REQUEST_NONE; return request;
    case EVENT_REQUEST_GOTO:
        EdEventInfo.command_mode = EVENT_COMMAND_RUN;
        EdEventInfo.request = EVENT_REQUEST_NONE; return request;
    default:
        if (EventScript.end) { EdEventEnd(); return EVENT_REQUEST_END; }
        return EVENT_REQUEST_NONE;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event", EventLoop__Fv);
#endif
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
#ifndef NONMATCHING
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event", __sinit_event_cpp);
#endif

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event", vv_984__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event", at_819__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event", at_820__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event", at_1002__4__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event", D_0037B038__DATA);

// Small uninitialised data (.sbss)
#ifndef NONMATCHING
INCLUDE_BSS(EventScene, 0x4);
INCLUDE_BSS(cnt_1056, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(EventScript, 0x60);
#endif
