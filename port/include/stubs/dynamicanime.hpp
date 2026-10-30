#pragma once

#include <span>

struct SPI_TAG_PARAM;

/** Runs a cloth script, a typed command list from a character resource or a text script, through the cloth tags. */
void PortRunDynamicAnimeScript(std::span<const SPI_TAG_PARAM> tags, char *script, int size);
