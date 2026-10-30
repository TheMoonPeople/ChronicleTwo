#pragma once

#include <runscript_opcodes.hpp>

class CScene;

/**
 * Selects the scene used by the active monster's retail script callbacks.
 */
void PortSetMonsterScriptScene(CScene *scene);
