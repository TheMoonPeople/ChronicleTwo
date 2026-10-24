--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_0f128988(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"La tienda est[UNI00e1] cerrada. Tendr[UNI00e1]s que\nir a la tienda de mi padre.<page>Busca las calabazas. Est[UNI00e1]n a la vista,\nencima de la escalera."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_0f128988
