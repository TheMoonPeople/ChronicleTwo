#pragma once

#include "common.h"

#include <libvu0.h>

/**
 * @file
 * Declares the event-scene sequencers that queue camera and object commands, and the spline paths they follow.
 */

/**
 *
 * Value a sequence command handler returns to say what its track does next.
 *
 */
enum SceneSeqResult {
    SCENE_SEQ_NEXT = 0,   /**< The command is done; the track runs its next command in the same frame. */
    SCENE_SEQ_WAIT = 1,   /**< The command is still running; the track resumes it next frame. */
    SCENE_SEQ_RETURN = 2, /**< The track goes back to the command its last Keep command marked. */
};

/**
 *
 * Shape of the speed curve of an eased move or turn.
 *
 */
enum SceneSeqEase {
    SCENE_SEQ_EASE_IN_OUT = 0, /**< Speeds up at the start and slows down at the end. */
    SCENE_SEQ_EASE_IN = 1,     /**< Speeds up at the start only. */
    SCENE_SEQ_EASE_OUT = 2,    /**< Starts at full speed and slows down at the end only. */
};

/**
 *
 * Track of a camera sequence; each track runs its own list of commands.
 *
 */
enum SceneCmrSeqTrack {
    SCENE_CMR_TRACK_PR = 0,    /**< Eye position and look-at point commands. */
    SCENE_CMR_TRACK_AHD = 1,   /**< Angle, height and distance commands. */
    SCENE_CMR_TRACK_FADE = 2,  /**< Screen fade commands. */
    SCENE_CMR_TRACK_QUAKE = 3, /**< Camera shake commands. */
    SCENE_CMR_TRACK_CHARA = 4, /**< Commands that place a character in front of the camera. */
    SCENE_CMR_TRACK_NUM = 5,   /**< Number of camera tracks. */
};

/**
 *
 * Command of a camera sequence entry, the index of its handler in the camera command table.
 *
 */
enum SceneCmrSeqCmd {
    SCENE_CMR_CMD_NONE = 0,              /**< Free entry. */
    SCENE_CMR_CMD_PR_DELAY = 1,          /**< Waits a number of frames on the position track. */
    SCENE_CMR_CMD_SET_POS = 2,           /**< Puts the eye at a position. */
    SCENE_CMR_CMD_SET_REF = 3,           /**< Puts the look-at point at a position. */
    SCENE_CMR_CMD_MOVE = 4,              /**< Moves the eye and the look-at point at an even speed. */
    SCENE_CMR_CMD_MOVE2 = 5,             /**< Moves the eye and the look-at point with an eased speed. */
    SCENE_CMR_CMD_MOVE_REF = 6,          /**< Moves the look-at point at an even speed. */
    SCENE_CMR_CMD_MOVE_POS = 7,          /**< Moves the eye at an even speed. */
    SCENE_CMR_CMD_INIT_PAS = 8,          /**< Clears the camera path. */
    SCENE_CMR_CMD_SET_PAS_FRM = 9,       /**< Sets the frame count of the camera path. */
    SCENE_CMR_CMD_ADD_PAS = 10,          /**< Adds a point to the camera path. */
    SCENE_CMR_CMD_START_PAS = 11,        /**< Runs the camera along its path. */
    SCENE_CMR_CMD_PR_SLOWING = 12,       /**< Lets the last eye and look-at movement die away. */
    SCENE_CMR_CMD_PR_KEEP = 13,          /**< Marks the position track's return point. */
    SCENE_CMR_CMD_PR_RETURN = 14,        /**< Goes back to the position track's return point. */
    SCENE_CMR_CMD_AHD_DELAY = 15,        /**< Waits a number of frames on the angle track. */
    SCENE_CMR_CMD_SET_ANGLE = 16,        /**< Sets the angle of the eye about the look-at point. */
    SCENE_CMR_CMD_SET_HEIGHT = 17,       /**< Sets the height of the eye above the look-at point. */
    SCENE_CMR_CMD_SET_DIST = 18,         /**< Sets the distance of the eye from the look-at point. */
    SCENE_CMR_CMD_SET_AHD = 19,          /**< Sets the angle, height and distance together. */
    SCENE_CMR_CMD_MOVE_AHD = 20,         /**< Changes the angle, height and distance at an even speed. */
    SCENE_CMR_CMD_MOVE_AHD2 = 21,        /**< Changes the angle, height and distance with an eased speed. */
    SCENE_CMR_CMD_SET_SYNC_OBJ = 22,     /**< Makes the camera follow an event object. */
    SCENE_CMR_CMD_RELEASE_SYNC_OBJ = 23, /**< Stops the camera from following an event object. */
    SCENE_CMR_CMD_AHD_SLOWING = 24,      /**< Lets the last angle, height and distance change die away. */
    SCENE_CMR_CMD_AHD_KEEP = 25,         /**< Marks the angle track's return point. */
    SCENE_CMR_CMD_AHD_RETURN = 26,       /**< Goes back to the angle track's return point. */
    SCENE_CMR_CMD_FADE_DELAY = 27,       /**< Waits a number of frames on the fade track. */
    SCENE_CMR_CMD_FADE_INIT = 28,        /**< Does nothing; kept as a fade track marker. */
    SCENE_CMR_CMD_FADE_IN = 29,          /**< Fades the screen in from a colour. */
    SCENE_CMR_CMD_FADE_OUT = 30,         /**< Fades the screen out to a colour. */
    SCENE_CMR_CMD_QUAKE_DELAY = 31,      /**< Waits a number of frames on the shake track. */
    SCENE_CMR_CMD_QUAKE = 32,            /**< Shakes the camera, fading the shake out. */
    SCENE_CMR_CMD_QUAKE2 = 33,           /**< Shakes the camera, the vertical shake only. */
    SCENE_CMR_CMD_CHARA_DELAY = 34,      /**< Waits a number of frames on the character track. */
    SCENE_CMR_CMD_CHARA_ATTACH = 35,     /**< Keeps a character a distance in front of the eye. */
    SCENE_CMR_CMD_NUM = 36,              /**< One past the last valid camera command. */
};

/**
 *
 * How a camera that follows an event object turns with it.
 *
 */
enum SceneCmrSyncMode {
    SCENE_CMR_SYNC_FIXED = 0,  /**< The camera angle does not turn with the object. */
    SCENE_CMR_SYNC_YAW = 1,    /**< The camera angle turns with the object's heading. */
    SCENE_CMR_SYNC_FRAME = 2,  /**< The camera follows the full orientation of a frame of the object. */
};

/**
 *
 * Track of an object sequence; each track runs its own list of commands.
 *
 */
enum SceneObjSeqTrack {
    SCENE_OBJ_TRACK_POS = 0,   /**< Position commands. */
    SCENE_OBJ_TRACK_ROT = 1,   /**< Rotation commands. */
    SCENE_OBJ_TRACK_MOT = 2,   /**< Motion commands. */
    SCENE_OBJ_TRACK_ANM = 3,   /**< Texture animation commands. */
    SCENE_OBJ_TRACK_COL = 4,   /**< Colour commands. */
    SCENE_OBJ_TRACK_SCALE = 5, /**< Scale commands. */
    SCENE_OBJ_TRACK_SE = 6,    /**< Sound effect commands. */
    SCENE_OBJ_TRACK_NUM = 7,   /**< Number of object tracks. */
};

/**
 *
 * Command of an object sequence entry, the index of its handler in the object command table.
 *
 */
enum SceneObjSeqCmd {
    SCENE_OBJ_CMD_NONE = 0,                 /**< Free entry. */
    SCENE_OBJ_CMD_POS_DELAY = 1,            /**< Waits a number of frames on the position track. */
    SCENE_OBJ_CMD_SET_POS = 2,              /**< Puts the object at a position. */
    SCENE_OBJ_CMD_MOVE = 3,                 /**< Moves the object at an even speed. */
    SCENE_OBJ_CMD_MOVE2 = 4,                /**< Moves the object with an eased speed. */
    SCENE_OBJ_CMD_INIT_PAS = 5,             /**< Clears the object path. */
    SCENE_OBJ_CMD_SET_PAS_FRM = 6,          /**< Sets the frame count of the object path. */
    SCENE_OBJ_CMD_ADD_PAS = 7,              /**< Adds a point to the object path. */
    SCENE_OBJ_CMD_START_PAS = 8,            /**< Runs the object along its path. */
    SCENE_OBJ_CMD_JUMP = 9,                 /**< Moves the object to a position along a jump arc. */
    SCENE_OBJ_CMD_SET_EOH_FRAME_POS = 10,   /**< Puts the object at a frame of another event object. */
    SCENE_OBJ_CMD_ADD_POS = 11,             /**< Adds an offset to the position every frame. */
    SCENE_OBJ_CMD_ATTACH_CAMERA = 12,       /**< Keeps the object a distance in front of the camera. */
    SCENE_OBJ_CMD_ROT_DELAY = 13,           /**< Waits a number of frames on the rotation track. */
    SCENE_OBJ_CMD_SET_ROT = 14,             /**< Sets the rotation of the object. */
    SCENE_OBJ_CMD_ROTATION = 15,            /**< Turns the object at an even speed. */
    SCENE_OBJ_CMD_ROTATION2 = 16,           /**< Turns the object with an eased speed. */
    SCENE_OBJ_CMD_REFERENCE = 17,           /**< Turns the object to face a position. */
    SCENE_OBJ_CMD_MOTION_DELAY = 18,        /**< Waits a number of frames on the motion track. */
    SCENE_OBJ_CMD_SET_MOTION = 19,          /**< Starts a motion at once. */
    SCENE_OBJ_CMD_NEXT_MOTION = 20,         /**< Starts a motion once the current one ends. */
    SCENE_OBJ_CMD_MOTION_WAIT = 21,         /**< Waits for the current motion to end. */
    SCENE_OBJ_CMD_MOTION_TRG = 22,          /**< Arms the motion trigger. */
    SCENE_OBJ_CMD_MOTION_TRG_WAIT = 23,     /**< Waits for the motion trigger. */
    SCENE_OBJ_CMD_SET_MOT_STEP = 24,        /**< Sets the motion playback step. */
    SCENE_OBJ_CMD_SET_MOT_CHANGE_STEP = 25, /**< Sets the motion blend step. */
    SCENE_OBJ_CMD_RESET_MOTION = 26,        /**< Resets the motion. */
    SCENE_OBJ_CMD_SET_MOTION_NOW_TIME = 27, /**< Sets the current motion time. */
    SCENE_OBJ_CMD_SET_MOTION_WAIT_TIME = 28, /**< Sets the motion wait time. */
    SCENE_OBJ_CMD_NORMAL_DRIVE = 29,        /**< Returns the object to its normal behaviour. */
    SCENE_OBJ_CMD_TEX_ANIME_DELAY = 30,     /**< Waits a number of frames on the texture animation track. */
    SCENE_OBJ_CMD_TEX_ANIME = 31,           /**< Turns a texture animation on or off. */
    SCENE_OBJ_CMD_COLOR_DELAY = 32,         /**< Waits a number of frames on the colour track. */
    SCENE_OBJ_CMD_SET_COLOR = 33,           /**< Changes the object colour over a number of frames. */
    SCENE_OBJ_CMD_SCALE_DELAY = 34,         /**< Waits a number of frames on the scale track. */
    SCENE_OBJ_CMD_SET_SCALE = 35,           /**< Changes the object scale over a number of frames. */
    SCENE_OBJ_CMD_SE_DELAY = 36,            /**< Waits a number of frames on the sound effect track. */
    SCENE_OBJ_CMD_SE_PLAY = 37,             /**< Plays a sound effect. */
    SCENE_OBJ_CMD_RESET_DA_POSITION = 38,   /**< Writes the position and rotation back to the object and resets its dynamic animation. */
    SCENE_OBJ_CMD_NUM = 39,                 /**< One past the last valid object command. */
};

/**
 *
 * One segment of a cubic spline through three dimensions, with its timing.
 *
 */
struct SPLINE_KEY {
    int frame;     /**< Frame at which the segment starts. */
    int length;    /**< Number of frames the segment lasts. */
    float a[3];    /**< Cubic coefficient of each axis. */
    float b[3];    /**< Square coefficient of each axis. */
    float c[3];    /**< Linear coefficient of each axis. */
    float d[3];    /**< Constant coefficient of each axis, the segment's start point. */
};
STATIC_ASSERT(sizeof(SPLINE_KEY) == 0x38);

/**
 *
 * Cubic spline through up to sixteen points, stepped by frame or by distance.
 *
 */
class C3DSpline {
public:
    SPLINE_KEY key[16]; /**< Segments of the spline. */
    int key_num;        /**< Number of points the spline passes through. */
    int now_key;        /**< Segment the current point is on. */
    float now_frame;    /**< Current time along the spline, in frames. */
    float now_pos[3];   /**< Current point on the spline. */
    float speed;        /**< Distance StepS moves along the spline in one step. */

    /**
     * Clears every segment and puts the spline at its start.
     *
     * @mangled __ct__9C3DSplineFv
     * @address 0x258420
     * @size 0x30
     */
    C3DSpline();

    /**
     * Clears every segment and puts the spline at its start.
     *
     * @mangled Initialize__9C3DSplineFv
     * @address 0x258450
     * @size 0x50
     */
    void Initialize();

    /**
     * Builds the segments through a list of points, each segment lasting
     * the matching number of frames, and sets the distance of a StepS step.
     *
     * @mangled SetUpSpline__9C3DSplineFPA4_fPiif
     * @address 0x2584A0
     * @size 0x2E0
     */
    void SetUpSpline(float (*points)[4], int *frames, int num, float speed);

    /**
     * Moves the current point along the spline by the step distance;
     * returns non-zero once the end is reached.
     *
     * @mangled StepS__9C3DSplineFv
     * @address 0x258780
     * @size 0x260
     */
    int StepS();

    /**
     * Moves the current point along the spline by one frame; returns
     * non-zero once the end is reached.
     *
     * @mangled Step__9C3DSplineFv
     * @address 0x2589E0
     * @size 0x1D0
     */
    int Step();

    /**
     * Copies the current point, with a w of 1, into a vector.
     *
     * @mangled GetNowXYZ__9C3DSplineFPf
     * @address 0x258BB0
     * @size 0x30
     */
    void GetNowXYZ(float *pos);
};
STATIC_ASSERT(sizeof(C3DSpline) == 0x39C);

/**
 *
 * Camera path: eye and look-at points joined by splines that the camera runs along at an even speed.
 *
 */
class CCameraPas {
public:
    sceVu0FVECTOR pos[16]; /**< Eye points of the path. */
    sceVu0FVECTOR ref[16]; /**< Look-at points of the path. */
    int pas_num;           /**< Number of points on the path. */
    int frame;             /**< Number of frames the whole path lasts. */
    C3DSpline pos_spline;  /**< Spline through the eye points. */
    C3DSpline ref_spline;  /**< Spline through the look-at points. */
    int run;               /**< Non-zero while the camera runs along the path. */

    /**
     * Clears the path.
     *
     * @mangled __ct__10CCameraPasFv
     * @address 0x258BE0
     * @size 0x40
     */
    CCameraPas();

    /**
     * Adds an eye point and a look-at point to the end of the path;
     * returns non-zero when the path is full.
     *
     * @mangled AddCameraPas__10CCameraPasFPfPf
     * @address 0x258C20
     * @size 0x80
     */
    int AddCameraPas(float *pos, float *ref);

    /**
     * Inserts an eye point and a look-at point before a point of the path;
     * returns non-zero when the index is out of range.
     *
     * @mangled InsCameraPas__10CCameraPasFiPfPf
     * @address 0x258CA0
     * @size 0x110
     */
    int InsCameraPas(int no, float *pos, float *ref);

    /**
     * Replaces a point of the path; returns non-zero when the index is out
     * of range.
     *
     * @mangled SetCameraPas__10CCameraPasFiPfPf
     * @address 0x258DB0
     * @size 0x60
     */
    int SetCameraPas(int no, float *pos, float *ref);

    /**
     * Copies out a point of the path; returns non-zero when the index is
     * out of range.
     *
     * @mangled GetCameraPas__10CCameraPasFiPfPf
     * @address 0x258E10
     * @size 0x60
     */
    int GetCameraPas(int no, float *pos, float *ref);

    /**
     * Removes a point of the path; returns non-zero when the index is out
     * of range.
     *
     * @mangled DelCameraPas__10CCameraPasFi
     * @address 0x258E70
     * @size 0xE0
     */
    int DelCameraPas(int no);

    /**
     * Sets the number of frames the whole path lasts; always returns 0.
     *
     * @mangled SetFrame__10CCameraPasFi
     * @address 0x258F50
     * @size 0x10
     */
    int SetFrame(int frame);

    /**
     * Returns the number of frames the whole path lasts.
     *
     * @mangled GetFrame__10CCameraPasFv
     * @address 0x258F60
     * @size 0x10
     */
    int GetFrame();

    /**
     * Removes every point and stops the camera.
     *
     * @mangled Initialize__10CCameraPasFv
     * @address 0x258F70
     * @size 0x80
     */
    void Initialize();

    /**
     * Builds both splines and measures them so that the camera covers the
     * path in its frame count; returns non-zero when the path is empty.
     *
     * @mangled Setup__10CCameraPasFv
     * @address 0x258FF0
     * @size 0x2A0
     */
    int Setup();

    /**
     * Starts the camera along the path.
     *
     * @mangled Run__10CCameraPasFv
     * @address 0x259290
     * @size 0x10
     */
    void Run();

    /**
     * Moves the camera one step along the path and copies out the eye and
     * look-at points.
     *
     * @mangled Step__10CCameraPasFPfPf
     * @address 0x2592A0
     * @size 0xB0
     */
    void Step(float *pos, float *ref);

    /**
     * Returns non-zero once the camera has reached the end of the path.
     *
     * @mangled CheckEnd__10CCameraPasFv
     * @address 0x259350
     * @size 0x20
     */
    int CheckEnd();
};
STATIC_ASSERT(sizeof(CCameraPas) == 0x950);

/**
 *
 * Character path: points joined by a spline that an event object walks along, facing its direction of travel.
 *
 */
class CCharaPas {
public:
    sceVu0FVECTOR pos[16]; /**< Points of the path. */
    int frame;             /**< Number of frames the whole path lasts. */
    int pas_num;           /**< Number of points on the path. */
    C3DSpline spline;      /**< Spline through the points. */
    int run;               /**< Non-zero while the object walks along the path. */
    int end;               /**< Non-zero once the spline has reached its end, for the last step. */

    /**
     * Clears the path.
     *
     * @mangled __ct__9CCharaPasFv
     * @address 0x259370
     * @size 0x40
     */
    CCharaPas();

    /**
     * Removes every point and stops the object.
     *
     * @mangled Initialize__9CCharaPasFv
     * @address 0x2593B0
     * @size 0x70
     */
    void Initialize();

    /**
     * Adds a point to the end of the path; returns non-zero when the path
     * is full.
     *
     * @mangled AddCharaPas__9CCharaPasFPf
     * @address 0x259420
     * @size 0x50
     */
    int AddCharaPas(float *pos);

    /**
     * Builds the spline and measures it so that the object covers the path
     * in its frame count; returns non-zero when the path is empty.
     *
     * @mangled Setup__9CCharaPasFv
     * @address 0x259470
     * @size 0x170
     */
    int Setup();

    /**
     * Starts the object along the path when the path has points.
     *
     * @mangled Run__9CCharaPasFv
     * @address 0x2595E0
     * @size 0x20
     */
    void Run();

    /**
     * Moves the object one step along the path, writing its position and
     * the heading of its direction of travel.
     *
     * @mangled Step__9CCharaPasFPfPf
     * @address 0x259600
     * @size 0x190
     */
    void Step(float *pos, float *rot_y);

    /**
     * Returns non-zero once the object has reached the end of the path.
     *
     * @mangled CheckEnd__9CCharaPasFv
     * @address 0x259790
     * @size 0x20
     */
    int CheckEnd();

    /**
     * Inserts a point before a point of the path; returns non-zero when the
     * index is out of range.
     *
     * @mangled InsCharaPas__9CCharaPasFiPf
     * @address 0x2597B0
     * @size 0xD0
     */
    int InsCharaPas(int no, float *pos);

    /**
     * Replaces a point of the path; returns non-zero when the index is out
     * of range.
     *
     * @mangled SetCharaPas__9CCharaPasFiPf
     * @address 0x259880
     * @size 0x40
     */
    int SetCharaPas(int no, float *pos);

    /**
     * Copies out a point of the path; returns non-zero when the index is
     * out of range.
     *
     * @mangled GetCharaPas__9CCharaPasFiPf
     * @address 0x2598C0
     * @size 0x40
     */
    int GetCharaPas(int no, float *pos);

    /**
     * Removes a point of the path; returns non-zero when the index is out
     * of range.
     *
     * @mangled DelCharaPas__9CCharaPasFi
     * @address 0x259900
     * @size 0xB0
     */
    int DelCharaPas(int no);

    /**
     * Sets the number of frames the whole path lasts.
     *
     * @mangled SetFrame__9CCharaPasFi
     * @address 0x2599B0
     * @size 0x10
     */
    void SetFrame(int frame);

    /**
     * Returns the number of frames the whole path lasts.
     *
     * @mangled GetFrame__9CCharaPasFv
     * @address 0x2599C0
     * @size 0x10
     */
    int GetFrame();
};
STATIC_ASSERT(sizeof(CCharaPas) == 0x4B0);

/**
 *
 * One queued command of a camera sequence, linked to the next command of its track.
 *
 */
struct _SEN_CMR_SEQ {
    int cmd;              /**< Command, a SceneCmrSeqCmd; 0 marks a free entry. */
    s32 unk_4;
    s32 unk_8;
    s32 unk_c;
    sceVu0FVECTOR vec0;   /**< Eye position, shake size or fade colour; for angle commands the angle, height and distance. */
    sceVu0FVECTOR vec1;   /**< Look-at position, or the offset from a followed object. */
    union {
        int frame;        /**< Number of frames the command lasts. */
        float value;      /**< Angle, height, distance or slowing rate the command sets. */
        int no;           /**< Event object handle or character number the command uses. */
    };
    union {
        int mode;         /**< Ease shape (a SceneSeqEase) or follow mode (a SceneCmrSyncMode). */
        int slow_frame;   /**< Number of frames a slowing command lasts. */
        float dist;       /**< Distance in front of the eye that a character is kept at. */
    };
    union {
        float ease_rate;  /**< Share of the frame count over which an eased command changes speed. */
        int attach_frame; /**< Number of frames a character is kept in front of the eye, or below zero for ever. */
    };
    char name[0x20];      /**< Name of the frame of a followed object, or empty for its origin. */
    _SEN_CMR_SEQ *next;   /**< Next command of the same track. */
};
STATIC_ASSERT(sizeof(_SEN_CMR_SEQ) == 0x60);

/**
 *
 * One queued command of an object sequence, linked to the next command of its track.
 *
 */
struct _SEN_OBJ_SEQ {
    int cmd;              /**< Command, a SceneObjSeqCmd; 0 marks a free entry. */
    s32 unk_4;
    s32 unk_8;
    s32 unk_c;
    sceVu0FVECTOR vec;    /**< Position, rotation, offset, colour or scale the command uses. */
    union {
        int frame;        /**< Number of frames the command lasts. */
        float value;      /**< Motion step or time, jump height or camera distance the command sets. */
        int no;           /**< Event object handle, motion flags, sound number or texture animation switch. */
        int grounded;     /**< Whether path movement keeps the object on the ground. */
    };
    union {
        int mode;         /**< Ease shape (a SceneSeqEase), or 1 to keep a moved object on the ground. */
        int sub_frame;    /**< Number of frames a jump, attach or frame-follow command lasts. */
        float step;       /**< Motion step a motion command starts the motion with. */
        int se_no;        /**< Sound effect number within its sound bank. */
    };
    union {
        float ease_rate;  /**< Share of the frame count over which an eased command changes speed. */
        int started;      /**< Non-zero once a motion command has started its motion. */
    };
    char name[0x20];      /**< Name of a motion, a texture animation or a frame. */
    _SEN_OBJ_SEQ *next;   /**< Next command of the same track. */
};
STATIC_ASSERT(sizeof(_SEN_OBJ_SEQ) == 0x50);

/**
 *
 * Event camera sequencer: runs queued commands on five tracks that move the eye and look-at point, fade, shake the view and place characters.
 *
 */
class CSceneCmrSeq {
public:
    _SEN_CMR_SEQ *seq_tbl;      /**< Pool of command entries. */
    int seq_num;                /**< Number of entries in the pool. */
    _SEN_CMR_SEQ *pr_seq;       /**< Current command of the position track. */
    _SEN_CMR_SEQ *pr_last;      /**< Last command of the position track. */
    _SEN_CMR_SEQ *ahd_seq;      /**< Current command of the angle track. */
    _SEN_CMR_SEQ *ahd_last;     /**< Last command of the angle track. */
    _SEN_CMR_SEQ *fade_seq;     /**< Current command of the fade track. */
    _SEN_CMR_SEQ *fade_last;    /**< Last command of the fade track. */
    _SEN_CMR_SEQ *quake_seq;    /**< Current command of the shake track. */
    _SEN_CMR_SEQ *quake_last;   /**< Last command of the shake track. */
    _SEN_CMR_SEQ *chara_seq;    /**< Current command of the character track. */
    _SEN_CMR_SEQ *chara_last;   /**< Last command of the character track. */
    _SEN_CMR_SEQ *pr_keep;      /**< Return point of the position track, or NULL; finished commands are kept while set. */
    _SEN_CMR_SEQ *ahd_keep;     /**< Return point of the angle track, or NULL; finished commands are kept while set. */
    int pr_cnt;                 /**< Frame counter of the running position command. */
    int ahd_cnt;                /**< Frame counter of the running angle command. */
    int fade_cnt;               /**< Frame counter of the running fade command. */
    int quake_cnt;              /**< Frame counter of the running shake command. */
    int chara_cnt;              /**< Frame counter of the running character command. */
    s32 unk_4c;
    sceVu0FVECTOR pos;          /**< Eye position given to the camera. */
    sceVu0FVECTOR ref;          /**< Look-at position given to the camera. */
    float angle;                /**< Angle, in radians, of the eye about the look-at point. */
    float height;               /**< Height of the eye above the look-at point. */
    float dist;                 /**< Horizontal distance of the eye from the look-at point. */
    int sync;                   /**< Non-zero while the camera follows an event object. */
    int sync_obj;               /**< Handle of the followed event object. */
    int sync_mode;              /**< How the camera turns with the followed object, a SceneCmrSyncMode. */
    s32 unk_88;
    s32 unk_8c;
    sceVu0FVECTOR sync_ofs;     /**< Offset of the look-at point from the followed object or frame. */
    float sync_angle;           /**< Angle of the eye about a followed object. */
    float sync_height;          /**< Height of the eye above a followed object. */
    float sync_dist;            /**< Distance of the eye from a followed object. */
    char sync_frame[0x20];      /**< Name of the followed frame of the object, or empty for its origin. */
    s32 unk_cc;
    sceVu0FVECTOR pos_spd;      /**< Eye movement in one frame of an even move. */
    sceVu0FVECTOR ref_spd;      /**< Look-at movement in one frame of an even move. */
    float angle_spd;            /**< Angle change in one frame of an angle move. */
    s32 unk_f4;
    float height_spd;           /**< Height change in one frame of an angle move. */
    float dist_spd;             /**< Distance change in one frame of an angle move. */
    sceVu0FVECTOR pos_ease_spd; /**< Current eye movement in one frame of an eased move, or the angle, height and distance change of an eased angle move. */
    sceVu0FVECTOR ref_ease_spd; /**< Current look-at movement in one frame of an eased move. */
    sceVu0FVECTOR pos_ease_acc; /**< Change of the eye movement in one frame of an eased move, or of the angle change of an eased angle move. */
    sceVu0FVECTOR ref_ease_acc; /**< Change of the look-at movement in one frame of an eased move. */
    int ease_frame;             /**< Number of frames over which an eased move changes speed. */
    s32 unk_144;
    s32 unk_148;
    s32 unk_14c;
    sceVu0FVECTOR pos_vel;      /**< Last eye movement in one frame, which slowing lets die away. */
    sceVu0FVECTOR ref_vel;      /**< Last look-at movement in one frame, which slowing lets die away. */
    sceVu0FVECTOR ahd_vel;      /**< Last angle, height and distance change in one frame, which slowing lets die away. */
    int quake;                  /**< Non-zero while the camera shakes. */
    s32 unk_184;
    s32 unk_188;
    s32 unk_18c;
    sceVu0FVECTOR quake_amp;    /**< Current size of the shake. */
    sceVu0FVECTOR quake_pos;    /**< Eye position without the shake. */
    sceVu0FVECTOR quake_ref;    /**< Look-at position without the shake. */
    CCameraPas pas;             /**< Path the camera runs along. */

    /**
     * Sets up the path and an empty sequencer with no command pool.
     *
     * @mangled __ct__12CSceneCmrSeqFv
     * @address 0x25B9C0
     * @size 0x40
     */
    CSceneCmrSeq();

    /**
     * Forgets the command pool and clears the camera state.
     *
     * @mangled ZeroInitialize__12CSceneCmrSeqFv
     * @address 0x25BA00
     * @size 0x40
     */
    void ZeroInitialize();

    /**
     * Takes a pool of command entries and clears every track.
     *
     * @mangled Initialize__12CSceneCmrSeqFP12_SEN_CMR_SEQi
     * @address 0x25BA40
     * @size 0x50
     */
    void Initialize(_SEN_CMR_SEQ *seq_tbl, int seq_num);

    /**
     * Stops every track, clears the camera state and frees every command
     * entry of the pool.
     *
     * @mangled Clear__12CSceneCmrSeqFv
     * @address 0x25BA90
     * @size 0x190
     */
    void Clear();

    /**
     * Returns non-zero once the position, angle, fade and shake tracks have
     * all finished.
     *
     * @mangled CheckEnd__12CSceneCmrSeqFv
     * @address 0x25BC20
     * @size 0x50
     */
    int CheckEnd();

    /**
     * Runs one frame of every track on the active camera and applies the
     * follow of an event object.
     *
     * @mangled Play__12CSceneCmrSeqFv
     * @address 0x25BC70
     * @size 0x5A0
     */
    void Play();

    /**
     * Returns a free entry of the command pool, or NULL when none is left.
     *
     * @mangled SearchSeq__12CSceneCmrSeqFv
     * @address 0x25C210
     * @size 0x50
     */
    _SEN_CMR_SEQ *SearchSeq();

    /**
     * Appends a free entry to the position track and returns it, or NULL.
     *
     * @mangled SearchNextPrSeq__12CSceneCmrSeqFv
     * @address 0x25C260
     * @size 0x60
     */
    _SEN_CMR_SEQ *SearchNextPrSeq();

    /**
     * Appends a free entry to the angle track and returns it, or NULL.
     *
     * @mangled SearchNextAhdSeq__12CSceneCmrSeqFv
     * @address 0x25C2C0
     * @size 0x60
     */
    _SEN_CMR_SEQ *SearchNextAhdSeq();

    /**
     * Appends a free entry to the fade track and returns it, or NULL.
     *
     * @mangled SearchNextFadeSeq__12CSceneCmrSeqFv
     * @address 0x25C320
     * @size 0x60
     */
    _SEN_CMR_SEQ *SearchNextFadeSeq();

    /**
     * Appends a free entry to the shake track and returns it, or NULL.
     *
     * @mangled SearchNextQuakeSeq__12CSceneCmrSeqFv
     * @address 0x25C380
     * @size 0x60
     */
    _SEN_CMR_SEQ *SearchNextQuakeSeq();

    /**
     * Appends a free entry to the character track and returns it, or NULL.
     *
     * @mangled SearchNextCharaSeq__12CSceneCmrSeqFv
     * @address 0x25C3E0
     * @size 0x60
     */
    _SEN_CMR_SEQ *SearchNextCharaSeq();

    /**
     * Returns the command after a finished one on a track (a
     * SceneCmrSeqTrack), freeing the finished entry unless the track has a
     * return point.
     *
     * @mangled GetNextSeq__12CSceneCmrSeqFP12_SEN_CMR_SEQi
     * @address 0x25C440
     * @size 0xA0
     */
    _SEN_CMR_SEQ *GetNextSeq(_SEN_CMR_SEQ *seq, int track);

    /**
     * Queues a wait of a number of 60 Hz frames on the position track.
     *
     * @mangled PRDelay__12CSceneCmrSeqFi
     * @address 0x25C4E0
     * @size 0x90
     */
    void PRDelay(int frame);

    /**
     * Queues putting the eye at a position.
     *
     * @mangled SetPos__12CSceneCmrSeqFPf
     * @address 0x25C570
     * @size 0x40
     */
    void SetPos(float *pos);

    /**
     * Queues putting the look-at point at a position.
     *
     * @mangled SetRef__12CSceneCmrSeqFPf
     * @address 0x25C5B0
     * @size 0x40
     */
    void SetRef(float *ref);

    /**
     * Queues an even move of the eye and the look-at point over a number of
     * 60 Hz frames.
     *
     * @mangled Move__12CSceneCmrSeqFPfPfi
     * @address 0x25C5F0
     * @size 0xC0
     */
    void Move(float *pos, float *ref, int frame);

    /**
     * Queues an eased move of the eye and the look-at point over a number
     * of 60 Hz frames.
     *
     * @mangled Move2__12CSceneCmrSeqFPfPfiif
     * @address 0x25C6B0
     * @size 0xE0
     */
    void Move2(float *pos, float *ref, int frame, int ease, float ease_rate);

    /**
     * Queues an even move of the look-at point over a number of 60 Hz
     * frames.
     *
     * @mangled MoveRef__12CSceneCmrSeqFPfi
     * @address 0x25C790
     * @size 0xB0
     */
    void MoveRef(float *ref, int frame);

    /**
     * Queues an even move of the eye over a number of 60 Hz frames.
     *
     * @mangled MovePos__12CSceneCmrSeqFPfi
     * @address 0x25C840
     * @size 0xB0
     */
    void MovePos(float *pos, int frame);

    /**
     * Queues clearing the camera path.
     *
     * @mangled InitPas__12CSceneCmrSeqFv
     * @address 0x25C8F0
     * @size 0x30
     */
    void InitPas();

    /**
     * Queues setting the camera path's length in 60 Hz frames.
     *
     * @mangled SetPasFrm__12CSceneCmrSeqFi
     * @address 0x25C920
     * @size 0x90
     */
    void SetPasFrm(int frame);

    /**
     * Queues adding an eye point and a look-at point to the camera path.
     *
     * @mangled AddPas__12CSceneCmrSeqFPfPf
     * @address 0x25C9B0
     * @size 0x70
     */
    void AddPas(float *pos, float *ref);

    /**
     * Queues running the camera along its path.
     *
     * @mangled StartPas__12CSceneCmrSeqFv
     * @address 0x25CA20
     * @size 0x30
     */
    void StartPas();

    /**
     * Queues letting the last eye and look-at movement die away by a rate
     * every frame over a number of 60 Hz frames.
     *
     * @mangled PRSlowing__12CSceneCmrSeqFfi
     * @address 0x25CA50
     * @size 0xA0
     */
    void PRSlowing(float rate, int frame);

    /**
     * Queues marking the position track's return point.
     *
     * @mangled PRKeep__12CSceneCmrSeqFv
     * @address 0x25CAF0
     * @size 0x30
     */
    void PRKeep();

    /**
     * Queues going back to the position track's return point.
     *
     * @mangled PRReturn__12CSceneCmrSeqFv
     * @address 0x25CB20
     * @size 0x30
     */
    void PRReturn();

    /**
     * Queues a wait of a number of 60 Hz frames on the angle track.
     *
     * @mangled AHDDelay__12CSceneCmrSeqFi
     * @address 0x25CB50
     * @size 0x90
     */
    void AHDDelay(int frame);

    /**
     * Queues setting the angle of the eye about the look-at point.
     *
     * @mangled SetAngle__12CSceneCmrSeqFf
     * @address 0x25CBE0
     * @size 0x40
     */
    void SetAngle(float angle);

    /**
     * Queues setting the height of the eye above the look-at point.
     *
     * @mangled SetHeight__12CSceneCmrSeqFf
     * @address 0x25CC20
     * @size 0x40
     */
    void SetHeight(float height);

    /**
     * Queues setting the distance of the eye from the look-at point.
     *
     * @mangled SetDist__12CSceneCmrSeqFf
     * @address 0x25CC60
     * @size 0x40
     */
    void SetDist(float dist);

    /**
     * Queues setting the angle, height and distance together.
     *
     * @mangled SetAHD__12CSceneCmrSeqFfff
     * @address 0x25CCA0
     * @size 0x60
     */
    void SetAHD(float angle, float height, float dist);

    /**
     * Queues an even change of the angle, height and distance over a number
     * of 60 Hz frames.
     *
     * @mangled MoveAHD__12CSceneCmrSeqFfffi
     * @address 0x25CD00
     * @size 0xC0
     */
    void MoveAHD(float angle, float height, float dist, int frame);

    /**
     * Queues an eased change of the angle, height and distance over a
     * number of 60 Hz frames.
     *
     * @mangled MoveAHD2__12CSceneCmrSeqFfffiif
     * @address 0x25CDC0
     * @size 0xE0
     */
    void MoveAHD2(float angle, float height, float dist, int frame, int ease, float ease_rate);

    /**
     * Queues following an event object, or a named frame of it, from an
     * angle, height and distance, with an offset on the look-at point.
     *
     * @mangled SetSyncObj__12CSceneCmrSeqFiPffffiPc
     * @address 0x25CEA0
     * @size 0xD0
     */
    void SetSyncObj(int obj, float *ofs, float angle, float height, float dist, int mode, char *frame_name);

    /**
     * Queues stopping the follow of an event object.
     *
     * @mangled ReleaseSyncObj__12CSceneCmrSeqFv
     * @address 0x25CF70
     * @size 0x30
     */
    void ReleaseSyncObj();

    /**
     * Queues letting the last angle, height and distance change die away by
     * a rate every frame over a number of 60 Hz frames.
     *
     * @mangled AHDSlowing__12CSceneCmrSeqFfi
     * @address 0x25CFA0
     * @size 0xA0
     */
    void AHDSlowing(float rate, int frame);

    /**
     * Queues marking the angle track's return point.
     *
     * @mangled AHDKeep__12CSceneCmrSeqFv
     * @address 0x25D040
     * @size 0x30
     */
    void AHDKeep();

    /**
     * Queues going back to the angle track's return point.
     *
     * @mangled AHDReturn__12CSceneCmrSeqFv
     * @address 0x25D070
     * @size 0x30
     */
    void AHDReturn();

    /**
     * Queues a wait of a number of 60 Hz frames on the fade track.
     *
     * @mangled FadeDelay__12CSceneCmrSeqFi
     * @address 0x25D0A0
     * @size 0x90
     */
    void FadeDelay(int frame);

    /**
     * Queues a fade track marker that does nothing.
     *
     * @mangled FadeInit__12CSceneCmrSeqFv
     * @address 0x25D130
     * @size 0x30
     */
    void FadeInit();

    /**
     * Queues fading the screen in from a colour over a number of 60 Hz
     * frames.
     *
     * @mangled FadeIn__12CSceneCmrSeqFifff
     * @address 0x25D160
     * @size 0xC0
     */
    void FadeIn(int frame, float r, float g, float b);

    /**
     * Queues fading the screen out to a colour over a number of 60 Hz
     * frames.
     *
     * @mangled FadeOut__12CSceneCmrSeqFifff
     * @address 0x25D220
     * @size 0xC0
     */
    void FadeOut(int frame, float r, float g, float b);

    /**
     * Queues a wait of a number of 60 Hz frames on the shake track.
     *
     * @mangled QuakeDelay__12CSceneCmrSeqFi
     * @address 0x25D2E0
     * @size 0x90
     */
    void QuakeDelay(int frame);

    /**
     * Queues a shake of a size that dies away over a number of 60 Hz
     * frames, or that lasts while the count is negative.
     *
     * @mangled Quake__12CSceneCmrSeqFPfi
     * @address 0x25D370
     * @size 0xB0
     */
    void Quake(float *amp, int frame);

    /**
     * Queues a shake like Quake that moves the camera vertically only.
     *
     * @mangled Quake2__12CSceneCmrSeqFPfi
     * @address 0x25D420
     * @size 0xD0
     */
    void Quake2(float *amp, int frame);

    /**
     * Queues a wait of a number of 60 Hz frames on the character track.
     *
     * @mangled CharaDelay__12CSceneCmrSeqFi
     * @address 0x25D4F0
     * @size 0x90
     */
    void CharaDelay(int frame);

    /**
     * Queues keeping a character a distance in front of the eye for a
     * number of 60 Hz frames, or for ever when the count is negative.
     *
     * @mangled CharaAttach__12CSceneCmrSeqFifi
     * @address 0x25D580
     * @size 0xB0
     */
    void CharaAttach(int chara_no, float dist, int frame);
};
STATIC_ASSERT(sizeof(CSceneCmrSeq) == 0xB10);

/**
 *
 * Event object sequencer: runs queued commands on seven tracks that move, turn, animate, colour, scale and sound one event object.
 *
 */
class CSceneObjSeq {
public:
    _SEN_OBJ_SEQ *seq_tbl;       /**< Pool of command entries. */
    int seq_num;                 /**< Number of entries in the pool. */
    _SEN_OBJ_SEQ *pos_seq;       /**< Current command of the position track. */
    _SEN_OBJ_SEQ *pos_last;      /**< Last command of the position track. */
    _SEN_OBJ_SEQ *rot_seq;       /**< Current command of the rotation track. */
    _SEN_OBJ_SEQ *rot_last;      /**< Last command of the rotation track. */
    _SEN_OBJ_SEQ *mot_seq;       /**< Current command of the motion track. */
    _SEN_OBJ_SEQ *mot_last;      /**< Last command of the motion track. */
    _SEN_OBJ_SEQ *anm_seq;       /**< Current command of the texture animation track. */
    _SEN_OBJ_SEQ *anm_last;      /**< Last command of the texture animation track. */
    _SEN_OBJ_SEQ *col_seq;       /**< Current command of the colour track. */
    _SEN_OBJ_SEQ *col_last;      /**< Last command of the colour track. */
    _SEN_OBJ_SEQ *scale_seq;     /**< Current command of the scale track. */
    _SEN_OBJ_SEQ *scale_last;    /**< Last command of the scale track. */
    _SEN_OBJ_SEQ *se_seq;        /**< Current command of the sound effect track. */
    _SEN_OBJ_SEQ *se_last;       /**< Last command of the sound effect track. */
    int pos_cnt;                 /**< Frame counter of the running position command. */
    int rot_cnt;                 /**< Frame counter of the running rotation command. */
    int mot_cnt;                 /**< Frame counter of the running motion command. */
    int anm_cnt;                 /**< Frame counter of the running texture animation command. */
    int col_cnt;                 /**< Frame counter of the running colour command. */
    int scale_cnt;               /**< Frame counter of the running scale command. */
    int se_cnt;                  /**< Frame counter of the running sound effect command. */
    s32 unk_5c;
    s32 unk_60;
    int eoh_no;                  /**< Handle of the event object the sequence drives, or -1 for none. */
    s32 unk_68;
    s32 unk_6c;
    sceVu0FVECTOR pos;           /**< Position of the object. */
    sceVu0FVECTOR rot;           /**< Rotation of the object, in radians. */
    sceVu0FVECTOR pos_spd;       /**< Movement in one frame of an even move. */
    sceVu0FVECTOR rot_spd;       /**< Rotation in one frame of an even turn. */
    sceVu0FVECTOR pos_ease_spd;  /**< Current movement in one frame of an eased move. */
    sceVu0FVECTOR rot_ease_spd;  /**< Current rotation in one frame of an eased turn. */
    sceVu0FVECTOR pos_ease_acc;  /**< Change of the movement in one frame of an eased move. */
    sceVu0FVECTOR rot_ease_acc;  /**< Change of the rotation in one frame of an eased turn. */
    int pos_ease_frame;          /**< Number of frames over which an eased move changes speed. */
    int rot_ease_frame;          /**< Number of frames over which an eased turn changes speed. */
    s32 unk_f8;
    s32 unk_fc;
    sceVu0FVECTOR jump_start;    /**< Position a jump starts from. */
    sceVu0FVECTOR jump_end;      /**< Position a jump lands on. */
    sceVu0FVECTOR color_spd;     /**< Colour change in one frame of a colour command. */
    sceVu0FVECTOR scale_spd;     /**< Scale change in one frame of a scale command. */
    CCharaPas pas;               /**< Path the object walks along. */

    /**
     * Sets up the path and an empty sequencer with no command pool.
     *
     * @mangled __ct__12CSceneObjSeqFv
     * @address 0x25EFF0
     * @size 0x40
     */
    CSceneObjSeq();

    /**
     * Forgets the command pool and clears the object state.
     *
     * @mangled ZeroInitialize__12CSceneObjSeqFv
     * @address 0x25F030
     * @size 0x20
     */
    void ZeroInitialize();

    /**
     * Takes a pool of command entries, clears every track and frees every
     * entry of the pool.
     *
     * @mangled Initialize__12CSceneObjSeqFP12_SEN_OBJ_SEQi
     * @address 0x25F050
     * @size 0x80
     */
    void Initialize(_SEN_OBJ_SEQ *seq_tbl, int seq_num);

    /**
     * Stops every track, forgets the driven object and clears the object
     * state.
     *
     * @mangled Clear__12CSceneObjSeqFv
     * @address 0x25F0D0
     * @size 0xC0
     */
    void Clear();

    /**
     * Sets the handle of the event object the sequence drives.
     *
     * @mangled SetEohNo__12CSceneObjSeqFi
     * @address 0x25F190
     * @size 0x10
     */
    void SetEohNo(int eoh_no);

    /**
     * Returns a free entry of the command pool, or NULL when none is left.
     *
     * @mangled SearchSeq__12CSceneObjSeqFv
     * @address 0x25F1A0
     * @size 0x50
     */
    _SEN_OBJ_SEQ *SearchSeq();

    /**
     * Frees a finished command entry and returns the command after it.
     *
     * @mangled GetNextSeq__12CSceneObjSeqFP12_SEN_OBJ_SEQ
     * @address 0x25F1F0
     * @size 0x40
     */
    _SEN_OBJ_SEQ *GetNextSeq(_SEN_OBJ_SEQ *seq);

    /**
     * Appends a free entry to the position track and returns it, or NULL.
     *
     * @mangled SearchNextPosSeq__12CSceneObjSeqFv
     * @address 0x25F230
     * @size 0x60
     */
    _SEN_OBJ_SEQ *SearchNextPosSeq();

    /**
     * Appends a free entry to the rotation track and returns it, or NULL.
     *
     * @mangled SearchNextRotSeq__12CSceneObjSeqFv
     * @address 0x25F290
     * @size 0x60
     */
    _SEN_OBJ_SEQ *SearchNextRotSeq();

    /**
     * Appends a free entry to the motion track and returns it, or NULL.
     *
     * @mangled SearchNextMotSeq__12CSceneObjSeqFv
     * @address 0x25F2F0
     * @size 0x60
     */
    _SEN_OBJ_SEQ *SearchNextMotSeq();

    /**
     * Appends a free entry to the texture animation track and returns it,
     * or NULL.
     *
     * @mangled SearchNextAnmSeq__12CSceneObjSeqFv
     * @address 0x25F350
     * @size 0x60
     */
    _SEN_OBJ_SEQ *SearchNextAnmSeq();

    /**
     * Appends a free entry to the colour track and returns it, or NULL.
     *
     * @mangled SearchNextColSeq__12CSceneObjSeqFv
     * @address 0x25F3B0
     * @size 0x60
     */
    _SEN_OBJ_SEQ *SearchNextColSeq();

    /**
     * Appends a free entry to the scale track and returns it, or NULL.
     *
     * @mangled SearchNextScaleSeq__12CSceneObjSeqFv
     * @address 0x25F410
     * @size 0x60
     */
    _SEN_OBJ_SEQ *SearchNextScaleSeq();

    /**
     * Appends a free entry to the sound effect track and returns it, or
     * NULL.
     *
     * @mangled SearchNextSeSeq__12CSceneObjSeqFv
     * @address 0x25F470
     * @size 0x60
     */
    _SEN_OBJ_SEQ *SearchNextSeSeq();

    /**
     * Returns non-zero once every track has finished.
     *
     * @mangled CheckEnd__12CSceneObjSeqFv
     * @address 0x25F4D0
     * @size 0x70
     */
    int CheckEnd();

    /**
     * Runs one frame of every track on the driven object and writes its
     * position and rotation back to it.
     *
     * @mangled Play__12CSceneObjSeqFv
     * @address 0x25F540
     * @size 0x200
     */
    void Play();

    /**
     * Queues a wait of a number of 60 Hz frames on the position track.
     *
     * @mangled PosDelay__12CSceneObjSeqFi
     * @address 0x25F740
     * @size 0x90
     */
    void PosDelay(int frame);

    /**
     * Queues putting the object at a position.
     *
     * @mangled SetPos__12CSceneObjSeqFPf
     * @address 0x25F7D0
     * @size 0x40
     */
    void SetPos(float *pos);

    /**
     * Queues an even move over a number of 60 Hz frames, kept on the
     * ground when the ground flag is 1.
     *
     * @mangled Move__12CSceneObjSeqFPfii
     * @address 0x25F810
     * @size 0xC0
     */
    void Move(float *pos, int frame, int ground);

    /**
     * Queues an eased move over a number of 60 Hz frames.
     *
     * @mangled Move2__12CSceneObjSeqFPfiif
     * @address 0x25F8D0
     * @size 0xD0
     */
    void Move2(float *pos, int frame, int ease, float ease_rate);

    /**
     * Queues clearing the object path.
     *
     * @mangled InitPas__12CSceneObjSeqFv
     * @address 0x25F9A0
     * @size 0x30
     */
    void InitPas();

    /**
     * Queues setting the object path's length in 60 Hz frames.
     *
     * @mangled SetPasFrm__12CSceneObjSeqFi
     * @address 0x25F9D0
     * @size 0x90
     */
    void SetPasFrm(int frame);

    /**
     * Queues adding a point to the object path.
     *
     * @mangled AddPas__12CSceneObjSeqFPf
     * @address 0x25FA60
     * @size 0x40
     */
    void AddPas(float *pos);

    /**
     * Queues walking the object along its path, kept on the ground when the
     * ground flag is 1.
     *
     * @mangled StartPas__12CSceneObjSeqFi
     * @address 0x25FAA0
     * @size 0x40
     */
    void StartPas(int ground);

    /**
     * Queues a jump to a position, peaking at a height, over a number of
     * 60 Hz frames.
     *
     * @mangled Jump__12CSceneObjSeqFPffi
     * @address 0x25FAE0
     * @size 0xD0
     */
    void Jump(float *pos, float height, int frame);

    /**
     * Queues keeping the object at an offset from a named frame of another
     * event object for a number of 60 Hz frames.
     *
     * @mangled SetEohFramePos__12CSceneObjSeqFiPciPf
     * @address 0x25FBB0
     * @size 0xD0
     */
    void SetEohFramePos(int eoh_no, char *frame_name, int frame, float *ofs);

    /**
     * Queues adding an offset to the position every frame for a number of
     * 60 Hz frames.
     *
     * @mangled AddPos__12CSceneObjSeqFPfi
     * @address 0x25FC80
     * @size 0xB0
     */
    void AddPos(float *add, int frame);

    /**
     * Queues keeping the object a distance in front of the camera for a
     * number of 60 Hz frames, or for ever when the count is negative.
     *
     * @mangled AttachCamera__12CSceneObjSeqFfi
     * @address 0x25FD30
     * @size 0xA0
     */
    void AttachCamera(float dist, int frame);

    /**
     * Queues a wait of a number of 60 Hz frames on the rotation track.
     *
     * @mangled RotDelay__12CSceneObjSeqFi
     * @address 0x25FDD0
     * @size 0x90
     */
    void RotDelay(int frame);

    /**
     * Queues setting the rotation.
     *
     * @mangled SetRot__12CSceneObjSeqFPf
     * @address 0x25FE60
     * @size 0x40
     */
    void SetRot(float *rot);

    /**
     * Queues an even turn to a rotation over a number of 60 Hz frames, or a
     * turn by the rotation every frame while the count is negative.
     *
     * @mangled Rotation__12CSceneObjSeqFPfi
     * @address 0x25FEA0
     * @size 0xB0
     */
    void Rotation(float *rot, int frame);

    /**
     * Queues an eased turn to a rotation over a number of 60 Hz frames.
     *
     * @mangled Rotation2__12CSceneObjSeqFPfiif
     * @address 0x25FF50
     * @size 0xD0
     */
    void Rotation2(float *rot, int frame, int ease, float ease_rate);

    /**
     * Queues turning the object to face a position over a number of 60 Hz
     * frames.
     *
     * @mangled Reference__12CSceneObjSeqFPfi
     * @address 0x260020
     * @size 0xB0
     */
    void Reference(float *pos, int frame);

    /**
     * Queues a wait of a number of 60 Hz frames on the motion track.
     *
     * @mangled MotionDelay__12CSceneObjSeqFi
     * @address 0x2600D0
     * @size 0x90
     */
    void MotionDelay(int frame);

    /**
     * Queues starting a named motion at once.
     *
     * @mangled SetMotion__12CSceneObjSeqFPcif
     * @address 0x260160
     * @size 0x70
     */
    void SetMotion(char *name, int flags, float step);

    /**
     * Queues starting a named motion once the current one ends.
     *
     * @mangled NextMotion__12CSceneObjSeqFPcif
     * @address 0x2601D0
     * @size 0x70
     */
    void NextMotion(char *name, int flags, float step);

    /**
     * Queues waiting for the current motion to end.
     *
     * @mangled MotionWait__12CSceneObjSeqFv
     * @address 0x260240
     * @size 0x30
     */
    void MotionWait();

    /**
     * Queues arming the motion trigger.
     *
     * @mangled SetMotionTrg__12CSceneObjSeqFv
     * @address 0x260270
     * @size 0x30
     */
    void SetMotionTrg();

    /**
     * Queues waiting for the motion trigger.
     *
     * @mangled MotionTrgWait__12CSceneObjSeqFv
     * @address 0x2602A0
     * @size 0x30
     */
    void MotionTrgWait();

    /**
     * Queues setting the motion playback step.
     *
     * @mangled SetStep__12CSceneObjSeqFf
     * @address 0x2602D0
     * @size 0x40
     */
    void SetStep(float step);

    /**
     * Queues setting the motion blend step.
     *
     * @mangled SetChengeStep__12CSceneObjSeqFf
     * @address 0x260310
     * @size 0x40
     */
    void SetChengeStep(float step);

    /**
     * Queues resetting the motion.
     *
     * @mangled ResetMotion__12CSceneObjSeqFv
     * @address 0x260350
     * @size 0x30
     */
    void ResetMotion();

    /**
     * Queues setting the current motion time.
     *
     * @mangled SetMotionNowTime__12CSceneObjSeqFf
     * @address 0x260380
     * @size 0x40
     */
    void SetMotionNowTime(float time);

    /**
     * Queues setting the motion wait time.
     *
     * @mangled SetMotionWaitTime__12CSceneObjSeqFf
     * @address 0x2603C0
     * @size 0x40
     */
    void SetMotionWaitTime(float time);

    /**
     * Queues returning the object to its normal behaviour.
     *
     * @mangled NormalDrive__12CSceneObjSeqFv
     * @address 0x260400
     * @size 0x30
     */
    void NormalDrive();

    /**
     * Queues a wait of a number of 60 Hz frames on the texture animation
     * track.
     *
     * @mangled TexAnimeDelay__12CSceneObjSeqFi
     * @address 0x260430
     * @size 0x90
     */
    void TexAnimeDelay(int frame);

    /**
     * Queues turning a named texture animation on or off; a NULL name with
     * the switch off turns every texture animation off.
     *
     * @mangled TexAnime__12CSceneObjSeqFPci
     * @address 0x2604C0
     * @size 0x80
     */
    void TexAnime(char *name, int on);

    /**
     * Queues a wait of a number of 60 Hz frames on the colour track.
     *
     * @mangled ColorDelay__12CSceneObjSeqFi
     * @address 0x260540
     * @size 0x90
     */
    void ColorDelay(int frame);

    /**
     * Queues changing the object colour over a number of 60 Hz frames.
     *
     * @mangled SetColor__12CSceneObjSeqFPfi
     * @address 0x2605D0
     * @size 0xB0
     */
    void SetColor(float *color, int frame);

    /**
     * Queues a wait of a number of 60 Hz frames on the scale track.
     *
     * @mangled ScaleDelay__12CSceneObjSeqFi
     * @address 0x260680
     * @size 0x90
     */
    void ScaleDelay(int frame);

    /**
     * Queues changing the object scale over a number of 60 Hz frames.
     *
     * @mangled SetScale__12CSceneObjSeqFPfi
     * @address 0x260710
     * @size 0xB0
     */
    void SetScale(float *scale, int frame);

    /**
     * Queues a wait of a number of 60 Hz frames on the sound effect track.
     *
     * @mangled SeDelay__12CSceneObjSeqFi
     * @address 0x2607C0
     * @size 0x90
     */
    void SeDelay(int frame);

    /**
     * Queues playing a sound effect of a sound bank.
     *
     * @mangled SePlay__12CSceneObjSeqFii
     * @address 0x260850
     * @size 0x50
     */
    void SePlay(int snd_id, int se_no);

    /**
     * Queues writing the position and rotation back to the object and
     * resetting its dynamic animation, on the motion and sound tracks.
     *
     * @mangled ResetDAPosition__12CSceneObjSeqFv
     * @address 0x2608A0
     * @size 0x50
     */
    void ResetDAPosition();
};
STATIC_ASSERT(sizeof(CSceneObjSeq) == 0x5F0);

void InitSceneCmrSeq(_SEN_CMR_SEQ *seq);
void InitSceneObjSeq(_SEN_OBJ_SEQ *seq);
