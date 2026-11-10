--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_fa64cd57(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Mon hobby [UNI00e0] moi, c'est la p[UNI00ea]che.<page>Je r[UNI00ea]ve de p[UNI00ea]cher un Mardan Garayan.<page>Il faut p[UNI00ea]cher gros pour m'[UNI00e9]pater."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_fa64cd57
