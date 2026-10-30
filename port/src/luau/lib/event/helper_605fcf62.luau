--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_605fcf62(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Made any good discoveries?<page>You know, while you're making discoveries\nabout machines and devices,\nI'm making discoveries about cooking.<page>Every day, I'm researching how to make\ndelicious foods that no one's ever\ntasted before."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_605fcf62
