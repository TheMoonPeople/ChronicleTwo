--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_d8d03c99(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(0, "Und trenne immer sch[UNI00f6]n den\nM[UNI00fc]ll und denk an die M[UNI00fc]llabfuhr, ja?")
	else
		event.open_message_window_2(
			0,
			"Nur so zwischen dir und mir - die\nZelmit-Mine ist nicht ungef[UNI00e4]hrlich.\nMach keine Dummheiten."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_d8d03c99
