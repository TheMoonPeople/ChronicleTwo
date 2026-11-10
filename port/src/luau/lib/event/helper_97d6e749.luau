--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_97d6e749(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Les Firbits ne rendent service\nqu'[UNI00e0] ceux qui leur sont\nsup[UNI00e9]rieurs.")
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_97d6e749
