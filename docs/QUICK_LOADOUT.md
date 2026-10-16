# Quick loadout

In a dungeon, Down on the directional pad opens the QUICK LOADOUT panel under the status board's active items, and
Down again closes it.

The panel has four slots, one for each face button:

| Character   | Triangle, Square | Cross, Circle  |
|-------------|------------------|----------------|
| Max, Monica | melee weapons    | second weapons |
| Ridepod     | arms             | legs           |

While it is open the face buttons belong to the panel:

- a tap equips the slot's item at once: the character is loaded again with it, as a quick change (L3, R3) loads the next
  character, and the quick change's white fade and stars play on it;
- holding the button keeps the item equipped in that slot's row in the slot.

The slot whose item is equipped now wears the game's own rotating active item cursor (the one round the camera on the
status board) round its picture.

The first time a character's panel opens, each empty row takes the item equipped in it. An item the party no longer
has is drawn dimmed, and its slot does nothing. The Ridepod only takes a part it has the capacity for, as in the menu.
The monster form has no panel.

The slots are kept in `quick_loadout.txt` in the save folder, one line per slot.

## Pictures

Each slot shows the item's own 3D model, drawn once into a 128x128 texture by Jeffiest's 3D item icon renderer
(`port/src/item_icon3d.cpp`, from TheMoonPeople/ChronicleTwo#53), in the dungeon's free texture blocks 0xAC and 0xAE.

The panel itself (copper frame, bolts, title, slots and the face button discs) is drawn in code by
`port/src/quick_loadout_art.cpp` when the panel first opens, after Javier's mockup. The repository holds none of the
game's pictures: the item pictures come from each player's own extracted data.
