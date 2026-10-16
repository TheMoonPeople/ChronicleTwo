#pragma once

#include "character.hpp"
#include "mg_dataset.hpp"
#include "scriptinterpreter.hpp"

/**
 * Initializes the original gameplay metadata setters for a directly loaded native character.
 */
void PortCharacterMetadataBegin(CCharacter2 *character, mgCMemory *model, mgCMemory *motion,
                                mgCMemory *images, int block, CCharacter2 *parent, bool outline,
                                const char *skin_name);
/**
 * Applies one non-resource gameplay setting using the game's original typed callback.
 */
bool PortCharacterMetadataApply(const char *command, SPI_STACK *arguments, int count, bool skin);
/**
 * Selects the native motion slot used by following key, sequence, and sound metadata.
 */
void PortCharacterMetadataMotionSlot(int slot);
/**
 * Returns the visual selection table established by vertex-animation metadata.
 */
mgCreateVisualType *PortCharacterMetadataVisualTypes(bool skin);
/**
 * Records the directly loaded body and its deformable frame references.
 */
void PortCharacterMetadataModel(mgCFrame *model);
/**
 * Returns and advances the next native cloth record selected by metadata.
 */
int PortCharacterMetadataNextCloth();
