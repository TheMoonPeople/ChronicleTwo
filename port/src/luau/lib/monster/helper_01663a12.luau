--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b6e560f = require("@lib/monster/helper_0b6e560f")

--- Helper function.
local function helper_01663a12(arg0: f32, arg1: f32, arg2: f32, arg3: s32, arg4: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	var15 = 300.0
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.GetRot()
		var12 = out2 or var12
	end
	if arg3 ~= 0 then
		var14 = vm.f32(var12 - vm.f32(1.5707964))
	else
		var14 = vm.f32(var12 + vm.f32(1.5707964))
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var14) * var15))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var14) * var15))
	helper_0b6e560f(pos_x, pos_y, pos_z, arg0, arg1, arg2, arg4)
end

return helper_01663a12
