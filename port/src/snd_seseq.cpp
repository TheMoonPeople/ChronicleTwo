#include "common.h"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <cstdio>
#include <vector>

#include "dataread_port.hpp"
#include "mg_memory.hpp"
#include "snd_seseq.hpp"

PORT_OVERRIDE void sndCSeSeqData::LoadSMF(char *source, int size, mgCMemory *memory) {
    Initialize();
    const auto length = size > 0 ? static_cast<std::size_t>(size) : DataReadBufferSize(source);
    if (source && length) {
        const std::string_view document(source, length);
        try {
            const auto root = nlohmann::json::parse(document);
            if (root.at("schema_version") != 1 || root.at("kind") != "effect_sequence") {
                return;
            }
            const auto &events = root.at("events");
            if (!events.is_array() || events.size() > 1048576) {
                return;
            }
            std::vector<sndSeSeqEvent> converted;
            for (const auto &e : events) {
                auto &out = converted.emplace_back();
                out = {};
                out.delta = e.at("delta");
                out.status = e.at("status");
                out.data[0] = static_cast<s8>(e.at("data").at(0).get<int>());
                out.data[1] = static_cast<s8>(e.at("data").at(1).get<int>());
            }
            const int rate = root.at("tick_rate");
            if (rate <= 0) {
                return;
            }
            converted.emplace_back();
            converted.back() = {};
            event_num = static_cast<int>(converted.size());
            const auto bytes = static_cast<unsigned int>(event_num * sizeof(sndSeSeqEvent));
            event = reinterpret_cast<sndSeSeqEvent *>(memory->Alloc((bytes + 15) / 16));
            if (!event) {
                Initialize();
                return;
            }
            std::copy(converted.begin(), converted.end(), event);
            tick_rate = rate;
            return;
        } catch (const nlohmann::json::exception &) {
            Initialize();
        }
    }
    std::fprintf(stderr, "sound: missing or invalid effect sequence JSON\n");
}
