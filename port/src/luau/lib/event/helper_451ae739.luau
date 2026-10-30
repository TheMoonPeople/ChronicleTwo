--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_451ae739(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(0, "Eres mucho m[UNI00e1]s r[UNI00e1]pido\nde lo que parece.\n[UNI00a1]Me has sorprendido!")
	else
		event.open_message_window_2(0, "Si hay algo en lo que pueda ayudarte\n, no tienes m[UNI00e1]s que ped[UNI00ed]rmelo.")
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_451ae739
