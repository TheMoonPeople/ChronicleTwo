--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_470f8a56 = require("@lib/event/helper_470f8a56")
local helper_68b3b239 = require("@lib/event/helper_68b3b239")

--- Helper function.
local function helper_4131c340(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_470f8a56(1, 4)
			helper_68b3b239(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_470f8a56(1, 4)
	helper_68b3b239(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_4131c340
