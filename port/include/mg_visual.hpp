#pragma once

#include "common.h"

#include <libvu0.h>

#include <cstddef>
#include <optional>
#include <span>

#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"

/**
 * @file
 * Declares the engine's model visuals: the base of every visual, the MDT model file records, the
 * MDT model that builds VU1 packets from its face lists, the model whose face packets are built
 * once at load time, the primitive visual that carries GS drawing attributes, and the helpers that
 * write texture, material and lighting packets.
 */

/**
 *
 * Bits of a face list's type, as an MDT model's FACES_ID records give them.
 *
 */
enum mgFaceType {
    MG_FACE_PRIM_MASK = 0x7,   /**< Bits holding the GS primitive the faces are drawn as, from mgPRIM_TYPE. */
    MG_FACE_FLAT = 0x8,        /**< Faces are drawn with flat shading. */
    MG_FACE_NO_TEXTURE = 0x10, /**< Faces are drawn untextured, and their vertices carry no texture coordinate index. */
    MG_FACE_COLOUR = 0x100,    /**< Vertices carry a per-vertex colour index. */
    MG_FACE_NO_NORMAL = 0x200, /**< Vertices carry no normal index. */
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
 * Starts an MDT model: the counts of each data section and their byte offsets from this header.
 *
 */
struct MDT_HEADER {
    char magic[4];    /**< Identifies the file as a model: "MDT". */
    int  header_size; /**< Size of this header in bytes. */
    int  unk_08;
    int  vertex_num;   /**< Number of vertex positions. */
    int  vertex_ofs;   /**< Byte offset from the header to the vertex positions. */
    int  normal_num;   /**< Number of normal vectors. */
    int  normal_ofs;   /**< Byte offset from the header to the normal vectors. */
    int  colour_num;   /**< Number of per-vertex colours. */
    int  colour_ofs;   /**< Byte offset from the header to the per-vertex colours. */
    int  faces_size;   /**< Size in bytes of the face section. */
    int  faces_ofs;    /**< Byte offset from the header to the face section. */
    int  uv_num;       /**< Number of texture coordinates. */
    int  uv_ofs;       /**< Byte offset from the header to the texture coordinates. */
    int  material_num; /**< Number of material records. */
    int  material_ofs; /**< Byte offset from the header to the material records. */
    int  unk_3c;
};

STATIC_ASSERT(sizeof(MDT_HEADER) == 0x40);
PORT_RECORD_ASSERT(sizeof(MDT_HEADER) == 0x40);

/**
 *
 * Describes one material of an MDT model: its colours and the name of the texture it draws with.
 *
 */
struct MDT_MATERIAL_ {
    sceVu0FVECTOR diffuse; /**< Colour the material is drawn with. */
    float         unk_10[4];
    float         unk_20[4];
    float         unk_30;
    char          texture[32]; /**< Name of the texture the material draws with. */
    int           unk_54;
    float         extra[2];
};

STATIC_ASSERT(sizeof(MDT_MATERIAL_) == 0x60);
PORT_RECORD_ASSERT(sizeof(MDT_MATERIAL_) == 0x60);

/**
 *
 * Starts the face section of an MDT model, which holds one FACES_ID record per primitive.
 *
 */
struct MDT_FACES {
    int unk_00;
    int header_size; /**< Size of this header in bytes; the first FACES_ID record follows it. */
    int prim_num;    /**< Number of FACES_ID records in the section. */
    int unk_0c;
};

STATIC_ASSERT(sizeof(MDT_FACES) == 0x10);
PORT_RECORD_ASSERT(sizeof(MDT_FACES) == 0x10);

/**
 *
 * One primitive of an MDT model's face section: a run of vertex indices drawn with one material.
 *
 */
struct FACES_ID {
    u_int type;       /**< Primitive flags, which set how many indices make one face. */
    u_int vertex_num; /**< Number of vertices in the primitive. */
    u_int material;   /**< Index of the material the primitive is drawn with. */
    int   index[1];   /**< Vertex indices, as many as the faces need. */
};

namespace dc2::render {
/**
 *
 * Gives the byte extent of one complete face record within its remaining source bytes.
 *
 */
std::optional<std::size_t> FaceRecordBytes(std::span<const std::byte> remaining, bool shadow);

/**
 *
 * Checks destination space for a complete face, its indices and a possible new group.
 *
 */
bool FaceAllocationFits(mgCMemory &face_memory, mgCMemory &index_memory, std::size_t index_count);

/**
 *
 * Validates the sections and face records of one complete MDT source buffer.
 *
 */
std::optional<std::span<const std::byte>> ValidateMdtFaceSection(std::span<const std::byte> model, bool shadow);

/**
 *
 * Selects the arena storage used by one model while its face records are built.
 *
 */
enum class MdtStorage {
    Owned,
    Borrowed,
    Shadow
};

/**
 *
 * Gives the maximum quadwords allocated while assigning a validated MDT model.
 *
 */
std::optional<std::size_t> RequiredMdtQuadwords(const MDT_HEADER          &header,
                                                std::span<const std::byte> face_section,
                                                MdtStorage                 storage);
} // namespace dc2::render

/**
 *
 * One material of a model as a visual draws it: its colours and the texture it is mapped with.
 *
 */
struct mgMaterial {
    sceVu0FVECTOR diffuse; /**< Colour the material is drawn with, sent alone when only the colour is needed. */
    sceVu0FVECTOR unk_10;
    mgCTexture   *texture; /**< Texture the material is mapped with, or NULL for an untextured material. */
};

STATIC_ASSERT(sizeof(mgMaterial) == 0x30);

/**
 *
 * One primitive of a model, made from a FACES_ID record and its persistent vertex indices.
 *
 */
class mgCFace {
public:
    u_short  type;         /**< Primitive bits, from mgFaceType. */
    short    index_stride; /**< Number of indices that make one vertex. */
    short    material;     /**< Index of the material the primitive is drawn with. */
    short    index_num;    /**< Number of indices, index_stride for each vertex. */
    short    vertex_num;   /**< Number of vertices in the primitive. */
    int     *index;        /**< Vertex indices: position, then normal, texture coordinate and colour as the type gives them. */
    mgCFace *next;         /**< Following primitive of the same material, or NULL. */
};

static_assert(sizeof(mgCFace) == 0x20);

/**
 *
 * The primitives of a model that share one material, and the packet that draws them.
 *
 */
struct mgFACE_GROUP {
    int           material;    /**< Index of the material the group is drawn with. */
    mgCFace      *face;        /**< First primitive of the group. */
    mgFACE_GROUP *next;        /**< Following group of the model, or NULL. */
    int           vu_program;  /**< VU1 microprogram the group is drawn with, from mgVU_PROG_ID. */
    u_long128    *packet;      /**< Packet that draws the group, registered with the draw manager. */
    int           packet_size; /**< Size of the packet in quadwords. */
    int           unk_18;
    int           unk_1c;
};

STATIC_ASSERT(sizeof(mgFACE_GROUP) == 0x20);

class mgCVisual;

namespace dc2::render {
/**
 * Records the concrete class selected by a native visual producer.
 */
enum class VisualCloneKind {
    Mdt,
    FixMdt,
    ShadowMdt,
    ShadowFixMdt,
    MotionMdt,
    Sprite3D,
    Water
};

/**
 * Authorizes cloning one exact visual object and its material allocation.
 */
class VisualCloneInputs {
public:
    /**
     * Publishes exact clone inputs after a typed producer finishes the visual.
     */
    static bool Publish(mgCMemory &producer, mgCVisual &visual, VisualCloneKind kind);
    /**
     * Validates the object before inspecting its current material identities.
     */
    [[nodiscard]] bool Matches(const mgCVisual *visual) const;
    /**
     * Validates an externally held object capability before entering its virtual clone implementation.
     */
    [[nodiscard]] mgCVisual *Clone(mgCVisual *expected, mgCMemory *memory) const;
    /**
     * Returns the producer's concrete kind only while its clone inputs remain valid.
     */
    [[nodiscard]] std::optional<VisualCloneKind> Kind(const mgCVisual *visual) const;

private:
    dc2::memory::ArenaResource state{}; /**< Immutable exact clone input metadata. */
};

static_assert(std::is_trivially_copyable_v<VisualCloneInputs>);
static_assert(std::is_trivially_destructible_v<VisualCloneInputs>);
} // namespace dc2::render

/**
 *
 * Base of everything a frame can draw: the draw settings shared by all visuals and the calls a frame makes on its visual.
 *
 */
class mgCVisual {
    friend class dc2::render::VisualCloneInputs;

public:
    dc2::render::VisualCloneInputs clone_inputs{}; /**< Exact producer capabilities for clone payload reads. */
    int                            unk_00{};
    mgCDrawEnv                    *draw_env{};        /**< Draw environment the visual is drawn with, or NULL for the render info's own. */
    mgCTextureManager             *texture_manager{}; /**< Texture manager the visual's textures come from, or NULL for the global one. */
    u_int                          prmode{};          /**< Value the visual writes to the GS PRMODE register. */
    int                            vu1_base{};        /**< VU1 memory base address sent with the VIF BASE command. */
    int                            vu1_offset{};      /**< VU1 double-buffer offset sent with the VIF OFFSET command. */
    int                            unk_18{};

    /**
     *
     * Creates a visual with its draw settings cleared.
     *
     * @mangled __ct__9mgCVisualFv
     */
    mgCVisual() { Initialize(); }

    /**
     *
     * Returns the kind of this visual.
     *
     * @mangled Iam__9mgCVisualFv
     * @address 0x133DC0
     * @size 0x10
     */
    virtual int Iam();

    /**
     *
     * Returns the number of materials the visual has.
     *
     * @mangled GetMaterialNum__9mgCVisualFv
     * @address 0x134980
     * @size 0x10
     */
    virtual int GetMaterialNum();

    /**
     *
     * Returns the visual's material table, or NULL if it has none.
     *
     * @mangled GetpMaterial__9mgCVisualFv
     * @address 0x134990
     * @size 0x10
     */
    virtual mgMaterial *GetpMaterial();

    /**
     *
     * Returns one of the visual's materials, or NULL if the index is out of range.
     *
     * @mangled GetMaterial__9mgCVisualFi
     * @address 0x1349A0
     * @size 0x10
     */
    virtual mgMaterial *GetMaterial(int index);

protected:
    /**
     *
     * Returns a copy of the visual allocated from memory; a visual with nothing to copy returns itself.
     *
     * @mangled Copy__9mgCVisualFP9mgCMemory
     * @address 0x133DD0
     * @size 0x10
     */
    virtual mgCVisual *Copy(mgCMemory *memory);

public:
    /**
     *
     * Writes the visual's bounding box and returns non-zero if it has one.
     *
     * @mangled CreateBBox__9mgCVisualFPfPfPA4_f
     * @address 0x1349B0
     * @size 0x10
     */
    virtual int CreateBBox(float *max, float *min, float (*matrix)[4]);

    /**
     *
     * Writes the packet that sets up drawing the visual and returns its length in quadwords.
     *
     * @mangled CreateRenderInfoPacket__9mgCVisualFPUiPA4_fP13mgRENDER_INFO
     * @address 0x1349C0
     * @size 0x10
     */
    virtual int CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info);

    /**
     *
     * Builds the visual's draw packet ahead of time and returns its size.
     *
     * @mangled CreatePacket__9mgCVisualFP9mgCMemoryP9mgCMemory
     * @address 0x134970
     * @size 0x10
     */
    virtual int CreatePacket(mgCMemory *memory, mgCMemory *work_memory);

    /**
     *
     * Draws the visual through the draw manager with no packet of the caller's.
     *
     * @mangled Draw__9mgCVisualFPA4_fP14mgCDrawManager
     * @address 0x1349E0
     * @size 0x40
     */
    virtual void Draw(float (*matrix)[4], mgCDrawManager *draw_manager);

    /**
     *
     * Writes the visual into a packet and returns the number of quadwords written.
     *
     * @mangled Draw__9mgCVisualFPUiPA4_fP14mgCDrawManager
     * @address 0x1349D0
     * @size 0x10
     */
    virtual int Draw(u_int *packet, float (*matrix)[4], mgCDrawManager *draw_manager);

    /**
     *
     * Clears the visual's draw settings.
     *
     * @mangled Initialize__9mgCVisualFv
     * @address 0x133440
     * @size 0x20
     */
    virtual void Initialize();

    /**
     *
     * Returns the visual's texture manager, or the global one if it has none.
     *
     * @mangled GetTextureManager__9mgCVisualFv
     * @address 0x13EE90
     * @size 0x30
     */
    mgCTextureManager *GetTextureManager();

    /**
     *
     * Writes a copy of a draw environment adjusted by the render info's settings and returns its length in quadwords.
     *
     * @mangled SetDrawEnvGifTag__9mgCVisualFP1P13mgRENDER_INFOP10mgCDrawEnv
     * @address 0x13EEC0
     * @size 0x270
     */
    int SetDrawEnvGifTag(u_long128 *packet, mgRENDER_INFO *info, mgCDrawEnv *base);
};

STATIC_ASSERT(sizeof(mgCVisual) == 0x20);

/**
 *
 * A model drawn from an MDT file: its vertex data, materials and face lists, from which it builds the
 * VU1 packets that draw it each frame.
 *
 */
class mgCVisualMDT : public mgCVisual {
public:
    int            vertex_num{};   /**< Number of vertex positions. */
    int            normal_num{};   /**< Number of normal vectors. */
    int            colour_num{};   /**< Number of per-vertex colours. */
    int            uv_num{};       /**< Number of texture coordinates. */
    sceVu0FVECTOR *vertex{};       /**< Vertex positions. */
    sceVu0FVECTOR *normal{};       /**< Normal vectors. */
    sceVu0FVECTOR *colour{};       /**< Per-vertex colours. */
    sceVu0FVECTOR *uv{};           /**< Texture coordinates. */
    int            material_num{}; /**< Number of materials. */
    mgMaterial    *material{};     /**< Material table. */
    mgFACE_GROUP  *face_group{};   /**< First group of primitives, one per material used. */

    /**
     *
     * Creates a model with no data.
     *
     * @mangled __ct__12mgCVisualMDTFv
     */
    mgCVisualMDT() {
        Initialize();
    }

    /**
     *
     * Returns one of the model's materials, or NULL when the model has no materials or the index
     * is out of range.
     *
     * @mangled GetMaterial__12mgCVisualMDTFi
     * @address 0x13F5D0
     * @size 0x4C
     */
    mgMaterial *GetMaterial(int index) override;

    /**
     *
     * Returns the kind of this visual.
     *
     * @mangled Iam__12mgCVisualMDTFv
     * @address 0x134900
     * @size 0xC
     */
    int Iam() override;

    /**
     *
     * Returns the number of materials the model has.
     *
     * @mangled GetMaterialNum__12mgCVisualMDTFv
     * @address 0x134910
     * @size 0xC
     */
    int GetMaterialNum() override;

    /**
     *
     * Returns the model's material table.
     *
     * @mangled GetpMaterial__12mgCVisualMDTFv
     * @address 0x134920
     * @size 0xC
     */
    mgMaterial *GetpMaterial() override;

    /**
     *
     * Writes the bounds of the model's vertex positions and returns non-zero when it has any.
     *
     * @mangled CreateBBox__12mgCVisualMDTFPfPfPA4_f
     * @address 0x13F630
     * @size 0x4C
     */
    int CreateBBox(float *min, float *max, float (*matrix)[4]) override;

    /**
     *
     * Writes and sends the packet that sets up drawing the model: its transforms, lighting, fog,
     * GS modes and draw environment, and returns its length in quadwords.
     *
     * @mangled CreateRenderInfoPacket__12mgCVisualMDTFPUiPA4_fP13mgRENDER_INFO
     * @address 0x140B40
     * @size 0x708
     */
    int CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info) override;

    /**
     *
     * Draws the model through the draw manager with no packet of the caller's.
     *
     * @mangled Draw__12mgCVisualMDTFPA4_fP14mgCDrawManager
     * @address 0x134930
     * @size 0x38
     */
    void Draw(float (*matrix)[4], mgCDrawManager *draw_manager) override;

    /**
     *
     * Builds the model's packets in the draw manager's buffers, then either registers each material
     * group with the draw manager or, given a packet, writes calls to them into it and returns its
     * length in quadwords.
     *
     * @mangled Draw__12mgCVisualMDTFPUiPA4_fP14mgCDrawManager
     * @address 0x13FB50
     * @size 0x1BC
     */
    int Draw(u_int *tag, float (*matrix)[4], mgCDrawManager *draw_manager) override;

    /**
     *
     * Clears the model's data and resets the VU1 buffer layout to the model microprogram's.
     *
     * @mangled Initialize__12mgCVisualMDTFv
     * @address 0x13F130
     * @size 0x54
     */
    void Initialize() override;

    /**
     *
     * Builds the model's packet in the draw manager's buffers, one chain per material group, and
     * returns its DMA address.
     *
     * @mangled CreatePacket__12mgCVisualMDTFP14mgCDrawManager
     * @address 0x13FD10
     * @size 0x27C
     */
    virtual uptr CreatePacket(mgCDrawManager *draw_manager);

    /**
     *
     * Writes the VU1 packet for one primitive, split into batches that fit the VU1 buffer, and
     * returns its length in quadwords.
     *
     * @mangled CreateFacePacket__12mgCVisualMDTFPUiP7mgCFace
     * @address 0x1405D0
     * @size 0x56C
     */
    virtual int CreateFacePacket(u_int *packet, mgCFace *face);

    /**
     *
     * Creates a primitive from one face record of the model data and links it into the group of
     * its material, returning the record that follows.
     *
     * @mangled CreateFace__12mgCVisualMDTFP8FACES_IDP9mgCMemoryP9mgCMemoryPP7mgCFace
     * @address 0x13F680
     * @size 0x27C
     */
    virtual const FACES_ID *CreateFace(const FACES_ID *faces, std::span<const std::byte> remaining,
                                       mgCMemory *memory, mgCMemory *index_memory,
                                       mgCFace **face);

    /**
     *
     * Writes the model's own additions to the setup packet and returns their length in quadwords;
     * a plain model has none.
     *
     * @mangled CreateExtRenderInfoPacket__12mgCVisualMDTFPUiPA4_fP13mgRENDER_INFO
     * @address 0x141250
     * @size 0x8
     */
    virtual int CreateExtRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info);

    /**
     *
     * Copies the model's data from an MDT file and creates its primitives; returns zero when there
     * is no data.
     *
     * @mangled DataAssignMDT__12mgCVisualMDTFP10MDT_HEADERP9mgCMemoryP17mgCTextureManager
     * @address 0x13F900
     * @size 0xC8
     */
    virtual int DataAssignMDT(std::span<std::byte> model, mgCMemory *memory,
                              mgCTextureManager *textures);

protected:
    /**
     *
     * Copies the counts, vertex data and materials of an MDT file into memory of the model's own.
     *
     * @mangled CopyMDTData__12mgCVisualMDTFP10MDT_HEADERP9mgCMemory
     * @address 0x13F210
     * @size 0x278
     */
    void CopyMDTData(MDT_HEADER *header, mgCMemory *memory);

    /**
     *
     * Points the model's vertex data into an MDT file in place, copying only its materials into
     * memory.
     *
     * @mangled CopyMDTDataPointer__12mgCVisualMDTFP10MDT_HEADERP9mgCMemory
     * @address 0x13F490
     * @size 0x134
     */
    void CopyMDTDataPointer(MDT_HEADER *header, mgCMemory *memory);

public:
    /**
     *
     * Returns the model's per-vertex colours and writes their number.
     *
     * @mangled GetColor__12mgCVisualMDTFPi
     * @address 0x13F620
     * @size 0x10
     */
    sceVu0FVECTOR *GetColor(int *out);
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
     *
     * Creates a model with no data.
     *
     * @mangled __ct__15mgCVisualFixMDTFv
     */
    mgCVisualFixMDT() {
        Initialize();
    }

    /**
     *
     * Returns the kind of this visual.
     *
     * @mangled Iam__15mgCVisualFixMDTFv
     * @address 0x141840
     * @size 0x8
     */
    int Iam() override;

protected:
    /**
     *
     * Returns a copy of the model allocated from memory, sharing its vertex data and primitives
     * but with a material table of its own.
     *
     * @mangled Copy__15mgCVisualFixMDTFP9mgCMemory
     * @address 0x141260
     * @size 0x190
     */
    mgCVisual *Copy(mgCMemory *memory) override;

public:
    /**
     *
     * Clears the model's data.
     *
     * @mangled Initialize__15mgCVisualFixMDTFv
     * @address 0x133420
     * @size 0x20
     */
    void Initialize() override;

    /**
     *
     * Builds the model's packet in the draw manager's buffers from the prebuilt primitive packets,
     * one chain per material group, and returns its address.
     *
     * @mangled CreatePacket__15mgCVisualFixMDTFP14mgCDrawManager
     * @address 0x13FF90
     * @size 0x228
     */
    uptr CreatePacket(mgCDrawManager *draw_manager) override;

    /**
     *
     * Points the model at an MDT file's data, creates its primitives and builds each primitive's
     * packet in memory; returns non-zero.
     *
     * @mangled DataAssignMDT__15mgCVisualFixMDTFP10MDT_HEADERP9mgCMemoryP17mgCTextureManager
     * @address 0x13F9D0
     * @size 0x180
     */
    int DataAssignMDT(std::span<std::byte> model, mgCMemory *memory,
                      mgCTextureManager *textures) override;
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
     *
     * Creates a visual with its settings reset.
     *
     * @mangled __ct__13mgCVisualPrimFv
     */
    mgCVisualPrim() {
        Initialize();
    }

    /**
     *
     * Returns zero because native primitive draws submit directly.
     *
     * @mangled CreateRenderInfoPacket__13mgCVisualPrimFPUiPA4_fP13mgRENDER_INFO
     * @address 0x141700
     * @size 0x11C
     */
    int CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info) override;

    /**
     *
     * Returns the kind of this visual.
     *
     * @mangled Iam__13mgCVisualPrimFv
     * @address 0x13C2F0
     * @size 0x8
     */
    int Iam() override;

    /**
     *
     * Clears the visual's draw settings and resets its GS settings.
     *
     * @mangled Initialize__13mgCVisualPrimFv
     * @address 0x141820
     * @size 0x1C
     */
    void Initialize() override;
};

/**
 *
 * Writes a copy of a draw environment adjusted by a visual's GS settings.
 *
 * @mangled SetDrawEnv__FP10mgCDrawEnvP13mgCVisualAttrP10mgCDrawEnv
 * @address 0x141490
 * @size 0x270
 */
void SetDrawEnv(mgCDrawEnv *env, mgCVisualAttr *attr, mgCDrawEnv *base);
