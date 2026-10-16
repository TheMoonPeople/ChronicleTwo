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

PORT_OVERRIDE int CommandStreamOpenFromFPL(int stream, char *, char *clip) {
    auto path = VoiceClipPath(clip);
    CSnd.StreamOpenFast(stream, path.data());
    return true;
}

PORT_OVERRIDE int CommandStreamOpen(int stream, char *clip) {
    auto path = VoiceClipPath(clip);
    CSnd.StreamOpenFast(stream, path.data());
    return true;
}

PORT_OVERRIDE int CommandStreamOpen2(int, char *) {
    return true;
}

PORT_OVERRIDE int _STREAM_OPEN(RS_STACKDATA *arguments, int count) {
    if (!arguments) {
        return false;
    }
    if (count == 2) {
        const auto &clip = arguments[1];
        if (clip.type == RS_INT) {
            EdEventInfo.stream_source = EVENT_STREAM_VOICE_PACK;
            char name[32];
            std::snprintf(name, sizeof(name), "%07d", clip.val.i);
            return CommandStreamOpen(EVENT_STREAM_CHANNEL, name);
        }
        if (clip.type == RS_STR && clip.val.s) {
            EdEventInfo.stream_source = EVENT_STREAM_FILE;
            return CommandStreamOpen(EVENT_STREAM_CHANNEL, clip.val.s);
        }
    } else if (count == 3 && arguments[1].type == RS_STR && arguments[2].type == RS_STR && arguments[2].val.s) {
        EdEventInfo.stream_source = EVENT_STREAM_VOICE_PACK;
        return CommandStreamOpenFromFPL(EVENT_STREAM_CHANNEL, arguments[1].val.s, arguments[2].val.s);
    }
    return false;
}
