--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_1459198e(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Mon magasin est sp[UNI00e9]cialis[UNI00e9] en\narmes blanches.<page>J'ai quelques armes [UNI00e0] feu,\nmais [UNI00e7]a n'est pas\nvraiment mon truc."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_1459198e
