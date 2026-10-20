--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b33603c6 = require("@lib/event/helper_b33603c6")

--- Helper function.
local function helper_002b65d0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Umm. No me hace falta saberlo ahora mismo,\npero quiz[UNI00e1] alg[UNI00fa]n d[UNI00ed]a\npuedas ense[UNI00f1]arme alguno de tus trucos."
		)
	else
		event.MesMake_2(
			0,
			"Tengo unas ganas de\nver todos los lugares para pescar\ndel mundo... S[UNI00ed] que va a ser divertido."
		)
	end
	helper_b33603c6(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_002b65d0
