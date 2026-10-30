--!strict
-- Shared event helper used by 70 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")

--- Helper function.
local function helper_74f9cdb5()
	local var3: s32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local _ = helper_7d54f41c(0, 2002, 8, 256, 208, 2, 1)
	local _ = helper_7d54f41c(0, -1, 8, 256, 208, 2, 1)
	var3 = 0
	var17 = vm.f32(var17 + 1.0)
	var19 = vm.f32(var19 + 1.0)
	var3 = var3 + 1
	var20 = vm.f32(var20 - vm.f32(3.1415927))
	var10 = vm.f32(vm.f32(vm.sin(var20) * 100.0) + var10)
	var11 = vm.f32(var11 + 30.0)
	var12 = vm.f32(vm.f32(vm.cos(var20) * 100.0) + var12)
end

return helper_74f9cdb5
