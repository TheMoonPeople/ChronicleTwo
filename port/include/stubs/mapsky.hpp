#pragma once
struct MAP_SKY_INFO;

/** Fills a sky's settings from its native sky document, in place of the sky script's run. */
void PortLoadSkyInfo(MAP_SKY_INFO *info, char *script, int size);
