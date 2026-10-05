#pragma once

#include "common.h"

#include <libvu0.h>

#include "sceneevent.hpp"

/**
 * @file
 * Declares the events the town editor (Georama) runs when the player
 * reaches an event point of the town: walking through a door, entering a
 * placed house, opening a treasure box and reading a book, together with
 * the script functions that load the villagers shown in the town.
 */

class CScene;
struct RS_STACKDATA;

/**
 *
 * Progress of an edit event, as CEditEvent::state holds it.
 *
 */
enum EditEventState {
    EDIT_EVENT_STATE_IDLE = 0,    /**< No event is held. */
    EDIT_EVENT_STATE_RUNNING = 1, /**< The event is being stepped. */
    EDIT_EVENT_STATE_UNK_2 = 2,   /**< Refused by CEditEvent::StartEvent like a running event; never set by this unit. */
    EDIT_EVENT_STATE_END = 3,     /**< The event has finished and waits to be reset. */
};

/**
 *
 * Kinds of edit event, chosen from the flags of the event point, as CEditEvent::type holds them.
 *
 */
enum EditEventType {
    EDIT_EVENT_TYPE_NONE = -1,        /**< The event point is of no kind the editor handles. */
    EDIT_EVENT_TYPE_HOUSE_DOOR = 0,   /**< Door of a placed part ("ed_door"), which first opens the part's menu. */
    EDIT_EVENT_TYPE_DOOR = 1,         /**< Door the player walks through to another map or an event. */
    EDIT_EVENT_TYPE_TREASURE_BOX = 2, /**< Treasure box the player opens. */
    EDIT_EVENT_TYPE_BOOK = 3,         /**< Book the player reads. */
};

/**
 *
 * What CEditEvent::Step asks the edit loop to do next.
 *
 */
enum EditEventResult {
    EDIT_EVENT_RESULT_IDLE = -1,        /**< No event is running. */
    EDIT_EVENT_RESULT_CONTINUE = 0,     /**< The event goes on next frame. */
    EDIT_EVENT_RESULT_END = 1,          /**< The event has finished. */
    EDIT_EVENT_RESULT_ENTER = 2,        /**< Enter the interior named by CEditEvent::map_name. */
    EDIT_EVENT_RESULT_EXIT = 3,         /**< Leave the interior back to the town. */
    EDIT_EVENT_RESULT_ENTER_HOUSE = 4,  /**< Enter the villager's house named by CEditEvent::map_name. */
    EDIT_EVENT_RESULT_MENU = 5,         /**< Open the menu of the placed part; the event keeps running. */
};

/**
 *
 * Steps of an EDIT_EVENT_TYPE_HOUSE_DOOR event, as CEditEvent::step holds them.
 *
 */
enum EditHouseDoorStep {
    EDIT_HOUSE_DOOR_STEP_OPEN_MENU = 0, /**< Fills the menu arguments and asks for the part's menu. */
    EDIT_HOUSE_DOOR_STEP_MENU_END = 1,  /**< Acts on how the menu ended, turning into a door event when the house is entered. */
    EDIT_HOUSE_DOOR_STEP_WAIT = 2,      /**< Waits for the fade, reloading the town's villager if one was asked for. */
};

/**
 *
 * Steps of an EDIT_EVENT_TYPE_DOOR event, as CEditEvent::step holds them.
 *
 */
enum EditDoorStep {
    EDIT_DOOR_STEP_START = 0,    /**< Picks the destination, turns the camera and records where the player stands. */
    EDIT_DOOR_STEP_APPROACH = 1, /**< Walks the player to the door and turns them to face it. */
    EDIT_DOOR_STEP_OPEN = 2,     /**< Opens the door and fades out, or plays the motion of a closed door. */
    EDIT_DOOR_STEP_LEAVE = 3,    /**< Runs the door's event or asks for the map jump. */
    EDIT_DOOR_STEP_RETURN = 4,   /**< Walks the player back from a closed door. */
    EDIT_DOOR_STEP_WAIT = 5,     /**< Waits for the player's motion to end. */
};

/**
 *
 * Steps of an EDIT_EVENT_TYPE_TREASURE_BOX event, as CEditEvent::step holds them.
 *
 */
enum EditTreasureBoxStep {
    EDIT_TREASURE_BOX_STEP_START = 0,        /**< Checks the item fits and starts opening the box. */
    EDIT_TREASURE_BOX_STEP_OPEN = 1,         /**< Waits while the box starts to open. */
    EDIT_TREASURE_BOX_STEP_LIFT = 2,         /**< Moves the lid and shows the item's message once it is open. */
    EDIT_TREASURE_BOX_STEP_WAIT = 3,         /**< Waits before the message can be closed. */
    EDIT_TREASURE_BOX_STEP_MESSAGE = 4,      /**< Waits for a button to close the item's message. */
    EDIT_TREASURE_BOX_STEP_DELETE = 5,       /**< Removes the opened box from the map. */
    EDIT_TREASURE_BOX_STEP_FULL_MESSAGE = 6, /**< Waits for a button to close the message that the item cannot be carried. */
    EDIT_TREASURE_BOX_STEP_END = 7,          /**< Ends the event, leaving the box closed. */
};

/**
 *
 * Steps of an EDIT_EVENT_TYPE_BOOK event, as CEditEvent::step holds them.
 *
 */
enum EditBookStep {
    EDIT_BOOK_STEP_START = 0, /**< Opens the message window with the book's text. */
    EDIT_BOOK_STEP_READ = 1,  /**< Pages through the text as buttons are pressed. */
    EDIT_BOOK_STEP_DONE = 2,  /**< Text finished; moves on to closing. */
    EDIT_BOOK_STEP_CLOSE = 3, /**< Closes the message window and ends the event. */
};

/**
 *
 * Event the town editor runs when the player reaches an event point of the town.
 *
 */
class CEditEvent {
public:
    s32             count;          /**< Frames spent in the current step, or a countdown set by a step. */
    s32             state;          /**< Progress of the event, an EditEventState. */
    s32             step;           /**< Step of the event, of the enum for its type. */
    s32             unk_c;
    s32             type;           /**< Kind of event, an EditEventType. */
    s32             unk_14;
    s32             unk_18;
    s32             unk_1c;
    CSceneEventData data;           /**< Event point the event was started from. */
    float           projection;     /**< Projection distance to restore when the part's menu has closed. */
    s32             unk_f4;
    s32             unk_f8;
    s32             unk_fc;
    sceVu0FVECTOR   return_pos;     /**< Position the player stood at when a door event started. */
    sceVu0FVECTOR   return_rot;     /**< Rotation the player had when a door event started. */
    s32             reload_geo_npc; /**< Non-zero when the town's villager is reloaded after the part's menu closes. */
    s32             unk_124;
    char            map_name[0x20]; /**< Map a door leads to, with the villager's house suffix added for a house. */
    s32             door_se;        /**< Door sound played on opening the door, or -1 when none was played. */
    s32             unk_14c;

    /**
     * Creates an event with nothing running.
     */
    CEditEvent() { Reset(); }

    /**
     *
     * Clears the event so that no event is held.
     *
     * @mangled Reset__10CEditEventFv
     * @address 0x2F49B0
     * @size 0x30
     */
    void Reset();

    /**
     *
     * Starts the event for an event point; returns non-zero when the point is of a kind the editor handles.
     *
     * @mangled StartEvent__10CEditEventFP15CSceneEventData
     * @address 0x2F49E0
     * @size 0x200
     */
    int StartEvent(CSceneEventData *event_data);

    /**
     *
     * Steps the running event by one frame and returns an EditEventResult.
     *
     * @mangled Step__10CEditEventFP6CScene
     * @address 0x2F4BE0
     * @size 0xF60
     */
    int Step(CScene *scene);

    /**
     *
     * Draws the event, which has nothing of its own to draw; returns zero.
     *
     * @mangled Draw__10CEditEventFP6CScene
     * @address 0x2F5B40
     * @size 0x20
     */
    int Draw(CScene *scene);
};

STATIC_ASSERT(sizeof(CEditEvent) == 0x150);

/**
 *
 * Commands of the event script's Georama function, given as its first argument.
 *
 */
enum GeoramaFuncCommand {
    GEORAMA_FUNC_LOAD_INT_NPC = 1,        /**< Loads a villager into a scene character slot of an interior. */
    GEORAMA_FUNC_LOAD_GEO_NPC = 2,        /**< Loads the villager shown in the town. */
    GEORAMA_FUNC_CHECK_PLACE_BURN = 3,    /**< Returns whether a part that can burn is placed. */
    GEORAMA_FUNC_TEST = 999,              /**< Prints a warning that the test function was called. */
};

/**
 *
 * What the Georama script functions work on.
 *
 */
struct GeoFuncParam {
    CScene *scene; /**< Scene the functions act on. */
};

STATIC_ASSERT(sizeof(GeoFuncParam) == 0x4);

/**
 *
 * Runs a command of the event script's Georama function, a GeoramaFuncCommand, on the scene of a parameter set.
 *
 * @mangled GeoramaFunc__FP12GeoFuncParamP12RS_STACKDATAi
 * @address 0x2F5B60
 * @size 0xC0
 */
int GeoramaFunc(GeoFuncParam *param, RS_STACKDATA *args, int argc);

/**
 *
 * Moves the villager shown in the town to the "npc_pos" point of the part it lives in.
 *
 * @mangled GeoUpdateNpcPos__FP6CScene
 * @address 0x2F6140
 * @size 0x190
 */
void GeoUpdateNpcPos(CScene *scene);
