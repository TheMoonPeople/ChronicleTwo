#pragma once

#include "common.h"

#include <libvu0.h>

#include "mg_visual.hpp"

/**
 * @file
 * Declares the engine's transformable object, the frame hierarchy built on it, and the drawing attributes each frame carries.
 */

class mgCVisual;
class mgCDrawManager;
class mgRENDER_INFO;
struct mgVu0FBOX;
struct mgMaterial;

/**
 *
 * Bits of a frame attribute's draw field, which say whether a frame and its children are drawn.
 *
 */
enum mgFrameDrawFlag {
    MG_FRAME_DRAW_VISIBLE        = 1, /**< Draws the frame's own visual. */
    MG_FRAME_DRAW_SKIP_CHILDREN  = 2, /**< Leaves the frame's children undrawn. */
    MG_FRAME_DRAW_SKIP_BY_PARENT = 4, /**< Makes the parent skip this frame and its subtree. */
};

/**
 *
 * Ways a frame turns to face the camera, as a frame attribute's billboard field holds them.
 *
 */
enum mgFrameBillboard {
    MG_FRAME_BILLBOARD_NONE = 0, /**< Keeps the hierarchy's orientation. */
    MG_FRAME_BILLBOARD_FULL = 1, /**< Turns about the vertical axis and tilts to face the camera. */
    MG_FRAME_BILLBOARD_Y    = 2, /**< Turns only about the vertical axis to face the camera. */
};

/**
 *
 * Bits of a frame's rotation type, which say how its rotation enters its local matrix.
 *
 */
enum mgFrameRotType {
    MG_FRAME_ROT_APPLY        = 1, /**< Applies the object's rotation angles to the local matrix. */
    MG_FRAME_ROT_LOCAL_ORIGIN = 2, /**< Rotates about the frame's own origin, leaving the translation unrotated; implies MG_FRAME_ROT_APPLY. */
};

/**
 *
 * Bits of the mask given to mgCFrame::SetAttrParam, each naming the attribute field it copies.
 *
 */
enum mgFrameAttrParam {
    MG_FRAME_ATTR_DRAW          = 0x1,      /**< Copies the draw flags. */
    MG_FRAME_ATTR_ALPHA_REF     = 0x2,      /**< Copies the visual attribute at offset 0x0 (alpha test reference). */
    MG_FRAME_ATTR_ALPHA_BLEND   = 0x4,      /**< Copies the visual attribute at offset 0x4 (alpha blending mode). */
    MG_FRAME_ATTR_Z_WRITE       = 0x8,      /**< Copies the visual attribute at offset 0x8 (depth write). */
    MG_FRAME_ATTR_Z_TEST        = 0x10,     /**< Copies the visual attribute at offset 0xC (depth test). */
    MG_FRAME_ATTR_CLIP          = 0x20,     /**< Copies clip_enable. */
    MG_FRAME_ATTR_UNK_20        = 0x40,     /**< Copies the field at offset 0x20. */
    MG_FRAME_ATTR_UNK_24        = 0x80,     /**< Copies the field at offset 0x24. */
    MG_FRAME_ATTR_UNK_28        = 0x100,    /**< Copies the field at offset 0x28. */
    MG_FRAME_ATTR_PROGRAM_OPT   = 0x200,    /**< Copies program_option. */
    MG_FRAME_ATTR_FOG           = 0x400,    /**< Copies fog. */
    MG_FRAME_ATTR_UNK_34        = 0x800,    /**< Copies the field at offset 0x34. */
    MG_FRAME_ATTR_UNK_38        = 0x1000,   /**< Copies the field at offset 0x38. */
    MG_FRAME_ATTR_UNK_3C        = 0x2000,   /**< Copies the field at offset 0x3C. */
    MG_FRAME_ATTR_PROGRAM_MODE  = 0x4000,   /**< Copies program_mode. */
    MG_FRAME_ATTR_NO_LIGHT      = 0x8000,   /**< Copies no_light. */
    MG_FRAME_ATTR_COLOR         = 0x10000,  /**< Copies color. */
    MG_FRAME_ATTR_POINT_LIGHT   = 0x20000,  /**< Copies point_light. */
    MG_FRAME_ATTR_OBJ_ALPHA     = 0x40000,  /**< Copies obj_alpha. */
    MG_FRAME_ATTR_BILLBOARD     = 0x80000,  /**< Copies billboard. */
    MG_FRAME_ATTR_NO_CULL       = 0x100000, /**< Copies no_cull. */
    MG_FRAME_ATTR_DEPTH_BIAS    = 0x200000, /**< Copies depth_bias. */
    MG_FRAME_ATTR_DEST_ALPHA    = 0x400000, /**< Copies the visual attribute at offset 0x14 (destination alpha test). */
    MG_FRAME_ATTR_AMBIENT_BOOST = 0x800000, /**< Copies ambient_boost. */
};

/**
 *
 * Drawing attributes of one frame: the visual's GS settings plus visibility, lighting, fog and billboarding.
 *
 */
class mgCFrameAttr : public mgCVisualAttr {
public:
    int           draw;            /**< Visibility bits, from mgFrameDrawFlag; set by the 'V' name flag. */
    int           clip_enable;     /**< Whether a frame crossing the screen's guard band is drawn with clipping; set by the 'N' name flag. */
    float         unk_20;
    int           unk_24;
    int           unk_28;
    int           program_option;  /**< Sets bit 2 of the microprogram's draw flags; set by the 'S' name flag. */
    int           fog;             /**< Fog mode: 0 off, 1 the scene's fog colour, 2 black fog, 3 white fog; set by the 'F' name flag. */
    int           unk_34;
    float         unk_38;
    int           unk_3c;
    int           program_mode;    /**< Microprogram mode bits; nonzero also sends the eye position in model space; set by the 'M' name flag. */
    float         obj_alpha;       /**< Factor applied to the alpha of the frame's ambient and material colours. */
    int           no_cull;         /**< Whether the frame is drawn without testing its bound against the screen. */
    int           ambient_boost;   /**< Whether the ambient light gains 30% of the first light's colour; set by the 'T' name flag. */
    sceVu0FVECTOR unk_50;
    int           no_light;        /**< Whether the frame is drawn without the scene's lights; set by the 'C0' name flag. */
    sceVu0FVECTOR color;           /**< Colour handed to the renderer while the frame is drawn. */
    int           point_light;     /**< Whether the frame is lit by the point lights its bounding sphere reaches. */
    int           unk_84;
    int           billboard;       /**< Billboard mode, from mgFrameBillboard; set by the 'BA' and 'BY' name flags. */
    float         depth_bias;      /**< Above 1.0, pulls the frame's depth forward so it draws over coplanar geometry; set by the 'Zp' name flag. */

    /**
     * Makes a set of attributes with every field at its default.
     *
     * @mangled __ct__12mgCFrameAttrFv
     * @address 0x1361F0
     * @size 0x30
     */
    mgCFrameAttr();

    /**
     * Puts every field back to its default: drawn, full alpha, grey colour,
     * depth written, no billboard.
     *
     * @mangled Initialize__12mgCFrameAttrFv
     * @address 0x136160
     * @size 0x90
     */
    void Initialize();
};

STATIC_ASSERT(sizeof(mgCFrameAttr) == 0x90);

/**
 *
 * An object with a position, a rotation and a scale, which remembers whether they changed since its matrix was last built.
 *
 */
class mgCObject {
public:
    /**
     * Marks the object's transform as changed.
     *
     * @mangled ChangeParam__9mgCObjectFv
     * @address 0x138EA0
     * @size 0x10
     */
    virtual void ChangeParam();

    /**
     * Marks the object's transform as changed so its matrix is rebuilt from
     * its parts.
     *
     * @mangled UseParam__9mgCObjectFv
     * @address 0x138EB0
     * @size 0x10
     */
    virtual void UseParam();

    /**
     * Puts the object at a position, marking it changed if the position differs.
     *
     * @mangled SetPosition__9mgCObjectFPf
     * @address 0x136820
     * @size 0x90
     */
    virtual void SetPosition(float *position);

    /**
     * Puts the object at a position, marking it changed if the position differs.
     *
     * @mangled SetPosition__9mgCObjectFfff
     * @address 0x1368B0
     * @size 0x40
     */
    virtual void SetPosition(float x, float y, float z);

    /**
     * Gets the object's position.
     *
     * @mangled GetPosition__9mgCObjectFPf
     * @address 0x1368F0
     * @size 0x10
     */
    virtual void GetPosition(float *out_position);

    /**
     * Turns the object to an angle about each axis, marking it changed if
     * the angles differ.
     *
     * @mangled SetRotation__9mgCObjectFPf
     * @address 0x136900
     * @size 0x80
     */
    virtual void SetRotation(float *rotation);

    /**
     * Turns the object to an angle about each axis, marking it changed if
     * the angles differ.
     *
     * @mangled SetRotation__9mgCObjectFfff
     * @address 0x136980
     * @size 0x40
     */
    virtual void SetRotation(float x, float y, float z);

    /**
     * Gets the object's angle about each axis.
     *
     * @mangled GetRotation__9mgCObjectFPf
     * @address 0x1369C0
     * @size 0x10
     */
    virtual void GetRotation(float *out_rotation);

    /**
     * Sets the object's scale along each axis, marking it changed if the
     * scale differs.
     *
     * @mangled SetScale__9mgCObjectFPf
     * @address 0x1369D0
     * @size 0x80
     */
    virtual void SetScale(float *scale);

    /**
     * Sets the object's scale along each axis, marking it changed if the
     * scale differs.
     *
     * @mangled SetScale__9mgCObjectFfff
     * @address 0x136A50
     * @size 0x40
     */
    virtual void SetScale(float x, float y, float z);

    /**
     * Gets the object's scale along each axis.
     *
     * @mangled GetScale__9mgCObjectFPf
     * @address 0x136A90
     * @size 0x10
     */
    virtual void GetScale(float *out_scale);

    /**
     * Draws the object. The base object draws nothing.
     *
     * @mangled Draw__9mgCObjectFv
     * @address 0x138ED0
     * @size 0x10
     */
    virtual int Draw();

    /**
     * Draws the object immediately. The base object draws nothing.
     *
     * @mangled DrawDirect__9mgCObjectFv
     * @address 0x138EC0
     * @size 0x10
     */
    virtual int DrawDirect();

    /**
     * Puts the object at the origin, unrotated, at a scale of one, with its
     * transform marked as changed.
     *
     * @mangled Initialize__9mgCObjectFv
     * @address 0x136AA0
     * @size 0x80
     */
    virtual void Initialize();

    /**
     * Makes an object at the origin, unrotated, at a scale of one.
     *
     * @mangled __ct__9mgCObjectFv
     * @address 0x163200
     * @size 0x40
     */
    mgCObject() { Initialize(); }

    sceVu0FVECTOR position; /**< Position of the object; w is 1. */
    sceVu0FVECTOR rotation; /**< Angle, in radians, about each axis; w is 0. */
    sceVu0FVECTOR scale;    /**< Scale along each axis; w is 0. */
    int           changed;  /**< Whether the transform changed since the cached world matrix was built. */
    int           use_srt;  /**< Whether the local matrix is built from scale, rotation and position instead of taken as set. */
};

STATIC_ASSERT(sizeof(mgCObject) == 0x50);

/**
 *
 * The object that frames derive from, adding nothing to the object but its own initialisation.
 *
 */
class mgCFrameBase : public mgCObject {
public:
    /**
     * Initialises the frame as an object.
     *
     * @mangled Initialize__12mgCFrameBaseFv
     * @address 0x136BA0
     * @size 0x10
     */
    virtual void Initialize() { mgCObject::Initialize(); }

    /**
     * Makes a frame base at the origin, unrotated, at a scale of one.
     */
    mgCFrameBase() { Initialize(); }
};

STATIC_ASSERT(sizeof(mgCFrameBase) == 0x50);

/**
 *
 * A named node of the model hierarchy: a transform linked to its parent, children and siblings, with a bound, drawing attributes and a visual.
 *
 */
class mgCFrame : public mgCFrameBase {
public:
    /**
     *
     * Bounding box and sphere of a frame in its local space.
     *
     */
    struct BoundCorners { float v[32]; };
    struct BoundInfo {
        sceVu0FVECTOR corner[8]; /**< Eight corners of the bounding box, each with w of 1. */
        sceVu0FVECTOR max;       /**< Maximum corner of the bounding box. */
        sceVu0FVECTOR min;       /**< Minimum corner of the bounding box. */
        float         center[3]; /**< Centre of the bounding sphere. */
        float         radius;    /**< Radius of the bounding sphere. */
    };

    char          *name;          /**< Frame name, whose part after "--" carries attribute flags. */
    mgCFrame      *parent;        /**< Parent frame, or the followed frame while reference is set. */
    mgCFrame      *child;         /**< First child frame, or null. */
    mgCFrame      *brother;       /**< Next sibling frame, or null. */
    mgCFrame      *elder;         /**< Previous sibling frame, or null. */
    int            frame_num;     /**< Number of frames in frame_list. */
    mgCFrame     **frame_list;    /**< Every frame of the model in load order, kept on the root frame. */
    float        (*init_matrix)[4][4]; /**< Local-to-world matrix of each frame in frame_list as loaded, kept on the root frame. */
    sceVu0FMATRIX lw_matrix;      /**< Cached local-to-world matrix. */
    sceVu0FMATRIX trans_matrix;   /**< Local transform, used as set while use_srt is clear. */
    BoundInfo     *bound;         /**< Bounding box and sphere, or null. */
    mgCFrameAttr  *attr;          /**< Drawing attributes, or null. */
    mgCVisual     *visual;        /**< Visual drawn at the frame, or null. */
    int            reference;     /**< Whether parent is a followed frame rather than a true parent. */
    int            rot_type;      /**< Rotation bits, from mgFrameRotType. */

    /**
     * Turns the frame to an angle about each axis and makes the rotation apply.
     *
     * @mangled SetRotation__8mgCFrameFPf
     * @address 0x137F60
     * @size 0x10
     */
    virtual void SetRotation(float *rotation);

    /**
     * Turns the frame to an angle about each axis and makes the rotation apply.
     *
     * @mangled SetRotation__8mgCFrameFfff
     * @address 0x137F70
     * @size 0x50
     */
    virtual void SetRotation(float x, float y, float z);

    /**
     * Draws the frame and its subtree into the render info's packet.
     *
     * @mangled Draw__8mgCFrameFv
     * @address 0x138E80
     * @size 0x20
     */
    virtual int Draw();

    /**
     * Unlinks the frame from every neighbour and clears its transform,
     * matrices, bound, attributes and visual.
     *
     * @mangled Initialize__8mgCFrameFv
     * @address 0x136BB0
     * @size 0x70
     */
    virtual void Initialize();

    /**
     * Gets the world-space box around the frame's bound and those of its
     * subtree. Returns whether any bound was found.
     *
     * @mangled GetWorldBBox__8mgCFrameFP9mgVu0FBOX
     * @address 0x136F20
     * @size 0x1F0
     */
    virtual int GetWorldBBox(mgVu0FBOX *box);

    /**
     * Draws the frame's visual, unless it lies off screen, and then its
     * children. Returns the number of quadwords written to the packet.
     *
     * @mangled Draw__8mgCFrameFPUi
     * @address 0x1384A0
     * @size 0x3B0
     */
    virtual int Draw(unsigned int *packet);

    /**
     * Sets the visual drawn at the frame.
     *
     * @mangled SetVisual__8mgCFrameFP9mgCVisual
     * @address 0x133410
     * @size 0x10
     */
    virtual void SetVisual(mgCVisual *visual);

    /**
     * Makes an unlinked frame at the origin with no bound, attributes or visual.
     *
     * @mangled __ct__8mgCFrameFv
     * @address 0x136B20
     * @size 0x80
     */
    mgCFrame();

    /**
     * Sets the frame's name.
     *
     * @mangled SetName__8mgCFrameFPc
     * @address 0x136C20
     * @size 0x10
     */
    void SetName(char *name);

    /**
     * Sets the rotation of the local transform from a quaternion, keeping
     * its translation.
     *
     * @mangled SetTransMatrix__8mgCFrameFPf
     * @address 0x136C30
     * @size 0x50
     */
    void SetTransMatrix(float *quaternion);

    /**
     * Sets the frame's bounding box and the eight corners made from it.
     *
     * @mangled SetBBox__8mgCFrameFPfPf
     * @address 0x136C80
     * @size 0x100
     */
    void SetBBox(float *max, float *min);

    /**
     * Gets the frame's bounding box, or zero vectors when it has no bound.
     *
     * @mangled GetBBox__8mgCFrameFPfPf
     * @address 0x136D80
     * @size 0x70
     */
    void GetBBox(float *out_max, float *out_min);

    /**
     * Sets the frame's bounding sphere.
     *
     * @mangled SetBSphere__8mgCFrameFPff
     * @address 0x136DF0
     * @size 0x50
     */
    void SetBSphere(float *center, float radius);

    /**
     * Gets a frame of the model by its index in the frame list, or null.
     *
     * @mangled GetFrame__8mgCFrameFi
     * @address 0x136E40
     * @size 0x50
     */
    mgCFrame *GetFrame(int index);

    /**
     * Has the visual measure its current box and makes that the frame's
     * bounding box. Returns whether the visual gave a box.
     *
     * @mangled RemakeBBox__8mgCFrameFPfPf
     * @address 0x136E90
     * @size 0x90
     */
    int RemakeBBox(float *out_max, float *out_min);

    /**
     * Counts the frame and every frame of its subtree.
     *
     * @mangled GetFrameNum__8mgCFrameFv
     * @address 0x137110
     * @size 0x60
     */
    int GetFrameNum();

    /**
     * Makes a frame the parent of this one, if it has none.
     *
     * @mangled SetParent__8mgCFrameFP8mgCFrame
     * @address 0x137170
     * @size 0x40
     */
    void SetParent(mgCFrame *parent);

    /**
     * Adds a frame at the end of this frame's chain of siblings.
     *
     * @mangled SetBrother__8mgCFrameFP8mgCFrame
     * @address 0x1371B0
     * @size 0x40
     */
    void SetBrother(mgCFrame *brother);

    /**
     * Adds a frame as the last child of this one.
     *
     * @mangled SetChild__8mgCFrameFP8mgCFrame
     * @address 0x1371F0
     * @size 0x60
     */
    void SetChild(mgCFrame *child);

    /**
     * Unlinks the frame from its parent and siblings.
     *
     * @mangled DeleteParent__8mgCFrameFv
     * @address 0x137250
     * @size 0x70
     */
    void DeleteParent();

    /**
     * Makes the frame follow another frame's transform without becoming its
     * child, if it has no parent.
     *
     * @mangled SetReference__8mgCFrameFP8mgCFrame
     * @address 0x1372C0
     * @size 0x30
     */
    void SetReference(mgCFrame *reference);

    /**
     * Stops the frame following another frame's transform.
     *
     * @mangled DeleteReference__8mgCFrameFv
     * @address 0x1372F0
     * @size 0x20
     */
    void DeleteReference();

    /**
     * Marks every direct child's transform as changed.
     *
     * @mangled ClearChildFlag__8mgCFrameFv
     * @address 0x137310
     * @size 0x60
     */
    void ClearChildFlag();

    /**
     * Gets the frame's local matrix: the local transform as set, or one
     * built from scale, rotation and position.
     *
     * @mangled GetLocalMatrix__8mgCFrameFPA4_f
     * @address 0x137370
     * @size 0x160
     */
    void GetLocalMatrix(float (*matrix)[4]);

    /**
     * Gets a local-to-world matrix that keeps the frame's position and scale
     * but turns it to face the eye, and caches it as the world matrix.
     *
     * @mangled GetBBoardMatrix__8mgCFrameFiPA4_fP13mgRENDER_INFO
     * @address 0x1374D0
     * @size 0x1F0
     */
    void GetBBoardMatrix(int mode, float (*matrix)[4], mgRENDER_INFO *info);

    /**
     * Gets the frame's local-to-world matrix, rebuilding the cached one when
     * the frame or any ancestor changed.
     *
     * @mangled GetLWMatrix__8mgCFrameFPA4_f
     * @address 0x1376C0
     * @size 0x180
     */
    void GetLWMatrix(float (*matrix)[4]);

    /**
     * Gets the frame's local-to-world matrix from its parent's cached one,
     * for walks of the hierarchy that visit parents first.
     *
     * @mangled GetLWMatrixTopBottom__8mgCFrameFPA4_f
     * @address 0x137840
     * @size 0x170
     */
    void GetLWMatrixTopBottom(float (*matrix)[4]);

    /**
     * Gets the inverse of the frame's local-to-world matrix.
     *
     * @mangled GetInverseMatrix__8mgCFrameFPA4_f
     * @address 0x1379B0
     * @size 0x270
     */
    void GetInverseMatrix(float (*matrix)[4]);

    /**
     * Sets the frame's local transform.
     *
     * @mangled SetTransMatrix__8mgCFrameFPA4_f
     * @address 0x137C20
     * @size 0x30
     */
    void SetTransMatrix(float (*matrix)[4]);

    /**
     * Finds the frame of a name in this frame's subtree, comparing names up
     * to their "--" flags, or null.
     *
     * @mangled SearchFrame__8mgCFrameFPc
     * @address 0x137D60
     * @size 0x80
     */
    mgCFrame *SearchFrame(char *name);

    /**
     * Finds the index in the frame list of the frame of a name, or -1.
     *
     * @mangled SearchFrameID__8mgCFrameFPc
     * @address 0x137DE0
     * @size 0x90
     */
    int SearchFrameID(char *name);

    /**
     * Moves a point from the frame's space into the world.
     *
     * @mangled GetWorldPosition__8mgCFrameFPfPf
     * @address 0x137E70
     * @size 0x50
     */
    void GetWorldPosition(float *out_position, float *local_position);

    /**
     * Gets the world position of the frame's origin.
     *
     * @mangled GetWorldPosition0__8mgCFrameFPf
     * @address 0x137EC0
     * @size 0x40
     */
    void GetWorldPosition0(float *out_position);

    /**
     * Turns a direction from the frame's space into the world.
     *
     * @mangled GetWorldDir__8mgCFrameFPfPf
     * @address 0x137F00
     * @size 0x60
     */
    void GetWorldDir(float *out_dir, float *local_dir);

    /**
     * Sets how the frame's rotation enters its local matrix.
     *
     * @mangled SetRotType__8mgCFrameFi
     * @address 0x137FC0
     * @size 0x20
     */
    void SetRotType(int type);

    /**
     * Copies attributes into the frame's own, all of them or those a mask of
     * mgFrameAttrParam bits names, optionally through its subtree.
     *
     * @mangled SetAttrParam__8mgCFrameFR12mgCFrameAttrii
     * @address 0x137FE0
     * @size 0x3E0
     */
    void SetAttrParam(mgCFrameAttr &attr, int children, int mask);

    /**
     * Sets the frame's alpha factor, optionally through its subtree.
     *
     * @mangled SetAttrParamObjAlpha__8mgCFrameFfi
     * @address 0x1383C0
     * @size 0x70
     */
    void SetAttrParamObjAlpha(float alpha, int children);

    /**
     * Sets the frame's draw flags, optionally through its subtree.
     *
     * @mangled SetAttrParamDraw__8mgCFrameFii
     * @address 0x138430
     * @size 0x70
     */
    void SetAttrParamDraw(int draw, int children);

    /**
     * Gets the screen rectangle that the frame and its subtree cover.
     * Returns whether any part is on screen.
     *
     * @mangled GetDrawRect__8mgCFrameFP9mgVu0FBOXP14mgCDrawManager
     * @address 0x138850
     * @size 0x500
     */
    int GetDrawRect(mgVu0FBOX *rect, mgCDrawManager *manager);

    /**
     * Copies another frame's contents, leaving this frame unlinked and
     * marking its transform changed.
     *
     * @mangled __as__8mgCFrameFR8mgCFrame
     * @address 0x138D50
     * @size 0x130
     */
    mgCFrame &operator=(mgCFrame &other);

    /**
     * Gets a material of the frame's visual, or null when it has none.
     *
     * @mangled GetMaterial__8mgCFrameFi
     * @address 0x163D00
     * @size 0x30
     * @unknownret
     */
    mgMaterial *GetMaterial(int index);

    /**
     * Sets the frame's bounding box and sphere.
     *
     * @mangled SetBound__8mgCFrameFPQ28mgCFrame9BoundInfo
     * @address 0x165510
     * @size 0x10
     */
    void SetBound(BoundInfo *bound) { this->bound = bound; }
};

STATIC_ASSERT(sizeof(mgCFrame::BoundInfo) == 0xB0);
STATIC_ASSERT(sizeof(mgCFrame) == 0x110);

/**
 * Compares two frame names up to their "--" flags. Returns whether they match.
 *
 * @mangled mgFrameNameComp__FPcPc
 * @address 0x137D50
 * @size 0x10
 */
int mgFrameNameComp(char *left, char *right);

/**
 * Tests whether a box in world space reaches the screen.
 *
 * @mangled mgInsideScreen__FP9mgVu0FBOX
 * @address 0x136520
 * @size 0x50
 */
int mgInsideScreen(mgVu0FBOX *box);

/**
 * Tests whether a box, moved by a matrix, reaches the screen.
 *
 * @mangled mgInsideScreen__FP9mgVu0FBOXPA4_f
 * @address 0x136570
 * @size 0x40
 */
int mgInsideScreen(mgVu0FBOX *box, float (*matrix)[4]);

/**
 * Tests whether a box, moved by a matrix, reaches the screen, and gets the
 * screen-space box it covers.
 *
 * @mangled mgInsideScreen__FP9mgVu0FBOXPA4_fPfPf
 * @address 0x1365B0
 * @size 0x60
 */
int mgInsideScreen(mgVu0FBOX *box, float (*matrix)[4], float *out_max, float *out_min);

/**
 * Tests whether eight corners, moved by a matrix, reach the screen.
 *
 * @mangled mgInsideScreen__FPA4_fPA4_f
 * @address 0x136610
 * @size 0x20
 */
int mgInsideScreen(float (*corners)[4], float (*matrix)[4]);

/**
 * Tests whether eight corners, moved by a matrix, reach the screen, and gets
 * the screen-space box they cover.
 *
 * @mangled mgInsideScreen__FPA4_fPA4_fPfPf
 * @address 0x136630
 * @size 0x1F0
 */
int mgInsideScreen(float (*corners)[4], float (*matrix)[4], float *out_max, float *out_min);
