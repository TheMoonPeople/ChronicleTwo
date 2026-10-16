#include "common.h"

#include "mainloop.hpp"
#include "menu_mouse_item.hpp"
#include "menuchr_port.hpp"
#include "padcontrol.hpp"
#include "platform/input.hpp"

PORT_OVERRIDE void CPadControl::Update(CGamePad *pad) {
    // The logical gameplay sample follows the retail pad read once per frame.
    // Latch the independent mouse channel here, including while menus own input,
    // so motion from a paused or scripted camera cannot queue up for gameplay.
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
