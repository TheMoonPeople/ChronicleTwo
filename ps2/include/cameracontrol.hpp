#pragma once

#include "common.h"

#include <libvu0.h>

#include "mg_camera.hpp"

/**
 * @file
 * Declares the player-steered camera that circles the player, turns and rises with the controller, and keeps clear of walls and the ground.
 */

class CPadControl;
struct CCPoly;

/**
 *
 * Identifies a CCameraControl, as its Iam function returns it.
 *
 */
enum CameraControlKind {
    CAMERA_KIND_CONTROL = 1000, /**< A CCameraControl. */
};

/**
 *
 * Bits of CCameraControl::rot_cancel, each of which stops one way that the camera moves.
 *
 */
// clang-format off
enum CameraRotCancel {
    CAMERA_ROT_CANCEL_BUTTON    = 0x1,  /**< The shoulder buttons do not turn the camera. */
    CAMERA_ROT_CANCEL_ANALOG    = 0x2,  /**< The right stick does not turn the camera. */
    CAMERA_ROT_CANCEL_ROT_BACK  = 0x40, /**< The button that swings the camera behind the player does nothing. */
    CAMERA_ROT_CANCEL_AUTO_MOVE = 0x80, /**< The camera does not swing round walls that hide the player. */
};

// clang-format on

/**
 *
 * Limits on the distance and the height of a controlled camera from the point that it looks at.
 *
 */
class CameraCtrlParam {
public:
    float min_dist;        /**< Distance, on the horizontal plane, that the eye keeps from the look-at point at the least. */
    float max_dist;        /**< Distance, on the horizontal plane, that the eye keeps from the look-at point at the most. */
    float near_height;     /**< Height added to the eye when it is at the least distance. */
    float far_height;      /**< Height added to the eye when it is at the most distance. */
    float height;          /**< Height of the eye above the look-at point, which the controller raises and lowers. */
    float max_height;      /**< Greatest height that the controller raises the eye to. */
    float min_height;      /**< Least height that the controller lowers the eye to. */
    float rest_max_height; /**< Greatest height that the eye drifts back below while the controller does not move it. */
    float rest_min_height; /**< Least height that the eye drifts back above while the controller does not move it. */
    float ground_space;    /**< Height that the eye keeps above the ground. */
    int   no_check;        /**< Non-zero when the eye goes through the ground and walls. */

    /**
     *
     * Makes the eye keep away from the ground and walls.
     *
     */
    CameraCtrlParam() { no_check = 0; }

#ifdef CAMERA_CONTROL_USE_RETAIL_ASSIGNMENT
    /**
     *
     * Copies every camera distance and height limit from another parameter set.
     *
     * @mangled __as__15CameraCtrlParamFRC15CameraCtrlParam
     * @address 0x1ACEE0
     * @size 0x60
     */
    CameraCtrlParam &operator=(const CameraCtrlParam &source);
#endif

    /**
     *
     * Gives every height limit, and the height of the eye, one value,
     * so that the eye stays at that height.
     *
     * @mangled SetFixHeight__15CameraCtrlParamFf
     * @address 0x2F0E50
     * @size 0x20
     */
    void SetFixHeight(float height);

    /**
     *
     * Gives the least and the greatest distance one value, so that the
     * eye stays at that distance.
     *
     * @mangled SetFixDist__15CameraCtrlParamFf
     * @address 0x2F0E70
     * @size 0x10
     */
    void SetFixDist(float dist);
};

STATIC_ASSERT(sizeof(CameraCtrlParam) == 0x2C);

/**
 *
 * Circles the player like its base camera until the player takes control; then turns and rises with the controller, within limits, and keeps the eye clear of walls and the ground.
 *
 */
class CCameraControl : public mgCCameraFollow {
public:
    /**
     *
     * Turn, rise and swing-back requests for one step of a controlled camera.
     *
     */
    struct Control {
        float rot;      /**< Angle, in radians, that the eye turns about the look-at point. */
        float height;   /**< Height that the eye rises by. */
        int   rot_back; /**< Non-zero to swing the eye round behind the player. */
    };

    int             control_on;     /**< Non-zero while the player steers the camera; zero leaves it circling as its base camera. */
    int             rot_cancel;     /**< CameraRotCancel bits that stop ways the camera moves. */
    int             rot_back;       /**< Non-zero while the eye swings round to the angle that it swings back to. */
    float           rot_back_angle; /**< Angle, in radians, that the eye swings back to. */
    int             rot_reverse;    /**< Non-zero to turn the camera the opposite way to the controller. */
    sceVu0FVECTOR   dir_offset;     /**< Offset added to the view direction when the camera matrix is made. */
    int             active_param;   /**< Index into param of the limits in use. */
    CameraCtrlParam param[4];       /**< Sets of limits on the distance and the height of the eye. */
    CameraCtrlParam default_param;  /**< Limits that the camera starts with. */
    sceVu0FVECTOR   check_ref;      /**< Point that walls and the ground are checked against, in place of the look-at point. */
    int             check_ref_on;   /**< Non-zero when walls and the ground are checked against check_ref. */

    /**
     *
     * Makes the camera circle a point at the default distance, height and
     * speed, with the default limits, and without the player's control.
     *
     * @mangled __ct__14CCameraControlFv
     * @address 0x2F0E80
     * @size 0x120
     */
    CCameraControl();

    /**
     *
     * Returns the limits in use.
     *
     * @mangled GetActiveParam__14CCameraControlFv
     * @address 0x2F0FA0
     * @size 0x30
     */
    CameraCtrlParam *GetActiveParam();

    /**
     *
     * Makes the limits in use the ones that the camera starts with.
     *
     */
    void SetDefaultParam() { default_param = *GetActiveParam(); }

    /**
     *
     * Sets the CameraRotCancel bits that stop ways the camera moves.
     *
     * @mangled SetRotCameraCancel__14CCameraControlFi
     * @address 0x2F0FD0
     * @size 0x10
     */
    void SetRotCameraCancel(int mask);

    /**
     *
     * Adds CameraRotCancel bits that stop ways the camera moves.
     *
     * @mangled BitSetRotCameraCancel__14CCameraControlFi
     * @address 0x2F0FE0
     * @size 0x10
     */
    void BitSetRotCameraCancel(int mask);

    /**
     *
     * Removes CameraRotCancel bits, letting the camera move those ways
     * again.
     *
     * @mangled BitResetRotCameraCancel__14CCameraControlFi
     * @address 0x2F0FF0
     * @size 0x20
     */
    void BitResetRotCameraCancel(int mask);

    /**
     *
     * Clears the cancel bits, stops any swing back, and removes the offset
     * from the view direction.
     *
     * @mangled InitStatus__14CCameraControlFv
     * @address 0x2F1010
     * @size 0x20
     */
    void InitStatus();

    /**
     *
     * Gives the player control of the camera, holding the eye and the
     * look-at point where they are and taking the height of the eye within
     * its limits.
     *
     * @mangled ControlOn__14CCameraControlFv
     * @address 0x2F1030
     * @size 0x90
     */
    void ControlOn();

    /**
     *
     * Takes control of the camera away from the player, so that it circles
     * as its base camera.
     *
     * @mangled ControlOff__14CCameraControlFv
     * @address 0x2F10C0
     * @size 0x10
     */
    void ControlOff();

    /**
     *
     * Stops the camera from moving, as its base camera does while it
     * circles, or as a plain camera does under control.
     *
     * @mangled Stay__14CCameraControlFv
     * @address 0x2F10D0
     * @size 0x40
     */
    virtual void Stay();

    /**
     *
     * Moves the camera one or more steps; under control, finishes any swing
     * back at once for a negative step count and measures the distance,
     * height and angles that the base camera keeps.
     *
     * @mangled Step__14CCameraControlFi
     * @address 0x2F1110
     * @size 0xE0
     */
    virtual void Step(int frames);

    /**
     *
     * Reads the turn, rise and swing-back requests from a controller and
     * moves the camera by them.
     *
     * @mangled MoveCamera__14CCameraControlFP11CPadControlPfP6CCPolyi
     * @address 0x2F11F0
     * @size 0x180
     */
    void MoveCamera(CPadControl *pad, float *target, CCPoly *polys, int poly_count);

    /**
     *
     * Turns, raises and pulls in or out the eye by the requests, within
     * the limits in use, swings it behind the player when asked, and keeps
     * it clear of the ground and walls.
     *
     * @mangled MoveCamera__14CCameraControlFPQ214CCameraControl7ControlPfP6CCPolyi
     * @address 0x2F1370
     * @size 0x3A0
     */
    void MoveCamera(Control *control, float *target, CCPoly *polys, int poly_count);

    /**
     *
     * Turns the position that the eye moves to about the look-at point by
     * an angle.
     *
     * @mangled Rotate__14CCameraControlFf
     * @address 0x2F1710
     * @size 0x80
     */
    void Rotate(float angle);

    /**
     *
     * Puts the position that the eye moves to at an angle about the
     * look-at point, keeping its distance and height.
     *
     * @mangled SetRotate__14CCameraControlFf
     * @address 0x2F1790
     * @size 0xA0
     */
    void SetRotate(float angle);

    /**
     *
     * Sets the height of the eye above the look-at point.
     *
     * @mangled SetHeight__14CCameraControlFf
     * @address 0x2F1830
     * @size 0x60
     */
    void SetHeight(float height);

    /**
     *
     * Makes the eye swing round to an angle about the look-at point.
     *
     * @mangled RotBack__14CCameraControlFf
     * @address 0x2F1890
     * @size 0x10
     */
    void RotBack(float angle);

    /**
     *
     * Stops the eye swinging round.
     *
     * @mangled CancelRotBack__14CCameraControlFv
     * @address 0x2F18A0
     * @size 0x10
     */
    void CancelRotBack();

    /**
     *
     * Sets the point that walls and the ground are checked against.
     *
     * @mangled SetCheckRef__14CCameraControlFPf
     * @address 0x2F18B0
     * @size 0x20
     */
    void SetCheckRef(float *ref);

    /**
     *
     * Sets the point that walls and the ground are checked against.
     *
     * @mangled SetCheckRef__14CCameraControlFfff
     * @address 0x2F18D0
     * @size 0x40
     */
    void SetCheckRef(float x, float y, float z);

    /**
     *
     * Pulls the eye in front of any wall between it and the point that it
     * looks at.
     *
     * @mangled CheckCollision__14CCameraControlFP6CCPolyi
     * @address 0x2F1910
     * @size 0x250
     */
    void CheckCollision(CCPoly *polys, int poly_count);

    /**
     *
     * Swings the eye round, a little at a time either way, until no wall
     * stands between it and the point that it looks at. Returns non-zero
     * when the eye has a clear view.
     *
     * @mangled AutoMove__14CCameraControlFP6CCPolyi
     * @address 0x2F1B60
     * @size 0x310
     */
    int AutoMove(CCPoly *polys, int poly_count);

    /**
     *
     * Keeps the eye above the floor below it and beneath the ceiling above
     * it.
     *
     * @mangled CheckGround__14CCameraControlFP6CCPolyi
     * @address 0x2F1E70
     * @size 0x3E0
     */
    void CheckGround(CCPoly *polys, int poly_count);

    /**
     *
     * Makes the matrix that moves the world into the space of the eye,
     * looking along the view direction plus its offset.
     *
     * @mangled GetCameraMatrix__14CCameraControlFPA4_f
     * @address 0x2F2250
     * @size 0xD0
     */
    virtual void GetCameraMatrix(float (*matrix)[4]);

    /**
     *
     * Copies the limits in use, the cancel bits and the follow offset to
     * another camera.
     *
     * @mangled CopyParam__14CCameraControlFR14CCameraControl
     * @address 0x2F2320
     * @size 0xB0
     */
    void CopyParam(CCameraControl &dest);

    /**
     *
     * Returns the kind of this camera.
     *
     * @mangled Iam__14CCameraControlFv
     * @address 0x2F23D0
     * @size 0x10
     */
    virtual int Iam();
};

STATIC_ASSERT(sizeof(CCameraControl) == 0x1F0);
