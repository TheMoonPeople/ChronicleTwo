// clang-format off
#include "platform/native_config.hpp"
#include "log/game_output.hpp"
// clang-format on

#include "common.h"

#include <array>
#include <cstdio>
#include <cstring>
#include <iterator>
#include <limits>
#include <vector>

#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "collision.hpp"
#include "dataread.hpp"
#include "mapload.hpp"
#include "mdslist.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "object.hpp"
#include "padcontrol.hpp"
#include "scene.hpp"
#include "scriptinterpreter.hpp"

/**
 *
 * Rounds a byte count up to the number of 16-byte allocation blocks.
 *
 */
static inline u_int align16_blocks(u_int size) {
    if (size & 15) {
        return (size >> 4) + 1;
    }

    return size >> 4;
}

int CMapPiece::AssignMds(CMdsInfo *info) {
    if (info == nullptr) {
        return false;
    }

    name = info->name;
    chara = info->chara;
    type = info->type;
    frame = info->frame;
    far_dist = info->far_dist;
    fade = info->far_fade;
    return true;
}

int CMapPiece::GetPoly(int type, CCPoly *poly, mgVu0FBOX &box, int num) {
    if (type != this->type) {
        return 0;
    }

    if (col_type != 0) {
        return 0;
    }

    if (GetShow() == 0) {
        return 0;
    }

    UpDatePosition();
    return (static_cast<CColFrame *>(frame))->PickUpNearPoly(poly, box, num);
}

void CMapPiece::SetTimeBand(float start, float end) {
    time_start = start;
    time_end = end;
}

PieceMaterial *CMapPiece::GetMaterial(int index) {
    PieceMaterial *list = {};

    list = material;

    if (list == nullptr) {
        return nullptr;
    }

    if (index < 0 || index >= material_num) {
        return nullptr;
    }

    return &list[index];
}

void CMapPiece::Step() {
    if (chara != nullptr) {
        UpDatePosition();
        chara->Step();
    }
}

int CMapPiece::GetBoundBox(mgVu0FBOX *box) {
    if (frame == nullptr) {
        return false;
    }

    UpDatePosition();
    return frame->GetWorldBBox(box);
}

int CMapPiece::DrawSub(int direct) {
    int            result = {};
    int            i = {};
    PieceMaterial *piece_material = {};

    if (draw_enable == 0) {
        return 0;
    }

    if (type & 0x1) {
        return 0;
    }

    if (material_num < 0 || (material_num > 0 && material == nullptr)) {
        return 0;
    }

    std::vector<std::array<float, 4>> saved_color(static_cast<std::size_t>(material_num));

    piece_material = material;

    if (piece_material != nullptr) {
        for (i = 0; i < material_num; i++, piece_material++) {
            if (piece_material->material != nullptr) {
                std::memcpy(saved_color[i].data(), piece_material->material->diffuse, sizeof(piece_material->material->diffuse));
                std::memcpy(piece_material->material->diffuse, piece_material->color, sizeof(piece_material->material->diffuse));
            }
        }
    }

    if (direct != 0) {
        result = CObjectFrame::DrawDirect();
    } else {
        result = CObjectFrame::Draw();
    }

    piece_material = material;

    if (piece_material != nullptr) {
        for (i = 0; i < material_num; i++, piece_material++) {
            if (piece_material->material != nullptr) {
                std::memcpy(piece_material->material->diffuse, saved_color[i].data(), sizeof(piece_material->material->diffuse));
            }
        }
    }

    return result;
}

void CMapPiece::Copy(CMapPiece &dest, mgCMemory *memory) {
    int            i = {};
    PieceMaterial *to = {};
    PieceMaterial *from = {};
    int            num = {};
    CCharacter2   *model = {};

    dest.Initialize();
    CObjectFrame::Copy(dest, memory);
    dest.name = name;
    dest.type = type;
    dest.draw_enable = draw_enable;
    dest.col_type = col_type;
    dest.time_start = time_start;
    dest.time_end = time_end;
    dest.material_num = material_num;

    if (memory == nullptr) {
        dest.material = material;
    } else {
        num = material_num;
        const auto bytes = num > 0 ? static_cast<std::size_t>(num) * sizeof(PieceMaterial) : 0;
        const auto blocks = (bytes + 15) / sizeof(u_long128) + 2;
        auto      *storage = num > 0 && material != nullptr && blocks <= static_cast<std::size_t>(std::numeric_limits<int>::max()) &&
                                     memory->stGetRest() > 0 && blocks < static_cast<std::size_t>(memory->stGetRest())
                                 ? memory->Alloc(static_cast<int>(blocks))
                                 : nullptr;
        dest.material = storage != nullptr ? new (storage) PieceMaterial[num] : nullptr;
        i = 0;

        if (dest.material == nullptr) {
            dest.material_num = 0;
        }

        for (; i < dest.material_num; i++) {
            from = &material[i];
            to = &dest.material[i];
            *to = *from;
        }
    }

    if (chara != nullptr && memory != nullptr) {
        model = dc2::memory::NewObject<CCharacter2>(*memory);

        dest.chara = model;

        if (dest.chara != nullptr) {
            chara->Copy(*dest.chara, memory);
            dest.frame = dest.chara->CObjectFrame::frame;
        }
    } else {
        dest.chara = chara;
    }
}

void CMapPiece::Initialize() {
    int i = {};

    CObjectFrame::Initialize();
    type = 0;
    chara = nullptr;
    i = 0;
    draw_enable = true;
    name = nullptr;
    material_num = 0;
    col_type = 0;
    col_param = 0;

    for (; i < material_num; i++) {
        memset(&material[i], 0, sizeof(PieceMaterial));
    }

    time_end = 0.0f;
    time_start = 0.0f;
}

void CMdsInfo::Initialize() {
    resource_lifetime = {};
    character_storage = {};
    name = nullptr;
    type = MDS_TYPE_MODEL;
    frame = nullptr;
    chara = nullptr;
    far_dist = -1.0f;
    far_fade = 0;
}

CMdsList *CMdsListSet::SearchMdsList(char *name) {
    int i = {};

    if (name == nullptr) {
        return nullptr;
    }

    for (i = 0; i < mds_list_num && i < static_cast<int>(std::size(mds_list)); i++) {
        if (mds_list[i].resource_lifetime.IsLive() && mds_list[i].name != nullptr && strcmp(mds_list[i].name, name) == 0) {
            return &mds_list[i];
        }
    }

    return nullptr;
}

CMdsList *CMdsListSet::GetMdsList(int index) {
    if (index < 0 || index >= mds_list_num || index >= static_cast<int>(std::size(mds_list))) {
        return nullptr;
    }

    return &mds_list[index];
}

CMdsInfo *CMdsListSet::SearchMDS(char *name) {
    int       i = {};
    CMdsList *models = {};
    CMdsInfo *item = {};

    i = 0;

    for (;;) {
        models = GetMdsList(i);

        if (models == nullptr) {
            break;
        }

        item = models->GetList(name);

        if (item != nullptr) {
            return item;
        }

        i++;
    }

    return nullptr;
}

int CMdsListSet::LoadPCPFile(char *name, u_int *pack, mgCMemory *memory, int type) {
    CMdsList *slot = {};
    int       i = {};
    int       is_free = {};

    if (name == nullptr) {
        return false;
    }

    if (SearchMdsList(name) != nullptr) {
        return false;
    }

    slot = nullptr;
    i = 0;

    for (; i < mds_list_num && i < static_cast<int>(std::size(mds_list)); i++) {
        is_free = !mds_list[i].resource_lifetime.IsLive() || !mds_list[i].list || !mds_list[i].name || mds_list[i].num == 0;

        if (is_free & 0xFF) {
            slot = &mds_list[i];
        }
    }

    if (slot == nullptr) {
        return false;
    }

    slot->LoadPCPFile(name, pack, memory, type);
    return true;
}

int CMdsListSet::DeleteMdsList(char *name) {
    CMdsList *mds_list = SearchMdsList(name);

    if (mds_list == nullptr) {
        return false;
    }

    mds_list->name = nullptr;
    mds_list->num = 0;
    mds_list->list = nullptr;
    return true;
}

int CMdsListSet::LoadIMGFile(char *name, mgCEnterIMGInfo *info, mgCMemory *memory) {
    CIMGList *slot = {};
    int       i = {};

    if (name == nullptr) {
        return false;
    }

    if (SearchIMGList(name) != nullptr) {
        return false;
    }

    slot = nullptr;
    i = 0;

    for (; i < img_list_num && i < static_cast<int>(std::size(img_list)); i++) {
        if (!img_list[i].resource_lifetime.IsLive() || static_cast<u_char>(!img_list[i].name) != 0) {
            slot = &img_list[i];
        }
    }

    if (slot == nullptr) {
        return false;
    }

    return slot->LoadIMGFile(name, info, memory);
}

void CMdsListSet::DeleteIMG(char *name) {
    CIMGList *img_list = SearchIMGList(name);

    if (img_list != nullptr) {
        img_list->name = nullptr;
        img_list->info = nullptr;
    }
}

CIMGList *CMdsListSet::SearchIMGList(char *name) {
    int i = {};

    for (i = 0; i < img_list_num && i < static_cast<int>(std::size(img_list)); i++) {
        if (img_list[i].resource_lifetime.IsLive() && static_cast<u_char>(!img_list[i].name) == 0 && img_list[i].name != nullptr && strcmp(img_list[i].name, name) == 0) {
            return &img_list[i];
        }
    }

    return nullptr;
}

/**
 *
 * Checks whether a texture group index addresses the supported group table.
 *
 */
static inline u_char IsImgGroup(int group) {
    return group >= 0 && group < MG_TEXTURE_IMG_GROUP_MAX;
}

/**
 *
 * Gets a texture group's starting block, or -1 for an invalid group.
 *
 */
static inline int GetImgBlock(mgCEnterIMGInfo *info, int group) {
    if (IsImgGroup(group) != 0) {
        return info->block[group];
    }

    return -1;
}

/**
 *
 * Gets a texture group's block count, or zero for an invalid group.
 *
 */
static inline int GetImgBlockNum(mgCEnterIMGInfo *info, int group) {
    if (IsImgGroup(group) != 0) {
        return info->block_num[group];
    }

    return 0;
}

int CMdsListSet::GetTextureBlockNo(int group, int *out_block, int max) {
    int count = 0;
    int i = {};

    for (i = 0; i < img_list_num && i < static_cast<int>(std::size(img_list)); i++) {
        mgCEnterIMGInfo *info = {};
        int              first_block = {};
        int              block_count = {};
        int              block = {};

        if (!img_list[i].resource_lifetime.IsLive() || static_cast<u_char>(!img_list[i].name) != 0) {
            continue;
        }

        info = img_list[i].info;

        if (info == nullptr) {
            continue;
        }

        first_block = GetImgBlock(info, group);

        if (first_block < 0) {
            continue;
        }

        block_count = GetImgBlockNum(info, group);

        if (block_count > 0) {
            for (block = 0; block < block_count; block++) {
                if (count >= max) {
                    break;
                }

                out_block[count++] = first_block + block;
            }
        }
    }

    return count;
}

void CMdsListSet::Initialize() {
    int i = {};
    int j = {};

    mds_list_num = 8;

    for (i = 0; i < mds_list_num && i < static_cast<int>(std::size(mds_list)); i++) {
        mds_list[i].resource_lifetime = {};
        mds_list[i].name = nullptr;
        mds_list[i].num = 0;
        mds_list[i].list = nullptr;
    }

    img_list_num = 16;

    for (j = 0; j < img_list_num; j++) {
        img_list[j].resource_lifetime = {};
        img_list[j].name = nullptr;
        img_list[j].info = nullptr;
    }
}

CMdsInfo *CMdsList::GetList(int index) {
    if (!resource_lifetime.IsLive() || list == nullptr || index < 0 || index >= num) {
        return nullptr;
    }

    auto &entry = list[index];
    if (!entry.resource_lifetime.IsLive()) {
        return nullptr;
    }
    if (entry.chara != nullptr) {
        const auto bytes = entry.character_storage.Bytes();
        if (bytes.size() != sizeof(CCharacter2) || bytes.data() != reinterpret_cast<const u8 *>(entry.chara) ||
            !dc2::character::ResourcesLive(*entry.chara)) {
            return nullptr;
        }
    }
    return &entry;
}

int CMdsList::GetListID(char *name) {
    int i = {};

    if (!resource_lifetime.IsLive() || list == nullptr || name == nullptr || *name == 0) {
        return -1;
    }

    for (i = 0; i < num; i++) {
        if (list[i].resource_lifetime.IsLive() && list[i].name != nullptr && strcasecmp(list[i].name, name) == 0) {
            return i;
        }
    }

    return -1;
}

CMdsInfo *CMdsList::GetList(char *name) {
    int index = {};

    index = GetListID(name);

    if (index < 0) {
        return nullptr;
    }

    return GetList(index);
}

int CIMGList::LoadIMGFile(char *name, mgCEnterIMGInfo *info, mgCMemory *memory) {
    mgCEnterIMGInfo *copy = {};
    u_int            length = {};
    u_int            blocks = {};

    if (name == nullptr || memory == nullptr || memory->lock != 0) {
        return false;
    }

    const auto lifetime = dc2::memory::ArenaLifetime::Capture(*memory);
    if (!lifetime.IsLive()) {
        return false;
    }
    const std::size_t name_length = std::strlen(name) + 1;
    if (name_length > static_cast<std::size_t>(std::numeric_limits<u_int>::max())) {
        return false;
    }
    length = static_cast<u_int>(name_length);
    blocks = align16_blocks(length);
    const u_int info_blocks = info == nullptr ? 0 : align16_blocks(sizeof(mgCEnterIMGInfo)) + 2;
    if (memory->stGetRest() <= 0 ||
        static_cast<std::size_t>(blocks) + info_blocks >= static_cast<std::size_t>(memory->stGetRest())) {
        return false;
    }
    this->name = nullptr;
    this->name = reinterpret_cast<char *>(memory->Alloc(blocks));
    if (this->name == nullptr) {
        return false;
    }
    std::memcpy(this->name, name, length);
    this->info = nullptr;

    if (info != nullptr) {
        auto *storage = memory->Alloc(align16_blocks(sizeof(mgCEnterIMGInfo)) + 2);
        if (storage == nullptr) {
            return false;
        }
        static_assert(std::is_trivially_destructible_v<mgCEnterIMGInfo>);
        this->info = new (storage) mgCEnterIMGInfo;
        copy = this->info;

        *copy = *info;
    }

    resource_lifetime = lifetime;
    return true;
}

CMdsInfo::CMdsInfo() {
    Initialize();
}

// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
// clang-format on

#include "common.h"

#include <algorithm>
#include <cstdio>
#include <cstring>
#include <limits>
#include <optional>
#include <string>
#include <vector>

#include "asset_directory.hpp"
#include "assets/data_registry.hpp"
#include "collision_assets.hpp"
#include "log/log.hpp"
#include "mdslist.hpp"
#include "mg_dataset.hpp"
#include "mglib.hpp"
#include "platform/datapacks.hpp"
#include "platform/model_assets.hpp"

namespace {
/**
 * Copies a retained gameplay name into the model's native allocation arena.
 */
char *CopyName(mgCMemory &memory, const std::string &name) {
    if (name.size() > std::numeric_limits<std::size_t>::max() - 16) {
        return nullptr;
    }
    const std::size_t blocks = (name.size() + 1 + 15) / 16 + 2;
    if (memory.lock != 0 || memory.stGetRest() <= 0 ||
        blocks >= static_cast<std::size_t>(memory.stGetRest()) ||
        blocks > static_cast<std::size_t>(std::numeric_limits<int>::max())) {
        return nullptr;
    }
    auto *copy = reinterpret_cast<char *>(memory.Alloc(static_cast<int>(blocks)));
    if (copy == nullptr) {
        return nullptr;
    }
    std::memcpy(copy, name.c_str(), name.size() + 1);
    return copy;
}

/**
 * One model of a model_list document.
 */
struct ModelEntry {
    std::optional<std::string> model;    /**< Model file in the pack, or nothing for a missing name. */
    std::optional<int>         type;     /**< Script model type, when given. */
    std::optional<float>       far_dist; /**< Far clip distance, when given. */
    int                        far_fade; /**< Whether the model fades at its far clip. */
};

/**
 * Parses a model_list document.
 */
std::vector<ModelEntry> ParseModelList(const native_config::Json &document) {
    using namespace native_config;
    std::vector<ModelEntry> models;
    for (const auto &model : Array(document, "models")) {
        ModelEntry entry{.model = GameText(At(model, "model")), .type = OptionalInt(model, "type"), .far_dist = std::nullopt, .far_fade = 0};
        if (model.contains("far_clip")) {
            const auto &clip = At(model, "far_clip");
            entry.far_dist = Float(clip, "distance");
            entry.far_fade = Int(clip, "fade");
        }
        models.push_back(std::move(entry));
    }
    return models;
}

/**
 * Converts a script model type to its stored model category; 3 and 4 both load a character.
 */
int ModelType(int type) {
    switch (type) {
        case 0:
            return MDS_TYPE_MODEL;
        case 1:
            return MDS_TYPE_COLLISION;
        case 2:
            return MDS_TYPE_CAMERA_COLLISION;
        case 3:
        case 4:
            return MDS_TYPE_CHARA;
        default:
            return type;
    }
}
} // namespace

void CMdsList::LoadPCPFile(char *label, u_int *source, mgCMemory *memory, int scissor) {
    if (!memory) {
        return;
    }
    const auto lifetime = dc2::memory::ArenaLifetime::Capture(*memory);
    if (!lifetime.IsLive()) {
        return;
    }
    const auto parent = AssetDirectoryPath(source);
    if (!parent) {
        return;
    }
    const auto models = native_config::Read<std::vector<ModelEntry>>(*parent + "/info.cfg.json", "model_list", ParseModelList);
    if (!models) {
        return;
    }
    std::string error;
    const auto  files = datapacks::DirectoryMembers(*parent);
    const auto  capacity = std::count_if(files.begin(), files.end(), [](const auto &file) { return std::filesystem::path(file).extension() == ".gltf"; });
    if (capacity > MDS_PCP_ENTRY_MAX) {
        CT_LOG_ERROR(Data, "model list: too many native models");
        return;
    }
    const std::size_t label_length = label == nullptr ? 0 : std::strlen(label);
    if (label_length > std::numeric_limits<std::size_t>::max() - 16) {
        return;
    }
    const std::size_t label_blocks = label == nullptr ? 0 : (label_length + 16) / 16 + 2;
    const std::size_t list_blocks = capacity == 0 ? 0 : (static_cast<std::size_t>(capacity) * sizeof(CMdsInfo) + 15) / 16 + 2;
    if (memory->lock != 0 || memory->stGetRest() <= 0 ||
        label_blocks + list_blocks >= static_cast<std::size_t>(memory->stGetRest())) {
        CT_LOG_ERROR(Data, "model list: insufficient memory for native model entries");
        return;
    }
    name = label ? CopyName(*memory, label) : nullptr;
    if (label != nullptr && name == nullptr) {
        return;
    }
    resource_lifetime = lifetime;
    num = static_cast<int>(capacity);
    auto *list_storage = num > 0 ? memory->Alloc(static_cast<int>(list_blocks)) : nullptr;
    list = list_storage != nullptr ? new (list_storage) CMdsInfo[num] : nullptr;
    if (num > 0 && list == nullptr) {
        num = 0;
        return;
    }
    int next = 0;
    for (const auto &model : *models) {
        // MDS past the table, or naming a model already listed, leaves no current entry.
        if (next >= num || (model.model && GetList(const_cast<char *>(model.model->c_str())))) {
            continue;
        }
        CMdsInfo *current = &list[next++];
        current->Initialize();
        current->resource_lifetime = lifetime;
        current->name = model.model ? CopyName(*memory, *model.model) : nullptr;
        if (model.type) {
            current->type = ModelType(*model.type);
        }
        if (model.far_dist) {
            current->far_dist = *model.far_dist;
            current->far_fade = model.far_fade;
        }
        if (current->name == nullptr) {
            continue;
        }
        const auto path = *parent + "/" + std::filesystem::path(current->name).filename().generic_string();
        if (current->type == MDS_TYPE_MODEL) {
            mgLoadData load{};
            load.memory = memory;
            current->frame = model_assets::LoadModel(path, load, error);
        } else if (current->type == MDS_TYPE_COLLISION || current->type == MDS_TYPE_CAMERA_COLLISION) {
            current->frame = LoadCollisionModel(path, memory);
        } else if (current->type == MDS_TYPE_CHARA) {
            auto *character = dc2::memory::NewObject<CCharacter2>(*memory);
            if (character == nullptr) {
                continue;
            }
            character->Initialize();
            model_assets::CharacterLoadOptions options{.model_memory = memory, .motion_memory = memory, .image_memory = memory, .textures = &mgTexManager, .parent = nullptr, .texture_block = -1, .outline = false};
            if (model_assets::LoadCharacter(*character, path, "info", options, error)) {
                current->character_storage = dc2::memory::ArenaBuffer::Bind(*memory, std::span<u8>(reinterpret_cast<u8 *>(character), sizeof(CCharacter2)));
                if (current->character_storage.Bytes().size() != sizeof(CCharacter2)) {
                    continue;
                }
                current->chara = character;
                current->frame = character->CObjectFrame::frame;
            }
        }
        if (scissor && current->frame) {
            mgCFrameAttr attributes{};
            attributes.clip_enable = 1;
            current->frame->SetAttrParam(attributes, 1, MG_FRAME_ATTR_CLIP);
        }
    }
}
