#include "common.h"
#include "gamepad.hpp"
#include "dataread.hpp"
#include "mglib.hpp"

#include <cstdio>
#include <eekernel.h>
#include <libgraph.h>
#include <libpad.h>

extern "C" {
extern s16 rpad_256;
extern s8 init_257;
extern int cnt_374;
extern s8 init_375;
extern int TheadID; /**< Identifier of the controller thread. */
extern u8 pad_dma_buf[0x400];
extern u8 /**< First controller port's DMA buffer. */ pad_dma_buf2[0x400];
extern u8 /**< Second controller port's DMA buffer. */ ThreadStack[0x400]; /**< Stack of the controller thread. */
}
extern const char at_248[];

static CGamePad *GamePad; /**< Controller manager the controller thread steps. */

static int read_pad(PAD_STATUS *status, int port, int slot);

// Code (.text)
#ifdef NONMATCHING
void CGamePad::Init() {
    key_lock = 0;
    key_lock2 = 0;
    vibration_enabled = 1;
    vibration_elapsed = 0;
    capture_mode = PAD_CAPTURE_OFF;
    capture_frame = 0;

    while (sceGsSyncV(0) == 0) {
    }

    scePadInit(0);
    unk_134 = 0;
    unk_138 = 0;
    unk_13C = 0;
    unk_140 = 0;

    for (int i = 0; i < 2; i++) {
        pad[i].phase = PAD_PHASE_QUERY;
        pad[i].button = 0;
        pad[i].right_y = 0;
        pad[i].right_x = 0;
        pad[i].left_y = 0;
        pad[i].left_x = 0;

        for (int j = 0; j < 6; j++) {
            pad[i].vibration[j] = 0;
            pad[i].vibration_timer[i] = 0;
        }

        axis_threshold[i] = 0;
        repeat[i].enabled = 0;
        repeat[i].active = 0;

        for (int j = 0; j < 32; j++) {
            repeat[i].counter[j] = 0;
            repeat[i].repeat_delay[j] = 0;
            repeat[i].initial_delay[j] = 0;
        }
    }

    if (!scePadPortOpen(0, 0, pad_dma_buf)) {
        printf("ERROR: scePadPortOpen\n");
        return;
    }

    sceGsSyncV(0);
    sceGsSyncV(0);

    if (!scePadPortOpen(1, 0, pad_dma_buf2)) {
        printf("ERROR: scePadPortOpen\n");
        return;
    }

    sceGsSyncV(0);
    sceGsSyncV(0);
}
#else
void CGamePad::Init() {
    int i;
    int j;

    key_lock = 0;
    key_lock2 = 0;
    vibration_enabled = 1;
    vibration_elapsed = 0;
    capture_mode = PAD_CAPTURE_OFF;
    capture_frame = 0;
    while (sceGsSyncV(0) == 0) {
    }
    scePadInit(0);

    unk_134 = 0;
    unk_138 = 0;
    unk_13C = 0;
    unk_140 = 0;
    for (i = 0; i < 2; i++) {
        pad[i].phase = 0;
        pad[i].button = 0;
        pad[i].right_y = 0;
        pad[i].right_x = 0;
        pad[i].left_y = 0;
        pad[i].left_x = 0;

        for (j = 0; j < 6; j++) {
            pad[i].vibration[j] = 0;
            pad[i].vibration_timer[i] = 0;
        }
        axis_threshold[i] = 0;
        repeat[i].enabled = 0;
        repeat[i].active = 0;
        for (j = 0; j < 32; j++) {
            repeat[i].counter[j] = 0;
            repeat[i].repeat_delay[j] = 0;
            repeat[i].initial_delay[j] = 0;
        }
    }

    if (scePadPortOpen(0, 0, pad_dma_buf) == 0) {
        printf(at_248);
        return;
    }
    sceGsSyncV(0);
    sceGsSyncV(0);
    if (scePadPortOpen(1, 0, pad_dma_buf2) == 0) {
        printf(at_248);
        return;
    }
    sceGsSyncV(0);
    sceGsSyncV(0);
}
#endif

void CGamePad::Close() {
    scePadPortClose(0, 0);
    scePadPortClose(1, 0);
    scePadEnd();
}

#ifdef NONMATCHING
/**
 * Reads one controller's buttons and sticks into its state and gives the
 * controller type the data reports, or 0 when nothing was read.
 */
static int pad_button_read(PAD_STATUS *status, int port, int slot) {
    static u16  rpad;
    static char init;
    u8          data[32];

    if (!init) {
        rpad = 0;
        init = 1;
    }

    if (!scePadRead(port, slot, data)) {
        return 0;
    }

    int extended_id = 0;

    if (data[0] == 0) {
        u16 button = ((data[2] << 8) | data[3]) ^ 0xFFFF;
        status->button = button & 0xFFFF;
        status->right_x = data[4];
        status->right_y = data[5];
        status->left_x = data[6];
        status->left_y = data[7];
        rpad = button;
        extended_id = data[1] >> 4;
    }

    return extended_id;
}
#else
int pad_button_read(PAD_STATUS *pad, int port, int slot) {
    u8 rdata[32];
    int pad_mode;
    int button;

    if (init_257 == 0) {
        rpad_256 = 0;
        init_257 = 1;
    }
    pad_mode = 0;
    if (scePadRead(port, slot, rdata) == 0) {
        return 0;
    }
    if (rdata[0] == 0) {

        button = ((rdata[2] << 8) | rdata[3]);
        button = button ^ 0xFFFF;
        pad->button = button & 0xFFFF;
        pad->right_x = rdata[4];
        pad->right_y = rdata[5];
        pad->left_x = rdata[6];
        pad->left_y = rdata[7];
        rpad_256 = button;
        pad_mode = rdata[1] >> 4;
    }
    return pad_mode;
}
#endif

#ifdef NONMATCHING
/**
 * Advances one controller's setup and, once it is ready, reads it; gives
 * nonzero when the controller's buttons and sticks were read.
 */
static int read_pad(PAD_STATUS *status, int port, int slot) {
    status->state = scePadGetState(port, slot);

    if (status->state == scePadStateDiscon) {
        status->phase = PAD_PHASE_QUERY;
    }

    int valid = 0;

    switch (status->phase) {
        case PAD_PHASE_QUERY:
            if (status->state == scePadStateStable || status->state == scePadStateFindCTP1) {
                int terminal_id = scePadInfoMode(port, slot, InfoModeCurID, 0);

                if (terminal_id != 0) {
                    status->extended_id = scePadInfoMode(port, slot, InfoModeCurExID, 0);

                    if (status->extended_id > 0) {
                        terminal_id = status->extended_id;
                    }

                    switch (terminal_id) {
                        case PAD_TERMINAL_NEGCON:
                            status->phase = PAD_PHASE_READY;
                            break;
                        case PAD_TERMINAL_KONAMI_GUN:
                            status->phase = PAD_PHASE_READY;
                            break;
                        case PAD_TERMINAL_DIGITAL:
                            status->phase = PAD_PHASE_ANALOG_CHECK;
                            break;
                        case PAD_TERMINAL_ANALOG_JOYSTICK:
                            status->phase = PAD_PHASE_READY;
                            break;
                        case PAD_TERMINAL_NAMCO_GUN:
                            status->phase = PAD_PHASE_READY;
                            break;
                        case PAD_TERMINAL_DUALSHOCK:
                            status->phase = PAD_PHASE_ACTUATOR_CHECK;
                            break;
                        case PAD_TERMINAL_EX_TSURICON:
                            status->phase = PAD_PHASE_READY;
                            break;
                        case PAD_TERMINAL_EX_JOGCON:
                            status->phase = PAD_PHASE_READY;
                            break;
                        default:
                            status->phase = PAD_PHASE_READY;
                            break;
                    }
                }
            }

            break;
        case PAD_PHASE_ANALOG_CHECK:
            if (scePadInfoMode(port, slot, InfoModeCurExID, 0) == 0) {
                status->phase = PAD_PHASE_READY;
                break;
            }

            status->phase++;
            // Fall through.
        case PAD_PHASE_ANALOG_SET:
            if (scePadSetMainMode(port, slot, 1, 3) == 1) {
                status->phase++;
            }

            break;
        case PAD_PHASE_ANALOG_WAIT:
            if (scePadGetState(port, slot) != scePadStateExecCmd) {
                status->phase = PAD_PHASE_QUERY;
            }

            break;
        case PAD_PHASE_ACTUATOR_CHECK:
            if (scePadInfoAct(port, slot, -1, 0) == 0) {
                status->phase = PAD_PHASE_READY;
            }

            status->actuator[0] = 0;
            status->actuator[1] = 1;

            for (int i = 2; i < 6; i++) {
                status->actuator[i] = 0xFF;
            }

            if (scePadSetActAlign(port, slot, status->actuator)) {
                status->phase++;
            }

            break;
        case PAD_PHASE_ACTUATOR_WAIT:
            if (scePadGetState(port, slot) != scePadStateExecCmd) {
                status->phase = PAD_PHASE_READY;
            }

            break;
        default:
            if (status->state == scePadStateStable || status->state == scePadStateFindCTP1) {
                status->pad_mode = pad_button_read(status, port, slot);

                if (status->pad_mode != 0) {
                    // A change of controller type restarts the setup.
                    if (status->previous_pad_mode != 0 && status->pad_mode != status->previous_pad_mode) {
                        status->previous_pad_mode = 0;
                        status->phase = PAD_PHASE_QUERY;
                    } else {
                        valid = 1;
                    }

                    status->previous_pad_mode = status->pad_mode;
                }
            }

            break;
    }

    if (!valid) {
        status->button = 0;
        status->left_y = 0x80;
        status->left_x = 0x80;
        status->right_y = 0x80;
        status->right_x = 0x80;
    }

    if (status->pad_mode == PAD_TERMINAL_DIGITAL) {
        status->left_y = 0x80;
        status->left_x = 0x80;
        status->right_y = 0x80;
        status->right_x = 0x80;
    }

    return valid;
}
#else
int read_pad(PAD_STATUS *pad, int port, int slot) {
    int ok;
    int id;

    int *phase = &pad->phase;
    int *state = &pad->state;
    int *extended_id = &pad->extended_id;
    int *pad_mode = &pad->pad_mode;
    int *previous_pad_mode = &pad->previous_pad_mode;

    *state = scePadGetState(port, slot);
    if (*state == 0) {
        *phase = 0;
    }
    ok = 0;
    switch (*phase) {
        case PAD_PHASE_QUERY:
            if (*state == scePadStateStable || *state == scePadStateFindCTP1) {
                id = scePadInfoMode(port, slot, InfoModeCurID, 0);
                if (id != 0) {
                    *extended_id = scePadInfoMode(port, slot, InfoModeCurExID, 0);
                    if (*extended_id > 0) {
                        id = *extended_id;
                    }

                    switch (id) {
                        case 2:
                            *phase = PAD_PHASE_READY;
                            break;
                        case 3:
                            *phase = PAD_PHASE_READY;
                            break;
                        case PAD_TERMINAL_DIGITAL:
                            *phase = PAD_PHASE_ANALOG_CHECK;
                            break;
                        case 5:
                            *phase = PAD_PHASE_READY;
                            break;
                        case 6:
                            *phase = PAD_PHASE_READY;
                            break;
                        case PAD_TERMINAL_DUALSHOCK:
                            *phase = PAD_PHASE_ACTUATOR_CHECK;
                            break;
                        case 0x100:
                            *phase = PAD_PHASE_READY;
                            break;
                        case 0x300:
                            *phase = PAD_PHASE_READY;
                            break;
                        default:
                            *phase = PAD_PHASE_READY;
                            break;
                    }
                }
            }
            break;
        case PAD_PHASE_ANALOG_CHECK:
            if (scePadInfoMode(port, slot, InfoModeCurExID, 0) == 0) {
                *phase = PAD_PHASE_READY;
                break;
            }
            (*phase)++;

        case PAD_PHASE_ANALOG_SET:
            if (scePadSetMainMode(port, slot, 1, 3) == 1) {
                (*phase)++;
            }
            break;
        case PAD_PHASE_ANALOG_WAIT:
            if (scePadGetState(port, slot) != scePadStateExecCmd) {
                *phase = 0;
            }
            break;
        case PAD_PHASE_ACTUATOR_CHECK:
            if (scePadInfoAct(port, slot, -1, 0) == 0) {
                *phase = PAD_PHASE_READY;
            }
            pad->actuator[0] = 0;
            pad->actuator[1] = 1;
            pad->actuator[2] = 0xFF;
            pad->actuator[3] = 0xFF;
            pad->actuator[4] = 0xFF;
            pad->actuator[5] = 0xFF;
            if (scePadSetActAlign(port, slot, pad->actuator) != 0) {
                (*phase)++;
            }
            break;
        case PAD_PHASE_ACTUATOR_WAIT:
            if (scePadGetState(port, slot) != scePadStateExecCmd) {
                *phase = PAD_PHASE_READY;
            }
            break;
        default:
            if (*state == scePadStateStable || *state == scePadStateFindCTP1) {

                if ((*pad_mode = pad_button_read(pad, port, slot)) != 0) {
                    if (*previous_pad_mode != 0 && *pad_mode != *previous_pad_mode) {
                        *previous_pad_mode = 0;
                        *phase = 0;
                    } else {
                        ok = 1;
                    }
                    *previous_pad_mode = *pad_mode;
                }
            }
            break;
    }
    if (ok == 0) {
        pad->button = 0;
        pad->left_y = 0x80;
        pad->left_x = 0x80;
        pad->right_y = 0x80;
        pad->right_x = 0x80;
    }

    if (*pad_mode == PAD_TERMINAL_DIGITAL) {
        pad->left_y = 0x80;
        pad->left_x = 0x80;
        pad->right_y = 0x80;
        pad->right_x = 0x80;
    }
    return ok;
}
#endif

void CGamePad::WaitEnable() {
    sceGsSyncV(0);

    while (!read_pad(&pad[0], 0, 0)) {
        sceGsSyncV(0);

        if (scePadGetState(0, 0) == scePadStateDiscon) {
            break;
        }
    }

    while (!read_pad(&pad[1], 1, 0)) {
        sceGsSyncV(0);

        if (scePadGetState(1, 0) == scePadStateDiscon) {
            break;
        }
    }
}

int CGamePad::Connect() {
    int state = scePadGetState(0, 0);

    if (state == scePadStateStable) {
        return 1;
    }

    return state == scePadStateFindCTP1;
}

#ifdef NONMATCHING
void CGamePad::UpDate() {
    static int  cnt;
    static char init;
    int         i;

    if (!init) {
        cnt = 0;
        init = 1;
    }

    previous_pad[0] = pad[0];
    read_pad(&pad[0], 0, 0);
    previous_pad[1] = pad[1];
    read_pad(&pad[1], 1, 0);

    switch (capture_mode) {
        case PAD_CAPTURE_RECORD:
            Capture(&pad[0]);
            break;
        case PAD_CAPTURE_PLAY:
            Play(&pad[0]);
            break;
    }

    for (i = 0; i < 2; i++) {
        int threshold = axis_threshold[i];

        if (threshold < 0) {
            threshold = 0;
        }

        if (threshold > 0) {
            if (threshold < GetLX()) {
                pad[i].button |= PAD_RIGHT;
            }

            if (GetLX() < -threshold) {
                pad[i].button |= PAD_LEFT;
            }

            if (threshold < GetLY()) {
                pad[i].button |= PAD_DOWN;
            }

            if (GetLY() < -threshold) {
                pad[i].button |= PAD_UP;
            }
        }
    }

    for (i = 0; i < 2; i++) {
        PAD_REPEAT *auto_repeat = &repeat[i];
        int         bit = 1;

        for (int j = 0; j < 32; j++, bit <<= 1) {
            if (auto_repeat->enabled & bit) {
                if ((pad[i].button & auto_repeat->enabled) & bit) {
                    auto_repeat->counter[j]++;

                    if (auto_repeat->counter[j] >= auto_repeat->initial_delay[j]) {
                        auto_repeat->active |= bit;
                    }
                } else {
                    auto_repeat->counter[j] = 0;
                    auto_repeat->active &= ~bit;
                }

                // A repeating button reads as released for one frame each repeat.
                if (auto_repeat->counter[j] >= auto_repeat->repeat_delay[j] && (auto_repeat->active & bit)) {
                    pad[i].button &= ~bit;
                    auto_repeat->counter[j] = 0;
                }
            }
        }
    }

    for (i = 0; i < 2; i++) {
        if ((pad[i].button & PAD_UP) && (pad[i].button & PAD_DOWN)) {
            pad[i].button &= ~(PAD_UP | PAD_DOWN);
        }

        if ((pad[i].button & PAD_RIGHT) && (pad[i].button & PAD_LEFT)) {
            pad[i].button &= ~(PAD_RIGHT | PAD_LEFT);
        }
    }

    if (key_lock2) {
        pad[1].button = 0;
        pad[1].right_x = 0x80;
        pad[1].right_y = 0x80;
        pad[1].left_x = 0x80;
        pad[1].left_y = 0x80;
        previous_pad[1].button = 0;
        previous_pad[1].right_x = 0x80;
        previous_pad[1].right_y = 0x80;
        previous_pad[1].left_x = 0x80;
        previous_pad[1].left_y = 0x80;
    }

    cnt = !cnt;
    SwitchGamePadThread();
}
#else
void CGamePad::UpDate() {
    int i;
    int j;
    int bit;
    PAD_REPEAT *rep;
    int range;

    if (init_375 == 0) {
        cnt_374 = 0;
        init_375 = 1;
    }
    previous_pad[0] = pad[0];
    read_pad(&pad[0], 0, 0);
    previous_pad[1] = pad[1];
    read_pad(&pad[1], 1, 0);

    switch (capture_mode) {
        case PAD_CAPTURE_RECORD:
            Capture(&pad[0]);
            break;
        case PAD_CAPTURE_PLAY:
            Play(&pad[0]);
            break;
    }

    for (i = 0; i < 2; i++) {
        range = axis_threshold[i];
        if (range < 0) {
            range = 0;
        }
        if (range > 0) {
            if (range < GetLX()) {
                pad[i].button |= PAD_RIGHT;
            }
            if (GetLX() < -range) {
                pad[i].button |= PAD_LEFT;
            }
            if (range < GetLY()) {
                pad[i].button |= PAD_DOWN;
            }
            if (GetLY() < -range) {
                pad[i].button |= PAD_UP;
            }
        }
    }

    for (j = 0; j < 2; j++) {
        bit = 1;
        rep = &repeat[j];
        for (i = 0; i < 32; i++, bit *= 2) {
            if (rep->enabled & bit) {
                if (bit & (pad[j].button & rep->enabled)) {
                    rep->counter[i]++;
                    if (rep->counter[i] >= rep->initial_delay[i]) {
                        rep->active |= bit;
                    }
                } else {
                    rep->counter[i] = 0;
                    rep->active &= ~bit;
                }
                if (rep->counter[i] >= rep->repeat_delay[i] && (rep->active & bit)) {
                    pad[j].button &= ~bit;
                    rep->counter[i] = 0;
                }
            }
        }
    }

    for (i = 0; i < 2; i++) {
        if ((pad[i].button & PAD_UP) && (pad[i].button & PAD_DOWN)) {
            pad[i].button &= ~(PAD_UP | PAD_DOWN);
        }
        if ((pad[i].button & PAD_RIGHT) && (pad[i].button & PAD_LEFT)) {
            pad[i].button &= ~(PAD_RIGHT | PAD_LEFT);
        }
    }

    if (key_lock2 != 0) {
        pad[1].button = 0;
        pad[1].right_x = 0x80;
        pad[1].right_y = 0x80;
        pad[1].left_x = 0x80;
        pad[1].left_y = 0x80;
        previous_pad[1].button = 0;
        previous_pad[1].right_x = 0x80;
        previous_pad[1].right_y = 0x80;
        previous_pad[1].left_x = 0x80;
        previous_pad[1].left_y = 0x80;
    }

    cnt_374 = !cnt_374;
    SwitchGamePadThread();
}
#endif

void CGamePad::Step(int elapsed) {
    vibration_elapsed += elapsed;

    if (vibration_elapsed > 1000) {
        vibration_elapsed = 0;
        StopVibration();
        return;
    }

    for (int i = 0; i < 1; i++) {
        if (!vibration_enabled) {
            pad[i].vibration[PAD_MOTOR_SMALL] = 0;
            pad[i].vibration[PAD_MOTOR_LARGE] = 0;
        }

        if (pad[i].vibration_timer[PAD_MOTOR_SMALL] > 0) {
            pad[i].vibration_timer[PAD_MOTOR_SMALL] -= elapsed;
        } else {
            pad[i].vibration_timer[PAD_MOTOR_SMALL] = 0;
            pad[i].vibration[PAD_MOTOR_SMALL] = 0;
        }

        if (pad[i].vibration_timer[PAD_MOTOR_LARGE] > 0) {
            pad[i].vibration_timer[PAD_MOTOR_LARGE] -= elapsed;
        } else {
            pad[i].vibration_timer[PAD_MOTOR_LARGE] = 0;
            pad[i].vibration[PAD_MOTOR_LARGE] = 0;
        }
    }

    scePadSetActDirect(0, 0, pad[0].vibration);
}

/**
 * Converts a raw stick position to a signed deflection from -128 to 128,
 * with a dead zone around the centre.
 */
static int AxisCalibration(int axis) {
    int calibrated = axis - 0x80;

    if (calibrated < 50 && calibrated > -50) {
        return 0;
    }

    if (calibrated > 0) {
        return ((calibrated - 49) << 7) / 78;
    }

    return ((calibrated + 50) << 7) / 78;
}

int CGamePad::GetRX() {
    return AxisCalibration(pad[0].right_x);
}

int CGamePad::GetRY() {
    return AxisCalibration(pad[0].right_y);
}

int CGamePad::GetLX() {
    return AxisCalibration(pad[0].left_x);
}

int CGamePad::GetLY() {
    return AxisCalibration(pad[0].left_y);
}

int CGamePad::GetRX2() {
    return AxisCalibration(pad[1].right_x);
}

#ifdef NONMATCHING
void CGamePad::CancelAutoRepeat(int mask) {
    PAD_REPEAT *auto_repeat = &repeat[0];
    int         bit = 1;

    for (int i = 0; i < 32; i++, bit <<= 1) {
        if (mask & bit) {
            auto_repeat->enabled &= ~bit;
            auto_repeat->active &= ~bit;
            auto_repeat->counter[i] = 0;
            auto_repeat->initial_delay[i] = 0;
            auto_repeat->repeat_delay[i] = 0;
        }
    }
}
#else
void CGamePad::CancelAutoRepeat(int mask) {
    int i;
    int bit;

    PAD_REPEAT *rep = &repeat[0];
    bit = 1;
    for (i = 0; i < 32; i++, bit *= 2) {
        if (mask & bit) {
            rep->enabled &= ~bit;
            rep->active &= ~bit;
            rep->counter[i] = 0;
            rep->initial_delay[i] = 0;
            rep->repeat_delay[i] = 0;
        }
    }
}
#endif

#ifdef NONMATCHING
void CGamePad::CancelAutoRepeat2(int mask) {
    PAD_REPEAT *auto_repeat = &repeat[1];
    int         bit = 1;

    for (int i = 0; i < 32; i++, bit <<= 1) {
        if (mask & bit) {
            auto_repeat->enabled &= ~bit;
            auto_repeat->active &= ~bit;
            auto_repeat->counter[i] = 0;
            auto_repeat->initial_delay[i] = 0;
            auto_repeat->repeat_delay[i] = 0;
        }
    }
}
#else
void CGamePad::CancelAutoRepeat2(int mask) {
    int i;
    int bit;
    PAD_REPEAT *rep = &repeat[1];

    bit = 1;
    for (i = 0; i < 32; i++, bit *= 2) {
        if (mask & bit) {
            rep->enabled &= ~bit;
            rep->active &= ~bit;
            rep->counter[i] = 0;
            rep->initial_delay[i] = 0;
            rep->repeat_delay[i] = 0;
        }
    }
}
#endif

#ifdef NONMATCHING
void CGamePad::SetAutoRepeat(int mask, int initial_delay, int repeat_delay) {
    PAD_REPEAT *auto_repeat = &repeat[0];
    int         bit = 1;

    if (repeat_delay < 2) {
        repeat_delay = 2;
    }

    if (initial_delay < 2) {
        initial_delay = 2;
    }

    for (int i = 0; i < 32; i++, bit <<= 1) {
        if (mask & bit) {
            auto_repeat->enabled |= bit;
            auto_repeat->active &= ~bit;
            auto_repeat->counter[i] = 0;
            auto_repeat->initial_delay[i] = initial_delay;
            auto_repeat->repeat_delay[i] = repeat_delay;
        }
    }
}
#else
void CGamePad::SetAutoRepeat(int mask, int delay, int interval) {
    int i;
    int bit;
    PAD_REPEAT *rep;

    bit = 1;
    if (interval < 2) {
        interval = 2;
    }
    if (delay < 2) {
        delay = 2;
    }
    rep = &repeat[0];
    for (i = 0; i < 32; i++, bit *= 2) {
        if (mask & bit) {
            rep->enabled |= bit;
            rep->active &= ~bit;
            rep->counter[i] = 0;
            rep->initial_delay[i] = delay;
            rep->repeat_delay[i] = interval;
        }
    }
}
#endif

#ifdef NONMATCHING
void CGamePad::SetAutoRepeat2(int mask, int initial_delay, int repeat_delay) {
    PAD_REPEAT *auto_repeat = &repeat[1];
    int         bit = 1;

    if (repeat_delay < 2) {
        repeat_delay = 2;
    }

    if (initial_delay < 2) {
        initial_delay = 2;
    }

    for (int i = 0; i < 32; i++, bit <<= 1) {
        if (!(auto_repeat->enabled & bit) && (mask & bit)) {
            auto_repeat->enabled |= bit;
            auto_repeat->active &= ~bit;
            auto_repeat->counter[i] = 0;
            auto_repeat->initial_delay[i] = initial_delay;
            auto_repeat->repeat_delay[i] = repeat_delay;
        }
    }
}
#else
void CGamePad::SetAutoRepeat2(int mask, int delay, int interval) {
    int i;
    int bit;
    PAD_REPEAT *rep;

    bit = 1;
    if (interval < 2) {
        interval = 2;
    }
    if (delay < 2) {
        delay = 2;
    }
    rep = &repeat[1];
    for (i = 0; i < 32; i++, bit *= 2) {
        if ((rep->enabled & bit) == 0 && (mask & bit)) {
            rep->enabled |= bit;
            rep->active &= ~bit;
            rep->counter[i] = 0;
            rep->initial_delay[i] = delay;
            rep->repeat_delay[i] = interval;
        }
    }
}
#endif

void CGamePad::KeyLock(int lock) {
    key_lock = lock;
}

void CGamePad::KeyLock2(int lock) {
    key_lock2 = lock;
}

void CGamePad::DebugKeyLock(int lock) {
    debug_key_lock = lock;
    KeyLock2(lock);
}

int CGamePad::GetPadOn() {
    if (key_lock) {
        return 0;
    }

    return pad[0].button;
}

int CGamePad::GetPadDown() {
    if (key_lock) {
        return 0;
    }

    return pad[0].button & ~previous_pad[0].button;
}

int CGamePad::GetPadUp() {
    if (key_lock) {
        return 0;
    }

    return ~pad[0].button & previous_pad[0].button;
}

float CGamePad::GetRXf() {
    return (float) GetRX() / 128.0f;
}

float CGamePad::GetRYf() {
    return (float) GetRY() / 128.0f;
}

float CGamePad::GetLXf() {
    return (float) GetLX() / 128.0f;
}

float CGamePad::GetLYf() {
    return (float) GetLY() / 128.0f;
}

float CGamePad::GetRXf2() {
    return (float) GetRX2() / 128.0f;
}

int CGamePad::On(int mask) {
    if (key_lock) {
        return 0;
    }

    return (pad[0].button & mask) != 0;
}

int CGamePad::On2(int mask) {
    if (key_lock) {
        return 0;
    }

    if (key_lock2) {
        return 0;
    }

    return (pad[1].button & mask) != 0;
}

int CGamePad::Down(int mask) {
    if (key_lock) {
        return 0;
    }

    return (mask & (pad[0].button & ~previous_pad[0].button)) != 0;
}

int CGamePad::Down2(int mask) {
    if (key_lock) {
        return 0;
    }

    if (key_lock2) {
        return 0;
    }

    return (mask & (pad[1].button & ~previous_pad[1].button)) != 0;
}

int CGamePad::Up(int mask) {
    if (key_lock) {
        return 0;
    }

    return (mask & (~pad[0].button & previous_pad[0].button)) != 0;
}

void CGamePad::AutoRepeatOff() {
    CancelAutoRepeat(-1);
}

void CGamePad::MenuModeOn(int threshold) {
    axis_threshold[0] = threshold;
}

void CGamePad::MenuModeOff() {
    axis_threshold[0] = 0;
}

void CGamePad::SetVibration(int motor, int strength, int duration) {
    vibration_elapsed = 0;

    if (!vibration_enabled || motor < PAD_MOTOR_SMALL || motor > PAD_MOTOR_LARGE || duration < 0) {
        return;
    }

    pad[0].vibration_timer[motor] = duration;

    // The small actuator is only on or off.
    if (motor == PAD_MOTOR_SMALL) {
        strength = strength != 0;
    }

    pad[0].vibration[motor] = strength;
}

void CGamePad::VibrationEnable(int enable) {
    vibration_enabled = enable;
}

void CGamePad::StopVibration() {
    SetVibration(PAD_MOTOR_SMALL, 0, 0);
    SetVibration(PAD_MOTOR_LARGE, 0, 0);
    Step(1);
}

void CGamePad::CaptureStart() {
    capture_mode = PAD_CAPTURE_RECORD;
    capture_frame = 0;
}

void CGamePad::CaptureEnd() {
    capture_mode = PAD_CAPTURE_OFF;
    capture_frame = 0;
}

void CGamePad::CapturePlay() {
    capture_mode = PAD_CAPTURE_PLAY;
}

#ifdef NONMATCHING
void CGamePad::Capture(PAD_STATUS *status) {
    if (capture_frame < PAD_CAPTURE_FRAME_MAX) {
        PAD_CAPTURE_FRAME *frame = &PAD_CAPTURE_BUFFER[capture_frame];
        frame->button = status->button;
        frame->left_y = status->left_y;
        frame->left_x = status->left_x;
        frame->right_y = status->right_y;
        frame->right_x = status->right_x;
        capture_frame++;
    }
}
#else
void CGamePad::Capture(PAD_STATUS *pad) {
    u8 *entry = (u8 *)PAD_CAPTURE_BUFFER;
    u32 frame = capture_frame;
    if (frame < PAD_CAPTURE_FRAME_MAX) {
        entry += frame * sizeof(PAD_CAPTURE_FRAME);
        *(s16 *)entry = pad->button;
        entry[2] = pad->left_y;
        entry[3] = pad->left_x;
        entry[4] = pad->right_y;
        entry[5] = pad->right_x;
        capture_frame = capture_frame + 1;
    }
}
#endif

#ifdef NONMATCHING
void CGamePad::Play(PAD_STATUS *status) {
    if (capture_frame < PAD_CAPTURE_FRAME_MAX) {
        PAD_CAPTURE_FRAME *frame = &PAD_CAPTURE_BUFFER[capture_frame];
        status->button = frame->button;
        status->left_y = frame->left_y;
        status->left_x = frame->left_x;
        status->right_y = frame->right_y;
        status->right_x = frame->right_x;
        capture_frame++;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gamepad", Play__8CGamePadFP10PAD_STATUS);
#endif

void CGamePad::SaveCapture() {
    WriteFile("host0:key_cap.bin", PAD_CAPTURE_BUFFER, capture_frame * sizeof(PAD_CAPTURE_FRAME));
}

void CGamePad::LoadCapture() {
    SetCurrentDir("");
    LoadFile2("key_cap.bin", PAD_CAPTURE_BUFFER, NULL, LOAD_FILE_READ);
    SetCurrentDir(NULL);
}

void SwitchGamePadThread() {
    RotateThreadReadyQueue(GAMEPAD_THREAD_PRIORITY);
}

/**
 * Runs the controller thread: steps the controller manager's vibration by
 * the vertical blanks elapsed since its last turn, then yields.
 */
static void GamePadStep(void *arg) {
    static int old_vsync;

    while (true) {
        int now = mgGetVSyncCount();
        int elapsed = now - old_vsync;

        if (elapsed < 0) {
            elapsed = 1;
        }

        if (elapsed > 0 && GamePad != NULL) {
            GamePad->Step(elapsed);
        }

        SwitchGamePadThread();
        old_vsync = now;
    }
}

#ifdef NONMATCHING
void CreateGamePadThread(CGamePad *game_pad) {
    ThreadParam param;
    param.entry = GamePadStep;
    param.option = 0;
    param.stack = ThreadStack;
    param.stackSize = sizeof(ThreadStack);
    param.initPriority = GAMEPAD_THREAD_PRIORITY;
    param.gpReg = &_gp;
    TheadID = CreateThread(&param);
    GamePad = game_pad;
    StartThread(TheadID, NULL);
}
#else
void CreateGamePadThread(CGamePad *pad) {
    ThreadParam param;

    param.entry = GamePadStep;
    param.stack = ThreadStack;
    param.stackSize = sizeof(ThreadStack);
    param.initPriority = GAMEPAD_THREAD_PRIORITY;
    param.gpReg = &_gp;
    param.option = 0;
    TheadID = CreateThread(&param);
    GamePad = pad;
    StartThread(TheadID, NULL);
}
#endif

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamepad", at_248__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamepad", at_904__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamepad", at_909__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamepad", at_910__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(rpad_256, 0x4);
INCLUDE_BSS(init_257, 0x4);
INCLUDE_BSS(cnt_374, 0x4);
INCLUDE_BSS(init_375, 0x4);
INCLUDE_BSS(TheadID, 0x4);
INCLUDE_BSS(GamePad, 0x4);
INCLUDE_BSS(old_vsync__2, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(pad_dma_buf, 0x400);
INCLUDE_BSS(pad_dma_buf2, 0x400);
INCLUDE_BSS(ThreadStack, 0x400);
