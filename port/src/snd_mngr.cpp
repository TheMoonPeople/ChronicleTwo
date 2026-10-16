#include "common.h"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <cstdio>
#include <cstring>
#include <new>
#include <vector>

#include "audio/sq.hpp"
#include "audio_assets.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "mg_memory.hpp"
#include "snd_mngr.hpp"
#include "snd_seseq.hpp"
#include "sound.hpp"
#include "sound_port.hpp"

extern sndPortInfo PortInfo[SND_PORT_NUM];

namespace {

bool  init_snd = false;
float PortVolf[SND_PORT_NUM] = {};

sndPortInfo *GetPortInfo(int port) {
    if (port < 0 || port >= SND_PORT_NUM) {
        return nullptr;
    }

    return &PortInfo[port];
}

int GetCSndPortNo(int port_no, int *port, int *sq_port, int *vol) {
    *vol = -1;

    switch (port_no) {
        case SND_PORT_BGM:
            *port = 0;
            *sq_port = 0;
            break;
        case SND_PORT_OB:
            *port = 15;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case 2:
            *port = 1;
            *sq_port = 1;
            break;
        case SND_PORT_BASE:
            *port = 10;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case SND_PORT_EVENT:
            *port = 14;
            *sq_port = 2;
            *vol = 0x100;
            break;
        case SND_PORT_ENEMY:
            *port = 13;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case SND_PORT_SYSTEM:
            *port = 12;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case 7:
            *port = 9;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case SND_PORT_MENU:
            *port = 11;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case SND_PORT_BGM2:
            *port = 3;
            *sq_port = 3;
            break;
        case 9:
            *port = 8;
            *sq_port = -1;
            *vol = 0x100;
            break;
        case 10:
            *port = 7;
            *sq_port = -1;
            *vol = 0x100;
            break;
        default:
            return 0;
    }

    return 1;
}

} // namespace

// The game's threads are cooperative fibers on one OS thread and nothing inside these sections yields,
// so there is nothing for a semaphore to guard.
PORT_OVERRIDE void sndWaitSema() {}

PORT_OVERRIDE void sndSignalSema() {}

PORT_OVERRIDE void sndInitMngr() {
    if (init_snd) {
        CSnd.Exit();
        init_snd = false;
    }

    CSnd.Init(4, 0, 40, 0);
    sndSetMasterVol(0, 1.0f);
    sndSetMasterVol(1, 1.0f);
    init_snd = true;

    for (int port = 0; port < 16; port++) {
        sndInitPort(port);
        PortVolf[port] = 0.0f;
    }
}

PORT_OVERRIDE void sndSetPortVol(int port_no, float vol) {
    sndPortInfo *info;
    int          driver_vol;

    info = GetPortInfo(port_no);

    if (info == NULL || info->port < 0 || info->port >= 16) {
        return;
    }

    if (vol < 0.0f) {
        vol = 0.0f;
    }

    if (vol > 1.0f) {
        vol = 1.0f;
    }

    PortVolf[port_no] = vol;
    driver_vol = (int) (127.0f * vol);

    if (vol == 1.0f) {
        driver_vol = 0x100;
    }

    sndWaitSema();
    CSnd.SetVol(info->port, driver_vol);
    sndSignalSema();
}

PORT_OVERRIDE float sndGetPortVol(int port) {
    if (port < 0 || port >= SND_PORT_NUM) {
        return 0.0f;
    }

    return PortVolf[port];
}

unsigned SoundLoadBundleData(int port_no, std::span<const std::byte> bytes, mgCMemory *memory) {
    auto *info = GetPortInfo(port_no);
    if (!info || !memory || bytes.empty()) {
        return -1;
    }
    try {
        const auto root = nlohmann::json::parse(reinterpret_cast<const char *>(bytes.data()), reinterpret_cast<const char *>(bytes.data() + bytes.size()));
        if (root.at("schema_version") != 1 || root.at("kind") != "sound_bundle") {
            return -1;
        }
        auto read = [&](const nlohmann::json &uri, std::string_view kind) {
            for (const auto &text : AudioDocuments(uri.get<std::string>())) {
                try {
                    const auto doc = nlohmann::json::parse(text);
                    if (doc.at("schema_version") != 1 || doc.at("kind") != kind) {
                        continue;
                    }
                    if (kind == "sequence") {
                        if (!audio::SqFile::CreateFromJson(text)) {
                            continue;
                        }
                    } else if (kind == "effect_sequence") {
                        if (doc.at("tick_rate").get<int>() <= 0 || !doc.at("events").is_array() || doc.at("events").size() > 1048576) {
                            continue;
                        }
                        for (const auto &e : doc.at("events")) {
                            (void) e.at("delta").get<s16>();
                            (void) e.at("status").get<u8>();
                            (void) e.at("data").at(0).get<int>();
                            (void) e.at("data").at(1).get<int>();
                        }
                    } else {
                        if (!doc.at("entries").is_array() || !doc.at("reverb").is_array()) {
                            continue;
                        }
                        if (kind == "sound_config") {
                            const auto count = doc.at("entry_count").get<std::size_t>();
                            if (count > 1048576 || doc.at("entries").size() > count) {
                                continue;
                            }
                            for (const auto &e : doc.at("entries")) {
                                (void) e.at("filename").get<std::string>();
                                (void) e.at("program").get<int>();
                                (void) e.at("key").get<int>();
                                (void) e.at("flag").get<bool>();
                            }
                        } else {
                            for (const auto &e : doc.at("entries")) {
                                (void) e.at("index").get<int>();
                                (void) e.at("volume").get<int>();
                            }
                        }
                        for (const auto &r : doc.at("reverb")) {
                            (void) r.at("type").get<int>();
                            (void) r.at("depth").get<int>();
                        }
                    }
                    return text;
                } catch (const nlohmann::json::exception &) {
                }
            }
            throw std::runtime_error("sound dependency missing or invalid");
        };
        const auto                                        config = read(root.at("config"), "sound_config");
        const auto                                        volume = read(root.at("volume"), "sound_volume");
        std::vector<std::pair<std::string, std::string> > sequences, effects;
        for (const auto &uri : root.at("sequences")) {
            sequences.emplace_back(uri.get<std::string>(), read(uri, "sequence"));
        }
        for (const auto &uri : root.at("effect_sequences")) {
            effects.emplace_back(uri.get<std::string>(), read(uri, "effect_sequence"));
        }
        if (sequences.size() > 32 || effects.size() > 48 || info->bank_num > 15) {
            return -1;
        }
        int initial_vol = -1;
        if (!GetCSndPortNo(port_no, &info->port, &info->sq_port, &initial_vol)) {
            return -1;
        }
        const int bank_no = info->bank_num;
        if (!root.at("bank").is_null()) {
            bool loaded = false;
            for (const auto &text : AudioDocuments(root.at("bank").get<std::string>())) {
                if (SoundLoadBankJson(info->port, text, bank_no != 0) == 0) {
                    loaded = true;
                    break;
                }
            }
            if (!loaded) {
                return -1;
            }
        }
        ++info->bank_num;
        auto *bank = info->GetBank(bank_no);
        if (!bank) {
            return -1;
        }
        if (info->sq_port >= 0) {
            bank->sq_num = static_cast<int>(sequences.size());
            bank->sq_name = new (memory->Alloc((sequences.size() * sizeof(char *) + 15) / 16 + 2)) char *[sequences.size()];
            for (std::size_t i = 0; i < sequences.size(); ++i) {
                if (SoundLoadSequenceJson(info->sq_port, sequences[i].second, sequences[i].first.c_str()) != 0) {
                    return -1;
                }
                bank->sq_name[i] = mgCopyString(sequences[i].first.data(), memory);
            }
        }
        bank->seseq_num = static_cast<int>(effects.size());
        if (!effects.empty()) {
            bank->seseq = new (memory->Alloc((effects.size() * sizeof(sndCSeSeqData) + 15) / 16 + 2)) sndCSeSeqData[effects.size()];
        }
        for (std::size_t i = 0; i < effects.size(); ++i) {
            bank->seseq[i].name = mgCopyString(effects[i].first.data(), memory);
            bank->seseq[i].LoadSMF(effects[i].second.data(), static_cast<int>(effects[i].second.size()), memory);
        }
        if (initial_vol >= 0) {
            CSnd.SetVol(info->port, initial_vol);
            PortVolf[port_no] = 1.0f;
        }
        info->LoadSeInfoTxt(bank_no, const_cast<char *>(config.data()), static_cast<int>(config.size()), memory);
        info->LoadVolInfoTxt(bank_no, const_cast<char *>(volume.data()), static_cast<int>(volume.size()));
        return ((port_no & 255) << 24) | ((bank_no & 255) << 16);
    } catch (const std::exception &error) {
        std::fprintf(stderr, "sound bundle: %s\n", error.what());
        return -1;
    }
}

unsigned SoundLoadBundlePath(int port_no, std::string_view path, mgCMemory *memory) {
    for (const auto &document : AudioDocuments(path)) {
        const auto result = SoundLoadBundleData(port_no, std::as_bytes(std::span(document.data(), document.size())), memory);
        if (result != static_cast<unsigned>(-1)) {
            return result;
        }
    }
    return -1;
}

PORT_OVERRIDE unsigned int sndLoadSound(int port_no, unsigned int *document, mgCMemory *memory) {
    if (const auto path = DataReadBufferPath(document)) {
        return SoundLoadBundlePath(port_no, *path, memory);
    }
    return SoundLoadBundleData(port_no, {reinterpret_cast<const std::byte *>(document), DataReadBufferSize(document)}, memory);
}

PORT_OVERRIDE void sndPortInfo::LoadSeInfoTxt(int bank_no, char *source, int size, mgCMemory *memory) {
    auto *bank_info = GetBank(bank_no);
    if (!bank_info) {
        return;
    }
    const auto length = size > 0 ? static_cast<std::size_t>(size) : DataReadBufferSize(source);
    if (source && length) {
        const std::string_view document(source, length);
        try {
            const auto root = nlohmann::json::parse(document);
            if (root.at("schema_version") != 1 || root.at("kind") != "sound_config") {
                return;
            }
            const std::size_t count = root.at("entry_count");
            if (count > 1048576 || root.at("entries").size() > count) {
                return;
            }
            std::vector<sndSeInfo>            effects;
            std::vector<std::pair<int, int> > reverbs;
            for (const auto &r : root.at("reverb")) {
                reverbs.emplace_back(r.at("type").get<int>(), r.at("depth").get<int>());
            }
            for (const auto &e : root.at("entries")) {
                auto      filename = e.at("filename").get<std::string>();
                sndSeInfo effect;
                std::memset(&effect, 0, sizeof(effect));
                int sequence_index = 0;
                effect.type = static_cast<s8>(bank_info->SearchSeq(filename.data(), &sequence_index));
                effect.prog = static_cast<s8>(e.at("program").get<int>());
                if (effect.type == SND_SE_TYPE_SQ || effect.type == SND_SE_TYPE_SESEQ) {
                    effect.prog = static_cast<s8>(sequence_index);
                }
                effect.key = static_cast<s8>(e.at("key").get<int>());
                effect.unk_7 = e.at("flag").get<bool>();
                effect.def_vol = 64;
                effects.push_back(effect);
            }
            bank_info->se_num = static_cast<int>(count);
            bank_info->se = new (memory->Alloc((count * sizeof(sndSeInfo) + 15) / 16 + 2)) sndSeInfo[count];
            std::memset(bank_info->se, 0, count * sizeof(sndSeInfo));
            std::copy(effects.begin(), effects.end(), bank_info->se);
            const int core = port == 0 ? 0 : port == 7 ? 1
                                                       : -1;
            if (core >= 0) {
                for (const auto &[type, depth] : reverbs) {
                    CSnd.SetReverb(core, type, depth);
                }
            }
            return;
        } catch (const nlohmann::json::exception &) {
        }
    }
    std::fprintf(stderr, "sound: missing or invalid sound config JSON\n");
}

PORT_OVERRIDE void sndPortInfo::LoadVolInfoTxt(int bank_no, char *source, int size) {
    auto *bank_info = GetBank(bank_no);
    if (!bank_info) {
        return;
    }
    const auto length = size > 0 ? static_cast<std::size_t>(size) : DataReadBufferSize(source);
    if (source && length) {
        const std::string_view document(source, length);
        try {
            const auto root = nlohmann::json::parse(document);
            if (root.at("schema_version") != 1 || root.at("kind") != "sound_volume") {
                return;
            }
            std::vector<std::pair<int, int> > levels, reverbs;
            for (const auto &e : root.at("entries")) {
                levels.emplace_back(e.at("index").get<int>(), e.at("volume").get<int>());
            }
            for (const auto &r : root.at("reverb")) {
                reverbs.emplace_back(r.at("type").get<int>(), r.at("depth").get<int>());
            }
            for (const auto &[index, volume] : levels) {
                if (auto *effect = bank_info->GetSe(index)) {
                    effect->def_vol = static_cast<s8>(volume);
                }
            }
            const int core = port == 0 ? 0 : port == 7 ? 1
                                                       : -1;
            if (core >= 0) {
                for (const auto &[type, depth] : reverbs) {
                    sndSetReverb(core, type, depth);
                }
            }
            return;
        } catch (const nlohmann::json::exception &) {
        }
    }
    std::fprintf(stderr, "sound: missing or invalid volume JSON\n");
}
