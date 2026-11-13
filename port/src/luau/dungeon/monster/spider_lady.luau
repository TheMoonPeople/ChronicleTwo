--!strict
--- Controls the Spider Lady family, casters that fire curse bullets and heal wounded monsters nearby.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the guard thresholds and the clip distance used by the monster.
local function configure_defense_and_clipping()
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

--- Turns toward another monster for a number of frames.
local function face_monster_for_frames(monster_id: s32, rot_speed: f32, frames: s32)
	local monster_x: f32 = 0
	local monster_y: f32 = 0
	local monster_z: f32 = 0
	local angle_to_monster: f32 = 0
	print("id=", monster_id, "-----------------\n")
	rot_speed = vm.f32(vm.f32(rot_speed / 180.0) * vm.f32(3.1415927))
	for frame = 0, frames - 1 do
		do
			local out1, out2, out3 = monster.get_monster_position(monster_id)
			monster_x = out1 or monster_x
			monster_y = out2 or monster_y
			monster_z = out3 or monster_z
		end
		angle_to_monster = monster.get_angle_to_position(monster_x, monster_y, monster_z) or angle_to_monster
		monster.turn_toward_angle(angle_to_monster, rot_speed)
		vm.wait()
	end
	movement.stop_turning()
end

--- Turns toward another monster until the current motion reaches a progress point.
local function face_monster_until_progress(monster_id: s32, rot_speed: f32, progress: f32, tolerance: f32)
	local monster_x: f32 = 0
	local monster_y: f32 = 0
	local monster_z: f32 = 0
	local angle_to_monster: f32 = 0
	local motion_progress: f32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.05)
	end
	rot_speed = calc.degrees_to_radians(rot_speed)
	while true do
		do
			local out1, out2, out3 = monster.get_monster_position(monster_id)
			monster_x = out1 or monster_x
			monster_y = out2 or monster_y
			monster_z = out3 or monster_z
		end
		angle_to_monster = monster.get_angle_to_position(monster_x, monster_y, monster_z) or angle_to_monster
		monster.turn_toward_angle(angle_to_monster, rot_speed)
		motion_progress = monster.get_motion_progress() or motion_progress
		if motion_progress < vm.f32(progress + tolerance) and motion_progress > vm.f32(progress - tolerance) then
			break
		else
			timer.wait_frame_with_reaction()
		end
	end
	movement.stop_turning()
end

--- Waits until the current motion reaches a progress point or finishes.
local function wait_until_progress(progress: f32, tolerance: f32)
	local motion_progress: f32 = 0
	local frames_waited: s32 = 0
	local motion_finished: s32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.03)
	end
	frames_waited = 0
	while true do
		timer.wait_frame_with_reaction()
		motion_progress = monster.get_motion_progress() or motion_progress
		if motion_progress < vm.f32(progress + tolerance) and motion_progress > vm.f32(progress - tolerance) then
			break
		else
			motion_finished = monster.is_motion_finished() or motion_finished
			if motion_finished ~= 0 then
				break
			else
				frames_waited = vm.i32(frames_waited + 1)
			end
		end
	end
end

--- Casts a recovery spell on the most wounded nearby monster, itself included.
local function heal_wounded_monster()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local candidate_life_fraction: f32 = 0
	local lowest_life_fraction: f32 = 0
	local ally_x: f32 = 0
	local ally_y: f32 = 0
	local ally_z: f32 = 0
	local rank: s32 = 0
	local candidate_id: s32 = 0
	local ally_id: s32 = 0
	local monster_count: s32 = 0
	local value: s32 = 0
	local heal_bonus: s32 = 0
	local max_life: s32 = 0
	local heal_amount: s32 = 0
	local chara_type: s32 = 0
	local own_life_fraction: s32 = 0
	local ally_life_fraction: s32 = 0
	local angle_to_ally: f32 = 0
	local life_fraction: f32 = 0
	value = monster.get_variable(7) or value
	if value < 300 then
		return
	end
	monster_count = monster.get_monster_count() or monster_count
	rank = 0
	ally_id = -1
	lowest_life_fraction = monster.get_monster_life_fraction(-1) or lowest_life_fraction
	while rank < monster_count do
		candidate_id = monster.get_nearby_monster(150.0, rank) or candidate_id
		if candidate_id ~= -1 then
			candidate_life_fraction = monster.get_monster_life_fraction(candidate_id) or candidate_life_fraction
		end
		if candidate_life_fraction < lowest_life_fraction then
			lowest_life_fraction = candidate_life_fraction
			ally_id = candidate_id
		end
		rank = rank + 1
	end
	if ally_id ~= -1 then
		own_life_fraction = vm.float_bits(monster.get_monster_life_fraction(-1)) or own_life_fraction
		ally_life_fraction = vm.float_bits(monster.get_monster_life_fraction(ally_id)) or ally_life_fraction
		if own_life_fraction < ally_life_fraction then
			ally_id = -2
		end
	else
		lowest_life_fraction = monster.get_monster_life_fraction(-1) or lowest_life_fraction
		ally_id = -2
	end
	if ally_id == -1 or lowest_life_fraction > vm.f32(0.9) then
		return
	end
	if ally_id == -2 then
		ally_id = -1
	else
		do
			local out1, out2, out3 = monster.get_monster_position(ally_id)
			ally_x = out1 or ally_x
			ally_y = out2 or ally_y
			ally_z = out3 or ally_z
		end
		angle_to_ally = monster.get_angle_to_position(ally_x, ally_y, ally_z) or angle_to_ally
		monster.set_motion("歩き", -1, 0)
		movement.turn_to_heading_with_reaction(calc.radians_to_degrees(angle_to_ally), 6.0)
	end
	monster.set_motion("攻撃２in", -1, 6)
	if ally_id ~= -1 then
		face_monster_for_frames(ally_id, 6.0, calc.pass_through(12))
	else
		timer.wait_frames(calc.pass_through(15))
	end
	monster.set_motion("攻撃２loop", -1, 6)
	if ally_id ~= -1 then
		face_monster_for_frames(ally_id, 6.0, 24)
	else
		timer.wait_frames(24)
	end
	monster.set_motion("攻撃２", -1, 6)
	do
		local out1, out2, out3 = monster.get_frame_position("magic_coll")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.create_effect_1("Ｍ回復Ｆ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	if ally_id ~= -1 then
		face_monster_until_progress(ally_id, 3.0, vm.f32(0.497), -1.0)
	else
		wait_until_progress(3.0, vm.f32(0.497))
	end
	if ally_id == -1 then
		chara_type = monster.get_character_number() or chara_type
	else
		chara_type = ally_id
	end
	life_fraction = monster.get_monster_life_fraction(chara_type) or life_fraction
	if life_fraction <= 0.0 then
		return
	end
	monster.create_effect_1("Ｍ回復")
	monster.set_effect_value(-1, 0, chara_type)
	if ally_id ~= -1 then
		face_monster_for_frames(ally_id, 6.0, calc.pass_through(15))
	else
		timer.wait_frames(calc.pass_through(15))
	end
	life_fraction = monster.get_monster_life_fraction(chara_type) or life_fraction
	if life_fraction <= 0.0 then
		return
	end
	max_life = monster.get_monster_max_life(ally_id) or max_life
	heal_amount = vm.ftoi(vm.f32(max_life * vm.f32(0.3)))
	heal_bonus = monster.get_random(vm.ftoi(vm.f32(heal_amount * vm.f32(0.2)))) or heal_bonus
	heal_amount = vm.i32(vm.ftoi(vm.f32(heal_amount * vm.f32(0.8))) + heal_bonus)
	monster.show_damage_number(ally_id, heal_amount, 1)
	monster.add_monster_life(ally_id, heal_amount)
	if ally_id ~= -1 then
		face_monster_for_frames(ally_id, 6.0, calc.pass_through(15))
	else
		timer.wait_frames(calc.pass_through(15))
	end
	monster.set_variable(7, 0)
	motion.wait_until_finished()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames(10)
end

--- Faces the target for as long as the player stays transformed.
local function face_target_while_player_transformed(monster_kind: any)
	local chara_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		timer.wait_frame_with_reaction()
		chara_id = monster.get_player_transform_id() or chara_id
		if chara_id == -1 then
			break
		else
			if sense.is_facing_target_within_angle(60.0) == 0 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_until_facing(3.0)
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Faces the target when the player is currently transformed.
local function wait_out_player_transformation()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	chara_id = monster.get_player_transform_id() or chara_id
	if chara_id > -1 then
		face_target_while_player_transformed(monster_id)
	end
end

--- Strafes to a spot beside the target or waits for the target to line up.
local function reposition_near_target()
	local roll: s32 = 0
	local side_angle: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		side_angle = monster.get_random_whole_number(30.0) or side_angle
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 110.0)
		if roll < 50 then
			side_angle = vm.f32(-side_angle - 30.0)
		else
			side_angle = vm.f32(side_angle + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = movement.move_to_point_around_target(2.0, 3.0, side_angle, distance, 47.0, 30)
		movement.turn_toward_target_until_facing(3.0)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_for_target_in_cone(47.0, 45.0, 30)
	end
end

--- Turns toward the target until the current motion reaches a progress point.
local function face_target_until_progress(turn_speed_degrees: f32, progress: f32, tolerance: f32)
	local target_angle: f32 = 0
	local motion_progress: f32 = 0
	local rot_speed: f32 = 0
	if tolerance == -1.0 then
		tolerance = vm.f32(0.05)
	end
	rot_speed = calc.degrees_to_radians(turn_speed_degrees)
	if rot_speed > vm.f32(3.1415927) then
		rot_speed = vm.f32(rot_speed - vm.f32(6.2831855))
	end
	if rot_speed <= vm.f32(-3.1415927) then
		rot_speed = vm.f32(rot_speed + vm.f32(6.2831855))
	end
	while true do
		target_angle = monster.get_target_angle() or target_angle
		monster.turn_toward_angle(target_angle, rot_speed)
		motion_progress = monster.get_motion_progress() or motion_progress
		if motion_progress < vm.f32(progress + tolerance) and motion_progress > vm.f32(progress - tolerance) then
			break
		else
			timer.wait_frame_with_reaction()
		end
	end
	movement.stop_turning()
end

--- Charges and fires a curse bullet at the target.
local function cast_curse_bullet()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local attack: s32 = 0
	monster.set_variable(0, 2)
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_until_facing(3.0)
	monster.set_motion("攻撃２in", -1, 6)
	timer.wait_frames_with_reaction(calc.pass_through(12))
	monster.set_motion("攻撃２loop", -1, 2)
	movement.track_target_for_frames(3.0, calc.pass_through(24))
	monster.set_motion("攻撃２", -1, 6)
	face_target_until_progress(3.0, vm.f32(0.513), vm.f32(0.01))
	do
		local out1, out2, out3 = monster.get_frame_position("magic_coll")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	monster.create_effect_1("呪い弾Ｆ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	wait_until_progress(vm.f32(0.533), vm.f32(0.01))
	monster.create_effect_1("呪い弾Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished_with_reaction()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_reaction(9)
end

--- Picks an attack or approach for when the target is far away.
local function act_at_long_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local life: f32 = 0
	local side_angle: f32 = 0
	life = 0.0
	target_distance = monster.get_target_distance() or target_distance
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 45 then
			roll = monster.get_random(100) or roll
			if roll < 25 then
				life = monster.get_life() or life
				if life < 0.5 then
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_until_facing(3.0)
					monster.set_motion("走り", -1, 0)
					movement.chase_target_by_moving(3.0, 3.0, 110.0, 60)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					movement.chase_target_by_moving(2.0, 3.0, 110.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_for_target_in_cone(47.0, 45.0, 75)
			end
		else
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_until_facing(3.0)
			cast_curse_bullet()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			side_angle = -30.0
		else
			side_angle = 30.0
		end
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_until_facing(3.0)
		monster.set_motion("歩き", -1, 0)
		movement.move_to_point_around_target(2.0, 3.0, side_angle, target_distance, 110.0, 45)
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_until_facing(3.0)
		monster.set_motion("立ち", -1, 0)
		sense.wait_for_target_in_cone(47.0, 45.0, 30)
	end
end

--- Sidesteps to the right or left for a distance unless a wall is in the way.
local function sidestep(speed: f32, distance: f32, step_right: s32, stop_margin: f32, max_frames: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local heading: f32 = 0
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local clear_distance: f32 = 0
	local wrapped_heading: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	if step_right ~= 0 then
		monster.set_motion("歩き右", -1, 0)
		heading = vm.f32(heading + vm.f32(1.5707964))
	else
		monster.set_motion("歩き左", -1, 0)
		heading = vm.f32(heading - vm.f32(1.5707964))
	end
	wrapped_heading = heading
	if wrapped_heading > vm.f32(3.1415927) then
		wrapped_heading = vm.f32(wrapped_heading - vm.f32(6.2831855))
	end
	if wrapped_heading <= vm.f32(-3.1415927) then
		wrapped_heading = vm.f32(wrapped_heading + vm.f32(6.2831855))
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 100.0 then
		distance = vm.f32(distance - clear_distance)
		if distance < stop_margin then
			return
		end
	end
	target = vm.f32(pos_x + vm.f32(vm.sin(wrapped_heading) * distance))
	target_2 = vm.f32(pos_y - 20.0)
	target_3 = vm.f32(pos_z + vm.f32(vm.cos(wrapped_heading) * distance))
	monster.move_toward_position(target, target_2, target_3, speed, speed)
	movement.wait_for_move_or_target_near(stop_margin, max_frames)
	monster.stop_moving()
end

--- Picks an attack or approach for when the target is at medium distance.
local function act_at_medium_range()
	local roll: s32 = 0
	local target_angle: f32 = 0
	local step_right: s32 = 0
	monster.get_target_distance()
	roll = monster.get_random(100) or roll
	if roll < 65 then
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_until_facing(3.0)
		cast_curse_bullet()
	else
		roll = monster.get_random(100) or roll
		if roll < 75 then
			monster.set_motion("走り", -1, 0)
			movement.chase_target_by_moving(3.0, 6.0, 47.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			target_angle = monster.get_target_angle() or target_angle
			roll = monster.get_random(100) or roll
			if roll < 50 then
				target_angle = vm.f32(target_angle - vm.f32(0.7853982))
				step_right = 1
			else
				target_angle = vm.f32(target_angle + vm.f32(0.7853982))
				step_right = 0
			end
			if target_angle > vm.f32(3.1415927) then
				target_angle = vm.f32(target_angle - vm.f32(6.2831855))
			end
			if target_angle <= vm.f32(-3.1415927) then
				target_angle = vm.f32(target_angle + vm.f32(6.2831855))
			end
			monster.set_motion("歩き", -1, 0)
			movement.turn_to_heading_with_reaction(calc.radians_to_degrees(target_angle), 3.0)
			sidestep(3.0, 80.0, step_right, 47.0, 60)
			monster.set_motion("歩き", -1, 0)
			movement.turn_toward_target_until_facing(3.0)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Turns to the target and attacks with its normal strike.
local function melee_attack()
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_until_facing(6.0)
	monster.set_motion("攻撃１", -1, 2)
	movement.track_target_for_frames(3.0, calc.pass_through(58))
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_reaction(9)
end

--- Hops backward away from the target.
local function step_backward()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local backward_heading: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		backward_heading = out2 or backward_heading
	end
	backward_heading = vm.f32(backward_heading + vm.f32(3.1415927))
	pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(backward_heading)))
	pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(backward_heading)))
	monster.set_monster_attributes(32, 1)
	monster.set_motion("ステップ後", -1, 6)
	timer.wait_frames_with_reaction(calc.pass_through(10))
	monster.move_toward_position(pos_x, pos_y, pos_z, 4.5, 4.5)
	timer.wait_frames_with_reaction(calc.pass_through(9))
	monster.stop_moving()
	motion.wait_until_finished_with_reaction()
	monster.set_monster_attributes(32, 0)
	monster.set_motion("立ち", -1, 0)
end

--- Picks an attack, approach or retreat for when the target is close.
local function act_at_short_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	local side_angle: f32 = 0
	monster.get_life()
	roll = monster.get_random(100) or roll
	if roll < 68 then
		target_distance = monster.get_target_distance() or target_distance
		roll = monster.get_random(100) or roll
		if target_distance < 70.0 then
			melee_attack()
		else
			cast_curse_bullet()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 75 then
			monster.set_motion("走り", -1, 0)
			movement.chase_target_by_moving(3.0, 6.0, 47.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				roll = monster.get_random(100) or roll
				side_angle = monster.get_random_whole_number(60.0) or side_angle
				if roll < 50 then
					side_angle = vm.f32(-side_angle - 30.0)
				else
					side_angle = vm.f32(side_angle + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				movement.move_to_point_around_target(2.0, 3.0, side_angle, 94.0, 1.0, 25)
				movement.turn_toward_target_until_facing(3.0)
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_reaction(9)
			else
				step_backward()
			end
		end
	end
end

--- Chooses attacks by target distance for as long as the monster has rage hits left.
local function fight_with_rage_hits()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		timer.wait_frame_with_reaction()
		heal_wounded_monster()
		monster.get_life()
		wait_out_player_transformation()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 270.0 then
			timer.wait_frame_with_reaction()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			timer.wait_frame_with_reaction()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			reposition_near_target()
			continue
		end
		if target_distance < 270.0 and target_distance >= 170.0 then
			act_at_long_range()
		elseif target_distance < 170.0 and target_distance >= 110.0 then
			act_at_medium_range()
		else
			act_at_short_range()
		end
	end
end

--- Wanders, waits or returns toward its home position while the target is out of range.
local function wander_near_home()
	local roll: s32 = 0
	local wait_result: s32 = 0
	local unused_state: s32 = 0
	local home_distance: f32 = 0
	local random_angle: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local heading: f32 = 0
	local clear_distance: f32 = 0
	local orbit_angle: f32 = 0
	local facing_angle: f32 = 0
	local strafe_angle: f32 = 0
	local strafe_distance: f32 = 0
	local target_distance: f32 = 0
	local final_angle: f32 = 0
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
	home_distance = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or home_distance
	do
		local _, out2, _ = monster.get_rotation()
		heading = out2 or heading
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 47.0 then
		random_angle = monster.get_random_whole_number(360.0) or random_angle
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_heading_with_reaction(random_angle, 3.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 47.0)
		if clear_distance > 0.0 then
			movement.move_along_heading_turning(3.0, vm.f32(1.8), random_angle, clear_distance, 47.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if home_distance > 300.0 then
		roll = monster.get_random(100) or roll
		if roll < 90 then
			if home_distance > 800.0 then
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
				orbit_angle = monster.get_random_whole_number(360.0) or orbit_angle
				home_distance = monster.get_random_whole_number(150.0) or home_distance
				if roll < 50 then
					orbit_angle = vm.f32(-orbit_angle - 30.0)
				else
					orbit_angle = vm.f32(orbit_angle + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.move_around_position(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.8), 3.0, home_distance, orbit_angle, 47.0, 60)
				facing_angle = monster.get_random_whole_number(180.0) or facing_angle
				roll = monster.get_random(100) or roll
				if roll < 50 then
					facing_angle = vm.f32(facing_angle * -1.0)
				end
				movement.turn_to_heading_with_reaction(facing_angle, 3.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_for_target_in_cone_or_approaching(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
			monster.get_random(100, roll)
			return
		end
	end
	roll = monster.get_random(100) or roll
	if roll < 75 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_for_target_in_cone_or_approaching(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			random_angle = monster.get_random_whole_number(180.0) or random_angle
			roll = monster.get_random(100) or roll
			if roll < 50 then
				random_angle = vm.f32(random_angle * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_heading_with_reaction(random_angle, 3.0)
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
					strafe_angle = monster.get_random_whole_number(180.0) or strafe_angle
					strafe_distance = monster.get_random_whole_number(30.0) or strafe_distance
					target_distance = monster.get_target_distance() or target_distance
					strafe_distance = vm.f32(strafe_distance + target_distance)
					if roll < 50 then
						strafe_angle = vm.f32(strafe_angle * -1.0)
					end
					roll = monster.get_random(100) or roll
					if roll < 50 then
						strafe_angle = vm.f32(-strafe_angle - 30.0)
					else
						strafe_angle = vm.f32(strafe_angle + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.move_to_point_around_target(vm.f32(1.8), 3.0, strafe_angle, strafe_distance, 47.0, 60)
					final_angle = monster.get_random_whole_number(360.0) or final_angle
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_angle = vm.f32(final_angle * -1.0)
					end
					movement.turn_to_heading_with_reaction(final_angle, 3.0)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						heading = out2 or heading
					end
					random_angle = calc.radians_to_degrees(heading)
					if random_angle > vm.f32(3.1415927) then
						random_angle = vm.f32(random_angle - vm.f32(6.2831855))
					end
					if random_angle <= vm.f32(-3.1415927) then
						random_angle = vm.f32(random_angle + vm.f32(6.2831855))
					end
					movement.move_along_heading(vm.f32(1.8), random_angle, 1000.0, 47.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_for_target_in_cone_or_approaching(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			roll = monster.get_random(120) or roll
			home_distance = monster.get_target_distance() or home_distance
			roll = vm.i32(roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.move_in_random_direction(vm.f32(1.8), 3.0, home_distance, 360.0, 40.0, 47.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Usually wanders, but occasionally sidesteps and waits for the target.
local function wander_or_sidestep()
	local roll: s32 = 0
	roll = monster.get_random(100) or roll
	if roll < 98 then
		wander_near_home()
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			sidestep(3.0, 80.0, 1, 47.0, 60)
		else
			sidestep(3.0, 80.0, 0, 47.0, 60)
		end
		monster.set_motion("立ち", -1, 0)
		sense.wait_for_target_in_cone(47.0, 45.0, 30)
	end
end

--- Runs at the target and stops close to it.
local function run_at_target()
	monster.set_motion("走り", -1, 0)
	movement.chase_target_by_moving(3.0, 3.0, 47.0, 90)
	monster.set_motion("立ち", -1, 0)
end

--- Chooses attacks by target distance once the monster has no rage hits left.
local function fight_without_rage_hits()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local gekirin: s32 = 0
	monster.get_life()
	while true do
		timer.wait_frame_with_reaction()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			reposition_near_target()
			continue
		end
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 110.0 then
			roll = monster.get_random(100) or roll
			if roll < 80 then
				roll = monster.get_random(100) or roll
				if roll < 50 then
					melee_attack()
				else
					cast_curse_bullet()
				end
			else
				monster.set_motion("走り", -1, 0)
				movement.chase_target_by_moving(3.0, 6.0, 47.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 60 then
				cast_curse_bullet()
			else
				roll = monster.get_random(100) or roll
				if roll < 90 then
					monster.set_motion("走り", -1, 0)
					movement.chase_target_by_moving(3.0, 3.0, 47.0, 30)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1, 0)
					movement.chase_target_by_moving(2.0, 6.0, 47.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
	end
end

--- Decides between fighting, wandering and guarding based on rage hits, guard state and target distance.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local gekirin: s32 = 0
	heal_wounded_monster()
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	target_distance = monster.get_target_distance() or target_distance
	if gekirin > 0 then
		wait_out_player_transformation()
		if reaction.is_guard_active() == 0 then
			if target_distance < 270.0 then
				fight_with_rage_hits()
			else
				wander_or_sidestep()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 170.0 then
					reaction.set_guard_active(0)
					fight_with_rage_hits()
				else
					run_at_target()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		fight_without_rage_hits()
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Registers the melee hit, loads the curse and recovery effects and configures defense.
function script.init()
	local get_not_used_texb: s32 = 0
	local texture_reserve_flag_1: s32 = 0
	local texture_reserve_flag_2: s32 = 0
	local texture_reserve_flag_3: s32 = 0
	monster.register_damage_hit("通常攻撃", 4.0, "攻撃１", 0.376, 0.411, 0)
	monster.set_variable(0, 0)
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		texture_reserve_flag_1 = monster.load_effect_script("呪い弾Ｆ", get_not_used_texb) or texture_reserve_flag_1
		texture_reserve_flag_2 = monster.load_effect_script("呪い弾Ｌ", get_not_used_texb) or texture_reserve_flag_2
		texture_reserve_flag_3 = monster.load_effect_script("呪い弾Ｈ", get_not_used_texb) or texture_reserve_flag_3
		if (if (if texture_reserve_flag_1 ~= 0 then 1 else texture_reserve_flag_2) ~= 0 then 1 else texture_reserve_flag_3) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		texture_reserve_flag_1 = monster.load_effect_script("Ｍ回復Ｆ", get_not_used_texb) or texture_reserve_flag_1
		texture_reserve_flag_2 = monster.load_effect_script("Ｍ回復", get_not_used_texb) or texture_reserve_flag_2
		if (if texture_reserve_flag_1 ~= 0 then 1 else texture_reserve_flag_2) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(7, 90)
	configure_defense_and_clipping()
end

--- Repeatedly chooses the monster's next behavior.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		timer.wait_frame_with_reaction()
		choose_behavior()
	end
end

--- Staggers in place while a status ailment lasts.
function script.on_status_hit()
	local ailment_flags: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailment_flags = 1
	while ailment_flags ~= 0 do
		ailment_flags = monster.get_status_ailments(40) or ailment_flags
		timer.wait_frame_with_reaction()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers back after a hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_with_reaction()
	timer.wait_frames_with_reaction(12)
	monster.set_motion("立ち", -1, 0)
	state.do_nothing()
end

--- Is knocked down and gets back up.
function script.on_knockdown()
	reaction.begin_knockdown_facing_target()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_with_reaction()
	monster.set_action_status(1)
	timer.wait_frames_with_reaction(45)
	monster.set_action_status(0)
	monster.set_motion("起き上り", -1, 6)
	motion.wait_until_finished_with_reaction()
	monster.set_motion("立ち", -1, 0)
	state.unlock_and_clear_action()
end

--- Guards against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_reaction(8)
	state.unlock()
end

--- Does nothing when dodging.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Does nothing when dodging.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Plays the death sequence.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Has no special behavior while caught.
function script.on_caught() end

--- Recovers after a throw without further action.
function script.on_land()
	reaction.end_throw_with_reaction()
	state.do_nothing_hook()
	return 1
end

--- Is stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_with_reaction()
	monster.set_motion("起き上り", -1, 6)
	motion.wait_until_finished_with_reaction()
	reaction.stun_until_recovered()
end

return script
