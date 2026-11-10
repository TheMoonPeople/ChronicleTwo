--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_6b3529e5(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Quel que soit ton probl[UNI00e8]me,\nn'h[UNI00e9]site pas [UNI00e0] venir me voir\nen premier.")
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_6b3529e5
