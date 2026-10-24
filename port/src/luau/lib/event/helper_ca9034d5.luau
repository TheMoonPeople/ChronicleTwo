--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_ca9034d5(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"En affaires, il est essentiel de\ngagner la confiance de tes clients.<page>C'est quelque chose qu'il ne faut\njamais consid[UNI00e9]rer comme acquis."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_ca9034d5
