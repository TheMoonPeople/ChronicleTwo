--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_860bdec4(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"Je suis peut-[UNI00ea]tre le seul [UNI00e0] le\npenser, quelque chose en toi me<page>rappelle H[UNI00e9]l[UNI00e8]ne. Un je-ne-sais-\nquoi qui te distingue des autres."
		)
	else
		event.open_message_window_2(0, "La Mine de zelmite est un endroit\nterrifiant. Reste toujours sur\ntes gardes.")
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_860bdec4
