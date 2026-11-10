# 3D item icons

The item menu's icons can be the item's own 3D model, drawn small, in place of the picture on the icon sheet. It is off
unless `DC2_ITEM_ICONS_3D=1` is set. Nothing is baked: each icon is drawn the first time the menu asks for it, from the
model and texture files the game loads, so a replaced model or texture changes its icon with no other step.

## What is drawn

`GetMenuItemIconTexInfo` (port/src/menu_icons.cpp) asks `ItemIcon3DTexture` (port/src/item_icon3d.cpp) for the item's icon
in the plain mode. It returns a 32x32 texture, or null where the item has no model of its own, and then the sheet's picture
is used:

- Weapons and robo parts use the model made for the item view (`wep_t/*_item.gltf`, `dungeon/robo/*`); other items use
  `item/*.gltf`.
- Clothes and footwear load the native base character and apply the item's glTF skin. Jackets and dresses show both authored clothing layers, cropped at the belt; footwear shows the shoe or boot region. Other whole-character costumes and treasure-chest stand-ins keep the sheet.
- The dimmed, grey and sepia variants are made from the sheet's pixels and stay with the sheet.
- The dungeon HUD's equipped-item icons (`CopyActiveIconTexture`) still copy from the sheet.

## How an icon is made

The model is loaded directly with `model_assets::LoadCharacter`, profile `info`, into a native arena
estimated from the glTF asset. Clothing uses `model_assets::LoadSkin`. A dedicated texture manager owns
the model and icon textures, so gameplay texture blocks are untouched. Native gameplay data comes
from the adjacent minimal `.game.json`; no retail model or CFG parser runs. The frame's drawn box (frames the draw flags skip, such as a light's cone, are left out) is turned and fitted:

- a weapon takes the axis-aligned turn that shows its broadest face; anything else is kept upright and turned about the
  vertical to its broadest view, then a little more to the left, and tipped to look from above;
- a thing long and thin as seen is laid along the diagonal; a robo arm's model is a pair, and the icon is the left one.

It is drawn into a 512x512 scratch texture with `mgSetPkFrameBuffer` (the projection's aspect is made for a screen 512
wide, so y is scaled back to make the pixels square): nine black unlit copies shifted about the picture make the outline
and shadow, then the lit model with a key light from the upper left. The middle 128x128 is halved twice into the icon.

Icon results are retained in a bounded cache; older entries are evicted between frames. Failed
renders release their texture headers, character textures are released before the arena, and a
scoped render-state snapshot restores the prior camera, framebuffer, projection, lighting and GS
state on every return. Mode changes clear the icon cache and its GPU targets.
