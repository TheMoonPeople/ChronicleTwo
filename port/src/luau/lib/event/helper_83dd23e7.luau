--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")

--- Helper function.
local function helper_83dd23e7(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Salut, Max.\nExcuse-moi, mais je suis\nun peu pris pour l'instant.<page>Je suis en train de r[UNI00e9]cup[UNI00e9]rer des\nmat[UNI00e9]riaux importants qui aideront [UNI00e0]\npr[UNI00e9]server la s[UNI00e9]curit[UNI00e9] de la ville."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Si [UNI00e7]a n'est pas urgent,\n[UNI00e7]a peut attendre jusqu'[UNI00e0] demain ?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

return helper_83dd23e7
