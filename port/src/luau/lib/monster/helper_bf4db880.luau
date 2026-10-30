--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_bf4db880()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var13: s32 = 0
	local attack: s32 = 0
	monster.set_variable(0, 2)
	monster.set_motion("歩き", -1, 0)
	helper_890ee63a(3.0)
	monster.set_motion("攻撃２", -1, 6)
	helper_c3e8ae39(helper_9df6409a(32))
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_variable(0, 4)
	attack = monster.get_attack_power_1() or attack
	var13 = 0
	while var13 < helper_9df6409a(60) do
		if vm.imod(var13, 4) == 0 then
			do
				local out1, out2, out3 = monster.get_frame_position("_nose_1")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = monster.get_frame_position("chn123")
				pos_x_2 = out1 or pos_x_2
				pos_y_2 = out2 or pos_y_2
				pos_z_2 = out3 or pos_z_2
			end
			do
				local out1, out2, out3 = monster.copy_vector(pos_x_2, pos_y_2, pos_z_2)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			do
				local out1, out2, out3 = monster.subtract_vectors(var6, var7, var8, pos_x, pos_y, pos_z)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			var7 = vm.f32(var7 / 3.0)
			do
				local out1, out2, out3 = monster.normalize_vector(var6, var7, var8)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			monster.create_effect_1("鼻弾Ｌ")
			monster.set_effect_first_vector(-1, pos_x_2, pos_y_2, pos_z_2)
			monster.set_effect_second_vector(-1, var6, var7, var8)
			monster.set_effect_value(-1, 0, attack)
		end
		vm.wait()
		var13 = var13 + 1
	end
	helper_c3e8ae39(helper_9df6409a(8))
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("立ち", -1, 0)
	helper_c3e8ae39(12)
end

return helper_bf4db880
