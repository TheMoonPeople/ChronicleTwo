#pragma once

#include "common.h"

#include "map.hpp"

/**
 * @file
 * Declares the placed object that a frame of model data draws.
 */

class mgCFrame;
class mgCMemory;

/**
 *
 * Places an object in the world and draws it with a frame, which it keeps on the position, rotation and scale that the object has.
 *
 */
class CObjectFrame : public CObject {
public:
    mgCFrame *frame; /**< Frame that draws the object; NULL while the object has none. */

    /**
     * Makes an object that no frame draws yet.
     *
     * @mangled __ct__12CObjectFrameFv
     * @address 0x163830
     * @size 0x50
     */
    CObjectFrame() { Initialize(); }

    /**
     * Gets the frame that draws the object.
     *
     * @mangled GetFrame__12CObjectFrameFv
     * @address 0x163D30
     * @size 0x10
     */
    mgCFrame *GetFrame() {
        return frame;
    }

    /**
     * Draws the frame through the drawing list when the object is to be
     * drawn this frame.
     *
     * @mangled Draw__12CObjectFrameFv
     * @address 0x16B3E0
     * @size 0x40
     */
    virtual int Draw();

    /**
     * Draws the frame straight away when the object is to be drawn this
     * frame.
     *
     * @mangled DrawDirect__12CObjectFrameFv
     * @address 0x16B420
     * @size 0x40
     */
    virtual int DrawDirect();

    /**
     * Detaches the frame and puts the object back to its initial state.
     *
     * @mangled Initialize__12CObjectFrameFv
     * @address 0x16B540
     * @size 0x10
     */
    virtual void Initialize();

    /**
     * Moves the frame onto the object and decides whether to draw it,
     * fading the frame by the distance alpha when the object fades.
     *
     * @mangled PreDraw__12CObjectFrameFv
     * @address 0x16B340
     * @size 0xA0
     */
    virtual int PreDraw();

    /**
     * Gets the distance from the camera to the world position of the frame.
     *
     * @mangled GetCameraDist__12CObjectFrameFv
     * @address 0x16B310
     * @size 0x30
     */
    virtual float GetCameraDist();

    /**
     * Works out whether the object is within its drawing distance.
     *
     * @mangled DrawStep__12CObjectFrameFv
     * @address 0x16B300
     * @size 0x10
     */
    virtual void DrawStep();

    /**
     * Gives the frame the position, rotation and scale of the object.
     *
     * @mangled UpDatePosition__12CObjectFrameFv
     * @address 0x16B290
     * @size 0x70
     */
    virtual void UpDatePosition();

    /**
     * Copies this object into another, sharing the same frame.
     *
     * @mangled Copy__12CObjectFrameFR12CObjectFrameP9mgCMemory
     * @address 0x16B460
     * @size 0xE0
     */
    virtual void Copy(CObjectFrame &dest, mgCMemory *memory);
};

STATIC_ASSERT(sizeof(CObjectFrame) == 0x80);
