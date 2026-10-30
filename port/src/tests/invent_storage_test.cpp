#include <gtest/gtest.h>

#include <string>

#include "inventmn.hpp"
#include "mg_memory.hpp"
#include "platform/arena.hpp"
#include "stubs/inventmn.hpp"

TEST(InventStorage, NativeRecipesAndMaterialsOutgrowTheRetailMenuSlot) {
    static char owner;
    auto       *retail_slot = reinterpret_cast<u_long128 *>(ArenaBlock(&owner, 0x210 * sizeof(u_long128)));
    InventTeigiStack.stSetBuffer(retail_slot, 0x210);
    std::string script = "DATATABLESET 136;\n";
    for (int i = 0; i < 136; ++i) {
        script += "DATASET " + std::to_string(i + 1) + ",4,11,12,210,5,216,4,231,15,0,0.99,-10.4,0.72,0;\n";
    }
    CInventDataManage manager;
    ASSERT_TRUE(manager.LoadAnalyzeInventFile(script.data(), script.size()));
    ASSERT_EQ(manager.num, 136);
    for (int i = 0; i < manager.num; ++i) {
        const auto &recipe = manager.table[i];
        EXPECT_EQ(recipe.item_id, i + 1);
        EXPECT_EQ(recipe.neta_id[2], 12);
        ASSERT_EQ(recipe.materials.num, 3);
        EXPECT_EQ(recipe.materials.material[2].item_id, 231);
        EXPECT_EQ(recipe.materials.material[2].num, 15);
        EXPECT_FLOAT_EQ(recipe.model_scale, 0.99f);
        EXPECT_FLOAT_EQ(recipe.model_pos[1], 0.72f);
    }
}

TEST(InventStorage, LoadingAnotherManagerPreservesExistingRecipePointers) {
    CInventDataManage first;
    CInventDataManage second;
    std::string       script = "DATATABLESET 1; DATASET 42,1,2,3,210,5,0,1.0,2.0,3.0,4.0;";
    ASSERT_TRUE(first.LoadAnalyzeInventFile(script.data(), script.size()));
    auto *recipe = first.table;
    auto *material = recipe->materials.material;
    script = "DATATABLESET 1; DATASET 43,4,5,6,211,7,0,1.0,2.0,3.0,4.0;";
    ASSERT_TRUE(second.LoadAnalyzeInventFile(script.data(), script.size()));
    EXPECT_EQ(first.table, recipe);
    EXPECT_EQ(recipe->item_id, 42);
    EXPECT_EQ(recipe->materials.material, material);
    EXPECT_EQ(material->item_id, 210);
    EXPECT_EQ(material->num, 5);
    EXPECT_EQ(second.table->item_id, 43);
}

TEST(InventStorage, MalformedCountsAndUnrepresentableMaterialAmountsAreRefused) {
    CInventDataManage manager;
    for (std::string script : {"DATATABLESET -1;", "DATASET 42,1,2,3,210,5,0,1.0,2.0,3.0,4.0;",
                               "DATATABLESET 1; DATASET 42,1,2,3,210,256,0,1.0,2.0,3.0,4.0;"}) {
        EXPECT_FALSE(manager.LoadAnalyzeInventFile(script.data(), static_cast<int>(script.size())));
    }
}
