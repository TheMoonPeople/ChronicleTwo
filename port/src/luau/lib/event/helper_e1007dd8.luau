--!strict
-- Shared event helper used by 108 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_e1007dd8(arg0: f32)
	local var1: s32 = 0
	var1 = 0
	arg0 = vm.f32(0.04)
	arg0 = vm.f32(arg0 + vm.f32(0.13))
	local _ = var1 <= 10
	var1 = var1 + 1
	return arg0
end

return helper_e1007dd8
