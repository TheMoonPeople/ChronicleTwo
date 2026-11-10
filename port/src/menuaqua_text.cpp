#include "common.h"

#include <algorithm>
#include <array>
#include <cstring>
#include <format>
#include <string>
#include <utility>

#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menuaqua.hpp"
#include "menucommon.hpp"
#include "nd_meswin.hpp"
#include "text/bounded.hpp"
#include "userdata.hpp"

// Retail appends the count conversion to each food's name and passes the result to sprintf as the
// format, then copies the line into a 50-byte message name. It also reads the tenth food number, which
// GetUseableEsaNo never writes. Lines are built as text, held to the name field, and the list stops at
// the numbers actually written.
void CAquaMes::SetQuestionId(int id, int top, int num) {
    question_cursor = 0;
    question_num = num;
    question_mes->select_top = top;

    if (id == AQUA_MES_FOOD_LIST) {
        std::array<int, 12> item_no{};
        question_mes->mes_no = -1;
        const int esa_num = GetUseableEsaNo(item_no.data());
        if (esa_num == 8) {
            id = AQUA_MES_FOOD_LIST;
        }
        if (esa_num == 9) {
            id = AQUA_MES_FOOD_LIST_ELECTRIC;
        }

        int listed = 0;
        for (; std::cmp_less(listed, item_no.size()) && listed < MES_NAME_MAX && item_no[listed] > 0; ++listed) {
            const char *name = GetItemMessage(item_no[listed]);
            if (name == nullptr) {
                break;
            }

            const int   have = GetUserItemHaveNum(item_no[listed]);
            const int   pad = (CheckNowEurope() ? 24 : 16) - static_cast<int>(std::strlen(name));
            std::string line = name;
            if (LanguageCode == 0) {
                // Japanese pads with full-width spaces before a full-width times sign.
                for (int j = 0; j < pad / 2; ++j) {
                    line += "\x81\x40";
                }
                line += std::format("\x81\x7e{:3}", have);
            } else {
                line.append(static_cast<std::size_t>(std::max(pad, 0)), ' ');
                line += std::format("x{:3}", have);
            }
            dc2::text::Copy(question_mes->name[listed], line);
        }

        question_num = listed;
    }

    question_mes->SetHalfFontWPercent(0.5f);
    question_mes->MakeMesWin(id);
    question_mes->Step();
}
