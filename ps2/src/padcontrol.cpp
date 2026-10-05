#include "common.h"
#include "padcontrol.hpp"
#include "gamepad.hpp"

// Code (.text)
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

void CPadControl::Update(CGamePad *pad) {
    int i;
    int j;

    rx = pad->GetRXf();
    ry = pad->GetRYf();
    lx = pad->GetLXf();
    ly = pad->GetLYf();
    for (i = 0; i < PAD_CTRL_BTN_MAX; i++) {
        PAD_CTRL_BTN *entry = &btn[i];
        int mask = entry->config;
        if (mask != 0) {
            int button = mask & 0xFFFF;
            switch (mask & PAD_CTRL_TRIGGER_MASK) {
        case PAD_CTRL_TRIGGER_ON:
                    entry->value = pad->On(button);
            break;
        case PAD_CTRL_TRIGGER_DOWN:
                    entry->value = pad->Down(button);
            break;
        case PAD_CTRL_TRIGGER_UP:
                    entry->value = pad->Up(button);
            break;
        }
    }
}
    for (j = 0; j < PAD_CTRL_ANALOG_MAX; j++) {
        PAD_CTRL_ANALOG *axis = &analog[j];
        switch (axis->axis) {
        case PAD_CTRL_AXIS_LX:
                axis->value = lx;
            break;
        case PAD_CTRL_AXIS_LY:
                axis->value = ly;
            break;
        case PAD_CTRL_AXIS_RX:
                axis->value = rx;
            break;
        case PAD_CTRL_AXIS_RY:
                axis->value = ry;
                break;
            case PAD_CTRL_AXIS_NONE:
            break;
        }
    }
}
