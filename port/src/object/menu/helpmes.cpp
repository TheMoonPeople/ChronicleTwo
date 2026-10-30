#include "helpmes.hpp"

#include <cstdio>
#include <cstring>

#include "dataread.hpp"
#include "log/game_output.hpp"
#include "mainloop.hpp"
#include "memory/tracked_copy.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "snd_mngr.hpp"

/**
 *
 * Whether the help message file has been loaded.
 *
 */
static int InitFlag;

/**
 *
 * Window style selected for the current help message.
 *
 */
static MesWindowMode WindowMode;

/**
 *
 * Whether to suppress the next help message draw.
 *
 */
static int ShowOffOnce;

/**
 *
 * Loaded bytes of the localized help message file.
 *
 */
static char                    HelpMesBuff[0x1000];
static dc2::text::MessageTable help_messages; /**< Immutable messages copied from the initialized help file. */

/**
 *
 * Message window used to display help and error messages.
 *
 */
static ClsMes HelpMes;

/**
 *
 * State of the current help or error message request.
 *
 */
static HELP_MES_INFO HelpMesInfo;

void LoadHelpMes() {
    help_messages = nullptr;
    InitFlag = false;
    char path[0x4C];
    int  size = {};

    std::snprintf(path, sizeof(path), "etc/help%d.mes", LanguageCode);

    if (LoadFile2(path, std::span(reinterpret_cast<u8 *>(HelpMesBuff), sizeof HelpMesBuff), &size, LOAD_FILE_READ) != 0) {
        if (size > 0x1000) {
            dc2::log::PrintGame("HMes Buffer Over!!(%d/%zubyte)", size, sizeof(HelpMesBuff));
            return;
        }

        help_messages = size > 0 ? dc2::text::MessageTable::Parse(
                                       {reinterpret_cast<const std::byte *>(HelpMesBuff), static_cast<std::size_t>(size)})
                                 : dc2::text::MessageTable{};
        InitFlag = static_cast<bool>(help_messages);
    }
}

/**
 *
 * Returns the shared help message state record.
 *
 */
static HELP_MES_INFO *GetHepMesInfo() {
    return &HelpMesInfo;
}

void CreateHelpMes(int texture_block) {
    if (InitFlag != 0) {
        HelpMes.npc_name_mode = 0;
        HelpMes.char_num = 0;
        HelpMes.text_w = 0;
        HelpMes.text_h = 0;
        HelpMes.page = 0;
        HelpMes.page_num = 0;

        for (int i = 0; i < 16; i++) {
            HelpMes.page_chars[i] = 0;
        }

        HelpMes.last_x = 0;
        HelpMes.last_y = 0;
        HelpMes.fade = 0.0f;
        HelpMes.open = 1;
        HelpMes.draw_speed = HelpMes.GetDrawSpeedDef();
        HelpMes.page_wait = 0;
        HelpMes.scroll_wait = 0;
        HelpMes.reveal = 0.0f;
        HelpMes.reveal_num = 0;
        HelpMes.page_top = 0;
        HelpMes.unk_1f4 = 0;
        HelpMes.InitMesWinTbl();
        HelpMes.color = HelpMes.def_color;
        HelpMes.wait = 0;
        HelpMes.page_time = 0;
        HelpMes.page_auto_time = 30;
        HelpMes.mes_no = -1;
        HelpMes.text_ptr = nullptr;
        HelpMes.alpha = 0x80;

        for (int i = 0; i < MES_NAME_MAX; i++) {
            memset(HelpMes.name[i], 0, sizeof(HelpMes.name[i]));
        }

        for (int i = 0; i < MES_NAME_MAX; i++) {
            HelpMes.item_mes[i] = -1;
        }

        for (int i = 0; i < MES_VALUE_MAX; i++) {
            HelpMes.values[i] = 0;
            HelpMes.value_width[i] = 0;
        }

        HelpMes.value = 0;
        HelpMes.value_sign = 0;
        HelpMes.value_zero = 1;
        HelpMes.value_half = 0;
        HelpMes.value_space = 0;
        HelpMes.digit_font = 0;
        HelpMes.space_w = -1;
        HelpMes.justify_w = -1;
        HelpMes.select = -1;
        HelpMes.goal_cursor_x = 0;
        HelpMes.goal_cursor_y = 0;
        HelpMes.cursor_x = 0;
        HelpMes.cursor_y = 0;
        HelpMes.select_shade = 0;
        HelpMes.cursor_centering = 0;
        HelpMes.cursor_time = 0;
        HelpMes.choice_pos[0][0] = -1;
        HelpMes.choice_pos[0][1] = -1;
        HelpMes.choice_pos[1][0] = -1;
        HelpMes.choice_pos[1][1] = -1;
        HelpMes.select_top = 0;
        HelpMes.cursor_off_y = 0;
        HelpMes.voice_on = 0;
        HelpMes.voice_type = 0;
        HelpMes.voice_cnt = 0;
        HelpMes.close_time = 0;
        HelpMes.scissor_on = 0;
        HelpMes.scissor.x = 0;
        HelpMes.scissor.width = 0;
        HelpMes.scissor.y = 0;
        HelpMes.scissor.height = 0;

        for (int i = 0; i < MES_LINE_MAX; i++) {
            HelpMes.line_indent[i] = 0;
            HelpMes.line_pos[i][0] = 0;
            HelpMes.line_pos[i][1] = 0;
            HelpMes.line_pos_on[i] = 0;
            HelpMes.line_shade[i] = -1;
            HelpMes.line_color[i] = 0;
            HelpMes.equip_on[i] = 0;
            HelpMes.equip_x[i] = 0;
            HelpMes.equip_y[i] = 0;
            HelpMes.line_w[i] = 0;
            HelpMes.line_alpha[i] = -1;
            HelpMes.cross_on[i] = 0;
            HelpMes.cross_x[i] = 0;
            HelpMes.cross_y[i] = 0;
            HelpMes.unk_271c[i] = -1;
            HelpMes.unk_276c[i] = -1;
            HelpMes.unk_27bc[i] = 0;
            HelpMes.unk_280c[i] = 0;
            HelpMes.delta_on[i] = 0;
            HelpMes.delta_x[i] = 0;
            HelpMes.delta_y[i] = 0;
        }

        HelpMes.Preset(MES_PRESET_WINDOW);
        HelpMes.SetWindowMode(MES_WIN_NONE);
        HelpMes.SetBuff(help_messages);
        HelpMes.texture_block = texture_block;
        ShowOffOnce = false;
        HelpMesInfo.time = 0;
        HelpMesInfo.mes_no = -1;
        HelpMesInfo.fukidashi_pos = -1;
        HelpMesInfo.show = false;
        HelpMesInfo.y = 0;
        HelpMesInfo.x = 0;
        HelpMesInfo.created = false;
    }
}

void StepHelpMes() {
    ClsMes        *message = &HelpMes;
    HELP_MES_INFO *info = GetHepMesInfo();

    if (info != nullptr) {
        int hidden = !info->show;

        if (hidden) {
            return;
        }
    } else {
        return;
    }

    if (!info->created) {
        message->Preset(MES_PRESET_WINDOW);
        message->SetWindowMode(WindowMode);
        message->MakeMesWin(info->mes_no);
        message->fade_speed = 1.0f;

        if (info->fukidashi_pos < 0) {
            message->abs_win.x = info->x;
            message->abs_win.y = info->y;
        } else {
            message->fukidashi_pos = info->fukidashi_pos;
        }

        info->created = true;
    }

    message->Step();

    if (info->time > 0) {
        info->time--;

        if (info->time == 0) {
            info->time = 0;
            info->mes_no = -1;
            info->show = false;
            info->y = 0;
            info->x = 0;
            info->created = false;
            info->fukidashi_pos = -1;
        }
    }
}

void ShowOffOnceHelpMes() {
    ShowOffOnce = true;
}

void DrawHelpMes() {
    if (DebugInfo.param_off != 0) {
        return;
    }

    ClsMes        *message = &HelpMes;
    HELP_MES_INFO *info = GetHepMesInfo();

    if (info != nullptr) {
        int hidden = !info->show;

        if (hidden) {
            return;
        }
    } else {
        return;
    }

    if (ShowOffOnce != 0) {
        ShowOffOnce = false;
        return;
    }

    mgTexManager.ReloadTexture(HelpMes.texture_block, (sceVif1Packet *) nullptr);
    message->DrawMesWin();
}

void ShowHelpMes(int mes_no, int time) {
    HELP_MES_INFO *info = GetHepMesInfo();

    if (info == nullptr) {
        return;
    }

    if (info->mes_no != mes_no) {
        info->time = 0;
        info->mes_no = -1;
        info->show = false;
        info->y = 0;
        info->x = 0;
        info->created = false;
        info->fukidashi_pos = -1;
    }

    info->show = true;
    info->mes_no = mes_no;
    info->time = time > 0 ? time + 1 : time;
    info->x = 18;
    info->y = mgScreenHeight - 31;
    info->fukidashi_pos = -1;
    WindowMode = MES_WIN_NONE;
}

void ShowErrorHelpMes(int mes_no, int time) {
    HELP_MES_INFO *info = GetHepMesInfo();

    if (info == nullptr) {
        return;
    }

    if (info->mes_no != mes_no) {
        info->time = 0;
        info->mes_no = -1;
        info->show = false;
        info->y = 0;
        info->x = 0;
        info->created = false;
        info->fukidashi_pos = -1;
    }

    info->show = true;
    info->mes_no = mes_no;
    info->time = time > 0 ? time + 1 : time;
    info->fukidashi_pos = 8;
    WindowMode = MES_WIN_VERSATILE_1;
    sndSePlay(GetSystemSndID(), SYSTEM_SE_DENIED, 0);
}
