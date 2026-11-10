--!strict
-- Shared event helper used by 139 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f8bbcc57 = require("@lib/event/helper_f8bbcc57")

--- Helper function.
local function helper_e1d4eb31(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = helper_f8bbcc57(1, vm.i32(arg0 + 70), 8, 256, 208, 2, 1)
	return var2
end

return helper_e1d4eb31
