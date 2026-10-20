--!strict
-- Shared event helper used by 40 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2a3d6ad0 = require("@lib/event/helper_2a3d6ad0")

--- Helper function.
local function helper_6e94ffcc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2a3d6ad0(arg0, vm.ftoi(arg1), -1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_2a3d6ad0(arg0, vm.ftoi(arg1), -1)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_6e94ffcc
