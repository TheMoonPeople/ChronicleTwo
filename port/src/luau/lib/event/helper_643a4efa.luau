--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0a42967e = require("@lib/event/helper_0a42967e")
local helper_148c4e7b = require("@lib/event/helper_148c4e7b")
local helper_1d33595a = require("@lib/event/helper_1d33595a")
local helper_22cd0ca2 = require("@lib/event/helper_22cd0ca2")
local helper_25a2bce4 = require("@lib/event/helper_25a2bce4")
local helper_59605cc0 = require("@lib/event/helper_59605cc0")
local helper_59d6deef = require("@lib/event/helper_59d6deef")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_71543208 = require("@lib/event/helper_71543208")
local helper_7c8b8b4e = require("@lib/event/helper_7c8b8b4e")
local helper_946ae97b = require("@lib/event/helper_946ae97b")
local helper_a62e48ab = require("@lib/event/helper_a62e48ab")
local helper_aa26cbbb = require("@lib/event/helper_aa26cbbb")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_ad8682c4 = require("@lib/event/helper_ad8682c4")
local helper_b0e03639 = require("@lib/event/helper_b0e03639")
local helper_b3f7f172 = require("@lib/event/helper_b3f7f172")
local helper_c155b08f = require("@lib/event/helper_c155b08f")
local helper_c91dac3f = require("@lib/event/helper_c91dac3f")
local helper_ccf6981a = require("@lib/event/helper_ccf6981a")
local helper_db9b1437 = require("@lib/event/helper_db9b1437")
local helper_de72cef6 = require("@lib/event/helper_de72cef6")
local helper_ec48f09e = require("@lib/event/helper_ec48f09e")
local helper_f0757175 = require("@lib/event/helper_f0757175")
local helper_fd9abc8f = require("@lib/event/helper_fd9abc8f")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_643a4efa(chara_no: s32, arg1: s32)
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
		helper_148c4e7b(chara_no, arg1)
	end
	if var3 == 5 then
		helper_946ae97b(chara_no, arg1)
	end
	if var3 == 4 then
		flag = event.get_save_flag(104) or flag
		if flag == 0 then
			event.open_message_window_2(0, "Je veux faire des achats\nC'est parti pour un scoop")
			var7 = helper_f0757175(chara_no, -1, 2, 0, 0, 0)
			if var7 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var7 == 1 then
				if helper_db9b1437(0) ~= 0 then
					event.fade_out_screen(25)
					wait_frames(30)
					event.open_event_menu(6, 33)
					vm.wait(6)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, chara_no)
				return
			else
				helper_de72cef6()
			end
		else
			event.open_message_window_2(0, "En route pour l'aventure ?\nC'est parti pour un scoop")
			var8 = helper_f0757175(chara_no, -1, 2, 0, 0, 0)
			if var8 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var8 == 1 then
				if helper_db9b1437(0) ~= 0 then
					event.fade_out_screen(25)
					wait_frames(30)
					event.open_event_menu(6, 33)
					vm.wait(11)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, chara_no)
				return
			else
				helper_0a42967e(chara_no, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_ad8682c4(chara_no, arg1)
	end
	if var3 == 8 then
		helper_59605cc0(chara_no, arg1)
	end
	if var3 == 10 then
		helper_71543208(chara_no, arg1)
	end
	if var3 == 11 then
		helper_22cd0ca2(chara_no, arg1)
	end
	if var3 == 12 then
		var9 = event.get_quest_request_status(0, 0) or var9
		var10 = event.get_quest_request_status(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Bonjour\nEn route pour l'aventure ?")
			var11 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var11 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var11 == 1 then
				helper_a62e48ab(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_de72cef6()
		else
			helper_a62e48ab(chara_no, arg1)
		end
	end
	if var3 == 14 then
		helper_7c8b8b4e(chara_no, arg1)
	end
	if var3 == 15 then
		var12 = event.get_quest_request_status(0, 0) or var12
		var13 = event.get_quest_request_status(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Bonjour\nEn route pour l'aventure ?")
			var14 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var14 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var14 == 1 then
				helper_fd9abc8f(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_de72cef6()
		else
			helper_fd9abc8f(chara_no, arg1)
		end
	end
	if var3 == 16 then
		helper_b0e03639(chara_no, arg1)
	end
	if var3 == 17 then
		helper_aa26cbbb(chara_no, arg1)
	end
	if var3 == 18 then
		var15 = event.get_quest_request_status(0, 0) or var15
		var16 = event.get_quest_request_status(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Bonjour\nEn route pour l'aventure ?")
			var17 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var17 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var17 == 1 then
				helper_ec48f09e(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_de72cef6()
		else
			helper_ec48f09e(chara_no, arg1)
		end
	end
	if var3 == 19 then
		helper_1d33595a(chara_no, arg1)
	end
	if var3 == 20 then
		helper_ccf6981a(chara_no, arg1)
	end
	if var3 == 21 then
		helper_25a2bce4(chara_no, arg1)
	end
	if var3 == 23 then
		helper_c91dac3f(chara_no, arg1)
	end
	if var3 == 24 then
		helper_59d6deef(chara_no, arg1)
	end
	if var3 == 25 then
		helper_c155b08f(chara_no, arg1)
	end
	if var3 == 33 then
		var18 = event.get_quest_request_status(0, 8) or var18
		active_chr_no = event.get_playable_character() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Je veux faire des achats\nBonjour")
			var20 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var20 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var20 == 1 then
				helper_b3f7f172(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		helper_de72cef6()
	end
	if var3 == 1 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"J'ai du mal depuis quelque temps [UNI00e0]\nvoir les toutes petites pi[UNI00e8]ces.<page>Je dois commencer [UNI00e0] me\nfaire un peu vieux..."
			)
		else
			event.open_message_window_2(
				0,
				"Revoir le chemin de fer Noirpierre\ntraverser tout le continent est un\nr[UNI00ea]ve que Need et moi partageons.<page>On peut compter sur ton aide, hein ?"
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 2 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(0, "Quand je n'ai rien\n[UNI00e0] faire, je deviens de\nmauvaise humeur.")
		else
			event.open_message_window_2(
				0,
				"S'ils d[UNI00e9]couvrent de la zelmite, je\nserai tr[UNI00e8]s occup[UNI00e9] moi aussi. Ouais,\nje vais creuser jour et nuit !!!"
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 6 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"Tu sais, j'ai plein de bestioles\ndans les plumes en ce moment,\net [UNI00e7]a me gratte terriblement."
			)
		else
			event.open_message_window_2(
				0,
				"Tu peux passer ton temps [UNI00e0] chercher\nde la zelmite si tu veux. Mais fais\nattention [UNI00e0] toi, gamin."
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 13 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"J'adore l'odeur de la poudre [UNI00e0]\ncanon ! C'est un boulot id[UNI00e9]al.<page>Malheureusement, j'ai un patron\ntr[UNI00e8]s ent[UNI00ea]t[UNI00e9] et vieille [UNI00e9]cole.\nM'enfin."
			)
		else
			event.open_message_window_2(0, "[UNI00c7]a t'emballe vraiment cette\naventure, hein ?")
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 22 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"[UNI00c0] part le fait que j'ai d[UNI00e9]but[UNI00e9]\nma vie sur une toile, je ne\nsuis pas diff[UNI00e9]rente des autres."
			)
		else
			event.open_message_window_2(0, "Cette Mine de zelmite ne m'inspire\npas confiance. Sois prudent, OK ?")
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	event.set_villager_ai_enabled(1, chara_no)
end

return helper_643a4efa
