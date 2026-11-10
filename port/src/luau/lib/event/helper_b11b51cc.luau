--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_b11b51cc(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"The most important thing in business\nis having the trust of your customers.<page>It's something you must\nnever take for granted."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_b11b51cc
