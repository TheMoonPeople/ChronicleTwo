#pragma once

#include "common.h"

#include <libvu0.h>

#include "dng_effect.hpp"
#include "runscript.hpp"
#include "scenesnd.hpp"
#include "sceneseq.hpp"

/**
 * @file
 * Declares the town and dungeon event state: the event information block
 * that event scripts fill in, the event object handles through which scripts
 * move characters, objects, sprites, frames and function points, the event
 * screen effects, the argument lists that event scripts load, and the
 * routines that set up, step, draw and finish an event.
 */

class CCharacter2;
class CEventSprite2;
class CEventSpriteMother;
class CFuncPoint;
class CMapParts;
class CMarker;
class CObject;
class CRain;
class mgCCamera;
class mgCFrame;
class mgCMemory;
class mgCTexture;
class ClsMes;

/**
 *
 * Kinds of game thing an event object handle refers to, as CEoh::type holds them.
 *
 */
enum EOH_TYPE {
    EOH_TYPE_NONE = -1,      /**< The handle refers to nothing. */
    EOH_TYPE_CHARA = 0,      /**< A scene character. */
    EOH_TYPE_OBJECT = 1,     /**< A map object. */
    EOH_TYPE_SPRITE = 2,     /**< An event sprite. */
    EOH_TYPE_FRAME = 3,      /**< A model frame. */
    EOH_TYPE_FUNC_POINT = 4, /**< A map function point. */
};

/**
 *
 * Number of event object handles an event can hold at once.
 *
 */
#define EOH_NUM 32

/**
 *
 * Progress of a raster (wavy screen) effect, as CRaster::state holds it.
 *
 */
enum RASTER_STATE {
    RASTER_OFF = 0,   /**< The effect is not drawn. */
    RASTER_START = 1, /**< The effect is moving towards its target strength. */
    RASTER_ON = 2,    /**< The effect is drawn at a steady strength. */
    RASTER_STOP = 3,  /**< The effect is fading out, and turns off once the fade ends. */
};

/**
 *
 * Number of movie captions an event can queue.
 *
 */
#define EVENT_CAPTION_NUM 18

/**
 *
 * State that the running town or dungeon event and its script share with the
 * game loops: the event's world coordinate, its requests to change map or mode,
 * skip, sound, stream, door, stopwatch and movie caption settings.
 *
 */
struct ED_EVENT_INFO {
    sceVu0FVECTOR world_coord_pos;    /**< Origin of the event's world coordinate. */
    sceVu0FVECTOR world_coord_rot;    /**< Rotation, in radians, of the event's world coordinate. */
    float projection;                 /**< Projection distance used while the event is drawn. */
    u8 unk_24[0x40];
    int jump_point;                   /**< Entry point on the map an event moves the player to, or -1. */
    char jump_map_name[0x20];         /**< Name of the map or interior an event moves the player to. */
    int event_no;                     /**< Event started after a map change or script load, or below zero for none. */
    char script_name[0x40];           /**< Path of the event script file the event asks to load. */
    int request;                      /**< Request the event leaves for the game loop. @see EVENT_REQUEST. */
    int command_mode;                 /**< How the running script is advanced each frame. @see EVENT_COMMAND_MODE. */
    int skip_state;                   /**< Progress of skipping the drama scene. @see EVENT_SKIP_STATE. */
    int skip_button;                  /**< Pad button that skips the drama scene. */
    s32 unk_dc;
    float skip_fade_color[4];         /**< Colour the screen fades to when the drama scene is skipped. */
    int start_button;                 /**< Pad button that the script reads as its start button. */
    int snd_id[12];                   /**< Sound bank handle loaded into each sound port. */
    int last_snd_id;                  /**< Sound bank handle loaded most recently. */
    s32 unk_128;
    float env_bgm_volume;             /**< Volume of the environment music the event started. */
    int env_bgm_no;                   /**< Environment music the event started. */
    int stream_playing;               /**< Non-zero while a voice stream the event started is playing. */
    int stream_from_fpl;              /**< Non-zero when the open voice stream was opened from a voice pack. */
    int func_iparam[16];              /**< Integer parameters of the door mode: character number, entry point and sound effect. */
    float func_fparam[16];            /**< Float parameters of the door mode: position, facing, camera position and look-at offset. */
    int monster_talk[3];              /**< Talk data of the monster the player spoke to in the dungeon. */
    int door_type;                    /**< Kind of door the door mode opens, choosing its sound effect. */
    int interior_entrance;            /**< Entrance of the interior an event moves the player into. */
    u64 stopwatch_start;              /**< Play time at which the stopwatch started, or 0 while it is stopped. */
    s64 stopwatch_limit;              /**< Time limit the stopwatch counts down from, or 0 to count up. */
    int stopwatch_x;                  /**< Screen X position of the stopwatch. */
    int stopwatch_y;                  /**< Screen Y position of the stopwatch. */
    int stopwatch_style;              /**< Layout the stopwatch is drawn in. */
    CMapParts *dng_event_parts;       /**< Dungeon map part the player triggered an event at. */
    int dng_event_found;              /**< Non-zero once a dungeon event part has been found. */
    int pack_loaded;                  /**< Non-zero while the read buffer holds a pack file that loads search first. */
    int map_draw;                     /**< Non-zero while the map is drawn behind the event. */
    int stream_reading;               /**< Non-zero while a stream reads the disc, so files may not be loaded. */
    int stream_volume;                /**< Volume the event plays its voice stream at. */
    int caption_enable;               /**< Non-zero while movie captions are drawn. */
    int caption_start[EVENT_CAPTION_NUM];                  /**< Movie frame at which each caption appears. */
    int caption_frames[EVENT_CAPTION_NUM];                 /**< Number of movie frames each caption stays. */
    char caption_text[EVENT_CAPTION_NUM][0xE1];            /**< Text of each caption. */
    u8 unk_126a[0x2];
    char *npc_talk_text;              /**< Loaded NPC conversation text of the town. */
    int npc_talk_size;                /**< Size of the loaded NPC conversation text. */
    CScene::BGM_STATUS bgm_status;    /**< Music state the event saved and can restore. */
    float keep_time;                  /**< Time of day the event saved. */
    u8 unk_1294[0xC];
};

STATIC_ASSERT(sizeof(ED_EVENT_INFO) == 0x12A0);

/**
 *
 * One handle through which an event script refers to a character, object,
 * sprite, frame or function point by a small number.
 *
 */
class CEoh {
public:
    int type;        /**< Kind of thing the handle refers to. @see EOH_TYPE. */
    int scene_no;    /**< Scene character slot of a character handle. */
    int world_coord; /**< Non-zero when positions given to an object or function point are in the event's world coordinate. */

    union {
        CCharacter2 *chara;      /**< Character the handle refers to. */
        CObject *object;         /**< Map object the handle refers to. */
        CEventSprite2 *sprite;   /**< Event sprite the handle refers to. */
        mgCFrame *frame;         /**< Model frame the handle refers to. */
        CFuncPoint *func_point;  /**< Function point the handle refers to. */
    };

    /**
     * Makes a handle that refers to nothing.
     *
     * @mangled __ct__4CEohFv
     * @address 0x2608F0
     * @size 0x30
     */
    CEoh();

    /**
     * Points the handle at a map object; returns 1 when the type is EOH_TYPE_OBJECT and the object exists, 0 otherwise.
     *
     * @mangled Set__4CEohFiP7CObjecti
     * @address 0x260920
     * @size 0x40
     */
    int Set(int type, CObject *object, int world_coord);

    /**
     * Points the handle at a scene character; returns 1 when the type is EOH_TYPE_CHARA and the character exists, 0 otherwise.
     *
     * @mangled Set__4CEohFiiP11CCharacter2
     * @address 0x260960
     * @size 0x40
     */
    int Set(int type, int scene_no, CCharacter2 *chara);

    /**
     * Points the handle at an event sprite; returns 1 when the type is EOH_TYPE_SPRITE and the sprite exists, 0 otherwise.
     *
     * @mangled Set__4CEohFiP13CEventSprite2
     * @address 0x2609A0
     * @size 0x40
     */
    int Set(int type, CEventSprite2 *sprite);

    /**
     * Points the handle at a model frame; returns 1 when the type is EOH_TYPE_FRAME and the frame exists, 0 otherwise.
     *
     * @mangled Set__4CEohFiP8mgCFrame
     * @address 0x2609E0
     * @size 0x40
     */
    int Set(int type, mgCFrame *frame);

    /**
     * Points the handle at a function point; returns 1 when the type is EOH_TYPE_FUNC_POINT and the point exists, 0 otherwise.
     *
     * @mangled Set__4CEohFiP10CFuncPoint
     * @address 0x260A20
     * @size 0x50
     */
    int Set(int type, CFuncPoint *func_point);
};

STATIC_ASSERT(sizeof(CEoh) == 0x10);

/**
 *
 * The event's table of object handles, through which event scripts move,
 * turn, scale, show and animate whatever each handle refers to.
 *
 */
class CEohMother {
public:
    CEoh eoh[EOH_NUM]; /**< Handles, indexed by the number the script uses. */

    /**
     * Makes a table in which every handle refers to nothing.
     *
     * @mangled __ct__10CEohMotherFv
     * @address 0x260CE0
     * @size 0x180
     */
    CEohMother();

    /**
     * Points a handle at a map object; returns 1 on success, 0 for a bad handle number or object.
     *
     * @mangled Set__10CEohMotherFiiP7CObjecti
     * @address 0x260E60
     * @size 0x40
     */
    int Set(int no, int type, CObject *object, int world_coord);

    /**
     * Points a handle at a scene character; returns 1 on success, 0 for a bad handle number or character.
     *
     * @mangled Set__10CEohMotherFiiiP11CCharacter2
     * @address 0x260EA0
     * @size 0x40
     */
    int Set(int no, int type, int scene_no, CCharacter2 *chara);

    /**
     * Points a handle at an event sprite; returns 1 on success, 0 for a bad handle number or sprite.
     *
     * @mangled Set__10CEohMotherFiiP13CEventSprite2
     * @address 0x260EE0
     * @size 0x40
     */
    int Set(int no, int type, CEventSprite2 *sprite);

    /**
     * Points a handle at a model frame; returns 1 on success, 0 for a bad handle number or frame.
     *
     * @mangled Set__10CEohMotherFiiP8mgCFrame
     * @address 0x260F20
     * @size 0x40
     */
    int Set(int no, int type, mgCFrame *frame);

    /**
     * Points a handle at a function point; returns 1 on success, 0 for a bad handle number or point.
     *
     * @mangled Set__10CEohMotherFiiP10CFuncPoint
     * @address 0x260F60
     * @size 0x40
     */
    int Set(int no, int type, CFuncPoint *func_point);

    /**
     * Moves what a handle refers to, converting from the event's world coordinate where it applies; returns 1 on success.
     *
     * @mangled SetPos__10CEohMotherFifff
     * @address 0x260FA0
     * @size 0x2A0
     */
    int SetPos(int no, float x, float y, float z);

    /**
     * Turns what a handle refers to, adding the rotation of the event's world coordinate; returns 1 on success.
     *
     * @mangled SetRot__10CEohMotherFifff
     * @address 0x261240
     * @size 0x220
     */
    int SetRot(int no, float x, float y, float z);

    /**
     * Gives the position of what a handle refers to in the event's world coordinate; returns 1 on success.
     *
     * @mangled GetPos__10CEohMotherFiPf
     * @address 0x261460
     * @size 0x1C0
     */
    int GetPos(int no, float *pos);

    /**
     * Gives the rotation of what a handle refers to in the event's world coordinate; returns 1 on success.
     *
     * @mangled GetRot__10CEohMotherFiPf
     * @address 0x261620
     * @size 0x1E0
     */
    int GetRot(int no, float *rot);

    /**
     * Starts a motion on a character handle, optionally at a given time; returns 1 on success.
     *
     * @mangled SetMotion__10CEohMotherFiPcif
     * @address 0x261800
     * @size 0xE0
     */
    int SetMotion(int no, char *name, int flag, float time);

    /**
     * Returns whether the motion of a character handle has ended, or 0 for a handle that is not a character.
     *
     * @mangled CheckMotionEnd__10CEohMotherFi
     * @address 0x2618E0
     * @size 0xA0
     */
    int CheckMotionEnd(int no);

    /**
     * Asks the motion sequence of a character handle to move on; returns 1 on success.
     *
     * @mangled SetMotionTrg__10CEohMotherFi
     * @address 0x261980
     * @size 0x80
     */
    int SetMotionTrg(int no);

    /**
     * Returns the progress of the motion sequence of a character handle, or 0 when it has none.
     *
     * @mangled GetSeqStatus__10CEohMotherFi
     * @address 0x261A00
     * @size 0x70
     */
    int GetSeqStatus(int no);

    /**
     * Sets the speed at which a character handle's motion plays; returns 1 on success.
     *
     * @mangled SetStep__10CEohMotherFif
     * @address 0x261A70
     * @size 0x70
     */
    int SetStep(int no, float step);

    /**
     * Sets the speed at which a character handle blends into its next motion; returns 1 on success.
     *
     * @mangled SetChangeStep__10CEohMotherFif
     * @address 0x261AE0
     * @size 0x80
     */
    int SetChangeStep(int no, float step);

    /**
     * Puts the motion of a character handle back to its start; returns 1 on success.
     *
     * @mangled ResetMotion__10CEohMotherFi
     * @address 0x261B60
     * @size 0x70
     */
    int ResetMotion(int no);

    /**
     * Switches a texture animation of a character handle on or off, or all of them off; returns 1 on success.
     *
     * @mangled SetTexAnim__10CEohMotherFiiPc
     * @address 0x261BD0
     * @size 0xC0
     */
    int SetTexAnim(int no, int on, char *name);

    /**
     * Scales what a handle refers to; returns 1 on success.
     *
     * @mangled SetScale__10CEohMotherFifff
     * @address 0x261C90
     * @size 0x140
     */
    int SetScale(int no, float x, float y, float z);

    /**
     * Gives the scale of what a handle refers to; returns 1 on success.
     *
     * @mangled GetScale__10CEohMotherFiPf
     * @address 0x261DD0
     * @size 0x120
     */
    int GetScale(int no, float *scale);

    /**
     * Shows or hides what a handle refers to; returns 1 on success.
     *
     * @mangled SetShow__10CEohMotherFii
     * @address 0x261EF0
     * @size 0xD0
     */
    int SetShow(int no, int show);

    /**
     * Gives whether what a handle refers to is shown; returns 1 on success.
     *
     * @mangled GetShow__10CEohMotherFiPi
     * @address 0x261FC0
     * @size 0xF0
     */
    int GetShow(int no, int *show);

    /**
     * Returns the frame of a character handle's model with a given name, or null.
     *
     * @mangled SearchFrame__10CEohMotherFiPc
     * @address 0x2620B0
     * @size 0x70
     */
    mgCFrame *SearchFrame(int no, char *name);

    /**
     * Shows or hides a named frame of what a handle refers to; returns 1 on success.
     *
     * @mangled SetFrameShow__10CEohMotherFiPci
     * @address 0x262120
     * @size 0xE0
     */
    int SetFrameShow(int no, char *name, int show);

    /**
     * Turns the shadow of a character handle on or off; returns 1 on success.
     *
     * @mangled SetShadow__10CEohMotherFii
     * @address 0x262200
     * @size 0x80
     */
    int SetShadow(int no, int on);

    /**
     * Shows or hides a named frame of a character handle's shadow model; returns 1 on success.
     *
     * @mangled SetShadowFrameShow__10CEohMotherFiPci
     * @address 0x262280
     * @size 0xB0
     */
    int SetShadowFrameShow(int no, char *name, int show);

    /**
     * Sets the translation of a frame handle or of a character handle's model; returns 1 on success.
     *
     * @mangled SetTranslate__10CEohMotherFiPf
     * @address 0x262330
     * @size 0xD0
     */
    int SetTranslate(int no, float *translate);

    /**
     * Sets the colour of an event sprite handle; returns 1 on success.
     *
     * @mangled SetColor__10CEohMotherFiPf
     * @address 0x262400
     * @size 0x70
     */
    int SetColor(int no, float *color);

    /**
     * Gives the colour of an event sprite handle; returns 1 on success.
     *
     * @mangled GetColor__10CEohMotherFiPf
     * @address 0x262470
     * @size 0x70
     */
    int GetColor(int no, float *color);

    /**
     * Returns the name of the motion a character handle is playing, or null.
     *
     * @mangled GetNowMotionName__10CEohMotherFi
     * @address 0x2624E0
     * @size 0x60
     */
    char *GetNowMotionName(int no);

    /**
     * Returns the state of the motion a character handle is playing, or 0.
     *
     * @mangled GetNowMotionStatus__10CEohMotherFi
     * @address 0x262540
     * @size 0x60
     */
    int GetNowMotionStatus(int no);

    /**
     * Moves the motion of a character handle to a time; returns 1 on success.
     *
     * @mangled SetMotionNowTime__10CEohMotherFif
     * @address 0x2625A0
     * @size 0xD0
     */
    int SetMotionNowTime(int no, float time);

    /**
     * Moves the motion of a character handle to a share of its length; returns 1 on success.
     *
     * @mangled SetMotionWaitTime__10CEohMotherFif
     * @address 0x262670
     * @size 0xD0
     */
    int SetMotionWaitTime(int no, float rate);

    /**
     * Sets the footstep sound of a character handle; returns 1 on success.
     *
     * @mangled SetFootSoundID__10CEohMotherFii
     * @address 0x262740
     * @size 0x60
     */
    int SetFootSoundID(int no, int id);

    /**
     * Gives the world position of a named frame of a character handle, in the event's world coordinate; returns 1 on success.
     *
     * @mangled GetFramePos__10CEohMotherFiPcPf
     * @address 0x2627A0
     * @size 0xB0
     */
    int GetFramePos(int no, char *name, float *pos);

    /**
     * Sets the sound bank a character handle plays its sound effects from; returns 1 on success.
     *
     * @mangled SetSoundID__10CEohMotherFiUi
     * @address 0x262850
     * @size 0x60
     */
    int SetSoundID(int no, unsigned int id);

    /**
     * Returns whether a named frame of what a handle refers to is shown, or 0.
     *
     * @mangled GetFrameShow__10CEohMotherFiPc
     * @address 0x2628B0
     * @size 0xD0
     */
    int GetFrameShow(int no, char *name);

    /**
     * Sets whether a character handle fades out when the camera comes close; returns 1 on success.
     *
     * @mangled SetFadeFlag__10CEohMotherFii
     * @address 0x262980
     * @size 0x70
     */
    int SetFadeFlag(int no, int flag);

    /**
     * Puts the dynamic-animation parts of a character handle back to rest; returns 1 on success.
     *
     * @mangled ResetDAPosition__10CEohMotherFi
     * @address 0x2629F0
     * @size 0x80
     */
    int ResetDAPosition(int no);

    /**
     * Steps the motion of a character handle once; returns 1 on success.
     *
     * @mangled NormalDrive__10CEohMotherFi
     * @address 0x262A70
     * @size 0x70
     */
    int NormalDrive(int no);

    /**
     * Applies the position of a character handle to its model; returns 1 on success.
     *
     * @mangled UpdatePosition__10CEohMotherFi
     * @address 0x262AE0
     * @size 0x70
     */
    int UpdatePosition(int no);

    /**
     * Sets the transparency of a named frame of what a handle refers to; returns 1 on success.
     *
     * @mangled SetFrameObjAlpha__10CEohMotherFiPcf
     * @address 0x262B50
     * @size 0x100
     */
    int SetFrameObjAlpha(int no, char *name, float alpha);

    /**
     * Sets the footstep sound effect of a character handle; returns 1 on success.
     *
     * @mangled SetFootSeId__10CEohMotherFii
     * @address 0x262C50
     * @size 0x70
     */
    int SetFootSeId(int no, int id);
};

STATIC_ASSERT(sizeof(CEohMother) == 0x200);

/**
 *
 * One argument of an event script argument list: a tagged integer, float or string.
 *
 */
struct ARG_DATA {
    int type; /**< Kind of value held. @see RS_STACK_TYPE. */

    union {
        int i;   /**< Value of an integer. */
        float f; /**< Value of a float. */
        char *s; /**< Value of a string. */
    };
};

STATIC_ASSERT(sizeof(ARG_DATA) == 0x8);

/**
 *
 * One argument list that an event script loaded, found by its number.
 *
 */
struct ARG_LIST {
    int id;          /**< Number the list is found by. */
    ARG_DATA *args;  /**< Arguments of the list. */
    int arg_num;     /**< Number of arguments. */
    ARG_LIST *next;  /**< Next list, or null. */
};

STATIC_ASSERT(sizeof(ARG_LIST) == 0x10);

/**
 *
 * The argument lists of an event, built by running an argument script that
 * hands each list to the event.
 *
 */
class CEventScriptArg {
public:
    CEventScriptArg();
    int next_id;        /**< Number the next list built is given. */
    ARG_LIST *list;     /**< First list, or null. */
    int list_num;       /**< Number of lists. */
    mgCMemory *memory;  /**< Memory the lists and their strings are taken from. */

    /**
     * Runs an argument script program, which builds this object's argument lists.
     *
     * @mangled BuildArgData__15CEventScriptArgFPUi
     * @address 0x262EB0
     * @size 0x150
     */
    void BuildArgData(unsigned int *program);
};

STATIC_ASSERT(sizeof(CEventScriptArg) == 0x10);

/**
 *
 * A raster effect that waves the screen sideways line by line, its strength,
 * speed and pitch moving to targets over a number of frames.
 *
 */
class CRaster {
public:
    CRaster();
    int state;             /**< Progress of the effect. @see RASTER_STATE. */
    float amplitude;       /**< Distance, in pixels, lines are moved at most. */
    float amplitude_step;  /**< Change of the amplitude each frame. */
    float speed;           /**< Angle, in radians, the wave moves each frame. */
    float speed_step;      /**< Change of the speed each frame. */
    float pitch;           /**< Angle, in radians, between one screen line and the next. */
    float pitch_step;      /**< Change of the pitch each frame. */
    float phase;           /**< Angle, in radians, of the wave at the top line. */
    s32 unk_20;
    int frames;            /**< Number of frames the current change lasts, or -1. */
    int frame;             /**< Frames passed in the current change. */

    /**
     * Turns the effect off and clears its settings.
     *
     * @mangled Initialize__7CRasterFv
     * @address 0x263440
     * @size 0x40
     */
    void Initialize();

    /**
     * Sets the amplitude, speed and pitch at once.
     *
     * @mangled SetParam__7CRasterFfff
     * @address 0x263480
     * @size 0x10
     */
    void SetParam(float amplitude, float speed, float pitch);

    /**
     * Turns the effect on, moving to the given amplitude, speed and pitch over a number of frames; -1 keeps a setting.
     *
     * @mangled StartRaster__7CRasterFfffi
     * @address 0x263490
     * @size 0x150
     */
    void StartRaster(float amplitude, float speed, float pitch, int frames);

    /**
     * Turns the effect off, moving to the given amplitude, speed and pitch over a number of frames; -1 keeps a setting.
     *
     * @mangled StopRaster__7CRasterFfffi
     * @address 0x2635E0
     * @size 0x150
     */
    void StopRaster(float amplitude, float speed, float pitch, int frames);

    /**
     * Moves the settings one frame towards their targets.
     *
     * @mangled StepRaster__7CRasterFv
     * @address 0x263730
     * @size 0x150
     */
    void StepRaster();

    /**
     * Redraws the frame buffer with each line moved by the wave.
     *
     * @mangled DrawRaster__7CRasterFv
     * @address 0x263880
     * @size 0x2A0
     */
    void DrawRaster();
};

STATIC_ASSERT(sizeof(CRaster) == 0x2C);

/**
 *
 * Full-screen effects an event can draw over the scene: the raster wave, a
 * sepia picture of the screen, and a flashing monochrome picture of it.
 *
 */
class CScreenEffect {
public:
    CScreenEffect();
    CRaster raster;                   /**< Raster wave effect. */
    mgCTexture *sepia_texture;        /**< Texture the sepia picture is captured into, or null. */
    int sepia;                        /**< Non-zero while the sepia picture is drawn. */
    mgCTexture *mono_flash_texture[2]; /**< Textures the two monochrome pictures are captured into, or null. */
    int mono_flash;                   /**< Non-zero while the monochrome pictures are drawn. */
    int mono_flash_interval;          /**< Number of frames each monochrome picture is shown. */
    int mono_flash_frame;             /**< Frames the current monochrome picture has been shown. */
    int mono_flash_no;                /**< Monochrome picture shown now, 0 or 1. */

    /**
     * Turns every effect off and forgets the textures.
     *
     * @mangled Initialize__13CScreenEffectFv
     * @address 0x263B20
     * @size 0x50
     */
    void Initialize();

    /**
     * Moves the raster wave one frame towards its targets.
     *
     * @mangled Step__13CScreenEffectFv
     * @address 0x263B70
     * @size 0x10
     */
    void Step();

    /**
     * Draws the sepia picture, the monochrome pictures and the raster wave that are on.
     *
     * @mangled Draw__13CScreenEffectFv
     * @address 0x263B80
     * @size 0x290
     */
    void Draw();

    /**
     * Turns the raster wave off and sets its amplitude, speed and pitch.
     *
     * @mangled InitRaster__13CScreenEffectFfff
     * @address 0x263E10
     * @size 0x60
     */
    void InitRaster(float amplitude, float speed, float pitch);

    /**
     * Turns the raster wave on over a number of frames.
     *
     * @mangled StartRaster__13CScreenEffectFfffi
     * @address 0x263E70
     * @size 0x10
     */
    void StartRaster(float amplitude, float speed, float pitch, int frames);

    /**
     * Turns the raster wave off over a number of frames.
     *
     * @mangled StopRaster__13CScreenEffectFfffi
     * @address 0x263E80
     * @size 0x10
     */
    void StopRaster(float amplitude, float speed, float pitch, int frames);

    /**
     * Gives the texture, and the image memory behind it, that the sepia picture is captured into.
     *
     * @mangled SetSepiaTexture__13CScreenEffectFP10mgCTextureP1
     * @address 0x263E90
     * @size 0x20
     */
    void SetSepiaTexture(mgCTexture *texture, u_long128 *image);

    /**
     * Captures the screen into the sepia texture, tinted sepia.
     *
     * @mangled CaptureSepiaScreen__13CScreenEffectFv
     * @address 0x263EB0
     * @size 0x280
     */
    void CaptureSepiaScreen();

    /**
     * Turns the sepia picture on or off; it stays off without a texture.
     *
     * @mangled SetSepiaFlag__13CScreenEffectFi
     * @address 0x264130
     * @size 0x20
     */
    void SetSepiaFlag(int on);

    /**
     * Gives the two textures, and the image memory behind them, that the monochrome pictures are captured into.
     *
     * @mangled SetMonoFlashTexture__13CScreenEffectFPP10mgCTexturePP1
     * @address 0x264150
     * @size 0x50
     */
    void SetMonoFlashTexture(mgCTexture **texture, u_long128 **image);

    /**
     * Captures the screen into the two monochrome textures.
     *
     * @mangled CaptureMonoFlashScreen__13CScreenEffectFv
     * @address 0x2641A0
     * @size 0x2D0
     */
    void CaptureMonoFlashScreen();

    /**
     * Turns the monochrome flash on or off and sets how many frames each picture is shown.
     *
     * @mangled SetMonoFlashFlag__13CScreenEffectFii
     * @address 0x264470
     * @size 0x40
     */
    void SetMonoFlashFlag(int on, int interval);
};

STATIC_ASSERT(sizeof(CScreenEffect) == 0x4C);

/**
 *
 * One spark of a hit effect, taken from the event's spark buffers.
 *
 */
struct HIT_EFFECT_PARTICLE {
    u8 unk_0[0x10];
    sceVu0FVECTOR pos; /**< Position of the spark. */
    sceVu0FVECTOR dir; /**< Direction the spark flies in. */
    float unk_30;
    float speed;       /**< Distance the spark flies each frame. */
    float slow;        /**< Amount the speed falls each frame. */
    int life;          /**< Frames left before the spark disappears. */
    s32 unk_40;
    float alpha;       /**< Opacity of the spark. */
    float alpha_step;  /**< Amount the opacity falls each frame. */
    s32 unk_4c;
};

STATIC_ASSERT(sizeof(HIT_EFFECT_PARTICLE) == 0x50);

/**
 * Number of hit effects an event can show at once.
 */
#define EVENT_HIT_EFFECT_NUM 5

/**
 * Number of sparks each event hit effect can show.
 */
#define EVENT_HIT_PARTICLE_NUM 0x40

/**
 * Marker an event draws over a character's head.
 */
extern CMarker EventMarker;

/**
 * Script slot that receives the item the player picks in the item menu an event opened, or null.
 */
extern RS_STACKDATA *p_use_item;

/**
 * Non-zero while the event's world coordinate is applied to positions.
 */
extern int SetWorldCoordFlg;

/**
 * Event object handle whose texture animation follows the voice stream's mouth movement, or -1.
 */
extern int PakuAnimEohNo;

/**
 * Event object handle whose motion follows the voice stream's mouth movement, or -1.
 */
extern int PakuMotionEohNo;

/**
 * How the mouth motion is played.
 */
extern int PakuMotionType;

/**
 * How the second mouth motion is played.
 */
extern int PakuMotionType2;

/**
 * State the running event and its script share with the game loops.
 */
extern ED_EVENT_INFO EdEventInfo;

/**
 * Object handles of the running event.
 */
extern CEohMother EventObjHandleMother;

/**
 * Text sprites of the running event.
 */
extern CEventSpriteMother esMother;

/**
 * Flags local to the running event, 32 to a word.
 */
extern u32 EventLocalFlag[0x40];

/**
 * Counters local to the running event.
 */
extern int EventLocalCnt[0x40];

/**
 * Rain the running event shows.
 */
extern CRain EventRain;

/**
 * Spark buffers of the event's hit effects.
 */
extern HIT_EFFECT_PARTICLE Hit_para[EVENT_HIT_EFFECT_NUM][EVENT_HIT_PARTICLE_NUM];

/**
 * Hit effects the running event shows.
 */
extern CHitEffectImage HitEffect[EVENT_HIT_EFFECT_NUM];

/**
 * Name of the texture animation that follows the voice stream's mouth movement.
 */
extern char PakuAnimName[0x40];

/**
 * Name of the second texture animation that follows the voice stream's mouth movement.
 */
extern char PakuAnimName2[0x40];

/**
 * Name of the motion that follows the voice stream's mouth movement.
 */
extern char PakuMotionName[0x40];

/**
 * Name of the second motion that follows the voice stream's mouth movement.
 */
extern char PakuMotionName2[0x40];

/**
 * Command entries of the event's camera sequence.
 */
extern _SEN_CMR_SEQ cmr_seq_tbl[0x100];

/**
 * Command entries shared by the event's object sequences.
 */
extern _SEN_OBJ_SEQ obj_seq_tbl[0x100];

/**
 * Full-screen effects of the running event.
 */
extern CScreenEffect EventScreenEffect;

/**
 * Multiplies a vector by the upper 3x3 of a matrix, giving a vector with w = 1.
 *
 * @mangled VectMatMul__FPfPfPA4_f
 * @address 0x260A70
 * @size 0xB0
 */
void VectMatMul(float *out, float *in, float (*matrix)[4]);

/**
 * Converts a position from the event's world coordinate into the map's.
 *
 * @mangled CalcPosWorldCoord__FPf
 * @address 0x260B20
 * @size 0x60
 */
void CalcPosWorldCoord(float *pos);

/**
 * Converts a position from the map's coordinate into the event's world coordinate.
 *
 * @mangled CalcPosWorldCoordGyaku__FPf
 * @address 0x260B80
 * @size 0x80
 */
void CalcPosWorldCoordGyaku(float *pos);

/**
 * Converts a camera's eye and look-at point from the event's world coordinate into the map's.
 *
 * @mangled SetCamWorldCoord__FP9mgCCamera
 * @address 0x260C00
 * @size 0x70
 */
void SetCamWorldCoord(mgCCamera *camera);

/**
 * Converts a camera's eye and look-at point from the map's coordinate into the event's world coordinate.
 *
 * @mangled SetCamWorldCoordGyaku__FP9mgCCamera
 * @address 0x260C70
 * @size 0x70
 */
void SetCamWorldCoordGyaku(mgCCamera *camera);

/**
 * Puts the event's world coordinate back onto the map's and stops applying it.
 *
 * @mangled InitWorldCoord__Fv
 * @address 0x2644B0
 * @size 0x50
 */
void InitWorldCoord();

/**
 * Returns whether an event local flag is set, or 0 for a bad flag number.
 *
 * @mangled GetLocalFlag__Fi
 * @address 0x264500
 * @size 0x80
 */
int GetLocalFlag(int no);

/**
 * Sets or clears an event local flag; returns the value set, or 0 for a bad flag number.
 *
 * @mangled SetLocalFlag__Fii
 * @address 0x264580
 * @size 0x90
 */
int SetLocalFlag(int no, int on);

/**
 * Returns an event local counter, or -1 for a bad counter number.
 *
 * @mangled GetLocalCnt__Fi
 * @address 0x264610
 * @size 0x40
 */
int GetLocalCnt(int no);

/**
 * Sets an event local counter; returns 1, or 0 for a bad counter number.
 *
 * @mangled SetLocalCnt__Fii
 * @address 0x264650
 * @size 0x40
 */
int SetLocalCnt(int no, int value);

/**
 * Returns the number of the first event local counter that holds a value, or -1.
 *
 * @mangled GetLocalCnt2__Fi
 * @address 0x264690
 * @size 0x50
 */
int GetLocalCnt2(int value);

/**
 * Clears every event local counter.
 *
 * @mangled InitLocalCnt__Fv
 * @address 0x2646E0
 * @size 0x50
 */
void InitLocalCnt();

/**
 * Clears the requests, skip, sound, stream and door settings of the event information.
 *
 * @mangled EdEventInfoCommandInitialize__Fv
 * @address 0x264730
 * @size 0x110
 */
void EdEventInfoCommandInitialize();

/**
 * Clears the event object handles, camera and object sequences, sprites, screen effects and argument lists.
 *
 * @mangled EventSeqInit__Fv
 * @address 0x264840
 * @size 0x1F0
 */
void EventSeqInit();

/**
 * Prepares the event system when an event starts: its sound memory, the event map, the world coordinate and every event object.
 *
 * @mangled EdEventInit__Fv
 * @address 0x264A30
 * @size 0x2C0
 */
void EdEventInit();

/**
 * Draws the event's stopwatch and its other timers.
 *
 * @mangled EventTimeDraw__Fv
 * @address 0x264CF0
 * @size 0xB60
 */
void EventTimeDraw();

/**
 * Draws the event's rain, hit effects, sword and effect scripts, event map, sprites and screen effects.
 *
 * @mangled EdEventDraw__Fv
 * @address 0x265850
 * @size 0x100
 */
void EdEventDraw();

/**
 * Draws the event sprites that are drawn before the scene.
 *
 * @mangled EdEventFirstDraw__Fv
 * @address 0x265950
 * @size 0x50
 */
void EdEventFirstDraw();

/**
 * Puts every event object back to rest when an event ends; returns 1, or 0 when the scene has no camera.
 *
 * @mangled EdEventFinish__Fv
 * @address 0x2659A0
 * @size 0x2C0
 */
int EdEventFinish();

/**
 * Steps the event's sequences, effects and background loading once; returns 1.
 *
 * @mangled EdEventStep__Fv
 * @address 0x265C60
 * @size 0xF0
 */
int EdEventStep();

/**
 * Lets the running drama scene be skipped with the default button and fade colour.
 *
 * @mangled InitDramaScene__Fv
 * @address 0x265D50
 * @size 0x40
 */
void InitDramaScene();

/**
 * Stops the running drama scene from being skipped.
 *
 * @mangled CancelDramaScene__Fv
 * @address 0x265D90
 * @size 0x10
 */
void CancelDramaScene();

/**
 * Hands the item picked in a menu the event opened back to the waiting script.
 *
 * @mangled EdEventMenuExit__Fv
 * @address 0x265DA0
 * @size 0x20
 */
void EdEventMenuExit();

/**
 * Does nothing.
 *
 * @mangled EdSetBrokenObject__Fv
 * @address 0x265E90
 * @size 0x10
 */
void EdSetBrokenObject();

/**
 * Forgets the message files loaded into every event message window.
 *
 * @mangled ResetMesFileBuffAll__Fv
 * @address 0x265EA0
 * @size 0x50
 */
void ResetMesFileBuffAll();

/**
 * Clears the event's sound handles and script path, the world coordinate, the requests and the screen effects before an event loop starts.
 *
 * @mangled EdEventLoopInit__Fv
 * @address 0x265DC0
 * @size 0xD0
 */
void EdEventLoopInit();

/**
 * Prepares the event system when a map is entered: its effects, stopwatch and sprites.
 *
 * @mangled EdEventMapInit__Fv
 * @address 0x265EF0
 * @size 0x280
 */
void EdEventMapInit();

/**
 * Stops the voice stream the event was playing.
 *
 * @mangled EdEventTermination__Fv
 * @address 0x266170
 * @size 0x70
 */
void EdEventTermination();

/**
 * Forgets the event's message files and clears its sequences when an event ends.
 *
 * @mangled EdEventEnd__Fv
 * @address 0x2661E0
 * @size 0x30
 */
void EdEventEnd();

/**
 * Returns the data of a file already read in the background from the current directory, or null, and gives its size.
 *
 * @mangled CheckLoadedBGFile__FPcPi
 * @address 0x266410
 * @size 0x80
 */
unsigned int *CheckLoadedBGFile(char *name, int *size);

/**
 * Returns the data of a file, taken from the background-read files, the loaded pack file or the disc, or null, and gives its size.
 *
 * @mangled GetLoadBGBuff__FPcPi
 * @address 0x266490
 * @size 0x170
 */
unsigned int *GetLoadBGBuff(char *name, int *size);

/**
 * Loads a character into a scene character slot from a pack file; returns non-zero on success.
 *
 * @mangled _LOAD_CHARA_sub__FiPPciPUii
 * @address 0x266790
 * @size 0x150
 */
int _LOAD_CHARA_sub(int stack_no, char **name, int scene_no, unsigned int *data, int flag);

/**
 * Loads a character into a scene character slot from a pack file; returns non-zero on success.
 *
 * @mangled _LOAD_CHARA_sub__FiPPciPUi
 * @address 0x2668E0
 * @size 0x10
 */
int _LOAD_CHARA_sub(int stack_no, char **name, int scene_no, unsigned int *data);

/**
 * Loads a motion file for a scene character; returns non-zero on success.
 *
 * @mangled _LOAD_MOTION_sub__FiPciPUi
 * @address 0x267030
 * @size 0x120
 */
int _LOAD_MOTION_sub(int stack_no, char *name, int scene_no, unsigned int *data);

/**
 * Returns the configuration setting that turns movie captions off.
 *
 * @mangled GetConfigCaptionOff__Fv
 * @address 0x268110
 * @size 0x50
 */
int GetConfigCaptionOff();

/**
 * Plays a movie file, drawing the event's captions over it; returns non-zero once it has played.
 *
 * @mangled LoadMovie__FPcP9mgCMemoryb
 * @address 0x268160
 * @size 0x8A0
 */
int LoadMovie(char *name, mgCMemory *memory, bool skip);

/**
 * Loads a message file into a message window; returns non-zero on success.
 *
 * @mangled _LOAD_MES_sub__FPciP6ClsMes
 * @address 0x271400
 * @size 0x100
 */
int _LOAD_MES_sub(char *name, int no, ClsMes *mes);

/**
 * Opens a voice stream from a voice pack; returns 1.
 *
 * @mangled CommandStreamOpenFromFPL__FiPcPc
 * @address 0x276B20
 * @size 0xC0
 */
int CommandStreamOpenFromFPL(int port, char *pack, char *name);

/**
 * Opens a voice stream from a file; returns 1.
 *
 * @mangled CommandStreamOpen__FiPc
 * @address 0x276BE0
 * @size 0x70
 */
int CommandStreamOpen(int port, char *name);

/**
 * Writes the name of the voice pack holding a voice number; returns 1, or 0 when no pack holds it.
 *
 * @mangled VpkFileNameFromVoiceNo__FPci
 * @address 0x276C50
 * @size 0x150
 */
int VpkFileNameFromVoiceNo(char *name, int voice_no);

/**
 * Plays the open voice stream at a volume, lowered by the reverb depth; returns 1.
 *
 * @mangled CommandStreamPlay__Fii
 * @address 0x276EC0
 * @size 0xE0
 */
int CommandStreamPlay(int port, int volume);

/**
 * Builds the path of a voice stream file without opening it; returns 1.
 *
 * @mangled CommandStreamOpen2__FiPc
 * @address 0x2778A0
 * @size 0x50
 */
int CommandStreamOpen2(int port, char *name);

/**
 * Gives an event script interpreter the table of event external functions.
 *
 * @mangled SetEventFunc__FP10CRunScript
 * @address 0x281920
 * @size 0x190
 */
void SetEventFunc(CRunScript *script);

class CCameraControl;

int GetArgInt(ARG_DATA *arg);
float GetArgFloat(ARG_DATA *arg);
char *GetArgString(ARG_DATA *arg);
void GetArgVector(float *out, ARG_DATA *arg);
void FileNameConvLanguage(char *name);
