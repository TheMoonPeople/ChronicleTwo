#pragma once

#include "common.h"

#include <libvu0.h>

#include "collision.hpp"
#include "mg_drawenv.hpp"
#include "mg_memory.hpp"

/**
 * @file
 * Declares the river grid of the Georama editor: the cells of a ground part
 * that river can be laid on, and the pieces and turns that make up the river's
 * banks in each quarter of a cell.
 */

/**
 *
 * Counts of the quarters of a river grid cell and of the turns its pieces are drawn at.
 *
 */
enum {
    EDIT_GRID_CORNER_MAX = 4, /**< Quarters of a cell, each drawn with its own river piece. */
    EDIT_GRID_ROT_MAX = 4,    /**< Quarter turns about the vertical axis that river pieces are drawn at. */
};

/**
 *
 * Shapes of the bank in a quarter of a river cell, chosen from which neighbouring cells beside that quarter hold river.
 *
 */
enum EditRiverPiece {
    EDIT_RIVER_PIECE_OUTER = 0,   /**< Neither neighbour beside the quarter holds river. */
    EDIT_RIVER_PIECE_EDGE = 1,    /**< One of the two neighbours beside the quarter holds river. */
    EDIT_RIVER_PIECE_INNER = 2,   /**< Both neighbours beside the quarter hold river, the diagonal one does not. */
    EDIT_RIVER_PIECE_FULL = 3,    /**< Both neighbours and the diagonal one hold river. */
    EDIT_RIVER_PIECE_VARIANT = 4, /**< Added to a shape to use its second model, picked from the cell's position. */
};

/**
 *
 * Cell of a river grid: whether it holds river, and the piece and turn each of its quarters is drawn with.
 *
 */
class CGridData {
public:
    s32 river{};                       /**< Nonzero when the cell holds river. */
    s16 piece[EDIT_GRID_CORNER_MAX]{}; /**< River piece of each quarter, an EditRiverPiece shape. */
    s16 rot[EDIT_GRID_CORNER_MAX]{};   /**< Index into CEditGrid::rot of the turn each quarter's piece is drawn at. */

    /**
     *
     * Makes an empty cell.
     *
     * @mangled __ct__9CGridDataFv
     * @address 0x29B650
     * @size 0x30
     */
    CGridData();
};

STATIC_ASSERT(sizeof(CGridData) == 0x14);

/**
 *
 * Grid of cells laid over a ground part of an edit map, on which the player lays river.
 *
 */
class CEditGrid {
public:
    s32           num_x;  /**< Number of cells along the X axis. */
    s32           num_z;  /**< Number of cells along the Z axis. */
    CGridData    *data;   /**< Cells, row by row along the X axis. */
    float         step_x; /**< Width of a cell along the X axis. */
    float         step_z; /**< Width of a cell along the Z axis. */
    u8            unk_14[0xC];
    sceVu0FVECTOR origin;                 /**< World position of the grid's smallest corner; its height is that of the river. */
    sceVu0FMATRIX rot[EDIT_GRID_ROT_MAX]; /**< Matrices that turn a river piece by each quarter turn about the vertical axis. */

    /**
     *
     * Allocates the cells of a grid of a given number of cells along each axis.
     *
     * @mangled Create__9CEditGridFiiP9mgCMemory
     * @address 0x29B590
     * @size 0xC0
     */
    void Create(int w, int h, mgCMemory *mem);

    /**
     *
     * Takes the river off every cell.
     *
     * @mangled Clear__9CEditGridFv
     * @address 0x29B680
     * @size 0x30
     */
    void Clear();

    /**
     *
     * Puts the grid into the state of having no cells.
     *
     * @mangled Initialize__9CEditGridFv
     * @address 0x29B6B0
     * @size 0x20
     */
    void Initialize();

    /**
     *
     * Returns whether a cell position lies inside the grid.
     *
     * @mangled Check__9CEditGridFii
     * @address 0x29B6D0
     * @size 0x50
     */
    int Check(int x, int y);

    /**
     *
     * Returns the cell at a cell position, or NULL when it lies outside the grid.
     *
     * @mangled Get__9CEditGridFii
     * @address 0x29B720
     * @size 0x60
     */
    CGridData *Get(int x, int y);

    /**
     *
     * Returns the cell at a cell position that is known to lie inside the grid.
     *
     * @mangled GetFast__9CEditGridFii
     * @address 0x29B780
     * @size 0x30
     */
    CGridData *GetFast(int x, int y);

    /**
     *
     * Finds the cell position under a world position, and returns whether it lies inside the grid.
     *
     * @mangled GetLPos__9CEditGridFPiff
     * @address 0x29B7B0
     * @size 0xC0
     */
    int GetLPos(int *cell, float x, float z);

    /**
     *
     * Gives the world position of the smallest corner of a cell.
     *
     * @mangled GetWPos__9CEditGridFPfii
     * @address 0x29B870
     * @size 0x50
     */
    void GetWPos(float *pos, int x, int y);

    /**
     *
     * Lays river on the cell under a world position, and returns whether there was a cell there.
     *
     * @mangled SetRiver__9CEditGridFff
     * @address 0x29B8C0
     * @size 0x40
     */
    int SetRiver(float x, float z);

    /**
     *
     * Takes the river off the cell under a world position, and returns whether there was river to take.
     *
     * @mangled ResetRiver__9CEditGridFff
     * @address 0x29B900
     * @size 0x40
     */
    int ResetRiver(float x, float z);

    /**
     *
     * Lays river on a cell and reshapes the banks of it and its neighbours, returning whether the cell exists.
     *
     * @mangled SetRiver__9CEditGridFii
     * @address 0x29B940
     * @size 0xF0
     */
    int SetRiver(int x, int z);

    /**
     *
     * Takes the river off a cell and reshapes the banks of it and its neighbours, returning whether it held river.
     *
     * @mangled ResetRiver__9CEditGridFii
     * @address 0x29BA30
     * @size 0x100
     */
    int ResetRiver(int x, int z);

    /**
     *
     * Chooses the piece and turn of each quarter of a river cell from its neighbours, returning whether it holds river.
     *
     * @mangled UpdateRiver__9CEditGridFii
     * @address 0x29BB30
     * @size 0x330
     */
    int UpdateRiver(int x, int z);

    /**
     *
     * Returns whether a cell holds river; a position outside the grid holds none.
     *
     * @mangled River__9CEditGridFii
     * @address 0x29BE60
     * @size 0x30
     */
    int River(int x, int z);

    /**
     *
     * Gives the world positions of the centres of the four quarters of a cell.
     *
     * @mangled GetRiverPos__9CEditGridFiiPA4_f
     * @address 0x29BE90
     * @size 0x100
     */
    void GetRiverPos(int x, int z, float (*pos)[4]);

    /**
     *
     * Gives the world position of the centre of a cell.
     *
     * @mangled GetRiverPos__9CEditGridFiiPf
     * @address 0x29BF90
     * @size 0x90
     */
    void GetRiverPos(int x, int y, float *pos);

    /**
     *
     * Makes the collision walls around each river cell inside a box, returning how many triangles were made.
     *
     * @mangled GetRiverPoly__9CEditGridFP6CCPolyRC9mgVu0FBOXif
     * @address 0x29C020
     * @size 0x3C0
     */
    int GetRiverPoly(CCPoly *poly, const mgVu0FBOX &box, int poly_max, float margin);

    /**
     *
     * Gives the flat box, at height zero, covering the cell under a world position.
     *
     * @mangled GetGridBox__9CEditGridFP9mgVu0FBOXPf
     * @address 0x29C3E0
     * @size 0x90
     */
    void GetGridBox(mgVu0FBOX *box, float *pos);
};

STATIC_ASSERT(sizeof(CEditGrid) == 0x130);
