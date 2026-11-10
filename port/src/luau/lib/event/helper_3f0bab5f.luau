--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_3f0bab5f(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Se te dan bien las m[UNI00e1]quinas,\n[UNI00bf]pero no crees que va siendo hora\nde que aprendas algo de miner[UNI00ed]a?"
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_3f0bab5f
