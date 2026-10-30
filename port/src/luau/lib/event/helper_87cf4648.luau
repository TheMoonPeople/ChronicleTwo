--!strict
-- Shared event helper used by 108 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02bd2840 = require("@lib/event/helper_02bd2840")

--- Helper function.
local function helper_87cf4648(arg0: any)
	local var1: s32 = 0
	local var2: f32 = 0
	var1 = 0
	var2 = 0.0
	var2 = vm.f32(var2 + vm.f32(0.01))
	local _ = var1 <= 5
	var1 = var1 + 1
	local _ = helper_02bd2840()
	var1 = 0
	var2 = vm.f32(var2 - vm.f32(0.004))
	local _ = var1 <= 4
	var1 = var1 + 1
end

return helper_87cf4648
