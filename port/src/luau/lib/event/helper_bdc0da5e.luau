--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_bdc0da5e(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"Vielleicht liegt's an mir, aber\ndu erinnerst mich sehr an Elena.<page>Ich wei[UNI00df] nicht, woran es liegt,\naber du bist anders als die\nanderen Leute in der Stadt."
		)
	else
		event.open_message_window_2(0, "Die Zelmit-Mine ist unheimlich.\nDort musst du immer\nwachsam bleiben.")
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_bdc0da5e
