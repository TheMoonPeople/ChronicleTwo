--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_88372fe7(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Questa citt[UNI00e0] [UNI00e8] troppo tranquilla,\nnon c'[UNI00e8] lavoro per me.<page>Non che mi lamenti,\neppure..."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_88372fe7
