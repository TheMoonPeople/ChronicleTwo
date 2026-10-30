--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_c4f7210b(arg0: s32, arg1: any, arg2: s32)
	local var3: s32 = 0
	event.apply_message_window_preset(0, 0)
	var3 = event.get_chapter() or var3
	if arg2 ~= 0 and var3 == 8 then
		event.open_message_window_2(0, "I pray that the world will\nfrom today forever be at peace.")
	else
		event.open_message_window_2(0, "When you're striving for a good cause,\nyou must have wisdom.")
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_c4f7210b
