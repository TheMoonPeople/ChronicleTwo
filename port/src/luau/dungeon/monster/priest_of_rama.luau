--!strict
--- Behaviour for the Priest of Rama family, a melee fighter that heals wounded allies.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the guard thresholds and clip distance when the monster is placed.
local function configure_defaults()
	local boss: s32 = 0
	state.set_unknown_float_8(500.0)
	state.set_unknown_float_9(80.0)
	reaction.set_guard_damage_threshold(0)
	monster.set_secondary_variable(5, 0)
	monster.set_secondary_variable(11, 150)
	monster.set_secondary_variable(12, 0)
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Finds the most wounded nearby ally and heals it, or itself, once the heal charge is full.
local function heal_weakest_ally()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local ally_life_fraction: f32 = 0
	local lowest_life_fraction: f32 = 0
	local ally_x: f32 = 0
	local ally_y: f32 = 0
	local ally_z: f32 = 0
	local index: s32 = 0
	local candidate: s32 = 0
	local heal_target: s32 = 0
	local monster_count: s32 = 0
	local heal_charge: s32 = 0
	local random_bonus: s32 = 0
	local target_id: s32 = 0
	local max_life: s32 = 0
	local heal_amount: s32 = 0
	local own_life_bits: s32 = 0
	local ally_life_bits: s32 = 0
	local angle_to_ally: f32 = 0
	local target_life_fraction: f32 = 0
	heal_charge = monster.get_variable(7) or heal_charge
	if heal_charge < 300 then
		return
	end
	monster_count = monster.get_monster_count() or monster_count
	index = 0
	heal_target = -1
	lowest_life_fraction = monster.get_monster_life_fraction(-1) or lowest_life_fraction
	while index < monster_count do
		candidate = monster.get_nearby_monster(200.0, index) or candidate
		if candidate ~= -1 then
			ally_life_fraction = monster.get_monster_life_fraction(candidate) or ally_life_fraction
		end
		if ally_life_fraction < lowest_life_fraction then
			lowest_life_fraction = ally_life_fraction
			heal_target = candidate
		end
		index = index + 1
	end
	if heal_target ~= -1 then
		own_life_bits = vm.float_bits(monster.get_monster_life_fraction(-1)) or own_life_bits
		ally_life_bits = vm.float_bits(monster.get_monster_life_fraction(heal_target)) or ally_life_bits
		if own_life_bits < ally_life_bits then
			heal_target = -2
		end
	else
		lowest_life_fraction = monster.get_monster_life_fraction(-1) or lowest_life_fraction
		heal_target = -2
	end
	if heal_target == -1 or lowest_life_fraction > vm.f32(0.9) then
		return
	end
	if heal_target == -2 then
		heal_target = -1
	else
		do
			local out1, out2, out3 = monster.get_monster_position(heal_target)
			ally_x = out1 or ally_x
			ally_y = out2 or ally_y
			ally_z = out3 or ally_z
		end
		angle_to_ally = monster.get_angle_to_position(ally_x, ally_y, ally_z) or angle_to_ally
		monster.set_motion("歩き", -1, 0)
		movement.turn_to_heading_with_reaction(calc.radians_to_degrees(angle_to_ally), 8.0)
	end
	monster.set_motion("回復in", -1, 6)
	if heal_target ~= -1 then
		movement.turn_toward_monster(heal_target, 8.0, calc.pass_through(18))
	else
		timer.wait_frames_with_reaction(calc.pass_through(18))
	end
	monster.set_motion("回復", -1, 6)
	if heal_target ~= -1 then
		movement.turn_toward_monster(heal_target, 8.0, calc.pass_through(12))
	else
		timer.wait_frames_with_reaction(calc.pass_through(12))
	end
	monster.set_motion("回復out", -1, 6)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol0")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("Ｍ回復Ｆ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	if heal_target ~= -1 then
		movement.turn_toward_monster(heal_target, 8.0, calc.pass_through(20))
	else
		timer.wait_frames_with_reaction(calc.pass_through(20))
	end
	if heal_target == -1 then
		target_id = monster.get_character_number() or target_id
	else
		target_id = heal_target
	end
	target_life_fraction = monster.get_monster_life_fraction(target_id) or target_life_fraction
	if target_life_fraction <= 0.0 then
		return
	end
	monster.create_effect_1("Ｍ回復")
	monster.set_effect_value(-1, 0, target_id)
	if heal_target ~= -1 then
		movement.turn_toward_monster(heal_target, 8.0, calc.pass_through(12))
	else
		timer.wait_frames_with_reaction(calc.pass_through(12))
	end
	target_life_fraction = monster.get_monster_life_fraction(target_id) or target_life_fraction
	if target_life_fraction <= 0.0 then
		return
	end
	max_life = monster.get_monster_max_life(heal_target) or max_life
	heal_amount = vm.ftoi(vm.f32(max_life * vm.f32(0.3)))
	random_bonus = monster.get_random(vm.ftoi(vm.f32(heal_amount * vm.f32(0.2)))) or random_bonus
	heal_amount = vm.i32(vm.ftoi(vm.f32(heal_amount * vm.f32(0.8))) + random_bonus)
	monster.show_damage_number(heal_target, heal_amount, 1)
	monster.add_monster_life(heal_target, heal_amount)
	if heal_target ~= -1 then
		movement.turn_toward_monster(heal_target, 8.0, calc.pass_through(12))
	else
		timer.wait_frames_with_reaction(calc.pass_through(12))
	end
	monster.set_motion("回復out", -1, 6)
	if heal_target ~= -1 then
		movement.turn_toward_monster(heal_target, 8.0, 20)
	else
		timer.wait_frames_with_reaction(90)
	end
	monster.set_variable(7, 0)
	motion.wait_until_finished_with_reaction()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_reaction(10)
end

--- Idles facing the target until the player is no longer transformed.
local function wait_while_player_transformed(monster_kind: any)
	local transform_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		timer.wait_frame_with_reaction()
		transform_id = monster.get_player_transform_id() or transform_id
		if transform_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_until_facing(4.0)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Starts waiting when the player is transformed.
local function check_player_transformation()
	local transform_id: s32 = 0
	local monster_kind: s32 = 0
	monster_kind = monster.get_monster_kind() or monster_kind
	transform_id = monster.get_player_transform_id() or transform_id
	if transform_id > -1 then
		wait_while_player_transformed(monster_kind)
	end
end

--- Repeats the idle play animation, optionally stopping early when the target comes in front.
local function play_idle_animation(repeat_count: s32, watch_target: s32)
	local target_seen: s32 = 0
	for index = 0, repeat_count - 1 do
		monster.reset_motion()
		monster.set_motion("遊び", -1, 6)
		if watch_target == 1 then
			target_seen = sense.wait_for_target_in_cone(74.0, 45.0, calc.pass_through(100))
			if target_seen == 1 then
				return
			end
		else
			timer.wait_frames_with_reaction(calc.pass_through(100))
		end
	end
end

--- Walks to a spot beside the target, waits in front of it or plays idle animations.
local function act_passively()
	local roll: s32 = 0
	local side_offset: f32 = 0
	local distance: f32 = 0
	local second_roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 60 then
			roll = monster.get_random(100) or roll
			side_offset = monster.get_random_whole_number(30.0) or side_offset
			distance = monster.get_random_whole_number(30.0) or distance
			distance = vm.f32(distance + 95.0)
			if roll < 50 then
				side_offset = vm.f32(-side_offset - 30.0)
			else
				side_offset = vm.f32(side_offset + 30.0)
			end
			monster.set_motion("歩き", -1, 0)
			local _ = movement.move_to_point_around_target(vm.f32(1.9), 4.0, side_offset, distance, 37.0, 30)
			movement.turn_toward_target_until_facing(4.0)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_until_facing(4.0)
			monster.set_motion("立ち", -1, 0)
			sense.wait_for_target_in_cone(37.0, 45.0, 30)
		end
	else
		if second_roll < 50 then
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_until_facing(4.0)
		end
		second_roll = monster.get_random(1) or second_roll
		play_idle_animation(vm.i32(1 + second_roll), 1)
	end
end

--- Turns toward the target and walks toward its position until close enough or the time runs out.
local function advance_toward_target(move_speed: f32, turn_speed: f32, stop_distance: f32, timeout_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local dest_x: f32 = 0
	local dest_z: f32 = 0
	local heading: f32 = 0
	local target_distance: f32 = 0
	local clear_distance: f32 = 0
	movement.turn_toward_target_until_facing(turn_speed)
	movement.stop_turning()
	monster.get_target_position()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	target_distance = monster.get_target_distance() or target_distance
	clear_distance = monster.get_clear_distance(move_speed + stop_distance, 0.0) or clear_distance
	if clear_distance < vm.f32(move_speed + stop_distance) then
		return
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	dest_x = vm.f32(pos_x + vm.f32(vm.sin(heading) * target_distance))
	dest_z = vm.f32(pos_z + vm.f32(vm.cos(heading) * target_distance))
	monster.move_toward_position(dest_x, pos_y - 20.0, dest_z, move_speed, stop_distance + move_speed)
	local _ = movement.wait_for_move_or_target_near(stop_distance, timeout_frames)
	monster.stop_moving()
end

--- Walks toward the target at long range or waits for it to come in front.
local function close_distance_or_wait()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 80 then
		monster.set_motion("歩き", -1, 0)
		advance_toward_target(vm.f32(1.9), 4.0, 95.0, 30)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_for_target_in_cone(92.0, 45.0, 45)
	end
end

--- Steps sideways to the left or right around the target.
local function sidestep_around_target()
	local roll: s32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local pos_y: f32 = 0
	local target_distance: f32 = 0
	local side_angle_degrees: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	monster.set_monster_attributes(32, 1)
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.reset_motion()
		monster.set_motion("ステップ右", -1, 6)
		side_angle_degrees = 25.0
	else
		monster.reset_motion()
		monster.set_motion("ステップ左", -1, 6)
		side_angle_degrees = -25.0
	end
	target_x, target_y, target_z = movement.get_approach_point(side_angle_degrees, target_distance, target_x, target_y, target_z)
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(target_x, pos_y - 10.0, target_z, 2.28, 2.85)
	timer.wait_frames_with_reaction(calc.pass_through(5))
	monster.set_monster_attributes(32, 0)
	motion.wait_until_finished_with_reaction()
	monster.stop_moving()
end

--- Picks a strafe, idle animation, sidestep or advance while the target is at medium range.
local function act_at_mid_range()
	local roll: s32 = 0
	local side_offset: f32 = 0
	local distance_offset: f32 = 0
	local second_roll: s32 = 0
	local target_distance: f32 = 0
	local step_index: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 35 then
		monster.get_random(100, roll)
		side_offset = monster.get_random_whole_number(30.0) or side_offset
		distance_offset = monster.get_random_whole_number(20.0) or distance_offset
		if roll < 50 then
			side_offset = vm.f32(-side_offset - 30.0)
		else
			side_offset = vm.f32(side_offset + 30.0)
		end
		distance_offset = vm.f32(distance_offset + 74.0)
		monster.set_motion("歩き", -1, 0)
		movement.move_to_point_around_target(vm.f32(1.9), 4.0, side_offset, distance_offset, 37.0, 30)
		movement.turn_toward_target_until_facing(4.0)
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			second_roll = monster.get_random(100) or second_roll
			if second_roll < 50 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_until_facing(4.0)
			end
			second_roll = monster.get_random(3) or second_roll
			play_idle_animation(vm.i32(1 + second_roll), 1)
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(2) or roll
				step_index = 0
				while step_index < vm.i32(1 + roll) do
					target_distance = monster.get_target_distance() or target_distance
					if target_distance < 95.0 then
						break
					end
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_until_facing(4.0)
					sidestep_around_target()
					step_index = step_index + 1
				end
			else
				monster.set_motion("歩き", -1, 0)
				advance_toward_target(vm.f32(1.9), 4.0, 37.0, 30)
			end
		end
	end
end

--- Plays the first swing while advancing on the target.
local function attack_first_swing()
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	advance_toward_target(6.0, 4.0, 1.0, 15)
	motion.wait_until_finished_with_reaction()
end

--- Plays the second swing while advancing on the target.
local function attack_second_swing()
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	advance_toward_target(6.0, 4.0, 1.0, calc.pass_through(15))
	motion.wait_until_finished_with_reaction()
end

--- Plays the second swing and then the first swing while advancing.
local function attack_second_then_first_swing()
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	timer.wait_frames_with_reaction(calc.pass_through(28))
	monster.set_motion("攻撃１", -1, 0)
	advance_toward_target(4.5, 4.0, 1.0, 15)
	timer.wait_frames_with_reaction(calc.pass_through(40))
end

--- Plays the first swing followed by the second swing.
local function attack_first_then_second_swing()
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	timer.wait_frames_with_reaction(calc.pass_through(12))
	monster.set_motion("攻撃２", -1, 0)
	timer.wait_frames_with_reaction(calc.pass_through(45))
end

--- Moves to a point beside the target, stopping early at obstacles or close range.
local function strafe_around_target(move_speed: f32, side_angle_degrees: f32, stop_distance: f32, timeout_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local dest_x: f32 = 0
	local dest_y: f32 = 0
	local dest_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local distance: f32 = 0
	distance = monster.get_target_distance() or distance
	dest_x, dest_y, dest_z = movement.get_approach_point(side_angle_degrees, distance, dest_x, dest_y, dest_z)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(dest_x, dest_y, dest_z) -- retail: argument 5 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 6 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, pos_x, pos_y, pos_z)
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
	distance = monster.get_clear_distance(100.0, 0.0) or distance
	if distance < 100.0 then
		dest_x = vm.f32(pos_x + vm.f32(direction_x * distance))
		dest_y = pos_y
		dest_z = vm.f32(pos_z + vm.f32(direction_z * distance))
		distance = vm.f32(distance - stop_distance)
		if distance < stop_distance then
			return
		end
	end
	monster.move_toward_position(dest_x, pos_y, dest_z, move_speed, move_speed)
	local _ = movement.wait_for_move_or_target_near(stop_distance, timeout_frames)
	monster.stop_moving()
end

--- Hops backward away from the target.
local function step_back_from_target(move_speed: f32)
	local pos_x: f32 = 0
	local approach_y: f32 = 0
	local pos_z: f32 = 0
	local target_distance: f32 = 0
	local random_extra: f32 = 0
	local current_y: f32 = 0
	monster.set_monster_attributes(32, 1)
	target_distance = monster.get_target_distance() or target_distance
	do
		local out1, _, out3 = monster.get_target_rotation()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	random_extra = monster.get_random_whole_number(10.0) or random_extra
	target_distance = vm.f32(target_distance + vm.f32(30.0 + random_extra))
	pos_x, approach_y, pos_z = movement.get_approach_point(0.0, target_distance, pos_x, approach_y, pos_z)
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames_with_reaction(calc.pass_through(6))
	do
		local _, out2, _ = monster.get_position_3()
		current_y = out2 or current_y
	end
	monster.move_toward_position(pos_x, current_y, pos_z, move_speed, move_speed + 1.0)
	timer.wait_frames_with_reaction(calc.pass_through(3))
	monster.set_monster_attributes(32, 0)
	motion.wait_until_finished_with_reaction()
	monster.stop_moving()
	monster.set_motion("立ち", -1)
end

--- Picks a melee swing combination or a strafe or retreat while the target is close.
local function attack_at_close_range()
	local roll: s32 = 0
	local side_angle_degrees: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 55 then
		roll = monster.get_random(100) or roll
		if roll < 60 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", -1, 0)
				advance_toward_target(3.0, 4.0, 37.0, 30)
				movement.turn_toward_target_until_facing(4.0)
				attack_first_swing()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_reaction(10)
			else
				monster.set_motion("歩き", -1, 0)
				advance_toward_target(3.0, 4.0, 37.0, 30)
				movement.turn_toward_target_until_facing(4.0)
				attack_second_swing()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_reaction(10)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 80 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("歩き", -1, 0)
					advance_toward_target(3.0, 4.0, 37.0, 30)
					movement.turn_toward_target_until_facing(4.0)
					attack_second_then_first_swing()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_reaction(10)
				else
					monster.set_motion("歩き", -1, 0)
					advance_toward_target(3.0, 4.0, 37.0, 30)
					movement.turn_toward_target_until_facing(4.0)
					attack_second_then_first_swing()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_reaction(10)
				end
			else
				monster.set_motion("歩き", -1, 0)
				advance_toward_target(3.0, 4.0, 37.0, 30)
				movement.turn_toward_target_until_facing(4.0)
				attack_first_then_second_swing()
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_reaction(10)
			end
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 60 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				side_angle_degrees = 45.0
			else
				side_angle_degrees = -45.0
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_until_facing(4.0)
			strafe_around_target(vm.f32(1.9), side_angle_degrees, vm.f32(1.9), 30)
			movement.turn_toward_target_until_facing(4.0)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_until_facing(4.0)
			step_back_from_target(vm.f32(1.9))
			roll = monster.get_random(100) or roll
			if roll < 40 then
				play_idle_animation(2, 1)
			end
		end
	end
end

--- Fights the target by distance each frame until it moves away or no rage hits remain.
local function fight_with_rage_hits_left()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		timer.wait_frame_with_reaction()
		check_player_transformation()
		heal_weakest_ally()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 255.0 then
			timer.wait_frame_with_reaction()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			timer.wait_frame_with_reaction()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			act_passively()
			continue
		end
		if target_distance < 255.0 and target_distance >= 168.0 then
			close_distance_or_wait()
		elseif target_distance < 168.0 and target_distance >= 95.0 then
			act_at_mid_range()
		else
			attack_at_close_range()
		end
		timer.wait_frame_with_reaction()
	end
end

--- Roams around its home position, turning and waiting for the target while nothing engages it.
local function wander_while_unengaged()
	local roll: s32 = 0
	local is_target_threatening: s32 = 0
	local unused_selector: s32 = 0
	local distance_from_home: f32 = 0
	local heading_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local orbit_degrees: f32 = 0
	local turn_degrees: f32 = 0
	local orbit_angle_degrees: f32 = 0
	local orbit_radius: f32 = 0
	local target_distance: f32 = 0
	local final_turn_degrees: f32 = 0
	timer.wait_frame_with_reaction()
	monster.set_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_pos_x = out1 or place_pos_x
		place_pos_y = out2 or place_pos_y
		place_pos_z = out3 or place_pos_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	distance_from_home = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or distance_from_home
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 37.0 then
		heading_degrees = monster.get_random_whole_number(360.0) or heading_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_heading_with_reaction(heading_degrees, 4.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 37.0)
		if clear_distance > 0.0 then
			movement.move_along_heading_turning(4.0, vm.f32(1.9), heading_degrees, clear_distance, 37.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance_from_home > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if distance_from_home > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				monster.set_place_position(pos_x, pos_y, pos_z)
			end
			roll = monster.get_random(100) or roll
			if roll < 30 then
				monster.set_variable(0, 4)
				roll = monster.get_random(100) or roll
				orbit_degrees = monster.get_random_whole_number(360.0) or orbit_degrees
				distance_from_home = monster.get_random_whole_number(150.0) or distance_from_home
				if roll < 50 then
					orbit_degrees = vm.f32(-orbit_degrees - 30.0)
				else
					orbit_degrees = vm.f32(orbit_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.move_around_position(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.9), 4.0, distance_from_home, orbit_degrees, 37.0, 60)
				turn_degrees = monster.get_random_whole_number(180.0) or turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					turn_degrees = vm.f32(turn_degrees * -1.0)
				end
				movement.turn_to_heading_with_reaction(turn_degrees, 4.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				is_target_threatening = sense.wait_for_target_in_cone_or_approaching(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if is_target_threatening == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 70 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_for_target_in_cone_or_approaching(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			heading_degrees = monster.get_random_whole_number(180.0) or heading_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				heading_degrees = vm.f32(heading_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_heading_with_reaction(heading_degrees, 4.0)
			monster.set_motion("立ち", -1, 0)
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_variable(0, 4)
					roll = monster.get_random(100) or roll
					orbit_angle_degrees = monster.get_random_whole_number(180.0) or orbit_angle_degrees
					orbit_radius = monster.get_random_whole_number(30.0) or orbit_radius
					target_distance = monster.get_target_distance() or target_distance
					orbit_radius = vm.f32(orbit_radius + target_distance)
					if roll < 50 then
						orbit_angle_degrees = vm.f32(orbit_angle_degrees * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						orbit_angle_degrees = vm.f32(-orbit_angle_degrees - 30.0)
					else
						orbit_angle_degrees = vm.f32(orbit_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					is_target_threatening = movement.move_to_point_around_target(vm.f32(1.9), 4.0, orbit_angle_degrees, orbit_radius, 37.0, 60)
					final_turn_degrees = monster.get_random_whole_number(360.0) or final_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
					end
					movement.turn_to_heading_with_reaction(final_turn_degrees, 4.0)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						rotation_y = out2 or rotation_y
					end
					heading_degrees = calc.radians_to_degrees(rotation_y)
					if heading_degrees > vm.f32(3.1415927) then
						heading_degrees = vm.f32(heading_degrees - vm.f32(6.2831855))
					end
					if heading_degrees <= vm.f32(-3.1415927) then
						heading_degrees = vm.f32(heading_degrees + vm.f32(6.2831855))
					end
					movement.move_along_heading(vm.f32(1.9), heading_degrees, 1000.0, 37.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				is_target_threatening = sense.wait_for_target_in_cone_or_approaching(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if is_target_threatening == 1 then
					return
				end
			end
		elseif unused_selector == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			distance_from_home = monster.get_target_distance() or distance_from_home
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.move_in_random_direction(vm.f32(1.9), 4.0, distance_from_home, 360.0, 40.0, 37.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Walks after the target for a while.
local function chase_target()
	monster.set_motion("歩き", -1, 0)
	movement.chase_target_by_moving(vm.f32(1.9), 4.0, 37.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Fights the target by distance each frame until rage hits are available.
local function fight_without_rage_hits()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		timer.wait_frame_with_reaction()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			act_passively()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 95.0 then
			roll = monster.get_random(100) or roll
			if roll < 60 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					monster.set_motion("歩き", -1, 0)
					advance_toward_target(3.0, 4.0, 37.0, 30)
					movement.turn_toward_target_until_facing(4.0)
					attack_first_swing()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_reaction(2)
				else
					monster.set_motion("歩き", -1, 0)
					advance_toward_target(3.0, 4.0, 37.0, 30)
					movement.turn_toward_target_until_facing(4.0)
					attack_second_swing()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_reaction(2)
				end
			else
				roll = monster.get_random(100) or roll
				if roll < 80 then
					roll = monster.get_random(100) or roll
					if roll < 50 then
						monster.set_motion("歩き", -1, 0)
						advance_toward_target(3.0, 4.0, 37.0, 30)
						movement.turn_toward_target_until_facing(4.0)
						attack_second_then_first_swing()
						monster.set_motion("立ち", -1, 0)
						timer.wait_frames_with_reaction(2)
					else
						monster.set_motion("歩き", -1, 0)
						advance_toward_target(3.0, 4.0, 37.0, 30)
						movement.turn_toward_target_until_facing(4.0)
						attack_second_then_first_swing()
						monster.set_motion("立ち", -1, 0)
						timer.wait_frames_with_reaction(2)
					end
				else
					monster.set_motion("歩き", -1, 0)
					advance_toward_target(3.0, 4.0, 37.0, 30)
					movement.turn_toward_target_until_facing(4.0)
					attack_first_then_second_swing()
					monster.set_motion("立ち", -1, 0)
					timer.wait_frames_with_reaction(2)
				end
			end
		else
			monster.set_motion("歩き", -1, 0)
			advance_toward_target(vm.f32(2.28), 4.0, 37.0, 30)
		end
	end
end

--- Picks the fighting, roaming or guarding behaviour from the rage state, guard state and target distance.
local function update_behavior()
	local target_distance: f32 = 0
	local guard_range: f32 = 0
	local rage_hits_left: s32 = 0
	heal_weakest_ally()
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	target_distance = monster.get_target_distance() or target_distance
	if rage_hits_left > 0 then
		check_player_transformation()
		if reaction.is_guard_active() == 0 then
			if target_distance < 255.0 then
				fight_with_rage_hits_left()
			else
				wander_while_unengaged()
			end
		else
			guard_range = state.get_secondary_float(guard_range)
			if target_distance < guard_range then
				if target_distance < 168.0 then
					monster.set_monster_escape_rate(-1, 1.0)
					reaction.set_guard_active(0)
					fight_with_rage_hits_left()
				else
					monster.set_monster_escape_rate(-1, 10.0)
					chase_target()
				end
			else
				monster.set_monster_escape_rate(-1, 1.0)
				reaction.set_guard_active(0)
			end
		end
	else
		fight_without_rage_hits()
	end
end

local script = {}

--- Does nothing; the monster needs no load-time setup.
function script.setup() end

--- Registers the monster's attacks, photo pose and healing effects when it is placed.
function script.init()
	local grade: s32 = 0
	local texture_block: s32 = 0
	local heal_flash_loaded: s32 = 0
	local heal_effect_loaded: s32 = 0
	monster.register_damage_hit("弱ＧＣ", 5.0, "攻撃１", 0.35, 0.45, 0)
	monster.register_damage_hit("弱ＧＣ", 5.0, "攻撃１", 0.35, 0.45, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 7.0, "攻撃２", 0.35, 0.5, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 7.0, "攻撃２", 0.35, 0.5, 1)
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("遊び", 0.18, 0.66, 1010)
	end
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		heal_flash_loaded = monster.load_effect_script("Ｍ回復Ｆ", texture_block) or heal_flash_loaded
		heal_effect_loaded = monster.load_effect_script("Ｍ回復", texture_block) or heal_effect_loaded
		if (if heal_flash_loaded ~= 0 then 1 else heal_effect_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(7, 90)
	configure_defaults()
end

--- Runs the behaviour update every frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		timer.wait_frame_with_reaction()
		update_behavior()
	end
end

--- Plays the damage pose until the status ailment ends.
function script.on_status_hit()
	local ailments: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailments = 1
	while ailments ~= 0 do
		ailments = monster.get_status_ailments(40) or ailments
		timer.wait_frame_with_reaction()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers and recovers after a normal hit.
function script.on_damage()
	local roll: s32 = 0
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_with_reaction()
	timer.wait_frames_with_reaction(12)
	monster.set_motion("立ち")
	roll = monster.get_random(100) or roll
	if roll < 8 then
		monster.set_motion("ステップ後", -1, 0)
		step_back_from_target(vm.f32(2.85))
	end
	state.do_nothing()
end

--- Plays the knockdown, lies on the ground and gets back up.
function script.on_knockdown()
	reaction.begin_knockdown_facing_target()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_with_reaction()
	monster.set_action_status(1)
	timer.wait_frames_with_reaction(30)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_with_reaction()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Raises a guard against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.get_random(100)
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_with_reaction()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_reaction(8)
	monster.set_motion("ガードout", -1, 2)
	motion.wait_until_finished_with_reaction()
	monster.set_motion("立ち")
	state.unlock()
end

--- Dodges in response to the target's first kind of attack.
function script.on_dodge_1()
	local roll: s32 = 0
	state.lock_and_reset_motion()
	roll = monster.get_random(20) or roll
	if roll < 20 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_until_facing(4.0)
		sidestep_around_target()
	else
		monster.set_motion("ステップ後", -1, 0)
		step_back_from_target(vm.f32(2.85))
	end
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Dodges in response to the target's second kind of attack.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_with_reaction()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_reaction(8)
	monster.set_motion("ガードout", -1, 2)
	motion.wait_until_finished_with_reaction()
	monster.set_motion("立ち")
	state.unlock()
end

--- Plays the death animation and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Struggles while held by the player.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		timer.wait_frame_with_reaction()
	end
end

--- Recovers after landing from a throw.
function script.on_land()
	reaction.end_throw_with_reaction()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_with_reaction(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_with_reaction()
	state.do_nothing_hook()
	return 1
end

--- Plays the stun recovery.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_with_reaction()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_with_reaction()
	reaction.stun_until_recovered()
end

return script
