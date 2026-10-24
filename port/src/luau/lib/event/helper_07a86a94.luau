--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5adc57de = require("@lib/event/helper_5adc57de")
local helper_bc4bfd47 = require("@lib/event/helper_bc4bfd47")

--- Helper function.
local function helper_07a86a94(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5adc57de(1, 4)
			helper_bc4bfd47(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_5adc57de(1, 4)
	helper_bc4bfd47(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_07a86a94
