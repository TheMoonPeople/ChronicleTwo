#pragma once
#include <cstring>

#include "common.h"

#include <libvu0.h>

#include "map.hpp"
#include "mapload.hpp"

/**
 * @file
 * Declares the description of an event that the player has reached in a
 * scene: the event point of a map, a villager to talk to or a game object,
 * which a scene keeps while it runs the event and hands to the event editor.
 */

/**
 *
 * Event the player has reached, with the settings, placement and owner of the point that starts it.
 *
 */
struct EventFloat2 { float v[2]; };
struct EventFloat4 { float v[4]; };
struct EventVector2 { u_long128 v[2]; };
struct EventVector4 { u_long128 v[4]; };

#pragma push
#pragma cpp_extensions on
struct CSceneEventData {
    CSceneEventData() { memset(this, 0, sizeof(*this)); }
    union {
        struct {
    CFuncPoint::EventData event;      /**< Settings of the event point, or the event number of a villager or game object. */
    sceVu0FVECTOR         position;   /**< Position of the event point or game object. */
    sceVu0FVECTOR         rotation;   /**< Rotation of the event point, zero for a game object. */
    sceVu0FVECTOR         scale;      /**< Scale of the event point. */
    MapEventInfo          map_event;  /**< Event point found on a map, with the matrix that places it. */
            int chara_no; /**< Character number of the villager talked to. */
            int chara_slot; /**< Scene character slot of the villager talked to. */
            int gameobj_no; /**< Index of the game object position within its map's entry. */
            int unk_cc;
};
        struct {
            EventFloat4 head;
            EventFloat4 group_1;
            EventFloat2 group_2;
            EventFloat4 group_3 __attribute__((aligned(16)));
            EventFloat4 group_4;
            EventFloat4 group_5;
            EventVector4 vectors_a;
            EventVector2 vectors_b;
        };
    };
};
#pragma pop

STATIC_ASSERT(sizeof(CSceneEventData) == 0xD0);
