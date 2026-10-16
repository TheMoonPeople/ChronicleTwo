#pragma once

#include <string>
#include <string_view>

#include "platform/settings.hpp"

// Native gameplay always runs at the NTSC field rate, independently of configuration.
inline constexpr double kConfigTickRateDefault = 60.0;

enum class ConfigAspect {
    Auto,
    FourThree,
};

struct Config : HostSettings {
    bool         interpolation = true;
    bool         debug_mode = false;
    bool         autosave = true;
    ConfigAspect aspect = ConfigAspect::Auto;
    float        ui_scale = 1.0f;
    bool         font_sharp = false;
    bool         mouse_fixed_look = true;
    // audio.dualsense_speaker: the Ridepod's lines, the treasure chests' opening and the menus' effects
    // play on a DualSense speaker when one is found instead of the TV.
    bool dualsense_speaker = true;
    // audio.controller_volume: gain on the controller speaker, on top of the master volume.
    float controller_volume = 1.0f;

    bool operator==(const Config &) const = default;
};

// <save root>/config.json. A missing file is written with the defaults. A file that exists but cannot
// be read leaves the defaults in memory and is never written this session. Returns whether it was read.
bool ConfigLoad();
bool ConfigSave();
bool ConfigSaved();
// Applies and saves both the host settings and the game's presentation fields.
bool ConfigChange(const Config &config);

// Called by SettingsChange once a changed value is stored, with the settings before and after it.
using ConfigChangeHook = void (*)(const HostSettings &before, const HostSettings &after);
void ConfigSetChangeHook(ConfigChangeHook hook);

const Config &ConfigGet();

// Unknown keys and values of the wrong type or range keep their defaults and are reported on stderr.
Config      ConfigParse(std::string_view text);
std::string ConfigSerialize(const Config &config);
