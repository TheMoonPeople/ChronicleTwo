--!strict
-- Shared event helper used by 9 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_33149f5a = require("@lib/event/helper_33149f5a")

--- Helper function.
local function helper_e1831703()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_33149f5a()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_33149f5a()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_e1831703
