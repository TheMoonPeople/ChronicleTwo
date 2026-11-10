#pragma once

#include "common.h"

#include "editmap.hpp"

/**
 * @file
 * Declares the second half of the Georama edit map: the checks that decide whether
 * a part can stand at a place, the lookups of placed parts by info, territory and
 * parent, fence painting, house updates and the tilting of the balance ground.
 * Every function the unit defines is either a member of CEditMap, declared in
 * editmap.hpp, or file-local, so the unit adds no declarations of its own.
 */
