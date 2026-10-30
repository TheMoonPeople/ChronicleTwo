#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstring>
#include <limits>
#include <memory>
#include <span>
#include <string>

#include "character.hpp"
#include "effect.hpp"
#include "effscript.hpp"
#include "mg_memory.hpp"
#include "native_script_program.hpp"
#include "platform/arena.hpp"

namespace {
class EffectWorkMemory : public testing::Test {
protected:
    void SetUp() override {
        storage = reinterpret_cast<u_long128 *>(ArenaBlock(this, 4096 * sizeof(u_long128)));
        memory.SetHeapMem(storage, 4096);
        character.Initialize();
        constexpr auto model_words = dc2::memory::ArrayQuadwords<mgCFrame>(1).value() + 16;
        auto          *model_storage = reinterpret_cast<u_long128 *>(ArenaBlock(&model_memory, model_words * sizeof(u_long128)));
        model_memory.stSetBuffer(model_storage, model_words);
        auto *model = dc2::memory::NewObject<mgCFrame>(model_memory);
        ASSERT_NE(model, nullptr);
        character.CObjectFrame::frame = model;
        ASSERT_TRUE(dc2::character::CaptureModelResources(character, model_memory));
        base.base_no = 7;
        base.texb = 10;
        base.chara = &character;
        base.script = reinterpret_cast<char *>(program.Bytes().data());
        base.script_size = program.Bytes().size();
        base.work_size = 0x7D + 0x24;
        manager.base[0] = &base;
        manager.base_num = 1;
        manager.SetWorkBuffer(&memory);
    }

    u_long128 *Fragment(int size = 164) {
        u_long128 *first = memory.StartStackMode(MG_STACK_MODE_FIT, size);
        EXPECT_NE(first, nullptr);
        memory.Alloc(size);
        memory.EndStackMode();
        u_long128 *barrier = memory.StartStackMode(MG_STACK_MODE_FIT, 4);
        EXPECT_NE(barrier, nullptr);
        memory.Alloc(4);
        memory.EndStackMode();
        std::memset(barrier, 0xA5, 4 * sizeof(u_long128));
        memory.Free(first);
        return barrier;
    }

    u_long128          *storage = nullptr;
    mgCMemory           memory;
    mgCMemory           model_memory;
    CCharacter2         character;
    NativeScriptProgram program;
    EFF_SPT_BASE        base{};
    CEffectScriptMan    manager;
};
} // namespace

TEST(EffectScriptTags, DispatchesBoundedNativeHandlersDirectly) {
    CEffectManager    manager;
    const std::string long_name(80, 'x');
    std::string       script =
        "{\"commands\":["
        "{\"command\":\"BUFFER_SIZE\",\"args\":[{\"type\":\"int\",\"value\":2},{\"type\":\"int\",\"value\":50}]},"
        "{\"command\":\"WAIT_FRAME\",\"args\":[{\"type\":\"int\",\"value\":99},{\"type\":\"int\",\"value\":12}]},"
        "{\"command\":\"IMG_NAME\",\"args\":[{\"type\":\"string\",\"value\":\"" +
        long_name + "\"}]}]}";
    int effects = 0;
    int emitters = 0;

    manager.GetBufferNums(script.data(), static_cast<int>(script.size()), &effects, &emitters);

    EXPECT_EQ(effects, 2);
    EXPECT_EQ(emitters, 8);
    EXPECT_EQ(std::strlen(manager.img_name), sizeof(manager.img_name) - 1);
    EXPECT_EQ(manager.img_name[sizeof(manager.img_name) - 1], '\0');
    EXPECT_EQ(manager.wait_frame[7], 0);
}

TEST(EffectScriptTags, EmitterNamesAndCountsStayWithinManagerTables) {
    CEffectManager             manager;
    std::array<CEffectCtrl, 9> emitters{};
    manager.EntryEffCtrls(nullptr, 0, emitters.data(), static_cast<int>(emitters.size()));
    EXPECT_EQ(manager.ctrl_num, 8);

    std::string long_name(80, 'e');
    CEffectCtrl emitter{};
    EXPECT_EQ(manager.EnterEffectCtrl(emitter, long_name.data()), 0);
    EXPECT_EQ(std::strlen(manager.ctrl_name[0]), sizeof manager.ctrl_name[0] - 1);
    EXPECT_EQ(manager.ctrl_name[0][sizeof manager.ctrl_name[0] - 1], '\0');

    manager.SetEffectNums(0, -1);
    EXPECT_EQ(manager.ctrl_num, 0);
    manager.SetEffectNums(0, 99);
    EXPECT_EQ(manager.ctrl_num, 8);
}

TEST(EffectScriptTags, NumericEmitterTagsRejectMissingAndMistypedValuesBeforeMutation) {
    const auto load_emitter = [](std::string commands) {
        CEffectManager manager;
        CEffectCtrl    emitter{};
        manager.EntryEffCtrls(nullptr, 0, &emitter, 1);
        manager.Load(commands.data(), static_cast<int>(commands.size()));
        return emitter;
    };

    const auto missing = load_emitter(
        R"({"commands":[{"command":"EFFECT_START","args":[{"type":"string","value":"missing"}]},{"command":"SIZE","args":[{"type":"float","value":9}]},{"command":"EFFECT_END","args":[]}]})");
    EXPECT_EQ(missing.entry, 1);
    EXPECT_FLOAT_EQ(missing.width, 1.0f);
    EXPECT_FLOAT_EQ(missing.height, 1.0f);

    const auto wrong_type = load_emitter(
        R"({"commands":[{"command":"EFFECT_START","args":[{"type":"string","value":"typed"}]},{"command":"SIZE","args":[{"type":"float","value":4},{"type":"float","value":5}]},{"command":"SIZE","args":[{"type":"float","value":9},{"type":"string","value":"bad"}]},{"command":"EFFECT_END","args":[]}]})");
    EXPECT_EQ(wrong_type.entry, 1);
    EXPECT_FLOAT_EQ(wrong_type.width, 4.0f);
    EXPECT_FLOAT_EQ(wrong_type.height, 5.0f);
}

TEST_F(EffectWorkMemory, SkipsAGapThatOnlyFitsTheRetailObjectBudget) {
    u_long128   *barrier = Fragment();
    _EFF_SCRIPT *effect = manager.CreateEffSpt(7, 0, 1);
    ASSERT_NE(effect, nullptr);
    EXPECT_GT(effect->work, barrier);
    EXPECT_EQ(effect->run.stack_num, 64);
    EXPECT_EQ(effect->run.call_num, 2);
    EXPECT_EQ(effect->slot, 0);
    EXPECT_EQ(manager.slot[0][0], effect);
    const auto *guard = reinterpret_cast<const unsigned char *>(barrier);
    for (int i = 0; i < 4 * sizeof(u_long128); ++i) {
        EXPECT_EQ(guard[i], 0xA5);
    }
}

TEST_F(EffectWorkMemory, RepeatedEffectsKeepTextureOrderAndOwnerSlots) {
    EFF_SPT_BASE second = base;
    EFF_SPT_BASE third = base;
    second.base_no = 8;
    second.texb = 3;
    third.base_no = 9;
    third.texb = 8;
    manager.base[1] = &second;
    manager.base[2] = &third;
    manager.base_num = 3;
    _EFF_SCRIPT *a = manager.CreateEffSpt(7, 0, 1);
    _EFF_SCRIPT *b = manager.CreateEffSpt(8, 0, 1);
    _EFF_SCRIPT *c = manager.CreateEffSpt(9, 0, 1);
    ASSERT_NE(a, nullptr);
    ASSERT_NE(b, nullptr);
    ASSERT_NE(c, nullptr);
    EXPECT_EQ(manager.head, b);
    EXPECT_EQ(b->next, c);
    EXPECT_EQ(c->prev, b);
    EXPECT_EQ(c->next, a);
    EXPECT_EQ(a->prev, c);
    EXPECT_EQ(manager.tail, a);
    EXPECT_EQ(manager.now, c);
    EXPECT_EQ(manager.slot[0][0], a);
    EXPECT_EQ(manager.slot[0][1], b);
    EXPECT_EQ(manager.slot[0][2], c);
    manager.ClearEffectFromChrid(0);
    EXPECT_EQ(manager.head, nullptr);
    EXPECT_EQ(manager.tail, nullptr);
    EXPECT_EQ(manager.slot[0][0], nullptr);
    EXPECT_EQ(manager.slot[0][1], nullptr);
    EXPECT_EQ(manager.slot[0][2], nullptr);
}

TEST_F(EffectWorkMemory, SecondaryCharactersSkipTheUndersizedFirstGap) {
    u_long128  *barrier = Fragment(128);
    _EFF_SCRIPT script{};
    script.chara = &character;
    ASSERT_TRUE(manager.AssignCharacter(&script, 1));
    EXPECT_GT(script.sub_chara_work, barrier);
    ASSERT_NE(script.sub_chara[0], nullptr);
    const auto *guard = reinterpret_cast<const unsigned char *>(barrier);
    for (int i = 0; i < 4 * sizeof(u_long128); ++i) {
        EXPECT_EQ(guard[i], 0xA5);
    }
}

TEST_F(EffectWorkMemory, SecondaryCharactersReserveAllCopies) {
    // This gap fits all retail object budgets but not all native copies.
    u_long128  *barrier = Fragment(EFF_SPT_SUB_CHARA_MAX * 0x68 + 4);
    _EFF_SCRIPT script{};
    script.chara = &character;
    ASSERT_TRUE(manager.AssignCharacter(&script, EFF_SPT_SUB_CHARA_MAX));
    EXPECT_GT(script.sub_chara_work, barrier);
    for (int i = 0; i < EFF_SPT_SUB_CHARA_MAX; ++i) {
        ASSERT_NE(script.sub_chara[i], nullptr);
        if (i != 0) {
            EXPECT_GE(reinterpret_cast<char *>(script.sub_chara[i]) -
                          reinterpret_cast<char *>(script.sub_chara[i - 1]),
                      static_cast<std::ptrdiff_t>(sizeof(CCharacter2)));
        }
    }
}

TEST_F(EffectWorkMemory, SecondaryCharacterExhaustionReportsTheNativeBudget) {
    ASSERT_NE(memory.StartStackMode(MG_STACK_MODE_FIT, 1), nullptr);
    ASSERT_NE(memory.Alloc(memory.stGetSize() - 1), nullptr);
    memory.EndStackMode();
    _EFF_SCRIPT script{};
    script.chara = &character;
    const int required = (sizeof(CCharacter2) + 15) / 16 + character.GetCopySize() + 4;
    testing::internal::CaptureStdout();
    EXPECT_FALSE(manager.AssignCharacter(&script, 1));
    const auto output = testing::internal::GetCapturedStdout();
    EXPECT_NE(output.find("es work max!! (assign character[" + std::to_string(required) + "])"), std::string::npos);
}

TEST_F(EffectWorkMemory, SpriteAllocationChecksCountAndInitializesEveryHostByte) {
    u_long128 *barrier = Fragment(64);
    EXPECT_EQ(manager.AssignSprite(-1), nullptr);
    EXPECT_EQ(manager.AssignSprite(std::numeric_limits<int>::max()), nullptr);

    _ES_SPRITE *sprites = manager.AssignSprite(2);
    ASSERT_NE(sprites, nullptr);
    const auto bytes = std::span(reinterpret_cast<const unsigned char *>(sprites),
                                 2 * sizeof(_ES_SPRITE));
    EXPECT_TRUE(std::all_of(bytes.begin(), bytes.end(), [](unsigned char byte) { return byte == 0; }));
    const auto *guard = reinterpret_cast<const unsigned char *>(barrier);
    for (int i = 0; i < 4 * sizeof(u_long128); ++i) {
        EXPECT_EQ(guard[i], 0xA5);
    }
    manager.DeleteSprite(sprites);
}

TEST_F(EffectWorkMemory, ClearBaseOutputRespectsEmptyAndSingleElementSpans) {
    base.level = 2;
    base.texb_owned = 1;
    manager.texb_used = 1;
    std::array<int, 3> sentinels{111, 222, 333};
    manager.ClearBaseFromLevel(2, std::span(sentinels).subspan(1, 0));
    EXPECT_EQ(sentinels, (std::array<int, 3>{111, 222, 333}));
    EXPECT_EQ(manager.base[0], nullptr);
    EXPECT_EQ(manager.texb_used, 0);

    manager.base[0] = &base;
    manager.texb_used = 1;
    manager.ClearBaseFromLevel(2, std::span(sentinels).subspan(1, 1));
    EXPECT_EQ(sentinels, (std::array<int, 3>{111, -1, 333}));
    EXPECT_EQ(manager.base[0], nullptr);
    EXPECT_EQ(manager.texb_used, 0);
}

TEST_F(EffectWorkMemory, LockedAndInvalidCharacterRequestsLeaveTheHeapAndSlotsUnchanged) {
    _EFF_SCRIPT script{};
    script.chara = &character;
    manager.now = &script;
    auto *heap_next = memory.heap_top->next;
    EXPECT_FALSE(manager.SetCharacter(nullptr, 0, -1));
    EXPECT_FALSE(manager.SetCharacter(&character, -1, 0));
    EXPECT_EQ(memory.heap_top->next, heap_next);
    memory.stSetLocked(true);
    EXPECT_FALSE(manager.SetCharacter(&character, 0, -1));
    EXPECT_FALSE(manager.AssignCharacter(&script, 1));
    EXPECT_EQ(manager.CreateEffSpt(7, 0, 1), nullptr);
    EXPECT_EQ(script.chara, &character);
    EXPECT_EQ(script.sub_chara_work, nullptr);
    EXPECT_EQ(manager.slot[0][0], nullptr);
    EXPECT_EQ(memory.heap_top->next, heap_next);
}

TEST_F(EffectWorkMemory, FailedCharacterCopiesReleaseTheirHeapTokenWithoutPublishingTargetsOrSubcharacters) {
    CCharacter2 previous;
    _EFF_SCRIPT script{};
    script.chara = &previous;
    script.sub_chara[0] = &previous;
    manager.now = &script;
    character.Initialize();
    auto *heap_next = memory.heap_top->next;
    EXPECT_FALSE(manager.SetCharacter(&character, 0, -1));
    EXPECT_EQ(script.chara, &previous);
    EXPECT_EQ(script.chara_work, nullptr);
    EXPECT_EQ(memory.stack_block, nullptr);
    EXPECT_EQ(memory.heap_top->next, heap_next);
    script.chara = &character;
    EXPECT_FALSE(manager.AssignCharacter(&script, 2));
    EXPECT_EQ(script.sub_chara[0], &previous);
    EXPECT_EQ(script.sub_chara[1], nullptr);
    EXPECT_EQ(script.sub_chara_work, nullptr);
    EXPECT_EQ(memory.stack_block, nullptr);
    EXPECT_EQ(memory.heap_top->next, heap_next);
    EXPECT_EQ(manager.CreateEffSpt(7, 0, 1), nullptr);
    EXPECT_EQ(manager.slot[0][0], nullptr);
    EXPECT_EQ(manager.head, nullptr);
    EXPECT_EQ(manager.tail, nullptr);
    EXPECT_EQ(memory.stack_block, nullptr);
    EXPECT_EQ(memory.heap_top->next, heap_next);
}

TEST(EffectConstruction, PoisonedEmitterStorageHasDefaultRepeatTiming) {
    alignas(CEffectCtrl) std::array<std::byte, sizeof(CEffectCtrl)> storage{};
    for (int reuse = 0; reuse < 2; ++reuse) {
        storage.fill(std::byte{0xA5});
        auto *emitter = std::construct_at(reinterpret_cast<CEffectCtrl *>(storage.data()));
        EXPECT_EQ(emitter->repeat_wait_now, 0);
        EXPECT_EQ(emitter->texture, nullptr);
        EXPECT_EQ(emitter->entry, 0);
        EXPECT_EQ(emitter->run, 0);
        EXPECT_EQ(emitter->width, 1.0f);
        std::destroy_at(emitter);
    }
}

TEST(EffectConstruction, PoisonedPoolsAndCatalogEntriesHaveInitializedInactiveState) {
    alignas(CEffectManager) std::array<std::byte, sizeof(CEffectManager)> storage{};
    storage.fill(std::byte{0xA5});
    auto *manager = std::construct_at(reinterpret_cast<CEffectManager *>(storage.data()));
    EXPECT_EQ(manager->effects, nullptr);
    EXPECT_EQ(manager->effect_num, 0);
    EXPECT_EQ(manager->ctrls, nullptr);
    EXPECT_EQ(manager->ctrl_num, 0);
    EXPECT_EQ(manager->ctrl_index, -1);
    EXPECT_EQ(manager->name[31], char{});
    EXPECT_EQ(manager->ctrl_name[7][31], char{});
    EXPECT_EQ(manager->img_name[31], char{});
    std::destroy_at(manager);
}

TEST(EffectRectangles, EmissionCopiesCanonicalComponentsAndHandlesAnEmptyAnimationList) {
    for (int rectangles : {0, 2}) {
        CEffectCtrl emitter;
        emitter.entry = 1;
        emitter.num = 1;
        emitter.count = 12;
        emitter.tex_get_type = 1;
        emitter.tex_rect_num = rectangles;
        for (int rectangle = 0; rectangle < 8; ++rectangle) {
            for (int component = 0; component < 4; ++component) {
                emitter.tex_rect[rectangle][component] = rectangle * 10 + component;
            }
        }
        CEffect particle;
        emitter.Run();
        emitter.Ctrl(&particle, 1);
        ASSERT_EQ(particle.active, 1);
        EXPECT_EQ(particle.param.tex_frame, rectangles == 0 ? 12 : 6);
        for (int rectangle = 0; rectangle < 8; ++rectangle) {
            for (int component = 0; component < 4; ++component) {
                EXPECT_EQ(particle.param.tex_rect[rectangle][component], rectangle * 10 + component);
            }
        }
    }
    CEffectCtrl invalid;
    invalid.entry = 1;
    invalid.num = 1;
    invalid.tex_rect_num = 9;
    CEffect particle;
    invalid.Run();
    invalid.Ctrl(&particle, 1);
    EXPECT_EQ(particle.active, 0);
}
