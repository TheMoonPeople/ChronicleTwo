#include "common.h"

#include <algorithm>
#include <array>
#include <climits>
#include <cstdint>
#include <cstring>
#include <deque>
#include <limits>
#include <memory>
#include <optional>
#include <span>
#include <unordered_map>
#include <vector>

#include "log/log.hpp"
#include "mg_dataset.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_shadow.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "profile.hpp"
#include "render/primitive_submission.hpp"
#include "render/renderer.hpp"
#include "render/visual_mesh.hpp"
#include "visualmotion.hpp"
#include "water.hpp"

std::optional<std::size_t> dc2::render::FaceRecordBytes(std::span<const std::byte> remaining, bool shadow) {
    constexpr std::size_t header_bytes = offsetof(FACES_ID, index);
    if (remaining.size() < header_bytes ||
        reinterpret_cast<std::uintptr_t>(remaining.data()) % alignof(FACES_ID) != 0) {
        return std::nullopt;
    }
    std::array<u_int, 3> fields{};
    std::memcpy(fields.data(), remaining.data(), header_bytes);
    const auto [type, vertex_count, material] = fields;
    const int stride = shadow ? 3 : 3 + ((type & MG_FACE_COLOUR) != 0) - ((type & MG_FACE_NO_NORMAL) != 0) - ((type & MG_FACE_NO_TEXTURE) != 0);
    if (stride <= 0 || vertex_count == 0 ||
        (shadow ? vertex_count > static_cast<unsigned>(SHRT_MAX) || vertex_count % 3 != 0
                : vertex_count > static_cast<unsigned>(SHRT_MAX / stride)) ||
        (material > static_cast<unsigned>(SHRT_MAX) && material != UINT_MAX)) {
        return std::nullopt;
    }
    const std::size_t index_count = static_cast<std::size_t>(vertex_count) * static_cast<std::size_t>(stride);
    if (index_count > (remaining.size() - header_bytes) / sizeof(int)) {
        return std::nullopt;
    }
    return header_bytes + index_count * sizeof(int);
}

bool dc2::render::FaceAllocationFits(mgCMemory &face_memory, mgCMemory &index_memory,
                                     std::size_t index_count) {
    const auto            index_quads = dc2::memory::ArrayQuadwords<int>(index_count);
    constexpr std::size_t object_quads = (sizeof(mgCFace) + sizeof(u_long128) - 1) / sizeof(u_long128) +
                                         (sizeof(mgFACE_GROUP) + sizeof(u_long128) - 1) / sizeof(u_long128);
    if (!index_quads || face_memory.lock != 0 || index_memory.lock != 0) {
        return false;
    }
    const auto index_blocks = static_cast<std::size_t>(*index_quads);
    const auto face_available = dc2::memory::RemainingBytes(face_memory).size() / sizeof(u_long128);
    if (&face_memory == &index_memory) {
        return object_quads + index_blocks < face_available;
    }
    return object_quads < face_available &&
           index_blocks < dc2::memory::RemainingBytes(index_memory).size() / sizeof(u_long128);
}

std::optional<std::span<const std::byte>> dc2::render::ValidateMdtFaceSection(std::span<const std::byte> model,
                                                                              bool                       shadow) {
    if (model.size() < sizeof(MDT_HEADER) ||
        reinterpret_cast<std::uintptr_t>(model.data()) % alignof(MDT_HEADER) != 0) {
        return std::nullopt;
    }
    const auto *header = reinterpret_cast<const MDT_HEADER *>(model.data());
    const auto  valid_section = [&model](int offset, int count, std::size_t stride, std::size_t alignment) {
        if (offset < 0 || count < 0) {
            return false;
        }
        const auto start = static_cast<std::size_t>(offset);
        return start <= model.size() && static_cast<std::size_t>(count) <= (model.size() - start) / stride &&
               (count == 0 || reinterpret_cast<std::uintptr_t>(model.data() + start) % alignment == 0);
    };
    if (std::memcmp(header->magic, "MDT", 3) != 0 || header->header_size != sizeof(MDT_HEADER) ||
        !valid_section(header->vertex_ofs, header->vertex_num, sizeof(sceVu0FVECTOR), alignof(sceVu0FVECTOR)) ||
        (!shadow && !valid_section(header->normal_ofs, header->normal_num, sizeof(sceVu0FVECTOR), alignof(sceVu0FVECTOR))) ||
        !valid_section(header->colour_ofs, header->colour_num, sizeof(sceVu0FVECTOR), alignof(sceVu0FVECTOR)) ||
        (!shadow && !valid_section(header->uv_ofs, header->uv_num, sizeof(sceVu0FVECTOR), alignof(sceVu0FVECTOR))) ||
        !valid_section(header->material_ofs, header->material_num, sizeof(MDT_MATERIAL_), alignof(MDT_MATERIAL_)) ||
        header->material_num > INT_MAX / static_cast<int>(sizeof(mgMaterial)) ||
        !valid_section(header->faces_ofs, header->faces_size, 1, alignof(MDT_FACES)) ||
        header->faces_size < static_cast<int>(sizeof(MDT_FACES))) {
        return std::nullopt;
    }
    const auto *materials = reinterpret_cast<const MDT_MATERIAL_ *>(model.data() + header->material_ofs);
    for (int index = 0; index < header->material_num; ++index) {
        if (std::memchr(materials[index].texture, '\0', sizeof materials[index].texture) == nullptr) {
            return std::nullopt;
        }
    }
    auto section = model.subspan(static_cast<std::size_t>(header->faces_ofs),
                                 static_cast<std::size_t>(header->faces_size));
    if (reinterpret_cast<std::uintptr_t>(section.data()) % alignof(MDT_FACES) != 0) {
        return std::nullopt;
    }
    const auto *faces = reinterpret_cast<const MDT_FACES *>(section.data());
    if (faces->header_size != sizeof(MDT_FACES) || faces->prim_num < 0 ||
        static_cast<std::size_t>(faces->prim_num) >
            (section.size() - sizeof(MDT_FACES)) / offsetof(FACES_ID, index)) {
        return std::nullopt;
    }
    auto remaining = section.subspan(sizeof(MDT_FACES));
    for (int index = 0; index < faces->prim_num; ++index) {
        const auto bytes = FaceRecordBytes(remaining, shadow);
        if (!bytes) {
            return std::nullopt;
        }
        std::array<u_int, 3> fields{};
        std::memcpy(fields.data(), remaining.data(), offsetof(FACES_ID, index));
        const auto [type, vertex_count, material] = fields;
        if (material >= static_cast<u_int>(header->material_num)) {
            return std::nullopt;
        }
        const std::size_t stride = shadow ? 3 : 3 + ((type & MG_FACE_COLOUR) != 0) - ((type & MG_FACE_NO_NORMAL) != 0) - ((type & MG_FACE_NO_TEXTURE) != 0);
        const auto        valid_index = [&](std::size_t slot, int count) {
            int value;
            std::memcpy(&value, remaining.data() + offsetof(FACES_ID, index) + slot * sizeof(value),
                        sizeof(value));
            return value >= 0 && value < count;
        };
        for (std::size_t vertex = 0; vertex < vertex_count; ++vertex) {
            const std::size_t base = vertex * stride;
            if (!valid_index(base, header->vertex_num)) {
                return std::nullopt;
            }
            if (shadow) {
                continue;
            }
            std::size_t next = base + 1;
            if ((type & MG_FACE_NO_NORMAL) == 0 && !valid_index(next++, header->normal_num)) {
                return std::nullopt;
            }
            if ((type & MG_FACE_NO_TEXTURE) == 0 && !valid_index(next++, header->uv_num)) {
                return std::nullopt;
            }
            if ((type & MG_FACE_COLOUR) != 0 && !valid_index(next, header->colour_num)) {
                return std::nullopt;
            }
        }
        remaining = remaining.subspan(*bytes);
    }
    return section;
}

std::optional<std::size_t> dc2::render::RequiredMdtQuadwords(
    const MDT_HEADER &header, std::span<const std::byte> face_section, MdtStorage storage) {
    static_assert(sizeof(mgMaterial) % sizeof(u_long128) == 0);
    static_assert(sizeof(mgCFace) <= 5 * sizeof(u_long128));
    static_assert(sizeof(mgFACE_GROUP) <= 4 * sizeof(u_long128));
    if (header.material_num < 0 || header.vertex_num < 0 || header.normal_num < 0 ||
        header.colour_num < 0 || header.uv_num < 0 || face_section.size() < sizeof(MDT_FACES)) {
        return std::nullopt;
    }
    const auto *faces = reinterpret_cast<const MDT_FACES *>(face_section.data());
    if (faces->prim_num < 0) {
        return std::nullopt;
    }
    std::size_t required = 0;
    const auto  add = [&required](std::size_t quadwords) {
        if (quadwords > std::numeric_limits<std::size_t>::max() - required) {
            return false;
        }
        required += quadwords;
        return true;
    };
    const std::size_t material_quads = static_cast<std::size_t>(header.material_num) *
                                       (sizeof(mgMaterial) / sizeof(u_long128));
    if (!add(material_quads) ||
        (storage != MdtStorage::Borrowed &&
         (!add(static_cast<std::size_t>(header.vertex_num)) ||
          !add(static_cast<std::size_t>(header.colour_num)) ||
          (storage == MdtStorage::Owned &&
           (!add(static_cast<std::size_t>(header.normal_num)) ||
            !add(static_cast<std::size_t>(header.uv_num))))))) {
        return std::nullopt;
    }
    if (storage == MdtStorage::Shadow && faces->prim_num > 0 && !add(0x12)) {
        return std::nullopt;
    }
    auto remaining = face_section.subspan(sizeof(MDT_FACES));
    for (int index = 0; index < faces->prim_num; ++index) {
        const auto bytes = FaceRecordBytes(remaining, storage == MdtStorage::Shadow);
        if (!bytes) {
            return std::nullopt;
        }
        const std::size_t index_count = (*bytes - offsetof(FACES_ID, index)) / sizeof(int);
        std::size_t       face_quads;
        if (storage == MdtStorage::Shadow) {
            u_int vertex_count;
            std::memcpy(&vertex_count, remaining.data() + offsetof(FACES_ID, vertex_num), sizeof(vertex_count));
            face_quads = 5 + static_cast<std::size_t>(vertex_count) / 4 + 0x10;
        } else {
            face_quads = (sizeof(mgCFace) + sizeof(u_long128) - 1) / sizeof(u_long128) +
                         index_count / 4 + 1 + 4;
        }
        if (!add(face_quads)) {
            return std::nullopt;
        }
        remaining = remaining.subspan(*bytes);
    }
    return required;
}

void mgCVisualAttr::Initialize() {
    memset(this, 0, sizeof(*this));
    alpha_ref = -1;
    z_write = 1;
    dest_alpha_test = -1;
}

mgCVisualAttr::mgCVisualAttr() {
    Initialize();
}

mgCTextureManager *mgCVisual::GetTextureManager() {
    mgCTextureManager *manager = texture_manager;

    if (manager != nullptr) {
        return manager;
    }

    return &mgTexManager;
}

int mgCVisual::SetDrawEnvGifTag(u_long128 *env_packet, mgRENDER_INFO *info, mgCDrawEnv *base) {
    mgCDrawEnv *env = (mgCDrawEnv *) env_packet;
    *env = *base;

    if (info->attr->alpha_ref >= 0) {
        env->test.bits.aref = info->attr->alpha_ref;
    }

    if (info->attr->z_test != 0) {
        env->test.bits.zte = 1;

        if (info->attr->z_test == -1) {
            env->test.bits.ztst = 1;
        }

        if (info->attr->z_test == 1) {
            env->test.bits.ztst = 2;
        }

        if (info->attr->z_test == 2) {
            env->test.bits.ztst = 3;
        }
    }

    if (info->attr->alpha_test > 0) {
        env->test.bits.ate = 1;
        env->test.bits.atst = info->attr->alpha_test;
    } else if (info->attr->alpha_test == -1) {
        env->test.bits.ate = 0;
    }

    if (info->attr->dest_alpha_test != 0) {
        if (info->attr->dest_alpha_test == -1) {
            env->test.bits.date = 0;
        } else if (info->attr->dest_alpha_test == 1) {
            env->test.bits.date = 1;
            env->test.bits.datm = 0;
        } else if (info->attr->dest_alpha_test == 2) {
            u_char on = 1;
            env->test.bits.date = on;
            env->test.bits.datm = on;
        }
    }

    if (info->attr->alpha_blend != 0) {
        env->SetAlpha(info->attr->alpha_blend);
    }

    env->SetZBuf(info->attr->z_write);
    return 4;
}

void mgCVisualMDT::Initialize() {
    vertex_num = 0;
    vertex = nullptr;
    normal_num = 0;
    normal = nullptr;
    colour_num = 0;
    colour = nullptr;
    uv_num = 0;
    uv = nullptr;
    material_num = 0;
    material = nullptr;
    face_group = nullptr;
    mgCVisual::Initialize();
    vu1_base = 60;
    vu1_offset = 180;
}

namespace {
/**
 * Copies material colours and resolves its texture in the active manager.
 */
void CopyMaterial(mgMaterial *dst, MDT_MATERIAL_ *src, mgCTextureManager *textures) {
    std::copy_n(src->diffuse, 4, dst->diffuse);
    std::copy_n(src->unk_10, 4, dst->unk_10);
    dst->texture = textures->GetTexture(src->texture, -1);
}
} // namespace

void mgCVisualMDT::CopyMDTData(MDT_HEADER *header, mgCMemory *memory) {
    int                index = {};
    mgCTextureManager *textures = {};
    sceVu0FVECTOR     *source_vertex = {};
    sceVu0FVECTOR     *source_normal = {};
    sceVu0FVECTOR     *source_colour = {};
    sceVu0FVECTOR     *source_uv = {};
    MDT_MATERIAL_     *source_material = {};

    textures = GetTextureManager();
    source_vertex = (sceVu0FVECTOR *) ((u_char *) header + header->vertex_ofs);
    source_normal = (sceVu0FVECTOR *) ((u_char *) header + header->normal_ofs);
    source_colour = (sceVu0FVECTOR *) ((u_char *) header + header->colour_ofs);
    source_uv = (sceVu0FVECTOR *) ((u_char *) header + header->uv_ofs);
    source_material = (MDT_MATERIAL_ *) ((u_char *) header + header->material_ofs);
    vertex_num = header->vertex_num;
    normal_num = header->normal_num;
    colour_num = header->colour_num;
    uv_num = header->uv_num;
    material_num = header->material_num;
    vertex = vertex_num > 0 ? dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(vertex_num)) : nullptr;
    normal = normal_num > 0 ? dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(normal_num)) : nullptr;
    uv = uv_num > 0 ? dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(uv_num)) : nullptr;
    colour = colour_num > 0 ? dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(colour_num)) : nullptr;
    material = material_num > 0 ? dc2::memory::NewArray<mgMaterial>(*memory, static_cast<std::size_t>(material_num)) : nullptr;

    if (vertex != nullptr) {
        for (index = 0; index < vertex_num; index++) {
            sceVu0CopyVector(vertex[index], source_vertex[index]);
        }
    }

    if (normal != nullptr) {
        for (index = 0; index < normal_num; index++) {
            sceVu0CopyVector(normal[index], source_normal[index]);
        }
    }

    if (colour != nullptr) {
        for (index = 0; index < colour_num; index++) {
            sceVu0CopyVector(colour[index], source_colour[index]);
        }
    }

    if (uv != nullptr) {
        for (index = 0; index < uv_num; index++) {
            sceVu0CopyVector(uv[index], source_uv[index]);
        }
    }

    if (material != nullptr) {
        for (index = 0; index < material_num; index++) {
            CopyMaterial(&material[index], &source_material[index], textures);
        }
    }
}

void mgCVisualMDT::CopyMDTDataPointer(MDT_HEADER *header, mgCMemory *memory) {
    mgCTextureManager *textures = GetTextureManager();
    uptr               vertex_address = (uptr) header + header->vertex_ofs;
    uptr               normal_address = (uptr) header + header->normal_ofs;
    uptr               colour_address = (uptr) header + header->colour_ofs;
    uptr               uv_address = (uptr) header + header->uv_ofs;
    MDT_MATERIAL_     *file_materials = (MDT_MATERIAL_ *) ((u_char *) header + header->material_ofs);
    vertex_num = header->vertex_num;
    normal_num = header->normal_num;
    colour_num = header->colour_num;
    uv_num = header->uv_num;
    material_num = header->material_num;
    vertex = (sceVu0FVECTOR *) vertex_address;
    normal = (sceVu0FVECTOR *) normal_address;
    colour = (sceVu0FVECTOR *) colour_address;
    uv = (sceVu0FVECTOR *) uv_address;
    material = material_num > 0 ? dc2::memory::NewArray<mgMaterial>(*memory, static_cast<std::size_t>(material_num)) : nullptr;

    if (material != nullptr) {
        for (int i = 0; i < material_num; i++) {
            CopyMaterial(&material[i], &file_materials[i], textures);
        }
    }
}

mgMaterial *mgCVisualMDT::GetMaterial(int index) {
    if (material == nullptr) {
        return nullptr;
    }

    if (index < 0 || index >= material_num) {
        return nullptr;
    }

    return material + index;
}

sceVu0FVECTOR *mgCVisualMDT::GetColor(int *out) {
    *out = colour_num;
    return colour;
}

int mgCVisualMDT::CreateBBox(float *min, float *max, float (*matrix)[4]) {
    if (vertex_num <= 0) {
        return 0;
    }

    if (vertex == nullptr) {
        return 0;
    }

    mgVectorMinMaxN(min, max, vertex, vertex_num);
    return 1;
}

const FACES_ID *mgCVisualMDT::CreateFace(const FACES_ID *faces, std::span<const std::byte> remaining,
                                         mgCMemory *memory, mgCMemory *index_memory, mgCFace **out_face) {
    const auto record_bytes = dc2::render::FaceRecordBytes(remaining, false);
    if (!record_bytes || remaining.data() != reinterpret_cast<const std::byte *>(faces) ||
        memory == nullptr || index_memory == nullptr) {
        return nullptr;
    }
    const auto index_count = (*record_bytes - offsetof(FACES_ID, index)) / sizeof(int);
    if (!dc2::render::FaceAllocationFits(*memory, *index_memory, index_count)) {
        return nullptr;
    }
    mgCFace      *face = {};
    mgCFace      *last_face = {};
    mgFACE_GROUP *group = {};
    mgFACE_GROUP *previous = {};
    int          *write = {};
    int           i = {};

    GetTextureManager();
    face = dc2::memory::NewObject<mgCFace>(*memory);
    if (face == nullptr) {
        return nullptr;
    }
    face->vertex_num = faces->vertex_num;
    face->type = faces->type;
    face->index_stride = 3;

    if (face->type & MG_FACE_COLOUR) {
        face->index_stride++;
    }

    if (face->type & MG_FACE_NO_NORMAL) {
        face->index_stride--;
    }

    if (face->type & MG_FACE_NO_TEXTURE) {
        face->index_stride--;
    }

    face->index_num = face->vertex_num * face->index_stride;
    face->material = faces->material;
    const int *source_indices = faces->index;
    write = dc2::memory::NewArray<int>(*index_memory, static_cast<std::size_t>(face->index_num));
    if (write == nullptr) {
        return nullptr;
    }
    face->index = write;

    for (i = 0; i < face->index_num; i++) {
        *write++ = source_indices[i];
    }

    face->next = nullptr;
    previous = face_group;

    if (previous == nullptr) {
        group = dc2::memory::NewObject<mgFACE_GROUP>(*memory);
        if (group == nullptr) {
            return nullptr;
        }
        *group = {};

        group->next = nullptr;
        group->face = nullptr;
        group->material = face->material;
        face_group = group;
    } else {
        while (previous->next != nullptr) {
            if (previous->material == face->material && previous->vu_program == 0) {
                break;
            }

            previous = previous->next;
        }

        if (previous->next == nullptr) {
            group = dc2::memory::NewObject<mgFACE_GROUP>(*memory);
            if (group == nullptr) {
                return nullptr;
            }
            *group = {};

            previous->next = group;
            group->next = nullptr;
            group->face = nullptr;
            group->material = face->material;
            group->vu_program = 0;
        } else {
            group = previous;
        }
    }

    last_face = group->face;

    if (last_face == nullptr) {
        group->face = face;
    } else {
        for (; last_face->next != nullptr; last_face = last_face->next) {
        }

        last_face->next = face;
    }

    if (out_face != nullptr) {
        *out_face = face;
    }

    return reinterpret_cast<const FACES_ID *>(remaining.data() + *record_bytes);
}

int mgCVisualMDT::DataAssignMDT(std::span<std::byte> model, mgCMemory *memory,
                                mgCTextureManager *textures) {
    const auto    face_section = dc2::render::ValidateMdtFaceSection(model, false);
    mgCVisualMDT *self = this;

    if (!face_section || memory == nullptr) {
        return 0;
    }
    auto      *header = reinterpret_cast<MDT_HEADER *>(model.data());
    const auto needed = dc2::render::RequiredMdtQuadwords(*header, *face_section,
                                                          dc2::render::MdtStorage::Owned);
    if (!needed || memory->lock != 0 ||
        *needed >= dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128)) {
        return 0;
    }

    if (textures == nullptr) {
        textures = &mgTexManager;
    }

    self->texture_manager = textures;
    CopyMDTData(header, memory);
    face_group = nullptr;
    const auto *faces = reinterpret_cast<const MDT_FACES *>(face_section->data());
    auto        remaining = face_section->subspan(sizeof(MDT_FACES));
    int         count = faces->prim_num;

    for (int i = 0; i < count; i++) {
        const auto *cursor = reinterpret_cast<const FACES_ID *>(remaining.data());
        const auto *next = self->CreateFace(cursor, remaining, memory, memory, nullptr);
        if (next == nullptr) {
            return 0;
        }
        remaining = remaining.subspan(reinterpret_cast<const std::byte *>(next) - remaining.data());
    }

    return 1;
}

int mgCVisualFixMDT::DataAssignMDT(std::span<std::byte> model, mgCMemory *memory,
                                   mgCTextureManager *textures) {
    const auto face_section = dc2::render::ValidateMdtFaceSection(model, false);
    if (!face_section || memory == nullptr) {
        return 0;
    }
    auto      *header = reinterpret_cast<MDT_HEADER *>(model.data());
    const auto needed = dc2::render::RequiredMdtQuadwords(*header, *face_section,
                                                          dc2::render::MdtStorage::Borrowed);
    if (!needed || memory->lock != 0 ||
        *needed >= dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128)) {
        return 0;
    }
    mgCVisualMDT *self = this;
    mgCFace      *part = {};

    if (textures == nullptr) {
        textures = &mgTexManager;
    }

    self->texture_manager = textures;
    CopyMDTDataPointer(header, memory);
    face_group = nullptr;
    const auto *faces = reinterpret_cast<const MDT_FACES *>(face_section->data());
    int         count = faces->prim_num;
    auto        remaining = face_section->subspan(sizeof(MDT_FACES));

    for (int i = 0; i < count; i++) {
        const auto *cursor = reinterpret_cast<const FACES_ID *>(remaining.data());
        const auto *next = self->CreateFace(cursor, remaining, memory, memory, &part);
        if (next == nullptr) {
            return 0;
        }
        remaining = remaining.subspan(reinterpret_cast<const std::byte *>(next) - remaining.data());
        self->CreateFacePacket(nullptr, part);
    }

    return 1;
}

int mgCVisualMDT::CreateExtRenderInfoPacket(u_int         *packet, float (*matrix)[4],
                                            mgRENDER_INFO *info) {
    return 0;
}

mgCVisual *mgCVisualFixMDT::Copy(mgCMemory *memory) {
    if (!clone_inputs.Matches(this)) {
        return nullptr;
    }
    if (memory == nullptr || memory->lock != 0 || material_num < 0 ||
        (material_num > 0 && material == nullptr)) {
        return nullptr;
    }
    const auto object_quads = dc2::memory::ArrayQuadwords<mgCVisualFixMDT>(1);
    const auto material_quads = material_num > 0
                                    ? dc2::memory::ArrayQuadwords<mgMaterial>(static_cast<std::size_t>(material_num))
                                    : std::optional<int>(0);
    if (!object_quads || !material_quads ||
        static_cast<std::size_t>(*object_quads) + static_cast<std::size_t>(*material_quads) >=
            dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128)) {
        return nullptr;
    }

    auto *copy = dc2::memory::NewObject<mgCVisualFixMDT>(*memory);
    if (copy == nullptr) {
        return nullptr;
    }
    *copy = *this;
    if (material_num > 0) {
        copy->material = dc2::memory::NewArray<mgMaterial>(*memory, static_cast<std::size_t>(material_num));
        if (copy->material == nullptr) {
            return nullptr;
        }
    }
    for (int index = 0; index < material_num; index++) {
        copy->material[index] = material[index];
    }

    if (!dc2::render::VisualCloneInputs::Publish(*memory, *copy, dc2::render::VisualCloneKind::FixMdt)) {
        return nullptr;
    }
    return copy;
}

void SetDrawEnv(mgCDrawEnv *env, mgCVisualAttr *attr, mgCDrawEnv *base) {
    *env = *base;

    if (attr->alpha_ref >= 0) {
        env->test.bits.aref = attr->alpha_ref;
    }

    env->test.bits.zte = 1;

    if (attr->z_test != 0) {
        if (attr->z_test == -1) {
            env->test.bits.ztst = 1;
        }

        if (attr->z_test == 1) {
            env->test.bits.ztst = 2;
        }

        if (attr->z_test == 2) {
            env->test.bits.ztst = 3;
        }
    }

    if (attr->alpha_test != 0) {
        if (attr->alpha_test == -1) {
            env->test.bits.ate = 0;
        } else {
            env->test.bits.ate = 1;
        }

        env->test.bits.atst = attr->alpha_test;
    }

    if (attr->dest_alpha_test != 0) {
        if (attr->dest_alpha_test == -1) {
            env->test.bits.date = 0;
        } else if (attr->dest_alpha_test == 1) {
            env->test.bits.date = 1;
            env->test.bits.datm = 0;
        } else if (attr->dest_alpha_test == 2) {
            u_char on = 1;
            env->test.bits.date = on;
            env->test.bits.datm = on;
        }
    }

    if (attr->z_write > 0) {
        env->zbuf.bits.zmsk = 0;
    }

    if (attr->z_write < 0) {
        env->zbuf.bits.zmsk = 1;
    }

    if (attr->alpha_blend != 0) {
        env->SetAlpha(attr->alpha_blend);
    }
}

int mgCVisualPrim::CreateRenderInfoPacket(u_int * /*packet*/, float (* /*matrix*/)[4], mgRENDER_INFO * /*info*/) {
    return 0;
}

void mgCVisualPrim::Initialize() {
    mgCVisual::Initialize();
    attr.Initialize();
}

int mgCVisualFixMDT::Iam() {
    return 2;
}

// Virtual tables (.vtables)

namespace {

constexpr int kFaceUnusedFrameLimit = 600;
// Persistent faces retain CPU geometry while idle GPU meshes release their slots.
constexpr int kPersistentMeshUnusedFrameLimit = 1800;
// Evictions only free memory, so they may run up to this many frames late.
constexpr int kSweepInterval = 16;

// The GS guard band reaches 10% past the screen on each side; the six-plane clip keeps what lies inside it.
constexpr float kGuardScale = 1.1f;

constexpr u_int kPrmodeFog = 0x20;
constexpr u_int kPrmodeBlend = 0x40;
// Gouraud shading, texture mapping and blending: the PRMODE every visual starts from.
constexpr u_int kPrmodeDefault = 0x58;

// mgCFrameAttr::program_mode bits.
constexpr int kProgramModeReal = 0x1;
constexpr int kProgramModeRefSphere = 0x2;

// The retail material's specular exponent (mat_pw).
constexpr uint32_t kMaterialPower = 3;

// mesh_prog0.vert reads the byte as byte / 255 and multiplies by 255 / 128, so 0x80 is the VU's 1.0 and
// the largest representable VU colour is 255 / 128.
constexpr uint8_t kVuUnitColour = 0x80;

uint8_t VuColourByte(float value) {
    const float scaled = value * 128.0f;
    if (!(scaled > 0.0f)) {
        return 0;
    }
    if (scaled >= 255.0f) {
        return 255;
    }
    return static_cast<uint8_t>(scaled + 0.5f);
}

struct CornerStreams {
    int position;
    int normal;
    int uv;
    int colour;
};

CornerStreams CornerOf(const mgCFace &face, int corner) {
    const int    *cursor = face.index + corner * face.index_stride;
    CornerStreams streams = {.position = cursor[0], .normal = -1, .uv = -1, .colour = -1};
    int           next = 1;

    if ((face.type & MG_FACE_NO_NORMAL) == 0) {
        streams.normal = cursor[next++];
    }
    if ((face.type & MG_FACE_NO_TEXTURE) == 0) {
        streams.uv = cursor[next++];
    }
    if ((face.type & MG_FACE_COLOUR) != 0) {
        streams.colour = cursor[next++];
    }
    return streams;
}

gfx::Vertex3D CornerVertex(const mgCVisualMDT &visual, const CornerStreams &streams) {
    gfx::Vertex3D vertex = {};
    const float  *position = visual.vertex[streams.position];

    for (int i = 0; i < 3; i++) {
        vertex.position[i] = position[i];
    }
    if (streams.normal >= 0) {
        const float *normal = visual.normal[streams.normal];
        for (int i = 0; i < 3; i++) {
            vertex.normal[i] = normal[i];
        }
    }
    if (streams.uv >= 0) {
        const float *uv = visual.uv[streams.uv];
        vertex.uv[0] = uv[0];
        vertex.uv[1] = uv[1];
    }
    for (int i = 0; i < 4; i++) {
        vertex.color[i] = streams.colour >= 0 ? VuColourByte(visual.colour[streams.colour][i]) : kVuUnitColour;
    }
    return vertex;
}

gfx::Vertex3D SkinSlot(const mgVertexWeight &weight) {
    gfx::Prog0Skin skin = {};
    for (int i = 0; i < 4; i++) {
        skin.weight[i] = weight.weight[i];
        skin.bone[i] = static_cast<uint8_t>(weight.matrix[i] / 4);
    }

    gfx::Vertex3D slot = {};
    std::memcpy(&slot, &skin, sizeof slot);
    return slot;
}

struct FaceEntry {
    std::shared_ptr<const mgVisualFaceMesh> mesh;
    bool                                    persistent = false;
    int                                     last_frame = 0;
};

std::unordered_map<const mgCFace *, FaceEntry> &FaceTable() {
    static std::unordered_map<const mgCFace *, FaceEntry> table;
    return table;
}

// Changes whenever a face table entry is added, forgotten, or given new geometry or residency, so a group
// batch validated at the current revision is still current without visiting its faces.
std::uint64_t face_revision = 1;

struct GroupEntry {
    std::shared_ptr<mgVisualGroupMesh> mesh;
    // The face meshes the batch was built from, in draw order. A refreshed face is a new mesh, so a
    // mismatch means the batch is stale; holding them also keeps their addresses from being reused.
    std::vector<std::shared_ptr<const mgVisualFaceMesh>> sources;
    // The faces visited for the batch; a draw that skips the visit still keeps them in the face table.
    std::vector<const mgCFace *> faces;
    const mgFACE_GROUP          *end = nullptr; /**< The group after the batch's last. */
    std::uint64_t                revision = 0;  /**< face_revision when the sources were last checked. */
    bool                         persistent = false;
    int                          last_frame = 0;
};

std::unordered_map<const mgFACE_GROUP *, GroupEntry> &GroupTable() {
    static std::unordered_map<const mgFACE_GROUP *, GroupEntry> table;
    return table;
}

#ifdef CT_ENABLE_TRACY
uint64_t gpu_upload_failures = 0;
uint64_t immediate_face_draws = 0;
#endif

void ReleaseMesh(mgVisualGroupMesh &mesh) {
    if (mesh.mesh != gfx::kNullMesh) {
        gfx::DestroyMesh(mesh.mesh);
        mesh.mesh = gfx::kNullMesh;
    }
}

// Batches waiting for the tick's render lease to upload.
std::vector<std::weak_ptr<mgVisualGroupMesh>> &PendingUploads() {
    static std::vector<std::weak_ptr<mgVisualGroupMesh>> pending;
    return pending;
}

// The CPU copy supports reupload after eviction and immediate draws when no mesh slot is free.
void UploadIfReady(GroupEntry &entry) {
    const mgVisualGroupMesh &mesh = *entry.mesh;
    if (!entry.persistent || mesh.mesh != gfx::kNullMesh || mesh.indices.empty() || !mgPortRendererReady()) {
        return;
    }
    PendingUploads().push_back(entry.mesh);
}

// Concatenates the faces in order. Each face's indices are rebased onto the batch's vertices (a skinned
// vertex is a pair of Vertex3D), and consecutive faces with the same face flags share one run.
std::shared_ptr<mgVisualGroupMesh> BuildGroup(const std::vector<std::shared_ptr<const mgVisualFaceMesh>> &faces) {
    // The last owner releases the GPU mesh, including while a queued draw or display list still holds it.
    std::shared_ptr<mgVisualGroupMesh> group(new mgVisualGroupMesh(), [](mgVisualGroupMesh *mesh) {
        ReleaseMesh(*mesh);
        delete mesh;
    });

    constexpr uint32_t kFaceFlags = MG_FACE_NO_TEXTURE | MG_FACE_COLOUR | MG_FACE_NO_NORMAL;
    for (const auto &face : faces) {
        group->skinned = face->skinned;
        const uint32_t stride = face->skinned ? 2 : 1;
        const uint32_t base = static_cast<uint32_t>(group->vertices.size()) / stride;
        const uint32_t first = static_cast<uint32_t>(group->indices.size());
        const uint32_t flags = face->type & kFaceFlags;
        group->vertices.insert(group->vertices.end(), face->vertices.begin(), face->vertices.end());
        for (uint32_t index : face->indices) {
            group->indices.push_back(base + index);
        }
        if (!group->runs.empty() && group->runs.back().face_flags == flags) {
            group->runs.back().index_count += face->index_count;
        } else {
            group->runs.push_back({.first_index = first, .index_count = face->index_count, .face_flags = flags});
        }
    }
    return group;
}

template <typename T>
bool SameElements(const std::vector<T> &lhs, const std::vector<T> &rhs) {
    if (lhs.size() != rhs.size()) {
        return false;
    }
    return lhs.empty() || std::memcmp(lhs.data(), rhs.data(), lhs.size() * sizeof(T)) == 0;
}

// Compares every field byte for byte, so a rebuilt face with identical geometry is recognised as unchanged.
bool SameFaceMesh(const mgVisualFaceMesh &lhs, const mgVisualFaceMesh &rhs) {
    return lhs.index_count == rhs.index_count && lhs.skinned == rhs.skinned && lhs.type == rhs.type &&
           SameElements(lhs.vertices, rhs.vertices) && SameElements(lhs.indices, rhs.indices);
}

} // namespace

mgVisualFaceMesh mgVisualPortBuildFace(const mgCVisualMDT &visual, const mgCFace &face, bool skinned) {
    mgVisualFaceMesh out;
    out.skinned = skinned;
    out.type = face.type;

    const int corner_count = face.vertex_num;
    if (corner_count <= 0) {
        return out;
    }

    const mgVertexWeight *weights = nullptr;
    if (skinned) {
        // Skin is carried only by a mgCVisualMotionMDT. When its bones overflow, retail leaves the weights
        // NULL and then reads through them, so such a face has no geometry here.
        const auto &motion = static_cast<const mgCVisualMotionMDT &>(visual);
        if (motion.weight == nullptr) {
            return out;
        }
        weights = motion.weight;
    }

    const size_t vertices_per_corner = skinned ? 2 : 1;
    out.vertices.reserve(static_cast<size_t>(corner_count) * vertices_per_corner);
    if ((face.type & MG_FACE_PRIM_MASK) == MG_PRIM_TRIANGLE_STRIP) {
        out.indices.reserve(corner_count >= 3 ? 3 * static_cast<size_t>(corner_count - 2) : 0);
    } else {
        out.indices.reserve(3 * static_cast<size_t>(corner_count / 3));
    }

    for (int corner = 0; corner < corner_count; corner++) {
        const CornerStreams streams = CornerOf(face, corner);
        out.vertices.push_back(CornerVertex(visual, streams));
        if (skinned) {
            out.vertices.push_back(SkinSlot(weights[streams.position]));
        }
    }

    if ((face.type & MG_FACE_PRIM_MASK) == MG_PRIM_TRIANGLE_STRIP) {
        // Retail restarts the winding parity at each VU1 batch; that is a batching artefact and is not
        // reproduced, so the whole strip keeps one winding.
        for (int t = 0; t + 2 < corner_count; t++) {
            const bool odd = (t & 1) != 0;
            out.indices.push_back(static_cast<uint32_t>(odd ? t + 1 : t));
            out.indices.push_back(static_cast<uint32_t>(odd ? t : t + 1));
            out.indices.push_back(static_cast<uint32_t>(t + 2));
        }
    } else {
        for (int corner = 0; corner + 2 < corner_count; corner += 3) {
            out.indices.push_back(static_cast<uint32_t>(corner));
            out.indices.push_back(static_cast<uint32_t>(corner + 1));
            out.indices.push_back(static_cast<uint32_t>(corner + 2));
        }
    }

    out.index_count = static_cast<uint32_t>(out.indices.size());
    return out;
}

void mgVisualPortRefreshFace(mgCVisualMDT *visual, mgCFace *face) {
    CT_PROFILE_ZONE("Build visual face");
    {
    }
    const int        kind = visual->Iam();
    auto [found, added] = FaceTable().try_emplace(face);
    FaceEntry       &entry = found->second;
    mgVisualFaceMesh mesh = mgVisualPortBuildFace(*visual, *face, kind == MG_VISUAL_KIND_MOTION_MDT);
    const bool       persistent = kind == MG_VISUAL_KIND_FIX_MDT || kind == MG_VISUAL_KIND_MOTION_MDT;
    if (added || entry.persistent != persistent) {
        ++face_revision;
    }
    // An unchanged face keeps its mesh, so the group batches built from it stay valid and are not rebuilt.
    // A changed face is a new mesh, and a group batch built from the previous one keeps it alive until it
    // next draws.
    if (entry.mesh == nullptr || !SameFaceMesh(*entry.mesh, mesh)) {
        entry.mesh = std::make_shared<const mgVisualFaceMesh>(std::move(mesh));
        ++face_revision;
    }
    // A plain visual is rebuilt on every CreateFacePacket and would churn GPU meshes if uploaded, so its
    // group batches stay on the CPU.
    entry.persistent = persistent;
    entry.last_frame = mgPortFrameCount();
}

namespace {

FaceEntry *FindFace(const mgCFace *face) {
    auto &table = FaceTable();
    auto  found = table.find(face);
    if (found == table.end()) {
        return nullptr;
    }
    found->second.last_frame = mgPortFrameCount();
    return &found->second;
}

// Visits the face entries of the groups from first up to end that have geometry, in draw order.
template <typename Visit>
void VisitGroupFaces(const mgFACE_GROUP *first, const mgFACE_GROUP *end, Visit &&visit) {
    for (const mgFACE_GROUP *group = first; group != end; group = group->next) {
        for (const mgCFace *face = group->face; face != nullptr; face = face->next) {
            const FaceEntry *entry = FindFace(face);
            if (entry == nullptr || entry->mesh->indices.empty()) {
                continue;
            }
            visit(face, *entry);
        }
    }
}

void SweepPeriodically() {
    if (mgPortFrameCount() % kSweepInterval == 0) {
        mgVisualPortSweep();
    }
}

// The batch of the groups from first up to end, keyed by first.
std::shared_ptr<const mgVisualGroupMesh> GroupMesh(const mgFACE_GROUP *first, const mgFACE_GROUP *end) {
    // A batch checked at the current face revision is current; marking it first keeps its faces through a sweep.
    if (const auto found = GroupTable().find(first); found != GroupTable().end()) {
        GroupEntry &cached = found->second;
        if (cached.revision == face_revision && cached.end == end && cached.mesh != nullptr) {
            cached.last_frame = mgPortFrameCount();
            SweepPeriodically();
            if (cached.revision == face_revision) {
                UploadIfReady(cached);
                return cached.mesh;
            }
        }
    }

    // Otherwise the cached batch is checked face by face against its sources.
    const GroupEntry *cached = nullptr;
    if (const auto found = GroupTable().find(first); found != GroupTable().end()) {
        cached = &found->second;
    }
    bool                         persistent = true;
    bool                         matched = cached != nullptr;
    size_t                       kept = 0;
    std::vector<const mgCFace *> visited;
    VisitGroupFaces(first, end, [&](const mgCFace *face, const FaceEntry &entry) {
        persistent = persistent && entry.persistent;
        matched = matched && kept < cached->sources.size() && cached->sources[kept].get() == entry.mesh.get();
        visited.push_back(face);
        ++kept;
    });
    matched = matched && kept == cached->sources.size();

    SweepPeriodically();
    if (kept == 0) {
        return nullptr;
    }

    // The sweep may have erased this group's entry, in which case the cached pointer is no longer used and
    // operator[] yields a fresh entry that is rebuilt below.
    GroupEntry &entry = GroupTable()[first];
    if (!matched || entry.mesh == nullptr) {
        std::vector<std::shared_ptr<const mgVisualFaceMesh>> faces;
        faces.reserve(kept);
        // The sweep spares every face this walk visited, so the second walk sees the same faces.
        VisitGroupFaces(first, end, [&](const mgCFace *, const FaceEntry &face_entry) { faces.push_back(face_entry.mesh); });
        entry.mesh = BuildGroup(faces);
        entry.sources = std::move(faces);
    }
    entry.faces = std::move(visited);
    entry.end = end;
    entry.revision = face_revision;
    entry.persistent = persistent;
    entry.last_frame = mgPortFrameCount();
    UploadIfReady(entry);
    return entry.mesh;
}

} // namespace

const mgVisualFaceMesh *mgVisualPortFaceMesh(const mgCFace *face) {
    const FaceEntry *entry = FindFace(face);
    return entry != nullptr ? entry->mesh.get() : nullptr;
}

const mgVisualGroupMesh *mgVisualPortGroupMesh(const mgFACE_GROUP *first, const mgFACE_GROUP *end) {
    return GroupMesh(first, end).get();
}

void mgVisualPortFlushUploads() {
    for (const std::weak_ptr<mgVisualGroupMesh> &pending : PendingUploads()) {
        const std::shared_ptr<mgVisualGroupMesh> mesh = pending.lock();
        // A batch drawn more than once this tick is queued more than once.
        if (mesh == nullptr || mesh->mesh != gfx::kNullMesh || mesh->indices.empty() || !mgPortRendererReady()) {
            continue;
        }
        mesh->mesh = gfx::CreateMesh(mesh->vertices, mesh->indices);
#ifdef CT_ENABLE_TRACY
        if (ct::profile::Enabled() && mesh->mesh == gfx::kNullMesh) {
            ++gpu_upload_failures;
        }
#endif
    }
    PendingUploads().clear();
}

void mgVisualPortSweep() {
    static int swept_frame = -1;
    const int  frame = mgPortFrameCount();
    if (frame == swept_frame) {
        return;
    }
    swept_frame = frame;
    CT_PROFILE_ZONE("Sweep visual faces");

    auto &faces = FaceTable();
    // A batch returned without visiting its faces still used them when it was drawn.
    for (const auto &[group, entry] : GroupTable()) {
        static_cast<void>(group);
        for (const mgCFace *face : entry.faces) {
            if (const auto found = faces.find(face); found != faces.end()) {
                found->second.last_frame = std::max(found->second.last_frame, entry.last_frame);
            }
        }
    }
#ifdef CT_ENABLE_TRACY
    const bool profiling = ct::profile::Enabled();
    uint64_t   gpu_groups = 0;
    uint64_t   cpu_bytes = 0;
#endif
    for (auto it = faces.begin(); it != faces.end();) {
#ifdef CT_ENABLE_TRACY
        if (profiling) {
            cpu_bytes += it->second.mesh->vertices.size() * sizeof(gfx::Vertex3D) +
                         it->second.mesh->indices.size() * sizeof(uint32_t);
        }
#endif
        if (it->second.persistent || frame - it->second.last_frame <= kFaceUnusedFrameLimit) {
            ++it;
            continue;
        }
        // A queued draw may still own this CPU geometry after the table forgets it.
        it = faces.erase(it);
        ++face_revision;
    }

    auto &groups = GroupTable();
    for (auto it = groups.begin(); it != groups.end();) {
#ifdef CT_ENABLE_TRACY
        if (profiling) {
            gpu_groups += it->second.mesh->mesh != gfx::kNullMesh;
            cpu_bytes += it->second.mesh->vertices.size() * sizeof(gfx::Vertex3D) +
                         it->second.mesh->indices.size() * sizeof(uint32_t);
        }
#endif
        const int unused = frame - it->second.last_frame;
        if (it->second.persistent) {
            if (unused > kPersistentMeshUnusedFrameLimit) {
                ReleaseMesh(*it->second.mesh);
            }
            ++it;
            continue;
        }
        if (unused <= kFaceUnusedFrameLimit) {
            ++it;
            continue;
        }
        it = groups.erase(it);
    }
#ifdef CT_ENABLE_TRACY
    if (profiling) {
        CT_PROFILE_PLOT("Visual face table entries", static_cast<int64_t>(faces.size()));
        CT_PROFILE_PLOT("Visual resident GPU batches", static_cast<int64_t>(gpu_groups));
        CT_PROFILE_PLOT("Visual retained CPU bytes", static_cast<int64_t>(cpu_bytes));
        CT_PROFILE_PLOT("Visual GPU upload failures", static_cast<int64_t>(gpu_upload_failures));
        CT_PROFILE_PLOT("Visual immediate face draws", static_cast<int64_t>(immediate_face_draws));
    }
    gpu_upload_failures = 0;
    immediate_face_draws = 0;
#endif
}

int mgCVisualMDT::CreateFacePacket(u_int * /*packet*/, mgCFace *face) {
    if (face != nullptr) {
        mgVisualPortRefreshFace(this, face);
    }
    return 0;
}

namespace {

struct RenderRecord {
    gfx::MeshConstants  mesh;
    gfx::Prog0Constants prog0;
    gfx::Prog0Palette   palette{};
    gfx::MeshTransform  transform{};
    gfx::DrawState      state;
    bool                drawn = false;
};

RenderRecord &CurrentRecord() {
    static RenderRecord record;
    return record;
}

const void *current_object = nullptr;

// A draw owns its immutable geometry independently of the group address in the load arena.
struct RunDraw {
    std::shared_ptr<const mgVisualGroupMesh> geometry;
    mgVisualGroupRun                         run;
    gfx::TextureBinding                      binding;
};

struct GroupDraw {
    gfx::MeshConstants  mesh;
    gfx::Prog0Constants prog0;
    // A copy, because the record is overwritten by the next visual before a packet's deferred draw runs.
    std::optional<gfx::Prog0Palette> palette;
    gfx::MeshTransform               transform{};
    gfx::DrawState                   state;
    const void                      *object{};
};

// A deferred group draw's state, shared by the packet's closure so the closure stays small.
struct GroupPacket {
    GroupDraw            draw;
    std::vector<RunDraw> runs;
};

/**
 * Group packets registered since the packet draws were last cleared, reused afterwards so their run vectors keep
 * their storage.
 */
struct GroupPacketPool {
    std::deque<GroupPacket> packets;   /**< Stable storage; a registered draw names its packet by index. */
    std::size_t             used = 0;  /**< Packets handed out in the current epoch. */
    std::uint64_t           epoch = 0; /**< mgPortPacketDrawEpoch when `used` was last reset. */
};

GroupPacketPool &GroupPackets() {
    static GroupPacketPool pool;
    return pool;
}

std::size_t NextGroupPacket() {
    GroupPacketPool &pool = GroupPackets();
    if (pool.epoch != mgPortPacketDrawEpoch()) {
        // The geometry owners go with the cleared draws; the vectors keep their storage.
        for (std::size_t index = 0; index < pool.used; ++index) {
            pool.packets[index].runs.clear();
        }
        pool.epoch = mgPortPacketDrawEpoch();
        pool.used = 0;
    }
    if (pool.used == pool.packets.size()) {
        pool.packets.emplace_back();
    }
    return pool.used++;
}

// Both prog0 submissions. Every call goes through here, so the renderer and frame checks mgPortDrawMesh makes
// apply to all of them.
void SubmitRuns(const GroupDraw &group, const std::vector<RunDraw> &runs) {
    CT_PROFILE_ZONE("Submit visual faces");
    if (!mgPortRendererReady() || !mgPortFrameOpen()) {
        return;
    }

    mgPortInterpScope scope(group.object, kMgPortFrameTeleportDistance);
    gfx::DrawState    state = group.state;

    for (const RunDraw &draw : runs) {
        state.prog0_face = draw.run.face_flags;

        const gfx::Prog0Palette *palette = group.palette ? &*group.palette : nullptr;
        if (draw.geometry->mesh != gfx::kNullMesh) {
            mgPortDrawMeshProg0(draw.geometry->mesh, draw.run.first_index, draw.run.index_count, group.mesh,
                                group.prog0, draw.binding, state, &group.transform, palette);
        } else {
#ifdef CT_ENABLE_TRACY
            if (ct::profile::Enabled()) {
                ++immediate_face_draws;
            }
#endif
            const auto indices = std::span(draw.geometry->indices).subspan(draw.run.first_index, draw.run.index_count);
            mgPortDrawMeshImmediateProg0(draw.geometry->vertices, indices, group.mesh, group.prog0, draw.binding, state,
                                         &group.transform, palette);
        }
    }
}

// Maps the clip space of the guard band onto the visible extent: the extent's centre and half sizes sit inside
// the guard, so at a 4:3 window the matrix is the identity.
void VisibleClipFit(float (*fit)[4]) {
    const mgPortExtent extent = mgPortVisibleExtent();
    const float        half_screen_w = 0.5f * static_cast<float>(mgScreenWidth);
    const float        half_screen_h = 0.5f * static_cast<float>(mgScreenHeight);
    const float        half_w = 0.5f * (extent.right - extent.left);
    const float        half_h = 0.5f * (extent.bottom - extent.top);
    const float        centre_x = 0.5f * (extent.left + extent.right) - half_screen_w;
    const float        centre_y = 0.5f * (extent.top + extent.bottom) - half_screen_h;

    std::memset(fit, 0, 16 * sizeof(float));
    fit[0][0] = half_screen_w / half_w;
    fit[3][0] = -centre_x / (kGuardScale * half_w);
    fit[1][1] = half_screen_h / half_h;
    fit[3][1] = -centre_y / (kGuardScale * half_h);
    fit[2][2] = 1.0f;
    fit[3][3] = 1.0f;
}

// Retail scales the screen matrix's z translation by 1.005; that term is projection[14] scaled by the same
// factor, so the bias is a multiply on the clip-space translation.
void ApplyDepthBias(gfx::MeshTransform &transform) {
    transform.projection[14] *= 1.005f;
}

} // namespace

// The base environment with the face's test, alpha and depth-write attributes applied. Retail packs the
// same result into a GIF tag; the port keeps the register state as the mgCDrawEnv itself.
mgCDrawEnv mgVisualPortDrawEnv(const mgCVisualAttr &attr, const mgCDrawEnv &base) {
    mgCDrawEnv env = base;

    if (attr.alpha_ref >= 0) {
        env.test.bits.aref = attr.alpha_ref;
    }

    if (attr.z_test != 0) {
        env.test.bits.zte = 1;
        switch (attr.z_test) {
            case MG_DEPTH_TEST_ALWAYS:
                env.test.bits.ztst = 1;
                break;
            case MG_DEPTH_TEST_GEQUAL:
                env.test.bits.ztst = 2;
                break;
            case MG_DEPTH_TEST_GREATER:
                env.test.bits.ztst = 3;
                break;
        }
    }

    if (attr.alpha_test > 0) {
        env.test.bits.ate = 1;
        env.test.bits.atst = attr.alpha_test;
    } else if (attr.alpha_test == -1) {
        env.test.bits.ate = 0;
    }

    switch (attr.dest_alpha_test) {
        case MG_DEST_ALPHA_TEST_OFF:
            env.test.bits.date = 0;
            break;
        case MG_DEST_ALPHA_TEST_ZERO:
            env.test.bits.date = 1;
            env.test.bits.datm = 0;
            break;
        case MG_DEST_ALPHA_TEST_ONE:
            env.test.bits.date = 1;
            env.test.bits.datm = 1;
            break;
    }

    if (attr.alpha_blend != 0) {
        env.SetAlpha(attr.alpha_blend);
    }

    env.SetZBuf(attr.z_write);
    return env;
}

const void *mgVisualPortObject() {
    return current_object;
}

void mgVisualPortSetObject(const void *object) {
    current_object = object;
}

gfx::Prog0Constants &mgVisualPortCurrentProg0() {
    return CurrentRecord().prog0;
}

gfx::Prog0Palette &mgVisualPortCurrentPalette() {
    return CurrentRecord().palette;
}

int mgCVisualMDT::CreateRenderInfoPacket(u_int * /*packet*/, float (*matrix)[4], mgRENDER_INFO *info) {
    RenderRecord &record = CurrentRecord();
    record.drawn = info->attr != nullptr;

    if (!record.drawn) {
        return 0;
    }

    const mgCFrameAttr  &attr = *info->attr;
    mgLIGHT_INFO        *lighting = info->GetpLightInfo();
    gfx::Prog0Constants &prog0 = record.prog0;

    std::memset(&prog0, 0, sizeof prog0);

    record.transform = mgPortMeshTransform(&matrix[0][0]);
    if (attr.depth_bias > 1.0f) {
        ApplyDepthBias(record.transform);
    }

    auto         *projection = reinterpret_cast<float (*)[4]>(record.transform.projection);
    auto         *view = reinterpret_cast<float (*)[4]>(record.transform.view);
    auto         *model = reinterpret_cast<float (*)[4]>(record.transform.model);
    sceVu0FMATRIX view_model;
    sceVu0FMATRIX mvp;
    mgMulMatrix(view_model, view, model);
    mgMulMatrix(mvp, projection, view_model);
    record.mesh = gfx::MeshConstants();
    std::memcpy(record.mesh.mvp, mvp, sizeof mvp);

    std::memcpy(prog0.model_world, matrix, sizeof prog0.model_world);
    for (int k = 0; k < 3; k++) {
        std::memcpy(prog0.light_direction[k], lighting->light_dir[k], sizeof prog0.light_direction[k]);
    }
    std::memcpy(prog0.light_color, lighting->light_color, sizeof prog0.light_color);
    std::memcpy(prog0.ambient, lighting->ambient, sizeof prog0.ambient);
    prog0.ambient[3] *= attr.obj_alpha;

    if (attr.ambient_boost != 0) {
        for (int i = 0; i < 3; i++) {
            prog0.object_color[i] = 0.3f * lighting->light_color[0][i] + lighting->ambient[i];
        }
        prog0.object_color[3] = info->object_color[3];
    } else {
        std::memcpy(prog0.object_color, info->object_color, sizeof prog0.object_color);
    }
    prog0.object_color[3] *= attr.obj_alpha;

    if (attr.program_mode != 0) {
        sceVu0FVECTOR eye = {info->camera_pos[0], info->camera_pos[1], info->camera_pos[2], 1.0f};
        sceVu0FMATRIX inverse;
        sceVu0CopyMatrix(inverse, matrix);
        sceVu0InversMatrix(inverse, inverse);
        sceVu0ApplyMatrix(eye, inverse, eye);
        std::memcpy(prog0.eye, eye, sizeof prog0.eye);
    }

    auto *clip_or_view = reinterpret_cast<float (*)[4]>(prog0.clip_or_view);
    if (info->scissor != 0) {
        sceVu0FMATRIX model_clip;
        sceVu0FMATRIX fit;
        mgMulMatrix(model_clip, info->world_clip, matrix);
        VisibleClipFit(fit);
        mgMulMatrix(clip_or_view, fit, model_clip);
    }

    if (attr.program_mode & kProgramModeRefSphere) {
        mgMulMatrix(clip_or_view, info->view, matrix);
    }

    if (info->plight_hit != 0 && info->lighting_enabled != 0) {
        for (int i = 0; i < 4; i++) {
            const mgPOINT_LIGHT &light = lighting->point_light[i];
            for (int k = 0; k < 3; k++) {
                prog0.point_light[i][k] = light.pos[k] - matrix[3][k];
            }
            prog0.point_light[i][3] = light.power;
            std::memcpy(prog0.point_color[i], light.color, sizeof prog0.point_color[i]);
        }
    }

    prog0.fog[0] = info->fog.offset;
    prog0.fog[1] = info->fog.near_value;
    prog0.fog[2] = info->fog.far_value;
    prog0.fog[3] = info->fog.scale;

    uint32_t flags = 0;
    if ((info->clip | info->scissor) != 0) {
        flags |= gfx::kProg0Clip;
    }
    if (info->scissor != 0) {
        flags |= gfx::kProg0Scissor;
    }
    if (attr.program_mode & kProgramModeReal) {
        flags |= gfx::kProg0Real;
    }
    if (attr.program_mode & kProgramModeRefSphere) {
        flags |= gfx::kProg0RefSphere;
    }
    if (attr.program_option != 0) {
        flags |= gfx::kProg0Cull;
    }
    if (info->plight_hit != 0) {
        flags |= gfx::kProg0PointLights;
    }
    if (info->motion != 0) {
        flags |= gfx::kProg0Skinned;
    }
    if (attr.no_light != 0 || info->lighting_enabled == 0 || attr.ambient_boost != 0) {
        flags |= gfx::kProg0Unlit;
    }
    if (attr.unk_84 == 1) {
        flags |= gfx::kProg0ColorAdd;
    }
    prog0.flags = flags;
    // Skinning is decided above. Identity bones hold until the motion code writes this visual's pose.
    if ((flags & gfx::kProg0Skinned) != 0) {
        for (auto &bone : record.palette.bones) {
            for (int row = 0; row < 3; row++) {
                for (int col = 0; col < 4; col++) {
                    bone[row][col] = row == col ? 1.0f : 0.0f;
                }
            }
        }
    }

    const bool fogged = attr.fog != 0 && info->fog_enable != 0;
    this->prmode = (fogged ? kPrmodeFog : 0) | kPrmodeDefault;

    const mgCDrawEnv env = mgVisualPortDrawEnv(attr, draw_env != nullptr ? *draw_env : info->draw_env[0]);

    record.state = mgPortDrawState();
    mgPortApplyDrawEnv(record.state, env);
    record.state.blend = (this->prmode & kPrmodeBlend) != 0;
    record.state.fog = fogged;

    uint8_t fog_rgb[3] = {info->fog.r, info->fog.g, info->fog.b};
    if (attr.fog > MG_FOG_SCENE) {
        const uint8_t value = attr.fog == MG_FOG_WHITE ? 0xFF : 0x00;
        fog_rgb[0] = fog_rgb[1] = fog_rgb[2] = value;
    }
    for (int c = 0; c < 3; c++) {
        record.state.fog_color[c] = fog_rgb[c];
    }

    record.drawn = true;
    CreateExtRenderInfoPacket(nullptr, matrix, info);
    return 0;
}

uptr mgCVisualMDT::CreatePacket(mgCDrawManager * /*manager*/) {
    CT_PROFILE_ZONE("Create visual packet");
    for (mgFACE_GROUP *group = face_group; group != nullptr; group = group->next) {
        for (mgCFace *face = group->face; face != nullptr; face = face->next) {
            CreateFacePacket(nullptr, face);
        }
    }
    return 0;
}

uptr mgCVisualFixMDT::CreatePacket(mgCDrawManager * /*manager*/) {
    return 0;
}

int mgCVisualMDT::Draw(u_int *tag, float (*matrix)[4], mgCDrawManager *draw_manager) {
    CT_PROFILE_ZONE("Draw visual");
    if (draw_manager == nullptr) {
        draw_manager = &mgDrawManager;
    }

    mgRENDER_INFO *info = draw_manager->render_info;
    texture_manager = draw_manager->texture_manager;
    // A shadow model's CreateRenderInfoPacket leaves the record alone, so the previous visual's record must not
    // send the shadow faces down as lit meshes in that visual's place.
    CurrentRecord().drawn = false;
    CreateRenderInfoPacket(nullptr, matrix, info);
    CreatePacket(draw_manager);

    const RenderRecord &record = CurrentRecord();
    if (!record.drawn) {
        return 0;
    }

    const void *object = mgVisualPortObject();
    if (object == nullptr) {
        object = this;
    }

    u_long128 *common = nullptr;
    if (tag == nullptr) {
        if (draw_manager->data_memory == nullptr || draw_manager->data_memory->lock != 0 ||
            dc2::memory::RemainingBytes(*draw_manager->data_memory).size() <= sizeof(u_long128)) {
            return 0;
        }
        common = draw_manager->data_memory->Alloc(1);
        if (common == nullptr) {
            return 0;
        }
        // This common packet is empty; its reused address may still hold an earlier face draw.
        mgPortClearPacketDraw(common);
    }

    for (mgFACE_GROUP *group = face_group, *end = nullptr; group != nullptr; group = end) {
        // Consecutive groups with one material and microprogram draw identically, so they batch together.
        end = group->next;
        while (end != nullptr && end->material == group->material && end->vu_program == group->vu_program) {
            end = end->next;
        }
        mgMaterial         *mat = material + group->material;
        gfx::TextureBinding binding = mgPortBinding(mat->texture);
        // Set each material's CLAMP so a draw does not inherit another material's wrap mode.
        if (mat->texture != nullptr) {
            binding.wrap_u = mgPortWrapU(mat->texture->clamp_bits);
            binding.wrap_v = mgPortWrapV(mat->texture->clamp_bits);
        }

        GroupDraw draw;
        draw.mesh = record.mesh;
        draw.prog0 = record.prog0;
        if ((record.prog0.flags & gfx::kProg0Skinned) != 0) {
            draw.palette = record.palette;
        }
        std::memcpy(draw.prog0.diffuse, mat->diffuse, sizeof draw.prog0.diffuse);
        std::memcpy(draw.prog0.specular, mat->unk_10, sizeof draw.prog0.specular);
        draw.prog0.specular_power = kMaterialPower;
        draw.transform = record.transform;
        draw.state = record.state;
        draw.state.cull = gfx::Prog0CullMode(draw.prog0);
        draw.object = object;

        static std::vector<RunDraw> runs;
        runs.clear();
        std::shared_ptr<const mgVisualGroupMesh> geometry;
        geometry = GroupMesh(group, end);
        if (geometry) {
            runs.reserve(geometry->runs.size());
            for (const mgVisualGroupRun &run : geometry->runs) {
                const bool textured = (run.face_flags & MG_FACE_NO_TEXTURE) == 0;
                runs.push_back({.geometry = geometry, .run = run, .binding = textured ? binding : gfx::TextureBinding()});
            }
        }

        if (tag != nullptr) {
            SubmitRuns(draw, runs);
            continue;
        }

        if (draw_manager->data_memory->lock != 0 ||
            dc2::memory::RemainingBytes(*draw_manager->data_memory).size() <= sizeof(u_long128)) {
            break;
        }
        u_long128 *packet = draw_manager->data_memory->Alloc(1);
        if (packet == nullptr) {
            break;
        }

        const std::size_t index = NextGroupPacket();
        GroupPacket      &group_packet = GroupPackets().packets[index];
        group_packet.draw = draw;
        group_packet.runs.assign(runs.begin(), runs.end());
        const std::uint64_t epoch = GroupPackets().epoch;
        mgPortSetPacketDraw(packet, [index, epoch] {
            // Registered draws are cleared with the epoch, so a matching epoch still owns this packet.
            if (GroupPackets().epoch == epoch) {
                const GroupPacket &deferred = GroupPackets().packets[index];
                SubmitRuns(deferred.draw, deferred.runs);
            }
        });

        const int block = mat->texture != nullptr ? mat->texture->block : -1;
        draw_manager->AddPacket(block, common, packet, group->vu_program);
    }

    return 0;
}

namespace dc2::render {
namespace {
/**
 * Holds immutable identities of one concrete visual and its copied materials.
 */
struct VisualCloneState {
    dc2::memory::ArenaBuffer object;             /**< Exact concrete visual object lease. */
    VisualCloneKind          kind;               /**< Concrete class selected by the producer. */
    mgMaterial              *material = nullptr; /**< Material identity at publication. */
    int                      material_count = 0; /**< Material count at publication. */
    dc2::memory::ArenaBuffer materials;          /**< Exact material array lease. */
};

/**
 * Gives the complete native object extent for a trusted factory choice.
 */
std::size_t VisualCloneSize(VisualCloneKind kind) {
    switch (kind) {
        case VisualCloneKind::Mdt:
            return sizeof(mgCVisualMDT);
        case VisualCloneKind::FixMdt:
            return sizeof(mgCVisualFixMDT);
        case VisualCloneKind::ShadowMdt:
            return sizeof(mgCShadowMDT);
        case VisualCloneKind::ShadowFixMdt:
            return sizeof(mgCShadowFixMDT);
        case VisualCloneKind::MotionMdt:
            return sizeof(mgCVisualMotionMDT);
        case VisualCloneKind::Sprite3D:
            return sizeof(mgC3DSprite);
        case VisualCloneKind::Water:
            return sizeof(CWater);
    }
    return 0;
}

/**
 * Reports whether the concrete clone implementation reads the material array.
 */
bool CopiesMaterials(VisualCloneKind kind) {
    return kind == VisualCloneKind::FixMdt || kind == VisualCloneKind::MotionMdt;
}
} // namespace

bool VisualCloneInputs::Publish(mgCMemory &producer, mgCVisual &visual, VisualCloneKind kind) {
    visual.clone_inputs = {};
    try {
        auto       value = std::make_shared<VisualCloneState>();
        const auto bytes = VisualCloneSize(kind);
        if (bytes == 0) {
            return false;
        }
        value->object = dc2::memory::ArenaBuffer::Bind(producer, {reinterpret_cast<u8 *>(&visual), bytes});
        if (value->object.Bytes().size() != bytes) {
            return false;
        }
        value->kind = kind;
        if (CopiesMaterials(kind)) {
            const auto &mdt = static_cast<const mgCVisualMDT &>(visual);
            if (mdt.material_num < 0 || (mdt.material_num > 0 && mdt.material == nullptr)) {
                return false;
            }
            const auto count = static_cast<std::size_t>(mdt.material_num);
            if (count > std::numeric_limits<std::size_t>::max() / sizeof(mgMaterial)) {
                return false;
            }
            value->material = mdt.material;
            value->material_count = mdt.material_num;
            if (count != 0) {
                value->materials = dc2::memory::ArenaBuffer::Bind(producer, {reinterpret_cast<u8 *>(mdt.material), count * sizeof(mgMaterial)});
                if (value->materials.Bytes().size() != count * sizeof(mgMaterial)) {
                    return false;
                }
            }
        }
        visual.clone_inputs.state = dc2::memory::ArenaResource::Store(value->object, value);
        return visual.clone_inputs.Matches(&visual);
    } catch (const std::bad_alloc &) {
        return false;
    }
}

bool VisualCloneInputs::Matches(const mgCVisual *visual) const {
    const auto value = state.Acquire<VisualCloneState>();
    if (!value || visual == nullptr) {
        return false;
    }
    const auto object = value->object.Bytes();
    if (object.size() != VisualCloneSize(value->kind) || object.data() != reinterpret_cast<const u8 *>(visual)) {
        return false;
    }
    // The exact object lease must pass before reading the embedded handle or derived fields.
    if (visual->clone_inputs.state.Acquire<VisualCloneState>() != value) {
        return false;
    }
    if (CopiesMaterials(value->kind)) {
        const auto &mdt = static_cast<const mgCVisualMDT &>(*visual);
        if (mdt.material != value->material || mdt.material_num != value->material_count) {
            return false;
        }
        if (value->material_count != 0 && value->materials.Bytes().size() != static_cast<std::size_t>(value->material_count) * sizeof(mgMaterial)) {
            return false;
        }
    }
    return true;
}

mgCVisual *VisualCloneInputs::Clone(mgCVisual *expected, mgCMemory *memory) const {
    if (!Matches(expected)) {
        return nullptr;
    }
    try {
        return expected->Copy(memory);
    } catch (const std::bad_alloc &) {
        return nullptr;
    }
}

std::optional<VisualCloneKind> VisualCloneInputs::Kind(const mgCVisual *visual) const {
    if (!Matches(visual)) {
        return std::nullopt;
    }
    const auto value = state.Acquire<VisualCloneState>();
    return value ? std::optional(value->kind) : std::nullopt;
}
} // namespace dc2::render
