--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_a1ca3b2f(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(0, "Le armi non sono giocattoli.<page>Attento a come le usi o\nrischi di farti male.")
	else
		event.open_message_window_2(
			0,
			"D'ora in poi aiuter[UNI00f2] Need e Cedric\na ricostruire il mondo. Dobbiamo\ntutti darci da fare."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_a1ca3b2f
