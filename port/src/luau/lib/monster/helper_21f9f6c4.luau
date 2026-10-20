--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b6e560f = require("@lib/monster/helper_0b6e560f")
local helper_362382c7 = require("@lib/monster/helper_362382c7")
local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_21f9f6c4(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32, arg7: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	var15 = monster.GetRndf(arg4) or var15
	var16 = monster.GetRndf(arg3) or var16
	var15 = vm.f32(var15 + arg2)
	helper_362382c7(var16, arg1)
	helper_442b9962()
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
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var12) * var15))
	pos_y = pos_y
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var12) * var15))
	local _ = helper_0b6e560f(pos_x, pos_y, pos_z, arg0, arg5, arg6, arg7)
end

return helper_21f9f6c4
