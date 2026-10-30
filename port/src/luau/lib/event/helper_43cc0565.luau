--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_43cc0565(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Diese Stadt ist zu friedlich -\nich hab nichts zu tun.<page>Ich wei[UNI00df] nat[UNI00fc]rlich, dass das gut\nist, aber trotzdem ..."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_43cc0565
