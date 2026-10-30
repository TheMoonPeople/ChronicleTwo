#include "menudraw.hpp"
#include "mw_runtime.h"

#include <cmath>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <format>

#include "actionchara.hpp"
#include "character.hpp"
#include "dataread.hpp"
#include "dng_main.hpp"
#include "editmenu.hpp"
#include "effscript.hpp"
#include "gamedata.hpp"
#include "gfx/gfx.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "memory/tracked_copy.hpp"
#include "menuaqua.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "menushop.hpp"
#include "menusys.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "text/bounded.hpp"
#include "userdata.hpp"

/**
 *
 * Pairs the textures used when reloading character palettes and copying item icon palettes.
 *
 */
struct texture_pair {
    mgCTexture *tex[2]; /**< Textures whose palettes are reloaded or copied. */
};

/**
 *
 * Stores the four item icon texture pointers selected by a transparent rectangle.
 *
 */
struct icon_texture_info {
    mgCTexture *tex[4]; /**< Icon texture variants for the selected source texture. */
};

/**
 *
 * Passes Spectol break and fusion arguments to CMenuEffect::PresetEffect.
 *
 */
struct menu_effect_preset {
    int v[10]; /**< Arguments passed to the effect preset. */
};

/**
 *
 * Stores texture coordinates for a menu quadrilateral.
 *
 */
struct quad_uv {
    float corner[4][2]; /**< Texture coordinates for its four corners. */
};

/**
 *
 * Stores the three points used to draw a cursor hand.
 *
 */
struct cursor_hand {
    float corner[3][2]; /**< Coordinates of the cursor hand points. */
};

/**
 *
 * Stores the widths of the two cursor parts.
 *
 */
struct cursor_width {
    float width[2]; /**< Widths of the cursor parts. */
};

/**
 *
 * Stores the position used when moving an icon.
 *
 */
struct icon_move_pos {
    int pos[2]; /**< Horizontal and vertical icon coordinates. */
};

/**
 *
 * Stores the position at which a cursor is placed.
 *
 */
struct cursor_put_pos {
    float pos[2]; /**< Horizontal and vertical cursor coordinates. */
};

/**
 *
 * Stores the position at which a menu element is placed.
 *
 */
struct menu_put_pos {
    int pos[2]; /**< Horizontal and vertical placement coordinates. */
};

/**
 *
 * Stores the position of a menu board.
 *
 */
struct menu_board_pos {
    float pos[2]; /**< Horizontal and vertical board coordinates. */
};

/**
 *
 * Stores the colour of a menu tile.
 *
 */
struct menu_tile_color {
    u8 rgba[4]; /**< Red, green, blue, and alpha channels. */
};

/**
 *
 * Provides a rectangle initialized with zero coordinates and dimensions.
 *
 */
struct ZeroedRect : mgRect<int> {
    ZeroedRect() { Set(0, 0, 0, 0); }
};

/**
 *
 * Stores the colour of a menu item.
 *
 */
struct item_color {
    u8 rgba[4]; /**< Red, green, blue, and alpha channels. */
};

/**
 *
 * Groups the rectangles that form a scroll bar.
 *
 */
struct scroll_bar_parts {
    mgRect<int> *rect[3]; /**< Rectangles used by the scroll bar. */
};

/**
 *
 * Stores texture coordinates for board numbers.
 *
 */
struct board_number_uv {
    u8 uv[2][4]; /**< Texture coordinates for the number states. */
};

/**
 *
 * Stores texture coordinates for board lines.
 *
 */
struct board_line_uv {
    s8 uv[6][3][4]; /**< Texture coordinates for the board line segments. */
};

/**
 *
 * Stores colours for two board pass states.
 *
 */
struct board_pass_color {
    int rgba[2][4]; /**< Colour channels for the two states. */
};

/**
 *
 * Stores colours for board button states.
 *
 */
struct board_button_color {
    int rgba[2][2][4]; /**< Colour channels for both button groups and states. */
};

/**
 *
 * Stores a menu cursor position.
 *
 */
struct menu_cursor_pos {
    float pos[2]; /**< Horizontal and vertical cursor coordinates. */
};

/**
 *
 * Stores the starting point of a menu line.
 *
 */
struct menu_line_origin {
    int pos[2]; /**< Horizontal and vertical line coordinates. */
};

/**
 *
 * Stores the position of a menu memo.
 *
 */
struct menu_memo_pos {
    float pos[2]; /**< Horizontal and vertical memo coordinates. */
};

/**
 *
 * Stores the positions of two frame edges.
 *
 */
struct waku_edge_pos {
    int pos[2][2]; /**< Coordinates of the two frame edges. */
} __attribute__((aligned(16)));

/**
 *
 * Stores the widths of board line segments.
 *
 */
struct board_line_width {
    int width[4]; /**< Widths of the four line segments. */
} __attribute__((aligned(16)));

/**
 *
 * Selects the number of digit places used by menu number drawing.
 *
 */
static signed char MenuDrawNumberKeta;

/**
 *
 * Marks completion of the main menu frame movement.
 *
 */
static u8 MenuMainFrame_ActionEndFlag;

/**
 *
 * Holds the common creation-board texture.
 *
 */
static mgCTexture *Tex_CommonBoard;

/**
 *
 * Holds the material rows and controls drawn on the common creation board.
 *
 */
static MENUFORM_MAKEBRD_INFO CommonBoardDrawInfo;

/**
 *
 * Selects the source item-icon texture and palette.
 *
 */
short use_trans_rect;

/**
 *
 * Tracks the phase of the enabled-item opacity pulse.
 *
 */
static float use_item_enable_alpha_angle;

/**
 *
 * Holds the current enabled-item opacity.
 *
 */
static int use_item_enable_alpha;

/**
 *
 * Holds horizontal offsets for the spectrum icon raster effect.
 *
 */
static float *spectol_raster_xtbl;

/**
 *
 * Holds the Geostone download panel texture.
 *
 */
static mgCTexture *Tex_MenuDl;

/**
 *
 * Holds the total size displayed by the Geostone download panel.
 *
 */
static int MenuDl_TotalSize;

/**
 *
 * Holds the processed size displayed by the Geostone download panel.
 *
 */
static int MenuDl_ProcessSize;

/**
 *
 * Gives the Geostone download and completion text for each language.
 *
 */
static char *tbl_1689[7][2] = {
    {" ",                                                         " "                                                          },
    {"Downloading Geostone...",                                   "Geostone downloading complete."                             },
    {"T[UNI00e9]l[UNI00e9]chargement de la g[UNI00e9]opierre...", "T[UNI00e9]l[UNI00e9]chargement de la g[UNI00e9]opierre fini"},
    {"Geostein-Download ...",                                     "Geostein-Download beendet."                                 },
    {"Scaricamento Geopietra in corso...",                        "Scaricamento Geopietra completato."                         },
    {"Descargando Geopiedra...",                                  "Descarga de Geopiedra finalizada."                          },
    {"Downloading Geostone...",                                   "Geostone downloading complete."                             }
};

/**
 *
 * Holds the top-left position of the main menu frame.
 *
 */
static float MenuMainFrame_LeftTop_Pos[2];

/**
 *
 * Tracks the missing-material quantity blink phase.
 *
 */
static float make_object_husoku_number_blink;

/**
 *
 * Tracks the animated menu cursor rotation.
 *
 */
static float menu_cursor_rotation_angle;

/**
 *
 * Supplies the initial position copied into a menu cursor draw.
 *
 */
static menu_cursor_pos at_3428;

/**
 *
 * Supplies the initial origin copied into a random menu line draw.
 *
 */
static menu_line_origin at_3527;

/**
 *
 * Supplies the initial position copied into a menu memo draw.
 *
 */
static menu_memo_pos at_3531;

/**
 *
 * Holds the repeated form-part quadrilateral screen coordinates.
 *
 */
static float putpostbl_3410[8];

/**
 *
 * Holds the repeated form-part quadrilateral texture coordinates.
 *
 */
static int getpostbl_3411[8];

static void MenuFrameImageDraw(mgCDrawPrim *prim, mgCTexture *tex, mgRect<float> rect, mgRect<int> tex_rect, int gray,
                               int alpha, int dtype);

/**
 *
 * Holds the item-board icon drawing colour.
 *
 */
static u8 localrgba_3166[4];

/**
 *
 * Tracks the item-board effect animation phase.
 *
 */
static float item_board_counter;

/**
 *
 * Selects the main menu frame display mode.
 *
 */
static short MenuMainFrame_Display_Mode;

/**
 *
 * Tracks the main menu frame display transition.
 *
 */
static float MenuMainFrame_Display_Mode_Cnt;

/**
 *
 * Sets the main menu frame display transition speed.
 *
 */
static float MenuMainFrame_Display_Mode_Cnt_Rate;

/**
 *
 * Holds the centre of the main menu frame lens.
 *
 */
static float MenuMainFrame_Lenze_Pos[2];

/**
 *
 * Holds horizontal and vertical main menu frame movement rates.
 *
 */
static float MenuMainFrame_MoveRate[2];

/**
 *
 * Tracks the main menu frame movement phase.
 *
 */
static float MenuMainFrame_MoveRate_Cnt;

/**
 *
 * Tracks the rotating circular menu frame phase.
 *
 */
static float MenuWakuRotCnt;

void SetPartEffectInfoRandFunc(MENU_PARTS_EFFECT_STRUCT1 *effect);

void SetPartEffectInfoRandFunc(MENU_PARTS_EFFECT_STRUCT1 *effect, short *values, int count);

/**
 *
 * Holds the total number of item-board rows.
 *
 */
static int MenuItemBrdMaxLine;

/**
 *
 * Holds the number of visible item-board rows.
 *
 */
static int MenuItemBrdViewLine;

/**
 *
 * Holds the item-board scroll cursor length.
 *
 */
static float MenuItemBrdScrlCurLen;

/**
 *
 * Tracks the item icon animation phase.
 *
 */
static float DrawItemCounter;

/**
 *
 * Tracks the item icon blink cycle.
 *
 */
static signed char DrawItemDefCounter;

/**
 *
 * Holds the current item-board scroll bar position.
 *
 */
static float MenuItemBrdScrlBarY;

/**
 *
 * Holds the next vertical position of the item-board cells.
 *
 */
static float MenuItemBrdUnderBrdPosY_Next;

/**
 *
 * Holds the weapon build-up line effect texture.
 *
 */
static mgCTexture *MenuVerticalLineTex;

/**
 *
 * Sets the upper limit of the weapon build-up line effect.
 *
 */
static float MenuVerticalLineUpLimmit;

/**
 *
 * Holds the weapon build-up line effect particles.
 *
 */
static CEffVerticalLine *MenuVerticalLine;

/**
 *
 * Holds the number of weapon build-up line effect particles.
 *
 */
static int MenuVerticalLineNum;

/**
 *
 * Character followed by the weapon build-up effect, or NULL.
 *
 */
static CCharacter2 *MenuVerticalLineChara;

/**
 *
 * Holds the vertical range of the weapon build-up line effect.
 *
 */
static float MenuVerticalRange;

/**
 *
 * Holds the current character position for weapon build-up effects.
 *
 */
static float MenuVerticalLineCharaPos[4];

/**
 *
 * Holds the secondary character position for weapon build-up effects.
 *
 */
static float MenuVerticalLineCharaPos2[4];

/**
 *
 * Holds the positions of the shared level-up sparks.
 *
 */
static float l_levelup_pos[32][3];

/**
 *
 * Holds the velocities of the shared level-up sparks.
 *
 */
static float l_levelup_vec[32][3];

/**
 *
 * Tracks the lifetime of each shared level-up spark.
 *
 */
static signed char l_levelup_counter[32];

/**
 *
 * Tracks the generation interval of each shared level-up spark.
 *
 */
static signed char l_levelup_generate_counter[32];

/**
 *
 * Marks the boiled-fish icon effect as active.
 *
 */
static short fish_boiled_runflag;

/**
 *
 * Tracks the boiled-fish icon effect duration.
 *
 */
static short fish_boiled_count;

/**
 *
 * Holds the positions of the boiled-fish icon effect particles.
 *
 */
static float fish_boiled_positin[8][2];

/**
 *
 * Tracks the sway phase of each boiled-fish icon effect particle.
 *
 */
static float fish_boiled_amp_count[8];

/**
 *
 * Holds the opacity of each boiled-fish icon effect particle.
 *
 */
static float fish_boiled_alpha[8];

/**
 *
 * Holds the size multiplier of each boiled-fish icon effect particle.
 *
 */
static float fish_boiled_streatch_rate[8];

/**
 *
 * Holds the texture used by the boiled-fish icon effect.
 *
 */
static mgCTexture *fish_boiled_effect_tex;

void MENU_BASETEXINFO_Init(MENU_BASETEXINFO *info);

/**
 *
 * Palette and effect modes used to render an item icon.
 *
 */
enum MENU_ICON_MODE {
    MENU_ICON_MODE_NORMAL = 0,      /**< Normal icon with its drop shadow. */
    MENU_ICON_MODE_SPECTRUM = 1,    /**< Spectrumised icon with raster and sparkle effects. */
    MENU_ICON_MODE_DIMMED = 2,      /**< Icon with a dark overlay. */
    MENU_ICON_MODE_BOILED_FISH = 3, /**< Boiled-fish icon with its alternate palette. */
};

static void ConvMGIRECTtoINTtbl(mgRect<int> rect, int *corners);

void PushPrimRepeat(mgCDrawPrim *prim, float *positions, int *tex_coords, int count);

void MenuWindowHelp(mgCDrawPrim *prim, mgCTexture *texture, float x, float y, float width, float height,
                    short *table);

static void SetMenuDrawNumberKeta(char value);

int DrawMenuNumber(mgCDrawPrim *prim, int number, int align, mgRect<int> rect, mgRect<int> texture_rect, int step_x,
                   int step_y);

void DrawRandamLine(mgCDrawPrim *prim, std::span<const int[2]> points, int smoothing, int count, std::span<const u8, 4> color);

void InitInitBuildUpInfoEffectPos();

#include "common.h"

#include <algorithm>
#include <filesystem>
#include <iterator>
#include <limits>
#include <optional>
#include <string>
#include <utility>
#include <vector>

#include "asset_directory.hpp"
#include "assets/data_registry.hpp"
#include "log/log.hpp"
#include "menu_mouse_item.hpp"
#include "menu_world.hpp"
#include "mg_memory.hpp"
#include "object/menu/menu_presentation.hpp"
#include "platform/model_assets.hpp"
#include "platform/texture_bundle.hpp"
#include "render/renderer.hpp"
#include "render/texture_runtime.hpp"
#include "stubs/menudraw.hpp"
#include "text/bounded.hpp"
#include "text/title_lettering.hpp"

/**
 *
 * Defines the three texture-coordinate vertices of each spectrum fragment.
 *
 */
static s16 spectol_break_pos[16][3][2] = {
    {{0, 0},
     {16, 0},
     {8, 8}  },
    {{0, 0},
     {8, 8},
     {0, 16} },
    {{16, 0},
     {32, 0},
     {24, 8} },
    {{16, 0},
     {24, 8},
     {16, 16}},
    {{16, 0},
     {32, 0},
     {24, 8} },
    {{16, 0},
     {24, 8},
     {16, 16}},
    {{32, 0},
     {32, 16},
     {24, 8} },
    {{16, 16},
     {24, 8},
     {32, 16}},
    {{0, 16},
     {16, 16},
     {8, 24} },
    {{0, 16},
     {8, 24},
     {0, 32} },
    {{16, 16},
     {32, 16},
     {24, 24}},
    {{16, 16},
     {24, 24},
     {16, 32}},
    {{16, 16},
     {32, 16},
     {24, 24}},
    {{16, 16},
     {24, 24},
     {16, 32}},
    {{32, 16},
     {32, 32},
     {24, 24}},
    {{16, 32},
     {24, 24},
     {32, 32}}
};

/**
 *
 * Defines the direction angles associated with each spectrum fragment.
 *
 */
static float spectol_break_angle[16][6] = {
    {0.0f, 0.0f, 0.0f,         0.0f,         -0.785398006f, -0.785398006f},
    {0.0f, 0.0f, -1.57079995f, -1.57079995f, -0.785398006f, -0.785398006f},
    {0.0f, 0.0f, 0.0f,         0.0f,         -0.785398006f, -0.785398006f},
    {0.0f, 0.0f, -1.57079995f, -1.57079995f, -0.785398006f, -0.785398006f},
    {0.0f, 0.0f, 0.0f,         0.0f,         -0.785398006f, -0.785398006f},
    {0.0f, 0.0f, -1.57079995f, -1.57079995f, -0.785398006f, -0.785398006f},
    {0.0f, 0.0f, -2.35618997f, -2.35618997f, -1.57079995f,  -1.57079995f },
    {0.0f, 0.0f, 0.785398006f, 0.785398006f, 0.0f,          0.0f         },
    {0.0f, 0.0f, 0.0f,         0.0f,         -0.785398006f, -0.785398006f},
    {0.0f, 0.0f, -1.57079995f, -1.57079995f, -0.785398006f, -0.785398006f},
    {0.0f, 0.0f, 0.0f,         0.0f,         -0.785398006f, -0.785398006f},
    {0.0f, 0.0f, -1.57079995f, -1.57079995f, -0.785398006f, -0.785398006f},
    {0.0f, 0.0f, 0.0f,         0.0f,         -0.785398006f, -0.785398006f},
    {0.0f, 0.0f, -1.57079995f, -1.57079995f, -0.785398006f, -0.785398006f},
    {0.0f, 0.0f, -2.35618997f, -2.35618997f, -1.57079995f,  -1.57079995f },
    {0.0f, 0.0f, 0.785398006f, 0.785398006f, 0.0f,          0.0f         }
};

/**
 *
 * Gives the item icon texture rectangles for the two source textures.
 *
 */
MENU_SHORT_RECT item_transtbl[2] = {
    {224, 736, 32, 32},
    {224, 736, 32, 32}
};

/**
 *
 * Gives the RGBA overlays for the nine paint item icons.
 *
 */
static int paint_color_table_1234[9][4] = {
    {233, 0,   0,   64},
    {0,   0,   233, 64},
    {0,   0,   0,   64},
    {0,   233, 0,   64},
    {233, 150, 60,  64},
    {250, 250, 70,  64},
    {169, 12,  210, 64},
    {250, 160, 210, 64},
    {233, 0,   0,   64}
};

/**
 *
 * Gives the vertical offsets of the spectrum icon raster lines.
 *
 */
static s8 spectol_y_addtbl_1245[40] = {1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1};

/**
 *
 * Gives the texture rectangles used by the gift-box window frame.
 *
 */
static short MenuWindowHelpTable_1346[36] = {0, 0, 22, 24, 23, 0, 2, 24, 24, 0, 22, 24, 0, 25, 22, 1, 22, 25, 2, 1, 24, 25, 22, 1, 0, 68, 22, 24, 22, 68, 2, 24, 24, 68, 22, 24};

/**
 *
 * Gives the left, centre and right texture rectangles of each download-panel row.
 *
 */
static MENU_SHORT_RECT table_1650[3][3] = {
    {{0, 0, 32, 32},
     {32, 0, 32, 32},
     {64, 0, 32, 32} },
    {{0, 32, 32, 16},
     {32, 32, 32, 16},
     {64, 32, 32, 16}},
    {{0, 48, 32, 76},
     {32, 48, 32, 76},
     {64, 48, 32, 76}}
};

/**
 *
 * Gives the three texture rectangles of active and inactive material-board rows.
 *
 */
static s16 get_onoffbrdtbl_1789[2][3][4] = {
    {{66, 72, 6, 30},
     {72, 72, 2, 30},
     {74, 72, 6, 30}},
    {{54, 20, 6, 30},
     {60, 20, 2, 30},
     {62, 20, 6, 30}}
};

/**
 *
 * Gives the target movement counts for each main menu frame mode.
 *
 */
static float tbl_2072[8] = {10.0f, 14.0f, 24.0f, 27.0f, 24.0f, 24.0f, 24.0f, 24.0f};

/**
 *
 * Gives the RGB colours used by the menu star particles.
 *
 */
static int star_color_table[9] = {255, 111, 111, 34, 230, 23, 0, 0, 128};

/**
 *
 * Identifies the texture rectangles used by the item-board frame.
 *
 */
enum MENU_ITEM_FRAME_PART {
    MENU_ITEM_FRAME_TOP_LEFT = 0,      /**< Top-left corner. */
    MENU_ITEM_FRAME_TOP = 1,           /**< First top-edge tile. */
    MENU_ITEM_FRAME_TOP_ALT = 2,       /**< Second top-edge tile. */
    MENU_ITEM_FRAME_TOP_RIGHT = 3,     /**< Top-right corner. */
    MENU_ITEM_FRAME_LEFT = 4,          /**< First left-edge tile. */
    MENU_ITEM_FRAME_RIGHT = 5,         /**< First right-edge tile. */
    MENU_ITEM_FRAME_LEFT_ALT = 6,      /**< Second left-edge tile. */
    MENU_ITEM_FRAME_RIGHT_ALT = 7,     /**< Second right-edge tile. */
    MENU_ITEM_FRAME_BOTTOM_LEFT = 8,   /**< Bottom-left corner. */
    MENU_ITEM_FRAME_BOTTOM = 9,        /**< First bottom-edge tile. */
    MENU_ITEM_FRAME_BOTTOM_ALT = 10,   /**< Second bottom-edge tile. */
    MENU_ITEM_FRAME_BOTTOM_RIGHT = 11, /**< Bottom-right corner. */
};

/**
 *
 * Selects texture rectangles for the top and bottom item-board frame segments.
 *
 */
static s16 frmtbl0_2922[16] = {
    MENU_ITEM_FRAME_TOP_LEFT,
    MENU_ITEM_FRAME_TOP,
    MENU_ITEM_FRAME_TOP_ALT,
    MENU_ITEM_FRAME_TOP,
    MENU_ITEM_FRAME_TOP_ALT,
    MENU_ITEM_FRAME_TOP,
    MENU_ITEM_FRAME_TOP_ALT,
    MENU_ITEM_FRAME_TOP_RIGHT,
    MENU_ITEM_FRAME_BOTTOM_LEFT,
    MENU_ITEM_FRAME_BOTTOM,
    MENU_ITEM_FRAME_BOTTOM_ALT,
    MENU_ITEM_FRAME_BOTTOM,
    MENU_ITEM_FRAME_BOTTOM_ALT,
    MENU_ITEM_FRAME_BOTTOM,
    MENU_ITEM_FRAME_BOTTOM_ALT,
    MENU_ITEM_FRAME_BOTTOM_RIGHT,
};

/**
 *
 * Selects texture rectangles for the side item-board frame segments.
 *
 */
static s16 frmtbl1_2938[10] = {
    MENU_ITEM_FRAME_LEFT,
    MENU_ITEM_FRAME_LEFT_ALT,
    MENU_ITEM_FRAME_LEFT,
    MENU_ITEM_FRAME_LEFT_ALT,
    MENU_ITEM_FRAME_LEFT,
    MENU_ITEM_FRAME_RIGHT,
    MENU_ITEM_FRAME_RIGHT_ALT,
    MENU_ITEM_FRAME_RIGHT,
    MENU_ITEM_FRAME_RIGHT_ALT,
    MENU_ITEM_FRAME_RIGHT_ALT,
};

/**
 *
 * Gives the oscillation rates for each remaining fish bounce count.
 *
 */
static float rottbl_3145[3] = {0.130899698f, 0.112199739f, 0.0872664675f};

/**
 *
 * Gives the base position offsets for the main menu icons.
 *
 */
static short baseposoffset_tbl_4194[23][2] = {
    {0,   0},
    {0,   0},
    {-40, 0},
    {0,   0},
    {-20, 0},
    {-4,  0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0},
    {0,   0}
};

/**
 *
 * Gives language-specific destination offsets for main menu icon movement.
 *
 */
static short actposoffsettbl1_4195[3][18][2] = {
    {{0, 0},
     {0, 0},
     {50, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0}},
    {{0, 0},
     {0, 0},
     {40, 3},
     {0, 0},
     {-12, 0},
     {0, 0},
     {0, 0},
     {0, -5},
     {0, -5},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0}},
    {{0, 0},
     {0, 0},
     {40, 0},
     {0, 0},
     {-12, 0},
     {0, 0},
     {0, 0},
     {0, -5},
     {0, -5},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0},
     {0, 0}}
};

/**
 *
 * Gives the RGBA colours of the two level-up spark kinds.
 *
 */
static int l_levelup_color[2][4] = {
    {79,  125, 75,  128},
    {125, 90,  100, 128}
};

/**
 *
 * Gives the normal gift-box item icon colour.
 *
 */
static u8 rgbatbl_1379[4] = {128, 128, 128, 128};

/**
 *
 * Gives the glyph coordinates for active and inactive creation-board buttons.
 *
 */
static s8 get_btntbl_1810[2][2] = {
    {80, 88},
    {80, 72}
};

/**
 *
 * Holds the centre position used by circular menu frames.
 *
 */
float MenuWakuPutXY[2] = {0.0f, 0.0f};

/**
 *
 * Gives the normal item-board icon colour.
 *
 */
static u8 static_rgba_table_3128[4] = {128, 128, 128, 128};

/**
 *
 * Selects the primitive kind and vertex count for repeated form-part drawing.
 *
 */
static u8 menu_prim_tbl[2][2] = {
    {MG_PRIM_SPRITE,         2},
    {MG_PRIM_TRIANGLE_STRIP, 4}
};

/**
 *
 * Holds the main menu icon base position.
 *
 */
static short basepos_4190[2] = {44, 96};

/**
 *
 * Holds the main menu icon left boundary position.
 *
 */
static short farleft_4191[2] = {-260, 0};

/**
 *
 * Holds the shared main menu icon movement offset.
 *
 */
static short xyoffset_4192[2] = {20, 43};

/**
 *
 * Holds the main menu icon action destination position.
 *
 */
static short actpos_4193[2] = {44, 16};

void AttachMessageForm() {
    char name[32];

    for (int i = 0; i < 9; i++) {
        std::snprintf(name, sizeof(name), "msg%d", i);
        MenuMesForm[i] = MenuPosData->GetFormInfo(name);
    }
}

void Init_MENUFORM_MAKEBRD_INFO(MENUFORM_MAKEBRD_INFO *board) {
    memset(board, 0, sizeof(*board));
}

void GetMenuItemIconTexGetXY(int item_no, mgRect<int> &rect) {
    int icon_no = GetItemIconNo(item_no);

    if (item_no == ITEM_ID_LAMBS_SWORD && MenuMainScene != nullptr &&
        GetTimeBand(MenuMainScene->time) == MAP_TIME_BAND_NIGHT) {
        icon_no++;
    }

    rect.right = rect.bottom = 32;
    rect.left = (icon_no % 8) * rect.right;
    rect.top = (icon_no / 8) * rect.bottom;
}

mgCTexture *GetMenuItemIconTexInfo(int item_no, int index);

/**
 *
 * Expands an integer rectangle into its four drawing corners.
 *
 */
static void ConvMGIRECTtoINTtbl(mgRect<int> rect, int *corners) {
    corners[0] = rect.left;
    corners[1] = rect.top;
    corners[2] = rect.left + rect.right;
    corners[3] = rect.top;
    corners[4] = rect.left;
    corners[5] = rect.top + rect.bottom;
    corners[6] = corners[2];
    corners[7] = corners[5];
}

/**
 *
 * Expands a floating-point rectangle into its four drawing corners.
 *
 */
static void ConvMGFRECTtoFLOATtbl(mgRect<float> rect, float *corners) {
    corners[0] = rect.left;
    corners[1] = rect.top;
    corners[2] = rect.left + rect.right;
    corners[3] = rect.top;
    corners[4] = rect.left;
    corners[5] = rect.top + rect.bottom;
    corners[6] = corners[2];
    corners[7] = corners[5];
}

/**
 *
 * Seeds an item part effect with randomized parameters for its effect type.
 *
 */
void SetPartEffectInfoRandFunc(MENU_PARTS_EFFECT_STRUCT1 *effect) {
    if (effect != nullptr) {
        int rand_a = rand();
        int rand_b = rand();

        switch (effect->type) {
            case MENU_PARTS_EFFECT_SPARKLE:
                effect->param[0] = 0.0f;
                effect->param[1] = 34.0f + static_cast<float>(rand_a % 20);
                effect->param[2] = 2.0f + static_cast<float>(rand_a % 30);
                effect->param[3] = static_cast<float>(rand_b % 34 - 1);
                effect->param[4] = static_cast<float>(rand_a % 3);
                effect->param[5] = 1.0f + 0.2f * static_cast<float>(rand_b % 4);
                effect->param[6] = static_cast<float>(rand_a % 9);
                effect->param[7] = 3.0f + static_cast<float>(rand_b % 6);
                return;
            case MENU_PARTS_EFFECT_STRETCH:
                effect->param[0] = 0.0f;
                effect->param[1] = 320.0f;
                effect->param[2] = 16.0f;
                effect->param[3] = 20.0f;
                effect->param[4] = 0.0f;
                effect->param[5] = 1000.0f;
                break;
        }
    }
}

/**
 *
 * Copies scripted values into an item part effect's parameter array.
 *
 */
void SetPartEffectInfoRandFunc(MENU_PARTS_EFFECT_STRUCT1 *effect, short *values, int count) {
    for (int i = 0; i < count; i++) {
        effect->param[i] = values[i];
    }
}

namespace {
/**
 *
 * Returns whether the current UI anchor moves draws towards a side of the window.
 *
 */
bool UiAnchored() {
    const gfx::UiAnchor anchor = gfx::CurrentUiAnchor();
    const gfx::UiAnchor none{};
    return anchor.left_until != none.left_until || anchor.right_from != none.right_from ||
           anchor.top_until != none.top_until || anchor.bottom_from != none.bottom_from;
}
} // namespace

void SetSpriteEnv(mgCDrawPrim *prim, int mode) {
    if (prim != nullptr) {
        prim->Initialize(nullptr, nullptr);
        prim->Coord(0);

        switch (mode) {
            case MENU_SPRITE_ENV_TEXTURE:
            case MENU_SPRITE_ENV_ADD:
            case MENU_SPRITE_ENV_SHADED:
                prim->AlphaBlendEnable(1);
                prim->Bilinear(0);

                if (mode == MENU_SPRITE_ENV_ADD) {
                    prim->AlphaBlend(MG_ALPHA_BLEND_ADD);
                    prim->Bilinear(1);
                } else {
                    prim->AlphaBlend(MG_ALPHA_BLEND_NORMAL);
                }

                prim->AlphaTestEnable(1);
                prim->AlphaTest(1, 0);
                prim->DepthTestEnable(0);
                prim->ZMask(MG_Z_MASK_MASKED);
                prim->Shading(0);
                prim->TextureMapEnable(1);
                prim->AntiAliasing(0);

                if (mode == MENU_SPRITE_ENV_SHADED) {
                    prim->Shading(1);
                    prim->Bilinear(1);
                    return;
                }

                break;
            case MENU_SPRITE_ENV_COLOR:
            case MENU_SPRITE_ENV_COLOR_AA:
                prim->AlphaTestEnable(1);
                prim->AlphaTest(1, 0);
                prim->AlphaBlendEnable(1);
                prim->AlphaBlend(MG_ALPHA_BLEND_NORMAL);
                prim->TextureMapEnable(0);
                // Only depthless 2D follows a UI anchor, so a colour box backing an anchored panel, such as the
                // Ridepod's fuel gauge fill on the spread Item page, draws depthless to move with it.
                prim->DepthTestEnable(UiAnchored() ? 0 : 1);

                if (mode == MENU_SPRITE_ENV_COLOR_AA) {
                    prim->DepthTestEnable(0);
                    prim->AntiAliasing(1);
                }

                prim->ZMask(MG_Z_MASK_MASKED);
                prim->Shading(1);
                return;
            case MENU_SPRITE_ENV_OPAQUE:
                prim->AlphaTestEnable(0);
                prim->AlphaTest(1, 0);
                prim->AlphaBlendEnable(0);
                prim->AlphaBlend(MG_ALPHA_BLEND_NONE);
                prim->DepthTestEnable(0);
                prim->ZMask(MG_Z_MASK_MASKED);
                prim->Shading(0);
                prim->TextureMapEnable(1);
                prim->Bilinear(1);
                return;
            case MENU_SPRITE_ENV_COLOR_NO_DEPTH:
                prim->AlphaTestEnable(1);
                prim->AlphaTest(1, 0);
                prim->AlphaBlendEnable(1);
                prim->AlphaBlend(MG_ALPHA_BLEND_NORMAL);
                prim->DepthTestEnable(0);
                prim->ZMask(MG_Z_MASK_MASKED);
                prim->Shading(1);
                prim->TextureMapEnable(0);
                break;
            default:
                break;
        }
    }
}

/**
 *
 * Appends vertices and texture coordinates for a repeated menu primitive.
 *
 */
void PushPrimRepeat(mgCDrawPrim *prim, float *positions, int *tex_coords, int count) {
    for (int i = 0; i < count; i++) {
        prim->TextureCrd(tex_coords[i * 2], tex_coords[i * 2 + 1]);
        prim->Vertex(positions[i * 2], positions[i * 2 + 1], 0.0f);
    }
}

void PrimQuad(mgCDrawPrim *prim, float x, float y, mgRect<int> cell) {
    if (prim != nullptr && dc2::text::DrawTitleLettering(*prim, x, y, cell)) {
        return;
    }
    prim->TextureCrd(cell.left, cell.top);
    prim->Vertex(x, y, 0.0f);
    prim->TextureCrd(cell.left + cell.right, cell.top + cell.bottom);
    prim->Vertex(x + cell.right, y + cell.bottom, 0.0f);
}

void PrimQuad(mgCTexture *texture, float x, float y, mgRect<int> cell, int alpha, int red, int green,
              int blue);

void PrimQuad(mgCDrawPrim *prim, mgCTexture *texture, float x, float y, mgRect<int> cell, int alpha,
              int red, int green, int blue) {
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(texture);
    prim->Color(red, green, blue, alpha);
    PrimQuad(prim, x, y, cell);
    prim->End();
}

void PrimQuad(mgCTexture *texture, mgRect<int> dest, mgRect<int> source, int alpha, int red, int green,
              int blue) {

    mgCDrawPrim prim;
    SetSpriteEnv(&prim, MENU_SPRITE_ENV_TEXTURE);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(texture);
    prim.Color(red, green, blue, alpha);
    PrimQuad(&prim, dest, source);
    prim.End();
}

void PrimQuad(mgCDrawPrim *prim, mgCTexture *texture, mgRect<int> dest, mgRect<int> source, int alpha,
              int red, int green, int blue) {
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(texture);
    prim->Color(red, green, blue, alpha);
    PrimQuad(prim, dest, source);
    prim->End();
}

void MenuClipRectCheck(mgRect<int> &rect) {
    if (rect.left < 0) {
        rect.left = 0;
    }

    if (rect.top < 0) {
        rect.top = 0;
    }

    int max_x = mgScreenWidth - 1;

    if (max_x < rect.right) {
        rect.right = max_x;
    }

    int max_y = mgScreenHeight - 1;

    if (max_y < rect.bottom) {
        rect.bottom = max_y;
    }
}

void SetMenuScissor(mgRect<int> rect) {
    mgCDrawPrim *prim = GetMenuPrim();
    prim->Initialize(nullptr, nullptr);
    prim->Begin(MG_PRIM_POINT);
    prim->Direct(SCE_GS_SCISSOR_1, rect.left | (static_cast<s64>(rect.right) << 16) | (static_cast<s64>(rect.top) << 32) | (static_cast<s64>(rect.bottom) << 48));
    prim->End();
}

void ResetMenuScissor() {
    mgCDrawPrim *prim = GetMenuPrim();
    prim->Initialize(nullptr, nullptr);
    prim->Begin(MG_PRIM_POINT);
    prim->Direct(SCE_GS_SCISSOR_1, (static_cast<s64>(mgScreenWidth - 1) << 16) | (static_cast<s64>(mgScreenHeight - 1) << 48));
    prim->End();
}

int SetModeMenuDrawItemBoard(int mode) {
    int            k = {};
    CGameDataUsed *item = nullptr;
    int            party = {};
    CGameDataUsed *used = {};

    MenuDrawItemInfoNum = 0;
    party = GetUserDataMan()->GetNowPartyMember();

    if (mode == MENU_ITEM_BOARD_BAG) {
        for (k = 0; k < 150; k++) {
            MenuDrawItemInfo[k] = &MenuUserParam.used_data[k];
        }

        MenuDrawItemInfoNum = GetNowBagMax(ITEM_BOARD_ALL);
    }

    if (mode == MENU_ITEM_BOARD_WEAPON) {
        if (party & (1 << USER_CHARA_MAX)) {
            MenuDrawItemInfo[MenuDrawItemInfoNum] = &MenuUserParam.chara[0]->equip[0];
            MenuDrawItemInfoNum++;
            MenuDrawItemInfo[MenuDrawItemInfoNum] = &MenuUserParam.chara[0]->equip[1];
            MenuDrawItemInfoNum++;
        }

        if (party & (1 << USER_CHARA_MONICA)) {
            MenuDrawItemInfo[MenuDrawItemInfoNum] = &MenuUserParam.chara[1]->equip[0];
            MenuDrawItemInfoNum++;
            MenuDrawItemInfo[MenuDrawItemInfoNum] = &MenuUserParam.chara[1]->equip[1];
            MenuDrawItemInfoNum++;
        }

        item = MenuUserParam.used_data;

        for (k = 0; k < 150; k++, item++) {
            if (item->used_type == USED_ITEM_TYPE_WEAPON) {
                MenuDrawItemInfo[MenuDrawItemInfoNum] = item;
                MenuDrawItemInfoNum++;
            }
        }
    }

    if (mode == MENU_ITEM_BOARD_RIDEPOD_ARM) {
        if (party & (1 << USER_CHARA_ROBO)) {
            MenuDrawItemInfo[MenuDrawItemInfoNum] = &MenuUserParam.robo->parts[0];
            MenuDrawItemInfoNum++;
        }

        item = MenuUserParam.used_data;

        for (k = 0; k < 150; k++, item++) {
            if (item->item_type == ITEM_DATA_ROBO_ARM) {
                MenuDrawItemInfo[MenuDrawItemInfoNum] = item;
                MenuDrawItemInfoNum++;
            }
        }
    }

    if (mode == MENU_ITEM_BOARD_ENERGY_PACK) {
        if (party & (1 << USER_CHARA_ROBO)) {
            MenuDrawItemInfo[MenuDrawItemInfoNum] = &MenuUserParam.robo->parts[2];
            MenuDrawItemInfoNum++;
        }

        item = MenuUserParam.used_data;

        for (k = 0; k < 150; k++, item++) {
            if (item->item_type == ITEM_DATA_ROBO_ENERGY_PACK) {
                MenuDrawItemInfo[MenuDrawItemInfoNum] = item;
                MenuDrawItemInfoNum++;
            }
        }
    }

    if (mode == MENU_ITEM_BOARD_FISH) {
        if (0 < GetUserItemHaveNum(ITEM_ID_AQUARIUM)) {
            CFishAquarium *aquarium = GetAquariumData();

            if (aquarium != nullptr) {
                used = aquarium->GetAquariumFishTop(AQUARIUM_TANK_FIRST);

                for (k = 0; k < 6; k++, used++) {
                    if (0 < used->item_no) {
                        MenuDrawItemInfo[MenuDrawItemInfoNum] = used;
                        MenuDrawItemInfoNum++;
                    }
                }
            }
        }

        item = MenuUserParam.used_data;

        for (k = 0; k < 150; k++, item++) {
            if (item->used_type == USED_ITEM_TYPE_FISH) {
                MenuDrawItemInfo[MenuDrawItemInfoNum] = item;
                MenuDrawItemInfoNum++;
            }
        }
    }

    for (k = MenuDrawItemInfoNum; k < 150; k++) {
        MenuDrawItemInfo[k] = nullptr;
    }

    return MenuDrawItemInfoNum;
}

void EnableUseItemAlphaStep() {
    use_item_enable_alpha_angle += 0.052359879f;

    if (use_item_enable_alpha_angle >= PI) {
        use_item_enable_alpha_angle -= TWO_PI;
    }

    use_item_enable_alpha = static_cast<int>(48.0f + 32.0f * sinf(use_item_enable_alpha_angle));
}

void InitSpectolRasterTable(mgCMemory *memory) {
    int   row = {};
    int   column = {};
    int   offset = {};
    float angle = {};
    spectol_raster_xtbl = reinterpret_cast<float *>(memory->Alloc(0x4E0));

    for (row = 0, offset = 0; row < 0x9C; row++) {
        angle = 0.0418879f * static_cast<float>(row);

        while (PI < angle) {
            angle -= TWO_PI;
        }

        for (column = 0; column < 0x20; column++) {
            spectol_raster_xtbl[offset + column] = 3.0f * sinf(angle);
            angle += 0.15707964f;
        }

        offset += 0x20;
    }
}

void DrawOneItem(mgCDrawPrim *prim, mgRect<float> rect, int item, int mode, MENU_PARTS_EFFECT_STRUCT1 *effect, u8 *rgba,
                 int item_flag) {
    if (rect.top + rect.bottom >= 0.0f && mgScreenWidth - 1 >= rect.left) {
        mgRect<int>        icon_uv(0, 0, 0, 0);
        mgCTextureManager *textures = &mgTexManager;
        GetMenuItemIconTexGetXY(item, icon_uv);
        mgCTexture *tex = GetMenuItemIconTexInfo(item, mode);

        if (tex != nullptr) {
            if (mode != MENU_ICON_MODE_NORMAL) {
                textures->ReloadCLUT(tex, (sceVif1Packet *) nullptr);
            }

            if (effect != nullptr) {
                effect->param[0] += 1.0f;

                if (effect->param[0] > 150.0f) {
                    effect->param[0] = 0.0f;
                }

                effect[1].param[0]++;
            }

            mgRect<int> uv(item_transtbl[use_trans_rect].left, item_transtbl[use_trans_rect].top,
                           item_transtbl[use_trans_rect].right, item_transtbl[use_trans_rect].bottom);
            u_int       tbp = tex->tex0.value & 0x3FFF;
            u_int       tbw = (tex->tex0.value >> 14) & 0x3F;
            prim->Begin(MG_PRIM_POINT);
            prim->Direct(SCE_GS_BITBLTBUF, SCE_GS_SET_BITBLTBUF(tbp, tbw, SCE_GS_PSMT8, tbp, tbw, SCE_GS_PSMT8));
            prim->Direct(SCE_GS_TRXPOS, SCE_GS_SET_TRXPOS(icon_uv.left, icon_uv.top, uv.left, uv.top, 0));
            prim->Direct(SCE_GS_TRXREG, SCE_GS_SET_TRXREG(icon_uv.right, icon_uv.bottom));
            prim->Direct(SCE_GS_TRXDIR, SCE_GS_SET_TRXDIR(2));
            prim->End();
            float right = rect.left + rect.right;
            float bottom = rect.top + rect.bottom;
            int   uv_right = uv.left + uv.right;
            int   uv_bottom = uv.top + uv.bottom;

            if (mode != MENU_ICON_MODE_SPECTRUM) {
                SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
                prim->Begin(MG_PRIM_SPRITE);
                prim->Texture(tex);

                if (mode == MENU_ICON_MODE_NORMAL) {
                    mgRect<float> shadow(3.0f + rect.left, 3.0f + rect.top, rect.right, rect.bottom);
                    prim->Color(0, 0, 0, rgba[3] * 40 / 128);
                    prim->TextureCrd(uv.left, uv.top);
                    prim->Vertex(shadow.left, shadow.top, 0.0f);
                    prim->TextureCrd(uv_right, uv_bottom);
                    prim->Vertex(shadow.left + shadow.right, shadow.top + shadow.bottom, 0.0f);
                }

                if ((item_flag & MENU_ITEM_ICON_HIGHLIGHT) || item == ITEM_ID_FRUIT_OF_EDEN) {
                    int add = 0x30;

                    if (DrawItemDefCounter < 40) {
                        add = -36;
                    }

                    int red = rgba[0] + add;

                    if (red < 0) {
                        red = 0;
                    }

                    int green = rgba[1] + add;

                    if (green < 0) {
                        green = 0;
                    }

                    int blue = rgba[2] + add;

                    if (blue < 0) {
                        blue = 0;
                    }

                    prim->Color(red, green, blue, rgba[3]);
                } else {
                    prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
                }

                prim->TextureCrd(uv.left, uv.top);
                prim->Vertex(rect.left, rect.top, 0.0f);
                prim->TextureCrd(uv_right, uv_bottom);
                prim->Vertex(right, bottom, 0.0f);

                if (item >= 0xED && item < 0xF5) {
                    prim->End();
                    prim->Bilinear(1);
                    prim->Begin(MG_PRIM_SPRITE);
                    int *paint = paint_color_table_1234[item - 0xED];
                    prim->Color(paint[0] * rgba[0] >> 7, paint[1] * rgba[1] >> 7, paint[2] * rgba[2] >> 7,
                                paint[3] * rgba[3] >> 7);
                    prim->TextureCrd(0x80, 0xC0);
                    prim->Vertex(rect.left, rect.top, 0.0f);
                    prim->TextureCrd(0xA0, 0xE0);
                    prim->Vertex(right, bottom, 0.0f);
                    prim->End();
                    prim->Bilinear(0);
                    prim->Begin(MG_PRIM_SPRITE);
                }

                if (mode == MENU_ICON_MODE_DIMMED) {
                    prim->Color(0x14, 0x14, 0x14, rgba[3] >> 2);
                    prim->TextureCrd(uv.left, uv.top);
                    prim->Vertex(rect.left, rect.top, 0.0f);
                    prim->TextureCrd(uv_right, uv_bottom);
                    prim->Vertex(right, bottom, 0.0f);
                }

                if (item >= 0x188 && item < 0x1A6) {
                    prim->Texture(tex);
                    prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
                    int mark = (item - 0x188) % 3;
                    int mark_u = mark % 2 * 16 + 0xC0;
                    int mark_v = mark / 2 * 16 + 0x1A0;
                    prim->TextureCrd(mark_u, mark_v);
                    float mark_y = {};
                    float mark_x = {};
                    mark_x = rect.left + 16.0f;
                    mark_y = rect.top + 20.0f;
                    prim->Vertex(mark_x, mark_y, 0.0f);
                    prim->TextureCrd(mark_u + 16, mark_v + 16);
                    prim->Vertex(16.0f + mark_x, 16.0f + mark_y, 0.0f);
                }
            } else if (mode == MENU_ICON_MODE_SPECTRUM) {
                SetSpriteEnv(prim, MENU_SPRITE_ENV_ADD);
                prim->AntiAliasing(0);
                prim->Begin(MG_PRIM_SPRITE);
                prim->Texture(tex);
                prim->Color(rgba[0], rgba[1], rgba[2], rgba[3] >> 2);
                prim->TextureCrd(uv.left, uv.top);
                prim->Vertex(rect.left, rect.top, 0.0f);
                prim->TextureCrd(uv_right, uv_bottom);
                prim->Vertex(right, bottom, 0.0f);
                prim->Flush();

                if (effect != nullptr) {
                    u8    blue = {};
                    int   raster = static_cast<int>(effect->param[0]) * 32;
                    u8    red = {};
                    float hue = mgAngleLimit(DEG_TO_RAD * effect[1].param[0]);
                    int   line_v = uv.top;
                    float line_y = rect.top;
                    u8    green = {};

                    for (int line = 0; line < 32; line++, line_v++) {
                        float line_x = rect.left + static_cast<int>(spectol_raster_xtbl[raster + line]);
                        float line_h = spectol_y_addtbl_1245[line];
                        red = 255.0f * sinf(hue);
                        green = 255.0f * sinf(2.0943952f + hue);
                        blue = 255.0f * sinf(4.1887903f + hue);
                        prim->Color(red, green, blue, rgba[3] / 3);
                        prim->TextureCrd(uv.left, line_v);
                        prim->Vertex(line_x, line_y, 0.0f);
                        prim->TextureCrd(uv.left + 32, line_v + 1);
                        line_y += line_h;
                        prim->Vertex(32.0f + line_x, line_y, 0.0f);
                        hue += 0.049087387f;
                    }
                }
            }

            prim->End();

            if (item_flag & MENU_ITEM_ICON_BUILD_UP) {
                float mark_x = {};
                float mark_right = {};
                float mark_y = {};
                float mark_bottom = {};
                mark_x = 23.0f + rect.left;
                mark_y = 16.0f + rect.top - DrawItemCounter;
                mark_right = 16.0f + mark_x;
                mark_bottom = 16.0f + mark_y;
                prim->Bilinear(1);
                prim->Begin(MG_PRIM_SPRITE);
                prim->Color(0x80, 0x80, 0x80, 0x80);
                prim->Texture(tex);
                prim->TextureCrd(0xD0, 0x1B0);
                prim->Vertex(mark_x, mark_y, 0.0f);
                prim->TextureCrd(0xE0, 0x1C0);
                prim->Vertex(mark_right, mark_bottom, 0.0f);
                mark_y += 13.0f;
                mark_bottom += 13.0f;
                prim->TextureCrd(0xD0, 0x1B0);
                prim->Vertex(mark_x, mark_y, 0.0f);
                prim->TextureCrd(0xE0, 0x1C0);
                prim->Vertex(mark_right, mark_bottom, 0.0f);
                prim->End();
                prim->Bilinear(0);
            }

            if (item == ITEM_ID_MEDAL_HOLDER) {
                prim->Begin(MG_PRIM_SPRITE);
                prim->Texture(MenuPosData->item_icon_tex[0][0]);
                prim->Color(0x80, 0x80, 0x80, rgba[3]);
                prim->TextureCrd(0xC0, 0x240);
                prim->Vertex(3.0f + rect.left, 2.0f + rect.top, 0.0f);
                prim->TextureCrd(0xE0, 0x260);
                prim->Vertex(3.0f + right, 2.0f + bottom, 0.0f);
                prim->End();
            }
        }
    }
}

/**
 *
 * Draws a help window from three vertically stacked texture sections.
 *
 */
void MenuWindowHelp(mgCDrawPrim *prim, mgCTexture *texture, float x, float y, float width, float height,
                    short *table) {
    if (texture != nullptr) {
        mgRect<int> top;
        mgRect<int> middle;
        mgRect<int> bottom;

        if (table == nullptr) {
            table = MenuWindowHelpTable_1346;
        }

        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(texture);
        prim->Color(128, 128, 128, 128);
        top.Set(static_cast<int>(x), static_cast<int>(y), static_cast<int>(width), 24);
        Menu3DivideTextureDraw(prim, top, table, 1);
        middle.Set(static_cast<int>(x), static_cast<int>(24.0f + y), static_cast<int>(width), static_cast<int>(height));
        Menu3DivideTextureDraw(prim, middle, &table[12], 1);
        bottom.Set(static_cast<int>(x), static_cast<int>(24.0f + y + height), static_cast<int>(width), 24);
        Menu3DivideTextureDraw(prim, bottom, &table[24], 1);
        prim->End();
    }
}

void MenuPresentBoxView(int x, int y, int &tex_block, mgCTexture *tex, mgCTexture *cursor_tex) {
    mgCDrawPrim *prim = {};
    mgRect<int> *window = {};
    int          item_x = {};
    int          i = {};

    if (NowGiftBoxPtr != nullptr && NowGiftBoxPtr->used_type == USED_ITEM_TYPE_GIFT_BOX) {
        prim = GetMenuPrim();

        if (y < mgScreenHeight / 2 - 30) {
            y += 0x38;
        } else {
            y -= 0x46;
        }

        window = &GiftBoxWindowPutPos;
        window->Set(x, y, 0x90, 0x38);

        if (window->left > 0x15C) {
            window->left = 0x15C;
        }

        if (window->left < 0x14) {
            window->left = 0x14;
        }

        if (window->top < 0x28) {
            window->top = 0x28;
        }

        if (window->top > 0x154) {
            window->top = 0x154;
        }

        MenuReloadTexture(tex_block, tex->block);
        MenuWindowHelp(prim, tex, window->left, window->top, window->right, 22.0f, nullptr);

        if (MenuPosData != nullptr && MenuPosData->item_icon_tex[0][0] != nullptr) {
            MenuReloadTexture(tex_block, MenuPosData->item_icon_tex[0][0]->block);
        }

        item_x = window->left + 14;

        for (i = 0; i < 3; i++) {
            Pos_ItemInGiftBox[i][0] = item_x;
            Pos_ItemInGiftBox[i][1] = window->top + 16;

            if (NowGiftBoxPtr->data.giftbox.item_no[i] > 0) {
                mgRect<float> item_rect(Pos_ItemInGiftBox[i][0], Pos_ItemInGiftBox[i][1], 32.0f, 40.0f);
                DrawOneItem(prim, item_rect, NowGiftBoxPtr->data.giftbox.item_no[i], 0, nullptr, rgbatbl_1379, 0);
            }

            item_x += 41;
        }

        if (GiftBoxViewFlag != 0 && cursor_tex != nullptr) {
            static float curpos = 0.0f;

            curpos += (Pos_ItemInGiftBox[NowGiftBoxSelect][0] - curpos) / 4.0f;

            if (curpos < Pos_ItemInGiftBox[0][0]) {
                curpos = Pos_ItemInGiftBox[0][0];
            }

            if (curpos > Pos_ItemInGiftBox[2][0]) {
                curpos = Pos_ItemInGiftBox[2][0];
            }

            MenuReloadTexture(tex_block, cursor_tex->block);
            cursor_put_pos cursor = {
                {0.0f, 0.0f}
            };
            cursor.pos[0] = curpos - 32.0f;
            cursor.pos[1] = Pos_ItemInGiftBox[NowGiftBoxSelect][1];
            MenuCursorDraw(cursor_tex, cursor.pos, 0.0f, 0x80);
        }
    }
}

/**
 *
 * Sets the minimum digit width used when drawing menu numbers.
 *
 */
static void SetMenuDrawNumberKeta(char value) {
    MenuDrawNumberKeta = value;
}

/**
 *
 * Returns its argument unchanged.
 *
 */
template <typename T>
static inline T Ident(T value) { return value; }

/**
 *
 * Draws a number with the selected alignment and optional digit padding.
 *
 */
int DrawMenuNumber(mgCDrawPrim *prim, int number, int align, mgRect<int> rect, mgRect<int> texture_rect, int step_x,
                   int step_y) {
    int digits = GetNumberKeta(number);
    int digit_w = texture_rect.right;
    int x = rect.left;
    int y = rect.top;
    int padding = MenuDrawNumberKeta;

    if (align == MENU_NUMBER_ALIGN_CENTER) {
        x = static_cast<int>(static_cast<float>(x) + 0.5f * static_cast<float>(step_x) * static_cast<float>(digits - 1));
    }

    if (align == MENU_NUMBER_ALIGN_LEFT) {
        if (padding < 0) {
            x += step_x * (digits - 1);
        } else {
            x += step_x * (padding - 1);
        }
    }

    while (digits > 0) {
        mgRect<int> dst;
        mgRect<int> src;
        int         put_y = y;
        x -= step_x;
        y -= step_y;
        src.Set(texture_rect.left + digit_w * (number % 10), texture_rect.top, digit_w, texture_rect.bottom);
        dst.Set(x, put_y, rect.right, rect.bottom);
        PrimQuad(prim, dst, src);
        number /= 10;
        digits--;
        padding--;
    }

    while (padding > 0) {
        mgRect<int> dst;
        mgRect<int> src;
        int         put_y = y;
        x -= step_x;
        y -= step_y;
        int top = texture_rect.top;
        int bottom = texture_rect.bottom;
        src.Set(texture_rect.left, Ident(top), digit_w, Ident(bottom));
        dst.Set(x, put_y, rect.right, rect.bottom);
        PrimQuad(prim, dst, src);
        padding--;
    }

    return x;
}

void PrimDrawNumber(mgCDrawPrim *prim, int number, int alignment, int x, int y,
                    mgRect<int> texture_rect, int spacing, int vertical_spacing) {
    SetMenuDrawNumberKeta(-1);
    mgRect<int> rect(x, y, texture_rect.right, texture_rect.bottom);
    DrawMenuNumber(prim, number, alignment, rect, texture_rect, texture_rect.right + spacing, vertical_spacing);
}

void PrimDrawNumber2(mgCDrawPrim *prim, int number, int digit_count, int x, int y,
                     mgRect<int> texture_rect, int spacing, int vertical_spacing) {
    SetMenuDrawNumberKeta(digit_count);
    mgRect<int> rect(x, y, texture_rect.right, texture_rect.bottom);
    DrawMenuNumber(prim, number, MENU_NUMBER_ALIGN_RIGHT, rect, texture_rect, texture_rect.right + spacing, vertical_spacing);
}

void PrimFillRect4(mgCDrawPrim *prim, mgRect<float> rect, float *rgba0, float *rgba1, float *rgba2, float *rgba3) {
    float right = {};
    float bottom = {};

    if (rgba0 == nullptr || rgba1 == nullptr || rgba2 == nullptr || rgba3 == nullptr) {
        return;
    }

    right = rect.left + rect.right;
    bottom = rect.top + rect.bottom;
    prim->Color(static_cast<int>(rgba0[0]), static_cast<int>(rgba0[1]), static_cast<int>(rgba0[2]), static_cast<int>(rgba0[3]));
    prim->Vertex(rect.left, rect.top, 0.0f);
    prim->Color(static_cast<int>(rgba1[0]), static_cast<int>(rgba1[1]), static_cast<int>(rgba1[2]), static_cast<int>(rgba1[3]));
    prim->Vertex(right, rect.top, 0.0f);
    prim->Color(static_cast<int>(rgba2[0]), static_cast<int>(rgba2[1]), static_cast<int>(rgba2[2]), static_cast<int>(rgba2[3]));
    prim->Vertex(rect.left, bottom, 0.0f);
    prim->Color(static_cast<int>(rgba3[0]), static_cast<int>(rgba3[1]), static_cast<int>(rgba3[2]), static_cast<int>(rgba3[3]));
    prim->Vertex(right, bottom, 0.0f);
}

void MenuReloadTexture(int &loaded_tex, int tex_no) {
    mgCTextureManager *manager = &mgTexManager;

    if (loaded_tex != tex_no) {
        loaded_tex = tex_no;
        manager->ReloadTexture(loaded_tex, (sceVif1Packet *) nullptr);
    }
}

void MenuReloadCLUT(int index);

void DrawMenuFillBox(int alpha, int red, int green, int blue);

void DrawMenuFillBox(float x, float y, float width, float height, int alpha, int red, int green, int blue) {
    mgCDrawPrim *prim = {};

    prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_COLOR);
    prim->DepthTestEnable(0);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Color(red, green, blue, alpha);
    prim->Vertex(x, y, 0.0f);
    prim->Vertex(x + width, y + height, 0.0f);
    prim->End();
}

void DrawMenuFillBox(mgCDrawPrim *prim, float x, float y, float width, float height, int alpha, int red,
                     int green, int blue) {
    SetSpriteEnv(prim, MENU_SPRITE_ENV_COLOR);
    prim->DepthTestEnable(0);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Color(red, green, blue, alpha);
    prim->Vertex(x, y, 0.0f);
    prim->Vertex(x + width, y + height, 0.0f);
    prim->End();
}

/**
 *
 * Generates the points of a scribbled line that wanders down and up within a box.
 *
 */
bool GenarateRandamLine(std::span<const int, 2> origin, int width, int height, std::span<int[2]> points, int count) {
    if (origin.data() == nullptr || count <= 0 || static_cast<std::size_t>(count) > points.size() || width <= 0 || height <= 0) {
        return false;
    }
    bool                            rising = true;
    long long                       offset = 0;
    std::vector<std::array<int, 2>> generated(static_cast<std::size_t>(count));
    for (auto &point : generated) {
        float progress = static_cast<float>(offset) / static_cast<float>(height);
        if (progress <= 0.06f) {
            progress = 0.04f;
        }
        const float     sway = static_cast<float>(GetRandI(width) - width / 2);
        const float     x = static_cast<float>(origin[0]) + sway * sinf(PI * progress);
        const long long y = static_cast<long long>(origin[1]) + offset;
        if (!std::isfinite(x) || static_cast<double>(x) < std::numeric_limits<int>::min() ||
            static_cast<double>(x) > std::numeric_limits<int>::max() || y < std::numeric_limits<int>::min() ||
            y > std::numeric_limits<int>::max()) {
            return false;
        }
        point[0] = static_cast<int>(x);
        point[1] = static_cast<int>(y);
        const int step = GetRandI(15);
        offset += rising ? step : -step;
        if (offset > height) {
            rising = false;
        } else if (offset < 0) {
            rising = true;
        }
    }
    const auto stride = static_cast<std::size_t>(GetRandI(7) + 4);
    for (std::size_t index = 0; index + stride < generated.size(); index += stride) {
        std::swap(generated[index][1], generated[index + stride][1]);
    }
    for (std::size_t index = 0; index < generated.size(); ++index) {
        points[index][0] = generated[index][0];
        points[index][1] = generated[index][1];
    }
    return true;
}

/**
 *
 * Draws a smoothed decorative line from its generated points.
 *
 */
void DrawRandamLine(mgCDrawPrim *prim, std::span<const int[2]> points, int smoothing, int count, std::span<const u8, 4> color) {
    sceVu0FVECTOR source[1000];
    sceVu0FVECTOR smoothed[2000];
    if (prim == nullptr || count < 3 || smoothing < 2 || static_cast<std::size_t>(count) > std::size(source) ||
        static_cast<std::size_t>(count) > points.size() ||
        static_cast<std::size_t>(count - 1) > std::size(smoothed) / static_cast<std::size_t>(smoothing)) {
        return;
    }
    for (int index = 0; index < count; ++index) {
        source[index][0] = static_cast<float>(points[static_cast<std::size_t>(index)][0]);
        source[index][1] = static_cast<float>(points[static_cast<std::size_t>(index)][1]);
        source[index][2] = 0.0f;
        source[index][3] = 1.0f;
    }
    const int total = CreatSmoothPass(smoothed, std::span(source).first(static_cast<std::size_t>(count)), count, smoothing, 0);
    if (total <= 0) {
        return;
    }
    SetSpriteEnv(prim, MENU_SPRITE_ENV_COLOR_NO_DEPTH);
    prim->Begin(MG_PRIM_LINE_STRIP);
    prim->Color(color[0], color[1], color[2], color[3]);
    prim->Vertex(smoothed[0][0], smoothed[0][1], 0.0f);
    for (int index = 0; index < total; ++index) {
        prim->Vertex(smoothed[index][0], smoothed[index][1], 0.0f);
    }
    prim->End();
}

mgCTexture *GetMenuDlTexture() {
    return mgTexManager.GetTexture("menudl", -1);
}

void InitMenuDl(mgCTexture *texture, int total_size) {
    Tex_MenuDl = texture;
    MenuDl_TotalSize = total_size;
    MenuDl_ProcessSize = 0;
}

int StepMenuDl(int step) {
    if (MenuDl_TotalSize <= 0) {
        return true;
    }

    MenuDl_ProcessSize += step;

    if (MenuDl_TotalSize <= MenuDl_ProcessSize) {
        MenuDl_ProcessSize = MenuDl_TotalSize;
        return true;
    }

    return false;
}

int StepMenuDl2(int progress) {
    if (MenuDl_TotalSize <= 0) {
        return true;
    }

    MenuDl_ProcessSize = progress;

    if (MenuDl_TotalSize <= progress) {
        MenuDl_ProcessSize = MenuDl_TotalSize;
        return true;
    }

    return false;
}

void DrawMenuDl(int &tex_block, int x, int y, int w, int alpha) {
    mgCDrawPrim *prim = {};
    int          left = {};
    float        rate = {};
    float        bar_len = {};
    int          bar_w = {};
    int          i = {};
    mgRect<int>  frame_tex;
    mgRect<int>  bar_tex;
    mgRect<int>  frame_rect;
    mgRect<int>  bar_rect;
    mgRect<int>  shadow_rect;
    mgRect<int>  window_rect;

    if (Tex_MenuDl != nullptr) {
        MenuReloadTexture(tex_block, Tex_MenuDl->block);
        left = (mgScreenWidth - w) >> 1;
        prim = GetMenuPrim();
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(Tex_MenuDl);
        prim->Color(0x80, 0x80, 0x80, alpha);
        frame_tex.Set(0x74, 0, 0xC, 0xC);
        bar_tex.Set(0x6D, 1, 6, 0xA);
        frame_rect.Set(left + 4, y + 0x40, w - 10, 0xE);
        PrimQuad(prim, frame_rect, frame_tex);
        prim->End();
        prim->Begin(MG_PRIM_SPRITE);
        bar_len = static_cast<float>(w) - static_cast<float>(table_1650[0][0].right - 20 + table_1650[1][1].left) - 2.0f;
        rate = static_cast<float>(MenuDl_ProcessSize) / static_cast<float>(MenuDl_TotalSize);
        bar_w = static_cast<int>(bar_len * rate);

        if (rate < 1.0f) {
            prim->Color(0x80, 0x80, 0x80, alpha);
        } else {
            prim->Color(0x40, 0x94, 0x40, alpha);
        }

        bar_rect.Set(left + 0x17, y + 0x41, bar_w, 0xA);
        PrimQuad(prim, bar_rect, bar_tex);
        prim->End();
        prim->Bilinear(0);
        prim->Begin(MG_PRIM_SPRITE);

        for (i = 0; i < 3; i++) {
            prim->Color(0, 0, 0, alpha >> 2);
            shadow_rect.Set(left + 4, y + 4, w, table_1650[i][0].bottom);
            Menu3DivideTextureDraw(prim, shadow_rect, &table_1650[i][0].left, 1);
            prim->Color(0x80, 0x80, 0x80, alpha);
            window_rect.Set(left, y, w, table_1650[i][0].bottom);
            Menu3DivideTextureDraw(prim, window_rect, &table_1650[i][0].left, 1);
            y += table_1650[i][0].bottom;
        }

        prim->End();
    }
}

void DrawMenuDl(int alpha) {
    char text[0x80];
    int  loaded_tex_no = {};
    int  caption_height = {};
    int  caption_width = {};

    if (Tex_MenuDl != nullptr) {
        if (alpha < 0) {
            alpha = 0;
        }

        loaded_tex_no = -1;
        int panel_width = 0x10E;

        if (LanguageCode == LANG_FRENCH || LanguageCode == LANG_ITALIAN || LanguageCode == LANG_SPANISH) {
            panel_width = 0x13A;
        }

        DrawMenuDl(loaded_tex_no, 0, 0x72, panel_width, alpha);
        int         language = LanguageCode;
        mgCTexture *texture = mgTexManager.GetTexture("gaiji", -1);

        if (texture != nullptr) {
            MenuReloadTexture(loaded_tex_no, texture->block);
            int step = StepMenuDl(0);
            memset(text, 0, sizeof(text));
            ConvertFontCode(tbl_1689[language][step], text);
            CMenuFont menu_font;
            menu_font.alpha = alpha;
            menu_font.SetStr(text);
            menu_font.CalcDrawWH(menu_font.str, &caption_width, &caption_height);
            menu_font.SetPos((0x200 - caption_width) >> 1, 0x86);
            menu_font.DrawDirect(menu_font.str, menu_font.pos_x, menu_font.pos_y);
        }
    }
}

void CalcCommonBrdDrawInfo(float *pos, MENUFORM_MAKEBRD_INFO *info, ClsMes *mes) {
    float board_w = {};
    int   i = {};
    int   center_x = {};
    int   quarter_w = {};
    int   left_x = {};
    int   right_x = {};

    if (info == nullptr || mes == nullptr) {
        Tex_CommonBoard = nullptr;
        return;
    }

    Tex_CommonBoard = mgTexManager.GetTexture("makebrd", -1);
    board_w = 188.0f;

    if (LanguageCode > LANG_JAPANESE) {
        board_w = 208.0f;
    }

    board_line_width line_w = {
        {0, 0, 0, 0}
    };

    for (i = 0; i < 4; i++) {
        if (mes->name[i + 1][0] != 0) {
            line_w.width[i] = mes->GetStrWidth(mes->name[i + 1]);
        }

        if (line_w.width[i] > board_w) {
            board_w = line_w.width[i];
        }
    }

    MakeBoardDrawInfo[4] = 40.0f + board_w;
    pos[0] = (static_cast<float>(mgScreenWidth) - MakeBoardDrawInfo[4]) / 2.0f - 18.0f;
    center_x = mgScreenWidth >> 1;
    board_w = MakeBoardDrawInfo[4];
    quarter_w = static_cast<int>(board_w) >> 2;
    left_x = center_x - quarter_w - (mes->line_w[0] >> 1);

    if (left_x < 22.0f + pos[0]) {
        left_x = 22.0f + pos[0];
    }

    right_x = center_x + quarter_w - (mes->line_w[1] >> 1);

    if (board_w / 2.0f < mes->line_w[1]) {
        right_x = static_cast<float>(center_x) + board_w / 2.0f - mes->line_w[1] - 4.0f;
    }

    mes->SetMovePosGyou(0, left_x, static_cast<int>(16.0f + pos[1]));
    mes->SetMovePosGyou(1, right_x, static_cast<int>(42.0f + pos[1]));

    for (i = 0; i < 4; i++) {
        if (mes->name[i + 1][0] != 0) {
            mes->SetMovePosGyou(i + 2, static_cast<int>(18.0f + (20.0f + pos[0])), static_cast<int>(1.0f + (92.0f + pos[1] + static_cast<float>(i * 34))));
        } else {
            mes->SetMovePosGyou(i + 2, -1, -1);
        }
    }

    dc2::memory::CopyTrackedBytes(&CommonBoardDrawInfo, info, sizeof(MENUFORM_MAKEBRD_INFO));
}

void CommonBoardDraw(float *pos, int &tex_block) {
    mgCTexture *board_tex = Tex_CommonBoard;

    if (board_tex == nullptr) {
        return;
    }

    make_object_husoku_number_blink += 1.0f;

    if (59.0f < make_object_husoku_number_blink) {
        make_object_husoku_number_blink = 0.0f;
    }

    MenuReloadTexture(tex_block, board_tex->block);
    mgCDrawPrim    *prim = GetMenuPrim();
    board_number_uv number_uv = {
        {{0, 116, 10, 12}, {0, 104, 10, 12}}
    };
    board_line_uv row_uv = {
        {
         {{0, 0, 22, 25}, {23, 0, 2, 25}, {24, 0, 22, 25}},
         {{0, 25, 22, 2}, {23, 25, 2, 2}, {24, 25, 22, 2}},
         {{0, 27, 22, 14}, {23, 27, 2, 14}, {24, 27, 22, 14}},
         {{0, 41, 22, 2}, {23, 41, 2, 2}, {24, 41, 22, 2}},
         {{0, 43, 22, 24}, {23, 43, 2, 24}, {24, 43, 22, 24}},
         {{0, 66, 22, 24}, {23, 66, 2, 24}, {24, 66, 22, 24}},
         }
    };
    int   heights[5] = {row_uv.uv[0][0][3], 200, row_uv.uv[2][0][3], 54, row_uv.uv[4][0][3]};
    int   board_w = static_cast<int>(MakeBoardDrawInfo[4]);
    float board_x = pos[0];
    float board_y = pos[1];
    SetSpriteEnv(prim, MENU_SPRITE_ENV_COLOR);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Color(0x28, 0x24, 0x23, 0x80);
    float fill_y = {};
    float fill_x = 10.0f + board_x;
    fill_y = 10.0f + board_y;
    prim->Vertex(fill_x, fill_y, 0.0f);
    prim->Vertex(fill_x + board_w + 20.0f, fill_y + heights[1] + heights[2], 0.0f);
    prim->End();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Bilinear(0);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(Tex_CommonBoard);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    int left = {};
    int top = {};
    int row = {};
    int pass = {};

    for (row = 0; row < 5; row++) {
        left = static_cast<int>(6.0f + pos[0]);
        top = static_cast<int>(6.0f + board_y);
        board_pass_color pass_color = {
            {{0, 0, 0, 46}, {128, 128, 128, 128}}
        };

        for (pass = 0; pass < 2; pass++) {
            int *rgba = pass_color.rgba[pass];
            prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
            prim->TextureCrd(row_uv.uv[row][0][0], row_uv.uv[row][0][1]);
            prim->Vertex(left, top, 0);
            prim->TextureCrd(row_uv.uv[row][0][0] + row_uv.uv[row][0][2], row_uv.uv[row][0][1] + row_uv.uv[row][0][3]);
            prim->Vertex(left + row_uv.uv[row][0][2], top + heights[row], 0);
            left += row_uv.uv[row][0][2];
            prim->TextureCrd(row_uv.uv[row][1][0], row_uv.uv[row][1][1]);
            prim->Vertex(left, top, 0);
            prim->TextureCrd(row_uv.uv[row][1][0] + row_uv.uv[row][1][2], row_uv.uv[row][1][1] + row_uv.uv[row][1][3]);
            prim->Vertex(left + board_w, top + heights[row], 0);
            left += board_w;
            prim->TextureCrd(row_uv.uv[row][2][0], row_uv.uv[row][2][1]);
            prim->Vertex(left, top, 0);
            prim->TextureCrd(row_uv.uv[row][2][0] + row_uv.uv[row][2][2], row_uv.uv[row][2][1] + row_uv.uv[row][2][3]);
            prim->Vertex(left + row_uv.uv[row][2][2], top + heights[row], 0);
            top -= 6;
            left = static_cast<int>(pos[0]);
        }

        board_y += heights[row];
    }

    prim->End();
    float       title_x = 16.0f + pos[0];
    float       title_y = 66.0f + pos[1];
    mgRect<int> title_uv(0x30, 0, 0x50, 0x14);
    prim->Bilinear(0);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(Tex_CommonBoard);
    prim->Color(0x80, 0x80, 0x80, 0x80);
    PrimQuad(prim, mgRect<int>(static_cast<int>(title_x), top = static_cast<int>(title_y), title_uv.right, title_uv.bottom), title_uv);
    prim->End();
    float blink = 32.0f * sinf(0.05235988f * make_object_husoku_number_blink);
    int   blink_rgba[4] = {static_cast<int>(blink) + 0x80, 0x80 - static_cast<int>(blink), 0x80 - static_cast<int>(blink), 0x80};
    int   line_w = board_w - 10;
    prim->Bilinear(1);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(Tex_CommonBoard);
    prim->Color(0x80, 0x80, 0x80, 0x80);

    for (pass = 0; pass < 4; pass++) {
        MENUFORM_MAKEBRD_LINE *line = &CommonBoardDrawInfo.line[pass];
        float                  line_x = {};
        float                  x = 20.0f + pos[0];
        line_x = x;
        float line_top = 88.0f + pos[1] + pass * 34;
        s16(*brd)[4] = get_onoffbrdtbl_1789[line->kind];
        PrimQuad(prim, mgRect<int>(static_cast<int>(x), top = static_cast<int>(line_top), brd[0][2], brd[0][3]),
                 mgRect<int>(brd[0][0], brd[0][1], brd[0][2], brd[0][3]));
        x += brd[0][2];
        PrimQuad(prim, mgRect<int>(static_cast<int>(x), top, line_w, brd[1][3]),
                 mgRect<int>(brd[1][0], brd[1][1], brd[1][2], brd[1][3]));
        int number_x = {};
        x += line_w;
        PrimQuad(prim, mgRect<int>(number_x = static_cast<int>(x), top, brd[2][2], brd[2][3]),
                 mgRect<int>(brd[2][0], brd[2][1], brd[2][2], brd[2][3]));
        int number_y = {};
        PrimDrawNumber2(prim, line->num, 0, number_x, number_y = static_cast<int>(10.0f + line_top),
                        mgRect<int>(number_uv.uv[0][0], number_uv.uv[0][1], 10, 13), 0, 0);
        int times_x = static_cast<int>(x - GetNumberKeta(line->num) * 10 - 12.0f);
        PrimQuad(prim, mgRect<int>(times_x, static_cast<int>(9.0f + line_top) + 1, 10, 12), mgRect<int>(0x14, 0x5C, 10, 12));

        if (line->sub_num > 0) {
            prim->Color(blink_rgba[0], blink_rgba[1], blink_rgba[2], 0x80);
            PrimDrawNumber2(prim, line->sub_num, 0, times_x - 2, number_y,
                            mgRect<int>(number_uv.uv[1][0], number_uv.uv[1][1], 10, 13), 0, 0);
            PrimQuad(prim, mgRect<int>(times_x - 14 - GetNumberKeta(line->sub_num) * 10, number_y, 10, 12),
                     mgRect<int>(0x1E, 0x5C, 10, 12));
            prim->Color(0x80, 0x80, 0x80, 0x80);
        }

        if (line->kind != 0) {
            s8 *button = get_btntbl_1810[line->button];
            PrimQuad(prim, mgRect<int>(static_cast<int>(line_x - 3.0f), top, 16, 16), mgRect<int>(button[0], button[1], 16, 16));
        }
    }

    float yes_y = 246.0f + pos[1];
    MakeBoardDrawInfo[1] = yes_y;
    MakeBoardDrawInfo[0] = MakeBoardDrawInfo[2] = (mgScreenWidth >> 1) - MakeBoardDrawInfo[4] / 3.0f;
    MakeBoardDrawInfo[3] = 28.0f + yes_y;
    board_button_color button_color = {
        {
         {{192, 192, 192, 128}, {128, 128, 128, 128}},
         {{128, 128, 128, 128}, {192, 192, 192, 128}},
         }
    };
    mgRect<int> yes_uv(0x44, 0x14, 0x3C, 0x1A);
    mgRect<int> no_uv(0x44, 0x2E, 0x3C, 0x1A);
    int (*rgba)[4] = button_color.rgba[CommonBoardDrawInfo.make_cursor];
    prim->Color(rgba[0][0], rgba[0][1], rgba[0][2], rgba[0][3]);
    PrimQuad(prim, mgRect<int>(static_cast<int>(MakeBoardDrawInfo[0]), static_cast<int>(MakeBoardDrawInfo[1]), yes_uv.right, yes_uv.bottom), yes_uv);
    prim->Color(rgba[1][0], rgba[1][1], rgba[1][2], rgba[1][3]);
    PrimQuad(prim, mgRect<int>(static_cast<int>(MakeBoardDrawInfo[2]), static_cast<int>(MakeBoardDrawInfo[3]), no_uv.right, no_uv.bottom), no_uv);
    int arrow_x = static_cast<int>(10.0f + pos[0] + MakeBoardDrawInfo[4] / 2.0f + MakeBoardDrawInfo[4] / 10.0f + 2.0f);
    int arrow_y = static_cast<int>(250.0f + pos[1]);
    prim->Color(0x80, 0x80, 0x80, 0x80);

    if (CommonBoardDrawInfo.decrease_flash_frames > 0) {
        prim->Color(0xC4, 0xC4, 0xC4, 0x80);
    }

    PrimQuad(prim, mgRect<int>(arrow_x, arrow_y, 0x10, 0x16), mgRect<int>(0x60, 0x48, 0x10, 0x16));
    prim->Color(0x80, 0x80, 0x80, 0x80);
    int count_y = static_cast<int>(250.0f + pos[1]);
    int count_x = arrow_x + 0x10;
    PrimQuad(prim, mgRect<int>(count_x, count_y, 6, 0x16), mgRect<int>(0x36, 0x32, 6, 0x16));
    PrimQuad(prim, mgRect<int>(count_x + 6, count_y, 0x14, 0x16), mgRect<int>(0x3C, 0x32, 2, 0x16));
    PrimQuad(prim, mgRect<int>(count_x + 0x1A, count_y, 6, 0x16), mgRect<int>(0x3E, 0x32, 6, 0x16));

    if (CommonBoardDrawInfo.increase_flash_frames > 0) {
        prim->Color(0xC4, 0xC4, 0xC4, 0x80);
    }

    PrimQuad(prim, mgRect<int>(count_x + 0x22, arrow_y, 0x10, 0x16), mgRect<int>(0x70, 0x48, 0x10, 0x16));
    prim->Color(0x80, 0x80, 0x80, 0x80);
    PrimDrawNumber(prim, CommonBoardDrawInfo.make_num, MENU_NUMBER_ALIGN_CENTER, count_x + 0x15, count_y + 5, mgRect<int>(number_uv.uv[0][0], number_uv.uv[0][1], 10, 13), 0, 0);
    prim->End();
}

void MenuCursorDraw(mgCTexture *tex, float *pos, float rot, int reverse, int alpha, float scale);

void MenuCursorDraw(mgCTexture *tex, float *pos, float rot, int alpha) {
    MenuCursorDraw(tex, pos, rot, 0, alpha, 1.0f);
}

void DrawMenuTilePattern(mgCDrawPrim *prim, mgCTexture *tex, float x, float y, mgRect<int> tex_rect, int unused,
                         u8 *rgba);

void DrawMenuMainFrmImg(int &loaded_tex_no, mgRect<int> dest, mgRect<int> source, int red, int green,
                        int blue, int alpha, int unused) {
    mgCTexture *texture = MenuPosData->common_tex;

    if (texture != nullptr) {
        MenuReloadTexture(loaded_tex_no, texture->block);
        mgCDrawPrim *prim = GetMenuPrim();
        SetSpriteEnv(prim, MENU_SPRITE_ENV_OPAQUE);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(texture);
        prim->Color(red, green, blue, alpha);
        PrimQuad(prim, dest, source);
        prim->End();
    }
}

int GetMenuMainFrameEndFlag() {
    return MenuMainFrame_ActionEndFlag;
}

float *GetMenuMainFrameLeftTopPos(int frame) {
    return MenuMainFrame_LeftTop_Pos;
}

float GetMenuMainFrameCount() {
    return tbl_2072[MenuMainFrame_Display_Mode / 2];
}

void MenuMainFrameModeSet(int mode, int restart);

void MenuMainFrameStep();

void MenuMainFrameDraw(int &loaded_tex, int unused) {
    mgRect<int>        screen_rect;
    float              alpha = {}, radius_x = {}, radius_y = {}, turn = {}, scale = {}, x0 = {}, y0 = {}, x1 = {}, y1 = {}, x3 = {}, y3 = {}, x2 = {}, y2 = {}, x4 = {}, size = {}, y4 = {}, angle = {};
    mgCTextureManager *textures = &mgTexManager;
    mgCTexture        *background = textures->GetTexture("bg16", -1);

    if (background == nullptr) {
        return;
    }

    screen_rect.Set(0, 0, 0x2C0, 0x1A0);
    radius_x = 160.0f;
    alpha = 128.0f;
    float progress = MenuMainFrame_Display_Mode_Cnt / 10.0f;
    scale = 1.5f - 0.5f * progress;

    switch (MenuMainFrame_Display_Mode) {
        case MENU_MAIN_FRAME_OPEN:
        case MENU_MAIN_FRAME_CLOSE:
            alpha = 128.0f * progress;
            break;
    }

    turn = QUARTER_PI * progress;
    angle = -(PI / 6.0f) + turn;
    radius_x *= scale;
    radius_y = 120.0f * scale;
    x0 = MenuMainFrame_Lenze_Pos[0] - radius_x * cosf(angle);
    y0 = MenuMainFrame_Lenze_Pos[1] - radius_x * sinf(angle);
    x1 = MenuMainFrame_Lenze_Pos[0] - radius_y * cosf(angle - (PI / 12.0f));
    y1 = MenuMainFrame_Lenze_Pos[1] - radius_y * sinf(angle - (PI / 12.0f));
    angle += QUARTER_PI;
    x3 = MenuMainFrame_Lenze_Pos[0] - radius_x * cosf(angle);
    y3 = MenuMainFrame_Lenze_Pos[1] - radius_x * sinf(angle);
    angle = 0.24166098f + angle;
    x2 = MenuMainFrame_Lenze_Pos[0] - radius_y * cosf(angle);
    y2 = MenuMainFrame_Lenze_Pos[1] - radius_y * sinf(angle);
    turn = -0.83775806f + turn;
    x4 = MenuMainFrame_Lenze_Pos[0] - radius_x * cosf(turn);
    y4 = MenuMainFrame_Lenze_Pos[1] - radius_x * sinf(turn);
    size = 3.0 * 16.0 * scale;
    MenuReloadTexture(loaded_tex, background->block);
    mgCDrawPrim *prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Bilinear(1);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(background);
    int alpha_int = {};
    prim->Color(0x80, 0x80, 0x80, alpha_int = fptosi(alpha));
    PrimQuad(prim, MenuMainFrame_PutRect, screen_rect);
    prim->End();
    mgCTexture *ornament = textures->GetTexture("mnmain", -1);
    prim->AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim->Shading(1);
    prim->Begin(MG_PRIM_TRIANGLE_FAN);
    prim->Texture(ornament);
    prim->Color(0x80, 0x80, 0x80, alpha_int);
    prim->TextureCrd(0x1A, 8);
    prim->Vertex(x0, y0, 0.0f);
    prim->TextureCrd(0x1A, 0x1A);
    prim->Vertex(x1, y1, 0.0f);
    prim->TextureCrd(0x38, 0x1A);
    prim->Vertex(x2, y2, 0.0f);
    prim->TextureCrd(0x38, 8);
    prim->Vertex(x3, y3, 0.0f);
    prim->End();
    prim->Begin(MG_PRIM_SPRITE);
    prim->TextureCrd(4, 0xA);
    prim->Vertex(x4, y4, 0.0f);
    prim->TextureCrd(0x12, 0x18);
    prim->Vertex(fptosi(x4 + size), fptosi(y4 + 1.25f * size), 0);
    prim->End();
}

void MenuMainFrameImgDraw(int &loaded_tex_no);

void DrawMenuWakuStep() {
    float move[6] = {-0.2f, 0.0f, 18.0f, 0.2f, 18.0f, 0.0f};
    int   i = {};

    for (i = 0; i < 2; i++) {
        int n = i * 3;
        MenuWakuPutXY[i] += move[n];

        if (CalcMenuAdd(&MenuWakuPutXY[i], move[n], move[n + 1]) != 0) {
            MenuWakuPutXY[i] = move[n + 2];
        }
    }

    MenuWakuRotCnt -= PI / 220.0f;

    if (MenuWakuRotCnt <= -PI) {
        MenuWakuRotCnt += TWO_PI;
    }
}

void DrawMenuWakuRect(mgCTexture *tex, mgRect<float> rect, mgRect<int> tex_rect, int a, int r, int g, int b);

void DrawWakuCircle(mgCDrawPrim *prim, mgCTexture *tex, mgRect<float> rect, mgRect<int> tex_rect, float rot, float size,
                    int a, int r, int g, int b) {
    float         radius = size / 2.0f;
    float         center_x = rect.left + rect.right / 2.0f;
    float         center_y = rect.top + rect.bottom / 2.0f;
    sceVu0FVECTOR pos;
    quad_uv       uv = {
        {{0.0f, 0.0f}, {0.0f, 0.0f}, {0.0f, 0.0f}, {0.0f, 0.0f}}
    };
    int i = {};

    uv.corner[0][0] = tex_rect.left;
    uv.corner[0][1] = tex_rect.top;
    uv.corner[1][0] = tex_rect.left + tex_rect.right;
    uv.corner[1][1] = tex_rect.top;
    uv.corner[2][0] = tex_rect.left + tex_rect.right;
    uv.corner[2][1] = tex_rect.top + tex_rect.bottom;
    uv.corner[3][0] = tex_rect.left;
    uv.corner[3][1] = tex_rect.top + tex_rect.bottom;
    prim->Begin(MG_PRIM_TRIANGLE_FAN);
    prim->Texture(tex);
    prim->Color(r, g, b, a);

    for (i = 0; i < 4; i++) {
        pos[0] = center_x + radius * cosf(rot);
        pos[1] = center_y + radius * sinf(rot);
        prim->TextureCrd(static_cast<int>(uv.corner[i][0]), static_cast<int>(uv.corner[i][1]));
        prim->Vertex(pos);
        rot += HALF_PI;
    }

    prim->End();
}

/**
 *
 * Clears a menu base texture record and its rectangle.
 *
 */
void MENU_BASETEXINFO_Init(MENU_BASETEXINFO *info) {
    info->name = nullptr;
    info->tex_name = nullptr;
    info->rect.Set(0, 0, 0, 0);
    info->tex_block = 0;
}

void MenuPosDataTypeInit(MENUFORMPARTS_TYPE *part) {
    part->name = nullptr;
    part->active = false;
    part->draw_flag = true;
    part->dtype = MENUFORMPARTS_DTYPE_NORMAL;
    part->vibe_cnt[1] = 0;
    part->vibe_cnt[0] = 0;
    part->viber[0] = 10;
    part->viber[1] = 8;
    part->tex_info_no = 0;
    part->h = 0;
    part->w = 0;
    part->y = 0;
    part->x = 0;
    part->rgba[3] = 0x80;
    part->rgba[2] = 0x80;
    part->rgba[1] = 0x80;
    part->rgba[0] = 0x80;
    part->etc_info[2] = 0;
    part->etc_info[1] = 0;
    part->etc_info[0] = 0;
    part->picture_scale = 1.0f;
    part->effect_num = 0;
    part->effect = nullptr;
    part->alpha_blend = MG_ALPHA_BLEND_NORMAL;
    part->bilinear = 0;
    part->item_flag = 0;
    part->tex = nullptr;
    part->shadow = false;
}

void MenuFormPartsPresetItem(MENUFORMPARTS_TYPE *part, int visible, int item_no, int original_item_no) {
    if (part != nullptr) {
        part->draw_flag = visible != 0;
        part->etc_info[0] = 0;
        part->etc_info[1] = item_no;

        part->etc_info[2] = original_item_no;
        Func_MenuItemIconSetEffectOne(part);
    }
}

void CMenuPosDataForm::Initialize() {
    int i = {};
    name = nullptr;
    active = false;
    draw_flag = true;
    y = 0;
    x = 0;
    dtype = MENUFORM_DTYPE_NORMAL;
    vibe_cnt[1] = 0;
    vibe_cnt[0] = 0;
    clip_h = -1;
    clip_w = -1;
    next_y = 0;
    next_x = 0;
    rate_y = 1.1f;
    rate_x = 1.1f;
    mtype = MENUFORM_MTYPE_N;
    rgba_bit = 0;

    for (i = 0; i < 4; i++) {
        rgba_add[i] = 0;
        rgba[i] = 0x80;
        rgba_target[i] = 0x80;
    }

    counter = 0;
    parts_num = 0;
    parts = nullptr;
    chara = nullptr;
    chara_tex_block = 0;
    secondary_tex_block = 0;
    step_stop = false;
    action_no = -1;
    action_state = MENUFORM_ACTION_STATE_NONE;
    action_num = 0;
    action = nullptr;
    sub_no = 0;
    prev = nullptr;
    next = nullptr;
}

MENUFORMPARTS_TYPE *CMenuPosDataForm::GetPartInfo(const char *name) {
    int i = 0;

    while (i < parts_num) {
        if (strcmp(parts[i].name, name) == 0) {
            return &parts[i];
        }

        i++;
    }

    return nullptr;
}

void CMenuPosDataForm::SetPartDrawFlag(const char *name, bool draw_flag) {
    MENUFORMPARTS_TYPE *part = GetPartInfo(name);

    if (part != nullptr) {
        part->draw_flag = draw_flag;
    }
}

void Func_MallocPartEffectInfo(MENUFORMPARTS_TYPE *part, mgCMemory *memory, int effect_count) {
    unsigned int bytes = {};
    unsigned int blocks = {};

    if (part != nullptr) {
        bytes = effect_count * sizeof(MENU_PARTS_EFFECT_STRUCT1);
        part->effect_num = effect_count;

        if (bytes & 0xF) {
            blocks = (bytes >> 4) + 1;
        } else {
            blocks = bytes >> 4;
        }

        part->effect = reinterpret_cast<MENU_PARTS_EFFECT_STRUCT1 *>(memory->Alloc(blocks));
    }
}

void Func_SetPartEffectInfo(MENU_PARTS_EFFECT_STRUCT1 *effect, unsigned int kind, short *values) {
    int i = {};

    if (effect == nullptr) {
        return;
    }

    effect->type = kind;

    for (i = 0; i < 8; i++) {
        effect->param[i] = 0;

        if (values != nullptr) {
            effect->param[i] = values[i];
        }
    }
}

void CMenuPosDataForm::SetActionCharaPtr(CActionChara *character, int texture_block, int secondary_block) {
    chara = character;
    chara_tex_block = texture_block;
    secondary_tex_block = secondary_block;
}

void CMenuPosDataForm::SetRGBACalcParam(int index, int from, int to) {
    if (index < 0 || index > 3) {
        return;
    }

    rgba_add[index] = from;
    rgba_target[index] = to;
}

void CMenuPosDataForm::FormFadeIn(int frames, int reset) {
    int i = {};

    if (reset != 0) {
        i = 0;
        rgba[0] = 0x80;
        rgba[1] = 0x80;
        rgba[2] = 0x80;
        rgba[3] = 0;

        do {
            SetRGBACalcParam(i, 0, 0x80);
            i++;
        } while (i < 4);
    }

    SetRGBACalcParam(3, 0x80 / frames, 0x80);
}

void CMenuPosDataForm::FormFadeOut(int frames, int reset) {
    int i = {};

    if (reset != 0) {
        i = 0;
        rgba[0] = 0x80;
        rgba[1] = 0x80;
        rgba[2] = 0x80;
        rgba[3] = 0x80;

        do {
            SetRGBACalcParam(i, 0, 0x80);
            i++;
        } while (i < 4);
    }

    SetRGBACalcParam(3, -0x80 / frames, 0);
}

void CMenuPosDataForm::SetNumber(char *part_name, int number) {
    MENUFORMPARTS_TYPE *part = GetPartInfo(part_name);

    if (part != nullptr) {
        part->etc_info[1] = number;
    }
}

void CMenuPosDataForm::SetPartRGBA(char *name, int r, int g, int b, int a) {
    MENUFORMPARTS_TYPE *part = GetPartInfo(name);

    if (part != nullptr) {
        part->rgba[0] = r;
        part->rgba[1] = g;
        part->rgba[2] = b;
        part->rgba[3] = a;
    }
}

void CMenuPosDataForm::GetPutPosXY(char *part_name, int &out_x, int &out_y) {
    float pos[2] = {out_x, out_y};
    GetPutPosXY(part_name, pos[0], pos[1]);
    out_x = pos[0];
    out_y = pos[1];
}

void CMenuPosDataForm::GetPutPosXY(char *part_name, float &out_x, float &out_y) {
    float             put_x = {};
    float             put_y = {};
    int               i = {};
    CMenuPosDataForm *form = {};
    int               form_pos[2];

    put_x = x;
    put_y = y;

    if (vibe_cnt[0] != 0) {
        put_x += 10.0f * cosf((PI / vibe_cnt[0]) * counter);
    }

    if (vibe_cnt[1] != 0) {
        put_y += 8.0f * sinf((PI / vibe_cnt[1]) * counter);
    }

    if (part_name == nullptr) {
        out_x = put_x;
        out_y = put_y;
        return;
    }

    for (i = 0; i < parts_num; i++) {
        if (parts[i].name != nullptr && strcmp(parts[i].name, part_name) == 0) {
            switch (parts[i].dtype) {
                case MENUFORMPARTS_DTYPE_FORM:
                    form = MenuPosData->GetFormInfo(parts[i].tex_info_no);

                    if (form != nullptr) {
                        form->GetPutPosXY(part_name, form_pos[0], form_pos[1]);
                    }

                    put_x += form_pos[0];
                    put_y += form_pos[1];
                    break;
                case MENUFORMPARTS_DTYPE_FUNCINFO:
                    put_x += parts[i].x;
                    put_y += parts[i].y;

                    if (parts[i].vibe_cnt[0] != 0) {
                        put_x += parts[i].viber[0] * cosf(counter * (PI / parts[i].vibe_cnt[0]));
                    }

                    if (parts[i].vibe_cnt[1] != 0) {
                        put_y += parts[i].viber[1] * sinf(counter * (PI / parts[i].vibe_cnt[1]));
                    }

                    break;
                default:
                    put_x += parts[i].x;
                    put_y += parts[i].y;
                    break;
            }

            break;
        }
    }

    out_x = put_x;
    out_y = put_y;
}

MENUFORMPARTS_TYPE *CMenuPosDataForm::GetEnableEnterPart() {
    int i = {};

    for (i = 0; i < parts_num; i++) {
        if (parts[i].name == nullptr && parts[i].active == 0) {
            return &parts[i];
        }
    }

    return nullptr;
}

int CMenuPosDataForm::GetNowPosRGBA(MENUFORMPARTS_TYPE *part, MENU_BASETEXINFO *tex_info, float *pos, u8 *rgba) {
    MENU_PARTS_EFFECT_STRUCT1 *effect = {};
    int                        i = {};
    int                        k = {};
    int                        n = {};
    float                      center_x = {};
    float                      center_y = {};
    float                      angle = {};
    float                      phase = {};
    float                      cos_angle = {};
    float                      sin_angle = {};
    float                      scale_x = {};
    float                      scale_y = {};
    float                      shrink = {};
    int                        dx = {};
    int                        dy = {};
    float                      rot[4][4];
    float                      sway[4][2];
    short                      color = {};

    if (part == nullptr) {
        return false;
    }

    effect = part->effect;

    if (effect == nullptr || part->effect_num <= 0) {
        return false;
    }

    center_x = tex_info->rect.right + (x + part->x);
    center_y = tex_info->rect.bottom + (y + part->y);

    for (i = 0; i < part->effect_num && effect != nullptr; i++, effect++) {
        if (effect->type == MENU_PARTS_EFFECT_FILLBOX) {
            if (effect->param[0] <= effect->param[1]) {
                rgba[0] = effect->param[2];
                rgba[1] = effect->param[3];
                rgba[2] = effect->param[4];
                rgba[3] = effect->param[5];
            }
        } else if (effect->type == MENU_PARTS_EFFECT_BLINK) {
            for (k = 0; k < 4; k++) {
                color = rgba[k] + static_cast<int>(effect->param[2] * cosf((TWO_PI / effect->param[1]) * effect->param[0]));
                rgba[k] = color;
            }
        } else if (effect->type == MENU_PARTS_EFFECT_ROT || effect->type == MENU_PARTS_EFFECT_HURIKO) {
            angle = 0.0f;
            phase = effect->param[0];

            if (effect->type == MENU_PARTS_EFFECT_HURIKO) {
                if (effect->param[1] > 0.0f) {
                    if (phase >= effect->param[1] / 2.0f) {
                        phase = effect->param[1] - phase;
                    }
                } else if (effect->param[1] < 0.0f && phase <= effect->param[1] / 2.0f) {
                    phase = effect->param[1] - phase;
                }
            }

            if (effect->param[4] != 0.0f) {
                angle = (TWO_PI / effect->param[4]) * phase;
            }

            angle += TWO_PI / effect->param[5];
            cos_angle = cosf(angle);
            sin_angle = sinf(angle);

            for (k = 0; k < 4; k++) {
                rot[k][0] = cos_angle;
                rot[k][1] = sin_angle;
                rot[k][2] = -sin_angle;
                rot[k][3] = cos_angle;
            }

            for (k = 0; k < 4; k++) {
                n = k * 2;
                dx = pos[n] - center_x;
                dy = pos[n + 1] - center_y;
                pos[n] = center_x + (dx * rot[k][0] + dy * rot[k][1]);
                pos[n + 1] = center_y + (dx * rot[k][2] + dy * rot[k][3]);
            }
        } else if (effect->type == MENU_PARTS_EFFECT_STRETCH || effect->type == MENU_PARTS_EFFECT_STRETCH_REP) {
            phase = effect->param[0] / 3.0f;
            scale_x = effect->param[4] + phase;
            scale_y = effect->param[5] + phase;

            if (effect->type == MENU_PARTS_EFFECT_STRETCH_REP && phase > effect->param[1] / 2.0f) {
                shrink = effect->param[1] - phase;
                scale_x = (effect->param[4] - shrink) / 100.0f;
                scale_y = (effect->param[5] - shrink) / 100.0f;
            }

            pos[0] = center_x + part->w / 2.0f * scale_x;
            pos[1] = center_y + part->h / 2.0f * scale_y;
            pos[2] = center_x + part->w / 2.0f * scale_x;
            pos[3] = center_y + part->h / 2.0f * scale_y;
            pos[4] = center_x + part->w / 2.0f * scale_x;
            pos[5] = center_y + part->h / 2.0f * scale_y;
            pos[6] = center_x + part->w / 2.0f * scale_x;
            pos[7] = center_y + part->h / 2.0f * scale_y;
        } else if (effect->type == MENU_PARTS_EFFECT_STRETCH_SIN) {
            sin_angle = sinf(TWO_PI * effect->param[0] / effect->param[1]);
            sway[0][0] = -sin_angle;
            sway[0][1] = -sin_angle;
            sway[1][0] = sin_angle;
            sway[1][1] = -sin_angle;
            sway[2][0] = -sin_angle;
            sway[2][1] = sin_angle;
            sway[3][0] = sin_angle;
            sway[3][1] = sin_angle;

            for (k = 0; k < 4; k++) {
                pos[k * 2] += effect->param[4] * sway[k][0];
                pos[k * 2 + 1] += effect->param[5] * sway[k][1];
            }
        }
    }

    return true;
}

void CMenuPosDataForm::MenuPartsStep() {
    int                        i = {};
    MENUFORMPARTS_TYPE        *part = {};
    MENU_PARTS_EFFECT_STRUCT1 *effect = {};
    int                        finished = {};
    int                        j = {};

    for (i = 0; i < parts_num; i++) {
        part = &parts[i];

        if (part != nullptr && (effect = part->effect) != nullptr) {
            for (j = 0; j < part->effect_num; j++, effect++) {
                finished = false;

                if (effect->type == MENU_PARTS_EFFECT_ICON_COUNTER) {
                    continue;
                }

                if (effect->type == MENU_PARTS_EFFECT_SPARKLE) {
                    effect->param[0] += 1.0f;

                    if (effect->param[0] >= effect->param[1]) {
                        SetPartEffectInfoRandFunc(effect);
                    }
                } else if (effect->type == MENU_PARTS_EFFECT_FILLBOX) {
                    effect->param[0] += 1.0f;

                    if (effect->param[0] > effect->param[1]) {
                        effect->param[0] = 1.0f + effect->param[1];
                    }
                } else if (effect->type == MENU_PARTS_EFFECT_BLINK) {
                    effect->param[0] += 1.0f;

                    if (effect->param[0] >= effect->param[1]) {
                        finished = true;
                        effect->param[0] = 0.0f;
                    }
                } else if (effect->type == MENU_PARTS_EFFECT_ROT || effect->type == MENU_PARTS_EFFECT_HURIKO ||
                           effect->type == MENU_PARTS_EFFECT_UNK_10 || effect->type == MENU_PARTS_EFFECT_UNK_11) {
                    if (effect->param[1] > 0.0f) {
                        effect->param[0] += 1.0f;

                        if (effect->param[0] >= effect->param[1]) {
                            effect->param[0] = 0.0f;
                            finished = true;
                        }
                    } else if (effect->param[1] < 0.0f) {
                        effect->param[0] -= 1.0f;

                        if (effect->param[0] <= effect->param[1]) {
                            effect->param[0] = 0.0f;
                            finished = true;
                        }
                    }
                } else if (effect->type == MENU_PARTS_EFFECT_STRETCH || effect->type == MENU_PARTS_EFFECT_STRETCH_REP ||
                           effect->type == MENU_PARTS_EFFECT_STRETCH_SIN) {
                    if (effect->param[1] < 0.0f) {
                        effect->param[0] -= 1.0f;

                        if (effect->param[0] <= effect->param[1]) {
                            effect->param[0] = 0.0f;
                            finished = true;
                        }
                    } else if (effect->param[1] > 0.0f) {
                        effect->param[0] += 1.0f;

                        if (effect->param[0] >= effect->param[1]) {
                            effect->param[0] = 0.0f;
                            finished = true;
                        }
                    }
                } else if (effect->type == MENU_PARTS_EFFECT_UNK_12) {
                    effect->param[0] += 1.0f;
                }

                if (finished != 0 && effect->repeat == 0) {
                    effect->active = false;
                }
            }
        }
    }
}

/**
 *
 * Draws the sparkles of a spectrumised item icon.
 *
 */
static void DrawItemIconEffect2(mgCDrawPrim *prim, mgCTexture *tex, MENUFORMPARTS_TYPE *part, mgRect<float> rect) {
    MENU_PARTS_EFFECT_STRUCT1 *effect = {};
    int                        i = {};
    int                        k = {};
    int                        n = {};
    short                      center_x = {};
    short                      center_y = {};
    float                      sin_angle = {};
    float                      cos_angle = {};
    float                      scale = {};
    float                      angle = {};
    int                        alpha = {};
    int                       *color = {};
    float                      dx = {};
    float                      dy = {};

    if (part != nullptr && part->effect != nullptr) {
        effect = &part->effect[2];
        mgRect<float> star_rect;
        float         corners[4][2];
        int           uv[8];
        star_rect.left = rect.left;
        star_rect.top = rect.top;
        star_rect.right = 8.0f;
        star_rect.bottom = 8.0f;
        ConvMGIRECTtoINTtbl(star_light, uv);
        SetSpriteEnv(prim, MENU_SPRITE_ENV_ADD);
        prim->Begin(MG_PRIM_TRIANGLE_STRIP);
        prim->Texture(tex);

        for (i = 0; i < 5; i++, effect++) {
            if (!(effect->param[0] <= 0.0f)) {
                star_rect.left = rect.left + effect->param[2];
                star_rect.top = rect.top + effect->param[3];
                ConvMGFRECTtoFLOATtbl(star_rect, corners[0]);
                center_x = 4.0f + star_rect.left;
                center_y = 4.0f + star_rect.top;
                scale = effect->param[5];
                angle = 0.34906587f * effect->param[6];
                sin_angle = sinf(angle);
                cos_angle = cosf(angle);
                alpha = static_cast<int>(64.0f * sinf((PI / effect->param[1]) * effect->param[0]));
                color = &star_color_table[static_cast<int>(3.0f * effect->param[4])];
                prim->Color(color[0], color[1], color[2], alpha);

                for (k = 0; k < 4; k++) {
                    dx = scale * (static_cast<float>(center_x) - corners[k][0]);
                    dy = scale * (static_cast<float>(center_y) - corners[k][1]);
                    corners[k][0] = center_x + dx * cos_angle - dy * sin_angle;
                    corners[k][1] = center_y + dx * sin_angle + dy * cos_angle;
                    n = k * 2;
                    prim->TextureCrd(uv[n], uv[n + 1]);
                    prim->Vertex(static_cast<int>(corners[0][n]), static_cast<int>(corners[0][n + 1]), 0);
                }

                prim->Flush();
            }
        }

        prim->End();
    }
}

void MenuItemBrdSetInfo(int unused, int pos, int max_line, int view_line) {
    float hidden_lines = {};
    MenuItemBrdMaxLine = max_line;
    MenuItemBrdViewLine = view_line;
    hidden_lines = static_cast<float>(max_line - view_line);

    if (hidden_lines < 1.0f) {
        hidden_lines = 1.0f;
    }

    MenuItemBrdScrlCurLen = 256.0f / hidden_lines;
    MenuItemBrdCalcManner = MENU_ITEM_BRD_CALC_JUMP;
    Func_MenuItemBrdPosStep(pos);
}

void MenuItemBrdFrameDraw(int x, int y, int &tex_block, int a, int r, int g, int b) {
    int          edge = {};
    int          clip_left = {};
    int          shadow_alpha = {};
    int          j = {};
    int          clip_top = {};
    int          row_top = {};
    mgCDrawPrim *prim = GetMenuPrim();
    mgRect<int>  put(0, 0, 0, 0);
    mgRect<int>  top_left(0, 0, 32, 32);
    mgRect<int>  top(32, 0, 32, 32);
    mgRect<int>  top2(64, 0, 32, 32);
    mgRect<int>  top_right(96, 0, 32, 32);
    mgRect<int>  left(0, 32, 32, 32);
    mgRect<int>  right(96, 32, 32, 32);
    mgRect<int>  left2(0, 64, 32, 32);
    mgRect<int>  right2(96, 64, 32, 32);
    mgRect<int>  bottom_left(0, 96, 32, 32);
    mgRect<int>  bottom(32, 96, 32, 32);
    mgRect<int>  bottom2(64, 96, 32, 32);
    mgRect<int>  bottom_right(96, 96, 32, 32);
    mgRect<int> *parts[12] = {&top_left, &top, &top2, &top_right, &left, &right,
                              &left2, &right2, &bottom_left, &bottom, &bottom2, &bottom_right};
    int          i = {};
    float        put_x = {};
    float        put_y = {};
    mgCTexture  *tex = mgTexManager.GetTexture("mt0", -1);

    if (tex != nullptr) {
        MenuReloadTexture(tex_block, tex->block);
        put.right = 40;
        put_x = x;
        put_y = y;
        put_x += 4.0f;
        put_y += 262.0f;
        clip_left = put_x;
        clip_top = static_cast<int>(put_y + 20.0f);
        int         clip_right = static_cast<int>(put_x + 300.0f);
        mgRect<int> clip(clip_left, clip_top, clip_right, static_cast<int>(put_y + 50.0f));
        MenuClipRectCheck(clip);
        SetMenuScissor(clip);
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        prim->Bilinear(1);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(tex);
        prim->Color(r, g, b, a);
        int part = {};
        part = 8;
        prim->Color(0, 0, 0, shadow_alpha = static_cast<int>(2.0f * a / 3.0f));
        PrimQuad(prim, mgRect<float>(put_x, put_y, 40.0f, 32.0f), *parts[frmtbl0_2922[part++]]);
        put_x += 40.0f;
        int put_top = {};

        for (j = 0; j < 5; j++) {
            edge = static_cast<int>(put_x);
            PrimQuad(prim, mgRect<int>(edge, clip_left = static_cast<int>(put_y), 40, 32), *parts[frmtbl0_2922[part++]]);
            put_x += 40.0f;
        }

        PrimQuad(prim, mgRect<int>(static_cast<int>(put_x), clip_left, 32, 32), *parts[11]);
        prim->End();
        ResetMenuScissor();
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        put_y = y;
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(tex);
        prim->Color(r, g, b, a);
        part = 0;

        for (i = 0; i < 2; i++) {
            put_x = x;
            edge = static_cast<int>(put_x);
            PrimQuad(prim, mgRect<int>(edge, row_top = static_cast<int>(put_y), 32, 40), *parts[frmtbl0_2922[part++]]);
            PrimQuad(prim, mgRect<int>(static_cast<int>(put_x + 32.0f), row_top, 8, 40), *parts[frmtbl0_2922[part++]]);
            put_x += 40.0f;

            for (j = 0; j < 5; j++) {
                PrimQuad(prim, mgRect<int>(static_cast<int>(put_x), row_top, 40, 40), *parts[frmtbl0_2922[part++]]);
                put_x += 40.0f;
            }

            PrimQuad(prim, mgRect<int>(static_cast<int>(put_x - 8.0f), row_top, 6, 40), *parts[frmtbl0_2922[part - 1]]);
            PrimQuad(prim, mgRect<int>(static_cast<int>(put_x - 2.0f), row_top, 32, 40), *parts[frmtbl0_2922[part++]]);
            put_y += 250.0f;
        }

        put.right = 32;
        part = 0;
        put_x = x;

        for (i = 0; i < 2; i++) {
            put_y = y + 40;
            int put_left{};

            for (j = 0; j < 5; ++j) {
                put_left = static_cast<int>(put_x);
                PrimQuad(prim, mgRect<int>(put_left, static_cast<int>(put_y), 32, 40), *parts[frmtbl1_2938[part++]]);
                put_y += 40.0f;
            }

            PrimQuad(prim, mgRect<int>(put_left, static_cast<int>(put_y), 32, 10), *parts[frmtbl1_2938[part - 1]]);
            put_x += 238.0f;
        }

        prim->End();
        float            bar_x = x + 260;
        int              heights[3] = {ItemBoardScrlBar1.bottom, 0x102, ItemBoardScrlBar3.bottom};
        int              layers[10] = {4, 0, 0, 0, shadow_alpha, 0, r, g, b, a};
        scroll_bar_parts bars = {
            {&ItemBoardScrlBar1, &ItemBoardScrlBar2, &ItemBoardScrlBar3}
        };
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(tex);

        for (int i = 0; i < 2; i++) {
            int pos = i * 5;
            prim->Color(layers[pos + 1], layers[pos + 2], layers[pos + 3], layers[pos + 4]);
            float bar_y = y + 9;

            for (j = 0; j < 3; j++) {
                mgRect<int> *bar = bars.rect[j];
                prim->TextureCrd(bar->left, bar->top);
                prim->Vertex(bar_x + layers[pos], bar_y + layers[pos], 0.0f);
                prim->TextureCrd(bar->left + bar->right, bar->top + bar->bottom);
                prim->Vertex(bar_x + bar->right + layers[pos], bar_y + heights[j] + layers[pos], 0.0f);
                bar_y += heights[j];
            }
        }

        prim->End();
        float bar_top = y + 9 + layers[0];

        if (MenuItemBrdScrlBarY < bar_top) {
            MenuItemBrdScrlBarY = bar_top;
        }

        prim->Bilinear(1);
        prim->Begin(MG_PRIM_SPRITE);
        PrimQuad(prim, mgRect<float>(8.0f + bar_x, MenuItemBrdScrlBarY, ItemBoardCursor.right, MenuItemBrdScrlCurLen), ItemBoardCursor);
        prim->End();
    }
}

void MenuItemBrdDraw(float *pos, mgRect<int> clip_rect, int &tex_block, int a, int r, int g, int b) {
    mgCDrawPrim *prim = {};
    mgCTexture  *tex = {};
    int          bottom = {};
    int          last_row = {};
    int          row = {};
    int          col = {};
    int          line_x0 = {};
    int          line_x1 = {};
    int          line_y = {};
    mgRect<int>  koma;
    mgRect<int>  scissor;

    prim = GetMenuPrim();
    koma = MenuItemBrdKomaRect;
    tex = mgTexManager.GetTexture("mt0", -1);

    if (tex != nullptr && !(mgScreenWidth < pos[0])) {
        scissor.left = clip_rect.left;
        scissor.top = clip_rect.top;
        scissor.right = clip_rect.right;
        scissor.bottom = bottom = clip_rect.bottom;
        MenuClipRectCheck(scissor);
        MenuReloadTexture(tex_block, tex->block);
        last_row = GetNowBagMax(ITEM_BOARD_MAIN) / 6;
        mgRect<int> put(0, 0, 0, 0);
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(tex);
        prim->Color(r, g, b, a);
        prim->Direct(SCE_GS_SCISSOR_1, scissor.left | (static_cast<s64>(scissor.right) << 16) | (static_cast<s64>(scissor.top) << 32) |
                                           (static_cast<s64>(scissor.bottom) << 48));
        put.top = static_cast<int>(pos[1]);
        put.right = 40;
        put.bottom = 50;
        mgRect<int> unused(0, 0, 0, 0);

        for (row = 0; row < 26; row++) {
            if (bottom < put.top) {
                break;
            }

            put.left = static_cast<int>(pos[0]);

            for (col = 0; col < 6; col++) {
                if (mgScreenWidth < put.left) {
                    break;
                }

                PrimQuad(prim, put, koma);
                put.left += put.right;
            }

            if (row == last_row && OmakeFlag == 0) {
                prim->End();
                prim->TextureMapEnable(0);
                prim->Bilinear(1);
                prim->Shading(1);
                prim->Begin(MG_PRIM_SPRITE);
                prim->Color(0xDE, 0xDE, 0xDE, a);
                line_x0 = static_cast<int>(pos[0] - 2.0f);
                line_x1 = static_cast<int>(pos[0] + static_cast<float>(put.right * 6));
                line_y = put.top - 1;
                prim->Vertex(line_x0, line_y, 0);
                prim->Vertex(line_x1, line_y + 1, 0);
                prim->End();
                prim->Begin(MG_PRIM_SPRITE);
                prim->Color(0xAC, 0xAC, 0xAC, a * 3 / 5);
                prim->Vertex(line_x0, line_y + 2, 0);
                prim->Vertex(line_x1, line_y + 3, 0);
                prim->End();
                prim->Begin(MG_PRIM_SPRITE);
                prim->Color(0x80, 0x80, 0x80, a / 5);
                prim->Vertex(line_x0, line_y + 4, 0);
                prim->Vertex(line_x1, line_y + 5, 0);
                prim->End();
                prim->TextureMapEnable(1);
                prim->Bilinear(0);
                prim->Shading(0);
                prim->Begin(MG_PRIM_SPRITE);
                prim->Color(r, g, b, a);
            }

            put.top += put.bottom;
        }

        prim->Direct(SCE_GS_SCISSOR_1, (static_cast<s64>(mgScreenWidth - 1) << 16) | (static_cast<s64>(mgScreenHeight - 1) << 48));
        prim->End();
    }
}

/**
 *
 * Returns the item number of a used item.
 *
 */
static inline int UsedItemNo(CGameDataUsed *used) { return used->item_no; }

void MenuItemModeItemDraw(int &tex_block, mgRect<int> clip_rect, float *pos, MENUFORMPARTS_TYPE *parts,
                          mgCTexture *num_tex, mgRect<int> num_rect, int unused_arg) {
    float              height = {};
    mgCTextureManager *textures = {};
    mgCDrawPrim       *prim = {};
    MENU_ICON_MODE     icon_mode;
    mgCTexture        *effect_tex = {};
    int                left = {};
    int                y = {};
    int                num_x = {};
    int                num_y = {};
    int                bag_max = {};
    int                row = {};
    int                col = {};
    int                item_flag = {};
    int                num_space = {};
    int                num_vertical_spacing = {};
    int                num = {};
    int                x = {};
    prim = GetMenuPrim();
    textures = &mgTexManager;
    mgCTexture *icon_tex = MenuPosData->item_icon_tex[0][0];
    mgCTexture *icon_tex2 = MenuPosData->item_icon_tex[0][1];

    if (icon_tex == nullptr || icon_tex2 == nullptr) {
        return;
    }

    effect_tex = MenuPosData->icon_effect_tex;
    left = static_cast<int>(4.0f + pos[0]);
    y = static_cast<int>(4.0f + pos[1]);
    mgRect<int> scissor;
    scissor.left = clip_rect.left;
    scissor.top = clip_rect.top;
    scissor.right = clip_rect.right;
    scissor.bottom = clip_rect.bottom;
    MenuClipRectCheck(scissor);
    mgRect<float> item_rect(0.0f, 0.0f, 0.0f, 0.0f);
    item_rect.right = 32.0f;
    item_rect.bottom = 40.0f;
    mgRect<int> unused(0, 0, 32, 32);
    MenuReloadTexture(tex_block, icon_tex->block);
    SetMenuScissor(scissor);
    bag_max = GetNowBagMax(ITEM_BOARD_MAIN);
    int no = 0;

    for (row = 0; row < 25; row++, y += 50) {
        if (y > clip_rect.bottom) {
            break;
        }

        for (col = 0, x = 0; col < 6; x += 40, col++, no++) {
            if (y < -40 || (parts != nullptr && parts->draw_flag == 0)) {
                if (parts != nullptr) {
                    parts++;
                }

                continue;
            }

            if (no >= MenuDrawItemInfoNum) {
                break;
            }

            item_rect.left = left + x;
            item_rect.top = y;
            CGameDataUsed *used = MenuDrawItemInfo[no];
            int            item_no = UsedItemNo(used);

            if (mgScreenWidth < item_rect.left || item_no <= 0) {
                if (parts != nullptr) {
                    parts++;
                }

                continue;
            }

            num_x = static_cast<int>(33.0f + item_rect.left);
            num_y = static_cast<int>(26.0f + item_rect.top);
            num = used->GetNum();
            MENU_PARTS_EFFECT_STRUCT1 *effect = nullptr;
            u8                        *rgba = static_rgba_table_3128;
            item_flag = 0;
            num_space = 0;
            num_vertical_spacing = 0;

            if (parts != nullptr) {
                effect = parts->effect;
                item_flag = parts->item_flag;
                rgba = parts->rgba;
                num_space = static_cast<int>(parts->x);
                num_vertical_spacing = static_cast<int>(parts->y);
            }

            icon_mode = MENU_ICON_MODE_NORMAL;

            if (item_no == ITEM_ID_SPECTOL) {
                item_no = used->GetSpectolNo();
                icon_mode = MENU_ICON_MODE_SPECTRUM;
            } else if (item_no == ITEM_ID_BOILED_FISH) {
                item_no = used->data.item.num;
                icon_mode = MENU_ICON_MODE_BOILED_FISH;
            } else if (used->used_type == USED_ITEM_TYPE_FISH && effect != nullptr) {
                float *wait = &MenuPosData->fish_jump_wait[no];

                if (*wait > 0.0f) {
                    *wait -= 1.0f;

                    if (*wait <= 0.0f) {
                        effect[1].param[0] = 0.0f;
                        MenuPosData->fish_jump_height[no] = 3.0f + GetRandF(7.0f);
                        MenuPosData->fish_jump_count[no] = 2;
                    }
                } else {
                    height = MenuPosData->fish_jump_height[no] *
                             sinf(effect[1].param[0] * rottbl_3145[MenuPosData->fish_jump_count[no]]);

                    if (height > 0.0f) {
                        item_rect.top -= height;
                    } else {
                        effect[1].param[0] = 0.0f;
                        MenuPosData->fish_jump_height[no] *= 0.4f;
                        MenuPosData->fish_jump_count[no]--;

                        if (MenuPosData->fish_jump_count[no] <= 0) {
                            *wait = 16.0f + GetRandF(12.0f);
                        }
                    }
                }
            } else if (item_no == ITEM_ID_MEDAL_HOLDER) {
                num = GetUserDataMan()->yarikomi_medal;
            }

            if (no < bag_max) {
                DrawOneItem(prim, item_rect, item_no, icon_mode, effect, rgba, item_flag);

                if (num >= 2 || item_no == ITEM_ID_MEDAL_HOLDER) {
                    prim->Begin(MG_PRIM_SPRITE);
                    prim->Texture(num_tex);

                    if (item_no == ITEM_ID_MEDAL_HOLDER) {
                        prim->Color(0xA4, 0xA4, 0x40, rgba[3]);
                    } else if (static_cast<s8>(menu_limmit_displayflag[no]) == 1) {
                        prim->Color(0x52, 0x52, 0x94, rgba[3]);
                    } else {
                        prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
                    }

                    PrimDrawNumber(prim, num, MENU_NUMBER_ALIGN_RIGHT, num_x, num_y, num_rect, num_space, num_vertical_spacing);
                    prim->End();
                }
            } else {
                dc2::memory::CopyTrackedBytes(localrgba_3166, rgba, sizeof(localrgba_3166));
                rgba[0] = fptoui(160.0f + 32.0f * sinf(item_board_counter));
                rgba[1] = 0x40;
                rgba[2] = 0x40;

                if (OmakeFlag == 1) {
                    rgba[0] = 0x80;
                    rgba[1] = 0x80;
                    rgba[2] = 0x80;
                }

                DrawOneItem(prim, item_rect, item_no, icon_mode, effect, rgba, item_flag);

                if (num >= 2 || item_no == ITEM_ID_MEDAL_HOLDER) {
                    prim->Begin(MG_PRIM_SPRITE);
                    prim->Texture(num_tex);
                    prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
                    PrimDrawNumber(prim, num, MENU_NUMBER_ALIGN_RIGHT, num_x, num_y, num_rect, num_space, num_vertical_spacing);
                    prim->End();
                }

                dc2::memory::CopyTrackedBytes(rgba, localrgba_3166, sizeof(localrgba_3166));
            }

            if (icon_mode != MENU_ICON_MODE_NORMAL) {
                if (icon_mode == MENU_ICON_MODE_SPECTRUM) {
                    DrawItemIconEffect2(prim, effect_tex, parts, item_rect);
                }

                textures->ReloadCLUT(MenuPosData->item_icon_tex[0][use_trans_rect], (sceVif1Packet *) nullptr);
            }

            if (parts != nullptr) {
                parts++;
            }
        }
    }

    item_board_counter += 0.06829549f;

    if (item_board_counter > PI) {
        item_board_counter -= TWO_PI;
    }

    ResetMenuScissor();
}

int CMenuPosDataForm::MenuFormStep() {
    int ended = false;
    int next[2];
    int calc = {};
    int i = {};

    if (step_stop != 0) {
        return false;
    }

    GetNextMovePos(next);
    counter += 1;

    if (counter > 100000) {
        counter = 0;
    }

    if (dtype == MENUFORM_DTYPE_POLY || dtype == MENUFORM_DTYPE_MAPPART) {
        if (counter > 15) {
            counter = 15;
        }
    }

    if (dtype == MENUFORM_DTYPE_BG_TILE) {
        MENUFORMPARTS_TYPE *part = parts;
        MENU_BASETEXINFO   *texture = MenuPosData->GetTexGetInfo(part->tex_info_no);

        if (counter % 2 != 0) {
            next[0] += part->etc_info[0];
            next[1] += part->etc_info[1];
        }

        if (part->etc_info[0] < 0) {
            if (next[0] <= -texture->rect.right) {
                next[0] = 0;
            }
        } else if (part->etc_info[0] > 0 && next[0] >= 0) {
            next[0] = -texture->rect.right;
        }

        if (part->etc_info[1] < 0) {
            if (next[1] <= -texture->rect.bottom) {
                next[1] = 0;
            }
        } else if (part->etc_info[1] > 0 && next[1] >= 0) {
            next[1] = -texture->rect.bottom;
        }
    } else if (dtype != MENUFORM_DTYPE_MSGFORM) {
        MenuPartsStep();
    }

    if (CheckMoveEnd(next[0], next[1]) != 0) {
        ended = true;
        action_state = MENUFORM_ACTION_STATE_END;
    }

    for (i = 0; i < 4; i++) {
        s8 step = rgba_add[i];

        if (step != 0) {
            calc = rgba[i];

            if (CalcMenuAdd(&calc, step, rgba_target[i]) != 0) {
                rgba_add[i] = 0;
            }

            rgba[i] = calc;
        }
    }

    x = next[0];
    y = next[1];
    return ended;
}

int CMenuPosDataForm::CheckMoveEnd(int target_x, int target_y) {
    int finished = false;

    if (x == target_x) {
        finished = true;

        if (y != target_y) {
            finished = false;
        }
    }

    return finished;
}

int CMenuPosDataForm::CheckMoveEnd() {
    if (action != nullptr && action_state == MENUFORM_ACTION_STATE_END) {
        return true;
    }

    if (x == next_x && y == next_y) {
        return true;
    }

    return false;
}

void CMenuPosDataForm::SetAction(char *action) {
    int i = 0;

    while (i < action_num) {
        if (strcmp(action, this->action[i].name) == 0) {
            action_no = i;
            action_state = MENUFORM_ACTION_STATE_RUN;
            return;
        }

        i++;
    }

    action_no = -1;
}

void CMenuPosDataForm::SetNextMovePos(int *position, int move_type) {
    mtype = move_type;
    next_x = position[0];
    next_y = position[1];
}

int CMenuPosDataForm::GetNextMovePos(int *pos) {
    int                    i = {};
    int                    move_type = {};
    float                  rate_now = {};
    MENU_FORM_ACTION_MOVE *move = {};
    float                  diff = {};
    float                  rate[2];
    int                    target[2];

    if (pos == nullptr || active == 0) {
        return true;
    }

    int now[2] = {static_cast<int>(x), static_cast<int>(y)};

    if (0 <= action_no) {
        move = action[action_no].move;
        move_type = move->mtype;
        rate[0] = move->rate_x;
        rate[1] = move->rate_y;
        target[0] = static_cast<int>(move->x);
        target[1] = static_cast<int>(move->y);
    } else {
        move_type = mtype;
        rate[0] = rate_x;
        rate[1] = rate_y;
        target[0] = next_x;
        target[1] = next_y;
    }

    switch (move_type) {
        case MENUFORM_MTYPE_N:
            break;
        case MENUFORM_MTYPE_D:
            now[0] = target[0];
            now[1] = target[1];
            break;
        case MENUFORM_MTYPE_L:
            for (i = 0; i < 2; i++) {
                if (target[i] - now[i] < 0) {
                    rate[i] = -rate[i];
                }

                rate_now = rate[i];
                now[i] += rate_now;

                if (abs(target[i] - now[i]) <= abs(static_cast<int>(rate_now))) {
                    now[i] = target[i];
                }
            }

            break;
        case MENUFORM_MTYPE_I:
        case MENUFORM_MTYPE_IR:
            for (i = 0; i < 2; i++) {
                rate_now = rate[i];
                diff = static_cast<float>(target[i] - now[i]);
                float step = diff / rate_now;
                now[i] += step;

                if (static_cast<float>(abs(target[i] - now[i])) <= rate_now) {
                    if (mtype != MENUFORM_MTYPE_IR) {
                        if (diff > 0.0f) {
                            now[i]++;
                        }

                        if (diff < 0.0f) {
                            now[i]--;
                        }
                    }

                    if (static_cast<float>(abs(static_cast<int>(diff))) < 1.6f) {
                        now[i] = target[i];
                    }
                }
            }

            break;
    }

    pos[0] = now[0];
    pos[1] = now[1];
    return true;
}

void Menu3DivideTextureDraw(mgCDrawPrim *prim, mgRect<int> rect, short *tex_tbl, int vertical) {
    int middle = {};

    if (vertical == 0) {
        middle = rect.bottom - tex_tbl[3] - tex_tbl[11];
        rect.bottom = tex_tbl[3];
    } else {
        middle = rect.right - tex_tbl[2] - tex_tbl[10];
        rect.right = tex_tbl[2];
    }

    mgRect<int> source(0, 0, 0, 0);
    int         size[2][4] = {
        {tex_tbl[3], middle, tex_tbl[11]},
        {tex_tbl[2], middle, tex_tbl[10]}
    };
    int *step = size[vertical];

    for (int i = 0; i < 3; i++) {
        source.Set(tex_tbl[i << 2], tex_tbl[(i << 2) + 1], tex_tbl[(i << 2) + 2], tex_tbl[(i << 2) + 3]);
        PrimQuad(prim, rect, source);

        if (vertical == 0) {
            rect.top += step[i];
            rect.bottom = step[i + 1];
        } else if (vertical == 1) {
            rect.left += step[i];
            rect.right = step[i + 1];
        }
    }
}

void CMenuPosDataForm::MenuFormDrawNormal(int x, int y, float sway_x, float sway_y, int &tex_block) {
    mgCTextureManager *textures = &mgTexManager;
    mgCDrawPrim       *prim = GetMenuPrim();
    prim->Initialize(nullptr, nullptr);
    mgRect<float>              put(0.0f, 0.0f, 0.0f, 0.0f);
    mgRect<int>                uv(0, 0, 0, 0);
    mgCTexture                *effect_tex = MenuPosData->icon_effect_tex;
    float                     *top_right{};
    float                     *bottom_left{};
    float                     *bottom_right{};
    float                     *top_left{};
    int                        block = -1;
    MENU_PARTS_EFFECT_STRUCT1 *item_effect = nullptr;
    float                      horizontal_offset = {};

    for (int i = 0; i < parts_num; i++) {
        MENUFORMPARTS_TYPE *part = {};
        MENU_BASETEXINFO   *info = {};
        mgCTexture         *tex = {};
        part = &parts[i];

        if (part->active == 0 || part->draw_flag == 0 || part->dtype == MENUFORMPARTS_DTYPE_FUNCINFO) {
            continue;
        }

        put.Set(sway_x + part->x, sway_y + part->y, part->w, part->h);

        if (part->vibe_cnt[0] != 0) {
            put.left += static_cast<u_int>(part->viber[0]) * cosf(PI / part->vibe_cnt[0] * counter);
            put.left = static_cast<int>(put.left);
        }

        if (part->vibe_cnt[1] != 0) {
            put.top += static_cast<u_int>(part->viber[1]) * sinf(PI / part->vibe_cnt[1] * counter);
            put.top = static_cast<int>(put.top);
        }

        if (part->dtype == MENUFORMPARTS_DTYPE_CURSOR) {
            menu_cursor_pos cursor = at_3428;
            cursor.pos[0] = put.left;
            cursor.pos[1] = put.top;
            mgCTexture *cursor_tex = textures->GetTexture("mnmain", -1);

            if (cursor_tex == nullptr) {
                return;
            }

            MenuReloadTexture(tex_block, cursor_tex->block);
            MenuCursorDraw(cursor_tex, cursor.pos, menu_cursor_rotation_angle, static_cast<u8>(MenuCursorReverseFlag), rgba[3], 1.0f);
            continue;
        }

        if (part->dtype == MENUFORMPARTS_DTYPE_CLUT_RELOAD) {
            MenuReloadCLUT(part->etc_info[0]);
            continue;
        }

        tex = part->tex;
        info = MenuPosData->GetTexGetInfo(part->tex_info_no);
        u8 dtype = part->dtype;

        if (dtype != MENUFORMPARTS_DTYPE_SQ_BETA && dtype != MENUFORMPARTS_DTYPE_FONT && tex == nullptr) {
            continue;
        }

        if (tex != nullptr) {
            block = tex->block;
        }

        if (dtype != MENUFORMPARTS_DTYPE_NETA && dtype != MENUFORMPARTS_DTYPE_SQ_BETA && dtype != MENUFORMPARTS_DTYPE_TRS &&
            dtype != MENUFORMPARTS_DTYPE_IDEA_BOARD && dtype != MENUFORMPARTS_DTYPE_FONT) {
            MenuReloadTexture(tex_block, block);
        }

        if (part->dtype < MENUFORMPARTS_DTYPE_BG || part->dtype >= MENUFORMPARTS_DTYPE_NETA) {
            SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        }

        prim->AlphaBlend(part->alpha_blend);

        if (part->bilinear & 1) {
            prim->Bilinear(1);
        } else {
            prim->Bilinear(0);
        }

        u8 color[4];

        for (int channel = 0; channel < 4; channel++) {
            color[channel] = part->rgba[channel];

            if (rgba_bit & (1 << channel)) {
                color[channel] = rgba[channel];
            }
        }

        ConvMGFRECTtoFLOATtbl(put, putpostbl_3410);
        GetNowPosRGBA(part, info, putpostbl_3410, color);

        if (rgba[3] == 0) {
            color[3] = 0;
        }

        uv = info->rect;
        ConvMGIRECTtoINTtbl(uv, getpostbl_3411);
        s8 repeat = part->effect != nullptr ? 1 : 0;

        switch (part->dtype) {
            case MENUFORMPARTS_DTYPE_NORMAL: {
                prim->Begin(menu_prim_tbl[repeat][0]);
                prim->Texture(tex);

                if (part->shadow != 0) {
                    prim->Color(0, 0, 0, color[3] / 3);

                    if (repeat == 0) {
                        s8 offset = part->shadow_offset;
                        horizontal_offset = offset;
                        mgRect<int> shadow(static_cast<int>(put.left + horizontal_offset), static_cast<int>(put.top + offset), static_cast<int>(put.right), static_cast<int>(put.bottom));
                        PrimQuad(prim, shadow, uv);
                    }
                }

                prim->Color(color[0], color[1], color[2], color[3]);

                if (repeat == 0) {
                    PrimQuad(prim, put, uv);
                } else if (repeat == 1) {
                    PushPrimRepeat(prim, putpostbl_3410, getpostbl_3411, menu_prim_tbl[repeat][1]);
                }

                prim->End();
                break;
            }
            case MENUFORMPARTS_DTYPE_NORMAL2:
                prim->Begin(MG_PRIM_TRIANGLE_STRIP);
                prim->Texture(tex);
                prim->Color(color[0], color[1], color[2], color[3]);
                prim->TextureCrd(uv.left, uv.top);
                prim->Vertex(put.left, put.top, 0.0f);
                prim->TextureCrd(uv.left + uv.right, uv.top);
                prim->Vertex(put.left + put.right, put.top, 0.0f);
                put.left += part->etc_info[0];
                prim->TextureCrd(uv.left, uv.top + uv.bottom);
                prim->Vertex(put.left, put.top + put.bottom, 0.0f);
                prim->TextureCrd(uv.left + uv.right, uv.top + uv.bottom);
                prim->Vertex(put.left + put.right, put.top + put.bottom, 0.0f);
                prim->End();
                break;
            case MENUFORMPARTS_DTYPE_NUMBER1:
            case MENUFORMPARTS_DTYPE_NUMBER2:
                if (part->etc_info[2] == 1) {
                    if (part->etc_info[1] <= 1) {
                        break;
                    }
                } else if (part->etc_info[1] < 0) {
                    break;
                }

                uv = info->rect;
                prim->Bilinear(0);
                prim->Begin(MG_PRIM_SPRITE);
                prim->Texture(tex);

                if (part->shadow != 0) {
                    s8 offset = part->shadow_offset;
                    horizontal_offset = offset;
                    int shadow_x = static_cast<int>(put.left + horizontal_offset);
                    int shadow_y = static_cast<int>(put.top + offset);
                    prim->Color(0, 0, 0, color[3] / 3);

                    if (part->dtype == MENUFORMPARTS_DTYPE_NUMBER1) {
                        PrimDrawNumber(prim, part->etc_info[1], part->etc_info[0], shadow_x, shadow_y, uv, static_cast<int>(part->w),
                                       static_cast<int>(part->h));
                    } else if (part->dtype == MENUFORMPARTS_DTYPE_NUMBER2) {
                        PrimDrawNumber2(prim, part->etc_info[1], part->etc_info[0], shadow_x, shadow_y, uv, static_cast<int>(part->w),
                                        static_cast<int>(part->h));
                    }
                }

                prim->Color(color[0], color[1], color[2], color[3]);

                if (part->dtype == MENUFORMPARTS_DTYPE_NUMBER1) {
                    PrimDrawNumber(prim, part->etc_info[1], part->etc_info[0], static_cast<int>(put.left), static_cast<int>(put.top), uv,
                                   static_cast<int>(part->w), static_cast<int>(part->h));
                } else if (part->dtype == MENUFORMPARTS_DTYPE_NUMBER2) {
                    PrimDrawNumber2(prim, part->etc_info[1], part->etc_info[0], static_cast<int>(put.left), static_cast<int>(put.top), uv,
                                    static_cast<int>(part->w), static_cast<int>(part->h));
                }

                prim->End();
                break;
            case MENUFORMPARTS_DTYPE_WAKU_RECT:
                put.right = part->w;
                put.bottom = part->h;
                DrawMenuWakuRect(tex, put, uv, color[3], color[0], color[1], color[2]);
                break;
            case MENUFORMPARTS_DTYPE_WAKU_CIRCLE:
                put.right = part->w;
                put.bottom = part->h;
                DrawWakuCircle(prim, tex, put, uv, MenuWakuRotCnt, put.right, color[3], color[0], color[1], color[2]);
                break;
            case MENUFORMPARTS_DTYPE_BG:
            case MENUFORMPARTS_DTYPE_BETA:
                MenuFrameImageDraw(prim, tex, put, uv, color[0], color[3], part->dtype);
                break;
            case MENUFORMPARTS_DTYPE_TRS: {
                int item = part->etc_info[1];

                if (item > 0) {
                    MenuReloadTexture(tex_block, MenuItemIconTextureBlock);
                    int            icon_item = item;
                    MENU_ICON_MODE icon_mode = MENU_ICON_MODE_NORMAL;

                    if (item == ITEM_ID_SPECTOL) {
                        icon_item = part->etc_info[2];
                        icon_mode = MENU_ICON_MODE_SPECTRUM;
                        item_effect = part->effect;
                    }

                    if (item == ITEM_ID_BOILED_FISH) {
                        icon_item = part->etc_info[2];
                        icon_mode = MENU_ICON_MODE_BOILED_FISH;
                    }

                    DrawOneItem(prim, put, icon_item, icon_mode, item_effect, color, part->item_flag);

                    if (icon_mode != MENU_ICON_MODE_NORMAL) {
                        if (icon_mode == MENU_ICON_MODE_SPECTRUM) {
                            DrawItemIconEffect2(prim, effect_tex, part, put);
                        }

                        textures->ReloadCLUT(MenuPosData->item_icon_tex[0][use_trans_rect], (sceVif1Packet *) nullptr);
                    }
                }

                break;
            }
            case MENUFORMPARTS_DTYPE_NETA:
                PictureDraw(tex_block, put, part->etc_info[0], part->picture_scale, color);
                break;
            case MENUFORMPARTS_DTYPE_IDEA_BOARD:
                MenuInventPictureBoardDraw(&this->x, tex_block, color[3]);
                break;
            case MENUFORMPARTS_DTYPE_ALBUM:
                MenuInventAlbumPictureDraw(&this->x, tex_block);
                break;
            case MENUFORMPARTS_DTYPE_SQ_BETA: {
                SetSpriteEnv(prim, MENU_SPRITE_ENV_COLOR);
                float alpha_rate = 1.0f;

                if (rgba_bit & MENUFORM_RGBA_BIT_ALPHA) {
                    prim->DepthTestEnable(0);
                    alpha_rate = static_cast<u_int>(color[3]) / 128.0f;
                }

                switch (part->etc_info[0]) {
                    case MENUFORMPARTS_FILL_FLAT: {
                        top_left = top_right = bottom_left = bottom_right = part->effect->param;
                        prim->Begin(MG_PRIM_SPRITE);
                        prim->Color(static_cast<int>(part->effect->param[0]), static_cast<int>(part->effect->param[1]), static_cast<int>(part->effect->param[2]), static_cast<int>(part->effect->param[3] * alpha_rate));
                        prim->Vertex(put.left, put.top, 0.0f);
                        prim->Vertex(put.left + put.right, put.top + put.bottom, 0.0f);
                        break;
                    }
                    case MENUFORMPARTS_FILL_VERTICAL:
                        top_left = top_right = part->effect[0].param;
                        bottom_left = bottom_right = part->effect[1].param;
                        prim->Begin(MG_PRIM_TRIANGLE_STRIP);
                        PrimFillRect4(prim, put, top_left, top_right, bottom_left, bottom_right);
                        break;
                    case MENUFORMPARTS_FILL_HORIZONTAL:
                        top_left = bottom_left = part->effect[0].param;
                        top_right = bottom_right = part->effect[1].param;
                        prim->Begin(MG_PRIM_TRIANGLE_STRIP);
                        PrimFillRect4(prim, put, top_left, top_right, bottom_left, bottom_right);
                        break;
                    case MENUFORMPARTS_FILL_CORNERS:
                        top_left = part->effect[0].param;
                        bottom_left = part->effect[1].param;
                        top_right = part->effect[2].param;
                        bottom_right = part->effect[3].param;
                        prim->Begin(MG_PRIM_TRIANGLE_STRIP);
                        PrimFillRect4(prim, put, top_left, top_right, bottom_left, bottom_right);
                        break;
                }

                prim->End();

                if (rgba_bit & MENUFORM_RGBA_BIT_ALPHA) {
                    top_left[3] = static_cast<int>(color[3]);
                    bottom_left[3] = static_cast<int>(color[3]);
                    top_right[3] = static_cast<int>(color[3]);
                    bottom_right[3] = static_cast<int>(color[3]);
                }

                break;
            }
            case MENUFORMPARTS_DTYPE_RANDOM_LINE: {
                const auto bounded_integer = [](double value) -> std::optional<int> {
                    if (!std::isfinite(value) || value < std::numeric_limits<int>::min() || value > std::numeric_limits<int>::max()) {
                        return std::nullopt;
                    }
                    return static_cast<int>(value);
                };
                const auto x = bounded_integer(put.left);
                const auto y = bounded_integer(put.top);
                const auto width = bounded_integer(part->w);
                const auto height = bounded_integer(part->h);
                auto       points = dc2::menu::RandomLinePoints();
                if (!x || !y || !width || !height || points.size() < 50) {
                    break;
                }
                const int origin[2] = {*x, *y};
                if (counter % 2 == 0 && !GenarateRandamLine(origin, *width, *height, points, 50)) {
                    break;
                }
                DrawRandamLine(prim, points, 10, 50, color);
                break;
            }
            case MENUFORMPARTS_DTYPE_IDEA_MEMO: {
                menu_memo_pos memo = at_3531;
                memo.pos[0] = sway_x;
                memo.pos[1] = sway_y;
                MenuInventNetaMemoDraw(memo.pos, tex_block);
                break;
            }
        }
    }
}

void CMenuPosDataForm::MenuFormDraw(int x, int y, int &tex_block) {
    if (active == 0 || draw_flag == 0) {
        return;
    }

    float draw_x = x;
    float draw_y = y;

    if (vibe_cnt[0] != 0) {
        draw_x += 10.0f * cosf(PI / vibe_cnt[0] * counter);
    }

    if (vibe_cnt[1] != 0) {
        draw_y += 8.0f * sinf(PI / vibe_cnt[1] * counter);
    }

    mgCTextureManager *textures = &mgTexManager;
    mgCDrawPrim       *prim = GetMenuPrim();
    u8                 type = dtype;

    if (type == MENUFORM_DTYPE_NORMAL || type == MENUFORM_DTYPE_LIST) {
        MenuFormDrawNormal(x, y, draw_x, draw_y, tex_block);
    } else if (type == MENUFORM_DTYPE_MSGFORM) {
        CDC2Mes *mes = MenuDCMsg[sub_no];
        int      texture_block = mes->texture_block;

        if (rgba[3] > 0) {
            MenuReloadTexture(tex_block, texture_block);

            mes->StepMsg();
            menu_put_pos put = {
                {0, 0}
            };
            put.pos[0] = static_cast<int>(draw_x);
            put.pos[1] = static_cast<int>(draw_y);
            mes->SetPutPos(put.pos);
            mes->SetMsgAlpha(rgba[3]);
            mes->DrawMsg();
        }
    } else if (type == MENUFORM_DTYPE_MAINFRM) {
        MenuMainFrameDraw(tex_block, 0x80);
    } else if (type == MENUFORM_DTYPE_MAINIMG) {
        MenuMainFrameImgDraw(tex_block);
    } else if (type == MENUFORM_DTYPE_ITEMBRD) {
        float       board_y = 20.0f + draw_y;
        float       board_x = 16.0f + draw_x;
        int         clip_left = static_cast<int>(board_x);
        int         clip_top = static_cast<int>(board_y - 2.0f);
        int         clip_right = static_cast<int>(board_x + 240.0f + 5.0f);
        mgRect<int> clip(clip_left, clip_top, clip_right, static_cast<int>(board_y + 250.0f + 2.0f));

        if (mgScreenWidth > draw_x && clip.bottom > 0) {
            MENU_BASETEXINFO *num_info = MenuPosData->GetTexGetInfo("num0");
            mgCTexture       *num_tex = textures->GetTexture("mnmain", -1);
            mgRect<int>       num_rect = num_info->rect;
            MenuItemBrdUnderBrdPosXY[0] = board_x;
            MenuItemBrdDraw(MenuItemBrdUnderBrdPosXY, clip, tex_block, 0x80, 0x80, 0x80, 0x80);
            MenuItemModeItemDraw(tex_block, clip, MenuItemBrdUnderBrdPosXY, parts, num_tex, num_rect, 0);
            MenuItemBrdFrameDraw(static_cast<int>(draw_x), static_cast<int>(draw_y), tex_block, rgba[3], rgba[0], rgba[1], rgba[2]);
        }
    } else if (type == MENUFORM_DTYPE_GIFTVIEW) {
        mgCTexture *board_tex = textures->GetTexture("makebrd", -1);
        mgCTexture *cursor_tex = textures->GetTexture("mnmain", -1);

        if (board_tex != nullptr) {
            MenuPresentBoxView(static_cast<int>(draw_x), static_cast<int>(draw_y), tex_block, board_tex, cursor_tex);
        }
    } else if (type == MENUFORM_DTYPE_POLY) {
        if (counter >= 15 && chara != nullptr) {
            float saved_ambient[4];
            mgGetAmbient(saved_ambient);

            if (0.0f <= ambient[0]) {
                mgSetAmbient(ambient);
            }

            if (chara_tex_block > 0) {
                MenuReloadTexture(tex_block, chara_tex_block);
                chara->DrawDirect();

                if (GetNowLoopNo() == LOOP_DUNGEON && FxScriptMan != nullptr) {
                    FxScriptMan->PauseFromLevel(3, 2);
                    FxScriptMan->PauseFromLevel(1, 2);
                    chara->DrawEffect();
                    FxScriptMan->PauseFromLevel(3, 0);
                    FxScriptMan->PauseFromLevel(1, 0);
                }
            } else if (chara->GetFrame() != nullptr) {
                mgDrawDirect(chara->GetFrame());
            }

            mgSetAmbient(saved_ambient);
        }
    } else if (type == MENUFORM_DTYPE_CREATEBRD) {
        menu_board_pos pos = {
            {0.0f, 0.0f}
        };
        pos.pos[0] = x;
        pos.pos[1] = y;
        CommonBoardDraw(pos.pos, tex_block);
    } else if (type == MENUFORM_DTYPE_MAPPART) {
        MenuMapPartsDraw(tex_block);
    } else if (type == MENUFORM_DTYPE_BG_TILE) {
        MENU_BASETEXINFO *info = MenuPosData->GetTexGetInfo(parts->tex_info_no);
        mgCTexture       *tex = textures->GetTexture(info->tex_name, info->tex_block);
        MenuReloadTexture(tex_block, info->tex_block);
        menu_tile_color color = {
            {128, 128, 128, 0}
        };
        color.rgba[3] = rgba[3];
        DrawMenuTilePattern(prim, tex, this->x, this->y, info->rect, 0, color.rgba);
    } else if (type == MENUFORM_DTYPE_CHRSTAR) {
        MenuCharaChangeStarDraw();
    } else if (type == MENUFORM_DTYPE_INV_CARD) {
        MenuInventCreateCardDraw(tex_block, &this->x);
    } else if (type == MENUFORM_DTYPE_GEOLIST) {
        MenuGeoramaListDraw(tex_block, &this->x, sub_no, rgba[3]);
    } else if (type == MENUFORM_DTYPE_GEOTITLE) {
        MenuGeoramaTitleDraw(tex_block, &this->x, rgba[3]);
    } else if (type == MENUFORM_DTYPE_GEOANA) {
        MenuGeoramaAnalyzeDraw(tex_block, &this->x, rgba[3]);
    } else if (type == MENUFORM_DTYPE_HOUSE) {
        MenuPlacedHouseDraw(tex_block);
    } else if (type == MENUFORM_DTYPE_SHOPLIST) {
        ShopSellListDraw(tex_block, &this->x);
    } else if (type == MENUFORM_DTYPE_SAVELIST) {
        SaveFileListDraw(tex_block, &this->x, rgba[3]);
    } else if (type == MENUFORM_DTYPE_INFOCUR) {
        MenuItemInfoCursorDraw(tex_block);
        MenuCharaStatusDraw(tex_block);
    } else if (type == MENUFORM_DTYPE_DLOAD) {
        int dl_x = static_cast<int>(this->x);
        DrawMenuDl(tex_block, dl_x, static_cast<int>(this->y), dl_x, rgba[3]);
    } else if (type == MENUFORM_DTYPE_CLIP) {
        float top = {};
        float left = this->x;
        top = this->y;
        int         clip_left = static_cast<int>(left);
        int         clip_top = static_cast<int>(top);
        int         clip_right = static_cast<int>(left + clip_w);
        mgRect<int> clip(clip_left, clip_top, clip_right, static_cast<int>(top + clip_h));
        MenuClipRectCheck(clip);
        SetMenuScissor(clip);
    } else if (type == MENUFORM_DTYPE_BUILDUP) {
        MenuWeaponBuildUpDraw(tex_block);
    }
}

void CPosDataManage::Initialize() {
    etc_tbl = nullptr;
    etc_tbl_num = 0;
    tex_info = nullptr;
    tex_info_num = 0;
    form = nullptr;
    form_num = 0;
    step_stop = false;
}

MENU_BASETEXINFO *CPosDataManage::GetTexGetInfo(int no) {
    if (no < 0 || tex_info_num <= no) {
        return nullptr;
    }

    return &tex_info[no];
}

MENU_BASETEXINFO *CPosDataManage::GetTexGetInfo(char *name) {
    int i = {};

    if (name == nullptr) {
        return nullptr;
    }

    for (i = 0; i < tex_info_num; i++) {
        if (tex_info[i].name != nullptr && strcmp(name, tex_info[i].name) == 0) {
            return &tex_info[i];
        }
    }

    return nullptr;
}

int CPosDataManage::GetTexGetInfoTblNo(char *name) {
    int i = {};

    if (name != nullptr) {
        for (i = 0; i < tex_info_num; i++) {
            if (tex_info[i].name != nullptr && strcmp(tex_info[i].name, name) == 0) {
                return i;
            }
        }
    }

    return -1;
}

void CPosDataManage::TexGetInfoClear(int from, int to) {
    int i = {};

    if (tex_info_num < to) {
        to = tex_info_num;
    }

    for (i = from; i < to; i++) {
        MENU_BASETEXINFO_Init(&tex_info[i]);
    }
}

void CPosDataManage::ResetTextureBlockNo(char *name, int block) {
    MENU_BASETEXINFO *info = {};
    int               i = {};

    info = GetTexGetInfo(0);

    for (i = 0; i < tex_info_num; i++, info++) {
        if (info->tex_name != nullptr && strcmp(info->tex_name, name) == 0) {
            info->tex_block = block;
        }
    }
}

void CPosDataManage::ResetTextureInfoAll() {
    mgCTextureManager  *tex_manager = &mgTexManager;
    CMenuPosDataForm   *form = {};
    MENUFORMPARTS_TYPE *part = {};
    MENU_BASETEXINFO   *info = {};
    int                 i = {};

    form = GetDrawTopList();

    if (form != nullptr) {
        do {
            part = form->parts;

            for (i = 0; i < form->parts_num && part != nullptr; i++, part++) {
                info = GetTexGetInfo(part->tex_info_no);

                if (info != nullptr) {
                    part->tex = tex_manager->GetTexture(info->tex_name, info->tex_block);
                }
            }

            form = form->next;
        } while (form != nullptr);
    }
}

void CPosDataManage::EtcTblClear(int from, int to) {
    MENU_ETCINFO *p = {};
    int           end = {};
    int           i = {};

    end = to;

    if (etc_tbl_num < end) {
        end = etc_tbl_num;
    }

    p = &etc_tbl[from];

    for (i = 0; i < end - from; i++, p++) {
        p->name = nullptr;
    }
}

MENU_ETCINFO *CPosDataManage::GetEtcTbl(char *name) {
    MENU_ETCINFO *p = {};
    u16           n = {};
    int           i = {};

    if (name == nullptr) {
        return nullptr;
    }

    n = etc_tbl_num;
    p = etc_tbl;
    i = 0;

    if (0 < n) {
        do {
            if (p->name != nullptr && strcmp(p->name, name) == 0) {
                return p;
            }

            i++;
            p++;
        } while (i < n);
    }

    return nullptr;
}

void CPosDataManage::GetEtcTblValue(char *name, int &value1, int &value2) {
    const MENU_ETCINFO *entry = GetEtcTbl(name);
    value1 = entry != nullptr ? entry->value[0] : 0;
    value2 = entry != nullptr ? entry->value[1] : 0;
}

MENU_ETCINFO2 *CPosDataManage::GetEtcTbl2(char *name) {
    MENU_ETCINFO2 *p = {};
    u16            n = {};
    int            i = {};

    if (name == nullptr) {
        return nullptr;
    }

    n = etc_tbl2_num;
    p = etc_tbl2;
    i = 0;

    if (0 < n) {
        do {
            if (p->name != nullptr && strcmp(p->name, name) == 0) {
                return p;
            }

            i++;
            p++;
        } while (i < n);
    }

    return nullptr;
}

void CPosDataManage::GetEtcTbl2Value(char *name, float *out, int count) {
    MENU_ETCINFO2 *entry = GetEtcTbl2(name);
    int            i = {};

    if (entry == nullptr) {
        return;
    }

    for (i = 0; i < count; i++) {
        out[i] = entry->value[i];
    }
}

void CPosDataManage::EtcTbl2Clear(int from, int to) {
    MENU_ETCINFO2 *p = {};
    int            end = {};
    int            count = {};
    int            i = {};

    end = to;

    if (etc_tbl2_num < end) {
        end = etc_tbl2_num;
    }

    count = end - from;
    i = 0;
    p = &etc_tbl2[from];

    if (0 < count) {
        do {
            i++;
            p->name = nullptr;
            p++;
        } while (i < count);
    }
}

std::string dc2::menu::MainIconName(int icon_no) {
    return std::format("mi{}", static_cast<std::int64_t>(icon_no) - 2);
}

CMenuPosDataForm *CPosDataManage::GetFormInfo(const char *name) {
    CMenuPosDataForm *form = {};
    int               i = {};

    if (name == nullptr) {
        return nullptr;
    }

    form = GetDrawTopList();
    i = 0;

    while (form != nullptr && i < form_num) {
        if (form->name == nullptr) {
            break;
        }

        if (strcmp(form->name, name) == 0) {
            return form;
        }

        form = form->next;
        i++;
    }

    return nullptr;
}

CMenuPosDataForm *CPosDataManage::GetFormInfo(int no) {

    if (no < 0 || form_num <= no) {
        return nullptr;
    }

    return &form[no];
}

void CPosDataManage::FormInfoClear(int from, int to) {
    int i = {};

    if (from < 0) {
        from = 0;
    }

    if (!(to < form_num)) {
        to = form_num;
    }

    for (i = from; i < to; i++) {
        form[i].Initialize();
    }
}

void CPosDataManage::SetFormPos(char *name, int *pos) {
    CMenuPosDataForm *form = GetFormInfo(name);

    if (form != nullptr) {
        form->x = pos[0];
        form->y = pos[1];
    }
}

void CPosDataManage::InitDrawList() {
    CMenuPosDataForm *form = this->form;
    CMenuPosDataForm *prev = nullptr;
    CMenuPosDataForm *next = {};
    int               i = 0;
    int               j = {};

    while (i < form_num) {
        form->prev = prev;
        next = nullptr;

        for (j = 1; j < form_num - i; j++) {
            if (form[j].name != nullptr) {
                i += j;
                next = &form[j];
                break;
            }
        }

        form->next = next;
        prev = form;
        form = next;

        if (form == nullptr) {
            break;
        }
    }
}

CMenuPosDataForm *CPosDataManage::GetDrawTopList() {
    CMenuPosDataForm *next = {};
    CMenuPosDataForm *form = {};

    form = GetFormInfo(0);

    while (form != nullptr) {
        next = form->prev;

        if (next == nullptr) {
            return form;
        }

        form = next;
    }

    return nullptr;
}

void CPosDataManage::FormReLink(char *form, char *target) {
    CMenuPosDataForm *first = GetFormInfo(form);
    CMenuPosDataForm *second = GetFormInfo(target);
    CMenuPosDataForm *first_prev = {};
    CMenuPosDataForm *first_next = {};

    if (first == nullptr || second == nullptr) {
        return;
    }

    first_prev = first->prev;
    first_next = first->next;
    first->prev = second->prev;
    first->next = second->next;
    second->prev = first_prev;
    second->next = first_next;

    if (second->prev != nullptr) {
        second->prev->next = second;
    }

    if (second->next != nullptr) {
        second->next->prev = second;
    }

    if (first->next != nullptr) {
        first->next->prev = first;
    }

    if (first->prev != nullptr) {
        first->prev->next = first;
    }
}

void CPosDataManage::FormReLink2(char *form, char *target, char *third, char *fourth) {
    CMenuPosDataForm *first_form = GetFormInfo(form);
    CMenuPosDataForm *third_form = GetFormInfo(third);
    CMenuPosDataForm *target_form = GetFormInfo(target);
    CMenuPosDataForm *fourth_form = GetFormInfo(fourth);
    CMenuPosDataForm *target_next = {};
    CMenuPosDataForm *fourth_next = {};
    CMenuPosDataForm *third_prev = {};
    CMenuPosDataForm *first_prev = {};

    if (first_form == nullptr || third_form == nullptr) {
        return;
    }

    first_prev = first_form->prev;
    target_next = nullptr;
    third_prev = third_form->prev;
    fourth_next = nullptr;

    if (target_form != nullptr) {
        target_next = target_form->next;
    }

    if (fourth_form != nullptr) {
        fourth_next = fourth_form->next;
    }

    if (target_form == third_prev) {
        third_form->prev = first_prev;
        first_prev->next = third_form;
        first_form->prev = fourth_form;
        fourth_form->next = first_form;
        target_form->next = fourth_next;
        fourth_next->prev = target_form;
    } else if (fourth_form == first_prev) {
        first_form->prev = first_prev;
        third_prev->next = first_form;
        third_form->prev = target_form;
        target_form->next = third_form;
        fourth_form->next = target_next;
        target_next->prev = fourth_form;
    } else {
        third_form->prev = first_prev;

        if (first_prev != nullptr) {
            first_prev->next = third_form;
        }

        if (target_next != nullptr) {
            fourth_form->next = target_next;
            target_next->prev = fourth_form;
        }

        first_form->prev = third_prev;

        if (third_prev != nullptr) {
            third_prev->next = first_form;
        }

        if (fourth_next != nullptr) {
            target_form->next = fourth_next;
            fourth_next->prev = target_form;
        }
    }
}

void CPosDataManage::FormStep() {
    CMenuPosDataForm *form = GetDrawTopList();
    int               was_stopped = {};

    if (form != nullptr) {
        do {
            was_stopped = form->step_stop;

            if (step_stop != 0) {
                form->step_stop = true;
            }

            form->MenuFormStep();

            if (was_stopped == 0) {
                form->step_stop = false;
            }

            form = form->next;

            if (form == nullptr) {
                break;
            }
        } while (form != nullptr);
    }
}

void MenuDrawParamStep() {
    DrawMenuWakuStep();
    EnableUseItemAlphaStep();
    DrawItemCounter += 0.25f;

    if (!(DrawItemCounter < 10.0f)) {
        DrawItemCounter = 0.0f;
    }

    DrawItemDefCounter += 1;

    if (DrawItemDefCounter >= 0x50) {
        DrawItemDefCounter = 0;
    }
}

void CPosDataManage::FormDraw() {
    int               state = -1;
    CMenuPosDataForm *form = GetDrawTopList();

    if (form != nullptr) {
        do {
            form->MenuFormDraw(state);
            form = form->next;

            if (form == nullptr) {
                break;
            }
        } while (form != nullptr);
    }
}

void CPosDataManage::ClearPos() {
    EtcTblClear(0, etc_tbl_num);
    TexGetInfoClear(0, tex_info_num);
    FormInfoClear(0, form_num);
}

void CMenuPosDataManage::AttachCommonTexInfo() {
    common_tex = mgTexManager.GetTexture("menuwork2", -1);
    unused_tex[0] = nullptr;
    icon_effect_tex = mgTexManager.GetTexture("menueff0", -1);
    effect_tex = mgTexManager.GetTexture("spectre", -1);
    item_icon_tex[0][0] = mgTexManager.GetTexture("wepicon", -1);
    item_icon_tex[0][1] = mgTexManager.GetTexture("itemicon", -1);
}

int CheckItemUseVariable(CGameDataUsed *item, CItemUseTarget *target) {
    int state = {};
    int result = {};

    if ((item == nullptr) || (target == nullptr)) {
        return 0;
    }

    state = CheckNowStateUseThisItem(item, target);
    result = state;

    if (target->type == ITEM_USE_TARGET_ITEM && CheckBuildUp(static_cast<CGameDataUsed *>(target->target.data), nullptr, nullptr, nullptr) != 0) {
        result = state | MENU_ITEM_ICON_BUILD_UP;
    }

    return result;
}

void Func_MenuItemBrdPrepare(MENUFORMPARTS_TYPE *parts, CGameDataUsed *items, CGameDataUsed *used,
                             int target_kind) {
    CGameDataUsed *item = {};
    int            count = {};
    int            i = {};

    if (parts != nullptr) {
        CItemUseTarget target;
        count = GetNowBagMax(ITEM_BOARD_ALL);
        i = 0;

        if (0 < count) {
            do {

                item = &items[i];
                target.SetPtr(target_kind, item);
                parts->item_flag = CheckItemUseVariable(used, &target);
                i++;
                parts++;
            } while (i < count);
        }
    }
}

void Func_MenuItemBrdPrepare2(MENUFORMPARTS_TYPE *parts, CGameDataUsed *items,
                              CGameDataUsed *used) {
    int count = {};
    int i = {};
    int item_no = {};

    if (parts == nullptr) {
        return;
    }

    if (used == nullptr) {
        return;
    }

    count = GetNowBagMax(ITEM_BOARD_ALL);
    item_no = used->item_no;
    i = 0;

    if (0 < count) {

        do {
            if (item_no == ITEM_ID_RIDEPOD_FUEL) {
                parts->item_flag = 0;
            } else {
                CItemUseTarget target;
                target.SetPtr(ITEM_USE_TARGET_ITEM, &items[i]);
                parts->item_flag = CheckItemUseVariable(used, &target);
            }

            i++;
            parts++;
        } while (i < count);
    }
}

int NowUseNeedItemCheck(CUserDataManager *manager) {
    int            needs = {};
    int            items_disabled = {};
    int            limit = {};
    int            party = {};
    int            active_chara = {};
    CHARA_DATA    *charas[2];
    ROBO_DATA     *robo = {};
    CHARA_DATA    *chara = {};
    CGameDataUsed *weapon = {};

    if (manager == nullptr) {
        return 0;
    }

    needs = 0;
    items_disabled = false;

    if ((GetMainScene()->battle_area.floor_status & DNG_FLOOR_DISABLE_ITEMS) != 0) {
        items_disabled = true;
    }

    active_chara = manager->active_chr_no;
    party = manager->GetNowPartyMember();
    charas[0] = manager->GetCharaDataPtr(USER_CHARA_MAX);
    charas[1] = manager->GetCharaDataPtr(USER_CHARA_MONICA);

    if ((party & (1 << USER_CHARA_ROBO)) != 0) {
        robo = &manager->robo_data;

        if (robo != nullptr) {
            if (robo->AddPoint(0.0f) < 0.2f) {
                needs |= MENU_ITEM_NEED_REFUEL_RIDEPOD;
            }
        }

        limit = GetShiledKitLimmit(manager->CheckRobotCore());

        if (robo->shield_kit_num < limit) {
            needs |= MENU_ITEM_NEED_RIDEPOD_SHIELD_KIT;
        }
    }

    if (active_chara == USER_CHARA_MAX || active_chara == USER_CHARA_MONICA) {
        chara = charas[active_chara];

        if (active_chara == USER_CHARA_MAX || (active_chara == USER_CHARA_MONICA && (party & (1 << USER_CHARA_MONICA)) != 0)) {
            if (chara->hp.GetRate() < 0.2f) {
                needs |= MENU_ITEM_NEED_RESTORE_HP;
            }

            if ((chara->status_attr & CHARA_STATUS_POISON) != 0) {
                needs |= MENU_ITEM_NEED_CURE_POISON;
            }

            if ((chara->status_attr & CHARA_STATUS_SLOW) != 0) {
                needs |= MENU_ITEM_NEED_CURE_SLOW;
            }

            if ((chara->status_attr & CHARA_STATUS_CURSE) != 0) {
                needs |= MENU_ITEM_NEED_CURE_CURSE;
            }

            if ((chara->status_attr & CHARA_STATUS_STOP) != 0) {
                needs |= MENU_ITEM_NEED_CURE_STOP;
            }

            if ((chara->status_attr & CHARA_STATUS_POWER) != 0) {
                needs |= MENU_ITEM_NEED_POWER;
            }

            if ((chara->status_attr & CHARA_STATUS_STONE) != 0) {
                needs |= MENU_ITEM_NEED_CURE_STONE;
            }

            if ((chara->status_attr & CHARA_STATUS_DRY) != 0) {
                needs |= MENU_ITEM_NEED_CURE_DRY;
            }
        }

        weapon = &chara->equip[0];

        if (weapon->GetWHp(nullptr) < 0.2f) {
            needs |= MENU_ITEM_NEED_REPAIR_MELEE;
        }

        if (chara->equip[1].GetWHp(nullptr) < 0.2f) {
            if (active_chara == USER_CHARA_MAX) {
                needs |= MENU_ITEM_NEED_REPAIR_GUN;
            }

            if (active_chara == USER_CHARA_MONICA) {
                needs |= MENU_ITEM_NEED_REPAIR_MAGIC;
            }
        }
    } else if (active_chara == USER_CHARA_ROBO) {

        if ((&manager->robo_data)->parts[0].GetWHp(nullptr) < 0.2f) {
            needs |= MENU_ITEM_NEED_REPAIR_RIDEPOD;
        }
    } else if (active_chara == USER_CHARA_MONSTER) {
        if (charas[1]->hp.GetRate() < 0.2f) {
            needs |= MENU_ITEM_NEED_RESTORE_HP;
        }
    }

    needs |= MENU_ITEM_NEED_UNUSED_10 | MENU_ITEM_NEED_MONICA_IN_PARTY;

    if ((party & (1 << USER_CHARA_MONICA)) == 0) {
        needs &= ~MENU_ITEM_NEED_MONICA_IN_PARTY;
    }

    if (items_disabled != 0) {
        needs &= ~MENU_ITEM_NEED_RECOVERY;
    }

    return needs | MENU_ITEM_NEED_UNUSED_40;
}

void Func_MenuIconDrawPrepare(MENUFORMPARTS_TYPE *part, CGameDataUsed *item, int need_item) {
    int          item_no = {};
    CDataCommon *record = {};
    CDataItem   *item_info = {};
    unsigned int flags = {};

    if (part != nullptr && item != nullptr) {
        part->item_flag = 0;
        item_no = item->item_no;

        if (item_no >= 0x10C) {
            record = GetCommonItemData(item_no);

            if (record != nullptr && (record->attribute & ITEM_ATTRIBUTE_USABLE) != 0) {
                item_info = GetItemInfoData(item_no);

                if (item_info != nullptr) {
                    flags = item_info->use_flags;

                    if ((flags & ITEM_USE_FLAG_RESTORE_HP) != 0 && (need_item & MENU_ITEM_NEED_RESTORE_HP) != 0) {
                        part->item_flag |= MENU_ITEM_ICON_HIGHLIGHT;
                    } else if (((flags & ITEM_USE_FLAG_CURE_POISON) != 0 && (need_item & MENU_ITEM_NEED_CURE_POISON) != 0) ||
                               ((flags & ITEM_USE_FLAG_CURE_CURSE) != 0 && (need_item & MENU_ITEM_NEED_CURE_CURSE) != 0) ||
                               ((flags & ITEM_USE_FLAG_CURE_STOP) != 0 && (need_item & MENU_ITEM_NEED_CURE_STOP) != 0) ||
                               ((flags & ITEM_USE_FLAG_CURE_SLOW) != 0 && (need_item & MENU_ITEM_NEED_CURE_SLOW) != 0) ||
                               ((flags & ITEM_USE_FLAG_CURE_STONE) != 0 && (need_item & MENU_ITEM_NEED_CURE_STONE) != 0) ||
                               ((flags & ITEM_USE_FLAG_CURE_DRY) != 0 && (need_item & MENU_ITEM_NEED_CURE_DRY) != 0)) {
                        part->item_flag |= MENU_ITEM_ICON_HIGHLIGHT;
                    } else if ((flags & ITEM_USE_FLAG_REPAIR) != 0 &&
                               ((item_no == ITEM_ID_MELEE_REPAIR &&
                                 ((need_item & MENU_ITEM_NEED_REPAIR_MELEE) != 0 || (need_item & MENU_ITEM_NEED_REPAIR_RIDEPOD) != 0)) ||
                                (item_no == ITEM_ID_GUN_REPAIR && (need_item & MENU_ITEM_NEED_REPAIR_GUN) != 0) ||
                                (item_no == ITEM_ID_MAGIC_REPAIR && (need_item & MENU_ITEM_NEED_REPAIR_MAGIC) != 0) ||
                                (item_no == ITEM_ID_RIDEPOD_FUEL && (need_item & MENU_ITEM_NEED_REFUEL_RIDEPOD) != 0))) {
                        part->item_flag |= MENU_ITEM_ICON_HIGHLIGHT;
                    } else if (item_no == ITEM_ID_SHIELD_KIT && (need_item & MENU_ITEM_NEED_RIDEPOD_SHIELD_KIT) != 0) {
                        part->item_flag |= MENU_ITEM_ICON_HIGHLIGHT;
                    } else if (item_no == ITEM_ID_FRUIT_OF_EDEN || item_no == ITEM_ID_POTATO_PIE) {
                        part->item_flag |= MENU_ITEM_ICON_HIGHLIGHT;
                    } else if (item_no == ITEM_ID_WITCH_PARFAIT && (need_item & MENU_ITEM_NEED_MONICA_IN_PARTY) != 0) {
                        part->item_flag |= MENU_ITEM_ICON_HIGHLIGHT;
                    }
                }
            }
        }
    }
}

void CheckItemBoardFunc_MenuIconDrawPrepare(CUserDataManager *manager, MENUFORMPARTS_TYPE *parts) {
    int            need_item = {};
    CGameDataUsed *item = {};
    int            count = {};
    int            i = {};

    need_item = NowUseNeedItemCheck(manager);
    item = manager->GetUsedDataPtr(0);
    count = GetNowBagMax(ITEM_BOARD_ALL);

    for (i = 0; i < count; i++) {
        Func_MenuIconDrawPrepare(&parts[i], item, need_item);

        if (CheckBuildUp(item, nullptr, nullptr, nullptr) != 0) {
            parts[i].item_flag |= MENU_ITEM_ICON_BUILD_UP;
        }

        item++;
    }
}

void MenuItemBrdScrlBarStep(int line, int height, int mode) {
    int pos =
        CalcScrlBarPutPos(height, 252.0f, line, static_cast<float>(MenuItemBrdMaxLine - MenuItemBrdViewLine));

    if (mode == MENU_ITEM_BRD_CALC_EASE) {
        CalcMenu1(static_cast<float>(pos), &MenuItemBrdScrlBarY, 4.0f, 4.0f, 0);
    }

    if (mode == MENU_ITEM_BRD_CALC_JUMP) {
        MenuItemBrdScrlBarY = static_cast<float>(pos);
    }
}

void Func_MenuItemBrdPosStep(int top_line) {
    int               pos[2] = {0, 24};
    CMenuPosDataForm *form = MenuPosData->GetFormInfo("itembrd");

    if (form != nullptr) {
        form->GetPutPosXY(nullptr, pos[0], pos[1]);
    }

    int x = pos[0];
    MenuItemBrdUnderBrdPosXY[0] = x + 16;
    MenuItemBrdUnderBrdPosY_Next = pos[1] + 26;
    MenuItemBrdUnderBrdPosY_Next -= 50.0f * top_line;

    if (MenuItemBrdCalcManner == MENU_ITEM_BRD_CALC_EASE) {
        CalcMenu1(MenuItemBrdUnderBrdPosY_Next, &MenuItemBrdUnderBrdPosXY[1], 4.0f, 2.0f, 0);
    }

    if (MenuItemBrdCalcManner == MENU_ITEM_BRD_CALC_JUMP) {
        MenuItemBrdUnderBrdPosXY[1] = MenuItemBrdUnderBrdPosY_Next;
    }

    MenuItemBrdScrlBarStep(top_line, pos[1] + 18, MenuItemBrdCalcManner);
}

void CMenuPosDataManage::GetPosMenuItemBrdKoma(int *position, int item_index, int clip) {
    CMenuPosDataForm *form = GetFormInfo("itembrd");

    if (form != nullptr) {
        form->GetNextMovePos(position);
        position[0] += (item_index % 6) * 40 + 16;
        int minimum_y = position[1] + 20;
        int maximum_y = position[1] + 270;
        position[1] = static_cast<int>(MenuItemBrdUnderBrdPosY_Next + static_cast<float>((item_index / 6) * 50));

        if (clip != 0) {
            if (position[1] < minimum_y) {
                position[1] = minimum_y;
            }

            if (maximum_y < position[1]) {
                position[1] = maximum_y;
            }
        }
    }
}

void CMenuPosDataManage::GetPosMenuItemOnItemBrd(int *pos, int item_no, int clip) {
    GetPosMenuItemBrdKoma(pos, item_no, clip);
    pos[0] += 4;
    pos[1] += 4;
}

void CMenuPosDataManage::GetPosMenuItemBrdForEffect(int *pos, int item_no, int clip) {
    GetPosMenuItemOnItemBrd(pos, item_no, clip);
    pos[0] += 0x12;
    pos[1] += 0x15;
}

void Func_MenuItemIconSetEffectOne(MENUFORMPARTS_TYPE *part) {
    int i = {};

    if (part == nullptr) {
        return;
    }

    if (part->effect == nullptr) {
        return;
    }

    short first[10] = {GetRandI(20), 160, 16, 20, 0, 120};
    SetPartEffectInfoRandFunc(part->effect, first, 8);
    part->effect[0].type = MENU_PARTS_EFFECT_ICON_COUNTER;
    part->effect[0].active = true;
    part->effect[0].repeat = true;
    short second[10] = {GetRandI(30), 160, 16, 20, 0, 120};
    SetPartEffectInfoRandFunc(&part->effect[1], second, 8);
    part->effect[1].type = MENU_PARTS_EFFECT_ICON_COUNTER;
    part->effect[1].active = true;
    part->effect[1].repeat = true;
    short sparkle[10] = {0};

    for (i = 2; i < 8; i++) {
        Func_SetPartEffectInfo(&part->effect[i], MENU_PARTS_EFFECT_SPARKLE, sparkle);
        part->effect[i].active = true;
        part->effect[i].repeat = true;
    }
}

void MenuItemBrdItemIconEffectMalloc(mgCMemory *memory, MENUFORMPARTS_TYPE *parts, int count) {
    if (memory == nullptr || parts == nullptr || count <= 0) {
        return;
    }
    auto *name = dc2::memory::CopyText(*memory, "icon");
    if (name == nullptr) {
        return;
    }
    int i = {};

    for (i = 0; i < count; i++) {
        MenuPosDataTypeInit(&parts[i]);
        parts[i].active = true;
        Func_MallocPartEffectInfo(&parts[i], memory, 8);
        Func_MenuItemIconSetEffectOne(&parts[i]);
    }

    parts->name = name;
    parts->w = 32.0f;
    parts->h = 40.0f;
}

void CMenuPosDataManage::InitializeCMenuPosDataManage() {
    Initialize();
    common_tex = nullptr;
    unused_tex[0] = nullptr;
    unused_tex[1] = nullptr;
    unused_tex[2] = nullptr;
    icon_effect_tex = nullptr;
    effect_tex = nullptr;
    item_icon_tex[0][0] = nullptr;
    item_icon_tex[0][1] = nullptr;
    item_icon_tex[1][0] = nullptr;
    item_icon_tex[1][1] = nullptr;
    pallet[2][0] = nullptr;
    pallet[2][1] = nullptr;
    item_icon_tex[3][0] = nullptr;
    item_icon_tex[3][1] = nullptr;
    memset(fish_jump_wait, 0, sizeof(fish_jump_wait));
    memset(fish_jump_height, 0, sizeof(fish_jump_height));
    memset(fish_jump_count, 2, sizeof(fish_jump_count));
}

int MenuCapture(int block, mgCMemory *stack, int draw);

void SetBGFrameForMenu(int tex_block, char *name) {
    mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *) nullptr);
    mgCTexture   frame;
    mgRect<int>  src;
    mgRect<int>  half;
    mgCDrawPrim *prim = {};
    mgCTexture  *background = {};

    mgGetFrameBuffer(&frame);
    src.Set(0, 0, mgScreenWidth << 4, mgScreenHeight << 4);
    half.Set(0, 0, mgScreenWidth << 3, mgScreenHeight << 3);
    prim = GetMenuPrim();
    prim->Initialize(nullptr, nullptr);
    prim->AlphaTestEnable(0);
    prim->ZMask(MG_Z_MASK_MASKED);
    prim->TextureMapEnable(1);
    background = mgTexManager.GetTexture(name, -1);
    background->Bilinear(1);
    mgSetPkMoveImage(&frame, src, background, 0, 0, 0);
}

/**
 *
 * Draws a menu frame image with color and edge-fade settings for its drawing type.
 *
 */
static void MenuFrameImageDraw(mgCDrawPrim *prim, mgCTexture *tex, mgRect<float> rect, mgRect<int> tex_rect, int gray,
                               int alpha, int dtype) {
    int prim_type = {};
    int env = {};

    if (tex != nullptr && prim != nullptr) {
        prim_type = MG_PRIM_SPRITE;
        env = MENU_SPRITE_ENV_SHADED;

        if (dtype == MENUFORMPARTS_DTYPE_BG) {
            env = MENU_SPRITE_ENV_OPAQUE;
        }

        if (dtype == MENUFORMPARTS_DTYPE_FADE_TOP || dtype == MENUFORMPARTS_DTYPE_FADE_BOTTOM ||
            dtype == MENUFORMPARTS_DTYPE_FADE_RIGHT || dtype == MENUFORMPARTS_DTYPE_FADE_LEFT) {
            prim_type = MG_PRIM_TRIANGLE_STRIP;
            env = MENU_SPRITE_ENV_SHADED;
        }

        SetSpriteEnv(prim, env);
        prim->Bilinear(1);
        prim->Begin(prim_type);
        prim->Texture(tex);
        u8 top_left[4] = {gray, gray, gray, alpha};
        u8 top_right[4] = {gray, gray, gray, alpha};
        u8 bottom_left[4] = {gray, gray, gray, alpha};
        u8 bottom_right[4] = {gray, gray, gray, alpha};

        if (dtype == MENUFORMPARTS_DTYPE_BG || dtype == MENUFORMPARTS_DTYPE_BETA) {
            prim->Color(gray, gray, gray, alpha);
            PrimQuad(prim, rect, tex_rect);
        } else {
            if (dtype == MENUFORMPARTS_DTYPE_FADE_TOP) {
                top_right[3] = 0;
                top_left[3] = 0;
            } else if (dtype == MENUFORMPARTS_DTYPE_FADE_BOTTOM) {
                bottom_right[3] = 0;
                bottom_left[3] = 0;
            } else if (dtype == MENUFORMPARTS_DTYPE_FADE_RIGHT) {
                bottom_right[3] = 0;
                top_right[3] = 0;
            } else if (dtype == MENUFORMPARTS_DTYPE_FADE_LEFT) {
                bottom_left[3] = 0;
                top_left[3] = 0;
            }

            prim->Color(top_left[0], top_left[1], top_left[2], top_left[3]);
            prim->TextureCrd(tex_rect.left, tex_rect.top);
            prim->Vertex(rect.left, rect.top, 0.0f);
            prim->Color(top_right[0], top_right[1], top_right[2], top_right[3]);
            prim->TextureCrd(tex_rect.left + tex_rect.right, tex_rect.top);
            prim->Vertex(rect.left + rect.right, rect.top, 0.0f);
            prim->Color(bottom_left[0], bottom_left[1], bottom_left[2], bottom_left[3]);
            prim->TextureCrd(tex_rect.left, tex_rect.top + tex_rect.bottom);
            prim->Vertex(rect.left, rect.top + rect.bottom, 0.0f);
            prim->Color(bottom_right[0], bottom_right[1], bottom_right[2], bottom_right[3]);
            prim->TextureCrd(tex_rect.left + tex_rect.right, tex_rect.top + tex_rect.bottom);
            prim->Vertex(rect.left + rect.right, rect.top + rect.bottom, 0.0f);
        }

        prim->End();
        tex->Bilinear(0);
    }
}

void CRepairEffect::Initialize() {
    active = false;
    particle = nullptr;
    sub_tex = nullptr;
    tex = nullptr;
    particle_num = 0;
}

void CRepairEffect::Generate(mgCMemory *memory, int particle_count) {
    int                     i = 0;
    REPAIR_EFFECT_PARTICLE *p = nullptr;
    int                     side = 0;
    active = false;
    particle_num = 0;
    particle = nullptr;
    if (memory == nullptr || particle_count <= 0) {
        return;
    }
    particle = dc2::memory::NewArray<REPAIR_EFFECT_PARTICLE>(*memory, static_cast<std::size_t>(particle_count));
    if (particle == nullptr) {
        return;
    }
    particle_num = particle_count;
    alpha = 0x80;
    counter = 0;
    active = true;
    i = 0;

    for (; i < particle_num; i++) {
        p = &particle[i];
        p->active = true;
        p->color[0] = 128.0f;
        p->color[1] = 128.0f;
        p->color[2] = 64.0f;
        p->alpha = 90.0f + GetRandF(20.0f);
        p->y = y + GetRandF(40.0f) - 22.0f;
        side = GetRandI(34);
        p->x = x + side;
        p->vx = GetRandF(0.16f);

        if (side < 19) {
            p->vx = -p->vx;
        }

        p->vy = 0.0f;
        p->counter = 0;
    }
}

void CRepairEffect::Step() {
    REPAIR_EFFECT_PARTICLE *p = {};
    int                     alive_count = {};
    int                     i = {};

    if (active != 0) {
        alive_count = 0;
        alpha -= 2;

        if (alpha < 0) {
            alpha = 0;
        }

        for (i = 0; i < particle_num; i++) {
            p = &particle[i];

            if (p->active != 0) {
                p->counter++;
                p->x += p->vx;
                p->y += 0.5f;
                p->alpha -= 1.7f;

                if (p->alpha <= 0.0f) {
                    p->active = false;
                }

                alive_count++;
            }
        }

        if (alive_count == 0) {
            active = false;
        }

        counter++;
    }
}

void CRepairEffect::Draw() {
    mgCDrawPrim            *prim = {};
    int                     i = {};
    REPAIR_EFFECT_PARTICLE *p = {};

    if (active != 0 && tex != nullptr) {
        prim = GetMenuPrim();
        SetSpriteEnv(prim, MENU_SPRITE_ENV_ADD);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(tex);
        prim->Color(0xC4, 0xC4, 0x80, alpha);
        prim->TextureCrd(0x40, 0);
        prim->Vertex(x, y, 0);
        prim->TextureCrd(0x60, 0x20);
        prim->Vertex(x + 0x28, y + 0x2C, 0);
        prim->End();
        prim->AlphaBlendEnable(1);
        prim->AlphaBlend(MG_ALPHA_BLEND_ADD);
        prim->Bilinear(1);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(tex);

        for (i = 0; i < particle_num; i++) {
            p = &particle[i];

            if (p->active != 0) {
                prim->Color(0xA4, 0xA4, 0x6E, static_cast<int>(p->alpha));
                prim->TextureCrd(0, 0x20);
                prim->Vertex(p->x, p->y, 0.0f);
                prim->TextureCrd(8, 0x28);
                prim->Vertex(p->x + 8.0f, p->y + 8.0f, 0.0f);
            }
        }

        prim->End();
    }
}

void CRepairManager::Initialize() {
    int i = {};
    bg_load = false;
    model_counter = 0;

    data_ready = false;
    tex_block = -1;
    sub_tex = nullptr;
    tex = nullptr;
    model = nullptr;
    data = nullptr;

    for (i = 0; i < 8; i++) {
        effect[i] = nullptr;
        effect_stack[i].stSetBuffer(nullptr, 0);
    }

    keep = false;
}

void CRepairManager::SetStack(mgCMemory *memory, int mode) {
    constexpr std::size_t effect_blocks = 0x500;
    constexpr std::size_t model_blocks = 0x1800;
    for (std::size_t index = 0; index < std::size(effect_stack); ++index) {
        effect[index] = nullptr;
        effect_stack[index].stSetBuffer(nullptr, 0);
    }
    if (memory == nullptr || (mode != 0 && mode != 1)) {
        return;
    }
    const auto bytes = dc2::memory::RemainingBytes(*memory);
    if (bytes.empty()) {
        return;
    }
    const auto available = std::span(reinterpret_cast<u_long128 *>(bytes.data()), bytes.size() / sizeof(u_long128));
    if (mode == 0) {
        model = nullptr;
        model_stack.stSetBuffer(nullptr, 0);
        constexpr auto total_blocks = model_blocks + std::extent_v<decltype(effect_stack)> * effect_blocks;
        if (available.size() < total_blocks) {
            return;
        }
        const auto tail = available.last(total_blocks);
        if (!model_stack.stShareBuffer(*memory, tail.first(model_blocks))) {
            return;
        }
        for (std::size_t index = 0; index < std::size(effect_stack); ++index) {
            if (!effect_stack[index].stShareBuffer(*memory, tail.subspan(model_blocks + index * effect_blocks, effect_blocks))) {
                return;
            }
        }
    } else {
        constexpr auto total_blocks = std::extent_v<decltype(effect_stack)> * (effect_blocks + 1);
        if (memory->lock != 0 || available.size() <= total_blocks) {
            return;
        }
        for (auto &slot : effect_stack) {
            auto *storage = memory->Alloc(static_cast<int>(effect_blocks + 1));
            if (storage == nullptr) {
                return;
            }
            slot.stSetChildBuffer(*memory, storage, static_cast<int>(effect_blocks));
        }
    }
}

void CRepairManager::Clear() {
    Initialize();
}

void CRepairManager::LoadDataBG(mgCMemory *memory) {
    int          size = {};
    unsigned int blocks = {};

    bg_load = false;

    if (data_ready == 0 || data == nullptr) {
        memory->stClearUsed();
        memory->stSetLocked(false);
        memory->Align64();
        size = 0;
        data = reinterpret_cast<unsigned int *>(&memory->stack[memory->stack_used]);
        StartReadBG();
        LoadFileBG("menu/eff/repair.gltf", dc2::memory::AvailableFrom(*memory, data), &size);

        if ((static_cast<unsigned int>(size) & 0xF) != 0) {
            blocks = (static_cast<unsigned int>(size) >> 4) + 1;
        } else {
            blocks = static_cast<unsigned int>(size) >> 4;
        }

        memory->Alloc(blocks);
        SetStack(memory, 0);
        bg_load = true;
    }
}

void CRepairManager::Generate(int x, int y) {
    int            i = {};
    int            slot = {};
    CRepairEffect *effect = {};
    mgCMemory     *memory = {};

    slot = -1;

    for (i = 0; i < 8; i++) {
        if (this->effect[i] == nullptr) {
            slot = i;
            break;
        }
    }

    if (0 <= slot) {
        memory = &effect_stack[slot];
        memory->stClearUsed();
        memory->stSetLocked(false);
        this->effect[slot] = dc2::memory::NewObject<CRepairEffect>(*memory);

        if ((effect = this->effect[slot]) != nullptr) {
            effect->Initialize();
            effect->x = x;
            effect->y = y;
            effect->sub_tex = sub_tex;
            effect->tex = tex;
            effect->Generate(memory, 0x20);
        }
    }
}

int CRepairManager::IsRunModel() {
    return model != nullptr && dc2::memory::ArenaStorageLive(model_stack);
}

int CRepairManager::IsRun() {
    int i = {};
    int running = {};

    running = false;

    for (i = 0; i < 8; i++) {
        if (effect[i] != nullptr) {
            running = true;
        }
    }

    if (IsRunModel() != 0) {
        running = true;
    }

    return running;
}

void CRepairManager::Step() {
    if (model != nullptr && !dc2::memory::ArenaStorageLive(model_stack)) {
        model = nullptr;
    }
    for (std::size_t index = 0; index < std::size(effect_stack); ++index) {
        if (!dc2::memory::ArenaStorageLive(effect_stack[index])) {
            effect[index] = nullptr;
        }
    }
    float angle = {};
    float scale = {};
    int   i = {};

    if (model != nullptr) {
        angle = 0.043633234f * model_counter;
        scale = 0.4f + 0.6f * sinf(angle);
        model->SetScale(scale, scale, scale);
        model->Step();

        if (scale < 0.46f && HALF_PI < angle) {
            model->Show(0, 1);
        }

        model_counter += 1.0f;

        if (model->CheckMotionEnd(nullptr) != 0) {
            mgTexManager.DeleteBlock(model->texture_block);
            model = nullptr;
            model_stack.stClearUsed();
            model_stack.stSetLocked(false);
        }
    }

    for (i = 0; i < 8; i++) {
        if (effect[i] != nullptr) {
            if (effect[i]->active == 0) {
                effect[i] = nullptr;
                effect_stack[i].stClearUsed();
                effect_stack[i].stSetLocked(false);
            } else {
                effect[i]->Step();
            }
        }
    }

    if (bg_load == 0 && IsRun() == 0 && keep == 0) {
        Clear();
    }
}

void CRepairManager::Draw() {
    mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *) nullptr);

    if (model != nullptr) {
        model->DrawDirect();
    }

    for (int index = 0; index < 8; index++) {
        if (effect[index] != nullptr) {
            effect[index]->Draw();
        }
    }
}

void CLevelUpEffect::Initialize() {
    active = false;
    chara = nullptr;
    tex = nullptr;
}

void CLevelUpEffect::Generate(mgCTexture *spark_texture, int effect_kind, int x, int y) {
    tex = spark_texture;
    kind = effect_kind;
    pos[0] = x - 0x10;
    pos[1] = y;
    counter = 0;
    chara = nullptr;
    active = true;
}

void CLevelUpEffect::Generate(mgCTexture *spark_texture, int effect_kind, CCharacter2 *target) {
    int i = {};

    active = true;
    kind = effect_kind;
    chara = target;
    tex = spark_texture;
    chara->GetPosition(pos);

    for (i = 0; i < 0x20; i++) {
        l_levelup_pos[i][0] = (pos[0] + GetRandF(14.0f)) - 7.0f;
        l_levelup_pos[i][1] = (pos[1] - 3.0f) + GetRandF(3.0f);
        l_levelup_pos[i][2] = (pos[2] + GetRandF(14.0f)) - 7.0f;
        l_levelup_vec[i][0] = GetRandF(0.3f) - 0.15f;
        l_levelup_vec[i][1] = GetRandF(0.5f);
        l_levelup_vec[i][2] = GetRandF(0.3f) - 0.15f;
        l_levelup_counter[i] = GetRandI(0x15);
        l_levelup_generate_counter[i] = GetRandI(3) + 2;
    }
}

int CLevelUpEffect::IsRun() {
    return active;
}

void CLevelUpEffect::Step() {
    int          i = {};
    float       *spark_pos = {};
    float       *spark_vec = {};
    int          offset = {};
    signed char *counter = {};
    signed char *generate_counter = {};
    int          alive = {};

    if (active != 0) {
        if (chara != nullptr) {
            alive = 0;
            i = 0;
            offset = 0;

            do {
                generate_counter = &l_levelup_generate_counter[i];

                if (*generate_counter > 0) {

                    spark_pos = reinterpret_cast<float *>(reinterpret_cast<u8 *>(l_levelup_pos) + offset);
                    spark_vec = reinterpret_cast<float *>(reinterpret_cast<u8 *>(l_levelup_vec) + offset);
                    counter = &l_levelup_counter[i];
                    spark_pos[0] += spark_vec[0];
                    spark_pos[1] += spark_vec[1];
                    spark_pos[2] += spark_vec[2];
                    (*counter)--;

                    if (*counter < 0) {
                        spark_pos[0] = pos[0] + GetRandF(14.0f) - 7.0f;
                        spark_pos[1] = pos[1] - 3.0f + GetRandF(3.0f);
                        spark_pos[2] = pos[2] + GetRandF(14.0f) - 7.0f;
                        spark_vec[0] = GetRandF(0.3f) - 0.15f;
                        spark_vec[1] = GetRandF(0.4f);
                        spark_vec[2] = GetRandF(0.3f) - 0.15f;
                        *counter = GetRandI(6) + 16;
                        (*generate_counter)--;
                    }

                    alive++;
                }

                i++;
                offset += 12;
            } while (i < 32);

            if (alive <= 0) {
                active = false;
                chara = nullptr;
            }
        } else {
            this->counter = this->counter + 1;

            if (this->counter > 30) {
                active = false;
            }
        }
    }
}

void CLevelUpEffect::Draw() {
    mgCDrawPrim  *prim = {};
    int          *color = {};
    int           i = {};
    int           top_left[4];
    int           bottom_right[4];
    sceVu0FVECTOR spark_pos;
    mgRect<int>   label_rect;
    int           alpha = {};
    float         x = {};
    float         y = {};

    if (active != 0 && tex != nullptr) {
        if (chara != nullptr) {
            prim = GetMenuPrim();
            SetSpriteEnv(prim, MENU_SPRITE_ENV_ADD);
            prim->Coord(1);
            prim->DepthTestEnable(1);
            prim->Begin(MG_PRIM_SPRITE);
            prim->Texture(tex);
            color = l_levelup_color[kind];

            for (i = 0; i < 32; i++) {
                if (l_levelup_generate_counter[i] > 0) {
                    spark_pos[0] = l_levelup_pos[i][0];
                    spark_pos[1] = l_levelup_pos[i][1];
                    spark_pos[2] = l_levelup_pos[i][2];
                    spark_pos[3] = 1.0f;

                    if (mgTransWorldPrim3DSprite(top_left, bottom_right, spark_pos, 1.5f, 1.5f, 0) != 0) {
                        prim->Color(color[0], color[1], color[2], 0x80);
                        prim->TextureCrd(0x40, 0);
                        prim->Vertex4(top_left);
                        prim->TextureCrd(0x60, 0x20);
                        prim->Vertex4(bottom_right);
                    }
                }
            }

            prim->End();
        } else {
            x = pos[0];
            y = pos[1] - 0.5f * counter;
            alpha = 0x80;

            if (counter > 20) {
                alpha = 0x80 - (counter - 20) * 12;
            }

            label_rect.Set(0xB8, kind * 14 + 0xE4, 0x48, 0xE);
            PrimQuad(tex, x, y, label_rect, alpha, 0x80, 0x80, 0x80);
        }
    }
}

void CLevelUpEffectManager::Initialize() {
    int i = {};

    for (i = 0; i < 8; i++) {
        effect[i].Initialize();
    }

    label_tex = nullptr;
}

int CLevelUpEffectManager::IsRun() {
    int i = {};

    for (i = 0; i < 8; i++) {
        if (effect[i].IsRun() != 0) {
            return true;
        }
    }

    return false;
}

void CLevelUpEffectManager::Generate(int effect_kind, int x, int y) {
    int i = {};

    for (i = 0; i < 8; i++) {
        if (effect[i].IsRun() == 0) {
            effect[i].Generate(label_tex, effect_kind, x, y);
            break;
        }
    }
}

void CLevelUpEffectManager::Generate(int effect_kind, CCharacter2 *chara) {
    int i = {};

    for (i = 0; i < 8; i++) {
        if (effect[i].IsRun() == 0) {
            effect[i].Generate(spark_tex, effect_kind, chara);
            break;
        }
    }
}

void CLevelUpEffectManager::Step() {
    int i = {};

    for (i = 0; i < 8; i++) {
        effect[i].Step();
    }
}

void CLevelUpEffectManager::Draw() {
    int i = {};

    for (i = 0; i < 8; i++) {
        effect[i].Draw();
    }
}

void CStarDust::Generate(int pos_x, int pos_y, int life_base, int life_range) {
    x = pos_x;
    y = pos_y;
    life = life_base + GetRandI(life_range);
    active = true;
}

void CStarDust::Step() {
    if (active != 0) {
        life -= 1;

        if (life < 0) {
            active = false;
        }
    }
}

void CStarDust::Draw(mgCTexture *texture, int u, int v) {
    short        remaining = {};
    int          alpha = {};
    mgCDrawPrim *prim = {};

    if ((active != 0) && (texture != nullptr)) {
        remaining = life;
        alpha = 0x80;

        if (remaining < 8) {
            alpha = remaining * 0x10;
        }

        prim = GetMenuPrim();
        SetSpriteEnv(prim, MENU_SPRITE_ENV_ADD);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(texture);
        prim->Color(0x80, 0x80, 0x80, alpha);
        prim->TextureCrd(u, v);
        prim->Vertex(x, y, 0.0f);
        prim->TextureCrd(u + 8, v + 8);
        prim->Vertex(8.0f + x, 8.0f + y, 0.0f);
        prim->End();
    }
}

CStarDust *CheckNotRunStarDust(CStarDust *dusts, int count) {
    int i = {};

    if (dusts == nullptr || count <= 0) {
        return nullptr;
    }

    i = 0;

    if (0 < count) {
        do {
            if (dusts[i].active == 0) {
                return &dusts[i];
            }

            i++;
        } while (i < count);
    }

    return nullptr;
}

int CheckRunStarDust(CStarDust *dusts, int count) {
    int i = {};

    if (dusts == nullptr || count <= 0) {
        return false;
    }

    i = 0;

    if (0 < count) {
        do {
            if (dusts[i].active != 0) {
                return true;
            }

            i++;
        } while (i < count);
    }

    return false;
}

void CEffVerticalLine::Generate(float *center, float range, float height) {
    float half_range = {};

    speed = 0.005f + GetRandF(0.1f);
    half_range = range / 2.0f;
    pos[0] = (center[0] + GetRandF(1.9f * range)) - 1.9f * half_range;
    pos[1] = center[1] - 0.76f * range;
    pos[2] = (center[2] + GetRandF(1.7f * range)) - 1.7f * half_range;
    pos[3] = center[3];
    w = 1.0f + GetRandF(0.4f);
    h = 0.7f + GetRandF(0.5f);
    r = GetRandF(26.0f);
    g = 72.0f + GetRandF(26.0f);
    b = 96.0f + GetRandF(26.0f);
    alpha = 138.0f + GetRandF(32.0f);
    angle = GetRandF(0.029637668f);
    angle_add = 0.059275337f;
}

void CEffVerticalLine::Step() {
    pos[1] += speed;
    h += 1.5f * speed;

    if (speed < 0.26f) {
        speed += 0.005f;
    } else {
        speed += 0.009f;
    }

    float phase = angle_add;
    phase = angle + phase;
    angle = phase;

    if (PI <= phase) {
        angle = PI;
    }
}

void CEffVerticalLine::Draw() {
    int screen_a[4];
    int screen_b[4];

    mgCDrawPrim prim;
    float       alpha = {};

    SetSpriteEnv(&prim, MENU_SPRITE_ENV_ADD);
    prim.Coord(1);
    prim.DepthTestEnable(1);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(MenuVerticalLineTex);

    if (mgTransWorldPrim3DSprite(screen_a, screen_b, &this->pos[0], this->w, this->h, 0) != 0) {
        alpha = this->alpha * sinf(this->angle);

        if (alpha <= 0.0f) {
            alpha = 0.0f;
        }

        prim.Color(fptosi(this->r), fptosi(this->g), fptosi(this->b),
                   fptosi(alpha));
        prim.TextureCrd(0, 0x62);
        prim.Vertex4(screen_a);
        prim.TextureCrd(0xA, 0x80);
        prim.Vertex4(screen_b);
    }

    if (mgTransWorldPrim3DSprite(screen_a, screen_b, &this->pos[0], 3.6f * this->w, 1.5f * this->h,
                                 0) != 0) {
        alpha = this->alpha * sinf(this->angle);

        if (alpha <= 0.0f) {
            alpha = 0.0f;
        }

        alpha *= 0.2f;
        prim.Color(fptosi(this->r), fptosi(this->g), fptosi(this->b),
                   fptosi(alpha));
        prim.TextureCrd(0, 0x62);
        prim.Vertex4(screen_a);
        prim.TextureCrd(0xA, 0x80);
        prim.Vertex4(screen_b);
    }

    prim.End();
}

/**
 *
 * Regenerates the positions and angles of build-up display line effects.
 *
 */
void InitInitBuildUpInfoEffectPos() {
    int i = {};

    for (i = 0; i < MenuVerticalLineNum; i++) {
        MenuVerticalLine[i].Generate(MenuVerticalLineCharaPos, MenuVerticalRange, 20.0f);
        MenuVerticalLine[i].pos[1] = MenuVerticalLineCharaPos[1] + GetRandF(8.0f);
        MenuVerticalLine[i].angle = GetRandF(PI);
    }
}

void InitBuildUpInfoEffect(mgCMemory *memory, mgCTexture *texture, int num, float up_limit) {
    MenuVerticalLineTex = texture;
    MenuVerticalLineUpLimmit = up_limit;
    MenuVerticalLine = nullptr;
    MenuVerticalLineNum = 0;
    MenuVerticalLineChara = nullptr;
    if (memory == nullptr || num <= 0) {
        return;
    }
    auto *lines = dc2::memory::NewArray<CEffVerticalLine>(*memory, static_cast<std::size_t>(num));
    if (lines == nullptr) {
        return;
    }
    MenuVerticalLine = lines;
    MenuVerticalLineNum = num;
    InitInitBuildUpInfoEffectPos();
}

void SetBuildUpInfoChara(CCharacter2 *chara, float range) {
    int same = {};

    same = true;

    if (MenuVerticalLineChara != chara) {
        same = false;
    }

    MenuVerticalRange = range;
    MenuVerticalLineChara = chara;

    if (chara != nullptr) {
        chara->GetPosition(MenuVerticalLineCharaPos);
        MenuVerticalLineCharaPos2[1] = MenuVerticalLineCharaPos[1] - 3.0f;

        if (same != 0) {
            InitInitBuildUpInfoEffectPos();
        }
    }
}

void StepBuildUpInfoEffect() {
    int               i = {};
    CEffVerticalLine *line = {};

    if (MenuVerticalLine != nullptr) {
        for (i = 0; i < MenuVerticalLineNum; i++) {
            MenuVerticalLine[i].Step();
            line = &MenuVerticalLine[i];

            if (PI <= line->angle || 19.0f <= line->pos[1]) {
                MenuVerticalLine[i].Generate(MenuVerticalLineCharaPos, MenuVerticalRange, 20.0f);
            }
        }
    }
}

void DrawBuildUpInfoEffect() {
    int i = {};

    if (MenuVerticalLineChara == nullptr || MenuVerticalLine == nullptr) {
        return;
    }

    if (MenuVerticalLineTex != nullptr) {
        mgTexManager.ReloadTexture(MenuVerticalLineTex->block, (sceVif1Packet *) nullptr);

        for (i = 0; i < MenuVerticalLineNum; i++) {
            MenuVerticalLine[i].Draw();
        }
    }
}

void InitFishBoiledEffect(int *position, mgCTexture *texture) {
    int i = {};

    fish_boiled_effect_tex = texture;
    fish_boiled_runflag = false;

    if (position != nullptr) {
        for (i = 0; i < 8; i++) {
            fish_boiled_positin[i][0] = (24.0f + static_cast<float>(position[0])) - GetRandF(32.0f);
            fish_boiled_positin[i][1] = (24.0f + static_cast<float>(position[1]) + GetRandF(12.0f)) - 6.0f;
            fish_boiled_alpha[i] = 132.0f - GetRandF(24.0f);
            fish_boiled_streatch_rate[i] = 0.4f + GetRandF(0.4f);
        }

        fish_boiled_runflag = true;
    }

    fish_boiled_count = 0;
}

int StepFishBoiledEffect() {
    int finished = {};
    int i = {};

    finished = 0;

    if (fish_boiled_runflag == 0) {
        return false;
    }

    for (i = 0; i < 8; i++) {
        fish_boiled_positin[i][1] -= 0.5f;
        fish_boiled_amp_count[i] = mgAngleLimit(0.052359879f + fish_boiled_amp_count[i]);

        if (CalcMenuAdd(&fish_boiled_alpha[i], -2.0f, 0.0f) != 0) {
            finished++;
        }
    }

    if (finished >= 8) {
        fish_boiled_runflag = 0;
        fish_boiled_effect_tex = nullptr;
        return false;
    }

    return true;
}

void DrawFishBoiledEffect() {
    mgCDrawPrim *prim = {};
    int          i = {};
    float        size = {};
    float        x = {};

    if (fish_boiled_runflag == 0) {
        return;
    }

    if (fish_boiled_effect_tex == nullptr) {
        return;
    }

    prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_ADD);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(fish_boiled_effect_tex);

    for (i = 0; i < 8; i++) {
        size = 32.0f * fish_boiled_streatch_rate[i];
        x = fish_boiled_positin[i][0] + 2.0f * sinf(fish_boiled_amp_count[i]);
        prim->Color(0x80, 0x80, 0x80, static_cast<int>(fish_boiled_alpha[i]));
        prim->TextureCrd(0x20, 0);
        prim->Vertex(x, fish_boiled_positin[i][1], 0.0f);
        prim->TextureCrd(0x40, 0x20);
        prim->Vertex(x + size, size + fish_boiled_positin[i][1], 0.0f);
    }

    prim->End();
}

void SetEffectSpectolBreak(mgCMemory *memory, CMenuEffect *effect, int item_no) {
    memory->stClearUsed();
    memory->stSetLocked(false);
    menu_effect_preset params = {
        {120, 175, 0, 0, 100, 100, 100, 100, 0, 0}
    };
    mgRect<int> rect;

    rect.Set(0, 0, 0, 0);
    GetMenuItemIconTexGetXY(item_no, rect);
    mgCTexture *icon_texture = GetMenuItemIconTexInfo(item_no, 0);
    params.v[2] = rect.left;
    params.v[3] = rect.top;
    params.v[4] = use_trans_rect;
    effect->PresetEffect(memory, icon_texture, MENU_EFFECT_TYPE_SPECTOL_FLASH, params.v);
    effect->EffectStart();
    MenuSePlay(-1);
}

void SetEffectSpectolFusion(mgCMemory *memory, CMenuEffect **effects, CGameDataUsed *item,
                            int is_fusion) {
    menu_effect_preset params = {
        {120, 175, 100, 100, 0, 0, 0, 0, 0, 0}
    };
    mgCTexture *icon_texture = {};

    trans_spectol_pos = GetSameAdrressUserData(item, 0);
    trans_spectol_cnt = 0;

    if (is_fusion != 0) {
        params.v[4] = 1;
    }

    if (trans_spectol_pos >= 0) {
        itemmenu_chr_rotflag = 0;
    }

    memory->stClearUsed();
    memory->stSetLocked(false);
    effects[0]->PresetEffect(memory, MenuPosData->effect_tex, MENU_EFFECT_TYPE_FUSION_SWIRL,
                             params.v);
    icon_texture = GetMenuItemIconTexInfo(item->item_no, 0);
    params.v[2] = item->item_no;
    effects[1]->PresetEffect(memory, icon_texture, MENU_EFFECT_TYPE_FUSION_ITEM, params.v);
    effects[0]->EffectStart();
    effects[1]->EffectStart();
}

void CMenuEffect::Initialize() {
    *this = CMenuEffect{};
}

void CMenuEffect::PresetEffect(mgCMemory *memory, mgCTexture *texture, int kind, int *base) {
    int *block = {};

    block = MenuCommonInfo->tex_block;
    type = kind;

    switch (kind) {
        case MENU_EFFECT_TYPE_FUSION_SWIRL:
            SetTexInfo(texture, block);
            info_num = 0x60;
            SetMemory(memory);
            SetBaseInfo(base, true, true, 4);
            break;
        case MENU_EFFECT_TYPE_GATHER:
            SetTexInfo(texture, block);
            info_num = 0x80;
            SetMemory(memory);
            SetBaseInfo(base, true, true, 4);
            break;
        case MENU_EFFECT_TYPE_FLASH:
            SetTexInfo(texture, block);
            info_num = 1;
            SetMemory(memory);
            SetBaseInfo(base, true, true, 4);
            break;
        case MENU_EFFECT_TYPE_SPECTOL_FLASH:
            SetTexInfo(texture, block);
            info_num = 0x70;
            SetMemory(memory);
            SetBaseInfo(base, true, true, 7);
            break;
        case MENU_EFFECT_TYPE_FUSION_ITEM:
            SetTexInfo(texture, block);
            info_num = 1;
            SetMemory(memory);
            SetBaseInfo(base, true, true, 4);
            break;
    }
}

void CMenuEffect::SetMemory(mgCMemory *memory) {
    unsigned int bytes = {};
    unsigned int blocks = {};

    bytes = info_num * sizeof(MENU_EFFECT_INFO);

    if (bytes & 0xF) {
        blocks = (bytes >> 4) + 1;
    } else {
        blocks = bytes >> 4;
    }

    info = reinterpret_cast<MENU_EFFECT_INFO *>(memory->Alloc(blocks));
}

void CMenuEffect::SetTexInfo(mgCTexture *texture, int *block) {
    tex = texture;

    if (block != nullptr) {
        tex_block = block[0];
    }
}

void CMenuEffect::SetBaseInfo(int *values, int preset, int initial, int count) {
    int i = {};

    for (i = 0; i < count; i++) {
        base_info[i] = values[i];
    }

    if (preset != 0) {
        PresetInfoAll(initial);
    }
}

void CMenuEffect::EffectStart() {
    run = true;
    counter = 0;
}

void CMenuEffect::PresetInfoAll(int initial) {
    int i = {};

    for (i = 0; i < info_num; i++) {
        PresetInfo(&info[i], i, initial);
    }
}

void CMenuEffect::PresetInfo(MENU_EFFECT_INFO *particle, int no, int initial) {
    switch (type) {
        case MENU_EFFECT_TYPE_GATHER: {
            float life = GetRandI(90) + 100;
            particle->life = life;
            particle->frame = GetRandI(static_cast<int>(life));
            particle->corner = 0.0f;
            particle->variant = GetRandI(4);
            particle->period = GetRandI(100);
            particle->radius = base_info[2] + GetRandI(44);
            particle->radius_speed = -(GetRandI(5) + 6);

            if (initial != 0) {
                particle->cycles = GetRandI(3) + 3;
            }

            particle->alpha = GetRandI(32) + 128;
            break;
        }
        case MENU_EFFECT_TYPE_FALL:
            particle->frame = GetRandI(3);
            particle->vx = GetRandI(4) - 2;
            particle->vy = GetRandI(9) + 10;
            particle->gravity = -(GetRandI(3) + 2);
            break;
        case MENU_EFFECT_TYPE_BURST:
            particle->frame = 0.0f;
            particle->vx = GetRandI(20) - 10;
            particle->vy = GetRandI(20) - 10;
            particle->burst_alpha = 128.0f;
            particle->fade_speed = GetRandI(3) + 5;
            break;
        case MENU_EFFECT_TYPE_FLASH:
            particle->frame = 0.0f;
            particle->w = 0.0f;
            particle->h = 0.0f;
            particle->half_w = 0.0f;
            particle->half_h = 0.0f;
            particle->alpha = 128.0f;
            break;
        case MENU_EFFECT_TYPE_FUSION_SWIRL:
        case MENU_EFFECT_TYPE_SWIRL: {
            float life = GetRandI(30) + 120;
            particle->life = life;
            particle->frame = GetRandI(static_cast<int>(life));
            particle->corner = GetRandI(3);
            particle->variant = GetRandI(4);
            particle->period = GetRandI(100) + 70;
            particle->sway_x = GetRandI(20);
            particle->sway_y = GetRandI(20);
            particle->sway_period = GetRandI(5) + 14;
            particle->pulse = GetRandI(4) + 4;
            particle->alpha = GetRandI(32) + 128;
            particle->alpha_speed = -GetRandI(5) - 1;
            particle->radius = base_info[2] + GetRandI(44);
            particle->radius_speed = -(GetRandI(3) + 2);

            if (initial != 0) {
                particle->cycles = GetRandI(2) + 3;
            }

            break;
        }
        case MENU_EFFECT_TYPE_STILL:
            particle->frame = 0.0f;
            particle->life = 64.0f;
            break;
        case MENU_EFFECT_TYPE_FUSION_ITEM:
            particle->frame = 0.0f;
            particle->item_no = base_info[2];
            particle->shake = 8.0f;
            particle->shake_decay = 0.88f;
            break;
        case MENU_EFFECT_TYPE_SQUARE:
            particle->frame = 0.0f;
            particle->interval = 1.0f;

            if (initial != 0) {
                particle->half_size = no * (static_cast<float>(base_info[2]) / info_num);
            } else {
                particle->half_size = base_info[2];
            }

            particle->size_step = -1.0f;
            particle->radius = 0.0f;
            particle->alpha = 0.0f;
            particle->alpha_speed = 1.0f;

            if (initial != 0) {
                particle->cycles = 1.0f;
            }

            break;
        case MENU_EFFECT_TYPE_SCATTER:
            particle->frame = 0.0f;
            particle->vx = GetRandI(4) + 1;
            particle->vy = GetRandI(4) + 1;

            if (GetRandI(2) != 0) {
                particle->vx = -particle->vx;
            }

            if (GetRandI(2) != 0) {
                particle->vy = -particle->vy;
            }

            particle->x = base_info[0] + particle->vx * GetRandI(3);
            particle->y = base_info[1] + particle->vy * GetRandI(3);
            particle->alpha = 128.0f;
            particle->alpha_speed = -6.0f;
            particle->cycles = 1.0f;
            break;
        case MENU_EFFECT_TYPE_SPECTOL_FLASH:
            particle->frame = GetRandI(8) + 4;
            particle->piece = no;
            particle->grow = 10.0f;
            particle->offset_x = -particle->grow - 12.0f;
            particle->offset_y = -particle->grow - 13.0f;

            if (no == 0) {
                particle->peak_alpha = 168.0f;
            } else {
                particle->peak_alpha = 0.0f;
            }

            break;
        case MENU_EFFECT_TYPE_SPECTOL_BREAK: {
            particle->frame = GetRandI(12);
            particle->piece = no % 16;
            int left = base_info[0] - 16;
            int top = base_info[1] - 16;
            int piece = static_cast<int>(particle->piece);
            particle->x = left + spectol_break_pos[piece][0][0];
            particle->y = top + spectol_break_pos[piece][0][1];
            particle->vertex1_angle = spectol_break_angle[piece][2];
            particle->vertex2_angle = spectol_break_angle[piece][4];
            particle->bounce = 4.0f * (0.98f + GetRandF(0.02f));
            particle->star_color = GetRandI(3);

            if (piece >= 48) {
                particle->x = left + GetRandI(32);
                particle->y = top + GetRandI(32);
            }

            float speed = (1.0f + GetRandF(0.01f)) * GetRandF(3.0f);
            speed += GetRandF(0.005f);
            int corner = static_cast<int>(particle->piece) % 8;

            if (corner >= 4) {
                particle->piece_vx = speed;

                if (speed < 0.0f) {
                    particle->piece_vx = 0.0f;
                }
            } else {
                particle->piece_vx = -speed;

                if (particle->piece_vx > 0.0f) {
                    particle->piece_vx = 0.0f;
                }
            }

            float rate = 1.0f;

            if (corner <= 1 || corner == 6 || corner == 7) {
                rate = 0.8f;
            }

            if (particle->piece < 8.0f) {
                particle->piece_vy = -(GetRandF(2.7f * rate) * (1.0f + GetRandF(0.01f))) - 3.0f;
                particle->floor_y = base_info[1] - GetRandF(5.0f) - 6.0f;
            } else {
                particle->piece_vy = -(GetRandF(4.0f * rate) * (1.0f + GetRandF(0.01f))) - 1.0f;
                particle->floor_y = base_info[1] + GetRandF(13.0f) + 3.0f;
            }

            particle->pulse = 0.0f;
            particle->piece_gravity = 0.0f;
            particle->damping = 0.66f + GetRandF(0.032f);
            particle->piece_alpha = 138.0f;

            if (piece < 48) {
                particle->spark_flag = 0.0f;
            } else {
                particle->spark_flag = 96.0f;
            }

            break;
        }
        case MENU_EFFECT_TYPE_SPECTOL_GATHER:
            particle->frame = GetRandI(80);
            particle->piece = 0.0f;
            particle->orbit = GetRandI(8) + 2;
            particle->ring_size = 0.0f;
            particle->shrinking = 0.0f;
            particle->star_color = GetRandI(3);
            break;
    }
}

/**
 *
 * Returns the kind of a menu effect.
 *
 */
static inline int EffectType(CMenuEffect *effect) { return effect->type; }

void CMenuEffect::Step() {
    end = false;

    if (run != 0) {
        if (info != nullptr) {
            MENU_EFFECT_INFO *particle = info;
            int               prev_type = EffectType(this);
            int               i = {};
            int               done = true;

            switch (prev_type) {
                case MENU_EFFECT_TYPE_GATHER:
                    for (i = 0; i < info_num; i++, particle++) {
                        if (particle->cycles > 0.0f) {
                            float radius = particle->radius;
                            float angle = PI / particle->period * particle->frame;
                            particle->x = base_info[0] + radius * cosf(angle);
                            particle->y = base_info[1] + radius * sinf(angle);
                            particle->radius += particle->radius_speed;
                            particle->alpha -= 8.0f;

                            if (radius < 40.0f) {
                                particle->alpha -= 20.0f;
                            }

                            if (particle->alpha < 0.0f) {
                                particle->alpha = 0.0f;
                            }

                            particle->frame += 1.0f;

                            if (particle->cycles > 1.0f && particle->radius < 3.0f) {
                                particle->cycles -= 1.0f;
                                PresetInfo(particle, i, false);
                            }

                            if (particle->cycles == 1.0f && particle->radius < 2.0f) {
                                particle->cycles -= 1.0f;
                            }

                            done = false;
                        }
                    }

                    if (done != 0) {
                        run = false;
                    }

                    break;
                case MENU_EFFECT_TYPE_FALL:
                    for (i = 0; i < info_num; i++) {
                        MENU_EFFECT_INFO *drop = &info[i];

                        if (drop->y < 520.0f) {
                            done = false;
                            drop->x = base_info[0] + drop->vx * drop->frame;
                            drop->y = base_info[1] + drop->vy * drop->frame + 0.25f * (drop->gravity * drop->frame);
                            drop->frame++;
                        }
                    }

                    if (done != 0) {
                        run = false;
                    }

                    break;
                case MENU_EFFECT_TYPE_BURST:
                    for (i = 0; i < info_num; i++) {
                        MENU_EFFECT_INFO *spark = &info[i];

                        if (spark->burst_alpha > 0.0f) {
                            spark->x += spark->vx;
                            spark->y += spark->vy;

                            if (spark->vx > 0.0f) {
                                spark->vx -= 1.0f;
                            }

                            if (spark->vx < 0.0f) {
                                spark->vx += 1.0f;
                            }

                            if (spark->vy > 0.0f) {
                                spark->vy -= 1.0f;
                            }

                            if (spark->vy < 0.0f) {
                                spark->vy += 1.0f;
                            }

                            spark->burst_alpha -= spark->fade_speed;

                            if (spark->burst_alpha < 0.0f) {
                                spark->burst_alpha = 0.0f;
                            }

                            done = false;
                        }
                    }

                    if (done != 0) {
                        run = false;
                    }

                    break;
                case MENU_EFFECT_TYPE_FADE:
                    alpha = 128 - counter * 3;

                    if (alpha < 0) {
                        alpha = 0;
                    }

                    break;
                case MENU_EFFECT_TYPE_FLASH:
                    particle->x = base_info[0] - particle->half_w;
                    particle->y = base_info[1] - particle->half_h;
                    particle->w = 2.0f * particle->half_w;
                    particle->h = 2.0f * particle->half_h;
                    particle->frame++;

                    if (particle->frame < 70.0f && static_cast<int>(particle->frame) % 2 != 0) {
                        particle->half_w += 1.0f;
                        particle->half_h += 1.0f;
                        particle->alpha += 1.0f;
                    } else if (70.0f <= particle->frame && particle->frame < 112.0f &&
                               static_cast<int>(particle->frame) % 4 == 0) {
                        particle->half_w += 2.0f;
                        particle->half_h += 2.0f;
                        particle->alpha += 5.0f;
                    } else if (112.0f <= particle->frame) {
                        particle->half_w -= 6.0f;
                        particle->half_h -= 6.0f;
                        particle->alpha -= 13.0f;
                    }

                    if (particle->alpha > 255.0f) {
                        particle->alpha = 255.0f;
                    }

                    if (particle->alpha < 0.0f) {
                        particle->alpha = 0.0f;
                    }

                    if (particle->half_w < 0.0f) {
                        particle->half_w = 0.0f;
                    }

                    if (particle->half_h < 0.0f) {
                        particle->half_h = 0.0f;
                    }

                    if (particle->alpha <= 0.0f && particle->half_w <= 0.0f) {
                        run = false;
                        type = MENU_EFFECT_TYPE_NONE;
                    }

                    break;
                case MENU_EFFECT_TYPE_FUSION_SWIRL:
                case MENU_EFFECT_TYPE_SWIRL: {
                    int faded = true;

                    for (i = 0; i < info_num; i++, particle++) {
                        particle->alpha += particle->alpha_speed;

                        if (particle->alpha < 0.0f) {
                            particle->alpha = 0.0f;
                        }

                        if (particle->cycles > 0.0f) {
                            float angle = PI / particle->period * particle->frame;
                            float radius = particle->radius;
                            particle->x = base_info[0] + radius * cosf(angle);
                            particle->y = base_info[1] + radius * sinf(angle);
                            int dx = particle->sway_x * sinf(PI * particle->frame / particle->sway_period);
                            particle->x += dx;
                            int dy = particle->sway_y * sinf(PI * particle->frame / particle->sway_period);
                            particle->y += dy;
                            particle->radius += particle->radius_speed;
                            particle->frame += 1.0f;

                            if (particle->cycles > 1.0f && particle->radius < 3.0f) {
                                particle->cycles -= 1.0f;
                                PresetInfo(particle, i, false);
                            }

                            if (particle->cycles == 1.0f && particle->radius < 2.0f) {
                                particle->cycles -= 1.0f;
                            }

                            done = false;
                        }

                        if (particle->alpha > 0.0f) {
                            faded = false;
                        }
                    }

                    if (done != 0 && faded != 0) {
                        run = false;
                    }

                    break;
                }
                case MENU_EFFECT_TYPE_STILL:
                    break;
                case MENU_EFFECT_TYPE_FUSION_ITEM:
                    particle->frame += 1.0f;
                    particle->x = base_info[0] + particle->shake * sinf(GetRandF(TWO_PI));
                    particle->y = base_info[1] + particle->shake * sinf(GetRandF(TWO_PI));

                    if (static_cast<int>(particle->frame) % 2 != 0) {
                        particle->shake *= particle->shake_decay;
                    }

                    particle->red = particle->green = particle->blue = 200.0f;
                    break;
                case MENU_EFFECT_TYPE_SQUARE:
                    for (i = 0; i < info_num; i++, particle++) {
                        particle->frame++;

                        if (static_cast<int>(particle->frame) % 2 != 0) {
                            particle->alpha += particle->alpha_speed;
                        }

                        if (particle->alpha <= 0.0f) {
                            particle->alpha = 0.0f;
                        }

                        if (particle->alpha > 164.0f) {
                            particle->alpha = 164.0f;
                        }

                        if (particle->cycles > 0.0f) {
                            if (static_cast<int>(particle->frame) % static_cast<int>(particle->interval) == 0) {
                                particle->half_size += particle->size_step;

                                if (particle->half_size <= 0.0f) {
                                    particle->cycles -= 1.0f;
                                    particle->half_size = 0.0f;
                                    PresetInfo(particle, i, false);
                                }
                            }

                            done = false;
                            particle->x = base_info[0] - particle->half_size;
                            particle->y = base_info[1] - particle->half_size;
                        }

                        if (particle->cycles <= 0.0f) {
                            particle->alpha = 0.0f;
                        }
                    }

                    if (done != 0) {
                        run = false;
                    }

                    break;
                case MENU_EFFECT_TYPE_SCATTER:
                    for (i = 0; i < info_num; i++, particle++) {
                        particle->alpha += particle->alpha_speed;

                        if (particle->cycles > 0.0f) {
                            particle->x += particle->vx;
                            particle->y += particle->vy;
                            particle->frame++;
                            done = false;

                            if (particle->cycles > 1.0f && particle->alpha < 10.0f) {
                                particle->cycles -= 1.0f;
                            }
                        }
                    }

                    if (done != 0) {
                        run = false;
                    }

                    break;
                case MENU_EFFECT_TYPE_SPECTOL_FLASH: {
                    int ended = 0;

                    for (i = 0; i < 1; i++, particle++) {
                        particle->frame += 1.0f;
                        particle->alpha = particle->peak_alpha * sinf(0.07853982f * particle->frame);
                        particle->x = base_info[0] - 16;
                        particle->y = base_info[1] - 12;

                        if (particle->alpha <= 0.0f) {
                            particle->alpha = 0.0f;
                            ended++;
                        }
                    }

                    if (ended > 0) {
                        type = MENU_EFFECT_TYPE_SPECTOL_BREAK;
                        PresetInfoAll(false);
                        counter = 0;
                    }

                    break;
                }
                case MENU_EFFECT_TYPE_SPECTOL_BREAK: {
                    int ended = 0;

                    for (i = 0; i < info_num; i++, particle++) {
                        particle->frame++;

                        if (particle->frame > 26.0f) {
                            particle->piece_alpha -= 2.0f;
                        }

                        if (particle->piece_alpha < 0.0f) {
                            particle->piece_alpha = 0.0f;
                            ended++;
                        }

                        if (particle->y <= mgScreenHeight && particle->x <= mgScreenWidth) {
                            particle->x += particle->piece_vx;
                            particle->y += particle->piece_vy;

                            if (static_cast<int>(particle->frame) % 6 == 0) {
                                particle->piece_vx *= particle->damping;
                                particle->piece_vy += particle->piece_gravity;
                            }

                            if (particle->floor_y <= base_info[1] && particle->piece_vy > 2.0f &&
                                particle->floor_y < particle->y) {
                                particle->piece_vy = -(0.8f * particle->bounce);
                                particle->piece_gravity = -1.0f;
                                particle->floor_y += 3.5f * (1.0f + GetRandF(0.004f) - 0.002f);

                                if (particle->bounce > 2.9f) {
                                    particle->bounce -= 1.6f;
                                }
                            }

                            if (particle->floor_y > base_info[1] && particle->piece_vy > 2.0f &&
                                particle->floor_y < particle->y) {
                                particle->piece_vy = -(0.9f * particle->bounce);
                                particle->piece_gravity = 2.0f;
                                particle->floor_y += 3.6f * (1.0f + GetRandF(0.004f) - 0.002f);

                                if (particle->bounce > 2.6f) {
                                    particle->bounce -= 1.1f;
                                }
                            }

                            if (particle->floor_y < base_info[1]) {
                                if (static_cast<int>(particle->frame) % 6 == 0) {
                                    particle->piece_gravity += 1.0f;
                                }
                            } else if (static_cast<int>(particle->frame) % 12 == 0) {
                                particle->piece_gravity += 1.0f;
                            }

                            if (static_cast<int>(particle->frame) % 12 == 0) {
                                particle->piece_gravity += 1.0f;
                            }
                        }
                    }

                    if (ended >= 48 && counter > 90) {
                        type = MENU_EFFECT_TYPE_SPECTOL_GATHER;
                        PresetInfoAll(false);
                        tex = MenuPosData->icon_effect_tex;
                        counter = 0;
                    }

                    break;
                }
                case MENU_EFFECT_TYPE_SPECTOL_GATHER: {
                    int gathered = 0;

                    for (i = 0; i < info_num - 1; i++, particle++) {
                        particle->frame += 1.0f;
                        particle->x += (base_info[4] - particle->x) / 9.0f;
                        particle->y += (base_info[5] - particle->y) / 9.0f;
                        int fade = {};

                        if (abs(static_cast<int>(particle->x - base_info[4])) < 9 && abs(static_cast<int>(particle->y - base_info[5])) < 9) {
                            particle->x = base_info[4] + particle->orbit * sinf(0.07853982f * particle->frame);
                            particle->y = base_info[5] + particle->orbit * cosf(0.07853982f * particle->frame);
                            fade = -5;
                            gathered++;
                        } else {
                            fade = 3;
                            done = false;
                        }

                        particle->piece_alpha += fade;

                        if (particle->piece_alpha < 0.0f) {
                            particle->piece_alpha = 0.0f;
                        }

                        if (particle->piece_alpha > 128.0f) {
                            particle->piece_alpha = 128.0f;
                        }
                    }

                    particle->frame++;
                    particle->x = base_info[4] - particle->ring_size;
                    particle->y = base_info[5] - particle->ring_size;

                    if (gathered < info_num * 14 / 15) {
                        particle->ring_size += 2.0f;

                        if (!(particle->ring_size < 30.0f)) {
                            particle->ring_size = 30.0f;
                        }
                    } else if (static_cast<int>(particle->frame) % 2 == 0) {
                        particle->shrinking = 1.0f;
                        particle->ring_size -= 1.0f;

                        if (particle->ring_size < 0.0f) {
                            particle->ring_size = 0.0f;
                        }
                    }

                    particle->piece_alpha = 7.0f * particle->ring_size;

                    if (done != 0 && particle->ring_size <= 0.0f) {
                        run = false;
                    }

                    break;
                }
            }

            if (prev_type != type) {
                end = true;
            }

            counter++;
        }
    }
}

void CMenuEffect::Draw() {
    if (run != 0 && info != nullptr && tex != nullptr) {
        mgTexManager.ReloadTexture(tex_block, (sceVif1Packet *) nullptr);
        mgCDrawPrim *prim = GetMenuPrim();
        prim->Initialize(nullptr, nullptr);
        prim->AlphaBlendEnable(1);
        prim->AlphaBlend(MG_ALPHA_BLEND_ADD);
        prim->AlphaTestEnable(1);
        prim->AlphaTest(1, 0);
        prim->DepthTestEnable(0);
        prim->ZMask(MG_Z_MASK_MASKED);
        prim->Shading(1);
        prim->TextureMapEnable(1);
        prim->Bilinear(1);
        MENU_EFFECT_INFO *particle = info;
        int               color[4] = {0x80, 0x80, 0x80, alpha};
        mgRect<float>     rect(0.0f, 0.0f, 8.0f, 8.0f);
        mgRect<int>       uv(0, 32, 8, 8);
        ZeroedRect        corner_uv[4];
        corner_uv[3].Set(32, 32, 32, 32);
        int i = {};

        switch (type) {
            case MENU_EFFECT_TYPE_SPECTOL_BREAK:
                prim->AlphaBlend(MG_ALPHA_BLEND_NORMAL);
                prim->Begin(MG_PRIM_TRIANGLE);
                prim->Texture(tex);

                for (i = 0; i < 48; i++, particle++) {
                    int piece = static_cast<int>(particle->piece);
                    prim->Color(color[0], color[1], color[2], static_cast<int>(particle->piece_alpha));
                    s16(*corner)[2] = spectol_break_pos[piece];
                    prim->TextureCrd(base_info[2] + corner[0][0], base_info[3] + corner[0][1]);
                    prim->Vertex(particle->x, particle->y, 0.0f);
                    prim->TextureCrd(base_info[2] + corner[1][0], base_info[3] + corner[1][1]);
                    float angle = particle->vertex1_angle + 0.05235988f * particle->frame;
                    prim->Vertex(particle->x + 10.0f * cosf(angle), particle->y + 10.0f * sinf(angle), 0.0f);
                    prim->TextureCrd(base_info[2] + corner[2][0], base_info[3] + corner[2][1]);
                    angle = particle->vertex2_angle + 0.05235988f * particle->frame;
                    prim->Vertex(particle->x + 10.0f * cosf(angle), particle->y + 10.0f * sinf(angle), 0.0f);
                }

                prim->End();
                prim->AlphaBlend(MG_ALPHA_BLEND_ADD);
                prim->Begin(MG_PRIM_SPRITE);
                prim->Texture(MenuPosData->icon_effect_tex);

                for (; i < info_num || i < 80; i++, particle++) {
                    prim->Color(color[0], color[1], color[2], static_cast<int>(particle->piece_alpha));
                    prim->TextureCrd(0, 32);
                    prim->Vertex(particle->x, particle->y, 0.0f);
                    prim->TextureCrd(8, 40);
                    prim->Vertex(8.0f + particle->x, 8.0f + particle->y, 0.0f);
                }

                prim->End();
                return;
            case MENU_EFFECT_TYPE_SPECTOL_FLASH: {
                int size = static_cast<int>(32.0f + 2.0f * particle->grow);
                prim->Begin(MG_PRIM_SPRITE);
                prim->Texture(MenuPosData->icon_effect_tex);
                prim->Color(0x80, 0x80, 0x80, static_cast<int>(particle->alpha));
                mgRect<int> put(static_cast<int>(particle->x), static_cast<int>(particle->y), size, size);
                PrimQuad(prim, put, star_light);
                prim->End();
                return;
            }
            case MENU_EFFECT_TYPE_FUSION_ITEM: {
                rect.Set(particle->x, particle->y, 32.0f, 40.0f);
                item_color item_rgba = {
                    {0, 0, 0, 0}
                };
                item_rgba.rgba[0] = particle->red;
                item_rgba.rgba[1] = particle->green;
                item_rgba.rgba[2] = particle->green;
                item_rgba.rgba[3] = particle->alpha;
                DrawOneItem(prim, rect, static_cast<int>(particle->item_no), 0, nullptr, item_rgba.rgba, 0);
                return;
            }
            case MENU_EFFECT_TYPE_FLASH:
                uv.Set(0x60, 0, 16, 16);
                rect.Set(particle->x, particle->y, particle->w, particle->h);
                break;
            case MENU_EFFECT_TYPE_FUSION_SWIRL:
                rect.Set(0.0f, 0.0f, 32.0f, 32.0f);
                corner_uv[0].Set(0, 0, 32, 32);
                corner_uv[1].Set(32, 0, 32, 32);
                corner_uv[2].Set(0, 32, 32, 32);

                if (base_info[4] == 0) {
                    rect.Set(0.0f, 0.0f, 16.0f, 16.0f);
                }

                break;
            case MENU_EFFECT_TYPE_SWIRL:
                rect.Set(0.0f, 0.0f, 32.0f, 32.0f);
                break;
            case MENU_EFFECT_TYPE_SQUARE:
                uv.Set(0, 0, 32, 32);
                color[0] = color[1] = 0x20;
                color[2] = 0x60;
                break;
            case MENU_EFFECT_TYPE_SCATTER:
                rect.Set(0.0f, 0.0f, 32.0f, 32.0f);
                uv.Set(0x40, 0, 32, 32);
                break;
        }

        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(tex);

        for (i = 0; i < info_num; i++, particle++) {
            if (type == MENU_EFFECT_TYPE_GATHER) {
                color[3] = static_cast<int>(particle->alpha);
            } else if (type == MENU_EFFECT_TYPE_BURST) {
                color[3] = static_cast<int>(particle->burst_alpha);
            } else if (type == MENU_EFFECT_TYPE_FUSION_SWIRL) {
                uv = corner_uv[static_cast<int>(particle->corner)];
                float angle = (PI / 8.0f) * particle->frame;

                while (PI <= angle) {
                    angle -= TWO_PI;
                }

                rect.right = rect.bottom = 32.0f + particle->pulse * sinf(angle);
                color[3] = static_cast<int>(particle->alpha);
            } else if (type == MENU_EFFECT_TYPE_SWIRL) {
                uv = corner_uv[3];
            } else if (type == MENU_EFFECT_TYPE_SQUARE) {
                float size = 2.0f * particle->half_size;
                rect.Set(particle->x, particle->y, size, size);
                color[3] = static_cast<int>(particle->alpha);
            } else if (type == MENU_EFFECT_TYPE_SPECTOL_GATHER) {
                if (i == info_num - 1) {
                    float size = 2.0f * particle->ring_size;
                    rect.Set(particle->x, particle->y, size, size);
                    uv.Set(0x40, 0, 32, 32);
                } else {
                    int *star_color = &star_color_table[static_cast<int>(particle->star_color) * 3];
                    color[0] = star_color[0];
                    color[1] = star_color[1];
                    color[2] = star_color[2];
                }

                color[3] = static_cast<int>(particle->piece_alpha);
            }

            prim->Color(color[0], color[1], color[2], color[3]);
            rect.left = particle->x;
            rect.top = particle->y;
            PrimQuad(prim, rect, uv);
        }

        prim->End();
    }
}

void PrimQuad_f_(mgCDrawPrim *prim, mgRect_f_ rect, mgRect_i_ tex_rect) {
    if (prim != nullptr) {
        prim->TextureCrd(tex_rect.left, tex_rect.top);
        prim->Vertex(rect.left, rect.top, 0.0f);
        prim->TextureCrd(tex_rect.left + tex_rect.right, tex_rect.top + tex_rect.bottom);
        prim->Vertex(rect.left + rect.right, rect.top + rect.bottom, 0.0f);
    }
}

void PrimQuad_i_(mgCDrawPrim *prim, mgRect_i_ rect, mgRect_i_ tex_rect) {
    if (prim != nullptr) {
        prim->TextureCrd(tex_rect.left, tex_rect.top);
        prim->Vertex(rect.left, rect.top, 0);
        prim->TextureCrd(tex_rect.left + tex_rect.right, tex_rect.top + tex_rect.bottom);
        prim->Vertex(rect.left + rect.right, rect.top + rect.bottom, 0);
    }
}

int MenuDrawItemInfoNum;

CGameDataUsed *NowGiftBoxPtr;

CMenuPosDataForm *GiftBoxViewForm;

int NowGiftBoxSelect;

u8 GiftBoxViewFlag;

namespace dc2::menu {
namespace {
dc2::memory::ArenaBuffer random_line_storage; /**< Exact lease containing the invention menu's line points. */
}

void BindRandomLinePoints(mgCMemory &owner, std::span<int[2]> points) {
    random_line_storage = dc2::memory::ArenaBuffer::Bind(owner, {reinterpret_cast<u8 *>(points.data()), points.size_bytes()});
    if (!random_line_storage.Bytes().empty()) {
        for (auto &point : points) {
            point[0] = 0;
            point[1] = 0;
        }
    }
}

std::span<int[2]> RandomLinePoints() {
    const auto bytes = random_line_storage.Bytes();
    if (bytes.empty() || bytes.size() % sizeof(int[2]) != 0) {
        return {};
    }
    return {reinterpret_cast<int (*)[2]>(bytes.data()), bytes.size() / sizeof(int[2])};
}
} // namespace dc2::menu

int MenuCursorReverseFlag;

s8 MenuItemBrdCalcManner;

float MenuItemBrdUnderBrdPosXY[2];

CMenuPosDataManage *MenuPosData;

mgCTexture *MenuFrameTex;

u8 menu_limmit_displayflag[0x9C];

CMenuPosDataForm *MenuMesForm[9];

CGameDataUsed *MenuDrawItemInfo[150];

mgRect<int> GiftBoxWindowPutPos(0, 0, 0, 0);

s16 Pos_ItemInGiftBox[3][2];

float MakeBoardDrawInfo[5];

mgRect<int> menu_long_hand(62, 1, 40, 24);

mgRect<int> MenuMainFrame_PutRect(0, 0, 0, 0);

mgRect<int> MenuMainIMG_PutRect(0, 0, 0, 0);

mgRect<int> star_light(0, 32, 8, 8);

mgRect<int> MenuItemBrdKomaRect(32, 32, 40, 50);

mgRect<int> ItemBoardScrlBar1(96, 128, 22, 11);

mgRect<int> ItemBoardScrlBar2(96, 138, 22, 4);

mgRect<int> ItemBoardScrlBar3(96, 140, 22, 12);

mgRect<int> ItemBoardCursor(118, 128, 8, 30);

namespace {
void MainFrameModeSetCore(int mode, int restart) {
    MenuMainFrame_Display_Mode = mode;
    MenuMainFrame_ActionEndFlag = false;
    MenuMainFrame_MoveRate[0] = 1.0f;

    if (restart != 0) {
        switch (MenuMainFrame_Display_Mode) {
            case MENU_MAIN_FRAME_OPEN:
                MenuMainFrame_Display_Mode_Cnt = 0.0f;
                MenuMainFrame_Display_Mode_Cnt_Rate = 0.7f;
                break;
            case MENU_MAIN_FRAME_SLIDE_LEFT:
            case MENU_MAIN_FRAME_LEAVE_RIGHT:
            case MENU_MAIN_FRAME_LEAVE_DOWN:
            case MENU_MAIN_FRAME_LEAVE_UP:
                MenuMainFrame_Display_Mode_Cnt = 10.0f;
                MenuMainFrame_Lenze_Pos[0] = 350.0f;
                MenuMainFrame_Lenze_Pos[1] = 240.0f;
                break;
        }
    }

    MenuMainFrame_MoveRate[0] = GetMenuMainFrameCount();
    MenuMainFrame_MoveRate[1] = GetMenuMainFrameCount();
    MenuMainFrame_MoveRate_Cnt = 0.0f;

    if (MenuMainFrame_Display_Mode >= MENU_MAIN_FRAME_LEAVE_RIGHT) {
        MenuMainFrame_MoveRate_Cnt = (PI / 12.0f);
    }
}

void MainFrameStepCore() {
    mgRect<int> screen;
    MenuMainFrame_PutRect.Set(0, 0, 0x2C0, 0x1E0);
    screen.Set(0, 0, 0x2C0, 0x1A0);
    float              progress = MenuMainFrame_Display_Mode_Cnt / 10.0f;
    float              scale = 1.5f - 0.5f * progress;
    static signed char MainFrameStepFlag = 0;

    switch (MenuMainFrame_Display_Mode) {
        case MENU_MAIN_FRAME_OPEN:
        case MENU_MAIN_FRAME_CLOSE: {
            mgRect<int> *image = {};

            if (MenuMainFrame_Display_Mode == MENU_MAIN_FRAME_OPEN) {
                if (MenuMainFrame_Display_Mode_Cnt < 10.0f) {
                    CalcMenuAdd(&MenuMainFrame_Display_Mode_Cnt, MenuMainFrame_Display_Mode_Cnt_Rate, 10.0f);

                    if (MenuMainFrame_Display_Mode_Cnt < 7.142857f) {
                        CalcMenuAdd(&MenuMainFrame_Display_Mode_Cnt_Rate, 0.3f, 1.4f);
                    } else {
                        CalcMenuAdd(&MenuMainFrame_Display_Mode_Cnt_Rate, -0.3f, 0.6f);
                    }

                    MainFrameStepFlag = 0;
                } else {
                    MainFrameStepFlag = 0;
                    MenuMainFrame_Display_Mode_Cnt = 10.0f;
                    MenuMainFrame_ActionEndFlag = true;
                }
            }

            int mode = MenuMainFrame_Display_Mode;

            if (mode == MENU_MAIN_FRAME_CLOSE) {
                if (0.0f < MenuMainFrame_Display_Mode_Cnt) {
                    MenuMainFrame_Display_Mode_Cnt -= 1.0f;
                }

                if (MainFrameStepFlag > 0) {
                    MenuMainFrame_ActionEndFlag = true;
                }

                if (MenuMainFrame_Display_Mode_Cnt < 0.0f) {
                    MenuMainFrame_Display_Mode_Cnt = 0.0f;
                }
            }

            MenuMainFrame_Lenze_Pos[0] = 256.0f + 94.0f * progress;
            MenuMainFrame_Lenze_Pos[1] = 240.0f;
            float lenze_x = MenuMainFrame_Lenze_Pos[0];
            MenuMainFrame_PutRect.left = static_cast<int>(lenze_x - 350.0f * scale);
            MenuMainFrame_PutRect.top = static_cast<int>(MenuMainFrame_Lenze_Pos[1] - 240.0f * scale);
            MenuMainFrame_PutRect.right = static_cast<int>(704.0f * scale);
            MenuMainFrame_PutRect.bottom = static_cast<int>(480.0f * scale);
            float image_half_height = 1.1538461f * (scale * 160.0f);
            image = &MenuMainIMG_PutRect;
            image->bottom = static_cast<int>(2.0f * image_half_height);
            image->right = static_cast<int>(1.06f * image->bottom);
            image->left = static_cast<int>(lenze_x - 198.0f * scale);
            image->top = static_cast<int>(MenuMainFrame_Lenze_Pos[1] - image_half_height);

            if (image->right > mgScreenWidth) {
                if (mode == MENU_MAIN_FRAME_CLOSE) {
                    image->right = mgScreenWidth;
                } else {
                    image->right = mgScreenWidth;
                    image->left = 0;
                }
            }

            while (image->top < 0) {
                image->top++;
            }

            while (mgScreenHeight < image->top + image->bottom) {
                image->bottom--;
            }

            if (image->left < 9) {
                image->left = 0;
                MainFrameStepFlag++;
            }

            break;
        }
        case MENU_MAIN_FRAME_SLIDE_LEFT:
            MenuMainFrame_Lenze_Pos[0] -= 11.285714f;

            if (MenuMainFrame_Lenze_Pos[0] < 158.0f) {
                MenuMainFrame_Lenze_Pos[0] = 158.0f;
                MenuMainFrame_ActionEndFlag = true;
            }

            break;
        case MENU_MAIN_FRAME_SLIDE_BACK:
            MenuMainFrame_Lenze_Pos[0] += 11.285714f;

            if (!(MenuMainFrame_Lenze_Pos[0] < 350.0f)) {
                MenuMainFrame_Lenze_Pos[0] = 350.0f;
                MenuMainFrame_ActionEndFlag = true;
            }

            break;
        case MENU_MAIN_FRAME_LEAVE_RIGHT:
        case MENU_MAIN_FRAME_RETURN_RIGHT: {
            MenuMainFrame_MoveRate_Cnt += 0.08726647f;
            float move = MenuMainFrame_MoveRate[0] * sinf(MenuMainFrame_MoveRate_Cnt);

            if (MenuMainFrame_Display_Mode == MENU_MAIN_FRAME_LEAVE_RIGHT && move < 0.0f) {
                move = -move;
            }

            if (MenuMainFrame_Display_Mode == MENU_MAIN_FRAME_RETURN_RIGHT && move > 0.0f) {
                move = -move;
            }

            MenuMainFrame_Lenze_Pos[0] += move;

            if (MenuMainFrame_Display_Mode == MENU_MAIN_FRAME_LEAVE_RIGHT) {
                if (!(MenuMainFrame_Lenze_Pos[0] < 860.0f)) {
                    MenuMainFrame_Lenze_Pos[0] = 860.0f;
                    MenuMainFrame_ActionEndFlag = true;
                }
            } else if (MenuMainFrame_Lenze_Pos[0] <= 350.0f) {
                MenuMainFrame_Lenze_Pos[0] = 350.0f;
                MenuMainFrame_ActionEndFlag = true;
            }

            break;
        }
        case MENU_MAIN_FRAME_LEAVE_DOWN:
        case MENU_MAIN_FRAME_RETURN_DOWN: {
            MenuMainFrame_MoveRate_Cnt += 0.09817477f;
            float move = MenuMainFrame_MoveRate[1] * sinf(MenuMainFrame_MoveRate_Cnt);

            if (MenuMainFrame_Display_Mode == MENU_MAIN_FRAME_LEAVE_DOWN && move < 0.0f) {
                move = -move;
            }

            if (MenuMainFrame_Display_Mode == MENU_MAIN_FRAME_RETURN_DOWN && move > 0.0f) {
                move = -move;
            }

            MenuMainFrame_Lenze_Pos[1] += move;

            if (MenuMainFrame_Display_Mode == MENU_MAIN_FRAME_LEAVE_DOWN && !(MenuMainFrame_Lenze_Pos[1] < 720.0f)) {
                MenuMainFrame_Lenze_Pos[1] = 720.0f;
                MenuMainFrame_ActionEndFlag = true;
            }

            if (MenuMainFrame_Display_Mode == MENU_MAIN_FRAME_RETURN_DOWN && MenuMainFrame_Lenze_Pos[1] <= 240.0f) {
                MenuMainFrame_Lenze_Pos[1] = 240.0f;
                MenuMainFrame_ActionEndFlag = true;
            }

            break;
        }
        case MENU_MAIN_FRAME_LEAVE_UP:
        case MENU_MAIN_FRAME_RETURN_UP: {
            MenuMainFrame_MoveRate_Cnt += 0.08726647f;
            float move = MenuMainFrame_MoveRate[1] * sinf(MenuMainFrame_MoveRate_Cnt);

            if (MenuMainFrame_Display_Mode == MENU_MAIN_FRAME_LEAVE_UP && move > 0.0f) {
                move = -move;
            }

            if (MenuMainFrame_Display_Mode == MENU_MAIN_FRAME_RETURN_UP && move < 0.0f) {
                move = -move;
            }

            MenuMainFrame_Lenze_Pos[1] += move;

            if (MenuMainFrame_Display_Mode == MENU_MAIN_FRAME_LEAVE_UP && MenuMainFrame_Lenze_Pos[1] <= -260.0f) {
                MenuMainFrame_Lenze_Pos[1] = -260.0f;
                MenuMainFrame_ActionEndFlag = true;
            }

            if (MenuMainFrame_Display_Mode == MENU_MAIN_FRAME_RETURN_UP && !(MenuMainFrame_Lenze_Pos[1] < 240.0f)) {
                MenuMainFrame_Lenze_Pos[1] = 240.0f;
                MenuMainFrame_ActionEndFlag = true;
            }

            break;
        }
    }

    if (MenuMainFrame_Display_Mode >= MENU_MAIN_FRAME_SLIDE_LEFT) {
        MenuMainFrame_PutRect.left = static_cast<int>(MenuMainFrame_Lenze_Pos[0] - 350.0f * scale);
        MenuMainFrame_PutRect.top = static_cast<int>(MenuMainFrame_Lenze_Pos[1] - 240.0f * scale);
    }

    MenuMainFrame_LeftTop_Pos[0] = MenuMainFrame_PutRect.left;
    MenuMainFrame_LeftTop_Pos[1] = MenuMainFrame_PutRect.top;
}

void MainFrameImageDrawCore(int &loaded_tex_no) {
    mgRect<int> dest(0, 0, 0, 0);
    mgRect<int> source(0, 0, mgScreenWidth / 2, mgScreenHeight / 2);
    int         alpha = static_cast<int>(128.0f * (MenuMainFrame_Display_Mode_Cnt / 10.0f));
    dest = MenuMainIMG_PutRect;

    switch (MenuMainFrame_Display_Mode) {
        case MENU_MAIN_FRAME_OPEN:
        case MENU_MAIN_FRAME_CLOSE:
            if (MenuMainFrame_Display_Mode == MENU_MAIN_FRAME_CLOSE) {
                alpha = 0x80;
            }

            break;
        default:
            dest.left = static_cast<int>(MenuMainFrame_Lenze_Pos[0] - 194.0f);
            dest.top = static_cast<int>(MenuMainFrame_Lenze_Pos[1] - 184.61539f);
            break;
    }

    mgRect<int> screen(0, 0, mgScreenWidth, mgScreenHeight);
    DrawMenuMainFrmImg(loaded_tex_no, screen, source, 0x80, 0x80, 0x80, alpha, 0);
    dest.bottom += 1;
    DrawMenuMainFrmImg(loaded_tex_no, dest, source, 0x80, 0x80, 0x80, alpha, 0);
}
} // namespace

int CMenuPosDataManage::MoveMainMenuIconsCore(int *icons, int select, int mode) {
    int               arrived = 0;
    int               count = 0;
    int               language = 0;
    int               slot = {};
    int               i = {};
    CMenuPosDataForm *form = {};
    int               j = {};
    int               icon = {};
    short (*act_offset)[2] = {};
    int highlight = {};

    if (LanguageCode > LANG_JAPANESE) {
        language = 1;
    }

    if (CheckNowEurope() != 0) {
        language = 2;
    }

    act_offset = actposoffsettbl1_4195[language];
    slot = 0;

    for (i = 0; (icon = icons[i]) >= 0 && count < 19; i++, count++) {
        form = GetFormInfo(dc2::menu::MainIconName(icon).data());

        if (form != nullptr) {
            icon_move_pos target = {
                {0, 0}
            };

            if (mode == 0) {
                target.pos[0] = static_cast<int>(static_cast<float>(baseposoffset_tbl_4194[icon][0]) +
                                                 (170.0f - 110.0f * sinf(0.44879895f + 0.35298797f * static_cast<float>(slot))));
            } else if (mode == 1 || mode == 2 || mode == 3) {
                target.pos[0] = basepos_4190[0] + farleft_4191[0];
            }

            target.pos[1] = basepos_4190[1] + xyoffset_4192[1] * slot;
            highlight = true;

            if (select >= 0 && select == icon && (mode == 2 || mode == 3)) {
                target.pos[0] = actpos_4193[0] + act_offset[icon][0];
                target.pos[1] = actpos_4193[1] + act_offset[icon][1];
                highlight = false;
            }

            form->rgba[0] = 0xA0;
            form->rgba[1] = 0xA0;
            form->rgba[2] = 0xA0;
            form->rgba[3] = 0x80;

            for (j = 0; j < 4; j++) {
                form->SetRGBACalcParam(j, 0, 0x80);
            }

            form->rgba_bit = 0;

            if (select == icon && highlight != 0) {
                form->rgba_bit = MENUFORM_RGBA_BIT_RGB;
            }

            form->SetNextMovePos(target.pos, MENUFORM_MTYPE_I);
            form->draw_flag = true;

            if (form->CheckMoveEnd(target.pos[0], target.pos[1]) != 0) {
                arrived++;
            }

            slot++;
        }
    }

    if (arrived >= count - 1) {
        return true;
    }

    return false;
}

void MenuReloadCLUT(int index) {
    MgTextureSetDrawVariant(MenuCharaChangeBase_Tex, index == 0 ? MenuCharaChangeCLUT_Tex : nullptr);
}

void DrawMenuFillBox(int alpha, int red, int green, int blue) {
    if (!menuworld::FillWithBackdrop()) {
        DrawMenuFillBox(0.0f, 0.0f, mgScreenWidth, mgScreenHeight, alpha, red, green, blue);
    }
}

void MenuMainFrameModeSet(int mode, int restart) {
    MainFrameModeSetCore(menuworld::FrameMode(mode), restart);
}

void MenuMainFrameStep() {
    MainFrameStepCore();
    menuworld::FrameStepped();
}

void MenuMainFrameImgDraw(int &tex_block) {
    if (!menuworld::DrawOrbPicture()) {
        MainFrameImageDrawCore(tex_block);
    }
}

void DrawMenuWakuRect(mgCTexture *texture, mgRect<float> rect, mgRect<int> uv,
                      int alpha, int red, int green, int blue) {
    if (texture == nullptr || uv.right <= 0) {
        return;
    }
    // The frame's many clipped pieces move together, or a frame between two spread panels comes apart.
    std::optional<gfx::UiAnchorScope> anchor;
    if (const auto selection = menuworld::SelectionAnchor()) {
        anchor.emplace(*selection);
    }
    const mgRect<int> outer(static_cast<int>(rect.left), static_cast<int>(rect.top),
                            static_cast<int>(rect.left + rect.right + uv.bottom),
                            static_cast<int>(rect.top + rect.bottom + uv.right));
    auto              scissor = outer;
    // The cursor is shifted past the logical frame on a wide window, so the frame's clamp would cut its rect.
    if (!menuworld::CursorDrawing()) {
        MenuClipRectCheck(scissor);
    }
    if (scissor.right <= 1) {
        return;
    }
    auto *prim = GetMenuPrim();
    SetMenuScissor(scissor);
    SetSpriteEnv(prim, MENU_SPRITE_ENV_ADD);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(texture);
    prim->Color(red, green, blue, alpha);
    float     sign = 1.0f;
    const int horizontal_count = static_cast<int>(3.0f + rect.right / uv.right);
    for (int edge = 0; edge < 2; ++edge) {
        float       x = (edge == 0 ? outer.right - 3 : outer.left) + PortMenuWakuPosition[0] * sign;
        const float y = edge == 0 ? outer.top - 5 : outer.bottom - 8;
        for (int tile = 0; tile < horizontal_count; ++tile) {
            // Tiles overshoot the rectangle's ends by up to three pieces; each is cut at the rectangle's own edges.
            const float left = std::max(x, static_cast<float>(outer.left));
            const float right = std::min(x + uv.right, static_cast<float>(outer.right));
            if (right > left) {
                prim->TextureCrd(uv.left + static_cast<int>(std::lround(left - x)), uv.top);
                prim->Vertex(left, y, 0.0f);
                prim->TextureCrd(uv.left + static_cast<int>(std::lround(right - x)), uv.top + uv.bottom);
                prim->Vertex(right, y + uv.bottom, 0.0f);
            }
            x -= uv.right * sign;
        }
        sign = -sign;
    }
    prim->End();

    SetMenuScissor({0, scissor.top + 1, mgScreenWidth - 1, scissor.bottom - 1});
    SetSpriteEnv(prim, MENU_SPRITE_ENV_ADD);
    prim->Begin(MG_PRIM_TRIANGLE_FAN);
    // Initialize clears the builder descriptor. Retail retains TEX0/RGBAQ in the GS;
    // explicitly bind both again for the rotated bands on the host.
    prim->Texture(texture);
    prim->Color(red, green, blue, alpha);
    const int vertical_count = static_cast<int>(3.0f + rect.bottom / uv.right);
    for (int edge = 0; edge < 2; ++edge) {
        const float x = edge == 0 ? outer.left - 5 : outer.right - 8;
        float       y = (edge == 0 ? outer.top - 13 : outer.bottom) + PortMenuWakuPosition[1] * sign;
        for (int tile = 0; tile < vertical_count; ++tile) {
            prim->TextureCrd(uv.left, uv.top + uv.bottom);
            prim->Vertex(x, y, 0.0f);
            prim->TextureCrd(uv.left, uv.top);
            prim->Vertex(x + uv.bottom, y, 0.0f);
            prim->TextureCrd(uv.left + uv.right, uv.top);
            prim->Vertex(x + uv.bottom, y + uv.right, 0.0f);
            prim->TextureCrd(uv.left + uv.right, uv.top + uv.bottom);
            prim->Vertex(x, y + uv.right, 0.0f);
            prim->Flush();
            y += uv.right * sign;
        }
        sign = -sign;
    }
    prim->End();
    ResetMenuScissor();
}

int MenuCapture(int block, mgCMemory *stack, int draw) {
    stack->Align64();
    u8       *dst = stack->stack_bytes + (stack->stack_used << 4);
    const int half_w = mgScreenWidth >> 1;
    const int half_h = mgScreenHeight >> 1;
    MenuBGTextureBlock = block;

    static char frame_name[] = "menuwork2";
    mgTexManager.DeleteBlock(block);
    MenuFrameTex = mgTexManager.EnterTexture(block, frame_name, nullptr, (half_w + 63) / 64 * 64, (half_h + 63) / 64 * 64,
                                             32, nullptr, 0, 0);

    if (MenuFrameTex != nullptr) {
        MenuFrameTex->tex0.bits.tcc = 0;
        MenuFrameTex->image[0] = reinterpret_cast<u_long128 *>(dst);
        stack->Alloc(half_w * half_h * 4 / 16 + 1);
    }

    // The grab costs a frame on PS2 too: the tick that just ended is gfx::kPreviousFrame in the next one.
    mgEndFrame(nullptr);
    mgBeginFrame(nullptr);

    const gfx::TextureHandle source = menuworld::TakeMenuGrab();
    if (MenuFrameTex != nullptr) {
        // Frame target: the window's sides past the logical frame are copied in and carried by the full-frame draw.
        const gfx::TextureHandle target = mgPortRenderTarget(MenuFrameTex, true);
        // Registered before the copy: until a target exists under its TBP0 the texture binds its stack image.
        // Linear at 2:1 samples each 2x2 block's midpoint, which is the box filter retail ran on the CPU.
        gfx::BlitTexture(source, gfx::Rect{.x = 0, .y = 0, .w = mgScreenWidth, .h = mgScreenHeight}, target,
                         gfx::Rect{.x = 0, .y = 0, .w = half_w, .h = half_h}, gfx::Filter::Linear);
    }

    if (draw != 0 && MenuFrameTex != nullptr) {
        mgTexManager.ReloadTexture(block, static_cast<sceVif1Packet *>(nullptr));
        auto *prim = GetMenuPrim();
        prim->Initialize(nullptr, nullptr);
        prim->TextureMapEnable(1);
        prim->Bilinear(1);
        prim->AlphaTestEnable(0);
        prim->DepthTestEnable(0);
        prim->ZMask(MG_Z_MASK_MASKED);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(MenuFrameTex);
        prim->Color(0x80, 0x80, 0x80, 0x80);
        prim->TextureCrd(0, 0);
        prim->Vertex(0, 0, 0);
        prim->TextureCrd(half_w, half_h);
        prim->Vertex(mgScreenWidth, mgScreenHeight, 0);
        prim->End();
    }

    return true;
}

// Move by whole tiles so integer sprite coordinates cover the visible leading edge.
float MenuTilePatternFirst(float phase, int size, float minimum) {
    if (size <= 0) {
        return phase;
    }
    return phase - std::ceil((phase - minimum) / size) * size;
}

// Count of grid positions first, first + size, ... that do not pass limit.
int MenuTilePatternCount(float first, int size, float limit) {
    if (size <= 0) {
        return 0;
    }
    int count = 0;
    for (float pos = first; pos <= limit; pos += static_cast<float>(size)) {
        ++count;
    }
    return count;
}

void DrawMenuTilePattern(mgCDrawPrim *prim, mgCTexture *tex, float x, float y, mgRect<int> tex_rect,
                         int /*unused*/, u8 *rgba) {
    if (tex_rect.right <= 0 || tex_rect.bottom <= 0) {
        return;
    }

    const auto extent = mgPortVisibleExtent();
    // One logical pixel protects negative fractional origins from truncation toward zero.
    const float column_first = MenuTilePatternFirst(x, tex_rect.right, std::floor(extent.left) - 1.0f);
    const float row_first = MenuTilePatternFirst(y - tex_rect.bottom, tex_rect.bottom, std::floor(extent.top) - 1.0f);
    const int   column_count = MenuTilePatternCount(column_first, tex_rect.right, std::ceil(extent.right));
    const int   row_count = MenuTilePatternCount(row_first, tex_rect.bottom, std::ceil(extent.bottom));

    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(tex);

    if (rgba != nullptr) {
        prim->Color(rgba[0], rgba[1], rgba[2], rgba[3]);
    } else {
        prim->Color(0x80, 0x80, 0x80, 0x80);
    }

    mgRect<int> dest(0, 0, 0, 0);
    for (int column = 0; column < column_count; ++column) {
        dest.Set(static_cast<int>(column_first + static_cast<float>(column * tex_rect.right)), static_cast<int>(row_first),
                 tex_rect.right, tex_rect.bottom);

        for (int row = 0; row < row_count; ++row) {
            PrimQuad(prim, dest, tex_rect);
            dest.top += dest.bottom;
        }
    }

    prim->End();
}

namespace {

// Retail's parked positions can leave a pixel or two inside its screen: the character page's
// backdrop rests at x=-512 with a 513-wide image.
constexpr float kParkedOverlap = 2.0f;

// Width of the invention card rows MenuInventCreateCardDraw draws from the form's place
// (inventmn.cpp:5657).
constexpr float kInventCardWidth = 231.0f;

// How far left of a message window's put position or laid-out pen its draws reach, by
// DrawMesWin (nd_meswin.cpp:4379-4594) for the window modes MessageLeft reads:
// - a frame's right corner pieces are 23 wide (DrawVersatileWin_1/3/4, drawwin.cpp:216, 278,
//   314), so they start left of the frame only when it is under 46 wide, scaled about its centre
//   by its fade (CalcRectScale, nd_meswin.cpp:3651). Its shadow and the push button
//   (DrawPushButton, nd_meswin.cpp:4269-4271, 40 left of the frame's right edge) lie right of
//   its left edge then too.
constexpr int kFrameCorner = 23;
// - a floating window's tail is 13 left of its frame (MyMenuFloatingWinDraw, drawwin.cpp:200-202);
//   its other tails start at or right of the frame's left edge, less 10, and its corners are 7.
constexpr int kFloatingTail = 13;
// - a character is drawn from its pen (DrawFont, nd_meswin.cpp:3830-3962): gaiji 0xFD21 starts 6
//   left of it (DrawGaiji_sub, font.cpp:1181, 1197); retail outlines reach 2 and the sharp
//   font's widest rim 2.5 (set2DSprite_Fuchi, DrawSharpFuchi in port/src/object/menu/font.cpp).
constexpr int kGlyphReach = 6;
// - the choice cursor's goal is 40 and half a character left of the text (ClsMes::SetGoalCursorXY,
//   nd_meswin.cpp:3984), and it sways 6 more (ClsMes::DrawSelectCursor, nd_meswin.cpp:4075); its
//   shadow is 5 right of it.
constexpr int kCursorLead = 40;
constexpr int kCursorSway = 6;
// DrawMsg moves a hidden cursor here before it steps (menucls1.cpp:870-874).
constexpr int kHiddenCursor = -1000;

// What a form draws over on one axis, in screen units; unbounded where it is not known.
struct MenuSpan {
    float low = -std::numeric_limits<float>::infinity();
    float high = std::numeric_limits<float>::infinity();
};

// The message window of the message form being drawn, which CDC2Mes::DrawMsg classifies once
// StepMsg has laid it out and SetPutPos has put it.
const CDC2Mes *form_message = nullptr;

// Whether the current target shows past retail's screen sideways or vertically. Menu sprites are
// drawn in UI units, which video.ui_scale scales, but depth-tested fills (SetSpriteEnv's
// MENU_SPRITE_ENV_COLOR) in the target's logical units, so either can show past it.
bool ShowsPastScreen(bool &wide, bool &tall) {
    const auto target = mgPortCurrentTarget();
    wide = false;
    tall = false;
    for (const auto &extent : {mgPortVisibleExtent(target), mgPortVisibleUiExtent(target)}) {
        wide = wide || extent.left < 0 || extent.right > mgScreenWidth;
        tall = tall || extent.top < 0 || extent.bottom > mgScreenHeight;
    }
    return wide || tall;
}

// A part form's spans relative to its position. A part that covers the screen may be a
// compositor without panel bounds, so full_screen asks for its drawing and side effects to run.
bool PartsSpans(const CMenuPosDataForm &form, MenuSpan &xs, MenuSpan &ys, bool &full_screen) {
    float left = std::numeric_limits<float>::infinity();
    float right = -left;
    float top = left;
    float bottom = -left;
    for (int i = 0; i < form.parts_num; ++i) {
        const auto &part = form.parts[i];
        if (!part.active || !part.draw_flag || part.dtype == MENUFORMPARTS_DTYPE_FUNCINFO) {
            continue;
        }
        full_screen = full_screen || (part.w >= mgScreenWidth && part.h >= mgScreenHeight);
        float x0 = part.x;
        float x1 = part.x + part.w;
        float y0 = part.y;
        float y1 = part.y + part.h;
        switch (part.dtype) {
            case MENUFORMPARTS_DTYPE_NORMAL:
            case MENUFORMPARTS_DTYPE_SQ_BETA:
            case MENUFORMPARTS_DTYPE_TRS:
                break;
            case MENUFORMPARTS_DTYPE_NORMAL2:
                x0 += std::min(0, part.etc_info[0]);
                x1 += std::max(0, part.etc_info[0]);
                break;
            case MENUFORMPARTS_DTYPE_NUMBER1:
            case MENUFORMPARTS_DTYPE_NUMBER2: {
                if (!MenuPosData) {
                    return false;
                }
                const auto *info = MenuPosData->GetTexGetInfo(part.tex_info_no);
                if (!info) {
                    return false;
                }
                int digits = 1;
                for (int value = part.etc_info[1]; value >= 10; value /= 10) {
                    ++digits;
                }
                if (part.dtype == MENUFORMPARTS_DTYPE_NUMBER2) {
                    digits = std::max(digits, part.etc_info[0]);
                }
                // Conservative for all three alignments, including negative spacing.
                const float span = digits * std::abs(info->rect.right + part.w) + info->rect.right;
                x0 -= span;
                x1 = part.x + span;
                const float height = std::abs(info->rect.bottom) + std::abs(part.h);
                y0 = part.y - height;
                y1 = part.y + height;
                break;
            }
            default:
                return false;
        }
        // Item-icon effects use their own storage layout in DrawOneItem.
        if (part.dtype != MENUFORMPARTS_DTYPE_SQ_BETA && part.dtype != MENUFORMPARTS_DTYPE_TRS) {
            for (int effect = 0; part.effect && std::cmp_less(effect, part.effect_num); ++effect) {
                const int type = part.effect[effect].type;
                if (type != 0 && type != MENU_PARTS_EFFECT_FILLBOX && type != MENU_PARTS_EFFECT_BLINK) {
                    return false;
                }
            }
        }
        const float sway_x = part.vibe_cnt[0] ? part.viber[0] + 1.0f : 0.0f;
        const float sway_y = part.vibe_cnt[1] ? part.viber[1] + 1.0f : 0.0f;
        const float shadow = part.shadow ? std::abs(static_cast<int>(part.shadow_offset)) : 0;
        left = std::min(left, std::min(x0, x1) - sway_x - shadow);
        right = std::max(right, std::max(x0, x1) + sway_x + shadow);
        top = std::min(top, std::min(y0, y1) - sway_y - shadow);
        bottom = std::max(bottom, std::max(y0, y1) + sway_y + shadow);
    }
    if (!std::isfinite(left)) {
        return false;
    }
    xs = {.low = left, .high = right};
    ys = {.low = top, .high = bottom};
    return true;
}

// The leftmost x a menu message window draws at this frame, read from its current layout: each
// character's pen in its laid-out table already holds whatever moved it while laying out (number
// padding, spacing, indents). False where that is not bounded here.
bool MessageLeft(CDC2Mes &mes, int &left) {
    if (!mes.buff || mes.ClsMes::mes_no == -1 || mes.font_h <= 0) {
        return false;
    }
    const int mode = mes.window_mode;
    switch (mode) {
        case MES_WIN_FLOATING:
        case MES_WIN_VERSATILE_1:
        case MES_WIN_VERSATILE_3:
        case MES_WIN_VERSATILE_4:
            break;
        default:
            return false;
    }
    // A window put at a negative position sits at its default place (ClsMes::SetAbsWinData).
    if (mes.abs_win.x < 0) {
        return false;
    }
    const int width = mes.abs_win.width > 0 ? mes.abs_win.width : mes.text_w + waku_data[mode][0] + waku_data[mode][2];
    if (width < 2 * kFrameCorner) {
        return false;
    }
    left = mes.abs_win.x - (mode == MES_WIN_FLOATING ? kFloatingTail : 0);

    // DrawMesWin's text origin (nd_meswin.cpp:4521-4527) and DrawFont's place for each character.
    int dx = 0;
    int dy = 0;
    mes.CalcCenteringXY(&dx, &dy);
    const int text_x = mes.abs_win.x + (mes.abs_text_off_x >= 0 ? mes.abs_text_off_x : waku_data[mode][0]);
    for (int i = std::max(0, mes.page_top); i < std::min<int>(mes.tbl_num, MES_WIN_TBL_MAX); ++i) {
        const int line = mes.tbl[i].y / mes.font_h;
        if (line < 0 || line >= MES_LINE_MAX) {
            return false;
        }
        int x = mes.tbl[i].x;
        if (mes.line_pos_on[line]) {
            x += mes.line_pos[line][0];
        } else {
            x += text_x + dx + (mes.line_indent_on ? mes.line_indent[line] : 0);
        }
        left = std::min(left, x - kGlyphReach);
    }

    // ClsMes::StepSelectCursor (menu_mouse_message.cpp) moves the cursor halfway to its goal.
    if (mes.select >= 0) {
        int goal = text_x - kCursorLead - mes.font_w / 2 + dx;
        if (mes.line_indent_on && mes.cursor_centering) {
            int lines = 0;
            while (lines < MES_LINE_MAX && mes.line_w[lines] >= 0) {
                ++lines;
            }
            int widest = 0;
            for (int line = std::max(0, mes.select_top); line < lines; ++line) {
                widest = std::max(widest, mes.line_w[line]);
            }
            goal += (mes.text_w - widest) / 2;
        }
        const int from = mes.cursor_on ? mes.cursor_x : kHiddenCursor;
        left = std::min(left, (mes.cursor_time <= 0 ? goal : (from + goal) / 2) - kCursorSway);
    }

    // Marks at their lines' places (ClsMes::DrawEquipment, DrawCross, DrawRightDelta,
    // nd_meswin.cpp:4098-4174).
    for (int line = 0; line < MES_LINE_MAX; ++line) {
        const int at = mes.line_pos[line][0];
        if (mes.equip_on[line]) {
            left = std::min(left, at + mes.equip_x[line]);
        }
        if (mes.cross_on[line]) {
            left = std::min(left, at + mes.cross_x[line]);
        }
        if (mes.delta_on[line]) {
            left = std::min(left, at + mes.delta_x[line]);
        }
    }
    return true;
}

enum class FormPlace {
    Shown,   // overlaps retail's screen, or is not known not to
    Parked,  // outside it but for retail's sliver: drawn clipped to it
    Outside, // a part form wholly outside it: not drawn
};

FormPlace PlaceForm(const CMenuPosDataForm &form) {
    bool     wide = false;
    bool     tall = false;
    bool     full_screen = false;
    MenuSpan xs;
    MenuSpan ys;
    if (!ShowsPastScreen(wide, tall)) {
        return FormPlace::Shown;
    }
    switch (form.dtype) {
        case MENUFORM_DTYPE_NORMAL:
        case MENUFORM_DTYPE_LIST:
            if (!PartsSpans(form, xs, ys, full_screen)) {
                return FormPlace::Shown;
            }
            break;
        case MENUFORM_DTYPE_INV_CARD:
            xs = {.low = 0.0f, .high = kInventCardWidth};
            full_screen = true;
            break;
        default:
            return FormPlace::Shown;
    }
    // MenuFormDraw's sway of the whole form.
    const float sway_x = form.vibe_cnt[0] ? 10.0f : 0.0f;
    const float sway_y = form.vibe_cnt[1] ? 8.0f : 0.0f;
    const int   x = fptosi(form.x);
    const int   y = fptosi(form.y);
    xs = {.low = x + xs.low - sway_x, .high = x + xs.high + sway_x};
    ys = {.low = y + ys.low - sway_y, .high = y + ys.high + sway_y};
    const auto beyond = [](const MenuSpan &span, int size, float overlap) {
        return span.high <= overlap || span.low >= size - overlap;
    };
    if (!(wide && beyond(xs, mgScreenWidth, kParkedOverlap)) && !(tall && beyond(ys, mgScreenHeight, kParkedOverlap))) {
        return FormPlace::Shown;
    }
    return wide && !full_screen && beyond(xs, mgScreenWidth, 0.0f) ? FormPlace::Outside : FormPlace::Parked;
}

} // namespace

bool MenuFormParked(const CMenuPosDataForm &form) {
    return PlaceForm(form) != FormPlace::Shown;
}

bool MenuMessageParked(CDC2Mes &mes) {
    bool wide = false;
    bool tall = false;
    int  left = 0;
    if (!ShowsPastScreen(wide, tall) || !wide || !MessageLeft(mes, left)) {
        return false;
    }
    // Each draw adds the window's drawing offset and rounds toward zero.
    return left + mes.draw_off_x - 1.0f >= mgScreenWidth - kParkedOverlap;
}

bool MenuFormDrawsMessage(const CDC2Mes &mes) {
    return form_message == &mes;
}

void MenuAlignCharacterSlot(CMenuPosDataForm &form) {
    if (form.name == nullptr || std::strcmp(form.name, "chr_bg") != 0) {
        return;
    }
    auto *backing = form.GetPartInfo(const_cast<char *>("fcb1"));
    auto *portrait = form.GetPartInfo(const_cast<char *>("fc1"));
    auto *upper_backing = form.GetPartInfo(const_cast<char *>("fcb0"));
    if (backing != nullptr && portrait != nullptr && upper_backing != nullptr &&
        backing->y == 158.0f && backing->h == 100.0f && portrait->y == 181.0f && upper_backing->h == 121.0f) {
        backing->y = portrait->y;
        backing->h = upper_backing->h;
    }
}

void CMenuPosDataForm::MenuFormDraw(int &state) {
    if (MenuCommonInfo != nullptr && MenuCommonInfo->now_mode == MENU_MODE_CHARA_CHANGE) {
        MenuAlignCharacterSlot(*this);
    }
    // Retail parks unused panels outside its screen (SPECHECK at x=-260, the item description at
    // x=570, the invention card list at x=-262), which a wider window would show at its sides. A
    // part form wholly outside it is hidden; one with retail's sliver inside, the card list and a
    // parked message window (CDC2Mes::DrawMsg) draw clipped to it. A form that overlaps the
    // screen draws whole, so slides still cross the sides.
    const FormPlace place = PlaceForm(*this);
    if (place == FormPlace::Outside || menuworld::HidesForm(*this)) {
        return;
    }
    // An item the mouse carries is drawn at the pointer, unmoved by the spread panels.
    float held_x = 0.0f;
    float held_y = 0.0f;
    if (menuworld::ItemBackdrop() && this == MenuCommonInfo->cursor_form && MenuMouseHeldItemAt(held_x, held_y)) {
        float tip_x = 0.0f;
        float tip_y = 0.0f;
        GetPutPosXY(const_cast<char *>("cursor0"), tip_x, tip_y);
        const gfx::UiAnchorScope unanchored(gfx::UiAnchor{});
        int                      draw_x = fptosi(x + held_x - 26.0f - tip_x);
        int                      draw_y = fptosi(y + held_y - 14.0f - tip_y);
        MenuFormDraw(draw_x, draw_y, state);
        return;
    }
    // The cursor and its frame take the cursor's shift, which eases across the spread, so they never change sides
    // apart and jump.
    if (menuworld::CursorForm(*this)) {
        if (!menuworld::CursorShown()) {
            return;
        }
        const menuworld::CursorDrawScope drawing;
        const gfx::UiAnchorScope         unanchored(gfx::UiAnchor{});
        MenuFormDraw(fptosi(x + menuworld::CursorFrameShift()), fptosi(y), state);
        return;
    }
    std::optional<gfx::UiAnchorScope> anchor;
    if (const auto spread = menuworld::FormAnchor(*this)) {
        anchor.emplace(*spread);
    }
    const mgPortScreenClipScope clip(place == FormPlace::Parked);
    const CDC2Mes *const        saved_message = form_message;
    form_message = dtype == MENUFORM_DTYPE_MSGFORM && sub_no < std::size(MenuDCMsg) ? MenuDCMsg[sub_no] : nullptr;
    int draw_x = fptosi(x);
    int draw_y = fptosi(y);
    {
        const menuworld::CharacterFadeScope fade(*this);
        MenuFormDraw(draw_x, draw_y, state);
    }
    form_message = saved_message;
}

namespace {

// The logical frame's centre, which the window's centre maps to for the unanchored Item title.
constexpr int kItemTitleCentreX = 320;
// Retail's icon move mode for the selected icon, which the Item title follows.
constexpr int kSelectedIconMove = 2;
// Logical x of the title's text centre from the plate's left edge, in the plate's 112-wide layout. The text sits right
// of the plate's centre, so the plate's width does not give its centre.
constexpr int kItemTitleTextCentreX = 90;

// Retargets the Item title's plate so its text is centred on the frame, keeping the height retail moves it to.
void CentreItemTitle(CMenuPosDataForm &title) {
    if (title.GetPartInfo(const_cast<char *>("mi0")) == nullptr) {
        return;
    }
    int target[2] = {kItemTitleCentreX - kItemTitleTextCentreX, title.next_y};
    title.SetNextMovePos(target, MENUFORM_MTYPE_I);
}

} // namespace

// Retail moves the icons toward their resting places; the Item page keeps its title centred while it is open.
int CMenuPosDataManage::StepMainMenuIconMove(int *icons, int select, int mode) {
    const int arrived = MoveMainMenuIconsCore(icons, select, mode);
    if (select == MENU_MODE_ITEM && mode == kSelectedIconMove && menuworld::ItemBackdrop()) {
        if (CMenuPosDataForm *title = GetFormInfo(dc2::menu::MainIconName(MENU_MODE_ITEM).data()); title != nullptr) {
            CentreItemTitle(*title);
        }
    }
    return arrived;
}

void MenuCursorDraw(mgCTexture *texture, float *position, float rotation,
                    int reverse, int alpha, float scale) {
    if (!texture) {
        return;
    }
    const auto hand_key = MenuMouseNoteHand(mgPortBinding(texture),
                                            {.x = static_cast<float>(menu_long_hand.left), .y = static_cast<float>(menu_long_hand.top), .w = static_cast<float>(menu_long_hand.right), .h = static_cast<float>(menu_long_hand.bottom)},
                                            rotation, alpha, scale);
    // The canonical image retains the selection hand. A displayed mouse pointer
    // replaces this tagged group without changing screenshots or grab textures.
    gfx::Interp2DScope tag({.key = hand_key, .generation = static_cast<uint64_t>(mgPortFrameCount())});
    auto              *prim = GetMenuPrim();
    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Bilinear(1);
    prim->Begin(MG_PRIM_TRIANGLE_STRIP);
    prim->Texture(texture);
    prim->Color(128, 128, 128, alpha);
    const float c = std::cos(rotation);
    const float s = std::sin(rotation);
    // The Item page's hand always points the same way, whichever side of the spread it is on.
    const bool mirrored = reverse != 0 && !menuworld::ItemBackdrop();
    for (int i = 0; i < 4; ++i) {
        const float x = (i & 1 ? 40 : 0) * scale * (mirrored ? -1 : 1);
        const float y = (i & 2 ? 24 : 0) * scale;
        prim->TextureCrd(menu_long_hand.left + (i & 1 ? menu_long_hand.right : 0),
                         menu_long_hand.top + (i & 2 ? menu_long_hand.bottom : 0));
        const float px = i == 0 ? 3.0f + position[0] : 3.0f + (position[0] + (x * c - y * s));
        const float py = i == 0 ? 3.0f + position[1] : i & 1 ? position[1] + (x * s + y * c)
                                                             : 3.0f + (position[1] + (x * s + y * c));
        prim->Vertex(px, py, 0.0f);
    }
    prim->End();
}

namespace {
/**
 * Selects the repair model by its actual bundle or ordinary asset-directory filename.
 */
std::optional<std::filesystem::path> RepairModelPath(const void *data) {
    const auto path = DataReadBufferPath(data);
    if (path && std::filesystem::path(*path).extension() == ".gltf") {
        return std::filesystem::path(*path).replace_extension(".assets") / "repair_powder.gltf";
    }
    if (const auto directory = AssetDirectoryPath(data)) {
        return std::filesystem::path(*directory) / "repair_powder.gltf";
    }
    return std::nullopt;
}

/**
 * Enters the repair sprites from an embedded native set or an ordinary texture document.
 */
bool EnterRepairTexture(const void *data, int block) {
    const auto path = DataReadBufferPath(data);
    if (!path) {
        return false;
    }
    dc2::text::Copy(mgTexManager.name_suffix, dc2::text::View("_2"));
    bool loaded = false;
    if (std::filesystem::path(*path).extension() == ".gltf") {
        std::string error;
        loaded = texture_bundle::Enter(*path, "menueff0", mgTexManager, block, nullptr, error);
        if (!loaded) {
            CT_LOG_ERROR(Data, "repair texture: {}", error);
        }
    } else if (const auto *texture = AssetDirectoryRead(data, "repair_powder2d.json", nullptr)) {
        if (const auto texture_path = DataReadBufferPath(texture)) {
            MgTextureEnterDocument(&mgTexManager, *texture_path, block, nullptr, nullptr);
        }
        char texture_name[] = "menueff0";
        loaded = mgTexManager.GetTexture(texture_name, block) != nullptr;
    }
    mgTexManager.name_suffix[0] = 0;
    return loaded;
}
} // namespace

void CRepairManager::CheckDataBG(int block) {
    if (data_ready) {
        return;
    }
    mgTexManager.DeleteBlock(block);
    tex_block = static_cast<s16>(block);
    tex = nullptr;
    if (!EnterRepairTexture(data, block)) {
        bg_load = false;
        return;
    }
    char texture_name[] = "menueff0_2";
    tex = mgTexManager.GetTexture(texture_name, -1);
    data_ready = tex != nullptr;
    bg_load = false;
}

void CRepairManager::SetRepairData(mgCMemory *memory, int block, unsigned int *pack) {
    if (!memory) {
        return;
    }
    tex_block = static_cast<s16>(block);
    data = pack;
    tex = nullptr;
    data_ready = false;
    bg_load = false;
    keep = false;
    if (!EnterRepairTexture(data, block)) {
        return;
    }
    char texture_name[] = "menueff0_2";
    tex = mgTexManager.GetTexture(texture_name, -1);
    data_ready = tex != nullptr;
    if (data_ready) {
        SetStack(memory, 1);
        keep = true;
    }
}

void CRepairManager::GeneratePoly(float *position, int block) {
    const auto path = RepairModelPath(data);
    if (!path || !position || !dc2::memory::ArenaStorageLive(model_stack)) {
        return;
    }
    if (model) {
        model_assets::DeleteCharacterTextures(*model, 0, CHARA_IMAGE_MAX - 1);
    }
    model = nullptr;
    model_stack.stClearUsed();
    model_stack.stSetLocked(false);
    auto *character = dc2::memory::NewObject<CActionChara>(model_stack);
    if (character == nullptr) {
        return;
    }
    model_assets::DeleteCharacterTextures(*character, 0, CHARA_IMAGE_MAX - 1);
    character->Initialize(nullptr);
    model_assets::CharacterLoadOptions options{.model_memory = &model_stack, .motion_memory = &model_stack, .image_memory = &model_stack, .textures = &mgTexManager, .parent = nullptr, .texture_block = block};
    std::string                        error;
    if (!model_assets::LoadCharacter(*character, *path, "info", options, error)) {
        model_assets::DeleteCharacterTextures(*character, 0, CHARA_IMAGE_MAX - 1);
        model_stack.stClearUsed();
        model_stack.stSetLocked(false);
        CT_LOG_ERROR(Data, "repair model: {}", error);
        return;
    }
    model = character;
    model->SetScale(0.4f, 0.4f, 0.4f);
    model->SetPosition(position);
    model->SetMotion(const_cast<char *>("\x94\xad\x93\xae"), 0, 1);
    model->SetFadeFlag(1);
    model->Show(0, 1);
    auto *frame = model->CObjectFrame::frame;
    if (frame && frame->attr) {
        frame->attr->z_test = MG_DEPTH_TEST_ALWAYS;
        frame->SetAttrParam(*frame->attr, 1, MG_FRAME_ATTR_Z_TEST);
    }
    model->Show(1, 1);
    model_counter = 0;
}
