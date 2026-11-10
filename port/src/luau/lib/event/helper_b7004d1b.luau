--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_b7004d1b(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(0, "Qu'est-ce que [UNI00e7]a donne ?<page>Sois honn[UNI00ea]te avec moi !")
	else
		event.open_message_window_2(0, "Je prie pour ta s[UNI00e9]curit[UNI00e9]...")
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_b7004d1b
