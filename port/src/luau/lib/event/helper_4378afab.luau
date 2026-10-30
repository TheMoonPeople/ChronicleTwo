--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_4378afab(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Angeln ist mein Hobby.<page>Ich tr[UNI00e4]ume davon, einmal einen\nMardan Garayan zu fangen.<page>Ich respektiere nur Leute,\ndie gro[UNI00df]e Fische fangen."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_4378afab
