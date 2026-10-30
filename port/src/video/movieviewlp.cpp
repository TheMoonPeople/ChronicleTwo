// clang-format off
#include "platform/native_config.hpp"
// clang-format on

#include "movieviewlp.hpp"

#include <algorithm>
#include <cstdio>
#include <cstring>
#include <format>
#include <limits>
#include <span>
#include <stdexcept>
#include <string>
#include <string_view>

#include "config_bridges.hpp"
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
#include "snd_mngr.hpp"
#include "text/bounded.hpp"

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

void MovieViewInit(INIT_LOOP_ARG arg);

void MovieViewExit() {
    sndSeAllStop(-1);
    mgCloseFont();
    mgPerformanceMeter(performance_meter_flag);
}

int MovieViewLoop() {
    mgCTextureManager *textures = &mgTexManager;

    MOVIE_LIST_ENTRY *entry = {};
    int               row_y = {};
    int               i = {};

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

        const bool has_movies = MovieList != nullptr && MovieListNum > 0;
        MovieSelect = has_movies ? static_cast<short>(std::clamp(static_cast<int>(MovieSelect), 0, MovieListNum - 1)) : 0;
        if (!has_movies) {
            MovieLine = 0;
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

        if (has_movies && GamePad__2.Down(PAD_CIRCLE) != 0) {
            Stack_ReadBuff__2.stReset();
            entry = MovieList + MovieSelect;
            textures->ReloadTexture(0xA, static_cast<sceVif1Packet *>(nullptr));

            if (0 < entry->bgm_no) {
                MovieScene->StopBGM(0);
                MovieScene->LoadBGM(entry->bgm_no, dc2::memory::RemainingBytes(Stack_ReadBuff__2));
                MovieScene->PlayBGM(0, -1, 1.0f);
            }

            MovieSpecialMode = MOVIE_SPECIAL_MODE_NONE;

            if (strcmp(entry->name, "promo") == 0) {
                MovieSpecialMode = MOVIE_SPECIAL_MODE_PROMO;
                MovieSpecialModeInfo[0] = 1;
                MovieView->Load("movie/PROMO1.mp4", 0x200, 0x1A0, true, false);
                MovieView->Play("moviework");
                MovieView->SwitchThread();

                while (MovieView->IsStarted() == 0) {
                    MovieView->SwitchThread();
                }
            } else if (strcmp(entry->name, "promo_tv") == 0) {
                MovieSpecialMode = MOVIE_SPECIAL_MODE_PROMO_TV;
                MovieSpecialModeInfo[0] = 1;
                MovieView->Load("movie/PROMO1TV.mp4", 0x200, 0x1A0, true, false);
                MovieView->Play("moviework");
                MovieView->SwitchThread();

                while (MovieView->IsStarted() == 0) {
                    MovieView->SwitchThread();
                }
            } else {
                MovieView->Load(entry->file_name, 0x200, 0x1A0, true, false);
                MovieView->Play("moviework");
                MovieView->SwitchThread();

                while (MovieView->IsStarted() == 0) {
                    MovieView->SwitchThread();
                }
            }

            MovieMode = MOVIE_VIEW_MODE_PLAY;
        }

        textures->ReloadTexture(0, static_cast<sceVif1Packet *>(nullptr));
        CFont menu_font;

        menu_font.Init();
        menu_font.SetClearance(0x10, 0x14);
        menu_font.SetFuchi(FUCHI_SHADOW_BLACK_WIDE);
        menu_font.SetColor(0x80686A6BU);
        i = MovieLine;
        row_y = 0x28;

        while (i < MovieLine + 8 && i < MovieListNum) {
            const char       *title = MovieList[i].name != nullptr ? MovieList[i].name : "";
            std::string       label = "  " + std::to_string(i) + ":";
            const std::size_t title_bytes = std::strlen(title);
            if (title_bytes < 18) {
                label.append(18 - title_bytes, ' ');
            }
            label.append(dc2::text::Fit(title, FONT_STR_MAX - 1 - label.size() - 2));
            label.append("  ");

            if (i == MovieSelect) {
                label[1] = '>';
            }

            menu_font.SetStr(label.data());
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
        textures->ReloadTexture(0xA, static_cast<sceVif1Packet *>(nullptr));
        MovieView->SwitchThread();
        CPreSprite prim;
        prim.Initialize(nullptr, nullptr);
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
            Stack_ReadBuff__2.stReset();

            if (MovieSpecialMode == MOVIE_SPECIAL_MODE_PROMO || MovieSpecialMode == MOVIE_SPECIAL_MODE_PROMO_TV) {
                MovieSpecialModeInfo[0] += 1;

                if (MovieSpecialModeInfo[0] < 4) {
                    MovieMode = MOVIE_VIEW_MODE_PLAY;
                    std::string part_path = std::format("movie/PROMO{}{}.mp4", MovieSpecialModeInfo[0],
                                                        MovieSpecialMode == MOVIE_SPECIAL_MODE_PROMO_TV ? "TV" : "");

                    MovieView->Load(part_path.data(), 0x200, 0x1A0, true, false);
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

#include "common.h"

#include <optional>
#include <string>
#include <vector>

#include "config_bridges.hpp"
#include "movieviewlp.hpp"

namespace {

/**
 * One movie of a movie_list document.
 */
struct MovieRecord {
    std::optional<std::string> title;  /**< CP932 title, or none when the operand was not text. */
    std::optional<std::string> file;   /**< Movie file name, or none when the operand was not text. */
    int                        bgm_no; /**< Music played alongside, or -1 when the list names none. */
};

/**
 * Movies of the last movie list read, which the entries handed out point into.
 */
std::vector<MovieRecord> movie_records;

/**
 * Entries handed to the movie viewer for movie_records.
 */
std::vector<PortMovieEntry> movie_entries;

/**
 * Parses a movie_list document.
 */
std::vector<MovieRecord> ParseMovieList(const native_config::Json &document) {
    using namespace native_config;
    std::vector<MovieRecord> movies;
    for (const auto &movie : Array(document, "movies")) {
        movies.push_back({.title = OptionalText(movie, "title"), .file = OptionalText(movie, "file"), .bgm_no = OptionalInt(movie, "bgm").value_or(-1)});
    }
    return movies;
}

/**
 * Gives a stored string's text, or null for none.
 */
const char *TextOf(const std::optional<std::string> &text) {
    return text ? text->c_str() : nullptr;
}

} // namespace

int PortReadMovieList(const PortMovieEntry **entries) {
    movie_records.clear();
    movie_entries.clear();
    if (auto movies = native_config::ReadGame<std::vector<MovieRecord>>("mv.cfg.json", "movie_list", ParseMovieList)) {
        movie_records = std::move(*movies);
    }
    for (const auto &movie : movie_records) {
        movie_entries.push_back({.title = TextOf(movie.title), .file = TextOf(movie.file), .bgm_no = movie.bgm_no});
    }
    *entries = movie_entries.data();
    return static_cast<int>(movie_entries.size());
}

void MovieViewInit([[maybe_unused]] INIT_LOOP_ARG argument) {
    MovieScene = GetMainScene();
    MovieScene->Initialize();
    mgInitFont();
    mgCMemory *main_stack = GetMainStack();
    if (main_stack == nullptr) {
        throw std::length_error("movie viewer arena is unavailable");
    }
    main_stack->stReset();
    const auto reserve = [main_stack](int quadwords) {
        main_stack->Align64();
        if (quadwords <= 0 || static_cast<std::size_t>(quadwords) >=
                                  dc2::memory::RemainingBytes(*main_stack).size() / sizeof(u_long128)) {
            throw std::length_error("movie viewer arena is exhausted");
        }
        auto *storage = main_stack->Alloc(quadwords);
        if (storage == nullptr) {
            throw std::length_error("movie viewer allocation failed");
        }
        return storage;
    };
    static mgCMemory packet_a;
    static mgCMemory packet_b;
    static mgCMemory data_a;
    static mgCMemory data_b;
    auto            *vif_a = reserve(0x2710);
    auto            *vif_b = reserve(0x2710);
    mgInitVif1Packet(vif_a, vif_b, 0x27100);
    packet_a.stSetChildBuffer(*main_stack, reserve(0x7530), 0x7530);
    packet_b.stSetChildBuffer(*main_stack, reserve(0x7530), 0x7530);
    data_a.stSetChildBuffer(*main_stack, reserve(0xEA60), 0xEA60);
    data_b.stSetChildBuffer(*main_stack, reserve(0xEA60), 0xEA60);
    DataBuffer__2.stSetChildBuffer(*main_stack, reserve(0x186A0), 0x186A0);
    mgSetPacketBuffer(&packet_a, &packet_b);
    mgSetDataBuffer(&data_a, &data_b, 1);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetTextureTable(0x64, 0x14, &DataBuffer__2);
    auto *textures = &mgTexManager;
    textures->EnterIMGFile(GetGaijiImgPtr(), 0, nullptr, nullptr);
    ReLoadFontTexture(0);
    constexpr std::size_t movie_capacity = 64;
    MovieView = dc2::memory::NewObject<CMovie>(*main_stack);
    MovieList = dc2::memory::NewArray<MOVIE_LIST_ENTRY>(*main_stack, movie_capacity);
    if (MovieView == nullptr || MovieList == nullptr) {
        throw std::length_error("movie viewer cannot allocate its player and list");
    }
    MovieListNum = 0;
    MovieLine = 0;
    MovieSelect = 0;
    MovieMode = MOVIE_VIEW_MODE_SELECT;
    const auto copy_text = [main_stack](const char *source) {
        const std::string_view text = source != nullptr ? source : "";
        char                  *copy = dc2::memory::NewArray<char>(*main_stack, text.size() + 1);
        if (copy == nullptr) {
            throw std::length_error("movie viewer cannot allocate a configured name");
        }
        std::memcpy(copy, text.data(), text.size());
        copy[text.size()] = char{};
        return copy;
    };
    const PortMovieEntry *movies = nullptr;
    const int             movie_count = PortReadMovieList(&movies);
    for (int index = 0; index < movie_count && static_cast<std::size_t>(MovieListNum) < movie_capacity; ++index) {
        auto &entry = MovieList[MovieListNum];
        entry.name = copy_text(movies[index].title);
        entry.file_name = copy_text(movies[index].file);
        entry.bgm_no = movies[index].bgm_no;
        ++MovieListNum;
    }
    main_stack->Align64();
    const auto available = dc2::memory::RemainingBytes(*main_stack).size() / sizeof(u_long128);
    if (available <= 1 || available - 1 > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
        throw std::length_error("movie viewer has no read arena");
    }
    const auto read_quadwords = static_cast<int>(available - 1);
    auto      *read_storage = main_stack->Alloc(read_quadwords);
    if (read_storage == nullptr) {
        throw std::length_error("movie viewer cannot reserve its read arena");
    }
    Stack_ReadBuff__2.stSetChildBuffer(*main_stack, read_storage, read_quadwords);
    Stack_ReadBuff__2.Align64();
    MovieSpecialModeInfo[0] = 0;
    MovieSpecialModeInfo[1] = 0;
    MovieSpecialModeInfo[2] = 0;
    MovieSpecialMode = MOVIE_SPECIAL_MODE_NONE;
    textures->EnterTexture(0xA, "moviework", nullptr, mgScreenWidth, mgScreenHeight, mgScreenDepth, nullptr, 0, 0);
    RushWork__2 = textures->GetTexture("moviework", 0xA);
    performance_meter_flag = mgGetPerformanceMeterFlag();
    mgPerformanceMeter(0);
}
