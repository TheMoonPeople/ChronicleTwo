--!strict
-- Shared event helper used by 30 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d0480c86 = require("@lib/event/helper_d0480c86")

--- Helper function.
local function helper_ed11f95b(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d0480c86(arg0, vm.ftoi(arg1), -1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_d0480c86(arg0, vm.ftoi(arg1), -1)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_ed11f95b
