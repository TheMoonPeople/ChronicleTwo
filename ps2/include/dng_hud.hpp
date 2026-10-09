#pragma once

#include "common.h"

#include <libvu0.h>

#include <cstring>

#include "object.hpp"

/**
 * @file
 * Declares the dungeon's on-screen battle indicators: level-up banner, dizzy stars, gift mark,
 * enemy life gauges, damage numbers, lock-on marker and low-gauge warnings.
 */

class CCharacter2;
class CPreSprite;
class CScene;
class ClsMes;
class mgCObject;

/**
 *
 * Stages of the level-up banner, advanced each time its progress reaches the end.
 *
 */
enum LevelupInfoPhase {
    LEVELUP_INFO_PHASE_NONE = 0,   /**< No banner is shown. */
    LEVELUP_INFO_PHASE_APPEAR = 1, /**< Banner fades in while rising into place. */
    LEVELUP_INFO_PHASE_FLASH = 2,  /**< Banner is shown with an additive glow pulsing over it. */
    LEVELUP_INFO_PHASE_HOLD = 3,   /**< Banner is shown still. */
    LEVELUP_INFO_PHASE_FADE = 4,   /**< Banner fades out, then the banner ends. */
};

/**
 *
 * States of one gekirin mark above an enemy's life gauge.
 *
 */
enum GekirinState {
    GEKIRIN_STATE_SHOW = 0,  /**< Mark is shown at rest. */
    GEKIRIN_STATE_BREAK = 1, /**< Mark plays its break-away animation with a glow. */
    GEKIRIN_STATE_NONE = 2,  /**< Mark is gone and not drawn. */
};

/**
 *
 * Number of gekirin marks that one enemy life gauge holds.
 *
 */
enum {
    ENEMY_LIFE_GAGE_GEKIRIN_MAX = 16, /**< Gekirin marks in one life gauge. */
};

/**
 *
 * Stages that a damage number goes through.
 *
 */
enum DamageScorePhase {
    DAMAGE_SCORE_PHASE_APPEAR = 0, /**< Number fades in while its digits bounce. */
    DAMAGE_SCORE_PHASE_FADE = 1,   /**< Number fades out; it ends once fully transparent. */
};

/**
 *
 * Stages that the player's damage number goes through.
 *
 */
enum DamageScore2Phase {
    DAMAGE_SCORE2_PHASE_NONE = 0, /**< No number is shown. */
    DAMAGE_SCORE2_PHASE_JUMP = 1, /**< Number fades in while jumping up. */
    DAMAGE_SCORE2_PHASE_HOLD = 2, /**< Number is held in place. */
    DAMAGE_SCORE2_PHASE_FADE = 3, /**< Number fades out while sinking. */
};

/**
 *
 * Which status board the low-gauge warnings are placed over.
 *
 */
enum WarningGageLayout {
    WARNING_GAGE_LAYOUT_NONE = -1, /**< No warnings are drawn. */
    WARNING_GAGE_LAYOUT_MAIN = 0,  /**< Board of a character on foot, with three gauges. */
    WARNING_GAGE_LAYOUT_ROBO = 1,  /**< Board of the robot, with two gauges. */
};

/**
 *
 * Banner that announces a level up on screen, appearing, flashing, holding and fading out.
 *
 */
class CLevelupInfo {
public:
    s32   unk_00;
    s32   unk_04;
    s32   unk_08;
    s32   unk_0c;
    s32   unk_10;
    s32   unk_14;
    s32   unk_18;
    s32   unk_1c;
    float progress; /**< Progress through the current phase, from 0.0 to 1.0. */
    s32   phase;    /**< Current stage of the banner, a ::LevelupInfoPhase. */
    s32   x;        /**< Screen x of the banner's text. */
    s32   y;        /**< Screen y of the banner's text. */
    s32   unk_30;
    s32   unk_34;

    /**
     *
     * Starts the banner centred on a screen position.
     *
     * @mangled SetLevelUpInfo__12CLevelupInfoFiiii
     * @address 0x1CA710
     * @size 0x50
     */
    void SetLevelUpInfo(int x, int y, int source, int value);

    /**
     *
     * Draws the banner for its current phase.
     *
     * @mangled Draw__12CLevelupInfoFv
     * @address 0x1CA760
     * @size 0x3C0
     */
    void Draw();

    /**
     *
     * Advances the banner through its phases.
     *
     * @mangled Step__12CLevelupInfoFv
     * @address 0x1CAB20
     * @size 0xD0
     */
    void Step();
};

STATIC_ASSERT(sizeof(CLevelupInfo) == 0x38);

/**
 *
 * Three stars that circle above the head of a stunned character.
 *
 */
class CPiyori {
public:
    mgCObject *target;        /**< Character that the stars circle; NULL while no stars are shown. */
    float      star_angle[3]; /**< Angle, in radians, of the bob of each star. */
    float      circle_angle;  /**< Angle, in radians, of the first star around the circle. */
    float      height;        /**< Height of the circle above the character's position. */
    float      radius;        /**< Radius of the circle. */
    s16        time;          /**< Frames left until the stars vanish; they shrink and fade over the last 16. */
    s16        se_wait;       /**< Frames left until the sound of the stars plays again. */

    /**
     *
     * Removes the stars.
     *
     * @mangled Initialize__7CPiyoriFv
     * @address 0x1CABF0
     * @size 0x10
     */
    void Initialize();

    /**
     *
     * Removes the stars and clears their remaining time.
     *
     * @mangled Reset__7CPiyoriFv
     * @address 0x1CAC00
     * @size 0x10
     */
    void Reset();

    /**
     *
     * Starts the stars circling an object for a number of frames.
     *
     * @mangled Set__7CPiyoriFP9mgCObjectffs
     * @address 0x1CAC10
     * @size 0x90
     */
    void Set(mgCObject *object, float height, float radius, short life);

    /**
     *
     * Starts the stars circling a character, sized to the character.
     *
     * @mangled Set__7CPiyoriFP9mgCObjects
     * @address 0x1CACA0
     * @size 0x40
     */
    void Set(mgCObject *target, short time);

    /**
     *
     * Draws the stars around their character.
     *
     * @mangled Draw__7CPiyoriFv
     * @address 0x1CACE0
     * @size 0x240
     */
    void Draw();

    /**
     *
     * Turns the stars, plays their sound, and ends them when their time runs out.
     *
     * @mangled Step__7CPiyoriFv
     * @address 0x1CAF20
     * @size 0x170
     */
    void Step();
};

STATIC_ASSERT(sizeof(CPiyori) == 0x20);

/**
 *
 * Mark that bobs above a character for a while to show that it carries a gift.
 *
 */
class CGiftMark {
public:
    CCharacter2 *chara;  /**< Character that the mark floats above. */
    float        height; /**< Height of the character, which places the mark above it. */
    float        angle;  /**< Angle, in radians, of the mark's bob. */
    s32          active; /**< Nonzero while the mark is shown. */
    s16          time;   /**< Frames that the mark has been shown; it ends after 240. */

    /**
     *
     * Shows the mark above a character.
     *
     * @mangled Set__9CGiftMarkFP11CCharacter2f
     * @address 0x1CB090
     * @size 0x50
     */
    void Set(CCharacter2 *chara, float character_scale);

    /**
     *
     * Draws the mark above its character.
     *
     * @mangled Draw__9CGiftMarkFv
     * @address 0x1CB0E0
     * @size 0x1A0
     */
    void Draw();

    /**
     *
     * Bobs the mark and ends it when its time runs out.
     *
     * @mangled Step__9CGiftMarkFv
     * @address 0x1CB280
     * @size 0x70
     */
    void Step();

    /**
     *
     * Hides the mark and clears its character and time.
     *
     * @mangled Initialize__9CGiftMarkFv
     * @address 0x1CB2F0
     * @size 0x20
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(CGiftMark) == 0x14);

/**
 *
 * One gekirin mark on an enemy's life gauge, which breaks away with an animation.
 *
 */
class CEnemyGekirin {
public:
    s8 state; /**< State of the mark, a ::GekirinState. */
    s8 frame; /**< Frame of the break-away animation. */

    /**
     *
     * Draws the mark into an open sprite list at a screen position.
     *
     * @mangled Draw__13CEnemyGekirinFP10CPreSpriteii
     * @address 0x1CB310
     * @size 0x130
     */
    void Draw(CPreSprite *sprite, int x, int y);

    /**
     *
     * Advances the break-away animation, and removes the mark when it ends.
     *
     * @mangled Step__13CEnemyGekirinFv
     * @address 0x1CB440
     * @size 0x50
     */
    void Step();
};

STATIC_ASSERT(sizeof(CEnemyGekirin) == 0x2);

/**
 *
 * Life gauge of an enemy, drawn above it in the world or across the foot of the screen, with
 * its gekirin marks.
 *
 */
class CEnemyLifeGage {
public:
    sceVu0FVECTOR pos;                                  /**< World position that the gauge is drawn over. */
    s32           max_hp;                               /**< Life that fills the gauge. */
    s32           hp;                                   /**< Life left. */
    s32           screen;                               /**< Nonzero to draw the gauge across the foot of the screen instead of in the world. */
    s32           view;                                 /**< Nonzero while the gauge is to be shown. */
    float         scale;                                /**< Width of the gauge from 0.0 to 1.0, grown while shown and shrunk while hidden. */
    CEnemyGekirin gekirin[ENEMY_LIFE_GAGE_GEKIRIN_MAX]; /**< Gekirin marks drawn above the gauge. */

    /**
     *
     * Shows or hides the gauge, starting it from half width when it appears.
     *
     * @mangled SetView__14CEnemyLifeGageFi
     * @address 0x1CB490
     * @size 0x40
     */
    void SetView(int visible);

    /**
     *
     * Places the gauge, fills it, and starts breaking the gekirin marks beyond a count.
     *
     * @mangled Set__14CEnemyLifeGageFPfiiii
     * @address 0x1CB4D0
     * @size 0xA0
     */
    void Set(float *pos, int new_max_life, int new_life, int count, int new_pinned);

    /**
     *
     * Draws the gauge, and its gekirin marks when they are not hidden.
     *
     * @mangled Draw__14CEnemyLifeGageFi
     * @address 0x1CB570
     * @size 0x650
     */
    void Draw(int hide_gekirin);

    /**
     *
     * Grows or shrinks the gauge and animates its gekirin marks.
     *
     * @mangled Step__14CEnemyLifeGageFv
     * @address 0x1CBBC0
     * @size 0x150
     */
    void Step();

    /**
     *
     * Shows a number of gekirin marks at rest and removes the rest.
     *
     * @mangled ResetGekirin__14CEnemyLifeGageFi
     * @address 0x1CBD10
     * @size 0x50
     */
    void ResetGekirin(int gekirin_count);

    /**
     *
     * Empties and hides the gauge, showing a number of gekirin marks.
     *
     * @mangled Initialize__14CEnemyLifeGageFi
     * @address 0x1CBD60
     * @size 0x40
     */
    void Initialize(int gekirin_num);
};

STATIC_ASSERT(sizeof(CEnemyLifeGage) == 0x50);

/**
 *
 * Number or sprite that pops up over a world position when an attack lands, then fades out.
 *
 */
class CDamageScore {
public:
    s32           unk_00;
    u8            unk_04[0xC];
    sceVu0FVECTOR pos;       /**< World position that the number is drawn over. */
    char          text[8];   /**< Digits of the number. */
    float         bounce[8]; /**< Angle, in radians, of the bounce of each digit, or of the sprite. */
    s16           color[3];  /**< Red, green and blue of the digits. */
    s16           alpha;     /**< Opacity of the number. */
    s16           phase;     /**< Current stage, a ::DamageScorePhase. */
    s16           length;    /**< Number of digits in the text. */
    s32           unk_54;
    s32           unk_58;
    s32           digit_w; /**< Width of one digit in the texture. */
    s32           digit_h; /**< Height of one digit in the texture. */
    s32           digit_u; /**< Texture x of the digit 0. */
    s32           digit_v; /**< Texture y of the digits. */
    s32           unk_6c;
    s32           unk_70;
    s32           sprite_w; /**< Width of the sprite in the texture. */
    s32           sprite_h; /**< Height of the sprite in the texture. */
    s32           sprite_u; /**< Texture x of the sprite. */
    s32           sprite_v; /**< Texture y of the sprite. */
    s32           sprite;   /**< Nonzero to draw the sprite instead of the digits. */
    s32           active;   /**< Nonzero while the number is shown. */

    /**
     *
     * Makes a number with white digits.
     *
     * @mangled __ct__12CDamageScoreFv
     * @address 0x1D5D20
     * @size 0x40
     */
    CDamageScore() { memset(color, 0x80, sizeof(color)); }

    /**
     *
     * Pops up a number over a world position.
     *
     * @mangled SetValue__12CDamageScoreFPfi
     * @address 0x1CBDA0
     * @size 0xA0
     */
    void SetValue(float *pos, int value);

    /**
     *
     * Sets the colour of the digits.
     *
     * @mangled SetColor__12CDamageScoreFsss
     * @address 0x1CBE40
     * @size 0x10
     */
    void SetColor(short r, short g, short b);

    /**
     *
     * Pops up a sprite from the system texture over a world position.
     *
     * @mangled SetSprite__12CDamageScoreFPfiiii
     * @address 0x1CBE50
     * @size 0x90
     */
    void SetSprite(float *pos, int u, int v, int u1, int v1);

    /**
     *
     * Draws the number or the sprite.
     *
     * @mangled Draw__12CDamageScoreFv
     * @address 0x1CBEE0
     * @size 0x330
     */
    void Draw();

    /**
     *
     * Bounces and fades the number, and ends it once it has faded out.
     *
     * @mangled Step__12CDamageScoreFv
     * @address 0x1CC210
     * @size 0x1B0
     */
    void Step();
};

STATIC_ASSERT(sizeof(CDamageScore) == 0x90);

/**
 *
 * Number that jumps up over a character of the scene when the character takes damage.
 *
 */
class CDamageScore2 {
public:
    s32   chara_no; /**< Index in the scene of the character that the number is drawn over. */
    float height;   /**< Height above the character's position at which the number is drawn. */
    float offset_y; /**< Screen offset of the jump. */
    float alpha;    /**< Opacity of the number, from 0.0 to 1.0. */
    s32   value;    /**< Number shown. */
    char  text[8];  /**< Digits of the number. */
    s32   phase;    /**< Current stage, a ::DamageScore2Phase. */
    s32   length;   /**< Number of digits in the text. */
    float progress; /**< Progress through the current phase. */

    /**
     *
     * Pops up a number over a character of the scene.
     *
     * @mangled SetValue__13CDamageScore2Fiif
     * @address 0x1CC3C0
     * @size 0x70
     */
    void SetValue(int slot, int value, float height);

    /**
     *
     * Draws the number over its character.
     *
     * @mangled Draw__13CDamageScore2FP6CScene
     * @address 0x1CC430
     * @size 0x220
     */
    void Draw(CScene *scene);

    /**
     *
     * Moves the number through its phases.
     *
     * @mangled Step__13CDamageScore2Fv
     * @address 0x1CC650
     * @size 0x190
     */
    void Step();
};

STATIC_ASSERT(sizeof(CDamageScore2) == 0x28);

/**
 *
 * Marker that spins over the enemy that the player has locked on to, with the enemy's name.
 *
 */
class CLockOnModel : public CObjectFrame {
public:
    CScene       *scene; /**< Scene whose characters are looked up. */
    ClsMes       *mes;   /**< Message window that shows the enemy's name. */
    float         angle; /**< Angle, in radians, by which the marker is turned. */
    char         *name;  /**< Name of the locked-on enemy; NULL when none is shown. */
    s32           message_no;
    u8            unk_94[0xC];
    sceVu0FVECTOR pos; /**< World position of the marker and of the name. */

    /**
     *
     * Draws the marker over the enemy that the player is locked on to, as a model or as a
     * sprite.
     *
     * @mangled Draw__12CLockOnModelFv
     * @address 0x1CC7E0
     * @size 0x3D0
     */
    virtual void Draw();

    /**
     *
     * Spins the marker.
     *
     * @mangled Step__12CLockOnModelFv
     * @address 0x1CCC60
     * @size 0x60
     */
    virtual void Step();

    /**
     *
     * Attaches the marker to a scene and clears the name.
     *
     * @mangled Initialize__12CLockOnModelFP6CScene
     * @address 0x1CD120
     * @size 0x10
     */
    virtual void Initialize(CScene *scene);

    /**
     *
     * Shows the name of the locked-on enemy in its message window.
     *
     * @mangled DrawMess__12CLockOnModelFi
     * @address 0x1CCBB0
     * @size 0xB0
     */
    void DrawMess(int tex_block);
};

STATIC_ASSERT(sizeof(CLockOnModel) == 0xB0);

/**
 *
 * Warnings that flash over the status board's gauges while they run low.
 *
 */
class CWarningGage2 {
public:
    s32   warning[3]; /**< Nonzero for each gauge that is low. */
    s32   time;       /**< Frame of the flash cycle; the warnings show in the second half of it. */
    float rate[3];    /**< How full each gauge is; an empty gauge shows a different warning. */
    s32   layout;     /**< Board that the warnings are placed over, a ::WarningGageLayout. */

    /**
     *
     * Advances the flash cycle.
     *
     * @mangled Step__13CWarningGage2Fv
     * @address 0x1CCCC0
     * @size 0x30
     */
    void Step();

    /**
     *
     * Draws the warnings of the low gauges.
     *
     * @mangled Draw__13CWarningGage2Fv
     * @address 0x1CCCF0
     * @size 0x430
     */
    void Draw();
};

STATIC_ASSERT(sizeof(CWarningGage2) == 0x20);
