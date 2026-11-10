#include "input_startup.hpp"

#include "platform/input.hpp"
#include "platform/settings.hpp"

void InputApplyGameConfig(const HostSettings &settings) {
    auto input_settings = settings;
    input_settings.stick_invert_x = !settings.stick_invert_x;
    input_settings.stick_invert_y = !settings.stick_invert_y;
    InputApplyConfig(input_settings);
}

void InputInitForRun(bool devices_closed) {
    if (!devices_closed) {
        InputInit();
    }
    InputApplyGameConfig(SettingsGet());
}
