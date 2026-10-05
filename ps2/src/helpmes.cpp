#include "helpmes.hpp"
#include "dataread.hpp"
#include "mainloop.hpp"
#include "nd_meswin.hpp"

#include <cstdio>
#include <cstring>

extern int ShowOffOnce;
extern int WindowMode;
extern u8 HelpMesBuff[4096];
extern u32 InitFlag__2;
extern HELP_MES_INFO HelpMesInfo;
extern ClsMes HelpMes;
extern char at_799__6[15];
extern char at_800__5[30];

// Code (.text)
void LoadHelpMes(u_long128 *scratch) {
    char path[0x4C];
    int size;

    sprintf(path, at_799__6, LanguageCode);
    if (LoadFile2(path, scratch, &size, 0) != 0) {
        if (size > 0x1000) {
            printf(at_800__5, size, 0x1000);
            return;
        }
        memcpy(HelpMesBuff, scratch, size);
        InitFlag__2 = 1;
    }
}
HELP_MES_INFO *GetHepMesInfo(void) {
    return &HelpMesInfo;
}
void CreateHelpMes(int message_id) {
    if (InitFlag__2 != 0) {
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
        HelpMes.unk_1e40 = 0;
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
        HelpMes.Preset(4);
        HelpMes.SetWindowMode(0);
        HelpMes.SetBuff((short *)HelpMesBuff);
        HelpMes.unk_22a4 = message_id;
        ShowOffOnce = 0;
        HelpMesInfo.time = 0;
        HelpMesInfo.mes_no = -1;
        HelpMesInfo.fukidashi_pos = -1;
        HelpMesInfo.show = 0;
        HelpMesInfo.y = 0;
        HelpMesInfo.x = 0;
        HelpMesInfo.created = 0;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/helpmes", StepHelpMes__Fv);
void ShowOffOnceHelpMes(void) {
    ShowOffOnce = 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/helpmes", DrawHelpMes__Fv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/helpmes", ShowHelpMes__Fii);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/helpmes", ShowErrorHelpMes__Fii);

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/helpmes", __sinit_helpmes_cpp);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/helpmes", at_799__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/helpmes", at_800__5__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/helpmes", D_0037B094__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(InitFlag__2, 0x4);
INCLUDE_BSS(WindowMode, 0x4);
INCLUDE_BSS(ShowOffOnce, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(HelpMesBuff, 0x1000);
INCLUDE_BSS(HelpMes, 0x295C);
INCLUDE_BSS(D_01F628BC, 0x4);
INCLUDE_BSS(HelpMesInfo, 0x20);
