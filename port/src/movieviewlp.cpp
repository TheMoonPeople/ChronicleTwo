#include "common.h"

#include "config_bridges.hpp"
#include "movieviewlp.hpp"

PORT_OVERRIDE void MovieViewInit(INIT_LOOP_ARG argument) { PortInitializeMovieViewer(argument); }
