#include "common.h"

#include <cstring>
#include <string_view>

#include "eventsprite.hpp"
#include "menucls1.hpp"
#include "nd_meswin.hpp"
#include "text/bounded.hpp"

// Retail copies each inserted string into its 50-byte message name without a bound.
void CDC2Mes::SetMsgItemNo(char **strings, int count) {
    for (int index = 0; index < count && index < MES_ITEM_MAX; ++index) {
        const std::string_view text = dc2::text::View(strings[index]);
        if (std::string_view(name[index]) != text) {
            msg_change = true;
            dc2::text::Copy(name[index], text);
        }

        if (strings[index] == nullptr) {
            for (; index < MES_ITEM_MAX; ++index) {
                name[index][0] = '\0';
            }
            break;
        }
    }
}

// Event sprites take their image and texture names from event scripts.
void CEventSprite::SetName(char *name) {
    dc2::text::Copy(this->name, dc2::text::View(name));
}

void CEventSprite2::SetTexture(char *name, int slot) {
    dc2::text::Copy(tex_name, dc2::text::View(name));
    tex_block = slot;
}
