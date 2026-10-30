#include "common.h"

#include <libvu0.h>
#include <sifdev.h>

#include <cmath>
#include <cstddef>
#include <cstdio>
#include <cstring>
#include <span>
#include <string_view>

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
#include "text/bounded.hpp"

/**
 *
 * Interpreter running the active scene event script.
 *
 */
static CRunScript EventScript;

namespace {
/**
 *
 * Identifies the current use of the permanent native event stack.
 *
 */
std::uint64_t event_script_generation = 0;

} // namespace

/**
 *
 * Scene receiving the active event script's commands.
 *
 */
CScene *EventScene;

int LoadNpcTalkMes(mgCMemory *memory) {
    char path[0x4C];
    int  size = {};
    if (memory == nullptr || memory->lock != 0) {
        return 0;
    }
    const auto available = dc2::memory::RemainingBytes(*memory);
    if (available.size() <= 2 * sizeof(u_long128)) {
        return 0;
    }
    const auto destination = available.first(available.size() - 2 * sizeof(u_long128));
    auto      *buffer = destination.data();

    const int primary_length = std::snprintf(path, sizeof path, "event/talk/npc_talk_c%d_%d.txt", GetNowChapter(GetSaveData()), LanguageCode);
    if (primary_length < 0 || static_cast<std::size_t>(primary_length) >= sizeof path) {
        return 0;
    }

    if (LoadFile2(path, destination, &size, 0) == 0) {
        const int fallback_length = std::snprintf(path, sizeof path, "event/talk/npc_talk_c2_%d.txt", LanguageCode);
        if (fallback_length < 0 || static_cast<std::size_t>(fallback_length) >= sizeof path) {
            return 0;
        }

        if (LoadFile2(path, destination, &size, 0) == 0) {
            return 0;
        }
    }

    if (size <= 0 || memory->Alloc(size / 16 + 1) == nullptr) {
        return 0;
    }
    const auto lease = dc2::memory::ArenaBuffer::Bind(*memory, {buffer, static_cast<std::size_t>(size)});
    if (lease.Bytes().empty()) {
        return 0;
    }
    EdEventInfo.npc_talk_text = reinterpret_cast<char *>(buffer);
    EdEventInfo.npc_talk_size = size;
    EdEventInfo.npc_talk_storage = lease;
    return 1;
}

void ResetNpcTalkMes() {
    EdEventInfo.npc_talk_text = nullptr;
    EdEventInfo.npc_talk_size = 0;
    EdEventInfo.npc_talk_storage = {};
}

int GetSquareEvent() {
    CSaveData *save_data = {};

    save_data = GetSaveData();

    if (save_data == nullptr) {
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

int RunEvent(int event_no, CScene *scene) {
    EventScene = scene;
    ++event_script_generation;
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
            int effect = {};

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

    if (camera != nullptr) {
        follow->FollowOff();
        camera->SetRef(camera_ref);
    }

    if (camera_pos[0] == 0.0f && camera_pos[1] == 0.0f && camera_pos[2] == 0.0f) {
        sceVu0UnitMatrix(rotation);
        sceVu0RotMatrixY(rotation, rotation, character_rot[1]);
        sceVu0ApplyMatrix(rotated_offset, rotation, vv[1]);
        sceVu0AddVector(rotated_offset, camera_ref, rotated_offset);

        if (camera != nullptr) {
            camera->SetPos(rotated_offset);
        }
    } else if (camera != nullptr) {
        camera->SetPos(camera_pos);
    }

    return 0;
}

int StartEventSyori() {
    int started = -1;

    if (EdEventInfo.event_no != -1) {
        if (EventScene != nullptr) {
            started = EdEventInfo.event_no;
            EventScene->RunEvent(EdEventInfo.event_no, nullptr);
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

    if (message != nullptr) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->text_ptr = nullptr;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
    }

    message = GetEventMessage(1);

    if (message != nullptr) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->text_ptr = nullptr;
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

    int        request = {};
    int        index = {};
    mgCMemory *buffer = {};
    char      *program = {};
    int        file_size = {};

    switch (EdEventInfo.skip_state) {
        case EVENT_SKIP_NONE:
            break;
        case EVENT_SKIP_ENABLED:
            if (EdEventInfo.skip_button == PAD_BTN_EVENT_SKIP_2 && PadCtrl.Btn(EdEventInfo.skip_button)) {
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
        case EVENT_REQUEST_LOAD_SCRIPT: {
            const std::string_view script_name = dc2::text::View(EdEventInfo.script_name);
            const std::size_t      separator = script_name.find('/');
            if (separator == 0 || separator == std::string_view::npos || separator >= 0x20) {
                EdEventEnd();
                return EVENT_REQUEST_END;
            }
            const std::string map_path = dc2::world::MapPath(script_name.substr(0, separator));
            std::string       directory = DivPathName(map_path).first;
            directory.append(script_name.substr(separator + 1));

            switch (GetNowLoopNo()) {
                case LOOP_EDIT:
                    buffer = &ScriptBuffer__2;
                    break;
                case LOOP_DUNGEON:
                    buffer = &BuffScriptData;
                    break;
                default:
                    EdEventEnd();
                    return EVENT_REQUEST_END;
            }

            std::string file_path = directory;
            buffer->stReset();
            if (buffer->stack == nullptr) {
                break;
            }
            buffer->Align64();
            const auto available = dc2::memory::RemainingBytes(*buffer);
            if (available.size() <= sizeof(u_long128) || buffer->lock != 0) {
                break;
            }
            const auto destination = available.first(available.size() - sizeof(u_long128));
            program = reinterpret_cast<char *>(destination.data());

            if (LoadFile2(file_path.data(), destination, &file_size, 0)) {
                buffer->Alloc(((unsigned int) file_size & 0xF) ? ((unsigned int) file_size >> 4) + 1 : (unsigned int) file_size >> 4);
                SetEventScript(destination.first(static_cast<std::size_t>(file_size)), buffer);
                index = StartEventSyori();

                if (GetNowLoopNo() == LOOP_DUNGEON && index >= 0) {
                    EventScene->event_run = 0;
                    RunEvent(index, DngMainScene);
                }
            } else if (LoadFile2(directory.data(), destination, &file_size, 0)) {
                buffer->Alloc(((unsigned int) file_size & 0xF) ? ((unsigned int) file_size >> 4) + 1 : (unsigned int) file_size >> 4);
                SetEventScript(destination.first(static_cast<std::size_t>(file_size)), buffer);
                index = StartEventSyori();

                if (GetNowLoopNo() == LOOP_DUNGEON && index >= 0) {
                    EventScene->event_run = 0;
                    RunEvent(index, DngMainScene);
                }
            }

            break;
        }
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
    ClsMes *message = {};

    message = nullptr;

    if (EventScene != nullptr) {
        message = EventScene->GetMessage(index);
    }

    return message;
}

mgCCamera *GetActiveCamera() {
    mgCCamera *camera = {};

    camera = nullptr;

    if (EventScene != nullptr) {
        camera = (mgCCamera *) EventScene->GetCamera(EventScene->active_camera);
    }

    return camera;
}

CCharacter2 *GetCharacter(int index) {
    CCharacter2 *character = {};

    character = nullptr;

    if (EventScene != nullptr) {
        character = EventScene->GetCharacter(index);
    }

    return character;
}

#include "common.h"
#include "mw_runtime.h"

#include <algorithm>
#include <array>

#include "dng_main.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "event_text.hpp"
#include "mainloop.hpp"
#include "mglib.hpp"
#include "platform/game_loop_state.hpp"
#include "runscript.hpp"
#include "script_guards.hpp"
#include "stubs/event.hpp"
#include "swordeffect.hpp"

namespace {
int ClearDungeonEffects(dc2::script::RunArguments /*unused*/, int /*unused*/) {
    RocketLauncher.Clear();
    for (int i = 0; i < 16; ++i) {
        MachineGun.active[i] = 0;
        MachineGun.col_prim_id[i] = -1;
    }
    MachineGun.index = 0;
    LaserGun.Clear();
    // Town events share this external, but only the dungeon owns FxScriptMan, which can be null on
    // first entry or point into a retired dungeon arena.
    if (PortLoopNo == LOOP_DUNGEON && FxScriptMan != nullptr) {
        FxScriptMan->AllClearEffSpt();
    }
    return true;
}
} // namespace

namespace {
// The interpreter's runtime arrays outlive each event; the file arena only keeps the program bytes.
std::array<RS_STACKDATA, 128> event_script_values;
std::array<RS_CALLDATA, 512>  event_script_calls;

/**
 *
 * Retains a result only in the permanent event stack and current program generation.
 *
 */
dc2::script::DeferredIntegerWriter CaptureEventInteger(void *, RS_STACKDATA &value) {
    for (std::size_t index = 0; index < event_script_values.size(); ++index) {
        if (&value == &event_script_values[index]) {
            const auto  generation = event_script_generation;
            const auto *program = EventScript.prog;
            return [index, generation, program](int result) {
                if (EventScript.prog != nullptr && EventScript.prog == program && event_script_generation == generation) {
                    event_script_values[index].val.i = result;
                }
            };
        }
    }
    return {};
}

void ConfigureEventScriptFunctions() {
    SetEventFunc(&EventScript);
    ++event_script_generation;
    EventScript.deferred_integer_factory = CaptureEventInteger;
    static std::array<dc2::script::RunFunction, EVENT_EXT_FUNC_NUM> functions;
    std::copy_n(EventScript.ext_func_table, EVENT_EXT_FUNC_NUM, functions.begin());
    functions[EVENT_EXT_DNG_EFFECT_ALL_CLEAR] = ClearDungeonEffects;
    ReplaceEventTextExternals(functions);
    script_guards::GuardEventExternals(functions);
    EventScript.ext_func(functions.data(), functions.size());
}
} // namespace

void SetEventScript(std::span<u8> program, mgCMemory *memory) {
    if (memory == nullptr || !EventScript.load(program, event_script_values, event_script_calls)) {
        EventScript.DeleteProgram();
        return;
    }
    ConfigureEventScriptFunctions();
}
