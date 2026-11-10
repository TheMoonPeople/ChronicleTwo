#pragma once

#include <mapselect.hpp>

/** Native map-name loading fills the map name table and its string storage. */
extern int            MapNameNum asm("MapSelect_MapNameNum");
extern MAP_NAME_INFO *map_name asm("MapSelect_MapName");
extern int            pMapNameBuff asm("MapSelect_MapNameBuffUsed");
extern int            pCharBuff asm("MapSelect_CharBuffUsed");
extern char          *CharBuff asm("MapSelect_CharBuff");
extern int            now_no asm("MapSelect_NowNo");
extern char           MapNameBuff[MAP_NAME_BUFF_SIZE * 16] asm("MapSelect_MapNameBuff");
