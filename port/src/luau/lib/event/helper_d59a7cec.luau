--!strict
-- Shared event helper used by 120 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1e1681bf = require("@lib/event/helper_1e1681bf")

--- Helper function.
local function helper_d59a7cec(arg0: any, arg1: f32)
	local var6: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	var10 = var6
	var11 = arg1
	var12 = vm.f32(var11 - var10)
	var14 = 0.0
	var15 = 10.0
	var13 = helper_1e1681bf(0.0, var12, var14, var15)
	var13 = vm.f32(var13 + var10)
	local _ = var14 <= var15
	var14 = vm.f32(var14 + 1.0)
end

return helper_d59a7cec
