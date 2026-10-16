#include "common.h"

#include <cstdio>

#include "dataread_port.hpp"
#include "mg_dataset.hpp"
#include "platform/model_assets.hpp"

PORT_OVERRIDE mgCFrame *mgLoadMDSFile(MDS_HEADER *mds, mgCMemory *memory,
                                      mgCreateVisualType *visual_type, mgCTextureManager *texture_manager) {
    mgLoadData load{};
    load.mds = mds;
    load.memory = memory;
    load.visual_type = visual_type;
    load.texture_manager = texture_manager;
    return mgLoadMDSFile(&load);
}

PORT_OVERRIDE mgCFrame *mgLoadMDSFile(mgLoadData *load) {
    if (!load || !load->mds || !load->memory) {
        return nullptr;
    }
    std::string error;
    const auto  path = DataReadBufferPath(load->mds);
    if (!path) {
        std::fprintf(stderr, "model: direct glTF path required; in-memory loaders must supply gameplay JSON\n");
        return nullptr;
    }
    auto *frame = model_assets::LoadModel(std::filesystem::path(*path), *load, error);
    if (!frame) {
        std::fprintf(stderr, "model: %s\n", error.c_str());
    }
    return frame;
}
