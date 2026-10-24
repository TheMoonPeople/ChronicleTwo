--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1e1681bf = require("@lib/event/helper_1e1681bf")
local helper_8433e29e = require("@lib/event/helper_8433e29e")

--- Helper function.
local function helper_5e37bf7b(arg0: s32, arg1: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	var6 = vm.f32(arg1 - var5)
	local _ = var6 < vm.f32(-3.1415927)
	var6 = vm.f32(var6 + vm.f32(6.2831855))
	local _ = vm.f32(3.1415927) < var6
	var6 = vm.f32(var6 - vm.f32(6.2831855))
	var7 = 0.0
	var8 = vm.f32(helper_8433e29e(var6) * 8.0)
	var9 = helper_1e1681bf(0.0, var6, var7, var8)
	var9 = vm.f32(var9 + var5)
	local _ = var7 < var8
	var7 = vm.f32(var7 + 1.0)
end

return helper_5e37bf7b
