--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_6fd4648e(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Depuis ton arriv[UNI00e9]e, j'ai\n[UNI00e0] peine vu Max. Je ne sais pas\n[UNI00e0] quoi tu t'amuses, mais j'esp[UNI00e8]re<page>que tu ne te sers pas de lui."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_6fd4648e
