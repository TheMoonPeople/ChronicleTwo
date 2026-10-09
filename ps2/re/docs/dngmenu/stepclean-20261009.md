# October 9 review cleanup: CMenuTreeMap::Step

Base `79749ab1` (Step native, PAL OK, 149/149), image
`chronicletwo_dev:sf-63f7a9e`, unchanged SF profile. Only Step, the data it
alone uses and enumerators it needs are changed. Every step below keeps Step
at **0/1548** words with body 0x1828, passes the full build
(`SCES_511.90: OK`, 6,790 perfect) and check_objects **149/149**
(`dngmenu: 0x8B90 bytes, 1420 relocations`).

## Function statics

Retail has six LOCAL Step statics in `.sbss`: `old_direction$2830`
(0x37D5A4, 4 bytes), `init$2831` (0x37D5A8, 1), `old_glid$2833` (0x37D5AC, 4),
`init$2834` (0x37D5B0, 1), `NextFloorGlid$2836` (0x37D5B4, 4) and
`init$2837` (0x37D5B8, 1). Step tests the first two guards at +0x2C and
+0x4C, beside the `MenuCommonInfo` load and before `MenuDCMsg[3]` and
`FadeInOutMenu`, and the third at +0x84, after `ReadBGSync`. All three
statics are used only inside Step, at function scope, so none needs an
explicit guard. Menuchr's `select_monster_save` likewise uses a natural
static, placed directly in the step-switch scope so later cases can read it.

The natural declarations sit where retail tests the guards:

```cpp
CMenuKeyFunc *keys = MenuCommonInfo;
static int old_direction = -1;
static GLID_INFO *old_glid = NULL;
...
int selection_changed = 0;
static GLID_INFO *NextFloorGlid = NULL;
```

MWCC emits each guard at its declaration; the postprocessor names the
statics through Step's complete code references (`old_direction_2830`,
`old_glid_2833`, `NextFloorGlid_2836` at their retail addresses). The
file-scope storage and the hand-written guards are gone. `old_direction`
is only ever reset to -1; retail never reads it either. `old_glid` is the
room the cursor last moved away from and is passed to `GetKeyNextRoom`.

## Data

`bitTable$2900` is LOCAL `.data` 0x352780, 36 bytes: nine words
`1, 1, 2, 8, 0x10, 0x20, 0x40, 0x80, 0x100`. Debug selector row zero edits
`visit_count` instead, so word zero is never read; rows 1 to 8 are the
`DNG_FLOOR_FLAG` bits in the order of the debug display's `bittable_2134`.
The former `extern int bitTable_2900[12]` overstated the size. It is now
`static int bitTable[9]` at the top of Step's debug block, written with the
flag enumerators (word zero repeats `DNG_FLOOR_FLAG_OPEN`). The postprocessor
proves it through Step and pads the 48-byte piece up to `at_3141`.

The remaining sixteen markers are compiler literals and initializer templates
that native Step already emits. They are removed without source changes,
as listed in [data-migration-20261008.md](data-migration-20261008.md). The
three empty section headings at the end of `dngmenu.cpp` are removed with them.
dngmenu markers go from **13 / 4 to 0 / 0** and the repository's from
594 / 110 to 581 / 106. The refreshed objdiff report's unmatched data falls
from 336,010 to 332,887 bytes: all 3,159 dngmenu data bytes now match, up from 36.
Coverage stays 6,790 matched / 73 guarded / 9 asm-only / 0 fuzzy.

## Named values

| Raw value | Name | Evidence |
|---|---|---|
| `SetBitFlag`/`CheckBitFlagMenu` `0xDC` | `SAVE_FLAG_FISHING_OPEN` (`savedata.hpp`) | Sets `DngInfoFishOkFlag`; while clear the fishing row shows message 2. The debug R1 key sets it. |
| `0x13D` | `SAVE_FLAG_SPHEDA_UNLOCKED` | Same for `DngInfoSphidaOkFlag` and the spheda row. |
| `MenuSePlay(0x13)` | `SYSTEM_SE_WINDOW` (`snd_mngr.hpp`) | Played as the floor question or information opens; menusys, menumain, menuaqua and menuchr play it on window and panel changes. |
| `MakeMsg` `0x3C`, `0x3D` | `TREE_MAP_MES_JUMP`, `TREE_MAP_MES_JUMP_NAMED` | Floor question; the second form inserts the start, sub, exit or boss floor's name (`floor_id + (dng_no + 1) * 1000`). |
| `mes_no += 2` | `TREE_MAP_MES_PAY` | Paid jump variant (`jump_pay`, which also shows the money). |
| `0x40`, `0x41` | `TREE_MAP_MES_FLOOR_INFO`, `TREE_MAP_MES_FLOOR_INFO_MATERIALS` | Floor information without and with georama materials. |
| `ResetBitCtrl(0x10)` | `MENU_DEBUG_BIT_CTRL_BOOT_TREEMAP` | The existing bit-control enumerator for 0x10. |
| `floor_status &= 0xFFF8` | `~(DNG_FLOOR_STATUS_SEAL_MONICA \| DNG_FLOOR_STATUS_SEAL_MAX \| DNG_FLOOR_STATUS_UNK_4)` (`scenesnd.hpp`) | dng_event sets `1 << (seal - 1)` for `DNGMAP_SEAL_MONICA`/`MAX`. Bit 4 is read by several menus with different local names, so it stays unknown. menusys and dng_main clear the same three bits. |
| `entry->flag = 0x1FB` | OR of the eight `DNG_FLOOR_FLAG` bits | Exactly the debug display's eight flags. |

The message enum is local to Step, like its action enum. The new enumerators
compile to the same bytes. Screen coordinates stay literal.

Kept raw: `CheckBitFlagMenu(0x66)` and its sibling floor-event flags `0xC9`,
`0xD4`, `0x133`, `0x158`, `0x196` and `0x1A8`. Each makes jumping to a
particular floor play its entry event while the flag is clear. The only other
consumer of 0x66 is menumain's clock (0x66 sets the shown time to 0:00). The
existing names for 0x158 and 0x1A8, `SAVE_FLAG_TOURNAMENT_STARTED`/`CYCLE`,
come from menumain's fishing-tournament debug key and do not describe this
use. Naming the family needs event-script evidence, so none is named here.

`DNGMAP_ROOM_INFO::selectable` (byte 0x44, formerly `unk_44`) is cleared by
`_ROOM_INFO`, set to 1 for every room by `CheckDrawGlidInfo`, and read signed
by Step: the cursor moves only onto rooms where it is 1. As an `s8` field Step
reads it without a cast (dngfloor and dngmenu objects unchanged).

## Jump-map test

The `SELECT` action rejected a destination that translates to the current map
with a comma expression inside its `else if` chain. The plain form compiles
identically (probe `AD-comma-statement`: 0/1548, unit check zero errors):

```cpp
} else {
    if (CheckDngTreeMapFuncType() == DNG_TREE_MAP_FUNC_OTHER && TreeMapCallDungeonSubMap == 1) {
        MakeDngTreeMapJumpNo(dng_no, NextFloorGlid->room.floor_id, &loop_no, &map_no);
        if (map_no == MenuMainScene->GetNowMapNo()) {
            MenuSePlay(MENU_SCRIPT_SOUND_CANCEL);
            break;
        }
    }
    selection_changed = 1;
```

The `break` leaves the action switch, which is all that follows the chain.

Receipts under `.private/stepclean-r0/`: `{base,A,D,B,C}-build.log`,
`{A,D,B,C}-objects.log`, `C-{progress,coverage}.log`, probes
`dngmenu/{A-statics,AD-comma-statement,C-enums}/`, and the edit scripts in
`edits/`.
