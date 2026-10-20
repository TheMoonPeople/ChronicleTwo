--!strict
-- Shared event helper used by 45 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f489ae28 = require("@lib/event/helper_f489ae28")

--- Helper function.
local function helper_1f6c4dc7(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f489ae28(arg0, vm.ftoi(arg1), -1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_f489ae28(arg0, vm.ftoi(arg1), -1)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_1f6c4dc7
