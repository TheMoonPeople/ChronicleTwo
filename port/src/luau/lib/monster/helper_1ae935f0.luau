--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_48852a90 = require("@lib/monster/helper_48852a90")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")

--- Helper function.
local function helper_1ae935f0(vector: f32, vector_2: f32, vector_3: f32, arg3: any)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local chara_type: s32 = 0
	local attack: s32 = 0
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	helper_48852a90(10.0, vm.f32(0.538), vm.f32(0.01))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol2")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	chara_type = monster.get_character_number() or chara_type
	attack = monster.get_attack_power_1() or attack
	monster.create_effect_1("毒液2L")
	monster.set_effect_target(-1, chara_type)
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, vector, vector_2, vector_3)
	monster.set_effect_value(-1, 0, attack)
	helper_56d63eae()
end

return helper_1ae935f0
