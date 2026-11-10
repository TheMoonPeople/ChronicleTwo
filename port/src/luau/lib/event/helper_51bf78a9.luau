--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_51bf78a9(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"No te olvides de reciclar y\nsaca la basura los d[UNI00ed]as apropiados. [UNI00bf]Te acordar[UNI00e1]s?"
		)
	else
		event.open_message_window_2(
			0,
			"F[UNI00ed]jate bien en lo que te digo:\ns[UNI00e9] que la Mina de Zelmite es un lugar\npeligroso. No hagas tonter[UNI00ed]as."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_51bf78a9
