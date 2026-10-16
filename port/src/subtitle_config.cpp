#include "common.h"

#include <cstdio>
#include <cstring>

#include "nd_meswin.hpp"
#include "platform/subtitle_config.hpp"

PORT_OVERRIDE void MovieCCAnalyze(char *text, int size, int id) {
    if (!text || size <= 0) {
        return;
    }
    int chapter = 0;
    if (id > 0 && id < 21) {
        chapter = id + 900;
    } else if (id == 21) {
        chapter = 944;
    } else if (id >= 24 && id < 47) {
        chapter = id + 897;
    }
    std::vector<subtitle_config::Cue> cues;
    std::string                       error;
    if (!subtitle_config::Decode(std::string_view(text, static_cast<std::size_t>(size)), chapter, cues, error)) {
        if (!error.empty()) {
            std::fprintf(stderr, "subtitles: %s\n", error.c_str());
        }
        return;
    }
    InitMovieCC();
    for (std::size_t index = 0; index < cues.size(); ++index) {
        MovieCCStart[index] = cues[index].start_frame;
        MovieCCClear[index] = cues[index].clear_frame;
        std::memcpy(MovieCCStr[index], cues[index].text.c_str(), cues[index].text.size() + 1);
    }
}
