#pragma once

/**
 * Draws the timed banner naming the character selected by quick change.
 */
void PortDrawQuickChangeBanner();
/**
 * Discards the quick-change banner before entering another gameplay mode.
 */
void PortCancelQuickChangeBanner();
/**
 * Plays the quick-change effect on the new character: a fade from white and a splash of stars.
 */
void PortStepQuickChangeEffect();
/**
 * Reports whether a new quick change must wait for the last one's effect to end.
 */
bool PortQuickChangeCoolingDown();

/**
 * Completes a quick change the frame just opened, in that same frame, so the game never stops for its menu.
 */
void PortFinishQuickChange();
