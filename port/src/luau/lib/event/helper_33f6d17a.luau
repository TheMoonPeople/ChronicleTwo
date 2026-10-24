--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_deea560b = require("@lib/event/helper_deea560b")
local helper_f7f0d19e = require("@lib/event/helper_f7f0d19e")

--- Helper function.
local function helper_33f6d17a(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_deea560b(1, 4)
			helper_f7f0d19e(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_deea560b(1, 4)
	helper_f7f0d19e(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_33f6d17a
