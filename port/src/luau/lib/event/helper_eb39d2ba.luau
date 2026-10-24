--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_eb39d2ba(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"You're good with machines,\nbut don't you think it's time for\nyou to start learning about mining?"
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_eb39d2ba
