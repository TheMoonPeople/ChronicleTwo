--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_6813499c(arg0: f32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	var2 = vm.f32(var2 + 25.0)
	arg0 = vm.f32(arg0 - vm.f32(3.1415927))
	var1 = vm.f32(vm.f32(vm.sin(arg0) * 100.0) + var1)
	var2 = vm.f32(var2 + 0.0)
	var3 = vm.f32(vm.f32(vm.cos(arg0) * 100.0) + var3)
end

return helper_6813499c
