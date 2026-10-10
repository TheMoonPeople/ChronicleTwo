#pragma once

#include "common.h"

#define PAD_ANALOG_CENTER 0x80

/**
 * @file
 * Declares the game controller manager, which reads both controller ports,
 * derives pressed, released and repeated buttons, and drives vibration.
 */

/**
 *
 * Steps of a controller's setup, as PAD_STATUS::phase holds them.
 *
 */
// clang-format off
enum PadSetupPhase {
    PAD_PHASE_QUERY          = 0,  /**< Reading the controller type. */
    PAD_PHASE_ANALOG_CHECK   = 40, /**< Checking for analog mode. */
    PAD_PHASE_ANALOG_SET     = 41, /**< Locking analog mode. */
    PAD_PHASE_ANALOG_WAIT    = 42, /**< Waiting for analog mode. */
    PAD_PHASE_ACTUATOR_CHECK = 70, /**< Checking for actuators. */
    PAD_PHASE_ACTUATOR_WAIT  = 71, /**< Waiting for the actuators. */
    PAD_PHASE_READY          = 99, /**< Reading buttons. */
};

// clang-format on

/**
 *
 * Controller types that scePadInfoMode and the controller's data report.
 *
 */
// clang-format off
enum PadTerminalId {
    PAD_TERMINAL_NEGCON          = 2,     /**< NeGcon. */
    PAD_TERMINAL_KONAMI_GUN      = 3,     /**< Konami gun. */
    PAD_TERMINAL_DIGITAL         = 4,     /**< Digital controller. */
    PAD_TERMINAL_ANALOG_JOYSTICK = 5,     /**< Analog joystick. */
    PAD_TERMINAL_NAMCO_GUN       = 6,     /**< Namco gun. */
    PAD_TERMINAL_DUALSHOCK       = 7,     /**< DualShock. */
    PAD_TERMINAL_EX_TSURICON     = 0x100, /**< Fishing controller. */
    PAD_TERMINAL_EX_JOGCON       = 0x300, /**< Jog controller. */
};

// clang-format on

/**
 *
 * Bits of a controller's button word, one per button.
 *
 */
// clang-format off
enum PadButton {
    PAD_L2       = 0x0001, /**< L2 shoulder button. */
    PAD_R2       = 0x0002, /**< R2 shoulder button. */
    PAD_L1       = 0x0004, /**< L1 shoulder button. */
    PAD_R1       = 0x0008, /**< R1 shoulder button. */
    PAD_TRIANGLE = 0x0010, /**< Triangle button. */
    PAD_CIRCLE   = 0x0020, /**< Circle button. */
    PAD_CROSS    = 0x0040, /**< Cross button. */
    PAD_SQUARE   = 0x0080, /**< Square button. */
    PAD_SELECT   = 0x0100, /**< Select button. */
    PAD_L3       = 0x0200, /**< Left stick press. */
    PAD_R3       = 0x0400, /**< Right stick press. */
    PAD_START    = 0x0800, /**< Start button. */
    PAD_UP       = 0x1000, /**< Up on the directional pad. */
    PAD_RIGHT    = 0x2000, /**< Right on the directional pad. */
    PAD_DOWN     = 0x4000, /**< Down on the directional pad. */
    PAD_LEFT     = 0x8000, /**< Left on the directional pad. */
};

// clang-format on

/**
 *
 * Vibration actuators of a DualShock, as CGamePad::SetVibration selects them.
 *
 */
// clang-format off
enum PadMotor {
    PAD_MOTOR_SMALL = 0, /**< Small actuator, either on or off. */
    PAD_MOTOR_LARGE = 1, /**< Large actuator, with a strength from 0 to 255. */
};

// clang-format on

/**
 *
 * Input recording modes, as CGamePad::capture_mode holds them.
 *
 */
// clang-format off
enum PadCaptureMode {
    PAD_CAPTURE_OFF    = 0, /**< Controller input is neither recorded nor replayed. */
    PAD_CAPTURE_RECORD = 1, /**< First-controller input is recorded each frame. */
    PAD_CAPTURE_PLAY   = 2, /**< First-controller input is replaced by the recording. */
};

#pragma push
#pragma cpp_extensions on
// clang-format on

/**
 *
 * Defines the state of one controller: its buttons, sticks, setup
 * progress and vibration.
 *
 */
struct PAD_STATUS {
    int button;            /**< Pressed buttons. @see PadButton */
    int left_y;            /**< Left stick vertical position, 0 to 255 with 0x80 at rest. */
    int left_x;            /**< Left stick horizontal position, 0 to 255 with 0x80 at rest. */
    int right_y;           /**< Right stick vertical position, 0 to 255 with 0x80 at rest. */
    int right_x;           /**< Right stick horizontal position, 0 to 255 with 0x80 at rest. */
    int phase;             /**< Controller setup step. @see PadSetupPhase */
    int state;             /**< Connection state scePadGetState last reported. */
    int extended_id;       /**< Extended controller type scePadInfoMode reports. @see PadTerminalId */
    int pad_mode;          /**< Controller type of the latest read. @see PadTerminalId */
    int previous_pad_mode; /**< Controller type of the previous successful read. @see PadTerminalId */
    u8  vibration[6];      /**< Actuator values sent to the controller. @see PadMotor */
    u8  actuator[6];       /**< Actuator alignment sent to the controller. */

    union {
        int vibration_words[6]; /**< Vibration timers and values viewed as one word array. */

        struct {
            int vibration_timer[2]; /**< Remaining time of each actuator, in vertical blanks. @see PadMotor */
            int unk_3C;
            int unk_40;
            int unk_44;
            int unk_48;
        };
    };
};

STATIC_ASSERT(sizeof(PAD_STATUS) == 0x4C);
#pragma pop

/**
 *
 * Defines the automatic button repeat state of one controller.
 *
 */
struct PAD_REPEAT {
    int enabled;           /**< Buttons with automatic repeat. @see PadButton */
    int active;            /**< Buttons held past their initial delay. @see PadButton */
    int counter[32];       /**< Frames each button has been held since its last repeat. */
    int initial_delay[32]; /**< Frames each button is held before it starts to repeat. */
    int repeat_delay[32];  /**< Frames between repeats of each button. */
};

STATIC_ASSERT(sizeof(PAD_REPEAT) == 0x188);

/**
 *
 * Defines one frame of recorded first-controller input.
 *
 */
struct PAD_CAPTURE_FRAME {
    u16 button;  /**< Pressed buttons. @see PadButton */
    u8  left_y;  /**< Left stick vertical position. */
    u8  left_x;  /**< Left stick horizontal position. */
    u8  right_y; /**< Right stick vertical position. */
    u8  right_x; /**< Right stick horizontal position. */
};

STATIC_ASSERT(sizeof(PAD_CAPTURE_FRAME) == 0x6);

/**
 *
 * Sizes of the one-megabyte input recording in development kit memory.
 *
 */
enum {
    PAD_CAPTURE_BUFFER_SIZE = 0x100000,                                          /**< Bytes reserved for the recording. */
    PAD_CAPTURE_FRAME_MAX = PAD_CAPTURE_BUFFER_SIZE / sizeof(PAD_CAPTURE_FRAME), /**< Frames the recording holds. */
};

/**
 *
 * Start of the input recording in development kit memory.
 *
 */
#define PAD_CAPTURE_BUFFER ((PAD_CAPTURE_FRAME *) 0x3000000)

/**
 *
 * Scheduling priority shared by the main thread and the controller thread,
 * whose ready queue SwitchGamePadThread rotates.
 *
 */
enum {
    GAMEPAD_THREAD_PRIORITY = 10, /**< Priority of both threads. */
};

/**
 *
 * Manages both game controllers: reads them, keeps the previous frame's
 * state to find newly pressed and released buttons, applies automatic
 * repeat and input locks, drives vibration, and records or replays input.
 *
 */
class CGamePad {
public:
    int        unk_000;
    PAD_STATUS pad[2];          /**< Current state of each controller. */
    PAD_STATUS previous_pad[2]; /**< State of each controller on the previous frame. */
    int        unk_134;
    int        unk_138;
    int        unk_13C;
    int        unk_140;
    PAD_REPEAT repeat[2];         /**< Automatic repeat state of each controller. */
    int        axis_threshold[2]; /**< Left stick deflection past which each controller's stick acts as the directional pad; 0 turns this off. */
    int        key_lock;          /**< Nonzero to ignore both controllers. */
    int        key_lock2;         /**< Nonzero to ignore the second controller. */
    int        debug_key_lock;    /**< Nonzero while the debug lock of the second controller is set. */
    int        vibration_enabled; /**< Nonzero when vibration may run. */
    int        vibration_elapsed; /**< Vertical blanks since vibration last changed; vibration stops past 1000. */
    int        capture_mode;      /**< Input recording mode. @see PadCaptureMode */
    u32        capture_frame;     /**< Number of frames recorded or replayed. */

    /**
     *
     * Initializes the controller library, clears both controllers' state
     * and opens both controller ports.
     *
     * @mangled Init__8CGamePadFv
     * @address 0x14A650
     * @size 0x1FC
     */
    void Init();

    /**
     *
     * Closes both controller ports and shuts down the controller library.
     *
     * @mangled Close__8CGamePadFv
     * @address 0x14A850
     * @size 0x34
     */
    void Close();

    /**
     *
     * Waits until each controller is ready or disconnected.
     *
     * @mangled WaitEnable__8CGamePadFv
     * @address 0x14ACF0
     * @size 0xB8
     */
    void WaitEnable();

    /**
     *
     * Tests whether the first controller is connected and usable.
     *
     * @mangled Connect__8CGamePadFv
     * @address 0x14ADB0
     * @size 0x3C
     */
    int Connect();

    /**
     *
     * Reads both controllers once a frame and derives the menu, repeat
     * and lock adjustments of their buttons.
     *
     * @mangled UpDate__8CGamePadFv
     * @address 0x14ADF0
     * @size 0x4F4
     */
    void UpDate();

    /**
     *
     * Counts down the vibration timers and sends the actuator values.
     *
     * @mangled Step__8CGamePadFi
     * @address 0x14B2F0
     * @size 0xC0
     */
    void Step(int elapsed);

    /**
     *
     * Gets the calibrated first-controller right stick horizontal position.
     *
     * @mangled GetRX__8CGamePadFv
     * @address 0x14B440
     * @size 0x8
     */
    int GetRX();

    /**
     *
     * Gets the calibrated first-controller right stick vertical position.
     *
     * @mangled GetRY__8CGamePadFv
     * @address 0x14B450
     * @size 0x8
     */
    int GetRY();

    /**
     *
     * Gets the calibrated first-controller left stick horizontal position.
     *
     * @mangled GetLX__8CGamePadFv
     * @address 0x14B460
     * @size 0x8
     */
    int GetLX();

    /**
     *
     * Gets the calibrated first-controller left stick vertical position.
     *
     * @mangled GetLY__8CGamePadFv
     * @address 0x14B470
     * @size 0x8
     */
    int GetLY();

    /**
     *
     * Gets the calibrated second-controller right stick horizontal position.
     *
     * @mangled GetRX2__8CGamePadFv
     * @address 0x14B480
     * @size 0x8
     */
    int GetRX2();

    /**
     *
     * Cancels automatic repeat of the first controller's selected buttons.
     *
     * @mangled CancelAutoRepeat__8CGamePadFi
     * @address 0x14B490
     * @size 0x64
     */
    void CancelAutoRepeat(int mask);

    /**
     *
     * Cancels automatic repeat of the second controller's selected buttons.
     *
     * @mangled CancelAutoRepeat2__8CGamePadFi
     * @address 0x14B500
     * @size 0x64
     */
    void CancelAutoRepeat2(int mask);

    /**
     *
     * Sets up automatic repeat of the first controller's selected buttons.
     *
     * @mangled SetAutoRepeat__8CGamePadFiii
     * @address 0x14B570
     * @size 0x7C
     */
    void SetAutoRepeat(int mask, int initial_delay, int repeat_delay);

    /**
     *
     * Sets up automatic repeat of the second controller's selected buttons
     * that do not repeat yet.
     *
     * @mangled SetAutoRepeat2__8CGamePadFiii
     * @address 0x14B5F0
     * @size 0x84
     */
    void SetAutoRepeat2(int mask, int initial_delay, int repeat_delay);

    /**
     *
     * Sets the lock that makes both controllers read as idle.
     *
     * @mangled KeyLock__8CGamePadFi
     * @address 0x14B680
     * @size 0x8
     */
    void KeyLock(int lock);

    /**
     *
     * Sets the lock that makes the second controller read as idle.
     *
     * @mangled KeyLock2__8CGamePadFi
     * @address 0x14B690
     * @size 0x8
     */
    void KeyLock2(int lock);

    /**
     *
     * Sets the debug lock, which also locks the second controller.
     *
     * @mangled DebugKeyLock__8CGamePadFi
     * @address 0x14B6A0
     * @size 0x8
     */
    void DebugKeyLock(int lock);

    /**
     *
     * Gets the buttons held on the first controller.
     *
     * @mangled GetPadOn__8CGamePadFv
     * @address 0x14B6B0
     * @size 0x24
     */
    int GetPadOn();

    /**
     *
     * Gets the buttons newly pressed on the first controller.
     *
     * @mangled GetPadDown__8CGamePadFv
     * @address 0x14B6E0
     * @size 0x2C
     */
    int GetPadDown();

    /**
     *
     * Gets the buttons newly released on the first controller.
     *
     * @mangled GetPadUp__8CGamePadFv
     * @address 0x14B710
     * @size 0x2C
     */
    int GetPadUp();

    /**
     *
     * Gets the first-controller right stick horizontal position from -1 to 1.
     *
     * @mangled GetRXf__8CGamePadFv
     * @address 0x14B740
     * @size 0x3C
     */
    float GetRXf();

    /**
     *
     * Gets the first-controller right stick vertical position from -1 to 1.
     *
     * @mangled GetRYf__8CGamePadFv
     * @address 0x14B780
     * @size 0x3C
     */
    float GetRYf();

    /**
     *
     * Gets the first-controller left stick horizontal position from -1 to 1.
     *
     * @mangled GetLXf__8CGamePadFv
     * @address 0x14B7C0
     * @size 0x3C
     */
    float GetLXf();

    /**
     *
     * Gets the first-controller left stick vertical position from -1 to 1.
     *
     * @mangled GetLYf__8CGamePadFv
     * @address 0x14B800
     * @size 0x3C
     */
    float GetLYf();

    /**
     *
     * Gets the second-controller right stick horizontal position from -1 to 1.
     *
     * @mangled GetRXf2__8CGamePadFv
     * @address 0x14B840
     * @size 0x3C
     */
    float GetRXf2();

    /**
     *
     * Tests whether the first controller holds any of the given buttons.
     *
     * @mangled On__8CGamePadFi
     * @address 0x14B880
     * @size 0x28
     */
    int On(int mask);

    /**
     *
     * Tests whether the second controller holds any of the given buttons.
     *
     * @mangled On2__8CGamePadFi
     * @address 0x14B8B0
     * @size 0x3C
     */
    int On2(int mask);

    /**
     *
     * Tests whether the first controller newly presses any of the given buttons.
     *
     * @mangled Down__8CGamePadFi
     * @address 0x14B8F0
     * @size 0x34
     */
    int Down(int mask);

    /**
     *
     * Tests whether the second controller newly presses any of the given buttons.
     *
     * @mangled Down2__8CGamePadFi
     * @address 0x14B930
     * @size 0x48
     */
    int Down2(int mask);

    /**
     *
     * Tests whether the first controller newly releases any of the given buttons.
     *
     * @mangled Up__8CGamePadFi
     * @address 0x14B980
     * @size 0x34
     */
    int Up(int mask);

    /**
     *
     * Cancels automatic repeat of every first-controller button.
     *
     * @mangled AutoRepeatOff__8CGamePadFv
     * @address 0x14B9C0
     * @size 0x8
     */
    void AutoRepeatOff();

    /**
     *
     * Makes the first controller's left stick act as the directional pad
     * past a deflection threshold.
     *
     * @mangled MenuModeOn__8CGamePadFi
     * @address 0x14B9D0
     * @size 0x8
     */
    void MenuModeOn(int threshold);

    /**
     *
     * Stops the first controller's left stick acting as the directional pad.
     *
     * @mangled MenuModeOff__8CGamePadFv
     * @address 0x14B9E0
     * @size 0x8
     */
    void MenuModeOff();

    /**
     *
     * Runs one actuator of the first controller at a strength for a time.
     *
     * @mangled SetVibration__8CGamePadFiii
     * @address 0x14B9F0
     * @size 0x58
     */
    void SetVibration(int motor, int strength, int duration);

    /**
     *
     * Allows or forbids vibration.
     *
     * @mangled VibrationEnable__8CGamePadFi
     * @address 0x14BA50
     * @size 0x8
     */
    void VibrationEnable(int enable);

    /**
     *
     * Stops both actuators of the first controller at once.
     *
     * @mangled StopVibration__8CGamePadFv
     * @address 0x14BA60
     * @size 0x50
     */
    void StopVibration();

    /**
     *
     * Starts recording first-controller input from the first frame.
     *
     * @mangled CaptureStart__8CGamePadFv
     * @address 0x14BAB0
     * @size 0x10
     */
    void CaptureStart();

    /**
     *
     * Stops recording or replaying input.
     *
     * @mangled CaptureEnd__8CGamePadFv
     * @address 0x14BAC0
     * @size 0xC
     */
    void CaptureEnd();

    /**
     *
     * Starts replaying the recorded first-controller input.
     *
     * @mangled CapturePlay__8CGamePadFv
     * @address 0x14BAD0
     * @size 0xC
     */
    void CapturePlay();

    /**
     *
     * Records one frame of a controller's input.
     *
     * @mangled Capture__8CGamePadFP10PAD_STATUS
     * @address 0x14BAE0
     * @size 0x64
     */
    void Capture(PAD_STATUS *pad);

    /**
     *
     * Replaces a controller's input with the next recorded frame.
     *
     * @mangled Play__8CGamePadFP10PAD_STATUS
     * @address 0x14BB50
     * @size 0x64
     */
    void Play(PAD_STATUS *status);

    /**
     *
     * Writes the recorded input to the host as key_cap.bin.
     *
     * @mangled SaveCapture__8CGamePadFv
     * @address 0x14BBC0
     * @size 0x20
     */
    void SaveCapture();

    /**
     *
     * Loads recorded input from key_cap.bin.
     *
     * @mangled LoadCapture__8CGamePadFv
     * @address 0x14BBE0
     * @size 0x40
     */
    void LoadCapture();
};

STATIC_ASSERT(sizeof(CGamePad) == 0x478);

/**
 *
 * Yields the processor to the next thread of the same priority, switching
 * between the main thread and the controller thread.
 *
 * @mangled SwitchGamePadThread__Fv
 * @address 0x14BC20
 * @size 0x8
 */
void SwitchGamePadThread();

/**
 *
 * Creates and starts the thread that steps a controller manager's
 * vibration every vertical blank.
 *
 * @mangled CreateGamePadThread__FP8CGamePad
 * @address 0x14BC90
 * @size 0x70
 */
void CreateGamePadThread(CGamePad *game_pad);
