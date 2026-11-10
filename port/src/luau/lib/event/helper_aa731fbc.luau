--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_aa731fbc(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(0, "Was n[UNI00fc]tzt dir eine\nalte Oma wie ich?")
	else
		event.open_message_window_2(
			0,
			'Wenn die Blackstone-Bahn fertig\nist, w[UNI00fc]rde ich gern mal\nzu den "Enden der Erde" fahren.'
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_aa731fbc
