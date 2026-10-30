#include "common.h"

#include "gamepad.hpp"
#include "padcontrol.hpp"

void CPadControl::Initialize() {
    for (int i = 0; i < PAD_CTRL_BTN_MAX; i++) {
        btn[i].config = 0;
    }

    for (int i = 0; i < PAD_CTRL_ANALOG_MAX; i++) {
        analog[i].axis = PAD_CTRL_AXIS_NONE;
    }
}

int CPadControl::RegisterBtn(int index, int mask, int flags) {
    if (index < 0 || index >= PAD_CTRL_BTN_MAX) {
        return 0;
    }

    btn[index].value = 0;
    btn[index].config = flags | mask;
    return 1;
}

int CPadControl::RegisterAnalog(int no, int axis) {
    if (no < 0 || no >= PAD_CTRL_ANALOG_MAX) {
        return 0;
    }

    analog[no].axis = axis;
    analog[no].value = 0.0f;
    return 1;
}

int CPadControl::Btn(int no) {
    if (no < 0 || no >= PAD_CTRL_BTN_MAX) {
        return 0;
    }

    return btn[no].value;
}

float CPadControl::Analog(int no) {
    if (no < 0 || no >= PAD_CTRL_ANALOG_MAX) {
        return 0.0f;
    }

    return analog[no].value;
}

#include "common.h"

#include "mainloop.hpp"
#include "menu_mouse_item.hpp"
#include "object/character/quick_change_presentation.hpp"
#include "padcontrol.hpp"
#include "platform/input.hpp"

void CPadControl::Update(CGamePad *pad) {
    // Latch the mouse with the once-per-frame pad read, even while menus own input, so motion during a
    // paused or scripted camera cannot queue up for gameplay.
    if (pad == &GamePad__2) {
        InputLatchPad(0);
        MenuMousePadTick();
    }
    rx = pad->GetRXf();
    ry = pad->GetRYf();
    lx = pad->GetLXf();
    ly = pad->GetLYf();
    for (auto &entry : btn) {
        if (!entry.config) {
            continue;
        }
        const int button = entry.config & 0xFFFF;
        switch (entry.config & PAD_CTRL_TRIGGER_MASK) {
            case PAD_CTRL_TRIGGER_ON:
                entry.value = pad->On(button);
                break;
            case PAD_CTRL_TRIGGER_DOWN:
                entry.value = pad->Down(button);
                break;
            case PAD_CTRL_TRIGGER_UP:
                entry.value = pad->Up(button);
                break;
        }
    }
    // Town quick changes wait for the last one's effect, as dungeon ones do in ChangeSetUnit.
    if (PortQuickChangeCoolingDown()) {
        btn[PAD_BTN_QUICK_CHANGE].value = 0;
    }
    for (auto &entry : analog) {
        switch (entry.axis) {
            case PAD_CTRL_AXIS_LX:
                entry.value = lx;
                break;
            case PAD_CTRL_AXIS_LY:
                entry.value = ly;
                break;
            case PAD_CTRL_AXIS_RX:
                entry.value = rx;
                break;
            case PAD_CTRL_AXIS_RY:
                entry.value = ry;
                break;
            case PAD_CTRL_AXIS_NONE:
                break;
        }
    }
}
