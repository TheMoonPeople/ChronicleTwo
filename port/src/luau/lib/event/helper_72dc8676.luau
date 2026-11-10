--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_72dc8676(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"Sar[UNI00f2] l'unico a pensarla cos[UNI00ec], ma\nqualcosa in te mi ricorda Elena.<page>Sei speciale rispetto agli altri\nabitanti di questa citt[UNI00e0]."
		)
	else
		event.open_message_window_2(
			0,
			"La Miniera di Zelmite [UNI00e8] un posto\nmolto pericoloso. Non si deve\nmai abbassare la guardia."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_72dc8676
