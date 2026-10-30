#pragma once

class mgCTexture;
enum class MgTextureColorMode {
    IconHighlight,
    Grey,
    Sepia,
    PartyLocked
};
mgCTexture *MgTextureCreateColorVariant(const mgCTexture *source, char *name, MgTextureColorMode mode);
void        MgTextureSetDrawVariant(const mgCTexture *source, mgCTexture *variant);
mgCTexture *MgTextureDrawVariant(mgCTexture *source);
