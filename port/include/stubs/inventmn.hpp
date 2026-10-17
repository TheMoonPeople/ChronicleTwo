#pragma once

class mgCMemory;
class CInventDataManage;
class CInventUserData;
class CMenuInvent;
struct SPI_TAG_PARAM;

extern mgCMemory          InventTeigiStack asm("Inventmn_RecipeStack");
extern CInventDataManage *InventManagePt asm("Inventmn_RecipeManager");
extern SPI_TAG_PARAM      invent_teigi_func[3] asm("Inventmn_RecipeTags");
extern CInventUserData   *InventUserDataPtr asm("Inventmn_PhotoData");
extern CMenuInvent       *CMenuInventPt asm("MenuMouse_Invent");
