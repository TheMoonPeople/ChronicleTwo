--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_74aa7964(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f1049565(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Pourquoi la lune me manque-t-elle<page>tant ? Je me demande si je ne\nviendrais pas de l[UNI00e0]-bas des fois..."
	)
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_74aa7964
