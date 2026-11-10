--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_d591a671 = require("@lib/event/helper_d591a671")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_00a34ef5()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	if now_party_chara_id == 2 then
		set_window_mode(0, 1)
		event.open_message_window_2(0, "Quand je n'ai rien\n[UNI00e0] faire, je deviens de\nmauvaise humeur.")
		var2 = event.get_chapter() or var2
		flag = event.get_save_flag(448) or flag
		if var2 == 4 and flag == 0 then
			event.open_message_window_2(
				0,
				"Les routes et les ponts sont\nvraiment mal faits ! T'as fait\nn'importe quoi ou quoi ? Pffff."
			)
		end
		if var2 == 3 then
			event.open_message_window_2(
				0,
				"Il faut faire de l'exercice souvent\npour [UNI00e9]viter les courbatures. Pour\nles machines c'est pareil..."
			)
		end
		helper_1c04a0eb(var0, -1, 0, 0)
	else
		var4 = event.get_triggered_event_data_2(13) or var4
		helper_d591a671(var4, 2)
	end
end

return helper_00a34ef5
