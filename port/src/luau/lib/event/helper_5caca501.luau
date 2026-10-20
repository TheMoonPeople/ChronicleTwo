--!strict
-- Shared event helper used by 9 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1050f840 = require("@lib/event/helper_1050f840")
local helper_18063f80 = require("@lib/event/helper_18063f80")

--- Helper function.
local function helper_5caca501(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1050f840(1, 4)
			helper_18063f80(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_1050f840(1, 4)
	helper_18063f80(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_5caca501
