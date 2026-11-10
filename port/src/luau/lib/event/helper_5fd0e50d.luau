--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_af068bc2 = require("@lib/event/helper_af068bc2")

--- Helper function.
local function helper_5fd0e50d(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 1 then
			helper_af068bc2(arg0, arg1)
			return
		end
		event.apply_message_window_preset(0, 0)
		event.open_message_window_2(
			0,
			"I can't believe it. I never\nreally imagined you could get them.<page>That's really something, Max!"
		)
	else
		event.open_message_window_2(0, "Hey! How goes the Zelmite hunt?\nIf there's anything I can do,\njust gimme a holler.")
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_5fd0e50d
