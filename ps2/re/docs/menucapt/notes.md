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
| chap_voice_851 | .data 0x20 | `static char *[8]` local of MenuChapterInit | narration stream names "0060600.wav", "0270310.wav", "0360260.wav", "0420120.wav", "0500010.wav", "0600360.wav", "0700010.wav", "0800140.wav", indexed by `chapter` |
| wait_cnt_918/init_919 | .sbss | function-local static int in MenuChapterKey | set 0, otherwise unused |
| voiceflag_921/init_922 | .sbss | function-local static int in MenuChapterKey | set when the stream reports 0x8000 or the timeout passes |

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

## C++ draft status

All three runtime functions now have typed guarded C++ drafts. `MenuChapterStack` is declared as an `mgCMemory` in the guarded branch, so its constructor supplies the static initializer that retail uses to call `mgCMemory::Init`. The default build keeps all four retail assembly bodies. `CSnd` is defined in `mainloop.cpp` and declared with its `CSound` type in `mainloop.hpp`, which `menucapt.cpp` includes. The chapter voice table is an eight-entry pointer array indexed by the chapter number. The first image allocation rounds the loaded byte count up to quadwords, and the sound pack allocation does the same after reserving 0x280 quadwords for the temporary sound memory manager.

`draft.sh menucapt` compiles all four drafts: the three runtime functions differ and the compiler-generated static initializer matches retail. Each runtime function received one isolated `--promote-all` attempt and stayed guarded because its typed file-local globals are available only with `NONMATCHING`. A manual initializer-only promotion attempt moved `MenuChapterStack` to the default path; the link then failed because the ctor table could not resolve `__sinit_menucapt_cpp`, so the retail initializer and BSS marker remain on the default path. The default full build passes byte-identical verification.
