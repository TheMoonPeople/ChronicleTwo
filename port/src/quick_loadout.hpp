#pragma once

// The dungeon's quick loadout: Down on the directional pad opens a panel of four slots under the active items, one for
// each face button. Max and Monica keep two melee weapons (Triangle, Square) and two second weapons (Cross, Circle); the
// Ridepod two arms and two leg parts. A tap equips the slot's item at once, with the quick change's effect; holding the
// button keeps the item now equipped in that row in the slot.

// After the pad is read each frame: opens and closes the panel and takes the face buttons from the game while it is open.
void PortQuickLoadoutPad();

// Draws, at most one a frame, the 3D picture of a slot's item that the panel does not have yet. Outside any UI anchor.
void PortQuickLoadoutPrepare();

// Draws the panel under the status board, which slides it with the board. Called inside DrawStatusBord's anchor.
void PortQuickLoadoutDraw(float statusbar_rate);

// Closes the panel and drops its pictures as a mode change starts the texture table again.
void PortQuickLoadoutReset();

// Whether the character being loaded again is a quick loadout's change of equipment rather than a quick change,
// which names the new character; Done is called once the load has finished.
bool PortQuickLoadoutReloading();
void PortQuickLoadoutReloadDone();
