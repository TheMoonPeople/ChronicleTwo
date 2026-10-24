--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_4fbbcd13(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Mein Laden ist spezialisiert\nauf Klingen.<page>Ich habe auch Schusswaffen,\naber eigentlich mag\nich sie nicht besonders."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_4fbbcd13
