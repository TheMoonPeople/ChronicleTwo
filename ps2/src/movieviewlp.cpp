#include "movieviewlp.hpp"

#include <cstdio>
#include <cstring>

#include "dataread.hpp"
#include "font.hpp"
#include "gaiji.hpp"
#include "gamepad.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "movie.hpp"
#include "prespr.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"

/**
 *
 * Scene used to display movies and play their music.
 *
 */
static CScene *MovieScene;

/**
 *
 * Movie player for the selected viewer entry.
 *
 */
static CMovie *MovieView;

/**
 *
 * Texture containing the current movie frame.
 *
 */
static mgCTexture *RushWork__2;

/**
 *
 * Performance meter setting restored when the viewer exits.
 *
 */
static int performance_meter_flag;

/**
 *
 * Number of configured movie entries.
 *
 */
static int MovieListNum;

/**
 *
 * Configured movies available to the viewer.
 *
 */
static MOVIE_LIST_ENTRY *MovieList;

/**
 *
 * First movie row displayed in the viewer list.
 *
 */
static short MovieLine;

/**
 *
 * Index of the selected movie entry.
 *
 */
static short MovieSelect;

/**
 *
 * Stack used to store movie names parsed from the configuration.
 *
 */
static mgCMemory *spi_MovieStack;

/**
 *
 * Promotional sequence currently selected for playback.
 *
 */
static short MovieSpecialMode;

/**
 *
 * Current part and additional state of a promotional sequence.
 *
 */
static short MovieSpecialModeInfo[3];

/**
 *
 * Current movie viewer list or playback mode.
 *
 */
static int MovieMode;

/**
 *
 * Texture data buffer used by the movie viewer.
 *
 */
static mgCMemory DataBuffer__2;

/**
 *
 * Read buffer for movie files and their accompanying music.
 *
 */
static mgCMemory Stack_ReadBuff__2;

// Code (.text)
/**
 *
 * Adds one configured movie and its optional music to the viewer list.
 *
 */
static int _MOVIE(SPI_STACK *stack, int argument_count) {
    MOVIE_LIST_ENTRY *entry = MovieList + MovieListNum;

    if (entry == NULL) {
        return 0;
    }

    char *name = spiGetStackString(stack++);
    char *subtitle = spiGetStackString(stack++);
    int   value = -1;

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

/**
 *
 * Script tags accepted by the movie viewer configuration.
 *
 */
static SPI_TAG_PARAM tag_movie[2] = {
    {"MOVIE", _MOVIE},
    {NULL, NULL},
};

void MovieViewInit(INIT_LOOP_ARG arg) {
    mgCMemory         *main_stack;
    mgCTextureManager *textures;
    u_long128         *packet_a;
    u_long128         *packet_b;
    char               script[0x5000];
    int                script_size;
    int                read_size;
    char              *script_ptr;
    short             *special_info;

    MovieScene = GetMainScene();
    MovieScene->Initialize();
    mgInitFont();
    main_stack = GetMainStack();
    main_stack->stack_used = 0;
    main_stack->lock = 0;

    /**
     * First packet buffer manager.
     */
    static mgCMemory buf0;

    /**
     * Second packet buffer manager.
     */
    static mgCMemory buf1;

    /**
     * First draw-data buffer manager.
     */
    static mgCMemory dbuf0;

    /**
     * Second draw-data buffer manager.
     */
    static mgCMemory dbuf1;

    packet_a = main_stack->stAlloc64(0x2710);
    packet_b = main_stack->stAlloc64(0x2710);
    mgInitVif1Packet(packet_a, packet_b, 0x27100);
    buf0.stSetBuffer(main_stack->stAlloc64(0x7530), 0x7530);
    buf1.stSetBuffer(main_stack->stAlloc64(0x7530), 0x7530);
    dbuf0.stSetBuffer(main_stack->stAlloc64(0xEA60), 0xEA60);
    dbuf1.stSetBuffer(main_stack->stAlloc64(0xEA60), 0xEA60);
    DataBuffer__2.stSetBuffer(main_stack->stAlloc64(0x186A0), 0x186A0);
    mgSetPacketBuffer(&buf0, &buf1);
    mgSetDataBuffer(&dbuf0, &dbuf1, 1);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetTextureTable(0x64, 0x14, &DataBuffer__2);
    textures = &mgTexManager;
    textures->EnterIMGFile(GetGaijiImgPtr(), 0, NULL, NULL);
    ReLoadFontTexture(0);
    textures->EnterIMGFile(GetFontTex2ImgPtr(), 0, NULL, NULL);
    MovieView = new (main_stack->Alloc(0x2396)) CMovie;
    MovieListNum = 0;
    MovieList = new (main_stack->Alloc(0x32)) MOVIE_LIST_ENTRY[64];
    MovieLine = 0;
    MovieSelect = 0;
    MovieMode = MOVIE_VIEW_MODE_SELECT;
    spi_MovieStack = main_stack;
    script_ptr = script;

    if (LoadFile2("mv.cfg", script_ptr, &script_size, 0) != 0) {
        CScriptInterpreter interpreter;
        interpreter.SetTag(tag_movie);
        interpreter.SetScript(script_ptr, script_size);
        interpreter.Run();
    }

    main_stack->Align64();
    read_size = main_stack->stGetRest();
    Stack_ReadBuff__2.stSetBuffer(main_stack->stGetTop(), read_size);
    Stack_ReadBuff__2.stack_used = 0;
    Stack_ReadBuff__2.lock = 0;
    Stack_ReadBuff__2.Align64();
    special_info = MovieSpecialModeInfo;
    special_info[0] = 0;
    special_info[1] = 0;
    MovieSpecialMode = MOVIE_SPECIAL_MODE_NONE;
    special_info[2] = 0;
    textures->EnterTexture(0xA, "moviework", NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth,
                           0, 0, 0);
    RushWork__2 = textures->GetTexture("moviework", 0xA);
    performance_meter_flag = mgGetPerformanceMeterFlag();
    mgPerformanceMeter(0);
}

void MovieViewExit() {
    sndSeAllStop(-1);
    mgCloseFont();
    mgPerformanceMeter(performance_meter_flag);
}

int MovieViewLoop() {
    mgCTextureManager *textures = &mgTexManager;

    MOVIE_LIST_ENTRY *entry;
    int               row_y;
    int               i;

    if (MovieMode == MOVIE_VIEW_MODE_SELECT) {
        if (GamePad__2.Down(PAD_START) != 0 || GamePad__2.Down(PAD_CROSS) != 0) {
            return 1;
        }

        if (GamePad__2.Down(PAD_UP) != 0) {
            MovieSelect -= 1;
        }

        if (GamePad__2.Down(PAD_DOWN) != 0) {
            MovieSelect += 1;
        }

        if (GamePad__2.Down(PAD_L1) != 0) {
            MovieSelect -= 7;
        }

        if (GamePad__2.Down(PAD_R1) != 0) {
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

        if (GamePad__2.Down(PAD_CIRCLE) != 0) {
            Stack_ReadBuff__2.stack_used = 0;
            Stack_ReadBuff__2.lock = 0;
            entry = MovieList + MovieSelect;
            textures->ReloadTexture(0xA, (sceVif1Packet *) 0);

            if (0 < entry->bgm_no) {
                MovieScene->StopBGM(0);
                MovieScene->LoadBGM(
                    entry->bgm_no,
                    Stack_ReadBuff__2.stGetTop());
                MovieScene->PlayBGM(0, -1, 1.0f);
            }

            MovieSpecialMode = MOVIE_SPECIAL_MODE_NONE;

            if (strcmp(entry->name, "promo") == 0) {
                MovieSpecialMode = MOVIE_SPECIAL_MODE_PROMO;
                MovieSpecialModeInfo[0] = 1;
                MovieView->Load("PROMO1.PSS", &Stack_ReadBuff__2, 0x200, 0x1A0, true, false);
                MovieView->Play("moviework");
                MovieView->SwitchThread();

                while (MovieView->IsStarted() == 0) {
                    MovieView->SwitchThread();
                }
            } else if (strcmp(entry->name, "promo_tv") == 0) {
                MovieSpecialMode = MOVIE_SPECIAL_MODE_PROMO_TV;
                MovieSpecialModeInfo[0] = 1;
                MovieView->Load("PROMO1TV.PSS", &Stack_ReadBuff__2, 0x200, 0x1A0, true, false);
                MovieView->Play("moviework");
                MovieView->SwitchThread();

                while (MovieView->IsStarted() == 0) {
                    MovieView->SwitchThread();
                }
            } else {
                MovieView->Load(entry->file_name, &Stack_ReadBuff__2, 0x200, 0x1A0, true, false);
                MovieView->Play("moviework");
                MovieView->SwitchThread();

                while (MovieView->IsStarted() == 0) {
                    MovieView->SwitchThread();
                }
            }

            MovieMode = MOVIE_VIEW_MODE_PLAY;
        }

        textures->ReloadTexture(0, (sceVif1Packet *) 0);
        CFont menu_font;
        char row_text[0x100];
        menu_font.Init();
        menu_font.SetClearance(0x10, 0x14);
        menu_font.SetFuchi(FUCHI_SHADOW_BLACK_WIDE);
        menu_font.SetColor(0x80686A6BU);
        sprintf(row_text, "  :%18s     %s", "\x89" "f\x91\x9c  ", "BGMID");
        i = MovieLine;
        row_y = 0x28;

        while (i < MovieLine + 8 && i < MovieListNum) {
            sprintf(row_text, "  %d:%18s  ", i, MovieList[i].name);

            if (i == MovieSelect) {
                row_text[1] = '>';
            }

            menu_font.SetStr(row_text);
            menu_font.SetPos(0x28, row_y);
            menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
            row_y += 0x14;

            if (row_y >= 0xC9) {
                break;
            }

            i++;
        }

        return 0;
    }

    if (MovieMode == MOVIE_VIEW_MODE_PLAY) {
        mgPerformanceMeter(0);
        textures->ReloadTexture(0xA, (sceVif1Packet *) 0);
        MovieView->SwitchThread();
        CPreSprite prim;
        prim.Initialize(NULL, NULL);
        prim.Preset2D();
        prim.AlphaBlendEnable(0);
        prim.TextureMapEnable(1);
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(0, 0, 0, 0x80);
        prim.SetIRect(0, 0, 0x200, 0x1A0, 0, 0);
        prim.Texture(RushWork__2);
        prim.Color(0x80, 0x80, 0x80, 0x80);
        prim.SetIRect(0, 0, 0x200, mgScreenHeight, 0, 0);
        prim.End();

        if (GamePad__2.Down(PAD_R1) != 0 || GamePad__2.Down(PAD_R2) != 0 ||
            GamePad__2.Down(PAD_L1) != 0 || GamePad__2.Down(PAD_L2) != 0) {
            mgPerformanceMeter(mgGetPerformanceMeterFlag() ^ 1);
        }

        if (MovieView->EndCheck() != 0 || GamePad__2.Down(PAD_START) != 0) {
            MovieView->Term();
            MovieView->SwitchThread();
            MovieMode = MOVIE_VIEW_MODE_SELECT;
            MovieScene->StopBGM(0);
            Stack_ReadBuff__2.stack_used = 0;
            Stack_ReadBuff__2.lock = 0;

            if (MovieSpecialMode == MOVIE_SPECIAL_MODE_PROMO || MovieSpecialMode == MOVIE_SPECIAL_MODE_PROMO_TV) {
                MovieSpecialModeInfo[0] += 1;

                if (MovieSpecialModeInfo[0] < 4) {
                    char part_path[0x40];
                    MovieMode = MOVIE_VIEW_MODE_PLAY;

                    if (MovieSpecialMode == MOVIE_SPECIAL_MODE_PROMO) {
                        sprintf(part_path, "PROMO%d.PSS", MovieSpecialModeInfo[0]);
                    }

                    if (MovieSpecialMode == MOVIE_SPECIAL_MODE_PROMO_TV) {
                        sprintf(part_path, "PROMO%dTV.PSS", MovieSpecialModeInfo[0]);
                    }

                    MovieView->Load(part_path, &Stack_ReadBuff__2, 0x200, 0x1A0, true, false);
                    MovieView->Play("moviework");
                    MovieView->SwitchThread();

                    while (MovieView->IsStarted() == 0) {
                        MovieView->SwitchThread();
                    }
                } else {
                    MovieSpecialModeInfo[0] = 0;
                    MovieSpecialMode = MOVIE_SPECIAL_MODE_NONE;
                }
            }

            return 0;
        }
    }

    return 0;
}
