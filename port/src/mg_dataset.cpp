#include "common.h"

#include <cstdio>

#include "character_motion.hpp"
#include "dataread_port.hpp"
#include "log/log.hpp"
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
        CT_LOG_ERROR(Data, "model: direct glTF path required; in-memory loaders must supply gameplay JSON");
        return nullptr;
    }
    auto *frame = model_assets::LoadModel(std::filesystem::path(*path), *load, error);
    if (!frame) {
        CT_LOG_ERROR(Data, "model: {}", error);
    }
    return frame;
}

void PortRetailCopyFrame(mgCFrame *, mgCFrame *, mgCMemory *, int, mgCFrame **) asm("MgDataset_CopyFrame");

PORT_OVERRIDE void CopyFrame(mgCFrame *dst, mgCFrame *src, mgCMemory *memory, int copy_visual, mgCFrame **frame_table) {
    PortRetailCopyFrame(dst, src, memory, copy_visual, frame_table);
    model_assets::CopyFrameConvention(*dst, *src);
    // An active monster's copy reuses its slot's storage, so the tree may sit where the previous monster's did.
    character_motion::ForgetPose(dst);
}
