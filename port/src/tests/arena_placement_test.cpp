#include <gtest/gtest.h>

#include <cstddef>
#include <cstdio>
#include <cstring>
#include <print>
#include <string>
#include <vector>

#include "actionchara.hpp"
#include "automap.hpp"
#include "character.hpp"
#include "collision.hpp"
#include "dng_event.hpp"
#include "dngmenu.hpp"
#include "dynamicanime.hpp"
#include "editeff.hpp"
#include "editexception.hpp"
#include "editinfo.hpp"
#include "editmap.hpp"
#include "editmenu.hpp"
#include "editparts.hpp"
#include "editriver.hpp"
#include "effscript.hpp"
#include "event_func.hpp"
#include "mapload.hpp"
#include "mapparts.hpp"
#include "mapselect.hpp"
#include "mapsky.hpp"
#include "mdslist.hpp"
#include "memcard.hpp"
#include "menucapt.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menudraw.hpp"
#include "menushop.hpp"
#include "mg_camera.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "movie.hpp"
#include "movieviewlp.hpp"
#include "nameregi.hpp"
#include "outline.hpp"
#include "platform/arena.hpp"
#include "quest.hpp"
#include "runscript.hpp"
#include "swordeffect.hpp"
#include "title.hpp"
#include "villagermngr.hpp"
#include "wavetable.hpp"

namespace {

struct Site {
    const char *where;
    std::size_t host_bytes;
    int         quadwords;
};

const Site kSites[] = {
    {.where = "automap.cpp:821 AUTOMAP_ROOM_INFO[AUTOMAP_ROOM_INFO_MAX]",  .host_bytes = sizeof(AUTOMAP_ROOM_INFO) * AUTOMAP_ROOM_INFO_MAX, .quadwords = 0x62  },
    {.where = "character.cpp:1958 COutLineDraw[1]",                        .host_bytes = sizeof(COutLineDraw) * 1,                          .quadwords = 9     },
    {.where = "character.cpp:3714 COutLineDraw[1]",                        .host_bytes = sizeof(COutLineDraw) * 1,                          .quadwords = 9     },
    {.where = "character.cpp:3792 CSWordAfterEffect[1]",                   .host_bytes = sizeof(CSWordAfterEffect) * 1,                     .quadwords = 12    },
    {.where = "dngmenu.cpp:3947 CMenuTreeMap[1]",                          .host_bytes = sizeof(CMenuTreeMap) * 1,                          .quadwords = 0x2FC0},
    {.where = "dngmenu.cpp:3949 CDngFreeMap[1]",                           .host_bytes = sizeof(CDngFreeMap) * 1,                           .quadwords = 0x13  },
    {.where = "dng_event.cpp:1704 TRESURE_BOX_FLOOR_INFO[1]",              .host_bytes = sizeof(TRESURE_BOX_FLOOR_INFO) * 1,                .quadwords = 0x1A43},
    {.where = "dynamicanime.cpp:1217 CDAColPipe[1]",                       .host_bytes = sizeof(CDAColPipe) * 1,                            .quadwords = 16    },
    {.where = "editeff.cpp:82 CPaintEffect[1]",                            .host_bytes = sizeof(CPaintEffect) * 1,                          .quadwords = 0x42  },
    {.where = "editeff.cpp:554 CMapParts[1]",                              .host_bytes = sizeof(CMapParts) * 1,                             .quadwords = 0x33  },
    {.where = "editexception.cpp:390 mgC3DSprite[1]",                      .host_bytes = sizeof(mgC3DSprite) * 1,                           .quadwords = 7     },
    {.where = "editexception.cpp:391 FirePowder[FIRE_POWDER_NUM]",         .host_bytes = sizeof(FirePowder) * FIRE_POWDER_NUM,              .quadwords = 0x202 },
    {.where = "editexception.cpp:392 mgCFrame[1]",                         .host_bytes = sizeof(mgCFrame) * 1,                              .quadwords = 0x13  },
    {.where = "editexception.cpp:393 mgCFrameAttr[1]",                     .host_bytes = sizeof(mgCFrameAttr) * 1,                          .quadwords = 0xB   },
    {.where = "editexception.cpp:691 mgCFrame[1]",                         .host_bytes = sizeof(mgCFrame) * 1,                              .quadwords = 0x13  },
    {.where = "editexception.cpp:692 mgCFrameAttr[1]",                     .host_bytes = sizeof(mgCFrameAttr) * 1,                          .quadwords = 0xB   },
    {.where = "editexception.cpp:696 CGeyserEffect[4]",                    .host_bytes = sizeof(CGeyserEffect) * 4,                         .quadwords = 0x22  },
    {.where = "editexception.cpp:700 CGeyserEffectPoint[0x30]",            .host_bytes = sizeof(CGeyserEffectPoint) * 0x30,                 .quadwords = 0x92  },
    {.where = "editmap.cpp:2091 CMapPiece[1]",                             .host_bytes = sizeof(CMapPiece) * 1,                             .quadwords = 0xD   },
    {.where = "editmap.cpp:2124 CMapPiece[1]",                             .host_bytes = sizeof(CMapPiece) * 1,                             .quadwords = 0xD   },
    {.where = "editmap.cpp:2151 CMapPiece[1]",                             .host_bytes = sizeof(CMapPiece) * 1,                             .quadwords = 0xD   },
    {.where = "editmap.cpp:2518 CEditPartsInfo[EDIT_MAP_RIVER_PARTS_MAX]", .host_bytes = sizeof(CEditPartsInfo) * EDIT_MAP_RIVER_PARTS_MAX, .quadwords = 0x142 },
    {.where = "editmenu.cpp:1162 CMenuGeorama[1]",                         .host_bytes = sizeof(CMenuGeorama) * 1,                          .quadwords = 0x1B92},
    {.where = "editmenu.cpp:1222 CDC2Mes[1]",                              .host_bytes = sizeof(CDC2Mes) * 1,                               .quadwords = 0x2A7 },
    {.where = "editmenu.cpp:2099 CDC2Mes[1]",                              .host_bytes = sizeof(CDC2Mes) * 1,                               .quadwords = 0x2A7 },
    {.where = "editmenu.cpp:2407 CEditInfoMngr[1]",                        .host_bytes = sizeof(CEditInfoMngr) * 1,                         .quadwords = 4     },
    {.where = "editmenu.cpp:2477 CMenuFont[1]",                            .host_bytes = sizeof(CMenuFont) * 1,                             .quadwords = 0xE   },
    {.where = "editmenu.cpp:2528 CMenuFont[1]",                            .host_bytes = sizeof(CMenuFont) * 1,                             .quadwords = 0xE   },
    {.where = "editmenu.cpp:5763 CRemovalMenu[1]",                         .host_bytes = sizeof(CRemovalMenu) * 1,                          .quadwords = 0x152 },
    {.where = "editmode.cpp:676 CCharacter2[1]",                           .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "editmode.cpp:695 CCharacter2[1]",                           .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "editmode.cpp:710 CCharacter2[1]",                           .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "editriver.cpp:53 CEditGrid[1]",                             .host_bytes = sizeof(CEditGrid) * 1,                             .quadwords = 0x15  },
    {.where = "effscript.cpp:546 EFF_SPT_BASE[1]",                         .host_bytes = sizeof(EFF_SPT_BASE) * 1,                          .quadwords = 4     },
    {.where = "effscript.cpp:560 CCharacter2[1]",                          .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "effscript.cpp:1294 CCharacter2[1]",                         .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "event_func.cpp:2016 ARG_LIST[1]",                           .host_bytes = sizeof(ARG_LIST) * 1,                              .quadwords = 3     },
    {.where = "event_func.cpp:6080 CCharacter2[1]",                        .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "event_func.cpp:17132 CSWordAfterEffect[1]",                 .host_bytes = sizeof(CSWordAfterEffect) * 1,                     .quadwords = 12    },
    {.where = "event_func.cpp:18927 mgCMemory[1]",                         .host_bytes = sizeof(mgCMemory) * 1,                             .quadwords = 5     },
    {.where = "fishing.cpp:1197 CCharacter2[1]",                           .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "fishing.cpp:1420 CCharacter2[1]",                           .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "fishing.cpp:1422 CCharacter2[1]",                           .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "fishing.cpp:1424 CCharacter2[1]",                           .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "fishing.cpp:1426 CCharacter2[1]",                           .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "fishing.cpp:1428 CCharacter2[1]",                           .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "fishing.cpp:1430 CCharacter2[1]",                           .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "fishing.cpp:1432 CCharacter2[1]",                           .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "funcpoint.cpp:495 CList<CFuncPoint>[1]",                    .host_bytes = sizeof(CList<CFuncPoint>) * 1,                     .quadwords = 0x20  },
    {.where = "maintex.cpp:283 CSWordAfterEffect[1]",                      .host_bytes = sizeof(CSWordAfterEffect) * 1,                     .quadwords = 12    },
    {.where = "mapselect.cpp:441 char *[SELECT_MAP_MAX]",                  .host_bytes = sizeof(char *) * SELECT_MAP_MAX,                   .quadwords = 0x22  },
    {.where = "mapselect.cpp:998 EVENT_VIEW_INFO[EVENT_VIEW_MAX]",         .host_bytes = sizeof(EVENT_VIEW_INFO) * EVENT_VIEW_MAX,          .quadwords = 0x382 },
    {.where = "mdslist.cpp:245 CCharacter2[1]",                            .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "mdslist.cpp:803 CCharacter2[1]",                            .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "menuchr.cpp:1030 mgCTexture[1]",                            .host_bytes = sizeof(mgCTexture) * 1,                            .quadwords = 9     },
    {.where = "menuchr.cpp:1189 CActionChara[1]",                          .host_bytes = sizeof(CActionChara) * 1,                          .quadwords = 0x105 },
    {.where = "menuchr.cpp:6620 CActionChara[1]",                          .host_bytes = sizeof(CActionChara) * 1,                          .quadwords = 0x105 },
    {.where = "menuchr.cpp:7242 CMenuCostumeSel[1]",                       .host_bytes = sizeof(CMenuCostumeSel) * 1,                       .quadwords = 0x2F  },
    {.where = "menuchr.cpp:7828 CActionChara[1]",                          .host_bytes = sizeof(CActionChara) * 1,                          .quadwords = 0x105 },
    {.where = "menuchr.cpp:7876 CMosBookMenu[1]",                          .host_bytes = sizeof(CMosBookMenu) * 1,                          .quadwords = 0x9A  },
    {.where = "menudraw.cpp:5809 mgCTexture[1]",                           .host_bytes = sizeof(mgCTexture) * 1,                            .quadwords = 9     },
    {.where = "menudraw.cpp:5810 mgCTexture[1]",                           .host_bytes = sizeof(mgCTexture) * 1,                            .quadwords = 9     },
    {.where = "menudraw.cpp:5811 mgCTexture[1]",                           .host_bytes = sizeof(mgCTexture) * 1,                            .quadwords = 9     },
    {.where = "menudraw.cpp:6359 CActionChara[1]",                         .host_bytes = sizeof(CActionChara) * 1,                          .quadwords = 0x105 },
    {.where = "menudraw.cpp:6402 CRepairEffect[1]",                        .host_bytes = sizeof(CRepairEffect) * 1,                         .quadwords = 5     },
    {.where = "menuop.cpp:3128 CDC2Mes[1]",                                .host_bytes = sizeof(CDC2Mes) * 1,                               .quadwords = 0x2A7 },
    {.where = "menushop.cpp:1868 CShopMenu[1]",                            .host_bytes = sizeof(CShopMenu) * 1,                             .quadwords = 0x23  },
    {.where = "menushop.cpp:1874 CShop[1]",                                .host_bytes = sizeof(CShop) * 1,                                 .quadwords = 0x123 },
    {.where = "menushop.cpp:1888 CMenuMoveItem[1]",                        .host_bytes = sizeof(CMenuMoveItem) * 1,                         .quadwords = 0x13  },
    {.where = "menushop.cpp:2336 CMenuQuestView[1]",                       .host_bytes = sizeof(CMenuQuestView) * 1,                        .quadwords = 0x1B  },
    {.where = "menushop.cpp:2341 CQuestManager[1]",                        .host_bytes = sizeof(CQuestManager) * 1,                         .quadwords = 3     },
    {.where = "menusys.cpp:6954 CActionChara[1]",                          .host_bytes = sizeof(CActionChara) * 1,                          .quadwords = 0x105 },
    {.where = "menusys.cpp:6960 CMenuMoveItem[1]",                         .host_bytes = sizeof(CMenuMoveItem) * 1,                         .quadwords = 0x13  },
    {.where = "menusys.cpp:6964 CActionChara[1]",                          .host_bytes = sizeof(CActionChara) * 1,                          .quadwords = 0x105 },
    {.where = "menusys.cpp:6966 CMenuEffect[1]",                           .host_bytes = sizeof(CMenuEffect) * 1,                           .quadwords = 6     },
    {.where = "menusys.cpp:6972 CMenuEffect[1]",                           .host_bytes = sizeof(CMenuEffect) * 1,                           .quadwords = 6     },
    {.where = "menusys.cpp:6978 CRepairManager[1]",                        .host_bytes = sizeof(CRepairManager) * 1,                        .quadwords = 0x21  },
    {.where = "menusys.cpp:11797 CDC2Mes[1]",                              .host_bytes = sizeof(CDC2Mes) * 1,                               .quadwords = 0x2A7 },
    {.where = "mg_dataset.cpp:867 mgCFrame::BoundInfo[1]",                 .host_bytes = sizeof(mgCFrame::BoundInfo) * 1,                   .quadwords = 0xD   },
    {.where = "mg_dataset.cpp:1034 mgCFrame::BoundInfo[1]",                .host_bytes = sizeof(mgCFrame::BoundInfo) * 1,                   .quadwords = 0xD   },
    {.where = "mg_shadow.cpp:162 mgCFace[1]",                              .host_bytes = sizeof(mgCFace) * 1,                               .quadwords = 5     },
    {.where = "mg_tanime.cpp:653 CList<mgCTexAnimeData>[1]",               .host_bytes = sizeof(CList<mgCTexAnimeData>) * 1,                .quadwords = 6     },
    {.where = "mg_tanime.cpp:1081 mgCTextureAnime[1]",                     .host_bytes = sizeof(mgCTextureAnime) * 1,                       .quadwords = 0x21  },
    {.where = "mg_visual.cpp:504 mgFACE_GROUP[1]",                         .host_bytes = sizeof(mgFACE_GROUP) * 1,                          .quadwords = 4     },
    {.where = "mg_visual.cpp:522 mgFACE_GROUP[1]",                         .host_bytes = sizeof(mgFACE_GROUP) * 1,                          .quadwords = 4     },
    {.where = "monster.cpp:1109 CSWordAfterEffect[1]",                     .host_bytes = sizeof(CSWordAfterEffect) * 1,                     .quadwords = 0xC   },
    {.where = "movieviewlp.cpp:203 CMovie[1]",                             .host_bytes = sizeof(CMovie) * 1,                                .quadwords = 0x2396},
    {.where = "movieviewlp.cpp:205 MOVIE_LIST_ENTRY[64]",                  .host_bytes = sizeof(MOVIE_LIST_ENTRY) * 64,                     .quadwords = 0x32  },
    {.where = "nameregi.cpp:1067 CNameRegiMenu[1]",                        .host_bytes = sizeof(CNameRegiMenu) * 1,                         .quadwords = 0xBF  },
    {.where = "sceneload.cpp:187 CCharacter2[1]",                          .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "sceneload.cpp:242 CCharacter2[1]",                          .host_bytes = sizeof(CCharacter2) * 1,                           .quadwords = 0x68  },
    {.where = "sceneload.cpp:325 CEditMap[1]",                             .host_bytes = sizeof(CEditMap) * 1,                              .quadwords = 0x111 },
    {.where = "sceneload.cpp:401 CMapSky[1]",                              .host_bytes = sizeof(CMapSky) * 1,                               .quadwords = 0x13  },
    {.where = "scenevillager.cpp:851 CVillagerPlaceInfo[1]",               .host_bytes = sizeof(CVillagerPlaceInfo) * 1,                    .quadwords = 6     },
    {.where = "title.cpp:661 TITLE_INFO[1]",                               .host_bytes = sizeof(TITLE_INFO) * 1,                            .quadwords = 0x1C  },
    {.where = "title.cpp:686 CMemoryCardManager[1]",                       .host_bytes = sizeof(CMemoryCardManager) * 1,                    .quadwords = 0x112 },
    {.where = "title.cpp:688 mgCCameraFollow[1]",                          .host_bytes = sizeof(mgCCameraFollow) * 1,                       .quadwords = 0xE   },
    {.where = "title.cpp:689 mgCCamera[1]",                                .host_bytes = sizeof(mgCCamera) * 1,                             .quadwords = 9     },
    {.where = "title.cpp:690 CWaveTable[1]",                               .host_bytes = sizeof(CWaveTable) * 1,                            .quadwords = 0x123 },
    {.where = "title.cpp:2644 CDC2Mes[1]",                                 .host_bytes = sizeof(CDC2Mes) * 1,                               .quadwords = 0x2A7 },
    {.where = "title.cpp:2645 CDC2Mes[1]",                                 .host_bytes = sizeof(CDC2Mes) * 1,                               .quadwords = 0x2A7 },
    {.where = "villagermngr.cpp:46 CVillagerPlaceInfo::Node[1]",           .host_bytes = sizeof(CVillagerPlaceInfo::Node) * 1,              .quadwords = 4     },
};

// Casted Alloc runs carry no type, so the count is what the caller hands the run (load capacity,
// loop bound, fixed write length) rather than a placement count.
const Site kCastSites[] = {
    {.where = "actscript.cpp:2612 RS_STACKDATA x 0x80",         .host_bytes = sizeof(RS_STACKDATA) * 0x80,       .quadwords = 0x40 },
    {.where = "actscript.cpp:2613 RS_CALLDATA x 0x200",         .host_bytes = sizeof(RS_CALLDATA) * 0x200,       .quadwords = 0x180},
    {.where = "dngmenu.cpp:2579 DNGMAP_KOMA_POS x 1",           .host_bytes = sizeof(DNGMAP_KOMA_POS) * 1,       .quadwords = 1    },
    {.where = "dngmenu.cpp:2609 DNGMAP_KOMA_POS x 1",           .host_bytes = sizeof(DNGMAP_KOMA_POS) * 1,       .quadwords = 1    },
    {.where = "dngmenu.cpp:2617 DNGMAP_KOMA_POS x 1",           .host_bytes = sizeof(DNGMAP_KOMA_POS) * 1,       .quadwords = 1    },
    {.where = "dngmenu.cpp:2642 DNGMAP_KOMA_POS x 1",           .host_bytes = sizeof(DNGMAP_KOMA_POS) * 1,       .quadwords = 1    },
    {.where = "dngmenu.cpp:2650 DNGMAP_KOMA_POS x 1",           .host_bytes = sizeof(DNGMAP_KOMA_POS) * 1,       .quadwords = 1    },
    {.where = "dngmenu.cpp:2664 DNGMAP_KOMA_POS x 1",           .host_bytes = sizeof(DNGMAP_KOMA_POS) * 1,       .quadwords = 1    },
    {.where = "dngmenu.cpp:2672 DNGMAP_KOMA_POS x 1",           .host_bytes = sizeof(DNGMAP_KOMA_POS) * 1,       .quadwords = 1    },
    {.where = "dynamicanime.cpp:1005 int x 4",                  .host_bytes = sizeof(int) * 4,                   .quadwords = 1    },
    {.where = "effscript.cpp:5563 RS_STACKDATA x 0x40",         .host_bytes = sizeof(RS_STACKDATA) * 0x40,       .quadwords = 0x20 },
    {.where = "event.cpp:112 RS_STACKDATA x 0x80",              .host_bytes = sizeof(RS_STACKDATA) * 0x80,       .quadwords = 0x40 },
    {.where = "event.cpp:113 RS_CALLDATA x 0x200",              .host_bytes = sizeof(RS_CALLDATA) * 0x200,       .quadwords = 0x180},
    {.where = "mapload.cpp:780 float x 4",                      .host_bytes = sizeof(float) * 4,                 .quadwords = 1    },
    {.where = "menucapt.cpp:110 MENU_CHAPTER_INFO x 1",         .host_bytes = sizeof(MENU_CHAPTER_INFO) * 1,     .quadwords = 2    },
    {.where = "menuchr.cpp:776 MENU_BGREAD_INFO2 x 1",          .host_bytes = sizeof(MENU_BGREAD_INFO2) * 1,     .quadwords = 8    },
    {.where = "menuchr.cpp:4135 MENU_BGREAD_INFO2 x 1",         .host_bytes = sizeof(MENU_BGREAD_INFO2) * 1,     .quadwords = 8    },
    {.where = "menucommon.cpp:2033 MENU_FORM_ACTION_MOVE x 1",  .host_bytes = sizeof(MENU_FORM_ACTION_MOVE) * 1, .quadwords = 2    },
    {.where = "menudraw.cpp:1515 float x 0x9C * 0x20",          .host_bytes = sizeof(float) * (0x9C * 0x20),     .quadwords = 0x4E0},
    {.where = "menudraw.cpp:5776 char x 5",                     .host_bytes = sizeof(char) * 5,                  .quadwords = 1    }, // "icon" plus terminator
    {.where = "mg_drawprim.cpp:751 mgSORT_PACKET x 1",          .host_bytes = sizeof(mgSORT_PACKET) * 1,         .quadwords = 1    },
    {.where = "mg_shadow.cpp:186 mgFACE_GROUP x 1",             .host_bytes = sizeof(mgFACE_GROUP) * 1,          .quadwords = 0x12 },
    {.where = "mg_visual.cpp mgCFace x 1",                      .host_bytes = sizeof(mgCFace) * 1,               .quadwords = 2    },
    {.where = "nameregi.cpp:761 NAMEREGI_KANJI_NODE x 1",       .host_bytes = sizeof(NAMEREGI_KANJI_NODE) * 1,   .quadwords = 1    },
    {.where = "nameregi.cpp:764 NAMEREGI_KANJI_NODE x 1",       .host_bytes = sizeof(NAMEREGI_KANJI_NODE) * 1,   .quadwords = 1    },
    {.where = "runscript_opcodes.cpp:4678 RS_STACKDATA x 0x80", .host_bytes = sizeof(RS_STACKDATA) * 0x80,       .quadwords = 0x40 },
    {.where = "runscript_opcodes.cpp:4679 RS_CALLDATA x 0x200", .host_bytes = sizeof(RS_CALLDATA) * 0x200,       .quadwords = 0x180},
    {.where = "scenevillager.cpp:1094 CCPoly x 0x80",           .host_bytes = sizeof(CCPoly) * 0x80,             .quadwords = 0x280},
};

} // namespace

TEST(CtArenaPlacement, RetailRunsAgainstHostSizes) {
    std::vector<std::string> outgrowing;
    for (const Site &site : kSites) {
        const std::size_t run_bytes = static_cast<std::size_t>(site.quadwords) * 16;
        if (site.host_bytes > run_bytes) {
            std::println("outgrows: {} host {} run {}", site.where, site.host_bytes, run_bytes);
            outgrowing.emplace_back(site.where);
        }
    }

    // These current native types exceed the corresponding retail quadword reservations.
    const std::vector<std::string> kOutgrowing = {
        "automap.cpp:821 AUTOMAP_ROOM_INFO[AUTOMAP_ROOM_INFO_MAX]",
        "character.cpp:3792 CSWordAfterEffect[1]",
        "dngmenu.cpp:3947 CMenuTreeMap[1]",
        "dngmenu.cpp:3949 CDngFreeMap[1]",
        "editeff.cpp:82 CPaintEffect[1]",
        "editeff.cpp:554 CMapParts[1]",
        "editexception.cpp:390 mgC3DSprite[1]",
        "editexception.cpp:392 mgCFrame[1]",
        "editexception.cpp:691 mgCFrame[1]",
        "editexception.cpp:696 CGeyserEffect[4]",
        "editmenu.cpp:1222 CDC2Mes[1]",
        "editmenu.cpp:2099 CDC2Mes[1]",
        "editmenu.cpp:5763 CRemovalMenu[1]",
        "editmode.cpp:676 CCharacter2[1]",
        "editmode.cpp:695 CCharacter2[1]",
        "editmode.cpp:710 CCharacter2[1]",
        "effscript.cpp:560 CCharacter2[1]",
        "effscript.cpp:1294 CCharacter2[1]",
        "event_func.cpp:6080 CCharacter2[1]",
        "event_func.cpp:17132 CSWordAfterEffect[1]",
        "fishing.cpp:1197 CCharacter2[1]",
        "fishing.cpp:1420 CCharacter2[1]",
        "fishing.cpp:1422 CCharacter2[1]",
        "fishing.cpp:1424 CCharacter2[1]",
        "fishing.cpp:1426 CCharacter2[1]",
        "fishing.cpp:1428 CCharacter2[1]",
        "fishing.cpp:1430 CCharacter2[1]",
        "fishing.cpp:1432 CCharacter2[1]",
        "funcpoint.cpp:495 CList<CFuncPoint>[1]",
        "maintex.cpp:283 CSWordAfterEffect[1]",
        "mapselect.cpp:441 char *[SELECT_MAP_MAX]",
        "mapselect.cpp:998 EVENT_VIEW_INFO[EVENT_VIEW_MAX]",
        "mdslist.cpp:245 CCharacter2[1]",
        "mdslist.cpp:803 CCharacter2[1]",
        "menuchr.cpp:1189 CActionChara[1]",
        "menuchr.cpp:6620 CActionChara[1]",
        "menuchr.cpp:7242 CMenuCostumeSel[1]",
        "menuchr.cpp:7828 CActionChara[1]",
        "menuchr.cpp:7876 CMosBookMenu[1]",
        "menudraw.cpp:6359 CActionChara[1]",
        "menuop.cpp:3128 CDC2Mes[1]",
        "menushop.cpp:1868 CShopMenu[1]",
        "menusys.cpp:6954 CActionChara[1]",
        "menusys.cpp:6964 CActionChara[1]",
        "menusys.cpp:6978 CRepairManager[1]",
        "menusys.cpp:11797 CDC2Mes[1]",
        "mg_tanime.cpp:1081 mgCTextureAnime[1]",
        "monster.cpp:1109 CSWordAfterEffect[1]",
        "movieviewlp.cpp:205 MOVIE_LIST_ENTRY[64]",
        "sceneload.cpp:187 CCharacter2[1]",
        "sceneload.cpp:242 CCharacter2[1]",
        "sceneload.cpp:325 CEditMap[1]",
        "sceneload.cpp:401 CMapSky[1]",
        "title.cpp:661 TITLE_INFO[1]",
        "title.cpp:686 CMemoryCardManager[1]",
        "title.cpp:2644 CDC2Mes[1]",
        "title.cpp:2645 CDC2Mes[1]",
    };
    EXPECT_EQ(outgrowing, kOutgrowing);
}

TEST(CtArenaPlacement, CastRunsAgainstHostSizes) {
    std::vector<std::string> outgrowing;
    for (const Site &site : kCastSites) {
        const std::size_t run_bytes = static_cast<std::size_t>(site.quadwords) * 16;
        if (site.host_bytes > run_bytes) {
            std::println("outgrows: {} host {} run {}", site.where, site.host_bytes, run_bytes);
            outgrowing.emplace_back(site.where);
        }
    }

    // Cast, not placed, so nothing grows them: each overruns its run on the host.
    const std::vector<std::string> kCastOutgrowing = {
        "actscript.cpp:2612 RS_STACKDATA x 0x80",
        "actscript.cpp:2613 RS_CALLDATA x 0x200",
        "effscript.cpp:5563 RS_STACKDATA x 0x40",
        "event.cpp:112 RS_STACKDATA x 0x80",
        "event.cpp:113 RS_CALLDATA x 0x200",
        "mg_drawprim.cpp:751 mgSORT_PACKET x 1",
        "runscript_opcodes.cpp:4678 RS_STACKDATA x 0x80",
        "runscript_opcodes.cpp:4679 RS_CALLDATA x 0x200",
    };
    EXPECT_EQ(outgrowing, kCastOutgrowing);
}

TEST(CtArenaPlacement, VillagerPlacesConstructDefaultsAndRejectExhaustedStorage) {
    constexpr auto quadwords = (sizeof(CVillagerPlaceInfo) + sizeof(u_long128) - 1) / sizeof(u_long128);
    mgCMemory      memory;
    auto          *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&memory, (quadwords + 1) * sizeof(u_long128)));
    memory.stSetBuffer(storage, static_cast<int>(quadwords + 1));
    std::memset(storage, 0xA5, (quadwords + 1) * sizeof(u_long128));
    const auto *place = dc2::memory::NewObject<CVillagerPlaceInfo>(memory);
    ASSERT_NE(place, nullptr);
    EXPECT_EQ(place->map_no, -1);
    EXPECT_EQ(place->route, nullptr);
    EXPECT_EQ(place->motion, 0);
    EXPECT_EQ(place->move_motion, 0);
    EXPECT_EQ(place->move_speed, 0.0f);
    EXPECT_EQ(place->no_shadow, 0);
    EXPECT_EQ(place->unk_38, 0);
    EXPECT_EQ(place->unk_3c, 0);
    for (const auto value : place->pos) {
        EXPECT_EQ(value, 0.0f);
    }
    for (const auto value : place->talk_offset) {
        EXPECT_EQ(value, 0.0f);
    }
    const auto used = memory.stGetUsed();
    EXPECT_EQ(dc2::memory::NewObject<CVillagerPlaceInfo>(memory), nullptr);
    EXPECT_EQ(memory.stGetUsed(), used);
}
