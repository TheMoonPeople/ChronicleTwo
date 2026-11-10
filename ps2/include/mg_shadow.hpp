#pragma once

#include "common.h"

#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"

/**
 * @file
 * Declares the engine's shadow model: an MDT model whose triangles are
 * drawn flattened onto the ground as a cast shadow.
 */

/**
 *
 * MDT model drawn as a cast shadow: its faces are sent as untextured
 * triangles, transformed by the scene's shadow projection.
 *
 */
class mgCShadowMDT : public mgCVisualMDT {
public:
    /**
     *
     * Writes and sends the packet that sets up the shadow drawing pass:
     * transforms, lighting, draw environment and shadow projection.
     *
     * @mangled CreateRenderInfoPacket__12mgCShadowMDTFPUiPA4_fP13mgRENDER_INFO
     * @address 0x13AE80
     * @size 0x460
     */
    virtual int CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info);

    /**
     *
     * Builds the model's draw packet in the draw manager's buffers, one
     * chain per face group, and returns its DMA address.
     *
     * @mangled CreatePacket__12mgCShadowMDTFP14mgCDrawManager
     * @address 0x13ABD0
     * @size 0x1E0
     */
    virtual uptr CreatePacket(mgCDrawManager *manager);

    /**
     *
     * Writes the triangle packet for one face list and returns its length
     * in quadwords.
     *
     * @mangled CreateFacePacket__12mgCShadowMDTFPUiP7mgCFace
     * @address 0x13A630
     * @size 0x3D0
     */
    virtual int CreateFacePacket(u_int *packet, mgCFace *face);

    /**
     *
     * Creates a face list from one face record of the model data and links
     * it into the model's face groups, returning the record that follows.
     *
     * @mangled CreateFace__12mgCShadowMDTFP8FACES_IDP9mgCMemoryP9mgCMemoryPP7mgCFace
     * @address 0x13AA00
     * @size 0x1D0
     */
    virtual FACES_ID *CreateFace(FACES_ID *source, mgCMemory *memory, mgCMemory *index_memory, mgCFace **result);

    /**
     *
     * Copies the model's data from an MDT file and creates its face lists;
     * returns zero when there is no data.
     *
     * @mangled DataAssignMDT__12mgCShadowMDTFP10MDT_HEADERP9mgCMemoryP17mgCTextureManager
     * @address 0x13ADB0
     * @size 0xD0
     */
    virtual int DataAssignMDT(MDT_HEADER *header, mgCMemory *memory, mgCTextureManager *textures);
};

STATIC_ASSERT(sizeof(mgCShadowMDT) == 0x50);

/**
 *
 * Shadow model the scene loader builds for MG_VISUAL_CREATE_SHADOW_FIX_MDT;
 * it keeps every behaviour of mgCShadowMDT.
 *
 */
class mgCShadowFixMDT : public mgCShadowMDT {
public:
};

STATIC_ASSERT(sizeof(mgCShadowFixMDT) == 0x50);
