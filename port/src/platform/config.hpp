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

// input.dualsense_haptics: what a DualSense's actuators play (see dualsense_haptics.hpp).
enum class ConfigHaptics {
    Off,       // Classic rumble only.
    Vibration, // The game's own vibration, played on the actuators.
    Full,      // Also camera quakes and the effects of the player, battles and monsters.
};

struct Config : HostSettings {
    bool         interpolation = true;
    // Skip tweened display frames when a tick records more mesh+2D draws than this (0 = never skip).
    // Off by default: draw counts do not track GPU cost, and ordinary towns record 2900-4200 draws.
    // interpolation_fps_floor already drops tweening on a machine that cannot keep up.
    int interpolation_draw_budget = 0;
    int interpolation_fps_floor = 54;
    // False allows one tweened present per tick slice, which holds the display near 60 FPS.
    bool interpolation_multi_present = true;
    bool         debug_mode = false;
    bool         autosave = true;
    // game.quick_loadout_title "plate": the quick loadout's title on a plate like the EXP gauge's, not on a bar.
    bool         quick_loadout_plate = false;
    // Skips the SCE "moji" boot logo and the title-screen Sony / Level-5 sequences.
    bool         skip_intro = false;
    // Scales Georama polygon build budgets (1 = retail caps, up to 6).
    int          georama_poly_multiplier = 1;
    // When on, up to 60 monsters can be active on a dungeon floor (retail is 24).
    bool         expanded_dungeon_monsters = false;
    // When on, event Use Item prompts with a single required id auto-confirm if owned.
    bool         auto_use_event_item = false;
    // game.floor_info_monsters: Triangle on a dungeon floor's information lists its monsters and their drops.
    bool         floor_info_monsters = false;
    ConfigAspect aspect = ConfigAspect::Auto;
    // video.fps_detail "budget": frame-budget ms lines in the FPS overlay (stored separately from Kazarov's enum).
    bool         fps_detail_budget = false;
    float        ui_scale = 1.0f;
    bool         font_sharp = false;
    bool         mouse_fixed_look = true;
    // audio.dualsense_speaker: the Ridepod's lines, the treasure chests' opening and the menus' effects
    // play on a DualSense speaker when one is found instead of the TV.
    bool dualsense_speaker = true;
    // audio.controller_volume: gain on the controller speaker, on top of the master volume.
    float controller_volume = 1.0f;
    ConfigHaptics dualsense_haptics = ConfigHaptics::Full;
    // input.haptics_strength: gain on the DualSense actuators.
    float haptics_strength = 1.0f;

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
