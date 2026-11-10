--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_fba6a7db(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"...<page>Ah! Hello!\nI've been a bit deaf lately.<page>I can't make out what you're\nsaying unless you speak slowly."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_fba6a7db
