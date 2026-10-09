# quest: reverse-engineering notes

No first-game counterpart (Dark Cloud has no quest/request memo or monster book of this form).

## Linkage
- LOCAL in retail (`build/re/local_symbols.tsv`), so `static` in `quest.cpp`, not in the header:
  `GetQuestData()`, `quest_NUM/NEW/COMMENT/END(SPI_STACK*, int)`, `quest_cmd_tag`,
  `spi_questman`, `spi_queststack`, `spi_quest_info`. The header therefore has no `extern` data.
- Global: the CQuestManager/CQuestData/CMonsterBook members, `QuestRequestSetFlag`,
  `QuestRequestClear`, `GetQuestRequestStatus`.

## Globals (all .sbss, 4 bytes, used only while LoadCfg runs the script)
- `spi_questman` (0x37EA28): `CQuestManager *` being filled (LoadCfg stores `this`).
- `spi_queststack` (0x37EA2C): `mgCMemory *` heap passed to LoadCfg.
- `spi_quest_info` (0x37EA30): `QUEST_INFO *` cursor; quest_NUM sets it to `info`, quest_END advances it by one (0x3D0).
- `quest_cmd_tag` (.rodata 0x363040, symbol size 0x28): `SPI_TAG_PARAM[5]` =
  {"NUM",quest_NUM}, {"NEW",quest_NEW}, {"COMENT",quest_COMMENT}, {"END",quest_END}, {0,0}.
  Strings are at_878..at_881 (.rodata 0x379108..).

## Names
`QUEST_INFO`, `QUEST_PLAY_DATA`, `MONSTER_BOOK_ENTRY`, `QUEST_LIMIT`, `QUEST_REQUEST_STATUS`
are not retail names (no symbol carries them); retail names exist only for the three classes.

## CQuestManager (size 0x8)
- `operator new(8)` in `MenuNPCQuestViewInit` (menushop) followed by a null-checked call to
  `Initialize` => inline ctor `CQuestManager() { Initialize(); }`.
- +0 `num` (s32): set by quest_NUM; GetQuestInfo loop bound; menushop scroll bar uses `num - 7`.
- +4 `info` (QUEST_INFO*): quest_NUM: `new(Alloc(stack, ((n*0x3D0 + 15) >> 4) + 2)) QUEST_INFO[n]`
  via `__nwa__FUiP1` with size exactly n*0x3D0 (no array cookie => trivial type).
- GetQuestInfo(id): linear search for `info[i].id == id`, returns `&info[i]` or 0.
- LoadCfg: CScriptInterpreter on stack (0xED0), SetTag(quest_cmd_tag), SetScript(script, size), Run.

## QUEST_INFO (size 0x3D0, stride in GetQuestInfo/quest_END/MenuNPCQuestViewDraw)
- +0 `id`: quest_NEW arg 0 (int).
- +4 `name[0x84]`: quest_NEW arg 1 strcpy; drawn in the list (CFont::SetStr(info+4)).
- +0x88 `comment[0x140]`: quest_COMMENT with index 0.
- +0x1C8 `reaction[4][0x82]`: quest_COMMENT with index n>0 writes `0x1C8 + (n-1)*0x82`.
  KeyStep (menushop) shows +0x1C8 (slot 0) when not cleared, +0x24A (slot 1) when cleared.
  Slots 2 and 3 exist by size (0x3D0 - 0x1C8 = 4*0x82) but no reader was found.
- name size 0x84 is inferred from the next field offset only.

## CQuestData (size 0x480)
- `Initialize` = `memset(this, 0, 0x480)`. Lives at save data + 0x62A40 (GetQuestData,
  MenuNPCQuestViewInit, CSaveData::Initialize); CMonsterBook follows at +0x62EC0 (= +0x480).
  memcard/convviewlp call Initialize on another base + 0x62AC0.
- +0 `play[0x40]` of QUEST_PLAY_DATA (stride 0x10; range check 0..0x3F in all three accessors).
- +0x400..0x480 never accessed in the code seen: `unk_400`.
- SetQuestFlag(id, flag): `play[id].accepted = flag` (sb). QuestClear(id): `play[id].cleared = 1`.
- GetPlayQuestData(id): `&play[id]` or 0.

## QUEST_PLAY_DATA (size 0x10)
- +0 `accepted` (lb => s8): Draw shows "?" for the title when 0, a different icon when ==1 and not cleared;
  debug view prints o/x.
- +1 `cleared` (lb => s8).
- +2..0x10 unknown.

## QUEST_REQUEST_STATUS (GetQuestRequestStatus)
-1 no save data / null play data; 2 if cleared; else `accepted != 0` (0/1). Returned to event
scripts by `_GET_QUEST_ETC` (event_func). `_SET_QUEST_ETC` mode 0 -> QuestRequestSetFlag(id, v),
mode 1 -> QuestRequestClear(id, v). QuestRequestClear ignores its second argument.

## CMonsterBook (size 0x1200)
- CSaveData::Initialize memsets save+0x62EC0 for 0x1200; the next save block starts at +0x640C0
  (GetMenuSysData). 0x1200 = 0x180 * 0xC.
- CountKill(id, count): 0 <= id < 0x180; `entry[id].kill_count += (u16)count` (andi 0xFFFF on count),
  clamp to 60000 if > 60000, return the lhu'd value. Return type declared `int`: KillMonsterCount
  (userdata, returns int) passes the value through unmasked; `u16` would be equally consistent.
- MONSTER_BOOK_ENTRY: +2 `kill_count` u16 (lhu/sh); +0 and +4..0xC never accessed in code seen
  (MonsterBookPtr in menuchr is only assigned, never read, in the decompiled output).

## C++ draft and promotion status

The C++ drafts in `quest.cpp` use the types and fields documented above. A single
grouped promotion attempt was made for the quest data operations. These matched
exactly and remain enabled: `GetQuestData`, `CQuestManager::GetQuestInfo`,
`CQuestData::Initialize`, `QuestRequestSetFlag`, `QuestRequestClear`, and
`GetQuestRequestStatus`. `CQuestManager::Initialize` already matched.

The same attempt produced nonzero object differences for
`CQuestData::SetQuestFlag`, `CQuestData::QuestClear`,
`CQuestData::GetPlayQuestData`, and `CMonsterBook::CountKill`; their C++ drafts
remain behind `NONMATCHING`. The script parser drafts (`quest_NUM`, `quest_NEW`,
`quest_COMMENT`, `quest_END`, and `CQuestManager::LoadCfg`) compiled in their
single grouped attempt but failed to link: the assembly-owned tag table still
references the original handler symbols. They also remain behind `NONMATCHING`.
