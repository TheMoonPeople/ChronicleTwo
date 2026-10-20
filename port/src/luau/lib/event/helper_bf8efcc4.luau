--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_065641b0 = require("@lib/event/helper_065641b0")
local helper_1adc7a8f = require("@lib/event/helper_1adc7a8f")

--- Helper function.
local function helper_bf8efcc4(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1adc7a8f(1, 4)
			helper_065641b0(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_1adc7a8f(1, 4)
	helper_065641b0(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_bf8efcc4
