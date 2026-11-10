--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_8d1d00e2(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(0, "What use could an old\ngranny like me be?")
	else
		event.open_message_window_2(
			0,
			'When the Blackstone Railroad is\nall done, I\'d just love to \ngo to the "Ends of the Earth".'
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_8d1d00e2
