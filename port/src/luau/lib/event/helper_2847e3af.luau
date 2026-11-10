--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0f9cefef = require("@lib/event/helper_0f9cefef")
local helper_1941d13f = require("@lib/event/helper_1941d13f")
local helper_1ba1dd3c = require("@lib/event/helper_1ba1dd3c")
local helper_26fb1957 = require("@lib/event/helper_26fb1957")
local helper_27e3607e = require("@lib/event/helper_27e3607e")
local helper_48c3461c = require("@lib/event/helper_48c3461c")
local helper_536094dc = require("@lib/event/helper_536094dc")
local helper_5bceac67 = require("@lib/event/helper_5bceac67")
local helper_674eb7db = require("@lib/event/helper_674eb7db")
local helper_705cb46d = require("@lib/event/helper_705cb46d")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_77183ee6 = require("@lib/event/helper_77183ee6")
local helper_8d00abde = require("@lib/event/helper_8d00abde")
local helper_9ea39dc3 = require("@lib/event/helper_9ea39dc3")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_e4ca14a4 = require("@lib/event/helper_e4ca14a4")
local helper_e58be93e = require("@lib/event/helper_e58be93e")
local helper_e6dee347 = require("@lib/event/helper_e6dee347")
local helper_e8e4afff = require("@lib/event/helper_e8e4afff")
local helper_e9dbeb07 = require("@lib/event/helper_e9dbeb07")
local helper_e9f151a1 = require("@lib/event/helper_e9f151a1")
local helper_f0757175 = require("@lib/event/helper_f0757175")
local helper_f2c96414 = require("@lib/event/helper_f2c96414")
local helper_f3091b76 = require("@lib/event/helper_f3091b76")
local helper_fce95934 = require("@lib/event/helper_fce95934")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_2847e3af(chara_no: s32, arg1: s32)
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
		helper_705cb46d(chara_no, arg1)
	end
	if var3 == 5 then
		helper_f2c96414(chara_no, arg1)
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
				if helper_27e3607e(0) ~= 0 then
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
				if helper_27e3607e(0) ~= 0 then
					event.fade_out_screen(25)
					wait_frames(30)
					event.open_event_menu(6, 33)
					vm.wait(11)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, chara_no)
				return
			else
				helper_1941d13f(chara_no, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_e9f151a1(chara_no, arg1)
	end
	if var3 == 8 then
		helper_0f9cefef(chara_no, arg1)
	end
	if var3 == 10 then
		helper_5bceac67(chara_no, arg1)
	end
	if var3 == 11 then
		helper_f3091b76(chara_no, arg1)
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
				helper_9ea39dc3(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_536094dc()
		else
			helper_9ea39dc3(chara_no, arg1)
		end
	end
	if var3 == 14 then
		helper_e9dbeb07(chara_no, arg1)
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
				helper_8d00abde(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_536094dc()
		else
			helper_8d00abde(chara_no, arg1)
		end
	end
	if var3 == 16 then
		helper_1ba1dd3c(chara_no, arg1)
	end
	if var3 == 17 then
		helper_e8e4afff(chara_no, arg1)
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
				helper_48c3461c(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_536094dc()
		else
			helper_48c3461c(chara_no, arg1)
		end
	end
	if var3 == 19 then
		helper_77183ee6(chara_no, arg1)
	end
	if var3 == 20 then
		helper_26fb1957(chara_no, arg1)
	end
	if var3 == 21 then
		helper_e6dee347(chara_no, arg1)
	end
	if var3 == 23 then
		helper_674eb7db(chara_no, arg1)
	end
	if var3 == 24 then
		helper_e4ca14a4(chara_no, arg1)
	end
	if var3 == 25 then
		helper_e58be93e(chara_no, arg1)
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

return helper_2847e3af
