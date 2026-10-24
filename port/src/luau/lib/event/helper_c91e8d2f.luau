--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_c91e8d2f(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	local _ = arg1 == 0
	arg1 = 1
	var3 = 0
	var2 = 1.0
	var2 = vm.f32(var2 - vm.f32(vm.fdiv(1.0, arg1)))
	local _ = var2 < 0.0
	var2 = 0.0
	local _ = var3 < arg1
	var3 = var3 + 1
	var2 = 0.0
	var2 = vm.f32(var2 + vm.f32(vm.fdiv(1.0, arg1)))
	local _ = var2 > 1.0
	var2 = 1.0
	local _ = var3 < arg1
	var3 = var3 + 1
end

return helper_c91e8d2f
