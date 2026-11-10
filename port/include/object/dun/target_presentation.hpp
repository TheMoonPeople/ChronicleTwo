#pragma once

#include "gfx/gfx.hpp"

class CLockOnModel;
class CActiveMonster;

void          mgPortHideTarget(CLockOnModel *lock);
void          mgPortTrackTarget(CLockOnModel *lock, CActiveMonster *target, int slot, bool locked);
gfx::Interp2D mgPortTargetBrackets(CLockOnModel *lock);
gfx::Interp2D mgPortTargetName(CLockOnModel *lock);
