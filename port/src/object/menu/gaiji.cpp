#include "common.h"

#include "dataread.hpp"
#include "gaiji.hpp"
#include "mainloop.hpp"

/** Buffer holding the language-specific gaiji image. */
u_char GaijiBuff[0x11800];

int LoadGaijiImg() {
    int size = {};

    switch (LanguageCode) {
        case LANG_JAPANESE:
            LoadFile("textures/meswin/jpn/gaiji.json", GaijiBuff, &size);
            break;
        case LANG_FRENCH:
            LoadFile("textures/meswin/eu/fra/gaiji.json", GaijiBuff, &size);
            break;
        case LANG_GERMAN:
            LoadFile("textures/meswin/eu/ger/gaiji.json", GaijiBuff, &size);
            break;
        case LANG_ITALIAN:
            LoadFile("textures/meswin/eu/ita/gaiji.json", GaijiBuff, &size);
            break;
        case LANG_SPANISH:
            LoadFile("textures/meswin/eu/spn/gaiji.json", GaijiBuff, &size);
            break;
        case LANG_ENGLISH:
        default:
            LoadFile("textures/meswin/usa/gaiji.json", GaijiBuff, &size);
            break;
    }

    return size;
}

u_char *GetGaijiImgPtr() {
    return GaijiBuff;
}
