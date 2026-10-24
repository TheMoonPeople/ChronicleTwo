--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a26e309a = require("@lib/event/helper_a26e309a")

--- Helper function.
local function helper_ecae3b61()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a26e309a()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_a26e309a()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_ecae3b61
