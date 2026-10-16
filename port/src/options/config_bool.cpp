#include "options/config_bool.hpp"

#ifdef PORT

#include "debug_mode.hpp"
#include "platform/config.hpp"

namespace port_settings {

bool ReadConfigBool(const Config &config, std::string_view config_key) {
    if (config_key == "game.debug_mode") {
        return config.debug_mode;
    }
    if (config_key == "game.skip_intro") {
        return config.skip_intro;
    }
    return false;
}

void WriteConfigBool(Config &config, std::string_view config_key, bool value) {
    if (config_key == "game.debug_mode") {
        config.debug_mode = value;
        DebugModeBoot(value);
        return;
    }
    if (config_key == "game.skip_intro") {
        config.skip_intro = value;
    }
}

} // namespace port_settings

#endif
