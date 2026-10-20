--!strict
-- Shared monster helper used by 9 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_32147814(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: f32 = 0
	var4 = monster.GetHigh2(arg0, arg1, arg2) or var4
	arg3 = vm.f32(arg1 - var4)
	return arg3
end

return helper_32147814
