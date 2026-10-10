# npccfg notes

Party character (NPC) configuration table loaded from `npc%d.cfg` (`%d` = LanguageCode) by a
CScriptInterpreter with two tags. Called from MainLoop and LanguageChange. No first-game
counterpart. The unit owns no class.

## Functions

All eight functions compile natively and match retail. `LoadNPCCfg` uses a 2048-quadword
stack buffer; increasing it changes frame offsets.

| Symbol | Binding | Notes |
|---|---|---|
| `_NPC_NUM(SPI_STACK*, int)` | LOCAL -> static in .cpp | `NpcBaseDataTotalNum = spiGetStackInt(stack)`; returns 1 |
| `_NPC_INFO(SPI_STACK*, int)` | LOCAL -> static in .cpp | fills `NpcBaseData[npc_spi_count_num++]`; returns 1 |
| `LoadNPCCfg()` | global, void | 0x8000 stack buffer aligned with MenuCalcBufAlignment, LoadFile2, CScriptInterpreter on stack, SetTag(npc_spitag), SetScript, Run; then `NpcBaseDataTotalNum = npc_spi_count_num` |
| `GetPartyCharaMessage(int,int,int)` | global, returns int | 0 if no entry; else `typetbl[type] + chara_no*100`; `type == 12` -> `chara_no + 3000`; 3rd arg non-zero adds 30000 (only `_GET_PARTY_CHARA_MES_NO`, an event-script tag, passes 1) |
| `GetNPCModelName(int)` | returns char* | `&entry->model` (+0x1F) or 0 |
| `GetNPCName(int)` | returns char* | `&entry->name` (+0x3) or 0 |
| `GetPartyCharaModelName(int,int)` | returns char* | NULL unless 1 <= chara_no <= 0x20; builds path in the function static `path` (char[0x40]); type see enum |
| `GetPartyNPCData(int)` | returns NPC_BASE_DATA* | linear search of NpcBaseData[0..NpcBaseDataTotalNum) on `chara_no` (lh) |

`_NPC_NUM`/`_NPC_INFO` take `(SPI_STACK *stack, int argument_count)` matching `SPI_TAG_FUNCTION`
in scriptinterpreter.hpp; the `int` argument is unused.

## NPC_BASE_DATA (name not retail; stride 0x36 from GetPartyNPCData `*0x36` and `_NPC_INFO` `n*9*6`)
`NpcBaseData` .bss extent 0x2600, symbol size 0x25F8 = 180 * 0x36 -> `NPC_BASE_DATA NpcBaseData[180]`.

| Off | Type | Name | Script arg | Evidence |
|---|---|---|---|---|
| 0x00 | s16 | chara_no | 0 (int) | sh in _NPC_INFO; lh compare in GetPartyNPCData |
| 0x02 | s8 | debug_flag | 10 (int) | MenuCharaChangeDraw debug NPC list (menu_debug_npcselect, ids < 0xB3) skips entries with 0 |
| 0x03 | char[0x1C] | name | 1 (string) | strcpy; printf "NAME OVER!!!!!!:%s\n" when strlen > 0x1B |
| 0x1F | char[0x10] | model | 2 (string) | strcpy; GetNPCModelName; file names in GetPartyCharaModelName |
| 0x2F | s8 | max_npc_point | 5 (int) | lb in CUserDataManager::JoinPartyChara (initial value of party info +4) and RefreshNPCStatus (recovery rate and clamp of party info +4) |
| 0x30 | s8 | ability_num | 4 (int) | lb in CMenuChrCngMenu::EnterDataMenu: loop count (<= 4) of ability messages from message type 5; 0 -> single entry 10 |
| 0x31 | s8 | unk_31 | 3 (int) | lb in `_GET_PARTY_CHARA_MES_NO` when type == 4, result + 3 pushed to the script; meaning unknown |
| 0x32 | u8[4] | ability_cost | 6..9 (int) | lbu `0x32 + ability` in UseNpcAbility (subtracted from party info +4); lbu 0x32 in EnterDataMenu |

Size 0x36 (2-byte aligned by the s16). Script arg N is `SPI_STACK` entry N (stride 8).

## Globals (all LOCAL -> static in .cpp)
- `NpcBaseDataTotalNum` .sbss 4, int (set by NPC_NUM, then overwritten by count after Run).
- `npc_spi_count_num` .sbss size 1, u8 (lbu/sb).
- `NpcBaseData` NPC_BASE_DATA[180].
- `npc_spitag` .data 0x18 = SPI_TAG_PARAM[3]: {"NPC_NUM", _NPC_NUM}, {"NPC_INFO", _NPC_INFO}, {0,0}.
  (The asm file shows 0x20 bytes; the last 8 are padding before typetbl.)
- `typetbl_853` .data 0x10: function-local `static char` table in GetPartyCharaMessage (loaded
  with lb): 0, 10, 20, 30, 2, 40, 45, 50, 55, 0, 90, 60, 0, 21, 25, 0. Types seen at call sites:
  0, 1, 3, 4, 5, 7, 8, 10, 11 (0x0B), 12 (0x0C, special-cased). No enum: meanings not established.
- `path$885` .bss 0x40: function-local `static char[0x40]` in GetPartyCharaModelName.
- `infocfg$886` .data 9: function-local `static char[] = "info.cfg"` in GetPartyCharaModelName
  (returned directly for type 1).
- Strings: "chara/", ".chr", "event/train/t%s.chr", "menu/npc/t%s.chr", "npc%d.cfg".

## NpcModelPathType (names not retail)
0 "chara/" + model + ".chr" (`_LOAD_CHARA_NPC`), 1 "info.cfg" (`_LOAD_CHARA_NPC`),
2 "event/train/t%s.chr" (`_LOAD_CHARA_NPC`), 3 "menu/npc/t%s.chr" (MenuNPCModelLoad).
The parameter stays `int` to mangle as `GetPartyCharaModelName__Fii`.


## Native data and canonical identity

All functions and data are native; no `INCLUDE_ASM`, `INCLUDE_RODATA` or `INCLUDE_BSS`
remains. `NpcBaseData[180]` has stride 0x36 and declared extent 0x25F8; eight following
bytes are alignment. The three-row `npc_spitag` array includes its null terminator.
`GetPartyCharaModelName` owns `path[0x40]` and the writable nine-byte `infocfg[]` string
as local statics.

`typetbl_853` remains file-local under its retail identity. Making it a function-local
`typetbl` preserves the executable but leaves the table unbound in the complete-object
check. The 16-byte signed suffix table has no established category enum.
