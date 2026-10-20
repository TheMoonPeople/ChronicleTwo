--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_8f85c9fe(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"La tienda est[UNI00e1] cerrada. Tendr[UNI00e1]s que\nir a la tienda de mi padre.<page>Busca las calabazas. Est[UNI00e1]n a la vista,\nencima de la escalera."
	)
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_8f85c9fe
