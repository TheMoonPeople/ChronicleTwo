--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_5dbe958b(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Hier ist zu. Geh doch stattdessen\nzum Laden meines alten Herrn.<page>Achte auf die K[UNI00fc]rbisse. Du siehst\nsie bestimmt. Einfach die Leiter rauf."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_5dbe958b
