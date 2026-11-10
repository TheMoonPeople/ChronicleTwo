--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_009e0d5d = require("@lib/event/helper_009e0d5d")
local helper_0785ebae = require("@lib/event/helper_0785ebae")
local helper_12d55230 = require("@lib/event/helper_12d55230")
local helper_13bc3e74 = require("@lib/event/helper_13bc3e74")
local helper_252d1cbb = require("@lib/event/helper_252d1cbb")
local helper_263740b8 = require("@lib/event/helper_263740b8")
local helper_3044d9e4 = require("@lib/event/helper_3044d9e4")
local helper_38b3597b = require("@lib/event/helper_38b3597b")
local helper_41228323 = require("@lib/event/helper_41228323")
local helper_4becd931 = require("@lib/event/helper_4becd931")
local helper_5fa8343f = require("@lib/event/helper_5fa8343f")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_71eeeebd = require("@lib/event/helper_71eeeebd")
local helper_85a64c66 = require("@lib/event/helper_85a64c66")
local helper_88180d1c = require("@lib/event/helper_88180d1c")
local helper_8c405c8d = require("@lib/event/helper_8c405c8d")
local helper_8ee5eddb = require("@lib/event/helper_8ee5eddb")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_b739c76b = require("@lib/event/helper_b739c76b")
local helper_b90b58ec = require("@lib/event/helper_b90b58ec")
local helper_dd10395e = require("@lib/event/helper_dd10395e")
local helper_f0757175 = require("@lib/event/helper_f0757175")
local helper_f1435650 = require("@lib/event/helper_f1435650")
local helper_f2710146 = require("@lib/event/helper_f2710146")
local helper_fa02dbd0 = require("@lib/event/helper_fa02dbd0")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_59c4ee1b(chara_no: s32, arg1: s32)
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
		helper_f2710146(chara_no, arg1)
	end
	if var3 == 5 then
		helper_85a64c66(chara_no, arg1)
	end
	if var3 == 4 then
		flag = event.get_save_flag(104) or flag
		if flag == 0 then
			event.open_message_window_2(0, "D[UNI00e9]jame comprar\nCavar buscando logros")
			var7 = helper_f0757175(chara_no, -1, 2, 0, 0, 0)
			if var7 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var7 == 1 then
				if helper_fa02dbd0(0) ~= 0 then
					event.fade_out_screen(25)
					wait_frames(30)
					event.open_event_menu(6, 33)
					vm.wait(6)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, chara_no)
				return
			else
				helper_263740b8()
			end
		else
			event.open_message_window_2(0, "Hazte amigo m[UNI00ed]o\nCavar buscando logros")
			var8 = helper_f0757175(chara_no, -1, 2, 0, 0, 0)
			if var8 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var8 == 1 then
				if helper_fa02dbd0(0) ~= 0 then
					event.fade_out_screen(25)
					wait_frames(30)
					event.open_event_menu(6, 33)
					vm.wait(11)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, chara_no)
				return
			else
				helper_b90b58ec(chara_no, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_13bc3e74(chara_no, arg1)
	end
	if var3 == 8 then
		helper_41228323(chara_no, arg1)
	end
	if var3 == 10 then
		helper_f1435650(chara_no, arg1)
	end
	if var3 == 11 then
		helper_dd10395e(chara_no, arg1)
	end
	if var3 == 12 then
		var9 = event.get_quest_request_status(0, 0) or var9
		var10 = event.get_quest_request_status(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var11 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var11 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var11 == 1 then
				helper_71eeeebd(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_263740b8()
		else
			helper_71eeeebd(chara_no, arg1)
		end
	end
	if var3 == 14 then
		helper_252d1cbb(chara_no, arg1)
	end
	if var3 == 15 then
		var12 = event.get_quest_request_status(0, 0) or var12
		var13 = event.get_quest_request_status(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var14 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var14 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var14 == 1 then
				helper_0785ebae(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_263740b8()
		else
			helper_0785ebae(chara_no, arg1)
		end
	end
	if var3 == 16 then
		helper_8ee5eddb(chara_no, arg1)
	end
	if var3 == 17 then
		helper_38b3597b(chara_no, arg1)
	end
	if var3 == 18 then
		var15 = event.get_quest_request_status(0, 0) or var15
		var16 = event.get_quest_request_status(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var17 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var17 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var17 == 1 then
				helper_4becd931(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_263740b8()
		else
			helper_4becd931(chara_no, arg1)
		end
	end
	if var3 == 19 then
		helper_8c405c8d(chara_no, arg1)
	end
	if var3 == 20 then
		helper_88180d1c(chara_no, arg1)
	end
	if var3 == 21 then
		helper_3044d9e4(chara_no, arg1)
	end
	if var3 == 23 then
		helper_12d55230(chara_no, arg1)
	end
	if var3 == 24 then
		helper_b739c76b(chara_no, arg1)
	end
	if var3 == 25 then
		helper_009e0d5d(chara_no, arg1)
	end
	if var3 == 33 then
		var18 = event.get_quest_request_status(0, 8) or var18
		active_chr_no = event.get_playable_character() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "D[UNI00e9]jame comprar\nHola")
			var20 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var20 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var20 == 1 then
				helper_5fa8343f(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		helper_263740b8()
	end
	if var3 == 1 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"[UNI00da]ltimamente lo he pasado\nmal viendo todas las peque[UNI00f1]as piezas.<page>Supongo que\nme estoy haciendo viejo..."
			)
		else
			event.open_message_window_2(
				0,
				"Ver en funcionamiento el\nFerrocarril Blackstone por todo el continente es un\nsue[UNI00f1]o com[UNI00fa]n de Need y m[UNI00ed]o.<page>Podemos contar con tu ayuda, [UNI00bf]no?"
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 2 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(0, "Si no estoy ocupado\nen algo,\nme pongo de mal humor.")
		else
			event.open_message_window_2(
				0,
				"Si descubren Zelmite me\nllegar[UNI00e1] el agua al cuello. S[UNI00ed].\n[UNI00a1][UNI00a1]Tendr[UNI00e9] que excavar y excavar sin parar!!"
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 6 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"No s[UNI00e9] por qu[UNI00e9], tengo tantos\nbichos en las plumas [UNI00fa]ltimamente\nque me pica todo."
			)
		else
			event.open_message_window_2(
				0,
				"Est[UNI00e1] bien que pases el tiempo\nintentando encontrar Zelmite, pero\ntampoco exageres."
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 13 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"[UNI00a1]Me encanta el olor de la p[UNI00f3]lvora!\nEste trabajo est[UNI00e1] hecho para m[UNI00ed].<page>Aunque mi jefe\nes un cabez[UNI00f3]n anticuado.\nEn fin..."
			)
		else
			event.open_message_window_2(0, "Te encanta toda esta\naventura, [UNI00bf]verdad?")
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 22 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"Aparte del hecho de que\nmi vida empez[UNI00f3] como cuadro, no soy diferente\na cualquier otra persona."
			)
		else
			event.open_message_window_2(0, "La Mina de Zelmite me da mala espina.\nTen cuidado, [UNI00bf]vale?")
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	event.set_villager_ai_enabled(1, chara_no)
end

return helper_59c4ee1b
