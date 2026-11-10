# Button symbols

The retail menus and messages draw PlayStation 2 button symbols from the game's own textures: the
message font's symbol sheet (`gaiji`, one per language under `meswin/`) and a few prompts such as the
cutscene skip (`skip`, under `img/<language>/`). With `input.glyphs` set to `new` (PC settings,
Controls, **Button symbols**), the port pastes the symbols of a `glyphs/` folder over those cells
when it decodes the texture, so every screen that samples it shows them.

`input.glyph_device` (**Glyph style**) chooses the style: a fixed one, or Auto, which follows the
device last used. A change takes effect on the next frame; active pixels are rebuilt from immutable
native mip and variant snapshots. Keyboard binding changes also refresh the symbols. A style or symbol that `glyphs/` does not have keeps the game's art, so `ps4` with no atlas
is the original look.

## The glyphs folder

`glyphs/` is read beside the executable, then in the save folder. Save-folder styles override
same-named installed styles and can add new ones. The build copies `port/assets/glyphs/` to `glyphs/` beside the executable: the art of
TheMoonPeople/Chronicle's `port/glyphs` (PS3, PS4, PS5, PS5 Color, Xbox, Switch, Steam Deck, Steam
Controller and keyboard). Replace any atlas with your own art and keep the rectangles in step.

```json
{
  "styles": {
    "xbox": {
      "atlas": "xbox.png",
      "glyphs": {
        "cross": [4, 4, 56, 56],
        "start_label": [12, 140, 136, 40]
      }
    }
  },
  "targets": {
    "gaiji": { "cross": [67, 23, 20, 20] }
  }
}
```

- `styles`: one entry per style name: `ps3`, `ps4`, `ps5`, `ps5color`, `xbox`, `switch`,
  `steamdeck`, `steamcontroller`, `keyboard`. `atlas` is a PNG beside `glyphs.json`; `glyphs`
  gives each symbol's rectangle `[x, y, width, height]` in atlas pixels. Draw at any resolution: a
  symbol is box-filtered into the cell it replaces, its aspect kept and centred, at the texture's
  resolution (an upscaled datapack texture gets a sharper symbol).
- Symbol names: `cross`, `circle`, `square`, `triangle` (by position: cross is the bottom face
  button, so `A` on Xbox and `B` on Switch), `l1`, `r1`, `l2`, `r2`, `start`, `select`, `dpad`,
  `dpad_ud`, `dpad_lr`, `lstick`, `rstick`, and `start_label`, `select_label` for the words
  START and SELECT. A lone word falls back to its button's symbol; the word beside the START and
  SELECT pills does not: without a word in the style it is cleared, so the symbol stands alone.
- `keyboard` names its symbols after keys as SDL spells them, lowercase without spaces (`space`,
  `return`, `e`, `leftshift`...) and `mouse1` to `mouse3`. Each pad button shows the key its
  binding names first.
- `targets` (optional) adds or moves cells of the retail textures, by texture name and in its
  logical pixels. A name `glyph@place` is another cell of the same symbol. The built-in cells:

| Texture | Cells |
| --- | --- |
| `gaiji` | `select_label` 2,2,52,17; `start_label` 62,2,44,17; `circle` 1,23,20,20; `triangle` 23,23,20,20; `square` 45,23,20,20; `cross` 67,23,20,20; `dpad` 2,68,18,18; `dpad_ud` 24,68,18,18; `dpad_lr` 46,68,18,18; `l2` 5,134,22,17; `l1` 37,134,22,17; `r1` 69,134,22,17; `r2` 101,134,22,17; `start` 14,157,24,15; `start_label@pill` 44,156,45,19; `select` 14,179,24,16; `select_label@pill` 44,177,52,19; `lstick` 137,202,26,27; `rstick` 165,201,26,28 |
| `skip` | `triangle` 8,26,20,19 |

Symbols painted into other menu textures are not covered yet; add them under `targets` as they are
found. The converted textures in `port_data/` show where each one is.

The GPU prompts and CPU texture stamping share Kazarov's glyph index and decoded atlas pixels.
Stamping changes only the active texture, preserving native image identity and animation variants.
The shared 512 MiB decode cache covers standalone PNGs and embedded glTF images, with source-file
stamps invalidating edited overlays. Changing the asset root clears the cache.
