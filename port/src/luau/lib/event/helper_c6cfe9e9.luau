--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_deeb8511 = require("@lib/event/helper_deeb8511")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_c6cfe9e9()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	if now_party_chara_id == 2 then
		set_window_mode(0, 1)
		event.open_message_window_2(0, "Si no estoy ocupado\nen algo,\nme pongo de mal humor.")
		var2 = event.get_chapter() or var2
		flag = event.get_save_flag(448) or flag
		if var2 == 4 and flag == 0 then
			event.open_message_window_2(
				0,
				"[UNI00a1]Ning[UNI00fa]n puente ni carretera\nest[UNI00e1] abierto! [UNI00bf]Qu[UNI00e9]\npensabas? Pero bueno..."
			)
		end
		if var2 == 3 then
			event.open_message_window_2(
				0,
				"[UNI00bf]No ves que si\nno haces ejercicio todos los d[UNI00ed]as te quedas\nanquilosado? Pues igual les pasa a las m[UNI00e1]quinas."
			)
		end
		helper_1c04a0eb(var0, -1, 0, 0)
	else
		var4 = event.get_triggered_event_data_2(13) or var4
		helper_deeb8511(var4, 2)
	end
end

return helper_c6cfe9e9
