#include "common.h"

#include <libvu0.h>

#include <algorithm>
#include <cstddef>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <iterator>
#include <limits>
#include <span>
#include <string>
#include <string_view>

#include "assets/data_registry.hpp"
#include "character_motion.hpp"
#include "log/log.hpp"
#include "mg_dataset.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_shadow.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "platform/model_assets.hpp"
#include "text/bounded.hpp"
#include "visualmotion.hpp"

/**
 *
 * Writes an object name with its "__" attribute marker turned into "--" and each attribute flag
 * after it in the form mgSetFrameAttr reads, and returns the length of the result with its end.
 *
 */
std::string ConvertFrameName(std::string_view source) {
    const auto marker = source.find("__");
    if (marker == std::string_view::npos) {
        return std::string(source);
    }

    std::string result(source.substr(0, marker));
    result += "--";
    const auto suffix = source.substr(marker + 2);
    for (std::size_t index = 0; index < suffix.size(); ++index) {
        switch (suffix[index]) {
            case 'c':
            case 'C':
                result += "c0";
                break;
            case 'n':
            case 'N':
                result += "n1";
                break;
            case 'z':
            case 'Z':
                result += "z0";
                break;
            case 'f':
            case 'F':
                result += "f0";
                break;
            case 's':
            case 'S':
                result += "s1";
                break;
            case 'm':
            case 'M':
                result += "m1";
                break;
            case 'o':
            case 'O':
                result += "o1";
                break;
            case 'v':
            case 'V':
                result += "v0";
                break;
            case 't':
            case 'T':
                result += 't';
                break;
            case 'b':
            case 'B':
                result += 'b';
                if (index + 1 < suffix.size()) {
                    result += suffix[++index];
                }
                break;
            case 'a':
            case 'A':
                if (suffix.size() - index < 3) {
                    return result;
                }
                result += 'a';
                result += suffix[index + 1];
                result += suffix[index + 2];
                index += 2;
                break;
            default:
                break;
        }
    }
    return result;
}

/**
 *
 * Reads a string of hexadecimal digits and returns its value; any other character counts as zero.
 *
 */
static int htoi(char *text) {
    char *end = text;
    s32   length = 0;
    s32   value = 0;

    while (*end++ != 0) {
        length++;
    }

    s32 i = {};
    s32 place = 1;

    for (i = 0; i < length; i++) {
        s32 back = length - i;
        s32 ch = ((u8 *) (back + (uptr) text))[-1];
        s32 digit = 0;

        if (ch >= '0' && ch <= '9') {
            digit = ch - '0';
        }

        if (ch >= 'a' && ch <= 'f') {
            digit = ch - 'a' + 10;
        }

        if (ch >= 'A' && ch <= 'F') {
            digit = ch - 'A' + 10;
        }

        value += digit * place;
        place <<= 4;
    }

    return value;
}

void mgSetFrameAttr(mgCFrame *input_frame, int input_recursive) {
    mgCFrameAttr *attr = {};
    char         *cursor = {};
    char         *text = {};
    int           recursive = {};
    mgCFrame     *frame = {};
    char         *end = {};
    frame = input_frame;
    recursive = input_recursive;

    if (frame == nullptr) {
        return;
    }

    mgCFrameAttr default_attr;
    int          apply = {};
    int          mask = {};
    char         code[3];
    mgCFrame    *child = {};
    s8           current = {};

    attr = frame->attr;

    if (attr == nullptr) {
        attr = &default_attr;
    }

    cursor = frame->name;

    static char *name_def = "";

    if (cursor == nullptr) {
        cursor = name_def;
    }

    text = cursor;

    while ((current = *text) != 0) {
        if (current == 0) {
            apply = 0;
            break;
        } else {
            if (current == '-' && text[1] == '-') {
                text += 2;
                break;
            }
        }

        text++;
    }

    end = text + strlen(text) + 1;
    apply = 0;

    for (; text < end; text++) {
        mask = 0;

        switch (*text) {
            case 'c':
            case 'C':
                text++;
                attr->no_light = (*text - '0') == 0;
                mask = MG_FRAME_ATTR_NO_LIGHT | MG_FRAME_ATTR_COLOR;
                break;
            case 'n':
            case 'N':
                text++;
                attr->clip_enable = (*text - '0') != 0;
                mask = MG_FRAME_ATTR_CLIP;
                break;
            case 'a':
            case 'A': {
                char *second = {};
                int   first = {};
                code[0] = text[1];
                text += 2;
                *(second = code + 1) = *text;
                code[2] = '\0';

                if (code[0] >= 'a' && code[0] <= 'z') {
                    code[0] -= 'a' - 'A';
                }

                if (*second >= 'a' && *second <= 'z') {
                    *second -= 'a' - 'A';
                }

                first = code[0];

                if (first == 'P' && *second == 'P') {
                    attr->alpha_blend = MG_ALPHA_MACRO_ADD;
                    mask = MG_FRAME_ATTR_ALPHA_BLEND;
                } else if (first == 'N' && *second == 'N') {
                    attr->alpha_blend = MG_ALPHA_MACRO_SUB;
                    mask = MG_FRAME_ATTR_ALPHA_BLEND;
                } else if (first == 'O' && *second == 'F') {
                    mask = MG_FRAME_ATTR_ALPHA_BLEND;
                    attr->alpha_blend = MG_ALPHA_MACRO_OPAQUE;
                } else {
                    attr->alpha_ref = (short) htoi(code);
                    mask |= MG_FRAME_ATTR_ALPHA_REF;
                }

                break;
            }
            case 'z':
            case 'Z':
                text++;

                if (*text == 'p' || *text == 'P') {
                    text++;

                    if ((*text - '0') != 0) {
                        attr->depth_bias = 1.005f;
                    } else {
                        attr->depth_bias = 0.0f;
                    }

                    mask = MG_FRAME_ATTR_DEPTH_BIAS;
                } else {
                    if ((*text - '0') != 0) {
                        attr->z_write = MG_ZBUF_WRITE;
                    } else {
                        attr->z_write = MG_ZBUF_NO_WRITE;
                    }

                    mask = MG_FRAME_ATTR_Z_WRITE;
                }

                break;
            case 'f':
            case 'F':
                text++;
                attr->fog = *text - '0';
                mask = MG_FRAME_ATTR_FOG;
                break;
            case 's':
            case 'S':
                text++;
                attr->program_option = (*text - '0') != 0;
                mask = MG_FRAME_ATTR_PROGRAM_OPT;
                break;
            case 'm':
            case 'M':
                text++;
                attr->program_mode = *text - '0';
                mask = MG_FRAME_ATTR_PROGRAM_MODE;
                break;
            case 'b':
            case 'B':
                text++;

                if (*text == 'Y' || *text == 'y') {
                    attr->billboard = MG_FRAME_BILLBOARD_Y;
                }

                if (*text == 'A' || *text == 'a') {
                    attr->billboard = MG_FRAME_BILLBOARD_FULL;
                }

                mask = MG_FRAME_ATTR_BILLBOARD;
                break;
            case 't':
            case 'T':
                attr->ambient_boost = 1;
                mask = MG_FRAME_ATTR_AMBIENT_BOOST;
                break;
            case 'o':
            case 'O':
                text++;

                if ((*text - '0') != 0) {
                    attr->z_test = MG_DEPTH_TEST_ALWAYS;
                } else {
                    attr->z_test = 0;
                }

                mask = MG_FRAME_ATTR_Z_TEST;
                break;
            case 'v':
            case 'V':
                text++;

                if (*text == 'c' || *text == 'C') {
                    text++;
                    attr->unk_84 = *text - '0';
                } else {
                    if ((*text - '0') != 0) {
                        attr->draw = MG_FRAME_DRAW_VISIBLE;
                    } else {
                        attr->draw = MG_FRAME_DRAW_SKIP_CHILDREN;
                    }

                    mask = MG_FRAME_ATTR_DRAW;
                }

                break;
        }

        if (apply && mask) {
            frame->SetAttrParam(*attr, 1, mask);
        }

        if (*text == '.') {
            apply = 1;
        } else {
            apply = 0;
        }
    }

    if (recursive == 0) {
        return;
    }

    for (child = frame->child; child != nullptr; child = child->brother) {
        mgSetFrameAttr(child, recursive);
    }
}

/**
 *
 * Finds the entry of a visual type table that applies to an object name, or NULL if none does.
 *
 */
mgCreateVisualType *SearchVisualType(mgCreateVisualType *table, char *name) {
    mgCreateVisualType *entry = {};
    mgCreateVisualType *found = {};

    if (table == nullptr) {
        return nullptr;
    }

    entry = table;
    found = nullptr;

    while (1) {
        if (entry->name == nullptr) {
            break;
        }

        if (entry->type == -1) {
            break;
        }

        if (mgFrameNameComp(name, entry->name) != 0) {
            found = entry;
            break;
        }

        entry++;
    }

    return found;
}

// Defined inline in mg_frame.hpp.
// Defined inline in mg_visual.hpp.

void mgCFrame::SetVisual(mgCVisual *visual) {
    if (this->visual != visual) {
        clone_inputs = {};
    }
    this->visual = visual;
}

void mgCVisualFixMDT::Initialize() {
    mgCVisualMDT::Initialize();
}

void mgCVisual::Initialize() {
    clone_inputs = {};
    unk_00 = 0;
    draw_env = nullptr;
    texture_manager = nullptr;
    prmode = 0;
    vu1_offset = 0;
    vu1_base = 0;
    unk_18 = 0;
}

mgCFrame *mgLoadMDSFile(MDS_HEADER *mds, mgCMemory *memory, mgCreateVisualType *visual_type, mgCTextureManager *texture_manager);

mgCFrame *mgLoadMDSFile(mgLoadData *load);

void mgCreateBBoxSphere(float *max, float *min, float *sphere, float (*vertex)[4], int vertex_num) {
    if (vertex == nullptr) {
        min[0] = 0;
        max[0] = 0;
        min[1] = 0;
        max[1] = 0;
        min[2] = 0;
        max[2] = 0;
        sphere[2] = 0;
        sphere[1] = 0;
        sphere[0] = 0;
        sphere[3] = 0;
        return;
    }

    s32    i = {};
    float *point = vertex[0];
    float  center[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    sceVu0CopyVector(max, vertex[0]);
    sceVu0CopyVector(min, vertex[0]);

    for (i = 0; i < vertex_num; i++) {
        mgVectorMaxMin(max, min, max, min, point);
        point += 4;
    }

    sceVu0AddVector(center, max, min);
    sceVu0ScaleVector(sphere, center, 0.5f);
    float radius = 0.0f;
    sphere[3] = 0;
    point = vertex[0];

    for (i = 0; i < vertex_num; i++) {
        float distance = mgDistVector(sphere, point);

        if (distance > radius) {
            radius = distance;
        }

        point += 4;
    }

    sphere[3] = radius;
}

namespace {

/**
 *
 * Copies one frame's contents, name, attributes and bound into another frame, with a copy of its
 * visual when asked; a copied motion model follows the given frame table.
 *
 */
bool CopyFrame(mgCFrame *dst, mgCFrame *src, mgCMemory *memory, int copy_visual, mgCFrame **frame_table);

} // namespace

// Defined inline in mg_dataset.hpp.
int mgCVisual::Iam() {
    return 0;
}

// Defined inline in mg_dataset.hpp.
mgCVisual *mgCVisual::Copy(mgCMemory *memory) {
    return clone_inputs.Matches(this) ? this : nullptr;
}

namespace {

/**
 *
 * Copies a frame and its subtree into new frames allocated from memory, and returns the copy of
 * the frame, or NULL if memory ran out.
 *
 */
mgCFrame *CopyFrameSub(mgCFrame *src, mgCMemory *memory, int copy_visual, mgCFrame **frame_table) {
    mgCFrame *frame = {};

    if (src == nullptr || memory == nullptr) {
        return nullptr;
    }
    frame = dc2::memory::NewObject<mgCFrame>(*memory);

    if (frame == nullptr) {
        return nullptr;
    }

    if (!CopyFrame(frame, src, memory, copy_visual, frame_table)) {
        return nullptr;
    }

    for (mgCFrame *child = src->GetChild(); child != nullptr; child = child->GetBrother()) {
        mgCFrame *copy = CopyFrameSub(child, memory, copy_visual, frame_table);

        if (copy == nullptr) {
            return nullptr;
        }
        copy->SetParent(frame);
    }

    return frame;
}

} // namespace

mgCFrame *mgCopyFrame(mgCFrame *frame, mgCMemory *memory, int copy_visual) {
    mgCFrame **copy_table = {};
    mgCFrame  *copies = {};
    s32        i = {};
    mgCFrame **table = {};
    mgCFrame  *parent = {};
    mgCFrame  *root = {};
    s32        parent_index = {};
    s32        count = {};

    if (frame == nullptr || memory == nullptr) {
        return nullptr;
    }

    count = frame->frame_num;
    table = frame->frame_list;
    if (count < 0) {
        return nullptr;
    }

    if (count > 0 && table != nullptr) {
        const auto table_blocks = dc2::memory::ArrayQuadwords<mgCFrame *>(static_cast<std::size_t>(count));
        const auto frame_blocks = dc2::memory::ArrayQuadwords<mgCFrame>(static_cast<std::size_t>(count));
        if (!table_blocks || !frame_blocks || memory->lock != 0 ||
            static_cast<std::size_t>(*table_blocks) + static_cast<std::size_t>(*frame_blocks) >=
                dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128)) {
            return nullptr;
        }
        copy_table = dc2::memory::NewArray<mgCFrame *>(*memory, static_cast<std::size_t>(count));
        copies = dc2::memory::NewArray<mgCFrame>(*memory, static_cast<std::size_t>(count));
        if (copy_table == nullptr || copies == nullptr) {
            return nullptr;
        }

        for (i = 0; i < count; i++) {
            mgCFrame *copy = &copies[i];
            copy_table[i] = copy;
            if (!CopyFrame(copy, table[i], memory, copy_visual, copy_table)) {
                return nullptr;
            }
        }

        for (i = 0; i < count; i++) {
            parent = table[i]->parent;

            if (parent != nullptr) {
                char *parent_name = parent->name;
                parent_index = frame->SearchFrameID(parent_name);

                if (parent_index >= 0 && parent_index < count) {
                    copies[i].SetParent(copy_table[parent_index]);
                }
            }
        }

        root = copy_table[0];
        root->frame_list = copy_table;
        root->frame_num = count;
        return copy_table[0];
    }

    return CopyFrameSub(frame, memory, copy_visual, nullptr);
}

namespace {

/**
 *
 * Checks a builder write against the actual destination before touching its bytes.
 *
 */
bool BuilderWriteFits(mgCMDTBuilder &builder, const void *destination, std::size_t bytes) {
    if (builder.failed || builder.header == nullptr || destination == nullptr || builder.writable_storage.empty() ||
        builder.memory == nullptr || builder.memory->lock != 0 ||
        dc2::memory::ArenaGeneration(*builder.memory) != builder.memory_generation ||
        builder.memory->stGetTop() != builder.allocation_top) {
        builder.failed = true;
        return false;
    }
    const auto begin = reinterpret_cast<std::uintptr_t>(builder.writable_storage.data());
    const auto address = reinterpret_cast<std::uintptr_t>(destination);
    if (address < begin || address - begin > builder.writable_storage.size() ||
        bytes > builder.writable_storage.size() - static_cast<std::size_t>(address - begin)) {
        builder.failed = true;
        return false;
    }
    return true;
}

} // namespace

void mgCMDTBuilder::Begin(mgCMemory *memory) {
    this->memory = memory;
    header = nullptr;
    writable_storage = {};
    failed = true;
    memory_generation = 0;
    allocation_top = nullptr;
    end = nullptr;
    data = nullptr;
    faces = nullptr;
    prim = nullptr;
    index = nullptr;
    data_type = MG_MDT_DATA_NONE;
    data_num = 0;
    index_num = 0;
    face_index_num = 0;
    material = {};
    if (memory == nullptr || memory->lock != 0) {
        return;
    }
    const auto available = std::as_writable_bytes(dc2::memory::RemainingBytes(*memory));
    if (available.size() <= sizeof(u_long128)) {
        return;
    }
    writable_storage = available.first(available.size() - sizeof(u_long128));
    header = dc2::memory::NewObject<MDT_HEADER>(*memory);
    if (header == nullptr) {
        writable_storage = {};
        return;
    }
    *header = {};
    dc2::text::Copy(header->magic, dc2::text::View("MDT"));
    header->header_size = sizeof(MDT_HEADER);
    end = reinterpret_cast<char *>(header) + sizeof(MDT_HEADER);
    memory_generation = dc2::memory::ArenaGeneration(*memory);
    allocation_top = memory->stGetTop();
    failed = false;
}

MDT_HEADER *mgCMDTBuilder::End() {
    if (memory == nullptr || !BuilderWriteFits(*this, end, 0) || data_type != MG_MDT_DATA_NONE) {
        return nullptr;
    }
    const auto current = reinterpret_cast<std::uintptr_t>(memory->stGetTop());
    const auto finish = reinterpret_cast<std::uintptr_t>(end);
    if (finish > current) {
        const auto bytes = finish - current;
        const auto quadwords = bytes / sizeof(u_long128) + (bytes % sizeof(u_long128) != 0);
        if (quadwords > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
            memory->Alloc(static_cast<int>(quadwords)) == nullptr) {
            failed = true;
            return nullptr;
        }
    }
    allocation_top = memory->stGetTop();
    return header;
}

void mgCMDTBuilder::End(mgCFrame *frame, mgCVisualMDT *visual, mgLoadData *load) {
    mgCTextureManager *textures = {};
    MDT_HEADER        *block = {};
    float              box_max[4];
    float              box_min[4];
    float              sphere[4];
    block = End();

    if (frame == nullptr || block == nullptr || visual == nullptr || load == nullptr || load->memory == nullptr) {
        return;
    }

    textures = load->texture_manager;

    if (textures == nullptr) {
        textures = &mgTexManager;
    }

    MDT_HEADER *mdt = block;
    float (*points)[4] = (float (*)[4])((u8 *) block + mdt->vertex_ofs);
    mgCreateBBoxSphere(box_max, box_min, sphere, points, (u_int) mdt->vertex_num);
    visual->Initialize();
    const auto source_bytes = static_cast<std::size_t>(end - reinterpret_cast<char *>(block));
    if (visual->DataAssignMDT(std::span<std::byte>{reinterpret_cast<std::byte *>(block), source_bytes},
                              load->memory, textures) == 0) {
        return;
    }
    auto *bound = dc2::memory::NewObject<mgCFrame::BoundInfo>(*load->memory);
    auto *attr = dc2::memory::NewObject<mgCFrameAttr>(*load->memory);
    if (bound == nullptr || attr == nullptr) {
        return;
    }
    frame->bound = bound;
    frame->SetVisual(visual);
    frame->SetBBox(box_max, box_min);
    frame->SetBSphere(sphere, sphere[3]);
    frame->attr = attr;
}

void mgCMDTBuilder::BeginData(int type) {
    if (BuilderWriteFits(*this, end, 0) && data_type == MG_MDT_DATA_NONE) {
        data = end;
        data_num = 0;
        data_type = type;
    }
}

void mgCMDTBuilder::SetData(float *vector) {
    switch (data_type) {
        case 1:
        case 2:
        case 3:
        case 4:
            if (vector == nullptr || data_num == std::numeric_limits<int>::max() ||
                !BuilderWriteFits(*this, data, sizeof(u_long128))) {
                failed = true;
                return;
            }
            std::memcpy(data, vector, sizeof(u_long128));
            data += sizeof(u_long128);
            data_num++;
            return;
        case 5:
            return;
    }
}

void mgCMDTBuilder::SetData(float x, float y, float z, float w) {
    float vector[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    vector[0] = x;
    vector[1] = y;
    vector[2] = z;
    vector[3] = w;

    if (data_type == MG_MDT_DATA_NORMAL) {
        vector[3] = 0.0f;
    }

    SetData(vector);
}

void mgCMDTBuilder::SetMaterial(const float *colour, const char *texture) {
    if (data_type == MG_MDT_DATA_MATERIAL) {
        if (colour == nullptr || texture == nullptr || data_num == std::numeric_limits<int>::max() ||
            !BuilderWriteFits(*this, data, sizeof(MDT_MATERIAL_))) {
            failed = true;
            return;
        }
        std::memmove(material.diffuse, colour, sizeof(material.diffuse));
        dc2::text::Copy(std::span(material.texture), dc2::text::View(texture));
        std::memcpy(data, &material, sizeof(material));
        data += sizeof(material);
        data_num++;
    }
}

void mgCMDTBuilder::EndData() {
    if (!BuilderWriteFits(*this, data, 0)) {
        return;
    }
    switch (data_type) {
        case MG_MDT_DATA_VERTEX:
            header->vertex_ofs = end - (char *) header;
            header->vertex_num = data_num;
            break;
        case MG_MDT_DATA_COLOUR:
            header->colour_ofs = end - (char *) header;
            header->colour_num = data_num;
            break;
        case MG_MDT_DATA_NORMAL:
            header->normal_ofs = end - (char *) header;
            header->normal_num = data_num;
            break;
        case MG_MDT_DATA_UV:
            header->uv_ofs = end - (char *) header;
            header->uv_num = data_num;
            break;
        case MG_MDT_DATA_MATERIAL:
            header->material_ofs = end - (char *) header;
            header->material_num = data_num;
            break;
    }

    end = data;
    data_type = MG_MDT_DATA_NONE;
}

void mgCMDTBuilder::BeginFaces() {
    if (!BuilderWriteFits(*this, end, sizeof(MDT_FACES))) {
        return;
    }
    header->faces_ofs = end - (char *) header;
    faces = (MDT_FACES *) end;
    memset(faces, 0, sizeof(MDT_FACES));
    faces->header_size = sizeof(MDT_FACES);
    end += sizeof(MDT_FACES);
    index = (int *) end;
}

void mgCMDTBuilder::EndFaces() {
    if (!BuilderWriteFits(*this, faces, sizeof(MDT_FACES)) || !BuilderWriteFits(*this, index, 0)) {
        return;
    }
    const auto bytes = reinterpret_cast<char *>(index) - reinterpret_cast<char *>(faces);
    if (bytes < 0 || static_cast<std::size_t>(bytes) > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
        failed = true;
        return;
    }
    const auto begin = reinterpret_cast<std::uintptr_t>(writable_storage.data());
    const auto offset = reinterpret_cast<std::uintptr_t>(index) - begin;
    const auto padding = (sizeof(u_long128) - offset % sizeof(u_long128)) % sizeof(u_long128);
    if (!BuilderWriteFits(*this, index, padding)) {
        return;
    }
    header->faces_size = static_cast<int>(bytes);
    end = reinterpret_cast<char *>(index) + padding;
}

void mgCMDTBuilder::BeginPrim(int type, int material) {
    if (!BuilderWriteFits(*this, faces, sizeof(MDT_FACES)) ||
        !BuilderWriteFits(*this, index, offsetof(FACES_ID, index))) {
        return;
    }
    prim = (FACES_ID *) index;
    index += 2;
    prim->type = type;
    prim->vertex_num = 0;

    face_index_num = 3;

    if (type & MG_FACE_NO_TEXTURE) {
        face_index_num--;
    }

    if (type & MG_FACE_COLOUR) {
        face_index_num++;
    }

    if (type & MG_FACE_NO_NORMAL) {
        face_index_num--;
    }

    index_num = 0;
    *index++ = material;
}

void mgCMDTBuilder::AddFace(int vertex) {
    if (index_num == std::numeric_limits<int>::max() || !BuilderWriteFits(*this, index, sizeof(int))) {
        failed = true;
        return;
    }
    *index++ = vertex;
    ++index_num;
}

void mgCMDTBuilder::EndPrim() {
    if (!BuilderWriteFits(*this, prim, offsetof(FACES_ID, index)) ||
        !BuilderWriteFits(*this, faces, sizeof(MDT_FACES)) || face_index_num <= 0 ||
        index_num % face_index_num != 0 || faces->prim_num == std::numeric_limits<int>::max()) {
        failed = true;
        return;
    }
    prim->vertex_num = index_num / face_index_num;
    faces->prim_num++;
}

// Defined inline in mg_visual.hpp.

int mgCVisualMDT::Iam() {
    return MG_VISUAL_KIND_MDT;
}

// Defined inline in mg_visual.hpp.
int mgCVisualMDT::GetMaterialNum() {
    return material_num;
}

// Defined inline in mg_visual.hpp.
mgMaterial *mgCVisualMDT::GetpMaterial() {
    return material;
}

// Defined inline in mg_visual.hpp.
void mgCVisualMDT::Draw(float (*matrix)[4], mgCDrawManager *draw_manager) {
    Draw(nullptr, matrix, draw_manager);
}

// Defined inline in mg_dataset.hpp.
int mgCVisual::CreatePacket(mgCMemory *memory, mgCMemory *scratch) {
    return 0;
}

// Defined inline in mg_dataset.hpp.
int mgCVisual::GetMaterialNum() {
    return 0;
}

// Defined inline in mg_dataset.hpp.
mgMaterial *mgCVisual::GetpMaterial() {
    return nullptr;
}

// Defined inline in mg_dataset.hpp.
mgMaterial *mgCVisual::GetMaterial(int index) {
    return nullptr;
}

// Defined inline in mg_dataset.hpp.
int mgCVisual::CreateBBox(float *box_min, float *box_max, float (*matrix)[4]) {
    return 0;
}

// Defined inline in mg_dataset.hpp.
int mgCVisual::CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info) {
    return 0;
}

// Defined inline in mg_dataset.hpp.
int mgCVisual::Draw(u_int *packet, float (*matrix)[4], mgCDrawManager *manager) {
    return 0;
}

// Defined inline in mg_dataset.hpp.
void mgCVisual::Draw(float (*matrix)[4], mgCDrawManager *manager) {
    Draw(nullptr, matrix, manager);
}

namespace {

bool CopyFrameBase(mgCFrame *dst, mgCFrame *src, mgCMemory *memory, int copy_visual, mgCFrame **frame_table) {
    if (dst == nullptr || src == nullptr || memory == nullptr || !src->clone_inputs.Matches(*src)) {
        return false;
    }
    const std::string_view source_name = src->name != nullptr ? dc2::text::View(src->name) : std::string_view{};
    char                  *name = dc2::memory::NewArray<char>(*memory, source_name.size() + 1);
    if (name == nullptr) {
        return false;
    }
    if (!source_name.empty()) {
        std::memcpy(name, source_name.data(), source_name.size());
    }
    name[source_name.size()] = '\0';

    mgCFrameAttr *attr = nullptr;
    if (src->attr != nullptr) {
        attr = dc2::memory::NewObject<mgCFrameAttr>(*memory);
        if (attr == nullptr) {
            return false;
        }
        *attr = *src->attr;
    }
    mgCFrame::BoundInfo *bound = nullptr;
    if (src->bound != nullptr) {
        bound = dc2::memory::NewObject<mgCFrame::BoundInfo>(*memory);
        if (bound == nullptr) {
            return false;
        }
        *bound = *src->bound;
    }
    mgCVisual *visual = src->visual;
    if (copy_visual != 0 && visual != nullptr) {
        const auto source_visual_inputs = visual->clone_inputs;
        visual = source_visual_inputs.Clone(visual, memory);
        if (visual == nullptr) {
            return false;
        }
        if (!visual->clone_inputs.Matches(visual)) {
            return false;
        }
        if (visual->clone_inputs.Kind(visual) == dc2::render::VisualCloneKind::MotionMdt) {
            static_cast<mgCVisualMotionMDT *>(visual)->frame = frame_table;
        }
    }
    *dst = *src;
    dst->SetName(name);
    dst->attr = attr;
    dst->bound = bound;
    dst->SetVisual(visual);
    return dc2::render::FrameCloneInputs::Publish(*memory, *dst, visual != nullptr ? visual->clone_inputs : dc2::render::VisualCloneInputs{});
}

} // namespace

mgCFrame *mgLoadMDSFile(MDS_HEADER *mds, mgCMemory *memory,
                        mgCreateVisualType *visual_type, mgCTextureManager *texture_manager) {
    mgLoadData load{};
    load.mds = mds;
    load.memory = memory;
    load.visual_type = visual_type;
    load.texture_manager = texture_manager;
    return mgLoadMDSFile(&load);
}

mgCFrame *mgLoadMDSFile(mgLoadData *load) {
    if (!load || !load->mds || !load->memory) {
        return nullptr;
    }
    std::string error;
    const auto  path = DataReadBufferPath(load->mds);
    if (!path) {
        CT_LOG_ERROR(Data, "model: direct glTF path required; in-memory loaders must supply gameplay JSON");
        return nullptr;
    }
    auto *frame = model_assets::LoadModel(std::filesystem::path(*path), *load, error);
    if (!frame) {
        CT_LOG_ERROR(Data, "model: {}", error);
    }
    return frame;
}

namespace {

bool CopyFrame(mgCFrame *dst, mgCFrame *src, mgCMemory *memory, int copy_visual, mgCFrame **frame_table) {
    if (!CopyFrameBase(dst, src, memory, copy_visual, frame_table)) {
        return false;
    }
    model_assets::CopyFrameConvention(*dst, *src);
    // An active monster's copy reuses its slot's storage, so the tree may sit where the previous monster's did.
    character_motion::ForgetPose(dst);
    return true;
}

} // namespace
