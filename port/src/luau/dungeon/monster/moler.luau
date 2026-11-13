--!strict
--- Behaviour for the Moler family, a burrowing monster that dashes at the target and fires curse bullets.

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

--- Strafes beside the target or waits in front of it.
local function act_passively()
	local roll: s32 = 0
	local side_offset: f32 = 0
	local distance: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			side_offset = monster.get_random_whole_number(30.0) or side_offset
			distance = monster.get_random_whole_number(30.0) or distance
			distance = vm.f32(distance + 110.0)
			if roll < 50 then
				side_offset = vm.f32(-side_offset - 30.0)
			else
				side_offset = vm.f32(side_offset + 30.0)
			end
			monster.set_monster_attributes(1, 1)
			monster.set_motion("歩き", -1, 0)
			local _ = movement.walk_to_point_near_target(2.0, 5.0, side_offset, distance, 25.0, 30)
			movement.turn_toward_target_and_wait_guarded(5.0)
			monster.set_motion("立ち", -1, 0)
			monster.set_monster_attributes(1, 0)
		else
			monster.set_motion("立ち", -1, 0)
			sense.wait_until_target_in_front(25.0, 45.0, 30)
		end
	end
end

--- Turns to a random heading and dashes forward while untargetable.
local function dash_in_random_direction()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local heading_degrees: f32 = 0
	heading_degrees = vm.bits_float(monster.get_random(360.0)) or heading_degrees
	monster.set_motion("歩き", -1, 0)
	movement.turn_to_angle_and_wait(heading_degrees, 5.0)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("攻撃１", -1, 6)
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, out3 = monster.get_rotation()
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(rotation_y) * 200.0))
	pos_y = vm.f32(pos_y - 20.0)
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(rotation_z) * 200.0))
	monster.move_toward_position(pos_x, pos_y, pos_z, 4.5, 4.5)
	timer.wait_frames_with_guard_update(calc.pass_through(13))
	monster.stop_moving()
	timer.wait_frames_with_guard_update(calc.pass_through(16))
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Fires a curse bullet at the target.
local function cast_curse_bullet()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local attack_power: s32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(5.0)
	monster.set_motion("攻撃２", -1, 6)
	movement.turn_until_motion_progress(5.0, vm.f32(0.42), -1.0)
	do
		local out1, out2, out3 = monster.get_frame_position("dcol0")
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
	attack_power = monster.get_attack_power_1() or attack_power
	monster.create_effect_1("呪い弾Ｆ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack_power)
	motion.wait_until_progress(vm.f32(0.455), -1.0)
	monster.create_effect_1("呪い弾Ｌ")
	monster.set_effect_first_vector(-1, pos_x, pos_y, pos_z)
	monster.set_effect_second_vector(-1, rotation_x, rotation_y, rotation_z)
	monster.set_effect_value(-1, 0, attack_power)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Rushes, waits, dashes or strafes while the target is at long range.
local function act_at_long_range()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 80 then
		roll = monster.get_random(100) or roll
		if roll < 50 then
			roll = monster.get_random(100) or roll
			if roll < 20 then
				monster.set_monster_attributes(1, 1)
				monster.set_motion("歩き", -1, 0)
				movement.rush_forward_guarded(2.0, 5.0, 25.0, 60)
				monster.set_motion("立ち", -1, 0)
				monster.set_monster_attributes(1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				sense.wait_until_target_in_front(25.0, 45.0, 75)
			end
		elseif roll < 30 then
			monster.set_monster_attributes(1, 1)
			monster.set_motion("走り", -1, 0)
			movement.rush_forward_guarded(3.0, 5.0, 25.0, 60)
			monster.set_motion("立ち", -1, 0)
			monster.set_monster_attributes(1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 65 then
				dash_in_random_direction()
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					strafe_angle_degrees = -30.0
				else
					strafe_angle_degrees = 30.0
				end
				monster.set_monster_attributes(1, 1)
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(5.0)
				monster.set_motion("歩き", -1, 0)
				movement.move_to_point_around_target_keeping_facing(2.0, strafe_angle_degrees, 110.0, 45)
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(5.0)
				monster.set_motion("立ち", -1, 0)
				monster.set_monster_attributes(1, 0)
				sense.wait_until_target_in_front(25.0, 45.0, 30)
			end
		end
	else
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(5.0)
		cast_curse_bullet()
		monster.set_motion("立ち", -1, 0)
	end
end

--- Turns toward the target and dashes forward while untargetable.
local function dash_toward_target()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local dash_heading: f32 = 0
	monster.set_motion("歩き", -1, 0)
	movement.turn_toward_target_and_wait_guarded(10.0)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_motion("攻撃１", -1, 6)
	timer.wait_frames_with_guard_update(2)
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	dash_heading = rotation_y
	if dash_heading > vm.f32(3.1415927) then
		dash_heading = vm.f32(dash_heading - vm.f32(6.2831855))
	end
	if dash_heading <= vm.f32(-3.1415927) then
		dash_heading = vm.f32(dash_heading + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(dash_heading)))
	pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(dash_heading)))
	monster.move_toward_position(pos_x, pos_y - 20.0, pos_z, 7.5, 7.5)
	timer.wait_frames_with_guard_update(calc.pass_through(13))
	monster.stop_moving()
	timer.wait_frames_with_guard_update(calc.pass_through(16))
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(9)
end

--- Dashes, fires a curse bullet, rushes or strafes while the target is at medium range.
local function act_at_mid_range()
	local roll: s32 = 0
	local strafe_angle_degrees: f32 = 0
	roll = monster.get_random(100) or roll
	if roll < 65 then
		roll = monster.get_random(100) or roll
		if roll < 25 then
			dash_toward_target()
		else
			cast_curse_bullet()
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 15 then
			monster.set_monster_attributes(1, 1)
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward_guarded(2.0, 5.0, 25.0, 90)
			monster.set_motion("立ち", -1, 0)
			monster.set_monster_attributes(1, 0)
		else
			roll = monster.get_random(100) or roll
			if roll < 50 then
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(5.0)
				monster.set_motion("立ち", -1, 0)
				timer.wait_frames_with_guard_update(30)
			else
				roll = monster.get_random(100) or roll
				if roll < 50 then
					strafe_angle_degrees = -30.0
				else
					strafe_angle_degrees = 30.0
				end
				monster.set_monster_attributes(1, 1)
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(5.0)
				monster.set_motion("歩き", -1, 0)
				movement.move_to_point_around_target_keeping_facing(2.0, strafe_angle_degrees, 110.0, 45)
				monster.set_motion("歩き", -1, 0)
				movement.turn_toward_target_and_wait_guarded(5.0)
				monster.set_motion("立ち", -1, 0)
				monster.set_monster_attributes(1, 0)
				sense.wait_until_target_in_front(25.0, 45.0, 30)
			end
		end
	end
end

--- Dashes toward the target several times in a row.
local function repeat_dash_toward_target(dash_count: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rotation_y: f32 = 0
	local dash_heading: f32 = 0
	for index = 0, dash_count - 1 do
		monster.set_motion("歩き", -1, 0)
		movement.turn_toward_target_and_wait_guarded(10.0)
		monster.set_motion("攻撃１", -1, 6)
		timer.wait_frames_with_guard_update(2)
		do
			local _, out2, _ = monster.get_rotation()
			rotation_y = out2 or rotation_y
		end
		do
			local out1, out2, out3 = monster.get_position_3()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		dash_heading = rotation_y
		if dash_heading > vm.f32(3.1415927) then
			dash_heading = vm.f32(dash_heading - vm.f32(6.2831855))
		end
		if dash_heading <= vm.f32(-3.1415927) then
			dash_heading = vm.f32(dash_heading + vm.f32(6.2831855))
		end
		pos_x = vm.f32(pos_x + vm.f32(100.0 * vm.sin(dash_heading)))
		pos_z = vm.f32(pos_z + vm.f32(100.0 * vm.cos(dash_heading)))
		monster.move_toward_position(pos_x, pos_y, pos_z, 4.5, 4.5)
		timer.wait_frames_with_guard_update(calc.pass_through(13))
		monster.stop_moving()
		timer.wait_frames_with_guard_update(calc.pass_through(16))
	end
	monster.set_motion("立ち", -1, 0)
	timer.wait_frames_with_guard_update(vm.f32(vm.f32(5.4) * dash_count))
end

--- Picks a dash, rush or strafe while the target is close.
local function attack_at_close_range()
	local roll: s32 = 0
	local side_angle_degrees: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		roll = monster.get_random(100) or roll
		if roll < 80 then
			dash_toward_target()
		else
			roll = monster.get_random(2) or roll
			repeat_dash_toward_target(vm.i32(roll + 1))
		end
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_monster_attributes(1, 1)
			monster.set_motion("歩き", -1, 0)
			movement.rush_forward_guarded(2.0, 5.0, 25.0, 60)
			monster.set_motion("立ち", -1, 0)
			monster.set_monster_attributes(1, 0)
		else
			roll = monster.get_random(100) or roll
			side_angle_degrees = monster.get_random_whole_number(60.0) or side_angle_degrees
			if roll < 50 then
				side_angle_degrees = vm.f32(-side_angle_degrees - 30.0)
			else
				side_angle_degrees = vm.f32(side_angle_degrees + 30.0)
			end
			monster.set_monster_attributes(1, 1)
			monster.set_motion("歩き", -1, 0)
			movement.walk_to_point_near_target(2.0, 5.0, side_angle_degrees, 50.0, 1.0, 25)
			movement.turn_toward_target_and_wait_guarded(5.0)
			monster.set_motion("立ち", -1, 0)
			monster.set_monster_attributes(1, 0)
			timer.wait_frames_with_guard_update(9)
		end
	end
end

--- Fights the target by distance each frame until it moves away or no rage hits remain.
local function fight_with_rage_hits_left()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		reaction.update_and_wait_frame()
		behavior.try_face_transformed_player_speed_5()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 280.0 then
			reaction.update_and_wait_frame()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			reaction.update_and_wait_frame()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 3 then
			act_passively()
			continue
		end
		if target_distance < 280.0 and target_distance >= 160.0 then
			act_at_long_range()
		elseif target_distance < 160.0 and target_distance >= 110.0 then
			act_at_mid_range()
		else
			attack_at_close_range()
		end
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
	distance_from_home = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or distance_from_home
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
	if clear_distance < 25.0 then
		heading_degrees = monster.get_random_whole_number(360.0) or heading_degrees
		monster.set_motion("歩き", -1.0, 0)
		movement.turn_to_angle_and_wait(heading_degrees, 5.0)
		clear_distance = monster.get_clear_distance(100.0, 0.0) or clear_distance
		clear_distance = vm.f32(clear_distance - 25.0)
		if clear_distance > 0.0 then
			movement.turn_and_move_in_direction_guarded(5.0, 2.0, heading_degrees, clear_distance, 25.0, 30)
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
				movement.walk_around_position_guarded(place_pos_x, place_pos_y, place_pos_z, 2.0, 5.0, distance_from_home, orbit_degrees, 25.0, 60)
				turn_degrees = monster.get_random_whole_number(180.0) or turn_degrees
				roll = monster.get_random(100) or roll
				if roll < 50 then
					turn_degrees = vm.f32(turn_degrees * -1.0)
				end
				movement.turn_to_angle_and_wait(turn_degrees, 5.0)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				is_target_threatening = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
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
			sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			monster.set_variable(0, 16)
			heading_degrees = monster.get_random_whole_number(180.0) or heading_degrees
			roll = monster.get_random(100) or roll
			if roll < 50 then
				heading_degrees = vm.f32(heading_degrees * -1.0)
			end
			monster.set_motion("歩き", -1.0, 0)
			movement.turn_to_angle_and_wait(heading_degrees, 5.0)
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
					is_target_threatening = movement.walk_to_point_near_target(2.0, 5.0, orbit_angle_degrees, orbit_radius, 25.0, 60)
					final_turn_degrees = monster.get_random_whole_number(360.0) or final_turn_degrees
					roll = monster.get_random(100) or roll
					if roll < 50 then
						final_turn_degrees = vm.f32(final_turn_degrees * -1.0)
					end
					movement.turn_to_angle_and_wait(final_turn_degrees, 5.0)
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
					movement.move_in_direction_guarded(2.0, heading_degrees, 1000.0, 25.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				is_target_threatening = sense.wait_until_target_threatening_guarded(100.0, 50.0, 35.0, vm.f32(1.2), 30)
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
			movement.wander(2.0, 5.0, distance_from_home, 360.0, 40.0, 25.0, roll)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Turns toward the target and dashes at it or fires a curse bullet.
local function turn_and_attack()
	local roll: s32 = 0
	monster.set_motion("歩き", -1.0, 0)
	movement.turn_toward_target_and_wait_guarded(5.0)
	roll = monster.get_random(100) or roll
	if roll < 90 then
		dash_toward_target()
	else
		cast_curse_bullet()
	end
end

--- Fights the target by distance each frame until rage hits are available.
local function fight_without_rage_hits()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local rage_hits_left: s32 = 0
	local strafe_angle_degrees: f32 = 0
	monster.get_life_int()
	while true do
		reaction.update_and_wait_frame()
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
		if target_distance < 110.0 then
			roll = monster.get_random(100) or roll
			if roll < 60 then
				dash_toward_target()
			else
				roll = monster.get_random(4) or roll
				repeat_dash_toward_target(vm.i32(roll + 1))
			end
		else
			roll = monster.get_random(100) or roll
			if roll < 80 then
				cast_curse_bullet()
			else
				roll = monster.get_random(100) or roll
				if roll < 90 then
					monster.set_monster_attributes(1, 1)
					monster.set_motion("走り", -1, 0)
					movement.rush_forward_guarded(3.0, 5.0, 25.0, 60)
					monster.set_motion("立ち", -1, 0)
					monster.set_monster_attributes(1, 0)
				else
					roll = monster.get_random(100) or roll
					if roll < 50 then
						strafe_angle_degrees = -30.0
					else
						strafe_angle_degrees = 30.0
					end
					monster.set_monster_attributes(1, 1)
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(5.0)
					monster.set_motion("歩き", -1, 0)
					movement.move_to_point_around_target_keeping_facing(2.0, strafe_angle_degrees, 110.0, 45)
					monster.set_motion("歩き", -1, 0)
					movement.turn_toward_target_and_wait_guarded(5.0)
					monster.set_motion("立ち", -1, 0)
					monster.set_monster_attributes(1, 0)
					sense.wait_until_target_in_front(25.0, 45.0, 30)
				end
			end
		end
	end
end

--- Picks the fighting, roaming or guarding behaviour from the rage state, guard state and target distance.
local function update_behavior()
	local target_distance: f32 = 0
	local guard_range: f32 = 0
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left > 0 then
		behavior.try_face_transformed_player_speed_5()
		target_distance = monster.get_target_distance() or target_distance
		if reaction.is_guard_active() == 0 then
			if target_distance < 280.0 then
				fight_with_rage_hits_left()
			else
				wander_while_unengaged()
			end
		else
			guard_range = state.get_secondary_float(guard_range)
			if target_distance < guard_range then
				if target_distance < 110.0 then
					reaction.set_guard_active(0)
					fight_with_rage_hits_left()
				else
					turn_and_attack()
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

--- Does nothing; the monster needs no load-time setup.
function script.setup() end

--- Registers the dash attack, photo pose and curse bullet effects when the monster is placed.
function script.init()
	local texture_block: s32 = 0
	local bullet_front_loaded: s32 = 0
	local bullet_launch_loaded: s32 = 0
	local bullet_hit_loaded: s32 = 0
	local grade: s32 = 0
	monster.register_damage_hit("吹っ飛び攻撃", 7.0, "攻撃１", 0.06, 0.45, 1)
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		bullet_front_loaded = monster.load_effect_script("呪い弾Ｆ", texture_block) or bullet_front_loaded
		bullet_launch_loaded = monster.load_effect_script("呪い弾Ｌ", texture_block) or bullet_launch_loaded
		bullet_hit_loaded = monster.load_effect_script("呪い弾Ｈ", texture_block) or bullet_hit_loaded
		if (if (if bullet_front_loaded ~= 0 then 1 else bullet_launch_loaded) ~= 0 then 1 else bullet_hit_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("攻撃１", 0.12, 0.45, 1022)
	end
	configure_defaults()
end

--- Runs the behaviour update every frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		reaction.update_and_wait_frame()
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
		reaction.update_and_wait_frame()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers and recovers after a normal hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_monster_attributes(1, 0)
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knockdown, lies on the ground and gets back up.
function script.on_knockdown()
	state.lock_and_face_target_guarded()
	monster.set_monster_attributes(1, 0)
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished_guarded()
	timer.wait_frames_with_guard_update(12)
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Raises a guard against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_monster_attributes(1, 0)
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Raises a guard.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	monster.set_monster_attributes(1, 0)
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Raises a guard.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.set_monster_attributes(1, 0)
	monster.reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames_with_guard_update(8)
	monster.set_motion("ガードout", -1, 6)
	motion.wait_until_finished_guarded()
	monster.set_motion("立ち")
	state.unlock()
end

--- Plays the death animation and effects.
function script.on_death()
	death.begin()
	monster.set_monster_attributes(1, 0)
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the empty handler stops the engine's default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the empty handler stops the engine's default.
function script.on_land() end

--- Plays the stun recovery.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 4)
	timer.wait_frames_with_guard_update(3)
	reaction.stun_until_recovered()
end

return script
