--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_efde1e95(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"...<page>Ah! Hallo!\nIch h[UNI00f6]re seit Kurzem schwer.<page>Ich verstehe dich nur, wenn\ndu ganz langsam sprichst."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_efde1e95
