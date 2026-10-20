--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_390a6696 = require("@lib/event/helper_390a6696")
local helper_e445e2f6 = require("@lib/event/helper_e445e2f6")

--- Helper function.
local function helper_9eef869d(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_390a6696(1, 4)
			helper_e445e2f6(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_390a6696(1, 4)
	helper_e445e2f6(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_9eef869d
