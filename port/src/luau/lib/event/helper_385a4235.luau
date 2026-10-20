--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_30c30f62 = require("@lib/event/helper_30c30f62")

--- Helper function.
local function helper_385a4235(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Das Firbit-Volk gew[UNI00e4]hrt\nnur denen Hilfe,\ndie etwas besser k[UNI00f6]nnen als sie.")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_385a4235
