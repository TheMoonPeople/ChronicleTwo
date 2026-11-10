--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_4bada87e = require("@lib/event/helper_4bada87e")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_2695d6f0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 1 then
			helper_4bada87e(arg0, arg1)
			return
		end
		event.open_message_window_2(0, "Don't go anywhere too\ndangerous.")
	else
		event.open_message_window_2(0, "At long last the Blackstone\nRailroad takes on the world.\nIt's so exciting!")
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_2695d6f0
