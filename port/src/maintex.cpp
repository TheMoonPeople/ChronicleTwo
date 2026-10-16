#include "common.h"

#include <cstdio>
#include <stdexcept>
#include <string>

#include "dataread.hpp"
#include "dng_main.hpp"
#include "gaiji.hpp"
#include "maintex.hpp"
#include "mglib.hpp"
#include "photo.hpp"
#include "platform/texture_bundle.hpp"
#include "userdata.hpp"

namespace {
/** Names of the dungeon's mutable render-target textures. */
char work_name[] = "work";
char work2_name[] = "work2";
char fire_work_name[] = "fire_work";
char capture_name[] = "capture";
char water_work_name[] = "water_work";
} // namespace

PORT_OVERRIDE void MainTextureInterface(mgCMemory *stack, CScene *scene) {
    mgTexManager.EnterIMGFile(GetGaijiImgPtr(), 0x58, nullptr, nullptr);
    ReLoadFontTexture(0x58);
    mgTexManager.EnterIMGFile(GetFontTex2ImgPtr(), 0x58, nullptr, nullptr);
    stack->Align64();
    auto *buffer = stack->stAllocTest(1);
    char  path[64];
    int   file_size = 0;
    std::snprintf(path, sizeof(path), "img/esystem%d.json", LanguageCode);
    LoadFile(path, buffer, &file_size);
    mgTexManager.EnterIMGFile(reinterpret_cast<u_char *>(buffer), 0x67, stack, nullptr);
    stack->Alloc(file_size / 16 + 1);
    LoadTakePhoto(0x67, stack, buffer);
    stack->Align64();

    std::snprintf(path, sizeof(path), "dungeon/articles/tex01_%d.gltf", LanguageCode);
    std::string error;
    const auto  enter = [&](const char *entry, int block, mgCMemory *memory, bool optional = false) {
        if (!texture_bundle::Enter(path, entry, mgTexManager, block, memory, error, optional)) {
            throw std::runtime_error(error);
        }
    };
    enter("frame", 0x48, stack);
    enter("effect00", 0x49, stack);
    enter("sweff", 0x4A, stack);
    enter("potbeam", 0x4A, stack);
    enter("ref", 0x59, nullptr);
    enter("fire_wrk", 0x4B, stack);
    enter("bteffe_chi", 0x6B, stack, LanguageCode == 0);

    mgTexManager.EnterTexture(0x64, work_name, nullptr, mgScreenWidth, mgScreenHeight, 32, nullptr, 0, 0);
    mgTexManager.EnterTexture(0x64, work2_name, nullptr, mgScreenWidth / 3, mgScreenHeight / 3, 32, nullptr, 0, 0);
    mgTexManager.EnterTexture(0x4B, fire_work_name, nullptr, mgScreenWidth, mgScreenHeight, 32, nullptr, 0, 0);
    mgTexManager.EnterTexture(0x65, capture_name, nullptr, mgScreenWidth, mgScreenHeight, mgScreenDepth, nullptr, 0, 0);
    mgTexManager.EnterTexture(0x59, water_work_name, nullptr, mgScreenWidth, mgScreenHeight, mgScreenDepth, nullptr, 0, 0);
    scene->fade.SetCrossTexture(mgTexManager.GetTexture(capture_name, -1), BuffReadData + 0x20000);
    GetTextureInfo(scene);
}
