--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_dd8a677b(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"T[UNI00fa] me has ayudado, as[UNI00ed] que te debo una,\npero no me lleves a ning[UNI00fa]n sitio donde haya insectos."
		)
	else
		event.open_message_window_2(
			0,
			"Si el Ferrocarril Blackstone se extiende\npor todo el mundo, quiz[UNI00e1]\nyo deba recorrer todo el mundo tambi[UNI00e9]n."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_dd8a677b
