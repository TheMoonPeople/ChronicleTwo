#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <limits>
#include <memory>
#include <new>
#include <set>
#include <span>
#include <string>
#include <vector>

#include "character.hpp"
#include "effscript.hpp"
#include "gfx/displaylist.hpp"
#include "gfx/gfx.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "native_script_program.hpp"
#include "platform/arena.hpp"
#include "render/renderer.hpp"
#include "render/sprite_batch.hpp"
#include "scenesnd.hpp"
#include "scoped_global_object.hpp"
#include "script/effect_script_runtime.hpp"

/**
 * Assigns sprite storage to the running effect.
 */
int _SPT_ASSIGN_SPRITE(dc2::script::RunArguments stack, int argument_count);
/**
 * Resets the selected sprite slots of the running effect.
 */
int _SPT_INIT_SPRITE(dc2::script::RunArguments stack, int argument_count);
/**
 * Releases the running effect's sprite storage.
 */
int _SPT_DELETE_SPRITE(dc2::script::RunArguments arguments, int argument_count);

/**
 * Updates colors of a bounded effect sprite range.
 */
int _SPT_SET_COLOR(dc2::script::RunArguments stack, int argument_count);
/**
 * Updates successive colors using color velocity and acceleration.
 */
int _SPT_VAN_SET_COL(dc2::script::RunArguments stack, int argument_count);

namespace {

/**
 * Records a model draw or billboard batch from the effect manager.
 */
struct Event {
    bool                       model = false;                         /**< Whether this event represents a model draw. */
    const CCharacter2         *chara = nullptr;                       /**< Model whose draw was captured. */
    float                      position[4] = {};                      /**< Model position at draw time. */
    gfx::Primitive             primitive = gfx::Primitive::Triangles; /**< Primitive topology of the captured billboards. */
    std::vector<gfx::Vertex2D> vertices;                              /**< Vertices submitted by the billboard batch. */
    gfx::DrawState             state;                                 /**< Render state of the captured billboard batch. */
    gfx::Interp2D              tag{};                                 /**< Interpolation tag active during the draw. */
};

/**
 * Receives model and billboard draws from the active fixture.
 */
std::vector<Event> *event_log = nullptr;

/**
 * Logs model draw positions alongside billboard batches.
 */
class LoggedModel final : public CCharacter2 {
public:
    /**
     * Records the model's current position in draw order.
     */
    int DrawDirect() override {
        Event event{.model = true, .chara = this};
        GetPosition(event.position);
        event_log->push_back(event);
        return 0;
    }
};

/**
 * Restores the screen offsets after drawing with test offsets.
 */
class ScreenOffsetScope {
public:
    /**
     * Installs test screen offsets while retaining the previous values.
     */
    ScreenOffsetScope(int x, int y) : saved_x(mgScreenOffx), saved_y(mgScreenOffy) {
        mgScreenOffx = x;
        mgScreenOffy = y;
    }

    /**
     * Restores the screen offsets that preceded the scope.
     */
    ~ScreenOffsetScope() {
        mgScreenOffx = saved_x;
        mgScreenOffy = saved_y;
    }

    /**
     * Prevents copying ownership of saved screen offsets.
     */
    ScreenOffsetScope(const ScreenOffsetScope &) = delete;
    /**
     * Prevents replacing a scope's saved screen offsets.
     */
    ScreenOffsetScope &operator=(const ScreenOffsetScope &) = delete;

private:
    int saved_x; /**< Screen x offset preceding the scope. */
    int saved_y; /**< Screen y offset preceding the scope. */
};

/**
 * Configures a camera whose origin projects to the GS centre.
 */
void SetOriginCamera(mgRENDER_INFO &render_info) {
    constexpr float depth_w = 4.0f;
    render_info.world_screen[0][0] = 2.0f;
    render_info.world_screen[1][1] = 2.0f;
    render_info.world_screen[2][2] = 1.0f;
    render_info.world_screen[3][0] = 2048.0f * depth_w;
    render_info.world_screen[3][1] = 2048.0f * depth_w;
    render_info.world_screen[3][2] = 10.0f * depth_w;
    render_info.world_screen[3][3] = depth_w;
    render_info.view_screen[0][0] = 2.0f;
    render_info.view_screen[1][1] = 2.0f;
    render_info.guard_min[3] = 1.0f;
    render_info.guard_max[3] = 200.0f;
}

/**
 * Identity transform for recorded sprite draws.
 */
float kIdentity[4][4] = {
    {1.0f, 0.0f, 0.0f, 0.0f},
    {0.0f, 1.0f, 0.0f, 0.0f},
    {0.0f, 0.0f, 1.0f, 0.0f},
    {0.0f, 0.0f, 0.0f, 1.0f}
};

/**
 * Creates an integer script argument.
 */
RS_STACKDATA Int(int value) {
    RS_STACKDATA slot{};
    slot.type = RS_INT;
    slot.val.i = value;
    return slot;
}

/**
 * Finds the effect base associated with a script name.
 */
int BaseNo(const char *script) {
    for (int i = 0; i < EFF_SPT_BASE_DEF_NUM; ++i) {
        if (std::strcmp(eff_spt_base_def[i].script, script) == 0) {
            return i;
        }
    }
    return -1;
}

/**
 * Returns the interpolation key of an effect sprite.
 */
gfx::InterpKey Key(const _EFF_SCRIPT *effect, int index) {
    return static_cast<gfx::InterpKey>(reinterpret_cast<uintptr_t>(&effect->sprite[index]));
}

/**
 * Captures recovery and ordinary effects with their draw order and interpolation tags.
 */
class EffectSprites : public testing::Test {
protected:
    /**
     * Creates the effect manager, camera and billboard capture sink.
     */
    void SetUp() override {
        storage = reinterpret_cast<u_long128 *>(ArenaBlock(this, 8192 * sizeof(u_long128)));
        memory.SetHeapMem(storage, 8192);
        heal.base_no = BaseNo("n_heal");
        other.base_no = BaseNo("gun_flash");
        ASSERT_GE(heal.base_no, 0);
        ASSERT_GE(other.base_no, 0);
        for (EFF_SPT_BASE *base : {&heal, &other}) {
            base->texb = 0;
            base->script = reinterpret_cast<char *>(program.Bytes().data());
            base->script_size = program.Bytes().size();
        }
        manager.base[0] = &heal;
        manager.base[1] = &other;
        manager.base_num = 2;
        manager.SetWorkBuffer(&memory);
        SetOriginCamera(render_info);
        draw_manager.render_info = &render_info;
        event_log = &events;
        mgPortSet3DSpriteSink([](gfx::Primitive primitive, std::span<const gfx::Vertex2D> vertices,
                                 const gfx::TextureBinding &, const gfx::DrawState       &state) {
            event_log->push_back({
                .primitive = primitive,
                .vertices = {vertices.begin(), vertices.end()},
                .state = state,
                .tag = gfx::CurrentInterp2D()
            });
        });
    }

    /**
     * Clears effects and restores the global capture seams.
     */
    void TearDown() override {
        manager.AllClearEffSpt();
        mgPortSet3DSpriteSink({});
        PortSetRunningEffect(nullptr, nullptr);
        event_log = nullptr;
    }

    /**
     * Creates an effect from the requested base.
     */
    _EFF_SCRIPT *Start(const EFF_SPT_BASE &base) {
        _EFF_SCRIPT *effect = manager.CreateEffSpt(base.base_no, 0, 1);
        EXPECT_NE(effect, nullptr);
        return effect;
    }

    /**
     * Assigns four sprites with additive, hidden and translucent test cases.
     */
    void GiveSprites(_EFF_SCRIPT *effect) {
        PortSetRunningEffect(&manager, effect);
        RS_STACKDATA count = Int(4);
        ASSERT_EQ(_SPT_ASSIGN_SPRITE(dc2::script::RunArguments(std::span(&count, 1)), 1), 1);
        for (int i = 0; i < 4; ++i) {
            _ES_SPRITE &sprite = effect->sprite[i];
            sprite = {};
            sprite.draw_flag = i == 1 ? 0 : 1;
            sprite.alpha = i == 3 ? MG_ALPHA_MACRO_BLEND : MG_ALPHA_MACRO_ADD;
            sprite.pos[0] = static_cast<float>(i);
            sprite.pos[3] = 1.0f;
            sprite.uv[2] = sprite.uv[3] = 16.0f;
            sprite.color[0] = sprite.color[1] = sprite.color[2] = sprite.color[3] = 128.0f;
            sprite.scale[0] = sprite.scale[1] = 1.0f;
            sprite.put_size[0] = 8.0f;
            sprite.put_size[1] = 6.0f;
            sprite.rotz = 0.25f * static_cast<float>(i);
        }
        PortSetRunningEffect(nullptr, nullptr);
    }

    /**
     * Captures the sprite batches drawn for one effect frame.
     */
    std::vector<Event> Draw(_EFF_SCRIPT *effect) {
        events.clear();
        mgC3DSprite renderer;
        renderer.BeginCreatePacket(MG_3DSPRITE_MODE_ROTATE, &draw_manager);
        float offset[4] = {0.0f, 0.0f, 0.0f, 0.0f};
        PortDrawEffectSprites(effect, &texture, offset, &renderer);
        renderer.EndCreatePacket();
        renderer.Draw(nullptr, kIdentity, &draw_manager);
        return events;
    }

    /**
     * Finds the display-list entry associated with a sprite key.
     */
    static gfx::detail::Draw2DEntry Entry(const std::vector<Event> &frame, gfx::InterpKey key) {
        for (const Event &event : frame) {
            if (!event.model && event.tag.key == key) {
                gfx::detail::Draw2DEntry entry{};
                entry.primitive = event.primitive;
                entry.vertices = event.vertices;
                entry.state = event.state;
                entry.scene = 0;
                entry.interpolation = event.tag;
                return entry;
            }
        }
        ADD_FAILURE() << "no draw keyed " << key;
        return {};
    }

    /**
     * Interpolates a display frame halfway between two recorded sprite frames.
     */
    static bool Blend(const gfx::detail::Draw2DEntry &before, const gfx::detail::Draw2DEntry &after,
                      std::vector<gfx::Vertex2D> &result) {
        gfx::detail::Mat4 identity{};
        identity[0] = identity[5] = identity[10] = identity[15] = 1.0f;
        const gfx::detail::SpriteScene scene{
            .camera = 0, .projection = identity, .to_clip = {1.0f, 1.0f, 0.0f, 0.0f}
        };
        return gfx::detail::InterpolateSprite(before, scene, identity, after, scene, identity, identity, 0.5f, result);
    }

    ScreenOffsetScope   screen_offset{0x800, 0x800}; /**< Screen offset scope shared by sprite draws. */
    std::vector<Event>  events;                      /**< Ordered model and billboard draws. */
    u_long128          *storage = nullptr;           /**< Arena backing the effect manager's work memory. */
    mgCMemory           memory;                      /**< Primary effect work memory. */
    mgCMemory           other_memory;                /**< Independent work memory for a peer manager. */
    NativeScriptProgram program;                     /**< Complete script program used by test effects. */
    EFF_SPT_BASE        heal{};                      /**< Recovery effect base configured for interpolation. */
    EFF_SPT_BASE        other{};                     /**< Ordinary effect base retaining retail batches. */
    CEffectScriptMan    manager;                     /**< Effect manager exercised by the fixture. */
    mgRENDER_INFO       render_info{};               /**< Camera state used for projection. */
    LoggedModel         draw_models[2]{};            /**< Models whose lifetime includes effect-manager cleanup. */
    mgCDrawManager      draw_manager;                /**< Draw manager exposing the fixture camera. */
    mgCTexture          texture;                     /**< Texture supplied to captured sprite draws. */
};

} // namespace

TEST_F(EffectSprites, RecoveryEffectDrawsEachVisibleSpriteUnderItsOwnKey) {
    _EFF_SCRIPT *effect = Start(heal);
    ASSERT_NE(effect, nullptr);
    GiveSprites(effect);

    const auto frame = Draw(effect);
    ASSERT_EQ(frame.size(), 3u);
    std::set<gfx::InterpKey> keys;
    std::set<uint64_t>       incarnations;
    for (const Event &event : frame) {
        EXPECT_EQ(event.primitive, gfx::Primitive::Triangles);
        EXPECT_EQ(event.vertices.size(), 6u); // One sprite per draw, so a hidden sprite shifts no other's match.
        EXPECT_TRUE(event.tag.world_corners);
        EXPECT_EQ(event.tag.teleport_distance, kMgPortFrameTeleportDistance);
        keys.insert(event.tag.key);
        incarnations.insert(event.tag.generation);
    }
    EXPECT_EQ(keys, (std::set<gfx::InterpKey>{Key(effect, 0), Key(effect, 2), Key(effect, 3)}));
    EXPECT_EQ(incarnations.size(), 3u);
    EXPECT_EQ(PortEffectSpriteTag(effect, 2).key, Key(effect, 2));
    EXPECT_EQ(PortEffectSpriteTag(effect, 4).key, 0u);
    EXPECT_EQ(gfx::CurrentInterp2D().key, 0u);

    // The next game frame matches every sprite with itself.
    const auto next = Draw(effect);
    ASSERT_EQ(next.size(), 3u);
    for (size_t i = 0; i < next.size(); ++i) {
        EXPECT_EQ(next[i].tag.key, frame[i].tag.key);
        EXPECT_EQ(next[i].tag.generation, frame[i].tag.generation);
    }
}

TEST_F(EffectSprites, ASlotResetAndShownAgainInPlaceKeepsItsNewestCorners) {
    _EFF_SCRIPT *effect = Start(heal);
    ASSERT_NE(effect, nullptr);
    GiveSprites(effect);
    const auto before = Draw(effect);

    // Between two game frames the script resets slot 0, puts it elsewhere and shows it again: a new particle, never
    // hidden in a recorded frame. Slot 2 just drifts.
    PortSetRunningEffect(&manager, effect);
    RS_STACKDATA slot = Int(0);
    ASSERT_EQ(_SPT_INIT_SPRITE(dc2::script::RunArguments(std::span(&slot, 1)), 1), 1);
    PortSetRunningEffect(nullptr, nullptr);
    _ES_SPRITE &reset = effect->sprite[0];
    EXPECT_EQ(reset.draw_flag, 0); // Retail's reset ran.
    reset.draw_flag = 1;
    reset.alpha = MG_ALPHA_MACRO_ADD;
    reset.pos[1] = 3.0f;
    reset.uv[2] = reset.uv[3] = 16.0f;
    reset.put_size[0] = 8.0f;
    reset.put_size[1] = 6.0f;
    effect->sprite[2].pos[1] = 1.0f;
    const auto after = Draw(effect);
    ASSERT_EQ(after.size(), 3u);

    const auto old_particle = Entry(before, Key(effect, 0));
    const auto new_particle = Entry(after, Key(effect, 0));
    EXPECT_NE(new_particle.interpolation.generation, old_particle.interpolation.generation);
    std::vector<gfx::Vertex2D> result;
    EXPECT_FALSE(Blend(old_particle, new_particle, result));
    ASSERT_EQ(result.size(), new_particle.vertices.size());
    for (size_t i = 0; i < result.size(); ++i) {
        EXPECT_EQ(result[i].x, new_particle.vertices[i].x);
        EXPECT_EQ(result[i].y, new_particle.vertices[i].y);
    }

    const auto drifted_before = Entry(before, Key(effect, 2));
    const auto drifted_after = Entry(after, Key(effect, 2));
    EXPECT_EQ(drifted_after.interpolation.generation, drifted_before.interpolation.generation);
    ASSERT_TRUE(Blend(drifted_before, drifted_after, result));
    EXPECT_NE(result[0].y, drifted_after.vertices[0].y);
    EXPECT_NEAR(result[0].y, (drifted_before.vertices[0].y + drifted_after.vertices[0].y) / 2.0f, 0.01f);
}

TEST_F(EffectSprites, SpritesReassignedWhereTheLastStoodAreNewParticles) {
    _EFF_SCRIPT *effect = Start(heal);
    ASSERT_NE(effect, nullptr);
    GiveSprites(effect);
    const _ES_SPRITE *first = effect->sprite;
    const uint64_t    incarnation = PortEffectSpriteTag(effect, 0).generation;

    PortSetRunningEffect(&manager, effect);
    ASSERT_EQ(InvokeNativeExternal(dc2::script::AdaptRunArguments<_SPT_DELETE_SPRITE>, {}), 1);
    PortSetRunningEffect(nullptr, nullptr);
    GiveSprites(effect);
    ASSERT_EQ(effect->sprite, first); // The work memory gave the same address back.
    EXPECT_NE(PortEffectSpriteTag(effect, 0).generation, incarnation);
}

TEST_F(EffectSprites, TwoRecoveryEffectsKeepTheirOwnKeysAndIncarnations) {
    _EFF_SCRIPT *a = Start(heal);
    _EFF_SCRIPT *b = Start(heal);
    ASSERT_NE(a, nullptr);
    ASSERT_NE(b, nullptr);
    GiveSprites(a);
    GiveSprites(b);
    EXPECT_EQ(PortRecoveryEffectCount(), 2u);

    std::set<gfx::InterpKey> keys;
    std::set<uint64_t>       incarnations;
    for (_EFF_SCRIPT *effect : {a, b}) {
        for (const Event &event : Draw(effect)) {
            EXPECT_TRUE(keys.insert(event.tag.key).second);
            EXPECT_TRUE(incarnations.insert(event.tag.generation).second);
        }
    }
    EXPECT_EQ(keys.size(), 6u);

    // Stopping one leaves the other's sprites as they were.
    const uint64_t kept = PortEffectSpriteTag(b, 0).generation;
    manager.DeleteEffSpt(a);
    EXPECT_EQ(PortRecoveryEffectCount(), 1u);
    EXPECT_EQ(PortEffectSpriteTag(b, 0).generation, kept);
}

TEST_F(EffectSprites, AnEffectStartedWhereTheLastStoodIsANewEmissionAndClearsLeaveNothing) {
    _EFF_SCRIPT *effect = Start(heal);
    ASSERT_NE(effect, nullptr);
    GiveSprites(effect);
    std::set<uint64_t> seen;
    for (int i = 0; i < 4; ++i) {
        seen.insert(PortEffectSpriteTag(effect, i).generation);
    }

    _EFF_SCRIPT *flash = Start(other);
    ASSERT_NE(flash, nullptr);
    EXPECT_EQ(PortRecoveryEffectCount(), 1u); // Only opted-in effects keep incarnations.
    manager.ClearEffectFromChrid(0);
    EXPECT_EQ(PortRecoveryEffectCount(), 0u);

    _EFF_SCRIPT *again = Start(heal);
    ASSERT_EQ(again, effect); // The work memory gave the same address back.
    GiveSprites(again);
    for (int i = 0; i < 4; ++i) {
        EXPECT_FALSE(seen.contains(PortEffectSpriteTag(again, i).generation));
    }
    manager.AllClearEffSpt();
    EXPECT_EQ(PortRecoveryEffectCount(), 0u);
}

TEST_F(EffectSprites, RejectsNaNResetIndexWithoutChangingParticleIdentity) {
    _EFF_SCRIPT *effect = Start(heal);
    ASSERT_NE(effect, nullptr);
    GiveSprites(effect);
    uint64_t                            before[4];
    std::array<int, 4>                  draw_flags{};
    std::array<std::array<float, 4>, 4> positions{};
    for (int i = 0; i < 4; ++i) {
        before[i] = PortEffectSpriteTag(effect, i).generation;
        draw_flags[i] = effect->sprite[i].draw_flag;
        std::copy_n(effect->sprite[i].pos, 4, positions[i].begin());
    }

    PortSetRunningEffect(&manager, effect);
    RS_STACKDATA index{};
    index.type = RS_FLOAT;
    index.val.f = std::numeric_limits<float>::quiet_NaN();
    EXPECT_EQ(InvokeNativeExternal(dc2::script::AdaptRunArguments<_SPT_INIT_SPRITE>, std::span(&index, 1)), 0);
    PortSetRunningEffect(nullptr, nullptr);

    for (int i = 0; i < 4; ++i) {
        EXPECT_EQ(effect->sprite[i].draw_flag, draw_flags[i]);
        EXPECT_EQ(PortEffectSpriteTag(effect, i).generation, before[i]);
        for (int component = 0; component < 4; ++component) {
            EXPECT_FLOAT_EQ(effect->sprite[i].pos[component], positions[i][component]);
        }
    }
}

TEST_F(EffectSprites, ARefusedSecondAssignmentChangesNothing) {
    _EFF_SCRIPT *effect = Start(heal);
    ASSERT_NE(effect, nullptr);
    GiveSprites(effect);
    const _ES_SPRITE       *sprites = effect->sprite;
    const std::vector<char> contents(reinterpret_cast<const char *>(sprites),
                                     reinterpret_cast<const char *>(sprites + effect->sprite_num));
    uint64_t                before[4];
    for (int i = 0; i < 4; ++i) {
        before[i] = PortEffectSpriteTag(effect, i).generation;
    }

    // Retail refuses to assign sprites to an effect that has them, and leaves the result slot alone.
    PortSetRunningEffect(&manager, effect);
    RS_STACKDATA arguments[2] = {Int(8), Int(77)};
    EXPECT_EQ(_SPT_ASSIGN_SPRITE(dc2::script::RunArguments(arguments), 2), 0);
    PortSetRunningEffect(nullptr, nullptr);

    EXPECT_EQ(arguments[1].val.i, 77);
    EXPECT_EQ(effect->sprite, sprites);
    EXPECT_EQ(effect->sprite_num, 4);
    EXPECT_EQ(std::memcmp(contents.data(), effect->sprite, contents.size()), 0);
    for (int i = 0; i < 4; ++i) {
        EXPECT_EQ(PortEffectSpriteTag(effect, i).generation, before[i]);
    }
}

TEST_F(EffectSprites, RetiringAManagerAndItsArenaForgetsOnlyItsEffects) {
    // A second manager, with a work memory of its own, runs a recovery effect throughout.
    auto *other_storage = reinterpret_cast<u_long128 *>(ArenaBlock(&other_memory, 4096 * sizeof(u_long128)));
    other_memory.SetHeapMem(other_storage, 4096);
    CEffectScriptMan other_manager; /**< Effect manager exercised by the fixture. */
    other_manager.base[0] = &heal;
    other_manager.base_num = 1;
    other_manager.SetWorkBuffer(&other_memory);
    _EFF_SCRIPT *survivor = other_manager.CreateEffSpt(heal.base_no, 0, 1);
    ASSERT_NE(survivor, nullptr);
    const uint64_t kept = PortEffectSpriteTag(survivor, 0).generation;

    // A game mode ends with a recovery effect still running, and its arena is reused without a clear: the manager is
    // built again where it stood, as dungeon set-up does.
    _EFF_SCRIPT *effect = Start(heal);
    ASSERT_NE(effect, nullptr);
    GiveSprites(effect);
    ASSERT_EQ(PortRecoveryEffectCount(), 2u);
    memory.SetHeapMem(storage, 8192);
    manager.~CEffectScriptMan();
    new (&manager) CEffectScriptMan;
    EXPECT_EQ(PortRecoveryEffectCount(), 1u);
    EXPECT_EQ(manager.head, nullptr);

    // The other manager's effect is untouched.
    EXPECT_EQ(PortEffectSpriteTag(survivor, 0).generation, kept);
    other_manager.AllClearEffSpt();
    EXPECT_EQ(PortRecoveryEffectCount(), 0u);
}

TEST_F(EffectSprites, AnUnchangedHeapHandedToAnotherManagerKeepsALivePeersEffect) {
    _EFF_SCRIPT *effect = Start(heal);
    ASSERT_NE(effect, nullptr);
    GiveSprites(effect);
    const uint64_t incarnation = PortEffectSpriteTag(effect, 0).generation;

    // Another manager is given the same work memory, which nothing reset: the first manager's effect still lives.
    CEffectScriptMan peer;
    peer.SetWorkBuffer(&memory);
    EXPECT_EQ(PortRecoveryEffectCount(), 1u);
    EXPECT_EQ(PortEffectSpriteTag(effect, 0).generation, incarnation);
    const auto frame = Draw(effect);
    ASSERT_EQ(frame.size(), 3u);
    for (const Event &event : frame) {
        EXPECT_TRUE(event.tag.world_corners);
    }
}

TEST_F(EffectSprites, AnEffectStartedWhereARetiredOneStoodReplacesItsEntry) {
    _EFF_SCRIPT *effect = Start(heal);
    ASSERT_NE(effect, nullptr);
    GiveSprites(effect);
    std::set<uint64_t> retired;
    for (int i = 0; i < 4; ++i) {
        retired.insert(PortEffectSpriteTag(effect, i).generation);
    }

    // A new heap lifetime retires the old incarnation metadata before any address is reused.
    memory.SetHeapMem(storage, 8192);
    CEffectScriptMan successor;
    successor.base[0] = &heal;
    successor.base[1] = &other;
    successor.base_num = 2;
    successor.SetWorkBuffer(&memory);
    EXPECT_EQ(PortRecoveryEffectCount(), 0u);
    EXPECT_EQ(PortEffectSpriteTag(effect, 0).key, 0U);

    _EFF_SCRIPT *again = successor.CreateEffSpt(heal.base_no, 0, 1);
    ASSERT_EQ(again, effect);
    PortSetRunningEffect(&successor, again);
    RS_STACKDATA count = Int(4);
    ASSERT_EQ(_SPT_ASSIGN_SPRITE(dc2::script::RunArguments(std::span(&count, 1)), 1), 1);
    PortSetRunningEffect(nullptr, nullptr);
    EXPECT_EQ(PortRecoveryEffectCount(), 1u);
    for (int i = 0; i < 4; ++i) {
        EXPECT_FALSE(retired.contains(PortEffectSpriteTag(again, i).generation));
    }

    // Retired again, the address now goes to an effect that does not interpolate: the dead entry goes with it.
    memory.SetHeapMem(storage, 8192);
    new (&manager) CEffectScriptMan; // The first manager is never used again; rebuilt only so teardown finds it empty.
    manager.base[0] = &other;
    manager.base_num = 1;
    manager.SetWorkBuffer(&memory);
    EXPECT_EQ(PortRecoveryEffectCount(), 0u);
    ASSERT_EQ(manager.CreateEffSpt(other.base_no, 0, 1), again);
    EXPECT_EQ(PortRecoveryEffectCount(), 0u);
}

TEST_F(EffectSprites, OtherEffectsAndEnclosingTagsKeepRetailBatches) {
    _EFF_SCRIPT *effect = Start(other);
    ASSERT_NE(effect, nullptr);
    GiveSprites(effect);
    EXPECT_EQ(PortEffectSpriteTag(effect, 0).key, 0u);

    // Retail batches by blend: the two additive sprites, then the translucent one.
    auto frame = Draw(effect);
    ASSERT_EQ(frame.size(), 2u);
    EXPECT_EQ(frame[0].vertices.size(), 12u);
    EXPECT_EQ(frame[1].vertices.size(), 6u);
    EXPECT_EQ(frame[0].tag.key, 0u);
    EXPECT_EQ(frame[1].tag.key, 0u);

    // The player's effects on the dungeon pause frame stay under the pause frame's tag.
    _EFF_SCRIPT *recovery = Start(heal);
    ASSERT_NE(recovery, nullptr);
    GiveSprites(recovery);
    {
        const gfx::Interp2DScope pause({.key = 0x504C415945464643, .generation = 7});
        frame = Draw(recovery);
    }
    ASSERT_EQ(frame.size(), 2u);
    EXPECT_EQ(frame[0].vertices.size(), 12u);
    for (const Event &event : frame) {
        EXPECT_EQ(event.tag.key, 0x504C415945464643u);
        EXPECT_FALSE(event.tag.world_corners);
    }
}

TEST_F(EffectSprites, ManagerDrawsEveryModelThenEverySpriteBatch) {
    std::vector<u_long128> table(8192);
    mgCMemory              table_memory; /**< Primary effect work memory. */
    table_memory.stSetBuffer(table.data(), static_cast<int>(table.size()));
    mgTexManager.SetTableBuffer(16, 4, &table_memory);
    mgTexManager.Initialize(0x1000, -1);
    std::vector<u_long128> pixels(4);
    u_long128             *images[MG_TEXTURE_LEVEL_MAX] = {pixels.data()};
    char                   name[] = "n_heal";
    ASSERT_NE(mgTexManager.EnterTexture(0, name, images, 2, 2, 32, nullptr, 0, 0), nullptr);

    auto                                                     scene = dc2::test::BindGlobalOwner<now_scene>(std::make_unique<CScene>());
    dc2::test::ScopedGlobalObject<mgDrawManager.render_info> render_owner(render_info);
    auto                                                    &models = draw_models;

    // The recovery effect starts first, so it is drawn first; each has a model to show the passes' order.
    _EFF_SCRIPT *recovery = Start(heal);
    _EFF_SCRIPT *flash = Start(other);
    ASSERT_NE(recovery, nullptr);
    ASSERT_NE(flash, nullptr);
    _EFF_SCRIPT *effects[2] = {recovery, flash};
    for (int e = 0; e < 2; ++e) {
        GiveSprites(effects[e]);
        std::strcpy(effects[e]->tex_name, name);
        models[e].Initialize();
        models[e].SetPosition(1.0f, 2.0f, 3.0f);
        effects[e]->chara = &models[e];
        effects[e]->origin[0] = 5.0f;
    }
    ASSERT_EQ(manager.head, recovery);

    events.clear();
    manager.Draw();

    // Both models, at the effect's origin, then the recovery effect's sprites one by one, then the other's two
    // retail batches.
    ASSERT_EQ(events.size(), 7u);
    for (int e = 0; e < 2; ++e) {
        ASSERT_TRUE(events[e].model);
        EXPECT_EQ(events[e].chara, &models[e]);
        EXPECT_FLOAT_EQ(events[e].position[0], 6.0f);
        EXPECT_FLOAT_EQ(events[e].position[1], 2.0f);
        float position[4];
        models[e].GetPosition(position);
        EXPECT_FLOAT_EQ(position[0], 1.0f); // Put back after its draw.
    }
    const gfx::InterpKey expected[5] = {Key(recovery, 0), Key(recovery, 2), Key(recovery, 3), 0, 0};
    const size_t         sizes[5] = {6, 6, 6, 12, 6};
    for (int i = 0; i < 5; ++i) {
        const Event &event = events[2 + i];
        ASSERT_FALSE(event.model);
        EXPECT_EQ(event.tag.key, expected[i]);
        EXPECT_EQ(event.tag.world_corners, i < 3);
        EXPECT_EQ(event.vertices.size(), sizes[i]);
        EXPECT_NE(event.state.depth_test, gfx::DepthTest::Always);
        EXPECT_FALSE(event.state.depth_write);
        EXPECT_TRUE(event.state.blend);
    }
    // An additive sprite draws with the same state in its own batch as in retail's.
    EXPECT_TRUE(events[2].state == events[5].state);
    EXPECT_FALSE(events[5].state == events[6].state);
    EXPECT_EQ(gfx::CurrentInterp2D().key, 0u);
}

TEST_F(EffectSprites, InvalidSpriteRangesLeaveEverySpriteUnchanged) {
    _EFF_SCRIPT *effect = Start(heal);
    ASSERT_NE(effect, nullptr);
    GiveSprites(effect);
    const auto                   bytes = std::as_bytes(std::span(effect->sprite, static_cast<std::size_t>(effect->sprite_num)));
    const std::vector<std::byte> before(bytes.begin(), bytes.end());
    PortSetRunningEffect(&manager, effect);
    for (const int count : {-1, std::numeric_limits<int>::max(), effect->sprite_num + 1}) {
        RS_STACKDATA arguments[] = {Int(0), Int(1), Int(2), Int(3), Int(4), Int(count)};
        EXPECT_EQ(_SPT_SET_COLOR(dc2::script::RunArguments(arguments), 6), 0);
        EXPECT_TRUE(std::equal(bytes.begin(), bytes.end(), before.begin()));
    }
    RS_STACKDATA short_arguments[] = {Int(0), Int(1)};
    EXPECT_THROW(_SPT_SET_COLOR(dc2::script::RunArguments(short_arguments), 2), dc2::script::ArgumentError);
    EXPECT_TRUE(std::equal(bytes.begin(), bytes.end(), before.begin()));
    PortSetRunningEffect(nullptr, nullptr);
}

TEST_F(EffectSprites, SuccessiveColorAcceptsThirteenMandatoryArgumentsWithoutReadingACount) {
    _EFF_SCRIPT *effect = Start(heal);
    ASSERT_NE(effect, nullptr);
    GiveSprites(effect);
    PortSetRunningEffect(&manager, effect);
    RS_STACKDATA arguments[] = {Int(0), Int(11), Int(22), Int(33), Int(44),
                                Int(0), Int(0), Int(0), Int(0), Int(0), Int(0), Int(0), Int(0)};
    EXPECT_EQ(_SPT_VAN_SET_COL(dc2::script::RunArguments(arguments), 13), 1);
    EXPECT_FLOAT_EQ(effect->sprite[0].color[0], 11.0f);
    EXPECT_FLOAT_EQ(effect->sprite[0].color[3], 44.0f);
    PortSetRunningEffect(nullptr, nullptr);
}
