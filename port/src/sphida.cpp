#include "common.h"

#include <algorithm>

#include "platform/config.hpp"
#include "sphida.hpp"
#include "sphida_port.hpp"

namespace {
// Retail caps a random hole's par here, and the par counter has room for two digits.
constexpr int kMaxPar = 99;

// A setup that laid out no hole (an unknown bonus course) leaves play off, and its par is not counted.
void AddHandicap(CSphida &sphida) {
    if (sphida.play_flag != 0) {
        sphida.par_count = SphedaHandicapPar(sphida.par_count, ConfigGet().spheda_handicap);
    }
}
} // namespace

int SphedaHandicapPar(int par, int handicap) {
    return std::min(par + std::clamp(handicap, 0, kSphedaHandicapMax), std::max(par, kMaxPar));
}

PORT_OVERRIDE void CSphida::SetUp(int arg) {
    PortRetailSetUp(arg);
    AddHandicap(*this);
}

PORT_OVERRIDE void CSphida::s17_SetUp(int arg) {
    PortRetailS17SetUp(arg);
    AddHandicap(*this);
}

PORT_OVERRIDE void CSphida::Omake_SetUp(int course, int tex_bank) {
    PortRetailOmakeSetUp(course, tex_bank);
    AddHandicap(*this);
}
