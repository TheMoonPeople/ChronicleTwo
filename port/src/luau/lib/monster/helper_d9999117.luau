--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b6e560f = require("@lib/monster/helper_0b6e560f")

--- Helper function.
local function helper_d9999117(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	monster.GetTargetPos()
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.GetRot()
		var11 = out2 or var11
	end
	var13 = vm.f32(var11 + vm.f32(3.1415927))
	if var13 > vm.f32(3.1415927) then
		var13 = vm.f32(var13 - vm.f32(6.2831855))
	end
	if var13 <= vm.f32(-3.1415927) then
		var13 = vm.f32(var13 + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var13) * var14))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var13) * var14))
	helper_0b6e560f(pos_x, pos_y, pos_z, arg0, arg1, arg2, arg3)
end

return helper_d9999117
