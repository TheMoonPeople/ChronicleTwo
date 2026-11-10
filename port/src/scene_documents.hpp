#pragma once

#include <array>
#include <optional>
#include <string>
#include <tuple>
#include <utility>
#include <vector>

// Typed contents of the scene_map (*.map.json) and scene_config (map/**/<map>.cfg.json) documents.
// Strings are CP932; an absent optional is an operand the script left out, which the loaders treat
// exactly as the retail callbacks treat the missing argument.

/**
 * Three floats: a position, rotation, scale, direction or colour as the script gives it.
 */
using SceneVec3 = std::array<float, 3>;

/**
 * Game text that may be null, as a missing or non-string script operand is.
 */
using SceneText = std::optional<std::string>;

/**
 * Directional light of a lighting set.
 */
struct SceneLight {
    int                      index{};   /**< Light slot, 0 to 3. */
    std::optional<SceneVec3> direction; /**< Direction; without it the light is ignored. */
    std::optional<SceneVec3> color;     /**< Colour, when given. */
};

/**
 * Point light of a lighting set.
 */
struct ScenePointLight {
    int       index;    /**< Light slot, 0 to 3. */
    float     power;    /**< Strength. */
    SceneVec3 position; /**< Position. */
    SceneVec3 color;    /**< Colour. */
};

/**
 * Fog of a lighting set.
 */
struct SceneFog {
    float                             near_dist;  /**< Near distance. */
    float                             far_dist;   /**< Far distance. */
    std::optional<std::array<int, 3>> color;      /**< Colour, white when left out. */
    std::optional<float>              far_value;  /**< Fog value at the far distance, 0 when left out. */
    std::optional<float>              near_value; /**< Fog value at the near distance, 255 when left out. */
};

/**
 * One LIGHT_SET block.
 */
struct SceneLightSet {
    int                          index;        /**< Lighting set number. */
    bool                         fov;          /**< Whether FOV appears, setting the 52-degree projection. */
    std::optional<SceneVec3>     bg_color;     /**< Background colour. */
    std::optional<SceneVec3>     bg_color2;    /**< Second background colour. */
    std::optional<SceneVec3>     ambient;      /**< Ambient colour. */
    std::vector<SceneLight>      lights;       /**< Directional lights in script order. */
    std::vector<ScenePointLight> point_lights; /**< Point lights in script order. */
    std::optional<int>           fog_enable;   /**< Fog switch. */
    std::optional<SceneFog>      fog;          /**< Fog. */
};

/**
 * Map settings read by CMapInfo::LoadMapInfo.
 */
struct SceneInfo {
    std::vector<SceneText>     texture_packs;       /**< IMG names in script order. */
    std::vector<SceneText>     model_packs;         /**< PCP names in script order. */
    std::optional<int>         active_light_set;    /**< ACTIVE_LIGHT_SET. */
    std::vector<SceneLightSet> light_sets;          /**< Lighting sets in script order. */
    std::optional<float>       floor;               /**< FLOOR. */
    std::optional<SceneVec3>   chara_pos;           /**< CHARA_POS. */
    std::optional<int>         def_foot;            /**< DEF_FOOT. */
    std::optional<int>         time_enable;         /**< TIME_FLAG's clock switch. */
    int                        time_blend = 0;      /**< TIME_FLAG's blend switch. */
    std::optional<float>       fixed_time;          /**< TIME_FLAG's fixed hour. */
    std::optional<int>         fixed_time_enable;   /**< TIME_FLAG's fixed-hour switch. */
    std::optional<int>         time_light_num;      /**< TIME_LIGHT_NUM. */
    std::optional<int>         time_cfade;          /**< TIME_CFADE. */
    std::optional<int>         sky_info;            /**< SKY_INFO's sky number. */
    float                      sky_height = 0.0f;   /**< SKY_INFO's height. */
    std::optional<float>       sun_angle_degrees;   /**< SKY_INFO's sun path angle. */
    std::optional<int>         lens_flare;          /**< LENS_FLARE. */
    std::optional<int>         all_scissor;         /**< ALL_SCISSOR. */
    std::optional<int>         chara_light_adjust;  /**< CHARA_LIGHT_ADJUST's mode. */
    SceneVec3                  chara_light_value{}; /**< CHARA_LIGHT_ADJUST's values. */
};

/**
 * Colour entry of a piece's material list.
 */
struct SceneMaterial {
    SceneText            frame;         /**< Frame holding the material. */
    int                  material_no{}; /**< Material number in the frame. */
    std::array<float, 4> color{};       /**< Colour. */
    int                  color_no{};    /**< Colour slot. */
};

/**
 * One PIECE block of a part definition.
 */
struct ScenePiece {
    SceneText                           model;          /**< Model data the piece uses. */
    std::optional<int>                  show;           /**< Whether it is shown, when given. */
    std::optional<SceneText>            name;           /**< PIECE_NAME. */
    std::optional<SceneVec3>            position;       /**< PIECE_POS. */
    std::optional<SceneVec3>            rotation;       /**< PIECE_ROT. */
    std::optional<SceneVec3>            scale;          /**< PIECE_SCALE. */
    std::optional<int>                  material_count; /**< PIECE_MATERIAL_START's entry count. */
    std::vector<SceneMaterial>          materials;      /**< PIECE_MATERIAL rows. */
    std::optional<int>                  col_type;       /**< PIECE_COL_TYPE's type. */
    std::optional<int>                  col_param;      /**< PIECE_COL_TYPE's parameter. */
    std::optional<std::array<float, 2>> time;           /**< PIECE_TIME's hours. */
};

/**
 * FUNC_FLAG of a function point.
 */
struct SceneFuncFlag {
    int   flag_no; /**< Map flag recording the point's state. */
    int   unk_8;   /**< Value copied to CFuncPoint::unk_8. */
    float start;   /**< Hour the point starts working. */
    float end;     /**< Hour the point stops working. */
};

/**
 * FUNC_FIRE_DATA of a function point.
 */
struct SceneFuncFire {
    SceneVec3          color;      /**< Colour, 0 to 1, or black for the default fire colour. */
    int                effect;     /**< Non-zero draws the fire effect. */
    std::optional<int> heat_haze;  /**< Heat haze switch, when given. */
    std::optional<int> cast_light; /**< Point-light switch, when given. */
};

/**
 * FUNC_PLIGHT_DATA of a function point.
 */
struct SceneFuncPlight {
    float                power;          /**< Strength. */
    SceneVec3            color;          /**< Colour, halved at load. */
    int                  light_type;     /**< Kind of light. */
    std::optional<int>   light_chara;    /**< Character lighting switch. */
    std::optional<int>   unk_40;         /**< Value copied to unk_40. */
    std::optional<int>   unk_44;         /**< Value copied to unk_44. */
    std::optional<int>   no_map_light;   /**< Map lighting switch. */
    std::optional<int>   flicker_type;   /**< Flicker kind. */
    std::optional<float> flicker_depth;  /**< Flicker depth. */
    std::optional<float> flicker_period; /**< Flicker period. */
};

/**
 * FUNC_ANIME_DATA of a function point.
 */
struct SceneFuncAnime {
    SceneText          parts_name;  /**< Placed part animated. */
    SceneText          piece_name;  /**< Piece animated. */
    SceneText          frame_name;  /**< Frame animated. */
    int                kind;        /**< Value animated. */
    int                mode;        /**< Animation mode. */
    SceneVec3          param;       /**< Start value. */
    SceneVec3          speed;       /**< Step. */
    SceneVec3          end;         /**< End value. */
    std::optional<int> uniform;     /**< Uniform switch, when given. */
    std::optional<int> piece_space; /**< Piece-space switch, when given. */
};

/**
 * FUNC_INVENT_DATA of a function point.
 */
struct SceneFuncInvent {
    int       neta_no;       /**< Photo subject. */
    SceneVec3 min;           /**< Box minimum. */
    SceneVec3 max;           /**< Box maximum. */
    int       unk_24;        /**< Value copied to unk_24. */
    float     range;         /**< Reach. */
    float     angle_degrees; /**< Angle in degrees. */
};

/**
 * FUNC_EVENT_DATA of a function point.
 */
struct SceneFuncEvent {
    SceneText                kind;     /**< Kind word. */
    int                      event_no; /**< Event number. */
    int                      point_no; /**< Event point number. */
    int                      arg1;     /**< First argument. */
    int                      arg2;     /**< Second argument. */
    int                      arg3;     /**< Third argument. */
    std::optional<SceneText> target;   /**< Target, when given. */
    std::optional<int>       action;   /**< Action switch, when given. */
    std::optional<int>       item;     /**< Item switch, when given. */
    std::optional<int>       unk_100;  /**< FUNC_EVENT_UNK_100 switch, when given. */
};

/**
 * FUNC_SOUND_DATA of a function point.
 */
struct SceneFuncSound {
    int       se_no;     /**< Sound effect. */
    float     near_dist; /**< Falloff start. */
    float     far_dist;  /**< Falloff end. */
    int       unk_2c;    /**< Value converted to unk_2c. */
    int       shape;     /**< Line switch. */
    SceneVec3 start;     /**< Line start. */
    SceneVec3 end;       /**< Line end. */
};

/**
 * One FUNC_DATA block.
 */
struct SceneFuncPoint {
    SceneText                           type;      /**< Kind word. */
    int                                 enable{};  /**< Enable value. */
    std::optional<SceneText>            name;      /**< FUNC_NAME. */
    std::optional<SceneFuncFlag>        flag;      /**< FUNC_FLAG. */
    std::optional<SceneFuncFire>        fire;      /**< FUNC_FIRE_DATA. */
    std::optional<SceneFuncPlight>      plight;    /**< FUNC_PLIGHT_DATA. */
    std::optional<SceneFuncAnime>       anime;     /**< FUNC_ANIME_DATA. */
    std::optional<SceneFuncInvent>      invent;    /**< FUNC_INVENT_DATA. */
    std::optional<SceneFuncEvent>       event;     /**< FUNC_EVENT_DATA. */
    std::optional<SceneFuncSound>       sound;     /**< FUNC_SOUND_DATA. */
    std::optional<SceneText>            effect;    /**< FUNC_EFFECT_NAME. */
    std::optional<std::array<float, 9>> transform; /**< FUNC_POS: position, rotation, scale. */
};

/**
 * One PARTS block: a part definition.
 */
struct ScenePart {
    SceneText                                  name;        /**< Part name. */
    std::optional<std::pair<float, int>>       far_clip;    /**< FAR_CLIP distance and fade. */
    std::optional<std::array<int, 2>>          light_flag;  /**< LIGHT_FLAG. */
    std::optional<std::array<int, 4>>          move_flag;   /**< MOVE_FLAG. */
    std::vector<ScenePiece>                    pieces;      /**< Pieces in script order. */
    std::optional<std::vector<SceneFuncPoint>> func_points; /**< The part's FUNC_POINT block. */
};

/**
 * One MAP_PARTS block: a placed part.
 */
struct ScenePlacement {
    SceneText                            name;       /**< Placement name. */
    std::optional<int>                   show;       /**< Whether it is shown, when given. */
    std::optional<std::pair<float, int>> far_clip;   /**< MAP_FAR_CLIP. */
    std::optional<SceneText>             definition; /**< PARTS_NAME. */
    std::optional<SceneText>             group;      /**< PARTS_GROUP. */
    std::optional<SceneVec3>             position;   /**< PARTS_POS. */
    std::optional<SceneVec3>             rotation;   /**< PARTS_ROT. */
    std::optional<SceneVec3>             scale;      /**< PARTS_SCALE. */
};

/**
 * Collision rectangle of a fixed camera.
 */
struct SceneCameraRect {
    SceneText                shape;    /**< Shape word; only "box" builds a collision. */
    SceneVec3                min{};    /**< Box minimum. */
    SceneVec3                max{};    /**< Box maximum. */
    std::optional<SceneVec3> position; /**< Frame position, when given. */
    std::optional<SceneVec3> rotation; /**< Frame rotation, when given. */
    std::optional<SceneVec3> scale;    /**< Frame scale, when given. */
};

/**
 * One FIX_CAMERA block.
 */
struct SceneCamera {
    std::optional<SceneVec3>                     position;    /**< FIX_CAMERA_POS. */
    std::vector<std::pair<int, SceneVec3>>       positions;   /**< FIX_CAMERA_POS2 rows. */
    std::vector<std::tuple<int, SceneText, int>> draw_groups; /**< FIX_CAMERA_OFF_GROUP rows. */
    std::vector<SceneCameraRect>                 rects;       /**< FIX_CAMERA_RECT rows. */
};

/**
 * Typed contents of a scene_map document.
 */
struct SceneMapDocument {
    SceneInfo                                  info;         /**< Map settings. */
    std::vector<ScenePart>                     parts;        /**< Part definitions. */
    std::vector<ScenePlacement>                placements;   /**< Placed parts. */
    std::optional<int>                         camera_count; /**< CAMERA_INFO's table size. */
    std::vector<SceneCamera>                   cameras;      /**< Fixed cameras. */
    std::optional<std::vector<SceneFuncPoint>> func_points;  /**< The map's own FUNC_POINT block. */
};

/**
 * Event point of a scene configuration.
 */
struct SceneEventPoint {
    SceneText                           type;      /**< FUNC_DATA's kind word; only "event" creates a point. */
    std::optional<SceneText>            name;      /**< FUNC_NAME. */
    std::optional<int>                  point_no;  /**< FUNC_EVENT_DATA's point number. */
    std::optional<SceneText>            mode;      /**< FUNC_EVENT_DATA's mode, when given. */
    std::optional<std::array<float, 9>> transform; /**< FUNC_POS. */
};

/**
 * Water surface of a scene configuration.
 */
struct SceneWaterSurface {
    std::optional<std::pair<std::array<int, 2>, std::array<float, 6>>> vertex;   /**< Grid size and opposite corners. */
    std::optional<SceneVec3>                                           position; /**< WATER_POS. */
    std::optional<std::array<float, 4>>                                param;    /**< WATER_PARAM. */
};

/**
 * Water drawing record of a scene configuration.
 */
struct SceneWaterDraw {
    int                      surface{}; /**< Surface index. */
    SceneText                target;    /**< Placed part name, or "#followNNN". */
    std::optional<SceneVec3> position;  /**< Position, when given. */
};

/**
 * Placed editor part of a georama map.
 */
struct SceneEditPart {
    int       id;       /**< Editor part number. */
    SceneVec3 position; /**< Position. */
    int       angle;    /**< Angle. */
};

/**
 * Editor part table of a georama map.
 */
struct SceneEditTable {
    int                        count; /**< Entries allocated. */
    std::vector<SceneEditPart> parts; /**< Parts in script order. */
};

/**
 * Georama editor settings of a scene configuration.
 */
struct SceneGeorama {
    std::optional<SceneEditTable>                      fixed_parts;   /**< FIX_EPARTS table. */
    std::vector<std::tuple<int, SceneText, SceneText>> river_parts;   /**< RIVER_PARTS_NAME rows. */
    std::vector<SceneText>                             water_models;  /**< WATER_PARTS_NAME rows. */
    std::vector<std::pair<int, SceneText>>             mask_parts;    /**< MASK_PARTS_NAME rows. */
    std::optional<SceneEditTable>                      initial_parts; /**< INIT_EPARTS table. */
};

/**
 * Typed contents of a scene_config document.
 */
struct SceneConfigDocument {
    std::vector<std::array<float, 12>> draw_off_rects;   /**< DRAW_OFF_RECT boxes. */
    std::vector<std::array<float, 12>> occlusion_planes; /**< OCCLUSION_PLANE corners. */
    std::optional<int>                 surface_count;    /**< WATER_SURFACE_NUM. */
    std::vector<SceneWaterSurface>     surfaces;         /**< Water surfaces. */
    std::optional<int>                 draw_count;       /**< WATER_DRAW_NUM. */
    std::vector<SceneWaterDraw>        draws;            /**< WATER_DRAW rows. */
    std::vector<SceneEventPoint>       event_points;     /**< Event points. */
    std::optional<SceneGeorama>        georama;          /**< Georama editor settings. */
};

/**
 * Parses the scene_map document a loaded map buffer was read from.
 */
std::optional<SceneMapDocument> ReadSceneMap(const void *buffer);

/**
 * Parses the scene_config document a loaded configuration buffer was read from.
 */
std::optional<SceneConfigDocument> ReadSceneConfig(const void *buffer);
