#pragma once

#include "common.h"

#include <libvu0.h>

/**
 * @file
 * Declares the engine camera that eases an eye towards a position, and the camera that circles a point.
 */

/**
 *
 * Identifies the kind of a camera, as the Iam function of each camera class returns it.
 *
 */
enum mgCameraKind {
    MG_CAMERA_KIND_CAMERA = 0, /**< A plain mgCCamera. */
    MG_CAMERA_KIND_FOLLOW = 1, /**< An mgCCameraFollow, which circles a point. */
};

/**
 *
 * Moves an eye point and a look-at point towards the positions that the game gives, and makes the matrix that puts the world in front of the eye.
 *
 */
class mgCCamera {
public:
    sceVu0FVECTOR pos;       /**< World position of the eye. */
    sceVu0FVECTOR ref;       /**< World position of the point that the eye looks at. */
    sceVu0FVECTOR next_pos;  /**< World position that the eye moves to. */
    sceVu0FVECTOR next_ref;  /**< World position that the look-at point moves to. */
    float roll;              /**< Angle, in radians, that turns the view about the view direction. */
    int unk_44;
    float pos_speed;         /**< Number of steps over which the eye closes the gap to its next position; 1.0 or less moves it at once. */
    float ref_speed;         /**< Number of steps over which the look-at point closes the gap to its next position. */
    float angle_h;           /**< Angle, in radians, of the view direction about the vertical axis. */
    float angle_v;           /**< Angle, in radians, of the view direction above the horizontal plane. */
    float snap_range;        /**< Distance at which the eye and the look-at point snap onto their next positions. */
    int suspended; /**< Non-zero while the camera does not move. */

    /**
     * Holds every camera still while it is not zero.
     *
     * @mangled StopCamera__9mgCCamera
     * @address 0x37CD80
     * @size 0x4
     */
    static int StopCamera;

    /**
     * Moves the eye and the look-at point one or more steps towards their
     * next positions, and measures the angles of the view direction. A step
     * count below zero puts both onto their next positions at once.
     *
     * @mangled Step__9mgCCameraFi
     * @address 0x131790
     * @size 0x290
     */
    virtual void Step(int steps);

    /**
     * Stops the camera from moving until it resumes.
     *
     * @mangled Suspend__9mgCCameraFv
     * @address 0x1321B0
     * @size 0x10
     */
    virtual void Suspend() { suspended = 1; }

    /**
     * Lets the camera move again after a suspension.
     *
     * @mangled Resume__9mgCCameraFv
     * @address 0x1321C0
     * @size 0x10
     */
    virtual void Resume() { suspended = 0; }

    /**
     * Puts the positions that the eye and the look-at point move to back onto
     * where they are, so that neither moves.
     *
     * @mangled Stay__9mgCCameraFv
     * @address 0x131A20
     * @size 0x40
     */
    virtual void Stay();

    /**
     * Makes the matrix that moves the world into the space of the eye, with
     * the up direction at right angles to the view direction.
     *
     * @mangled GetCameraMatrix__9mgCCameraFPA4_f
     * @address 0x131B50
     * @size 0xC0
     */
    virtual void GetCameraMatrix(float (*matrix)[4]);

    /**
     * Returns the kind of this camera.
     *
     * @mangled Iam__9mgCCameraFv
     * @address 0x1321D0
     * @size 0x10
     */
    virtual int Iam() { return MG_CAMERA_KIND_CAMERA; }

    /**
     * Puts the eye onto a position at once.
     *
     * @mangled SetPos__9mgCCameraFfff
     * @address 0x131A60
     * @size 0x30
     */
    void SetPos(float x, float y, float z);

    /**
     * Puts the eye onto a position at once.
     *
     * @mangled SetPos__9mgCCameraFPf
     * @address 0x131A90
     * @size 0x10
     */
    void SetPos(float *pos);

    /**
     * Gives the eye the position that it moves to.
     *
     * @mangled SetNextPos__9mgCCameraFfff
     * @address 0x131AA0
     * @size 0x10
     */
    void SetNextPos(float x, float y, float z);

    /**
     * Gives the eye the position that it moves to.
     *
     * @mangled SetNextPos__9mgCCameraFPf
     * @address 0x131AB0
     * @size 0x10
     */
    void SetNextPos(float *pos);

    /**
     * Puts the look-at point onto a position at once.
     *
     * @mangled SetRef__9mgCCameraFfff
     * @address 0x131AC0
     * @size 0x20
     */
    void SetRef(float x, float y, float z);

    /**
     * Puts the look-at point onto a position at once.
     *
     * @mangled SetRef__9mgCCameraFPf
     * @address 0x131AE0
     * @size 0x10
     */
    void SetRef(float *ref);

    /**
     * Gives the look-at point the position that it moves to.
     *
     * @mangled SetNextRef__9mgCCameraFfff
     * @address 0x131AF0
     * @size 0x10
     */
    void SetNextRef(float x, float y, float z);

    /**
     * Gives the look-at point the position that it moves to.
     *
     * @mangled SetNextRef__9mgCCameraFPf
     * @address 0x131B00
     * @size 0x10
     */
    void SetNextRef(float *ref);

    /**
     * Gives the vector that goes from the eye to the look-at point.
     *
     * @mangled GetDir__9mgCCameraFPf
     * @address 0x131B10
     * @size 0x40
     */
    void GetDir(float *dir);

    /**
     * Sets the number of steps that the eye and the look-at point need to
     * reach their positions; a look-at speed below zero takes the eye's.
     *
     * @mangled SetSpeed__9mgCCameraFff
     * @address 0x131C10
     * @size 0x30
     */
    void SetSpeed(float pos_speed, float ref_speed);

    /**
     * Sets the angle that turns the view about the view direction.
     *
     * @mangled SetRoll__9mgCCameraFf
     * @address 0x131C40
     * @size 0x10
     */
    void SetRoll(float roll);

    /**
     * Gives the world position of the eye.
     *
     * @mangled GetPos__9mgCCameraFPf
     * @address 0x131C50
     * @size 0x10
     */
    void GetPos(float *pos);

    /**
     * Gives the world position of the point that the eye looks at.
     *
     * @mangled GetRef__9mgCCameraFPf
     * @address 0x131C60
     * @size 0x10
     */
    void GetRef(float *ref);

    /**
     * Gives the world position that the eye moves to.
     *
     * @mangled GetNextPos__9mgCCameraFPf
     * @address 0x131C70
     * @size 0x10
     */
    void GetNextPos(float *pos);

    /**
     * Gives the world position that the look-at point moves to.
     *
     * @mangled GetNextRef__9mgCCameraFPf
     * @address 0x131C80
     * @size 0x10
     */
    void GetNextRef(float *ref);

    /**
     * Returns the angle of the view direction about the vertical axis.
     *
     * @mangled GetAngleH__9mgCCameraFv
     * @address 0x131C90
     * @size 0x10
     */
    float GetAngleH();

    /**
     * Returns the angle of the view direction above the horizontal plane.
     *
     * @mangled GetAngleV__9mgCCameraFv
     * @address 0x131CA0
     * @size 0x10
     */
    float GetAngleV();

    /**
     * Puts the camera at rest and gives the eye and the look-at point the
     * number of steps that they need to reach a position.
     *
     * @mangled __ct__9mgCCameraFf
     * @address 0x131CB0
     * @size 0x50
     */
    mgCCamera(float speed);
};
STATIC_ASSERT(sizeof(mgCCamera) == 0x70);

/**
 *
 * Follows a point in the world, keeping the eye on that point; the eye sits on a circle about the point, at a set height and distance.
 *
 */
class mgCCameraFollow : public mgCCamera {
public:
    sceVu0FVECTOR follow;        /**< World position that the eye circles. */
    sceVu0FVECTOR follow_offset; /**< Offset added to the followed position to give the point that the eye circles and looks at. */
    float distance;              /**< Distance from the eye to the circled point, on the horizontal plane. */
    float height;                /**< Height of the eye above the circled point. */
    float next_angle;            /**< Angle, in radians, that the eye turns to. */
    float angle;                 /**< Angle, in radians, of the eye about the circled point. */
    int follow_on; /**< Non-zero while the eye circles the point; zero leaves the eye where it is. */
    sceVu0FVECTOR follow_next;   /**< Point that the eye circles and looks at: the followed position plus its offset. */

    /**
     * Turns the eye one or more steps towards the angle that it turns to, and
     * moves the eye and the look-at point to where the circle puts them. A
     * step count below zero turns the eye at once.
     *
     * @mangled Step__15mgCCameraFollowFi
     * @address 0x131DC0
     * @size 0x210
     */
    virtual void Step(int steps);

    /**
     * Puts the circled point onto the look-at point's next position, and the
     * angle that the eye turns to onto its angle, so that nothing moves.
     *
     * @mangled Stay__15mgCCameraFollowFv
     * @address 0x131FD0
     * @size 0x40
     */
    virtual void Stay();

    /**
     * Returns the kind of this camera.
     *
     * @mangled Iam__15mgCCameraFollowFv
     * @address 0x1321A0
     * @size 0x10
     */
    virtual int Iam() { return MG_CAMERA_KIND_FOLLOW; }

    /**
     * Sets the world position that the eye circles.
     *
     * @mangled SetFollow__15mgCCameraFollowFfff
     * @address 0x132010
     * @size 0x10
     */
    virtual void SetFollow(float x, float y, float z);

    /**
     * Gives the position that the circle puts the eye at, for the current
     * angle, distance and height.
     *
     * @mangled GetFollowNextPos__15mgCCameraFollowFPf
     * @address 0x131D00
     * @size 0x80
     */
    void GetFollowNextPos(float *pos);

    /**
     * Gives the followed position plus its offset: the point that the eye
     * circles.
     *
     * @mangled GetFollowNext__15mgCCameraFollowFPf
     * @address 0x131D80
     * @size 0x40
     */
    void GetFollowNext(float *pos);

    /**
     * Makes the eye circle the point again.
     *
     * @mangled FollowOn__15mgCCameraFollowFv
     * @address 0x132020
     * @size 0x10
     */
    void FollowOn();

    /**
     * Leaves the eye where it is, and makes it take the angle that the base
     * camera measures.
     *
     * @mangled FollowOff__15mgCCameraFollowFv
     * @address 0x132030
     * @size 0x10
     */
    void FollowOff();

    /**
     * Sets the angle that the eye turns to, which it reaches over several
     * steps.
     *
     * @mangled SetAngle__15mgCCameraFollowFf
     * @address 0x132040
     * @size 0x10
     */
    void SetAngle(float angle);

    /**
     * Sets the angle of the eye, and the angle that it turns to, so that the
     * eye turns at once.
     *
     * @mangled SetAngleSoon__15mgCCameraFollowFf
     * @address 0x132050
     * @size 0x10
     */
    void SetAngleSoon(float angle);

    /**
     * Returns the angle that the eye is at now.
     *
     * @mangled GetAngle__15mgCCameraFollowFv
     * @address 0x132060
     * @size 0x10
     */
    float GetAngle();

    /**
     * Adds to the angle that the eye turns to.
     *
     * @mangled AddAngle__15mgCCameraFollowFf
     * @address 0x132070
     * @size 0x10
     */
    void AddAngle(float delta);

    /**
     * Sets the distance from the eye to the point that it circles.
     *
     * @mangled SetDistance__15mgCCameraFollowFf
     * @address 0x132080
     * @size 0x10
     */
    void SetDistance(float distance);

    /**
     * Returns the distance from the eye to the point that it circles.
     *
     * @mangled GetDistance__15mgCCameraFollowFv
     * @address 0x132090
     * @size 0x10
     */
    float GetDistance();

    /**
     * Adds to the distance from the eye to the point that it circles.
     *
     * @mangled AddDistance__15mgCCameraFollowFf
     * @address 0x1320A0
     * @size 0x10
     */
    void AddDistance(float delta);

    /**
     * Sets the height of the eye above the point that it circles.
     *
     * @mangled SetHeight__15mgCCameraFollowFf
     * @address 0x1320B0
     * @size 0x10
     */
    void SetHeight(float height);

    /**
     * Returns the height of the eye above the point that it circles.
     *
     * @mangled GetHeight__15mgCCameraFollowFv
     * @address 0x1320C0
     * @size 0x10
     */
    float GetHeight();

    /**
     * Adds to the height of the eye above the point that it circles.
     *
     * @mangled AddHeight__15mgCCameraFollowFf
     * @address 0x1320D0
     * @size 0x10
     */
    void AddHeight(float delta);

    /**
     * Sets the offset added to the followed position.
     *
     * @mangled SetFollowOffset__15mgCCameraFollowFfff
     * @address 0x1320E0
     * @size 0x10
     */
    void SetFollowOffset(float x, float y, float z);

    /**
     * Gives the world position that the eye follows.
     *
     * @mangled GetFollow__15mgCCameraFollowFPf
     * @address 0x1320F0
     * @size 0x10
     */
    void GetFollow(float *pos);

    /**
     * Gives the offset added to the followed position.
     *
     * @mangled GetFollowOffset__15mgCCameraFollowFPf
     * @address 0x132100
     * @size 0x10
     */
    void GetFollowOffset(float *offset);

    /**
     * Puts the eye on the circle that the given distance, height and angle
     * describe, about the origin, and makes it circle the point.
     *
     * @mangled __ct__15mgCCameraFollowFffff
     * @address 0x132110
     * @size 0x90
     */
    mgCCameraFollow(float distance, float height, float angle, float speed);
};
STATIC_ASSERT(sizeof(mgCCameraFollow) == 0xC0);
