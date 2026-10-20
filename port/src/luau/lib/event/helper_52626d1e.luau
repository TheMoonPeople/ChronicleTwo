--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02b69e90 = require("@lib/event/helper_02b69e90")
local helper_ea1a74f3 = require("@lib/event/helper_ea1a74f3")

--- Helper function.
local function helper_52626d1e(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_02b69e90(1, 4)
			helper_ea1a74f3(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_02b69e90(1, 4)
	helper_ea1a74f3(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_52626d1e
