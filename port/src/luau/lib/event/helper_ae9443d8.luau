--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_ae9443d8(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"This town is too peaceful, and\nthere's just no work for me.<page>Of course, I know that's a good thing,\nbut still..."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_ae9443d8
