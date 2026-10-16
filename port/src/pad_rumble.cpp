#include "pad_rumble.hpp"

#include <SDL3/SDL.h>

#include <algorithm>
#include <cstdio>
#include <vector>

#include "platform/settings.hpp"

namespace {

// SDL rumble needs a duration; the game restates its motors every vertical blank, so a short one is
// refreshed while it lasts and a hung game stops shaking on its own.
constexpr Uint32 kRumbleMs = 500;

struct Sent {
    SDL_JoystickID id = 0;
    bool           failed = false;
};

std::vector<Sent> g_known;
bool              g_small = false;
std::uint8_t      g_large = 0;
Uint64            g_last_send = 0;

const char *ConnectionName(SDL_JoystickConnectionState state) {
    switch (state) {
        case SDL_JOYSTICK_CONNECTION_WIRED:
            return "wired";
        case SDL_JOYSTICK_CONNECTION_WIRELESS:
            return "wireless";
        default:
            return "unknown";
    }
}

Sent &Known(SDL_JoystickID id, SDL_Gamepad *gamepad) {
    for (Sent &sent : g_known) {
        if (sent.id == id) {
            return sent;
        }
    }
    const SDL_PropertiesID props = SDL_GetGamepadProperties(gamepad);
    const char            *name = SDL_GetGamepadName(gamepad);
    std::fprintf(stderr, "rumble: pad \"%s\" (%04x:%04x, %s, %s), rumble %s\n", name ? name : "?",
                 SDL_GetGamepadVendor(gamepad), SDL_GetGamepadProduct(gamepad),
                 SDL_GetGamepadStringForType(SDL_GetGamepadType(gamepad)),
                 ConnectionName(SDL_GetGamepadConnectionState(gamepad)),
                 SDL_GetBooleanProperty(props, SDL_PROP_GAMEPAD_CAP_RUMBLE_BOOLEAN, false) ? "yes" : "no");
    g_known.push_back({id});
    return g_known.back();
}

void Send(Uint16 low, Uint16 high) {
    int             count = 0;
    SDL_JoystickID *ids = SDL_GetGamepads(&count);
    for (int i = 0; ids != nullptr && i < count; ++i) {
        // Only pads the input layer opened; this never opens one itself.
        SDL_Gamepad *gamepad = SDL_GetGamepadFromID(ids[i]);
        if (gamepad == nullptr) {
            continue;
        }
        Sent &sent = Known(ids[i], gamepad);
        if (!SDL_RumbleGamepad(gamepad, low, high, kRumbleMs) && !sent.failed) {
            sent.failed = true;
            std::fprintf(stderr, "rumble: \"%s\" refused rumble: %s\n", SDL_GetGamepadName(gamepad), SDL_GetError());
        }
    }
    SDL_free(ids);
    g_last_send = SDL_GetTicks();
}

} // namespace

void PortPadRumble(bool small_motor, std::uint8_t large_motor) {
    const bool changed = small_motor != g_small || large_motor != g_large;
    const bool active = small_motor || large_motor != 0;
    g_small = small_motor;
    g_large = large_motor;
    if (!changed && !(active && SDL_GetTicks() - g_last_send >= kRumbleMs / 2)) {
        return;
    }
    const float strength = std::clamp(SettingsGet().rumble_strength, 0.0f, 1.0f);
    const auto  low = static_cast<Uint16>(large_motor * 257 * strength);
    const auto  high = static_cast<Uint16>(small_motor ? 0xFFFF * strength : 0);
    Send(low, high);
}
