--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6a980af5 = require("@lib/event/helper_6a980af5")

--- Helper function.
local function helper_4e95a934()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6a980af5()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_6a980af5()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_4e95a934
