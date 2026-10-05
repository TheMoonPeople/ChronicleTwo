#include "movieviewlp.hpp"
#include "dataread.hpp"
#include "font.hpp"
#include "gaiji.hpp"
#include "movie.hpp"
#include "prespr.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"

#include <cstdio>
#include <cstring>

extern "C" SPI_TAG_PARAM tag_movie[];
extern "C" void *__ct__18CScriptInterpreterFv(void *);
extern "C" void *__ct__11mgCDrawPrimFv(void *);
extern CMovie *MovieView;
extern int MovieMode;
extern short MovieSelect;
extern short MovieLine;
extern short MovieSpecialMode;
extern short MovieSpecialModeInfo[3];
extern CScene *MovieScene;
extern mgCTexture *RushWork__2;
extern mgCMemory Stack_ReadBuff__2;
extern mgCMemory DataBuffer__2;
extern mgCMemory buf0_791;
extern mgCMemory buf1_794;
extern mgCMemory dbuf0_797;
extern mgCMemory dbuf1_800;
extern signed char init_792;
extern signed char init_795;
extern signed char init_798;
extern signed char init_801;
extern char at_843__4[];
extern char at_844__3[];
extern char at_1028__8[];
extern char at_1029__6[];
extern char at_1030__5[];
extern char at_1031__5[];
extern char at_1032__6[];
extern char at_1033__7[];
extern char at_1034__5[];
extern char at_1035__5[];
extern char at_1036__5[];
extern char at_1037__5[];
extern MOVIE_LIST_ENTRY *MovieList;
extern int MovieListNum;
extern mgCMemory *spi_MovieStack;
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "gaiji.hpp"
#include "dataread.hpp"
#include "movie.hpp"
#include "scenesnd.hpp"
#include "gamepad.hpp"
#include "prespr.hpp"
#include "font.hpp"
#include <cstdio>
#include <cstring>
#include "mglib.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"

// File-local data supplied by the retail assembly while data migration is pending.
extern CGamePad GamePad__2;
extern CScene *MovieScene;
extern CMovie *MovieView;
extern mgCTexture *RushWork__2;
extern MOVIE_LIST_ENTRY *MovieList;
extern int MovieListNum;
extern short MovieLine;
extern short MovieSelect;
extern short MovieSpecialMode;
extern short MovieSpecialModeInfo[3];
extern int MovieMode;
extern SPI_TAG_PARAM tag_movie[];
extern mgCMemory buf0_791, buf1_794, dbuf0_797, dbuf1_800;
extern mgCMemory *spi_MovieStack;
extern int performance_meter_flag;
extern mgCMemory DataBuffer__2;
extern mgCMemory Stack_ReadBuff__2;

static inline int movieFreeBlocks(mgCMemory *memory) {
    return memory->stack_size - memory->stack_used;
}

static inline u_char *movieFreeTop(mgCMemory *memory) {
    return memory->stack_bytes + memory->stack_used * 16;
}

// Code (.text)
int _MOVIE(SPI_STACK *stack, int argument_count) {
    MOVIE_LIST_ENTRY *entry = MovieList + MovieListNum;
    if (entry == NULL) {
        return 0;
    }
    char *name = spiGetStackString(stack++);
    char *subtitle = spiGetStackString(stack++);
    int value = -1;
    if (argument_count >= 3) {
        value = spiGetStackInt(stack);
    }
    if (entry != NULL) {
        entry->name = mgCopyString(name, spi_MovieStack);
        entry->file_name = mgCopyString(subtitle, spi_MovieStack);
        entry->bgm_no = value;
    }
    MovieListNum++;
    return 1;
}
void MovieViewInit(INIT_LOOP_ARG arg) {
    mgCMemory *main_stack;
    mgCTextureManager *textures;
    void *packet_a;
    void *packet_b;
    char script[0x5000];
    int script_size;
    int read_size;
    char *script_ptr;
    u_char interpreter[0xED0];
    short *special_info;

    MovieScene = GetMainScene();
    MovieScene->Initialize();
    mgInitFont();
    main_stack = GetMainStack();
    main_stack->stack_used = 0;
    main_stack->lock = 0;
    if (init_792 == 0) {
        buf0_791.Init();
        init_792 = 1;
    }
    if (init_795 == 0) {
        buf1_794.Init();
        init_795 = 1;
    }
    if (init_798 == 0) {
        dbuf0_797.Init();
        init_798 = 1;
    }
    if (init_801 == 0) {
        dbuf1_800.Init();
        init_801 = 1;
    }
    packet_a = main_stack->stAlloc64(0x2710);
    packet_b = main_stack->stAlloc64(0x2710);
    mgInitVif1Packet((u_long128 *)packet_a, (u_long128 *)packet_b, 0x27100);
    buf0_791.stSetBuffer((u_long128 *)main_stack->stAlloc64(0x7530), 0x7530);
    buf1_794.stSetBuffer((u_long128 *)main_stack->stAlloc64(0x7530), 0x7530);
    dbuf0_797.stSetBuffer((u_long128 *)main_stack->stAlloc64(0xEA60), 0xEA60);
    dbuf1_800.stSetBuffer((u_long128 *)main_stack->stAlloc64(0xEA60), 0xEA60);
    DataBuffer__2.stSetBuffer((u_long128 *)main_stack->stAlloc64(0x186A0), 0x186A0);
    mgSetPacketBuffer(&buf0_791, &buf1_794);
    mgSetDataBuffer(&dbuf0_797, &dbuf1_800, 1);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetTextureTable(0x64, 0x14, &DataBuffer__2);
    textures = &mgTexManager;
    textures->EnterIMGFile((u8 *)GetGaijiImgPtr(), 0, NULL, NULL);
    ReLoadFontTexture(0);
    textures->EnterIMGFile((u8 *)GetFontTex2ImgPtr(), 0, NULL, NULL);
    MovieView = (CMovie *)operator new(sizeof(CMovie), (u_long128 *)main_stack->Alloc(0x2396));
    MovieListNum = 0;
    MovieList = (MOVIE_LIST_ENTRY *)operator new[](0x300, (u_long128 *)main_stack->Alloc(0x32));
    MovieLine = 0;
    MovieSelect = 0;
    MovieMode = 0;
    spi_MovieStack = main_stack;
    script_ptr = script;
    if (LoadFile2(at_843__4, script_ptr, &script_size, 0) != 0) {
        __ct__18CScriptInterpreterFv(interpreter);
        ((CScriptInterpreter *)interpreter)->SetTag(tag_movie);
        ((CScriptInterpreter *)interpreter)->SetScript(script_ptr, script_size);
        ((CScriptInterpreter *)interpreter)->Run();
    }
    main_stack->Align64();
    read_size = movieFreeBlocks(main_stack);
    Stack_ReadBuff__2.stSetBuffer((u_long128 *)movieFreeTop(main_stack), read_size);
    Stack_ReadBuff__2.stack_used = 0;
    Stack_ReadBuff__2.lock = 0;
    Stack_ReadBuff__2.Align64();
    special_info = MovieSpecialModeInfo;
    special_info[0] = 0;
    special_info[1] = 0;
    MovieSpecialMode = 0;
    special_info[2] = 0;
    textures->EnterTexture(0xA, at_844__3, NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth,
                           0, 0, 0);
    RushWork__2 = textures->GetTexture(at_844__3, 0xA);
    performance_meter_flag = mgGetPerformanceMeterFlag();
    mgPerformanceMeter(0);
}
void MovieViewExit() {
    sndSeAllStop(-1);
    mgCloseFont();
    mgPerformanceMeter(performance_meter_flag);
}
int MovieViewLoop(void) {
    mgCTextureManager *textures = &mgTexManager;
    struct {
        u_char font[0x94];
        int draw_x;
        int draw_y;
        u_char rest[0xB8 - 0x9C];
    } menu_font;
    char row_text[0x100];
    u_char prim[sizeof(CPreSprite)];
    char part_path[0x40];
    MOVIE_LIST_ENTRY *entry;
    int row_y;
    int i;
    int entry_offset;

    if (MovieMode == 0) {
        if (GamePad__2.Down(0x800) != 0 || GamePad__2.Down(0x40) != 0) {
            return 1;
        }
        if (GamePad__2.Down(0x1000) != 0) {
            MovieSelect -= 1;
        }
        if (GamePad__2.Down(0x4000) != 0) {
            MovieSelect += 1;
        }
        if (GamePad__2.Down(4) != 0) {
            MovieSelect -= 7;
        }
        if (GamePad__2.Down(8) != 0) {
            MovieSelect += 7;
        }
        if (MovieSelect < 0) {
            MovieSelect = 0;
        }
        if (MovieListNum <= MovieSelect) {
            MovieSelect = MovieListNum - 1;
        }
        if (MovieSelect < MovieLine) {
            MovieLine -= 1;
        }
        if (MovieLine < 0) {
            MovieLine = 0;
        }
        if (MovieLine + 7 < MovieSelect) {
            MovieLine += 1;
        }
        if (GamePad__2.Down(0x20) != 0) {
            Stack_ReadBuff__2.stack_used = 0;
            Stack_ReadBuff__2.lock = 0;
            entry = MovieList + MovieSelect;
            textures->ReloadTexture(0xA, (sceVif1Packet *)0);
            if (0 < entry->bgm_no) {
                MovieScene->StopBGM(0);
                MovieScene->LoadBGM(
                    entry->bgm_no,
                    (u_long128 *)movieFreeTop(&Stack_ReadBuff__2));
                MovieScene->PlayBGM(0, -1, 1.0f);
            }
            MovieSpecialMode = 0;
            if (strcmp(entry->name, at_1028__8) == 0) {
                MovieSpecialMode = 1;
                MovieSpecialModeInfo[0] = 1;
                MovieView->Load(at_1029__6, &Stack_ReadBuff__2, 0x200, 0x1A0, true, false);
                MovieView->Play(at_844__3);
                MovieView->SwitchThread();
                while (MovieView->IsStarted() == 0) {
                    MovieView->SwitchThread();
                }
            } else if (strcmp(entry->name, at_1030__5) == 0) {
                MovieSpecialMode = 2;
                MovieSpecialModeInfo[0] = 1;
                MovieView->Load(at_1031__5, &Stack_ReadBuff__2, 0x200, 0x1A0, true, false);
                MovieView->Play(at_844__3);
                MovieView->SwitchThread();
                while (MovieView->IsStarted() == 0) {
                    MovieView->SwitchThread();
                }
            } else {
                MovieView->Load(entry->file_name, &Stack_ReadBuff__2, 0x200, 0x1A0, true, false);
                MovieView->Play(at_844__3);
                MovieView->SwitchThread();
                while (MovieView->IsStarted() == 0) {
                    MovieView->SwitchThread();
                }
            }
            MovieMode = 1;
        }
        textures->ReloadTexture(0, (sceVif1Packet *)0);
        ((CFont *)menu_font.font)->Init();
        ((CFont *)menu_font.font)->Init();
        ((CFont *)menu_font.font)->SetClearance(0x10, 0x14);
        ((CFont *)menu_font.font)->SetFuchi(5);
        ((CFont *)menu_font.font)->SetColor(0x80686A6BU);
        sprintf(row_text, at_1032__6, at_1033__7, at_1034__5);
        i = MovieLine;
        row_y = 0x28;
        entry_offset = i * 0xC;
        while (i < MovieLine + 8 && i < MovieListNum) {
            sprintf(row_text, at_1035__5, i, *(char **)((u8 *)MovieList + entry_offset));
            if (i == MovieSelect) {
                row_text[1] = '>';
            }
            ((CFont *)menu_font.font)->SetStr(row_text);
            ((CFont *)menu_font.font)->SetPos(0x28, row_y);
            ((CFont *)menu_font.font)->DrawDirect((char *)&menu_font, menu_font.draw_x, menu_font.draw_y);
            row_y += 0x14;
            if (row_y >= 0xC9) {
                break;
            }
            entry_offset += 0xC;
            i++;
        }
        return 0;
    }
    if (MovieMode == 1) {
        mgPerformanceMeter(0);
        textures->ReloadTexture(0xA, (sceVif1Packet *)0);
        MovieView->SwitchThread();
        __ct__11mgCDrawPrimFv(&prim);
        ((CPreSprite *)prim)->Initialize(NULL, NULL);
        ((CPreSprite *)prim)->Preset2D();
        ((CPreSprite *)prim)->AlphaBlendEnable(0);
        ((CPreSprite *)prim)->TextureMapEnable(1);
        ((CPreSprite *)prim)->Begin(6);
        ((CPreSprite *)prim)->Color(0, 0, 0, 0x80);
        ((CPreSprite *)prim)->SetIRect(0, 0, 0x200, 0x1A0, 0, 0);
        ((CPreSprite *)prim)->Texture(RushWork__2);
        ((CPreSprite *)prim)->Color(0x80, 0x80, 0x80, 0x80);
        ((CPreSprite *)prim)->SetIRect(0, 0, 0x200, mgScreenHeight, 0, 0);
        ((CPreSprite *)prim)->End();
        if (GamePad__2.Down(8) != 0 || GamePad__2.Down(2) != 0 ||
            GamePad__2.Down(4) != 0 || GamePad__2.Down(1) != 0) {
            mgPerformanceMeter(mgGetPerformanceMeterFlag() ^ 1);
        }
        if (MovieView->EndCheck() != 0 || GamePad__2.Down(0x800) != 0) {
            MovieView->Term();
            MovieView->SwitchThread();
            MovieMode = 0;
            MovieScene->StopBGM(0);
            Stack_ReadBuff__2.stack_used = 0;
            Stack_ReadBuff__2.lock = 0;
            if (MovieSpecialMode == 1 || MovieSpecialMode == 2) {
                MovieSpecialModeInfo[0] += 1;
                if (MovieSpecialModeInfo[0] < 4) {
                    MovieMode = 1;
                    if (MovieSpecialMode == 1) {
                        sprintf(part_path, at_1036__5, MovieSpecialModeInfo[0]);
                    }
                    if (MovieSpecialMode == 2) {
                        sprintf(part_path, at_1037__5, MovieSpecialModeInfo[0]);
                    }
                    MovieView->Load(part_path, &Stack_ReadBuff__2, 0x200, 0x1A0, true, false);
                    MovieView->Play(at_844__3);
                    MovieView->SwitchThread();
                    while (MovieView->IsStarted() == 0) {
                        MovieView->SwitchThread();
                    }
                } else {
                    MovieSpecialModeInfo[0] = 0;
                    MovieSpecialMode = 0;
                }
            }
            return 0;
        }
    }
    return 0;
}

// Static initialiser (.init)
extern "C" void __sinit_movieviewlp_cpp() {
    DataBuffer__2.Init();
    Stack_ReadBuff__2.Init();
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", tag_movie__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", at_786__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", at_843__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", at_844__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", at_1028__8__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", at_1029__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", at_1030__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", at_1031__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", at_1032__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", at_1033__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", at_1034__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", at_1035__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", at_1036__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", at_1037__5__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/movieviewlp", D_0037B064__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(MovieScene, 0x4);
INCLUDE_BSS(MovieView, 0x4);
INCLUDE_BSS(RushWork__2, 0x4);
INCLUDE_BSS(performance_meter_flag, 0x4);
INCLUDE_BSS(MovieListNum, 0x4);
INCLUDE_BSS(MovieList, 0x4);
INCLUDE_BSS(MovieLine, 0x4);
INCLUDE_BSS(MovieSelect, 0x4);
INCLUDE_BSS(spi_MovieStack, 0x4);
INCLUDE_BSS(MovieSpecialMode, 0x4);
INCLUDE_BSS(MovieSpecialModeInfo, 0x8);
INCLUDE_BSS(MovieMode, 0x4);
INCLUDE_BSS(init_792, 0x4);
INCLUDE_BSS(init_795, 0x4);
INCLUDE_BSS(init_798, 0x4);
INCLUDE_BSS(init_801, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(DataBuffer__2, 0x30);
INCLUDE_BSS(Stack_ReadBuff__2, 0x30);
INCLUDE_BSS(buf0_791, 0x30);
INCLUDE_BSS(buf1_794, 0x30);
INCLUDE_BSS(dbuf0_797, 0x30);
INCLUDE_BSS(dbuf1_800, 0x30);
