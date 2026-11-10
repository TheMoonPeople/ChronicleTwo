--!strict
-- Shared monster helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_de1504df = require("@lib/monster/helper_de1504df")

--- Helper function.
local function helper_68e24e97(arg0: f32, arg1: f32, arg2: f32, scale: f32, arg4: f32, arg5: f32, arg6: any)
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var22: f32 = 0
	local var23: s32 = 0
	local var24: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		var7 = out1 or var7
		var8 = out2 or var8
		var9 = out3 or var9
	end
	var19 = helper_57b569a8(var19)
	arg1 = vm.f32(var19 + arg5)
	do
		local out1, out2, out3 = monster.copy_vector(arg0, arg1, arg2)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var13, var14, var15, var7, var8, var9)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var13, var14, var15)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = monster.scale_vector(var13, var14, var15, scale)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	monster.copy_vector(arg0, arg1, arg2)
	var11 = monster.get_angle_to_position(var7 + var13, var8 + var14, var9 + var15) or var11
	var23 = 0
	while var23 < arg6 do
		do
			local out1, out2, out3 = monster.add_vectors(var7, var8, var9, var13, var14, var15)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		var22 = monster.get_height_above_ground_at(var7, var8, var9) or var22
		if var22 >= 25.0 or var22 <= 0.0 then
			var8 = vm.f32(var8 - var14)
			var14 = 0.0
		end
		var20 = monster.get_distance_between(var7, var8, var9, arg0, arg1, arg2) or var20
		if var20 < vm.f32(scale + arg4) then
			return 1
		end
		var24 = helper_de1504df(var7, var8, var9, scale, var11)
		if var24 ~= 0 then
			return var24
		end
		monster.set_position(var7, var8, var9)
		monster.copy_vector(var7, var8, var9)
		helper_0ba23e4e()
		var23 = vm.i32(var23 + 1)
	end
	return 0
end

return helper_68e24e97
