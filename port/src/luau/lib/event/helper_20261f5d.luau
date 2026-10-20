--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7ec0dfb1 = require("@lib/event/helper_7ec0dfb1")
local helper_feb439af = require("@lib/event/helper_feb439af")

--- Helper function.
local function helper_20261f5d(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_feb439af(1, 4)
			helper_7ec0dfb1(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_feb439af(1, 4)
	helper_7ec0dfb1(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_20261f5d
