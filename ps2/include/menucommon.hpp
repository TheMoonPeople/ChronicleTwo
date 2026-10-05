#pragma once

#include "common.h"

/**
 * @file
 * Declares the helpers that every menu shares: random numbers, model scaling, menu sound,
 * sorting and stacking of item lists, language-aware file loading, menu value easing, and the
 * script tags that read a menu layout file and run its message commands.
 */

class CCharacter2;
class CGameDataUsed;
class CSaveData;
class mgCCamera;
class mgCFrame;
class mgCMemory;
struct BG_READ_INFO;
struct mgVu0FBOX;

/**
 *
 * How LoadFileMenu reads a file, as its mode argument holds it.
 *
 */
// clang-format off
enum MenuFileLoadMode {
    MENU_FILE_LOAD_BG     = 0, /**< Queue the file for reading in the background. */
    MENU_FILE_LOAD_DIRECT = 1, /**< Read the file at once. */
};

// clang-format on

/**
 *
 * Pairs a keyword that a menu script may give with the value it stands for, in tables ended by a null keyword.
 *
 */
struct MENU_SPI_ANALYZE_STRUCT1 {
    char *name;  /**< Keyword as written in the script; null ends the table. */
    int   value; /**< Value that the keyword stands for. */
};

STATIC_ASSERT(sizeof(MENU_SPI_ANALYZE_STRUCT1) == 0x8);

int menu_spi_analyze_func_strcut1(MENU_SPI_ANALYZE_STRUCT1 *table, char *name);

/**
 *
 * Holds the command that MenuCommandAnalyze runs and the message buffers its commands may hand to message windows.
 *
 */
struct MENU_COMMAND_ANALYZE_INFO {
    char   command_name[0x48];  /**< Command whose block of the script runs; other blocks are skipped. */
    short *system_mes_buff[4];  /**< System message buffers by number; null stands for the default system message buffer. */
    short *mes_buff[4];         /**< Message buffers by number. */
};

STATIC_ASSERT(sizeof(MENU_COMMAND_ANALYZE_INFO) == 0x68);

/**
 *
 * Returns a random integer from zero up to, but not including, a limit.
 *
 * @mangled GetRandI__Fi
 * @address 0x252CF0
 * @size 0x40
 */
int GetRandI(int limit);

/**
 *
 * Returns a random number from zero up to a limit.
 *
 * @mangled GetRandF__Ff
 * @address 0x252D30
 * @size 0x30
 */
float GetRandF(float limit);

/**
 *
 * Returns the scale that fits the bounding box of a model to a given size.
 *
 * @mangled MenuAdjustPolygonScale__FP8mgCFramef
 * @address 0x252E00
 * @size 0x50
 */
float MenuAdjustPolygonScale(mgCFrame *frame, float size);

/**
 *
 * Returns the scale that fits a bounding box to a given size.
 *
 * @mangled MenuAdjustPolygonScale__F9mgVu0FBOXf
 * @address 0x252E50
 * @size 0xB0
 */
float MenuAdjustPolygonScale(mgVu0FBOX box, float size);

/**
 *
 * Scales a character so that its body height matches a given size.
 *
 * @mangled MenuAdjustPolygonScale__FP11CCharacter2f
 * @address 0x252F00
 * @size 0x80
 */
void MenuAdjustPolygonScale(CCharacter2 *chara, float size);

/**
 *
 * Turns a character about the Y axis by an angle.
 *
 * @mangled AddRotationCharaY__FP11CCharacter2f
 * @address 0x252F80
 * @size 0x80
 */
void AddRotationCharaY(CCharacter2 *chara, float angle);

/**
 *
 * Plays a system sound effect; a negative number plays nothing.
 *
 * @mangled MenuSePlay__Fi
 * @address 0x253000
 * @size 0x30
 */
void MenuSePlay(int se_no);

/**
 *
 * Plays a sound effect from a loaded sound; a negative number plays nothing.
 *
 * @mangled MenuSePlay__FUii
 * @address 0x253030
 * @size 0x20
 */
void MenuSePlay(unsigned int snd_id, int se_no);

/**
 *
 * Loads a sound into the menu sound port and plays one of its sound effects.
 *
 * @mangled MenuSePlay__FiPUiP9mgCMemory
 * @address 0x253050
 * @size 0x90
 */
void MenuSePlay(int se_no, unsigned int *sound, mgCMemory *stack);

/**
 *
 * Silences the map's object, base and environment sound while a menu is open, and the event sound when asked.
 *
 * @mangled StopEnvSoundMenu__Fi
 * @address 0x2530E0
 * @size 0xA0
 */
void StopEnvSoundMenu(int stop_event);

/**
 *
 * Restores the sound volumes that StopEnvSoundMenu silenced.
 *
 * @mangled ReStartEnvSoundMenu__Fv
 * @address 0x253180
 * @size 0x60
 */
void ReStartEnvSoundMenu();

/**
 *
 * Merges stackable items of a list into full stacks, then sorts the list by item kind; returns zero for no list.
 *
 * @mangled MenuSeiton__FP13CGameDataUsedi
 * @address 0x253430
 * @size 0x190
 */
int MenuSeiton(CGameDataUsed *items, int item_num);

/**
 *
 * Returns the bag slot that an item occupies, or -1 when it is not in the bag.
 *
 * @mangled GetSameAdrressUserData__FP13CGameDataUsedi
 * @address 0x2535C0
 * @size 0x70
 */
int GetSameAdrressUserData(CGameDataUsed *item, int bag);

/**
 *
 * Removes one entry from a list by moving the later entries down, and keeps the selected entry in range.
 *
 * @mangled local_sort1__FRiPiPi
 * @address 0x253630
 * @size 0x50
 */
void local_sort1(int &select, int *num, int *list);

/**
 *
 * Returns the chapter that a save has reached, or -1 for no save.
 *
 * @mangled GetNowChapter__FP9CSaveData
 * @address 0x253680
 * @size 0x70
 */
int GetNowChapter(CSaveData *save);

/**
 *
 * Rounds a buffer pointer up to the next 64-byte boundary.
 *
 * @mangled MenuCalcBufAlignment__FP1
 * @address 0x2536F0
 * @size 0x40
 */
u_long128 *MenuCalcBufAlignment(u_long128 *buffer);

/**
 *
 * Loads a menu file from the current language's directory, and returns its size or -1. @see MenuFileLoadMode
 *
 * @mangled LoadFileMenu__FPcP1i
 * @address 0x253730
 * @size 0xC0
 */
int LoadFileMenu(char *name, u_long128 *buffer, int mode);

/**
 *
 * Copies a text, turning its bracketed character codes into font characters when the game runs in a European language.
 *
 * @mangled ConvertFontCode__FPcPc
 * @address 0x2537F0
 * @size 0x270
 */
void ConvertFontCode(char *src, char *dst);

/**
 *
 * Returns whether the game runs in one of the European languages.
 *
 * @mangled CheckNowEurope__Fv
 * @address 0x253A60
 * @size 0x30
 */
int CheckNowEurope();

/**
 *
 * Loads a null-terminated list of menu files one after another into a memory stack, and returns their total size.
 *
 * @mangled MenuCommonReadData__FP9mgCMemoryPPci
 * @address 0x253A90
 * @size 0xD0
 */
int MenuCommonReadData(mgCMemory *stack, char **names, int mode);

/**
 *
 * Deletes the texture blocks of a list ended by a negative block, up to sixteen.
 *
 * @mangled MenuDeleteTextureBlock__FPi
 * @address 0x253B60
 * @size 0x80
 */
void MenuDeleteTextureBlock(int *blocks);

/**
 *
 * Enters a blank work texture whose sides are rounded up to multiples of 64.
 *
 * @mangled MenuWorkTextureEnter__FiPciii
 * @address 0x253BE0
 * @size 0x90
 */
void MenuWorkTextureEnter(int block, char *name, int width, int height, int bpp);

/**
 *
 * Enters the textures of an IMG archive, appending a suffix to their names while they are entered.
 *
 * @mangled MenuEnterIMG__FiPUcPc
 * @address 0x253C70
 * @size 0x70
 */
void MenuEnterIMG(int block, unsigned char *img, char *name_suffix);

/**
 *
 * Returns the background read of a file in the current directory.
 *
 * @mangled GetReadBGInfo__FPc
 * @address 0x253CE0
 * @size 0x40
 */
BG_READ_INFO *GetReadBGInfo(char *name);

/**
 *
 * Eases a value toward a target by a fraction of the distance, snapping to it when close enough or when asked.
 *
 * @mangled CalcMenu1__FfPfffi
 * @address 0x253D20
 * @size 0x90
 */
void CalcMenu1(float target, float *value, float divisor, float snap_range, int snap);

/**
 *
 * Eases a value toward a target by a fraction of the distance, snapping to it when close enough or when asked.
 *
 * @mangled CalcMenu1__FiPiiii
 * @address 0x253DB0
 * @size 0x80
 */
void CalcMenu1(int target, int *value, int divisor, int snap_range, int snap);

/**
 *
 * Adds a step to a value and clamps it at a limit; returns 1 when clamped, 0 when not and -1 for no value.
 *
 * @mangled CalcMenuAdd__FPiii
 * @address 0x253E30
 * @size 0x60
 */
int CalcMenuAdd(int *value, int step, int limit);

/**
 *
 * Adds a step to a value and clamps it at a limit; returns 1 when clamped, 0 when not and -1 for no value.
 *
 * @mangled CalcMenuAdd__FPfff
 * @address 0x253E90
 * @size 0x90
 */
int CalcMenuAdd(float *value, float step, float limit);

/**
 *
 * Adds a step to a value unless it would pass a limit; returns 1 when refused, 0 when added and -1 for no value.
 *
 * @mangled CalcMenuAdd2__FPiii
 * @address 0x253F20
 * @size 0x70
 */
int CalcMenuAdd2(int *value, int step, int limit);

/**
 *
 * Returns the number of decimal digits of a number.
 *
 * @mangled GetNumberKeta__Fi
 * @address 0x253F90
 * @size 0x60
 */
int GetNumberKeta(int value);

/**
 *
 * Returns a value as the whole number shown for it, rounding any fraction up.
 *
 * @mangled GetDispVolumeForFloat__Ff
 * @address 0x253FF0
 * @size 0x60
 */
int GetDispVolumeForFloat(float value);

/**
 *
 * Returns the fractional part of a value.
 *
 * @mangled GetFloatCommaValue__Ff
 * @address 0x254050
 * @size 0x30
 */
float GetFloatCommaValue(float value);

/**
 *
 * Returns where a scroll bar's knob sits for a scroll position.
 *
 * @mangled CalcScrlBarPutPos__Fifif
 * @address 0x254080
 * @size 0x50
 */
int CalcScrlBarPutPos(int top, float pos, int length, float pos_max);

/**
 *
 * Projects the position of a frame to screen coordinates through a camera.
 *
 * @mangled Trans3DPosTo2DPos__FP9mgCCameraP8mgCFramePi
 * @address 0x2540D0
 * @size 0xA0
 */
void Trans3DPosTo2DPos(mgCCamera *camera, mgCFrame *frame, int *screen_pos);

/**
 *
 * Runs a menu layout script, building its textures, forms and parts in a memory stack; returns zero for no script.
 *
 * @mangled MenuDataAnalyze__FPciP9mgCMemory
 * @address 0x256730
 * @size 0x70
 */
int MenuDataAnalyze(char *script, int size, mgCMemory *stack);

/**
 *
 * Runs the block of a menu command script that belongs to one command.
 *
 * @mangled MenuCommandAnalyze__FPciPc
 * @address 0x257670
 * @size 0x80
 */
void MenuCommandAnalyze(char *script, int size, char *command_name);

/**
 *
 * Whether a menu loaded its own sound into the menu sound port, to release it when the menu closes.
 *
 */
extern u8 MenuSePlayUsedFlag;

/**
 *
 * Memory stack that a menu layout script allocates from while MenuDataAnalyze runs it.
 *
 */
extern mgCMemory *MenuSpiStack;

/**
 *
 * Command and message buffers of the menu command script that MenuCommandAnalyze runs.
 *
 */
extern MENU_COMMAND_ANALYZE_INFO MenuCommandAnalyzeInfo;
