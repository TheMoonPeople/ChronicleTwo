#pragma once
#include "nowload.hpp"

// Retail loading-bar state shared by the native loading hook and its callers.
extern NowLoadingInfo PortLoadInfo asm("NowLoad_LoadInfo");
extern int            PortProgBarCnt asm("NowLoad_ProgBarCnt");
extern float          PortProgBarWidthStep asm("NowLoad_ProgBarWidthStep");

// game.skip_intro: SCElogoFade keeps the language select and drops its fade frames, MainLoop drops the boot logo's
// fade-out, and TitleCopyRightStep ends at once.
bool PortSkipIntro();
