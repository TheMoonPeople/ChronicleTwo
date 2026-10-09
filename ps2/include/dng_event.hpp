#pragma once

#include "common.h"

/**
 *
 * A dungeon event vector viewed as floats or a quadword.
 *
 */
union DngEventVector {
    float     f[4]; /**< Four floating point components. */
    u_long128 qw;   /**< The same components as one quadword. */
};

#include <libvu0.h>

#include "character.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "object.hpp"

/**
 * @file
 * Declares the dungeon's floor events: the episode title, the queued message window, the red
 * target marker, the geostone, the random circles and the treasure boxes, and the functions that
 * load a floor and place its boxes, monsters and circles.
 */

class CAutoMapGen;
class CColFrame;
class CMapParts;
class CMiniMapSymbol;
class ClsMes;
class mgCFrame;
class mgCMemory;
struct CCPoly;

/**
 *
 * Stages of the episode title shown when a floor starts.
 *
 */
enum EpisodeTitleState {
    EPISODE_TITLE_OFF = 0,      /**< The title is not shown. */
    EPISODE_TITLE_FADE_IN = 1,  /**< The frame fades in and the title slides into place. */
    EPISODE_TITLE_HOLD = 2,     /**< The title stays on screen for a while. */
    EPISODE_TITLE_FADE_OUT = 3, /**< The title and its frame fade out. */
};

/**
 *
 * States of a treasure box slot, as CTreasureBox::state holds them.
 *
 */
enum TreasureBoxState {
    TREASURE_BOX_STATE_NONE = 0,     /**< The slot holds no box. */
    TREASURE_BOX_STATE_UNOPENED = 1, /**< The box waits to be opened, and shows on the mini map. */
    TREASURE_BOX_MAX = 24,
};

/**
 *
 * Bits of CTreasureBox::flags that describe a treasure box.
 *
 */
enum TreasureBoxFlag {
    TREASURE_BOX_FLAG_TWO_ITEMS = 0x80, /**< The box holds a second item. */
    TREASURE_BOX_FLAG_MIMIC = 0x100,    /**< The box is a mimic; its first item is the monster. */
};

/**
 *
 * Places that GetDungeonEventPoint can find on the floor.
 *
 */
enum DungeonEventPointKind {
    DUNGEON_EVENT_POINT_PLAYER = 0,       /**< Grid cell that the player stands in. */
    DUNGEON_EVENT_POINT_TREASURE_BOX = 1, /**< Treasure box that the player stands at. */
    DUNGEON_EVENT_POINT_WAY_20 = 2,       /**< First of the "way32" to "way35" parts on the map. */
    DUNGEON_EVENT_POINT_WAY_24 = 3,       /**< First of the "way36" to "way51" parts on the map. */
};

/**
 *
 * One item that a group of the treasure box table can give.
 *
 */
struct TRESURE_BOX_ITEM {
    s32 item_no; /**< Item that the box holds. */
    s32 rank;    /**< Value of the item, compared against the rank that a box asks for. */
    s32 num;     /**< Number of the item that the box holds. */
};

STATIC_ASSERT(sizeof(TRESURE_BOX_ITEM) == 0xC);

/**
 *
 * One group of items in the treasure box table, which floors draw their items from.
 *
 */
struct TRESURE_BOX_GROUP {
    s32              group_id; /**< Identifier that the floors use to name the group. */
    s32              item_num; /**< Number of entries of item in use. */
    TRESURE_BOX_ITEM item[96]; /**< Items of the group. */
};

STATIC_ASSERT(sizeof(TRESURE_BOX_GROUP) == 0x488);

/**
 *
 * Groups of items that one floor draws its treasure box items from.
 *
 */
struct TRESURE_BOX_FLOOR {
    s32 group_num;    /**< Number of entries of group_id in use. */
    s32 group_id[64]; /**< Identifiers of the groups that the floor draws from. */
};

STATIC_ASSERT(sizeof(TRESURE_BOX_FLOOR) == 0x104);

/**
 *
 * Treasure box table of a dungeon, read from its tbox_d0<n>.cfg script.
 *
 */
struct TRESURE_BOX_FLOOR_INFO {
    s16               rank_max;    /**< Highest item rank among the groups of the current floor. */
    s16               rank_min;    /**< Lowest item rank among the groups of the current floor. */
    TRESURE_BOX_GROUP group[64];   /**< Item groups of the dungeon. */
    s32               group_num;   /**< Number of entries of group in use. */
    TRESURE_BOX_FLOOR floor[128];  /**< Groups that each floor draws from. */
    s32               floor_start; /**< Value that the script's FLOOR_START tag gives. */
};

STATIC_ASSERT(sizeof(TRESURE_BOX_FLOOR_INFO) == 0x1A40C);

/**
 *
 * Name of the floor shown in a frame at the bottom of the screen when a floor starts.
 *
 */
class CStartupEpisodeTitle {
public:
    s16     state;  /**< Stage of the title, an ::EpisodeTitleState. */
    s16     wait;   /**< Frames the title stays on screen before it fades out. */
    float   alpha;  /**< Opacity of the frame, from 0 to 1. */
    float   reveal; /**< How much of the title's backing is uncovered, from 0 to 1. */
    float   slide;  /**< How far the title has slid into place, from 0 to 1. */
    s16     width;  /**< Width of the frame, at least 154 pixels. */
    ClsMes *mes;    /**< Message window that writes the title. */

    /**
     *
     * Draws the frame and the title.
     *
     * @mangled DrawEpisode__20CStartupEpisodeTitleFii
     * @address 0x28ED90
     * @size 0x2C0
     */
    void DrawEpisode(int mes_tex_block, int frame_tex_block);

    /**
     *
     * Starts the title of the current floor, or closes the title.
     *
     * @mangled Switch__20CStartupEpisodeTitleFi
     * @address 0x28F050
     * @size 0x160
     */
    void Switch(int on);

    /**
     *
     * Advances the fades of the title and places its message window.
     *
     * @mangled Step__20CStartupEpisodeTitleFv
     * @address 0x28F1B0
     * @size 0x2B0
     */
    void Step();

    /**
     *
     * Hides the title and detaches its message window.
     *
     * @mangled Initialize__20CStartupEpisodeTitleFv
     * @address 0x28F460
     * @size 0x10
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CStartupEpisodeTitle) == 0x18);

/**
 *
 * One message waiting to be shown in the dungeon's message window.
 *
 */
struct MESSAGE_TASK {
    char         *message;   /**< Text to show, pointing at text; NULL while the slot is free. */
    char          text[128]; /**< Copy of the text. */
    s8            priority;  /**< Messages with a lower value are shown first. */
    s16           time;      /**< Frames the message has left on screen. */
    s16           count;     /**< Frames the message has been on screen. */
    s16           slot;      /**< Window position slot given to the message window. */
    MESSAGE_TASK *next;      /**< Next message in the queue. */
};

STATIC_ASSERT(sizeof(MESSAGE_TASK) == 0x90);

/**
 *
 * Queue of short messages that the dungeon shows one after another, in order of priority.
 *
 */
class MessageTaskManager {
public:
    u32           flag;    /**< Holds the queue back while bit 0 is set. */
    ClsMes       *mes;     /**< Message window that shows the messages. */
    MESSAGE_TASK  task[6]; /**< Message slots. */
    MESSAGE_TASK *top;     /**< Message shown now, at the head of the queue. */

    /**
     *
     * Draws the message window.
     *
     * @mangled Draw__18MessageTaskManagerFv
     * @address 0x28F470
     * @size 0x30
     */
    void Draw();

    /**
     *
     * Shows the message at the head of the queue and moves on to the next when its time is up.
     *
     * @mangled Step__18MessageTaskManagerFv
     * @address 0x28F4A0
     * @size 0x100
     */
    void Step();

    /**
     *
     * Queues a message in a free slot, after every message of the same or a lower priority value.
     *
     * @mangled Print__18MessageTaskManagerFPciii
     * @address 0x28F5A0
     * @size 0x130
     */
    void Print(char *message, int time, int slot, int priority);

    /**
     *
     * Closes the message window and empties the queue.
     *
     * @mangled Clear__18MessageTaskManagerFv
     * @address 0x28F6D0
     * @size 0xA0
     */
    void Clear();

    /**
     *
     * Empties every slot and detaches the message window.
     *
     * @mangled Initialize__18MessageTaskManagerFv
     * @address 0x28F770
     * @size 0x90
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(MessageTaskManager) == 0x36C);

/**
 *
 * Red marker that bobs over a target for the frames in which the game asks for it.
 *
 */
class CRedMarkModel : public CObjectFrame {
public:
    s32   draw_request; /**< Draws the marker on the next draw while nonzero; each draw clears it. */
    float angle;        /**< Angle, in radians, that makes the marker bob. */

    /**
     *
     * Clears the draw request, the bob and the frame.
     *
     * @mangled Initialize__13CRedMarkModelFv
     * @address 0x1CF560
     * @size 0x10
     */
    virtual void Initialize();

    /**
     *
     * Draws the marker raised by its bob when a draw was requested.
     *
     * @mangled Draw__13CRedMarkModelFv
     * @address 0x28F800
     * @size 0xA0
     */
    virtual void Draw();

    /**
     *
     * Advances the bob.
     *
     * @mangled Step__13CRedMarkModelFv
     * @address 0x28F8A0
     * @size 0x50
     */
    virtual void Step();
};

STATIC_ASSERT(sizeof(CRedMarkModel) == 0x90);

/**
 *
 * Geostone of the floor, which floats above the ground until the player takes it.
 *
 */
class CGeoStone : public CCharacter2 {
public:
    s32   flag;  /**< Nonzero while the geostone is on the floor. */
    float angle; /**< Angle, in radians, that makes the geostone float up and down. */
    s32   anime; /**< Makes the geostone float and hides it beyond 1000 units while nonzero. */

    /**
     *
     * Draws the geostone, raised by its float, when the player is near.
     *
     * @mangled GeoDraw__9CGeoStoneFPf
     * @address 0x28F8F0
     * @size 0xF0
     */
    void GeoDraw(float *view_pos);

    /**
     *
     * Puts the geostone's symbol on the mini map.
     *
     * @mangled DrawMiniMapSymbol__9CGeoStoneFP14CMiniMapSymbol
     * @address 0x28F9E0
     * @size 0x50
     */
    void DrawMiniMapSymbol(CMiniMapSymbol *symbol_drawer);

    /**
     *
     * Puts the geostone on the floor or takes it away, moving the automap's geostone part out of
     * sight when it is taken away.
     *
     * @mangled SetFlag__9CGeoStoneFi
     * @address 0x28FA30
     * @size 0x60
     */
    void SetFlag(int flag);

    /**
     *
     * Animates the geostone and advances its float.
     *
     * @mangled GeoStep__9CGeoStoneFv
     * @address 0x28FA90
     * @size 0x80
     */
    void GeoStep();

    /**
     *
     * Tells whether a position is within 30 units of the geostone.
     *
     * @mangled CheckEvent__9CGeoStoneFPf
     * @address 0x28FB10
     * @size 0x80
     */
    int CheckEvent(float *pos);

    /**
     *
     * Puts the character back to its initial state and takes the geostone off the floor.
     *
     * @mangled Initialize__9CGeoStoneFv
     * @address 0x28FB90
     * @size 0x30
     */
    virtual void Initialize();
};

STATIC_ASSERT(sizeof(CGeoStone) == 0x670);

/**
 *
 * Random circles of the floor: up to three places that start an event when the player steps
 * onto them.
 *
 */
class CRandomCircle {
public:
    sceVu0FVECTOR pos[3];    /**< World position of each circle. */
    s32           active[3]; /**< Nonzero for each circle that is on the floor. */
    s32           hit;       /**< Circle that the player last stood on, or -1 for none. */
    CCharacter2   model;     /**< Model drawn at each circle. */

    /**
     *
     * Draws each circle within 1000 units of the player.
     *
     * @mangled Draw__13CRandomCircleFPf
     * @address 0x28FBC0
     * @size 0xF0
     */
    void Draw(float *view_pos);

    /**
     *
     * Animates the circles' model.
     *
     * @mangled Step__13CRandomCircleFv
     * @address 0x28FCB0
     * @size 0x20
     */
    void Step();

    /**
     *
     * Puts each circle's symbol on the mini map.
     *
     * @mangled DrawSymbol__13CRandomCircleFP14CMiniMapSymbol
     * @address 0x28FCD0
     * @size 0x90
     */
    void DrawSymbol(CMiniMapSymbol *mini_map);

    /**
     *
     * Tells whether a position is at least a distance away from every circle.
     *
     * @mangled CheckArea__13CRandomCircleFPff
     * @address 0x28FD60
     * @size 0xB0
     */
    int CheckArea(float *pos, float radius);

    /**
     *
     * Gets the position of a circle, or of the circle that the player last stood on when the
     * index is -1; returns 0 when there is no such circle.
     *
     * @mangled GetPosition__13CRandomCircleFPfi
     * @address 0x28FE10
     * @size 0x80
     */
    int GetPosition(float *out_pos, int index);

    /**
     *
     * Finds the circle within 20 units of a position and remembers it, or gives -1.
     *
     * @mangled CheckEvent__13CRandomCircleFPf
     * @address 0x28FE90
     * @size 0xB0
     */
    int CheckEvent(float *pos);

    /**
     *
     * Puts a circle on a free slot and gives its index, or -1 when every slot is in use.
     *
     * @mangled SetCircle__13CRandomCircleFPf
     * @address 0x28FF40
     * @size 0x90
     */
    int SetCircle(float *pos);

    /**
     *
     * Takes every circle off the floor.
     *
     * @mangled Clear__13CRandomCircleFv
     * @address 0x28FFD0
     * @size 0x20
     */
    void Clear();

    /**
     *
     * Puts the model back to its initial state and takes every circle off the floor.
     *
     * @mangled Initialize__13CRandomCircleFv
     * @address 0x28FFF0
     * @size 0x50
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CRandomCircle) == 0x6A0);

/**
 *
 * One treasure box of the floor, or a mimic that looks like one.
 *
 */
class CTreasureBox : public mgCObject {
public:
    float        lid_open;  /**< Opening of the lid; each 1.0 turns it 45 degrees. */
    s8           state;     /**< State of the slot, a ::TreasureBoxState. */
    s32          flags;     /**< Description of the box, a combination of ::TreasureBoxFlag bits. */
    s16          item[2];   /**< Items that the box holds, or the monster of a mimic; -1 for none. */
    s16          num[2];    /**< Number of each item. */
    mgCFrame    *lid_frame; /**< Lid of the box model ("tbox1"). */
    mgCFrame    *frame;     /**< Frame of the box model. */
    CCharacter2 *model;     /**< Box model, shared by every box. */

    /**
     *
     * Puts the box back to its initial state, with an empty slot.
     *
     * @mangled Initialize__12CTreasureBoxFv
     * @address 0x1BC6F0
     * @size 0x20
     */
    virtual void Initialize()
#ifndef DNG_DEBUG_SOURCE
    {
        state = TREASURE_BOX_STATE_NONE;
        lid_open = 0.0f;
        flags = 1;
    }
#else
        ;
#endif

    /**
     *
     * Draws the box with its lid opened, when the camera is within 1000 units.
     *
     * @mangled Draw__12CTreasureBoxFPf
     * @address 0x290040
     * @size 0x130
     */
    void Draw(float *view_pos);

    /**
     *
     * Draws the box's shadow cast by a light, when the camera is within 1000 units.
     *
     * @mangled DrawShadow__12CTreasureBoxFPfPf
     * @address 0x290170
     * @size 0x130
     */
    void DrawShadow(float *view_pos, float *light_dir);
};

STATIC_ASSERT(sizeof(CTreasureBox) == 0x70);

/**
 *
 * Treasure boxes of the floor, sharing one model and one collision model.
 *
 */
class CTreasureBoxManager {
public:
    s32          tex_block; /**< Texture block of the box model. */
    CTreasureBox box[TREASURE_BOX_MAX];   /**< Box slots. */
    s32          unk_A90;
    CCharacter2 *model;     /**< Box model. */
    CColFrame   *col_frame; /**< Collision model of a box ("tbox_a.mds"). */
    s32          near_box;  /**< Box that the player last stood at, or -1 for none. */

    void Initialize() {
        for (int i = 0; i < TREASURE_BOX_MAX; i++) {
            box[i].Initialize();
        }

        unk_A90 = 0;
        model = NULL;
        col_frame = NULL;
        near_box = -1;
    }

    /**
     *
     * Gives every box the box model and its lid.
     *
     * @mangled SetLargeModel__19CTreasureBoxManagerFP11CCharacter2i
     * @address 0x2902A0
     * @size 0xD0
     */
    void SetLargeModel(CCharacter2 *model, int value);

    /**
     *
     * Loads the collision model of a box from a pack file.
     *
     * @mangled SetCollisionModel__19CTreasureBoxManagerFPUiP9mgCMemory
     * @address 0x290370
     * @size 0x50
     */
    void SetCollisionModel(unsigned int *pack, mgCMemory *memory);

    /**
     *
     * Puts a box in a slot, or in the first free slot when the index is -1.
     *
     * @mangled PutTreasureBox__19CTreasureBoxManagerFiPffiiiii
     * @address 0x2903C0
     * @size 0x120
     */
    void PutTreasureBox(int index, float *pos, float rot_y, int flags, int item0, int num0, int item1, int num1);

    /**
     *
     * Tells whether a position is at least a distance away from every box.
     *
     * @mangled CheckArea__19CTreasureBoxManagerFPff
     * @address 0x2904E0
     * @size 0xB0
     */
    int CheckArea(float *pos, float radius);

    /**
     *
     * Puts the symbol of each unopened box on the mini map.
     *
     * @mangled DrawMiniMapSymbol__19CTreasureBoxManagerFP14CMiniMapSymbol
     * @address 0x290590
     * @size 0x90
     */
    void DrawMiniMapSymbol(CMiniMapSymbol *symbol_drawer);

    /**
     *
     * Draws every box.
     *
     * @mangled Draw__19CTreasureBoxManagerFPf
     * @address 0x290620
     * @size 0x80
     */
    void Draw(float *view_pos);

    /**
     *
     * Draws the shadow of every box, cast by the scene's main light.
     *
     * @mangled DrawShadow__19CTreasureBoxManagerFPf
     * @address 0x2906A0
     * @size 0xF0
     */
    void DrawShadow(float *view_pos);

    /**
     *
     * Gathers the collision polygons of the boxes within 40 units of a position, and gives their
     * number.
     *
     * @mangled PickupCollision__19CTreasureBoxManagerFPfP6CCPoly9mgVu0FBOXi
     * @address 0x290790
     * @size 0x150
     */
    int PickupCollision(float *pos, CCPoly *poly, mgVu0FBOX box, int flag);

    /**
     *
     * Counts the unopened mimics.
     *
     * @mangled MimicCount__19CTreasureBoxManagerFv
     * @address 0x2908E0
     * @size 0x50
     */
    int MimicCount();

    /**
     *
     * Finds the nearest unopened box within a distance of a position and remembers it, or
     * gives -1.
     *
     * @mangled CheckEvent__19CTreasureBoxManagerFPff
     * @address 0x290930
     * @size 0xE0
     */
    int CheckEvent(float *pos, float dist);
};

STATIC_ASSERT(sizeof(CTreasureBoxManager) == 0xAA0);

/**
 *
 * Gives the item that opens a dungeon's gate on a floor.
 *
 * @mangled GetGateKeyIndex__Fii
 * @address 0x290A10
 * @size 0x40
 */
int GetGateKeyIndex(int floor, int level);

/**
 *
 * Gives the item that opens a dungeon's key door on a floor.
 *
 * @mangled GetKeyDoorIndex__Fii
 * @address 0x290A50
 * @size 0x40
 */
int GetKeyDoorIndex(int floor, int level);

/**
 *
 * Shows the weapon form that suits the time band when the player character holds one of the
 * two changing weapons; gives 1 or 0 for the form shown and -1 when neither is held.
 *
 * @mangled Lamb2WolfManager__Fv
 * @address 0x290A90
 * @size 0x1A0
 */
int Lamb2WolfManager();

/**
 *
 * Does nothing.
 *
 * @mangled LoopSoundManager__Fi
 * @address 0x290C30
 * @size 0x10
 */
void LoopSoundManager(int sound_id);

/**
 *
 * Updates the battle music of the area and the warning sound of the player's status.
 *
 * @mangled BattleSoundManager__Fv
 * @address 0x290C40
 * @size 0x30
 */
void BattleSoundManager();

/**
 *
 * Runs a debug command from an event script; command 0 restores the player's health.
 *
 * @mangled ScriptDebugCommand__Fi
 * @address 0x291050
 * @size 0x60
 */
void ScriptDebugCommand(int command);

/**
 *
 * Swaps the first eight light sets of the current map with the eight that follow them.
 *
 * @mangled XChgMapLighting__Fv
 * @address 0x2910B0
 * @size 0xC0
 */
void XChgMapLighting();

/**
 *
 * Gives the angle, in radians, of one of the four map part rotations, or 0 when the rotation
 * is out of range.
 *
 * @mangled XChgMapRotation__Fi
 * @address 0x291170
 * @size 0x40
 */
float XChgMapRotation(int index);

/**
 *
 * Finds the first "way" part of a kind placed on the current map and its angle; gives 1 when
 * one is found.
 *
 * @mangled SearchMapEventParts__FiPP9CMapPartsPfi
 * @address 0x2911B0
 * @size 0x150
 */
int SearchMapEventParts(int kind, CMapParts **out_parts, float *rotation, int max);

/**
 *
 * Picks a random flat place on the generated floor; gives 0 when none is found.
 *
 * @mangled SearchMapFlatPosition__FPfP11CAutoMapGen
 * @address 0x291300
 * @size 0x410
 */
int SearchMapFlatPosition(sceVu0FVECTOR out_pos, CAutoMapGen *map_gen);

/**
 *
 * Finds a place on the floor and the angle that faces it, by a ::DungeonEventPointKind; gives
 * 0 when there is none.
 *
 * @mangled GetDungeonEventPoint__FPfPfi
 * @address 0x291710
 * @size 0x2E0
 */
int GetDungeonEventPoint(float *out_pos, float *out_rot, int kind);

/**
 *
 * Reads a dungeon's treasure box table from its script.
 *
 * @mangled CreatTresuarBoxInfo__FP22TRESURE_BOX_FLOOR_INFOPci
 * @address 0x291D50
 * @size 0xB0
 */
void CreatTresuarBoxInfo(TRESURE_BOX_FLOOR_INFO *table, char *script, int length);

/**
 *
 * Finds the first of sixteen directions around a position in which no map polygon blocks the
 * view, and gives its angle in radians.
 *
 * @mangled ScanEyePoint__FPf
 * @address 0x292110
 * @size 0x1E0
 */
float ScanEyePoint(float *pos);

/**
 *
 * Puts a treasure box with an item on the floor.
 *
 * @mangled AutoSetTreasureBox__FiPff
 * @address 0x2922F0
 * @size 0x30
 */
void AutoSetTreasureBox(int id, float *pos, float power);

/**
 *
 * Places the floor's treasure boxes, mimics, random circles, geostone, random stones and key
 * door box at random places on the generated floor.
 *
 * @mangled AutoSetTreasureBox__Fv
 * @address 0x292320
 * @size 0xA20
 */
void AutoSetTreasureBox();

/**
 *
 * Puts the monsters that LoadMonsterFile listed for the current floor at random places on the
 * generated floor, giving the first one the floor's gate key.
 *
 * @mangled AutoSetMonster__Fv
 * @address 0x292F30
 * @size 0x1E0
 */
void AutoSetMonster();

/**
 *
 * Puts a monster on the floor.
 *
 * @mangled AutoSetMonster__FiPfPfi
 * @address 0x293110
 * @size 0x80
 */
void AutoSetMonster(int base_index, float *pos, float *direction, int option);

/**
 *
 * Does nothing.
 *
 * @mangled DungeonFloorInit__Fv
 * @address 0x293190
 * @size 0x10
 */
void DungeonFloorInit();

/**
 *
 * Does nothing.
 *
 * @mangled DungeonFloorFinish__Fv
 * @address 0x2931A0
 * @size 0x10
 */
void DungeonFloorFinish();

/**
 *
 * Loads a dungeon map and everything on it, and builds a random floor from a room
 * configuration when one is named.
 *
 * @mangled LoadDungeonMapFile__FPcPci
 * @address 0x2931B0
 * @size 0x9B0
 */
void LoadDungeonMapFile(char *map_name, char *cfg_name, int gen_flag);

/**
 *
 * Opens the mini map's door at a position and updates the navigation from it.
 *
 * @mangled MinimapDoorEnable__FPf
 * @address 0x293B60
 * @size 0x50
 */
void MinimapDoorEnable(float *pos);

/**
 *
 * Resets the monster manager and loads the monsters that the dungeon's monster script lists
 * for the current floor.
 *
 * @mangled LoadMonsterFile__Fv
 * @address 0x293BB0
 * @size 0x1E0
 */
void LoadMonsterFile();

/**
 *
 * Loads one monster, first resetting the monster manager and its memory when asked.
 *
 * @mangled LoadMonsterFile__Fii
 * @address 0x293D90
 * @size 0x130
 */
void LoadMonsterFile(int monster_id, int initialize);

/**
 *
 * Sounds the low-health warning while dungeon combat is active.
 *
 * @mangled StatusWarningSnd__Fv
 * @address 0x290C70
 * @size 0x100
 */
void StatusWarningSnd();

/**
 *
 * Adjusts the battle music and player battle state as monsters approach.
 *
 * @mangled BattleAreaBGMCtrl__Fv
 * @address 0x290D70
 * @size 0x2DC
 */
void BattleAreaBGMCtrl();

/**
 *
 * Finds the minimum and maximum item ranks available on a dungeon floor.
 *
 * @mangled PickupRandomItemCheckMax__FP22TRESURE_BOX_FLOOR_INFOi
 * @address 0x291E00
 * @size 0xE0
 */
void PickupRandomItemCheckMax(TRESURE_BOX_FLOOR_INFO *table, int floor_index);

/**
 *
 * Selects a treasure item from the floor groups near the requested rank.
 *
 * @mangled PickupRandomItem__FP22TRESURE_BOX_FLOOR_INFOii
 * @address 0x291EE0
 * @size 0x14C
 */
TRESURE_BOX_ITEM *PickupRandomItem(TRESURE_BOX_FLOOR_INFO *table, int floor_index, int value);

/**
 *
 * Checks whether a dungeon object can be placed clear of chests, markers, and stones.
 *
 * @mangled CheckObjectPutArea__FPf
 * @address 0x292030
 * @size 0xE0
 */
int CheckObjectPutArea(float *pos);

/**
 *
 * Runs the script that defines monster placement for a dungeon floor.
 *
 * @mangled CreatMonsterFloorInfo__FPci
 * @address 0x292EC0
 * @size 0x64
 */
void CreatMonsterFloorInfo(char *script, int length);
