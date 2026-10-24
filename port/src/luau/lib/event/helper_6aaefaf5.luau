--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_6aaefaf5(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Questa citt[UNI00e0] [UNI00e8] troppo tranquilla,\nnon c'[UNI00e8] lavoro per me.<page>Non che mi lamenti,\neppure..."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_6aaefaf5
