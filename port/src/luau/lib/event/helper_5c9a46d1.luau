--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_64bcf845 = require("@lib/event/helper_64bcf845")

--- Helper function.
local function helper_5c9a46d1()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_64bcf845()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_64bcf845()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_5c9a46d1
