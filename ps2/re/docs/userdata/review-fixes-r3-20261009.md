# October 9 round-three review fixes (review-night-r2)

Base `fc0893b2`. The changes keep the userdata object, the whole PAL build
(`SCES_511.90: OK`) and all 149 complete-object checks exact.

## Redundant signed-byte casts (S6)

`BREEDFISH_USED::sex` and `CGameDataUsed::rename_flag` are `s8` fields
(every user stores 0 or 1). The remaining `(signed char)` / `static_cast<s8>`
/ `(s8)` conversions on them were no-ops and are gone:

- `CGameDataUsed::GetName` indexes `symbol_tbl_1338[LanguageCode][rename_flag]`
  for the name prefix and suffix;
- `CGameDataUsed::TransToPassword` packs `body->sex` into the one-bit
  `PackedFish::sex`;
- `CFishAquarium::CheckHaigouTankSex` compares the two `sex` bytes
  directly.

The menuaqua casts on the same fields belong to that unit's lane.

## `GetActiveChrNo()` documentation

`CUserDataManager::GetActiveChrNo()` now has a doc block like its neighbour
`GetMonsterID()`. Retail has no out-of-line copy of either accessor, so
neither carries `@mangled`/`@address`/`@size`.

## `ATTACH_USED::status` and the ten-parameter run

`status[2]` (+0x2) is followed directly by `attribute[8]` (+0x6), and
retail treats them as one ten-parameter run in two places:
`CGameDataUsed::GetStatusParam` copies `status[0..1]`, `attribute[0..7]`
into `param[0..9]`, and menuchr's `CMenuMosSelect::KeyStep` fills a
class-change reward through `s16 *param = reward.data.attach.status` with
`param[0..9]`, writing past `status` into `attribute`. The arrays stay
separate because gamedata and userdata index them separately
(`status[list_no - 10]`, `status[slot - 8]`, `attribute[slot]`); the field
documentation records the run.

## Validation

`./build.sh` exit 0 with `SCES_511.90: OK (6789 perfect, 0 fuzzy, 83 asm,
0 unmatched)`; `check_objects.py` 149/149 (`userdata: 0xBC1C bytes, 1081
relocations`, `menuchr: 0x11C9F bytes, 3835 relocations`).
