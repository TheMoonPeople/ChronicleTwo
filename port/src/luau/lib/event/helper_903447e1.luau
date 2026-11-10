--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_903447e1(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"En affaires, il est essentiel de\ngagner la confiance de tes clients.<page>C'est quelque chose qu'il ne faut\njamais consid[UNI00e9]rer comme acquis."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_903447e1
