# October 9 round-three save-menu review fixes

## S4: cursor tables and local state

`CSaveMenuClass::KeyStep` owns `static char *tbl[2]` and
`static char *tp[3]` immediately before their respective cursor-action uses.
Their LOCAL retail objects are `tbl$2023` (eight-byte `.sdata`) and
`tp$2083` (twelve-byte `.data`). `FormatCase` and `DarkClonicleFileMax`
retain retail spelling and their compiler-generated initialization guards.
These are the verified R source forms.

The opposite card is selected with `slot_form[!slot]`. The option caption
field is already `s8`, so its array index reads `config->caption_off`
directly, as verified by P3. The method signature uses `KeyStep()`, matching
nearby definitions. The manual fade-counter doc block and source spacing
follow the nearby style.

## Two-value message buffers with a sixteen-value request

The gyorace load-confirmation path in KeyStep creates `int values[2]`,
sets `{file_no, info->fish_num}`, and calls `SetMsgVolumeNo` with
`MES_VALUE_MAX` (sixteen). `SubGameSaveKey` likewise creates two integers
for slot number and total required size but requests sixteen. The callee
reads fourteen integers beyond each declared input array. This is the retail
call behavior, not evidence for sixteen-element caller buffers; enlarging
those arrays changes the caller's stack layout. Both calls now spell the
existing count `MES_VALUE_MAX`. No count or array extent changes.

## Position-array decision retained

`form_pos[9][2]` remains the accepted source shape. Its 72 bytes exactly
fill retail's `+0x120..+0x167` interval; only the first pair is accessed.
Matching smaller aggregates rely on alignment slack. The observed offsets
therefore favor this size without independently proving nine original pairs;
see [menuop-r0-20261009.md](menuop-r0-20261009.md).

The full pinned-image build verifies `SCES_511.90: OK`; all 149 canonical
objects pass. Function selection and compiler profile are unchanged.
Receipts: `.private/fixes-r3b/receipts/menuop-cleanup-{build,objects}.log`.
