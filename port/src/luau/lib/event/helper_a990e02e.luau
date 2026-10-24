--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_a990e02e(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"The shop's closed. You'll have to\ngo to my old man's shop instead.<page>Look for the pumpkins. I'm sure you'll see 'em.\nIt's just at the top of that ladder."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_a990e02e
