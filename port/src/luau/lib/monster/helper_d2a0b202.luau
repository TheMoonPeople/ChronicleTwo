--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_d2a0b202()
	local timer: s32 = 0
	local value: s32 = 0
	timer = monster.GetTimer() or timer
	value = monster.VPop(5) or value
	timer = vm.i32(timer - value)
	return timer
end

return helper_d2a0b202
