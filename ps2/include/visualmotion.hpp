#pragma once

#include "common.h"

#include "mg_drawenv.hpp"
#include "mg_visual.hpp"

/**
 * @file
 * Declares the skinned MDT model, whose vertices are blended between the matrices of up to 32 bone
 * frames by per-vertex weights, and the data it is built from.
 */

class mgCFrame;
class mgCMemory;
class mgCTextureManager;
class mgRENDER_INFO;
class mgCFace;

/**
 *
 * Bones and blend weights of one vertex of a skinned model, as sent to VU1 beside its position.
 *
 */
struct mgVertexWeight {
    int matrix[4];   /**< VU1 quadword offset of each influencing bone's matrix: four times its bone slot. */
    float weight[4]; /**< Blend weight of each influencing bone; the weights of a vertex sum to one. */

    /**
     * Creates a weight with no bones and every weight zero.
     *
     * @mangled __ct__14mgVertexWeightFv
     * @address 0x28D620
     * @size 0x30
     */
    mgVertexWeight();
};
STATIC_ASSERT(sizeof(mgVertexWeight) == 0x20);

/**
 *
 * What a skinned model is built from: its weight records and the frames and base matrices of the
 * skeleton it follows.
 *
 */
class mgCVMotionData {
public:
    u_int *weight_data;           /**< Weight records of every model of the scene, each block naming the model and bone it belongs to. */
    int frame_id;                 /**< Index in the frame table of the frame the model is attached to. */
    mgCFrame **frame;             /**< Table of the skeleton's frames, indexed by frame number. */
    float (*base_matrix)[4][4];   /**< Base matrix of each frame of the table, indexed by frame number. */
    int unk_10;
};
STATIC_ASSERT(sizeof(mgCVMotionData) == 0x14);

/**
 *
 * An MDT model whose vertices follow the frames of a skeleton, each blended between up to four of
 * the model's bones by its weights.
 *
 */
class mgCVisualMotionMDT : public mgCVisualFixMDT {
public:
    mgCFrame **frame;           /**< Table of the skeleton's frames the bones are taken from, indexed by frame number. */
    int frame_id;               /**< Index in the frame table of the frame the model is attached to. */
    float (*base_matrix)[4][4]; /**< Base matrix of each frame of the table, indexed by frame number. */
    mgVu0FBOX base_box;         /**< Bounds of the model in its base pose, moved with each bone to bound the posed model. */
    int bone[32];               /**< Frame number of each bone slot whose matrix is sent to VU1, ended by -1. */
    int weight_num;             /**< Number of vertex weights, one per vertex position. */
    mgVertexWeight *weight;     /**< Bones and blend weights of each vertex position. */

    /**
     * Creates a model with no data.
     *
     * @mangled __ct__18mgCVisualMotionMDTFv
     */
    mgCVisualMotionMDT() {
        Initialize();
    }

    /**
     * Returns the kind of this visual.
     *
     * @mangled Iam__18mgCVisualMotionMDTFv
     * @address 0x28EB40
     * @size 0x10
     */
    virtual int Iam();

    /**
     * Returns a copy of the model allocated from memory, sharing its vertex data, primitives and
     * weights but with a material table of its own.
     *
     * @mangled Copy__18mgCVisualMotionMDTFP9mgCMemory
     * @address 0x28E930
     * @size 0x210
     */
    virtual mgCVisual *Copy(mgCMemory *memory);

    /**
     * Writes the bounds of the posed model, the base box moved by each bone, relative to a matrix,
     * and returns non-zero when the model has any bones.
     *
     * @mangled CreateBBox__18mgCVisualMotionMDTFPfPfPA4_f
     * @address 0x28E670
     * @size 0x2C0
     */
    virtual int CreateBBox(float *max, float *min, float (*matrix)[4]);

    /**
     * Writes and sends the packet that sets up drawing the model, marked as a motion model, and
     * returns its length in quadwords.
     *
     * @mangled CreateRenderInfoPacket__18mgCVisualMotionMDTFPUiPA4_fP13mgRENDER_INFO
     * @address 0x28E430
     * @size 0x30
     */
    virtual int CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info);

    /**
     * Clears the model's data and bones, and resets the VU1 buffer layout to the skinning
     * microprogram's.
     *
     * @mangled Initialize__18mgCVisualMotionMDTFv
     * @address 0x28D1F0
     * @size 0x90
     */
    virtual void Initialize();

    /**
     * Writes the VIF packet that loads each bone's current skinning matrix into VU1 memory and
     * returns its length in quadwords, or zero when the model has no skeleton or bones.
     *
     * @mangled CreateExtRenderInfoPacket__18mgCVisualMotionMDTFPUiPA4_fP13mgRENDER_INFO
     * @address 0x28E460
     * @size 0x1F0
     */
    virtual int CreateExtRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info);

    /**
     * Points the model at an MDT file's data, builds its vertex weights and bones, creates its
     * primitives and builds each primitive's skinned packet in memory; returns zero when there is
     * no work memory.
     *
     * @mangled DataAssignMotionMDT__18mgCVisualMotionMDTFP10MDT_HEADERP14mgCVMotionDataP9mgCMemoryP9mgCMemoryP17mgCTextureManager
     * @address 0x28D710
     * @size 0x200
     */
    virtual int DataAssignMotionMDT(MDT_HEADER *header, mgCVMotionData *motion, mgCMemory *memory,
                                    mgCMemory *work_memory, mgCTextureManager *texture_manager);

    /**
     * Writes the VU1 packet for one primitive with each vertex's weights, split into batches that
     * fit the VU1 buffer, and returns its length in quadwords.
     *
     * @mangled CreateFaceMotionPacket__18mgCVisualMotionMDTFPUiP7mgCFaceP14mgCVMotionData
     * @address 0x28DEA0
     * @size 0x590
     */
    virtual int CreateFaceMotionPacket(u_int *packet, mgCFace *face, mgCVMotionData *motion);

    /**
     * Builds the weights of every vertex from the weight records of the given frame, filling the
     * bone slots; on more than 32 bones the model is left without weights.
     *
     * @mangled CreateVertexWeight__18mgCVisualMotionMDTFPUiiP9mgCMemory
     * @address 0x28D280
     * @size 0x3A0
     */
    void CreateVertexWeight(u_int *weight_data, int frame_id, mgCMemory *memory);

    /**
     * Moves the model onto another skeleton, finding each bone's frame there by name.
     *
     * @mangled ChangeWeight__18mgCVisualMotionMDTFPP8mgCFramePA4_A4_fi
     * @address 0x28D650
     * @size 0xC0
     */
    void ChangeWeight(mgCFrame **frame, float (*base_matrix)[4][4], int frame_id);

    /**
     * Sets the bounds of the model in its base pose, and sets the w of both given corners to one.
     *
     * @mangled SetBaseBox__18mgCVisualMotionMDTFPfPf
     * @address 0x28E650
     * @size 0x20
     */
    void SetBaseBox(float *max, float *min);
};
STATIC_ASSERT(sizeof(mgCVisualMotionMDT) == 0x110);
