--!strict
-- dungeon/monster/b17a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")

--- Helper function.
local function helper_2138(value: f32)
	monster.set_variable_float(0, value)
end

--- Helper function.
local function helper_18d0(arg0: s32, arg1: s32)
	local att_type: s32 = 0
	att_type = monster.get_last_attack_type() or att_type
	monster.set_variable(6, att_type)
	monster.set_variable(7, vm.i32(arg1 - arg0))
end

--- Helper function.
local function helper_32d0()
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
local function helper_1ba4()
	local life: s32 = 0
	local value: s32 = 0
	local value_2: s32 = 0
	value = monster.get_variable(9) or value
	life = monster.get_monster_life(-1) or life
	if life <= 0 then
		monster.set_variable(9, life)
		return
	end
	if vm.i32(life - value) < 0 then
		monster.set_variable(9, life)
		helper_18d0(life, value)
		value_2 = monster.get_variable(8) or value_2
		monster.set_variable(8, vm.i32(value_2 + 1))
		print("dmg_cnt = ", vm.i32(value_2 + 1), "--------------------\n")
		return
	end
	monster.set_variable(9, life)
end

--- Helper function.
local function helper_2058(arg0: f32)
	local value: f32 = 0
	value = monster.get_variable_float(0) or value
	arg0 = value
	return arg0
end

--- Helper function.
local function helper_21dc()
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local var12: f32 = 0
	monster.get_monster_life_fraction(-1)
	target = 250.0
	target_2 = 0.0
	target_3 = 250.0
	var7 = monster.get_angle_to_position(target, target_2, target_3) or var7
	var6 = helper_2058(var6)
	x = vm.f32(target + vm.f32(vm.sin(var6) * 180.0))
	y = vm.f32(target_2 + 105.0)
	z = vm.f32(target_3 + vm.f32(vm.cos(var6) * 180.0))
	monster.set_position(x, y, z)
	monster.set_rotation(0.0, var7, 0.0)
	value_2 = monster.get_variable_float(1) or value_2
	value = monster.get_variable_float(2) or value
	var12 = monster.get_variable_float(3) or var12
	if value > var12 or value < -var12 then
		var12 = monster.get_random_whole_number(0.011635529) or var12
		if value > vm.f32(0.023271058) then
			var12 = vm.f32(-var12 + vm.f32(0.023271058))
			value = var12
		else
			var12 = vm.f32(var12 + vm.f32(0.023271058))
			value = -var12
		end
		value_2 = vm.f32(value_2 * -1.0)
		monster.set_variable_float(1, value_2)
		monster.set_variable_float(3, var12)
	end
	value = vm.f32(value + value_2)
	monster.set_variable_float(2, value)
	helper_2138(vm.f32(var6 + value))
end

--- Helper function.
local function helper_2b2c()
	local value: s32 = 0
	helper_1ba4()
	value = monster.get_variable(8) or value
	if value >= 3 then
		if value == 3 then
			monster.set_variable_float(10, 0.004363323)
			monster.set_variable_float(1, 9.3499795e-05)
			print("3\n")
		end
		if value == 4 then
			monster.set_variable_float(10, 0.0058177644)
			monster.set_variable_float(1, 0.00012466639)
		end
		if value == 5 then
			monster.set_variable_float(10, 0.008726646)
			monster.set_variable_float(1, 0.00018699959)
		end
	end
	helper_21dc()
end

--- Helper function.
local function helper_2fe8()
	helper_2b2c()
	vm.wait()
end

--- Helper function.
local function helper_31a8()
	local var0: s32 = 0
	while true do
		helper_2fe8()
		var0 = monster.is_motion_finished() or var0
		if var0 ~= 0 then
			return
		end
	end
end

--- Helper function.
local function helper_1f9c(arg0: s32)
	monster.set_variable(vm.i32(arg0 + 20), 1)
end

--- Helper function.
local function helper_121a4()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.play_sound(4)
	else
		monster.play_sound(5)
	end
	monster.set_motion("攻撃１", -1, 6)
	helper_31a8()
	argc = monster.get_random(120) or argc
	var1 = vm.imod(argc, 6)
	var2 = 0
	while var2 < vm.i32(var1 + 1) do
		argc = monster.get_random(120) or argc
		helper_1f9c(vm.imod(argc, 6))
		var2 = var2 + 1
	end
end

--- Helper function.
local function helper_3068(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_2fe8()
		var1 = vm.i32(var1 + 1)
	end
end

--- Helper function.
local function helper_d290()
	monster.spawn_death_effects()
	while true do
		helper_2fe8()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local chara_type: s32 = 0
	local life: s32 = 0
	monster.set_monster_attributes(1, 1)
	monster.set_monster_attributes(4, 1)
	monster.set_camera_mode(4)
	chara_type = monster.get_character_number() or chara_type
	monster.set_variable(30, chara_type)
	monster.set_variable(5, 0)
	helper_2138(0.0)
	monster.set_variable_float(1, 6.2333194e-05)
	monster.set_variable_float(2, 0.011635529)
	monster.set_variable_float(3, 0.034906585)
	life = monster.get_monster_life(-1) or life
	monster.set_variable(9, life)
	monster.set_variable(8, 0)
	monster.set_variable_float(10, 0.0)
	helper_18d0(life, life)
	monster.set_map_part_visible("p01_boss", "boss02-a0", 1)
	monster.set_map_part_visible("p01_boss", "boss02-a1", 1)
	monster.set_map_part_visible("p01_boss", "boss02-a2", 1)
	monster.set_map_part_visible("p01_boss", "boss02-a3", 1)
	monster.set_map_part_visible("p01_boss", "boss02-a4", 1)
	monster.set_map_part_visible("p01_boss", "boss02-a5", 1)
	monster.set_map_part_visible("p01_boss", "boss02-c0", 1)
	monster.set_map_part_visible("p01_boss", "boss02-c1", 1)
	monster.set_map_part_visible("p01_boss", "boss02-c2", 1)
	monster.set_map_part_visible("p01_boss", "boss02-c3", 1)
	monster.set_map_part_visible("p01_boss", "boss02-c4", 1)
	monster.set_map_part_visible("p01_boss", "boss02-c5", 1)
	monster.set_photo_opportunity(1027)
	helper_32d0()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local var1: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	value = monster.get_variable(5) or value
	if value == 0 then
		monster.play_sound(2)
		monster.set_variable(5, 1)
	end
	monster.reset_motion()
	while true do
		monster.set_motion("あそび", -1, 0)
		if vm.imod(var1, 90) == 0 then
			helper_121a4()
		end
		helper_2fe8()
		var1 = vm.i32(var1 + 1)
	end
end

--- Reacts to a hit while greyed out, or to a hit that greys it out.
function script.on_status_hit()
	local var0: s32 = 0
	helper_5d37e9f4()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	var0 = 1
	while var0 ~= 0 do
		var0 = monster.get_status_ailments(40) or var0
		vm.wait()
	end
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	print("damage action-----------\n")
	monster.reset_motion()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	helper_31a8()
	helper_3068(12)
	monster.set_motion("あそび")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	print("blow damage----------\n")
end

--- Guards against a hit.
function script.on_guard()
	print("guard-----------\n")
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	print("sword escape-----------\n")
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	print("shot escape------------\n")
end

--- Runs the monster's death.
function script.on_death()
	monster.set_map_part_visible("p01_boss", "boss02-a0", 0)
	monster.set_map_part_visible("p01_boss", "boss02-a1", 0)
	monster.set_map_part_visible("p01_boss", "boss02-a2", 0)
	monster.set_map_part_visible("p01_boss", "boss02-a3", 0)
	monster.set_map_part_visible("p01_boss", "boss02-a4", 0)
	monster.set_map_part_visible("p01_boss", "boss02-a5", 0)
	monster.set_map_part_visible("p01_boss", "boss02-c0", 0)
	monster.set_map_part_visible("p01_boss", "boss02-c1", 0)
	monster.set_map_part_visible("p01_boss", "boss02-c2", 0)
	monster.set_map_part_visible("p01_boss", "boss02-c3", 0)
	monster.set_map_part_visible("p01_boss", "boss02-c4", 0)
	monster.set_map_part_visible("p01_boss", "boss02-c5", 0)
	vm.wait()
	helper_02ce7891()
	monster.play_sound(23)
	monster.stop_sound(2)
	monster.request_event_script(501)
	monster.set_motion("死に", -1, 2)
	helper_31a8()
	monster.spawn_death_effects()
	while true do
		helper_2fe8()
	end
	helper_d290()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
function script.on_stun() end

return script
