--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_b02b3614(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Sei in gamba con le macchine,\nma non credi sia giunto il momento\nd'imparare qualcosa sulle miniere?"
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_b02b3614
