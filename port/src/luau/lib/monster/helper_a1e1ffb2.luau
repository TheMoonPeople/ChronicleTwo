--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b6e560f = require("@lib/monster/helper_0b6e560f")
local helper_362382c7 = require("@lib/monster/helper_362382c7")
local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_a1e1ffb2(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	helper_362382c7(arg2, arg0)
	helper_442b9962()
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(vm.f32(arg2 * vm.f32(0.017453292))) * arg3))
	pos_y = pos_y
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(vm.f32(arg2 * vm.f32(0.017453292))) * arg3))
	local _ = helper_0b6e560f(pos_x, pos_y, pos_z, arg1, arg4, arg5, arg6)
end

return helper_a1e1ffb2
