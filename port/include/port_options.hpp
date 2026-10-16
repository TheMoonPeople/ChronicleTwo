#pragma once

#ifdef PORT

class CMenuOption;

// Retail in-game Options menu integration for port-registered host settings.
void PortOptionsBindRetailValues(CMenuOption *menu);
void PortOptionsAfterScript();
void PortOptionsRefreshRetailLabels();
bool PortOptionsOnDecide(int select, int choice);

bool PortSkipIntroLogos();

#endif
