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

enum PadCtrlButton {
    PAD_BTN_CONFIRM        = 0,
    PAD_BTN_CANCEL         = 1,
    PAD_BTN_MENU           = 5,
    PAD_BTN_RIGHT          = 9,
    PAD_BTN_LEFT           = 10,
    PAD_BTN_START          = 0x0F,
    PAD_BTN_PAUSE          = 0x15,
    PAD_BTN_EVENT_SKIP     = 0x16,
    PAD_BTN_QUICK_CHANGE   = 0x17,
    PAD_BTN_ACTION_CONFIRM = 0x32,
    PAD_BTN_ACTION_SQUARE  = 0x33,
    PAD_BTN_ACTION_CANCEL  = 0x34,
    PAD_BTN_ACTION_HELD    = 0x38,
    PAD_BTN_EDIT_SWITCH    = 0x6C,
};

// clang-format on

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
