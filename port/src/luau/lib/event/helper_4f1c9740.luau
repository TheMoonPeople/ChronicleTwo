--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_4f1c9740(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"Um, I don't need to know right this instant,\nbut maybe one day you could let me\nin on your fishing tricks."
		)
	else
		event.open_message_window_2(
			0,
			"I can't wait to check out all the\nnew fishing spots all over the\nworld. It's gonna be so fun."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_4f1c9740
