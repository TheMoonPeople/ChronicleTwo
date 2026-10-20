--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_378193a4 = require("@lib/event/helper_378193a4")
local helper_6fa67f47 = require("@lib/event/helper_6fa67f47")

--- Helper function.
local function helper_3454cb4e(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_378193a4(1, 4)
			helper_6fa67f47(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_378193a4(1, 4)
	helper_6fa67f47(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_3454cb4e
