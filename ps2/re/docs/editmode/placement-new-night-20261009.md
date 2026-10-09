# Georama cursor-model construction

`LoadEditCursor` loads the Georama system texture and the removal, paint,
shovel and unit cursor models, applies their frame attributes, and configures
the debug font. Its documented model and allocator types remain unchanged.
Its guard is removed by hand after complete source review.

The exact row is `editmode.cpp` / `LoadEditCursor__FP9mgCMemoryi` /
`__nw__FUiP1` / `__ct__11CCharacter2Fv`, with
`after_constructor_inline` and `expected_matches: 3`. Three separate scalar
character expressions are selected; model-file allocation is outside that
identity. The canonical 270-word construction schedule difference reaches
zero with the policy and the cleaned source.

Ten retail path/model literals are inlined and only their unused aliases
and data fragments are removed. The pack size output is a real `int`, matching
`GetPackFile`'s argument, instead of casting an unsigned local's address.
Both quadword-rounding branches cast its value to `u_int` before shifting,
preserving retail's logical right shifts. Leaving one branch signed introduces
one word difference. The known Z-write sentinel uses `MG_ZBUF_NO_WRITE`;
existing attribute-mask enums are retained. Font preset/outline values remain
numeric because their available owner documentation supplies no named enum.

Retail 0x002DDB30 is GLOBAL/FUNC, size 0x5B4 within extent 0x5C0. The header's
extent-based size has an exact private correction. pn14 checks the complete
resolved editmode object, all 149 units and `SCES_511.90: OK`, including the
twelve alignment bytes. Every assembled and source-only object outside the
twelve promoted units retains its baseline hash; linked main/game bytes and
loaded memory extent agree.

Receipts: `.private/pntc/receipts/natural-editmode-clean.log`,
`editmode-literal-recovery.json`, `promote-eighteen-pn14-clean-build.log`
and `.exit`, `promote-eighteen-pn14-clean-objects.log`, and
`promote-eighteen-pn14-clean-artifacts.json`.
The [design note](../satansfiddle/placement-new.md)
describes the intentional policy and its evidence limits.

Final marker-order validation also passes `promote-eighteen-final-build.log`,
`promote-eighteen-final-objects.log` (149/149), and
`promote-eighteen-final-artifacts.json`. Resolved game bytes and all objects outside the accepted units still agree.
Refreshed native coverage is 6,767 matched / 95 guarded / 10 assembly-only /
0 fuzzy, recorded in `promote-eighteen-coverage.log`.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
