#include <gtest/gtest.h>

#include <cstring>
#include <memory>

#include "editexception.hpp"
#include "scenesnd.hpp"
#include "vector_scratch_probes.hpp"

TEST(ThunderVector, FourBandMapUsesTheCompleteLightingOutput) {
    auto scene = std::make_unique<CScene>();
    auto map = std::make_unique<CMap>();
    scene->map_num = 1;
    scene->active_map = 0;
    scene->map[0].status = SCENE_DATA_ASSIGNED;
    std::strcpy(scene->map[0].name, "s51");
    scene->map[0].map = map.get();
    map->map_info.Initialize();
    map->map_info.time_light_num = 4;
    map->place_parts_num = 0;
    InitS51Thunder();
    S51Thunder(scene.get());
    EXPECT_EQ(map->map_info.time_light_num, 4);
}

TEST(ThunderVector, ActualScratchDeclarationsHoldEveryWrittenLane) {
    EXPECT_TRUE(VectorScratchProbe::Thunder);
}
