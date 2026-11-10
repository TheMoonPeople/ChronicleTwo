--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_45a6628c()
	local var1: f32 = 0
	local var4: f32 = 0
	local var7: f32 = 0
	var1 = vm.f32(var1 + 100.0)
	var4 = vm.f32(var4 - vm.f32(1.4))
	var7 = vm.f32(var7 + vm.f32(1.4))
end

return helper_45a6628c
