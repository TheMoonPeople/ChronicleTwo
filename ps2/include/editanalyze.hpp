#pragma once

#include "common.h"

class CEditData;
/**
 * @file
 * Declares the town analysis of the Georama maps: the checks that turn the
 * parts placed in a town into the conditions its analysis script needs, the
 * checks on whether a villager can live in a house, and the events a map
 * sets up from save flags when it is entered.
 */

class CEditMap;
class CEditParts;

/**
 * Georama maps that have a town analysis, numbered as their saved layouts
 * and analysis scripts are.
 */
enum EditAnalyzeMap {
    EDIT_ANALYZE_MAP_SHARLOT     = 0, /**< Town analysed by AnalyzeSharlot. */
    EDIT_ANALYZE_MAP_STERA       = 1, /**< Town analysed by AnalyzeStera. */
    EDIT_ANALYZE_MAP_BENIETIO    = 2, /**< Town analysed by AnalyzeBenietio. */
    EDIT_ANALYZE_MAP_HEIM        = 3, /**< Town analysed by AnalyzeHeim. */
    EDIT_ANALYZE_MAP_MOON_FLOWER = 4, /**< Town analysed by AnalyzeMoonFlower. */
};

/**
 *
 * Works out which conditions of a town's analysis its layout meets and stores them in the town's saved layout.
 *
 * @mangled AnalyzeEditMap__FiP8CEditMap
 * @address 0x31BDD0
 * @size 0xD0
 */
void AnalyzeEditMap(int map_no, CEditMap *edit_map);

/**
 *
 * Counts the placed edit parts of a kind among a list of slot numbers.
 *
 * @mangled CountPartsType__FiP8CEditMapPii
 * @address 0x31BEA0
 * @size 0xC0
 */
int CountPartsType(int parts_type, CEditMap *edit_map, int *list, int num);

/**
 *
 * Counts the placed edit parts with a definition ID among a list of slot numbers.
 *
 * @mangled CountPartsInfoID__FiP8CEditMapPii
 * @address 0x31BF60
 * @size 0xC0
 */
int CountPartsInfoID(int info_id, CEditMap *edit_map, int *list, int num);

/**
 *
 * Gives the slot numbers of the placed houses of a town, up to a maximum, returning how many were given.
 *
 * @mangled GetHouseParts__FP8CEditMapPii
 * @address 0x31C130
 * @size 0xB0
 */
int GetHouseParts(CEditMap *edit_map, int *list, int max);

/**
 *
 * Returns a placed edit part and gives its position, or returns NULL when the slot is empty.
 *
 * @mangled GetPartsPos__FP8CEditMapiPf
 * @address 0x31C230
 * @size 0x70
 */
CEditParts *GetPartsPos(CEditMap *edit_map, int no, float *pos);

/**
 *
 * Returns whether a villager would agree to live in a placed house, judged by its surroundings.
 *
 * @mangled CheckLiveChara__FiP8CEditMapii
 * @address 0x31DDE0
 * @size 0x470
 */
int CheckLiveChara(int map_no, CEditMap *edit_map, int no, int chara);

/**
 *
 * Sets up the parts and function points of a map that depend on save flags when the map is entered.
 *
 * @mangled EditMapInitEvent__FiP8CEditMap
 * @address 0x31E250
 * @size 0xC0
 */
void EditMapInitEvent(int map_no, CEditMap *edit_map);

void AnalyzeSharlot(CEditData *data, CEditMap *map);

void AnalyzeStera(CEditData *data, CEditMap *map);

void AnalyzeBenietio(CEditData *data, CEditMap *map);

void AnalyzeHeim(CEditData *data, CEditMap *map);

void AnalyzeMoonFlower(CEditData *data, CEditMap *map);

int GetColorType(CEditParts *parts, int no);
