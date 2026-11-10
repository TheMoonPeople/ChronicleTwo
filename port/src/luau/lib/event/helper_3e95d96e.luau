--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_3e95d96e(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(0, "Wie passt es denn?<page>Sag die Wahrheit!")
	else
		event.open_message_window_2(0, "Ich bete f[UNI00fc]r deine Sicherheit ...")
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_3e95d96e
