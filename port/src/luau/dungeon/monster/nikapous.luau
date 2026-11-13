--!strict
--- Controls the Nikapous family of monsters, which cast fireballs and slash with swords.

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

--- Sets the monster's guard threshold, behavior parameters and clip distance.
local function configure_guard_and_clip()
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

--- Strafes to a random point near the target or stands and watches it.
local function reposition_or_wait()
	local random_value: s32 = 0
	local side_angle_degrees: f32 = 0
	local distance: f32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 50 then
		random_value = monster.get_random(100) or random_value
		side_angle_degrees = monster.get_random_whole_number(30.0) or side_angle_degrees
		distance = monster.get_random_whole_number(30.0) or distance
		distance = vm.f32(distance + 60.0)
		if random_value < 50 then
			side_angle_degrees = vm.f32(-side_angle_degrees - 30.0)
		else
			side_angle_degrees = vm.f32(side_angle_degrees + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		local _ = movement.walk_to_point_near_target(1.5, 4.0, side_angle_degrees, distance, 35.0, 30)
		movement.turn_toward_target_and_wait_guarded(4.0)
	else
		monster.set_motion("立ち", -1, 0)
		sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
	end
end

--- Plays the spell attack and launches a fireball from the monster's hand toward the target.
local function cast_fireball()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local attack: s32 = 0
	monster.set_motion("攻撃２", -1, 2)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol2")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	attack = monster.get_attack_power_1() or attack
	movement.turn_until_motion_progress(4.0, vm.f32(0.56), -1.0)
	monster.create_effect_1("火炎弾発動")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	motion.wait_until_progress(vm.f32(0.6), -1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol2")
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.get_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	monster.create_effect_1("火炎弾ループ")
	monster.set_effect_first_vector(-1, position_x, position_y, position_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack)
	monster.set_motion("攻撃２", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 4)
	timer.wait_frames_with_guard_update(10)
end

--- Rushes forward with the sword slash attack.
local function slash_while_rushing()
	monster.set_motion("攻撃１", -1, 2)
	movement.rush_forward_guarded(2.5, 4.0, 1.0, calc.pass_through(42))
	motion.wait_until_finished_guarded()
end

--- Picks an attack or approach when the target is at far range.
local function act_at_far_range()
	local random_value: s32 = 0
	local reached_point: s32 = 0
	local side_angle_degrees: f32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 80 then
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_toward_target_with_offset_guarded(4.0, 15.0, 15)
		cast_fireball()
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames_with_guard_update(3)
	elseif random_value < 70 then
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_toward_target_and_wait_guarded(4.0)
		monster.set_motion("歩き", -1.0, 0)
		movement.chase_target_guarded(vm.f32(5.6), vm.f32(5.2), 30.0, 30)
	else
		monster.get_random(100, random_value)
		monster.get_random_whole_number(30.0, side_angle_degrees)
		if random_value < 50 then
			side_angle_degrees = vm.f32(-side_angle_degrees - 30.0)
		else
			side_angle_degrees = vm.f32(side_angle_degrees + 30.0)
		end
		monster.set_motion("歩き", -1.0, 0)
		reached_point = movement.walk_to_point_near_target(1.5, vm.f32(5.2), side_angle_degrees, 70.0, 35.0, 40)
		movement.turn_toward_target_and_wait_guarded(4.0)
		if reached_point == 1 then
			slash_while_rushing()
		end
	end
end

--- Picks a fireball, slash or approach when the target is at medium range.
local function act_at_medium_range()
	local random_value: s32 = 0
	local reached_point: s32 = 0
	local side_angle_degrees: f32 = 0
	random_value = monster.get_random(100) or random_value
	if random_value < 70 then
		random_value = monster.get_random(100) or random_value
		if random_value < 70 then
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_with_offset_guarded(4.0, 12.5, 15)
			cast_fireball()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(3)
		else
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_with_offset_guarded(4.0, 10.0, 15)
			slash_while_rushing()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(3)
		end
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 35 then
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			monster.set_motion("歩き", -1.0, 0)
			movement.chase_target_guarded(vm.f32(5.6), 4.0, 35.0, 90)
		else
			random_value = monster.get_random(100) or random_value
			if random_value < 85 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				monster.set_motion("歩き", -1.0, 0)
				movement.chase_target_guarded(vm.f32(5.6), 4.0, 35.0, 90)
			else
				monster.get_random(100, random_value)
				monster.get_random_whole_number(30.0, side_angle_degrees)
				if random_value < 50 then
					side_angle_degrees = vm.f32(-side_angle_degrees - 30.0)
				else
					side_angle_degrees = vm.f32(side_angle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				reached_point = movement.walk_to_point_near_target(1.5, vm.f32(5.2), side_angle_degrees, 70.0, 35.0, 40)
				movement.turn_toward_target_and_wait_guarded(4.0)
				if reached_point == 1 then
					slash_while_rushing()
				end
			end
		end
	end
end

--- Picks an attack, retreat or strafe when the target is at melee range.
local function act_at_melee_range()
	local random_value: s32 = 0
	local side_angle_degrees: f32 = 0
	local distance: f32 = 0
	monster.get_life_int()
	random_value = monster.get_random(100) or random_value
	if random_value < 80 then
		random_value = monster.get_random(100) or random_value
		if random_value < 15 then
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			cast_fireball()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(8)
		else
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			monster.set_motion("歩き", -1.0, 0)
			movement.chase_target_guarded(vm.f32(5.6), 4.0, 35.0, 30)
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
			slash_while_rushing()
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames_with_guard_update(3)
		end
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 60 then
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(1.5)
			monster.set_motion("歩き", -1.0, 0)
			movement.move_in_direction_guarded(1.5, 180.0, 200.0, 35.0, 20)
		else
			random_value = monster.get_random(100) or random_value
			side_angle_degrees = monster.get_random_whole_number(30.0) or side_angle_degrees
			distance = monster.get_random_whole_number(30.0) or distance
			distance = vm.f32(distance + 60.0)
			if random_value < 50 then
				side_angle_degrees = vm.f32(-side_angle_degrees - 30.0)
			else
				side_angle_degrees = vm.f32(side_angle_degrees + 30.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			local _ = movement.walk_to_point_near_target(1.5, 4.0, side_angle_degrees, distance, 35.0, 30)
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_toward_target_and_wait_guarded(4.0)
		end
	end
end

--- Repeatedly chooses an attack by target distance until the target leaves range or the rage hits run out.
local function fight_target_in_range()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		behavior.try_face_transformed_player_speed_4()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 210.0 then
			reaction.update_and_wait_frame()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left <= 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			reposition_or_wait()
			continue
		end
		if target_distance < 210.0 and target_distance >= 100.0 then
			act_at_far_range()
		elseif target_distance < 100.0 and target_distance >= 60.0 then
			act_at_medium_range()
		else
			act_at_melee_range()
		end
	end
end

--- Wanders, turns or waits near the monster's home position while the target is far away.
local function roam_around_home()
	local random_value: s32 = 0
	local wait_result: s32 = 0
	local unused_state: s32 = 0
	local distance: f32 = 0
	local turn_angle_degrees: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local rotation_y: f32 = 0
	local clear_distance: f32 = 0
	local orbit_angle_degrees: f32 = 0
	local post_orbit_turn_degrees: f32 = 0
	local offset_angle_degrees: f32 = 0
	local offset_distance: f32 = 0
	local target_distance: f32 = 0
	local post_walk_turn_degrees: f32 = 0
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
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	distance = monster.get_distance_between(position_x, position_y, position_z, place_pos_x, place_pos_y, place_pos_z) or distance
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 35.0 then
		turn_angle_degrees = monster.get_random_whole_number(360.0) or turn_angle_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(turn_angle_degrees, 4.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 35.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(4.0, 1.5, turn_angle_degrees, clear_distance, 35.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if distance > 300.0 then
		random_value = monster.get_random(100) or random_value
		if random_value < 90 then
			if distance > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				monster.set_place_position(position_x, position_y, position_z)
			end
			random_value = monster.get_random(100) or random_value
			if random_value < 30 then
				monster.set_variable(0, 4)
				random_value = monster.get_random(100) or random_value
				orbit_angle_degrees = monster.get_random_whole_number(360.0) or orbit_angle_degrees
				distance = monster.get_random_whole_number(150.0) or distance
				if random_value < 50 then
					orbit_angle_degrees = vm.f32(-orbit_angle_degrees - 30.0)
				else
					orbit_angle_degrees = vm.f32(orbit_angle_degrees + 30.0)
				end
				monster.set_motion("歩き", -1.0, 0)
				movement.walk_around_position_guarded(place_pos_x, place_pos_y, place_pos_z, 1.5, 4.0, distance, orbit_angle_degrees, 35.0, 60)
				post_orbit_turn_degrees = monster.get_random_whole_number(180.0) or post_orbit_turn_degrees
				random_value = monster.get_random(100) or random_value
				if random_value < 50 then
					post_orbit_turn_degrees = vm.f32(post_orbit_turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(post_orbit_turn_degrees, 4.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
			monster.get_random(100, random_value)
			return
		end
	end
	random_value = monster.get_random(100) or random_value
	if random_value < 65 then
		random_value = monster.get_random(100) or random_value
		if random_value < 80 then
			monster.set_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			turn_angle_degrees = monster.get_random_whole_number(180.0) or turn_angle_degrees
			random_value = monster.get_random(100) or random_value
			if random_value < 50 then
				turn_angle_degrees = vm.f32(turn_angle_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(turn_angle_degrees, 4.0)
			monster.set_motion("立ち", -1, 0)
		end
	else
		random_value = monster.get_random(100) or random_value
		if random_value < 50 then
			random_value = monster.get_random(100) or random_value
			if random_value < 50 then
				random_value = monster.get_random(100) or random_value
				if random_value < 50 then
					monster.set_variable(0, 4)
					random_value = monster.get_random(100) or random_value
					offset_angle_degrees = monster.get_random_whole_number(180.0) or offset_angle_degrees
					offset_distance = monster.get_random_whole_number(30.0) or offset_distance
					target_distance = monster.get_target_distance() or target_distance
					offset_distance = vm.f32(offset_distance + target_distance)
					if random_value < 50 then
						offset_angle_degrees = vm.f32(offset_angle_degrees * -1.0)
					end
					random_value = monster.get_random(100) or random_value
					if random_value < 50 then
						offset_angle_degrees = vm.f32(-offset_angle_degrees - 30.0)
					else
						offset_angle_degrees = vm.f32(offset_angle_degrees + 30.0)
					end
					monster.set_motion("歩き", -1.0, 0)
					wait_result = movement.walk_to_point_near_target(1.5, 4.0, offset_angle_degrees, offset_distance, 35.0, 60)
					post_walk_turn_degrees = monster.get_random_whole_number(360.0) or post_walk_turn_degrees
					random_value = monster.get_random(100) or random_value
					if random_value < 50 then
						post_walk_turn_degrees = vm.f32(post_walk_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(post_walk_turn_degrees, 4.0)
					monster.set_motion("立ち", -1, 0)
				else
					monster.set_variable(0, 32)
					monster.set_motion("歩き", -1.0, 0)
					do
						local _, out2, _ = monster.get_rotation()
						rotation_y = out2 or rotation_y
					end
					turn_angle_degrees = calc.radians_to_degrees(rotation_y)
					if turn_angle_degrees > vm.f32(3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees - vm.f32(6.2831855))
					end
					if turn_angle_degrees <= vm.f32(-3.1415927) then
						turn_angle_degrees = vm.f32(turn_angle_degrees + vm.f32(6.2831855))
					end
					movement.move_in_direction_guarded(1.5, turn_angle_degrees, 1000.0, 35.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				wait_result = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if wait_result == 1 then
					return
				end
			end
		elseif unused_state == 8 then
			monster.set_variable(0, 1)
			random_value = monster.get_random(120) or random_value
			distance = monster.get_target_distance() or distance
			random_value = vm.i32(random_value + 15)
			monster.set_motion("歩き", -1.0, 0)
			movement.wander(1.5, 4.0, distance, 360.0, 40.0, 35.0, random_value)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Chases the target while guarding and sometimes casts a fireball when it arrives.
local function approach_and_cast_fireball()
	local random_value: s32 = 0
	monster.set_motion("歩き", -1.0, 0)
	movement.turn_toward_target_and_wait_guarded(4.0)
	monster.set_motion("歩き", -1.0, 0)
	movement.chase_target_guarded(vm.f32(5.6), 4.0, 30.0, 60)
	random_value = monster.get_random(100) or random_value
	if random_value < 70 then
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_toward_target_and_wait_guarded(4.0)
		cast_fireball()
	end
end

--- Fights the target with a different attack mix once no rage hits are left.
local function fight_without_rage_hits()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local random_value: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 210.0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 1 then
			random_value = monster.get_random(100) or random_value
			if random_value < 50 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(1.5)
				monster.set_motion("歩き", -1.0, 0)
				movement.move_in_direction_guarded(vm.f32(5.6), 180.0, 200.0, 30.0, 90)
			end
			continue
		end
		if target_distance < 210.0 and target_distance >= 100.0 then
			random_value = monster.get_random(100) or random_value
			if random_value < 50 then
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_with_offset_guarded(8.0, 30.0, 15)
				cast_fireball()
			else
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				monster.set_motion("歩き", -1.0, 0)
				movement.rush_forward_guarded(3.0, 4.0, 30.0, 30)
			end
		else
			random_value = monster.get_random(100) or random_value
			if random_value < 90 then
				random_value = monster.get_random(100) or random_value
				if random_value < 35 then
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_and_wait_guarded(8.0)
					cast_fireball()
				else
					monster.set_motion("歩き", -1.0, 0)
					movement.turn_toward_target_and_wait_guarded(8.0)
					slash_while_rushing()
				end
			else
				monster.set_motion("歩き", -1.0, 0)
				movement.turn_toward_target_and_wait_guarded(4.0)
				monster.set_motion("歩き", -1.0, 0)
				movement.rush_forward_guarded(vm.f32(5.6), 4.0, 30.0, 30)
			end
		end
		reaction.update_and_wait_frame()
	end
end

--- Picks the monster's behavior from its guard state and the distance to the target.
local function choose_action()
	local target_distance: f32 = 0
	local guard_distance: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.try_face_transformed_player_speed_4()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			monster.set_defense_rate(1.0)
			if target_distance < 210.0 then
				fight_target_in_range()
			else
				roam_around_home()
			end
		else
			guard_distance = state.get_secondary_float(guard_distance)
			if target_distance < guard_distance then
				if target_distance < 100.0 then
					reaction.set_guard_active(0)
					fight_target_in_range()
				else
					approach_and_cast_fireball()
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

--- Registers the Nikapous hit boxes, loads its effect scripts and applies its default settings.
function script.init()
	local texture_block: s32 = 0
	local launch_effect_loaded: s32 = 0
	local loop_effect_loaded: s32 = 0
	local hit_effect_loaded: s32 = 0
	monster.register_damage_hit("敵基本１", 1.5, "攻撃１", 0.3, 0.7, 0)
	monster.register_damage_hit("敵基本１", 1.5, "攻撃１", 0.3, 0.8, 1)
	monster.register_damage_hit("敵基本１", 1.5, "攻撃１", 0.2, 0.6, 3)
	monster.register_damage_hit("敵基本１", 1.5, "攻撃１", 0.3, 0.7, 4)
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		launch_effect_loaded = monster.load_effect_script("火炎弾発動", texture_block) or launch_effect_loaded
		loop_effect_loaded = monster.load_effect_script("火炎弾ループ", texture_block) or loop_effect_loaded
		hit_effect_loaded = monster.load_effect_script("火炎弾ヒット", texture_block) or hit_effect_loaded
		if (if (if launch_effect_loaded ~= 0 then 1 else loop_effect_loaded) ~= 0 then 1 else hit_effect_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.add_sword_trail(0, "攻撃１", 0.4, 0.41, "dcol3", "dcol0", 45, 20, 30)
	monster.add_sword_trail(1, "攻撃１", 0.25, 0.27, "dcol4", "dcol1", 30, 20, 20)
	configure_guard_and_clip()
end

--- Runs the Nikapous fighting and roaming behavior every frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
		choose_action()
	end
end

--- Freezes the monster in a damage pose until its status ailments clear.
function script.on_status_hit()
	local has_ailment: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	has_ailment = 1
	while has_ailment ~= 0 do
		has_ailment = monster.get_status_ailments(40) or has_ailment
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the flinch reaction when the monster takes a staggering hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knock-down and get-up sequence when the monster is blown over.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished_guarded()
	monster.set_action_status(1)
	timer.wait_frames_with_guard_update(45)
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
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("ガードout", -1, 2)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Is intentionally empty so the monster has no first dodge reaction.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Is intentionally empty so the monster has no second dodge reaction.
function script.on_dodge_2() end

--- Plays the death motion and the death effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Plays the struggling motion while the monster is held.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		reaction.update_and_wait_frame()
	end
end

--- Recovers the monster and stands it back up after it lands from a throw.
function script.on_land()
	reaction.recover_from_throw()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames_with_guard_update(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	state.do_nothing_hook()
	return 1
end

--- Knocks the monster down and keeps it stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished_guarded()
	reaction.stun_until_recovered()
end

return script
