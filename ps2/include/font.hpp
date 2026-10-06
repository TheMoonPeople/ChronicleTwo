#pragma once

#include "common.h"

#include "mg_tanime.hpp"

/**
 * @file
 * Declares the font: the class that draws a string of the game's text with
 * the font textures, character by character with an optional outline, plus
 * the lookups that turn the text's characters, tags and special symbols
 * (gaiji) into font numbers and texture rectangles.
 */

class mgCDrawPrim;

/**
 *
 * Rectangle given by its top-left corner and its extent.
 *
 */
struct RECT {
    s32 x;      /**< Distance of the left edge from the left of the screen. */
    s32 y;      /**< Distance of the top edge from the top of the screen. */
    s32 width;  /**< Distance from the left edge to the right edge. */
    s32 height; /**< Distance from the top edge to the bottom edge. */
};

STATIC_ASSERT(sizeof(RECT) == 0x10);

/**
 *
 * Colour in the layout of the GS RGBAQ register.
 *
 */
struct RGBAQ_TYPE {
    u_long r : 8;  /**< Red. */
    u_long g : 8;  /**< Green. */
    u_long b : 8;  /**< Blue. */
    u_long a : 8;  /**< Alpha; 0x80 is fully opaque. */
    u_long q : 32; /**< Q value of the register. */
};

STATIC_ASSERT(sizeof(RGBAQ_TYPE) == 0x8);

/**
 *
 * Character codes, font numbers and table sizes of the font.
 *
 */
// clang-format off
enum {
    FONT_STR_MAX             = 0x80,   /**< Bytes of the string a CFont holds, terminator included. */
    FONT_NO_NONE             = -1,     /**< Font number of a character the font has no glyph for. */
    FONT_NO_NEWLINE          = -2,     /**< Font number GetFontNo and GetHalfFontNo give a line feed. */
    FONT_NO_ALPHABETICAL_TOP = 0x5E,   /**< Font number of the first alphabetical character. */
    FONT_NO_FONT_GAIJI_TOP   = 0x9D,   /**< Font number of the first font gaiji character. */
    FONT_NO_FONT_GAIJI_END   = 0xB5,   /**< Font number after the last font gaiji character. */
    FONT_NO_HALF_SPACE       = 0xFF02, /**< Font number CheckHalfFont always treats as half-width. */
    FONT_TEX_PAGE_CHARS      = 0x260,  /**< Characters on one page of the font texture. */
    FONT_TEX_COLUMNS         = 32,     /**< Characters in one row of a font texture page. */
    FONT_TEX_CHAR_W          = 16,     /**< Width of one character in the font texture. */
    FONT_TEX_CHAR_H          = 20,     /**< Height of one character in the font texture. */
    GAIJI_CODE_TOP           = 0xFD00, /**< Code of the first gaiji symbol. */
    GAIJI_CODE_END           = 0xFD32, /**< Code after the last gaiji symbol. */
    FONT_GAIJI_CODE_TOP      = 0xFDE0, /**< Code of the first font gaiji character. */
    FONT_GAIJI_CODE_END      = 0xFDF8, /**< Code after the last font gaiji character. */
    GAIJI_DATA_NUM           = 51,     /**< Rows of GaijiDataTbl. */
    FCONV_CODE_NUM           = 46,     /**< Rows of FconvCodeTbl. */
    FONT_GAIJI_CONV_NUM      = 24,     /**< Rows of FontGaijiConvTbl. */
    ALPHABETICAL_CHARA_NUM   = 63,     /**< Rows of alphabetical_chara_tbl. */
    ALPHABETICAL_CHARA_LEN   = 5,      /**< Bytes of one row of alphabetical_chara_tbl. */
    FONT_TBL_BIN_SIZE        = 0x1000, /**< Bytes of the loaded font table file. */
};
// clang-format on

/**
 *
 * Outline or shadow drawn behind each character, as CFont::SetFuchi takes it.
 *
 */
// clang-format off
enum FontFuchi {
    FUCHI_NONE              = 0, /**< No outline. */
    FUCHI_SHADOW_WHITE      = 1, /**< Half-transparent white shadow one pixel down and right. */
    FUCHI_SHADOW_BLACK      = 2, /**< Half-transparent black shadow one pixel down and right. */
    FUCHI_OUTLINE           = 3, /**< Black outline one pixel wide on four sides. */
    FUCHI_SHADOW_DOUBLE     = 4, /**< Grey shadow one pixel and black shadow two pixels down and right. */
    FUCHI_SHADOW_BLACK_WIDE = 5, /**< Black shadow two pixels down and right. */
    FUCHI_OUTLINE_WIDE      = 6, /**< Black outline two pixels out on four sides. */
    FUCHI_SHADOW_WHITE_BLUE = 7, /**< White shadow one pixel and dark blue shadow two pixels down and right. */
    FUCHI_OUTLINE_THICK     = 8, /**< Black outline on eight sides plus two pixels out on four sides. */
    FUCHI_NUM               = 9, /**< Number of styles; larger values draw no outline. */
};
// clang-format on

/**
 *
 * Colour and outline combinations CFont::Preset applies.
 *
 */
// clang-format off
enum FontPreset {
    FONT_PRESET_DARK      = 0, /**< Dark grey text with a black shadow. */
    FONT_PRESET_DARK_2    = 1, /**< Same as FONT_PRESET_DARK. */
    FONT_PRESET_THICK     = 2, /**< Light grey text with a thick black outline. */
    FONT_PRESET_THICK_2   = 3, /**< Same as FONT_PRESET_THICK. */
    FONT_PRESET_SHADOWED  = 4, /**< Light grey text with a wide black shadow. */
};
// clang-format on

/**
 *
 * Size and texture position of one gaiji symbol, a row of GaijiDataTbl.
 *
 */
struct GAIJI_DATA {
    u16 code;  /**< Gaiji code of the symbol. */
    s16 u;     /**< Left edge of the symbol in the gaiji texture. */
    s16 v;     /**< Top edge of the symbol in the gaiji texture. */
    s16 w;     /**< Width of the symbol. */
    s16 h;     /**< Height of the symbol. */
    s16 off_x; /**< Horizontal offset the symbol draws at. */
    s16 off_y; /**< Vertical offset the symbol draws at. */
};

STATIC_ASSERT(sizeof(GAIJI_DATA) == 0xE);

/**
 *
 * Text tag and the code it stands for, a row of FconvCodeTbl and FontGaijiConvTbl.
 *
 */
struct FCONV_CODE {
    char *str; /**< Tag as written in the text. */
    s32 len;   /**< Bytes of the tag. */
    u16 code;  /**< Gaiji or font gaiji code the tag stands for. */
};

STATIC_ASSERT(sizeof(FCONV_CODE) == 0xC);

/**
 *
 * Font table file loaded by LoadFontTblBin: counts, then the Shift-JIS code
 * of each full-width font number in ascending order.
 *
 */
struct FONT_TBL_BIN {
    u16 half_font_num;              /**< Number of half-width font numbers. */
    u16 kanji_top_no;               /**< First kanji font number; zero when the font has no kanji. */
    u16 yoyaku_num;                 /**< Codes in yoyaku_tbl. */
    u16 unk_6;
    u8 yoyaku_tbl[0x7FC][2];        /**< Big-endian Shift-JIS code of each font number, sorted. */
};

STATIC_ASSERT(sizeof(FONT_TBL_BIN) == FONT_TBL_BIN_SIZE);

/**
 *
 * Text drawn with the font textures: holds a string, where and how large
 * to draw it, its colour and its outline.
 *
 */
class CFont {
public:
    char str[FONT_STR_MAX]; /**< String SetStr copies. */
    s32 fuchi;              /**< Outline drawn behind each character, a FontFuchi. */
    s32 unk_84;
    RGBAQ_TYPE color;       /**< Colour of the text. */
    s32 alpha;              /**< Scale applied to the colour's alpha; 0x80 leaves it unchanged. */
    s32 pos_x;              /**< Screen x DrawDirect starts the text at. */
    s32 pos_y;              /**< Screen y DrawDirect starts the text at. */
    s32 clearance_w;        /**< Advance after a full-width character; half of it after a half-width one. */
    s32 clearance_h;        /**< Advance from one line to the next. */
    s32 draw_w;             /**< Width a full-width character is drawn at. */
    s32 draw_h;             /**< Height a character is drawn at. */
    s32 mini;               /**< Non-zero to draw with the small font texture. */
    float unk_b0;
    float unk_b4;

    /**
     *
     * Creates a font with the default settings.
     *
     */
    CFont() { Init(); }

    /**
     *
     * Tells whether a font number is a kanji.
     *
     * @mangled CheckKanjiFont__5CFontFi
     * @address 0x2D8EE0
     * @size 0x80
     */
    int CheckKanjiFont(int font_no);

    /**
     *
     * Tells whether a font number is drawn half-width.
     *
     * @mangled CheckHalfFont__5CFontFi
     * @address 0x2D8F60
     * @size 0xA0
     */
    int CheckHalfFont(int font_no);

    /**
     *
     * Sets the size each character is drawn at.
     *
     * @mangled SetDrawSize__5CFontFii
     * @address 0x2D9000
     * @size 0x10
     */
    void SetDrawSize(int w, int h);

    /**
     *
     * Sets the advance after each character and from one line to the next.
     *
     * @mangled SetClearance__5CFontFii
     * @address 0x2D9010
     * @size 0x10
     */
    void SetClearance(int w, int h);

    /**
     *
     * Sets the screen position the text starts at.
     *
     * @mangled SetPos__5CFontFii
     * @address 0x2D9020
     * @size 0x10
     */
    void SetPos(int x, int y);

    /**
     *
     * Sets the colour of the text from its components.
     *
     * @mangled SetColor__5CFontFiiii
     * @address 0x2D9030
     * @size 0x20
     */
    void SetColor(int r, int g, int b, int a);

    /**
     *
     * Sets the colour of the text.
     *
     * @mangled SetColor__5CFontF10RGBAQ_TYPE
     * @address 0x2D9050
     * @size 0x30
     */
    void SetColor(RGBAQ_TYPE color);

    /**
     *
     * Sets the colour of the text from a colour packed as 0xAABBGGRR.
     *
     * @mangled SetColor__5CFontFUi
     * @address 0x2D9080
     * @size 0x50
     */
    void SetColor(unsigned int color);

    /**
     *
     * Sets the outline drawn behind each character.
     *
     * @mangled SetFuchi__5CFontFi
     * @address 0x2D90D0
     * @size 0x10
     */
    void SetFuchi(int fuchi);

    /**
     *
     * Copies a string into the font, unless it is too long.
     *
     * @mangled SetStr__5CFontFPc
     * @address 0x2D90E0
     * @size 0x70
     */
    void SetStr(char *str);

    /**
     *
     * Gives the digit a font number shows, or -1 when it is not a digit.
     *
     * @mangled GetDigitNo__5CFontFi
     * @address 0x2D9850
     * @size 0x120
     */
    int GetDigitNo(int font_no);

    /**
     *
     * Draws one character by its font number, with its outline when asked.
     *
     * @mangled DrawChar__5CFontFP11mgCDrawPrimiiii10RGBAQ_TYPEUc
     * @address 0x2DA1B0
     * @size 0x210
     */
    void DrawChar(mgCDrawPrim *prim, int font_no, int x, int y, int fuchi_on, RGBAQ_TYPE color, unsigned char alpha);

    /**
     *
     * Draws the character at the start of a string with the font's colour.
     *
     * @mangled DrawChar__5CFontFP11mgCDrawPrimPcii
     * @address 0x2DA3C0
     * @size 0x70
     */
    void DrawChar(mgCDrawPrim *prim, char *str, int x, int y);

    /**
     *
     * Draws one gaiji symbol from the gaiji texture.
     *
     * @mangled DrawGaiji__5CFontFP11mgCDrawPrimiii
     * @address 0x2DA640
     * @size 0x90
     */
    void DrawGaiji(mgCDrawPrim *prim, int code, int x, int y);

    /**
     *
     * Measures the width and height a string would be drawn at.
     *
     * @mangled CalcDrawWH__5CFontFPcPiPi
     * @address 0x2DA700
     * @size 0x2F0
     */
    void CalcDrawWH(char *str, int *w, int *h);

    /**
     *
     * Draws a string at once, starting at a screen position.
     *
     * @mangled DrawDirect__5CFontFPcii
     * @address 0x2DA9F0
     * @size 0x350
     */
    void DrawDirect(char *str, int x, int y);

    /**
     *
     * Applies one of the preset colour and outline combinations.
     *
     * @mangled Preset__5CFontFi
     * @address 0x2DAD40
     * @size 0xC0
     */
    void Preset(int preset);

    /**
     *
     * Empties the string and restores the default settings.
     *
     * @mangled Init__5CFontFv
     * @address 0x2DAE00
     * @size 0x90
     */
    void Init();
};

STATIC_ASSERT(sizeof(CFont) == 0xB8);

/**
 *
 * Gives the width of a gaiji symbol, or zero when the code is not a gaiji.
 *
 * @mangled GetGaijiW__Fi
 * @address 0x2D8AA0
 * @size 0x50
 */
int GetGaijiW(int code);

/**
 *
 * Gives the height of a gaiji symbol, or zero when the code is not a gaiji.
 *
 * @mangled GetGaijiH__Fi
 * @address 0x2D8AF0
 * @size 0x50
 */
int GetGaijiH(int code);

/**
 *
 * Gives a font number's rectangle in the font texture and which page of
 * the texture holds it.
 *
 * @mangled GetRectFontTex__FiPi
 * @address 0x2D8B40
 * @size 0x1B0
 */
RECT GetRectFontTex(int font_no, int *tex_no);

/**
 *
 * Makes a primitive draw with one of the small font textures.
 *
 * @mangled MySetTexMini__FiP11mgCDrawPrim
 * @address 0x2D8CF0
 * @size 0x80
 */
void MySetTexMini(int tex_no, mgCDrawPrim *prim);

/**
 *
 * Gives a font number's rectangle in the small font texture.
 *
 * @mangled GetRectFontTexMini__FiPi
 * @address 0x2D8D70
 * @size 0x30
 */
RECT GetRectFontTexMini(int font_no, int *tex_no);

/**
 *
 * Copies characters of a string, copying each bracketed tag whole.
 *
 * @mangled My_strncpy__FPcPCcUi
 * @address 0x2D8DA0
 * @size 0x80
 */
char *My_strncpy(char *dst, const char *src, unsigned int n);

/**
 *
 * Gives the font table's sorted list of full-width character codes.
 *
 * @mangled GetYoyakuTblTop__Fv
 * @address 0x2D8E20
 * @size 0x10
 */
u8 *GetYoyakuTblTop();

/**
 *
 * Loads the font table of the current language.
 *
 * @mangled LoadFontTblBin__Fv
 * @address 0x2D8E30
 * @size 0x80
 */
int LoadFontTblBin();

/**
 *
 * Gives the number of codes in the font table's list.
 *
 * @mangled GetYoyakuTblNum__Fv
 * @address 0x2D8EB0
 * @size 0x10
 */
int GetYoyakuTblNum();

/**
 *
 * Gives the first kanji font number, or zero when the font has none.
 *
 * @mangled GetKanjiTopNo__Fv
 * @address 0x2D8EC0
 * @size 0x10
 */
int GetKanjiTopNo();

/**
 *
 * Gives the number of half-width font numbers.
 *
 * @mangled GetHalfFontNum__Fv
 * @address 0x2D8ED0
 * @size 0x10
 */
int GetHalfFontNum();

/**
 *
 * Gives the gaiji code of the tag a string starts with, or zero.
 *
 * @mangled GetGaijiFontNo__FPc
 * @address 0x2D9150
 * @size 0x90
 */
unsigned short GetGaijiFontNo(char *str);

/**
 *
 * Gives the length of the tag that stands for a gaiji code, or zero.
 *
 * @mangled GetGaijiLen__FUs
 * @address 0x2D91E0
 * @size 0x80
 */
int GetGaijiLen(unsigned short code);

/**
 *
 * Gives the font number of an accented single-byte character, or zero.
 *
 * @mangled GetAlphabeticalFontNo_uc__FUc
 * @address 0x2D9260
 * @size 0xB0
 */
unsigned short GetAlphabeticalFontNo_uc(unsigned char c);

/**
 *
 * Gives the font number of the accented character tag a string starts with, or zero.
 *
 * @mangled GetAlphabeticalFontNo_cp__FPc
 * @address 0x2D9310
 * @size 0x1A0
 */
unsigned short GetAlphabeticalFontNo_cp(char *str);

/**
 *
 * Gives the font gaiji code of the tag a string starts with, or zero.
 *
 * @mangled GetFontGaijiFontNo__FPc
 * @address 0x2D94B0
 * @size 0xA0
 */
unsigned short GetFontGaijiFontNo(char *str);

/**
 *
 * Gives the font number of an accented character's 16-bit code, or zero.
 *
 * @mangled GetAlphabeticalFontNo_us__FUs
 * @address 0x2D9550
 * @size 0xA0
 */
unsigned short GetAlphabeticalFontNo_us(unsigned short code);

/**
 *
 * Gives the font number a font gaiji code is drawn with, or zero.
 *
 * @mangled GetFontNoFromFontGaijiCode__FUs
 * @address 0x2D95F0
 * @size 0x80
 */
unsigned short GetFontNoFromFontGaijiCode(unsigned short code);

/**
 *
 * Tells whether a font gaiji code is drawn half-width.
 *
 * @mangled GetFontGaijiHankaku__FUs
 * @address 0x2D9670
 * @size 0x40
 */
int GetFontGaijiHankaku(unsigned short code);

/**
 *
 * Gives the font number of the full-width character a string starts with.
 *
 * @mangled GetFontNo__FPc
 * @address 0x2D96B0
 * @size 0x150
 */
int GetFontNo(char *str);

/**
 *
 * Gives the font number of a half-width character.
 *
 * @mangled GetHalfFontNo__Fc
 * @address 0x2D9800
 * @size 0x50
 */
int GetHalfFontNo(char c);

/**
 *
 * Adds one sprite mapping the texture rectangle @p uv onto the screen
 * rectangle @p xy, both given as position and size.
 *
 * @mangled set2DSpriteEasyFont__FP11mgCDrawPrim9mgRect_i_9mgRect_i_P10RGBAQ_TYPE
 * @address 0x2D9970
 * @size 0x140
 */
void set2DSpriteEasyFont(mgCDrawPrim *prim, mgRect<int> xy, mgRect<int> uv, RGBAQ_TYPE *color);

/**
 *
 * Draws the outline of one character in a FontFuchi style.
 *
 * @mangled set2DSprite_Fuchi__FP11mgCDrawPrim4RECT4RECTii
 * @address 0x2D9AB0
 * @size 0x700
 */
void set2DSprite_Fuchi(mgCDrawPrim *prim, RECT xy, RECT uv, int fuchi, int alpha);

/**
 *
 * Makes a primitive draw with the named texture.
 *
 * @mangled MySetTex__FPcP11mgCDrawPrim
 * @address 0x2DA430
 * @size 0x50
 */
void MySetTex(char *name, mgCDrawPrim *prim);

/**
 *
 * Makes a primitive draw with one of the two font textures.
 *
 * @mangled MySetTex__FiP11mgCDrawPrim
 * @address 0x2DA480
 * @size 0x50
 */
void MySetTex(int tex_no, mgCDrawPrim *prim);

/**
 *
 * Draws one gaiji symbol, centred vertically in a line of the given height.
 *
 * @mangled DrawGaiji_sub__FP11mgCDrawPrimiii10RGBAQ_TYPEi
 * @address 0x2DA4D0
 * @size 0x170
 */
void DrawGaiji_sub(mgCDrawPrim *prim, int code, int x, int y, RGBAQ_TYPE color, int line_h);

/**
 *
 * Widens a width and height to reach a point.
 *
 * @mangled UpDateWH__FPiPiii
 * @address 0x2DA6D0
 * @size 0x30
 */
void UpDateWH(int *w, int *h, int x, int y);

/** Size and texture position of each gaiji symbol, from GAIJI_CODE_TOP on. */
extern GAIJI_DATA GaijiDataTbl[GAIJI_DATA_NUM];

/** Tags of the text that stand for gaiji symbols. */
extern FCONV_CODE FconvCodeTbl[FCONV_CODE_NUM];

/** Tags of the text that stand for font gaiji characters. */
extern FCONV_CODE FontGaijiConvTbl[FONT_GAIJI_CONV_NUM];

/** Hexadecimal codes of the accented character tags, in font number order from FONT_NO_ALPHABETICAL_TOP. */
extern char alphabetical_chara_tbl[ALPHABETICAL_CHARA_NUM][ALPHABETICAL_CHARA_LEN];
