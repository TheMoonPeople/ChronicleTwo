# Natural SetCharacter construction residual

`SetCharacter__16CEffectScriptManFP11CCharacter2ii` stays guarded. Fresh pn15
current-profile compilation differs by 24 words. A private after-inline row
selecting its two witnessed CCharacter2 constructions leaves 21 words with
the inherited byte-address expression. Required typed slot access gives the
best measured hygienic result: 23 words, symbol body 0x29c within extent 0x2a0,
with equal relocation offsets/types. This is a bounded result, not proof
that every admissible source has that lower bound.

Twenty-one words exchange s1/s2 roles for the mutable table entry and new
character. Two more reverse commutative addu operands at +0x9c/+0xa0. The
negative-slot arm matches under the conversion. Neither the caller nor its
constructor chain contains floating instructions or a source float constant;
there is no genuine float argument identity for the supported float policy.

The manager is 0x1190, with work_memory at +0x4, its real 128-by-8 pointer
table at +0x184 and now at +0x1184. A script is 0x150, with chara_work +0x4
and chara +0x8. CCharacter2 is 0x660; virtual Copy and GetCopySize are +0xec
and +0xf0. Allocation retains the actual 0x68 quadword request. The mutable
entry's script is reloaded after allocation and virtual Copy, and now is
reloaded in the negative-slot branch. Caching either across callbacks changes
retail behavior. Existing failure exits before EndStackMode are retained.

Fourteen fresh controls measure typed entries, mutable/read-only references,
branch-local characters, immutable real pointer bindings, before timing,
conditional slot binding, a model-member reference, and an owner-row lifetime
between separate bounds checks. Hygienic reference and pointer forms remain
23; the conditional, model-member and row-lifetime forms reach 57, 101 and
140 respectively. Previously documented simple row staging and byte/pointer
spelling negatives are not claimed as novel controls.

Cleanup recovers the diagnostic at 0x00377510 with its exact newline, removes
its exclusive alias/storage, and uses MG_STACK_MODE_FIT. Native construction
keeps the documented base/derived vtables and shadow-link clears. All 184
nonselected scored rows and 188 emitted function bodies, bindings, sizes and
normalized relocation targets remain unchanged. BuildBase and AssignCharacter
remain zero; CreateEffSpt does not regress. One anonymous data number changes
in _INTERSECTION_POINT while its full referenced data fingerprint agrees.

The scorer's initially omitted unique local suffixes are corrected by
re-reading every saved object; original metrics remain archived. Fresh m2c,
type/literal witnesses, all controls, exact residual classification and final
audits are in `.private/pntc/effscript-setcharacter-natural/`. Its comment-only
shared-header size correction and scoped row stay private. No approximate
source or profile row is promoted.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
