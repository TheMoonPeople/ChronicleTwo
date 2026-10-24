#pragma once

// The game as the iOS port's Swift code sees it, through Swift's C++ interoperability (module.modulemap names this
// header ChronicleBridge). It is kept to plain types, so the Swift compiler parses none of the game's own headers.

#include <cstdint>
#include <string>

namespace ct::ios {

// The on-screen gamepad: an active-high button word and stick deflections from -1 to 1 (InputTouchOverlayState).
struct TouchState {
    std::uint16_t buttons = 0;
    float         left_x = 0;
    float         left_y = 0;
    float         right_x = 0;
    float         right_y = 0;
};

// Pad 0 takes this while TouchOverlayVisible().
void SetTouchOverlay(const TouchState &state);
// No gamepad, keyboard or mouse connected and no key or mouse button held.
bool TouchOverlayVisible();
// The libpad bit of each on-screen button: Up, Down, Left, Right, Cross, Circle, Square, Triangle, L1, R1, L2, R2,
// Select, Start, L3, R3.
std::uint16_t ButtonBit(int index);

// The DualSense actuator signal (dualsense_haptics.hpp): interleaved left and right samples at HapticsRate().
int  HapticsRate();
void HapticsRender(float *left_right, int frames);

// The APP SETTINGS rows of the game's Options page (options::Pages).
std::string PageTitle();
int         SettingsPageCount();
std::string SettingsPageName(int page);
int         SettingsRowCount(int page);
// A row the launcher can step: one with a value and no binding, since bindings wait for a key in the game.
bool        SettingsRowSteppable(int page, int row);
std::string SettingsRowLabel(int page, int row);
std::string SettingsRowHelp(int page, int row);
std::string SettingsRowValue(int page, int row);
enum class StepResult { Unchanged, Saved, NotSaved };
// Steps the row as Left (-1) and Right (1) do in the game, and saves config.json.
StepResult  SettingsStep(int page, int row, int direction);

// The game data (ios/data.hpp).
bool        DataMissing(const std::string &root);
// The disc image found in Documents or its Inbox, or empty.
std::string DiscImage();
void        ExtractBegin(const std::string &image, const std::string &root);
struct Extraction {
    bool        running = false;
    float       fraction = 0;
    std::string stage;
    std::string failure;
};
Extraction ExtractPoll();

} // namespace ct::ios
