#pragma once

#include <array>
#include <string>
#include <vector>

// Plain typed configuration records handed to the native bridges appended to ps2 unit copies,
// which reach their units' file statics and types but not the JSON reader.

class mgCMemory;

/**
 * One prize of a fish prize group: its rate and the item and count of each of three ranks.
 */
struct NativeFishPrize {
    int                               rate;  /**< Rate the script gives the prize. */
    std::array<std::array<int, 2>, 3> ranks; /**< Item number and count of each rank. */
};

/**
 * One fish prize group.
 */
struct NativeFishPrizeGroup {
    int                          prize_count; /**< Prize records the group allocates. */
    std::array<int, 8>           rates;       /**< Rates the script gives the group. */
    std::vector<NativeFishPrize> prizes;      /**< Prizes in script order. */
};

/**
 * Typed contents of a fish_prizes document.
 */
struct NativeFishPrizes {
    int                               count;  /**< Groups allocated. */
    std::vector<NativeFishPrizeGroup> groups; /**< Groups in script order. */
};

/**
 * Builds the tournament prize table from a parsed fish_prizes document in the given memory.
 */
void PortApplyFishPrizes(const NativeFishPrizes &prizes, mgCMemory *pool);

/**
 * One fish of the development gyorace configuration.
 */
struct NativeDebugRaceFish {
    std::string name;      /**< Fish name, CP932. */
    bool        has_name;  /**< Whether the name operand was a string. */
    int         item;      /**< Item number of the fish. */
    int         color;     /**< Colour. */
    int         kind;      /**< Kind. */
    int         tactics;   /**< Race tactics. */
    int         battle;    /**< Battle stat. */
    int         stamina;   /**< Stamina stat. */
    int         boost;     /**< Boost stat. */
    int         endurance; /**< Endurance stat. */
    int         tenacity;  /**< Tenacity stat. */
};

/**
 * Reads the development gyorace configuration from the host save directory.
 */
bool PortReadDebugRaceFish(std::vector<NativeDebugRaceFish> &fish);
