# inventmn: ResetAddress, MenuInventKey and CalcTex

`MenuInventKey` and `CMenuInvent::CalcTex` are native and exact; the source
forms their matches depend on are in [notes.md](notes.md) under
"Matching-dependent source forms".

`CInventUserData::ResetAddress` remains a guarded draft. Retail recomputes the
invariant `this + 0xD60` row base inside each unrolled loop copy and again
before the two-photo remainder; a typed row pointer computes it once before the
loop inductions, so the setup words and the remainder differ while the
eight-assignment unrolled body is exact. See "Guarded functions" in
[notes.md](notes.md).
