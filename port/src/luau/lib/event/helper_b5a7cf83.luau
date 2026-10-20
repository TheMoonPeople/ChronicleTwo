--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_b5a7cf83(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Depuis ton arriv[UNI00e9]e, j'ai\n[UNI00e0] peine vu Max. Je ne sais pas\n[UNI00e0] quoi tu t'amuses, mais j'esp[UNI00e8]re<page>que tu ne te sers pas de lui."
	)
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_b5a7cf83
