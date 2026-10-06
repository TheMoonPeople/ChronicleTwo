#pragma once

#include "common.h"

#include <cstring>

#include "font.hpp"
#include "mg_tanime.hpp"

/**
 * @file
 * Declares the message window: the class that lays a message's text out
 * character by character, reveals it over time, pages and scrolls it, and
 * draws it inside a speech bubble or one of the menu frames; plus the
 * helpers it draws and places itself with and the movie caption player.
 */

class CCharacter2;
class mgCDrawPrim;

/**
 *
 * Sizes of the message window's tables.
 *
 */
enum {
    MES_WIN_TBL_MAX = 450,  /**< Characters one message window can lay out. */
    MES_LINE_MAX = 20,      /**< Lines one message window keeps per-line settings for. */
    MES_PAGE_MAX = 16,      /**< Pages one message window counts characters for. */
    MES_NAME_MAX = 16,      /**< Strings a message can insert into its text. */
    MES_NAME_LEN = 50,      /**< Bytes of one inserted string. */
    MES_VALUE_MAX = 16,     /**< Numbers a message can insert into its text. */
    MES_ITEM_MAX = 16,      /**< System messages a message can insert into its text. */
    NAME_REGIST_MAX = 8,    /**< Rows of NameRegistTbl. */
    NAME_REGIST_LEN = 11,   /**< Characters of one NameRegistTbl row. */
    NAME_REGIST_USED = 6,   /**< Rows of NameRegistTbl SetAndGetNameRegistTbl hands out. */
    NPC_NAME_CHARA_TOP = 8, /**< First scene character slot ClsMes::StepNpcName shows a name for. */
    NPC_NAME_CHARA_NUM = 56, /**< Scene character slots ClsMes::StepNpcName looks at. */
    MOVIE_CC_MAX = 20,      /**< Captions one movie can show. */
    MOVIE_CC_LEN = 350,     /**< Bytes of one movie caption. */
    WAKU_DATA_MAX = 9,      /**< Rows of waku_data. */
};

/**
 *
 * Phases of a message window, as ClsMes::State reports them.
 *
 */
enum ClsMesState {
    CLSMES_CLOSED = 0,      /**< Fully faded out. */
    CLSMES_OPENING = 1,     /**< Fading in. */
    CLSMES_REVEALING = 2,   /**< Revealing the text. */
    CLSMES_SHOWN = 3,       /**< All text of the message shown. */
    CLSMES_CLOSING = 4,     /**< Fading out. */
    CLSMES_PAGE_WAIT = 5,   /**< Waiting at a page break. */
    CLSMES_SCROLLING = 6,   /**< Waiting for the text to scroll into place. */
};

/**
 *
 * Frames a message window draws around its text, as ClsMes::window_mode holds them.
 *
 */
enum MesWindowMode {
    MES_WIN_NONE = 0,          /**< No frame. */
    MES_WIN_FUKIDASHI = 1,     /**< Speech bubble with a tail pointing at the speaker. */
    MES_WIN_HELP = 2,          /**< Help window; ClsMes::SetWindowMode turns it into MES_WIN_VERSATILE_1. */
    MES_WIN_FLOATING = 3,      /**< Floating menu window with a shadow. */
    MES_WIN_VERSATILE_1 = 4,   /**< Plain menu window. */
    MES_WIN_YESNO = 5,         /**< Menu window with yes and no choices below the text. */
    MES_WIN_VERSATILE_3 = 6,   /**< Menu window with a band behind the selected line. */
    MES_WIN_BOTTOM = 7,        /**< No frame, placed at the bottom centre of the screen. */
    MES_WIN_VERSATILE_4 = 8,   /**< Menu window of the fourth style. */
    MES_WIN_DQ_FUKIDASHI = 9,  /**< Speech bubble at the bottom centre of the screen. */
    MES_WIN_DQ_FUKIDASHI_2 = 10, /**< The same bubble, as the closing timer sets it. */
    MES_WIN_CENTRE = 11,       /**< No frame, placed at the centre of the screen. */
    MES_WIN_PLAIN = 12,        /**< No frame; ClsMes::SetWindowMode stores it as MES_WIN_NONE. */
};

/**
 *
 * Settings ClsMes::Preset applies.
 *
 */
enum MesPreset {
    MES_PRESET_FUKIDASHI = 0,       /**< Speech bubble revealing at the language's speed. */
    MES_PRESET_SYSTEM = 1,          /**< No frame, shown at once. */
    MES_PRESET_PLAIN = 2,           /**< No frame, shown at once, placed freely. */
    MES_PRESET_NPC_NAME = 3,        /**< Names over the characters on screen. */
    MES_PRESET_WINDOW = 4,          /**< Plain menu window, shown at once. */
    MES_PRESET_SMALL_FUKIDASHI = 5, /**< Small-font speech bubble with a slow fade. */
    MES_PRESET_WINDOW_REVEAL = 6,   /**< Plain menu window revealing one character a frame. */
};

/**
 *
 * Control codes in a message's 16-bit text.
 *
 */
enum MesCode {
    MES_CODE_COLOR_A = 0xF200,         /**< Sets the alpha of the text colour to the low byte. */
    MES_CODE_COLOR_B = 0xF300,         /**< Sets the blue of the text colour to the low byte. */
    MES_CODE_COLOR_G = 0xF400,         /**< Sets the green of the text colour to the low byte. */
    MES_CODE_COLOR_R = 0xF500,         /**< Sets the red of the text colour to the low byte. */
    MES_CODE_JUSTIFY = 0xF700,         /**< Justifies the line to four times the low byte. */
    MES_CODE_SPACE_W = 0xF800,         /**< Sets the width of a space to the low byte. */
    MES_CODE_MOVE_X = 0xF900,          /**< Moves the next character right by the low byte. */
    MES_CODE_ITEM_LAST = 0xFBE7,       /**< Inserts the system message of ClsMes::item_mes[15]. */
    MES_CODE_ITEM_FIRST = 0xFBFE,      /**< Inserts the system message of ClsMes::item_mes[0]. */
    MES_CODE_COLOR_DEFAULT = 0xFC00,   /**< Returns to the default text colour. */
    MES_CODE_COLOR_HIGHLIGHT = 0xFC01, /**< Switches to the highlight text colour. */
    MES_CODE_GAIJI = 0xFD00,           /**< First of the external characters, up to 0xFD31. */
    MES_CODE_WAIT = 0xFE00,            /**< Waits the low byte of frames after the previous character. */
    MES_CODE_NEWLINE = 0xFF00,         /**< Starts a new line. */
    MES_CODE_END = 0xFF01,             /**< Ends the message. */
    MES_CODE_SPACE = 0xFF02,           /**< Inserts a space. */
    MES_CODE_PAGE = 0xFF03,            /**< Waits for the next page. */
    MES_CODE_VOICE_1 = 0xFF04,         /**< Reveals with the first alternative voice sound. */
    MES_CODE_VOICE_0 = 0xFF05,         /**< Reveals with the default voice sound. */
    MES_CODE_VOICE_2 = 0xFF06,         /**< Reveals with the second alternative voice sound. */
};

/**
 *
 * Shades a line of a message window draws in, as ClsMes::GetGyouAlpha gives them.
 *
 */
enum MesLineShade {
    MES_SHADE_AUTO = -1,  /**< Shade follows the selected line. */
    MES_SHADE_NORMAL = 0, /**< Text colour as laid out. */
    MES_SHADE_DARK = 1,   /**< Colour halved. */
    MES_SHADE_BRIGHT = 2, /**< Alpha raised to full. */
    MES_SHADE_FAINT = 3,  /**< Black at a quarter alpha. */
    MES_SHADE_HIDDEN = 4, /**< Not drawn. */
};

/**
 *
 * How the selected line shades the lines whose shade is MES_SHADE_AUTO, as
 * ClsMes::select_shade holds it.
 *
 */
enum MesSelectShade {
    MES_SELECT_SHADE_NONE = -1,  /**< Selection shades no line. */
    MES_SELECT_SHADE_DARK = 0,   /**< The other lines draw MES_SHADE_DARK. */
    MES_SELECT_SHADE_BRIGHT = 1, /**< The selected line draws MES_SHADE_BRIGHT. */
    MES_SELECT_SHADE_FAINT = 2,  /**< The other lines draw MES_SHADE_FAINT. */
};

/**
 *
 * Drawing setups MySetPrim initialises a primitive builder for.
 *
 */
enum MesPrimSetup {
    MES_PRIM_SPRITE = 1,     /**< Flat textured sprites with alpha testing. */
    MES_PRIM_SHADED = 3,     /**< Gouraud-shaded textured primitives. */
    MES_PRIM_SHADED_2 = 4,   /**< The same setup as MES_PRIM_SHADED. */
    MES_PRIM_UNTEXTURED = 7, /**< Untextured antialiased primitives. */
};

/**
 *
 * Layers ClsMes::DrawFukidashi draws the speech bubble in.
 *
 */
enum MesFukidashiLayer {
    MES_FUKIDASHI_OUTLINE = 1, /**< Dark copy drawn offset behind the bubble as its outline. */
    MES_FUKIDASHI_BODY = 3,    /**< The bubble itself, shaded light grey. */
};

/**
 *
 * Packed RGBA colours the message window's text starts in.
 *
 */
enum MesTextColor {
    MES_COLOR_DARK = 0x80202020, /**< Dark grey, for text in speech bubbles. */
    MES_COLOR_GREY = 0x80686A6B, /**< Light grey, for text in menu frames. */
};

/**
 *
 * One laid-out character of a message window.
 *
 */
struct MES_WIN_TBL {
    u16 code;  /**< Font number of the character, or the MesCode it stands for. */
    s16 x;     /**< Distance of the character from the left of the text. */
    s16 y;     /**< Distance of the character from the top of the text. */
    u32 color; /**< Packed RGBA colour the character draws with. */
    u8 wait;   /**< Frames revealing pauses for after the character. */
};

STATIC_ASSERT(sizeof(MES_WIN_TBL) == 0x10);

/**
 *
 * Message window that lays a message out, reveals it over time and draws it
 * in a speech bubble or a menu frame.
 *
 */
class ClsMes : public CFont {
public:
    s32 fuchi;                               /**< Outline style the text draws with, passed to CFont::SetFuchi. */
    s32 npc_name_mode;                       /**< Non-zero to show the names of the characters on screen. */
    s32 text_x;                              /**< Distance of the text from the left of the screen. */
    s32 text_y;                              /**< Distance of the text from the top of the screen. */
    s32 font_w;                              /**< Width of one full-width character. */
    s32 font_h;                              /**< Height of one line. */
    float half_font_w_percent;                 /**< Width of a half-width character as a fraction of font_w. */
    s32 columns;                             /**< Characters the window is laid out for per line. */
    s32 rows;                                /**< Lines the window is laid out for. */
    s32 char_num;                            /**< Characters of the laid-out message. */
    s32 text_w;                              /**< Width of the laid-out text. */
    s32 text_h;                              /**< Height of the laid-out text. */
    s32 page;                                /**< Page being shown. */
    s32 page_num;                            /**< Pages of the laid-out message. */
    s32 page_chars[MES_PAGE_MAX];            /**< Characters on each page. */
    s32 last_x;                              /**< Screen x of the last character drawn. */
    s32 last_y;                              /**< Screen y of the last character drawn. */
    s32 window_mode;                         /**< Frame drawn around the text, a MesWindowMode. */
    s32 bg_opaque;                           /**< Non-zero to fill the frame opaquely. */
    s32 fukidashi_centre_x;                  /**< Screen x of the bubble's centre; negative when not placed. */
    s32 fukidashi_centre_y;                  /**< Screen y of the bubble's centre; negative when not placed. */
    s32 fukidashi_x;                         /**< Screen x of the bubble's left edge. */
    s32 fukidashi_y;                         /**< Screen y of the bubble's top edge. */
    s32 fukidashi_w;                         /**< Width of the bubble. */
    s32 fukidashi_h;                         /**< Height of the bubble. */
    s32 fukidashi_pos;                       /**< Screen slot the bubble is forced into, counting from one; zero to choose it. */
    s32 tail_on;                             /**< Non-zero to draw the bubble's tail. */
    s32 tail_target_x;                       /**< Screen x the tail points at. */
    s32 tail_target_y;                       /**< Screen y the tail points at. */
    s32 tail_root_x;                         /**< Screen x where the tail leaves the bubble. */
    s32 tail_root_y;                         /**< Screen y where the tail leaves the bubble. */
    s32 tail_half_w;                         /**< Half the width of the tail where it leaves the bubble. */
    s32 tail_length;                         /**< Length of the tail. */
    s32 tail_left_x;                         /**< Screen x of the tail's first root corner. */
    s32 tail_left_y;                         /**< Screen y of the tail's first root corner. */
    s32 tail_right_x;                        /**< Screen x of the tail's second root corner. */
    s32 tail_right_y;                        /**< Screen y of the tail's second root corner. */
    s32 tail_tip_x;                          /**< Screen x of the tail's tip. */
    s32 tail_tip_y;                          /**< Screen y of the tail's tip. */
    float fade_speed;                          /**< Amount fade changes by each frame; zero to show at once. */
    float fade;                                /**< How far the window has faded in, from 0 to 1. */
    s32 open;                                /**< Non-zero while the window fades in, zero while it fades out. */
    RECT abs_win;                            /**< Fixed outer rectangle of the frame; a negative x or y leaves that axis free. */
    s32 abs_text_off_x;                      /**< Distance of the text from the fixed frame's left edge; negative to use waku_data. */
    s32 abs_text_off_y;                      /**< Distance of the text from the fixed frame's top edge; negative to use waku_data. */
    float draw_off_x;                          /**< Horizontal offset everything the window draws is moved by. */
    float draw_off_y;                          /**< Vertical offset everything the window draws is moved by. */
    s32 point_x;                             /**< Horizontal distance of the frame's pointer from the frame's corner. */
    s32 point_y;                             /**< Vertical distance of the frame's pointer from the frame's corner. */
    s32 unk_1c4;
    RGBAQ_TYPE win_color;                    /**< Colour the floating frame is filled with. */
    float draw_speed;                          /**< Characters revealed each frame; zero to reveal at once. */
    float draw_speed_def;                      /**< Reveal speed the window returns to. */
    s32 page_wait;                           /**< Non-zero while revealing waits at a page break. */
    s32 page_auto;                           /**< Non-zero to turn pages by themselves after page_auto_time frames. */
    s32 unk_1e0;
    s32 scroll_wait;                         /**< Non-zero while revealing waits for the text to scroll. */
    float reveal;                              /**< Characters revealed so far, with the fraction of the next. */
    s32 reveal_num;                          /**< Characters revealed so far. */
    s32 page_top;                            /**< First character of the page being shown. */
    s32 unk_1f4;
    MES_WIN_TBL tbl[MES_WIN_TBL_MAX];        /**< Laid-out characters of the message. */
    s32 tbl_num;                             /**< Entries of tbl in use. */
    s32 scroll_y;                            /**< Distance the text has scrolled by. */
    s32 scroll_goal;                         /**< Distance the text is scrolling to. */
    s32 scroll_speed;                        /**< Distance the text scrolls by each frame. */
    u32 def_color;                           /**< Packed RGBA colour the text starts in. */
    u32 color;                               /**< Packed RGBA colour of the next character laid out. */
    s32 wait;                                /**< Frames left before the next character is revealed. */
    s32 page_time;                           /**< Frames the window has been drawn since the page began. */
    s32 page_auto_time;                      /**< Frames a page shows for before turning by itself. */
    s32 mes_no;                              /**< Message the window holds; -1 for none, -2 for a string. */
    s32 unk_1e40;
    char *mes_data;                          /**< Message text loaded for the window. */
    s32 mes_data_size;                       /**< Bytes of mes_data. */
    s32 push_button;                         /**< Non-zero to draw the button prompt when the text is shown. */
    s32 centering;                           /**< Non-zero to centre the text in the window. */
    s32 line_indent_on;                      /**< Non-zero to move each line by line_indent. */
    u8 alpha;                                /**< Alpha the whole window draws with; 0x80 is fully opaque. */
    char name[MES_NAME_MAX][MES_NAME_LEN];   /**< Strings the message inserts into its text. */
    s32 item_mes[MES_ITEM_MAX];              /**< System messages the item codes insert; -1 for none. */
    s32 values[MES_VALUE_MAX];               /**< Numbers the value codes insert. */
    s32 value_width[MES_VALUE_MAX];          /**< Digits each number in values is padded to. */
    s32 value;                               /**< Number the single value code inserts. */
    s32 value_sign;                          /**< Non-zero to write a plus sign before positive numbers. */
    s32 value_zero;                          /**< Non-zero to write numbers that are zero. */
    s32 value_half;                          /**< Non-zero to write numbers in half-width digits. */
    s32 value_space;                         /**< Extra distance between the digits of a number. */
    s32 digit_font;                          /**< Non-zero to draw digits with the digit texture. */
    s32 space_w;                             /**< Width of a space in the line being laid out; negative for the normal width. */
    s32 justify_w;                           /**< Width the line being laid out is justified to; negative for none. */
    s32 select;                              /**< Line the select cursor is on; -1 for none. */
    s32 goal_cursor_x;                       /**< Screen x the select cursor moves towards. */
    s32 goal_cursor_y;                       /**< Screen y the select cursor moves towards. */
    s32 cursor_x;                            /**< Screen x of the select cursor. */
    s32 cursor_y;                            /**< Screen y of the select cursor. */
    s32 select_shade;                        /**< How selection shades the lines whose shade is MES_SHADE_AUTO. */
    s32 cursor_centering;                    /**< Non-zero to move the cursor in with the centred lines. */
    s32 cursor_time;                         /**< Frames the select cursor has been moving. */
    s32 choice_pos[2][2];                    /**< Screen x and y of the yes and no choices. */
    s32 select_top;                          /**< First line that can be selected. */
    s32 cursor_off_y;                        /**< Vertical offset of the select cursor. */
    s32 voice_on;                            /**< Non-zero to play the voice sound as characters are revealed. */
    s32 voice_type;                          /**< Voice sound to play, set by the voice codes. */
    s32 voice_cnt;                           /**< Voice sounds played so far. */
    s32 close_time;                          /**< Frames left before the window closes by itself; zero for none. */
    s32 texture_block;                       /**< Texture block reloaded before the message window is drawn. */
    s32 scissor_on;                          /**< Non-zero to clip the text to scissor. */
    RECT scissor;                            /**< Screen rectangle the text is clipped to. */
    s32 line_indent[MES_LINE_MAX];           /**< Horizontal offset of each line. */
    s32 line_pos[MES_LINE_MAX][2];           /**< Screen x and y of each line placed by itself. */
    s32 line_pos_on[MES_LINE_MAX];           /**< Non-zero for each line drawn at line_pos. */
    s32 line_shade[MES_LINE_MAX];            /**< Shade of each line, a MesLineShade. */
    u32 line_color[MES_LINE_MAX];            /**< Packed RGBA colour of each line; zero to keep the laid-out colours. */
    s32 equip_on[MES_LINE_MAX];              /**< Non-zero for each line drawn with the equipment mark. */
    s32 equip_x[MES_LINE_MAX];               /**< Horizontal offset of each line's equipment mark. */
    s32 equip_y[MES_LINE_MAX];               /**< Vertical offset of each line's equipment mark. */
    s32 line_w[MES_LINE_MAX];                /**< Width of each line; negative past the last line. */
    s32 line_alpha[MES_LINE_MAX];            /**< Alpha of each line; negative to use alpha. */
    s32 cross_on[MES_LINE_MAX];              /**< Non-zero for each line drawn with the cross mark. */
    s32 cross_x[MES_LINE_MAX];               /**< Horizontal offset of each line's cross mark. */
    s32 cross_y[MES_LINE_MAX];               /**< Vertical offset of each line's cross mark. */
    s32 unk_271c[MES_LINE_MAX];
    s32 unk_276c[MES_LINE_MAX];
    s32 unk_27bc[MES_LINE_MAX];
    s32 unk_280c[MES_LINE_MAX];
    s32 delta_on[MES_LINE_MAX];              /**< Non-zero for each line drawn with the right-pointing triangle. */
    s32 delta_x[MES_LINE_MAX];               /**< Horizontal offset of each line's triangle. */
    s32 delta_y[MES_LINE_MAX];               /**< Vertical offset of each line's triangle. */
    short *buff;                             /**< Message file the window's messages are read from. */
    short *buff_system;                      /**< System message file the item codes read from. */
    s32 unk_2954;

    /**
     *
     * Draws one layer of the speech bubble and its tail, offset by @p dx
     * and @p dy, in the style @p mode asks for.
     *
     * @mangled DrawFukidashi_sub__6ClsMesFP11mgCDrawPrimiii
     * @address 0x151E50
     * @size 0x580
     */
    void DrawFukidashi_sub(mgCDrawPrim *prim, int dx, int dy, int mode);

    /**
     *
     * Sets up a primitive builder and draws one layer of the speech bubble
     * with it.
     *
     * @mangled DrawFukidashi__6ClsMesFiii
     * @address 0x1523D0
     * @size 0x110
     */
    void DrawFukidashi(int dx, int dy, int mode);

    /**
     *
     * Sets the reveal speeds to the one the language reads at.
     *
     * @mangled SetDrawSpeed__6ClsMesFv
     * @address 0x1524E0
     * @size 0x50
     */
    void SetDrawSpeed();

    /**
     *
     * Gives back the reveal speed to return to: zero when the options ask for
     * text to be shown at once, otherwise draw_speed_def.
     *
     * @mangled GetDrawSpeedDef__6ClsMesFv
     * @address 0x152530
     * @size 0x60
     */
    float GetDrawSpeedDef();

    /**
     *
     * Gives back the option that turns movie captions off.
     *
     * @mangled GetCaptionOff__6ClsMesFv
     * @address 0x152590
     * @size 0x50
     */
    int GetCaptionOff();

    /**
     *
     * Gives back whether pages turn by themselves.
     *
     * @mangled GetPageAutoFlg__6ClsMesFv
     * @address 0x1525E0
     * @size 0x10
     */
    int GetPageAutoFlg();

    /**
     *
     * Places a line at a screen position of its own; ignores lines out of range.
     *
     */
    void SetMovePosGyou(int line, int x, int y) {
        if (line >= 0 && line < MES_LINE_MAX) {
            line_pos[line][0] = x;
            line_pos[line][1] = y;
            line_pos_on[line] = 1;
        }
    }

    /**
     *
     * Gives back how wide a string of font numbers draws.
     *
     * @mangled GetStrWidth__6ClsMesFPc
     * @address 0x152690
     * @size 0x230
     */
    int GetStrWidth(char *str);

    /**
     *
     * Gives back how wide one of the inserted strings draws.
     *
     * @mangled GetStrWidth__6ClsMesFi
     * @address 0x1528C0
     * @size 0x50
     */
    int GetStrWidth(int name_no);

    /**
     *
     * Writes the screen positions of the speaker and the listener into
     * @p pos, two values each.
     *
     * @mangled AutoSetSub__6ClsMesFP11CCharacter2P11CCharacter2Pi
     * @address 0x152910
     * @size 0x50
     */
    void AutoSetSub(CCharacter2 *speaker, CCharacter2 *listener, int *pos);

    /**
     *
     * Places the text inside the speech bubble.
     *
     * @mangled CalcMesWinXYFromFukidashiXY__6ClsMesFv
     * @address 0x152A60
     * @size 0x20
     */
    void CalcMesWinXYFromFukidashiXY();

    /**
     *
     * Chooses where the speech bubble goes for the speaker and listener
     * screen positions in @p pos.
     *
     * @mangled CalcFukidashiXY__6ClsMesFPi
     * @address 0x152A80
     * @size 0x3D0
     */
    void CalcFukidashiXY(int *pos);

    /**
     *
     * Places the speech bubble and points its tail at the speaker whose
     * screen position @p pos starts with.
     *
     * @mangled AutoSet__6ClsMesFPi
     * @address 0x152E50
     * @size 0x160
     */
    void AutoSet(int *pos);

    /**
     *
     * Sets how wide a half-width character draws; a negative value sets the
     * default.
     *
     * @mangled SetHalfFontWPercent__6ClsMesFf
     * @address 0x153070
     * @size 0x30
     */
    void SetHalfFontWPercent(float percent);

    /**
     *
     * Creates an empty window that draws a speech bubble.
     *
     * @mangled __ct__6ClsMesFv
     * @address 0x1530A0
     * @size 0x420
     */
    ClsMes();

    /**
     *
     * Sets the message file the window's messages are read from.
     *
     * @mangled SetBuff__6ClsMesFPs
     * @address 0x1534C0
     * @size 0x10
     */
    void SetBuff(short *buff);

    /**
     *
     * Sets the system message file the item codes read from.
     *
     * @mangled SetBuff_system__6ClsMesFPs
     * @address 0x1534D0
     * @size 0x10
     */
    void SetBuff_system(short *buff);

    /**
     *
     * Sets the colour the text starts in.
     *
     * @mangled SetDefColor__6ClsMesFUi
     * @address 0x1534E0
     * @size 0x10
     */
    void SetDefColor(unsigned int color);

    /**
     *
     * Empties the window and applies one of the MesPreset settings.
     *
     * @mangled Preset__6ClsMesFi
     * @address 0x1534F0
     * @size 0x490
     */
    void Preset(int preset);

    /**
     *
     * Sets the frame drawn around the text, a MesWindowMode, with the colour
     * and outline that go with it.
     *
     * @mangled SetWindowMode__6ClsMesFi
     * @address 0x153980
     * @size 0x250
     */
    void SetWindowMode(int mode);

    /**
     *
     * Gives back the frame drawn around the text, a MesWindowMode.
     *
     * @mangled GetWindowMode__6ClsMesFv
     * @address 0x153BD0
     * @size 0x10
     */
    int GetWindowMode();

    /**
     *
     * Sets whether the frame is filled opaquely.
     *
     * @mangled SetWindowBgOpaqueFlg__6ClsMesFi
     * @address 0x153BE0
     * @size 0x10
     */
    void SetWindowBgOpaqueFlg(int opaque);

    /**
     *
     * Lays out the names of the characters on screen, each over its
     * character.
     *
     * @mangled StepNpcName__6ClsMesFv
     * @address 0x153BF0
     * @size 0x300
     */
    void StepNpcName();

    /**
     *
     * Advances the fade, recomputes the bubble's tail and reveals the text.
     *
     * @mangled StepNormal__6ClsMesFv
     * @address 0x153EF0
     * @size 0x310
     */
    void StepNormal();

    /**
     *
     * Advances the window by one frame: closing timer, reveal and scroll.
     *
     * @mangled Step__6ClsMesFv
     * @address 0x154200
     * @size 0x270
     */
    void Step();

    /**
     *
     * Gives back the phase the window is in, a ClsMesState.
     *
     * @mangled State__6ClsMesFv
     * @address 0x154470
     * @size 0xB0
     */
    int State();

    /**
     *
     * Moves on from a page break to the next page.
     *
     * @mangled GoNextPage__6ClsMesFv
     * @address 0x154520
     * @size 0x30
     */
    void GoNextPage();

    /**
     *
     * Reveals the next character and acts on the code it holds; gives back 1
     * at a page break, 2 at MES_CODE_END and 0 otherwise.
     *
     * @mangled MyTextureMake_sub__6ClsMesFv
     * @address 0x154550
     * @size 0x260
     */
    int MyTextureMake_sub();

    /**
     *
     * Reveals as many characters as this frame's reveal speed allows.
     *
     * @mangled MyTextureMake__6ClsMesFv
     * @address 0x1547B0
     * @size 0x230
     */
    void MyTextureMake();

    /**
     *
     * Lays out the single number value at the position in @p x and @p y,
     * moving them past it.
     *
     * @mangled MakeMesWinTbl_value__6ClsMesFPiPi
     * @address 0x154AE0
     * @size 0x330
     */
    void MakeMesWinTbl_value(int *x, int *y);

    /**
     *
     * Lays out one of the numbers in values at the position in @p x and
     * @p y, moving them past it.
     *
     * @mangled MakeMesWinTbl_value__6ClsMesFiPiPi
     * @address 0x154E10
     * @size 0x330
     */
    void MakeMesWinTbl_value(int value_no, int *x, int *y);

    /**
     *
     * Lays out a string at the position in @p x and @p y, moving them past
     * it.
     *
     * @mangled MakeMesWinTbl_str__6ClsMesFPcPiPi
     * @address 0x155140
     * @size 0xC70
     */
    void MakeMesWinTbl_str(char *str, int *x, int *y);

    /**
     *
     * Lays out one of the inserted strings at the position in @p x and
     * @p y, moving them past it.
     *
     * @mangled MakeMesWinTbl_str__6ClsMesFiPiPi
     * @address 0x155DB0
     * @size 0x20
     */
    void MakeMesWinTbl_str(int name_no, int *x, int *y);

    /**
     *
     * Lays out the system message an item code inserts at the position in
     * @p x and @p y; gives back whether @p code was an item code.
     *
     * @mangled MakeMesWinTbl_item__6ClsMesFiPiPi
     * @address 0x155DD0
     * @size 0x660
     */
    int MakeMesWinTbl_item(int code, int *x, int *y);

    /**
     *
     * Gives back how wide the widest line of one system message draws.
     *
     * @mangled GetMesWidth_system__6ClsMesFi
     * @address 0x156430
     * @size 0x2D0
     */
    int GetMesWidth_system(int mes_no);

    /**
     *
     * Gives back where one message of the message file starts.
     *
     * @mangled GetTextLineDataTop__6ClsMesFi
     * @address 0x156700
     * @size 0x70
     */
    short *GetTextLineDataTop(int mes_no);

    /**
     *
     * Gives back where one message of the system message file starts.
     *
     * @mangled GetTextLineDataTop_system__6ClsMesFi
     * @address 0x156770
     * @size 0x70
     */
    short *GetTextLineDataTop_system(int mes_no);

    /**
     *
     * Empties the table of laid-out characters and the scroll.
     *
     * @mangled InitMesWinTbl__6ClsMesFv
     * @address 0x1567E0
     * @size 0x110
     */
    void InitMesWinTbl();

    /**
     *
     * Enters one character into the table at @p x and @p y, or applies the
     * colour, voice or wait code it stands for; gives back whether a
     * character was entered.
     *
     * @mangled SetMesWinTbl__6ClsMesFiss
     * @address 0x1568F0
     * @size 0x280
     */
    int SetMesWinTbl(int code, short x, short y);

    /**
     *
     * Gives back how wide each space of a line has to draw for the line to
     * reach @p width, given characters @p font_w wide.
     *
     * @mangled CalcSpaceW__6ClsMesFiiPUs
     * @address 0x156B70
     * @size 0x2F0
     */
    int CalcSpaceW(int width, int font_w, unsigned short *text);

    /**
     *
     * Lays one message of the message file out into the table; gives back
     * whether it was laid out.
     *
     * @mangled MakeMesWinTbl__6ClsMesFi
     * @address 0x156E60
     * @size 0x760
     */
    int MakeMesWinTbl(int mes_no);

    /**
     *
     * Lays a string out into the table; gives back whether it was laid out.
     *
     * @mangled MakeMesWinTbl__6ClsMesFPc
     * @address 0x1575C0
     * @size 0x80
     */
    int MakeMesWinTbl(char *str);

    /**
     *
     * Adds @p width to the width of one line.
     *
     * @mangled AddYokoHaba__6ClsMesFii
     * @address 0x157790
     * @size 0x20
     */
    void AddYokoHaba(int line, int width);

    /**
     *
     * Sets the width of one line, unless @p width is negative.
     *
     * @mangled SetYokoHaba__6ClsMesFii
     * @address 0x1577B0
     * @size 0x20
     */
    void SetYokoHaba(int line, int width);

    /**
     *
     * Records that page @p page ends at character @p last.
     *
     * @mangled AddPage__6ClsMesFii
     * @address 0x1577D0
     * @size 0x110
     */
    void AddPage(int last, int page);

    /**
     *
     * Works out the width, height, line widths and pages one message of the
     * message file needs.
     *
     * @mangled NeedMesWinWH__6ClsMesFi
     * @address 0x1578E0
     * @size 0xB70
     */
    void NeedMesWinWH(int mes_no);

    /**
     *
     * Works out the width, height, line widths and pages a string needs.
     *
     * @mangled NeedMesWinWH__6ClsMesFPc
     * @address 0x158450
     * @size 0x10A0
     */
    void NeedMesWinWH(char *str);

    /**
     *
     * Resets the reveal, pages and voice for a new message; a non-zero
     * @p reset_fade also starts the fade from nothing.
     *
     * @mangled MakeMesWin_init__6ClsMesFi
     * @address 0x1594F0
     * @size 0x120
     */
    void MakeMesWin_init(int reset_fade);

    /**
     *
     * Opens the window on one message of the message file, unless it already
     * holds it.
     *
     * @mangled MakeMesWin__6ClsMesFi
     * @address 0x159610
     * @size 0x210
     */
    void MakeMesWin(int mes_no);

    /**
     *
     * Opens the window on a string, with @p open as the fade direction and
     * @p reset_fade as for MakeMesWin_init.
     *
     * @mangled MakeMesWin__6ClsMesFPcii
     * @address 0x159920
     * @size 0x1D0
     */
    void MakeMesWin(char *str, int open, int reset_fade);

    /**
     *
     * Opens the window on a string centred over a point of the world,
     * offset on screen by @p dx and @p dy; gives back whether it fits on
     * screen.
     *
     * @mangled MakeAnd3DPosSet__6ClsMesFPcPfii
     * @address 0x159AF0
     * @size 0x130
     */
    int MakeAnd3DPosSet(char *str, float *pos, int dx, int dy);

    /**
     *
     * Draws the shadow of the speech bubble and its tail.
     *
     * @mangled DrawFukidashiShadow__6ClsMesFv
     * @address 0x159C20
     * @size 0x210
     */
    void DrawFukidashiShadow();

    /**
     *
     * Places the yes and no choices inside the frame rectangle @p rect.
     *
     * @mangled SetSelectCursorPos__6ClsMesF4RECT
     * @address 0x159F30
     * @size 0x50
     */
    void SetSelectCursorPos(RECT rect);

    /**
     *
     * Gives back the colour one laid-out character draws with, after its
     * line's colour and shade; sets @p fuchi to whether it draws an outline.
     *
     * @mangled GetFontColor__6ClsMesFiPi
     * @address 0x15A260
     * @size 0x200
     */
    RGBAQ_TYPE GetFontColor(int index, int *fuchi);

    /**
     *
     * Gives back the shade one line draws in, a MesLineShade.
     *
     * @mangled GetGyouAlpha__6ClsMesFi
     * @address 0x15A460
     * @size 0xD0
     */
    int GetGyouAlpha(int line);

    /**
     *
     * Draws the revealed characters of the page being shown.
     *
     * @mangled DrawFont__6ClsMesFv
     * @address 0x15A530
     * @size 0x4A0
     */
    void DrawFont();

    /**
     *
     * Works out where the select cursor points at the selected line or
     * choice.
     *
     * @mangled SetGoalCursorXY__6ClsMesFv
     * @address 0x15A9D0
     * @size 0x1F0
     */
    void SetGoalCursorXY();

    /**
     *
     * Moves the select cursor halfway to its goal @p steps times.
     *
     * @mangled StepSelectCursor__6ClsMesFi
     * @address 0x15ABC0
     * @size 0x360
     */
    void StepSelectCursor(int steps);

    /**
     *
     * Draws the select cursor.
     *
     * @mangled DrawSelectCursor__6ClsMesFP11mgCDrawPrim
     * @address 0x15AF20
     * @size 0x320
     */
    void DrawSelectCursor(mgCDrawPrim *prim);

    /**
     *
     * Draws the equipment mark beside each line that asks for it.
     *
     * @mangled DrawEquipment__6ClsMesFP11mgCDrawPrim
     * @address 0x15B240
     * @size 0x1C0
     */
    void DrawEquipment(mgCDrawPrim *prim);

    /**
     *
     * Draws the cross mark beside each line that asks for it.
     *
     * @mangled DrawCross__6ClsMesFP11mgCDrawPrim
     * @address 0x15B400
     * @size 0x1C0
     */
    void DrawCross(mgCDrawPrim *prim);

    /**
     *
     * Draws the right-pointing triangle beside each line that asks for it.
     *
     * @mangled DrawRightDelta__6ClsMesFP11mgCDrawPrim
     * @address 0x15B5C0
     * @size 0x1C0
     */
    void DrawRightDelta(mgCDrawPrim *prim);

    /**
     *
     * Draws one digit from the digit texture at @p x and @p y.
     *
     * @mangled DrawDigit__6ClsMesFP11mgCDrawPrimiiiiP10RGBAQ_TYPE
     * @address 0x15B780
     * @size 0x150
     */
    void DrawDigit(mgCDrawPrim *prim, int digit, int x, int y, int alpha, RGBAQ_TYPE *color);

    /**
     *
     * Draws the prompt to press a button once the text is shown.
     *
     * @mangled DrawPushButton__6ClsMesFP11mgCDrawPrimii
     * @address 0x15B8D0
     * @size 0x310
     */
    void DrawPushButton(mgCDrawPrim *prim, int x, int y);

    /**
     *
     * Gives back the offsets that centre the text in the window.
     *
     * @mangled CalcCenteringXY__6ClsMesFPiPi
     * @address 0x15BBE0
     * @size 0x90
     */
    void CalcCenteringXY(int *dx, int *dy);

    /**
     *
     * Moves the frame rectangle @p rect to the fixed position abs_win holds.
     *
     * @mangled SetAbsWinData__6ClsMesFP4RECT
     * @address 0x15BC70
     * @size 0x60
     */
    void SetAbsWinData(RECT *rect);

    /**
     *
     * Moves the frame rectangle @p rect to the screen slot fukidashi_pos
     * asks for.
     *
     * @mangled SetOuterRectXYFromFukidashiPos__6ClsMesFP4RECT
     * @address 0x15BCD0
     * @size 0x60
     */
    void SetOuterRectXYFromFukidashiPos(RECT *rect);

    /**
     *
     * Draws the window: its frame, the text revealed so far and the marks
     * that go with them.
     *
     * @mangled DrawMesWin__6ClsMesFv
     * @address 0x15BEB0
     * @size 0xB80
     */
    void DrawMesWin();

    void SetItemMes(int index, int mes) {
        if (index >= 0 && index < MES_ITEM_MAX) {
            item_mes[index] = mes;
        }
    }

    /**
     *
     * Empties the window, as Preset does before applying its settings.
     *
     * @mangled Init__6ClsMesFv
     * @address 0x1F38E0
     * @size 0x2C0
     */
    void Init() {
        int name_offset;
        int name_count;
        int i;

        npc_name_mode = 0;
        char_num = 0;
        text_w = 0;
        text_h = 0;
        page = 0;
        page_num = 0;
        for (i = 0; i < MES_PAGE_MAX; i++) {
            page_chars[i] = 0;
        }
        last_x = 0;
        last_y = 0;
        fade = 0.0f;
        open = 1;
        draw_speed = GetDrawSpeedDef();
        page_wait = 0;
        scroll_wait = 0;
        reveal = 0.0f;
        reveal_num = 0;
        page_top = 0;
        unk_1f4 = 0;
        InitMesWinTbl();
        color = def_color;
        wait = 0;
        page_time = 0;
        page_auto_time = 30;
        mes_no = -1;
        unk_1e40 = 0;
        alpha = 0x80;
        name_count = 0;
        name_offset = 0;
        do {
            memset(((ClsMes *)((char *)this + name_offset))->name[0], 0, MES_NAME_LEN);
            name_count++;
            name_offset += MES_NAME_LEN;
        } while (name_count < MES_NAME_MAX);
        for (int item_index = 0; item_index < MES_ITEM_MAX; item_index++) {
            item_mes[item_index] = -1;
        }
        for (int value_index = 0; value_index < MES_VALUE_MAX; value_index++) {
            values[value_index] = 0;
            value_width[value_index] = 0;
        }
        value = 0;
        value_sign = 0;
        value_zero = 1;
        value_half = 0;
        value_space = 0;
        digit_font = 0;
        space_w = -1;
        justify_w = -1;
        select = -1;
        goal_cursor_x = 0;
        goal_cursor_y = 0;
        cursor_x = 0;
        cursor_y = 0;
        select_shade = MES_SELECT_SHADE_DARK;
        cursor_centering = 0;
        cursor_time = 0;
        choice_pos[0][0] = -1;
        choice_pos[0][1] = -1;
        choice_pos[1][0] = -1;
        choice_pos[1][1] = -1;
        select_top = 0;
        cursor_off_y = 0;
        voice_on = 0;
        voice_type = 0;
        voice_cnt = 0;
        close_time = 0;
        scissor_on = 0;
        scissor.x = 0;
        scissor.width = 0;
        scissor.y = 0;
        scissor.height = 0;
        int pair_offset;
        int line_offset;
        int line_index;
        line_index = 0;
        line_offset = 0;
        pair_offset = 0;
        do {
            ((ClsMes *)((char *)this + line_offset))->line_indent[0] = 0;
            ((ClsMes *)((char *)this + pair_offset))->line_pos[0][0] = 0;
            ((ClsMes *)((char *)this + pair_offset))->line_pos[0][1] = 0;
            ((ClsMes *)((char *)this + line_offset))->line_pos_on[0] = 0;
            ((ClsMes *)((char *)this + line_offset))->line_shade[0] = MES_SHADE_AUTO;
            ((ClsMes *)((char *)this + line_offset))->line_color[0] = 0;
            ((ClsMes *)((char *)this + line_offset))->equip_on[0] = 0;
            ((ClsMes *)((char *)this + line_offset))->equip_x[0] = 0;
            ((ClsMes *)((char *)this + line_offset))->equip_y[0] = 0;
            ((ClsMes *)((char *)this + line_offset))->line_w[0] = 0;
            ((ClsMes *)((char *)this + line_offset))->line_alpha[0] = -1;
            ((ClsMes *)((char *)this + line_offset))->cross_on[0] = 0;
            ((ClsMes *)((char *)this + line_offset))->cross_x[0] = 0;
            ((ClsMes *)((char *)this + line_offset))->cross_y[0] = 0;
            ((ClsMes *)((char *)this + line_offset))->unk_271c[0] = -1;
            ((ClsMes *)((char *)this + line_offset))->unk_276c[0] = -1;
            ((ClsMes *)((char *)this + line_offset))->unk_27bc[0] = 0;
            ((ClsMes *)((char *)this + line_offset))->unk_280c[0] = 0;
            ((ClsMes *)((char *)this + line_offset))->delta_on[0] = 0;
            ((ClsMes *)((char *)this + line_offset))->delta_x[0] = 0;
            ((ClsMes *)((char *)this + line_offset))->delta_y[0] = 0;
            line_index++;
            line_offset += sizeof(int);
            pair_offset += sizeof(int) * 2;
        } while (line_index < MES_LINE_MAX);
    }
};

STATIC_ASSERT(sizeof(ClsMes) == 0x2958);

/**
 *
 * Initialises a primitive builder for one of the drawing setups the message
 * window uses.
 *
 * @mangled MySetPrim__FP11mgCDrawPrimii
 * @address 0x151910
 * @size 0x1F0
 */
void MySetPrim(mgCDrawPrim *prim, int type, int bilinear);

/**
 *
 * Adds one sprite mapping the texture rectangle @p uv onto the screen
 * rectangle @p xy.
 *
 * @mangled set2DSpriteEasy__FP11mgCDrawPrim9mgRect_i_9mgRect_i_P10RGBAQ_TYPE
 * @address 0x151B00
 * @size 0x120
 */
void set2DSpriteEasy(mgCDrawPrim *prim, mgRect<int> xy, mgRect<int> uv, RGBAQ_TYPE *color);

/**
 *
 * Draws one sprite from the named texture, unless MesAbsDrawOff is set.
 *
 * @mangled _set2DSprite__FPcP11mgCDrawPrim9mgRect_i_9mgRect_i_P10RGBAQ_TYPE
 * @address 0x151C20
 * @size 0x90
 */
void _set2DSprite(char *texture, mgCDrawPrim *prim, mgRect<int> xy, mgRect<int> uv, RGBAQ_TYPE *color);

/**
 *
 * Draws one sprite from the message window's texture.
 *
 * @mangled set2DSprite__FP11mgCDrawPrim9mgRect_i_9mgRect_i_P10RGBAQ_TYPE
 * @address 0x151CB0
 * @size 0x50
 */
void set2DSprite(mgCDrawPrim *prim, mgRect<int> xy, mgRect<int> uv, RGBAQ_TYPE *color);

/**
 *
 * Fills a screen rectangle with one colour.
 *
 * @mangled FillRect__Fiiiiiiii
 * @address 0x151D00
 * @size 0x150
 */
void FillRect(int x, int y, int width, int height, int r, int g, int b, int a);

/**
 *
 * Writes the screen position of the top of a character into @p pos.
 *
 * @mangled GetScrPosFromChar__FP11CCharacter2Pi
 * @address 0x1525F0
 * @size 0xA0
 */
void GetScrPosFromChar(CCharacter2 *chara, int *pos);

/**
 *
 * Fills the nine screen slots a window of @p width by @p height can take
 * on a screen of @p screen_w by @p screen_h.
 *
 * @mangled CalcAutoPosSetData__FiiiiP4RECT
 * @address 0x152960
 * @size 0x100
 */
void CalcAutoPosSetData(int screen_w, int screen_h, int width, int height, RECT *slots);

/**
 *
 * Gives back the line after the `@` marker numbered @p id in a text file,
 * or NULL.
 *
 * @mangled GetBuffMesIdPtr__FPcii
 * @address 0x152FB0
 * @size 0xC0
 */
char *GetBuffMesIdPtr(char *buff, int size, int id);

/**
 *
 * Clears one row of NameRegistTbl and gives it back, or NULL for a row out
 * of range.
 *
 * @mangled SetAndGetNameRegistTbl__Fi
 * @address 0x1549E0
 * @size 0x100
 */
short *SetAndGetNameRegistTbl(int no);

/**
 *
 * Gives back which item slot, from 1, an item code stands for, or -1.
 *
 * @mangled GetItemNoFromFontNo__Fi
 * @address 0x157640
 * @size 0x150
 */
int GetItemNoFromFontNo(int code);

/**
 *
 * Copies one message of a text file into @p dst, turning `\n` escapes and
 * line ends into newlines, up to the next `@` marker.
 *
 * @mangled PreMesMake__FPcPc
 * @address 0x159820
 * @size 0x100
 */
void PreMesMake(char *src, char *dst);

/**
 *
 * Scales a rectangle about its centre.
 *
 * @mangled CalcRectScale__F4RECTfP4RECT
 * @address 0x159E30
 * @size 0x100
 */
void CalcRectScale(RECT rect, float scale, RECT *out);

/**
 *
 * Draws the yes and no choices at the two given screen positions.
 *
 * @mangled DrawYesNo__FP11mgCDrawPrimiiiiP10RGBAQ_TYPE
 * @address 0x159F80
 * @size 0xF0
 */
void DrawYesNo(mgCDrawPrim *prim, int yes_x, int yes_y, int no_x, int no_y, RGBAQ_TYPE *color);

/**
 *
 * Gives back where something of @p width by @p height goes when placed at
 * one of the nineteen anchor points of a rectangle, numbered from 1.
 *
 * @mangled GetPos_AbsPosSet__F4RECTiiiPiPi
 * @address 0x15A070
 * @size 0x180
 */
void GetPos_AbsPosSet(RECT rect, int width, int height, int anchor, int *x, int *y);

/**
 *
 * Gives back the position that leaves @p size placed @p ratio of the way
 * between @p min and @p max.
 *
 * @mangled CalcAutoPosSet__Fffff
 * @address 0x15A1F0
 * @size 0x20
 */
float CalcAutoPosSet(float min, float max, float size, float ratio);

/**
 *
 * Unpacks a packed RGBA colour.
 *
 * @mangled RgbqToUint__FUi
 * @address 0x15A210
 * @size 0x50
 */
RGBAQ_TYPE RgbqToUint(unsigned int color);

/**
 *
 * Grows a frame's inner rectangle by the margins of window mode @p mode.
 *
 * @mangled CalcWindowOutRectFromInRect__Fi4RECTP4RECT
 * @address 0x15BD30
 * @size 0xC0
 */
void CalcWindowOutRectFromInRect(int mode, RECT in, RECT *out);

/**
 *
 * Shrinks a frame's outer rectangle by the margins of window mode @p mode.
 *
 * @mangled CalcWindowInRectFromOutRect__Fi4RECTP4RECT
 * @address 0x15BDF0
 * @size 0xC0
 */
void CalcWindowInRectFromOutRect(int mode, RECT out, RECT *in);

/**
 *
 * Writes the unit direction from @p from to @p to into @p dir.
 *
 * @mangled Parametric__FPfPfPf
 * @address 0x15CA30
 * @size 0x50
 */
void Parametric(float *from, float *to, float *dir);

/**
 *
 * Solves a quadratic equation; gives back how many real roots it wrote.
 *
 * @mangled Quadratic__FfffPfPf
 * @address 0x15CA80
 * @size 0x170
 */
int Quadratic(float a, float b, float c, float *root0, float *root1);

/**
 *
 * Works out where the line through @p from and @p to meets a sphere; gives
 * back how many points it wrote.
 *
 * @mangled CalcIntersectionPointSphereAndLine__FPffPfPfPfPf
 * @address 0x15CBF0
 * @size 0x150
 */
int CalcIntersectionPointSphereAndLine(float *centre, float radius, float *from, float *to, float *hit0, float *hit1);

/**
 *
 * Gives back whether @p pos lies inside the box spanned by @p a and @p b.
 *
 * @mangled CheckPosInOutForArea__FPfPfPf
 * @address 0x15CD40
 * @size 0xA0
 */
int CheckPosInOutForArea(float *a, float *b, float *pos);

/**
 *
 * Moves @p speed from @p from towards @p to into @p out, stopping at
 * @p to; gives back whether it was reached.
 *
 * @mangled CalcMoveNextPos__FPfPffPf
 * @address 0x15CDE0
 * @size 0xE0
 */
int CalcMoveNextPos(float *from, float *to, float speed, float *out);

/**
 *
 * Clears the movie captions.
 *
 * @mangled InitMovieCC__Fv
 * @address 0x15CEC0
 * @size 0x90
 */
void InitMovieCC();

/**
 *
 * Copies one line of text into @p dst, without its line end.
 *
 * @mangled MyStrCpyLineFeed__FPcPc
 * @address 0x15CF50
 * @size 0x80
 */
void MyStrCpyLineFeed(char *dst, char *src);

/**
 *
 * Moves a text pointer to the start of the next line.
 *
 * @mangled GetNextLineTop__FPPc
 * @address 0x15CFD0
 * @size 0x30
 */
void GetNextLineTop(char **text);

/**
 *
 * Gives back the line after the `@` marker numbered @p id in a text file,
 * or NULL.
 *
 * @mangled GetTopAddress__FPcii
 * @address 0x15D000
 * @size 0xA0
 */
char *GetTopAddress(char *buff, int size, int id);

/**
 *
 * Reads the caption times and texts of one movie from a caption file.
 *
 * @mangled MovieCCAnalyze__FPcii
 * @address 0x15D0A0
 * @size 0x230
 */
void MovieCCAnalyze(char *buff, int size, int movie_no);

/**
 *
 * Draws the captions due this frame and advances the caption clock.
 *
 * @mangled MovieCCDraw__Fv
 * @address 0x15D2D0
 * @size 0x100
 */
void MovieCCDraw();

/**
 *
 * Sets up the caption font and reads one movie's captions.
 *
 * @mangled MovieCCInit__FPcii
 * @address 0x15D3D0
 * @size 0xA0
 */
void MovieCCInit(char *buff, int size, int movie_no);

/** Points of the speech bubble's outline, as fractions of its width and height. */
extern float p[16][2];

/** Margins of each window mode's frame around its text: left, top, right and bottom. */
extern s32 waku_data[WAKU_DATA_MAX][4];

/** Non-zero to stop the message windows drawing text and sprites. */
extern s32 MesAbsDrawOff;

/** Frames the movie captions have run for. */
extern s32 MovieCCCnt;

/** Width of the caption being drawn. */
extern s32 MovieCCW;

/** Height of the caption being drawn. */
extern s32 MovieCCH;

/** Names the name-registration codes 0xFAFA to 0xFAFF insert into messages, one row each. */
extern short NameRegistTbl[NAME_REGIST_MAX][NAME_REGIST_LEN];

/** Font the movie captions draw with. */
extern CFont MovieCCFont;

/** Frame each movie caption appears on. */
extern s32 MovieCCStart[MOVIE_CC_MAX];

/** Frame each movie caption disappears on. */
extern s32 MovieCCClear[MOVIE_CC_MAX];

/** Text of each movie caption. */
extern char MovieCCStr[MOVIE_CC_MAX][MOVIE_CC_LEN];
