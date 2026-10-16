#pragma once

/**
 * Draws the timed banner naming the character selected by quick change.
 */
void PortDrawQuickChangeBanner();
/**
 * Discards the quick-change banner before entering another gameplay mode.
 */
void PortCancelQuickChangeBanner();

// Plays the effect on the character a quick change switched to: a fade from white and a splash of stars.
void PortStepQuickChangeEffect();

// Whether the last quick change is still playing its effect; no new quick change starts until it ends.
bool PortQuickChangeCoolingDown();
