--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f68d3245 = require("@lib/monster/helper_f68d3245")

--- Helper function.
local function helper_b273522a(arg0: s32, arg1: s32)
	return helper_f68d3245(vm.f32(arg0 * vm.f32(0.017453292)), vm.f32(arg1 * vm.f32(0.017453292)))
end

return helper_b273522a
