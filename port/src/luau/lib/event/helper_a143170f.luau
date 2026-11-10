--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_a143170f(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"La tienda est[UNI00e1] cerrada. Tendr[UNI00e1]s que\nir a la tienda de mi padre.<page>Busca las calabazas. Est[UNI00e1]n a la vista,\nencima de la escalera."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_a143170f
