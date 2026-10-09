# menucapt data migration (2026-10-08)

Baseline: `95f8fdd1`; 14 initialized-data
markers and 11 BSS markers. Every function already matches.
The pinned `chronicletwo_dev:sf-63f7a9e` image and full object/PAL checks
validate each accepted step. Public declarations remain compatible.

## Chapter state

The eleven reservations are native file-local definitions with the existing
word, pointer and signed-byte types. The two initialization flags have declared
size one; their three-byte alignment gaps remain piece padding, rather than
additional state. `MenuChapterStack` remains a native `mgCMemory`, so its
constructor and the unit's initializer retain the retail call.

`wait_cnt_918` is only reset, never advanced or read by the title state
machine. `voiceflag_921` records narration completion or the 1,500-frame
timeout. Their existing initialization guards and runtime instructions remain
unchanged. The typed data definitions do not introduce helper code or locals.

The `menucapt-state-{build,objects,metrics}.log` receipts in `.private/dataD/`
record PAL OK, 149/149 objects and unchanged unowned hashes. BSS markers
fall from eleven to zero; interim matched data is 93/336.

## Narration table and paths

`chap_voice_851` is a native eight-pointer table with inline filenames.
Actual retail bytes are `0060600.wav`, `2070310.wav`, `3060260.wav`,
`4020120.wav`, `5000010.wav`, `6000360.wav`, `7000010.wav` and `8000140.wav`.
The older `notes.md` filename list incorrectly transposes the leading digits
of seven entries; the native initializer preserves the bytes of each piece.
The table and eight anonymous string markers are removed together.

The existing inline image paths and texture names supply their four own
pieces. The sound-bank path is inline with the existing writable `char *`
API conversion. Plain `LoadFile2("snd2/sp/SP_007.snd", ...)` exchanges the
filename and size-pointer `addiu` instructions at +0x1AC/+0x1B0 (two
masked words), despite exact data. Preserving the explicit `(char *)`
conversion emits both instructions in retail order; no local or helper is
introduced. All anonymous extern declarations are removed.

Final markers: **0 RODATA / 0 BSS**, from **14 / 11**. Refreshed
`matched_data` increases from **52/336** to **336/336**. All four functions
remain matched. Accepted receipts in `.private/dataD/` are
`menucapt-narration-table-{build,objects,metrics}.log` and
`menucapt-sound-path-cast-{build,objects,metrics}.log`; both pass PAL,
149/149 objects and unchanged unowned hashes. The rejected plain-string
receipt is `menucapt-path-literals-build.log` and its canonical `-check.log`.
