--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_b937768e(arg0: s32)
	local timer: s32 = 0
	local value: s32 = 0
	timer = monster.GetTimer() or timer
	value = monster.VPop(vm.i32(30 + arg0)) or value
	timer = vm.i32(timer - value)
	return timer
end

return helper_b937768e
