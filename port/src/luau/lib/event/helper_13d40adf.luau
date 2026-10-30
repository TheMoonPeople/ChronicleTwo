--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_13d40adf(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Da quando sei arrivata,\nnon ho pi[UNI00f9] visto Max.\nNon so cos'hai in mente, ma<page>spero tu non lo stia sfruttando."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_13d40adf
