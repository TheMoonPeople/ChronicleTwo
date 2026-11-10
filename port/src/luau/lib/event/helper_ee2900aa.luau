--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_ee2900aa(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Por qu[UNI00e9] echo tanto de menos la luna?<page>A lo mejor yo he venido\nde all[UNI00ed]..."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_ee2900aa
