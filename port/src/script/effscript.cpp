#include "common.h"
#include "mw_runtime.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iterator>
#include <limits>
#include <string_view>
#include <type_traits>

#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "colprim.hpp"
#include "dataread.hpp"
#include "dng_main.hpp"
#include "effscript.hpp"
#include "event_func.hpp"
#include "log/game_output.hpp"
#include "mainloop.hpp"
#include "map.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "object.hpp"
#include "padcontrol.hpp"
#include "runscript_opcodes.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "text/bounded.hpp"

namespace {

/**
 *
 * Copies all four vector components while preserving overlapping source values.
 *
 */
void CopyEffectVector(float *destination, const float *source) {
    const std::array<float, 4> snapshot{source[0], source[1], source[2], source[3]};
    std::copy(snapshot.begin(), snapshot.end(), destination);
}

} // namespace

/**
 * Available effect script resource definitions.
 */
EFF_SPT_BASE_DEF eff_spt_base_def[EFF_SPT_BASE_DEF_NUM] = {
    {"\x94\x9A\x94\xAD",                                                                   EFF_SPT_BASE_CHR, "Explosion_s",      "explosion"       },
    {"\x92\xB1\x83\x72\x81\x5B\x83\x80",                                                   EFF_SPT_BASE_IMG, "nana_rinpun",      "beam"            },
    {"\x92\xB1\x82\xE8\x82\xF1\x82\xD5\x82\xF1",                                           EFF_SPT_BASE_CHR, "b02a_rinpun_l",    "nana_rinpun_l"   },
    {"\x92\xB1\x82\xE8\x82\xF1\x82\xD5\x82\xF1\x82\x67",                                   EFF_SPT_BASE_CHR, "b02a_rinpun_h",    "nana_rinpun_h"   },
    {"\x92\xCA\x8F\xED\x89\xF1\x95\x9C",                                                   EFF_SPT_BASE_IMG, "n_heal",           "n_heal"          },
    {"\x92\xCA\x8F\xED\x89\xF1\x95\x9C\x83\x54\x83\x75",                                   EFF_SPT_BASE_IMG, "n_heal",           "n_heal_sub"      },
    {"\x83\x8D\x83\x7B\x83\x7E\x83\x54\x83\x43\x83\x8B",                                   EFF_SPT_BASE_CHR, "polm",             "polm"            },
    {"\x83\x8D\x83\x7B\x83\x7E\x83\x54\x83\x43\x83\x8B\x89\x8C",                           EFF_SPT_BASE_IMG, "m_kemuri",         "polm_smoke"      },
    {"\x83\x7D\x83\x59\x83\x8B\x83\x74\x83\x89\x83\x62\x83\x56\x83\x85",                   EFF_SPT_BASE_IMG, "effect00",         "gun_flash"       },
    {"\x83\x89\x83\x74\x83\x8C\x83\x56\x83\x41\x89\xD4\x95\xB2",                           EFF_SPT_BASE_IMG, "spore",            "spore"           },
    {"\x83\x89\x83\x74\x83\x8C\x83\x56\x83\x41\x89\xD4\x95\xB2\x83\x54\x83\x75",           EFF_SPT_BASE_IMG, "spore",            "spore_sub"       },
    {"\x83\x8D\x83\x7B\x83\x7E\x83\x54\x83\x43\x83\x8B\x94\x9A\x94\xAD",                   EFF_SPT_BASE_CHR, "m_exp",            "m_exp"           },
    {"\x92\xB1\x8D\x87\x91\xCC",                                                           EFF_SPT_BASE_CHR, "union",            "union"           },
    {"\x83\x4D\x83\x8B\x83\x67\x81\x5B\x83\x6A\x83\x56\x81\x5B\x83\x8B\x83\x68",           EFF_SPT_BASE_CHR, "g_shield",         "g_shield"        },
    {"\x83\x4D\x83\x8B\x83\x67\x81\x5B\x83\x6A\x96\x82\x96\x40",                           EFF_SPT_BASE_CHR, "g_magic",          "g_magic"         },
    {"\x83\x4D\x83\x8B\x83\x67\x81\x5B\x83\x6A\x96\x82\x96\x40\x83\x54\x83\x75",           EFF_SPT_BASE_CHR, "g_magic_obj",      "g_magic_sub"     },
    {"\x83\x86\x83\x8A\x83\x58\x97\xAD\x82\xDF\x8D\x55\x8C\x82",                           EFF_SPT_BASE_CHR, "c01tame",          "c01tame"         },
    {"\x83\x82\x83\x6A\x83\x4A\x97\xAD\x82\xDF\x8D\x55\x8C\x82",                           EFF_SPT_BASE_CHR, "c02tame",          "c02tame"         },
    {"\x83\x82\x83\x6A\x83\x4A\x96\x82\x96\x40\x81\x7C\x97\x8B",                           EFF_SPT_BASE_IMG, "c02lightning_hit", "c02lightning"    },
    {"\x83\x82\x83\x6A\x83\x4A\x96\x82\x96\x40\x81\x7C\x97\x8B\x83\x71\x83\x62\x83\x67",   EFF_SPT_BASE_IMG, "c02lightning_hit", "c02lightning_hit"},
    {"\x8D\xBB\x89\x8C",                                                                   EFF_SPT_BASE_IMG, "base_eff2",        "pother"          },
    {"\x91\xAB\x8D\xBB\x89\x8C",                                                           EFF_SPT_BASE_IMG, "base_eff2",        "foot_pother"     },
    {"\x83\x82\x83\x6A\x83\x4A\x96\x82\x96\x40\x81\x7C\x89\xCE",                           EFF_SPT_BASE_IMG, "c02flame",         "c02flame"        },
    {"\x83\x82\x83\x6A\x83\x4A\x96\x82\x96\x40\x81\x7C\x89\xCE\x83\x71\x83\x62\x83\x67",   EFF_SPT_BASE_IMG, "c02flame",         "c02flame_h"      },
    {"\x83\x4B\x81\x5B\x83\x68\x83\x47\x83\x74\x83\x46\x83\x4E\x83\x67\x82\x60",           EFF_SPT_BASE_IMG, "effect01",         "guard_eff_a"     },
    {"\x8F\x65\x92\x65",                                                                   EFF_SPT_BASE_IMG, "effect00",         "bullet"          },
    {"\x8E\xE8\x93\x8A\x82\xB0\x94\x9A\x92\x65",                                           EFF_SPT_BASE_CHR, "",                 "bakudan"         },
    {"\x83\x71\x83\x7D\x81\x5B\x83\x89\x89\xF1\x93\x5D\x8D\x55\x8C\x82",                   EFF_SPT_BASE_CHR, "e216ex_kaiten",    "e216ex_kaiten"   },
    {"fox_\x8F\x65\x92\x65",                                                               EFF_SPT_BASE_IMG, "effect00",         "fox_bullet"      },
    {"\x83\x81\x83\x80\x83\x43\x81\x5B\x83\x5E\x81\x5B\x92\x65",                           EFF_SPT_BASE_IMG, "effect00",         "mem_bullet"      },
    {"\x83\x94\x83\x40\x83\x93\x83\x4B\x81\x5B\x83\x68\x8F\xD5\x8C\x82\x94\x67",           EFF_SPT_BASE_CHR, "m_shockwave",      "m_shockwave"     },
    {"e110\x83\x7C\x83\x8B\x89\xF1\x93\x5D\x83\x4C\x83\x89",                               EFF_SPT_BASE_IMG, "p_kirakira",       "e110pol1"        },
    {"\x83\x67\x81\x5B\x83\x8C\x82\xCC\x89\x8C",                                           EFF_SPT_BASE_IMG, "smoke_tore",       "smoke_tore"      },
    {"\x91\xAB\x94\x67\x96\xE4",                                                           EFF_SPT_BASE_CHR, "f_hamon",          "foot_hamon"      },
    {"\x91\xAB\x90\x85\x83\x70\x83\x56\x83\x83",                                           EFF_SPT_BASE_IMG, "base_eff2",        "foot_splatter"   },
    {"\x91\xAB\x8E\xC5\x90\xB6",                                                           EFF_SPT_BASE_IMG, "base_eff2",        "foot_grass"      },
    {"\x8F\xAC\x90\xB8\x97\xEC\x94\x9A\x94\xAD",                                           EFF_SPT_BASE_CHR, "m_explosion",      "m_explosion"     },
    {"\x83\x73\x83\x47\x83\x8D\x95\xBA\x83\x69\x83\x43\x83\x74",                           EFF_SPT_BASE_CHR, "e211aex_knife",    "e211aex_knife"   },
    {"\x93\xC5\x89\x74L",                                                                  EFF_SPT_BASE_CHR, "m_dokueki_l",      "m_dokueki_l"     },
    {"\x93\xC5\x89\x74H",                                                                  EFF_SPT_BASE_CHR, "m_dokueki_h",      "m_dokueki_h"     },
    {"\x89\xCE\x89\x8A\x92\x65\x94\xAD\x93\xAE",                                           EFF_SPT_BASE_CHR, "m_fball_f",        "m_fball_f"       },
    {"\x89\xCE\x89\x8A\x92\x65\x83\x8B\x81\x5B\x83\x76",                                   EFF_SPT_BASE_CHR, "m_fball_l",        "m_fball_l"       },
    {"\x89\xCE\x89\x8A\x92\x65\x83\x71\x83\x62\x83\x67",                                   EFF_SPT_BASE_CHR, "m_fball_h",        "m_fball_h"       },
    {"\x83\x8D\x83\x7B\x8C\xCC\x8F\xE1",                                                   EFF_SPT_BASE_CHR, "kosyou",           "robo_failure"    },
    {"\x93\xC5\x89\x74"
     "2L",
     EFF_SPT_BASE_CHR,                                                                                       "m_dokueki_l",      "m_dokueki2_l"    },
    {"\x89\xCE\x89\x8A\x92\x65\x83\x8B\x81\x5B\x83\x76\x82\x51",                           EFF_SPT_BASE_CHR, "m_fball_l",        "m_fball_l2"      },
    {"\x89\xCE\x89\x8A\x92\x65\x83\x8B\x81\x5B\x83\x76\x82\x52",                           EFF_SPT_BASE_CHR, "m_fball_l",        "m_fball_l3"      },
    {"\x89\xCE\x89\x8A\x92\x65\x83\x8B\x81\x5B\x83\x76\x82\x53",                           EFF_SPT_BASE_CHR, "m_fball_l",        "m_fball_l4"      },
    {"\x83\x82\x83\x6A\x83\x4A\x96\x82\x96\x40\x81\x7C\x95\x97",                           EFF_SPT_BASE_IMG, "c02wind",          "c02wind"         },
    {"\x83\x82\x83\x6A\x83\x4A\x96\x82\x96\x40\x81\x7C\x95\x97\x83\x71\x83\x62\x83\x67",   EFF_SPT_BASE_IMG, "c02wind",          "c02wind_h"       },
    {"\x83\x82\x83\x6A\x83\x4A\x96\x82\x96\x40\x81\x7C\x95\x58",                           EFF_SPT_BASE_CHR, "c02cold",          "c02cold"         },
    {"\x83\x82\x83\x6A\x83\x4A\x96\x82\x96\x40\x81\x7C\x95\x58\x83\x71\x83\x62\x83\x67",   EFF_SPT_BASE_CHR, "c02cold",          "c02cold_h"       },
    {"\x83\x82\x83\x6A\x83\x4A\x96\x82\x96\x40\x81\x7C\x97\xAD\x82\xDF",                   EFF_SPT_BASE_IMG, "effect01",         "c02_magic_tame"  },
    {"\x83\x6F\x83\x4D\x81\x5B\x8D\xBB\x89\x8C",                                           EFF_SPT_BASE_IMG, "base_eff2",        "buggy_pother"    },
    {"\x95\xF3\x94\xA0\x94\x9A\x94\xAD",                                                   EFF_SPT_BASE_CHR, "m_exp",            "tbox_exp"        },
    {"\x83\x70\x83\x93\x83\x76\x83\x4C\x83\x93\x83\x77\x83\x62\x83\x68\x94\x9A\x92\x65",   EFF_SPT_BASE_CHR, "bakudan",          "pump_bakudan"    },
    {"\x83\x6F\x83\x89",                                                                   EFF_SPT_BASE_CHR, "b06a_bara",        "bara"            },
    {"\x83\x6F\x83\x89\x83\x71\x83\x62\x83\x67",                                           EFF_SPT_BASE_CHR, "b06a_bara_h",      "bara_hit"        },
    {"\x83\x54\x83\x93\x82\xCC\x97\xB3\x8A\xAA",                                           EFF_SPT_BASE_CHR, "b06a_tatumaki",    "b06a_tatu"       },
    {"\x8E\xB5\x90\x46\x92\xB1\x82\xCC\x89\xCE\x92\x8C",                                   EFF_SPT_BASE_CHR, "b02a_hibasira_s",  "b02a_hibasira"   },
    {"EV\x83\x82\x83\x6A\x83\x4A\x96\x82\x96\x40\x81\x7C\x89\xCE",                         EFF_SPT_BASE_IMG, "c02flame",         "ev_c02flame"     },
    {"EV\x83\x82\x83\x6A\x83\x4A\x96\x82\x96\x40\x81\x7C\x89\xCE\x83\x71\x83\x62\x83\x67", EFF_SPT_BASE_IMG, "c02flame",         "ev_c02flame_h"   },
    {"\x96\x43\x92\x65",                                                                   EFF_SPT_BASE_CHR, "b15a_tama1",       "houdan"          },
    {"\x8B\x40\x8F\x65",                                                                   EFF_SPT_BASE_CHR, "b15a_tama",        "kizyu"           },
    {"\x82\x6C\x83\x4D\x83\x8B\x89\xCE\x92\x8C\x82\x50",                                   EFF_SPT_BASE_CHR, "p00_23a_hibasira", "p00_23a_hibasira"},
    {"\x82\x6C\x83\x4D\x83\x8B\x89\xCE\x89\x8A\x92\x65\x82\x50",                           EFF_SPT_BASE_CHR, "m_fball_l",        "mg_fball1"       },
    {"\x82\x6C\x83\x4D\x83\x8B\x89\xCE\x89\x8A\x92\x65\x82\x51",                           EFF_SPT_BASE_CHR, "p00_23a_fball",    "mg_fball2"       },
    {"\x82\x6C\x83\x4D\x83\x8B\x89\xCE\x89\x8A\x92\x65\x82\x52",                           EFF_SPT_BASE_CHR, "p00_23a_fball",    "mg_fball3"       },
    {"\x82\x6C\x83\x4D\x83\x8B\x89\xCE\x82\xCC\x95\xB2",                                   EFF_SPT_BASE_IMG, "hinoko",           "hinoko"          },
    {"\x82\x6C\x83\x4D\x83\x8B\x82\xDB\x82\xBD\x82\xDB\x82\xBD",                           EFF_SPT_BASE_IMG, "hinoko",           "potapota"        },
    {"\x82\x6C\x83\x4D\x83\x8B\x82\xB5\x82\xD4\x82\xAB",                                   EFF_SPT_BASE_CHR, "p00_23a_msibuki",  "p00_23a_msibuki" },
    {"\x82\x6C\x83\x4D\x83\x8B\x89\x8C",                                                   EFF_SPT_BASE_IMG, "effect00",         "mguil_kemuri"    },
    {"\x83\x56\x81\x5B\x83\x4F\x83\x89\x82\xC8\x82\xAC\x95\xA5\x82\xA2",                   EFF_SPT_BASE_IMG, "base_eff2",        "seagura_dust"    },
    {"\x83\x8F\x83\x43\x83\x93\x92\x4D\x92\x65",                                           EFF_SPT_BASE_CHR, "Shell",            "robo_missile"    },
    {"\x89\xCE\x92\x65\x82\x65",                                                           EFF_SPT_BASE_CHR, "m_fball_f",        "m_fballf_f"      },
    {"\x89\xCE\x92\x65\x82\x6B",                                                           EFF_SPT_BASE_CHR, "m_fball_l",        "m_fballf_l"      },
    {"\x89\xCE\x92\x65\x82\x67",                                                           EFF_SPT_BASE_CHR, "m_fball_h",        "m_fballf_h"      },
    {"\x95\x58\x92\x65\x82\x65",                                                           EFF_SPT_BASE_CHR, "m_cball_f",        "m_cball_f"       },
    {"\x95\x58\x92\x65\x82\x6B",                                                           EFF_SPT_BASE_CHR, "m_cball_l",        "m_cball_l"       },
    {"\x95\x58\x92\x65\x82\x67",                                                           EFF_SPT_BASE_CHR, "m_cball_h",        "m_cball_h"       },
    {"\x97\x8B\x92\x65\x82\x65",                                                           EFF_SPT_BASE_CHR, "m_sball_f",        "m_sball_f"       },
    {"\x97\x8B\x92\x65\x82\x6B",                                                           EFF_SPT_BASE_CHR, "m_sball_l",        "m_sball_l"       },
    {"\x97\x8B\x92\x65\x82\x67",                                                           EFF_SPT_BASE_CHR, "m_sball_h",        "m_sball_h"       },
    {"\x95\x97\x92\x65\x82\x65",                                                           EFF_SPT_BASE_CHR, "m_wball_f",        "m_wball_f"       },
    {"\x95\x97\x92\x65\x82\x6B",                                                           EFF_SPT_BASE_CHR, "m_wball_l",        "m_wball_l"       },
    {"\x95\x97\x92\x65\x82\x67",                                                           EFF_SPT_BASE_CHR, "m_wball_h",        "m_wball_h"       },
    {"\x90\xB9\x92\x65\x82\x65",                                                           EFF_SPT_BASE_CHR, "m_hball_f",        "m_hball_f"       },
    {"\x90\xB9\x92\x65\x82\x6B",                                                           EFF_SPT_BASE_CHR, "m_hball_l",        "m_hball_l"       },
    {"\x90\xB9\x92\x65\x82\x67",                                                           EFF_SPT_BASE_CHR, "m_hball_h",        "m_hball_h"       },
    {"\x90\x85\x92\x65\x82\x65",                                                           EFF_SPT_BASE_CHR, "m_mball_f",        "m_mball_f"       },
    {"\x90\x85\x92\x65\x82\x6B",                                                           EFF_SPT_BASE_CHR, "m_mball_l",        "m_mball_l"       },
    {"\x90\x85\x92\x65\x82\x6B\x82\x51",                                                   EFF_SPT_BASE_CHR, "m_mball_l",        "m_mball_l2"      },
    {"\x90\x85\x92\x65\x82\x67",                                                           EFF_SPT_BASE_CHR, "m_mball_h",        "m_mball_h"       },
    {"\x95\x97\x92\x65\x82\x6B\x82\x51",                                                   EFF_SPT_BASE_CHR, "m_wball_l",        "m_wball_l2"      },
    {"\x95\x97\x92\x65\x82\x67\x82\x51",                                                   EFF_SPT_BASE_CHR, "m_wball_h",        "m_wball_h2"      },
    {"\x8E\xF4\x82\xA2\x92\x65\x82\x65",                                                   EFF_SPT_BASE_CHR, "m_curse_f",        "m_curse_f"       },
    {"\x8E\xF4\x82\xA2\x92\x65\x82\x6B",                                                   EFF_SPT_BASE_CHR, "m_curse_l",        "m_curse_l"       },
    {"\x8E\xF4\x82\xA2\x92\x65\x82\x67",                                                   EFF_SPT_BASE_CHR, "m_curse_h",        "m_curse_h"       },
    {"\x82\xA9\x82\xDA\x82\xBF\x82\xE1\x94\x9A\x92\x65",                                   EFF_SPT_BASE_CHR, "e10a_kabobomb",    "e10a_kabobomb"   },
    {"\x82\xA9\x82\xDA\x82\xBF\x82\xE1\x94\x9A\x94\xAD",                                   EFF_SPT_BASE_CHR, "m_fball_h",        "e10a_kabobomb_h" },
    {"\x95\x97\x92\x65\x82\x6B\x82\x51",                                                   EFF_SPT_BASE_CHR, "m_wball_l",        "m_wball_l2"      },
    {"\x83\x4D\x83\x41\x96\xEE",                                                           EFF_SPT_BASE_CHR, "e118a_arrow",      "e118a_arrow"     },
    {"\x83\x4D\x83\x41\x93\xC5\x96\xEE",                                                   EFF_SPT_BASE_CHR, "e118a_arrow_doku", "e118a_arrow_doku"},
    {"\x92\x4D\x92\x65\x82\xC4\x82\xB7\x82\xC6",                                           EFF_SPT_BASE_IMG, "effect00",         "tarub"           },
    {"\x82\x72\x83\x45\x83\x46\x81\x5B\x83\x75\x82\x6B",                                   EFF_SPT_BASE_CHR, "m_swave_l",        "m_swave_l"       },
    {"\x82\x72\x83\x45\x83\x46\x81\x5B\x83\x75\x82\x65",                                   EFF_SPT_BASE_CHR, "m_swave_f",        "m_swave_f"       },
    {"\x82\xCB\x82\xCE\x82\xCB\x82\xCE\x82\x6B",                                           EFF_SPT_BASE_CHR, "m_nebaneba_l",     "m_nebaneba_l"    },
    {"\x82\xCB\x82\xCE\x82\xCB\x82\xCE\x82\x67",                                           EFF_SPT_BASE_CHR, "m_nebaneba_h",     "m_nebaneba_h"    },
    {"\x82\xCB\x82\xCE\x82\xCB\x82\xCE\x82\x6B\x82\x51",                                   EFF_SPT_BASE_CHR, "m_nebaneba_l",     "m_nebaneba_l2"   },
    {"\x89\xCE\x92\x8C",                                                                   EFF_SPT_BASE_CHR, "m_hibasira",       "m_hibasira"      },
    {"\x95\x58\x92\x8C",                                                                   EFF_SPT_BASE_CHR, "m_hibasira_c",     "m_hibasira_c"    },
    {"\x97\x8B\x92\x8C",                                                                   EFF_SPT_BASE_CHR, "m_hibasira_s",     "m_hibasira_s"    },
    {"\x95\x97\x92\x8C",                                                                   EFF_SPT_BASE_CHR, "m_hibasira_w",     "m_hibasira_w"    },
    {"\x90\xB9\x92\x8C",                                                                   EFF_SPT_BASE_CHR, "m_hibasira_h",     "m_hibasira_h"    },
    {"\x90\x85\x92\x8C",                                                                   EFF_SPT_BASE_CHR, "m_hibasira_m",     "m_hibasira_m"    },
    {"\x89\xCE\x92\x8C\x92\x65",                                                           EFF_SPT_BASE_CHR, "m_fball_l",        "m_hball_f_l"     },
    {"\x95\x58\x92\x8C\x92\x65",                                                           EFF_SPT_BASE_CHR, "m_hball_c_l",      "m_hball_c_l"     },
    {"\x97\x8B\x92\x8C\x92\x65",                                                           EFF_SPT_BASE_CHR, "m_hball_s_l",      "m_hball_s_l"     },
    {"\x95\x97\x92\x8C\x92\x65",                                                           EFF_SPT_BASE_CHR, "m_hball_l",        "m_hball_w_l"     },
    {"\x90\xB9\x92\x8C\x92\x65",                                                           EFF_SPT_BASE_CHR, "m_hball_h_l",      "m_hball_h_l"     },
    {"\x83\x65\x83\x42\x83\x4F\x89\x48\x8D\xAA\x82\x6B",                                   EFF_SPT_BASE_CHR, "e212a_hane_l",     "e212a_hane_l"    },
    {"\x83\x65\x83\x42\x83\x4F\x89\x48\x8D\xAA\x82\x67",                                   EFF_SPT_BASE_CHR, "e212a_hane_h",     "e212a_hane_h"    },
    {"\x83\x7B\x83\x93\x83\x6F\x83\x77\x8E\xA9\x94\x9A",                                   EFF_SPT_BASE_CHR, "e49a_jibaku",      "e49a_jibaku"     },
    {"\x8F\xD5\x8C\x82\x94\x67",                                                           EFF_SPT_BASE_CHR, "m_shockwave",      "m_shockwave2"    },
    {"\x82\x6C\x8F\xAC\x94\x9A\x94\xAD",                                                   EFF_SPT_BASE_CHR, "m_explosion",      "m_explosion"     },
    {"\x83\x6F\x83\x4D\x81\x5B\x96\xF2\xE4\xB0",                                           EFF_SPT_BASE_CHR, "e204_yakkyou",     "buggy_shell_case"},
    {"\x83\x56\x83\x4F\x81\x5B\x93\x66\x82\xAB",                                           EFF_SPT_BASE_IMG, "Shigu_breath",     "Shigu_breath"    },
    {"\x83\x54\x83\x93\x83\x8F\x81\x5B\x83\x76",                                           EFF_SPT_BASE_CHR, "b06a_warp",        "b06a_warp"       },
    {"\x83\x54\x83\x93\x83\x8F\x81\x5B\x83\x76\x82\x51",                                   EFF_SPT_BASE_CHR, "b06a_warp",        "b06a_warp2"      },
    {"\x83\x58\x83\x73\x83\x93",                                                           EFF_SPT_BASE_CHR, "m_spin",           "m_spin"          },
    {"\x92\xB4\x89\xB9\x94\x67",                                                           EFF_SPT_BASE_CHR, "m_onpa",           "m_onpa"          },
    {"\x96\x82\x90\xCE\x89\x8A",                                                           EFF_SPT_BASE_CHR, "maseki_f",         "maseki_f"        },
    {"\x96\x82\x90\xCE\x97\xE2",                                                           EFF_SPT_BASE_CHR, "maseki_c",         "maseki_c"        },
    {"\x96\x82\x90\xCE\x97\x8B",                                                           EFF_SPT_BASE_CHR, "maseki_t",         "maseki_t"        },
    {"\x96\x82\x90\xCE\x95\x97",                                                           EFF_SPT_BASE_CHR, "maseki_w",         "maseki_w"        },
    {"\x96\x82\x90\xCE\x90\xB9",                                                           EFF_SPT_BASE_CHR, "maseki_h",         "maseki_h"        },
    {"\x83\x4F\x83\x8A\x89\x48\x8D\xAA\x82\x6B\x82\x50",                                   EFF_SPT_BASE_CHR, "b08a_hane_l",      "b08a_hane_l"     },
    {"\x83\x4F\x83\x8A\x89\x48\x8D\xAA\x82\x6B\x82\x51",                                   EFF_SPT_BASE_CHR, "b08a_hane_l",      "b08a_hane_l2"    },
    {"\x83\x4F\x83\x8A\x89\x48\x8D\xAA\x82\x67",                                           EFF_SPT_BASE_CHR, "b08a_hane_h",      "b08a_hane_h"     },
    {"\x8D\xBB\x89\x8C"
     "2",
     EFF_SPT_BASE_IMG,                                                                                       "base_eff2",        "pother2"         },
    {"\x8D\xBB\x89\x8C"
     "e107",
     EFF_SPT_BASE_IMG,                                                                                       "base_eff2",        "pother_e107"     },
    {"\x83\x41\x83\x67\x83\x89\x82\xCC\x8C\xF5",                                           EFF_SPT_BASE_IMG, "b08_ex",           "atora"           },
    {"\x90\xCE\x89\xBB\x92\x65\x82\x6B",                                                   EFF_SPT_BASE_CHR, "m_nebaneba_l",     "m_stnball_l"     },
    {"\x83\x4E\x83\x8D\x83\x58\x83\x4A\x83\x62\x83\x5E\x81\x5B",                           EFF_SPT_BASE_CHR, "b09a_crossgiri",   "b09a_crossgiri"  },
    {"\x83\x4F\x83\x8A\x8F\xD5\x8C\x82\x94\x67",                                           EFF_SPT_BASE_CHR, "b10a_shougekiha",  "b10a_shougekiha" },
    {"\x83\x4F\x83\x8A\x82\x72\x82\x76\x82\x6B",                                           EFF_SPT_BASE_CHR, "b10a_swave_l",     "b10a_swave_l"    },
    {"\x83\x4F\x83\x8A\x82\x72\x82\x76\x82\x65",                                           EFF_SPT_BASE_CHR, "b10a_swave_f",     "b10a_swave_f"    },
    {"\x83\x4F\x83\x8A\x83\x52\x83\x93\x83\x7B",                                           EFF_SPT_BASE_CHR, "b10a_combo",       "b10a_combo"      },
    {"\x83\x4F\x83\x8A\x89\x8A",                                                           EFF_SPT_BASE_IMG, "b10a_handfire",    "b10a_handfire"   },
    {"\x82\x6C\x94\xC4\x97\x70\x89\x8C",                                                   EFF_SPT_BASE_IMG, "effect00",         "m_hankemuri"     },
    {"\x82\x63\x82\x64\x8C\xF5\x90\xC2",                                                   EFF_SPT_BASE_CHR, "b11a_hikari_blue", "b11a_hikari_blue"},
    {"\x82\x63\x82\x64\x8C\xF5\x90\xD4",                                                   EFF_SPT_BASE_CHR, "b11a_hikari_red",  "b11a_hikari_red" },
    {"\x82\x63\x82\x64\x96\xEE",                                                           EFF_SPT_BASE_CHR, "b11a_arrow",       "b11a_arrow"      },
    {"\x82\x63\x82\x64\x83\x72\x81\x5B\x83\x80\x82\x65",                                   EFF_SPT_BASE_CHR, "b11a_beam_f",      "b11a_beam_f"     },
    {"\x82\x63\x82\x64\x83\x72\x81\x5B\x83\x80\x82\x6B",                                   EFF_SPT_BASE_CHR, "b11a_beam_l",      "b11a_beam_l"     },
    {"\x82\x63\x82\x64\x83\x72\x81\x5B\x83\x80\x82\x67",                                   EFF_SPT_BASE_CHR, "b11a_beam_h",      "b11a_beam_h"     },
    {"\x82\x63\x82\x64\x96\xEE\x82\x51",                                                   EFF_SPT_BASE_CHR, "b11a_arrow",       "b11a_arrow2"     },
    {"\x8A\x43\x91\xAF\x94\x9A\x92\x65\x94\x9A\x94\xAD",                                   EFF_SPT_BASE_CHR, "m_exp2",           "kai_bomb"        },
    {"e209\x96\x82\x96\x40",                                                               EFF_SPT_BASE_CHR, "e209_magic1",      "e209_magic"      },
    {"\x96\x83\xE1\x83\x92\x65\x82\x65",                                                   EFF_SPT_BASE_CHR, "m_mahi_f",         "m_mahi_f"        },
    {"\x96\x83\xE1\x83\x92\x65\x82\x6B",                                                   EFF_SPT_BASE_CHR, "m_mahi_l",         "m_mahi_l"        },
    {"\x96\x83\xE1\x83\x92\x65\x82\x67",                                                   EFF_SPT_BASE_CHR, "m_mahi_h",         "m_mahi_h"        },
    {"\x89\xCE\x92\x65\x82\x6B\x82\x51",                                                   EFF_SPT_BASE_CHR, "m_fball_l",        "m_fball_l2"      },
    {"\x82\x6C\x89\xF1\x95\x9C\x82\x65",                                                   EFF_SPT_BASE_CHR, "m_heal_f",         "m_heal_f"        },
    {"\x82\x6C\x89\xF1\x95\x9C",                                                           EFF_SPT_BASE_CHR, "m_heal",           "m_heal"          },
    {"\x8D\x82\x91\xAC\x92\x65",                                                           EFF_SPT_BASE_CHR, "e25a_tama",        "e25a_tama"       },
    {"\x89\xCE\x92\x65\x82\x6B\x82\x52",                                                   EFF_SPT_BASE_CHR, "m_fball_l",        "m_fball_l3"      },
    {"\x95\x58\x92\x65\x82\x6B\x82\x51",                                                   EFF_SPT_BASE_CHR, "m_cball_l",        "m_cball_l2"      },
    {"\x82\x64\x82\x55\x82\x53\x82\x4F\x8C\x8E\x89\xD4\x83\x72\x81\x5B\x83\x80",           EFF_SPT_BASE_CHR, "e640_beamhajike",  "e640_beam"       },
    {"\x97\x8B\x92\x65\x82\x6B\x82\x51",                                                   EFF_SPT_BASE_CHR, "m_sball_l",        "m_sball_l2"      },
    {"\x90\xB9\x92\x65\x82\x6B\x82\x51",                                                   EFF_SPT_BASE_CHR, "m_hball_l",        "m_hball_l2"      },
    {"\x82\x64\x82\x55\x82\x50\x82\x55\x8C\x8E\x89\xD4\x83\x72\x81\x5B\x83\x80\x82\x60",   EFF_SPT_BASE_CHR, "e616_tama",        "e616_beam_a"     },
    {"\x82\x64\x82\x55\x82\x50\x82\x55\x8C\x8E\x89\xD4\x83\x72\x81\x5B\x83\x80\x82\x61",   EFF_SPT_BASE_CHR, "e616_tama1",       "e616_beam_b"     },
    {"\x97\xF1\x8E\xD4\x89\x8C",                                                           EFF_SPT_BASE_IMG, "kemuri_train",     "kemuri_train"    },
    {"\x82\x63\x82\x64\x96\xEE\x82\x52",                                                   EFF_SPT_BASE_CHR, "b11a_arrow",       "b11a_arrow3"     },
    {"\x82\x6C\x8A\xB4\x93\x64",                                                           EFF_SPT_BASE_CHR, "m_kanden",         "m_kanden"        },
    {"\x83\x7C\x83\x8B\x82\x69\x82\x64\x82\x73",                                           EFF_SPT_BASE_CHR, "e808_mp_jet",      "e808_mp_jet"     },
    {"\x96\x82\x90\x6C\x83\x72\x81\x5B\x83\x80",                                           EFF_SPT_BASE_IMG, "nana_rinpun",      "majin_beam"      },
    {"\x96\x82\x90\x6C\x83\x72\x81\x5B\x83\x80\x82\x67",                                   EFF_SPT_BASE_CHR, "b02a_hibasira_s",  "mj_beam_h"       },
    {"\x93\xC5\x96\xB6\x82\x6B",                                                           EFF_SPT_BASE_CHR, "m_dokugiri_l",     "m_dokugiri_l"    },
    {"\x93\xC5\x96\xB6\x82\x67",                                                           EFF_SPT_BASE_CHR, "m_dokugiri_h",     "m_dokugiri_h"    },
    {"\x8C\x52\x8A\xCD\x83\x5F\x83\x81\x81\x5B\x83\x57",                                   EFF_SPT_BASE_CHR, "e206_bbaku",       "ggun_damage"     },
    {"\x83\x68\x83\x89\x83\x53\x83\x93\x89\xCE\x92\x65\x82\x65",                           EFF_SPT_BASE_CHR, "e219ex_fire_f",    "e219ex_fire_f"   },
    {"\x83\x68\x83\x89\x83\x53\x83\x93\x89\xCE\x92\x65\x82\x6B",                           EFF_SPT_BASE_CHR, "e219ex_fire_l",    "e219ex_fire_l"   },
    {"\x8B\x40\x8A\xD6\x8F\x65\x81\x69\x8F\xAC\x81\x6A",                                   EFF_SPT_BASE_CHR, "e516_gun_s",       "e516_gun_s"      },
    {"\x8B\x40\x8F\x65\x92\x85\x92\x65",                                                   EFF_SPT_BASE_CHR, "e516_gun_tyaku",   "e516_gun_tyaku"  },
    {"\x96\x82\x90\x6C\x83\x72\x81\x5B\x83\x80\x82\x65\x82\x51",                           EFF_SPT_BASE_CHR, "b13a_beam_f",      "mj_beam_f2"      },
    {"\x96\x82\x90\x6C\x83\x72\x81\x5B\x83\x80\x82\x6B\x82\x51",                           EFF_SPT_BASE_CHR, "b13a_beam_l",      "mj_beam_l2"      },
    {"\x96\x82\x90\x6C\x83\x72\x81\x5B\x83\x80\x82\x67\x82\x51",                           EFF_SPT_BASE_CHR, "b13a_beam_h",      "mj_beam_h2"      },
    {"\x82\xCB\x82\xCE\x83\x73\x81\x5B\x83\x60\x82\x6B",                                   EFF_SPT_BASE_CHR, "e10b_neva_momo",   "e10b_neva_momo"  },
    {"\x83\x58\x83\x67\x81\x5B\x83\x93\x83\x78\x83\x8A\x81\x5B",                           EFF_SPT_BASE_CHR, "e10c_stone_bery",  "e10c_stone_bery" },
    {"\x83\x74\x83\x40\x83\x43\x83\x69\x83\x8B\x83\x7B\x83\x80",                           EFF_SPT_BASE_CHR, "e10e_bomb_f",      "e10e_bomb_f"     },
    {"\x83\x74\x83\x40\x83\x43\x83\x69\x83\x8B\x83\x7B\x83\x80\x82\x67",                   EFF_SPT_BASE_CHR, "m_explosion",      "e10e_bomb_f_h"   },
    {"\x83\x68\x83\x89\x83\x53\x83\x93\x89\xCE\x92\x65\x82\x67",                           EFF_SPT_BASE_CHR, "m_hibasira",       "m_dra_hibasira"  },
    {"\x82\x6C\x94\x9A\x94\xAD\x91\xE5",                                                   EFF_SPT_BASE_CHR, "m_exp2",           "m_mexp_b"        },
    {"\x82\x78\x83\x72\x81\x5B\x83\x80\x82\x67",                                           EFF_SPT_BASE_CHR, "beam_hit",         "y_beam_h"        },
    {"\x82\x78\x83\x4F\x83\x8C\x82\x67",                                                   EFF_SPT_BASE_CHR, "grenade_hit",      "y_grenade_h"     },
    {"\x82\x64\x82\x52\x82\x54\x82\x55\x89\xCE\x82\xCC\x95\xB2",                           EFF_SPT_BASE_IMG, "hinoko",           "e356_hinoko"     },
    {"\x82\x64\x82\x56\x82\x52\x82\x51\x8C\xF5\x89\x4A",                                   EFF_SPT_BASE_IMG, "e732_snow",        "e732_snow"       },
    {"\x95\x40\x92\x65\x82\x67",                                                           EFF_SPT_BASE_CHR, "e220a_neba_h",     "mem_bullet_h"    },
    {"\x95\x40\x92\x65\x82\x6B",                                                           EFF_SPT_BASE_CHR, "e220a_neba_l",     "mem_bullet_l"    },
    {"\x82\x72\x82\x76\x90\xD4\x82\x65",                                                   EFF_SPT_BASE_CHR, "e117e_swave_f",    "e117e_swave_f"   },
    {"\x82\x72\x82\x76\x90\xD4\x82\x6B",                                                   EFF_SPT_BASE_CHR, "e117e_swave_l",    "e117e_swave_l"   },
    {"\x82\x65\x83\x7B\x83\x80\x82\x67",                                                   EFF_SPT_BASE_CHR, "finalbomb_h",      "finalbomb_h"     },
    {"\x93\x64\x8C\xF5\x90\xCE\x89\xCE",                                                   EFF_SPT_BASE_CHR, "denkousekka_h",    "denkousekka_h"   },
    {"e104\x83\x4C\x83\x89\x83\x4C\x83\x89",                                               EFF_SPT_BASE_CHR, "e104_kira",        "e104_magic_kira" },
    {"e612\x8D\xBB\x89\x8C",                                                               EFF_SPT_BASE_IMG, "e612_tutimemuri",  "e612_pother"     },
    {"\x82\x6C\x89\x8C",                                                                   EFF_SPT_BASE_CHR, "m_smoke",          "m_smoke"         },
    {"\x82\x63\x82\x64\x96\xEE\x82\x67",                                                   EFF_SPT_BASE_CHR, "b11a_arrow_h",     "b11a_arrow_h"    },
    {"\x83\x4D\x83\x8B\x96\x82\x96\x40\x82\x51",                                           EFF_SPT_BASE_CHR, "g_magic",          "g_magic2"        },
    {"\x83\x4D\x83\x8B\x96\x82\x96\x40\x83\x54\x83\x75\x82\x51",                           EFF_SPT_BASE_CHR, "g_magic_obj",      "g_magic_sub2"    },
    {"\x92\xB1\x82\xCB\x82\xCE\x82\x6B",                                                   EFF_SPT_BASE_CHR, "m_nebaneba_l",     "m_bt_neba_l"     },
    {"\x82\x6C\x82\x6F\x94\x9A\x92\x65\x94\x9A\x94\xAD",                                   EFF_SPT_BASE_CHR, "m_exp2",           "mpol_bomb"       },
    {"\x83\x4D\x83\x8B\x82\x51\x96\x82\x96\x40\x82\x6B",                                   EFF_SPT_BASE_IMG, "c02flame",         "g2_magic_l"      },
    {"\x83\x4D\x83\x8B\x82\x51\x96\x82\x96\x40\x82\x67",                                   EFF_SPT_BASE_IMG, "c02flame",         "g2_magic_h"      },
    {"\x93\x79\x89\x8C",                                                                   EFF_SPT_BASE_CHR, "tutikemuri",       "tutikemuri"      },
    {"\x8D\xBB\x89\x8C\x91\xE5",                                                           EFF_SPT_BASE_CHR, "bostorol_smoke",   "bostorol_smoke"  },
    {"\x90\x85\x82\xB5\x82\xD4\x82\xAB",                                                   EFF_SPT_BASE_CHR, "mizusibuki",       "mizusibuki"      },
    {"",                                                                                   EFF_SPT_BASE_END, "",                 ""                },
};

/**
 * Effect script whose external commands are being executed.
 */
static _EFF_SCRIPT *now_script;

/**
 * Dispatch slots for effect script external commands.
 */
static dc2::script::RunFunction ext_func[256];

EFF_SPT_BASE_DEF *GetEffSptBaseDefPtr(int index);
int               SetEffectScript(CRunScript *script, std::span<u8> program, mgCMemory *memory);
void              SetEffectScriptFunc();
static void       DrawEffSptSprite(_EFF_SCRIPT *script, mgCTexture *texture, float *offset, mgC3DSprite *renderer, CMapLightingInfo *lighting);

/**
 *
 * Rounds a byte count up to a number of 16-byte blocks.
 *
 */
static inline u_int align16_blocks(u_int size) {
    if (size & 0xF) {
        return (size >> 4) + 1;
    }

    return size >> 4;
}

void CEffectScriptMan::SetWorkBuffer(mgCMemory *memory) {
    if (memory != nullptr) {
        work_memory = memory;
    }
}

int CEffectScriptMan::SearchBaseNo(char *name) {
    int index = 0;

    while (true) {
        EFF_SPT_BASE_DEF *base = GetEffSptBaseDefPtr(index);

        if (base == nullptr) {
            return -1;
        }

        if (strcmp(base->name, name) == 0) {
            return index;
        }

        index++;
    }
}

int CEffectScriptMan::LoadBaseEffSpt(char *name, mgCMemory *memory, int level) {
    return LoadBaseEffSpt(SearchBaseNo(name), memory, level);
}

void CEffectScriptMan::ClearBaseFromLevel(int level, std::span<int> cleared) {
    std::size_t count = 0;
    ClearEffectFromLevel(level);

    for (int i = 0; i < EFF_SPT_BASE_MAX; i++) {
        if (base[i] != nullptr && base[i]->level == level) {
            if (base[i]->texb_owned != 0 && count < cleared.size()) {
                cleared[count++] = base[i]->texb;
            }

            if (base[i]->texb_owned != 0) {
                texb_used--;
            }

            base[i] = nullptr;
        }
    }

    if (level > 0 && level < 4) {
        texb_used -= level_texb_used[level];
        level_texb_used[level] = 0;
    }

    if (texb_used < 0) {
        texb_used = 0;
    }

    if (!cleared.empty()) {
        if (count == cleared.size()) {
            dc2::log::PrintGame("--- effect script err (ClearBaseFromLevel TexbTable Over)!!! ---\n");
            --count;
        }
        cleared[count] = -1;
    }
}

CCharacter2 *CEffectScriptMan::GetBaseChara(int base_no) {
    for (int i = 0; i < EFF_SPT_BASE_MAX; i++) {
        if (base[i] != nullptr) {
            EFF_SPT_BASE_DEF *current = GetEffSptBaseDefPtr(base[i]->base_no);

            if (current == nullptr) {
                return nullptr;
            }

            EFF_SPT_BASE_DEF *wanted = GetEffSptBaseDefPtr(base_no);

            if (wanted == nullptr) {
                return nullptr;
            }

            if (current->type == 0 && strcmp(current->file, wanted->file) == 0) {
                return base[i]->chara;
            }
        }
    }

    return nullptr;
}

CCharacter2 *CEffectScriptMan::GetBaseChara(char *name) {
    return GetBaseChara(SearchBaseNo(name));
}

int CEffectScriptMan::GetNotUsedTexb() {
    int used = texb_used;

    if (used >= texb_num) {
        return -1;
    }

    return texb_start + used;
}

void CEffectScriptMan::AddTexb() {
    int count = texb_used;

    if (count < texb_num) {
        texb_used = count + 1;
        level_texb_used[level] = level_texb_used[level] + 1;
    }
}

int CEffectScriptMan::BuildBase(char *name, u_long128 *path_file, int path_size, u_long128 *pack_file,
                                int pack_size, mgCMemory *memory, int level) {
    return BuildBase(SearchBaseNo(name), path_file, path_size, pack_file, pack_size, memory, level);
}

int CEffectScriptMan::BuildPack(char *name, u_int *pack, mgCMemory *memory, int level) {
    return BuildPack(SearchBaseNo(name), pack, memory, level);
}

int CEffectScriptMan::GetNeedFilePath(char *name, std::span<char> path, std::span<char> pack) {
    return GetNeedFilePath(SearchBaseNo(name), path, pack);
}

int CEffectScriptMan::CreateEffSpt(char *name, int user_id, int use_slot) {
    _EFF_SCRIPT *effect = CreateEffSpt(SearchBaseNo(name), user_id, use_slot);

    if (effect != nullptr) {
        return effect->slot;
    }

    return -1;
}

void CEffectScriptMan::ClearEffectFromChrid(int chrid) {
    _EFF_SCRIPT *script = head;

    if (script != nullptr) {
        do {
            if (script->user_id == chrid) {
                _EFF_SCRIPT *doomed = script;
                script = script->next;
                DeleteEffSpt(doomed);
            } else {
                script = script->next;
            }
        } while (script != nullptr);
    }
}

void CEffectScriptMan::ClearEffectFromLevel(int level) {
    _EFF_SCRIPT *script = head;

    if (script != nullptr) {
        do {
            if (script->level == level) {
                _EFF_SCRIPT *doomed = script;
                script = script->next;
                DeleteEffSpt(doomed);
            } else {
                script = script->next;
            }
        } while (script != nullptr);
    }
}

int CEffectScriptMan::DeleteEffSpt(int group, int slot) {
    if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot < 0 || slot >= EFF_SPT_OWNER_SLOT_MAX) {
        return 0;
    }

    DeleteEffSpt(this->slot[group][slot]);
    return 1;
}

void CEffectScriptMan::AllClearEffSpt() {
    _EFF_SCRIPT *script = tail;

    if (script != nullptr) {
        while (script->prev != nullptr) {
            _EFF_SCRIPT *prev = script->prev;
            script = prev;
            DeleteEffSpt(prev->next);
        }

        DeleteEffSpt(script);
        tail = nullptr;
        head = nullptr;

        for (int group = 0; group < EFF_SPT_OWNER_MAX; group++) {
            for (int slot = 0; slot < EFF_SPT_OWNER_SLOT_MAX; slot++) {
                this->slot[group][slot] = nullptr;
            }
        }

        now = nullptr;
    }
}

void CEffectScriptMan::Step() {
    _EFF_SCRIPT *script = head;
    EffScriptMan = this;

    if (script != nullptr) {
        do {
            now_script = script;

            if (script->state == EFF_SPT_STATE_HIDE_STOP || script->state == EFF_SPT_STATE_STOP) {
                script = script->next;
                continue;
            }

            if (script->state != EFF_SPT_STATE_SCRIPT_PAUSE) {
                if (script->prog_no != -1) {
                    if (script->run.check_program(script->prog_no)) {
                        if (script->run.run(script->prog_no) == 0) {
                            if (script->next == nullptr) {
                                DeleteEffSpt(script);
                                script = nullptr;
                            } else {
                                script = script->next;
                                DeleteEffSpt(script->prev);
                            }

                            continue;
                        }

                        script->prog_no = -1;
                    }
                } else {
                    script->run.resume();
                }
            }

            if (script->chara != nullptr) {
                script->chara->Step();

                for (int character_index = 0; character_index < EFF_SPT_SUB_CHARA_MAX; character_index++) {
                    if (script->sub_chara[character_index] != nullptr) {
                        script->sub_chara[character_index]->Step();
                    }
                }
            }

            if (script->sprite != nullptr) {
                for (int sprite_index = 0; sprite_index < script->sprite_num; sprite_index++) {
                    _ES_SPRITE *sprite = &script->sprite[sprite_index];
                    sceVu0AddVector(sprite->pos, sprite->pos, sprite->velo_pos);
                    sceVu0AddVector(sprite->velo_pos, sprite->velo_pos, sprite->acc_pos);
                    sprite->rotz += sprite->velo_rotz;
                    sprite->rotz = mgAngleLimit(sprite->rotz);
                    sprite->velo_rotz += sprite->acc_rotz;

                    if (!(sprite->velo_rotz <= TWO_PI)) {
                        sprite->velo_rotz = TWO_PI;
                    }

                    sceVu0AddVector(sprite->color, sprite->color, sprite->velo_col);
                    sceVu0AddVector(sprite->velo_col, sprite->velo_col, sprite->acc_col);

                    if (sprite->color_conv_div > 0.0) {
                        sprite->color[0] += (sprite->color_target[0] - sprite->color[0]) / sprite->color_conv_div;
                        sprite->color[1] += (sprite->color_target[1] - sprite->color[1]) / sprite->color_conv_div;
                        sprite->color[2] += (sprite->color_target[2] - sprite->color[2]) / sprite->color_conv_div;
                        sprite->color[3] += (sprite->color_target[3] - sprite->color[3]) / sprite->color_conv_div;
                    }

                    sprite->scale[0] += sprite->velo_scl[0];
                    sprite->scale[1] += sprite->velo_scl[1];
                    sprite->velo_scl[0] += sprite->acc_scl[0];
                    sprite->velo_scl[1] += sprite->acc_scl[1];

                    if (sprite->scale_conv_div > 0.0) {
                        sprite->scale[0] += (sprite->scale_target[0] - sprite->scale[0]) / sprite->scale_conv_div;
                        sprite->scale[1] += (sprite->scale_target[1] - sprite->scale[1]) / sprite->scale_conv_div;
                    }
                }
            }

            if (script->run.end) {
                if (script->next == nullptr) {
                    DeleteEffSpt(script);
                    script = nullptr;
                } else {
                    script = script->next;
                    DeleteEffSpt(script->prev);
                }
            } else {
                script = script->next;
            }
        } while (script != nullptr);
    }

    now_script = nullptr;
    now = nullptr;
}

_ES_SPRITE *CEffectScriptMan::AssignSprite(int count) {
    if (work_memory == nullptr || count <= 0) {
        return nullptr;
    }
    const auto quadwords = dc2::memory::ArrayQuadwords<_ES_SPRITE>(static_cast<std::size_t>(count));
    if (!quadwords || *quadwords > std::numeric_limits<int>::max() - 3) {
        return nullptr;
    }
    const int  blocks = *quadwords + 3;
    u_long128 *token = work_memory->StartStackMode(MG_STACK_MODE_FIT, blocks);
    if (token == nullptr) {
        dc2::log::PrintGame("------- es work max!! (assign sprite[%d]) ---------\n", blocks);
        return nullptr;
    }
    _ES_SPRITE *sprite = dc2::memory::NewArray<_ES_SPRITE>(*work_memory, static_cast<std::size_t>(count));
    if (sprite == nullptr) {
        work_memory->EndStackMode();
        work_memory->Free(token);
        return nullptr;
    }
    static_assert(std::is_trivially_copyable_v<_ES_SPRITE>);
    std::fill_n(reinterpret_cast<std::byte *>(sprite), static_cast<std::size_t>(count) * sizeof(_ES_SPRITE),
                std::byte{0});
    work_memory->stAlign64();
    work_memory->EndStackMode();
    return sprite;
}

void CEffectScriptMan::DeleteSprite(_ES_SPRITE *sprite) {
    mgCMemory *memory = work_memory;

    if (memory == nullptr || sprite == nullptr) {
        return;
    }

    memory->Free((u_long128 *) sprite);
}

int CEffectScriptMan::SetScriptProgNo(int prog_no, int group, int slot) {
    if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot < 0 || slot >= EFF_SPT_OWNER_SLOT_MAX) {
        return 0;
    }

    _EFF_SCRIPT *script = this->slot[group][slot];

    if (script == nullptr) {
        return 0;
    }

    script->prog_no = prog_no;
    return 1;
}

int CEffectScriptMan::Pause(int state, int group, int slot) {
    if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot < 0 || slot >= EFF_SPT_OWNER_SLOT_MAX) {
        return 0;
    }

    _EFF_SCRIPT *script = this->slot[group][slot];

    if (script == nullptr) {
        return 0;
    }

    script->state = state;
    return 1;
}

void CEffectScriptMan::PauseFromLevel(int level, int state) {
    _EFF_SCRIPT *script = head;

    if (script != nullptr) {
        do {
            if (script->level == level) {
                script->state = state;
            }

            script = script->next;
        } while (script != nullptr);
    }
}

int CEffectScriptMan::SetScriptVect1(float *vect, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == nullptr) {
            return 0;
        }

        CopyEffectVector(script->work_vect1, vect);
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        CopyEffectVector(first->work_vect1, vect);
        return 1;
    }

    return 0;
}

int CEffectScriptMan::GetScriptVect1(float *vect, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == nullptr) {
            return 0;
        }

        CopyEffectVector(vect, script->work_vect1);
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        CopyEffectVector(vect, first->work_vect1);
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetScriptVect2(float *vect, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == nullptr) {
            return 0;
        }

        CopyEffectVector(script->work_vect2, vect);
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        CopyEffectVector(first->work_vect2, vect);
        return 1;
    }

    return 0;
}

int CEffectScriptMan::GetScriptVect2(float *vect, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == nullptr) {
            return 0;
        }

        CopyEffectVector(vect, script->work_vect2);
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        CopyEffectVector(vect, first->work_vect2);
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetScriptTargetId(int target_id, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == nullptr) {
            return 0;
        }

        script->target_id = target_id;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        first->target_id = target_id;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::GetScriptTargetId(int &target_id, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == nullptr) {
            return 0;
        }

        target_id = script->target_id;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        target_id = first->target_id;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetScriptUserId(int user_id, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == nullptr) {
            return 0;
        }

        script->user_id = user_id;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        first->user_id = user_id;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::GetScriptUserId(int &user_id, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == nullptr) {
            return 0;
        }

        user_id = script->user_id;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        user_id = first->user_id;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetColPrim(CColPrim *colprim, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == nullptr) {
            return 0;
        }

        script->colprim = colprim;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        first->colprim = colprim;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetValue(int index, int value, int group, int slot) {
    if (index < 0 || index >= EFF_SPT_VALUE_MAX) {
        return 0;
    }

    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == nullptr) {
            return 0;
        }

        script->value[index].i = value;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        first->value[index].i = value;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetValue(int index, float value, int group, int slot) {
    if (index < 0 || index >= EFF_SPT_VALUE_MAX) {
        return 0;
    }

    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == nullptr) {
            return 0;
        }

        script->value[index].f = value;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        first->value[index].f = value;
        return 1;
    }

    return 0;
}

int CEffectScriptMan::SetOrigin(float *vect, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == nullptr) {
            return 0;
        }

        CopyEffectVector(script->origin, vect);
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        CopyEffectVector(first->origin, vect);
        return 1;
    }

    return 0;
}

CCharacter2 *CEffectScriptMan::GetCharacter(int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return nullptr;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script != nullptr) {
            return script->chara;
        }

        return nullptr;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        return first->chara;
    }

    return nullptr;
}

int CEffectScriptMan::SetCharacter(CCharacter2 *source, int group, int slot) {
    if (source == nullptr || work_memory == nullptr || work_memory->lock != 0) {
        return 0;
    }
    _EFF_SCRIPT *target = now;
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }
        target = this->slot[group][slot];
    }
    if (target == nullptr) {
        return 0;
    }
    const long long required = static_cast<long long>(std::max(0, source->GetCopySize())) +
                               align16_blocks(sizeof(CCharacter2)) + 6;
    if (required > std::numeric_limits<int>::max()) {
        return 0;
    }
    auto *token = work_memory->StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(required));
    if (token == nullptr) {
        return 0;
    }
    auto *storage = work_memory->Alloc(align16_blocks(sizeof(CCharacter2)) + 2);
    if (storage == nullptr) {
        work_memory->EndStackMode();
        work_memory->Free(token);
        return 0;
    }
    static_assert(std::is_trivially_destructible_v<CCharacter2>);
    auto *character = new (storage) CCharacter2;
    if (!source->Copy(*character, work_memory)) {
        work_memory->EndStackMode();
        work_memory->Free(token);
        return 0;
    }
    target->chara = character;
    target->chara_work = token;
    work_memory->stAlign64();
    work_memory->EndStackMode();
    return 1;
}

int CEffectScriptMan::SetTexb(int texb, int group, int slot) {
    if (slot >= 0) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX || slot >= EFF_SPT_OWNER_SLOT_MAX) {
            return 0;
        }

        _EFF_SCRIPT *script = this->slot[group][slot];

        if (script == nullptr) {
            return 0;
        }

        script->texb = texb;
        return 1;
    }

    _EFF_SCRIPT *first = now;

    if (first != nullptr) {
        first->texb = texb;
        return 1;
    }

    return 0;
}

/**
 *
 * Returns a nonempty effect script base definition by index.
 *
 */
EFF_SPT_BASE_DEF *GetEffSptBaseDefPtr(int index) {
    if (index < 0) {
        return nullptr;
    }

    EFF_SPT_BASE_DEF *base = eff_spt_base_def + index;
    return strcmp(base->name, "") == 0 ? nullptr : base;
}

/**
 *
 * Draws visible effect sprites with their color, lighting, and alpha settings.
 *
 */
static void DrawEffSptSprite(_EFF_SCRIPT *script, mgCTexture *texture, sceVu0FVECTOR offset, mgC3DSprite *renderer, CMapLightingInfo *lighting) {
    _ES_SPRITE *sprites = script->sprite;
    int         count = script->sprite_num;
    int         alpha = sprites->alpha;
    mgCDrawEnv  environment(*mgGetpDrawEnv(0));
    sceGsTest  *test = &environment.test;
    int         component = {};
    test->bits.zte = 1;
    test->bits.ztst = 2;
    environment.SetZBuf(MG_ZBUF_NO_WRITE);
    environment.SetAlpha(alpha);
    renderer->CPSetDrawEnv(&environment);
    renderer->CPSetTexture(texture);
    renderer->BeginCPSprite();

    for (int i = 0; i < count; i++) {
        if (sprites[i].draw_flag != 0) {
            _ES_SPRITE *sprite = &sprites[i];

            if (alpha != sprite->alpha) {
                alpha = sprite->alpha;
                renderer->EndCPSprite();
                mgCDrawEnv next_environment(*mgGetpDrawEnv(0));
                sceGsTest *next_test = &next_environment.test;
                next_test->bits.zte = 1;
                next_test->bits.ztst = 2;
                next_environment.SetZBuf(MG_ZBUF_NO_WRITE);
                next_environment.SetAlpha(alpha);
                renderer->CPSetDrawEnv(&next_environment);
                renderer->CPSetTexture(texture);
                renderer->BeginCPSprite();
            }

            sceVu0FVECTOR size = {0.0f, 0.0f, 0.0f, 0.0f};
            sceVu0FVECTOR uv0, uv1, position;
            sceVu0FVECTOR color;
            mgZeroVector(uv0);
            mgZeroVector(uv1);
            sceVu0AddVector(position, sprite->pos, offset);
            position[3] = 1.0f;
            CopyEffectVector(color, sprite->color);

            if (0.0f != sprite->blink_speed) {
                for (component = 0; component < 4; component++) {
                    color[component] += sinf(sprite->blink_phase) * sprite->blink_amp[component];

                    if (color[component] < 0.0f) {
                        color[component] = 0.0f;
                    }

                    if (color[component] > 255.0f) {
                        color[component] = 255.0f;
                    }
                }

                sprite->blink_phase += sprite->blink_speed;
                sprite->blink_phase = mgAngleLimit(sprite->blink_phase);
            } else {
                for (int component = 0; component < 4; component++) {
                    if (color[component] < 0.0f) {
                        color[component] = 0.0f;
                    }

                    if (color[component] > 255.0f) {
                        color[component] = 255.0f;
                    }
                }
            }

            if (script->light_flag) {
                sceVu0FMATRIX light_direction, light_color;
                sceVu0FVECTOR ambient;
                mgGetLight(light_direction, light_color);
                mgGetAmbient(ambient);
                color[0] = 0.3 * light_color[0][0] + ambient[0];
                color[1] = light_color[0][1] * 0.3 + ambient[1];
                color[2] = light_color[0][2] * 0.3 + ambient[2];
            }

            size[0] = sprite->put_size[0] * sprite->scale[0];
            size[1] = sprite->put_size[1] * sprite->scale[1];
            size[2] = mgAngleLimit(sprite->rotz);
            uv0[0] = sprite->uv[0];
            uv0[1] = sprite->uv[1];
            uv1[0] = sprite->uv[0] + sprite->uv[2];
            uv1[1] = sprite->uv[1] + sprite->uv[3];
            renderer->CPSetSprite(position, size, color, uv0, uv1);
        }
    }

    renderer->EndCPSprite();
}

/**
 *
 * Returns an effect sprite at a valid slot index.
 *
 */
static _ES_SPRITE *GetSpritePtr(_EFF_SCRIPT *script, int index) {
    if (script == nullptr || index < 0 || index >= script->sprite_num || script->sprite == nullptr) {
        return nullptr;
    }

    return &script->sprite[index];
}

/**
 *
 * Checks a complete sprite range without overflowing its signed endpoint.
 *
 */
static bool ValidSpriteRange(const _EFF_SCRIPT *script, int first, int count) {
    return script != nullptr && first >= 0 && count >= 0 && first <= script->sprite_num &&
           count <= script->sprite_num - first && (count == 0 || script->sprite != nullptr);
}

/**
 *
 * Reads an effect script argument as an integer.
 *
 */
static int GetStackInt(dc2::script::RunArguments slot) {
    return dc2::script::RunInteger(slot);
}

/**
 *
 * Reads an effect script argument as a float.
 *
 */
static float GetStackFloat(dc2::script::RunArguments slot) {
    return dc2::script::RunFloat(slot);
}

/**
 *
 * Reads three effect script values into a homogeneous vector.
 *
 */
static void GetStackVector(float *vector, dc2::script::RunArguments slot) {
    vector[0] = GetStackFloat(slot++);
    vector[1] = GetStackFloat(slot++);
    vector[2] = GetStackFloat(slot);
    vector[3] = 1.0f;
}

static void GetRunVector(float *vector, dc2::script::RunArguments args) {
    vector[0] = dc2::script::RunFloat(args++);
    vector[1] = dc2::script::RunFloat(args++);
    vector[2] = dc2::script::RunFloat(args);
    vector[3] = 1.0f;
}

static CCharacter2 *GetSubCharacter(dc2::script::RunArguments &args) {
    const int index = dc2::script::RunInteger(args++);
    if (now_script == nullptr || index < 0 || index >= static_cast<int>(std::size(now_script->sub_chara))) {
        return nullptr;
    }
    return now_script->sub_chara[index];
}

static std::array<RS_STACKDATA *, 3> GetRunVectorOutputs(dc2::script::RunArguments args) {
    return {&dc2::script::RunOutput(args++), &dc2::script::RunOutput(args++),
            &dc2::script::RunOutput(args)};
}

/**
 *
 * Writes an integer through an effect script reference slot.
 *
 */
static void SetStack(dc2::script::RunArguments slot, int value) {
    dc2::script::RunOutput(slot).val.i = value;
}

/**
 *
 * Writes a float through an effect script reference slot.
 *
 */
static void SetStack(dc2::script::RunArguments slot, float value) {
    dc2::script::RunOutput(slot).val.f = value;
}

/**
 *
 * Validates effect output references before any callback updates them.
 *
 */
static void ValidateEffectOutputs(dc2::script::RunArguments args) {
    for (std::size_t index = 0; index < args.Remaining(); ++index) {
        const auto slot = args + index;
        if (slot.At().type == RS_PTR) {
            dc2::script::RunOutput(slot);
        }
    }
}

/**
 *
 * Writes a zero vector to three effect script outputs.
 *
 */
static int _ZERO_VECTOR(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    if (argument_count != 3) {
        return 0;
    }

    SetStack(stack++, 0.0f);
    SetStack(stack++, 0.0f);
    SetStack(stack, 0.0f);
    return 1;
}

/**
 *
 * Normalizes a vector stored in three effect script outputs.
 *
 */
static int _NORMAL_VECTOR(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    float vector[4];

    if (argument_count != 3) {
        return 0;
    }

    vector[0] = dc2::script::RunOutput(stack).val.f;
    vector[1] = dc2::script::RunOutput(stack + 1).val.f;
    vector[2] = dc2::script::RunOutput(stack + 2).val.f;
    vector[3] = 1.0f;
    sceVu0Normalize(vector, vector);
    SetStack(stack++, vector[0]);
    SetStack(stack++, vector[1]);
    SetStack(stack, vector[2]);
    return 1;
}

/**
 *
 * Copies three script vector components to output slots.
 *
 */
static int _COPY_VECTOR(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    float vector[4];

    if (argument_count != 6) {
        return 0;
    }

    GetStackVector(vector, stack + 3);
    SetStack(stack++, vector[0]);
    SetStack(stack++, vector[1]);
    SetStack(stack, vector[2]);
    return 1;
}

/**
 *
 * Adds a script vector to three output components.
 *
 */
static int _ADD_VECTOR(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    float vector[4];

    if (argument_count != 6) {
        return 0;
    }

    GetStackVector(vector, stack + 3);
    SetStack(stack, dc2::script::RunOutput(stack).val.f + vector[0]);
    SetStack(stack + 1, dc2::script::RunOutput(stack + 1).val.f + vector[1]);
    SetStack(stack + 2, dc2::script::RunOutput(stack + 2).val.f + vector[2]);
    return 1;
}

/**
 *
 * Subtracts a script vector from three output components.
 *
 */
static int _SUB_VECTOR(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    float vector[4];

    if (argument_count != 6) {
        return 0;
    }

    GetStackVector(vector, stack + 3);
    SetStack(stack, dc2::script::RunOutput(stack).val.f - vector[0]);
    SetStack(stack + 1, dc2::script::RunOutput(stack + 1).val.f - vector[1]);
    SetStack(stack + 2, dc2::script::RunOutput(stack + 2).val.f - vector[2]);
    return 1;
}

/**
 *
 * Scales three output vector components by a script value.
 *
 */
static int _SCALE_VECTOR(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    float scale = {};

    if (argument_count != 4) {
        return 0;
    }

    scale = GetStackFloat(stack + 3);
    SetStack(stack, dc2::script::RunOutput(stack).val.f * scale);
    SetStack(stack + 1, dc2::script::RunOutput(stack + 1).val.f * scale);
    SetStack(stack + 2, dc2::script::RunOutput(stack + 2).val.f * scale);
    return 1;
}

/**
 *
 * Divides three output vector components by a nonzero script value.
 *
 */
static int _DIV_VECTOR(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    float divisor = {};

    if (argument_count != 4) {
        return 0;
    }

    divisor = GetStackFloat(stack + 3);

    if (divisor == 0.0f) {
        return 0;
    }

    SetStack(stack, dc2::script::RunOutput(stack).val.f / divisor);
    SetStack(stack + 1, dc2::script::RunOutput(stack + 1).val.f / divisor);
    SetStack(stack + 2, dc2::script::RunOutput(stack + 2).val.f / divisor);
    return 1;
}

/**
 *
 * Returns the length of a script vector.
 *
 */
static int _DIST_VECTOR(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    float vector[4];

    if (argument_count != 4) {
        return 0;
    }

    GetStackVector(vector, stack);
    stack = stack + 3;
    SetStack(stack++, mgDistVector(vector));
    return 1;
}

/**
 *
 * Returns the distance between two script vectors.
 *
 */
static int _DIST_VECTOR2(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    float from[4];
    float to[4];

    if (argument_count != 7) {
        return 0;
    }

    GetStackVector(from, stack);
    GetStackVector(to, stack + 3);
    stack = stack + 6;
    SetStack(stack++, mgDistVector(from, to));
    return 1;
}

/**
 *
 * Returns the square root of a script value.
 *
 */
static int _SQRT(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    if (argument_count != 2) {
        return 0;
    }

    float value = GetStackFloat(stack++);
    SetStack(stack, (float) sqrt(value));
    return 1;
}

/**
 *
 * Returns the angle of two script values using atan2.
 *
 */
static int _ATAN2F(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    float y = {};
    float x = {};

    if (argument_count != 3) {
        return 0;
    }

    y = GetStackFloat(stack++);
    x = GetStackFloat(stack++);
    SetStack(stack, atan2f(y, x));
    return 1;
}

/**
 *
 * Compares two script angles with a supplied tolerance.
 *
 */
static int _ANGLE_CMP(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    float first_angle = {};
    float second_angle = {};
    float c = {};

    if (argument_count != 4) {
        return 0;
    }

    first_angle = GetStackFloat(stack++);
    second_angle = GetStackFloat(stack++);
    c = GetStackFloat(stack++);
    SetStack(stack, mgAngleCmp(first_angle, second_angle, c));
    return 1;
}

/**
 *
 * Wraps a script angle into the engine angle range.
 *
 */
static int _ANGLE_LIMIT(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    if (argument_count != 1) {
        return 0;
    }

    SetStack(stack, mgAngleLimit(dc2::script::RunOutput(stack).val.f));
    return 1;
}

/**
 *
 * Returns a random integer or float within a script range.
 *
 */
static int _GET_RAND(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    if (argument_count != 2) {
        return 0;
    }

    if (stack.At().type == 1) {
        float range = GetStackFloat(stack++);
        SetStack(stack, range * (float) rand() / 2147483648.0f);
        return 1;
    }

    int range = GetStackInt(stack++);
    int value = fptosi((float) range * (float) rand() / 2147483648.0f);
    SetStack(stack, value);
    return 1;
}

/**
 *
 * Returns the yaw or full rotation from one script position to another.
 *
 */
static int _GET_REF_ROT(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    if (argument_count != 7 && argument_count != 9) {
        return 0;
    }

    float from[4];
    float dir[4];
    GetStackVector(from, stack);
    GetStackVector(dir, stack + 3);
    stack = stack + 6;
    sceVu0SubVector(dir, dir, from);
    sceVu0Normalize(dir, dir);
    float *z = &dir[2];
    float  yaw = atan2f(dir[0], *z);
    float  pitch = -atan2f(dir[1], sqrtf(dir[0] * dir[0] + *z * *z));

    switch (argument_count) {
        case 7:
            SetStack(stack, yaw);
            break;
        case 9:
            SetStack(stack++, pitch);
            SetStack(stack++, yaw);
            SetStack(stack, 0.0f);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Returns a direction vector from scripted rotation angles.
 *
 */
int _GET_DIR_VECTOR(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    if (argument_count != 6) {
        return 0;
    }

    float matrix[4][4];
    float rot[4];
    float dir[4] = {0.0f, 0.0f, 1.0f, 1.0f};
    GetStackVector(rot, stack);
    stack = stack + 3;
    rot[0] = mgAngleLimit(rot[0]);
    float *y = &rot[1];
    *y = mgAngleLimit(*y);
    float *z = &rot[2];
    *z = mgAngleLimit(*z);
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixX(matrix, matrix, rot[0]);
    sceVu0RotMatrixY(matrix, matrix, *y);
    sceVu0ApplyMatrix(dir, matrix, dir);
    SetStack(stack++, dir[0]);
    SetStack(stack++, dir[1]);
    SetStack(stack, dir[2]);
    return 1;
}

/**
 *
 * Sets the origin offset of the current effect script.
 *
 */
int _SET_ORIGIN(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    now_script->origin[0] = GetStackFloat(stack++);
    now_script->origin[1] = GetStackFloat(stack++);
    now_script->origin[2] = GetStackFloat(stack);
    now_script->origin[3] = 0.0f;
    return 1;
}

/**
 *
 * Returns the origin offset of the current effect script.
 *
 */
int _GET_ORIGIN(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 3) {
        return 0;
    }

    SetStack(stack++, now_script->origin[0]);
    SetStack(stack++, now_script->origin[1]);
    SetStack(stack, now_script->origin[2]);
    return 1;
}

/**
 *
 * Configures automatic effect offset from a named frame.
 *
 */
int _AUTO_SET_OFFSET(dc2::script::RunArguments args) {
    if (now_script == nullptr) {
        return 0;
    }
    const int        offset = dc2::script::RunInteger(args++);
    std::string_view name;
    if (args.Remaining() > 0) {
        name = dc2::script::RunText(args);
    }
    if (name.size() >= sizeof(now_script->offset_frame)) {
        return 0;
    }
    now_script->auto_offset = offset;
    dc2::text::Copy(now_script->offset_frame, name);

    return 1;
}

/**
 *
 * Returns the first work vector of the current effect script.
 *
 */
int _GET_WORK_VECT1(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 3) {
        return 0;
    }

    SetStack(stack++, now_script->work_vect1[0]);
    SetStack(stack++, now_script->work_vect1[1]);
    SetStack(stack, now_script->work_vect1[2]);
    return 1;
}

/**
 *
 * Returns the second work vector of the current effect script.
 *
 */
int _GET_WORK_VECT2(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 3) {
        return 0;
    }

    SetStack(stack++, now_script->work_vect2[0]);
    SetStack(stack++, now_script->work_vect2[1]);
    SetStack(stack, now_script->work_vect2[2]);
    return 1;
}

/**
 *
 * Returns the target character identifier of the current effect script.
 *
 */
int _GET_TARGET_ID(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 1) {
        return 0;
    }

    SetStack(stack, now_script->target_id);
    return 1;
}

/**
 *
 * Returns the user identifier of the current effect script.
 *
 */
int _GET_USER_ID(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 1) {
        return 0;
    }

    SetStack(stack, now_script->user_id);
    return 1;
}

/**
 *
 * Returns a typed value from the current effect script.
 *
 */
int _GET_VALUE(dc2::script::RunArguments args) {
    if (now_script == nullptr || args.Remaining() != 2) {
        return 0;
    }
    const int index = dc2::script::RunInteger(args++);
    if (index < 0 || index >= static_cast<int>(std::size(now_script->value))) {
        return 0;
    }
    RS_STACKDATA &result = dc2::script::RunOutput(args);
    switch (result.type) {
        case RS_INT:
            result.val.i = now_script->value[index].i;
            break;
        case RS_FLOAT:
            result.val.f = now_script->value[index].f;
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Stores a typed value in the current effect script.
 *
 */
int _SET_VALUE(dc2::script::RunArguments args) {
    if (now_script == nullptr || args.Remaining() != 2) {
        return 0;
    }
    const int index = dc2::script::RunInteger(args++);
    if (index < 0 || index >= static_cast<int>(std::size(now_script->value))) {
        return 0;
    }
    switch (args.At().type) {
        case RS_INT:
            now_script->value[index].i = dc2::script::RunInteger(args);
            break;
        case RS_FLOAT:
            now_script->value[index].f = dc2::script::RunFloat(args);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Changes primary effect character visibility with optional fading.
 *
 */
int _CHR_SET_SHOW(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (now_script->chara == nullptr) {
        return 0;
    }

    int  show = {};
    int  fade = 0;
    auto next = stack + 1;
    show = GetStackInt(stack);

    if (argument_count >= 2) {
        fade = GetStackInt(next++);

        if (argument_count == 3) {
            GetStackFloat(next);
        }
    }

    now_script->chara->Show(show);
    now_script->chara->fade = 1;
    now_script->chara->fade_speed = 0.1f;

    if (fade == 1 && show == 1) {
        now_script->chara->fade_alpha = 0.0001f;
    } else if (fade == 1 && show == 0) {
        now_script->chara->fade_alpha = 1.0f;
    }

    return 1;
}

/**
 *
 * Returns primary effect character visibility and fade state.
 *
 */
int _CHR_GET_SHOW(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 1 && argument_count != 2) {
        return 0;
    }

    if (now_script->chara == nullptr) {
        return 0;
    }

    SetStack(stack++, now_script->chara->GetShow());

    if (argument_count == 2) {
        SetStack(stack, now_script->chara->fade);
    }

    return 1;
}

/**
 *
 * Sets the primary effect character position.
 *
 */
int _CHR_SET_POS(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (now_script->chara == nullptr) {
        return 0;
    }

    float vector[4];
    GetStackVector(vector, stack);
    now_script->chara->SetPosition(vector);
    return 1;
}

/**
 *
 * Returns the primary effect character position.
 *
 */
int _CHR_GET_POS(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 3) {
        return 0;
    }

    if (now_script->chara == nullptr) {
        return 0;
    }

    float pos[4];
    now_script->chara->GetPosition(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Turns the primary effect character toward a rotation over optional steps.
 *
 */
int _CHR_SET_ROT(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (now_script->chara == nullptr) {
        return 0;
    }

    float rot[4];
    float current[4];
    int   steps = 1;
    GetStackVector(rot, stack);
    stack = stack + 3;

    if (argument_count >= 4) {
        steps = GetStackInt(stack++);
    }

    now_script->chara->GetRotation(current);
    sceVu0SubVector(rot, rot, current);
    rot[0] = mgAngleLimit(rot[0]);
    float *y = &rot[1];
    *y = mgAngleLimit(*y);
    float *z = &rot[2];
    *z = mgAngleLimit(*z);
    sceVu0DivVector(rot, rot, (float) steps);
    sceVu0AddVector(rot, rot, current);
    rot[0] = mgAngleLimit(rot[0]);
    *y = mgAngleLimit(*y);
    *z = mgAngleLimit(*z);
    rot[3] = 1.0f;
    now_script->chara->SetRotation(rot);
    return 1;
}

/**
 *
 * Returns the primary effect character rotation.
 *
 */
int _CHR_GET_ROT(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 3) {
        return 0;
    }

    if (now_script->chara == nullptr) {
        return 0;
    }

    float rot[4];
    now_script->chara->GetRotation(rot);
    SetStack(stack++, rot[0]);
    SetStack(stack++, rot[1]);
    SetStack(stack, rot[2]);
    return 1;
}

/**
 *
 * Sets the primary effect character scale.
 *
 */
int _CHR_SET_SCALE(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (now_script->chara == nullptr) {
        return 0;
    }

    float vector[4];
    GetStackVector(vector, stack);
    now_script->chara->SetScale(vector);
    return 1;
}

/**
 *
 * Returns the primary effect character scale.
 *
 */
int _CHR_GET_SCALE(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 3) {
        return 0;
    }

    if (now_script->chara == nullptr) {
        return 0;
    }

    float scale[4];
    now_script->chara->GetScale(scale);
    SetStack(stack++, scale[0]);
    SetStack(stack++, scale[1]);
    SetStack(stack, scale[2]);
    return 1;
}

/**
 *
 * Starts a named motion on the primary effect character.
 *
 */
int _CHR_SET_MOTION(dc2::script::RunArguments args) {
    if (now_script == nullptr || now_script->chara == nullptr || args.Remaining() < 1 || args.Remaining() > 3) {
        return 0;
    }
    int   mode = 0;
    float step = -1.0f;
    char *name = dc2::script::RunCString(args++);
    if (args.Remaining() > 0) {
        step = dc2::script::RunFloat(args++);
    }
    if (args.Remaining() > 0) {
        mode = dc2::script::RunInteger(args);
    }

    now_script->chara->SetMotion(name, mode);

    if (step >= 0.0f) {
        now_script->chara->SetStep(step);
    }

    return 1;
}

/**
 *
 * Sets primary effect character motion playback speed.
 *
 */
int _CHR_SET_MOT_STEP(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (now_script->chara == nullptr) {
        return 0;
    }

    (now_script)->chara->SetStep(GetStackFloat(stack));
    return 1;
}

/**
 *
 * Returns the current motion frame wait of the primary effect character.
 *
 */
int _CHR_GET_MOT_WAIT(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 1) {
        return 0;
    }

    CCharacter2 *chara = now_script->chara;

    if (chara == nullptr) {
        return 0;
    }

    SetStack(stack, chara->GetNowFrameWait());
    return 1;
}

/**
 *
 * Returns the primary effect character facing direction.
 *
 */
int _CHR_GET_DIR_VECTOR(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 3) {
        return 0;
    }

    if (now_script->chara == nullptr) {
        return 0;
    }

    float matrix[4][4];
    float rot[4];
    float dir[4] = {0.0f, 0.0f, 1.0f, 1.0f};
    sceVu0UnitMatrix(matrix);
    now_script->chara->GetRotation(rot);
    sceVu0RotMatrixX(matrix, matrix, rot[0]);
    sceVu0RotMatrixY(matrix, matrix, rot[1]);
    sceVu0ApplyMatrix(dir, matrix, dir);
    SetStack(stack++, dir[0]);
    SetStack(stack++, dir[1]);
    SetStack(stack, dir[2]);
    return 1;
}

/**
 *
 * Returns rotation toward a point from the primary effect character.
 *
 */
int _CHR_GET_REF_ROT(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 4 && argument_count != 6) {
        return 0;
    }

    if (now_script->chara == nullptr) {
        return 0;
    }

    float dir[4];
    float pos[4];
    GetStackVector(dir, stack);
    stack = stack + 3;
    now_script->chara->GetPosition(pos);
    sceVu0SubVector(dir, dir, pos);
    sceVu0Normalize(dir, dir);
    float *z = &dir[2];
    float  yaw = atan2f(dir[0], *z);
    float  pitch = -atan2f(dir[1], sqrtf(dir[0] * dir[0] + *z * *z));

    switch (argument_count) {
        case 4:
            SetStack(stack, yaw);
            break;
        case 6:
            SetStack(stack++, pitch);
            SetStack(stack++, yaw);
            SetStack(stack, 0.0f);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Offsets the primary effect character position.
 *
 */
int _CHR_ADD_POS(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (now_script->chara == nullptr) {
        return 0;
    }

    float offset[4];
    float pos[4];
    GetStackVector(offset, stack);
    now_script->chara->GetPosition(pos);
    sceVu0AddVector(pos, pos, offset);
    now_script->chara->SetPosition(pos);
    return 1;
}

/**
 *
 * Offsets the primary effect character rotation.
 *
 */
int _CHR_ADD_ROT(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (now_script->chara == nullptr) {
        return 0;
    }

    float offset[4];
    float rot[4];
    GetStackVector(offset, stack);
    now_script->chara->GetRotation(rot);
    sceVu0AddVector(rot, rot, offset);
    rot[0] = mgAngleLimit(rot[0]);
    float *y = &rot[1];
    *y = mgAngleLimit(*y);
    float *z = &rot[2];
    *z = mgAngleLimit(*z);
    rot[3] = 1.0f;
    now_script->chara->SetRotation(rot);
    return 1;
}

/**
 *
 * Calculates and discards a primary effect character scale offset.
 *
 */
int _CHR_ADD_SCALE(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (now_script->chara == nullptr) {
        return 0;
    }

    float offset[4];
    float scale[4];
    GetStackVector(offset, stack);
    now_script->chara->GetScale(scale);
    sceVu0AddVector(scale, scale, offset);

    now_script->chara->GetScale(scale);
    return 1;
}

/**
 *
 * Assigns the primary character to another effect script slot.
 *
 */
int _CHR_COPY_CHARA(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (now_script->chara == nullptr) {
        return 0;
    }

    return EffScriptMan->AssignCharacter(now_script, GetStackInt(stack));
}

/**
 *
 * Sets a secondary effect character position.
 *
 */
int _CHR_SET_POS2(dc2::script::RunArguments args) {
    if (args.Remaining() != 4) {
        return 0;
    }
    CCharacter2 *character = GetSubCharacter(args);
    if (character == nullptr) {
        return 0;
    }
    float vector[4];
    GetRunVector(vector, args);
    character->SetPosition(vector);
    return 1;
}

/**
 *
 * Sets a secondary effect character rotation.
 *
 */
int _CHR_SET_ROT2(dc2::script::RunArguments args) {
    if (args.Remaining() != 4) {
        return 0;
    }
    CCharacter2 *character = GetSubCharacter(args);
    if (character == nullptr) {
        return 0;
    }
    float vector[4];
    GetRunVector(vector, args);
    character->SetRotation(vector);
    return 1;
}

/**
 *
 * Sets a secondary effect character scale.
 *
 */
int _CHR_SET_SCALE2(dc2::script::RunArguments args) {
    if (args.Remaining() != 4) {
        return 0;
    }
    CCharacter2 *character = GetSubCharacter(args);
    if (character == nullptr) {
        return 0;
    }
    float vector[4];
    GetRunVector(vector, args);
    character->SetScale(vector);
    return 1;
}

/**
 *
 * Starts a named motion on a secondary effect character.
 *
 */
int _CHR_SET_MOTION2(dc2::script::RunArguments args) {
    if (args.Remaining() < 2 || args.Remaining() > 4) {
        return 0;
    }
    CCharacter2 *character = GetSubCharacter(args);
    if (character == nullptr) {
        return 0;
    }
    int   mode = 0;
    float step = -1.0f;
    char *name = dc2::script::RunCString(args++);
    if (args.Remaining() > 0) {
        step = dc2::script::RunFloat(args++);
    }
    if (args.Remaining() > 0) {
        mode = dc2::script::RunInteger(args);
    }
    character->SetMotion(name, mode);

    if (step >= 0.0f) {
        character->SetStep(step);
    }

    return 1;
}

/**
 *
 * Offsets a secondary effect character position.
 *
 */
int _CHR_ADD_POS2(dc2::script::RunArguments args) {
    if (args.Remaining() != 4) {
        return 0;
    }
    CCharacter2 *character = GetSubCharacter(args);
    if (character == nullptr) {
        return 0;
    }
    float offset[4];
    float pos[4];
    GetRunVector(offset, args);
    character->GetPosition(pos);
    sceVu0AddVector(pos, pos, offset);
    character->SetPosition(pos);
    return 1;
}

/**
 *
 * Offsets a secondary effect character rotation.
 *
 */
int _CHR_ADD_ROT2(dc2::script::RunArguments args) {
    if (args.Remaining() != 4) {
        return 0;
    }
    CCharacter2 *character = GetSubCharacter(args);
    if (character == nullptr) {
        return 0;
    }
    float delta[4];
    float rot[4];
    GetRunVector(delta, args);
    character->GetRotation(rot);
    sceVu0AddVector(rot, rot, delta);
    rot[0] = mgAngleLimit(rot[0]);
    float *y = &rot[1];
    *y = mgAngleLimit(*y);
    float *z = &rot[2];
    *z = mgAngleLimit(*z);
    rot[3] = 1.0f;
    character->SetRotation(rot);
    return 1;
}

/**
 *
 * Offsets a secondary effect character scale.
 *
 */
int _CHR_ADD_SCALE2(dc2::script::RunArguments args) {
    if (args.Remaining() != 4) {
        return 0;
    }
    CCharacter2 *character = GetSubCharacter(args);
    if (character == nullptr) {
        return 0;
    }
    float offset[4];
    float scale[4];
    GetRunVector(offset, args);
    character->GetScale(scale);
    sceVu0AddVector(scale, scale, offset);
    character->SetScale(scale);
    return 1;
}

/**
 *
 * Changes secondary effect character visibility with optional fading.
 *
 */
int _CHR_SET_SHOW2(dc2::script::RunArguments args) {
    if (args.Remaining() < 2 || args.Remaining() > 4) {
        return 0;
    }
    CCharacter2 *character = GetSubCharacter(args);
    if (character == nullptr) {
        return 0;
    }
    const int show = dc2::script::RunInteger(args++);
    int       fade = 0;
    if (args.Remaining() > 0) {
        fade = dc2::script::RunInteger(args++);
    }
    if (args.Remaining() > 0) {
        dc2::script::RunFloat(args);
    }
    character->Show(show);
    character->fade = 1;
    character->fade_speed = 0.1f;

    if (fade == 1 && show == 1) {
        character->fade_alpha = 0.0001f;
    } else if (fade == 1 && show == 0) {
        character->fade_alpha = 1.0f;
    }

    return 1;
}

/**
 *
 * Returns the world position of a named primary character frame.
 *
 */
int _CHR_GET_FRAME_POS(dc2::script::RunArguments args) {
    if (now_script == nullptr || args.Remaining() != 4) {
        return 0;
    }
    if (now_script->chara == nullptr) {
        return 0;
    }
    char      *name = dc2::script::RunCString(args++);
    const auto outputs = GetRunVectorOutputs(args);
    mgCFrame  *character_frame = {};
    mgCFrame  *frame = {};

    if ((character_frame = now_script->chara->CObjectFrame::frame) == nullptr) {
        return 0;
    }

    if ((frame = character_frame->SearchFrame(name)) == nullptr) {
        return 0;
    }

    float pos[4];
    frame->GetWorldPosition0(pos);
    outputs[0]->val.f = pos[0];
    outputs[1]->val.f = pos[1];
    outputs[2]->val.f = pos[2];
    return 1;
}

/**
 *
 * Changes the draw state of a named primary character frame.
 *
 */
int _CHR_SET_FRAME_SHOW(dc2::script::RunArguments args) {
    if (now_script == nullptr || now_script->chara == nullptr || args.Remaining() != 3) {
        return 0;
    }
    char     *name = dc2::script::RunCString(args++);
    int       show = dc2::script::RunInteger(args++);
    int       attr_mask = dc2::script::RunInteger(args);
    mgCFrame *character_frame = now_script->chara->CObjectFrame::frame;

    if (character_frame == nullptr) {
        return 0;
    }

    mgCFrame *frame = {};

    if ((frame = character_frame->SearchFrame(name)) == nullptr) {
        return 0;
    }

    mgCFrameAttr attr;
    attr.draw = show;
    frame->SetAttrParam(attr, attr_mask, 1);
    return 1;
}

/**
 *
 * Reports whether the primary effect character motion has ended.
 *
 */
int _CHR_CHK_MOT_END(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 1) {
        return 0;
    }

    CCharacter2 *chara = now_script->chara;

    if (chara == nullptr) {
        return 0;
    }

    SetStack(stack, chara->CheckMotionEnd());
    return 1;
}

/**
 *
 * Sets lighting color and optional lighting bypass on the primary character.
 *
 */
int _CHR_SET_LIGHT_COLOR(dc2::script::RunArguments stack, int argument_count) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argument_count != 5 && argument_count != 4) {
        return 0;
    }

    mgCFrameAttr attr;

    if (now_script == nullptr) {
        return 0;
    }

    int       flags = {};
    mgCFrame *frame = now_script->chara->CObjectFrame::frame;

    if (frame == nullptr) {
        return 0;
    }

    float red = GetStackFloat(stack++);
    float green = GetStackFloat(stack++);
    float blue = GetStackFloat(stack++);
    float alpha = GetStackFloat(stack++);
    attr.color[0] = red;
    attr.color[1] = green;
    attr.color[2] = blue;
    attr.color[3] = alpha;
    flags = MG_FRAME_ATTR_COLOR;

    if (argument_count == 5) {
        flags |= MG_FRAME_ATTR_NO_LIGHT;
        attr.no_light = GetStackInt(stack);
    }

    frame->SetAttrParam(attr, 1, flags);
    return 1;
}

/**
 *
 * Allocates sprite slots for the current effect script.
 *
 */
int _SPT_ASSIGN_SPRITE(dc2::script::RunArguments stack, int argument_count);

/**
 *
 * Releases sprite slots owned by the current effect script.
 *
 */
int _SPT_DELETE_SPRITE(dc2::script::RunArguments, int) {
    _ES_SPRITE *sprite = now_script->sprite;

    if (sprite == nullptr) {
        return 0;
    }

    EffScriptMan->DeleteSprite(sprite);
    now_script->sprite = nullptr;
    now_script->sprite_num = 0;
    return 1;
}

/**
 *
 * Sets the texture name used by effect sprites.
 *
 */
int _SPT_SET_TEXNAME(dc2::script::RunArguments args) {
    if (now_script == nullptr) {
        return 0;
    }
    const std::string_view name = dc2::script::RunText(args);
    if (name.size() >= sizeof(now_script->tex_name)) {
        return 0;
    }
    dc2::text::Copy(now_script->tex_name, name);
    return 1;
}

/**
 *
 * Sets alpha blend mode for a range of effect sprites.
 *
 */
int _SPT_SET_ALPHAB(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    int         first = {};
    int         alpha = {};
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    alpha = GetStackInt(stack++);

    if (argument_count >= 3) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        sprite->alpha = alpha;
    }

    return 1;
}

/**
 *
 * Restores default values for a range of effect sprites.
 *
 */
int _SPT_INIT_SPRITE(dc2::script::RunArguments stack, int argument_count);

/**
 *
 * Sets visibility for a range of effect sprites.
 *
 */
int _SPT_SET_DRAW_FLAG(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    int         first = {};
    int         draw_flag = {};
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    draw_flag = GetStackInt(stack++);

    if (argument_count >= 3) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        sprite->draw_flag = draw_flag;
    }

    return 1;
}

/**
 *
 * Returns the visibility flag of an effect sprite.
 *
 */
int _SPT_GET_DRAW_FLAG(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    if (argument_count != 2) {
        return 0;
    }

    auto        result_slot = stack + 1;
    _ES_SPRITE *sprite = GetSpritePtr(now_script, GetStackInt(stack));

    if (sprite == nullptr) {
        return 0;
    }

    SetStack(result_slot, sprite->draw_flag);
    return 1;
}

/**
 *
 * Sets texture origin and size for a range of effect sprites.
 *
 */
int _SPT_SET_UV_SIZE(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    int         first = {};
    float       value[4];
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    value[0] = GetStackFloat(stack++);
    value[1] = GetStackFloat(stack++);
    value[2] = GetStackFloat(stack++);
    value[3] = GetStackFloat(stack++);

    if (argument_count >= 6) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        CopyEffectVector(sprite->uv, value);
    }

    return 1;
}

/**
 *
 * Sets rendered size for a range of effect sprites.
 *
 */
int _SPT_SET_PUT_SIZE(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    int         first = {};
    float       put_size[2];
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    put_size[0] = GetStackFloat(stack++);
    put_size[1] = GetStackFloat(stack++);

    if (argument_count >= 4) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        sprite->put_size[0] = put_size[0];
        sprite->put_size[1] = put_size[1];
    }

    return 1;
}

/**
 *
 * Sets position for a range of effect sprites.
 *
 */
int _SPT_SET_POS(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    int         first = {};
    float       value[4];
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    GetStackVector(value, stack);
    stack = stack + 3;

    if (argument_count >= 5) {
        count = GetStackInt(stack++);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        CopyEffectVector(sprite->pos, value);
    }

    return 1;
}

/**
 *
 * Returns an effect sprite position.
 *
 */
int _SPT_GET_POS(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    if (argument_count != 4) {
        return 0;
    }

    _ES_SPRITE *sprite = GetSpritePtr(now_script, GetStackInt(stack++));

    if (sprite == nullptr) {
        return 0;
    }

    SetStack(stack++, sprite->pos[0]);
    SetStack(stack++, sprite->pos[1]);
    SetStack(stack, sprite->pos[2]);
    return 1;
}

/**
 *
 * Sets rotation around the screen normal for a range of sprites.
 *
 */
int _SPT_SET_ROTZ(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    int         first = {};
    float       rotz = {};
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    rotz = GetStackFloat(stack++);

    if (argument_count >= 3) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        sprite->rotz = rotz;
    }

    return 1;
}

/**
 *
 * Returns an effect sprite rotation around the screen normal.
 *
 */
int _SPT_GET_ROTZ(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    if (argument_count != 2) {
        return 0;
    }

    auto        result_slot = stack + 1;
    _ES_SPRITE *sprite = GetSpritePtr(now_script, GetStackInt(stack));

    if (sprite == nullptr) {
        return 0;
    }

    SetStack(result_slot, sprite->rotz);
    return 1;
}

/**
 *
 * Sets two-dimensional scale for a range of effect sprites.
 *
 */
int _SPT_SET_SCALE(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    int         first = {};
    float       scale[2];
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    scale[0] = GetStackFloat(stack++);
    scale[1] = GetStackFloat(stack++);

    if (argument_count >= 4) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        sprite->scale[0] = scale[0];
        sprite->scale[1] = scale[1];
    }

    return 1;
}

/**
 *
 * Returns an effect sprite two-dimensional scale.
 *
 */
int _SPT_GET_SCALE(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    if (argument_count != 3) {
        return 0;
    }

    _ES_SPRITE *sprite = GetSpritePtr(now_script, GetStackInt(stack++));

    if (sprite == nullptr) {
        return 0;
    }

    SetStack(stack++, sprite->scale[0]);
    SetStack(stack, sprite->scale[1]);
    return 1;
}

/**
 *
 * Sets RGBA color for a range of effect sprites.
 *
 */
int _SPT_SET_COLOR(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    int         first = {};
    float       value[4];
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    value[0] = GetStackFloat(stack++);
    value[1] = GetStackFloat(stack++);
    value[2] = GetStackFloat(stack++);
    value[3] = GetStackFloat(stack++);

    if (argument_count >= 6) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        CopyEffectVector(sprite->color, value);
    }

    return 1;
}

/**
 *
 * Returns an effect sprite RGBA color.
 *
 */
int _SPT_GET_COLOR(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    if (argument_count != 5) {
        return 0;
    }

    _ES_SPRITE *sprite = GetSpritePtr(now_script, GetStackInt(stack++));

    if (sprite == nullptr) {
        return 0;
    }

    SetStack(stack++, sprite->color[0]);
    SetStack(stack++, sprite->color[1]);
    SetStack(stack++, sprite->color[2]);
    SetStack(stack, sprite->color[3]);
    return 1;
}

/**
 *
 * Assigns successive sprite positions using velocity and acceleration.
 *
 */
int _SPT_VAN_SET_POS(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first_sprite = {};
    float       position[4];
    float       velocity[4];
    float       acceleration[4];
    int         sprite_count = {};
    int         sprite_index = {};
    _ES_SPRITE *sprite = {};

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    GetStackVector(position, stack);
    GetStackVector(velocity, stack + 3);
    GetStackVector(acceleration, stack + 6);
    stack = stack + 9;

    if (argc >= 11) {
        sprite_count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first_sprite, sprite_count)) {
        return 0;
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == nullptr) {
            return 0;
        }

        CopyEffectVector(sprite->pos, position);
        sceVu0AddVector(position, position, velocity);
        position[3] = 1.0f;
        sceVu0AddVector(velocity, velocity, acceleration);
        velocity[3] = 1.0f;
    }

    return 1;
}

/**
 *
 * Assigns successive sprite rotations using angular velocity and acceleration.
 *
 */
int _SPT_VAN_SET_ROT(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first_sprite = {};
    float       angle = {};
    float       velocity = {};
    float       acceleration = {};
    int         sprite_count = {};
    int         sprite_index = {};
    _ES_SPRITE *sprite = {};

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    angle = GetStackFloat(stack++);
    velocity = GetStackFloat(stack++);
    acceleration = GetStackFloat(stack++);

    if (argc >= 5) {
        sprite_count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first_sprite, sprite_count)) {
        return 0;
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == nullptr) {
            return 0;
        }

        angle = mgAngleLimit(angle);
        sprite->rotz = angle;
        angle += velocity;
        velocity += acceleration;
    }

    return 1;
}

/**
 *
 * Assigns successive sprite colors using velocity and acceleration.
 *
 */
int _SPT_VAN_SET_COL(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first_sprite = {};
    float       color[4];
    float       velocity[4];
    float       acceleration[4];
    int         sprite_count = {};
    int         sprite_index = {};
    _ES_SPRITE *sprite = {};

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    color[0] = GetStackFloat(stack++);
    color[1] = GetStackFloat(stack++);
    color[2] = GetStackFloat(stack++);
    color[3] = GetStackFloat(stack++);
    velocity[0] = GetStackFloat(stack++);
    velocity[1] = GetStackFloat(stack++);
    velocity[2] = GetStackFloat(stack++);
    velocity[3] = GetStackFloat(stack++);
    acceleration[0] = GetStackFloat(stack++);
    acceleration[1] = GetStackFloat(stack++);
    acceleration[2] = GetStackFloat(stack++);
    acceleration[3] = GetStackFloat(stack++);

    if (argc >= 14) {
        sprite_count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first_sprite, sprite_count)) {
        return 0;
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == nullptr) {
            return 0;
        }

        CopyEffectVector(sprite->color, color);
        sceVu0AddVector(color, color, velocity);
        sceVu0AddVector(velocity, velocity, acceleration);
    }

    return 1;
}

/**
 *
 * Assigns successive sprite scales using velocity and acceleration.
 *
 */
int _SPT_VAN_SET_SCL(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first_sprite = {};
    float       x = {};
    float       y = {};
    float       velocity_x = {};
    float       velocity_y = {};
    float       acceleration_x = {};
    float       acceleration_y = {};
    int         sprite_count = {};
    int         sprite_index = {};
    _ES_SPRITE *sprite = {};

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    x = GetStackFloat(stack++);
    y = GetStackFloat(stack++);
    velocity_x = GetStackFloat(stack++);
    velocity_y = GetStackFloat(stack++);
    acceleration_x = GetStackFloat(stack++);
    acceleration_y = GetStackFloat(stack++);

    if (argc >= 8) {
        sprite_count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first_sprite, sprite_count)) {
        return 0;
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == nullptr) {
            return 0;
        }

        sprite->scale[0] = x;
        sprite->scale[1] = y;
        x += velocity_x;
        y += velocity_y;
        velocity_x += acceleration_x;
        velocity_y += acceleration_y;
    }

    return 1;
}

/**
 *
 * Offsets positions of a range of effect sprites.
 *
 */
int _SPT_ADD_POS(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first_sprite = {};
    float       offset[4];
    int         sprite_count = {};
    int         sprite_index = {};
    _ES_SPRITE *sprite = {};

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    GetStackVector(offset, stack);
    stack = stack + 3;

    if (argc >= 5) {
        sprite_count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first_sprite, sprite_count)) {
        return 0;
    }

    for (sprite_index = first_sprite; sprite_index < sprite_count + first_sprite; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == nullptr) {
            return 0;
        }

        sceVu0AddVector(sprite->pos, sprite->pos, offset);
    }

    return 1;
}

/**
 *
 * Offsets rotations of a range of effect sprites.
 *
 */
int _SPT_ADD_ROTZ(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first = {};
    float       angle = {};
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    angle = GetStackFloat(stack++);

    if (argc >= 3) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        sprite->rotz += angle;
        sprite->rotz = mgAngleLimit(sprite->rotz);
    }

    return 1;
}

/**
 *
 * Offsets and clamps colors of a range of effect sprites.
 *
 */
int _SPT_ADD_COLOR(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first_sprite = {};
    float       color_delta[4];
    int         sprite_count = {};
    int         sprite_index = {};
    _ES_SPRITE *sprite = {};

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    color_delta[0] = GetStackFloat(stack++);
    color_delta[1] = GetStackFloat(stack++);
    color_delta[2] = GetStackFloat(stack++);
    color_delta[3] = GetStackFloat(stack++);

    if (argc >= 6) {
        sprite_count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first_sprite, sprite_count)) {
        return 0;
    }

    for (sprite_index = first_sprite; sprite_index < sprite_count + first_sprite; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == nullptr) {
            return 0;
        }

        sceVu0AddVector(sprite->color, sprite->color, color_delta);

        if (sprite->color[0] <= 0.0f) {
            sprite->color[0] = 0.0f;
        } else if (!(sprite->color[0] < 255.0f)) {
            sprite->color[0] = 255.0f;
        }

        if (sprite->color[1] <= 0.0f) {
            sprite->color[1] = 0.0f;
        } else if (!(sprite->color[1] < 255.0f)) {
            sprite->color[1] = 255.0f;
        }

        if (sprite->color[2] <= 0.0f) {
            sprite->color[2] = 0.0f;
        } else if (!(sprite->color[2] < 255.0f)) {
            sprite->color[2] = 255.0f;
        }

        if (sprite->color[3] <= 0.0f) {
            sprite->color[3] = 0.0f;
        } else if (!(sprite->color[3] < 255.0f)) {
            sprite->color[3] = 255.0f;
        }
    }

    return 1;
}

/**
 *
 * Rotates positions of a range of sprites around the world Y axis.
 *
 */
int _SPT_WORLD_ROT(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first = {};
    float       angle = {};
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};
    float       matrix[4][4];

    count = 1;
    first = GetStackInt(stack++);
    angle = GetStackFloat(stack++);

    if (argc >= 3) {
        count = GetStackInt(stack);
    }

    sceVu0UnitMatrix(matrix);
    mgRotMatrixY(matrix, angle);

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        sceVu0ApplyMatrix(sprite->pos, matrix, sprite->pos);
    }

    return 1;
}

/**
 *
 * Rejects the unsupported sprite lifetime command.
 *
 */
int _SPT_SET_LIFE(dc2::script::RunArguments, int) {
    return 0;
}

/**
 *
 * Sets position velocity for a range of effect sprites.
 *
 */
int _SPT_SET_VELO_POS(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first_sprite = {};
    float       velocity[4];
    int         sprite_count = {};
    int         sprite_index = {};
    _ES_SPRITE *sprite = {};

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    GetStackVector(velocity, stack);
    velocity[3] = 0.0f;
    stack = stack + 3;

    if (argc >= 5) {
        sprite_count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first_sprite, sprite_count)) {
        return 0;
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == nullptr) {
            return 0;
        }

        CopyEffectVector(sprite->velo_pos, velocity);
    }

    return 1;
}

/**
 *
 * Sets position acceleration for a range of effect sprites.
 *
 */
int _SPT_SET_ACC_POS(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first_sprite = {};
    float       acceleration[4];
    int         sprite_count = {};
    int         sprite_index = {};
    _ES_SPRITE *sprite = {};

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    GetStackVector(acceleration, stack);
    acceleration[3] = 0.0f;
    stack = stack + 3;

    if (argc >= 5) {
        sprite_count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first_sprite, sprite_count)) {
        return 0;
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == nullptr) {
            return 0;
        }

        CopyEffectVector(sprite->acc_pos, acceleration);
    }

    return 1;
}

/**
 *
 * Sets angular velocity for a range of effect sprites.
 *
 */
int _SPT_SET_VELO_ROTZ(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first = {};
    float       value = {};
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    value = GetStackFloat(stack++);

    if (argc >= 3) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        sprite->velo_rotz = value;
    }

    return 1;
}

/**
 *
 * Sets angular acceleration for a range of effect sprites.
 *
 */
int _SPT_SET_ACC_ROTZ(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first = {};
    float       value = {};
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    value = GetStackFloat(stack++);

    if (argc >= 3) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        sprite->acc_rotz = value;
    }

    return 1;
}

/**
 *
 * Sets color velocity for a range of effect sprites.
 *
 */
int _SPT_SET_VELO_COL(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first_sprite = {};
    float       color_velocity[4];
    int         sprite_count = {};
    int         sprite_index = {};
    _ES_SPRITE *sprite = {};

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    color_velocity[0] = GetStackFloat(stack++);
    color_velocity[1] = GetStackFloat(stack++);
    color_velocity[2] = GetStackFloat(stack++);
    color_velocity[3] = GetStackFloat(stack++);

    if (argc >= 6) {
        sprite_count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first_sprite, sprite_count)) {
        return 0;
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == nullptr) {
            return 0;
        }

        CopyEffectVector(sprite->velo_col, color_velocity);
    }

    return 1;
}

/**
 *
 * Sets color acceleration for a range of effect sprites.
 *
 */
int _SPT_SET_ACC_COL(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first_sprite = {};
    float       color_acceleration[4];
    int         sprite_count = {};
    int         sprite_index = {};
    _ES_SPRITE *sprite = {};

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    color_acceleration[0] = GetStackFloat(stack++);
    color_acceleration[1] = GetStackFloat(stack++);
    color_acceleration[2] = GetStackFloat(stack++);
    color_acceleration[3] = GetStackFloat(stack++);

    if (argc >= 6) {
        sprite_count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first_sprite, sprite_count)) {
        return 0;
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == nullptr) {
            return 0;
        }

        CopyEffectVector(sprite->acc_col, color_acceleration);
    }

    return 1;
}

/**
 *
 * Sets color blinking amplitude and speed for effect sprites.
 *
 */
int _SPT_SET_BLINKING(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first_sprite = {};
    float       color[4];
    float       speed = {};
    int         sprite_count = {};
    int         sprite_index = {};
    _ES_SPRITE *sprite = {};

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    color[0] = GetStackFloat(stack++);
    color[1] = GetStackFloat(stack++);
    color[2] = GetStackFloat(stack++);
    color[3] = GetStackFloat(stack++);
    speed = GetStackFloat(stack++);

    if (argc >= 7) {
        sprite_count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first_sprite, sprite_count)) {
        return 0;
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == nullptr) {
            return 0;
        }

        CopyEffectVector(sprite->blink_amp, color);
        sprite->blink_speed = speed;
        sprite->blink_phase = 0;
    }

    return 1;
}

/**
 *
 * Sets scale velocity for a range of effect sprites.
 *
 */
int _SPT_SET_VELO_SCL(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first = {};
    float       x = {};
    float       y = {};
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    x = GetStackFloat(stack++);
    y = GetStackFloat(stack++);

    if (argc >= 4) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        sprite->velo_scl[0] = x;
        sprite->velo_scl[1] = y;
    }

    return 1;
}

/**
 *
 * Sets scale acceleration for a range of effect sprites.
 *
 */
int _SPT_SET_ACC_SCL(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first = {};
    float       x = {};
    float       y = {};
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    x = GetStackFloat(stack++);
    y = GetStackFloat(stack++);

    if (argc >= 4) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        sprite->acc_scl[0] = x;
        sprite->acc_scl[1] = y;
    }

    return 1;
}

/**
 *
 * Sets target scale and convergence divisor for effect sprites.
 *
 */
int _SPT_SCALE_CONV(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first = {};
    float       time = {};
    float       target_x = {};
    float       target_y = {};
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);
    target_x = GetStackFloat(stack++);
    target_y = GetStackFloat(stack++);
    time = GetStackFloat(stack++);

    if (argc >= 5) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < first + count; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        sprite->scale_target[0] = target_x;
        sprite->scale_target[1] = target_y;
        sprite->scale_conv_div = time;
    }

    return 1;
}

/**
 *
 * Sets target color and convergence divisor for effect sprites.
 *
 */
int _SPT_COLOR_CONV(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    int         first_sprite = {};
    float       color[4];
    float       divisor = {};
    int         sprite_count = {};
    int         sprite_index = {};
    _ES_SPRITE *sprite = {};

    sprite_count = 1;
    first_sprite = GetStackInt(stack++);
    color[0] = GetStackFloat(stack++);
    color[1] = GetStackFloat(stack++);
    color[2] = GetStackFloat(stack++);
    color[3] = GetStackFloat(stack++);
    divisor = GetStackFloat(stack++);

    if (argc >= 7) {
        sprite_count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first_sprite, sprite_count)) {
        return 0;
    }

    for (sprite_index = first_sprite; sprite_index < first_sprite + sprite_count; sprite_index++) {
        sprite = GetSpritePtr(now_script, sprite_index);

        if (sprite == nullptr) {
            return 0;
        }

        CopyEffectVector(sprite->color_target, color);
        sprite->color_conv_div = divisor;
    }

    return 1;
}

/**
 *
 * Returns the position of a scene character.
 *
 */
int _SCN_GET_CHR_POS(dc2::script::RunArguments stack, int argc) {
    if (now_scene == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    float        pos[4];
    CCharacter2 *chara = {};

    if (argc != 4) {
        return 0;
    }

    chara = now_scene->GetCharacter(GetStackInt(stack++));

    if (chara == nullptr) {
        return 0;
    }

    chara->GetPosition(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Returns the yaw or full rotation of a scene character.
 *
 */
int _SCN_GET_CHR_ROT(dc2::script::RunArguments stack, int argc) {
    if (now_scene == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    float        rot[4];
    CCharacter2 *chara = {};

    if (argc != 2 && argc != 4) {
        return 0;
    }

    chara = now_scene->GetCharacter(GetStackInt(stack++));

    if (chara == nullptr) {
        return 0;
    }

    chara->GetRotation(rot);

    switch (argc) {
        case 2:
            SetStack(stack, rot[1]);
            break;
        case 4:
            SetStack(stack++, rot[0]);
            SetStack(stack++, rot[1]);
            SetStack(stack, rot[2]);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Returns the world position of a named scene character frame.
 *
 */
int _SCN_GET_CHR_FRM_POS(dc2::script::RunArguments args) {
    float        pos[4];
    int          chara_slot = {};
    char        *frame_name = {};
    CCharacter2 *chara = {};
    mgCFrame    *frame = {};

    if (now_scene == nullptr || args.Remaining() != 5) {
        return 0;
    }
    chara_slot = dc2::script::RunInteger(args++);
    frame_name = dc2::script::RunCString(args++);
    const auto outputs = GetRunVectorOutputs(args);
    chara = now_scene->GetCharacter(chara_slot);

    if (chara == nullptr) {
        return 0;
    }

    if (chara->CObjectFrame::frame == nullptr) {
        return 0;
    }

    frame = chara->CObjectFrame::frame->SearchFrame(frame_name);

    if (frame == nullptr) {
        return 0;
    }

    frame->GetWorldPosition0(pos);
    outputs[0]->val.f = pos[0];
    outputs[1]->val.f = pos[1];
    outputs[2]->val.f = pos[2];
    return 1;
}

/**
 *
 * Returns the world direction of a named scene character frame.
 *
 */
int _SCN_GET_CHR_FRM_DIR(dc2::script::RunArguments args) {
    float        direction[4];
    int          chara_slot = {};
    char        *frame_name = {};
    CCharacter2 *character = {};
    mgCFrame    *frame = {};

    if (now_scene == nullptr || args.Remaining() != 5) {
        return 0;
    }
    chara_slot = dc2::script::RunInteger(args++);
    frame_name = dc2::script::RunCString(args++);
    const auto outputs = GetRunVectorOutputs(args);
    character = now_scene->GetCharacter(chara_slot);

    if (character == nullptr) {
        return 0;
    }

    if (character->CObjectFrame::frame == nullptr) {
        return 0;
    }

    frame = character->CObjectFrame::frame->SearchFrame(frame_name);

    if (frame == nullptr) {
        return 0;
    }

    direction[0] = 0.0f;
    direction[1] = 0.0f;
    direction[2] = 1.0f;
    direction[3] = 0.0f;
    frame->GetWorldDir(direction, direction);
    outputs[0]->val.f = direction[0];
    outputs[1]->val.f = direction[1];
    outputs[2]->val.f = direction[2];
    return 1;
}

/**
 *
 * Returns pitch and yaw from a named scene character frame.
 *
 */
int _SCN_GET_CHR_FRM_ROT(dc2::script::RunArguments args) {
    float        direction[4];
    float        origin[4];
    float        yaw = {};
    int          chara_slot = {};
    char        *frame_name = {};
    CCharacter2 *character = {};
    mgCFrame    *frame = {};

    if (now_scene == nullptr || args.Remaining() != 5) {
        return 0;
    }
    chara_slot = dc2::script::RunInteger(args++);
    frame_name = dc2::script::RunCString(args++);
    const auto outputs = GetRunVectorOutputs(args);
    character = now_scene->GetCharacter(chara_slot);

    if (character == nullptr) {
        return 0;
    }

    if (character->CObjectFrame::frame == nullptr) {
        return 0;
    }

    frame = character->CObjectFrame::frame->SearchFrame(frame_name);

    if (frame == nullptr) {
        return 0;
    }

    direction[0] = 0.0f;
    direction[1] = 0.0f;
    direction[2] = 1.0f;
    direction[3] = 0.0f;
    origin[0] = 0.0f;
    origin[1] = 0.0f;
    origin[2] = 0.0f;
    origin[3] = 1.0f;
    frame->GetWorldDir(direction, direction);
    sceVu0SubVector(direction, direction, origin);
    sceVu0Normalize(direction, direction);
    yaw = atan2f(direction[0], direction[2]);
    outputs[0]->val.f = -atan2f(direction[1], sqrtf(direction[0] * direction[0] + direction[2] * direction[2]));
    outputs[1]->val.f = yaw;
    outputs[2]->val.f = 0.0f;
    return 1;
}

/**
 *
 * Returns the position of a scene character entry object.
 *
 */
int _SCN_GET_ENTRY_OBJ_POS(dc2::script::RunArguments stack, int argc) {
    if (now_scene == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    float pos[4];
    int   chara_slot = {};
    int   entry_index = {};

    if (argc != 5) {
        return 0;
    }

    chara_slot = GetStackInt(stack++);
    entry_index = GetStackInt(stack++);

    if (entry_index < 0 || entry_index > 1) {
        return 0;
    }

    CCharacter2 *chara = now_scene->GetCharacter(chara_slot);

    if (chara == nullptr) {
        return 0;
    }

    chara->GetEntryObjectPos(entry_index, pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Tests a segment against scene collision polygons and returns hit details to the script.
 *
 */
int _INTERSECTION_POINT(dc2::script::RunArguments stack, int argc) {
    if (now_scene == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    sceVu0FVECTOR start;
    sceVu0FVECTOR end;
    sceVu0FVECTOR hit;
    sceVu0FVECTOR reflection;
    mgVu0FBOX     box{};
    CCPoly        poly[0x80];
    sceVu0FVECTOR normal;

    if (argc != 8 && argc != 9 && argc != 10 && argc != 11 && argc != 12 && argc != 13 && argc != 14 && argc != 15 && argc != 16) {
        return 0;
    }

    int ignore_mask = GetStackInt(stack++);
    GetStackVector(start, stack);
    GetStackVector(end, stack + 3);
    stack = stack + 6;
    float range = 10.0f + mgDistVector(start, end);
    box.max[0] = range + start[0];
    box.min[0] = start[0] - range;
    box.max[1] = range + start[1];
    box.min[1] = start[1] - range;
    box.max[2] = range + start[2];
    box.min[2] = start[2] - range;
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    int poly_num = now_scene->GetColPoly(poly, box, 0x80);

    if (poly_num >= 0x80) {
        dc2::log::PrintGame("effect script[INTERSECTION_POINT] poly num over[%d]\n", poly_num);
        return 0;
    }

    CCPoly *hit_poly = poly;
    int     hit_no = CheckHit(hit_poly, poly_num, start, end, hit, 1, ignore_mask);
    int     foot_sound{};
    int     area_kind{};

    if (hit_no >= 0) {
        hit_poly = &hit_poly[hit_no];
        sceVu0Normalize(normal, hit_poly->normal);
        mgReflectionPlane(normal, hit, start, reflection);
        sceVu0Normalize(reflection, reflection);
        foot_sound = hit_poly->foot_sound;
        area_kind = hit_poly->area_kind;

        if (foot_sound == 0) {
            CMap *map = now_scene->GetMap(now_scene->active_map);

            if (map != nullptr) {
                foot_sound = map->map_info.def_foot;
            }
        }
    }

    switch (argc) {
        case 8:
        case 9:
        case 10:
            SetStack(stack++, hit_no);

            if (argc >= 9) {
                SetStack(stack++, area_kind);
            }

            if (argc == 10) {
                SetStack(stack, foot_sound);
            }

            break;
        case 11:
        case 12:
        case 13:
            SetStack(stack++, hit[0]);
            SetStack(stack++, hit[1]);
            SetStack(stack++, hit[2]);
            SetStack(stack++, hit_no);

            if (argc >= 12) {
                SetStack(stack++, area_kind);
            }

            if (argc == 13) {
                SetStack(stack, foot_sound);
            }

            break;
        case 14:
        case 15:
        case 16:
            SetStack(stack++, hit[0]);
            SetStack(stack++, hit[1]);
            SetStack(stack++, hit[2]);
            SetStack(stack++, reflection[0]);
            SetStack(stack++, reflection[1]);
            SetStack(stack++, reflection[2]);
            SetStack(stack++, hit_no);

            if (argc >= 15) {
                SetStack(stack++, area_kind);
            }

            if (argc == 16) {
                SetStack(stack, foot_sound);
            }

            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Plays a sound from the current effect owner character.
 *
 */
int _MON_SE_PLAY(dc2::script::RunArguments stack, int argc) {
    if (now_script == nullptr) {
        return 0;
    }
    if (now_scene == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    float        position[4];
    float        pad[2];
    float        volume = {};
    float        pan = {};
    CCharacter2 *owner = {};
    int          se_id = {};
    u_int        se_handle = {};
    int          slot = now_script->user_id;

    if (slot <= -1) {
        return 0;
    }

    owner = now_scene->GetCharacter(slot);

    if (owner == nullptr) {
        return 0;
    }

    se_handle = owner->sound_info.se_bank;
    se_id = GetStackInt(stack++);

    switch (argc) {
        case 1:
            sndSePlay(se_handle, se_id, 0);
            break;
        case 4:
            GetStackVector(position, stack);
            sndGetVolPan(&volume, &pan, position, 160.0f, 1200.0f);
            sndSePlayVPf(se_handle, se_id, volume, pan, 0);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Stops a sound from the current effect owner character.
 *
 */
int _MON_SE_STOP(dc2::script::RunArguments stack, int argc) {
    if (now_script == nullptr) {
        return 0;
    }
    if (now_scene == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    CCharacter2 *owner = {};
    int          slot = now_script->user_id;

    if (slot <= -1) {
        return 0;
    }

    owner = now_scene->GetCharacter(slot);

    if (owner == nullptr) {
        return 0;
    }

    u_int se_handle = owner->sound_info.se_bank;
    sndSeStop(se_handle, GetStackInt(stack), 0);
    return 1;
}

/**
 *
 * Plays a sound from the scene battle sound bank.
 *
 */
int _BTL_SE_PLAY(dc2::script::RunArguments stack, int argc) {
    if (now_scene == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    float position[4];
    float pad[2];
    float volume = {};
    float pan = {};
    float near_distance = 160.0f;
    float far_distance = 1200.0f;
    int   se_id = {};
    u_int se_handle = now_scene->se_battle_id;
    se_id = GetStackInt(stack++);

    switch (argc) {
        case 1:
            sndSePlay(se_handle, se_id, 0);
            break;
        case 4:
            GetStackVector(position, stack);
            sndGetVolPan(&volume, &pan, position, near_distance, far_distance);
            sndSePlayVPf(se_handle, se_id, volume, pan, 0);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Stops a sound from the scene battle sound bank.
 *
 */
int _BTL_SE_STOP(dc2::script::RunArguments stack, int argc) {
    if (now_scene == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    u_int se_handle = {};

    se_handle = now_scene->se_battle_id;
    sndSeStop(se_handle, GetStackInt(stack), 0);
    return 1;
}

/**
 *
 * Plays a sound from the scene base sound bank.
 *
 */
int _BSE_SE_PLAY(dc2::script::RunArguments stack, int argc) {
    if (now_scene == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    u_int se_handle = {};

    se_handle = now_scene->se_base_id;
    sndSePlay(se_handle, GetStackInt(stack), 0);
    return 1;
}

/**
 *
 * Stops a sound from the scene base sound bank.
 *
 */
int _BSE_SE_STOP(dc2::script::RunArguments stack, int argc) {
    if (now_scene == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    u_int se_handle = {};

    se_handle = now_scene->se_base_id;
    sndSeStop(se_handle, GetStackInt(stack), 0);
    return 1;
}

/**
 *
 * Plays a sound from a selected scene character.
 *
 */
int _MON_SE_PLAY2(dc2::script::RunArguments stack, int argc) {
    if (now_scene == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    float        position[4];
    float        pad[2];
    float        volume = {};
    float        pan = {};
    float        near_distance = 160.0f;
    float        far_distance = 1200.0f;
    CCharacter2 *owner = {};
    int          se_id = {};
    u_int        se_handle = {};

    if (argc != 2 && argc != 5) {
        return 0;
    }

    owner = now_scene->GetCharacter(GetStackInt(stack++));

    if (owner == nullptr) {
        return 0;
    }

    se_handle = owner->sound_info.se_bank;
    se_id = GetStackInt(stack++);

    switch (argc) {
        case 2:
            sndSePlay(se_handle, se_id, 0);
            break;
        case 5:
            GetStackVector(position, stack);
            sndGetVolPan(&volume, &pan, position, near_distance, far_distance);
            sndSePlayVPf(se_handle, se_id, volume, pan, 0);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Stops a sound from a selected scene character.
 *
 */
int _MON_SE_STOP2(dc2::script::RunArguments stack, int argc) {
    if (now_scene == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    auto         second = stack + 1;
    CCharacter2 *owner = {};
    u_int        se_handle = {};
    owner = now_scene->GetCharacter(GetStackInt(stack));

    if (owner == nullptr) {
        return 0;
    }

    se_handle = owner->sound_info.se_bank;
    sndSeStop(se_handle, GetStackInt(second), 0);
    return 1;
}

/**
 *
 * Sets whether effect sprites use scene lighting.
 *
 */
int _SET_LIGHT_FLAG(dc2::script::RunArguments stack, int argc) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    now_script->light_flag = GetStackInt(stack);
    return 1;
}

/**
 *
 * Returns the position of a selected scene character entry object.
 *
 */
int _SCN_GET_CHR_ENTOBJ_POS(dc2::script::RunArguments stack, int argc) {
    if (now_scene == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    float        pos[4];
    int          chara_slot = {};
    int          entry_index = {};
    CCharacter2 *chara = {};

    if (argc != 5) {
        return 0;
    }

    chara_slot = GetStackInt(stack++);
    entry_index = GetStackInt(stack++);
    chara = now_scene->GetCharacter(chara_slot);

    if (chara == nullptr) {
        return 0;
    }

    chara->GetEntryObjectPos(entry_index, pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Rejects creation of a standalone damage object.
 *
 */
int _CREATE_DAMAGE(dc2::script::RunArguments, int) {
    dc2::log::PrintGame("effect script err   \x8C\xC3\x82\xA2\x83\x52\x83\x8A\x83\x57\x83\x87\x83\x93\x83\x4E\x83\x89\x83\x58\x82\xCD\x8E\x67\x82\xC1\x82\xBF\x82\xE1\x83\x5F\x83\x81\x82\xE6\x81\x49\x81\x49\n");
    return 0;
}

/**
 *
 * Rejects deletion of a standalone damage object.
 *
 */
int _DELETE_DAMAGE(dc2::script::RunArguments, int) {
    return 0;
}

/**
 *
 * Rejects positioning of a standalone damage object.
 *
 */
int _DMG_SET_POS(dc2::script::RunArguments, int) {
    return 0;
}

/**
 *
 * Rejects setting a standalone damage direction.
 *
 */
int _DMG_SET_FRONT_VECT(dc2::script::RunArguments, int) {
    return 0;
}

/**
 *
 * Rejects setting standalone damage.
 *
 */
int _DMG_SET_DAMAGE(dc2::script::RunArguments, int) {
    dc2::log::PrintGame("effect script err   \x8C\xC3\x82\xA2\x83\x52\x83\x8A\x83\x57\x83\x87\x83\x93\x83\x4E\x83\x89\x83\x58\x82\xCD\x8E\x67\x82\xC1\x82\xBF\x82\xE1\x83\x5F\x83\x81\x82\xE6\x81\x49\x81\x49\n");
    return 0;
}

/**
 *
 * Creates a collision primitive for the current effect script.
 *
 */
int _COLPRIM_CREATE(dc2::script::RunArguments args) {
    if (now_script == nullptr || args.Remaining() < 1 || args.Remaining() > 2) {
        return 0;
    }
    char *damage_name = dc2::script::RunCString(args++);
    int   owner = args.Remaining() > 0 ? dc2::script::RunInteger(args) : now_script->user_id;
    if (now_script->colprim != nullptr) {
        now_script->colprim->Delete(now_script->user_id);
    }
    CColPrim *colprim = ColPrimMan.GetPrim();
    now_script->colprim = colprim;

    if (colprim == nullptr) {
        return 0;
    }

    now_script->colprim->SetDamage(damage_name, owner);
    return 1;
}

/**
 *
 * Sets collision primitive coordinates from positions or named frames.
 *
 */
int _COLPRIM_SET_COORD(dc2::script::RunArguments args) {
    float     start[4];
    float     end[4];
    float     radius = {};
    mgCFrame *root = {};
    mgCFrame *frame = {};

    if (now_script == nullptr || now_script->colprim == nullptr) {
        return 0;
    }

    mgCFrame *first_frame = {};
    mgCFrame *second_frame = {};
    switch (args.Remaining()) {
        case 4:
            GetRunVector(start, args);
            radius = dc2::script::RunFloat(args + 3);
            now_script->colprim->SetCoord(start, radius);
            break;
        case 7:
            GetRunVector(start, args);
            GetRunVector(end, args + 3);
            radius = dc2::script::RunFloat(args + 6);
            now_script->colprim->SetCoord(start, end, radius);
            break;
        case 2: {
            if (now_script->chara == nullptr) {
                return 0;
            }
            char *start_name = dc2::script::RunCString(args++);
            radius = dc2::script::RunFloat(args);
            root = now_script->chara->CObjectFrame::frame;

            if (root == nullptr) {
                return 0;
            }

            frame = root->SearchFrame(start_name);

            if (frame == nullptr) {
                return 0;
            }

            now_script->colprim->SetCoord(frame, radius);
            break;
        }
        case 3: {
            if (now_script->chara == nullptr) {
                return 0;
            }
            char *start_name = dc2::script::RunCString(args++);
            char *end_name = dc2::script::RunCString(args++);
            radius = dc2::script::RunFloat(args);
            root = now_script->chara->CObjectFrame::frame;

            if (root == nullptr) {
                return 0;
            }

            if ((first_frame = root->SearchFrame(start_name)) == nullptr) {
                return 0;
            }

            if ((second_frame = root->SearchFrame(end_name)) == nullptr) {
                return 0;
            }

            now_script->colprim->SetCoord(first_frame, second_frame, radius);
            break;
        }
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Deletes the collision primitive owned by the current effect script.
 *
 */
int _COLPRIM_DELETE(dc2::script::RunArguments stack, int argc) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    CColPrim *colprim = {};

    if (now_script == nullptr) {
        return 0;
    }

    GetStackInt(stack);
    colprim = now_script->colprim;

    if (colprim == nullptr) {
        return 0;
    }

    colprim->Delete(-1);
    now_script->colprim = nullptr;
    return 1;
}

/**
 *
 * Returns the hit count of the current collision primitive.
 *
 */
int _COLPRIM_GET_HITCNT(dc2::script::RunArguments stack, int argc) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    CColPrim *colprim = {};

    if (argc != 1) {
        return 0;
    }

    colprim = now_script->colprim;

    if (colprim == nullptr) {
        return 0;
    }

    SetStack(stack, colprim->hit_num);
    return 1;
}

/**
 *
 * Assigns a gift item, count, and rate to the current collision primitive.
 *
 */
int _COLPRIM_GET_GIFT(dc2::script::RunArguments stack, int argc) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    int       item_id = {};
    int       count = {};
    int       rate = {};
    CColPrim *colprim = {};

    if (argc != 3) {
        return 0;
    }

    auto next_slot = stack + 1;

    if (now_script->colprim == nullptr) {
        return 0;
    }

    item_id = GetStackInt(stack);
    count = GetStackInt(next_slot++);
    rate = GetStackInt(next_slot);
    colprim = now_script->colprim;
    colprim->gift[0] = item_id;
    colprim->gift[1] = count;
    colprim->gift[2] = rate;
    colprim->has_gift = 1;
    dc2::log::PrintGame("%d,%d,%d\n", item_id, count, rate);
    return 1;
}

/**
 *
 * Returns the collision primitive reversal count and optional vector.
 *
 */
int _COLPRIM_GET_REVCNT(dc2::script::RunArguments stack, int argc) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argc != 4 && argc != 1) {
        return 0;
    }

    if (now_script->colprim == nullptr) {
        return 0;
    }

    SetStack(stack++, now_script->colprim->reversed);

    if (argc == 4) {
        SetStack(stack++, now_script->colprim->revers_vec[0]);
        SetStack(stack++, now_script->colprim->revers_vec[1]);
        SetStack(stack, now_script->colprim->revers_vec[2]);
    }

    return 1;
}

/**
 *
 * Sets the damage value of the current collision primitive.
 *
 */
int _COLPRIM_SET_DAMAGE(dc2::script::RunArguments stack, int argc) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (now_script->colprim == nullptr) {
        return 0;
    }

    now_script->colprim->damage = GetStackInt(stack);
    return 1;
}

/**
 *
 * Returns the last hit position of the current collision primitive.
 *
 */
int _COLPRIM_GET_HIT_POS(dc2::script::RunArguments stack, int argc) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    if (argc != 3) {
        return 0;
    }

    if (now_script->colprim == nullptr) {
        return 0;
    }

    SetStack(stack++, now_script->colprim->hit_pos[0]);
    SetStack(stack++, now_script->colprim->hit_pos[1]);
    SetStack(stack, now_script->colprim->hit_pos[2]);
    return 1;
}

/**
 *
 * Creates a child effect script for the current effect owner.
 *
 */
int _ES_CREATE(dc2::script::RunArguments args) {
    if (now_script == nullptr || EffScriptMan == nullptr || args.Remaining() < 1 || args.Remaining() > 2) {
        return 0;
    }
    int   handle = -1;
    char *name = dc2::script::RunCString(args++);

    switch (args.Remaining()) {
        case 0:
            EffScriptMan->CreateEffSpt(name, now_script->user_id, 0);
            break;
        case 1: {
            RS_STACKDATA &output = dc2::script::RunOutput(args);
            int           user_id = now_script->user_id;

            if (user_id >= 0) {
                handle = EffScriptMan->CreateEffSpt(name, user_id, 1);
            }

            output.val.i = handle;

            if (handle <= -1) {
                dc2::log::PrintGame("ES_CREATE error [%s][%d][%d]", name, now_script->user_id, handle);
            }

            break;
        }
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Sets the first work vector of a child effect script.
 *
 */
int _ES_SET_VECT1(dc2::script::RunArguments stack, int argc) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    float vect[4];
    int   target_id = {};

    switch (argc) {
        case 3:
            GetStackVector(vect, stack);
            EffScriptMan->SetScriptVect1(vect, now_script->user_id, -1);
            break;
        case 4:
            target_id = GetStackInt(stack++);
            GetStackVector(vect, stack);
            EffScriptMan->SetScriptVect1(vect, now_script->user_id, target_id);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Sets the second work vector of a child effect script.
 *
 */
int _ES_SET_VECT2(dc2::script::RunArguments stack, int argc) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    float vect[4];
    int   target_id = {};

    switch (argc) {
        case 3:
            GetStackVector(vect, stack);
            EffScriptMan->SetScriptVect2(vect, now_script->user_id, -1);
            break;
        case 4:
            target_id = GetStackInt(stack++);
            GetStackVector(vect, stack);
            EffScriptMan->SetScriptVect2(vect, now_script->user_id, target_id);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Sets the target identifier of a child effect script.
 *
 */
int _ES_SET_TARGET_ID(dc2::script::RunArguments stack, int argc) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    switch (argc) {
        case 1:
            EffScriptMan->SetScriptTargetId(GetStackInt(stack), now_script->user_id, -1);
            break;
        case 2: {
            int source_id = GetStackInt(stack++);
            EffScriptMan->SetScriptTargetId(GetStackInt(stack),
                                            now_script->user_id,
                                            source_id);
            break;
        }
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Sets a typed value in a child effect script.
 *
 */
int _ES_SET_VALUE(dc2::script::RunArguments stack, int argc) {
    if (now_script == nullptr) {
        return 0;
    }
    ValidateEffectOutputs(stack);
    int target_id = -1;
    int index = {};

    switch (argc) {
        case 2:
            break;
        case 3:
            target_id = GetStackInt(stack++);
            break;
        default:
            return 0;
    }

    index = GetStackInt(stack++);

    switch (stack.At().type) {
        case 0:
            EffScriptMan->SetValue(index, GetStackInt(stack), now_script->user_id, target_id);
            break;
        case 1:
            EffScriptMan->SetValue(index, GetStackFloat(stack), now_script->user_id, target_id);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Associates the current collision primitive with a child effect script.
 *
 */
int _ES_SET_COLPRIM(dc2::script::RunArguments, int) {
    CColPrim *colprim = {};

    colprim = now_script->colprim;

    if (colprim == nullptr) {
        return 0;
    }

    EffScriptMan->SetColPrim(colprim,
                             now_script->user_id, -1);
    return 1;
}

/**
 *
 * Returns the position of an event object handle.
 *
 */
int _GET_EOH_POS(dc2::script::RunArguments stack, int argc) {
    ValidateEffectOutputs(stack);
    float pos[4];

    if (argc != 4) {
        return 0;
    }

    EventObjHandleMother.GetPos(GetStackInt(stack++), pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Loads an effect program with script stack and call data.
 *
 */
int SetEffectScript(CRunScript *script, std::span<u8> program, mgCMemory *memory) {
    if (script == nullptr || memory == nullptr || program.empty()) {
        return 0;
    }
    auto *stack = dc2::memory::NewArray<RS_STACKDATA>(*memory, 0x40);
    auto *call_data = dc2::memory::NewArray<RS_CALLDATA>(*memory, 2);
    if (stack == nullptr || call_data == nullptr ||
        !script->load(program, std::span<RS_STACKDATA>(stack, 0x40), std::span<RS_CALLDATA>(call_data, 2))) {
        return 0;
    }
    if (!script->BindRetainedTextArena(*memory, std::span(stack, 0x40))) {
        script->DeleteProgram();
        return false;
    }
    script->ext_func(ext_func, 0x100);
    return 1;
}

/**
 * External effect script handlers in command-table order.
 */
static RS_EXTFUNC_INFO ext_func_info[129] = {
    {dc2::script::AdaptRunArguments<_ZERO_VECTOR>,            EFF_EXT_ZERO_VECTOR           },
    {dc2::script::AdaptRunArguments<_NORMAL_VECTOR>,          EFF_EXT_NORMAL_VECTOR         },
    {dc2::script::AdaptRunArguments<_COPY_VECTOR>,            EFF_EXT_COPY_VECTOR           },
    {dc2::script::AdaptRunArguments<_ADD_VECTOR>,             EFF_EXT_ADD_VECTOR            },
    {dc2::script::AdaptRunArguments<_SUB_VECTOR>,             EFF_EXT_SUB_VECTOR            },
    {dc2::script::AdaptRunArguments<_SCALE_VECTOR>,           EFF_EXT_SCALE_VECTOR          },
    {dc2::script::AdaptRunArguments<_DIV_VECTOR>,             EFF_EXT_DIV_VECTOR            },
    {dc2::script::AdaptRunArguments<_DIST_VECTOR>,            EFF_EXT_DIST_VECTOR           },
    {dc2::script::AdaptRunArguments<_DIST_VECTOR2>,           EFF_EXT_DIST_VECTOR2          },
    {dc2::script::AdaptRunArguments<_SQRT>,                   EFF_EXT_SQRT                  },
    {dc2::script::AdaptRunArguments<_ATAN2F>,                 EFF_EXT_ATAN2F                },
    {dc2::script::AdaptRunArguments<_ANGLE_CMP>,              EFF_EXT_ANGLE_CMP             },
    {dc2::script::AdaptRunArguments<_ANGLE_LIMIT>,            EFF_EXT_ANGLE_LIMIT           },
    {dc2::script::AdaptRunArguments<_GET_RAND>,               EFF_EXT_GET_RAND              },
    {dc2::script::AdaptRunArguments<_GET_REF_ROT>,            EFF_EXT_GET_REF_ROT           },
    {dc2::script::AdaptRunArguments<_GET_DIR_VECTOR>,         EFF_EXT_GET_DIR_VECTOR        },
    {dc2::script::AdaptRunArguments<_SET_ORIGIN>,             EFF_EXT_SET_ORIGIN            },
    {dc2::script::AdaptRunArguments<_GET_ORIGIN>,             EFF_EXT_GET_ORIGIN            },
    {dc2::script::AdaptRunArguments<_AUTO_SET_OFFSET>,        EFF_EXT_AUTO_SET_OFFSET       },
    {dc2::script::AdaptRunArguments<_GET_WORK_VECT1>,         EFF_EXT_GET_WORK_VECT1        },
    {dc2::script::AdaptRunArguments<_GET_WORK_VECT2>,         EFF_EXT_GET_WORK_VECT2        },
    {dc2::script::AdaptRunArguments<_GET_TARGET_ID>,          EFF_EXT_GET_TARGET_ID         },
    {dc2::script::AdaptRunArguments<_GET_USER_ID>,            EFF_EXT_GET_USER_ID           },
    {dc2::script::AdaptRunArguments<_GET_VALUE>,              EFF_EXT_GET_VALUE             },
    {dc2::script::AdaptRunArguments<_SET_VALUE>,              EFF_EXT_SET_VALUE             },
    {dc2::script::AdaptRunArguments<_CHR_SET_SHOW>,           EFF_EXT_CHR_SET_SHOW          },
    {dc2::script::AdaptRunArguments<_CHR_GET_SHOW>,           EFF_EXT_CHR_GET_SHOW          },
    {dc2::script::AdaptRunArguments<_CHR_SET_POS>,            EFF_EXT_CHR_SET_POS           },
    {dc2::script::AdaptRunArguments<_CHR_GET_POS>,            EFF_EXT_CHR_GET_POS           },
    {dc2::script::AdaptRunArguments<_CHR_SET_ROT>,            EFF_EXT_CHR_SET_ROT           },
    {dc2::script::AdaptRunArguments<_CHR_GET_ROT>,            EFF_EXT_CHR_GET_ROT           },
    {dc2::script::AdaptRunArguments<_CHR_SET_SCALE>,          EFF_EXT_CHR_SET_SCALE         },
    {dc2::script::AdaptRunArguments<_CHR_GET_SCALE>,          EFF_EXT_CHR_GET_SCALE         },
    {dc2::script::AdaptRunArguments<_CHR_SET_MOTION>,         EFF_EXT_CHR_SET_MOTION        },
    {dc2::script::AdaptRunArguments<_CHR_SET_MOT_STEP>,       EFF_EXT_CHR_SET_MOT_STEP      },
    {dc2::script::AdaptRunArguments<_CHR_GET_DIR_VECTOR>,     EFF_EXT_CHR_GET_DIR_VECTOR    },
    {dc2::script::AdaptRunArguments<_CHR_GET_REF_ROT>,        EFF_EXT_CHR_GET_REF_ROT       },
    {dc2::script::AdaptRunArguments<_CHR_ADD_POS>,            EFF_EXT_CHR_ADD_POS           },
    {dc2::script::AdaptRunArguments<_CHR_ADD_ROT>,            EFF_EXT_CHR_ADD_ROT           },
    {dc2::script::AdaptRunArguments<_CHR_ADD_SCALE>,          EFF_EXT_CHR_ADD_SCALE         },
    {dc2::script::AdaptRunArguments<_CHR_COPY_CHARA>,         EFF_EXT_CHR_COPY_CHARA        },
    {dc2::script::AdaptRunArguments<_CHR_SET_POS2>,           EFF_EXT_CHR_SET_POS2          },
    {dc2::script::AdaptRunArguments<_CHR_SET_ROT2>,           EFF_EXT_CHR_SET_ROT2          },
    {dc2::script::AdaptRunArguments<_CHR_SET_SCALE2>,         EFF_EXT_CHR_SET_SCALE2        },
    {dc2::script::AdaptRunArguments<_CHR_SET_MOTION2>,        EFF_EXT_CHR_SET_MOTION2       },
    {dc2::script::AdaptRunArguments<_CHR_ADD_POS2>,           EFF_EXT_CHR_ADD_POS2          },
    {dc2::script::AdaptRunArguments<_CHR_ADD_ROT2>,           EFF_EXT_CHR_ADD_ROT2          },
    {dc2::script::AdaptRunArguments<_CHR_ADD_SCALE2>,         EFF_EXT_CHR_ADD_SCALE2        },
    {dc2::script::AdaptRunArguments<_CHR_GET_MOT_WAIT>,       EFF_EXT_CHR_GET_MOT_WAIT      },
    {dc2::script::AdaptRunArguments<_CHR_SET_SHOW2>,          EFF_EXT_CHR_SET_SHOW2         },
    {dc2::script::AdaptRunArguments<_CHR_GET_FRAME_POS>,      EFF_EXT_CHR_GET_FRAME_POS     },
    {dc2::script::AdaptRunArguments<_CHR_SET_FRAME_SHOW>,     EFF_EXT_CHR_SET_FRAME_SHOW    },
    {dc2::script::AdaptRunArguments<_CHR_CHK_MOT_END>,        EFF_EXT_CHR_CHK_MOT_END       },
    {dc2::script::AdaptRunArguments<_CHR_SET_LIGHT_COLOR>,    EFF_EXT_CHR_SET_LIGHT_COLOR   },
    {dc2::script::AdaptRunArguments<_SPT_ASSIGN_SPRITE>,      EFF_EXT_SPT_ASSIGN_SPRITE     },
    {dc2::script::AdaptRunArguments<_SPT_DELETE_SPRITE>,      EFF_EXT_SPT_DELETE_SPRITE     },
    {dc2::script::AdaptRunArguments<_SPT_SET_TEXNAME>,        EFF_EXT_SPT_SET_TEXNAME       },
    {dc2::script::AdaptRunArguments<_SPT_SET_ALPHAB>,         EFF_EXT_SPT_SET_ALPHAB        },
    {dc2::script::AdaptRunArguments<_SPT_INIT_SPRITE>,        EFF_EXT_SPT_INIT_SPRITE       },
    {dc2::script::AdaptRunArguments<_SPT_SET_UV_SIZE>,        EFF_EXT_SPT_SET_UV_SIZE       },
    {dc2::script::AdaptRunArguments<_SPT_SET_PUT_SIZE>,       EFF_EXT_SPT_SET_PUT_SIZE      },
    {dc2::script::AdaptRunArguments<_SPT_SET_DRAW_FLAG>,      EFF_EXT_SPT_SET_DRAW_FLAG     },
    {dc2::script::AdaptRunArguments<_SPT_GET_DRAW_FLAG>,      EFF_EXT_SPT_GET_DRAW_FLAG     },
    {dc2::script::AdaptRunArguments<_SPT_SET_POS>,            EFF_EXT_SPT_SET_POS           },
    {dc2::script::AdaptRunArguments<_SPT_GET_POS>,            EFF_EXT_SPT_GET_POS           },
    {dc2::script::AdaptRunArguments<_SPT_SET_ROTZ>,           EFF_EXT_SPT_SET_ROTZ          },
    {dc2::script::AdaptRunArguments<_SPT_GET_ROTZ>,           EFF_EXT_SPT_GET_ROTZ          },
    {dc2::script::AdaptRunArguments<_SPT_SET_SCALE>,          EFF_EXT_SPT_SET_SCALE         },
    {dc2::script::AdaptRunArguments<_SPT_GET_SCALE>,          EFF_EXT_SPT_GET_SCALE         },
    {dc2::script::AdaptRunArguments<_SPT_SET_COLOR>,          EFF_EXT_SPT_SET_COLOR         },
    {dc2::script::AdaptRunArguments<_SPT_GET_COLOR>,          EFF_EXT_SPT_GET_COLOR         },
    {dc2::script::AdaptRunArguments<_SPT_VAN_SET_POS>,        EFF_EXT_SPT_VAN_SET_POS       },
    {dc2::script::AdaptRunArguments<_SPT_VAN_SET_ROT>,        EFF_EXT_SPT_VAN_SET_ROT       },
    {dc2::script::AdaptRunArguments<_SPT_ADD_POS>,            EFF_EXT_SPT_ADD_POS           },
    {dc2::script::AdaptRunArguments<_SPT_ADD_ROTZ>,           EFF_EXT_SPT_ADD_ROTZ          },
    {dc2::script::AdaptRunArguments<_SPT_ADD_COLOR>,          EFF_EXT_SPT_ADD_COLOR         },
    {dc2::script::AdaptRunArguments<_SPT_WORLD_ROT>,          EFF_EXT_SPT_WORLD_ROT         },
    {dc2::script::AdaptRunArguments<_SPT_SET_LIFE>,           EFF_EXT_SPT_SET_LIFE          },
    {dc2::script::AdaptRunArguments<_SPT_SET_VELO_POS>,       EFF_EXT_SPT_SET_VELO_POS      },
    {dc2::script::AdaptRunArguments<_SPT_SET_ACC_POS>,        EFF_EXT_SPT_SET_ACC_POS       },
    {dc2::script::AdaptRunArguments<_SPT_SET_VELO_ROTZ>,      EFF_EXT_SPT_SET_VELO_ROTZ     },
    {dc2::script::AdaptRunArguments<_SPT_SET_ACC_ROTZ>,       EFF_EXT_SPT_SET_ACC_ROTZ      },
    {dc2::script::AdaptRunArguments<_SPT_SET_VELO_COL>,       EFF_EXT_SPT_SET_VELO_COL      },
    {dc2::script::AdaptRunArguments<_SPT_SET_ACC_COL>,        EFF_EXT_SPT_SET_ACC_COL       },
    {dc2::script::AdaptRunArguments<_SPT_SET_BLINKING>,       EFF_EXT_SPT_SET_BLINKING      },
    {dc2::script::AdaptRunArguments<_SPT_VAN_SET_COL>,        EFF_EXT_SPT_VAN_SET_COL       },
    {dc2::script::AdaptRunArguments<_SPT_SET_VELO_SCL>,       EFF_EXT_SPT_SET_VELO_SCL      },
    {dc2::script::AdaptRunArguments<_SPT_SET_ACC_SCL>,        EFF_EXT_SPT_SET_ACC_SCL       },
    {dc2::script::AdaptRunArguments<_SPT_VAN_SET_SCL>,        EFF_EXT_SPT_VAN_SET_SCL       },
    {dc2::script::AdaptRunArguments<_SPT_SCALE_CONV>,         EFF_EXT_SPT_SCALE_CONV        },
    {dc2::script::AdaptRunArguments<_SPT_COLOR_CONV>,         EFF_EXT_SPT_COLOR_CONV        },
    {dc2::script::AdaptRunArguments<_SCN_GET_CHR_POS>,        EFF_EXT_SCN_GET_CHR_POS       },
    {dc2::script::AdaptRunArguments<_SCN_GET_CHR_ROT>,        EFF_EXT_SCN_GET_CHR_ROT       },
    {dc2::script::AdaptRunArguments<_SCN_GET_CHR_FRM_POS>,    EFF_EXT_SCN_GET_CHR_FRM_POS   },
    {dc2::script::AdaptRunArguments<_INTERSECTION_POINT>,     EFF_EXT_INTERSECTION_POINT    },
    {dc2::script::AdaptRunArguments<_MON_SE_PLAY>,            EFF_EXT_MON_SE_PLAY           },
    {dc2::script::AdaptRunArguments<_MON_SE_STOP>,            EFF_EXT_MON_SE_STOP           },
    {dc2::script::AdaptRunArguments<_BTL_SE_PLAY>,            EFF_EXT_BTL_SE_PLAY           },
    {dc2::script::AdaptRunArguments<_BTL_SE_STOP>,            EFF_EXT_BTL_SE_STOP           },
    {dc2::script::AdaptRunArguments<_BSE_SE_PLAY>,            EFF_EXT_BSE_SE_PLAY           },
    {dc2::script::AdaptRunArguments<_BSE_SE_STOP>,            EFF_EXT_BSE_SE_STOP           },
    {dc2::script::AdaptRunArguments<_MON_SE_PLAY2>,           EFF_EXT_MON_SE_PLAY2          },
    {dc2::script::AdaptRunArguments<_MON_SE_STOP2>,           EFF_EXT_MON_SE_STOP2          },
    {dc2::script::AdaptRunArguments<_SET_LIGHT_FLAG>,         EFF_EXT_SET_LIGHT_FLAG        },
    {dc2::script::AdaptRunArguments<_SCN_GET_CHR_ENTOBJ_POS>, EFF_EXT_SCN_GET_CHR_ENTOBJ_POS},
    {dc2::script::AdaptRunArguments<_SCN_GET_CHR_FRM_DIR>,    EFF_EXT_SCN_GET_CHR_FRM_DIR   },
    {dc2::script::AdaptRunArguments<_SCN_GET_CHR_FRM_ROT>,    EFF_EXT_SCN_GET_CHR_FRM_ROT   },
    {dc2::script::AdaptRunArguments<_SCN_GET_ENTRY_OBJ_POS>,  EFF_EXT_SCN_GET_ENTRY_OBJ_POS },
    {dc2::script::AdaptRunArguments<_CREATE_DAMAGE>,          EFF_EXT_CREATE_DAMAGE         },
    {dc2::script::AdaptRunArguments<_DELETE_DAMAGE>,          EFF_EXT_DELETE_DAMAGE         },
    {dc2::script::AdaptRunArguments<_DMG_SET_POS>,            EFF_EXT_DMG_SET_POS           },
    {dc2::script::AdaptRunArguments<_DMG_SET_FRONT_VECT>,     EFF_EXT_DMG_SET_FRONT_VECT    },
    {dc2::script::AdaptRunArguments<_DMG_SET_DAMAGE>,         EFF_EXT_DMG_SET_DAMAGE        },
    {dc2::script::AdaptRunArguments<_COLPRIM_CREATE>,         EFF_EXT_COLPRIM_CREATE        },
    {dc2::script::AdaptRunArguments<_COLPRIM_SET_COORD>,      EFF_EXT_COLPRIM_SET_COORD     },
    {dc2::script::AdaptRunArguments<_COLPRIM_DELETE>,         EFF_EXT_COLPRIM_DELETE        },
    {dc2::script::AdaptRunArguments<_COLPRIM_GET_HITCNT>,     EFF_EXT_COLPRIM_GET_HITCNT    },
    {dc2::script::AdaptRunArguments<_COLPRIM_SET_DAMAGE>,     EFF_EXT_COLPRIM_SET_DAMAGE    },
    {dc2::script::AdaptRunArguments<_COLPRIM_GET_HIT_POS>,    EFF_EXT_COLPRIM_GET_HIT_POS   },
    {dc2::script::AdaptRunArguments<_COLPRIM_GET_GIFT>,       EFF_EXT_COLPRIM_GET_GIFT      },
    {dc2::script::AdaptRunArguments<_COLPRIM_GET_REVCNT>,     EFF_EXT_COLPRIM_GET_REVCNT    },
    {dc2::script::AdaptRunArguments<_ES_CREATE>,              EFF_EXT_ES_CREATE             },
    {dc2::script::AdaptRunArguments<_ES_SET_VECT1>,           EFF_EXT_ES_SET_VECT1          },
    {dc2::script::AdaptRunArguments<_ES_SET_VECT2>,           EFF_EXT_ES_SET_VECT2          },
    {dc2::script::AdaptRunArguments<_ES_SET_TARGET_ID>,       EFF_EXT_ES_SET_TARGET_ID      },
    {dc2::script::AdaptRunArguments<_ES_SET_COLPRIM>,         EFF_EXT_ES_SET_COLPRIM        },
    {dc2::script::AdaptRunArguments<_ES_SET_VALUE>,           EFF_EXT_ES_SET_VALUE          },
    {dc2::script::AdaptRunArguments<_GET_EOH_POS>,            EFF_EXT_GET_EOH_POS           },
    {nullptr,                                                 EFF_EXT_END                   },
};

/**
 *
 * Builds the effect script external function table.
 *
 */
void SetEffectScriptFunc() {
    int function_index = {};
    int previous_index = {};

    for (function_index = 0; function_index < 256; function_index++) {
        ext_func[function_index] = nullptr;
    }

    for (function_index = 0;; function_index++) {
        if (ext_func_info[function_index].func == nullptr) {
            break;
        }

        if (0 < function_index) {
            previous_index = 0;

            do {
                if (ext_func_info[function_index].no == ext_func_info[previous_index].no) {
                    dc2::log::PrintGame("dng_effect same ext_func_no!!![%d]\n", ext_func_info[previous_index].no);

                    while (1) {
                    }
                }

                previous_index++;
            } while (previous_index < function_index);
        }

        if (ext_func_info[function_index].no < 0 || ext_func_info[function_index].no >= 256) {
            dc2::log::PrintGame("dng_effect ext func over!!\n");
        } else {
            ext_func[ext_func_info[function_index].no] = ext_func_info[function_index].func;
        }
    }
}

CScene *now_scene;

CEffectScriptMan *EffScriptMan;

void CEffectScriptMan::InitializeEffectSlots(mgCMemory *memory, int texb_start, int texb_num) {
    int                i = {};
    int                j = {};
    mgCTextureManager *manager = {};
    int                bank = {};

    this->memory = memory;
    load_buffer = nullptr;
    work_memory = nullptr;
    level = 0;

    for (i = 0; i < EFF_SPT_BASE_MAX; i++) {
        base[i] = nullptr;
    }

    base_num = 0;

    for (i = 0; i < EFF_SPT_OWNER_MAX; i++) {
        for (j = 0; j < EFF_SPT_OWNER_SLOT_MAX; j++) {
            slot[i][j] = nullptr;
        }
    }

    now = nullptr;
    this->texb_start = texb_start;
    this->texb_num = texb_num;
    texb_used = 0;
    tail = nullptr;
    head = nullptr;
    now_scene = GetMainScene();
    SetEffectScriptFunc();
    level_texb_used[0] = 0;
    level_texb_used[1] = 0;
    level_texb_used[2] = 0;
    level_texb_used[3] = 0;
    manager = &mgTexManager;

    for (bank = this->texb_start; bank < this->texb_start + this->texb_num; bank++) {
        manager->DeleteBlock(bank);
    }
}

void CEffectScriptMan::UnlinkEffectScript(_EFF_SCRIPT *script) {
    if (script == nullptr || work_memory == nullptr) {
        return;
    }

    if (script->prev != nullptr) {
        script->prev->next = script->next;
    } else {
        head = script->next;

        if (head != nullptr) {
            head->prev = nullptr;
        }
    }

    if (script->next != nullptr) {
        script->next->prev = script->prev;
    } else {
        tail = script->prev;

        if (tail != nullptr) {
            tail->next = nullptr;
        }
    }

    if (now != nullptr && script->work == now->work) {
        now = nullptr;
    }

    if (script->slot >= 0) {
        slot[script->user_id][script->slot] = nullptr;
    }

    if (script->colprim != nullptr) {
        script->colprim->Delete(script->user_id);
    }

    DeleteSprite(script->sprite);

    if (script->sub_chara_work != nullptr) {
        work_memory->Free(script->sub_chara_work);
    }

    if (script->chara_work != nullptr) {
        work_memory->Free(script->chara_work);
    }

    script->run.DeleteProgram();
    work_memory->Free(script->work);
}

namespace {
int AssignSpriteCore(dc2::script::RunArguments stack, int argument_count) {
    if (argument_count != 1 && argument_count != 2) {
        return 0;
    }

    int count = GetStackInt(stack++);

    if (now_script->sprite != nullptr) {
        return 0;
    }

    _ES_SPRITE *sprite = EffScriptMan->AssignSprite(count);

    if (sprite == nullptr) {
        if (argument_count >= 2) {
            SetStack(stack, 0);
        }

        return 0;
    }

    if (argument_count >= 2) {
        SetStack(stack, 1);
    }

    now_script->sprite = sprite;
    now_script->sprite_num = count;
    return 1;
}

int InitSpriteCore(dc2::script::RunArguments stack, int argument_count) {
    int         first = {};
    int         count = {};
    int         i = {};
    _ES_SPRITE *sprite = {};

    count = 1;
    first = GetStackInt(stack++);

    if (argument_count >= 2) {
        count = GetStackInt(stack);
    }

    if (!ValidSpriteRange(now_script, first, count)) {
        return 0;
    }

    for (i = first; i < count + first; i++) {
        sprite = GetSpritePtr(now_script, i);

        if (sprite == nullptr) {
            return 0;
        }

        sprite->draw_flag = 0;
        sprite->alpha = 1;
        sprite->pos[0] = 0;
        sprite->pos[1] = 0;
        sprite->pos[2] = 0;
        sprite->pos[3] = 1.0f;
        sprite->uv[0] = 0;
        sprite->uv[1] = 0;
        sprite->uv[2] = 0;
        sprite->uv[3] = 0;
        sprite->color[0] = 128.0f;
        sprite->color[1] = 128.0f;
        sprite->color[2] = 128.0f;
        sprite->color[3] = 128.0f;
        sprite->scale[1] = 1.0f;
        sprite->scale[0] = 1.0f;
        sprite->put_size[1] = 0;
        sprite->put_size[0] = 0;
        sprite->rotz = 0;
        sprite->velo_pos[0] = 0;
        sprite->velo_pos[1] = 0;
        sprite->velo_pos[2] = 0;
        sprite->velo_pos[3] = 0;
        sprite->acc_pos[0] = 0;
        sprite->acc_pos[1] = 0;
        sprite->acc_pos[2] = 0;
        sprite->acc_pos[3] = 0;
        sprite->velo_col[0] = 0;
        sprite->velo_col[1] = 0;
        sprite->velo_col[2] = 0;
        sprite->velo_col[3] = 0;
        sprite->acc_col[0] = 0;
        sprite->acc_col[1] = 0;
        sprite->acc_col[2] = 0;
        sprite->acc_col[3] = 0;
        sprite->color_target[0] = 0;
        sprite->color_target[1] = 0;
        sprite->color_target[2] = 0;
        sprite->color_target[3] = 0;
        sprite->color_conv_div = -1.0f;
        sprite->acc_rotz = 0;
        sprite->velo_rotz = 0;
        sprite->velo_scl[1] = 0;
        sprite->velo_scl[0] = 0;
        sprite->acc_scl[1] = 0;
        sprite->acc_scl[0] = 0;
        sprite->scale_target[1] = 0;
        sprite->scale_target[0] = 0;
        sprite->scale_conv_div = -1.0f;
        sprite->blink_amp[0] = 0;
        sprite->blink_amp[1] = 0;
        sprite->blink_amp[2] = 0;
        sprite->blink_amp[3] = 0;
        sprite->blink_speed = 0;
        sprite->blink_phase = 0;
    }

    return 1;
}
} // namespace

#include "common.h"
#include "mw_runtime.h"

#include <nlohmann/json.hpp>

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <limits>
#include <optional>
#include <print>
#include <span>
#include <string>
#include <unordered_map>
#include <vector>

#include "asset_directory.hpp"
#include "assets/data_registry.hpp"
#include "character.hpp"
#include "effscript.hpp"
#include "effscript_config_bridge.inc"
#include "log/log.hpp"
#include "luau_runtime.hpp"
#include "map.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_sprite.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/datapacks.hpp"
#include "platform/model_assets.hpp"
#include "platform/vfs.hpp"
#include "render/renderer.hpp"
#include "render/sprite_batch.hpp"
#include "render/texture_runtime.hpp"
#include "scenesnd.hpp"
#include "script/effect_script_runtime.hpp"

// The effect whose script is running (port/src/effscript_config_bridge.inc).
_EFF_SCRIPT *PortRunningEffect();

namespace {
constexpr int Quadwords(std::size_t bytes) {
    return static_cast<int>((bytes + 15) / 16);
}

/**
 * The sprite incarnations of a running recovery effect. A slot's incarnation is a serial that no sprite has had
 * before, renewed when the script assigns the effect's sprites or resets the slot, so a particle reset and shown again
 * in place between two game frames never blends from the one it replaced.
 */
struct RecoveryEffect {
    dc2::memory::ArenaBuffer script_anchor;     /**< Exact effect allocation authorizing access to its state. */
    const CEffectScriptMan  *manager = nullptr; /**< Manager that started the effect. */
    const _ES_SPRITE        *sprites = nullptr; /**< Sprites the incarnations number; null before any are assigned. */
    std::vector<uint64_t>    incarnations;      /**< One per sprite slot. */
};

/**
 *
 * Owns recovery-particle incarnations while their exact effect allocations remain live.
 *
 */
std::unordered_map<const _EFF_SCRIPT *, RecoveryEffect> &RecoveryEffects() {
    static std::unordered_map<const _EFF_SCRIPT *, RecoveryEffect> effects;
    std::erase_if(effects, [](const auto &entry) { return entry.second.script_anchor.Bytes().empty(); });
    return effects;
}

uint64_t next_incarnation = 0;

void Renumber(RecoveryEffect &effect, const _EFF_SCRIPT *script) {
    effect.sprites = script->sprite;
    effect.incarnations.resize(script->sprite != nullptr ? static_cast<std::size_t>(std::max(0, script->sprite_num)) : 0);
    for (uint64_t &incarnation : effect.incarnations) {
        incarnation = ++next_incarnation;
    }
}

// The effect's entry, its incarnations numbering its current sprites, or null for an effect that is not one.
RecoveryEffect *Recovery(const _EFF_SCRIPT *script) {
    const auto found = RecoveryEffects().find(script);
    if (found == RecoveryEffects().end()) {
        return nullptr;
    }
    RecoveryEffect &effect = found->second;
    const auto      count = static_cast<std::size_t>(script->sprite != nullptr ? std::max(0, script->sprite_num) : 0);
    if (effect.sprites != script->sprite || effect.incarnations.size() != count) {
        Renumber(effect, script);
    }
    return &effect;
}

/**
 * The recovery effect (the healing point, food and drink, Resurrection Powder, items used from the menu) and the
 * sparkles it starts. Their sprites drift, spin and fade while the effect follows its character.
 */
bool SpritesInterpolate(int base_no) {
    if (base_no < 0 || base_no >= EFF_SPT_BASE_DEF_NUM) {
        return false;
    }
    const char *script = eff_spt_base_def[base_no].script;
    return std::strcmp(script, "n_heal") == 0 || std::strcmp(script, "n_heal_sub") == 0;
}
} // namespace

int CEffectScriptMan::AssignCharacter(_EFF_SCRIPT *script, int count) {
    if (count < 0 || count > EFF_SPT_SUB_CHARA_MAX || script == nullptr ||
        script->chara == nullptr || work_memory == nullptr || work_memory->lock != 0) {
        return 0;
    }
    const int object_size = Quadwords(sizeof(CCharacter2));
    // The allocator picks its gap before placement new runs, so native objects are budgeted up front,
    // with room for the final 64-byte alignment and the strict end-of-stack check.
    const long long required = count * (static_cast<long long>(object_size) +
                                        std::max(0, script->chara->GetCopySize())) +
                               4;
    if (required > std::numeric_limits<int>::max()) {
        std::println("------- es work max!! (assign character[{}]) ---------", required);
        return 0;
    }
    u_long128 *token = work_memory->StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(required));
    if (token == nullptr) {
        std::println("------- es work max!! (assign character[{}]) ---------", required);
        return 0;
    }
    std::array<CCharacter2 *, EFF_SPT_SUB_CHARA_MAX> characters{};
    for (int i = 0; i < count; ++i) {
        auto *storage = work_memory->Alloc(object_size);
        if (storage == nullptr) {
            work_memory->EndStackMode();
            work_memory->Free(token);
            return 0;
        }
        characters[static_cast<std::size_t>(i)] = new (storage) CCharacter2;
        if (!script->chara->Copy(*characters[static_cast<std::size_t>(i)], work_memory)) {
            work_memory->EndStackMode();
            work_memory->Free(token);
            return 0;
        }
    }
    std::copy_n(characters.begin(), count, script->sub_chara);
    script->sub_chara_work = token;
    work_memory->stAlign64();
    work_memory->EndStackMode();
    return 1;
}

_EFF_SCRIPT *CEffectScriptMan::CreateEffSpt(int base_no, int group, int register_in_group) {
    if (base_num <= 0) {
        std::println("--- effect script (non base)!!! ---");
        return nullptr;
    }
    EFF_SPT_BASE *definition = nullptr;
    for (auto *candidate : base) {
        if (candidate != nullptr && candidate->base_no == base_no) {
            definition = candidate;
            break;
        }
    }
    if (definition == nullptr || work_memory == nullptr || work_memory->lock != 0) {
        now = nullptr;
        std::println("--- effect script (missing base or work stack)!!! ---");
        return nullptr;
    }

    int owner_slot = -1;
    if (register_in_group == 1) {
        if (group < 0 || group >= EFF_SPT_OWNER_MAX) {
            return nullptr;
        }
        for (int i = 0; i < EFF_SPT_OWNER_SLOT_MAX; ++i) {
            if (slot[group][i] == nullptr) {
                owner_slot = i;
                break;
            }
        }
        if (owner_slot < 0) {
            now = nullptr;
            std::println("--- effect script (ent_tbl max)!!! ---");
            return nullptr;
        }
    }

    // The copy size covers native frame and model allocations; add the effect and character objects,
    // interpreter arrays and final 64-byte alignment.
    long long required = Quadwords(sizeof(_EFF_SCRIPT)) + 2 + Quadwords(64 * sizeof(RS_STACKDATA)) +
                         Quadwords(2 * sizeof(RS_CALLDATA)) + 4;
    if (definition->chara != nullptr) {
        required += Quadwords(sizeof(CCharacter2)) + 2 + std::max(0, definition->chara->GetCopySize());
    }
    if (required > std::numeric_limits<int>::max()) {
        return nullptr;
    }
    definition->work_size = static_cast<int>(required);
    u_long128 *token = work_memory->StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(required));
    if (token == nullptr) {
        now = nullptr;
        std::println("--- effect script work max[{}]!!! ---", work_memory->stack_size - work_memory->stack_used);
        return nullptr;
    }

    auto *storage = work_memory->Alloc(Quadwords(sizeof(_EFF_SCRIPT)) + 2);
    if (storage == nullptr) {
        work_memory->EndStackMode();
        work_memory->Free(token);
        return nullptr;
    }
    static_assert(std::is_trivially_destructible_v<_EFF_SCRIPT>);
    auto *effect = new (storage) _EFF_SCRIPT{};
    effect->work = token;
    effect->texb = definition->texb;
    effect->level = definition->level;
    if (definition->chara != nullptr) {
        auto *character_storage = work_memory->Alloc(Quadwords(sizeof(CCharacter2)) + 2);
        if (character_storage == nullptr) {
            work_memory->EndStackMode();
            work_memory->Free(token);
            return nullptr;
        }
        effect->chara = new (character_storage) CCharacter2;
        effect->chara->Initialize();
        if (!definition->chara->Copy(*effect->chara, work_memory)) {
            work_memory->EndStackMode();
            work_memory->Free(token);
            return nullptr;
        }
        effect->chara->SetPosition(0.0f, -10000.0f, 0.0f);
        effect->chara->SetRotation(0.0f, 0.0f, 0.0f);
    }
    if (!SetEffectScript(&effect->run,
                         {reinterpret_cast<u8 *>(definition->script), definition->script_size}, work_memory)) {
        work_memory->EndStackMode();
        work_memory->Free(token);
        return nullptr;
    }
    effect->prog_no = static_cast<int>(EffectScriptProgram::Start);
    effect->user_id = group;
    effect->slot = owner_slot;
    effect->work_vect1[3] = effect->work_vect2[3] = 1.0f;
    effect->target_id = -1;
    work_memory->stAlign64();
    work_memory->EndStackMode();

    if (register_in_group == 1) {
        slot[group][owner_slot] = effect;
    }
    if (SpritesInterpolate(base_no)) {
        RecoveryEffects()[effect] = {
            .script_anchor = dc2::memory::ArenaBuffer::Bind(*work_memory,
                                                            {reinterpret_cast<u8 *>(effect), sizeof(*effect)}),
            .manager = this};
    } else {
        RecoveryEffects().erase(effect);
    }
    _EFF_SCRIPT *previous = nullptr;
    _EFF_SCRIPT *following = head;
    while (following != nullptr && following->texb <= effect->texb) {
        previous = following;
        following = following->next;
    }
    effect->prev = previous;
    effect->next = following;
    if (previous != nullptr) {
        previous->next = effect;
    } else {
        head = effect;
    }
    if (following != nullptr) {
        following->prev = effect;
    } else {
        tail = effect;
    }
    now = effect;
    return effect;
}

namespace {
/**
 * Selects a bounded retail effect definition without interpreting a resource archive.
 */
const EFF_SPT_BASE_DEF *EffectDefinition(int base_no) {
    return base_no >= 0 && base_no < EFF_SPT_BASE_DEF_NUM && eff_spt_base_def[base_no].name[0] ? &eff_spt_base_def[base_no] : nullptr;
}

/**
 * Describes the direct model or texture resource used by one effect base.
 */
struct EffectResource {
    std::string                model;       /**< Character glTF path, or empty for an unmodeled effect. */
    std::string                texture;     /**< Standalone texture JSON path. */
    std::string                bundle;      /**< glTF path containing an embedded texture set. */
    std::optional<std::size_t> texture_set; /**< Embedded set selected by its retained texture name. */
};

/**
 * Returns the handle of the Luau module of one directly named effect script, or nothing when it has none.
 */
std::vector<unsigned char> EffectScript(const std::string &path) {
    const auto module = luau_runtime::ModuleForScript(vfs::FoldKey(path));
    if (!module) {
        return {};
    }
    const std::string handle = luau_runtime::MakeHandle(*module);
    return {handle.begin(), handle.end()};
}

/**
 * Builds a native effect base from explicit standard resources and bounded VM bytes.
 */
int BuildNativeEffect(CEffectScriptMan &manager, int base_no, const EffectResource &resource,
                      std::span<const unsigned char> script, mgCMemory *work, int requested_block) {
    auto       *memory = work ? work : manager.memory;
    const auto *definition = EffectDefinition(base_no);
    if (!memory || !definition || script.empty() || !dc2::memory::ArrayQuadwords<u8>(script.size())) {
        return -1;
    }
    int index = -1;
    for (int candidate = 0; candidate < EFF_SPT_BASE_MAX; ++candidate) {
        if (manager.base[candidate] && manager.base[candidate]->base_no == base_no) {
            return 0;
        }
        if (!manager.base[candidate] && index < 0) {
            index = candidate;
        }
    }
    const int block = requested_block < 0 ? manager.texb_start + manager.texb_used : requested_block;
    if (index < 0 || (requested_block < 0 && manager.texb_used >= manager.texb_num) ||
        block < manager.texb_start || block >= manager.texb_start + manager.texb_num) {
        return -1;
    }
    memory->stSetLocked(false);
    memory->Align64();
    auto *storage = memory->Alloc(Quadwords(sizeof(EFF_SPT_BASE)) + 2);
    if (storage == nullptr) {
        return -1;
    }
    static_assert(std::is_trivially_destructible_v<EFF_SPT_BASE>);
    auto *base = new (storage) EFF_SPT_BASE{};
    base->base_no = base_no;
    base->work_size = 0x7D + 0x24;
    base->texb = block;
    base->level = manager.level;
    bool owns_block = false;
    if (definition->type == EFF_SPT_BASE_CHR && !resource.model.empty()) {
        auto *source = manager.GetBaseChara(base_no);
        auto *character_storage = memory->Alloc(Quadwords(sizeof(CCharacter2)) + 2);
        if (character_storage == nullptr) {
            return -1;
        }
        base->chara = new (character_storage) CCharacter2;
        base->chara->Initialize();
        if (source) {
            if (!source->Copy(*base->chara, memory)) {
                return -1;
            }
            base->texb = source->texture_block;
        } else {
            if (requested_block < 0) {
                mgTexManager.DeleteBlock(block);
            }
            model_assets::CharacterLoadOptions options{.model_memory = memory, .motion_memory = memory, .image_memory = memory, .textures = &mgTexManager, .parent = nullptr, .texture_block = block, .outline = false};
            std::string                        error;
            if (!model_assets::LoadCharacter(*base->chara, resource.model, "info", options, error)) {
                CT_LOG_ERROR(Data, "effect model: {}", error);
                return -1;
            }
            owns_block = requested_block < 0;
        }
        base->work_size += base->chara->GetCopySize();
    } else if (definition->type == EFF_SPT_BASE_IMG) {
        auto *texture = mgTexManager.GetTexture(const_cast<char *>(definition->file), -1);
        if (texture) {
            base->texb = texture->block;
        } else {
            if (requested_block < 0) {
                mgTexManager.DeleteBlock(block);
            }
            bool loaded = false;
            if (resource.texture_set) {
                std::string error;
                loaded = model_assets::LoadTextureSet(resource.bundle, *resource.texture_set, mgTexManager, block, *memory, error);
                if (!loaded) {
                    CT_LOG_ERROR(Data, "effect texture: {}", error);
                }
            } else if (!resource.texture.empty()) {
                MgTextureEnterDocument(&mgTexManager, resource.texture, block, memory, nullptr);
                loaded = mgTexManager.GetTexture(const_cast<char *>(definition->file), block) != nullptr;
            }
            if (!loaded) {
                return -1;
            }
            owns_block = requested_block < 0;
        }
    }
    base->script = reinterpret_cast<char *>(memory->stAlloc64(Quadwords(script.size()) + 1));
    if (!base->script) {
        return -1;
    }
    std::memcpy(base->script, script.data(), script.size());
    base->script_size = script.size();
    if (owns_block) {
        manager.texb_used++;
        base->texb_owned = 1;
    }
    manager.base[index] = base;
    manager.base_num++;
    return 1;
}

/**
 * Selects the embedded set containing the effect's actual texture name.
 */
std::optional<std::size_t> EffectTextureSet(const std::string &bundle, const char *name) {
    std::string error;
    const auto  game = model_assets::ReadGameplay(bundle, error);
    if (!game) {
        return std::nullopt;
    }
    const auto resource_fields = game->find("resources");
    if (resource_fields == game->end() || !resource_fields->is_object()) {
        return std::nullopt;
    }
    const auto &resources = *resource_fields;
    const auto  found = resources.find("texture_sets");
    if (found == resources.end() || !found->is_array()) {
        return std::nullopt;
    }
    const auto &sets = *found;
    for (std::size_t index = 0; index < sets.size(); ++index) {
        if (!sets[index].is_object() || !sets[index].contains("document") || !sets[index]["document"].is_object()) {
            continue;
        }
        const auto &document = sets[index]["document"];
        const auto  entries = document.find("entries");
        if (entries == document.end() || !entries->is_array()) {
            continue;
        }
        for (const auto &entry : *entries) {
            if (entry.is_object() && entry.contains("name") && entry["name"].is_string() && entry["name"] == name) {
                return index;
            }
        }
    }
    return std::nullopt;
}
} // namespace

int CEffectScriptMan::BuildPack(int base_no, u_int *pack, mgCMemory *memory, int texture_block) {
    const auto *definition = EffectDefinition(base_no);
    const auto  path = DataReadBufferPath(pack);
    if (!definition || !path) {
        return -1;
    }
    EffectResource        resource;
    std::filesystem::path directory;
    if (std::filesystem::path(*path).extension() == ".gltf") {
        directory = std::filesystem::path(*path).replace_extension(".assets");
        if (definition->type == EFF_SPT_BASE_IMG) {
            resource.bundle = *path;
            resource.texture_set = EffectTextureSet(*path, definition->file);
        }
    } else if (const auto parent = AssetDirectoryPath(pack)) {
        directory = *parent;
        if (definition->type == EFF_SPT_BASE_IMG) {
            const auto name = std::string(definition->file) + ".json";
            if (const auto *texture = AssetDirectoryRead(pack, name.c_str(), nullptr)) {
                resource.texture = DataReadBufferPath(texture).value_or(std::string{});
            }
        }
    } else {
        return -1;
    }
    if (definition->type == EFF_SPT_BASE_CHR && definition->file[0]) {
        const auto model = (directory / (std::string(definition->file) + ".gltf")).generic_string();
        if (!datapacks::Candidates(model).empty()) {
            resource.model = model;
        }
    }
    const auto script = EffectScript((directory / (std::string(definition->script) + ".stb")).generic_string());
    return BuildNativeEffect(*this, base_no, resource, script, memory, texture_block);
}

int CEffectScriptMan::LoadBaseEffSpt(int base_no, mgCMemory *memory, int texture_block) {
    const auto *definition = EffectDefinition(base_no);
    if (!definition) {
        return -1;
    }
    for (const auto *entry : base) {
        if (entry && entry->base_no == base_no) {
            return 0;
        }
    }
    EffectResource resource;
    if (definition->type == EFF_SPT_BASE_CHR && definition->file[0]) {
        const auto model = "dungeon/eff_script/" + std::string(definition->file) + ".gltf";
        if (!datapacks::Candidates(model).empty()) {
            resource.model = model;
        }
    } else if (definition->type == EFF_SPT_BASE_IMG) {
        resource.texture = "textures/dungeon/eff_script/" + std::string(definition->file) + ".json";
    }
    const auto script = EffectScript("dungeon/eff_script/" + std::string(definition->script) + ".stb");
    return BuildNativeEffect(*this, base_no, resource, script, memory, texture_block);
}

int CEffectScriptMan::BuildBase(int base_no, u_long128 *data, int /*unused*/, u_long128 *script, int script_size, mgCMemory *memory, int texture_block) {
    const auto *definition = EffectDefinition(base_no);
    if (!definition || !script || script_size <= 0) {
        return -1;
    }
    EffectResource resource;
    if (const auto path = DataReadBufferPath(data)) {
        if (definition->type == EFF_SPT_BASE_CHR && std::filesystem::path(*path).extension() == ".gltf") {
            resource.model = *path;
        } else if (definition->type == EFF_SPT_BASE_IMG && std::filesystem::path(*path).extension() == ".json") {
            resource.texture = *path;
        } else {
            return -1;
        }
    } else if (data) {
        return -1;
    }
    return BuildNativeEffect(*this, base_no, resource,
                             {reinterpret_cast<const unsigned char *>(script), static_cast<std::size_t>(script_size)}, memory, texture_block);
}

int CEffectScriptMan::GetNeedFilePath(int base_no, std::span<char> resource, std::span<char> script) {
    const auto *definition = EffectDefinition(base_no);
    if (!definition || resource.empty() || script.empty()) {
        return 0;
    }

    const std::string_view file_name = dc2::text::View(definition->file);
    const std::string_view script_name = dc2::text::View(definition->script);
    if (file_name.empty() || file_name.size() == sizeof definition->file ||
        dc2::text::Fit(file_name, file_name.size()) != file_name || script_name.empty() ||
        script_name.size() == sizeof definition->script || dc2::text::Fit(script_name, script_name.size()) != script_name) {
        return 0;
    }

    const std::string resource_path = std::string(definition->type == EFF_SPT_BASE_CHR ? "" : "textures/") +
                                      "dungeon/eff_script/" + std::string(file_name) +
                                      (definition->type == EFF_SPT_BASE_CHR ? ".gltf" : ".json");
    const std::string script_path = "dungeon/eff_script/" + std::string(script_name) + ".stb";
    if (!dc2::text::Fits(resource_path, resource.size()) || !dc2::text::Fits(script_path, script.size())) {
        return 0;
    }

    dc2::text::Copy(resource, resource_path);
    dc2::text::Copy(script, script_path);
    return 1;
}

gfx::Interp2D PortEffectSpriteTag(const _EFF_SCRIPT *script, int index) {
    const RecoveryEffect *effect = Recovery(script);
    if (effect == nullptr || index < 0 || static_cast<std::size_t>(index) >= effect->incarnations.size()) {
        return {};
    }
    return {.key = static_cast<gfx::InterpKey>(reinterpret_cast<uintptr_t>(&script->sprite[index])),
            .generation = effect->incarnations[static_cast<std::size_t>(index)],
            .world_corners = true,
            .teleport_distance = kMgPortFrameTeleportDistance};
}

std::size_t PortRecoveryEffectCount() {
    return RecoveryEffects().size();
}

// A new sprite array, even one allocated where the last was, numbers every slot afresh. A refused assignment (the
// effect already has sprites, or the work memory is full) changes nothing, so neither does it here.
int _SPT_ASSIGN_SPRITE(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    const int    result = AssignSpriteCore(stack, argument_count);
    _EFF_SCRIPT *script = PortRunningEffect();
    if (const auto found = RecoveryEffects().find(script); result != 0 && found != RecoveryEffects().end()) {
        Renumber(found->second, script);
    }
    return result;
}

// A reset slot receives a new particle identity after the complete range is validated.
int _SPT_INIT_SPRITE(dc2::script::RunArguments stack, int argument_count) {
    ValidateEffectOutputs(stack);
    const int       result = InitSpriteCore(stack, argument_count);
    RecoveryEffect *effect = Recovery(PortRunningEffect());
    if (result != 0 && effect != nullptr) {
        const int first = GetStackInt(stack);
        const int count = argument_count >= 2 ? GetStackInt(stack + 1) : 1;
        for (int i = first; i < first + count && i >= 0 && static_cast<std::size_t>(i) < effect->incarnations.size(); i++) {
            effect->incarnations[static_cast<std::size_t>(i)] = ++next_incarnation;
        }
    }
    return result;
}

// Every stop and clear of an effect comes here, so a stopped recovery effect leaves no entry.
void CEffectScriptMan::DeleteEffSpt(_EFF_SCRIPT *script) {
    RecoveryEffects().erase(script);
    UnlinkEffectScript(script);
}

// A reset manager has no effects: those it ran are gone with the arena or the mode that held them.
void CEffectScriptMan::Initialize(mgCMemory *memory, int texb_start, int texb_num) {
    std::erase_if(RecoveryEffects(), [this](const auto &entry) { return entry.second.manager == this; });
    InitializeEffectSlots(memory, texb_start, texb_num);
}

// Retail's DrawEffSptSprite batches every sprite of an effect that shares a blend into one draw at the tick's screen
// corners, so the sprites' drift, spin and fade moved at the game rate. An interpolated effect's sprites are each a batch
// of their own, keyed by the sprite, so display frames blend their world corners; a hidden or culled sprite leaves no
// gap that would shift another's match. The images drawn are unchanged.
void PortDrawEffectSprites(_EFF_SCRIPT *script, mgCTexture *texture, float *offset, mgC3DSprite *renderer) {
    _ES_SPRITE *sprites = script->sprite;
    const int   count = script->sprite_num;
    int         alpha = sprites->alpha;
    // A tag already current (the player's effects on the dungeon pause frame) is kept for every sprite.
    const bool keyed = gfx::CurrentInterp2D().key == 0 && PortEffectSpriteTag(script, 0).key != 0;
    auto       begin = [&](int blend) {
        mgCDrawEnv environment(*mgGetpDrawEnv(0));
        sceGsTest *test = &environment.test;
        test->bits.zte = 1;
        test->bits.ztst = 2;
        environment.SetZBuf(MG_ZBUF_NO_WRITE);
        environment.SetAlpha(blend);
        renderer->CPSetDrawEnv(&environment);
        renderer->CPSetTexture(texture);
        renderer->BeginCPSprite();
    };
    begin(alpha);

    for (int i = 0; i < count; i++) {
        if (sprites[i].draw_flag == 0) {
            continue;
        }

        _ES_SPRITE *sprite = &sprites[i];

        if (alpha != sprite->alpha || keyed) {
            alpha = sprite->alpha;
            renderer->EndCPSprite();
            begin(alpha);
        }

        if (keyed) {
            mgPortTag3DSpriteBatch(renderer, PortEffectSpriteTag(script, i));
        }

        sceVu0FVECTOR size = {0.0f, 0.0f, 0.0f, 0.0f};
        sceVu0FVECTOR uv0;
        sceVu0FVECTOR uv1;
        sceVu0FVECTOR position;
        sceVu0FVECTOR color;
        mgZeroVector(uv0);
        mgZeroVector(uv1);
        sceVu0AddVector(position, sprite->pos, offset);
        position[3] = 1.0f;
        sceVu0CopyVector(color, sprite->color);

        if (0.0f != sprite->blink_speed) {
            for (int component = 0; component < 4; component++) {
                color[component] += sinf(sprite->blink_phase) * sprite->blink_amp[component];
                color[component] = std::clamp(color[component], 0.0f, 255.0f);
            }

            sprite->blink_phase += sprite->blink_speed;
            sprite->blink_phase = mgAngleLimit(sprite->blink_phase);
        } else {
            for (float &component : color) {
                component = std::clamp(component, 0.0f, 255.0f);
            }
        }

        if (script->light_flag) {
            sceVu0FMATRIX light_direction;
            sceVu0FMATRIX light_color;
            sceVu0FVECTOR ambient;
            mgGetLight(light_direction, light_color);
            mgGetAmbient(ambient);
            color[0] = 0.3 * light_color[0][0] + ambient[0];
            color[1] = light_color[0][1] * 0.3 + ambient[1];
            color[2] = light_color[0][2] * 0.3 + ambient[2];
        }

        size[0] = sprite->put_size[0] * sprite->scale[0];
        size[1] = sprite->put_size[1] * sprite->scale[1];
        size[2] = mgAngleLimit(sprite->rotz);
        uv0[0] = sprite->uv[0];
        uv0[1] = sprite->uv[1];
        uv1[0] = sprite->uv[0] + sprite->uv[2];
        uv1[1] = sprite->uv[1] + sprite->uv[3];
        renderer->CPSetSprite(position, size, color, uv0, uv1);
    }

    renderer->EndCPSprite();
}

namespace {
/**
 * Where an effect's model and sprites are placed: its origin, plus its target character's position, or that of the
 * character's named frame, when the effect follows it. Retail's Draw computes it for the models and the sprites alike.
 */
void EffectOffset(_EFF_SCRIPT *script, sceVu0FVECTOR offset) {
    mgZeroVector(offset);

    // Retail tests target_id >= 0 || target_id < 128, which every id passes.
    if (script->auto_offset) {
        CCharacter2 *character = now_scene->GetCharacter(script->target_id);

        if (character != nullptr) {
            sceVu0FVECTOR character_position;
            character->GetPosition(character_position);

            if (std::strcmp(script->offset_frame, "") != 0) {
                mgCFrame *frame = character->CObjectFrame::frame;

                if (frame != nullptr) {
                    frame = frame->SearchFrame(script->offset_frame);

                    if (frame != nullptr) {
                        sceVu0FVECTOR frame_position;
                        frame->GetWorldPosition0(frame_position);
                        sceVu0CopyVector(character_position, frame_position);
                    }
                }
            }

            sceVu0CopyVector(offset, character_position);
        }
    }

    sceVu0AddVector(offset, offset, script->origin);
    offset[3] = 0.0f;
}

bool Hidden(const _EFF_SCRIPT *script) {
    return script->state == EFF_SPT_STATE_HIDE_STOP || script->state == EFF_SPT_STATE_HIDE;
}
} // namespace

// Retail's Draw: every effect's models, then every effect's sprites, the sprites built by PortDrawEffectSprites.
void CEffectScriptMan::Draw() {
    mgCTextureManager *textures = &mgTexManager;
    CMap              *map = now_scene->GetMap(now_scene->active_map);
    CMapLightingInfo   lighting;

    if (map != nullptr) {
        map->GetLightInfo(&lighting);
    }

    for (_EFF_SCRIPT *script = head; script != nullptr; script = script->next) {
        if (Hidden(script) || script->chara == nullptr) {
            continue;
        }

        sceVu0FVECTOR offset;
        EffectOffset(script, offset);
        textures->ReloadTexture(script->texb, static_cast<sceVif1Packet *>(nullptr));
        sceVu0FVECTOR position;
        script->chara->GetPosition(position);
        sceVu0AddVector(position, position, offset);
        position[3] = 1.0f;
        script->chara->SetPosition(position);
        script->chara->DrawDirect();
        sceVu0SubVector(position, position, offset);
        position[3] = 1.0f;
        script->chara->SetPosition(position);

        for (CCharacter2 *sub : script->sub_chara) {
            if (sub != nullptr) {
                sceVu0FVECTOR sub_position;
                sub->GetPosition(sub_position);
                sceVu0AddVector(sub_position, sub_position, offset);
                sub_position[3] = 1.0f;
                sub->SetPosition(sub_position);
                sub->DrawDirect();
                sceVu0SubVector(sub_position, sub_position, offset);
                sub_position[3] = 1.0f;
                sub->SetPosition(sub_position);
            }
        }
    }

    for (_EFF_SCRIPT *script = head; script != nullptr; script = script->next) {
        if (Hidden(script) || script->sprite == nullptr) {
            continue;
        }

        sceVu0FVECTOR offset;
        EffectOffset(script, offset);
        textures->ReloadTexture(script->texb, static_cast<sceVif1Packet *>(nullptr));
        mgCTexture *texture = textures->GetTexture(script->tex_name, script->texb);

        if (texture != nullptr) {
            sprite.Initialize();
            sprite.BeginCreatePacket(1, nullptr);
            PortDrawEffectSprites(script, texture, offset, &sprite);
            sprite.EndCreatePacket();
            sceVu0FMATRIX matrix;
            mgUnitMatrix(matrix);
            mgDrawDirect(&sprite, matrix);
        }
    }
}
