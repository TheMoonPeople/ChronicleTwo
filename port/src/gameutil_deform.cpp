#include "common.h"

#include <cstring>
#include <iterator>
#include <utility>

#include "gameutil.hpp"
#include "mg_frame.hpp"
#include "mg_visual.hpp"

namespace {

/**
 *
 * Records which normals each vertex of a skinned mesh uses, keeping each vertex to its record's slots.
 *
 */
void LinkVertexNormals(tagFRAME_INF &info, const mgCVisualMDT &mesh) {
    for (int j = 0; j < mesh.vertex_num; ++j) {
        info.vertex_refs[j].count = 0;
    }

    for (mgFACE_GROUP *node = mesh.face_group; node != nullptr; node = node->next) {
        // Retail tests the group's first face for normals before walking each of its faces.
        for (mgCFace *list = node->face; list != nullptr && !(node->face->type & MG_FACE_NO_NORMAL); list = list->next) {
            const int *indices = list->index;
            for (int pos = 0; pos < list->index_num; pos += list->index_stride) {
                const int from = indices[pos];
                const int to = indices[pos + 1];
                if (from < 0 || from >= mesh.vertex_num) {
                    continue;
                }
                FrameLinkRecord &record = info.vertex_refs[from];
                if (std::cmp_less(record.count, std::size(record.link))) {
                    record.link[record.count++] = to;
                }
            }
        }
    }
}

} // namespace

// Retail appends a normal to a vertex's eleven-slot record for every face corner that uses the vertex,
// overrunning the next record on meshes whose vertices are shared more widely, and indexes the records
// with face indices unchecked.
PORT_OVERRIDE int AnimeDataInit(mgCFrame *frame, tagMOTION_TYPE *motion, mgCMemory *memory, tagFRAME_INF *frame_info) {
    const int frame_num = frame->GetFrameNum();
    for (int i = 0; i < frame_num; ++i) {
        tagFRAME_INF &info = frame_info[i];
        info.parent = static_cast<s32>(frame->GetFrame(i)->parent - frame);
        info.vertex_count = 0;
        info.normal_count = 0;
    }

    for (Mot_List *channel = motion->skin_list; channel != nullptr; channel = channel->next) {
        if (channel->type != MOTION_KEY_SKIN_WEIGHTED && channel->type != MOTION_KEY_SKIN_AVERAGED) {
            continue;
        }
        mgCFrame     *target = frame->GetFrame(channel->frame);
        tagFRAME_INF &info = frame_info[channel->frame];
        if (info.vertex_count != 0 || target == nullptr || target->visual == nullptr) {
            continue;
        }

        auto      &mesh = *static_cast<mgCVisualMDT *>(target->visual);
        const auto vertices = static_cast<u32>(mesh.vertex_num);
        const auto normals = static_cast<u32>(mesh.normal_num);
        info.base_vertices = reinterpret_cast<sceVu0FVECTOR *>(memory->Alloc(vertices + 1));
        info.base_normals = reinterpret_cast<sceVu0FVECTOR *>(memory->Alloc(normals + 1));
        info.vertex_refs = reinterpret_cast<FrameLinkRecord *>(memory->Alloc(static_cast<u32>((vertices * sizeof(FrameLinkRecord)) >> 4) + 1));
        info.vertex_count = vertices;
        info.normal_count = normals;
        std::memcpy(info.base_vertices, mesh.vertex, vertices * sizeof(sceVu0FVECTOR));
        std::memcpy(info.base_normals, mesh.normal, normals * sizeof(sceVu0FVECTOR));
        LinkVertexNormals(info, mesh);
    }
    return true;
}
