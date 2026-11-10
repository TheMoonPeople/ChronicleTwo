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

class CMenuInvent;
class mgCTexture;

// Bounded native replacements of the photo-name and idea-memo formatting read these.
extern char        *gaiji_table_4737[3] asm("Inventmn_MemoIconPrefixes");
extern char        *addstringtable_1722[3] asm("Inventmn_IdeaIconPrefixes");
extern short        pic_name_info_num asm("Inventmn_PictureNameCount");
extern mgCTexture  *Tex_Hatsumei asm("Inventmn_InventionTexture");
extern CMenuInvent *CMenuInventPt asm("Inventmn_Menu");
extern char        *NetaMemoStr[512] asm("Inventmn_MemoNames");
extern short        NetaMemoID[512] asm("Inventmn_MemoIds");
