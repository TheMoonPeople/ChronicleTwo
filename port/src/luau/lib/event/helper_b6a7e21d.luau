--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local set_window_mode = require("@lib/event/set_window_mode")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_b6a7e21d(arg0: s32, arg1: any)
	local flag: s32 = 0
	local var3: s32 = 0
	local player_chara: s32 = 0
	local var5: any = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	event.set_character_motion(0, "立ち", 0)
	wait_frames(9)
	flag = event.get_save_flag(7) or flag
	if flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		set_window_mode(0, 1)
		helper_4e93f9fc(arg0, 0, 0)
		player_chara = event.get_player_character_slot() or player_chara
		event.open_message_window_2(0, "Und, wie geht's Steve?")
		helper_0ffc2526(0, -1, arg0, player_chara, 0)
		event.set_character_motion(arg0, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "Aufladen\nKern verbessern")
		var5 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_bubble_tail(0, 1)
		if var5 == 0 then
			event.set_save_data_value(2)
			event.open_message_window_2(0, "So! Alles fertig!")
			helper_0ffc2526(0, -1, arg0, player_chara, 0)
		end
		if var5 == 1 then
			event.fade_out_screen(25)
			wait_frames(30)
			event.open_event_menu(6, 23)
			vm.wait(7)
			event.fade_in_screen(25)
		end
		event.set_villager_ai_enabled(1, 24)
		return
	end
	flag = event.get_save_flag(107) or flag
	if flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(0, "Du gibst bei so etwas\nschon auf? Nie aufgeben, sag ich!")
		helper_1c04a0eb(arg0, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	flag = event.get_save_flag(20) or flag
	if flag == 1 then
		vm.wait(9)
		event.load_event_script("i01h01/i01h01c_1.stb", 500)
		return
	end
	var3 = event.get_item_count(165) or var3
	if var3 > 0 then
		event.set_save_flag(20, 1)
		vm.wait(10)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	argc = event.get_item_count(224) or argc
	argc_2 = event.get_item_count(245) or argc_2
	argc_3 = event.get_item_count(227) or argc_3
	var3 = event.is_invention_created(165) or var3
	if argc >= 20 and argc_2 >= 1 and argc_3 >= 2 and var3 ~= -1 then
		vm.wait(11)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	flag = event.get_save_flag(19) or flag
	if flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(
			0,
			"Geh nach drau[UNI00df]en. Der Laden direkt\ngegen[UNI00fc]ber mit dem K[UNI00fc]rbis-Schild ist\nder Gegenst[UNI00e4]ndeladen.<page>Du brauchst 20 St[UNI00fc]ck Metall,\n2 Kupferklumpen und 1 Tierhaut.\nGeh r[UNI00fc]ber und kauf das!"
		)
		helper_1c04a0eb(arg0, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	var3 = event.is_invention_created(165) or var3
	if var3 ~= -1 then
		vm.wait(13)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	var3 = event.has_invention_ideas(165) or var3
	if var3 == 1 then
		vm.wait(14)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	flag = event.get_save_flag(17) or flag
	if flag == 1 then
		vm.wait(15)
		event.load_event_script("i01h01/i01h01b_1.stb", 510)
		return
	end
	flag = event.get_save_flag(105) or flag
	if flag == 0 then
		event.open_message_window_2(0, "Max, du kannst nicht einfach\nblaumachen, verstanden?")
		helper_1c04a0eb(arg0, -1, 0, 0)
		return
	end
	event.set_villager_ai_enabled(0, 24)
	event.open_message_window_2(0, "Du musst es erst alleine\nversuchen, Junge.")
	helper_1c04a0eb(arg0, -1, 0, 0)
	event.open_message_window_2(0, "Wenn du nicht weiterkommst,\ngeb ich dir einen Tipp, ja?")
	helper_1c04a0eb(arg0, -1, 0, 0)
	event.open_message_window_2(0, "Jetzt mach dich ran!")
	helper_1c04a0eb(arg0, -1, 0, 0)
	event.set_villager_ai_enabled(1, 24)
end

return helper_b6a7e21d
