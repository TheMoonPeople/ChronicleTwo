--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_76e63645(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"So you saw me at the circus?\nPretty cool, right?<page>It's not so much a job\nas a hobby of mine."
		)
	else
		event.open_message_window_2(0, "So, what's the scoop? Come across\nany tough guys in that mine yet?")
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_76e63645
