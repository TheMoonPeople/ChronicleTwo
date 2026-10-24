--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_b62118b5(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Cette ville est tr[UNI00e8]s calme, du coup\nje n'ai pas de travail du tout.<page>[UNI00c9]videmment, je sais que c'est une\nbonne chose, mais quand m[UNI00ea]me..."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_b62118b5
