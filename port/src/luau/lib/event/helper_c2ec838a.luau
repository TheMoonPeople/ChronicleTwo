--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_c2ec838a(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"Las armas las carga el diablo.<page>Ten cuidado con\nellas o podr[UNI00ed]as hacerte da[UNI00f1]o."
		)
	else
		event.open_message_window_2(
			0,
			"A partir de ahora voy a ayudar\na Need y Cedric a reconstruir el mundo.\nTenemos que trabajar juntos."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_c2ec838a
