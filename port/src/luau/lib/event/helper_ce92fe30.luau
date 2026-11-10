--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_ce92fe30(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(0, "Certo che non vi rifiuterei\nmai niente.")
	else
		event.open_message_window_2(
			0,
			"Un giorno diventer[UNI00f2] il miglior\ncuoco del mondo e allora potrai\nmangiare gratis quanto vorrai."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_ce92fe30
