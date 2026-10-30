--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_4b332c29(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Perch[UNI00e9] mi manca tanto la luna?<page>Magari [UNI00e8] da l[UNI00ec] che\nvengo...")
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_4b332c29
