#include "sound.hpp"
#include "dataread.hpp"
#include "prespr.hpp"
#include "mg_drawprim.hpp"
#include <cstdio>
#include "font.hpp"
#include "sysmes.hpp"
#include "scenesnd.hpp"
#include "savedata.hpp"
#include "userdata.hpp"
#include "gamedata.hpp"
#include "scriptinterpreter.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mainloop.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "menumain.hpp"
#include "common.h"
#include "menusystemdata.hpp"
#include <cstring>

// Code (.text)
CMenuSystemData::CMenuSystemData() {
    MenuSystemDataInit();
}

void CMenuSystemData::MenuSystemDataInit() {
    memset(this, 0, 4);
}

int CMenuSystemData::CheckGetAlready(int item_no) {
    for (int i = 0; i < MENU_SYSTEM_GHOBI_NUM; i++) {
        if (ghobi[i].item_no == item_no) {
            return 1;
        }
    }
    return 0;
}

void CMenuSystemData::GetGhobi(int item_no) {
    int i = 0;
    do {
        if (ghobi[i].item_no <= 0) {
            ghobi[i].item_no = item_no;
            break;
        }
        i++;
    } while (i < MENU_SYSTEM_GHOBI_NUM);
    }
