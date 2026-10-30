--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_284f5aeb(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(0, "You're a lot faster\nthan you look.\nYou've surprised me!")
	else
		event.open_message_window_2(0, "If there's anything I can help you\nwith, don't you hesitate to ask.")
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_284f5aeb
