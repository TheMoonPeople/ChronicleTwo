--!strict
-- Shared event helper used by 108 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_9a2a4514(arg0: f32)
	local var1: s32 = 0
	local var2: f32 = 0
	var1 = 0
	arg0 = vm.f32(arg0 + vm.f32(0.18))
	local _ = var1 < 10
	var1 = var1 + 1
	var1 = 0
	var2 = vm.f32(0.06)
	arg0 = vm.f32(arg0 - var2)
	var2 = vm.f32(var2 - vm.f32(0.008))
	local _ = var1 <= 6
	var1 = var1 + 1
	var1 = 0
	var2 = vm.f32(0.005)
	arg0 = vm.f32(arg0 + var2)
	var2 = vm.f32(var2 + vm.f32(0.01))
	local _ = var1 <= 8
	var1 = var1 + 1
	var1 = 0
	var2 = vm.f32(0.03)
	arg0 = vm.f32(arg0 - var2)
	var2 = vm.f32(var2 - vm.f32(0.005))
	local _ = var1 <= 6
	var1 = var1 + 1
	var1 = 0
	var2 = vm.f32(0.01)
	arg0 = vm.f32(arg0 + var2)
	var2 = vm.f32(var2 + vm.f32(0.01))
	local _ = var1 <= 4
	var1 = var1 + 1
	return arg0
end

return helper_9a2a4514
