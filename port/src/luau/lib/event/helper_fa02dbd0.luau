--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_20be1371 = require("@lib/event/helper_20be1371")
local helper_33f5143b = require("@lib/event/helper_33f5143b")
local helper_8ab07f4b = require("@lib/event/helper_8ab07f4b")
local helper_be16759c = require("@lib/event/helper_be16759c")
local helper_e7e9e89d = require("@lib/event/helper_e7e9e89d")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_fa02dbd0(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local argc: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var1 = event.get_triggered_event_data_2(13) or var1
		player_chara = event.get_player_character_slot() or player_chara
		now_map_no = event.get_current_map() or now_map_no
		argc = event.get_owned_item_count(355) or argc
		if argc <= 0 then
			set_window_mode(arg0, 1)
			event.open_message_window_2(arg0, "Tr[UNI00e1]eme una\nNota de Logros, anda.")
			if now_map_no == 22 then
				at = 1
				helper_0ffc2526(arg0, -1, var1, player_chara, 0)
			else
				at = 2
				show_message(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		do
			local out1, out2 = event.get_menu_value_3(5)
			var5 = out1 or var5
			var6 = out2 or var6
		end
		if var5 == var6 then
			set_window_mode(arg0, 1)
			event.open_message_window_2(arg0, "Parece que no quedan\nlogros.")
			if now_map_no == 22 then
				at = 3
				helper_0ffc2526(arg0, -1, var1, player_chara, 0)
			else
				at = 4
				show_message(arg0, -1, 3, 256, 208)
			end
			at = 5
			return helper_e7e9e89d(arg0)
		end
		var7 = event.get_menu_value_2(3) or var7
		if 0 < var7 then
			set_window_mode(arg0, 8)
			event.set_message_number(arg0, 1, var7)
			event.open_message_window_2(arg0, "Yo calculo [Number1] logros m[UNI00e1]s.")
			event.set_message_draw_speed(arg0, 0)
			at = 6
			show_message(arg0, -1, 8, 0, 0)
		end
		set_window_mode(arg0, 1)
		var7 = event.get_menu_value_2(4) or var7
		if var7 <= 0 then
			event.open_message_window_2(
				arg0,
				"[UNI00a1]Oye, t[UNI00ed]o! [UNI00a1]No te relajes!\n[UNI00bf]D[UNI00f3]nde est[UNI00e1]n todas tus nuevos logros Interiores?"
			)
		else
			event.set_message_number(arg0, 1, var7)
			event.open_message_window_2(
				arg0,
				"[UNI00a1]Guau! [UNI00a1]Ya tienes [Number 1] nuevos logros!\n[UNI00a1]Sab[UNI00ed]a que lo llevabas dentro de ti!"
			)
		end
		if now_map_no == 22 then
			at = 7
			helper_0ffc2526(arg0, -1, var1, player_chara, 0)
		else
			at = 8
			show_message(arg0, -1, 3, 256, 208)
		end
		at = 9
		return helper_e7e9e89d(arg0)
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_33f5143b(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 5 then
			if at <= 3 then
				helper_33f5143b(arg0, -1, 3, 256, 208)
			end
			return helper_20be1371(arg0)
		end
		if at <= 9 then
			if at <= 6 then
				helper_8ab07f4b(arg0, 1)
				helper_be16759c(arg0, -1, var1, player_chara, 0)
			end
			if at <= 7 then
				helper_33f5143b(arg0, -1, 3, 256, 208)
			end
			return helper_20be1371(arg0)
		end
		return nil
	end)
end

return helper_fa02dbd0
