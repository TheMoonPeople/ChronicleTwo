--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_e52c0bd6(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"Maybe I'm the only one to think this, but something\nabout you really reminds me of Elena.<page>I don't know what it is, but you have a certain quality\nthat seems different to other people in this town."
		)
	else
		event.open_message_window_2(0, "Zelmite Mine is a very scary place.\nYou must be sure to never let\nyour guard down.")
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_e52c0bd6
