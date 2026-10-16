#include "common.h"

#include <cstdio>
#include <cstring>

#include "collision.hpp"
#include "dataread_port.hpp"
#include "gameutil.hpp"
#include "mg_math.hpp"
#include "platform/model_assets.hpp"

PORT_OVERRIDE void SetMotionTime(mgCFrame *root, tagMOTION_TYPE *motion, float time, mgCCamera *camera) {
    for (auto *channel = motion->motion_list; channel;) {
        if (!channel->key_count) {channel=channel->next;continue;}
        if (model_assets::ApplyChannel(*root, time, time, 0, *channel)) {
            channel = channel->next;
        } else {
            channel = MotionProc(root, time, channel, camera);
        }
    }
}

PORT_OVERRIDE void ChangeMotion(mgCFrame *root, tagMOTION_TYPE *motion, unsigned int from_frame,
                                unsigned int to_frame, float blend, mgCCamera *camera) {
    for (auto *channel = motion->motion_list; channel;) {
        if (!channel->key_count) {channel=channel->next;continue;}
        if (model_assets::ApplyChannel(*root, static_cast<float>(from_frame), static_cast<float>(to_frame), blend, *channel)) {
            channel = channel->next;
        } else {
            channel = MotionProc(root, from_frame, to_frame, blend, channel, camera);
        }
    }
}

PORT_OVERRIDE int CreateAnimeDataEX(tagMOTION_TYPE *motion, mgCMemory *memory, MOTION_FILE_INFO *info) {
    if (!motion || !memory || !info) {
        return false;
    }
    std::string error;
    const void *bytes = info[1].data ? info[1].data : info[0].data ? info[0].data
                                                                   : info[2].data;
    const auto  path = DataReadBufferPath(bytes);
    const auto  animation = info[1].data ? std::optional<std::size_t>{0} : std::nullopt;
    const auto  bind = info[0].data ? std::optional<std::size_t>{0} : std::nullopt;
    const auto  weights = info[2].data ? std::optional<std::size_t>{0} : std::nullopt;
    if (!path) {
        std::fprintf(stderr, "animation: direct glTF path required\n");
        return false;
    }
    const bool loaded = model_assets::LoadAnimation(std::filesystem::path(*path), *motion, *memory, animation, bind, weights, std::nullopt, error);
    if (loaded) {
        return true;
    }
    std::fprintf(stderr, "animation: %s\n", error.c_str());
    return false;
}

PORT_OVERRIDE void ChangeWeight(Mot_List *list, mgCMemory *memory, u8 *data, int frame_no,
                                tagFRAME_INF *frame_info, mgCVisualMDT *mesh, mgCFrame *frame,
                                mgCFrame *source_frame) {
    if (!list || !memory || !data || !frame || !source_frame || !frame_info) {
        return;
    }
    Mot_List *previous = list;
    for (auto *channel = list; channel;) {
        auto *next = channel->next;
        if (channel->frame == frame_no) {
            previous->next = next;
        } else {
            previous = channel;
        }
        channel = next;
    }
    try {
        tagMOTION_TYPE replacement{};
        std::string    error;
        const auto     path = DataReadBufferPath(data);
        if (!path) {
            std::fprintf(stderr, "animation: direct glTF weight path required\n");
            return;
        }
        const bool loaded = model_assets::LoadAnimation(std::filesystem::path(*path), replacement, *memory, std::nullopt, std::nullopt, 0, std::nullopt, error);
        if (!loaded) {
            throw std::runtime_error(error);
        }
        auto *head = replacement.skin_list;
        previous->next = head;
        for (auto *channel = head; channel; channel = channel->next) {
            channel->frame = frame_no;
            auto *target = source_frame->GetFrame(channel->target);
            channel->target = target ? frame->SearchFrameID(target->name) : -1;
        }
        if (!mesh) {
            return;
        }
        auto &info = frame_info[frame_no];
        info.vertex_count = mesh->vertex_num;
        info.normal_count = mesh->normal_num;
        info.base_vertices = reinterpret_cast<sceVu0FVECTOR *>(memory->Alloc(mesh->vertex_num + 1));
        info.base_normals = reinterpret_cast<sceVu0FVECTOR *>(memory->Alloc(mesh->normal_num + 1));
        info.vertex_refs = reinterpret_cast<FrameLinkRecord *>(memory->Alloc((mesh->vertex_num * sizeof(FrameLinkRecord) + 15) / 16 + 1));
        std::memcpy(info.base_vertices, mesh->vertex, mesh->vertex_num * sizeof(sceVu0FVECTOR));
        std::memcpy(info.base_normals, mesh->normal, mesh->normal_num * sizeof(sceVu0FVECTOR));
        std::memset(info.vertex_refs, 0, mesh->vertex_num * sizeof(FrameLinkRecord));
        for (auto *group = mesh->face_group; group; group = group->next) {
            for (auto *face = group->face; face; face = face->next) {
                if (face->type & MG_FACE_NO_NORMAL) {
                    continue;
                }
                for (int corner = 0; corner < face->vertex_num; ++corner) {
                    const auto *indices = face->index + corner * face->index_stride;
                    auto       &record = info.vertex_refs[indices[0]];
                    if (record.count < 11) {
                        record.link[record.count++] = indices[1];
                    }
                }
            }
        }
    } catch (const std::exception &error) {
        std::fprintf(stderr, "animation: %s\n", error.what());
    }
}

PORT_OVERRIDE int CheckHitVertical(CollisionInfo *collision, float *position, float dy, float *hit, int mask) {
    if (collision == nullptr || collision->polys == nullptr || collision->count == 0) {
        return -1;
    }
    // Translation changes only y, including for callers using a non-unit w.
    float end[4] = {position[0], position[1] + dy, position[2], position[3]};
    int   best = -1;
    float best_y = 0.0f;
    for (int i = 0; i < collision->count; ++i) {
        CCPoly &poly = collision->polys[i];
        if ((poly.ignore_mask & mask) ||
            !mgIntersectionPoint_line_poly3(position, end, poly.vertex[0], poly.vertex[1],
                                            poly.vertex[2], poly.normal, hit)) {
            continue;
        }
        const bool nearer = dy <= 0.0f
                                ? !(position[1] <= hit[1]) && (best < 0 || best_y <= hit[1])
                                : position[1] < hit[1] && (best < 0 || !(best_y < hit[1]));
        if (nearer) {
            best = i;
            best_y = hit[1];
        }
    }
    if (best >= 0) {
        hit[1] = best_y;
    }
    return best;
}
