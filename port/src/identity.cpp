#include "identity.hpp"

#include "platform/paths.hpp"
#include "platform/settings.hpp"
#include "platform/window.hpp"

namespace {

WindowIdentity Identity() { return {.title = "Dark Chronicle", .app_id = "chronicletwo"}; }

} // namespace

void GameSetIdentity() {
    SettingsSetEnvPrefix("DC2");
    PathsConfigure({.app_dir = "chronicletwo", .env_data = "DC2_DATA", .env_save = "DC2_SAVE", .installed_save_default = true, .coherent_default_root = true});
    WindowSetIdentity(Identity());
}

void GameSetIcon(const std::uint8_t *rgba, int size) {
    WindowIdentity identity = Identity();
    identity.icon_rgba = rgba;
    identity.icon_size = size;
    WindowSetIdentity(identity);
}
