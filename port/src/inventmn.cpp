// clang-format off
// nlohmann must precede the game headers, whose macros it would otherwise see.
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"

#include <algorithm>
#include <cstring>
#include <limits>
#include <numbers>
#include <optional>
#include <string>
#include <vector>

#include "actionchara.hpp"
#include "dataread.hpp"
#include "inventmn.hpp"
#include "menuchr.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "platform/arena.hpp"
#include "scriptinterpreter.hpp"
#include "stubs/inventmn.hpp"

namespace {
struct RecipeLayout {
    std::size_t quadwords = 0;
    int         capacity = 0;
    int         rows = 0;
    bool        valid = true;
};

thread_local RecipeLayout *layout;

std::size_t Quadwords(std::size_t bytes) { return (bytes + 15) / 16; }

int CountTable(SPI_STACK *args, int /*unused*/) {
    layout->capacity = spiGetStackInt(args);
    layout->rows = 0;
    if (layout->capacity < 0) {
        layout->valid = false;
        return 0;
    }
    layout->quadwords += Quadwords(static_cast<std::size_t>(layout->capacity) * sizeof(INVENT_DATA_INFO));
    return 1;
}

int CountMaterials(SPI_STACK * /*unused*/, int argc) {
    const int count = (argc - 9) / 2;
    if (layout->rows >= layout->capacity || count <= 0) {
        return 0;
    }
    layout->quadwords += Quadwords(static_cast<std::size_t>(count) * sizeof(INVENT_MATERIAL));
    ++layout->rows;
    return 1;
}
} // namespace

PORT_OVERRIDE int CInventDataManage::LoadAnalyzeInventFile(char *script, int size) {
    if (script == nullptr) {
        return false;
    }

    // Recipe rows hold native material pointers, so the table and each separately rounded material
    // list are measured before loading instead of using the PS2 menu slot.
    RecipeLayout  measured;
    RecipeLayout *previous = layout;
    layout = &measured;
    SPI_TAG_PARAM count_tags[] = {
        {.name = "DATATABLESET", .function = CountTable    },
        {.name = "DATASET",      .function = CountMaterials},
        {.name = nullptr,        .function = nullptr       }
    };
    CScriptInterpreter counter;
    counter.SetTag(count_tags);
    counter.SetScript(script, size);
    counter.Run();
    layout = previous;
    if (!measured.valid || measured.quadwords >= static_cast<std::size_t>(std::numeric_limits<int>::max())) {
        return false;
    }

    // mgCMemory retains a spare quadword at the end of every allocation run.
    const int count = static_cast<int>(measured.quadwords + 1);
    auto     *storage = reinterpret_cast<u_long128 *>(ArenaBlock(this, static_cast<std::size_t>(count) * sizeof(u_long128)));
    InventTeigiStack.stSetBuffer(storage, count);
    InventManagePt = this;
    InventTeigiStack.lock = 0;
    CScriptInterpreter reader;
    reader.SetTag(invent_teigi_func);
    reader.SetScript(script, size);
    reader.Run();
    return true;
}

PORT_OVERRIDE void CMenuInvent::LoadCharaCheck() {
    // The photo page creates its forms from a background pack in InitEnd; another read batch
    // started before then replaces that pack's read handle.
    if (photo_only == 1 && !opened) {
        return;
    }

    auto *character = MenuActionChara[0];
    auto *memory = &MenuCharaLoadStack;
    if (chara_load_step == INVENT_CHARA_LOAD_START) {
        if (poly_chr_form[0]) {
            poly_chr_form[0]->SetActionCharaPtr(nullptr, tex_block[1], -1);
        }
        MenuLoadInfo.mode = MENU_LOAD_MODE_INVENT;
        MenuLoadInfo.load_all = true;
        MenuLoadInfo.chara_no = 0;
        MenuLoadInfo.update_scene = false;
        SetMenuLoadItemNo(0);
        MenuItemCharaDataLoad(memory, 0, MenuCharaBuild2, 0);
        chara_load_step = INVENT_CHARA_LOAD_WAIT;
        sub_chara = nullptr;
        if (photo_only == 1) {
            int size = 0;
            LoadFileBG("menu/chara4/camera.pac", memory->stGetTop(), &size);
            memory->Alloc(Quadwords(size));
            chara_read_info = GetReadBGInfo("menu/chara4/camera.pac");
        }
        return;
    }
    if (chara_load_step == INVENT_CHARA_LOAD_READY) {
        character->Step();
        return;
    }
    if (chara_load_step != INVENT_CHARA_LOAD_WAIT || ReadBGSync() != 0) {
        return;
    }

    MenuItemCharaDataLoadEndCheck(MenuCharaBuild2, nullptr, MenuActionChara, 0, tex_block[1], -1);
    character->ResetParent();
    if (MenuActionChara[3] && MenuUserParam.chara[0]->equip[2].item_no > 0) {
        character->SetRef(MenuActionChara[3], "hat");
        character->CopyOutLine(MenuActionChara[3]);
    }
    if (auto *frame = character->CObjectFrame::frame) {
        frame->attr->no_light = true;
        frame->SetAttrParam(*frame->attr, 1, MG_FRAME_ATTR_NO_LIGHT | MG_FRAME_ATTR_COLOR);
    }
    character->SetMotion("\x97\xa7\x82\xbf", 0, 1);
    if (chara_read_info) {
        int   size = 0;
        auto *pack = reinterpret_cast<u_int *>(chara_read_info->buffer);
        auto *model = AssetDirectoryRead(pack, "c01_camera.gltf", &size);
        chara_stack.stack_used = chara_stack.lock = 0;
        std::strcpy(mgTexManager.name_suffix, "_mn");
        if (model) {
            character->LoadPack(model, "info", &chara_stack, &chara_stack, &chara_stack, tex_block[1], nullptr);
        }
        auto *camera = AssetDirectoryRead(pack, "camera.gltf", &size);
        sub_chara = new (chara_stack.Alloc(Quadwords(sizeof(CActionChara)) + 2)) CActionChara;
        sub_chara->Initialize(nullptr);
        sub_chara->LoadPack(camera, "info", &chara_stack, &chara_stack, &chara_stack, tex_block[1], character);
        mgTexManager.name_suffix[0] = '\0';
        character->SetRef(sub_chara, "ef00");
        character->CopyOutLine(sub_chara);
        character->SetMotion("\x83\x4a\x83\x81\x83\x89\x97\xa7\x82\xbf", 0, 1);
    }
    character->SetPosition(album_enable == 0 && photo_only == 1 ? 15.0f : 20.0f, -29.0f, 14.0f);
    character->SetRotation(0.0f, -0.56f, 0.0f);
    character->Step();
    ExeScript("\x8d\x6c\x82\xa6\x83\x82\x81\x5b\x83\x68"
              "0");
    chara_load_step = INVENT_CHARA_LOAD_READY;
    poly_chr_form[0]->SetActionCharaPtr(character, tex_block[1], -1);
    unk_642 = unk_640 = 0;
    unk_648 = -std::numbers::pi_v<float> / 5.0f;
}

namespace {

/**
 * One scoop description of a scoop_texts document.
 */
struct ScoopText {
    int                        id;   /**< Scoop number. */
    std::optional<std::string> text; /**< Description, CP932, or nothing for a missing string. */
};

/**
 * Parses a scoop_texts document.
 */
std::vector<ScoopText> ParseScoopTexts(const native_config::Json &document) {
    std::vector<ScoopText> entries;
    for (const auto &entry : native_config::Array(document, "entries")) {
        entries.push_back({.id = native_config::Int(entry, "id"), .text = native_config::OptionalText(entry, "text")});
    }
    return entries;
}

} // namespace

PORT_OVERRIDE void AnalyzeScoopString(mgCMemory *stack, char *script, int /*size*/) {
    InitScoopString();
    const auto entries = native_config::ReadBuffer<std::vector<ScoopText> >(script, "scoop_texts", ParseScoopTexts);
    if (!entries) {
        return;
    }
    for (const auto &entry : *entries) {
        SCOOP_DATA *scoop = GetScoopDataTable(entry.id);
        if (scoop != nullptr) {
            std::string text = entry.text.value_or(std::string{});
            scoop->text = entry.text ? mgCopyString(text.data(), stack) : nullptr;
        }
    }
}
