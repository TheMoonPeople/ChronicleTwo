#include "common.h"

#include <libvu0.h>
#include <sifdev.h>

#include <cmath>
#include <cstdio>
#include <cstring>

#include "character.hpp"
#include "dataread.hpp"
#include "dbg_font.hpp"
#include "dng_main.hpp"
#include "editloop.hpp"
#include "effectlist.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "menucommon.hpp"
#include "mg_camera.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "padcontrol.hpp"
#include "runscript.hpp"
#include "savedata.hpp"
#include "sceneseq.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"

/**
 *
 * Interpreter running the active scene event script.
 *
 */
static CRunScript EventScript;

/**
 *
 * Scene receiving the active event script's commands.
 *
 */
CScene *EventScene;

// Code (.text)
int LoadNpcTalkMes(mgCMemory *memory) {
    char path[0x4C];
    int  size;
    u8  *buffer = reinterpret_cast<u8 *>(memory->stGetTop());

    if (buffer == NULL) {
        return 0;
    }

    sprintf(path, "event/talk/npc_talk_c%d_%d.txt", GetNowChapter(GetSaveData()), LanguageCode);

    if (LoadFile2(path, buffer, &size, 0) == 0) {
        sprintf(path, "event/talk/npc_talk_c2_%d.txt", LanguageCode);

        if (LoadFile2(path, buffer, &size, 0) == 0) {
            return 0;
        }
    }

    memory->Alloc(size / 16 + 1);
    EdEventInfo.npc_talk_text = (char *) buffer;
    EdEventInfo.npc_talk_size = size;
    return 1;
}

void ResetNpcTalkMes() {
    EdEventInfo.npc_talk_text = 0;
    EdEventInfo.npc_talk_size = 0;
}

int GetSquareEvent() {
    CSaveData *save_data;

    save_data = GetSaveData();

    if (save_data == NULL) {
        return 0;
    }

    if (save_data->CheckNowTourEvent() == 0) {
        return 0;
    }

    return save_data->CheckNowTourType();
}

void InitEvent(CScene *scene) {
    EventSeqInit();
    EventScene = scene;
    EdEventInfo.projection = mgGetProjection();
}

void SetEventScript(char *script, char *name, mgCMemory *memory) {
    RS_STACKDATA *stack_data;
    RS_CALLDATA  *call_data;

    if (script == NULL || memory == NULL) {
        EventScript.DeleteProgram();
        return;
    }

    stack_data = (RS_STACKDATA *) memory->Alloc(0x40);
    call_data = (RS_CALLDATA *) memory->Alloc(0x180);
    EventScript.load((RS_PROG_HEADER *) script, stack_data, 0x80, call_data, 0x200);
    SetEventFunc(&EventScript);
}

int RunEvent(int event_no, CScene *scene) {
    EventScene = scene;
    return EventScript.run(event_no);
}

int EventDoorLoop(int frame, int use_scene_se) {
    /**
     *
     * Camera offsets used by the door-opening sequence.
     *
     */
    static float vv[3][4] __attribute__((aligned(16))) = {
        {-94.0f, 35.5f, -106.5f, 1.0f},
        {105.0f, 32.5f, -28.5f,  1.0f},
        {113.0f, 34.5f, 82.5f,   1.0f}
    };

    float         character_pos[4];
    float         character_rot[4];
    float         camera_pos[4];
    float         camera_ref[4];
    sceVu0FMATRIX rotation;
    float         rotated_offset[4];

    character_pos[0] = EdEventInfo.func_fparam[0];
    character_pos[1] = EdEventInfo.func_fparam[1];
    character_pos[2] = EdEventInfo.func_fparam[2];
    character_rot[0] = 0.0f;
    character_rot[1] = EdEventInfo.func_fparam[3];
    character_rot[2] = 0.0f;
    camera_pos[0] = EdEventInfo.func_fparam[4];
    camera_pos[1] = EdEventInfo.func_fparam[5];
    camera_pos[2] = EdEventInfo.func_fparam[6];
    CCharacter2     *character = GetCharacter(EdEventInfo.func_iparam[0]);
    mgCCamera       *camera = GetActiveCamera();
    mgCCameraFollow *follow = (mgCCameraFollow *) GetActiveCamera();

    if (frame <= 0) {
        character->SetPosition(character_pos);
        character->SetRotation(character_rot);

        if (use_scene_se != 0) {
            character->SetMotion("\x83\x68\x83\x41\x8A\x4A\x82\xAF", 2);
        } else {
            character->SetMotion("\x83\x68\x83\x41\x8A\x4A\x82\xAF", 2);
        }
    } else if (frame == 25) {
        u32 bank = EventScene->se_base_id;

        if (use_scene_se != 0) {
            sndSePlay(bank, EdEventInfo.func_iparam[2], 0);
        } else {
            int effect;

            switch (EdEventInfo.door_type) {
                case 1:
                    effect = 2;
                    break;
                case 2:
                    effect = 4;
                    break;
                case 3:
                    effect = 6;
                    break;
                case 4:
                    effect = 8;
                    break;
                case 5:
                    effect = 13;
                    break;
                default:
                    effect = 0;
                    break;
            }

            sndSePlay(bank, effect, 0);
            EdEventInfo.door_type = 0;
        }
    } else if (frame == 30) {
        EventScene->fade.FadeOut(30, 0.0f, 0.0f, 0.0f);
    }

    if (frame > 60) {
        return 1;
    }

    camera_ref[0] = character_pos[0] + EdEventInfo.func_fparam[7];
    camera_ref[1] = character_pos[1] + EdEventInfo.func_fparam[8];
    camera_ref[2] = character_pos[2] + EdEventInfo.func_fparam[9];

    if (camera != NULL) {
        follow->FollowOff();
        camera->SetRef(camera_ref);
    }

    if (camera_pos[0] == 0.0f && camera_pos[1] == 0.0f && camera_pos[2] == 0.0f) {
        sceVu0UnitMatrix(rotation);
        sceVu0RotMatrixY(rotation, rotation, character_rot[1]);
        sceVu0ApplyMatrix(rotated_offset, rotation, vv[1]);
        sceVu0AddVector(rotated_offset, camera_ref, rotated_offset);

        if (camera != NULL) {
            camera->SetPos(rotated_offset);
        }
    } else if (camera != NULL) {
        camera->SetPos(camera_pos);
    }

    return 0;
}

int StartEventSyori() {
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

void SkipEventStart() {
    (&EventScene->fade)->FadeOut(30, EdEventInfo.skip_fade_color[0], EdEventInfo.skip_fade_color[1], EdEventInfo.skip_fade_color[2]);
    EdEventInfo.skip_state = 2;
}

void SkipEvent() {
    ClsMes *message = GetEventMessage(0);

    if (message != NULL) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->text_ptr = 0;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
    }

    message = GetEventMessage(1);

    if (message != NULL) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->text_ptr = 0;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
    }

    CSnd.StreamClose(1);
    EdEventInfo.stream_reading = 0;
    EventScript.skip();
}

bool CheckEventSkip() {
    return EdEventInfo.skip_state != 0;
}

int EventLoop() {
    /**
     *
     * Door-sequence frame counter while a scene event is active.
     *
     */
    static int cnt;

    int        request;
    int        index;
    mgCMemory *buffer;
    char      *program;
    char       path[0x40];
    char       map_name[0x20];
    char       directory[0x40];
    char       name[0x20];
    char       file_path[0x10C];
    int        file_size;

    switch (EdEventInfo.skip_state) {
        case EVENT_SKIP_NONE:
            break;
        case EVENT_SKIP_ENABLED:
            if (EdEventInfo.skip_button == 20 && PadCtrl.Btn(EdEventInfo.skip_button)) {
                SkipEventStart();
            }

            break;
        case EVENT_SKIP_FADE_OUT:
            if (EventScene->fade.FadeCheck()) {
                EventScene->fade.FadeOut(0, EdEventInfo.skip_fade_color[0], EdEventInfo.skip_fade_color[1], EdEventInfo.skip_fade_color[2]);
                EdEventInfo.skip_state = EVENT_SKIP_WAIT_SOUND;
            }

            break;
        case EVENT_SKIP_WAIT_SOUND:
            if (CSnd.StreamOpenState() == 0) {
                BreakReadBG();
                SkipEvent();
                EdEventInfo.skip_state = EVENT_SKIP_NONE;
                EdEventInfo.request = EVENT_REQUEST_NONE;
            }

            return EdEventInfo.request;
    }

    SetCamWorldCoordGyaku(EventScene->GetCamera(EventScene->active_camera));

    switch (EdEventInfo.command_mode) {
        case EVENT_COMMAND_DOOR:
            if (EventDoorLoop(cnt, 1)) {
                cnt = 0;
                EdEventInfo.command_mode = EVENT_COMMAND_RUN;
                EdEventInfo.request = EVENT_REQUEST_NONE;
            } else {
                cnt++;
            }

            break;
        case EVENT_COMMAND_SUB_MODE:
            EdEventInfo.command_mode = EVENT_COMMAND_RUN;
            EdEventInfo.request = EVENT_REQUEST_NONE;
            SetCamWorldCoord(EventScene->GetCamera(EventScene->active_camera));
            return EVENT_REQUEST_SUB_MODE;
        case EVENT_COMMAND_UNK_1:
        case EVENT_COMMAND_UNK_2:
            break;
        default:
            cnt = 0;
            EventScript.resume();
            break;
    }

    if (!EventScript.end) {
        EdEventStep();
    }

    SetCamWorldCoord(EventScene->GetCamera(EventScene->active_camera));
    request = EdEventInfo.request;

    switch (request) {
        case EVENT_REQUEST_GOTO:
            EdEventInfo.command_mode = EVENT_COMMAND_RUN;
            EdEventInfo.request = EVENT_REQUEST_NONE;
            return EVENT_REQUEST_GOTO;
        case EVENT_REQUEST_LOAD_SCRIPT:
            index = 0;

            do {
                if (EdEventInfo.script_name[index] == '/') {
                    break;
                }

                map_name[index] = EdEventInfo.script_name[index];
                index++;
            } while (index < 0x20);

            map_name[index] = 0;
            GetMapPath(path, map_name);
            DivPathName(path, directory, name);
            strcat(directory, &EdEventInfo.script_name[index + 1]);

            switch (GetNowLoopNo()) {
                case (int) LOOP_EDIT:
                    buffer = &ScriptBuffer__2;
                    break;
                case (int) LOOP_DUNGEON:
                    buffer = &BuffScriptData;
                    break;
                default:
                    EdEventEnd();
                    return EVENT_REQUEST_END;
            }

            strcpy(file_path, directory);
            buffer->stack_used = 0;
            buffer->lock = 0;
            buffer->Align64();
            program = reinterpret_cast<char *>(buffer->stGetTop());

            if (LoadFile2(file_path, program, &file_size, 0)) {
                buffer->Alloc(((unsigned int) file_size & 0xF) ? ((unsigned int) file_size >> 4) + 1 : (unsigned int) file_size >> 4);
                SetEventScript(program, NULL, buffer);
                index = StartEventSyori();

                if (GetNowLoopNo() == (int) LOOP_DUNGEON && index >= 0) {
                    EventScene->event_run = 0;
                    RunEvent(index, DngMainScene);
                }
            } else if (LoadFile2(directory, program, &file_size, 0)) {
                buffer->Alloc(((unsigned int) file_size & 0xF) ? ((unsigned int) file_size >> 4) + 1 : (unsigned int) file_size >> 4);
                SetEventScript(program, NULL, buffer);
                index = StartEventSyori();

                if (GetNowLoopNo() == (int) LOOP_DUNGEON && index >= 0) {
                    EventScene->event_run = 0;
                    RunEvent(index, DngMainScene);
                }
            }

            break;
        case EVENT_REQUEST_MAP_JUMP:
            EdEventInfo.request = EVENT_REQUEST_NONE;
            return EVENT_REQUEST_MAP_JUMP;
        case EVENT_REQUEST_INTERIOR:
            EdEventInfo.request = EVENT_REQUEST_NONE;
            return EVENT_REQUEST_INTERIOR;
        case EVENT_REQUEST_OUTSIDE:
            EdEventInfo.request = EVENT_REQUEST_NONE;
            return EVENT_REQUEST_OUTSIDE;
        case EVENT_REQUEST_EDIT_MODE:
            EdEventInfo.request = EVENT_REQUEST_NONE;
            return EVENT_REQUEST_EDIT_MODE;
        case EVENT_REQUEST_RESET_EDIT:
            EdEventInfo.request = EVENT_REQUEST_NONE;
            return EVENT_REQUEST_RESET_EDIT;
        case EVENT_REQUEST_RESTART_EDIT:
            EdEventInfo.request = EVENT_REQUEST_NONE;
            return EVENT_REQUEST_RESTART_EDIT;
        default:
            if (EventScript.end) {
                EdEventEnd();
                return EVENT_REQUEST_END;
            }

            return EVENT_REQUEST_NONE;
    }

    EdEventInfo.request = EVENT_REQUEST_NONE;
    return request;
}

ClsMes *GetEventMessage(int index) {
    ClsMes *message;

    message = NULL;

    if (EventScene != NULL) {
        message = EventScene->GetMessage(index);
    }

    return message;
}

mgCCamera *GetActiveCamera() {
    mgCCamera *camera;

    camera = NULL;

    if (EventScene != NULL) {
        camera = (mgCCamera *) EventScene->GetCamera(EventScene->active_camera);
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
