#include "identity.hpp"

#include "icon/chronicletwo.hpp"
#include "platform/datapacks.hpp"
#include "platform/game_icon.hpp"
#include "platform/paths.hpp"
#include "platform/settings.hpp"
#include "platform/window.hpp"

void GameSetIdentity() {
    SettingsSetEnvPrefix("DC2");
    PathsConfigure({.app_dir = "chronicletwo", .env_data = "DC2_DATA", .env_save = "DC2_SAVE", .installed_save_default = true, .coherent_default_root = true});
    WindowSetIdentity({.title = "Dark Chronicle",
                       .app_id = "chronicletwo",
                       .icon_rgba = kIconRgba,
                       .icon_size = kIconSize});
}

GameIconSource GameDataIconSource() {
    GameIconSource source;
    source.packs = {"title"};
    source.member = "dc2_ic.gltf";
    source.candidates = datapacks::Candidates;
    source.ico_file = L"chronicletwo.ico";
    source.shortcut = L"Dark Chronicle";
    return source;
}

void GameSetDataIcon() {
    GameIconInstall(datapacks::Root(), GameDataIconSource());
}
