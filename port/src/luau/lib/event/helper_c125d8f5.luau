--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_c125d8f5(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"Je n'aime pas trop voir les femmes\nmanier des [UNI00e9]p[UNI00e9]es. Pour moi, une<page>femme doit [UNI00ea]tre plus f[UNI00e9]minine.\nComme Ad[UNI00e8]le, par exemple."
		)
	else
		event.open_message_window_2(0, "Si je peux t'aider en quoi que ce\nsoit, n'h[UNI00e9]site pas [UNI00e0] me demander.")
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_c125d8f5
