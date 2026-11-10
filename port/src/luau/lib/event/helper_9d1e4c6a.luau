--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_b390c073 = require("@lib/event/helper_b390c073")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_9d1e4c6a()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var6: s32 = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	if now_party_chara_id == 13 then
		set_window_mode(0, 1)
		event.open_message_window_2(
			0,
			"Che profumo la polvere da sparo!\nSono nato per questo lavoro!<page>Certo, il mio capo [UNI00e8] un terribile\ncapoccione e all'antica.\nMa... pazienza!"
		)
		var2 = event.get_chapter() or var2
		flag = event.get_save_flag(280) or flag
		if var2 == 2 and flag == 0 then
			event.open_message_window_2(0, "Basta una Superbomba e questo\nmasso diventer[UNI00e0] storia!")
		end
		flag_2 = event.get_save_flag(372) or flag_2
		if var2 == 3 and flag_2 == 0 then
			event.open_message_window_2(
				0,
				"Attento, maneggiare esplosivi non\n[UNI00e8] una passeggiata. Una piccola\ndistrazione e butti gi[UNI00f9] la casa!"
			)
		end
		flag_3 = event.get_save_flag(448) or flag_3
		if var2 == 4 and flag_3 == 0 then
			event.open_message_window_2(
				0,
				"Sar[UNI00f2] anche esperto in demolizioni\nma, quando si tratta di riparare\nqualcosa, sono proprio una frana!"
			)
		end
		helper_1c04a0eb(var0, -1, 0, 0)
	else
		var6 = event.get_triggered_event_data_2(13) or var6
		helper_b390c073(var6, 3)
	end
end

return helper_9d1e4c6a
