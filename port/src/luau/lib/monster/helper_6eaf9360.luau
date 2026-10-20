--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f68d3245 = require("@lib/monster/helper_f68d3245")

--- Helper function.
local function helper_6eaf9360(arg0: s32, arg1: f32)
	return helper_f68d3245(vm.f32(arg0 * vm.f32(0.017453292)), vm.f32(arg1 * vm.f32(0.017453292)))
end

return helper_6eaf9360
