--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_494cae3e = require("@lib/event/helper_494cae3e")
local helper_831c8e6c = require("@lib/event/helper_831c8e6c")

--- Helper function.
local function helper_91766708(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_494cae3e(1, 4)
			helper_831c8e6c(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_494cae3e(1, 4)
	helper_831c8e6c(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_91766708
