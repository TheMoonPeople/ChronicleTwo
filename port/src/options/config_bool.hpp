#pragma once

#ifdef PORT

#include <string_view>

struct Config;

namespace port_settings {

bool ReadConfigBool(const Config &config, std::string_view config_key);
void WriteConfigBool(Config &config, std::string_view config_key, bool value);

} // namespace port_settings

#endif
