--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_61d4ffb7(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Cette ville est tr[UNI00e8]s calme, du coup\nje n'ai pas de travail du tout.<page>[UNI00c9]videmment, je sais que c'est une\nbonne chose, mais quand m[UNI00ea]me..."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_61d4ffb7
