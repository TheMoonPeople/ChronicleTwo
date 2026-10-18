#include "common.h"

#include <array>
#include <cmath>
#include <cstring>
#include <numbers>
#include <optional>
#include <string>
#include <utility>
#include <vector>

#include "automap.hpp"
#include "collision.hpp"
#include "funcpoint.hpp"
#include "map.hpp"
#include "mapinfo.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "mdslist.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "scene_documents.hpp"
#include "water.hpp"

namespace {

/**
 * Gives the number of quadwords that hold a byte count.
 */
u32 Quadwords(u32 bytes) {
    return (bytes & 0xF) != 0 ? (bytes >> 4) + 1 : bytes >> 4;
}

/**
 * Function point that FUNC_NAME and FUNC_POS of a scene configuration change. Retail keeps it in a
 * file static that LoadCfgFile does not reset, so a configuration continues from the map's last point.
 */
CFuncPoint *current_func_point = nullptr;

/**
 * Sets a function point's transform and moves event trigger bounds as FUNC_POS does.
 */
void ApplyFuncPosition(CFuncPoint &point, const std::array<float, 9> &transform) {
    float pos[4] = {transform[0], transform[1], transform[2], 1.0f};
    float rot[4] = {transform[3], transform[4], transform[5], 0.0f};
    float scale[4] = {transform[6], transform[7], transform[8], 0.0f};
    point.SetPosition(pos);
    rot[0] = mgAngleLimit(rot[0]);
    rot[1] = mgAngleLimit(rot[1]);
    rot[2] = mgAngleLimit(rot[2]);
    point.SetRotation(rot);
    point.SetScale(scale);
    if (point.type != FUNC_POINT_EVENT) {
        return;
    }
    auto &event = point.event;
    if ((event.flag & FUNC_EVENT_LADDER_TOP) != 0 || (event.flag & FUNC_EVENT_LADDER_BOTTOM) != 0) {
        if (scale[0] <= 1.1f && scale[1] <= 1.1f && scale[2] <= 1.1f) {
            scale[0] = scale[1] = scale[2] = 25.0f;
        }
    } else if ((event.flag & FUNC_EVENT_TREASURE_BOX) != 0) {
        scale[0] = scale[1] = scale[2] = 20.0f;
    } else {
        const int scale_y = static_cast<int>(0.1f + scale[1]);
        const int scale_z = static_cast<int>(0.1f + scale[2]);
        const int scale_x = static_cast<int>(0.1f + scale[0]);
        if (scale_x == 1 && scale_y == 1 && scale_z == 1) {
            scale[0] = scale[1] = scale[2] = 15.0f;
        }
    }
    point.SetScale(scale);
    float offset[4] = {};
    if ((event.flag & FUNC_EVENT_DOOR) != 0) {
        offset[0] = -2.0f;
        offset[2] = -12.0f;
    }
    float matrix[4][4];
    mgUnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, rot[1]);
    sceVu0ApplyMatrix(offset, matrix, offset);
    mgAddVector(pos, offset);
    point.SetPosition(pos);
}

/**
 * Builds the part definitions, placed parts, fixed cameras and function points of one map script.
 */
class SceneMapLoader {
public:
    /**
     * Prepares a load into a map, its memory and the add-map mode.
     */
    SceneMapLoader(CMap &target, mgCMemory &arena, bool adding) : map(target), memory(arena), add_mode(adding) {}

    /**
     * Applies a document in the order the map script runs.
     */
    void Apply(const SceneMapDocument &document) {
        for (const auto &part : document.parts) {
            Part(part);
        }
        for (const auto &placement : document.placements) {
            Placement(placement);
        }
        if (document.camera_count) {
            Cameras(*document.camera_count, document.cameras);
        }
        if (document.func_points) {
            current_parts = nullptr;
            FuncPoints(*document.func_points, false);
        }
    }

private:
    /**
     * Allocates quadwords with the two quadwords of slack the map's placement news take.
     */
    u_long128 *Object(std::size_t bytes) { return memory.Alloc(static_cast<int>(Quadwords(static_cast<u32>(bytes)) + 2)); }

    /**
     * Keeps a copy of game text in the map's memory.
     */
    char *Copy(const std::string &text) {
        auto *copy = reinterpret_cast<char *>(memory.Alloc(static_cast<int>(Quadwords(static_cast<u32>(text.size() + 1)))));
        if (copy != nullptr) {
            std::strcpy(copy, text.c_str());
        }
        return copy;
    }

    /**
     * Copies optional game text with mgCopyString, as the animation names are copied.
     */
    char *CopyString(const SceneText &text) {
        if (!text) {
            return nullptr;
        }
        std::string copy = *text;
        return mgCopyString(copy.data(), &memory);
    }

    /**
     * Builds one part definition as PARTS ... PARTS_END do.
     */
    void Part(const ScenePart &part) {
        current_parts = new (Object(sizeof(CList<CMapParts>))) CList<CMapParts>;
        CMapParts  *parts = current_parts->pGetData();
        std::string name = part.name.value_or(std::string{});
        parts->SetName(part.name ? name.data() : nullptr);
        parts->SetPartsName(part.name ? name.data() : nullptr);
        if (part.far_clip) {
            parts->far_dist = part.far_clip->first;
            parts->fade = part.far_clip->second;
        }
        if (part.light_flag) {
            parts->no_light = (*part.light_flag)[0];
            parts->no_plight = (*part.light_flag)[1];
        }
        if (part.move_flag) {
            const auto &flags = *part.move_flag;
            parts->move_flag = 0;
            parts->move_flag |= flags[0] != 0 ? AUTOMAP_WALL_NEG_X : 0;
            parts->move_flag |= flags[1] != 0 ? AUTOMAP_WALL_NEG_Z : 0;
            parts->move_flag |= flags[2] != 0 ? AUTOMAP_WALL_POS_X : 0;
            parts->move_flag |= flags[3] != 0 ? AUTOMAP_WALL_POS_Z : 0;
        }
        for (const auto &piece : part.pieces) {
            Piece(piece);
        }
        if (part.func_points) {
            FuncPoints(*part.func_points, true);
        }
        map.AddParts(current_parts);
        current_parts->pGetData()->CreateBoundBox();
    }

    /**
     * Builds one piece of the current part as PIECE ... PIECE_END do.
     */
    void Piece(const ScenePiece &source) {
        if (!source.model) {
            return;
        }
        // The skip bit is never set, but a skipped piece leaves the previous one current.
        if ((map.piece_load_skip & 1) != 0) {
            return;
        }
        current_piece = new (Object(sizeof(CList<CMapPiece>))) CList<CMapPiece>;
        CMapPiece *piece = current_piece->pGetData();
        char      *name = Copy(*source.model);
        piece->SetName(name);
        piece->show = source.show.value_or(1);
        if (CMdsInfo *mds = map.SearchMDS(name)) {
            piece->AssignMds(mds);
        }
        if (source.name && *source.name) {
            piece->SetName(Copy(**source.name));
        }
        float vector[4] = {};
        if (source.position) {
            std::memcpy(vector, source.position->data(), sizeof(float) * 3);
            piece->SetPosition(vector);
        }
        if (source.rotation) {
            std::memcpy(vector, source.rotation->data(), sizeof(float) * 3);
            piece->SetRotation(vector);
        }
        if (source.scale) {
            std::memcpy(vector, source.scale->data(), sizeof(float) * 3);
            piece->SetScale(vector);
        }
        if (source.material_count) {
            Materials(*piece, *source.material_count, source.materials);
        }
        if (source.col_type) {
            piece->col_type = *source.col_type;
            if (source.col_param) {
                piece->col_param = *source.col_param;
            }
        }
        if (source.time) {
            piece->SetTimeBand((*source.time)[0], (*source.time)[1]);
        }
        current_parts->pGetData()->AddPiece(current_piece);
    }

    /**
     * Gives a piece its material colour list as PIECE_MATERIAL_START and PIECE_MATERIAL do.
     */
    void Materials(CMapPiece &piece, int count, const std::vector<SceneMaterial> &materials) {
        if (count > 0) {
            auto *table = new (Object(count * sizeof(PieceMaterial))) PieceMaterial[count];
            if (table != nullptr) {
                piece.SetMaterial(table, count);
            }
        }
        int index = 0;
        for (const auto &entry : materials) {
            PieceMaterial *slot = piece.GetMaterial(index++);
            mgCFrame      *frame = piece.GetFrame();
            if (slot == nullptr || !entry.frame || frame == nullptr) {
                continue;
            }
            std::string name = *entry.frame;
            slot->frame = frame->SearchFrame(name.data());
            if (slot->frame == nullptr) {
                continue;
            }
            slot->material_no = entry.material_no;
            slot->material = slot->frame->GetMaterial(slot->material_no);
            for (int channel = 0; channel < 4; ++channel) {
                slot->color[channel] = entry.color[channel];
            }
            slot->color_no = entry.color_no;
        }
    }

    /**
     * Adds a function-point block to the current part or to the map, as FUNC_POINT ... FUNC_POINT_END do.
     */
    void FuncPoints(const std::vector<SceneFuncPoint> &points, bool part_points) {
        for (const auto &point : points) {
            FuncPoint(point, part_points);
        }
        CFuncPointMngr *manager = nullptr;
        if (part_points) {
            if (current_parts == nullptr) {
                return;
            }
            manager = &current_parts->pGetData()->func_point_mngr;
        } else {
            manager = &map.func_point;
        }
        manager->UpdateStatus();
    }

    /**
     * Gives the function-point kind a FUNC_DATA word names, or nothing for an unknown word.
     */
    static std::optional<int> Kind(const SceneText &word, CMap &map) {
        if (!word) {
            return std::nullopt;
        }
        static constexpr std::pair<const char *, int> kinds[] = {
            {"effect", FUNC_POINT_EFFECT},
            {"fire",   FUNC_POINT_FIRE  },
            {"flare",  FUNC_POINT_FLARE },
            {"plight", FUNC_POINT_PLIGHT},
            {"anime",  FUNC_POINT_ANIME },
            {"invent", FUNC_POINT_INVENT},
            {"event",  FUNC_POINT_EVENT },
            {"sound",  FUNC_POINT_SOUND },
            {"pos",    FUNC_POINT_POS   },
        };
        for (const auto &[name, kind] : kinds) {
            if (*word == name) {
                if (kind == FUNC_POINT_EVENT) {
                    map.parts_event = true;
                }
                return kind;
            }
        }
        return std::nullopt;
    }

    /**
     * Builds one function point as FUNC_DATA ... FUNC_DATA_END do.
     */
    void FuncPoint(const SceneFuncPoint &source, bool part_points) {
        CFuncPoint *point = nullptr;
        if (const auto kind = Kind(source.type, map)) {
            if (!part_points) {
                point = map.func_point.Add(*kind, &memory);
            } else if (current_parts != nullptr) {
                point = current_parts->pGetData()->func_point_mngr.Add(*kind, &memory);
            }
            if (point != nullptr) {
                point->type = *kind;
                point->enable = source.enable;
            }
        }
        current_func_point = point;
        if (point != nullptr) {
            FuncPointData(*point, source);
        }
        current_func_point = nullptr;
    }

    /**
     * Applies the data rows of one function point.
     */
    void FuncPointData(CFuncPoint &point, const SceneFuncPoint &source) {
        if (source.name && *source.name) {
            point.name = Copy(**source.name);
        }
        if (source.flag) {
            point.flag_no = source.flag->flag_no;
            point.unk_8 = source.flag->unk_8;
            point.start = source.flag->start;
            point.end = source.flag->end;
        }
        if (source.fire) {
            Fire(point, *source.fire);
        }
        if (source.plight) {
            PointLight(point, *source.plight);
        }
        if (source.anime) {
            Anime(point, *source.anime);
        }
        if (source.invent) {
            const auto &invent = *source.invent;
            point.invent.neta_no = invent.neta_no;
            std::memcpy(point.invent.box.min, invent.min.data(), sizeof(float) * 3);
            point.invent.box.min[3] = 1.0f;
            std::memcpy(point.invent.box.max, invent.max.data(), sizeof(float) * 3);
            point.invent.box.max[3] = 1.0f;
            point.invent.unk_24 = invent.unk_24;
            point.invent.range = invent.range;
            point.invent.angle = std::numbers::pi_v<float> * invent.angle_degrees / 180.0f;
        }
        if (source.event) {
            Event(point, *source.event);
        }
        if (source.sound) {
            const auto &sound = *source.sound;
            point.sound.se_no = sound.se_no;
            point.sound.near_dist = sound.near_dist;
            point.sound.far_dist = sound.far_dist;
            point.sound.unk_2c = static_cast<float>(sound.unk_2c);
            point.sound.shape = sound.shape;
            std::memcpy(point.sound.start, sound.start.data(), sizeof(float) * 3);
            std::memcpy(point.sound.end, sound.end.data(), sizeof(float) * 3);
            point.sound.end[3] = 1.0f;
            point.sound.start[3] = 1.0f;
        }
        if (source.effect && *source.effect) {
            char *name = Copy(**source.effect);
            point.effect.name = name;
            const int effect_index = map.SaerchEffectIndex(name);
            if (effect_index >= 0) {
                point.effect.index = effect_index;
                point.frame.SetBound(new (Object(sizeof(mgCFrame::BoundInfo))) mgCFrame::BoundInfo);
            } else {
                point.type = FUNC_POINT_NONE;
            }
        }
        if (source.transform) {
            ApplyFuncPosition(point, *source.transform);
        }
    }

    /**
     * Sets a fire point's colour and switches as FUNC_FIRE_DATA does.
     */
    static void Fire(CFuncPoint &point, const SceneFuncFire &fire) {
        float color[4] = {fire.color[0], fire.color[1], fire.color[2], 0.0f};
        if (0.0f == color[2] + (color[0] + color[1])) {
            color[0] = 128.0f;
            color[1] = 90.0f;
            color[2] = 38.0f;
        } else {
            sceVu0ScaleVector(color, color, 128.0f);
        }
        color[3] = 128.0f;
        std::memcpy(point.fire.color, color, sizeof(color));
        point.fire.effect_off = fire.effect == 0 ? 1 : 0;
        if (fire.heat_haze) {
            point.fire.heat_haze = *fire.heat_haze;
        }
        if (fire.cast_light) {
            point.fire.cast_light = *fire.cast_light;
        }
    }

    /**
     * Sets a point light's strength, colour and options as FUNC_PLIGHT_DATA does.
     */
    static void PointLight(CFuncPoint &point, const SceneFuncPlight &light) {
        point.plight.power = light.power;
        float color[4] = {light.color[0], light.color[1], light.color[2], 0.0f};
        sceVu0ScaleVector(color, color, 0.5f);
        color[3] = 0.0f;
        float largest = 0.0f;
        if (color[0] > color[1]) {
            largest = color[0] > color[2] ? color[0] : color[2];
        } else {
            largest = color[1] > color[2] ? color[1] : color[2];
        }
        point.plight.range = 0.25 * (static_cast<double>(point.plight.power) * std::sqrt(static_cast<double>(largest)));
        std::memcpy(point.plight.color, color, sizeof(color));
        point.plight.light_type = light.light_type;
        if (light.light_chara) {
            point.plight.light_chara = *light.light_chara;
        }
        if (light.unk_40) {
            point.plight.unk_40 = *light.unk_40;
        }
        if (light.unk_44) {
            point.plight.unk_44 = *light.unk_44;
        }
        if (light.no_map_light) {
            point.plight.no_map_light = *light.no_map_light;
        }
        if (light.flicker_type) {
            point.plight.flicker_type = *light.flicker_type;
        }
        if (light.flicker_depth) {
            point.plight.flicker_depth = *light.flicker_depth;
        }
        if (light.flicker_period) {
            point.plight.flicker_period = *light.flicker_period;
        }
    }

    /**
     * Sets an animation point's target and parameters as FUNC_ANIME_DATA does.
     */
    void Anime(CFuncPoint &point, const SceneFuncAnime &anime) {
        point.anime.parts_name = CopyString(anime.parts_name);
        point.anime.piece_name = CopyString(anime.piece_name);
        point.anime.frame_name = CopyString(anime.frame_name);
        point.anime.kind = anime.kind;
        point.anime.mode = anime.mode;
        std::memcpy(point.anime.param, anime.param.data(), sizeof(float) * 3);
        std::memcpy(point.anime.speed, anime.speed.data(), sizeof(float) * 3);
        std::memcpy(point.anime.end, anime.end.data(), sizeof(float) * 3);
        point.anime.uniform = 0;
        if (anime.uniform) {
            point.anime.uniform = static_cast<s16>(*anime.uniform);
        }
        if (anime.piece_space) {
            point.anime.piece_space = static_cast<s16>(*anime.piece_space);
        }
    }

    /**
     * Sets an event point's identifiers and flags as FUNC_EVENT_DATA does.
     */
    static void Event(CFuncPoint &point, const SceneFuncEvent &source) {
        auto &event = point.event;
        event.event_no = source.event_no;
        event.point_no = source.point_no;
        event.arg1 = source.arg1;
        event.arg2 = source.arg2;
        event.arg3 = source.arg3;
        u32 kind = 0;
        if (source.kind) {
            const std::string &word = *source.kind;
            if (word == "door") {
                kind = FUNC_EVENT_UNK_100 | FUNC_EVENT_DOOR | FUNC_EVENT_ACTION;
            } else if (word == "ed_door") {
                kind = FUNC_EVENT_UNK_100 | FUNC_EVENT_ED_DOOR | FUNC_EVENT_DOOR | FUNC_EVENT_ACTION;
            } else if (word == "lddr_b") {
                kind = FUNC_EVENT_LADDER_BOTTOM;
                event.event_no = 1;
            } else if (word == "lddr_t") {
                kind = FUNC_EVENT_LADDER_TOP;
                event.event_no = 1;
            } else if (word == "close_door") {
                kind = FUNC_EVENT_CLOSE_DOOR | FUNC_EVENT_DOOR | FUNC_EVENT_ACTION;
            } else if (word == "t_box") {
                kind = FUNC_EVENT_TREASURE_BOX | FUNC_EVENT_ACTION;
                event.event_no = 1;
            } else if (word == "book") {
                kind = FUNC_EVENT_BOOK | FUNC_EVENT_ACTION;
            }
        }
        event.flag = kind;
        if (source.target && *source.target) {
            const std::string &target = **source.target;
            const std::size_t  length = target.size() < sizeof(event.target) ? target.size() : sizeof(event.target) - 1;
            std::memcpy(event.target, target.data(), length);
            event.target[length] = 0;
        }
        if (source.action && *source.action != 0) {
            event.flag |= FUNC_EVENT_ACTION;
        }
        if (source.item && *source.item != 0) {
            event.flag |= FUNC_EVENT_ITEM;
        }
        if (source.unk_100) {
            if (*source.unk_100 != 0) {
                event.flag |= FUNC_EVENT_UNK_100;
            } else {
                event.flag &= ~FUNC_EVENT_UNK_100;
            }
        }
    }

    /**
     * Builds the fixed-camera table as CAMERA_INFO ... CAMERA_INFO_END do; an add-map has none.
     */
    void Cameras(int count, const std::vector<SceneCamera> &cameras) {
        if (add_mode || count < 0) {
            return;
        }
        map.SetCameraInfoTable(new (Object(count * sizeof(CCameraInfo))) CCameraInfo[count], count);
        int index = 0;
        for (const auto &camera : cameras) {
            if (CCameraInfo *info = map.GetCameraInfo(index)) {
                Camera(*info, camera);
            }
            ++index;
        }
    }

    /**
     * Fills one fixed camera as FIX_CAMERA ... FIX_CAMERA_END do.
     */
    void Camera(CCameraInfo &info, const SceneCamera &camera) {
        if (camera.position) {
            std::memcpy(info.pos[0], camera.position->data(), sizeof(float) * 3);
        }
        for (const auto &[index, position] : camera.positions) {
            if (index < 0 || index >= CAMERA_INFO_POS_MAX) {
                continue;
            }
            std::memcpy(info.pos[index], position.data(), sizeof(float) * 3);
            info.pos_num = index + 1 < info.pos_num ? info.pos_num : index + 1;
        }
        for (const auto &[draw_index, group, unk_4] : camera.draw_groups) {
            CCameraDrawInfo *draw = info.GetDrawInfo(draw_index);
            if (draw == nullptr || !group || group->empty()) {
                continue;
            }
            std::string name = *group;
            draw->unk_4 = unk_4;
            draw->group_no = map.SearchPartsGroupNo(name.data());
        }
        int rect_index = 0;
        for (const auto &rect : camera.rects) {
            if (!rect.shape) {
                continue;
            }
            auto       *frame = new (Object(sizeof(CColFrame))) CColFrame;
            CCollision *collision = nullptr;
            if (*rect.shape == "box") {
                collision = new (Object(sizeof(CCollision))) CCollision;
                std::memcpy(collision->bbox.min, rect.min.data(), sizeof(float) * 3);
                collision->bbox.min[3] = 1.0f;
                std::memcpy(collision->bbox.max, rect.max.data(), sizeof(float) * 3);
                collision->bbox.max[3] = 1.0f;
                float vector[4] = {};
                if (frame != nullptr && rect.position) {
                    std::memcpy(vector, rect.position->data(), sizeof(float) * 3);
                    frame->SetPosition(vector);
                }
                if (frame != nullptr && rect.rotation) {
                    std::memcpy(vector, rect.rotation->data(), sizeof(float) * 3);
                    frame->SetRotation(vector);
                }
                if (frame != nullptr && rect.scale) {
                    std::memcpy(vector, rect.scale->data(), sizeof(float) * 3);
                    frame->SetScale(vector);
                }
            }
            if (frame != nullptr) {
                frame->SetCollision(collision);
            }
            if (rect_index < info.rect_num) {
                info.rect[rect_index++] = frame;
            }
        }
    }

    /**
     * Places one part definition as MAP_PARTS ... MAP_PARTS_END do.
     */
    void Placement(const ScenePlacement &placement) {
        current_parts = nullptr;
        if (!placement.name) {
            return;
        }
        float       position[4] = {};
        float       rotation[4] = {};
        float       scale[4] = {1.0f, 1.0f, 1.0f, 0.0f};
        std::string definition;
        std::string group;
        if (placement.definition && *placement.definition) {
            definition = **placement.definition;
        }
        if (placement.group && *placement.group) {
            group = **placement.group;
        }
        if (placement.position) {
            std::memcpy(position, placement.position->data(), sizeof(float) * 3);
        }
        if (placement.rotation) {
            std::memcpy(rotation, placement.rotation->data(), sizeof(float) * 3);
        }
        if (placement.scale) {
            std::memcpy(scale, placement.scale->data(), sizeof(float) * 3);
        }
        CMapParts *parts = map.PlaceParts(definition.data(), position, rotation, scale, &memory);
        if (parts == nullptr) {
            return;
        }
        std::string name = *placement.name;
        parts->SetName(name.data());
        if (placement.far_clip && placement.far_clip->first > 0.0f) {
            parts->far_dist = placement.far_clip->first;
            parts->fade = placement.far_clip->second;
        }
        parts->show = placement.show.value_or(1);
        if (!group.empty()) {
            parts->group_no = map.AddPartsGroup(group.data(), parts, &memory);
        }
    }

    CMap             &map;                     /**< Map being built. */
    mgCMemory        &memory;                  /**< Memory the map's records come from. */
    bool              add_mode;                /**< Whether the script adds to a map already loaded. */
    CList<CMapParts> *current_parts = nullptr; /**< Part definition being built. */
    CList<CMapPiece> *current_piece = nullptr; /**< Piece being built. */
};

} // namespace

PORT_OVERRIDE void CMap::LoadMapFile(char *script, int /*length*/, mgCMemory *memory, int add_mode) {
    current_func_point = nullptr;
    SetPieceLoadSkip(0);
    if (const auto document = ReadSceneMap(script)) {
        SceneMapLoader(*this, *memory, add_mode != 0).Apply(*document);
    }
}

namespace {

/**
 * Builds the event points of a scene configuration as cfgFUNC_DATA and its tags do.
 */
void ApplyEventPoints(CMap &map, mgCMemory &memory, const std::vector<SceneEventPoint> &points) {
    bool reserved = false;
    for (const auto &source : points) {
        if (!reserved) {
            map.func_point.Reserve(0x40, &memory);
            reserved = true;
        }
        // A word other than "event" leaves the previous point current.
        if (source.type && *source.type == "event") {
            map.parts_event = true;
            current_func_point = map.func_point.AddFromReserve(FUNC_POINT_EVENT);
        }
        CFuncPoint *point = current_func_point;
        if (point == nullptr) {
            continue;
        }
        if (source.name && *source.name) {
            const std::string &name = **source.name;
            auto              *copy = reinterpret_cast<char *>(memory.Alloc(static_cast<int>(Quadwords(static_cast<u32>(name.size() + 1)))));
            if (copy != nullptr) {
                std::strcpy(copy, name.c_str());
            }
            point->name = copy;
        }
        if (source.point_no) {
            point->event.point_no = *source.point_no;
            if (source.mode) {
                point->event.event_no = 0;
                if (*source.mode) {
                    const std::string &mode = **source.mode;
                    if (mode == "every") {
                        point->event.flag = FUNC_EVENT_EVERY;
                    } else if (mode == "action") {
                        point->event.flag = FUNC_EVENT_ACTION;
                    } else if (mode == "check") {
                        point->event.flag = FUNC_EVENT_ACTION;
                        point->event.event_no = 1;
                    } else if (mode == "item") {
                        point->event.flag = FUNC_EVENT_ITEM;
                        point->event.event_no = 1;
                    } else if (mode == "invent") {
                        point->event.flag = FUNC_EVENT_ACTION;
                        point->event.event_no = 2;
                    }
                }
            }
        }
        if (source.transform) {
            ApplyFuncPosition(*point, *source.transform);
        }
    }
}

/**
 * Builds the water surfaces and their drawing records as the WATER tags do.
 */
void ApplyWater(CMap &map, mgCMemory &memory, const SceneConfigDocument &config) {
    if (config.surface_count) {
        map.water_surface_num = *config.surface_count;
        if (map.water_surface_num > 0) {
            map.water_surface = new (memory.Alloc(static_cast<int>(Quadwords(map.water_surface_num * sizeof(CWaterFrame *)) + 2))) CWaterFrame *[map.water_surface_num];
            if (map.water_surface == nullptr) {
                map.water_surface_num = 0;
            }
            for (int index = 0; index < map.water_surface_num; ++index) {
                map.water_surface[index] = nullptr;
            }
        }
    }
    int surface_index = 0;
    for (const auto &surface : config.surfaces) {
        CWaterFrame *water = nullptr;
        if (surface.vertex) {
            const auto &[counts, corners] = *surface.vertex;
            float corner0[4] = {corners[0], corners[1], corners[2], 1.0f};
            float corner1[4] = {corners[3], corners[4], corners[5], 1.0f};
            water = CreateWaterFrame(counts[0], counts[1], corner0, corner1, &memory);
        }
        if (water != nullptr && surface.position) {
            float pos[4] = {(*surface.position)[0], (*surface.position)[1], (*surface.position)[2], 0.0f};
            water->SetPosition(pos);
        }
        // Retail dereferences a surface without a grid here.
        if (water != nullptr && surface.param) {
            water->SetParam((*surface.param)[0], (*surface.param)[1], (*surface.param)[2], (*surface.param)[3]);
        }
        if (surface_index < map.water_surface_num) {
            map.water_surface[surface_index++] = water;
        }
    }
    if (config.draw_count) {
        map.water_num = *config.draw_count;
        if (map.water_num >= 0) {
            map.water = new (memory.Alloc(static_cast<int>(Quadwords(map.water_num * sizeof(CMapWater)) + 2))) CMapWater[map.water_num];
            for (int index = 0; index < map.water_num; ++index) {
                map.water[index].Initialize();
                map.water[index].parts_max = MAP_WATER_PARTS_MAX;
                map.water[index].parts = new (memory.Alloc(static_cast<int>(Quadwords(map.water[index].parts_max * sizeof(CMapParts *)) + 2))) CMapParts *[map.water[index].parts_max];
                map.water[index].Clear();
            }
        }
    }
    for (const auto &draw : config.draws) {
        if (draw.surface < 0 || draw.surface >= map.water_surface_num) {
            continue;
        }
        CMapWater *slot = nullptr;
        for (int index = 0; index < map.water_num; ++index) {
            if (map.water[index].frame == nullptr) {
                slot = &map.water[index];
                break;
            }
        }
        if (slot == nullptr) {
            continue;
        }
        slot->frame = map.water_surface[draw.surface];
        if (draw.target && !draw.target->empty()) {
            std::string target = *draw.target;
            if (target.starts_with("#follow")) {
                // "#follow" names the follow slots with three digits; retail reads them unchecked.
                for (std::size_t digit = 0; digit < 3; ++digit) {
                    slot->follow[digit] = 7 + digit < target.size() ? target[7 + digit] - '0' : -'0';
                }
            } else {
                slot->parts_name = mgCopyString(target.data(), &memory);
            }
        }
        if (draw.position) {
            float pos[4] = {(*draw.position)[0], (*draw.position)[1], (*draw.position)[2], 0.0f};
            slot->SetPosition(pos);
        }
    }
}

} // namespace

PORT_OVERRIDE void CMap::LoadCfgFile(char *script, int /*length*/, mgCMemory *memory) {
    const auto config = ReadSceneConfig(script);
    if (!config) {
        return;
    }
    for (const auto &rect : config->draw_off_rects) {
        mgVu0FBOX first{};
        mgVu0FBOX second{};
        std::memcpy(first.min, rect.data(), sizeof(float) * 3);
        std::memcpy(first.max, &rect[3], sizeof(float) * 3);
        std::memcpy(second.min, &rect[6], sizeof(float) * 3);
        std::memcpy(second.max, &rect[9], sizeof(float) * 3);
        CreateDrawRect(memory, &first, &second, false);
    }
    for (const auto &corners : config->occlusion_planes) {
        float plane[4][4];
        for (int corner = 0; corner < 4; ++corner) {
            plane[corner][0] = corners[(corner * 3) + 0];
            plane[corner][1] = corners[(corner * 3) + 1];
            plane[corner][2] = corners[(corner * 3) + 2];
            plane[corner][3] = 1.0f;
        }
        CreateOcclusion(plane);
    }
    ApplyWater(*this, *memory, *config);
    ApplyEventPoints(*this, *memory, config->event_points);
}
