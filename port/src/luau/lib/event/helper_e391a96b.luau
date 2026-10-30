--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_11b3915e = require("@lib/event/helper_11b3915e")
local helper_3bf2a68f = require("@lib/event/helper_3bf2a68f")
local helper_47e5dca9 = require("@lib/event/helper_47e5dca9")
local helper_4bec8a80 = require("@lib/event/helper_4bec8a80")
local helper_54a6779c = require("@lib/event/helper_54a6779c")
local helper_5d48770f = require("@lib/event/helper_5d48770f")
local helper_5d793e51 = require("@lib/event/helper_5d793e51")
local helper_6917720f = require("@lib/event/helper_6917720f")
local helper_70b12dbe = require("@lib/event/helper_70b12dbe")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_852403e1 = require("@lib/event/helper_852403e1")
local helper_8746555c = require("@lib/event/helper_8746555c")
local helper_8e4698f8 = require("@lib/event/helper_8e4698f8")
local helper_978fc274 = require("@lib/event/helper_978fc274")
local helper_9fcb2562 = require("@lib/event/helper_9fcb2562")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_aed23307 = require("@lib/event/helper_aed23307")
local helper_b2bc36f0 = require("@lib/event/helper_b2bc36f0")
local helper_bc14a483 = require("@lib/event/helper_bc14a483")
local helper_bdc02408 = require("@lib/event/helper_bdc02408")
local helper_cf8e0fe9 = require("@lib/event/helper_cf8e0fe9")
local helper_d5e8455a = require("@lib/event/helper_d5e8455a")
local helper_ddd55ec8 = require("@lib/event/helper_ddd55ec8")
local helper_e82e424a = require("@lib/event/helper_e82e424a")
local helper_f0757175 = require("@lib/event/helper_f0757175")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_e391a96b(chara_no: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: any = 0
	local var8: any = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: any = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: any = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: any = 0
	local var18: s32 = 0
	local active_chr_no: s32 = 0
	local var20: any = 0
	event.apply_message_window_preset(0, 0)
	event.set_message_bubble_tail(0, 1)
	var2 = event.get_chapter() or var2
	var3 = event.get_triggered_event_data_2(14) or var3
	event.get_current_map()
	now_sub_map_no = event.get_current_submap() or now_sub_map_no
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, chara_no)
	if var3 == 3 then
		helper_e82e424a(chara_no, arg1)
	end
	if var3 == 5 then
		helper_d5e8455a(chara_no, arg1)
	end
	if var3 == 4 then
		flag = event.get_save_flag(104) or flag
		if flag == 0 then
			event.open_message_window_2(0, "Lass mich einkaufen.\nEinen Kn[UNI00fc]ller aufsp[UNI00fc]ren.")
			var7 = helper_f0757175(chara_no, -1, 2, 0, 0, 0)
			if var7 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var7 == 1 then
				if helper_5d793e51(0) ~= 0 then
					event.fade_out_screen(25)
					wait_frames(30)
					event.open_event_menu(6, 33)
					vm.wait(6)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, chara_no)
				return
			else
				helper_47e5dca9()
			end
		else
			event.open_message_window_2(0, "Sei mein Freund!\nEinen Kn[UNI00fc]ller aufsp[UNI00fc]ren.")
			var8 = helper_f0757175(chara_no, -1, 2, 0, 0, 0)
			if var8 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var8 == 1 then
				if helper_5d793e51(0) ~= 0 then
					event.fade_out_screen(25)
					wait_frames(30)
					event.open_event_menu(6, 33)
					vm.wait(11)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, chara_no)
				return
			else
				helper_bc14a483(chara_no, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_8e4698f8(chara_no, arg1)
	end
	if var3 == 8 then
		helper_5d48770f(chara_no, arg1)
	end
	if var3 == 10 then
		helper_11b3915e(chara_no, arg1)
	end
	if var3 == 11 then
		helper_54a6779c(chara_no, arg1)
	end
	if var3 == 12 then
		var9 = event.get_quest_request_status(0, 0) or var9
		var10 = event.get_quest_request_status(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Hallo.\nSei mein Freund!")
			var11 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var11 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var11 == 1 then
				helper_3bf2a68f(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_47e5dca9()
		else
			helper_3bf2a68f(chara_no, arg1)
		end
	end
	if var3 == 14 then
		helper_ddd55ec8(chara_no, arg1)
	end
	if var3 == 15 then
		var12 = event.get_quest_request_status(0, 0) or var12
		var13 = event.get_quest_request_status(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Hallo.\nSei mein Freund!")
			var14 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var14 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var14 == 1 then
				helper_6917720f(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_47e5dca9()
		else
			helper_6917720f(chara_no, arg1)
		end
	end
	if var3 == 16 then
		helper_bdc02408(chara_no, arg1)
	end
	if var3 == 17 then
		helper_aed23307(chara_no, arg1)
	end
	if var3 == 18 then
		var15 = event.get_quest_request_status(0, 0) or var15
		var16 = event.get_quest_request_status(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Hallo.\nSei mein Freund!")
			var17 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var17 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var17 == 1 then
				helper_4bec8a80(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_47e5dca9()
		else
			helper_4bec8a80(chara_no, arg1)
		end
	end
	if var3 == 19 then
		helper_cf8e0fe9(chara_no, arg1)
	end
	if var3 == 20 then
		helper_b2bc36f0(chara_no, arg1)
	end
	if var3 == 21 then
		helper_8746555c(chara_no, arg1)
	end
	if var3 == 23 then
		helper_9fcb2562(chara_no, arg1)
	end
	if var3 == 24 then
		helper_852403e1(chara_no, arg1)
	end
	if var3 == 25 then
		helper_978fc274(chara_no, arg1)
	end
	if var3 == 33 then
		var18 = event.get_quest_request_status(0, 8) or var18
		active_chr_no = event.get_playable_character() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Lass mich einkaufen.\nHallo.")
			var20 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var20 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var20 == 1 then
				helper_70b12dbe(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		helper_47e5dca9()
	end
	if var3 == 1 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"Ich hab in letzter Zeit Probleme,\ndie kleinen Teile zu sehen.<page>Ich werde wohl auch\nnicht j[UNI00fc]nger ..."
			)
		else
			event.open_message_window_2(
				0,
				"Need und ich tr[UNI00e4]umen davon, dass\ndie Blackstone-Bahn den ganzen\nKontinent bef[UNI00e4]hrt.<page>Du hilft uns doch, oder?"
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 2 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(0, "Wenn ich nicht immer\nwas zu tun habe,\nwerde ich unausstehlich.")
		else
			event.open_message_window_2(
				0,
				"Wenn sie Zelmit finden, bin ich\nauch besch[UNI00e4]ftigt. Dann w[UNI00fc]rde\nich buddeln, buddeln, buddeln!"
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 6 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(0, "Ich habe in letzter Zeit viel\nUngeziefer im Gefieder,\ndas juckt schrecklich.")
		else
			event.open_message_window_2(
				0,
				"Wenn du Zelmit suchen willst,\nmach das ruhig. Aber\n[UNI00fc]beranstrenge dich nicht, Kleiner."
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 13 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"Ich liebe Schwarzpulver-Duft!\nDas ist echt mein Traumjob.<page>Aber mein Boss ist ziemlich\nstur und altmodisch.\nAch, na ja."
			)
		else
			event.open_message_window_2(0, "Diese Abenteuer machen dir\neinen Riesenspa[UNI00df], was?")
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 22 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"Abgesehen davon, dass ich als\nGem[UNI00e4]lde zur Welt kam, bin\nich genau wie alle anderen."
			)
		else
			event.open_message_window_2(0, "Ich hab ein dummes Gef[UNI00fc]hl bei der\nZelmit-Mine. Sei vorsichtig, ja?")
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	event.set_villager_ai_enabled(1, chara_no)
end

return helper_e391a96b
