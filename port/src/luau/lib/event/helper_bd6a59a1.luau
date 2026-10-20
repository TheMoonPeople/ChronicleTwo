--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_836d3926 = require("@lib/event/helper_836d3926")
local helper_b8b453c5 = require("@lib/event/helper_b8b453c5")

--- Helper function.
local function helper_bd6a59a1(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_836d3926(1, 4)
			helper_b8b453c5(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_836d3926(1, 4)
	helper_b8b453c5(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_bd6a59a1
