--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_18fabe70 = require("@lib/event/helper_18fabe70")
local interpolate = require("@lib/event/interpolate")
local negate = require("@lib/event/negate")

--- Helper function.
local function helper_c8cc3030(arg0: s32, arg1: any, arg2: any)
	local var3: f32 = 0
	local var4: f32 = 0
	local var12: f32 = 0
	local var15: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	var30 = var12
	var31 = var3
	var32 = vm.f32(var31 - var30)
	local _ = var32 < vm.f32(-3.1415927)
	var32 = vm.f32(var32 + vm.f32(6.2831855))
	local _ = vm.f32(3.1415927) < var32
	var32 = vm.f32(var32 - vm.f32(6.2831855))
	var34 = var15
	var35 = var4
	var36 = vm.f32(var35 - var34)
	local _ = var36 < vm.f32(-3.1415927)
	var36 = vm.f32(var36 + vm.f32(6.2831855))
	local _ = vm.f32(3.1415927) < var36
	var36 = vm.f32(var36 - vm.f32(6.2831855))
	var38 = 0.0
	var39 = vm.f32(helper_18fabe70(negate(var32), negate(var36)) * 8.0)
	var33 = interpolate(0.0, var32, var38, var39)
	var33 = vm.f32(var33 + var30)
	var37 = interpolate(0.0, var36, var38, var39)
	var37 = vm.f32(var37 + var34)
	local _ = var38 < var39
	var38 = vm.f32(var38 + 1.0)
end

return helper_c8cc3030
