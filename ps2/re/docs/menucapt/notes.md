# menucapt notes

Chapter title screen run by the main menu (MenuModeID `MENU_MODE_CHAPTER` = 17). MenuMainInit's
open-type case 0xB sets `MenuCommonInfo+0x54 = 0x11` and calls
`MenuChapterInit(&MenuMainStack, MenuCommonInfo+0xC, 0xB, DAT_01efc668)`. No first-game
counterpart. The unit owns no class (`class_units.tsv` has no entry).

## Globals (all LOCAL in retail -> `static` in the .cpp, not in the header)
| Symbol | Section/size | Type | Use |
|---|---|---|---|
| MenuChapterMode | .sbss 4 | int (MenuChapterModeID) | 0/1/2 switch in MenuChapterKey; Init sets 0 |
| MenuChapterInfo | .sbss 4 | MENU_CHAPTER_INFO* | `Alloc(2)` from MenuChapterStack (2 qwords = 0x20) |
| MenuChapterBG | .sbss 4 | mgCTexture* | GetTexture("chapbg", -1) |
| MenuChapter_Logo | .sbss 4 | mgCTexture* | GetTexture("chaplogo", -1) |
| MenuChapterSnd_ID | .sbss 4 | int | sndLoadSound(8, ...) result; sndSePlay(id,0,0) at counter 0x24 |
| menu_snd_counter | .sbss 4 | int | frame counter for sound steps |
| menu_chap_error_check_cnt | .sbss 4 | int | timeout: >0x5DC (1500) frames forces voice-done |
| MenuChapterStack | .bss 0x30 | mgCMemory | `__sinit` calls `mgCMemory::Init`; stSetBuffer from caller stack top (`stack+0x20 + stack+0x24*16`) |

Defining `MenuChapterStack` as a file-scope `mgCMemory` generates the retail
`__sinit_menucapt_cpp` initializer automatically. Its instruction stream matches exactly,
and the object keeps a 0x30-byte BSS section.
| chap_voice_851 | .data 0x20 | `static char *chap_voice[8]` local of MenuChapterInit | narration stream names "0060600.wav", "2070310.wav", "3060260.wav", "4020120.wav", "5000010.wav", "6000360.wav", "7000010.wav", "8000140.wav", indexed by `chapter` |
| wait_cnt_918/init_919 | .sbss | `static u32 wait_cnt = 0` local of MenuChapterKey | only reset, never advanced or read |
| voiceflag_921/init_922 | .sbss | `static u32 voiceflag = 0` local of MenuChapterKey | set when the stream reports 0x8000 or the 1,500-frame timeout passes |

The two function-local statics are declared after `finished = 0;`: MWCC runs
their zero-initialisation guards at the declaration point, and retail fills the
first guard's delay slot with that store. The `init_*` flags have declared size
one; their three-byte alignment gaps are piece padding.

Strings: "chap%d.img" (fallback "chap0.img"), "chapbg", "chaplogo", "snd2/sp/SP_007.snd".

## MENU_CHAPTER_INFO (name not retail; size 0x20 from Alloc(2) in qwords)
| Off | Type | Name | Evidence |
|---|---|---|---|
| 0x0 | int[2] | tex_block | copied from `param_2[0..1]` (= CMenuKeyFunc+0xC texture block array per menumain notes); [0] passed as `block` to EnterIMGFile and ReloadTexture |
| 0x8 | 0x10 bytes | unk_8 | never accessed |
| 0x18 | int | show_cnt | lw/sw +1 per frame in mode 1, zeroed on entering mode 1, `>300` with menu_snd_counter `>0x159` triggers FadeOut |
| 0x1C | float | logo_alpha | lwc1 in Draw (fptosi -> Color alpha); `CalcMenuAdd(&logo_alpha, 3.0, 128.0)` in mode 0; Init stores 0 |

## MenuChapterModeID (names not retail)
0 fade in (waits FadeCheck, at counter 2 sets stream vol 0x7FFF and plays stream 1, raises logo alpha;
done -> mode 1), 1 show, 2 fade out (`FadeOut(0x3C, 0,0,0)`; returns 1 once FadeCheck is done).

## Functions
- `MenuChapterInit(mgCMemory *stack, int *tex_block, int open_type, int chapter)`: `open_type`
  (3rd arg) is unused in the body; MenuMainInit passes 0xB. Name chosen from that call site.
- `MenuChapterKey()` returns int 0/1 (v0 = 1 only in mode 2 after the fade).
- `MenuChapterDraw()` void: DrawMenuFillBox(0x80,0,0,0), BG quad 512x0x1C0 -> 512xmgScreenHeight,
  logo quad (src rect 0,0,512,64) at y = screenH/2 - 32 - 12 with logo_alpha, then a second quad
  from src (0,64,512,64) at (0,0) with full alpha.
- Uses of `CSnd` (CSound, mainloop) stream channel 1, `MenuMainScene+0x2C70` (CFadeInOut).

## Source forms the match depends on

- `MenuChapterInit`: `LoadFile2((char *) "snd2/sp/SP_007.snd", sound_buffer,
  (int *) &file_size, 0)`. Without the cast on the string literal MWCC sets up
  `a2` (`&file_size`) before the literal's address in `a0`; retail sets up `a0`
  first. `file_size` is `u_int` for the unsigned size arithmetic around the
  call, so `&file_size` keeps its `(int *)` conversion.
- `MenuChapterInit`: the temporary sound-memory manager is an anonymous
  `union { mgCMemory sound_memory; }`; a plain `mgCMemory` local changes the
  frame layout and the stack offsets after +0x1AC.

All four functions, including the compiler-generated `__sinit_menucapt_cpp`,
are native and match; no assembly or data markers remain.
