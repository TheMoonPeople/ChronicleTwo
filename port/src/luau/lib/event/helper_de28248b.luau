--!strict
-- Shared event helper used by 54 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local interpolate = require("@lib/event/interpolate")

--- Helper function.
local function helper_de28248b(arg0: s32, arg1: f32)
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
	var13 = interpolate(0.0, var12, var14, var15)
	var13 = vm.f32(var13 + var10)
	local _ = var14 <= var15
	var14 = vm.f32(var14 + 1.0)
end

return helper_de28248b
