--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_f66a15ec(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Seit du da bist, hab ich\nMax kaum gesehen.\nIch wei[UNI00df] nicht, was du vor hast -<page>ich hoffe, du benutzt\nihn nicht."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_f66a15ec
