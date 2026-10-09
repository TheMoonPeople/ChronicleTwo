# October 9 round-three review fixes (review-night-r2)

Base `fc0893b2`. Every change below keeps the menuchr object exact
(`menuchr: 0x11C9F bytes, 3835 relocations`), the whole PAL build
(`SCES_511.90: OK`) and all 149 complete-object checks. No guard,
compiler-profile row or guarded draft body changes.

## `CMenuMosSelect::KeyStep` closing script (M2)

The mode-2 close path runs the nine-byte Shift-JIS end-processing script
(終了処理). `KeyStep` now passes the literal inline, as
`CMenuChrCngMenu::MenuLocalLoop` already does; the `extern char at_2307[]`
declaration is gone. MWCC pools the two identical literals into the one retail object
`at_2307`, so both relocations resolve to the same address as before.

## Command-window arm scope (M3)

The `case 1:` / `case 4:` arm of the step-0 command switch declares
`int mes = command->item_mes[cursor];`. Without braces, the following
`case 2:` label jumps past that initialised declaration, which C++ forbids
(GCC and clang reject it; MWCC accepts it). The arm is now a braced block;
the generated code is unchanged.

A scan of every `switch` in the unit's matched code (labels that follow an
initialised automatic declaration made directly in the switch body) finds
one more instance in `KeyStep`: step 10's confirm arm
(`case MENU_PUSH_BUTTON_DECIDE:`) declares `char *name = GetMonsterName(…);`
before `case MENU_PUSH_BUTTON_CANCEL:`. It is braced the same way, also
without a code change. No other matched switch in menuchr has the pattern;
the guarded drafts were not scanned. A host `clang++-18 -fsyntax-only`
pass over the unit (n32 MIPS target, the project's include directories)
reports exactly these two "cannot jump from switch statement to this case
label" errors at `fc0893b2` and none in `menuchr.cpp` after the fixes; its
remaining errors are in shared headers (`__int128`, size assertions).

## `select_monster_save` is a function static in the step switch (M4)

Retail has a function static `select_monster_save$3371` with the guard
`init$3372`, and the guard test sits at the start of step 10's arm. The
static is also read in steps 12 and 13 (the chosen class-change monster's
id and name), which are later `case` arms of the same `switch (step)`. A
static declared inside step 10's braced block is not visible there, and a
static at the top of `KeyStep` moves the guard test to the function entry.

`case 10:` followed by `static int select_monster_save = 0;` directly in the
`switch (step)` scope, with step 10's body as a nested block, keeps the static
in scope for steps 12 and 13 and runs its guard where retail's does. C++
allows a jump to bypass a static's declaration (only automatic variables are
protected), and clang accepts it. The former file-scope
`select_monster_save_3371` / `init_3372__2` pair and the written-out guard are
gone: `SCES_511.90: OK`, 149/149 (`menuchr: 0x11C9F bytes, 3835 relocations`).

## Plain local arrays instead of initializer wrappers (S3)

`MonsterNameList`, `MenuCommandList`, `MonsterNameTable` and
`BadgeInfoValues` existed only to hold `KeyStep`'s aggregate initializers.
They are replaced by plain local arrays and deleted:

| Wrapper | Native local array | Uses |
| --- | --- | --- |
| `MonsterNameList` | `char *[1] = {NULL}` | grown-monster and growth-item names |
| `MenuCommandList` | `int [8] = {…}` | badge command message numbers |
| `MonsterNameTable` | `char *[8] = {NULL}` | transform and class-change name lists |
| `BadgeInfoValues` | `int [6] = {0}` | badge description values |

The zero templates (`at_3412`, `at_3440`, `at_3511`, `at_3529`, `at_3554`)
and the command template (`at_3481`) keep their retail bytes and sizes; the
review probe T verified the same conversion.

## Function statics of `KeyStep` (S3)

`convert_table$3430`, `ghobitbl$3437` and `get_stringtbl$3557` are retail
function statics used only by `KeyStep`. They are now declared at the top of
`KeyStep` as `convert_table`, `ghobitbl` and `get_stringtbl` (the review
probe V verified this placement); the file-scope `_NNNN` definitions are
gone.

## Constants (S3)

- `GamePad__2.On(PAD_SQUARE)` selects the debug gauge.
- Key and button bits use `MENU_SELECT_KEY_*` and `MENU_PUSH_BUTTON_*` in
  `CMenuMosSelect::KeyStep` and `CMenuCostumeSel::KeyStep`, the two
  matched readers in this unit (the guarded `KeyChangeMain` and
  `CMosBookMenu::KeyStep` drafts are unchanged). `CheckLRKey`'s bits are
  the shoulder buttons `MENU_SELECT_KEY_L1/R1/L2/R2`.
- The badge commands are `MOS_SELECT_COMMAND_MSG`: 0x14B6 transform
  (dimmed when the change is not allowed, the badge has no health or Monica
  has status attribute 4, 8 or 0x20), 0x14B7 view status, 0x14B8 class
  change (removed from the list when the badge cannot change class).
  The scripts these commands run (ステータスを見る, クラスチェンジ) name them.
- Dimmed lines use `MES_COLOR_DARK`; the line bound is `MES_LINE_MAX`;
  the status-attribute tests use `CHARA_STATUS_UNK_4/8/20`.
- The class-change reward is `USED_ITEM_TYPE_ATTACH` with item type
  `ITEM_DATA_UNK_22`.

## `CameraPoint` stays (probe R)

`*(CameraPoint *) MenuDrawEnv->pos = *(CameraPoint *) camera_pos;` (and the
`ref` copy, also in the matched `MenuMonsterBoxInit`) copies four floats.
The review probe R replaced both copies with upstream's
`*(u_long128 *)` spelling: `MenuMonsterBoxInit` and `KeyStep` both shrink
(a quadword copy instead of four word copies) and the object no longer
matches, so the four-float struct copy is load-bearing. The natural end
state is a typed four-float vector type for `MENU_DRAW_ENV::pos/ref` and
`CMenuMosSelect::camera_pos/ref`, so that the copy needs no cast; that
touches shared headers and is unprobed.

## Ten-parameter reward fill

The class-change reward fills ten parameters through
`s16 *param = reward.data.attach.status;`: `param[0..1]` are `status[2]`
and `param[2..9]` run on into `attribute[8]`, which follows it directly
(offsets 2..0x15 of `ATTACH_USED`). `CGameDataUsed::GetStatusParam` reads
the same ten values in the same order. The two arrays are not merged into
one: gamedata, userdata and the weapon code index `status` and `attribute`
separately (`status[list_no - 10]`, `status[slot - 8]`, `attribute[slot]`),
so one array would change every such user. The overrun is documented on
`ATTACH_USED::status`.

## Formatting

The remaining double blank line before the `.rodata` section is removed, and
both `#pragma inline_depth reset` lines that sat directly against a
function now have the blank-line spacing the unit's other pragmas use.
Printable ASCII in the matched code's script and form-part literals is
written as plain characters (`"…" "2OFF"`, `"MSG…"`, `"NOT_…"`, `"…" "1"`);
Shift-JIS characters keep the unit's uppercase hex spelling, and a literal
is split where an ASCII hex digit would otherwise extend the preceding
escape. The bytes are unchanged.

## Validation

Each source commit was built on its own: `./build.sh` exit 0 with
`SCES_511.90: OK (6789 perfect, 0 fuzzy, 83 asm, 0 unmatched)` and
`check_objects.py` 149/149 (`menuchr: 0x11C9F bytes, 3835 relocations`).
After a refreshed objdiff/progress report, coverage is unchanged at 6,789
matched / 74 guarded / 9 assembly-only / 0 fuzzy, and the marker counts
stay at 594 `INCLUDE_RODATA` / 110 `INCLUDE_BSS` (the inlined `at_2307`
was already native data).
