--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_085d9936(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Mon magasin est sp[UNI00e9]cialis[UNI00e9] en\narmes blanches.<page>J'ai quelques armes [UNI00e0] feu,\nmais [UNI00e7]a n'est pas\nvraiment mon truc."
	)
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_085d9936
