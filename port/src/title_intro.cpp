#include "platform/config.hpp"
#include "port_options.hpp"

bool PortSkipIntroLogos() { return ConfigGet().skip_intro; }
