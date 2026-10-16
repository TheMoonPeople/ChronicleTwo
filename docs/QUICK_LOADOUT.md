# Quick loadout

In a dungeon, Down on the directional pad opens the QUICK LOADOUT panel under the status board's active items, and
Down again closes it.

The panel has four slots, one for each face button:

| Character   | Square, Triangle | Cross, Circle  |
|-------------|------------------|----------------|
| Max, Monica | melee weapons    | second weapons |
| Ridepod     | arms             | legs           |

Items go in the slots from the item menu: on a weapon of Max or Monica, or a Ridepod arm or leg part, the command
list has **Equip Slot** after Equip. It lists the four slots by their buttons, the item's two (its character's row)
to choose from and the other two greyed out; the one chosen takes the item, and a row's other slot lets go of it.

While the panel is open the face buttons belong to it: a press equips the slot's item at once, the character is
loaded again with it, as a quick change (L3, R3) loads the next character, and the quick change's white fade and
stars play on it. Pressing the slot already in hand does nothing.

The slot whose item is equipped now wears the game's own rotating active item cursor (the one round the camera on the
status board) round its picture.

The first time a character's panel opens, each empty row takes the item equipped in it. An item the party no longer
has is drawn dimmed, and its slot does nothing. The Ridepod only takes a part it has the capacity for, as in the menu.
The monster form has no panel.

The slots are kept in `quick_loadout.txt` in the save folder, one line per slot.

## Pictures

Each slot shows the item's own 3D model, drawn once into a 128x128 texture by Jeffiest's 3D item icon renderer
(`port/src/item_icon3d.cpp`, from TheMoonPeople/ChronicleTwo#53), in the dungeon's free texture blocks 0xAC and 0xAE.

The panel picture, `port/quick_loadout/panel.png`, is drawn from shapes by `scripts/port/quick_loadout_panel.py` in
the style of the dungeon's active item board (gold lines around plum fills), from Javier's design, and embedded in the
executable as `port/src/quick_loadout_panel.inc`:

    python3 scripts/port/quick_loadout_panel.py port/quick_loadout/panel.png
    python3 scripts/port/embed_png.py port/src/quick_loadout_panel.inc kQuickLoadoutPanelPng=port/quick_loadout/panel.png

Its title, QUICK LOADOUT, is written on it at run time in the game's own font. The item pictures come from each
player's own extracted data; the repository holds none of the game's pictures.
