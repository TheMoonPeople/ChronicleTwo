--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_10b1a515 = require("@lib/event/helper_10b1a515")
local helper_2c306c6d = require("@lib/event/helper_2c306c6d")

--- Helper function.
local function helper_fea8c733(arg0: s32, sp: number)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_10b1a515(1, 4)
			helper_2c306c6d(1, vm.i32(60 + arg0), 8, 0, 0, sp + 1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_10b1a515(1, 4)
	helper_2c306c6d(1, vm.i32(60 + arg0), 8, 0, 0, sp + 1)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_fea8c733
