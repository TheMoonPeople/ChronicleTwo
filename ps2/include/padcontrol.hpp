#pragma once

#include "common.h"

/**
 * @file
 * Declares the logical controller map, which binds numbered game actions to
 * controller buttons and stick axes and samples them once per frame.
 */

class CGamePad;

/** Number of logical buttons a CPadControl holds. */
#define PAD_CTRL_BTN_MAX 128

/** Number of logical stick axes a CPadControl holds. */
#define PAD_CTRL_ANALOG_MAX 32

/**
 *
 * When a logical button reports its controller buttons, held in the
 * PAD_CTRL_TRIGGER_MASK bits of PAD_CTRL_BTN::config.
 *
 */
// clang-format off
enum PadCtrlTrigger {
    PAD_CTRL_TRIGGER_ON   = 0x00000, /**< While held, as CGamePad::On reports. */
    PAD_CTRL_TRIGGER_DOWN = 0x10000, /**< On the frame pressed, as CGamePad::Down reports. */
    PAD_CTRL_TRIGGER_UP   = 0x20000, /**< On the frame released, as CGamePad::Up reports. */
    PAD_CTRL_TRIGGER_MASK = 0xF0000, /**< Bits of PAD_CTRL_BTN::config holding the trigger. */
    PAD_CTRL_BUTTON_MASK  = 0x0FFFF, /**< Bits of PAD_CTRL_BTN::config holding the buttons. */
};

/**
 *
 * Logical button actions bound by the main loop and sampled each frame.
 *
 */
enum PadCtrlButton {
    PAD_BTN_CONFIRM            = 0,
    PAD_BTN_CANCEL             = 1,
    PAD_BTN_R1_HELD            = 2,    /**< R1 while held. */
    PAD_BTN_L1_HELD            = 3,    /**< L1 while held. */
    PAD_BTN_MENU               = 5,
    PAD_BTN_UP                 = 7,    /**< Up on the frame pressed. */
    PAD_BTN_DOWN               = 8,    /**< Down on the frame pressed. */
    PAD_BTN_RIGHT              = 9,
    PAD_BTN_LEFT               = 10,
    PAD_BTN_START              = 0x0F,
    PAD_BTN_PAUSE              = 0x15,
    PAD_BTN_EVENT_SKIP         = 0x16,
    PAD_BTN_QUICK_CHANGE       = 0x17,
    PAD_BTN_ACTION_CONFIRM     = 0x32,
    PAD_BTN_ACTION_SQUARE      = 0x33,
    PAD_BTN_ACTION_CANCEL      = 0x34,
    PAD_BTN_ACTION_HELD        = 0x38,
    PAD_BTN_EDIT_TURN_DECREASE = 0x64, /**< R2: turns the selected Georama part one way. */
    PAD_BTN_EDIT_TURN_INCREASE = 0x65, /**< L2: turns the selected Georama part the other way. */
    PAD_BTN_EDIT_PLACE         = 0x66, /**< Confirm button: places a Georama part or selects a wall. */
    PAD_BTN_EDIT_REMOVE        = 0x67, /**< Confirm button: starts digging out the selected Georama part. */
    PAD_BTN_EDIT_PAINT         = 0x68, /**< Confirm button: paints the selected Georama surface. */
    PAD_BTN_EDIT_WALL_NEXT     = 0x69, /**< R2: selects the next wall. */
    PAD_BTN_EDIT_WALL_PREVIOUS = 0x6A, /**< L2: selects the previous wall. */
    PAD_BTN_EDIT_PAINT_ALL     = 0x6B, /**< Square: paints the roof or the whole fence. */
    PAD_BTN_EDIT_SWITCH        = 0x6C,
    PAD_BTN_EDIT_MAGNET        = 0x6D, /**< Square: toggles Georama part snapping. */
};
// clang-format on

/**
 *
 * Logical stick axes, as the main loop binds them to the pad's sticks.
 *
 */
enum PadCtrlAnalog {
    PAD_ANALOG_LEFT_X  = 0, /**< Left stick horizontal position. */
    PAD_ANALOG_LEFT_Y  = 1, /**< Left stick vertical position. */
    PAD_ANALOG_RIGHT_X = 2, /**< Right stick horizontal position. */
    PAD_ANALOG_RIGHT_Y = 3, /**< Right stick vertical position. */
};

/**
 *
 * Stick axes a logical stick axis can read, as PAD_CTRL_ANALOG::axis holds
 * them.
 *
 */
// clang-format off
enum PadCtrlAxis {
    PAD_CTRL_AXIS_NONE = 0, /**< Unbound; the value is left as it is. */
    PAD_CTRL_AXIS_LX   = 1, /**< Left stick horizontal position. */
    PAD_CTRL_AXIS_LY   = 2, /**< Left stick vertical position. */
    PAD_CTRL_AXIS_RX   = 3, /**< Right stick horizontal position. */
    PAD_CTRL_AXIS_RY   = 4, /**< Right stick vertical position. */
};
// clang-format on

/**
 *
 * One logical button of a CPadControl: its binding and its state this frame.
 *
 */
struct PAD_CTRL_BTN {
    int value;  /**< Result of the bound test this frame; nonzero when the button fires. */
    int config; /**< Controller buttons ORed with a trigger, or 0 when unbound. @see PadButton @see PadCtrlTrigger */
};

STATIC_ASSERT(sizeof(PAD_CTRL_BTN) == 0x8);

/**
 *
 * One logical stick axis of a CPadControl: its binding and its value this frame.
 *
 */
struct PAD_CTRL_ANALOG {
    float value; /**< Position of the bound axis this frame, from -1 to 1. */
    int   axis;  /**< Stick axis read. @see PadCtrlAxis */
};

STATIC_ASSERT(sizeof(PAD_CTRL_ANALOG) == 0x8);

/**
 *
 * Map of numbered game actions onto controller buttons and stick axes, read by gameplay code.
 *
 */
class CPadControl {
public:
    float           rx;                          /**< Right stick horizontal position this frame. */
    float           ry;                          /**< Right stick vertical position this frame. */
    float           lx;                          /**< Left stick horizontal position this frame. */
    float           ly;                          /**< Left stick vertical position this frame. */
    PAD_CTRL_BTN    btn[PAD_CTRL_BTN_MAX];       /**< Logical buttons, by number. */
    PAD_CTRL_ANALOG analog[PAD_CTRL_ANALOG_MAX]; /**< Logical stick axes, by number. */

    /**
     *
     * Unbinds every logical button and stick axis.
     *
     * @mangled Initialize__11CPadControlFv
     * @address 0x2F23E0
     * @size 0x80
     */
    void Initialize();

    /**
     *
     * Binds a logical button to controller buttons and a trigger, returning 1 if the number is valid.
     *
     * @mangled RegisterBtn__11CPadControlFiii
     * @address 0x2F2460
     * @size 0x3C
     */
    int RegisterBtn(int index, int mask, int flags);

    /**
     *
     * Binds a logical stick axis to a controller stick axis, returning 1 if the number is valid.
     *
     * @mangled RegisterAnalog__11CPadControlFii
     * @address 0x2F24A0
     * @size 0x38
     */
    int RegisterAnalog(int no, int axis);

    /**
     *
     * Gets a logical button's state this frame, or 0 for an invalid number.
     *
     * @mangled Btn__11CPadControlFi
     * @address 0x2F24E0
     * @size 0x34
     */
    int Btn(int no);

    /**
     *
     * Gets a logical stick axis's position this frame, or 0 for an invalid number.
     *
     * @mangled Analog__11CPadControlFi
     * @address 0x2F2520
     * @size 0x30
     */
    float Analog(int no);

    /**
     *
     * Samples the controller's sticks and every bound logical button and stick axis.
     *
     * @mangled Update__11CPadControlFP8CGamePad
     * @address 0x2F2550
     * @size 0x1A0
     */
    void Update(CGamePad *pad);
};

STATIC_ASSERT(sizeof(CPadControl) == 0x510);
