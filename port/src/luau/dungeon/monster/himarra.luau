--!strict
--- Controls the Himarra family of plant monsters that spit sticky goo and spin.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local calc = require("@lib/monster/calc")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the guard, clip distance and secondary variable defaults shared by this monster's behaviour.
local function initialize_behavior_defaults()
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

--- Either strafes around the target or waits for it to come in front, chosen at random.
local function strafe_or_wait()
	local random_roll: s32 = 0
	local angle_degrees: f32 = 0
	local distance: f32 = 0
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 50 then
		random_roll = monster.get_random(100) or random_roll
		angle_degrees = monster.get_random_whole_number(30.0) or angle_degrees
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 70.0)
		if random_roll < 50 then
			angle_degrees = vm.f32(-angle_degrees - 30.0)
		else
			angle_degrees = vm.f32(angle_degrees + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = movement.walk_to_point_near_target(vm.f32(1.8), 4.0, angle_degrees, distance, 38.0, 30)
		movement.turn_toward_target_and_wait_guarded(4.0)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(38.0, 45.0, 30)
	end
end

--- Walks or runs toward the target, or waits for it to come in front.
local function act_at_far_range()
	local random_roll: s32 = 0
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 80 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			monster.set_motion("歩き", -1.0, 0)
			movement.chase_target_guarded(vm.f32(1.8), 4.0, 70.0, 60)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			monster.set_motion("走り", -1.0, 0)
			movement.chase_target_guarded(5.0, 4.0, 38.0, 60)
			monster.set_motion("立ち", -1, 0)
		end
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_in_front(70.0, 45.0, 30)
	end
end

--- Spits a sticky glob at the target.
local function spit_sticky_goo()
	local attack: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.reset_motion()
	monster.set_motion("攻撃２", -1, 6)
	motion.wait_until_progress(vm.f32(0.372), vm.f32(0.02))
	do
		local out1, out2, out3 = monster.get_frame_position("dcol01")
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
	monster.create_effect_1("ねばねばＬ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	motion.wait_until_finished_guarded()
end

--- Steps to the left or right around the target.
local function side_step()
	local random_roll: s32 = 0
	local target: f32 = 0
	local approach_y: f32 = 0
	local target_3: f32 = 0
	local target_distance: f32 = 0
	local side_offset_degrees: f32 = 0
	local pos_y: f32 = 0
	target_distance = monster.get_target_distance() or target_distance
	monster.set_monster_attributes(32, 1)
	monster.reset_motion()
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 50 then
		monster.set_motion("ステップ右", -1, 6)
		side_offset_degrees = 30.0
	else
		monster.set_motion("ステップ左", -1, 6)
		side_offset_degrees = -30.0
	end
	target, approach_y, target_3 = movement.get_approach_point(side_offset_degrees, target_distance, target, approach_y, target_3)
	timer.wait_frames_guarded(7)
	do
		local _, out2, _ = monster.get_position_3()
		pos_y = out2 or pos_y
	end
	monster.move_toward_position(target, pos_y - 20.0, target_3, 2.8799999, 2.8799999)
	timer.wait_frames_guarded(3)
	timer.wait_frames_guarded(6)
	monster.set_monster_attributes(32, 0)
	motion.wait_until_finished_guarded()
	monster.stop_moving()
end

--- Spits goo, closes in, side steps or wanders when the target is at medium range.
local function act_at_mid_range()
	local target_distance: f32 = 0
	local random_roll: s32 = 0
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 45 then
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_toward_target_and_wait_guarded(4.0)
		spit_sticky_goo()
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames_guarded(8)
	else
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				monster.set_motion("歩き", -1.0, 0)
				movement.chase_target_guarded(vm.f32(1.8), 4.0, 38.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				monster.set_motion("走り", -1.0, 0)
				movement.chase_target_guarded(5.0, 4.0, 38.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 30 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				side_step()
				monster.set_motion("立ち", -1, 0)
			else
				target_distance = monster.get_target_distance() or target_distance
				random_roll = monster.get_random(15) or random_roll
				monster.set_motion("歩き", -1.0, 0)
				movement.wander(vm.f32(1.8), 4.0, target_distance, 360.0, 40.0, 38.0, vm.i32(45 + random_roll))
				monster.set_motion("立ち", -1, 0)
			end
		end
	end
	reaction.update_and_wait_frame()
end

--- Spins in place with a damaging rotation attack.
local function spin_attack()
	local attack: s32 = 0
	attack = monster.get_attack_power_1() or attack
	monster.set_motion("攻撃１in", -1, 2)
	motion.wait_until_finished_guarded()
	monster.create_effect_1("ヒマーラ回転攻撃")
	monster.set_effect_value(-1, 0, attack)
	monster.set_motion("攻撃１", -1, 4)
	timer.wait_frames_guarded(30)
	monster.set_motion("攻撃１out", -1, 6)
	motion.wait_until_finished_guarded()
end

--- Attacks, side steps or circles when the target is close.
local function act_at_near_range()
	local random_roll: s32 = 0
	local life: f32 = 0
	local approach_distance: f32 = 0
	local side_angle_degrees: f32 = 0
	life = 0.0
	life = monster.get_life() or life
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 45 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 80 then
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			monster.set_motion("歩き", -1.0, 0)
			movement.chase_target_guarded(vm.f32(1.8), 4.0, 58.0, 30)
			spin_attack()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_guarded(8)
		else
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			spit_sticky_goo()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_guarded(8)
		end
	else
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			if life > vm.f32(0.23) then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				monster.set_motion("歩き", -1.0, 0)
				movement.chase_target_guarded(vm.f32(1.8), 4.0, 38.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				side_step()
				monster.set_motion("立ち", -1, 0)
			end
		else
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				side_angle_degrees = -30.0
			else
				side_angle_degrees = 30.0
			end
			random_roll = monster.get_random(100) or random_roll
			monster.set_motion("歩き", -1.0, 0)
			movement.walk_to_point_near_target(vm.f32(1.8), 4.0, side_angle_degrees, approach_distance, 38.0, vm.i32(45 + random_roll))
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(38.0, 45.0, 30)
		end
	end
	reaction.update_and_wait_frame()
end

--- Repeatedly picks a behaviour by target distance until the target is far away.
local function engage_target()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		behavior.try_face_transformed_player_speed_4()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 310.0 then
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin <= 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			strafe_or_wait()
			continue
		end
		if target_distance < 310.0 and target_distance >= 200.0 then
			act_at_far_range()
		elseif target_distance < 200.0 and target_distance >= 70.0 then
			act_at_mid_range()
		else
			act_at_near_range()
		end
		reaction.update_and_wait_frame()
	end
end

--- Wanders around or waits for the target while it is far away.
local function wander_when_far()
	local random_roll: s32 = 0
	local action_result: s32 = 0
	local wander_state: s32 = 0
	local distance: f32 = 0
	local turn_angle_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local facing_angle: f32 = 0
	local clear_distance: f32 = 0
	local orbit_angle_degrees: f32 = 0
	local final_turn_degrees: f32 = 0
	local approach_angle_degrees: f32 = 0
	local approach_distance: f32 = 0
	local target_distance: f32 = 0
	local end_turn_degrees: f32 = 0
	reaction.update_and_wait_frame()
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
	distance = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		facing_angle = out2 or facing_angle
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 38.0 then
		turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle_degrees, 4.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 38.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(4.0, vm.f32(1.4), turn_angle_degrees, clear_distance, 38.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 300.0 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 90 then
			if distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				monster.set_place_position(pos_x, pos_y, pos_z)
			end
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 30 then
				monster.set_variable(0, 4)
				random_roll = monster.get_random(100) or random_roll
				orbit_angle_degrees = monster.get_random_whole_number(360.0) or orbit_angle_degrees
				distance = monster.get_random_whole_number(150.0) or distance
				if random_roll < 50 then
					orbit_angle_degrees = vm.f32(-orbit_angle_degrees - 30.0)
				else
					orbit_angle_degrees = vm.f32(orbit_angle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_pos_x, place_pos_y, place_pos_z, vm.f32(1.4), 4.0, distance, orbit_angle_degrees, 38.0, 60)
				final_turn_degrees = monster.get_random_whole_number(180.0) or final_turn_degrees
				random_roll = monster.get_random(100) or random_roll
				if random_roll < 50 then
					final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(final_turn_degrees, 4.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				action_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 33.0, vm.f32(1.2), 30)
				if action_result == 1 then
					return
				end
			end
			monster.get_random(100, random_roll)
			return
		end
	end
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 65 then
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 33.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle_degrees = monster.get_random_whole_number(180.0) or turn_angle_degrees
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				turn_angle_degrees = vm.f32(turn_angle_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_angle_degrees, 4.0)
			monster.set_motion("立ち", -1, 0)
		end
	else
		random_roll = monster.get_random(100) or random_roll
		if random_roll < 50 then
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				random_roll = monster.get_random(100) or random_roll
				if random_roll < 50 then
					monster.set_variable(0, 4)
					random_roll = monster.get_random(100) or random_roll
					approach_angle_degrees = monster.get_random_whole_number(180.0) or approach_angle_degrees
					approach_distance = monster.get_random_whole_number(30.0) or approach_distance
					target_distance = monster.get_target_distance() or target_distance
					approach_distance = vm.f32(approach_distance + target_distance)
					if random_roll < 50 then
						approach_angle_degrees = vm.f32(approach_angle_degrees * -1.0)
					end
					random_roll = monster.get_random(100) or random_roll
					if random_roll < 50 then
						approach_angle_degrees = vm.f32(-approach_angle_degrees - 30.0)
					else
						approach_angle_degrees = vm.f32(approach_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					action_result = movement.walk_to_point_near_target(vm.f32(1.4), 4.0, approach_angle_degrees, approach_distance, 38.0, 60)
					end_turn_degrees = monster.get_random_whole_number(360.0) or end_turn_degrees
					random_roll = monster.get_random(100) or random_roll
					if random_roll < 50 then
						end_turn_degrees = vm.f32(end_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(end_turn_degrees, 4.0)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						facing_angle = out2 or facing_angle
					end
					turn_angle_degrees = calc.radians_to_degrees(facing_angle)
					if turn_angle_degrees > vm.f32(3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees - vm.f32(6.2831855))
					end
					if turn_angle_degrees <= vm.f32(-3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(vm.f32(1.4), turn_angle_degrees, 1000.0, 38.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				action_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 33.0, vm.f32(1.2), 30)
				if action_result == 1 then
					return
				end
			end
		elseif wander_state == 8 then
			monster.set_variable(0, 1)
			random_roll = monster.get_random(120) or random_roll
			distance = monster.get_target_distance() or distance
			random_roll = vm.i32(random_roll + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(vm.f32(1.4), 4.0, distance, 360.0, 40.0, 38.0, random_roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Runs at the target and may spit goo on arrival.
local function rush_and_spit_goo()
	local random_roll: s32 = 0
	monster.set_motion("歩き", -1.0, 0)
	movement.turn_toward_target_and_wait_guarded(4.0)
	monster.set_motion("走り", -1, 0)
	movement.chase_target_guarded(5.0, 4.0, 70.0, 60)
	monster.set_motion("立ち", -1, 0)
	random_roll = monster.get_random(100) or random_roll
	if random_roll < 70 then
		spit_sticky_goo()
	end
end

--- Fights aggressively with spins, goo and rushes once the rage hits are used up.
local function act_when_no_rage_hits_left()
	local range_distance: f32 = 0
	local priority: s32 = 0
	local random_roll: s32 = 0
	local gekirin: s32 = 0
	local target_distance: f32 = 0
	local target_angle: f32 = 0
	print("start gekirn----------------------\n")
	while true do
		reaction.update_and_wait_frame()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(vm.f32(1.8))
				monster.set_motion("歩き", -1.0, 0)
				movement.move_in_direction_guarded(vm.f32(1.8), 180.0, 200.0, 38.0, 90)
				monster.set_motion("立ち", -1, 0)
			else
				motion.idle_for_frames(30)
			end
			continue
		end
		if range_distance < 310.0 and range_distance >= 200.0 then
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 50 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_with_offset_guarded(8.0, 30.0, 15)
				spit_sticky_goo()
			else
				monster.set_motion("歩き", -1.0, 0)
				movement.chase_target_guarded(vm.f32(3.6), 4.0, 38.0, 60)
				monster.set_motion("立ち", -1, 0)
			end
		else
			target_distance = monster.get_target_distance() or target_distance
			if target_distance < 70.0 then
				random_roll = monster.get_random(100) or random_roll
				if random_roll < 60 then
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					spit_sticky_goo()
				end
			end
			random_roll = monster.get_random(100) or random_roll
			if random_roll < 65 then
				random_roll = monster.get_random(100) or random_roll
				if random_roll < 40 then
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					spit_sticky_goo()
				else
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					spin_attack()
				end
			else
				random_roll = monster.get_random(100) or random_roll
				if random_roll < 70 then
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					target_angle = monster.get_target_angle() or target_angle
					movement.move_in_direction_guarded(vm.f32(2.6999998), target_angle, 100.0, 38.0, 45)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_and_wait_guarded(4.0)
					monster.set_motion("歩き", -1.0, 0)
					movement.chase_target_guarded(vm.f32(2.6999998), 4.0, 38.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			end
		end
		monster.set_motion("走り", -1, 0)
		movement.chase_target_guarded(5.0, 4.0, 38.0, 60)
		reaction.update_and_wait_frame()
	end
end

--- Chooses between engaging, wandering and the aggressive behaviour from the rage and guard state.
local function choose_behavior()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local gekirin: s32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		behavior.try_face_transformed_player_speed_4()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 310.0 then
				engage_target()
			else
				wander_when_far()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 200.0 then
					reaction.set_guard_active(0)
					engage_target()
				else
					rush_and_spit_goo()
				end
			else
				reaction.set_guard_active(0)
			end
		end
	else
		act_when_no_rage_hits_left()
	end
end

local script = {}

--- Runs once when the script is loaded, before any program.
function script.setup() end

--- Loads the spin and goo effects and applies the shared defaults.
function script.init()
	local get_not_used_texb: s32 = 0
	local spin_effect_loaded: s32 = 0
	local goo_low_loaded: s32 = 0
	local goo_high_loaded: s32 = 0
	get_not_used_texb = monster.get_free_texture_block() or get_not_used_texb
	if get_not_used_texb ~= -1 then
		spin_effect_loaded = monster.load_effect_script("ヒマーラ回転攻撃", get_not_used_texb) or spin_effect_loaded
		goo_low_loaded = monster.load_effect_script("ねばねばＬ", get_not_used_texb) or goo_low_loaded
		goo_high_loaded = monster.load_effect_script("ねばねばＨ", get_not_used_texb) or goo_high_loaded
		if (if (if spin_effect_loaded ~= 0 then 1 else goo_low_loaded) ~= 0 then 1 else goo_high_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	initialize_behavior_defaults()
	state.set_secondary_flag(150)
end

--- Each frame chooses the monster's behaviour from its rage, guard state and target distance.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.stop_sound(5)
	while true do
		reaction.update_and_wait_frame()
		choose_behavior()
	end
end

--- Stops the monster in a hurt pose until its status ailments clear.
function script.on_status_hit()
	local ailment_flags: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailment_flags = 1
	while ailment_flags ~= 0 do
		ailment_flags = monster.get_status_ailments(40) or ailment_flags
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the flinch reaction when the monster is hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_guarded(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knockdown reaction when the monster is knocked over.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_guarded()
	monster.set_action_status(1)
	timer.wait_frames_guarded(45)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Plays the guard reaction when the monster blocks a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_guarded(8)
	monster.set_motion("ガードout", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Side steps around the target.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(4.0)
	side_step()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Side steps around the target.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(4.0)
	side_step()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the monster's death sequence.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Plays the struggling pose while the monster is held.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
end

--- Recovers the monster after a throw lands.
function script.on_land()
	combat.finish_throw_guarded()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_guarded(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	state.do_nothing_hook()
	return 1
end

--- Plays the stun reaction until the monster recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
