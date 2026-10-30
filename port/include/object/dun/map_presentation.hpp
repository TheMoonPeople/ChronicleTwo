#pragma once

#include <optional>

#include "mg_tanime.hpp"

struct DNGMAP_ROOM_INFO;

/**
 * The picture CDngFreeMap::DrawRoomOne puts for a room at put position (x, y) on dungeon dng_no's floor map, or
 * nothing when it culls the room past the right or bottom edge given.
 */
std::optional<mgRect<float>> PortDngRoomPicture(int dng_no, const DNGMAP_ROOM_INFO &room, float x, float y, float right,
                                                float bottom);
