--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_b99d7c77(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"My hobby is fishing.<page>It's my dream to catch a Mardan Karayan.<page>I only respect people who catch big fish."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_b99d7c77
