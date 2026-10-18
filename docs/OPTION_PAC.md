# Patching `option.pac` for Skip Intro (retail row 16)

The PC port adds **Skip Intro** as a 17th in-game Options row (`OPTION_ITEM_SKIP_INTRO`). Retail script and layout only define **16** rows in `opt_com.cfg` / `option.cfg`; row 16 needs extra **Op_Switch** parts (`INDEX160` / `INDEX161`) and scroll metadata.

## Quick path

Apply repo patches onto your dev tree first when using `port/run` — see [PORT_DATA.md](PORT_DATA.md) (`scripts/port/apply_patches`).

From a game data tree that already has extracted menus (e.g. `data/menu/0/option.pac`):

```bash
python3 scripts/port/patch_option_pac.py \
  data/menu/0/option.pac \
  data/menu/0/option.pac
```

Repeat for each language directory that has its own `option.pac` (`menu/0`, `menu/1`, …) if you use non-default language packs.

Restart the game (or reload menu data) after replacing the pack.

## What the script changes

Inside **`option.cfg`** in the pack:

- `FORM_PARTNUM` 54 → 58 (four new toggle parts)
- `op_waku15` / `op_waku16` cursor sizes (if missing)
- `INDEX150`/`INDEX151` at Y=360 (row 15 toggles; stock PAL packs often stop at `INDEX14`)
- `INDEX160`/`INDEX161` at Y=384 (row 16 Skip Intro)

## Code coupling

With the patched pack and a current port build:

- `config_option_num` is **17** for non-Japanese languages (`+1` on port).
- Registry binds `game.skip_intro` to row **16**; **Display Monster Name** stays on row **10**.
- Labels still come from the port registry (`PortOptionsRefreshRetailLabels`); the pack supplies toggle positions.

Without the patched pack, row 16 may be selectable but labels/toggles can misalign.

## `allmenu.mes` (optional)

Message **2051** (column 1 labels) is a compact template in stock data. The port patches labels at runtime where possible. If row 16’s text still looks wrong after `option.pac` is updated, extend message **2051** in `allmenu.mes` inside the same pack with the same item-line pattern as rows 10–15 (one line per option). That step is editor-specific; keep a backup of the original `option.pac`.

## Verify

1. Open in-game **Options** (not Backspace PC SETTINGS).
2. Scroll past **Camera Rotation** — **Skip Intro** should appear on the next row.
3. **Display Monster Name** should still be on its original row.
4. Toggle Skip Intro; confirm `save/config.json` has `"skip_intro": true` after leaving the menu.
