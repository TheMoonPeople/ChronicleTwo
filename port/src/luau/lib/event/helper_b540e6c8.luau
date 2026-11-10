--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1996828b = require("@lib/event/helper_1996828b")
local helper_20c00eaf = require("@lib/event/helper_20c00eaf")
local helper_215574ee = require("@lib/event/helper_215574ee")
local helper_23f66934 = require("@lib/event/helper_23f66934")
local helper_32d0a967 = require("@lib/event/helper_32d0a967")
local helper_399942cd = require("@lib/event/helper_399942cd")
local helper_536094dc = require("@lib/event/helper_536094dc")
local helper_6f2bfb5f = require("@lib/event/helper_6f2bfb5f")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_7215de68 = require("@lib/event/helper_7215de68")
local helper_747b4a80 = require("@lib/event/helper_747b4a80")
local helper_8c6d5cd5 = require("@lib/event/helper_8c6d5cd5")
local helper_938dbe57 = require("@lib/event/helper_938dbe57")
local helper_99c023b7 = require("@lib/event/helper_99c023b7")
local helper_a051c35b = require("@lib/event/helper_a051c35b")
local helper_a41a9c8b = require("@lib/event/helper_a41a9c8b")
local helper_a4d8dd70 = require("@lib/event/helper_a4d8dd70")
local helper_a6cb6e2e = require("@lib/event/helper_a6cb6e2e")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_b6dc5663 = require("@lib/event/helper_b6dc5663")
local helper_b7f78b43 = require("@lib/event/helper_b7f78b43")
local helper_f0757175 = require("@lib/event/helper_f0757175")
local helper_f3ec808f = require("@lib/event/helper_f3ec808f")
local helper_f502f95f = require("@lib/event/helper_f502f95f")
local helper_fce95934 = require("@lib/event/helper_fce95934")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_b540e6c8(chara_no: s32, arg1: s32)
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
		helper_6f2bfb5f(chara_no, arg1)
	end
	if var3 == 5 then
		helper_747b4a80(chara_no, arg1)
	end
	if var3 == 4 then
		flag = event.get_save_flag(104) or flag
		if flag == 0 then
			event.open_message_window_2(0, "Fammi far compere\nIndaga per uno scoop")
			var7 = helper_f0757175(chara_no, -1, 2, 0, 0, 0)
			if var7 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var7 == 1 then
				if helper_a41a9c8b(0) ~= 0 then
					event.fade_out_screen(25)
					wait_frames(30)
					event.open_event_menu(6, 33)
					vm.wait(6)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, chara_no)
				return
			else
				helper_536094dc()
			end
		else
			event.open_message_window_2(0, "Benvenuto!\nIndaga per uno scoop")
			var8 = helper_f0757175(chara_no, -1, 2, 0, 0, 0)
			if var8 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var8 == 1 then
				if helper_a41a9c8b(0) ~= 0 then
					event.fade_out_screen(25)
					wait_frames(30)
					event.open_event_menu(6, 33)
					vm.wait(11)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, chara_no)
				return
			else
				helper_20c00eaf(chara_no, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_f502f95f(chara_no, arg1)
	end
	if var3 == 8 then
		helper_b7f78b43(chara_no, arg1)
	end
	if var3 == 10 then
		helper_8c6d5cd5(chara_no, arg1)
	end
	if var3 == 11 then
		helper_a4d8dd70(chara_no, arg1)
	end
	if var3 == 12 then
		var9 = event.get_quest_request_status(0, 0) or var9
		var10 = event.get_quest_request_status(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Salve\nBenvenuto!")
			var11 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var11 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var11 == 1 then
				helper_399942cd(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_536094dc()
		else
			helper_399942cd(chara_no, arg1)
		end
	end
	if var3 == 14 then
		helper_32d0a967(chara_no, arg1)
	end
	if var3 == 15 then
		var12 = event.get_quest_request_status(0, 0) or var12
		var13 = event.get_quest_request_status(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Salve\nBenvenuto!")
			var14 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var14 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var14 == 1 then
				helper_7215de68(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_536094dc()
		else
			helper_7215de68(chara_no, arg1)
		end
	end
	if var3 == 16 then
		helper_1996828b(chara_no, arg1)
	end
	if var3 == 17 then
		helper_a051c35b(chara_no, arg1)
	end
	if var3 == 18 then
		var15 = event.get_quest_request_status(0, 0) or var15
		var16 = event.get_quest_request_status(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Salve\nBenvenuto!")
			var17 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var17 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var17 == 1 then
				helper_f3ec808f(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_536094dc()
		else
			helper_f3ec808f(chara_no, arg1)
		end
	end
	if var3 == 19 then
		helper_215574ee(chara_no, arg1)
	end
	if var3 == 20 then
		helper_23f66934(chara_no, arg1)
	end
	if var3 == 21 then
		helper_99c023b7(chara_no, arg1)
	end
	if var3 == 23 then
		helper_b6dc5663(chara_no, arg1)
	end
	if var3 == 24 then
		helper_a6cb6e2e(chara_no, arg1)
	end
	if var3 == 25 then
		helper_938dbe57(chara_no, arg1)
	end
	if var3 == 33 then
		var18 = event.get_quest_request_status(0, 8) or var18
		active_chr_no = event.get_playable_character() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Fammi far compere\nSalve")
			var20 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var20 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var20 == 1 then
				helper_fce95934(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		helper_536094dc()
	end
	if var3 == 1 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(0, "Ultimamente faccio fatica\na vedere le cose piccole.<page>Mmmh... sto\ninvecchiando...")
		else
			event.open_message_window_2(
				0,
				"Vedere la Ferrovia Carbonero\noperativa su tutto il continente\n[UNI00e8] il sogno mio e di Need.<page>Possiamo contare su di te, vero?"
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 2 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(0, "Se non tengo le mani\ncontinuamente occupate,\nvado fuori di testa!")
		else
			event.open_message_window_2(
				0,
				"Se trovano la Zelmite sar[UNI00f2]\nproprio impegnato. Gi[UNI00e0]!\nScavare, scavare e solo scavare!!!"
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 6 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(0, "Sai, in questi giorni, ho\nle penne piene di pulci:\nprudono terribilmente!")
		else
			event.open_message_window_2(0, "Va bene passare il tempo\ncercando Zelmite, ma vedi di\nnon stancarti troppo, ragazzo!")
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 13 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"Che profumo la polvere da sparo!\nSono nato per questo lavoro!<page>Certo, il mio capo [UNI00e8] un terribile\ncapoccione e all'antica.\nMa... pazienza!"
			)
		else
			event.open_message_window_2(0, "Ti piace proprio\nl'avventura, eh?")
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 22 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(0, "A parte il fatto di essere nata\nda un quadro, non sono differente\nda chiunque altro.")
		else
			event.open_message_window_2(0, "Ho un brutto presentimento sulla\nMiniera di Zelmite. Stai all'erta!")
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	event.set_villager_ai_enabled(1, chara_no)
end

return helper_b540e6c8
