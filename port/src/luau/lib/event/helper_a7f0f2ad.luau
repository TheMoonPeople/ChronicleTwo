--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_a7f0f2ad(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"[UNI00bf]Por qu[UNI00e9] echo tanto de menos la luna?<page>A lo mejor yo he venido\nde all[UNI00ed]..."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_a7f0f2ad
