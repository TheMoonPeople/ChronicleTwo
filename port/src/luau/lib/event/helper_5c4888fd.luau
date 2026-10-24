--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_5c4888fd(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Il mio negozio [UNI00e8] specializzato\nin lame.<page>Ho delle armi da fuoco,\nma in realt[UNI00e0] non sono\naffatto il mio genere."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_5c4888fd
