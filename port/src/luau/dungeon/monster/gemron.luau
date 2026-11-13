--!strict
--- Controls the flying Gemron, Gundron, Drake and Wyrm monsters of each element, which hover, step aside and spit elemental orbs at the player.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the distance beyond which the monster stops being processed, unlimited for bosses.
local function initialize_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Faces the target and fires an orb of the monster's element from its mouth toward the target.
local function spit_elemental_orb()
	local mouth_x: f32 = 0
	local mouth_y: f32 = 0
	local mouth_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local attack: s32 = 0
	local monster_id: s32 = 0
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	motion.wait_until_progress_facing_target(vm.f32(4.8), vm.f32(0.39), vm.f32(0.015))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol0")
		mouth_x = out1 or mouth_x
		mouth_y = out2 or mouth_y
		mouth_z = out3 or mouth_z
	end
	mouth_y = vm.f32(mouth_y - 5.0)
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	attack = monster.get_attack_power_1() or attack
	do
		local out1, out2, out3 = monster.get_target_position()
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	direction_y = vm.f32(direction_y + 20.0)
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, mouth_x, mouth_y, mouth_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(direction_x, direction_y, direction_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	monster_id = monster.get_monster_kind() or monster_id
	if monster_id >= 112 and monster_id <= 115 then
		monster.create_effect_1("火弾Ｆ")
	end
	if monster_id >= 116 and monster_id <= 119 then
		monster.create_effect_1("氷弾Ｆ")
	end
	if monster_id >= 120 and monster_id <= 123 then
		monster.create_effect_1("雷弾Ｆ")
	end
	if monster_id >= 124 and monster_id <= 127 then
		monster.create_effect_1("風弾Ｆ")
	end
	if monster_id >= 128 and monster_id <= 131 then
		monster.create_effect_1("聖弾Ｆ")
	end
	monster.set_effect_first_vector(-1, mouth_x, mouth_y, mouth_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	motion.wait_until_progress_reached(vm.f32(0.42), vm.f32(0.015))
	if monster_id >= 112 and monster_id <= 115 then
		monster.create_effect_1("火弾Ｌ３")
	end
	if monster_id >= 116 and monster_id <= 119 then
		monster.create_effect_1("氷弾Ｌ２")
	end
	if monster_id >= 120 and monster_id <= 123 then
		monster.create_effect_1("雷弾Ｌ２")
	end
	if monster_id >= 124 and monster_id <= 127 then
		monster.create_effect_1("風弾Ｌ２")
	end
	if monster_id >= 128 and monster_id <= 131 then
		monster.create_effect_1("聖弾Ｌ２")
	end
	monster.set_effect_first_vector(-1, mouth_x, mouth_y, mouth_z)
	monster.set_effect_second_vector(-1, direction_x, direction_y, direction_z)
	monster.set_effect_value(-1, 0, attack)
	monster.set_effect_value_float(-1, 1, 12.0)
	motion.wait_until_finished()
end

--- Spits an orb at the target or circles around it while it is far away.
local function act_at_long_range()
	local roll: s32 = 0
	local circle_degrees: f32 = 0
	local target_distance: f32 = 0
	if roll < 65 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		spit_elemental_orb()
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames(15)
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			circle_degrees = -45.0
		else
			circle_degrees = 45.0
		end
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		monster.set_motion("歩き", -1, 0)
		target_distance = monster.get_target_distance() or target_distance
		movement.walk_to_point_around_target(2.0, vm.f32(4.8), circle_degrees, target_distance, 35.0, 25.0, 60)
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(2.4))
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(35.0, 45.0, 30)
	end
end

--- Plays the walk motion and holds the current position.
local function hold_position()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	monster.set_motion("歩き", -1, 0)
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	movement.walk_to_position(position_x, position_y, position_z, 2.0, 0.0, 25.0, 30)
end

--- Holds position, raises its guard and rushes the target before lowering the guard again.
local function guard_and_rush_target()
	local position_y: f32 = 0
	local target_height: f32 = 0
	hold_position()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_facing_target(vm.f32(4.8))
	do
		local _, out2, _ = monster.get_position_3()
		position_y = out2 or position_y
	end
	do
		local _, out2, _ = monster.get_target_position()
		target_height = out2 or target_height
	end
	if position_y < target_height then
		monster.set_motion("攻撃２", -1, 0)
		movement.chase_target_after_turning(vm.f32(5.6), vm.f32(4.8), 0.0, 40.0, 10)
		movement.chase_target_with_rotation(vm.f32(5.6), vm.f32(4.8), 0.0, 40.0, 0, 20)
	else
		monster.set_motion("攻撃２", -1, 0)
		movement.chase_target_after_turning(vm.f32(5.6), vm.f32(4.8), 0.0, 8.0, 10)
		movement.chase_target_with_rotation(vm.f32(5.6), vm.f32(4.8), 0.0, 8.0, 0, 20)
	end
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished()
end

--- Steps sideways to a point on the opposite side of the target, offset by the given distance and angle.
local function side_step_around_target(extra_distance: f32, angle_degrees: f32, step_right: s32, duration_frames: s32)
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local step_angle_radians: f32 = 0
	local step_distance: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.8))
	step_distance = monster.get_target_distance() or step_distance
	step_distance = vm.f32(step_distance + extra_distance)
	angle_degrees = calc.degrees_to_radians(angle_degrees)
	step_angle_radians = monster.get_target_angle() or step_angle_radians
	step_angle_radians = vm.f32(step_angle_radians - vm.f32(3.1415927))
	step_angle_radians = vm.f32(step_angle_radians + angle_degrees)
	if step_angle_radians > vm.f32(3.1415927) then
		step_angle_radians = vm.f32(step_angle_radians - vm.f32(6.2831855))
	end
	if step_angle_radians <= vm.f32(-3.1415927) then
		step_angle_radians = vm.f32(step_angle_radians + vm.f32(6.2831855))
	end
	if step_right == 1 then
		monster.set_motion("ステップ右", -1, 0)
	else
		monster.set_motion("ステップ左", -1, 0)
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		destination_x = out1 or destination_x
		destination_y = out2 or destination_y
		destination_z = out3 or destination_z
	end
	destination_x = vm.f32(destination_x + vm.f32(vm.sin(step_angle_radians) * step_distance))
	destination_y = vm.f32(destination_y - 10.0)
	destination_z = vm.f32(destination_z + vm.f32(vm.cos(step_angle_radians) * step_distance))
	movement.walk_to_position(destination_x, destination_y, destination_z, 4.0, 4.0, 5.0, vm.idiv(duration_frames, 2))
	movement.walk_to_position(destination_x, destination_y, destination_z, 4.0, 4.0, 25.0, vm.idiv(duration_frames, 2))
end

--- Side-steps to the left or right of the target at random.
local function side_step_randomly()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		side_step_around_target(50.0, 150.0, 1, 30)
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		side_step_around_target(50.0, -150.0, 0, 30)
	end
end

--- Rushes, spits orbs with or without a side-step, or circles the target at medium distance.
local function act_at_medium_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local circle_degrees: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 40 then
		guard_and_rush_target()
	end
	roll = monster.get_random(100) or roll
	if roll < 60 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(4.8))
			spit_elemental_orb()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(15)
		else
			side_step_randomly()
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(9.6))
			spit_elemental_orb()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(15)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			circle_degrees = -45.0
		else
			circle_degrees = 45.0
		end
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		monster.set_motion("歩き", -1, 0)
		target_distance = monster.get_target_distance() or target_distance
		target_distance = vm.f32(target_distance + 10.0)
		movement.walk_to_point_around_target(2.0, vm.f32(4.8), circle_degrees, target_distance, 35.0, 25.0, 60)
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(2.4))
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_arc(35.0, 45.0, 30)
	end
end

--- Steps backward away from the target at the given speed to a point a little farther out.
local function back_step_away(speed: f32)
	local current_y: f32 = 0
	local retreat_x: f32 = 0
	local retreat_y: f32 = 0
	local retreat_z: f32 = 0
	local retreat_distance: f32 = 0
	local random_extra_distance: f32 = 0
	monster.set_monster_attributes(32, 1)
	retreat_distance = monster.get_target_distance() or retreat_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		retreat_x = out1 or retreat_x
		retreat_z = out3 or retreat_z
	end
	random_extra_distance = monster.get_random_whole_number(10.0) or random_extra_distance
	retreat_distance = vm.f32(retreat_distance + vm.f32(30.0 + random_extra_distance))
	monster.reset_motion()
	monster.set_motion("ステップ後", -1, 6)
	retreat_x, retreat_y, retreat_z = movement.get_approach_point(0.0, retreat_distance, retreat_x, retreat_y, retreat_z)
	timer.wait_frames(calc.pass_through(4))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	movement.walk_to_position(retreat_x, current_y, retreat_z, speed, vm.f32(speed + 1.0), 25.0, calc.pass_through(10))
	monster.set_monster_attributes(32, 0)
	motion.wait_until_finished()
	monster.stop_moving()
end

--- Rushes, spits orbs, backs off or strafes when the target is close.
local function act_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 90 then
		guard_and_rush_target()
	end
	target_distance = monster.get_target_distance() or target_distance
	if target_distance < 40.0 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait(vm.f32(4.8))
		spit_elemental_orb()
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames(21)
	end
	roll = monster.get_random(100) or roll
	if roll < 60 then
		roll = monster.get_random(100) or roll
		if roll < 60 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(4.8))
			spit_elemental_orb()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(15)
		else
			side_step_randomly()
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(9.6))
			spit_elemental_orb()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(15)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 30 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(vm.f32(4.8))
			back_step_away(3.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_and_wait(2.0)
			roll = monster.get_random(100) or roll
			if roll < 50 then
				movement.walk_along_heading(2.0, 215.0, 100.0, 35.0, 25.0, 20)
			else
				movement.walk_along_heading(2.0, 145.0, 100.0, 35.0, 25.0, 20)
			end
		end
	end
end

--- Loops choosing an attack by target distance until the target moves out of range.
local function engage_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	while true do
		vm.wait()
		behavior.try_face_transformed_player_wide_cone()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 350.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			behavior.circle_target_or_wait_distance_140()
			continue
		end
		if target_distance < 350.0 and target_distance >= 240.0 then
			act_at_long_range()
		elseif target_distance < 240.0 and target_distance >= 140.0 then
			act_at_medium_range()
		else
			act_at_close_range()
		end
	end
end

--- Side-steps left or right away from the target's attack and settles.
local function dodge_sideways()
	local roll: s32 = 0
	local dodge_x: f32 = 0
	local dodge_y: f32 = 0
	local dodge_z: f32 = 0
	local target_distance: f32 = 0
	local step_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	monster.set_monster_attributes(32, 1)
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("ステップ右", -1, 0)
		step_degrees = 60.0
	else
		monster.set_motion("ステップ左", -1, 0)
		step_degrees = -60.0
	end
	dodge_x, dodge_y, dodge_z = movement.get_approach_point(step_degrees, target_distance, dodge_x, dodge_y, dodge_z)
	movement.walk_to_position(dodge_x, vm.f32(dodge_y - 10.0), dodge_z, 3.0, 3.0, 25.0, calc.pass_through(10))
	monster.set_monster_attributes(32, 0)
	movement.wait_until_move_finished_without_stopping(calc.pass_through(30))
	monster.stop_moving()
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack hit windows, loads the effect scripts for the monster's element and enables flying.
function script.init()
	local monster_id: s32 = 0
	local texture_block: s32 = 0
	local charge_effect_loaded: s32 = 0
	local launch_effect_loaded: s32 = 0
	local hit_effect_loaded: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	monster.register_damage_hit("吹っ飛び攻撃", 7.2, "攻撃２", 0.0, 0.5, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 7.2, "攻撃２", 0.5, 1.0, 1)
	monster_id = monster.get_monster_kind() or monster_id
	if monster_id >= 112 and monster_id <= 115 then
		texture_block = monster.get_free_texture_block() or texture_block
		if texture_block ~= -1 then
			charge_effect_loaded = monster.load_effect_script("火弾Ｆ", texture_block) or charge_effect_loaded
			launch_effect_loaded = monster.load_effect_script("火弾Ｌ３", texture_block) or launch_effect_loaded
			hit_effect_loaded = monster.load_effect_script("火弾Ｈ", texture_block) or hit_effect_loaded
			if (if (if charge_effect_loaded ~= 0 then 1 else launch_effect_loaded) ~= 0 then 1 else hit_effect_loaded) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	if monster_id >= 116 and monster_id <= 119 then
		texture_block = monster.get_free_texture_block() or texture_block
		if texture_block ~= -1 then
			charge_effect_loaded = monster.load_effect_script("氷弾Ｆ", texture_block) or charge_effect_loaded
			launch_effect_loaded = monster.load_effect_script("氷弾Ｌ２", texture_block) or launch_effect_loaded
			hit_effect_loaded = monster.load_effect_script("氷弾Ｈ", texture_block) or hit_effect_loaded
			if (if (if charge_effect_loaded ~= 0 then 1 else launch_effect_loaded) ~= 0 then 1 else hit_effect_loaded) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	if monster_id >= 120 and monster_id <= 123 then
		texture_block = monster.get_free_texture_block() or texture_block
		if texture_block ~= -1 then
			charge_effect_loaded = monster.load_effect_script("雷弾Ｆ", texture_block) or charge_effect_loaded
			launch_effect_loaded = monster.load_effect_script("雷弾Ｌ２", texture_block) or launch_effect_loaded
			hit_effect_loaded = monster.load_effect_script("雷弾Ｈ", texture_block) or hit_effect_loaded
			if (if (if charge_effect_loaded ~= 0 then 1 else launch_effect_loaded) ~= 0 then 1 else hit_effect_loaded) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	if monster_id >= 124 and monster_id <= 127 then
		texture_block = monster.get_free_texture_block() or texture_block
		if texture_block ~= -1 then
			charge_effect_loaded = monster.load_effect_script("風弾Ｆ", texture_block) or charge_effect_loaded
			launch_effect_loaded = monster.load_effect_script("風弾Ｌ２", texture_block) or launch_effect_loaded
			hit_effect_loaded = monster.load_effect_script("風弾Ｈ", texture_block) or hit_effect_loaded
			if (if (if charge_effect_loaded ~= 0 then 1 else launch_effect_loaded) ~= 0 then 1 else hit_effect_loaded) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	if monster_id >= 128 and monster_id <= 131 then
		texture_block = monster.get_free_texture_block() or texture_block
		if texture_block ~= -1 then
			charge_effect_loaded = monster.load_effect_script("聖弾Ｆ", texture_block) or charge_effect_loaded
			launch_effect_loaded = monster.load_effect_script("聖弾Ｌ２", texture_block) or launch_effect_loaded
			hit_effect_loaded = monster.load_effect_script("聖弾Ｈ", texture_block) or hit_effect_loaded
			if (if (if charge_effect_loaded ~= 0 then 1 else launch_effect_loaded) ~= 0 then 1 else hit_effect_loaded) ~= 0 then
				monster.reserve_texture_block()
			end
		end
	end
	state.initialize_flying()
	state.set_max_flight_height(40.0)
	initialize_clip_distance()
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	monster.set_position(position_x, vm.f32(position_y + 25.0) - 10.0, position_z)
end

--- Engages the target when it is near and wanders otherwise.
function script.loop()
	local target_distance: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		monster.get_rage_hits_left()
		behavior.try_face_transformed_player_wide_cone()
		target_distance = sense.get_horizontal_target_distance(target_distance)
		if target_distance < 350.0 then
			engage_target()
		else
			behavior.choose_wander_action()
		end
	end
end

--- Staggers in place until the status ailment wears off.
function script.on_status_hit()
	local ailments: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailments = 1
	while ailments ~= 0 do
		ailments = monster.get_status_ailments(40) or ailments
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the flinch reaction.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(16)
	monster.set_motion("立ち", -1, 0)
	state.do_nothing()
end

--- Plays the knockback, lies down and gets back up.
function script.on_knockdown()
	reaction.begin_knockdown()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 25)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	reaction.end_knockdown()
end

--- Plays the guard motions and recoils.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード入り", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("ガード", -1, 6)
	monster.start_knockback(3.0, 0.0, 2)
	motion.wait_until_finished()
	timer.wait_frames(8)
	monster.set_motion("ガード戻り", -1, 6)
	motion.wait_until_finished()
	state.unlock()
end

--- Turns toward the target and side-steps its attack.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	movement.face_target_instantly()
	vm.wait()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.8))
	dodge_sideways()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	state.unlock()
end

--- Side-steps the attack and plays the dodge recovery.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait(vm.f32(4.8))
	dodge_sideways()
	movement.face_target_instantly()
	vm.wait()
	motion.wait_until_finished()
	monster.set_motion("よけるもどり", -1, 6)
	motion.wait_until_finished()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	state.unlock()
end

--- Plays the death motion and effects.
function script.on_death()
	death.start_death_and_fall()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Struggles while held.
function script.on_caught()
	state.stop_flying_and_reset_motion()
	monster.set_motion("じたばた", -1, 4)
	timer.wait_forever_unguarded()
end

--- Resumes flying after being thrown.
function script.on_land()
	reaction.end_throw_and_resume_flying()
	state.set_flying_attributes(1)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	movement.raise_one_unit()
	return 1
end

--- Falls, gets up and stays stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("吹っ飛びループ", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("気絶", -1)
	reaction.stun_until_recovered()
end

return script
