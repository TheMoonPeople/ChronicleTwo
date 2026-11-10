--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_33f5143b = require("@lib/event/helper_33f5143b")
local helper_48c10ac3 = require("@lib/event/helper_48c10ac3")
local helper_8ab07f4b = require("@lib/event/helper_8ab07f4b")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_66c9a4b8(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var1 = event.get_triggered_event_data_2(13) or var1
		player_chara = event.get_player_character_slot() or player_chara
		now_map_no = event.get_current_map() or now_map_no
		do
			local out1, out2 = event.get_menu_value_3(6)
			var4 = out1 or var4
			var5 = out2 or var5
		end
		if 0 < var4 then
			return 1
		end
		if var5 == 1 then
			set_window_mode(arg0, 1)
			event.open_message_window_2(arg0, "Ram[UNI00e8]ne-moi plus de scoops ou je ne\npourrai rien te donner !")
			if now_map_no == 22 then
				at = 1
				helper_0ffc2526(arg0, -1, var1, player_chara, 0)
			else
				at = 2
				show_message(arg0, -1, 3, 256, 208)
			end
		end
		if var5 == 2 then
			set_window_mode(arg0, 1)
			event.open_message_window_2(
				arg0,
				"Ton niveau de photographie est\nd[UNI00e9]termin[UNI00e9] par le nombre d'id[UNI00e9]es et\nde scoops que tu as.<page>[UNI00c0] mesure que ton niveau s'am[UNI00e9]liore,\ntu gagnes des trucs supers."
			)
			if now_map_no == 22 then
				at = 3
				helper_0ffc2526(arg0, -1, var1, player_chara, 0)
			else
				at = 4
				show_message(arg0, -1, 3, 256, 208)
			end
		end
		return 0
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_33f5143b(arg0, -1, 3, 256, 208)
			end
			if at <= 2 then
				helper_8ab07f4b(arg0, 1)
				helper_48c10ac3(arg0, -1, var1, player_chara, 0)
			end
			if at <= 3 then
				helper_33f5143b(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

return helper_66c9a4b8
