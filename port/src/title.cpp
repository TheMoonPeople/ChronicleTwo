#include "common.h"

#include "mglib.hpp"
#include "mg_texture.hpp"
#include "nd_meswin.hpp"

extern ClsMes *TitleMCCheckMes asm("Title_MCCheckMes");

namespace {
// System message 102, "Reading memory card (PS2).", which retail shows while it scans both cards at boot.
constexpr int kReadingCardMessage = 0x66;
} // namespace

// The PC save folder needs no boot scan notice. The no-space and no-card notices still draw.
PORT_OVERRIDE void TitleMCCheckDraw() {
    if (TitleMCCheckMes != NULL && TitleMCCheckMes->mes_no != kReadingCardMessage) {
        mgTexManager.ReloadTexture(0x46, (sceVif1Packet *) NULL);
        TitleMCCheckMes->Step();
        TitleMCCheckMes->DrawMesWin();
    }
}
