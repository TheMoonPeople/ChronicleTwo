--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_83ea1bf2(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Tu es dou[UNI00e9] avec les machines, mais\nil serait temps d'apprendre le b.a.\n-ba de l'exploitation mini[UNI00e8]re..."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_83ea1bf2
