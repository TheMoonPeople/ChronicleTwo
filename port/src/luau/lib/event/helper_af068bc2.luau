--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_af068bc2(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Since you came along, I've\nhardly seen Max at all.\nI don't know what you're up to,<page>but I hope you're not using him."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_af068bc2
