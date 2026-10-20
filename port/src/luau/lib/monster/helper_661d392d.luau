--!strict
-- Shared monster helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f68d3245 = require("@lib/monster/helper_f68d3245")

--- Helper function.
local function helper_661d392d(arg0: s32, arg1: any)
	return helper_f68d3245(vm.f32(arg0 * vm.f32(0.017453292)), arg1 * vm.f32(0.017453292))
end

return helper_661d392d
