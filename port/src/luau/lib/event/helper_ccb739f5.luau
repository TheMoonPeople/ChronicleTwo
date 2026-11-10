--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_03012f66 = require("@lib/event/helper_03012f66")
local helper_1539c0ad = require("@lib/event/helper_1539c0ad")
local helper_3b5ab347 = require("@lib/event/helper_3b5ab347")
local helper_41594bec = require("@lib/event/helper_41594bec")
local helper_47e5dca9 = require("@lib/event/helper_47e5dca9")
local helper_59f2903b = require("@lib/event/helper_59f2903b")
local helper_5eb3e959 = require("@lib/event/helper_5eb3e959")
local helper_681d409d = require("@lib/event/helper_681d409d")
local helper_686b44f0 = require("@lib/event/helper_686b44f0")
local helper_6cd86d6e = require("@lib/event/helper_6cd86d6e")
local helper_70b12dbe = require("@lib/event/helper_70b12dbe")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_7c1fe17f = require("@lib/event/helper_7c1fe17f")
local helper_8bc31502 = require("@lib/event/helper_8bc31502")
local helper_9f2ca95f = require("@lib/event/helper_9f2ca95f")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_cb3af2cc = require("@lib/event/helper_cb3af2cc")
local helper_d09a4ccd = require("@lib/event/helper_d09a4ccd")
local helper_e13105bc = require("@lib/event/helper_e13105bc")
local helper_e7f8c4b7 = require("@lib/event/helper_e7f8c4b7")
local helper_f0757175 = require("@lib/event/helper_f0757175")
local helper_f2069798 = require("@lib/event/helper_f2069798")
local helper_f84bd810 = require("@lib/event/helper_f84bd810")
local helper_fdbc62e2 = require("@lib/event/helper_fdbc62e2")
local helper_ffcb9d64 = require("@lib/event/helper_ffcb9d64")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_ccb739f5(chara_no: s32, arg1: s32)
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
		helper_f2069798(chara_no, arg1)
	end
	if var3 == 5 then
		helper_59f2903b(chara_no, arg1)
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
				if helper_e7f8c4b7(0) ~= 0 then
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
				if helper_e7f8c4b7(0) ~= 0 then
					event.fade_out_screen(25)
					wait_frames(30)
					event.open_event_menu(6, 33)
					vm.wait(11)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, chara_no)
				return
			else
				helper_5eb3e959(chara_no, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_d09a4ccd(chara_no, arg1)
	end
	if var3 == 8 then
		helper_686b44f0(chara_no, arg1)
	end
	if var3 == 10 then
		helper_9f2ca95f(chara_no, arg1)
	end
	if var3 == 11 then
		helper_41594bec(chara_no, arg1)
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
				helper_cb3af2cc(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_47e5dca9()
		else
			helper_cb3af2cc(chara_no, arg1)
		end
	end
	if var3 == 14 then
		helper_8bc31502(chara_no, arg1)
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
				helper_e13105bc(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_47e5dca9()
		else
			helper_e13105bc(chara_no, arg1)
		end
	end
	if var3 == 16 then
		helper_f84bd810(chara_no, arg1)
	end
	if var3 == 17 then
		helper_fdbc62e2(chara_no, arg1)
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
				helper_6cd86d6e(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_47e5dca9()
		else
			helper_6cd86d6e(chara_no, arg1)
		end
	end
	if var3 == 19 then
		helper_7c1fe17f(chara_no, arg1)
	end
	if var3 == 20 then
		helper_03012f66(chara_no, arg1)
	end
	if var3 == 21 then
		helper_ffcb9d64(chara_no, arg1)
	end
	if var3 == 23 then
		helper_1539c0ad(chara_no, arg1)
	end
	if var3 == 24 then
		helper_3b5ab347(chara_no, arg1)
	end
	if var3 == 25 then
		helper_681d409d(chara_no, arg1)
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

return helper_ccb739f5
