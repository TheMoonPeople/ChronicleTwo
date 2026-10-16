#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <cstring>
#include <vector>

#include "character.hpp"
#include "dataread.hpp"
#include "effect.hpp"
#include "mg_memory.hpp"
#include "platform/model_assets.hpp"

TEST(CharacterEffectMemory, ManagerOffsetDoesNotOverlapParticleStorage) {
    using Json = nlohmann::json;
    const Json args = Json::array({
        {{"type", "resource"}, {"kind", "script"}, {"index", 0}},
        {{"type", "string"}, {"value", "test"}},
        {{"type", "int"}, {"value", 0}},
        {{"type", "string"}, {"value", ""}},
        {{"type", "float"}, {"value", 2.0}},
        {{"type", "float"}, {"value", 3.0}},
        {{"type", "float"}, {"value", 4.0}}
    });
    const Json game = {
        {"schema_version", 1                                                                                 },
        {"kind",           "character"                                                                       },
        {"models",         Json::array()                                                                     },
        {"profiles",       {{"info", {{"commands", Json::array({{{"command", "EFFECT"}, {"args", args}}})}}}}},
        {"resources",      {{"scripts", Json::array({{{"name", "effect"}, {"commands", Json::array()}}})}}   }
    };
    auto bytes = Json{
        {"asset", {{"version", "2.0"}}}
    }
                     .dump();
    alignas(64) u_long128 storage[2048]{};
    mgCMemory             memory;
    memory.stSetBuffer(storage, 2048);
    CCharacter2 character;
    character.Initialize();
    character.effect_image_load = 0;
    model_assets::CharacterLoadOptions options{&memory, &memory, &memory};
    std::string                        error;
    ASSERT_TRUE(model_assets::LoadCharacter(character, {reinterpret_cast<const std::byte *>(bytes.data()), bytes.size()}, game, "info", options, error)) << error;
    ASSERT_NE(character.effect_list, nullptr);
    auto *manager = character.effect_list->effect;
    ASSERT_NE(manager, nullptr);
    EXPECT_GE(reinterpret_cast<char *>(manager->particle_pool) - reinterpret_cast<char *>(manager),
              static_cast<std::ptrdiff_t>(sizeof(*manager)));
    // The zero-particle pool still owns one quadword; writing it must not touch offset.
    std::memset(manager->particle_pool, 0xA5, 16);
    EXPECT_FLOAT_EQ(manager->offset[0], 2.0f);
    EXPECT_FLOAT_EQ(manager->offset[1], 3.0f);
    EXPECT_FLOAT_EQ(manager->offset[2], 4.0f);
    EXPECT_FLOAT_EQ(manager->offset[3], 1.0f);
}
