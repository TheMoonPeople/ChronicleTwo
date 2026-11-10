#pragma once
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

struct CSceneEventData {
    CFuncPoint::EventData event{};       /**< Settings of the selected event point. */
    sceVu0FVECTOR         position{};    /**< Position of the event point or game object. */
    sceVu0FVECTOR         rotation{};    /**< Rotation of the event point. */
    sceVu0FVECTOR         scale{};       /**< Scale of the event point. */
    MapEventInfo          map_event{};   /**< Placement and identity of the map event. */
    int                   chara_no{};    /**< Character number of the villager. */
    int                   chara_slot{};  /**< Scene character slot of the villager. */
    int                   gameobj_no{};  /**< Game object position within its map entry. */
    int                   villager_id{}; /**< Villager selected for an edit event. */
};

STATIC_ASSERT(sizeof(CSceneEventData) == 0xD0);
