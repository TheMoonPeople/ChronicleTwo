#pragma once

#include <string>
#include <string_view>

#include "platform/settings.hpp"
#include "timing.hpp"

// The disc is the PAL release, so its logic runs at the PAL field rate, not the NTSC 60 the host defaults to.
inline constexpr double kConfigTickRateDefault = 50.0;
inline constexpr double kConfigTickRateMin = 25.0;
inline constexpr double kConfigTickRateMax = 240.0;

enum class ConfigAspect {
    Auto,
    FourThree,
};

struct Config : HostSettings {
    Config() { tick_rate = kConfigTickRateDefault; }

    bool         interpolation = true;
    bool         debug_mode = false;
    TimingProfile timing = TimingProfile::Pal;
    ConfigAspect aspect = ConfigAspect::Auto;
    float        ui_scale = 1.0f;
    bool         font_sharp = false;
    bool         mouse_fixed_look = true;

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
