--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")

--- Helper function.
local function helper_94de8d8f(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"ファブリースの民は、\n自分より秀でた人でないと、\nたのみを聞く事はありません。"
	)
	helper_1c04a0eb(arg0, -1, 0, 0)
end

return helper_94de8d8f
