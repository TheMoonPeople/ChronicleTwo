#pragma once

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
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
enum class StepResult {
    Unchanged,
    Saved,
    NotSaved
};
// Steps the row as Left (-1) and Right (1) do in the game, and saves config.json.
StepResult SettingsStep(int page, int row, int direction);

// Game data discovery and background extraction.
void LeaveNote();
bool DataMissing(const std::string &root);
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

extern "C" {
#define CT_IOS_NOEXCEPT noexcept
#else
#define CT_IOS_NOEXCEPT
#endif

/**
 * Owns UTF-8 bytes returned by the native iOS bridge.
 */
typedef struct IosString {
    uint8_t *data; /**< Owned bytes released by IosStringFree, or null for empty text. */
    size_t   size; /**< Number of UTF-8 bytes, including any embedded null bytes. */
} IosString;

/**
 * Describes the touch gamepad's buttons and stick deflections.
 */
typedef struct IosTouchState {
    uint16_t buttons; /**< Active-high pad button word. */
    float    left_x;  /**< Left stick's horizontal deflection. */
    float    left_y;  /**< Left stick's vertical deflection. */
    float    right_x; /**< Right stick's horizontal deflection. */
    float    right_y; /**< Right stick's vertical deflection. */
} IosTouchState;

/**
 * Reports whether a settings step changed the live configuration and saved it.
 */
typedef struct IosSettingsChange {
    bool changed; /**< Whether the requested step changed a setting. */
    bool saved;   /**< Whether the changed setting was written to disk. */
} IosSettingsChange;

/**
 * Owns a snapshot of background disc extraction progress and errors.
 */
typedef struct IosExtraction {
    bool      running;  /**< Whether extraction is still in progress. */
    float     fraction; /**< Fraction of extraction work completed. */
    IosString stage;    /**< Owned progress text released by IosExtractionFree. */
    IosString failure;  /**< Owned error text released by IosExtractionFree. */
} IosExtraction;

/**
 * Releases an owned UTF-8 result from the native iOS bridge.
 */
void IosStringFree(IosString text) CT_IOS_NOEXCEPT;

/**
 * Releases both owned strings in an extraction snapshot.
 */
void IosExtractionFree(IosExtraction extraction) CT_IOS_NOEXCEPT;

/**
 * Sets the touch gamepad state used by pad zero.
 */
void IosSetTouchOverlay(IosTouchState state) CT_IOS_NOEXCEPT;

/**
 * Reports whether the touch gamepad should be visible.
 */
bool IosTouchOverlayVisible(void) CT_IOS_NOEXCEPT;

/**
 * Returns the libpad bit for one on-screen gamepad button.
 */
uint16_t IosButtonBit(int index) CT_IOS_NOEXCEPT;

/**
 * Returns the sample rate of the DualSense actuator signal.
 */
int IosHapticsRate(void) CT_IOS_NOEXCEPT;

/**
 * Renders interleaved left and right DualSense actuator samples.
 */
void IosHapticsRender(float *left_right, int frames) CT_IOS_NOEXCEPT;

/**
 * Returns the owned title of the application settings page.
 */
IosString IosPageTitle(void) CT_IOS_NOEXCEPT;

/**
 * Returns the number of application settings sections.
 */
int IosSettingsPageCount(void) CT_IOS_NOEXCEPT;

/**
 * Returns the owned name of one application settings section.
 */
IosString IosSettingsPageName(int page) CT_IOS_NOEXCEPT;

/**
 * Returns the number of rows in one application settings section.
 */
int IosSettingsRowCount(int page) CT_IOS_NOEXCEPT;

/**
 * Reports whether a settings row can be stepped by the launcher.
 */
bool IosSettingsRowSteppable(int page, int row) CT_IOS_NOEXCEPT;

/**
 * Returns the owned label of one application settings row.
 */
IosString IosSettingsRowLabel(int page, int row) CT_IOS_NOEXCEPT;

/**
 * Returns the owned help text of one application settings row.
 */
IosString IosSettingsRowHelp(int page, int row) CT_IOS_NOEXCEPT;

/**
 * Returns the owned current value of one application settings row.
 */
IosString IosSettingsRowValue(int page, int row) CT_IOS_NOEXCEPT;

/**
 * Steps one setting and reports whether it changed and was saved.
 */
IosSettingsChange IosSettingsStep(int page, int row, int direction) CT_IOS_NOEXCEPT;

/**
 * Reports whether the borrowed UTF-8 root lacks current game data.
 */
bool IosDataMissing(const char *root) CT_IOS_NOEXCEPT;

/**
 * Returns an owned UTF-8 path to a discoverable disc image.
 */
IosString IosDiscImage(void) CT_IOS_NOEXCEPT;

/**
 * Starts extraction using borrowed UTF-8 paths copied before returning.
 */
void IosExtractBegin(const char *image, const char *root) CT_IOS_NOEXCEPT;

/**
 * Returns an owned snapshot of disc extraction progress and errors.
 */
IosExtraction IosExtractPoll(void) CT_IOS_NOEXCEPT;

/**
 * Runs the iOS launcher on the main thread until current game data is ready and Play is selected.
 */
void IosLauncherRunAt(const char *data_root);

/**
 * Attaches the touch gamepad to the game window while no physical input device is active.
 */
void IosTouchOverlayStart(void);

/**
 * Starts the Core Haptics worker if needed and reports whether the DualSense actuators are ready.
 */
bool IosHapticsReady(void);

#ifdef __cplusplus
}
#endif
#undef CT_IOS_NOEXCEPT
