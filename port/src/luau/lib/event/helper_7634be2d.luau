--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_7634be2d(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Das Wichtigste in diesem Gesch[UNI00e4]ft\nist das Vertrauen der Kunden.<page>Das darf man nie\neinfach voraussetzen."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_7634be2d
