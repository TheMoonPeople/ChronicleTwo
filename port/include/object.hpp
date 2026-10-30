#pragma once

#include "common.h"

#include "mg_frame.hpp"
#include "mg_memory.hpp"

/**
 * @file
 * Declares the base drawable object that map parts and water are built on, and the placed object
 * that a frame of model data draws.
 */

/**
 *
 * Base of the map's drawable objects: an engine object that can be shown, hidden and faded between a near and a far distance.
 *
 */
class CObject : public mgCObject {
public:
    float far_dist{};   /**< Distance from the camera beyond which the object is not drawn, or not above zero for none. */
    s32   fade{};       /**< Fades the object in and out at the near and far distances instead of cutting it off. */
    float fade_alpha{}; /**< Current alpha of a fading object, or below zero before its first step. */
    float fade_speed{}; /**< Alpha the fade gains or loses each step. */
    float near_dist{};  /**< Distance from the camera within which the object is not drawn, or not above zero for none. */
    s32   show{};       /**< Draws the object while nonzero. */
    s32   draw_off{};   /**< Keeps the object from drawing while nonzero, whatever show holds. */

    /**
     *
     * Makes an object at the world origin, shown, with no draw distances.
     *
     * @mangled __ct__7CObjectFv
     * @address 0x1631B0
     * @size 0x50
     */
    CObject() { Initialize(); }

    /**
     *
     * Draws the object. The base object draws nothing.
     *
     * @mangled Draw__7CObjectFv
     * @address 0x161F60
     * @size 0x10
     */
    int Draw() override { return 0; }

    /**
     *
     * Draws the object straight into the packet. The base object draws nothing.
     *
     * @mangled DrawDirect__7CObjectFv
     * @address 0x161F70
     * @size 0x10
     */
    int DrawDirect() override { return 0; }

    /**
     *
     * Puts the object at the world origin, shows it, and clears its draw distances and fade.
     *
     * @mangled Initialize__7CObjectFv
     * @address 0x16B1F0
     * @size 0xA0
     */
    void Initialize() override;

    /**
     *
     * Returns whether the object is shown and not kept from drawing.
     *
     * @mangled PreDraw__7CObjectFv
     * @address 0x16B1C0
     * @size 0x30
     */
    virtual int PreDraw();

    /**
     *
     * Returns the distance from the camera to the object.
     *
     * @mangled GetCameraDist__7CObjectFv
     * @address 0x16B020
     * @size 0x10
     */
    virtual float GetCameraDist();

    /**
     *
     * Returns whether the object is drawn at a distance from the camera, stepping its fade and giving its alpha.
     *
     * @mangled FarClip__7CObjectFfPf
     * @address 0x16AED0
     * @size 0x150
     */
    virtual int FarClip(float dist, float *out_alpha);

    /**
     *
     * Steps the object's fade for its current distance from the camera.
     *
     * @mangled DrawStep__7CObjectFv
     * @address 0x16B120
     * @size 0x50
     */
    virtual void DrawStep();

    /**
     *
     * Returns the alpha the object is drawn with.
     *
     * @mangled GetAlpha__7CObjectFv
     * @address 0x16B170
     * @size 0x50
     */
    virtual float GetAlpha();

    /**
     *
     * Shows or hides the object.
     *
     * @mangled Show__7CObjectFi
     * @address 0x161F80
     * @size 0x10
     */
    virtual void Show(int on) { show = on; }

    /**
     *
     * Returns whether the object is shown.
     *
     * @mangled GetShow__7CObjectFv
     * @address 0x160520
     * @size 0x10
     */
    virtual int GetShow() { return show; }

    /**
     *
     * Sets the distance beyond which the object is not drawn.
     *
     * @mangled SetFarDist__7CObjectFf
     * @address 0x161F90
     * @size 0x10
     */
    virtual void SetFarDist(float dist) { far_dist = dist; }

    /**
     *
     * Returns the distance beyond which the object is not drawn.
     *
     * @mangled GetFarDist__7CObjectFv
     * @address 0x161FA0
     * @size 0x10
     */
    virtual float GetFarDist() { return far_dist; }

    /**
     *
     * Sets the distance within which the object is not drawn.
     *
     * @mangled SetNearDist__7CObjectFf
     * @address 0x161FB0
     * @size 0x10
     */
    virtual void SetNearDist(float dist) { near_dist = dist; }

    /**
     *
     * Returns the distance within which the object is not drawn.
     *
     * @mangled GetNearDist__7CObjectFv
     * @address 0x161FC0
     * @size 0x10
     */
    virtual float GetNearDist() { return near_dist; }

    /**
     *
     * Returns whether the object is to be drawn this frame.
     *
     * @mangled CheckDraw__7CObjectFv
     * @address 0x16B030
     * @size 0xF0
     */
    virtual int CheckDraw();

    /**
     *
     * Copies the object's placement, draw distances and fade into another object.
     *
     * @mangled Copy__7CObjectFR7CObjectP9mgCMemory
     * @address 0x161FD0
     * @size 0xB0
     */
    virtual void Copy(CObject &dest, mgCMemory *stack) { dest = *this; }

    /**
     *
     * Builds the object's world matrix from its scale, rotation and position.
     *
     * @mangled GetMatrix__7CObjectFPA4_f
     * @address 0x16AE00
     * @size 0xD0
     */
    void GetMatrix(float (*out_matrix)[4]);
};

STATIC_ASSERT(sizeof(CObject) == 0x70);

/**
 *
 * Places an object in the world and draws it with a frame, which it keeps on the position, rotation and scale that the object has.
 *
 */
class CObjectFrame : public CObject {
public:
    mgCFrame *frame{}; /**< Frame that draws the object; NULL while the object has none. */

    /**
     *
     * Makes an object that no frame draws yet.
     *
     * @mangled __ct__12CObjectFrameFv
     * @address 0x163830
     * @size 0x50
     */
    CObjectFrame() { Initialize(); }

    /**
     *
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
     *
     * Draws the frame through the drawing list when the object is to be
     * drawn this frame.
     *
     * @mangled Draw__12CObjectFrameFv
     * @address 0x16B3E0
     * @size 0x40
     */
    int Draw() override;

    /**
     *
     * Draws the frame straight away when the object is to be drawn this
     * frame.
     *
     * @mangled DrawDirect__12CObjectFrameFv
     * @address 0x16B420
     * @size 0x40
     */
    int DrawDirect() override;

    /**
     *
     * Detaches the frame and puts the object back to its initial state.
     *
     * @mangled Initialize__12CObjectFrameFv
     * @address 0x16B540
     * @size 0x10
     */
    void Initialize() override;

    /**
     *
     * Moves the frame onto the object and decides whether to draw it,
     * fading the frame by the distance alpha when the object fades.
     *
     * @mangled PreDraw__12CObjectFrameFv
     * @address 0x16B340
     * @size 0xA0
     */
    int PreDraw() override;

    /**
     *
     * Gets the distance from the camera to the world position of the frame.
     *
     * @mangled GetCameraDist__12CObjectFrameFv
     * @address 0x16B310
     * @size 0x30
     */
    float GetCameraDist() override;

    /**
     *
     * Works out whether the object is within its drawing distance.
     *
     * @mangled DrawStep__12CObjectFrameFv
     * @address 0x16B300
     * @size 0x10
     */
    void DrawStep() override;

    /**
     *
     * Gives the frame the position, rotation and scale of the object.
     *
     * @mangled UpDatePosition__12CObjectFrameFv
     * @address 0x16B290
     * @size 0x70
     */
    virtual void UpDatePosition();

    /**
     *
     * Copies this object into another, sharing the same frame.
     *
     * @mangled Copy__12CObjectFrameFR12CObjectFrameP9mgCMemory
     * @address 0x16B460
     * @size 0xE0
     */
    virtual void Copy(CObjectFrame &dest, mgCMemory *memory);
};

STATIC_ASSERT(sizeof(CObjectFrame) == 0x80);
