#pragma once

#include "common.h"

#include <libvu0.h>

/**
 * @file
 * Declares the engine's model data sets: the MDS scene and MDT model file formats, the loader that
 * turns a scene into a table of frames with visuals attached, the base of every visual, and the
 * builder that writes an MDT model in memory.
 */

class mgCMemory;
class mgCFrame;
class mgCVisualMDT;
class mgCTextureManager;
class mgCDrawManager;
class mgCDrawEnv;
class mgRENDER_INFO;
struct mgMaterial;

/**
 *
 * Identifies the kind of a visual, as the Iam function of each visual class returns it.
 *
 */
enum mgVisualKind {
    MG_VISUAL_KIND_VISUAL = 0,     /**< A plain mgCVisual, or a class that keeps its Iam. */
    MG_VISUAL_KIND_MDT = 1,        /**< An mgCVisualMDT, or a shadow model built on it. */
    MG_VISUAL_KIND_FIX_MDT = 2,    /**< An mgCVisualFixMDT. */
    MG_VISUAL_KIND_MOTION_MDT = 3, /**< An mgCVisualMotionMDT, whose vertices follow other frames. */
    MG_VISUAL_KIND_PRIM = 7,       /**< An mgCVisualPrim. */
};

/**
 *
 * Selects which visual class the scene loader builds for an object's model.
 *
 */
enum mgVisualCreateType {
    MG_VISUAL_CREATE_END = -1,           /**< Ends a table of mgCreateVisualType entries. */
    MG_VISUAL_CREATE_MDT = 0,            /**< An mgCVisualMDT, with its bounds widened by half. */
    MG_VISUAL_CREATE_FIX_MDT = 1,        /**< An mgCVisualFixMDT; the default when a table names no type. */
    MG_VISUAL_CREATE_SHADOW_MDT = 2,     /**< An mgCShadowMDT. */
    MG_VISUAL_CREATE_SHADOW_FIX_MDT = 3, /**< An mgCShadowFixMDT. */
    MG_VISUAL_CREATE_MOTION_MDT = 4,     /**< An mgCVisualMotionMDT; an mgCVisualFixMDT when no weight data is given. */
};

/**
 *
 * Names the section of an MDT model that mgCMDTBuilder is writing between BeginData and EndData.
 *
 */
enum mgMDTDataType {
    MG_MDT_DATA_NONE = 0,     /**< No section is open. */
    MG_MDT_DATA_VERTEX = 1,   /**< Vertex positions. */
    MG_MDT_DATA_NORMAL = 2,   /**< Normal vectors, whose fourth component is written as zero. */
    MG_MDT_DATA_UV = 3,       /**< Texture coordinates. */
    MG_MDT_DATA_COLOUR = 4,   /**< Per-vertex colours. */
    MG_MDT_DATA_MATERIAL = 5, /**< Material records. */
};

/**
 *
 * Starts an MDT model: the counts of each data section and their byte offsets from this header.
 *
 */
struct MDT_HEADER {
    char magic[4];    /**< Identifies the file as a model: "MDT". */
    int header_size;  /**< Size of this header in bytes. */
    int unk_08;
    int vertex_num;   /**< Number of vertex positions. */
    int vertex_ofs;   /**< Byte offset from the header to the vertex positions. */
    int normal_num;   /**< Number of normal vectors. */
    int normal_ofs;   /**< Byte offset from the header to the normal vectors. */
    int colour_num;   /**< Number of per-vertex colours. */
    int colour_ofs;   /**< Byte offset from the header to the per-vertex colours. */
    int faces_size;   /**< Size in bytes of the face section. */
    int faces_ofs;    /**< Byte offset from the header to the face section. */
    int uv_num;       /**< Number of texture coordinates. */
    int uv_ofs;       /**< Byte offset from the header to the texture coordinates. */
    int material_num; /**< Number of material records. */
    int material_ofs; /**< Byte offset from the header to the material records. */
    int unk_3c;
};
STATIC_ASSERT(sizeof(MDT_HEADER) == 0x40);

/**
 *
 * Describes one material of an MDT model: its colours and the name of the texture it draws with.
 *
 */
struct MDT_MATERIAL_ {
    sceVu0FVECTOR diffuse; /**< Colour the material is drawn with. */
    float unk_10[4];
    float unk_20[4];
    float unk_30;
    char texture[32];      /**< Name of the texture the material draws with. */
    int unk_54;
    float extra[2];
};
STATIC_ASSERT(sizeof(MDT_MATERIAL_) == 0x60);

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

/**
 *
 * One primitive of an MDT model's face section: a run of vertex indices drawn with one material.
 *
 */
struct FACES_ID {
    u_int type;     /**< Primitive flags, which set how many indices make one face. */
    u_int face_num; /**< Number of faces in the primitive. */
    u_int material; /**< Index of the material the primitive is drawn with. */
    int index[1];   /**< Vertex indices, as many as the faces need. */
};

/**
 *
 * Starts an MDS scene file: the number of objects and where the first object record lies.
 *
 */
struct MDS_HEADER {
    int unk_00;
    int unk_04;
    u_int object_num; /**< Number of object records in the scene. */
    int object_ofs;   /**< Byte offset from this header to the first object record. */
};
STATIC_ASSERT(sizeof(MDS_HEADER) == 0x10);

/**
 *
 * One object of an MDS scene: its name, its parent, its transform and the model it draws.
 *
 */
struct MDTOBJ_HEADER {
    int unk_00;
    int size;               /**< Size of this record in bytes, which leads to the next record. */
    char name[32];          /**< Name of the object, which also carries its attribute text. */
    int mdt_ofs;            /**< Byte offset from the scene header to the object's MDT model, or zero for none. */
    int parent;             /**< Index of the parent object, or a negative value for none. */
    sceVu0FMATRIX matrix;   /**< Transform of the object relative to its parent. */
};
STATIC_ASSERT(sizeof(MDTOBJ_HEADER) == 0x70);

/**
 *
 * Pairs an object name with the visual class that the scene loader builds for objects of that name.
 *
 */
struct mgCreateVisualType {
    int type;   /**< Visual class to build, from mgVisualCreateType; MG_VISUAL_CREATE_END ends the table. */
    char *name; /**< Object name the entry applies to, an empty name for every other object, or NULL to end the table. */
};
STATIC_ASSERT(sizeof(mgCreateVisualType) == 0x8);

/**
 *
 * Gathers what the scene loader needs: the scene, the memory it builds into and how to build visuals.
 *
 */
struct mgLoadData {
    MDS_HEADER *mds;                      /**< Scene file to load. */
    mgCMemory *memory;                    /**< Memory the frames, visuals and model data are allocated from. */
    mgCMemory *work_memory;               /**< Memory the visuals use while they are being built. */
    mgCreateVisualType *visual_type;      /**< Table choosing the visual class per object, or NULL for the default. */
    mgCTextureManager *texture_manager;   /**< Texture manager the materials look textures up in, or NULL for the global one. */
    u_int *weight;                        /**< Vertex weight data for motion models, or NULL. */
    float (*matrix)[4][4];                /**< Matrices copied into a frame table when its frames are exchanged, or NULL. */
    int unk_1c[9];
};
STATIC_ASSERT(sizeof(mgLoadData) == 0x40);

/**
 *
 * Base of everything a frame can draw: the draw settings shared by all visuals and the calls a frame makes on its visual.
 *
 */
class mgCVisual {
public:
    int unk_00;
    mgCDrawEnv *draw_env;               /**< Draw environment the visual is drawn with, or NULL for the render info's own. */
    mgCTextureManager *texture_manager; /**< Texture manager the visual's textures come from, or NULL for the global one. */
    u_int prmode;                       /**< Value the visual writes to the GS PRMODE register. */
    int vu1_base;                       /**< VU1 memory base address sent with the VIF BASE command. */
    int vu1_offset;                     /**< VU1 double-buffer offset sent with the VIF OFFSET command. */
    int unk_18;

    /**
     * Creates a visual with its draw settings cleared.
     *
     * @mangled __ct__9mgCVisualFv
     */
    mgCVisual() { Initialize(); }

    /**
     * Returns the kind of this visual.
     *
     * @mangled Iam__9mgCVisualFv
     * @address 0x133DC0
     * @size 0x10
     */
    virtual int Iam() ;

    /**
     * Returns the number of materials the visual has.
     *
     * @mangled GetMaterialNum__9mgCVisualFv
     * @address 0x134980
     * @size 0x10
     */
    virtual int GetMaterialNum() ;

    /**
     * Returns the visual's material table, or NULL if it has none.
     *
     * @mangled GetpMaterial__9mgCVisualFv
     * @address 0x134990
     * @size 0x10
     */
    virtual mgMaterial *GetpMaterial() ;

    /**
     * Returns one of the visual's materials, or NULL if the index is out of range.
     *
     * @mangled GetMaterial__9mgCVisualFi
     * @address 0x1349A0
     * @size 0x10
     */
    virtual mgMaterial *GetMaterial(int index) ;

    /**
     * Returns a copy of the visual allocated from memory; a visual with nothing to copy returns itself.
     *
     * @mangled Copy__9mgCVisualFP9mgCMemory
     * @address 0x133DD0
     * @size 0x10
     */
    virtual mgCVisual *Copy(mgCMemory *memory) ;

    /**
     * Writes the visual's bounding box and returns non-zero if it has one.
     *
     * @mangled CreateBBox__9mgCVisualFPfPfPA4_f
     * @address 0x1349B0
     * @size 0x10
     */
    virtual int CreateBBox(float *max, float *min, float (*matrix)[4]) ;

    /**
     * Writes the packet that sets up drawing the visual and returns its length in quadwords.
     *
     * @mangled CreateRenderInfoPacket__9mgCVisualFPUiPA4_fP13mgRENDER_INFO
     * @address 0x1349C0
     * @size 0x10
     */
    virtual int CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info) ;

    /**
     * Builds the visual's draw packet ahead of time and returns its size.
     *
     * @mangled CreatePacket__9mgCVisualFP9mgCMemoryP9mgCMemory
     * @address 0x134970
     * @size 0x10
     */
    virtual int CreatePacket(mgCMemory *memory, mgCMemory *work_memory) ;

    /**
     * Draws the visual through the draw manager with no packet of the caller's.
     *
     * @mangled Draw__9mgCVisualFPA4_fP14mgCDrawManager
     * @address 0x1349E0
     * @size 0x40
     */
    virtual void Draw(float (*matrix)[4], mgCDrawManager *draw_manager) ;

    /**
     * Writes the visual into a packet and returns the number of quadwords written.
     *
     * @mangled Draw__9mgCVisualFPUiPA4_fP14mgCDrawManager
     * @address 0x1349D0
     * @size 0x10
     */
    virtual int Draw(u_int *packet, float (*matrix)[4], mgCDrawManager *draw_manager) ;

    /**
     * Clears the visual's draw settings.
     *
     * @mangled Initialize__9mgCVisualFv
     * @address 0x133440
     * @size 0x20
     */
    virtual void Initialize() ;

    /**
     * Returns the visual's texture manager, or the global one if it has none.
     *
     * @mangled GetTextureManager__9mgCVisualFv
     * @address 0x13EE90
     * @size 0x30
     */
    mgCTextureManager *GetTextureManager();

    /**
     * Writes a copy of a draw environment adjusted by the render info's settings and returns its length in quadwords.
     *
     * @mangled SetDrawEnvGifTag__9mgCVisualFP1P13mgRENDER_INFOP10mgCDrawEnv
     * @address 0x13EEC0
     * @size 0x270
     */
    int SetDrawEnvGifTag(u_long128 *packet, mgRENDER_INFO *info, mgCDrawEnv *draw_env);
};
STATIC_ASSERT(sizeof(mgCVisual) == 0x20);

/**
 *
 * Writes an MDT model into memory piece by piece, for models the game makes rather than loads.
 *
 */
class mgCMDTBuilder {
public:
    mgCMemory *memory;      /**< Memory the model is written into. */
    MDT_HEADER *header;     /**< Header of the model being written. */
    union { char *end; int cursor; };              /**< End of the model written so far. */
    union { char *data; int sectionStart; u_long128 *dataCursor; MDT_MATERIAL_ *materialCursor; };             /**< Write position inside the open data section. */
    int data_num;           /**< Number of entries written to the open data section. */
    union { MDT_FACES *faces; int *faceBlock; int faceBlockAddr; };       /**< Header of the face section. */
    FACES_ID *prim;         /**< Primitive being written. */
    int index_num;          /**< Number of indices added to the primitive. */
    int face_index_num;     /**< Number of indices that make one face of the primitive. */
    union { int *index; int *faceCursor; int faceEnd; };             /**< Write position for the next index of the face section. */
    int data_type;          /**< Section open for writing, from mgMDTDataType. */
    int unk_2c;
    MDT_MATERIAL_ material; /**< Material record written by SetMaterial. */

    /**
     * Starts a model in memory, writing its header.
     *
     * @mangled Begin__13mgCMDTBuilderFP9mgCMemory
     * @address 0x134170
     * @size 0xC0
     */
    void Begin(mgCMemory *memory);

    /**
     * Ends the model, keeping the memory it was written into, and returns its header.
     *
     * @mangled End__13mgCMDTBuilderFv
     * @address 0x134230
     * @size 0x60
     */
    MDT_HEADER *End();

    /**
     * Ends the model and attaches it to a frame through a visual, setting the frame's bounds and attributes.
     *
     * @mangled End__13mgCMDTBuilderFP8mgCFrameP12mgCVisualMDTP10mgLoadData
     * @address 0x134290
     * @size 0x180
     */
    void End(mgCFrame *frame, mgCVisualMDT *visual, mgLoadData *load);

    /**
     * Opens a data section of the type given by mgMDTDataType, if none is open.
     *
     * @mangled BeginData__13mgCMDTBuilderFi
     * @address 0x134410
     * @size 0x30
     */
    void BeginData(int type);

    /**
     * Adds one vector to the open vertex, normal, texture-coordinate or colour section.
     *
     * @mangled SetData__13mgCMDTBuilderFPf
     * @address 0x134440
     * @size 0x80
     */
    void SetData(float *vector);

    /**
     * Adds one vector, given by its components, to the open data section.
     *
     * @mangled SetData__13mgCMDTBuilderFffff
     * @address 0x1344C0
     * @size 0x60
     */
    void SetData(float x, float y, float z, float w);

    /**
     * Adds one material with a colour and a texture name to the open material section.
     *
     * @mangled SetMaterial__13mgCMDTBuilderFPfPc
     * @address 0x134520
     * @size 0x120
     */
    void SetMaterial(float *colour, char *texture);

    /**
     * Closes the open data section, recording its count and offset in the header.
     *
     * @mangled EndData__13mgCMDTBuilderFv
     * @address 0x134640
     * @size 0x110
     */
    void EndData();

    /**
     * Starts the face section.
     *
     * @mangled BeginFaces__13mgCMDTBuilderFv
     * @address 0x134750
     * @size 0x70
     */
    void BeginFaces();

    /**
     * Ends the face section, recording its size in the header.
     *
     * @mangled EndFaces__13mgCMDTBuilderFv
     * @address 0x1347C0
     * @size 0x40
     */
    void EndFaces();

    /**
     * Starts a primitive of the given type, drawn with the given material.
     *
     * @mangled BeginPrim__13mgCMDTBuilderFii
     * @address 0x134800
     * @size 0x90
     */
    void BeginPrim(int type, int material);

    /**
     * Adds one vertex index to the primitive.
     *
     * @mangled AddFace__13mgCMDTBuilderFi
     * @address 0x134890
     * @size 0x30
     */
    void AddFace(int index);

    /**
     * Ends the primitive, recording its face count.
     *
     * @mangled EndPrim__13mgCMDTBuilderFv
     * @address 0x1348C0
     * @size 0x40
     */
    void EndPrim();
};
STATIC_ASSERT(sizeof(mgCMDTBuilder) == 0x90);

/**
 * Reads the attribute text after "--" in a frame's name into its frame attributes, and does the
 * same for its children when asked.
 *
 * @mangled mgSetFrameAttr__FP8mgCFramei
 * @address 0x132620
 * @size 0x660
 */
void mgSetFrameAttr(mgCFrame *frame, int recursive);

/**
 * Loads a scene into a table of frames, building each object's visual, and returns the first frame.
 *
 * @mangled mgLoadMDSFile__FP10MDS_HEADERP9mgCMemoryP18mgCreateVisualTypeP17mgCTextureManager
 * @address 0x133460
 * @size 0x80
 */
mgCFrame *mgLoadMDSFile(MDS_HEADER *mds, mgCMemory *memory, mgCreateVisualType *visual_type, mgCTextureManager *texture_manager);

/**
 * Loads the scene a load description names into a table of frames and returns the first frame.
 *
 * @mangled mgLoadMDSFile__FP10mgLoadData
 * @address 0x1334E0
 * @size 0x400
 */
mgCFrame *mgLoadMDSFile(mgLoadData *load);

/**
 * Writes the bounding box and bounding sphere of a run of vertices; the sphere's fourth component is its radius.
 *
 * @mangled mgCreateBBoxSphere__FPfPfPfPA4_fi
 * @address 0x1338E0
 * @size 0x1A0
 */
void mgCreateBBoxSphere(float *max, float *min, float *sphere, float (*vertex)[4], int vertex_num);

/**
 * Copies a frame and its hierarchy into memory, copying the visuals when asked, and returns the copy.
 *
 * @mangled mgCopyFrame__FP8mgCFrameP9mgCMemoryi
 * @address 0x133EF0
 * @size 0x280
 */
mgCFrame *mgCopyFrame(mgCFrame *frame, mgCMemory *memory, int copy_visual);
