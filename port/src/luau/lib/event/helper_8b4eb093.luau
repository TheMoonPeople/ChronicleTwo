--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_8b4eb093(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"...<page>Ah! Salve!\nSono un po' sorda, ultimamente.<page>Non riesco a capire cosa dici\nse non parli lentamente."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_8b4eb093
