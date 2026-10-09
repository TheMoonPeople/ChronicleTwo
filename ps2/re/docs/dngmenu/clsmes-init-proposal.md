# ClsMes::Init emission

`Init__6ClsMesFv` at 0x001F38E0 is emitted in dngmenu from the unchanged
inline definition in `nd_meswin.hpp`. The natural `CMenuTreeMap` constructor,
with its real eight-window `CDC2Mes` member array and attachment loop, gives
MWCC the call context that makes it emit the body as a standalone function:
all 176 words of its 0x2C0 manifest reservation match, comprising 0x2B8 native
bytes and eight bytes of alignment padding. No shared-header change is needed.

Moving the inline definition out of the shared header into dngmenu.cpp also
produces all 174 nonpadding instructions, but it changes other callers'
inlining and is not used; the in-header definition is sufficient.
