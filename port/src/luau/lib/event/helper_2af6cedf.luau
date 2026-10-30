--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_2af6cedf(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"...<page>[UNI00a1]Ah! [UNI00a1]Hola!\n[UNI00da]ltimamente no oigo muy bien.<page>No te entiendo si no\nme hablas m[UNI00e1]s despacio."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_2af6cedf
