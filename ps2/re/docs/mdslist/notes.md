# mdslist: reverse-engineering notes

## Native source status

All 31 functions have active C++ bodies. `CMapPiece::Copy` and the file-local
`CreateChara` are accepted native callers with one scoped `CCharacter2`
placement row each. No `NONMATCHING` guards or assembly fallbacks remain.
See [placement conversion](../satansfiddle/placement-new.md).
Earlier promotion attempts in `scripts/re/promotion_attempts.tsv` describe
prior source/profile boundaries.

The unit loads PCP pack files (lists of MDS model / collision / character data driven by an
`info.cfg` script inside the pack), records IMG texture files, and implements `CMapPiece`, the
per-piece object of a map part. There is no counterpart in the first game (no `CMdsList`,
`CMapPiece` or `pcp*` there).

## Layout probing
MWCC packs arrays at natural (4-byte) alignment here; probe structs confirmed `{int; T[8] (16-byte
T); int; ...}` puts the second int at 0x84. So the 12 bytes at `CMdsListSet+0x4` are real
(unknown) data, not padding. Note: `STATIC_ASSERT` reuses one typedef name
(`_static_assert___COUNTER__`, `##` stops expansion), so when probing use uniquely named
`typedef char x[(cond)?1:-1];` lines.

All non-member functions (`pcpMDS`, `pcpTYPE`, `pcpFAR_CLIP`, `pcpMDS_END`, `CreateChara`) and all
data (`pcp_tag`, `now_mds_num`, `max_mds_num`, `pcpMdsList`, `pcpMdsInfo`, `pcpNowMdsInfo`,
`pcpStack`, `pcp_file`, `pcpAllScissor`) are LOCAL in retail -> `static` in the .cpp, nothing in
the header.

## CMdsInfo (0x20, asserted)
Size: `__construct_new_array(..., __ct__8CMdsInfoFv, 0, 0x20, n)` in `CMdsList::LoadPCPFile`;
`GetList(int)` stride 0x20.
| off | field | evidence |
|---|---|---|
| 0x00 | `char *name` | pcpMDS strcpy's the script string into Alloc'd memory; GetListID strcasecmp |
| 0x04 | `s32 type` (MdsType) | pcpTYPE; pcpMDS_END switch |
| 0x08 | `mgCFrame *frame` | pcpMDS_END result; AssignMds -> CObjectFrame::frame (0x70) |
| 0x0C | `CCharacter2 *chara` | CreateChara result; AssignMds -> CMapPiece+0x9C |
| 0x10 | `float far_dist` | Initialize = -1.0f; pcpFAR_CLIP arg 0 (float); AssignMds -> CObject+0x50 (far distance, see CObject::FarClip/CheckDraw) |
| 0x14 | `s32 far_fade` | pcpFAR_CLIP arg 1 (int); AssignMds -> CObject+0x54 (non-zero = fade alpha at +0x58) |
| 0x18 | vptr | ctor stores `__vt__8CMdsInfo` at +0x18 (data declared before the first virtual precede the vptr in MWCC) |
| 0x1C | `unk_1c` | never touched |

Vtable `__vt__8CMdsInfo` (0xC): `{0, 0, Initialize}`. Initialize zeroes 0..0xC, 0x14, sets 0x10 = -1.0f.
Ctor `__ct__8CMdsInfoFv` (0x16AC90) is emitted after the last address-ordered function and only
referenced by address from `__construct_new_array`, so it is declared inline
(`CMdsInfo() { Initialize(); }`); vtable lands in mdslist because Initialize (non-inline) is here.

## MdsType
Values stored in `CMdsInfo::type` / `CMapPiece::type`: 0 model (`mgLoadMDSFile`), 1 collision
(`LoadCollisionFile`; `CMapParts::GetColPoly` asks type 1), 3 camera collision
(`LoadCollisionFile`; `CMapParts::GetCameraPoly` asks type 3), 4 character (`CreateChara`).
Bit 0 => not drawn (`DrawSub` tests `type & 1`); bit 2 => character (`CMapParts::AddPiece` sets its
step flag on `type & 4`). The script `TYPE` value differs: pcpTYPE maps script 0->0, 1->1, 2->3,
3->4, 4->4, others kept unchanged. Retail enum name unknown; `MdsType` is ours.

## CMdsList (0x10, asserted)
Stride 0x10 in CMdsListSet (`SearchMdsList` returns `this + i*0x10 + 0x10`).
0x0 `char *name` (strcpy'd pack name, strcmp in SearchMdsList), 0x4 `s32 num` (count of `mds`+`chr`
pack entries, warns `"over pcp %d\n"` above 0x1FF), 0x8 `CMdsInfo *list`, 0xC unk (DeleteMdsList
and LoadPCPFile's free-slot test only touch 0..8).
`LoadPCPFile` returns void (no v0 set after `Run`). `GetList(int)` bounds `0 <= i < num`.

## CIMGList (0x8, asserted)
Stride 8 in CMdsListSet. 0x0 `char *name`, 0x4 `mgCEnterIMGInfo *info`: LoadIMGFile allocates
`Alloc(0x12)` (0x120 bytes) and placement-news 0x100 bytes, copying the caller's 0x100-byte
`mgCEnterIMGInfo` (declared in mg_texture.hpp: `int start[32]` at 0, `int count[32]` at 0x80, as
used by GetTextureBlockNo and mgCTextureManager::EnterIMGFile). Name alloc is `Alloc((len+1+15)/16)`.

## CMdsListSet (>= 0x114, size NOT asserted)
| off | field | evidence |
|---|---|---|
| 0x00 | `s32 mds_list_num` | Initialize = 8; loop bound |
| 0x04 | `u8 unk_4[0xC]` | never touched |
| 0x10 | `CMdsList mds_list[8]` | Initialize zeroes +0x10/0x14/0x18 at stride 0x10 |
| 0x90 | `s32 img_list_num` | Initialize = 16 |
| 0x94 | `CIMGList img_list[16]` | stride 8 |
Fields end at 0x114. Instances: `CScene+0x23D0` (next known member at +0x24F0) and a global at
0x1DFD500 (next object, an mgCTexture, at 0x1DFD620): both leave 0x120, so the size is 0x114 or up
to 0x120 with trailing unknowns; unresolved.
`GetMdsList(int i)` tests `i < 0 || num < i` (accepts i == num, an off-by-one in retail).
SearchMDS loops i = 0.. until GetMdsList returns NULL, so i == 8 treats `this+0x90`
(img_list_num / img_list[0]) as a CMdsList -- reproduce as is.
`GetTextureBlockNo(group, out, max)` returns the count in v0 (EditDraw uses it); ghidra shows void.
Return types: LoadPCPFile/LoadIMGFile/DeleteMdsList return 0/1 (int); DeleteIMG void.

## CMapPiece (0xB0, asserted) : CObjectFrame
Size: editmap `emap*_PARTS_NAME` do `new(Alloc(0xD)) ... __nw(0xB0)` with the ctor chain inlined;
`CList<CMapPiece>` (0xD0 alloc) has data at +0x10 and its vptr at +0xC0 (so CMapPiece is 16-aligned,
from CObjectFrame). Own fields start at 0x80, so this assumes sizeof(CObjectFrame) == 0x80 (verified
here with a stub only; object.hpp/map.hpp are other agents').
| off | field | evidence |
|---|---|---|
| 0x80 | `char *name` | SetName; CMapParts::SearchPiece strcmp (node[0x24]) ; AssignMds copies CMdsInfo::name |
| 0x84 | `s32 type` | AssignMds from info->type; GetPoly compares param; DrawSub `& 1`; AddPiece `& 4` |
| 0x88 | `s32 draw_enable` | Initialize = 1; DrawSub returns 0 when zero; Copy copies |
| 0x8C | `s32 material_num` | SetMaterial; GetMaterial bound; Copy alloc count |
| 0x90 | `PieceMaterial *material` | stride 0x20; Copy `__construct_new_array(..., __ct__13PieceMaterialFv, 0, 0x20, n)` |
| 0x94 | `float time_start` | SetTimeBand; CMapParts::DrawSub `CheckTime(now, [0x29], [0x2a])` |
| 0x98 | `float time_end` | same |
| 0x9C | `CCharacter2 *chara` | AssignMds; Step calls chara vt+0xD4; Copy news a CCharacter2 (0x660) and calls src chara vt+0xEC (Copy) |
| 0xA0 | `s16 col_type` | mapPIECE_COL_TYPE arg 0; GetPoly requires 0; SearchPieceColType |
| 0xA2 | `s16 col_param` | mapPIECE_COL_TYPE optional arg 1; Initialize clears it and Copy does not copy it; meaning unknown |
0xA4..0xAF: tail padding to 16-byte alignment (no access seen).

Vtable `__vt__9CMapPiece` (0x7C) is CObjectFrame's with three overrides: slot 0x34 `Draw`, 0x38
`DrawDirect`, 0x3C `Initialize`. No new virtuals. `Copy(CMapPiece&, mgCMemory*)` is NON-virtual
(slot 0x78 stays `CObjectFrame::Copy`); it calls `dest.Initialize()` virtually, then
`CObjectFrame::Copy(dest, stack)` qualified, then copies fields into `dest` (this is the source).
Vtable slots used: 0x3C Initialize, 0x58 GetShow (GetPoly), 0x74 UpDatePosition (GetPoly,
GetBoundBox, Step). GetBoundBox calls `frame->vt+0x40` = `mgCFrame::GetWorldBBox(mgVu0FBOX*)`.

Inline members emitted elsewhere: ctor (mapload 0x1637E0, also inlined in editmap), SetName and
SetMaterial (mapload) -> defined in the class body. `Draw`/`DrawDirect` (mapparts 0x168250 /
0x168240, each `j DrawSub` with 0/1) are declared non-inline here, so that `Initialize` (declared
first among the overrides) is the key function keeping the vtable in mdslist; their bodies belong
in mapparts.cpp (`return DrawSub(0)` / `return DrawSub(1)`). If the vtable placement does not match,
revisit this.

DrawSub: for up to 4 materials (stack buffer of 4 x 16 bytes at sp+0x20) it saves the 16 bytes at
`material[i]+8 -> *` (the mgCMaterial colour), writes `material[i]+0x10` (the piece colour) into it,
draws via CObjectFrame::Draw/DrawDirect, then restores; returns the draw result. Note the buffer is
indexed by material without a bound of 4.

## PieceMaterial (owned by mapload; forward-declared)
0x20 bytes: 0x0 `mgCFrame*` (SearchFrame by name), 0x4 int material index, 0x8 material pointer
(`mgCFrame::GetMaterial`), 0xC int, 0x10..0x1C float colour[4] (sceVu0FVECTOR, lq/sq).

## CreateChara (static)
`new(stack->Alloc(0x68)) CCharacter2` (0x660 bytes, ctor chain inlined), then
`chara->vt+0x3C` (Initialize) and `vt+0x80(pack, "info.cfg", stack, stack, stack, -1, 0)`; returns
the character or NULL. Its active C++ body uses typed placement construction.
The scoped compiler conversion preserves retail's save of the allocation result
from `v0` to `s0` in the null branch's delay slot. On success, the compiler-generated constructor chain runs
`mgCObject`, `CObject`, `CObjectFrame`, and `CCharacter2` initialization; the
function then calls `Initialize` once more before `LoadPackNoLine`. The native
caller is covered by the complete-object and PAL acceptance.

## CMapPiece::Copy

Copies the piece's frame, metadata, material records, and optional character
into the destination. Its accepted native character allocation uses typed
placement construction and the scoped compiler conversion.

## Matched slot clearing
`CMapPiece::SetTimeBand` writes the start and end floats to its named members.
`CMdsInfo::Initialize` clears the name, model, character and fade fields, chooses
`MDS_TYPE_MODEL`, and sets `far_dist` to -1.0f. `DeleteMdsList` clears only the
name, count and entry pointer of a found pack slot; `DeleteIMG` clears only the
name and image info pointer of a found image slot. These operations do not release
allocated storage.
