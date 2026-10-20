--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_cea0e31f(arg0: s32)
	local timer: s32 = 0
	timer = monster.GetTimer() or timer
	monster.VPush(vm.i32(30 + arg0), timer)
end

return helper_cea0e31f
