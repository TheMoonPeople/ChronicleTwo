#pragma once

#include "common.h"

#include <libvu0.h>

#include "mg_dataset.hpp"

/**
 * @file
 * Declares the engine's model visuals: the MDT model that builds VU1 packets from its face lists, the
 * model whose face packets are built once at load time, the primitive visual that carries GS drawing
 * attributes, and the helpers that write texture, material and lighting packets.
 */

class mgCMemory;
class mgCTexture;
class mgCTextureManager;
class mgCDrawEnv;
class mgCDrawManager;
class mgRENDER_INFO;
class mgCFace;

/**
 *
 * Bits of a face list's type, as an MDT model's FACES_ID records give them.
 *
 */
enum mgFaceType {
    MG_FACE_PRIM_MASK = 0x7,    /**< Bits holding the GS primitive the faces are drawn as, from mgPRIM_TYPE. */
    MG_FACE_FLAT = 0x8,         /**< Faces are drawn with flat shading. */
    MG_FACE_NO_TEXTURE = 0x10,  /**< Faces are drawn untextured, and their vertices carry no texture coordinate index. */
    MG_FACE_COLOUR = 0x100,     /**< Vertices carry a per-vertex colour index. */
    MG_FACE_NO_NORMAL = 0x200,  /**< Vertices carry no normal index. */
};

/**
 *
 * Destination alpha tests a visual attribute selects for the GS TEST register.
 *
 */
enum mgDestAlphaTest {
    MG_DEST_ALPHA_TEST_OFF = -1, /**< Destination alpha is not tested. */
    MG_DEST_ALPHA_TEST_KEEP = 0, /**< Leaves the draw environment's setting as it is. */
    MG_DEST_ALPHA_TEST_ZERO = 1, /**< Pixels whose destination alpha bit is zero pass. */
    MG_DEST_ALPHA_TEST_ONE = 2,  /**< Pixels whose destination alpha bit is one pass. */
};

/**
 *
 * One material of a model as a visual draws it: its colours and the texture it is mapped with.
 *
 */
struct mgMaterial {
    sceVu0FVECTOR diffuse; /**< Colour the material is drawn with, sent alone when only the colour is needed. */
    sceVu0FVECTOR unk_10;
    mgCTexture *texture;   /**< Texture the material is mapped with, or NULL for an untextured material. */
};
STATIC_ASSERT(sizeof(mgMaterial) == 0x30);

/**
 *
 * One primitive of a model, made from a FACES_ID record: its vertex indices and the packet built from them.
 *
 */
class mgCFace {
public:
    u_short type;         /**< Primitive bits, from mgFaceType. */
    short index_stride;   /**< Number of indices that make one vertex. */
    short material;       /**< Index of the material the primitive is drawn with. */
    short index_num;      /**< Number of indices, index_stride for each vertex. */
    short vertex_num;     /**< Number of vertices in the primitive. */
    int *index;           /**< Vertex indices: position, then normal, texture coordinate and colour as the type gives them. */
    mgCFace *next;        /**< Following primitive of the same material, or NULL. */
    u_long128 packet_tag; /**< DMA tag that calls the primitive's prebuilt packet, in a model whose packets are built at load time. */
};
STATIC_ASSERT(sizeof(mgCFace) == 0x30);

/**
 *
 * The primitives of a model that share one material, and the packet that draws them.
 *
 */
struct mgFACE_GROUP {
    int material;         /**< Index of the material the group is drawn with. */
    mgCFace *face;        /**< First primitive of the group. */
    mgFACE_GROUP *next;   /**< Following group of the model, or NULL. */
    int vu_program;       /**< VU1 microprogram the group is drawn with, from mgVU_PROG_ID. */
    u_long128 *packet;    /**< Packet that draws the group, registered with the draw manager. */
    int packet_size;      /**< Size of the packet in quadwords. */
    int unk_18;
    int unk_1c;
};
STATIC_ASSERT(sizeof(mgFACE_GROUP) == 0x20);

/**
 *
 * GS drawing settings a visual or frame applies over the draw environment it is drawn with.
 *
 */
class mgCVisualAttr {
public:
    int alpha_ref;       /**< Alpha test reference value, or a negative value to keep the environment's. */
    int alpha_blend;     /**< Alpha blending mode, from mgAlphaMacroID; zero keeps the environment's. */
    int z_write;         /**< Depth buffer write mode, from mgZBufMode. */
    int z_test;          /**< Depth test, from mgDEPTH_TEST; zero keeps the environment's. */
    int alpha_test;      /**< GS alpha test method, -1 to disable alpha testing, or zero to keep the environment's. */
    int dest_alpha_test; /**< Destination alpha test, from mgDestAlphaTest. */

    /**
     * Creates the attributes with every setting reset.
     *
     * @mangled __ct__13mgCVisualAttrFv
     * @address 0x13EE60
     * @size 0x28
     */
    mgCVisualAttr();

    /**
     * Resets every setting: no alpha reference, depth writes on, destination alpha test off,
     * and everything else left to the draw environment.
     *
     * @mangled Initialize__13mgCVisualAttrFv
     * @address 0x13EE20
     * @size 0x40
     */
    void Initialize();
};
STATIC_ASSERT(sizeof(mgCVisualAttr) == 0x18);

/**
 *
 * A model drawn from an MDT file: its vertex data, materials and face lists, from which it builds the
 * VU1 packets that draw it each frame.
 *
 */
class mgCVisualMDT : public mgCVisual {
public:
    int vertex_num;             /**< Number of vertex positions. */
    int normal_num;             /**< Number of normal vectors. */
    int colour_num;             /**< Number of per-vertex colours. */
    int uv_num;                 /**< Number of texture coordinates. */
    sceVu0FVECTOR *vertex;      /**< Vertex positions. */
    sceVu0FVECTOR *normal;      /**< Normal vectors. */
    sceVu0FVECTOR *colour;      /**< Per-vertex colours. */
    sceVu0FVECTOR *uv;          /**< Texture coordinates. */
    int material_num;           /**< Number of materials. */
    mgMaterial *material;       /**< Material table. */
    mgFACE_GROUP *face_group;   /**< First group of primitives, one per material used. */

    /**
     * Creates a model with no data.
     *
     * @mangled __ct__12mgCVisualMDTFv
     */
    mgCVisualMDT() {
        Initialize();
    }

    mgCVisualMDT &operator=(const mgCVisualMDT &source);

    /**
     * Returns the kind of this visual.
     *
     * @mangled Iam__12mgCVisualMDTFv
     * @address 0x134900
     * @size 0xC
     */
    virtual int Iam();

    /**
     * Returns the number of materials the model has.
     *
     * @mangled GetMaterialNum__12mgCVisualMDTFv
     * @address 0x134910
     * @size 0xC
     */
    virtual int GetMaterialNum();

    /**
     * Returns the model's material table.
     *
     * @mangled GetpMaterial__12mgCVisualMDTFv
     * @address 0x134920
     * @size 0xC
     */
    virtual mgMaterial *GetpMaterial();

    /**
     * Returns one of the model's materials, or NULL when the model has no materials or the index
     * is out of range.
     *
     * @mangled GetMaterial__12mgCVisualMDTFi
     * @address 0x13F5D0
     * @size 0x4C
     */
    virtual mgMaterial *GetMaterial(int index);

    /**
     * Writes the bounds of the model's vertex positions and returns non-zero when it has any.
     *
     * @mangled CreateBBox__12mgCVisualMDTFPfPfPA4_f
     * @address 0x13F630
     * @size 0x4C
     */
    virtual int CreateBBox(float *max, float *min, float (*matrix)[4]);

    /**
     * Writes and sends the packet that sets up drawing the model: its transforms, lighting, fog,
     * GS modes and draw environment, and returns its length in quadwords.
     *
     * @mangled CreateRenderInfoPacket__12mgCVisualMDTFPUiPA4_fP13mgRENDER_INFO
     * @address 0x140B40
     * @size 0x708
     */
    virtual int CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info);

    /**
     * Draws the model through the draw manager with no packet of the caller's.
     *
     * @mangled Draw__12mgCVisualMDTFPA4_fP14mgCDrawManager
     * @address 0x134930
     * @size 0x38
     */
    virtual void Draw(float (*matrix)[4], mgCDrawManager *draw_manager);

    /**
     * Builds the model's packets in the draw manager's buffers, then either registers each material
     * group with the draw manager or, given a packet, writes calls to them into it and returns its
     * length in quadwords.
     *
     * @mangled Draw__12mgCVisualMDTFPUiPA4_fP14mgCDrawManager
     * @address 0x13FB50
     * @size 0x1BC
     */
    virtual int Draw(u_int *packet, float (*matrix)[4], mgCDrawManager *draw_manager);

    /**
     * Clears the model's data and resets the VU1 buffer layout to the model microprogram's.
     *
     * @mangled Initialize__12mgCVisualMDTFv
     * @address 0x13F130
     * @size 0x54
     */
    virtual void Initialize();

    /**
     * Builds the model's packet in the draw manager's buffers, one chain per material group, and
     * returns its DMA address.
     *
     * @mangled CreatePacket__12mgCVisualMDTFP14mgCDrawManager
     * @address 0x13FD10
     * @size 0x27C
     */
    virtual u_int CreatePacket(mgCDrawManager *draw_manager);

    /**
     * Writes the VU1 packet for one primitive, split into batches that fit the VU1 buffer, and
     * returns its length in quadwords.
     *
     * @mangled CreateFacePacket__12mgCVisualMDTFPUiP7mgCFace
     * @address 0x1405D0
     * @size 0x56C
     */
    virtual int CreateFacePacket(u_int *packet, mgCFace *face);

    /**
     * Creates a primitive from one face record of the model data and links it into the group of
     * its material, returning the record that follows.
     *
     * @mangled CreateFace__12mgCVisualMDTFP8FACES_IDP9mgCMemoryP9mgCMemoryPP7mgCFace
     * @address 0x13F680
     * @size 0x27C
     */
    virtual FACES_ID *CreateFace(FACES_ID *faces, mgCMemory *memory, mgCMemory *index_memory,
                                 mgCFace **face);

    /**
     * Writes the model's own additions to the setup packet and returns their length in quadwords;
     * a plain model has none.
     *
     * @mangled CreateExtRenderInfoPacket__12mgCVisualMDTFPUiPA4_fP13mgRENDER_INFO
     * @address 0x141250
     * @size 0x8
     */
    virtual int CreateExtRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info);

    /**
     * Copies the model's data from an MDT file and creates its primitives; returns zero when there
     * is no data.
     *
     * @mangled DataAssignMDT__12mgCVisualMDTFP10MDT_HEADERP9mgCMemoryP17mgCTextureManager
     * @address 0x13F900
     * @size 0xC8
     */
    virtual int DataAssignMDT(MDT_HEADER *header, mgCMemory *memory,
                              mgCTextureManager *texture_manager);

    /**
     * Writes the VIF packet that loads a material's colours into VU1 memory, with its texture
     * registers unless the texture is the one last set, and returns its length in quadwords.
     *
     * @mangled SetMaterialRef__12mgCVisualMDTFP1P10mgMateriali
     * @address 0x13EC60
     * @size 0x148
     */
    int SetMaterialRef(u_long128 *packet, mgMaterial *material, int flags);

    /**
     * Writes the packet that sets the GS PRMODE register for a primitive of the given type and
     * returns its length in quadwords.
     *
     * @mangled SetPModeRef__12mgCVisualMDTFP1i
     * @address 0x13EDB0
     * @size 0x70
     */
    int SetPModeRef(u_long128 *packet, int type);

    /**
     * Copies the counts, vertex data and materials of an MDT file into memory of the model's own.
     *
     * @mangled CopyMDTData__12mgCVisualMDTFP10MDT_HEADERP9mgCMemory
     * @address 0x13F210
     * @size 0x278
     */
    void CopyMDTData(MDT_HEADER *header, mgCMemory *memory);

    /**
     * Points the model's vertex data into an MDT file in place, copying only its materials into
     * memory.
     *
     * @mangled CopyMDTDataPointer__12mgCVisualMDTFP10MDT_HEADERP9mgCMemory
     * @address 0x13F490
     * @size 0x134
     */
    void CopyMDTDataPointer(MDT_HEADER *header, mgCMemory *memory);

    /**
     * Returns the model's per-vertex colours and writes their number.
     *
     * @mangled GetColor__12mgCVisualMDTFPi
     * @address 0x13F620
     * @size 0x10
     */
    sceVu0FVECTOR *GetColor(int *num);
} __attribute__((aligned(16)));
STATIC_ASSERT(sizeof(mgCVisualMDT) == 0x50);

/**
 *
 * An MDT model whose primitive packets are built once, when its data is assigned, so that each
 * frame only calls them.
 *
 */
class mgCVisualFixMDT : public mgCVisualMDT {
public:
    /**
     * Creates a model with no data.
     *
     * @mangled __ct__15mgCVisualFixMDTFv
     */
    mgCVisualFixMDT() {
        Initialize();
    }

    /**
     * Returns the kind of this visual.
     *
     * @mangled Iam__15mgCVisualFixMDTFv
     * @address 0x141840
     * @size 0x8
     */
    virtual int Iam();

    /**
     * Returns a copy of the model allocated from memory, sharing its vertex data and primitives
     * but with a material table of its own.
     *
     * @mangled Copy__15mgCVisualFixMDTFP9mgCMemory
     * @address 0x141260
     * @size 0x190
     */
    virtual mgCVisual *Copy(mgCMemory *memory);

    /**
     * Clears the model's data.
     *
     * @mangled Initialize__15mgCVisualFixMDTFv
     * @address 0x133420
     * @size 0x20
     */
    virtual void Initialize();

    /**
     * Builds the model's packet in the draw manager's buffers from the prebuilt primitive packets,
     * one chain per material group, and returns its address.
     *
     * @mangled CreatePacket__15mgCVisualFixMDTFP14mgCDrawManager
     * @address 0x13FF90
     * @size 0x228
     */
    virtual u_int CreatePacket(mgCDrawManager *draw_manager);

    /**
     * Points the model at an MDT file's data, creates its primitives and builds each primitive's
     * packet in memory; returns non-zero.
     *
     * @mangled DataAssignMDT__15mgCVisualFixMDTFP10MDT_HEADERP9mgCMemoryP17mgCTextureManager
     * @address 0x13F9D0
     * @size 0x180
     */
    virtual int DataAssignMDT(MDT_HEADER *header, mgCMemory *memory,
                              mgCTextureManager *texture_manager);
};
STATIC_ASSERT(sizeof(mgCVisualFixMDT) == 0x50);

/**
 *
 * Base of the visuals that draw GS primitives directly, carrying the GS settings they are drawn with.
 *
 */
class mgCVisualPrim : public mgCVisual {
public:
    mgCVisualAttr attr; /**< GS settings applied over the render info's draw environment. */

    /**
     * Creates a visual with its settings reset.
     *
     * @mangled __ct__13mgCVisualPrimFv
     */
    mgCVisualPrim() {
        Initialize();
    }

    /**
     * Returns the kind of this visual.
     *
     * @mangled Iam__13mgCVisualPrimFv
     * @address 0x13C2F0
     * @size 0x8
     */
    virtual int Iam();

    /**
     * Writes and sends the packet that sets up drawing the primitives: the GS modes and the draw
     * environment adjusted by the visual's settings, and returns its length in quadwords.
     *
     * @mangled CreateRenderInfoPacket__13mgCVisualPrimFPUiPA4_fP13mgRENDER_INFO
     * @address 0x141700
     * @size 0x11C
     */
    virtual int CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info);

    /**
     * Clears the visual's draw settings and resets its GS settings.
     *
     * @mangled Initialize__13mgCVisualPrimFv
     * @address 0x141820
     * @size 0x1C
     */
    virtual void Initialize();
};

/**
 * Returns the half of the scratchpad that the next packet is written into while the other half
 * is sent.
 *
 * @mangled GetScrPad__Fv
 * @address 0x13EA20
 * @size 0x14
 */
u_int *GetScrPad();

/**
 * Copies the packet written in the current scratchpad half out to its place in main memory by
 * DMA, after the previous copy finishes, and switches scratchpad halves.
 *
 * @mangled SendDMA__FPvi
 * @address 0x13EA40
 * @size 0xD0
 */
void SendDMA(void *packet, int size);

/**
 * Writes the packet that sets the GS TEX1 and TEX0 registers and returns its length in quadwords.
 *
 * @mangled mgSetPkTEX0__FPUiUlUl
 * @address 0x13EB10
 * @size 0x40
 */
int mgSetPkTEX0(u_int *packet, u_long tex0, u_long tex1);

/**
 * Writes the packet that sets the GS TEX1, TEX0 and TEXA registers and returns its length in
 * quadwords.
 *
 * @mangled mgSetPkTEX0__FPUiUlUlUl
 * @address 0x13EB50
 * @size 0x4C
 */
int mgSetPkTEX0(u_int *packet, u_long tex0, u_long tex1, u_long texa);

/**
 * Writes the packet that flushes the GS texture cache, when given a packet, and returns its length
 * in quadwords.
 *
 * @mangled mgSetPkTexFlush_TagCnt__FPUi
 * @address 0x13EBA0
 * @size 0x48
 */
int mgSetPkTexFlush_TagCnt(u_int *packet);

/**
 * Writes the VIF packet that loads two point light matrices into VU1 memory and returns its length
 * in quadwords.
 *
 * @mangled SetPointLight__FPUiPA4_fPA4_f
 * @address 0x13EBF0
 * @size 0x68
 */
int SetPointLight(u_int *packet, float (*matrix0)[4], float (*matrix1)[4]);

/**
 * Fills a material from an MDT material record, looking its texture up by name.
 *
 * @mangled CopyMaterial__FP10mgMaterialP13MDT_MATERIAL_P17mgCTextureManager
 * @address 0x13F190
 * @size 0x74
 */
void CopyMaterial(mgMaterial *material, MDT_MATERIAL_ *source, mgCTextureManager *texture_manager);

/**
 * Writes a batch of vertices with position, normal and texture coordinate, and returns the end of
 * what it wrote.
 *
 * @mangled SetData0__FiiPPiP1P1P1P1P1
 * @address 0x1401C0
 * @size 0x88
 */
u_long128 *SetData0(int vertex_num, int type, int **index, u_long128 *packet, u_long128 *vertex,
                    u_long128 *normal, u_long128 *uv, u_long128 *colour);

/**
 * Writes a batch of vertices with position, normal, texture coordinate and colour, and returns the
 * end of what it wrote.
 *
 * @mangled SetData1__FiiPPiP1P1P1P1P1
 * @address 0x140250
 * @size 0xA8
 */
u_long128 *SetData1(int vertex_num, int type, int **index, u_long128 *packet, u_long128 *vertex,
                    u_long128 *normal, u_long128 *uv, u_long128 *colour);

/**
 * Writes a batch of vertices with position and normal, and returns the end of what it wrote.
 *
 * @mangled SetData2__FiiPPiP1P1P1P1P1
 * @address 0x140300
 * @size 0x70
 */
u_long128 *SetData2(int vertex_num, int type, int **index, u_long128 *packet, u_long128 *vertex,
                    u_long128 *normal, u_long128 *uv, u_long128 *colour);

/**
 * Writes a batch of vertices with position, normal and colour, and returns the end of what it
 * wrote.
 *
 * @mangled SetData3__FiiPPiP1P1P1P1P1
 * @address 0x140370
 * @size 0x88
 */
u_long128 *SetData3(int vertex_num, int type, int **index, u_long128 *packet, u_long128 *vertex,
                    u_long128 *normal, u_long128 *uv, u_long128 *colour);

/**
 * Writes a batch of vertices with position and texture coordinate, and returns the end of what it
 * wrote.
 *
 * @mangled SetData4__FiiPPiP1P1P1P1P1
 * @address 0x140400
 * @size 0x70
 */
u_long128 *SetData4(int vertex_num, int type, int **index, u_long128 *packet, u_long128 *vertex,
                    u_long128 *normal, u_long128 *uv, u_long128 *colour);

/**
 * Writes a batch of vertices with position, texture coordinate and colour, and returns the end of
 * what it wrote.
 *
 * @mangled SetData5__FiiPPiP1P1P1P1P1
 * @address 0x140470
 * @size 0x88
 */
u_long128 *SetData5(int vertex_num, int type, int **index, u_long128 *packet, u_long128 *vertex,
                    u_long128 *normal, u_long128 *uv, u_long128 *colour);

/**
 * Writes a batch of vertices with position only, and returns the end of what it wrote.
 *
 * @mangled SetData6__FiiPPiP1P1P1P1P1
 * @address 0x140500
 * @size 0x5C
 */
u_long128 *SetData6(int vertex_num, int type, int **index, u_long128 *packet, u_long128 *vertex,
                    u_long128 *normal, u_long128 *uv, u_long128 *colour);

/**
 * Writes a batch of vertices with position and colour, and returns the end of what it wrote.
 *
 * @mangled SetData7__FiiPPiP1P1P1P1P1
 * @address 0x140560
 * @size 0x70
 */
u_long128 *SetData7(int vertex_num, int type, int **index, u_long128 *packet, u_long128 *vertex,
                    u_long128 *normal, u_long128 *uv, u_long128 *colour);

/**
 * Writes a copy of a draw environment adjusted by a visual's GS settings.
 *
 * @mangled SetDrawEnv__FP10mgCDrawEnvP13mgCVisualAttrP10mgCDrawEnv
 * @address 0x141490
 * @size 0x270
 */
void SetDrawEnv(mgCDrawEnv *env, mgCVisualAttr *attr, mgCDrawEnv *base);

/**
 * GIF tag of one A+D register write, whose loop count each user rewrites.
 *
 * @mangled giftag
 * @address 0x338320
 * @size 0x10
 */
struct mgVisualGifTag {
    u_int word0;
    u_int words[3];
};
STATIC_ASSERT(sizeof(mgVisualGifTag) == 0x10);
extern mgVisualGifTag giftag;

/**
 * DMA tag that sends the three quadwords of the TEX1 and TEX0 packet.
 *
 * @mangled set_tex0_dma
 * @address 0x338330
 * @size 0x10
 */
extern u_long128 set_tex0_dma;

/**
 * GIF tag of the two A+D register writes of the TEX1 and TEX0 packet.
 *
 * @mangled set_tex0_giftag
 * @address 0x338340
 * @size 0x10
 */
extern u_long128 set_tex0_giftag;

/**
 * DMA tag that sends the four quadwords of the TEX1, TEX0 and TEXA packet.
 *
 * @mangled set_texa_dma
 * @address 0x338350
 * @size 0x10
 */
extern u_long128 set_texa_dma;

/**
 * GIF tag of the three A+D register writes of the TEX1, TEX0 and TEXA packet.
 *
 * @mangled set_texa_giftag
 * @address 0x338360
 * @size 0x10
 */
extern u_long128 set_texa_giftag;

/**
 * VIF code that unpacks a material's four quadwords into VU1 memory.
 *
 * @mangled mat_vif
 * @address 0x3383A0
 * @size 0x10
 */
extern u_long128 mat_vif;

/**
 * VIF code that unpacks only a material's diffuse colour into VU1 memory.
 *
 * @mangled mat_vif_dif
 * @address 0x3383B0
 * @size 0x10
 */
extern u_long128 mat_vif_dif;

/**
 * VIF code that sends the two-quadword GS packet that sets PRMODE.
 *
 * @mangled mat_vif_d
 * @address 0x3383C0
 * @size 0x10
 */
extern u_long128 mat_vif_d;

/**
 * Last quadword of a material's VU1 data, sent after its colours.
 *
 * @mangled mat_pw
 * @address 0x3383D0
 * @size 0x10
 */
extern u_long128 mat_pw;

/**
 * VIF code that sends the four-quadword GS packet that sets a material's texture registers.
 *
 * @mangled mat_vif_d_tex
 * @address 0x3383E0
 * @size 0x10
 */
extern u_long128 mat_vif_d_tex;

/**
 * Non-zero while a scratchpad DMA transfer started by SendDMA may still be running.
 *
 * @mangled start_dma
 * @address 0x37CDC0
 * @size 0x4
 */
extern int start_dma;

/**
 * Half of the scratchpad that the next packet is written into.
 *
 * @mangled buff_id
 * @address 0x37CDC4
 * @size 0x4
 */
extern int buff_id;

/**
 * Texture of the material whose registers were last written, or NULL for none.
 *
 * @mangled prev_tex
 * @address 0x37CDC8
 * @size 0x4
 */
extern mgCTexture *prev_tex;
