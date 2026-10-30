#include "common.h"

#include <cstdio>
#include <string>
#include <string_view>

#include "event.hpp"
#include "event_func.hpp"
#include "runscript.hpp"
#include "sound.hpp"

namespace {
/**
 * Produces the direct WAV resource path for an event voice clip identifier.
 */
std::string VoiceClipPath(std::string_view clip) {
    std::string path(clip);
    if (!clip.contains('/')) {
        path.insert(0, "sound/");
    }
    if (!clip.ends_with(".wav")) {
        path += ".wav";
    }
    return path;
}
} // namespace

int CommandStreamOpenFromFPL(int stream, char * /*unused*/, char *clip) {
    return CommandStreamOpen(stream, clip);
}

int CommandStreamOpen(int stream, char *clip) {
    auto path = VoiceClipPath(clip);
    CSnd.StreamOpenFast(stream, path.data());
    return true;
}

int CommandStreamOpen2(int /*unused*/, char * /*unused*/) {
    return true;
}

int _STREAM_OPEN(dc2::script::RunArguments arguments, int count) {
    if (count == 2) {
        const auto clip = arguments + 1;
        if (clip.At().type == RS_INT) {
            EdEventInfo.stream_source = EVENT_STREAM_VOICE_PACK;
            char name[32];
            std::snprintf(name, sizeof(name), "%07d", dc2::script::RunInteger(clip));
            return CommandStreamOpen(EVENT_STREAM_CHANNEL, name);
        }
        if (clip.At().type == RS_STR) {
            char *name = dc2::script::RunCString(clip);
            EdEventInfo.stream_source = EVENT_STREAM_FILE;
            return CommandStreamOpen(EVENT_STREAM_CHANNEL, name);
        }
    } else if (count == 3) {
        char *pack = dc2::script::RunCString(arguments + 1);
        char *clip = dc2::script::RunCString(arguments + 2);
        EdEventInfo.stream_source = EVENT_STREAM_VOICE_PACK;
        return CommandStreamOpenFromFPL(EVENT_STREAM_CHANNEL, pack, clip);
    }
    return false;
}
