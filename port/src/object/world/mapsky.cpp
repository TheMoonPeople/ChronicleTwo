// clang-format off
#include "platform/native_config.hpp"
#include "memory/tracked_copy.hpp"
// clang-format on

#include "common.h"

#include <cstring>

#include "dataread.hpp"
#include "mapsky.hpp"
#include "mg_dataset.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "text/bounded.hpp"

static void LoadSkyPack(MAP_SKY_INFO *info, char *script, int size);

void CMapSky::Initialize() {
    for (int band = 0; band < 4; band++) {
        sky[band] = nullptr;
        skyb[band] = nullptr;
        sun[band] = nullptr;
        skyb_rot[band] = 0.0f;
        sky_rot[band] = 0.0f;
        skyb_rot_speed[band] = 0.0f;
        sky_rot_speed[band] = 0.0f;
        tex_block[band] = -1;
    }

    for (int frame = 0; frame < 16; frame += 8) {
        anime[frame + 0].frame = nullptr;
        anime[frame + 0].speed = 0.0f;
        anime[frame + 1].frame = nullptr;
        anime[frame + 1].speed = 0.0f;
        anime[frame + 2].frame = nullptr;
        anime[frame + 2].speed = 0.0f;
        anime[frame + 3].frame = nullptr;
        anime[frame + 3].speed = 0.0f;
        anime[frame + 4].frame = nullptr;
        anime[frame + 4].speed = 0.0f;
        anime[frame + 5].frame = nullptr;
        anime[frame + 5].speed = 0.0f;
        anime[frame + 6].frame = nullptr;
        anime[frame + 6].speed = 0.0f;
        anime[frame + 7].frame = nullptr;
        anime[frame + 7].speed = 0.0f;
    }

    bg = nullptr;
    bg_visual = nullptr;
}

void CMapSky::DrawSkyBack(float *camera_pos, float *color1, float *color0) {
    if (bg == nullptr) {
        return;
    }

    bg->SetPosition(camera_pos[0], camera_pos[1], camera_pos[2]);

    if (bg_visual != nullptr) {
        int            color_count = {};
        sceVu0FVECTOR *colors = bg_visual->GetColor(&color_count);

        if (colors != nullptr && color_count == 2) {
            sceVu0CopyVector(colors[1], color1);
            sceVu0CopyVector(colors[0], color0);
        }
    }

    bg->SetScale(1.0f, 1.0f, 1.0f);
    mgDrawDirect(bg);
    bg->SetScale(1.0f, -1.0f, 1.0f);
    mgDrawDirect(bg);
}

void CMapSky::DrawSky(float *camera_pos, float *sun_pos, float *moon_pos, int time_band,
                      float *lighting_ratio, float *sun_lighting_ratio) {
    float rotation[4];
    float ambient[4];
    float ambient_back[4];

    if (time_band < 0 || time_band >= 4) {
        return;
    }

    for (int i = 0; i < 16; i++) {
        AnimeFrame *entry = &anime[i];

        if (entry->frame != nullptr) {
            entry->frame->GetRotation(rotation);
            rotation[1] = mgAngleLimit(rotation[1] + entry->speed);
            entry->frame->SetRotation(rotation);
        }
    }

    for (int i = 0; i < 4; i++) {
        sky_rot[i] = mgAngleLimit(sky_rot[i] + sky_rot_speed[i]);
        skyb_rot[i] = mgAngleLimit(skyb_rot[i] + skyb_rot_speed[i]);
    }

    mgCTextureManager *textures = &mgTexManager;
    mgGetAmbient(ambient);
    mgGetAmbient(ambient_back);
    mgCFrameAttr attr;

    for (int i = 0; i < 4; i++) {
        attr.obj_alpha = lighting_ratio[i];

        if (!(lighting_ratio[i] <= 0.0f) && skyb[i] != nullptr) {
            textures->ReloadTexture(tex_block[i], (sceVif1Packet *) nullptr);
            skyb[i]->SetScale(1.0f, 1.0f, 1.0f);
            skyb[i]->SetPosition(camera_pos[0], camera_pos[1], camera_pos[2]);
            skyb[i]->SetRotation(0.0f, skyb_rot[i], 0.0f);
            skyb[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_OBJ_ALPHA);
            mgDrawDirect(skyb[i]);
            skyb[i]->SetScale(1.0f, -1.0f, 1.0f);
            mgDrawDirect(skyb[i]);
        }
    }

    if (lighting_ratio[2] <= 0.0f) {
        for (int i = 0; i < 4; i++) {
            attr.obj_alpha = sun_lighting_ratio[i];

            if (!(sun_lighting_ratio[i] <= 0.0f) && sun[i] != nullptr) {
                textures->ReloadTexture(tex_block[i], (sceVif1Packet *) nullptr);
                sun[i]->SetPosition(sun_pos);
                sun[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_OBJ_ALPHA);

                if (!(sun_pos[1] <= camera_pos[1])) {
                    mgDrawDirect(sun[i]);

                    if (i != 2) {
                        sun[i]->SetPosition(sun_pos[0], camera_pos[1] - sun_pos[1], sun_pos[2]);
                        mgDrawDirect(sun[i]);
                    }
                }
            }
        }
    }

    if (!(lighting_ratio[2] <= 0.0f)) {
        for (int i = 0; i < 4; i++) {
            attr.obj_alpha = sun_lighting_ratio[i];

            if (!(sun_lighting_ratio[i] <= 0.0f) && sun[i] != nullptr) {
                textures->ReloadTexture(tex_block[i], (sceVif1Packet *) nullptr);
                sun[i]->SetPosition(moon_pos);
                sun[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_OBJ_ALPHA);

                if (!(moon_pos[1] <= camera_pos[1])) {
                    mgDrawDirect(sun[i]);

                    if (i != 2) {
                        sun[i]->SetPosition(moon_pos[0], camera_pos[1] - moon_pos[1], moon_pos[2]);
                        mgDrawDirect(sun[i]);
                    }
                }
            }
        }
    }

    for (int i = 0; i < 4; i++) {
        attr.obj_alpha = lighting_ratio[i];

        if (!(lighting_ratio[i] <= 0.0f) && sky[i] != nullptr) {
            textures->ReloadTexture(tex_block[i], (sceVif1Packet *) nullptr);
            sky[i]->SetScale(1.0f, 1.0f, 1.0f);
            sky[i]->SetPosition(camera_pos[0], camera_pos[1], camera_pos[2]);
            sky[i]->SetRotation(0.0f, sky_rot[i], 0.0f);
            sky[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_OBJ_ALPHA);
            mgDrawDirect(sky[i]);
            sky[i]->SetScale(1.0f, -1.0f, 1.0f);
            mgDrawDirect(sky[i]);
        }
    }
}

void CMapSky::LoadPack(unsigned int *pack, int tex_block_base, mgCMemory *memory) {
    if (pack == nullptr) {
        return;
    }

    Initialize();
    int          script_size = 0;
    char        *script = reinterpret_cast<char *>(AssetDirectoryRead(pack, "info.cfg.json", &script_size));
    MAP_SKY_INFO info{};
    memset(&info, 0, sizeof(info));
    LoadSkyPack(&info, script, script_size);
    mgCTextureManager *textures = &mgTexManager;
    mgCFrameAttr       attr;
    attr.alpha_ref = 0;
    attr.z_write = -1;

    for (int i = 0; i < 4; i++) {
        int     image_size = {};
        u_char *image = {};
        int     texture_block = tex_block_base + i;
        textures->DeleteBlock(texture_block);
        u_int       *image_in_pack = AssetDirectoryRead(pack, info.img_name[i], &image_size);
        unsigned int quadwords = {};

        if (image_size & 0xF) {
            quadwords = (static_cast<unsigned int>(image_size) >> 4) + 1;
        } else {
            quadwords = static_cast<unsigned int>(image_size) >> 4;
        }

        image = reinterpret_cast<u_char *>(memory->Alloc(quadwords));
        dc2::memory::CopyTrackedBytes(image, image_in_pack, image_size);
        MDS_HEADER *sky_file = reinterpret_cast<MDS_HEADER *>(AssetDirectoryRead(pack, info.sky_mds_name[i], nullptr));
        MDS_HEADER *skyb_file = reinterpret_cast<MDS_HEADER *>(AssetDirectoryRead(pack, info.skyb_mds_name[i], nullptr));
        MDS_HEADER *sun_file = reinterpret_cast<MDS_HEADER *>(AssetDirectoryRead(pack, info.sun_mds_name[i], nullptr));
        sky_rot_speed[i] = info.sky_rot_speed[i];
        skyb_rot_speed[i] = info.skyb_rot_speed[i];

        if (image != nullptr) {
            tex_block[i] = texture_block;
            textures->EnterIMGFile(image, texture_block, memory, nullptr);
        }

        if (sky_file != nullptr) {
            sky[i] = mgLoadMDSFile(sky_file, memory, nullptr, nullptr);

            if (sky[i] != nullptr) {
                sky[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_ALPHA_REF | MG_FRAME_ATTR_Z_WRITE);
            }
        }

        if (skyb_file != nullptr) {
            skyb[i] = mgLoadMDSFile(skyb_file, memory, nullptr, nullptr);

            if (skyb[i] != nullptr) {
                skyb[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_ALPHA_REF | MG_FRAME_ATTR_Z_WRITE);
            }
        }

        if (sun_file != nullptr) {
            sun[i] = mgLoadMDSFile(sun_file, memory, nullptr, nullptr);

            if (sun[i] != nullptr) {
                sun[i]->SetAttrParam(attr, 1, MG_FRAME_ATTR_ALPHA_REF | MG_FRAME_ATTR_Z_WRITE);
            }
        }
    }

    MDS_HEADER *background_file = reinterpret_cast<MDS_HEADER *>(AssetDirectoryRead(pack, info.bg_mds_name, nullptr));

    if (background_file != nullptr) {
        mgCreateVisualType visual_types[2] = {
            {0,                    ""     },
            {MG_VISUAL_CREATE_END, nullptr}
        };
        bg = mgLoadMDSFile(background_file, memory, visual_types, nullptr);

        if (bg != nullptr) {
            mgCFrameAttr *bg_attr = bg->attr;

            if (bg_attr != nullptr) {
                bg_attr->z_write = -1;
                bg_attr->clip_enable = 1;
                bg_attr->fog = MG_FOG_OFF;
            }

            bg_visual = static_cast<mgCVisualMDT *>(bg->visual);
        }
    }

    int next = 0;

    for (int i = 0; i < 16; i++) {
        if (info.sky_anime_name[i][0] != 0 && next < 16) {
            mgCFrame *model = sky[info.sky_anime_id[i]];

            if (model != nullptr) {
                mgCFrame *frame = model->SearchFrame(info.sky_anime_name[i]);

                if (frame != nullptr) {
                    anime[next].frame = frame;
                    anime[next].speed = info.sky_anime_speed[i];
                    next++;
                }
            }
        }
    }

    for (int i = 0; i < 16; i++) {
        if (info.skyb_anime_name[i][0] != 0 && next < 16) {
            mgCFrame *model = skyb[info.skyb_anime_id[i]];

            if (model != nullptr) {
                mgCFrame *frame = model->SearchFrame(info.skyb_anime_name[i]);

                if (frame != nullptr) {
                    anime[next].frame = frame;
                    anime[next].speed = info.skyb_anime_speed[i];
                    next++;
                }
            }
        }
    }
}

/**
 *
 * Parses sky configuration tags into the supplied sky information record.
 *
 */
static void LoadSkyPack(MAP_SKY_INFO *info, char *script, int size) {
    if (script == nullptr || size == 0) {
        return;
    }

    PortLoadSkyInfo(info, script, size);
}

// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
// clang-format on

#include "common.h"

#include <cstring>
#include <numbers>
#include <optional>
#include <string>
#include <vector>

#include "mapsky.hpp"
#include "stubs/mapsky.hpp"

namespace {

/**
 * Number of time bands a sky has.
 */
constexpr int kSkyBands = 4;

/**
 * Number of turning frames each kind of sky model can hold.
 */
constexpr int kSkyAnimations = 16;

/**
 * Bytes of every name field of MAP_SKY_INFO.
 */
constexpr std::size_t kSkyName = sizeof(MAP_SKY_INFO::bg_mds_name);

/**
 * One row of a sky table: a band, a file or frame name and, for models and animations, degrees.
 */
struct SkyRow {
    int                        band;    /**< Time band; unused for the background. */
    std::optional<std::string> name;    /**< File or frame name, CP932. */
    float                      degrees; /**< Turn per frame in degrees, for models and animations. */
};

/**
 * Typed contents of a sky document, each table in script order.
 */
struct SkyDocument {
    std::vector<SkyRow> images;          /**< SKY_IMG rows. */
    std::vector<SkyRow> models;          /**< SKY_MDS rows. */
    std::vector<SkyRow> animations;      /**< SKY_ANIME rows. */
    std::vector<SkyRow> suns;            /**< SUN_MDS rows. */
    std::vector<SkyRow> back_models;     /**< SKYB_MDS rows. */
    std::vector<SkyRow> back_animations; /**< SKYB_ANIME rows. */
    std::vector<SkyRow> backgrounds;     /**< SKY_BG rows. */
};

/**
 * Parses one sky table; the name key is "file" or "frame" and the degree key is optional.
 */
std::vector<SkyRow> Rows(const native_config::Json &document, const char *key, const char *name_key, const char *degree_key, bool band) {
    using namespace native_config;
    std::vector<SkyRow> rows;
    for (const auto &row : Array(document, key)) {
        SkyRow parsed{.band = band ? Int(row, "band") : 0, .name = OptionalText(row, name_key), .degrees = degree_key != nullptr ? Float(row, degree_key) : 0.0f};
        // The sky's fields hold 31 bytes and a terminator.
        if (parsed.name && parsed.name->size() >= kSkyName) {
            throw std::runtime_error(std::string(key) + " name is longer than the sky holds");
        }
        rows.push_back(std::move(parsed));
    }
    return rows;
}

/**
 * Parses a sky document.
 */
SkyDocument ParseSky(const native_config::Json &document) {
    return {.images = Rows(document, "images", "file", nullptr, true),
            .models = Rows(document, "models", "file", "rotation_degrees", true),
            .animations = Rows(document, "animations", "frame", "speed_degrees", true),
            .suns = Rows(document, "suns", "file", nullptr, true),
            .back_models = Rows(document, "back_models", "file", "rotation_degrees", true),
            .back_animations = Rows(document, "back_animations", "frame", "speed_degrees", true),
            .backgrounds = Rows(document, "backgrounds", "file", nullptr, false)};
}

/**
 * Copies a sky name when the row gave one.
 */
template <std::size_t N>
void CopyName(char (&destination)[N], const std::optional<std::string> &name) {
    if (name) {
        dc2::text::Copy(destination, std::string_view(*name));
    }
}

/**
 * Whether a band names one of the sky's time bands.
 */
bool Band(int band) {
    return band >= 0 && band < kSkyBands;
}

/**
 * Adds the turning frames of one kind of sky model, as SKY_ANIME and SKYB_ANIME do.
 */
void Animations(const std::vector<SkyRow> &rows, int *ids, char (*names)[32], float *speeds) {
    int count = 0;
    for (const auto &row : rows) {
        if (count >= kSkyAnimations || !Band(row.band)) {
            continue;
        }
        ids[count] = row.band;
        CopyName(names[count], row.name);
        speeds[count] = std::numbers::pi_v<float> * row.degrees / 180.0f;
        ++count;
    }
}

} // namespace

void PortLoadSkyInfo(MAP_SKY_INFO *info, char *script, int size) {
    if (script == nullptr || size == 0) {
        return;
    }
    const auto sky = native_config::ReadBuffer<SkyDocument>(script, "sky", ParseSky);
    if (!sky) {
        return;
    }
    for (const auto &row : sky->images) {
        if (Band(row.band)) {
            CopyName(info->img_name[row.band], row.name);
        }
    }
    for (const auto &row : sky->models) {
        if (Band(row.band)) {
            CopyName(info->sky_mds_name[row.band], row.name);
            info->sky_rot_speed[row.band] = row.degrees * std::numbers::pi_v<float> / 180.0f;
        }
    }
    for (const auto &row : sky->suns) {
        if (Band(row.band)) {
            CopyName(info->sun_mds_name[row.band], row.name);
        }
    }
    for (const auto &row : sky->back_models) {
        if (Band(row.band)) {
            CopyName(info->skyb_mds_name[row.band], row.name);
            info->skyb_rot_speed[row.band] = row.degrees * std::numbers::pi_v<float> / 180.0f;
        }
    }
    for (const auto &row : sky->backgrounds) {
        CopyName(info->bg_mds_name, row.name);
    }
    Animations(sky->animations, info->sky_anime_id, info->sky_anime_name, info->sky_anime_speed);
    Animations(sky->back_animations, info->skyb_anime_id, info->skyb_anime_name, info->skyb_anime_speed);
}
