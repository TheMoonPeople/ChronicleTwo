#include "platform/config.hpp"
#include "port_options.hpp"

bool PortSkipIntro() { return ConfigGet().skip_intro; }

bool PortSkipIntroLogos() { return PortSkipIntro(); }
