--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_54f42506(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"Pense [UNI00e0] bien trier tes d[UNI00e9]chets et\n[UNI00e0] les jeter les bons jours, OK ?"
		)
	else
		event.open_message_window_2(
			0,
			"Je voulais te dire... je sais que\nla Mine de zelmite est un endroit\ndangereux. Ne prends aucun risque."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_54f42506
