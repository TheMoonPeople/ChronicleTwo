--!strict
-- dungeon/monster/b05a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_93495fdf = require("@lib/monster/helper_93495fdf")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_d30a9fa2 = require("@lib/monster/helper_d30a9fa2")
local helper_e05438b5 = require("@lib/monster/helper_e05438b5")

--- Helper function.
local function helper_1d54(value: s32)
	monster.set_variable(5, value)
end

--- Helper function.
local function helper_1df8(arg0: s32)
	local value: s32 = 0
	value = 0
	value = monster.get_variable(5) or value
	arg0 = value
	return arg0
end

--- Helper function.
local function helper_24e4(value: s32)
	monster.set_variable(2, value)
end

--- Helper function.
local function helper_1f08(value: s32)
	monster.set_variable(1, value)
end

--- Helper function.
local function helper_2ae4()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Helper function.
local function helper_2404(arg0: s32)
	local value: s32 = 0
	value = monster.get_variable(2) or value
	arg0 = value
	return arg0
end

--- Helper function.
local function helper_2270(arg0: s32)
	local var1: s32 = 0
	local value: s32 = 0
	var1 = 0
	value = 0
	var1 = helper_1df8(var1)
	value = monster.get_variable(vm.i32(var1 + 20)) or value
	arg0 = value
	return arg0
end

--- Helper function.
local function helper_2588()
	local var0: s32 = 0
	var0 = 0
	var0 = helper_2270(var0)
	return var0
end

--- Helper function.
local function helper_18c8(arg0: s32, arg1: s32)
	monster.set_variable(4, vm.i32(arg1 - arg0))
end

--- Helper function.
local function helper_1a7c()
	local life: s32 = 0
	local value: s32 = 0
	value = monster.get_variable(7) or value
	life = monster.get_monster_life(-1) or life
	if life <= 0 then
		monster.set_variable(7, life)
		return 1
	end
	if vm.i32(life - value) < 0 then
		monster.set_variable(7, life)
		helper_18c8(life, value)
		return 2
	end
	monster.set_variable(7, life)
	return 0
end

--- Helper function.
local function helper_208c()
	local value: s32 = 0
	value = monster.get_variable(1) or value
	monster.set_variable(1, vm.i32(value + 1))
end

--- Helper function.
local function helper_2650()
	local var0: s32 = 0
	local max_life: s32 = 0
	if helper_2588() ~= 0 then
		var0 = helper_1a7c()
		if var0 == 2 then
			helper_208c()
		end
	end
	max_life = monster.get_monster_max_life(-1) or max_life
	monster.add_monster_life(-1, max_life)
end

--- Helper function.
local function helper_27fc()
	helper_2650()
	vm.wait()
end

--- Helper function.
local function helper_287c(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_27fc()
		var1 = vm.i32(var1 + 1)
	end
end

--- Helper function.
local function helper_29bc()
	local var0: s32 = 0
	while true do
		helper_27fc()
		var0 = monster.is_motion_finished() or var0
		if var0 ~= 0 then
			return
		end
	end
end

--- Helper function.
local function helper_12964()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local vector: f32 = 0
	local vector_3: f32 = 0
	local var6: f32 = 0
	monster.set_motion("攻撃１", -1, 6)
	helper_287c(85)
	do
		local out1, out2, out3 = monster.get_frame_position("marioa_null")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	for var7 = 0, 4 do
		var6 = vm.f32(vm.f32(1.2566371) * var7)
		vector = vm.f32(pos_x + vm.f32(vm.sin(var6) * 20.0))
		vector_3 = vm.f32(pos_z + vm.f32(vm.cos(var6) * 20.0))
		monster.create_effect_1("砂煙")
		monster.set_effect_first_vector(-1, vector, 0.0, vector_3)
		vm.wait()
	end
	helper_29bc()
end

--- Helper function.
local function helper_135f4(show: s32)
	local var1: s32 = 0
	var1 = helper_1df8(var1)
	if var1 == 0 then
		monster.set_map_part_visible("p01_boss", "boss-c0", show)
	end
	if var1 == 1 then
		monster.set_map_part_visible("p01_boss", "boss-c1", show)
	end
	if var1 == 2 then
		monster.set_map_part_visible("p01_boss", "boss-c2", show)
	end
	if var1 == 3 then
		monster.set_map_part_visible("p01_boss", "boss-c3", show)
	end
	if var1 == 4 then
		monster.set_map_part_visible("p01_boss", "boss-c4", show)
	end
	if var1 == 5 then
		monster.set_map_part_visible("p01_boss", "boss-c5", show)
	end
end

--- Helper function.
local function helper_12e84()
	monster.set_motion("ぐったりL", -1, 0)
end

--- Helper function.
local function helper_1fac(arg0: s32)
	local value: s32 = 0
	value = monster.get_variable(1) or value
	arg0 = value
	return arg0
end

--- Helper function.
local function helper_13364(arg0: f32)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local value: s32 = 0
	value = monster.get_variable(30) or value
	do
		local out1, _, out3 = monster.get_monster_position(value)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	var7 = monster.get_distance_between(pos_x, 0.0, pos_z, var4, 0.0, var6) or var7
	arg0 = var7
	return arg0
end

--- Helper function.
local function helper_12f50()
	local chara_type: s32 = 0
	local value: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_monster_attributes(32, 1)
	monster.set_motion("戻り", -1, 6)
	value = monster.get_variable(10) or value
	if value ~= 0 then
		chara_type = monster.get_character_number() or chara_type
		monster.create_effect_1("Ｍ感電")
		monster.set_effect_owner(-1, chara_type)
		helper_56d63eae()
	else
		helper_29bc()
	end
	monster.set_monster_attributes(32, 0)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Helper function.
local function helper_2190(value: s32)
	local var1: s32 = 0
	var1 = helper_1df8(var1)
	monster.set_variable(vm.i32(var1 + 20), value)
end

--- Helper function.
local function helper_d730()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	helper_442b9962()
	helper_93495fdf()
	helper_27fc()
	monster.set_action_status(1)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local chara_type: s32 = 0
	local var1: s32 = 0
	monster.register_damage_hit("吹っ飛び攻撃", 18.0, "攻撃１", 0.219, 0.504, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 20.0, "攻撃１", 0.219, 0.504, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 18.0, "攻撃１", 0.219, 0.504, 2)
	monster.register_damage_hit("シーグラ攻撃", 14.0, "戻り", 0.109, 0.2, 0)
	monster.set_monster_attributes(128, 1)
	monster.set_clip_distance(10000.0)
	monster.set_monster_attributes(512, 1)
	chara_type = monster.get_character_number() or chara_type
	print("user_id=", chara_type, "----------\n")
	print("USERID_INDEX=", 24, "---------------\n")
	if chara_type == 24 then
		print("0---------------\n")
		helper_1d54(0)
	end
	if chara_type == 25 then
		print("1---------------\n")
		helper_1d54(1)
	end
	if chara_type == 26 then
		print("2---------------\n")
		helper_1d54(2)
	end
	if chara_type == 27 then
		print("3---------------\n")
		helper_1d54(3)
	end
	if chara_type == 28 then
		print("4---------------\n")
		helper_1d54(4)
	end
	if chara_type == 29 then
		print("5---------------\n")
		helper_1d54(5)
	end
	monster.load_effect_script("Ｍ感電")
	var1 = helper_1df8(var1)
	print("seag id=", var1, "------------\n")
	monster.set_variable(vm.i32(var1 + 20), 0)
	monster.set_variable(2, 0)
	monster.set_variable(10, 0)
	helper_24e4(3)
	helper_1f08(0)
	helper_2ae4()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: f32 = 0
	local var1: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	monster.set_motion("立ち", -1, 0)
	while true do
		var1 = helper_2404(var1)
		if var1 == 1 then
			helper_12964()
			helper_24e4(4)
			var4 = 0
		end
		if var1 == 4 then
			helper_135f4(1)
			helper_12e84()
			var3 = helper_1fac(var3)
			var0 = helper_13364(var0)
			if var3 >= 1 then
				monster.set_variable(10, 1)
				helper_24e4(2)
				helper_1f08(0)
			end
			if var0 > 450.0 and var4 > 210 then
				helper_24e4(2)
				helper_1f08(0)
			end
			var4 = vm.i32(var4 + 1)
		end
		if var1 == 2 then
			helper_135f4(0)
			helper_12f50()
			monster.set_variable(10, 0)
			helper_24e4(3)
			helper_2190(0)
		end
		if var1 == 3 or var1 == 0 then
			if helper_2588() ~= 0 then
				print("set act attack\n")
				helper_24e4(1)
			end
			monster.set_motion("立ち", -1, 0)
		end
		helper_27fc()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	monster.add_monster_life_fraction(-1, 1.0)
	helper_5d37e9f4()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	helper_29bc()
	helper_287c(12)
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_d730()
	monster.set_monster_attributes(32, 0)
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	helper_29bc()
	helper_287c(12)
	monster.set_motion("立ち")
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	helper_a551797e()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, var0, 0.0)
	helper_27fc()
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local var0: f32 = 0
	helper_49610f43()
	var0 = monster.get_target_angle() or var0
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, var0, 0.0)
	helper_27fc()
	monster.set_motion("立ち", -1, 0)
	helper_a551797e()
end

--- Runs the monster's death.
function script.on_death()
	helper_02ce7891()
	monster.set_motion("死に", -1, 2)
	helper_29bc()
	monster.spawn_death_effects()
	while true do
		helper_27fc()
	end
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

--- Stuns the monster.
function script.on_stun()
	helper_d30a9fa2()
	monster.set_motion("吹っ飛び", -1, 6)
	helper_29bc()
	monster.set_motion("起き上がり", -1, 6)
	helper_29bc()
	helper_e05438b5()
end

return script
