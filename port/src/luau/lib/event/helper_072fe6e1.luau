--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_072fe6e1(arg0: f32, arg1: f32, arg2: any)
	local var3: s32 = 0
	local var4: s32 = 0
	local var6: f32 = 0
	local var15: f32 = 0
	local var18: f32 = 0
	local var28: f32 = 0
	local var30: f32 = 0
	var3 = 0
	local _ = var3 < 48
	var3 = var3 + 1
	var3 = 0
	local _ = var3 < 32
	var3 = var3 + 1
	local _ = var4 == 0
	local _ = var4 == 2
	var4 = 0
	var6 = vm.f32(var6 + 3.0)
	var15 = vm.f32(var15 + 3.0)
	var18 = 600.0
	var3 = 1
	var18 = vm.f32(var18 - var28)
	var30 = vm.f32(20.0 - var28)
	local _ = var18 <= 0.0
	var18 = vm.f32(var18 - var30)
	var4 = var4 + 1
	local _ = vm.imod(var3, 6) == 0
	var3 = var3 + 1
	var4 = var4 + 1
	local _ = var3 >= 31
	local _ = var3 >= 31
	local _ = vm.imod(var3, 6) == 0
	var3 = var3 + 1
	var4 = var4 + 1
	local _ = var3 >= 31
	local _ = var3 < 31
	local _ = vm.imod(var3, 6) == 0
	var3 = var3 + 1
end

return helper_072fe6e1
