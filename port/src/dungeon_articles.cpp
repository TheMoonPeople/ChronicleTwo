#include "common.h"

#include <array>
#include <cstdio>
#include <format>
#include <string>

#include "dng_event.hpp"
#include "dng_hud.hpp"
#include "dng_main.hpp"
#include "dng_object.hpp"
#include "dungeon_articles.hpp"
#include "log/log.hpp"
#include "mainloop.hpp"
#include "mg_dataset.hpp"
#include "mglib.hpp"
#include "nowload.hpp"
#include "platform/model_assets.hpp"

bool PortLoadDungeonArticleModels() {
    auto             *memory = MainBuffer__2;
    const std::string bundle = std::format("dungeon/articles/pack01_{}.gltf", LanguageCode);
    const std::string children = std::format("dungeon/articles/pack01_{}.assets/", LanguageCode);
    mgLoadData        load{};
    load.memory = memory;
    load.texture_manager = &mgTexManager;
    std::string error;
    auto        model = [&](const char *name) {
        auto *frame = model_assets::LoadModelScene(bundle, name, load, error);
        if (!frame) {
            CT_LOG_ERROR(Data, "dungeon article {}: {}", name, error);
        }
        return frame;
    };
    LockOnModel.name = nullptr;
    LockOnModel.scene = DngMainScene;
    LockOnModel.frame = model("cursor");
    if (!LockOnModel.frame) {
        return false;
    }
    auto &lock_attr = *LockOnModel.frame->attr;
    lock_attr.no_light = 1;
    lock_attr.color[0] = lock_attr.color[1] = lock_attr.color[2] = 255;
    lock_attr.color[3] = 128;
    LockOnModel.frame->SetAttrParam(lock_attr, 1, MG_FRAME_ATTR_NO_LIGHT | MG_FRAME_ATTR_COLOR);
    LockOnModel.mes = MonsterMess;
    RedMarkModel = new (memory->Alloc((sizeof(CRedMarkModel) + 15) / 16 + 2)) CRedMarkModel;
    RedMarkModel->Initialize();
    RedMarkModel->frame = model("bikkuri_aka");
    if (!RedMarkModel->frame) {
        return false;
    }
    mgCFrameAttr attr;
    attr.billboard = 2;
    attr.no_light = 1;
    attr.color[0] = attr.color[1] = attr.color[2] = 255;
    attr.color[3] = 128;
    RedMarkModel->frame->SetAttrParam(attr, 1, 0);
    RedMarkModel->draw_request = false;
    model_assets::CharacterLoadOptions options{.model_memory = memory, .motion_memory = memory, .image_memory = memory};
    options.texture_block = 0xad;
    GeoStone.Initialize();
    if (!model_assets::LoadCharacter(GeoStone, children + "giostone.gltf", "info", options, error)) {
        CT_LOG_ERROR(Data, "dungeon geostone: {}", error);
        return false;
    }
    RandomCircle.Initialize();
    if (!model_assets::LoadCharacter(RandomCircle.model, children + "ring_loop.gltf", "info", options, error)) {
        CT_LOG_ERROR(Data, "dungeon circle: {}", error);
        return false;
    }
    constexpr std::array<const char *, 3> sparks{"bteffe_att_a", "bteffe_att_b", "bteffe_att_c"};
    for (std::size_t index = 0; index < sparks.size(); ++index) {
        SparcModel[index] = model(sparks[index]);
        if (!SparcModel[index]) {
            return false;
        }
    }
    TornadoModel = model("bteffe_cyc");
    if (!TornadoModel) {
        return false;
    }
    NowLoadingBarStep();
    constexpr std::array<const char *, 18> items{
        "seisui", "bom", "isi", "maseki_hi", "maseki_rei", "maseki_rai", "maseki_kaze", "maseki_sei", "tokimeki",
        "isi_berry", "neba_momo", "bom_nattu", "dokuring", "m_banana", "gift_cp", "bom_kai", "f_bom", "denkou"};
    options.texture_block = 0x68;
    options.outline = false;
    for (std::size_t index = 0; index < items.size(); ++index) {
        ItemBaseData[index].Initialize();
        if (!model_assets::LoadCharacter(ItemBaseData[index], std::format("dungeon/articles/item01b.assets/{}.gltf", items[index]), "info", options, error)) {
            CT_LOG_ERROR(Data, "dungeon item {}: {}", items[index], error);
            return false;
        }
    }
    return true;
}
