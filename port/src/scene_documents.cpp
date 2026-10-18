// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "scene_documents.hpp"

namespace {

using native_config::Json;

/**
 * Reads a required three-number member.
 */
SceneVec3 Vec3(const Json &object, const char *key) {
    return native_config::Floats<3>(object, key);
}

/**
 * Reads an optional three-number member.
 */
std::optional<SceneVec3> OptionalVec3(const Json &object, const char *key) {
    return object.contains(key) ? std::optional<SceneVec3>(Vec3(object, key)) : std::nullopt;
}

/**
 * Reads a member holding game text or null.
 */
SceneText Text(const Json &object, const char *key) {
    return native_config::GameText(native_config::At(object, key));
}

/**
 * Reads an optional member holding game text or null.
 */
std::optional<SceneText> OptionalText(const Json &object, const char *key) {
    return object.contains(key) ? std::optional<SceneText>(Text(object, key)) : std::nullopt;
}

/**
 * Reads a {"distance", "fade"} far clip.
 */
std::optional<std::pair<float, int> > FarClip(const Json &object, const char *key) {
    if (!object.contains(key)) {
        return std::nullopt;
    }
    const auto &clip = native_config::At(object, key);
    return std::pair{native_config::Float(clip, "distance"), native_config::Int(clip, "fade")};
}

/**
 * Reads a {"position", "rotation", "scale"} transform as nine floats.
 */
std::optional<std::array<float, 9> > Transform(const Json &object, const char *key) {
    if (!object.contains(key)) {
        return std::nullopt;
    }
    const auto          &value = native_config::At(object, key);
    std::array<float, 9> out{};
    const char          *keys[] = {"position", "rotation", "scale"};
    for (int part = 0; part < 3; ++part) {
        const auto vec = Vec3(value, keys[part]);
        for (int axis = 0; axis < 3; ++axis) {
            out[(part * 3) + axis] = vec[axis];
        }
    }
    return out;
}

/**
 * Parses one lighting set.
 */
SceneLightSet LightSet(const Json &set) {
    using namespace native_config;
    SceneLightSet out{.index = Int(set, "index"), .fov = set.contains("fov"), .bg_color = OptionalVec3(set, "bg_color"), .bg_color2 = OptionalVec3(set, "bg_color2"), .ambient = OptionalVec3(set, "ambient"), .lights = {}, .point_lights = {}, .fog_enable = OptionalInt(set, "fog_enable"), .fog = std::nullopt};
    for (const auto &light : Array(set, "lights")) {
        out.lights.push_back({.index = Int(light, "index"), .direction = OptionalVec3(light, "direction"), .color = OptionalVec3(light, "color")});
    }
    for (const auto &light : Array(set, "point_lights")) {
        out.point_lights.push_back({.index = Int(light, "index"), .power = Float(light, "power"), .position = Vec3(light, "position"), .color = Vec3(light, "color")});
    }
    if (set.contains("fog")) {
        const auto &fog = At(set, "fog");
        SceneFog    parsed{.near_dist = Float(fog, "near"), .far_dist = Float(fog, "far"), .color = std::nullopt, .far_value = OptionalFloat(fog, "far_value"), .near_value = OptionalFloat(fog, "near_value")};
        if (fog.contains("color")) {
            parsed.color = Ints<3>(fog, "color");
        }
        out.fog = parsed;
    }
    return out;
}

/**
 * Parses the map settings.
 */
SceneInfo Info(const Json &info) {
    using namespace native_config;
    SceneInfo out;
    for (const auto &name : Array(info, "texture_packs")) {
        out.texture_packs.push_back(GameText(name));
    }
    for (const auto &name : Array(info, "model_packs")) {
        out.model_packs.push_back(GameText(name));
    }
    out.active_light_set = OptionalInt(info, "active_light_set");
    for (const auto &set : Array(info, "light_sets")) {
        out.light_sets.push_back(LightSet(set));
    }
    out.floor = OptionalFloat(info, "floor");
    out.chara_pos = OptionalVec3(info, "chara_pos");
    out.def_foot = OptionalInt(info, "def_foot");
    if (info.contains("time")) {
        const auto &time = At(info, "time");
        out.time_enable = Int(time, "enable");
        out.time_blend = Int(time, "blend");
        out.fixed_time = OptionalFloat(time, "fixed_time");
        out.fixed_time_enable = OptionalInt(time, "fixed_time_enable");
    }
    out.time_light_num = OptionalInt(info, "time_light_num");
    out.time_cfade = OptionalInt(info, "time_cfade");
    if (info.contains("sky")) {
        const auto &sky = At(info, "sky");
        out.sky_info = Int(sky, "info");
        out.sky_height = Float(sky, "height");
        out.sun_angle_degrees = OptionalFloat(sky, "sun_angle_degrees");
    }
    out.lens_flare = OptionalInt(info, "lens_flare");
    out.all_scissor = OptionalInt(info, "all_scissor");
    if (info.contains("chara_light_adjust")) {
        const auto &adjust = At(info, "chara_light_adjust");
        out.chara_light_adjust = Int(adjust, "mode");
        out.chara_light_value = Vec3(adjust, "value");
    }
    return out;
}

/**
 * Reads x, y and z members with a common prefix as a vector.
 */
SceneVec3 Axes(const Json &object, const std::string &prefix) {
    return {native_config::Float(object, (prefix + "_x").c_str()), native_config::Float(object, (prefix + "_y").c_str()), native_config::Float(object, (prefix + "_z").c_str())};
}

/**
 * Parses one function point.
 */
SceneFuncPoint FuncPoint(const Json &point) {
    using namespace native_config;
    SceneFuncPoint out{.type = Text(point, "type"), .enable = Int(point, "enable"), .name = OptionalText(point, "name"), .flag = std::nullopt, .fire = std::nullopt, .plight = std::nullopt, .anime = std::nullopt, .invent = std::nullopt, .event = std::nullopt, .sound = std::nullopt, .effect = std::nullopt, .transform = Transform(point, "transform")};
    if (point.contains("flag")) {
        const auto &flag = At(point, "flag");
        out.flag = SceneFuncFlag{.flag_no = Int(flag, "flag_no"), .unk_8 = Int(flag, "unk_8"), .start = Float(flag, "start"), .end = Float(flag, "end")};
    }
    if (point.contains("fire")) {
        const auto &fire = At(point, "fire");
        out.fire = SceneFuncFire{
            .color = {Float(fire, "red"), Float(fire, "green"), Float(fire, "blue")},
            .effect = Int(fire, "effect"),
            .heat_haze = OptionalInt(fire, "heat_haze"),
            .cast_light = OptionalInt(fire, "cast_light")
        };
    }
    if (point.contains("plight")) {
        const auto &light = At(point, "plight");
        out.plight = SceneFuncPlight{
            .power = Float(light, "power"), .color = {Float(light, "red"), Float(light, "green"), Float(light, "blue")},
                  .light_type = Int(light, "light_type"), .light_chara = OptionalInt(light, "light_chara"), .unk_40 = OptionalInt(light, "unk_40"), .unk_44 = OptionalInt(light, "unk_44"), .no_map_light = OptionalInt(light, "no_map_light"), .flicker_type = OptionalInt(light, "flicker_type"), .flicker_depth = OptionalFloat(light, "flicker_depth"), .flicker_period = OptionalFloat(light, "flicker_period")
        };
    }
    if (point.contains("anime")) {
        const auto &anime = At(point, "anime");
        out.anime = SceneFuncAnime{.parts_name = Text(anime, "parts_name"), .piece_name = Text(anime, "piece_name"), .frame_name = Text(anime, "frame_name"), .kind = Int(anime, "kind"), .mode = Int(anime, "mode"), .param = Axes(anime, "param"), .speed = Axes(anime, "speed"), .end = Axes(anime, "end"), .uniform = OptionalInt(anime, "uniform"), .piece_space = OptionalInt(anime, "piece_space")};
    }
    if (point.contains("invent")) {
        const auto &invent = At(point, "invent");
        out.invent = SceneFuncInvent{.neta_no = Int(invent, "neta_no"), .min = Axes(invent, "min"), .max = Axes(invent, "max"), .unk_24 = Int(invent, "unk_24"), .range = Float(invent, "range"), .angle_degrees = Float(invent, "angle_degrees")};
    }
    if (point.contains("event")) {
        const auto &event = At(point, "event");
        out.event = SceneFuncEvent{.kind = Text(event, "kind"), .event_no = Int(event, "event_no"), .point_no = Int(event, "point_no"), .arg1 = Int(event, "arg1"), .arg2 = Int(event, "arg2"), .arg3 = Int(event, "arg3"), .target = OptionalText(event, "target"), .action = OptionalInt(event, "action"), .item = OptionalInt(event, "item"), .unk_100 = OptionalInt(event, "unk_100")};
    }
    if (point.contains("sound")) {
        const auto &sound = At(point, "sound");
        out.sound = SceneFuncSound{.se_no = Int(sound, "se_no"), .near_dist = Float(sound, "near_dist"), .far_dist = Float(sound, "far_dist"), .unk_2c = Int(sound, "unk_2c"), .shape = Int(sound, "shape"), .start = Axes(sound, "start"), .end = Axes(sound, "end")};
    }
    if (point.contains("effect")) {
        out.effect = Text(At(point, "effect"), "name");
    }
    return out;
}

/**
 * Parses a list of function points.
 */
std::vector<SceneFuncPoint> FuncPoints(const Json &points) {
    std::vector<SceneFuncPoint> out;
    if (!points.is_array()) {
        throw std::runtime_error("function points are not an array");
    }
    for (const auto &point : points) {
        out.push_back(FuncPoint(point));
    }
    return out;
}

/**
 * Parses one piece of a part definition.
 */
ScenePiece Piece(const Json &piece) {
    using namespace native_config;
    ScenePiece out{.model = Text(piece, "model"), .show = OptionalInt(piece, "show"), .name = OptionalText(piece, "name"), .position = OptionalVec3(piece, "position"), .rotation = OptionalVec3(piece, "rotation"), .scale = OptionalVec3(piece, "scale"), .material_count = std::nullopt, .materials = {}, .col_type = std::nullopt, .col_param = std::nullopt, .time = std::nullopt};
    if (piece.contains("materials")) {
        const auto &materials = At(piece, "materials");
        out.material_count = Int(materials, "count");
        for (const auto &entry : Array(materials, "entries")) {
            out.materials.push_back({.frame = Text(entry, "frame"), .material_no = Int(entry, "material_no"), .color = Floats<4>(entry, "color"), .color_no = Int(entry, "color_no")});
        }
    }
    if (piece.contains("collision")) {
        const auto &collision = At(piece, "collision");
        out.col_type = Int(collision, "type");
        out.col_param = OptionalInt(collision, "param");
    }
    if (piece.contains("time")) {
        out.time = Floats<2>(piece, "time");
    }
    return out;
}

/**
 * Parses a scene_map document.
 */
SceneMapDocument ParseSceneMap(const Json &document) {
    using namespace native_config;
    SceneMapDocument out{.info = Info(At(document, "info")), .parts = {}, .placements = {}, .camera_count = std::nullopt, .cameras = {}, .func_points = std::nullopt};
    for (const auto &part : Array(document, "parts")) {
        ScenePart parsed{.name = Text(part, "name"), .far_clip = FarClip(part, "far_clip"), .light_flag = std::nullopt, .move_flag = std::nullopt, .pieces = {}, .func_points = std::nullopt};
        if (part.contains("light_flag")) {
            const auto &flag = At(part, "light_flag");
            parsed.light_flag = std::array<int, 2>{Int(flag, "no_light"), Int(flag, "no_plight")};
        }
        if (part.contains("move_flag")) {
            parsed.move_flag = Ints<4>(part, "move_flag");
        }
        for (const auto &piece : Array(part, "pieces")) {
            parsed.pieces.push_back(Piece(piece));
        }
        if (part.contains("func_points")) {
            parsed.func_points = FuncPoints(At(part, "func_points"));
        }
        out.parts.push_back(std::move(parsed));
    }
    for (const auto &placement : Array(document, "placements")) {
        out.placements.push_back({.name = Text(placement, "name"), .show = OptionalInt(placement, "show"), .far_clip = FarClip(placement, "far_clip"), .definition = OptionalText(placement, "definition"), .group = OptionalText(placement, "group"), .position = OptionalVec3(placement, "position"), .rotation = OptionalVec3(placement, "rotation"), .scale = OptionalVec3(placement, "scale")});
    }
    if (document.contains("cameras")) {
        const auto &cameras = At(document, "cameras");
        out.camera_count = Int(cameras, "count");
        for (const auto &camera : Array(cameras, "cameras")) {
            SceneCamera parsed{.position = OptionalVec3(camera, "position"), .positions = {}, .draw_groups = {}, .rects = {}};
            for (const auto &pos : Array(camera, "positions")) {
                parsed.positions.emplace_back(Int(pos, "index"), Vec3(pos, "position"));
            }
            for (const auto &group : Array(camera, "draw_groups")) {
                parsed.draw_groups.emplace_back(Int(group, "index"), Text(group, "group"), Int(group, "unk_4"));
            }
            for (const auto &rect : Array(camera, "rects")) {
                parsed.rects.push_back({.shape = Text(rect, "shape"), .min = Vec3(rect, "min"), .max = Vec3(rect, "max"), .position = OptionalVec3(rect, "position"), .rotation = OptionalVec3(rect, "rotation"), .scale = OptionalVec3(rect, "scale")});
            }
            out.cameras.push_back(std::move(parsed));
        }
    }
    if (document.contains("func_points")) {
        out.func_points = FuncPoints(At(document, "func_points"));
    }
    return out;
}

/**
 * Parses an editor part table.
 */
std::optional<SceneEditTable> EditTable(const Json &georama, const char *key) {
    using namespace native_config;
    if (!georama.contains(key)) {
        return std::nullopt;
    }
    const auto    &table = At(georama, key);
    SceneEditTable out{.count = Int(table, "count"), .parts = {}};
    for (const auto &part : Array(table, "parts")) {
        out.parts.push_back({.id = Int(part, "id"), .position = Vec3(part, "position"), .angle = Int(part, "angle")});
    }
    return out;
}

/**
 * Parses a scene_config document.
 */
SceneConfigDocument ParseSceneConfig(const Json &document) {
    using namespace native_config;
    SceneConfigDocument out;
    for (const auto &rect : Array(document, "draw_off_rects")) {
        std::array<float, 12> box{};
        int                   at = 0;
        for (const char *key : {"box", "box2"}) {
            const auto &bound = At(rect, key);
            for (const char *corner : {"min", "max"}) {
                for (const float value : Vec3(bound, corner)) {
                    box[at++] = value;
                }
            }
        }
        out.draw_off_rects.push_back(box);
    }
    for (const auto &plane : Array(document, "occlusion_planes")) {
        if (!plane.is_array() || plane.size() != 4) {
            throw std::runtime_error("an occlusion plane has four corners");
        }
        std::array<float, 12> corners{};
        for (std::size_t corner = 0; corner < 4; ++corner) {
            if (!plane[corner].is_array() || plane[corner].size() != 3) {
                throw std::runtime_error("an occlusion corner has three numbers");
            }
            for (std::size_t axis = 0; axis < 3; ++axis) {
                corners[(corner * 3) + axis] = Float(plane[corner][axis]);
            }
        }
        out.occlusion_planes.push_back(corners);
    }
    const auto &water = At(document, "water");
    out.surface_count = OptionalInt(water, "surface_count");
    for (const auto &surface : Array(water, "surfaces")) {
        SceneWaterSurface parsed{.vertex = std::nullopt, .position = OptionalVec3(surface, "position"), .param = std::nullopt};
        if (surface.contains("vertex")) {
            const auto &vertex = At(surface, "vertex");
            const auto  corner0 = Vec3(vertex, "corner0");
            const auto  corner1 = Vec3(vertex, "corner1");
            parsed.vertex = std::pair{
                std::array<int, 2>{Int(vertex, "count_x"), Int(vertex, "count_z")},
                std::array<float, 6>{corner0[0], corner0[1], corner0[2], corner1[0], corner1[1], corner1[2]}
            };
        }
        if (surface.contains("param")) {
            parsed.param = Floats<4>(surface, "param");
        }
        out.surfaces.push_back(parsed);
    }
    out.draw_count = OptionalInt(water, "draw_count");
    for (const auto &draw : Array(water, "draws")) {
        out.draws.push_back({.surface = Int(draw, "surface"), .target = Text(draw, "target"), .position = OptionalVec3(draw, "position")});
    }
    for (const auto &point : Array(document, "event_points")) {
        SceneEventPoint parsed{.type = Text(point, "type"), .name = OptionalText(point, "name"), .point_no = std::nullopt, .mode = std::nullopt, .transform = Transform(point, "transform")};
        if (point.contains("event")) {
            const auto &event = At(point, "event");
            parsed.point_no = Int(event, "point_no");
            parsed.mode = OptionalText(event, "mode");
        }
        out.event_points.push_back(std::move(parsed));
    }
    if (document.contains("georama")) {
        const auto  &georama = At(document, "georama");
        SceneGeorama parsed{.fixed_parts = EditTable(georama, "fixed_parts"), .river_parts = {}, .water_models = {}, .mask_parts = {}, .initial_parts = EditTable(georama, "initial_parts")};
        for (const auto &river : Array(georama, "river_parts")) {
            parsed.river_parts.emplace_back(Int(river, "index"), Text(river, "parts"), Text(river, "model"));
        }
        for (const auto &model : Array(georama, "water_parts_models")) {
            parsed.water_models.push_back(GameText(model));
        }
        for (const auto &mask : Array(georama, "mask_parts")) {
            parsed.mask_parts.emplace_back(Int(mask, "index"), Text(mask, "model"));
        }
        out.georama = std::move(parsed);
    }
    return out;
}

} // namespace

std::optional<SceneMapDocument> ReadSceneMap(const void *buffer) {
    return native_config::ReadBuffer<SceneMapDocument>(buffer, "scene_map", ParseSceneMap);
}

std::optional<SceneConfigDocument> ReadSceneConfig(const void *buffer) {
    return native_config::ReadBuffer<SceneConfigDocument>(buffer, "scene_config", ParseSceneConfig);
}
