--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_30c30f62 = require("@lib/event/helper_30c30f62")

--- Helper function.
local function helper_c7771b43(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"[UNI00bf]Has hecho alg[UNI00fa]n gran descubrimiento?<page>Mientras t[UNI00fa] descubres\nm[UNI00e1]quinas y chismes,\nyo invento platos.<page>Todos los d[UNI00ed]as investigo para\npreparar comida que nadie haya\nprobado a[UNI00fa]n."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_c7771b43
