#pragma once

#include "common.h"

#include "object.hpp"

/**
 * @file
 * Declares the lists of model, collision and character data loaded from
 * PCP pack files, the lists of IMG texture files loaded beside them, and
 * the map piece that places one entry of model data in a map part.
 */

class CCharacter2;
class mgCEnterIMGInfo;
class mgCFrame;
class mgCMemory;
class PieceMaterial;
struct CCPoly;
struct mgVu0FBOX;

/**
 *
 * Kinds of data an entry of a PCP pack file holds, and so which loader builds it.
 *
 */
// clang-format off
enum MdsType {
    MDS_TYPE_MODEL            = 0, /**< Model drawn by a frame. */
    MDS_TYPE_COLLISION        = 1, /**< Collision geometry that characters stand on and bump into. */
    MDS_TYPE_CAMERA_COLLISION = 3, /**< Collision geometry that keeps the camera out. */
    MDS_TYPE_CHARA            = 4, /**< Character with its own motion. */
};

// clang-format on
/**
 *
 * One entry of a PCP pack file: the data it was loaded as and the far-clip settings it gives the pieces that use it.
 *
 */
class CMdsInfo {
public:
    char        *name;     /**< Name the entry is found by. */
    int          type; /**< Kind of data the entry holds, an MdsType. */
    mgCFrame    *frame;    /**< Frame built from the entry's data, or NULL. */
    CCharacter2 *chara;    /**< Character built from the entry's data when it is an MDS_TYPE_CHARA, or NULL. */
    float        far_dist; /**< Distance beyond which a piece using the entry is not drawn, or a negative value for none. */
    int          far_fade; /**< Non-zero fades a piece using the entry in and out at the far distance instead of cutting it. */

    /**
     *
     * Creates an entry that holds no data.
     *
     * @mangled __ct__8CMdsInfoFv
     * @address 0x16AC90
     * @size 0x3C
     */
    CMdsInfo();

    /**
     *
     * Clears the entry to hold no data and no far distance.
     *
     * @mangled Initialize__8CMdsInfoFv
     * @address 0x169F70
     * @size 0x20
     */
    virtual void Initialize();

    int unk_1c;
};

STATIC_ASSERT(sizeof(CMdsInfo) == 0x20);

/**
 *
 * The entries of one loaded PCP pack file, found by name.
 *
 */
class CMdsList {
public:
    char     *name; /**< Name of the pack file the entries were loaded from, or NULL while the slot is free. */
    int       num; /**< Number of entries. */
    CMdsInfo *list; /**< Entries, num long. */
    int       unk_c;

    /**
     *
     * Gets an entry by its index, or NULL when the index is out of range.
     *
     * @mangled GetList__8CMdsListFi
     * @address 0x16A560
     * @size 0x38
     */
    CMdsInfo *GetList(int index);

    /**
     *
     * Gets the index of the entry with a name, ignoring case, or -1 when there is none.
     *
     * @mangled GetListID__8CMdsListFPc
     * @address 0x16A5A0
     * @size 0xA4
     */
    int GetListID(char *name);

    /**
     *
     * Gets the entry with a name, ignoring case, or NULL when there is none.
     *
     * @mangled GetList__8CMdsListFPc
     * @address 0x16A650
     * @size 0x3C
     */
    CMdsInfo *GetList(char *name);

    /**
     *
     * Builds an entry for every model and character file of a pack file, as its script lists them.
     *
     * @mangled LoadPCPFile__8CMdsListFPcPUiP9mgCMemoryi
     * @address 0x16AAC0
     * @size 0x1C8
     */
    void LoadPCPFile(char *name, unsigned int *pack, mgCMemory *stack, int all_scissor);
};

STATIC_ASSERT(sizeof(CMdsList) == 0x10);

/**
 *
 * One loaded IMG texture file and the texture blocks its textures were entered into.
 *
 */
class CIMGList {
public:
    char            *name; /**< Name of the IMG file, or NULL while the slot is free. */
    mgCEnterIMGInfo *info; /**< Texture blocks the file's textures were entered into, or NULL when not recorded. */

    /**
     *
     * Records the name of an IMG file and a copy of where its textures were entered.
     *
     * @mangled LoadIMGFile__8CIMGListFPcP15mgCEnterIMGInfoP9mgCMemory
     * @address 0x16A690
     * @size 0x110
     */
    int LoadIMGFile(char *name, mgCEnterIMGInfo *info, mgCMemory *stack);
};

STATIC_ASSERT(sizeof(CIMGList) == 0x8);

/**
 *
 * The PCP pack files and IMG texture files a scene has loaded, searched together for model data and texture blocks.
 *
 */
class CMdsListSet {
public:
    int      mds_list_num; /**< Number of slots in mds_list. */
    u_char       unk_4[0xC];
    CMdsList mds_list[8];  /**< Loaded pack files. */
    int      img_list_num; /**< Number of slots in img_list. */
    CIMGList img_list[16]; /**< Loaded IMG files. */

    /**
     *
     * Gets the loaded pack file with a name, or NULL when there is none.
     *
     * @mangled SearchMdsList__11CMdsListSetFPc
     * @address 0x169F90
     * @size 0x98
     */
    CMdsList *SearchMdsList(char *name);

    /**
     *
     * Gets a pack file slot by its index, or NULL when the index is out of range.
     *
     * @mangled GetMdsList__11CMdsListSetFi
     * @address 0x16A030
     * @size 0x34
     */
    CMdsList *GetMdsList(int index);

    /**
     *
     * Gets the entry with a name from any loaded pack file, or NULL when there is none.
     *
     * @mangled SearchMDS__11CMdsListSetFPc
     * @address 0x16A070
     * @size 0x74
     */
    CMdsInfo *SearchMDS(char *name);

    /**
     *
     * Loads a pack file into a free slot unless one with the same name is loaded, and reports whether it was loaded.
     *
     * @mangled LoadPCPFile__11CMdsListSetFPcPUiP9mgCMemoryi
     * @address 0x16A0F0
     * @size 0x108
     */
    int LoadPCPFile(char *name, unsigned int *pack, mgCMemory *stack, int all_scissor);

    /**
     *
     * Frees the slot of the loaded pack file with a name, and reports whether there was one.
     *
     * @mangled DeleteMdsList__11CMdsListSetFPc
     * @address 0x16A200
     * @size 0x3C
     */
    int DeleteMdsList(char *name);

    /**
     *
     * Records an IMG file in a free slot unless one with the same name is recorded, and reports whether it was recorded.
     *
     * @mangled LoadIMGFile__11CMdsListSetFPcP15mgCEnterIMGInfoP9mgCMemory
     * @address 0x16A240
     * @size 0xD0
     */
    int LoadIMGFile(char *name, mgCEnterIMGInfo *info, mgCMemory *stack);

    /**
     *
     * Frees the slot of the recorded IMG file with a name.
     *
     * @mangled DeleteIMG__11CMdsListSetFPc
     * @address 0x16A310
     * @size 0x2C
     */
    void DeleteIMG(char *name);

    /**
     *
     * Gets the recorded IMG file with a name, or NULL when there is none.
     *
     * @mangled SearchIMGList__11CMdsListSetFPc
     * @address 0x16A340
     * @size 0xA0
     */
    CIMGList *SearchIMGList(char *name);

    /**
     *
     * Lists, across every recorded IMG file, the texture blocks a texture group was entered into, and returns how many were listed.
     *
     * @mangled GetTextureBlockNo__11CMdsListSetFiPii
     * @address 0x16A3E0
     * @size 0xF8
     */
    int GetTextureBlockNo(int group, int *out_block, int max);

    /**
     *
     * Frees every pack file and IMG file slot.
     *
     * @mangled Initialize__11CMdsListSetFv
     * @address 0x16A4E0
     * @size 0x78
     */
    void Initialize();
};

/**
 *
 * One piece of a map part: an entry of model, collision or character data placed in the part, with the materials it recolours and the time of day it shows in.
 *
 */
class CMapPiece : public CObjectFrame {
public:
    char          *name;         /**< Name of the entry of model data the piece uses. */
    int            type; /**< Kind of data the piece uses, an MdsType. */
    int            draw_enable; /**< Non-zero lets the piece be drawn. */
    int            material_num; /**< Number of materials in material. */
    PieceMaterial *material;     /**< Materials whose colour the piece sets while it is drawn, material_num long. */
    float          time_start;   /**< Start of the time of day the piece shows in. */
    float          time_end;     /**< End of the time of day the piece shows in. */
    CCharacter2   *chara;        /**< Character the piece moves when its data is an MDS_TYPE_CHARA, or NULL. */
    short            col_type; /**< Collision type the map script gives the piece; only pieces of type 0 give collision triangles. */
    short            col_param; /**< Second value the map script gives with the collision type. */

    /**
     *
     * Creates a piece that uses no model data.
     *
     * @mangled __ct__9CMapPieceFv
     * @address 0x1637E0
     * @size 0x44
     */
    CMapPiece() { Initialize(); }

    /**
     *
     * Sets the name of the entry of model data the piece uses.
     *
     * @mangled SetName__9CMapPieceFPc
     * @address 0x163760
     * @size 0x8
     */
    void SetName(char *name) { this->name = name; }

    /**
     *
     * Sets the materials whose colour the piece sets while it is drawn.
     *
     * @mangled SetMaterial__9CMapPieceFP13PieceMateriali
     * @address 0x163B60
     * @size 0xC
     */
    void SetMaterial(PieceMaterial *material, int num) {
        this->material = material;
        material_num   = num;
    }

    /**
     *
     * Clears the piece to use no model data, no materials and no time of day.
     *
     * @mangled Initialize__9CMapPieceFv
     * @address 0x169ED0
     * @size 0x98
     */
    virtual void Initialize();

    /**
     *
     * Draws the piece straight away.
     *
     * @mangled DrawDirect__9CMapPieceFv
     * @address 0x168240
     * @size 0x8
     */
    virtual int DrawDirect();

    /**
     *
     * Draws the piece through the drawing list.
     *
     * @mangled Draw__9CMapPieceFv
     * @address 0x168250
     * @size 0x8
     */
    virtual int Draw();

    /**
     *
     * Makes the piece use an entry of model data, taking its frame, character and far-clip settings, and reports whether there was one.
     *
     * @mangled AssignMds__9CMapPieceFP8CMdsInfo
     * @address 0x169930
     * @size 0x4C
     */
    int AssignMds(CMdsInfo *info);

    /**
     *
     * Copies at most a given number of the piece's collision triangles that meet a box into an array, when its data is of a given type, and returns how many were copied.
     *
     * @mangled GetPoly__9CMapPieceFiP6CCPolyR9mgVu0FBOXi
     * @address 0x169980
     * @size 0xAC
     */
    int GetPoly(int type, CCPoly *poly, mgVu0FBOX &box, int max);

    /**
     *
     * Sets the time of day the piece shows in.
     *
     * @mangled SetTimeBand__9CMapPieceFff
     * @address 0x169A30
     * @size 0xC
     */
    void SetTimeBand(float start, float end);

    /**
     *
     * Gets a material of the piece by its index, or NULL when there is none.
     *
     * @mangled GetMaterial__9CMapPieceFi
     * @address 0x169A40
     * @size 0x44
     */
    PieceMaterial *GetMaterial(int index);

    /**
     *
     * Moves the piece's character on by one frame.
     *
     * @mangled Step__9CMapPieceFv
     * @address 0x169A90
     * @size 0x4C
     */
    void Step();

    /**
     *
     * Gets the world-space bounds of the piece's frame, and reports whether it has a frame.
     *
     * @mangled GetBoundBox__9CMapPieceFP9mgVu0FBOX
     * @address 0x169AE0
     * @size 0x60
     */
    int GetBoundBox(mgVu0FBOX *box);

    /**
     *
     * Draws the piece with its materials' colours, through the drawing list or straight away.
     *
     * @mangled DrawSub__9CMapPieceFi
     * @address 0x169B40
     * @size 0x118
     */
    int DrawSub(int direct);

    /**
     *
     * Copies the piece into another, giving the copy its own materials and character when memory is given.
     *
     * @mangled Copy__9CMapPieceFR9CMapPieceP9mgCMemory
     * @address 0x169C60
     * @size 0x268
     */
    void Copy(CMapPiece &dest, mgCMemory *stack);
};

STATIC_ASSERT(sizeof(CMapPiece) == 0xB0);
