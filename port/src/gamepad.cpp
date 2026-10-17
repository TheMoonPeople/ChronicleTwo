#include "common.h"

#include <cstdint>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <vector>

#include "dualsense_haptics.hpp"
#include "gamepad.hpp"
#include "gamepad_port.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menu_mouse_item.hpp"
#include "pad_rumble.hpp"
#include "platform/input.hpp"
#include "platform/paths.hpp"
#include "test_hooks.hpp"

namespace {
std::vector<PAD_CAPTURE_FRAME> recording;

void Neutral(PAD_STATUS &status) {
    status.button = 0;
    status.left_x = status.left_y = status.right_x = status.right_y = 128;
}
} // namespace

PORT_OVERRIDE void CGamePad::UpDate() {
    // Only the retail menu threshold may turn stick axes into D-pad buttons.
    // Disable the host fallback so movement keys cannot select field slots.
    InputSetKeyboardStickNavigation(false);
    for (int port = 0; port < 2; ++port) {
        previous_pad[port] = pad[port];
        PortReadPad(&pad[port], port, 0);
    }

    const bool playback = capture_mode == PAD_CAPTURE_PLAY;
    if (capture_mode == PAD_CAPTURE_RECORD) {
        Capture(&pad[0]);
    }
    if (playback) {
        Play(&pad[0]);
    }

    // Retail applies pad 0's left stick to both configured thresholds, regardless
    // of which host device supplies each axis. MenuModeOff disables conversion.
    for (int port = 0; port < 2; ++port) {
        const int threshold = axis_threshold[port];
        if (threshold <= 0) {
            continue;
        }
        const int x = GetLX();
        const int y = GetLY();
        if (x > threshold) {
            pad[port].button |= PAD_RIGHT;
        }
        if (x < -threshold) {
            pad[port].button |= PAD_LEFT;
        }
        if (y > threshold) {
            pad[port].button |= PAD_DOWN;
        }
        if (y < -threshold) {
            pad[port].button |= PAD_UP;
        }
    }

    for (int port = 0; port < 2; ++port) {
        auto &state = repeat[port];
        for (int index = 0; index < 32; ++index) {
            const unsigned bit = 1u << index;
            if (!(state.enabled & bit)) {
                continue;
            }
            if (pad[port].button & bit) {
                ++state.counter[index];
                if (state.counter[index] >= state.initial_delay[index]) {
                    state.active |= bit;
                }
            } else {
                state.counter[index] = 0;
                state.active &= ~bit;
            }
            if ((state.active & bit) && state.counter[index] >= state.repeat_delay[index]) {
                pad[port].button &= ~bit;
                state.counter[index] = 0;
            }
        }
        for (int pair : {PAD_UP | PAD_DOWN, PAD_LEFT | PAD_RIGHT}) {
            if ((pad[port].button & pair) == pair) {
                pad[port].button &= ~pair;
            }
        }
    }
    if (key_lock2) {
        Neutral(pad[1]);
        Neutral(previous_pad[1]);
    }
    SwitchGamePadThread();
}

// Retail counts the motors down here and sends them to pad 0 alone. The port plays them on a
// DualSense's actuators when it can (dualsense_haptics.hpp), and otherwise sends them to every open
// pad, since a DualSense behind DSX or Steam Input shows up twice (see pad_rumble.hpp).
PORT_OVERRIDE void CGamePad::Step(int elapsed) {
    vibration_elapsed += elapsed;
    if (vibration_elapsed > 1000) {
        vibration_elapsed = 0;
        StopVibration();
        return;
    }
    PAD_STATUS &status = pad[0];
    if (!vibration_enabled) {
        status.vibration[PAD_MOTOR_SMALL] = 0;
        status.vibration[PAD_MOTOR_LARGE] = 0;
    }
    for (int motor : {PAD_MOTOR_SMALL, PAD_MOTOR_LARGE}) {
        if (status.vibration_timer[motor] > 0) {
            status.vibration_timer[motor] -= elapsed;
        } else {
            status.vibration_timer[motor] = 0;
            status.vibration[motor] = 0;
        }
    }
    const bool         small = status.vibration[PAD_MOTOR_SMALL] != 0;
    const std::uint8_t large = status.vibration[PAD_MOTOR_LARGE];
    HapticsPollGame();
    if (HapticsActive()) {
        // SDL's emulated rumble switches the pad's audio haptics off while it runs.
        PortPadRumble(false, 0);
        HapticsSetMotors(small, large);
    } else {
        HapticsSetMotors(false, 0);
        PortPadRumble(small, large);
    }
}

PORT_OVERRIDE void CGamePad::MenuModeOn(int threshold) {
    axis_threshold[0] = threshold;
    InputSetMenuNavigation(true);
    MenuMouseEnable(true);
}

PORT_OVERRIDE void CGamePad::MenuModeOff() {
    axis_threshold[0] = 0;
    InputSetMenuNavigation(false);
    MenuMouseEnable(false);
    MenuMouseClose();
}

PORT_OVERRIDE void CGamePad::CaptureStart() {
    recording.clear();
    capture_frame = 0;
    capture_mode = PAD_CAPTURE_RECORD;
}

PORT_OVERRIDE void CGamePad::CapturePlay() {
    capture_frame = 0;
    capture_mode = PAD_CAPTURE_PLAY;
}

PORT_OVERRIDE void CGamePad::Capture(PAD_STATUS *status) {
    if (!status || capture_frame >= PAD_CAPTURE_FRAME_MAX) {
        return;
    }
    if (capture_frame == 0) {
        recording.clear();
    }
    if (capture_frame != recording.size()) {
        return;
    }
    recording.push_back({static_cast<u16>(status->button), status->left_y, status->left_x,
                         status->right_y, status->right_x});
    ++capture_frame;
}

PORT_OVERRIDE void CGamePad::Play(PAD_STATUS *status) {
    if (!status) {
        return;
    }
    if (capture_frame >= recording.size()) {
        Neutral(*status);
        capture_mode = PAD_CAPTURE_OFF;
        return;
    }
    const auto &frame = recording[capture_frame++];
    status->button = frame.button;
    status->left_y = frame.left_y;
    status->left_x = frame.left_x;
    status->right_y = frame.right_y;
    status->right_x = frame.right_x;
}

PORT_OVERRIDE void CGamePad::SaveCapture() {
    const auto      path = PathsSaveRoot() / "key_cap.bin";
    std::error_code error;
    std::filesystem::create_directories(path.parent_path(), error);
    std::ofstream file(path, std::ios::binary | std::ios::trunc);
    for (const auto &frame : recording) {
        const unsigned char bytes[] = {static_cast<unsigned char>(frame.button),
                                       static_cast<unsigned char>(frame.button >> 8),
                                       frame.left_y, frame.left_x, frame.right_y, frame.right_x};
        file.write(reinterpret_cast<const char *>(bytes), sizeof(bytes));
    }
    if (!file) {
        std::fprintf(stderr, "gamepad: could not save key_cap.bin\n");
    }
}

PORT_OVERRIDE void CGamePad::LoadCapture() {
    recording.clear();
    capture_frame = 0;
    capture_mode = PAD_CAPTURE_OFF;
    std::ifstream file(PathsSaveRoot() / "key_cap.bin", std::ios::binary | std::ios::ate);
    if (!file) {
        return;
    }
    const auto size = file.tellg();
    if (size < 0 || size > static_cast<std::streamoff>(PAD_CAPTURE_FRAME_MAX * 6) || size % 6 != 0) {
        std::fprintf(stderr, "gamepad: invalid key_cap.bin size\n");
        return;
    }
    file.seekg(0);
    std::vector<PAD_CAPTURE_FRAME> loaded;
    loaded.reserve(static_cast<std::size_t>(size) / 6);
    for (std::streamoff offset = 0; offset < size; offset += 6) {
        unsigned char bytes[6];
        if (!file.read(reinterpret_cast<char *>(bytes), sizeof(bytes))) {
            return;
        }
        loaded.push_back({static_cast<u16>(bytes[0] | (bytes[1] << 8)), bytes[2], bytes[3], bytes[4], bytes[5]});
    }
    recording = std::move(loaded);
}

namespace {
constexpr int kDebugButtonsModifier = PAD_L2 | PAD_SELECT;
constexpr int kConsumedDebugButtons = kDebugButtonsModifier | PAD_CIRCLE | PAD_CROSS;

bool DebugModifier(const CGamePad &pad, bool previous = false) {
    const int buttons = previous ? pad.previous_pad[0].button : pad.pad[0].button;
    return GameDebugEnabled() && (buttons & kDebugButtonsModifier) == kDebugButtonsModifier;
}

int Pad1Buttons(const CGamePad &pad, int buttons, bool edges = false) {
    return DebugModifier(pad) || (edges && DebugModifier(pad, true))
               ? buttons & ~kConsumedDebugButtons
               : buttons;
}
} // namespace

PORT_OVERRIDE int CGamePad::On2(int mask) {
    if (key_lock) {
        return 0;
    }
    const int real = key_lock2 ? 0 : pad[1].button;
    const int single = DebugModifier(*this) ? pad[0].button & ~kDebugButtonsModifier : 0;
    return ((real | single) & mask) != 0;
}

PORT_OVERRIDE int CGamePad::Down2(int mask) {
    if (key_lock) {
        return 0;
    }
    const int real = key_lock2 ? 0 : pad[1].button & ~previous_pad[1].button;
    const int single = DebugModifier(*this) ? pad[0].button & ~previous_pad[0].button & ~kDebugButtonsModifier : 0;
    return ((real | single) & mask) != 0;
}

PORT_OVERRIDE int CGamePad::Down(int mask) {
    if (key_lock) {
        return 0;
    }
    return (GetPadDown() & mask) != 0;
}

PORT_OVERRIDE int CGamePad::GetPadDown() {
    if (key_lock) {
        return 0;
    }
    return Pad1Buttons(*this, (pad[0].button & ~previous_pad[0].button) | (this == &GamePad__2 ? MenuMouseButtons() : 0), true);
}

PORT_OVERRIDE int CGamePad::GetPadOn() {
    if (key_lock) {
        return 0;
    }
    return Pad1Buttons(*this, pad[0].button);
}

PORT_OVERRIDE int CGamePad::GetPadUp() {
    if (key_lock) {
        return 0;
    }
    return Pad1Buttons(*this, ~pad[0].button & previous_pad[0].button, true);
}

PORT_OVERRIDE int CGamePad::On(int mask) { return (GetPadOn() & mask) != 0; }

PORT_OVERRIDE int CGamePad::Up(int mask) { return (GetPadUp() & mask) != 0; }
