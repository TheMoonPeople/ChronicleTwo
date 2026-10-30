--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_13cc925c(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Desde que has venido,\napenas he visto a Max.\nNo s[UNI00e9] qu[UNI00e9] pretendes,<page>pero espero que no lo est[UNI00e9]s utilizando."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_13cc925c
