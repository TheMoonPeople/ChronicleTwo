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
status board): its dashes are laid along the slot's rounded edge and travel round it, and the button's disc stays
in front of them. With Max or Monica the panel sits under the active item circles; the Ridepod's status board has none,
so its panel sits further left and higher, under the Ridepod's numbers. A character change closes the panel, which
fades where it was rather than following the board as it slides away.

The first time a character's panel opens, each empty row takes the item equipped in it. An item the party no longer
has is drawn dimmed, and its slot does nothing. The Ridepod only takes a part it has the capacity for, as in the menu.
The monster form has no panel.

The slots are kept in `quick_loadout.txt` in the save folder, one line per slot.

## Pictures

Each slot shows the item's own 3D model, drawn once into a 128x128 texture by Jeffiest's 3D item icon renderer
(`port/src/item_icon3d.cpp`, from TheMoonPeople/ChronicleTwo#53), in the dungeon's free texture blocks 0xAC and 0xAE.

The panel itself is put together at run time from the dungeon's own system frame texture, the one the active item
board is drawn from: the EXP gauge's box round the panel with a see-through black inside, and the halves of the item
circles stretched into the four slots, the title bar and the buttons' discs. The buttons are the font's own button
pictures, and the title, QUICK LOADOUT, is written in the game's font. PC settings, Game, Quick loadout title
(`game.quick_loadout_title`) chooses its style: white on the bar, or engraved on a plate taken from the EXP gauge's,
standing on the box's top edge. Everything shown comes from each player's own
extracted data; the repository holds none of the game's pictures.
