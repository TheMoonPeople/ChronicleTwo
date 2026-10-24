--!strict
-- Shared event helper used by 42 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_8af09d2f(arg0: f32, arg1: f32, arg2: any)
	local var3: s32 = 0
	local var4: s32 = 0
	local var6: f32 = 0
	local var15: f32 = 0
	local var18: f32 = 0
	local var19: s32 = 0
	local var29: f32 = 0
	local var31: f32 = 0
	var3 = 0
	local _ = var3 < 48
	var3 = var3 + 1
	local _ = var4 == 0
	var4 = 0
	var6 = vm.f32(var6 + 3.0)
	var15 = vm.f32(var15 + 3.0)
	var18 = 100.0
	var19 = 0
	local _ = var3 == 0
	var3 = 0
	var18 = 100.0
	var18 = vm.f32(var18 - var29)
	var31 = vm.f32(20.0 - var29)
	local _ = var18 <= 0.0
	var18 = vm.f32(var18 - var31)
	var3 = var3 + 1
	var4 = var4 + 1
	local _ = vm.imod(var3, 6) == 0
	local _ = vm.imod(var3, 5) == 0
	local _ = var3 >= 31
	local _ = var3 >= 31
	var3 = var3 + 1
	var4 = var4 + 1
	local _ = vm.imod(var3, 6) == 0
	local _ = var3 >= 31
	local _ = vm.imod(var3, 5) == 0
	local _ = var3 < 31
	var3 = var3 + 1
	var4 = var4 + 1
	local _ = var19 < 6
	var19 = var19 + 1
end

return helper_8af09d2f
