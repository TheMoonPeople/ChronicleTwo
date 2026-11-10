--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_72fec261 = require("@lib/monster/helper_72fec261")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_9662aa5e()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local height: f32 = 0
	local vector_2: f32 = 0
	local attack: s32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("攻撃１", -1, 2)
	helper_72fec261(vm.f32(0.6), -1.0)
	height = monster.get_height_above_ground() or height
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	vector_2 = vm.f32(pos_y - height)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol1")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.create_effect_1("ＳウェーブＬ")
	monster.set_effect_first_vector(-1, pos_x, vector_2, pos_z)
	monster.set_effect_second_vector(-1, var3, var4, var5)
	monster.set_effect_value(-1, 0, attack)
	helper_56d63eae()
	monster.set_motion("歩き", -1, 0)
	helper_c3e8ae39(3)
end

return helper_9662aa5e
