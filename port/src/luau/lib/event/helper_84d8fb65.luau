--!strict
-- Shared event helper used by 540 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_18fabe70 = require("@lib/event/helper_18fabe70")
local helper_1e1681bf = require("@lib/event/helper_1e1681bf")
local helper_8433e29e = require("@lib/event/helper_8433e29e")

--- Helper function.
local function helper_84d8fb65(arg0: s32, arg1: any, arg2: any)
	local var10: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	var27 = var10
	var28 = var15
	var29 = vm.f32(var28 - var27)
	var30 = var13
	var31 = var16
	var32 = vm.f32(var31 - var30)
	var33 = 0.0
	var34 = vm.f32(helper_18fabe70(helper_8433e29e(var29), helper_8433e29e(var32)) * 8.0)
	var35 = helper_1e1681bf(0.0, var29, var33, var34)
	var35 = vm.f32(var35 + var27)
	var36 = helper_1e1681bf(0.0, var32, var33, var34)
	var36 = vm.f32(var36 + var30)
	local _ = var33 < var34
	var33 = vm.f32(var33 + 1.0)
end

return helper_84d8fb65
