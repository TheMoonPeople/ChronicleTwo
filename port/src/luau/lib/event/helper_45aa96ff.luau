--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_d591a671 = require("@lib/event/helper_d591a671")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_45aa96ff()
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
			"J'adore l'odeur de la poudre [UNI00e0]\ncanon ! C'est un boulot id[UNI00e9]al.<page>Malheureusement, j'ai un patron\ntr[UNI00e8]s ent[UNI00ea]t[UNI00e9] et vieille [UNI00e9]cole.\nM'enfin."
		)
		var2 = event.get_chapter() or var2
		flag = event.get_save_flag(280) or flag
		if var2 == 2 and flag == 0 then
			event.open_message_window_2(0, "Une super bombe et ce rocher\nne sera plus qu'un souvenir.")
		end
		flag_2 = event.get_save_flag(372) or flag_2
		if var2 == 3 and flag_2 == 0 then
			event.open_message_window_2(
				0,
				"N'emp[UNI00ea]che que, faire sauter des\ntrucs, c'est pas rien non plus.\nUne erreur, et tout s'[UNI00e9]croule."
			)
		end
		flag_3 = event.get_save_flag(448) or flag_3
		if var2 == 4 and flag_3 == 0 then
			event.open_message_window_2(
				0,
				"Je suis peut-[UNI00ea]tre expert en\nd[UNI00e9]molition, mais quand il s'agit de\nr[UNI00e9]parer, j'ai deux mains gauches !"
			)
		end
		helper_1c04a0eb(var0, -1, 0, 0)
	else
		var6 = event.get_triggered_event_data_2(13) or var6
		helper_d591a671(var6, 3)
	end
end

return helper_45aa96ff
