#include "common.h"

#include <algorithm>
#include <cstring>
#include <limits>
#include <vector>

#include "gameutil.hpp"
#include "mg_frame.hpp"
#include "mg_visual.hpp"

int AnimeDataInit(mgCFrame *frame, tagMOTION_TYPE *motion, mgCMemory *memory, std::span<tagFRAME_INF> frame_info) {
    if (frame == nullptr || motion == nullptr || memory == nullptr || memory->lock != 0) {
        return false;
    }
    const int frame_num = frame->GetFrameNum();
    if (frame_num <= 0 || static_cast<std::size_t>(frame_num) > frame_info.size()) {
        return false;
    }
    std::vector<mgCFrame *> frames;
    frames.reserve(static_cast<std::size_t>(frame_num));
    for (int index = 0; index < frame_num; ++index) {
        auto *node = frame->GetFrame(index);
        if (node == nullptr) {
            return false;
        }
        frames.push_back(node);
    }

    /**
     * Keeps a validated target mesh and its frame-table slot.
     */
    struct MeshCopy {
        std::size_t   index; /**< Slot receiving the mesh data. */
        mgCVisualMDT *mesh;  /**< Source mesh whose vertices and normals are copied. */
    };

    std::vector<MeshCopy> copies;
    std::vector<bool>     seen(frames.size());
    std::size_t           required = 0;
    for (Mot_List *channel = motion->skin_list; channel != nullptr; channel = channel->next) {
        if (channel->type != MOTION_KEY_SKIN_WEIGHTED && channel->type != MOTION_KEY_SKIN_AVERAGED) {
            continue;
        }
        if (channel->frame < 0 || static_cast<std::size_t>(channel->frame) >= frames.size()) {
            return false;
        }
        const auto index = static_cast<std::size_t>(channel->frame);
        auto      *target = frames[index];
        if (seen[index] || target->visual == nullptr) {
            continue;
        }
        seen[index] = true;
        auto *mesh = static_cast<mgCVisualMDT *>(target->visual);
        if (mesh->vertex_num < 0 || mesh->normal_num < 0 ||
            (mesh->vertex_num > 0 && mesh->vertex == nullptr) ||
            (mesh->normal_num > 0 && mesh->normal == nullptr)) {
            return false;
        }
        const auto count = static_cast<std::size_t>(mesh->vertex_num) + static_cast<std::size_t>(mesh->normal_num);
        if (count > std::numeric_limits<std::size_t>::max() - required) {
            return false;
        }
        required += count;
        copies.push_back({index, mesh});
    }
    if (required >= dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128)) {
        return false;
    }
    frame_info = frame_info.first(static_cast<std::size_t>(frame_num));
    std::ranges::fill(frame_info, tagFRAME_INF{});
    for (std::size_t index = 0; index < frames.size(); ++index) {
        auto      &info = frame_info[index];
        const auto parent = std::ranges::find(frames, frames[index]->parent);
        info.parent = parent == frames.end() ? -1 : static_cast<s32>(parent - frames.begin());
    }
    for (const auto &copy : copies) {
        auto &info = frame_info[copy.index];
        auto &mesh = *copy.mesh;
        if (mesh.vertex_num > 0) {
            info.base_vertices = dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(mesh.vertex_num));
            if (info.base_vertices == nullptr) {
                return false;
            }
            std::memcpy(info.base_vertices, mesh.vertex, static_cast<std::size_t>(mesh.vertex_num) * sizeof(sceVu0FVECTOR));
        }
        if (mesh.normal_num > 0) {
            info.base_normals = dc2::memory::NewArray<sceVu0FVECTOR>(*memory, static_cast<std::size_t>(mesh.normal_num));
            if (info.base_normals == nullptr) {
                return false;
            }
            std::memcpy(info.base_normals, mesh.normal, static_cast<std::size_t>(mesh.normal_num) * sizeof(sceVu0FVECTOR));
        }
        info.vertex_count = static_cast<u32>(mesh.vertex_num);
        info.normal_count = static_cast<u32>(mesh.normal_num);
    }
    motion->frame_info_view = frame_info;
    return true;
}
