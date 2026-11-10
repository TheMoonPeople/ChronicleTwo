// Appended to the native copy of ps2/src/effscript.cpp: the effect whose script is running and its manager, file
// statics that the sprite-command seams in port/src/effscript.cpp read.

_EFF_SCRIPT *PortRunningEffect() {
    return now_script;
}

void PortSetRunningEffect(CEffectScriptMan *manager, _EFF_SCRIPT *script) {
    EffScriptMan = manager;
    now_script = script;
}
