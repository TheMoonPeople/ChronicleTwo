--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_85491252(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Das Firbit-Volk gew[UNI00e4]hrt\nnur denen Hilfe,\ndie etwas besser k[UNI00f6]nnen als sie.")
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_85491252
