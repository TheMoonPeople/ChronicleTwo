#include "charasetup.hpp"

#include "gamedata.hpp"
#include "userdata.hpp"

ROBO_INFO_DATA *PortRetailGetRoboPartsInfo(CUserDataManager *) asm("CharaSetup_GetRoboPartsInfo");

namespace {

// Retail's tables of Max-in-the-Ridepod models, one per outfit.
constexpr int kMaxOutfits = 6;

} // namespace

// Retail indexes its six "mints" model names by Max's outfit minus the first outfit item, without a
// range check. While the item menu holds Max's outfit on the cursor, his outfit slot is empty, so the
// index is -258 and retail formats its filename from whatever pointer lies 258 entries before the
// table. On the PS2 that reads junk (the PAL "Make menu" crash); natively it faults in sprintf. Give
// retail Max's first outfit for the call when the slot holds no outfit, then put the slot back.
PORT_OVERRIDE ROBO_INFO_DATA *GetRoboPartsInfo(CUserDataManager *user_data) {
    CHARA_DATA    *max = user_data->GetCharaDataPtr(USER_CHARA_MAX);
    CGameDataUsed &outfit = max->equip[CHARA_EQUIP_CLOTHES];
    const short    item_no = outfit.item_no;
    const int      first = GetGameDataPt()->GetDataTypeStartListNo(ITEM_DATA_MAX_CLOTHES);
    const int      index = item_no - first;

    if (first > 0 && (index < 0 || index >= kMaxOutfits)) {
        outfit.item_no = static_cast<short>(first);
        ROBO_INFO_DATA *info = PortRetailGetRoboPartsInfo(user_data);
        outfit.item_no = item_no;
        return info;
    }

    return PortRetailGetRoboPartsInfo(user_data);
}
