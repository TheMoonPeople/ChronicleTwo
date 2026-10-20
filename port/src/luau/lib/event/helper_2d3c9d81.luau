--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_021e710a = require("@lib/event/helper_021e710a")
local helper_37d1ae51 = require("@lib/event/helper_37d1ae51")

--- Helper function.
local function helper_2d3c9d81(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_021e710a(1, 4)
			helper_37d1ae51(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_021e710a(1, 4)
	helper_37d1ae51(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_2d3c9d81
